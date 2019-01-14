> * 原文地址：[Front-End Performance Checklist 2019 — 2](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2019 — 2

Let’s make 2019... fast! An annual front-end performance checklist, with everything you need to know to create fast experiences today. Updated since 2016.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> **[译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)**
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### Table Of Contents

- [Setting Realistic Goals](#setting-realistic-goals)
  - [7. 100-millisecond response time, 60 fps.](#7-100-millisecond-response-time-60-fps)
  - [8. Speed Index < 1250, TTI < 5s on 3G, Critical file size budget < 170KB (gzipped).](#8-speed-index--1250-tti--5s-on-3g-critical-file-size-budget--170kb-gzipped)
- [Defining The Environment](#defining-the-environment)
  - [9. Choose and set up your build tools](#9-choose-and-set-up-your-build-tools)
  - [10. Use progressive enhancement as a default.](#10-use-progressive-enhancement-as-a-default)
  - [11. Choose a strong performance baseline](#11-choose-a-strong-performance-baseline)
  - [12. Evaluate each framework and each dependency.](#12-evaluate-each-framework-and-each-dependency)
  - [13. Consider using PRPL pattern and app shell architecture](#13-consider-using-prpl-pattern-and-app-shell-architecture)
  - [14. Have you optimized the performance of your APIs?](#14-have-you-optimized-the-performance-of-your-apis)
  - [15. Will you be using AMP or Instant Articles?](#15-will-you-be-using-amp-or-instant-articles)
  - [16. Choose your CDN wisely](#16-choose-your-cdn-wisely)

### Setting Realistic Goals

#### 7. 100-millisecond response time, 60 fps.

For an interaction to feel smooth, the interface has 100ms to respond to user’s input. Any longer than that, and the user perceives the app as laggy. The [RAIL, a user-centered performance model](https://www.smashingmagazine.com/2015/10/rail-user-centric-model-performance/) gives you healthy targets: To allow for <100 milliseconds response, the page must yield control back to main thread at latest after every <50 milliseconds. [Estimated Input Latency](https://developers.google.com/web/tools/lighthouse/audits/estimated-input-latency) tells us if we are hitting that threshold, and ideally, it should be below 50ms. For high-pressure points like animation, it’s best to do nothing else where you can and the absolute minimum where you can't.

[![RAIL](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c91c910d-e934-4610-9dc5-369ec9071b57/rail-perf-model-opt.png)](https://developers.google.com/web/fundamentals/performance/rail)
    
[RAIL](https://developers.google.com/web/fundamentals/performance/rail), a user-centric performance model.

Also, each frame of animation should be completed in less than 16 milliseconds, thereby achieving 60 frames per second (1 second ÷ 60 = 16.6 milliseconds) — preferably under 10 milliseconds. Because the browser needs time to paint the new frame to the screen, your code should finish executing before hitting the 16.6 milliseconds mark. We’re starting having conversations about 120fps (e.g. iPad’s new screens run at 120Hz) and Surma has covered some [rendering performance solutions for 120fps](https://dassur.ma/things/120fps/), but that’s probably not a target we’re looking at _just yet_.

Be pessimistic in performance expectations, but [be optimistic in interface design](https://www.smashingmagazine.com/2016/11/true-lies-of-optimistic-user-interfaces/) and [use idle time wisely](https://philipwalton.com/articles/idle-until-urgent/). Obviously, these targets apply to runtime performance, rather than loading performance.

#### 8. Speed Index < 1250, TTI < 5s on 3G, Critical file size budget < 170KB (gzipped).

Although it might be very difficult to achieve, a good ultimate goal would be First Meaningful Paint under 1 second and a [Speed Index](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index) value under 1250. Considering the baseline being a $200 Android phone (e.g. Moto G4) on a slow 3G network, emulated at 400ms RTT and 400kbps transfer speed, aim for [Time to Interactive under 5s](https://www.youtube.com/watch?v=_srJ7eHS3IM&feature=youtu.be&t=6m21s), and for repeat visits, aim for under 2s (achievable only with a service worker),

Notice that, when speaking about interactivity metrics, it’s a good idea to [distinguish between First CPU Idle and Time To Interactive](https://calendar.perfplanet.com/2017/time-to-interactive-measuring-more-of-the-user-experience/) to avoid misunderstandings down the line. The former is the earliest point after the main content has rendered (where there is at least a 5-second window where the page is responsive). The latter is the point where the page can be expected to always be responsive to input (_thanks, Philip Walton!_).

We have two major constraints that effectively shape a _reasonable_ target for speedy delivery of the content on the web. On the one hand, we have **network delivery constraints** due to [TCP Slow Start](https://hpbn.co/building-blocks-of-tcp/#slow-start). The first 14KB of the HTML is the >most critical payload chunk — and the only part of the budget that can be delivered in the first roundtrip (which is all you get in 1 sec at 400ms RTT due to mobile wake-up times).

On the other hand, we have **hardware constraints** on memory and CPU due to JavaScript parsing times (we’ll talk about them in detail later). To achieve the goals stated in the first paragraph, we have to consider the critical file size budget for JavaScript. Opinions vary on what that budget should be (and it heavily depends on the nature of your project), but a budget of 170KB JavaScript gzipped already would take up to 1s to parse and compile on an average phone. Assuming that 170KB expands to 3× that size when decompressed (0.7MB), that already could be the death knell of a "decent" user experience on a Moto G4 or Nexus 2.

Of course, your data might show that your customers are not on these devices, but perhaps they simply don’t show up in your analytics because your service is inaccessible to them due to slow performance. In fact, Google’s Alex Russels recommends to [aim for 130–170KB gzipped](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) as a reasonable upper boundary, and exceeding this budget should be an informed and deliberate decision. In real-life world, most products aren’t even close: an average bundle size today is around [400KB](https://beta.httparchive.org/reports/state-of-javascript#bytesJs), which is up 35% compared to late 2015. On a middle-class mobile device, that accounts for 30-35 seconds for _Time-To-Interactive_.

We could also go beyond the bundle size budget though. For example, we could set performance budgets based on the activities of the browser’s main thread, i.e. paint time before start render, or [track down front-end CPU hogs](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/). Tools such as [Calibre](https://calibreapp.com/), [SpeedCurve](https://speedcurve.com/) and [Bundlesize](https://github.com/siddharthkp/bundlesize) can help you keep your budgets in check, and can be integrated into your build process.

Also, a performance budget probably shouldn’t be a fixed value. Depending on the network connection, [performance budgets should adapt](https://twitter.com/katiehempenius/status/1075478356311924737), but payload on slower connection is much more "expensive", regardless of how they’re used.

[![From 'Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/3bb4ab9e-978a-4db0-83c3-57a93d70516d/file-size-budget-fast-default-addy-osmani-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

[From Fast By Default: Modern loading best practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by Addy Osmani (Slide 19)

[![](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/949e5601-04e7-48ee-91a5-10bd7af19a0f/perf-budgets-network-connection.jpg)](https://twitter.com/katiehempenius/status/1075478356311924737) 

Performance budgets should adapt depending on the network conditions for an average mobile device. (Image source: [Katie Hempenius](https://twitter.com/katiehempenius/status/1075478356311924737)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/949e5601-04e7-48ee-91a5-10bd7af19a0f/perf-budgets-network-connection.jpg))

### Defining The Environment

#### 9. Choose and set up your build tools

[Don’t pay too much attention to what’s supposedly cool](https://24ways.org/2017/all-that-glisters/) [these days](https://2018.stateofjs.com/). Stick to your environment for building, be it Grunt, Gulp, Webpack, Parcel, or a combination of tools. As long as you are getting results you need and you have no issues maintaining your build process, you’re doing just fine.

Among the build tools, Webpack seems to be the most established one, with literally hundreds of plugins available to optimize the size of your builds. Getting started with Webpack can be tough though. So if you want to get started, there are some great resources out there:
    
*   [Webpack documentation](https://webpack.js.org/concepts/) — obviously — is a good starting point, and so are [Webpack — The Confusing Bits](https://medium.com/@rajaraodv/webpack-the-confusing-parts-58712f8fcad9) by Raja Rao and [An Annotated Webpack Config](https://nystudio107.com/blog/an-annotated-webpack-4-config-for-frontend-web-development) by Andrew Welch.

*   Sean Learkin has a free course on [Webpack: The Core Concepts](https://webpack.academy/p/the-core-concepts) and Jeffrey Way has released a fantastic free course on [Webpack for everyone](https://laracasts.com/series/webpack-for-everyone). Both of them are great introductions for diving into Webpack.

*   [Webpack Fundamentals](https://frontendmasters.com/courses/webpack-fundamentals/) is a very comprehensive 4h course with Sean Larkin, released by FrontendMasters.

*   If you are slightly more advanced, Rowan Oulton has published a [Field Guide for Better Build Performance with Webpack](https://slack.engineering/keep-webpack-fast-a-field-guide-for-better-build-performance-f56a5995e8f1) and Benedikt Rötsch’s made a tremendous research on [putting Webpack bundle on a diet](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/).

*   [Webpack examples](https://github.com/webpack/webpack/tree/master/examples) has hundreds of ready-to-use Webpack configurations, categorized by topic and purpose. Bonus: there is also a [Webpack config configurator](https://webpack.jakoblind.no/) that generates a basic configuration file.

*   [awesome-webpack](https://github.com/webpack-contrib/awesome-webpack) is a curated list of useful Webpack resources, libraries and tools, including articles, videos, courses, books and examples for Angular, React and framework-agnostic projects.
#### 10. Use progressive enhancement as a default.

Keeping [progressive enhancement](https://www.aaron-gustafson.com/notebook/insert-clickbait-headline-about-progressive-enhancement-here/) as the guiding principle of your front-end architecture and deployment is a safe bet. Design and build the core experience first, and then enhance the experience with advanced features for capable browsers, creating [resilient](https://resilientwebdesign.com/) experiences. If your website runs fast on a slow machine with a poor screen in a poor browser on a sub-optimal network, then it will only run faster on a fast machine with a good browser on a decent network.
    
#### 11. Choose a strong performance baseline

With so many unknowns impacting loading — the network, thermal throttling, cache eviction, third-party scripts, parser blocking patterns, disk I/O, IPC latency, installed extensions, antivirus software and firewalls, background CPU tasks, hardware and memory constraints, differences in L2/L3 caching, RTTS — [JavaScript has the heaviest cost of the experience](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4), next to web fonts blocking rendering by default and images often consuming too much memory. With the performance bottlenecks [moving away from the server to the client](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/), as developers, we have to consider all of these unknowns in much more detail.

With a 170KB budget that already contains the critical-path HTML/CSS/JavaScript, router, state management, utilities, framework and the application logic, we have to thoroughly [examine network transfer cost, the parse/compile time and the runtime cost](https://www.twitter.com/kristoferbaxter/status/908144931125858304) of the framework of our choice.

As [noted](https://twitter.com/sebmarkbage/status/829733454119989248) by Seb Markbåge, a good way to measure start-up costs for frameworks is to first render a view, then delete it and then render again as it can tell you how the framework scales. The first render tends to warm up a bunch of lazily compiled code, which a larger tree can benefit from when it scales. The second render is basically an emulation of how code reuse on a page affects the performance characteristics as the page grows in complexity.

[!['Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/39c247a9-223f-4a6c-ae3d-db54a696ffcb/tti-budget-opt.png)](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)

From [Fast By Default: Modern Loading Best Practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by Addy Osmani (Slides 18, 19).

#### 12. Evaluate each framework and each dependency.

Now, [not every project needs a framework](https://twitter.com/jaffathecake/status/923805333268639744) and [not every page of a single-page-application needs to load a framework](https://medium.com/dev-channel/a-netflix-web-performance-case-study-c0bcde26a9d9). In Netflix’s case, "removing React, several libraries and the corresponding app code from the client-side reduced the total amount of JavaScript by over 200KB, causing [an over-50% reduction in Netflix’s Time-to-Interactivity](https://news.ycombinator.com/item?id=15567657) for the logged-out homepage." The team then utilized the time spent by users on the landing page to prefetch React for subsequent pages that users were likely to land on ([read on for details](https://jakearchibald.com/2017/netflix-and-react/)).

It might sound obvious but worth stating: some projects can also benefit [benefit from removing an existing framework](https://twitter.com/jaffathecake/status/925320026411950080) altogether. Once a framework is chosen, you’ll be staying with it for at least a few years, so if you need to use one, make sure your choice [is informed](https://www.youtube.com/watch?v=6I_GwgoGm1w) and [well considered](https://medium.com/@ZombieCodeKill/choosing-a-javascript-framework-535745d0ab90#.2op7rjakk).

Inian Parameshwaran [has measured performance footprint of top 50 frameworks](https://youtu.be/wVY3-acLIoI?t=699) (against [_First Contentful Paint_](https://developers.google.com/web/tools/lighthouse/audits/first-contentful-paint) — the time from navigation to the time when the browser renders the first bit of content from the DOM). Inian discovered that, out there in the wild, Vue and Preact are the fastest across the board — both on desktop and mobile, followed by React ([slides](https://drive.google.com/file/d/1CoCQP7qyvkSQ4VG9L_PTWD5AF9wF28XT/view)). You could examine your framework candidates and the proposed architecture, and study how most solutions out there perform, e.g. with server-side rendering or client-side rendering, on average.

Baseline performance cost matters. According to a [study by Ankur Sethi](https://blog.uncommon.is/the-baseline-costs-of-javascript-frameworks-f768e2865d4a), "your React application will never load faster than about 1.1 seconds on an average phone in India, no matter how much you optimize it. Your Angular app will always take at least 2.7 seconds to boot up. The users of your Vue app will need to wait at least 1 second before they can start using it." You might not be targeting India as your primary market anyway, but users accessing your site with suboptimal network conditions will have a comparable experience. In exchange, your team gains maintainability and developer efficiency, of course. But this consideration needs to be deliberate.

You could go as far as evaluating a framework (or any JavaScript library) on Sacha Greif’s [12-point scale scoring system](https://medium.freecodecamp.org/the-12-things-you-need-to-consider-when-evaluating-any-new-javascript-library-3908c4ed3f49) by exploring features, accessibility, stability, performance, package ecosystem, community, learning curve, documentation, tooling, track record, team, compatibility, security for example. But on a tough schedule, it’s a good idea to consider _at least_ the total cost on size + initial parse times before choosing an option; lightweight options such as [Preact](https://github.com/developit/preact), [Inferno](https://github.com/infernojs/inferno), [Vue](https://vuejs.org/), [Svelte](https://svelte.technology/) or [Polymer](https://github.com/Polymer/polymer) can get the job done just fine. The size of your baseline will define the constraints for your application’s code.

A good starting point is to choose a good default stack for your application. [Gatsby.js](http://gatsbyjs.org/) (React), [Preact CLI](https://github.com/developit/preact-cli), and [PWA Starter Kit](https://github.com/Polymer/pwa-starter-kit) provide reasonable defaults for fast loading out of the box on average mobile hardware.

[![JavaScript processing times in 2018 by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/53363a80-48ae-4f91-aed0-69d292e6d7a2/2018-js-processing-times.png)](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4) 

(Image credit: [Addy Osmani](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/53363a80-48ae-4f91-aed0-69d292e6d7a2/2018-js-processing-times.png))

#### 13. Consider using PRPL pattern and app shell architecture

Different frameworks will have different effects on performance and will require different strategies of optimization, so you have to clearly understand all of the nuts and bolts of the framework you’ll be relying on. When building a web app, look into the [PRPL pattern](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) and [application shell architecture](https://developers.google.com/web/updates/2015/11/app-shell). The idea is quite straightforward: Push the minimal code needed to get interactive for the initial route to render quickly, then use service worker for caching and pre-caching resources and then lazy-load routes that you need, asynchronously.

[![PRPL Pattern in the application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bb4716e5-d25b-4b80-b468-f28d07bae685/app-build-components-dibweb-c-scalew-879-opt.png)](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)

[PRPL](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) stands for Pushing critical resource, Rendering initial route, Pre-caching remaining routes and Lazy-loading remaining routes on demand.

[![Application shell architecture](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6423db84-4717-4aeb-9174-7ae96bf4f3aa/appshell-1-o0t8qd-c-scalew-799-opt.jpg)](https://developers.google.com/web/updates/2015/11/app-shell)

An [application shell](https://developers.google.com/web/updates/2015/11/app-shell) is the minimal HTML, CSS, and JavaScript powering a user interface.

#### 14. Have you optimized the performance of your APIs? 

APIs are communication channels for an application to expose data to internal and third-party applications via so-called _endpoints_. When [designing and building an API](https://www.smashingmagazine.com/2012/10/designing-javascript-apis-usability/), we need a reasonable protocol to enable the communication between the server and third-party requests. [Representational State Transfer](https://www.smashingmagazine.com/2018/01/understanding-using-rest-api/) ([_REST_](http://web.archive.org/web/20130116005443/http://tomayko.com/writings/rest-to-my-wife)) is a well-established, logical choice: it defines a set of constraints that developers follow to make content accessible in a performant, reliable and scalable fashion. Web services that conform to the REST constraints, are called _RESTful web services_.

As with good ol' HTTP requests, when data is retrieved from an API, any delay in server response will propagate to the end user, hence delaying rendering. When a resource wants to retrieve some data from an API, it will need to request the data from the corresponding endpoint. A component that renders data from several resources, such as an article with comments and author photos in each comment, may need several roundtrips to the server to fetch all the data before it can be rendered. Furthermore, the amount of data returned through REST is often more than what is needed to render that component.

If many resources require data from an API, the API might become a performance bottleneck. [GraphQL](https://graphql.org/) provides a performant solution to these issues. Per se, GraphQL is a query language for your API, and a server-side runtime for executing queries by using a type system you define for your data. Unlike REST, GraphQL can retrieve all data in a single request, and the response will be exactly what is required, without _over_ or _under_-fetching data as it typically happens with REST.

In addition, because GraphQL is using schema (metadata that tells how the data is structured), it can already organize data into the preferred structure, so, for example, [with GraphQL, we could remove JavaScript code used for dealing with state management](https://hackernoon.com/how-graphql-replaces-redux-3fff8289221d), producing a cleaner application code that runs faster on the client.

If you want to get started with GraphQL, Eric Baer published two fantastic articles on yours truly Smashing Magazine: [A GraphQL Primer: Why We Need A New Kind Of API](https://www.smashingmagazine.com/2018/01/graphql-primer-new-api-part-1/) and [A GraphQL Primer: The Evolution Of API Design](https://www.smashingmagazine.com/2018/01/graphql-primer-new-api-part-2/) (_thanks for the hint, Leonardo!_).

[![Hacker Noon](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5fda8d85-1151-4d0b-b2f6-da354ebae345/redux-rest-apollo-graphql.png)](https://hackernoon.com/how-graphql-replaces-redux-3fff8289221d) 

A difference between REST and GraphQL, illustrated via a conversation between Redux + REST on the left, an Apollo + GraphQL on the right. (Image source: [Hacker Noon](https://hackernoon.com/how-graphql-replaces-redux-3fff8289221d)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5fda8d85-1151-4d0b-b2f6-da354ebae345/redux-rest-apollo-graphql.png))

#### 15. Will you be using AMP or Instant Articles?

Depending on the priorities and strategy of your organization, you might want to consider using Google’s [AMP](https://www.ampproject.org/) or Facebook’s [Instant Articles](https://instantarticles.fb.com/) or Apple’s [Apple News](https://www.apple.com/news/). You can achieve good performance without them, but AMP _does_ provide a solid performance framework with a free content delivery network (CDN), while Instant Articles will boost your visibility and performance on Facebook.

The seemingly obvious benefit of these technologies for users is _guaranteed performance_, so at times they might even prefer AMP-/Apple News/Instant Pages-links over "regular" and potentially bloated pages. For content-heavy websites that are dealing with a lot of third-party content, these options could potentially help speed up render times dramatically.

[Unless they don't.](https://timkadlec.com/remembers/2018-03-19-how-fast-is-amp-really/) According to Tim Kadlec, for example, "AMP documents tend to be faster than their counterparts, but they don’t necessarily mean a page is performant. AMP is not what makes the biggest difference from a performance perspective."

A benefit for the website owner is obvious: discoverability of these formats on their respective platforms and [increased visibility in search engines](https://ethanmarcotte.com/wrote/ampersand/). You could build [progressive web AMPs](https://www.smashingmagazine.com/2016/12/progressive-web-amps/), too, by reusing AMPs as a data source for your PWA. Downside? Obviously, a presence in a walled garden places developers in a position to produce and maintain a separate version of their content, and in case of Instant Articles and Apple News [without actual URLs](https://www.w3.org/blog/TAG/2017/07/27/distributed-and-syndicated-content-whats-wrong-with-this-picture/) _(thanks Addy, Jeremy!)_.

#### 16. Choose your CDN wisely

Depending on how much dynamic data you have, you might be able to "outsource" some part of the content to a [static site generator](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/), pushing it to a CDN and serving a static version from it, thus avoiding database requests. You could even choose a [static-hosting platform](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/) based on a CDN, enriching your pages with interactive components as enhancements ([JAMStack](https://jamstack.org/)). In fact, some of those generators (like [Gatsby](https://www.gatsbyjs.org/blog/2017-09-13-why-is-gatsby-so-fast/) on top of React) are actually [website compilers](https://tomdale.net/2017/09/compilers-are-the-new-frameworks/) with many automated optimizations provided out of the box. As compilers add optimizations over time, the compiled output gets smaller and faster over time.

Notice that CDNs can serve (and offload) dynamic content as well. So, restricting your CDN to static assets is not necessary. Double-check whether your CDN performs compression and conversion (e.g. image optimization in terms of formats, compression and resizing at the edge), [support for servers workers](https://www.filamentgroup.com/lab/servers-workers.html), edge-side includes, which assemble static and dynamic parts of pages at the CDN’s edge (i.e. the server closest to the user), and other tasks.

Note: based on research by Patrick Meenan and Andy Davies, HTTP/2 is [effectively broken on many CDNs](https://github.com/andydavies/http2-prioritization-issues#cdns--cloud-hosting-services), so we shouldn’t be too optimistic about the performance boost there.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> **[译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)**
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> [译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
