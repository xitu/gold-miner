> * 原文地址：[Exploring Apps Without Jailbreaking](https://medium.com/@nathangitter/exploring-apps-without-jailbreaking-e932904f9863)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/exploring-apps-without-jailbreaking.md](https://github.com/xitu/gold-miner/blob/master/TODO1/exploring-apps-without-jailbreaking.md)
> * 译者：
> * 校对者：

# Exploring Apps Without Jailbreaking

## Five simple techniques to learn how other apps are built

The Medium iOS app is a native app with a fake navigation bar and the Product Hunt app is built with React Native.

![](https://cdn-images-1.medium.com/max/800/1*OW-khVXV7oFfBpwdtOD_hw.png)

The Medium iOS app (left) and the Product Hunt iOS app (right).

How do I know? Unless I wrote the code myself or asked the developers who did, I can be confident based on a few simple tests—no jailbreaking required.

Want to learn how it’s done?

### Background

In the “early days” of the web, it was easy to learn how any site was built. By viewing the source in a browser, the underlying code could be exposed for anyone to see, remix, and reuse. As the web progresses and frameworks increase the complexity of sites, this is nearly impossible now.

![](https://cdn-images-1.medium.com/max/800/1*F1PatoKhttsUn6yowfwjDA.png)

Using Chrome to inspect the HTML of a Medium article.

Apps have the same problem, but worse. Apps are compiled, which means the original source code has been translated from a human-friendly format to a computer-friendly format.

While there are tools to de-compile iOS apps, they require a jailbroken device, special tools, and coding expertise. I’m going to share tactics that don’t require any hacker skills—all you need is the app installed on your device.

### The Key Idea

Our strategy is simple: push apps to their limits in hopes of breaking them. If we see how they break, we can infer how they work.

We are going to try to answer the following:

1.  Is the app native? If not, is it a web view? React Native? PhoneGap? Unity? Some kind of hybrid?
2.  What UI elements are being used? Mainly out-of-the-box components or something custom? How are they used to achieve the desired effect?

### The Experiments

To gather data, we are going to perform five tests. I will explain how to perform each test, what to look for, and what to conclude from the results.

We will be testing:

1.  Button touch states 👆
2.  Interactive navigation gestures 🔙
3.  VoiceOver 🔊
4.  Dynamic type 🔎
5.  Airplane mode ✈️

![](https://cdn-images-1.medium.com/max/2000/1*Mji7eJHwKQKQBh82Tv2obw.jpeg)

### Experiment #1: Button Touch States 👆

A button may seem simple. You tap on it, and something happens. However, not all buttons are created equal.

We are going to test the edge cases of button interaction—the behavior when the user doesn’t simply tap the button.

New iOS developers are often surprised by the complexity of interaction on a `UIButton` (the default button component on iOS). There are nine events that occur at various points in the interaction.

1.  `touchDown`
2.  `touchDownRepeat`
3.  `touchDragInside`
4.  `touchDragOutside`
5.  `touchDragEnter`
6.  `touchDragExit`
7.  `touchUpInside`
8.  `touchUpOutside`
9.  `touchCancel`

(Learn more about `UIControlEvents` in the [developer documentation](https://developer.apple.com/documentation/uikit/uicontrolevents).)

Almost all buttons perform an action on `touchUpInside` (when the user releases their touch inside the bounds of the control). Most buttons have a special state when the user touches down.

The real differentiating factor is how buttons handle the `touchDragExit` and `touchDragEnter` events. How do buttons respond when the user touches down on the button, then without lifting their finger, drags outside of the button and then back in?

![](https://cdn-images-1.medium.com/max/800/1*o9vaFZNIOoJOyRbe9QvU6A.gif)

Testing a standard button in the iOS simulator.

Standard `UIButton`'s have some common behaviors:

1.  The “touch area” when dragging back into the button is larger than the button’s bounds.
2.  There is an animation on `touchDragEnter` and `touchDragExit`.

However, customized native buttons often lose these default animations.

![](https://cdn-images-1.medium.com/max/800/1*7WEjgmPpcWb1RJU_7Vk3VQ.gif)

A custom button with no animations.

#### An Example

Let’s try an example with the Medium app. If you’re reading this on the Medium iOS app, you can follow along at home!

Let’s try this fancy-looking button in the bottom right:

![](https://cdn-images-1.medium.com/max/800/1*LjDIPzIsPupqBavlayV06g.png)

If you tap on the button, then while still holding, move your finger out and back in, you’ll notice the hand icon switching between its light and dark state.

(My next post: “How I growth-hacked my way to 100k claps” 😉)

#### React Native Buttons

React Native buttons are pretty easy to spot. They often have a slow fade animation, and it’s applied to **everything**.

![](https://cdn-images-1.medium.com/max/800/1*TRzUveN7gJy-QCCo-p-pEA.gif)

Button animation in Facebook’s F8 app. This is a common effect in React Native apps.

React Native apps usually make heavy use of scroll views, which can make this button behavior difficult to test, since dragging the button also scrolls the view.

While on the topic of React Native, another big giveaway is the touch states on “cells”. Traditional table cells apply a solid background color, while React Native cells usually apply a highlight effect similar to their buttons.

![](https://cdn-images-1.medium.com/max/800/1*kDDB-EtlYgMR_yENeMmg4Q.gif)

Left: React Native cell behavior. Right: Native cell behavior.

#### Web View Buttons

Of the PhoneGap apps I downloaded to test, ~95% of the buttons had no touch states at all, and the remaining ~5% had a touch down state, but didn’t have any effect when dragging out or back in.

#### Conclusions from button touch states

It’s important to keep in mind that these button behaviors are easily overridable. Exhibiting a particular behavior does not imply a cause—it’s just a clue in a certain direction.

You’ll have to get a “feel” for buttons over time, but it’s one of the easiest ways to start making educated guesses about how an app is built. (This technique can also be used to determine whether an interactive element is a button or some other kind of control.)

### Experiment #2: Interactive navigation gestures 🔙

Since iOS 7, users have been able to navigate to the previous screen by swiping the left edge of the display. This gesture is especially fun because it’s interactive, meaning it can be scrubbed back and forth.

This behavior comes for free when using a standard `UINavigationController` on iOS. For one reason or another, many apps forgo the standard behavior and end up with a missing, broken, or [janky](https://medium.com/@nathangitter/designing-jank-free-apps-9f66d43b9c87) navigation transition.

Let’s try it on the Medium app.

![](https://cdn-images-1.medium.com/max/800/1*DXaY3wngOmbDnygRsGR_5w.gif)

Comparing navigation transitions on the Medium app (left) and the App Store app (right).

Unlike a standard navigation transition, the Medium app moves the navigation bar with the rest of the screen. Normally the navigation bar stays constant and any labels cross-fade.

Additionally, the dark overlay on the previous screen is much darker in the Medium app, leading me to believe that the transition has been overridden, or more likely, is a totally custom component.

I personally think it looks really good, and understand there are major design and development benefits gained from this approach.

#### React Native Navigation

From a development perspective, navigation is more difficult in React Native. As a result, React Native apps tend to use custom navigation transitions instead of the standard “push” and “pop” of `UINavigationController`.

![](https://cdn-images-1.medium.com/max/800/1*xkAtEig66JoJISlBcl3YCw.gif)

A custom transition in Facebook’s F8 app.

Default modal presentations on iOS are not interactive, and don’t have a scaling effect on the screen that’s re-appearing.

Here’s another example of a custom transition in React Native.

![](https://cdn-images-1.medium.com/max/800/1*iOqkUpe_3TDIvt_JqSYo-A.gif)

A navigation transition in Facebook’s F8 app.

There’s no shadow or dark overlay, but the real giveaway is the animation timing. It’s hard to see in this gif, but after I release my touch, the animation completes much slower than normal.

Just like button touch states, this is something you can get a “feel” for over time by testing many navigation transitions.

#### Conclusions from interactive navigation gestures

This is one of my favorite tests since it can reveal more about an app than just how the navigation bar works. If the gesture breaks an app, it’s possible to learn about more than just the navigation transition.

However, just like button touch states, navigation transitions can be overridden. In practice, navigation transitions are less likely to be heavily customized since it requires significant development effort.

### Experiment #3: VoiceOver 🔊

You want superpowers? VoiceOver will give you superpowers.

VoiceOver is Apple’s version of a screen reader. Meant for low-vision users, this accessibility option reads the user interface aloud.

VoiceOver has another effect we are more interested in: it displays a black box around the currently selected element.

![](https://cdn-images-1.medium.com/max/800/1*7B6BZBbp-amooMt5ZOMvpA.png)

Voice over selecting elements in the App Store and Weather apps.

This allows us to break a screen into its parts. Instead of guessing how a screen is built, we can just have VoiceOver tell us! Sometimes it will even read aloud the type of element (“button”, “date picker”, etc).

If you haven’t played with VoiceOver before, it is worth learning. The basics:

1.  Drag on the screen to select elements.
2.  Double-tap anywhere on the screen to “tap” the selected element.
3.  Swipe left and right to quickly jump between elements.

Let’s investigate the Medium app with VoiceOver.

![](https://cdn-images-1.medium.com/max/800/1*_wvOl8sGA-2RjevOJcBzpA.png)

Using VoiceOver to select the title of a post in the Medium app.

Most of the elements act as expected. VoiceOver simply reads the content of the selection or the name of the element. However, there are a few unusual behaviors.

On the home screen, selecting the title of a post only reads half of the title. First it says, “Color Contrast Crash C”, then selecting the bottom of the title reads “Course for Interface Design”. There must be something custom about the layout of the labels that makes VoiceOver think the title is split into multiple labels, one per line. (My guess is they built a workaround for labels with custom line spacing, which usually requires overriding the `attributedString` property, and can lead to complications later.)

Selecting the description, we can see the power of VoiceOver to reveal hidden information. To most users, the label only says “There are an estimated 285 million…”. But VoiceOver tells us more: “There are an estimated 285 million people in the world who are visually impaired. This number includes anyone from legally blind to those”. In this case, all that data is stored in the label, but visually cut off.

* YouTube 视频链接：https://youtu.be/7iiah_J_N0A

VoiceOver demo on the Medium iOS app. (Make sure your sound is on.)

If you’re lucky, you can use this to access information you otherwise shouldn’t be able to access.

Here’s another fun one. On the “bookmarks” tab, if you have no bookmarks, there is an invisible label. It says “To bookmark stories, tap on the bookmark icon anywhere and it will be added to this list.”

![](https://cdn-images-1.medium.com/max/800/1*o-X2hCfV1rWjXIRWdWOa_g.png)

Using VoiceOver to select an invisible label in the Medium app.

My guess is that a developer quickly hid this label temporarily, with the assumption that it might be shown in the future. (Or maybe I’m just being A/B tested.)

#### Non-native Apps

VoiceOver works well for web view-based apps as well. If you hear words like “link” or “heading level one”, you’re in a web view.

Additionally, text can be split in various odd ways based on styling (because of its HTML representation), and elements may not be grouped naturally.

Games (built with Unity, SpriteKit, etc) generally do not have any VoiceOver support at all.

#### Conclusions from VoiceOver

VoiceOver provides the most reliable evidence of any test. It shows the visual bounds of elements, and reads invisible attributes. It’s a treasure trove of data about any screen.

As you use VoiceOver more, you’ll learn the default phrasing for various UI elements, and start to notice when it’s different.

As with any of these tests, VoiceOver is not 100% reliable. All of the VoiceOver text and bounding boxes are configurable by the developer. Apps optimized for VoiceOver tend to display less rich information about how the app works since the developer has fixed issues that cause it to break.

(Pro tip: Setting VoiceOver as your “Accessibility Shortcut” makes it easy to toggle on and off while testing.)

### Experiment #4: Dynamic type 🔎

Similar to VoiceOver, dynamic type is an accessibility setting for low-vision users. It modifies the text size throughout the system.

We want to use dynamic type to break layouts. And with the new “Accessibility Sizes” which are absolutely gigantic, this is easier than ever.

![](https://cdn-images-1.medium.com/max/800/1*KmwvxTP9Q2KyLfTqwo54MQ.png)

The “Larger Text” settings screen with the maximum type size.

Dynamic type can be activated in Settings > Accessibility > Larger Text. This can also be added as a widget to the control center in iOS 11 for easier access.

Unfortunately the Medium app doesn’t support dynamic type, so we are going to use the App Store app instead.

I set the text size to the maximum, and was able to find one broken layout—an advertisement on the search screen.

![](https://cdn-images-1.medium.com/max/800/1*IsqwosbqCtJVJADUySBb3A.png)

The App Store search screen with the largest type setting (left), and the default (right).

The clipping text “22K” is pretty great, but it doesn’t reveal too much about the layout, since the layout is adjusted for large type (seen by the elements in a stack instead of being side-by-side).

My favorite part here is the light blue “Ad” button. Instead of a nice rounded rectangle, we get a funky stretched shape.

![](https://cdn-images-1.medium.com/max/800/1*Q-v6oAigHDVBWNfBgzgmXQ.png)

The “Ad” button with a large type setting.

My guess is that this blue box is drawn as a custom path with a hard-coded radius. Usually controls don’t resize with dynamic type (see the “GET” button as an example), so there’s something custom going on here.

#### Conclusions from dynamic type

Some apps simply don’t support dynamic type. Even if they do, they might not support the larger accessibility sizes.

When it works, dynamic type can stress-test layouts. Some of this information is viewable already with VoiceOver, but it can help to verify theories. Generally apps that support dynamic type have also tested dynamic type, which reduces the chance of revealing useful information.

### Experiment #5: Airplane mode ✈️

Another simple test is to enable Airplane mode. Airplane mode disables Wi-Fi and cellular connection, which causes network requests to immediately fail. By disabling network connections in various situations, we can see how apps break.

In the Medium app, if you load the home page, turn on Airplane mode, and select a post, the post will still load. In fact, the entire post is still readable.

![](https://cdn-images-1.medium.com/max/800/1*uKDEsrYBp0PRfIVlq8aLoA.png)

The Medium app with Airplane mode on. The content loads, but images do not.

From this, we know that the app pulls the content for entire posts when it loads the previews (and does some caching).

The App Store app lazily loads images as well. Turning on Airplane mode after loading an app page and scrolling to the bottom reveals blank spaces where the loaded images belong.

![](https://cdn-images-1.medium.com/max/800/1*ayzVeFPBdoN9UwaPIKdSsQ.png)

The App Store app with Airplane mode on. Images (even on the same page) appear to lazily load.

Most modern apps depend heavily on network connections to download content and allow interactivity, so this will break most apps.

#### React Native and Non-Native Apps

Of the React Native apps I tested, most immediately responded to a lack of internet connection by removing all content on the screen and displaying a custom “no connection” message.

For webview-based apps, most didn’t respond. There was no indication that loading was occurring, or that it failed.

#### Conclusions from airplane mode

Unfortunately, airplane mode doesn’t give too many definitive answers on how the app is built, as most apps have some kind of fallback when no connection is available.

Want to dive deeper? You can learn a lot about other apps by observing their network traffic. Charles Proxy for iOS is a great way to get insight, but requires some knowledge of HTTP networking.

### Takeaways

While it may seem impossible to determine how an app is built, there are some ways to make educated guesses. By studying edge cases, we can reveal the inner workings of the larger system.

Our learnings can inform the design and development of our own apps. Being aware of other approaches helps us make better decisions in the future.

In a world of closed-source apps with a limited ability to tinker, hopefully these techniques help some people discover (or rediscover) the joy of learning how things work.

* * *

Enjoyed the story? Leave some claps 👏👏👏 here on Medium and share it with your iOS design/dev friends. Want to stay up-to-date on the latest in mobile app design/dev? Follow me on Twitter: [twitter.com/nathangitter](https://twitter.com/nathangitter)

Thanks to [David Okun](https://twitter.com/dokun24) for revising drafts of this post.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
