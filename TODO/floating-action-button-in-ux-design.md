> * 原文地址：[Floating Action Button in UX Design](https://uxplanet.org/floating-action-button-in-ux-design-7dd06e49144e)
> * 原文作者：[Nick Babich](https://uxplanet.org/@101)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

![](https://cdn-images-1.medium.com/max/800/1*0qLDFA-7qPANEMKO6xCEtw.png)

# Floating Action Button in UX Design #

Floating Action Button (FAB) is a very commonly used control in Android apps. Shaped like a circled icon floating above the UI, it’s a tool for designers to call out the key parts of the app’s product story. FAB is quite simple and easy to implement UI element, but designers often incorrectly incorporate it into designs.

In this article you’ll find answers on following questions:

- When to use FAB?
- What are best practices for FAB?
- How FAB and animation can work together to improve UX?

### When to Use FAB? ###

#### For hallmark actions ####

FAB highlights the most relevant or frequently used actions. It should be used for the actions that are strongly characteristics of your app. Ideally, the FAB should represent the core function of your entire app just like in the example below.

![](https://cdn-images-1.medium.com/max/800/1*fV1xkVAU9VS-jmoydI5TDw.jpeg)

A floating action button represents the primary action in an application. Pausing or resuming playback on this screen tells users that it’s a music app.

#### As way-finding tool ####

FAB is a natural cue for telling users what to do next. Research by Google shows that, when faced with unfamiliar screen many user rely on FAB to navigate. Thus, FAB is very useful as a signpost of what’s important.

![](https://cdn-images-1.medium.com/max/800/1*NrhEXDLgvSfLoUs24KiY0A.png)

Twitter uses FAB for write a tweet action.

#### Not every screen needs a FAB ####

FABs are colorful, raised, and grid-breaking. It’s very difficult not to spot these buttons, and that’s because they are designed to stand out. But not every screen should use the FAB simply because not every screen has an action of this importance.

> Do not use a FAB at all costs. It’s only for promoted actions!

One good example is [Google Photos app](https://play.google.com/store/apps/details?id=com.google.android.apps.photos&amp;hl=en) for Android. The app opens in a gallery view, which has a floating action button for search. There are two problem with a FAB here:

- Search is an extra action for the majority of users. The primary task is photo browsing. Thus, there’s no need to have this FAB.
- The presence of a FAB can distract and take up a user’s attention away from the main content (photos).

![](https://cdn-images-1.medium.com/max/800/1*9TQLyWdW0Jo4kjkjQh4BKA.png)

Search is extra action for Google Photos and doesn’t require FAB

**Tip:** Finding the primary action of a screen can be much harder than it first seems. In order to simplify the task and understand whether you need FAB in your UI use a simple *five minutes rule: i*f you struggle for more than 5 minutes searching for what your screen primary action should be, it’s clear that the FAB isn’t required for this view.

### Best Practices for FAB ###

#### Avoid mystery meat navigation ####

The term “Mystery meat navigation” was introduced by Vincent Flanders, a creator of the famous website [Web Pages That Suck.](https://en.wikipedia.org/wiki/Mystery_meat_navigation)  It refers to buttons or links that don’t explain to you what they do. Instead, users have to tap on them to find out.

FAB is an icon-only button and the problem is that [icons are really hard to understand](http://uxmyths.com/post/715009009/myth-icons-enhance-usability) because they’re so open to interpretation. As NNG [points out](https://www.nngroup.com/articles/icon-usability/), universally recognised icons are rare. For example, can you guess what a button in example below does?

![](https://cdn-images-1.medium.com/max/800/1*p6e4Z9F353Fj-U_gSnnzYg.png)

What does FAB means here?

You don’t know for certain until you tap it. And if a user needs to guess, your button is mystery meat. Some may say that the the time it takes to discover what these icons means is quite short and the percieved possible risk very low. Yes, the time it takes to find out what an icon means, by tapping on it, may be quite small. But there is a cognitive load:

> User will have to remember what it means.

Multiply that by all the mystery meat icons in all your apps and that is not small effort.

It’s acceptable to use icons-only buttons but only ifyou make sure they are *context-relevant and* clear for your users. Context is what helps users interpret icon-only buttons and explain the actions. For example, if you have a note taking application it’s quite clear that the main purpose of the app is to take — and view — notes. And a ‘Pen’ icon would be great in this context.

#### Use only one FAB per screen ####

Because FABs are so prominent/intrusive, FAB’s should be used *once on a page or not at all.*

![](https://cdn-images-1.medium.com/max/800/1*ONI398PyIgulggs6TEmg5Q.png)

**Don’t **have more than one floating action button per screen.

#### Use FAB only for positive actions ####

Because the FAB is characteful, it’s generally a positive action, like create, share, explore, and so on. FAB shouldn’t be destructive action, like delete or archive. They shouldn’t be unspecific or alerts, limited actions like cut-and-paste the text, or actions that should be in a toolbar (e.g. changing a volume).

![](https://cdn-images-1.medium.com/max/1000/1*2v9CL54h2AQfp-mMV_O4iQ.png)

The function should be an action that makes user feel positive about using FAB and never worried it’s going to do something wrong. Image credit: Material Design

### FAB and Animation ###

Floating action buttons are designed to be flexible. FAB can expand, morph, and react.

#### Expand into a set of actions ####

In some cases, it is appropriate for the button to spin out and expose a few other options (as seen in the Evernote example below). The FAB can replace itself with a sequence of more specific actions and you can design them to be contextual to your users. But keep in mind that:

- These actions must be related to the primary action the FAB itself expresses and be related to each other: do not treat these revealed actions as independent as they could be if positioned on a toolbar.
- As a general rule, have at least three options upon press but not more than six, including the original floating action button target.

![](https://cdn-images-1.medium.com/max/800/1*mjNKHpgABoV0gG72hfHMCQ.gif)

A floating action button flinging out related actions.

#### FAB can morph into the new surface ####

FAB is not just a round button, it has some transformative properties that you can use to help ease your users from screen to screen. The floating action button can transform into views that are part of the app structure.

> FAB can improve transitions between screens

When morphing the floating action button, transition between starting and ending positions in a logical way. For examle, the animation in example below maintains the user’s sense of orientation and helps the user comprehend the change that has just happened in the view’s layout, what has triggered the change and how to initiate the change again later on if needed.

![](https://cdn-images-1.medium.com/max/800/1*jSCtVcpUQnYNwxck1Pcp1w.gif)

Image credit: [Ehsan Rahimi](https://dribbble.com/EhsanCinematic) 

#### FAB can be hidden during scrolling ####

FAB can be hidden when scrolling down if it gets in the way (prevents user from reading the content). In example below, the FAB *needs* to be able to move out of the way, so that all parts of all list items are actually reachable.

![](https://cdn-images-1.medium.com/max/800/1*fUdO6yS6KkNX7m-vXuzqWA.gif)

Hide FAB to maximise the viewport area dedicated to the list. Image credit: [Juliane Lehmann](https://lambdasoup.com/post/fab_behavior_sync_appbarlayout/) 

Medium app for Android is a good example of using this technique. The Heart button disappears on scroll and reappears when the end of the article is reached — just when readers who liked the article would have wanted to use the button.

### Conclusion ###

If you’re going to use FAB in your app, the design of the app must be carefully considered and the user’s possible actions must be boiled down to a single most prominent feature. Used correctly, FAB can be an astoundingly helpful pattern for the end-user.

Thank you!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
