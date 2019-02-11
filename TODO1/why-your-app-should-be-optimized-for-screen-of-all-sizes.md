> * 原文地址：[Why your app should be optimized for screens of all sizes](https://medium.com/googleplaydev/more-than-mobile-friendly-547e44bc085a)
> * 原文作者：[Natalia Gvak](https://medium.com/@nataliagvak)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-your-app-should-be-optimized-for-screen-of-all-sizes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-your-app-should-be-optimized-for-screen-of-all-sizes.md)
> * 译者：MirosalvaSun
> * 校对者：

# Why your app should be optimized for screens of all sizes
# 为什么你的应用需要对各种尺寸屏幕做适配优化？

See how Gameloft, Evernote, Slack, and 1Password have optimized for Chrome OS   
查看这些应用：Gameloft、Evernote、Slack、1Password 如何适配 Chrome OS 系统。

![](https://cdn-images-1.medium.com/max/1000/1*qstDYCF2lqMH_aQd_81cWA.png)

Since we launched our first Chromebooks in 2011, the growth of Chrome OS has been incredible. Today, Chromebooks range from traditional laptops to convertibles and tablets that are available in over 10,000 stores — thanks to close partnerships with top OEMs, including Samsung, Dell, and HP, among many others — and we’re only going to keep expanding. It’s been an exciting period of growth for us, but even more so for developers.  
自从2011年，我们发布第一批 Chromebooks 起，Chrome OS 系统的变化令人惊奇。如今，Chromebooks 使用范围从传统笔记本电脑扩展到可折叠翻转笔记本和平板电脑，多亏了与领先的 OEM 厂商的紧密合作，与这些电脑的集成应用在超过10000多家商店中可购得，包含 Samsung、Dell、HP 及其他品牌电脑，并且我们还会继续扩张。对我们来说这一直是令人激动的增长阶段，对开发者来说更是如此。

The evolution of Chrome OS presents an amazing opportunity for developers to boost their reach across a wider variety of devices and screens. By optimizing their apps for wider screens on Chrome OS, dev teams can drive higher engagement and reach even more users with immersive experiences.  
Chrome OS 的演变为开发者在提升多类型设备和屏幕上的研究能力上带来独特的机遇。通过优化基于 Chrome OS 系统的宽屏应用，开发者团队可以驱动更高的参与度并通过身临其境的体验来触达更多的用户。 

### Tapping into a wider appeal for wider screens  
### 为更宽屏幕挖掘更广泛的影响力  

Much of our growth has been fueled by new ways that people consume and engage with content. A lot of people use more than one type of device every day, and the lines between desktop and mobile experiences are getting blurrier. Today, consumers demand versatility. We’re seeing people shift their focus to devices with larger, wider screens that allow them to easily access the content they want, anywhere and anytime.   
我们的大多数增长是由用户消费和接触内容的新方式来助推的。许多人每天使用不止一种类型的设备，并且台式机和移动设备的界限并得越来越模糊。如今，消费者需求设备的多功能性，我们发现人们对设备的关注点转移到更大、更宽的屏幕，以便他们随时随地可以便捷地获取所需内容。

Last year, we added our four-in-one, high-performance Chromebook — [Google Pixelbook](https://store.google.com/us/product/google_pixelbook) — to the Chrome OS family. This October, we introduced the first-ever premium tablet made by Google to run Chrome OS: [Google Pixel Slate](https://store.google.com/us/product/pixel_slate?hl=en-US). Along with a rich display and performance that’s ideal for using mobile apps, the Pixel Slate also comes with a detachable keyboard that gives users a familiar laptop feel.  
去年，我们为 Chrome OS 家族增加了四合一、高性能 Chromebook:[Google Pixelbook](https://store.google.com/us/product/google_pixelbook)。今年十月，我们发布了 Google 研发的运行 Chrome OS 系统的首款高级平板电脑：[Google Pixel Slate](https://store.google.com/us/product/pixel_slate?hl=en-US)。Pixel Slate 搭配了一块可拆卸键盘，可以为用户提供熟悉的笔记本体验，同时它的高分辨率和性能对移动应用来说是理想选择。

![](https://cdn-images-1.medium.com/max/800/0*5aXo82iDOfDi9_wX)

Like other devices powered by Chrome OS, both of these devices combine access to millions of mobile apps with a brilliant, large-screen display. Developers can reach even more users by [adapting their apps for Chrome OS](https://developer.android.com/topic/arc/optimizing) in different ways:  

1.  Optimizing designs for wider screens
2.  Landscape mode
3.  Multi-window management
4.  Keyboard, mouse, and stylus input


像其他基于 Chrome OS 系统的设备一样，Pixel Slate 的两款设备可以将数百万移动应用与出色的大屏幕显示器连接起来。开发者可以通过将他们的[应用适配 Chrome OS](https://developer.android.com/topic/arc/optimizing)后来触达更多用户。

1.  宽屏的优化设计
2.  景观模式 
3.  多窗口管理
4.  键盘、鼠标、手写笔输入 


### How leading dev teams have optimized for Chrome OS  
### 领先开发团队是如何做 Chrome OS 优化的

#### Gameloft’s Asphalt 8: Airborne
#### Gameloft 公司的游戏应用 狂野飙车8：极速凌云
Asphalt 8: Airborne is a racing game that’s all about extreme speed and complete control. The design team at Gameloft always wants its games to be available on the latest portable hardware, so as soon as the Chromebook hit the market, the team saw a new home for its Asphalt series.  
狂野飙车 8：极速凌云 是一个与极速和超强控制感相关的赛车类游戏。Gameloft 公司的设计团队一直希望他们的游戏可以在最新的便携设备上运行，因此 Chromebook一经上市，该公司团队便预视了自家 Asphalt 系列游戏新战场。

Because Chrome OS treats a physical keyboard just like an external keyboard on an Android phone, Asphalt 8: Airborne could [support keyboard controls using APIs](https://developer.android.com/topic/arc/input-compatibility) from the [Android Platform SDK 26](https://developer.android.com/studio/releases/platform-tools). This also enabled the UI to automatically switch between touchscreen and keyboard mode. After making the adjustments, Gameloft was able to run Android application packages at even higher performance levels than native apps, allowing it to maintain the series’ breathtaking graphics and breakneck speeds on Chrome OS. Even better, it only took Gameloft’s developers a few days to completely integrate the new control schemes to the game.  
由于 Chrome OS 系统将物理键盘作为类似于安卓手机上的外设键盘，狂野飙车 8：极速凌云，基于[安卓平台开发套件 SDK26](https://developer.android.com/studio/releases/platform-tools)可以[通过 APIs 支持键盘控制](https://developer.android.com/topic/arc/input-compatibility) 。这样可以使 UI 界面在触摸屏和键盘模式间自由切换。完成了适配后，Gameloft 公司可以使安卓应用包的运行时性能水平比原生应用更高，且在 Chrome OS 上保有美到窒息的图形和令人惊叹的极致速度。

After the optimizations, Asphalt 8 saw a 6X increase in daily active users and a 9X boost in revenue from Chrome users. Now, designing for larger screens is a rule of thumb at Gameloft — the latest edition of the series, Asphalt 9: Legends, is now [available on the Chromebook](https://play.google.com/store/apps/details?id=com.gameloft.android.ANMP.GloftA9HM&hl=en_US).  
优化之后，狂野飙车 8 实现了 6 倍的日活用户增长以及 9 倍的来自 Chrome 用户的收入增长。现在，为了更大屏设计成为 Gameloft 公司游戏系列最新版本的设计经验法则，狂野飙车 9：传奇 现在已经[可在 Chromebook 下载](https://play.google.com/store/apps/details?id=com.gameloft.android.ANMP.GloftA9HM&hl=en_US)。

#### Evernote and Slack
#### Evernote 应用和 Slack 应用

One of [Evernote’s](https://developer.android.com/stories/apps/evernote) key features is translating touchscreen handwriting into text, which people tend to use more often on larger screens. To make its app even easier to use across devices and platforms, Evernote’s development team used Google’s low-latency stylus API to quickly implement touchscreen handwriting and enhanced layouts for larger screens. The API allows apps to bypass parts of the OS and draw directly on the display, so Evernote users feel like they’re actually drawing and writing on paper.  
[Evernote应用](https://developer.android.com/stories/apps/evernote) 的一个关键功能是可以将触摸屏上的手写转化成文本，用户更倾向于在更大屏幕上使用这一功能。为了让应用更易于跨设备和平台使用，Evernote 的开发团队使用谷歌的低延迟手写笔 API 接口来快速实现触摸屏手写和更大屏幕上的增强布局。

Thanks to its new Chrome OS experience, the average Evernote user is spending 3X more time on larger screen devices and 4X more time when using the Google Pixelbook.  
得益于他们在新 Chrome OS 上经验，Evernote 用户的平均使用时长在更大屏幕上增加了 3 倍，在 Google 的 Pixelbook 上增加了 4 倍。

Meanwhile, the development team at Slack optimized its popular messaging app for Chrome OS by setting up keyboard shortcuts for its most commonly used functions. When users write a message on a Chromebook, they can simply hit the “Enter” key — just like you would on mobile — rather than taking the extra step to click “Send” with their mouse.  
同样的，Slack 应用的开发团队为 Chrome OS 系统上运行的其流行的消息应用做了键盘快捷键来快速启动常用功能的优化适配。当用户在 Chromebook 上编写消息时，他们可以简单的敲击 『Enter』键（就像在手机上做的那样），而不需要再用鼠标多点一步『Send』键。


- YouTube 视频链接：https://youtu.be/YlQVNyTDI6Y

#### 1Password 
#### 1Password 应用

1Password worked with the Chrome OS team to drastically improve its user experience in just six weeks. To ensure the app made the best use of [window space at any screen orientation and size](https://developer.android.com/topic/arc/window-management), the development team combined its existing designs for phones and tablets to deliver a responsive layout when users resized the app window. The team also used Chrome OS’s drag-and-drop feature so app users can easily drag content between 1Password and other Android apps on Chrome OS.  
1Password 应用团队与 Chrome OS 团队通过仅 6 个月的合作就大幅提高了该应用的用户体验。为确充分利用好[在任意屏幕方向和尺寸上的窗口空间](https://developer.android.com/topic/arc/window-management)，开发团队将已有的为手机和平板电脑所做设计与提供一个响应式布局技术结合来应对用户调整屏幕大小的操作。开发团队也使用了 Chrome OS 的拖拽功能，以便于用户可以轻松地将内容在 1Password 与 Chrome OS 上其他安卓应用之间进行拖动。

![](https://cdn-images-1.medium.com/max/800/0*GEnxnt_AJrb1rysl)

Finally, the team enhanced support for keyboard and trackpad input so people can navigate the app without taking their hands off the keyboard. This created a more desktop-like experience on mobile, allowing users to use direction keys and keyboard shortcuts to trigger actions. Since implementing these new improvements, 1Password has seen more than 22.6% more installs on Chrome OS devices.  
最后，开发团队增强了对键盘和触控盘输入的支持，从而使用户即使手不离键盘，也可以做到导航应用。这样在移动设备上提供了一种更类似于台式机的体验，允许用户使用方向键和键盘快捷键来触发应用活动。自从实现了这些改进，1Password 已经历了 Chrome OS 设备上装机量22.6% 的增幅。

### **Deliver the experience your app users demand**
### **提供你的应用用户所需体验**

In a world where consumers increasingly demand versatility, it’s important for developers to expand their strategies beyond mobile and serve users on a variety of devices. It’s crucial to consider whether your app is set up to deliver the most engaging experiences for every user — no matter their device or screen size. Doing so may mean the difference between driving growth and missing out on a plethora of new customers. 
在消费者越来越需要多功能的世界里，对开发人员来说，重要的是将他们的策略扩展到移动设备之外，并在各种设备上为用户提供服务。思考这件事很重要：你的应用是否要为每一个用户提供最具吸引力的体验，而不论他们的设备或屏幕大小。这样做意味着分清驱动用户增长和错失大量新用户两者之间的差异。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
