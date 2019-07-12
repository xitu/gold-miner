> * 原文地址：[The state of GraphQL by Reddit](https://blog.graphqleditor.com/the-state-of-graphql-by-reddit/)
> * 原文作者：[Robert Matyszewski](https://twitter.com/intent/follow?screen_name=iamrobmat)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-graphql-by-reddit.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-graphql-by-reddit.md)
> * 译者：
> * 校对者：

# The state of GraphQL by Reddit

There’s a lot of hype on GraphQL and debate to compare it to REST. GraphQL is in the early stage of adoption globally and no one exactly knows where it will end. Researching on the internet, I was able to find many positive articles presenting this new piece of tech. Is it just a hype of the first impression?

I’ve researched Reddit and selected the most upvoted comments on GraphQL. My goal was to write down as much transparent and objective article on the topic. I’ve used discussions and arguments between users to present a different point of view on each aspect. Each comment quoter below has a link to its author and number of upvotes in (). Keep in mind that upvote numbers might change since I’ve written this article.

## Agenda

* General review
* React & Apollo review
* Big Boys & GraphQL
* Caching
* Data Fetching
* Summary.

# General review

Starting from a general view I’ve chosen two cases. First, one - [SwiftOneSpeaks](https://www.reddit.com/user/SwiftOneSpeaks/) shows front end developer perspective and potential improvements in time to market. Secondly, [Scruffles360](https://www.reddit.com/user/scruffles360/) presents strategy trends on how teams adapt graphql and which one they used. Later on you’ll find more about his case. The second comment was the least upvoted one that I’ve chosen in the article.

[SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/) (23) says:

> **When I was working with a backend dev team, they were far more willing to provide new queries to match my needs because it didn’t impact existing queries they had to support. (That said, I have no idea how well this scales over time). It also reduced the number of crappy responses I had to reparse into usable (for my needs) data structures. (example, I’d get 3 arrays back that I had to relate and zip together into a single set of objects. With GraphQL, I had more ability to demand data in a useful shape, though the backend still has to do their part).**

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enpb6fg/) (8) explains his three trends in GraphQL scope:

> * The monolith - which is what Apollo is pushing now. Every company has one and only one api endpoint and schema that proxies to everything else ([https://principledgraphql.com/](https://principledgraphql.com/)). I disagree with this wholeheartedly, but won’t repeat my arguments here (you can dig through my comment history if you want)
> * The database api - for some strange reason people have started adding plugins to databases that give you direct database access via graphql. Graphql is wonderful for so many reasons, but it doesn’t come close to competing with a native database query language. More importantly, this takes away your business layer giving callers direct access to your store. No one should have access to your store except one single microservice. Everyone else should be calling through your api.
> * The medium approach - The classic API approach where each app has their own API (graphql in this case). It might isolate business logic or proxy to microservices (via rest or by schema stitching another Graphql schema). That’s the route we went, and I don’t regret a thing.

# React & Apollo review

React & Apollo combination review request gained a lot of attention. Additionally [Wronglyzorro](https://www.reddit.com/user/wronglyzorro/) and [Livelierepeat](https://www.reddit.com/user/livelierepeat/) argued about why backend developers might not like GraphQL. The response from more experienced developer gained triple more upvotes! Additionally I’ve choosen one longer but very detailed review.

[Wronglyzorro](https://www.reddit.com/r/reactjs/comments/9nmj0w/what_is_your_experience_with_react_apollo_graphql/e7nkk73/) (12) says:

> **We strictly use react + apollo on our web app. We’re also forcing the mobile clients to use it as well. It’s incredible and the future. Backend devs of course hate it because they are set in their ways and don’t like change. However over the last year when there have been any sort of outages it was never graphql that was a point of weakness. It was always the legacy backend services that crapped out.**

[Livelierepeat](https://www.reddit.com/r/reactjs/comments/9nmj0w/what_is_your_experience_with_react_apollo_graphql/e7o92o5/) (40) responded:

> **You might want to gain a little more insight that that. I used to be a young dev who used all of the latest tools and scoffed at those who “couldn’t adapt”. I’ve learned that there are often much more interesting reasons than, “people hate change”. Like does GraphQl create burdensome abstractions? What is getting added to their workload that they are resisting? At some point using all of the latest tools loses its luster. More power comes from understanding the code and the people processes as well.**

[Capaj](https://www.reddit.com/r/reactjs/comments/9nmj0w/what_is_your_experience_with_react_apollo_graphql/e7nlgrn/) (11) detailed review:

> **We use it in production since May. We’re a fullstack team so we’re not on the mercy of some other team doing the backend. It wasn’t easy persuading everyone, but with a single sample feature built in GQL everyone agreed it looked way better than REST. Graphiql helped a lot with that. It’s been quite good. We have apollo engine enabled on the backend and I really enjoy using metrics to hunt API bugs in prod. We use decapi to decorate our objection.js DB models. We have a single place where we define our models and GQL gets generated almost for free. On the frontend we use apollo-client, but we don’t use caching so far. Our FE focus is on getting rid of our legacy angular.js code, so we don’t have time yet to experiment with FE caching. I don’t event consider using apollo for client side state management, because all the feedback I’ve heard so far was that it’s not production ready yet. Also I have to say it looks quite verbose for what it really does. Instead I am hoping I can extend [https://github.com/mhaagens/gql-to-mobx](https://github.com/mhaagens/gql-to-mobx) and use that for our state management needs. MST works wonders with typescript. If we can generate MST models from our queries on the fly while editing our GQL queries we can boost our productivity considerably.**

# Caching

I’ve found a lot of great and upvoted comments from [SwiftOneSpeaks](https://www.reddit.com/user/SwiftOneSpeaks/) and [Scruffles360](https://www.reddit.com/user/scruffles360/) which had been already mentioned here. Here’s what they discussed on lack of caching and potential solution.

[SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/) (23) writes:

> **While you can configure GraphQL to work differently, as a practical matter they will always be POST requests. Which means all your browser/CDN/proxy caches that rely on GET being idempotent and POST not being now don’t work by default. Everything is treated as a new request. You can set the client to do more smart caching, but that’s literally solving a problem you created.**

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enokkzb/) (11) respoded:

> **Apollo has a solution for this. I haven’t tried it, but its called Dynamic Persisted Queries if you want to read up. Basically the client makes a GET call with a hash of the query and if it fails, falls back to POST. The next GET call will succeed and populate any proxy caches.**

# Data Fetching

Those guys also presented a different points of view on data fetching. In the [original article](https://www.imaginarycloud.com/blog/graphql-vs-rest/) writer describes an example of blog app with multiple authors and possibility of using GraphQL vs REST.

[SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/) (23) says:

> **Everyone emphasizes the “over fetching” problem. I feel like that’s a red herring outside of poorly designed services (and that sort of points out the flaw - don’t expect GraphQL services from poor service developers to suddenly not be poor) It’s easy to resolve if you put a service in front - GraphQL can be that service, but so can something else. The issue isn’t over fetching vs not, it’s having a central service AND solving the caching issues.**

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enokkzb/) (12) responded:

> **Over fetching is a real problem. When you have hundreds of clients, each calling your system in different ways, adding a property to a rest api causes massive inefficiencies. Many people point out using client-centric facades for their mobile client vs web for example, but that doesn’t scale. My project is called by hundreds of clients, each asking for slightly different data in different ways.**

# Big Boys & GraphQL

Everyone is interested in big companies like Facebook, Netflix and Coursera and their adaptation of GraphQL. In the [article](https://www.imaginarycloud.com/blog/graphql-vs-rest/) commented on Reddit we can find two main reasons as an author - states. The first comment presented was the most upvoted comment that I’ve found.

* In the early 2010s there was a boom in mobile usage, which led to some issues with low-powered devices and sloppy networks. REST isn’t optimal to deal with those problems;
* As mobile usage increased, so did the number of different front-end frameworks and platforms that run client applications. Given REST’s inflexibility, it was harder to develop a single API that could fit the requirements of every client.

[Greulich](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/ennt7ak/) (62) responded to article:

> * This is so tangential as to be pointless. A different method of structuring your requests, does not render the network on which those requests better or worse.
> * I think the author means endpoint rather than API, because any endpoint, no matter how many there are, is part of the API. Assuming that is the case, why do we NEED only one endpoint?

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enohrog/) (16) responded to Greulich:

> **The first two points weren’t worded well in the article, but are still valid. A REST API can either be generic and reusable or crafted specifically for a known client. In the first case, you aren’t going to get good performance when you keep making calls back to the system for more data (especially on high-latency networks like we had on mobile 10 years ago). If you craft your API for a specific client, you obviously run into scalability problems.**

# Summary

There’s a lot to say or choose when picking the right comment to summarize the state of GraphQL. **Till today the most popular submissions on reddit are case studies of facebook or netflix yet they aren’t much commented**. This gives us already a good summary on reddit’s view on GraphQL. From a daily developer life I couldn’t skip what [Kdesign](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enn9sdf/) (36) wrote:

> ### **GraphQL provides job security, that’s for sure**.

[Kollektiv](https://www.reddit.com/r/node/comments/bozsb1/graphql_vs_rest_putting_rest_to_rest/enng3ba/) (44) stated a great list of GraphQL issues:

> * Things like query rate limiting and credit estimation are difficult.
> * The way type and dataloaders work, it’s difficult to bind queries to the database layer in an efficient way by grouping queries without writing a full module for it.
> * Validation only checks types so you still need some kind of JSON schema to do additional format validation.
> * GraphQL queries only allow for left joins so recreating SQL like INNER JOINs together with filters quickly becomes awkward.
> * The imposed pagination (connections) from frameworks like Relay are a mess.

Regarding my initial research on GraphQL [SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/) (24) wrote:

> I expect many of the “GraphQL is great” reports we are seeing is mainly because ANY new service is great - they only get klunky over time, as assumptions are violated and needs change and code changes accrue. This doesn’t mean GraphQL won’t be great - it just means I can’t trust early reports too much.

And finally, I’ve chosen [Mando0975](https://www.reddit.com/r/node/comments/bozsb1/graphql_vs_rest_putting_rest_to_rest/enopzpk/) (28) opinion to summarize this article:

> **Development should always be about picking the right tool for the job. GraphQL isn’t always the right tool. REST isn’t dead and GraphQL isn’t going to kill it.**

### What’s your experience with GraphQL?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
