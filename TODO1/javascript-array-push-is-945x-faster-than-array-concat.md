> * 原文地址：[Javascript Array.push is 945x faster than Array.concat 🤯🤔](https://dev.to/uilicious/javascript-array-push-is-945x-faster-than-array-concat-1oki)
> * 原文作者：[Shi Ling](https://dev.to/shiling)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-array-push-is-945x-faster-than-array-concat.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-array-push-is-945x-faster-than-array-concat.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[钱俊颖](https://github.com/Baddyo), [MLS](https://github.com/hzdaqo)

# Javascript 中 Array.push 要比 Array.concat 快 945 倍！🤯🤔

如果要合并拥有上千个元素的数组，使用 `arr1.push(...arr2)` 可比 `arr1 = arr1.concat(arr2)` 节省时间。如果你想要再快一点，你甚至可以编写自己的函数来实现合并数组的功能。

## 等一下……用 `.concat` 合并 15000 个数组要花多长时间呢？

最近，我们有一个用户抱怨他在使用 [UI-licious](https://uilicious.com) 对他们的 UI 进行测试时，速度明显慢了很多。通常，每一个 `I.click` `I.fill` `I.see` 命令需要大约 1 秒的时间完成（后期处理，例如截屏），现在需要超过 40 秒才能完成，因此通常在 20 分钟内可以完成的测试现在需要花费数小时才能完成，这严重地拖慢了他们的部署进程。

我很快就设置好了定时器，锁定了导致速度缓慢的那部分代码，但当我找到罪魁祸首时，我着实吃了一惊：

```
arr1 = arr1.concat(arr2)
```

数组的 `.concat` 方法。

为了允许在编写测试的时候可以使用简单的指令，如 `I.click("Login")`，而不是使用 CSS 或是 XPATH 选择器，如 `I.click("#login-btn")`，UI-licious 基于网站的语义、可访问性属性以及各种流行但不标准的模式，使用动态代码分析（模式）来分析 DOM 树，从而确定网站的测试内容和测试方法。这些 `.concat` 操作被用来压扁 DOM 树进行分析，但是当 DOM 树非常大而且非常深时，性能非常糟糕，这就是我们的用户最近更新他们的应用程序时发生的事情，这波更新也导致了他们的页面明显臃肿起来（这是他们那边的性能问题，是另外的话题了）。

**使用 `.concat` 合并 15000 个平均拥有 5 个元素的数组需要花费 6 秒的时间。**

**纳尼？**

6 秒……

仅仅是 15000 个数组，而且平均只拥有 5 个元素？

**数据量并不是很大。**

为什么这么慢？合并数组有没有更快的方法呢？

* * *

## 基准比较

### .push vs. .concat，合并 10000 个拥有 10 个元素的数组

所以我开始研究（我指的是谷歌搜索）`.concat` 和 Javascript 中合并数组的其它方式的基准对比。

事实证明，合并数组最快的方式是使用 `.push` 方法，该方法可以接收 n 个参数：

```
// 将 arr2 的内容压（push）入 arr1 中
arr1.push(arr2[0], arr2[1], arr2[3], ..., arr2[n])

// 由于我的数组大小不固定，我使用了 `apply` 方法
Array.prototype.push.apply(arr1, arr2)
```

相比之下，它的速度更快，简直是个飞跃。

有多快？

我自己运行了一些性能基准测试来亲眼看看。瞧，这是在 Chrome 上执行的差别：

[![JsPerf - .push vs. .concat 10000 size-10 arrays (Chrome)](https://res.cloudinary.com/practicaldev/image/fetch/s--I6TQ4Ugm--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/txrl0qpb5oz46mqfy3zn.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--I6TQ4Ugm--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/txrl0qpb5oz46mqfy3zn.PNG)

👉 [链接到 JsPerf 上的测试](https://jsperf.com/javascript-array-concat-vs-push/100)

合并拥有大小为 10 的数组 10000 次，`.concat` 的速度为 0.40 ops/sec（操作每秒），而 `.push` 的速度是 378 ops/sec。也就是说 `push` 比 `concat` 快了整整 945 倍！这种差异可能不是线性的，但在这种小规模数据量上已经很明显了。

在 Firefox 上，执行结果如下：

[![JsPerf - .push vs. .concat 10000 size-10 arrays (Firefox)](https://res.cloudinary.com/practicaldev/image/fetch/s--1syE91oa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/i8qyutk1h1azih06rn4z.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--1syE91oa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/i8qyutk1h1azih06rn4z.PNG)

通常，与 Chrome 的 V8 引擎相比，Firefox 的 SpiderMonkey Javascript 引擎速度较慢，但 `.push` 仍然排名第一，比 `concat` 快了 2260 倍。

我们对代码做了上面的改动，它修复了整个速度变慢的问题。

### .push vs. .concat，合并 2 个拥有 50000 个元素的数组

但好吧，如果你合并的不是 10000 个拥有 10 个元素的数组，而是两个拥有 50000 个元素的庞大数组呢？

下面是在 Chrome 上测试的结果：

[![JsPerf - .push vs. .concat 2 size-50000 arrays (chrome)](https://res.cloudinary.com/practicaldev/image/fetch/s--pmnpnick--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/7euccbt97unwnjjdq5iw.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--pmnpnick--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/7euccbt97unwnjjdq5iw.PNG)

👉 [链接到 JsPerf 上的测试](https://jsperf.com/javascript-array-concat-vs-push/170)

`.push` 仍然比 `.concat` 快, 但这次是 9 倍.

虽然没有戏剧性的慢上 945 倍，但已经很慢了。

* * *

### 更优美的扩展运算

如果你觉得 `Array.prototype.push.apply(arr1, arr2)` 很啰嗦，你可以使用 ES6 的扩展运算符做一个简单的改造：

```
arr1.push(...arr2)
```

`Array.prototype.push.apply(arr1, arr2)` 和 `arr1.push(...arr2)` 之间的性能差异基本可以忽略。

* * *

## 但是为什么 `Array.concat` 这么慢？

它和 Javascript 引擎有很大的关系，我也不知道确切的答案，所以我问了我的朋友 [@picocreator](https://dev.to/picocreator) —— [GPU.js](http://gpu.rocks/) 的联合创始人，他之前花了很多时间研究 V8 的源码。因为我的 MacBook 内存不足以运行 `.concat` 合并两个长度为 50000 的数组，[@picocreator](https://dev.to/picocreator) 还把他用来对 GPU.js 做基准测试的宝贝游戏 PC 借给我跑 JsPerf 的测试。

显然答案与它们的运行机制有很大的关系：在合并数组的时候，`.concat` 创建了一个新的数组，而 `.push` 只是修改了第一个数组。这些额外的操作（将第一个数组的元素添加到返回的数组里）就是拖慢了 `.concat` 速度的关键。

> 我：“纳尼？不可能吧？就是这样而已？但为什么差距这么大？不可能啊！”
> @picocreator：“我可没开玩笑，试着写下 .concat 和 .push 的原生实现你就知道了！”

所以我按照他说的试了试，写了几种实现方式，又加上了和 [lodash](https://lodash.com/) 的 `_.concat` 的对比：

[![JsPerf - Various ways to merge arrays (Chrome)](https://res.cloudinary.com/practicaldev/image/fetch/s--hIgqWvh5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/w00r7grlnl1x5bnprrqy.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--hIgqWvh5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/w00r7grlnl1x5bnprrqy.PNG)

👉 [链接到 JsPerf 上的测试](https://jsperf.com/merge-array-implementations/1)

### 原生实现方式 1

让我们来讨论下第一套原生实现方式:

#### `.concat` 的原生实现

```
// 创建结果数组
var arr3 = []

// 添加 arr1
for(var i = 0; i < arr1Length; i++){
  arr3[i] = arr1[i]
}

// 添加 arr2
for(var i = 0; i < arr2Length; i++){
  arr3[arr1Length + i] = arr2[i]
}
```

#### `.push` 的原生实现

```
for(var i = 0; i < arr2Length; i++){
  arr1[arr1Length + i] = arr2[i]
}
```

如你所见，两者之间的唯一区别是 `.push` 在实现中直接修改了第一个数组。

#### 常规实现方法的结果：

*   `.concat` : 75 ops/sec
*   `.push`: 793 ops/sec (快 10 倍)

#### 原生实现方法 1 的结果：

*   `.concat` : 536 ops/sec
*   `.push` : 11,104 ops/sec (快 20 倍)

结果证明我自己写的 `concat` 和 `push` 比它们的常规实现方法还快……但我们可以看到，仅仅是简单地创建一个新数组并将第一个数组的内容复制给它就可以使整个过程明显变慢。

### 原生实现方式 2（预分配最终数组的大小）

通过在添加元素之前预先分配数组的大小，我们可以进一步改进原生实现方法，这会产生巨大的差异。

#### 带预分配的 `.concat` 的原生实现

```
// 创建结果数组并给它预先分配大小
var arr3 = Array(arr1Length + arr2Length)

// 添加 arr1
for(var i = 0; i < arr1Length; i++){
  arr3[i] = arr1[i]
}

// 添加 arr2
for(var i = 0; i < arr2Length; i++){
  arr3[arr1Length + i] = arr2[i]
}
```

#### 带预分配的 `.push` 的原生实现

```
// 预分配大小
arr1.length = arr1Length + arr2Length

// 将 arr2 的元素添加给 arr1
for(var i = 0; i < arr2Length; i++){
  arr1[arr1Length + i] = arr2[i]
}
```

#### 原生实现方法 1 的结果：

*   `.concat` : 536 ops/sec
*   `.push` : 11,104 ops/sec (快 20 倍)

#### 原生实现方法 2 的结果：

*   `.concat` : 1,578 ops/sec
*   `.push` : 18,996 ops/sec (快 12 倍)

预分配最终数组的大小可以使每种方法的性能提高 2-3 倍。

### `.push` 数组 vs. `.push` 单个元素

那假如我们每次只 .push 一个元素呢？它会比 `Array.prototype.push.apply(arr1, arr2)` 快吗？

```
for(var i = 0; i < arr2Length; i++){
  arr1.push(arr2[i])
}
```

#### 结果

*   `.push` 整个数组：793 ops/sec
*   `.push` 单个元素: 735 ops/sec (慢)

所以 `.push` 单个元素要比 `.push` 整个数组慢，这也说得通。

## 结论：为什么 `.push` 比 `.concat` 更快

总而言之，`concat` 比 `.push` 慢这么多的主要原因就是它创建了一个新数组，还需要额外将第一个数组的元素复制给这个新数组。

现在对我来说还有另外一个迷……

## 另一个迷

为什么常规实现要比原生实现方式慢呢？🤔我再次向 [@picocreator](https://dev.to/picocreator) 寻求帮助。

我们看了一下 lodash 的 `_.concat` 实现，想要获得一些关于 `.concat` 常规实现方法的提示，因为它们在性能上相当（lodash 要快一点点）。

事实证明，根据 `.concat` 常规实现方式的规范，这个方法被重载，并且支持两种传参方式：

1.  传递要添加的 n 个值作为参数，例如：`[1,2].concat(3,4,5)`
2.  传递要合并的数组作为参数，例如：`[1,2].concat([3,4,5])`

你甚至可以这样写：`[1,2].concat(3,4,[5,6])`

Lodash 一样做了重载，支持两种传参方式，lodash 将所有的参数放入一个数组，然后将它拍平。所以如果你给它传递多个数组的也可以说得通。但是当你传递一个需要合并的数组时，它将不仅仅使用数组本身，而是将它复制到一个新的数组中，然后再把它拍平。

……好吧……

所以绝对可以对性能做优化。这也是你为什么想要自己实现合并数组的原因。

此外，这只是我和 [@picocreator](https://dev.to/picocreator) 基于 Lodash 的源码以及他对 V8 源码略微过时的了解，对 `.concat` 的常规实现如何在引擎中工作的理解。

你可以在空闲的时间点击[这里](https://github.com/lodash/lodash/blob/4.17.11/lodash.js#L6913)阅读 lodash 的源码。

* * *

### 补充说明

1.  我们的测试仅仅使用了包含整数的数组。我们都知道 Javascript 引擎使用规定类型的数组可以更快地执行。如果数组中有对象，结果预计会更慢。
    
2.  以下是用于运行基准测试的 PC 的规格：

[![PC specs for the performance tests](https://res.cloudinary.com/practicaldev/image/fetch/s--rsJtFcLH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/fl7utbii6ivyifs66q2t.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--rsJtFcLH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/fl7utbii6ivyifs66q2t.PNG)
    

* * *

## 为什么我们在 UI-licious 测试期间会进行如此大的数组操作呢？

[![Uilicious Snippet dev.to test](https://res.cloudinary.com/practicaldev/image/fetch/s--5llcnkKt--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/gyrtj5lk2b2bn89z7ra1.gif)](https://snippet.uilicious.com/test/public/1cUHCW368zsHrByzHCkzLE)

从工作原理上来说，UI-licious 测试引擎扫描目标应用程序的 DOM 树，评估语义、可访问属性和其他常见模式，来确定目标元素以及测试方法。

这样我们就可以确保像下面这样简单地编写测试：

```
// 跳转到 dev.to
I.goTo("https://dev.to")

// 在搜索框进行输入和搜索
I.fill("Search", "uilicious")
I.pressEnter()

// 我应该可以看见我自己和我的联合创始人
I.see("Shi Ling")
I.see("Eugene Cheah")
```

没有使用 CSS 或 XPATH 选择器，这样可以使测试更易读，对 UI 中的更改也不太敏感，并且更易于维护。

### 注意：公共服务公告 —— 请保持小数量的 DOM！

不幸的是，由于人们正在使用现代前端框架来构建越来越复杂和动态的应用程序，DOM 树有越来越大的趋势。框架是一把双刃剑，它允许我们更快地开发，但是人们常常忘记框架平添了多少累赘。在检查各种网站的源代码时，那些单纯为了包裹其他元素而存在的元素的数量经常会吓到我。

如果你想知道你的网站是否有太多 DOM 节点，你可以运行 [Lighthouse](https://developers.google.com/web/tools/lighthouse/) 查看。

[![Google Lighthouse](https://res.cloudinary.com/practicaldev/image/fetch/s--OZ3aIjva--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://developers.google.com/web/progressive-web-apps/images/pwa-lighthouse.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--OZ3aIjva--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://developers.google.com/web/progressive-web-apps/images/pwa-lighthouse.png)

根据 Google 的说法，最佳 DOM 树是：

*   少于 1500 个节点
*   深度少于 32 级
*   父节点拥有少于 60 个子节点

对 Dev.to feed 的快速检查表明它的 DOM 树的大小非常好：

*   总计 941 个节点
*   最大深度为 14
*   子元素的最大数量为 49 个

还不错！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
