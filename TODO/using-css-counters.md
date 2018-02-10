> * 原文地址：[Using CSS Counters](https://pineco.de/using-css-counters/)
> * 原文作者：[Adam Laki](https://pineco.de/author/laki/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-css-counters.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-css-counters.md)
> * 译者：
> * 校对者：

# 使用 CSS 计数器

**CSS 计数器是我们可以用特定属性递增或递减的变量。有了它，我们可以在编程语言中实现一些通用的迭代。**

这种方法可以用于一些创造性的解决方案，其中包括一些重复代码的计数器。

为了控制你的计数器，你需要 `counter-increment` 和 `counter-increment` 属性，以及 `counter()` 和 `counters()` 函数。这种方法如果计数展示，没有任何价值，因此我们可以使用简化的内容属性。

特性是简单的。你有一个无序的列表，你想要计数 li 的项。你专门声明了一个新 ul 元素计数器，并在 li 元素上增加。

## counter-reset 属性

我们可以用 `counter-reset` 属性来定义我们的计数器变量；为此，我们必须给出任意的名字和可选的开始值。默认的开始值是 0。这个属性是包装器元素。

## counter-increment 属性

运用 `counter-increment` 属性，我们可以递增或者递减计数器的值。该属性还有一个可选的值，用于指定递增/递减量。

## counter() 函数

`counter()` 函数负责转储。转储的位置是内容属性，因为这是您可以通过 CSS 将数据返回给 HTML 的地方。该函数有两个参数，第一个参数是计数器变量名，第二参数是[计数器类型](https://drafts.csswg.org/css-counter-styles-3/#typedef-counter-style)(可选)。

**注意：** 在CSS中没有任何连接运算符，所以如果你想连接内容属性中的两个值只能使用空间。

## counters() 函数

这个函数跟 `counter()`函数实现同样的功能。主要区别在于用 `counter()` 可以将计数器迭代嵌入到另一个类似于多级 ul 列表。它有三个参数，第一个是计数器名称，第二个是分隔符，第三个是计数器类型（可选）。

## 使用场景 #1 - 自动追踪文档问题
当你有一些重复的元素时，这个解决方案可以很方便，并且你也想对它们进行计数。

我们在我们的 `.container` 包裹元素创建一个 `counter-reset`。创建后，我们为具有**问题类名**的项目设置一个 `counter-increment`。最后，我们用`.issues：before` 条目的内容属性写出计数器的值。

详见 Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io) 的[ CSS 计数器案例](https://codepen.io/adamlaki/pen/RrKBpJ/) 文章。

## 使用场景 #2 - 嵌套列表

使用 `counters()` 函数，我们可以像在文本编辑器程序那样制作嵌套列表计数器。

详见 Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io) 的[嵌套计数器](https://codepen.io/adamlaki/pen/a1907874b8b6eb2395cf0af7742e8f9d/)文章。

## 使用场景 #3 - 计算已经勾选的复选框

使用输入字段`：checked` 伪类值，我们可以检查复选框是否被选中，如果是，我们可以增加我们的计数器。

详见 Adam Laki ([@adamlaki](https://codepen.io/adamlaki)) on [CodePen](https://codepen.io) 的[复选框计数器](https://codepen.io/adamlaki/pen/RrKBpJ/) 文章。

## 视频总结

[Steve Griffith](https://www.youtube.com/channel/UCTBGXCJHORQjivtgtMsmkAQ) 就这个话题做了一个很好的和内容丰富的整套视频。它涵盖了几乎所有你需要了解的 CSS 计数器。

<iframe width="911" height="537" src="https://www.youtube.com/embed/TJR7qGCOjTk" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## 其他使用案例

1. Šime Vidas 发布了一个 [注释很好的示例](https://codepen.io/simevidas/pen/xpbLmV?editors=0100)。
2. Sam Dutton 做了一个[有趣的在线计数示例](https://codepen.io/samdutton/pen/xpGxbY)。
3. Gaël 在复杂的层面上[为他的名为 a11y.css 的项目](http://ffoodd.github.io/a11y.css/errors.html)使用了这个特性。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
