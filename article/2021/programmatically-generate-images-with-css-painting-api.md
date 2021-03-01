> * 原文地址：[Programmatically generate images with CSS Painting API](https://blog.bitsrc.io/programmatically-generate-images-with-css-painting-api-3b1a860dae3b)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/programmatically-generate-images-with-css-painting-api.md](https://github.com/xitu/gold-miner/blob/master/article/2021/programmatically-generate-images-with-css-painting-api.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)、[lsvih](https://github.com/lsvih)

# 使用 CSS Painting API 自动生成图像

![Banner](https://cdn-images-1.medium.com/max/5760/1*wKYGWd-7eWgpmMeBNiLCDA.jpeg)

图像为应用程序增添色彩，丰富内容。然而，如果网页中嵌入了大量高分辨率图像，会大量增加页面资源加载时间，严重影响用户体验。对于展示产品、方案等必须内容的图像，我们别无选择，只能按照正常方式嵌入这些图像并通过缓存它们来优化应用程序。但是，如果我们在应用程序中需要几何图像，则不必再将其作为资源来加载。

> 我们可以使用 CSS Painting API 即时生成几何图像。

让我们一起来走进这个 API，并且学习如何使用它生成图像吧～

## CSS Painting API 的简介

开发者们能够使用 [CSS Painting API](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Painting_API) 使用编写的 JavaScript 函数将图像绘制到 CSS 属性中，例如 `background-image`和 `border`。它提供了一组 API，使开发人员可以访问 CSSOM，CSS Houdini（[Houdini](https://github.com/w3c/css-houdini-drafts)）的一部分 —— 新浏览器 API 的集合，为开发人员提供了对 CSS 本身的更底层的访问方法。）

嵌入图像的传统方法如下。

```css
div {
    background-image: url('assets/background.jpg');
}
```

而如果使用 CSS Painting API，我们只需要调用 `paint()` 函数，并且传入一个 JavaScript 声明好的 Worklet：

```css
div {
    background-image: paint(background);
}
```

这串代码的工作逻辑是这样的：

![](https://cdn-images-1.medium.com/max/2000/1*c2EShrISdnmcxc87qJdKPg.png)

在上文中似乎存在着一些晦涩难懂的术语。例如，我们提及了 `worklet`？

简而言之，让程序自动生成图像的 JavaScript 代码称为 Paint Worklet。[Worklet](https://www.w3.org/TR/worklets-1/#intro) 是浏览器渲染管道的一个扩展。除了 Paint Worklet 之外，还有其他类型的 Worklet，例如 Animation Worklet 和 Layout Worklet。

现在，让我们看一下程序生成图像的分步方法。

## 在实践中使用 CSS Painting API

在本文中，我们将会探讨如何创建一个气泡背景

#### 第一步：添加 CSS paint() 函数

在开始这一切之前，我们需要往所需要添加图片的 CSS 属性中添加 `paint()` 函数。

```css
.bubble-background {
    width: 400px;
    height: 400px;
    background-image: paint(bubble);
}
```

`bubble` 就是我们等下生成图片的 Worklet，而要生成 Worklet，仅仅只需要短短几步。

#### 第二步：定义 Worklet

Worklet 需要在外部 JavaScript 文件中被保存，而 Painting Worklet 应该是一个 `class`，例如 `class Bubble { …… }`，然后这个 Worklet 需要使用 `registerPaint()` 函数注册。

```js
class Bubble {
    paint(context, canvas, properties) {
        /* TODO: ... */
    }
}

registerPaint('bubble', Bubble);
```

`registerPaint()` 函数的第一个参数是我们向在 CSS 中使用的参考名。

现在就让我们来绘制背景吧！

```js
class Bubble {
    paint(context, canvas, properties) {
        const circleSize = 10;
        const bodyWidth = canvas.width;
        const bodyHeight = canvas.height;

        const maxX = Math.floor(bodyWidth / circleSize);
        const maxY = Math.floor(bodyHeight / circleSize);

        for (let y = 0; y < maxY; y++) {
            for (let x = 0; x < maxX; x++) {
                context.fillStyle = '#eee';
                context.beginPath();
                context.arc(x * circleSize * 2 + circleSize, y * circleSize * 2 + circleSize, circleSize, 0, 2 * Math.PI, true);
                context.closePath();
                context.fill();
            }
        }
    }
}

registerPaint('bubble', Bubble);
```

创建图像的运算是在 `paint()` 函数的内部进行的。我们将需要一些有关 Canvas 的知识来绘制上述图像。如果不熟悉，我们其实可以看一下 [Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial) 文档。

#### 第三步：调用 Worklet

最后一步是在 HTML 文件中调用 Worklet。

```html

<div class="bubble-background"></div>

<script>
    CSS.paintWorklet.addModule('https://codepen.io/viduni94/pen/ZEpgMja.js');
</script>
```

这就好啦！

你现在已经在三步之内用程序自动生成一张图片啦！

## 生成的图片

我们所编写的的代码的运行效果应该是这样的：

![[在编辑器中查看](https://codepen.io/viduni94/pen/jOMgpNX)](https://cdn-images-1.medium.com/max/2448/1*vvLIdPpqWdRWswddJ9CgUw.png)

## 我们还可以用 CSS Painting API 干些什么呢？

The power of the CSS Painting API is not over yet. There are more things you can do with it.

#### 1. 我们可以创建动图

例如，我们可以动态更改气泡的颜色，而 CSS 变量就是服务此目的的。为了使用 CSS 变量，浏览器应该先明白我们在使用它。我们可以使用 `inputProperties()` 函数来做到这一点。

```js
registerPaint('bubble', class {
    static get inputProperties() {
        return ['--bubble-size', '--bubble-color'];
    }

    paint() {
        /* ... */
    }
});
```

变量们可以通过第三个参数传给 `paint()` 方法

```js
paint(context, canvas, properties)
{
    const circleSize = parseInt(properties.get('--bubble-size').toString());
    const circleColor = properties.get('--bubble-color').toString();
    const bodyWidth = canvas.width;
    const bodyHeight = canvas.height;

    const maxX = Math.floor(bodyWidth / circleSize);
    const maxY = Math.floor(bodyHeight / circleSize);

    for (let y = 0; y < maxY; y++) {
        for (let x = 0; x < maxX; x++) {
            context.fillStyle = circleColor;
            context.beginPath();
            context.arc(x * circleSize * 2 + circleSize, y * circleSize * 2 + circleSize, circleSize, 0, 2 * Math.PI, true);
            context.closePath();
            context.fill();
        }
    }
}
```

#### 2. 我们可以使用 `Math.random()` 在 `paint()` 函数中生成随机的图片

```css
body {
    width: 200px;
    height: 200px;
    background-image: paint(random);
}
```

```javascript
function getRandomHexColor() {
    return '#' + Math.floor(Math.random() * 16777215).toString(16)
}

class Random {
    paint(context, canvas) {
        const color1 = getRandomHexColor();
        const color2 = getRandomHexColor();

        const gradient = context.createLinearGradient(0, 0, canvas.width, 0);
        gradient.addColorStop(0, color1);
        gradient.addColorStop(1, color2);

        context.fillStyle = gradient;
        context.fillRect(0, 0, canvas.width, canvas.height);
    }
}

registerPaint('random', Random);
```

如果你在如何做到这些上存在疑惑，请在评论区中提出你的问题。

这个真是太棒啦！

但是，好事总有糟糕的一面，这个 API 现在仅仅只被部分浏览器所有限制的支持。

## 浏览器支持

![数据源：[Can I Use](https://caniuse.com/css-paint-api)](https://github.com/PassionPenguin/gold-miner-images/blob/master/programmatically-generate-images-with-css-painting-api-caniuse.com_css-paint-api.png?raw=true)

包括 Firefox 在内的大多数浏览器都不支持 CSS Painting API。到目前为止，只有基于 Chromium 的浏览器完全支持此功能，真希望不久的将来浏览器支持会有所改善。

## 摘要

CSS Painting API 对于减少网络请求的响应时间非常有用，因为图片是程序化生成而非获取网络数据得到的。

最重要的是，我认为主要的好处如下。

* 能够创建完全可定制的图像，而不是静态图像。
* 它创建与分辨率无关的图像（让我们的站点上不再有质量差的图像）。

需要注意的重要一点是，我们可以使用 `polyfill` 等库作为解决方案来支持尚未实现 CSS Painting API 的 Firefox 等浏览器。

---

如果你对本文有任何疑问或想法，请在评论区告诉我们！感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
