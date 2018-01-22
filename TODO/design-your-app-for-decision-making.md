> * 原文地址：[Design your app for decision-making](https://medium.com/googleplaydev/design-your-app-for-decision-making-e9e5745508e4)
> * 原文作者：[Jeni](https://medium.com/@_jeniwren?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/design-your-app-for-decision-making.md](https://github.com/xitu/gold-miner/blob/master/TODO/design-your-app-for-decision-making.md)
> * 译者：
> * 校对者：

# Design your app for decision-making

## _Post 1 of 3: Simplify, trigger, motivate — a three-step approach to optimize for user behavior_

![](https://cdn-images-1.medium.com/max/800/1*wsvauosvxPMm0R6rlKXR_g.jpeg)

If you work on mobile apps, you have the potential to influence the actions of millions of people every single day. Whether it’s to engage with a new feature, visit your app daily, or subscribe to your premium product, you likely have in mind a key behavior you wish more users would do, more often. But how can you increase the chances of your users taking action?

Whatever the desired behavior, this blog post (the first in a three-part series drawing on insights rooted in behavioral economics, psychology, and gamification) will introduce you to a three-step approach to optimizing for behavioral outcomes — Simplify, Trigger and Motivate. We’ll cover the first two steps, ‘Simplify’ and ‘Trigger‘ in this blog post specifically.

Where should you start when considering strategies to encourage a specific user action? Dr. BJ Fogg, the director of Stanford University’s [Persuasive Tech Lab](http://captology.stanford.edu/), created the Fogg behavioral model to visualize how three elements (ability, triggers, and motivation) contribute to the likelihood of a given behavior occurring:

![](https://cdn-images-1.medium.com/max/800/0*dP-BAPMCWX9uKBuj.)

Fogg Behavioral Model

The model suggests three factors influencing user behavior, which map to three key steps for driving behavioral change:

* Step 1: **Simplify** the desired behavior. Encourage action from engaged, motivated users by reducing (and ideally removing) barriers that prevent it from happening.
* Step 2: **Trigger** behavior from motivated users. The presence of “triggers” (prompts, cues, CTAs) can drive action even when motivation levels might be slightly lower.
* Step 3: Boost user **motivation**. Motivation is hard to influence, but if the desired behavior is relatively ‘easy’ to do, amplifying motivation levels with compelling messaging or engaging game elements can help inspire users to act.

So far, so good. But how do you carry out these steps? We’ll do a deep dive into the first two below. (I’ll discuss the third step, boosting user motivation, in a future post).

### Step 1. Simplify the desired behavior

The behavior you want your users to perform should be easy to do (with few to no barriers to act) and easy to decide on (with clearly understood benefits). Every action we take requires resources to carry out (for example time, money, and cognitive load). These resources act as barriers, and every decision is a trade-off between using these resources for the resulting benefits of the action. For example, many of us have a surge of motivation to get fit at the beginning of the year, but putting in the resources necessary to exercise leads to many broken resolutions!

What barriers or “asks” are decreasing the chances of your users taking action? Common barriers that drain your users’ resources can be cumbersome manual input, redundant screens, an overwhelming array of options, and confusing messaging with no clear call to action. These barriers can be identified both quantitatively via data analysis of user’s in-app actions, and qualitatively, for example, via user research. Once you’ve identified your barriers to action, it’s time to lessen or remove some of them:

#### **REDUCE THE TIME REQUIRED TO ACT**

It can take several clicks from the moment of app discovery to download, not to mention the download wait. These are barriers that all app developers face. However, [Android Instant Apps](https://developer.android.com/topic/instant-apps/index.html) is an option which lets users accomplish many tasks quickly (e.g. watching a video or making a purchase) by running a native experience instantly, without the barrier of installation.

![](https://cdn-images-1.medium.com/max/600/1*R4kv3XMr9rpphokMjS0jRA.png)

Once your user opens your app, the sign-up flow can be the next minefield of cumbersome and time-intensive asks. Instead of asking users to sign in each time, developers like those at [Ticketmaster](https://play.google.com/store/apps/details?id=com.ticketmaster.mobile.android.uk) and [AliExpress](https://play.google.com/store/apps/details?id=com.alibaba.aliexpresshd) effectively removed manual password requests by integrating with [Google Smart Lock](http://get.google.com/smartlock/#for-passwords). They subsequently saw large decreases in sign-in failure rates.

Developers can track user drop-off in core user journeys by conducting a funnel analysis, helping to pinpoint any barriers to desired behavior. In running a funnel analysis, food delivery company [Deliveroo](https://play.google.com/store/apps/details?id=com.deliveroo.orderapp) identified a conversion drop-off for first-time users during the checkout process. They noticed that this same drop-off wasn’t shared with existing customers whose payment and delivery details were already saved in the app. Realizing that their sign-up flow was likely part of the problem, the team prioritized efforts to roll out [Android Pay](https://developers.google.com/android-pay/) to create a simpler checkout experience for first-time users.

![](https://cdn-images-1.medium.com/max/600/1*bst4m7qIgfsAuyybPOIAsw.png)

#### **REDUCE THE (REAL AND PERCEIVED) COST**

Reducing cost doesn’t mean you should reduce your price across the board! What it does mean is that prospective purchasers each have a different “sweet spot” reflecting the price they deem represents good value to them, based on factors like app engagement levels, user location, and overall user purchasing power.

Google Play’s Head of Western Europe Apps, Tamzin Taylor, has given a talk rounding up some key best practices for pricing optimization, such as leveraging the [Big Mac Index](http://www.economist.com/content/big-mac-index) to assess purchase parity across markets:

<iframe width="700" height="393" src="https://www.youtube.com/embed/LQ6MsPmUa38" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

Another way to reduce cost as a barrier to potential purchasers is to lower the initial monetary ask. Our recent [Introductory Pricing](https://support.google.com/googleplay/android-developer/answer/140504#intro) feature for app subscriptions allows you to do exactly that.

When we think about perceived cost, it’s important to note that the way price is presented can have a significant impact on perceptions of value. There are two main ways of shaping this perception:

**1. Anchoring**

Developers and retailers often seek to “nudge” users to purchase a particular product through the use of [“good,” “better,” “best” price tiering](https://hbr.org/2013/02/why-good-better-best-prices-are-so-effective). This works by placing the standard price alongside cheaper or more expensive price points. The higher-priced “best” option acts as a reference point — or anchor — making it more likely that the standard price appears like a cheaper and better value to users.

> We gravitate towards middle prices because they seem ‘fair,’ in context.

> — [Derek Thompson](https://medium.com/@dkthomp), The Atlantic

Dan Ariely drew our attention to the now-famous example of The Economist’s pricing strategy in his book, _Predictably Irrational._ The magazine offered three options: a $59 internet subscription, a $125 print subscription, and a$125 internet and print subscription. Ariely suggests that “relative to the print-only option, the print-and-internet option looks clearly superior,” and that this persuades us to purchase third option because it’s “easier” to assess the value of something when placed next to an option it has a relative advantage over.

**2. Framing**

Given the choice of a subscription product that costs $60 a year, or $5 per month, which would you choose? Many subscription apps highlight the cost of an annual plan as its monthly cost because this lowers the perceived cost to potential purchasers, despite them both costing the same amount over an annual period.

![](https://cdn-images-1.medium.com/max/600/1*S8DAVtjS0Z48RSJyzbzkKQ.png)

#### **REDUCING COGNITIVE LOAD**

The more choices you present to a user, the more mental effort is takes to compare options and make a decision.

Besides assessing the choices you offer to users at key stages in the user journey, it’s worth assessing how you present options, as this can have a huge impact on the decision-making process.

**The value of limits**

For example, searches on the flight app [Skyscanner](https://play.google.com/store/apps/details?id=net.skyscanner.android.main) often yield thousands of results. Rationally, you could argue that consumers should weigh the merits of each individual result. But given the barriers of finite time and cognitive load, Skyscanner decided to limit choice by bundling the results in a more meaningful way, creating a new time-based widget to allow users to easily compare options between airlines. While the same number of results was returned, this simple change to their presentation on the page led to a 14% increase in conversions.

**The power of defaults**

In general, people follow the path of least resistance. This means pre-set options are powerful tools for optimizing user behavior, especially when these defaults actively benefit the user.

* For example, recipe app [Simple Feast](https://play.google.com/store/apps/details?id=com.simplefeast.android.app) decided to emphasize the price of their annual subscription on their Premium page. They presented it as the default user choice by visually drawing attention to it, and found that users who opted for annual subscriptions increased as a result.
* A seemingly small change to a checkbox can have profound impact, too. The power of defaults has been utilized to great effect in government policy like organ donation, where countries whose forms have an “opt-out” policy [see much higher organ donation consent rates](http://www.dangoldstein.com/papers/JohnsonGoldstein_Defaults_Transplantation2004.pdf). Why? People prefer to stick with the “status quo”.

### Step 2. Trigger behavior from motivated users

The second step to encouraging desired user behavior is the presence of actionable, relevant triggers in the paths of motivated users. A memorable BJ Fogg mantra is to “place hot triggers in the path of motivated users.” Triggers tend to be external to the user — a developer-initiated prompt, reminder or call to action that intends to influence what the user does next. A push notification is a trigger in this sense, and can be especially effective when it’s actionable, personalized, and timely.

[Antoine Sakho](https://medium.com/@antoinesakho), Head of Product at language-learning app [Busuu](https://play.google.com/store/apps/dev?id=8335366955203612525), describes in [his Medium article](https://medium.com/@antoinesakho/designing-push-notifications-that-dont-suck-af6aaa0ea85) how they applied [Nir Eyal](https://medium.com/@nireyal)’s [Hooked Model](http://www.nirandfar.com/hooked) to their push notification strategy, which drove a 300% increase in push open rates. He writes:

> _First, we prompt the user with a personalized push notification_ **_(external trigger)_** _which sparks curiosity_ **_(internal trigger)_**_. Tapping on the push, they go through a quiz_ **_(action)_**_. At the end of the quiz, they get a congratulations screen with their score_ **_(reward)_**_. Finally, by training the vocabulary they had learned, they have strengthened their long-term memory_ **_(investment)_**_._

![](https://cdn-images-1.medium.com/max/800/0*rEsZdKUne9TjMfzu.)

The Hooked Model, applied to Busuu’s re-engagement campaigns

Despite the promise that push notifications hold for re-engaging users, you should avoid these common pitfalls:

1. Push notifications sent at inopportune times, or containing content irrelevant to the user’s context produce a real backfire effect.
2. Sending the same push notification messaging becomes stale quickly: Follow Busuu’s lead and never send the same push notification twice.
3. Don’t over-rely on push notifications to drive user action. App habits are ultimately formed when the user proactively engages with your content without needing a prompt to do so. [Nir Eyal](https://medium.com/@nireyal) sums this up in his [Medium article](https://medium.com/behavior-design/the-psychology-of-notifications-how-to-send-triggers-that-work-25c7be3d84d3#.e4sbkzj7l):

> _Habit-forming products align the external trigger (a push notification for example) with the moment when the internal trigger is felt (say the feeling of uncertainty or boredom)._

The most successful external triggers are immediately actionable. So how can you build upon the idea that the user should take action at a precise moment? According to [Prospect theory](https://en.wikipedia.org/wiki/Prospect_theory), people act to avoid losses because the pain of loss is greater than the pleasure of an equivalent gain. This means we’re more likely to act to prevent missing out on something, than to secure a guaranteed gain.

Limited-time, limited-quantity sales are a core lever that many developers use to drive users to purchase now rather than later. These tactics are driven by our aversion to loss. After all, failure to act quickly entails the possibility of “missing out” on deals and items in scarce supply. This idea can also be used to construct more persuasive messaging. For example, you could choose to focus on what your users might lose if they don’t act, versus what they gain if they do.

![](https://cdn-images-1.medium.com/max/800/0*WtMs-w9cf21LbpB0.)

Health and lifestyle app [Lifesum](https://play.google.com/store/apps/details?id=com.sillens.shapeupclub) saw a 15% increase in 1st-day conversion after introducing a limited-time “starter kit” for new users. The “today only” messaging urges the user to act now, instilling a sense of urgency to prevent missing out.

**Summarizing the key takeaways:**

* Users won’t perform the desired behavior if the cost or resources necessary don’t clearly align with resulting value
* Users are also less likely to act if it’s difficult to assess and choose between the options available
* Users are more likely to perform the desired behavior if you provide them with relevant, actionable triggers in context

You can learn more about the ideas in this post by attending or watching my [Google I/O talk, “Boost User Retention with Behavioral Insights,”](https://events.google.com/io/schedule/?sid=b187c653-5143-4b2d-addc-103e1f04fbc2#may-19) on **Friday May 19th** at **8:30 am (PST)**. Along with Sami Ben Hassine, CEO of [The Fabulous](https://play.google.com/store/apps/details?id=co.thefabulous.app), I’ll be discussing how developers can apply behavioral insights to build more engaging app experiences.

* * *

#### What do you think?

Do you have questions or thoughts on optimizing your app for decision making? Continue the discussion in the comments below or tweet using the hashtag #AskPlayDev and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

* * *

_In the_ [_second Medium post_](https://medium.com/googleplaydev/the-right-app-rewards-to-boost-motivation-c1ec86390450)_, I reveal some details behind the third step of behavior change — boosting user motivation. I’ll be exploring the psychology of motivation, its relationship to gamification, and approaching rewards in the right way._

_Special thank you to_ [_Aaron Otani_](https://medium.com/@aaronotani) _for providing feedback on a draft version of this post._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
