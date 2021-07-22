> * 原文地址：[Can We Create a “Resize Hack” With Container Queries?](https://css-tricks.com/can-we-create-a-resize-hack-with-container-queries/)
> * 原文作者：[Jhey Tompkins](https://css-tricks.com/author/jheytompkins/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/can-we-create-a-resize-hack-with-container-queries.md](https://github.com/xitu/gold-miner/blob/master/article/2021/can-we-create-a-resize-hack-with-container-queries.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 我们可以使用 Container 查询创造一个“缩放大小工具”吗？

如果你对 CSS 的新发展有所关注，你可能听说过 **Container 查询**即将到来。我们将在这里查看基础知识，但如果您想再看一看，请查看 Una 的 [Next Gen CSS CSS：@container](https://css-tricks.com/next-gen-css-container/) 一文（或者本人翻译并发表在掘金社区的 [下一代 CSS：@container](https://juejin.cn/post/6981456441341132837)）。在我们自己摸索基础知识之后，我们将用它们构建一些非常有趣的东西：对经典 CSS 模因的全新演绎，「彼得格里芬和他那百叶窗 Peter Griffin fussing with window blinds」。 ;)

那么，什么**是**容器查询？就是……就是……就像我们有媒体查询来查询诸如视口大小之类的东西一样，容器查询允许我们查询容器的大小。基于此，我们可以将不同的样式应用于所述容器的子项。

它是什么样子的？嗯，确切的标准正在制定中。但目前，它是这样的：

```css
.container {
  contain: layout size;
  /* Or... */
  contain: layout inline-size;
}

@container (min-width: 768px) {
  .child { background: hotpink; }
}
```

`layout` 关键字为元素开启 `layout-containment` 功能。`inline-size` 允许用户更具体地了解容器。这目前意味着我们只能查询容器的宽度 `width`，而使用 `size` 后，我们就可以查询容器的 `height`。

同样，我们现在做的事情**可能**仍然会在未来有所改变。在撰写本文时，使用容器查询（没有 [polyfill](https://github.com/jsxtools/cqfill)）的唯一方法隐藏在了 Chrome Canary 中的 Flags（`chrome://flags`）之后。我绝对建议您在 [csswg.org](https://drafts.c​​sswg.org/css-contain/#valdef-contain-layout) 上快速阅读这份草案。

开始尝试 Container 查询的最简单方法是制作几个带有可调整大小的容器元素的快速演示。

[CodePen jh3y/poeyxba](https://codepen.io/jh3y/pen/poeyxba)

[CodePen jh3y/zYZKEyM](https://codepen.io/jh3y/pen/zYZKEyM)

尝试在 Chrome Canary 中更改 `contain` 值并查看演示如何响应。这些演示使用不限制轴的 `contain: layout size`。当容器的 `height` 和 `width` 都满足特定阈值时，衬衫尺寸会在第一个演示中进行调整。第二个演示展示了每一个轴如何独立工作，比如说调整水平轴数值时胡须会改变颜色。

```css
@container (min-width: 400px) and (min-height: 400px) {
  .t-shirt__container {
    --size: "L";
    --scale: 2;
  }
}
```

这就是我们现在需要了解的有关容器查询的信息，这实际上只是一些新的 CSS 的样式……

唯一的问题是：到目前为止，我见过的大多数容器查询演示都使用了一个非常标准的“卡片”示例来演示这个概念。不要误会我的意思，因为卡片是容器查询的一个很好的用例，卡片组件实际上是容器查询的子代。考虑通用卡片设计以及它在不同布局中使用时如何受到影响，这是一个常见的问题。我们中的许多人都参与过我们最终制作各种卡片变化的项目，所有这些都迎合了使用它们的不同布局。

但是卡片并不能激发我们使用容器查询的想象力，我希望看到他们**有动力去**以更大的极限来做有趣的事情。我在那个 T 恤尺码演示中和他们尝试了一会儿，我将等到有更好的浏览器支持，直到我开始进一步深入研究（我目前是 [Brave](https://brave.com/) 用户）。但是后来 [Bramus](https://twitter.com/bramus) 分享了一个容器查询 polyfill！

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/can-we-create-a-resize-hack-with-container-queries-twiter-1.png)

这让我开始思考如何“破解”容器查询。

⚠️ **剧透警告：** 我的 Hack 没有用。很短时间内它确实起效了，或者至少我认为它奏效了。但是，这实际上是一件幸事，因为它引发了更多关于容器查询的对话。

我的想法是什么？ 我想创建类似于“Checkbox Hack”的东西，但用于容器查询。

```html
<div class="container">
  <div class="container__resizer"></div>
  <div class="container__fixed-content"></div>
</div>
```

这个想法是我们可以有一个容器，里面有一个可调整大小的元素，然后另一个元素在容器外固定定位，而调整容器大小可能会触发容器查询并重新设置固定元素的样式。

```css
.container {
  contain: layout size;
}

.container__resize {
  resize: vertical;
  overflow: hidden;
  width: 200px;
  min-height: 100px;
  max-height: 500px;
}

.container__fixed-content {
  position: fixed;
  left: 200%;
  top: 0;
  background: red;
}

@container(min-height: 300px) {
  .container__fixed-content {
    background: blue;
  }
}
```

尝试调整此演示中红色框的大小，它将改变紫色框的颜色。

[CodePen jh3y/mdWylBW](https://codepen.io/jh3y/pen/mdWyLBW)

## 我们可以用容器查询来做到经典的 CSS 模因吗？

看到上面那个作品奏效了，着实让我很兴奋。现在，我们终于有机会用 CSS 创建一个 Peter Griffin 的 CSS 模因版本并揭穿它！

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/05/giphy-downsized.gif?resize=640%2C480&ssl=1)

你可能已经看过这个表情包了。这是对 Cascade 的一击，管理它是多么困难。我使用 `cqfill@0.5.0` 创建了这个演示……当然，我自己做了一些小改动。 😅

[CodePen jh3y/LYxKjKX](https://codepen.io/jh3y/pen/LYxKjKX)

移动绳索手柄，调整元素的大小，进而影响容器的大小。不同的容器断点会更新 CSS 变量 `--open`，从 `0` 到 `1`，其中 `1` 等于“打开”状态，而 `0` 等于“关闭”状态。

```css
@container (min-height: 54px) {
  .blinds__blinds {
    --open: 0.1;
  }
}
@media --css-container and (min-height: 54px) {
  .blinds__blinds {
    --open: 0.1;
  }
}
@container (min-height: 58px) {
  .blinds__blinds {
    --open: 0.2;
  }
}
@media --css-container and (min-height: 58px) {
  .blinds__blinds {
    --open: 0.2;
  }
}
@container (min-height: 62px) {
  .blinds__blinds {
    --open: 0.3;
  }
}
@media --css-container and (min-height: 62px) {
  .blinds__blinds {
    --open: 0.3;
  }
}
```

但…。正如我所提到的，这种 Hack 是不可能的。

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/can-we-create-a-resize-hack-with-container-queries-twiter-2.png)

很棒的是，它引发了关于容器查询如何工作的对话。它还强调了容器查询 polyfill 的一个错误，该错误现已修复。不过，我很想看到这个 “Hack” 能正常运转。

Miriam Suzanne 一直在围绕容器查询创建一些精彩的内容。容器查询的能力已经发生了很大的变化，这就是生活在最前沿的风险。[她的最新文章](https://www.miriamsuzanne.com/2021/05/02/container-queries/)总结了当前的状态。

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/can-we-create-a-resize-hack-with-container-queries-twiter-3.png)

尽管我最初的演示/Hack 不起作用，但我们仍然可以使用“调整大小” Hack 来创建这扇百叶窗。同样，如果我们使用 `contain: layout size`，我们可以查询 `height`。旁注：有趣的是，我们目前无法使用 `contain` 根据调整其子元素的大小来查询容器的高度。

反正不管怎么说，看看下面这个演示：

[CodePen jh3y/jOBEKZO](https://codepen.io/jh3y/pen/jOBEKZO)

箭头随着容器的大小而旋转。这里的技巧是使用容器查询来更新作用域 CSS 自定义属性。

```css
.container {
  contain: layout size;
}

.arrow {
  transform: rotate(var(--rotate, 0deg));
}

@container(min-height: 200px) {
  .arrow {
    --rotate: 90deg;
  }
}
```

那么我们在这里有一个容器查询技巧。我们无法使用第一个 Hack 概念的缺点是我们不能完全实现 3D 效果。overflow `hidden` 将解决这个问题它。我们还需要将绳索穿过窗户下方，这意味着窗台会阻止我们实现效果。

不过，我们还是可以非常接近地实现这个效果了。

[CodePen jh3y/qBrEMEe](https://codepen.io/jh3y/pen/qBrEMEe)

上述演示使用预处理器生成容器查询步骤。在每一步，范围内的自定义属性都会更新。这就展示了彼得并打开了百叶窗。

这里的技巧是放大容器以使调整大小的句柄更大，然后我缩小内容以适应它原本的样子。

---

这个有趣的演示“揭穿模因”还无法 100% 实现，但是，我们已经越来越近了。容器查询是一个令人兴奋的前景。看看它们如何随着浏览器支持的发展而变化会很有趣。看到人们如何突破极限或以不同方式使用它们，也会令人兴奋。

谁知道？有一天，“Resize Hack”可能会与臭名昭著的“Checkbox Hack”并驾齐驱。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
