> * 原文地址：[10 New CSS Features You Might Not Know About (2021 Edition)](https://torquemag.io/2021/03/new-css-features/)
> * 原文作者：Nick Schäferhoff
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-css-features-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-css-features-2021.md)
> * 译者：
> * 校对者：

# 10 New CSS Features You Might Not Know About (2021 Edition)

The modern web would not be possible without CSS. The markup language is responsible for the fact that websites look good, have a pleasant layout, and that every element stays where it belongs. Yet, did you know that new CSS features come out all the time?

Over the years, CSS has gone way beyond background colors, borders, text styling, margins, and **[the box model](https://torquemag.io/2018/06/css-box-model/)**. Modern CSS is capable of a whole range of functionality that, in the past, you needed JavaScript or workarounds for.

To celebrate how far it has come, in this post we want to look at some of the amazing new features that CSS boasts in 2021 and that you might not be aware of. We will highlight cool things **[web designers and developers](https://torquemag.io/2017/10/web-designer-vs-web-developer-difference/)** can do with modern CSS, talk about use cases, browser support, and also give you a quick example.

Let’s get going.

## New CSS Features: What Modern CSS Can Do

Here are some of the amazing things that CSS is capable of these days.

### Custom Properties/Variables

Custom properties basically allow you to define stand-ins for CSS properties in a central place to use for your design. The best way to understand the why that is useful is to go over an example.

Usually, when building a theme, you would choose a **[color scheme](https://websitesetup.org/website-color-schemes/)** and then declare those colors every time it’s necessary.

```css
a {
	color: #cd2653;
}

.social-icons a {
	background: #cd2653;
}

.wp-block-button.is-style-outline {
	color: #cd2653;
}
```

The problem with this approach is, if you want to make changes to one of the colors, you have to change every single instance of it. While **[code editors](https://torquemag.io/2015/12/17-best-code-editors-wordpress-developers-users/)** can easily do that via search and replace, it’s still annoying. Especially if you just want to do a quick test and have to reverse everything again.

### There is a Better Solution

Custom properties do away with this. With their help, you can assign the colors in question to a variable once and then simply input that variable as the CSS property every time you use it like so:

```css
:root {
	--global--color-primary: #28303d;
}

a {
	color: var(--global--color-primary);
}

.social-icons a {
	background: var(--global--color-primary);
}
```

That way, when you want to make change, you only have to do it in one place. Cool, right? In the past, you needed to employ a preprocessor such as **[SASS](https://torquemag.io/2017/06/start-using-sass-wordpress-npm-scripts/)** to use variables, now it’s a native functionality of CSS.

As you can see above, custom properties are also very simple to use. Define your variables at the beginning of the document under the `:root` selector (notice the double hyphen `--` in front of the variables, this is what defines them as custom properties, also they are case sensitive!). After that, you can use them throughout document via the `var()` function.

If you want to change a variable, simply change the declaration under `:root` and you are good to go. A theme that takes a lot of advantage of custom properties is Twenty Twenty-One. If you want to see them in action, I recommend that you read **[our review](https://torquemag.io/2021/01/twenty-twenty-one-review/)**.

As for the question of how well adopted this CSS feature is, **[browser support](https://caniuse.com/css-variables)** is very good:

![https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-variables-custom-properties-browser-support-1024x376.jpg](https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-variables-custom-properties-browser-support-1024x376.jpg)

### @supports

Next up, we have a CSS rule similar to media queries. However, instead of making CSS rules conditional on screen size or phone type, `@supports` allows you to do the same depending on what CSS properties and values the user browser supports.

What is this good for?

As you will see throughout this post, not all CSS features are supported in all browsers and devices. While you can often deal with this using fallback declarations, in some cases, if you don’t specifically include a support for older technology, it can seriously break your site.

In addition, you can use `@supports` to add extra features or styling for more modern browsers that can deal with them (which is why queries with `@supports` are also referred to as “feature queries”).

### How to Use Feature Queries

If you are familiar with media queries, using the support check will be very easy. Here’s how to use it:

```css
@supports (display: grid) {
	.site-content {
		display: grid;
	}
}
```

As you can see, it’s simply the rule followed by the property or property-value pair you want to check for in brackets. After that comes the usual CSS declaration for what rules to apply if the condition is met.

The above example states that if the browser supports CSS grid (more on that in a minute) it should apply `display: grid;` to the element with the class `.site-content`.

It’s also important to note that `@supports` understands the operators `not`, `and`, and `or` (that can also be combined) to create more specific rules, such as a fallback for browsers that don’t support that particular feature:

```css
@supports not (display: grid) {
	.site-content {
		float: left;
	}
}
```

In order to use `@supports` properly, you need to be aware of which browsers support it (I know, this is kind of meta). The good news is that **[all modern browsers do](https://caniuse.com/css-featurequeries)**.

![https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-feature-queries-browser-support-1024x368.jpg](https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-feature-queries-browser-support-1024x368.jpg)

However, since the goal of these queries is to enable or disable features that older browsers can’t deal with, make sure that you construct them properly. That means, if you are going to use a feature query, create it for browsers that understand feature queries. It’s no use telling a browser to ignore something in a way that it can’t understand.

### Flexbox Gaps

Flexbox is another CSS layout module that we have discussed **[at length](https://torquemag.io/2020/02/flexbox-tutorial/)** before. One of its weak points have long been flexbox gaps, meaning the possibility to define breaks between rows and columns.

Thankfully, browser support for this CSS feature is improving. You can now start using **[gap](https://caniuse.com/flexbox-gap)**, **[row-gap](https://caniuse.com/?search=row-gap)**, and **[column-gap](https://caniuse.com/?search=column-gap)** to create space in layouts created with Grid, Flexbox, and Multi-Column Layouts.

Here’s a quick example of what this might look like in flexbox:

```
.flex-gap-test {
	display: inline-flex;
	flex-wrap: wrap;
	gap: 16px;
}

<div class="flex-gap-test">
	<div>1</div>
	<div>2</div>
	<div>3</div>
	<div>4</div>
	<div>5</div>
	<div>6</div>
</div>
```

And here it is on the page:

![https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/new-css-features-flexbox-gaps-example.jpg](https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/new-css-features-flexbox-gaps-example.jpg)

While it is possible to achieve the same layout via margins it needs a lot more markup and workarounds than simply declaring gap size.

### content-visibility

`content-visibility` is a really cool new CSS feature to **[improve site performance](https://torquemag.io/2015/08/ways-to-speed-up-wordpress-decrease-page-load-time/)**. It basically works like **[lazy loading](https://torquemag.io/2018/01/lazy-load-wordpress/)**, only not for images but any HTML element. You can use it to keep any part of your site from loading until it becomes visible.

Usage is also super easy. Simply apply it to an element of your choice like so:

```css
.content-below-fold {
	content-visibility: auto;
}
```

`content-visibility` takes three values. By default, it is set to `visible`, in which case the element loads as usual. Alternatively, you can set it to `hidden`, in which case the element is not rendered, no matter whether it’s visible or not. When set to `auto`, on the other hand, elements outside of the visible area will be skipped and then rendered once they appear on screen.

Pretty cool stuff, right?

One thing that might also be important in this case is `contain-intrinsic-size`. Since elements set to `content-visibility: hidden;` are effectively zero in size, this lets you apply a theoretical height and width to hidden elements so that the browser can take it into consideration from the get-go instead of at the point when the element is rendered. This way, you can avoid sudden layout changes during scroll.

**[Browser support for](https://caniuse.com/css-content-visibility)** **`[content-visibility](https://caniuse.com/css-content-visibility)`** is still a bit spotty but getting there. Same for **`[contain-intrinsic-size](https://caniuse.com/mdn-css_properties_contain-intrinsic-size)`**.

![https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-content-visibility-browser-support-1024x370.jpg](https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-content-visibility-browser-support-1024x370.jpg)

Once more widely adopted, I predict that it will become one of the most effective tools for speeding up the rendering process.

### Transitions, Transforms, Animations

In former times, if you wanted something to move on your website, you usually had to resort to JavaScript (or animated GIFs, for those who are part of generation MySpace). However, what you might not be aware of is that CSS has also had the ability to make things move for years. The three main tools for achieving this sort of thing are:

- **[Transitions](https://www.w3schools.com/css/css3_transitions.asp)** — Allow you to make a change from one property value to another (e.g. hover effects) smooth instead of abrupt.
- Transformations — Lets you move, rotate, and scale elements both in **[2D](https://www.w3schools.com/css/css3_2dtransforms.asp)** and **[3D](https://www.w3schools.com/css/css3_3dtransforms.asp)** space.
- **[Animations](https://www.w3schools.com/css/css3_animations.asp)** — Set up simple or complex animations in CSS and configure how and when they should run.

Naturally, we don’t have the space to go over all three in detail here. Be sure to check out the links above if you want to learn more. However, let’s do some quickfire examples for each so you have an impression of what is possible.

### CSS Transition

Here’s a quick example for a CSS transition:

```css
div {
	width: 100px;
	height: 100px;
	transition: height 3s;
}

div:hover {
	height: 500px;
}
```

The above markup will slow down the increase in `div` height to three seconds when somebody hovers over the element.

### CSS Transformation

Below is an example of a CSS transformation. It will rotate the element by 30 degrees clockwise when someone hovers their mouse over it:

```css
div:hover {
	transform: rotate(30deg);
}
```

### CSS Animation

And finally, a short snippet that shows off a CSS animation:

```css
@keyframes color-change {
	from {background-color: blue;}
	to {background-color: yellow;}
}

div:hover {
	animation-name: color-change;
	animation-duration: 3s;
}
```

Notice how you use `@keyframes` to name the animation and define what it does and then apply it to an element using `animation-name`. `animation-duration` controls how long it takes to complete. There are other properties like this.

If you want to give all of these a try, the good news is that browser support is excellent (see **[here](https://caniuse.com/css-transitions)**, **[here](https://caniuse.com/transforms2d)**, **[here](https://caniuse.com/transforms3d)** and **[here](https://caniuse.com/css-animation)**). Therefore, nothing stands in the way of you giving CSS transitions, transformations, and animations a spin.

### Scroll Snap

Scroll snapping gives you the option to lock the user’s viewport to a certain parts or element of your site. It is very useful to create cool transitions and help users focus on the most important page elements while scrolling down the page. You can find a simple demo of it **[here](https://codepen.io/tutsplus/pen/qpJYaK)**.

This effect is visible in mobile apps a lot, yet, with scroll snapping, you can bring it to websites as well.

Usage is also relatively simple on the most basic level. You simply apply the type of scroll snapping to a container and define where its children should snap to.

```css
.container {
	scroll-snap-type: y mandatory;
}

.container div {
	scroll-snap-align: start;
}
```

Of course, there is more to it. If you want to learn about it, CSS Tricks have great **[write up](https://css-tricks.com/practical-css-scroll-snapping/)**.

That only leaves a look at browser compatibility, which is **[pretty good](https://caniuse.com/css-snappoints)**.

![https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-scroll-snap-browser-support-1024x378.jpg](https://s3-torquehhvm-wpengine.netdna-ssl.com/uploads/2021/02/css-scroll-snap-browser-support-1024x378.jpg)

However, be aware that support is a bit uneven across all available `scroll-snap` properties. Therefore, be sure to check for your particular use case.

### :is and :where

The final entries on our list of new CSS features you might not be aware of are the `:is` and `:where` pseudo classes. They allow you to reduce repetition in CSS markup by shortening lists of CSS selectors.

For example, compare this:

```css
.main a:hover,
.sidebar a:hover,
.site-footer a:hover {
	/* markup goes here */
}
```

To this:

```css
:is(.main, .sidebar, .site-footer) a:hover {
	/* markup goes here */
}
```

The same thing works with `:where`:

```css
:where(.main, .sidebar, .site-footer) a:hover {
	/* markup goes here */
}
```

If the markup is the same, what’s the difference? The difference is that `:is` is a lot more specific. It takes the level of specificity of the most specific element in the parentheses. In contrast to that, the specificity of `:where` is always zero. Consequently, it is a lot easier to override further down the line.

Browser adoption is still a bit spotty but **[slowly](https://caniuse.com/mdn-css_selectors_is)** getting **[there](https://caniuse.com/mdn-css_selectors_where)**. So, feel free to start trying them out.

## Any Other New CSS Features Worth Looking At?

Like all other web technology, cascading stylesheet markup is constantly evolving. That means, there are always new CSS features to discover and things to try out and experiment with.

Above, we have looked at some examples of things CSS is already capable of today that you might have missed. There’s more where that came from. We’d be delighted to hear what else you have to share. Aside from that, happy coding!

*What’s your favorite feature of modern day CSS? Share it in the comments section below!*

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
