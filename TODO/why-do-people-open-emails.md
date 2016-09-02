> * 原文地址：[Why do people open emails?](https://blog.mixpanel.com/2016/07/12/why-do-people-open-emails/)
* 原文作者：[Justin Megahan](https://blog.mixpanel.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Why do people open emails? It’s something I think about every time I send an article out to _The Signal_ subscribers. When the article hits your inbox between a shared Google doc and yet another newsletter, what is it that’s going to get you to open and read it?

I’ve heard the best practices, and I try my best to adhere to them, but I can’t help but wonder if they actually make any difference. But to know that, I’m going to need data, and a lot of it.

So, **armed with 85,637 subject lines from Mixpanel campaigns – totaling 1.7 billion emails sent and 232 million opens**, over a span from June 2012 to May 2016 – I looked to answer the eternal question: **What makes people open an email?**

One thing worth calling out right away is that Mixpanel campaigns aren’t necessarily one-time email blasts out to an entire list. They _can_ be, but more often they are event-driven emails, meaning the user took some action to trigger the email notification. For example, a campaign might target users who have created an account in the last 30 days, but haven’t returned in the last seven days. Then, for as long as that campaign is active, whenever a user qualifies, they receive the email.

Okay, now here’s what I learned.

## Most emails aren’t opened

Right out of the gate, let’s level set. It’s a hard reality, and we all know it, but most emails aren’t opened. The emails that I looked at spanned industries and intention. They included everything from very targeted emails for when a user completes a specific task, or very broad “Welcome” or e-commerce sale emails. **And the overall open rate for all sends was 13.53%**.

#### All campaigns

85,637 campaigns  

232,706,223 opens  

1,720,490,613 sends  

**13.53% open rate**

But some campaigns did disproportionately better than others. Of the 49k campaigns that had more than 100 recipients, **one in five had an open rate over 50%**. At the same time, **two out of five campaigns had open rates under 10%**.

So, there is quite a bit of disparity, and obviously there are many factors at play here. Controlling for subject lines only, how do different subjects affect overall open rate?

## Don’t make your subject too long

For a long time, I’ve heard that subject lines should be [somewhere between 40 and 60 characters long](http://www.universalwilde.com/blog-0/bid/140949/5-Tips-That-Will-Get-Your-Email-Campaigns-Read). For context, here’s an email subject line we recently sent out for our “[Survival Metrics](https://blog.mixpanel.com/2016/06/23/survival-metrics-will-help-company-survive)” post. It’s 42 characters long:

_How will you help your company survive?_

And here’s one from [our profile of Hunter Walk](https://blog.mixpanel.com/2016/07/06/hunter-walk-early-stage-venture-capital/?discovery=homepage%20feature) that is just on the other side of that window, at 65 characters:

_Hunter Walk grew YouTube by 40x. Here’s his advice to startups_

But by analyzing the open rate by characters in the subject line across our massive data set, it became obvious that the 40-60 character “standard” is a bit dated.

[![](https://blog.mixpanel.com/wp-content/uploads/2016/07/subject-length-ctt-228x300.pn)](https://twitter.com/intent/tweet?text=Why%20do%20people%20open%20emails%3F%20%20https%3A%2F%2Fblog.mixpanel.com%2F2016%2F07%2F12%2Fwhy-do-people-open-emails%2F%3Futm_campaign%3D%26utm_source%3Dtwitter%26utm_medium%3Dsocial%26utm_content%3D%20pic.twitter.com%2FnY6uBYBnKd)  



While you might not want to read an 80 character subject line, desktop clients still do a great job displaying them. But more and more, we read our email on mobile. And in apps like Google’s Inbox, the subject line gets truncated and an ellipsis is added after 27 characters. So our example subject lines from above become: 

_How will you help your comp…  

Hunter Walk grew YouTube by…_

The sweet spot is definitely under 40 characters. When you think about how we read email today, that shouldn’t be that surprising. 

When we look at the open rate of subject lines at that breakpoint, **subjects with less than 30 characters long have a 15.05% open rate, while those with more than 30 characters have a 12.92% open rate. **

![IMG_0394](https://blog.mixpanel.com/wp-content/uploads/2016/07/IMG_0394-300x154.png)

#### Takeaway

Keep it short. Ultra-short. And when you go longer, at least make sure that the first 30 characters are enticing and informative enough on their own to get mobile readers to open.

## Does personalizing actually help?

Another standard recommendation is to personalize emails. You can do so using any piece of information you’ve collected with an email address, but most often it’s the recipient’s name. The thought is that by using something personalized, the subject line appears more catered to the recipient and she’ll be more likely to open it.

But again, when actually I looked at the data, personalization didn’t seem to have that effect at all.

#### Includes variable

6,117 campaigns  

14,361,034 opens  

153,694,066 sends  

**9.34% open rate**

7% of all campaigns I analyzed include a variable, but the open rate is a very lackluster 9.34%, well below the 13.53% overall open rate.

But when I look at my personal Gmail, this low open rate isn’t all that surprising. I see a slew of “personalized” emails. A few I’ll open, but many I won’t.

And more importantly, it’s not noteworthy that my name is in a subject line anymore. MailMerge isn’t anything new, and like Andrew Chen talked about in “[The State of Growth Hacking](https://blog.mixpanel.com/2016/03/16/andrew-chen-and-the-state-of-growth-hacking/),” tactics decay. I’m sure there is still power in customizing an email for each user, but it needs to be more substantive than a name.

#### Takeaway

If it genuinely makes an subject line more compelling, include a name variable. But don’t put a first name in there just because you can. Five years ago, it might have been novel to see your name in a subject line, but at this point it’s old hat.

## Don’t shout. Be nice.

The old best practices for what to do weren’t performing well, so I decided to take a look at something convention says you should avoid: exclamation points. For a long time the consensus has been that exclamation points appear spammy and should be used with extreme caution or else your email risks getting caught in spam filters. Nevertheless, I found that a lot of subject lines still had them. Here’s how the data broke out:

#### Includes ‘!’

22,844 campaigns  

62,989,308 opens  

576,772,852 sends  

**10.92 % open rate**

It looks like this one still holds true although, honestly, the open rate didn’t take as big of a hit as I expected. That said, when I started to look at subject lines with multiple exclamation points, the open rates plummeted. Subject lines with three exclamation points (“!!!”) took the biggest hit, with open rates falling to a dismal 7.59%.

So, if one exclamation point is spammy, then three are downright rude. For contrast, I looked at polite words, like “thank you”, “please”, and “sorry,” to see how being a little more courteous affected open rates.

#### Includes ‘thanks’, ‘thank you’, ‘please’, ‘sorry’

1,478 campaigns  

3,911,452 opens  

17,022,299 sends  

**22.98% open rate**

#### 

As you can see, it was a pretty sizable increase. It turns out a little common courtesy goes a long way.

#### Takeaway

Take some data-driven motherly advice: don’t yell and always mind your manners. Use “please” and “thank you,” and say “sorry” when you mean it.

## Inquiring minds want to know

In the age of Buzzfeed, you’re never too far from clickbait headlines about how “you’ll never believe what happened next.” But there’s a reason why they work, even if there is little substance behind them: they’re enticing, they get you wondering, and, before you know it, you’re clicking through.

I took a look at subject lines that had a question mark or the phrase “How to” to tease the reader about an answer that is behind the open.

#### Includes ‘?’

10,724 campaigns  

27,387,349 opens  

180,003,478 sends  

**15.21% open rate**

#### Includes ‘How to’

701 campaigns  

2,747,926 opens  

13,302,419 sends  

**20.66% open rate**

A question mark added a little bump to the open rate, but a phrase like ‘How to’ entices a click by letting the reader know what they’re going to get if they click through. And they did at a much higher rate.

#### Takeaway

Luring your reader with what they’ll get in return for opening, like the answer to a question, entices them to open.

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

## Making that $

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



