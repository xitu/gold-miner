> * 原文地址：[All you need to know about hyphenation in CSS](https://clagnut.com/blog/2395)
> * 原文作者：[Richard Rutter](https://clagnut.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/hyphenation-in-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/hyphenation-in-css.md)
> * 译者：[马猴烧酒](https://github.com/Augustwuli)
> * 校对者：[L9m](https://github.com/L9m)

![在古腾堡圣经的一些内容中，许多句子都使用了连字符。](https://user-gold-cdn.xitu.io/2019/4/14/16a199cf29a9d077?w=1086&h=246&f=jpeg&s=115352)

月初我应邀在维也纳的奥地利印刷学会（[tga](http://typographischegesellschaft.at/)）做了一场[晚间讲座](http://typographischegesellschaft.at/k_vortrag_workshop/v_rutter.html)。我很荣幸能够做这样一个演讲，因为这意味着我将追随马修·卡特（Matthew Carter）、维姆·克鲁维尔（Wim Crouwel）、玛格丽特·卡尔弗特（Margaret Calvert）、埃里克·斯皮克曼（Erik Spiekermann）和已故的弗雷达·萨克（Freda Sack）等名人的脚步。

我展示了一些 Web 排版的黄金准则，在之后的问答环节中，我被问到关于 Web 自动断字的现状。这是一个恰当的问题，因为德语以长单词而闻名 —— 尤其在名词复合词中很常见（例如 Verbesserungsvorschlag 意为改进建议）—— 所以使用连字符断字在大多数书面媒体中被广泛使用。

自 2011 年以来，Web 上的自动断字已经成为[可能](https://clagnut.com/blog/2394)，现在得到了[广泛的支持](https://caniuse.com/#feat=css-hyphens)。Safari、Firefox 和 Internet Explorer 9 以上版本支持自动断字，Android 和 MacOS 上的 Chrome 也支持自动断字（但 [Windows 或 Linux](https://bugs.chromium.org/p/chromium/issues/detail?id=652964) 上还没有）。

## 如何开启自动断字

打开自动断字需要两个步骤。首先设置文本语言。这将告诉浏览器使用哪个断字字典 —— 正确的自动断字需要一个适合文本语言的断字字典。CSS 指南说，如果浏览器不知道文本的语言，即使在样式表中打开连字符，也不会自动断字。

断字是一门复杂的学科。断字点主要以词源和音系相结合的音节为基础，但特定机构也有不同的断字规则。

### 1. 设置语言

网页语言应该使用 HTML 的 `lang` 属性设置。

```html
<html lang="en">
```

设置文本语言有益于自动翻译工具、屏幕阅读器和其他辅助软件，无论是否使用断字，这种方式都是所有 Web 页面的最佳实践。

`lang="en"` 属性通过使用一个 [ISO 语言标签](https://www.w3.org/International/articles/language-tags/) 告诉浏览器文本使用的是英语。这个案例中，浏览器将会选择它默认的英语断字字典，这意味着使用美式英语的断字。虽然美式英语和其他国家在拼写和发音（因此断字）上有很大差异，但在葡萄牙语等语言上的差异可能更大。解决方案是在语言中添加一个「区域」，以便浏览器知道哪个是最合适的断字字典。例如，要指定巴西葡萄牙语或英式英语：

```html
<html lang="pt-BR">
<html lang="en-GB">
```

### 2.启用断字

到目前为止，已经设置好了语言，可以在 CSS 中打开自动断字。这再简单不过了：

```css
hyphens: auto;
```

目前 Safari 和 IE/Edge 都需要前缀，所以需要在属性前面加对应的前缀：

```css
-ms-hyphens: auto;
-webkit-hyphens: auto;
hyphens: auto;
```

## 断字控制

设置断字不仅仅是打开断字。[CSS Text Module Level 4](https://www.w3.org/TR/css-text-4/#hyphenation) 引入了布局软件（例如 InDesign）和一些文字处理器（包括 Word）。这些控制提供了不同的方法来定义文本中出现了多少断字。

### 限制断字前后的单词的长度和字符数

如果你用连字符连接短单词，它们会更难读。同样，您也不希望在连字符之前的行上留下太少的字符，或者在连字符之后被移到下一行。一个常见的经验法则是，只允许至少有 6 个字母长的单词用连字符连接，在单词断开之前至少留下 3 个字符，并在下一行至少保留 2 个字符。

《牛津风格手册》（Oxford Style Manual）建议，换行符中连字符后的最小字母数是 3，不过也可以在很短的时间内出现例外。

您可以使用断字 `hyphenate-limit-chars` 属性设置这些限制。它使用三个空格分隔值。第一个是连字符的最小字符限制；二是连字符前的最小字符数；最后是连字符后的最小字符。要设置前面提到的规则，限制 6 个字符的字数，在断字符前加 3 个字符，在断字符后加 2 个字符，请使用：

```css
hyphenate-limit-chars: 6 3 2;
```

![](https://user-gold-cdn.xitu.io/2019/4/14/16a199d2387ba79e?w=1074&h=186&f=png&s=33030)

> hyphenate-limit-chars 实现效果。

对于所有这三个设置，`hyphenate-limit-chars` 的默认值都是 `auto`。这意味着浏览器应该根据当前的语言和布局选择最佳设置。CSS Text Module Level 4 建议浏览器使用 `5 2 2` 作为起始点（我认为这会导致有太多的连字符），但是浏览器可以根据自己的需要随意更改。

目前，只有 IE/Edge 支持这个属性（带有前缀），但是 Safari 确实支持使用 CSS3 Text Module 早期草稿中指定的一些遗留属性限制连字符。这意味着你可以在 Edge 和 Safari 中获得相同的控制（对 Firefox 进行一些提前规划），如下所示：

```css
/* 遗留属性 */
-webkit-hyphenate-limit-before: 3;
-webkit-hyphenate-limit-after: 2;

/* 建议使用 */
-moz-hyphenate-limit-chars: 6 3 2; /* not yet supported */
-webkit-hyphenate-limit-chars: 6 3 2; /* not yet supported */
-ms-hyphenate-limit-chars: 6 3 2;
hyphenate-limit-chars: 6 3 2;
```

### 限制连续连字符行数

出于美学的原因，可以限制行中连字符的行数。连续连字符的线，特别是三条或三条以上的线，这被轻蔑地称为梯子。英语的一般经验法则是，连续两行是理想的最大值（相比之下，德语读者可能要面对许多梯子）。默认情况下，CSS 不限制连续连字符的数量，但是可以使用 `hyphenate-limit-lines` 属性指定最大值。目前，这只被 IE/Edge 和 Safari （带有前缀）支持。

```css
-ms-hyphenate-limit-lines: 2;
-webkit-hyphenate-limit-lines: 2;
hyphenate-limit-lines: 2;
```

![](https://user-gold-cdn.xitu.io/2019/4/14/16a199d39c2d9c8a?w=1089&h=372&f=png&s=95544)

> hyphenate-limit-lines 用来防止梯子。

你可以使用 `no-limit` 删除限制。

### 避免在段落的最后一行使用连字符

除非你告诉它，否则浏览器会很乐意用连字符连接一段的最后一个单词，这样断字的某位会单独出现在最后一行，就像孤儿一样孤独。通常，在倒数第二行末尾有一个大的空格比在最后一行有半个字要好。你可以通过激活值为 `always` 的 `hyphenate-limit-last` 属性来实现这一点。

```css
hyphenate-limit-last: always;
```

目前只支持 IE/Edge（带前缀）。

### 通过设置连字符区来减少连字符

默认情况下，只要浏览器可以在任意设置的 `hyphenate-limit-chars` 和 `hyphenate-limit-lines` 值内将一个单词分隔成两行，就会经常出现连字符。即使应用这些属性来控制什么时候发生断字，仍然可能出现大量的连字符段落。即使应用这些属性来控制什么时候发生断字，仍然可能出现大量的连字符段落。

考虑一个左对齐的段落。右边参差不齐，连字符可以减少。默认情况下，所有允许断字的单词都将被连字符连接。这将给你最大的断字量，从而最大限度地减少碎屑。如果你准备容忍段落边缘的不均匀，你可以减少连字符的数量。

可以通过指定行最后一个单词和文本框边缘之间允许的最大空白量来实现这一点。如果一个新单词在这个空格中开始，它没有连字符。这个空格称为连字符区。连字区越大，破碎处越多，断字越少。通过调整连字符区，你可以平衡更好的间距和更少的连字符之间的比例。

![](http://clagnut.com/images/1-handj-hyphenation-zone.png)

> **左**：箭头表示允许连字符的线。
> **右**：连字符与连字符区设置。
>
> 为此，你可以使用 `hyphenation-limit-zone` 属性，它接受一个长度或百分比值（根据文本框的宽度）。在响应式设计的上下文中，将连字符区设置为百分比是有意义的。这样做意味着在更小的屏幕会有更小的连字符区，从而导致更多的连字符和更少的碎屑。相反，在更宽的屏幕上，你会得到更宽的连字符区，因此更少的连字符和更多的碎屑，这是一个更宽的措施能更好的适应。基于页面布局软件的典型默认值，8% 是一个不错的开始：

```css
hyphenate-limit-zone: 8%
```

目前只支持 IE/Edge（带前缀）。

### 把它们放在一起

使用 CSS Text Module Level 4 属性对段落应用与传统布局软件相同的连字符控制（至少逐行使用）：

```css
p {
    hyphens: auto;
    hyphenate-limit-chars: 6 3 3;
    hyphenate-limit-lines: 2;
    hyphenate-limit-last: always;
    hyphenate-limit-zone: 8%;
}
```

以及适当的浏览器前缀和回退：

```css
p {
    -webkit-hyphens: auto;
    -webkit-hyphenate-limit-before: 3;
    -webkit-hyphenate-limit-after: 3;
    -webkit-hyphenate-limit-chars: 6 3 3;
    -webkit-hyphenate-limit-lines: 2;
    -webkit-hyphenate-limit-last: always;
    -webkit-hyphenate-limit-zone: 8%;

    -moz-hyphens: auto;
    -moz-hyphenate-limit-chars: 6 3 3;
    -moz-hyphenate-limit-lines: 2;
    -moz-hyphenate-limit-last: always;
    -moz-hyphenate-limit-zone: 8%;

    -ms-hyphens: auto;
    -ms-hyphenate-limit-chars: 6 3 3;
    -ms-hyphenate-limit-lines: 2;
    -ms-hyphenate-limit-last: always;
    -ms-hyphenate-limit-zone: 8%;

    hyphens: auto;
    hyphenate-limit-chars: 6 3 3;
    hyphenate-limit-lines: 2;
    hyphenate-limit-last: always;
    hyphenate-limit-zone: 8%;
}
```

连字符是渐进式增强的一个完美例子，因此，如果你正在制作一个有长单词语言内容的网站，那么现在就可以开始应用上面的方法 —— 浏览器之间的支持只会增加。如果你在为一个用长单词写的网站设计，比如德语，你的读者一定会感谢你的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
