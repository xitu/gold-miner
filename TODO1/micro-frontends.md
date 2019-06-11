> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends.md)
> * 译者：
> * 校对者：

# Micro Frontends

Good frontend development is hard. Scaling frontend development so that many teams can work simultaneously on a large and complex product is even harder. In this article we'll describe a recent trend of breaking up frontend monoliths into many smaller, more manageable pieces, and how this architecture can increase the effectiveness and efficiency of teams working on frontend code. As well as talking about the various benefits and costs, we'll cover some of the implementation options that are available, and we'll dive deep into a full example application that demonstrates the technique.

* * *

In recent years, [microservices](https://martinfowler.com/articles/microservices.html) have exploded in popularity, with many organisations using this architectural style to avoid the limitations of large, monolithic backends. While much has been written about this style of building server-side software, many companies continue to struggle with monolithic frontend codebases.

Perhaps you want to build a progressive or responsive web application, but can't find an easy place to start integrating these features into the existing code. Perhaps you want to start using new JavaScript language features (or one of the myriad languages that can compile to JavaScript), but you can't fit the necessary build tools into your existing build process. Or maybe you just want to scale your development so that multiple teams can work on a single product simultaneously, but the coupling and complexity in the existing monolith means that everyone is stepping on each other's toes. These are all real problems that can all negatively affect your ability to efficiently deliver high quality experiences to your customers.

Lately we are seeing more and more attention being paid to the overall architecture and organisational structures that are necessary for complex, modern web development. In particular, we're seeing patterns emerge for decomposing frontend monoliths into smaller, simpler chunks that can be developed, tested and deployed independently, while still appearing to customers as a single cohesive product. We call this technique **micro frontends**, which we define as:

> "An architectural style where independently deliverable frontend applications are composed into a greater whole"

In the November 2016 issue of the ThoughtWorks technology radar, we listed [micro frontends](https://www.thoughtworks.com/radar/techniques/micro-frontends) as a technique that organisations should Assess. We later promoted it into Trial, and finally into Adopt, which means that we see it as a proven approach that you should be using when it makes sense to do so.

![A screenshot of micro frontends on the ThoughtWorks tech radar](https://martinfowler.com/articles/micro-frontends/radar.png)

Figure 1: Micro frontends has appeared on the tech radar several times.

Some of the key benefits that we've seen from micro frontends are:

* smaller, more cohesive and maintainable codebases
* more scalable organisations with decoupled, autonomous teams
* the ability to upgrade, update, or even rewrite parts of the frontend in a more incremental fashion than was previously possible

It is no coincidence that these headlining advantages are some of the same ones that microservices can provide.

Of course, there are no free lunches when it comes to software architecture - everything comes with a cost. Some micro frontend implementations can lead to duplication of dependencies, increasing the number of bytes our users must download. In addition, the dramatic increase in team autonomy can cause fragmentation in the way your teams work. Nonetheless, we believe that these risks can be managed, and that the benefits of micro frontends often outweigh the costs.

* * *

## Benefits

Rather than defining micro frontends in terms of specific technical approaches or implementation details, we instead place emphasis on the attributes that emerge and the benefits they give.

### Incremental upgrades

For many organisations this is the beginning of their micro frontends journey. The old, large, frontend monolith is being held back by yesteryear's tech stack, or by code written under delivery pressure, and it's getting to the point where a total rewrite is tempting. In order to avoid the [perils](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/) of a full rewrite, we'd much prefer to [strangle](https://martinfowler.com/bliki/StranglerApplication.html) the old application piece by piece, and in the meantime continue to deliver new features to our customers without being weighed down by the monolith.

This often leads towards a micro frontends architecture. Once one team has had the experience of getting a feature all the way to production with little modification to the old world, other teams will want to join the new world as well. The existing code still needs to be maintained, and in some cases it may make sense to continue to add new features to it, but now the choice is available.

The endgame here is that we're afforded more freedom to make case-by-case decisions on individual parts of our product, and to make incremental upgrades to our architecture, our dependencies, and our user experience. If there is a major breaking change in our main framework, each micro frontend can be upgraded whenever it makes sense, rather than being forced to stop the world and upgrade everything at once. If we want to experiment with new technology, or new modes of interaction, we can do it in a more isolated fashion than we could before.

### Simple, decoupled codebases

The source code for each individual micro frontend will by definition be much smaller than the source code of a single monolithic frontend. These smaller codebases tend to be simpler and easier for developers to work with. In particular, we avoid the complexity arising from unintentional and inappropriate coupling between components that should not know about each other. By drawing thicker lines around the [bounded contexts](https://martinfowler.com/bliki/BoundedContext.html) of the application, we make it harder for such accidental coupling to arise.

Of course, a single, high-level architectural decision (i.e. "let's do micro frontends"), is not a substitute for good old fashioned clean code. We're not trying to exempt ourselves from thinking about our code and putting effort into its quality. Instead, we're trying to set ourselves up to fall into the [pit of success](https://blog.codinghorror.com/falling-into-the-pit-of-success/) by making bad decisions hard, and good ones easy. For example, sharing domain models across bounded contexts becomes more difficult, so developers are less likely to do so. Similarly, micro frontends push you to be explicit and deliberate about how data and events flow between different parts of the application, which is something that we should have been doing anyway!

### Independent deployment

Just as with microservices, independent deployability of micro frontends is key. This reduces the scope of any given deployment, which in turn reduces the associated risk. Regardless of how or where your frontend code is hosted, each micro frontend should have its own continuous delivery pipeline, which builds, tests and deploys the it all the way to production. We should be able to deploy each micro frontend with very little thought given to the current state of other codebases or pipelines. It shouldn't matter if the old monolith is on a fixed, manual, quarterly release cycle, or if the team next door has pushed a half-finished or broken feature into their master branch. If a given micro frontend is ready to go to production, it should be able to do so, and that decision should be up to the team who build and maintain it.

![A diagram showing 3 applications independently going from source control, through build, test and deployment to production](https://martinfowler.com/articles/micro-frontends/deployment.png)

Figure 2: Each micro frontend is deployed to production independently

### Autonomous teams

As a higher-order benefit of decoupling both our codebases and our release cycles, we get a long way towards having fully independent teams, who can own a section of a product from ideation through to production and beyond. Teams can have full ownership of everything they need to deliver value to customers, which enables them to move quickly and effectively. For this to work, our teams need to be formed around vertical slices of business functionality, rather than around technical capabilities. An easy way to do this is to carve up the product based on what end users will see, so each micro frontend encapsulates a single page of the application, and is owned end-to-end by a single team. This brings higher cohesiveness of the teams' work than if teams were formed around technical or “horizontal” concerns like styling, forms, or validation.

![A diagram showing teams formed around 3 applications, and warning against forming a 'styling' team](https://martinfowler.com/articles/micro-frontends/horizontal.png)

Figure 3: Each application should be owned by a single team

### In a nutshell

In short, micro frontends are all about slicing up big and scary things into smaller, more manageable pieces, and then being explicit about the dependencies between them. Our technology choices, our codebases, our teams, and our release processes should all be able to operate and evolve independently of each other, without excessive coordination.

We're releasing this article in installments. Future installments will describe alternative integration approaches for making these work, how to handle implementation issues such as styling and communication with applications, some downsides, and go through an example implementation in detail.

To find out when we publish the next installment subscribe to the site's [RSS feed,](https://martinfowler.com/feed.atom) [Cam's twitter stream](https://twitter.com/thecamjackson), or [Martin's twitter stream](https://twitter.com/martinfowler)

## Significant Revisions

**10 June 2019:** Published first installment, covering benefits

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
