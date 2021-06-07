> * 原文地址：[Rust, not Firefox, is Mozilla's greatest industry contribution](https://www.techrepublic.com/article/rust-not-firefox-is-mozillas-greatest-industry-contribution/)
> * 原文作者：[Matt Asay](https://www.techrepublic.com/meet-the-team/us/matt-asay/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/rust-not-firefox-is-mozillas-greatest-industry-contribution.md](https://github.com/xitu/gold-miner/blob/master/article/2021/rust-not-firefox-is-mozillas-greatest-industry-contribution.md)
> * 译者：[灰灰 greycodee](https://github.com/greycodee)
> * 校对者：[PingHGao](https://github.com/PingHGao)、[Chorer](https://github.com/Chorer)、[PassionPenguin](https://github.com/PassionPenguin)

# Mozilla 对行业最大的贡献是 Rust，而不是火狐浏览器

Linus Torvalds 也许是作为 Linux 创造者而举世闻名，但也有人认为他创造的 Git 对世界的影响更加重大。同样，尽管 Mozilla 作为创造火狐浏览器的组织为被我们铭记，但它创造的 Rust 编程语言对计算领域的影响却更加深远。

## Mozilla：寻求新目标

Mozilla 曾辉煌一时。曾几何时，它对于网络自由是不可或缺的。那时微软的 Internet Explorer 是主要的 Web 浏览器，这不由得令人担忧 Web 的未来，因为其主要入口被一家大型私有公司所掌控。经过多年的努力，Mozilla 在创造一个更加开放和自由的网络环境上大获成功。不幸的是，成功的果实却被谷歌的 Chrome 浏览器窃取。多年后，掌控大权的浏览器发生更替，而[火狐浏览器却被排挤在外了](https://twitter.com/mjasay/status/902652369607036928?lang=en)。

尽管 Mozilla 奋斗了十年来寻找新的目标，情况还是比较糟糕。或许 [Mozilla 可以创建下一个伟大的平台](https://www.cnet.com/news/forget-facebook-the-webs-platform-is-firefox/)（并没有）。或是一个[伟大的手机操作系统](https://www.cnet.com/news/why-the-death-of-the-firefox-phone-matters/)（也不太可能）? [同步](https://twitter.com/mjasay/status/239069091573420032)（再次说不）？很多希望和错误的开始，导致不可避免的『不』。在 2017 年 [CNET 采访了 Mozilla 当时的首席执行官 Chris Beard](https://www.cnet.com/news/mozilla-three-years-later-is-firefox-in-a-better-place/)，从他们的前景来看，并不是很乐观。

然而，在所有这些努力中，Mozilla 创造了一个真正伟大的东西：Rust。

## 平静的 Rust

从某种意义上说，十年前从 Mozilla 的研究领域中出现了一种系统编程语言是很奇怪的。之所以奇怪，是因为像什么手机浏览器、邮件客户端、手机系统等等，都是比较好的东西，而公司却去创建一个编程语言，虽然可能对创造安全的浏览器组件有点用处，但是却不一定能给 Mozilla 带来光明的未来。 

Rust 起始于 2006 年 Mozilla 员工 Graydon Hoare 的一个个人项目。[Hoare 解释](https://www.infoq.com/news/2012/08/Interview-Rust/)了他 2012 年做这项工作背后的原因：

> 许多显而易见的好想法，在其他语言中被广泛接受和喜爱，却没有加入到被广泛使用的系统语言中，或者只在内存模型非常差（不安全，对并发性敌对）的系统语言中加入。在70年代末和80年代初，在这个领域有很多优秀的竞争对手，我想根据环境已经改变的理论，复兴他们的一些想法，再给他们一个机会：Internet 是高度并发且有高度的安全意识，因此，用 C 和 C ++ 的设计的方案正在发生变化。

在 2009 年 Mozilla 接受了 Hoare 的工作，并且在 2010 年正式宣布公司成立。在过去的十年中，Rust 蓬勃发展，广受欢迎，并逐渐渗透到为 AWS，Microsoft 和 Google 等公司提供支持的基础架构中。但是它还没有为 Mozilla 带来光明的未来。实际上，[Mozilla 在 2020 年解雇了很大一部分员工](https://www.zdnet.com/article/programming-language-rust-mozilla-job-cuts-have-hit-us-badly-but-heres-how-well-survive/)，其中就包括了不少 Rust 的主要贡献者。这些 Rust 贡献者很容易在其他地方找到工作，因为 Rust 对于几乎所有依赖系统工程工作的公司都非常重要。

这又让我们把目光重新聚焦到了 Mozilla 的问题。尽管多年来 Mozilla 在技术领域做出了让人难以置信的贡献，但它的未来仍然扑朔迷离。对于 Mozilla 最令人印象深刻的贡献所带来的影响，人们可能在接下来的很多年都无法完全意识到。我们每天或直接或间接依赖的大量云服务越来越多地使用 Rust 构建。

在谈到 [Rust 的日益普及](https://redmonk.com/sogrady/2021/03/01/language-rankings-1-21/)时，RedMonk 分析师 James Governor 强调了 Rust 填补各种市场的能力是其成功的关键：『我首先在物联网领域遇到了它­­ —— 即用于设备编程的 Rust。显然，它作为一种系统编程语言正在成长，Rust 和 WASM/WASI 周围的生态系统以及来自 Fastly 的无服务器计算看起来非常有趣。』

正如 Mozilla 所[表明](https://research.mozilla.org/rust/)的那样，这种使[开发人员](https://www.techrepublic.com/article/how-to-become-a-developer-a-cheat-sheet/)能够构建“健壮、快速且正确的”代码的能力，将让 Rust 在系统开发中变得越来越普遍。Mozilla 可能不会直接从这项创新中受益，但是通过 Rust 的发展和贡献，Mozilla 为我们提供了比 Firefox 更大甚至更具战略意义的东西。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
