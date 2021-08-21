> * 原文地址：[11 Rare JavaScript One-Liners That Will Amaze You](https://betterprogramming.pub/11-rare-javascript-one-liners-that-will-amaze-you-331659832301)
> * 原文作者：[Can Durmus](https://medium.com/@candurmuss)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/11-rare-javascript-one-liners-that-will-amaze-you.md](https://github.com/xitu/gold-miner/blob/master/article/2021/11-rare-javascript-one-liners-that-will-amaze-you.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Z招锦](https://github.com/zenblofe)、[KimYangOfCat](https://github.com/KimYangOfCat)

# 11 个让你惊叹的罕见 JavaScript 单行代码

![Source: [Pexels](https://www.pexels.com/photo/blue-eyed-man-staring-at-the-mirror-54377/)](https://cdn-images-1.medium.com/max/8576/1*-0ag6JFjkLmmXTJVVZPVmA.jpeg)

如果你想给专业开发人员留下深刻印象，你会怎么做？这很简单：用简易的策略和尽量少的代码来解决一个复杂的难题。随着 ES6 引入了箭头函数功能，我们可以创建看起来优雅又简单的单行代码。

在本文中，您将学习 11 种罕见但功能强大的单行代码。那么，准备好，让我们从第一个开始吧！

## 1. 获取字符串中的字符数

获取字符数是一个很实用的功能，在许多场景下都很适用。你可以使用它来获取空格数和随后的单词数，或者用于获取字符串中某个分隔符的统计次数。

![](https://cdn-images-1.medium.com/max/2412/1*4JTq7Wv6G1Tu0GUkHjJqNA.png)

```js
const characterCount = (str, char) => str.split(char).length - 1
```

这个想法非常简单。我们使用传递的参数 `char` 拆分字符串并获得返回数组的长度。在每一次分割字符串时，结果都会比分割符多 1。减去 1，我们就有了一个 `characterCount` 的单行代码。

## 2. 检查对象是否为空

检查对象是否为空实际上比想像中要困难得多。即使对象为空，但每次检查该对象是否等于 `{}` 都会返回 `false`。

幸运的是，下面的单行代码实现了我们想要完成的事。

![](https://cdn-images-1.medium.com/max/3100/1*raLs5fvNEPlEUQnU4z-Chw.png)

```js
const isEmpty = obj => Reflect.ownKeys(obj).length === 0 && obj.constructor === Object
```

在这一行中，我们检查对象的键的长度是否等于 0，以及传递的参数是否为对象。

## 3. 等待一定时间后执行

在这个单行代码中，我们将接触一些简单的异步编程概念。在运行代码时，如果你想等待一定的时间，这是 `wait` 的单行代码：

![](https://cdn-images-1.medium.com/max/3448/1*zED3kVo1HB1p-rMsEB-rbw.png)

```js
const wait = async (milliseconds) => new Promise((resolve) => setTimeout(resolve, milliseconds));
```

在 `wait` 这个单行代码中，我们创建一个 Promise 对象并在给定的时间后使用 `setTimeout` 函数完成它。

## 4. 获取两个日期之间的天数差

在开发 Web 应用程序时，日期通常是最容易令人混淆的部分，因为这里有很多容易导致误算的概念。

这是一个强大的单行代码来计算两个日期之间的天数差。但这还没结束。和我一样，你可以创建自己的单行代码来计算月数差、年数差等。

![](https://cdn-images-1.medium.com/max/3416/1*pWjSKnUvpmNYGi2F7VZWLQ.png)

```js
const daysBetween = (date1, date2) => Math.ceil(Math.abs(date1 - date2) / (1000 * 60 * 60 * 24))
```

这个单行代码背后的逻辑很容易理解。当两个日期相减时，差值以毫秒为单位返回。要将毫秒转换为天，我们必须将其除以毫秒、秒、分钟和小时。

## 5. 重定向到另一个 URL

如果你曾经创建过一个真实的网站，我敢肯定你会遇到身份验证逻辑。例如，非管理员用户不应该能够访问 `/admin` 路由。如果用户尝试访问它，那么你必须将其重定向到另一个 URL。

这个单行代码正好适用于我上面提到的情况，但我认为你可以找到更多的使用场景。

![](https://cdn-images-1.medium.com/max/2000/1*Ab_JYkkPUZ1wdOksFFqGZQ.png)

```js
const redirect = url => location.href = url
```

`location` 是全局 `window` 对象中的一个方法，设置 `href` 属性的行为与用户单击链接的行为相同。

## 6. 检查设备是否支持触屏

随着可以连接到互联网的设备越来越多，创建响应式网站的必要性也越来越高。20 年前，开发者应该考虑过桌面版网站，但今天超过 50% 的网络流量来自触摸设备。因此，采取一些行动以支持设备的触屏是非常重要的。

![](https://cdn-images-1.medium.com/max/4056/1*hCg1ziRq2M2JniqKfc2sBA.png)

```js
const touchSupported = () => ('ontouchstart' in window || DocumentTouch && document instanceof DocumentTouch)
```

在这一行中，我们在检查 `document` 是否支持 `touchstart` 事件。

## 7. 在元素后插入一串 HTML

在开发 Web 应用程序时，使用 JavaScript 更新 DOM 是一件很常见的事情。JavaScript 内置的一些基本的方法可以完成这项任务，但是当情况变得复杂时，事情就变得很难克服。

这是在 HTML 元素之后立即注入一串 HTML 的单行代码。通过几分钟的思考和谷歌搜索，我相信你可以找到这个单行**之前**的版本。

![](https://cdn-images-1.medium.com/max/2840/1*52MWqa-s4AMOMSKOIqgODw.png)

```js
const insertHTMLAfter = (html, el) => el.insertAdjacentHTML('afterend', html)
```

## 8.  打乱数组

在开发中，打乱一组数据是你随时可能遇到的常见情况，不幸的是，JavaScript 中没有内置这种方法。

为此，这里提供了一个能让你可以每天使用的单行 `shuffle` 代码：

![](https://cdn-images-1.medium.com/max/2336/1*__MeJCilbgX-QPSqpquOYQ.png)

```js
const shuffle = arr => arr.sort(() => 0.5 - Math.random())
```

它利用了数组的 `sort` 方法，通过在前一个元素的之前或之后插入下一个元素来进行随机排序。

## 9. 在网页上获取选定的文本

浏览器在全局 `windows` 对象上有一个名为 `getSelection` 的内置方法。使用此方法，你可以创建一个单行代码，返回网页上被框选的文本。

![](https://cdn-images-1.medium.com/max/2840/1*HKml5QxPBuZWWymaNC26GQ.png)

```js
const getSelectedText = () => window.getSelection().toString()
```

## 10. 获取一个随机布尔值

在编程时，尤其是在编写游戏时，有时你会想要某些行为被随机的执行。在这种情况下，下面的单行代码让事情变得非常方便。

![](https://cdn-images-1.medium.com/max/2080/1*xpI9zORD0YwiQwtd1Qr_0w.png)

```js
const getRandomBoolean = () => Math.random() >= 0.5
```

上面的代码有 50/50 的机会返回 `true` 或 `false`，因为生成的随机数大于 0.5 的概率等于小于 0.5 的概率。

但是，举例来说，如果你想获得一个概率为 70% `false` 的随机布尔值，那么您可以简单地将 0.5 更改为 0.7，依此类推。

## 11. 计算数组的平均值

计算数组的平均值有很多种方法，但每个的逻辑都是一样的。你必须获得数组的总和及其长度，然后相除得出平均值。

![](https://cdn-images-1.medium.com/max/2652/1*z2pUB4_rZKS7vfbW4YDubw.png)

```js
const average = (arr) => arr.reduce((a, b) => a + b) / arr.length
```

在 `average` 这个单行代码中，我们使用 `reduce` 以便能只用一行就获取到数组的总和，而不是使用循环。然后，我们将其除以数组长度，这就是数组的平均值。

---

就这些了，大家！现在你已经了解了 11 个简单但功能强大的 JavaScript 单行代码。我试着选择了那些不是很知名的代码，这样你就可以学习新东西。我每天都在使用它们，我想你也会。

感谢你的阅读。如果你喜欢这篇文章，记得点赞。如果你对这篇文章有什么想说的，请留言。下一篇文章见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
