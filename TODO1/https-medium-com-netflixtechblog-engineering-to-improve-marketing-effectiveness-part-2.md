> * 原文地址：[Engineering to Improve Marketing Effectiveness (Part 2) — Scaling Ad Creation and Management](https://medium.com/netflix-techblog/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2-7dd933974f5e)
> * 原文作者：[Netflix Technology Blog](https://medium.com/@NetflixTechBlog?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2.md)
> * 译者：
> * 校对者：

# Engineering to Improve Marketing Effectiveness (Part 2) — Scaling Ad Creation and Management

by [Ravi Srinivas Ranganathan](https://www.linkedin.com/in/rravisrinivas), [Gopal Krishnan](https://www.linkedin.com/in/gopal-krishnan-9057a7/)

> In the [first part](https://medium.com/netflix-techblog/engineering-to-improve-marketing-effectiveness-part-1-a6dd5d02bab7) of this series of blogs, we described our philosophy, motivations, and approach to blending ad technology into our marketing. In addition, we laid out some of the engineering undertakings to solve creative development and localization at scale.

> In this Part-2, we describe the process of scaling advertising at Netflix through ad assembly and personalization on the various ad platforms that we advertise in.

### The Problem Surface

Our world-class marketing team has the unique task of showcasing our growing slate of Original Movies and TV Shows, and the unique stories behind every one of them. Their job is not just about promoting awareness of the content we produce, but an even harder one — of tailoring the right content, with the right message to qualified non-members (acquisition marketing) and members — collectively, billions of users who are reached by our online advertising. These ads will have to reach users on the internet on a variety of websites and publishers, on Facebook, Youtube and other ad platforms.

Imagine if you had to launch the digital marketing campaign for the next big blockbuster movie or must-watch TV show. You will need to create ads for a variety of creative concepts, A/B tests, ad formats and localizations, then QC (quality control) all of them for technical and content errors. Having taken those variations into consideration, you’ll need to traffic them to the respective platforms that those ads are going to be delivered from. Now, imagine launching multiples titles daily while still ensuring that every single one of these ads reaches the exact person that they are meant to speak to. Finally, you need to continue to manage your portfolio of ads after the campaign launches in order to ensure that they are kept up to date (for eg. music licensing rights and expirations) and continue to support phases that roll in post-launch.

There are three broad areas that the problem can be broken down into :

*  **Ad Assembly**: A scalable way of producing ads and building workflow automation
*  **Creative QC**: Set of tools and services that make it possible to easily QC thousands of ad units for functional and semantic correctness
*  **Ad Catalog Management**: Capabilities that make it possible for managing scale campaigns easily — ML based automation

### What is Ad Assembly?

Overall, if you looked at the problem from a purely analytical perspective, we need to find a way to efficiently automate and manage the scale resulting from textbook combinatorial explosion.

**Total Ad Cardinality ≈**

_Titles in Catalog_ **x** _Ad Platforms_ **x** _Concepts_ **x** _Formats_ **x** _A/B Tests_ **x** _Localizations_

Our approach of handling the combinatorics to catch it at the head and to create marketing platforms where our ad operations, the primary users of our product, can concisely express the gamut of variations with the least amount of redundant information.

![](https://cdn-images-1.medium.com/max/800/1*TWbovfnsSqMJG66KYDQp6w.gif)

**CREATIVE VARIATIONS IN VIDEO BASED SOCIAL ADS**

Consider the ads below, which differ along a number of different dimensions that are highlighted.

![](https://cdn-images-1.medium.com/max/800/0*NQ9dYbl6USSMRXhc)

**CREATIVE VARIATIONS IN DISPLAY ADS**

If you were to simply vary just the unique localizations for this ad for all the markets that we advertise in, that would result in ~30 variations. In a world with static ad creation, that means that 30 unique ad files will be produced by marketing and then trafficked. In addition to the higher effort, any change that needs to address all the units would then have to be introduced into each of them separately and then QC-ed all over again. Even a minor modification in just a single creative expression, such as an asset change, would involve making modifications within the ad unit. Each variation would then need to go through the rest of the flow involving, QC and a creative update / re-trafficking.

Our solve for the above was to build a dynamic ad creation and configuration platform — our ad production partners build a single **_dynamic_** unit and then the associated data configuration is used to modify the behavior of the ad units contextually. Secondly, by providing tools where marketers have to express just the variations and automatically inherit what doesn’t change, we significantly reduce the surface area of data that needs to be defined and managed.

If you look at the localized versions below, they reused the same fundamental building blocks but got expressed as different creatives based on nothing but configuration.

![](https://cdn-images-1.medium.com/max/600/0*DqNQBG1sW7cEvPYf)

**EASY CONFIGURATION OF LOCALIZATIONS**

This makes it possible to go from 1 => 30 localizations in a matter of minutes instead of hours or even days for every single ad unit!

We are also able to make the process more seamless by building integrations with a number of useful services to speed up the ad assembly process. For example, we have integrated features like support for maturity ratings, transcoding and compressing video assets or pulling in artwork from our product catalog. Taken together, these conveniences dramatically decrease the level of time effort needed to run campaigns with extremely large footprints.

### Creative QC

One major aspect of quality control to ensure that the ad is going to render correctly and free from any technical or visual errors — we call this “functional QC”. Given the breadth of differences amongst various ad types and the kinds of possible issues, here are some of the top-line approaches that we have pursued to improve the state of creative QC.

First, we have tools that plug in sensible values throughout the ad assembly process and reduce the likelihood of errors.

Then, we minimize the total volume of QC issues encountered by adding validations and correctness checks throughout the ad assembly process. For eg. we surface a warning when character limits on Facebook video ads are exceeded.

![](https://cdn-images-1.medium.com/max/800/0*e-_QuY5UR1T24BMR)

**WARNINGS DURING AD ASSEMBLY**

Secondly, we run suites of automated tests that help identify if there are any technical issues that are present in the ad unit that may negatively impact either the functionality or cause negative side-effects to the user-experience.

![](https://cdn-images-1.medium.com/max/800/0*htbGIBapUv-gh_S1)

**SAMPLE AUTOMATED SCAN FROM A DISPLAY AD**

Most recently, we’ve started leveraging machine vision to handle some QC tasks. For eg. depending on where an ad needs to be delivered, there might have to be the need to add specific rating images. To verify that the right rating image was applied in the video creation process, we now use an image detection algorithm developed by our Cloud Media Systems team. As the volume of AV centric creatives continues to scale and increase over time, we will be adding more such solutions to our overall workflow.

![](https://cdn-images-1.medium.com/max/600/0*OF25W7mXzgtEoFj5)

**SAMPLE RATING IMAGE QC-ED WITH COMPUTER VISION**

In addition to the functional correctness, we also care a whole lot about semantic QC — i.e for our marketing users to determine if the ads are being true to their creative goals and representing the tone and voice of the content and of the Netflix brand accurately.

One of the core tenets around which our ad platform is built is immediate updates with live renderings across the board. This, coupled with the fact that our users can identify and make pinpointed updates with broad implications easily, allows them to fix issues as fast as they can find them. Our users are also able to collaborate on creative feedback, reviews much more efficiently by sharing **_tearsheets_** as needed. A tearsheet is a preview of the final ad after it has been locked and is used to get final clearance ahead of launch.

Given how important this process is to the overall health and success of our advertising campaigns, we’re investing heavily on QC automation infrastructure. We’re also actively working on enabling sophisticated task management, status tracking and notification workflows that help us scale to even higher orders of magnitude in a sustainable way.

### Ad Catalog Management

Once the ads are prepared, instead of directly trafficking them as such, we decouple the ad creation, assembly from ad trafficking with a “catalog” layer.

A catalog picks the sets of ads to run with based on the intent of the campaign — Is it meant for building title awareness or for acquisition marketing? Are we running a campaign for a single movie or show or does it highlight multiple titles or is it a brand-centric asset? Is this a pre-launch campaign or a post-launch campaign?

Once a definition is assigned by the user, an automated catalog handles the following concerns amongst other things :

*  Uses aggregate first party data and machine-learnt models, user configuration, ad performance data etc. to manage the creatives it delivers
*  Automatically makes requests for production of ads that are needed but not available already
*  Reacts to changing asset availability, recommendation data, blacklisting etc.
*  Simplifies user workflows — management of pre-launch and post-launch phases of the campaign, scheduling content refreshes etc.
*  Collects metrics and track asset usage and efficiency

The catalog is hence a very powerful tool as it optimizes itself and hence the campaign it’s supporting — in effect, it turns our first party data into an “intelligence-layer”.

### Personalization and A/B Tests

All of this can add to a sum greater than its parts — for eg. using this technology, we can now run a **_Global Scale Vehicle_** — an always-on / evergreen, auto-optimizing campaigns powered by content performance data and ad performance data. Along with automatic budget allocation algorithms (we’ll discuss it in the next blog post in this series), this tames the operational complexity very effectively. As a result, our marketing users get to focus to building amazing creatives and formulating A/B tests and market plans on their end, and our automated catalogs help to deliver the right creative to the right place in a hands off fashion — automating the ad selection and personalization.

In order to understand why this is a game changer, let’s reflect on the previous approach — every title that needed to be launched had to involve planning on budgeting, targeting, which regions to support any title in, how long to run and to what spend levels, etc.

This was a phenomenally hard task in the face of our ever increasing content library, breadth and nuances of marketing to nearly all countries of the world and the number of platforms and formats needing support to reach our addressable audience. Secondly, it was challenging to react fast enough to unexpected variations in creative performance all while also focusing on upcoming campaigns and launches.

![](https://cdn-images-1.medium.com/max/800/1*TuPBPYY83i85z6vYN7lTsQ.png)

In true, Netflix fashion, we arrived at this model through a series of A/B tests — originally, we ran several tests learning that an always-on ad catalog with personalized delivery outperformed our previous tentpole launch approach. We then ran many more follow-ups to determine how to do it well on different platforms. As one would imagine, this is fundamentally a process of continuous learning and we’re pleasantly surprised to find huge, successive improvements on our optimization metrics as we’ve continued to run growing number of marketing A/B tests around the world.

### Service Architecture

We enable this technology using a number of Java and Groovy based microservices that tap into various NoSQL stores such as Cassandra and Elasticsearch and use Kafka, Hermes to glue the different parts by either transporting data or triggering events that result in [dockerized micro-applications](https://medium.com/netflix-techblog/the-evolution-of-container-usage-at-netflix-3abfc096781b) getting invoked on [Titus](https://medium.com/netflix-techblog/titus-the-netflix-container-management-platform-is-now-open-source-f868c9fb5436).

![](https://cdn-images-1.medium.com/max/800/1*6_BrSaP_JSBsJPZP0RPGzA.png)

![](https://cdn-images-1.medium.com/max/600/1*H6bB68gFOfg3mjQ672j5xQ.png)

We use [RxJava](https://github.com/ReactiveX/RxJava) fairly heavily and the ad server which handles real-time requests for servicing display and VAST videos uses RxNetty as it’s application framework and it offers customizability while bringing minimal features and associated overheads. For the ads middle tier application server, we use a Tomcat / Jersey / Guice powered service as it offers way more features and easy integrations for it’s concerns such as easy authentication and authorization, out-of-the-box support for Netflix’s cloud ecosystem as we lack of strict latency and throughput constraints.

### Future

Although we’ve had the opportunity to build a lot of technology in the last few years, the practical reality is that our work is far from done.

We’ve had a high degree of progress on some ad platforms, we’re barely getting started on others and there’s some we aren’t even ready to think of, just yet. On some, we’ve hit the entirety of ad creation, assembly and management and QC, on others, we’ve not even scratched the full surface of just plain assembly.

Automation and machine learning have gotten us pretty far — but our organizational appetite for doing more and doing better is far outpacing the speed with which can build these systems. With every A/B test having us think of more avenues of exploration and in using data to power analysis and prediction in various aspects of our ad workflows, we’ve got a lot of interesting challenges to look forward to.

### Closing

In summary, we’ve discussed how we build unique ad technology that helps us add both scale and add intelligence into advertising efforts. Some of the details themselves are worth follow-up posts on and we’ll be publishing them in the future.

To further our marketing technology journey, we’ll have the next blog shortly that moves the story forward towards how we support marketing analytics from a variety of platforms and make it possible to compare proverbial apples and oranges and use it to optimize campaign spend.

If you’re interested in joining us in working on some of these opportunities within Netflix’s Marketing Tech, [**we’re hiring**](https://sites.google.com/netflix.com/adtechjobs/ad-tech-engineering)**!** :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
