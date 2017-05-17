
> * 原文地址：[Quantum Up Close: What is a browser engine?](https://hacks.mozilla.org/2017/05/quantum-up-close-what-is-a-browser-engine/)
> * 原文作者：本文已获得原作者 [Potch](http://potch.me/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[吃土小2叉](https://github.com/xunge0613)
> * 校对者：[AceLeeWinnie](https://github.com/AceLeeWinnie)、[yzgyyang](https://github.com/yzgyyang)、[薛定谔的猫](https://github.com/Aladdin-ADD)

# 解密 Quantum：现代浏览器引擎的构建之道 #

2016 年 10 月，[Mozilla 公布了 Quantum 项目](https://medium.com/mozilla-tech/a-quantum-leap-for-the-web-a3b7174b3c12) —— 倡议开创下一代浏览器引擎。现在这一项目已然步入正轨。实际上，我们在上个月刚更新的 Firefox 53 中[首次包含了 Quantum 的部分核心代码](https://hacks.mozilla.org/2017/04/firefox-53-quantum-compositor-compact-themes-css-masks-and-more/) 。

但是，我们意识到对于那些不从事浏览器开发的人来说（而且是大多数人），很难明白这些改动对于 Firefox 的重大意义。毕竟，许多改动对于用户来说是不可见的。

意识到这点后，我们开始撰写一系列博客文章来深度解读 Quantum 项目正在做什么。我们希望这一系列的文章能够帮助大家理解 Firefox 的工作原理，以及 Firefox 是如何打造一款下一代浏览器引擎，从而更好地利用现代计算机的硬件性能。

作为这系列文章的第一篇，最好还是先说明一下 Quantum 正在改变哪些核心内容。

浏览器引擎**是**什么？它的工作原理又是什么？

那么，就从头开始说起吧。

Web 浏览器是一种软件，它首先加载文件（通常这些文件来自于远程服务器），然后在本地显示这些文件，并且允许用户交互。

Quantum 是项目的代号，Mozilla 启动这个项目是为了大幅度升级 Firefox 浏览器的某个模块，这个模块决定了浏览器如何根据远程文件将网页显示给用户。这一模块的行业术语叫“浏览器引擎”，如果没有浏览器引擎，用户就只能看看网站源代码而不能浏览网站了。Firefox 的浏览器引擎叫 Gecko。

可以简单地把浏览器引擎看作一个黑盒（有点类似于电视机），灌入数据后由黑盒来决定展示在屏幕上的数据形态。现在的问题是：浏览器引擎是如何呈现页面的？它是通过哪些步骤将数据转化为我们所看见的网页？

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/black-box.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/black-box.png) 

网页数据通常有许多类型，但总的来说可以划分为三大类：

- 用于描述网页**结构**的代码
- 用于提供**样式**的代码，描述了网页结构的视觉外观
- 用于控制浏览器行为的**脚本**代码，包括：计算、人机互动以及修改已初始化的网页结构和样式。

浏览器引擎将页面结构和样式结合从而在屏幕上渲染出网页，同时确定可以互动的内容。

这一切要从网页结构说起。浏览器会根据给定的地址去加载一个网站。这个地址指向的是另一台电脑，当它收到访问请求时，会返回网页数据给浏览器。至于这个过程的具体实现可以查阅[这篇文章](https://developer.mozilla.org/en-US/docs/Web/HTTP)，反正最后浏览器拿到网页数据了。这个数据以 HTML 的格式返回，它描述了网页的结构。那么浏览器又是如何读懂 HTML 的呢？

浏览器引擎包含一类称为**解析器**的特殊模块，它将数据从一种格式转换为另一种可以存储在浏览器内存中的格式。举个例子，HTML 解析器拿到了以下 HTML 内容：

```
<section>
 <h1 class="main-title">Hello!</h1>
 <img src="http://example.com/image.png">
</section>
```

于是，解析器开始解析、理解 HTML，下面是解析器的独白：


> 嗯，这里有个章节。在这个章节里有个一级标题，这个标题包含的文本内容是 “Hello!”。另外在这个章节中，还有一张图片。这个图片的数据从这里获取：http://example.com/image.png

网页在浏览器内存中的结构被称为[文档对象模型](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction)，简称 DOM。DOM 以元素树的形式来表示页面结构，而非长文本形式，包括：每个元素各自的属性以及元素间的嵌套关系。

[![A diagram showing the nesting of HTML elements](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/html-diagra.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/html-diagra.png)

除了用于描述页面结构，HTML 同样包含指向样式文件和脚本文件的地址。浏览器发现这些后，就开始请求并加载数据。然后浏览器会根据数据的类型，指定相应的解析器来处理。脚本文件可以在 HTML 文件解析的同时，改变页面的结构和样式。而样式规则，CSS， 在浏览器引擎中发挥以下作用。

## 关于样式 ##

CSS 是一门编程语言，开发者可以借助 CSS 描述页面元素的外观。CSS 全称 Cascading Style Sheets （译注：层叠样式表），之所以这样命名是因为多个 CSS 指令可以作用在同一个元素上，后定义的指令可以覆盖之前定义的指令，权重高的指令可以覆盖权重低的指令（这就是层叠的概念）。下面是一些 CSS 代码。

```
section {
  font-size: 15px;
  color: #333;
  border: 1px solid blue;
}
h1 {
  font-size: 2em;
}
.main-title {
  font-size: 3em; 
}
img {
  width: 100%;
}

```

大部分 CSS 代码被分割在称为规则的一个个分组中，每条规则包含两个部分。其中一个部分是选择器，选择器描述了 DOM 中需要应用样式的元素（上文说过，还记得吗？）。另一部分则是一系列样式声明，应用于与选择器匹配的元素。浏览器引擎中包含一个名为样式引擎的子系统，用于接收 CSS 代码，并将 CSS 规则应用到由 HTML 解析器生成的 DOM 中。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/style-engine-1.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/style-engine-1.png)

举个例子，在上述 CSS 中，我们有一条规则指定了选择器 “section”，这会匹配到 DOM 中所有 section 元素。接着，浏览器引擎会为 DOM 中的每一个元素附上样式注解。直到最后每个 DOM 元素都应用了样式，我们将该状态称为元素样式计算完毕。而当多个选择器作用在一个元素上时，源代码次序靠后的或者权重更高的 CSS 规则最终会应用到元素上。可以认为样式表是层叠的薄透写纸，上层覆盖下层，但同时也能让下层透过上层显示出来。

一旦浏览器引擎计算好了样式，接下来就要派上用场了！布局引擎接下来会接手 DOM 和已计算的样式，并且会考虑待绘制布局所在的窗口大小。然后布局引擎会分析该元素应用的所有样式，并通过各种算法将每个元素绘制在一个个内容盒子中。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/layout-time.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/layout-time.png)

页面布局绘制完毕后，是时候将页面蓝图转化成你所看见的实际页面了。这一步骤称为 painting（绘制），这也是先前所有步骤的最终整合。每个由布局定义的内容盒子都将被绘制，其内容来自 DOM，其样式源自 CSS。最终，从代码一步步重组而成的页面，展现在用户眼中。

以上就是以前的浏览器引擎所做的事情。

当用户滚动页面的时候，浏览器会进行重绘来显示原先在可见窗口外的页面内容。然而，显然用户都喜欢滚动页面！浏览器引擎清楚地意识到自己肯定会被要求展示初始窗口以外的内容（也称视口）。现代浏览器根据这个事实在页面初始化的时候绘制了比视口更多的页面内容。当用户滚动页面的时候，这部分用户想要看的内容早就已经绘制完毕了。这样的好处就是页面滚动变得更快更流畅。这种技术是网页合成的基础，合成是一种减少所需绘制量的技术术语。

另外，我们有时候也需要重绘部分页面内容。比如用户有可能正在观看一个每秒 60 帧的视频。也可能页面上有一个图片轮播或者滚动列表。浏览器能够检测出页面上哪一部分内容将要移动或者更新，并且会为这些更新的内容创建一个新的图层，而非重新渲染整个页面。一个页面可以由多个彼此重叠的图层构成。每个图层都可以改变定位方式、滚动位置、透明度或者在不触发重绘的前提下控制图层的上下位置！相当方便。

有时候一些脚本或者动画会修改元素的样式。这个时候，样式引擎就需要重新计算这个元素的样式（可能页面上许多其他元素也要重新计算），重新计算布局（产生一次回流），然后重绘整个页面。随着计算量的增加，这些操作会耗费很多时间，但只要发生的频率低，那么就不会对用户体验产生负面影响。

在现代 web 应用中，文档结构经常会被脚本改变。而哪怕只是一点小改动，都会或多或少地触发整个渲染流程：HTML 解析成 DOM，样式计算，回流，重绘。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/browser-diagram-full-2.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/05/browser-diagram-full-2.png)

## Web 标准 ##

不同浏览器解释 HTML、CSS 和 JavaScript 的方式也不一样。这就产生了各种影响：小到细微的视觉差异，大到用户无法在某些浏览器上正常浏览网站。近年来在现代互联网中，大多数网站在不同浏览器下似乎都表现的不错，而且也没有关注用户具体使用的是什么浏览器。那么，不同浏览器又是如何达到这种程度的一致性体验呢？

网站代码的格式，以及代码的解释规则、页面的渲染规则都是由一种由多方认可的文件定义的，即 Web 标准。来自浏览器厂商、Web 开发者、设计师等行业成员的代表组成的委员会制定了这些标准文档。他们一起确定了对于给定的代码片段，浏览器引擎应该显示的明确行为。Web 标准包括 [HTML、CSS 和 JavaScript 标准](https://developer.mozilla.org/en-US/docs/Web_Standards)以及图像、视频、音频等数据格式的标准。

为什么说 Web 标准是重要的？因为只要保证遵循了 Web 标准，就可以开发出一个全新的浏览器引擎，这个引擎可以处理互联网上数以亿计的网页，并绘制出和其它浏览器一样的结果。这也意味着在某些浏览器中才能运作的“秘密配方”不再是秘密了（译者注：例如，不再需要 CSS 私有前缀）。另外，正因为 Web 标准的存在，用户可以凭自己的喜好挑选浏览器。

## 摩尔定律的终结 ##

 过去，人们只有台式电脑。曾经有一个相对保守的假设：计算机只会变得更快更强大。这个想法是基于[摩尔定律](https://en.wikipedia.org/wiki/Moore%27s_law)的推测：集成电路上可容纳的元器件的数目，约每隔 2 年便会增加一倍（因此半导体芯片的性能也将提升一倍、体积也将缩小一倍）。令人难以置信的是，这种趋势一直持续到了 21 世纪，并且有人认为这一定律仍然适用于当今最前沿的研究。那么为什么在过去十年中，计算机的平均运算速度似乎已经趋于稳定了？

顾客买电脑的时候不单单考虑运行速度，毕竟速度快的电脑很可能非常耗电、非常容易发热还非常贵！有时候人们想要一台续航时间良好的笔记本电脑。有时候呢，人们又想要一个微型的触屏电脑，带摄像头，又小到可以塞进口袋，并且电量足够用一天！计算能力的进步已经让这成为可能（真的很惊人！），不过代价就是运行速度下降。正如你在飙车的时候无法有效（或者说安全）地控制行车路线，你也无法让电脑超负荷计算的同时处理大量任务。现在的解决方案都是借助于单 CPU 多核。因此，现在智能手机普遍都有 4 个较小、较弱的计算核心。

不幸的是，过去的浏览器设计是基于摩尔定律（性能提升）会继续有效的假设。另外，编写能够充分利用多核 CPU 的代码也是**极为**复杂的。所以，我们该如何在这个到处都是小型计算机的时代，开发一款高速又高效的浏览器呢？

我们已经想到了！

在接下来的几个月中，我们将更进一步关注 Firefox 的变化，以及这些变化将如何更好地利用现代硬件来实现[一个更快更稳定的浏览器](https://www.mozilla.org/en-US/firefox/developer/)，从而让网站更加多姿多彩。

皮皮虾，我们走！ 

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
