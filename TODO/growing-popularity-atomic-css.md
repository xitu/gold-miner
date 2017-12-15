> * 原文地址：[On the Growing Popularity of Atomic CSS](https://css-tricks.com/growing-popularity-atomic-css/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[OLLIE WILLIAMS](https://css-tricks.com/author/olliew/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/growing-popularity-atomic-css.md](https://github.com/xitu/gold-miner/blob/master/TODO/growing-popularity-atomic-css.md)
> * 译者：
> * 校对者：

# On the Growing Popularity of Atomic CSS

Even if you consider yourself a CSS expert, chances are that at some point on a large project you've had to deal with a convoluted, labyrinthine stylesheet that never stops growing. Some stylesheets can feel like a messy entangled web of inheritance.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/spaghetti-monster.jpg)

Spaghetti Monster

The cascade is incredibly powerful. Small changes can have large effects, making it harder to know what the immediate consequences will be. Refactoring, changing, and removing CSS is seen as risky and approached with trepidation as it's difficult to know all the places it's being used.

> One thing that is often hard to articulate with new tooling is **when, exactly** do you start to reach for this? The answer is rarely (if ever) _immediately_ and _in all situations_.
> 
> One of those situations, in my limited experience, is on large teams with large codebases. **The feeling is that the CSS can get far too large and team members essentially become afraid of it, and the CSS becomes jokingly-but-accurately “append-only”.**
> 
> Along comes a tool that delivers on a promise of shipping far less CSS and in a way that (after a learning curve) nobody is ever afraid of again… I can see the appeal.
> 
> - [Chris Coyier](https://css-tricks.com/lets-define-exactly-atomic-css/#comment-1607914)

### Atomic CSS keeps things simple

> I no longer had to think about how to organise my CSS. I didn't have to think about what to name my 'components', where to draw the line between one component and another, what should live where, and crucially, how to refactor things when new requirements came in.
> 
> - [Callum Jefferies, Takeaways from trying out Tachyons CSS after ages using BEM](https://madebymany.com/stories/takeaways-from-trying-out-tachyons-css-after-ages-using-bem)

[Atomic CSS](https://css-tricks.com/lets-define-exactly-atomic-css/) offers a straightforward, obvious, and simple methodology. Classes are immutable - they don't change. This makes the application of CSS predictable and reliable as classes will always do _exactly_ the same thing. The scope of adding or removing a utility class in an HTML file is unambiguous, giving you the confidence that you aren't breaking anything else. This can reduce cognitive load and mental-overhead.

Naming components is notoriously difficult. Deciding on a class name that is both meaningful but also vague enough to be reusable is time-consuming and mentally taxing.

> There are only two hard things in Computer Science: cache invalidation and naming things.
> 
> – Phil Karlton

Coming up with the appropriate abstractions is hard. Naming utility classes, by contrast, is completely straightforward.

```
/* naming utility classes */
.relative {
  position: relative;
}
.mt10 {
  margin-top: 10px;
}
.pb10 {
  padding-bottom: 10px;
}
```

Atomic classes speak for themselves. Their intent and effect are immediately obvious. While littering HTML with countless classes may look cluttered, HTML is much easier to reason about than an impenetrably gargantuan and incomprehensible wall of tangled styles.

In a mixed-ability team, perhaps involving backend developers with limited interest and knowledge of CSS, there's less chance of people messing up the stylesheet.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/s_936DE68CA3D578D4EBA9574821004F0B168A1400AEE2F968AAEBC3372F36B63D_1510608565787_ScreenShot2017-11-13at21.27.52.png)

Taken from ryanair.com - a whole load of CSS all doing one thing.

### Dealing with stylistic variation

[Utility classes](https://css-tricks.com/need-css-utility-library/) are perfect for dealing with small stylistic variations. While design systems and pattern libraries may be all the rage these days, what this approach recognizes is that there will continuously be new requirements and variations. All the talk about component reusability often isn't reflected in the design mocks that get passed your way. While visual and brand consistency is good, the wide variety of contexts on a large website make some variation inevitable and justified.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/bem-modifiers.png)

The Medium development team moved away from BEM modifiers, as [documented on their blog](https://medium.engineering/simple-style-sheets-c3b588867899).

What if we want a component to differ from another in only one single small way. If you've adopted a BEM naming convention, the modifier classes may well get out of hand - countless modifiers that often do only a single thing. Lets take margins as an example. The margins of a component are unlikely to remain universally consistent for a component. The desired spacing depends not only on the component but also its position on a page and its relation to its surrounding elements. Much of the time designs will contain similar but _non-identical_ UI elements, which are arduous to deal with using traditional CSS.

### A lot of people dislike it

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/twitter.com_AaronGustafson_status_743073596789133312_ref_srctwsrc5Etfwref_urlhttp3A2F2Fcssmojo.com2Fopinions_of_leaders_considered_harmful2F.png)

Aaron Gustafson, chief editor of A List Apart, former manager of the Web Standards Project, Microsoft employee.

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/soledad.png)

Mozilla Engineer Soledad Penades

![](https://cdn.css-tricks.com/wp-content/uploads/2017/11/cssmojo.com2Fopinions_of_leaders_considered_harmful2F.png)

From the creator of CSS Zen Garden

### How is Atomic CSS different from inline styles?

This is the question always asked of atomic CSS by its critics. Inline styles have long been deemed a bad practice, rarely used since the early days of the web. _Critics aren't completely wrong to equate atomic CSS to inline styles because they both suffer from the same major pain point._ Here's an example: What if we want to change everything with a `.black` class to be navy instead? We could do this:

```
.black {
  color: navy;
}
```

That's obviously a _terrible_ idea.

Text editors are sophisticated things these days. It feels somewhat hazardous, but it would be simple enough to use find and replace to change all instances of the `.black` class with a new `.navy` class. The real problem is when you want to change _only certain instances_ of `.black` to be `.navy`.

In traditional approaches to CSS, adjusting the styling of a component is as easy as updating a single value in a single class in a CSS file. With atomic CSS this becomes the tedious task of searching through every piece of HTML to update every instance of said component. However advanced code editors become, there's no getting around this. Even if you're separating your markup into reusable templates, this is still a major drawback. **Perhaps this manual labour is worth it for the simplicity of this approach. Updating HTML files with different classes may be tedious but its not difficult.** (Although there have been times when I have temporarily introduced stylistic inconsistency by missing certain instances of the relevant component when manually updating.) If a design changes, chances are you'll need to hand-edit classes from all over your HTML.

While atomic CSS shares inline styles big drawback, they aren't a retrograde step into the past. Utility classes are better than inline styles in all kinds of ways.

### Atomic CSS vs. Inline Styles

#### Atomic classes allow abstraction, inline styles don't

With atomic classes, it is possible to create abstractions that would be impossible with inline styles.

```
<p style="font-family: helvetica; color: rgb(20, 20, 20)">
  Inline styles suck.
</p>
<p class="helvetica rgb202020">
  Badly written CSS isn't very different.
</p>
<p class="sans-serif color-dark">
  Utility classes allow for abstraction.
</p>
```

The first two examples shown above would require a manual find-and-replace in order to update styling were the design to change. The styles in the third example can be adjusted in a single place within a stylesheet.

#### Tooling

Sass, Less, PostCSS, Autoprefixer… The CSS community has created a lot of useful tools that weren't available for inline styles.

#### Brevity

Rather than writing out verbose inline styles, atomic classes can be terse abbreviations of declarations. It's less typing: `mt0` vs `margin-top: 0`, `flex` vs `display: flex`, etc.

#### Specificity

This is a contentious point. If a class or inline style only does one single thing, chances are _you want it to do that thing._ Some people have even advocated using `!important` on all utility classes to ensure they override everything else. Similarly, proponents of inline styles see its inability to be overridden (by anything other than !important) as a selling point - it means you can be sure the style will be applied. However, a class alone is specific enough to override any base style. The lower specificity of atomic classes compared to inline styles is a good thing. It allows more versatility. Were all used to changing classes on JavaScript to change styles. Inline styles make this harder.

#### Classes in stylesheets can do things inline styles can't

Inline styles do not support media queries, pseudo selectors, @supports, or CSS animations. Perhaps you have a single hover effect you want to apply to disparate elements rather than to only one component.

```
.circle {
  border-radius: 50%;
}

.hover-radius0:hover {
  border-radius: 0;
}
```

Simple reusable media query rules can also be turned into a utility class. Its common to use a classname prefix for small, medium and large screen sizes. Here is an example of a flexbox class that will only apply on medium and large screen sizes:

```
@media (min-width: 600px) {
  .md-flex {
    display: flex;
  }
}
```

This wouldn't be possible with an inline style.

Perhaps you want a reusable pseudo-content icon or label?

```
.with-icon::after {
  content: 'some icon goes here!';
}
```

#### Limiting choice can be a good thing

Inline styles can be _anything_. This freedom could easily lead to design anarchy and inconsistency. By predefining classes for everything, atomic CSS can ensure a certain amount of stylistic consistency. Rather than ad libbing colours and values from an infinite amount of options, utility classes offer a curated set of predefined options. Developers choose from this limited set of single-purpose utility classes. This constraint can both eliminate the problem of an ever-growing stylesheet and maintain visual consistency.

Take the `box-shadow` as an example. An inline style will have an almost limitless amount of options for offset, spread, color, opacity and blur radius.

```
<div style="box-shadow: 2px 2px 2px rgba(10, 10, 250, .4)">stuff</div>
```

With an atomic approach, CSS authors can define the preferred style, which is then simply applied, without the possibility of stylistic inconsistency.

```
<div class="box-shadow">stuff</div>
```

### Atomic CSS is not all or nothing

There's no doubt that utility class frameworks like Tachyons have grown in popularity. However, CSS approaches are not mutually exclusive. There are plenty of cases where utility classes aren't the best option:

* If you need to change a lot of styles for a particular component inside of a media query.
* If you want to change multiple styles with JavaScript, it's easier to abstract that into a single class.

Utility classes can coexist with other approaches. Its probably a good idea to define base styles and sane defaults globally. If you keep duplicating the same long string of utility classes, chances are the styles should be abstracted into a single class. You can mix in component classes, but do so only when you know they will be reused.

> Taking a component-first approach to CSS means you create components for things even if they will never get reused. This premature abstraction is the source of a lot of bloat and complexity in stylesheets.
> 
> - [Adam Wathan](https://adamwathan.me/css-utility-classes-and-separation-of-concerns/)

> The smaller the unit, the more reusable it is.
> 
> - [Thierry Koblentz](http://www.smashingmagazine.com/2013/10/challenging-css-best-practices-atomic-approach)

Looking at the newest release of Bootstrap, a whole host of utility classes is now offered, while still including its traditional components. Increasingly, popular frameworks are taking this mixed approach.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
