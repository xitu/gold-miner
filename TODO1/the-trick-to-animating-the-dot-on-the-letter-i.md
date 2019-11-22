> * 原文地址：[The Trick to Animating the Dot on the Letter “i”](https://css-tricks.com/the-trick-to-animating-the-dot-on-the-letter-i/)
> * 原文作者：[Ali Churcher](https://css-tricks.com/author/alichurcher/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-trick-to-animating-the-dot-on-the-letter-i.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-trick-to-animating-the-dot-on-the-letter-i.md)
> * 译者：[vitoxli](https://github.com/vitoxli)
> * 校对者：[Baddyo](https://github.com/Baddyo)、[lzfcc](https://github.com/lzfcc)

# 让字母“i”的点动起来的秘密

![](https://res.cloudinary.com/css-tricks/image/fetch/w_1200,q_auto,f_auto/https://css-tricks.com/wp-content/uploads/2019/10/letter-i-collage.png)

诀窍是这样的：把土耳其字母“ı”和句号“.”结合起来，我们就可以创建一个看起来像是字母“i”但实际上却是两个独立的元素的东西。这为我们提供了一些有趣的选项，让我们能为“i”的点添加独立于其下部分的样式或动画。如果担心有可访问性方面的问题，那么不用担心，我们将介绍所知的最佳实践。

让我们来看看如何创建这些分离的“字母”并设置其样式，以及什么时候可以使用它们，什么时候不要使用它们。

### 一些例子

通过这种方式来实现的一些样式和动画：

来看看 Ali C（[@alichur](https://codepen.io/alichur)）在 [CodePen](https://codepen.io) 的[样式和动画](https://codepen.io/alichur/pen/vYYLdej)。

由于字母的两个部分都是常规的 Unicode 字符，因此它们会随着字体变化和页面缩放变化，正如其它普通文本一样。以下是一些不同字体、样式和缩放的示例：

来看看 Ali C（[@alichur](https://codepen.io/alichur)）在 [CodePen](https://codepen.io) 的[不同的字体和缩放](https://codepen.io/alichur/pen/YzzwYEG)。

### 逐步介绍这项技术

让我们来了解一下这项技术的工作原理。

#### 使用 Unicode 字符来组合

我们使用字符（ı）来表示去掉点的字符“i”和表示点的句号来进行组合。但是，我们同样可以使用其它字符，比如字符（ȷ）来表示去掉点的字符“j”，甚至可以使用表示音调的字符，比如“ñ”（~）或者“è”（`）。

通过把它们放到 span 标签中并设置 `display` 属性为 `block` 来把这些字符堆叠在一起。

```html
<span class="character">.</span>
<span class="character">ı</span>
```

```css
.character {
  display: block;
}
```

#### 对齐字符

它们需要距离彼此近一些。我们可以通过调整行高并去掉 margin 来实现。

```css
.character {
  display: block;
  line-height: 0.5;
  margin-top: 0;
  margin-bottom: 0;
}
```

#### 为点元素增加 CSS 动画

比如像这样的弹跳动画：

```css
@keyframes bounce {
  from {
    transform: translate3d(0, 0, 0);
  }

  to {
    transform: translate3d(0, -10px, 0);
  }
}

.bounce {
  animation: bounce 0.4s infinite alternate;
}
```

查看 CSS-Tricks 年鉴中[更多 CSS 动画](https://css-tricks.com/almanac/properties/a/animation/)。

目前为止应该是这样的：

来看看 Ali C（[@alichur](https://codepen.io/alichur)）在 [CodePen](https://codepen.io) 的[创建字母](https://codepen.io/alichur/pen/OJJNZYO)。

#### 添加单词中的其他字母

可以仅仅给“i”单独添加动画，但是“i”可能只是单词中的一个字母，比如“Ping”。我们将添加了动画的字母放在 span 标签中来确保所有内容都在一行。

```html
<p>
  P
  <span>
    <span class="character">.</span>
    <span class="character>ı</span> 
  </span>
  ng
</p>
```

[inline-block 会在元素间自动增加间隔](https://css-tricks.com/fighting-the-space-between-inline-block-elements/)，所以请先确保已经移除了它们之间的间隙。

最后阶段：

来看看 Ali C（[@alichur](https://codepen.io/alichur)）在 [CodePen](https://codepen.io) 的[在单词中添加字母](https://codepen.io/alichur/pen/WNNwzov)。

### 关于 SVG

通过两个或更多个 SVG 元素创建字母可以实现相同的效果。在这个示例中，圆形元素的动画独立于矩形元素。

来看看 Ali C（[@alichur](https://codepen.io/alichur)）在 [CodePen](https://codepen.io) 的[使用 SVG 为 i 添加动画](https://codepen.io/alichur/pen/eYYgyEB)。

尽管 SVG 字母无法随字体更改，但它为那些 Unicode 无法表示的字母部件和字体中不存在的字母样式提供了添加动画的可能性。

### 你将在哪里用到这些？

你想在哪里用到这些呢？我的意思是，对于 body 内容或者任何形式的长篇幅的内容，这项技术不是很好的实践。它不仅会影响可读性（你能想象在这篇文章中所有的“i”都使用了动画吗？），还会对辅助技术产生不好的影响，比如屏幕阅读器，我们将在下面对此进行讨论。

相反，当我们的内容更多地是出于装饰的目的时，使用这项技术是个很好的选择。通过这项技术来制作 logo，或者用在那些用来描述而不是通过辅助技术解释成文字的[图标中](https://css-tricks.com/tips-aligning-icons-text/)，都是很好的实践。

### 可访问性

回到我们的“Ping”例子，屏幕阅读器会将它读作 `P . ı ng`。这并不是我们期望听到的读音并且绝对会给任何听到它的人造成困扰。

可以根据用法添加不同的 ARIA 属性，从而使文本以不同的方式朗读。例如，我们可以将整个元素设置为图像并添加文本作为其标签：

```html
<div role=img aria-label="Ping">
  <p>P<span>.</span><span>ı</span>ng</p>
</div>
```

这样，外部 div 元素描述了屏幕阅读器读取的文本的含义。但是，我们还希望辅助技术能跳过内部元素。我们可以为添加 `aria-hidden="true"` 或 `role="presentation"`，这样它们便不会被解释为文本：

```html
<div role=img aria-label="Ping">
  <p role="presentation">P
    <span>.</span>
    <span>ı</span>
  ng</p>
</div>
```

以上只在一台 Mac 上的 Safari 中通过 VoiceOver 进行了测试。如果在其他辅助工具中遇到了任何问题，请在评论中进行留言。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
