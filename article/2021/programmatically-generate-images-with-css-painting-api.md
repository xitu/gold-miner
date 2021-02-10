> * 原文地址：[Programmatically generate images with CSS Painting API](https://blog.bitsrc.io/programmatically-generate-images-with-css-painting-api-3b1a860dae3b)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/programmatically-generate-images-with-css-painting-api.md](https://github.com/xitu/gold-miner/blob/master/article/2021/programmatically-generate-images-with-css-painting-api.md)
> * 译者：
> * 校对者：

# Programmatically generate images with CSS Painting API

## Programmatically Generate Images with CSS Painting API

#### A JavaScript API for dynamic image creation coupled with CSS

![](https://cdn-images-1.medium.com/max/5760/1*wKYGWd-7eWgpmMeBNiLCDA.jpeg)

Images add color to an application. However, as we all know, having a lot of high-resolution images affects the page load time. For images of products, scenarios, and so on, we have no option but to include these images and optimize the application by caching them. But if you need a geometric image in your application, you don’t have to include it as an asset anymore.

> # You can programmatically generate geometric images on the fly using the CSS Painting API.

Let’s find out what this API is and how to generate an image using it.

## Introduction to the CSS Painting API

The [CSS Painting API](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Painting_API) enables developers to write JavaScript functions to draw images into CSS properties like `background-image` and `border-image`. It provides a set of APIs that gives developers access to the CSSOM. This is a part of CSS Houdini ([Houdini](https://github.com/w3c/css-houdini-drafts) — a collection of new browser APIs, gives developers lower-level access to CSS itself.).

The traditional approach to include an image is as follows.

```
div {
  background-image: url('assets/background.jpg);
}
```

With the CSS Painting API, you can call the `paint()` function and pass in a worklet written in JS instead of the above.

```
div {
  background-image: paint(background);
}
```

The workflow of this would be as follows.

![](https://cdn-images-1.medium.com/max/2000/1*c2EShrISdnmcxc87qJdKPg.png)

You may have come across some unknown terms in the above section. For example, what are these worklets that we keep talking about?

In brief, the JavaScript code written to programmatically generate an image is called a Paint Worklet. A [worklet](https://www.w3.org/TR/worklets-1/#intro) is an extension point into the browser rendering pipeline. There are other types of worklets apart from paint worklets as well, such as animation worklets, layout worklets, etc.

Now let’s look at a step-by-step approach to generate an image programmatically.

## Using the CSS Painting API in practice

In this article, we’ll look at how to create a bubble background.

#### Step 1: Add the CSS paint() function

First of all, you need to add the `paint()` function to the CSS property you need your image to be on.

```
.bubble-background {
  width: 400px;
  height: 400px;
  background-image: paint(bubble);
}
```

---

`bubble` will be the worklet that we create to generate the images. This will be done in the next few steps.

Tip: **Share your reusable components** between projects using [**Bit**](https://bit.dev/) ([Github](https://github.com/teambit/bit)).

Bit makes it simple to share, document, and reuse independent components between projects**.** Use it to maximize code reuse, keep a consistent design, speed up delivery, and build apps that scale.

[**Bit**](https://bit.dev/) supports Node, TypeScript, React, Vue, Angular, and more.

---

![Example: exploring reusable React components shared on [Bit.dev](https://bit.dev/)](https://cdn-images-1.medium.com/max/3678/0*Uc8yted1zlBiHGob.gif)

#### Step 2: Defining the worklet

The worklets need to be kept in an external JS file. The paint worklet would be a `class` . E.g.:- `class Bubble { .... }` . This worklet needs to be registered using the `registerPaint()` method.

```
class Bubble {
    paint(context, canvas, properties) {
        ........
    }
}

registerPaint('bubble', Bubble);
```

The first parameter of the `registerPaint()` method should be the reference you included in CSS.

Now let’s draw the background.

```
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

The logic to create the image is inside the `paint()` method. You would need a bit of knowledge on canvas creation to draw images as above. Refer to the [Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API/Tutorial) documentation if you aren’t familiar with it.

#### Step 3: Invoke the worklet

The final step would be to invoke the worklet in the HTML file.

```
<div class="bubble-background"></div>

<script>
 CSS.paintWorklet.addModule('https://codepen.io/viduni94/pen/ZEpgMja.js');
</script>
```

It’s done!

You have programmatically generated an image in just 3 steps.

## Generated image

The output of what we created will look as follows.

![[View in Editor](https://codepen.io/viduni94/pen/jOMgpNX)](https://cdn-images-1.medium.com/max/2448/1*vvLIdPpqWdRWswddJ9CgUw.png)

## What else can we do with this CSS Painting API?

The power of the CSS Painting API is not over yet. There are more things you can do with it.

#### 1. You can create dynamic images

For example, you can dynamically change the color of the bubbles. CSS variables are used for this purpose. In order to use CSS variables, the browser should have prior knowledge that we are using it. We can use the `inputProperties()` method to do this.

```
registerPaint('bubble', class {
  static get inputProperties() {
   return ['--bubble-size', '--bubble-color'];
  }

  paint() {
    /* ... */
  }
});
```

The variables can be assigned using the third parameter passed to the `paint()` method.

```
paint(context, canvas, properties) {
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

#### 2. You can generate random images using Math.random() in the paint() method.

```
// CSS
body {
  width: 200px;
  height: 200px;
  background-image: paint(random);
}

// JS
function getRandomHexColor() {
  return '#'+ Math.floor(Math.random() * 16777215).toString(16)
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

If you want to know more details about how to implement these, let me know in the comments section below.

It’s awesome, isn’t it?

But, every good thing has at least one bad side to it. This API has very limited support in browsers.

## Browser Support

![Source: [Can I Use](https://caniuse.com/css-paint-api)](https://cdn-images-1.medium.com/max/5464/1*esNAOqTkQ-sH7ObC1XURlg.png)

Most browsers including Firefox have no support for the CSS Paint API. Only Chrome and Chromium-based browsers have full support for this so far. Let’s hope that browser support will improve in the near future.

## Summary

The CSS Paint API is extremely useful to reduce the response time of network requests. This is achieved by generating some images programmatically rather than retrieving them via network requests.

On top of this, the main benefits in my opinion are as follows.

* Ability to create fully customizable images as opposed to static images.
* It creates resolution-independent images (no more bad quality images on your site).

An important point to note is that you can use a polyfill as a workaround to support the browsers like Firefox that’s yet to implement the CSS Painting API.

---

Let us know your thoughts on this too. Thanks for reading!

## Learn more
[**How we Build a Design System**
**Building a design system with components to standardize and scale our UI development process.**blog.bitsrc.io](https://blog.bitsrc.io/how-we-build-our-design-system-15713a1f1833)
[**10 JavaScript Image Manipulation Libraries for 2020**
**Image compression, processing, resizing, and more, for your next web app.**blog.bitsrc.io](https://blog.bitsrc.io/image-manipulation-libraries-for-javascript-187fde1ad5af)
[**CSS Clamp(): The Responsive Combination We’ve All Been Waiting For**
**Bringing Together the Best of the CSS min() and CSS max() Functions**blog.bitsrc.io](https://blog.bitsrc.io/css-clamp-the-responsive-combination-weve-all-been-waiting-for-f1ce1981ea6e)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
