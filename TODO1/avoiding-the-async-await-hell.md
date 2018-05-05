> * 原文地址：[How to escape async/await hell](https://medium.freecodecamp.org/avoiding-the-async-await-hell-c77a0fb71c4c)
> * 原文作者：[Aditya Agarwal](https://medium.freecodecamp.org/@adityaa803?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/avoiding-the-async-await-hell.md](https://github.com/xitu/gold-miner/blob/master/TODO1/avoiding-the-async-await-hell.md)
> * 译者：[Colafornia](https://github.com/Colafornia)
> * 校对者：[Starriers](https://github.com/Starriers) [whuzxq](https://github.com/whuzxq)

# 如何逃离 async/await 地狱

![](http://o7ts2uaks.bkt.clouddn.com/1__3nDjjPTWn4ohLt96IcwCA.png)

async/await 将我们从回调地狱中解脱，但人们的滥用，导致了 async/await 地狱的诞生。

本文将阐述什么是 async/await 地狱，以及逃离 async/await 地狱的几个方法。

### 什么是 async/await 地狱

进行 JavaScript 异步编程时，大家经常需要逐一编写多个复杂语句的代码，并都在调用语句前标注了 **await**。由于大多数情况下，一个语句并不依赖于前一个语句，但是你仍不得不等前一个语句完成，这会导致性能问题。

### 一个 async/await 地狱示例

思考一下，如果你需要写一段脚本预订一个披萨和一杯饮料。脚本可能会是这样的：

```javascript
(async () => {
  const pizzaData = await getPizzaData()    // 异步调用
  const drinkData = await getDrinkData()    // 异步调用
  const chosenPizza = choosePizza()    // 同步调用
  const chosenDrink = chooseDrink()    // 同步调用
  await addPizzaToCart(chosenPizza)    // 异步调用
  await addDrinkToCart(chosenDrink)    // 异步调用
  orderItems()    // 异步调用
})()
```

表面上看起来没什么问题，这段代码也可以执行。但是它并不是一个好的实现，因为它没有考虑并发性。让我们了解一下这段代码是怎么运行的，这样才可以确定问题所在。

#### 解释

我们将这段代码包裹在一个异步的 [IIFE 立即执行函数](https://developer.mozilla.org/en-US/docs/Glossary/IIFE) 中。准确的执行顺序如下：

1.  获取披萨列表。
2.  获取饮料列表。
3.  从列表中选择一份披萨。
4.  从列表中选择一杯饮料。
5.  将选中披萨加入购物车。
6.  将选中饮料加入购物车。
7.  将购物车内物品下单。

#### 哪里出问题了？

如我之前所强调过的，所有语句都会逐一执行。此处并无并发操作。仔细想一下：为什么我们要在获取披萨列表完成后才去获取饮料列表呢？两个列表应该一起获取。但是我们在选择披萨时，确实需要在这之前已获取饮料列表。饮料同理。

因此，我们可以总结出，披萨相关的事务与饮料相关事务可以并发发生，但是披萨相关事务内部的独立步骤需要继发进行（逐一进行）。

#### 另一个糟糕实现的例子

这段代码将获取购物车内的东西，并发起一个请求下单。

```javascript
async function orderItems() {
  const items = await getCartItems()    // 异步调用
  const noOfItems = items.length
  for(var i = 0; i < noOfItems; i++) {
    await sendRequest(items[i])    // 异步调用
  }
}
```

在这种情况下，for 循环需要等待 `sendRequest()` 函数完成后才能进行下一个迭代。事实上，我们不需要等待。我们想要尽快发送所有请求，然后等待所有请求执行完毕。

希望现在你可以更理解 async/await 地狱是什么，以及它对你的程序性能影响有多么严重。现在，我想问你一个问题。

### 如果我们忘了 await 关键字会怎样？

如果你在调用一个异步函数时忘了使用 **await** 关键字，该函数就会立即开始执行。这意味着 await 对于函数的执行来说不是必需的。异步函数会返回一个 promise 对象，你可以稍后使用这个 promise。

```javascript
(async () => {
  const value = doSomeAsyncTask()
  console.log(value) // 一个未完成的 promise
})()
```

不使用 await 调用异步函数的另一个后果是，编译器不知道你想等待这个函数执行完成。因此编译器将在异步任务完成之前就退出程序。因此我们确实需要 await 关键字。

promise 有一个好玩的特性，你可以在一行代码中得到一个 promise 对象，在另一行代码中得到这个 promise 的执行结果。这是逃离 async/await 地狱的关键。

```javascript
(async () => {
  const promise = doSomeAsyncTask()
  const value = await promise
  console.log(value) // 实际的返回值
})()
```

如你所见，`doSomeAsyncTask()` 返回了一个 promise 对象。此时 `doSomeAsyncTask()` 开始执行。我们使用 await 关键字来获取 promise 对象的执行结果，并告诉 JavaScript 不要立即执行下一行代码，而是等待 promise 执行完成再执行下一行代码。

### 如何逃离 async/await 地狱？

你需要遵循以下步骤：

#### 找到依赖其它语句执行结果的语句

在第一个示例中，我们选择了一份披萨和一杯饮料。可以推断出在选择一份披萨前，我们需要先获得所有披萨的列表。在将选择的披萨加入购物车之前，我们需要先选择一份披萨。因此我们可以说这三个步骤是互相依赖的。我们不能在前一件事完成之前做下一件事。

但是如果把问题看得更广泛一些，我们可以发现选披萨并不依赖选饮料，因此我们可以并行选择。这方面，机器可以比我们做的更好。

因此我们已经发现有一些语句依赖于其它语句的执行，有些则不依赖。

#### 将互相依赖的语句包裹在 async 函数中

如我们所见，选择披萨包括了如获取披萨列表，选择披萨，将所选披萨加入购物车等依赖语句。我们应该将这些语句包裹在一个 async 函数中。这样我们得到了两个 async 函数，`selectPizza()` 和 `selectDrink()`。

#### 并发执行 async 函数

然后我们可以利用事件循环并发执行这些非阻塞 async 函数。有两种常用模式，分别是**优先返回 promises** 和使用**Promise.all 方法**。

### 让我们来修改一下示例

遵循以下三个步骤，将它们应用到我们的示例中。

```javascript
async function selectPizza() {
  const pizzaData = await getPizzaData()    // 异步调用
  const chosenPizza = choosePizza()    // 同步调用
  await addPizzaToCart(chosenPizza)    // 异步调用
}

async function selectDrink() {
  const drinkData = await getDrinkData()    // 异步调用
  const chosenDrink = chooseDrink()    // 同步调用
  await addDrinkToCart(chosenDrink)    // 异步调用
}

(async () => {
  const pizzaPromise = selectPizza()
  const drinkPromise = selectDrink()
  await pizzaPromise
  await drinkPromise
  orderItems()    // 异步调用
})()

// 我更喜欢这种方法

(async () => {
  Promise.all([selectPizza(), selectDrink()]).then(orderItems)   // 异步调用
})()
```

现在我们将语句分组到两个函数中。在函数内部，每个语句依赖于前一个语句的执行。然后我们并发执行两个函数 `selectPizza()` 和 `selectDrink()`。

在第二个例子中，我们需要处理未知数量的 promise。解决这种情况很容易：创建一个数组，将 promise push 进去。然后使用 `Promise.all()` 我们就可以并行等待所有的 promise 处理完毕。

```javascript
async function orderItems() {
  const items = await getCartItems()    // 异步调用
  const noOfItems = items.length
  const promises = []
  for(var i = 0; i < noOfItems; i++) {
    const orderPromise = sendRequest(items[i])    // 异步调用
    promises.push(orderPromise)    // 同步调用
  }
  await Promise.all(promises)    // 异步调用
}
```

希望本文可以帮你提高 async/await 的基础水平并提升应用的性能。

如果喜欢本文，请点个喜欢。

也请分享到 Fb 和 Twitter。如果想获取文章更新，可以在 [Twitter](https://twitter.com/dev__adi) 和 [Medium](https://medium.com/@adityaa803/) 上关注我。有任何问题可以在评论中指出。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
