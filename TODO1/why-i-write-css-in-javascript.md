> * 原文地址：[Why I Write CSS in JavaScript](https://mxstbr.com/thoughts/css-in-js/)
> * 原文作者：[max stoiber](https://mxstbr.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-i-write-css-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-i-write-css-in-javascript.md)
> * 译者：[Ivocin](https://github.com/Ivocin)
> * 校对者：[MacTavish Lee](https://github.com/Reaper622), [Mirosalva](https://github.com/Mirosalva)

# 为什么我用 JavaScript 来编写 CSS

三年来，我设计的 Web 应用程序都没有使用 `.css` 文件。作为替代，我用 JavaScript 编写了所有的 CSS。

我知道你在想什么：“为什么有人会用 JavaScript 编写 CSS 呢？！” 这篇文章我就来解答这个问题。

## CSS-in-JS 长什么样？

开发者们已经创建了[不同风格的 CSS-in-JS](https://github.com/michelebertoli/css-in-js)。迄今为止最受欢迎的，是我和他人共同开发的一个叫做 [styled-components](https://styled-components.com) 的库，在 GitHub 上有超过 20,000 颗星。

如下是它与 React 一起使用的例子：

```
import styled from 'styled-components'

const Title = styled.h1`
  color: palevioletred;
  font-size: 18px;
`

const App = () => (
  <Title>Hello World!</Title>
)
```

这会在 DOM 里渲染一个字体大小为 18px 的浅紫红色的 `<h1>`：

![](https://user-images.githubusercontent.com/26959437/53942001-9c4cfd80-40f4-11e9-80ad-5cc9a4c35c4e.png)

## 为什么我喜欢 CSS-in-JS？

主要是 **CSS-in-JS 增强了我的信心**。我可以在不产生任何意外后果的情况下，添加、更改和删除 CSS。我对组件样式的更改不会影响其他任何内容。如果删除组件，我也会删除它的 CSS。不再是[只增不减的样式表](https://css-tricks.com/oh-no-stylesheet-grows-grows-grows-append-stylesheet-problem/)了！ ✨

**信心**：在不产生任何意外后果的情况下，添加、更改和删除 CSS，并避免无用代码。

**易维护**：再也不需要寻找影响组件的 CSS 了。

尤其是我所在的团队从中获取了很大的信心。我不能指望所有团队成员，特别是初级成员，对 CSS 有着百科全书般的理解。最重要的是，截止日期还可能会影响质量。

使用 CSS-in-JS，我们会自动避开 CSS 常见的坑，比如类名冲突和权重大战（specificity wars）。这使我们的代码库整洁，并且开发更迅速。 😍

**提升的团队合作**：无论经验水平如何，都会避开 CSS 常见的坑，以保持代码库整洁，并且开发更迅速。

关于性能，CSS-in-JS 库跟踪我在页面上使用的组件，只将它们的样式注入 DOM 中。虽然我的 `.js` 包稍大，但我的用户下载了尽可能小的有效 CSS 内容，并避免了对 `.css` 文件的额外网络请求。

这导致交互时间稍微长一点，但是首次有效绘制却会快很多！ 🏎💨

**高性能**：仅向用户发送关键 CSS 以快速进行首次绘制。

我还可以基于不同的状态（`variant="primary"` vs `variant="secondary"`）或全局主题轻松调整组件的样式。当我动态更改该上下文时，该组件将自动应用正确的样式。 💅

**动态样式**：基于全局主题或不同状态设置组件样式。

CSS-in-JS 还提供 CSS 预处理器的所有重要功能。所有库都支持 auto-prefixing，JavaScript 原生提供了大多数其他功能，如 mixins（函数）和变量。

* * *

我知道你在想什么：“Max，你也可以通过其他工具或严格的流程或大量的培训来获得这些好处。是什么让 CSS-in-JS 变得特别？”

CSS-in-JS 将所有这些好处结合到一个好用的包中并强制执行它们。它引导我走向[成功的关键](https://blog.codinghorror.com/falling-into-the-pit-of-success/)：做正确的事情很容易，做错事很难（甚至不可能）。

## 谁在使用 CSS-in-JS？

有上千家公司在生产中使用 CSS-in-JS，包括 [Reddit](https://reddit.com)、[Patreon](https://patreon.com)、[Target](https://target.com), [Atlassian](https://atlaskit.atlassian.com)、[Vogue](https://vogue.de)、[GitHub](https://primer.style/components)、[Coinbase](https://pro.coinbase.com) 等等。([包括本网站](https://github.com/mxstbr/mxstbr.com))

## CSS-in-JS 适合你吗？

如果你使用 JavaScript 框架来构建包含组件的 Web 应用程序，那么 CSS-in-JS 可能非常适合。特别是你所在团队中每个人都理解基本的 JavaScript。

如果你不确定如何开始，我会建议你尝试一下 CSS-in-JS，亲眼看看它有多好！ ✌️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
