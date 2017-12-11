> * 原文地址：[Introducing Turbo: 5x faster than Yarn & NPM, and runs natively in-browser 🔥](https://medium.com/@ericsimons/introducing-turbo-5x-faster-than-yarn-npm-and-runs-natively-in-browser-cc2c39715403)
> * 原文作者：[Eric Simons](https://medium.com/@ericsimons?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/introducing-turbo-5x-faster-than-yarn-npm-and-runs-natively-in-browser.md](https://github.com/xitu/gold-miner/blob/master/TODO/introducing-turbo-5x-faster-than-yarn-npm-and-runs-natively-in-browser.md)
> * 译者：
> * 校对者：

# Introducing Turbo: 5x faster than Yarn & NPM, and runs natively in-browser 🔥

![](https://cdn-images-1.medium.com/max/800/1*ZM5-cr-PRyZxEV7gegcU_g.png)

_Note: This is part of a talk I’m giving at Google’s Mountain View campus on Wednesday, December 6th — _[**_come join_**](https://www.meetup.com/modernweb/events/244544544/)_!_

After four months of hard work, I’m excited to finally announce **Turbo**! 🎉

Turbo is a blazing fast NPM client originally built for [StackBlitz](https://stackblitz.com) that:

* **Installs packages ≥5x faster than Yarn & NPM 🔥**
* **Reduces the size of** `**node_modules**` **up to two orders of magnitude 😮**
* **Has multiple layers of redundancy for production grade reliability** 💪
* **Works _entirely_ within your web browser, enabling lightning fast dev environments ⚡️**

![](https://cdn-images-1.medium.com/max/800/1*flSBzkA6MwhaGdXnHE9B1g.gif)

Actual installation speed of NPM packages using Turbo on [StackBlitz.com](https://stackblitz.com/)

### Why?

When we first [started working on StackBlitz](https://medium.com/@ericsimons/stackblitz-online-vs-code-ide-for-angular-react-7d09348497f4), our goal was to create an online IDE that gave you the same feeling as being behind the wheel of a supercar: that giggly delight of receiving instantaneous responses to your every command.

This contrasts with the experience NPM & Yarn can provide locally. Since they’re designed to handle massive dependencies backend codebases require for native binaries & other assets, their install process requires something more akin to a semi-truck than a supercar. But frontend code rarely relies on such massive dependencies, so what’s the problem? Well, those dependencies still slip into the install process as dev & sub-dependencies and are downloaded & extracted all the same, resulting in the infamous black hole known as `node_modules`:

![](https://cdn-images-1.medium.com/max/600/1*liNzl2MQKqg4tLMCF4jY5g.png)

Dank, relevant meme (pictured above)

This is the crux of what prevents NPM from working natively in-browser. Resolving, downloading, and extracting the hundreds of megabytes (or gigabytes) typical frontend projects contain in their `node_modules` folder is a challenge browsers just aren’t well suited for. Additionally, this is also why existing server side solutions to this problem have proven to be [slow, unreliable, and cost prohibitive to scale](https://github.com/unpkg/unpkg/issues/35#issuecomment-317128917).

> So, if NPM itself can’t work in the browser, what if we built a brand new NPM client from the ground up that could?

### The solution: A smarter, faster package manager built specifically for the web 📦

Turbo’s speed & efficiency is largely achieved by utilizing the same techniques modern frontend applications use for snappy performance—tree-shaking, lazy-loading, and plain ol’ XHR/fetch with gzip.

#### **_Retrieves only_ the files you need, on-demand** 🚀

Instead of downloading entire tarballs, Turbo is smart and only retrieves the files that are directly required from the main, typings and other relevant fields. This eliminates a surprising amount of dead weight in individual packages and even more so in larger projects:

![](https://cdn-images-1.medium.com/max/800/1*zl-KV3eL7lSnAI45Hb_Rcw.png)

Comparison of total compressed payload size for [RxJS](http://npmjs.com/package/rxjs) and [RealWorld Angular](https://github.com/gothinkster/angular-realworld-example-app)

So what happens if you import a file that’s not required by the main field, like [a Sass file](https://stackblitz.com/edit/angular-material?file=theme.scss) for example? No problem—Turbo simply lazy-loads it on-demand and persists it for future use, similar to how Microsoft’s new [GVFS Git protocol](https://blogs.msdn.microsoft.com/devops/2017/02/03/announcing-gvfs-git-virtual-file-system/) works.

#### Robust caching with multiple failover strategies 🏋️

We recently rolled out a Turbo-specific CDN that hydrates any NPM package in one gzipped JSON request, providing massive speed boosts to package installations. This concept is similar to NPM’s tarballs which concats all files in a package and gzips them, whereas Turbo’s cache intelligently concats only the files your application needs and gzips them.

Every Turbo client runs standalone in-browser and automatically downloads the appropriate files on-demand directly from [jsDelivr’s production grade CDN](https://www.jsdelivr.com/) if a package fails to be retrieved from our cache. But what if jsDelivr goes down too? No sweat—it then switches over to using [Unpkg’s CDN](https://unpkg.com) instead, giving you three separate layers of redundancy for ultra reliable package installations 👌

#### Lightning fast dependency resolution ⚡️

To ensure minimal payload sizes, Turbo uses a custom resolution algorithm to aggressively resolve common package versions whenever possible. It’s also insanely fast & redundant: the serverless version of the resolver has access to NPM’s entire dataset in-memory and **resolves any package.json in <85ms**. Should Turbo have any problems connecting to the serverless resolver, it gracefully fails over to running completely in-browser and retrieves all required metadata for resolution.

Doing dependency resolution on the client also opens up some new & exciting possibilities, like the ability to install missing peer dependencies in just one click 😮:

![](https://cdn-images-1.medium.com/max/800/1*BTe1Q-cZda_1dB3H0wROzQ.gif)

Because no one reads those warnings that npm pipes into the console 😜

#### Proven to work at scale 📈

Turbo is now reliably handling tens of millions of requests every month with negligible overhead cost, and we’re also excited to announce that Google’s Angular team recently chose StackBlitz to power all the live examples that millions of developers use in their docs!

### Now in technology preview 🙌

Turbo is live on [StackBlitz.com](https://stackblitz.com) and during the technology preview phase we’ll be running a ton of tests & releasing speed, efficiency, and reliability improvements, all of which your feedback is critical on — so please don’t hesitate to [file any issues](https://github.com/stackblitz/core/issues) you run into or to chat with us in [our Discord community](http://discord.gg/stackblitz)! 🍻

While Turbo was originally designed for production grade usage in [a real IDE](https://stackblitz.com), parts of it have already found their way into a handful of online playgrounds & folks in our community have even started prototyping a way to enable [script type=module](https://www.chromestatus.com/feature/5365692190687232) to work with Turbo (how cool is that??). We can’t wait to see all the other amazing stuff people come up with, so once our API churn smooths out we’ll be open sourcing all of it (and many other parts of StackBlitz) in our [**our Github repo**](https://github.com/stackblitz/core) for the world to use 🤘

Lastly, we want to give a huge thanks to Google’s Angular team for deciding to take a bet on our technology & to the Google Cloud team for their amazing service + sponsoring the servers that Turbo runs on! ❤️

#### As always, please feel free to tweet me [@ericsimons40](https://twitter.com/ericsimons40) or @[stackblitz](https://twitter.com/stackblitz) with any questions, feedback, ideas, etc :)

PS — If you’re interested in supporting our work, please consider grabbing a [Thinkster Pro](https://thinkster.io/pro) subscription! We’re creating a brand new series on how we built Turbo & StackBlitz, as well as revamping our entire content catalog :)

Rock on & I hope to see y‘all in [Mountain View on Wednesday, December 6th](https://www.meetup.com/modernweb/events/244544544/)!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
