> * 原文地址：[A Unified Styling Language](https://medium.com/seek-blog/a-unified-styling-language-d0c208de2660)
> * 原文作者：[Mark Dalgleish](https://medium.com/@markdalgleish)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# A Unified Styling Language

In the past few years we’ve seen the rise of [CSS-in-JS](https://github.com/MicheleBertoli/css-in-js), emerging primarily from within the [React](https://facebook.github.io/react) community. This, of course, hasn’t been without its controversies. Many people, particularly those already intimately familiar with CSS, have looked on in disbelief.

> “Why would anyone want to write CSS in JS?

> Surely this is a terrible idea!

> If only they’d learn CSS!”

If this was your reaction, then read on. We’re going to take a look at why writing your styles in JavaScript isn’t such a terrible idea after all, and why I think you should be keeping an eye on this rapidly evolving space.

![](https://cdn-images-1.medium.com/max/2000/1*Ipu5Grtzr21suPiTfvGXaw.png)

### Misunderstood communities

The React community is often misunderstood by the CSS community, and vice versa. This is particularly interesting for me, as I’m caught somewhere between these two worlds.

I started learning HTML in the late nineties, and I’ve been working with CSS professionally since the dark ages of table-based layouts. Inspired by [CSS Zen Garden](http://www.csszengarden.com), I was on the front lines of migrating existing codebases towards [semantic markup](https://en.wikipedia.org/wiki/Semantic_HTML) and cascading style sheets. It wasn’t long after this that I became obsessed with separating our concerns, using [unobtrusive JavaScript](https://www.w3.org/wiki/The_principles_of_unobtrusive_JavaScript) to decorate our server-rendered markup with client-side interactions. There was a small but vibrant community surrounding these practices, and we became the first generation of front-end developers, trying to give the browser platform the respect it deserved.

With a web-focused background like this, you might imagine that I’d be vehemently opposed to React’s [_HTML-in-JS_](https://facebook.github.io/react/docs/jsx-in-depth.html) model, which seemingly goes against the principles we held so dear—but in fact, it’s quite the opposite. In my experience, React’s component model, coupled with its ability to render server-side, finally gives us a way to build complex single-page apps at scale, in a way that still allows us to ship fast, accessible, progressively enhanced products to our users. We’ve even leveraged this ability here at [SEEK](https://www.seek.com.au), our flagship product being a single-page React app where the core search flow still works when JavaScript is disabled—gracefully degrading to a traditional web site by running the same JavaScript code on the server.

So, consider this an olive branch from one community to another. Together, let’s try and understand what this movement is all about. It might not be _perfect,_ it might not be something you plan to use in your products, it might not even be terribly convincing for you—but it’s at least worth trying to wrap your head around.

### Why CSS-in-JS?

If you’re familiar with my recent work with React and [CSS Modules](https://github.com/css-modules/css-modules), you may be surprised to see me defending CSS-in-JS.

![](https://cdn-images-1.medium.com/max/1600/1*RtAMWbxdwW2ujyrurU9plw.png)

After all, CSS Modules is typically chosen by developers who want locally-scoped styles _without_ buying in to CSS-in-JS. In fact, I don’t even use CSS-in-JS in my own work.

Despite this, I continue to maintain a keen interest in the CSS-in-JS community, keeping a close eye on the innovations that they continually come up with. Not only that, _I think the broader CSS community should be interested too._

But why?

To get a clearer understanding of why people are choosing to write their styles in JavaScript, we’ll focus on the practical benefits that emerge when taking this approach.

I’ve broken this down into five major areas:

1.  Scoped styles
2.  Critical CSS
3.  Smarter optimisations
4.  Package management
5.  Non-browser styling

Let’s break this down further and have a closer look at what CSS-in-JS brings to the table for each of these points.

### 1.

#### **Scoped styles**

It’s no secret that architecting CSS effectively at scale is incredibly difficult. When joining an existing long-lived project, it wasn’t uncommon to find that the CSS was the hardest part of the system to figure out.

To counter this, the CSS community has invested heavily in trying to address these issues, making our styles more maintainable with methodologies like [OOCSS](https://github.com/stubbornella/oocss/wiki) by [Nicole Sullivan](https://twitter.com/stubbornella) and [SMACSS](https://smacss.com/) by [Jonathan Snook](https://twitter.com/snookca)—but the clear winner right now in terms of popularity seems to be [BEM](http://getbem.com), or Block Element Modifier, from [Yandex](https://github.com/yandex).

Ultimately, BEM (when applied purely to CSS) is just a naming convention, opting to limit styles to classes following a `.Block__element--modifier` pattern. In any given BEM-styled codebase, developers have to remember to follow BEM’s rules at all times. When strictly followed, BEM works really well, but why is something as fundamental as scoping left up to pure _convention?_

Whether they explicitly say so or not, the majority of CSS-in-JS libraries are following the BEM mindset of trying to target styles to individual UI elements, but implementing it in a radically different way.

What does this look like in practice? When using [glamor](https://github.com/threepointone/glamor) by [Sunil Pai](https://twitter.com/threepointone), it looks something like this:

```
import { css } from 'glamor'
const title = css({
  fontSize: '1.8em',
  fontFamily: 'Comic Sans MS',
  color: 'blue'
})
console.log(title)
// → 'css-1pyvz'
```

What you’ll notice here is that _the CSS class is nowhere to be found in our code._ It’s no longer a hard-coded reference to a class defined elsewhere in the system. Instead, it is generated automatically for us by the library. We don’t have to worry about our selectors clashing in the global scope, which means we no longer have to manually prefix them.

The scoping of this selector matches the scoping rules of the surrounding code. If you want to make this rule available to the rest of your application, you’ll need to turn it into a JavaScript module and import it wherever it’s used. In terms of keeping our codebases maintainable over time, this is incredibly powerful, _making sure that the source of any given style can be easily traced like any other code._

**_By moving from mere convention towards enforcing locally-scoped styles by default, we’ve now improved the baseline quality of our styles. BEM is baked in, not opt-in._**

—

Before I continue, there’s a critically important point to clarify.

**_This is generating real CSS, not inline styles._**

Most of the earliest CSS-in-JS libraries attached styles directly to each element, but the critical flaw in this model is that ‘style’ attributes can’t do everything that CSS can do. Most new libraries instead focus on _dynamic style sheets,_ inserting and removing rules at runtime from a global set of styles.

As an example, let’s have a look at [JSS](https://github.com/cssinjs/jss) by [Oleg Slobodskoi](https://twitter.com/oleg008), one of the earliest CSS-in-JS libraries to generate _real CSS._

![](https://cdn-images-1.medium.com/max/1600/1*ltBvwbyvBt8OMdGZQOdMDA.png)

When using JSS, you can use standard CSS features like hover styles and media queries, which map directly to the equivalent CSS rules.

```
const styles = {
  button: {
    padding: '10px',
    '&:hover': {
      background: 'blue'
    }
  },
  '@media (min-width: 1024px)': {
    button: {
      padding: '20px'
    }
  }
}
```

Once you insert these styles into the document, the automatically generated classes are provided to you.

```
const { classes } = jss.createStyleSheet(styles).attach()
```

These generated classes can then be used instead of hard-coded class strings when generating markup in JavaScript. This pattern works regardless of whether you’re using a full-blown framework, or something as simple as _innerHTML._

```
document.body.innerHTML = `
  <h1 class="${classes.heading}">Hello World!</h1>
`
```

Managing the styles in this way is of little benefit by itself—it’s usually paired with some kind of component library. As a result, it’s typical to find bindings available for the most popular libraries. For example, JSS can easily bind to React components with the help of [react-jss](https://github.com/cssinjs/react-jss), injecting a small set of styles into each component while managing the global lifecycle for you.

```
import injectSheet from 'react-jss'
const Button = ({ classes, children }) => (
  <button className={classes.button}>
    <span className={classes.label}>
      {children}
    </span>
  </button>
)
export default injectSheet(styles)(Button)
```

By focusing our styles around components, integrating them more closely at the code level, we’re effectively taking BEM to its logical conclusion. So much so that many in the CSS-in-JS community felt like the importance of extracting, naming and reusing components was being lost in all the style-binding boilerplate.

An entirely new way of thinking about this problem emerged with the introduction of [styled-components](https://github.com/styled-components/styled-components) by [Glen Maddern](https://twitter.com/glenmaddern) and [Max Stoiber](https://twitter.com/mxstbr).

![](https://cdn-images-1.medium.com/max/1600/1*l4nfMFKxfT4yNTWUK2Vsdg.png)

Instead of creating styles, which we then have to manually bind to components, we’re forced to create components directly.

```
import styled from 'styled-components'

const Title = styled.h1`
  font-family: Comic Sans MS;
  color: blue;
`
```

When applying these styles, we don’t attach a class to an existing element. We simply render the generated component.

```
<Title>Hello World!</Title>
```

While styled-components uses traditional CSS syntax via tagged template literals, others prefer working with data structures instead. A notable alternative is [Glamorous](https://github.com/paypal/glamorous) by [Kent C. Dodds](https://twitter.com/kentcdodds) from [PayPal](https://github.com/paypal).

![](https://cdn-images-1.medium.com/max/1600/1*Ere9GQTIJeNac2ONfZlfdw.png)

Glamorous offers the same component-first API as styled-components, but opts for _objects_ instead of _strings,_ eliminating the need to include a CSS parser in the library—reducing the library’s size and performance footprint.

```
import glamorous from 'glamorous'

const Title = glamorous.h1({
  fontFamily: 'Comic Sans MS',
  color: 'blue'
})
```

Whichever syntax you use to describe your styles, they’re no longer just _scoped_ to components—_they’re inseparable from them._ When using a library like React, components are the fundamental building blocks, and now our styles form a core part of that architecture. _If we describe everything in our app as components, why not our styles too?_

—

For seasoned veterans of BEM, all of this may seem like a relatively shallow improvement given the significance of the change we’ve introduced to our system. In fact, CSS Modules lets you achieve this without leaving the comfort of the CSS tooling ecosystem. This is why so many projects stick with CSS Modules, finding that it sufficiently solves most of their problems with writing CSS at scale without sacrificing the familiarity of regular CSS.

However, it’s when we start to build on top of these basic concepts that things start to get a lot more interesting.

### 2.

#### Critical CSS

It’s become a relatively recent best practice to inline critical styles in the head of your document, improving initial load times by providing only those styles required to render the current page. This is in stark contrast to how we usually loaded styles—forcing the browser to download every possible visual style for our application before a single pixel was rendered on the screen.

While there are tools available for extracting and inlining critical CSS, like the appropriately named [critical](https://github.com/addyosmani/critical) by [Addy Osmani](https://twitter.com/addyosmani), they don’t fundamentally change the fact that critical CSS is difficult to maintain and automate. It’s a tricky, purely optional performance optimisation, so most projects seem to forgo this step.

CSS-in-JS is a totally different story.

When working in a server rendered application, extracting your critical CSS is not merely an optimisation—CSS-in-JS on the server fundamentally _requires_ critical CSS to even work in the first place.

For example, when using [Aphrodite](https://github.com/Khan/aphrodite) from [Khan Academy](https://github.com/Khan), it keeps track of which styles are used within a single render pass using its `css` function, which is called inline while applying classes to your elements.

```
import { StyleSheet, css } from 'aphrodite'
const styles = StyleSheet.create({
  title: { ... }
})
const Heading = ({ children }) => (
  <h1 className={css(styles.heading)}>{ children }</h1>
)
```

Even though all of your styles are defined in JavaScript, you can easily extract all the styles for the current page into a static string of CSS that can be inserted into the head of the document when rendering server-side.

```
import { StyleSheetServer } from 'aphrodite';

const { html, css } = StyleSheetServer.renderStatic(() => {
  return ReactDOMServer.renderToString(<App/>);
});
```

You can now render your critical CSS block like this:

```
const criticalCSS = `
  <style data-aphrodite>
    ${css.content}
  </style>
`;
```

If you’ve looked into React’s server rendering model, you may find this to be a very familiar pattern. In React, your components define their markup in JavaScript, but can be rendered to a regular HTML string on the server.

**_If you build your app with progressive enhancement in mind, despite being written entirely in JavaScript, it might not require JavaScript on the client at all._**

Either way, the client-side JavaScript bundle includes the code needed to boot up your single-page app, suddenly bringing it to life, rendering in the browser from that point forward.

Since rendering your HTML and CSS on the server happen at the same time, libraries like Aphrodite often help us streamline the generation of both critical CSS _and_ server-rendered HTML into a single call, as we saw in the previous example. This now allows us to render our React components to static HTML in a similar fashion.

```
const appHtml = `
  <div id="root">
    ${html}
  </div>
`
```

By using CSS-in-JS on the server, not only does our single-page app continue to work without JavaScript, _it might even render faster too._

**_As with the scoping of our selectors, the best practice of rendering critical CSS is now baked in, not opt-in._**

### 3.

#### Smarter optimisations

We’ve recently seen the rise of new ways of structuring our CSS—like [Atomic CSS](https://acss.io/) from [Yahoo](https://github.com/yahoo) and [Tachyons](http://tachyons.io/) by [Adam Morse](https://twitter.com/mrmrs_)—that eschew “semantic classes” in favour of tiny, single-purpose classes. For example, when using Atomic CSS, you apply classes with a function-like syntax which can then be used to generate an appropriate style sheet.

```
<div class="Bgc(#0280ae.5) C(#fff) P(20px)">
  Atomic CSS
</div>
```

The goal is to keep your CSS bundle as lean as possible by maximising the re-usability of classes, effectively treating classes like inline styles. While it’s easy to appreciate the reduction in file size, the impacts to both your codebase and your fellow team members are anything but insignificant. These optimisations, by their very nature, involve changes to both your CSS _and_ your markup, making them a more significant architectural effort.

As we’ve touched on already, when using CSS-in-JS or CSS Modules, you no longer hard-code class strings in your markup, instead using dynamic references to JavaScript values that have been generated automatically by a library or build tool.

Instead of this:

```
<aside className="sidebar" />
```

We write this:

```
<aside className={styles.sidebar} />
```

This may look like a fairly superficial change, but this is a monumental shift in how we manage the relationship between our markup and our styles. By giving our CSS tooling the ability to alter not just our styles, _but the final classes we apply to our elements,_ we unlock an entirely new class of optimisations for our style sheets.

If we look at the example above, _‘styles.sidebar’_ evaluates to a string, but there’s nothing limiting it to a single class. For all we know, it could just as easily end up being a string of over a dozen classes.

```
<aside className={styles.sidebar} />
// Could easily resolve to this:
<aside className={'class1 class2 class3 class4'} />
```

If we can optimise our styles, generating multiple classes for each set of styles, we can do some really interesting things.

My favourite example of this is [Styletron](https://github.com/rtsao/styletron) by [Ryan Tsao](https://twitter.com/rtsao).

![](https://cdn-images-1.medium.com/max/1600/1*7xxb6FOmcmPCnQNrFy5pjg.png)

In the same way that CSS-in-JS and CSS Modules automate the process of adding BEM-style class prefixes, Styletron does the same thing to the Atomic CSS mindset.

The core API is focused around a single task—defining individual CSS rules for each combination of property, value and media query, which then returns an automatically generated class.

```
import styletron from 'styletron';
styletron.injectDeclaration({
  prop: 'color',
  val: 'red',
  media: '(min-width: 800px)'
});
// → 'a'
```

Of course, Styletron provides higher level APIs, such as its `injectStyle` function which allows multiple rules to be defined at once.

```
import { injectStyle } from 'styletron-utils';
injectStyle(styletron, {
  color: 'red',
  display: 'inline-block'
});
// → 'a d'
injectStyle(styletron, {
  color: 'red',
  fontSize: '1.6em'
});
// → 'a e'
```

Take special note of the commonality between the two sets of class names generated above.

**_By relinquishing low-level control over the classes themselves, only defining the desired set of styles, we allow the library to generate the optimal set of atomic classes on our behalf._**

![](https://cdn-images-1.medium.com/max/1600/1*pWXr1A6uhiOkYHqwfBMtWg.png)

Optimisations that are typically done by hand—finding the most efficient way to split up our styles into reusable classes—can now be completely automated. You might be starting to notice a trend here. **_Atomic CSS is baked in, not opt-in._**

### 4.

#### Package management

Before digging into this point, it’s first worth stopping and asking yourself a seemingly simple question.

_How do we share CSS with each other?_

We’ve migrated from manually downloading CSS files, towards front-end specific package managers like [Bower](https://bower.io), and now via [npm](https://www.npmjs.com/) thanks to tools like [Browserify](http://browserify.org/) and [webpack](https://webpack.js.org). Even though some tooling has automated the process of including CSS from external packages, the front-end community has mostly settled on manual inclusion of CSS dependencies.

Either way, there’s one thing that CSS dependencies aren’t very good at—depending on _other_ CSS dependencies.

As many of you might remember, we’ve seen a similar effect with _JavaScript modules_ between Bower and npm.

Bower wasn’t coupled to any particular module format, whereas modules published to npm use the [CommonJS module format](http://wiki.commonjs.org/wiki/Modules/1.1). This has had a massive impact on the number of packages published to each platform.

Complex trees of small, _nested_ dependencies felt right at home on npm, while Bower attracted large, _monolithic_ dependencies, of which you might only have two or three—plus a few plugins, of course. Since your dependencies didn’t have a module system to rely on, each package couldn’t easily make use of its _own_ dependencies, so the integration was always a manual step left up to the consumer.

As a result, the number of packages on npm over time forms an exponential curve, while Bower only had a fairly linear increase of packages. While there are certainly a variety of reasons for this differentiation, it’s fair to say that a _lot_ of it has to do with the way each platform allows (or doesn’t allow) packages to depend on each other at runtime.

![](https://cdn-images-1.medium.com/max/1600/1*LTrsIISPV5qK-qAQKaeINA.png)

Unfortunately, this looks all too familiar to the CSS community, where we’ve also seen a relatively slow increase of monolithic packages compared to what we see with JavaScript packages on npm.

What if we instead wanted to match npm’s exponential growth? What if we wanted to be able to depend on complex package hierarchies of varying sizes, with less focus on large, all-encompassing frameworks? To do this, we’d not only need a package manager that’s up to the task—we’d also need an appropriate module format too.

Does this mean that we need a package manager specifically designed for CSS? For preprocessors like Sass and Less?

What’s really interesting is that we’ve already gone through a similar realisation with HTML. If you ask the same questions about how we share _markup_ with each other, you’ll quickly notice that we almost never share raw HTML directly—we share _HTML-in-JS._

We do this via [jQuery plugins](https://plugins.jquery.com/), [Angular directives](http://ngmodules.org) and [React components](https://react.parts/web). We compose large components out of smaller components, each with their own HTML, each published independently to npm. HTML as a format might not be powerful enough to allow this, but by _embedding HTML within a fully-fledged programming language,_ we’re easily able to work around this limitation.

What if, like HTML, we shared our CSS—and the logic that generates it—via JavaScript? What if, instead of using [mixins](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#mixins), we used _functions returning objects and strings?_ Instead of [extending classes](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#extend), what if we simply _merged objects_ with [_Object.assign_](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign), or the new [object spread operator](https://github.com/tc39/proposal-object-rest-spread)?

```
const styles = {
  ...rules,
  ...moreRules,
  fontFamily: 'Comic Sans MS',
  color: 'blue'
}
```

Once we start writing our styles this way, we can now compose and share our styling code like any other code in our application, using the same patterns, the same tooling, the same infrastructure, _the same ecosystem._

A great example of how this starts to pay off is in libraries like [Polished](https://github.com/styled-components/polished) by [Max Stoiber](https://twitter.com/mxstbr), [Nik Graf](https://twitter.com/nikgraf) and [Brian Hough](https://twitter.com/b_hough).

![](https://cdn-images-1.medium.com/max/1600/1*fczf3OWmmKBkFgtUqZnq2g.png)

Polished is essentially the [Lodash](https://lodash.com) of CSS-in-JS, providing a complete suite of mixins, colour functions, shorthands and more, making the process of authoring styles in JavaScript much more familiar for those coming from languages like [Sass](http://sass-lang.com). The key difference now is that this code is much more composable, testable and shareable, able to use the full JavaScript package ecosystem.

So, when it comes to CSS, how do we achieve the same level of open source activity seen across npm as a whole, composing large collections of styles from small, reusable, open-source packages? Strangely enough, we might finally achieve this by embedding our CSS within another language and completely embracing JavaScript modules.

### 5.

#### Non-browser styling

So far, all of the points we’ve covered—while certainly a lot _easier_ when writing CSS in JavaScript—they’re by no means things that are _impossible_ with regular CSS. This is why I’ve left the most interesting, future-facing point until last. Something that, while not necessarily playing a huge role in today’s CSS-in-JS community, is quite possibly going to become a foundational layer in the future of _design._ Something that affects not just developers, but designers too, radically altering the way these two disciplines communicate with each other.

First, to put this in context, we need to take a quick detour into React.

—

The React model is all about components rendering intermediate representations of the final output. When working in the browser, rather than directly mutating DOM elements, we’re building up complex trees of virtual DOM.

What’s interesting, though, is that rendering to the DOM is not part of the core React library, instead being provided by _react-dom._

```
import { render } from 'react-dom'
```

Even though React was built for the DOM first, and still gets most of its usage in that environment, this model allows React to target wildly different environments simply by introducing new renderers.

JSX isn’t just about virtual DOM—it’s about virtual _whatever._

This is what allows [React Native](https://facebook.github.io/react-native) to work, writing truly native applications in JavaScript, by writing components that render virtual representations of their native counterparts. Instead of _div_ and _span_, we have _View_ and _Text._

From a CSS perspective, the most interesting thing about React Native is that it comes with its own [StyleSheet API](https://facebook.github.io/react-native/docs/stylesheet.html):

```
var styles = StyleSheet.create({
  container: {
    borderRadius: 4,
    borderWidth: 0.5,
    borderColor: '#d6d7da',
  },
  title: {
    fontSize: 19,
    fontWeight: 'bold',
  },
  activeTitle: {
    color: 'red',
  }
})
```

Here you can see a familiar set of styles, in this case covering colours, fonts and border styling.

These rules are fairly straightforward and map easily to most UI environments, but things get really interesting when it comes to native layout.

```
var styles = StyleSheet.create({
  container: {
    display: 'flex'
  }
})
```

Despite being outside of a browser environment, _React Native ships with its own native implementation of_ [_flexbox_](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes)_._

Initially released as a JavaScript package called [_css-layout_](https://www.npmjs.com/package/css-layout)_,_ reimplementing flexbox entirely in JavaScript (backed by an appropriately comprehensive test suite), it’s now been migrated to C for better portability.

Given the scope and importance of the project, it’s been given a more significant brand of its own in the form of [Yoga](https://facebook.github.io/yoga).

![](https://cdn-images-1.medium.com/max/1600/1*mv_hHmbOgU7SOd5t2J2Q2g.png)

Even though Yoga is all about porting CSS concepts to non-browser environments, the potentially unmanageable scope has been reigned in by focusing on only a subset of CSS features.

> “Yoga’s focus is on creating an expressive layout library, not implementing all of CSS”

These sorts of tradeoffs may seem limiting, but when you look at the history of CSS architecture, it’s clear that _working with CSS at scale is all about picking a reasonable subset of the language._

In Yoga’s case, they eschew the cascade in favour of scoped styles, and focus their layout engine entirely on flexbox. While this rules out a lot of functionality, it also unlocks an amazing opportunity for cross-platform components with embedded styling, and we’ve already seen several notable open source projects trying to capitalise on this fact.

[React Native for Web](https://github.com/necolas/react-native-web) by [Nicolas Gallagher](https://twitter.com/necolas) aims to be a drop-in replacement for the react-native library. When using a bundler like webpack, aliasing third-party packages is fairly straightforward.

```
module: {
  alias: {
    'react-native': 'react-native-web'
  }
}
```

Using React Native for Web allows React Native components to work in a browser environment, including a browser port of the [React Native StyleSheet API](https://facebook.github.io/react-native/docs/stylesheet.html)_._

Similarly, [react-primitives](https://github.com/lelandrichardson/react-primitives) by [Leland Richardson](https://twitter.com/intelligibabble) is all about providing a cross-platform set of primitive components that abstract away the implementation details of the target platform, creating a workable baseline for cross-platform components.

Even [Microsoft](https://github.com/Microsoft) is getting in on the act with the introduction of [ReactXP](https://microsoft.github.io/reactxp), a library designed to streamline efforts to share code across both web and native, which also includes its own [platform-agnostic style implementation](https://microsoft.github.io/reactxp/docs/styles.html).

—

Even if you don’t write software for native applications, it’s important to note that having a truly cross-platform component abstraction allows us to target an effectively limitless set of environments, sometimes in ways that you might never have predicted.

The most surprising example of this I’ve seen is [react-sketchapp](http://airbnb.io/react-sketchapp) by [Jon Gold](https://twitter.com/jongold) at [Airbnb](https://github.com/airbnb).

![](https://cdn-images-1.medium.com/max/1600/1*qfskIhHAWpYwfR5Lz0_cIA.png)

For many of us, so much of our time is spent trying to standardise our design language, limiting the amount of duplication in our systems as much as possible. Unfortunately, as much as we’d like to only have a single source of truth, it seemed like the best we could hope for was to reduce it to _two_—a living style guide for developers, and _a static style guide for designers._ While certainly much better than what we’ve been historically used to, this still leaves us manually syncing from design tools—like [Sketch](https://www.sketchapp.com)—to code and back. This is where react-sketchapp comes in.

Thanks to Sketch’s [JavaScript API](http://developer.sketchapp.com/reference/api), and the ability for React to connect to different renderers, react-sketchapp lets us take our cross-platform React components and render them into our Sketch documents.

![](https://cdn-images-1.medium.com/max/1600/1*v2L1DB8OS38GScyBRFD8hQ.png)

Needless to say, this has the potential to massively shake up how designers and developers collaborate. Now, when we refer to the same components while iterating on our designs, we can potentially be referring to the same _implementation_ too, regardless of whether we’re working with tools for designers or developers.

With [symbols in Sketch](https://www.sketchapp.com/learn/documentation/symbols) and [components in React](https://facebook.github.io/react/docs/components-and-props.html), our industry is essentially starting to converge on the same abstraction, opening the opportunity for us to work closer together by sharing the same tools.

It’s no coincidence that so many of these new experiments are coming from within the React community, and those communities surrounding it.

In a component architecture, co-locating as many of a component’s concerns in a single place becomes a high priority. This, of course, includes its locally scoped styles, but even extends to more complicated areas like data fetching thanks to libraries like [Relay](https://facebook.github.io/relay) and [Apollo](http://dev.apollodata.com). The result is something that unlocks an enormous amount of potential, of which we’ve only just scratched the surface.

While this has a huge impact on the way we style our applications, it has an equally large effect on everything else in our architecture—but for good reason.

By unifying our model around components written in a single language, we have the potential to better separate our concerns—not by technology, but by _functionality._ Scoping everything around the unit of a component, scaling large yet maintainable systems from them, optimised in ways that weren’t possible before, sharing our work with each other more easily and composing large applications out of small open-source building blocks. Most importantly, we can do all of this without breaking progressive enhancement, without giving up on the principles that many of us see as a non-negotiable part of taking the web platform seriously.

Most of all, I’m excited about the potential of components written in a single language to form the basis of _a new, unified styling language_—one that unites the front-end community in ways we’ve never seen before.

At SEEK, we’re working to take advantage of this by building our own living style guide around this component model, where semantics, interactivity and visual styling are all united under a single abstraction. This forms a common design language, shared between developers and designers alike.

As much as possible, building a page should be as simple as combining an opinionated set of components that ensure our work stays on brand, while allowing us to upgrade our design language long after we’ve shipped to production.

```
import {
  PageBlock,
  Card,
  Text
} from 'seek-style-guide/react'
const App = () => (
  <PageBlock>
    <Card>
      <Text heading>Hello World!</Text>
    </Card>
  </PageBlock>
)
```

Even though our style guide is currently built with React, webpack and CSS Modules, the architecture exactly mirrors what you’d find in any system built with CSS-in-JS. The technology choices may differ, but the mindset is the same.

However, these technology choices will likely need to shift in unexpected ways in the future, which is why keeping an eye on this space is so critical to the ongoing development of our component ecosystem. We may not be using CSS-in-JS today, but it’s quite possible that a compelling reason to switch could arise sooner than we think.

CSS-in-JS has come a surprisingly long way in a short amount of time, but it’s important to note that, in the grand scheme of things, it’s only just getting started.

There’s still so much room for improvement, and the innovations are showing no signs of stopping. Libraries are still popping up to address the outstanding issues and to improve the developer experience—performance enhancements, extracting static CSS at build time, targeting CSS variables and lowering the barrier to entry for all front-end developers.

This is where the CSS community comes in. Despite all of these massive alterations to our workflow, **_none of this changes the fact that you still need to know CSS._**

We may express it with different syntax, we may architect our apps in different ways, but the fundamental building blocks of CSS aren’t going away. Equally, our industry’s move towards component architectures is inevitable, and the desire to reimagine the front-end through this lens is only getting stronger. There is a very real need for us to work together, to ensure our solutions are widely applicable to developers of all backgrounds, whether design-focused, engineering-focused, or both.

While we may sometimes seem at odds, the CSS and JS communities both share a passion for improving the front-end, for taking the web platform seriously, and improving our processes for the next generation of web sites. There’s so much potential here, and while we’ve covered an incredible amount of ground so far, there’s still so much work left to be done.

At this point, you still might not be convinced, and that’s totally okay. It’s completely reasonable to find CSS-in-JS to be ill-fitting for your work _right now,_ but my hope is that it’s for the _right reasons,_ rather than superficial objections to mere _syntax._

Regardless, it seems quite likely that this approach to authoring styles is only going to grow more popular over the coming years, and it’s worth keeping an eye on it while this approach continues to evolve at such a rapid pace. I sincerely hope that you’re able to join us in helping make the next generation of CSS tooling as effective as possible for all front-end developers, whether through code contributions or _simply being an active part of the conversation._ If not, at the _very least,_ I hope I’ve been able to give you a better understanding of why people are so passionate about this space, and—maybe—why it’s not such a ridiculous idea after all.

_This article was written in parallel with a talk of the same name — presented at CSSconf EU 2017 in Berlin, Germany — which is now_ [_available on YouTube_](https://www.youtube.com/watch?v=X_uTCnaRe94)_._

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
