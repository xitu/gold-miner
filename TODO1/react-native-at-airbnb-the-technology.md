> * 原文地址：[React Native at Airbnb: The Technology](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb-the-technology.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb-the-technology.md)
> * 译者：
> * 校对者：

# React Native at Airbnb: The Technology

## The technical details

![](https://cdn-images-1.medium.com/max/2000/1*iaYan0f1NeQlzGnwzjXEvg.jpeg)

This is the second in a [series of blog posts](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c) in which we outline our experience with React Native and what is next for mobile at Airbnb.

React Native itself is a relatively new and fast-moving platform in the cross-section of Android, iOS, web, and cross-platform frameworks. After two years, we can safely say that React Native is revolutionary in many ways. It is a paradigm shift for mobile and we were able to reap the benefits of many of its goals. However, its benefits didn’t come without significant pain points.

### What Worked Well

#### Cross-Platform

The primary benefit of React Native is the fact that code you write runs natively on Android and iOS. Most features that used React Native were able to achieve _95–100% shared code_ and _0.2% of files were platform-specific_ (*.android.js/*.ios.js).

#### Unified Design Language System (DLS)

We developed a cross-platform design language called [DLS](https://airbnb.design/building-a-visual-language/). We have Android, iOS, React Native, and web versions of every component. Having a unified design language was amenable to writing cross-platform features because it meant that designs, component names, and screens were consistent across platforms. However, we were still able to make platform-appropriate decisions where applicable. For example, we use the native [Toolbar](https://developer.android.com/reference/android/support/v7/widget/Toolbar) on Android and [UINavigationBar](https://developer.apple.com/documentation/uikit/uinavigationbar) on iOS and we chose to hide [disclosure indicators](https://developer.apple.com/ios/human-interface-guidelines/views/tables/) on Android because they don’t adhere to the Android platform design guidelines.

We opted to rewrite components instead of wrapping native ones because it was more reliable to make platform-appropriate APIs individually for each platform and reduced the maintenance overhead for Android and iOS engineers who may not know how to properly test changes in React Native. However, it did cause fragmentation between the platforms in which native and React Native versions of the same component would get out of sync.

#### React

There is a reason that React is the [most-loved](https://insights.stackoverflow.com/survey/2018/#technology-most-loved-dreaded-and-wanted-frameworks-libraries-and-tools) web framework. It is simple yet powerful and scales well to large codebases. Some of the things we particularly like are:

*   **Components:** React Components enforce separation of concerns with well-defined props and state. This is a major contributor to React’s scalability.
*   **Simplified Lifecycles:** Android and, to a slightly lesser extent, iOS lifecycles are notoriously [complex](https://i.stack.imgur.com/fRxIQ.png). Functional reactive React components fundamentally solve this problem and made learning React Native dramatically simpler than learning Android or iOS.
*   **Declarative:** The declarative nature of React helped keep our UI in sync with the underlying state.

#### Iteration Speed

While developing in React Native, we were able to reliably use [hot reloading](https://facebook.github.io/react-native/blog/2016/03/24/introducing-hot-reloading.html) to test our changes on Android and iOS in just a second or two. Even though build performance is a top priority for our native apps, it has never come close to the iteration speed we achieved with React Native. At best, native compilation times are 15 seconds but can be as high as 20 minutes for full builds.

#### Investing in Infrastructure

We developed extensive integrations into our native infrastructure. All core pieces such as networking, i18n, experimentation, shared element transitions, device info, account info, and many others were wrapped in a single React Native API. These bridges were some of the more complex pieces because we wanted to wrap the existing Android and iOS APIs into something that was consistent and canonical for React. While keeping these bridges up to date with the rapid iteration and development of new infrastructure was a constant game of catch up, the investment by the infrastructure team made product work much easier.

Without this heavy investment in infrastructure, React Native would have led to a subpar developer and user experiences. As a result, we don’t believe React Native can be simply tacked on to an existing app without a significant and continuous investment.

#### Performance

One of the largest concerns around React Native was its performance. However, in practice, this was rarely a problem. Most of our React Native screens feel as fluid as our native ones. Performance is often thought of in a single dimension. We frequently saw mobile engineers look at JS and think “slower than Java”. However, moving business logic and [layout](https://github.com/facebook/yoga) off of the main thread actually improves render performance in many cases.

When we did see performance issues, they were usually caused by excessive rendering and were mitigated by effectively using [shouldComponentUpdate](https://reactjs.org/docs/react-component.html#shouldcomponentupdate), [removeClippedSubviews](https://facebook.github.io/react-native/docs/view.html#removeclippedsubviews), and better use of Redux.

However, the initialization and first-render time (outlined below) made React Native perform poorly for launch screens, deeplinks, and increased the TTI time while navigating between screens. In addition, screens that dropped frames were difficult to debug because [Yoga](https://github.com/facebook/yoga) translates between React Native components and native views.

#### Redux

We used [Redux](https://redux.js.org/) for state management which we found effective and prevented the UI from ever getting out of sync with state and enabled easy data sharing across screens. However, Redux is notorious for its boilerplate and has a relatively difficult learning curve. We provided generators for some common templates but it was still one of the most challenging pieces and source of confusion while working with React Native. It is worth noting that these challenges were not React Native specific.

#### Backed by Native

Because everything in React Native can be bridged by native code, we were ultimately able to build many things we weren’t sure were possible at the beginning such as:

1.  _Shared element transitions_: We built a _<SharedElement>_ component that is backed by native shared element code on Android and iOS. This even works between native and React Native screens.
2.  _Lottie:_ We were able to get Lottie working in React Native by wrapping the existing libraries on Android and iOS.
3.  _Native networking stack:_ React Native uses our existing native networking stack and cache on both platforms.
4.  _Other core infra:_ Just like networking, we wrapped the rest of our existing native infrastructure such as i18n, experimentation, etc. so that it worked seamlessly in React Native.

#### Static Analysis

We have a [strong history of using eslint](https://github.com/airbnb/javascript) on web which we were able to leverage. However, we were the first platform at Airbnb to pioneer [prettier](https://github.com/prettier/prettier). We found it to be effective at reducing nits and bikeshedding on PRs. Prettier is now being actively investigated by our web infrastructure team.

We also used analytics to measure render times and performance to figure out which screens were the top priority to investigate for performance issues.

Because React Native was smaller and newer than our web infrastructure, it proved to be a good testbed for new ideas. Many of the tools and ideas we created for React Native are being adopted by web now.

#### Animations

Thanks to the React Native [Animated](https://facebook.github.io/react-native/docs/animated.html) library, we were able to achieve jank-free animations and even interaction-driven animations such as scrolling parallax.

#### JS/React Open Source

Because React Native truly runs React and javascript, we were able to leverage the extremely vast array of javascript projects such as redux, reselect, jest, etc.

#### Flexbox

React Native handles layout with [Yoga](https://github.com/facebook/yoga), a cross-platform C library that handles layout calculations via the [flexbox](https://www.w3schools.com/css/css3_flexbox.asp) API. Early on, we were hit with Yoga limitations such as the lack of aspect ratios but they have been added in subsequent updates. Plus, fun tutorials such as [flexbox froggy](https://flexboxfroggy.com/) made onboarding more enjoyable.

#### Collaboration with Web

Late in the React Native exploration, we began building for web, iOS, and Android at once. Given that web also uses Redux, we found large swaths of code that could be shared across web and native platforms with no alterations.

### What didn’t work well

#### React Native Immaturity

React Native is less mature than Android or iOS. It is newer, highly ambitious, and moving extremely quickly. While React Native works well in most situations, there are instances in which its immaturity shows through and makes something that would be trivial in native very difficult. Unfortunately, these instances are hard to predict and can take anywhere from hours to many days to work around.

#### Maintaining a Fork of React Native

Due to React Native’s immaturity, there were times in which we needed to patch the React Native source. In addition to contributing back to React Native, we had to [maintain a fork](https://github.com/airbnb/react-native/commits/0.46-canary) in which we could quickly merge changes and bump our version. Over the two years, we had to add roughly 50 commits on top of React Native. This makes the process of upgrading React Native extremely painful.

#### JavaScript Tooling

JavaScript is an untyped language. The lack of type safety was both difficult to scale and became a point of contention for mobile engineers used to typed languages who may have otherwise been interested in learning React Native. We explored adopting [flow](https://flow.org/) but cryptic error messages led to a frustrating developer experience. We also explored [TypeScript](http://www.typescriptlang.org/) but integrating it into our existing infrastructure such as [babel](https://babeljs.io/) and [metro bundler](https://github.com/facebook/metro) proved to be problematic. However, we are continuing to actively investigate TypeScript on web.

#### Refactoring

A side-effect of JavaScript being untyped is that refactoring was extremely difficult and error-prone. Renaming props, especially props with a common name like _onClick_ or props that are passed through multiple components were a nightmare to refactor accurately. To make matters worse, the refactors broke in production instead of at compile time and were hard to add proper static analysis for.

#### JavaScriptCore inconsistencies

One subtle and tricky aspect of React Native is due to the fact that it is executed on a [JavaScriptCore environment](https://facebook.github.io/react-native/docs/javascript-environment.html). The following are consequences we encountered as a result:

*   iOS ships with its own [JavaScriptCore out of the box](https://developer.apple.com/documentation/javascriptcore). This meant that iOS was mostly consistent and not problematic for us.
*   Android doesn’t ship its own JavaScriptCore so React Native bundles its own. However, the one you get by default [is ancient](https://github.com/facebook/react-native/issues/10245). As a result, we had to go out of our way to bundle a [newer one](https://github.com/react-community/jsc-android-buildscripts).
*   While debugging, React Native attaches to a Chrome Developer Tools instance. This is great because it is a powerful debugger. However, once the debugger is attached, all JavaScript runs within Chrome’s V8 engine. This is fine 99.9% of the time. However, in one instance, we got bit when toLocaleString worked on iOS and but only worked on Android while debugging. It turns out that the Android JSC [doesn’t include it](https://github.com/facebook/react-native/issues/15717) and it was silently failing unless you were debugging in which case it was using V8 which does. Without knowing technical details like this, it can lead to days of painful debugging for product engineers.

#### React Native Open Source Libraries

Learning a platform is difficult and time-consuming. Most people only know one or two platforms well. React Native libraries that have native bridges such as maps, video, etc. requires equal knowledge of all three platforms to be successful. We found that most React Native Open source projects were written by people who had experience with only one or two. This led to inconsistencies or unexpected bugs on Android or iOS.

On Android, many React Native libraries also require you to use a relative path to node_modules rather than publishing maven artifacts which are inconsistent with what is expected by the community.

#### Parallel Infrastructure and Feature Work

We have accumulated many years of native infrastructure on Android and iOS. However, in React Native, we started with a blank slate and had to write or create bridges of all existing infrastructure. This meant that there were times in which a product engineer needed some functionality that didn’t yet exist. At that point, they either had to work in a platform they were unfamiliar with and outside the scope of their project to build it or be blocked until it could be created.

#### Crash Monitoring

We use [Bugsnag](https://www.bugsnag.com/) for crash reporting on Android and iOS. While we were able to get Bugsnag generally working on both platforms, it was less reliable and required more work than it did on our other platforms. Because React Native is relatively new and rare in the industry, we had to build a significant amount of infrastructure such as uploading source maps in-house and had to work with Bugsnag to be able to do things like filter crashes by just those that occurred in React Native.

Due to the amount of custom infrastructure around React Native, we would occasionally have serious issues in which crashes weren’t reported or source maps weren’t properly uploaded.

Finally, debugging React Native crashes were often more challenging if the issue spanned React Native and native code since stack traces don’t jump between React Native and native.

#### Native Bridge

React Native has a [bridge API](https://facebook.github.io/react-native/docs/communication-ios.html) to communicate between native and React Native. While it works as expected, it is extremely cumbersome to write. Firstly, it requires all three development environments to be properly set up. We also experienced many issues in which the types coming from JavaScript were unexpected. For example, integers were often wrapped by strings, an issue that isn’t realized until it is passed over a bridge. To make matters worse, sometimes iOS will fail silently while Android will crash. We began to investigate automatically generating bridge code from TypeScript definitions towards the end of 2017 but it was too little too late.

#### Initialization Time

Before React Native can render for the first time, you must initialize its runtime. Unfortunately, this takes several seconds for an app of our size, even on a high-end device. This made using React Native for launch screens nearly impossible. We minimized the first-render time for React Native by initializing it at app-launch.

#### Initial Render Time

Unlike with native screens, rendering React Native requires at least one full main thread -> js -> yoga layout thread -> main thread round trip before there is enough information to render a screen for the first time. We saw an average initial p90 render of 280ms on iOS and 440ms on Android. On Android, we used the [postponeEnterTransition](https://developer.android.com/reference/android/app/Activity.html#postponeEnterTransition%28%29) API which is normally used for shared element transitions to delay showing the screen until it has rendered. On iOS, we had issues setting the navbar configuration from React Native fast enough. As a result, we added an artificial delay of 50ms to all React Native screen transitions to prevent the navbar from flickering once the configuration was loaded.

#### App Size

React Native also has a non-negligible impact on app size. On Android, the total size of React Native (Java + JS + native libraries such as Yoga + Javascript Runtime) was 8mb per ABI. With both x86 and arm (32 bit only) in one APK, it would have been closer to 12mb.

#### 64-bit

We still can’t ship a 64-bit APK on Android because of [this](https://github.com/facebook/react-native/issues/2814) issue.

#### Gestures

We avoided using React Native for screens that involved complex gestures because the touch subsystem for Android and iOS are different enough that coming up with a unified API has been challenging for the entire React Native community. However, work is continuing to progress and [react-native-gesture-handler](https://github.com/kmagiera/react-native-gesture-handler) just hit 1.0.

#### Long Lists

React Native has made some progress in this area with libraries like [FlatList](https://facebook.github.io/react-native/docs/flatlist.html). However, they are nowhere near the maturity and flexibility of [RecyclerView](https://developer.android.com/guide/topics/ui/layout/recyclerview) on Android or [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview) on iOS. Many of the limitations are difficult to overcome because of the threading. Adapter data can’t be accessed synchronously so it is possible to see views flash in as they get asynchronously rendered while scrolling quickly. Text also can’t be measured synchronously so iOS can’t make certain optimizations with pre-computed cell heights.

#### Upgrading React Native

Although most React Native upgrades were trivial, there were a few that wound up being painful. In particular, it was nearly impossible to use React Native 0.43 (April 2017) to 0.49 (October 2017) because it used React 16 alpha and beta. This was hugely problematic because most React libraries that are designed for web use don’t support pre-release React versions. The process of wrangling the proper dependencies for this upgrade was a major detriment to other React Native infrastructure work in mid-2017.

#### Accessibility

In 2017, we did a major [accessibility overhaul](https://airbnb.design/designing-for-access/) in which we invested significant efforts to ensure that people with disabilities can use Airbnb to book a listing that can accommodate their needs. However, there were many holes in the React Native accessibility APIs. In order to meet even a minimum acceptable accessibility bar, we had to [maintain our own fork](https://github.com/airbnb/react-native/commits/0.46-canary) of React Native where we could merge fixes. For these case, a one-line fix on Android or iOS wound up taking days of figuring out how to add it to React Native, cherry picking it, then filing an issue on React Native core and following up on it over the coming weeks.

#### Troublesome Crashes

We have had to deal with a few very bizarre crashes that are hard to fix. For example, we are currently experiencing [this crash](https://issuetracker.google.com/issues/37045084) on the _@ReactProp_ annotation and have been unable to reproduce it on any device, even those with identical hardware and software to ones that are crashing in the wild.

#### SavedInstanceState Across Processes on Android

Android frequently cleans up background processes but gives them a chance to [synchronously save their state in a bundle](https://developer.android.com/topic/libraries/architecture/saving-states#use_onsaveinstancestate_as_backup_to_handle_system_initiated_process_death). However, on React Native, all state is only accessible in the js thread so this can’t be done synchronously. Even if this weren’t the case, redux as a state store is not compatible with this approach because it contains a mix of serializable and non-serializable data and may contain more data than can fit within the savedInstanceState bundle which would lead to [crashes in production](https://medium.com/@mdmasudparvez/android-os-transactiontoolargeexception-on-nougat-solved-3b6e30597345).

* * *

This is part two in a series of blog posts highlighting our experiences with React Native and what’s next for mobile at Airbnb.

*   [Part 1: React Native at Airbnb](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c)
*   [_Part 2: The Technology_](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)
*   [Part 3: Building a Cross-Platform Mobile Team](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)
*   [Part 4: Making a Decision on React Native](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)
*   [Part 5: What’s Next for Mobile](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
