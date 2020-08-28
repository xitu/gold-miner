> * 原文地址：[Creating a Menu Image Animation on Hover](https://tympanus.net/codrops/2020/07/01/creating-a-menu-image-animation-on-hover/)
> * 原文作者：[Mary Lou](http://www.codrops.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/creating-a-menu-image-animation-on-hover.md](https://github.com/xitu/gold-miner/blob/master/article/2020/creating-a-menu-image-animation-on-hover.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：

# 如何在悬停时创建菜单图像动画

[![rapid_feat](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2020/07/rapid_feat.jpg)](http://tympanus.net/Tutorials/RapidImageHoverMenu/ "Creating a Menu Image Animation on Hover Demo")

- [查看演示](http://tympanus.net/Tutorials/RapidImageHoverMenu/)
- [下载源码](https://github.com/codrops/RapidImageHoverMenu/archive/master.zip)

在 Codrops，我们喜欢尝试有趣的悬停效果。早在 2018 年，我们就探索了一组有趣的悬停动画以获取链接。我们将其称为“ 图像显示悬停效果”，它展示了如何在悬停菜单项时使图像以精美的动画出现。看完 Marvin Schwaibold 出色的作品集之后，我想在更大的菜单上再次尝试这种效果，并在移动鼠标时添加漂亮的摇摆效果。使用一些过滤器，这也可以变得更加生动。

如果您对其他类似效果感兴趣，请查看以下内容：

* [图像轨迹效果](https://tympanus.net/codrops/2019/08/07/image-trail-effects/)
* [滤镜的图像失真效果](https://tympanus.net/codrops/2019/03/12/image-distortion-effects-with-svg-filters/)
* [图像拖拽效果](https://tympanus.net/codrops/2020/02/03/image-dragging-effects/)

因此，今天我们来看看如何创建这种多汁的图像悬停展示动画：

![ezgif-1-49e5dab6c59e](https://user-images.githubusercontent.com/5164225/90801365-659a8f80-e348-11ea-9d32-ff9c90c5836f.gif)

## 若干标记和样式

我们将为每个菜单项使用嵌套结构，因为我们将在页面加载和悬停时显示几个文本元素。

但是我们不会在加载或悬停效果上使用文本动画，因此我们感兴趣的是如何使图像显示在每个项目上。当我想产生某种效果时，我要做的第一件事就是不使用 JavaScript 编写所需的结构。因此，让我们看一下：

```html
<a class="menu__item">
    <span class="menu__item-text">
        <span class="menu__item-textinner">Maria Costa</span>
    </span>
    <span class="menu__item-sub">Style Reset 66 Berlin</span>
    <!-- 用JS插入图像的标记， -->
    <div class="hover-reveal">
        <div class="hover-reveal__inner">
            <div class="hover-reveal__img" style="background-image: url(img/1.jpg);"></div>
        </div>
    </div>
</a>
```

为了构造图像的标记，我们需要将源保存在某个地方。我们将在menu__item上使用data属性，例如data-img="img/1.jpg"。稍后我们将详细介绍。

接下来，我们将对其进行一些样式设置：

```css
.hover-reveal {
    position: absolute;
    z-index: -1;
    width: 220px;
    height: 320px;
    top: 0;
    left: 0;
    pointer-events: none;
    opacity: 0;
}

.hover-reveal__inner {
    overflow: hidden;
}

.hover-reveal__inner,
.hover-reveal__img {
    width: 100%;
    height: 100%;
    position: relative;
}

.hover-reveal__img {
    background-size: cover;
    background-position: 50% 50%;
}
```

我们将动态添加特定于我们的效果的其他任何样式（如转换）。

让我们看一下JavaScript。


## 使用 JavaScript

我们将使用 [GSAP](https://greensock.com/gsap/)，除了悬停动画外，还将使用[自定义光标](https://tympanus.net/codrops/2020/03/24/animated-custom-cursor-effects/)和平滑滚动。为此，我们将使用来自年度开发活动令人赞叹的 [平滑滚动库](https://github.com/locomotivemtl/locomotive-scroll)。由于这些都是可选的，并且超出了我们要展示的菜单效果范围，因此在此不再赘述。

首先，我们要预加载所有图像。出于本演示的目的，我们在页面加载时执行此操作，但这是可选的。

完成后，我们可以初始化平滑滚动实例，自定义光标和我们的**菜单**实例。

需要的 JavaScript 文件（index.js）如下所示：


```js
import Cursor from './cursor';
import {preloader} from './preloader';
import LocomotiveScroll from 'locomotive-scroll';
import Menu from './menu';

const menuEl = document.querySelector('.menu');

preloader('.menu__item').then(() => {
    const scroll = new LocomotiveScroll({el: menuEl, smooth: true});
    const cursor = new Cursor(document.querySelector('.cursor'));
    new Menu(menuEl);
});
```

现在，让我们为**菜单**创建一个类（在 menu.js 中）：

```js
import {gsap} from 'gsap';
import MenuItem from './menuItem';

export default class Menu {
    constructor(el) {
        this.DOM = {el: el};
        this.DOM.menuItems = this.DOM.el.querySelectorAll('.menu__item');
        this.menuItems = [];
        [...this.DOM.menuItems].forEach((item, pos) => this.menuItems.push(new MenuItem(item, pos, this.animatableProperties)));

        ...
    }
    ...
}
```

到目前为止，我们已经参考了主要元素（菜单 <nav>
元素）和菜单元素。我们还将创建一个 MenuItem 实例数组。但是，让我们稍后介绍一下。

现在，我们要在将鼠标移到菜单项上时更新 transform（X 和 Y 转换）值。但是我们也可能想更新其他属性。在我们的情况下，我们将另外更新旋转和 CSS 过滤器值（亮度）。为此，让我们创建一个存储此配置的对象：

```js
constructor(el) {
    ...

    this.animatableProperties = {
        tx: {previous: 0, current: 0, amt: 0.08},
        ty: {previous: 0, current: 0, amt: 0.08},
        rotation: {previous: 0, current: 0, amt: 0.08},
        brightness: {previous: 1, current: 1, amt: 0.08}
    };
}
```

通过插值，可以在移动鼠标时实现平滑的动画效果。“上一个”和“当前”值是我们将要插值的值。这些“可动画化”属性之一的当前值将以特定的增量介于这两个值之间。“amt”的值是要内插的数量。例如，以下公式将计算我们当前的**translationX**值：


```js
this.animatableProperties.tx.previous = MathUtils.lerp(this.animatableProperties.tx.previous, this.animatableProperties.tx.current, this.animatableProperties.tx.amt);
```

最后，我们可以显示菜单项，默认情况下它们是隐藏的。这只是一点点额外的东西，而且完全是可选的，但这绝对是一个不错的附加组件，它可以延迟页面加载来显示每个项目。

```js
constructor(el) {
    ...

    this.showMenuItems();
}
showMenuItems() {
    gsap.to(this.menuItems.map(item => item.DOM.textInner), {
        duration: 1.2,
        ease: 'Expo.easeOut',
        startAt: {y: '100%'},
        y: 0,
        delay: pos => pos*0.06
    });
}
```

Menu 类就是这样。接下来，我们将研究如何创建 MenuItem 类以及一些辅助变量和函数。

因此，让我们开始导入 GSAP 库（我们将使用它来显示和隐藏图像），一些帮助函数以及 images 文件夹中的图像。

接下来，我们需要在任何给定时间访问鼠标的位置，因为图像将跟随其移动。我们可以在“ mousemove”上更新此值。我们还将缓存其位置，以便可以计算 X 轴和 Y 轴的速度和移动方向。

因此，到目前为止，这就是 menuItem.js 文件中的内容：

```js
import {gsap} from 'gsap';
import { map, lerp, clamp, getMousePos } from './utils';
const images = Object.entries(require('../img/*.jpg'));

let mousepos = {x: 0, y: 0};
let mousePosCache = mousepos;
let direction = {x: mousePosCache.x-mousepos.x, y: mousePosCache.y-mousepos.y};

window.addEventListener('mousemove', ev => mousepos = getMousePos(ev));

export default class MenuItem {
    constructor(el, inMenuPosition, animatableProperties) {
        ...
    }
    ...
}
```

传递其位置索引和 **animatableProperties** 之前对象所描述。“动画”属性值在不同菜单项之间共享和更新的事实将使图像的移动和旋转连续进行。

现在，为了能够以一种精美的方式显示和隐藏菜单项图像，我们需要创建在开始时显示的特定标记并将其附加到该项。请记住，默认情况下，我们的菜单项是：

```html
<a class="menu__item" data-img="img/3.jpg">
    <span class="menu__item-text"><span class="menu__item-textinner">Franklin Roth</span></span>
    <span class="menu__item-sub">Amber Convention London</span>
</a>
```

让我们在项目上添加以下结构：

```html
<div class="hover-reveal">
    <div class="hover-reveal__inner" style="overflow: hidden;">
        <div class="hover-reveal__img" style="background-image: url(pathToImage);">
        </div>
    </div>
</div>
```

随着我们移动鼠标，在悬停显示内容将是一个移动的对象。
该悬停 reveal__inner 元素与一起悬停 reveal__img（一个与背景图像），将是那些我们可以动画联手打造看中喜欢的动画显示 unreveal 效果。

```js
layout() {
    this.DOM.reveal = document.createElement('div');
    this.DOM.reveal.className = 'hover-reveal';
    this.DOM.revealInner = document.createElement('div');
    this.DOM.revealInner.className = 'hover-reveal__inner';
    this.DOM.revealImage = document.createElement('div');
    this.DOM.revealImage.className = 'hover-reveal__img';
    this.DOM.revealImage.style.backgroundImage = `url(${images[this.inMenuPosition][1]})`;
    this.DOM.revealInner.appendChild(this.DOM.revealImage);
    this.DOM.reveal.appendChild(this.DOM.revealInner);
    this.DOM.el.appendChild(this.DOM.reveal);
}
```

并且 MenuItem 构造函数完成了：

```js
constructor(el, inMenuPosition, animatableProperties) {
    this.DOM = {el: el};
    this.inMenuPosition = inMenuPosition;
    this.animatableProperties = animatableProperties;
    this.DOM.textInner = this.DOM.el.querySelector('.menu__item-textinner');
    this.layout();
    this.initEvents();
}
```

最后一步是初始化一些事件。我们需要在悬停项目时显示图像，而在离开项目时将其隐藏。

另外，将鼠标悬停时，我们需要更新 animatableProperties 对象属性，并随着鼠标移动来移动，旋转和更改图像的亮度：


```js
initEvents() {
    this.mouseenterFn = (ev) => {
        this.showImage();
        this.firstRAFCycle = true;
        this.loopRender();
    };
    this.mouseleaveFn = () => {
        this.stopRendering();
        this.hideImage();
    };
    
    this.DOM.el.addEventListener('mouseenter', this.mouseenterFn);
    this.DOM.el.addEventListener('mouseleave', this.mouseleaveFn);
}
```

现在让我们编写 **showImage** 和 **hideImage** 函数的代码。

我们可以为此创建一个 GSAP 时间轴。让我们从将揭密元素（刚创建的结构的顶部元素）的不透明度设置为1开始。另外，为了使图像出现在所有其他菜单项的顶部，让我们将该项目的 z-index 设置为较高的值。

接下来，我们可以对图像的外观进行动画处理。让我们这样做：根据鼠标x轴的移动方向（在 direction.x 中有此方向），图像向左右显示。为此，图像元素（revealImage）需要将其 translationX 值动画化为其父元素（revealInner元素）的相对侧。
基本上就是这样：


主要内容就这些：

```js
showImage() {
    gsap.killTweensOf(this.DOM.revealInner);
    gsap.killTweensOf(this.DOM.revealImage);
    
    this.tl = gsap.timeline({
        onStart: () => {
            this.DOM.reveal.style.opacity = this.DOM.revealInner.style.opacity = 1;
            gsap.set(this.DOM.el, {zIndex: images.length});
        }
    })
    // animate the image wrap
    .to(this.DOM.revealInner, 0.2, {
        ease: 'Sine.easeOut',
        startAt: {x: direction.x < 0 ? '-100%' : '100%'},
        x: '0%'
    })
    // animate the image element
    .to(this.DOM.revealImage, 0.2, {
        ease: 'Sine.easeOut',
        startAt: {x: direction.x < 0 ? '100%': '-100%'},
        x: '0%'
    }, 0);
}
```

要隐藏图像，我们只需要反转此逻辑即可：

```js
hideImage() {
    gsap.killTweensOf(this.DOM.revealInner);
    gsap.killTweensOf(this.DOM.revealImage);

    this.tl = gsap.timeline({
        onStart: () => {
            gsap.set(this.DOM.el, {zIndex: 1});
        },
        onComplete: () => {
            gsap.set(this.DOM.reveal, {opacity: 0});
        }
    })
    .to(this.DOM.revealInner, 0.2, {
        ease: 'Sine.easeOut',
        x: direction.x < 0 ? '100%' : '-100%'
    })
    .to(this.DOM.revealImage, 0.2, {
        ease: 'Sine.easeOut',
        x: direction.x < 0 ? '-100%' : '100%'
    }, 0);
}
```

现在，我们只需要更新 **animatableProperties** 对象属性，以便图像可以平滑地移动，旋转和改变其亮度。我们在 **requestAnimationFrame** 循环中执行此操作。在每个周期中，我们都会插值先前值和当前值，因此事情会轻松进行。

我们要旋转图像并根据鼠标的X轴速度（或从上一个循环开始的距离）更改其亮度。因此，我们需要计算每个周期的距离，这可以通过从缓存的鼠标位置中减去鼠标位置来获得。

我们也想知道我们向哪个方向移动鼠标，因为旋转将取决于鼠标。向左移动时，图像旋转为负值；向右移动时，图像旋转为正值。

接下来，我们要更新 **animatableProperties** 值。对于 **translationX和translationY**，我们希望将图像的中心定位在鼠标所在的位置。请注意，图像元素的原始位置在菜单项的左侧。

根据鼠标的速度、距离及其方向，旋转角度可以从 -60 度变为 60 度。最终，亮度可以从 1 变为 4，这取决于鼠标的速度、距离。

最后，我们将这些值与以前的循环值一起使用，并使用插值法设置最终值，然后在为元素设置动画时会给我们带来平滑的感觉。

这是 render 函数的样子：


```js
render() {
    this.requestId = undefined;
    
    if ( this.firstRAFCycle ) {
        this.calcBounds();
    }

    const mouseDistanceX = clamp(Math.abs(mousePosCache.x - mousepos.x), 0, 100);
    direction = {x: mousePosCache.x-mousepos.x, y: mousePosCache.y-mousepos.y};
    mousePosCache = {x: mousepos.x, y: mousepos.y};

    this.animatableProperties.tx.current = Math.abs(mousepos.x - this.bounds.el.left) - this.bounds.reveal.width/2;
    this.animatableProperties.ty.current = Math.abs(mousepos.y - this.bounds.el.top) - this.bounds.reveal.height/2;
    this.animatableProperties.rotation.current = this.firstRAFCycle ? 0 : map(mouseDistanceX,0,100,0,direction.x < 0 ? 60 : -60);
    this.animatableProperties.brightness.current = this.firstRAFCycle ? 1 : map(mouseDistanceX,0,100,1,4);

    this.animatableProperties.tx.previous = this.firstRAFCycle ? this.animatableProperties.tx.current : lerp(this.animatableProperties.tx.previous, this.animatableProperties.tx.current, this.animatableProperties.tx.amt);
    this.animatableProperties.ty.previous = this.firstRAFCycle ? this.animatableProperties.ty.current : lerp(this.animatableProperties.ty.previous, this.animatableProperties.ty.current, this.animatableProperties.ty.amt);
    this.animatableProperties.rotation.previous = this.firstRAFCycle ? this.animatableProperties.rotation.current : lerp(this.animatableProperties.rotation.previous, this.animatableProperties.rotation.current, this.animatableProperties.rotation.amt);
    this.animatableProperties.brightness.previous = this.firstRAFCycle ? this.animatableProperties.brightness.current : lerp(this.animatableProperties.brightness.previous, this.animatableProperties.brightness.current, this.animatableProperties.brightness.amt);
    
    gsap.set(this.DOM.reveal, {
        x: this.animatableProperties.tx.previous,
        y: this.animatableProperties.ty.previous,
        rotation: this.animatableProperties.rotation.previous,
        filter: `brightness(${this.animatableProperties.brightness.previous})`
    });

    this.firstRAFCycle = false;
    this.loopRender();
}
```

我希望这并非难事，并且您已经对构建这种奇特的效果有所了解。

如果您有任何疑问，请告诉我 [@codrops](https://twitter.com/codrops) 或 [@crnacura](https://twitter.com/crnacura)。

感谢您的阅读！

[在 Github 上找到这个项目](https://github.com/codrops/RapidImageHoverMenu/)

> 该演示中使用的图像是 [Andrey Yakovlev and Lili Aleeva](https://www.behance.net/AndrewLili) 制作的。 使用的所有图像均在 [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en_US) 获得许可。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
