> * 原文地址：[“Responsive” Font-Size Using Vanilla CSS](https://levelup.gitconnected.com/responsive-font-size-using-vanilla-css-51f81fe999db)
> * 原文作者：[Jason Knight](https://medium.com/@deathshadow)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/responsive-font-size-using-vanilla-css.md](https://github.com/xitu/gold-miner/blob/master/article/2020/responsive-font-size-using-vanilla-css.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[HurryOwen](https://github.com/HurryOwen)、[JohnieXu](https://github.com/JohnieXu)

# 使用原生 CSS 设置响应式字体

有时需要根据屏幕宽度将字体大小比例进行适配操作。奇怪的是，我见过有人为了实现这个功能经历了重重困难。例如 [Ahmed Sakr](undefined) 在他的文章 [Medium](https://medium.com/javascript-in-plain-english/automatically-scale-font-sizes-with-rfs-ca22549cc802) 中概述的 `RFS` 的使用，尽管他很好地概述了 `RFS` 如何工作的，但在 CSS3 计算和比较时代，[RFS 本身却是过时的淘汰品](https://github.com/twbs/rfs)。

不幸的是，这些问题在那些使用 CSS 预处理器的人中间很常见，而这些程序很像**框架**。 — 创建此类系统的人**和使用这些系统的人**显然不够格编写 HTML 代码，更不用说应用 CSS 了，然后大言不惭地告诉别人如何做。

## 字体单位计算

值得高兴的是，这实际上很容易实现。假设想要最小的字体为 1em，最大的字体为 4em，最大字体的缩放比例基于 75rem。75rem 对应 1600px（适用于普通用户，1rem 代表 16px），1500px（适用于大字体用户，例如我本人，1rem 代表 20px）和 2400px（常用于 4k 设备上，1rem 代表 32px）。

```css
font-size:max(1em, min(4em, calc(100vw * 4 / 75)));
```

你也可以自己计算

```css
font-size:max(1em, min(4em, 5.333vw));
```

数学中的 4 仅需与 min 计算中的 4em 相匹配。

您不再需要大型的 derpy 框架或垃圾预处理器，也不会有任何内存垃圾。这是 CSS 本身足以处理的计算功能。

然后还可以利用 CSS 变量存储各种值，以使其在布局中更容易应用。

## 与其他实现对比

不必使用媒体查询来手动在其他地方声明最大尺寸，我们可以使用 min、max 将最小和最大尺寸硬编码到公式中。一个简单的调用就可以解决所有问题，不必考虑（或编写代码）说（max-width：1200px）或代码带有最大值的单独媒体查询之类的，我们只需将它们全部放入一个声明中即可。

它还允许事物**实际达到最小值**。大多数这样的尝试只会将基本尺寸增加到显示宽度的一小部分，这意味着最小尺寸不是所需要获得的最小尺寸或布局可能达到的最小尺寸。

同样，这是基于 100％EM 的，因此您不会以像素为单位精简可用性和可访问性。再次，正如我在过去的十五年中多次说过的那样，如果您使用 EM 和 ％ 作为字体大小控制单位，则内边距 padding、外边距 margin 和媒体查询也全部都应该基于 EM，不要混用。对于非标准字体大小的用户来说，它最终会混乱崩掉的。就像我这样，我的笔记本电脑和工作站上的像素为 20px == 1REM，媒体中心的像素为 32px == 1EM。

> **似乎所有人都不喜欢豌豆和粥混合在一起。— R. Lutece**

## 原生 CSS 代码

使用简单的页面展示：

```html
<section>
  <h2>Sample Section</h2>
  <p>
   This card uses a relatively simple CSS calculation to rescale <code>margin</code>, <code>padding</code>, <code>font-size</code>, and <code>border-radius</code> between a minimum and maximum size based on screen width.
  </p><p>
   No LESS/SASS/SCSS rubbish, no NPM package trash, just flipping do it with <code>calc</code>, <code>min</code>, <code>max</code> and some native CSS variables. 
  </p>
 </section>
```

首先，我们创建一些变量来处理各种所需的最小和最大尺寸：

```css
:root {
 --base-scale:calc(100vw / 75);
 --h2-font-size:max(1em, min(4em, calc(var(--base-scale) * 4)));
 --padding-size:max(1em, min(2em, calc(var(--base-scale) * 2)));
 --margin-size:max(0.5em, min(2em, calc(var(--base-scale) * 2)));
 --border-radius:max(1em, min(3em, calc(var(--base-scale) * 3)));
}
```

不同的显示屏幕具有不同的宽度，只需将 75 更改为所需的宽度（以 em 为单位）即可。我们只是根据需要来进行计算。

同样，`max(value)` 实际上是你设备的最大尺寸，`min(value)` 是你设备的最小尺寸，并且最后的计算值应该是你设备屏幕显示的最小尺寸 `min(value)`。

实际应用很简单：

```css
main section {
 max-width:40em;
 padding:var(--padding-size);
 margin:var(--margin-size);
 border-radius:var(--border-radius);
 background:#FFF;
 border:1px solid #0484;
}

h2 {
 font-size:var(--h2-font-size);
}
```

结果如何呢？当页面很大时：

![](https://cdn-images-1.medium.com/max/2000/1*NdMmS0zWfYXuARtPoY6gMg.png)

当页面很小时：

![](https://cdn-images-1.medium.com/max/2000/1*qC9Zj2yrRKpKGuBvl-Nnhg.png)

padding、border-radius、heading 的尺寸大小等都会缩小。

## 在线演示

[**使用原生 CSS 设置响应式字体**](https://cutcodedown.com/for_others/medium_articles/responsiveRescale/responsiveRescale.html)

与我所有的示例一样，该目录为：

[https://cutcodedown.com/for_others/medium_articles/responsiveRescale/](https://cutcodedown.com/for_others/medium_articles/responsiveRescale/)

这个项目是开放的，可以轻松访问，并且包含整个项目的 .rar 文件，也可以轻松下载、测试。

随你怎么喜欢怎么操作！

## 不足之处

真正的不足只有一个：旧版浏览器不支持。你知道是哪个吧？**哦，真想好起来！！！**

但是，如果对此感到担心，请一如既往地查阅 “caniuse”。

[https://caniuse.com/css-math-functions](https://caniuse.com/css-math-functions)

除此之外，还有些人会说这太难记了。认真的吗？复制粘贴的工具人！

## 结论

我经常惊讶于人们为了“使它更简单”而投入大量的代码，在这个过程中，你常常会取消对结果的控制。即便使用预处理器或辅助脚本来完成这类操作，也应该很容易将值插入到上面的公式中。不过，老实说，如果你认为花 9k 的 SCSS 来做这件事是值得的...那么，也许是时候离开键盘，开始一些不太注重细节的东西了，比如 macramé。

但说实话，“min” 和 “max” 是**非常新的** CSS 特性 —— 至少在 2020 年是这样 —— 尽管目前的所有浏览器引擎都能够支持。大量预处理 css 样式文件及其他耗时的处理都是为了弥补规范中的空白，确保浏览器兼容性。

**CSS 变量比预编译语言（LESS、SASS、SCSS）中定义变量的方式更优秀，因为你可以动态地更改它们，它会影响调用它的所有东西。通过预处理器，它们被编译出来。对于那些懒得去寻找替换的人来说，我把它们标记为无用的垃圾。实际上本文代码实现很有用！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
