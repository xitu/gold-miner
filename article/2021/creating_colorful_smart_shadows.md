> * 原文地址：[Creating Colorful, Smart Shadows](https://www.kirupa.com/html5/creating_colorful_smart_shadows.htm)
> * 原文作者：[kirupa](https://www.kirupa.com/me/index.htm)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/creating_colorful_smart_shadows.md](https://github.com/xitu/gold-miner/blob/master/article/2021/creating_colorful_smart_shadows.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[CarlosChenN](https://github.com/CarlosChenN)、[Kim Yang](https://github.com/KimYangOfCat)

# 纯 CSS 创建五彩斑斓的智能阴影

几天前，我在 Home Depot（也就是大孩子的[玩具反斗城](http://en.wikipedia.org/wiki/Toys_R_Us)）处发现，他们有一个巨大的显示器来展示所有这些彩色的供销售的电灯泡！其中一项是一组在电视后面的智能灯泡。它们会在电视的后面投影近似于电视在播出的内容的彩色阴影，与以下内容 [类似](https://www.philips-hue.com/en-us/p/hue-play-hdmi-sync-box-/046677555221)：

![](https://www.kirupa.com/html5/images/lighting_behind_tv.png)

注意电视后面发生的事情。屏幕中所显示的颜色会被灯泡投影为电视机身后面的彩色阴影。随着屏幕上的颜色发生变化，投射在背景中的颜色也会发生变化。真的很酷，对吧？

自然，看到这个之后，我的第一个想法是，我们是否可以使用 Web 技术创建一个足够智能以模仿前景色的彩色阴影。事实证明，我们完全可以只使用 CSS 构建出这个案例。在本文中，我们将了解如何创建这种效果。

走起！

## 让它变成真的！

正如你将在以下部分中看到的，使用 CSS 创建这种彩色阴影似乎是一项艰巨的任务（当然，只是就刚开始而言）。当我们开始进入它并将这个困难的任务的核心分割成一个个小任务时，我们其实能够发现，要实现这个效果，其实蛮简单的。在接下来的几个小节中，我们将创建以下示例：

![](https://user-images.githubusercontent.com/5164225/122199432-9bf35d80-cecc-11eb-9150-28c7b09c595e.gif)

你应该看到的是一张后面有一个五颜六色的阴影的寿司的图片。（只是为了强调我们正在做这一切，我们为阴影添加了脉冲的动画效果）抛开示例，让我们深入了解实现，看看 HTML 和 CSS 如何让这一切变为现实！

### 展示我们的照片

用来展示我们寿司图片的 HTML 其实没什么特别的：

```html

<div class="parent">
    <div class="colorfulShadow sushi"></div>
</div>
```

我们有一个父 div 元素，包含一个负责显示寿司的子 div 元素。我们显示寿司的方式是将其指定为背景图像，并由以下 **.sushi** 样式规则处理：

```css
.sushi {
    margin: 100px;
    width: 150px;
    height: 150px;
    background-image: url("https://www.kirupa.com/icon/1f363.svg");
    background-repeat: no-repeat;
    background-size: contain;
}
```

在此样式规则中，我们将 div 的大小指定为 150 x 150 像素，并在其上设置 `background-image` 和相关的其他属性。就目前而言，我们所看到的 HTML 和 CSS 会给我们提供如下所示的内容：

![](https://www.kirupa.com/html5/images/chrome_sushi_only.png)

## 现在是阴影时间

现在我们的图像出现了，剩下的就是我们定义阴影这一有趣的部分。我们要定义阴影的方法是指定一个子伪元素（使用 `::after`），它将做三件事：

1. 直接定位在我们的图片后面；
2. 继承与父元素相同的背景图片；
3. 依靠滤镜实现多彩的阴影效果；

这三件事是通过以下两条样式规则完成的：

```css
.colorfulShadow {
    position: relative;
}

.colorfulShadow::after {
    content: "";
    width: 100%;
    height: 100%;
    position: absolute;
    background: inherit;
    background-position: center center;
    filter: drop-shadow(0px 0px 10px rgba(0, 0, 0, 0.50)) blur(20px);
    z-index: -1;
}
```

让我们花一点时间来看看这里发生了些什么：先注意每一个属性和对应的值，有一些值得注意的属性 —— `background` 和 `filter`。`background` 属性使用了 `inherit` 继承父元素，意味着能够继承父元素的背景：

```css
.colorfulShadow::after {
    content: "";
    width: 100%;
    height: 100%;
    position: absolute;
    background: inherit;
    background-position: center center;
    filter: drop-shadow(0px 0px 10px rgba(0, 0, 0, 0.50)) blur(20px);
    z-index: -1;
}
```

我们为 `filter` 属性定义了两个过滤的属性，分别是 **drop-shadow** 和 **blur**：

```css
.colorfulShadow::after {
    content: "";
    width: 100%;
    height: 100%;
    position: absolute;
    background: inherit;
    background-position: center center;
    filter: drop-shadow(0px 0px 10px rgba(0, 0, 0, 0.50)) blur(20px);
    z-index: -1;
}
```

我们的 **drop-shadow** 过滤器设置为显示不透明度为 50% 的黑色阴影，而我们的 **blur** 过滤器会将我们的伪元素模糊 20px。 这两个过滤器的组合最终创建了彩色的阴影，当应用这两个样式规则时，该阴影现在将出现在我们的寿司图像后面：

![](https://www.kirupa.com/html5/images/chrome_sushi_shadow.png)

至此，我们已经实现了智能阴影。为完整起见，如果我们想要彩色阴影缩放的动画，如下 CSS 代码的添加能够助力我们实现目标：

```css
.colorfulShadow {
    position: relative;
}

.colorfulShadow::after {
    content: "";
    width: 100%;
    height: 100%;
    position: absolute;
    background: inherit;
    background-position: center center;
    filter: drop-shadow(0px 0px 10px rgba(0, 0, 0, 0.50)) blur(20px);
    z-index: -1;

    /* animation time! */
    animation: oscillate 1s cubic-bezier(.17, .67, .45, 1.32) infinite alternate;
}

@keyframes oscillate {
    from {
        transform: scale(1, 1);
    }

    to {
        transform: scale(1.3, 1.3);
    }
}
```

如果你想要一些交互性而没有不断循环的动画，你还可以使用 CSS 过渡来更改阴影在某些动作（如悬停）上的行为方式。困难的部分是像对待在 HTML 中明确定义或使用 JavaScript 动态创建的任何其他元素一样对待伪元素。其唯一的区别是伪元素是完全使用 CSS 创建的！

## 结论

伪元素允许我们使用 CSS 来完成一些历史上属于 HTML 和 JavaScript 领域的元素创建任务。对于我们多彩而智能的阴影，我们能够依靠父元素来设置背景图像。这使我们能够轻松定义一个既继承了父元素的背景图像细节，又允许我们为其设置一系列属性以实现模糊和阴影效果的子伪元素。尽管这一切都很好，我们也最大限度地减少了大量复制和粘贴，但这种方法不是很灵活。

如果我想将这样的阴影应用到一个不只是带有背景图像的空元素上怎么办？如果我有一个像 **Button** 或 **ComboBox** 这样的 HTML 元素想要应用这种阴影效果怎么办？一种解决方案是依靠 JavaScript 在 DOM 中复制适当的元素，将它们放置在前景元素下方，应用过滤器，然后就可以了。虽然可行，但考虑到该过程的复杂程度，实在是有些不寒而栗。可惜 JavaScript 没有等效的 [renderTargetBitmap](https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.imaging.rendertargetbitmap?view=net-5.0) 这种能够把我们的视觉效果渲染成位图，然后你可以做任何你想做的事的 API…… 🥶

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
