> * 原文链接 : [Exploring the Product Design of the Stripe Dashboard for iPhone — Startups, Wanderlust, and Life Hacking — Medium](https://medium.com/swlh/exploring-the-product-design-of-the-stripe-dashboard-for-iphone-e54e14f3d87e#.ff88r5yuu)
* 原文作者 : [Michaël Villar](https://medium.com/@michaelvillar)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

Because of the service it provides, Stripe didn’t start as a mobile-first company, like many other startups these days. The core business is the payments API, allowing companies to get setup to accept payments within minutes. The web dashboard makes it easy for everyone on a team to track and manage subscriptions, payments, customers, and transfers. However, it was designed for larger screens and as such, is barely usable on mobile. After shipping the latest version of Checkout, we decided to focus on developing [a mobile app](https://stripe.com/dashboard/iphone), starting with the iPhone.

![](https://cdn-images-1.medium.com/max/1200/1*mAvkW9E9TeJPUquXCM6t2w.png)


This article is about the creation process of the app, and more generally, about how [Benjamin](https://twitter.com/bdc) and [I](https://twitter.com/michaelvillar) design products. It’s not necessarily a new way of doing things but I wanted to share it for the curious.

_Designing any product can feel overwhelming but by diluting it down to the essential user experience, you can make it approachable and doable._


We spend a lot of time in the conceptualization phase. Even though it’s the first step, product design never truly ends and should be carefully revisited at all times.

Our first meeting starts with white boarding, where we start by identifying all of the features that are part of the core experience, as we define it. For the Dashboard for iPhone app, we envisioned it as a companion app and focused on two main use cases, rather than having it be a full-featured version of the web dashboard:

1.  An app you open first thing in the morning to quickly review yesterday’s numbers
2.  A way to be able to quickly look up customers, payments, and transfer information


![](https://cdn-images-1.medium.com/max/600/1*WmJOXZSO70d8XSqH0AHSGQ.gif)


After defining the features, we work on the wireframes. We have the added difficulty of working with a 9 hour timezone difference. In order to work around this, we draw things on paper, take pictures, and record an explanation of the wireframes. We send them to each other and wait for the response. Here is an example (in French): [http://bit.ly/1GSByqd](http://bit.ly/1GSByqd)

Our wireframes are really rough. There’s no visual refinement; it’s really about the flow and overall user experience. They help us define our expectations and remind us of what we want on every screen.


![](https://cdn-images-1.medium.com/max/600/1*glT8wsxJ9Ke3Mjh3nRmJfg.gif)


When our wireframes are done, we start working on the visual design. At the beginning of this stage, we work closely together to find the right direction that best fits our vision. The homepage, for example, took a lot of different iterations. We knew that we wanted recent activity front and center but deciding what _didn’t_ need to be there was tough. It’s easy to think the more data the better, but we had to decide which were the most important and deserved the limelight versus their interesting-but-not-necessary cousins.

When we both agree on the visual design direction, Benjamin starts finalizing everything. Of course, there is plenty of feedback along the way but mainly, Benjamin runs the show here.


Interactions are thought about during the whole visual design process but we only begin to prototype them when we have a clear idea of the visual design. In the prototyping phase, we can confirm whether our initial interaction ideas were right or not.

For the Dashboard app, the main one was the cards paradigm. We decided to implement a web prototype of it, which was ridiculously buggy, but it convinced us that the idea was one worth pursuing.


![](https://cdn-images-1.medium.com/max/800/1*np5s8zeu57ol8JeAKFNQHg.gif)


Getting this UI to feel intuitive and snappy is complex.

*   You want new cards to be opened in a way to show that users how they can be manipulated: slide open from the side with a slight spring because that’s how they can be moved and dismissed
*   You want an extra shadow when you drag a card to emphasize that you’re controlling that specific card
*   You want to move the other cards behind it forward when you’re dragging a card away in order to show their progress
*   You want to match the velocity of the card being thrown away to the velocity of the deck moving forward so that it’s clear the actions are connected
*   You want cards farther back to be darker like they would be in real life


For the action menu, we wanted a contextual menu without opening a large and intrusive native popup menu. We came up with this fun animation that works well for us since we didn’t have more than two actions per card. You also don’t even need to close the menu if you are not interested.


![](https://cdn-images-1.medium.com/max/800/1*w2xZf1DxkHQGV0ACBYYL0w.gif)

Toggling the actions menu (we did a HTML/CSS prototype)


You can switch the time period displayed in the revenue/customer graph. The way we’ve made this animation helps users understand where the previous time period fits in the new one. If you look closely, you’ll see that as the units change from days to weeks, we fade the graphs out while scaling.


![](https://cdn-images-1.medium.com/max/800/1*htXPyd36h2udb2Yk2q6j0g.gif)

Changing time periods in the graph view


When an app is internet dependent, you can either show a landing screen or an empty app with lots of spinners. We end up choosing the former combined with an animation because during that loading period the app isn’t responsive anyway. Here are a few of the startup animations prototypes we came up with:


![](https://cdn-images-1.medium.com/max/800/1*wHNuKP1WqqUWmxKMLuHXNg.gif)

For the startup animation, we did a few prototypes in HTML/CSS and After Effects.

At app launch, we wait for the data to be loaded to display the first screen and show the UI all at once with no extra spinner or UI blinking. If the network is too slow, we’ll show the UI with spinners anyway after a few seconds though.


We also added a tap animation (inspired by [Material Design](https://www.google.com/design/spec/material-design/introduction.html)) when you tap on a row anywhere in the app. We added a 100 ms delay before opening the card for two reasons: 1) the data needs to load and showing an empty card is unhelpful and 2) the user has the time to see where they tapped.

![](https://cdn-images-1.medium.com/max/800/1*i9B3HzFDLxT_UKCMmpEkiw.gif)


My strategy behind implementing an app is pretty simple: I always start by implementing the user interface. The UI is the most important part of the app and should be a main focus for iOS app developers. Starting with the user interface without binding any data or working with the API will help you make sure the UI is as smooth as possible. It also makes it easier to understand why performance degrades when implementing new features and allows us to fix these problems faster.

This is one of my favorite features of the app. We use push notifications for a few different things at the moment (more to come):

*   Daily summary: a quick look at your sales and new customers from yesterday when you wake up in the morning.
*   New payments and new customers: for small businesses, it’s really exciting to see your business growing.
*   Failed transfers: we want to make sure our users notice their transfers failing and explain how to fix them.
*   Account changes: we let the users know that their password or bank account has changed as soon as it changes. This allows them to react and contact support if the changes were unauthorized.

For non-urgent notifications, we make sure to send them during business hours, depending on the user’s timezone. Nobody wants to be woken up in the middle of the night!

Today, the iOS team ([Ben](https://twitter.com/benzguo) and [Jack](https://twitter.com/jflinter)) is working on a bunch of new features and improvements that are taking the product that Benjamin and I started to the next level.

I’ve thought a lot about why Benjamin and I are able to kick off new products together so well. Having a team with complementary skills is key to this. We start by working together on product design, then he focuses on visual design while I focus on the code. It’s a great combination — between the two of us we’re able to create entire apps together. Everything moves lightning fast, and you spend less time in meetings and clarifying the vision if members are on the same page. Of course, it also helps if you worked with the same person for the last 5 years.

Thanks to [Kat](http://twitter.com/kitchenettekat) for rewriting my English to make it human-readable.

[You can follow me on Twitter :)](https://twitter.com/michaelvillar)
