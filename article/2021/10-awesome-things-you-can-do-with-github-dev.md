> * 原文地址：[10 Fun Things You Can Do With GitHub.dev](https://dev.to/lostintangent/10-awesome-things-you-can-do-with-github-dev-5fm7)
> * 原文作者：[Jonathan Carter](https://dev.to/lostintangent)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/10-awesome-things-you-can-do-with-github-dev.md](https://github.com/xitu/gold-miner/blob/master/article/2021/10-awesome-things-you-can-do-with-github-dev.md)
> * 译者：[greycodee](https://github.com/greycodee)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)、[airfri](https://github.com/airfri)

# 可以在 GitHub.dev 做的十件有趣的事😎

GitHub 最近发布了 [github.dev](https://github.dev)，它允许你在任何仓库下按下 `.` 然后直接用浏览器在 VS Code 中打开这个仓库。这个简单的操作显著的提高你在 GitHub 上阅读、编辑和分享代码的效率。包括在 iPad 上你也可以轻松的实现以上操作。
> **注意**: 除 `.` 键，你也可以在网址栏中将域名后的 `.com` 改为 `.dev` 也可以达到同样的效果👍.

![](https://res.cloudinary.com/practicaldev/image/fetch/s--VJkNTHVS--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E8hp-_MWEAQRYeB.jpg)

然而，可能不是很明显的是 github.dev 实现了更扣人心弦的功能：一个定制和创建全新的 GitHub 原生工作流的机会。 无需依赖[浏览器扩展](https://github.com/collections/github-browser-extensions)或第三方服务来增强 github.com，你可以轻松地利用你喜爱的编辑器及其[丰富的生态系统](https://marketplace.visualstudio.com/vscode)，直接增强 GitHub。 为了说明我的意思，让我们看一下 Github.dev 今天使之成为可能的 10 个例子🚀

## 1. 💄 个性化

开发人员喜欢个性化他们的编辑器，以使其更高效、更符合人体工程学和视觉吸引力。由于 github.dev 基于 VS Code，因此您可以自定义键绑定、颜色主题、文件图标、片段等。 更酷的是，您可以启用 [设置同步](https://code.visualstudio.com/docs/editor/settings-sync) 并在 VS Code、github.dev 和 [Codespaces](https://github.com/features/codespaces) 之间漫游你的设置。 这样，无论您在哪里阅读/编辑代码，您都会立即感到宾至如归💖

![](https://res.cloudinary.com/practicaldev/image/fetch/s--RSG3mtK5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E9lhmoeXIAM7-Bl.jpg)

## 2.分享深层链接

除了在仓库页面按下 `.`，您还可以在查看 GitHub.com 上的特定文件时按 `.`。 此外，如果您在当前打开的文件中选择一些文本，然后按 `.`，那么当 VS Code 被打开时，它将聚焦该文件并突出显示您的文本选择。 然后，您可以在浏览器中复制 URL，并将其发送给其他人，以便共享 **完全相同的上下文**。 这将开启全新且有趣的方式来交流代码🔥

![](https://res.cloudinary.com/practicaldev/image/fetch/s--yElJmPGE--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E9pdcqiVUAEa13W.jpg)

> **演示：** 点击 [这个链接](https://github.dev/lostintangent/gitdoc/blob/master/src/extension.ts#L26-L27) 查看 [GitDoc 扩展](https://aka.ms/gitdoc) 如何订阅 VS Code 中的 repo 事件。

## 3. ✅ 拉取请求审查

除了在 github.com 上的仓库或文件上点击 `.`，您还可以在查看拉取请求时按下它。 这使您能够使用丰富的多文件视图查看 PR，包括查看和回复评论、建议更改，甚至直接从编辑器批准/合并 PR 的能力。 这使得通过为开发人员提供更好的工具来减少“肤浅的评论”成为可能，而无需克隆或切换分支🙅‍♂️

![](https://res.cloudinary.com/practicaldev/image/fetch/s--AYrXWxQm--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E9I5DW-X0AUINAA.jpg)

> **演示：** 单击[此链接](https://github.dev/microsoft/codetour/pull/153)查看将正则表达式解析器添加到 [CodeTour 扩展](https://aka.ms/codetour)的 PR。

## 4. 📊 编辑图像和图表

除了编辑文本文件，VS Code 还允许添加扩展来[自定义编辑器](https://code.visualstudio.com/api/extension-guides/custom-editors)，这使您可以编辑项目中的任何文件类型。比如安装 [Drawio 扩展](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio)，就可以查看和编辑丰富的图表。

![](https://res.cloudinary.com/practicaldev/image/fetch/s--WDkqu00U--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E8mbuSaX0AAAkEp.jpg)

此外，如果您安装了 [Luna Paint 扩展](https://marketplace.visualstudio.com/items?itemName=Tyriar.luna-paint)，您可以编辑图像（PNG、JPG 等）。

在每种情况下，您的编辑都会自动保存，您可以通过 `Source Control` 选项卡将更改提交/推送回您的 GitHub 仓库。更酷的是，您可以与他人共享图像/图表的深层链接，只要他们安装必要的扩展程序，他们就可以通过完全相同的体验与您合作。 这有效地使 github.dev 成为存储在 GitHub 中的任何文件类型的可破解『画布』😎

## 5. 🗺 代码库演示

学习新的代码库很困难，因为通常不清楚从哪里开始，或者各种文件/文件夹如何相互关联。 使用 github.dev，您可以安装 [CodeTour 扩展](https://aka.ms/codetour)，它允许您创建和播放代码库的指导演练。由于 github.dev 完全在浏览器中可用，因此团队中或社区中的任何人都可以轻松快速上手，而无需在本地安装任何东西。

> **演示：** 打开 [这个仓库](https://github.dev/microsoft/codetour) 并安装 CodeTour。 您将看到一个弹窗，询问您是否愿意参加**入门**之旅。

## 6. 📕 代码片段和 Gists

[Gists](https://gist.github.com) 是开发人员管理和共享代码片段、配置文件、注释等的流行方式。在 github.dev 中，您可以安装 [GistPad 扩展](https://aka.ms/gistpad) 并查看/编辑您的 Gists。这允许您跨多个存储库维护代码片段，并从桌面编辑器以及在 GitHub 上浏览/编辑代码时访问它们。

![](https://res.cloudinary.com/practicaldev/image/fetch/s--W9WuEbZ9--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://pbs.twimg.com/media/E8w8aCiVoAIYOLl.jpg)

## 7. 🎢 Web 游乐场和教程

编码游乐场（例如 CodePen、JSFiddle）是一种流行的学习编程语言/库，然后与他人分享的方式。 使用 github.dev，您可以安装 [CodeSwing 扩展](https://aka.ms/codeswing) 并开始创建 Web Playground，使用您现有的编辑器设置，并将您的文件保存回 GitHub。

> **演示：** 打开[这个仓库](https://github.dev/lostintangent/rock-paper-scissors) 并安装 CodeSwing 和 CodeTour。 几秒钟后，您将看到 Playground 环境。

## 8. ✏️ 笔记和知识库

VS Code 是世界一流的 Markdown 编辑器，因此，您可以开始使用 github.dev 来编辑和预览您的所有个人笔记/文档。 更酷的是，您可以安装 [WikiLens 扩展](https://aka.ms/wikilens) 以获得类似 [Roam](https://roamresearch.com/) 或 [obsidian](https://obsidian.md/) 的编辑体验，来维护一个知识库，不仅能将其存储在 GitHub 中而且能从 VS Code 的扩展/个性化生态系统受益。

## 9. 📓 Jupyter Notebooks

除了编码 playgrounds 之外，另一种流行的学习和共享代码的方式是 Jupyter 笔记本。 如果你在 github.dev 中打开一个 `.ipynb` 文件，你可以立即查看笔记本的单元格和缓存输出。 更好的是，您可以安装 [Pyodide 扩展](https://marketplace.visualstudio.com/items?itemName=joyceerhl.vscode-pyodide)，以便实际运行 Python 代码，且是完全在您的浏览器中运行的！

## 10. 🛠 创建您自己的扩展！

您可能已经注意到，上面的大多数功能都是通过扩展启用的，这是别人创建并发布到市场的。由于 VS Code [完全可扩展](https://code.visualstudio.com/api/references/vscode-api)，使用简单的 JavaScript API，您可以创建自己的扩展，不仅支持 VS Code 桌面，而且还支持 [github.dev](https://github.com/microsoft/vscode-docs/blob/vnext/api/extension-guides/web-extensions.md)。所以，如果你有一个很棒的想法，关于如何使在 GitHub 上编码更高效和有趣，那么你现在已经拥有起步所需的一切🏃

## 🔮 期待

虽然 GitHub.dev 已经有大量用法，但它仍处于早期阶段，因此随着生态系统的不断创新，这是一个值得关注的领域。例如，我很高兴看到这样一个激动人心的时刻🙌 ，那就是[实时协作](https://aka.ms/vsls)、[课堂作业](https://marketplace.visualstudio.com/items?itemName=GitHub.classroom) 和 [在线演讲](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode) 可以很快成为能在浏览器中执行的并建立在 GitHub 存储库之上的场景示例💯 

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
