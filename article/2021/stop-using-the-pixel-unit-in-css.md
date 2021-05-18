> * 原文地址：[Stop Using the Pixel Unit in CSS](https://betterprogramming.pub/stop-using-the-pixel-unit-in-css-8b8788a1301f)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/stop-using-the-pixel-unit-in-css.md](https://github.com/xitu/gold-miner/blob/master/article/2021/stop-using-the-pixel-unit-in-css.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)，[Kimhooo](https://github.com/Kimhooo)、[Li-saltair](https://github.com/Li-saltair)

# 快停止在 CSS 中使用像素单位

![图源 [Alexander Andrews](https://unsplash.com/@alex_andrews?utm_source=medium&utm_medium=referral)，出自 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/12450/0*5eX8OB4YTWwqM1RV)

为什么 Web 开发者如此盲目地使用 px 单位？这只是一个坏习惯吗？是因为缺乏其他单位的知识吗？也许是因为设计团队的模拟依赖于 px 和 pt？目前我们也无法明白为什么像素是大多数团队当前的首选单位。

也许，主要原因是它看起来简单方便。凭直觉，我们认为我们了解此单位，因为它看起来好像在映射像素屏幕。

px 单位可以使你轻松上手，但是后来却变成了一个问题。在本文中，我将介绍避免像素单位的最有力的三个原因。我们将讨论其使用方面的问题以及一些可能的解决方案。

## 1. 它们只是光学参考单位

如今像素值不再基于硬件像素，会在许多屏幕和分辨率下不生效，而且看起来都非常不同。它们只是基于光学单位，因此，我们发现对该单元更直观的部分不再存在。

硬件每天都在变化，像素密度也在增长。我们不能依靠这样的假设，即设备的像素密度为 96dpi —— 这不再是一个稳定的参考值。

> “请注意，如果锚点单位是像素单位，则物理单位可能与它们的物理尺寸不匹配。或者，如果锚点单元是物理单元，则像素单元可能不会映射到设备像素的总数。
>
>请注意，像素单位和物理单位的定义与CSS的早期版本不同。特别是，在 CSS 的早期版本中，像素单位和物理单位不是以固定比率关联的：物理单位始终与物理尺寸相关联，而像素单位会发生变化以最紧密地匹配参考像素。（进行此更改是因为现有内容过多取决于 96dpi 的假设，而打破该假设会破坏内容。）” —— [W3C]（https://www.w3.org/TR/2011/WD-css3-values-20110906 /）

总之，这意味着像素不可靠。由于其不可靠的特性，可能无法实现像素完美的布局。

让我们看一下每英寸点数不同的像素等效于 1mm 的像素：

![在 Pixelcalculator 上平均 MacBook dpi 的毫米到像素](https://cdn-images-1.medium.com/max/2000/1*xgFl-SLMot8k2KR0HEn4mQ.png)

![Pixelcalculator 上平均 iPhone dpi 的毫米到像素](https://cdn-images-1.medium.com/max/2000/1*qBVYc5fFUBNnzgTMJYHtoQ.png)

可以区分屏幕上像素的日子已经一去不复返了。我们已经习惯了这种限制，这是一个我们需要放弃的想法。随着时间的流逝，“像素”一词的含义已失去其含义，现在该停止在我们的 CSS 代码中将其设为默认单位了。

## 2. 它们是绝对的值

看着上面的问题，为什么会发生？为什么我们的布局无法达到像素完美？因为像素单位是绝对的。这意味着它将无法适应我们浏览器的像素比率、分辨率、大小等。

如果要满足广大受众的需求，绝对的值通常不是很有用。px 是唯一的绝对单位吗？不，CSS 中还有另外六个绝对单位，如下图：

![CSS 支持的绝对单位列表](https://cdn-images-1.medium.com/max/2000/1*aXVUdpRMgeFox_6uHkR_SA.png)

这意味着，如果你使用这些单位，网站的访问着就会看到各种各样的布局，而让你的页面进行任何可能显示的分辨率进行适配都会是不合理的。

我们如何解决这个问题？我们如何才能使布局具有响应性？—— 使用“相对单位”。那到底是什么？

> “相对长度单位是相对于其他单位的，也许是父元素字体的大小或视口的大小。” — [MDN Web 文档]（https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Values_and_units）

让我们检查一下我们可以使用的相对单位：

![CSS 中可用的相关相对单位列表](https://cdn-images-1.medium.com/max/2000/1*4AZByHrtdOwFI_bDnfMKmQ.png)

你会看到相对单位的列表大于绝对单位列表。为什么会有那么多的相对单位？

这些中的每一个都有一些更适合使用的特定方案。有很多方案可选是个好消息，因为我们知道我们可以涵盖很多不同的用例。这就是为什么了解它们每个单位变得很重要。

假设我们要显示一列每行最多 20 个字符的内容。

大多数的开发者会想干什么？通过字符的字体、字体、大小和粗细来测量字符的平均长度，并将其乘以 20。

该方法会导致我们需要一个硬编码的像素值，也意味着，如果字体大小更改，你将不得不再次进行计算。这种方法只是一种近似，无法在所有设备上始终如一地工作。

有什么更好的解决方案？使用 `ch` 单位。你可以将目标列宽基于 `ch` 单位的倍数

让我们看一下代码，以更好地理解这一点：

```HTML
<!DOCTYPE html>
<html>
<head>
    <title>Units Playground</title>
    <meta charset="UTF-8"/>
</head>
<body>
<style type="text/css">
    body {
        color: white;
        text-align: center;
        box-sizing: content-box;
        margin: 1em;
    }

    #container {
        color: white;
        display: grid;
        gap: 1rem;
        grid-template-columns: max-content 1fr;
    }

    #content {
        padding: 1em;
        margin: 0;
        background-color: #5B2E48;
        color: white;
        max-width: 20ch;
    }

    #photo {
        background-color: #CEB992;
    }
</style>
<div id="container">
    <p id="content">
        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum
    </p>
    <div id="photo">
    </div>
</div>
</body>
</html>
```

![使用 `ch` 单位构建动态内容宽度的例子](https://cdn-images-1.medium.com/max/2000/1*1K2l3CJ41vA1UMqLOVbp_Q.png)

如你所见，我们限制了我们内容的 `max-width` 为 `20ch`。

```css
#content {
    max-width: 20ch;
}
```

以上仅是示例。像素单元有很多替代品。有时，你不需要相对单位。你可以使用 flex 和 grid 布局的功能来相应地调整布局。不依赖绝对单位能够让你的布局保持一致。切记，始终首先依靠浏览器帮助我们完成这些繁重的工作。

## 3. 可访问性：它们不适应用户的默认字体大小

可访问性是一个被遗忘的主题，我们大家都应该更加关注它。像素单位的使用如何影响可访问性？

浏览器可让你配置默认的基本字体大小。默认情况下，它设置为 `16px`，但可以轻松更改。这对于视力障碍的人非常有用。然后，浏览器通过将基本字体大小设置为该值，向我们提示有关首选用户的字体大小。

但是，如果开发者使用绝对像素值，则该信息将被忽略。基本的“字体大小”不会对我们的应用程序布局产生任何影响。所有用户的字体大小都将相同。这是一件坏事，因为你忽略了用户的偏好设置并损害了页面的可访问性。

我们如何尊重基本字体大小？通过使用相对单位，例如 `rem` 和 `em`。什么是 `rem` 和 `em`？ `rem` 和 `em` 单位表示相对于基本字体的字体大小（从框到文本）。简而言之，这意味着你的文本字体大小将是用户首选字体大小的倍数。两者有什么区别？

* `rem` 的大小由根元素（`:root`）的 `font-size` 决定。
* `em` 的大小由父元素的 `font-size` 决定。

你不仅限于仅在 `font-size` 属性上使用这些单位。它们可以在 CSS 元素中的任何位置使用。这意味着你可以根据用户设置创建自适应布局。你可以确保为用户提供适当的体验。

让我们看一个示例，在该示例中，我们将根据用户的基本字体大小来调整整个布局。对于此特定示例，我们将依靠 `rem` 设计自适应布局：

```HTML
<!DOCTYPE html>
<html>
<head>
    <title>Units Playground</title>
    <meta charset="UTF-8"/>
</head>
<body>
<style type="text/css">
    body {
        color: white;
        text-align: center;
        box-sizing: content-box;
    }

    h1 {
        font-size: 1.9rem;
    }

    h2 {
        font-size: 1.5rem;
    }

    p {
        font-size: 1.2rem;
        color: #5B2E48;
    }

    .main-article {
        padding: 1em;
        margin: 0;
        background-color: #5B2E48;
        color: white;
        width: 30em;
    }

    .sub-article {
        padding: 1em;
        margin: 0;
        background-color: #CEB992;
        color: white;
        margin-bottom: 1em;
    }
</style>
<article class="main-article">
    <h1>Weather forecast for Barcelona</h1>
    <article class="sub-article">
        <h2>10 May 2021</h2>
        <p>Cloudy</p>
    </article>
    <article class="sub-article">
        <h2>11 May 2021</h2>
        <p>Sunny</p>
    </article>
    <article class="sub-article">
        <h2>12 May 2021</h2>
        <p>Sunny</p>
    </article>
</article>
</body>
</html>
```

![使用不同字体大小的并排可访问组件](https://cdn-images-1.medium.com/max/2400/1*OHY0OQ7_MXRAbx9J5mmFTg.png)

请注意，我们已将 `rem` 应用于 `padding`、`width` 和 `font-size` 三个属性。

```CSS
p {
    font-size: 1.2rem;
    color: #5B2E48;
}

.main-article {
    padding: 1em;
    margin: 0;
    background-color: #5B2E48;
    color: white;
    width: 30em;
}
```

我们可以在上方看到布局如何适应用户的浏览器设置。字体会更大一些，但 article 也会变大一些 —— 它们会变大以保留比例。即使针对不同用户的大小不同，它们的形状也保持一致。

## 额外提示

当使用 `rem` 和 `rem` 单位时，使用默认的 `16px` 基本字体来表达所有内容可能会很麻烦。在这种情况下，有一个非常流行的技巧：

```css
html {
    font-size: 62.5%; /* 基于默认浏览器字体大小，让 font-size 1em = 10px */
}
```

使用此技巧，现在所有字体大小都将基于默认像素 `16px` 的 `10px` 因子。它能使你的代码少一点混乱，也并不会损害可访问性。它将使你的工作更加轻松。

## 最后的想法

我们已经看到了为什么我们应该放弃像素单位的三个有力理由。依靠相对单位或布局功能将确保你的布局在设备和分辨率之间保持一致。

幸运的是，相对单位如 `rem` 和 `em` 的使用正在不断扩大。同时，浏览器正在尽力提供一些解决方案。当使用绝对值时，如果用户正在缩放，则浏览器单元将缩放以匹配用户应用的适当缩放。这虽不是完美的体验，也是个不错的后备。

我希望本文能为你提供最后的推动力，使你尽可能远离像素单位。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
