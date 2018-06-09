> * 原文地址：[Introduction to accessibility for Android apps and games](https://medium.com/googleplaydev/introduction-to-accessibility-for-android-apps-and-games-d0e7af5384d)
> * 原文作者：[Maxim Mai](https://medium.com/@maximfmai?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-accessibility-for-android-apps-and-games.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-accessibility-for-android-apps-and-games.md)
> * 译者：
> * 校对者：

# Introduction to accessibility for Android apps and games

## How you can tailor app or game design to improve the experience for everyone

![](https://cdn-images-1.medium.com/max/800/0*C2kWfqX8bsbps-ME.)

While we aim to design and create apps that cater to a broad audience, we should not forget that there are people who use Android and Google Play who may have some form of disability. The [World Health Organization](http://www.who.int/disabilities/world_report/2011/report/en/) estimated that 15% of the world’s population, roughly one billion people, experience some form of disability affecting hearing, visual, cognitive, and motor functions. This can impact the way these users interact with technology, and it’s important to us at Google Play and Android that everyone feels welcome and comfortable using their favorite apps and games.

We often think of disabilities as being permanent or a continued deterioration of ability, but there are often cases of situational or temporary accessibility needs that affect everyone. Having only one hand available while holding a baby, recovering from a surgery, or simply riding a bike, all represent situational accessibility needs that may be improved and accommodated by using good design.

At Android and Google Play, we are committed to providing developers with tools, guidance, and support in order to promote inclusive experiences for as many people as possible. We also recently curated a [collection of accessibility-related apps](https://www.google.com/url?q=http://play.google.com/store/apps/topic?id%3Dcampaign_editorial_300324a_accessapps18&sa=D&source=hangouts&ust=1526630727446000&usg=AFQjCNFT86-9N1DrImf9arznkRQ-QdarXA) on the Play Store. Check out these awesome apps as we are proud to have them on Android and Google Play!

Some Android developers have also taken the accessibility experience to a new level, specifically addressing needs arising from disabilities. Let’s take a deeper look to see what we can learn from their apps and games.

### Easy steps to make your app and game more accessible

Whether you are building apps specifically with accessibility use cases in mind, or whether you are working on making your app or game more inclusive for people with disabilities, we are here to support you.

We have created a resource to [accessibility](https://developer.android.com/guide/topics/ui/accessibility/) for Android developers, where you’ll find an easy to follow introduction to the topic, alongside links to [using material design to support accessibility needs](https://material.io/guidelines/usability/accessibility.html), and best practices for [developing more accessible apps](https://developer.android.com/guide/topics/ui/accessibility/apps).

You can ensure your app **labels UI elements properly** to make it easier for people who use screen readers, such as TalkBack, to hear the content clearly. Similarly, you may consider thinking through your content grouping on screen so that those with vision impairments can navigate your app quickly and efficiently.

Some people may have difficulties interacting with small touch controls, so keep that in mind by providing **larger touch targets**. This may make it much easier for many people to navigate your app. Color and contrast are two more areas that may impact large sections of your audience. **Avoiding low contrast ratios** between foreground and background colors is a another best practice, as well as ensuring that UI elements are clearly distinguishable for people with colorblindness.

Adding video and audio content or instructions can ensure people with a hearing impairment can access your app. Consider providing the option to **toggle subtitles,** and if instructions are given via videos think about making those same instructions available in an alternative format.

These are examples of easy steps you can follow to make your app more inclusive, however they are in no way meant to serve as an exhaustive checklist. We will follow-up with a deep-dive post later this summer to provide more tips on accessible design and development.

### Three apps that focus on accessibility

These apps and games improve the opportunity for people with disabilities to access and utilize mobile technology in their everyday lives.

[**Be My Eyes**](https://play.google.com/store/apps/details?id=com.bemyeyes.bemyeyes)

How often would you help a stranger in need? The team behind Be My Eyes is harnessing the global scale of Android to tap into the power of human generosity and our sense of community with the goal of empowering blind and low vision people to lead more independent lives.

At no cost to either side, the app matches blind or low vision users to sighted volunteers via a video call who can provide assistance such as helping with orientation in new surroundings, reading labels or controls, distinguishing colours, and many more tasks.

![](https://cdn-images-1.medium.com/max/800/0*ZWrIIDxpH76qNmfL.)

Vision impaired user ready to call to a sighted volunteer

As a large majority of the over [253 million people](http://www.who.int/en/news-room/fact-sheets/detail/blindness-and-visual-impairment) with vision impairments live in low and medium income countries, it is important to add more local languages to the app and improve the quality of translations. You can also help by [getting involved in the translation project](https://crowdin.com/project/be-my-eyes-android).

[**Open Sesame**](https://play.google.com/store/apps/details?id=com.sesame.phone_nougat)

Touchscreens have revolutionised phones because they offer intuitive navigation on a handheld device. However, for the millions of people with severe dexterity impairments resulting from spinal cord injuries, Multiple Sclerosis, ALS and neurodegenerative diseases, a different interaction model may be needed.

Combining advanced computer-vision technologies and voice control, Open Sesame allows anyone with controlled movement of their head complete hands free access to an Android phone or tablet. The app achieves this by registering an [Android accessibility service](https://developer.android.com/guide/topics/ui/accessibility/services.html) so that people can control the entire operating system, download apps via the Play Store, and play any game and control connected home devices and services.

![](https://cdn-images-1.medium.com/max/800/0*xPVd0S0KMl_mN3Cn.)

Motor impaired user controlling an Android phone with head movements

A number of US states offer subsidies to put the magic of Open Sesame within reach of more people who are eligible. The Sesame Enable team is working hard to increase the number of these programs and are happy to [guide new users](https://sesame-enable.com/get-help-with-state-benefits/) through the subsidy process.

[**Audio Game Hub 2.0**](https://play.google.com/store/apps/details?id=com.AUT.AudioGameHub)

The team at Sonar Interactive, based in Auckland, New Zealand, specialises in using voices, sounds, and music to create games for both sighted and non-sighted users. The idea is to bring the fun and sense of community of video games to those with vision impairments around the world.

Audio Game Hub is a collection of eleven standalone games including Bomb Disarmer, Archery, Samurai Tournament, and Hunt. Many can be played by multiple players on the same device to enable collaborative and competitive experiences, involving sighted and vision impaired friends.

![](https://cdn-images-1.medium.com/max/800/1*2lC2yhviSS9fjtcju9TVHA.png)

A game of Archery is in progress, aiming is guided by sound

The team continues to innovate in the gaming space. Checkout Animal Escape, the latest addition to Audio Game Hub, launched today and available on the Play Store.

### A useful developer tool to test the accessibility of your apps and games

Testing your app for accessibility is a key component of your development process. We have published a [getting started guide](https://developer.android.com/training/accessibility/testing#top_of_page) that highlights the importance of combining manual, user, and automated testing to find usability issues that you might otherwise miss.

The [Google Accessibility Scanner](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor) uses the [Accessibility Testing Framework](https://github.com/google/Accessibility-Test-Framework-for-Android) and suggests improvements for any Android app installed on your phone without requiring technical skills. It provides actionable suggestions after looking at content labels, clickable items, contrast, and more.

For example, content labels provide useful and descriptive descriptions that explain the meaning and purpose of each interactive element to people. These labels allow screen readers, such as TalkBack, to properly explain the function of a particular control to those who may rely on these services.

![](https://cdn-images-1.medium.com/max/800/1*aAcJvQ75gLoECAO5grbCLA.png)

Accessibility scanner is turned on and ready to analyze any app

While we hope you will use Accessibility Scanner to improve the accessibility of your own app, it also allows you to suggest accessibility improvements to other developers.

We have shared some examples from those who are making big developments in this space and hopefully the tips and links to resources we have provided will help you create a better experience for everyone who wants to use your app or game. Whether you are specifically creating an app for people with a disability or just trying to share your app or game with all those who are interested, these insights hopefully provide some inspiration and a good starting point. As we mentioned above, they are by no means exhaustive, and there are still many more considerations both in development, design, and when initially concepting your app or game that can help to make it more accessible and enjoyable for everyone. Look out for my next article, which will take a deeper look into accessibility development and also remember to check out the [new accessibility collection](https://www.google.com/url?q=http://play.google.com/store/apps/topic?id%3Dcampaign_editorial_300324a_accessapps18&sa=D&source=hangouts&ust=1526630727446000&usg=AFQjCNFT86-9N1DrImf9arznkRQ-QdarXA) on the Play store in the meantime.

* * *

### What do you think?

Do you have thoughts on designing apps for accessibility? Let us know in the comments below or tweet using **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
