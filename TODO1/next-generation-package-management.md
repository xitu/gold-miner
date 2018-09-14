> * 原文地址：[Next Generation Package Management](https://blog.npmjs.org/post/178027064160/next-generation-package-management)
> * 原文作者：[The npm Blog](https://blog.npmjs.org)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/next-generation-package-management.md](https://github.com/xitu/gold-miner/blob/master/TODO1/next-generation-package-management.md)
> * 译者：
> * 校对者：

# Next Generation Package Management

What if installs were so fast they could happen in the background, just by using Node? What every file in your dependencies could be guaranteed to be bit-by-bit identical to what’s on the registry? What if working on a new project was as simple as clone and run? What if your build tools got out of your way?

Introducing [`tink`](https://t.umblr.com/redirect?z=https%3A%2F%2Fgithub.com%2Fnpm%2Ftink&t=NDM0Zjk2ZmNkNTVkNTU4NDlmNzNkNDQwMWE3YTMwNjI0OTMyNTg5Yix2SGt2amVPVg%3D%3D&b=t%3AnXsLs1P4AptPf1fBr_nFxw&p=https%3A%2F%2Fblog.npmjs.org%2Fpost%2F178027064160%2Fnext-generation-package-management&m=1), a proof of concept implementation of an install-less installer.

`tink` acts as a replacement for Node.js itself, working from your existing `package-lock.json`. Try it out on a project without a `node_modules` and you’ll find that you can still `require` any of your dependencies even though you never ran an install. The first run will take a few seconds while it downloads and extracts the package tarballs, but subsequent runs are nearly instantaneous even though it’s still verifying that everything in your `package-lock.json` is on your system.

The first thing you’ll notice is that none of those modules are put into your `node_modules` folder — in fact, the only thing you’ll find there is a `.package-map.json` file. This contains hashes of all of the files in every package you have installed. These are verified before they’re loaded, so you can have confidence that you’re getting what you asked for (if a verification fails then the file is fetched from its original source, all transparently).

We’re not throwing the baby out with the bathwater though. You can still install things in your `node_modules` folder and those versions will be used in preference to the cached version. This opens a path to live-editing of dependencies (sometimes a necessary debugging technique) and support for things like postinstall scripts that mutate the package distribution.

`tink` is an opportunity to change how we relate to our Node.js projects and the npm Registry. Should using `require` or `import` on a module not in your `package.json` just add it to your `package.json`? Should extremely popular features like babel-compatible esm, typescript, or jsx be available by default? These are the questions we’ve been asking ourselves and we’d love to hear what you would want from a next generation experience. Come by [npm.community](https://t.umblr.com/redirect?z=https%3A%2F%2Fnpm.community&t=MzE1YThiMDY5NDdlM2U2ZGExZGJjYWQwODYzZjJmMjI5NTkzNThlYix2SGt2amVPVg%3D%3D&b=t%3AnXsLs1P4AptPf1fBr_nFxw&p=https%3A%2F%2Fblog.npmjs.org%2Fpost%2F178027064160%2Fnext-generation-package-management&m=1) and let us know!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
