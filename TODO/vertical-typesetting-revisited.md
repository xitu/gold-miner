> * 原文地址：[Vertical typesetting with writing-mode revisited](https://www.chenhuijing.com/blog/vertical-typesetting-revisited/)
> * 原文作者：[Chen Hui Jing](https://www.chenhuijing.com/blog/vertical-typesetting-revisited/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/vertical-typesetting-revisited.md](https://github.com/xitu/gold-miner/blob/master/TODO/vertical-typesetting-revisited.md)
> * 译者：[DEARPORK](https://github.com/Usey95)
> * 校对者：[congFly](https://github.com/congFly) [PLDaily](https://github.com/PLDaily)

# 垂直排版：重提 writing-mode

大约一年前， 我写了在一次 Web 中文垂直排版的尝试中的[一些发现](https://www.chenhuijing.com/blog/chinese-web-typography/)。这是一个[简单的 demo](https://www.chenhuijing.com/zh-type)，它允许你通过复选框来切换书写模式。

我在不久后遇到了 [Yoav Weiss](https://blog.yoav.ws/)，并聊了一下[响应式图片社区小组](http://ricg.io/)，因为我提到如果可以通过媒体查询得到 `picture` 元素的 `writing-mode`，我就不必在切换排版的时候通过一些比较 hack 的方式对图像进行转换。他建议我把它写成[一个响应式图像用例](https://github.com/ResponsiveImagesCG/ri-usecases/issues/63)。

但当我重新打开这个一年没打开的 demo 的时候，我的表情在最初的五分钟由 😱 变成了 😩（我还能说什么呢，我就是这么表情丰富 🤷）。所以为了宣泄，我将一步步写下谁（也就是各种浏览器）破坏了什么以及目前可能的解决办法。

帖子很长，可以使用链接来跳转。

### 大脑转储结构

* [最初的发现](#initial-findings)
  * [Chrome (64.0.3278.0 dev)](#chrome-64032780-dev)
  * [Firefox (59.0a1 Nightly)](#firefox-590a1-nightly)
  * [Safari Technology Preview 44](#safari-technology-preview-44)
  * [Edge 16.17046](#edge-1617046)
  * [Edge 15.15254](#edge-1515254)
  * [iOS 11 WebKit](#ios-11-webkit)
* [代码时间](#code-time)
  * [一些背景](#some-background)
  * [调试 101：重置为基准](#debugging-101-reset-to-baseline)
  * [vertical-rl 的含义](#the-implications-of-vertical-rl)
* [排版切换](#layout-switching)
  * [解决方案 #1: Javascript](#solution-1-javascript)
  * [解决方案 #2: 复选框 hack](#solution-2-checkbox-hack)
* [处理图像对齐](#handling-image-alignment)
  * [经典的属性](#old-school-properties)
  * [使用 flexbox 来居中](#using-flexbox-for-centring)
  * [Grid 怎么样？](#how-about-grid)
* [成功的解决方案？](#winning-solution)
* [延伸阅读](#further-reading)
* [问题和错误列表](#issues-and-bugs-list)

## 最初的发现

我只在看我能立即访问的浏览器，因为我的人生还有很多别的事要做 🙆。

### Chrome (64.0.3278.0 dev)

![vertical-rl on Chrome](https://www.chenhuijing.com/images/posts/vertical-typesetting/chrome-640.jpg)

好的，这看起来非常棒。我说所有东西都被破坏了其实有点夸张。所有的文字和图片都占满，在垂直书写模式下没有重大的渲染问题。做的好，Chrome。

![horizontal-tb on Chrome](https://www.chenhuijing.com/images/posts/vertical-typesetting/chrome2-640.jpg)

切换排版模式将东西都踢去了右边。我记得在垂直排版下将东西水平居中是一件让人特别痛苦的事情，所以在第一次不太顺利的尝试中我肯定用了某些 hack 手段。

这在 2017 年初是绝对可行的，因为我为我的 Webconf.Asia 幻灯片做了[这个截屏](https://www.chenhuijing.com/slides/webconf-asia-2017/videos/mode-switcher.mp4)。我很确定当时用的是 Chrome。几个月时间一个 demo 的变化让人惊讶。我的老大提到过一个词叫「代码腐烂」，也许这就是吧。

### Firefox (59.0a1 Nightly)

![vertical-rl on Firefox](https://www.chenhuijing.com/images/posts/vertical-typesetting/firefox-640.jpg)

天哪，这，我都无语了。Firefox Nightly 是我的默认浏览器，所以我的最初反应是一切都被破坏了。一切确实都被破坏了，看看这无限滚动的水平滚动条，到底发生了什么？！

![horizontal-tb on Firefox](https://www.chenhuijing.com/images/posts/vertical-typesetting/firefox2-640.jpg)

让我们切换……等等，我的复选框呢？唉，这可能要等一会。不管怎么说，至少我将复选框绑在了 label 上，所以我仍然可以通过点击 label 来切换排版。所以，这绝对不是居中，但也没有太崩。两个浏览器的表现形式天差地别。

### Safari Technology Preview 44

![vertical-rl on Safari TP](https://www.chenhuijing.com/images/posts/vertical-typesetting/stp-640.jpg)

嘿，嘿，嘿！这看起来令人惊讶的好。甚至连高度都是正确的。Safari，我可能误判你了。Safari 的渲染引擎到底是什么？好吧，WebKit。

![horizontal-tb on Safari TP](https://www.chenhuijing.com/images/posts/vertical-typesetting/stp2-640.jpg)

噢噢噢，这有点居中。不看代码，我也能确定我尝试过一些很奇怪的转译来改变整个内容块，因此在每个浏览器中行为不一致。但这是个令人欣慰的惊喜。

### Edge 16.17046

这是 Windows 10 内置快速通道版本，所以我想我的 Edge 浏览器应该比大多数人的版本更高。没关系，我也可以用我的手机（没错，我用的是 Windows phone，不服来战）。

![vertical-rl on Edge 16](https://www.chenhuijing.com/images/posts/vertical-typesetting/edge-640.jpg)

无论如何，这看起来也不算太坏。只是那个复选框有点错位。更重要的是滚轮正常工作！其他所有的浏览器都不允许我用滚轮水平滚动。虽然我不知道这是 Windows 的功劳还是 Edge。

![horizontal-tb on Edge 16](https://www.chenhuijing.com/images/posts/vertical-typesetting/edge2-640.jpg)

也是隐约的居中。我真的需要马上检查下我的转换代码。现在我可能对我的复选框究竟怎么了也产生了疑问。啊，使用滚轮无法垂直滚动，这就有意思了。另外，注意滚动条在左边 🤔。

### Edge 15.15254

![](https://www.chenhuijing.com/images/posts/vertical-typesetting/edgem.jpg)

Edge 15 上的 vertical-rl

![](https://www.chenhuijing.com/images/posts/vertical-typesetting/edgem2.jpg)

Edge 15 上的 horizontal-tb

跟 Edge 16 几乎一模一样。我有理由相信 Windows phone 上的 Edge 浏览器用的是与桌面版本同样的渲染引擎 EdgeHTML，如果有错还望指正。

### iOS 11 WebKit

![](https://www.chenhuijing.com/images/posts/vertical-typesetting/ios.jpg)

iOS 11 WebKit 上的 vertical-rl

![](https://www.chenhuijing.com/images/posts/vertical-typesetting/ios2.jpg)

iOS 11 WebKit 上的 horizontal-tb 

尽管我的 iPad 上装了一大堆浏览器，但我知道它们的渲染引擎都是 WebKit，因为苹果从未允许过第三方的浏览器引擎。正如在桌面版展示的那样，这是表现比较好的浏览器。

## 代码时间

好了，既然我们已经确定了破坏的基准，现在是时候把防尘罩拆下来，看看底下到底有什么怪异的代码。公平地说，没有太多，考虑到这是一个非常简单的演示，所以还不错。

同时我还要强烈安利（无数次）[Browsersync](https://www.browsersync.io/)，那是我最重要的开发工具，尤其是需要在不同设备的不同浏览器上调试的时候。如果我没有 Browsersync，我将不会为此做这么多工作。

### 一些背景

切换器的实现可以用两种形式，一是通过 Javascript 切换类，二是 hack 复选框。我通常倾向于只使用 CSS 的解决方案，所以决定 hack 复选框。这个 demo 足够简单，所以不会有太多键盘控制方面的干扰。我的意思是，你可以像其它任何的复选框一样用 tab 切换到它然后切换。
我真的需要研究可访问性的问题以确定我是否会在屏幕阅读器上搞砸它，但那是另一回事了。今天优先处理布局问题。

如果你没有尝试过 hack 复选框，它涉及到 `:checked` 伪选择器的使用和兄弟或子选择器，你可以通过这种方式用 CSS hack 复选框的状态。

需要注意的是，切换 `:checked` 状态的 input（通常是复选框元素），必须处于与你想切换状态的目标元素相同或更高的层级。

```
<body>
  <input type="checkbox" name="mode" class="c-switcher__checkbox" id="switcher" checked>
  <label for="switcher" class="c-switcher__label">竪排</label>

  <main>
    <!-- 内容样式 -->
  </main>

  <script src="scripts.js"></script>
</body>
```

问题就在复杂度上。在同一个页面上混合使用不同的嵌套的书写模式确实会搞垮浏览器。我不是浏览器工程师，但我有足够的常识知道渲染东西不是微不足道的。但是我是一个执着的人，所以必受其苦。

![](https://www.chenhuijing.com/images/posts/vertical-typesetting/diagram.svg)

一般的复选框 hack 策略

原始的 demo上，我在 `body` 元素上设置默认的书写模式为 `vertical-rl`，然后使用复选框来切换 `main` 元素里的书写模式。但是看起来似乎每个人（浏览器渲染引擎）都向上面的截图目录一样，以不同的方式处理嵌套的书写模式。

### 调试 101: 重置为基准

记住，这是一个大脑转储条目，如果你觉得无聊，我对此表示抱歉。我做的第一件事就是删除所有样式，重新开始。再次重申，这个 demo 有效是因为它十分简单。上下文才是一切，朋友们。

```
html {
  box-sizing: border-box;
  height: 100%;
}

*,
*::before,
*::after {
  box-sizing: inherit;
}

body {
  margin: 0;
  padding: 0;
  font-family: "Microsoft JhengHei", "微軟正黑體", "Heiti TC", "黑體-繁", sans-serif;
  text-align: justify;
}
```

这几乎成了我所有项目的事实起点。将所有元素设置成 `border-box`，而且通常我还会加上 `margin: 0` 和 `padding: 0` 作为样式重置的基础。但是就这个 demo 而言，我将让浏览器保留它的空白只重置 `body` 元素。

这个 demo 几乎全是中文，所以我只添加了中文字体，把系统自带的 sans-serif 作为后备。不过大多数情况来说，优先选择基于拉丁语的字体是个普遍的共识。但在这里，中文字体支持基本的拉丁字符，而反过来情况就不一样了。

当浏览器遇到中文字符时，它不会在基于拉丁语的字体中寻找，所以它会选用下一种备选字体，直到找到合适的。如果你先将中文字体列出来，浏览器将使用中文字体中的拉丁语字符，有时候这些字形没被打磨，看起来也不太好，尤其是在 Windows 上。

接下来是一些不太影响布局的美化（`line-height` 算吗？🤔）

```
img {
  max-height: 100%;
  max-width: 100%;
}

p {
  line-height: 2;
}

figure {
  margin: 0;
}

figcaption {
  font-family: "MingLiU", "微軟新細明體", "Apple LiSung", serif;
  line-height: 1.5;
}
```

这一个合理、体面的基准。现在我们可以调查 `writing-mode` 的行为了。

### vertical-rl 的含义

每一个元素的 `writing-mode` 的默认值都是 `horizontal-tb`，而且它是一个继承属性。如果你设置了一个元素的 `writing-mode`，这个值将传递到它所有的子元素。

如果我们将 `main` 元素的 `writing-mode` 设置为 `vertical-rl` ，在每个浏览器上，所有的文字和图像都被正确渲染了。Firefox 有 15px 轻微的垂直溢出，我怀疑是因为滚动条，不过我不能确定。其它的浏览器一点水平溢出都没有。

![vertical-rl on the main element](https://www.chenhuijing.com/images/posts/vertical-typesetting/main-640.jpg)

`main` 元素是垂直书写模式的同时，document 本身是水平书写模式，就会产生问题，意味着内容从左边开始，而且我们最终会看到第一次加载的文章的末尾。

所以，让我们把东西提升一个层级，在 `body` 上设置 `writing-mode: vertical-rl`。Chrome，Safari 和 Edge 如我们所想从右到左渲染内容。但是 Firefox 仍然显示文章的末尾，尽管这确实修复了滚动条溢出的问题，它看起来和 [Bug 1102175](https://bugzilla.mozilla.org/show_bug.cgi?id=1102175)有关。

![vertical-rl on the body element](https://www.chenhuijing.com/images/posts/vertical-typesetting/body-640.jpg)

最后，如果我们将 `html` 设置 `writing-mode: vertical-rl`，Firefox 终于正常并从右到左显示了，而且没有搞笑的溢出。And lastly, if we apply `writing-mode: vertical-rl` to the `html` element, Firefox finally comes around and reads from right-to-left. Also, no funny overflowing, just vertical right-to-left goodness.

![vertical-rl on the html element](https://www.chenhuijing.com/images/posts/vertical-typesetting/html-640.jpg)

IE11 支持书写模式属性，只不过使用[较早的规范](https://www.w3.org/TR/2003/CR-css3-text-20030514/#Progression)中定义的旧语法 `-ms-writing-mode: tb-rl`。这工作正常，但我由于现在使用的 `main` 标签 IE11 并不支持，切换器失效了。甚至将 `main` 标签设置成 `display: block` 都无法修复。我可以为了更好的兼容性将 `main` 替换成 `div`。让我考虑一下。

## 布局切换

由于 Firefox 有已知的垂直书写的弹性盒模型的问题，所以我将把调试任务分成两个部分，一是纯粹的布局。找出使切换器正常工作的不同方法，而且没有任何奇怪的溢出。

第二个部分将与图像居中有关，这让我陷入混乱。除了居中，我还想调整图像的方向，它是让我首先重温 [RICG 用例汇总](https://github.com/ResponsiveImagesCG/ri-usecases/issues/63)的原因。#不起眼的注脚

### 解决方案 #1: Javascript

让我们先来尝试回避的解决方案，既然问题出在混用书写模式，也许我们可以停止混用。基于我们上面的观察，用一个 Javascript 事件监听器去切换 html 元素的 CSS 类可以隐性修复许多奇怪的渲染问题。好了，代码时间到。

我想切换的两个类的类名简单地叫做 `vertical` 和 `horizontal`。既然我已经有了复选框，也许也可以用作类的切换器。

```
document.addEventListener('DOMContentLoaded', function() {
  const switcher = document.getElementById('switcher')

  switcher.onchange = changeEventHandler
}, false)

function changeEventHandler(event) {
  const isChecked = document.getElementById('switcher').checked
  const container = document.documentElement

  if (isChecked) {
    container.className = 'vertical'
  } else {
    container.className = 'horizontal'
  }
}
```

将内容块居中完成得很好。因为再也没有嵌套的书写模式或者弹性盒模型。直接的自动 margin 在所有浏览器中都完美实现了居中，甚至 Firefox。

```
.vertical {
  writing-mode: vertical-rl;

  main {
    max-height: 35em;
    margin-top: auto;
    margin-bottom: auto;
  }
}

.horizontal {
  writing-mode: horizontal-tb;

  main {
    max-width: 40em;
    margin-left: auto;
    margin-right: auto;
  }
}
```

![Auto margins for vertical centring](https://www.chenhuijing.com/images/posts/vertical-typesetting/centred2-640.jpg)

有趣的是，在垂直书写模式，我们可以用 `margin-top: auto` 和 `margin-bottom: auto` 来垂直居中。但相信我，水平居中将比你想象的更令人痛苦。在下一个 hack 复选框的部分你将看到。

**意外的 TIL**: Microsoft Edge 遵守 ECMAScript5「**严格模式下不允许分配只读属性**」的规范，但是 Chrome 和 Firefox 在严格怪异模式下仍然允许，很可能是为了代码兼容。我最初尝试使用 `classList` 来切换类名，但它是一个只读属性，而 `className` 则不是。相关阅读在[下面的链接](#further-reading)。

### 解决方案 2: 复选框 hack

这个方案的原理类似使用 Javascript，区别在于我们不使用 CSS 类来改变状态，而是使用 `:checked` 伪元素。如我们前面所讨论的，复选框元素必须和 `main` 元素在同一层级才会生效。

```
.c-switcher__checkbox:checked ~ main {
  max-height: 35em;
  margin-top: auto;
  margin-bottom: auto;
}

.c-switcher__checkbox:not(:checked) ~ main {
  writing-mode: horizontal-tb;
  max-width: 40em; 
  margin-left: auto; // 无效
  margin-right: auto; // 无效
}
```

布局代码与 `.vertical` 和 `.horizontal` 一样，但，结果却不一样。垂直居中是好的，看起来好像是我们在用 Javascript。但是水平居中歪向了右边。自动 margin 在这一部分似乎完全没有发挥作用。
但仔细一想，这其实是「正确」的行为，因为我们同样不能用这种方式在水平书写模式下实现垂直居中。为什么呢？让我们来看一下规范。

所有的 CSS 属性都有值，一旦你的浏览器解析了一个文档并构建了 DOM 树，每个元素的每个属性都需要赋值。[Lin Clark](http://lin-clark.com/) 写了[一个精彩的代码漫画](https://hacks.mozilla.org/2017/08/inside-a-super-fast-css-engine-quantum-css-aka-stylo/)来解释 CSS 引擎如何工作，你不能错过它！话说回来，值，规范里说：

> 一个属性的最终值是**四步计算**的结果：首先通过规范确定值（「**指定值**」），然后解析为一个用于继承的值（「**计算值**」），然后如果有必要，转换成绝对值（「**使用值**」），最后依据具体场景限制再做转换（「**实际值**」）。

与此同时，依据规范，[高度和 margin 的计算](https://www.w3.org/TR/CSS2/visuren.html#relative-positioning)由各类盒模型的许多规则决定的。如果上下的值同时为 auto，它们的使用值将被解析成 `0`。

![Margins resolving to zero](https://www.chenhuijing.com/images/posts/vertical-typesetting/zero-640.jpg)

当我们将书写模式设置成垂直，「height」似乎在计算的时候会变成水平坐标。我说似乎是因为我并不百分百确定它真的是这样计算的。它让我觉得 Javascript 解决方案很神奇。

开个玩笑，实际上因为我们在 Javascript 解决方案中没有混用书写模式，所以将各自的值解析为 `0` 并不影响我们想要的居中效果。可能你需要重读这一句话几次 🤷。

想要在切换到垂直书写模式的时候将 `main` 元素水平居中，我们需要使用好的变换技巧。

```
.c-switcher__checkbox:not(:checked) ~ main {
  position: absolute;
  top: 0;
  right: 50%;
  transform: translateX(50%);
}
```

这在 Chrome，Firefox 和 Safari 上可行。不幸的是，Edge 上有点毛病，东西都歪向页面中间的某个地方以及左边。是时候记录下这个 Edge 的 bug。另外，滚动条出现在了左侧而不是右侧。

![Seems to be buggy on Edge](https://www.chenhuijing.com/images/posts/vertical-typesetting/troublemaker-640.jpg)

## 处理图像对齐

好了，继续。当在垂直书写模式时，我希望有两张图片的 figure 元素堆叠显示，而在水平书写模式中，如果空间允许，则并排显示。理想情况下，figure 元素（图像和标题）将在各自的书写模式下居中。

### 经典的属性

既然我们正在一个干净的页面工作，让我们试试最基础的居中技术：`text-align`。默认情况下，图像和文本是内联元素。给 figure 元素设置 `text-align: center`，天呐，成功了 😱！

水平和垂直书写模式下的图像都已经成功地居中了。我现在非常怀疑一年前我做这个的时候的智商。显然，为了我的目的和意图，弹性盒模型是不必要的。我首先尝试了新的技术，但它让我付出了代价。

真是醉了 🥃。

在水平书写模式中，不需要添加太多东西。只是一个简单的 `margin-bottom: 1em`，给 figure 之间留空间。由于空间关系，我确实需要将竖直的图像旋转，在这里我使用 transform 的 rotate 来完成。

```
.vertical {
  figure {
    margin-bottom: 1em;
  }

  figcaption {
    max-width: 30em;
    margin: 0 auto;
    display: inline-block;
    text-align: justify;
  }

  .img-rotate {
    transform: rotate(-90deg);
  }
}
```

问题是，当你旋转了一个元素，浏览器仍然会记住它原来的宽高（我想），所以在我的 demo 中，当视窗变得非常窄的时候，它将触发水平溢出。可能有办法修复这个问题，但我没有找到。欢迎指教。

这就是我将为 RICG 编写的用例。想法是，如果可以通过媒体查询得到书写模式，我就可以使用 `srcset` 定义一个垂直的图像和一个水平的图像，分别为对应的书写模式提供图片。

在垂直书写模式中，我们通常希望文字整齐，或者至少在短行上对齐半孤立的字符。然后文字间的空隙，margin 应该设置为 left 而不是 bottom。

```
.vertical {
  figure {
    margin-left: 1em;
  }

  figcaption {
    max-height: 30em;
    margin: auto 0.5em;
    display: inline-block;
    text-align: justify;
  }
}
```

现在我们几乎可以称之为圆满的一天。最终结果已经实现了目标。我想补充说的是，除了我之前提到的 Edge 缺陷之外，无论 Javascript 方案还是复选框 hack 方案都是完全相同的。

### 使用弹性盒模型居中

我怀疑我选择弹性盒模型实现居中的理由，尽管老实说我想不起来到底为什么我觉得这是一个好主意。显然，我不需要弹性盒模型的任何特点。那我应该也做个大脑转储？

但看了一眼我的源码，我才发现我给包裹图像的应该堆叠的 `div` 设置了 `display: flex`，这让图像成为了弹性容器的子元素，导致 Firefox 的垂直书写模式渲染混乱。

![Flexbox issue with vertical writing-mode on Firefox](https://www.chenhuijing.com/images/posts/vertical-typesetting/ffbug-640.jpg)

使用这种方法，东西看上去都很美好，而且我测试过的 Chrome，Edge 以及 Safari 的所有版本（前面提到的列表）都可行，因此图像在垂直和水平两种模式下都居中对齐。但 Firefox 不行，真的，切换到垂直书写模式时，图片在我的页面上不可见，虽然在水平模式下很好。

![Flexbox issue with vertical writing-mode on Firefox](https://www.chenhuijing.com/images/posts/vertical-typesetting/ffbug2-640.jpg)

我已经用 `display: flex` 的 `div` 包裹了应该堆叠显示的图像，但不知为何在 Firefox 的垂直模式下搞砸了。我怀疑这个行为和这些 bug 有关：[Bug 1189131](https://bugzilla.mozilla.org/show_bug.cgi?id=1189131)， [Bug 1223180](https://bugzilla.mozilla.org/show_bug.cgi?id=1223180), [Bug 1332555](https://bugzilla.mozilla.org/show_bug.cgi?id=1332555)， [Bug 1318825](https://bugzilla.mozilla.org/show_bug.cgi?id=1318825) 和 [Bug 1382867](https://bugzilla.mozilla.org/show_bug.cgi?id=1382867)。

与此同时，我对 Firefox 下，在垂直书写模式中作为弹性容器子元素的图像的效果产生了好奇。好像浏览器直接对你说不 ♀️ 🙅 💩。

![Flexbox issue with vertical writing-mode on Firefox](https://www.chenhuijing.com/images/posts/vertical-typesetting/whoa-640.jpg)

抛开垂直书写模式，我和 [Jen Simmons](http://jensimmons.com/) 交流过不同浏览器的 flexbox 实现，她发现在所有的浏览器中，缩小图像的处理都是不同的。[这个问题](https://github.com/w3c/csswg-drafts/issues/1322)仍在 CSS 工作组中讨论，敬请期待更新。

这个缩小的问题与固有尺寸的概念有关，尤其是含有固有长宽比例的图像。CSS 工作组对此有过[相当长的讨论](https://github.com/w3c/csswg-drafts/issues/1112)，因为这不是一个小问题。

Firefox 上一个有趣的观察是，弹性容器的宽被视窗的宽度限制，但目前没有在别的浏览器上发现这个问题。当容器内所有的图片的宽度之和超过了视窗宽度，在 Firefox 上，图像会缩小以适应宽度，但在别的所有的浏览器上，它们只会溢出然后你会得到一个水平滚动条 🤔。

为了暂时避免这个问题，我要确保我的图像都不是弹性容器的子元素。所有的图像，无论是单还是双，都被包裹在额外的 `div`中。`figure` 元素设置了 `display: flex` 属性，让 `figcaption` 和包裹图像的 `div` 成为弹性容器的子元素而不是图像本身。

```
.vertical {
  writing-mode: vertical-rl;

  main {
    max-height: 35em;
    margin-top: auto;
    margin-bottom: auto;
  }

  figure {
    flex-direction: column;
    align-items: center;
    margin-left: 1em;
  }

  figcaption {
    max-height: 30em;
    margin-left: 0.5em;
  }

  .img-single {
    max-height: 20em;
  }
}

.horizontal {
  writing-mode: horizontal-tb;

  main {
    max-width: 40em;
    margin-left: auto;
    margin-right: auto;
  }

  figure {
    flex-wrap: wrap;
    justify-content: center;
    margin-bottom: 1em;
  }

  figcaption {
    max-width: 30em;
    margin-bottom: 0.5em;
  }

  .img-wrapper img {
    vertical-align: middle;
  }

  .img-single {
    max-width: 20em;
  }

  .img-rotate {
    transform: rotate(-90deg);
  }
}

```

复选框 hack 的实现完全一样。我从中学习到的是，浏览器对于元素的区域计算需要下很大功夫，尤其是具有固有尺寸比例的。

### Grid 怎么样？

我们已经在布局所需上走了很远，所以我考虑尝试使用 Grid 来实现图像对齐。我们可以尝试让每个 `figure` 都成为一个 grid 容器，或许可以用上 `grid-area` 和 `fit-content` 这些有趣的属性让东西对齐。

不幸的是，十分钟的尝试之后，我脑袋炸了。Firefox 的 grid 调试器并不能匹配我页面上的元素，但也有可能是因为页面上太多东西了。

![Grid inspector tool issue in vertical writing-mode](https://www.chenhuijing.com/images/posts/vertical-typesetting/gridtool-640.jpg)

我需要为使用 grid 的垂直书写模式创建一个简化的测试用例，那将是一个简单得多的 demo，我还会单独写一篇文章（可能还有相关的错误报告）。

## 成功的解决方案？

当前完成的我的[独立 demo](https://www.chenhuijing.com/zh-type/) 使用的是不用弹性盒模型的复选框 hack 解决方案。我将保留复选框 hack 的版本以追踪 Edge 的 bug。但弹性盒模型解决方案，如果你不介意多余的包裹，也是可以的。用于 Javascript 实现的标记也看起来更好，因为你将切换器包裹在一个 `div` 中然后写样式。

在最后，有很多方法可以实现同样的结果。从别的地方拷贝代码也可以，但是出现莫名其妙的问题就麻烦了。你不必从头开始编写所有东西，但要确保里面没有无法破译的「魔法」。

说说而已 😎。

## 延伸阅读

* [严格模式下不允许分配只读属性](https://devtidbits.com/2016/06/12/assignment-to-read-only-properties-is-not-allowed-in-strict-mode/)
* [内置的超快 CSS 引擎: Quantum CSS (又称 Stylo)](https://hacks.mozilla.org/2017/08/inside-a-super-fast-css-engine-quantum-css-aka-stylo/)
* [CSS 写作模式 级别三](https://www.w3.org/TR/css-writing-modes-3/)
* [CSS 弹性盒模型布局 模块 级别一 编辑草案](https://drafts.csswg.org/css-flexbox/)
* [CSS 内部与外部尺寸 模块 级别三](https://www.w3.org/TR/css-sizing-3/)

## 问题和错误列表

* [Firefox Bug 1102175: writing-mode 为 vertical-rl 的`<body>`元素子元素不向右对齐](https://bugzilla.mozilla.org/show_bug.cgi?id=1102175)
* [Firefox Bug 1189131: 当书写模式为vertical-rl时，flex align-items center会移动文本](https://bugzilla.mozilla.org/show_bug.cgi?id=1189131)
* [Firefox Bug 1223180: Flex + 垂直书写模式: flex 元素 / 文本 消失](https://bugzilla.mozilla.org/show_bug.cgi?id=1223180)
* [Firefox Bug 1332555: [书写模式] 垂直书写模式的子元素固有大小错误，因此重绘后大小不适](https://bugzilla.mozilla.org/show_bug.cgi?id=1332555)
* [Firefox Bug 1318825: [css-flexbox] 垂直书写模式下 Flex 元素在水平弹性容器中宽度错误](https://bugzilla.mozilla.org/show_bug.cgi?id=1318825)
* [Firefox Bug 1382867: 书写模式和弹性盒模型的布局问题](https://bugzilla.mozilla.org/show_bug.cgi?id=1382867)
* [CSSWG Issue #1322: [css-flexbox] 与图像缩小不兼容](https://github.com/w3c/csswg-drafts/issues/1322)
* [Chromium Issue 781972: 调整大小时，图像不保留宽高比](https://bugs.chromium.org/p/chromium/issues/detail?id=781972)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

