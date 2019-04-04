> * 原文地址：[Crafting Reusable HTML Templates](https://css-tricks.com/crafting-reusable-html-templates/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[xionglong58](https://github.com/xionglong58)，[HearFishle](https://github.com/HearFishle)

# 编写可以复用的 HTML 模板

在我们的[上一篇文章中](https://juejin.im/post/5c9a3cce5188252d9b3771ad), 我们讨论了 web 组件规范（自定义元素、shadow DOM 和 HTML 模板）的高级特性。在本文以及接下来的三篇文章中，我们将这些技术应用到测试并更详细地去验证它们，看下我们在如今的产品如何应用它们。为了做到这些，我们将会从零开始构建一个自定义模式的对话框，来查看这些不同的技术如何组装在一起。

#### 系列文章:

1.  [Web 组件简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可以复用的 HTML 模板（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [从 0 开始创建自定义元素](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web 组件的高阶工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

* * *

### HTML 模板

[Web 组件规范](https://www.w3.org/standards/techs/components#w3c_all)中最不被认可但是最强大的功能之一是 `<template>` 元素。在这个系列的[第一篇文章](https://css-tricks.com/an-introduction-to-web-components)中，我们将这种模板元素定义为『仅在调用时才渲染的用户自定义 HTML 模板』。换句话说，模板就是一种当浏览器被告知时才执行的 HTML 代码，其他情况下是被忽略的。

这种模块可以通过许多有趣的方式去传递和应用。基于本文的目的，我们将看下如何为一种最终应用到自定义元素中的对话框创建模板。

### 定义你的模板

就像它听起来这样简单，一个 `<template>` 是一种 HTML 元素，所以一个含内容的模板所具备的最基本形式如下：

```
<template>
  <h1>Hello world</h1>
</template>
```

在浏览器中运行这段代码会显示空白页面，因为浏览器并没有渲染模板元素内容。这种方式的强大之处在于它允许我们保存自定义内容（或内容结构），以供后续使用，而不需要使用 JavaScript 来动态编写 HTML 代码。

为了使用模板，我们 **将** 需要用到 JavaScript。

```
const template = document.querySelector('template');
const node = document.importNode(template.content, true);
document.body.appendChild(node);
```

真正神奇的地方在于 `document.importNode` 方法。这个函数将会为模板的 `content` 创建一份副本，并且做好将拷贝插入其他文档（或文档片段）的准备。函数的第一个参数获取到模板的内容，第二个参数告诉浏览器要对元素的 DOM 子树做一份深度拷贝（也就是拷贝它的所有子节点）。

我们可以直接使用 `template.content`，但是这样做的话，我们随后需要把内容从元素中移除并将它拼接到其他文档的 body 部分。任何 DOM 节点仅可以被接入到一个位置，所以随后对模板内容的使用将会导致空文档片段（基本上是一个空值），因为之前已移动了内容对象。使用 `document.importNode` 允许我们在不同的位置来复用同一个模板内容的实例。

以上代码执行后，节点内容会被拼接到 `document.body` 对象，并被渲染显示给用户。这样最终使我们能够做许多有趣的事情，比如为我们的用户（或者我们程序的消费者）提供创建内容的模板，类似下面的 demo，在[第一篇文章](https://css-tricks.com/an-introduction-to-web-components)我们讨论过：

请参阅笔记[模板样例](https://codepen.io/calebdwilliams/pen/LqQmXN/)，来自 [CodePen](https://codepen.io) 的 Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams))。

这个例子中，我们提供了两个模板来渲染同样的内容 —— 作者和他写的书。当表格变化时，我们选择渲染与该变化值相关联的模板。使用相同的技术允许我们最终创建一个自定义元素，该元素将使用稍后定义的模板。

### 模板的多功能性

模板中一个有趣的点是我们可以包含 **任意** HTML，包括脚本和样式元素。一个非常简单的模板例子是添加一个可以提示被点击的按钮。

```
<button id="click-me">Log click event</button>
```

让我们加点样式：

```
button {
  all: unset;
  background: tomato;
  border: 0;
  border-radius: 4px;
  color: white;
  font-family: Helvetica;
  font-size: 1.5rem;
  padding: .5rem 1rem;
}
```

...然后通过一个非常简单的脚本来调用按钮：

```
const button = document.getElementById('click-me');
button.addEventListener('click', event => alert(event));
```

当然，我们可以直接使用 `<style>` 和 `<script>` 标签来将他们放在同一个文件中，而非放在分离的文件中：

```
<template id="template">
  <script>
    const button = document.getElementById('click-me');
    button.addEventListener('click', event => alert(event));
  </script>
  <style>
    #click-me {
      all: unset;
      background: tomato;
      border: 0;
      border-radius: 4px;
      color: white;
      font-family: Helvetica;
      font-size: 1.5rem;
      padding: .5rem 1rem;
    }
  </style>
  <button id="click-me">Log click event</button>
</template>
```

一旦这个元素被加入到 DOM 结构中，我们会看到一个 ID 为 `#click-me` 的新按钮，一个全局的 CSS selector 被绑定到这个按钮的 ID，一个简单的事件监听回调函数会提示元素的点击事件。

至于我们的脚本，我们仅需使用 `document.importNode` 来拼接内容，并且我们有一个包含大致内容的 HTML 模板，在页与页之间可以复用。

请参阅笔记[包含脚本和样式的模板例子](https://codepen.io/calebdwilliams/pen/modxXr/)，来自 [CodePen](https://codepen.io) 的 Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams))。

### 为我们的对话框编写模板

回到我们编写一个对话框元素这个任务，我们希望定义自己的模板内容和样式。

```
<template id="one-dialog">
  <script>
    document.getElementById('launch-dialog').addEventListener('click', () => {
      const wrapper = document.querySelector('.wrapper');
      const closeButton = document.querySelector('button.close');
      const wasFocused = document.activeElement;
      wrapper.classList.add('open');
      closeButton.focus();
      closeButton.addEventListener('click', () => {
        wrapper.classList.remove('open');
        wasFocused.focus();
      });
    });
  </script>
  <style>
    .wrapper {
      opacity: 0;
      transition: visibility 0s, opacity 0.25s ease-in;
    }
    .wrapper:not(.open) {
      visibility: hidden;
    }
    .wrapper.open {
      align-items: center;
      display: flex;
      justify-content: center;
      height: 100vh;
      position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
      opacity: 1;
      visibility: visible;
    }
    .overlay {
      background: rgba(0, 0, 0, 0.8);
      height: 100%;
      position: fixed;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
      width: 100%;
    }
    .dialog {
      background: #ffffff;
      max-width: 600px;
      padding: 1rem;
      position: fixed;
    }
    button {
      all: unset;
      cursor: pointer;
      font-size: 1.25rem;
      position: absolute;
        top: 1rem;
        right: 1rem;
    }
    button:focus {
      border: 2px solid blue;
    }
  </style>
  <div class="wrapper">
  <div class="overlay"></div>
    <div class="dialog" role="dialog" aria-labelledby="title" aria-describedby="content">
      <button class="close" aria-label="Close">&#x2716;&#xfe0f;</button>
      <h1 id="title">Hello world</h1>
      <div id="content" class="content">
        <p>This is content in the body of our modal</p>
      </div>
    </div>
  </div>
</template>
```

这段代码将成为我们对话框的基础部分。简单介绍一下，我们有一个全局的关闭按钮，一个标题和一些内容。我们也添加了一些行为来实现可视化触发对话框（尽管它还无法被访问）。不幸的是，样式和脚本内容并非仅限作用于我们的模板，而是应用于整个文件，当我们将多个模板实例添加到 DOM 时，并没有产生理想的中的效果。在下篇文章中，我们将应用自定义元素f生成方法并创建我们自己的元素，实时使用该模板并封装元素的行为。

请查阅笔记[以脚本模板来编写对话框](https://codepen.io/calebdwilliams/pen/JzjLyQ/)，来自 [CodePen](https://codepen.io) 的 Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams))。

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可以复用的 HTML 模板（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [从 0 开始创建自定义元素](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web 组件的高阶工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
