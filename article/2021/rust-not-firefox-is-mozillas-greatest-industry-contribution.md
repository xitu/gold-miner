> * 原文地址：[Rust, not Firefox, is Mozilla's greatest industry contribution](https://www.techrepublic.com/article/rust-not-firefox-is-mozillas-greatest-industry-contribution/)
> * 原文作者：Matt Asay
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/rust-not-firefox-is-mozillas-greatest-industry-contribution.md](https://github.com/xitu/gold-miner/blob/master/article/2021/rust-not-firefox-is-mozillas-greatest-industry-contribution.md)
> * 译者：
> * 校对者：

# Rust, not Firefox, is Mozilla's greatest industry contribution

Linus Torvalds is perhaps best known as the creator of Linux, but he has arguably had a bigger impact as the inventor of Git. In like manner, though we remember Mozilla as the organization behind the Firefox web browser, it will have a much more profound impact on computing for its development of the Rust programming language.

## Mozilla: seeking a new purpose

Mozilla has seen better days. There was a time when it was indispensable to web freedom. That time was when Microsoft's Internet Explorer was the dominant web browser, and there was real concern about the web's future with its primary gateway owned by one big, proprietary company.

Over the course of many years, Mozilla largely succeeded in its mission of creating a more open, free web. Unfortunately, the space it created for competition was largely filled by Google's Chrome browser. Years later, we've traded one hegemon for another, and [Firefox is no longer very relevant to the conversation](https://twitter.com/mjasay/status/902652369607036928?lang=en).

This is so despite Mozilla struggling for well over a decade to find a new purpose. Maybe [Mozilla could build the next great platform](https://www.cnet.com/news/forget-facebook-the-webs-platform-is-firefox/). (Nope.) Or a [great mobile OS](https://www.cnet.com/news/why-the-death-of-the-firefox-phone-matters/)? (Also nope.) [Sync](https://twitter.com/mjasay/status/239069091573420032)? (Again, nope.) Lots and lots of hope and false starts, leading to the inevitable "nope." In 2017 [CNET interviewed Mozilla's then CEO Chris Beard](https://www.cnet.com/news/mozilla-three-years-later-is-firefox-in-a-better-place/) to get a read on its prospects--they still don't look particularly bright.

And yet in the midst of all this struggle, Mozilla created something truly great: Rust.

## Rust in peace

In some ways, it's bizarre that a systems programming language emerged 10 years ago from the bowels of Mozilla Research. Bizarre because, well, what's a mobile browser/email client/mobile OS/etc. etc. company doing creating a programming language that might be useful for creating secure browser components but doesn't necessarily give Mozilla a future?

Rust started as Mozilla engineer Graydon Hoare's personal project in 2006. [Hoare explained](https://www.infoq.com/news/2012/08/Interview-Rust/) the reasons behind his work in 2012:

> A lot of obvious good ideas, known and loved in other languages, haven't made it into widely-used systems languages, or are deployed in languages that have very poor (unsafe, concurrency-hostile) memory models. There were a lot of good competitors in the late 70s and early 80s in that space, and I wanted to revive some of their ideas and give them another go, on the theory that circumstances have changed: the internet is highly concurrent and highly security-conscious, so the design-tradeoffs that always favor C and C++ (for example) have been shifting.

By 2009 Mozilla had embraced Hoare's work, and in 2010 the company formally announced it in 2010. Over the past decade, Rust has blossomed, gaining in popularity and finding its way into the infrastructure that powers companies like AWS, Microsoft and Google. What it hasn't done, however, is to offer Mozilla a future. In fact, [in 2020 Mozilla laid off a big chunk of its employees](https://www.zdnet.com/article/programming-language-rust-mozilla-job-cuts-have-hit-us-badly-but-heres-how-well-survive/), including key Rust contributors. Those Rust contributors readily found work elsewhere, given the importance of Rust to pretty much any company that depends on systems engineering work.

This brings us back to Mozilla's legacy. It's hard to guess what will happen to Mozilla, despite the incredible good it has done for tech over the years. The impact of Mozilla's most impressive work will likely not be fully realized for many years. A huge swath of the cloud services we directly or indirectly depend on each day are increasingly built with Rust.

Speaking about the [rising popularity of Rust](https://redmonk.com/sogrady/2021/03/01/language-rankings-1-21/), RedMonk analyst James Governor highlighted [Rust's ability to fill a variety of niches as key to its success](https://redmonk.com/rstephens/2021/03/10/language-slackchat-jan2021/): "I first encountered it in terms of IoT--that is Rust for device programming. But clearly it's growing as a systems programming language, and the ecosystem around Rust and WASM/WASI with serverless compute from Fastly looks very interesting."

This ability to enable [developers](https://www.techrepublic.com/article/how-to-become-a-developer-a-cheat-sheet/) to build "ambitious, fast, and correct" code, as [Mozilla has suggested](https://research.mozilla.org/rust/), makes it almost certain to become ever more pervasive in systems development. Mozilla may not directly benefit from this innovation, but through its development and contribution of Rust to the world, Mozilla has given us something even bigger and more strategically important than Firefox.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

