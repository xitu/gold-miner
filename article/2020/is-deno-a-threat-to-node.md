> * 原文地址：[Is Deno a Threat to Node?](https://medium.com/better-programming/is-deno-a-threat-to-node-1ec3f177b73c)
> * 原文作者：[KAPIL RAGHUWANSHI](https://medium.com/@techygeeky)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-a-threat-to-node.md](https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-a-threat-to-node.md)
> * 译者：[ZiXYu]()
> * 校对者：

# Deno 会对 Node 造成威胁吗？

![Image copyrights Deno team — [deno.land](https://deno.land/)](https://cdn-images-1.medium.com/max/4000/0*eWlvIft04L3P3uPm.jpg)

> Deno 1.0 在 2020 年 5 月 13 日由 Node 的创造者 Dyan Dahl 发布

It’s been around for two years now. We’re hearing the term **Deno**, and the developer community, especially the JavaScript community, is quite excited since it’s coming from the author of [Node](https://en.wikipedia.org/wiki/Node.js), Ryan Dahl. In this article, we’ll discuss a brief history of [Deno](https://deno.land/) and Node along with their salient features and popularity.

从我们第一次听到 **Deno** 一词到现在大概快有两年的时间了，同时开发者社区，尤其是 JavaScript 社区对此非常兴奋，因为 Deno 是由 Node 的创造者 Ryan Dahl 创造的。在这篇文章中，我们将会对 [Deno](https://deno.land/) 和 Node 的历史进行一个简单的介绍，同时介绍它们的显著功能和受欢迎程度。

Deno was announced at JSConf EU 2018 by [Ryan Dahl](https://en.wikipedia.org/wiki/Ryan_Dahl) in his talk “10 Things I Regret About Node.js.” In his talk, Ryan mentioned his regrets about the initial design decisions with Node.

Deno 是在 2018 年的欧洲 JSConf 上由 [Ryan Dahl](https://en.wikipedia.org/wiki/Ryan_Dahl) 在他的演讲 ”我对 Node.js 感到遗憾的十件事“ 中宣布的。在他的演讲中，Ryan 提到了他对 Node 在最初的设计决策上的一些遗憾。

[点此观看他出色的演讲 (youtube)](https://youtu.be/M3BM9TB-8yA)

In his JSConf presentation, he explained his regrets while developing Node, like not sticking with promises, security, the build system (GYP), `package.json`, and `node_modules`, etc. But in the same presentation, after explaining all the regret, he launched his new work named **Deno**. It was in the process of development then.

在他的 JSConf 演讲中，他解释了在开发 Node 时的遗憾，例如没有坚持 promises，安全， 构建系统 (GYP)，`package.json` 和 `node_modules` 等等。但是在这同一演讲中，在解释完所有的遗憾之后，他推出了当时正处于开发中的名为 **Deno** 的新作品。

But on 13th May 2020, around two years later, Deno 1.0 was launched by Ryan and the team (Ryan Dahl, Bert Belder, and Bartek Iwańczuk). So let’s talk about some features of Deno.

在大约两年后的 2020 年 5 月 13 日，Ryan 和他的开发团队 (Ryan Dahl, Bert Belder, and Bartek Iwańczuk) 发布了 Deno 1.0。因此，让我们来谈谈 Deno 的一些特性。

## What Is Deno?

## Deno 是什么？

Deno is a JavaScript/TypeScript runtime with secure defaults and a great developer experience. Deno is built on three pillars:

Deno 是一种 JavaScript / TypeScript 的运行时，拥有默认的安全机制和绝佳的开发体验。Deno 由三大支柱组成：

1. [**Chrome V8**](https://v8.dev/) — JavaScript 运行时引擎
2. [**Rust**](https://www.rust-lang.org/) - 编程语言
3. **[Tokio](https://github.com/tokio-rs/tokio)** — 如在 Github 上写的那样, “一个用于编写可靠、异步和轻巧的应用的运行时

Deno aims to be a productive and scripting environment for the modern programmer. Similar to Node, Deno emphasizes [event-driven architecture](https://en.wikipedia.org/wiki/Event-driven_architecture), providing a set of non-blocking core IO utilities, along with their blocking versions.

Deno 的目标是为现代程序员提供高效的脚本环境。和 Node 类似，Deno 强调了[事件驱动架构](https://en.wikipedia.org/wiki/Event-driven_architecture)，提供了一套非阻塞的核心 IO 使用程序和它们的阻塞版本。

#### Installation steps

#### 安装步骤

Deno ships as a single executable with no dependencies. You can install it using the installers below.

Deno 提供了没有依赖性的单个可执行文件。你可以使用如下的安装方法来安装它。

Using Shell:

使用 Shell：

```bash
curl -fsSL https://deno.land/x/install/install.sh | sh
```

Or using Homebrew:

或者使用 Homebrew：

```bash
brew install deno
```

See [deno_install](https://github.com/denoland/deno_install) for more installation options.

查看 [安装 Deno] 来获取更多的安装选项。

A basic Hello-World program in Deno looks like the following (same as in Node):

在 Deno 中一个最基础的 Hello-World 程序如下（和在 Node 中一样）：

```js
console.log("Hello world");
```

We will try to compare the features of Deno with Node throughout the article. And in the end, we’ll try to find out whether or not it’s really a threat.

在这篇文章中，我们会试着比较 Deno 和 Node 的特性。最后，我们将尝试找出 Deno 是否对 Node 真的造成了威胁。

There is no doubt that Node is a hugely successful JavaScript runtime environment. Today, more than thousands of production builds are using Node. Another reason for this success is NPM, a package manager for the JavaScript runtime environment Node, which has millions of reusable libraries and packages for every JavaScript developer out there. Node is a decade old now: It was initially launched on May 27, 2009. On the other hand, Deno is relatively very new and still not used in production builds much. It can be used to create web servers like Node, perform scientific computations, etc.

毫无疑问，Node 是一个非常成功的 JavaScript 运行时环境。如今，成千上万的生产版本正在使用 Node。取得这个成功的另一个原因是 NPM，它是 JavaScript 运行时环境 Node 的 package 管理器，它为每一个 JavaScript 开发人员提供了数百万个可复用的库和 package。Node 已经有十年历史了：它于 2009 年 5 月 27 号首次发布。从另一方面说，Deno 相对比较新，而且还没有在生产版本中被广泛使用。它可以像 Node 一样被用于创建 Web 服务器，也可以用于执行科学计算等等。

## Highlighted Features of Deno

## Deno 的亮眼功能

* 安全 (默认没有文件、网络或者网络访问权限)
* 是一个单个可执行文件
* 对 `node_modules` 和 `package.json` 说不
* 开箱即用的 TypeScript 支持

#### Security

#### 安全性

The program in Deno is executed in a secure sandbox (by default). Scripts cannot access the hard drive, open network connections, or make any other potentially malicious actions without permission. For example, the following runs a basic Deno script without any read/write/network permissions:

Deno 中的程序是在一个安全的沙箱中执行的 (在默认情况下)。未经允许，脚本无法访问硬件，打开网络连接或者或进行任何其它潜在的恶意操作。例如，下面的命令行会在没有任何读/写/网络权限的情况下运行基本的 Deno 脚本：

```bash
deno run index.ts
```

Explicit flags are required to expose corresponding permission:

在命令行中添加显式标签来打开相应的权限：

```bash
deno run --allow-read --allow-net index.ts
```

#### Single executable file

#### 单个可执行文件

Deno attempts to provide a standalone tool for quickly scripting complex functionality. Deno is a single file that can define arbitrarily complex behavior without any other tooling, so every library will be explicitly called and included in the program.

Deno 尝试着提供一个独立的工具来快速编写复杂的功能。Deno 是一个单独的文件，无需其它的工具就可以定义任意复杂的行为，

#### Module system

#### 模块系统

Here, we do not have any `package.json` or `node_modules`. Source files can be imported using a relative path, an absolute path, or a fully qualified URL of a source file. as shown below:

在 Deno 中，完全没有任何的 `package.json` 或者 `node_modules` 的概念。可以使用源文件的相对路径、绝对路径或者一个完整有效的 URL 来导入源文件。如下所示：

```js
import { serve } from “https://deno.land/std@0.50.0/http/server.ts";

for await (const req of serve({ port: 8000 })) {
  req.respond({ body: “Hello from Deno\n” });
}
```

#### TypeScript support

#### TypeScript 支持

TypeScript is an open-source programming language developed and maintained by Microsoft. TypeScript, in the end, transcompiles to JavaScript only. It is another popular language of recent times used heavily in the [Angular Framework](https://angular.io/) and React.js UI library. Deno supports TypeScript without additional tooling.

TypeScript 是 Microsoft 开发及维护的一种开源编程语言。最后，TypeScript 仅可以被编译为 JavaScript。它是当下另一种在 [Angular 框架](https://angular.io/) 和 React.js UI 库中被大量使用的流行语言。Deno 无需其它工具即可支持 TypeScript。

---

Deno is a new runtime for executing JavaScript and TypeScript outside of the web browser, like Node. But it’s important to understand that Deno is not an extension of Node — it’s completely a newly written implementation.

Deno 类似于 Node，是一种新的可以在 web 浏览器之外执行 JavaScript 和 TypeScript 的运行时。但是我们必须要认识到，Deno 并不是 Node 的一种拓展 - 它完全是全新创作的一种实现。

Slowly, Deno is also getting popular, like Node. You can see the popularity by Deno’s official twitter handle [@deno_land](https://twitter.com/deno_land) with [11.5K followers](https://twitter.com/deno_land/followers) and 50k+ stars on Github [https://github.com/denoland/deno](https://github.com/denoland/deno).

渐渐地 Deno 也越来越受欢迎，就像 Node 一样。你可以从 Deno 拥有 [1.15 万粉丝](https://twitter.com/deno_land/followers) 的官方 Twitter 账号 [@deno_land](https://twitter.com/deno_land) 和 5 万+ 点赞的 [Github 页面](https://github.com/denoland/deno) 中发现它到底有多受欢迎。

![Deno 在 Github 中的页面](https://cdn-images-1.medium.com/max/4028/1*-Yautd54wWFt9irbMVx0Iw.png)

## Limitations of Deno

## Deno 的限制

* Deno is not compatible with Node (NPM) packages. That’s a huge disappointment for the big JavaScript dev community.
* Since it uses the TypeScript compiler internally to parse the code to plain JavaScript, it is still very slow comparatively.
* It lags in HTTP server performance.

* Deno 与 Node (NPM) 软件包并不兼容。这对于庞大的 JavaScript 开发者社区来说非常令人失望。
* 由于它内部使用了 TypeScript 编译器将代码解析为纯 JavaScript，因此它相对而言仍然很慢。
* 它在 HTTP 服务器性能方面比较落后

In the end, we can conclude that Node and Deno are two different JavaScript runtime environments altogether — so it’s better not to compare them. The choice depends on the given requirements. After looking at the gradually increasing popularity of Node among developers for a decade, I think it will be difficult for Deno to cover that in less time. But indeed, for new features, one can definitely try Deno. We will keep an eye on further developments with Deno and figure out more in the coming years. So, today we can make a statement that:

最后，我们可以得出结论，Node 和 Deno 是两个完全不同的 JavaScript 运行时环境 - 因此我们最好不要把它们放在一起比较。在它们两个之间做出的选择取决于给定的要求。在观察了十年来 Node 在开发人员之间逐渐流行的过程之后，我认为对 Deno 而言很难在更短的时间里实现这一点。但是确实，Deno 的新功能让它绝对值得一试。我们将会持续关注 Deno 的进一步发展，并且在未来几年中找到更多的解决方案。所以，今天我们可以得出这样一个结论：

As of 2020, Deno is not at all a threat to Node.

在 2020 年，Deno 还完全称不上 Node 的威胁。

---

Write your suggestions and feedbacks in the comment section below.

请在下方评论区写下您的建议和反馈。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
