> * 原文地址：[5 reasons why Deno will stop using TypeScript - StartFunction](https://startfunction.com/deno-will-stop-using-typescript/)
> * 原文作者：[eliorivero](https://en.gravatar.com/eliorivero)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-Deno-will-stop-using-TypeScript-StartFunction.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-Deno-will-stop-using-TypeScript-StartFunction.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)
> 
# Deno 将停用 TypeScript 的五个原因

![image](https://user-images.githubusercontent.com/8282645/109243795-858b9e00-7818-11eb-9779-00cf8282c99f.png)

最近有一份流传的文档，说是 Deno 将停止在其内部代码中使用 TypeScript。文档中提到了当前开发环境的几个问题，包括了 TypeScript 编译时间、结构和代码管理等。在未来，Deno 的内部代码将使用原生 JavaScript 进行开发。

## Deno 使用 TypeScript 的现存问题

目前 Deno 团队在内部代码中使用 [TypeScript](https://startfunction.com/tag/typescript) 时，遇到的问题有如下这些：

- 当更改文件时，TypeScript 的编译需要几分钟，这使得项目文件的连续编译非常缓慢。
- 在创建实际的 Deno 可执行文件和面向用户的 API 文件时，使用的 TypeScript 结构会造成项目运行的性能问题。
- 事实证明，TypeScript 本身对 Deno 代码管理没有帮助，并且 Deno 团队正经受着相反的效果。在项目的议题列表中就提到一个[问题](https://github.com/denoland/deno/issues/4748)：在两个不同的位置产生了相同的独立主体类。
- 必须手动保持内部代码和运行时 TypeScript 声明的同步，因为 TypeScript 编译器对生成 d.ts 文件没有帮助。
- Deno 团队需要去维护两台 TS 编译器主机：一个用于内部代码，另一个用于外部用户代码，尽管两者的目标相似。

## Deno 内部代码删除 TypeScript

[Deno](https://startfunction.com/tag/deno) 团队的目标是删除所有构建时 TS 类型检查和内部代码的捆绑。他们打算将所有运行时代码移动到一个 [JavaScript](https://startfunction.com/category/javascript) 文件中。然而，他们还是使用配套的 d.ts 文件来保存类型定义和文档记录。

值得注意的是，Deno 将只在内部代码中停止使用 TypeScript，Deno 用户代码仍然可以使用 TypeScript，因此会进行类型检查。

虽然 TypeScript 有时被视为 JavaScript 的改进版本，但以上情况表明事实并非如此。它具有任何其他语言一样的缺陷，最重要的问题之一是编译速度慢。从原生 JavaScript 切换到 TypeScript 时，小型项目可能不会在编译时间上出现大幅度的增长，但在大型项目（如复杂的 [React](https://startfunction.com/tag/react) 应用程序）中，它就会很明显。考虑到编译运行时长，Deno 将停止使用 TypeScript 也就不足为奇。

项目开发过程进行的安全性类型检查，在编译时是有代价的。TypeScript 项目有一个关于如何解决和[改进编译时间](https://github.com/microsoft/TypeScript/wiki/Performance)的文档，这是有存在意义的。最有趣的方法之一是采取[项目引用](https://www.typescriptlang.org/docs/handbook/project-references.html)，它允许开发人员将一个大的 TypeScript 代码片段分解成更小的片段。

**阅读更多关于 Deno 停用 TypeScript 的原因。**

关于 Deno 从内部代码中删除 TypeScript 并改用 JavaScript 的完整讨论，可以在[本文](https://docs.google.com/document/d/1_WvwHl7BXUPmoiSeD8G83JmS8ypsTPqed4Btkqkn_-4/preview?pru=AAABcrrKL5k*nQ4LS569NsRRAce2BVanXw#)中找到，Ryan Dahl 与合作者共同讨论了这个问题的解决方案以及如何实现。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
