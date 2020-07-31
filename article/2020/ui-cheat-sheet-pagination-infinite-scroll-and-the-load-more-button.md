> * 原文地址：[UI cheat sheet: pagination, infinite scroll and the load more button](https://uxdesign.cc/ui-cheat-sheet-pagination-infinite-scroll-and-the-load-more-button-e5c452e279a8)
> * 原文作者：[Tess Gadd](https://medium.com/@tessgadd)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/ui-cheat-sheet-pagination-infinite-scroll-and-the-load-more-button.md](https://github.com/xitu/gold-miner/blob/master/article/2020/ui-cheat-sheet-pagination-infinite-scroll-and-the-load-more-button.md)
> * 译者：
> * 校对者：

# UI cheat sheet: pagination, infinite scroll and the load more button

![](https://cdn-images-1.medium.com/max/2390/1*zdbbG0Pjgqm4lCgiTtsuyw.gif)

When you have a lot of content, you have to rely on one of these three patterns to load it. So, which is best? What will your users like? What do most platforms use? These are the questions we will explore today.

Before you start, I would recommend checking out my other two related cheat sheets, one on [searching and browsing](https://uxdesign.cc/ux-cheat-sheet-searching-vs-browsing-221de84c51ed) and the other on [grids and lists](https://uxdesign.cc/ui-cheat-sheet-list-vs-grids-48151a7262a7). While these aren’t critical to understanding the three pattern types, they will give you some background and context.

## In this cheat sheet we will cover:

**1. Introduction**

**2. Pagination**
2.1. Fact-ish sheet
2.2. How many items per page
2.3. Component: Navigation
2.4. Component: Filters
2.5. Component: Sorting
2.6. Component: Items per page
2.7. Component: Showing results
2.8. Component: Grid to list switcher
2.9. Component: Alphabetical index
2.10. Component: Jump to

**3. Infinite scroll**
3.1. Fact-ish sheet
3.2. Component: Sticky nav bar
3.3. Component: Instagram’s ‘You are all caught up’ component
3.4. Component: Loader

**4. Load more button**
4.1. Fact-ish sheet
4.2. Components: ‘Load more’ button
4.3. Component: Loader
4.4. Component: Search suggestions tags
4.5. Component: Scroll to top button

**5. Closing thoughts**

**6. Further reading & references**

## 1. Introduction

Imagine you’re a happy little server in a big server room. You can handle a few tasks at a time, mostly just sending stuff to people when they ask for it, life is good. And then one day, you are asked to send 926 trillion items for 4 million different people. You would probably freak out and die* and the people asking for these results would also die (but of boredom waiting for them to load). And this is why we have pagination, infinite scroll and the load more button.

These patterns allow the server to send through only a portion of the content to a user at a time, thus reducing load time. But they each have their own strengths and weaknesses, and you have to decide which is better for your product.

In a nutshell:

**Pagination** is just pages. Think most online stores.

**Infinite scroll** tricks you into thinking that everything has been downloaded, but is, in fact, downloading as you scroll. Think Instagram.

**Load more button** is a button at the bottom of a page that allows you to load more results. Think Google Images.

![Example of pagination, infinite scroll and load more button](https://cdn-images-1.medium.com/max/2800/0*DRqqvS2DptOYkV4w)

> I have no idea how servers die. I imagine that they go out in a BOOM while singing ‘don’t cry for me Argentina’. But I can’t be sure. I am also pretty sure this wouldn’t **actually** kill a server. Just crash it or something.

![](https://cdn-images-1.medium.com/max/2000/0*_ZAZQ4gOtHN7ZJks)

## 2. Pagination

Due to my hours of online shopping (I suspect that I am single-handedly keeping local small businesses going during the COVID-19 lockdown), I can safely say that pagination is still the most popular way to display products. And if you don’t believe me, [Smashing Magazine](https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/) says so too.

When a user is in ‘[search mode](https://uxdesign.cc/ux-cheat-sheet-searching-vs-browsing-221de84c51ed)’ they are looking for something specific. The following sites use pagination in their search results:

* [Google (Desktop)](https://www.google.com/search?rlz=1C5CHFA_enUS877ZA884&sxsrf=ALeKk01ssJwgOpcNeWawl9694MdEx5Yjdg%3A1589363024501&ei=UMG7XoKNHq-Z1fAPztSG-A8&q=cat&oq=cat&gs_lcp=CgZwc3ktYWIQAzIECAAQRzIECAAQRzIECAAQRzIECAAQRzIECAAQRzIECAAQRzIECAAQRzIECAAQR1CKKliKKmDxK2gAcAF4AIABAIgBAJIBAJgBAKABAaoBB2d3cy13aXo&sclient=psy-ab&ved=0ahUKEwiC9fnTxrDpAhWvTBUIHU6qAf8Q4dUDCAw&uact=5)
* [Amazon](https://www.amazon.com/s?k=cats&ref=nb_sb_noss_2)
* [Udemy](https://www.udemy.com/courses/search/?src=ukw&q=cats)
* [eBay](https://www.ebay.com/sch/i.html?_from=R40&_trksid=m570.l1313&_nkw=cats&_sacat=0)
* [Shutterstock](https://www.shutterstock.com/search/cats?kw=shutterstock&gclid=CjwKCAjwte71BRBCEiwAU_V9hwNfj0t9hxqy94wLsOWqMYoN32wyaa2fA1Z8asCHyNSSJ9c9XB5MTxoCxIsQAvD_BwE&gclsrc=aw.ds)

#### 2.1. Fact-’ish’ sheet

While some of the below bullet points are researched facts, a lot of them are also my opinion; so please take them with a grain of salt when deciding on the right pattern to use.

**Pros:**

* Popular on eCommerce sites.
* Allows users to research and reference pages (“Oh, those earrings I liked were on page 3”).
* Good for sites where the order of items are important.

**Cons:**

* People perceive it as being slow and taking a long time to load. ([reference](https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/))
* If Google’s search results is anything to go by — anything on page 2 might as well not exist. That being said, if I am shopping for something, I will click through every. Damn. Page.
* Being a fairly ‘old’ pattern, I suspect that most people find it a bit old-fashioned compared to infinite scroll & lazy load.
* Navigation elements have to be simpler on mobile due to [fat fingers](https://www.experiencedynamics.com/blog/2014/09/ux-power-fat-finger-friendly) (or maybe that’s just me? *quickly hides hands*).

**Interesting:**

* While most patterns include the page number’s links, users usually just click ‘next’ or ‘previous’. ([reference](https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/))
* While most people complain about it — pagination still seems to be the most popular of the three patterns.
* People spend more time looking at the content on page one. ([reference](https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/))

**Popular with:**

* eCommerce
* Search results
* Reference catalogues

#### 2.2. How many items should you have per page

So, how many items should you have on your page? Well, it will depend on a couple of factors, a) Are you using a [grid or list view](https://uxdesign.cc/ui-cheat-sheet-list-vs-grids-48151a7262a7), b) Do you have a ‘items per page component’? c) How big are your items?

Below is a list of how many items load per page on the following sites:

**Grid view**
Sears: 50
Toy’s R Us: 100
Shutterstock: 27
Amazon: 48

**List view**
Udemy: 20
Alibaba: 48
CNN: 10
Google search: +/- 10 items (depending on if you count ads)
Amazon: 16

**Grid view with an ‘items per page’ component**
Macy’s: 60 (default) or 120
Superbalist: 24 (4 across) (default) or 72 (6 across) or 72 (8 across)
Newegg: 36 (default) or 60 or 90
Currys PC World: 20 (default) or 30 or all
Wondery: 10 or 20 (default) or 50 or 100
Foyles: 10 or 20 (default) or 50 or 100 or 200
Barns & Noble: 20 (default) or 40

**List view with an ‘items per page’ component**
eBay: 25 or 50 (default) or 100 or 200

The above ‘item per page’ counts were gathered on the 14th of May 2020.

**Question:** So, what is the perfect number of items to display per page?

**Answer:** I can’t tell you. If you look at all the above values, you will see that there seems to be very little agreement between different sites (except for the sites with a grid view and ‘items per page’ component).
When designing your own catalogue page, I would decide on how many ‘scroll downs’ your user would want to do, and how many items you would want to expose them to per page.

#### 2.3. Component: Navigation

Next/Previous buttons are the main way that users navigate through pages, so it makes sense to make them fairly prominent. Because users are more likely to look for the ‘next’ button, make sure it has a more dominant style (or is a ‘primary action button’ if you have read my [cheats sheet on buttons](https://uxdesign.cc/ui-cheat-sheets-buttons-7329ed9d6112).)

![**Example of pagination navigation**](https://cdn-images-1.medium.com/max/2800/0*Sb0qS-U2Wspc5dy0)

Without the luxury of space on mobile, rather use the page number as indicators only, and the buttons for navigation.

![**Example of pagination’s navigation on mobile**](https://cdn-images-1.medium.com/max/2800/1*yFV6MzRzHd7UlxBZjBmfPg.png)

Something else to keep in mind is that you will need to either hide or disable a ‘previous’ or ‘next’ button if you are on the first or last page. I am more of a ‘hidden’ girl myself, but the choice is yours.

![Example of pagination’s navigation components on the first page: The top one has the ‘Previous’ button disabled, the bottom has the button hidden.](https://cdn-images-1.medium.com/max/2800/1*_xW_QY2hzMAbb1T1OIHqig.png)

**DO YOU** NEED **IT FOR PAGINATION?** Yes. You can’t navigate pages without it.

#### 2.4. Component: Filters

Filters help your users find more accurate results. This is, of course, relying on your content being accurately tagged and categorized.

There are two main filtering styles, the first being aligned to the top of the page above the results. Use this style if there are only a few facets, or if you want your list or grid to take up the full width of the page grid. Top filtering can also be used on pages with a ‘load more button’, like Google Images.

![**Example of top filters**](https://cdn-images-1.medium.com/max/2800/1*Vqiv3ksv2z8UcVbCXeErHg.png)

The second filtering style is aligned to the left. I would suggest using this style if you have a lot of categories and your list/grid doesn’t need the full width.

![**Example of side filters**](https://cdn-images-1.medium.com/max/2800/1*_JlJNePykddQbzuFr1Gfuw.png)

**DO YOU** NEED **IT FOR PAGINATION?** It’s an expected element, but not a required one.

#### 2.5. Component: Sorting

Sorting allows the user to order the content in the way they want. While most of us ramen eating millennials will choose to order by ‘lowest price’ — this isn’t what is most important to everyone. By default, it should be set to ‘most relevant’ if you got to that page via a search query. If the user just clicks on a catalogue without adding any search terms, you could also default by ‘most relevant’ but maybe consider going by ‘most rated’ or ‘newest’, or even a criteria that’s specific to your site, e.g. ‘most lit’ or whatever gen Z is saying these days.

![**Example of sorting**](https://cdn-images-1.medium.com/max/2800/0*4n1cXzSHxy9BuKGb)

When creating your options to sort through, you might consider using some of the options from the list below. They may not always be relevant, e.g. ‘Sort A-Z’ won’t be useful when looking at handbags, but will be useful when looking at students in a class.

* Most relevant
* Most viewed
* Most reviewed
* Most rated
* Most favourited
* Newest
* Lowest price
* Highest Price
* Alphabetical: A-Z
* Alphabetical by first name: A-Z
* Alphabetical by surname: A-Z
* Highest score
* Lowest score

Etc.

**DO YOU** NEED **IT FOR PAGINATION?** It’s an expected element, but not a required one.

#### 2.6. Component: Items per page

This allows the user to see either more or less items on a page. A user will usually adjust this depending on their internet speed and how many items they want to see on the page. While doing my research, I noticed that this component was used more on British sites than American ones. I’m not sure if it was the sites I picked or if this is a thing? If you have noticed this too — let me know in the comments. :)

![**Example of an items per page component**](https://cdn-images-1.medium.com/max/2800/0*EJJV9bCXsdz45_yi)

**DO YOU** NEED **IT FOR PAGINATION?** Nice to have.

#### 2.7. Component: Showing results

Your user may want to know how many items are available for them to see. This will indicate how popular their search criteria is and how many options they have. This is a static component and won’t be interactable.

![**Example of a showing results component**](https://cdn-images-1.medium.com/max/2800/0*vVkM9iVf3AdQdr_7)

Usually, you wouldn’t show this component without the items per page component. Sometimes the two can even sit hand in hand.

![Example of a combination of showing results and items per page component](https://cdn-images-1.medium.com/max/2800/0*jCP9vMGdlDN45bEi)

**DO YOU** NEED **IT FOR PAGINATION?** It’s expected, but not required.

#### 2.8. Component: Grid to list switcher

This component allows you to switch between a grid and a list view. This can be helpful if you don’t fully understand how your users want to view your content. I would also suggest doing some AB testing to see which style your users prefer.

![**Example of a grid or list switcher component**](https://cdn-images-1.medium.com/max/2800/0*glEsBiRFOJXKPbw5)

You can also switch between grid widths using this component. I find it quite helpful when doing online shopping so that I can alternate between a ‘scanning’ view and an ‘evaluating’ one.

![**Example of a grid width component**](https://cdn-images-1.medium.com/max/2800/0*aO_QWMJFmM54IZxt)

**DO YOU** NEED **IT FOR PAGINATION**? It’s nice to have, but definitely not required.

#### 2.9. Component: Alphabetical index

Whenever I come across one of these components — I know I’m on an old site. Alphabetical index components are a ‘phone book’ type style that allows you to easily find someone by their initial. I suspect these aren’t that popular anymore — I mean, usually, there are so many people on a site, that an index like this won’t help anyway — and search is just **so** much more effective.

![**Example of Alphabetical index component**](https://cdn-images-1.medium.com/max/2800/0*CmSJjAIlrXau8i9h)

**DO YOU** NEED **IT FOR PAGINATION?** Probably not, unless you are designing a glossary or something. Give your users a break and use a search component instead.

#### 2.10. Component: Jump to

I like these guys, but seldom see them anymore. It really is a great way of navigating through big documents and reference sites, or just getting back to page 36 which had the casserole dish I liked.

![**Example of a jump to component**](https://cdn-images-1.medium.com/max/2800/0*bbwepGWj1iWDzM7o)

**DO YOU** NEED **IT FOR PAGINATION**? It’s nice to have, but definitely not required.

---

![](https://cdn-images-1.medium.com/max/2000/1*m0v-9wHuC8vMGuk8GcSlwQ.gif)

## 3. Infinite scroll

Remember when everyone (a.k.a. my old boss) said ‘**scroll is dead**’, ‘**users don’t like scrolling**,’ and if something isn’t ‘**above the fold**’ on a site then no one would ever see it? Well, I invite you to laugh at them with me:

BAHAHAHAHAHAHAAHAHAHAHAHAHAHAHAHAAHAHAHAHHA.

Moving along.

Infinite scroll is the quintessence of ‘browsing behaviour’ (apologies for the use of quintessence, I have recently watched **The Secret Life of Walter Mitty** and now it is my favourite big word). It’s best for entertainment, you just scroll and scroll and scroll and as you do so, time (and your life) just starts to disappear. However — it is kind of awful for eCommerce. Imagine trying to find something you saw 30 scrolls earlier? Hence, it lives mostly in the realms of social entertainment.

> # **“scrolling is a continuation; clicking is a decision”
> # - [Joshua porter](http://bokardo.com/archives/scrolling-easier-clicking/)**

#### 3.1. Fact-’ish’ sheet

While some of the below bullet points are researched facts, a lot of them are also my own opinion, so again, please take them with a grain of salt when deciding on the right pattern to use.

**Pros:**

* **Infinite scroll can be addictive.**
* It has a perceived quick load time.
* It’s ‘trendy’.
* It has long periods of user engagement.
* Scrolling is an expected behaviour, especially on touch screens.
* It’s good for images.

#### Cons:

* **Infinite scroll can be addictive.**
* It’s really bad for searching for content and is difficult to find something you found earlier.
* Users focus less on the content. ([reference](https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/))
* Your user will almost never see the footer (if you have one).
* Not good for text search results.
* Navigation can become tricky and users may have to scroll all the way up to get to the nav bar (if it isn’t sticky).
* There are vague whispers about banning infinite scroll. ([reference](https://www.cnet.com/news/bill-wants-to-ban-infinite-scroll-autoplay-to-curb-your-social-media-addiction/))
* Tracking the analytics is harder (I haven’t got any personal insight into this, but [designshack.com](https://designshack.net/articles/layouts/infinite-scrolling-pros-and-cons/) has suggestions on how to deal with it).
* You can have performance issues if the user has a bad signal.

**Interesting**:

* Having infinite scroll allows the platform to continually generate content for the user (varying in relevance). Pinterest is a perfect example of this, as you scroll, it brings up more and more content related to your interests.
* This pattern is also sometimes called endless scroll.

**Examples:**

I have yet to come across an eCommerce site using infinite scroll*, and as far as I can tell, it is mostly entertainment & social sites that use it, for example:

* Instagram
* [Twitter](https://twitter.com/search?q=cats&src=typed_query)
* [Pinterest](https://za.pinterest.com/search/pins/?q=cats&rs=typed&term_meta%5B%5D=cats%7Ctyped)
* Facebook
* YouTube
* Google play

**Post publish edit:** [Saurav Pandey](undefined) reminded me that some mobile versions (m.) of eCommerce sites use infinite scroll, for example: [https://m.snapdeal.com/](https://m.snapdeal.com/).

Thank you!

#### 3.2. Component: Sticky nav bar

Because infinite scroll scrolls well, infinitely, you have to make sure your navigation sticks — otherwise your poor user will never be able to find their way around your platform. For platforms viewed in a browser, I would recommend sticking the nav to the top of the screen. With apps, you probably have more flexibility, and like Instagram, you could probably get away with docking a nav at the top and bottom.

![**Examples of a sticky nav on mobile**](https://cdn-images-1.medium.com/max/2800/0*kA8hc8jJ7cO-Kr0K)

**DO YOU** NEED **IT FOR INFINITE SCROLL**? Yes, it’s required.

#### 3.3. Component: Instagram’s ‘You’re all caught up’ component

Remember when we used to spend hours scrolling through Instagram on the couch? And then one day we saw the ‘You’re all caught up’ message and it screamed “get off the couch, you’re wasting your life!” at you? Yeah, it was a hard day for me too.

Instagram received a lot of criticism in the past because people couldn’t keep track of what they had and hadn’t seen, which is why they introduced this [component](https://about.instagram.com/blog/announcements/introducing-youre-all-caught-up-in-feed). While I didn’t like it at first, it **has** made my experience much better, and I personally appreciate my 10 minute scroll sessions so much more (especially in lockdown).

![Example of a ‘You are all caught up’ component inspired by Instagram’s](https://cdn-images-1.medium.com/max/2800/0*VEKiizoPFp1yHhtm)

**DO YOU** NEED **IT FOR INFINITE SCROLL**? It’s a nice to have depending on your platform.

#### 3.4. Component: Loader

In an ideal world — you will never know what an app’s loader looks like. But, alas, we don’t live in that world. Or maybe [Taiwan](https://www.webfx.com/blog/internet/fastest-internet-connection-infographic/) does? If you are from Taiwan, can you confirm in the comments if you still see loaders? I mean, I assume you do — but give a girl hope.

![**Example of a loader**](https://cdn-images-1.medium.com/max/2800/0*wi8c-WJQ1Q2B0UWO)

If you have poor internet connection or the server you are downloading from is slow, you will have to stare at a loader for what seems like forever. Loaders are just an indicator to let you know that the platform hasn’t crashed — it’s just struggling. It’s kinda like a pulse — it let’s you know that your body is alive, even though you feel dead on the inside after that millionth Instagram scroll.

**DO YOU** NEED **IT FOR INFINITE SCROLL?** Yes, it’s required.

![](https://cdn-images-1.medium.com/max/2000/0*vMPfzQjNIkLoCDFN)

## 4. Load more button

The load more button is the third child that no one really talks about, and when they do, it is to compare it to its siblings. It’s always ‘pagination this’ and ‘infinite scroll that’, and the poor old load more button is just playing with their Pokémon tazos in the background waiting for someone to come talk to them. It is strange that this pattern doesn’t get as much attention, seeing as it’s used by one of the biggest search engines in the world — Google. They use it on mobile and in Google Images (and probably more places, I just felt like these two proved enough of a point and I didn’t feel like checking anymore).

#### 4.1. Fact-’ish’ sheet

Remember, while some of the below bullet points are researched facts, a lot of them are also my own opinion.

**Pros:**

* Like pagination, you can still order results.
* Like infinite scroll, it works well on mobile.

**Cons:**

* Like infinite scroll, it’s hard to find a result again.

**Interesting:**

* It has an ‘end’ and won’t carry on creating content like Pinterest.

**Examples:**

* Google (on mobile)
* Google Images
* Harvard Business Review (in search)
* Stitcher
* Marks and Spencer

#### 4.2. Component: Load/Show more results button

This is the button that this pattern couldn’t work without. Once you reach the bottom of the page, it will appear, signalling that you can still load more results.

![**Example of a Load/show more button**](https://cdn-images-1.medium.com/max/2800/0*dTch4L0yfi68uKTb)

One of the things that you will have to decide on, is what to say on the button. ‘Load more’, ‘Show more results’ and ‘More results’ seem to be the most common.

**DO YOU** NEED **IT FOR LOAD MORE BUTTONS?** Yes, it’s required.

#### 4.3. Component: Loader

Like the infinite scroll, you will probably need a loader. The loader will only be triggered when you click the ‘load more button’.

![**Example of a loader**](https://cdn-images-1.medium.com/max/2800/0*bbah2SCwfcxxSW0z)

**DO YOU** NEED **IT FOR LOAD MORE BUTTONS?** It’s required.

#### 4.4. Component: Search suggestions tags

These little search suggestion tags are a lovely way to encourage your user to browse more around a topic. You can also have them on the other patterns, but they seem to work best with ‘load more’ buttons.

![**Example of search suggestion tags**](https://cdn-images-1.medium.com/max/2800/0*6V9nL4BbvfqU-oFT)

**DO YOU** NEED **IT FOR LOAD MORE BUTTONS?** No, but it’s nice to have.

#### 4.5. Component: Scroll to top button

This handy little guy allows you to scroll all the way to the top without you having to do it manually.

![**Example of a scroll to top button**](https://cdn-images-1.medium.com/max/2800/0*xMAtJo-lwOSLhYPs)

## 5. Closing thoughts

**Question**: So, pagination, infinite scroll or a load more button — which should you use?

**The answer**: It depends entirely on what kind of product experience you’re trying to build.

If you’re building a site where people will reference and browse your content — look at using pagination. But if you’re looking at building a social platform where you expect users to browse — use an infinite scroll. Use a ‘load more’ button somewhere in between those two or when the situation makes sense.

Happy designing!

## 6. Further reading and references

* The Pros and Cons of Infinite Scroll: [https://www.webdevelopmentgroup.com/2017/06/the-pros-and-cons-of-infinite-scroll/](https://www.webdevelopmentgroup.com/2017/06/the-pros-and-cons-of-infinite-scroll/)
* Scrolling is easier than clicking: [http://bokardo.com/archives/scrolling-easier-clicking/](http://bokardo.com/archives/scrolling-easier-clicking/)
* Infinite Scrolling: Pros and Cons: [https://designshack.net/articles/layouts/infinite-scrolling-pros-and-cons/](https://designshack.net/articles/layouts/infinite-scrolling-pros-and-cons/)
* ⭐ Infinite Scrolling, Pagination Or “Load More” Buttons? Usability Findings In eCommerce [https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/](https://www.smashingmagazine.com/2016/03/pagination-infinite-scrolling-load-more-buttons/)

![The UX Collective donates US$1 for each article published in our platform. This story contributed to [UX Para Minas Pretas](https://twitter.com/uxminaspretas) (UX For Black Women), a Brazilian organization focused on promoting equity of Black women in the tech industry through initiatives of action, empowerment, and knowledge sharing. Silence against systemic racism is not an option. Build the design community you believe in.](https://cdn-images-1.medium.com/max/2000/0*r6TyOzWAtX5kA1G-)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
