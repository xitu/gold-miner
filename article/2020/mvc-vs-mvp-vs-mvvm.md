> * 原文地址：[MVC vs MVP vs MVVM](https://levelup.gitconnected.com/mvc-vs-mvp-vs-mvvm-35e0d4b933b4)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/mvc-vs-mvp-vs-mvvm.md](https://github.com/xitu/gold-miner/blob/master/article/2020/mvc-vs-mvp-vs-mvvm.md)
> * 译者：[snowyYU](https://github.com/snowyYU)
> * 校对者：[onlinelei](https://github.com/onlinelei)，[z0gSh1u](https://github.com/z0gSh1u)

# MVC，MVP，MVVM 对比 

![Photo by [Edwin Andrade](https://unsplash.com/@theunsteady5?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10098/0*zrwD7OZp_Lz0Trzm)

当下有很多种设计模式可供我们选择。 在分别使用 Model-View-ViewModel (MVVM)，Model-View-Presenter (MVP)，和 Model-View-Controller (MVC)，模式开发了一些 app 后，我觉得是时候聊聊它们间的区别了。为了方便理解，这里我们举一个例子：开发一个查找书籍的小功能，其实就是那些 **BookSearch** 应用中的搜索功能。

让我们开始吧

## MV(X) 基本概念

在深入研究 MVC，MVP 和 MVVM 架构之前，我们要简要的了解下它们。

#### 为什么会诞生 Model-View-(C or P or VM)?

最初这些架构的目的都是为了将带有图形界面的应用解构成各司其职的几块：视图，处理程序，数据管理。

![separate the responsibilities of visualizing, processing, and data management](https://cdn-images-1.medium.com/max/2730/1*EyHs4py3rl8WsAKhno-oSw.png)

现在有了更多的目标

* 模块化
* 灵活性
* 可测性
* 可维护性

## Model-View-Controller

简称 MVC，它是架构软件应用程序的一种广泛使用的设计模式。该模式最初是由 [Trygve Reenskaug](https://en.wikipedia.org/wiki/Trygve_Reenskaug) 在从事 Smalltalk-80（1979）的工作期间设计的，最初被称为 Model-View-Controller-Editor。1994 年在 [“设计模式 : 可复用面向对象软件的基础”](https://www.amazon.co.uk/Design-patterns-elements-reusable-object-oriented/dp/0201633612)（又名 “GoF”）一书中对 MVC 进行了更深入的描述，该书在推广其使用方面发挥了作用。 该模式将应用程序分为三个部分。

![](https://cdn-images-1.medium.com/max/2730/1*C6X8ZQf3grq0ifscFvMugw.png)

* **Model** —— 负责应用的业务逻辑。它管理着应用的状态。这还包括读取和写入数据，持久化应用程序状态，甚至可能包括与数据管理相关的任务，例如网络和数据验证。
* **View** —— 这部分有两个重要的任务：向用户展示数据和处理用户和应用的交互。
* **Controller** —— view 层和 model 层经由一个或多个 controller 绑定在一起。

![MVC on Android](https://cdn-images-1.medium.com/max/2730/1*KuqHoiiiIAU9olKqlkFujA.png)

## Model–View–Presenter

MVP 是 MVC 设计模式的衍生品，该模式专注于改进展示逻辑。它起源于 1990 年代初的一家名为 [Taligent](https://en.wikipedia.org/wiki/Taligent) 的公司，当时他们正在开发一个运行于 C ++ CommonPoint 环境的模型。

![](https://cdn-images-1.medium.com/max/2730/1*ru_qYzPdhTnOoFGOcU6qOA.png)

虽然 MVP 是 MVC 的衍生品，但它们也有细微的差别。

* **Model** —— model 代表一组描述业务逻辑和数据的类。它制定了更改和操作数据的规则。
* **View** —— view 负责与用户进行交互，就如下图中 XML、Activity、fragments 部分。它与流程中要实现的逻辑无关。
* **Presenter** —— presenter 从 View 获取输入，在 model 的帮助下处理数据，并在处理完成后将结果传递回 view。

![MVP on Android](https://cdn-images-1.medium.com/max/2730/1*naMJ_Kfe8sLShjoBwDfjzg.png)

## Model-View-ViewModel

MVVM 最初是由 Microsoft 提出的，用于 Windows Presentation Foundation（WPF）和 Silverlight，由 John Grossman 于 2005 年在有关 Avalon（WPF的代号）的博客文章中正式提出。这种基于 MVC 和 MVP 的模式致力于将应用中 UI 的开发与业务逻辑的开发分离。

![](https://cdn-images-1.medium.com/max/2730/1*j6dM1iDMAn3d94g4tvuLFg.png)

它由如下的三部分组成。

* **Model** —— MVVM 中的 model 层和 MVC 中的 model 层非常相似，包含了供应用正常运转所需的基本数据。
* **View** —— view 层是用户和设计模式之间的图形界面，类似于 MVC 中的 view 层。用来展示处理后的数据。
* **View-Model** —— view-model 既是视图层的抽象，又提供了要访问的模型数据的包装。 也就是说，它包含一个可以被转换为视图的模型，并且还包含了一些命令，视图层可以使用这些命令更改模型。

![MVVM on Android](https://cdn-images-1.medium.com/max/2730/1*XRtDb_FlcGjwvXjLqra94w.png)

## MVC vs MVP vs MVVM

让我们来看下 MVC、MVP 和 MVVM 间的主要区别。

![](https://cdn-images-1.medium.com/max/2730/1*sIwF6PKHDQl59SdKOYbsPA.jpeg)

**性能上的评估** —— 当我们测试 UI 的性能时，就渲染帧而言，可以认为 MVP 是其中可靠性最高，阻塞最小的了。MVVM 中的数据绑定会产生额外的过载，很可能导致在执行复杂任务时性能严重下降。

**兼容性** —— 当测试它们的兼容性时，MVVM 是其中最好的，这得益于它的数据绑定。MVP 的表现要好于 MVC，后者存在严重的重启问题。

**拓展性** —— 说起设计模式，它们必须要有一定的拓展性，因此我们才可以在应用中不断添加新的功能和策略。

* 由以上几点得知，MVP 和 MVVM 的区别较小，不过 MVVM 的可维护性略胜一筹。
* 多数情况下，每次后续的拓展，采用 MVC 模式的应用需要改动更多的地方。

**引用** —— 在 MVC 中，view 未直接引用 controller，而在 MVP 中，视图引用了 presenter，在 MVVM 中，view 引用了 view-model。

**应用入口** —— 对于 MVC，应用程序的入口是 controller，而对于 MVP 和 MVVM，入口是 view。

## 使用不同的架构来完成上文的示例

尝试使用如下的架构之一开发 BookSearch 应用，这有助于你对上文的理解。

![MVC vs MVP vs MVVM implementation for the BookSearch application](https://cdn-images-1.medium.com/max/2730/1*if_3uYnoFmxfWXkKYpDNqw.png)

很简单吧？你现在可以自个儿尝试实现一下。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
