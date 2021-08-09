> * 原文地址：[Creating Stylesheet Feature Flags With Sass !default](https://css-tricks.com/creating-stylesheet-feature-flags-with-sass-default/)
> * 原文作者：[Nathan Babcock](https://css-tricks.com/author/nathanbabcock/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/creating-stylesheet-feature-flags-with-sass-default.md](https://github.com/xitu/gold-miner/blob/master/article/2021/creating-stylesheet-feature-flags-with-sass-default.md)
> * 译者：
> * 校对者：

# Creating Stylesheet Feature Flags With Sass !default

`!default` is a Sass flag that indicates *conditional assignment* to a variable — it assigns a value only if the variable was previously undefined or `null`. Consider this code snippet:

```scss
$variable: 'test' !default;
```

To the Sass compiler, this line says:

> Assign `$variable` to value `'test'`, **but only if** `$variable` is not already assigned.

Here’s the counter-example, illustrating the other side of the `!default` flag’s conditional behavior:

```scss
$variable: 'hello world';
$variable: 'test' !default;
// $variable still contains `hello world`
```

After running these two lines, the value of `$variable` is still `'hello world'` from the original assignment on line 1. In this case, the `!default` assignment on line 2 is ignored since a value has already been provided, and no default value is needed.

## Style libraries and `@use...with`

The primary motivation behind `!default` in Sass is to facilitate the usage of style libraries, and their convenient inclusion into downstream applications or projects. By specifying some of its variables as `!default`, the library can allow the importing application to customize or adjust these values, without completely forking the style library. In other words, `!default` variables essentially function as *parameters* which modify the behavior of the library code.

Sass has a special syntax just for this purpose, which combines a stylesheet import with its related variable overrides:

```scss
// style.scss
@use 'library' with (
  $foo: 'hello',
  $bar: 'world'
);
```

This statement functions *almost* the same as a variable assignment followed by an `@import`, like so:

```scss
// style.scss - a less idiomatic way of importing `library.scss` with configuration
$foo: 'hello';
$bar: 'world';
@import 'library';
```

The important distinction here, and the reason `@use...with` is preferable, is about the *scope* of the overrides. The `with` block makes it crystal clear — to both the Sass compiler and anyone reading the source code — that the overrides apply specifically to variables which are defined and used inside of `library.scss`. Using this method keeps the global scope uncluttered and helps mitigate variable naming collisions between different libraries.

## Most common use case: Theme customization

```scss
// library.scss
$color-primary: royalblue !default;
$color-secondary: salmon !default;


// style.scss
@use 'library' with (
  $color-primary: seagreen,
  $color-secondary: lemonchiffon
);
```

One of the most ubiquitous examples of this feature in action is the implementation of **theming**. A color palette may be defined in terms of Sass variables, with `!default` allowing customization of that color palette while all other styling remains the same (even including mixing or overlaying those colors).

Bootstrap exports its [entire Sass variable API](https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss) with the `!default` flag set on every item, including the theme color palette, as well as other shared values such as spacing, borders, font settings, and even animation easing functions and timings. This is one of the best examples of the flexibility provided by `!default`, even in an extremely comprehensive styling framework.

In modern web apps, this behavior by itself could be replicated using [CSS Custom Properties](https://css-tricks.com/a-complete-guide-to-custom-properties/) with a [fallback parameter](https://css-tricks.com/a-complete-guide-to-custom-properties/#h-custom-property-fallbacks). If your toolchain doesn’t already make use of Sass, modern CSS may be sufficient for the purposes of theming. However, we’ll examine use cases that can *only* be solved by use of the Sass `!default` flag in the next two examples.

## Use case 2: Loading webfonts conditionally

```scss
// library.scss
$disable-font-cdn: false !default;
@if not $disable-font-cdn {
    @import url('https://fonts.googleapis.com/css2?family=Public+Sans&display=swap');
}

// style.scss
@use 'library' with (
  $disable-font-cdn: true
);
// no external HTTP request is made
```

Sass starts to show its strength when it leverages its preprocessor appearance in the CSS lifecycle. Suppose the style library for your company’s design system makes use of a custom webfont. It’s loaded from a Google’s CDN — ideally as quick as it gets — but nevertheless a separate mobile experience team at your company has concerns about page load time; every millisecond matters for their app.

To solve this, you can introduce an optional *boolean* flag in your style library (slightly different from the CSS color values from the first example). With the default value set to `false`, you can check this feature flag in a Sass `@if` statement before running expensive operations such as external HTTP requests. Ordinary consumers of your library don’t even need to know that the option exists — the default behavior works for them and they automatically load the font from the CDN, while other teams have access to the toggle what they need in order to fine tune and optimize page loading.

A CSS variable would not be sufficient to solve this problem — although the `font-family` could be overridden, the HTTP request would have already gone out to load the unused font.

## Use case 3: Visually debugging spacing tokens

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/sass-default-visually-debugging.png?resize=1808%2C468&ssl=1)

[View live demo](https://codepen.io/nathanbabcock/project/editor/AYYygg)

`!default` feature flags can also be used to create debugging tools for use during development. In this example, a visual debugging tool creates color-coded overlays for spacing tokens. The foundation is a set of spacing tokens defined in terms of ascending “t-shirt sizes” (aka “xs”/”extra-small” through “xl”/”extra-large”). From this single token set, a Sass `@each` loop generates every combination of utility classes applying that particular token to padding or margin, on every side (top, right, bottom, and left individually, or all four at once).

Since these selectors are all constructed dynamically in a nested loop, and single `!default` flag can switch the rendering behavior from standard (margin plus padding) to the colored debug view (using transparent borders with the same sizes). This color-coded view may look very similar to the deliverables and wireframes which a designer might hand off for development — especially if you are already sharing the same spacing values between design and dev. Placing the visual debug view side-by-side with the mockup can help quickly and intuitively spot discrepancies, as well as debug more complex styling issues, such as [margin collapse](https://css-tricks.com/what-you-should-know-about-collapsing-margins/) behavior.

Again — by the time this code is compiled for production, none of the debugging visualization will be anywhere in the resulting CSS since it will be completely replaced by the corresponding margin or padding statement.

## Further reading

These are just a few examples of Sass `!default` in the wild. Refer to these documentation resources and usage examples as you adapt the technique to your own variations.

* [`!default` documentation](https://sass-lang.com/documentation/variables#default-values)
* [`@use with` documentation](https://sass-lang.com/documentation/at-rules/use#configuration)
* [Bootstrap variable defaults](https://getbootstrap.com/docs/4.0/getting-started/theming/#variable-defaults)
* [A Sass `default` use case](https://thoughtbot.com/blog/sass-default) (thoughtbot)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
