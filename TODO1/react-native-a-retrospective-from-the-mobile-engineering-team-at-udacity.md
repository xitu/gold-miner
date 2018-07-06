> * 原文地址：[React Native: A retrospective from the mobile-engineering team at Udacity](https://engineering.udacity.com/react-native-a-retrospective-from-the-mobile-engineering-team-at-udacity-89975d6a8102)
> * 原文作者：[Nate Ebel](https://engineering.udacity.com/@n8ebel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-a-retrospective-from-the-mobile-engineering-team-at-udacity.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-a-retrospective-from-the-mobile-engineering-team-at-udacity.md)
> * 译者：
> * 校对者：

# React Native: A retrospective from the mobile-engineering team at Udacity

![](https://cdn-images-1.medium.com/max/1600/1*AjesIvV-kkwk6LLvNf1t4A.png)

The mobile team here at [Udacity](https://www.udacity.com/) recently removed the last features in our apps that were written with [React Native](https://facebook.github.io/react-native/).

We’ve received numerous questions regarding our usage or React Native and why we’ve stopped investing in it.

In this post, I hope to answer the majority of the questions we’ve received and give insight into:

*   What is the size & makeup of our particular team?
*   Why did we try React Native in the first place?
*   What was the reason for removing it?
*   What worked? What didn’t?
*   … and more 🙂

I certainly won’t claim to be an expert on React Native. Others on our team have much more experience than I do, but I doubt they would claim to be experts either.

I’ll be speaking from our own experiences about what did and didn’t work in our specific situation. Whether React Native is right for your team/project is up to you, but hopefully this post will provide an additional useful datapoint to consider.

> “Whether React Native is right for your team/project is up to you”

I also want to point out that these experiences and opinions are from the mobile-engineering team here at Udacity, and no one else. The thoughts here don’t reflect the opinions of any other teams using, or building content for, React or React Native.

* * *

### The Team

First things first. What does our team look like? The size, experience, and organization of your team can have a real impact on the viability of React Native for your project.

Our mobile-engineering team is split across the iOS and Android platforms.

> Team Size

**When introducing React Native:**

*   1 iOS dev
*   2 Android devs
*   1 PM
*   1 Designer

**Today:**

*   4 iOS devs
*   3 Android devs
*   1 PM
*   1 Designer

Over the course of our ~18 months with React Native, both our iOS and Android teams grew in size.

The team saw a new PM take the helm.

We went transitioned through multiple designers & design paradigms.

> Dev Background

How comfortable was/is each team with Javascript and a React paradigm when introducing React Native?

**iOS**

The sole dev on the iOS team was quite comfortable jumping into React Native having had ample previous experience with Javascript and web development.

Today, three of four iOS devs are at least moderately comfortable working with Javascript & React Native.

**Android**

At the introduction of React Native, one of the two Android developers was comfortable with Javascript. The other (myself) had very little Javascript, React, or web background.

The additional Android developer that joined the team also has little Javascript or web experience.

* * *

### The Apps

What do our apps do?

Our mobile apps aim to bring the Udacity learning experience to your mobile device. They support authentication, content discovery, program registration (and in some cases payment), and finally the consumption of learning materials across a variety of programs and content types.

The apps are also a testing ground for new, experimental features and initiatives aimed at improving the overall learning outcomes for our users.

> **Size of the codebases**

*   iOS: 97,400 lines (.swift, .h, .m)
*   Android: 93,000 lines (xml, java, kotlin, gradle)

> **Parity**

When React Native was introduced, the apps were very close to feature equivalent.

As time has gone on, core experiences have stayed mostly equivalent but each team has also increased the number of “experiments” exclusive to one platform or the other.

Additionally, due to much greater international demand, initiatives such as localization and smaller apk size have becoming an increasing priority for the Android team. The Android team has also worked closely at times with teams in other locales for market specific features that are not a priority for iOS.

* * *

### Why/How Did We Adopt React Native?

> **Why did we introduce?**

We were kicking off a brand new, mobile-only feature. We wanted to experiment and validate quickly on both platforms, so a cross-platform was very attractive.

Because it was a new and isolated feature, it was viewed as very interesting opportunity to try out a cross-platform approach.

React Native was chosen for a few reasons:

*   increased viability as a cross platform solution
*   most (2/3 devs) of the team was comfortable with Javascript & web development
*   increased development speed
*   success stories from other teams outside the company

> **How did we introduce?**

The initial React Native feature was built in a separate GitHub repository and incorporated back into both the iOS and Android repositories separately as a [git subtree](https://www.atlassian.com/blog/git/alternatives-to-git-submodule-git-subtree).

This allowed for very fast prototyping and provided the opportunity for the feature to be released as a stand-alone product if desired.

More experiences were prototyped, and eventually we introduced a second, larger feature into the React Native codebase.

> **Timeline**

*   Aug 2016: React Native repo created for _Feature 1_
*   Nov 2016: _Feature 1_ released on Android
*   Nov 2016: _Feature 2_ begins development
*   Dec 2016: _Feature 3_ prototyping beings
*   Jan 2017: _Feature 1_ development ends
*   Feb 2017: _Feature 2_ released
*   Mar 2017: _Feature 3_ prototyping ends
*   Nov 2017: _Feature 2_ last Android update
*   Dec 2017: Feature 4 prototyped as standalone app. Ultimately scrapped in favor of native due to performance concerns
*   Feb 2018: _Feature 2_ last iOS update
*   Apr 2018: _Feature 1_ removed from Android
*   Jun 2018: _Feature 2_ removed from both apps

* * *

### Motivation for Removing?

This answer is pretty straightforward.

We removed the last traces of React Native from the apps because the only remaining React Native feature was being sunset and we no longer had to support it.

> “_why did we stop investing in React Native for new features?_”

A more interesting question might be “_why did we stop investing in React Native for new features?_”

Several things come to mind:

1.  A decrease in the number of features being built on both platforms at the same time
2.  An increase in Android-specific product requests
3.  Frustration over long-term maintenance costs
4.  The Android team’s reluctance to continue using React Native

* * *

### What Did We Replace It With?

The React Native features we’ve deployed and removed are no longer supported, and have not required replacement.

* * *

### What Went Well?

What aspects of our foray into React Native went well?

*   It’s quite easy to get up and running with React Native and start building for both platforms
*   Able to pull in libraries and tools from the larger React & Javascript ecosystem
*   We were able to prototype _Feature 1_ on both platforms at the same time
*   A single developer, on a cross-functional team, was able to build the large majority of _Feature 2_ for both platforms at the same time
*   The team’s collective understanding of React Native increased

* * *

### What Issues Did We Face?

During our time with React Native, we faced a number of issues. Some of these can be attributed to our process, some to our use cases, and some to React Native itself.

### **Design & Experience Challenges**

> **Platform Consistent UI/UX**

Because we were integrated a few new screens into larger existing experiences, we wanted the new React Native code to adhere to both native platform patterns, and existing styling. This meant we couldn’t necessarily use the same UI design for both platforms.

Ensuring styling that felt native to each platform isn’t difficult in React Native, but it does require knowledge of the design paradigms used in each code base. At it’s easiest, this requires platform checks and perhaps custom widgets for each OS.

For us, this often required touching base with developers and designers from each platform to understand what was required, or a single style would be used for both which often led to experiences on the Android side that had a distinctly different look from the rest of the app.

In more complex situations, additional platform specific code was needed to customize the app experience.

Once such example was ensuring the proper behavior of a back/up icon. Because of where/how new React Native features needed to be integrated into the existing apps, ensuring the proper behavior of the back/up icon and back button press required Android specific native code & Android specific changes to the React Native codebase.

> **Changes in native design might necessitate changes to React Native code to handle the integration points**

On at least one occasion, the navigational structure of the Android app changed which required us to update the React Native code for no other reason than to change how the native to React Native integration was handled.

Instead of being isolated into its own Activity, the React Native feature had to be moved to a fragment, placed within a screen with a BottomNavigationView and then coordinate state between itself and other native fragments.

This type of platform change required going back to the separate code base, making changes, updating integration, and ensuring that the new changes also didn’t negatively impact the iOS application.

> **Device Specific Issues**

Whether you call it “_fragmentation_” or “_diversity_”, the fact remains that there are far more unique Android device configurations to account for.

On multiple occasions we discovered layouts that didn’t adapt well to differently sized Android phones. We found that animations running smoothly on the latest iPhone or Pixel device wouldn’t run well on lower end devices in international markets where Android is more widely used.

These certainly aren’t uniquely React Native problems; these are common development challenges on Android, but as the amount of platform specific checks and considerations added up we had to start considering how much time we were actually saving by using React Native.

> **Global Growth**

During our time with React Native, internationalization became a much larger focus for the Android team. We had several international offices requesting localization and a decrease in apk size.

String localization in React Native can be done thought it does require additional setup. In our case, it would require changes to a separate repo. This increased the complexity of the localization task which was not ideal when asking for localization assistance from other teams. This contributed to a decrease in the frequency with which the React Native features were localized.

We were able to reduce our apk size over this time, but the inclusion of React Native was a sizable increase in size that we couldn’t do much to work around. After removing the last feature, our apk decreased by ~10MB from the command resource decrease and the size of React Native itself.

### **Integration Challenges**

> **Integration with native components & navigation structure**

In our experience, integrating React Native into existing app can be pretty straightforward if it’s an isolated feature, or can be a bit of a challenge if it’s needed to integrate closely with existing components and communicate with them.

We found ourselves often needing a great deal of bridging code to communicate between native and React Native components. At least once this code then required an update when we needed to change where the React Native component fit into our navigation hierarchy.

> **Tooling/Build Issue**

Incorporating React Native required updates to our build processes for each app. We use CircleCI to build our projects which needed to be reconfigured to support the additional React Native build steps.

As previously shared, on the Android side this was not as straightforward as we would have hoped.

[**Bundling React Native during Android release builds**  
_How to run the React Native bundling command during you Android release build_engineering.udacity.com](https://engineering.udacity.com/bundling-react-native-during-android-release-builds-43d5c825d296 "https://engineering.udacity.com/bundling-react-native-during-android-release-builds-43d5c825d296")[](https://engineering.udacity.com/bundling-react-native-during-android-release-builds-43d5c825d296)

Once our build was updated to include the required React Native tasks, it increased the duration of our release build on CircleCI by ~20%.

After removal of the final React Native feature from our codebase we saw the following improvements:

*   CircleCI build time decreased from ~15min to ~12min
*   Release apk size decreased from 28.4MB to 18.1MB

The Android team also experienced issues at times with Android/Gradle build tooling being in conflict with React Native. Most recently we had been working around [issues with Gradle 4](https://github.com/facebook/react-native/issues/16906).

The iOS team had its fair share of challenges as well.

Configuring the build was painful because we had a non-standard file structure for React Native. Because of our separate project repos, we pulled in the React Native repo under srcroot/ReactNative and a lot of the existing build tools assumed the default app structure which is /ReactNative/ios/…ios .

Additionally, we used cocoapods for dependency management which was originally the suggested way to include React Native, but was deprecated along the way. This was further exacerbated by our non-standard file structure and we had to include some annoying hacks in our Podfile to get it to read from the correct place.

Since cocoapods was no longer the canonical way to include React Native, Podfile updates were dependent on the community to update which weren’t always in sync. There were several versions where the css/Yoga dependency was updated but the Podfile was referencing an incorrect version.. Up until the end, we had some nasty post-install hacks to essentially sed/regex some of the include calls.

Lastly, CI for the iOS project was a pain point as well. We now had to add an npm dependency layer and make sure those were being updated properly before continuing the install. This added nontrivial amounts of time to our build step.

There was also an issue that caused a crash because one version of npm had a \`package.lock\` and the other didn’t which caused us to install incorrect versions of a dependency across a React Native upgrade.

* * *

### **React Native Challenges**

> **Documentation**

React Native as a whole has been moving very fast, and we found documentation was lacking at times. Particularly as we were first adopting, we found that documentation/answers for a particular version may, or may not, still be relevant.

Documentation for integrating React Native with an existing project seemed sparse at the time. This was a contributing factor to the challenges we had updating our CI builds.

As React Native has continued to evolve, the documentation and supporting community contributions have improved. It’s likely that if we were starting today, we would have been able find answers to some of our questions more easily.

> **Navigation**

We initially started with NavigationExperimental, which wasn’t the easiest navigation library to work with. When [React Navigation](https://github.com/react-navigation/react-navigation) came out, it quickly became the community accepted navigation and NavigationExperimental was deprecated before ReactNavigation was truly fully baked.

Despite this; there were things that we couldn’t do in ReactNavigation without kludging things together (example: Push flows inside a presented modal flow)

> **Performance**

As mentioned before, there were certain times where performance issues were noticed.

We were able to build some very nice animations that looked great on well specced iOS & Android devices, but did not perform well on under powered Android devices that are more prevalent in international markets.

The load time when entering into the React Native portion of the app was longer than we would have liked. It often did not feel like a seamless transition.

When prototyping the standalone _Feature 4,_ graphing rendering performance was a large enough concern that React Native was scrapped in favor of a native experience.

> **Lag Behind Native Platforms**

Because it’s not built in conjunction with iOS or Android, React Native lags behind the native platforms at times. It’s often largely dependent on the community to support new native features.

One such example was the urgent need for [_safe area_](https://facebook.github.io/react-native/docs/safeareaview.html) support for the iPhone X. We ultimately opted to leave the feature without SafeArea support for a short period of time as it was going to be introduced shortly. Utilizing `SafeAreaView` is one example of a platform specific feature that cross-platform developers would need to be aware of to develop compliant apps.

At other times, React Native lags behind in the adoption of new platform requirements such as Android apps [being required to target api 26](https://android-developers.googleblog.com/2017/12/improving-app-security-and-performance.html) by August 2018. There are several [open issues](https://github.com/facebook/react-native/issues/18095) for this requirement.

> **Breaking Updates**

React Native’s non backwards compatible upgrades were pretty frustrating. One example was the [PropType deprecation](https://github.com/react-navigation/react-navigation/issues/1352) when React Native upgraded it’s underlying React library.

Without maintaining our own custom fork, many third party libraries became unusable if they were no longer being maintained.

* * *

### **Maintenance Challenges**

Maintenance of the React Native portions of the codebase was a challenge for us at times. As mentioned before, Android often required additional work whether to integrate with existing code or to fix UI issues. This led to iOS and Android working off of different branches of the React Native codebase so one platform wouldn’t slow the other.

Because of this branching, a divergence in the code slowly started to form and the effort required to bring them to parity increased. As a result, updates to one platform or the other didn’t immediately get added to the other platform.

The speed of change of React Native also presented challenges. Because of the possibility of breaking changes, it wasn’t always quick to update a dependency to pick up a new feature or bug fix.

Again, at times this led to increased friction which slowed the rate of maintenance of this code. With a small team, and limited bandwidth, if it wasn’t an easy/quick fix in the React Native code it had a much lower likelihood of being addressed because of the additional development effort it might require.

With the addition of React Native, it was not always clear at what level a bug existed. Was it present in both platforms? Was it only on one platform? If only on one platform, was it in the native code or the React Native code? The added complexity of these questions slowed the qa process at times.

When needing to fix an issue in the React Native portion of the codebase, we now had to consider both iOS & Android and possibly work with 3 development stacks instead of 1.

Also, with less than 100% of the team feeling productive with React Native, the number of developers able to quickly jump in and fix something was reduced as well.

* * *

### What Could We Have Done Differently?

I believe some of the problems we faced were inherent to our use case, however there are things we could have done differently to mitigate some of these issues.

> **Less Divergence**

We could have done a better job of keeping each app up to date with the latest changes in the React Native repo. I believe that keeping those updates in sync would have helped us develop a stronger sense of true cross-platform development for these features.

Increased on-device testing, especially on Android, may have led to finding more UI/performance issues early on and allowed us to fix them before things were released. This also could have decreased the amount of code divergence by fixing issues before work on new things started.

> **More Consistent Design**

A more concrete design plan from the outset likely would have improved the native look of the features. One specific example of this is using text/margin values that are consistent with the rest of the native applications, rather than picking a new value within the new experience and using that on both platforms.

> **Greater Team Understanding**

Members of the team that were less comfortable with React Native could have possibly done more to become comfortable with the additional development stack. This could have increased the number of people capable of quickly fixing issues in that part of the code.

* * *

### Are There Use Cases We Think Would Be A Better Fit?

I don’t think anyone on our team believes that React Native is without its merits. I certainly believe there are use cases for which React Native is very well suited.

Do you need to prototype/build a new app from scratch, quickly, on both platforms?

Are you building an app/feature that will look/behave the same regardless of platform?

Do you have Javascript developers with spare dev cycles that you would like to contribute to mobile?

If you answered _“Yes”_ to any of these questions, React Native is possibly a viable option for you.

In particular, I think if you have a Javascript/React background and are looking to build an app which won’t require much native code, then React Native is a very attractive option. It will enable you to start building on mobile without having to learn 2 different tech stacks.

For greenfield development on a fully cross-platform application, React Native could also be an excellent choice.

* * *

### Would We Use React Native Again?

The iOS and Android teams have a difference of opinion here.

> **iOS**

Possibly. The iOS team was generally pretty happy working with React Native and has considered building new functionality with it. Additionally, on the product side of things our PM has more confidence in a React Native solution running on iOS than on Android.

> **Android**

No. Ideally, the Android team would not be investing into React Native in the future. We found the process of integrating with React Native components cumbersome, and felt the resulting experiences didn’t work as well across all Android devices.

Additionally, there is a sense of preferring to stick to a single development stack rather than adding a new layer of abstraction and possible bugs on top of the Android framework.

Our impression was that React Native was faster to get a new feature running on Android, but took longer to take that feature from early stages to polished release, to long-term maintenance.

* * *

### Would We Use Another Cross-Platform Solution Again?

As a team, we probably wont be investing into cross platform development in the near future. It’s possible the iOS team could build something using React Native and still keep it specific to iOS since they generally enjoyed the experience more.

Individually, members of the team continue to follow React Native as well as Flutter. As solutions such as React Native and Flutter continue to evolve, we will continue to evaluate them for our team.

* * *

So, that’s where we are today.

We have a better understanding of how React Native fits our team and our roadmap. We can use that information going forward to make informed decisions about the right technology choices for our team.

> “Can we say definitively whether or not React Native is right for you? No.”

We see the merits of React Native as well as the limitations. Can we say definitively whether or not React Native is right for you?

No.

But hopefully our experiences can act as an additional data point for you when evaluating the viability of React Native for your projects.

* * *

#### Want to Learn More About Mobile Development?

* [**Android Development Nanodegree by Google | Udacity**: Start your career as an Android developer with our Android development Nanodegree with Google.](https://www.udacity.com/course/android-developer-nanodegree-by-google--nd801)

* [**Become an iOS Developer | Udacity**: Learn iOS app development and become an iOS developer with our iOS Developer Nanodegree.](https://www.udacity.com/course/ios-developer-nanodegree--nd003)

* [**React | Udacity**: React is completely transforming Front-End Development. Master this powerful UI library from Facebook with Udacity.](https://www.udacity.com/course/react-nanodegree--nd019)

* [**Build Native Mobile Apps with Flutter | Udacity**: Learn from experts at Google how to use Flutter to craft high-quality native interfaces on iOS and Android devices in…](https://www.udacity.com/course/build-native-mobile-apps-with-flutter--ud905)

#### Follow Us

For more from the engineers and data scientists building Udacity, follow us [here](https://engineering.udacity.com/) on Medium.

_Interested in joining us @udacity?_ [_See our current opportunities_](http://www.udacity.com/jobs)_._

#### Udacity for Mobile

[**Udacity for Mobile | iPad, iPhone and Android**  
_We've brought the Udacity course experience to iPad and iPhone and Android. Start learning the skills you need to…_www.udacity.com](https://www.udacity.com/mobile "https://www.udacity.com/mobile")[](https://www.udacity.com/mobile)

Thanks to [Aashish Bansal](https://medium.com/@aashish.bansal?source=post_page) and [Justin Li](https://medium.com/@li.justin?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
