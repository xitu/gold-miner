> * 原文地址：[Meet the New Dialog Element](https://keithjgrant.com/posts/2018/meet-the-new-dialog-element/?utm_source=frontendfocus&utm_medium=email)
> * 原文作者：[keithjgrant](https://keithjgrant.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/meet-the-new-dialog-element.md](https://github.com/xitu/gold-miner/blob/master/TODO/meet-the-new-dialog-element.md)
> * 译者：[FateZeros](https://github.com/fatezeros)
> * 校对者：[ryouaki](https://github.com/ryouaki) [PCAaron](https://github.com/PCAaron)

# 迎接新的 Dialog 元素

![用字母在前面装饰的旧铁邮箱](https://keithjgrant.com/images/2018/iron-mailbox.jpg)

[HTML 5.2](https://www.w3.org/TR/html52/) 为原生弹窗对话框引入了一个新的 `<dialog>` 元素。乍一看，它似乎相当简单（本来就是），但当我和它打交道的过程中，我发现有一些很棒的新特性很容易被忽视掉。

在本文的最后我加上了一个完整可行的 Demo，但是如果你想在阅读的过程中也查看的话，[你可以看这里](https://codepen.io/keithjgrant/pen/eyMMVL)。

这是一个基本的弹窗对话框标记：

```
<dialog open>
  Native dialog box!
</dialog>
```

`open` 属性意味着对话框是可见的。没有它，除非你用 JavaSript 使它出现，否则它就是隐藏的。在添加样式之前，对话框渲染如下所示：

![对话框中的文本有加粗的黑色轮廓](https://keithjgrant.com/images/2018/native-dialog-basic.png)

它在页面中是绝对定位的，因此它会按照你所期望的那样出现在其他内容前面，并且水平居中。默认情况下，它和内容等宽。

## 基本操作

JavaScript 有几个方法和属性可以方便地处理 `<dialog>` 元素。你可能最需要的两个方法是 `showModal()` 和 `close()`。

```
const modal = document.querySelector('dialog');

// 使对话框出现（添加 `open` 属性）
modal.showModal();

// 隐藏对话框（移除 `open` 属性）
modal.close();
```

当你用 `showModal()` 打开对话框的时候，页面会添加一层背景，阻止用户与对话框之外的内容交互。默认情况下，这层背景是完全透明的，但是你可以改变 CSS 属性使它可见（后面会有更多介绍）。

按 Esc 键会关闭对话框，你也可以提供一个关闭按钮来触发 `close()` 方法。

还有第三个方法，`show()` 也会让对话框出现，但不会伴随背景层。用户仍可以和对话框之外的可见的元素进行交互。

### 浏览器支持和 Polyfill

现在，只有 Chrome 支持 `<dialog>`。Firefox 提供了默认样式，但是 JavaScript API 仅在标志后启用。我猜想 Firefox 会很快支持它。

庆幸地是，[polyfill](https://github.com/GoogleChrome/dialog-polyfill) 提供了 JavaScript 事件和默认样式。用 npm 安装 `dialog-polyfill` 来使用它 —— 或者使用常用的旧的 `<script>` 标签。这样 `<dialog>` 就可以在 IE9及以上版本中使用了。

当使用 polyfill 时，页面上的每个对话框都需要被初始化：

```
dialogPolyfill.registerDialog(modal);
```

这不会替代拥有它的浏览器中的原生事件。

## 样式

打开和关闭对话框完成了，但是它起初看起来并不专业。我们像给其他元素添加样式那样，给对话框添加样式。背景层可以用新的 `::backdrop` 伪元素来设计。

```
dialog {
  padding: 0;
  border: 0;
  border-radius: 0.6rem;
  box-shadow: 0 0 1em black;
}

dialog::backdrop {
  /* make the backdrop a semi-transparent black */
  background-color: rgba(0, 0, 0, 0.4);
}
```

对于那些需要使用 polyfill 的老浏览器，这个伪元素选择器将不会起作用，然而，在这个对话框位置后，polyfill 会立即添加一个 `.backdrop` 元素。你可以像这样用 CSS 来定位它：

```
dialog + .backdrop {
  background-color: rgba(0, 0, 0, 0.4);
}
```

添加更多的标记来提供样式的钩子。一个常用的做法是将对话框划分为标题，正文和页脚：

```
<dialog id="demo-modal">
  <h3 class="modal-header">A native modal dialog box</h3>
  <div class="modal-body">
    <p>Finally, HTML has a native dialog box element! This is fantastic.</p>
    <p>And a polyfill makes this usable today.</p>
  </div>
  <footer class="modal-footer">
    <button id="close" type="button">close</button>
  </footer>
</dialog>
```

给它添加一些 CSS，你可以让对话框做成任何你想要的外观：

  

## 更多控制

通常，我们想要从对话框中获得更多用户反馈。当关闭对话框时，你可以传递一个字符串值到 `close()` 方法。该值将会被赋值给对话框 DOM 元素的 `retrunValue`属性，因此它可以在后面被读取到：

```
modal.close('Accepted');

console.log(modal.returnValue); // logs `Accepted`
```

还有一些事件你可以监听。两个有用的事件是 `close` （当对话框关闭的时候触发）和 `cancel`（当用户按了 Esc 关闭对话框时触发）。

有一件事似乎被忘掉了，当背景层被点击时能够关闭对话框，但有一个变通方案。当点击背景层时，触发 `<dialog>` 的点击事件作为事件目标。而且，如果你构造对话框使得子元素填充了整个对话框，那些子元素将会被作为对话框内任何点击的目标。这种方式，你可以监听对话框上的点击，当点击事件的目标是对话框本身的时候关闭它：

```
modal.addEventListener('click', (event) => {
  if (event.target === modal) {
    modal.close('cancelled');
  }
});
```

虽然不完美，但是起了作用。如果你找到了更好的方法来检测背景层上的点击，请让我知道。

## 完整可行的 Demo

我在下面的示例中演示了很多东西。亲自实践下，看你还能用 `<dialog>` 做些什么。它包含了 polyfill，所以它应该能在大多数浏览器中运行。

请参阅 Keith J. Grant ([@keithjgrant](https://codepen.io/keithjgrant)) 在 [CodePen](https://codepen.io) 上的 [<dialog>](https://codepen.io/keithjgrant/pen/eyMMVL/)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
