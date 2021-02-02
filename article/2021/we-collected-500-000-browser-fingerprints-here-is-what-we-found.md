> * 原文地址：[We collected 500,000 browser fingerprints. Here is what we found.](https://medium.com/slido-dev-blog/we-collected-500-000-browser-fingerprints-here-is-what-we-found-82c319464dc9)
> * 原文作者：[Peter Hraška](https://medium.com/@peterhraka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/we-collected-500-000-browser-fingerprints-here-is-what-we-found.md](https://github.com/xitu/gold-miner/blob/master/article/2021/we-collected-500-000-browser-fingerprints-here-is-what-we-found.md)
> * 译者：
> * 校对者：

# We collected 500,000 browser fingerprints. Here is what we found.

![](https://cdn-images-1.medium.com/max/2560/1*pG2Zzgc5OZr5frYc2ovhkg.png)

## We’ve analysed 500,000 browser fingerprints. Here is what we found.

#### From basics all the way to the geeky stuff.

Remember the last time you looked for an item online and then you were haunted by related ads everywhere? The chances are that you are being tracked because information like your screen resolution, timezone and emoji sets are exposed to the internet.

And yes, this method can track you even while you are using private browsing (a.k.a. the incognito mode).

![Example features and values of a browser fingerprint — check yours at [http://fp.virpo.sk](http://fp.virpo.sk)](https://cdn-images-1.medium.com/max/2000/1*PxgUnoZ92Gg75mpgczP2xQ.png)

At [Slido](https://slido.com), we conducted one of the largest public investigations into browser fingerprinting accuracy and the world’s first thorough review of this technique’s performance on smartphones.

So let’s look at what browser fingerprints are, how they can be used to track you, and how good they are at doing it.

## What is browser fingerprinting?

I’ll explain this using a simple ‘cameras and typewriters’ analogy.

Both cameras and typewriters can be identified and distinguished from each other easily by looking at their outputs.

![](https://cdn-images-1.medium.com/max/10000/1*UwuI5f-7llEnwGoF_ul4hg.jpeg)

Each camera leaves a unique noise pattern on its pictures and each typewriter leaks ink around its letters in a specific way.

By looking at two photographs and comparing their noise patterns, we can determine whether it was taken by the same camera pretty accurately.

The same principle applies to browsers. JavaScript, which is enabled on most browsers, exposes a lot of information about you to the world.

Be it your screen size, emojis, installed fonts, languages, time zones, or graphics card model. All of these can be obtained from your browser without you ever noticing.

On its own, all this information is insignificant. But by combining it, anyone can use it to identify a specific browser pretty accurately.

![Even the appearance of emojis on your device can be used to identify you. Emojis can be extracted as a bitmap using HTML5 canvas.](https://cdn-images-1.medium.com/max/2264/1*EWjMItxMhNQCgseB4serOg.jpeg)

If you are interested, you can check what your browser fingerprint looks like [on my website](http://fp.virpo.sk).

## How are browser fingerprints being used?

One might think that the fingerprints are inherently used in a negative way, but that is far from the truth.

Take fraud prevention as an example. If you have any kind of online account such as a bank account or even a social network account, you usually log in just by using your email address and a password.

In case your credentials get stolen one day and the thief tries to log in from his or her device, the bank or social network will be able to detect this suspicious behavior thanks to the change in browser fingerprint. To prevent this kind of fraud, they might require further authorization, e.g. via SMS.

However, the most widespread use of browser fingerprints is an ad personalization by far. The social ‘like’ and ‘share’ buttons which are present on almost every website often contain a script that collects your browser fingerprint and therefore knows your browsing history.

![Social share buttons are commonly used to collect your browser fingerprint](https://cdn-images-1.medium.com/max/2164/1*5Ux2MPqwS-XmNJrmSFw3uw.png)

Collecting a single fingerprint from a single device is not too valuable. Nor is there much use from collecting many fingerprints on a single website.

But since the social buttons — and therefore browser fingerprinting scripts — are present almost everywhere, social networks pretty much know how you browse the web.

This way tech giants can serve you ads related to what you searched for half an hour ago.

## So can I be identified everywhere, all the time?

Well, no.

There are several sites such as [AmIUnique](https://amiunique.org/) and [Panopticlick](https://panopticlick.eff.org/), that can tell you whether your browser fingerprint is unique from roughly a million fingerprints collected in their database.

Your fingerprint most likely going to be marked as unique. This sounds scary, but bear with me, it may be a bit less scary once we see the full picture.

These sites compare your fingerprint with their whole database which contains data collected over 2–3 years (or 45 days in case of Panopticlick).

However, both 45 days and 2 years is enough time for your browser fingerprint to change without you doing anything. For instance, my browser fingerprint changed 6 times over a period of 60 days.

The change can be caused by automatic browser updates, window resizing, installing a new font or even daylight saving time adjustment. All this can make your browser much harder to uniquely identify over longer periods of time.

## The data we analysed

Both [Panopticlick](https://panopticlick.eff.org/static/browser-uniqueness.pdf) and [AmIUnique](https://hal.inria.fr/hal-01285470/file/beauty-sp16.pdf) published excellent scientific papers where they analysed several hundreds of thousands browser fingerprints.

Our data is different in several key aspects. We believe that this helped us reveal more information about browser fingerprints.

* we analysed 566,704 browser fingerprints, which is roughly twice the amount of fingerprints analysed in the largest previous research
* 65% of devices in our dataset were smartphones
* the data consisted of 31 distinct browser fingerprint features from each device using state-of-the-art browser fingerprinting script

We value online privacy greatly and therefore all the data was analysed anonymously. We went to great lengths to ensure the data is useless in any other way than for purposes of this research.

![Distribution of device types within our dataset](https://cdn-images-1.medium.com/max/3842/1*6TGFW_Ta6xBGPtG3renu_g.png)

## The results

Probably the most intuitive graph drawn from our data is the one showing sizes of anonymity sets.

Anonymity set basically describes how many distinct devices shared the exact same browser fingerprint.

For example, anonymity set of size 1 means that the browser fingerprint was unique. Anonymity set of size 5 means that 5 distinct devices had the exact same fingerprint and therefore, you are not able to differentiate one from another just based on its fingerprint.

The results of anonymity set sizes for most occupied device types in our dataset are as follows:

![Anonymity set sizes for the most occupied device types within our dataset. For example, only 33% of iPhones could be uniquely identified within our dataset.](https://cdn-images-1.medium.com/max/3652/1*aRYY86WUgiB9OuSMrHil_w.png)

Looking at the graph, there are a couple of things that stand out:

* 74% of desktop devices can be uniquely identified, while the same can only be said about 45% of mobile users.
* Only 33% of browser fingerprints collected on iPhones were unique.
* The other 33% of iPhones can hardly be tracked at all, because 20 or more iPhones expose the exact same browser fingerprint.

#### The rate of change

We observed another interesting phenomenon when looking at how often browser fingerprints of a single device change.

The following graphs show the number of days between the device’s first visit and the first change of its browser fingerprint:

![Rate of change of browser fingerprints.](https://cdn-images-1.medium.com/max/3842/1*girS-UYQ-GwEactOp8bgfg.png)

We can observe that within 24 hours, nearly 10% of the devices we observed multiple times managed to change their fingerprint.

Let’s see how this plays out for each device type separately:

![Rate of fingerprint change across different device types.](https://cdn-images-1.medium.com/max/4192/1*-kGLm0LGKQxjbtckW2gyZg.png)

This graph shows that while 19% of iPhones changed their fingerprint within a week, only around 3% of Android phones did. Our data therefore suggests that iPhones are much harder to track for longer periods of time than Androids.

#### Minimal fingerprint

Finally, we explored how many features would someone actually need to collect from a browser to reliably identify it.

To do this, we measured how powerful a fingerprint was using [Shannon’s information entropy](https://en.wikipedia.org/wiki/Entropy_(information_theory)). The higher the entropy, the more accurate the identification process.

**For example, entropy of 14.2 means that 1 in every ~19,000 browser fingerprints has exactly the same fingerprint as me. Increasing the entropy to 16.5 means, that one in every ~92,500 devices shares the same fingerprint as me.**

In our experiment, we looked for the strongest subsets of browser fingerprint features given by the size of a subset.

The entropy of our whole dataset was 16.55, so we decided to start with just 3 features and increase the subset size until the subset reaches entropy of at least 16.5 and these are the results:

![By collecting 9 instead of 33 browser features, the entropy only drops by 0.035](https://cdn-images-1.medium.com/max/3444/1*gMIh_szBYVW1STWYMoEqBA.png)

This experiment revealed that by extracting 3 elementary browser features, namely date format, user-agent string and available size (screen size minus size of the docks, window bars, etc.), we can achieve entropy of 14.2, which is already enough to identify browsers (and therefore users) in some cases.

If we extend the subset with features that are more difficult to obtain, such as canvas fingerprint, list of installed fonts and several others, we are able to reach our entropy goal of 16.5.

This means that websites and companies do not really need to put much effort into identifying you.

## Conclusions

So what to take out of this?

* tech giants can track your online movement, but not quite precisely (yet).
* smartphones (and especially iPhones) are harder to track than PCs
* browser fingerprint of a device changes quite frequently
* browser fingerprints are easy to obtain

However, if you are worried about your data privacy, I have some good news as well. Firstly, [Apple announced a war against browser fingerprinting](https://www.howtogeek.com/fyi/safari-battles-browser-fingerprinting-and-tracking-on-macos-mojave/) with it’s latest Mac OS Mojave. Secondly, GDPR considers browser fingerprints to be personal data and they have to be treated accordingly. And lastly there are [many plugins and browser extension](https://amiunique.org/tools) that can confuse browser fingerprinting scripts.

So, our future is not as dim as it seems. Yes, sometimes you can be identified uniquely, but quite often there are other devices with the exact same browser fingerprint as yours, which makes you harder to track.

#### Motivation behind this research

At [Slido](https://slido.com) we try to make user experience of our web application as simple as possible. When you join our app, you usually aren’t required to sign in and we want to keep it that way.

Our motivation behind this research was to investigate whether authentication using browser fingerprints can actually be used to defend our users from malicious scripts without harming the user experience.

Note that it was also important to know whether the same method would work on smartphones, since our app’s traffic consists mostly of smartphone devices.

And the answer to our question is “no”.

Browser fingerprints alone aren’t accurate enough to be used as authentication for our users. They are, however, accurate enough to place you in a group of people with similar interests (in cats or cars for example).

---

That pretty much means that browser fingerprints are ideal for use cases such as ad personalization, where accuracy isn’t the key or bank fraud prevention, where paranoia is a good thing.

If you want to know more about browser fingerprinting, I wrote a [60+ pages long thesis](http://virpo.sk/browser-fingerprinting-hraska-diploma-thesis.pdf) on the research we conducted which you can read.

You will learn more about how extraction of each browser feature works, how it is possible to avoid being tracked by browser fingerprints, with graphs and results explained in greater detail, and much more.

---

Huge thanks goes to my supervisor, RNDr. Michal Forišek, PhD., who helped me greatly during this research.

Related links:

* [My 60+ pages long thesis on browser fingerprints](http://virpo.sk/browser-fingerprinting-hraska-diploma-thesis.pdf)
* [http://fp.virpo.sk](http://fp.virpo.sk) — see what your fingerprint looks like
* [https://panopticlick.eff.org](https://panopticlick.eff.org/static/browser-uniqueness.pdf)— Panopticlick
* [https://amiunique.org](https://amiunique.org/)— AmIUnique
* [https://audiofingerprint.openwpm.com](https://audiofingerprint.openwpm.com/) — audio used to fingerprint browsers
* [https://www.nothingprivate.ml/](https://www.nothingprivate.ml/) — Incognito browsing is not as incognito

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
