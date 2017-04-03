> * 原文地址：[O-h yeah! What we look forward to in Android O](https://www.novoda.com/blog/o-h-yeah-what-we-look-forward-to-in-android-o/)
> * 原文作者：[Novoda](https://www.novoda.com/blog/author/novoda/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# O-h yeah! What we look forward to in Android O


Novoda has a reputation of building the most desirable apps for Android and iOS. We believe living and sharing a hack-and-tell culture is one way to maintain top-shelf quality.
        

This week Google has announced the new Android O Preview programme. Like most Android developers out there, we poured over the documentation to find out what new feature tickles our fancies the most. Here’s what people at Novoda are looking forward to.

![Android O-Some](https://2.bp.blogspot.com/-WSPrWvuvCvc/WM80F43fu4I/AAAAAAAAGtU/N73vMkriLX8rH-lt1t2cns9YSuJlBHr_wCLcB/s1600/android-o-logo.png)

## Sebastiano Poggi

> There are a lot of very interesting new APIs and features in this release; to me, being a UI kind of person, there are a few that have been making me giggle with delight.

### Wide gamut and diverse colour spaces support 🌈

![Adobe RGB vs sRGB colour spaces](https://developer.android.com/reference/android/images/graphics/colorspace_adobe_rgb.png)First and foremost, I'm *extremely* happy that Android will be able to handle **colour spaces** properly. No more being limited to sRGB, now apps will be able to properly display images that are stored in the Adobe RGB, ProPhoto RGB and many others. The new APIs will also help you with [converting between colour spaces](https://developer.android.com/reference/android/graphics/ColorSpace.Adaptation.html). The [documentation](https://developer.android.com/reference/android/graphics/ColorSpace.html) seems excellent as well, even just to learn about colour spaces!

*Fun fact:* all the [named colour space graphs](https://developer.android.com/reference/android/graphics/ColorSpace.Named.html) in the docs have been generated with the new [`ColorSpace.Renderer`](https://developer.android.com/reference/android/graphics/ColorSpace.Renderer.html) on Android.

### First-party and first-class fonts support ❤️

For years now Android developers have been forced to use clever hacks to implement fonts support in apps, such as [Calligraphy](https://github.com/InflationX/Calligraphy) or custom span-based solutions. Unfortunately there is still a lot of limitations with that approach, such as the layout preview in Android Studio not showing the custom fonts, or the inability to apply the fonts in some unusual cases (such as `TabLayout`‘s tabs that get their `textAppearance` separately from their inflation ಠ_ಠ). So I’m very, very happy that all these things will be sorted out in the next version of the OS, with the introduction of **font resources**. It took some time, but we’re getting there. Hopefully it’ll get to the [support library](https://twitter.com/chrisbanes/status/844274842279051264), too…

### Adaptive Icons ⚪ ⬛ 🔴 ⬜

![Three dimensional animation of an Adaptive Icon](https://d2mxuefqeaa7sj.cloudfront.net/s_D495BEC1F83AAA38C0FCFF599E996A34C92045AC1FD3533493D989F431CA82C0_1490194268969_NB_Icon_Layers_3D_03_ext.gif)

I think this might have been introduced to put a leash on OEMs that like to mess a bit too much with things. Embracing the current (mal-)practice of adding a background to icons is not *exactly* new—[round launcher icons](https://developer.android.com/about/versions/nougat/android-7.1.html#circular-icons) in Android N were a first step in that direction. **Adaptive icons** will take it the next level though, allowing OEMs and launcher developers to specify a mask to apply to an application-provided background image. This way, icons will fit into whatever style the context they show up into dictates, without having to ship all possible variations.

In addition, the new assets are supposed to be substantially larger than the previous images, with a lot of leeway for animating the icons:

![Parallax animation on an Adaptive Icon](https://d2mxuefqeaa7sj.cloudfront.net/s_D495BEC1F83AAA38C0FCFF599E996A34C92045AC1FD3533493D989F431CA82C0_1490194498483_Single_Icon_Parallax_Demo_01_2x_ext.gif)![Zoom/pop animation on an Adaptive Icon](https://d2mxuefqeaa7sj.cloudfront.net/s_D495BEC1F83AAA38C0FCFF599E996A34C92045AC1FD3533493D989F431CA82C0_1490194498352_Single_Icon_Pickup_Drop_01_2x_ext.gif)

## Ataul Munim

> A few things caught my eye which will be interesting for those of you interested in inclusive design.

### Accessibility Button

Accessibility services (like Google TalkBack) will be able to request an additional button in the navigation bar for devices with soft navigation keys.

This button will provide a service-specific shortcut. So far, only TalkBack has implemented it—though I think they had the inside track on this one!

It’ll be interesting to see how services use (and mis-use) this feature, and how the system will deal with multiple services that are vying for the same space.

### Fingerprint gestures

Many of you will already be using fingerprint gestures as convenient shortcuts for frequently performed tasks on your phones, from scrolling through content to pulling down the notification shade.

Fingerprint gestures being made available to accessibility services can only be considered a good thing, providing this addition is transparent to app developers and is handled wholly by Android or the service in question.

I wonder if it could be used to bring back something similar to the optical trackball!

### Autosizing TextView 👓

This is the one I’m a little worried about. All too often we see apps that don’t cater for users that make use of the system font size selector (available in Settings > Display), resulting in clipped text and thoroughly confused readers.

I suspect we’ll see this issue exacerbated by apps using the autosizing TextView, though if I put my Hopeful Hat on, maybe it'll prompt designers and developers to consider what their apps will look like with various text sizes.

## [Paul Blundell](http://twitter.com/blundell_apps)

> Everyone is thinking, there are no desserts beginning with the letter O... While I'm excited for the new APIs, I'm more excited that perhaps M will get more device adoption now that people is looking at O!

### AutoFill APIs

Didn't realise I needed it until it was pointed out it was missing. So many times do I give up logging into an app because I know if I go on the mobile website my login will be autofilled. No more.

Two points from the announcement:

> Users can select an autofill app, similar to the way they select a keyboard app. The autofill app stores and secures user data, such as addresses, user names, and even passwords. 

Interestingly, this pushes security concerns onto 3rd parties. I wonder who will come out on top. With Google having their own [Smart Lock](https://get.google.com/smartlock/) concept, I imagine Google may be releasing an autofill app alongside O. 

> For apps that want to handle autofill, we're adding new APIs to implement an Autofill service. 

Oh boy, I want to play with this. I've read about the security researchers who created [invisible input fields](https://github.com/anttiviljami/browser-autofill-phishing) on a webpage to contain *credit card* details, that would get autofilled while the user only saw the *name* field. Users were tricked into allowing autofill and, when they submitted the form, unintentionally disclosed their card details. Looking forward to seeing how Android tackles this and other security questions around Autofill.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
