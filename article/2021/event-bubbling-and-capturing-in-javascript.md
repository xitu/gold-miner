> * 原文地址：[Event Bubbling and Capturing in JavaScript](https://blog.bitsrc.io/event-bubbling-and-capturing-in-javascript-6bc908321b22)
> * 原文作者：[Dulanka Karunasena](https://medium.com/@dulanka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/event-bubbling-and-capturing-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/event-bubbling-and-capturing-in-javascript.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)、[jaredliw](https://github.com/jaredliw)

# 简述 JavaScript 的事件捕获和事件冒泡

![](https://cdn-images-1.medium.com/max/5760/1*7Iz_wjlurP2vVhkBpVVzgA.jpeg)

JavaScript 事件冒泡是为了捕捉和处理 DOM 内部传播的事件。但是你知道事件冒泡和事件捕获之间的区别吗？

在这篇文章中，我将用相关的示例来讨论关于这个主题你所需要了解的全部情况。

## 事件流的传播

在介绍事件捕获和事件冒泡之前，先来看下一个事件是如何在 DOM 内部传播的。

如果我们有几个嵌套的元素处理同一个事件，我们会对哪个事件处理程序会先触发的问题感到困惑。这时，理解事件传播顺序就变得很有必要。

> 通常，一个事件会从父元素开始向目标元素传播，然后它将被传播回父元素。

JavaScript 事件分为三个阶段：

* **捕获阶段**：事件从父元素开始向目标元素传播，从 `Window` 对象开始传播。
* **目标阶段**：该事件到达目标元素或开始该事件的元素。
* **冒泡阶段**：这时与捕获阶段相反，事件向父元素传播，直到 `Window` 对象。

下图将让你进一步了解事件传播的生命周期：

![DOM 事件流](https://cdn-images-1.medium.com/max/2000/1*B0k6-J5ZwfmsxZDXAOCT2Q.jpeg)

现在你大概了解了 DOM 内部的事件流程，让我们再来看下事件捕获和冒泡是如何出现的。

## 什么是事件捕获

> 事件捕获是事件传播的初始场景，从包装元素开始，一直到启动事件生命周期的目标元素。

如果你有一个与浏览器的 `Window` 对象绑定的事件，它将是第一个被执行的。所以，在下面的例子中，事件处理的顺序将是 `Window`、`Document`、`DIV 2`、`DIV 1`，最后是 `button`。

![事件捕获示例](https://cdn-images-1.medium.com/max/2000/1*bwNxfZVJ28WSAQ5s1MCc3A.gif)

这里我们可以看到，事件捕获只发生在被点击的元素或目标上，该事件不会传播到子元素。

我们可以使用 `addEventListener()` 方法的 `useCapture` 参数来注册捕捉阶段的事件。

```js
target.addEventListener(type, listener, useCapture)
```

你可以使用下面的代码来测试上述示例，并获得事件捕获的实践经验。

```JavaScript
window.addEventListener("click", () => {
    console.log('Window');
  },true);

document.addEventListener("click", () => {
    console.log('Document');
  },true);

document.querySelector(".div2").addEventListener("click", () => { 
    console.log('DIV 2');
  },true);

document.querySelector(".div1").addEventListener("click", () => {
    console.log('DIV 1');
  },true);

document.querySelector("button").addEventListener("click", () => {
    console.log('CLICK ME!');
  },true);
```

## 什么是事件冒泡

如果你知道事件捕获，事件冒泡就很容易理解，它与事件捕获是完全相反的。

> 事件冒泡将从一个子元素开始，在 DOM 树上传播，直到最上面的父元素事件被处理。

在 `addEventListener()` 中省略或将 `useCapture` 参数设置为 `false`，将注册冒泡阶段的事件。所以，事件监听器默认监听冒泡事件。

![事件冒泡示例](https://cdn-images-1.medium.com/max/2000/1*sfTTnB76jtG7dhfMQa0Zsg.gif)

在我们的示例中，我们对所有的事件使用了事件捕获或事件冒泡。但是如果我们想在两个阶段内都处理事件呢？

让我们举个例子，在冒泡阶段处理 `Document` 和 `DIV 2` 的点击事件，其他事件则在捕获阶段处理。

![注册两个阶段的事件](https://cdn-images-1.medium.com/max/2000/1*L53X6yq5t-Nw_vl1EH9EWA.gif)

连接到 `Window`、`DIV 1` 和 `button` 的点击事件将在捕获过程中分别触发，而 `DIV 2` 和 `Document` 监听器则在冒泡阶段依次触发。

```JavaScript
window.addEventListener("click", () => {
    console.log('Window');
  },true);

document.addEventListener("click", () => {
    console.log('Document');
  }); // 已注册为冒泡

document.querySelector(".div2").addEventListener("click", () => { 
    console.log('DIV 2');
  }); // 已注册为冒泡

document.querySelector(".div1").addEventListener("click", () => {
    console.log('DIV 1');
  },true);

document.querySelector("button").addEventListener("click", () => {
    console.log('CLICK ME!');
  },true);
```

我想现在你已经对事件流、事件冒泡和事件捕获有了很好的理解。那么，让我们看下什么时候可以使用事件冒泡和事件捕获。

## 事件捕获和冒泡的应用

通常情况下，我们只需要在全局范围内执行一个函数，就可以使用事件传播。例如，我们可以注册文档范围内的监听器，如果 `DOM` 内有事件发生，它就会运行。

> 同样地，我们可以使用事件捕获和冒泡来改变用户界面。

假设我们有一个允许用户选择单元格的表格，我们需要向用户显示所选单元格。

![演示](https://cdn-images-1.medium.com/max/2000/1*ZAgwPqbTDtk8TROAUe-tdw.gif)

> 在这种情况下，为每个单元格分配事件处理程序将不是一个好的做法。它最终会导致代码的重复。

作为一个解决方案，我们可以使用一个单独的事件监听器，并利用事件冒泡和捕获来处理这些事件。

因此，我为 `table` 创建了一个单独的事件监听器，它将被用来改变单元格的样式。

```js
document.querySelector("table").addEventListener("click", (event) =>
  {       
     if (event.target.nodeName == 'TD')
         event.target.style.background = "rgb(230, 226, 40)";
  }
);
```

在事件监听器中，我使用 `nodeName` 来匹配被点击的单元格，如果匹配，单元格的颜色就会改变。

## 如何防止事件传播

> 有时，如果事件冒泡和捕捉开始不受我们控制地传播时，就会让人感到厌烦。

如果你有一个严重嵌套的元素结构，这也会导致性能问题，因为每个事件都会创建一个新的事件周期。

![当冒泡变得烦人时](https://cdn-images-1.medium.com/max/3840/1*BObT883lMyK8AH2RPaBGdQ.gif)

在上述情况下，当我点击删除按钮时，包装元素的点击事件也被触发了。这是由于事件冒泡导致的。

> 我们可以使用 `stopPropagation()` 方法来避免这种行为，它将阻止事件沿着 DOM 树向上或向下进一步传播。

```js
document.querySelector(".card").addEventListener("click", () => {
    $("#detailsModal").modal();
});

document.querySelector("button").addEventListener("click",(event)=>{
    event.stopPropagation(); // 停止冒泡
    $("#deleteModal").modal();
});
```

![使用 `stopPropagation()` 后](https://cdn-images-1.medium.com/max/3840/1*sDLWoQ_4VjjPiXhUGoY3uA.gif)

## 本文总结

JavaScript 事件捕获和冒泡可以用来有效地处理 Web 应用程序中的事件。了解事件流以及捕获和冒泡是如何工作的，将有助于你通过正确的事件处理来优化你的应用程序。

例如，如果你的应用程序中有任何意外的事件启动，了解事件捕获和冒泡可以节省你排查问题的时间。

因此，我希望你尝试上述示例并在评论区分享你的经验。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
