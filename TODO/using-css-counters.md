> * 原文地址：[Using CSS Counters](https://pineco.de/using-css-counters/)
> * 原文作者：[Adam Laki](https://pineco.de/author/laki/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-css-counters.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-css-counters.md)
> * 译者：
> * 校对者：

# Using CSS Counters

**The CSS counters are variables which we can increment or decrement with the specific property. With the help of it, we can achieve some generic iteration like in a programming language.**

This method can be used for some creative solution which includes a counter for some repeating part of your code.

To control your counters you need the `counter-reset` and `counter-increment` property and also the `counter()` and `counters()` function pair. This methodology not worth anything without the counter display, for that we can use the simplified content property.

The behavior is simple. You have an unordered list, and you want to count your li items. You specify a new counter on the ul element, and you increment it on the li elements.

## counter-reset property

We can define our counter variable with the `counter-reset` property; for this, we have to give any name and optionally a start value. The default start data is zero. This property goes to the wrapper element.

## counter-increment property

With the use of the `counter-increment` property, we can increase or decrease our counter value. This property also has an optional second value which specifies the increment/decrement volume.

## counter() function

The `counter()` function is responsible for the dump. The place of the dump is the content property because this is where you can give back data to your HTML through CSS. The function has two parameters; the first is the name of the counter variable and the second is the [counter type](https://drafts.csswg.org/css-counter-styles-3/#typedef-counter-style) (optional).

**Note:** in CSS there aren’t any concatenation operator so if you want to connect two value in the content property merely use space.

## counters() function

This function does the same job as the `counter()` function. The main difference is that with the `counters()` you can embed the counter iterations to another like in a multi-level ul list. It has three parameters, the first is the name of the counter, the second is the separator, and the third is the counter type (optional).

## Use Case #1 – Automatic Documentation Issue Tracking

This solution can be handy when you have some repetitive element, and you also want to count them.

We create a `counter-reset` on our `.container` wrapper element. After this, we set a `counter-increment` for the items with **issues class name**. In the end, we write out the value of the counter with the help of the content property on the `.issues:before` items.

See the Pen [CSS Counter Example](https://codepen.io/adamlaki/pen/RrKBpJ/) by Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io).

## Use Case #2 – Nested Lists

Using the `counters()` function, we can make nested list counter as we do in our text editor program.

See the Pen [Nesting Counters](https://codepen.io/adamlaki/pen/a1907874b8b6eb2395cf0af7742e8f9d/) by Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io).

## Use Case #3 – Counting Checked Checkboxes

Using the input fields `:checked` pseudo-class value we can check if a checkbox is checked and if so we can increment our counter.

See the Pen [Checkbox Counter](https://codepen.io/adamlaki/pen/f1ce9eef0a19069b883da8ec855e4b71/) by Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io).

## Summary in a Video

[Steve Griffith](https://www.youtube.com/channel/UCTBGXCJHORQjivtgtMsmkAQ) made an excellent and informative overall video on this topic. It is covering almost everything you need to know about CSS counters.

<iframe width="911" height="537" src="https://www.youtube.com/embed/TJR7qGCOjTk" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Other Use Case(s)

1. Šime Vidas posted a [great example with footnotes](https://codepen.io/simevidas/pen/xpbLmV?editors=0100).
2. Sam Dutton made an [interesting line numbering example](https://codepen.io/samdutton/pen/xpGxbY).
3. Gaël use this feature on a complex level [in his project named a11y.css](http://ffoodd.github.io/a11y.css/errors.html).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
