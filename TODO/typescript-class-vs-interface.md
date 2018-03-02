> * 原文地址：[Typescript : class vs interface](https://medium.com/front-end-hacking/typescript-class-vs-interface-99c0ae1c2136)
> * 原文作者：[Valentin PARSY](https://medium.com/@parsyval?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/typescript-class-vs-interface.md](https://github.com/xitu/gold-miner/blob/master/TODO/typescript-class-vs-interface.md)
> * 译者：
> * 校对者：

# Typescript : class vs interface

![](https://cdn-images-1.medium.com/max/800/1*TP-D_umXHGfSyJbUrSQ24g.jpeg)

Interface and class have a different definition weither you’re talking about Java or Typescript.

I want to adress a problem I’ve seen one too many time today. In a typescript code here is what I’ve found :

```
class MyClass {
  a: number;
  b: string;
}
```

NO ! Just no. It hurts. But what trully hurts is to then read :

```
class MyOtherClass extends MyClass {
  c: number;
}
```

Argh ! I know it can be confusing for people coming from an OOP language, but in Javascript an object IS NOT an instance of a class. I’ve worked with C++ for about ten years, so I understand it feels right when doing

```
let mine = new MyClass();
```

you get an ‘_object_’. But when thinking that you forget that Javascript is not a ‘class based’ language, it uses a prototypal approach. (read the article below or any other explaining this to get the grasp of how all that works).

- [**A Plain English Guide to JavaScript Prototypes - Sebastian's Blog**(http://sporto.github.io/blog/2013/02/22/a-plain-english-guide-to-javascript-prototypes/)

* * *

### Interface

> One of TypeScript’s core principles is that type-checking focuses on the _shape_ that values have.

Interfaces are contracts. An interface defines what’s inside an object (again … not an instance of a class). When you define your interface

```
interface MyInterface{
  a: number;
  b: string;
}
```

You’re saying that any object given this contract must be an object containing 2 properties (no more, no less) which are specifically called ‘a’ and ‘b’ and are respectively a number and a string.
What happens is that typescript will then throw an error anytime you don’t respect this contract (for example if a parameter to a function is supposed to be a MyInterface, you can’t pass anything else).

### Class

Let’s look at the definition’s first lines of a class according to the TS doc :

> Traditional JavaScript uses functions and prototype-based inheritance to build up reusable components, but this may feel a bit awkward to programmers more comfortable with an object-oriented approach, where classes inherit functionality and objects are built from these classes.

The **first line** of the definition of a class in TS is “prototype-based inheritance is confusing for programmers coming from OOP world”. I then go as far as thinking “this is the main reason classes exist in TS” (but that’s maybe only me).
As you know Typescript is translated to Javascript, which also uses a ‘class’ keyword since very recently.
Let’s see the MDN doc about classes in Javascript :

> JavaScript classes, introduced in ECMAScript 2015, are primarily **syntactical sugar** over JavaScript’s existing prototype-based inheritance. The class syntax **does not** introduce a new object-oriented inheritance model to JavaScript.

You can’t be clearer about classes in JS (and by extension, in TS).

### Interface vs class

When you are defining a contract, you want to use an interface. That’s it, no arguing about that … but then, when to use a class ?
John Papa has got his definition in this article :

- [**TypeScript Classes and Interfaces - Part 3**(https://johnpapa.net/typescriptpost3/)

*   Creating multiple new instances
*   Using inheritance
*   Singleton objects

One can agree or disagree, but like he says : “classes are nice but they are not necessary in Javascript”. I would say, since they are here and make life easier for a lot of people, you can use them for whatever reason you want, as long as you keep in mind it’s still JS and prototypes.

But then why the aggressive intro ?

### Why using class to define a contract hurts

There is an awesome tool on the Typescript website called “Playground”

- [**Playground · TypeScript**](https://www.typescriptlang.org/play/)

You write typescript code on the left and it shows you the javascript it will be transformed into on the right.
Let’s try with two classes, with one inheriting from the previous one :

![](https://cdn-images-1.medium.com/max/1000/1*rHfgm0K-kDPc1fKFSCrnYA.jpeg)

Well, that’s a lot of JS code !

Now what about the same contract but with interfaces :

![](https://cdn-images-1.medium.com/max/1000/1*ZAXtcsFvS6dMj1aCS0sgDg.jpeg)

Nothing ! Since TS uses interfaces just to see if you respect the contracts “at compile time”, it doesn’t translate into anything in JS (in opposite to classes).
So when I see a class defining a contract, I actually see the first image in my head … and that hurts.
By the way, a file with only interfaces in it is an empty file at the end of the day …


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
