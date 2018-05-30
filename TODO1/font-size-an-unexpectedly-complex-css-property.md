> * 原文地址：[Font-size: An Unexpectedly Complex CSS Property](https://manishearth.github.io/blog/2017/08/10/font-size-an-unexpectedly-complex-css-property/)
> * 原文作者：[Manish Goregaokar](https://manishearth.github.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/font-size-an-unexpectedly-complex-css-property.md](https://github.com/xitu/gold-miner/blob/master/TODO1/font-size-an-unexpectedly-complex-css-property.md)
> * 译者：[zephyrJS](https://github.com/zephyrJS)
> * 校对者：[bambooom](https://github.com/bambooom)，[Colafornia](https://github.com/Colafornia)

# Font-size：一个意外复杂的 CSS 属性

[`font-size`](https://developer.mozilla.org/en/docs/Web/CSS/font-size) 是糟糕的 CSS 属性

这可能是每一个写过 CSS 的人都知道的属性。它随处可见。

但它也 **十分** 的复杂。

“它不过是个数值”，你说，“它能有多复杂呢？”

我曾经也这么认为，直到我开始致力于实现 [stylo](https://wiki.mozilla.org/Quantum/Stylo)。

Stylo 是一个将 [Servo](http://github.com/servo/servo/) 的样式系统集成到 Firefox 中的项目。这个样式系统负责解析 CSS，确定哪些规则适用于哪些元素，通过级联运行这些规则，最终计算并将样式分配给树中的各个元素。这不仅发生在页面加载上，也发生在各种事件（包括 DOM 操作）触发时，并且是页面加载和交互时间的一个重要部分。

Servo 使用 [Rust](https://rust-lang.org)，并在许多地方用到了 Rust 的并行安全特性，样式便是其中之一。Stylo 有潜力将这些加速技术带入 Firefox，以及更安全的系统语言带来的代码的安全性。

无论如何，就样式系统而言，我认为字体大小是它必须处理的最复杂的属性。当涉及到布局或渲染时，有些属性可能会更复杂，但 font-size 可能是样式中最复杂的属性。

我希望这篇文章能给出一个关于 web 会**变得多么复杂**的想法，同时也可以作为一些复杂问题的文档。在这篇文章中，我也将尝试解释一个样式系统是如何工作的。

好的。让我们看看 font-size 是有多么的复杂。

## 基础

该属性的语法非常简单。你可以将其指定为：

*   长度值（`12px`, `15pt`, `13em`, `4in`, `8rem`）
*   百分比值（`50%`）
*   将上述混合起来，使用 calc 来计算（`calc(12px + 4em + 20%)`）
*   绝对关键字（`medium`, `small`, `large`, `x-large`, 等等）
*   相对关键字（`larger`, `smaller`）

前三种用法在长度相关的 CSS 属性中十分常见。语法没有异常。

接下来两个很有趣。本质上，绝对关键字映射到各种像素值，并匹配 `<font size=foo>` 的结果（例如  `size=3` 就相当于 `font-size: medium`）。他们映射到的**实际值**并不简单，我将在后面的文章中讨论。

相对关键字基本上是向上或向下缩放。缩放的机制也是复杂的，但是这已经改变了。接下来我也会谈到这个。

## em 和 rem 单位

首先：`em` 单位。在任何基于长度的 CSS 属性中都可以指定为一个单位为 em 或 rem 的值。

`5em` 是指 “应用于元素的 font-size 的 5 倍”。`5rem` 是指 “根元素的 font-size 的 5 倍”

这意味着字体大小需要在所有其他属性之前计算（好吧，不完全是，但是我们将讨论这个！）以便在这段时间内它是可用的。

你也可以在 `font-size` 中使用 `em` 单位。在本例中，它是相对于**父**元素的字体大小计算的，而不是根据自身的字体大小来计算。

## 最小字体大小

浏览器允许您在它们的首选项中设置 “最小” 字体大小，文本不会比这个字体大小更小。这对于难以阅读小字的人来说是很有帮助的。

但是，这并不影响以 em 为单位的 font-size 属性。所以如果你使用最小字体大小，`<div style="font-size: 1px; height: 1em; background-color: red">` 将会有一个很小的高度（你可以通过颜色注意到），但文本的大小却会被限制在最小的尺寸上。

实际上这意味着你需要跟踪**两个**单独计算的字体大小值。其中一个值用于确定实际文本的字体大小（例如，用于计算 `em` 单位。），而当样式系统需要知道字体大小时使用另一个值。

但涉及到 [ruby](https://en.wikipedia.org/wiki/Ruby_character)（旁注标记）时，这会变得更加复杂。在表意文字中（通常指汉字及基于汉字的日本汉字和朝鲜汉字），为了帮助那些不熟悉汉字的读者，用拼音字来表达每个字符的发音有时是很有用的，这就是所谓的 “ruby”（在日语中被叫做 “[振り仮名](https://en.wikipedia.org/wiki/Furigana)”）。因为这些文字是表意的，所以学习者知道一个单词的发音却不知道如何书写它的情况并不少见。例如想要显示 <ruby><rb>日</rb><rt>に</rt><rb>本</rb><rt>ほん</rt></ruby>，则需要在日语的日本（日语中读作 “nihon”）上用 ruby 添加上平假名 にほん 。

如你所见，拼音部分的 ruby 文本字体更小（通常是主文本字体大小的 50%<sup id="fnref:1">[1](#fn:1)</sup>）。最小字体大小**遵守**这一点，并确保如果 ruby 应用 `50%` 的字体大小，则 ruby 的最小字体大小是原始最小字体大小的 `50%`。这就避免了 <ruby><rb>日</rb><rt style="font-size: 1em">に</rt><rb>本</rb><rt style="font-size: 1em">ほん</rt></ruby>（上下两段字设置成相同大小时）的情况，这样看起来将会很丑。

## 文字变大

Firefox 允许你在仅缩放的时候缩放文本。如果你在阅读一些小字时遇到了困难，那么在不需要整页放大的情况下就能把页面上的文本放大（这意味着你需要大量滚动），这是很好的体验。

在这个例子中，其他设置了 `em` 单位的属性也**要**被放大。毕竟，它们应该相对于文本的字体大小（并且可能与文本有某种关系），所以如果这个大小已经改变，那它们也应随之改变。

（当然，这个论点也适用于最小字体大小。但我不知道为什么最小字体没有应用。）

实际上这很容易实现。在计算绝对字体大小（包括关键字）时，如果文字缩放功能开启则它们会相应的缩放。而其他则一切照旧。

`<svg:text>` 元素禁止了文字缩放功能，这也引起了一些相当棘手的问题。

## 插曲：样式系统是如何工作的

再继续接下来的内容之前，我有必要概述下样式系统是如何工作的。

样式系统的职责是接受 CSS 代码和 DOM 树，并为每个元素分配计算样式。

这里的 “specified” 和 “computed” 是不一样的。“specified” 样式是在 CSS 中指定的样式，而计算样式是指那些附加到元素、发送到布局并继承自元素的那些样式。当应用于不同的元素时，指定的样式可以计算出不同的值。

所以当你**指定**了 `width: 5em`，它可能计算得出 `width: 80px`。计算值通常是指定值清理后的结果。

样式系统将首先解析 CSS，通常会生成一组包含声明的规则（声明类似于 `width: 20%;`；即属性名和指定值）

然后，它按照自顶向下的顺序遍历树（在 Stylo 中这是并行的），找出每个元素所适用的声明以及其执行顺序 - 有些声明优先于其他声明。然后，它将根据元素的样式（父样式和其他信息）计算每个相关声明，并将该值存储在元素的 “计算样式” 中。

为了避免重复的工作，Gecko 和 Servo 在这里做了很多优化<sup id="fnref:2">[2](#fn:2)</sup>。 有一个 bloom 过滤器用于快速检查深层后代选择器是否应用于子树。有一个 “规则树” 用于缓存已确定的声明。计算样式经常被引用、计数和共享（因为默认状态是从父样式或默认样式继承的）。

总的来说，这就是样式系统运作的基本原理。

## 关键字值

好吧，这就是事情变得复杂的地方。

还记得我说的 `font-size: medium` 会映射到某个值吗？

那么它映射到什么呢？

嗯，结果是，这取决于字体。对于以下 HTML：

```
<span style="font: medium monospace">text</span>
<span style="font: medium sans-serif">text</span>
```

你能从（[codepen](https://codepen.io/anon/pen/RZgxjw)）看到运行结果。

<div style="border: 1px solid black; display: inline-block; padding: 15px;"><span style="font: medium monospace">text</span> <span style="font: medium sans-serif">text</span></div>

其中第一个计算字体大小为 13px，第二个字体大小为 16px。你能从 devtools 的计算样式窗口得到答案，或者使用 `getComputedStyle()` 也行。

我**认为**这背后的原因是等宽字体往往更宽，而默认字体大小（medium）被缩小，使得它们看起来有相似的宽度，以及所有其他关键字字体大小也被改变。最终的结果就变成这样：

![](https://manishearth.github.io/images/post/font-size-table.png)

Firefox 和 Servo 有一个 [矩阵](https://github.com/servo/servo/blob/d415617a5bbe65a73bd805808a7ac76f38a1861c/components/style/properties/longhand/font.mako.rs#L763-L774) 用在计算基于“基本大小”（也就是 font-size: medium 的计算值）的所有绝对字体大小的关键字的值。实际上，Firefox 有 [三个表格](http://searchfox.org/mozilla-central/rev/c329d562fb6c6218bdb79290faaf015467ef89e2/layout/style/nsRuleNode.cpp#3272-3341) 来支持一些遗留用例，例如怪异模式（Servo 尚未添加对这三个表的支持）。我们在浏览器的其他部分查询“基本大小”时是基于语言和字体的。

等等，这和语言又有什么关系呢？语言是如何影响字体大小的？

实际上，基本大小取决于字体家族**和**语言，你可以对它进行配置。

Firefox 和 Chrome（使用扩展）实际上都允许你为每种语言设置使用哪些字体，**以及默认（基本）的字体大小**。

这并不像人们想象的那样晦涩难懂。对于非拉丁语系的文字，默认字体通常很难看。我单独安装了一个字体, 可以显示好看的天城文连字

同样的，有些文字也比拉丁文复杂得多。我为天城文设置的默认字体为 18 而不是 16。我已经开始学习普通话了，我也把字号设置为 18。汉字字形可能会变得相当复杂，我仍然很难学会（以及认识）它们。更大的字体对学习它们更有帮助。

总之，这不会让事情变得太复杂。这确实意味着 font family 需要在 font-size 之前计算，而 font-size 需要在大多数其他属性之前计算。语言可以通过 HTML 的 `lang` 属性来设置，由于它是可继承的，Firefox 内部将其视为一个 CSS 属性，必须尽早计算。

到此为止，还不算太糟。

现在，难以预料的事情出现了。这种对 language 和 family 的**依赖**是可以**继承的**。

快看，`div` 里面的字体大小是多少呢？

```
<div style="font-size: medium; font-family: sans-serif;"> <!-- base size 16 -->
    font size is 16px
    <div style="font-family: monospace"> <!-- base size 13 -->
        font size is ??
    </div>
</div>
```

对于可继承的 CSS 属性<sup id="fnref:3">[3](#fn:3)</sup>，如果父级的计算值是 `16px`，且子元素没有被指定其他值，那么子元素将继承这个 `16px` 的值。子元素不需要关心父元素是**从哪里**得到这个计算值的。

现在，`font-size` “继承”了一个 `13px` 的值。你能从这里（[codepen](https://codepen.io/anon/pen/MvorQQ)）看到结果：

<div style="border: 1px solid black; display: inline-block; padding: 15px;">
    <div style="font-size: medium; font-family: sans-serif;">font size is 16px
        <div style="font-family: monospace">font size is ??</div>
    </div>
</div>

基本上，如果计算的值来自关键字，那么无论 font family 或 language 如何变化，font-size 都会用关键字里的 font family 和 language 来重新计算。

这么做的原因是如果不这么做，不同的字体大小将无法工作。默认字体大小为 `medium`，因此根元素基本上会得到一个 `font-size: medium` 而其他元素将继承这个声明。如果在文档中将其改为等宽字体或使用其他语言，则需要重新计算字体大小。

不仅如此。它甚至通过**相对单位**继承（IE 除外）。

```
<div style="font-size: medium; font-family: sans-serif;"> <!-- base size 16 -->
    font size is 16px
    <div style="font-size: 0.9em"> <!-- could also be font-size: 50%-->
        font size is 14.4px (16 * 0.9)
        <div style="font-family: monospace"> <!-- base size 13 -->
            font size is 11.7px! (13 * 0.9)
        </div>
    </div>
</div>
```

([codepen](https://codepen.io/anon/pen/oewpER))

<div style="border: 1px solid black; display: inline-block; padding: 15px;">
    <div style="font-size: medium; font-family: sans-serif;">font size is 16px
        <div style="font-size: 0.9em">font size is 14.4px (16 * 0.9)

            <div style="font-family: monospace">font size is 11.7px! (13 * 0.9)</div>
        </div>
    </div>
</div>

因此，当我们从第二个 div 继承时，实际继承的是 `0.9*medium`，而不是 `14.4px`。

另一种看待这个问题的方法是，每当 font family 或 language 怎么变化，你都应该重新计算字体大小， 就好像 language 和 family 没有变化一样。

Firefox 同时使用了这两种策略。最初的 Gecko 样式系统通过实际返回树的顶部并重新计算字体大小来处理这个问题，就好像 language 和 family 是不同的一样。我怀疑这是低效的，但是规则树似乎使其略微高效了一些。

另一方面，在计算的同时，Servo 会存储一些额外的数据，这些数据会被复制到子元素中。基本上来说, 存储的内容相当于：“是的，这个字体是从关键字计算出来的。关键字是 `medium`，然后我们对它应用了 0.9 因子。”<sup id="fnref:4">[4](#fn:4)</sup>

在这两种情况下，这都会导致所有**其他**字体大小复杂性加剧，因为它们需要通过这种方式得到谨慎的保护。

在 Servo 里，**多数**情况都是通过 [font-size 自定义级联函数](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/longhand/font.mako.rs#L964-L1061) 来处理的。

## Larger/smaller

前面我提到了 `font-size: larger` 和 `smaller` 的是按比例缩放的，但还没有提到对应的比例值。

根据 [规范](https://drafts.csswg.org/css-fonts-3/#relative-size-value)，如果当前字体大小与绝对关键字大小的值匹配（medium，large 等），则应该选择上一个或下一个关键字大小的值。

如果是在两个绝对关键字值**之间**，则在前两个或后两个尺寸中间寻找相同比例的点。

当然，这必须很好地处理之前提到的关键字字体大小的奇怪继承问题。在 gecko 模型中这并不太难，因为 Gecko 无论如何都会重新计算。在 Servo 的模块中，我们存储一系列 `larger` 和 `smaller` 的应用和相对单位，而不是只存储一个相对单位。

此外，在文本缩放过程中计算此值时，必须先取消缩放，然后再在表中查找，然后重新缩放。

总的来说，一堆复杂的东西并没有带来多大的收益 —— 原来只有 Gecko 真正遵循了规范！其他浏览器引擎只是使用了简单的比例缩放。

所以我的解决方案 [就是把这种行为从 Gecko 上移除](https://bugzilla.mozilla.org/show_bug.cgi?id=1361550)。简化了这个处理过程。

## MathML

Firefox 和 Safari 支持数学标记语言 MathML。如今，它在网络上使用不多，但它确实存在。

当谈到字体大小时，MathML 也有它的复杂性。特别是 `scriptminsize`，`scriptlevel` 和 `scriptsizemultiplier`。

例如，在 MathML 中，分子、分母或是文字上标是其外部文本字体大小的 0.71 倍。这是因为 MathML 元素默认的 `scriptsizemultiplier` 为 0.71, 而这些特定元素的 scriptlevel 默认为 `+1`。

基本上，`scriptlevel=+1` 的意思是 “字体大小乘以 `scriptsizemultiplier`”，而 `scriptlevel=-1` 则用于消除这种影响。这可以通过在 `mstyle` 元素上设置 `scriptlevel` 属性指定。同样你也可以通过 `scriptsizemultiplier` 来调整（继承的）乘数因子，通过 `scriptminsize` 来调整最小值。

例如：

```
<math><msup>
    <mi>text</mi>
    <mn>small superscript</mn>
</msup></math><br>
<math>
    text
    <mstyle scriptlevel=+1>
        small
        <mstyle scriptlevel=+1>
            smaller
            <mstyle scriptlevel=-1>
                small again
            </mstyle>
        </mstyle>
    </mstyle>
</math>
```

显示如下（需要用 Firefox 来查看呈现版本，Safari 也支持 MathML，但支持不太好）：

<div style="border: 1px solid black; display: inline-block; padding: 15px;"><math><msup><mi>text</mi><mn>small superscript</mn></msup></math>
<math>text <mstyle scriptlevel="+1">small <mstyle scriptlevel="+1">smaller <mstyle scriptlevel="-1">small again</mstyle></mstyle></mstyle></math></div>

([codepen](https://codepen.io/anon/pen/BdZJgR))

所以这没那么糟。就好像 `scriptlevel` 是一个奇怪的 `em` 单位。没什么大不了的，我们已经知道如何处理这些问题了。

还有 `scriptminsize`。这使你可以**为 `scriptlevel` 所引起的更改**设置最小字体大小。

这意味着，`scriptminsize` 将确保 `scriptlevel` 不会导致出现比最小尺寸更小的字体，但它会忽略特意指定的 `em` 单位和像素值。

这里已经引入了一点微妙的复杂性，现在 `scriptlevel` 成了影响到 `font-size` 如何继承的另一个因素了。幸运的是，在 Firefox/Servo 的内部，`scriptlevel`（以及 `scriptminsize` 和 `scriptsizemultiplier`）也是作为 CSS 属性处理，这意味着我们可以使用与 font-family 和 language 一样的框架来处理 —— 在字体大小设置之前计算脚本属性，如果设置了 `scriptlevel`，则强制重新计算字体大小，即使没有设置字体大小本身。

### 插曲：早期和晚期处理属性

在 Servo 中，我们处理属性依赖关系的方式是拥有一组 “早期” 属性和一组 “后期” 属性（允许依赖于早期属性）。我们对声明进行了两次查找，一次是查找早期属性，另一次是后期属性。然而，现在我们有了一组相当复杂的依赖关系，其中 font-size 必须在 language、font-family 和脚本属性之后计算，但在其他所有涉及长度的东西之前计算。另外，由于另一个我没有谈到的字体复杂性，font-family 必须在所有其他早期属性之后进行计算。

我们处理这个问题的方法是在早期计算时 [抽离 font-size 和 font-family](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/properties.mako.rs#L3195-L3204) ，直到[早期计算完成后再处理它](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/properties.mako.rs#L3211-L3327)。

在这个阶段，我们首先[处理文本缩放的禁用](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/properties.mako.rs#L3219-L3233)，然后处理 [font-family 的复杂性](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/properties.mako.rs#L3235-L3277)。

然后[计算 font family](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/properties.mako.rs#L3280-L3303)。如果指定了字体大小，则[进行计算](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/properties.mako.rs#L3305-L3309)。如果没有指定，但指定了 font family，lang 或 scriptlevel，则[强制将计算作为继承](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/properties.mako.rs#L3310-L3324)，来处理所有的约束。

### 为什么 scriptminsize 会变得这么复杂

与其他 “最小字体大小” 不同，在字体大小被 scriptminsize 限制时，在任何属性中使用 `em` 单位都将用一个钳位值来计算长度，而不是 “如果没有被钳位” 的值, 如果字体大小被 scriptminsize 限制。因此，乍一看，处理这一点似乎很简单；当因为 scriptlevel 而需要缩放时, 只考虑最小字体大小  scriptminsize。

和往常一样，事情并没有这么简单 😀：

```
<math>
<mstyle scriptminsize="10px" scriptsizemultiplier="0.75" style="font-size:20px">
    20px
    <mstyle scriptlevel="+1">
        15px
        <mstyle scriptlevel="+1">
            11.25px
                <mstyle scriptlevel="+1">
                    would be 8.4375, but is clamped at 10px
                        <mstyle scriptlevel="+1">
                            would be 6.328125, but is clamped at 10px
                                <mstyle scriptlevel="-1">
                                    This is not 10px/0.75=13.3, rather it is still clamped at 10px
                                        <mstyle scriptlevel="-1">
                                            This is not 10px/0.75=13.3, rather it is still clamped at 10px
                                            <mstyle scriptlevel="-1">
                                                This is 11.25px again
                                                    <mstyle scriptlevel="-1">
                                                        This is 15px again
                                                    </mstyle>
                                            </mstyle>
                                        </mstyle>
                                </mstyle>
                        </mstyle>
                </mstyle>
        </mstyle>
    </mstyle>
</mstyle>
</math>
```

（[codepen](https://codepen.io/anon/pen/wqepjo)）

基本上来说, 如果你在达到最小字体大小后继续多次增加层级, 然后减掉一个层级, 是没法立即计算出 `min size / multiplier` 的值的。这使之变得不对称了, 如果乘数因子没有变化, 一个净层级为 `+5` 应该与一个净层级为 `+6 -1` 的元素具有相同字体大小。

因此，所发生的情况是，script level 是根据字体大小计算的**就好像 scriptminsize 从未应用过一样**，而且只有当脚本大小大于最小大小时，我们才使用该大小。

这不仅仅是跟踪 script level 还需要跟踪 multiplier 的变化。因此，这最终将创建**另一个要继承的字体大小值**。

概括地说，我们现在有**四**种不同的继承字体大小的概念：

*   样式使用的主要字体大小
*   “实际” 的字体大小，即主要的字体大小，但受限于最小值
*   （仅在 servo 中的）“关键字” 尺寸；即存储为关键字和比率的大小（如果它是从关键字派生的）
*   “不受脚本控制的” 尺寸；就像 scriptminsize 从不存在。

另一个复杂性在于下面这种情况应该仍然能正常工作：

```
<math>
<mstyle scriptminsize="10px" scriptsizemultiplier="0.75" style="font-size: 5px">
    5px
    <mstyle scriptlevel="-1">
        6.666px
    </mstyle>
</mstyle>
</math>
```

([codepen](https://codepen.io/anon/pen/prwpVd))

如果已经比 scriptminsize 还小，减少 script level（以增大字体大小）不应该被钳制，因为之后这会让它看起来过于巨大。

这基本上意味着, 只能在 script level 对应的值大于脚本最小字体大小时, 使用 scriptminsize。

在 Servo 中，所有 MathML 的处理都被[这个奇妙的注释比代码多的函数](https://github.com/servo/servo/blob/53c6f8ea8bf1002d0c99c067601fe070dcd6bcf1/components/style/properties/gecko.mako.rs#L2304-L2403)以及它附近函数的一些代码完美解决。

* * *

这就是你要了解的。`font-size` 实际上是相当复杂的。很多网络平台都隐藏着这样的复杂情况，但遇到了却会觉得十分有趣。

（当我必须实现它们时，可能就没那么有趣了。 😂）

感谢 mystor，mgattozzi，bstrie 和 projektir 审阅了这篇文章的草稿。

* * *

1. 有趣的是，在 Firefox 中，对所有的 ruby 来说这个数值为 50%，当语言为台湾中文时**除外**（此时为 30%）。 这是因为台湾使用一种名为 Bopomofo 的拼音文字，每一个汉字可由最多三个 Bopomofo 字符表示。因此，有可能选择一个合理的最小尺寸，使 ruby 永远不会超出下面的文字。另一方面，拼音最多可达 6 个字母，而日语平假名最多可达 (我认为) 5 个，相应的 “no overflow” 将使文字显得太小。 因此，将它们放在字上并不是问题，相反，为了更好的可读性，我们选择使用更大的字体大小。 此外，Bopomofo ruby 通常是放在文字的旁边而非顶部, 所以 30% 效果更好。（h/t @upsuper 指出了这一点）[↩](#fnref:1)
2. 其他的浏览器引擎也有其他的优化，但我还不了解它们。[↩](#fnref:2)
3. 有些属性是继承的，有些是 “reset” 的。例如，`font-family` 继承的 —— 除非另外设置。但是 `transform` 却不是，如果你在元素上应用了 transform 但它的子元素却不会继承这个属性。[↩](#fnref:3)
4. 这不能处理 `calc`s，这是我需要解决的问题。除了比率之外，还存储一个绝对偏移量。[↩](#fnref:4)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
