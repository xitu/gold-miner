> * 原文地址：[Adaptive video with CSS Math](https://medium.com/@yokselzok/adaptive-video-with-css-math-d71640c6068a)
> * 原文作者：[Йоксель Зок](https://medium.com/@yokselzok)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/adaptive-video-with-css-math.md](https://github.com/xitu/gold-miner/blob/master/article/2020/adaptive-video-with-css-math.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[regon-cao](https://github.com/regon-cao)

# 使用原生 CSS 实现自适应视频

我在研究 [CSS 数学函数](https://www.w3.org/TR/css-values-4/#calc-notation)时，曾考虑过响应式 iframe，也能找到一些现有的解决方案，例如[这个](https://css-tricks.com/fluid-width-video/)，但是需要使用包装器或 JavaScript。假如没有包装器，只使用原生 CSS 能实现相同的功能吗？

首先，我们需要获取视频的宽高比。然而无法从属性中获取视频的宽高比（此方法[存在](https://www.w3.org/TR/css-values-3/#attr-notation)于规范中，但浏览器不支持），因此需要使用自定义属性：

```HTML
<iframe
    width="560" height="315"
    style="--width: 560; --height: 315;"
    class="video"
    ...
></iframe>
```

自定义属性中的宽度和高度必须在没有 px 单位的情况下使用，否则无法处理这些值来计算视频的宽高比。

接着需要计算视频的宽高比：

```css
.video {
  --aspect-ratio: calc(var(--height) / var(--width));
}
```

并给高度添加单位：

```css
.video {
  --aspect-ratio: calc(var(--height) / var(--width));
  --height-with-units: calc(var(--height) * 1px);
}
```

在移动设备上 iframe 必须适应窗口大小，为此添加以下内容：

```css
.video {
  --aspect-ratio: calc(var(--height) / var(--width));
  --height-with-units: calc(var(--height) * 1px);
  
  max-width: 100%;
}
```

最后一步有点棘手，但也不是很难。在移动设备上，iframe 会被宽度压缩。如何才能获取实际的宽度呢？如果 iframe 被拉伸到页面宽度，那么页面宽度大约等于窗口宽度，那么我们可以使用 viewport 数值来表示 iframe 的宽度，它将等于 `100vw`。使用 iframe 实际的宽度以及宽高比，就可以计算高度：

```css
calc(100vw * var(--aspect-ratio))
```

这个表达式只适用于 iframe 的宽度等于窗口宽度的移动设备。桌面应用该怎么处理呢？可以根据屏幕大小，借助 CSS 数学计算为 iframe 获取适当的高度。用 `min()` 来选择哪个高度更适合：

```css
height: min(calc(100vw * var(--aspect-ratio)), var(--height-with-units));
```

如果从 `100vw` 计算的高度大于初始高度，则 `min()` 将选择初始高度，iframe 不会增长更多。相反，如果从 `100vw` 计算的高度小于初始高度，`min()` 将选择计算高度，iframe 将被高度压缩。

最终的 CSS 代码:

```CSS
.video {
  /* 获取宽高比 */
  --aspect-ratio: calc(var(--height) / var(--width));
  /* 给高度添加单位 */
  --height-with-units: calc(var(--height) * 1px);

  max-width: 100%;

  /* 获取初始最小高度
     或根据窗口宽高比来计算高度 */
  height: min(calc(100vw * var(--aspect-ratio)), var(--height-with-units));
}
```

打开[**在线示例**](https://codepen.io/yoksel/pen/oNxmgYq?editors=0100)并通过调整窗口大小来查看其工作方式。

**注意：** 如果在预处理器（SCSS、Less）中使用以上代码，要避免在不同的计量单位下处理 `min()`。使得预处理器强制忽略 CSS 数学函数，在 SCSS 中，函数名必须以大写字母：`Min(…)` 开头；而对于 Less 函数，必须这样包装：`~”min(…)”`。

我没有在实际项目中使用过这个解决方案，但希望它会有用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
