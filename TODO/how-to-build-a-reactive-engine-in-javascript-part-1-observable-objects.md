> * 原文地址：[How to build a reactive engine in JavaScript. Part 1: Observable objects](https://monterail.com/blog/2016/how-to-build-a-reactive-engine-in-javascript-part-1-observable-objects)
> * 原文作者：本文已获原作者 [Damian Dulisz](https://disqus.com/by/damiandulisz/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[IridescentMia](https://github.com/IridescentMia)
> * 校对者：[reid3290](https://github.com/reid3290)，[malcolmyu](https://github.com/malcolmyu)

![](https://d4a7vd7s8p76l.cloudfront.net/uploads/1484604970-4-7876/observables.png)

# 如何使用 JavaScript 构建响应式引擎 —— Part 1：可观察的对象 #

## 响应式的方式 ##

随着对强健、可交互的网站界面的需求不断增多，很多开发者开始拥抱响应式编程规范。

在开始实现我们自己的响应式引擎之前，快速地解释一下到底什么是响应式编程。维基百科给出一个经典的响应式界面实现的例子 —— 叫做 spreadsheet。定义一个准则，对于 `=A1+B1`，只要  `A1` 或 `B1` 发生变化，`=A1+B1` 也会随之变化。这样的准则也可以被理解为是一种 computed value。

我们将会在这系列教程的 Part 2 部分学习如何实现 computed value。在那之前，我们首先需要对响应式引擎有个基础的了解。

## 引擎 ##

目前有很多不同解决方案可以观察到应用状态的改变，并对其做出反应。

- Angular 1.x 有脏检查。
- React 由于它工作方式，并不追踪数据模型中的改变。它用虚拟 DOM 比较并修补 DOM。
- Cycle.js 和 Angular 2 更倾向于响应流方式实现，像 XStream 和 Rx.js。
- 像 Vue.js， MobX 或 Ractive.js 这些库都使用 getters/setters 变量创建可观察的数据模型。

在这篇教程中，我们将使用 getters/setters 的方式观察并响应变化。

> 注意：为了让这篇教程尽量保持简单，代码缺少对非初级数据类型或嵌套属性的支持，并且很多内容需要完整性检查，因此决不能认为这些代码已经可以用于生产环境。下面的代码是受 Vue.js 启发的响应式引擎的实现，使用 ES2015 标准编写。

## 可观察的对象 ##

让我们从一个 `data` 对象开始，我们想要观察它的属性。

```
let data = {
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
}
```

首先从创建两个函数开始，使用 getter/setter 的功能，将对象的普通属性转换成可观察的属性。

```
function makeReactive (obj, key) {
  let val = obj[key]

  Object.defineProperty(obj, key, {
    get () {
      return val // 简单地返回缓存的 value
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

通过运行 `observeData(data)`，将原始的对象转换成可被观察的对象；现在当对象的 value 发生变化时，我们有创建通知的办法。

## 响应变化 ##

在我们开始接收 *notifying* 前，我们需要一些通知的内容。这里是使用观察者模式的一个极好例子。在这个案例中我们将使用 signals 实现。

我们从 `observe` 函数开始。

```
let signals = {} // Signals 从一个空对象开始

function observe (property, signalHandler) {
  if(!signals[property]) signals[property] = [] // 如果给定属性没在 signal 中，则创建这个属性的 signal，并将其设置为空数组来存储 signalHandlers

  signals[property].push(signalHandler) // 将 signalHandler 存入 signal 数组，高效地获得一组保存在数组中的回调函数
}
```

我们现在可以这样用 `observe` 函数：`observe('propertyName', callback)`，每次属性值发生改变的时候 `callback` 函数应该被调用。当多次在一个属性上调用 **observe** 时，每个回调函数将被存在对应属性的 signal 数组中。这样就可以存储所有的回调函数并且可以很容易地获得到它们。

现在来看一下上文中提到的 `notify` 函数。

```
function notify (signal, newVal) {
  if(!signals[signal] || signals[signal].length < 1) return // 如果没有 signal 的处理器则提前 return 

  signals[signal].forEach((signalHandler) => signalHandler()) // 调用给定属性的每个 signalHandler 
}
```

如你所见，现在每次一个属性发生变化，就会调用对其分配的 signalHandlers。

所以我们把它全部封装起来做成一个工厂函数，传入想要响应的数据对象。我把它命名为 `Seer`。我们最终得到如下：

```
function Seer (dataObj) {
  let signals = {}

  observeData(dataObj)

  // 除了响应式的数据对象，我们也需要返回并且暴露出 observe 和 notify 函数。
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

现在我们需要做的就是创建一个新的可响应对象。多亏了暴露出来的 `notify` 和 `observe` 函数，我们可以观察到并响应对象的改变。

```
const App = new Seer({
  title: 'Game of Thrones',
  firstName: 'Jon',
  lastName: 'Snow',
  age: 25
})

// 为了订阅并响应可响应 APP 对象的改变：
App.observe('firstName', () => console.log(App.data.firstName))
App.observe('lastName', () => console.log(App.data.lastName))

// 为了触发上面的回调函数，像下面这样简单地改变 values：
App.data.firstName = 'Sansa'
App.data.lastName = 'Stark'

```

很简单，是不是？现在我们讲完了基本的响应式引擎，让我们来用用它。
我提到过随着前端编程可响应式方法的增多，我们不能总想着在发生改变后手动地更新 DOM。

有很多方法来完成这项任务。我猜现在最流行的趋势是用虚拟 DOM 的办法。如果你对学习如何创建你自己的虚拟 DOM 实现感兴趣，已经有很多这方面的教程。然而，这里我们将用到更简单的方法。

HTML 看起来像这样： `html<h1>Title comes here</h1>`

响应式更新 DOM 的函数看起来像这样：

```
// 首先需要获得想要保持更新的节点。
const h1Node = document.querySelector('h1')

function syncNode (node, obj, property) {
  // 用可见对象的属性值初始化 h1 的 textContent 值
  node.textContent = obj[property]

  // 开始用我们的 Seer 的实例 App.observe 观察属性。
  App.observe(property, value => node.textContent = obj[property] || '')
}

syncNode(h1Node, App.data, 'title')
```

这样做是可行的，但是使用它把所有数据模型绑定到 DOM 元素需要大量的工作。

这就是我们为什么要再向前迈一步，然后将所有这些自动化完成。
如果你熟悉 AngularJS 或者 Vue.js，你肯定记得使用自定义属性 `ng-bind` 或 `v-text`。我们在这里创建类似的东西。
我们的自定义属性叫做 `s-text`。我们将寻找在 DOM 和数据模型之间建立绑定的方式。

让我们更新一下 HTML：

```
<!-- 'title' 是我们想要在 <h1> 内显示的属性 -->
<h1 s-text="title">Title comes here</h1>
function parseDOM (node, observable) {
  // 获得所有具有自定义属性 s-text 的节点
  const nodes = document.querySelectorAll('[s-text]')

  // 对于每个存在的节点，我们调用 syncNode 函数
  nodes.forEach((node) => {
    syncNode(node, observable, node.attributes['s-text'].value)
  })
}

// 现在我们需要做的就是在根节点 document.body 上调用它。所有的 `s-text` 节点将会自动的创建与之对应的响应式属性的绑定。
parseDOM(document.body, App.data)
```

## 总结 ##

现在我们可以解析 DOM 并且将数据模型绑定到节点上，把这两个函数添加到 Seer 工厂函数中，这样就可以在初始化的时候解析 DOM。

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
    //转换数据对象后，可以安全地解析 DOM 绑定。
    parseDOM(document.body, obj)
  }

  function syncNode (node, observable, property) {
    node.textContent = observable[property]
    // 移除了 `Seer.` 是因为 observe 函数在可获得的作用域范围之内。
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
// 代码用了 ES2015，使用兼容的浏览器才可以哦，比如 Chrome，Opera，Firefox
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
    //转换数据对象后，可以安全地解析 DOM 绑定。
    parseDOM(document.body, obj)
  }

  function syncNode (node, observable, property) {
    node.textContent = observable[property]
    // 移除了 `Seer.` 是因为 observe 函数在可获得的作用域范围之内。
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

上文的代码可以在这里找到： [github.com/shentao/seer](https://github.com/shentao/seer/tree/master)

## 未完待续…… ##

这篇是制作你自己的响应式引擎系列文章中的第一篇。

**[下一篇](https://github.com/xitu/gold-miner/blob/master/TODO/computed-properties-javascript-dependency-tracking.md) 将是关于创建 computed properties，每个属性都有它自己的可追踪依赖。**

非常欢迎在评论区提出你对于下一篇文章讲述内容的反馈和想法！

感谢阅读。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
