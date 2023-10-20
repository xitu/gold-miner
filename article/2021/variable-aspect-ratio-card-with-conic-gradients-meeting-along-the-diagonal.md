> * 原文地址：[Variable Aspect Ratio Card With Conic Gradients Meeting Along the Diagonal](https://css-tricks.com/variable-aspect-ratio-card-with-conic-gradients-meeting-along-the-diagonal/)
> * 原文作者：[Ana Tudor](https://css-tricks.com/author/thebabydino/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/variable-aspect-ratio-card-with-conic-gradients-meeting-along-the-diagonal.md](https://github.com/xitu/gold-miner/blob/master/article/2021/variable-aspect-ratio-card-with-conic-gradients-meeting-along-the-diagonal.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[CarlosChenN](https://github.com/CarlosChenN)、[Usualminds](https://github.com/Usualminds)

# 对角线分割的圆锥渐变式可变长宽比卡片

我最近遇到了一个有趣的问题 —— 我需要实现一个具有可变纵横比（由用户决定）的卡片，且纵横比值定义在了 `--ratio` 这个自定义属性中。具有特定纵横比的卡片是 CSS 中的一个经典问题，也是近年来变得容易解决的问题，尤其是有了 [`aspect-ratio`](https://css-tricks.com/almanac/properties/a/aspect-ratio/) 之后，但这里棘手的部分是我们需要在每张卡片沿对角线交点处分别添加一个圆锥渐变，如图：

![一个 3 x 3 的正方形卡片网格，带有由圆锥渐变制成的彩色背景。渐变看起来像从卡片的对角延伸的条纹。每张卡片都以精美的字体展示 Hello Gorgeous 的名言。](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/var_cards.png?resize=799%2C571&ssl=1)

<small>用户设置的纵横比卡片。</small>

这里的挑战是，用 `linear-gradient()` 对沿着可变纵横比框的对角线做唐突的改变，比较容易，例如使用像“向左上角”这样的方向随纵横比变化，但 `conic-gradient()` 这个需要一个角度或一个百分比来表示它绕了一整圈走了多远的渐变并不好构建。

> 查看[这篇指南](https://css-tricks.com/a-complete-guide-to-css-gradients/#h-conic-gradients)以了解圆锥渐变的工作原理。

## 简单的解决方案

CSS 规范现在包括了 [三角函数和反三角函数](https://drafts.csswg.org/css-values-4/#trig-funcs)，它*可以*在这里帮助我们 —— 对角线与垂直线的角度是纵横比 `atan(var(--ratio))` 的反正切（矩形的左边缘和上边缘与对角线形成直角三角形，其中对角线与垂直线形成的角度的切线是宽度超过高度 —— 正是我们的纵横比）。

![插图：显示一个宽度为 w 和高度为 h 的矩形，从左下角到右上角绘制一条对角线。这条对角线是直角三角形的斜边，直角三角形的斜边是矩形的左边缘和上边缘。在这个直角三角形中，斜边（原始矩形的对角线）与垂直（原始矩形的左边缘）之间的夹角的切线是左边缘 (h) 上方的上边缘 (w)。](https://css-tricks.com/wp-content/uploads/2021/04/ang_diag.svg)

<small>对角线与垂直线（边）的夹角。</small>

把它写成代码，我们有：

```scss
--ratio: 3/ 2;
aspect-ratio: var(--ratio);
--angle: atan(var(--ratio));
background:
    /* below the diagonal */
    conic-gradient(from var(--angle) at 0 100%,
        #319197, #ff7a18, #af002d  calc(90deg - var(--angle)), transparent 0%),
    /* above the diagonal */
    conic-gradient(from calc(.5turn + var(--angle)) at 100% 0,
        #ff7a18, #af002d, #319197 calc(90deg - var(--angle)));
```

然而，目前没有浏览器实现三角函数和反三角函数，所以这个简单的解决方案我们也只能想想，留着未来实现。

## JavaScript 解决方案

我们当然可以使用 JavaScript 中的 `--ratio` 值来计算 `--angle`。

```javascript
let angle = Math.atan(1 / ratio.split('/').map(c => +c.trim()).reduce((a, c) => c / a, 1));
document.body.style.setProperty('--angle', `${+(180 * angle / Math.PI).toFixed(2)}deg`)
```

但是如果使用 JavaScript 不行呢？如果我们真的需要一个纯 CSS 解决方案怎么办？好吧，这有点麻烦，但我们还是可以做到！

## hacky CSS 解决方案

这是我从 SVG 渐变的特殊性中得到的一个想法，老实说，当我[第一次看到这个问题](https://css-tricks.com/state-css-reflections/#the-svg-gradient-problem) 时，我发现它非常令人沮丧.

假设我们有一个从底部到顶部的 `50%` 的渐变（因为在 CSS 中，这是一个角度为 `0°` 的渐变）。现在假设我们在 SVG 中有相同的渐变，我们将两个渐变的角度更改为相同的值。

在 CSS 中，这是：

```css
linear-gradient(45deg, var(--stop-list));
```

在 SVG 中，我们有：

```html
<linearGradient id='g' y1='100%' x2='0%' y2='0%'
                gradientTransform='rotate(45 .5 .5)'>
    <!-- 渐变停止 -->
</linearGradient>
```

如下所示，这两个不会给我们相同的结果。虽然 CSS 渐变实际上是在 `45°`，旋转了相同 `45°` 的 SVG 渐变沿着对角线在橙色和红色之间有明显的过渡，即使我们的盒子不是方形的，所以对角线不是在 `45°`！

![屏幕截图：显示 CSS 渐变为 45°（左）的矩形与从下到上 SVG 渐变旋转 45°（右）的矩形。该角度可通过底部的滑块进行调节。CSS 渐变实际上是 45°，但 SVG 渐变的线垂直于矩形的对角线。](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/css_vs_svg_grad.png?resize=999%2C556&ssl=1)

<small>`45°` CSS 与 SVG 渐变（[例子](https://codepen.io/thebabydino/full/pbVdPx)）。</small>

这是因为我们的 SVG 渐变被绘制在一个 `1x1` 方形框内，旋转了 `45°`，这使得沿着方形对角线从橙色突然变为红色。然后这个正方形被拉伸以适应矩形，这基本上改变了对角线的角度。

> 请注意，只有当我们不会将 `linearGradient` 的 `gradientUnits` 属性从其默认值 `objectBoundingBox` 更改为 `userSpaceOnUse` 时，才会发生 SVG 渐变失真。

### 基本思路

我们不能在这里使用 SVG，因为它只有线性和径向渐变，而没有圆锥渐变。但是，我们可以将 CSS 圆锥渐变放在一个方形框中，并使用 `45°` 角使它们沿对角线相交：

```css
aspect-ratio: 1/ 1;
width: 19em;
background: 
  /* 对角线之下 */
  conic-gradient(from 45deg at 0 100%, 
      #319197, #ff7a18, #af002d 45deg, transparent 0%), 
  /* 对角线之上 */
  conic-gradient(from calc(.5turn + 45deg) at 100% 0, 
      #ff7a18, #af002d, #319197 45deg);
```

然后我们可以使用缩放 `transform` 来拉伸这个方框 —— 诀窍是 `3/2` 中的 `/` 在用作 `aspect-ratio` 值时是一个分隔符，但在 `calc()` 中被解析为除法：

```css
--ratio: 3/ 2;
transform: scaley(calc(1/(var(--ratio))));
```

我们可以在下面嵌入的可编辑代码中更改 `--ratio` 的值来查看，这样，两个圆锥渐变总是沿对角线相交：[CodePen](https://codepen.io/thebabydino/pen/QWdzOVg)

> 请注意，此演示仅适用于 [支持 `aspect-ratio`](https://caniuse.com/mdn-css_properties_aspect-ratio) 的浏览器。此属性在 Chrome 88+ 中支持开箱即用，但 Firefox 仍需要在 about:config 中将 `layout.css.aspect-ratio.enabled` 标志设置为 `true`。如果你使用的是 Safari……好吧，对不起！

![显示如何启用 Firefox 标志的屏幕截图。转到 about:config（在地址栏中键入该内容 —— 系统可能会询问你是否确定要在允许进入之前弄乱这些内容）。使用搜索栏查找“aspect” —— 这应该足以显示标志。将其值设置为 true。](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/flag_enable_firefox.png?resize=999%2C206&ssl=1)

<small>在 Firefox 中启用标志。</small>

### 这种方法的问题以及如何解决这些问题

不过，缩放实际的 `.card` 元素很少是一个好主意。对于我的用例，卡片位于网格上并且在它们上设置方向比例会弄乱布局（网格单元仍然是方形的，即使我们已经缩放了其中的 `.card` 元素）。它们也有被 `scaley()` 函数奇怪地拉伸的文本内容。

![屏幕截图：显示卡片元素如何垂直缩小，但它们占据的网格单元仍然保持方形，就像定向缩放之前的卡片一样。](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/issues_scaling_card_hlight_firefox.png?resize=999%2C367&ssl=1)

<small>缩放实际卡片的问题（[例子](https://codepen.io/thebabydino/pen/BapvOvr)）</small>

解决方案是为实际卡片提供所需的 `aspect-ratio`，并使用绝对定位的 `::before` 放置在文本内容后面（`z-index: -1`）以创建我们的 `background`。这个伪元素获得它的 `.card` 父元素的 `width` 并且最初是正方形的。我们还设置了之前的方向缩放和圆锥梯度。请注意，由于我们绝对定位的 `::before` 与它的 `.card` 父级的上边缘顶部对齐，我们也应该相对于这条边缘缩放它（`transform-origin` 需要有一个值沿 y 轴为 `0`，而 x 轴值无关紧要，可以是任何值）。

```scss
body {
    --ratio: 3/ 2;
    /* 其他装饰用的布局样式 */
}

.card {
    position: relative;
    aspect-ratio: var(--ratio);

    &::before {
        position: absolute;
        z-index: -1; /* 移到文字下方 */

        aspect-ratio: 1/ 1; /* 让卡片成为正方形 */
        width: 100%;

        /* 让它缩放到它所对其的顶部边缘 */
        transform-origin: 0 0;
        /* 使用 Transform 给他指定的缩放比 */
        transform: scaley(calc(1 / (var(--ratio))));
        /* 设置背景 */
        background: /* 对角线之下 */
                conic-gradient(from 45deg at 0 100%,
                        #319197, #af002d, #ff7a18 45deg, transparent 0%),
                    /* 对角线之上 */
                conic-gradient(from calc(.5turn + 45deg) at 100% 0,
                        #ff7a18, #af002d, #319197 45deg);
        content: '';
    }
}
```

> 请注意，在此示例中，我们已将样式从原生 CSS 修改为使用 SCSS。

这要好得多，因为它可以在下面的嵌入中看到，它也是可编辑的，因此我们可以修改 `--ratio` 并查看当我们更改其值时一切将如何完美地适应。

[CodePen](https://codepen.io/thebabydino/pen/MWJZPLe) 供代码参考与效果预览。

### 内边距问题

由于我们没有在卡片上设置 `padding`，文本可能会一直延伸到边缘，甚至稍微超出边界，因为它有点倾斜。

![屏幕截图：显示了这样一种情况，其中文本一直延伸到卡片的边缘，甚至出现了一点点，从而产生了丑陋的结果。](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/need_for_padding.png?resize=799%2C117&ssl=1)

<small>缺少 `padding` 会导致问题。</small>

这应该不会太难修复，对吧？我们只是添加了一个 `padding`，对吧？好吧，当我们这样做时，我们发现布局失效了！

![GIF：显示开发工具网格覆盖突出显示，虽然背景（使用缩放的伪创建）仍然具有所需的纵横比，但网格单元和其中的实际卡片更高。](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/padding_issue.gif?resize=800%2C324&ssl=1)

<small>添加 `padding` 会破坏布局。（[例子](https://codepen.io/thebabydino/pen/MWJZxdV)）</small>

这是因为我们在 `.card` 元素上设置的 `aspect-ratio` 是由 `box-sizing` 指定的 `.card` 框的纵横比。由于我们没有明确设置任何 `box-sizing` 值，它的当前值是默认值也就是 `content-box`。在这个框周围添加一个相同值的 `padding` 会给我们一个不同纵横比的 `padding-box`，让它不再与其它的元素的 `::before` 重合。

为了更好地理解这一点，假设我们的 `aspect-ratio` 为 `4/1`，`content-box` 的宽度为 `16rem`（`256px`）。这意味着 `content-box` 的高度是这个宽度的四分之一，计算得出结果是 `4rem` (`64px`)。所以 `content-box` 是一个 `16rem×4rem`（`256px×64px`）大的矩形。

现在假设我们沿着每条边添加一个 `1rem`（`16px`）的 `padding`。现在，`padding-box` 的宽度为 `18rem`（`288px`，如上面的动画 GIF 所示）—— 计算得出 `content-box` 的宽度为 `16rem`（` 256px`) ，再加上左侧的 `1rem` (`16px`) 和来自 `padding` 的右侧的 `1rem`。类似地，`padding-box` 的高度为 `6rem`（`96px`）—— 计算得出 `content-box` 的高度，即 `4rem`（`64px`），再加上顶部的 `1rem`（` 16px`）和底部的 `1rem` `padding`。

这意味着 `padding-box` 是一个 `18rem×6rem`（`288px×96px`）的矩形，并且由于 `18 = 3⋅6`，它的纵横比为 `3/1`，与我们为 `aspect-ratio` 属性设置的 `4/1` 值不一样！同时，`::before` 伪元素的宽度等于其父元素 `padding-box` 的宽度（我们计算为 `18rem` 或 `288px`），而且它的纵横比（通过缩放设置的）仍然是 `4/1`，所以它的视觉高度计算可得是 `4.5rem`（`72px`）。这就解释了为什么用这个伪元素创建的 `background` —— 垂直缩小到一个 `18rem×4.5rem`（`288px×72px`）的矩形 —— 现在却比实际的卡片 —— 一个带有 `padding` 的 `18rem×6rem`（`288px× 96px`) 矩形 —— 要小。

因此，看起来解决方案非常简单 —— 我们只需要将 `box-sizing` 设置为 `border-box` 就可以解决我们的问题，因为这会在这个盒子上应用 `aspect-ratio`（与 `padding-box` 当我们没有 `border` 时一致）。

果然，这可以解决问题……但仅限于 Firefox！

![屏幕截图：显示文本如何在 Chromium 浏览器（上图）中不居中对齐，而 Firefox（下图）则正确。](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/box_sizing_fix_collage.png?resize=799%2C459&ssl=1)

<small>显示 Chromium（上图）和 Firefox（下图）之间的区别。</small>

文本应该垂直居中对齐，因为我们给了 `.card` 元素一个网格布局，并在它们上设置了 `place-content: center`。然而，这不会发生在 Chromium 浏览器中。当我们删除最后一个声明时，这变得更加明显 —— 不知何故，卡片网格中的单元格也获得了 `3/1` 的纵横比，并溢出了卡片的 `content-box`：

![GIF：由于某种原因，卡片内的网格单元获得设置的纵横比并溢出卡片的内容框。](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/04/place_content_hint.gif?resize=800%2C300&ssl=1)

<small>使用 `place-content: center` 与否来检查卡片的网格。（[例子](https://codepen.io/thebabydino/pen/vYgvwBJ)）</small>

幸运的是，这是一个 [已知的 Chromium 错误](https://bugs.chromium.org/p/chromium/issues/detail?id=1166875)，并且[应该可以在未来几个月内得到修复](https://twitter.com/bfgeek/status/1385704283643932672)。

与此同时，我们可以做的就是从 `.card` 元素中移除 `box-sizing`、`padding` 和 `place-content` 声明，移动子元素（或用 `::after` 伪元素 —— 我指的是，如果只需要一行代码，不过我们很懒惰。当然如果我们希望文本保持可以被选择，则实际的子元素应该是更好的主意）并使其成为带有 `padding` 的 `grid`。

```scss
.card {
    /* 和以前一致，
       减去 box-sizing、place-content 和内边距定义
       最后两个我们移动的子元素 */

    &__content {
        place-content: center;
        padding: 1em
    }
}
```

[CodePen](https://codepen.io/thebabydino/pen/gOgqewy) 供代码参考与效果预览。

### 添加圆角

假设我们也希望我们的卡片有圆角。由于像 `::before` 伪元素上我们用 `scaley` 这样的定向的 `transform` 创建的 `background` *也会扭曲圆角*，因此实现这一点的最简单方法是设置一个 `border- radius` 在实际的 `.card` 元素上，并使用 `overflow: hidden` 切掉卡片之外的所有内容。

![屏幕截图：左图是一个有一个完美的圆形边界半径没有缩放的元素。右图有一个不均匀缩放的元素 —— 它的边界半径不再是完美的圆形，而是被缩放扭曲了。](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/04/scaling_altering_corner_rad.png?resize=799%2C391&ssl=1)

<small>非均匀缩放会扭曲圆角。（[例子](https://codepen.io/thebabydino/pen/VJQMmJ)）</small>

但是，如果在某些时候我们希望我们的 `.card` 的其他子代在它之外可见，这就会成为问题。所以，我们要做的是直接在创建卡片背景的 `::before` 伪元素上设置 `border-radius`，并在这个 `border-radius` 上沿 y 轴反转方向缩放 `transform`：

```scss
$r: .5rem;

.card {
    /* 和之前一致 */

    &::before {
        border-radius: #{$r}/ calc(#{$r}*var(--ratio));
        transform: scaley(calc(1 / (var(--ratio))));
        /* 和之前一致 */
    }
}
```

[CodePen](https://codepen.io/thebabydino/pen/RwKdKMv) 供代码参考与效果预览。

## 最终效果

把上面的代码合并起来，这是一个交互式演示，允许通过拖动滑块来更改纵横比 —— 每次滑块值更改时，`--ratio` 变量都会更新：[CodePen](https://codepen.io/thebabydino/pen/XWpyowX)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
