> * 原文地址：[How to make a Pull Request against the ECMAScript specification](https://github.com/tc39/how-we-work/blob/master/pr.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-make-a-Pull-Request-against-the-ECMAScript-specification.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-make-a-Pull-Request-against-the-ECMAScript-specification.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)、[Usualminds](https://github.com/Usualminds)
> * 校对者：[Usualminds](https://github.com/Usualminds)、[kimberlyohq](https://github.com/kimberlyohq)、[Kim Yang](https://github.com/KimYangOfCat)

# 如何针对 ECMAScript 规范创建一个拉取请求

对 JavaScript 规范的所有更改最终都会变为对 [ecma262](https://github.com/tc39/ecma262/) 或 [ecma402](https://github.com/tc39/ecma402/) 存储库的拉取请求。

## 创建一个拉取请求

要创建一个拉取请求（PR），请 [fork](https://help.github.com/articles/fork-a-repo/) [ecma262](https://github.com/tc39/ecma262) 仓库，将变更添加到 spec.html 文件，并将其上传到 GitHub 上之前 fork 的仓库中，使用 Web 端界面提交拉取请求。在本地编辑时，要想查看你在 HTML 中的内容更改，请运行 `npm run build`（通过 [ecmarkup](https://github.com/bterlson/ecmarkup)）将 spec.html 生成为实际的 HTML 文件。

**拉取请求应指定哪个仓库？**：几乎所有规范内容的拉取请求都应针对 ecma262 仓库；ecma402 仓库仅用于存储国际规范（提供国际化的标准库）。

拉取请求中的提交的第一行应该以以下的标记开头，后跟冒号，以说明它们是哪一种修补（patch）类型：

* `Normative:` 变化会以某种方式影响 JavaScript 的行为。这些更改被称为“可观察的”，因为我们可以通过编写代码来“观察”其行为的变化。
* `Editorial:` 对规范文本进行的任何非规范性更改，包括拼写错误、文档样式的更改等。
* `Layering:` 重构规范文本、算法或嵌入钩子的修改，以实现 JavaScript 规范与其他使用 JavaScript 规范的无入侵式的集成。
* `Markup:` 对规范中的标记不可见的更改
* `Meta:` 更改了有关该存储库的文档（例如 readme.md 或 contributing.md）以及其他支持文档或脚本（例如 package.json，设计文档等）

## 第四阶段提案拉取请求（`Normative:`）

[TC39 阶段流程](http://tc39.es/process-document/) 的第四阶段要求将建议书写成与规范相对应的拉取文本；要进入第四阶段，需要[编辑组](https://github.com/tc39/how-we-work/blob/master/management.md#ecma-262-editor-group)针对该拉取请求进行审查，并在第四阶段之后合并该拉取请求。

## 非规范拉取请求

`Editorial`、`Layering`、`Markup` 和 `Meta` 类型的拉取请求不会更改 JavaScript 的行为，但是它们对于正在阅读或使用 JavaScript 规范的人员却很有意义。

如果你要对 JavaScript 规范进行更改，请提出 Issue 进行初步讨论，或者直接创建拉取请求并请求审核。通常，针对拉取请求的审核可以完全在 GitHub 上进行，编者和任何其他想要参与的人都可以参与审核。由于 JavaScript 不会有明显的变化，因此这些拉取请求不需要委员会的明确共识，但是，如果出现了争议，则可以将这个拉取请求提交到委员会，交由委员会处理。

## 规范性拉取请求

规范性拉取请求更改了 JavaScript 程序的功能，可能需要采取行动才能从 JavaScript 引擎实现者以及使用 JavaScript 进行编程的开发者那里进行调整。这是很严肃的事情！因此，规范的拉取请求具有以下要求：

- 必须在 [test262](https://github.com/tc39/test262/) 中提出针对拉取请求的所做的测试。
- 拉取请求必须在委员会中提出。在某些情况下，编者或作者只需对 PR 进行简短描述，如果没有提出任何疑问，则认为该提案“已达成共识”。在其他时候，如果该提案有争议，则需要[准备演示文稿](https://github.com/tc39/how-we-work/blob/master/presenting.md)，更详细地说明动机（这很是有用）。随后将进行讨论，并且委员会将会针对是否可以就该提案达成共识作出回应。因此，有争议的规范性拉取请求会被标记为“需要共识”（`needs consensus`）。

如果你有拟议的拉取请求，并且希望将其推进，请为其编写 test262 测试，并将其放在即将举行的 TC39 会议的议程上。如果你不在委员会中，对你而言重要的事情是要找到一个 TC39 代表来支持该提案，并在委员会的整个过程中（包括进行演示）将其推进。

我们鼓励 TC39 代表们在即将到来的会议议程上主动添加“需要共识”的拉取请求，并对其进行介绍。如果没有人主动提出该拉取请求，编者将在时间允许的情况下将其添加到议程中。

### "网络实际" 拉取请求

有时，JavaScript 规范与大多数或所有 Web 浏览器实现的内容之间会出现不匹配的情况。鉴于网络上的大量代码，很有可能已经有许多网站期望这种行为，但是却没有明确说明，但大体上是部署了的。在这种情况下，最有用的事情通常是更改规范，而不是更改所有 JavaScript 实现，以匹配“网络实际”。

### 实施反馈

在许多情况下，收集有关实施规范的拉取请求的实际状况、是否实现对某些不太重要的修改感兴趣等方面，获取外界的反馈是有用的。对于这些情况，委员会可能会要求构建一个或多个实现（可能只是在 fork 中或被隐藏在 flag 中），然后再合并规范拉取请求。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
