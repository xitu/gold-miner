> * 原文地址：[What’s New in HTML 5.2?](https://bitsofco.de/whats-new-in-html-5-2/)
> * 原文作者：[bitsofco](https://bitsofco.de/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-html-5-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-html-5-2.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Raoul1996](https://github.com/Raoul1996), [吃土小2叉](https://github.com/xunge0613)

# HTML 5.2 有哪些新内容？

就在不到一个月前，HTML 5.2 正式成为了 W3C 的推荐标准（REC）。当一个规范到达 REC 阶段，就意味着它已经正式得到了 W3C 成员和理事长的认可。并且 W3C 将正式推荐浏览器厂商部署、web 开发者实现此规范。

在 REC 阶段有个原则叫做[“任何新事物都至少要有两种独立的实现”](https://www.slideshare.net/rachelandrew/where-does-css-come-from/27?src=clipshare)，这对于我们 web 开发者来说是一个实践新特性的绝佳机会。

在 HTML 5.2 中有一些添加和删除，具体改变可以参考官方的 [HTML 5.2 变动内容](https://www.w3.org/TR/html52/changes.html#changes)网页。本文将介绍一些我认为与我的开发有关的改动。

## 新特性

### 原生的 `<dialog>` 元素

在 HTML 5.2 的所有改动中，最让我激动的就是关于 [`<dialog>` 元素](https://www.w3.org/TR/html52/interactive-elements.html#elementdef-dialog)这个原生对话框的介绍。在 web 中，对话框比比皆是，但是它们的实现方式都各有不同。对话框很难实现可访问性，这导致大多数的对话框对那些不方便以视觉方式访问网页的用户来说都是不可用的。

新的 `<dialog>` 元素旨在改变这种状况，它提供了一种简单的方式来实现模态对话框。之后我会单独写一篇文章专门介绍这个元素的工作方式，在此先简单介绍一下。

由一个 `<dialog>` 元素创建对话框：

```
<dialog>  
  <h2>Dialog Title</h2>
  <p>Dialog content and other stuff will go here</p>
</dialog>  
```

默认情况下，对话框会在视图中（以及 DOM 访问中）隐藏，只有设置 open 属性后，对话框才会显示。

```
<dialog open>  
```

`open` 属性可以通过调用 `show()` 与 `close()` 方法开启或关闭，任何 `HTMLDialogElement` 都可以调用这两个方法。

```
<button id="open">Open Dialog</button>  
<button id="close">Close Dialog</button>

<dialog id="dialog">  
  <h2>Dialog Title</h2>
  <p>Dialog content and other stuff will go here</p>
</dialog>

<script>  
const dialog = document.getElementById("dialog");

document.getElementById("open").addEventListener("click", () => {  
  dialog.show();
});

document.getElementById("close").addEventListener("click", () => {  
  dialog.close();
});
</script>  
```

目前，Chrome 浏览器已经支持 `<dialog>` 元素，Firefox 也即将支持（behind a flag）。 

[![](https://bitsofco.de/content/images/2018/01/caniuse-dialog.png)](http://caniuse.com/#feat=dialog) 

上图为 caniuse.com 关于 dialog 特性主流浏览器兼容情况的数据

### 在 iFrame 中使用 Payment Request API（支付请求 API）

[Payment Request API](https://www.w3.org/TR/payment-request/) 是支付结算表单的原生替代方案。它将支付信息置于浏览器处理，用来代替之前各个网站各不相同的结算表单，旨在为用户提供一种标准、一致的支付方式。

在 HTML 5.2 之前，这种支付请求无法在文档嵌入的 iframe 中使用，导致第三方嵌入式支付解决方案（如 Stripe, Paystack）基本不可能使用这个 API，因为它们通常是在 iframe 中处理支付接口。

为此，HTML 5.2 引入了用于 iframe 的 `allowpaymentrequest` 属性，允许用户在宿主网页中访问 iframe 的 Payment Request API。

```
<iframe allowpaymentrequest>  
```

### 苹果的图标尺寸

如要定义网页图标，我们可以在文档的 head 中使用 `<link rel="icon">` 元素。如果要定义不同尺寸的图标，我们可以使用 `sizes` 属性。

```
<link rel="icon" sizes="16x16" href="path/to/icon16.png">  
<link rel="icon" sizes="32x32" href="path/to/icon32.png">  
```

这个属性虽然纯粹是个建议，但如果提供了多种尺寸的图标，可以让用户代理（UA）决定使用哪种尺寸的图标。在大多数设备有着不同的“最佳”图标尺寸时尤为重要。

在 HTML 5.2 之前，`sizes` 属性仅能用于 rel 为 `icon` 的 link 元素中。然而，苹果的 iOS 设备不支持 `sizes` 属性。为了解决这个问题，苹果自己引入了一个他们设备专用的 rel `appple-touch-icon` 用于定义他们设备上使用的图标。

在 HTML 5.2 中，规范定义了 `sizes` 属性**不再仅仅**可用于 rel 为 `icon` 的元素，也能用于 rel 为 `apple-touch-icon` 的元素。这样可以让我们为不同的苹果设备提供不同尺寸的图标。不过直到现在为止，据我所知苹果的设备还是不支持 `sizes` 属性。在将来苹果最终支持此规范时，它将派上用场。

## 新的有效实践

除了新特性之外，HTML 5.2 还将一些之前无效的 HTML 写法认定为有效。

### 多个 `<main>` 元素

`<main>` 元素代表网页的主要内容。虽然不同网页的重复内容可以放在 header、section 或者其它元素中，但 `<main>` 元素是为页面上的特定内容保留的。因此在 HTML 5.2 之前，`<main>` 元素在 DOM 中必须唯一才能令页面有效。

随着单页面应用（SPA）的普及，要坚持这个原则变得困难起来。在同一个网页的 DOM 中可能会有多个 `<main>` 元素，但在任意时刻只能给用户展示其中的一个。

使用 HTML 5.2，我们只要保证同一时刻只有一个 `<main>` 元素可见，就能在我们的标签中使用多个 `<main>` 元素。与此同时其它的 `<main>` 元素必须使用 `hidden` 属性进行隐藏。

```
<main>...</main>  
<main hidden>...</main>  
<main hidden>...</main>  
```

我们都知道，[通过 CSS 来隐藏元素的方法有很多](https://bitsofco.de/hiding-elements-with-css/)，但多余的 `<main>` 元素必须使用 `hidden` 属性进行隐藏。任何其它隐藏此元素的方法（如 `display: none;` 和 `visibility: hidden;`）都将无效。

### 在 `<body>` 中写样式

一般来说，使用`<style>`元素定义的内联 CSS 样式会放置在 HTML 文档的 `<head>` 中。随着组件化开发的流行，开发者已经发现编写 style 并放置在与其相关的 html 中更加有益。

在 HTML 5.2 中，可以在 HTML 文档 `<body>` 内的任何地方定义内联 `<style>` 样式块。这意味着样式定义可以离它们被使用的地方更近。

```
<body>  
    <p>I’m cornflowerblue!</p>
    <style>
        p { color: cornflowerblue; }
    </style>
    <p>I’m cornflowerblue!</p>
</body>  
```

然而仍需注意的是，**由于性能问题，样式还是应当优先考虑放在 `<head>` 中**。参见 [规范](https://www.w3.org/TR/html52/document-metadata.html#elementdef-style)，

> 样式元素最好用于文档的 head 中。在文档的 body 中使用样式可能导致重复定义样式，触发重布局、导致重绘，因此需要小心使用。

此外还应该注意的是如示例所示，样式不存在作用域。后来在 HTML 文档中定义的内联样式仍然会应用于之前定义的元素，所以它可能会触发重绘。

### `<legend>` 中的标题元素

在表单中，`<legend>` 元素表示 `<fieldset>` 表单域中的标题。在 HTML 5.2 前，legend 元素的内容必须为纯文本。而现在，它可以包含标题元素（ `<h1>` 等）了。

```
<fieldset>  
    <legend><h2>Basic Information</h2></legend>
    <!-- Form fields for basic information -->
</fieldset>  
<fieldset>  
    <legend><h2>Contact Information</h2></legend>
    <!-- Form fields for contact information -->
</fieldset>  
```

当我们想用 `fieldset` 对表单中不同部分进行分组时，这个特性非常有用。在这种情况下使用标题元素是有意义的，因为这能让那些依赖于文档大纲的用户可以轻松导航至表单的对应部分。

## 移除的特性

在 HTML 5.2 中移除了一些元素，具体为：

* `keygen`：曾经用于帮助表单生成公钥
* `menu` 与 `menuitem`：曾经用于创建导航与内容菜单

## 新的无效实践

最后，一些开发实践方式被规定不再有效。

### 在 `<p>` 中不再能包含行内、浮动、块类型的子元素

在 HTML 5.2 中，`<p>` 元素中唯一合法的子元素只能是文字内容。这也意味着以下类型的元素不再能嵌套于段落标签 `<p>` 内：

* 行内块（Inline blocks）
* 行内表格（Inline tables）
* 浮动块与固定位置块

### 不再支持严格文档类型（Strict Doctypes）

最后，我们终于可以和这些文档类型说再见了！

```
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">  
```

```
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">  
```


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


