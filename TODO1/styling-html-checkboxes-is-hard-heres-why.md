> * 原文地址：[Styling HTML checkboxes is hard - here's why](https://areknawo.com/styling-html-checkboxes-is-hard-heres-why/)
> * 原文作者：[Areknawo](https://areknawo.com/author/areknawo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/styling-html-checkboxes-is-hard-heres-why.md](https://github.com/xitu/gold-miner/blob/master/TODO1/styling-html-checkboxes-is-hard-heres-why.md)
> * 译者：[jilanlan](https://github.com/jilanlan)
> * 校对者：[shixi-li](https://github.com/shixi-li), [Baddyo](https://github.com/Baddyo)

# 为什么 HTML 中复选框样式难写 —— 本文给你答案

![](https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjExNzczfQ)

在当今世界，大多数网页开发者认为掌握 **JavaScript** 是优先选择，这理所当然，因为 JS 是**浏览器脚本语言**。虽然 HTML 和 CSS 决定网站的样式，但是 JS 凭借它能调用 HTML 和 CSS API，优良性能以及它的多功能性，深受网页开发者喜爱。像 React、Vue、和 Angular 等第三方**库**或框架，还有像 **CSS-in-JS** 等旨在简化样式编写的解决方案，都证实了前面所说的趋势。

遗憾的是，万物皆有双面刃。一些包括我在内的网页开发者们，直接就上手使用例如 React 等第三方框架，而不是先**学习 HTML**。更有甚者，我们越来越依赖于使用 **UI 组件库**，因为它完美地封装了所有我们所需要的功能。当然，这些库或者框架的本质是好的，它们遵循了 DRY 规则，开发者们没必要什么都自己写。但是，从我个人经验来讲，过多地依赖框架会让我们忽略 HTML 的一些要点的存在。

## HTML 表单元素

下面回归正题。最近，我开始着手独立创建一个组件库。为了不吸取太多灵感（复制 —— 粘贴），我决定不使用任何基于框架的组件库，并且开始尝试实现一些**纯 CSS** 的东西。在这过程中我注意到，表单相关组件之间是如何独立开的，并且一些组件库其实并没有真正地改变**复选框**的样式。至此，一些 HTML 专家可能就一带而过，但我后来意识到，给复选框添加样式的难度超乎任何人想象，这完全令人意想不到。

原因在于它的存在方式，HTML 本质不是一门真正的表达性语言。例如复选框、单选按钮和开关等**表单元素**，由于它们的动态本质，很难与其他 HTML 元素适应。尤其是在尝试给表单元素添加样式时。尽管网上有关于给表单元素添加样式的教程，但在这篇文章中，我们将通过两种方式**一步步**地（而不是直接将代码扔你面前）改变复选框的样式，一种是**纯 CSS** 实现，另一种比较简单 —— 借助 **JavaScript** 来实现。

## 纯 CSS 方式

### 基础

我们只要使用一些 CSS 代码和 `:checked` 伪类就可以在现代浏览器上控制复选框的样式了。如果你想深入定制（像自定义图标），或者想支持老版本浏览器，那实现起来就变得复杂了。在本篇文章中，我们将隐藏原生复选框，**自己创建复选框**，它比原生更加美观，同时还能监听原生复选框事件。下面让我们先从完整的 HTML 代码开始吧。

```html
<label class="checkbox">
  <input type="checkbox"/>
  <span class="overlay">
      <svg class="icon"/>
  </span>
</label>  
```

上面的代码是将原生复选框和用来覆盖原生复选框的行内元素（`<span/>` 标签）包裹在一个元素之中。同时还创建了 **SVG 复选框图标**供后面使用。现在我们开始写 CSS 样式吧！

### 隐藏原生复选框

```css
.checkbox input {
    position: absolute;
    opacity: 0;
}
```

上面代码是通过设置 `opacity` 为 `0` 来隐藏原生复选框元素。这里如果使用其他方法，例如设置 `display` 为 `none` 或者 `visibility` 为 `hidden` 都是不行的，因为这些方法会使复选框的部分（或者所有）事件无效，但在这篇文章中，复选框事件有效是必要条件。

### 未选中状态

至此，我们只需要设置覆盖元素的样式来控制选中或者未选中的状态。

```css
.checkbox .overlay {
  position: absolute;
  top: 0px;
  left: 0px;
  height: 24px;
  width: 24px;
  background-color: transparent;
  border-radius: 8px;
  border: 2px solid #F39C12;
  transform: rotate(-90deg);
  transition: all 0.3s;
}

.checkbox .overlay .icon {
  color: white;
  display: none;
}
```

首先，我们来设置未选中状态的复选框样式。上面的 CSS 样式很具有装饰性，其实就是让表单元素看上去更酷罢了。例如，我们悄悄地增加了一些动画和过渡效果（使用老版本浏览器记得加前缀），这至少让我们的复选框变得更**动态**化。但是我们明显的感受到，在图标上设置的 `display: none` 才是重点。这里我们完全可以通过设置 `display` 属性来隐藏图标，因为我们不需要监听图标的事件。

## SVG 图标

SVG 图标本身就是一种图标。这里我们将使用简洁圆滑的复选框**矢量图标**，这图标可以直接从名叫 **[Feather](https://feathericons.com/)** 的图标库下载。Feather 是一套采用 MIT 开源协议的图标库。下面是 SVG 图标的完整代码展示：

```html
<svg xmlns="http://www.w3.org/2000/svg"
    width="24"
    height="24"
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    stroke-width="2"
    stroke-linecap="round"
    stroke-linejoin="round"
    class="icon">
        <polyline points="20 6 9 17 4 12"/>
</svg>
```

### 选中状态

最后设置复选框选中状态样式：

```css
.checkbox input:checked ~ .overlay {
  background-color: #F39C12;
  border-radius: 8px;
  transform: rotate(0deg);
  opacity: 1;
  border: 2px solid #F39C12;
}

.checkbox input:checked ~ .overlay .icon {
  display: block;
}
```

上面代码充分利用了 CSS 的 `~` 选择器，能够把样式应用到每个紧随着指定元素的那些元素。下一步，我们让复选框图标可见，并且旋转复选框到它原始位置。完整代码可以在下方的 CodePen 中查看。

在 [CodePen](https://codepen.io) 中查看来自 Arek Nawo（[@areknawo](https://codepen.io/areknawo)）的 [CSS 复选框](https://codepen.io/areknawo/pen/GaRLYm/) 代码示例。

## JS 方式

### 为什么？

此时，这里有些地方要注意了。在有些例子中，复选框图标是通过**旋转矩形**结合小边框和 CSS 伪类实现的，而不是利用 SVG 图标。本文前面就是使用 SVG 图标的方法，因为它能支持更多的个性化设置（例如圆角），并且上手也简单。然后，我们只是设置了一些小旋转和颜色变换动画，如果你想更进一步，我推荐尝试 `stroke-dasharray`、`stroke-dashoffset` 和一些 **keyframe 动画**，这能让你的 SVG 图标显得流畅。但是，你要知道，你往复选框上加的特性越多，你的 CSS 代码也会随即变的越来越**臃肿**。当然，CSS 的计算能力很强，但是和 JS 比起来还是存在一些差距，特别是在一些现代设备中表现得尤为明显。也就是说，如果你想真正展示你的创造力，可能就需要借助 JS。

### 设置

在没有纯 CSS 的限制的情况下，我们没必要对选择器做太多工作。我们将保留上面写的 HTML 代码结构，在 **JS 代码**中获取到所有需要的元素。

```
const checkboxes = document.querySelectorAll(".checkbox");
checkboxes.forEach(checkbox => {
  const input = checkbox.children[0];
  const overlay = checkbox.children[1];
  const icon = overlay.children[0];
});
```

我们可以通过 JS 拿到所有存在的复选框元素，但是切记，在**生产环境**最好不要用上面这种方式。相反，如果在项目中使用例如 React 这样**基于组件的库**，你就要把你的复选框封装成一个组件，使用例如先进的**动画库**来保持项目正常运转。但我这里只是做一个简单的例子，没必要去用这么大的第三方库。让我们继续使用基础的 JavaScript 就好。

### CSS 调整

```css
.checkbox input {
  position: absolute;
  opacity: 0;
}

.checkbox .overlay {
  position: absolute;
  top: 0px;
  left: 0px;
  height: 24px;
  width: 24px;
  background-color: #F39C12;
  border-radius: 8px;
  border: 2px solid #F39C12;
}

.checkbox .overlay .icon {
  color: white;
}

.checkbox .overlay.checked {
  border-radius: 8px;
  opacity: 1;
  border: 2px solid #F39C12;
}
```

上面就是我们的 CSS 代码，我觉得这样的 CSS 代码很 **“平整”**。上面代码中我们做了以下调整：去掉了 `~` 选择器，目的是简化 CSS 子类 `checked`，调整了一些别的样式，包括选中状态的图标的样式，目的是准备实现的 **JS 动画**。

这样的方式自然有它的好处。CSS **结构**就是主要好处之一。如此**平整**的 CSS，没有半点复杂的选择器，更容易在各种 **CSS-in-JS** 库中实现，并且众所周知，这方法还能够让我们的 CSS 代码更加**易读易管理**。

```javascript
// ...
input.addEventListener("change", () => {
    if (input.checked) {
        overlay.classList.add("checked");
        icon.classList.add("checked");
    } else {
        overlay.classList.remove("checked");
        icon.classList.remove("checked");
    }
});
// ...
```

### 事件侦听器

通过 JS，不论何时发生何种变化，我们都能监听到 `change` 事件，这是大部分表单元素都支持的。然后，借助每个 `type='checked'` 的 input 元素都有的 `checkbox` 属性，来决定是否应该添加或者移除我们的样式类。附注一点，所有**现代浏览器**包括 IE 10 在内，都支持[基本形式的 `classList`](https://caniuse.com/#feat=classlist) 属性。

最后，我们借助 JS 让 SVG 图标的交互效果显得流畅，就像一个完好的复选框图标。这个部分代码有很多调整，你可以在下方 CodePen 中查看完整代码。

在 [CodePen](https://codepen.io) 中查看来自 Arek Nawo（[@areknawo](https://codepen.io/areknawo)）的 [JS 复选框](https://codepen.io/areknawo/pen/BeyLeJ/)代码示例。

## 你喜欢这篇文章吗？

嗯，总之，我希望这份**快速上手指南**能够帮助你了解更多关于复选框元素和 HTML 的知识。还有很多知识等我们去发掘，特别是在不提及任何类型的第三方库的时候。我希望你们能喜欢这篇短小精悍的文章。如果你想**看更多**关于这方面内容的博客，请在下方**评论区评论**告诉我。如果你想**分享这篇文章**，请关注我的 [**Twitter**](https://twitter.com/areknawo)、**[我的 Facebook 主页](https://www.facebook.com/areknawoblog)**，并注册 **weekly newsletter**。非常感谢你们能够通读这篇文章，我们**下篇文章**见！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
