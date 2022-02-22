> * 原文地址：[Github Copilot: Review After 3 Months of Usage with Examples](https://javascript.plainenglish.io/github-copilot-review-after-3-months-of-usage-with-examples-74335cd45478)
> * 原文作者：[Volodymyr Golosay](https://medium.com/@golosay)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/github-copilot-review-after-3-months-of-usage-with-examples.md](https://github.com/xitu/gold-miner/blob/master/article/2022/github-copilot-review-after-3-months-of-usage-with-examples.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Alfxjx](https://github.com/Alfxjx)

# 使用了三个月的 Github Copilot，这是我的一些看法……

![在 Shutterstock 上购买的图片，由我编辑 😊](https://cdn-images-1.medium.com/max/2000/1*XADRDVUDatfS1oSAn_Cn8A.png)

三个月前，我被允许加入到 Github Copilot 的测试项目中了。在此期间，我在 Angular、基于 LitElement 的 web 组件、Node.js（TypeScript）和 Vanilla JavaScript 项目中测试了 Copilot。AI 结对编程如何能协助我们？它真的有用吗？让我们一起看下去吧。

## GitHub Copilot 到底是什么？

GitHub Copilot 是由 Github 和 OpenAI 创造的 AI 工具。该工具通过自动代码补全来帮助程序员们编写代码。Visual Studio Code、Neovim 和 JetBrains 的用户已经可以使用这个插件了。

GitHub Copilot 基于 OpenAI Codex 模型，经过自然语言和数十亿行公共源码的训练，其中来源包含 Github 上的项目。

该工具能为你编写代码或提供替代的解决方案。该服务支持所有的编程语言，但在 Python、JavaScript、TypeScript、Ruby、Java 和 Go 语言中表现得最为出色。

根据他们所给出的数据，50% 的 GIthub 开发者仍在试用期结束后（2021 年七月）继续使用该服务。

## 如何使用？

Github Copilot 现在仍在技术预览的状态下；这只对部分的测试者开放。要想加入等候名单，见 [copilot.github.com](https://copilot.github.com/)。

在使用 GitHub Copilot 之前，你首先得下载 Visual Studio Code 插件。

1. 在 Visual Studio Code Marketplace（或 JetBrains Marketplace）里浏览 [GitHub Copilot 插件](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)页面并下载该插件；
2. 打开 Visual Studio Code，你会被提示登录 GitHub 并授权该插件；
3. 授权插件之后，Github 会带你返回到 Visual Studio Code。

安装完成后，创建一个新的文件，你就可以开始编写你的代码了。

举例：

1. 创建一个新的 JavaScript 文件（`.js`）；
2. 声明函数，等待魔法的发生。

![使用 Github Copilot 声明函数](https://cdn-images-1.medium.com/max/2816/1*zEgoTPGdZVZ3hd5HmZJ9jg.gif)

就这么简单。如果你不喜欢建议的代码，你也可以使用快捷键切换选项。

![图片来源于：[copilot.github.com](https://copilot.github.com/) 文档](https://cdn-images-1.medium.com/max/4028/1*rp702SwCtPU2qYj91ZrQnQ.png)

## 可用性

我将从缺点开始讨论，因为缺点的话题不多，而且以一种正向的调调结尾让人感觉比较愉快（？？？）。

### 缺点

首先，我想提一下上方 GIF 中的问题 —— 在使用 Copilot 后，我每次都要手动去除多余的括号。在这三个月里，我时不时都要这样做，尤其是在编写条件或函数的时候。

第二个问题是关于 HTML。我知道 HTML 不是支持的语言之一，但在默认情况下，Github Copilot 每次都会建议代码。或许是我编写的布局太难以预测了，亦或是我倒霉，但我从来没有收到可用的代码补全。

这些就是我想说的了。现在我们来聊聊它的优点。

### 优点

Github Copilot 带来的最大的价值是节省你查阅文档的时间。举例来说，在处理键盘事件时，你是否记得方向键的键码？我可不记得。幸运的是，有了 Copilot，**你就不必记住或上网搜索这些键码了**。反之，你只需要将你的需求写成注释即可。

![Keyboard events handling with 使用 Copilot 处理键盘事件](https://cdn-images-1.medium.com/max/3060/1*kVU6LD8_Ze7Qr8PbV21K3g.gif)

此外，你也不需要搜索**公式**，如**华氏度和摄氏度之间的转换**。

![Convert Fahrenheit to Celsius degrees with Copilot](https://cdn-images-1.medium.com/max/2532/1*xPZF0vI-C5IUwJ1rEFO8Hg.gif)

很棒对吧？

---

Copilot 不仅适用于常用的函数，它能完美地识别文件上下文并利用现有的变量和函数来实现代码补全。

**使用 Github Copilot 编写 API 服务类**：

![使用 Copilot 编写 API](https://cdn-images-1.medium.com/max/3516/1*XyCPuRbbpfWnqI6I4GTVZQ.gif)

Copilot 建议了包含方法的整个类。当我修改构造器并添加 host 和 JWT 字符串时，它也能依据这些变量建议 GET 和 POST 方法。

它也能识别一个 JWT 变量名并理解如何使用它。它添加了一个请求头：`“Authorization”: “Bearer “ + this.jwt`。

---

最后，然我们看看它是如何在类之间运作的。举例来说，Copilot 能分析导入/现有的方法并再利用这些方法，无论它们是否在同一个类或 Object 中。

![Copilot 再利用其他类中的 `get` 方法](https://cdn-images-1.medium.com/max/3520/1*fMoUv9i4QC_vN1Q5MeHTPA.gif)

## 与 Tabnine 相比，Copilot 的表现如何？

Github Copilot v.s. Tabine 的话题在网上常有讨论，甚至 Tabnine 的官网也有一个专门的页面。

![Tabnine 官网上的比较图](https://cdn-images-1.medium.com/max/4848/1*-fWg81zsA37J-jsU6_humQ.png)

> 确实，Copilot 的一个很大的缺点是将代码放到云端分析，因为这对大公司来说可能是一个巨大的安全问题。因此，在使用之前请确保这是被允许的。

出于这个原因，我没有冒险在我的主要工作中使用它。Tabnine 在本地运作；它能很好地保护你的隐私。此外，Tabnine 也可以在没网时运作。

对于其他方面来说，我觉得这些对比是没有意义的 —— 你可以同时使用这两个工具。虽说我使用了标准的 Visual Studio Code IntelliSense，我仍需要经常地删除多余的括号。

 你可以先开始输入一些东西，Tabnine 会建议方法，其余的代码就交由 Copilot 来完成 🤖。

---

Copilot 也为公司留下了一个“陷阱”。在面试中，公司时常会要求面试者完成一个测试题，像是编写算法或是实现 polyfill 等。

如果面试者的电脑上装有 Copilot，那么他只需要简单地将任务输入成注释，其余的工作将由 Copilot 完成。我已经在正真的面试中遇到过如此“机智”的面试者。

---

就如同其他的新技术一样，Copilot 不仅带来了生活上的改善，同时也引出了政策和流程方面的问题。无论如何，我很喜欢 Copilot 并会在我的项目中使用它。

感谢你的阅读！在团队里使用 Copilot 插件之间，请务必获得公司许可。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
