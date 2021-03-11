> * 原文地址：[Announcing the New TypeScript Handbook](https://devblogs.microsoft.com/typescript/announcing-the-new-typescript-handbook/)
> * 原文作者：[Orta Therox](https://devblogs.microsoft.com/typescript/author/ortammicrosoft-com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/announcing-the-new-typescript-handbook.md](https://github.com/xitu/gold-miner/blob/master/article/2021/announcing-the-new-typescript-handbook.md)
> * 译者：
> * 校对者：

# Announcing the New TypeScript Handbook

Hey folks, we’re happy to announce that a fresh re-write of the TypeScript Handbook is out of beta and is now our website’s primary resource for learning TypeScript!

![](https://camo.githubusercontent.com/31314b426b9625bab48f962812b35f25c46f1d4f89ffbc652192b5e2cd81cf8f/68747470733a2f2f646576626c6f67732e6d6963726f736f66742e636f6d2f747970657363726970742f77702d636f6e74656e742f75706c6f6164732f73697465732f31312f323032312f30332f53637265656e2d53686f742d323032312d30332d30352d61742d322e35332e32372d504d2e706e67)

Read the handbook on [Web](https://www.typescriptlang.org/docs/handbook/intro.html) / [Epub](https://www.typescriptlang.org/assets/typescript-handbook.epub) / [PDF](https://www.typescriptlang.org/assets/typescript-handbook.pdf)

In the last year, the TypeScript team has heavily focused on ramping up the scale, modernity and scope of our documentation. One of the most critical sections of our documentation is the handbook, a guided tour through the sort of TypeScript code you’ll see in most codebases. We want the handbook to feel like the first recommendation you give for learning TypeScript.

With the release of the [revised website last year](https://devblogs.microsoft.com/typescript/announcing-the-new-typescript-website/) we included some incremental improvements to the handbook, but the new version of the handbook is what provided a “north star” for a lot of features on the new website.

The new handbook project started out in 2018, with an additional set of constraints applied to how we teach:

- **Leave teaching JavaScript to the experts**

    There are so many great resources for learning JavaScript across the web and via books. There’s no need for us to compete in that space. The handbook aims to help engineers understand the way TypeScript builds on JavaScript. This focus means that our documentation can make assumptions about background, and avoid explaining JavaScript features from the ground up.

    That isn’t to say that we don’t anticipate people from different skill levels using the handbook though. For example, we added a new section to the site which primes people on how TypeScript compares to other languages depending on their technical background as a precursor reading to the handbook. You can see that over in the [documentation overview](https://www.typescriptlang.org/docs/).

- **Teach incrementally**

    We wanted to build concepts on top of each other in a linear way – avoiding TypeScript features which hadn’t yet been explained. This limitation did a good job of forcing us to re-think the order and categories for language concepts. Teaching this way made authoring the first few pages a little difficult, but it really becomes valuable for readers and encourages a start-to-finish style of reading.

- **Let the compiler do the talking**

    If you have already used the TypeScript documentation since the new website launched, you may have noticed that we have code samples which provide inline context like quick info and errors, and can even show output `.js` and `.d.ts` files.

    As handbook contributors, it means we have to acknowledge when a TypeScript change impacts the documentation. When we migrate the website to a new TypeScript version, that migrates the handbook too, and if the results aren’t the same it’s easy for us to see the impact and decide what the changes we need to make.

    What excites me, is that we are using these tools to bring some of the best features from a rich editor’s experience into the pages on the web, and statically in epub/pdf forms for the handbook. This technology can power [your apps too](https://www.npmjs.com/package/shiki-twoslash).

    As a reader, that means all code samples in the site are up-to-date, accurate and interactive!

- **Write for the everyday cases**

    TypeScript has been around for 8 years, and on the whole, does not remove features. Documenting all of the possible uses, and viable options for any concept, has been moved out of the responsibility of the handbook and into our growing section of “reference pages”. We think this should remove distractions on the path to TypeScript enlightenment.

    While for some of us it might be fun to learn about the history of JavaScript bundling patterns or how more-esoteric TypeScript options change code flow analysis (and it is for me!), most people are either learning for “greenfield” projects, or working in codebases with all that figured out already.

These constraints have helped us provide a much more focused, and approachable guided tour through the TypeScript language. We’re big fans (even if we might be biased).

While I may be the one announcing the new handbook, and pushing it over the line to *“ready”*. The new handbook has been a running project for many years in TypeScript team with many hundreds of contributions big and small. In the last few months, we’ve been getting really great feedback from the public which has helped give some fresh perspective on how we explain ideas – so I’d like to say thanks to everyone involved!

If you’ve been keeping up to date with TypeScript via the quarterly release notes on this blog, you might be a good candidate for giving the new handbook a re-read. We showcase all the old and new features but they are all interlinked and introduced in a consistent order. You never know what you might have missed. If you spot something we’ve missed, feel free to leave us an [issue on microsoft/TypeScript-Website](https://github.com/microsoft/TypeScript-Website/issues/new/choose).

You can read the new handbook on: [Web](https://www.typescriptlang.org/docs/handbook/intro.html) / [Epub](https://www.typescriptlang.org/assets/typescript-handbook.epub) / [PDF](https://www.typescriptlang.org/assets/typescript-handbook.pdf)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
