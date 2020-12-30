> * 原文地址：[Improve Page Rendering Speed Using Only CSS](https://blog.bitsrc.io/improve-page-rendering-speed-using-only-css-a61667a16b2)
> * 原文作者：[Rumesh Eranga Hapuarachchi](https://medium.com/@rehrumesh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/improve-page-rendering-speed-using-only-css.md](https://github.com/xitu/gold-miner/blob/master/article/2020/improve-page-rendering-speed-using-only-css.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：[regonCao](https://github.com/regon-cao)、[NieZhuZhu](https://github.com/NieZhuZhu) 

# 使用 CSS 提升页面渲染速度

![Image by [Arek Socha](https://pixabay.com/users/qimono-1962238/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1726153) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1726153)](https://cdn-images-1.medium.com/max/2560/1*o38gRq5SvLMtgjMMo5Ph7A.jpeg)

用户喜欢流畅的 Web 应用体验。他们希望页面可以快速加载并且平稳运行。如果用户在浏览网站过程中出现断断续续的动画或延迟，那么他们极有可能离开该网站。作为开发人员，你可以在改善用户体验上做很多事情。本文将重点介绍 4 个可以提升页面渲染速度的 CSS 技巧。

## 1. Content-visibility

一般来说，大多数 Web 应用都有复杂的 UI 元素，其关联的内容超出了用户在浏览器视图中的可视范围。这种情况下，我们可以设置 `content-visibility` 属性来跳过对屏幕以外内容的渲染。如果有大量屏幕以外内容，这将大大减少页面渲染时间。

这是最新添加的特性之一，它是提高渲染性能最具影响力的特性之一。 `content-visibility` 接收多个值，我们可以在一个元素上使用 `content-visibility: auto;` 立即获得性能提升。

让我们观察下面这个页面，它包含了多个不同信息的卡片。虽然屏幕可以显示大约 12 张卡片，但列表中大约有 375 张卡片。如你所见，浏览器用了 1037ms 来加载这个页面。

![Regular HTML page](https://cdn-images-1.medium.com/max/2256/1*8IqnZPmf3Gmw65XnMmQ6YQ.png)

接下来，你可以给所有卡片添加 `content-visibility` 属性。

> 在这个例子中，在页面添加了 `content-visibility` 后，渲染时间下降到了 150ms。性能提升了 **6 倍多**。

![With content-visibility](https://cdn-images-1.medium.com/max/2402/1*zL8hg1aj4ztMVDHe_W7BLQ.png)

正如你所见，content-visibility 属性非常强大，对于改善页面加载时间非常有用。到目前为止，根据我们讨论的内容，你一定认为它是提升页面渲染速度的灵丹妙药。

#### content-visibility 的局限性

然而，content-visibility 也有其不适合使用的场景。我想强调两点供你考虑。

* **该特性仍处于实验阶段** 
到目前为止，火狐(PC 和安卓版本)，IE(我认为他们并不计划把这个特性添加到 IE 中) 和 Safari (Mac 和 iOS)都不支持 content-visibility 属性。
* **滚动条相关的异常问题**. 
因为页面元素最初呈现的高度是 0px，所以当向下滚动时，这些元素就会出现在屏幕上。实际内容将被渲染，元素的高度也将相应地更新。这将使滚动条出现异常行为。

![Scroll behavior with content-visibility](https://cdn-images-1.medium.com/max/2000/1*_PZdobRzoAhQkqG-Kq5B3A.gif)

为了解决滚动条的问题，你可以使用另一个 CSS 属性 `container-intrinsic-size`。它可以指定一个元素的原始大小。因此元素将以指定的高度渲染，而不是以 0px。

```css
.element{
    content-visibility: auto;
    contain-intrinsic-size: 200px;
}
```

然而，在实践过程中，我发现如果有大量的元素将 `content-visibility` 设置为 `auto` ，即使使用 `container-intrinsic-size`，依然存在滚动条相关的小问题。

因此，我的建议是规划好页面布局，将其分解为多个模块，然后在这些模块上使用  content-visibility，从而使得滚动条行为正常。

## 2. Will-change 属性

浏览器上的使用动画已经不是新鲜事了。通常，浏览器会按照一定规律渲染这些动画和其他页面元素。但是，现在可以使用 GPU 来优化其中的某些动画操作。

> # 使用 CSS 的 will-change 属性，我们可以指定该元素修改特定属性，从而使浏览器执行前进行必要性能的优化。

其底层原理是浏览器为指定 will-change 属性的元素创建一个单独的层级。接着，它将元素的渲染和其他优化委托给 GPU。GPU 将加速接管动画的渲染，从而使得动画更加流畅。

考虑以下 CSS:

```css
// stylesheet 文件
.animating-element {
  will-change: opacity;
}

// HTML 文件

<div class="animating-elememt">
  Animating Child elements
</div>
```

在浏览器中渲染以上代码片段时，它将识别出 `will-change` 属性，并在之后的渲染中优化与透明度相关的更改。

> 根据 [Maximillian Laumeister](https://www.maxlaumeister.com/articles/css-will-change-property-a-performance-case-study/) 所做的性能基准测试，你可以看到，通过这一行修改，使得该元素获得了超过 120 帧/秒的渲染速度，最初大约是 50 帧/秒。

![Without using will-change; Image by Maximilian](https://cdn-images-1.medium.com/max/2000/0*KP2Dz1t5MCjqapBm.png)

![With will-change; Image by Maximilian](https://cdn-images-1.medium.com/max/2000/0*SM3J13ZbiJeAfmRo.png)

#### will-change 不适宜使用的场景

尽管 `will-change` 旨在提高渲染性能，但是如果你滥用它，也会导致 Web 应用性能的降低。

* **使用** `will-change` **表示该元素将来会发生改变。**
所以如果你试图将 `will-change` 和动画同时使用，这将不会带来任何优化。因此，建议在父元素上使用 will-change 属性，在子元素上使用动画。

```css
.my-class{
  will-change: opacity;
}

.child-class{
  transition: opacity 1s ease-in-out;
}
```

* **请不要在与动画无关的元素上使用。**
在元素上使用 `will-change` 属性时，浏览器会将该元素转移到新的层级并转交给 GPU 对其进行优化。如果没有任何会发生改变的内容，将会导致资源浪费。

最后，需要牢记的一点是：建议在完成所有动画后，从元素中移除 will-change 属性。

## 3. 减少渲染阻塞时间

如今，许多 Web 应用程序必须适配多种机型的浏览器，包括 PC，平板和手机等。要实现响应式布局，我们必须根据不同的媒体尺寸编写不同的样式。涉及到页面渲染时，在 CSS 对象模型（CSSOM）准备就绪前，浏览器无法启动渲染。
根据你的 Web 应用程序，你可能会拥有一个比较大的样式表，以适应所有设备的外形尺寸。

> 但是，假设我们根据页面加载优先级将其拆分为多个样式表。在这种情况下，我们可以只让主要的 CSS 文件阻塞关键路径，并将其作为高优先级下载，而让其他样式表以较低优先级下载。

```html
<link rel="stylesheet" href="styles.css">
```

![Single stylesheet](https://cdn-images-1.medium.com/max/2000/1*0LtBYTLTuUcK7J8ArX4sZA.png)

拆分成多个样式表后:

```html
<!-- style.css 只包含渲染页面所需的最少样式表 -->
<link rel="stylesheet" href="styles.css" media="all" />

<!-- 下面的样式表只有低优先级所必需声明的样式 -->
<link rel="stylesheet" href="sm.css" media="(min-width: 20em)" /><link rel="stylesheet" href="md.css" media="(min-width: 64em)" /><link rel="stylesheet" href="lg.css" media="(min-width: 90em)" /><link rel="stylesheet" href="ex.css" media="(min-width: 120em)" /><link rel="stylesheet" href="print.css" media="print" />
```

![](https://cdn-images-1.medium.com/max/2000/1*TiCgtB6JO9Ud5v0E0XblmQ.png)

可以看得，根据样式加载优先级分解样式表可以减少渲染阻塞时间。

## 4. 避免 @import 包含多个样式表

使用 `@import` 时，我们可以在一个样式表中加载另一个样式表。当我们在处理大型项目时，使用 `@import` 可使代码更简洁。

> 关于 `@import` 的一个主要事实是，它是阻塞调用的，因为它必须发出网络请求以获取文件，解析文件并将其包含在样式表中。如果在样式表中嵌套了 `@import`，将会影响渲染性能。

```css
# style.css
@import url("windows.css");

# windows.css
@import url("componenets.css");
```

![Waterfall with imports](https://cdn-images-1.medium.com/max/2056/1*kmPjWDOBdfzyVLsiLYmENA.png)

除了使用 `@import` 之外，我们还可以使用多个链接来获得更高的性能，因为它允许并行加载样式表。

![Waterfall with linking](https://cdn-images-1.medium.com/max/2106/1*-KPFrviQosYgL1KTZUQHYw.png)

## 结论

除了本文讨论的 4 个 CSS 技巧外，我们很难使用其他 CSS 方法来改善网页性能。CSS 的最新功能之一，即 `content-visibility` ，在未来看起来很有希望，因为它可以通过页面渲染获得多方面的性能提升。

> 最重要的是，我们无需编写任何 JavaScript 代码即可获得性能提升。

我相信你可以结合上述的某些 CSS 功能，最终能为用户构建性能更好的 Web 应用程序。希望本文对你能有所帮助，如果你知道其他任何可以提高 Web 应用程序的性能的 CSS 技巧，请在下面的评论中回复。谢谢！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
