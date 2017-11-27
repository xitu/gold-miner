> * 原文地址：[Automate CI/CD and Spend More Time Writing Code](https://www.sitepoint.com/automate-cicd-visual-app-center/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[Cormac Foster](https://www.sitepoint.com/author/cfoster/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/automate-cicd-visual-app-center.md](https://github.com/xitu/gold-miner/blob/master/TODO/automate-cicd-visual-app-center.md)
> * 译者：
> * 校对者：

# Automate CI/CD and Spend More Time Writing Code

_This article was sponsored by [Microsoft Visual Studio App Center](https://appcenter.ms/signup?utm_source=Sitecore&utm_medium=Blog&utm_campaign=appcenter_connect). Thank you for supporting the partners who make SitePoint possible._

What’s the best part about developing software? Writing amazing code.

What’s the worst part? Everything else.

Developing software is a wonderful job. You get to solve problems in new ways, delight users, and see something you built making lives better. But for all the hours we spend writing code, there are often just as many spent managing the overhead that comes along with it—and it’s all a big waste of time. Here are some of the biggest productivity sinkholes, and how we at Microsoft are trying to scrape back some of that time for you.

## 1. Building

What’s the first step to getting your awesome app in the hands of happy users? Making it exist. Some may think moving from source code to binary wouldn’t still be such a pain, but it is. Depending on the project, you might compile several times a day, on different platforms, and all that waiting is time you could have spent coding. Plus, if you’re building iOS apps, you need a Mac build agent—not necessarily your primary development tool, particularly if you’re building apps in a cross-platform framework.

You want to claim back that time, and the best way to do that is (it won’t be the last time I say this) _automation_. You need to automate away the configuration and hardware management so the apps just build when they’re supposed to.

![Build with Microsoft Mobile Center](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/11/1510795993Mobile-Center_Image1_Build-1024x524.png)

Our attempt to answer that need is Visual Studio App Center Build, a service that automates all the steps you don’t want to reproduce manually, so you can build every time you check in code, or any time you, your QA team, or your release managers want to. Just point Build at a Github, Bitbucket, or VSTS repo, pick a branch, configure a few parameters, and you’re building Android, UWP, and even iOS and macOS apps in the cloud, without managing any hardware. And if you need to do something special, you can add post-clone, pre-build, and post-build scripts to customize.

## 2. Testing

I’ve spent many years testing software, and throughout my career, there were three questions I always hated hearing:

“Are you done yet?”

“Can you reproduce it?”

“Is it really that bad?”

In the past, there’s rarely been enough time or resources for thorough, proper testing, but mobile development has exacerbated that particular problem. We now deliver more code, more frequently to more devices. We can’t waste hours trying to recreate that elusive critical failure, and we don’t have time to argue over whether a bug is a showstopper. At the same time, we’re the gatekeepers who are ultimately responsible for a high-visibility failure or a poor-quality product, and as members of a team, we want to get ahead of problems to _increase_ quality, rather than just standing in the way of shipping.

So what’s the answer? “Automation,” sure. But automation that _makes sense_. Spreadsheets of data and folders of screenshots mean nothing if you can’t put it all together. When you’re up against a deadline and have to convince product owners to make a call, you need to deliver information they can understand, while still giving devs the detail they need to make the fix.

![Test with Microsoft Mobile Center](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/11/1510796048Mobile-Center_Image2_test-1024x582.png)

To help with that, we’ve created App Center Test, a service that performs automated UI tests on hundreds of configurations across thousands of real devices. Since the tests are automated, you run exactly the same test every time, so you can identify performance and UX deviations right away, with every build. Tests produce screenshots or videos alongside performance data, so anyone can spot issues, and devs can click down into the detailed logs and start fixing right away. You can spot-check your code by testing on a few devices with every commit, then run regressions on hundreds of devices to verify that everything works for all your users.

## 3. Distribution

So you’ve built an app and it’s performing as it should. Great! But now the iteration really begins. You want to know what people think of it before you push it to end-users. But how? Putting together a beta program is hard enough, but making sure everyone has the most recent version of your app (and if it’s a mobile app, making sure your users can even install the app) is a full-time job—and it’s a job nobody on your team wants.

Once again, _automation_. When you’re ready to push a build, you need to automate the notification process _and_ the app distribution process, and you need to be able to trigger both every time you build (or every time the release manager says so).

![Distribute with Microsoft Mobile Center](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/11/1510796093Mobile-Center_Image3_Distribute-1024x640.png)

Our answer is App Center’s Distribute service. If you have a list of email addresses, you have what you need to get your builds in the hands of internal or beta testers. Create a distribution group, upload a build (or build one from a repo), and Distribute handles the rest. If you think this sounds like [HockeyApp](https://hockeyapp.net/), you’re right. App Center Distribute is the next generation of HockeyApp, integrating its distribution automation with the rest of our CI/CD services. And once you’re done with beta testing, Distribute can also get your app into your users’ hands, with deployment to Google Play, Apple’s App Store, or—for enterprise users—Microsoft Intune.

## 4. Closing the Loop

People often talk about deployment pipelines, but we’re not just after a one-way push. If you can learn what’s happening _after_ your apps have shipped, you can take that feedback to developers and create a closed loop to make your products better, faster. That information takes two forms—analysis of how users interact with your apps, and critically, reporting on how and when those apps fail.

Let’s start with the second, because crashing is about as bad as it gets. When an app fails, you want to know about it fast, but you also need to know how much it really matters. A crash in an obscure feature that affects everyone is usually worse than a total launch failure on just the iPhone 4. App Center Crashes groups similar crash reports and shows you the most affected platforms so you can make intelligent triage decisions. And when you’re ready to start fixing the issues, the crashes are fully symbolicated so you have the information you need to get started. You can automatically create entries in your bug tracker, so developers can start fixing issues without leaving their workflow. Again, more automation means more time writing better code.

For analytics, you want something useful out-of-the-box. App Center Analytics provides the kind of engagement-focused user- and device-level metrics app that owners want to see; things like who’s using which devices, how often, from where, and how long they’re staying. But your app isn’t the same as everyone else’s, so we let you create and track custom metrics, like “booked a ride” or “ordered home delivery.” And if you want deeper analysis, we enable continuous export to [Azure Application Insights](https://azure.microsoft.com/en-us/services/application-insights/).

## 5. Working with what you have

You can theorycraft the perfect CI/CD solution all day long, but it’s all useless if you can’t put it into action. What matters is getting something you can use now, whether that means integrating with existing systems you really love (or can’t get rid of), or just automating pieces of a manual process until you can get to the rest. It’s always better to make even a small step, as long as it’s in the right direction.

Obviously, I’m biased and think you should give our whole system a try, but developers need different things. If you just want to adopt pieces of App Center, we’ve built it to be completely modular. We have REST APIs for every App Center service, and we’ve pre-built integration with services like VSTS. And that’s the way it should be, because you’re building _your_ app, so you should build it _your_ way.

We’d love to have you [try Visual Studio App Center](https://appcenter.ms/signup?utm_source=Sitecore&utm_medium=Blog&utm_campaign=appcenter_connect)—it’s brand new today and free to get started. We want to hear what you think!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
