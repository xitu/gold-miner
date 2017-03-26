> * 原文地址：[How to build a reactive engine in JavaScript. Part 2: Computed properties and dependency tracking](https://monterail.com/blog/2017/computed-properties-javascript-dependency-tracking)
> * 原文作者：[Damian Dulisz](https://disqus.com/by/damiandulisz/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[IridescentMia](https://github.com/IridescentMia)
> * 校对者：

![](https://d4a7vd7s8p76l.cloudfront.net/uploads/56873733-c918-4cd6-bac1-dea44dcc3a9f/Reactive%20engine.png)

# [How to build a reactive engine in JavaScript. Part 2: Computed properties and dependency tracking](/blog/2017/computed-properties-javascript-dependency-tracking/) #
# 如何使用 JavaScript 构建响应式引擎 —— Part 2：计算属性和依赖追踪 #

Hey! If you have ever worked with Vue.js, Ember or MobX I’m pretty sure you stumbled upon so-called **computed** properties. They allow you to create functions that can be accessed just like normal values, but once computed they are cached until one of its dependencies has changed. In general this is a concept very similar to getters and in fact, the following implementation will be using getters. In a smart way. ;)
Hey！如果你用过 Vue.js、Ember 或 MobX，我敢肯定你被 **计算** 属性难倒过。计算属性允许你创建像正常的值一样使用的函数，但是一旦完成计算，他们就被缓存下来直到它的一个依赖发生改变。总的来说，这一概念与 getters 非常相似，并且事实上，下面的实现将会使用 getters。用一种机智的方式。 ;)

> This is the 2nd part of the How to build a reactive engine in JavaScript series. Before reading any further it is highly recommended to read [Part 1: Observable objects](https://monterail.com/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects), because the following implementation is built on top of the previous article's code.
> 这是如何使用 JavaScript 构建响应式引擎系列文章的第二部分。在深入阅读前强烈建议读一下 [Part 1： 可观察的对象](https://monterail.com/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects)，因为接下来的实现是构建于前一篇文章的代码基础之上的。

## Computed properties ##
## 计算属性 ## 

Let’s say we have a computed property called `fullName` which is a combination of `firstName` and `lastName` with space in between.
假设有一个计算属性叫 `fullName`，是 `firstName` 和 `lastName` 之间加上空格的组合。

In Vue.js such a computed value could be created like this:
在 Vue.js 中这样的计算值可以像下面这样创建：

```
data: {
  firstName: 'Cloud',
  lastName: 'Strife'
},
computed: {
  fullName () {
    return this.firstName + ' ' + this.lastName // 'Cloud Strife'
  }
}
```

Now if we use the `fullName` somewhere in our template, we expect it will be updated whenever `firstName` or `lastName` change. If you come from an AngularJS background you might also remember using expressions inside the template or function calls. Of course, this works the same when using render functions (with JSX or not); it doesn’t really matter.
现在如果在模板中使用 `fullName`，我们希望它能随着 `firstName` 或 `lastName` 的改变而更新。如果你有使用 AngularJS 的背景，你可能还记得在模板或者函数调用内使用表达式。当然了，使用渲染函数（使用 JSX 或者不使用）的时候和这里是一样的；其实这无关紧要。

Let’s consider the following example:
来看一下下面的例子：

```
<!-- expression -->
<!-- 表达式 -->
<h1>{{ firstName + ' ' + lastName }}</h1>
<!-- function call -->
<!-- 函数调用 -->
<h2>{{ getFullName() }}</h2>
<!-- computed property -->
<!-- 计算属性 -->
<h3>{{ fullName }}</h3>
```

The result of the above code will be mostly the same. Each time `firstName` or `lastName` changes, the view will update with the headers and show the full name.
上面代码的执行结果几乎是一样的。每次 `firstName` 或 `lastName` 发生变化，视图将会更新这些 `<h>` 并且显示出全名。

However, what if we use the expression, method call and computed property multiple times? The expression and method call will have to be calculated each time they are accessed, whereas the computed property will be cached after the first computation until one of its dependencies change. It will also persist through the re-render cycles! That’s actually quite a nice optimization if you consider that in event-based modern user interfaces, it’s hard to predict which action the user will take first.
然而，如果多次使用表达式、函数调用和计算属性呢？使用表达式和函数调用每次都会计算一遍，而计算属性在第一次计算后将会缓存下来，直到它的依赖发生改变。它也会在重新渲染的循环中一直保持！如果考虑在基于事件模型的用户界面中，很难预测用户会首先执行哪项操作，那么这确实是一个最优化方案。

## Basic computed property ##
## 基础的计算属性 ##

In the previous article, we learned how to track and react to changes inside observable object properties by utilizing an event emitter. We know that when we change the `firstName` it will call all the handlers that subscribed to the `’firstName’` event. Thus it is quite easy to build a computed property by manually subscribing to its dependencies.
This is actually how Ember does it:
在前面文章中，我们学习了如何通过使用事件发射器追踪和响应可观察对象内的改变。我们知道当改变 `firstName` 时，会调用所有的订阅了 `’firstName’` 事件的处理器。因此通过手动订阅它的依赖来构建计算属性是相当容易的。
这也是 Ember 实现它的方式：

```
fullName: Ember.computed('firstName', 'lastName', function() {
  return this.get('firstName') + ' ' + this.get('lastName')
})
```

The drawback here is that you have to declare the dependencies yourself. Doesn’t seem like a problem until you have computed properties that are a result of a chain of more expensive, complex functions. For example:
这样做的缺点就是你不得不自己声明依赖。当你的计算属性是一串高开销的、复杂的函数的时候，你就知道这的确是个问题了。例如：

```
selectedTransformedList: Ember.computed('story', 'listA', 'listB', 'listC', function() {
  switch (this.story) {
    case 'A':
      return expensiveTransformation(this.listA)
    case 'B':
      return expensiveTransformation(this.listB)
    default:
      return expensiveTransformation(this.listC)
  }
})
```

In the above case, even if `this.story` always equals `’A’`, the computed property will have to be re-evaluated each time one of the lists changes. Even if they are not used for the end result.
在上面的案例中，即便 `this.story` 总是等于 `’A’`，一旦 lists 发生改变，计算属性也将不得不每次都反复计算。

## Dependency tracking ##
## 依赖追踪 ##

Vue.js and MobX take a different approach to this problem. The difference is, you don’t have to declare the dependencies at all because they are detected automatically each time it is evaluated. Let say `this.story = ‘A’`. The detected dependencies will be:
Vue.js 和 MobX 在解决这个问题上使用了与上文不同的方法。不同在于，你根本不必声明依赖，因为在计算的时候他们会自动地检测。假定 `this.story = ‘A’`，检测到的依赖会是：

* `this.story`
* `this.listA`

When `this.story` changes to `’B’` it will collect a fresh set of dependencies and remove the unnecessary ones (`this.listA`) that were used before but was not called anymore.
This way even if the other lists change it won’t trigger a recalculation of `selectedTransformedList`.
That’s smart!
当 `this.story` 变成 `’B’`，它将会收集一组新的依赖，并移除那些之前用而现在不再使用的多余的依赖（`this.listA`）。这样，尽管其他 lists 发生变化，也不会触发 `selectedTransformedList` 的重计算。

Now it’s a good time to look again at the [code from the previous article - JSFiddle](https://jsfiddle.net/shentao/4k0gk3bx/10/), as the following changes will be based upon that code.
现在是时候返回来看一看 [上一篇文章中的代码 - JSFiddle](https://jsfiddle.net/shentao/4k0gk3bx/10/)，下面的改动将基于这些代码。

> The code in this article is written to be as simple as possible, ignoring many sanity checks and optimizations. By no means is it production ready, as it’s the only purpose is strictly educational.

> 这篇文章中的代码尽量写的简单，忽略很多完整性检查和优化。绝不是已经可以用于生产环境的，仅仅用于教育目的。

Let’s create a new data model:
我们来创建一个新的数据模型：

```
const App = Seer({
  data: {
    // observable values
    // 可观察的值
    goodCharacter: 'Cloud Strife',
    evilCharacter: 'Sephiroth',
    placeholder: 'Choose your side!',
    side: null,
    // computed property
    // 计算属性
    selectedCharacter () {
      switch (this.side) {
        case 'Good':
          return `Your character is ${this.goodCharacter}!`
        case 'Evil':
          return `Your character is ${this.evilCharacter}!`
        default:
          return this.placeholder
      }
    },
    // computed property depending on other computed
    // 依赖其他计算属性的计算属性
    selectedCharacterSentenceLength () {
      return this.selectedCharacter.length
    }
  }
})
```

### Detecting the dependencies ###
### 检测依赖 ###

To find out the dependencies of the currently evaluated computed property, we need a way to collect the dependencies. As you know, every observable property is already transformed into a getter and setter.
When evaluating the computed property (function) it will access other properties, which will trigger their getters.
为了找到当前求值计算属性的依赖，需要一种收集依赖的办法。如你所知，每个可观察属性是已经转换成 getter 和 setter 的形式。当对计算属性（函数）求值的时候，需要用到其他的属性，也就是触发他们的 getters。

For example this function:
例如这个函数：

```
{
  fullName () {
    return this.firstName + ' ' + this.lastName
  }
}
```

will call both the `firstName` and `lastName` getters.
将会调用 `firstName` 和 `lastName` 的 getters。

Let’s make use of it!
让我们开始使用它！

We need a way to collect the information that a getter was called when evaluating a computed property. For this to work, first we need a place to store which computed property is currently being evaluated. We can use a simple object for this:
当对计算属性求值的时候，我们需要收集 getter 被调用的信息。为了完成这项工作，首先需要空间存储当前求值的计算属性。可以用这样的简单对象：

```
let Dep = {
  // Name of the currently evaluated computed value
  // 当前求值的计算属性的名字
  target: null
}
```

We used the `makeReactive` function to transform primitives into observable properties. Let’s create a transform function for computed properties and name it `makeComputed`.
我们过去曾用 `makeReactive` 函数将原始属性转换成可观察属性。现在让我们为计算属性创建一个转换函数并将它命名为 `makeComputed`。

```
function makeComputed (obj, key, computeFunc) {
  Object.defineProperty(obj, key, {
    get () {
      // If there is no target set
      // 如果没有 target 集合
      if (!Dep.target) {
        // Set the currently evaluated property as the target
        // 设置 target 为当前求值的属性
        Dep.target = key
      }
      const value = computeFunc.call(obj)

      // Clear the target context
      // 清空 target 上下文
      Dep.target = null
      return value
    },
    set () {
      // Do nothing!
    }
  })
}

// It will be later called in this manner
// 后面将会用这种方式调用
makeComputed(data, 'fullName', data['fullName'])
```

Okay. Now that the context is available, we can modify our `makeReactive` function that we created in the previous article to make use of that context.
Okay！既然上下文可以获取了，修改上一篇文章中创建的 `makeReactive` 函数以便使用获取到的上下文。

The new `makeReactive` function should look like this:
新的 `makeReactive` 函数像下面这样：

```
function makeReactive (obj, key) {
  let val = obj[key]
  // create an empty array for storing dependencies
  // 创建空数组用来存依赖
  let deps = []

  Object.defineProperty(obj, key, {
    get () {
      // Run only when called within a computed property context
      // 只有在计算属性上下文中调用的时候才会执行
      if (Dep.target) {
        // Add the computed property as depending on this value
        // if not yet added
        // 如果还没添加，则作为依赖这个值的计算属性添加
        if (!deps.includes(Dep.target)) {
          deps.push(Dep.target)
        }
      }
      return val
    },
    set (newVal) {
      val = newVal
      // If there are computed properties
      // that depend on this value
      // 如果有依赖于这个值的计算属性
      if (deps.length) {
        // Notify each computed property observers
        // 通知每个计算属性的观察者
        deps.forEach(notify)
      }
      notify(key)
    }
  })
}
```

One last thing we need is to slightly modify our `observeData` function so that it runs `makeComputed` instead of `makeReactive` for properties that are functions.
我们要做的最后一件事就是稍稍改进 `observeData` 函数，以便对于函数形式的属性，它运行 `makeComputed` 而不是 `makeReactive`。

```
function observeData (obj) {
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      if (typeof obj[key] === 'function') {
        makeComputed(obj, key, obj[key])
      } else {
        makeReactive(obj, key)
      }
    }
  }
  parseDOM(document.body, obj)
}
```

And that’s basically it! We just created our own implementation of computed properties with dependency tracking.
基本上就是这样！我们刚刚通过依赖追踪创建了我们自己的计算属性实现。

Sadly – the above, very naive implementation still lacks some crucial that can be found in Vue.js and MobX. I guess the most important of those will be caching and removing the dead dependencies. So let’s add them.
不幸的是 —— 上面的实现是非常基础的，仍然缺少 Vue.js 和 MobX 中可以找到的重要的特性。我猜最重要的就是缓存和移除废弃的依赖。所以我们把它们添上。

## Caching ##
## 缓存 ##

First, we need to add a place to store the cache. Let’s add our cache management to the `makeComputed` function:
首先，我们需要空间存储缓存。我们在 `makeComputed` 函数中添加缓存管理器。

```
function makeComputed (obj, key, computeFunc) {
  let cache = null

  // Observe self to clear cache when deps change
  // 自观察，当 deps 改变的时候清除缓存
  observe(key, () => {
    // Clear cache
    // 清空缓存
    cache = null
  })

  Object.defineProperty(obj, key, {
    get () {
      if (!Dep.target) {
        Dep.target = key
      }

      // If not cached yet
      // 当没有缓存
      if (!cache) {
        // calculate new value and save to cache
        // 计算新的值并存入缓存
        cache = computeFunc.call(obj)
      }

      Dep.target = null
      return cache
    },
    set () {
      // Do nothing!
    }
  })
}
```

That’s it! Now each time we access our computed property after the initial computation, it will return the cached value until it has to be recalculated. Pretty straightforward, right?
就是这样！现在在初始化计算后，每次读取计算属性，它都会返回缓存的值，直到不得不重新计算。相当简单，是不是？

Thanks to the `observe` method we used inside `makeComputed` during the data transformation process, we ensure to always clean the cache before other signal handlers are executed. This means whenever one of the computed property’s dependencies change, the cache will be cleaned, just before the interface gets updated.
多亏了 `observe` 函数，在数据转换过程中我们在 `makeComputed` 内部使用，确保在其他信号处理器执行前清空缓存。这意味着，计算属性的一个依赖发生变化，缓存将被清空，刚刚好在界面更新前完成。

## Removing the unnecessary dependencies ##
## 移除不必要的依赖 ##

So now what’s left is to get rid of dependencies that are no longer valid. This is often a case when our computed properties conditionally depend on different values. What we want to achieve is our computed property only depending on the last used dependencies. The above implementation is flawed in that once a dependency registers that a computed property depends on it, it stays this way forever.
现在剩下的工作就是清理无效的依赖。当计算属性依赖于不同的值的时候通常是一个案例。我们想达到的效果是计算属性仅依赖最后使用到的依赖。上面的实现在这方面是有缺陷的，一旦计算属性登记了依赖于它，它就一直在那了。

There are probably better ways to handle this, but because we want to keep things really simple let’s just create a secondary dependency list. One that will store a computed property’s dependencies.
To sum things up, our dependency lists:
可能有更好的方式处理这种情况，但是因为我们想保持简单，我们来创建第二个依赖列表，来存储计算属性的依赖项。
总结来说，我们的依赖列表：

- List of computed property names that depend on this value (observables or other computed) stored locally. Think: **Those are the values that depend on me.**
- A secondary dependency list that is used to remove dead dependencies and stores the most recent dependencies of a computed property. Think: **Those are the values I’m depending on.**

- 依赖于这个值（可观察的或者其他的计算后的）的计算属性名列表存储在本地。可以这样想：**这些是依赖于我的值。**
- 第二个依赖列表，用来移除废弃的依赖并存储计算属性的最新的依赖。可以这样想：**这些值是我依赖的。**

With those two lists, we can run a filter function to remove the no longer valid dependencies. So let’s start with creating an object to store a secondary dependency list and some utility functions.
用这两列表，我们可以运行一个过滤函数来移除无效的依赖。让我们首先创建一个存储第二个依赖列表的对象和一些实用的函数。

```
let Dep = {
  target: null,
  // Stores the dependencies of computed properties
  // 存储计算属性的依赖
  subs: {},
  // Create a two-way dependency relation between computed properties
  // and other computed or observable values
  // 在计算属性和其他计算后的或者可观察的值之间创建双向的依赖关系
  depend (deps, dep) {
    // Add the current context (Dep.target) to local deps
    // as depending on the current property
    // if not yet added
    // 如果还没添加，则添加当前上下文（Dep.target）到本地的 deps，作为依赖于当前属性
    if (!deps.includes(this.target)) {
      deps.push(this.target)
    }
    // Add the current property as a dependency of the computed value
    // if not yet added
    // 如果还没有添加，将当前属性作为计算值的依赖加入
    if (!Dep.subs[this.target].includes(dep)) {
      Dep.subs[this.target].push(dep)
    }
  },
  getValidDeps (deps, key) {
    // Filter only valid dependencies by removing dead dependencies
    // that were not used during last computation
    // 通过移除在上一次计算中没有使用的废弃依赖，仅仅过滤出有效的依赖
    return deps.filter(dep => this.subs[dep].includes(key))
  },
  notifyDeps (deps) {
    // notify all existing deps
    // 通知所有已存在的 deps
    deps.forEach(notify)
  }
}
```

If the `Dep.depend` method doesn’t make much sense right now, wait until we use it. It should become more clear what is actually happening there.
如果 `Dep.depend` 函数现在还没什么意义，等一下我们就会用到它。这里做的什么应该就更清楚了。

First, let’s tune the `makeReactive` transform function.
首先，来调整 `makeReactive` 转换函数。

```
function makeReactive (obj, key, computeFunc) {
  let deps = []
  let val = obj[key]

  Object.defineProperty(obj, key, {
    get () {
      // Run only when getting within a computed value context
      // 只有当在计算值的上下文内时才执行
      if (Dep.target) {
        // Add Dep.target as depending on this value
        // this will mutate the deps Array
        // as we’re passing a reference to it
        // 将 Dep.target 作为依赖于这个值添加，浙江使 deps 数组发生变化，因为我们给它传了一个引用
        Dep.depend(deps, key)
      }

      return val
    },
    set (newVal) {
      val = newVal

      // Clean up dead dependencies
      // 清除废弃依赖
      deps = Dep.getValidDeps(deps, key)
      // and notify valid deps
      // 并通知有效的 deps
      Dep.notifyDeps(deps, key)

      notify(key)
    }
  })
}
```

Almost the same has to be changed inside the `makeComputed` transform function. The difference is that we won’t be using the setter but the signal handler callback we passed to the `observe` function. Why? Because this callback will be called whenever the actual computed value has to update, as its dependencies have changed.

`makeComputed` 转换函数内部也需要做相似的改动。不同在于不使用 setter 而是用传给 `observe` 函数的信号回调处理器。为什么？因为这个回调无论何时计算的值更新了，也就是依赖改变了，都会被调用。

```
function makeComputed (obj, key, computeFunc) {
  let cache = null
  // Create a local deps list similar to makeReactive deps
  // 创建一个本地的 deps 列表，相似于 makeReactive 的 deps
  let deps = []

  observe(key, () => {
    cache = null

    // Clean up and notify valid deps
    // 清空并通知有效的 deps
    deps = Dep.getValidDeps(deps, key)
    Dep.notifyDeps(deps, key)
  })

  Object.defineProperty(obj, key, {
    get () {
      // If evaluated during the evaluation of
      // another computed property
      // 如果如果在其他计算属性正在计算的时候计算
      if (Dep.target) {
        // Create a dependency relationship
        // between those two computed properties
        // 在这两个计算属性之间创建一个依赖关系
        Dep.depend(deps, key)
      }
      // Normalize Dep.target back to self
      // This makes it possible to build a dependency tree
      // instead of a flat structure
      // 将 Dep.target 标准化成它原本的样子，这使得构建一个依赖树成为可能，而不是一个扁平化的结构
      Dep.target = key

      if (!cache) {
        // Clear dependencies list to ensure getting a fresh one
        // 清空依赖列表以获得一个新的
        Dep.subs[key] = []
        cache = computeFunc.call(obj)
      }

      // Clear the target context
      // 清空目标上下文
      Dep.target = null
      return cache
    },
    set () {
      // Do nothing!
    }
  })
}
```

Done! You might have already noticed that it also enables computed properties to be dependent on other computed properties, without having to know about the observables that lie underneath. Pretty sweet, isn’t it?
完成了！你可能已经注意到，它允许计算属性依赖于其他计算属性，不需要知道背后的可观察的对象。相当不错，是不？

## Asynchronous pitfalls ##
## 异步陷阱 ##

Now that you know how dependency tracking works, it should be quite obvious why it’s not possible to track asynchronous data inside computed properties both in MobX and Vue.js. It all breaks because even a `setTimeout(callback, 0)` will be called out of the current context where `Dep.target` no longer exists. This means that whatever happens inside the callback won’t be tracked.
既然你知道了依赖追踪如何工作，也就很明显为什么在 MobX 和 Vue.js 中追踪计算属性中的异步数据是不可能的。这一切会被打破，因为即使 `setTimeout(callback, 0)` 将会在当前上下文外被调用，在那里 `Dep.target` 不在存在。这也就意味着在回调函数中无论发生什么都不会被追踪到。

## Bonus: Watchers ##
## 红利：Watchers ##

The above problem can be, however, partially tackled with watchers. You might know them from Vue.js. Building watchers on top of what we already have is actually really simple. After all, a watcher is just a signal handler called after a given value has changed.
然而，上面的问题可以通过 watchers 部分的解决。你可能已经在 Vue.js 中了解过它们。在我们已有的基础上创建 watchers 真的很容易。毕竟，watcher 是一个给定值发生变化时调用的信号处理器。

We just have to add a watchers registration method and trigger it within our Seer function.
我们只是不得不添加一个 watchers 注册方法并在 Seer 函数内触发它。

```
function subscribeWatchers(watchers, context) {
  for (let key in watchers) {
    if (watchers.hasOwnProperty(key)) {
      // We use Function.prototype.bind to bind our data model
      // as the new `this` context for our signal handler
      // 使用 Function.prototype.bind 来绑定数据模型，作为我们信号处理器新的 `this` 上下文
      observe(key, watchers[key].bind(context))
    }
  }
}

subscribeWatchers(config.watch, config.data)
```

That’s all! We can use it like this:
这就是全部了，可以像这样用它：

```
const App = Seer({
  data: {
    goodCharacter: 'Cloud Strife'
  },
  // here we can declare watchers
  // 这里可以忽略 watchers
  watch: {
    // watch for 'goodCharacter' changes
    // 'goodCharacter' 改变时的 watch
    goodCharacter () {
      // log the value into the console
      // 在控制台输出值
      console.log(this.goodCharacter)
    }
  }
}

```

The complete code is available here:
完整的代码可以在下面获得：
[https://github.com/shentao/seer/tree/cached-computed](https://github.com/shentao/seer/tree/cached-computed)

You can play with it online here (Opera/Chrome only):
你可以在线的试试它（仅支持 Opera/Chrome）：
[https://jsfiddle.net/oyw72Lyy/](https://jsfiddle.net/oyw72Lyy/)

## Summary ##
## 总结 ##

I hope you enjoyed the tutorial and that the provided explanation turned out to be good enough to bring some light into what might be happening inside Vue or MobX when using computed properties. Keep in mind that the provided implementation was meant to be quite naive and not on par with the mentioned libraries. It is also not production ready in any way.
我希望你们喜欢这个教程，当使用计算属性的时候，希望我的解释很好的阐明了 Vue 或 MobX 内部的原理。记住本文提供的实现是相当基础的，和提到的库中的实现不是同等水平的。无论如何都不是可以直接用于生产环境的。

## What comes next? ##
## 接下来讲什么？ ##

The 3rd part should include support for nested properties and observing arrays. I might also finally add a way to unsubscribe from the event bus! :D
As for the 4th part – maybe streams? Would you be interested?
第三部分涵盖了对嵌套属性和可观察数组的支持，我也可能在最后添加从事件中取消订阅的办法！ :D
至于第四部分，也许是数据流？你们感兴趣吗？

Feel free to leave your feedback in the comments!
在评论区随意反馈意见！

Thanks for reading!
感谢阅读！
