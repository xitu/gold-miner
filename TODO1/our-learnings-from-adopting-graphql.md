> * 原文地址：[Our learnings from adopting GraphQL: A Marketing Tech Campaign](https://medium.com/netflix-techblog/our-learnings-from-adopting-graphql-f099de39ae5f)
> * 原文作者：[Netflix Technology Blog](https://medium.com/@NetflixTechBlog?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/our-learnings-from-adopting-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO1/our-learnings-from-adopting-graphql.md)
> * 译者：
> * 校对者：

# Our learnings from adopting GraphQL: A Marketing Tech Campaign

In an [earlier blog post](https://github.com/xitu/gold-miner/blob/master/TODO1/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2.md), we provided a high-level overview of some of the applications in the Marketing Technology team that we build to enable _scale and intelligence_ in driving our global advertising, which reaches users on sites like The New York Times, Youtube, and thousands of others. In this post, we’ll share our journey in updating our front-end architecture and our learnings in introducing GraphQL into the Marketing Tech system.

Our primary application for managing the creation and assembly of ads that reach the external publishing platforms is internally dubbed **_Monet_**. It’s used to supercharge ad creation and automate management of marketing campaigns on external ad platforms. Monet helps drive incremental conversions, engagement with our product and in general, present a rich story about our content and the Netflix brand to users around the world. To do this, first, it helps scale up and automate ad production and manage millions of creative permutations. Secondly, we utilize various signals and aggregate data such as understanding of content popularity on Netflix to enable highly relevant ads. Our overall aim is to make our ads on all the external publishing channels resonate well with users and we are constantly experimenting to improve our effectiveness in doing that.

![](https://cdn-images-1.medium.com/max/800/0*CafLBZiEtz9uwO62)

Monet and the high-level _Marketing Technology_ flow

When we started out, the React UI layer for Monet accessed traditional REST APIs powered by an Apache Tomcat server. Over time, as our application evolved, our use cases became more complex. Simple pages would need to draw in data from a wide variety of sources. To more effectively load this data onto the client application, we first attempted to denormalize data on the backend. Managing this denormalization became difficult to maintain since not all pages needed all the data. We quickly ran into network bandwidth bottlenecks. The browser would need to fetch much more denormalized data than it would ever use.

To winnow down the number of fields sent to the client, one approach is to build custom endpoints for every page; it was a fairly obvious non-starter. Instead of building these custom endpoints, we opted for GraphQL as the middle layer of the app. We also considered [Falcor](https://netflix.github.io/falcor/) as a possible solution since it has delivered great results at Netflix in many core use cases and has a ton of usage, but a robust GraphQL ecosystem and powerful third party tooling made GraphQL the better option for our use case. Also, as our data structures have become increasingly graph-oriented, it ended up being a very natural fit. Not only did adding GraphQL solve the network bandwidth bottleneck, but it also provided numerous other benefits that helped us add features more quickly.

![](https://cdn-images-1.medium.com/max/800/1*pmh-VimZJJindIJUyZtyzg.png)

Architecture before and after GraphQL

### Benefits

We have been running GraphQL on NodeJS for about 6 months, and it has proven to significantly increase our development velocity and overall page load performance. Here are some of the benefits that worked out well for us since we started using it.

**Redistributing load and payload optimization**

Often times, some machines are better suited for certain tasks than others. When we added the GraphQL middle layer, the GraphQL server still needed to call the same services and REST APIs as the client would have called directly. The difference now is that the majority of the data is flowing between servers within the same data center. These server to server calls are of very low latency and high bandwidth, which gives us about an 8x performance boost compared to direct network calls from the browser. The last mile of the data transfer from the GraphQL server to the client browser, although still a slow point, is now reduced to a single network call. Since GraphQL allows the client to select only the data it needs we end up fetching a significantly smaller payload. In our application, pages that were fetching 10MB of data before now receive about 200KB. Page loads became much faster, especially over data-constrained mobile networks, and our app uses much less memory. These changes did come at the cost of higher server utilization to perform data fetching and aggregation, but the few extra milliseconds of server time per request were greatly outweighed by the smaller client payloads.

**Reusable abstractions**

Software developers generally want to work with reusable abstractions instead of single-purpose methods. With GraphQL, we define each piece of data once and define how it relates to other data in our system. When the consumer application fetches data from multiple sources, it no longer needs to worry about the complex business logic associated with data join operations.

Consider the following example, we define entities in GraphQL exactly once: _catalogs, creatives, and comments_. We can now build the views for several pages from these definitions. One page on the client app (catalogView) declares that it wants all comments for all creatives in a catalog while another client page (creativeView) wants to know the associated catalog that a creative belongs to, along with all of its comments.

![](https://cdn-images-1.medium.com/max/800/1*Tr-cnrbTOPKkWkshYpQeIA.png)

The flexibility of the GraphQL data model to represent different views from the same underlying data

The same graph model can power both of these views without having to make any server side code changes.

**Chaining type systems**

Many people focus on type systems within a single service, but rarely across services. Once we defined the entities in our GraphQL server, we use auto codegen tools to generate TypeScript types for the client application. The props of our React components receive types to match the query that the component is making. Since these types and queries are also validated against the server schema, any breaking change by the server would be caught by clients consuming the data. Chaining multiple services together with GraphQL and hooking these checks into the build process allows us to catch many more issues before deploying bad code. Ideally, we would like to have type safety from the database layer all the way to the client browser.

![](https://cdn-images-1.medium.com/max/800/1*YLL0aFFgcGDXFEa-V9_LPA.png)

Type safety from database to backend to client code

**DI/DX — Simplifying development**

A common concern when creating client applications is the UI/UX, but the developer interface and developer experience is just as important for building maintainable apps. Before GraphQL, writing a new React container component required maintaining complex logic to make network requests for the data we need. The developer would need to consider how one piece of data relates to another, how the data should be cached, whether to make the calls in parallel or in sequence and where in Redux to store the data. With a GraphQL query wrapper, each React component only needs to describe the data it needs, and the wrapper takes care of all of these concerns. There is much less boilerplate code and a cleaner separation of concerns between the data and UI. This model of declarative data fetching makes the React components much easier to understand, and serves to partially document what the component is doing.

**Other benefits**

There are a few other smaller benefits that we noticed as well. First, if any resolver of the GraphQL query fails, the resolvers that succeeded still return data to the client to render as much of the page as possible. Second, the backend data model is greatly simplified since we are less concerned with modeling for the client and in most cases can simply provide a CRUD interface to raw entities. Finally, testing our components has also become easier since the GraphQL query is automatically translatable into stubs for our tests and we can test resolvers in isolation from the React components.

### Growing pains

Our migration to GraphQL was a straightforward experience. Most of the infrastructure we built to make network requests and transform data was easily transferable from our React application to our NodeJS server without any code changes. We even ended up deleting more code than we added. But as with any migration to a new technology, there were a few obstacles we needed to overcome.

**Selfish resolvers**

Since resolvers in GraphQL are meant to run as isolated units that are not concerned with what other resolvers do, we found that they were making many duplicate network requests for the same or similar data. We got around this duplication by wrapping the data providers in a simple caching layer that stored network responses in memory until all resolvers finished. The caching layer also allowed us to aggregate multiple requests to a single service into a bulk request for all the data at once. Resolvers can now request any data they need without worrying about how to optimize the process of fetching it.

![](https://cdn-images-1.medium.com/max/800/1*FZCtNPL4bXS6jpgVZx0RYg.png)

Adding a cache to simplify data access from resolvers

**What a tangled web we weave**

Abstractions are a great way to make developers more efficient… until something goes wrong. There will undoubtedly be bugs in our code and we didn’t want to obfuscate the root cause with a middle layer. GraphQL would orchestrate network calls to other services automatically, hiding the complexities from the user. Server logs provide a way to debug, but they are still one step removed from the natural approach of debugging via the browser’s network tab. To make debugging easier, we added logs directly to the GraphQL response payload that expose all of the network requests that the server is making. When the debug flag is enabled, you get the same data in the client browser as you would if the browser made the network call directly.

**Breaking down typing**

Passing around objects is what OOP is all about, but unfortunately, GraphQL throws a wrench into this paradigm. When we fetch partial objects, this data cannot be used in methods and components that require the full object. Of course, you can cast the object manually and hope for the best, but you lose many of the benefits of type systems. Luckily, TypeScript uses duck typing, so adjusting the methods to only require the object properties that they really need was the quickest fix. Defining these more precise types takes a bit more work, but gives greater type safety overall.

### What comes next

We are still in the early stages in our exploration of GraphQL, but it’s been a positive experience so far and we’re happy to have embraced it. One of the key goals of this endeavor was to help us get increased development velocity as our systems become increasingly sophisticated. Instead of being bogged down with complex data structures, we hope for the investment in the graph data model to make our team more productive over time as more edges and nodes are added. Even over the last few months, we have found that our existing graph model has become sufficiently robust that we don’t need any graph changes to be able to build some features. It has certainly made us more productive.

![](https://cdn-images-1.medium.com/max/800/1*T3KO2GOY6EhoWUdQw8zuLQ.png)

Visualization of our GraphQL Schema

As GraphQL continues to thrive and mature, we look forward to learning from all the amazing things that the community can build and solve with it. On an implementation level, we are looking forward to using some cool concepts like schema stitching, which can make integrations with other services much more straightforward and save a great deal of developer time. Most crucially, it’s very exciting to see a lot more teams [across our company](https://medium.com/netflix-techblog/the-new-netflix-stethoscope-native-app-f4e1d38aafcd) see GraphQL’s potential and start to adopt it.

If you’ve made this thus far and you’re also interested in joining the Netflix Marketing Technology team to help conquer our unique challenges, check out the [open positions](https://sites.google.com/netflix.com/adtechjobs/ad-tech-engineering) listed on our page. **_We’re hiring!_**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
