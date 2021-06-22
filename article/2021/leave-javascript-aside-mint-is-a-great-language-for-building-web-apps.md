> * 原文地址：[Leave JavaScript Aside — Mint Is a Great Language for Building Web Apps](https://betterprogramming.pub/leave-javascript-aside-mint-is-a-great-language-for-building-web-apps-3ce5a6873d48)
> * 原文作者：[Chris Vibert](https://medium.com/@cp.vibert)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/leave-javascript-aside-mint-is-a-great-language-for-building-web-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/leave-javascript-aside-mint-is-a-great-language-for-building-web-apps.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：[Kim Yang](https://github.com/KimYangOfCat)、[Chorer](https://github.com/Chorer)、[PassionPenguin](https://github.com/PassionPenguin)

# 将 JavaScript 放到一边 —— 用 Mint 这门强大的语言来创建一个 Web 应用

![图片由 [Unsplash](https://unsplash.com/s/photos/mint-cocktail?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 用户 [Luca Volpe](https://unsplash.com/@lucavolpe?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)提供。](https://cdn-images-1.medium.com/max/13440/1*-AzcPWEeQ7lrNOGm9VWHVA.jpeg)

最近, 我用 [Mint](https://www.mint-lang.com/) 构建了一个小型的 Web 应用程序, 正如大家所说的那样，这确实是一次**全新**的开发体验。毕竟对于构建 Web 应用来说的，Mint 是一个相对没有那么主流的编程语言。同时它也是一门强类型语言，可以被编译为 JavaScript，并且内置了许多重要的功能。

以上所有这些都意味着，使用 Mint，你可以**非常快速地**构建 Web 应用。

## 为什么使用 Mint

我之所以尝试使用 Mint，是因为我想从非常熟悉的 JavaScript/TypeScript/React/Vue 生态里走出来，做一些改变。Mint 提供了这种改变的可能性。它是一种与众不同的语言，但是使用 Mint 编写的 UI 组件和 React 极为相似：

![](https://cdn-images-1.medium.com/max/2588/1*eNKRgF6r-mKpOfYVh1udEg.png)

通常情况下，当我们想要突破 JavaScript 语言来进行 Web 应用开发时，会尝试选择 [Elm](https://elm-lang.org/) 这门语言。它和 Mint 有很多类似的地方，比如说它的强类型和函数式语言编程风格。我曾经尝试过使用 Elm 进行开发，但是我发现自己的进度太慢了，因为它的学习曲线比较陡峭，有太多的模版代码需要学习。而使用 Mint 却恰恰相反。

## 我做了什么

我**重构**了一个 Chrome 插件。我用 Mint 开发了一个**弹框**，当你点击工具栏中的插件图标时它会弹出，事实上它只是一个小型的单页面 Web 应用。

![](https://cdn-images-1.medium.com/max/2000/1*Jzir0KchJB937yXh7zjvmw.png)

在[源码](https://github.com/cpv123/github-go-chrome-extension)中，你可以查看更多的有关于插件的信息，也可以对比分析 Javascript 版本和优化后的 Mint 新版本。

在我的下一篇文章里，我将会说明如何使用 Mint 来构建一个 Chrome 插件。今天，我们主要讲下日常使用 Mint 构建 Web 应用中我比较中意的几个点。

[Mint 官网](https://www.mint-lang.com/)很友好地展示了 Mint 包含的所有功能。包括来语言特性和 Web 开发框架特点。这里有很多有趣的特性可供选择使用，但是我发现以下两个特性特别棒：

* 更少的外部依赖，因为它自身内置了很多功能
* 更贴近 JavaScript 的语义化编程

## 内置状态管理

使用过 React 的人都知道，`npm install` 是日常开发工作的重要一环，但对于 Mint 来讲，它几乎内置了所有东西。这意味着我们只需要关注极少数的外部依赖（如果需要的话）。

Mint 提供了一套非常简单的全局状态管理方案，类似 Redux，但它不需要过多关注不可变的数据流和组件之间的状态连接。

使用 Mint，你可以定义 [stores](https://www.mint-lang.com/guide/reference/stores)，它包含了应用程序的状态以及更新该状态所需要的函数。任意组件想要获取或者更新某个状态时，都可以使用 `connect` 和 `exposing` 关键字来轻松连接到相关的 store。当 store 中的数据发生改变时，与之相关的组件将会使用新的数据来渲染。

通常情况下，你可以在单独的文件夹中存放 store 和组件，下面是一个示例：

![](https://cdn-images-1.medium.com/max/2456/1*W5wDBfg2iB0MbkkZfl0Ysw.png)

请注意状态值是使用 `next` 关键字来更新的，它专门用于安全地进行状态变更。

## 内置的样式和 CSS

对我而言，内置的样式解决方案绝对是一个惊喜：CSS 的作用域是定义在它的组件内部。并且基于 arguments/props、媒体查询、选择器嵌套以及真正的 CSS 语法等实现可选样式 (比如`align-items` 而不是 `alignItems`)。

感觉像是拥有了 [styled-components](https://styled-components.com/) 的强大功能，但却不需要进行 `npm install`。

如下是一个相对基础的示例，它展示了如何根据参数对 CSS 赋值：

![](https://cdn-images-1.medium.com/max/2516/1*G1HvZDnQy5-DW3BZnlCIPQ.png)

进一步讲，你可以使用组件中的 props 和状态来进行赋值。下面的例子展示了一个按钮如何根据以下情况进行样式转变：

1. 应用程序的原始色值，可以在全局的 **theme store** 中配置。
2. 按钮的 `variant` 属性，可以由 `ButtonVariants` 枚举进行类型定义。

![](https://cdn-images-1.medium.com/max/2016/1*U-3VK_BjR074wB2SZ4xSxA.png)

我们可以根据 `ButtonVariants` 枚举中包含的值对按钮组件进行渲染：

![](https://cdn-images-1.medium.com/max/2700/1*8nBj3UvkJ5HVO_hNqKoJLg.png)

![](https://cdn-images-1.medium.com/max/2000/1*xRLD2GIbZPOg4zqxJgINCg.png)

样式和状态管理只是 Mint 内置功能的两个示例。Mint 还提供了内置路由、代码格式化、测试流、文档工具等更多功能。

## 语义化的 JavaScript —— 在 Mint 中编写 JavaScript 代码

对于绝大多数人而言，语义化是一个锦上添花的特性。但对我来说，它是至关重要的，因为我正在使用 Mint 构建适配 JavaScript Chrome API 的 Chrome 插件。

这是语义化 JavaScript 的一个示例，其中，Mint 调用了一个名为 `handleSubmit` 的 JavaScript 函数，并且传了一个 Mint 的形参给这个函数：

![](https://cdn-images-1.medium.com/max/2000/1*G4umab884w5PXFP-ZEzYnA.png)

Mint 实际上提供了[几种不同的方式](https://www.mint-lang.com/guide/reference/javascript-interop)与 JavaScript 进行交互，这里我们只是展示了最常用的方法：通过单引号包裹的方式内联 JavaScript 代码。这是奏效的，因为  Mint 可以编译为 JavaScript。当你使用 Mint 构建应用程序时，所有的代码最终都会被编译为 JavaScript。

尽管使用内联的方法快捷简便，但它需要进行类型推断，这并不是完全可行的，有的类型可能无法推断出来。在 Mint 中可以通过使用[decode expressions](https://www.mint-lang.com/guide/reference/javascript-interop/decode-expression) 将 JavaScript 对象转化为有明确类型的值，这种方法是类型安全的。

## 结论

总而言之，我使用 Mint 进行开发的经历是很有意义的，有了来自 TypeScript 和 React 的相关知识，使用 Mint 更容易上手，并且其语言核心内置了很多熟悉的概念特性。

我做的只是一个内容简单的小型应用程序，因此我无法确切地说 Mint 同样适用于构建涉及到复杂路由、数据获取、性能考量等元素的大型应用程序。但是，从我个人的角度来讲，Mint 对此早已做好了万全准备。

官方的 [mint-ui](https://ui.mint-lang.com/) 组件库才刚刚发布，这个语言似乎正在受到大家的关注。我希望 Mint 在 2021 年能更上一层楼。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
