> * 原文地址：[Announcing Ant Design 3.0](https://medium.com/ant-design/announcing-ant-design-3-0-70e3e65eca0c)
> * 原文作者：[Meck](https://medium.com/@yesmeck?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/announcing-ant-design-3-0.md](https://github.com/xitu/gold-miner/blob/master/TODO/announcing-ant-design-3-0.md)
> * 译者：
> * 校对者：

# Announcing Ant Design 3.0

![](https://cdn-images-1.medium.com/max/2000/1*LipB3O0Bt3sdeP4V9ZILeQ.png)

> [**Ant Design**](https://ant.design/) _which is specially created for enterprise internal desktop applications, is committed to improving the experience of users, designers and developers._

We released **Ant Design 2.0** 14 months ago. In those 14 months we received PRs from more than 200 contributors.Underwent about 4,000 commit and over 60 [releases](https://github.com/ant-design/ant-design/releases).

![](https://cdn-images-1.medium.com/max/800/1*lo18e8-74pk6w5jLPy7npA.png)

The number of GitHub star also rose all the way from 6k to 20k.

![](https://cdn-images-1.medium.com/max/1000/1*pn8DEp6GwBgoVksi9kwMuw.png)

GitHub trending since 2015.

![](https://cdn-images-1.medium.com/max/800/1*Pyy85SEu0fYxthrWe7vv-A.png)

**Today, we are happy to announce that Ant Design 3.0 has finally been released 🎉.** In this release we made a completely new design for components and websites, introduced a new color system, refactored code for multiple underlying components, introduced new features and improvements while minimizing incompatible changes. See full change logs [here](https://ant.design/changelog#3.0.0).

Here is our home page: [http://ant.design/](http://ant.design/)

### New Color System

Our new color system is inspired by the sky, because its inclusiveness coincide with the tone of our brand. Based on the natural sky color change with time and the research on the light and shade rules, we rewrote our color algorithm to generate a [brand new palettes](https://ant.design/docs/spec/colors), and the corresponding gradation levels are optimized too. The senses of new color palette is younger, brighter, and grayscale transitions more natural, a perfect blend of sensual and rational beauty. In addition, all dominant color values ​​take into account accessibility standards.

![](https://cdn-images-1.medium.com/max/1000/1*PzbgW3jZA9uyR8JszwLgAw.png)

### New Design of Components

In previous version, the basic font size of the component was 12px, and we received many feedbacks from community to request us increasing the font size. Our designers are also aware that today the big screen is very common, 14px is a more appropriate font size. So we increased the base font size for to 14px and resized the dimensions of all the components to accommodate this change.

![](https://cdn-images-1.medium.com/max/2000/1*NIlj0-TdLMbo_hzSBP8tmg.png)

### Rewrote components

We rewrote the `Table` component to resolve some long living issues. A new prop `components` was introduced, with this props you can highly customize `Table` component now, here is a [example](http://beta.ant.design/components/table/#components-table-demo-drag-sorting) to add drag & drop feature to table.

`Form` component also has been rewrote to provide a better support for nested fields.

Another rewrote component is `Steps`, with this rewrote `Steps` has a simpler DOM structure and IE9 compatibility.

### New Components

This version we added two new components, _List_ and _Divider_.

List components can be very convenient for text, lists, pictures, paragraphs and other data display. And easy integration with third-party libraries, for example, you can use [react-virtualized](https://github.com/bvaughn/react-virtualized) to achieve infinite loading list. More detailed examples can refer to the [List](https://ant.design/components/list/) document.

The Divider component can be used to split paragraphs of text in different chapters or to split in-line text / links, such as the action column of a table. Detailed examples can refer to the [Divider](https://ant.design/components/divide) document.

### Full support for React 16 and ES Module

In this version we added support for React 16 and ES module. If you are using webpack 3 then you can now enjoy the optimization of antd’s components by Tree Shaking and Module Concatenation. If you’re using `babel-import-plugin`, just set `libraryDirectory` to the `es` directory.

### More friendly TypeScript support

We’ve removed all the implicit `any` types in our code, and we no longer requires `"allowSyntheticDefaultImports": true` in your project. If you happen to have projects that you plan to write using TypeScript, please refer to our new documentation “[Using in TypeScript](https://ant.design/docs/react/use-in-typescript/)” .

### 😍 One More Thing…

![](https://cdn-images-1.medium.com/max/1000/1*YHn_dMzMYfkIL2Hr5TvXcQ.png)

Some people may already know it, we are working on another project named [Ant Design Pro](https://pro.ant.design/), it’s a out-of box UI solution and a React boilerplate for enterprise applications based on Ant Design 3.0\. Though it has not reached its [1.0 release](https://github.com/ant-design/ant-design-pro/issues/333) yet. But with antd 3.0 releasing, you can use it in production now.

### What’s Next

Our designers are working on rewritting our design guideline documentation and designing a new website for Ant Design. We are very exited to provide a better design language to inspire more ideas of building enterprise applications.

And our engineers are working hard on Ant Design Pro to make 1.0 happen, which also need your help to [translate our documents](https://github.com/ant-design/ant-design-pro/issues/120).

### Conclusion

It’s not possible to reach here without your supports, feedbacks, and participations. Thanks to the awesome Ant Design community. If you encounter any problems when using antd, feel free to [file a new issue](https://github.com/ant-design/ant-design/issues/new) on GitHub.

Thanks for reading. Go install it, star it, and give it a try! 🎉

#### Links

*   [Ant Design](https://ant.design)
*   [Ant Design Github Repository](http://github.com/ant-design/ant-design)
*   [Ant Design Pro](https://pro.ant.design/)
*   [Ant Design Mobile](https://mobile.ant.design/)
*   [NG-ZORRO — An Angular Implementation of Ant Design](https://ng.ant.design)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
