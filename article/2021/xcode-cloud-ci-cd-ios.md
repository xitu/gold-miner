> * 原文地址：[Xcode Cloud Brings CI/CD to iOS App Development](https://www.infoq.com/news/2021/06/xcode-cloud-ci-cd-ios/)
> * 原文作者：[Sergio De Simone](https://www.infoq.com/profile/Sergio-De-Simone/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/xcode-cloud-ci-cd-ios.md](https://github.com/xitu/gold-miner/blob/master/article/2021/xcode-cloud-ci-cd-ios.md)
> * 译者：
> * 校对者：

# Xcode Cloud Brings CI/CD to iOS App Development

At WWDC21, Apple announced [Xcode Cloud](https://developer.apple.com/documentation/Xcode/Xcode-Cloud), a continuous integration and delivery (CI/CD) system to help developers build, test, and distribute iOS apps. Still in beta, Xcode Cloud supports both releasing to TestFlight and on the App Store.

> Xcode Cloud is a CI/CD system that uses Git for source control and provides you with an integrated system that ensures the quality and stability of your codebase. It also helps you publish apps efficiently.

According to Apple, Xcode Cloud [makes it easy](https://developer.apple.com/documentation/Xcode/Configuring-Your-First-Xcode-Cloud-Workflow) to build and test automatically on multiple iOS simulators. In case of errors, Xcode Cloud will send a notification so developers can promptly fix them. This basic workflow covers the continuous integration side of the equation. Optionally, when a build succeeds, it can be automatically distributed to team members through TestFlight or submit it for review before publishing in the App Store. Continuous deployment can be automatically triggered by any change to the code.

Xcode Cloud is based on Git and requires your code to be on GitHub, GitLab, or BitBucket. Indeed, the upcoming version of Apple official IDE, Xcode 13, embraces collaboration using pull requests (PR) and allows developers to create, view, and comment on PRs, as well as merge changes into their codebase. Xcode Cloud can thus detect new pull requests, create a temporary branch, and set up a build environment to build the project and run its tests. Xcode Cloud is also able to [manage dependencies](https://developer.apple.com/documentation/xcode/making-dependencies-available-to-xcode-cloud) and supports [custom build scripts](https://developer.apple.com/documentation/xcode/writing-custom-build-scripts) to perform a specific task at a designated time.

While Xcode Cloud appears to follow Apple's philosophy of providing easy-to-use tools that address a very specific use case, namely using CI/CD for iOS apps without the need to set up a whole infrastructure, it also brings with it a number of limitations, such as no support for "configuration as code" nor for DevOps platforms, etc. This may be an issue or not depending on the size of your project and organization.

Previous to Xcode Cloud, iOS developers could adopt CI/CD using [fastlane](https://fastlane.tools), a tools developed by Google and supporting both iOS and Android.

Xcode Cloud will become available with Xcode 13, which should come out of beta next Fall.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
