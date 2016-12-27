> * 原文地址：[React Native at WalmartLabs](https://medium.com/walmartlabs/react-native-at-walmartlabs-cdd140589560#.aynnbnjy1)
* 原文作者：[Keerti](https://medium.com/@Keerti)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[]()
* 校对者：[]()

# React Native at WalmartLabs

![](https://cdn-images-1.medium.com/max/1600/1*FgddJm_KiUTCA5mh_fM7_Q.jpeg)

Here at [Walmart](http://careers.walmart.com/), the customer is always #1, so we’re constantly on the lookout for ways we can improve upon the shopping experience we provide to our customers. The Walmart app, as it currently stands, has a number of embedded web views, and we’ve found that these implementations fall below the standard that both we and our customers demand from the app. The performance of the hybrid web view implementations aren’t great, even on high-end devices, and any semblance of a native feel is absent. Not only that, but because web views are heavily dependent upon network requests (we use server-side rendering for our web implementation), users with slower connections can have a rough experience. So, we were wondering: “Is there a way we can revamp or replace the current implementations to provide a better, smoother experience for our customers?” And, we started on the hunt for the answer.

### Potential Solutions

After some brainstorming, we came up with the following solutions:

1. Pure Native implementation (no more web views)
2. React Native

![](https://cdn-images-1.medium.com/max/1200/1*iUQwmDC3ym3JJe_iSLZQ7A.png)

Native implementation is great in theory, but practically, we need to think about productivity/code sharing/time-to-market, which is where a cross-platform framework like React Native comes in. There are other cross-platform mobile development frameworks outside of React Native, such as PhoneGap, Xamarin, and Meteor, but given our current web codebase uses React and Redux, it made the most sense to consider React Native before any other cross-platform framework — not to mention, it’s one that’s fairly stable and likely to remain popular for a while.

Here are the benefits we observed with React Native:

**Productivity**

- 95% of the codebase is shared between iOS and Android
- No knowledge sharing required, as each feature is implemented by a single team
- *Developer experience is awesome*. No need to restart packager to see simple changes
- React Native is written in JavaScript. We can leverage programming skills/resources across the organization

**Code Sharing**

- FrontEnd/Presentation code can be shared between iOS and Android
- Business logic (redux store) can be shared with Web applications as well
- Lots of code reusability between platforms

**App-store approval**

- No need to go through the app store approval process. We can host the bundle on our own server and do over-the-air updates

**Time-to-market**

- Very fast
- We have control over the release dates
- Both platforms can be released on the same day and time

**Performance**

- React Native provides nearly identical performance to native

**Animations**

- React Native provides extremely smooth animations because the code is converted to native views before rendering

**UX**

- We can have platform-specific UI design

**Automation**

- Same automation suite can run on both iOS and Android

### **Performance**

We had a few goals in mind when we did our performance testing at [WalmartLabs](http://www.walmartlabs.com/team/). We wanted to know how React Native stacked up against its competition, based on measures like RAM usage, FPS, CPU utilization, etc., but we also wanted to investigate React Native’s capacity to scale — since potentially React Native could become the standard mobile technology for the entire enterprise. Since this project is an experiment for WalmartLabs, our short-term goal was to prove that this technology had a performance profile equivalent to or better than the current solution. What we’re after in the long-term is to have performance testing integrated with our CI, like what [Facebook](https://code.facebook.com/posts/924676474230092/mobile-performance-tooling-infrastructure-at-facebook/) does, so we can test the effect each of our changes is having on overall app performance.

***The trouble with tribbles***

As of right now, performance testing React Native is kind of a pain. Right off the bat, due to the two different platforms, there are two sets of tools for gathering data. Apple has provided Instruments for testing, which provided us with most of the measurements we were after. Android requires the use of multiple utilities to gather all the data we wanted. In addition, for many of the measurements there’s no easy way to get a stream of the data, so some measurements had to be estimated.

Facebook has tried to bridge the gap between Android and iOS performance testing by providing a performance monitor built into the React Native developer menu. Unfortunately, this solution is far from perfect. On iOS it provides RAM use, FPS data, as well as a host of React Native related measurements, however for Android, the perf monitor only provides FPS data. In the future, I would love to see the provided measurements standardized across both platforms, if possible.

**Shut up and tell me how React Native did!**

Ok, fine, but do be aware that the performance we’re reporting is based off OUR app, and may not be representative of YOUR app. However, I will try to provide general conclusions that can be drawn from our tests.

The data we’ve gathered is promising. It has shown that React Native is indeed a viable solution for mobile applications big and small. In the areas of graphical performance, RAM usage, and CPU, every measure we took was comparable to or better than our current hybrid solution, and this held true for both platforms. The overall feel of the app was significantly improved, and provides a far superior user experience over hybrid.

React Native is fast — really fast. While we didn’t have a pure native version to test against, it’s safe to say that as far as look and feel goes, writing this app in pure native wouldn’t provide any significant benefit over React Native. Overall, we’re very happy with the performance of React Native thus far, and we’re hopeful that the results we’ve gathered will be met with approval from the business side, and ultimately our users.

### Testing

To ensure the quality of our React Native code, we aim for 100% test coverage for both unit tests and integration tests.

#### Integration tests

The Walmart iOS and Android apps are built by a collaboration of hundreds of engineers. We use our integration tests to ensure that our React Native code remains functional as the code base continues to evolve.

At Walmart, we need to support a wide array of devices and operating systems. [Sauce Labs](https://saucelabs.com/) allows us to run our integration tests on several combinations of iOS and Android hardware and OS versions. Running integration tests on multiple devices takes a long time, so we do it only once every night.

We also use our integration tests to prevent regressions. We’ve hooked up our [TeamCity CI](https://www.jetbrains.com/teamcity/) with GitHub Enterprise to run our tests on every pull request. Unlike the nightly job, with pull requests we only run the tests on one device. But even that could potentially take longer than is feasible, so we employ some tools to cut down this time. [Magellan](https://github.com/TestArmada/magellan), which is one of our open source projects, allows us to run tests in parallel to reduce testing time significantly.

The tests themselves are written in JavaScript, run by Mocha, and use [Appium](http://appium.io/) commands to control the mobile simulators. React Native allows us to set a `testID` property on each component. These `testID`s act as CSS class names. We use them to precisely and conveniently specify a component using XPaths and interact with it for the purpose of the test.

#### Unit tests

We use unit tests to exercise our React Native components in isolation and prevent unintentional changes.

We use common React unit testing tools, such as Mocha, Chai, Sinon, and Enzyme. But React Native has some [unique challenges](https://formidable.com/blog/2016/02/08/unit-testing-react-native-with-mocha-and-enzyme/) because its components have environment [dependencies](http://airbnb.io/enzyme/docs/guides/react-native.html) that prevent it from running on Node. [react-native-mock](https://github.com/lelandrichardson/react-native-mock) solves this problem for us because it provides mocked React Native components that don’t break when run outside of iOS or Android. And when we find ourselves needing to mock additional dependencies, we use the [rewire](https://github.com/jhnns/rewire) Node module.

#### Reusability

We are leveraging the same automation test suite to run on both iOS and Android.

### Deployment

One of the main advantages of React Native is the ability to push quick bug fixes over-the-air, bypassing app stores, which means the React Native JavaScript bundle will be hosted on a server and retrieved by the client directly, similar to how the web works.

However, one challenge that React Native presents is that for the JS bundle to work, there has to be a compatible React Native counterpart on the native side. If you upgrade the native side to the latest React Native, and the user updates their app but they download an old bundle, the app will break. And if you update the bundle to match the latest native side and serve it to user that still hasn’t updated their app, it will break too.

Tools like Microsoft [CodePush](https://github.com/Microsoft/react-native-code-push) can be used to map bundles to the correct app versions. But supporting multiple versions of the app at the same time is an overhead that should be considered when deciding to use React Native.

### Challenges

#### Differences between iOS and Android

There are enough inconsistencies between the functionality of React Native on iOS and on Android to make it tricky to support both platforms. Several React Native behaviors and style implementation differ between the platforms. For example, the style property `overflow` is supported on iOS but not Android. Component properties can also be platform specific. In the React Native documentation you can see many properties and features marked as “Android only” or “iOS only.” Test automation code also needs to be tweaked for each platform.

We have found that iOS has more features than Android, so for a product that targets both platforms, it may make sense to develop with an Android-first approach.

#### Development and debugging

One pain point in our experience has been how React Native code behaves differently in debug mode vs regular mode due to the fact that React Native utilizes a [different JavaScript engine for each of these two modes](https://facebook.github.io/react-native/docs/javascript-environment.html#javascript-runtime). When a bug is particular to regular mode, it can naturally be hard to debug because it’s irreproducible in debug mode.

### Conclusion

React Native has some great things going for it. The defining feature of React Native, and arguably its best selling point, is that it’s cross platform — allowing for simultaneous development on iOS and Android by the same team, which can cut labor costs roughly in half. Speaking of the team, JavaScript developers are plentiful, and the mobile-specific skills required are minimal, meaning appropriately skilled labor is readily available. Initial development, as well as development of incremental features, is very quick and therefore you can satisfy your customers’ needs faster than your competition. As icing on the cake, applications written in React Native generally speaking have comparable or even potentially superior performance to those written as native applications.

While React Native does have some fantastic selling points, there are also a few things you need to keep in mind before embarking upon a project with React Native. Firstly, while React Native does a good job bridging the gap between iOS and Android, you’re not going to achieve complete parity between the two operating systems. There are certain things that one platform can do that the other can’t handle, mostly related to styling views, but also more important considerations such as performance testing. While the open source community is fantastic about developing and releasing new features and performance tweaks, actually upgrading your React Native version tends to be a massive pain, especially if you have a platform built around React Native like we do at Walmart.

We strongly believe that React Native is a fantastic framework. It’s done everything we wanted of it, and it’s done so admirably. While it does have a few issues, those issues are overshadowed by the mountain of benefits you get from using it. From startups to Fortune 500 companies, if you’re considering taking on a new mobile project, consider using React Native — we know you won’t regret it.

**Credits**

This article was written as a collaborative effort by the engineers of the React Native team at WalmartLabs — [Matt Bresnan](https://medium.com/u/bbf6a1d22e3), [M.K. Safi](https://medium.com/u/a4da983a03a0), [Sanket Patel](https://medium.com/u/3736ca4de438) and [Keerti](https://medium.com/u/5d46542ee15f).
