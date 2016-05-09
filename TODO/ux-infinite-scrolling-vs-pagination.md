>* 原文链接 : [UX: Infinite Scrolling vs. Pagination](https://uxplanet.org/ux-infinite-scrolling-vs-pagination-1030d29376f1#.4mfu0ijhu)
* 原文作者 : [Nick Babich](https://medium.com/@101)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


“Should I use Infinite scrolling or Pagination for my content?” Some designers are still refereeing a tug-o-war between the two methods to decide which to implement into their projects. Each of them has their strengths and weaknesses and in this article we’ll overview the two methods and decide which one we should use for our projects.

### Infinite Scrolling

Infinite scrolling is a technique that allowing users to scroll through a massive chunk of content with no finishing-line in sight. This technique simply keeps refreshing a page when you scroll down it. Tempting as it may sound, the technique isn’t a one-size-fits-all solution for every site or app.

![](https://cdn-images-1.medium.com/freeze/max/30/1*4YjR_KzD2wsFP_MDM5lE0Q.png?q=20)![](https://cdn-images-1.medium.com/max/800/1*4YjR_KzD2wsFP_MDM5lE0Q.png)</div>

<figcaption>Infinite scrolling</figcaption>


#### **Pros #1: User Engagement and Content Discovery**

When you use scrolling as your prime method of exploring the data, it _may_ make the user to stay longer on your web page, and so increase engagement. With the popularity of social media, massive amounts of data are being consumed; infinite scrolling offers an _efficient way to browse that ocean of information_, without having to wait for pages to preload.

Infinite scrolling is almost a must-have feature for _discovery interfaces_. When the user does not search for something specific so they need to see a large amount of items to find the one thing they like.

![](https://cdn-images-1.medium.com/max/800/1*ufczGiC2hnW3ogCNsXNzuQ.png)</div>

<figcaption>_Pinterest’s ocean of pins_</figcaption>

You may measure the benefits of infinite scrolling with the example of a Facebook news feed. By unspoken agreement, users are aware that they won’t get to see _everything_ on the feed, because the content is updated too frequently. With infinite scrolling, Facebook is doing it’s best to expose as much information as possible to the users and they are scanning and _consuming_ this flow of information.

![](https://cdn-images-1.medium.com/max/800/1*Tp7uqBoVLSOIfwngtJMeGg.png)</div>

<figcaption>Facebook news feed keeps user scrolling more and more for content update</figcaption>

#### Pros #2: Scrolling is Better Than Clicking

_Users have better experiences with scrolling than clicking/tapping_. The mouse wheels or touchscreens make scrolling faster and easier than clicking. For a continuous and lengthy content, like a tutorial, scrolling provides even [better usability<sup>[1]</sup>](http://www.hugeinc.com/ideas/perspective/everybody-scrolls) than slicing up the text to several separate screens or pages.

![](https://cdn-images-1.medium.com/max/800/1*UFQxw3Mvf7XgdRGNYZ_2yA.jpeg)</div>

<figcaption>For clicking/tapping: each content update requires an additional click action and wait time for a page to load. For scrolling: single scrolling action for content update. Image credit: [designbolts<sup>[2]</sup>](http://www.designbolts.com/2014/12/30/10-of-the-most-anticipated-web-design-trends-to-look-for-in-2015/)</figcaption>

#### Pros #3: Scrolling is Good For Mobile Devices

_The smaller the screen, the longer the scroll_. The popularization of mobile browsing is another significant supporter of long scrolling. The gesture controls of mobile devices make scrolling intuitive and easy to use. As a result, the users enjoy a truly responsive experience, whatever device they’re using.

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3p890yozrg30m80go7wo.gif)</div>

<figcaption>Source: [Dribbble<sup>[3]</sup>](https://dribbble.com/shots/2352597-Craigslist-redesign-mobile)</figcaption>

#### Cons #1: Page Performance and Device Resources

_Page-loading speed is everything for good user experience_. Multiple researches have [shown<sup>[4]</sup>](https://blog.kissmetrics.com/loading-time/) that slow load times result in people leaving your site or delete your app which result in low conversion rates. And that’s bad news for those who use an infinite-scrolling. The more users scroll down a page, more content has to load on the same page. As a result, the _page performance will increasingly slow down_.

Another problem is limited resources of the user’s device. On many infinite scrolling sites, especially those with many images, devices with limited resources such as an iPad can start slowing down because of the sheer number of assets it has loaded.

#### **Cons #2: Item Search and Location**

Another issue with infinite scrolling is that when users get to a certain point in the stream, they _can’t bookmark_ their location and come back to it later. If they leave the site, they’ll lose all their progress and will have to scroll down again to get back to the same spot. This inability to determine the scrolling position of the user not only causes annoyance or confusion to the users but also hurts the overall user experience, as a result.

In 2012 Etsy had spent time implementing an infinite scroll interface and [found<sup>[5]</sup>](http://www.slideshare.net/danmckinley/design-for-continuous-experimentation) that the new interface just didn’t perform as well as a pagination. Although the amount of purchases stayed roughly the same, user engagement has gone down — now people weren’t using the search so much.

![](https://cdn-images-1.medium.com/max/800/1*fzb-pg0noBPYBia8ZhsLBw.png)</div>

<figcaption>Etsy’s search interface with infinite scroll. Current version has a pagination.</figcaption>

As Dmitry Fadeyev [points out<sup>[6]</sup>](http://usabilitypost.com/2013/01/07/when-infinite-scroll-doesnt-work/): “People will want to go back to the list of search results to check out the items they’ve just seen, comparing them to what else they’ve discovered somewhere else down the list. Not only does the infinite scroll break this dynamic, it also makes it difficult to move up and down the list, especially when you return to the page at another time and find yourself back at the top, being forced to scroll down the list once again and wait for the results to load. In this way the infinite scroll interface is actually slower than the paginated one.”

#### Cons #3: Irrelevant Scroll Bar

Another annoying thing is that _scroll bars don’t reflect the actual amount of data available_. You’ll scroll down happily assuming you are close to the bottom, which by itself tempts you to scroll that little bit more, only to find that the results have just doubled by the time you get there. From an accessibility point of view it’s quite bad to break the use of scrollbars for your users.

![](https://cdn-images-1.medium.com/freeze/max/30/1*8ArcBlJK19mNRGIg3jBa-g.jpeg?q=20)![](https://cdn-images-1.medium.com/max/800/1*8ArcBlJK19mNRGIg3jBa-g.jpeg)</div>

<figcaption>Scroll bar should reflect real page length</figcaption>

#### Cons #4: Lack of a Footer

Footers exist for a reason: they contain content that the user sometimes needs — if users can’t find something or they want additional information, they often go there. But because the feed scrolls infinitely, more data gets loaded as soon as user reach the bottom, pushing the footer out of view every time.
![](https://cdn-images-1.medium.com/freeze/max/30/1*wywLjoN1ngn3ngTYu6p9qw.jpeg?q=20)

![](https://cdn-images-1.medium.com/max/800/1*wywLjoN1ngn3ngTYu6p9qw.jpeg)</div>

<figcaption>When LinkedIn introduced infinite scrolling in 2012, users managed to grab a screen just before it loaded new stories.</figcaption>

Sites that implement infinite scrolling should either make the footer accessible by making it _sticky_ or relocate the links to a top or _side bar._

![](https://cdn-images-1.medium.com/max/800/1*S0DOI2NG84PBMGO0gPn71A.png)</div>

<figcaption>Facebook moved all links from the footer (e.g. ‘Legal’, ‘Careers’) to the right side bar.</figcaption>

Another solution is to load content _on demand_ using a _Load More_ button. New content won’t automatically load until the user clicks the More button. This way users can get to your footer easily without having to chase it down.

![](https://cdn-images-1.medium.com/max/800/1*du1cepjlGiMG-yMfV2RRSw.png)</div>

<figcaption>Instagram uses ‘Load More’ button in order to make footer accessible for the users</figcaption>

### Pagination

Pagination is a user interface pattern that divides content into separate pages. If you scroll to the bottom of a page and see the row of numbers — that row of numbers is a site’s or app’s pagination.

![](https://cdn-images-1.medium.com/max/800/1*Cmf8-zXra4FXC7sRlS0yzw.jpeg)</div>

<figcaption>Pagination</figcaption>

#### **Pros #1: Good Conversion**

Pagination is good when the user is _searching_ for something in particular within the list of results, not just scanning and _consuming_ the flow of information.

You may measure the benefits of pagination with the example of Google Search. Looking for the best search result could take a second or an hour, depending on your research. But when you decide to stop searching in Google’s current format, you know the exact number of search results. You can make an decision about where to stop or how many results to peruse.

![](https://cdn-images-1.medium.com/max/800/1*UkscmldH9wnnFEGV70OtuA.png)</div>

<figcaption>Google search result data</figcaption>

#### **Pros #2: Sense of Control**

_Infinite scrolling is like an endless game _— no matter how far you scroll, you feel like you’ll never get to the end. When the users know the number of results availablethey are able to make a more informed decision, rather than be left to scour an infinitely scrolling list. According to the David Kieras research [Psychology in Human-Computer Interaction<sup>[7]</sup>](http://videolectures.net/chi08_kieras_phc/): “_Reaching an end point provides a sense of control_”. The research also clarifies that when users have limited but still relevant results, they are able to determine easily if what they’re seeking is actually there or not.

Also when users see total number of results (of course when a total amount of data isn’t infinite) they will be able to estimate how much time it’ll take to find what they’re actually looking for.

#### Pros #3: Item Location

Having a paginated interface lets the user keep a _mental location_ of the item. They may not necessarily know the exact page number of page, but they will remember roughly what it was, and the paginated links will let them get there easier.

![](https://cdn-images-1.medium.com/max/800/1*yHj3EYY8ebffjwyM-bwjoQ.png)</div>

<figcaption>With paginations users are in control of navigation because they know which page to click on to get back to where they were.</figcaption>

Pagination is good for ecomerce sites and apps. When users shop online, they want to be able to come back to the place they left off and continue their shopping.

![](https://cdn-images-1.medium.com/max/800/1*osnIWtLG6UusQjDJZGRpDw.jpeg)</div>

<figcaption>MR Porter site uses a pagination for items</figcaption>

#### Cons: Extra Actions

To get to the next page in a pagination, the user has to find the link target (e.g. “Next”), hover the mouse over it, click it and wait for the new page to load.

![](https://cdn-images-1.medium.com/max/800/1*l5djDDvsP0_JU7oP1EQIbg.png)</div>

<figcaption>Clicking for a content</figcaption>

The main problem here is that most sites show users very limited content with a single page. By making your pages longer without compromising loading speed, users will get more content per page and won’t have to click or tap the pagination button as much.

### When To Use Infinite Scrolling/Pagination?

There are only a few instances where infinite scrolling is effective. It’s best suited for sites and apps that _boast user-generated content_ (Twitter, Facebook) or _visual content_ (Pinterest, Instagram). Pagination, on the other hand, is a safe option, and good solution for sites and apps that intend to satisfy the goal-oriented activities of the users.

Google experience is a good illustration for this point. Google Images uses infinite scroll because users are able to scan and process images much more quickly than text. Reading a search result takes much longer. This is the reason why their Google Search results still use the more traditional pagination technique.

### Conclusion

Designers should weigh the pros and cons of infinite scrolling and pagination before select the one. The choice depends on the context of your design and how that content is delivered. In general, an infinite scroll works well for something like Twitter where users consuming an endlessly flowing stream of data _without looking for anything in particular_, while pagination interface is good for search results pages _where people are looking for a specific item and where the location of all the items the user has viewed matter_.

In upcoming articles we’ll overview best practices for infinite scroll and pagination. So stay tuned!

