> * 原文地址：[MVC vs MVP vs MVVM](https://levelup.gitconnected.com/mvc-vs-mvp-vs-mvvm-35e0d4b933b4)
> * 原文作者：[Trung Anh Dang](https://medium.com/@dangtrunganh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/mvc-vs-mvp-vs-mvvm.md](https://github.com/xitu/gold-miner/blob/master/article/2020/mvc-vs-mvp-vs-mvvm.md)
> * 译者：
> * 校对者：

# MVC vs MVP vs MVVM

![Photo by [Edwin Andrade](https://unsplash.com/@theunsteady5?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10098/0*zrwD7OZp_Lz0Trzm)

Nowadays we have many options when it comes to architecture design patterns. After developing many apps using Model-View-ViewModel (MVVM), Model-View-Presenter (MVP), and Model-View-Controller (MVC), I finally feel qualified to talk about the differences between them. For easier to understand, we can use a simple example like developing a screen to search books in the **BookSearch** App.

Let’s begin now…!

## MV(X) essentials

First of all, we need to understand briefly MVC, MVP, and MVVM architecture before dive into them.

#### Why Model-View-(C or P or VM)?

The aim of these architectures is to separate the responsibilities of visualizing, processing, and data management for UI applications.

![separate the responsibilities of visualizing, processing, and data management](https://cdn-images-1.medium.com/max/2730/1*EyHs4py3rl8WsAKhno-oSw.png)

Their goals are to increase.

* Modularity
* Flexibility
* Testability
* Maintainability

## Model-View-Controller

Or MVC for short is a widely used design pattern for architecting software apps. The pattern was originally designed by [Trygve Reenskaug](https://en.wikipedia.org/wiki/Trygve_Reenskaug) during his time working on Smalltalk-80 (1979) where it was initially called Model-View-Controller-Editor. MVC went on to be described in depth in [“Design Patterns: Elements of Reusable Object- Oriented Software”](https://www.amazon.co.uk/Design-patterns-elements-reusable-object-oriented/dp/0201633612) (The “GoF” book) in 1994, which played a role in popularizing its use. The pattern breaks an app up into three components.

![](https://cdn-images-1.medium.com/max/2730/1*C6X8ZQf3grq0ifscFvMugw.png)

* **Model** — is responsible for the business logic of the application. It manages the state of the application. This also includes reading and writing data, persisting application state, and it may even include tasks related to data management such as networking and data validation.
* **View** — this component has two important tasks: presenting data to the user and handling user interaction.
* **Controller** — the view layer and the model layer are glued together by one or more controllers.

![MVC on Android](https://cdn-images-1.medium.com/max/2730/1*KuqHoiiiIAU9olKqlkFujA.png)

## Model–View–Presenter

MVP is a derivative of the MVC design pattern which focuses on improving presentation logic. It originated at a company named [Taligent](http://Model-view-presenter (MVP) is a derivative of the MVC design pattern which focuses on improving presentation logic. It originated at a company named Taligent in the early 1990s while they were working on a model for a C++ CommonPoint environment.) in the early 1990s while they were working on a model for a C++ CommonPoint environment.

![](https://cdn-images-1.medium.com/max/2730/1*ru_qYzPdhTnOoFGOcU6qOA.png)

Although MVP is a derivation of MVC, they do have their slight differences.

* **Model** — The Model represents a set of classes that describes the business logic and data. It also defines business rules for data means how the data can be changed and manipulated.
* **View** — The View is used for making interactions with users like XML, Activity, fragments. It has got nothing to do with the logic that is to be implemented in the process.
* **Presenter** — The presenter gets the input from the View, processes the data with the help of the Model, and passes the results back to the View after the processing is done.

![MVP on Android](https://cdn-images-1.medium.com/max/2730/1*naMJ_Kfe8sLShjoBwDfjzg.png)

## Model-View-ViewModel

MVVM was originally defined by Microsoft for use with Windows Presentation Foundation (WPF) and Silverlight, having been officially announced in 2005 by John Grossman in a blog post about Avalon (the codename for WPF). This pattern based on MVC and MVP which attempts to more clearly separate the development of UI from that of the business logic and behavior in an application.

![](https://cdn-images-1.medium.com/max/2730/1*j6dM1iDMAn3d94g4tvuLFg.png)

It has three main components as follows.

* **Model** — the Model used in MVVM is similar to the model used in MVC, consisting of the basic data required to run the software.
* **View** — the View is a graphical interface between the user and the design pattern, similar to the one in MVC. It displays the output of the data processed.
* **View-Model** — the View-Model is on one side an abstraction of the View and, on the other, provides a wrapper of the Model data to be linked. That is, it comprises a Model that is converted to a View, and it also contains commands that the View can use to influence the Model.

![MVVM on Android](https://cdn-images-1.medium.com/max/2730/1*XRtDb_FlcGjwvXjLqra94w.png)

## MVC vs MVP vs MVVM

Let’s find out MVC Vs MVP Vs MVVM, main points of differences.

![](https://cdn-images-1.medium.com/max/2730/1*sIwF6PKHDQl59SdKOYbsPA.jpeg)

**Performance Evaluation** — When we are testing the UI performance, MVP turns out to be the one with the highest reliability and lowest hindrance when it comes to rendering frames. Data binding in MVVM creates an additional overload that could drastically affect its performance when performing complex tasks.

**Compatibility** — When testing the patterns based on their compatibility, MVVM was the best of the lot due to its data binding which had a positive impact. MVP fared better than MVC, which had serious restating issues.

**Modifiability** — When we talk about design patterns, it is evident that it should be modifiable since that gives us the option of adding new features and strategies into our app.

* Based on these factors, we observed that changes are very less in MVP and MVVM, with MVVM contributing a lot towards maintainability.
* MVC tends to increase the number of changes in the majority of the cases.

**References** — In MVC, the View doesn’t have reference to the Controller while in MVP, the View has reference to the presenter and in MVVM, the View has reference to the View-Model.

**Entry Point** — For MVC, the entry point to the application is the Controller whereas, for MVP and MVVM, the entry point is the View.

## Implement the example by various architectures

You can implement the BookSearch application to understand by using one of three architecture as the following diagram.

![MVC vs MVP vs MVVM implementation for the BookSearch application](https://cdn-images-1.medium.com/max/2730/1*if_3uYnoFmxfWXkKYpDNqw.png)

Easy, right? Can you implement it yourself?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
