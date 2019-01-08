> * 原文地址：[Top JavaScript Frameworks and Topics to Learn in 2019](https://medium.com/javascript-scene/top-javascript-frameworks-and-topics-to-learn-in-2019-b4142f38df20)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/top-javascript-frameworks-and-topics-to-learn-in-2019.md](https://github.com/xitu/gold-miner/blob/master/TODO1/top-javascript-frameworks-and-topics-to-learn-in-2019.md)
> * 译者：
> * 校对者：

# Top JavaScript Frameworks and Topics to Learn in 2019

![](https://cdn-images-1.medium.com/max/2560/1*RFPEzZmTByjDmScp1sY8Jw.png)

Image: Jon Glittenberg Happy New Year 2019 (CC BY 2.0)

It’s that time of year again: The annual overview of the JavaScript tech ecosystem. Our aim is to highlight the learning topics and technologies with the highest potential job ROI. What are people using in the workforce? What do the trends look like? We’re not attempting to pick what’s best, but instead using a data-driven approach to help you focus on what might actually help you land a job when the interviewer asks you, “do you know __(fill in the blank)__?”

We’re not going to look at which ones are the fastest, or which ones have the best code quality. We’ll assume they’re all speed demons and they’re all good enough to get the job done. The focus is on one thing: What’s actually being used at scale?

### Component Frameworks

The big question we’ll look at is the current state of component frameworks, and we’re going to focus primarily on the big three: React, Angular, and Vue.js, primarily because they have all broken far ahead of the rest of the pack in terms of workplace adoption.

Last year I noted how fast Vue.js was growing and mentioned it might catch Angular in 2018. That didn’t happen, but it’s still growing very quickly. I also predicted it would have a much harder time converting React users because React has a much stronger user satisfaction rate than Angular — React users simply don’t have a compelling reason to switch. That played out as expected in 2018. React kept a firm grip on its lead in 2018.

Interestingly, all three frameworks are still growing exponentially, year over year.

#### Prediction: React Continues to Dominate in 2019

React still has [much higher satisfaction ratings than Angular](https://2018.stateofjs.com/front-end-frameworks/overview/) for the third year we’ve been tracking it, and it’s not giving up any ground to challengers. I don’t currently see anything that could challenge it in 2019. Unless something crazy big comes along and disrupts it, React will be the framework to beat again at the end of 2019.

Speaking of React, it just keeps getting better. The new [React hooks API](https://reactjs.org/docs/hooks-reference.html) replaced the `class` API I’ve been merely tolerating since React 0.14. (The `class` API still works, but the hooks API is really _much better_). React’s great API improvements, like better support for code splitting and concurrent rendering (see [details](https://reactjs.org/blog/2018/11/13/react-conf-recap.html)), are going to make it really hard to beat in 2019. React is now without a doubt, the most developer friendly front-end framework in the space. I couldn’t recommend it more.

#### Data Sources

We’ll look at a handful of key pieces of data to gauge interest and use in the industry:

1.  **Google Search trends.** Not my favorite indicator, but good for a big picture view.
2.  **Package Downloads.** The aim here is to catch real users in the act of using the framework.
3.  **Job board postings from Indeed.com.** Using the same methodology from previous years for consistency.

#### Google Search Trends

![](https://cdn-images-1.medium.com/max/800/1*DPlan5kEE81FW0eUA3Y3oQ.png)

Framework search trends: Jan 2014 — Dec 2018

React overtook Angular in the search trends in January 2018, and held its lead through the end of the year. Vue.js now holds a visible position on the graph, but still small factor in the search trends. For comparison: last year’s graph:

![](https://cdn-images-1.medium.com/max/800/1*q0MyFu6pldf-guTIQweTSQ.png)

Framework search trends: Jan 2014 — Dec 2017

#### Package Downloads

Package downloads give us a fair indication of what’s actually being used, because developers frequently download the packages they need while they’re working.

Overly-clever readers will note that sometimes they download these things from their internal corporate package repos, to which I answer, “why yes, that does happen — to all three frameworks.” All of them have established a foothold in the enterprise, and I’m confident in the averaging power of this data at scale.

**React Monthly Downloads: 2014–2018**

![](https://cdn-images-1.medium.com/max/800/1*IV9KdeP1hOwxSVZdwoKKcQ.png)

**Angular Monthly Downloads: 2014–2018**

![](https://cdn-images-1.medium.com/max/800/1*IxS8G-0oixLWL0F2NDIYng.png)

**Vue Monthly Downloads: 2014–2018**

![](https://cdn-images-1.medium.com/max/800/1*uvg4_D5NyuIiyUI_H72S2w.png)

Let’s look at a quick visual comparison of the share of downloads:

![](https://cdn-images-1.medium.com/max/800/1*THtgoY-LQTvIm8ezl3SGiQ.png)

_“But you’re forgetting all about Angular 1.0! It’s still huge in the enterprise.”_

No, I’m not. Angular 1.0 is still used a lot in the enterprise in the same way that Windows XP is still used a lot in the enterprise. It’s definitely out there in enough numbers to notice, but the new versions have long since dwarfed it to the point that it’s now less significant than the other frameworks.

Why? Because the software industry at large, and over-all use of JavaScript _across all sectors (including the enterprise)_ is growing so fast that new installs quickly dwarf old installs, even if the legacy apps _never upgrade._

For evidence, just take another look at those download charts. More downloads in 2018 than in the previous years _combined._

#### Job Board Postings

Indeed.com aggregates job postings from a variety of job boards. Every year, _we tally the job postings¹_ mentioning each framework to give you a better idea of what people are hiring for. Here’s what it looks like this year:

![](https://cdn-images-1.medium.com/max/800/1*GkJY82i3ryEZW1akwUSQoA.png)

Dec 2018 Job Board Postings Per Framework

*   React: 24,640
*   Angular: 19,032
*   jQuery: 14,272
*   Vue: 2,816
*   Ember (not pictured): 2,397

Again, a lot more total jobs this year than the previous year. I dropped Ember because it’s clearly not growing at the rate that everything else is. I wouldn’t recommend learning it to prepare for a future job placement. jQuery and Ember jobs didn’t change much, but everything else grew a lot.

Thankfully, the number of new people joining the software engineering field has grown a lot as well in 2018, but we need to continue to hire and train junior developers (meaning we need [qualified senior developers to mentor them](https://devanywhere.io)), or we won’t keep pace with the explosive job growth. For comparison, here’s last year’s chart:

![](https://cdn-images-1.medium.com/max/800/1*zO-KgLZ5kDbv2sug6js9ug.png)

Average salary climbed again in 2018, from $110k/year to $111k/year. Anecdotally, the salary listings are lagging new hire expectations, and hiring managers will struggle to hire and retain developers if they don’t adjust for the developer’s market and offer larger pay increases. Retention and poaching continues to be a huge problem in 2018 as employees jump ship for higher paying jobs, elsewhere.

1.  **_Methodology:_** _Job searches were conducted on Indeed.com. To weed out false positives, I paired searches with the keyword “software” to strengthen the chance of relevance, and then multiplied by ~1.5 (roughly the difference between programming job listings that use the word “software” and those that don’t.) All SERPS were sorted by date and spot checked for relevance. The resulting figures aren’t 100% accurate, but they’re good enough for the relative approximations used in this article._

### JavaScript Fundamentals

I say it every year: Focus on the fundamentals. This year you’re getting some extra help. All software development is composition: The act of breaking down complex problems into smaller problems, and composing solutions to those smaller problems to form your application.

But when I ask JavaScript interviewees the most fundamental questions in software engineering, “what is function composition?” and “what is object composition?” they almost invariably can’t answer the questions, even though they do them every day.

I have long thought this was a very serious problem that needs to be addressed, so I wrote a book on the topic: [**“Composing Software”**](https://leanpub.com/composingsoftware).

> If you learn nothing else in 2019, learn how to compose software well.

#### On TypeScript

TypeScript continued to grow in 2018, and it continues to be overrated because [type safety does not appear to be a real thing](https://medium.com/javascript-scene/the-shocking-secret-about-static-types-514d39bf30a3) (does not appear to reduce production bug density by much), and [type inference](https://medium.com/javascript-scene/you-might-not-need-typescript-or-static-types-aa7cb670a77b) in JavaScript without TypeScript’s help is really quite good. You can even use the TypeScript engine to get type inference in normal JavaScript using Visual Studio Code. Or install the Tern.js plugins for your favorite editor.

TypeScript continues to fall flat on its face for most higher order functions. Maybe I just don’t know how to use it correctly (after years living with it on a regular basis — in which case, they really need to improve usability, documentation, or both), but I still don’t know how to properly type the map operation in TypeScript, and it seems to be oblivious to anything going on in a [transducer](https://medium.com/javascript-scene/transducers-efficient-data-processing-pipelines-in-javascript-7985330fe73d). It fails to catch errors, and frequently complains about errors that aren’t really errors at all.

It just isn’t flexible or full featured enough to support how I think about software. But I’m still holding out hope that one day it will add the features we need, because as much as its shortcomings frustrate me while trying to use it for real projects, I also love the potential of being able to properly (and selectively) type things when it’s really useful.

My current rating: Very cool in very select, restricted use-cases, but overrated, clumsy, and very low ROI for large production apps. Which is ironic, because TypeScript bills itself as “JavaScript that scales”. Perhaps they should add a word: “JavaScript that scales awkwardly.”

What we need for JavaScript is a type system modeled more after Haskell’s, and less after Java’s.

#### Other JavaScript Tech to Learn

*   [GraphQL](https://graphql.org/) to query services
*   [Redux](https://redux.js.org/) to manage app state
*   [redux-saga](https://github.com/redux-saga/redux-saga) to isolate side-effects
*   [react-feature-toggles](https://github.com/paralleldrive/react-feature-toggles) to ease continuous delivery and testing
*   [RITEway](https://github.com/ericelliott/riteway) for beautifully readable unit tests

### The Rise of the Crypto Industry

Last year I predicted that blockchain and fin-tech would be big technologies to watch in 2018. That prediction was spot on. One of the major themes of 2017–2018 was the rise of crypto and building the foundations of **the internet of value.** Remember that phrase. You’re going to hear it a lot, soon.

If you’re like me and you’ve been following decentralized apps since the P2P explosion, this has been a long time coming. Now that Bitcoin lit the fuse and showed how decentralized apps can be self-sustaining using cryptocurrencies, the explosion is unstoppable.

Bitcoin has grown several orders of magnitude in just a few years. You may have heard that 2018 was a “crypto winter”, and got the idea that the crypto industry is in some sort of trouble. That’s complete nonsense. What really happened was at the end of 2017, Bitcoin hit another 10x multiple in an epic exponential growth curve, and the market pulled back a bit, which happens every time the Bitcoin market cap grows another 10x.

![](https://cdn-images-1.medium.com/max/800/1*2nlit12SUIYN93RdmBNoHQ.png)

Bitcoin 10x Inflection Points

In this chart, each arrow starts at another 10x point, and points to the low point on the price correction.

Fundraising for crypto ICOs (Initial Coin Offerings) peaked in early 2018, and the 2017–2018 funding bubble brought a rush of new job openings into the ecosystem, peaking at over 10k open jobs in January 2018. It has since settled back to about 2,400 (according to Indeed.com), but we’re still very early and this party is just getting started.

![](https://cdn-images-1.medium.com/max/800/1*FUZjNmtKuVNSAK-DnoGtoQ.png)

There is a lot more to say about the burgeoning crypto industry, but that’s a whole other blog post. If you’re interested, read [“Blockchain Platforms and Tech to Watch in 2019”](https://medium.com/the-challenge/blockchain-platforms-tech-to-watch-in-2019-f2bfefc5c23).

#### Other Tech to Watch

As predicted last year, these technologies continued to explode in 2018:

**AI/Machine Learning** is in full swing with 30k open jobs at the close of 2018, deep fakes, incredible generative art, amazing video editing capabilities from the research teams at companies like Adobe — there has never been a more exciting time to explore AI.

**Progressive Web Applications** are quickly just becoming how modern web apps are properly built — added features and support from Google, Apple, Microsoft, Amazon, etc. It’s incredible how quickly I’m taking the PWAs on my phone for granted. For example, I don’t have the Twitter Android app installed on my phone anymore. I exclusively use [the Twitter PWA instead](https://mobile.twitter.com/home).

**AR** (Augmented Reality) **VR** (Virtual Reality) **MR** (Mixed Reality) all got together and joined forces like Voltron to become **XR** (eXtended Realty). The future of full-time XR immersion is coming. I’m predicting within 5–10 years for mass adoption of consumer XR glasses. Contact lenses within 20. Thousands of new jobs opened up in 2018, and this industry will continue to explode in 2019.

- YouTube 视频链接：https://youtu.be/JaiLJSyKQHk

**Robotics, Drones, and Autonomous Vehicles** Autonomous flying drones are already here, autonomous robots continue to improve, and more autonomous vehicles are sharing the road with us at the end of 2018. These technologies will continue to grow and reshape the world around us through 2019 and into the next 20 years.

**Quantum Computing** progressed admirably in 2018, as predicted, and as predicted, it did not go mainstream, yet. In fact, my prediction, “it may be 2019 or later before the disruption really starts” was likely very optimistic.

Researchers in the crypto space have paid extra attention to quantum-safe encryption algorithms (quantum computing will invalidate lots of today’s assumptions about what is expensive to compute, and crypto relies on things being expensive to compute), but in spite of a constant flood of interesting research progress in 2018, a recent report [puts things into perspective](https://www.theregister.co.uk/2018/12/06/quantum_computing_slow/):

> “Quantum computing has been on Gartner’s hype list 11 times between 2000 and 2017, each time listed in the earliest stage of the hype cycle and each time said to be more than a decade away.”

This reminds me of early AI efforts, which began to heat up in the 1950’s, had limited but interesting success in the 1980’s and 1990’s, but only just started getting really mind-blowing circa 2010.

* * *

> We’re BUIDLing the future of celebrity digital collectables: [cryptobling](https://docs.google.com/forms/d/e/1FAIpQLScrRX9bHdIYbQFI5L3hEgwQaDEdjo8t8glqlyObZexWjssxNQ/viewform).

* * *

**_Eric Elliott_ 是 [“编写 JavaScript 应用”](http://pjabook.com)（O’Reilly）以及[“跟着 Eric Elliott 学 Javascript”](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 *Adobe Systems*、*Zumba Fitness*、*The Wall Street Journal*、*ESPN* 和 *BBC* 等，也是很多机构的顶级艺术家，包括但不限于 *Usher*、*Frank Ocean* 以及 *Metallica*。**

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

感谢 [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
