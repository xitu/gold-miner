
> * 原文地址：[How writing custom Babel & ESLint plugins can increase productivity & improve user experience](https://medium.com/@kentcdodds/how-writing-custom-babel-and-eslint-plugins-can-increase-your-productivity-and-improve-user-fd6dd8076e26)
> * 原文作者：[Kent C. Dodds](https://medium.com/@kentcdodds)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-writing-custom-babel-and-eslint-plugins-can-increase-your-productivity-and-improve-user.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-writing-custom-babel-and-eslint-plugins-can-increase-your-productivity-and-improve-user.md)
> * 译者：[H2O2](https://github.com/H2O-2)
> * 校对者：[MJingv](https://github.com/MJingv)，[zyziyun](https://github.com/zyziyun)

# 自定义 Babel 和 ESLint 插件是如何提高生产率与用户体验的

---

![](https://cdn-images-1.medium.com/max/2000/1*5eWvduloSZ5sSGd0TGUSWA.jpeg)

一个正在探索**森林**的人（来源：[https://unsplash.com/photos/ZDhLVO5m5iE](https://unsplash.com/photos/ZDhLVO5m5iE)）

# 自定义 Babel 和 ESLint 插件是如何提高生产率与用户体验的

**而且比你想象的容易很多...**

**我的[前端大师课程 「程序变换（code transformation）与抽象语法树（AST）」](https://frontendmasters.com/courses/linting-asts/)已经发布了🎉 🎊（进入网址查看课程的简介）！我觉得你们应该都有兴趣了解为什么要花上 3 小时 42 分钟来学习编写 Babel 和 ESLint 插件**

构建应用程序是件困难的事，并且难度会随着团队和代码库的扩张而增大。幸运的是，我们有诸如 [ESLint](http://eslint.org/) 和 [Babel](https://babeljs.io/) 这样的工具来帮助我们处理这些逐渐成长的代码库，防止 bug 的产生并迁移代码，从而让我们可以把注意力集中在应用程序的特定领域上。

ESLint 和 Babel 都有活跃的插件社区 (如今在 npm 上 [「ESLint plugin」](https://www.npmjs.com/search?q=eslint%20plugin&amp;page=1&amp;ranking=optimal) 可以搜索出 857 个包，[「Babel Plugin」](https://www.npmjs.com/search?q=babel%20plugin) 则可以搜索出 1781 个包)。正确应用这些插件可以提升你的开发体验并提高代码库的代码质量。

尽管 Babel 和 ESLint 都拥有很棒的社区，你往往会遇到其他人都没遇到过的问题，因此你需要的特定用途的插件也可能不存在。另外，在大型项目的代码重构过程时，一个自定义的 babel 插件比查找/替换正则要有效得多。

> **你可以编写自定义 ESLint 和 Babel 插件来满足特定需求**

### 应在什么时候写自定义的 ESLint 插件

![](https://cdn-images-1.medium.com/max/1200/1*w18mlu-5XnwPK9rQn0JYeQ.png)

ESLint logo

你应该确保修复过的 bug 不再出现。与其通过 [测试驱动开发（test driven development）](https://egghead.io/lessons/javascript-use-test-driven-development)达到这个目的，先问问自己：「这个 bug 是不是可以通过使用一个类型检查系统（如 [Flow](https://flow.org/)）来避免？」 如果答案是否定的，再问自己「这个 bug 是不是可以通过使用 [自定义 ESLint 插件](http://eslint.org/docs/developer-guide/working-with-rules)来避免？」 这两个工具的好处是可以**静态**分析你的代码。

> 通过 ESLint 你 **不需要运行任何一部分代码**即可断定是否有问题。

除了上面所说的之外，一旦你添加了一个 ESLint 插件，问题不仅在代码库的特定位置得到了解决，**该问题在任何一个位置都不会出现了**。这是件大好事！（而且这是测试无法做到的）。

下面是我在 PayPal 的团队使用的一些自定义规则，以防止我们发布曾经出现过的 bug。

- 确保我们一直使用本地化库而不是把内容写在行内。
- 强制使用正确的 React 受控组件（controlled component）行为并确保每个 `value` 都有一个 `onChange` handler。
- 确保 `<button>` 标签总是有 `type` 属性。
- 确保 `<Link>` 组件和 `<a>` 标签总是有合理的 `data` 属性以解析数据。
- 确保只在某个应用或共享文件夹内部导入文件（我们在一个仓库（repo）里有多个应用）。

我们还有更多的规则，但总的来说规则并不多。很赞的一点是，因为我们花了时间去[学习并编写自定义 ESLint 插件](http://kcd.im/fm-asts), 这些 bug 都没有再次出现。

注意：如果某个 bug 无法通过 Flow 或 ESLint 避免，那可能是业务逻辑出了什么问题，你可以回到通过测试的方式来避免此类情况发生（[学习如何测试 JavaScript 项目](http://kcd.im/fm-testing)）。

### 应在什么时候写自定义的 Babel 插件

![](https://cdn-images-1.medium.com/max/1200/1*ZuncrF7DO9VeF1LusgFmPw.png)

Babel logo

如果你在思索：「那个 API 实在太无趣了」或是「我们不能那么做，运行效率太低。」那你就应该考虑写一个自定义的 babel 插件了。

[Babel 插件](https://babeljs.io/docs/plugins/) 允许你调整代码。这一操作既可以在编译时完成（以此来进行一些编译时的优化），也可以是一个一次性的操作（称为「codemod」，你可以把它想象成一种比正则表达式强得多的查找替换功能）。

我很喜欢 Babel 的一个原因：

> Babel 使我们可以同时提升用户和开发者的体验。

下面的例子说明了 babel 插件是如何做到的这一点的。

1. 在登陆界面就加载整个应用十分浪费资源，因此社区采取了「[code-splitting](https://webpack.js.org/guides/code-splitting/)」来避免这种情况。[react-loadable](https://github.com/thejameskyle/react-loadable)则实现了 React 组件的延迟加载。如果你想实现更复杂的功能（如服务器端支持或优化客户端加载），就需要相对复杂的 API 了，然而，[babel-plugin-import-inspector](https://github.com/thejameskyle/react-loadable/blob/3a9d9cf34abff075f3ec7919732f95dc6d9453a4/README.md#babel-plugin-import-inspector) 已经自动为你处理好这一切了。
2. [Lodash](https://lodash.com/) 是一个使用很广泛的 JavaScript 实用程序库，但同时它也很大。一个小窍门是，如果你「cherry-pick」需要用到的方法（比如：`import get from 'lodash/get'`），只有你用到的那部分代码会被最终打包。[babel-plugin-lodash](https://github.com/lodash/babel-plugin-lodash) 插件会让你正常使用整个库（`import _ from 'lodash'`）然后自动 cherry-pick 所需的方法。
3. 我在构建 [glamorous.rocks](https://rc.glamorous.rocks/) 网站（即将上线）时发现，无论用户使用的哪种语言，所有本地化字符串都会被加载！所以我写了[一个自定义的 babel 插件](https://github.com/kentcdodds/glamorous-website/blob/7ab245a4f99af9f217fd9b7d63f59dae1814f08e/other/babel-plugin-l10n-loader.js)基于 `LOCALE` 环境变量加载正确的本地化字符串。这样我们就可以为每种语言创建一个[服务端渲染网站的静态输出](https://github.com/zeit/next.js/blob/dba24dac9db97dfce07fbdb1725f5ed1f9a40811/readme.md#static-html-export)，并开始在服务器端为本地化字符串使用 markdown 了（而我们之前会在 JavaScript 模块里使用 markdown 的字符串，完全是一团乱）。我们可以不再使用令人混乱的「高阶组件（Higher Ordered Component）」来进行本地化，而可以**在服务器上**导入 markdown 文件。最终网站变得更快且对开发者更友好了。

还有很多例子，不过希望这些已经足够让你认识到自定义 Babel 插件所带来的可能性了。

哦对了，你知道那些随着框架和工具主要更新一起推出的 codemods 吗？它们会像施魔法一样 ✨ 把你的代码更新到最新的API（比如 [React 的这个 codemod](https://github.com/reactjs/react-codemod) 或者 [webpack 的这个 codemod](https://github.com/webpack/webpack-cli/blob/master/lib/migrate.js)）。你可以把那些工具写成 babel 插件然后通过 [babel-codemod](https://github.com/square/babel-codemod) 运行（看看[这个 babel-codemod 的演示](https://www.youtube.com/watch?v=Vj9MOXbC43A&amp;index=1&amp;list=PLV5CVI1eNcJipUVm6RDsOQti_MzHImUMD)）。（[通过这篇演讲深入了解 codemods](https://www.youtube.com/watch?v=d0pOgY8__JM)，演讲者 [Chirstoph](https://medium.com/@cpojer)）。

> 我不管你的正则表达式用得有多好，自定义 babel 插件可以让你做得更好。

### 但是到底什么是 AST？我可不是什么火箭专家 🚀 ！

![](https://cdn-images-1.medium.com/max/1200/1*MEh3npM0n7DG5r5Kt0Znmg.png)

astexplorer.net 上一个名为「你也许不需要 jQuery」的 babel 插件演示。打开链接：[http://kcd.im/asteymnnj](http://kcd.im/asteymnnj)
Babel 和 ESLint 都以一个名为抽象语法树（Abstract Syntax Tree，常缩写为 AST）的结构为基础运行。实际上这就是计算机如何读取代码的。Babel 有一个 [名为「babylon」的 JavaScript 语法分析器](https://github.com/babel/babylon)，可以把代码字符串变成一个 AST（其实就是一个 JavaScript 对象），然后 Babel 把一些片段提供给 babel 插件来让你操作。如果是 Babel 则你可以做一些变形，如果是 ESLint 则你可以检查你不希望出现的规则。

我没有计算机科学的文凭。我一年前才开始学习 AST。

> 和 AST 打交道帮助我更深刻地理解了 JavaScript。

### 尝试一下

**我保证，这远没有你想象的困难😱**。你可以学好的。我会给你一步步地解释。而且这门课还有很多非常好的练习帮助你进步。学习如何编写自定义的 ESlint 和 Babel 插件会对你的软件开发之路有帮助，并且会让你的应用变得更好 👍。

[学习程序变换以及使用抽象语法树进行 lint](http://kcd.im/fm-asts)

### 分享一下吧

自定义插件是一个往往令人们生畏或疑惑的主题。如果这篇博文增进了你的理解，请分享给更多人，让他们了解到学习编写自定义 Babel 和 ESLint 插件是多么重要的技能。你可以通过 Medium 的 💚 分享，[发推分享](https://twitter.com/intent/tweet?text=%22How%20writing%20custom%20Babel%20%26%20ESLint%20plugins%20can%20increase%20productivity%20%26%20improve%20user%20experience%22%20https://medium.com/@kentcdodds/fd6dd8076e26%20by%20@kentcdodds%20%F0%9F%91%8D)，或者转推：

[![](https://ws4.sinaimg.cn/large/006tNc79gy1fi6vcdrs4jj315c0wan2n.jpg)](https://twitter.com/kentcdodds/status/886945519909711872)

![](https://cdn-images-1.medium.com/max/1600/1*sjisq4ValabuxUpLAm0O5w.png)
再见！[@kentcdodds](https://twitter.com/kentcdodds)

---

P.S. 还有一些其他（免费）的资源可以帮助你学习 AST。

- [babel 插件手册](https://github.com/thejameskyle/babel-handbook/blob/master/translations/en/plugin-handbook.md)
- [asts-workshop](https://github.com/kentcdodds/asts-workshop)（前端大师课程使用的 repo）
- [使用 AST 编写自定义 Babel 和 ESLint 插件](https://www.youtube.com/watch?v=VBscbcm2Mok&amp;index=1&amp;list=PLV5CVI1eNcJgNqzNwcs4UKrlJdhfDjshf&amp;t=192s)
- [Egghead.io 上一些有关 AST 的课程](http://kcd.im/egghead-asts)

P.S.P.S 我觉得我应该提一下我最近写的两个 babel 插件，它们让我感到很兴奋（[I’m](https://twitter.com/threepointone/status/885884698093899777) [not](https://twitter.com/mitchellhamiltn/status/886441807420182528) [alone](https://twitter.com/rauchg/status/886449097770541057) [either](https://twitter.com/souporserious/status/886803870743121920)）我觉得你们应该看看这些插件。这两个插件的最初版本我都只写了半个小时：

- [babel-plugin-preval](https://github.com/kentcdodds/babel-plugin-preval): 在编译时预分析代码
- [babel-macros](https://github.com/kentcdodds/babel-macros): 使 babel 插件无需配置即可直接导入

在[课程](http://kcd.im/fm-asts)里，我会把所有编写这样的插件需要的知识教给你。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
