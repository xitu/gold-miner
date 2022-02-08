> * 原文地址：[Custom State Pseudo-Classes in Chrome](https://css-tricks.com/custom-state-pseudo-classes-in-chrome/)
> * 原文作者：[Šime Vidas](https://css-tricks.com/author/simevidas/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/custom-state-pseudo-classes-in-chrome.md](https://github.com/xitu/gold-miner/blob/master/article/2021/custom-state-pseudo-classes-in-chrome.md)
> * 译者：[acev](https://github.com/acev-online)
> * 校对者：[darkyzhou](https://github.com/darkyzhou)、[Chor](https://github.com/Chorer)、[Kim Yang](https://github.com/KimYangOfCat)

# Chrome 浏览器的自定义状态伪类

Web 平台上的“自定义”功能越来越多，比如自定义属性（`--my-property`）、自定义元素（`<my-element>`）和自定义事件（`new CustomEvent('myEvent')`）。我们一度甚至还能使用[自定义媒体查询](https://css-tricks.com/platform-news-defaulting-to-logical-css-fugu-apis-custom-media-queries-and-wordpress-vs-italics/#still-no-progress-on-css-custom-media-queries) (`@media (--my-media)`)。

但那还没完！有个新的“自定义”功能你可能错过了，因为这篇 Google 发布的 [“New in Chrome 90”](https://developer.chrome.com/blog/new-in-chrome-90/) 文章中并没有提到（公平地说，[声明性（declarative） shadow DOM](https://css-tricks.com/platform-news-using-focus-visible-bbcs-new-typeface-declarative-shadow-doms-a11y-and-placeholders/#declarative-shadow-dom-could-help-popularize-style-encapsulation) 在这次发布中占尽了风头），但是 Chrome 刚刚增加了对另一个“自定义”功能的支持：自定义状态伪类（`:--my-state`）。

## 内置状态

在讨论自定义状态之前，我们先快速查看下内置 HTML 元素定义的内置状态。HTML 标准的 [CSS 选择器模块](https://drafts.csswg.org/selectors/)和[“伪类”章节](https://html.spec.whatwg.org/multipage/semantics-other.html#pseudo-classes)指定了许多可以用于匹配不同状态元素的伪类。下面提到的所有伪类都在当今的浏览器中得到了广泛的支持：

### 用户操作

| 类型 | 描述 |
| --- | --- |
| `:hover` | 鼠标光标悬停在元素上 |
| `:active` | 该元素被用户激活 |
| `:focus` | 该元素获得焦点 |
| `:focus-within` | 该元素或者后代元素获得焦点 |

### 定位

| 类型 | 描述 |
| --- | --- |
| `:visited` | 该链接之前被用户访问过 |
| `:target` | 该元素被页面的 URL 片段指定 |

### 输入

| 类型 | 描述 |
| --- | --- |
| `:disabled` | 表单元素被禁用 |
| `:placeholder-shown` | input 元素正在展示 placeholder 文本 |
| `:checked` | 复选框或单选按钮被选中 |
| `:invalid` | 表单元素的值不合法 |
| `:out-of-range` | input 元素的值[超出指定范围](https://twitter.com/mgechev/status/1384726124522098688) |
| `:-webkit-autofill` | input 元素的值被浏览器自动填充  |

### 其他状态

| 类型 | 描述 |
| --- | --- |
| `:defined` | 该自定义元素已被注册 |

> **注：** 为简洁起见，有些伪类被省略了，并且有些伪类的描述没有包括所有可能的用例。

## 自定义状态

与内置元素类似，自定义元素也可以有不同的状态。使用自定义元素的网页可能想给这些状态设置不同的样式。自定义元素可以通过它的宿主元素的 CSS 类（`class` 属性）来暴露状态，但[这被认为是一种反模式](https://github.com/WICG/webcomponents/issues/738#issuecomment-367499244)。

Chrome 现在支持将内部状态添加到自定义元素的 API。这些状态通过自定义状态伪类暴露出来。例如：使用 `<live-score>` 元素的页面可以给这个元素自定义的 `--loading` 状态声明样式。

```css
live-score {
  /* 元素的默认样式 */
}

live-score:--loading {
  /* 新内容加载时的样式 */
}
```

## 让我们给 `<labeled-checkbox>` 元素添加 `--checked` 状态

[自定义状态伪类](https://wicg.github.io/custom-state-pseudo-class/)规范包含一个完整的代码示例。我将用这个示例解释 API。此功能的 JavaScript 部分位于自定义元素的类定义中。在构造函数中，为自定义元素创建“[元素内部](https://html.spec.whatwg.org/multipage/custom-elements.html#element-internals)”对象，之后可以在 `states` 内部对象上设置或取消设置自定义状态。

请注意 [`ElementInternals`](https://html.spec.whatwg.org/multipage/custom-elements.html#element-internals) API 可确保自定义状态在元素外部[只读](https://github.com/w3ctag/design-reviews/issues/428#issuecomment-566103510)。换句话说，元素外部不能修改自定义元素的内部状态。

```javascript
class LabeledCheckbox extends HTMLElement {
  constructor() {
    super();

    // 1. 创建“元素内部”对象
    this._internals = this.attachInternals();

    // （其他代码）
  }

  // 2. 设置自定义状态
  set checked(flag) {
    if (flag) {
      this._internals.states.add("--checked");
    } else {
      this._internals.states.delete("--checked");
    }
  }

  // （其他代码）
}
```

网页现在可以通过同名的自定义伪类来给自定义元素的内部状态设置样式。在我们的例子中，`--checked` 状态以 `:--checked` 伪类的形式暴露出来。

```css
labeled-checkbox {
  /* 默认状态下的样式 */
}

labeled-checkbox:--checked {
  /* --checked 状态下的样式 */
}
```

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/custom-state-pseudo-classes-in-chrome-custom-state-pseudo-class.gif?raw=true)

[用 Chrome 浏览器打开这个 demo](https://codepen.io/simevidas/pen/ZELwEBy)

## 此功能尚未成为标准

[过去三年来](https://github.com/WICG/webcomponents/issues/738)，浏览器厂商一直在讨论如何通过自定义伪类来暴露自定义元素的内部状态。Google 的[自定义状态伪类](https://wicg.github.io/custom-state-pseudo-class/)规范目前托管在 WICG 名下，仍然处于一个非官方的状态。该功能由 W3C 技术架构组（TAG）[进行设计审查](https://github.com/w3ctag/design-reviews/issues/428)并[移交给 CSS 工作组](https://github.com/w3c/csswg-drafts/issues/4805)。在 Chrome 的“出货意向”讨论中，[Mounir Lamouri 写道](https://groups.google.com/a/chromium.org/g/blink-dev/c/dJibhmzE73o/m/VT-NceIhAAAJ)：

> 此功能看起来得到了许多支持它的声音，但是只要它没有被各大浏览器支持，Web 开发者可能都难以从此功能中获益。希望 Firefox 和 Safari 能够跟进并实现此功能。总得有厂商带头实现这个功能。而且，鉴于这个功能不存在可预见的一些向后不兼容的改变，要带这个头看上去挺安全的。

我们现在需要等待 Firefox 和 Safari 浏览器实现这个功能。对应的补丁已经以文件形式提交到 [Mozilla #1588763](https://bugzilla.mozilla.org/show_bug.cgi?id=1588763) 和 [WebKit #215911](https://bugs.webkit.org/show_bug.cgi?id=215911)，但还没有得到太多关注。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
