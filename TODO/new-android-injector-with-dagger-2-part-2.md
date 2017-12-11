> * 原文地址：[New Android Injector with Dagger 2 — part 2](https://medium.com/@iammert/new-android-injector-with-dagger-2-part-2-4af05fd783d0)
> * 原文作者：[Mert Şimşek](https://medium.com/@iammert?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md)
> * 译者：
> * 校对者：

# New Android Injector with Dagger 2 — part 2

![](https://cdn-images-1.medium.com/max/2000/1*mUOY8duji6LKT9dKFpDvoA.jpeg)

- [New Android Injector with Dagger 2 — part 1](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md)
- [New Android Injector with Dagger 2 — part 2](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md)

I tried to explain dagger-android injection in my previous blogpost. I got some review and people say that it is too complicated and no reason to upgrade to new injection way. I knew it would happen but wanted to explain how it actually works behind the scene. Before you read this part 2 I strongly recommend start with part 1\. This part will simplify dagger injection using brand new annotation. **_@ContributesAndroidInjector_** .



Lets remember our dagger graph with a visual graphic.

![](https://cdn-images-1.medium.com/max/1000/1*RbT9g29U6QErwWktV6089Q.png)

Let’s examine this graph step by step. I will do that for only MainActivity. We can do the rest If we understand the logic.

* Create an _AppComponent_ and _AppModule_.
* Create _MainActivity_, _MainActivityComponent_, _MainActivityModule_
* Map _MainActivity_ to _ActivityBuilder_(So dagger can understand MainActivity will be injected.)

Here we go. We call **_AndroidInjection.inject(this)_** in _MainActivity_ and provide whatever instance we want in _MainActivityModule_.

We just want to inject into MainActivity but we have to do a lot. It can be simplified. How? Let’s check the graph again.

* UI subcomponents(MainActivityComponent and DetailActivityComponent) are just like bridge in the graph. We don’t even have to use our brain to create this class.
* Whenever we add our UI component as new subcomponent, we have to map our activity in ActivityBuilder module. This is also repetitive task.

### Don’t Repeat Yourself

Authors of dagger realised that problem and brought new solution to this problem. New annotation. **@ContributesAndroidInjector .** With this annotation, we can easily attach activities/fragments to dagger graph. Before I give you simplified code I wanted to show you simplified dagger graph.

![](https://cdn-images-1.medium.com/max/1000/1*KqjANMe67JfzRNp0-QQIEw.png)

I think it is much more understandable. I simplified my repo with @ContributesAndroidInjector in new branch. [You can check my commit](https://github.com/iammert/dagger-android-injection/commit/5cf00f738751939b0d222e5da55e7f4384fa5798).

You can also check my simplified android injection branch [from here](https://github.com/iammert/dagger-android-injection/tree/dagger-simplified-with-contributes).

#### Simplified branch

[**iammert/dagger-android-injection**
_dagger-android-injection - Sample project explains Dependency Injection in Android using dagger-android framework._github.com](https://github.com/iammert/dagger-android-injection/tree/dagger-simplified-with-contributes)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
