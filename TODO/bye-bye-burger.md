> * 原文地址：[Bye, Bye Burger! What we learned from implementing the new Android Bottom Navigation](https://medium.com/startup-grind/bye-bye-burger-5bd963806015#.b1x3w6elg)
* 原文作者：[Sebastian Lindemann](https://medium.com/@S_Lindemann)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Bye, Bye Burger! What we learned from implementing the new Android Bottom Navigation
I exactly remember what I was doing when the news broke on March 15 — we were knee deep in the concept phase for moving towards a visible tab navigation and away from a burger menu in our [Android Job Search App](https://play.google.com/store/apps/details?id=com.xing.mpr.cep&hl=de), when Google announced that a new bottom navigation will be added to the Android Material Design Guidelines. The news spread like wildfire through the Android community, including heated [debates](https://plus.google.com/+LukeWroblewski/posts/ZgNUpC72FVt) on the bottom bar’s visual appeal and functionality.



![](https://cdn-images-1.medium.com/max/600/1*DEsoBD74AHj4Z6U4zdnSpA.png)

The Android Bottom Navigation. Source: [Material Design Guidelines](https://material.google.com/components/bottom-navigation.html#bottom-navigation-specs)



Like others, our enthusiasm was curbed at first. The thought of throwing away weeks of hard work for the new and unproven navigation that Google dropped in front of us felt intimidating. Still, we decided to pick up the ball and released a new version of our Android app recently, being one of the first to utilize the new navigation. Our journey brought along several insights and remarkable results which I want to share.

Navigations and menus on mobile have always been a hot topic, especially since the introduction of the [hamburger menu](https://blog.placeit.net/history-of-the-hamburger-icon/) and the simultaneous rise of the smartphone as the leading information consumption device. The three-lined menu became the default navigation element in many major apps (e.g. Facebook, Spotify and Youtube) before quickly falling from grace due to its integral characteristic of hiding relevant destinations from the user’s eye. For iOS apps a new kind of visible navigation established with the [bottom tab bar](https://developer.apple.com/ios/human-interface-guidelines/ui-bars/tab-bars/), which quickly became the standard way for implementing a visible top-level navigation on Apple smartphones.

Unfortunately, Android apps were missing a proper solution for a bottom navigation, leaving apps, such as ours, with a burger menu. To still make navigations visible without breaking the Material Design Guidelines (too much) app developers started using [tabs](https://material.google.com/components/tabs.html) at the top of the screen. While tabs work for simple apps, space problems occur when a second level of navigation needs to be added or there are more than 3 destinations. Considering mobile devices’ [“Thumb Zones”](http://blog.experts-exchange.com/ee-blog/smartphone-thumb-zone/) the top area can also be seen as ergonomically challenging to smartphone users especially compared to a navigation at the bottom.

With the introduction of the Material Design bottom navigation, Google recognized the challenges app developers were having, providing a way to get the top-level navigation out of the burger into users sight… which we gladly took advantage of.

After making the decision to go with the bottom navigation, we entered one of the most challenging parts on our journey — the design phase. Wandering through the muddy waters of specifications and animations we had to make some important UX & product decisions:



![](https://cdn-images-1.medium.com/max/600/1*2HlX9ZSSHnQ5llC_o8dOOA.gif)

Our bottom navigation at work



*   **Hiding on scroll:** We wanted to provide as much content as possible on our user’s screens. Consequently, we decided to make the navigation hide on scroll, thus making more room for the content area. Scrolling up makes the navigation fade back in.
*   **Shifting navigation :** The Material Design bottom bar comes with a very slick animation, which is referred to as the Shifting navigation — when navigating between destinations the selected section icon is enlarged, moving the unselected element to the back. Flipping through destinations on the nav bar thus feels a bit like browsing through a carousel. We decided to utilize this effect as it adds a playful note to switching sections, which we hoped would nudge our users into navigating to different areas in the app more often. Further, the animation plays a major part in our next point…



![](https://cdn-images-1.medium.com/max/600/1*uMnDyq7fTZ3KDu2BteuIxw.gif)

Android’s Shifting Navigation. Source: [Material Design Guidelines](https://material.google.com/components/bottom-navigation.html#bottom-navigation-specs)



*   **Material Design look & feel:** We wanted the bottom navigation to feel as organic and native to the Android environment as possible. This meant doubling down on animation and visual design. Only by doing so we would be able to achieve a high acceptance with our Android user base — the last thing we wanted was users wondering if they are using a cheap clone of an iOS app when interacting with the navigation.
*   **Saving state:** With a bottom bar the app needs to remember what a user did in a section, making the behavior very different to a burger menu. As the purpose of the visible section arrangement is to allow a fast and frequent switching between them, the click path in a section needs to be stored so that a user can go back to a task easily. In contrast, for apps with a burger navigation, the state is not stored and it’s a fresh start on the first view hierarchy level whenever a user comes back to a section. Depending on your application’s infrastructure, saving the state in a section can be a major technical challenge and I suggest talking with your development team about this early.
*   **Compact number of sections:** We had the benefit of only having to switch a manageable number of sections from the burger menu to the bottom bar, which allowed us to go fast in the design and development phase. We still put a strong focus on making sure that only the most important destinations were presented to the user. This lead us to moving the settings section into an overflow menu on the top right instead of placing it next to important features such as search, bookmarks and recommendations. I recommend being as rigorous as possible when deciding about which functionality to place in the navigation. If you have an app with a lot of sections, a bottom bar will be a lot harder to implement and you might need to consider combining or rearranging things — something we luckily did not have to do.
*   **Keeping it lean:** While it is important to know the full scope of where you want to go with your new navigation, it is equally important to not get lost in the details before verifying that the core concept works. Because of this the MVP of our bottom navigation did not include a lot of bells & whistles. While we would add those additions at a later point eventually, we first wanted to know if we were on the right track. We even went as far as releasing a first version of the new navigation without the ability to save the user’s state (see point above) to a small amount of users and only tackled subsequent tasks after we saw positive indications on our metrics with our testing cohort.

_Note that while Google’s_ [_Material Design Guidelines_](https://material.google.com/components/bottom-navigation.html) _might offer a thorough definition on how to use the new navigation there are still some important decisions to make yourself depending on your goals and how your product works._

We carefully rolled out the new navigation to our users using [Google Play’s staged rollout](https://support.google.com/googleplay/android-developer/answer/6346149?hl=en) functionality to make sure that the changes had the desired effect — fortunately, we quickly saw that they did:

*   **Increasing user engagement:** Our users are more active, creating more pageviews than before (double digit growth in PVs/Monthly Active User). Further, our users come back more often, allowing the conclusion that the new navigation resonates with them, thus improving retention (near double digit growth in Visits/Monthly Active User).
*   **Increasing visits into app sections:** Important app destinations, like bookmarks and job recommendations are now visible in the bottom nav and are seeing a strong increase in usage (double to tripple digit growth in users who enter the section). This uptick helps us in presenting our unique assets to our users thus also helping to improve the overall product experience.
*   **No negative user feedback:** So far, neither through direct user feedback nor through app reviews, have we received complaints about the new navigation, underlining the positive adoption which can already be seen in the figures mentioned before.



![](https://cdn-images-1.medium.com/max/800/1*NArH9VWRmCHAd67OYR1hrw.png)

Burger vs No Burger: A side-by-side comparison of our app before and after the navigation change



Taking the leap of faith with the new Android bottom navigation paid off and we succeeded in our goal of improving our app experience and KPI performance. I would thus strongly advice exploring the opportunity of switching to a visible navigation, if your app is still relying on a burger navigation. Though, before doubling down on development it is important to establish a thorough understanding of the required design changes first to have a good understanding of the scope of work.

You can check out the newest version of our app [here](https://play.google.com/store/apps/details?id=com.xing.mpr.cep&hl=de) with some further design tweaks coming to the bottom navigation soon. The app is targeted at the German job market so it might not have a full list of jobs for where you are. I am very happy about any questions and thoughts you might have and do look forward to your comments and DMs.

Last but not least, I want to say THANKS! to our amazing team of designers and developers (like [Dema](https://twitter.com/demito29), [Miguel](https://twitter.com/miguel_eedl) and [Cristian](https://twitter.com/cmonfortep)) who made crafting and implementing the new navigation a joyful and exciting journey.





[![](https://cdn-images-1.medium.com/max/400/1*Mro-phkgJv4rZQ223OYosA.jpeg)](http://eepurl.com/bBbrFX)





[![](https://cdn-images-1.medium.com/max/400/1*kHlMuCZPyf0mQQWAuaR7HQ.jpeg)](http://facebook.com/startupgrind)





[![](https://cdn-images-1.medium.com/max/400/1*B3UHAfn5Xm2QNIPW1sYJHA.jpeg)](https://twitter.com/startupgrind)



