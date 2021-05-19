> * 原文地址：[Custom State Pseudo-Classes in Chrome](https://css-tricks.com/custom-state-pseudo-classes-in-chrome/)
> * 原文作者：[Šime Vidas](https://css-tricks.com/author/simevidas/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/custom-state-pseudo-classes-in-chrome.md](https://github.com/xitu/gold-miner/blob/master/article/2021/custom-state-pseudo-classes-in-chrome.md)
> * 译者：
> * 校对者：

# Custom State Pseudo-Classes in Chrome

There is an increasing number of “custom” features on the web platform. We have custom properties (`--my-property`), custom elements (`<my-element>`), and custom events (`new CustomEvent('myEvent')`). At one point, we might even get [custom media queries](https://css-tricks.com/platform-news-defaulting-to-logical-css-fugu-apis-custom-media-queries-and-wordpress-vs-italics/#still-no-progress-on-css-custom-media-queries) (`@media (--my-media)`).

But that’s not all! You might have missed it because it wasn’t mentioned in Google’s [“New in Chrome 90”](https://developer.chrome.com/blog/new-in-chrome-90/) article (to be fair, [declarative shadow DOM](https://css-tricks.com/platform-news-using-focus-visible-bbcs-new-typeface-declarative-shadow-doms-a11y-and-placeholders/#declarative-shadow-dom-could-help-popularize-style-encapsulation) stole the show in this release), but Chrome just added support for yet another “custom” feature: custom state pseudo-classes (`:--my-state`).

### Built-in states

Before talking about custom states, let’s take a quick look at the built-in states that are defined for built-in HTML elements. The [CSS Selectors module](https://drafts.csswg.org/selectors/) and the [“Pseudo-classes” section](https://html.spec.whatwg.org/multipage/semantics-other.html#pseudo-classes) of the HTML Standard specify a number of pseudo-classes that can be used to match elements in different states. The following pseudo-classes are all widely supported in today’s browsers:

#### User action

| Type | Description |
| --- | --- |
| `:hover` | the mouse cursor hovers over the element |
| `:active` | the element is being activated by the user |
| `:focus` | the element has the focus |
| `:focus-within` | the element has or contains the focus |

#### Location

| Type | Description |
| --- | --- |
| `:visited` | the link has been visited by the user |
| `:target` | the element is targeted by the page URL’s fragment |

#### Input

| Type | Description |
| --- | --- |
| `:disabled` | the form element is disabled |
| `:placeholder-shown` | the input element is showing placeholder text |
| `:checked` | the checkbox or radio button is selected |
| `:invalid` | the form element’s value is invalid |
| `:out-of-range` | the input element’s value is [outside the specificed range](https://twitter.com/mgechev/status/1384726124522098688) |
| `:-webkit-autofill` | the input element has been autofilled by the browser |

#### Other

| Type | Description |
| --- | --- |
| `:defined` | the custom element has been registered |

> **Note:** For brevity, some pseudo-classes have been omitted, and some descriptions don’t mention every possible use-case.

### Custom states

Like built-in elements, custom elements can have different states. A web page that uses a custom element may want to style these states. The custom element could expose its states via CSS classes (`class` attribute) on its host element, but that’s [considered an anti-pattern](https://github.com/WICG/webcomponents/issues/738#issuecomment-367499244).

Chrome now supports an API for adding internal states to custom elements. These custom states are exposed to the outer page via custom state pseudo-classes. For example, a page that uses a `<live-score>` element can declare styles for that element’s custom `--loading` state.

```css
live-score {
  /* default styles for this element */
}

live-score:--loading {
  /* styles for when new content is loading */
}
```

### Let’s add a `--checked` state to a `<labeled-checkbox>` element

The [Custom State Pseudo Class](https://wicg.github.io/custom-state-pseudo-class/) specification contains a complete code example, which I will use to explain the API. The JavaScript portion of this feature is located in the custom element‘s class definition. In the constructor, an “[element internals](https://html.spec.whatwg.org/multipage/custom-elements.html#element-internals)” object is created for the custom element. Then, custom states can be set and unset on the internal `states` object.

Note that the `[ElementInternals](https://html.spec.whatwg.org/multipage/custom-elements.html#element-internals)` API ensures that the custom states are [read-only](https://github.com/w3ctag/design-reviews/issues/428#issuecomment-566103510) to the outside. In other words, the outer page cannot modify the custom element’s internal states.

```javascript
class LabeledCheckbox extends HTMLElement {
  constructor() {
    super();

    // 1. instantiate the element’s “internals”
    this._internals = this.attachInternals();

    // (other code)
  }

  // 2. toggle a custom state
  set checked(flag) {
    if (flag) {
      this._internals.states.add("--checked");
    } else {
      this._internals.states.delete("--checked");
    }
  }

  // (other code)
}
```

The web page can now style the custom element’s internal states via custom pseudo-classes of the same name. In our example, the `--checked` state is exposed via the `:--checked` pseudo-class.

```css
labeled-checkbox {
  /* styles for the default state */
}

labeled-checkbox:--checked {
  /* styles for the --checked state */
}
```

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/custom-state-pseudo-classes-in-chrome-custom-state-pseudo-class.gif?raw=true)

[Try the demo in Chrome](https://codepen.io/simevidas/pen/ZELwEBy)

### This feature is not (yet) a standard

Browser vendors have been debating for the [past three years](https://github.com/WICG/webcomponents/issues/738) how to expose the internal states of custom elements via custom pseudo-classes. Google’s [Custom State Pseudo Class](https://wicg.github.io/custom-state-pseudo-class/) specification remains an “unofficial draft” hosted by WICG. The feature [underwent a design review](https://github.com/w3ctag/design-reviews/issues/428) at the W3C TAG and has been [handed over to the CSS Working Group](https://github.com/w3c/csswg-drafts/issues/4805). In Chrome’s ”intent to ship” discussion, [Mounir Lamouri wrote this](https://groups.google.com/a/chromium.org/g/blink-dev/c/dJibhmzE73o/m/VT-NceIhAAAJ):

> It looks like this feature has good support. It sounds that it may be hard for web developers to benefit from it as long as it’s not widely shipped, but hopefully Firefox and Safari will follow and implement it too. Someone has to implement it first, and given that there are no foreseeable backward incompatible changes, it sounds safe to go first.

We now have to wait for the implementations in Firefox and Safari. The browser bugs have been filed ([Mozilla #1588763](https://bugzilla.mozilla.org/show_bug.cgi?id=1588763) and [WebKit #215911](https://bugs.webkit.org/show_bug.cgi?id=215911)) but have not received much attention yet.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
