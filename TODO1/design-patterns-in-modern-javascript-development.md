> * 原文地址：[Design patterns in modern JavaScript development](https://levelup.gitconnected.com/design-patterns-in-modern-javascript-development-ec84d8be06ca)
> * 原文作者：[Kristian Poslek](https://medium.com/@bojzi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-in-modern-javascript-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-in-modern-javascript-development.md)
> * 译者：[Hyde Song](https://github.com/HydeSong)
> * 校对者：[xujiujiu](https://github.com/xujiujiu), [ezioyuan](https://github.com/ezioyuan)

# 现代 JavaScript 开发中的设计模式

> 关于软件项目设计中有效沟通的思考

![](https://cdn-images-1.medium.com/max/7296/1*nfNi7oUIZBakAdyXXcmirw.jpeg)

## 模式？设计？我们是在讨论软件开发么？

**当然是啦。**

就像面向对象编程一样，我们开发人员正试图为我们周围的世界建模。因此，尝试并使用我们周围的世界作为工具来描述我们的作品同样有意义。

在本例中，我们效仿建筑架构（有建筑和桥梁的）来举例。正如具有开创性的建筑架构书籍 **《建筑模型语言》**（**Christopher Alexander，Sara Ishikawa，Murray Silverstein 著**）中对“模式”所描述的那样：

> 每个模式都描述了我们环境中反复出现的问题，然后描述了该问题解决方案的核心，以这样的方式，你可以多次使用此解决方案，而不必以相同的方式重复使用两次。

在软件开发中，架构是以健康、健壮和可维护的方式构建应用程序的过程，模式提供了一种给常见问题解决方案命名的方法。这些解决方案可以是抽象的/概念性的，也可以是非常精确的和技术性的，并且允许开发人员有效地相互沟通。

![高效](https://cdn-images-1.medium.com/max/8000/1*pdCoxUhmMHI5tBnGVdnNJQ.jpeg)

如果团队中有两个或更多的开发人员了解模式，那么讨论问题的解决方案就会变得非常高效。如果只有一个开发人员知道模式，那么向团队的其他成员解释它们通常也很容易。

**本文的目标是通过向你介绍软件设计模式的概念，并介绍一些有趣的模式，以激发你对某种形式的软件开发知识的兴趣，因为它们在现代 JavaScript 项目中得到了广泛的应用。**

## 单例模式

### 概念

单例模式并不是最广泛使用的模式之一，但是我们从它开始是因为它相对容易掌握。

单例模式源于单例的数学概念，即：

> 在数学中，**单例**，也称为**单元集合**，是一个只有一个元素的集合。例如，集合 {null} 是一个单例。

在软件中，它只是意味着我们将类的实例化限制为一个对象。第一次实现单例模式的类的对象应该被实例化，实际上它也将被实例化。任何后续尝试都会返回第一个实例。

![蝙蝠侠来了，谁还需要两个超级英雄？](https://cdn-images-1.medium.com/max/5652/1*JsnR25Uewd4wZLzZ-a9frg.png)

### 为什么

除了我们只能有一个超级英雄（显然是蝙蝠侠）的原因外，我们为什么要使用单例模式呢？

尽管单例模式并非没有问题（它以前被认为是有害的，因为单例模式 [被称为病态说谎者](http://misko.hevery.com/2008/08/17/singletons-are-pathological-liars/)），但它仍然有它的用途。最值得注意的是实例化配置对象。你可能只想要应用程序的一个配置实例，除非应用程序的一个特性提供了多个配置。

### 用在哪里

Angular 的服务是大型流行框架中使用单例模式的一个主要例子。在 Angular 的文档中有一个 [专用页面](https://angular.io/guide/singleton-services) 解释了如何确保服务总是作为单例提供。

服务是单例的非常有意义，因为服务被用作存储状态、配置和允许组件之间通信的地方，你希望确保不会有多个实例混淆这些概念。

例如，假设你有一个简单的应用程序，它用于计算按钮被单击的次数。

![](https://cdn-images-1.medium.com/max/4566/1*PZpt4afyPY10CnuRADJx5w.png)

你应跟踪在一个对象内按下的按钮次数，该对象提供：

* 计数功能
* 并提供当前的单击次数。

如果该对象不是单例对象（按钮将各自获得自己的实例），那么单击计数就不正确。此外，你将向显示当前计数的组件提供哪些计数实例？

## 观察者模式

### 概念

观察者模式定义如下：

> **观察者模式**是一种软件设计模式，其中一个对象（称为**主题**）维护它的依赖项列表（称为**观察者**），并自动通知它们任何状态更改，通常通过调用它们的方法之一。

如果我们试着将观察者模式与现实世界中的一个例子 —— 报纸订阅 —— 进行比较，就会非常容易理解观察者模式。

当你买报纸的时候，通常的情况是你走到报摊，问你最喜欢的报纸的新一期是否已经出版了。如果不是这样，你就得走回家，然后再试一次，这是一件效率低下的可悲事情。在 JavaScript 术语中，这与循环相同，直到得到所需的结果。当你最终拿到报纸的时候，你可以做你想做的事情 —— 坐下来喝杯咖啡，享受你的报纸（或者，对 JavaScript 术语来说，执行你一直想做的回调函数）。

![最后](https://cdn-images-1.medium.com/max/12000/1*arrsn5kxG1GRbVpn7tlZkw.jpeg)

明智的做法是（每天获得你喜爱的报纸）订阅这份报纸。这样，出版公司就会让你知道新一期的报纸什么时候出版，然后把它寄给你。不再跑去报摊。不再失望。真开心。在 JavaScript 术语中，只有在运行函数之后，才会循环并请求结果。相反，你应该让主题知道你对事件（消息）感兴趣，并提供一个回调函数，应该在新数据准备好时调用该函数。那么，你就是观察者。

![再也不要错过你的晨报了。](https://cdn-images-1.medium.com/max/4002/1*Umz-GYQk5skILT07e0Kr4A.png)

这样的好处是 —— 你不必是唯一的订阅者。你会因为错过报纸而失望，其他人也会。这就是为什么多个观察者可以订阅主题。

### 为什么

观察者模式有很多用例，但是通常，当你想要在对象之间创建一对多的依赖关系时，应该使用它，这种依赖关系不是紧密耦合的，并且有可能让数量不限的对象知道状态何时发生了变化。

JavaScript 环境是实现观察者模式的好地方，因为一切都是由事件驱动的，而不是总是询问是否发生了事件，你应该让事件通知你（就像老话说的那样“**不要给我们打电话，我们会给你打电话**”）。很可能你已经完成了类似于观察者模式的操作 —— `addEventListener`。向具有观察者模式的所有标记元素添加事件监听器：

* 你可以订阅这个对象，
* 你可以取消订阅对象，
* 并且该对象可以向其所有订阅者广播事件。

学习观察者模式的最大好处是，你可以实现自己的主题，或者更快地掌握现有的解决方案。

### 用在哪里

实现一个基本的可观察对象应该不会太难，但是有一个很棒的库被许多项目使用，[ReactiveX](http://reactivex.io/)（它是 [RxJS](https://github.com/ReactiveX/rxjs) 对应的 JavaScript 库）。

RxJS 不仅允许你订阅主题，而且还允许你以可以想象的任何方式转换数据，组合多个订阅，使异步工作更易于管理，而且要多得多。如果你曾经想将数据处理和转换级别提升到更高的级别，那么 RxJS 将是一个非常值得学习的库。

除了观察者模式之外，ReactiveX 还以实现了迭代器模式而自豪，该模式使主题能够让其订阅者知道订阅何时结束，从而有效地从主题的角度结束订阅。在本文中，我不打算解释迭代器模式，但是对于你来说，了解它并知道它如何适应可观察的模式将是一个很好的练习。

## 外观模式

### 概念

外观模式的名称来源于建筑学。在建筑学中：

> **外观**通常是指建筑物的一面，通常是正面。这是一个来自法语的外来词，意思是"正面"或"脸"。

正如和建筑的正面作为建筑物的外观隐藏其内部运作一样，外观模式在软件开发中也试图隐藏背后的潜在复杂性，从而允许你有效地使用更容易掌握的 API，同时提供更改底层代码的可能性。

### 为什么

你可以在许多情况下使用外观模式，但最值得注意的是使代码更容易理解（隐藏复杂性），并使依赖关系尽可能松散耦合。

![Fus Ro Dah!](https://cdn-images-1.medium.com/max/3708/1*Unh3rSLKfaMzs3gweZF7UQ.png)

很容易看出为什么外观模式的对象（或包含多个对象的层）是一件很棒的事情。如果可以避免的话，你肯定不想和龙打交道。观察者模式对象将为你提供一个很好的 API，并处理所有龙的诡计本身。

我们在这里可以做的另一件很棒的事情是在不接触应用程序其余部分的情况下将龙从后台中去掉。假设你想把那条龙和一只小猫换掉。它仍然有爪子，但更容易喂养。更改它是在不更改任何依赖对象的情况下在外观中重写代码的问题。

### 用在哪里

你经常可以看到外观模式的地方是 Angular，它使用其服务作为简化背后潜在逻辑的一种方法。但是并不只 Angular 里有，在下一个例子中你会看到。

假设你想要将状态管理添加到应用程序中。你可以选择 Redux、NgRx、Akita、MobX、Apollo 或者任何一个新成员，在这个代码块里到处出现。那么，为什么不把它们都挑出来，带着它们去兜一圈呢？

状态管理库将为你提供哪些基本功能？

可能是：

* 一种让状态管理器知道你想要更改状态的方法
* 以及获取当前（片）状态的方法。

听起来还不错。

现在，以你掌握的外观模式的能力，你可以为状态的每个部分编写外观，这将为你提供一个很好的 API —— 比如 `facade.startSpinner()`，`facade.stopSpinner()` 和 `facade.getSpinnerState()`。这些方法真的很容易理解。

在此之后，你可以处理外观并编写代码，那段代码将转换你的代码，以便与 Apollo 一起工作（使用 GraphQL 管理状态——现在非常流行）。你可能会注意到它根本不适合你的编码风格，或者必须编写单元测试的方式真的不是你喜欢的。没问题，编写一个新的外观来支持 MobX。

![也可能是龙……](https://cdn-images-1.medium.com/max/5376/1*O3pSZ9xOfBkk7lO0CtGCPA.png)

## 拓展

您可能已经注意到，我所讨论的设计模式没有代码和实现。这是因为每一种设计模式都至少可以成为一本书的一章。

既然我们在讨论书籍，那么深入研究一两种设计模式也无妨。

首先强烈推荐的书必须是[**《设计模式：可重用面向对象软件的元素》**](http://wiki.c2.com/?DesignPatternsBook)，作者是 **Erich Gamma**、**Richard Helm**、**Ralph Johnson** 和 **John Vlisside**，也称为**四人帮**。这本书价值连城，是**实际意义上**的软件设计模式圣经。

如果你想找一些更容易理解的东西，可以参考 **Bert Bates**、**Kathy Sierra**、**Eric Freeman** 和 **Elisabeth Robson** 的[《Head First 设计模式》](https://www.goodreads.com/book/show/58128.Head_First_Design_Patterns)。这是一本非常好的书，它试图通过视觉角度传达设计模式的概念。

**最后但同样重要的是，没有什么比搜索谷歌，阅读和尝试不同的方法更好的了。即使你最终从未使用过一种模式或技术，你也会学到一些东西，并以意想不到的方式成长。**

**插图中使用的对话气泡是由 [starline — www.freepik.com](https://www.freepik.com/free-photos-vectors/frame) 创作的。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
