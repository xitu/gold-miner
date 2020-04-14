> * 原文地址：[What on Earth is the Shadow DOM and Why Does it Matter?](https://medium.com/better-programming/what-on-earth-is-the-shadow-dom-and-why-it-matters-eff0884bd33d)
> * 原文作者：[Aphinya Dechalert](https://medium.com/@PurpleGreenLemon)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-on-earth-is-the-shadow-dom-and-why-it-matters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-on-earth-is-the-shadow-dom-and-why-it-matters.md)
> * 译者：[Renzi](https://github.com/mengrenzi)
> * 校对者：

#影子 DOM 到底是什么？它为什么重要？

![Photo by [Tom Barrett](https://unsplash.com/@wistomsin?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/shadow?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6538/1*wDb9Aw5YXEM_O8DqrsG0vQ.jpeg)

> 光有一个 Dom 还不够吗？

我们都曾听说过 DOM，它是一个容易被忽略的话题，而且对此也没有充足的讨论，**影子 DOM** 这个名字听起来有点邪恶，但是相信我，它不是。

DOM 的概念是网络和界面的基础之一，并且与 JavaScript 息息相关。

许多人都知道 DOM 是什么。首先，它代表文档对象模型。但这意味着什么？为什么它很重要？了解它如何工作与您的下一个编码项目有什么关系？

---

继续往下看吧。

## DOM 到底是什么？

有一种误解认为 HTML 元素和 DOM 是一回事。但是，它们在功能和创建方式上是独立且不同的。

HTML 是一种标记语言。其唯一目的是修饰呈现的内容。它使用标记来定义元素，并使用人类可读的单词。它是一种标准化的标记语言，具有一组预定义的标记。

标记语言与典型的编程语法不同，因为标记语言除了创建内容分界外没有做任何其他事情。

然而，DOM 是由浏览器或渲染接口创建的对象构造的树。从本质上说，它有点像一个 API，用于将内容挂接到标记结构中。

那么这棵树是什么样的呢？

让我们快速浏览以下 HTML：

```HTML
<!doctype html>
   <html>
   <head>
     <title>DottedSquirrel.com</title>
   </head>
   <body>
      <h1>Welcome to the site!</h1>
      <p>How, now, brown, cow</p>
   </body>
   </html>
```

这将生成下面的 DOM 树。

![](https://cdn-images-1.medium.com/max/2000/1*J8n54a_p1jI6bPPJIKufbg.jpeg)

由于 HTML 文档中的所有元素和样式都位于全局范围内，因此这也意味着 DOM 是一个大的全局范围对象。

`document` 在 JavaScript 中是指文档的全局空间。`querySelector()` 方法允许您查找和访问特定的元素类型，而不管它在 DOM 树中的嵌套有多深，只要您有正确的路径即可。

比如：

```js
document.querySelector(".heading");
```

这将选择文档中带有 class="heading" 的第一个元素。

假设您执行以下操作：

```js
document.querySelector("p");
```

这将针对文档中存在的第一个 `\<p>` 元素。

具体来讲，您还可以执行以下操作：

```js
document.querySelector("h1.heading");
```

这将针对第一个 `\<h1 class="heading">` 实例。

使用 `.innerHTML = ""` 将使您能够修改标签之间的任何内容。例如，你可以这样做：

```js
document.querySelector("h1").innerHTML = "Moooo!"
```

这会将第一个 `\<h1>` 标记内的内容更改为 `Moooo!`。

---

现在，我们已经梳理了 DOM 的基础知识，下面我们来讨论存在于 DOM 中的 DOM 的来历。

## 存在于 DOM 中的 DOM（又名影子 DOMs）

有时候，一个简单的单一对象 DOM 就可以满足 Web 应用程序或 Web 页面的所有需求。但是，有时您需要第三方脚本来显示内容，而不需要它破坏您已经存在的元素。

这就是影子 DOM 发挥作用的地方。

影子 DOM 是独立存在的 DOM，有自己的作用域集，不属于原始 DOM 的一部分。

影子 DOM 本质上是独立的 Web 组件，因此可以构建模块化的接口，而不会相互冲突。

浏览器会自动将影子 DOM 附加到某些元素，例如 `\<input>`，`\<textarea>` 和 `\<video>`。

但是有时您需要手动创建影子 DOM 来提取所需的部分。为此，您需要首先创建一个影子主机，然后再创建一个影子根。

#### 设置影子主机

为了分割出一个影子 DOM，您需要确定提取哪一组包装器。

例如，您希望 `host` 类成为定义影子 DOM 边界的包装器集合。

```HTML
<!doctype html>
   <html>
   <head>
     <title>DottedSquirrel.com</title>
   </head>
   <body>
      <h1>Welcome to the site!</h1>
      <p>How, now, brown, cow</p> 
      <span class="host"> 
           ... 
      <span class="host">
   </body>
   </html>
```

通常情况下，浏览器不会将 `span` 自动转换为影子 DOM。要通过 JavaScript 做到这一点，你需要使用 `querySelector()` 和 `attachShadow()` 方法。

```js
const shadowHost = document.querySelector(".host");
const shadow = shadowHost.attachShadow({mode: 'open'});
```

`shadow` 被设置为我们的影子 DOM 的影子根。 然后，这些元素成为提取的独立 DOM 的子元素，以 `.host` 作为根类元素。

虽然您仍然可以在检查器中看到 HTML，但是代码的 `host` 部分对根代码不再可见。

要访问这个新的影子 DOM，你只需要使用一个对影子根的引用，即上面例子中的 `shadow`。

例如，你希望添加一些内容，可以这样做:

```js
const paragraph = document.createElement("p");
paragraph.text = shadow.querySelector("p");
paragraph.innerHTML = "helloooo!";
```

这将在影子根内部创建一个带有 `helloooo!` 的新 `p` 元素。

#### 影子DOM 的一部分

影子 DOM 由四部分组成：影子主机、影子树、影子边界和影子根。

影子主机是影子 DOM 所连接的常规 DOM 节点。在前面的示例中，这是通过类 `host` 实现的。

这个影子树的外观和行为与普通的 DOM 树类似，只是它的范围仅限于影子主机的边缘。

影子边界是影子 DOM 开始和结束的地方。

最后，影子根是影子树的根节点，这是不同于影子主机（即 `host` 类，基于上面的例子）。

让我们再看看这段代码:

```js
const shadowHost = document.querySelector(".host");
const shadow = shadowHost.attachShadow({mode: 'open'});
```

`shadowHost` 常量是我们的影子宿主，而 `shadow` 实际上是影子的根。两者之间的区别是 `shadow` 返回 `DocumentFragment`，而 `shadowHost` 返回 `document` 元素。

---

将主机视为实际影子 DOM 的占位符。

## 为什么影子 DOMs 很重要？

现在的大问题是：为什么影子 DOM 很重要？

影子 DOM 是一种浏览器技术，用于在 Web 组件中定义变量和 CSS 的范围。

首先，DOM 是一个对象，如果你不能跨过你想确保彼此独立的边界，那么你不可能对单个对象进行所有操作。

这意味着影子 DOMs 支持封装，也就是说，能够将标记结构、样式和行为与其他代码分离并隐藏起来，以使它们不会发生冲突。

这就是影子 DOM 的核心。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
