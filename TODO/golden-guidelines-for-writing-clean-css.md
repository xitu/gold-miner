> * 原文地址：[Golden Guidelines for Writing Clean CSS](https://www.sitepoint.com/golden-guidelines-for-writing-clean-css/)
> * 原文作者：本文已获作者 [Tiffany Brown](https://www.sitepoint.com/author/tbrown/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[reid3290](https://github.com/reid3290)
> * 校对者：[weapon-xx](https://github.com/weapon-xx)，[bambooom](https://github.com/bambooom)

---

# 编写整洁 CSS 代码的黄金法则

### 编写整洁 CSS 代码的黄金法则

要编写整洁的 CSS 代码，有一些规则是应当极力遵守的，这有助于写出轻量可复用的代码：

- 避免使用全局选择器和元素选择器
- 避免使用权重（specific）过高的选择器
- 使用语义化类名
- 避免 CSS 和标签结构的紧耦合

本文将依次阐述上述规则。

### 避免使用全局选择器

全局选择器包括通配选择器（`*`）、元素选择器（例如`p`、`button`、`h1`等）和属性选择器（例如`[type=checkbox]`），这些选择器下的 CSS 属性会被应用到全站所有符合要求的元素上，例如：

```
button {
  background: #FFC107;
  border: 1px outset #FF9800;
  display: block;
  font: bold 16px / 1.5 sans-serif;
  margin: 1rem auto;
  width: 50%;
  padding: .5rem;
}
```

这段代码看似无伤大雅，但如果我们需要一个样式不同的 `button` 呢？假设需要一个用于关闭对话框组件的 `.close` button：

```
<section class="dialog">
  <button type="button" class="close">Close</button>
</section>
```

##### 注意: 为什么不使用 `dialog` 元素？

##### 此处使用了 `section` 元素而非 `dialog`，因为只有基于 Blink 内核的浏览器才支持 `dialog` 元素， 例如 Chrome/Chromium、Opera、和 Yandex 等。

现在，需要编写 CSS 代码来覆盖那些不需要继承于 `.button` 的属性：

```
.close {
  background: #e00;
  border: 2px solid #fff;
  color: #fff;
  display: inline-block;
  margin: 0;
  font-size: 12px;
  font-weight: normal;
  line-height: 1;
  padding: 5px;
  border-radius: 100px;
  width: auto;
}
```

除此之外，还需要编写大量类似代码来覆盖浏览器的默认样式。但如果将元素选择器 `button` 用类选择器 `.default` 来替代会如何呢？显而易见，`.close` 不再需要指定`display`、`font-weight`、 `line-height`、`margin`、 `padding`和`width`等属性，这便减少了 23% 的代码量：

```
.default {
  background: #FFC107;
  border: 1px outset #FF9800;
  display: block;
  font: bold 16px / 1.5 sans-serif;
  margin: 1rem auto;
  width: 50%;
  padding: .5rem;
}

.close {
  background: #e00;
  border: 2px solid #fff;
  color: #fff;
  font-size: 12px;
  padding: 5px;
  border-radius: 100px;
}
```

还有一点同样重要：避免使用全局选择器有助于减少样式冲突，即某个模块（或页面）的样式不会意外地影响到另一个模块（或页面）的样式。

对于重置和统一浏览器默认样式，全局选择器完全适用；但对于其他大部分情况而言，全局选择器只会造成代码臃肿。

### 避免使用权重过高的选择器

保持选择器的低权重是编写轻量级、可复用和可维护的 CSS 代码的又一关键所在。你可能记得什么是权重，元素选择器的权重是 `0,0,1`，而类选择器的权重则是 `0,1,0`：

```
/* 权重：0,0,1 */
p {
  color: #222;
  font-size: 12px;
}

/* 特殊性：0,1,0 */
.error {
  color: #a00;
}
```

当为元素选择器加上一个类名后，该选择器的优先级就会高于一般的选择器。没有必要将类选择器和元素选择器组合在一起来提升优先级，这样做会提升选择器的权重和增加文件体积。

换句话说，没有必要使用 `p.error` 这样的选择器，因为仅仅一个 `.error` 就能达到同样的效果；此外 `.error` 还可以被其他元素所复用，而 `p.error` 则会将 `.error` 这个类限制于 `p` 元素上。

#### 避免链接类选择器

还需要避免链接类选择器。形如 `.message.warning` 这样的选择器权重为 `0,2,0`。越高的权重意味着越难进行样式覆盖，而且这种链接还会造成其他副作用。例如：

```
message {
  background: #eee;
  border: 2px solid #333;
  border-radius: 1em;
  padding: 1em;
}
.message.error {
  background: #f30;
  color: #fff;
}
.error {
  background: #ff0;
  border-color: #fc0;
}
```

如下图所示，在上述 CSS 的作用下，`<p class="message">` 会得到一个带有深灰色边框和灰色背景的盒子。

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/03/1489119564SelectorChainingNoChain.png)

但 `<p class="message error">` 却会得到 `.message.error` 的背景和 `.error` 的边框：

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/03/1489119684SelectorChaining.png)

要想覆盖链接在一起的类选择器的样式，只能使用权重更高的选择器。在上例中，要想让边框不是黄色就需要在已有选择器上再加一个类名或一个标签选择器： `.message.warning.exception` 或 `div.message.warning`。更好的做法是创建一个新类。如果你发现你正在链接选择器，那就该回过头重新考量了：要么是设计上存在不一致的地方，要么就是过早尝试避免那些尚不存在的问题。解决这些问题将会带来更高的可维护性和可复用性。

#### 避免使用 `id` 选择器

在一个 HTML 文档中一个 `id` 只能对应一个元素，因此应用于 `id` 选择器的 CSS 规则是很难复用的。这样做一般都会涉及到一系列的 `id` 选择器，例如  `#sidebar-features` 和 `#sidebar-sports`。

此外，`id` 选择器具有很高的权重，要想覆盖它们就必须使用更“长”的选择器。例如下面这段 CSS 代码，为了覆盖 `#sidebar` 的背景颜色属性，必须使用 `#sidebar.sports` 和 `#sidebar.local`：

```
#sidebar {
  float: right;
  width: 25%;
  background: #eee;
}
#sidebar.sports  {
  background: #d5e3ff;
}
#sidebar.local {
  background: #ffcccc;
}
```

改用类选择器，例如 `.sidebar`，可以简化 CSS 选择器：

```
sidebar {
  float: right;
  width: 25%;
  background: #eee;
}
.sports  {
  background: #d5e3ff;
}
.local {
  background: #ffcccc;
}
```

 `.sports` 和 `.local` 不仅节省了好几个字节，还可以复用到其他元素上。

使用属性选择器（例如 `[id=sidebar]`）可以解决 `id` 选择器高权重的问题，尽管其复用性不如类选择器，但其低权重可以让我们避免使用链式选择器。

##### 注意:  `id` 选择器的高权重也确有用武之地

在某些情况下，你可能确实需要 `id` 选择器的高特殊性。例如，一些媒体站点可能需要其所有子站都使用同样的导航条组件，该组件必须在所有站点都表现一致并且其样式是难以被覆盖的。此时，使用 `id` 选择器就可以减少导航条样式被意外覆盖的情况。

最后，再来讨论一下形如 `#main article.sports table#stats tr:nth-child(even) td:last-child` 这样的选择器。这条选择器不仅长的离谱，而且其权重为 `2,3,4`，也很难复用。试想 HTML 中会有多少标签真能匹配这一选择器呢？稍作思考，就可以将上述选择器其缩减为 `#stats tr:nth-child(even) td:last-child`，其权重也足够满足需求了。但还有更好的方法既能提高复用性又能减少代码量，也就是使用类选择器。

##### 注意：预处理器嵌套综合症

权重过高的选择器大多源于预处理器中过多的嵌套（译注：此处所指应是 Sass 中选择器嵌套过深）。

#### 使用语义化类名

所谓**语义化**，是指要**有意义** —— 类名应当能够表明其规则有何作用或会作用于哪些内容。此外类名也要能够适应 UI 需求的变化。命名看似简单，实则不然。

例如，不要使用 `.red-text`、`.blue-button`、 `.border-4px` 和  `.margin10px` 这样的类名，这些类名和当前的设计耦合得太紧了。用 `class="red-text"` 来修饰错误信息看似可行，但如果设计稿发生了变化并要求将错误信息用橙底黑字表示呢？这时原有类名就不准确了，使人难以理解代码的真正含义。

在这个例子中，最好使用 `.alert`、`.error`  或是  `.message-error`  这样的类名，这些类名表明了该如何使用它们以及它们会影响哪些内容（即错误信息）。对用于页面布局的类名，不妨加上 `layout-`、 `grid-`、 `col-` 或 `l-` 等前缀，使人一眼可以看出它们的作用。之后关于 BEM 方法论的章节详细阐述了这一过程。

#### 避免 CSS 和标签结构的紧耦合

你可能在代码中使用过子元素选择器和后代选择器。子元素选择器形如 `E > F`，其中 F 是某个元素，而 E 是 F 的**直接**父元素。例如，`article > h1` 会影响 `<article><h1>Advanced CSS</h1></article>` 中的 `h1` 元素，但不会影响 `<article><section><h1>Advanced CSS</h1></section></article>` 中的 `h1` 元素。另一方面，后代选择器形如 `E F`，其中 F 是某个元素而 E 是 F 的祖先元素。还用上述例子，则那两种标签结构中的 `h1` 元素都会受到 `article h1` 的影响。

子元素选择器和后代选择器本身并没有问题，实际上它们在限制 CSS 规则的作用域方面确实发挥着很好的作用。但它们也绝非理想之选，因为标签结构经常会发生改变。

遇到过如下情况的同学请举手：你为某个客户编写了一些模版，并且在 CSS 代码中用到了子元素选择器和后代选择器，并且大多数都是元素选择器，即形如 `.promo > h2` 和 `.media h3` 这样的选择器；后来你的客户又聘请了一位 SEO 技术顾问，他检查了你代码中的标签结构并建议你将 `h2` 和 `h3` 分别改为 `h1` 和  `h2`，这时候问题来了 —— 你必须同时修改 CSS 代码。

在上述情况下，类选择器再一次表现出其优点。使用  `.promo > .headline` 或 `.media .title` （或者更简单一些： `.promo-headline` 和 `.media-title`）使得在改变标签结构的时候无需改变 CSS 代码。

当然，这条规则假设你对标签结构有足够的控制权，这在面对一些遗留的 CMS 系统的时候可能是不现实的，在这种情况下使用子元素选择器、后代选择器和伪类选择器是适当的同时也是必要的。

##### PS：更多架构合理的 CSS 规则

Philip Walton 在其 [“CSS 架构”](http://philipwalton.com/articles/css-architecture/)一文中讨论了相关规则，有关 CSS 架构的更多想法参见 Roberts 的网站 [CSS 原则](http://cssguidelin.es/) 以及 Nicolas Gallagher 的博客文章 [HTML 语义化及前端架构](http://nicolasgallagher.com/about-html-semantics-front-end-architecture/)。

接下来将会探讨有关 CSS 架构的两种方法，这两种方法主要用于提升大规模团队和大规模站点的开发效率，但对于小团队来说其实也是十分适用的。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
