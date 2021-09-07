> * 原文地址：[Threats of Using Regular Expressions in JavaScript](https://blog.bitsrc.io/threats-of-using-regular-expressions-in-javascript-28ddccf5224c)
> * 原文作者：[Dulanka Karunasena](https://medium.com/@dulanka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/threats-of-using-regular-expressions-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/threats-of-using-regular-expressions-in-javascript.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)

# 在 JavaScript 中使用正则表达式的隐患

![](https://cdn-images-1.medium.com/max/5760/1*5MYzlcICu2hhNjrtRCjb3A.jpeg)

正则表达式（RegEx）被广泛地运用于 Web 开发中，用作模式匹配及验证等用途。然而，在实际使用中它们会带来一些安全和性能上的风险，并向攻击者敞开大门。

因此，在这篇文章中，我将讨论使用正则表达式前所需注意的两个基本问题。

## 灾难性回溯

正则表达式的算法有两种：

* **确定性有限状态自动机（DFA）** —— 对于给定字符串，每个字符只检查一次。
* **非确定性有限状态自动机（NFA）** —— 多次检查同一个字符，直到找到最佳匹配。

JavaScript 的 RegEx 引擎使用的是 NFA 算法，这会导致灾难性回溯。

为了更好地理解这个问题，让我们考虑以下的 RegEx：

```js
/(g|i+)+t/
```

这个 RegEx 看起来很简单。但是，请别低估它让你付出的代价😯。首先，让我们了解这个 RegEx 背后的含义：

* **`(g|i+)`** —— 这个组检查给定字符串是否由 `g` 或至少一个 `i` 开头。
* 接下来的 `+` 将匹配前面的组一次或多次。
* 字符串应由字母 `t` 结尾。

根据上方的 RegEx，以下的文本被判定为匹配：

```
git
giit
gggt
gigiggt
igggt
```

现在，让我们以一个匹配的字符串作为输入，测试上方的 RegEx。我将使用 `console.time()` 方法：

![匹配的文本](https://cdn-images-1.medium.com/max/2000/1*f6jb5c3Y3nsF6W1SsZucRw.png)

我们可以看到执行速度非常快，即使字符串有点长。

> 但是，当你看到验证不匹配的文本所花费的时间时，你会感到惊讶。

在下方的示例中，字符串以 `v` 结尾，因此与 RegEx 不匹配。然而，它花了大约 429 毫秒，差不多是验证匹配字符串的运行时间的 400 倍。

![不匹配的文本](https://cdn-images-1.medium.com/max/2000/1*zKduT1538LwOWj0x5g9Y7g.png)

> 这个性能上的差异来源于 JavaScript 所使用的 NFA 算法。

在第一次验证成功后，JavaScript 的 RegEx 引擎仍会尝试继续。当它在特定位置失败时，它将回溯到上一个位置并寻找替代路径。

当回溯变得太复杂时，算法就会消耗更多计算能力，造成**灾难性回溯**。

> **备注**：欲了解回溯的复杂度，你可以访问 [regex101.com](https://regex101.com/) 并测试你的 RegEx。[regex101.com](https://regex101.com/) 显示使用上述 RegEx 验证 `giiiit` 只需要 10 个步骤，而验证 `giiiiv` 则需要 189 个步骤。

---

## Node.js 环境上的 ReDoS 攻击

> 攻击者能利用灾难性回溯来攻击 Node.js 服务器。

由于 JavaScript 是单线程的，ReDoS 攻击能耗尽事件循环，造成服务器无响应，直到请求完成为止。

我将使用 Moment.js 库来演示这一点，因为在低于 2.15.2 的 Moment.js 的版本中存在一个著名的 ReDoS 漏洞。

```js
var moment = require('moment');
moment.locale("be");
moment().format("D                               MMN MMMM");
```

在这个示例中，日期格式有 40 个字符，其中包括 31 个附加空格。由于灾难性回溯，这些空格将使运行时间增加一倍。在我的本地环境中，它耗时超过 4 分钟。

![运行结果](https://cdn-images-1.medium.com/max/2000/1*YUOV_B0E8SHaL_6ys3cDhQ.png)

`/D[oD]?(\[[^\[\]]*\]|\s+)+MMMM?/` 中 `+` 运算符的过度使用造成了这个漏洞。幸运的是，该问题由 [Snyk](https://snyk.io/)（一个漏洞追踪工具）提出后便在更高的版本中得到了修复。

## 如何规避 RegEx 的漏洞

### 1. 编写简单的 RegEx

当 RegEx 中包含至少 3 个字符，且包含至少两个彼此接近的 `*`、`+` 和 `}` 时，灾难性回溯就会发生。

所以，如果你能简化你的 RegEx 并避免使用以上的样式，那么你便能避免灾难性回溯。

### 2. 使用验证库

对于常用的验证任务，我们可以使用第三方库，例如 [validator.js](https://www.npmjs.com/package/validator) 或 [express-validator](https://www.npmjs.com/package/express-validator)。

我们可以依赖这些库，因为它们的背后有一个大型社区的支持。

### 3. 使用 RegEx 分析器

你能通过使用 [safe-regex](https://www.npmjs.com/package/safe-regex)、[rxxr2](https://www.cs.bham.ac.uk/~hxt/research/rxxr2/) 等工具来编写无漏洞的 RegEx。它们将检查你的 RegEx 是否存在漏洞并返回其合法性。

```js
var safe = require('safe-regex');

var regex = /(g|i+)+t/;
console.log(safe(regex)); // false
```

### 4. 避免使用 Node.js 默认的 RegEx 引擎

由于 Node.js 默认的 RegEx 引擎容易受到 ReDoS 攻击，我们可以避免使用它，并以其他引擎作为替代，例如：Google 的 [re2](https://www.npmjs.com/package/re2) 引擎。它确保 RegEx 可以安全地抵御 ReDoS 攻击，用法也与 Node.js 默认的 RegEx 引擎相似。

```js
var RE2 = require('re2');

var re = new RE2(/(g|i+)+t/);
var result = 'giiiiiiiiiiiiiiiiiiit'.search(re);
console.log(result); // false
```

这将被判定为 `false`，因为这个正则表达式容易受到灾难性回溯的影响。

## 主要收获

灾难性回溯是正则表达式中最常见的问题。它不仅影响应用程序的性能，也向 ReDoS 攻击者敞开大门，导致 Node.js 服务器被攻击。

在这篇文章中，我们讨论了灾难性回溯和 ReDoS 的原理，以及规避这些问题的方法。

我希望这篇文章能帮助你保护你的应用程序免受此类攻击。别忘了在留言区分享你的看法。

感谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
