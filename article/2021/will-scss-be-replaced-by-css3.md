> * 原文地址：[Will SCSS be replaced by CSS3?](https://blog.bitsrc.io/will-scss-be-replaced-by-css3-754842d6b681)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/will-scss-be-replaced-by-css3.md](https://github.com/xitu/gold-miner/blob/master/article/2021/will-scss-be-replaced-by-css3.md)
> * 译者：
> * 校对者：

# Will SCSS be replaced by CSS3?

## Should We Use CSS or SCSS in 2021?

#### With the continuously improving CSS over the years, is SCSS relevant anymore? Let’s find out.

![](https://cdn-images-1.medium.com/max/5760/1*iiuMRihN7Lj3i1-hTk8PjA.jpeg)

When it comes to the domain of styling web pages, we have the choice of using plain CSS or SCSS in a project (among other preprocessors). SCSS is a superset of CSS. Most developers find it more convenient to use it over CSS due to its advanced features and clearer syntax.

---

In this article, I want to explore the SCSS features and improvements in CSS over the years. In addition to that, I will evaluate whether CSS is ready as a replacement for SCSS in practice.

## What CSS offers today

CSS has come a long way since its early days. The recent developments in CSS also eliminate the need to use JavaScript for animations. Modern browsers even utilize GPUs to improve the performance of these animations when we perform them in CSS. We can also create complex and responsive grid layouts with CSS, with a minimal footprint.

While there are many new CSS features, I want to emphasize the new features we often use in modern web applications.

* In any web application, the primary building block of the page is the page layout. While many of us relied on CSS frameworks like Bootstrap for many years, CSS now offers Grid, Subgrid, and Flexbox to structure the layout natively in a web page. While Flexbox is widely popular among developers, Grid is catching up.
* Typographic flexibilities.
* Power of Transitions and Transforms will take out the need for JavaScript for Animations.
* Custom properties /variable support. That feature is especially important when sharing and reusing CSS components using tools like [Bit](https://bit.dev) ([Github](https://bit.dev)). They allow us to compose themes — sizes, color palettes, fonts, etc — these are all components that can be used independently or composed to form a full theme.

---

![Exploring components on [Bit.dev](https://bit.dev)](https://cdn-images-1.medium.com/max/2000/1*T6i0a9d9RykUYZXNh2N-DQ.gif)

## Features of SCSS

#### SCSS allows variables — Avoid repeating!

We re-use a lot of colors and other elements such as fonts in our styling code. In order to declare these re-used properties in one place, SCSS offers variables. This gives us the ability to define a color under a variable name and use the variable name everywhere in the project rather than repeating the color value.

Let’s have a look at an example.

```
$black: #00000;
$primary-font: $ubuntu-font: 'Ubuntu', 'Helvetica', sans-serif;
$unit: 1rem;

body {
  color: $black;
  font-family: $primary-font;
  padding: #{$unit * 2};
}
```

CSS lets us use variables as well using custom properties. This is how custom properties in CSS would look like.

```
--black: #00000;
--width: 800px;
--primaryFont: $ubuntu-font: 'Ubuntu', 'Helvetica', sans-serif;

body {
  width: var(--width);
  color: var(--black);
  font-family: var(--primaryFont);
}
```

> # However, CSS custom properties are expensive at run-time than SCSS variables.

The reason being they are processed by the browser during runtime. Opposed to that, SCSS variables are determined at the pre-processing stage when SCSS is converted to CSS. Therefore, **the use of variables and code re-use is better in performance with SCSS**.

#### SCSS allows nested syntax — Cleaner source code😊

If we consider a block of code in CSS such as,

```
.header {
  padding: 1rem;
  border-bottom: 1px solid grey;
}

.header .nav {
  list-style: none;
}

.header .nav li {
  display: inline-flex;
}

.header .nav li a {
  display: flex;
  padding: 0.5rem;
  color: red;
}
```

The above code seems cluttered with the same parent class having to repeat in order to apply styling for the child classes.

However, with SCSS you can use a nested syntax that produces much cleaner code. The above code in SCSS would look like the following.

```
.header {
  padding: 1rem;
  border-bottom: 1px solid grey;

  .nav {
    list-style: none;

    li {
      display: inline-flex;

      a {
        display: flex;
        padding: 0.5rem;
        color: red;
      }
      
    }

  }

}
```

Therefore, styling your components using SCSS than conventional CSS seems much better and cleaner.

#### @extend feature — Avoid repeating the same styles!

In SCSS you can use`@extend` to share properties between one selector and another. The use `@extend` with placeholders would look like the following.

```
%unstyled-list {
  list-style: none;
  margin: 0;
  padding: 0;
}
```

`%unstyled-list` is a placeholder that can be used to avoid code repetition when you need to use the above list styling pattern in multiple places.

```
.search-results {
  @extend %unstyled-list;
}

.advertisements {
  @extend %unstyled-list;
}

.dashboard {
  @extend %unstyled-list;
}
```

Likewise, you can re-use this pattern in all your stylesheets.

---

There are a lot more features in SCSS like [functions](https://sass-lang.com/documentation/at-rules/function), [mixins](https://sass-lang.com/documentation/at-rules/mixin), [loops](https://sass-lang.com/documentation/at-rules/control/for), etc., which makes the life of a frontend developer easier.

## Should we switch to CSS from SCSS?

We have been exploring what CSS offers today and the features of SCSS so far. However, if we compare CSS with SCSS, we can find a few essential features that are not yet available in CSS at the moment.

* With the growth of a web application, stylesheets tend to become complex and larger. The ability to nest CSS would come as a life savior for everyone in such a project to improve readability. However, as of writing this article, CSS does not support that.
* CSS isn’t capable of handling flow control rules. SCSS provides @if, @else, @each, $for, and @while flow control rules out of the box. As a programmer, I find this highly useful when it comes to emitting styles. This also allows you to write less and cleaner code.
* Out of the box, SCSS supports the standard set of numeric operators for numbers wherein CSS you have to use `calc()` function for numeric operations. SCSS numeric operations will automatically convert between compatible units.

> # However, `calc()` function of CSS has few limitations such as with division, the right-hand side must be a number and for multiplication at least one of the arguments must be a number.

* The other important aspect is the style reuse which is a stronghold for SCSS. For example, SCSS provides many features such as built-in modules, maps, loops, and variables to reuse styles.

Therefore, in my opinion, even with the latest features of CSS, SCSS remains the better option. Let me know your thoughts in the comments below.

I hope you enjoyed the article. Thanks for reading!

## Learn More
[**Improve Page Rendering Speed Using Only CSS**
**4 Important CSS tips for faster page rendering**blog.bitsrc.io](https://blog.bitsrc.io/improve-page-rendering-speed-using-only-css-a61667a16b2)
[**How we Build a Design System**
**Building a design system with components to standardize and scale our UI development process.**blog.bitsrc.io](https://blog.bitsrc.io/how-we-build-our-design-system-15713a1f1833)
[**CSS Clamp(): The Responsive Combination We’ve All Been Waiting For**
**Bringing Together the Best of the CSS min() and CSS max() Functions**blog.bitsrc.io](https://blog.bitsrc.io/css-clamp-the-responsive-combination-weve-all-been-waiting-for-f1ce1981ea6e)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
