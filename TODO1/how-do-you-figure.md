> * 原文地址：[How do you figure?](https://www.scottohara.me/blog/2019/01/21/how-do-you-figure.html)
> * 原文作者：[scottohara](https://www.scottohara.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-do-you-figure.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-do-you-figure.md)
> * 译者：
> * 校对者：

# How do you figure?

Introduced as part of HTML5, the `figure` and `figcaption` elements are meant to create a meaningful markup structure that:

*   provides a descriptive label to a piece of content that…
*   is relevant to the current document, but not vital to its understanding.

To get more specific, let’s look at these elements individually.

## The `figure` element

Often thought of containing images or diagrams, the `figure` element can host any content (code snippets, quotes, audio, video, etc.) that is referred to from the primary content of the document, but is not redundant information. A `figure` should be able to be completely removed from the flow of a document without any detriment to the understanding of the primary content.

For example, a document outlining the airspeed velocity of an unladen Swallow may have a section explaining the differences between a South African Swallow vs the European Swallow. Accompanying this content could be a `figure` showcasing a side by side comparison of these birds, so as to compliment the information the document outlines.

![screen shot of an article using an image, offset from the primary content, to indicate the visual differences between a South African and European Swallow. Text in the image notes the South African Swallow is on the left, and the European Swallow is on the right.](https://scottohara.me/assets/img/articles/swallow-figure.jpg)

This meta example of a figure and caption works in reference to the content that preceded it. If I didn't include it, all the information up to that point would still have described the purpose of a `figure`.

[Image source (2003)](http://style.org/unladenswallow/).

A `figure` can be used with or without a `figcaption`. However, without a caption, or an alternate means of providing an accessible name (e.g. `aria-label`) a `figure` may not provide much value in conveying its semantics alone. In some cases, it may not convey any semantics at all if its given no accessible name.

## The `figcaption` element

A `figcaption` provides a caption, or summary, to the content the `figure` contains. The `figcaption` should become the accessible name to the `figure` element, unless an `aria-label` or `aria-labelledby` attribute are used on the `figure` instead.

The `figcaption` may be placed before or after the primary contents of the `figure`, however it must be a direct child of the `figure` element.

Allowed patterns:

```
<figure>
  <figcaption>...</figcaption>
  <!-- contents of the figure -->
</figure>

<figure>
  <!-- contents of the figure -->
  <figcaption>...</figcaption>
</figure>

<figure>
  <figcaption>
    <div>
      ...
    </div>
  </figcaption>
  <!-- contents of the figure -->
</figure>
```

Not allowed patterns:

```
<figure>
  <div>
    <figcaption>...</figcaption>
  </div>
  <!-- contents of the figure -->
</figure>

<figure>
  <!-- contents of the figure -->
  <div>
    <figcaption>...</figcaption>
  </div>
</figure>
```

A `figcaption` may contain [flow content](https://html.spec.whatwg.org/multipage/dom.html#flow-content-2), which categorizes most elements allowed as children of the `body` element. But, as the element is meant to provide a caption to the `figure`’s contents, brevity and concise descriptive text are typically preferable. The `figcaption` should not repeat the content of the `figure`, or other content within the primary document.

### A `figcaption` is not a substitute for `alt` text

Regarding images used within figures, one of the biggest misunderstandings of using a `figcaption` is that it’s used in place of image alternative text. Such a practice is outlined in [HTML 5.2](https://www.w3.org/TR/html52/semantics-embedded-content.html#when-a-text-alternative-is-not-available-at-the-time-of-publication) as being a last ditch effort to convey meaningful information, but only when images are published without an author being able to provide appropriate `alt` text.

From the guidance of HTML 5.2:

> Such cases are to be kept to an absolute minimum. If there is even the slightest possibility of the author having the ability to provide real alternative text, then it would not be acceptable to omit the `alt` attribute.

A `figcaption` is meant to provide a caption or summary to a figure, relating it back to the document the figure is contained within, or conveying additional information that may not be directly apparent from reviewing the figure itself.

If an image is given an empty `alt`, then the `figcaption` is in effect describing nothing. And that doesn’t make much sense, does it?

To put it another way, let’s look at a `figure` that contains a Sass code snippet:

```
<figure>
  <pre><code>
    $align-list: center, left, right;

    @each $align in $align-list {
      .txt-#{$align} {
        text-align: $align;
      }
    }
  </code></pre>
  <figcaption>
    This use of Sass's @each control directive will compile to 
    three CSS classes; .txt-center, .txt-left, and .txt-right.
  </figcaption>
</figure>
```

In comparison to images with empty `alt`s within figures, it’d be like putting an `aria-hidden="true"` on the code snippet. Doing so would remove the ability for screen readers and other assistive technology to parse the content the caption refers to. However, it’s unfortunately a reflection of what commonly happens with images in figures.

“But shouldn’t it be obvious that the caption is meant to be the `alt` text for the image?”, you may think. There are two issues with that assumption:

**First**, what image? When an image has an empty `alt` it won’t be announced, nor will it be discoverable when navigating with a screen reader. If an `alt` was left off the image, _some_ screen readers would announce the file name of the image, but not all (screen readers, like JAWS, have settings to adjust this behavior. but the default behavior is for images like these to be ignored).

**Second**, an `alt` is meant to convey the important information an image represents. A `figcaption` should provide context to relate the figure (image) back to the primary document, or to call out a particular piece of information to pay attention to. If a `figcaption` takes the place of an `alt`, then this creates duplicate information for sighted users.

There are other issues with incorrect use of a `figcaption` in place of an image `alt`. But to identify those issues, we need to understand how screen readers parse `figure`s.

## `figure`s and screen readers

Now that we have an idea of how figures and their captions should be used, how do these elements get exposed to screen readers?

Ideally a `figure` should announce its role and the content of the `figcaption` as its accessible name. A person should then be able to navigate into the `figure` and interact with the contents of the `figure` and `figcaption` independently. For browsers that don’t fully support `figure`s, like Internet Explorer 11, [ARIA’s `role="figure"`](https://www.w3.org/TR/wai-aria-1.1/#figure) and an `aria-label` can be used to help increase the likelihood the markup will be recognized by certain screen readers.

Here is a roundup of how tested screen readers, with default settings, expose this information (or don’t) in different browsers:

### JAWS 18, 2018, and 2019

JAWS has the best support for announcing native figures and their captions, though support is not perfect or consistent depending on the browser and JAWS’s verbosity settings.

IE11 requires the use of `role="figure"` and an `aria-label` or `aria-labelledby` pointing to the `figcaption` to mimic native announcements. It’s not surprising that IE11 doesn’t support the native element, as [HTML5 Accessibility’s IE11 browser rating](https://www.html5accessibility.com/) will never improve. But at least ARIA can provide the semantics.

Edge won’t announce the presence of a figure role at all, regardless if ARIA is used or not. This will likely change once [Edge switches over to Chromium](https://www.windowscentral.com/faq-edge-chromium).

Chrome and Firefox offer similar support, however JAWS (with default verbosity settings) + Chrome will **completely ignore** a `figure` (including the content of its `figcaption`) if an image has an empty `alt` or is lacking an `alt` attribute.

This means that those captions that accompany images [in various Medium articles](https://twitter.com/aardrian/status/923536098734891009), those are all completely ignored by JAWS paired with Chrome. If JAWS settings are updated to announce all images (e.g. images where an `alt` attribute or value is not provided) then JAWS should announce these figure captions with Chrome.

Unlike with Chrome, JAWS paired with Firefox **will still announce** the `figure` and `figcaption` if an image has an empty or missing `alt`, but as the image will be completely ignored, the person using the screen reader will just have to infer that the primary content of the figure was an image.

### NVDA

Testing NVDA version 2018.4.1 with IE11, Edge, Firefox 64.0.2 and Chrome 71, there was no trace of figures. The closest indication that something might be there was NVDA + IE11 announcing “edit” prior to the announcement of an image or contents of a `figcaption` (not that “edit” made any sense though…). Testing patterns with `role="figure"` did not change the lack of announcements. The contents of figures are still accessible, but no relationship of content and caption will be conveyed.

### VoiceOver (macOS)

Testing was performed with Safari (12.0.2) and Chrome (71.0.3578.98) on macOS 10.14.2, with VoiceOver 9.

#### Safari

When testing with Safari, a `figure` will have it’s role announced. A `figure`’s role will not be announced if it has no accessible name (e.g. no `figcaption`, `aria-label`, etc.).

VoiceOver can navigate into the `figure` and interact with the primary content of the `figure` and `figcaption` individually.

#### Chrome

Though Chrome’s accessibility inspector notes that the semantics of the `figure` is being revealed, and that the accessible name is provided by its caption, VoiceOver does not locate or announce the presence of the `figure` as it does with Safari. That is unless the `figure` specifically has an `aria-label`. Using an `aria-describedby` or `aria-labelledby` on the `figure` to point to the `figcaption` does **not** expose the `figure` to VoiceOver. To properly convey figures to VoiceOver, with Chrome, the following markup would be necessary:

```
<!-- 
  aria-label would need to repeat the content of the figcaption 
  to announce the figure as expected. 
-->
<figure aria-label="Figcaption content here.">
  <!-- figure content -->
  <figcaption>
    Figcaption content here.
  </figcaption>
</figure>
```

Adding a `role="figure"` to the `figure` element, or another element in place of a `<figure>`, will still require an `aria-label` to make the role discoverable to VoiceOver with Chrome.

### VoiceOver (iOS 12.1.2)

Testing both Safari and Chrome with VoiceOver, there is no announcement of figures, or a relationship of the figure’s content to its caption. Both `<figure>` and `role="figure"` patterns yielded the same results.

### TalkBack (7.2 on Android 8.1)

Testing both Chrome (70) and Firefox (63.0.2), there is no announcement of figures, or a relationship of the figure’s content to its caption. Both `<figure>` and `role="figure"` patterns yielded the same results.

### Narrator & Edge 42 / EdgeHTML 17

Narrator does not announce a `figure` role at all. However, the native element and `role="figure"` do have an effect on the manner in which a figure’s content is announced. When a `figure` has an accessible name, the contents of the figure (e.g. an image’s `alt` text) and the accessible name of the figure (`figcaption` content or `aria-label`) will be announced together. If an image has an empty `alt`, a `figure` and its `figcaption` will be completely ignored.

## Wrapping up

Based on the intended use cases for figures and their captions, as well as the current screen reader support for these elements, the following markup pattern should be considered if you want to ensure the semantics are conveyed to as wide of an audience as possible:

```
<figure role="figure" aria-label="repeat figcaption content here">
  <!-- figure content. if an image, provide alt text -->
  <figcaption>
    Caption for the figure.
  </figcaption>
</figure>

<!--
  aria-label for macOS VoiceOver + Chrome
  role="figure" for IE11.

  IE11 needs an accessible name (provided by aria-label).
  If not for the fact VO + Chrome doesn't support an
  accessible name from aria-labelledby, that attribute
  would have been preferred / pointed to an ID on 
  the <figcaption>.
-->
```

This pattern will ensure that the following pairings will announce the figure role and its caption:

*   JAWS with Chrome, Firefox and IE11.
*   macOS VoiceOver with Safari and Chrome.
*   Edge & narrator will create a relationship, but won’t announce the figure role.

Presently, mobile screen readers won’t announce figures, nor Edge unless paired with Narrator (sort of), or any browser paired with NVDA. But don’t let these gaps deter you from using the elements as intended by their specifications.

With Edge changing over to Chromium, better support will likely become a reality in the near future. And while NVDA and mobile screen readers don’t announce the semantics, the content remains accessible. [Filing bugs](https://github.com/nvaccess/nvda/issues/9177) is the best we can do for now to usher change for these gaps.

Thank you to [Steve Faulkner](https://twitter.com/stevefaulkner) for reviewing my tests and this article.

### Further reading

The following are additional resources to learn more about `figure`s and `figcaption`s, the test page / results I used, as well as bugs that have been filed with JAWS and NVDA:

*   [HTML Accessibility API Mappings 1.0: `figure` and `figcaption` elements](https://w3c.github.io/html-aam/#figure-and-figcaption-elements), W3C
*   [HTML5 Accessibility](https://www.html5accessibility.com/)
*   [HTML5 Doctor: `figure` and `figcaption`](http://html5doctor.com/the-figure-figcaption-elements/), (2010)
*   [HTML5 Accessibility Chops: the figure and figcaption elements](https://developer.paciellogroup.com/blog/2011/08/html5-accessibility-chops-the-figure-and-figcaption-elements/), Steve Faulkner (2011)
*   [ARIA 1.1: `figure` role](https://www.w3.org/TR/wai-aria-1.1/#figure)
*   [`figure` and `figcaption` test page](https://scottaohara.github.io/testing/figure/)
*   [JAWS + Chrome bug filed](https://github.com/FreedomScientific/VFO-standards-support/issues/161)
*   [NVDA bug to support `figure`s](https://github.com/nvaccess/nvda/issues/9177)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
