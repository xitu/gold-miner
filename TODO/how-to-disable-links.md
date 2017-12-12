> * 原文地址：[How to Disable Links](https://css-tricks.com/how-to-disable-links/?utm_source=frontendfocus&utm_medium=email)
> * 原文作者：[GERARD COHEN](https://css-tricks.com/author/gerardkcohen/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-disable-links.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-disable-links.md)
> * 译者：[Usey95](https://github.com/usey95)
> * 校对者：[athena0304](https://github.com/athena0304) [LeopPro](https://github.com/LeopPro)

# 禁用连接：从入门到放弃

有一天，我在工作中产生了关于如何禁用链接的思考。不知为何，去年我无意添加了一个「disabled」锚点样式。但有一个问题：你无法在 HTML 中真正禁用 `<a>` 链接（拥有合法 `href` 属性）。更何况，你为什么要禁用它呢？链接是 Web 的基础。

某种意义上，我的同事看起来并不打算接受这个事实，所以我开始思考如何真正实现它。我知道这将付出很多努力，所以我想证明为了这种非传统的交互并不值得付出努力和代码。但我担心一旦被证明这是可以实现的，他们将无视我的警告继续做类似的尝试。这还没有动摇我，不过我觉得我们可以开始看我的研究了。

第一：

### 不要这样做。

一个被禁用的链接不能称作一个链接，它只是一段文本。如果需要禁用一个链接的话，你需要重新思考你的设计。

Bootstrap 有一个为锚点标签添加 `.disabled` 类的例子，我很讨厌这点。虽然他们至少提及了这个类只提供了一个禁用 **样式**，但这仍然是一种误导。如果你真的想禁用一个链接，你需要做更多的工作而不是只是让它 **看起来** 被禁用了。

### 万无一失的办法：移除 href 属性

如果你决定无视我的警告尝试禁用一个链接，那么 **移除 `href` 属性是我所知的最好的办法**。

官方解释 [Hyperlink spec](https://www.w3.org/TR/html5/links.html#attr-hyperlink-href)：

> `a` 和 `area` 元素的 `href` 属性不是必要的；当这些元素没有 `href` 属性时，它们将不会解释成超链接。

一个更易理解的定义 [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a)：

> 这个属性可以被忽略（从 HTML5 开始支持）以创建一个占位符链接。占位符链接类似传统的超链接，但它不会跳转到任何地方。

下面是用来设置和移除 `href` 属性的基本 JavaScript 代码：

```
/* 
 * 用你习惯的方式选择一个链接
 *
 * document.getElementById('MyLink');
 * document.querySelector('.link-class');
 * document.querySelector('[href="https://unfetteredthoughts.net"]');
 */
// 通过移除 href 属性来「禁用」一个链接。
link.href = '';
// 通过设置 href 属性启用链接
link.href = 'https://unfetteredthoughts.net';
```

为这些链接设置 CSS 样式同样非常简单：

```
a {
  /* 已禁用的链接样式 */
}
a:link, a:visited { /* or a[href] */
  /* 可访问的链接样式 */
}
```

**这就是你所要做的全部！**

### 这是不够的，我想要更复杂的东西让我看起来更聪明！

如果你不得不为了某些极端情况过度设计，这里有些事情需要考虑。希望你注意并且意识到我将为你展示的东西并不值得为之努力。

首先，我们需要为链接添加样式，让它看起来被禁用了。

```
.isDisabled {
  color: currentColor;
  cursor: not-allowed;
  opacity: 0.5;
  text-decoration: none;
}
```

```
<a class="isDisabled" href="https://unfetteredthoughts.net">Disabled Link</a>
```

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/disabled-link.gif)

把 `color` 设置成 `currentColor` 将把字体颜色重置为普通的非链接文本的颜色。同时把鼠标悬停设置为 `not-allowed`，这样鼠标悬停时就会显示禁用的标识。我们遗漏掉了那些不使用鼠标的用户，他们主要使用触摸和键盘，所以并不会得到这个指示。接下来，将透明度减至 0.5。根据 [WCAG](https://www.w3.org/WAI/WCAG20/quickref/#visual-audio-contrast-contrast)，禁用的元素不需要满足颜色对比指南。我认为这是很危险的，因为这基本上是纯文本，减少透明度至 0.5 将使视弱用户难以阅读，这是我讨厌禁用链接的另一个原因。最后，文本的下划线被移除了，因为它通常是一个链接的最佳标识。现在，这 **看起来** 是一个被禁用的链接了！

但它并没有被真正禁用！用户仍然可以点击、触摸这个链接。我听到你在尖叫 `pointer-events`。

```
.isDisabled {
  ...
  pointer-events: none;
}
```

现在，我们完成了所有工作！禁用一个链接已经大功告成！虽然这只是对鼠标用户和触屏用户 **真正地** 禁用了链接。那么对于不支持 `pointer-events` 的浏览器怎么办呢？根据 [caniuse](https://caniuse.com/#feat=pointer-events)，Opera Mini 以及 IE 11 以下版本都不支持这个属性。IE 11 以及 Edge 实际上也不支持 `pointer-events`，除非 `display` 设置成 `block` 或者 `inline-block`。而且，将 `pointer-events` 设置成 `none` 将覆盖我们 `not-allowed` 的指针样式，所以现在鼠标用户将不会得到这个额外的视觉指示，表明链接被禁用。这已经开始崩溃了。现在我们不得不更改我们的标记和 CSS。

```
.isDisabled {
  cursor: not-allowed;
  opacity: 0.5;
}
.isDisabled > a {
  color: currentColor;
  display: inline-block;  /* 为了 IE11/ MS Edge 的 bug */
  pointer-events: none;
  text-decoration: none;
}
```

```
<span class="isDisabled"><a href="https://unfetteredthoughts.net">Disabled Link</a></span>
```

将一个链接包裹在 `<span>` 标签中并添加 `isDisabled` 类给了我们一半禁用视觉样式。一个很好的效果是这个 `isDisabled` 类是通用的，可以用在其他元素上，例如按钮和表单元素。实际的锚点标签现在有设置为 `none` 的 `pointer-events` 和 `text-decoration` 属性。

那么键盘用户呢？键盘用户会使用回车键激活链接。`pointer-events` 只用于光标，没有键盘事件。我们还需要防止不支持 `pointer-events` 的旧浏览器激活链接，现在我们将介绍一些 JavaScript。

### 引入 JavaScript

```
// 在用常用方法获取链接之后
link.addEventListener('click', function (event) {
  if (this.parentElement.classList.contains('isDisabled')) {
    event.preventDefault();
  }
});
```

现在我们的链接 **看起来** 被禁用了而且不会响应点击、触摸以及回车键。但是我们还没完成！屏幕阅读器用户无法知道这个链接已经被禁用了。我们需要将这个链接描述为被禁用。`disabled` 属性在链接上不合法，但我们可以使用 `aria-disabled="true"`。

```
<span class="isDisabled"><a href="https://unfetteredthoughts.net" aria-disabled="true">Disabled Link</a></span>
```

现在我将利用这个机会根据 `aria-disabled` 属性设置链接样式。我喜欢使用 ARIA 属性作为 CSS 的钩子，因为拥有不正确的样式的元素可以表现出重要的可访问缺失。

```
.isDisabled {
  cursor: not-allowed;
  opacity: 0.5;
}
a[aria-disabled="true"] {
  color: currentColor;
  display: inline-block;  /* 为了 IE11/ MS Edge 的 bug */
  pointer-events: none;
  text-decoration: none;
}
```

现在我们的链接 **看起来** 被禁用, **表现起来** 被禁用, 而且被 **描述** 成被禁用.

不幸的是，即便链接被描述成被禁用，一些屏幕阅读器（JAWS）仍将宣称这些链接是可点击的。任何一个有点击事件监听器的元素都是这样。这是因为开发者倾向于将非交互元素如 `div` 和 `span` 添加事件监听器从而当做伪交互元素使用。对此我们无能为力。我们为了去除一个链接的所有特征所做的努力都被我们想要愚弄的辅助技术所挫败，讽刺的是，我们之前就想骗过它了。

不过，如果我们将监听器移动到 body 呢？

```
document.body.addEventListener('click', function (event) {
  // 过滤掉其他元素的点击事件
  if (event.target.nodeName == 'A' && event.target.getAttribute('aria-disabled') == 'true') {
    event.preventDefault();
  }
});
```

我们完成了吗？其实并没有。有的时候我们需要启用这些链接，所以我们需要添加额外的代码来切换这些状态或行为。

```
function disableLink(link) {
// 1\. 为父级 span 添加 isDisabled　类
  link.parentElement.classList.add('isDisabled');
// 2\. 保存 href 以便以后添加
  link.setAttribute('data-href', link.href);
// 3\. 移除 href
  link.href = '';
// 4\. 设置 aria-disabled 为 'true'
  link.setAttribute('aria-disabled', 'true');
}
function enableLink(link) {
// 1\. 将父级 span 的 'isDisabled' 类移除
  link.parentElement.classList.remove('isDisabled');
// 2\. 设置 href
  link.href = link.getAttribute('data-href');
// 3\. 移除 'aria-disabled' 属性，比将其设为 false 更好
  link.removeAttribute('aria-disabled');
}
```

就是这样。我们现在从视觉上、功能上以及语义上为所有的用户禁用了链接。它只用了 10 行 CSS，15 行 JavaScript（包括 body 上的一个监听器）以及 2 个 HTML 元素。

说真的，**不要做这样的尝试。**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
