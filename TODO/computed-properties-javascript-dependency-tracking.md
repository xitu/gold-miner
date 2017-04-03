> * 原文地址：[How to build a reactive engine in JavaScript. Part 2: Computed properties and dependency tracking](https://monterail.com/blog/2017/computed-properties-javascript-dependency-tracking)
> * 原文作者：本文已获原作者 [Damian Dulisz](https://disqus.com/by/damiandulisz/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[IridescentMia](https://github.com/IridescentMia)
> * 校对者：[malcolmyu](https://github.com/malcolmyu)，[AceLeeWinnie](https://github.com/AceLeeWinnie)

![](https://d4a7vd7s8p76l.cloudfront.net/uploads/56873733-c918-4cd6-bac1-dea44dcc3a9f/Reactive%20engine.png)

# 如何使用 JavaScript 构建响应式引擎 —— Part 2：计算属性和依赖追踪 #

Hey！如果你用过 Vue.js、Ember 或 MobX，我敢肯定你被 **计算** 属性难倒过。计算属性允许你创建像正常的值一样使用的函数，但是一旦完成计算，他们就被缓存下来直到它的一个依赖发生改变。总的来说，这一概念与 getters 非常相似，实际上下面的实现也将会用到 getters。只不过实现的方式更加聪明一点。 ;)

> 这是如何使用 JavaScript 构建响应式引擎系列文章的第二部分。在深入阅读前强烈建议读一下 [Part 1： 可观察的对象](https://juejin.im/post/58dc9da661ff4b0061547ca0)，因为接下来的实现是构建于前一篇文章的代码基础之上的。

## 计算属性 ##

假设有一个计算属性叫 `fullName`，是 `firstName` 和 `lastName` 之间加上空格的组合。

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

现在如果在模板中使用 `fullName`，我们希望它能随着 `firstName` 或 `lastName` 的改变而更新。如果你有使用 AngularJS 的背景，你可能还记得在模板或者函数调用内使用表达式。当然了，使用渲染函数（不管用不用 JSX）的时候和这里是一样的；其实这无关紧要。

来看一下下面的例子：

```
<!-- 表达式 -->
<h1>{{ firstName + ' ' + lastName }}</h1>
<!-- 函数调用 -->
<h2>{{ getFullName() }}</h2>
<!-- 计算属性 -->
<h3>{{ fullName }}</h3>
```

上面代码的执行结果几乎是一样的。每次 `firstName` 或 `lastName` 发生变化，视图将会更新这些 `<h>` 并且显示出全名。

然而，如果多次使用表达式、函数调用和计算属性呢？使用表达式和函数调用每次都会计算一遍，而计算属性在第一次计算后将会缓存下来，直到它的依赖发生改变。它也会在重新渲染的周期中一直保持！如果考虑在基于事件模型的现代用户界面中，很难预测用户会首先执行哪项操作，那么这确实是一个最优化方案。

## 基础的计算属性 ##

在前面文章中，我们学习了如何通过使用事件发射器追踪和响应可观察对象属性内的改变。我们知道当改变 `firstName` 时，会调用所有的订阅了 `’firstName’` 事件的处理器。因此通过手动订阅它的依赖来构建计算属性是相当容易的。
这也是 Ember 实现计算属性的方式：

```
fullName: Ember.computed('firstName', 'lastName', function() {
  return this.get('firstName') + ' ' + this.get('lastName')
})
```

这样做的缺点就是你不得不自己声明依赖。当你的计算属性是一串高开销的、复杂的函数的运行结果时候，你就知道这的确是个问题了。例如：

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

在上面的案例中，即便 `this.story` 总是等于 `’A’`，一旦 lists 发生改变，计算属性也将不得不每次都反复计算。

## 依赖追踪 ##

Vue.js 和 MobX 在解决这个问题上使用了与上文不同的方法。不同在于，你根本不必声明依赖，因为在计算的时候他们会自动地检测。假定 `this.story = ‘A’`，检测到的依赖会是：

* `this.story`
* `this.listA`

当 `this.story` 变成 `’B’`，它将会收集一组新的依赖，并移除那些之前用而现在不再使用的多余的依赖（`this.listA`）。这样，尽管其他 lists 发生变化，也不会触发 `selectedTransformedList` 的重计算。真聪明！

现在是时候返回来看一看 [上一篇文章中的代码 - JSFiddle](https://jsfiddle.net/shentao/4k0gk3bx/10/)，下面的改动将基于这些代码。

> 这篇文章中的代码尽量写的简单，忽略很多完整性检查和优化。绝不是已经可以用于生产环境的，仅仅用于教育目的。

我们来创建一个新的数据模型：

```
const App = Seer({
  data: {
    // 可观察的值
    goodCharacter: 'Cloud Strife',
    evilCharacter: 'Sephiroth',
    placeholder: 'Choose your side!',
    side: null,
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
    // 依赖其他计算属性的计算属性
    selectedCharacterSentenceLength () {
      return this.selectedCharacter.length
    }
  }
})
```

### 检测依赖 ###

为了找到当前求值计算属性的依赖，需要一种收集依赖的办法。如你所知，每个可观察属性是已经转换成 getter 和 setter 的形式。当对计算属性（函数）求值的时候，需要用到其他的属性，也就是触发他们的 getters。

例如这个函数：

```
{
  fullName () {
    return this.firstName + ' ' + this.lastName
  }
}
```

将会调用 `firstName` 和 `lastName` 的 getters。

让我们利用这一点！

当对计算属性求值的时候，我们需要收集 getter 被调用的信息。为了完成这项工作，首先需要空间存储当前求值的计算属性。可以用这样的简单对象：

```
let Dep = {
  // 当前求值的计算属性的名字
  target: null
}
```

我们过去曾用 `makeReactive` 函数将原始属性转换成可观察属性。现在让我们为计算属性创建一个转换函数并将它命名为 `makeComputed`。

```
function makeComputed (obj, key, computeFunc) {
  Object.defineProperty(obj, key, {
    get () {
      // 如果没有 target 集合
      if (!Dep.target) {
        // 设置 target 为当前求值的属性
        Dep.target = key
      }
      const value = computeFunc.call(obj)
      // 清空 target 上下文
      Dep.target = null
      return value
    },
    set () {
      // Do nothing!
    }
  })
}

// 后面将会用这种方式调用
makeComputed(data, 'fullName', data['fullName'])
```

Okay！既然上下文可以获取了，修改上一篇文章中创建的 `makeReactive` 函数以便使用获取到的上下文。

新的 `makeReactive` 函数像下面这样：

```
function makeReactive (obj, key) {
  let val = obj[key]
  // 创建空数组用来存依赖
  let deps = []

  Object.defineProperty(obj, key, {
    get () {
      // 只有在计算属性上下文中调用的时候才会执行
      if (Dep.target) {
        // 如果还没添加，则作为依赖这个值的计算属性添加
        if (!deps.includes(Dep.target)) {
          deps.push(Dep.target)
        }
      }
      return val
    },
    set (newVal) {
      val = newVal
      // 如果有依赖于这个值的计算属性
      if (deps.length) {
        // 通知每个计算属性的观察者
        deps.forEach(notify)
      }
      notify(key)
    }
  })
}
```

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

基本上就是这样！我们刚刚通过依赖追踪创建了我们自己的计算属性实现。

不幸的是 —— 上面的实现是非常基础的，仍然缺少 Vue.js 和 MobX 中可以找到的重要的特性。我猜最重要的就是缓存和移除废弃的依赖。所以我们把它们添上。

## 缓存 ##

首先，我们需要空间存储缓存。我们在 `makeComputed` 函数中添加缓存管理器。

```
function makeComputed (obj, key, computeFunc) {
  let cache = null

  // 自观察，当 deps 改变的时候清除缓存
  observe(key, () => {
    // 清空缓存
    cache = null
  })

  Object.defineProperty(obj, key, {
    get () {
      if (!Dep.target) {
        Dep.target = key
      }
      // 当没有缓存
      if (!cache) {
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

就是这样！现在在初始化计算后，每次读取计算属性，它都会返回缓存的值，直到不得不重新计算。相当简单，是不是？

多亏了 `observe` 函数，在数据转换过程中我们在 `makeComputed` 内部使用，确保在其他信号处理器执行前清空缓存。这意味着，计算属性的一个依赖发生变化，缓存将被清空，刚刚好在界面更新前完成。

## 移除不必要的依赖 ##

现在剩下的工作就是清理无效的依赖。当计算属性依赖于不同的值的时候通常是一个案例。我们想达到的效果是计算属性仅依赖最后使用到的依赖。上面的实现在这方面是有缺陷的，一旦计算属性登记了依赖于它，它就一直在那了。

可能有更好的方式处理这种情况，但是因为我们想保持简单，我们来创建第二个依赖列表，来存储计算属性的依赖项。
总结来说，我们的依赖列表：

- 依赖于这个值（可观察的或者其他的计算后的）的计算属性名列表存储在本地。可以这样想：**这些是依赖于我的值。**
- 第二个依赖列表，用来移除废弃的依赖并存储计算属性的最新的依赖。可以这样想：**这些值是我依赖的。**

用这两列表，我们可以运行一个过滤函数来移除无效的依赖。让我们首先创建一个存储第二个依赖列表的对象和一些实用的函数。

```
let Dep = {
  target: null,
  // 存储计算属性的依赖
  subs: {},
  // 在计算属性和其他计算后的或者可观察的值之间创建双向的依赖关系
  depend (deps, dep) {
    // 如果还没添加，则添加当前上下文（Dep.target）到本地的 deps，作为依赖于当前属性
    if (!deps.includes(this.target)) {
      deps.push(this.target)
    }
    // 如果还没有添加，将当前属性作为计算值的依赖加入
    if (!Dep.subs[this.target].includes(dep)) {
      Dep.subs[this.target].push(dep)
    }
  },
  getValidDeps (deps, key) {
    // 通过移除在上一次计算中没有使用的废弃依赖，仅仅过滤出有效的依赖
    return deps.filter(dep => this.subs[dep].includes(key))
  },
  notifyDeps (deps) {
    // 通知所有已存在的 deps
    deps.forEach(notify)
  }
}
```
 `Dep.depend` 函数现在还看不出用处，但我们待会就会用到它。那时在这里它的用处会更清楚。

首先，来调整 `makeReactive` 转换函数。

```
function makeReactive (obj, key, computeFunc) {
  let deps = []
  let val = obj[key]

  Object.defineProperty(obj, key, {
    get () {
      // 只有当在计算值的上下文内时才执行
      if (Dep.target) {
        // 将 Dep.target 作为依赖于这个值添加，浙江使 deps 数组发生变化，因为我们给它传了一个引用
        Dep.depend(deps, key)
      }

      return val
    },
    set (newVal) {
      val = newVal
      // 清除废弃依赖
      deps = Dep.getValidDeps(deps, key)
      // 并通知有效的 deps
      Dep.notifyDeps(deps, key)

      notify(key)
    }
  })
}
```

`makeComputed` 转换函数内部也需要做相似的改动。不同在于不使用 setter 而是用传给 `observe` 函数的信号回调处理器。为什么？因为这个回调无论何时计算的值更新了，也就是依赖改变了，都会被调用。

```
function makeComputed (obj, key, computeFunc) {
  let cache = null
  // 创建一个本地的 deps 列表，相似于 makeReactive 的 deps
  let deps = []

  observe(key, () => {
    cache = null
    // 清空并通知有效的 deps
    deps = Dep.getValidDeps(deps, key)
    Dep.notifyDeps(deps, key)
  })

  Object.defineProperty(obj, key, {
    get () {
      // 如果如果在其他计算属性正在计算的时候计算
      if (Dep.target) {
        // 在这两个计算属性之间创建一个依赖关系
        Dep.depend(deps, key)
      }
      // 将 Dep.target 标准化成它原本的样子，这使得构建一个依赖树成为可能，而不是一个扁平化的结构
      Dep.target = key

      if (!cache) {
        // 清空依赖列表以获得一个新的列表
        Dep.subs[key] = []
        cache = computeFunc.call(obj)
      }

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

完成了！你可能已经注意到，它允许计算属性依赖于其他计算属性，不需要知道背后的可观察的对象。相当不错，是不？

## 异步陷阱 ##

既然你知道了依赖追踪如何工作，在 MobX 和 Vue.js 中不能追踪计算属性种的异步数据的原因就很明显了。这一切会被打破，因为即使 `setTimeout(callback, 0)` 将会在当前上下文外被调用，在那里 `Dep.target` 不在存在。这也就意味着在回调函数中无论发生什么都不会被追踪到。

## 红利：Watchers ##

然而，上面的问题可以通过 watchers 部分解决。你可能已经在 Vue.js 中了解过它们。在我们已有的基础上创建 watchers 真的很容易。毕竟，watcher 是一个给定值发生变化时调用的信号处理器。

我们只是不得不添加一个 watchers 注册方法并在 Seer 函数内触发它。

```
function subscribeWatchers(watchers, context) {
  for (let key in watchers) {
    if (watchers.hasOwnProperty(key)) {
      // 使用 Function.prototype.bind 来绑定数据模型，作为我们信号处理器新的 `this` 上下文
      observe(key, watchers[key].bind(context))
    }
  }
}

subscribeWatchers(config.watch, config.data)
```

这就是全部了，可以像这样用它：

```
const App = Seer({
  data: {
    goodCharacter: 'Cloud Strife'
  },
  // 这里可以忽略 watchers
  watch: {
    // 'goodCharacter' 改变时的 watch
    goodCharacter () {
      // 在控制台输出值
      console.log(this.goodCharacter)
    }
  }
}

```

完整的代码可以在下面获得：
[https://github.com/shentao/seer/tree/cached-computed](https://github.com/shentao/seer/tree/cached-computed)

你可以在线的试玩（仅支持 Opera/Chrome）：
[https://jsfiddle.net/oyw72Lyy/](https://jsfiddle.net/oyw72Lyy/)

## 总结 ##

我希望你们喜欢这个教程，当使用计算属性的时候，希望我的解释很好的阐明了 Vue 或 MobX 内部的原理。记住本文提供的实现是相当基础的，和提到的库中的实现不是同等水平的。无论如何都不是可以直接用于生产环境的。

## 接下来讲什么？ ##

第三部分涵盖了对嵌套属性和可观察数组的支持，我也可能在最后添加从事件中取消订阅的办法！ :D
至于第四部分，也许是数据流？你们感兴趣吗？

欢迎在评论区随意反馈意见！

感谢阅读！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
