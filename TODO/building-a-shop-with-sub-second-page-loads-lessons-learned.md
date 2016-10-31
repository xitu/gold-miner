> * 原文地址：[Building a Shop with Sub-Second Page Loads: Lessons Learned](https://medium.baqend.com/building-a-shop-with-sub-second-page-loads-lessons-learned-4bb1be3ed07#.svcz7qtdn)
* 原文作者：[Erik Witt](https://medium.baqend.com/@erik.witt)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Building a Shop with Sub-Second Page Loads: Lessons Learned








> _Here is the story of how_ [_we_](http://www.baqend.com/) _leveraged research on web-caching and NoSQL systems to prepare a_ [_webshop_](http://www.thinks.com/) _for hundreds of thousands of visitors due to TV Show publicity and everything that we learned along the way._













![](https://cdn-images-2.medium.com/max/1200/1*8n8yIaSM7m7VflC3dOGr8g.png)









TV-Shows like “Shark Tank” (US), “Dragons’ Den” (UK) or “Die Höhle der Löwen (DHDL)” (GER) offer young startups a one-time opportunity to pitch their products to business magnates in front of a huge audience. The main profit, however, often does not lie in the strategic investments offered by jury members — [only few deals are finalized](http://www.bloomberg.com/news/articles/2014-07-15/shark-tank-do-two-thirds-of-deals-fall-apart) — but rather in the attention raised during the show: a few on-air minutes can already draw hundreds of thousands of new visitors to a website and may boost the base level of activity for weeks, months or even permanently. That is, if the website can take the initial load spike and does not turn down user requests…

### Availability is not enough — latency is key!

Webshops find themselves in a particularly tight spot, because they are not mere pastime projects (like, say, a blog), but are often backed by substantial investments from the founders themselves and _have to turn a profit_. The obvious worst case for a business is an overload situation during which the server has to drop user requests or even completely breaks down. And this is not as uncommon as you might think: About half of all webshops pitched in the current season of the DHDL became unreachable while in the spotlight. And staying online is only half the rent, since **user satisfaction is hard-wired to the conversion rate** and thus directly translates to the generated revenue.



![](https://cdn-images-2.medium.com/max/800/1*bw_wf7Q8V_nykLwdnTA8wQ.png)

[Source](http://infographicjournal.com/how-page-load-time-can-impact-conversions/)



There is an abundance of [studies](https://wpostats.com/tags/conversions/) on the effect of page loading times on customer satisfaction and conversion rate to support this statement. For example, the Aberdeen Group discovered that a single second of additional latency results in 11% fewer page views and 7% loss in conversions. But you can also ask [Google](https://wpostats.com/2015/10/29/google-500ms.html) or [Amazon](https://wpostats.com/2015/10/29/amazon-1-percent.html) and they’ll tell you the same.

### How to speed up websites

Building the webshop for the startup [_Thinks_](https://www.thinks.com/) — participating in DHDL, aired on September 6. — we faced the challenge to build a shop that can handle hundreds of thousands of visitors while constantly loading below one second. Here is what we learned in the process as well as from several years of database and web performance research.

There are three major drivers of page load time in state of the art web applications, all illustrated below.









![](https://cdn-images-2.medium.com/max/800/1*j_z9Rbmp0GLNqr4LwWVCmQ.png)





1.  **Backend processing**: The webserver needs time to load data from the database and to assemble the website.
2.  **Network latency**: Every request needs time to travel from the client to the server and back (request latency). This becomes even more essential when considering that an average website makes more than [100 request](http://httparchive.org/interesting.php)to load completely.
3.  **Fronted processing**: The frontend device needs time to render the page.

In order to speed up our webshop, lets address the three bottlenecks one by one.

#### Frontend Performance

The most important factor for frontend performance is the critical rendering path ([CRP](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/?hl=en)). It describes the 5 necessary steps in a browser to display the page to users, as illustrated below.













![](https://cdn-images-2.medium.com/max/1200/1*1DEuTsfd9RckmywKDTwxGA.tiff)



Steps of the critical rendering path







*   **DOM**: When the browser parses the HTML, it incrementally generates a tree model of the HTML tags called _document object model_ (DOM), which describes the content of the page.
*   **CSSOM**: Once the browser receives all the CSS, it generates a tree model of the contained tags and classes called _CSS object model_ with the styling information attached to the tree nodes. The tree describes how the page content is styled.
*   **Render Tree:** By combining the DOM and CSSOM, the browser constructs a render tree, which contains the page content along with the styling information to apply.
*   **Layout:** The layout step computes the actual position and size of the page content on the screen.
*   **Paint**: The last step uses the layout information to paint the actual pixels to the screen.

The individual steps are quite straight-forward; it’s the dependencies of steps that make things difficult and limit performance. The construction of the DOM and CSSOM usually have the greatest performance impact.

This diagram shows the steps of the critical rendering path including the wait-for dependencies as arrows.













![](https://cdn-images-2.medium.com/max/1200/1*t40GwOqsIbif3WUxKGMRVQ.tiff)



Important dependencies in the critical rendering path







Before loading the CSS and constructing the full CSSOM nothing can be displayed to the client. Therefore CSS is called **render blocking.**

JavaScript (JS) is even worse, because it can access and change both the DOM and CSSOM. This means that once a script tag in the HTML is discovered, the DOM construction is paused and the script is requested from the server. Once the script is loaded it cannot be executed before all CSS is fetched and the CSSOM is constructed. After CSSOM construction JS is executed, which as in the example below may access and alter the DOM as well as the CSSOM. Only then the construction of the DOM can proceed and the page can be displayed to the client. Therefore JavaScript is called parser blocking.

Example of JavaScript accessing CSSOM and changing DOM:

    <script>
       ...
       var old = elem.style.width;
       elem.style.width = "50px";
       document.write("alter DOM");
       ...
    </script>

And JS can even be more harmful than this. There are for example [jQuery plugins](https://github.com/jjenzz/jquery.ellipsis) which access computed layout information of HTML elements and then start altering the CSSOM again and again until it agrees with the desired layout. As a consequence the browser has to repeat JS execution, render tree construction and layout over an over again before the user will see anything other than a white screen.

To optimize the CRP there are three [basic concepts](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/optimizing-critical-rendering-path):

1.  **Reduce critical ressources:** Critical ressources are those needed for the initial rendering of the page (HTML, CSS, JS files). These can be highly reduced by **inlining** CSS and JS needed for rendering the portion of the website visible without scrolling (called **above the fold).** Further JS and CSS should be loaded **asynchronously**. Files that cannot be loaded asynchronously can be **concatenated** into one file.
2.  **Minimize bytes:** The number of bytes loaded in the CRP can be highly reduced by **minifying** and **compressing** CSS, JS and images.
3.  **Shorten CRP length:** The CRP length is the maximum number of consecutive **roundtrips** to the server needed to fetch all critical resources. It is shortened both by reducing critical resources and minimizing their size (large files need multiple roundtrips to fetch). What further helps is to include **CSS at the top** of the HTML and **JS at the bottom**, because JS execution would block on fetching CSS and building the CSSOM and DOM anyway.

Furthermore, **browser caching** is highly effective and should always be used. It fits in all three optimization categories because cached resources do not have to be loaded from the server in the first place.

The whole topic of CRP optimization is quite complex and especially inlining, concatenating and asynchronous loading can ruin code redability. Thankfully there are tons of great tools that will do these optimizations gladly for you, which can be integrated into your build and deployment chain. You should definitively take a look at the following tools for…

*   **Profiling:** [GTmetrix](https://gtmetrix.com/) to measure page speed, [webpagetest](https://www.webpagetest.org/) to profile your resources and Google’s [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) to generate tips specific to your website on how to optimize your CRP.
*   **Inlining and optimization**: [Critical](https://github.com/addyosmani/critical) is great to automatically inline your CSS above the fold and load the rest asynchronously, [processhtml](https://github.com/Wildhoney/gulp-processhtml)concatenates your resources and [PostCSS](https://github.com/postcss/postcss) further optimizes CSS.
*   **Minification and compression:** We use [tiny png](https://tinypng.com/) for image compression, [UglifyJs](https://github.com/mishoo/UglifyJS) and [cssmin](https://www.npmjs.com/package/cssmin) for minification or [Google Closure](https://developers.google.com/closure/) for JS optimization.

With these tool and a little bit of work, you can build websites with great frontend performance. Here are the page speed test for a first visit for the _Thinks_ shop:









![](https://cdn-images-2.medium.com/max/800/1*zRwgmwVleajpoA-Xq4CjhQ.png)



Google page speed score for thinks.com



Interestingly, the only complaint in PageSpeed Insights is, that the Google Analytics script’s cache lifetime is too short. So Google is basicly complaining about itself.









![](https://cdn-images-2.medium.com/max/800/1*ls8OEm_co28ib7ehy189rA.png)



First page load from Canada (GTmetrix), server hosted in Frankfurt



#### Network Performance

Network latency is the most important factor when it comes to page load time and it is also the hardest to optimize. But before we go into the optimizations, lets take a look at a breakdown of an initial browser request:













![](https://cdn-images-2.medium.com/max/1200/1*Y3uwr-Q8L-OSH3ubXl-HiA.tiff)









When we type [https://www.thinks.com/](https://www.thinks.com/) into the browser and hit enter, the browser starts with a **DNS lookup** to identify the IP address associated with the domain. This lookup has to be done for every individual domain.

With the received IP address, the browser initiates a **TCP connection** with the server. The TCP handshake needs 2 roundtrips (1 with [TCP Fast Open](https://en.wikipedia.org/wiki/TCP_Fast_Open)). With a secure **SSL connection** the TLS handshake needs an additional 2 roundtrips (1 with [TLS False Start](https://blogs.windows.com/msedgedev/2016/06/15/building-a-faster-and-more-secure-web-with-tcp-fast-open-tls-false-start-and-tls-1-3/#BqAGYfpLwoYCtE6i.97) or [Session Resumption](https://timtaubert.de/blog/2014/11/the-sad-state-of-server-side-tls-session-resumption-implementations/)).

After the initial connection, the browser sends the actual request and waits for data to come in. This **time to first byte** depends heavily on the distance between client and server and includes the time needed at the server to render the page (including session lookups, database queries, template rendering and so on).

The last step is **downloading the resource** (HTML in this case) in potentionally many roundtrips. Especially new connections often need a lot of roundtrips because the initial congestion window is small. That means TCP does not use the full bandwidth right from the start but increases it over time (see [TCP congestion control)](https://en.wikipedia.org/wiki/TCP_congestion_control). The speed is subject to the slow-start algorithm that doubles the number of segments in the congestion window per round-trip until packet loss occurs. On mobile and Wifi networks lost packets hence have a large performance impact.

Another thing to keep in mind: with HTTP/1.1 you only get **6 parallel connections** (2 if browsers would still follow the orginal standard). Thus, you can only request up to 6 resources in parallel.

To get an intuition of how important network performance is for page speed the [httparchive](http://httparchive.org/interesting.php) has a lot of statistics. For example the average website loads about 2.5 MB of data in over 100 requests.









![](https://cdn-images-2.medium.com/max/800/1*ycpDPIWtye5aFu7Kdtb5Ew.png)



[source](http://httparchive.org/interesting.php#reqTotal)



So websites make a lot of small requests to load many resources, but network bandwidth is increasing all the time. The evolution of physical networks will save us, right? Well, not really…









![](https://cdn-images-2.medium.com/max/800/1*R1NZ69zvARAdY6fkf2ljng.tiff)



From [High Performance Browser Networking](https://hpbn.co/) by Ilya Grigorik



It turns out that increasing **bandwidth** beyond 5 Mbps does not really have an effect on page load time at all. But decreasing **latency** of individual requests drives down page load time. That means doubling the bandwidth leaves you with the same load time, while cutting in half latency will give you half your load time.

So if latency is the deciding factor for network performance what can we do about it?

*   **Persistent connections** are a must-have. There is nothing worse than when your server closes the connection after every request and the browser has to perform handshakes and TCP slow start again and again.
*   **Avoid redirects** wherever possible as they slow down your initial page load a lot. Always link the full url (www.thinks.com as apposed to thinks.com) for example.
*   Use **HTTP/2** if possible. It comes with **server push** to transfer multiple resource for a single request, **header compression** to drive down request and response sizes and also request **pipelining** and **multiplexing** to send arbitrary parallel request over a single connection. With server push, your server can for example ship your html and push CSS and JS needed by the website right after that without waiting for the actual request.
*   Set explicit **caching headers** for your static resources (CSS, JS, static images like logos). This way you can tell the browser how long to cache these resources and when to revalidate. Caching can potentially save you a lot of roundtrips and bytes to download. If no explicit headers are set, the browser will do [heuristic caching](http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html), which is better than nothing but far from optimal.
*   Use a **Content Delivery Network** (CDN) to cache images, CSS, JS and HTML. These distributed cache networks can significantly reduce the distance to your users and thus deliver resources much faster. They also speed up your initial connection since you do the TCP and TLS handshakes with a nearby CDN node, which in turn has warm and persistent backend connections.
*   Consider building a **Single-Page App** with a small initial page that loads additional parts asynchronously. This way you can use cachable HTML templates, load dynamic data in small requests and only update sections of the page during navigation.

In summary, there are a few do’s and don’ts when it comes to network performance but the limiting factor is always the number of roundtrips combined with the physical network latency. The only effective way to conquer this limitation is to bring data closer to clients. State of the art web caching does exactly that but is only applicable for static resources.

For _Thinks,_ we followed the above guidelines, used the [Fastly](https://www.fastly.com/) CDN and aggressive browser caching even for dynamic data using a novel [Bloom Filter algorithm](https://medium.baqend.com/bringing-web-performance-to-the-next-level-an-overview-of-baqend-be3521bc2faf#.ajhyivndc) to keep cached data consistent.









![](https://cdn-images-2.medium.com/max/800/1*djg5dkELtzm0wQd_sKmoTg.tiff)



Repeated load of [www.thinks.com](http://www.thinks.com/) showing the browser cache coverage



The only requests for a repeated page load that are not served from browser cache (see figure above) are two async calls to Google’s analytics API and the request for the initial HTML that is fetched from the CDN. As a consequence, the page loads instantly for repeated page loads.

#### Backend Performance

For backend performance, we need to consider both latency and throughput. To achieve low latency, we need to minimize the processing time of the server. To sustain high throughput and cope with load spikes, we need to adopt a **horizontally scalable** architecture. Without going into too much detail — the space of design decisions impacting performance is huge — these are the most important components and properties to look for:













![](https://cdn-images-2.medium.com/max/1200/1*lF1D54UVWbHPosMZBoCJSg.tiff)



Components of a scalable backend stack: load balancers, stateless application servers, distributed databases







First of all, you need **load balancing** (e.g. Amazon ELB or DNS load balancing) to assign incoming requests to one of your application servers. It should also implement **automatic scaling** to spawn additional application servers when needed as well as **failover** to replace broken servers and re-route requests to healthy ones.

**Application servers** should **minimize shared state** to keep coordination to a minimum and use **stateless session handling** to enable free load balancing. Furthermore, the server should be **efficient** in code as well as IO to minimize server processing time.

**Databases** also need to withstand load spikes and impose as little processing time as possible. At the same time, they need to be expressive enough to model and query data as needed. There are tons of scalable databases (especially NoSQL) each with its own set of trade-offs. For more details, see our survey and decision guidance on this topic:

[**NoSQL Databases: a Survey and Decision Guidance**  
_Together with our colleagues at the University of Hamburg, we — that is Felix Gessert, Wolfram Wingerath, Steffen…_medium.baqend.com](https://medium.baqend.com/nosql-databases-a-survey-and-decision-guidance-ea7823a822d "https://medium.baqend.com/nosql-databases-a-survey-and-decision-guidance-ea7823a822d")

The _Thinks_ webshop is built on [Baqend](http://www.baqend.com/), which using the following backend stack:









![](https://cdn-images-2.medium.com/max/800/1*C7yp3ODTiIyCv6ZxtZVQCg.tiff)



Baqend’s backend stack: MongoDB as the main database, stateless application servers, HTTP caching hierarchy, REST and the JS SDK for the web frontend



The main database used for _Thinks_ is **MongoDB.** To maintain our expiring Bloom filter (used for browser caching), we use **Redis** for its high write thoughput. The stateless application servers ([**Orestes Servers**](http://orestes.info/assets/files/Paper.pdf)) provide interfaces to backend features (file hosting, data storage, real-time queries, push notifications, access control, etc.) and handle cache coherence for dynamic data. They get their requests from the **CDN**, which also acts as a load balancer. The website frontend uses a **JS SDK** based on a **REST API** to access the backend which automatically leverages the full **HTTP caching hierarchy** to accelerate requests and keep cached data up-to-date.

#### Load Testing

To test the _Thinks_ webshop under high load, we conducted a load test with 2 application servers on t2.medium AWS instances in Frankfurt. MongoDB ran on two t2.large instances. The load test was built using [JMeter](http://jmeter.apache.org/) and executed on 20 machines on [IBM soft layer](http://www.softlayer.com/) to simulate **200.000 users** accessing and surfing through the website within **15 minutes**. 20% of the users (40.000) were configured to execute an additional payment process.













![](https://cdn-images-2.medium.com/max/1200/1*PTn0h56pvC5HYEAaEPnI1A.png)



The load test setup for the webshop







We discovered a few bottlenecks in our payment implementation, for example we had to switch from an optimistic update of the stock (implemented with [findAndModify](https://docs.mongodb.com/manual/reference/method/db.collection.findAndModify/)) to MongoDB’s partial update operations ([_inc_](https://docs.mongodb.com/manual/reference/operator/update/inc/)_). But after that the servers handled the load just fine achieving an average request latency of 5 ms._





![](https://cdn-images-2.medium.com/max/800/1*SrfTDYzeTKh5-T26I2Nakw.tiff)



JMeter output during the load test: 6.8 million requests in 12 minutes, 5 ms average latency



All the load tests combined generated about **10 million request** and tranfered **460 GB of data** with a CDN **cache hit rate** of **99.8%**.













![](https://cdn-images-2.medium.com/max/1200/1*buvg1l0A2FrzqR8dbgQ5cQ.png)



The dashboard overview after the load test







### Summary

In summary, good user experience rests on three pillars: frontend, network and backend performance.













![](https://cdn-images-2.medium.com/max/1200/1*KaPvIFl16OLU76KxJMR1WQ.tiff)









**Frontend performance** is the easiest to achieve in our opinion because there is already great tooling and a bunch of best practices that are easy to follow. But still a lot of websites do not follow these best practices and do not optimize their frontend at all.

**Network performance** is the most important factor for page load times and also the hardest to optimize. Caching and CDNs are the most effective ways of optimization but come with a considerable effort even for static content.

**Backend performance** is dependent on single-server performance and your ability to distribute work across machines. Horizontal scalability is particularly difficult to implement and has to be considered right from the start. A lot of projects treat scalability and performance as an afterthought and come into big trouble when their business grows.

### Literature and Tool Recommendations









![](https://cdn-images-2.medium.com/max/800/1*Fu5eAxBQORO1em86kuJBgA.tiff)





There are great books on the topic of web performance and scalable systems’ design. [High Performance Browser Networking](https://hpbn.co/) by Ilya Grigorik contains almost everything you need to know about networking and browser performance, plus the constantly updated version is free to read online! [Desining Data-Intensive Applications](http://dataintensive.net/) by Martin Kleppmann is still in early release state but already among the best book in its field. It covers most fundamentals behind scalable backend systems with great detail. [Designing for Performance](http://designingforperformance.com/) by Lara Callender Hogan is all about building fast websites with great user experience covering a lot of best practices.









![](https://cdn-images-2.medium.com/max/800/1*rNqMUe5C9Z2KvCjqQJRNrA.tiff)





There are also great online guides, tutorials and tools to consider. From the beginner-friendly Udacity course [Website Performance Optimization](https://www.udacity.com/course/website-performance-optimization--ud884) over Google’s [developer performance guide](https://developers.google.com/web/fundamentals/performance/?hl=en) to profiling tools like [Google PageSpeed Insights](https://developers.google.com/web/fundamentals/performance/?hl=en), [GTmetrix](https://gtmetrix.com/) and [WebPageTest](https://www.webpagetest.org/).

### Newest Developments In Web Performance

**Accelerated Mobile Pages**

Google is doing a lot to increase awareness for web performance with projects such as [PageSpeed Insights](https://developers.google.com/speed/pagespe%E2%80%A6), [developer guides](https://developers.google.com/web/fundamentals/performance/) for web performance and including page speed as a leading factor of their [page rank](https://webmasters.googleblog.com/2010/04/using-site-speed-in-web-search-ranking.html).

Their newest concept to improve page speed and user experiance in Google search is called [accelerated mobile pages (**AMP**)](https://www.ampproject.org/). The idea is to have news articles, product pages and other search content load instantly right from the Google search. To this end, these pages have to be built as AMPs.









![](https://cdn-images-2.medium.com/max/800/1*dFufupcLXGvhJdeqhntcsA.png)



Example of an AMP page



AMP does two major things:

1.  Websites built as AMP use a stripped-down version of HTML and use a JS loader to render fast and load as much resources as possible asynchronously.
2.  Google caches the websites in the Google CDN and delivers them via HTTP/2.

The first means in essence, AMP restricts your HTML, JS and CSS in a way that pages built this way have an optimized critical rendering path and can easily be crawled by Google. AMP enforces [several restrictions](https://www.ampproject.org/docs/reference/spec), for example all CSS must be inlined, all JS must be asynchronous and everything on the page must have a static size (to prevent repaints). Although you can achieve the same results without these restrictions by sticking to the web performance best practices from above, AMP might be good trade-off and help for very simple websites.

The second means that Google crawls your website and then caches it in the Google CDN to deliver it very fast. The website content is updated once the crawler indexes your website again. The CDN also respects static TTLs set by the server but performs at least [micro-caching](https://developers.google.com/amp/cache/overview#google-amp-cache-updates): resources are considered fresh for at least one minute and updated in the background when a user request comes in. The effective consequence is that AMP is best applicable in use cases where the content is mostly static. This is the case for news websites or other publications that are only changed by human editors.

#### Progressive Web Apps

Another approach (also by Google) are [progressive web apps](https://developers.google.com/web/fundamentals/getting-started/codelabs/your-first-pwapp/) (**PWA**). The idea is to cache static parts of a website using [service workers](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers) in the browser. As a consequence, these parts load instantly for repeated views and are also available offline. Dynamic parts are still loaded from the server.

The _app shell_ (the single page application logic) can be revalidated in the background. If updates to the app shell are identified, the user is prompted with a message asking him to update the page. This is for example done in [Inbox by Gmail](https://www.google.de/inbox/).

However, the service worker code caching static resources and doing the revalidation comes with considerable effort for every website. Furthermore, only Chrome and Firefox support Service Workers sufficiently.

### Caching Dynamic Content

The problem that all the caching approaches suffer from is that they cannot deal with dynamic content. This is simply due to how HTTP caching works. There are two types of caches: **Invalidation-based** caches (like forward proxy caches and CDNs) and **expiration-based** caches (like ISP caches, corporate proxies and **browser caches**). Invalidation-based caches can be invalidated proactively from the server, expiration-based caches can only be revalidated from the client.

The tricky thing when using expiration-based caches is that you must specify a cache lifetime (TTL) when you first deliver the data from the server. After that you do not have any chance to kick the data out. It will be served by the browser cache up to the moment the TTL expires. For static assets it is not such a complex thing, since they usually only change when you deploy a new version of your web application. Therefore, you can use cool tools like [gulp-rev-all](https://github.com/smysnk/gulp-rev-all) and [grunt-filerev](https://github.com/yeoman/grunt-filerev) to hash the assets.

But what do you do with all the data which is loaded and changed by your application at runtime? Changing user profiles, updating a post or adding a new comment are seemingly impossible to combine with the browsers cache, since you cannot estimate when such updates will happen in the future. Therefore, caching is just disabled or very low TTLs are used.













![](https://cdn-images-2.medium.com/max/1200/0*K1ZJfaJ6zgz6eEk_.png)



Example of how cached dynamic data becomes outdated when updated by another client







#### Baqend’s Cache-Sketch Approach

At [Baqend](http://www.baqend.com/), we have researched and developed an approach to check the staleness of a URL in the client before actually fetching it. At the begin of each user session, we fetch a very small data structure called Bloom filter, which is a highly compressed representation of the set of all stale resources. By looking in the Bloom filter, the client can check whether a resource might be stale (contained in the Bloom filter) or is definitely fresh. For potentially stale resources, we bypass the browser cache and fetch the content from the CDN. In all other cases, we serve the content directly from the browsers cache. Using the browser cache saves network traffic, bandwidth and is _fast_.

In addition, we ensure that the CDN (and other invalidation-based caches like Varnish) always contain the most recent data by instantly purging resources as soon as they become stale.













![](https://cdn-images-2.medium.com/max/1200/0*lpjUnI1olugLyyto.png)



Example of how Baqend ensures the freshness of cached dynamic data







The [Bloom filter](http://de.slideshare.net/felixgessert/bloom-filters-for-web-caching-lightning-talk) is a probabilistic data structure with a tunable false positive rate, which means that the set may indicate containment for objects which were never added, but will never drop an item that actually was. In other words, we may occasionally revalidate fresh resources, but **we never deliver stale data**. Note that the false positive rate is very low and it is what enables us to make the footprint of the set very small. For an example we just need 11Kbyte to store 20,000 distinct updates.

There is lot of stream processing (query match detection), machine learning (optimal TTL estimation) and distributed coordination (scalable Bloom filter maintenance) happening at the server side. If you’re interested in the nitty-gritty details have a look at this [paper](http://www.baqend.com/paper/btw-cache.pdf) or [these slides](http://de.slideshare.net/felixgessert/talk-cache-sketches-using-bloom-filters-and-web-caching-against-slow-load-times) for a deep-dive.

#### Performance Gains

What it all boils down to is this.

> Which page speed improvement can be achieved with Baqend’s caching infrastructure?

In order to showcase the benefit of using Baqend, we built a very simple news application on each of the leading competitors in the backend-as-a-service (BaaS) space and measured the page load times from different locations all over the world. As shown below, Baqend consistently loads below 1 second and is 6.8 times faster than the competition on average. Even when all clients come from the same location the server is located, Baqend is 150% faster due to browser caching.













![](https://cdn-images-2.medium.com/max/1200/1*wT5diC6Pcd95wUSVroYviw.tiff)



Average load time comparison for a simple news application







We built this comparison as a [hands-on web app](http://s.codepen.io/baqend/debug/3010e4601789ea4d77673140d8e06245#) to compare the BaaS competition.









![](https://cdn-images-2.medium.com/max/800/1*X2Gc9KCtG_33mRe5Q9ayJw.tiff)



Screenshot of the [hands-on comparison](http://s.codepen.io/baqend/debug/3010e4601789ea4d77673140d8e06245)



But this is of course a test scenario and not a web application with real users. So lets come back to the _Thinks_ webshop to look at a real world example.

### Thinks Webshop — All The Facts

When DHDL (german version of “Shark Tank”) aired on september 6th with 2.7 million viewers, we were sitting in front of the TV and our Google analytics screens, excited for the the _Thinks_ founders to present their product.

Right from the start of their presentation, the number of concurrent users on the webshop rapidly increased to about 10.000, but the real bump happend at the commercial break when suddenly over 45.000 concurrent users came to visit the shop to buy a Towell+:









![](https://cdn-images-2.medium.com/max/800/1*sCsJOCw-7clmfIbyYRwUrA.gif)



Google analytics measurement starting right before the commercial break.



During the 30 minutes _Thinks_ was on the air, we got **3.4** million requests, **300.000** visitors, up to **50.000** concurrent visitors and up to 20.000 requests per second — all this achieving a **cache hit rate of 98.5%** at CDN level and an average **server CPU load of 3%**.

As a consequence, the **page load time** was **below 1 second** for the whole time enabling a great **conversion rate of 7.8%**.

If we take a look at the other shops presented in the same episode of DHDL, we see that four of them where **completely down** and the remaining shops only leveraged few performance optimizations.









![](https://cdn-images-2.medium.com/max/800/1*3VLcWgaWIiFlJdaqy27gCg.png)



Overview of availability and Google page speed score of the shops presented a DHDL on September 6th.



### Summary

We have seen the bottlenecks to overcome when designing fast and scalable websites: we have to master the **critical rendering path**, understand the network limitations, the importance of **caching** and design for **horizontal scalability** in the backend.

We have seen a lot of tools solving individual problems as well as accelerated mobile pages (**AMP**) and progressive web apps (**PWA**) taking a more comprehensive approach. Still, the problem of **caching dynamic data**remained.

**Baqend**‘s approach is to reduce web development to building mostly the frontend and using backend features of Baqend’s fully managed cloud service through a JS SDK, including data and file storage, (realtime-) queries, push notifications, user management and OAuth as well as access control. The platform automatically accelerates all request by using the full HTTP cache hierarchy and guarantees availability as well as scalability.









![](https://cdn-images-2.medium.com/max/600/1*lDR0ZIX0ACdKwYMzEqyAKg.png)





#### Our vision at Baqend is a web without load times and we want to give you the tools to achieve that.

Go ahead and try it for free at [www.baqend.com](http://www.baqend.com/).











* * *







Don’t want to miss our next post on web performance? Get it conveniently delivered to your inbox by joining our [newsletter](http://www.baqend.com/#newsletter).







