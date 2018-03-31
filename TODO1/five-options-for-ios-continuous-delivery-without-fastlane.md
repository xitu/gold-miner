> * 原文地址：[Five Options for iOS Continuous Delivery without Fastlane](https://medium.com/xcblog/five-options-for-ios-continuous-delivery-without-fastlane-2a32e05ddf3d)
> * 原文作者：[Shashikant Jagtap](https://medium.com/@shashikant.jagtap?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/five-options-for-ios-continuous-delivery-without-fastlane.md](https://github.com/xitu/gold-miner/blob/master/TODO1/five-options-for-ios-continuous-delivery-without-fastlane.md)
> * 译者：
> * 校对者：

# Five Options for iOS Continuous Delivery without Fastlane

![](https://cdn-images-1.medium.com/max/800/1*VttABPhOQPcSnjJTSkxykg.jpeg)

_Original Article published on XCBlog_ [_here_](http://shashikantjagtap.net/five-options-for-ios-continuous-delivery-without-fastlane/)

Fastlane [tools](https://fastlane.tools/) automate entire iOS CI/CD pipelines and allow us to keep an iOS infrastructure as code. Fastlane is set of tools to automate almost everything from analyzing, building, testing, code signing and archiving iOS apps. However, if you look inside, it’s nothing but a Ruby layer on top of native Apple developer tools. It might be possible that Fastlane might have saved some time in some cases but its worth considering how much developer hours have been wasted by Fastlane by frequent breaking changes. There are many developers hour wasted in constant learning of Ruby and Fastlane’s way of automating things. Like [CocoaPods](https://cocoapods.org/), Fastlane might be another white elephant in your iOS project that uses Ruby which is nothing to do with iOS development. It’s not that difficult to learn some native Apple developer tools and remove Ruby and other third-party tools like Fastlane completely from your iOS development toolbox. In this post, we will cover what are the problems that iOS developers are facing using Fastlane and what are the current alternatives to Fastlane.

### Five Fastlane Problems

Fastlane claims that it saved developers hours by automating common tasks. It might be true in the situations where Fastlane is working as expected but it’s also important to consider how many developers hours wasted by Fastlane in terms of setup, debugging and managing. In this section, we will see what are the common issues that iOS developers might be facing using Fastlane.

### 1. Ruby

The first and major issues to use Fastlane inside the iOS project is [Ruby](https://www.ruby-lang.org/en/). Generally, iOS developers aren’t that much skilled in Ruby but in order to use tools like Fastlane or CocoaPods, they have to learn Ruby which has nothing to do with actual iOS development. Setti g up Fastlane tools requires the good understanding of how Ruby and [RubyGems](https://rubygems.org/) and [Bundler](http://bundler.io/) works. There is [Swift version](https://docs.fastlane.tools/getting-started/ios/fastlane-swift/) of Fastlane recently announced to get rid of Ruby but its just Swift executing Ruby commands under the hood. I doubt the usability of the Swift version of Fastlane. I have written my initial impressions in [this](https://dzone.com/articles/first-impressions-of-fastlane-swift-for-ios) post. Fastlane has good documentation but iOS developers still have to use Ruby to script all the infrastructure for automating iOS release pipelines.

### 2. Frequent Breaking Updates

Apple keeps changing the native tools which in turns constantly breaks the Fastlane tools. They need to always chase with Apple and Google ( In case of Android ) to accommodate those changes in the Fastlane. This requires Fastlane developers to implement these features and release the new version of Fastlane. The most of the time updating Fastlane version requires updating the existing Fastlane scripts if Fastlane versions aren’t managed by Bundler. There might be frequent build breakage due to updates and iOS developers need to spend the time to analyze what has been changed in the Fastlane and fix the builds accordingly. This kind of breaking updates disturb the main development flow of iOS developers and it ends up wasting hours to fix the build. One of the pain points of using Fastlane is the options configured in the previous versions of Fastlane doesn’t always works with the newer version and if you search for the solution then you end up having multiple solutions for the same problems for different versions of Fastlane.

### 3. Time Consuming Setup and Maintenance

Although Fastlane provides great getting started guide with template code, it’s not fairly straightforward to script all the things that we need to automate iOS release pipelines. We probably need to customize the options as per our need which requires how that options are coded in the Fastlanes. We can then use different lanes to scripts our pipeline. It requires a lot of time to learn about Fastlane and Ruby toolbox to get everything set up. The job isn’t done when you setup everything needed, it requires constant ongoing maintenance per Fastlane update as mentioned above.

### 4. Hard To Contribute

There might need to configure iOS release pipelines as per the company-specific rules or require Fastlane to do something customized. The only option to do this is writing [plugins](https://docs.fastlane.tools/plugins/available-plugins/) for Fastlane. Currently, the only way to write a plugin is to write a Rubygem which can be installed as Fastlane plugin. Again it requires the deep understanding of Ruby ecosystem that normally iOS developers aren’t skilled. It’s unfortunate that iOS developers can’t contribute to the tool they are currently using in the toolbox. On top of this, the process of [contributing](https://github.com/fastlane/fastlane/blob/master/CONTRIBUTING.md) to Fastlane is time-consuming and full of automated bots. It starts with creating a Github issue as a proposal, leading to the endless discussions. You can read more about Fastlane contributing guide [here](https://github.com/fastlane/fastlane/blob/master/CONTRIBUTING.md).

### 5. Open Issues on Github

There are multiple [issues](https://github.com/fastlane/fastlane/issues) open on GitHub and some of them are closed by automated bots without providing the correct solution to users. The good example of this would be, how I wasted multiple days to figure out if the Fastlane [match](https://docs.fastlane.tools/actions/match/) support enterprise app build the distribution with Xcode 9\. While searching for the solution, I found there are other people looking for the solution as well. [This](https://github.com/fastlane/fastlane/issues/10895) is the example of unresolved issue closed by Fastlane bot without providing the proper solution. I have tried multiple solutions provided on the issues like [11090](https://github.com/fastlane/fastlane/issues/11090),[10543](https://github.com/fastlane/fastlane/issues/10543),[10325](https://github.com/fastlane/fastlane/issues/10325), [10458\.](https://github.com/fastlane/fastlane/issues/10458) After reading all these things, I couldn’t figure out what would be the export method that works for enterprise builds. Some of the users saying it works when you use adhoc while other are saying Ad-hoc or AdHoc or enterprise. You can imagine how much time it takes to test each export method by archiving an app. I saw that CircleCI users are also got [frustrated](https://twitter.com/m4rr/status/961047312666710016) with code signing issues with Fastlane Match.

This is the small list of the problems that Fastlane has created within your iOS project but you might have the different story and different issues that you never spoke up.

### Five Fastlane Alternatives

Now that, we have seen some of the issues of using Fastlane inside the iOS project. The question is can we remove Fastlane from iOS projects completely. The answer is YES. However, you need to spend some time to understand the iOS build process and few native Apple command line developer tools. I would say it’s worth investing time to learn about native Apple developer tools than learning third-party frameworks. You will never regret learning native Apple command line developer tools. However, if you don’t have time to learn these then there are some other free and paid services that handle everything for you that Fastlane does. Currently, we have following free and paid alternatives for Fastlane

Top 5 Alternatives to Fastlane

*   Native Apple Developer tools (Free)
*   Xcode Server ( Free )
*   Cloud-Based CI Services ( Paid )
*   Apple + BuddyBuild (God Knows)
*   Swift Based Alternatives ( Free but not ready)

### 1. Native Apple Developer Tools

Nothing beats learning native Apple developer tools and write custom scripts as per the requirement of your build and deployment process. Apple has provided command line developer tools to do almost everything that we want. Remember that Fastlane and similar tools also use the native Apple developer tools under the hood. The biggest benefit of the using Apple developer tools is it can’t be broken by anyone apart from Apple and they are backward compatible in most of the cases. Apple has documented these tools and most of the tools have man pages to see all the options provided by those tools. In order to script the iOS build pipelines, we need to know about following major tools

*   [xcodebuild](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html) — Analysing, building, testing and archiving iOS app. This is the father of all command so it’s important to learn this tool.
*   [altool](http://help.apple.com/itc/apploader/#/apdATD1E53-D1E1A1303-D1E53A1126): upload .ipa to iTunes Connect
*   [agvtool](https://developer.apple.com/library/content/qa/qa1827/_index.html): To manage version and build numbers
*   [codesign](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/codesign.1.html): Manage code signing for iOS apps
*   [security](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/security.1.html): Manage Certificates, Keychains, and Profiles

There are supplementary utilities like [simctl](https://medium.com/xcblog/simctl-control-ios-simulators-from-command-line-78b9006a20dc), [PlistBuddy](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/PlistBuddy.8.html), [xcode-select](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcode-select.1.html) etc that needs sometimes in order to deal with simulators, Plist files, and Xcode versions etc. Once you get familiar with these tools, you feel confident about scripting the iOS deployment pipelines on your own and able to fix any issues. In most cases, few lines of code can land your iOS app to iTunes Connect. I have written an article on deploying the iOS app from command line [here](https://medium.com/xcblog/xcodebuild-deploy-ios-app-from-command-line-c6defff0d8b8) but we also need to know [code signing](https://developer.apple.com/support/code-signing/) bit to understand the entire flow. Learning and applying Apple developer tools in the iOS build process takes some time but its once for all and you don’t need to learn about any third party frameworks like Fastlane.

### 2. Xcode Server

[Xcode Server](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/xcode_guide-continuous_integration/) is the Continuous Integration service provided by Apple. With Xcode 9 release, Apple enhanced Xcode Server a lot with the lot of new features that automated almost everything under the hood. Xcode Server is tightly coupled with Xcode which makes iOS developers experience. With Xcode Server we can analyze, test, build and archive an iOS app without writing a single line of code or script. You probably don’t need any tooling to automate build process if you use Xcode Server for iOS Continuous Integration. You can read more about the Xcode Server features [here](https://medium.com/xcblog/xcode9-xcode-server-comprehensive-ios-continuous-integration-3613a7973b48). However, there is one manual step that we need to do to upload binary to iTunes Connects or some other platform, Currently, Xcode Server cannot upload binary to iTunes Connect but it can be easily achieved with using altool as post-integration script of Xcode Server bot.

If you can’t manage mac Mini servers in-house then you can hire some Mac Mini from services like [Mac Stadium](https://www.macstadium.com/) to get on with Xcode Server instance.

### 3. Cloud-Based CI Services

There are various cloud-based CI Services like [BuddyBuild](https://www.buddybuild.com/), [Bitrise](https://www.bitrise.io/), [CircleCI](https://circleci.com), [Nevercode](https://nevercode.io/) which offers Continuous Integration as well as Continuous Delivery services. BuddyBuild has been acquired by Apple recently and we will cover that in the next session. These cloud-based CI services handles all the iOS build process including testing, code signing and deploying apps to specific services or iTunes connects. We can also write our own custom scripts to achieve specific needs. These services completely remove the need for Fastlane or any kind of scripting from iOS projects. However, these services are not free and take control of your project. If you don’t have skills script the CI/CD infrastructure then this will be the good option. I have done critical evolution all these Cloud-based CI services on my personal project and written my conclusions [here](https://dzone.com/articles/olympics-of-top-5-cloud-ios-continuous-integration). Hope you will find those comparisons useful while selecting the right service for your iOS project

### 4. Apple + BuddyBuild

Apple [aquired](https://techcrunch.com/2018/01/02/apple-buys-app-development-service-buddybuild/) BuddyBuild at the start of the year that means Apple and BuddyBuild might be working together to provide the painless Continuous Integration and Delivery services for iOS developers. it would be interesting to see what Apple and BuddyBuild will build together and present at [WWDC 2018](https://developer.apple.com/wwdc/). There are few things that we may [expect](https://dzone.com/articles/apple-acquires-buddybuild-oh-my-xcode-server) like Apple will keep Xcode Server as self-hosted solutions (free) and integrate BuddyBuild inside Xcode as the Cloud-based solution (paid or free) or Apple may completely kill Xcode Server and only keep BuddyBuild as service which might be free or paid. However, in all cases, there won’t need to explicitly script infrastructure unless needed. This will also completely remove the need for the tools like Fastlane. The only thing we can do currently is waiting until WWDC 2018.

### 5. Swift Options ( Not Ready)

Fastlane has recently added support to configure the lanes using [Swift](https://docs.fastlane.tools/getting-started/ios/fastlane-swift/) rather Ruby. However, currently, implementation isn’t usable as its just Swift executing Ruby commands under the hood. It adds lots of irrelevant Swift files in the projects which ideally should be provided as Swift package (SDK) that can be distributed through CocoaPods, Carthage or Swift Package Manager. I have written my first impressions of Fastlane Swift [here](https://dzone.com/articles/first-impressions-of-fastlane-swift-for-ios). Another solution is [Autobahn](https://github.com/AutobahnSwift/Autobahn) which is purely Swift implementation Fastlane but its too early in the development and cannot be used until the development finishes. Unfortunately, we have to wait for these swift based solutions, they are not ready yet to use in the current iOS projects. However, we can hope that sooner or later there will be the feasible solution which will allow iOS developers to write configuration code in Swift. In my opinion, Swift is not scripting language but can be used as scripting if needed.

### Tips for Choosing Right Options

Now that, we have seen all the options to setup Continuous Delivery without using Fastlane tools. The next thing is to decide which options set for your iOS project. It depends on skills and experience of engineers working in your team.

*   If the team has iOS engineers without any previous knowledge of CI/CD then it’s worth going for Cloud-Based CI solutions that handles everything.
*   If the team has few iOS engineers having some experience with CI/CD then its worth giving Xcode Server a try as it’s fairly easy to configure and use.
*   If the team has experience iOS developers with sounds knowledge of native tools then its worth scripting build pipelines
*   Its good idea to wait until WWDC 2018 and see what Apple and BuddyBuild will present on stage.

### Conclusion

With the use of native Apple developer tools, we can script our entire CI/CD pipeline for the iOS project which removed the need for the third-party tool like Fastlane inside iOS projects.However, It requires time and efforts to learn the native Apple developer tools. Other options to use Xcode Server or Cloud-Based CI solutions to remove needs of scripting release pipelines.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
