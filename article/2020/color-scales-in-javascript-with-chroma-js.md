> * 原文地址：[Color Scales in JavaScript with Chroma.js](https://levelup.gitconnected.com/color-scales-in-javascript-with-chroma-js-b9f59d2a68d7)
> * 原文作者：[Joe T. Santhanavanich](https://medium.com/@joets)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/color-scales-in-javascript-with-chroma-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/color-scales-in-javascript-with-chroma-js.md)
> * 译者：
> * 校对者：

# Color Scales in JavaScript with Chroma.js

#### Coloring your app with this powerful tiny JavaScript library!

![Photo by [Daniele Levis Pelusi](https://unsplash.com/@yogidan2012?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10806/0*8vuqBAz5TLSVD38h)

Many developers design Color codes and scale with the CSS, pick the color from some online color palette. However, it is not everyone's favorite tool. The good news is we have the Chroma.js, a small library that can be a big help with generating the color scale within the JavaScript code. This means you can plug it into your JavaScript framework directly!

#### Let’s get started!

## Install

In your web application, you can use a link from CDNJS in your HTML doc

```
<script src="https://cdnjs.cloudflare.com/ajax/libs/chroma-js/2.1.0/chroma.min.js" integrity="sha512-yocoLferfPbcwpCMr8v/B0AB4SWpJlouBwgE0D3ZHaiP1nuu5djZclFEIj9znuqghaZ3tdCMRrreLoM8km+jIQ==" crossorigin="anonymous"></script>
```

Or, you can install it using the NPM as well.

```
$ npm install chroma-js
```

## Example Usage

You can simply create a color scale within your JavaScript code with chroma.scale([\<color1>,\<color2>, ... , \<color n>]) function which will create the color scale between the colors you assign.

For example, you can create a color scale from yellow to red with the following script:

```
var color_scale = chroma.scale([‘yellow’, ‘red’]);
```

Then, you can access the color in RGB or in HEX code by

```
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

There are many more options you can do with the color scale, for example, the color scale based on the [ColorBrewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3). Mixing more color codes.

Here are some more examples:

```
chroma.scale('Spectral');
```

![**10 classes of Color Scale output from chroma.scale(‘Spectral’)** (by Author)](https://cdn-images-1.medium.com/max/2000/1*PpS1nMb_piYOuk4ENWWBWA.png)

```
chroma.scale('RdPu');
```

![**10 classes of Color Scale output from chroma.scale(‘RdPu’)** (by Author)](https://cdn-images-1.medium.com/max/2116/1*11Y1xrUSthjj1yNvMMJyzA.png)

```
chroma.scale('RdPu').domain([1,0]); // reverse color scales
```

![**10 classes of Color Scale output from chroma.scale(‘RdPu’).domain([1,0])** (by Author)](https://cdn-images-1.medium.com/max/2118/1*zqTLSKzHFpZ4VhYBhW7s4w.png)

#### That’s about it!

If you like this tool, you can find more advanced tutorials at [https://gka.github.io/chroma.js/](https://gka.github.io/chroma.js/) if you need color manipulation combining in the scaling methods. Overall, I hope you like this article and be able to apply this tool to your application or project.

Be **Safe** and **Healthy**! Have fun coding!

**Thank you for Reading. 👋**😄

![](https://cdn-images-1.medium.com/max/2554/0*hOOIt9JjQXekqlXg.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
