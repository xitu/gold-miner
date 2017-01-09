> * 原文地址：[How To Communicate Hidden Gestures in Mobile App](https://uxplanet.org/how-to-communicate-hidden-gestures-in-mobile-app-e55397f4006b#.po5wdv20m)
* 原文作者：[Nick Babich](https://uxplanet.org/@101?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How To Communicate Hidden Gestures in Mobile App #

Gestures, those little movements of finger and thumb that allow user to interact with an app. Touch interfaces provide many opportunities to use natural gestures like tap, swipe and pinch to get things done, but unlike graphical user interface controls, these interactions are often hidden from users, so unless users have prior knowledge that a gesture exists, they won’t try.

How to incorporate hidden gestures? Luckily there are number of visual interaction design techniques for making them known.

### Tutorials and Walkthrough During Onboarding ###

Tutorials and walktrhoughs is quite a popular practice for gesture-driven apps. Incorporating tutorials in your app in many cases means showing some instructions to the user to explain the interface. However, UI tutorial isn’t the most elegant way to explain the core functionality of an app. There are two problems with this approach:

- If you have to give your app an instruction manual, then you’re not doing a good job of communicating with your users because users cannot be expected to read a manual before using your app.

- Another problem with tutorials is that users have to remember all of those new ways of using the app once they get in.

For example, in Clear app starts with a mandatory 7-page tutorial and users have to patiently read all the information and try to commit it to their memory. That’s bad design because it requires users to work upfront even before they actually try the app.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*GPB-VY6vVkRPtU1t.png">

*Tutorial in Clear app*

Avoid mandatory multi-step UI walkthrough and try to educate in context of action (when user actually needs it). Given some iteration, tutorial can be transformed into a more gradual discovery:

> Focus on a single interaction rather than trying to explain every possible action in user interface

Take this gesture education screen from YouTube app for Android as an example:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*jit4P5QZ3GGKTjtc.png">

Youtube app for Android

The app has a gesture-based interaction, but doesn’t use tutorial to instruct users. Instead, it uses hints that appear on the first launch for new users, one at a time, as the user reaches the relevant section of the app.

### How To Educate in Context ###

Education in context technique helping users interact with an element or surface in a way they have not done so previously. This technique often includes* slight visual cues* and *subtle animation.*

#### Plain Text Command ####

This technique is based on text command which prompts users to perform a gesture and describe the result of the interaction in short and clear description.

**Tip:** Use ultra-short text for instruction — the less text overall, the more likely it is that users will read it and then actually follow that instruction.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*jZyn5K8phjbxoFiZNYKZ6A.gif">

Credits: Material Design

#### Hint Motion ####

Hint motion (or animated visual hint) shows a preview of how to interact with element when performing the action. For example, Pudding Monsters’ game mechanics are based solely on gestures, but they allow users to get the basic idea of what to do without guessing too much. Animation conveys information about functioning — a scenario is showcased with animation and it immediately becomes clear for users what to do.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*mtNyp2a4Ovg2usopA6cOfw.gif">

Hint motion shows a preview of how to interact with an element. Credits: Pudding Monsters

#### Content Teases ####

Content teases are example of subtle visual clues, which indicate what’s possible. Example below demonstrates a content teases for cards — it simply shows that other cards exist behind a current card and this makes it clear that swiping is possible.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YjZGGyu1OLaddxQ-b-NKXg.gif">

Exhibit navigation functionality. Credits: [Barthelemy Chalvet](https://dribbble.com/BarthelemyChalvet)

### Conclusion ###

The bottom-line is that there’s no one-size-fits-all solution to how to introduce gestures for your users in a mobile or web app. But when it comes to teaching users to use your UIs, I would recommend to do so mainly by educating in context using content teases,[ progressive disclosure](https://uxplanet.org/design-patterns-progressive-disclosure-for-mobile-apps-f41001a293ba#.p5aq5o4f2) and subtle animations. Tutorials and walkthroughts should be used only as a final resort.

Thank you!
