> * 原文地址：[Why is NanoID Replacing UUID?](https://blog.bitsrc.io/why-is-nanoid-replacing-uuid-1b5100e62ed2)
> * 原文作者：[Charuka Herath](https://charuka95.medium.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-is-nanoid-replacing-uuid.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-is-nanoid-replacing-uuid.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 为什么 NanoID 正在取代 UUID？

![](https://miro.medium.com/max/1400/1*o7-WnAbmlrLnDmfRhl3opQ.jpeg)

[UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) 是软件开发中最常用的通用标识符之一。然而，在过去的几年里，其他的竞品挑战了它的存在。

其中，NanoID 是 UUID 的主要竞争对手之一。

因此，在本文中，我们将展开讨论 NanoID 的功能、它的亮点以及它的局限性，以便让我们更好地了解何时使用它。

---

## 了解 NanoID 及其用法

对于 JavaScript，生成 UUID 或 NanoID 都非常简单。它们都有对应的 NPM 包来帮助我们实现生成。

我们所需要做的就是运行 `npm i nanoid` 命令安装 [NanoID NPM 库](https://www.npmjs.com/package/nanoid) 并在我们的项目中使用它：

```javascript
import { nanoid } from 'nanoid';  
model.id = nanoid();
```

> 你是否知道 NanoID 每周的 NPM 下载量超过 1175.4 万，并且运行起来比 UUID 快 60%？

此外，NanoID 比 UUID 年轻了将近 7 年，而且它的 GitHub 星数已经比 UUID 多。

下图显示了这两个之间的 npm 趋势比较，我们可以看到 NanoID 的上升趋势与 UUID 的平坦进展有强烈的对比。

![](https://miro.medium.com/max/1400/1*OIOSOm8uIfHAJnbTRJvlIQ.png)

<small>[https://www.npmtrends.com/nanoid-vs-uuid](https://www.npmtrends.com/nanoid-vs-uuid)</small>

我希望这些数字已经说服你去尝试 NanoID。

但是，这两者之间的主要区别很简单。它归结为键使用的字母表。

由于 NanoID 使用比 UUID 更大的字母表，因此较短的 ID 可以用于与较长的 UUID 相同的目的。

## 1. NanoID 只有 108 个字节那么大

与 UUID 不同，NanoID 的大小要小 4.5 倍，并且没有任何依赖关系。此外，大小限制已用于将大小从另外 35% 减小。

大小减少直接影响数据的大小。例如，使用 NanoID 的对象小而紧凑，能够用于数据传输和存储。随着应用程序的增长，这些数字变得明显起来。

## 2. 更安全

在大多数随机生成器中，它们使用不安全的 `Math.random()`。但是，NanoID 使用 [`crypto module`](https://nodejs.org/api/crypto.html) 和 [`Web Crypto API`](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)，意味着 NanoID 更安全。

此外，NanoID 在 ID 生成器的实现过程中使用了自己的算法，称为 [统一算法](https://github.com/ai/nanoid/blob/main/index.js)，而不是使用“随机 % 字母表” `random % alphabet`。

## 3. 它既快速又紧凑

NanoID 比 UUID 快 60%。与 UUID 字母表中的 36 个字符不同，NanoID 只有 21 个字符。

```text
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyz-
```

此外，NanoID 支持 14 种不同的编程语言，它们分别是：

```text
C#、C++、Clojure 和 ClojureScript、Crystal、Dart & Flutter、Deno、Go、Elixir、Haskell、Janet、Java、Nim、Perl、PHP、带字典的 Python、Ruby、Rust、Swift
```

## 4. 兼容性

它还支持 PouchDB、CouchDB WebWorkers、Rollup 以及 React 和 Reach-Native 等库。

我们可以使用 `npx nanoid` 在终端中获得唯一 ID。在 JavaScript 中使用 NanoID 唯一的要求是要先安装 NodeJS。

![](https://miro.medium.com/max/1352/1*DB4RlTcwQ_2qwHSNY2mp2A.png)

此外，我们还可以在 [Redux toolkit](https://redux-toolkit.js.org/api/other-exports) 中找到 NanoID，并将其用于其他用例，如下所示；

```javascript
import { nanoid } from ‘@reduxjs/toolkit’  
console.log(nanoid()) //‘dgPXxUz\_6fWIQBD8XmiSy’
```

## 5. 自定义字母

NanoID 的另一个现有功能是它允许开发人员使用自定义字母表。我们可以更改文字或 id 的大小，如下所示：

```javascript
import { customAlphabet } from 'nanoid';  
const nanoid = customAlphabet('ABCDEF1234567890', 12);  
model.id = nanoid();
```

在上面的示例中，我将自定义字母表定义为 `ABCDEF1234567890`，并将 Id 的大小定义为 12。

## 6. 没有第三方依赖

由于 NanoID 不依赖任何第三方依赖，随着时间的推移，它能够变得更加稳定自治。

从长远来看，这有利于优化包的大小，并使其不太容易出现依赖项带来的问题。

---

## 局限性和未来重点

根据 StackOverflow 中的许多专家意见，使用 NanoID 没有明显的缺点或限制。

非人类可读是许多开发人员在 NanoID 中看到的主要缺点，因为它使调试变得更加困难。但是，与 UUID 相比，NanoID 更短且可读。

另外，如果你使用 NanoID 作为表的主键，如果你使用相同的列作为聚集索引也会出现问题。这是因为 NanoID 不是连续的。

### 在将来……

NanoID 正逐渐成为 JavaScript 最受欢迎的唯一 id 生成器，大多数开发人员更喜欢选择它而不是更喜欢 UUID。

![](https://miro.medium.com/max/1400/1*dwhmN-DJNpT2uPtvy2ZGjg.png)
<small>来源：[https://www.npmjs.com/package/nanoid](https://www.npmjs.com/package/nanoid)</small>

上述基准测试显示了 NanoID 与其他主要 id 生成器相比的性能。

> 使用默认字母表每秒可生成超过 220 万个唯一 ID，使用自定义字母表每秒可生成超过 180 万个唯一 ID。

根据我使用 UUID 和 NanoID 的经验，考虑到它的小尺寸、URL 友好性、安全性和速度，我建议在任何未来的项目中使用 NanoID 而不是 UUID。

因此，我邀请您在下一个项目中试用 NanoID，并在评论部分与其他人分享您的想法。

感谢阅读！！！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
