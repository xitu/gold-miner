> * 原文地址：[Web Architecture 101: The basic architecture concepts I wish I knew when I was getting started as a web developer](https://engineering.videoblocks.com/web-architecture-101-a3224e126947)
> * 原文作者：[Jonathan Fulton](https://engineering.videoblocks.com/@jonathan_fulton?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/web-architecture-101.md](https://github.com/xitu/gold-miner/blob/master/TODO1/web-architecture-101.md)
> * 译者：[horizon13th](https://github.com/horizon13th)
> * 校对者：

# Web Architecture 101 网络应用架构必修课

## The basic architecture concepts I wish I knew when I was getting started as a web developer 初级后端开发者必学的基础网络架构

![](https://cdn-images-1.medium.com/max/800/1*K6M-x-6e39jMq_c-2xqZIQ.png)

Modern web application architecture overview 网络应用主流架构概览

The above diagram is a fairly good representation of our architecture at Storyblocks. If you’re not an experienced web developer, you’ll likely find it complicated. The walk through below should make it more approachable before we dive into the details of each component. 上图便是我司（Storyblocks）网络架构的很好展现。如果你还没成为经验老道的 web 工程师，可能觉得上图巨复杂。在详解各个模块前，我们先简单过一下流程。

> A user searches on Google for “Strong Beautiful Fog And Sunbeams In The Forest”. The [first result](https://www.graphicstock.com/stock-image/strong-beautiful-fog-and-sunbeams-in-the-forest-246703) happens to be from Storyblocks, our leading stock photo and vectors site. The user clicks the result which redirects their browser to the image details page. Underneath the hood the user’s browser sends a request to a DNS server to lookup how to contact Storyblocks, and then sends the request.用户在 Google 搜索关键字 “大雾 阳光 森林” 首条结果便是来自我们网站，用户点击搜索结果进入图片详情页。在用户操作的背后，客户端浏览器向 DNS 服务器查询图片所在服务器，并发送访问请求。

> The request hits our load balancer, which randomly chooses one of the 10 or so web servers we have running the site at the time to process the request. The web server looks up some information about the image from our caching service and fetches the remaining data about it from the database. We notice that the color profile for the image has not been computed yet, so we send a “color profile” job to our job queue, which our job servers will process asynchronously, updating the database appropriately with the results.用户请求通过负载均衡（随机选择多个服务器中的一个）访问站点处理请求。服务器从缓存服务中查找图片信息，并从数据库中调取其它信息。我们注意到此时，图片尚未进行色彩渲染计算，便发送“色彩渲染”任务到任务队列。此时该服务所在服务器异步处理任务，适时将结果更新到数据库。

> Next, we attempt to find similar photos by sending a request to our full text search service using the title of the photo as input. The user happens to be a logged into Storyblocks as a member so we look up his account information from our account service. Finally, we fire off a page view event to our data firehose to be recorded on our cloud storage system and eventually loaded into our data warehouse, which analysts use to help answer questions about the business.接下来，我们尝试匹配相似图片，以图片标题作为输入，进行全文搜索服务。用户登入系统，系统通过账户服务查找账户信息。系统火速查找到页面视图，并录入数据仓库，供产品运营人员做之后的商业分析。

> The server now renders the view as HTML and sends it back to the user’s browser, passing first through the load balancer. The page contains Javascript and CSS assets that we load into our cloud storage system, which is connected to our CDN, so the user’s browser contacts the CDN to retrieve the content. Lastly, the browser visibly renders the page for the user to see.服务器将渲染的 HTML 页面先经过负载均衡，再返回到用户浏览器。页面包含 Javascript 脚本和 CSS 素材，存与我们的云端存储系统，并连接到我们的 CDN，用户浏览器直接通过 CDN 检索内容。最后，浏览器显式地渲染页面，供用户浏览。

Next I’ll walk you through each component, providing a “101” introduction to each that should give you a good mental model for thinking through web architecture going forward. I’ll follow up with another series of articles providing specific implementation recommendations based on what I’ve learned in my time at Storyblocks. 下面，我们就每一个组件详细讨论，做最最基础的介绍，帮你建构认知模型，思考整个前面提到的整个网络服务架构。之后我还会发布其它文章，基于在我司学习到的内容，为大家更有针对性地从实践角度做推荐。

### 1. DNS

DNS stands for “Domain Name Server” and it’s a backbone technology that makes the world wide web possible. At the most basic level DNS provides a key/value lookup from a domain name (e.g., google.com) to an IP address (e.g., 85.129.83.120), which is required in order for your computer to route a request to the appropriate server. Analogizing to phone numbers, the difference between a domain name and IP address is the difference between “call John Doe” and “call 201-867–5309.” Just like you needed a phone book to look up John’s number in the old days, you need DNS to look up the IP address for a domain. So you can think of DNS as the phone book for the internet. DNS（Domain Name Server）是域名服务器的简称，它是互联网依存的基础设施。简单来说，DNS 提供域名与IP地址的键值对查找，例如（google.com 域名对应 85.129.83.120 IP 地址），这很有必要，它让你的电脑通过请求寻路到特定服务器。就好比打电话，域名与 IP 地址的关系类似于，联系人和电话号码的关系。以前你需要电话号码簿记录他人的电话号码，现在你需要 DNS 服务器寻找域名对应的 IP 地址。所以你可以把 DNS 想象成互联网世界的电话簿。

There’s a lot more detail we could go into here but we’ll skip over it because it’s not critical for our 101-level intro.这里我们还有很多细节可以深入，暂时先跳过，因为这里还不是重点。

### 2. Load Balancer 负载均衡

Before diving into details on load balancing, we need to take a step back to discuss horizontal vs. vertical application scaling. What are they and what’s the difference? Very simply put in [this StackOverflow post](https://stackoverflow.com/questions/11707879/difference-between-scaling-horizontally-and-vertically-for-databases), horizontal scaling means that you scale by adding more machines into your pool of resources whereas “vertical” scaling means that you scale by adding more power (e.g., CPU, RAM) to an existing machine.在详解负载均衡之前，我们先退一步讨论一下应用的纵向扩展和横向扩展。两者有什么区别？简单来说，参考 [StackOverflow 的这篇帖子](https://stackoverflow.com/questions/11707879/difference-between-scaling-horizontally-and-vertically-for-databases)，横向规模扩展意味着通过在资源池中加机器，纵向扩展意味着在已有机器上增强算力（如 CPU，RAM）。

In web development, you (almost) always want to scale horizontally because, to keep it simple, stuff breaks. Servers crash randomly. Networks degrade. Entire data centers occasionally go offline. Having more than one server allows you to plan for outages so that your application continues running. In other words, your app is “fault tolerant.” Secondly, horizontal scaling allows you to minimally couple different parts of your application backend (web server, database, service X, etc.) by having each of them run on different servers. Lastly, you may reach a scale where it’s not possible to vertically scale any more. There is no computer in the world big enough to do all your app’s computations. Think Google’s search platform as a quintessential example though this applies to companies at much smaller scales. Storyblocks, for example, runs 150 to 400 AWS EC2 instances at any given point in time. It would be challenging to provide that entire compute power via vertical scaling.
在 web 开发绝大多数情况下，会选择横向扩展。理由很简单，服务器会宕机，网络会断线，数据中心会掉电。多台服务器可以保证你的应用在能够一边停机维护，一边持续工作。换句话说，应用能够“容错”。另外，横向扩展能最小限度地耦合不同后台服务（web 服务器，数据库，等等），使不同服务在不同机器上运行。还有一点，纵向扩展是有上限的，到达一定限度就无法再扩展。世界上也不存在一台超算计算机承载应用的所有计算，典型例子想象一下 Google 的搜索平台，哪怕其它公司达不到这么大的规模。例如我司，Storyblocks，任何时候都跑在 150-400 个 AWS 实例上。通过纵向扩展提供算力是相当有挑战的。

Ok, back to load balancers. They’re the magic sauce that makes scaling horizontally possible. They route incoming requests to one of many application servers that are typically clones / mirror images of each other and send the response from the app server back to the client. Any one of them should process the request the same way so it’s just a matter of distributing the requests across the set of servers so none of them are overloaded.
回到负载均衡，可以说它是横向扩展的黑魔法。它将传入请求转路到多个服务器中的其中一个，再将响应回传给客户端。多个服务器彼此作为镜像，任意机器都会以同样的方式处理请求。向服务集群分发消息，便不会出现单个服务器过载的情况。
That’s it. Conceptually load balancers are fairly straight forward. Under the hood there are certainly complications but no need to dive in for our 101 version.
理论上负载均衡就这些要点，很简单直接。当然了，简单的理论背后有更多细节，这篇入门文章里我们不再赘述。

### 3. Web Application Servers

At a high level web application servers are relatively simple to describe. They execute the core business logic that handles a user’s request and sends back HTML to the user’s browser. To do their job, they typically communicate with a variety of backend infrastructure such as databases, caching layers, job queues, search services, other microservices, data/logging queues, and more. As mentioned above, you typically have at least two and often times many more, plugged into a load balancer in order to process user requests.

You should know that app server implementations require choosing a specific language (Node.js, Ruby, PHP, Scala, Java, C# .NET, etc.) and a web MVC framework for that language (Express for Node.js, Ruby on Rails, Play for Scala, Laravel for PHP, etc.). However, diving into the details of these languages and frameworks is beyond the scope of this article.

### 4. Database Servers

Every modern web application leverages one or more databases to store information. Databases provide ways of defining your data structures, inserting new data, finding existing data, updating or deleting existing data, performing computations across the data, and more. In most cases the web app servers talk directly to one, as will the job servers. Additionally, each backend service may have it’s own database that’s isolated from the rest of the application.

While I’m avoiding a deep dive on particular technologies for each architecture component, I’d be doing you a disservice not to mention the next level of detail for databases: SQL and NoSQL.

SQL stands for “Structured Query Language” and was invented in the 1970s to provide a standard way of querying relational data sets that was accessible to a wide audience. SQL databases store data in tables that are linked together via common IDs, typically integers. Let’s walk through a simple example of storing historical address information for users. You might have two tables, users and user_addresses, linked together by the user’s id. See the image below for a simplistic version. The tables are linked because the user_id column in user_addresses is a “foreign key” to the id column in the users table.

![](https://cdn-images-1.medium.com/max/800/1*Ln39QPggpJVMAScUBsrcCQ.png)

If you don’t know much about SQL, I highly recommend walking through a tutorial like you can find on Khan Academy [here](https://www.khanacademy.org/computing/computer-programming/sql). It’s ubiquitous in web development so you’ll at least want to know the basics in order to properly architect an application.

NoSQL, which stands for “Non-SQL”, is a newer set of database technologies that has emerged to handle the massive amounts of data that can be produced by large scale web applications (most variants of SQL don’t scale horizontally very well and can only scale vertically to a certain point). If you don’t know anything about NoSQL, I recommend starting with some high level introductions like these:

*   [https://www.w3resource.com/mongodb/nosql.php](https://www.w3resource.com/mongodb/nosql.php)
*   [http://www.kdnuggets.com/2016/07/seven-steps-understanding-nosql-databases.html](http://www.kdnuggets.com/2016/07/seven-steps-understanding-nosql-databases.html)
*   [https://resources.mongodb.com/getting-started-with-mongodb/back-to-basics-1-introduction-to-nosql](https://resources.mongodb.com/getting-started-with-mongodb/back-to-basics-1-introduction-to-nosql)

I would also keep in mind that, by and large, [the industry is aligning on SQL as an interface even for NoSQL databases](https://blog.timescale.com/why-sql-beating-nosql-what-this-means-for-future-of-data-time-series-database-348b777b847a) so you really should learn SQL if you don’t know it. There’s almost no way to avoid it these days.

### 5. Caching Service

A caching service provides a simple key/value data store that makes it possible to save and lookup information in close to O(1) time. Applications typically leverage caching services to save the results of expensive computations so that it’s possible to retrieve the results from the cache instead of recomputing them the next time they’re needed. An application might cache results from a database query, calls to external services, HTML for a given URL, and many more. Here are some examples from real world applications:

*   Google caches search results for common search queries like “dog” or “Taylor Swift” rather than re-computing them each time
*   Facebook caches much of the data you see when you log in, such as post data, friends, etc. Read a detailed article on Facebook’s caching tech [here](https://medium.com/@shagun/scaling-memcache-at-facebook-1ba77d71c082).
*   Storyblocks caches the HTML output from server-side React rendering, search results, typeahead results, and more.

The two most widespread caching server technologies are Redis and Memcache. I’ll go into more detail here in another post.

### 6. Job Queue & Servers

Most web applications need to do some work asynchronously behind the scenes that’s not directly associated with responding to a user’s request. For instance, Google needs to crawl and index the entire internet in order to return search results. It does not do this every time you search. Instead, it crawls the web asynchronously, updating the search indexes along the way.

While there are different architectures that enable asynchronous work to be done, the most ubiquitous is what I’ll call the “job queue” architecture. It consists of two components: a queue of “jobs” that need to be run and one or more job servers (often called “workers”) that run the jobs in the queue.

Job queues store a list of jobs that need to be run asynchronously. The simplest are first-in-first-out (FIFO) queues though most applications end up needing some sort of priority queuing system. Whenever the app needs a job to be run, either on some sort of regular schedule or as determined by user actions, it simply adds the appropriate job to the queue.

Storyblocks, for instance, leverages a job queue to power a lot of the behind-the-scenes work required to support our marketplaces. We run jobs to encode videos and photos, process CSVs for metadata tagging, aggregate user statistics, send password reset emails, and more. We started with a simple FIFO queue though we upgraded to a priority queue to ensure that time-sensitive operations like sending password reset emails were completed ASAP.

Job servers process jobs. They poll the job queue to determine if there’s work to do and if there is, they pop a job off the queue and execute it. The underlying languages and frameworks choices are as numerous as for web servers so I won’t dive into detail in this article.

### 7. Full-text Search Service

Many if not most web apps support some sort of search feature where a user provides a text input (often called a “query”) and the app returns the most “relevant” results. The technology powering this functionality is typically referred to as “[full-text search](https://en.wikipedia.org/wiki/Full-text_search)”, which leverages an [inverted index](https://en.wikipedia.org/wiki/Inverted_index) to quickly look up documents that contain the query keywords.

![](https://cdn-images-1.medium.com/max/800/1*gun_BpdDH9KrNna1NnaocA.png)

Example showing how three document titles are converted into an inverted index to facilitate fast lookup from a specific keyword to the documents with that keyword in the title. Note, common words such as “in”, “the”, “with”, etc. (called stop words), are typically not included in an inverted index.

While it’s possible to do full-text search directly from some databases (e.g., [MySQL supports full-text search](https://dev.mysql.com/doc/refman/5.7/en/fulltext-search.html)), it’s typical to run a separate “search service” that computes and stores the inverted index and provides a query interface. The most popular full-text search platform today is [Elasticsearch](https://www.elastic.co/products/elasticsearch) though there are other options such as [Sphinx](http://sphinxsearch.com/) or [Apache Solr](http://lucene.apache.org/solr/features.html).

### 8. Services

Once an app reaches a certain scale, there will likely be certain “services” that are carved out to run as separate applications. They’re not exposed to the external world but the app and other services interact with them. Storyblocks, for example, has several operational and planned services:

*   **Account service** stores user data across all our sites, which allows us to easily offer cross-sell opportunities and create a more unified user experience
*   **Content service** stores metadata for all of our video, audio, and image content. It also provides interfaces for downloading the content and viewing download history.
*   **Payment service** provides an interface for billing customer credit cards.
*   **HTML → PDF service** provides a simple interface that accepts HTML and returns a corresponding PDF document.

### 9. Data

Today, companies live and die based on how well they harness data. Almost every app these days, once it reaches a certain scale, leverages a data pipeline to ensure that data can be collected, stored, and analyzed. A typical pipeline has three main stages:

1.  The app sends data, typically events about user interactions, to the data “firehose” which provides a streaming interface to ingest and process the data. Often times the raw data is transformed or augmented and passed to another firehose. AWS Kinesis and Kafka are the two most common technologies for this purpose.
2.  The raw data as well as the final transformed/augmented data are saved to cloud storage. AWS Kinesis provides a setting called “firehose” that makes saving the raw data to it’s cloud storage (S3) extremely easy to configure.
3.  The transformed/augmented data is often loaded into a data warehouse for analysis. We use AWS Redshift, as does a large and growing portion of the startup world, though larger companies will often use Oracle or other proprietary warehouse technologies. If the data sets are large enough, a Hadoop-like NoSQL MapReduce technology may be required for analysis.

Another step that’s not pictured in the architecture diagram: loading data from the app and services’ operational databases into the data warehouse. For example at Storyblocks we load our VideoBlocks, AudioBlocks, Storyblocks, account service, and contributor portal databases into Redshift every night. This provides our analysts a holistic dataset by co-locating the core business data alongside our user interaction event data.

### 10. Cloud storage

“Cloud storage is a simple and scalable way to store, access, and share data over the Internet” [according to AWS](https://aws.amazon.com/what-is-cloud-storage/). You can use it to store and access more or less anything you’d store on a local file system with the benefits of being able to interact with it via a RESTful API over HTTP. Amazon’s S3 offering is by far the most popular cloud storage available today and the one we rely on extensively here at Storyblocks to store our video, photo, and audio assets, our CSS and Javascript, our user event data and much more.

### 11. CDN

CDN stands for “Content Delivery Network” and the technology provides a way of serving assets such as static HTML, CSS, Javascript, and images over the web much faster than serving them from a single origin server. It works by distributing the content across many “edge” servers around the world so that users end up downloading assets from the “edge” servers instead of the origin server. For instance in the image below, a user in Spain requests a web page from a site with origin servers in NYC, but the static assets for the page are loaded from a CDN “edge” server in England, preventing many slow cross-Atlantic HTTP requests.

![](https://cdn-images-1.medium.com/max/800/1*ZkC_5865Hx-Cgph3iPJghw.png)

[Source](https://www.creative-artworks.eu/why-use-a-content-delivery-network-cdn/)

[Check out this article](https://www.creative-artworks.eu/why-use-a-content-delivery-network-cdn/) for a more thorough introduction. In general a web app should always use a CDN to serve CSS, Javascript, images, videos and any other assets. Some apps might also be able to leverage a CDN to serve static HTML pages.

### Parting thoughts

And that’s a wrap on Web Architecture 101. I hope you found this useful. I’ll hopefully post a series of 201 articles that provide deep dives into some of these components over the course of the next year or two.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
