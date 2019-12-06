> * 原文地址：[Why Coding Your Own Makes You a Better Developer](https://medium.com/better-programming/why-coding-your-own-makes-you-a-better-developer-5c53439c5e4a)
> * 原文作者：[Danny Moerkerke](https://medium.com/@dannymoerkerke)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-coding-your-own-makes-you-a-better-developer.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-coding-your-own-makes-you-a-better-developer.md)
> * 译者：[quzhen12](https://github.com/quzhen12)
> * 校对者：[jiapengwen](https://github.com/jiapengwen), [Baddyo](https://github.com/Baddyo)

# 为什么自己动手写代码能让你成为更好的开发者

> 要想真正地理解轮子，你需要重新造轮子

![Photo by [Jon Cartagena](https://unsplash.com/@cartega?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*nbaB-g7qNeIhN7iN)

前几天，我参与了一个关于 JavaScript 开发人员的高级开发岗位面试。我的同事在这次面试中要求面试者写一个能执行 HTTP 调用的函数，如果没有成功的话可以多次尝试。

当他开始在白板上写代码之后，其实写伪代码就可以了。如果他对这个问题理解的比较好，我们也会比较开心。但是很不幸，他不能给出一个好的解决方案。

考虑到他可能比较紧张，我们决定降低难度让他写一个将回调的函数转换为 Promise 的函数。

运气有点差。

当然，我可以说他以前看过类似的代码。他或多或少知道它是如何工作的。一个伪代码的解决方案就可以证明他理解那个概念。

但是他在白板上写的代码完全没有意义的。他对 JavaScript Promise 的概念只有模糊的理解，无法很好地解释它。

如果你是初级的开发者，你可以避免这种情况，但是如果你想申请一个高级开发者的职位，做到这些还是不够的。他要如何调试复杂的 Promise 链并且向他人解释他做了什么呢？

---

## 开发者习惯于抽象

作为开发者，我们的工作中充满抽象概念。我们将本来需要重复的代码概念化。因此，当我们专注于更重要的部分时，会不假思索地将这些概念进行运用并**假设**它们有效。

一般说来，它们的确有效，但当遇到复杂情况时**真正理解**这些抽象代码就很有价值了

那位高级开发职位的应试者不假思索地就写出来这段 promise 抽象的代码。如果是在某处看到这段代码的话他大概懂得如何运用，但是他并没有真正**弄懂**它的意义，所以无法在工作面试中重现这段代码。

他本可以直接把这段代码背下来，这其实一点都不难：

```js
return new Promise((resolve, reject) => {
  functionWithCallback((err, result) => {
   return err ? reject(err) : resolve(result);
  });
});
```

我就这么干过。也许，我们都这么干过。把一段代码背下来以便直接使用，多少明白一点它的意义。

但是假如他真正理解这段代码，就没**必要**死记硬背了。那段代码会**了然于胸**，绝不会写不出来。

---

## 理解源代码

早在 2012 年，在前端-后端模式流行之前，jQuery 是世界的佼佼者，我当时正在阅读 jQuery 创始人 John Resig 写的 “[Secrets of the JavaScript Ninja](https://www.manning.com/books/secrets-of-the-javascript-ninja)” 。

这本书教你如何从零开始创建自己的 jQuery ，让你理解创建库后面的思维过程。尽管 jQuery 在随后几年淡出了大众视线，我还是强烈推荐读一下这本书。

读这本书时我最深的一个感悟是，我总感觉自己本应该能想得出这个主意。里面描述的步骤非常符合逻辑并且非常直白，真让我觉得只要我当时想，jQuery 本该是**我**建的。

当然，现实中，我永远不可能做到 —— 我准会认为那太过复杂。我准会觉得自己的方法太过简单幼稚不可能有效而放弃。我会理所当然认为 jQuery 才是有效的。后面我可能根本不会花时间研究它为什么有效。我会把它当成个黑箱子那样使用。

读这本书改变了我。我开始阅读源代码然后发现许多解决方法都十分直接，甚至明显。

现在，自己设计解决方法当然完全是另一回事。但是阅读源代码然后自己重新启用已有方法，恰恰是能帮你写出自己的代码的方法。

作为开发者，这个过程中你得到的灵感和学到的方法会让你改变。你将发现，你所使用和以为神奇的库其实并不神奇，只是个简洁聪明的方案。

理解代码需要花费时间，一步步来，但也能让你经历创始人当初经历的同样一点一点逐渐前进的脚步。这让你更理解编程过程，也让你更有信心去创建自己的方案。

当我开始使用 JavaScript 的 Promise 时，我认为它们充满魔力。后来我明白它们只不过是基于回调，我对于编程的看法永远地改变了。

旨在摆脱回调的这种模式是使用……**回调来实现的？**

这改变了我。我意识到这些代码对我来说并不是复杂到无法理解。如果我有足够的好奇心和意志力去投入进入就能轻易理解。

这就是学会编程的真正法门。这就是成为更好的开发者的途径。

---

## 重新造轮子

去吧，去造你自己的轮子。编写[自己的数据绑定](https://medium.com/swlh/https-medium-com-drmoerkerke-data-binding-for-web-components-in-just-a-few-lines-of-code-33f0a46943b3?source=friends_link&sk=09dd590e07b3300bae4b63dbb716cc39)，编写[自己的 Promise](https://hackernoon.com/implementing-javascript-promise-in-70-lines-of-code-b3592565af0f) 甚至是[自己的状态管理解决方案](https://css-tricks.com/build-a-state-management-system-with-vanilla-javascript/)。

即使不会有人使用也没关系。你会从中成长。如果你能把它用在自己的一个项目中，就很好了。你会开发得更好并成长更多。

重点是不要把你的方案用在生产上，而是在学习中。针对已有的方案编辑自己的执行代码是向最优秀的人学习的好方法。

**这就是成为更优秀的开发者的方法。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
