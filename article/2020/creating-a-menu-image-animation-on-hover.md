> * 原文地址：[Creating a Menu Image Animation on Hover](https://tympanus.net/codrops/2020/07/01/creating-a-menu-image-animation-on-hover/)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/creating-a-menu-image-animation-on-hover.md](https://github.com/xitu/gold-miner/blob/master/article/2020/creating-a-menu-image-animation-on-hover.md)
> * 译者：
> * 校对者：

# Creating a Menu Image Animation on Hover

A tutorial on how to create a hover effect for a menu where images appear with an animation on each item.

By [Mary Lou](https://tympanus.net/codrops/author/crnacura/ "Posts by Mary Lou") in [Tutorials](https://tympanus.net/codrops/category/tutorials/) on July 1, 2020

[![rapid_feat](https://codropspz-tympanus.netdna-ssl.com/codrops/wp-content/uploads/2020/07/rapid_feat.jpg)](http://tympanus.net/Tutorials/RapidImageHoverMenu/ "Creating a Menu Image Animation on Hover Demo")

[View demo](http://tympanus.net/Tutorials/RapidImageHoverMenu/) [Download Source](https://github.com/codrops/RapidImageHoverMenu/archive/master.zip)

From our sponsor: [Reach inboxes when it matters most. Instantly deliver transactional emails to your customers.](https://ad.doubleclick.net/ddm/clk/468663188;274327225;t)

At Codrops, we love experimenting with playful hover effects. Back in 2018, we explored a set of fun hover animations for links. We called that [Image Reveal Hover Effects](https://tympanus.net/codrops/2018/11/27/image-reveal-hover-effects/) and it shows how to make images appear with a fancy animation when hovering items of a menu. After seeing the fantastic [portfolio of Marvin Schwaibold](https://www.marvinschwaibold.com/projects/), I wanted to try this effect again on a larger menu and add that beautiful swing effect when moving the mouse. Using some filters, this can also be made more dramatic.

If you are interested in other similar effect, have a look at these:

* [Image Trail Effects](https://tympanus.net/codrops/2019/08/07/image-trail-effects/)
* [Image Distortion Effects with SVG Filters](https://tympanus.net/codrops/2019/03/12/image-distortion-effects-with-svg-filters/)
* [Image Dragging Effects](https://tympanus.net/codrops/2020/02/03/image-dragging-effects/)

So, today we’ll have a look at how to create this juicy image hover reveal animation:

## Some Markup and Styling

We’ll use a nested structure for each menu item because we’ll have several text elements that will appear on page load and hover.

But we’ll not go into the text animation on load or the hover effect so what we are interested in here is how we’ll make the image appear for each item. The first thing I do when I want to make a certain effect is to write up the structure that I need using no JavaScript. So let’s take a look at that:

```
<a class="menu__item">
    <span class="menu__item-text">
        <span class="menu__item-textinner">Maria Costa</span>
    </span>
    <span class="menu__item-sub">Style Reset 66 Berlin</span>
    <!-- Markup for the image, inserted with JS -->
    <div class="hover-reveal">
        <div class="hover-reveal__inner">
            <div class="hover-reveal__img" style="background-image: url(img/1.jpg);"></div>
        </div>
    </div>
</a>
```

In order to construct this markup for the image, we need to save the source somewhere. We’ll use a data attribute on the **menu__item**, e.g. `data-img="img/1.jpg"`. We’ll go into more detail later on.

Next, we’ll have some styling for it:

```
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

Any other styles that are specific to our effect (like the transforms) we’ll add dynamically.

Let’s take a look at the JavaScript.

## The JavaScript

We’ll use [GSAP](https://greensock.com/gsap/) and besides our hover animation, we’ll also use a [custom cursor](https://tympanus.net/codrops/2020/03/24/animated-custom-cursor-effects/) and smooth scrolling. For that we’ll use the [smooth scroll library](https://github.com/locomotivemtl/locomotive-scroll) from the amazing folks of Locomotive, the Agency of the year. Since those are both optional and out of the scope of the menu effect we want to showcase, we’ll not be covering it here.

First things first: let’s preload all the images. For the purpose of this demo we are doing this on page load, but that’s optional.

Once that’s done, we can initialize the smooth scroll instance, the custom cursor and our **Menu** instance.

Here’s how the entry JavaScript file (index.js) looks like:

```
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

Now, let’s create a class for the **Menu** (in menu.js):

```
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

So far we have a reference to the main element (the menu `<nav>`  
element) and the menu item elements. We’ll also create an array of our **MenuItem** instances. But let’s cover that bit in a moment.

What we’ll want to do now is to update the transform (both, X and Y translate) value as we move the mouse over the menu items. But we might as well want to update other properties. In our case we will additionally be updating the rotation and the CSS filter value (brightness). For that, let’s create an object that stores this configuration:

```
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

With interpolation, we can achieve the smooth animation effect when moving the mouse. The “previous” and “current” values are the values we’ll be interpolating. The current value of one of these “animatable” properties will be one between these two values at a specific increment. The value of “amt” is the amount to interpolate. As an example, the following formula calculates our current **translationX** value:

```
this.animatableProperties.tx.previous = MathUtils.lerp(this.animatableProperties.tx.previous, this.animatableProperties.tx.current, this.animatableProperties.tx.amt);
```

Finally, we can show the menu items, which are hidden by default. This was just a little extra, and totally optional, but it’s definitely a nice add-on to reveal each item with a delay on page load.

```
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

That’s it for the **Menu** class. What we’ll be looking into next is how to create the **MenuItem** class together with some helper variables and functions.

So, let’s start by importing the GSAP library (which we will use to show and hide the images), some helper functions and the images inside our images folder.

Next, we need to get access to the mouse position at any given time, since the image will follow along its movement. We can update this value on “mousemove” . We will also cache its position so we can calculate its speed and movement direction for both, the X and Y axis.

Hence, that’s what we’ll have so far in the menuItem.js file:

```
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

An item will be passed its position/index in the menu (inMenuPosition) and the **animatableProperties** object described before. The fact that the “animatable” property values are shared and updated among the different menu items will make the movement and rotation of the images continuous.

Now, in order to be possible to show and hide the menu item image in a fancy way, we need to create that specific markup we’ve shown in the beginning and append it to the item. Remember, our menu item is this by default:

```
<a class="menu__item" data-img="img/3.jpg">
    <span class="menu__item-text"><span class="menu__item-textinner">Franklin Roth</span></span>
    <span class="menu__item-sub">Amber Convention London</span>
</a>
```

Let’s append the following structure to the item:

```
<div class="hover-reveal">
    <div class="hover-reveal__inner" style="overflow: hidden;">
        <div class="hover-reveal__img" style="background-image: url(pathToImage);">
        </div>
    </div>
</div>
```

The **hover-reveal** element will be the one moving as we move the mouse.  
The **hover-reveal__inner** element together with the **hover-reveal__img** (the one with the background image) will be the ones that we can animate together to create fancy animations like reveal/unreveal effects.

```
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

And the **MenuItem** constructor completed:

```
constructor(el, inMenuPosition, animatableProperties) {
    this.DOM = {el: el};
    this.inMenuPosition = inMenuPosition;
    this.animatableProperties = animatableProperties;
    this.DOM.textInner = this.DOM.el.querySelector('.menu__item-textinner');
    this.layout();
    this.initEvents();
}
```

The last step is to initialize some events. We need to show the image when hovering the item and hide it when leaving the item.

Also, when hovering it we need to update the **animatableProperties** object properties, and make the image move, rotate and change its brightness as the mouse moves:

```
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

Let’s now code the **showImage** and **hideImage** functions.

We can create a GSAP timeline for this. Let’s start by setting the opacity to 1 for the reveal element (the top element of that structure we’ve just created). Also, in order to make the image appear on top of all other menu items, let’s set the item’s z-index to a high value.

Next, we can animate the appearance of the image. Let’s do it like this: the image gets revealed to the right or left, depending on the mouse x-axis movement direction (which we have in direction.x). For this to happen, the image element (revealImage) needs to animate its translationX value to the opposite side of its parent element (revealInner element).  
That’s basically it:

```
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

To hide the image we just need to reverse this logic:

```
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

Now we just need to update the **animatableProperties** object properties so the image can move around, rotate and change its brightness smoothly. We do this inside a **requestAnimationFrame** loop. In every cycle we interpolate the previous and current values so things happen with an easing.

We want to rotate the image and change its brightness depending on the x-axis speed (or distance traveled from the previous cycle) of the mouse. Therefore we need to calculate that distance for every cycle which we can get by subtracting the mouse position from the cached mouse position.

We also want to know in which direction we move the mouse since the rotation will be dependent on it. When moving to the left the image rotates negatively, and when moving to the right, positively.

Next, we want to update the **animatableProperties** values. For the translationX and translationY, we want the center of the image to be positioned where the mouse is. Note that the original position of the image element is on the left side of the menu item.

The rotation can go from -60 to 60 degrees depending on the speed/distance of the mouse and its direction. Finally the brightness can go from 1 to 4, also depending on the speed/distance of the mouse.

In the end, we take these values together with the previous cycle values and use interpolation to set up a final value that will then give us that smooth feeling when animating the element.

This is how the render function looks like:

```
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

I hope this has been not too difficult to follow and that you have gained some insight into constructing this fancy effect.

Please let me know if you have any question [@codrops](https://twitter.com/codrops) or [@crnacura](https://twitter.com/crnacura).

Thank you for reading!

**The images used in the demo are by [Andrey Yakovlev and Lili Aleeva](https://www.behance.net/AndrewLili). All images used are licensed under [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.en_US)**

[Find this project on Github](https://github.com/codrops/RapidImageHoverMenu/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
