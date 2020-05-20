> * 原文地址：[Rethinking the Front-end: Micro Frontend](https://medium.com/front-end-weekly/rethinking-the-front-end-micro-frontend-4cf21f0e22e)
> * 原文作者：[Ritesh Kumar](https://medium.com/@riteshiitbbs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/rethinking-the-front-end-micro-frontend.md](https://github.com/xitu/gold-miner/blob/master/article/2020/rethinking-the-front-end-micro-frontend.md)
> * 译者：
> * 校对者：

# Rethinking the Front-end: Micro Frontend

![](https://cdn-images-1.medium.com/max/2000/1*8wFsg7DNlsY8IFpEr6_Szg.jpeg)

> The front end is getting bigger and bigger for most of the **web apps** and the back end is becoming less relevant. I would assume that the majority of new web applications that are being developed today are facing a similar situation.

This includes support to enable the coexistence of different front-end frameworks, e.g. older modules built-in JQuery or AngularJS 1.x, in conjunction with newer modules built-in React or Vue.

#### The monolithic method isn’t working for broader web applications.

Managing 10 projects with 10 people each is simpler than managing one big project with 100 people each.

Scalability is the main conception here. By simplifying, we ‘re getting:

- Separate repositories
- Independent deployments
- Builds and releases faster
- Autonomous teams
- Easier testing and handling

**To give an example:**

**Myapp.com/-** Static HTML-built landing page.

**Myapp.com/settings -**old module of settings installed into AngularJS 1.x.

**Myapp.com/dashboard** - Built in React, new dashboard module.

I would imagine it requires the following:

- > A shared codebase in pure JavaScript e.g. routing management and user session management. Some have exchanged CSS. Both should be as slim as they can be.
- > A series of “mini-apps” independent modules designed in various frameworks, stored in different code repositories.
- > A deployment framework that bundles all modules from different repositories together, and deploys to a server whenever a module is modified.

**But as it turns out, several other people are pondering the same thoughts. The typical term is “micro frontends”.**

![Source: cygnismedia](https://cdn-images-1.medium.com/max/2100/1*rxsVRHNFdG-6gvOIUGAdcw.jpeg)

![Source: cygnismedia](https://cdn-images-1.medium.com/max/2896/1*rhF-hehEm-EN1lu8FnDvgw.png)

React is by far the most popular one as it has greatly evolved over the years and has made the life of developer easy.

## Implementing micro frontends

Here are a few different methods to implementing micro frontends:

1. [**Single-SPA** “meta framework”](https://github.com/CanopyTax/single-spa) to combine multiple frameworks on the same page without refreshing the page (see [this demo](https://single-spa.surge.sh/) that combines React, Vue, Angular 1, Angular 2, etc). See [Bret Little’s explanation here](https://medium.com/@blittle/great-article-d618ef46161c).
2. [**Multiple single-page apps that existat different URLs**](https://news.ycombinator.com/item?id=13011795). The apps use NPM/Bower components for shared functionality.
3. Isolating micro-apps into [**IFrames** using libraries and Window.postMessage APIs](https://news.ycombinator.com/item?id=13009285) to coordinate. IFrames share APIs exposed by their parent window.
4. [**Web Components** as the integration layer](https://technologyconversations.com/2015/08/09/including-front-end-web-components-into-microservices/).
5. [“Blackbox” **React** components](https://news.ycombinator.com/item?id=13012916).

Happy reading!

Cheers,
Ritesh :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
