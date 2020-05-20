> * 原文地址：[10 Best Practices for Improving Your CSS](https://medium.com/better-programming/10-best-practices-for-improving-your-css-84c69aac66e)
> * 原文作者：[Ferenc Almasi](https://medium.com/@ferencalmasi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/10-best-practices-for-improving-your-css.md](https://github.com/xitu/gold-miner/blob/master/article/2020/10-best-practices-for-improving-your-css.md)
> * 译者：
> * 校对者：

# 10 Best Practices for Improving Your CSS

![](https://cdn-images-1.medium.com/max/3400/1*m7oyUcMoJsW5wyzGfh6ydA.png)

CSS may seem like a pretty straightforward language, on that’s hard to make mistakes in. You just add your rules to style your website and you’re done, right? With small sites that require only a couple of CSS files, this might be the case. But in large applications, styles can quickly spiral out of control. How do you keep them manageable?

The reality is that, just as with any other language, CSS has its own nuances that can make or break your design. Here are 10 tips for CSS — best practices that can help you bring out the best from your styles.

## 1. Do You Really Need a Framework?

First of all, decide whether you really need to use a CSS framework. There are now many lightweight alternatives to robust frameworks. Usually, you won’t be using every selector from a framework, so your bundle will contain dead code.

If you’re only using styles for buttons, outsource them to your own CSS file and get rid of the rest. Also, you can identify unused CSS rules using code coverage in DevTools.

![](https://cdn-images-1.medium.com/max/2000/1*9XvQSS3wJLIIx7GdzsDSBQ.png)

To open it, search for Coverage in the Tools panel. You can open the Tools panel by clicking `Ctrl` + `Shift` + `P`. Once open, start recording by clicking on the reload icon. Everything shown in red is unused.

You can see that in the example above, it says that 98% of the CSS is not used. Note that this is not actually true — some CSS styles are only applied after the user interacts with the site. Styles for mobile devices are also flagged as unused bytes. So before you remove everything, make sure you verify that it is indeed not used anywhere.

## 2. Prefer Using a CSS Methodology

Consider using a CSS methodology for your project. CSS methodologies are used to create consistency in your CSS files. They help in scaling and maintaining your projects. Here are some popular CSS methodologies that I can recommend.

#### BEM

BEM —Block, Element, Modifier **—** is one of the most popular CSS methodologies out there. It’s a collection of naming conventions you can use to easily craft reusable components. The naming conventions follow this pattern:

```CSS
.block { ... }
.block__element { ... }
.block--modifier { ... }
```

* `.block`: Blocks represent a component. They’re standalone entities and are meaningful on their own.
* `.block__element`: These are parts of a `.block`. They have no standalone meaning and must be tied to a block.
* `.block--modifier`: These are used as flags on blocks or elements. We can use them to change the appearance, behavior, or state of elements. For example, to use a hidden flag, we could say `.block--hidden`.

#### ITCSS

Inverted Triangle CSS helps you better organize your files by introducing different layers to different specificities. The deeper you go, the more specific.

![The 7 layers of ITCSS](https://cdn-images-1.medium.com/max/2796/1*8w0OVv3Z8z2eQdtPBasfnA.png)

#### OOCSS

Object-oriented CSS, or OOCSS, has two main principles.

**Separating structure and skin**

This means you want to define visuals separately from structural code. What does this mean in practice?

```CSS
/* Instead of  */
.box {
    width: 250px;
    height: 250px;
    padding: 10px;
    border: 1px solid #CCC;
    box-shadow: 1px 2px 5px #CCC;
    border-radius: 5px;
}

/* Do */
.box {
    width: 250px;
    height: 250px;
    padding: 10px;
}

.elevated {
    border: 1px solid #CCC;
    box-shadow: 1px 2px 5px #CCC;
    border-radius: 5px;
}
```

**Separating container and content**

This means you don’t want any element to depend on its location. The same elements should look the same regardless of where they are on the page.

```CSS
/* Instead */
.main span.breadcumb { ... }

/* Do */
.breadcrumb { ... }
```

## 3. Set Up a Pre-Processor

Setting up a pre-processor can benefit you in various ways. A pre-processor is a tool that lets you use advanced features that don’t exist in CSS. These can be things like variables for loops, or even functions.

There are plenty of pre-processors out there. Probably the most famous three are [Sass](https://sass-lang.com/), [Less](http://lesscss.org/), and [Stylus](https://stylus-lang.com/). I recommend using Sass because of it’s thriving community and the extensive documentation you can find for it on the web.

So, how can pre-processors help you?

#### Organize your styles better

Pre-processors help you organize your styles better. They have the ability to break down your files into smaller, reusable pieces. These can be imported into each other, or later separately into your application.

```SCSS
// Import different modules into one SCSS file
@import 'settings';
@import 'tools';
@import 'generic';
@import 'elements';
@import 'objects';
@import 'components';
@import 'trumps';
```

#### Nest your selectors

Another great way to enhance readability is by nesting your selectors. This is a simple, powerful feature that CSS lacks.

```SCSS
.wrapper {
    .sidebar {
        &.collapsed {
            display: none;
        }
        
        .list {
            .list-item {
                ...
                
                &.list-item--active {
                    ...
                }
            }
        }
    }
}
```

The hierarchical structure makes it easier to visualize how different elements tie together.

#### Automatically vendor prefix your rules

Some nonstandard or experimental features are prefixed in CSS. Different browsers use different prefixes for them, such as:

* `-webkit-`: for WebKit based browsers such as Chrome, Safari, or newer versions of Opera.
* `-moz-`: for Firefox.
* `-o-`: for older versions of Opera.
* `-ms-`: for IE and Edge.

To support all major browsers, we have to define certain properties multiple times.

```CSS
.gradient {
    background: rgb(30,87,153);
    background: -moz-linear-gradient(top, rgba(30,87,153,1) 0%, rgba(41,137,216,1) 50%, rgba(32,124,202,1) 51%, rgba(125,185,232,1) 100%);
    background: -webkit-linear-gradient(top, rgba(30,87,153,1) 0%, rgba(41,137,216,1) 50%, rgba(32,124,202,1) 51%, rgba(125,185,232,1) 100%);
    background: linear-gradient(to bottom, rgba(30,87,153,1) 0%, rgba(41,137,216,1) 50%, rgba(32,124,202,1) 51%, rgba(125,185,232,1) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#1e5799', endColorstr='#7db9e8', GradientType=0);
}
```

Pre-processors help us tackle this with `mixin`s — functions that can be used in place of hard-coded values.

```SCSS
@mixin gradient() {
    background: rgb(30,87,153);
    background: -moz-linear-gradient(top, rgba(30,87,153,1) 0%, rgba(41,137,216,1) 50%, rgba(32,124,202,1) 51%, rgba(125,185,232,1) 100%);
    background: -webkit-linear-gradient(top, rgba(30,87,153,1) 0%, rgba(41,137,216,1) 50%,rgba(32,124,202,1) 51%, rgba(125,185,232,1) 100%);
    background: linear-gradient(to bottom, rgba(30,87,153,1) 0%, rgba(41,137,216,1) 50%,rgba(32,124,202,1) 51%, rgba(125,185,232,1) 100%);
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#1e5799', endColorstr='#7db9e8', GradientType=0);
}

.gradient {
    @include gradient();
}
```

Instead of writing out the same thing over and over again, you can just include `mixin`s whenever you need them.

#### Using post-processors

An even better option is a post-processor. A post-processor can run additional optimization steps once your CSS is generated by a pre-processor. One of the most popular post-processors is `[PostCSS](https://postcss.org/)`.

You can use `PostCSS` to automatically prefix your CSS rules, so you don’t have to worry about leaving out major browsers. They use values from [Can I Use](https://caniuse.com/), so it’s always up to date.

Another great post-processor is `[autoprefixer](https://www.npmjs.com/package/autoprefixer)`. With `autoprefixer`, when you want to support the last four versions — you’re all done without having to write any vendor prefixes in your CSS files!

```JavaScript
const autoprefixer = require('autoprefixer')({
    browsers: [
	'last 4 versions',
	'not ie < 9'
    ]
});
```

#### Use configs for consistent designs

Apart from `mixin`s, you also have the option to use variables. In conjunction with a linter, you can enforce design rules.

```SCSS
// Font definitions
$font-12: 12px;
$font-21: 21px;

// Color definitions
$color-white: #FAFAFA;
$color-black: #212121;
```

## 4. Use Markup Instead of CSS

Now let’s move on to actual CSS. This is often overlooked. Usually, you can reduce the size of your CSS bundles by simply using the correct HTML elements. Say you have a heading with the following set of rules:

```CSS
span.heading {
    display: block;
    font-size: 1.2em;
    margin-top: 1em;
    margin-bottom: 1em; 
}
```

You’re using a `span` element as a header. You override the default display, spacing or font style. This can be avoided by using an `h1`, `h2`, or `h3` instead. By default, they have the styles you’re trying to achieve with other elements. You can immediately get rid of four unnecessary rules.

## 5. Use Shorthand Properties

To further reduce the number of rules, always try to go with [shorthand properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Shorthand_properties). For the above example, we could have said:

```CSS
.heading {
    margin: 1em 0;
}
```

This is true for other properties such as paddings, borders, or backgrounds.

![Using shorthand properties can greatly reduce the weight of your CSS files](https://cdn-images-1.medium.com/max/2000/1*7KmDiqi1dJ7iQT2TUD87oA.gif)

## 6. Reduce Redundancy

This goes hand in hand with the previous point. Sometimes it’s hard to spot redundancy, especially when repeating rules don’t follow the same order in both selectors. But if your classes differ in just one or two rules, it’s better to outsource those rules and use them as an extra class. Instead of this:

```HTML
<style>
    .warning {
        width: 100%;
        height: 50px;
        background: yellow;
        border-radius: 5px;
    }

    .elevated-warning {
        width: 100%;
        height: 50px;
        font-size: 150%;
        background: yellow;
        box-shadow: 1px 2px 5px #CCC;
        border-radius: 5px;
    }
</style>

<div class="warning">⚠️</div>
<div class="elevated-warning">🚨</div>
```

Try to go with a similar approach:

```HTML
<style>
    .warning {
        width: 100%;
        height: 50px;
        background: yellow;
        border-radius: 5px;
    }

    .warning--elevated {
        font-size: 150%;
        box-shadow: 1px 2px 5px #CCC;
    }
</style>

<div class="warning">⚠️</div>
<div class="warning warning--elevated">🚨</div>
```

## 7. Avoid Complex Selectors

There are two major problems with using complex selectors. First, your increased specificity will not only make it harder to later rewrite existing rules, but also increase the time it takes for the browser to match selectors.

#### Matching selectors

When your browser is trying to interpret selectors and decide which element it matches, they go from [right to left](https://stackoverflow.com/questions/5797014/why-do-browsers-match-css-selectors-from-right-to-left/5813672#5813672). This is faster in terms of performance than doing the other way around. Let’s take the selector below as an example.

```CSS
.deeply .nested .selector span {
    ...
}
```

Your browser will first start from the `span`. It will match all the `span` tags then go to the next one. It will filter out the `span`s that are inside a `.selector` class, and so on.

It’s not recommended to use tags for CSS selectors because it will match for every tag. While the difference can only be measured in a fraction of a millisecond, little things add up. More importantly, it’s good practice to reduce complexity for another reason.

#### Understanding the selector

It’s not only hard for machines to parse, but it’s also hard for humans to do so. Take the following as an example:

```CSS
[type="checkbox"]:checked + [class$="-confirmation"]::after {
    ...
}
```

When do you think the rule above will be applied? This can be simplified by making a custom class and switching it with JavaScript.

```CSS
.confirmation-icon::after {
    ...
}
```

Now it looks much more pleasant. If you still find yourself in need of an overly complicated selector and you believe you have no other option, please leave a comment below explaining your solution.

```CSS
/**
 * Creates a confirmation icon after a checkbox is selected.
 * Select all labels ending with a class name of "-confirmation"
 * that are preceeded by a checked checkbox.
 * PS.: There's no other way to get around this, don't try to fix it.
 **/
.checkbox:checked + label[class$="-confirmation"]::after {
    ...
}
```

## 8. Don’t Remove Outlines

This is one of the most common mistakes developers make when writing CSS. While you may think there’s nothing wrong about removing the highlight that outlines create, in fact, you’re making the site inaccessible. It’s common practice to add this rule as a reset to your CSS.

```CSS
:focus {
    outline: none;
}
```

This way, however, users with only keyboard navigation will have no clue about what they’re focusing on your site.

![](https://cdn-images-1.medium.com/max/2000/1*O46YMp_-UZPNFpQtqXbVYQ.gif)

If the default styling looks bad for your brand, create custom outlines. Just make sure there is some kind of indication when it comes to focusing elements.

## 9. Use Mobile First

When you have to deal with media queries, always use mobile-first. The mobile-first approach means you start writing CSS for small screen devices first and build from there. This is also called progressive enhancement.

This will ensure that you mostly add extra rules to cater for large screen devices, rather than rewriting existing CSS rules. This can reduce the number of rules you end up with.

How can you tell if you use mobile-first? If your media queries use `min-width`, you’re on the right track.

```CSS
/* Mobile-first media query, everything above 600px will get the below styles */
@media (min-width: 600px) {
    /* your CSS rules */
}

/* Non mobile-first media query, everything below 600px will get the below styles */
@media (max-width: 600px) {
    /* your CSS rules */
}
```

## 10. Compress

Lastly, compress your bundles to reduce their size. Compression removes comments and whitespaces your bundles require less bandwidth to fetch.

![before and after compressing a set of rules in CSS](https://cdn-images-1.medium.com/max/2320/1*npjW2mjxVcPkaKse9S97CA.png)

If you haven’t already, enable compression on the server-side as well.

Another great way to further reduce the size of your CSS — **and markup**— is obfuscating class names.

![](https://cdn-images-1.medium.com/max/2000/1*UHDONG8KhB1kcGAFuiDhGw.png)

To achieve this, you have a couple of options based on your project setup:

* **Webpack**: for Webpack, you can use the `[css-loader](https://github.com/webpack-contrib/css-loader)` module.
* **Gulp**: for Gulp, you can use the `[gulp-minify-cssnames](https://www.npmjs.com/package/gulp-minify-cssnames)` plugin.
* **Create your own**: If you don’t have a dedicated package for your project setup, I have a tutorial that shows you how you can create [your own implementation](https://medium.com/swlh/how-i-reduced-my-css-bundle-size-by-more-than-20-76433e7330eb).

## Summary

Following these 10 simple steps will help you to write CSS files that are:

* more lightweight
* easier to maintain
* easier to scale

Not only that, but using utilities such as a predefined color palette or typography rules, will help you create more consistent designs. Your styles will also be more reusable, so you can save time on your next project.

What are some other CSS best practices you follow, but were not mentioned in this article? Let us know in the comments!

Thanks for taking the time to read this article and happy styling!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
