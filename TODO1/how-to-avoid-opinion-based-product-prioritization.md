> * 原文地址：[How to avoid opinion-based product prioritization](https://medium.com/googleplaydev/how-to-avoid-opinion-based-product-prioritization-d398fd047ab7)
> * 原文作者：[Tamzin Taylor](https://medium.com/@tamzint?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-avoid-opinion-based-product-prioritization.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-avoid-opinion-based-product-prioritization.md)
> * 译者：
> * 校对者：

# How to avoid opinion-based product prioritization

## Discover insights to help you drive decision making using data and better manage stakeholders

![](https://cdn-images-1.medium.com/max/800/1*1QtpBve99bpwRN2PFAokjg.png)

Making decisions is hard. And, in most organizations, they are made harder by the many competing opinions, stakeholders, and self-interests in play. Sometimes the biggest hurdle to rational decision-making can be your CEO or CFO, whose very strong views can be hard to resist.

So, how do successful app developers avoid decisions about product features and marketing defaulting to the view of the highest-paid or most persistent voice?

I recently had the opportunity to explore this question. I interviewed around 20 of our top developers, as well as Google engineers, Google product managers, and directors of growth. From these interviews, it was clear that the interviewees exhibited three key behaviors that address this challenge:

*   They use experimentation to explore their opportunities.
*   They put data at the heart of the process.
*   They spread this culture of data and sharing of information throughout their organization.

In this article, I’m looking in detail at two examples of these behaviors in action. In the first case, I had the opportunity to take a prioritization method often using internally at Google, and test it out with UK app developer 1tap. Then, I’ve been fortunate enough to be given the inside track on the process used by 2017 app of the year winner Memrise.

### 1tap and the North Star method

Originating in Silicon Valley, the concept of a [North Star Metric](https://www.forbes.com/sites/forbesagencycouncil/2017/07/19/how-to-find-your-companys-north-star-metric/#58293ac830f8) has been around for a while. Within Google, the teams at YouTube and Gmail among others, use the process of orienting around a “north star metric” to prioritize the features to build. From my interviews, I discovered how beneficial it is for our teams and wondered if it might help app developers too. Within Google, we have a growth team that has been the conduit for this process, so I harnessed this team to work with 1tap.

So, what is this method? Conceptually it’s really simple; there are just four components: the North Star metric, a user flows diagram, a growth model, and a spreadsheet. Because, let’s face it, what data-based model is complete without a spreadsheet?

Let’s look at each of these components in more detail, and how they played out at 1tap.

### Set a North Star metric

This is a metric that consolidates all the work you’re doing and value you’re delivering across acquisition, engagement, conversion, and retention. So, if you were a hotel booking app this metric is nights booked, while for a messaging app it would be messages sent.

1tap’s mission is to make self-employment easier than being employed. They have two apps: [1tap receipts](https://play.google.com/store/apps/details?id=io.onetap.app.receipts.uk) that offers automatic data extraction and bookkeeping, and [1tap tax](https://play.google.com/store/apps/details?id=io.onetap.app.tax) that estimates tax payments with automatic receipt and invoice scanning.

For this exercise, we looked at 1tap receipts. We very quickly determined the North Star metric for 1tap receipts had to be about transactions. However, as Jon Butterfield, head of growth at 1tap, notes “the tricky part here, and the thing that threw us off, was what’s more important, users adding a lot of receipts, or a lot of uses just adding a few receipts?” Looking closely at the value 1tap receipts offers its users, it was clear that if users record more data 1tap receipts can help them better with their taxes. The result, a North Star metric that is all about receipts per user, and the more receipts the better.

### Define your user flows

![](https://cdn-images-1.medium.com/max/800/0*7B9lSgNbH6rkQmH3.)

The goal here is twofold. First, to **confirm that your app includes feedback loops** that continue to bring the user back. Second, to **examine your metrics and determine how successful** you are **at moving users through these loops**. The process is straightforward, you:

*   Define your app’s key events.
*   Draw the flows between events.
*   Use your analytics to identify the percentage of users taking each flow.

You’ll find the diagram has 3 main sections: your acquisition and retention loops, and the key flows inside the product.

The **acquisition sources are the main ways users install your app**. You can get this data from the Play Console under User acquisition, just make sure you’ve added UTM tags to all your marketing URLs, and link your AdWords account for full visibility.

The product user flows will be specific to your business but will probably include sign-in, onboarding, and conversion (if you’re a paid app). Most likely there’ll be a magic moment in the onboarding flow you’ll really care about, as it’s a leading indicator of engagement and conversion, make sure you include it.

Finally there are the **re-engagement flows**, what’s driving users to come back into the app.

When your diagram is complete, everyone in your business can talk about the product in the same way and understand how their activities — acquisition, engagement, conversion, and retention — impact the North Star metric.

In the case of 1tap receipts, this exercise resulted in the following visualization.

![](https://cdn-images-1.medium.com/max/800/0*ihtNP20aIDYffxrn.)

You’ll notice that there aren’t any analytics on this user flow. For 1tap the most important outcome was understanding the flow of the product and focusing on the key components that “move the needle”. One important result was **identifying where the wow moment is**. In 1tap receipts, it turned out to be the “Activate User” stage, where they add the receipt. “Getting the user to see their data automatically extracted instantly shows the value of the product, and surprises a lot of people with the accuracy of the OCR technology,” says Jon.

The final user flow diagram was the result of about 10 iterations. The first one had, in Jon’s words, “thousands and thousands of different things in it and it was just a clutter.” We then worked together to simplify the representation to focus on the key moments in the user journeys. It also helped 1tap ask the question of features that didn’t get into the diagram, “if it’s not included in the core flow, is it even needed?” As Jon notes, “cluttering your app with features is something that can kill usability.”

As a result, 1tap also discovered they had a break in their user feedback loops. This break occurred in the activities, shown in orange in the diagram, related to exporting transaction data. As a result 1tap began changing how users export their data, and where they get access to their exports. They’re still experimenting, but by keeping many of the reports in the app they have increased retention.

### **Build a growth model**

The next step is to build the growth model. We use the information about the user flows and are guided by the North Star metric to determine the growth drivers. These are the drivers that will improve areas of weakness and build on strengths.

As with the initial user flow diagram, the first version of the growth model 1tap built was rather complex, stretching to some 16 pages. But, by focusing on what’s important a straightforward, workable growth model soon emerged. This growth model can be summarized as:

![](https://cdn-images-1.medium.com/max/800/0*qnlVKnZB8odmSPE-.)

The headline here is receipts added per user, which you should recognize: it’s the North Star metric. This headline breaks down into the receipt submissions divided by the monthly active users (MAU). In turn, this further breaks down into each of the mechanisms users can employ for adding receipts — scanning, sending by email, and entering manually — and new and returning users.

When they first started coding their products, 1tap focused on analytics. They tracked just about everything a user does in the app. As Jon notes “this is something that we are really proud of,” says Jon. “However, before we knew it, we were suffering from analysis paralysis. With so much choice, we didn’t know where to begin with understanding our users and their behavior. The model helped us focus on providing value and made it easier for us to deliver our North Star metric.’

But, as Jon explains, the key benefit of developing this growth model was that it made it easier to explain to the CEO where the MAU comes from, and then the CFO could see where the revenue comes from too. Also, product could see what levers to pull to add the most value.

### Create a spreadsheet

The final step is to transfer the model to a spreadsheet and **evaluate your opportunities, to see how they impact growth**.

You probably won’t be surprised to learn that 1tap’s growth model translated into a large spreadsheet. But, on this occasion, size was important. Here is a snippet of, what Jon and the team at 1tap call “The Calculator”.

![](https://cdn-images-1.medium.com/max/800/0*Hmizl_Y7zhdMbNmU.)

Armed with this spreadsheet, 1tap started to explore how various activities would impact receipts added per user over 10 days. Jon notes that one of the early benefit was that they could see the impact of minor changes. For example, by improving download to registration conversion by just 2%, the overall receipt count improved by 100%. By contrast, improving registration to activation conversion would only impact the receipt count by 75%.

As a result, 1tap started putting more effort into getting the wow moment (and registration) earlier in the user journeys, rather than pumping more money into acquisition.

So, what did this process and the model achieve for 1tap?

“The first thing it gave us was clarity — across all departments — about what we’re doing,” says Jon. “So our CEO, Nick, no longer had to ask where the MAU was coming from and how we could increase it. It’s as clear as day in this model. Similarly, product didn’t have to ask what are we going to do next? What’s the priority? These decisions are now all based on the calculator. And, the CFO knew that, by increasing revenue, we increased retention. So, from the growth model, everyone can see what is happening next.”

Another important impact was understanding how to increase acquisitions. “The big thing we realized is that we should be putting a lot of priority into accountants. We’d not really done this in the past, so it was a huge wake-up call,” says Jon. “This is a big lever, and it was clear that if we put more effort into partner channels, we could get a lot more users relatively easily and have a built-in mechanism, their accountant, to help retain them.”

Jon also notes another important knock-on effect, and that was with new hires. “Without the information from the calculator, we could easily be hiring the wrong people at the wrong time. But, now we know when and who we should hire to maximize our growth.”

### Memrise

Language app [Memrise](https://play.google.com/store/apps/details?id=com.memrise.android.memrisecompanion&hl=en_US) is used by 35 million people to learn their choice of language from over 200 language pairs. Kristina Narusk, head of growth for Memrise, describes the company’s journey to date as unique, in part because “we’ve been rather lucky with having Ed Cooke as our CEO because he is one of the most creative and experimental people out there who, at the same time, is great at running a growing team and a growing business”. Ed’s approach injects a lot of out-of-the-box thinking into the company. The downside, if you can describe it as such, is the challenge of managing the creative ideas to find the ones that will grow the app.

Kristina told me about one such example where, one Sunday morning about three years ago, she got a text from Ed to say he was in Scotland, had bought a double-decker bus, and was going to tour Europe filming videos of native speakers saying phrases and sentences. “It was quite a unique experience to get a message like that,” says Kristina. “So, we had to come up with ways to handle this kind of irreverent idea, not just those from Ed but the whole team, and turn them into successful app features.”

Memrise came up with a way of filtering these ideas using **six criteria**:

1.  Has to be iterable. It must be possible to start with a small MVP and then iterate if it’s successful.
2.  Has an immediate impact. As soon as the feature rolls out to users, it should generate behavioral change that is noticeable in metrics.
3.  Has a lasting effect. It must benefit users over an extended period, not just for the first five minutes or the first day.
4.  Has to be measurable. There must be a way to measure its impact on users and the success of the app.
5.  Has the power of localization. It has to be something that can be delivered to most, if not all, of the app’s markets.
6.  Has to fit coherently into the app. The idea has to fit into the app and make sense.

![](https://cdn-images-1.medium.com/max/800/0*ZFEKyBCJ09866AjF.)

In the feature discovery phase the team then plays a prediction game, to assess how the feature idea is aligned with the criteria. Only ideas that meet all of the criteria pass through the evaluation filter and head to Memrise’s development process.

As Kristina explains, to instill this creative and experimental mindset in every team in the company, **Memrise divided the product development lifecycle into 4 stages: discover, define, develop, and follow-up.**

![](https://cdn-images-1.medium.com/max/800/0*zHlTtMJtB4hKpYoz.)

During the **discovery** stage the product team sketches, draws, designs, prototypes, and user tests the idea. Experiments are run for designs, UI prototypes, and content prototypes. They could, for example, build something that they can get random people from the street to test out. Other experiments might use online resources (to test copy, buttons, and colors), or Memrise users for longitudinal course content experiments. The entire product and design team is involved at this stage, with researchers, language experts, and developers sitting in the testing sessions. One challenge Kristina has found with this process is keeping the observers silent. “Developers are very quiet when coding,“ says Kristina, “but tend to become very vocal when they see people using the product ‘incorrectly’.”

In the Memrise Membus case (Ed’s impulse Scottish purchase), during the discovery phase, the bus went to Oxford to film some videos in English to see whether the idea made sense before touring the rest of Europe. Adding the videos to the Memrise English courses was the minimum viable product (MVP), making sure the bus stayed in one piece for distances longer than the drive from the Memrise office in East London to Oxford Circus was more of a challenge. But, importantly, the test showed that the videos had a positive effect on subscription conversions and the cost of producing the videos was low enough to justify moving onto other languages. So, it turned out that it was a good idea to buy a bus in Scotland and then turn it into a video feature.

With the idea tested out the team moves to **define**, where they create a detailed spec with all the functionality described and the user interfaces drawn out. Also, it specifies the experiments to run on the feature, including details such as the:

*   Target platform
*   Target learners
*   Target language
*   Length of the experiment
*   What needs tracking
*   What the analytics dashboard should contain

The data team gets involved too. They help make sure that the feature is built to capture the right data points, so that the product team can evaluate the feature’s impact. The videos were used to create a premium learning mode and offered as part of the Pro subscription. It was, therefore, important to understand the effect on the conversion rate to Pro from adding this mode to the English course. At the end of the stage, the whole team acts as jury, to give feedback on the product ideation and specing outcome.

Once everything is ready and set up, the development team start to **develop** the feature. Because the development team has been involved in the discovery and define phases, development is usually straightforward as many assumptions have been tested and there is more certainty about the business reasons for building the feature.

When development finishes, it’s down to the product manager to switch on the feature, so that the users will see what’s been built, and start the experiments.

With the new version of the app out, the team can move to the **follow-up** stage. At this point, the team will look to answer questions such as: How are the KPIs for the feature performing?What is the initial user feedback? What is the effect of the new release on the app ratings? Hopefully, as Kristina describes it, this is “the joyful moment of watching when and how the results come in.”

YouTube 视频链接：https://youtu.be/e2RPXKi4e90

At Memrise they have a standard set of metrics and graphs for every experiment that goes out. “The day after the release you’ll find us refreshing this page all the time,” says Kristina, “to see how the feature and the new idea is performing. In our team’s case, it shows you the joy and fun of seeing the results coming in and learning whether we built something super successful that people enjoy, or whether we need to go back to the whiteboard and start thinking again.” The Memrise Membus journey ended with a decision to add videos and a special _Learn with Locals_ mode to all languages.

### Conclusion

![](https://cdn-images-1.medium.com/max/800/0*QnrE1nsyWfxPFOlq.)

I said at the start of this article that making decisions is hard. Avoiding opinion-based decisions, maybe, even harder. However, by sharing two very different approaches to product decision making, I hope I’ve given you some ideas on how to streamline and rationalize the process in your company. Regardless of the process you adopt or create, remember it’s key that the process involves everyone from your organization and product team. And, ultimately, look to data to help identify the right changes to make or activities to engage in.

* * *

### **What do you think?**

Do you have thoughts on decision making and prioritization? Let us know in the comments below or tweet using **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
