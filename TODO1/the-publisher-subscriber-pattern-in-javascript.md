> * 原文地址：[The Publisher/Subscriber Pattern in JavaScript](https://medium.com/better-programming/the-publisher-subscriber-pattern-in-javascript-2b31b7ea075a)
> * 原文作者：[jsmanifest](https://medium.com/@jsmanifest)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-publisher-subscriber-pattern-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-publisher-subscriber-pattern-in-javascript.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[weisiwu](https://github.com/weisiwu)，[Alfxjx](https://github.com/Alfxjx)

# JavaScript 的发布者/订阅者（Publisher/Subscriber）模式

> 简写为 Pub 和 sub

![**Photo by [NordWood Themes](https://unsplash.com/@nordwood) on [Unsplash](https://unsplash.com/)**](https://cdn-images-1.medium.com/max/3000/1*yH2hPgLBkX2CtuFwGlpdIA.jpeg)

在本篇文章中，我们将会学习 JavaScript 的发布/订阅模式，并且我们将能看到，在我们的 JavaScript 代码中使用这种设计模式很简单（但却很高效）。

发布者/订阅者模式是一种设计模式，旨在让开发者设计出不直接互相依赖，但却可以互相传递信息的高效能动态应用程序。

这种模式在 JavaScript 中十分常见，它和观察者模式的工作方式很相近 —— 一个区别是，在观察者模式中，观察者直接从它所观察的实体那里得到通知，而在发布者/订阅者模式中，订阅者则通过渠道得到通知，渠道位于发布者和订阅者之间并来回传递信息。

如果想要实现一个发布者/订阅者模式，我们需要一个发布者、一个订阅者，以及一些存储订阅者所注册的回调函数的空间。

下面，让我们一起来看看落实到代码应该怎么写。我们将会使用一个 [factory](https://www.sitepoint.com/factory-functions-javascript/) 函数（你不一定非要使用这个模式）来写出发布者/订阅者模式的实现。

我们要做的第一件事，就是在函数中声明一个本地变量，用来保存订阅的回调函数：

```
function pubSub() {
  const subscribers = {}
}
```

下面，我们将会定义 `subscribe` 方法，它负责在 `subscribers` 中插入回调函数：

```JavaScript
function pubSub() {
  const subscribers = {}
  
  function subscribe(eventName, callback) {
    if (!Array.isArray(subscribers[eventName])) {
      subscribers[eventName] = []
    }
    subscribers[eventName].push(callback)
  }
  
  return {
    subscribe,
  }
}
```

该段代码会在添加新的事件订阅前，检查订阅者中是否有对应的事件。如果没有，将在订阅者上添加值为空数组的事件属性，否则将在对应的事件队列下入队新的订阅回调。

当 `publish` 事件被触发的时候，它将会收到两个参数：

1. `eventName` 参数
2. 所有被传递给注册在 `subscribers[eventName]` 的回调函数的 `data`

我们继续向下看看代码是如何实现的：

```JavaScript
function pubSub() {
  
  const subscribers = {}
  
  function publish(eventName, data) {
    if (!Array.isArray(subscribers[eventName])) {
      return
    }
    subscribers[eventName].forEach((callback) => {
      callback(data)
    })
  }
  
  function subscribe(eventName, callback) {
    if (!Array.isArray(subscribers[eventName])) {
      subscribers[eventName] = []
    }
    subscribers[eventName].push(callback)
  }
  
  return {
    publish,
    subscribe,
  }
}
```

在遍历 `subscribers` 中的回调函数列表之前，要先检查对象中该属性是否是数组类型。如果不是，那么就认为这个 `eventName` 之前并没有被注册过，所以就直接返回了。这一步可以保证避免潜在的程序报错。

在这之后，如果程序执行到了 `.forEach` 这一行，那么我们就可以确定 `eventName` 已经被注册了一个或多个回调函数。程序就可以继续保证安全的循环遍历 `subscribers[eventName]`。

程序每读取到一个回调函数，都将会以 `data` 为第二个参数来调用它。

当我们如此订阅一个函数的时候，就会发生上述流程。

```JavaScript
function showMeTheMoney(money) {
  console.log(money)
}

const ps = pubSub()

ps.subscribe('show-money', showMeTheMoney)
```

如果我们在以后的某一时刻调用 `publish`：

```JavaScript
ps.publish('show-money', 1000000)
```

那么我们注册的 `showMeTheMoney` 回调函数将会被触发，`money` 参数的值为 `1000000`：

```JavaScript
function showMeTheMoney(money) {
  console.log(money) // result: 10000000
}
```

这就是发布/订阅模式的原理。我们定义了一个 `pubSub` 函数，并在函数内将回调函数存储到本地，并提供了 `subscribe` 方法注册回调函数，以及 `publish` 方法来遍历并使用数据来调用所有注册过的回调函数。

但是，这里还存在一个问题。在真正应用这个模式的时候，如果我们订阅了很多回调函数，就可能会遇到内存泄漏，如果不想办法解决这个问题，这将造成极大的浪费。

所以我们还需要一个移除订阅的回调函数的方法，以便在不需要它们的时候可以删除。通常的方法是在某处定义一个 `unsubscribe` 方法。而实现它最便捷的位置就是作为 `subscribe` 的返回值，因为在我看来这是最直观的方法，我们来看看代码：

```JavaScript
function subscribe(eventName, callback) {
  if (!Array.isArray(subscribers[eventName])) {
    subscribers[eventName] = []
  }
  
  subscribers[eventName].push(callback)
  
  const index = subscribers[eventName].length - 1
  
  return {
    unsubscribe() {
      subscribers[eventName].splice(index, 1)
    },
  }
}

const { unsubscribe } = subscribe('food', function(data) {
  console.log(`Received some food: ${data}`)
})

// 移除订阅的回调
unsubscribe()
```

在这个例子中，我们需要一个索引。这样我们就能确保移除的是正确的回调函数，我们使用得是 `.splice` 函数，它可以通过索引来移除我们需要移除的数组中的项目。

我们还可以这样写；但是这样性能就稍差一些：

```JavaScript
function subscribe(eventName, callback) {
  if (!Array.isArray(subscribers[eventName])) {
    subscribers[eventName] = []
  }
  
  subscribers[eventName].push(callback)
  
  const index = subscribers[eventName].length - 1
  
  return {
    unsubscribe() {
      subscribers[eventName] = subscribers[eventName].filter((cb) => {
        // 在新的数组中不再包含这个回调函数
        if (cb === callback) {
          return false
        }
        return true
      })
    },
  }
}
```

---

## 不足之处

虽然发布者/订阅者模式有很多优势，但是同时它也存在灾难性的缺点，这可能会让我们付出巨大的调试时间成本。

我们如何知道是否之前已经订阅了同一个回调函数呢？除非我们实现一个工具来映射整个列表，否则实在无法知道，但是这样的话我们就要使用 JavaScript 来完成更多的工作了。

在实际应用中过度使用发布者/订阅者模式，也让我们的代码更加难以维护。事实是，在这种模式中回调函数之间是解耦的，所以当你在多处都使用了回调函数后，追踪代码就变得非常困难。

---

## 总结

综上所述就是本文的全部内容。希望能对你有所帮助！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
