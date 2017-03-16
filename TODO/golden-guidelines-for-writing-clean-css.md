> * 原文地址：[Golden Guidelines for Writing Clean CSS](https://www.sitepoint.com/golden-guidelines-for-writing-clean-css/)
* 原文作者：[Tiffany Brown](https://www.sitepoint.com/author/tbrown/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

---

# Golden Guidelines for Writing Clean CSS

### Golden Guidelines for Writing Clean CSS

As mentioned, there are some rules for writing clean CSS that you should try your best to avoid breaking. They’ll help you write CSS that is lightweight and reusable:

- Avoid global and element selectors
- Omit overly specific selectors
- Use semantic class names
- Don’t tie CSS too closely to markup structure

Let’s look at these one by one.

### Avoid Global Selectors

Global selectors include the universal selector (`*`), element selectors such as `p`, `button`, and `h1`, and attribute selectors such as `[type=checkbox]`. Style declarations applied to these selectors will be applied to every such element across the site. Here’s an example:

```
button {
  background: #FFC107;
  border: 1px outset #FF9800;
  display: block;
  font: bold 16px / 1.5 sans-serif;
  margin: 1rem auto;
  width: 50%;
  padding: .5rem;
}
```

This seems innocuous enough. But what if we want to create a button that’s styled differently? Let’s style a `.close` button that will be used to close dialog modules:

```
<section class="dialog"> 
  <button type="button" class="close">Close</button>
</section>
```

##### Note: Why not use `dialog?`

We’re using `section` here instead of the `dialog` element because support for `dialog` is limited to Blink-based browsers such as Chrome/Chromium, Opera, and Yandex.

Now we need to write CSS to override every line that we don’t want to inherit from the `button` rule set:

```
.close {
  background: #e00;
  border: 2px solid #fff;
  color: #fff;
  display: inline-block;
  margin: 0;
  font-size: 12px;
  font-weight: normal;
  line-height: 1;
  padding: 5px;
  border-radius: 100px;
  width: auto;        
}
```

We’d still need many of these declarations to override browser defaults. But what if we scope our `button` styles to a `.default` class instead? We can then drop the `display`, `font-weight`, `line-height`, `margin`, `padding`, and `width` declarations from our `.close` rule set. That’s a 23% reduction in size:

```
.default {
  background: #FFC107;
  border: 1px outset #FF9800;
  display: block;
  font: bold 16px / 1.5 sans-serif;
  margin: 1rem auto;
  width: 50%;
  padding: .5rem;
}

.close {
  background: #e00;
  border: 2px solid #fff;
  color: #fff;
  font-size: 12px;
  padding: 5px;
  border-radius: 100px;
}
```

Just as importantly, avoiding global selectors reduces the risk of styling conflicts. A developer working on one module or document won’t inadvertently add a rule that creates a side effect in another module or document.

Global styles and selectors are perfectly okay for resetting and normalizing default browser styles. In most other cases, however, they invite bloat.

### Avoid Overly Specific Selectors

Maintaining low specificity in your selectors is one of the keys to creating lightweight, reusable, and maintainable CSS. As you may recall on specificity, a type selector has the specificity 0,0,1. Class selectors, on the other hand, have a specificity of 0,1,0:

```
/* Specificity of 0,0,1 */
p {
  color: #222;
  font-size: 12px;
}

/* Specificity of 0,1,0 */
.error {
  color: #a00;
}
```

When you add a class name to an element, the rules for that selector take precedence over more generic-type selector rules. There’s no need to further qualify a class selector by combining it with a type selector. Doing so increases the specificity of that selector and increases the overall file size.

Put differently, using `p.error` is unnecessarily specific because `.error` achieves the same goal. Another advantage is that `.error` can be reused with other elements. A `p.error` selector limits the `.error` class to `p` elements.

#### Don’t Chain Classes

Also avoid chaining class selectors. Selectors such as `.message.warning` have a specificity of 0,2,0. Higher specificity means they’re hard to override, plus chaining often causes side effects. Here’s an example:

```
message {
  background: #eee;
  border: 2px solid #333;
  border-radius: 1em;
  padding: 1em;
}
.message.error {
  background: #f30;
  color: #fff;
}
.error {
  background: #ff0;
  border-color: #fc0;
}
```

Using `<p class="message">` with this CSS gives us a nice gray box with a dark gray border, as seen in Figure 2.1:

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/03/1489119564SelectorChainingNoChain.png)

Using `<p class="message error">`, however, gives us the background of `.message.error` and the border of `.error` shown in Figure 2.2:

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/03/1489119684SelectorChaining.png)

The only way to override a chained class selector would be to use an even more specific selector. To be rid of the yellow border, we’d need to add a class name or type selector to the chain: `.message.warning.exception` or `div.message.warning`. It’s more expedient to create a new class instead. If you do find yourself chaining selectors, go back to the drawing board. Either the design has inconsistencies, or you’re chaining prematurely in an attempt to prevent problems that you don’t have. Fix those problems. The maintenance headaches you’ll prevent and the reusability you’ll gain are worth it.

#### Avoid Using `id` Selectors

Because you can only have one element per `id` per document, rule sets that use `id` selectors are hard to repurpose. Doing so typically involves using a list of `id` selectors; for example, `#sidebar-features` and `#sidebar-sports`.

Identifiers also have a high degree of specificity, so we’ll need longer selectors to override declarations. In the CSS that follows, we need to use `#sidebar.sports` and `#sidebar.local` to override the background color of `#sidebar`:

```
#sidebar {
  float: right;
  width: 25%;
  background: #eee;
}
#sidebar.sports  {
  background: #d5e3ff;
}
#sidebar.local {
  background: #ffcccc;
}
```

Switching to a class selector, such as `.sidebar`, lets us simplify our selector chain:

```
sidebar {
  float: right;
  width: 25%;
  background: #eee;
}
.sports  {
  background: #d5e3ff;
}
.local {
  background: #ffcccc;
}
```

As well as saving us a few bytes, our `.sports`, and `.local` rule sets can now be added to other elements.

Using an attribute selector such as `[id=sidebar]` lets us get around the higher specificity of an identifier. Though it lacks the reusability of a class selector, the low specificity means that we can avoid chaining selectors.

##### Note: When the High Specificity of `id` Selectors is Useful

In some circumstances, you might *want* the higher specificity of an `id` selector. For example, a network of media sites might wish to use the same navigation bar across all of its web properties. This component must be consistent across sites in the network, and should be hard to restyle. Using an `id` selector reduces the chances of those styles being accidentally overridden.

Finally, let’s talk about selectors such as `#main article.sports table#stats tr:nth-child(even) td:last-child`. Not only is it absurdly long, but with a specificity of 2,3,4, it’s also not reusable. How many *possible* instances of this selector can there be in your markup? Let’s make this better. We can immediately trim our selector to `#stats tr:nth-child(even) td:last-child`. It’s specific enough to do the job. Yet the far better approach—for both reusability and to minimize the number of bytes—is to use a class name instead.

##### Note: A Symptom of Preprocessor Nesting

Overly specific selectors are often the result of too much preprocessor nesting.

#### Use Semantic Class Names

When we use the word *semantic*, we mean *meaningful*. Class names should describe what the rule does or the type of content it affects. We also want names that will endure changes in the design requirements. Naming is harder than it looks.

Here are examples of what not to do: `.red-text`, `.blue-button`, `.border-4px`, `.margin10px`. What’s wrong with these? They are too tightly coupled to the existing design choices. Using `class="red-text"` to mark up an error message does work. But what happens if the design changes and error messages become black text inside orange boxes? Now your class name is inaccurate, making it tougher for you and your colleagues to understand what’s happening in the code.

A better choice in this case is to use a class name such as `.alert`, `.error`, or `.message-error`. These names indicate how the class should be used and the kind of content (error messages) that they affect. For class names that define page layout, add a prefix such as `layout-`, `grid-`, `col-`, or simply `l-` to indicate at a glance what it is they do. The section on BEM methodology later on describes a process for this.

#### Avoid Tying CSS Closely to Markup

You’ve probably used child or descendant selectors in your code. Child selectors follow the pattern `E > F` where F is an element, and E is its *immediate* parent. For example, `article > h1` affects the `h1` element in `<article><h1>Advanced CSS</h1></article>`, but not the `h1` element in `<article><section><h1>Advanced CSS</h1></section></article>`. A descendant selector, on the other hand, follows the pattern `E F` where F is an element, and E is an ancestor. To use our previous example, `article h1` selects the `h1` element in both cases.

Neither child nor descendant selectors are inherently bad. In fact, they work well to limit the scope of CSS rules. But they’re far from ideal, however, because markup occasionally changes.

Raise your hand if you’ve ever experienced the following. You’ve developed some templates for a client and your CSS uses child and descendant selectors in several places. Most of those children and descendants are also element selectors, so selectors such as `.promo > h2` and `.media h3` are all over your code. Your client also hired an SEO consultant, who reviewed your markup and suggested you change your `h2` and `h3` elements to `h1` and `h2` elements. The problem is that we also have to change our CSS.

Once again, class selectors reveal their advantage. Using `.promo > .headline` or `.media .title` (or more simply `.promo-headline` and `.media-title`) lets us change our markup without having to change our CSS.

Of course, this rule assumes that you have access to and control over the markup. This may not be true if you’re dealing with a legacy CMS. It’s appropriate and necessary to use child, descendant, or pseudo-class selectors in such cases.

##### Note: More Architecturally Sound CSS Rules

Philip Walton discusses these and other these rules in his article [“CSS Architecture.”](http://philipwalton.com/articles/css-architecture/) I also recommend Harry Roberts’ site [CSS Guidelines](http://cssguidelin.es/) and Nicolas Gallagher’s post [About HTML Semantics and Front-end Architecture](http://nicolasgallagher.com/about-html-semantics-front-end-architecture/) for more thoughts on CSS architecture.

We’ll now look at two methodologies for CSS architecture. Both methods were created to improve the development process for large sites and large teams; however, they work just as well for teams of one.