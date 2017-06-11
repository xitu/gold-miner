> * 原文地址：[UX Review and Redesign of the CocaCola Freestyle Kiosk Interface](https://medium.com/@vedantha/ux-review-and-redesign-of-the-cocacola-freestyle-kiosk-interface-f77fc087c09)
> * 原文作者：[Ved](https://medium.com/@vedantha)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# UX Review and Redesign of the CocaCola Freestyle Kiosk Interface #
# 可口可乐自由风格售卖亭界面用户体验的回顾和重新设计 #

![](https://cdn-images-1.medium.com/max/800/1*ZydJMy1NI8CJ2Uwc0ocewA.jpeg)

A CocaCola Freestyle Kiosk Interface

一个可口可乐自由风格售卖亭的界面

### **Objectives** ###

### **任务** ###

- Understand the Kiosk and its UX
- 理解这个售卖亭和它的用户体验
- Identify pain points and UX obstacles
- 找到痛点以及用户体验的障碍
- Improve UX/UI of the CocaCola Freestyle Kiosk Interface
- 优化可口可乐自由风格售卖亭的用户体验和界面设计

### Design Process ###

### 设计流程 ###

![](https://cdn-images-1.medium.com/max/800/1*Jo9PS6PGeSzVPIJpSlnrLQ.png)

Design process followed for this project

这是这个项目的设计流程

I followed a simple design process for this redesign project.

在复盘中我遵循了简单的设计流程。

I’d never used the machine myself before. So I needed to understand how it worked, and its context of use. Observing how the machine was used in different restaurants and a movie theater provided the necessary context.

我自己之前从来没有用过这个机器，所以我需要理解它是如何工作的，以及它的使用环境。观察这个机器在不同的餐馆和电影院中如何被使用提供了重要的场景。

Later I conducted some quick users tests and asked the users to think aloud as they were getting their drink. I made notes of what I observed and user quotes, and analyzed this data to make sense of it. This later drove the redesign presented in this post.

在我做了一些快速用户测试和询问了用户当他们想喝饮料时在想什么。我把观察到的和用户问券做了笔记，分析这些数据搞清楚他们的意思。这驱动了在这篇文章中提到的再设计。

### **Observation** ###
### **观察** ###

I visited popular restaurants around my area where the machine is located. The main objective here was to understand the audience, environment, and contexts. I also found out about rush hours by speaking to the staff of the place.
我参观了我所在区域附近有这个机器的参观。主要目的是理解用户，环境和设备场景。通过和当地工作人员交流我也发现了（设备使用的）高峰时段。

**Context**
** 环境 **

- The Kiosk is placed mainly in Restaurants and places of leisure such as movie theaters.
- These places are rushed on weekends, holidays and certain times during the day.
- There is usually a queue during rush hours.

- 在餐馆，Kiosk 位于主要位置，而在电影院这类地方，它却在角落里。
- 周末，假期以及平时固定时间会是高峰期。
- 高峰时经常会排队。

**End Users**
** 终端用户 **

The end users of the machine include
机器的终端用户包括

- Age group: teens and above (excluding those unable to reach or operate the screen)
- People with different calorie and caffeine preferences.

- 年龄段：青少年及以下（除了够不着操作不了屏幕的那些）
- 偏爱热量和咖啡因的人群

### **Quick User Tests** ###
### **快速的用户测试** ##

- Number of participants: 4
- Familiarity: 2 first time users, 2 returning users
- Time: 8–9 minutes overall

- 参与人数：4
- 熟悉程度：两人第一次用，两人曾经用过
- 时间：8、9 分钟左右

**Notes from user tests:**
** 来自用户测试的记录：**

- Returning users knew exactly what drink they wanted. They were quick to pick the categories and were familiar with the UI.
- The new users took longer to make a choice, and there was some back and forth between the different kind of main drink categories.
- The new users were also confused about the “Push” button under the screen.
- Some users wanted to “try” new flavors and mixes before filling up their cup with their preferred one. Due to this, there was a lot of back and forth as well.

- 曾经用过的用户明确的知道他们想要喝什么。他们快速的挑选类别，对图形界面很熟悉。
- 新用户花了很长时间做选择，他们在不同的几种主要饮料种类中纠结了一会儿。
- 新用户也对屏幕底部的「Push」按钮感到疑惑。
- 一些用户想「尝试」新的味道或者是把他们最喜欢的饮料混合起来填满杯子。因为这样，他们也有许多反复的（操作）。

**Some user quotes**
**一些用户建议**
> “Woah, so many options!”

> “My drink is usually over here <navigates to the drink’s button>”

> “Do I need to hold the ‘Push’ button?”

> 「哇， 太多选项了！」 

> 「我通常只会选择在「导航到饮料的按钮」上的饮料」

> 「我是否需要按住「Push」键？」

### Analysis ###
### 分析 ###

The user tests gave me some good insight into the different issues with the interface, and user flows. To understand more about this, lets consider the current user flow. From the time a user stand before the Kiosk, to getting a drink, the process looks as shown below.
用户测试给了我一些好的理解在界面和用户流方面的不同问题上。为了理解更多，得到准确的用户流程，从用户站在 Kiosk 前开始，到得到一杯饮料，过程如下图所示。

#### Current user flow (using just the Kiosk) ####
#### 当前用户流（仅适用于 Kiosk） ####


![](https://cdn-images-1.medium.com/max/800/1*zsd3Jch6qnl0JaerA700-g.png)

User flow for getting drinks or creating mixes
得到一杯饮料或者创造混合饮料的流程

This is a best case user flow and applicable for most users. While it seems quite simple at the outset, the major obstacle to a smooth flow here is a cognitive overload if the user does not already have a drink in mind. **Each screen has anywhere between 8 to 15 drink options to choose from. Making a decision is quite taxing in such a scenario, and the existing design does not help with that.** This process is repeated taking up more time if the user wants to create a mix.
这是一个最好的用户流程用例，适用于绝大多数的用户。虽然它一开始看起来相当简单，但是当用户没有想好要什么饮料时，这里最主要的障碍就是认知过载。** 每一屏上面都有 8 到 15 个选项可供选择。在这种情况下作出决策是相当困难的。而现有的设计并没有帮助（用户做出选择）。**当用户需要创造一种混合饮料的时候花费的时间会更多。

#### Current user flow with mobile app ####
#### 当前移动应用的用户流程 ####

![](https://cdn-images-1.medium.com/max/800/1*iOMdvGQAE33q_HYoXZZn1Q.png)

User flow with the mobile app
移动应用的用户流程

Using the app simplifies the process on the kiosk slightly. It saves time by having mixes ready for the users, so they don’t have to navigate and pick each time.
在 Kiosk 上使用应用会稍稍简化流程，通过为用户准备好混合饮料节约了时间，所以他们不需要每次都浏览和选择。

#### Pain points ####
#### 痛点 ####

From user tests and comments from [many users online](https://www.facebook.com/IHateTheCocaColaFreestyleDrinkMachine/), these are the pain points I discovered
从用户测试和[许多用户的在线反馈](https://www.facebook.com/IHateTheCocaColaFreestyleDrinkMachine/)来看，这些是我发现的痛点。

![](https://cdn-images-1.medium.com/max/800/1*rJ48-RHDEqtJJNfqK0kgSw.jpeg)

A screen showing 15 drink options!
一个屏幕内展示 15 种饮料！
- Cognitive overload from too many options ([according to Hick’s Law](https://en.wikipedia.org/wiki/Hick%27s_law))
- Lots of back and forth for new users and for users wanting to mix flavors
- Initial confusion with push button
- Screen timeout too short — creates a sense of urgency
- Filters are either caffeine free or low calorie, but not both
- Takes too long to get some of the regular flavors such as Coke or Sprite

- 太多的选择中导致的认知超载（[根据西克定律](https://en.wikipedia.org/wiki/Hick%27s_law))
- 对于新用户和想要混合口味的用户来说，有太多反复的步骤
- 对于「push」按钮的初始认知不明确
- 屏幕超时的时间太短-造成了紧迫感
- 过滤器中可以不含咖啡因或者低热量，但不能同时过滤
- 获得一些常规口味的饮料像可乐和雪碧也需要太长时间。


### Redesign ###
### 重新设计 ###
Based on the findings in the previous stage, the UX can be refined as shown below. The companion mobile app has also been considered for the redesign. First lets look at some goals, constraints and assumptions made for the redesign.
根据前一阶段的发现，可以对用户体验进行细化，如下所示。辅助的移动应用也被考虑进行重新设计。首先让我们看看为了重新设计而定制的一些目标，约束和假设。

#### Goals for redesign ####
#### 重新设计的目标 ####

- Reduce the number of steps to get a drink for most people
- Reduce cognitive load
- Make it easier to create mixes
- Make navigation easier

- 对于大多数人来说减少获得饮料所需要的步骤数
- 减少认知负荷
- 让创造混合（饮料）更简单
- 让导航更简单

#### **Constraints** ####

- The main constraint is the touchscreen. It is resistive touch, and works well for tap interactions, but not well suited for more advanced gestures.
#### **约束** ####
- 主要的约束就是触屏，它是电阻式触屏，并且只适用于轻击的交互，而不太适合更高级的手势。

#### Assumptions ####
#### 假设 ####

- The Kiosk provides data back to CocaCola (or the maintaining company).
- CocaCola and partners maintain and make use of this data for analysis and product enhancement.

- Kiosl 可以给可口可乐（或者服务商）提供数据反馈
- 可口可乐和合作伙伴持续使用这些数据分析并优化产品。

#### Sketches ####
#### 草图 ####

Sketches are very powerful in generating quick ideas. I arrived at the final redesign from these initial sketches.
在快速产生创意上草图十分强大，我从做这些最初的草图中得到了最终的重新设计（方案），

![](https://cdn-images-1.medium.com/max/800/1*YUdZ1df6gR97Ntz1jHVs_w.jpeg)

Exploring some initial concepts
探索一些初步的概念

![](https://cdn-images-1.medium.com/max/800/1*5Gab6nhVVNOHvP-kLBCY1Q.jpeg)

Some drink mixing concepts
一些混合饮料的概念

#### Low-Fi screens ####
#### 低保真原型 ####

These initial prototypes were made with Balsamiq. (These come after a lot of quick sketches)
这些初步的原型是用 Balsamiq 制成的。（他们源于大量的快速草图）

![](https://cdn-images-1.medium.com/max/1000/1*zBNUTKoV3u_vAM-i2ItgvA.png) 

Left: Start screen || Right: after the user selects a drink
左边：初始化界面 || 右边：用户选择一种饮料后的界面

Consider the screens above.
思考下面的界面

Left: The start screen consists of the most popular drink products. Notice that the “low calorie” and “caffeine free” are filters. The user can select both, narrowing down the choices in subsequent screens.
左边：初始化界面由最受用户欢迎的饮料产品构成。请注意，「低热量」和「不含咖啡因」是过滤条件。用户可以选择两者，减少后续屏幕中的选项。

Right: After the user has made a drink choice, the system “recommends” 4 popular flavors for the selected main drink. Also notice that there are a total of 8 drink choices displayed here.
右边：用户选择了一种饮料后，系统「推荐」四种流行口味的饮料。请注意，这里有八种饮料可以选择。

How is this better? Well, using data backed recommendations, the design **makes it easier to select the 48 most popular drinks out of around a 100 total**.
这是更好的吗？那么，使用数据反馈的建议，设计 **可以更容易的从大约 100 个总数中选出 48 种最受欢迎的饮料。

![](https://cdn-images-1.medium.com/max/1000/1*248PiUK1TkFRxuk2hvzQSw.png)

Left: After selected drink has been finalized || Right: When the user is pouring the drink
左边：在选择的饮料已经确定时 || 右边：用户接饮料时

The above two screens show the flow for pouring a selected drink. Notice that the description reads “Press & Hold” addressing a user’s earlier confusion with the system. As a part of improving microinteractions, it also responds to the button press on the UI.
上面的两个界面显示了接选中的饮料的流程。请注意，描述为「按住」，解决了用户早期对系统的混淆，最为改善微交互的一部分，它也相应了 UI 上的按钮。

Another important thing to notice — **the row of circles. These are drink recommendations that go well with the current drink.** The user can quickly press one of these options and add it to the drink mix. Again, **these are data backed recommendations.**
另一个重要的事情需要注意-**这一行圆圈，这些是添加饮料到当前饮料中的建议。**用户可以快速按下这些选项之一，并将其添加到混合饮料中。再一次强调，**这些来源于数据的支持。**

![](https://cdn-images-1.medium.com/max/800/1*wje3sg8WTiqT0IGdXH6hXA.png)

After the user selects the second drink to mix
在用户选择第二种饮料混合后

Other key points:
其他的关键点

- The design makes it easy to navigate. The pagination is an easy back and forth, and gives an idea of the total options available.
- 设计使其易于浏览。分页操作是一个容易的来回，并且给出了可选择的全部选项的预期。

- For mixing, the user can also always go back and select a different drink. The design makes an attempt to ease the process, but also gives the user flexibility to go back or start over.
- 为了混合，用户还可以随时返回选择不用的饮料。这个设计试图简化此过程，但也使用户可以灵活的返回或重新开始。

#### How this changes user flow ####
#### 这如何改变用户流 ####

Lets consider how this would change the user flow* for most people when backed by data driven insights.*
让我们考虑如何**在数据驱动的支持下，针对大多数人，**改变用户流。

![](https://cdn-images-1.medium.com/max/800/1*cyjjSL2T-qXC7uocWjDK8g.png)

User flow with the redesign
重新设计的用户流

#### How the mobile app could further improve experience ####
#### 移动应用如何进一步改善体验 ####

The mobile app already makes the experience better. But it could further be improved. Lets take a look at how we can currently choose drinks on the mobile app, and how it can be improved.
移动应用已经能创造更好的体验。但还可以进一步改善。让我们来看看我们如何在移动应用上选择饮料，以及如何改进。

![](https://cdn-images-1.medium.com/max/800/1*XG8SU63vMnjNmmsE1UAPzw.png)

Left: Current screen to choose drink || Right: A design with pull down to search
左边：目前选择饮料的界面 || 右边：一个下拉搜索的设计

#### Hi-Fi screens ####
#### 高保真界面 ####

Now lets take a look at some hi-fidelity designs. Based on some user feedback, there are some small changes compared to the low-fi version.
现在让我们看一看一些高保真设计，基于一些用户反馈，与低保真界面相比有一些小的变化。

![](https://cdn-images-1.medium.com/max/1000/1*dyJzBQnzaKCw1hFwONe-Nw.png)

Left: The start screen. The interface shows the top 6 popular drinks on first page. || Right: Once the user taps on a drink, its variants appear as shown.
左边：开始屏幕。该界面展示了第一页上最受欢迎的六种饮料。 || 右边：当用户点击一杯饮料后，变化如图所示。

One change on the start screen is the water icon has been moved to the top-right for more visibility, and the button also takes a circular shape to be in line with the drink icon shapes.
开始画面上的一个变化是水图标被移到了右上角以获得更多的可见性，并且该按钮也用了圆形更符合饮料的图标形状。

![](https://cdn-images-1.medium.com/max/1000/1*tka8iXFvRQNEaDVwvYBz6g.png)

Left: Once the user taps on a drink variant, its time to pour it into the cup. || Right: UI feedback when the user presses the “PUSH” button.
左边：一旦用户选择了一个饮料的变种，就把它倒入杯子里。||右边：当用户按下「Push」按钮时 UI 界面的反馈。

These screens are a slight change from the low-fi designs. There is an additional column in the final version — “For other choices” beside mix drink recommendations. This communicates the users’ choices more clearly. If the users want a different drink or flavor from the recommended choices, it guides them to the next steps.
这些界面和低保真设计有一些不同。再最终版本中还有一个附加列-「混合饮料建议」旁边的「其他选择」。这更清楚的表达了用户（可以进行）的选择。如果用户想要选择与推荐的饮料不同的风味，这会引导他们进行下一步。

![](https://cdn-images-1.medium.com/max/1000/1*65IQM2cIqVpx421UaZtrjQ.png)

Left: Once the user taps on a recommended second drink to mix, this screen is shown. || Right: From the start screen (screen 1), clicking on the “Fruit Flavors” lead to this screen.
左边：用户点击推荐的第二杯饮料进行混合后，显示这个界面。|| 右边： 从开始的界面（界面 1），点击「水果味」进入此界面。

The screen numbered 6 shows the “Fruit Flavors” selection. The 5 most popular flavors are show right on top and highlighted. Less popular flavors are displayed right below. There are 3 “mixed” flavors on the Kiosk, and these are listed under mix flavors. Selecting one f these options will display options similar to screen 2.
6 号屏幕显示「水果味」的选择。最受欢迎的五种口味显示在顶部并十分突出。下面显示不太受欢迎的口味。Kiosk 上有三种「混合」口味，这些都是混合口味。选择一个这些选项将显示类似于屏幕 2 的选项。

A click through prototype:
点击原型

[![](https://marvelapp-live.storage.googleapis.com/serve/2017/5/18854dfb4ab14e5ba0da5aa0eb69942a.png)](https://marvelapp.com/28f7gbe?emb=1&referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F1dba6e6eec95ce7b8611343aef3c1237%3FpostId%3Df77fc087c09)

### Limitations of the design ###
### 设计的局限性 ###

Even though the redesign addresses some key points, there are some limitations.
虽然重新设计解决了一些关键点，但仍存在一些限制。

- The design prioritizes the most popular options over the less common ones. It might take a few extra taps if the user has a less common option in mind.
- 目前的设计相对较少的选项优先偏向于最常见的选项，如果用户想要不常见的选项，可能需要多做几步。
- If the users want to create a mix with flavors other than the recommended ones, they need to start over or head to the flavors scree and pick another drink.
- 如果用户想要使用于推荐的口味不同的口味混合，需要重新开始活着回到口味选择页面，然后挑选另一种饮料。

*Tools used for prototypes: Balsamiq, Sketch.*
** 原型使用的工具：Balsamiq, Sketch **

*Fruit icons are made by [*Freepik*](http://www.freepik.com) and [*Madebyoliver*](http://www.flaticon.com/authors/madebyoliver).*
** 水果图标来自于 [*Freepik*](http://www.freepik.com)和 [*Madebyoliver*](http://www.flaticon.com/authors/madebyoliver)

*If you liked this post, please click the little green heart below. It helps others discover the post, and puts a big smile on my face :)*
**如果您喜欢这篇文章，请点击下面的小绿心。 它帮助别人发现这个帖子，并在我脸上放一个微笑：）。**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
