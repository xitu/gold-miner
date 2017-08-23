
> * 原文地址：[Reflections on ESLint's success](https://www.nczonline.net/blog/2016/02/reflections-on-eslints-success/)
> * 原文作者：[Nicholas C. Zakas](http://www.twitter.com/slicknet/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/reflections-on-eslints-success.md](https://github.com/xitu/gold-miner/blob/master/TODO/reflections-on-eslints-success.md)
> * 译者：[薛定谔的猫](https://github.com/Aladdin-ADD)
> * 校对者：[H2O-2](https://github.com/H2O-2) [warcryDoggie](https://github.com/warcryDoggie)

# 回顾 ESLint 的成功

难以置信，我在 2013 年 6 月构思开发了 ESLint，7 月第一次对外发布。熟悉的读者可能还记得，ESLint 最初主要设计目标是运行时加载的检查工具（linter）。在工作中我看到我们的 JavaScript 代码中的一些问题，希望能有一些自动化的手段避免这些问题再次出现。

在 ESLint 发布后的 2 年半里，它的受欢迎程度大大增加。上个月的 30 天在 npm 上就有超过 1 500 000 次下载，这是当初平均月下载量只有 600 时我不曾想象的。

所有这一切发生了，然而过去 2 年我患上了很严重的莱姆病，几乎无法离开我的房子。这意味着我不能够外出参加会议和聚会来宣传 ESLint（前 2 年我可是会议常客）。但不知为何，ESLint 获得了广泛关注，并且继续收到欢迎。我觉得是时候回顾其中缘由了。

## JavaScript 使用量增加

过去三年，我们看到浏览器上 JavaScript 的使用量持续增加。根据 HTTP Archive[3]，现在网页的 JavaScript 比 2013 年增加了 100 KB。

![Chart - Increasing JavaScript Usage in Browsers 2013-2016](https://www.nczonline.net/images/posts/blog-js-chart-2016.png)

另一个因素是 Node.js 的爆炸性流行。以前 JavaScript 仅限于客户端使用，而 Node.js 使另外一些开发者也能够使用 JavaScript。随着运行环境拓展到了浏览器和服务器端，JavaScript 工具需求自然增加了。由于 ESLint 可以用于浏览器和 Node.js 上的 JavaScript，迎合了这一需求。

## 检查工具更加流行

由于 JavaScript 工具的需求增加，对 JavaScript 代码检查的需求也随之增加。这很容易理解 -- 你编写的 JavaScript 代码越多，就越需要更多保障，避免一些常见错误。自 2013 年中以来 npm 上 JSHint、JSCS、ESLint 的下载量显示了这一趋势。

![Chart - Increasing downloads for all JavaScript linters](https://www.nczonline.net/images/posts/blog-eslint-chart.png)

JSCS 和 ESLint 几乎是同时创建的，将它们各自的增加轨迹与更早一些的 JSHint 进行对比可以看到一些很有趣的地方。到 2016 年初，JSHint 在 JavaScript 代码检查领域有着优势地位，JSCS 和 ESLint 也在增长。最有趣的是这三个工具的下载量都在增长，说明每月下载检查工具的人多于更换的人数。

所以 ESLint 确实迎合了开发者对 JavaScript 代码检查需求增加的大趋势。

## ES6/Babel

在过去的四年里，ECMAScript 6 的人气一直在稳定增长，这也使 Babel 获得了极大成功。开发者不用等浏览器和 Node.js 的正式支持就可以使用 ECMAScript 6 语法，这也需要 JavaScript 工具的新特性支持。在这一点上，JSHint 对 ECMAScript 6 特性支持不足，显得有些落后了。

另一方面，ESLint 有一个巨大的优势：你可以用其它的 parser 来代替默认的 parser -- 只要它的输出与 Esprima（或 Espree）兼容。这意味着你可以直接使用 Facebook 的 Esprima 支持 ES6 的 fork （现在已不再维护）来检查你的 ES6 代码。Espree 现在也已经支持 ES6 了（主要来自 Facebook 的 fork）。这使得开发者可以很方便的使用 ES6。

当然，Babel 并没有止步于支持 ES6 -- 它同样也支持实验特性。这就需要不但支持 ES 标准特性，还有其它开发中的特性（stage0 ~ stage4）。因此 ESLint 的 parser 可配置性就很重要了，因为 Babel 成员创建的 babel-eslint[4] 在其基础上进行封装，以便 ESLint 能够使用。

不久以后，ESLint 就成为了使用 ES6 或者 Babel 的人推荐的检查工具，这得益于允许兼容 parser 替换默认 parser 的设计决策。

现在，ESLint 安装时大约有 41% 使用了 babel-eslint（基于 npm 下载量统计）。

## React

讨论 ESLint 的流行离不开 React。React 的一个核心特性就是支持在 JavaScript 中嵌入 JSX，而其它检查工具起初都不支持这一特性。ESLint 不但在其默认 parser 支持 JSX，用户也可以通过配置使用 babel-eslint 或者 Facebook 的 Esprima fork 来支持 JSX。React 用户也因此开始使用 ESLint。

我们收到很多在 ESLint 本身加入一些 React 特有规则的请求，但是原则上我不希望有库专有的规则 -- 因为这会带来巨大的维护成本。2014 年 12 月，eslint-plugin-react[5] 引入了许多 React 专有规则，很快得到了 Recat 开发者的欢迎。

后来在 2015 年 2 月，Dan Abramov 写了一篇文章《Lint like it's 2015》[6]。这这篇文章中，他介绍了 ESLint 在 React 中的应用，并给出了高度评价：

> 如果你从未听说过 ESLint -- 它就是我一直想要 JSHint 成为的那样。

Dan 也介绍了如何配置使用 babel-eslint，提供了极有价值的文档。明显可以看到这是 ESLint 的一个大的转折点：月下载量从 2015 年 2 月的 89,000 到 2015 年 3 月的 161,000 -- 增长了近一倍。从这之后到现在，ESLint 经历了一个快速增长的阶段。

现在，eslint-plugin-react 在 ESLint 安装中使用率有 45%+（基于 npm 下载量统计）。

## 可扩展性是关键

从一开始，我的想法就是 ESLint 本身是小核心工具，作为大生态的中心。我的目标是通过允许足够的扩展使 ESLint 永不过时：即便无法提供的新特性，ESLint 仍然可以通过扩展获得新功能。虽然现在 ESLint 还没有完全满足我的设想，但已经非常灵活：

- 你可以在运行时增加新规则，这使得任何人都可以编写自己的规则。为了避免每天花费大量时间处理用户想要各种预料外的规则，我将其视为关键所在。现在，没有什么阻止用户编写自己的规则。
- parser 的可配置性使 ESLint 可以处理任何和 Espree 兼容的格式。正如上文所述，这也是 ESLint 流行的一个重大原因。
- 配置可分享，所有人都可以发布和分享配置，非常便于不同的项目共用相同配置（ESLint 安装中 eslint-config-airbnb 的使用率有 15%）。
- 插件系统 人们可以很方便的通过 package 分享规则，文本处理器，环境和配置。
- 良好的 Node.js API 可以很方便的用于构建工具插件（Grunt，Gulp等），也可用于创建零配置的检查工具（Standard，XO等）。

我希望 ESLint 未来可以提供更多的可扩展性。

## 听取社区反馈

我非常努力做到的事情之一就是：听取 ESLint 社区的反馈。虽然开始有些固执于对于 ESLint 最初的设想，后来我意识到了众人的智慧。听到同样的建议次数越多，就越有可能是需要考虑的痛点。在这一点上我现在好多了，社区的很多好的想法也促成了 ESLint 的成功：
1. **parser 可配置** - 直接来自 Facebook的建议，他们希望将 Esprima fork 用于 ESLint。
2. **JSX 支持** - 起初我非常反对默认支持 JSX。但有持续不断的建议，我最终同意了。如上文提到的，这一点也成为了 ESLint 成功的关键。
3. **可分享配置** - 来自 Standard 和其它基于 ESLint 的封装，它们的目标是使用特定的配置来运行 ESLint。看起来社区确实需要一种简便的方式来分享配置，因此这个特性诞生了。
4. **插件** - 起初加载自定义规则的唯一方式是，从文件系统使用命令行选项 `--rulesdir` 加载。很快人们开始在 npm 发布自己的规则。这样使用起来很痛苦，并且很难同时使用多个 package，因此我们增加了插件以便能够方便的分享。

很明显，ESLint 社区关于这个项目的成长有许多极好的想法。毫无疑问，ESLint 的成功直接受益于它们。

## 群众基础

ESLint 发布以来，我写了两篇相关文章。第一篇发表在我的个人博客，第二篇在去年 9 月发表于 Smashing 杂志。除此之外，对 ESLint 的推广仅限于 Twitter 和 管理 ESLint Twitter 账户。如果我愿意花心思去做些演讲的话，我肯定会在推广 ESLint 上做的更好。但是因为我没有，我决定放弃尝试去推广它了。

然而我很欣喜的发现人们开始讨论 ESLint，写关于它的文章。起初是一些我不认识也没听说过的人。不断有人写文章（比如说 Dan），人们也在各种会议和聚会上讨论 ESlint。网上的内容越来越多，ESLint 很自然的也更加流行了。

一个有趣的对比是 JSCS 的成长。最开始 JSCS 得到了 JSHint 的宣传 -- JSHint 决定去除所有代码风格相关的规则，而 JSCS 则作为这些规则的替代品。因此当 JSCS 遇到问题时，会提到 JSHint 团队成员。有了这个领域的巨头支持，早期一段时间内，JSCS 的使用远超于 ESLint。第一年的一段时间内，我曾一度以为 JSCS 会碾压 ESLint，让我许多夜晚和周末的工作失去意义，然而这一切并没有发生。

强大的群众基础支持着 ESLint，最终帮助它得到了巨大成长。用户带来了更多用户，ESLint 也由此获得了成功。

## 关注实用性而非竞争

这是 ESLint 一路走来我最骄傲的事情之一。我从来没有说过 ESLint 优于其它工具，从来没有要求人们从 JSHint 或 JSCS 转向 ESLint。我主要说明了 ESLint 能更好的支持你编写自定义规则。到今天为止，ESLint README 里面这样写（在 FAQ）:

> 我不是说服你 ESLint 比 JSHint 更好。我只知道 ESLint 在我的工作中比 JSHint 更好。极小可能性你在做类似的工作，它可能更适合你。否则，继续使用 JSHint，我当然不会劝说你放弃使用它。

这一直是我的立场，现在也是 ESLint 团队的立场。一直以来，我始终认为 JSHint 是很好的工具，它有着很多优势 -- JSCS 也一样。很多人非常满意于使用 JSHint 和 JSCS 这一对组合，对他们来说，我鼓励他们继续使用。

ESLint 关注于尽可能有用，让开发者来决定是否适合他们。所有决策都基于有用性，而非与其它工具竞争。这个世界可以有很多检查工具的空间，不必只有一个。

## 耐心

我以前说过[8]，现在开源项目间似乎有一种不理性竞争：对人气的关注高于一切。ESLint 是一个项目从诞生到成功的很好的例子。在项目诞生初的近 2 年里，ESLint 的下载量远低于 JSHint 和 JSCS。ESLint 和 社区的成熟都花费了时间。ESLint 的“一夜成名”并不是发生在一夜，它经历了持续不断的基于有用性和社区反馈的改进。

## 优秀的团队

我很幸运有很优秀的团队为 ESLint 做贡献。由于我没有太多精力和时间在 ESLint 上，他们做了很多工作。一直令我吃惊的是我从来没有当面见过他们，也没有听过他们的声音，但我很期待能够每天和他们对话。由于我需要恢复健康，他们永恒的激情和创造力使得 ESLint 能够继续成长。虽然我一个人开始了 ESLint 这个项目，但他们无疑是它能够发展达到目前的人气的原因。

非常感谢 Ilya Volodin, Brandon Mills, Gyandeep Singh, Mathias Schreck, Jamund Ferguson, Ian VanSchooten, Toru Nagashima, Burak Yiğit Kaya, 和 Alberto Rodríguez，谢谢你们的大量工作。

## 结论

有许多因素导致了 ESLint 的成功，我希望通过分享它们，能给其他人创建成功的开源项目提供一个指引。最值得做的事情，一点幸运，其他人的帮助和对要实现的东西的一个清晰的愿景，这就是所有关键。我坚信如果你关注于创造一些有用的东西，愿意付出辛苦的工作，最终将得到应得的回报。

ESLint 也在继续成长和改变，团队和社区也是。期待 ESLint 的未来。

## References

1. [ESLint](http://eslint.org) (eslint.org)
2. [Introducing ESLint](https://www.nczonline.net/blog/2013/07/16/introducing-eslint/) (nczonline.net)
3. [HTTP Archive Trends 2013-2016](http://httparchive.org/trends.php?s=All&amp;minlabel=Jul+15+2013&amp;maxlabel=Jan+15+2016#bytesJS&amp;reqJS) (httparchive.org)
4. [babel-eslint](https://github.com/babel/babel-eslint) (github.com)
5. [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react) (github.com)
6. [Lint like it's 2015](https://medium.com/@dan_abramov/lint-like-it-s-2015-6987d44c5b48#.giue3dxsd) (medium.com)
7. [ESLint: The Next Generation JavaScript Linter](https://www.smashingmagazine.com/2015/09/eslint-the-next-generation-javascript-linter/) (smashingmagazine.com)
8. [Why I'm not using your open source project](https://www.nczonline.net/blog/2015/12/why-im-not-using-your-open-source-project/) (nczonline.net)

免责声明：文中任何观点都属于 Nicholas C. Zakas 本人所有，不代表雇主、同事，[Wrox Publishing](http://www.wrox.com/)、[O'Reilly Publishing](http://www.oreilly.com/)或其他人。

---

【译注】：本文发表于2016-2-9，现在 [JSCS 团队已经加入了 ESLint](http://eslint.org/blog/2016/04/welcoming-jscs-to-eslint)，文中有些数据也已经不再准确，但文章关注点不在这些，所以不再重新更新。希望这篇文章对开源作者有所参考！Enjoy it!❤️

---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
