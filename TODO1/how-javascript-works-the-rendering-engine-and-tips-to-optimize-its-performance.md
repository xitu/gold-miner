> * 原文地址：[How JavaScript works: the rendering engine and tips to optimize its performance](https://blog.sessionstack.com/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance-7b95553baeda)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md)
> * 译者：
> * 校对者：

# How JavaScript works: the rendering engine and tips to optimize its performance

This is post # 11 of the series dedicated to exploring JavaScript and its building components. In the process of identifying and describing the core elements, we also share some rules of thumb we use when building [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-rendering-engine-intro), a JavaScript application that needs to be robust and highly-performant to help users see and reproduce their web app defects real-time.

When you’re building web apps, however, you don’t just write isolated JavaScript code that runs on its own. The JavaScript you write is interacting with the environment. Understanding this environment, how it works and what it is composed of will allow you to build better apps and be well-prepared for potential issues that might arise once your apps are released into the wild.

![](https://cdn-images-1.medium.com/max/800/1*lMBu87MtEsVFqqbfMum-kA.png)

So, let’s see what the browser main components are:

*   **User interface**: this includes the address bar, the back and forward buttons, bookmarking menu, etc. In essence, this is every part of the browser display except for the window where you see the web page itself.
*   **Browser engine**:ithandles the interactions between the user interface and the rendering engine
*   **Rendering engine**: it’s responsible for displaying the web page. The rendering engine parses the HTML and the CSS and displays the parsed content on the screen.
*   **Networking**: these are network calls such as XHR requests, made by using different implementations for the different platforms, which are behind a platform-independent interface. We talked about the networking layer in more detail in a [previous post](https://blog.sessionstack.com/how-modern-web-browsers-accelerate-performance-the-networking-layer-f6efaf7bfcf4) of this series.
*   **UI backend**: it’s used for drawing the core widgets such as checkboxes and windows. This backend exposes a generic interface that is not platform-specific. It uses operating system UI methods underneath.
*   **JavaScript engine**: We’ve covered this in great detail in a [previous post](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e) from the series. Basically, this is where the JavaScript gets executed.
*   **Data persistence**: your app might need to store all data locally. The supported types of storage mechanisms include [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage), [indexDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API), [WebSQL](https://en.wikipedia.org/wiki/Web_SQL_Database) and [FileSystem](https://developer.mozilla.org/en-US/docs/Web/API/FileSystem).

In this post, we’re going to focus on the rendering engine, since it’s handling the parsing and the visualization of the HTML and the CSS, which is something that most JavaScript apps are constantly interacting with.

#### Overview of the rendering engine

The main responsibility of the rendering engine is to display the requested page on the browser screen.

Rendering engines can display HTML and XML documents and images. If you’re using additional plugins, the engines can also display different types of documents such as PDF.

#### Rendering engines

Similar to the JavaScript engines, different browsers use different rendering engines as well. These are some of the popular ones:

*   **Gecko** — Firefox
*   **WebKit** — Safari
*   **Blink** — Chrome, Opera (from version 15 onwards)

#### The process of rendering

The rendering engine receives the contents of the requested document from the networking layer.

![](https://cdn-images-1.medium.com/max/800/1*9b1uEMcZLWuGPuYcIn7ZXQ.png)

#### Constructing the DOM tree

The first step of the rendering engine is parsing the HTML document and converting the parsed elements to actual [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction) nodes in a **DOM tree**.

Imagine you have the following textual input:

```
<html>
  <head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="theme.css">
  </head>
  <body>
    <p> Hello, <span> friend! </span> </p>
    <div> 
      <img src="smiley.gif" alt="Smiley face" height="42" width="42">
    </div>
  </body>
</html>
```

The DOM tree for this HTML will look like this:

![](https://cdn-images-1.medium.com/max/800/1*ezFoXqgf91umls9FqO0HsQ.png)

Basically, each element is represented as the parent node to all of the elements, which are directly contained inside of it. And this is applied recursively.

#### Constructing the CSSOM tree

CSSOM refers to the **CSS Object Model**. While the browser was constructing the DOM of the page, it encountered a `link` tag in the `head` section which was referencing the external `theme.css` CSS style sheet. Anticipating that it might need that resource to render the page, it immediately dispatched a request for it. Let’s imagine that the `theme.css` file has the following contents:

```
body { 
  font-size: 16px;
}

p { 
  font-weight: bold; 
}

span { 
  color: red; 
}

p span { 
  display: none; 
}

img { 
  float: right; 
}
```

As with the HTML, the engine needs to convert the CSS into something that the browser can work with — the CSSOM. Here is how the CSSOM tree will look like:

![](https://cdn-images-1.medium.com/max/800/1*5YU1su2mdzHEQ5iDisKUyw.png)

Do you wonder why does the CSSOM have a tree structure? When computing the final set of styles for any object on the page, the browser starts with the most general rule applicable to that node (for example, if it is a child of a body element, then all body styles apply) and then recursively refines the computed styles by applying more specific rules.

Let’s work with the specific example that we gave. Any text contained within a `span` tag that is placed within the `body` element, has a font size of 16 pixels and has a red color. Those styles are inherited from the `body` element. If a `span` element is a child of a `p` element, then its contents are not displayed due to the more specific styles that are being applied to it.

Also, note that the above tree is not the complete CSSOM tree and only shows the styles we decided to override in our style sheet. Every browser provides a default set of styles also known as **“user agent styles”** — that’s what we see when we don’t explicitly provide any. Our styles simply override these defaults.

#### Constructing the render tree

The visual instructions in the HTML, combined with the styling data from the CSSOM tree, are being used to create a **render tree**.

What is a render tree you may ask? This is a tree of the visual elements constructed in the order in which they will be displayed on the screen. It is the visual representation of the HTML along with the corresponding CSS. The purpose of this tree is to enable painting the contents in their correct order.

Each node in the render tree is known as a renderer or a render object in Webkit.

This is how the renderer tree of the above DOM and CSSOM trees will look like:

![](https://cdn-images-1.medium.com/max/800/1*WHR_08AD8APDITQ-4CFDgg.png)

To construct the render tree, the browser does roughly the following:

*   Starting at the root of the DOM tree, it traverses each visible node. Some nodes are not visible (for example, script tags, meta tags, and so on), and are omitted since they are not reflected in the rendered output. Some nodes are hidden via CSS and are also omitted from the render tree. For example, the span node — in the example above it’s not present in the render tree because we have an explicit rule that sets the `display: none` property on it.
*   For each visible node, the browser finds the appropriate matching CSSOM rules and applies them.
*   It emits visible nodes with content and their computed styles

You can take a look at the RenderObject’s source code (in WebKit) here: [https://github.com/WebKit/webkit/blob/fde57e46b1f8d7dde4b2006aaf7ebe5a09a6984b/Source/WebCore/rendering/RenderObject.h](https://github.com/WebKit/webkit/blob/fde57e46b1f8d7dde4b2006aaf7ebe5a09a6984b/Source/WebCore/rendering/RenderObject.h)

Let’s just look at some of the core things for this class:

```
class RenderObject : public CachedImageClient {
  // Repaint the entire object.  Called when, e.g., the color of a border changes, or when a border
  // style changes.
  
  Node* node() const { ... }
  
  RenderStyle* style;  // the computed style
  const RenderStyle& style() const;
  
  ...
}
```

Each renderer represents a rectangular area usually corresponding to a node’s CSS box. It includes geometric info such as width, height, and position.

#### Layout of the render tree

When the renderer is created and added to the tree, it does not have a position and size. Calculating these values is called layout.

HTML uses a flow-based layout model, meaning that most of the time it can compute the geometry in a single pass. The coordinate system is relative to the root renderer. Top and left coordinates are used.

Layout is a recursive process — it begins at the root renderer, which corresponds to the `<html>` element of the HTML document. Layout continues recursively through a part or the entire renderer hierarchy, computing geometric info for each renderer that requires it.

The position of the root renderer is `0,0` and its dimensions have the size of the visible part of the browser window (a.k.a. the viewport).

Starting the layout process means giving each node the exact coordinates where it should appear on the screen.

#### Painting the render tree

In this stage, the renderer tree is traversed and the renderer’s `paint()` method is called to display the content on the screen.

Painting can be global or incremental (similar to layout):

*   **Global** — the entire tree gets repainted.
*   **Incremental** — only some of the renderers change in a way that does not affect the entire tree. The renderer invalidates its rectangle on the screen. This causes the OS to see it as a region that needs repainting and to generate a `paint` event. The OS does it in a smart way by merging several regions into one.

In general, it’s important to understand that painting is a gradual process. For better UX, the rendering engine will try to display the contents on the screen as soon as possible. It will not wait until all the HTML is parsed to start building and laying out the render tree. Parts of the content will be parsed and displayed, while the process continues with the rest of the content items that keep coming from the network.

#### Order of processing scripts and style sheets

Scripts are parsed and executed immediately when the parser reaches a `<script>` tag. The parsing of the document halts until the script has been executed. This means that the process is **synchronous**.

If the script is external then it first has to be fetched from the network (also synchronously). All the parsing stops until the fetch completes.

HTML5 adds an option to mark the script as asynchronous so that it gets parsed and executed by a different thread.

#### Optimizing the rendering performance

If you’d like to optimize your app, there are five major areas that you need to focus on. These are the areas over which you have control:

1.  **JavaScript** — in previous posts we covered the topic of writing optimized code that doesn’t block the UI, is memory efficient, etc. When it comes to rendering, we need to think about the way your JavaScript code will interact with the DOM elements on the page. JavaScript can create lots of changes in the UI, especially in SPAs.
2.  **Style calculations **— this is the process of determining which CSS rule applies to which element based on matching selectors. Once the rules are defined, they are applied and the final styles for each element are calculated.
3.  **Layout** — once the browser knows which rules apply to an element, it can begin to calculate how much space the latter takes up and where it is located on the browser screen. The web’s layout model defines that one element can affect others. For example, the width of the `<body>` can affect the width of its children and so on. This all means that the layout process is computationally intensive. The drawing is done in multiple layers.
4.  **Paint** — this is where the actual pixels are being filled. The process includes drawing out text, colors, images, borders, shadows, etc. — every visual part of each element.
5.  **Compositing** — since the page parts were drawn into potentially multiple layers they need to be drawn onto the screen in the correct order so that the page renders properly. This is very important, especially for overlapping elements.

#### Optimizing your JavaScript

JavaScript often triggers visual changes in the browser. All the more so when building an SPA.

Here are a few tips on which parts of your JavaScript you can optimize to improve rendering:

*   Avoid `setTimeout` or `setInterval` for visual updates. These will invoke the `callback` at some point in the frame, possible right at the end. What we want to do is trigger the visual change right at the start of the frame not to miss it.
*   Move long-running JavaScript computations to Web Workers as we have [previously discussed](https://blog.sessionstack.com/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them-a547c0757f6a?source=---------3----------------).
*   Use micro-tasks to introduce DOM changes over several frames. This is in case the tasks need access to the DOM, which is not accessible by Web Workers. This basically means that you’d break up a big task into smaller ones and run them inside `requestAnimationFrame` , `setTimeout`, `setInterval` depending on the nature of the task.

#### Optimize your CSS

Modifying the DOM through adding and removing elements, changing attributes, etc. will make the browser recalculate element styles and, in many cases, the layout of the entire page or at least parts of it.

To optimize the rendering, consider the following:

*   Reduce the complexity of your selectors. Selector complexity can take more than 50% of the time needed to calculate the styles for an element, compared to the rest of the work which is constructing the style itself.
*   Reduce the number of elements on which style calculation must happen. In essence, make style changes to a few elements directly rather than invalidating the page as a whole.

#### Optimize the layout

Layout re-calculations can be very heavy for the browser. Consider the following optimizations:

*   Reduce the number of layouts whenever possible. When you change styles the browser checks to see if any of the changes require the layout to be re-calculated. Changes to properties such as width, height, left, top, and in general, properties related to geometry, require layout. So, avoid changing them as much as possible.
*   Use `flexbox` over older layout models whenever possible. It works faster and can create a huge performance advantage for your app.
*   Avoid forced synchronous layouts. The thing to keep in mind is that while JavaScript runs, all the old layout values from the previous frame are known and available for you to query. If you access `box.offsetHeight` it won’t be an issue. If you, however, change the styles of the box before it’s accessed (e.g. by dynamically adding some CSS class to the element), the browser will have to first apply the style change and then run the layout. This can be very time-consuming and resource-intensive, so avoid it whenever possible.

**Optimize the paint**

This often is the longest-running of all the tasks so it’s important to avoid it as much as possible. Here is what we can do:

*   Changing any property other than transforms or opacity triggers a paint. Use it sparingly.
*   If you trigger a layout, you will also trigger a paint, since changing the geometry results in a visual change of the element.
*   Reduce paint areas through layer promotion and orchestration of animations.

Rendering is a vital aspect of how [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-rendering-engine-outro) functions. SessionStack has to recreate as a video everything that happened to your users at the time they experienced an issue while browsing your web app. To do this, SessionStack leverages only the data that was collected by our library: user events, DOM changes, network requests, exceptions, debug messages, etc. Our player is highly optimized to properly render and make use of all the collected data in order to offer a pixel-perfect simulation of your users’ browser and everything that happened in it, both visually and technically.

There is a free plan if you’d like to [give SessionStack a try](https://www.sessionstack.com/signup/).

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)

#### Resources

*   [https://developers.google.com/web/fundamentals/performance/critical-rendering-path/constructing-the-object-model](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/constructing-the-object-model)
*   [https://developers.google.com/web/fundamentals/performance/rendering/reduce-the-scope-and-complexity-of-style-calculations](https://developers.google.com/web/fundamentals/performance/rendering/reduce-the-scope-and-complexity-of-style-calculations)
*   [https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/#The_parsing_algorithm](https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/#The_parsing_algorithm)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
