> * 原文地址：[Announcing Ant Design 3.0](https://medium.com/ant-design/announcing-ant-design-3-0-70e3e65eca0c)
> * 原文作者：[Meck](https://medium.com/@yesmeck?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/announcing-ant-design-3-0.md](https://github.com/xitu/gold-miner/blob/master/TODO/announcing-ant-design-3-0.md)
> * 译者：[木羽](https://github.com/zwwill)
> * 校对者：[Usey95](https://github.com/Usey95)，[swants](http://www.swants.cn)


# Ant Design 3.0 驾到

![](https://cdn-images-1.medium.com/max/2000/1*LipB3O0Bt3sdeP4V9ZILeQ.png)

> **[Ant Design](https://ant.design/index-cn) 是一个致力于提升「用户」和「设计者」使用体验，提高「研发者」开发效率的企业中后台设计体系。**

14 个月前我们发布了 **Ant Design 2.0**。期间我们收到了 200 多位贡献者的 PR，经历了大约 4000 个提交和超过 60 个[版本](https://github.com/ant-design/ant-design/releases)

![](https://cdn-images-1.medium.com/max/800/1*lo18e8-74pk6w5jLPy7npA.png)

GitHub 上的 star 数也从 6k 上升到了 20k。

![](https://cdn-images-1.medium.com/max/1000/1*pn8DEp6GwBgoVksi9kwMuw.png)

自 2015 年以来的 GitHub star 趋势。

![](https://cdn-images-1.medium.com/max/800/1*Pyy85SEu0fYxthrWe7vv-A.png)

**今天，我们很高兴地宣布，Ant Design 3.0 正式发布了**。在这个版本中，我们为组件和网站做了全新的设计，引入了新的颜色系统，重构了多个底层组件，加入了新的特性和优化，同时最小化不兼容的更改。[这里](https://ant.design/changelog-cn#3.0.0)可查看到完整的更改日志。

这是我们的主页：[https://ant.design/index-cn](https://ant.design/index-cn)

### 全新的颜色系统

我们的新颜色系统源于天空的启发，因为她的包容性与我们品牌基调一致。基于对天空色彩随时间自然变化的观察，对光和阴影规则的研究，我们重新编写了颜色算法来生成一个[全新的调色板](https://ant.design/docs/spec/colors-cn)，相应的层次也进行了优化。新调色板的感官更年轻，更明亮，灰度过渡得更自然，是感性美和理性美的完美结合。此外，所有主流色值都参照了信息获取标准。

![](https://cdn-images-1.medium.com/max/1000/1*PzbgW3jZA9uyR8JszwLgAw.png)

### 组件的新设计

在之前的版本中，组件的基本字体大小是 12px，我们收到了很多来自社区的反馈，建议我们加大字号。我们的设计师也意识到，在大屏幕普及的今天，14px 是更合适的字体大小。因此，我们将基本字体大小增大到了 14px，并对所有组件的尺寸进行了适配。

![](https://cdn-images-1.medium.com/max/2000/1*NIlj0-TdLMbo_hzSBP8tmg.png)

### 组件重写

我们重写了 `Table` 组件来解决一些历史性问题。引入了一个新的工具 `components`，现在你可以使用这个工具来高度定制 `Table` 组件，这里有一个[示例](https://ant.design/components/table-cn/#components-table-demo-drag-sorting)，可以添加拖拽功能。

`Form` 组件也被重新编写，为表单嵌套提供更好的支持。

另一个重写的组件是 `Steps`，这个重写的 `Steps` 有着更简单的 DOM 结构并且兼容到IE9。

### 全新的组件

这个版本，我们新增了两个组件， **List** 和 **Divider**。

`List` 组件对于文本、列表、图片、段落和其他数据的显示非常方便。与第三方库集成也很简单，例如，您可以使用 [react-virtualized](https://github.com/bvaughn/react-virtualized) 来实现无限加载列表。更详细的例子可以参考 [List](https://ant.design/components/list-cn/) 文档。

`Divider` 组件可用于在不同的章节中分割文本段落，或者将行内文本/链接分开，如表的动态列。详细的示例可以参考 [Divider](https://ant.design/components/divider-cn/) 文档。

### 全面支持 React 16 和 ES 模块

在这个版本中，我们增加了对 React 16 和 ES 模块的支持。如果你正在使用 webpack 3，那么你现在可以通过 `tree-shaking` 和 `ModuleConcatenationPlugin` 来享受 antd 对组件的优化。如果你使用的是 `babel-import-plugin`，只需将 `libraryDirectory` 设置到 `es` 目录。

### 更友好的 TypeScript 支持

在我们的代码中，我们已经删除了所有的隐式 `any` 类型，在您的项目中不再需要配置 `"allowSyntheticDefaultImports": true`。如果您计划使用 TypeScript 来编写项目，请参考我们的新文档 「[在 TypeScript 中使用](https://ant.design/docs/react/use-in-typescript-cn/)」。

### 😍 还有一件事儿

![](https://cdn-images-1.medium.com/max/1000/1*YHn_dMzMYfkIL2Hr5TvXcQ.png)

有些人可能已经知道了，我们正在开发另一个名为 [Ant Design Pro](https://pro.ant.design/) 的项目，它是一个企业级中后台前端/设计解决方案，是基于 Ant Design 3.0 的 React Boilerplate。尽管它还没有达到[ 1.0 版本](https://github.com/ant-design/ant-design-pro/issues/333)。但是随着 antd 3.0 的发布，现在可以投入使用了。

### 接下来

我们的设计师正在重新编写我们的设计指南，并设计一个新的 Ant Design 官网。我们非常高兴能够提供更好的设计语言，以激发更多构建企业级应用的灵感。

为了使 1.0 早日成型，我们的工程师正在投入到 Ant Design Pro 努力工作，同时我们也需要你的帮助来[翻译我们的文档](https://github.com/ant-design/ant-design-pro/issues/120)

### 最后

如果没有你们的支持、反馈和参与，就不可能有今天的成功。感谢优秀的 Ant Design 社区。如果您在使用 antd 时遇到任何问题，可随时在 GitHub [提交问题](https://github.com/ant-design/ant-design/issues/new)。

感谢你的阅读。敬请安装、star、尝试。 🎉

### 链接

*   [Ant Design](https://ant.design)
*   [Ant Design Github Repository](http://github.com/ant-design/ant-design)
*   [Ant Design Pro](https://pro.ant.design/)
*   [Ant Design Mobile](https://mobile.ant.design/)
*   [NG-ZORRO — An Angular Implementation of Ant Design](https://ng.ant.design)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
