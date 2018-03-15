> * 原文地址：[How switching our domain structure unlocked international growth](https://medium.com/@Pinterest_Engineering/how-switching-our-domain-structure-unlocked-international-growth-e00c8184d5dd)
> * 原文作者：[Pinterest Engineering](https://medium.com/@Pinterest_Engineering?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-switching-our-domain-structure-unlocked-international-growth.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-switching-our-domain-structure-unlocked-international-growth.md)
> * 译者：
> * 校对者：

# How switching our domain structure unlocked international growth

Christian Miranda | Software Engineer, Growth

More than half of the 200 million monthly active users on Pinterest use our app outside the U.S. As we continue to make Pinterest even better for our global users, we moved our traffic to country code top-level domains (ccTLDs). An example of this is serving the website on [www.pinterest.de](http://www.pinterest.de) in Germany instead of [www.pinterest.com.](http://www.pinterest.com.) Here we’ll deep dive into the specifics of how this change can help improve growth and discuss some of the engineering challenges we came across throughout the process.

### It’s all in the name

Since Pinterest’s inception in 2010, every page of the website has been hosted on [www.pinterest.com.](http://www.pinterest.com.) A few years down the line, we introduced country subdomains (e.g. de.pinterest.com) in order to segment our content by country and provide a more localized and relevant experience for Pinners. This improved search engine optimization (SEO) and general growth, because more people found relevant content in their language as country subdomains ranked higher in global search results.

The next step was to implement ccTLDs. Through research we learned that some other sites who made the switch saw neutral or negative effects on growth, even though the industry view on ccTLDs is that they provide a stronger geo-targeting signal in many search engine algorithms, and users are more likely to click results with local domain endings (this may result in a higher click-through rate, which can positively affect search ranking). We wanted to test them to see how they’d work for Pinterest and our diverse catalog of content.

### More than just a redirect: The challenges of switching domains

On the surface, the project seemed fairly simple — all we had to do was provision the new ccTLDs we wanted and set up redirects to start giving them traffic. However, it became apparent that changing the top-level domain of our site required significant changes to our infrastructure.

#### Cross-domain authentication

Authentication on Pinterest is pretty standard. We have an in-house user service that handles sign ups with a username/password combination, and we employ the OAuth open standard for those who authenticate with third parties (i.e. Facebook). The backend returns an access token which we retrieve to authenticate a user each time they visit [www.pinterest.com.](http://www.pinterest.com.)

With the introduction of ccTLDs, we needed to support the ability to authenticate a user regardless of which domain they visit. Our solution was to set up a central domain (accounts.pinterest.com) that would act as the single source of truth for all logins.

![](https://cdn-images-1.medium.com/max/800/0*xGzaLMrxl2YDvYf7.)

In short, Pinterest ccTLDs communicate with the central domain to determine authentication status and setup the client-side cookie to mirror it. The next section describes this communication in detail, which we call the auth handshake.

#### The auth handshake

The general flow of the auth handshake is:

1.  During signup or login, an API call is made from the visiting domain (let’s say, [www.pinterest.abc)](http://www.pinterest.abc%29) to accounts.pinterest.com to determine authentication status.
2.  If the user is logged in on accounts.pinterest.com, they’ll automatically be logged in on [www.pinterest.abc.](http://www.pinterest.abc.)
3.  If the user is not logged in on accounts.pinterest.com, we generate an access token and set it in the cookie on both domains. This bootstraps the central domain for subsequent visits, so it can qualify step two.

There lies a problem in step one: the same-origin policy states that “scripts on a web page can only access data on a second web page if both pages have the same origin.” This is the backbone of Internet security, and it’s what prevents Javascript on malicious websites from accessing personal or sensitive information. In the case of the auth handshake, it prevents Pinterest ccTLDs from communicating with accounts.pinterest.com due to a mismatch in domain (ex. pinterest**.com** vs. pinterest**.abc**).

To work through this, we used Cross-Origin Resource Sharing (CORS), which gives web servers cross-domain access controls to enable secure data transfers across domains. This is done by adding new CORS-specific headers to HTTP requests and responses in the data transfer, and handling them accordingly.

#### Using CORS in the handshake

Let’s walk through the process with a simplified example of a Pinterest sign up on [www.pinterest.de](http://www.pinterest.de) using the auth handshake. First, the client specifies it wants to make a cross-domain request to accounts.pinterest.com with the user’s credentials. At this point, the browser automatically adds an Origin header to the request, specifying the current domain.

![](https://cdn-images-1.medium.com/max/800/0*-pGIuaxTVuwL0Ckm.)

When the request reaches the server, we create the access token and authenticate the user on accounts.pinterest.com. Once the user is logged in, the handshake sends back a custom token in the response to the client. This token can be exchanged for an access token that [www.pinterest.de](http://www.pinterest.de) can use to authenticate.

The server keeps track of all of the ccTLDs we whitelist for authentication. Before we return the response, we check if the value of the Origin request header exists in the whitelist. If so, the server adds special CORS headers to the response. The most important of these headers is Access-Control-Allow-Origin; the existence of this header signals to the client whether or not the cross-domain transfer is allowed.

![](https://cdn-images-1.medium.com/max/800/0*3AzyMrdmfwNNLXux.)

When the client receives the response, it sees the Access-Control-Allow-Origin header with the value “https://www.pinterest.de.” Since this matches the client’s origin, it continues to process the response. The custom token is retrieved and used to fetch an access token, allowing the user to log in on [www.pinterest.de.](http://www.pinterest.de.)

![](https://cdn-images-1.medium.com/max/800/0*p3ob8BR1Q6b4vY72.)

You can read more about Cross-Origin Resource Sharing and the full set of headers involved in these requests in the [official Mozilla documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS).

#### Improving discoverability through SEO

Once we set up our new local domains, the next step was to help them become more discoverable. One of the simplest ways to bootstrap traffic was to implement redirects to the new domains. When applicable, we used permanent (301) redirects from old existing country subdomains to the new associated ccTLDs (ex. de.pinterest.com → [www.pinterest.de).](http://www.pinterest.de%29.) Using permanent redirects allowed us to transfer most of the PageRank and authority of pages on old domains to new ones.

There also were a handful of indirect methods we used to improve the quality of traffic to the new ccTLDs. Hreflangs are attributes that can be included in the markup of a web page to tell search crawlers about the different language versions of it. When search engines see this markup, they surface the locally relevant page depending on the searcher’s locale. We also used files called sitemaps to help boost the efficiency and rate at which search engines crawled our site. Sitemaps are files used to list out the web pages of your website and tell search engines about the organization of your content. By serving these files directly to the search bots, it’s easier for them to find new content to crawl and rank.

### Results

To date, we’ve observed positive traffic growth and increased clicks and views in the countries where we’ve launched. One of the more interesting findings through this process was that more of our pages can be indexed, because a different top-level domain opens up a separate “crawl budget” for the search bots.

Moving forward, we’ll continue to invest in ccTLDs for our international content and are looking into further enhancing accounts.pinterest.com to serve as the central authentication hub for all Pinterest properties.

* * *

![](https://cdn-images-1.medium.com/max/800/1*VS-SIyipZqIIfQYxAvva3A.png)

_Acknowledgements: Devin Lundberg, Josh Enders, Sam Meder, Jess Males, Evan Jones, Jeff Avery, Grey Skold, Julie Trier, Vadim Antonov, Kynan Lalone, Evelyn Obamos & the International team_


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
