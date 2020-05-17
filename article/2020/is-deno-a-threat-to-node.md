> * 原文地址：[Is Deno a Threat to Node?](https://medium.com/better-programming/is-deno-a-threat-to-node-1ec3f177b73c)
> * 原文作者：[KAPIL RAGHUWANSHI](https://medium.com/@techygeeky)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-a-threat-to-node.md](https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-a-threat-to-node.md)
> * 译者：
> * 校对者：

# Is Deno a Threat to Node?

#### Deno 1.0 was launched on May 13, 2020, by Ryan Dahl — the creator of Node

![Image copyrights Deno team — [deno.land](https://deno.land/)](https://cdn-images-1.medium.com/max/4000/0*eWlvIft04L3P3uPm.jpg)

It’s been around for two years now. We’re hearing the term **Deno**, and the developer community, especially the JavaScript community, is quite excited since it’s coming from the author of [Node](https://en.wikipedia.org/wiki/Node.js), Ryan Dahl. In this article, we’ll discuss a brief history of [Deno](https://deno.land/) and Node along with their salient features and popularity.

Deno was announced at JSConf EU 2018 by [Ryan Dahl](https://en.wikipedia.org/wiki/Ryan_Dahl) in his talk “10 Things I Regret About Node.js.” In his talk, Ryan mentioned his regrets about the initial design decisions with Node.

In his JSConf presentation, he explained his regrets while developing Node, like not sticking with promises, security, the build system (GYP), `package.json`, and `node_modules`, etc. But in the same presentation, after explaining all the regret, he launched his new work named **Deno**. It was in the process of development then.

But on 13th May 2020, around two years later, Deno 1.0 was launched by Ryan and the team (Ryan Dahl, Bert Belder, and Bartek Iwańczuk). So let’s talk about some features of Deno.

---

## What Is Deno?

Deno is a JavaScript/TypeScript runtime with secure defaults and a great developer experience. Deno is built on three pillars:

1. [**Chrome V8**](https://v8.dev/) — JavaScript runtime engine
2. [**Rust**](https://www.rust-lang.org/) Programming language
3. **[Tokio](https://github.com/tokio-rs/tokio)** — As noted on GitHub, “a runtime for writing reliable, asynchronous, and slim applications”

Deno aims to be a productive and scripting environment for the modern programmer. Similar to Node, Deno emphasizes [event-driven architecture](https://en.wikipedia.org/wiki/Event-driven_architecture), providing a set of non-blocking core IO utilities, along with their blocking versions.

#### Installation steps

Deno ships as a single executable with no dependencies. You can install it using the installers below.

Using Shell:

```
curl -fsSL https://deno.land/x/install/install.sh | sh
```

Or using Homebrew:

```
brew install deno
```

See [deno_install](https://github.com/denoland/deno_install) for more installation options.

A basic Hello-World program in Deno looks like the following (same as in Node):

```
console.log("Hello world");
```

We will try to compare the features of Deno with Node throughout the article. And in the end, we’ll try to find out whether or not it’s really a threat.

There is no doubt that Node is a hugely successful JavaScript runtime environment. Today, more than thousands of production builds are using Node. Another reason for this success is NPM, ****a ****package manager for the JavaScript runtime environment Node, which has millions of reusable libraries and packages for every JavaScript developer out there. Node is a decade old now: It was initially launched on May 27, 2009. On the other hand, Deno is relatively very new and still not used in production builds much. It can be used to create web servers like Node, perform scientific computations, etc.

---

## Highlighted Features of Deno

* Secure (No file, network, or environment access by default_
* Ships only a single executable file
* Say no to `node_modules` and `package.json`
* TypeScript support out of the box

#### Security

The program in Deno is executed in a secure sandbox (by default). Scripts cannot access the hard drive, open network connections, or make any other potentially malicious actions without permission. For example, the following runs a basic Deno script without any read/write/network permissions:

```
deno run index.ts
```

Explicit flags are required to expose corresponding permission:

```
deno run --allow-read --allow-net index.ts
```

#### Single executable file

Deno attempts to provide a standalone tool for quickly scripting complex functionality. Deno is a single file that can define arbitrarily complex behavior without any other tooling, so every library will be explicitly called and included in the program.

#### Module system

Here, we do not have any `package.json` or `node_modules`. Source files can be imported using a relative path, an absolute path, or a fully qualified URL of a source file. as shown below:

```
import { serve } from “https://deno.land/std@0.50.0/http/server.ts";

for await (const req of serve({ port: 8000 })) {

  req.respond({ body: “Hello from Deno\n” });

}
```

#### TypeScript support

TypeScript is an open-source programming language developed and maintained by Microsoft. TypeScript, in the end, transcompiles to JavaScript only. It is another popular language of recent times used heavily in the [Angular Framework](https://angular.io/) and React.js UI library. Deno supports TypeScript without additional tooling.

---

Deno is a new runtime for executing JavaScript and TypeScript outside of the web browser, like Node. But it’s important to understand that Deno is not an extension of Node — it’s completely a newly written implementation.

Slowly, Deno is also getting popular, like Node. You can see the popularity by Deno’s official twitter handle [@deno_land](https://twitter.com/deno_land) with [11.5K followers](https://twitter.com/deno_land/followers) and 50k+ stars on Github [https://github.com/denoland/deno](https://github.com/denoland/deno).

![Deno on GitHub](https://cdn-images-1.medium.com/max/4028/1*-Yautd54wWFt9irbMVx0Iw.png)

---

## Limitations of Deno

* Deno is not compatible with Node (NPM) packages. That’s a huge disappointment for the big JavaScript dev community.
* Since it uses the TypeScript compiler internally to parse the code to plain JavaScript, it is still very slow comparatively.
* It lags in HTTP server performance.

In the end, we can conclude that Node and Deno are two different JavaScript runtime environments altogether — so it’s better not to compare them. The choice depends on the given requirements. After looking at the gradually increasing popularity of Node among developers for a decade, I think it will be difficult for Deno to cover that in less time. But indeed, for new features, one can definitely try Deno. We will keep an eye on further developments with Deno and figure out more in the coming years. So, today we can make a statement that:

As of 2020, Deno is not at all a threat to Node.

---

Write your suggestions and feedbacks in the comment section below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
