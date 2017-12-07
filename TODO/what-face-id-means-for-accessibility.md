> * 原文地址：[What Face ID Means for Accessibility](https://www.stevensblog.co/blogs/what-face-id-means-for-accessibility?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[steven](https://www.stevensblog.co)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/what-face-id-means-for-accessibility.md](https://github.com/xitu/gold-miner/blob/master/TODO/what-face-id-means-for-accessibility.md)
> * 译者：
> * 校对者：

# [What Face ID Means for Accessibility]

When Apple introduced Touch ID with the iPhone 5s in 2013, I [wrote a piece](https://medium.com/@steven_aquino/on-touch-id-and-accessibility-eff1391cff91) in which I posited how the fingerprint reader would be beneficial in an accessibility context. I wrote, in part:

> What I see Touch ID doing is helping people with the aforementioned acuity/motor issues by allowing them to simply use their thumbprint (or other finger) to unlock their phone, password-free. More specifically, Touch ID would free users from the struggle of manually entering in their passcode.
> 
> My idea here is not so much of convenience (which is nice) but rather of usability. I know many folks with vision-and motor-related issues who bemoan iOS’s passcode prompt because not only does it take time, but also entering in said code isn’t necessarily an easy task. In fact, more than a few lament this so often that they forego a passcode altogether because it’s time-consuming and a pain (sometimes literally) to enter.

Four years later, the advent of Face ID in the iPhone X represents the next step in biometric security. But it’s something else too—for as great as Touch ID has been in terms of security, convenience, _and_ accessibility, Face ID is even better. [In my brief time with iPhone X so far](https://www.stevensblog.co/blogs/my-first-week-with-iphone-x), I have found Apple’s facial recognition technology to best Touch ID in virtually every meaningful way. Not to mention it’s pretty damn cool knowing I have the ability to unlock my phone and buy things _with my face_.

Living on the bleeding-edge is fun.

## Facing My Face ID Conundrum

In my first impressions story, I noted how Face ID on iPhone X has been “the most revelatory aspect” of the device thus far. What’s revelatory about it is how it taught me something about myself: namely, that I’m an edge case. For the first time using an Apple product, I have felt like I’ve been forced to adapt to the technology rather than have the tech adapt to me.

Here’s the thing. I have a condition called [strabismus](https://en.wikipedia.org/wiki/Strabismus), which means one or both of the eyes are not set straight. For me, mine is the left eye—ironically, my strong eye—and it seems to wreak havoc with the TrueDepth camera system. In my initial attempts to set up Face ID, I could not get Face ID to unlock my phone. The setup process went smoothly—Face ID successfully mapped my face, but again, it was unable to recognize me when unlocking the phone or logging into an app like 1Password. It was highly frustrating.

As Face ID is _the_ marquee feature of iPhone X, this was bad.

After some troubleshooting, however, there was a solution. Following some tests, I determined I’m one of those users for which requiring “eye contact” with iPhone X just will not work. Hence, the solution was to go into Face ID’s settings and turn off the Require Attention feature (Settings > Face ID & Passcode > Require Attention for Face ID). With Require Attention disabled, Face ID works like a charm. Doing things such as unlocking my phone, logging into 1Password, and paying with Apple Pay all are effortless.

The only caveat to this is I’m still not used to holding my phone far enough away such that Face ID can read my face. Because of my low vision, I instinctively hold my phone close to my face because I need it close to see. Face ID obviously can’t see me at this angle, so I tend to get the haptic, can’t-log-you-in “head shake” a lot. I’ve only had the iPhone X for almost two weeks now, so it’ll take me a bit more time to develop a new muscle memory. I can deal with this, though, because I know the technology isn’t faulty nor did Apple give me a lemon of a review unit, as I initially feared. Everything works as intended, as designed—I just need to learn new habits.

Especially with iPhone X, there’s ten years of iPhone convention to unlearn.

## Why Face ID Beats Touch ID

So what makes Face ID even more accessible than Touch ID?

For one thing, setup is far faster and less taxing. Enrolling in Touch ID is by no means difficult, but it is relatively slow and “precise.” iOS prompts you to move your finger this way and that way, and will bug you when you don’t follow directions. If you’re someone with limited fine-motor skills, getting Touch ID set up can be a literal pain along with being a figurative one.

By contrast, setting up Face ID at least _feels_ more streamlined and less tedious. While moving your head around “like you’re drawing a circle with your face,” as Apple described it to me, can be difficult for individuals with certain gross motor limitations, there is an accessibility option to eliminate that step. (Instead of moving your head around to get the depth map, the system will take a single shot at a fixed angle.) If rolling your head around is impossible or bothersome, Apple has you covered right from within the setup UI. Again, Touch ID is no slouch, but I have found, anecdotally, that setting up Face ID is much simpler and quicker than ever. Surely this is due to Apple having years to study user data and fine-tune BiometricKit.

Beyond setup, another area where Face ID excels is its presence removes a point of friction (the Touch ID sensor) for many disabled users. However accessible Touch ID may be, the fact remains reaching and/or pushing that button is problematic for many. Instead of tactilely authenticating for everything, now all someone has to do is literally _look_ at their phone. It’s no doubt convenient as well, but importantly for accessibility, Face ID is freedom. It’s freedom knowing there’s a better way forward technologically, and freedom knowing there’s less one less possible barrier.

The way Apple has built Face ID, hardware- and software-wise, into iOS quite literally makes using iPhone a “hands-free” experience in many regards. And that’s _without_ discrete accessibility features like Switch Control or AssistiveTouch. That makes a significant difference to users, myself included, whose physical limitations make even the most mundane tasks (e.g., unlocking one’s device) tricky. As with so many accessibility-related topics, the little things that are taken for granted are always the things that make the biggest difference in shaping a positive experience.

## On Face ID and Apple Pay

I’ve gone on the record ([here](http://m.imore.com/apple-pay-and-empowering-nature-inclusive-design) and [here](http://www.imore.com/apple-watch-makes-apple-pay-even-better-accessibility)) to laud Apple Pay as an accessible way to pay for stuff. I’ve used it every chance I get since its debut in 2014, and still can’t get over how well done it is. It’s a truly magical service.

Face ID on iPhone X takes Apple Pay to the next level. In the handful of times I’ve used Apple Pay on iPhone X (to pay for Lyft rides), Face ID has provided an even more seamless experience. Like with unlocking, the advantage of Apple Pay being tied to Face ID is you confirm the purchase with your face. (You double-press the side button to initiate, but that’s it.) The hands-free nature of it means I needn’t worry about getting my thumb in the right position or spend time waiting for authorization.

Despite how good it is, the thing about Apple Pay on the phone is, since I’m an Apple Watch wearer, I don’t use the service often on my iPhone. It’s even better from my wrist, but I’m glad Apple made the gestures more consistent across devices. Nonetheless, for the times when I _do_ use Apple Pay on my iPhone, Face ID makes it quicker, easier, and more accessible.

## A Brief Note on the Touch ID API

It’s worth mentioning how much of an impact I believe the public Touch ID/Face ID API has had on accessibility. To me, it’s a sleeper hit.

The reason for this is because, by giving developers the power to integrate biometrics into their apps, Apple is effectively ensuring third-party apps be more accessible. I continue to agree with Marco Arment that the company [should make accessibility a tentpole of the app-vetting process](https://marco.org/2014/07/10/app-review-should-test-accessibility), but as it stands currently, just the fact alone that App Store apps have access to these biometric features puts them on solid ground, accessibility-wise. That I have been able to use my thumb (and now my face) to get into my 1Password means that app already is pretty accessible, even without critiquing any design details. It sure beats typing a passcode every time.

Of course there’s [more developers need to do](http://techcrunch.com/2014/08/02/reuters-rebuttal/) to ensure their app(s) are accessible by all, but the API sure puts them and users ahead. It’s not trivial, and Apple is to be commended for perhaps having the foresight to realize the benefits here. It was a huge addition to the toolkit.

## The Future of the (Accessible) Smartphone

Everyone who has an iPhone X right now is still in the honeymoon phase, so time will tell how feelings about the evolve as the device ages. In my usage so far, it’s clear to me Apple built iPhone X in such a way that the so-called “future” of the smartphone is an accessible one.

iPhone X takes many leaps forward, but Face ID is the biggest. It’s markedly better than its predecessor, which is high praise for a feature as beloved as Touch ID. There was some adjustment necessary on my part, but I can’t speak effusively enough about Face ID. It’s delightful, reliable, and accessible.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
