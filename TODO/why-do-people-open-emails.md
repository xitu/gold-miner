> * 原文地址：[Why do people open emails?](https://blog.mixpanel.com/2016/07/12/why-do-people-open-emails/)
* 原文作者：[Justin Megahan](https://blog.mixpanel.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


人们为什么打开电子邮件？每次将文章推送给 _The Signal_ 的订阅者我都会思考这个问题。当文章到达你的收件箱，还有共享谷歌文档和其他简讯可以选择，是什么让你打开邮件然后阅读它呢？

我听说过最佳做法，我努力坚持下去，但是我忍不住想它们是否真的有区别。但是要搞清楚这些的话，我需要数据，很多很多的数据。

所以，**分析了来自 Mixpanel 活动的 85,637 行主题 - 总共发送 17 亿封电子邮件，其中 2.32 亿封被打开**，时间跨度从 2012 年 6 月到 2016 年 5 月，我期待着这个一直困扰我的问题——究竟是什么让人们打开一封电子邮件，能找到答案。

有件事情值得一提的是，Mixpanel 活动不一定是一次性群发给整个邮件列表的。它们可以这么做，但更多的时候它们是事件驱动的电子邮件，意味着用户的某些动作触发了邮件通知。举个例子，一个活动可能针对最近 30 天内创建过账号的用户，但是最近 7 天没有登录过的。然后该活动是激活状态的，只要用户符合要求，他们就会收到电子邮件。

好吧，下面就是我所学到的东西。

## 大多数邮件是没人看的

出门右拐，不管其他的数据。我们都知道，这是个残酷的现实，就是大多数邮件不会被打开。我关注的那些邮件跨行业，有着不同的目的。它们包含了一切东西，当用户完成某项特定任务而发送非常有针对性的邮件，或非常广泛的"欢迎"或电子商务销售电子邮件。**所有这些发送的邮件打开率为 13.53% **

#### 所有活动

85,637 活动数  

232,706,223 打开数  

1,720,490,613 发送数  

**13.53% 打开率**

但有些活动确实不符合平均比例，而是比别人更好，超过 100 位接收人的 49k 个活动中，**五分之一打开率超过 50%**。同时，**超过五分之二打开率低于 10%**。

所以，差异还是蛮大的，显然这里有很多因素在影响着结果。只控制主题行，不同主题对整体打开率有怎样的影响呢？

## 主题行不能太长

很长一段时间，我听说主题行字符长应该是[在 40 和 60 之间](http://www.universalwilde.com/blog-0/bid/140949/5-Tips-That-Will-Get-Your-Email-Campaigns-Read)。比如，我们最近发出的一篇文章[“Survival Metrics”](https://blog.mixpanel.com/2016/06/23/survival-metrics-will-help-company-survive)，它的电子邮件主题行长 42 个字符：

_How will you help your company survive?_

这儿还有另外一个典型 [our profile of Hunter Walk](https://blog.mixpanel.com/2016/07/06/hunter-walk-early-stage-venture-capital/?discovery=homepage%20feature)，这篇就超过了范围, 65 个字符:

_Hunter Walk grew YouTube by 40x. Here’s his advice to startups_

但是通过分析大数据中的打开率和主题行字符数的相关性发现，40-60 字符数的“标准”很明显有点过时了。

[![](https://blog.mixpanel.com/wp-content/uploads/2016/07/subject-length-ctt-228x300.png)](https://twitter.com/intent/tweet?text=Why%20do%20people%20open%20emails%3F%20%20https%3A%2F%2Fblog.mixpanel.com%2F2016%2F07%2F12%2Fwhy-do-people-open-emails%2F%3Futm_campaign%3D%26utm_source%3Dtwitter%26utm_medium%3Dsocial%26utm_content%3D%20pic.twitter.com%2FnY6uBYBnKd)  


虽然你可能不想再读 80 字符的主题行，桌面客户端仍然做了大量的工作全部显示它们。但是越来越多的时候，我们是在移动设备上阅读邮件。在 app 里，像 Google 的 Inbox，主题行被截断成 27 个字符，后面加上一个神略号。所以我们上面例子的主题行会变成这样：

_How will you help your comp…_

_Hunter Walk grew YouTube by…_

最佳做法绝对是少于 40 字符。想想我们现在是如何阅读邮件的，就不会觉得惊讶了。

让我们来看看截断的主题行的打开率，**主题少于 30 字符的有 15.05% 的打开率，那些主题超过 30 字符的打开率为 12.92% **。

![IMG_0394](https://blog.mixpanel.com/wp-content/uploads/2016/07/IMG_0394-300x154.png)

#### 小结

尽量简短。超短。而当主题行超长了，至少要确保前 30 个字符是诱人且有足够的信息让用户在移动阅读器上有欲望打开它。

## 个性化有实质性的帮助吗?

另一项标准的建议是个性化的电子邮件。你可以使用任何一项你收集到的和邮件地址相关的信息，但最常见的还是收件人的姓名。个性化的核心思想就是通过使用个性化的东西，主题行显示给收件人更多的照顾，她就更有可能将其打开。

但是，当实际上我看到数据的时候，并不是所有个性化都有这种效果。

#### 统计数据

6,117 活动数  

14,361,034 打开数  

153,694,066 发送数  

**9.34% 打开率**


我分析了 包含变量的 7% 的活动，但是打开率非常低，只有 9.34 %，远低于 13.53% 的整体打开率。

但是当我审视自己的个人 Gmail 时，这么低的打开率也就不足为奇了。我看到大量 “personalized(个性化)” 邮件。很少一分部我会打开，但是大多数我都不会。

更重要的是，我的名字在主题行不再值得关注了。邮件合并并不是什么新东西，像 Andrew Chen 在[增长骇客](https://blog.mixpanel.com/2016/03/16/andrew-chen-and-the-state-of-growth-hacking/)中提到的战术衰减。我敢肯定为每个用户定制电子邮件仍然有增长的空间，但是需要比名字更个性点。

#### 小结

如果你真的想让主题行更加引人注目，包括一个名称变量。但是不要因为你可以放就一定要放一个名字在那。五年前，可能在主题行看到自己的名字会觉得与众不同，但是现在真的过时了。

## 别嚷嚷，矜持点。

The old best practices for what to do weren’t performing well, so I decided to take a look at something convention says you should avoid: exclamation points. For a long time the consensus has been that exclamation points appear spammy and should be used with extreme caution or else your email risks getting caught in spam filters. Nevertheless, I found that a lot of subject lines still had them. Here’s how the data broke out:

之前的最佳实践现在都有些过时了，那来看看有哪些习惯是应该避免的：惊叹号。很长一段时间里，大家都形成一个共识，带感叹号的都是垃圾邮件，应谨慎使用，否则你的邮件有被垃圾邮件过滤器过滤的风险。然而，我发现很多主题行仍然使用感叹号。看看下面的数据：

#### 包含 ‘!’

22,844 活动数  

62,989,308 打开数  

576,772,852 发送数  

**10.92 % 打开率**

It looks like this one still holds true although, honestly, the open rate didn’t take as big of a hit as I expected. That said, when I started to look at subject lines with multiple exclamation points, the open rates plummeted. Subject lines with three exclamation points (“!!!”) took the biggest hit, with open rates falling to a dismal 7.59%.

看起来像是这么回事，老实说，打开率并没有我预期的打击那么大。当我开始看到有多个感叹号的主题行，打开率骤降。带三个感叹号的主题行遭受的打击最大，打开率下降到凄惨的 7.59%。

那么，如果一个感叹号是垃圾，那三个感叹号简直就是粗鲁。那么来对比下礼貌的词语，如“谢谢你”、“请” 和“对不起”，来看看礼貌对打开率的影响。

#### 包含 ‘谢谢’, ‘谢谢你’, ‘请’, ‘对不起’

1,478 活动数  

3,911,452 打开数  

17,022,299 发送数  

**22.98% 打开率**

####

正如你所看到的，它是一个相当可观的增加。原来礼貌点很有帮助。

#### 小结

采取一些数据驱动的建议：不要叫喊，始终注意自己的礼貌。真诚的使用“请”、“谢谢”和“抱歉”等礼貌用语。

## 好奇心，想知道

在 Buzzfeed 的时代，你会经常看到“你永远不知道接下来会发生什么”这样的标题党。但是他们总能吸引人的眼球是有原因的，虽然其背后缺乏有价值的东西：它们很诱人，它们捕获了你的好奇心，想知道吗？快来点击吧。

I took a look at subject lines that had a question mark or the phrase “How to” to tease the reader about an answer that is behind the open.

看看那些带个问号或"如何"的主题行，挑逗着读者打开后面的答案。

#### 包含 ‘?’

10,724 活动数  

27,387,349 打开数  

180,003,478 发送数  

**15.21% 打开率**

#### 包含 ‘如何’

701 活动数  

2,747,926 打开数  

13,302,419 发送数  

**20.66% 打开率**

一个问号能提升一些打开率，但是一个像“如何”这样的短词通过引诱点击让读者知道点击后的内容。它们能有更高的打开率。

#### 小结

许诺读者们会得到什么作为诱饵，比如回答一个问题，诱使他们打开它。

## Does creating urgency matter?

Another suggested best practice is to create urgency using words like “today” and “now.” In our daily struggle against the ever-rising tide of email, it’s not that we consciously decide against opening an email; usually we just don’t have a reason to immediately open it. Then, of course, the old emails get buried under new ones, and many are never opened.

Creating urgency in a subject line is supposed to put a little pressure on a reader to open it when they first see the email. But does it work?

#### Includes ‘today’, ‘tomorrow’, ‘tonight’, or ‘now’

4,669 campaigns  

11,979,604 opens  

94,559,225 sends  

**12.67% open rate**

Apparently not. In fact, it’s slightly lower than the average. Creating a sense of urgency doesn’t seem to hurt the open rate enough to avoid it, but it certainly doesn’t get people rushing to open that email either.

#### Takeaway

As long as it’s appropriate, you’re fine using words like “now” and “today,” but don’t just shoehorn them in because you think it’ll result in a boost in your opens.

## Making that $$$

Then there are those emails that promote a big sale and are trying to drive some revenue. They might not always be your favorite emails to receive, but they’re sent for a reason: they make money.

#### Includes ‘offer’, ‘code’, ‘coupon’, ‘sale’, ‘$’, ‘discount’

9,370 campaigns  

21,900,339 opens  

211,747,667 sends  

**10.34% open rate**

That’s honestly higher than I had expected. But I suppose it’s only spam when you don’t want to see the deal. So, depending on the sale or the sender, many might be excited to see a subject with these words in their inbox. And, you know what, at least it’s transparent about the purpose of the email. Maybe that honesty pays off.

But the outlier of sales-y words is the word “free.” Convention says to avoid it, that it will just get caught in spam filters. That made complete sense to me. But when I looked more closely, the data didn’t back up that convention at all.

#### Includes ‘free’

2,017 campaigns  

6,272,514 opens  

36,312,363 sends  

**17.27% open rate**

I have a hard time making sense of this. I can see how some of the old best practices might be dated, but this result throws me for a loop. Maybe we’ve all preached against using “free” for so long that we’ve overcorrected and those who dare to use it reap the benefits. Your guess is as good as mine, but whatever it is, it looks like “free” is working – so let’s all go ruin it again.

#### Takeaway

The important thing to remember here is that when it comes to sales emails, open rate isn’t the most important metric – revenue generated is. But surprisingly, promotional emails with words like “sale” and “offer” maintain a respectable open rate, and “free” sees a noticeable increase.

## Maybe avoid those mass blasts?

The last thing I looked at was how many recipients each campaign sent to. Was the open rate on sends to 500,000 people different from campaigns that targeted 5,000 people?

It turns out the answer is yes, and much more than I had expected.

[![number-of-sends-ctt](https://blog.mixpanel.com/wp-content/uploads/2016/07/number-of-sends-ctt-223x300.png)](https://twitter.com/intent/tweet?text=Why%20do%20people%20open%20emails%3F%20%20https%3A%2F%2Fblog.mixpanel.com%2F2016%2F07%2F12%2Fwhy-do-people-open-emails%2F%3Futm_campaign%3D%26utm_source%3Dtwitter%26utm_medium%3Dsocial%26utm_content%3D%20pic.twitter.com%2FDXV10CD4w7)

You can see that as the sends get larger, the open rate declines. It turns out that with email marketing, one size doesn’t fit all. Those large email blasts are less targeted, and that means a diverse group of readers will find them less compelling. On the other hand, smaller sends – perhaps one that gets sent after a user takes a specific action to qualify for a more targeted send – have a much higher open rate. Campaigns that go out to 5,000 people have double the open rate of those that go out to 500,000 people.

#### Takeaway

Don’t send fewer emails; create more specific email campaigns that are targeted and are crafted for a smaller subset of your users.

## Don’t build tomorrow’s emails with yesterday’s best practices

After running all these numbers – and scores more that didn’t yield as significant or noteworthy results – my overall takeaway is that we all need to to question more of yesterday’s best practices. Question what you learned six years ago when you first started sending out emails. Question the practices your company has put into place. Things change too quickly to carve email marketing commandments in stone.

Learn from the numbers and the lessons of this article, but question them too. Conventions change. How people are reading their emails changes and what was once a compelling subject line in 2011 might not be one in 2016\. Tactics, like including a name in a subject line, quickly wear out their use. Words that were toxic in the past might not be today.

It seems so simple. We’re all just trying to get someone to click (or tap) on our subject lines and take a quick look at an email. But so is everyone else. Take the time to craft good subject lines, find what works, and send out emails that your users will want to open.

_Is there a best practice I didn’t test that you’d like to have answers on? Let us know. Email [blog@mixpanel.com](mailto:blog@mixpanel.com) or tweet [@mixpanel](http://twitter.com/mixpanel) and I’ll take a look._

[![](https://blog.mixpanel.com/wp-content/uploads/2016/07/why-do-people-open-emails-ctt-300x150.png)](https://twitter.com/intent/tweet?text=Why%20do%20people%20open%20emails%3F%20%20https%3A%2F%2Fblog.mixpanel.com%2F2016%2F07%2F12%2Fwhy-do-people-open-emails%2F%3Futm_campaign%3D%26utm_source%3Dtwitter%26utm_medium%3Dsocial%26utm_content%3D%20pic.twitter.com%2FoRptlv49gp)

_Photograph by [Andrew Taylor](https://www.flickr.com/photos/profilerehab/5707316547/in/photolist-9Gkunr-7bfPS1-KzGwZ-oxMAXY-hRmQD-J2dst-bBavHS-jWUyA-2q6n8-8F2iz9-6cdZ7H-FDFThy-3KMTAm-4kC7Ca-ouAjEm-7ZNTFh-5Qmfb6-5pw1mA-wUdon-6B817j-Bddh5-4gEfk-e3G5f-83bVCz-6k1NHD-4BSCA-bEGXg2-4qwMSH-bkbnqV-4kXzr5-kVsR6-48G2hm-4SKBZG-8iq4Go-vJs7G-cHDRcC-FF1gsD-daVFYT-33wxA-59sbz3-FCPKt-6HknLQ-2keEL6-4kTxdr-MGo5-fdVi2-afBt81-284GwD-oFg5-LLPYr), made available under an [Attribution 2.0 Generic license](https://creativecommons.org/licenses/by/2.0/)_
