> * 原文地址：[Color Scales in JavaScript with Chroma.js](https://levelup.gitconnected.com/color-scales-in-javascript-with-chroma-js-b9f59d2a68d7)
> * 原文作者：[Joe T. Santhanavanich](https://medium.com/@joets)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/color-scales-in-javascript-with-chroma-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/color-scales-in-javascript-with-chroma-js.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：

# JavaScript 颜色处理库 Chroma.js 的应用

![Photo by [Daniele Levis Pelusi](https://unsplash.com/@yogidan2012?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10806/0*8vuqBAz5TLSVD38h)

许多开发人员用 CSS 设计颜色代码和比例，从一些在线调色板中选择颜色。然而，它并不是每个人都喜欢的工具。好消息是我们有 Chroma.js，这是一个很小的库，对于在 JavaScript 代码中生成色阶有很大帮助。这意味着您可以直接将其插入到 JavaScript 代码框架中！

#### 让我们开始吧！

## 启动安装

在 web 应用程序中，可以在 HTML 文档中使用 CDNJS 的链接。

```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/chroma-js/2.1.0/chroma.min.js" integrity="sha512-yocoLferfPbcwpCMr8v/B0AB4SWpJlouBwgE0D3ZHaiP1nuu5djZclFEIj9znuqghaZ3tdCMRrreLoM8km+jIQ==" crossorigin="anonymous"></script>
```

或者，也可以使用 NPM 安装它。

```bash
$ npm install chroma-js
```

## 示例用法

您只需在 JavaScript 代码中使用 chroma.scale([\<color1>,\<color2>, ... , \<color n>]) 函数，将在指定的颜色之间创建色阶。

例如，可以使用以下 JavaScript 代码创建从黄色到红色的颜色比例：

```js
var color_scale = chroma.scale([‘yellow’, ‘red’]);
```

然后，您可以通过以下方式访问 RGB 或十六进制代码中的颜色：

```js
color_scale(0).rgb()    // [255, 255, 0]
color_scale(0.1).rgb()  // [255, 230, 0]
color_scale(0.2).rgb()  // [255, 204, 0]
color_scale(0.3).rgb()  // [255, 179, 0]
...
color_scale(1.0).rgb()  // [255, 0, 0]

===================================

color_scale(0).hex()    // "#ffff00"
color_scale(0.1).hex()  // "#ffe600"
color_scale(0.2).hex()  // "#ffcc00"
color_scale(0.3).hex()  // "#ffb300"
...
color_scale(1.0).hex()  // "#ff0000"
```

![**10 classes of Color Scale output from chroma.scale([‘yellow’, ‘red’])** (by Author)](https://cdn-images-1.medium.com/max/2112/1*RJ74UXMa6nqmEUyGIZI4Pg.png)

您可以使用色阶执行更多选项，例如，基于 [ColorBrewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3) 的色阶，混合更多颜色代码。

以下是更多示例：

```js
chroma.scale('Spectral');
```

![**10 classes of Color Scale output from chroma.scale(‘Spectral’)** (by Author)](https://cdn-images-1.medium.com/max/2000/1*PpS1nMb_piYOuk4ENWWBWA.png)

```js
chroma.scale('RdPu');
```

![**10 classes of Color Scale output from chroma.scale(‘RdPu’)** (by Author)](https://cdn-images-1.medium.com/max/2116/1*11Y1xrUSthjj1yNvMMJyzA.png)

```js
chroma.scale('RdPu').domain([1,0]); // 反转色阶
```

![**10 classes of Color Scale output from chroma.scale(‘RdPu’).domain([1,0])** (by Author)](https://cdn-images-1.medium.com/max/2118/1*zqTLSKzHFpZ4VhYBhW7s4w.png)

#### 应用总结

如果您喜欢这个颜色处理库，可以在 [https://gka.github.io/chroma.js/](https://gka.github.io/chroma.js/) 查找更多高级教程，例如在缩放方法中结合颜色处理等等。总的来说，我希望您喜欢本文，并能够将此颜色处理库应用到您的应用程序或项目中。

保持健全安康！快乐写代码！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
