> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * 译者：
> * 校对者：

# 微前端：未来前端开发的新趋势 — 第二部分

做好前端开发不是件容易的事情，而比这更难的是扩展前端开发规模以便于多个团队可以同时开发一个大型且复杂的产品。本系列文章将描述一种趋势，可以将大型的前端项目分解成许多个小而易于管理的部分，也将讨论这种体系结构如何提高前端代码团队工作的有效性和效率。除了讨论各种好处和代价之外，我们还将介绍一些可用的实现方案和深入探讨一个应用该技术的完整示例应用程序。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

## The example

Imagine a website where customers can order food for delivery. On the surface it's a fairly simple concept, but there's a surprising amount of detail if you want to do it well:

* There should be a landing page where customers can browse and search for restaurants. The restaurants should be searchable and filterable by any number of attributes including price, cuisine, or what a customer has ordered previously
* Each restaurant needs its own page that shows its menu items, and allows a customer to choose what they want to eat, with discounts, meal deals, and special requests
* Customers should have a profile page where they can see their order history, track delivery, and customise their payment options

![A wireframe of a food delivery website](https://martinfowler.com/articles/micro-frontends/wireframe.png)

Figure 4: A food delivery website may have several reasonably complex pages

There is enough complexity in each page that we could easily justify a dedicated team for each one, and each of those teams should be able to work on their page independently of all the other teams. They should be able to develop, test, deploy, and maintain their code without worrying about conflicts or coordination with other teams. Our customers, however, should still see a single, seamless website.

Throughout the rest of this article, we'll be using this example application wherever we need example code or scenarios.

* * *

## Integration approaches

Given the fairly loose definition above, there are many approaches that could reasonably be called micro frontends. In this section we'll show some examples and discuss their tradeoffs. There is a fairly natural architecture that emerges across all of the approaches - generally there is a micro frontend for each page in the application, and there is a single **container application**, which:

* renders common page elements such as headers and footers
* addresses cross-cutting concerns like authentication and navigation
* brings the various micro frontends together onto the page, and tells each micro frontend when and where to render itself

![A web page with boxes drawn around different sections. One box wraps the whole page, labelling it as the 'container application'. Another box wraps the main content (but not the global page title and navigation), labelling it as the 'browse micro frontend'](https://martinfowler.com/articles/micro-frontends/composition.png)

Figure 5: You can usually derive your architecture from the visual structure of the page

### Server-side template composition

We start with a decidedly un-novel approach to frontend development - rendering HTML on the server out of multiple templates or fragments. We have an `index.html` which contains any common page elements, and then uses server-side includes to plug in page-specific content from fragment HTML files:

```
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Feed me</title>
  </head>
  <body>
    <h1>🍽 Feed me</h1>
    <!--# include file="$PAGE.html" -->
  </body>
</html>
```

We serve this file using Nginx, configuring the `$PAGE` variable by matching against the URL that is being requested:
```
server {
    listen 8080;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;
    ssi on;

    # Redirect / to /browse
    rewrite ^/$ http://localhost:8080/browse redirect;

    # Decide which HTML fragment to insert based on the URL
    location /browse {
      set $PAGE 'browse';
    }
    location /order {
      set $PAGE 'order';
    }
    location /profile {
      set $PAGE 'profile'
    }

    # All locations should render through index.html
    error_page 404 /index.html;
}
```

This is fairly standard server-side composition. The reason we could justifiably call this micro frontends is that we've split up our code in such a way that each piece represents a self-contained domain concept that can be delivered by an independent team. What's not shown here is how those various HTML files end up on the web server, but the assumption is that they each have their own deployment pipeline, which allows us to deploy changes to one page without affecting or thinking about any other page.

For even greater independence, there could be a separate server responsible for rendering and serving each micro frontend, with one server out the front that makes requests to the others. With careful caching of responses, this could be done without impacting latency.

![A flow diagram showing a browser making a request to a 'container app server', which then makes requests to one of either a 'browse micro frontend server' or a 'order micro frontend server'](https://martinfowler.com/articles/micro-frontends/ssi.png)

Figure 6: Each of these servers can be built and deployed to independently

This example shows how micro frontends is not necessarily a new technique, and does not have to be complicated. As long as we're careful about how our design decisions affect the autonomy of our codebases and our teams, we can achieve many of the same benefits regardless of our tech stack.

### Build-time integration

One approach that we sometimes see is to publish each micro frontend as a package, and have the container application include them all as library dependencies. Here is how the container's `package.json` might look for our example app:

```
{
  "name": "@feed-me/container",
  "version": "1.0.0",
  "description": "A food delivery web app",
  "dependencies": {
    "@feed-me/browse-restaurants": "^1.2.3",
    "@feed-me/order-food": "^4.5.6",
    "@feed-me/user-profile": "^7.8.9"
  }
}
```

At first this seems to make sense. It produces a single deployable Javascript bundle, as is usual, allowing us to de-duplicate common dependencies from our various applications. However, this approach means that we have to re-compile and release every single micro frontend in order to release a change to any individual part of the product. Just as with microservices, we've seen enough pain caused by such a **lockstep release process** that we would recommend strongly against this kind of approach to micro frontends.

Having gone to all of the trouble of dividing our application into discrete codebases that can be developed and tested independently, let's not re-introduce all of that coupling at the release stage. We should find a way to integrate our micro frontends at run-time, rather than at build-time.

### Run-time integration via iframes

One of the simplest approaches to composing applications together in the browser is the humble iframe. By their nature, iframes make it easy to build a page out of independent sub-pages. They also offer a good degree of isolation in terms of styling and global variables not interfering with each other.

```
<html>
  <head>
    <title>Feed me!</title>
  </head>
  <body>
    <h1>Welcome to Feed me!</h1>

    <iframe id="micro-frontend-container"></iframe>

    <script type="text/javascript">
      const microFrontendsByRoute = {
        '/': 'https://browse.example.com/index.html',
        '/order-food': 'https://order.example.com/index.html',
        '/user-profile': 'https://profile.example.com/index.html',
      };

      const iframe = document.getElementById('micro-frontend-container');
      iframe.src = microFrontendsByRoute[window.location.pathname];
    </script>
  </body>
</html>
```

Just as with the [server-side includes option](#Server-sideTemplateComposition), building a page out of iframes is not a new technique and perhaps does not seem that exciting. But if we revisit the chief benefits of micro frontends [listed earlier](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md#%E4%BC%98%E7%82%B9), iframes mostly fit the bill, as long as we're careful about how we slice up the application and structure our teams.

We often see a lot of reluctance to choose iframes. While some of that reluctance does seem to be driven by a gut feel that iframes are a bit “yuck”, there are some good reasons that people avoid them. The easy isolation mentioned above does tend to make them less flexible than other options. It can be difficult to build integrations between different parts of the application, so they make routing, history, and deep-linking more complicated, and they present some extra challenges to making your page fully responsive.

### Run-time integration via JavaScript

The next approach that we'll describe is probably the most flexible one, and the one that we see teams adopting most frequently. Each micro frontend is included onto the page using a `<script>` tag, and upon load exposes a global function as its entry-point. The container application then determines which micro frontend should be mounted, and calls the relevant function to tell a micro frontend when and where to render itself.

```
<html>
  <head>
    <title>Feed me!</title>
  </head>
  <body>
    <h1>Welcome to Feed me!</h1>

    <!-- These scripts don't render anything immediately -->
    <!-- Instead they attach entry-point functions to `window` -->
    <script src="https://browse.example.com/bundle.js"></script>
    <script src="https://order.example.com/bundle.js"></script>
    <script src="https://profile.example.com/bundle.js"></script>

    <div id="micro-frontend-root"></div>

    <script type="text/javascript">
      // These global functions are attached to window by the above scripts
      const microFrontendsByRoute = {
        '/': window.renderBrowseRestaurants,
        '/order-food': window.renderOrderFood,
        '/user-profile': window.renderUserProfile,
      };
      const renderFunction = microFrontendsByRoute[window.location.pathname];

      // Having determined the entry-point function, we now call it,
      // giving it the ID of the element where it should render itself
      renderFunction('micro-frontend-root');
    </script>
  </body>
</html>
```

The above is obviously a primitive example, but it demonstrates the basic technique. Unlike with build-time integration, we can deploy each of the `bundle.js` files independently. And unlike with iframes, we have full flexibility to build integrations between our micro frontends however we like. We could extend the above code in many ways, for example to only download each JavaScript bundle as needed, or to pass data in and out when rendering a micro frontend.

The flexibility of this approach, combined with the independent deployability, makes it our default choice, and the one that we've seen in the wild most often. We'll explore it in more detail when we get into the [full example.](#TheExampleInDetail)

### Run-time integration via Web Components

One variation to the previous approach is for each micro frontend to define an HTML custom element for the container to instantiate, instead of defining a global function for the container to call.

```
<html>
  <head>
    <title>Feed me!</title>
  </head>
  <body>
    <h1>Welcome to Feed me!</h1>

    <!-- These scripts don't render anything immediately -->
    <!-- Instead they each define a custom element type -->
    <script src="https://browse.example.com/bundle.js"></script>
    <script src="https://order.example.com/bundle.js"></script>
    <script src="https://profile.example.com/bundle.js"></script>

    <div id="micro-frontend-root"></div>

    <script type="text/javascript">
      // These element types are defined by the above scripts
      const webComponentsByRoute = {
        '/': 'micro-frontend-browse-restaurants',
        '/order-food': 'micro-frontend-order-food',
        '/user-profile': 'micro-frontend-user-profile',
      };
      const webComponentType = webComponentsByRoute[window.location.pathname];

      // Having determined the right web component custom element type,
      // we now create an instance of it and attach it to the document
      const root = document.getElementById('micro-frontend-root');
      const webComponent = document.createElement(webComponentType);
      root.appendChild(webComponent);
    </script>
  </body>
</html>
```

The end result here is quite similar to the previous example, the main difference being that you are opting in to doing things 'the web component way'. If you like the web component spec, and you like the idea of using capabilities that the browser provides, then this is a good option. If you prefer to define your own interface between the container application and micro frontends, then you might prefer the previous example instead.

* * *

## Styling

CSS as a language is inherently global, inheriting, and cascading, traditionally with no module system, namespacing or encapsulation. Some of those features do exist now, but browser support is often lacking. In a micro frontends landscape, many of these problems are exacerbated. For example, if one team's micro frontend has a stylesheet that says `h2 { color: black; }`, and another one says `h2 { color: blue; }`, and both these selectors are attached to the same page, then someone is going to be disappointed! This is not a new problem, but it's made worse by the fact that these selectors were written by different teams at different times, and the code is probably split across separate repositories, making it more difficult to discover.

Over the years, many approaches have been invented to make CSS more manageable. Some choose to use a strict naming convention, such as [BEM](http://getbem.com/), to ensure selectors only apply where intended. Others, preferring not to rely on developer discipline alone, use a pre-processor such as [SASS](https://sass-lang.com/), whose selector nesting can be used as a form of namespacing. A newer approach is to apply all styles programatically with [CSS modules](https://github.com/css-modules/css-modules) or one of the various [CSS-in-JS](https://mxstbr.com/thoughts/css-in-js/) libraries, which ensures that styles are directly applied only in the places the developer intends. Or for a more platform-based approach, [shadow DOM](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_shadow_DOM) also offers style isolation.

The approach that you pick does not matter all that much, as long as you find a way to ensure that developers can write their styles independently of each other, and have confidence that their code will behave predictably when composed together into a single application.

* * *

## Shared component libraries

We mentioned above that visual consistency across micro frontends is important, and one approach to this is to develop a library of shared, re-usable UI components. In general we believe that this a good idea, although it is difficult to do well. The main benefits of creating such a library are reduced effort through re-use of code, and visual consistency. In addition, your component library can serve as a living styleguide, and it can be a great point of collaboration between developers and designers.

One of the easiest things to get wrong is to create too many of these components, too early. It is tempting to create a [Foundation Framework](https://martinfowler.com/bliki/FoundationFramework.html), with all of the common visuals that will be needed across all applications. However, experience tells us that it's difficult, if not impossible, to guess what the components' APIs should be before you have real-world usage of them, which results in a lot of churn in the early life of a component. For that reason, we prefer to let teams create their own components within their codebases as they need them, even if that causes some duplication initially. Allow the patterns to emerge naturally, and once the component's API has become obvious, you can [harvest](https://martinfowler.com/bliki/HarvestedFramework.html) the duplicate code into a shared library and be confident that you have something proven.

The most obvious candidates for sharing are “dumb” visual primitives such as icons, labels, and buttons. We can also share more complex components which might contain a significant amount of UI logic, such as an auto-completing, drop-down search field. Or a sortable, filterable, paginated table. However, be careful to ensure that your shared components contain only UI logic, and no business or domain logic. When domain logic is put into a shared library it creates a high degree of coupling across applications, and increases the difficulty of change. So, for example, you usually should not try to share a `ProductTable`, which would contain all sorts of assumptions about what exactly a “product” is and how one should behave. Such domain modelling and business logic belongs in the application code of the micro frontends, rather than in a shared library.

As with any shared internal library, there are some tricky questions around its ownership and governance. One model is to say that as a shared asset, “everyone” owns it, though in practice this usually means that **no one** owns it. It can quickly become a hodge-podge of inconsistent code with no clear conventions or technical vision. At the other extreme, if development of the shared library is completely centralised, there will be a big disconnect between the people who create the components and the people who consume them. The best models that we've seen are ones where anyone can contribute to the library, but there is a [custodian](https://martinfowler.com/bliki/ServiceCustodian.html) (a person or a team) who is responsible for ensuring the quality, consistency, and validity of those contributions. The job of maintaining the shared library requires strong technical skills, but also the people skills necessary to cultivate collaboration across many teams.

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
