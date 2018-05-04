> * 原文地址：[Let’s make multi-colored icons with SVG symbols and CSS variables](https://medium.freecodecamp.org/lets-make-your-svg-symbol-icons-multi-colored-with-css-variables-cddd1769fca4)
> * 原文作者：[Sarah Dayan](https://medium.freecodecamp.org/lets-make-your-svg-symbol-icons-multi-colored-with-css-variables-cddd1769fca4)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/lets-make-your-svg-symbol-icons-multi-colored-with-css-variables.md](https://github.com/xitu/gold-miner/blob/master/TODO/lets-make-your-svg-symbol-icons-multi-colored-with-css-variables.md)
> * 译者：[PTHFLY](https://github.com/pthtc)
> * 校对者：[cherry](https://github.com/sunshine940326)、[Raoul1996](https://github.com/Raoul1996)

# 使用 SVG 符号和 CSS 变量实现多彩图标

![](https://cdn-images-1.medium.com/max/1000/1*WO5mgu0bcFNdt7R6JH6mhQ.png)

使用图片和 CSS 精灵制作 web 图标的日子一去不复返了。随着 web 字体的爆发，图标字体已经成为在你的 web 项目中显示图标的第一解决方案。

字体是矢量，所以你无须担心分辨率的问题。他们和文本一样因为拥有 CSS 属性，那就意味着，你完全可以应用 `size` 、 `color` 和 `style` 。你可以添加转换、特效和装饰，比如旋转、下划线或者阴影。

![](https://cdn-images-1.medium.com/max/800/0*3CipXJBmc9h8Q-68.png)

怪不得类似 Font Awesome 这类项目仅仅在 npm 至今已经被下载了[超过 1500 万次](http://npm-stats.com/~packages/font-awesome)。

**可是图标字体并不完美**, 这就是为什么越来越多的人使用行内 SVG 。CSS Tricks 写了[图标字体劣于原生 SVG 元素的地方](https://css-tricks.com/icon-fonts-vs-svg)：锐利度、定位或者是因为跨域加载、特定浏览器错误和广告屏蔽器等原因导致的失败。现在你可以规避绝大多数这些问题了，总体上使用图标字体是一个安全的选择。

然而，还是有一件事情对于图标字体来说是绝对不可能的：**多色支持**。只有 SVG 可以做到。

**摘要** _：这篇博文深入阐述怎么做和为什么。如果你想理解整个思维过程，推荐阅读。否则你可以直接在 [CodePen](https://codepen.io/sarahdayan/pen/GOzaEQ) 看最终代码。_ 

### 设置 SVG 标志图标

行内 SVG 的问题是，它会非常冗长。你肯定不想每次使用同一个图标的时候，还需要复制/粘贴所有坐标。这将会非常重复，很难阅读，更难维护。

通过 SVG 符号图标，你只需拥有一个 SVG 元素，然后在每个需要的地方引用就好了。

先添加行内 SVG ，隐藏它之后，再用 `<symbol>` 包裹它，用 `id` 对其进行识别。

```
<svg xmlns="http://www.w3.org/2000/svg" style="display: none">
  <symbol id="my-first-icon" viewBox="0 0 20 20">
    <title>my-first-icon</title>
    <path d="..." />
  </symbol>
</svg>
```

_整个 SVG 标记被一次性包裹并且在 HTML 中被隐藏。_

然后，所有你要做的是用一个 `<use>` 标签将图标实例化。

```
<svg>
  <use xlink:href="#my-first-icon" />
</svg>
```

_这将会显示一个初始 SVG 图标的副本。_

![](https://cdn-images-1.medium.com/max/800/0*QRBjEA0KVeKcjGBy.png)

**就是这样了！**看起来很棒，是吧？

你可能注意到了这个有趣的 `xlink:href` 属性：这是你的实例与初始 SVG 之间的链接。

需要提到的是 `xlink:href` 是一个弃用的 SVG 属性。尽管大多数浏览器仍然支持，**你应该用**  `**href**` 替代。现在的问题是，一些浏览器比如 Safari 不支持使用 `href` 进行 SVG 资源引用，因此你仍然需要提供 `xlink:href` 选项。

安全起见，两个都用吧。

### 添加一些颜色

不像是字体， `color` 对于 SVG 图标没有任何作用：你必须使用 `fill` 属性来定义一个颜色。这意味着他们将不会像图标字体一样继承父文本颜色，但是你仍然可以在 CSS 中定义它们的样式。

```
// HTML
<svg class="icon">
  <use xlink:href="#my-first-icon" />
</svg>
// CSS
.icon {
  width: 100px;
  height: 100px;
  fill: red;
}
```

在这里，你可以使用不同的填充颜色创建同一个图标的不同实例。

```
// HTML
<svg class="icon icon-red">
  <use xlink:href="#my-first-icon" />
</svg>
<svg class="icon icon-blue">
  <use xlink:href="#my-first-icon" />
</svg>
// CSS
.icon {
  width: 100px;
  height: 100px;
}
.icon-red {
  fill: red;
}
.icon-blue {
  fill: blue;
}
```

这样就可以生效了，但是不**完全**符合我们的预期。目前为止，我们所有做的事情可以使用一个普通的图标字体来实现。我们想要的是在图标的位置可以有不同的颜色。我们想要向每个**路径**上填充不同颜色，而不需要改变其他实例，我们想要能够在必要的时候重写它。

首先，你可能会受到依赖于特性的诱惑。

```
// HTML
<svg xmlns="http://www.w3.org/2000/svg" style="display: none">
  <symbol id="my-first-icon" viewBox="0 0 20 20">
    <title>my-first-icon</title>
    <path class="path1" d="..." />
    <path class="path2" d="..." />
    <path class="path3" d="..." />
  </symbol>
</svg>
<svg class="icon icon-colors">
  <use xlink:href="#my-first-icon" />
</svg>
// CSS
.icon-colors .path1 {
  fill: red;
}
.icon-colors .path2 {
  fill: green;
}
.icon-colors .path3 {
  fill: blue;
}
```

**不起作用。**

我们尝试设置 `.path1` 、 `.path2` 和 `.path3` 的样式，仿佛他们被嵌套在 `.icon-colors` 里，但是严格来说，**并非如此**。 `<use>` 标签不是一个会被你的 SVG 定义替代的**占位符**。这是一个**引用**将它所指向内容复制为 [**shadow DOM**](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Shadow_DOM) 😱。

**那接下来我们该怎么办？**当子项不在 DOM 中时，我们如何才能用一个区域性的方式影响子项？

### CSS 变量拯救世界

在 CSS 中，[一些属性](https://developer.mozilla.org/en-US/docs/Web/CSS/inheritance)从父元素继承给子元素。如果你将一个文本颜色分配给 `body` ，这一页中所有文本将会继承那个颜色直到被重写。父元素没有意识到子元素，但是**可继承**的样式仍然继续传播。

在我们之前的例子里，我们继承了**填充**属性。回头看，你会看到我们声明**填充**颜色的类被附加在了**实例**上，而不是定义上。这就是我们能够为同一定义的每个不同实体赋予不同颜色的原因。

现在有个问题：我们想传递**不同**颜色给原始 SVG 的**不同**路径，但是只能从一个 `fill` 属性里继承。

这就需要 **CSS 变量**了。

就像任何其它属性一样， CSS 变量在规则集里被声明。你可以用任意命名，分配任何有效的 CSS 值。然后，你为它自己或者其它子属性，像一个值一样声明它，并且**这将被继承**。

```
.parent {
  --custom-property: red;
  color: var(--custom-property);
}
```

_所有_ `.parent` _的子项都有红色文本。_

```
.parent {
  --custom-property: red;
}
.child {
  color: var(--custom-property);
}
```

_所有嵌套在_  `.parent` _标签里的_ `.child` _都有红色文本。_

现在，让我们把这个概念应用到 SVG 符号里去。我们将在 SVG 定义的每个部分使用 `fill` 属性，并且设置成不同的 CSS 变量。然后，我们将给它们分配不同的颜色。

```
// HTML
<svg xmlns="http://www.w3.org/2000/svg" style="display: none">
  <symbol id="my-first-icon" viewBox="0 0 20 20">
    <title>my-first-icon</title>
    <path fill="var(--color-1)" d="..." />
    <path fill="var(--color-2)" d="..." />
    <path fill="var(--color-3)" d="..." />
  </symbol>
</svg>
<svg class="icon icon-colors">
  <use xlink:href="#my-first-icon" />
</svg>
// CSS
.icon-colors {
  --color-1: #c13127;
  --color-2: #ef5b49;
  --color-3: #cacaea;
}
```

然后… **生效了** 🎉!

![](https://cdn-images-1.medium.com/max/800/0*b9uBTmdvSJs7fd1D.png)

现在开始，为了用不同的颜色方案创建实例，我们所需要做的是创建一个新类。

```
// HTML
<svg class="icon icon-colors-alt">
  <use xlink:href="#my-first-icon" />
</svg>
// CSS
.icon-colors-alt {
  --color-1: brown;
  --color-2: yellow;
  --color-3: pink;
}
```

如果你仍然想有单色图标，**你不必在每个 CSS 变量中重复同样的颜色**。相反，你可以声明一个单一 `fill` 规则：因为如果 CSS 变量没有被定义，它将会回到你的 `fill` 声明。

```
.icon-monochrome {
  fill: grey;
}
```

_你的 `fill` 声明将会生效，因为初始 SVG 的 `fill` 属性被未设置的 CSS 变量值定义。_

### 怎样命名我的 CSS 变量？

当提到在 CSS 中命名，通常有两条途径：**描述的**或者**语义的**。描述的意思是告诉一个颜色**是什么**：如果你存储了  `#ff0000` 你可以叫它 `--red` 。语义的意思是告诉颜色**它将会被如何应用**：如果你使用 `#ff0000` 来给一个咖啡杯把手赋予颜色，你可以叫它 `--cup-handle-color` 。

描述的命名也许是你的本能。看起来更干脆，因为`#ff0000` 除了咖啡杯把手还有更多地方可以被使用。一个 `--red` CSS 变量可被复用于其他需要变成红色的图标路径。毕竟，这是实用主义在 CSS 中的工作方式。并且是[一个良好的系统](https://frontstuff.io/in-defense-of-utility-first-css)。

问题是，在我们的案例里，**我们不能把零散的类应用于我们想设置样式的标签**。实用主义原则不能应用，因为我们对于每个图标有单独的引用，我们不得不通过类的变化来设置样式。

使用语义类命名，例如 `--cup-handle-color` ，对于这个情况更有用。当你想改变图标一部分的颜色时，你立即知道这是什么以及需要重写什么。无论你分配什么颜色，类命名将会一直关联。

### 默认还是不要默认，这是个问题

将你的图标的多色版本设置成默认状态是很有诱惑力的选择。这样，你无需设置额外样式，只需要在必要的时候可以添加你自己的类。

有两个方法可以实现：**:root** 和 **var() default** 。

### :root

在 `:root` 选择器中你可以定义所有你的 CSS 变量。这将会把它们统一放在一个位置，允许你『分享』相似的颜色。 `:root` 拥有最低的优先度，因此可以很容易地被重写。

```
:root {
  --color-1: red;
  --color-2: green;
  --color-3: blue;
  --color-4: var(--color-1);
}
.icon-colors-alt {
  --color-1: brown;
  --color-2: yellow;
  --color-3: pink;
  --color-4: orange;
}
```

然而，**这个方法有一个主要缺点**。首先，将颜色定义与各自的图标分离可能会有些让人疑惑。当你决定重写他们，你必须在类与 `:root` 选择器之间来回操作。但是更重要的是，**它不允许你去关联你的 CSS 变量**，因此让你不能复用同一个名字。

大多数时候，当一个图标只用一种颜色，我用 `--fill-color` 名称。简单，易懂，对于所有仅需要一种颜色的图标非常有意义。如果我必须在 `:root` 声明中声明所有变量，我就不会有几个 `--fill-color`。我将会被迫定义 `--fill-color-1` ， `--fill-color-2` 或者使用类似 `--star-fill-color` ， `--cup-fill-color` 的命名空间。

### var() 默认

你可以用 `var()` 功能来把一个 CSS 变量分配给一个属性，并且它的第二个参数可以设置为某个默认值。

```
<svg xmlns="http://www.w3.org/2000/svg" style="display: none">
  <symbol id="my-first-icon" viewBox="0 0 20 20">
    <title>my-first-icon</title>
    <path fill="var(--color-1, red)" d="..." />
    <path fill="var(--color-2, blue)" d="..." />
    <path fill="var(--color-3, green)" d="..." />
  </symbol>
</svg>
```

在你定义完成 `--color-1` ， `--color-2` 和 `--color-3` 之前，图标将会使用你为每个 `<path>` 设置的默认值。这解决了当我们使用 `:root` 时的全局关联问题，但是请小心：**你现在有一个默认值，并且它将会生效**。结果是，你再也不能使用单一的 `fill` 声明来定义单色图标了。你将不得不一个接一个地给每个使用于这个图标的 CSS 变量分配颜色。

设置默认值会很有用，但是这是一个折中方案。我建议你不要形成习惯，只在对给定项目有帮助的时候做这件事情。

### How browser-friendly is all that?

[CSS 变量与大多数现代浏览器兼容](https://caniuse.com/#feat=css-variables)，但是就像你想的那样， Internet Explorer **完全**不兼容。因为微软要支持 Edge 终止了 IE11 开发， IE 以后也没有机会赶上时代了。

现在，仅仅是因为一个功能不被某个浏览器（而你必须适配）兼容，这不意味着你必须全盘放弃它。在这种情况下，考虑下**优雅降级**：给现代浏览器提供多彩图标，给落后浏览器提供备份的填充颜色。

你想要做的是设置一个仅在 CSS 变量不被支持时触发的声明。这可以通过设置备份颜色的 `fill` 属性实现：如果 CSS 变量不被支持，它甚至不会被纳入考虑。如果它们不能被支持，你的 `fill` 声明将会生效。

如果你使用 Sass 的话，这个可以被抽象为一个 `@mixin` 。

```
@mixin icon-colors($fallback: black) {
  fill: $fallback;
  @content;
}
```

现在，你可以任意定义颜色方案而无需考虑浏览器兼容问题了。

```
.cup {
  @include icon-colors() {
    --cup-color: red;
    --smoke-color: grey;
  };
}
.cup-alt {
  @include icon-colors(green) {
    --cup-color: green;
    --smoke-color: grey;
  };
}
```

_在 mixin 中通过  `@content`  传递 CSS 变量也是一个可选项。如果你在外面做这件事，被编译的 CSS 将会变得一样。但是它有助于被打包在一起：你可以在你编辑器中折叠片段然后用眼睛分辨在一起的声明。_

在不同的浏览器中查看这个 [pen](https://codepen.io/sarahdayan/pen/GOzaEQ/) 。在最新版本的 Firefox ， Chrome 和 Safari 中，最后两只杯子各自拥有红色杯身灰色烟气和蓝色杯身灰色烟气。在 IE 和 版本号小于 15 的 Edge 中，第三个杯子的杯身与烟气全部都是红色，第四个则全部是蓝色！ ✨

如果你想了解更多关于 SVG 符号图标（或者一般的 SVG ），我**强烈**建议你阅读 [ Sara Soueidan 写的一切东西](https://www.sarasoueidan.com/blog)。如果你有任何关于 CSS 符号图标的问题，不要犹豫，尽管在 [Twitter](https://twitter.com/frontstuff_io) 上联系我。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

