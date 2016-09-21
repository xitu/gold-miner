> * 原文地址：[Writing better CSS with currentColor](https://hashnode.com/post/writing-better-css-with-currentcolor-cit5mgva31co79c53ia20vetq)
* 原文作者：[Alkshendra Maurya](https://hashnode.com/@alkshendra)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：



There are some extremely powerful CSS properties that have good browser support but are rarely used by the developers. `currentColor` is one of such properties.

MDN [defines](https://developer.mozilla.org/en/docs/Web/CSS/color_value#currentColor_keyword) currentColor as

> The `currentColor` keyword represents the calculated value of the element's color property. It allows to make the color properties inherited by properties or child's element properties that do not inherit it by default.

In this article, let's get an overview on how to use CSS `currentColor` keyword in some interesting ways.

* * *

## Introduction

The `currentColor` keyword takes up the value of the color property in a rule and assigns it to itself.

You can use this `currentColor` keyword in your code wherever you want the value of the `color` property to be inherited by default. So when you change the value of the `color` keyword, it is automatically reflected at all the places where `currentColor` keyword is used as a rule. Isn't it awesome? 😀

    .box {
        color: red;
        border 1px solid currentColor;
        box-shadow: 0 0 2px 2px currentColor;
    }

In the above code snippet, you can see that instead of repeating the same color value everywhere, we have replaced it with currentColor. This makes the CSS much more manageable as you don't have to keep track of color values at different places.

* * *

## Possible Usage

Lets checkout some possible use cases and examples for `currentColor`:

**Simplifying the color definitions**

Things like like links, borders, icons and box-shadow that usually follow the same color as their parent can be simplified by giving the currentColor value instead of mentioning the same specific color value again, and again; thus making the code more manageable.

Example:

    .box {
        color: red;
    }
    .box .child-1 {
        background: currentColor;
    }
    .box .child-2 {
        color: currentColor;
        border 1px solid currentColor;
    }

In the above code snippet, you can see that instead of specifying a color for the border, and box-shadow, we have used `currentColor` in these properties, which is automatically chabged to "red".

**Simplifying transitions and animations**

currentColor can be used to make the transitions and animations much simpler.

Let's consider the example code from the earlier use-case, and change the `color` on hover.

    .box:hover {
        color: purple;
    }

Here, instead of writing three different properties in the `:hover`, we just changed the `color` value; and all the properties using `currentColor` would automatically reflect the change on hover.

**Use with psuedo elements**

Psuedo elements like `:before` and `:after` can also take up the currentColor value from its parent element. This can be used to create things like "tooltips" with dynamic colors or "overlays" with the body color, and an opacity to give it a translucent effect.

    .box {
        color: red;
    }
    .box:before {
        color: currentColor;
        border: 1px solid currentColor;
    }

Here, the `:before` psuedo element will have the `color` and the `border-color` from the parent div and can be manipulated in building something like a tooltip.

**Use with SVGs**

SVGs can also take the `currentColor` value from the parent elements. This can be really useful when you're using the SVGs in different places and want to inherit the color from the parent without explicitly mentioning it every time.

    svg {
        fill: currentColor;
    }

Here, the svg would have the same fill color as its parent element and will change dynamically depending on the parent element's color.

**Use with Gradients**

`currentColor` can also be used for creating CSS gradients where one part of the gradient could be set to have the `currentColor` of the parent.

    .box {
        background: linear-gradient(top bottom right, currentColor, #FFFFFF);
    }

Here, the _top_ part of the gradient would always have the color that the parent element has. Though there's a limitation of having just one dynamic color in this case, this still is a neat trick for generating dynamic gradients based on parent element's color.

Here is a [Codepen example](http://codepen.io/alkshendra/pen/xEVrJJ?editors=1100#0) demonstrating all the above use cases.

* * *

## Brower Support

The CSS `currentColor` was derived from the SVG spec into CSS3, and has been there since 2003\. Thus, the support for `currentColor` is pretty solid, with the exception of IE8 and lower versions.

Here's a chart showing the current browser support information as mentioned on [caniuse.com](http://caniuse.com/#feat=currentcolor):

![currentColor Support](https://res.cloudinary.com/hashnode/image/upload/v1474021764/g03f4hx1ftb0frtoonfw.png)

* * *

## Conclusion

CSS `currentColor` is an under-used, albeit great feature. It has great support and brings a lot of possibilities onto the table aiding you to keep your code much cleaner.

While the CSS variables are on their way, making the use of `currentColor` a habit, would definitely be rad.

This was just a short take on a topic I found interesting, and thought a few others would too. Let me know of your thoughts in the comments below! 😊

