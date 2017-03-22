> * 原文地址：[How to build a reactive engine in JavaScript. Part 1: Observable objects](https://monterail.com/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects)
> * 原文作者：[Damian Dulisz](https://disqus.com/by/damiandulisz/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[IridescentMia](https://github.com/IridescentMia)
> * 校对者：

![](https://d4a7vd7s8p76l.cloudfront.net/uploads/1484604970-4-7876/observables.png)

# [How to build a reactive engine in JavaScript. Part 1: Observable objects](/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects/) # 
# 如何用 JavaScript 构建响应式引擎 —— Part 1：可见的对象 #

## The reactive way ##
## 响应的方式 ##

With the growing need for robust and interactive web interfaces, many developers have started embracing the reactive programming paradigm.
随着对强健、可交互的网站界面的需求不断增多，很多开发者开始拥抱响应式编程规范。

Before we begin implementing our own reactive engine, let’s quickly explain what reactive programming actually is. Wikipedia gives us a classic example of a reactive interface implementation – namely a spreadsheet. Defining a formula such as `=A1+B1` would update the cell whenever either `A1` or `B1` change. Such a formula can be considered a computed value.
在开始实现我们自己的响应式引擎之前，快速的解释一下到底什么是响应式编程。维基百科给出一个经典的响应式界面实现的例子 —— 叫做 spreadsheet。定义一个准则，对于 `=A1+B1`，只要  `A1` 或 `B1` 发生变化，`=A1+B1` 也会随之变化。这个准则被认为是 computed value。

You will learn how to implement computed values in the second part of this reactive series. Before that, we first need a base for our reactivity engine.
我们将会在这系列教程的 Part 2 部分学习如何实现 computed value。在那之前，我们首先需要对响应式引擎有个基础的了解。

## The engine ##
## 引擎 ##

Currently there are many different approaches to solving the problem of observing and reacting to the changing application state.
目前有很多不同解决方案可以观察到应用状态的改变，并对其做出反应。

- Angular 1.x has its dirty checking.
- React, because of the way it works – doesn’t actually track changes in the data model. It uses the virtual DOM to diff and patch the DOM.
- Cycle.js and Angular 2 prefer the reactive streams implementations like XStream and Rx.js.
- Libraries like Vue.js, MobX or Ractive.js all use a variation of getters/setters to create observable data models.

- Angular 1.x 有脏检查。
- React 由于它工作方式的原因，并不追踪数据模型中的改变。它用虚拟 DOM 比较并修补 DOM。
- Cycle.js 和 Angular 2 更喜欢响应流方式实现，像 XStream 和 Rx.js.
- 像 Vue.js， MobX 或 Ractive.js 这些库都使用 getters/setters 变量创建可见的数据模型。

In this tutorial, we will go the getters/setters way of observing and reacting to changes.
在这篇教程中，我们将使用 getters/setters 的方式观察并响应变化。

> Note: To keep the tutorial as simple as possible, the code lacks the support for non-primitive data types or nested properties and many of the required sanity checks, thus by no means should this code be considered production ready. The code below is written using the ES2015 standard and is loosely inspired by the Vue.js reactive engine implementation.

> 注意：为了让这篇教程尽量保持简单，代码缺少对非初级数据类型或嵌套属性的支持，并且很多内容需要完整性检查，因此决不能认为这些代码已经可以用于生产环境。下面的代码是受 Vue.js 启发的响应式引擎的实现，使用 ES2015 标准编写。

## The observable object ##
## 可见的对象 ##

Let’s start with a `data` object, whose properties we want to observe.
让我们从一个 `data` 对象开始，我们想要将它的属性可见。

```
let data = {
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
}
```

Let’s start by creating two functions that will transform our object’s properties into observable properties using the getter/setter functionality.
首先从创建两个函数开始，使用 getter/setter 的功能，将对象的普通属性转换成可见的属性。

```
function makeReactive (obj, key) {
  let val = obj[key]

  Object.defineProperty(obj, key, {
    get () {
      return val // 简单的返回缓存的 value
    },
    set (newVal) {
      val = newVal // 保存 newVal
      notify(key) // 暂时忽略这里
    }
  })
}

// 循环迭代对象的 keys
function observeData (obj) {
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      makeReactive(obj, key)
    }
  }
}

observeData(data)
```

By running `observeData(data)` we transform our object into an object capable of being observed; now we have a way to create notifications whenever the value changes.
通过运行 `observeData(data)`，将原始的对象转换成具有可见性的对象；现在当对象的 value 发生变化时，我们有创建通知的办法。

## Reacting to changes ##
## 响应变化 ##

Before we begin *notifying*, we need something that we can actually notify. This is a perfect example where we can use the observer pattern. In this case we will make use of the signals implementation.
在我们开始接收 *notifying* 前，我们需要一些通知的内容。这里是使用观察者模式的一个极好例子。在这个案例中我们将使用 signals 实现。

Let’s start with the `observe` function.
我们从 `observe` 函数开始。

```
let signals = {} // Signals 从一个空对象开始

function observe (property, signalHandler) {
  if(!signals[property]) signals[property] = [] // 如果给定属性没在 signal 中，则创建这个属性的 signal，并将其设置为空数组来存储 signalHandlers

  signals[property].push(signalHandler) // 将 signalHandler 存入 signal 数组，高效的获得一组保存在数组中的回调函数
}
```

We can now use the `observe` function like this: `observe('propertyName', callback)`, where `callback` is a function that should be called each time the property’s value has changed. When we **observe** a property multiple times, each callback will be stored inside the corresponding property’s signal array. This way we can store all callbacks and have easy access to them.
我们现在可以这样用 `observe` 函数：`observe('propertyName', callback)`，每次属性值发生改变的时候 `callback` 函数应该被调用。当多次在一个属性上调用 **observe** 时，每个回调函数将被存在对应属性的 signal 数组中。这样就可以存储所有的回调函数并且可以很容易的获得到它们。

Now for the `notify` function that you saw before.
现在来看一下上文中提到的 `notify` 函数。

```
function notify (signal, newVal) {
  if(!signals[signal] || signals[signal].length < 1) return // 如果没有 signal 的处理器则提前 return 

  signals[signal].forEach((signalHandler) => signalHandler()) // 调用给定属性的每个 signalHandler 
}
```

As you can see, now every time one of the properties changes, the assigned signalHandlers will be called.
如你所见，现在每次一个属性发生变化，就会调用对其分配的 signalHandlers。

So let’s wrap it all up into a factory function that we pass the data object that has to be reactive. I will name mine `Seer`. We end up with something like this:
所以我们把它全部封装起来做成一个工厂函数，传入想要响应的数据对象。我把它命名为 `Seer`。我们最终得到如下：

```
function Seer (dataObj) {
  let signals = {}

  observeData(dataObj)

  // 除了响应的数据对象，我们也需要返回并且暴露出 observe 和 notify 函数。
  return {
    data: dataObj,
    observe,
    notify
  }

  function observe (property, signalHandler) {
    if(!signals[property]) signals[property] = []

    signals[property].push(signalHandler)
  }

  function notify (signal) {
    if(!signals[signal] || signals[signal].length < 1) return

    signals[signal].forEach((signalHandler) => signalHandler())
  }

  function makeReactive (obj, key) {
    let val = obj[key]

    Object.defineProperty(obj, key, {
      get () {
        return val
      },
      set (newVal) {
        val = newVal
        notify(key)
      }
    })
  }

  function observeData (obj) {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        makeReactive(obj, key)
      }
    }
  }
}
```

All we need to do now is to create a new reactive object. Thanks to the exposed `notify` and `observe` functions, we can observe and react to the changes made to the object.
现在我们需要做的就是创建一个新的可响应对象。多亏了暴露出来的 `notify` 和 `observe` 函数，我们可以观察到并响应对象的改变。

```
const App = new Seer({
  title: 'Game of Thrones',
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
})

// To subscribe and react to changes made to the reactive App object:
// 为了订阅并响应可响应 APP 对象的改变：
App.observe('firstName', () => console.log(App.data.firstName))
App.observe('lastName', () => console.log(App.data.lastName))

// To trigger the above callbacks simply change the values like this:
// 为了触发上面的回调函数，像下面这样简单的改变 values：
App.data.firstName = 'Sansa'
App.data.lastName = 'Stark'

```

Simple, isn’t it? Now that we have the basic reactivity engine covered, let’s make some use of it.
I mentioned that with the more reactive approach to front-end programming, we should not be concerned with things like manually updating the DOM after each change.
很简单，是不是？现在我们讲完了基本的响应式引擎，让我们来用用它。
我提到过随着前端编程可响应式方法的增多，我们不能总想着在发生改变后手动的更新 DOM。

There are many approaches to this. I guess the most trending one right now is the so called virtual DOM. If you are interested in learning how to create your own virtual DOM implementation, there are already great tutorials for this. However, here we will go with a much simpler approach.
有很多方法来完成这项任务。我猜现在最流行的趋势是用虚拟 DOM 的办法。如果你对学习如何创建你自己的虚拟 DOM 实现感兴趣，已经有很多这方面的教程。然而，这里我们将用到更简单的方法。

Let’s say our HTML looks like this:`html<h1>Title comes here</h1>`
HTML 看起来像这样： `html<h1>Title comes here</h1>`

The function responsible for updating the DOM would look like this:
响应式更新 DOM 的函数看起来像这样：

```
// First we need to get the node that we want to keep updating.
// 首先需要获得想要保持更新的节点。
const h1Node = document.querySelector('h1')

function syncNode (node, obj, property) {
  // Initialize the h1’s textContent value with the observed object’s property value
  // 用可见对象的属性值初始化 h1 的 textContent 值
  node.textContent = obj[property]

  // Start observing the property using our Seer instance App.observe method.
  // 开始用我们的 Seer 的实例 App.observe 观察属性。
  App.observe(property, value => node.textContent = obj[property] || '')
}

syncNode(h1Node, App.data, 'title')
```

This will work but actually requires a lot of work from us to actually bind all the DOM elements to the desired data models.
这样做是可行的，但是使用它把所有数据模型绑定到 DOM 元素需要大量的工作。

That’s why we can go a step further and automate all of this.
If you are familiar with AngularJS or Vue.js you surely remember using custom HTML attributes like `ng-bind` or `v-text`. We will create something similar here!
Our custom attribute will be called `s-text`. We will look for it to create bindings between the DOM and the data model.

这就是我们为什么要再向前迈一步，然后将所有这些自动化完成。
如果你熟悉 AngularJS 或者 Vue.js，你肯定记得使用自定义属性 `ng-bind` 或 `v-text`。我们在这里创建类似的东西。
我们的自定义属性叫做 `s-text`。我们将寻找在 DOM 和数据模型之间建立绑定的方式。

Let’s update our HTML:
让我们更新一下 HTML：

```
<!-- 'title' is the property which value we want to show inside the <h1> element -->
<!-- 'title' 是我们想要在 <h1> 内显示的属性 -->
<h1 s-text="title">Title comes here</h1>
function parseDOM (node, observable) {
  // We get all nodes that have the s-text custom attribute
  // 获得所有具有自定义属性 s-text 的节点
  const nodes = document.querySelectorAll('[s-text]')

  // For each existing node, we call the syncNode function
  // 对于每个存在的节点，我们调用 syncNode 函数
  nodes.forEach((node) => {
    syncNode(node, observable, node.attributes['s-text'].value)
  })
}

// Now all we need to do is call it with document.body as the root node. All `s-text` nodes will automatically create bindings to the corresponding reactive property.
// 现在我们需要做的就是在根节点 document.body 上调用它。所有的 `s-text` 节点将会自动的创建与之对应的响应式属性的绑定。
parseDOM(document.body, App.data)
```

## Summary ##
## 总结 ##

Now that we have a way to parse the DOM and bind the nodes to the data model, let’s add those two functions into the Seer factory function, where we will parse the DOM on initialization.
现在我们可以解析 DOM 并且将数据模型绑定到节点上，把这两个函数添加到 Seer 工厂函数中，这样就可以在初始化的时候解析 DOM。

The result should look like this:
结果应该像下面这样：

```
function Seer (dataObj) {
  let signals = {}

  observeData(dataObj)

  return {
    data: dataObj,
    observe,
    notify
  }

  function observe (property, signalHandler) {
    if(!signals[property]) signals[property] = []

    signals[property].push(signalHandler)
  }

  function notify (signal) {
    if(!signals[signal] || signals[signal].length < 1) return

    signals[signal].forEach((signalHandler) => signalHandler())
  }

  function makeReactive (obj, key) {
    let val = obj[key]

    Object.defineProperty(obj, key, {
      get () {
        return val
      },
      set (newVal) {
        val = newVal
        notify(key)
      }
    })
  }

  function observeData (obj) {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        makeReactive(obj, key)
      }
    }
    // We can safely parse the DOM looking for bindings after we converted the dataObject.
    parseDOM(document.body, obj)
  }

  function syncNode (node, observable, property) {
    node.textContent = observable[property]
    // We remove the `Seer.` as it is now available for us in our scope.
    observe(property, () => node.textContent = observable[property])
  }

  function parseDOM (node, observable) {
    const nodes = document.querySelectorAll('[s-text]')

    nodes.forEach((node) => {
      syncNode(node, observable, node.attributes['s-text'].value)
    })
  }
}
```

Example on JsFiddle:
JsFiddle 上的例子：

HTML

```
<h1 s-text="title"></h1>
<div class="form-inline">
  <div class="form-group">
    <label for="title">Title: </label>
    <input 
      type="text" 
      class="form-control" 
      id="title" placeholder="Enter title"
      oninput="updateText('title', event)">
  </div>
  <button class="btn btn-default" type="button" onclick="resetTitle()">Reset title</button>
</div>
```

JS

```
// This code uses ES2015.
// Please use a compatible browser like: Chrome, Opera, Firefox

function Seer (dataObj) {
  let signals = {}

  observeData(dataObj)

  return {
    data: dataObj,
    observe,
    notify
  }

  function observe (property, signalHandler) {
    if(!signals[property]) signals[property] = []

    signals[property].push(signalHandler)
  }

  function notify (signal) {
    if(!signals[signal] || signals[signal].length < 1) return

    signals[signal].forEach((signalHandler) => signalHandler())
  }

  function makeReactive (obj, key) {
    let val = obj[key]

    Object.defineProperty(obj, key, {
      get () {
        return val
      },
      set (newVal) {
        val = newVal
        notify(key)
      }
    })
  }

  function observeData (obj) {
    for (let key in obj) {
      if (obj.hasOwnProperty(key)) {
        makeReactive(obj, key)
      }
    }
    // We can safely parse the DOM looking for bindings after we converted the dataObject.
    parseDOM(document.body, obj)
  }

  function syncNode (node, observable, property) {
    node.textContent = observable[property]
    // We remove the `Seer.` as it is now available for us in our scope.
    observe(property, () => node.textContent = observable[property])
  }

  function parseDOM (node, observable) {
    const nodes = document.querySelectorAll('[s-text]')

    for (const node of nodes) {
      syncNode(node, observable, node.attributes['s-text'].value)
    }
  }
}

const App = Seer({
  title: 'Game of Thrones',
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
})

function updateText (property, e) {
	App.data[property] = e.target.value
}

function resetTitle () {
	App.data.title = "Game of Thrones"
}
```

Resources

```
EXTERNAL RESOURCES LOADED INTO THIS FIDDLE:

bootstrap.min.css
```

Result

![Markdown](http://i2.buimg.com/1949/cf89248985467d6f.png)

The above code can be found here: [github.com/shentao/seer](https://github.com/shentao/seer/tree/master)
上文的代码可以在这里找到： [github.com/shentao/seer](https://github.com/shentao/seer/tree/master)

## To be continued... ##
## 未完待续…… ##

This is the first part in a series about crafting your own reactivity engine.
这篇是制作你自己的响应式引擎系列文章中的第一篇。

**The next part will be about creating computed properties, where each has its own trackable dependencies.**
**下一篇将是关于创建 computed properties，每个属性都有它自己的可追踪依赖。**

Your feedback and ideas on what to cover next are both very welcome in the comments!
非常欢迎在评论区提出你对于下一篇文章讲述内容的反馈和想法！

Thanks for reading. 
感谢阅读。
