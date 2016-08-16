> * 原文地址：[How to design a mobile app across OS platforms?](https://medium.com/@ooceanzou/designers-problem-d7f70d4f4d6c#.8mr6hednc)
* 原文作者：[Ocean Zou](https://medium.com/@ooceanzou)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者： 

### Designers’ Problem

***Android and iOS,***[the two main mobile OS platforms in the market](http://www.idc.com/prodserv/smartphone-os-market-share.jsp), are usually requested to be developed when a company wants to launch a mobile app. For a mobile app to be designed across these two platforms, one of the challenges is to balance the consistency of branding and functionality with the conventions of each platform.

As a digital designer, it is important to understand the idioms and behaviours of each platform so that we can better communicate with the developers and stakeholders before starting the design. That way, your team can discuss about the development plan based on the advantages and disadvantages of adapting each platform (whether to develop iOS first, Android first, or to develop your app on both platforms at the same time).

> Therefore, I want to compare the similarities & differences between Google’s and Apple’s Mobile OS Design Guideline. In addition, I will explore those differences & similarities by studying selected app design on iOS and Android platforms.

By doing so, I hope to better understand the benefits & drawbacks to depot design on each platform and come up with some advice to help designers & developers better decide on their mobile app design & development strategies in the future — whether iOS first, Android first or developing both at the same time.

### Design Guidelines

In this section, I will analyze and study the design guideline from [Apple](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/) and [Google](https://www.google.com/design/spec/material-design/introduction.html), exploring their similarities & differences.

#### Google Design Guideline

[Material Design](https://www.google.com/design/spec/material-design/introduction.html), coming up in 2014 as google’s new approach to cross-product, cross-platform design, is the default visual language for Android 5.0+ devices.

![](http://ac-Myg6wSTV.clouddn.com/5a25fa2885fcbf1a5e08.png)
Figure 1.1 Adaption Rate for Each Version of Android
Based on figure 1.1 from [android developer dashboard site](http://developer.android.com/about/dashboards/index.html) , the adoption rate of material design is only around 24% as of *October 5, 2015* but it has been increased radically since its launched on* November, 2014. Based on the growth of new android devices, *The adoption rate of material design is likely to grow in the future as there are [growing amounts of new android devices](http://www.idc.com/prodserv/smartphone-os-market-share.jsp). Therefore, as Material Design is the latest design framework that Google define for the android device, in this study, I will refer Material design as the design applied in the android system.

![](http://ac-Myg6wSTV.clouddn.com/53102f018f484dde50cf.png)
Figure 1.2 Material Design Main Features
Material design has been well-defined by Google. According to the figure 1.2, there are four aspects you need to pay attention to if you are not familiar with the material design.

**Depth & Surface:** You will find a considered use of elevated surfaces and shadows in Android, which intends to indicate the depth of UI elements.

**Grid and dpi: **Material design strictly adheres to the Density-independent pixels(dp) grid system. According to [google’s definition, ](https://www.google.com/design/spec/layout/units-measurements.html#units-measurements-density-independent-pixels-dp-)dp are flexible units that scale to uniform dimensions on any screen. When developing an Android application, designers use dp to display elements uniformly on screens with different densities. In material design, everything aligns to an 8dp grid, creating a consistent visual rhythm across apps. For example, buttons are often 48dp tall, the [app bar](https://www.google.com/design/spec/layout/structure.html#structure-app-bar) is 56dp tall by default, and spacing between elements is in multiples of 8dp.

**Typography: **[Roboto](https://www.google.com/fonts/specimen/Roboto) is the default font family for Android, and includes a number of weights as well as a [condensed](https://www.google.com/fonts/specimen/Roboto+Condensed) variant. In addition, you can also incorporate your brand’s typographic palette into your app.

**Interaction & Motion: **Material design places a lot of emphasis on user-initiated motion and touch response. According to figure 1.3 below, when you touch an element, in addition to the touch ripples that emanate from your finger, buttons can rise in elevation (essentially, their shadow grows) to “meet” your finger.

![](http://ac-Myg6wSTV.clouddn.com/ef8991f36a50b6877541.gif)
Figure 1.3 Material Design Interaction
![](http://ac-Myg6wSTV.clouddn.com/1b40487c14c76b73a321.png)
Figure 1.4, Adoption Rate for Each Version of iOS

#### Apple Design Guideline

Unlike the Material design, Apple has established and developed their iOS Design Framework for a long time and there are dramatically more users using iOS8 and iOS9 [(based on ](https://developer.apple.com/support/app-store/)figure[ 1.3)](https://developer.apple.com/support/app-store/). As iOS9 is a new OS that launched a few months ago, most of the iOS application still remain in iOS8. Due to this reason, when I am talking about iOS Design in this study, I will refer to iOS8 and its features.

Based on the reading on [iOS Human Interface Guideline](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/), I have summarized the following key points for iOS Design:

**Flat Design: **It removes any stylistic choices that give it the illusion of three-dimensionality, like drop shadows, gradients, and textures. It’s focused purely on the interplay of icons, typography, and colour.

**Minimalist Design & Functionality: **The design in iOS focuses more on raw functionality instead of the appearance. The simplicity of its iconography and layout is intended to reduce the cognition workload for users while they are using the phone.

**Intuitive Interaction:** The built-in apps use a variety of cues, including response to pressure, colour, location, context, and meaningful icons and labels. Users rarely need additional decorations to show them that an onscreen element is interactive or to suggest what it does. For example, to go back, users will generally get hints to slide their finger from the left to the right as there is response to pressure on screen.

**Colour & Image:** In iOS, Apple relies on using colour to helps indicate interactivity and provide visual continuity. To intuitively guided users through the process of a mobile app, it suggest designers to base heavily on using the colours and pictures alone to guide for user’s next actions.

#### Comparisons between Apple and Google

**UI Elements**

![](http://ac-Myg6wSTV.clouddn.com/775dce40405661b2b82f.png)
Figure 1.5 UI Elements Comparisons

The iOS Platform and Android Platform have differences in the User Interface elements. According to the figure 1.4, firstly, iOS(left) and Android(right) have different position for the main action bar. While apple system place it on the bottom of the User Interface, Android system usually place it on the top but below the navigation bar. Secondly, both android and iOS have designed back navigation button on the top. However, the top back navigation button is optional for Android since it also has a physical back navigation bar on the phone. Thirdly, while material design frequently uses hamburger icon as their menu button, apple normally do not use the hamburger-like menu. Fourthly, material design also allow float button always stay above the UI, using as a shortcut button for the user. In addition, material design also use cards as a key component for their user interface.

**Interaction & Motion**

![](http://ac-Myg6wSTV.clouddn.com/3bbd8617f851fdb1ac5e.png)
Figure 1.6 Interaction and Motion Design Comparisons
Android also differs from iOS design regarding its interaction and motion design. According to figure 1.5, Firstly, while iOS use colour change or dimming to provide users with interaction feedback, the interaction feedback from Android includes touch ripples that emanate from your finger *(surface reaction and radial reaction)*, buttons can rise in elevation with their shadow grow to “meet” your finger *(material response)*. Secondly, while Apple advocates to add animation cautiously and do the animation in a subtle way, Material design implements animation in a more eye catching way. In Google’s opinion, the clean and strong motion design can effectively guide the user’s attention in ways that both inform and delight. They believe the use of motion can smoothly transport users between navigational contexts, explain changes in the arrangement of elements on a screen, and reinforce element hierarchy *(transitions).*

**Visual Language**

![](http://ac-Myg6wSTV.clouddn.com/89cbb9564cdc61855a4b.png)
Figure 1.7 Visual Design Comparision

Android and iOS also have different visual languages based on figure 1.6. Firstly, on Android, the key unit of measure is the density-independent pixel, often abbreviated DIP or DP while iOS use points as their unit. Both types of units ensures your designs have a consistent physical size across devices of varying density. Secondly, iOS conventionally uses a blur effect to indicate depth while Android use the shadow to do so. Thirdly, regarding the form size, iOS use 3 types (@1x,@2x,@3x) while the Android use 4 types (normal, small, large, extra large).

### Mobile Applications

After knowing the main features of Material Design and iOS Design, I researched and studied the applications that has different or similar design on iOS & Android. As I don’t know any people from the application team, the opinion in this section is my observation instead of the team’s actual decisions. Based on the observations, there are various approaches on designing apps on multi-platforms which includes Brand-oriented approach, Platform-oriented approach, and the Fixed approach. In the following section, I will explain each approach and analyze the examples.

#### Brand-oriented approach

The Brand-oriented approach unifies a product’s brand identity by customizing its user interface and user experience on both OS. Under this approach, designer usually don’t follow the standard platform guideline and design unique user interface to deploy on both platform. Under this category, VSCO CAM and Snapchat not only have strong brand identity but also have unique custom interface. In this section, we will evaluate them and study from their design.

> VSCO CAM

![](http://ac-Myg6wSTV.clouddn.com/690e10db3d0181112c16.gif)
Figure 2.1 VSCO CAM — Explore Page ( Left IOS vs Right Android )
VSCO Cam app is a popular photo editing application nowadays. It was first launched in iOS and then was ported to Android. As you can see from the figure 2.1 above, the UI on android looks almost the same UI on iOS. They have the same navigation, same menu, and even the same icons. More interestingly, neither of them follow the platform design guidelines. There is no traditional action bar. The way you navigate around is through its menu which is not located in a traditional position. In this case, as VSCO CAM drop platform guidelines in favour of brand identity, you can strongly feel its consistent brand identity across both platforms.

![](http://ac-Myg6wSTV.clouddn.com/7f760c5880e1ea13e99e.gif)
Figure 2.2 VSCO CAM — Camera Page( Left IOS vs Right Android )
Although the current iOS and Android versions of Snapcthat do look like twins, there are still a few elements that set them apart. For example, the camera interface looks native to both platforms.

> Snapchat

![](https://cdn-images-1.medium.com/max/800/1*4uytqo55hEPhaLn2WSlrQw.gif)
Figure h2.3 Snapchat — UI flow ( Left iOS vs Right Android )
Like the VSCO Cam app, Snapchat was launched in the App Store way before it became available for Android in 2011. The uniqueness and playfulness of its interaction has made Snapchat stand out, which make this app successfully [attract more than 200 million active users nowadays](http://www.businessinsider.com/snapchats-monthly-active-users-may-be-nearing-200-million-2014-12). simplified process to take and send photo, nice color palette, the smooth transition, and animation all contribute to the uniqueness of Snapchat. As the unique interaction is Snapchat’s brand identity, we can see that the company is trying to unify its interaction experience on both platforms. The iOS and Android interfaces of the Snapchat app are almost identical, including UX design and UI design. As you can see from figure 2.3, Snapchat has the same interaction flow on both platforms. On both iOS and Android, user will first enter the camera page. After that, they can view the friends page if they swipe to the left while swiping right to view the “discovery” page. In addition, the design for UI elements and graphics also look highly similar. The design on each platform only differ regarding the size and position of title and icon element.

Generally speaking, both Snapchat and VSCO Cam have created strong brand identities via implementing unified UX and UI design across platforms. However, such approach also has drawbacks and we will further discuss it in later section. For now, we will keep exploring and get to know the platform-oriented approach.

#### Platform-oriented Approach

The Platform-oriented approach aligns the design on each platform with the corresponding platform design guideline. In this case, the product designer’s focus has shifted from brand identity to familiarity with platform standards since users are accustomed to the platform conventions. They have an intuitive grasp of the design rules around their platform so that the platform-specific design can make them easily to adapt to your product. In this category, Evernote and Dropbox are excellent examples.

> Evernote

Evernote was introduced in 2007 as a note taking product aiming to help to improve people’s work productivity. As note taking

The iOS and Android versions of Evernote look completely different from each other regarding both the UI and UX. They differ everything on each platform from the login page design to the menu design, and even the choice on specific UI element.

![](http://ac-Myg6wSTV.clouddn.com/e441197fed5eb967158f.gif)
Figure 2.4 Evernote Login ( Left iOS vs Right Android )
Mentioned previously, while iOS advocates adding animation cautiously and in a very subtle way, Android prefer use dynamic animation to guide user’s eyes. As you can see from figure 2.4, the login pages on iOS and Android follow each platforms guideline and look completely different. As a result, we see the login page on iOS has minimal graphic design and animation while the one on Android has more dynamic looks and animation.

![](http://ac-Myg6wSTV.clouddn.com/81f08899ab7d034ad4fa.gif)
Figure 2.5 Evernote Main Menu | left(iOS) vs right(Android)
The menu design also looks completely different. The menu on iOS takes up full page and has an overwhelming green background, which makes it look like a new page instead of a menu. Unlike the design on iOS, Android’s version follows Material Design guideline and use hamburger menu. As the menu only take up half of the page and user can easily see where they are, it gives user better understanding about their locations during the page transition. In addition, the menu items on Android is easier to read as there are more white space and better information hierarchy.

![](http://ac-Myg6wSTV.clouddn.com/be827a16addd448cebfd.gif)
Figure 2.6 Evernote Macro Interaction ( Left iOS vs Right Android )
Evernote’s designers also adopted native UI elements on each platform to perform same tasks. As you can see from the graph 2.6, the add button on android is float button, which is a traditional UI element on material design. On the other hand, the add button on iOS is action bar button, which is usually seen in the iOS design guideline.

> Dropbox

Dropbox is a utility app that has chosen to focus on functionality rather than the look. Therefore, its designers decided to stick to a platform-oriented approach since the native user interface is more predictable and is therefore easier for a user.

![](http://ac-Myg6wSTV.clouddn.com/fd2fc3dc962f9814f9e9.gif)
Figure 2.7 Dropbox Navigation Strucutre
As you can see from figure 2.7, Dropbox Android and iOS take different approaches for navigation hierarchy. The current Dropbox for iOS uses a bottom tabs bar to switch between four top-level sections: Files, Photos, Offline Files, and Notifications. However, Android version hides all top level sections into the navigation drawer, which is a large difference from hierarchical perspective.

![](http://ac-Myg6wSTV.clouddn.com/41f45399d3e334894329.gif)
Figure 2.8 Dropbox Float Button ( Left iOS and Right Android )
The Dropbox designers also use platform-standard controls and UX interaction elements for the design on each platform. According to figure 2.8, Android’s floating action button and iOS’s tab button have been used in the corresponding platform to give users easy access to primary content-related actions, for example, u*pload file*, new folder, etc. The use of these two UI elements not only keep the same content working across platforms but also truly fit in with each OS’s UI pattern.

![](http://ac-Myg6wSTV.clouddn.com/4cc916d24f5c47cf8ac7.gif)
Figure 2.9 Dropbox Login Page ( Left iOS vs Right Android )
Beside the UI and UX differences among these two platforms, there are also differences regarding graphic design, animation, and copywriting. As you can see from graph 2.9, while iOS version has minimal text and icon, the Android version shows us appealing visual design and animation. Android’s version has better copywriting as well, which create a sense of caring and welcome.

Generally speaking, both Evernote and Dropbox have created highly platform-specific apps. However, as the opposite side of brand-oriented approach, this method also has drawbacks, which will be discussed later. For now, we will keep exploring the last methods to design multiplatform apps: the mixed approach.

#### Mixed Approach

This mixed approach to multiplatform design seeks a balanced combination of the two approaches mentioned above, and it’s also the most complicated one. In this case, designer need to take into account two types of users: those familiar with your product, and those who have never used it before. The former adhere to a brand, while the latter are accustomed to the particularities of their platform. Designers who choose the mixed method are diplomats whose job is to represent the interests of the brand, as well as promote friendly relations with users. They need to figure out what UI elements make a product stand out, and also find platform-specific solutions which won’t hurt the brand. Under this category, Facebook and Spotify are the examples being used.

> Facebook

Facebook’s brand has a huge impact while its multiplatform network has an enormous number of users. That’s why the mixed approach which harmoniously combines brand identity and platform was the most appropriate approach for its situation. It is easy to see that Facebook is adopting mixed approach. The current iOS and Android versions of Facebook’s app look similar, but also feel quite native to users of both platforms.

![](http://ac-Myg6wSTV.clouddn.com/76a10752b1df69d5e875.gif)
Figure 3.1 Facebook Layout (Left iOS vs Right Android)
At first sight, the compliance with the brand identity is achieved by using colour and icons identical on both platforms. The main difference between Facebook’s iOS and Android apps is the location of the navigation bar. As you can see from graph 3.1, the iOS version uses a typical iOS navigation bar at the bottom of the screen and a standard search bar. In the Android version switching between sections is done with the help of a tab bar, which is located at the top just like the majority of Android apps.

![](http://ac-Myg6wSTV.clouddn.com/6c7deac5dc7e72ba6495.gif)
Figure 3.3 Facebook Search Bar ( Left iOS vs Right Android )
The navigation button on search bar is also platform-specific. According to figure 3.3, the Facebook’s search bar on iOS has a cancel button. However, the cancel button becomes a arrow icon on Android, which may not be familiar for iOS’s users. The platform-specific design for those interactions has allowed first-time users to easily understand how those interactions work.

> Spotify

Spotify is a well-known music streaming app that has stylized design and strong brand identity. While Spotify’s designers made a significant efforts to maintain the brand’s integrity, they also follow the platform’s design guidelines to design some specific app features.

![](http://ac-Myg6wSTV.clouddn.com/52e9851376f9599abce7.gif)
Figure 3.4 Spotify Home Page ( Left iOS and Right Android )
At first sight from figure 3.4, the Spotify designers did a great job on unifying UI and visual design on both platforms’ home page. The design on this page show a strong consistency across platforms.

![](http://ac-Myg6wSTV.clouddn.com/d3f65a13207a69347547.gif)
Figure 3.6 Spotify Sign Up Page
Despite strong adherence to the brand, Spotify also meets users’ expectations in the interface and interactions, and pays a lot of attention to the use of platform-specific UI elements. As you can see from figure 3.6, Spotify design the text filed for birthday and gender information differently on iOS and Android. While iOS design respond to user’s interaction with its traditional dropdown menu, the response on Android is a pop up window. “ The pop window ” is the typical card design based on the Material Design guideline.

![](http://ac-Myg6wSTV.clouddn.com/d71ea302d20a2924bf41.gif)
Figure 3.7 Spotify Message and Activity Page ( Left iOS and Right Android )
In addition, the content hierarchy is designed differently on iOS and Android. According to graph 3.7 , while the activities and messages sections are top-level menu items on iOS, these two sections are under a menu item called “notification” on Android version. Spotify’s designers have taken the design from Google to simplify the information flow on Android.

### Pros and Cons

After viewing those case studies, we will move forward and analyze the pros and cons on each approaches. In this section, I will explore when a company is suggested to choose each approach and analyze the advantages and disadvantages of using each approach.

#### Brand-oriented Approach

Sticking to the brand and ignoring rules from platform guideline is the fastest, easiest and most cost-efficient approach to create UI design. The UI components that freely created by designers usually allow apps to provide users with more customized design and interaction experience. As it is not following specific platform guideline, the product is easier to give users the same look and feeling across platform, which helps company retain their brand identity. However,custom UI is complex in implementation, so development effort would cost your company more if compared to the price of building standard components. It may also causes specific user experience problems since your users are not familiar with the new interface and interaction.

**Recommendation: **It is perfect to develop an app to be part of the brand when retaining the brand’s consistency is the first priority for company’s strategy.

#### Platform-oriented Approached

Platform-oriented approached has a faster development cycle as software engineers are familiar with standard UI element and can implement the idea much quicker. Once an app has been launched, users who download it will find interaction patterns familiar, which iseasier for a user to adapt your app. However, following platform-specific standards requires significantly more time and money regarding UI design. When designer port design, many UX and UI elements need to be recreated from scratch to align with the conventions of the target platform. Moreover, when designer follow the guideline, everything start to looks like made by google and apple. In this case, the platform-oriented approach isn’t always so awesome for companies that want to retain the strength of their own brand.

**Recommendation:** It is a perfect approach when your want to make a fast launch and rapidly grow a user base in a highly competitive market environment.

#### Mixed approached

The mixed approach is a singular case where you let the experience speak for the brand. I believe it’s the best path to the ideal multiplatform adaptation. It allows designer to stay true to the platform, brand and user. Besides, using this approach lets a designer alter the balance either in favor of the brand or the platform guidelines, and as a result deliver a great product. However, mixed method require longest time and effort to develop products as it involves constant change in development cycle. It’s usually hard for small startups since they don’t have enough time and money.

**Recommendation: **In my opinion, such approach is perfect when designer do not have too much restriction and can incrementally develop and refine the product’s design based on feedback and evaluation

### Guideline for Decision Making

Even though the mixed method seems to be the way to go, I’d say none of the approaches mentioned in this article is perfect. Sometimes choosing brand identity over the platform standards leads to specific user experience problems . The apps that use platform-oriented approaches risk acquiring a look that’s toostandardized and doesn’t work well for the brand. The apps I used to illustrate the mixed approach are great examples of successful multiplatform adaptation. However, such cases are rare since it require a lot of time and investments.

Therefore, when considering about the use of each approach, designers should align their decisions with the product’s strategy and consider the constraints in the product development, such as the lack of talent developers, money, or even the time. When your team have strong needs for brand integrity and your company are not a big company, Brand-oriented approach is suggested. On the other hand, the Platform-oriented approach will be suggested when your company focus on more rapidly growing a user base. The mixed approach will be recommended when your product development team doesn’t have too much constraints and just want to constantly improve the product.
