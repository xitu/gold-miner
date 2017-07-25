> * 原文地址：[CSS Isn’t Black Magic](https://medium.freecodecamp.org/its-not-dark-magic-pulling-back-the-curtains-from-your-stylesheets-c8d677fa21b2)
> * 原文作者：[aimeemarieknight](https://medium.freecodecamp.org/@aimeemarieknight)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/its-not-dark-magic-pulling-back-the-curtains-from-your-stylesheets.md](https://github.com/xitu/gold-miner/blob/master/TODO/its-not-dark-magic-pulling-back-the-curtains-from-your-stylesheets.md)
> * 译者：[吃土小2叉](https://github.com/xunge0613)
> * 校对者：[薛定谔的猫](https://github.com/Aladdin-ADD)、[LeviDing](https://github.com/leviding)

# CSS 才不是什么黑魔法呢

## 一起来揭开 CSS 的神秘面纱

![](https://cdn-images-1.medium.com/max/1600/1*TqpR80LFFl09NnOpISdXJg.jpeg)

如果你是一名 web 开发者，你可能会时不时地写一些 CSS。

当你第一次接触 CSS 时，似乎觉得 CSS 轻而易举。加边框，改颜色，小菜一碟。JavaScript 才是前端开发的难点，不是吗？

但是在你 web 开发生涯中的某天，这个想法变了！更糟糕的是，许多前端社区的开发者早已把 CSS 轻视为一门玩具语言。

然而，事实却是当我们碰壁时，我们中的许多人实际上未曾深入了解我们编写的 CSS 做了什么。

在我接受前端培训后的头两年，我曾从事全栈 JavaScript 开发，偶尔写一点点 CSS。作为 [JavaScript Jabber](https://devchat.tv/js-jabber/my-js-story-aimee-knight) 评委会的一员，我一直认为 JavaScript 才是我吃饭的家伙，所以大部分时间我都花在 JavaScript 上。

然而直到去年，当我决定专注于前端时，才意识到根本无法像调试 JavaScript 那样轻松地调试 CSS！

我们都喜欢拿 CSS 开玩笑，但是我们中有多少人真的花时间去尝试理解我们正在编写或正在阅读的 CSS。当我们碰壁时，我们有多少人在解决问题的同时，会深入最底层（看看发生了什么）？ 相反，我们止步于照搬 StackOverflow 上票数最高的答案，或者用一些黑科技（hack）手段随便应付一下，或者我们干脆撒手不管了：那是一个 feature 而不是一个 bug。

当浏览器以非预期的方式呈现 CSS 时，开发者常常感到非常困惑。但是 CSS 并不是黑魔法，而作为开发者，我们都明白计算机只会按照我们的指令去执行。

学习浏览器的内部工作原理将有助于掌握高级调试技巧和性能优化方案。虽然许多会议的演讲会讨论如何修复常见的 bug，但我的演讲（和这篇文章）的重点在于为什么会有这些 bug，为此我将深入介绍浏览器内部原理，看看我们的 CSS 是如何被解析和呈现。

### DOM 与 CSSOM

首先，了解浏览器包含 JavaScript 引擎和渲染引擎非常重要，而本文将重点关注后者。例如，我们将讨论涉及 WebKit（Safari），Blink（Chrome），Gecko（Firefox）和 Trident / EdgeHTML（IE / Edge）的细节。浏览器将经历包括转换、标记化、词法分析和解析的过程，最终构建 DOM 和 CSSOM。（译注：CSSOM 即 CSS Object Model，定义了媒体查询，选择器和 CSS 本身的 API，这些 API 包括了通用解析和序列化规则，传送门：[CSSOM](https://www.w3.org/TR/cssom-1/)）

这一过程大致可以分为以下几个步骤：

- **转换**：从磁盘或网络读取 HTML 和 CSS 的原始字节。
- **标记化**： 将输入内容分解成一个个有效标记（例如：起始标签、结束标签、属性名、属性值），分离无关字符（如空格和换行符）。
- **词法分析**：和 tokenizer（标记生成器）类似，但它还标记每个 token 的类型（类型包括：数字、字符串字面量、相等运算符等等）。
- **解析**： 解析器接收词法分析器传递的 tokens，并尝试将其与某条语法规则进行匹配，匹配成功后将之添加到抽象语法树中。

一旦 DOM 树和 CSSOM 树创建完毕，渲染引擎就会将数据结构附加到所谓的渲染树中，并作为布局过程的一部分。

渲染树是文档的可视化表现形式，它按照正确的顺序绘制页面的内容。渲染树的构造过程遵循以下顺序：

- 从 DOM 树的根节点开始，遍历每个可见节点
- 忽略不可见的节点
- 对于每个可见节点，找到合适的与 CSSOM 匹配的规则并应用它们
- 发送包含内容和计算样式的可见节点
- 最后，在屏幕上输出包含所有可见元素的内容和样式信息的渲染树。

CSSOM 可以对渲染树产生很大的影响，但不会影响到 DOM 树。

### 渲染

经历了布局和渲染树构建后，浏览器终于要开始将网页绘制到屏幕上并合成图层。

- **布局**：包括计算一个元素占用的空间以及它在屏幕上的位置。父元素可以影响子元素布局，某些情况下子元素也会反过来影响父元素。
- **绘制**：将渲染树中的每个节点转换为屏幕上的实际像素的过程。它涉及绘制文本、颜色、图像、边框和阴影。绘图通常在多个图层上完成，另外由于加载、执行 JavaScript 而改变了 DOM 会导致多次绘制 。
- **合成**：将所有图层合并在一个图层，作为最终屏幕上可见图层的过程。由于页面的各个部分可以绘制成多层，所以需要以正确的顺序绘制到屏幕上。

绘制时间取决于渲染树结构，元素的 `width` 和 `height` 的值越大，绘制时间就越长。

添加各种特效同样会增加绘画时间。绘制的顺序是按照元素进入层叠上下文的顺序（从后往前绘制），稍后我们再谈谈 `z-index`。如果你喜欢看视频教程，有一个很棒的关于绘制过程的 [demo](https://www.youtube.com/watch?v=ZTnIxIA5KGw)。

当人们在谈论浏览器的硬件加速时，绝大多数都是指加速“合成”过程，也就是意味着使用 GPU 来合成网页的内容。

与使用计算机 CPU 进行合成的旧方式相比，使用 GPU 能带来相当多的速度提升，而合理利用 `will-change` 这一属性有助于此。（译注：`will-change` 相关资料传送门 [will-change MDN](https://developer.mozilla.org/zh-CN/docs/Web/CSS/will-change) 、[Everything You Need to Know About the CSS will-change Property](https://dev.opera.com/articles/css-will-change-property/)）

举个例子：在使用 CSS `transform` 属性时，`will-change` 属性能提前告知浏览器 DOM 元素接下来会有哪些变化。这可以将一些绘制和合成操作移交给 GPU，从而大大提高有大量动画的页面的性能。使用 `will-change` 属性，对于滚动位置变化、内容变化、不透明度变化以及绝对定位坐标位置变化也有类似的性能收益。

有必要了解一件事：某些 CSS 属性将导致重新布局，而其他属性只会导致重新绘制。当然出于性能考虑，最好只触发重绘。

举个例子：元素的颜色改变后，只会对该元素进行重绘。而元素的位置改变后，会对该元素及其子元素（可能还有同级元素）进行布局和重绘。添加 DOM 节点后，会对该节点进行布局和重绘。一些重大变化（例如增大 `html` 元素的字体）会导致整个渲染树进行重新布局和绘制。

如果你像我一样，比起 CSSOM 更熟悉 DOM，那么让我们来深入了解一下 CSSOM。请务必注意，默认情况下，CSS 会被视为阻塞渲染资源。这意味着浏览器在构建完 CSSOM 之前，将挂起任何其它进程的渲染。

CSSOM 和 DOM 并不是一一对应的。具有 `dispay:none` 属性的元素、`<script>` 标签、`<meta>` 标签、`<head>` 元素等等不可见的 DOM 元素不会显示在渲染树中。

CSSOM 和 DOM 的另一个区别则在于解析 CSS 使用的是一种上下文无关语法。也就是说，CSS 渲染引擎不会自动补全 CSS 中缺少的语法，然而解析 HTML 创建 DOM 时则刚好相反。

解析 HTML 时，浏览器不得不结合 HTML 标签所在的上下文，而且只遵从 HTML 规范是不够的，因为 HTML 标签可能包含一些缺省的信息，并且无论解析成什么，最终都要渲染出来。（译注：这么做的目的是为了包容开发者的错误，简化 web 开发，例如能省略一些起始或者结束标记等等）

说了那么多，我们来回顾一下：

- 浏览器向服务器发起 HTTP 请求
- 服务器响应请求，并返回网页数据
- 浏览器通过标记化将响应数据（字节）转换为 tokens
- 浏览器将 tokens 转换为节点
- 浏览器将节点插入 DOM 树
- 等待构建 CSSOM 树

### 优先级

我们已经深入了解了不少浏览器的工作原理，那么接下来我们来看看一些更常见的开发痛点吧。首先说说优先级。

简单来说，CSS 的优先级是指以正确的层叠顺序应用规则。尽管可以使用多种 CSS 选择器来选中特定的标签，浏览器仍需要一种方式来决定最终哪些样式将会生效。在决策过程中，首先浏览器会计算每个选择器的优先级。

不幸的是，优先级的计算规则难倒了不少 JavaScript 开发者，所以让我们一起深入研究 CSS 优先级的计算规则。我们将使用以下的 html 结构作为例子：有一个类名为 `container` 的 div，在这个 div 里，我们嵌套了另一个 div，它的 id 是 `main`，我们又在这个 div 里嵌套了一个包含 a 标签的 p 标签。别偷看答案，你知道 a 标签的颜色是什么吗？

``` css
#main a {
  color: green;
}

p a {
  color: yellow;
}

.container #main a {
  color: pink;
}

div #main p a {
  color: orange;
}

a {
  color: red;
}
```

（译注：加一段 html 结构顺便防偷看答案 →_→）

``` html
<div class="container">
	<div id="main">
		<p>
			<a href="#">Test</a>
		</p>
	</div>
</div>
```

答案是粉色，它的优先级为：1，1，1。以下是其余选择器的优先级：

- `div #main p a: 1，0，3`
- `#main a: 1，0，1`
- `p a: 2`
- `a: 1`

优先级的每一个数的计算规则如下：

- **第一个数**：ID 选择器的数量
- **第二个数**：类选择器、属性选择器（不包含：`[type="text"]`, `[rel="nofollow"]`）、以及伪类选择器（不包含：`:hover`, `:visited`）的数量和。
- **第三个数**：元素选择器与伪元素选择器（不包含: `::before`, `::after`）的数量和。

因此，对于以下选择器：

    #header .navbar li a:visited

该选择器的优先级是：1，2，2。因为我们有 1 个 ID 选择器、1 个类选择器、1 个伪类选择器、还有 2 个元素选择器（`li`、`a`）。你可以把优先级看作一个数字，比如 1，2，2 就是 122。这里的逗号是为了提现你优先级的数值并不是以 10 进制计算的。理论上你可以让一个元素的优先级为：0，1，13，4，其中的 13 并不会像 10 进制那样产生进位。（译注：不会变成 0，2，3，4）  
 
### 定位

其次，我想花点时间讨论一下定位。正如前文所说的，定位和布局是密切相关的。

布局是一个递归的过程，当全局样式变化的时候，有时会在整个渲染树上（重新）触发布局，有时则仅在局部变化的地方增量更新。有一件有趣的事情值得注意：如果我们重新思考渲染树中的绝对定位元素，该对象在渲染树中的位置和它在 DOM 树中的位置不同的。

我也经常被问及应该使用 `flexbox` 还是 `float` 进行布局。毫无疑问，用 `flexbox` 进行布局相当方便，而且当应用于同一个元素时，`flexbox` 布局将在大约 3.5ms 内呈现，而 `float` 布局可能需要大约 14ms。所以，磨砺你的 CSS 技能所带来的回报不下于磨砺你的 JavaScript 技能的回报。

### Z-Index

最后，我想聊聊 `z-index`。起初 `z-index` 听起来很简单。HTML 文档中的每个元素都可以处在文档的每个其他元素的前面或后面。 而它也只适用于指定了定位方式的元素（译注：即，未被定位，非 `position:static` 的元素）。如果你尝试在没有被定位的元素上设置 `z-index`，则不会起作用。

调试 z-index 问题的关键是理解层叠上下文，并始终从层叠上下文的根元素开始调试。 层叠上下文是 HTML 元素的三维概念，这些 HTML 元素在一条假想的相对于面向视窗（电脑屏幕）的用户的 z 轴上延伸。换句话说，它是一组具有相同父级的元素，在同一个层叠上下文领域，层叠水平值大的那一个覆盖小的那一个。

每个层叠上下文都有一个唯一的 HTML 元素作为其根元素，并且在不涉及 `z-index` 和 `position` 属性时，层叠规则很简单：层叠顺序与元素在 HTML 中出现的顺序相同。（译注：即，新绘制的元素会覆盖之前的元素）

当然，你也可以使用 `z-index` 之外的属性来创建新的层叠上下文，这会导致情况更为复杂。以下属性都会创建新的层叠上下文：

- `opacity` 值不是 1
- `filter` 值不是 `none`
- `mix-blend-mode` 值不是 `normal`

顺便提一下，blend mode 决定了指定图层上的像素与其下方图层上的可见像素的混合方式。

`transform` 属性值不为 `none` 的元素同样会创建新的层叠上下文。例如 `scale(1)` 和 `translate3d(0,0,0)`。同样顺便提一下，`scale` 属性是用于调整元素大小的，而 `translate3d` 属性则会启用 GPU 加速让 CSS 动画更为流畅 。

所以，尽管你可能还没有设计师般的眼光，但希望你正向着 CSS 大师迈进！如果你有兴趣了解更多，我整理了一些[学习资源](https://gist.github.com/AimeeKnight/77b36738ec876965c6db5c6d39f4ef4f)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
