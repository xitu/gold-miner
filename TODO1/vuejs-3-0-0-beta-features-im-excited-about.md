> * 原文地址：[VueJS 3.0.0 Beta: Features I’m Excited About](https://blog.bitsrc.io/vuejs-3-0-0-beta-features-im-excited-about-c70b82fac163)
> * 原文作者：[Nwose Lotanna](https://medium.com/@viclotana)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vuejs-3-0-0-beta-features-im-excited-about.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vuejs-3-0-0-beta-features-im-excited-about.md)
> * 译者：[zhanght9527](https://github.com/zhanght9527)
> * 校对者：[shixi-li](https://github.com/shixi-li)、[xionglong58](https://github.com/xionglong58)、[TUARAN](https://github.com/TUARAN)

# VueJS 3.0.0 Beta：那些令人兴奋的功能

![](https://cdn-images-1.medium.com/max/2560/1*RldyrFWyMYS5mhvUNmkw7g.jpeg)

在撰写本文时，VueJS 3.0.0 已经处于 Beta 阶段。在这篇文章中，我们将会看到 Vue 团队在最新的 ThisDot 在线会议上所展示的关于这个大版本的概述。

![](https://cdn-images-1.medium.com/max/2952/1*jfs5yQ21kQKLCvbvuHmSXA.png)

## Vue JS

Vue JS 是一个非常流行的渐进式 JavaScript 框架，由尤雨溪（Evan You）与超过 284 名的 Vue 社区成员创建。它已经拥有 120 多万用户，由一个只关注视图层的可访问核心库和一个支持该核心库的生态系统组成，Vue 可以帮助你处理大型单页应用中的难题。

#### 生态系统

看到 Vue 的生态系统变得如此庞大，真是太不可思议了。我特别兴奋的一件事是最近发布了支持 VueJS 的 [**Bit.dev**]（https://Bit.dev）。因此，现在 Vue 开发人员终于可以在云组件中心中发布、记录和组织可重用组件了（就像 React 开发人员一样）。每一个新的 VueJS 库或工具都增强了这个伟大的框架，并且其中的一些格外具有影响力（不能够自由地在任意一代码库发布组件对许多开发人员来说都是一个非常糟糕的体验）。

![在 [Bit.dev](https://bit.dev) 发布 React 组件 —— 现在已经支持 VueJS](https://cdn-images-1.medium.com/max/2000/1*Nj2EzGOskF51B5AKuR-szw.gif)

#### This Dot 会议

疫情期间，ThisDot 会议于 4 月 16 日在线上举行，核心团队展示了未来 Vue JS 的发展趋势，这也是我们将在本文中总结的。

## 性能

这个新版本的 Vue JS 是为速度而构建的，在 3.0 版本和之前的 Vue 版本之间有一个明显的速度差异。它的更新性能提高了 2 倍，服务器端渲染的速度提高了 3 倍。组件初始化现在也更高效了，甚至优化了模板编译（Compiler informed fast paths）。虚拟 DOM 也被完全重写了，这个新版本将比以往任何时候都要快。

## 支持 Tree-shaking

在这个版本中，现在还可以支持诸如 tree-shaking 之类的操作。在 Vue 中大多数可选功能现在都是可以 tree-shakable，比如 transition 和 v-model 。这大大减少了 Vue 应用程序的大小，一个 HelloWorld 的文件大小现在是 13.5 kb，而有了复合 API 的支持，它的文件大小可以低至 11.75kb。包含了所有的运行时特性后，一个项目的大小可能只有 22.5 kb。这意味着即使增加了更多的特性，Vue 3.0 仍然比任何的 2.x 版本都要轻量。

## Composition API

Vue 团队引入了一种新的方法来组织代码，最初是在 2.x 版本我们使用了 options。Options 很好，但是在尝试匹配或访问 Vue 逻辑时它有编译器的缺点，还必须处理 JavaScript 的这个问题。因此，composition API 是处理这些问题的更好的解决方案，它还具有在 Vue 组件中使用和重用纯 JS 函数的自由和灵活性，使我们可以写更少的代码。composition API 是这样的:

```js
<script>
export default {
  setup() {
    return {
      average(), range(), median()
    }
  }
} 

function average() { } 
function range() { } 
function median() { }
</script>
```

这让我们会失去 options API 吗？不，相反 composition API 和 options API 可以一起使用。（这让我想起了 React hooks）

## Fragments

就像 React 一样，Vue JS 将在 Vue 3.0.0 版本中引入 fragments, fragments 的主要需求之一是 Vue 模板只能有一个标签。所以像这样的代码块在 Vue 模板会返回一个错误：

```html
<template>   
 <div>Hello</div>   
 <div>World</div>   
</template>
```

我第一次看到这个想法是在 React 16 中实现的，fragments 是模板包装标签，用于构造 HTML 代码，但不会改变语义。就像 Div 标签，但是对 DOM 没有任何影响。对于 fragments，手动渲染函数可以返回数组，并且它的工作方式与 React 中的工作方式类似。

## Teleport

Teleports 在之前被称为 portals ，是一种子节点渲染到父组件以外的 DOM 节点的方式，比如用于弹出窗口甚至 modals 。以前，在 CSS 中处理这个问题通常会很麻烦，现在 Vue 允许你在模板部分使用 \<Teleport> 来处理这个问题。我相信 teleport 的灵感来自React portals，它将与 Vue JS 3.0.0 版本一起发布。

## Suspense

Suspense 是延迟加载期间需要的组件，主要用于包装延迟组件。可以使用 suspense 组件包装多个延迟组件。在 3.0.0 版本中，将引入 Vue JS suspense，以便在嵌套树中等待嵌套的异步依赖项，它可以很好地和异步组件配合使用。

## 更好的 TypeScript 支持

Vue 从 2.x 版本开始已经支持 TypeScript，而对于 3.0.0 版本，Vue 将继续支持 TypeScript 。因此，在支持 TSX 的 Vue 3.0.0 中，可能使用当前最新的 TypeScript 版本生成新项目，而 TS 和 JS 代码以及 api 之间并没有太大区别。类组件仍然受支持（[vue Class component@next](https://github.com/vuejs/vue-Class-component/tree/next) 当前位于 alpha 中）。

## Version 3.0.0 进度报告

根据 GitHub 上的项目时间表，Vue JS 的 3.0.0 版本最初的官方发布计划定于 [2020年第一季度](https://github.com/vuejs/vue/projects/6)，从 2020 年 4 月 16 日开始，Vue 版本 3.0.0 现在处于 beta 阶段！这意味着所有计划中的评论请求都已得到处理和实现，团队现在的重点是库集成。现在有一个对 [Vue CLI here](https://github.com/vuejs/vue-cli-pluging-vue-next) 的实验性支持，还有一个非常简单的基于 [Webpack here](https://github.com/vuejs/vue-next-webpack-preview) 的单文件组件支持。

## 另一个版本

Vue 2.7 是一个小版本，很快就会发布，它可能是 3.0.0 版本正式发布之前 2.x 系列的最后一个版本。它将支持 3.0.0 版本的端口兼容改进，并对不在 3.0.0 版本中的功能给出对应的警告。

## 想要获得支持 ......

可能性很低，但你可能会遇到与 2.x 版本不一致的情况，你必须检查 RFC 中是否已经提出了该问题的解决方案，如果没有，那么需要新建一个 issue。记得 [阅读问题助手](https://new-issue.vuejs.org/?repo=vuejs/vue-next) 指导你新建 issues。

## 结论

以上是 Vue JS 第三版的新功能概述。Vue 的团队已经确定这个版本是市场上最快的前端框架。你可以查看 ThisDot 在线会议的幻灯片 [这里](https://t.co/7TP5ZMtjK4?amp=1)，stay safe and happy hacking！那么，你最喜欢的新功能是什么呢？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
