> * 原文地址：[Writing better CSS with currentColor](https://hashnode.com/post/writing-better-css-with-currentcolor-cit5mgva31co79c53ia20vetq)
* 原文作者：[Alkshendra Maurya](https://hashnode.com/@alkshendra)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[yangzj1992](http://qcyoung.com)
* 校对者： [linpu.li](https://github.com/llp0574), [Nicolas(Yifei) Li](https://github.com/yifili09)

# 使用 currentColor 属性写出更好的 CSS 代码

总有一些极其强大的 CSS 属性在目前已经有了很好的浏览器支持，但却很少被开发者使用。 `currentColor` 就是这样的属性之一。

MDN 把 currentColor [定义为](https://developer.mozilla.org/en/docs/Web/CSS/color_value#currentColor_keyword):

> `currentColor` 代表了当前元素被应用上的 color 颜色值。它允许让继承自属性或子元素属性的 color 属性为默认值而不再继承。

在本文中，我们将通过一些有趣的方式来概述如何使用 CSS `currentColor` 这一关键字。

* * *

## 介绍

`currentColor` 关键字按某种规则获取了 color 属性的值并赋值给了自身。

在任何你想要默认继承 `color` 属性值的地方都可以使用 `currentColor` 这一关键字。这样当你改变 `color` 关键字的属性值时，它会自动的通过规则反映在所有 `currentColor` 关键字使用的地方。这难道不是很棒吗？😀

    .box {
        color: red;
        border 1px solid currentColor;
        box-shadow: 0 0 2px 2px currentColor;
    }

在上面的代码片段里，你可以看到我们不是在所有的地方都重复相同的 color 值，而是用 currentColor 来代替。这使得 CSS 变得更加容易管理，你将不再需要在不同的地方来追踪 color 值

* * *

## 各种用法

来看一下 `currentColor` 可能的用例和例子:

**简化 color 定义**

像链接，边框，图标以及阴影的值总是随着它们的父元素 color 值保持一致，这可以通过简化的 currentColor 来替换一遍又一遍的特定 color 值；从而使代码更加易于管理。

例如:

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

在上面的代码片段中，你可以看到我们不是在边框、阴影上指定一个颜色，而是在这些属性上使用了 `currentColor`，这将使它们自动变为 `red`。

**简化过渡和动画**

currentColor 可以使 transitions 和 animations 变得更加简单。

让我们考虑一下最早的代码示例，并且改变一下 hover 时的 `color` 值

    .box:hover {
        color: purple;
    }

这里，我们不需要再在 `:hover` 里写三个不同的属性，我们只需改变 `color` 值；所有使用 `currentColor` 的属性会自动在 hover 时发生改变。

**在伪元素上使用**

像是`:before` 和 `:after` 这样的伪元素也同样可以通过用 currentColor 来获取它的父元素的值。这就可以用于创建带有动态颜色的『提示框』，或是使用 body 颜色的『覆盖层』，并给它一个半透明的效果。

    .box {
        color: red;
    }
    .box:before {
        color: currentColor;
        border: 1px solid currentColor;
    }

这里，`:before` 伪元素的 `color` 和 `border-color` 会从父元素 div 中获得并可以被组建成类似提示框的东西。

**在 SVG 中使用**

SVG 中 `currentColor` 的值同样可以从父元素中获取。当你在不同地方应用 SVG 并想从父元素中继承 color 值而又不想每次明确提及时，使用它是相当有帮助的。

    svg {
        fill: currentColor;
    }

在这里，svg 将会使用与它父元素相同的填充颜色，并且会动态的随着父元素颜色的修改而发生变化。

**在渐变中使用**

`currentColor` 可以同样用于创建 CSS 渐变，其中渐变属性的一部分可以被设置成父元素的 `currentColor` 。

    .box {
        background: linear-gradient(top bottom right, currentColor, #FFFFFF);
    }

在这里，**顶部**的渐变颜色将会总是与父元素保持一致。虽然在这种情况下只会有一个动态颜色的限制，但对基于父元素颜色来生成动态的渐变来说，这仍然是一个简洁的方法。

这儿有一个 [Codepen 示例](http://codepen.io/alkshendra/pen/xEVrJJ?editors=1100#0)来演示上述的所有例子。

* * *

## 浏览器支持

CSS `currentColor` 是从 CSS3 引入 SVG 规范时产生的，自 2003 年以来一直存在。因此浏览器对 `currentColor` 的支持是很可靠的，除了 IE8 和一些更低版本的浏览器。

下面这张图展示了目前有关浏览器支持情况的信息，信息来自 [caniuse.com](http://caniuse.com/#feat=currentcolor):

![currentColor Support](https://res.cloudinary.com/hashnode/image/upload/v1474021764/g03f4hx1ftb0frtoonfw.png)

* * *

## 结论

CSS `currentColor` 尽管是一个很好的特性，但还尚未得到充分运用。它提供了很棒的支持并带来了相当的可能性来使你保持你的代码更加的整洁。

尽管 CSS 变量有它自己的方式，但是养成使用 `currentColor` 的习惯还是很酷的。

这只是一个我发现的很有趣的简单的话题，如果有人也对此话题感兴趣。请让我知道你的想法并在下面留言！😊

