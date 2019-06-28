> * 原文地址：[Inclusively Hidden](https://www.scottohara.me/blog/2017/04/14/inclusively-hidden.html)
> * 原文作者：[scottohara](https://www.scottohara.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/inclusively-hidden.md](https://github.com/xitu/gold-miner/blob/master/TODO1/inclusively-hidden.md)
> * 译者：
> * 校对者：

# Inclusively Hidden

There are various ways to hide content in web interfaces, but are you aware of the different effects they have on the accessibility of that content? While some might think it’s strange to have multiple different ways to hide content, there are certain benefits that each method provides.

There have been many articles written about hiding content, and this post will cover some of the noted methods, and purposefully ignore others. This article will highlight the methods of hiding content that are most appropriate for modern web development, and note the accessibility impacts of each.

But before we talk about how to hide content we should ask ourselves a question…

## Why are we hiding content?

There are three primary reasons to hide content in an interface. It’s important to identify what those reasons are, as they will correlate with the appropriate technique needed to hide such content to the necessary type of end-user(s).

### 1. Completely Hidden Content:

This sort of hidden content is part of the intended design and UX of an interface.

There are many components in our interfaces (tab panels, off-screen navigations, modal windows, etc.) that are initially hidden until a state change occurs to bring these components, and their content, into view. Typically these sorts of initially hidden components are meant to be purposefully inaccessible until a requirement is met and the component becomes available to everyone.

### 2. Only Visually Hidden Content:

To address a design’s contextual shortcomings, visually hidden content may be added to a component that have inherent visual meaning, but may otherwise be undiscoverable or confusing to users of assistive technology (ATs).

As the best interfaces are interfaces that you don’t even notice, removing extraneous visual elements and paring components down to their absolute necessities can go a long way to create seamless user experiences.

However by striving for a minimal visual footprint, some of the first bits of “fluff” to be removed from an interface are often things like labels, or explicit copy.

By re-injecting visually hidden (but screen reader friendly) content, like text to accompany elements only represented by icons, or additional context to “read more” links, one can significantly bridge the gap between how sighted users and users relying on assistive technology will experience your interfaces.

In contrast to temporarily completely hidden content, this sort of hidden content is not meant to become visually accessible. This visually hidden content may have been added to make up for the fact it can be inferred from the visual interface, but there would otherwise be no overt announcement of it otherwise.

### 3. Visual-Only Content, or hiding content to assistive technologies:

In very specific instances, there may be visual elements that should not be discoverable to users of assistive technology. While this may seem counter intuitive to creating fully accessible user experiences, the goal with hiding this sort of content is to reduce potential redundancies in information (e.g. an image that would have alt text as “warning”, followed by visible text which states “warning”. Communicating both to assistive technologies is not necessary.)

## Time to properly hiding content

Now that we’ve identified three categories of hidden content, the following are techniques one can utilize to appropriately hide each content type:

### Hiding Content Completely

The techniques for hiding content completely are best used in conjunction with temporarily hidden content. This content should be hidden from all users until the content is needed. To achieve this, we can utilize the following:

1.  CSS `display: none`: Useful for completely removing elements from the normal DOM flow. Content set to display none will not be accessible to any user.

2.  HTML’s [`hidden` Attribute](https://html.spec.whatwg.org/multipage/interaction.html#the-hidden-attribute): The `hidden` attribute is a HTML5 native means to hide content to all users. It is essentially the same as using CSS to declare an element as `display: none;`. By declaring `[hidden] { display: none; }` in your CSS, even legacy browsers which don’t support the `hidden` attribute by default will still hide content in the same manner.

3.  CSS `visibility: hidden`: Much like `display: none`, this declaration will completely hide content from all users, with two important differences to `display: none`.

    First, this method does not remove the content from the normal DOM flow, so its “physical space” is still retained in the document.

    The second difference is unlike `display: none`, `visibility: hidden` will respect CSS transitions. This makes it a preferred choice when hidden content is meant to transition between its hidden and revealed state. To compensate for the first difference, `visibility: hidden` is best paired with other CSS properties that negate its position in the DOM. e.g. use `position: absolute` to remove it from the normal DOM flow in the hidden state, or `overflow: hidden` and `height: 0;`, etc.

With these choices in mind, the correct one should be used when coding a toggle interaction for a particular component.

For instance, if a component requires a basic show and hide interaction, and the content should become available were CSS to fail, toggle a `display: none` class.

If a component should remain hidden regardless of CSS being available or not, use and toggle the `hidden` attribute.

If a more complex transition is required, like when transitioning an off-screen navigation into the viewport, use `visibility: hidden;` along with other CSS positioning and transform properties when toggling the state of the component.

To reveal content hidden via these methods, you will need to utilize JavaScript to toggle attributes or classes.

Here is a quick demo of toggling content using CSS `visibility` and `display` properties:

See the Pen [toggles](http://codepen.io/scottohara/pen/ybLMOm/) by Scott ([@scottohara](http://codepen.io/scottohara)) on [CodePen](http://codepen.io).

### Hiding Content Visually

Visually hidden techniques allow for content to be hidden from sighted users while still allowing ATs to discover and interact with the content.

There are multiple ways to use CSS to visually hide content, but the following example will cover many use cases.

```
/* ie9+ */
.sr-only:not(:focus):not(:active) {
  clip: rect(0 0 0 0); 
  clip-path: inset(100%);
  height: 1px;
  overflow: hidden;
  position: absolute;
  white-space: nowrap; 
  width: 1px;
}
```

The above “sr-only” class is utilizing various declarations to shrink an element into a 1px square, hiding any overflow, and absolutely positioning the element to remove any trace of it from the normal document flow.

The `:not` portions of the selector are allowing a means for any focusable element to become visible when focused/active by a user. So elements that normally can’t receive focus, like paragraphs, will not become visible if a user navigates through content via screen reader controls or the Tab key, but natively focusable elements, or elements with a non-negative `tabindex` will have these elements appear in the DOM on focus.

As for some examples, this class can help provide context to read more links:

```
<a href="#foo">
  Read more
  <!-- 
    always visually hidden because the parent 
    is the focusable element.
  -->
  <span class="sr-only">
    about how to visually hide content
  </span>
</a>
```

inline skip links:

```
<!-- temporarily hidden until <a> is focused -->
<a href="#main_content" class="sr-only">
  Jump to main content
</a>
```

or labels to form components where context is visually implied, but may not be apparent to users reliant on screen readers.

```
<fieldset class="date-range-component">
  <legend>
    Select Start and End Dates
  </legend>

  <!-- always visually hidden -->
  <label for="start_date" class="sr-only">
    Start Date:
  </label>
  <input type="date" id="start_date" name="start_date">

  <span>
    to
  </span>

  <label for="end_date" class="sr-only">
    End Date:
  </label>
  <input type="date" id="end_date" name="end_date">
</fieldset>
```

If you’d like to learn more about `.sr-only` classes, there are additional links in the resources section at the end of the article.

#### Visually Hidden: Off Screen

Another method for hiding content from view is to push it off to the left of the visible viewport of the browser.

```
/* baseline rules for an off-screen class */
.off-screen {
  left: -100vw;
  position: absolute;
}
```

Absolutely positioning content off screen removes the content from the document flow, while also retaining access to it for ATs. It’s best to position content off to the left, as positioning it to the right may create horizontal scroll bars, if an `overflow-x: hidden;` is not set on containing elements.

Where this sort of technique can be preferred over the `.sr-only` class is when it’s modified for content that will transition from off-screen to within the view port, upon focus.

e.g. grouped skip links

```
<!--
  a list of skip links to jump directly to the 
  primary navigation or content of an interface.
-->
<ul class="off-screen-ul">
  <li>
    <a href="#primary_nav" class="skip-link">
      Skip to Primary Navigation
    </a>
  </li>
  <li>
    <a href="#primary_content" class="skip-link">
      Skip to Primary Content
    </a>
  </li>
</ul>
```

```
/*
  hides the list off screen, since these are links
  that are only useful for keyboard users, and do
  not require being consistently visible.
 */
.off-screen-ul {
  left: -100vw;
  list-style: none;
  position: absolute;
}

/*
  Style the skip links to be fixed to the 
  top of the page, and have an initial 
  negative Y-axis value.
 */
.skip-link {
  background: #000;
  color: #fff;
  left: 0;
  padding: .75em;
  position: fixed;
  top: 0;
  transform: translateY(-10em);
  transition: transform .2s ease-in-out;
}

/*
  Upon focus of the skip link, transition
  it into view by returning it's Y-axis to
  the default 0 value.
 */
.skip-link:focus {
  transform: translateY(0em);
}
```

Here’s a [CodePen of the above example](https://codepen.io/scottohara/pen/QKmWJG).

See the Pen [Simple off-screen skip link nav](https://codepen.io/scottohara/pen/QKmWJG/) by Scott ([@scottohara](https://codepen.io/scottohara)) on [CodePen](https://codepen.io).

In the above example, I’ve expanded the basic `.off-screen` class to hide the unordered list from being visible. The skip links have a variation of an off-screen class, as I want them to always be positioned at the top of the screen, but not transition in from the left. Since I want these links to individually slide into view, I’m also using the transform property, rather than top property, as [transitioning transforms has better performance (YouTube video of Will Boyd’s CSS Conf 2016 talk)](https://www.youtube.com/watch?v=bEoLCZzWZX8&feature=youtu.be).

### Exploiting a Completely Hidden Content Loophole

Using `display: none`, the `hidden` attribute, and `visibility: hidden` to completely hide content will negate all users from directly access that content. However, there is a way to reveal that content solely to screen readers in certain circumstances.

By attaching an `aria-describedby` or `aria-labelledby` attribute to a focusable element, and setting the ARIA attribute’s value to the completely hidden element’s `id`, screen readers will announce the content of the completely hidden element.

The use case for doing this would be if there was a need to provide additional context to an element (like test fields in a form), or to provide a label to an element without having that content discovered and announced multiple times by a screen reader.

For example:

```
<!-- 
  the sr-only class does not completely hide content. 
  These instructions will still be discovered by screen readers.
-->
<p class="sr-only" id="example_desc">
  Here are specific instructions for the type of information this form input is expecting to receive...
</p>

<!-- ... -->

<label for="example">
  Example
</label>
<input type="text" id="example" aria-describedby="example_desc">
```

The above example would allow screen readers to read the contents of the example description as a user navigates through the document with the virtual cursor.

While this is not “inaccessible”, the issue with it is that the information may not make sense when accessed in isolation to the form control in which it describes. It’s only necessary to make it available to users when they are accessing the form control to which it relates.

So, to make sure the content is only accessible when necessary, it could be marked up like so:

```
<!-- 
  using the hidden attribute, this description is now inaccessible
  via standard methods of content discovery. The aria-describedby,
  attribute on the input will still announce it to the user.
-->
<p hidden id="updated_example_desc">
  Here are specific instructions for the type of information this form input is expecting to receive...
</p>

<!-- ... -->

<label for="example">
  Example
</label>
<input type="text" id="example_2" aria-describedby="updated_example_desc">
```

Now the instructions are hidden from everyone in the normal document flow, but the ARIA attribute can still reference the ID, and reveal the content to the screen reader as descriptive text for the form control.

### Hiding Content from Assistive Technology

Sometimes content is for decorative purposes only, and it would be optimal to not announce this content to assistive technology.

For instance, icon fonts.

The Filament Group wrote an excellent article [Bulletproof Accessible Icon Fonts](https://www.filamentgroup.com/lab/bulletproof_icon_fonts.html) that I suggest reading if you or your organization is still using icon fonts. I also suggest reading [Making the Switch Away from Icon Fonts to SVG, by Sara Soueidan](https://sarasoueidan.com/blog/icon-fonts-to-svg/).

The short version is that icon fonts can be interpreted strangely by screen readers, and as they should be coupled with text labels, or at the very least, visually hidden accessible text to describe the icon’s purpose, the icon is really just for decoration.

With this in mind, we can apply `aria-hidden="true"` to the element that renders the font icon so screen readers know to ignore this content.

```
<button type="button">
  <!-- an X icon -->
  <span class="icon-close" aria-hidden="true"></span> 
  <!-- replace "this component" with appropriate text -->
  <span class="sr-only">Close "this component"</span>
</button>
```

The above markup uses an “X” icon as the visual indicator for the close button. Since its an icon font, and doesn’t provide adequate context as a label, the icon is hidden from screen readers. Visually hidden text is instead used to properly announce its meaning to screen readers.

#### Some things to be aware of if using `aria-hidden`:

1.  Do not use it on focusable elements. These elements would still be focusable but not properly announced by ATs. You could add a `tabindex="-1"` on the focusable element to remove it from the tab order, but the problem remains that you’ve now created an element that can’t be accessed by sighted keyboard users. Really, just don’t use `aria-hidden` on focusable content and you’ll be all set.

2.  Unlike `[hidden]` where setting a `display: block;` will override the attribute’s default styling and semantics, `aria-hidden` is not tied to any CSS rules. The only way to reveal its contents to users is to set the value to “false” or better yet, to remove the attribute all together when its meant to be fully accessible to all users.

3.  If you are using `aria-hidden` as a hook to hide/show content with JavaScript, then do not hard code `aria-hidden="true"` on the containing element. If JavaScript becomes unavailable, hard-coded `aria-hidden="true"` content would be permanently inaccessible, as there’d be no available way to change the state of that element.

## To wrap this all up…

Let’s do a quick recap:

1.  There are three categories of hidden content:

    *   Completely Hidden.
    *   Visually Hidden.
    *   Only Hidden from Assistive Technology.

2.  Depending on the type of content, you will need to use an appropriate technique to hide it, via:

    *   Using CSS or `[hidden]` to hide content completely.
    *   Using visually-hidden / sr-only classes to visually hide content, but keep it available for assistive technologies.
    *   Or using `aria-hidden="true"` to hide content specifically from screen readers.

Going back to my initial question “why are we hiding content?”, it’s apparent that there are some elements of a UI that truly need to be hidden. And while we have techniques to hide content, but still make it accessible for assistive technology users, I wouldn’t necessarily jump to these techniques as design solutions.

The goal should be to craft interfaces and experiences that are accessible and understandable to as many people as possible. Not to create interfaces where we can shoe horn in additional context by visually hiding it by default.

### Additional Resources:

Here are the great resources that were already available and helped me in formulating how I wanted to discuss this topic:

External Link:

*   [WebAim: Invisible Content](http://webaim.org/techniques/css/invisiblecontent/)
*   [How Visible vs. Hidden Elements Affect Keyboard/Screen Reader Users, by Marcy Sutton](https://egghead.io/lessons/html-5-visible-vs-hidden)
*   [Hiding Content for Accessibility, by Jonathan Snook](https://snook.ca/archives/html_and_css/hiding-content-for-accessibility)
*   [The State of Hidden Content Support in 2016](https://www.paciellogroup.com/blog/2016/01/the-state-of-hidden-content-support-in-2016/)
*   [Hidden Content Tests, by Terrill Thompson](http://terrillthompson.com/tests/hiddencontent.html)
*   [Explanation of white-space: nowrap, in sr-only class](https://medium.com/@jessebeach/beware-smushed-off-screen-accessible-text-5952a4c2cbfe)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
