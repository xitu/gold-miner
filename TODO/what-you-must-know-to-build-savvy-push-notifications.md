> * 原文地址：[What You Must Know To Build Savvy Push Notifications](http://firstround.com/review/what-you-must-know-to-build-savvy-push-notifications/)
* 原文作者：[First Round](https://twitter.com/firstround)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# What You Must Know To Build Savvy Push Notifications


Smartphones have been around for nearly a decade and yet founders still declare mobile the most underhyped technology, according to [First Round's State of Startups Survey](http://stateofstartups.firstround.com/#highlights). And, within mobile, the potential of push notifications reigns supreme. Entrepreneur [Ariel Seidman](https://www.linkedin.com/in/aseidman) [captures this well](http://arielseidman.com/post/62564939335/fixing-mobile-push-notifications): “It’s hard to over-hype the power of mobile push notifications. For the first time in human history, you can tap almost two billion people on the shoulder.” That’s why [**Slack**](https://slack.com/)'s [**Noah Weiss**](https://www.linkedin.com/in/noahw) is a true believer in a world coming closer together through smarter pings.





Recommended Article





Before Slack, Weiss worked at Foursquare when it [monetized the service with native ads](http://techcrunch.com/2013/10/14/with-an-eye-to-more-revenue-foursquare-opens-its-ads-platform-to-all-small-businesses/) and [boldly split into two apps in 2014](https://medium.com/foursquare-direct/the-lego-block-exercise-4c7d60eeb38f#.tmyz2j5o0). During that time, monthly active users more than quintupled. Weiss was also Google’s lead product manager on structured data-related search projects. Recently, Weiss joined Slack [to build out its New York office and lead its new Search, Learning and Intelligence Group](https://medium.com/@noah_weiss/starting-up-slack-s-search-learning-intelligence-group-in-the-new-nyc-office-af6523090789#.sqly156er) with a [mandate to develop features](http://www.recode.net/2016/6/6/11863534/slack-artificial-intelligence-AI-noah-weiss) that make companies more productive the more they use Slack.

In this interview, Weiss maps out the dynamic evolution of push notifications — revealing critical paradigm shifts in the era of smartwatches and app-filled homescreens. Here, he also shares tips for startups seeking to build out their push notification strategy and the inputs, metrics and guidelines to instate. Any startup that wants to command this high-risk, high-reward channel will benefit from Weiss’ wisdom.

> A great push notification is three things: timely, personal and actionable.

## Evolution of Push Notifications

Before sharing tactics, Weiss summarizes the evolution of push notifications as it relates to **the three qualities that make pings powerful: being timely, personal and actionable.** He sees their history and progression as fundamental context to consider as you build your future strategy. Here’s an abridged four-stage history:

**Email As the Push Notification Predecessor.** The push notification of the early web era was email. “There are a lot of similar analogs between email and push,” says Weiss, “Back in the day, you gave permission for an open line of communication with a website by giving your email address. Email became the primary, reliable way to bring a person back to a website; it wasn’t through a portal or bookmarks. Lastly, there’s an unsubscribe option in email. The equivalent for notifications is adjusting the push settings or, more frequently, uninstalling the app.”

**Migration to Mobile.** Email started to falter as users engaged more on their mobile phones. “It may be hard to recall a time before smartphones, but people didn’t used to live in their inboxes. They checked email a few times a day from a computer,” says Weiss. “Even companies with very successful email marketing strategies hit walls with mobile. Remember Groupon offers of laser hair removal deals? Why did you receive it when you did? When did you show interest in hair removal or indicate you’d make this type of purchase decision on your phone? When tied to a user, location and time of day, push notifications became more effective. While they feel abrasive if done poorly, they had the potential to be timely, personal and actionable.”

**Competing with SMS, not Email.** On mobile, push notifications are more akin to texts than emails. “Push is about what is relevant to this moment. You can send an email that you may not expect to be read for a couple of days; that’s okay for newsletters or digests,” says Weiss. “However, the timeliness or the attention required in real time with a push notification is completely different. With pings, you’re effectively competing with SMS and other very personal forms of communication. How personal do you have to be if the rest of the notifications come from someone’s spouse, best friend or mom? It has to be at that same level.”

**Cutting through all the apps.** When people first adopted smartphones, their apps could fit in a 4x4 grid on their home screen. Now, the average person in the U.S. has around 55 apps on their phone. “You get to the point where there’s no way one can actually use all those apps on a regular basis. It’s so hard today to develop a cadence where an app becomes a daily habit,” says Weiss. “The reality for developers is you’re probably not going to be on someone’s home screen and users likely aren’t going to be in the habit of using it multiple times a day. That's where notifications become increasingly important. For most apps, a push notification can be perfect for delivering urgent information: an Uber is arriving, your flight’s gate has changed or you’re mentioned in Slack. If users are inundated with 50+ apps, you can’t rely on them to remember to use you at the right time and place. You need to proactively pull them in.”





Noah Weiss





## Build Your Notification Strategy Around These Tenets

An in-depth notification strategy can weigh and weave together several factors, such as nearby wifi, personalization, social factors and real-time snapping to places to power its push notifications. But for startups that are just embarking on their push notification technology, there are fundamentals to consider. From the basics to more advanced tips, Weiss outlines the essential lessons he’s learned while developing push notification systems.





Recommended Article





**Boost retention _outside_ the app.**

From a user retention standpoint, there are diminishing returns after your app crosses a threshold of functionality. There’s only so many features you can jam into a single app and expect new users to discover them in their first few sessions. “The biggest challenge in mobile is retaining new users. There are proven tactics to get them through the door: efficient app install marketing, social channels, SEM and SEO. However, what’s really hard is getting new users to develop a habit,” says Weiss. “There comes a time when improvements to your app won’t dramatically affect top line retention anywhere close to an investment in the surface area outside of your app, namely push notifications. That’s because once someone closes your app, it doesn’t matter if there’s a magical experience they missed on the fourth tab of the app. If they never open it up again, they’ll never know what they missed out on.”

In your quest to build the best user experience for your app, don’t forget that that experience only happens if users open the app in the first place — and keep returning to it. “It always amazes — and pains — me when I see the incredible time and effort put into an app with no hint of a strategy to re-engage me,” says Weiss. “Of course most young developers aren’t thinking about notifications. Don’t make that mistake. It’s the single biggest oversight in mobile product development today.”

> Customer acquisition propels an app. User retention builds a business.

**Don’t mistake a download with permission.**

Asking for the authority to send notifications is not only good form, but technologically necessary. “If you’re building on iOS, sending notifications is a permission the user must authorize. Unlike on Android, downloading the app does not give you that authority. You have to prompt users for it,” says Weiss. “This is the pivotal moment. If users decline permission, there’s no way for the app to reach out to pull them back in, which drastically decreases the likelihood that they’ll be active users down the line. Even if they accept, it is not a binding contract."

If users get tired of your push notifications, the best case is that they select which notifications to keep active in app, but it’s more likely that they’ll navigate to their phone settings to turn off all notifications or simply uninstall the app. This is effectively irreversible. The takeaway: Deliver on users’ first notification experiences or they’ll shut down the channel for good.”

So the first step is to prompt users to agree to notifications at the start — if they say no, the rest of this advice doesn’t matter. It involves user education, placing prompts after actions users find valuable or doing pre-prompts to get the green light to ask permission at later dates to increase the rate of conversion. Then it’s about maintaining trust and keeping an open line of communication. There’s strong literature that’s been written on both steps, so Weiss recommends this syllabus:

*   [The Right Way to Ask Users for Mobile Permissions](https://library.launchkit.io/the-right-way-to-ask-users-for-ios-permissions-96fa4eb54f2c#.3u7waqk3w) by [Brenden Mulligan](https://twitter.com/mulligan)

*   [Why 60% of your users opt-out of push notifications, and what to do about it](http://andrewchen.co/why-people-are-turning-off-push/) by [Andrew Chen](https://twitter.com/andrewchen)

*   [The right way to ask your users to review your app](https://medium.com/circa/the-right-way-to-ask-users-to-review-your-app-9a32fd604fca#.iz4jrwiin) by [Matt Galligan](https://twitter.com/mg)

Given the high stakes of getting permission to notify, the thrust of these articles is to default to being risk-averse. “If you’re smart, you’re actually very cautious when it comes to notifications. Build safety nets into all experiments, because any misfire can burn for a long time,” says Weiss. “For example, if I were to launch a weekly ping that all users would receive, I’d start it as a 5 or 10 percent experiment to cap any potential downside of people opting out of notifications.”

**Nail down three metrics to measure notifications...**

To assess your notification strategy, nail down three metrics: **1) the rate of users opting out of your notification permissions, 2) the uninstall rate and 3) actions per hundred pings**.

“To evaluate a great notification, you have to balance positive engagement with the downside of setting opt-outs. It’s a tricky balance, because you may be comparing a short-term engagement boost versus a longer-term downside of users who’ve uninstalled and can no longer be re-engaged,” says Weiss. “Start by pinning your assessment to uninstall and notification disable rates. If you’re a consumer app and your uninstall rate is below 2% you’re in a safe zone. So if your weekly churn is 1% and you have a 2% rate increase to 1.02%, that’s not devastating. Monitor any drastic fluctuation though, as a compounding effect week-on-week can become damaging.”

To capture the reward of the notification strategy, look beyond open rates to measure specific actions taken. “One tack that I recommend is to monitor a window of time post ping for the number of actions that can be tied back to the original notification. For example, if the notification encouraged users to rate places they’ve visited recently, analyze how many ratings users made per hundred pings within a 2-6 hour window,” says Weiss. “There are always questions of attribution, but if you define a fixed window of time to evaluate after a notification is shipped, you can accept the results with a higher degree of confidence.”





Recommended Article





**...but calibrate them to compare performance on iOS and Android.**

For those that want to track open rates as a metric, Weiss has a few observations about the nature of notifications on different operating systems. “It’s as easy to track open rates from pings as it is with email, but know that iOS open rates are much, much lower than Android; they can show up to five times more open rates for identical pings on iOS,” says Weiss. “Users tend to process the notifications on Android, as there’s an inbox that only clears as you manually open each ping, whereas on iOS, once you open up one notification from your lock screen, the others all clear.”

As with other functionalities, operating systems have different capabilities when it comes notifications. “For example, notifications on Android can display inline photos, which can get a free 15-20% boost of engagement. Since most developers are most often working in iOS, they don’t think to send Android push notifications with photos,” says Weiss. “There’s also inline action buttons so users can take steps from notifications. Those also get higher engagement rates. Basically everything about Android is better for notification development, and I say that as an iPhone user.”

> Fill your notifications with personalized tidbits, so they sound like they came from a close friend.

**Counteract the novelty effect.**

Run experiments with notifications for a minimum of six weeks but 12 weeks is a good sweet spot. Weiss has learned that conducting tests for a longer period of time is necessary to surface any negative effects. “The average user will ignore unwanted pings for about a month without taking action, such as altering settings or uninstalling the app. There’s a threshold that’s passed where annoyance surprasses the ease of quick dismissal,” says Weiss.

Notifications have strong novelty biases, which delay the true impact on users. Once Weiss launched an experiment to test emoji-heavy pings to users. “We cut down the length of text by half and added relevant emoji. In the first couple weeks of the experiment, our metrics shot through the roof. Users and ping opens were up significantly. WAUs [weekly active users] were up. It was tempting to announce that the future was here and it was emojis,” says Weiss. “Well, we monitored it over time and the growth slowed and then flatlined. In the end, the impact was neutral. That’s not bad, but it would have been if we allocated resources based off of initial results. It’s best to test in months rather than weeks with notifications.”

**Experiment with how, when and where.**

The “why” and “who” behind push notifications is often more straightforward — the goal is to increase engagement among all users. However, there’s a diversity of thought on the way in which pings should be released. Through his career, Weiss has helped launch over 100 notification experiments — testing everything from time of day to triggering based on arriving back at home. [As with shipping software, there's no "right" way](http://firstround.com/review/the-right-way-to-ship-software/), but here he shares some non-negotiables:

*   **Resort to vibration for only the most urgent of pings**. “With push, you can control the default of whether the phone vibrates or is silent. From all my user research, I’ve learned this is one of the most high-risk decisions. If a notification vibrates a user and she doesn’t find it urgent, the likelihood of the app being uninstalled immediately skyrockets,” says Weiss. “If it’s urgent — like you are about to miss your plane or an urgent, direct message from a coworker — a buzz can be a very powerful and appreciated tool. If not, it’s dangerous and will backfire, so don’t use it for events like favorites or likes from a friend. On average, people check their phone between 70 to 100 times a day, so they’re likely see your message anyway within the next 15 minutes.”

*   **Match users’ biorhythms**. “The timing of your ping matters, but there’s not one rule declaring the absolute best window. But take a moment to think about how to mirror the progression of your users’ days. Avoid sending notification when your user is asleep because you’ll wake them or they’ll find a queue of messages on top of yours in the morning,” says Weiss. “Consider the nature of your content, too. Sending news in the morning works well, as does sending content as they commute to or from work. Refine your cadence by monitoring their engagement.”

*   **Use variety of personalization in your copy**. “It makes a huge difference. Inserting the user’s first name doesn’t count, like ‘Noah, here are your daily deals for Tuesday!’ Showcase what you know about your users in the ping copy — otherwise they’ll activate their natural filter against marketing blasts,” says Weiss. “Twitter has a good practice for users catching up on their timeline. The service prompts you to check out tweets from the last day from Evelyn, Marcos and Lydia. These are all people you follow, called out by name. Spotify does the same with new songs from artists you listen to frequently.”

*   **Think of your ping as an Uber**. “Would you be happy if your Uber dropped you off on any block in Manhattan if you requested a specific one in the Lower East Side? Well, it seems obvious, but may startups forget to route their users to the screen in the app _exactly_ where the ping promised,” says Weiss. “People will click on the notifications if it gets them to where they were expecting. If not, they’ll ignore it the next time. A lot of e-commerce apps screw this up by sending customers to the generic home screen, rather than a specific item or page.”

> Magicians bring your card to the top of a deck. Apps with smart notifications will have this sleight of hand, lifting their service to the front of people’s phones at the right time.

## The Future of Notifications

Smartphone and smartwatch screens will keep changing, but the real estate of home screens will always be finite regardless of the size. Given the ballooning number of apps kept on phones, this limitation is a constraint. Here is how he sees mobile operating systems evolving and food for thought on the future of notifications:

**Make the lockscreen the new home screen**. The truth is that the only place people see more than their phone’s home screen is their lockscreen. “Your home screen houses the apps you want at your fingertips, limited to less than 20\. Your lockscreen lists your recent notifications from the hundreds of apps you have on your phone,” says Weiss. “I think that the lock screen is going to wind up replacing the home screen. There’ll be one home experience, which will have a stream of apps reaching out to you. Eventually ranking will matter more than just recency and frequency. The OS notifications will evolve from feeling like Twitter’s real-time, noisy stream to feeling like Facebook’s ranked feed.”

> You’ll always be able to navigate to an app, but notifications will be your steadfast sherpa.

[There's a natural phenomenon with the bundling and unbundling of apps](http://ben-evans.com/benedictevans/2014/8/1/app-unbundling-search-and-discovery), and Weiss sees a tide shift where the lockscreen will rebundle them once more. “Over the last three years, there’s been a gradual, giant unbundling in the app ecosystem. Apps have become more specialized for single purpose use cases,” says Weiss. “But as users amass dozens and dozens of apps, it’s increasingly hard to navigate to the right service at the right time. Notifications are apps signaling to people they have something timely and useful to offer. There will be a new navigation paradigm, where apps control — hopefully intelligently — when users are thinking about using them.”

**Enrich contextual awareness**. If users increasingly interact with apps through a stream of pings sent to a lockscreen, it’ll be because they inherently trust that they’re being sent the most timely, relevant alerts. That only happens with a robust contextual awareness. “The sensors on your phone allow you to build a level of contextual awareness into your mobile services that you could never do on desktop or email. How do you take that awareness and translate it into really actionable timely relevant notifications?” asks Weiss. “That’s kind of the exciting new frontier. Imagine a service that can distinguish if someone stops at a specific business, whether it’s a café or an airport or a gym. The unique understanding of context creates a ton of new opportunities for sending relevant pings.”

> The best apps will be the ones you don’t have to remember to use. They’ll remind you. Soon that’ll be the only type of app.

“One of my favorite push notifications from Foursquare is for new and trending venues in a city. It can crosslist that with the places you’ve actually visited just based on where your phone has been,” says Weiss. “It'll send you a notification usually once a week which is ‘Hey, here are three places that are hot and trending in your city that you haven't tried yet.’ It's this magical moment when you realize you’ve just been walking around with the phone in your pocket, maybe you haven’t even used the app all week. You haven’t had to do a single bit of work. It not only pulls you back into the app, but it also delights you.”

A comprehensive approach to leveraging sensors on mobile can be challenging, but there are basic ways to get started. “While most developers cannot easily build this type of location understanding, it's fairly trivial to build a model for understanding when a person is at home or work based on background location. Those are two very rich contexts for triggering relevant pings," says Weiss.

## Bringing it All Together

While notifications are great for boosting retention and engagement rates, don’t start off by looking at them as a growth hacking tool. They have the potential to be the most intuitive and intimate way to interact with your users. In order to build that trustworthy relationship, they must be timely, personal and actionable. A notification strategy must ask permission from users and be measured by their opt-outs, uninstalls and actions per 100 pings. The more that notifications can be customized actively via user input and passively through contextual awareness, the better.

“We are still in early days with mobile. Devices continue to shapeshift to have bigger screens, longer battery life or become wearable,” says Weiss. “Yet no matter how the hardware develops, notifications will be the most intimate feature of your mobile device. Like a close friend or family member, smart notifications remember your preferences and history. They’ll guide you the right direction, keep you connected with loved ones and remind you of what’s important at the best time. That’s about as powerful as technology gets.”

_Photographs courtesy of Slack._

