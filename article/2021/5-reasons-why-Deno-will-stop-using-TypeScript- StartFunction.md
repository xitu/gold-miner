> * 原文地址：[5 reasons why Deno will stop using TypeScript - StartFunction](https://startfunction.com/deno-will-stop-using-typescript/)
> * 原文作者：[eliorivero](https://en.gravatar.com/eliorivero)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-Deno-will-stop-using-TypeScript- StartFunction.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-Deno-will-stop-using-TypeScript- StartFunction.md)
> * 译者：
> * 校对者：
> 
# 5 reasons why Deno will stop using TypeScript
![image](https://user-images.githubusercontent.com/8282645/109243795-858b9e00-7818-11eb-9779-00cf8282c99f.png)


A document surfaced today pointing that Deno will stop using TypeScript in its internal code, citing several problems with the current environment. Issues mentioned involve TypeScript compiling times, structuring and code organization, among others. Moving forward, Deno will use pure JavaScript for its internal code.

## Deno problems with TypeScript

The unfavorable situations that the Deno team is currently experiencing while using [TypeScript](https://startfunction.com/tag/typescript) for its internal code are:

- TypeScript compile time when changing files takes several minutes, making continuous compiling an excruciatingly slow process
- The Typescript structure that they’re using in the source files that create the actual Deno executable and the user-facing APIs is creating runtime performance problems
- TypeScript isn’t proving itself helpful to organize Deno code. On the contrary, the Deno team is experiencing the opposite effect. One of the issues mentioned is that they ended up with duplicate independent Body classes in two locations [https://github.com/denoland/deno/issues/4748](https://github.com/denoland/deno/issues/4748)
- The internal code and runtime TypeScript declarations must be manually kept in sync since the TypeScript Compiler isn’t helpful to generate the d.ts files
- They’re maintaining two TS compiler hosts: one for the internal Deno code and another other for external user code even though both have a similar goal

## Removing TypeScript in internal Deno code

The [Deno](https://startfunction.com/tag/deno) team aims to remove all build-time TS type checking and bundling for internal Deno code. They’re looking forward to move all the runtime code into a single [JavaScript](https://startfunction.com/category/javascript) file. However, they’ll still use a companion d.ts file to keep the type definitions and documentation.

It’s worth mentioning that Deno will stop using TypeScript only for the internal Deno code: the Deno user code will still be in TypeScript and thus type checked.

While TypeScript is sometimes seen as an improved version of JavaScript, this case is showing that in fact, it’s not. It has flaws like any other language. One of the most important ones is its slow compilation time. While small projects might not see a huge spike in compilation time when switching from pure JavaScript to TypeScript, it will be noticeable in large projects like a complex [React](https://startfunction.com/tag/react) app. Given the large size of its runtime, it’s not surprising that Deno will stop using TypeScript.

The safety of type checking during development does have its cost at compilation time. It’s not without reason that the TypeScript project has an extensive document on how to address and [improve compilation time](https://github.com/microsoft/TypeScript/wiki/Performance). One of the most interesting approaches is to use [Project References](https://www.typescriptlang.org/docs/handbook/project-references.html), that allows developers to break apart a big TypeScript piece of code into smaller pieces.

## Read more about why Deno will stop using TypeScript

The complete discussion about the decision to drop TypeScript from the internal Deno code and use JavaScript instead can be found in [this document](https://docs.google.com/document/d/1_WvwHl7BXUPmoiSeD8G83JmS8ypsTPqed4Btkqkn_-4/preview?pru=AAABcrrKL5k*nQ4LS569NsRRAce2BVanXw#), where Ryan Dahl and collaborators discuss the problem, its solution, and how it’s going to be implemented.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
