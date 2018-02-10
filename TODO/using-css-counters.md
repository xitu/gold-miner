> * 原文地址：[Using CSS Counters](https://pineco.de/using-css-counters/)
> * 原文作者：[Adam Laki](https://pineco.de/author/laki/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-css-counters.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-css-counters.md)
> * 译者：
> * 校对者：

# Using CSS Counters
# 使用 CSS 计数器

**The CSS counters are variables which we can increment or decrement with the specific property. With the help of it, we can achieve some generic iteration like in a programming language.**
**CSS 计数器是我们可以用特定属性递增或递减的变量。有了它，我们可以在编程语言中实现一些通用的迭代。**

This method can be used for some creative solution which includes a counter for some repeating part of your code.
这种方法可以用于一些创造性的解决方案，其中包括一些重复代码的计数器

To control your counters you need the `counter-reset` and `counter-increment` property and also the `counter()`  `counter()` and `counters()` function pair. This methodology not worth anything without the counter display, for that we can use the simplified content property.
为了控制你的计数器，你需要 `counter-increment` 和 `counter-increment` 属性，以及 `counter()` 和 `counters()` 函数。这种方法如果计数展示，没有任何价值，因此我们可以使用简化的内容属性。

The behavior is simple. You have an unordered list, and you want to count your li items. You specify a new counter on the ul element, and you increment it on the li elements.
特性是简单的。你有一个无序的列表，你想要计数 li 的项。你专门声明了一个新 ul 元素计数器，并在 li 元素上增加。

## counter-reset property
## counter-reset 属性

We can define our counter variable with the `counter-reset` property; for this, we have to give any name and optionally a start value. The default start data is zero. This property goes to the wrapper element.
我们可以用 `counter-reset` 属性来定义我们的计数器变量；为此，我们必须给出任意的名字和可选的开始值。默认的开始值是 0。这个属性是包装器元素。

## counter-increment property
## counter-increment 属性

With the use of the `counter-increment` property, we can increase or decrease our counter value. This property also has an optional second value which specifies the increment/decrement volume.
运用 `counter-increment` 属性，我们可以递增或者递减计数器的值。该属性还有一个可选的值，用于指定递增/递减量。

## counter() function
## counter() 函数

The `counter()` function is responsible for the dump. The place of the dump is the content property because this is where you can give back data to your HTML through CSS. The function has two parameters; the first is the name of the counter variable and the second is the [counter type](https://drafts.csswg.org/css-counter-styles-3/#typedef-counter-style) (optional).
`counter()` 函数负责转储。转储的位置是内容属性，因为这是您可以通过 CSS 将数据返回给 HTML 的地方。该函数有两个参数，第一个参数是计数器变量名，第二参数是[计数器类型](https://drafts.csswg.org/css-counter-styles-3/#typedef-counter-style)(可选)。

**Note:** in CSS there aren’t any concatenation operator so if you want to connect two value in the content property merely use space.
**注意：** 在CSS中没有任何连接运算符，所以如果你想连接内容属性中的两个值只能使用空间。

## counters() function
## counters() 函数

This function does the same job as the `counter()` function. The main difference is that with the `counters()` you can embed the counter iterations to another like in a multi-level ul list. It has three parameters, the first is the name of the counter, the second is the separator, and the third is the counter type (optional).
这个函数跟 `counter()`函数实现同样的功能。主要区别在于用 `counter()` 可以将计数器迭代嵌入到另一个类似于多级 ul 列表。

## Use Case #1 – Automatic Documentation Issue Tracking
## 使用场景 #1 - 自动追踪文档问题

This solution can be handy when you have some repetitive element, and you also want to count them.
当你有一些重复的元素时，这个解决方案可以很方便，并且你也想对它们进行计数。

We create a `counter-reset` on our `.container` wrapper element. After this, we set a `counter-increment` for the items with **issues class name**. In the end, we write out the value of the counter with the help of the content property on the `.issues:before` items.
我们在我们的 `.container` 包裹元素创建一个 `counter-reset`。创建后，我们为具有**问题类名**的项目设置一个 `counter-increment`。最后，我们用`.issues：before` 条目的内容属性写出计数器的值。

See the Pen [CSS Counter Example](https://codepen.io/adamlaki/pen/RrKBpJ/) by Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io).
详见 Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io) 的[ CSS 计数器案例](https://codepen.io/adamlaki/pen/RrKBpJ/) 文章。

## Use Case #2 – Nested Lists
## 使用场景 #2 - 嵌套列表

Using the `counters()` function, we can make nested list counter as we do in our text editor program.

See the Pen [Nesting Counters](https://codepen.io/adamlaki/pen/a1907874b8b6eb2395cf0af7742e8f9d/) by Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io).

## Use Case #3 – Counting Checked Checkboxes
## 使用场景 #3 - 计算已经勾选的 checkbox

Using the input fields `:checked` pseudo-class value we can check if a checkbox is checked and if so we can increment our counter.

See the Pen [Checkbox Counter](https://codepen.io/adamlaki/pen/f1ce9eef0a19069b883da8ec855e4b71/) by Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io).

## Summary in a Video
## 视频总结

[Steve Griffith](https://www.youtube.com/channel/UCTBGXCJHORQjivtgtMsmkAQ) made an excellent and informative overall video on this topic. It is covering almost everything you need to know about CSS counters.

<iframe width="911" height="537" src="https://www.youtube.com/embed/TJR7qGCOjTk" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Other Use Case(s)
## 其他使用案例

1. Šime Vidas posted a [great example with footnotes](https://codepen.io/simevidas/pen/xpbLmV?editors=0100).
2. Sam Dutton made an [interesting line numbering example](https://codepen.io/samdutton/pen/xpGxbY).
3. Gaël use this feature on a complex level [in his project named a11y.css](http://ffoodd.github.io/a11y.css/errors.html).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
