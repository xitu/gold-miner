> * 原文地址：[How to Achieve Reusability with React Components](https://medium.com/walmartlabs/how-to-achieve-reusability-with-react-components-81edeb7fb0e0#.czocsk5l0)
* 原文作者：[Alex Grigoryan](https://medium.com/@lexgrigoryan?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How to Achieve Reusability with React Components #

# 如何实现 React 组件的可复用性 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*5jIE1tOzVSuz5NPHsfeQ8w.png">

Reusability is one of the most common buzzwords in software engineering today. It’s promised by a wide variety of frameworks, tools, and paradigms, each of which seems to have not only its own approach to achieving reusability, but its own definition of the word itself.

可复用性一词是当今软件工程领域上最为常见的流行词之一。大量不同的框架、工具乃至模型都承诺着会达到一定的可复用性，而且每一个都看似具有着自己的实现方法，以及对该词的不同定义。

### So what do we mean by reusability? ###

### 那么，可复用性在这里到底意味着什么？ ###

True reusability is not an ad hoc process, but a development strategy. Reusable components must be built from the ground up with reusability in mind, which involves careful planning and empathetic API design. Furthermore, while modern development tools and frameworks can support and encourage code reuse, reusability cannot be achieved through technology alone — it requires processes implemented consistently across teams, and commitment at all levels of an organization.

正确的可复用性指的并非是一个特定的流程，而是一个开发策略。因而，在构建可复用组件时必须把可复用性牢记在脑海里，包括细致的规划与设身处地的 API 设计。再者，当现代的开发工具与框架都可以支持且倡导代码复用时，可复用性已经不能通过单一的技术去实现 —— 而是需要开发团队间一致的实现过程以及一个机构所有层面上的技术保证。

So when we discuss reusability, it’s not just a technical discussion. It also incorporates corporate culture, training, and a host of other considerations. We’ll touch on a few of those here, but the point is that **reusability is a process that touches every stage of development and every level of an organization**.

因此，当我们谈及可复用性时，这并不仅仅只是一个技术性的讨论。它还会综合有公司的文化、培训以及很多其他的要素。而在该文当中，我们会触碰到部分的要素，但关键点在于**可复用性是一个过程。它会触碰到开发的各个阶段以及一个机构中的各个层面。**

Walmart consists of several brands, including Sam’s Club, Asda, and regional branches like Walmart Canada and Walmart Brazil. Across these brands we have dozens of front-end applications built and maintained by hundreds of developers.

沃尔玛（Walmart）旗下其实包含有若干个品牌，其中包括山姆俱乐部（Sam’s Club）、阿斯达（Asda）以及一些地区分支，如 沃尔玛（加拿大）与沃尔玛（巴西）等。其中，大量穿插在这些品牌中的前端应用则是由上百名开发者进行构建与维护。

Because each of these brands has its own online presence, each has developers working on components that are common to all of Walmart’s brands — an image carousel, navigational elements like bread crumbs, flyouts, credit card form components, for example. Duplication of work that’s already been completed by another team is a waste of time and money, and also creates more surface area for bugs. Eliminating that duplication enables developers to spend more time on projects that bring new value to the customer experience.

因为每一个品牌都会有着属于自己的品牌容貌，因而开发者需要在一个共同的组件上工作，以维护所有的这些沃尔玛品牌 —— 例如，图片轮播（Image Carousel）或像面包屑（Bread Crumbs）、弹框和信用卡 Form 组件等这样的导航式元素。众所周知，重复去做别人已做过的事情只是在浪费时间与金钱，而且还会造成更多容易出现问题的地方。因此，消除这样的重复工作能使得开发者把时间更多地花费在用户体验的提升上。

On the backend, sharing code across brands is more intuitive: a single service can take requests from multiple different brands and return the appropriate data for that brand (and there are a few ways to handle that based on the shape of the data). On the front end, the situation is more complex because it involves taking the data provided by the backend and applying themes and other transformations appropriate to a specific brand and view. Doing this in a way that fosters reuse is not a completely solved problem.

对于后端来说，在不同的品牌间分享代码会使得事情变得更为直观：即一个单一的服务器能处理来自不同品牌的多个请求，并返回对应品牌的精确数据（基于数据形式的处理方法不止一个）。可是，对于前端来说，这样的情况则会变得更为复杂。因为这将涉及对后端所提供的数据进行提取，并把主题及其他信息准确地应用到一个特定的品牌和视图上。因此，我们仅仅促进代码的复用，是不能完全地去解决问题。

### React Component Reuse at @WalmartLabs ###

### @沃尔玛实验室（@WalmartLabs）里对 React 组件的复用 ###

For Walmart.com, we picked React for our front end framework, and one of the reasons we picked it was that its component model provides a good starting point for code reuse — especially when paired with Redux for state management. Still, there are significant challenges to frontend code reuse in an organization the size of Walmart.

关于构建网站 Walmart.com，React 是我们所选择的前端框架。至于为何作出这样的抉择，其中一个原因在于其组件模型能为代码的复用提供一个好的起始点，尤其是当我们结合 Redux 来管理 State 时。可是，Walmart 的体量对前端代码复用来说仍然会带有显著的挑战。

### Technical Capability to Share Code ###

### 共享代码的技术可能性 ###

The first challenge involves the technical means of sharing code — components need to be versioned, easy to install, and upgradeable. We put all of our React components into a separate GitHub organization. Currently, components are bundled into repos based on the teams that created them, but we’re in the process of moving toward functional repos, such as a “Navigation” repo containing breadcrumb, tabs, and sidenav link components. Components are then published in our private npm registry, meaning that developers can easily install a specific component version, ensuring that their apps won’t suddenly break on upgrade.

共享代码所涉及的首个技术挑战是 —— 组件需要能被版本化，且易于安装及升级。对此，我们会把所有的 React 组件放置在一个分离的 GitHub 机构中。可目前，尽管组件已被捆绑于创建自身的团队项目中，但我们仍然需要把部分的组件移至功能化项目，如包含有面包屑、标签及侧导航链接组件的“导航栏”项目。然后，组件就会被发布至 npm。这也就意味着开发者能非常容易地安装具有特定版本的一个组件，并保证其程序不会因版本的升级而突然抛锚。

At this point, since code is being shared across teams, we needed to ensure consistent structure and coding standards across hundreds of components, even as dependencies are upgraded and needs change. That’s why we created [Electrode Archetypes](http://www.electrode.io/docs/what_are_archetypes.html) for [components](https://github.com/electrode-io/electrode/tree/master/packages/electrode-archetype-react-component) and [applications](https://github.com/electrode-io/electrode/tree/master/packages/electrode-archetype-react-app). The archetypes include configuration files for linting, transpilation, and bundling, and provide a central point from which we can manage core dependencies & tasks/scripts. Starting from a common structure and establishing consistent coding standards across all projects enables us to maintain modern best practices throughout the organization and increases the confidence developers have in each other’s code, improving the chances that reusable components will actually be reused. This confidence is further improved by a rigorous Continuous Integration/Continuous Deployment system, including rules to lint code, gauge performance, and test across multiple devices, browsers, and screen resolutions. The CI system can include rules to publish a beta version of a component when a PR is submitted and run functional tests of all applications using that component, to ensure that the PR doesn’t break anything.

至此，既然代码能在团队间进行分享，那么，不管组件的依赖是否更新或替换，我们都需要保证其结构与代码的一致性。这也就是为什么我们要为[组件](https://github.com/electrode-io/electrode/tree/master/packages/electrode-archetype-react-component)与[应用](https://github.com/electrode-io/electrode/tree/master/packages/electrode-archetype-react-app)创造出 [Electrode 原型](http://www.electrode.io/docs/what_are_archetypes.html)。该原型不仅包含有用于代码规范、转译及封装的配置文件，而且还提供有用于管理核心代码依赖与任务/脚本的中心点。从一个通用的结构开始，建立起项目间一致的代码标准可以使得我们维持机构里最好的现代化实践，并提高开发者在他人代码中的信心。这样的话，可复用的组件才能更为可能地被真正复用。

### The Meta Team ###

### 元队（the Meta Team） ###

In the early days of this project, the majority of shared components were contributed by just a few teams, and those components tended to change very quickly. Eventually, we selected a few developers with a particularly deep understanding of the Electrode framework and Walmart internals and created a group we call our meta team. These individuals would devote a few hours or a day every few weeks to review the code going into the component organization, ensure that all best practices are followed, and generally help out in any way they could. This team also developed an overall knowledge of what’s being built across the organization, and served as ambassadors for the [Electrode](http://www.electrode.io/) project in their own teams. Meta team members also took information about pending archetype changes to their teams, and collected feedback to share with the Electrode core team.

在项目的初期，由于大部分的共享组件是由少量的团队所贡献完成的，因而它们更新迭代的速度会非常得快。可最终，我们还是选择了少部分的开发者去深入探究 Electrode 原型及沃尔玛的内部结构，以创造出我们所称作的“元队”。被选中的人会在每周抽出数小时或一天的时间去对机构中正在运行的组件代码进行审查，以确保开发者能遵循实践，并尽可能地互相协助。此外，该团队还会就机构中所构建的东西总结出一整套知识体系，并以使者的角色去为自己团队中采用 [Electrode](http://www.electrode.io/) 原型的项目提供服务。再且，元队成员还会把关于原型修改待决的部分信息带至自己的团队中，以收集回馈并与 Electrode 原型的核心开发团队进行分享。

These steps were a great start, but we still saw further opportunities to improve code reuse as an organization.

尽管这是一步好的开始，但作为一个机构，我们仍然能看到更深的机会去提升代码的复用情况。

### Discoverability Problem of Hundreds of Components ###

### 上百个组件的暴露性问题 ###

We started noticing a lot of messages in our Slack channels along a shared theme. Developers wanted to know whether or not a component had already been created for a certain task. UX teams wanted to be able to see what components were available. Project managers wanted to see what components were being built by other teams. The common thread among all these messages was discoverability. We needed a fast, simple way to discover what components were available, to see them in use and interact with them, and to learn about their implementation, configuration, and dependencies.

过去，我们开始注意到 Slack 频道上有大量关于共享主题的信息涌现出来，并发现开发者希望能知道是否已经有现有的组件能完成一个特定的任务。比如说 UX 团队希望能查看到哪些组件是可用的，而项目经理则希望能查看到哪些组件是其他团队正在构建中的。也就是说，所有的这些信息围绕的共同焦点就在于组件的暴露性。因此，我们过去需要一种快速且简单的方法，去发现可用的组件并查看它们的使用情况。从而能与这些组件进行交互，并了解它们的实现、配置及依赖。

Our answer to this problem is [Electrode Explorer, which I discussed in a previous post](https://medium.com/walmartlabs/spotlight-on-electrode-explorer-react-component-reuse-without-the-hassle-6447763365b2#.etp9o5wr0). Explorer enables our developers to browse through the hundreds of components available within @WalmartLabs, read their documentation and see what they look like, and even step through their version histories to see how they’ve changed over time. Because Electrode Explorer provides a web interface to all of the React components in an organization, developers don’t need to `npm install` a component to see it and interact with it.

那么，问题的答案就在于[我过去曾写文讨论的一样东西 —— Electrode 勘探器](https://medium.com/walmartlabs/spotlight-on-electrode-explorer-react-component-reuse-without-the-hassle-6447763365b2#.etp9o5wr0)。开发者通过该勘探器不仅能浏览到@沃尔玛实验室中上百个可用的组件及其文档，而且还能浏览到组件的版本提交记录，以查看其各阶段的修改。正是因为 Electrode 勘探器能提供机构中所有组件的 Web 接口，因而开发者不再需要 `npm install` 去查看及使用组件。

### Duplication Spilling Through The Cracks ###

### 缝隙间溢出的重复组件 ###

But even with all these tool and processes to facilitate code reuse, we still saw problems. One issue was that teams often developed new components without recognizing that they could be useful to other teams. Components can’t be reused if they’re not included in the reusable ecosystem. Even within the shared component system, we saw a lot of duplication, or components that took slightly different approaches to very similar problems. What we realized is that technological solutions aren’t enough — there needs to be a company-wide change in thinking, wherein stakeholders at all levels take a reusability-first approach. This includes taking the time to generalize components so that reuse is easier, expanding existing components rather than starting from scratch, and consciously seeking out opportunities to share code whenever possible.

尽管所有的这些工具与程序都是在促进代码的复用，但我们仍然能看到问题的所在。其中一个问题就是，开发团队经常在开发新组件时没有意识到组件会帮助到其他团队。若组件没有被涵盖在可复用的生态系统中，这就意味着该组件无法被重用。即便它们是存在于一套共享组件系统，但我们还是能发现系统里存在有许多重复的组件，或一些对相似问题采用不同解决办法的组件。因此，我们这才意识到技术手段并非能完全地解决问题。此时，我们需要的是一种办法。它不仅能广泛地改变公司人员的思考方式，而且还能使得所有层面的人员都能事事以可复用性当先。这就包括花费时间去对之前的组件进行归纳总结，以便复用变得更为简单；在已有组件的基础上扩展，而非从零开始；且不断寻找机会来尽可能地去与外界分享代码。

To assist this change in thinking, we created a component proposal process. Under this system, developers discuss new components before starting work on them. This provides an opportunity for developers on other teams to suggest existing solutions or alternative approaches, and lets others in the organization know what’s happening.

为了协助思想上的这种改变，我们创建了一套组件开发的提案流程。在此系统下，开发者需要在工作开始前先讨论关于新组件的一切事宜，以便机构中的其他团队能根据此事来推荐出已有的解决方案或可选方法。

> *The proposal system along with the meta process helps not having duplication get through the cracks.*

> *伴随着开发过程，该提案系统帮助我们解决了缝隙间所溢出的重复组件问题。*

### Importance of CI/CD ###

### 持续集成（CI）/持续部署（CD）方案的重要性 ###

A big issue we ran into was that one team would work on a component and break another team’s application. If you didn’t lock down your component version, your CI/CD might fail due to a component being modified by another team — it’s a terrible feeling, and it leads to a lot of teams locking down components to a very specific version, where they might not even take new patch versions.

过去，我们曾遇到过一个大的问题，那就是一个团队在组件上的开发可能会导致其他团队的程序抛锚。换而言之，如果你不对组件的版本进行加锁，持续集成/持续部署方案可能就会因为组件被其他团队修改，而导致出错 —— 这是一个非常糟糕的体验。甚者还会到导致大量团队需要封锁自身组件至一个特定的版本，而无法使用新的补丁版本。

This is where the CI/CD comes into play. When a component version is updated, automation should check if it breaks any consuming applications on that major version — it should check this even if the application locks its component versions. If there is no break, we want the CI/CD system to send a PR request that updates the locked version to the new one which didn’t break the application. If there is a break, both teams should be notified to talk out what the problem is.

因此，这就是为何我们需要引入持续集成/持续部署方案。当一个组件版本更新时，不管其他重要的程序是否对该组件的版本进行加锁，方案中的自动装置仍需要检查本次更新是否会导致程序主版本的崩溃。若无，则生成一个 PR 请求来更新锁定的版本至最新版本号；而若有，则通知涉事团队双方去检讨问题的所在。

### Innersource ###

### 内部资源 ###

The foundation of our approach to reusability is our embrace of the open source/inner source philosophy, as described by [Laurent Desegur](https://twitter.com/ldesegur) in a previous [post](https://medium.com/walmartlabs/beyond-open-source-walmartlabs-e690c934fe35#.lqc0e6x3b) . @WalmartLabs has been a user of and contributor to open source for years, as demonstrated by projects like Hapi, [OneOps](https://github.com/oneops) , and [Electrode](https://github.com/electrode-io) . Less obvious from outside the company is our commitment to inner source, which is the internal application of the open source model. In the inner source approach, no team or developer “owns” a component — all components are shared throughout the organization. This eliminates bottlenecks and empowers developers to improve existing components.

关于提高 React 组件可复用性的这些方法都是基于 [Laurent Desegur](https://twitter.com/ldesegur) 早前[写文](https://medium.com/walmartlabs/beyond-open-source-walmartlabs-e690c934fe35#.lqc0e6x3b)所描述的关于开放资源/内部资源哲学思想的一些领会。随着像 Hapi、[OneOps](https://github.com/oneops) 与 [Electrode](https://github.com/electrode-io) 等一些项目的展现，可以看到@沃尔玛实验室在过去几年已逐渐成为开源征途上的用户及贡献者。尽管，从外界很难看出实验室是我们内部资源的保障，即那些基于开源模型所开发的内部程序。但是，对于内部资源来说，并没有任何一个团队或成员会真正地“拥有”一个组件。换句话说，所有的组件是分享在整个机构当中的。这就意味着能消除开发的瓶颈并驱使开发者去提升已有组件的质量。

These policies greatly increase opportunities for reuse — but more importantly, they signal to developers our commitment, as a company, to a philosophy of cooperation and collaboration. They empower developers to use their time and expertise where it’s most needed, rather than waiting for bottlenecks to clear, and they benefit the company in real, measurable ways.

这样的策略不仅能很好地提高组件复用的机率，而且更为重要的是，还能为我们的开发者及开发协作的哲学思想提供有一定指引。
它们驱使着开发者去利用时间与经验来琢磨组件的所需之处，从而使得公司能真正显著地受益，而不是等待着技术瓶颈的清除。

### Conclusion ###

### 总结 ###

Reusability is not just a technical decision, but also a philosophical one that requires organizational commitment and has far-reaching implications. At @WalmartLabs, we’ve seen the benefits it can bring — right now we’re moving SamsClub.com to the [Electrode platform](https://github.com/electrode-io) , and our developers are reusing hundreds of components from Walmart.com with theming to match the Sam’s Club brand.

可复用性不仅是一种技术性的决策，而且还是一种需要机构性保障，且具有深远意义的哲学思想。通过@沃尔玛实验室这个例子，我们就可以清晰地看到其所产生的效益是何等巨大。如今开发者们正在把 SamsClub.com 移植到 [Electrode 平台](https://github.com/electrode-io)上，并复用数百个来自 Walmart.com 的组件以匹配山姆俱乐部的品牌。

Tell us your reusability story — what obstacles have you encountered? How have you solved them? What opportunities for further improvement do you see?

最后，你也可以跟我们分享一下自己关于可复用性的一些故事，包括当中遇到了哪些阻碍？怎么去解决？以及你所能看到的哪些更深层次的提升？
