> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)
> * 译者：
> * 校对者：

# 微前端：未来前端开发的新趋势 — 第四部分

做好前端开发不是件容易的事情，而比这更难的是扩展前端开发规模以便于多个团队可以同时开发一个大型且复杂的产品。本系列文章将描述一种趋势，可以将大型的前端项目分解成许多个小而易于管理的部分，也将讨论这种体系结构如何提高前端代码团队工作的有效性和效率。除了讨论各种好处和代价之外，我们还将介绍一些可用的实现方案和深入探讨一个应用该技术的完整示例应用程序。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

## Cross-application communication

### The micro frontends

The logical place to continue this story is with the global render function we keep referring to. The home page of our application is a filterable list of restaurants, whose entry point looks like this:

```
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import registerServiceWorker from './registerServiceWorker';

window.renderBrowse = (containerId, history) => {
  ReactDOM.render(<App history={history} />, document.getElementById(containerId));
  registerServiceWorker();
};

window.unmountBrowse = containerId => {
  ReactDOM.unmountComponentAtNode(document.getElementById(containerId));
};
```

Usually in React.js applications, the call to `ReactDOM.render` would be at the top-level scope, meaning that as soon as this script file is loaded, it immediately begins rendering into a hard-coded DOM element. For this application, we need to be able control both when and where the rendering happens, so we wrap it in a function that receives the DOM element's ID as a parameter, and we attach that function to the global `window` object. We can also see the corresponding un-mounting function that is used for clean-up.

While we've already seen how this function is called when the micro frontend is integrated into the whole container application, one of the biggest criteria for success here is that we can develop and run the micro frontends independently. So each micro frontend also has its own `index.html` with an inline script to render the application in a “standalone” mode, outside of the container:

```
<html lang="en">
  <head>
    <title>Restaurant order</title>
  </head>
  <body>
    <main id="container"></main>
    <script type="text/javascript">
      window.onload = () => {
        window.renderRestaurant('container');
      };
    </script>
  </body>
</html>
```

![A screenshot of the 'order' page running as a standalone application outside of the container](https://martinfowler.com/articles/micro-frontends/screenshot-order.png)

Figure 9: Each micro frontend can be run as a standalone application outside of the container.

From this point onwards, the micro frontends are mostly just plain old React apps. The ['browse'](https://github.com/micro-frontends-demo/browse) application fetches the list of restaurants from the backend, provides `<input>` elements for searching and filtering the restaurants, and renders React Router `<Link>` elements, which navigate to a specific restaurant. At that point we would switch over to the second, ['order'](https://github.com/micro-frontends-demo/restaurant-order) micro frontend, which renders a single restaurant with its menu.

![An architecture diagram that shows the sequence of steps for navigation, as described above](https://martinfowler.com/articles/micro-frontends/demo-architecture.png)

Figure 10: These micro frontends interact only via route changes, not directly

The final thing worth mentioning about our micro frontends is that they both use `styled-components` for all of their styling. This CSS-in-JS library makes it easy to associate styles with specific components, so we are guaranteed that a micro frontend's styles will not leak out and effect the container, or another micro frontend.

### Cross-application communication via routing

We [mentioned earlier](https://martinfowler.com/articles/micro-frontends.html#Cross-applicationCommunication) that cross-application communication should be kept to a minimum. In this example, the only requirement we have is that the browsing page needs to tell the restaurant page which restaurant to load. Here we will see how we can use client-side routing to solve this problem.

All three React applications involved here are using React Router for declarative routing, but initialised in two slightly different ways. For the container application, we create a `<BrowserRouter>`, which internally will instantiate a `history` object. This is the same `history` object that we've been glossing over previously. We use this object to manipulate the client-side history, and we can also use it to link multiple React Routers together. Inside our micro frontends, we initialise the Router like this:

```
<Router history={this.props.history}>
```

In this case, rather than letting React Router instantiate another history object, we provide it with the instance that was passed in by the container application. All of the `<Router>` instances are now connected, so route changes triggered in any of them will be reflected in all of them. This gives us an easy way to pass “parameters” from one micro frontend to another, via the URL. For example in the browse micro frontend, we have a link like this:

```
<Link to={`/restaurant/${restaurant.id}`}>
```

When this link is clicked, the route will be updated in the container, which will see the new URL and determine that the restaurant micro frontend should be mounted and rendered. That micro frontend's own routing logic will then extract the restaurant ID from the URL and render the right information.

Hopefully this example flow shows the flexibility and power of the humble URL. Aside from being useful for sharing and bookmarking, in this particular architecture it can be a useful way to communicate intent across micro frontends. Using the page URL for this purpose ticks many boxes:

* Its structure is a well-defined, open standard
* It's globally accessible to any code on the page
* Its limited size encourages sending only a small amount of data
* It's user-facing, which encourages a structure that models the domain faithfully
* It's declarative, not imperative. I.e. "this is where we are", rather than "please do this thing"
* It forces micro frontends to communicate indirectly, and not know about or depend on each other directly

When using routing as our mode of communication between micro frontends, the routes that we choose constitute a **contract**. In this case, we've set in stone the idea that a restaurant can be viewed at `/restaurant/:restaurantId`, and we can't change that route without updating all applications that refer to it. Given the importance of this contract, we should have automated tests that check that the contract is being adhered to.

### Common content

While we want our teams and our micro frontends to be as independent as possible, there are some things that should be common. We wrote earlier about how [shared component libraries](https://martinfowler.com/articles/micro-frontends.html#SharedComponentLibraries) can help with consistency across micro frontends, but for this small demo a component library would be overkill. So instead, we have a small [repository of common content](https://github.com/micro-frontends-demo/content), including images, JSON data, and CSS, which are served over the network to all micro frontends.

There's another thing that we can choose to share across micro frontends: library dependencies. As we will [describe shortly](https://martinfowler.com/articles/micro-frontends.html#PayloadSize), duplication of dependencies is a common drawback of micro frontends. Even though sharing those dependencies across applications comes with its own set of difficulties, for this demo application it's worth talking about how it can be done.

The first step is to choose which dependencies to share. A quick analysis of our compiled code showed that about 50% of the bundles was contributed by `react` and `react-dom`. In addition to their size, these two libraries are our most 'core' dependencies, so we know that all micro frontends can benefit from having them extracted. Finally, these are stable, mature libraries, which usually introduce breaking changes across two major versions, so cross-application upgrade efforts should not be too difficult.

As for the actual extraction, all we need to do is mark the libraries as [externals](https://webpack.js.org/configuration/externals/) in our webpack config, which we can do with a rewiring similar to the one [described earlier](https://martinfowler.com/articles/micro-frontends.html#TheContainer).

```
module.exports = (config, env) => {
  config.externals = {
    react: 'React',
    'react-dom': 'ReactDOM'
  }
  return config;
};
```

Then we add a couple of `script` tags to each `index.html` file, to fetch the two libraries from our shared content server.

```
<body>
  <noscript>
    You need to enable JavaScript to run this app.
  </noscript>
  <div id="root"></div>
  <script src="%REACT_APP_CONTENT_HOST%/react.prod-16.8.6.min.js"></script>
  <script src="%REACT_APP_CONTENT_HOST%/react-dom.prod-16.8.6.min.js"></script>
</body>
```

Sharing code across teams is always a tricky thing to do well. We need to ensure that we only share things that we genuinely want to be common, and that we want to change in multiple places at once. However, if we're careful about what we do share and what we don't, then there are real benefits to be gained.

### Infrastructure

The application is hosted on AWS, with core infrastructure (S3 buckets, CloudFront distributions, domains, certificates, etc), provisioned all at once using a [centralised repository](https://github.com/micro-frontends-demo/infra) of Terraform code. Each micro frontend then has its own source repository with its own continuous deployment pipeline on [Travis CI](https://travis-ci.org/micro-frontends-demo/), which builds, tests, and deploys its static assets into those S3 buckets. This balances the convenience of centralised infrastructure management with the flexibility of independent deployability.

Note that each micro frontend (and the container) gets its own bucket. This means that it has free reign over what goes in there, and we don't need to worry about object name collisions, or conflicting access management rules, from another team or application.

* * *

## Downsides

At the start of this article, we mentioned that there are tradeoffs with micro frontends, as there are with any architecture. The benefits that we've mentioned do come with a cost, which we'll cover here.

### Payload size

Independently-built JavaScript bundles can cause duplication of common dependencies, increasing the number of bytes we have to send over the network to our end users. For example, if every micro frontend includes its own copy of React, then we're forcing our customers to download React **n** times. There is a [direct relationship](https://developers.google.com/web/fundamentals/performance/why-performance-matters/) between page performance and user engagement/conversion, and much of the world runs on internet infrastructure much slower than those in highly-developed cities are used to, so we have many reasons to care about download sizes.

This issue is not easy to solve. There is an inherent tension between our desire to let teams compile their applications independently so that they can work autonomously, and our desire to build our applications in such a way that they can share common dependencies. One approach is to externalise common dependencies from our compiled bundles, [as we described](https://martinfowler.com/articles/micro-frontends.html#CommonContent) for the demo application. As soon as we go down this path though, we've re-introduced some build-time coupling to our micro frontends. Now there is an implicit contract between them which says, “we all must use these exact versions of these dependencies”. If there is a breaking change in a dependency, we might end up needing a big coordinated upgrade effort and a one-off lockstep release event. This is everything we were trying to avoid with micro frontends in the first place!

This inherent tension is a difficult one, but it's not all bad news. Firstly, even if we choose to do nothing about duplicate dependencies, it's possible that each individual page will still load faster than if we had built a single monolithic frontend. The reason is that by compiling each page independently, we have effectively implemented our own form of code splitting. In classic monoliths, when any page in the application is loaded, we often download the source code and dependencies of every page all at once. By building independently, any single page-load will only download the source and dependencies of that page. This may result in faster initial page-loads, but slower subsequent navigation as users are forced to re-download the same dependencies on each page. If we are disciplined in not bloating our micro frontends with unnecessary dependencies, or if we know that users generally stick to just one or two pages within the application, we may well achieve a net **gain** in performance terms, even with duplicated dependencies.

There are lots of “may’s” and “possibly’s” in the previous paragraph, which highlights the fact that every application will always have its own unique performance characteristics. If you want to know for sure what the performance impacts will be of a particular change, there is no substitute for taking real-world measurements, ideally in production. We've seen teams agonise over a few extra kilobytes of JavaScript, only to go and download many megabytes of high-resolution images, or run expensive queries against a very slow database. So while it's important to consider the performance impacts of every architectural decision, be sure that you know where the real bottlenecks are.

### Environment differences

We should be able to develop a single micro frontend without needing to think about all of the other micro frontends being developed by other teams. We may even be able to run our micro frontend in a “standalone” mode, on a blank page, rather than inside the container application that will house it in production. This can make development a lot simpler, especially when the real container is a complex, legacy codebase, which is often the case when we're using micro frontends to do a gradual migration from old world to new. However, there are risks associated with developing in an environment that is quite different to production. If our development-time container behaves differently than the production one, then we may find that our micro frontend is broken, or behaves differently when we deploy to production. Of particular concern are global styles that may be brought along by the container, or by other micro frontends.

The solution here is not that different to any other situation where we have to worry about environmental differences. If we're developing locally in an environment that is not production-like, we need to ensure that we regularly integrate and deploy our micro frontend to environments that **are** like production, and we should do testing (manual and automated) in these environments to catch integration issues as early as possible. This will not completely solve the problem, but ultimately it's another tradeoff that we have to weigh up: is the productivity boost of a simplified development environment worth the risk of integration issues? The answer will depend on the project!

### Operational and governance complexity

The final downside is one with a direct parallel to microservices. As a more distributed architecture, micro frontends will inevitably lead to having more **stuff** to manage - more repositories, more tools, more build/deploy pipelines, more servers, more domains, etc. So before adopting such an architecture there are a few questions you should consider:

* Do you have enough automation in place to feasibly provision and manage the additional required infrastructure?
* Will your frontend development, testing, and release processes scale to many applications?
* Are you comfortable with decisions around tooling and development practices becoming more decentralised and less controllable?
* How will you ensure a minimum level of quality, consistency, or governance across your many independent frontend codebases?

We could probably fill another entire article discussing these topics. The main point we wish to make is that when you choose micro frontends, by definition you are opting to create many small things rather than one large thing. You should consider whether you have the technical and organisational maturity required to adopt such an approach without creating chaos.

* * *

## Conclusion

As frontend codebases continue to get more complex over the years, we see a growing need for more scalable architectures. We need to be able to draw clear boundaries that establish the right levels of coupling and cohesion between technical and domain entities. We should be able to scale software delivery across independent, autonomous teams.

While far from the only approach, we have seen many real-world cases where micro frontends deliver these benefits, and we've been able to apply the technique gradually over time to legacy codebases as well as new ones. Whether micro frontends are the right approach for you and your organiation or not, we can only hope that this will be part of a continuing trend where frontend engineering and architecture is treated with the seriousness that we know it deserves.

* * *

if you found this article useful, please share it. I appreciate the feedback and encouragement

## Acknowledgements

Huge thanks to Charles Korn, Andy Marks, and Willem Van Ketwich for their thorough reviews and detailed feedback. Thanks also to Bill Codding, Michael Strasser, and Shirish Padalkar for their input given on the ThoughtWorks internal mailing list. Thanks to Martin Fowler for his feedback as well, and for giving this this article a home here on his website. And finally, thanks to Evan Bottcher and Liauw Fendy for their encouragement and support.

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
