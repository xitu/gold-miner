> * 原文地址：[Typescript : class vs interface](https://medium.com/front-end-hacking/typescript-class-vs-interface-99c0ae1c2136)
> * 原文作者：[Valentin PARSY](https://medium.com/@parsyval?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/typescript-class-vs-interface.md](https://github.com/xitu/gold-miner/blob/master/TODO/typescript-class-vs-interface.md)
> * 译者：[xueshuai](https://github.com/xueshuai)
> * 校对者：[Starriers](https://github.com/Starriers), [rpgmakervx](https://github.com/rpgmakervx)

# Typescript: 类 vs 接口

![](https://cdn-images-1.medium.com/max/800/1*TP-D_umXHGfSyJbUrSQ24g.jpeg)

无论是在 Java 或 Typescript 中，接口和类的定义是不同的。

我想指出一个我今天看到了很多次的错误。在这段 Typescript 的代码中我发现：

```
class MyClass {
  a: number;
  b: string;
}
```

不！绝对不对。太让人难受了。但是真正让人难受的是接下来读到的：

```
class MyOtherClass extends MyClass {
  c: number;
}
```

哎呀呀！我知道这可能对来自一种 OOP 语言的人有一些困惑，但是在 Javascript 中，一个对象不是一个类的实例。我已经写 C++ 快10年了，所以我理解当我们这样做时是对的：

```
let mine = new MyClass();
```
你生成了一个‘_object_’。但是你别忘了 Javascript 不是一个基于类的语言，他用的是原型方法（阅读下面的文章或者其他的解释这个的东西来掌握所有的这些是怎么回事）。

- [**关于 Javascript 原型的简单英文指南 - Sebastian的博客**(http://sporto.github.io/blog/2013/02/22/a-plain-english-guide-to-javascript-prototypes/)

* * *

### 接口

> Typescript 的一个核心原则是类型检查，它关注的是值所拥有的_shape_。

接口就是约定。一个接口定义了一个对象里面拥有的东西（再一次强调...不是一个类的实例）。当你定义你的接口：

```
interface MyInterface{
  a: number;
  b: string;
}
```

你的意思是任何继承了这个约定的对象一定是一个拥有这两个（不会多，也不会少）特别的被称为‘a’和‘b’的属性，他们分别是数字型和字符串型。当你不遵守这个约定的时候，Typescript 将会抛出一个错误（例如，如果函数的参数符合 MyInterface，你不能传递任何别的参数）。

### 类

让我们来看一看 Typescript 文档中关于类的定义的第一行：

> 传统的 Javascript 使用函数和基于原型的继承来构造可服用的组件，但是这会让那些对面向对象方法更舒服的程序员感到一些尴尬，在面向对象方法中，类继承了功能，而对象是通过类来构造的。

在 Typescript 中关于类的**第一行**的定义是“来自 OOP 世界的程序员对基于原型的继承会感到困惑”。于是我尽可能的想“这就是 Typescript 中存在类的主要原因”（但那可能只是我这么认为）。

> Javascript 的类，在 ECMAScript 2015的介绍中，主要是 Javascript 基于原型继承的语法糖。类的语法没有想 Javascript 中引入一个新的面向对象的继承模型。

你不能对 Javascript 中的类更清楚了（扩展一下，在 Typescript中也是一样）

### 接口 vs 类

当你定义一个约定，你是想使用一个接口。一定是的，不可辩驳……但是，当你想使用一个类的时候呢？

John Papa 已经在他的文章中指出了他的定义：

- [**TypeScript 的类和接口 - 第3部分**(https://johnpapa.net/typescriptpost3/)

*  创建多个实例
*  使用继承
*  单例对象

不管同意或者不同意，但正如他所说的：“类很好，但是在 Javascript 中它们不是必须的”。我想说的是，既然它们已经存在而且让很多人的工作变得更轻松，那不管是什么原因，你都可以使用它们，只要你记住，它仍然是 Javascript 和原型。

但是为什么这么积极地介绍这些呢？

### 为什么使用类定义一个不好的约定呢？

在 Typescript 网站上有一个很棒的工具叫做“Playground”。

- [**Playground · TypeScript**](https://www.typescriptlang.org/play/)

你在左边写 Typescript 的代码，右边就会显示经过转换的 Javascript 代码。

![](https://cdn-images-1.medium.com/max/1000/1*rHfgm0K-kDPc1fKFSCrnYA.jpeg)

好吧，那是很多的 Javascript 代码！

现在，如果我们用接口来定义相同的约定：

![](https://cdn-images-1.medium.com/max/1000/1*ZAXtcsFvS6dMj1aCS0sgDg.jpeg)

什么都没有！因为 Typescript 只是使用接口来检查你是否在编译阶段最瘦了约定，他不会转换为任何 Javascript 代码（和类相反）。所以当我看到一个类定义了约定，我实际上在我的脑海中看到了第一张图片，那很受伤。顺便说一句，一个只有接口的文件最终是一个空文件。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
