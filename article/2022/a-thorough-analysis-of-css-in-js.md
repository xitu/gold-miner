> * 原文地址：[A Thorough Analysis of CSS-in-JS](https://css-tricks.com/a-thorough-analysis-of-css-in-js/)
> * 原文作者：[Andrei Pfeiffer](https://css-tricks.com/author/andreipfeiffer/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/a-thorough-analysis-of-css-in-js.md](https://github.com/xitu/gold-miner/blob/master/article/2022/a-thorough-analysis-of-css-in-js.md)
> * 译者：
> * 校对者：

# A Thorough Analysis of CSS-in-JS

DigitalOcean provides cloud products for every stage of your journey. Get started with [$200 in free credit!](https://try.digitalocean.com/css-tricks/?utm_medium=content_acq&utm_source=css-tricks&utm_campaign=global_brand_ad_en&utm_content=conversion_prearticle_everystage)

Wondering what’s even more challenging than choosing a JavaScript framework? You guessed it: choosing a CSS-in-JS solution. Why? Because there are more than [50 libraries](http://michelebertoli.github.io/css-in-js/) out there, each of them offering a unique set of features.

We tested [10 different libraries](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#overview), which are listed here in no particular order: [Styled JSX](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-jsx), [styled-components](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-components), [Emotion](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#emotion), [Treat](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat), [TypeStyle](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#typestyle), [Fela](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#fela), [Stitches](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#stitches), [JSS](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#jss), [Goober](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#goober), and [Compiled](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#compiled). We found that, although each library provides a diverse set of features, many of those features are actually commonly shared between most other libraries.

So instead of reviewing each library individually, we’ll analyse the features that stand out the most. This will help us to better understand which one fits best for a specific use case.

**Note**: We assume that if you’re here, you’re already familiar with CSS-in-JS. If you’re looking for a more elementary post, you can check out [“An Introduction to CSS-in-JS.”](https://webdesign.tutsplus.com/articles/an-introduction-to-css-in-js-examples-pros-and-cons--cms-33574)

## Common CSS-in-JS features

Most actively maintained libraries that tackle CSS-in-JS support all the following features, so we can consider them de-facto.

### Scoped CSS

All CSS-in-JS libraries generate unique CSS class names, a technique pioneered by **CSS modules**. All styles are scoped to their respective component, providing encapsulation without affecting any styling defined outside the component.

With this feature built-in, we never have to worry about CSS class name collisions, specificity wars, or wasted time spent coming up with unique class names across the entire codebase.

This feature is invaluable for component-based development.

### SSR (Server-Side Rendering)

When considering Single Page Apps (SPAs) — where the HTTP server only delivers an initial empty HTML page and all rendering is performed in the browser — Server-Side Rendering (SSR) might not be very useful. However, any website or application that needs to be **parsed and indexed by search engines** must have SSR pages and styles need to be generated on the server as well.

The same principle applies to Static Site Generators (SSG), where pages along with any CSS code are pre-generated as static HTML files at build time.

The good news is that **all libraries we’ve tested support SSR**, making them eligible for basically any type of project.

### Automatic vendor prefixes

Because of the complex [CSS standardization process](https://www.youtube.com/watch?v=TQ7NqpFMbFs), it might take years for any new CSS feature to become available in all popular browsers. One approach aimed at providing early access to experimental features is to ship non-standard CSS syntax under a [vendor prefix](https://developer.mozilla.org/en-US/docs/Glossary/Vendor_Prefix):

```css
/* WebKit browsers: Chrome, Safari, most iOS browsers, etc */
-webkit-transition: all 1s ease;

/* Firefox */
-moz-transition: all 1s ease;

/* Internet Explorer and Microsoft Edge */
-ms-transition: all 1s ease;

/* old pre-WebKit versions of Opera */
-o-transition: all 1s ease;

/* standard */
transition: all 1s ease; 
```

However, it turns out that [vendor prefixes are problematic](https://css-tricks.com/is-vendor-prefixing-dead/) and the CSS Working Group intends to stop using them in the future. If we want to fully support older browsers that don’t implement the standard specification, we’ll need to know [which features require a vendor prefix](http://shouldiprefix.com/).

Fortunately, there are tools that allow us to use the standard syntax in our source code, generating the required vendor prefixed CSS properties automatically. **All CSS-in-JS libraries also provide this feature out-of-the-box.**

### No inline styles

There are some CSS-in-JS libraries, like Radium or Glamor, that output all style definitions as inline styles. This technique has a huge limitation, because it’s impossible to define pseudo classes, pseudo-elements, or media queries using inline styles. So, these libraries had to hack these features by adding DOM event listeners and triggering style updates from JavaScript,  essentially reinventing native CSS features like `:hover`, `:focus` and many more.

It’s also generally accepted that inline styles are [less performant](https://esbench.com/bench/5908f78199634800a0347e94) than class names. It’s usually a [discouraged practice](https://reactjs.org/docs/dom-elements.html#style) to use them as a primary approach for styling components.

**All current CSS-in-JS libraries have stepped away from using inline styles**, adopting CSS class names to apply style definitions.

### Full CSS support

A consequence of using CSS classes instead of inline styles is that there’s no limitation regarding what [CSS properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference) we can and can’t use. During our analysis we were specifically interested in:

* pseudo classes and elements;
* media queries;
* keyframe animations.

**All the libraries we’ve analyzed offer full support for all CSS properties.**

## Differentiating features

This is where it gets even more interesting. Almost every library offers a unique set of features that can highly influence our decision when choosing the appropriate solution for a particular project. Some libraries pioneered a specific feature, while others chose to borrow or even improve certain features.

### React-specific or framework-agnostic?

It’s not a secret that CSS-in-JS is more prevalent within the React ecosystem. That’s why some libraries are **specifically built for React**: [**Styled JSX**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-jsx), [**styled-components**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-components), and [**Stitches**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#stitches).

However, there are plenty of libraries that are **framework-agnostic**, making them applicable to any project: [**Emotion**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#emotion), [**Treat**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat), [**TypeStyle**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#typestyle), [**Fela**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#fela), [**JSS**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#jss) or [**Goober**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#goober).

If we need to support vanilla JavaScript code or frameworks other than React, the decision is simple: we should choose a framework-agnostic library. But when dealing with a React application, we have a much wider range of options which ultimately makes the decision more difficult. So let’s explore other criteria.

### Styles/Component co-location

The ability to define styles along with their components is a very convenient feature, removing the need to switch back-and-forth between two different files: the `.css` or `.less`/`.scss` file containing the styles and the component file containing the markup and behavior.

[React Native StyleSheets](https://reactnative.dev/docs/stylesheet), [Vue.js SFCs](https://vuejs.org/v2/guide/single-file-components.html), or [Angular Components](https://angular.io/guide/component-styles) support co-location of styles by default, which proves to be a real benefit during both the development and the maintenance phases. We always have the option to extract the styles into a separate file, in case we feel that they’re obscuring the rest of the code.

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/aKsPahlPZ8qr6R8aVCancNsC_LOuKlcpBo-Ys44a1ya3QDvoLabbiBTYf36xX90hAfgMxgvBjMxxuBgIGnzH-_NId-71NfK7hh-ZFBJizZF6l3A4sLgb2vyYKgwnod86YBoLsE4.png?resize=800%2C589&ssl=1)

Almost all CSS-in-JS libraries support co-location of styles. The only exception we encountered was [**Treat**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat), which requires us to define the styles in a separate `.treat.ts` file, similarly to how CSS Modules work.

### Styles definition syntax

There are two different methods we can use to define our styles. Some libraries support only one method, while others are quite flexible and support both of them.

#### Tagged Templates syntax

The **Tagged Templates** syntax allows us to define styles as a string of plain CSS code inside a standard [ES Template Literal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals):

```js
// consider "css" being the API of a generic CSS-in-JS library
const heading = css`
  font-size: 2em;
  color: ${myTheme.color};
`;
```

We can see that:

* CSS properties are written in kebab case just like regular CSS;
* JavaScript values can be interpolated;
* we can easily migrate existing CSS code without rewriting it.

Some things to keep in mind:

* In order to get **syntax highlight** and **code suggestions,** an additional editor plugin is required; but this plugin is usually available for popular editors like VSCode, WebStorm, and others.
* Since the final code must be eventually executed in JavaScript, the style definitions need to be **parsed and converted to JavaScript code**. This can be done either at runtime, or at build time, incurring a small overhead in bundle size, or computation.

#### Object Styles syntax

The **Object Styles** syntax allows us to define styles as regular JavaScript Objects:

```js
// consider "css" being the API of a generic CSS-in-JS library
const heading = css({
  fontSize: "2em",
  color: myTheme.color,
});
```

We can see that:

* CSS properties are written in camelCase and string values must be wrapped in quotes;
* JavaScript values can be referenced as expected;
* it doesn’t feel like writing CSS, as instead we define **styles** using a slightly different syntax but with the same property names and values available in CSS (don’t feel intimidated by this, you’ll get used to it in no time);
* migrating existing CSS would require a rewrite in this new syntax.

Some things to keep in mind:

* **Syntax highlighting** comes out-of-the-box, because we’re actually writing JavaScript code.
* To get **code completion**, the library must ship CSS types definitions, most of them extending the popular [CSSType](https://www.npmjs.com/package/csstype) package.
* Since the styles are already written in JavaScript, there’s no additional parsing or conversion required.

| Library | Tagged template | Object styles |
| --- | --- | --- |
| styled-components | ✅ | ✅ |
| Emotion | ✅ | ✅ |
| Goober | ✅ | ✅ |
| Compiled | ✅ | ✅ |
| Fela | 🟠 | ✅ |
| JSS | 🟠 | ✅ |
| Treat | ❌ | ✅ |
| TypeStyle | ❌ | ✅ |
| Stitches | ❌ | ✅ |
| Styled JSX | ✅ | ❌ |

> ✅  Full support         🟠  Requires plugin          ❌  Unsupported

### Styles applying method

Now that we know what options are available for style definition, let’s have a look at how to apply them to our components and elements.

#### Using a class attribute / className prop

The easiest and most intuitive way to apply the styles is to simply attach them as classnames. Libraries that support this approach provide an API that returns a string which will output the generated unique classnames:

```js
// consider "css" being the API of a generic CSS-in-JS library
const heading_style = css({
  color: "blue"
});
```

Next, we can take the `heading_style`, which contains a string of generated CSS class names, and apply it to our HTML element:

```js
// Vanilla DOM usage
const heading = `<h1 class="${heading_style}">Title</h1>`;

// React-specific JSX usage
function Heading() {
  return <h1 className={heading_style}>Title</h1>;
}
```

As we can see, this method pretty much resembles the traditional styling: first we define the styles, then we attach the styles where we need them. The learning curve is low for anyone who has written CSS before.

#### Using a `<Styled />` component

Another popular method, that was first introduced by the [styled-components](https://styled-components.com/docs/basics#getting-started) library (and named after it), takes a different approach.

```js
// consider "styled" being the API for a generic CSS-in-JS library
const Heading = styled("h1")({
  color: "blue"
});
```

Instead of defining the styles separately and attaching them to existing components or HTML elements, we use a special API by specifying what type of element we want to create and the styles we want to attach to it.

The API will **return a new component,** having classname(s) already applied, that we can render like any other component in our application. This basically removes the mapping between the component and its styles.

#### Using the `css` prop

A newer method, popularised by [Emotion](https://emotion.sh/docs/css-prop), allows us to pass the styles to a special prop, usually named `css`. This API is available only for JSX-based syntax.

```js
// React-specific JSX syntax
function Heading() {
  return <h1 css={{ color: "blue" }}>Title</h1>;
}
```

This approach has a certain ergonomic benefit, because we don’t have to import and use any special API from the library itself. We can simply pass the styles to this `css` prop, similarly to how we would use inline styles.

Note that this custom `css` prop is not a standard HTML attribute, and needs to be enabled and supported via a separate Babel plugin provided by the library.

| Library | Tagged template | Object styles |
| --- | --- | --- |
| styled-components | ✅ | ✅ |
| Emotion | ✅ | ✅ |
| Goober | ✅ | ✅ |
| Compiled | ✅ | ✅ |
| Fela | 🟠 | ✅ |
| JSS | 🟠 | ✅ |
| Treat | ❌ | ✅ |
| TypeStyle | ❌ | ✅ |
| Stitches | ❌ | ✅ |
| Styled JSX | ✅ | ❌ |
 
> ✅  Full support         🟠  Requires plugin          ❌  Unsupported

| Library | `className` | `<Styled />` | `css` prop |
| --- | --- | --- | --- |
| styled-components | ❌ | ✅ | ✅ |
| Emotion | ✅ | ✅ | ✅ |
| Goober | ✅ | ✅ | 🟠 2 |
| Compiled | 🟠 1 | ✅ | ✅ |
| Fela | ✅ | ❌ | ❌ |
| JSS | ✅ | 🟠 2 | ❌ |
| Treat | ✅ | ❌ | ❌ |
| TypeStyle | ✅ | ❌ | ❌ |
| Stitches | ✅ | ✅ | 🟠 1 |
| Styled JSX | ✅ | ❌ | ❌ |

> ✅  Full support          🟠 1  Limited support          🟠 2  Requires plugin          ❌  Unsupported

### Styles output

There are two mutually exclusive methods to generate and ship styles to the browser. Both methods have benefits and downsides, so let’s analyze them in detail.

#### `<style>`-injected DOM styles

Most CSS-in-JS libraries inject styles into the DOM at runtime, using either one or more [`<style>` tags](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#1-using-style-tags), or using the [`CSSStyleSheet`](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#2-using-cssstylesheet-api) API to manage styles directly within the CSSOM. During SSR, styles are always appended as a `<style>` tag inside the `<head>` of the rendered HTML page.

There are a few **key advantages** and **preferred use cases** for this approach:

1. Inlining the styles during SSR provides an [increase in page loading performance metrics](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#2-style-tag-injected-styles) such as **FCP** (First Contentful Paint), because rendering is not blocked by fetching a separate `.css` file from the server.
2. It provides out-of-the-box [**critical CSS extraction**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#-critical-css-extraction) during SSR by inlining only the styles required to render the initial HTML page. It also removes any dynamic styles, thus further improving loading time by downloading less code.
3. **Dynamic styling** is usually easier to implement, as this approach appears to be more suited for highly interactive user interfaces and **Single-Page Applications** (SPA), where most components are **client-side rendered**.

The drawbacks are generally related to the total bundle size:

* an additional **runtime library** is required for handling dynamic styling in the browser;
* the inlined SSR styles won’t be cached out-of-the-box and they will need to be shipped to the browser upon each request since they’re part of the `.html` file rendered by the server;
* the SSR styles that are inlined in the `.html` page will be sent to the browser again as JavaScript resources during the [rehydration](https://developers.google.com/web/updates/2019/02/rendering-on-the-web#rehydration-issues) process.

#### Static `.css` file extraction

There’s a very small number of libraries that take a totally different approach. Instead of injecting the styles in the DOM, they generate static `.css` files. From a loading performance point of view, we get the same advantages and drawbacks that come with writing plain CSS files.

1. The **total amount of shipped code is much smaller**, since there is no need for additional runtime code or rehydration overhead.
2. Static `.css` files benefit from out-of-the-box caching inside the browser, so subsequent requests to the same page won’t fetch the styles again.
3. This approach seems to be more appealing when dealing with **SSR pages** or **Static Generated pages** since they benefit from default caching mechanisms.

However, there are some important drawbacks we need to take note of:

* The first visit to a page, with an empty cache, will [usually have a longer **FCP**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#1-css-file-extraction) when using this method compared to the one mentioned previously; so deciding if we want to optimize for **first-time users** or **returning visitors** could play a crucial role when choosing this approach.
* All dynamic styles that can be used on the page will be included in the pre-generated bundle, potentially leading to larger `.css` resources that need to be loaded up front.

Almost all the libraries that we tested implement the first method, injecting the styles into the DOM. The only tested library which supports static `.css` file extraction is [Treat](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat). There are other libraries that support this feature, like [Astroturf](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#astroturf), [Linaria](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#linaria), and [style9](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#style9), which were not included in our final analysis.

### Atomic CSS

Some libraries took optimizations one step further, implementing a technique called [**atomic CSS-in-JS**](https://sebastienlorber.com/atomic-css-in-js), inspired by frameworks such as [Tachyons](https://tachyons.io/) or [Tailwind](https://tailwindcss.com/).

Instead of generating CSS classes containing all the properties that were defined for a specific element, they generate a unique CSS class for each unique CSS property/value combination.

```css
/* classic, non-atomic CSS class */
._wqdGktJ {
  color: blue;
  display: block;
  padding: 1em 2em;
}

/* atomic CSS classes */
._ktJqdG { color: blue; }
._garIHZ { display: block; }
/* short-hand properties are usually expanded */
._kZbibd { padding-right: 2em; }
._jcgYzk { padding-left: 2em; }
._ekAjen { padding-bottom: 1em; }
._ibmHGN { padding-top: 1em; }
```

This enables a high degree of reusability because each of these individual CSS classes can be reused anywhere in the code base.

In theory, this works really great in the case of large applications. Why? Because there’s a finite number of unique CSS properties that are needed for an entire application. Thus, the scaling factor is not linear, but rather **logarithmic**, resulting in less CSS output compared to non-atomic CSS.

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/kwyuFPAdFlkMaYo7vYFufdUG3WP4mp7_bbAsQnU7sVCnGH31dDmSgYp5KHqX4tQQR60KfzWV890kBXDPC68H4rLuYvMeVEhItg_oBFt59mCJmsN8giiB6HogBD9F7h6p2aMbs7Q.png?resize=800%2C449&ssl=1)

But there is a catch: individual class names must be applied to each element that requires them, resulting in slightly larger HTML files:

```html
<!-- with classic, non-atomic CSS classes -->
<h1 class="_wqdGktJ">...</h1>

<!-- with atomic CSS classes -->
<h1 class="_ktJqdG _garIHZ _kZbibd _jcgYzk _ekAjen _ibmHGN">...</h1>
```

So basically, we’re moving code from CSS to HTML. The resulting difference in size depends on too many aspects for us to draw a definite conclusion, but generally speaking, it **should decrease** the total amount of bytes shipped to the browser.

## Conclusion

CSS-in-JS will dramatically change the way we author CSS, providing many benefits and improving our overall development experience.

However, choosing which library to adopt is not straightforward and all choices come with many technical compromises. In order to identify the library that is best suited for our needs, we have to understand the project requirements and its use cases:

* **Are we using React or not?** React applications have a wider range of options, while non-React solutions have to use a framework agnostic library.
* **Are we dealing with a highly interactive application, with client-side rendering?** In this case, we probably aren’t very concerned about the overhead of rehydration, or care that much about extracting static `.css` files.
* **Are we building a dynamic website with SSR pages?** Then, extracting static `.css` files may probably be a better option, as it would allow us to benefit from caching.
* **Do we need to migrate existing CSS code?** Using a library that supports Tagged Templates would make the migration easier and faster.
* **Do we want to optimize for first-time users or returning visitors?** Static `.css` files offer the best experience for returning visitors by caching the resources, but the first visit requires an additional HTTP request that blocks page rendering.
* **Do we update our styles frequently?** All cached `.css` files are worthless if we frequently update our styles, thus invalidating any cache.
* **Do we re-use a lot of styles and components?** Atomic CSS shines if we reuse a lot of CSS properties in our codebase.

Answering the above questions will help us decide what features to look for when choosing a CSS-in-JS solution, allowing us to make more educated decisions.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
