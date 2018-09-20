> * 原文地址：[Next Generation Package Management](https://blog.npmjs.org/post/178027064160/next-generation-package-management)
> * 原文作者：[The npm Blog](https://blog.npmjs.org)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/next-generation-package-management.md](https://github.com/xitu/gold-miner/blob/master/TODO1/next-generation-package-management.md)
> * 译者：[diliburong](https://github.com/diliburong)
> * 校对者：[CoderMing](https://github.com/CoderMing) [tvChan](https://github.com/tvChan)

# 下一代包管理工具

如果希望在后台仅仅通过 Node 就能达到非常快的依赖安装速度该怎么办？如果你希望依赖项中的每个文件都可以保证与注册表中的文件是完全一致该怎么办？如果在新项目上工作就像克隆和运行一样简单呢？如果你的构建工具并不合适怎么办？

下面将介绍 [`tink`](https://t.umblr.com/redirect?z=https%3A%2F%2Fgithub.com%2Fnpm%2Ftink&t=NDM0Zjk2ZmNkNTVkNTU4NDlmNzNkNDQwMWE3YTMwNjI0OTMyNTg5Yix2SGt2amVPVg%3D%3D&b=t%3AnXsLs1P4AptPf1fBr_nFxw&p=https%3A%2F%2Fblog.npmjs.org%2Fpost%2F178027064160%2Fnext-generation-package-management&m=1)，一个 `install-less` 安装程序的概念验证实现。

`tink` 作为 Node.js 本身的替代品，以你现有的 `package-lock.json` 文件为工作基础。在没有 `node_modules` 目录的项目上尝试之后你会发现，即使从来没有运行过安装，依旧可以使用 `require` 关键词来导入任何依赖项。第一次运行也许需要花费几秒钟的时间来下载和提取包的压缩文件。但是之后的运行几乎能够瞬间完成，即使依旧会核查来确保 `package-lock.json` 中的所有内容都在系统上。

你会注意到的第一件事是这些模块实际上都没有放入 `node_modules` 目录下，唯一能找到的就是一个 `.package-map.json` 文件。这个文件中包含了已安装的包模块中的所有文件的哈希值。你可以放心地获取所请求的内容，因为它们在加载前已经被验证过了。（如果验证失败，则文件将从其原始源获取，所有过程都是透明的）。

不过我们并不会良莠不分全盘否定之前的方案。你仍然可以将内容安装入 `node_modules` 目录，这些版本相对缓存版本来说会被优先使用。这为依赖项的实时编辑（有时是必要的调试技术）打开了一条路径，并支持修改软件包发行版中的像 postinstall 这样钩子脚本。

`tink` 是一个改变我们与 Node.js 项目以及 npm 注册表相关联方式的机会。是否应该在模块中使用 `requrie` 或者 `import` 关键词而不是在 `package.json` 来添加依赖？是否应该默认提供一些像兼容 babel 的 ES Module、typescript 以及 jsx 这样非常受欢迎的功能？这些是我们一直在问自己的问题，我们很乐意听到您所期望的下一代体验。请来 [npm.community](https://t.umblr.com/redirect?z=https%3A%2F%2Fnpm.community&t=MzE1YThiMDY5NDdlM2U2ZGExZGJjYWQwODYzZjJmMjI5NTkzNThlYix2SGt2amVPVg%3D%3D&b=t%3AnXsLs1P4AptPf1fBr_nFxw&p=https%3A%2F%2Fblog.npmjs.org%2Fpost%2F178027064160%2Fnext-generation-package-management&m=1) 告诉我们。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
