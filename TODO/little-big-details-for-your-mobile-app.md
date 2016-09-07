> * 原文地址：[Little Big Details For Your Mobile App](http://babich.biz/little-big-details-for-your-mobile-app/)
* 原文作者：[Nick Babich](http://babich.biz/author/nick/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


Your app’s success is based on a combination of factors, but the overall user experience tops them all. The apps that stand out in the market are those that deliver great UX. When it comes down to designing for mobile UX, sticking to best practices is a solid way to go, but during the creation of the big picture it’s fairly easy to skimp over design elements that feel like nice to have but not necessary. However, the difference between creating good experiences and amazing experiences often comes down to how thoughtful we can design these small details.

In this article you’ll see why these _little big details_ are just as important as the more obvious elements of your design, and how they help determine the success of your app.

## Splash Screen

When a user launches your app, the last thing you want to do is tell them to wait. But what if your app has a time-consuming initial setup phase and there’s _impossible_ to optimize this step? You _have to_ ask users to wait. And if they should wait, you should figure out how to _engage them_. A splash screen solves the waiting problem and gives you a short but vital window to engage a user in your proposition.  

![](http://babich.biz/content/images/2016/08/1-kA8WMVt3-7UxbCYieFoOsg.png)

Image credit: mobile-patterns

Here’s a few tips to keep in mind when you’ll design a splash screen:

*   Both [Google](https://developer.android.com/training/articles/perf-anr.html) and [Apple](https://developer.apple.com/ios/human-interface-guidelines/graphics/launch-screen/) suggest to use the launch screen to improve the user experience by _simulating faster loading times_. Splash screen gives the user immediate feedback that the app has started and is loading. To ensure people don’t get bored while waiting for something to happen, offer them some _distraction_: something fun, something unexpected or anything else that catches your users’ attention long enough for your app to load.

    ![](http://babich.biz/content/images/2016/08/1-88tQ_gtQrWY7LQXUMglNzg.gif)

    Image credit: Cuberto

*   If your app has a initial setup phase, which takes more than 10 seconds, consider using [progress indicators](http://babich.biz/progress-indicators/) to show that loading is in progress. _Keep in mind that uncertain waits are longer than known, finite waits._ Thus, you should give your users a clear indication of how long they need to wait.

    ![](http://babich.biz/content/images/2016/08/1-Qq7rzaTpyd2OndF3zgyZtA.png)

    Make the loading process feel natural by using progress bars. Image credit: de_martin

## Empty States

We normally design for a populated interface where everything in the layout perfectly arranged and looks great. But how should we design our screen when it’s pending user action? I’m talking about empty (or blank) states. Designing an empty state is a very important moment, because even it’s meant to be just a temporary stage it should be _a natural part of your app_ and _be helpful_ for your users.

The purpose of a empty state is more than a just decoration. Besides informing the user about what content to expect on the page, empty states can also act as a type of _onboarding_ (they introduce the app and demonstrate what it does to your users) or _helping hand_ for your users (the screen when things go wrong). In both cases, you want your users to do something so that the screen wont’ be empty as soon as possible.  

![](http://babich.biz/content/images/2016/08/1-W3q0L25iO7HP6ywPYQJ9lQ.png)

Image credit: inspired-ui

Here’s a few tips to keep in mind when you’ll design an empty state:

*   _Empty state for a first-time user._ Remember that first time user experiences should be _focused_. When designing empty states for a first-time users, keep them as simple as possible. Focus on primary user goals and design for maximum interactivity: clear message, right imagery, and a action button is everything you need.

    ![](http://babich.biz/content/images/2016/08/1-Wg23TxJp1IFCSwpiaZ43zw.png)

    Khaylo Workout is a great example of a proper empty state design. This empty state tells users why they see it (because they haven’t challenged any friends) and how to fix it (tap the ‘+’ icon). Image credit: emptystat.es

*   _Error state._ If the empty state was due to system or user error, you must find a balance between friendliness and helpfulness. A short sprinkling of humour is often a great way to diffuse the frustration of an error, but it’s more important that you clearly explain the steps to solve the problem.

    ![](http://babich.biz/content/images/2016/08/1-czn24uzZvVIsLRhc2nVYag.png)

    Feel lost and unconnected, like you are on a deserted island? Follow the advice from Azendoo, keep calm, light a fire, and keep refreshing. Image credit: emptystat.es

## Skeleton Screens

We don’t usually think about different loading speeds for our content —  we believe that it loads instantly (or at least very quickly) all the time. So we don’t usually design the uncomfortable moments when users must wait for content to display.

But internet connection speeds aren’t always guaranteed and actions can take longer that expected. This is especially true when heavy content (such as images) is downloading. If you can’t shorten the line you should at least try to make the wait more pleasant for your users. You have a great opportunity to keep users engaged by using _temporary information containers_, such as skeleton screens and image placeholders. Rather than show a loading spinner, skeleton screens create anticipation of what is to come and reduce cognitive load.

Here are a few tips for your design:

*   The load screen doesn’t need to be eye-catching. It should highlight only necessary information such as structure of the sections. Facebook’s gray placeholder is a good example — it uses template elements when loading content and makes the user familiar with the overall structure of the content being loaded. Notice that images used in skeleton screen aren’t drastically different from wireframes.

    ![](http://babich.biz/content/images/2016/08/1-PGXSupBdpfiGeU6zwfBxNw--1-.jpeg)

*   For a loading image you can use a placeholder filled with the predominant color of the loading image. Medium has a nice image loading effect. First, load a small blurry image, and then transition to the large image.

    ![](http://babich.biz/content/images/2016/08/1-jFvvQCNfMH7rs-QG5DprKg.png)

    Before the actual image appears, you can see a placeholder filled with the blurry image. Image credit: jmperezperez

## Animated Feedback

Good interaction design provides feedback. In the physical world, objects like buttons respond to our interactions with them. People expect a similar level of responsiveness from app elements. Visual feedback makes users _feel in control_: 

*   It communicates the results of any interaction, making it visible and understandable.
*   It gives the user a signal that they (or the app) have succeeded or failed at performing a task.

Animated feedback should save time by instantly communicating information in a way that doesn’t bore or distract the user. The most basic use of animated feedback is in _transitions_:  

![](http://babich.biz/content/images/2016/08/1-JySxzSIszvxYECYOo0Gxag.gif)

When users see an animated feedback triggered by click/tap action, they instantly know the action was accepted. Image credit: Ryan Duffy

![](http://babich.biz/content/images/2016/08/1-VQ66RMfNtTLiCX4jqqhlFQ.gif)

When user checks the box to indicate that the task is complete, the block containing this task shrinks in size and changes its colour to green. Image credit: Vitaly Rubtsov

but an app can truly delight a user when [animation](http://babich.biz/animation-in-mobile-ux-design/) is used in ways beyond the standard scope of actions.  
Here are a few tips and things to remember for animated feedback:

*   Animated feedback must survive long-term use. What seems fun the first time might become annoying after the 100th use.

    ![](http://babich.biz/content/images/2016/08/1-DCw_ooNYrwRAs_19o_wcsQ.jpeg)

    Image credits: Rachel Nabors

*   Animations can distract your visitors and make them ignore long loading times.

    ![](http://babich.biz/content/images/2016/08/1-JzEgzgSjJKV7zxWKPdBAjg.gif)

    Image credit: xjw

*   Animation can make your user experience truly delightful and memorable.

    ![](http://babich.biz/content/images/2016/08/1-l2AHcRcm2Knky-IpD0hP4g.gif)

    Image credit: Tubik

## Conclusion

_Design with care._ Each minor detail in your app’s UI deserves close attention, because UX is the sum of all details working harmoniously. Thus, polish your UI from A to Z in order to create really amazing user experience.

Thank you!



