> * 原文地址：[Tab Bars are the new Hamburger Menus](https://uxplanet.org/tab-bars-are-the-new-hamburger-menus-9138891e98f4)
> * 原文作者：[Fabian Sebastian](https://uxplanet.org/@fabiansebastian?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tab-bars-are-the-new-hamburger-menus.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tab-bars-are-the-new-hamburger-menus.md)
> * 译者：
> * 校对者：

# Tab Bars are the new Hamburger Menus

In this article we are going to talk about a navigation pattern that got out of hand.

![](https://cdn-images-1.medium.com/max/1000/1*2bmlj_WCGK8nrYXDWXTf5g.jpeg)

Usually, I don’t like to only complain about bad UX design and I don’t like to only point out a problem. Instead, I always try to suggest solutions. This time it’s the other way around: The solution is obvious — it’s tab bars — but the original intent of this solution got lost in recent years, resulting in the same old problems. It’s time to talk about the problems again before we start talking about our solutions. But one step at a time:

* * *

### History Lesson

2014 Apple sparked a fundamental change in thinking on how mobile navigation should work. Until then the “hamburger menu” or “navigation drawer” (official Material Design naming) was the most common mobile navigation solution. During their 2014 WWDC Talk “[Designing Intuitive User Experiences](https://developer.apple.com/videos/play/wwdc2014/211/)” Apple basically crushed this design element and recommended using different types of navigation — like **tab bars**.

![](https://cdn-images-1.medium.com/max/1000/1*dVH3vmhY9UQxSC11437E8g.jpeg)

WWDC Talk “Designing Intuitive User Experiences” (source: [https://developer.apple.com/videos/play/wwdc2014/211/](https://developer.apple.com/videos/play/wwdc2014/211/))

The WWDC talk went viral and UX and UI designers all over the world started talking about the downsides of hamburger menus:

*   **Why and How to Avoid Hamburger Menus**  
    [https://lmjabreu.com/post/why-and-how-to-avoid-hamburger-menus/](https://lmjabreu.com/post/why-and-how-to-avoid-hamburger-menus/)
*   **Alternatives of hamburger menu — UX Planet**  
    [https://uxplanet.org/alternatives-of-hamburger-menu-a8b0459bf994](https://uxplanet.org/alternatives-of-hamburger-menu-a8b0459bf994)
*   **Kill The Hamburger Button — TechCrunch  
    **[https://techcrunch.com/2014/05/24/before-the-hamburger-button-kills-you/?guccounter=1](https://techcrunch.com/2014/05/24/before-the-hamburger-button-kills-you/?guccounter=1)
*   **Hamburger Menus and Hidden Navigation Hurt UX Metrics — NN Group  
    **[https://www.nngroup.com/articles/hamburger-menus/](https://www.nngroup.com/articles/hamburger-menus/)

Since then, hamburger menus started to disappear and the tab bar replaced it as a go-to-solution. 2015 even Google, father of the navigation drawer, started introducing a “bottom navigation” (= iOS “tab bar”) to their own set of Android apps and the Material Design Guidelines. It seemed to be the best solution to meet the goals of an intuitive mobile navigation. Designers started to think about what they are trying to achieve again.

![](https://cdn-images-1.medium.com/max/1000/1*Gycb7q465smTr92XZ_mVdA.png)

Bottom Navigation, Google Material Design Guidelines (source: [https://material.io/design/components/bottom-navigation.html#usage](https://material.io/design/components/bottom-navigation.html#usage))

* * *

### Navigation Goals

A quick recap: A navigation basically has to tell a user three things:

*   **Where am I?**
*   **Where else can I go?**
*   **What will I find when I get there?**

The tab bar fulfils all 3 requirements. It is visible on every screen and therefore always gives you visual orientation. It shows you where in the information architecture you are (active tab highlighting), where you can go (other tabs) and what you will find there (icons and descriptive labels). You can access deeper content (navigate from a parent screen to a child screen) without losing context and your position in the app.

In other words: Tab bars are a perfect mobile navigation solution. At least they were — until designers started using them without thinking about the “why?”. In thinking about the solution before thinking about the actual problem they forgot what tab bars tried to achieve in the first place. Today tab bars are often used in the same way that hamburger menus were used before 2014.

* * *

### The Problem with Tab Bars

Look at the following UI, your beloved Medium iOS app, and try to spot the problem:

![](https://cdn-images-1.medium.com/max/1000/1*16K8VPrRMCI8yQoD_jrNCA.jpeg)

Screenshot: Medium for iOS (article)

As soon as a user navigates from a top-level view to a child-view (eg. article) the child-view overlays the entire screen including the tab bar.

![](https://cdn-images-1.medium.com/max/1000/1*01HSwcT6pcws4fM6luY5aA.png)

Screenshot: Medium for iOS (profile settings)

Now, let’s look at our three navigation goals again:

*   **Where am I?  
    **By hiding the navigation in child-views the user no longer knows which top-level page of the app he/she is in. Users lose the position in your overall information architecture.
*   **Where else can I go?  
    **By hiding other top-level pages users can no longer directly navigate to other areas of the app. Instead they first have to navigate back to the top level of the information architecture.
*   **What will I find when I get there?  
    **The only navigation element in the child screen is a small left-arrow without a label or description. It doesn’t tell a user where he/she will go by clicking it.

Medium might have had the best intentions when they did include a tab navigation. And so did thousands of other iOS and Android apps. It works perfectly on top-level views, but their execution failed to meet every single goal of a navigation in child-views.

The child-view behaves like a **modal-view** by overlaying the overall navigation (tab bar), but it animates like a **child-view** (right to left) and displays a back-link (arrow) like a child-view. Modality isn’t a bad thing at all. “Modality creates focus by preventing people from doing other things until they complete a task or dismiss a message or view” ([Apple](https://developer.apple.com/ios/human-interface-guidelines/app-architecture/modality/)). But modality also requires the usage of modal animations (iOS: animating from the bottom into the screen) and including completion and cancel buttons to exit the modal view. Modal views are only used for short-term tasks that are **self-contained processes** and can be either completed or candled, like writing a mail, adding an event to a calendar, dismissing a notification, … They are not intended to be used as a detail-view or to replace a child-view. Those child views are not a self-contained process and they can neither be canceled nor saved.

One could argue that there are exemptions to this restrictive use of modality, e.g. for **fullscreen detail-views** like a single photo. Hiding the app’s overall UI (like tab bar) creates focus and minimises distraction. In this case, a custom transition is often used to explain the uncommon use of modality. While a Medium article could be considered a fullscreen detail-view that lacks a custom transition and close-functionality the app’s settings-view definitely can’t be.

![](https://cdn-images-1.medium.com/max/800/1*4bXY4-kFshVmA6KfOU1TlA.gif)

custom content-specific transition (source: [https://material.io/design/navigation/navigation-transitions.html#hierarchical-transitions](https://material.io/design/navigation/navigation-transitions.html#hierarchical-transitions))

* * *

### Google’s and Apple’s Take

Only in rare occasions do Apple and Google agree on a topic. This is one of those rare occasions. Both Apple’s and Google’s guidelines encourage designers to use tab bars (bottom navigations) consistently on every screen of the application:

> “When used, the bottom navigation bar appears at the bottom of every screen” —[ Google Material Design](https://material.io/design/components/bottom-navigation.html#usage)

> “Tab bars […] are [only] hidden when a keyboard is displayed” — [Apple Human Interface Guidelines](https://developer.apple.com/ios/human-interface-guidelines/bars/tab-bars/)

Apple is following its self-imposed restrictions very strictly by adding the tab bar to every child-screen of its apps like Apple Music, Photos, Podcasts, Health or Files.

![](https://cdn-images-1.medium.com/max/1000/1*XvyavA7fFYdRFNUXYuVAOw.jpeg)

Tab bars in Google Photos vs Apple Photos

Google on the other hand often breaks its own rules by hiding the bottom navigation on child views. While Youtube (by Google) keeps the bottom navigation visible consistently, Google Photos and Google+ hide it on child views (like albums and groups). The Material Design Guidelines never explicitly require designers to add the bottom navigation to child views, but they require them to add it to “every screen” without specifying the level within the information architecture.

Apple always uses tab bars on a per-app basis, Google often seems to use bottom navigations on a per-screen basis*. By doing so, Google created a child screen that is neither a real child-view (because there is no visible main navigation) nor a modal-view (because it is not a self-contained process with cancel and save buttons)— it’s something in between. And these inbetweenish screens are a growing problem. In theory, Google did introduce a tab bar equivalent, but in practice they just might have introduced the next hamburger menu. Many iOS developers later adapted the “Google-way” of using tab bars. And by doing so they forgot the reason why tab bars did replace hamburger menus in the first place.

*_Edit 28.05.2018: As_ [_Craig Phares_](https://medium.com/@craigphares) _pointed out, this is further supported by the fact that iOS and Android development tools handle the use of tab bars differently. Xcode automatically adds the navigation elements to every View Controller of an application by default. However, as an Android developer a lot of additional time and effort is needed to consistently_ [_keep tabs visible on every new activity_](https://stackoverflow.com/questions/17918198/how-to-keep-tabs-visible-on-every-activity)_. (_[_Read more_](https://medium.com/@craigphares/the-reason-apple-and-google-bottom-tabs-behave-differently-is-due-to-their-respective-authoring-8bac9bd5588d)_)_

* * *

### Verdict

Why is Google using bottom navigations the way they do? And how do they want designers to use these inbetweenish, modalish child-views? I don’t know. I would love to hear Google’s opinion on that! And I would love to hear your opinion on this topic. Until then, these are my recommendations:

*   Draw a clear line between modal-views and child-views and know when to use which
*   Only use **modal-views for self-contained processes** (and fullscreen detail-views in rare occasions)
*   Use child-views for everything else
*   Display the **tab bar / bottom navigation on every view** including child-views
*   Hide navigation bars (at the top of the screen) and tab bars (at the bottom of the screen) when scrolling down if you want to create focus and maximise screen estate (e.g. for articles, …)

Are tab bars the new hamburger menus? In a way they are. If used correctly they both are a powerful navigation element (Yes, there are cases in which hamburger menus [do make sense](https://uxplanet.org/when-to-use-a-hamburger-menu-199d62f764aa)). But once you start using tab bars for the sake of using tab bars (because everybody does), you are losing sight of the most important goals of every navigation. The same thing happened with hamburger menus 4 years ago. So, don’t stop thinking about the “why?”.

### Communication is Key

_Feel free to leave me a message:_ [_www.fabiansebastian.com_](http://www.fabiansebastian.com)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
