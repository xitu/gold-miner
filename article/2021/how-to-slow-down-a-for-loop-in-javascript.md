> * 原文地址：[How To Slow Down A For-Loop in JavaScript](https://medium.com/javascript-in-plain-english/javascript-slow-down-for-loop-9d1caaeeeeed)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-slow-down-a-for-loop-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-slow-down-a-for-loop-in-javascript.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Usualminds](https://github.com/Usualminds)、[samyu2000](https://github.com/samyu2000)

# 如何让 JavaScript 中的循环慢下来

![图源 [Charlotte Coneybeer](https://unsplash.com/@she_sees?utm_source=medium&utm_medium=referral)，上传于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*kcAWzuiAUolF3Zkr)

For 循环在 JavaScript 中是必不可少的。使用 For 循环，我们可以写出与列表有关的程序。但是这里存在一个问题 —— For 循环是尽可能快地执行。当然如果我们只是用它来遍历数组那绝对是没有问题的。

但是如果我们在循环中执行请求，那就可能会出现一些问题（例如过高的请求速度让服务器封锁 IP 之类的我们不想看到的情况就会纷至沓来了）。如果我们能实现每隔一段时间才执行一次循环（例如，每秒只执行一次循环操作），也就是使 For 循环的执行放慢一些，那该会有多棒啊！

在下文中，我们将一起开启探索之旅～

## 首先：无效的方法

如果你正在寻找直接解决问题的方法，请直接跳过这里吧。而如果你想学习更多有关 JavaScript 的知识，那么就请留步～

我想在这里先解释一下为什么常见的解决方案不起作用。

首先还是先要感谢 JavaScript 为我们提供的 `setTimeout` 方法，让我们能够实现在一定时间后执行某些代码的功能。咦？这似乎能够满足我们题目的要求啊 —— 我们只需要将 `setTimeout` 加入 For 循环体中，循环速度就会变慢：

```js
for (let i = 0; i < 100; i++) {
    setTimeout(() => {
        console.log(i);
    }, 1000);
}
```

但我们运行上面的代码，却会发生以下情况：

* 起初先卡顿了一下，随后所有日志同时被打印在控制台上。

这完全就不是我们想要的结果呢～

造成这个结果的原因是我们陷入了误区。似乎这里 For 循环也并没有为每一个元素设置 `timeout`（但实际上，程序设置了）。

我们只是忘记了 JavaScript 是如何执行代码的。循环是会立即创建所有的 `timeout`，而不是顺序创建。这非常快，也因此所有的 `timeout` 都具有几乎相同的**开始时间**。

而一旦设置的时间到了，所有的任务都会立即执行 —— 同时打印日志。

即便我们按照下面的代码去重写代码，我们仍会看到相同的效果。

```js
for (let i = 0; i < 100; i++) {
    setTimeout(() => {
    }, 1000);
    console.log(i);
}
```

如果以这个想法为出发点，其实我们可以在其他一些编程语言中达到我们的目标 —— 循环创建 `timeout`，且只有当这些任务执行后，循环才继续执行 —— 至少在其他编程语言中是这样的。但是，在 JavaScript 中，程序可不会停下来，只会继续创建 `timeout`。代码也只会继续执行下去不会停留。因此，JavaScript 可以看作是创建了两个并行运行的线程同时处理 For 循环和 For 循环创建的 `timeout`。

## 如何正确地降低 For 循环的执行速度

显然，如果我们只使用 **`setTimeout`**，将永远无法达到我们的预期，那我们应该怎么做呢？

其实解决方案很简单，只需要用一段简单的 `Promise` 语句就行了。

```js
const sleep = (time) => {
    return new Promise((resolve) => {
        return setTimeout(function () {
            resolve()
        }, time)
    })
}
```

我们通过函数调用 `Promise`，而它会获取 **setTimeout** 应该被设置的时间（以毫秒为单位）。在一定时间后，所有 `timeout` 都会执行 `resolve` 函数。这意味着 `Promise` 被我们执行了。我们可以简化上面显示的代码：

```js
const sleep = (time) => {
    return new Promise(resolve => setTimeout(resolve, time))
}
```

使用 `Promise` 可以实现我们需要的功能。现在让我们将它添加到 For 循环中：

```js
const sleep = (time) => {
    return new Promise((resolve) => setTimeout(resolve, time))
}

const doSomething = async () => {
    for (let i = 0; i < 100; i++) {
        await sleep(1000)
        console.log(i)
    }
}

doSomething()
```

程序每秒执行一次日志打印操作。因此，要输出循环的所有数字，我们需要等待 100 秒。现在我们已经成功的放缓了 For 循环的执行速度！

感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
