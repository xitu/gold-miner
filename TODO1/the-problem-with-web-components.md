> * 原文地址：[The problem with web components](https://adamsilver.io/articles/the-problem-with-web-components/)
> * 原文作者：[Adam Silver](https://adamsilver.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-problem-with-web-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-problem-with-web-components.md)
> * 译者：
> * 校对者：

# The problem with web components

[Web components](https://www.webcomponents.org/introduction) are becoming increasingly popular within the web community. They offer a way to standardise and encapsulate JavaScript-enhanced components without a framework.

However, web components have a number of drawbacks. For instance, they have a number of technical limitations and are easy to misuse in a way that excludes users.

It’s possible—and certainly my hope—that web components will improve over time and these issues will be resolved. But for now, I’m holding fire on them.

In this article I’ll explain why that is, and suggest an alternative way to develop components in the meantime.

## They are constraining

In his [criticism of web components](https://thenewobjective.com/a-criticism-of-web-components/), Michael Haufe explains that:

* custom CSS pseudo selectors can’t be used with web components
* they don’t work seamlessly with native elements and their associated APIs
* if we wanted to create a custom button, for example, we can’t extend the [HTMLButtonElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLButtonElement) directly, we have to extend the [HTMLElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement)

Additionally, web components have to be defined with ES2015 classes which means they can't be transpiled to give more people the enhanced experience.

So, straight off the bat, there are a number of technical constraints to work around when it comes to using web components.

## They are not widely supported

Currently, web components have relatively poor cross-browser support, so the enhanced experienced won’t work for everyone.

![Web component support on caniuse.com](https://adamsilver.io/assets/images/web-component-can-i-use.png)

That doesn’t mean we can’t use them, it just means we’ll need to [provide a baseline experience that works for everyone else](https://adamsilver.io/articles/thinking-differently-about-progressive-enhancement/). That’s progressive enhancement.

But we should think seriously about whether the choice to use web components is the most inclusive option. If we don’t use web components, we can provide the same rich experience to a significantly wider group of people. I’ll explain how later.

Polyfills offer a way to provide broader support. But they are [slow, unreliable and hard to work](https://adamsilver.io/articles/the-disadvantages-of-javascript-polyfills/) with in general, and have a number of [specific limitations](https://www.webcomponents.org/polyfills#known-limitations) when used to make web components work more broadly.

So while it may be preferable for us as code authors to use standards-based technologies, it’s not necessarily beneficial to our users—which should always be our first priority.

## They are easily misunderstood and misused

Jeff Atwood said that any application that can be written in JavaScript, will eventually be written in JavaScript.

But just because we can use JavaScript to do something, doesn’t mean we should. There’s even a W3 principle that says we should use the [least powerful tool for the job](https://www.w3.org/2001/tag/doc/leastPower.html).

Web components are made up of JavaScript APIs which means we should use them only when we need JavaScript. But as Jeff Atwood predicted, people sometimes use web components when they don’t need to.

When we make JavaScript a dependency and don’t provide a fallback, users get a broken experience. Even [webcomponents.org](http://webcomponents.org), built using web components, shows a blank web page [when JavaScript isn’t available](https://kryogenix.org/code/browser/everyonehasjs.html).

![Completely broken experience on webcomponents.org when experiencing a JavaScript failure.](https://adamsilver.io/assets/images/web-components-org-no-js.png)

By the same token, it can encourage people to make components that request their data with AJAX and render themselves, like little iframes.

This type of approach causes a number of avoidable issues which I’ll explain by way of an example.

Imagine we want to load a table showing the sales figures for a product our website sells using AJAX like this:

```html
<sales-figures></sales-figures>
```

Firstly, it’s just a table. There’s no column sorting and therefore no need for JavaScript. Browsers provide the `<table>` element for this exact purpose and it works everywhere.

Secondly, as mentioned above, when a browser doesn’t support web components, or JavaScript fails to run, users won’t see anything.

To make our table work in these situations, we would need to put a `<table>` inside `<sales-figures>`. This is known as graceful degradation.

```html
<sales-figures>
  <table>...</table>
</sales-figures>
```

If the component already has a populated table on the page when the page loads, wrapping `<sales-figures>` around it gives us and our users nothing.

Finally, using AJAX can introduce a number of usability and accessibility issues.

1. [AJAX is often slower than a page refresh](https://jakearchibald.com/2016/fun-hacks-faster-content/), not faster.
2. We’ll need to create custom loading indicators, which are usually inaccurate and unfamiliar to users, unlike browsers’ loading indicators.
3. We’ll need to [make AJAX work cross-domain](https://zinoui.com/blog/cross-domain-ajax-request), which isn’t straightforward.
4. As the components load the page will jump around causing [visual glitches](https://twitter.com/chriscoyier/status/1057303249902952448) and potentially making users click the wrong thing. You may have heard about [skeleton interfaces](https://medium.com/@rohit971/boost-your-ux-with-skeleton-pattern-b8721929239f) as a way to solve this problem. They are placeholders put where the components will end up being shown once loaded. But while they help a bit, they don’t fully solve the problem because they can’t always predict the exact size of the content that will load.
5. Point 4 affects screen reader users too because they won’t know whether the components have loaded, have failed to load or are in the process of loading. ARIA live regions provide a way to communicate these states to screen readers. But when several components are being loaded, the user will be bombarded with announcements.

Scale this up to several web components on a screen and we risk giving users a very unpleasant, exclusive and slow experience to contend with.

Components that depend on AJAX requests to the server are no longer framework agnostic and therefore interoperable. This somewhat defeats the object of using web components, given that interoperability and technology agnosticism are 2 of the main benefits they aim to provide.

Importantly, none of these problems are the fault of web components per se. We could easily develop components to work like this without web components. But, as demonstrated, it’s easy to misinterpret web components and unknowingly use them in a way that hurts both users and code authors.

## They are hard to compose

Let’s say we have just 2 web components. One for sortable tables and another for expandable rows.

```html
<sortable-table>
  <table>...</table>
</sortable-table>

<expandable-rows>
  <table>...</table>
</expandable-rows>
```

But if we want a sortable table with expandable rows then we need to nest the components like this:

```html
<expandable-rows>
  <sortable-table>
    <table>...</table>
  </sortable-table>
</expandable-rows>
```

The relationship between `<expandable-rows>` and `<table>` is unclear. For example, it’s hard to tell whether `<expandable-rows>` is operating on the `<table>` or the `<sortable-table>`.

The order matters, too. If each component enhances the table it could create a conflict. Also, it's not clear which component initialises first—the inside one or the outside one.

**(Note: you may have heard about the `is` attribute as a way around this but Jeremy Keith explains that browsers aren’t going to implement this in [extensible web components](https://medium.com/@adactio/extensible-web-components-e794559b8c2e).)**

## They can’t just be dropped into an application

One of the supposed benefits of web components is that we can drop one script per component onto the page and they just work—regardless of the application or tech stack.

But unlike standard elements, we may need to add additional code to get them to work properly. In some ways this is a bit like adding a framework or library.

One example of this is polyfills which I mentioned earlier. If you choose to use a polyfill to provide broader support, then that code needs to be ready and waiting in your web page.

Another example would be when you need to stop JavaScript-enhanced components from making the [page judder while initialising](https://twitter.com/adambsilver/status/1119123828884434945).

This is usually fixed by adding a script in the `<head>` of your document to [provide a hook for CSS](https://css-tricks.com/snippets/javascript/css-for-when-javascript-is-enabled/). This in turn is used to style the component based on JavaScript being available and avoids the page judder.

This is perhaps of little consequence overall, but it does considerably negate one of the supposed benefits of using web components.

## Framework agnostic components without web components

You may have heard [web components being sold as an alternative to using frameworks](https://medium.com/@oneeezy/frameworks-vs-web-components-9a7bd89da9d4).

While I’m in favour of creating interfaces without client-side frameworks, this is misleading for a number of reasons.

Firstly, client-side frameworks usually provide additional features besides enhancing pieces of the interface.

Secondly, web components can be used in tandem with frameworks.

Lastly, we’ve been able to create JavaScript-enhanced components without frameworks and web components for a very long time.

By creating components like this we can avoid the drawbacks I’ve described in this article.

Let’s use the same sortable table and row expander to do this.

Firstly, we need to create a JavaScript file for each component—the same as if we were using web components. We can define the `SortableTable` and `RowExpander` classes inside.

```js
SortableTable.js // define SortableTable class and behaviour
RowExpander.js // define RowExpander class and behaviour
```

Once that’s done, we can initialise the components like this:

```js
// grab table
var table = document.querySelector('table');

// initialise sortable table
var sortable = new SortableTable(table);

// initialise row expander
var expander = new RowExpander(table);
```

We can make these components fire events just like web components. Something like this:

```js
sortable.addEventListener(‘sort’, fn);
expander.addEventListener(‘expand’, fn);
```

By using regular JavaScript in this way, not only can we write clean code, free from technical constraints, but we get to give that code to a significantly wider user base.

## In conclusion

Web components hold a lot of promise because they give code authors a way to create interoperable components based on standards.

As a result, it should be easier to understand other people’s code and create components that can be reused across projects.

But even if we choose to provide enhancements exclusively for cutting edge browsers that support them, there’s still several limitations and issues we need to tackle.

My hope is that web components get better in future. But until then, I’m sticking with regular JavaScript to avoid the current technical limitations and provide the most equitable experience to users.

**Huge thanks to [Amy Hupe](https://amyhupe.co.uk/) who not only edited this article from top to bottom, but also made it as simple and inclusive as possible. Not an easy feat for an article on web components of all things.** 🙌

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
