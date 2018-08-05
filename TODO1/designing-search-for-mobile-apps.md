> * 原文地址：[Designing search for mobile apps](https://medium.muz.li/designing-search-for-mobile-apps-ab2593e9e413)
> * 原文作者：[Shashank Sahay](https://medium.muz.li/@shashanksahay?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/designing-search-for-mobile-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/designing-search-for-mobile-apps.md)
> * 译者：
> * 校对者：

# Designing search for mobile apps

## Explore the various ways to implement search and the purpose behind each

![](https://cdn-images-1.medium.com/max/2000/1*KMCNd82pJP-lUQIoZaxpGQ.png)

Feature Breakdown #4: Search for mobile apps

After 3 feature breakdowns, I have another interesting feature for you — **Search for mobile apps**. Search is a fairly complex feature and this article does not cover everything there is to know about it. In this story, I will be discussing how to pick between the two most popular ways of using search on your application, search bar on the landing screen or search tab on the navigation bar.

### Search for mobile apps

So many applications that we use on a daily basis have the Search feature. The way these applications implement search can be very different. But why is there a need for different implementations of the same feature? Is one better than the other? Let’s find out.

### 1. Search bar on landing screen

![](https://cdn-images-1.medium.com/max/2000/1*L8hbI6zINOlZwUoCXvq0YQ.png)

Search bar on the landing screen

Here’s a screenshot of some of the popular apps that use a search bar on the landing screen. The **search bar** is easily discoverable as most of the times it is present on the top of the landing screen.

In this case, the Search caters to the users who have a **clear intention** behind performing a search. Any suggestions or help the platform might provide will be on the basis of the keyword entered by the user.

_(This explanation also applies to apps that have a search icon on the top right of the landing screen. I’ve put these two variations together, as they’re very similar in terms of discoverability, accessibility and even take the same number of taps to use.)_

### 2. Search tab on navigation bar

![](https://cdn-images-1.medium.com/max/2000/1*htxb3xD_rwZOeDkjGc5YnA.png)

Search tab on the navigation bar

And here are screenshots of some apps that use search as a tab on the navigation bar. This Search isn’t as discoverable as the Search bar on the landing screen, but it is easily accessible considering that the users can easily reach it with their thumbs.

In this case, Search gets an entire screen for itself. This screen has a search bar on the top and the rest of the screen is populated with data that would either aid the user’s search or would help the user explore the content on the platform. This facilitates an **exploratory search** for the user who does not have a clear intention yet.

### Bar or Tab?

Both the searches aid different intentions of the user. And that’s not all, both the searches also depend on the type of platform and the kind of content the platform offers.

#### Use a search bar on the landing screen when

1.  The **user’s primary intention behind opening the app could be searching for something**. For reference, have a look at Google Maps, Uber or Zomato. Most of the times people open these apps precisely to perform a search for a location, a restaurant or a dish.
2.  The **user has a clear intention behind performing the search**, as in the case of Facebook where users generally look for other users or pages. Most of the times they know what the name of the user or page might be, even if they’re not completely certain of how it’s spelled. For such platforms, it’s a rare possibility that the user only has vague information about the thing they’re looking for. And even if this possibility arises, there’s not much that the platform can do to help the user.

#### Use search as a tab on the navigation bar when

1.  You want to **enhance user engagement** by allowing the user to explore and discover new content on the platform. For reference, have a look at Instagram and Twitter. These platforms want the users to stay longer on the app, which is why they offer personalized content which is outside your network to help you discover new users or content that you might be interested in.
2.  The **user isn’t sure of what they’re looking for** and the app can guide the user in finding what they want. For reference, look at Netflix and Uber Eats. They allow the users to explore the app via the means of genres and cuisines. This caters to the user who knows he wants to watch a comedy show but isn’t really sure of which one he should watch.

### Now, let’s look at Airbnb?

![](https://cdn-images-1.medium.com/max/2000/1*yhxaOzAg5yPGXeIdHPVRPw.png)

Airbnb

Airbnb uses a mix of both the variations. They’ve got a search bar on the landing screen and the landing screen is the search/explore tab.

Given the context of Airbnb I believe that it makes a lot of sense. By doing this they cater to two types of users — users with a specific destination in mind who would use the search bar (users with **clear intention**), and users who might not have a specific destination in mind, and are in the process of figuring out the destination (users who need kind of an **exploratory search**).

### Conclusion

Both the variations have pros and cons. Both of them are suited for specific use cases. Going through all the examples above, we can conclude that there are two factors that determine which search to use — intentions of users coming to the app and the possible offerings of the app.

* * *

#### Special Thanks To

[Tanvi Kumthekar](https://medium.com/@tanvikumthekar) and [Shailly Kishtawal](https://medium.com/@shailly.kishtawal) for the brainstorming.  
[Dhruvi Shah](https://www.linkedin.com/in/dhruvishah394/), [Nisshtha Khattar](https://www.linkedin.com/in/nisshtha-khattar-9ab554159/), [Preethi Shreeya](https://uxplanet.org/@preethishreeya1) and [Prasanth Marimuthu](https://www.linkedin.com/in/prasanthuxer/) for their constant feedback.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
