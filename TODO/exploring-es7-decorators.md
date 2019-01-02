> * 原文地址：[Exploring EcmaScript Decorators](https://medium.com/google-developers/exploring-es7-decorators-76ecb65fb841)
> * 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/exploring-es7-decorators.md](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-es7-decorators.md)
> * 译者：[miaoyu](https://juejin.im/user/57df39fca0bb9f0058a3c63d/posts)
> * 校对者：[ZhiyuanSun](https://github.com/zhiyuansun) [ryouaki](https://github.com/ryouaki)

# 探索 ECMAScript 装饰器

![](https://cdn-images-1.medium.com/max/800/1*Ifm00n-npUdYWTDbZag3rQ.png)

[迭代器（Iterators）](http://jakearchibald.com/2014/iterators-gonna-iterate/), [生成器（generators）](http://www.2ality.com/2015/03/es6-generators.html) 和 [数组简约式（array comprehensions）](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Array_comprehensions)；随着时间的推移，JavaScript 和 Python 越来越像，如今我已经见怪不怪了。今天我们就来讨论一个类似 Python 语法的 ECMAScript 提议：[装饰器](https://github.com/wycats/javascript-decorators)，该提案来自 Yehuda Katz。

**更新 07/29/2015: 装饰器提议已经提交到TC39。最新进展你可在 [提议](https://github.com/tc39/proposal-decorators) 仓库找到。现在又出了几个 [新的例子](http://tc39.github.io/proposal-decorators/)。**
（译注：TC39 全称 TC39 ECMA 技术委员会，受特许解决JavaScript语言相关事宜。）

### 装饰器模式

到底什么是装饰器？在 Python中，装饰器提供了一个非常简单的语法，用于调用[高阶](https://en.wikipedia.org/wiki/Higher-order_function)函数。一个 Python 装饰器就是一个函数，它包装另外一个函数来拓展功能，而不需要做显式的修改。[最简单](http://www.saltycrane.com/blog/2010/03/simple-python-decorator-examples/)的 Python 装饰器看起来是这样的：

![](https://cdn-images-1.medium.com/max/400/1*Np2xWAiiQmq9LfwOquDOuQ.png)

代码顶部（`@mydecorator`）就是一个装饰器，它看起来和 ES2016（ES7）没有什么区别，所以你一定分清楚！:)。

_`@`_ 向编译器表明，我们正在使用装饰器，_mydecorator_ 指向一个同名的函数。我们的装饰器接受一个参数（被装饰的函数），拓展功能后，返回一个与参数同名的函数。

装饰器帮助你添加任何你想拓展的功能，比如 memoization（译者注：一种将函数返回值缓存起来的方法），强制访问控制，身份验证，插桩，时间函数，日志，比率限制，等等。

### 在 ES5 和 ES2015（即ES6） 中的装饰器

在 ES5 中，实现命令式装饰器（作为纯函数）是相当麻烦的。在 ES2015（即ES6）中，当类支持扩展，我们有多个类需要共享一个功能时，我们就需要更好的方法；或者说需要更好的分配方法。

Yehuda 的装饰器建议寻求在设计时对 JavaScript 类、属性和对象字面量进行注释和修改，同时保持声明式语法。

让我们来看一些 ES2016 装饰器吧！

### ES2016 装饰器

想想我们在 Python 中学到的知识。一个 ES2016 装饰器是一个表达式，它返回一个函数以及接收一个目标体，名称，属性描述符来作为参数。通过在装饰器前面加一个 `@` 符号，然后放到被装饰者的最上面来使用装饰器。装饰器可以被定义为类或者属性。

#### 装饰一个属性

我们来看一个基础的 Cat 类：

![](https://cdn-images-1.medium.com/max/800/1*vgZrCKk9PtyCAkUQdJC1Dg.png)

编译这个类的结果就是将 meow 函数加载到 `Cat.prototype`，大致如下：

![](https://cdn-images-1.medium.com/max/800/1*rsumqLVuE3FaFZy5mKBZSg.png)

设想一下，我们希望标记一个属性或者方法名不能被编辑。装饰器优先级高于定义属性的语法，因此我们可以定义一个 `@readonly` 装饰器，如下：

![](https://cdn-images-1.medium.com/max/800/1*1rWYZ3XAjD-6Eu1Y_7x8QA.png)

我们就可以这样来定义 meow 属性了，如下：

![](https://cdn-images-1.medium.com/max/800/1*KDIo38_mEWYLS-s2kvsIiw.png)

装饰器就是一个表达式，它会被执行然后返回一个函数。这就是为什么 `@readonly` 和 `@something(parameter)` 都能工作。

在 描述符（descriptor）加载进 Cat.prototype 之前，JavaScript引擎会先调用装饰器：

![](https://cdn-images-1.medium.com/max/800/1*hSy8oLzgqEHKOOnX8dzdRg.png)

现在 meow 变成了只读，我们可以来验证一下：

![](https://cdn-images-1.medium.com/max/800/1*Mv24M1ipQtk-HqX3pRr9Hw.png)

不仅仅是属性，接下来我们来探讨装饰器类，在此之前我们先来看第三方库，尽管都很年轻，装饰器库从2016年开始陆续出现，包括由 Jay Phelps 开发的 [decorators.js](https://github.com/jayphelps/core-decorators.js)。

和我们上面实现的 readonly 一样，decorators.js 包含了 `@readonly` ， 只需要导入就行了：

![](https://cdn-images-1.medium.com/max/800/1*FJIBx1JqlHmMlRPNVa5glQ.png)

它还包含其他的装饰器，比如 `@deprecate` ，主要是用于，当你的API需要提示方法可能会改变：

> **调用 console.warn() 打印描述信息。也可以自定义描述信息，也可以在描述信息中添加链接，以便进一步阅读。**

![](https://cdn-images-1.medium.com/max/800/1*RZcsUApI6TGaIPnD9syfFw.png)

#### 装饰一个类

接下来我们来看看装饰类。根据提议规范，一个装饰器接收构造函数作为参数。假设有一个 `MySuperHero` 类，我们可以定义一个简单的装饰器 `@superhero`来装饰它：

![](https://cdn-images-1.medium.com/max/800/1*wRKeM_ZJmeqZoD-2sXrvlQ.png)

这可以进一步拓展，通过提供参数使我们可以让装饰器定义成工厂函数：

![](https://cdn-images-1.medium.com/max/800/1*HAL1EWF3ekb1nJBskLKRyg.png)

ES2016 装饰器作用于描述符和类。它们会自动接收被传递的属性名和目标对象，我们很快会讲到。通过对描述符的访问，装饰器可以做到更改属性使其使用 getter，或开启一些原本非常繁琐的操作，比如在第一次访问属性时自动绑定方法到当前实例。

#### ES2016 装饰器 和 Mixins 模式

我拜读了 Reg Braithwaite 最近的文章 [ES2016 Decorators as mixins](http://raganwald.com/2015/06/26/decorators-in-es7.html) 和之前的一篇 [Functional Mixins](http://raganwald.com/2015/06/17/functional-mixins.html)。Reg 提出使用一个 helper 将不同行为混入任意一个目标（类原型或者 standalone），并表述为一个类专属的版本。这种功能性的混入会把实例行为混入类原型，使其看起来像这样：

![](https://cdn-images-1.medium.com/max/800/1*bB77ghg773qnwCA1aeKPBg.png)

好了，我们现在可以定义一些 mixins ，然后尝试用它们装饰一个类。假设我们有一个简单的 `ComicBookCharacter` 类：

![](https://cdn-images-1.medium.com/max/800/1*1YMyHF0gp8F4mVRBtloJ-A.png)

`ComicBookCharacter ` 可能是世界上最无聊的角色了，但是我们可以定义一些 mixins，为它提供超能力（`SuperPowers`）和 装备（`UtilityBelt`），让我们用 Reg 的 mixin helper 来实现吧：

![](https://cdn-images-1.medium.com/max/800/1*2a3HCBjjQSPZcoER0rSFsg.png)

现在我们就可以通过在 mix 函数前面加 `@` 的语法，根据我们想要的属性来装饰 `ComicBookCharacter`。注意我们是如何在类上面加多个装饰器语句的：

![](https://cdn-images-1.medium.com/max/800/1*jbX4pzw31FBNp-2QgnfCew.png)

现在我们可以塑造一个蝙蝠侠角色了。

![](https://cdn-images-1.medium.com/max/800/1*_4pUUwbwlqTdBTxV-X111g.png)

这些类的装饰器相对紧凑，我可以将它们用作函数调用的替代方法，或者作为高阶组件的助手。

**注: @WebReflection 有一些替代方案，用于本节中使用的mixin模式，您可以点击 [了解更多](https://gist.github.com/addyosmani/a0ccf60eae4d8e5290a0#comment-1489585)。**

### 通过 Babel 使用装饰器

装饰器（在我写本文的时候）仍然还是一个提案。他们还没有通过。感谢 Babel 支持在实验模式使用装饰器语法，所以本文的大部分例子都可以直接使用。

如果你使用 Babel CLI，你可以出入如下参数：

```
$ babel --optional es7.decorators
```

或者直接调用 transformer：

![](https://cdn-images-1.medium.com/max/800/1*9dlzSG1EqMCpH-dk1RZ5xg.png)

这里有一个 [Babel 在线的 REPL](https://babeljs.io/repl/)；复选框选中“Experimental”就可以使用装饰器了。

### 有趣的实验

我很幸运坐在 Paul Lewis 的旁边，他在[尝试用装饰器](https://github.com/GoogleChrome/samples/tree/gh-pages/decorators-es7/read-write)重新调度读写 DOM 的代码。它借鉴了 Wilson Page 的 FastDOM，但是提供了更精简的API。Paul 的 read/write 装饰器可以通过 `console` 来提醒你，如果你在改变布局时使用 @write 后调用方法或者属性（或者使用 @read 后改变DOM）。

下面是 Paul 的一个实验例子，在使用 @read 后尝试改变 DOM，会在 `console` 中打印异常：

![](https://cdn-images-1.medium.com/max/800/1*A3gYGXlTPdXGtCkfgK_NRA.png)

### 现在就去试试装饰器吧！

在短时间来看，ES2016装饰器对于声明式装饰和注释，类型检查和在 ES2015 类中应用装饰器都是大有裨益的，从长远来看，他们可以提供非常有用的静态分析工具（编译时类型检查和自动补全）。

他们和经典面向对象语言（OOP）中的装饰器没有区别，允许一个对象可以被行为装饰，不管是动态的还是静态的都不会影响到来自同一个类的对象。装饰器的提案还一直在变化中，让我们持续关注 Yehuda 的提案吧。

第三方库的作者正在讨论，装饰器可能会替换 mixins，以及他们可以应用到 [React](https://github.com/timbur/react-mixin-decorator) 的高阶组件中。

我个人很希望看到关于装饰器越来越多的尝试，你可以在 Babel 上尝试，识别出可复用的装饰器，也许你也可以像 Paul 那样分享你的作品 :)

### 了解更多以及参考

* [https://github.com/wycats/javascript-decorators](https://github.com/wycats/javascript-decorators)
* [https://github.com/jayphelps/core-decorators.js](https://github.com/jayphelps/core-decorators.js)
* [http://blog.developsuperpowers.com/eli5-ecmascript-7-decorators/](http://blog.developsuperpowers.com/eli5-ecmascript-7-decorators/)
* [http://elmasse.github.io/js/decorators-bindings-es7.html](http://elmasse.github.io/js/decorators-bindings-es7.html)
* [http://raganwald.com/2015/06/26/decorators-in-es7.html](http://raganwald.com/2015/06/26/decorators-in-es7.html)
* [Jay’s function expression ES2016 Decorators example](https://babeljs.io/repl/#?experimental=true&evaluate=true&loose=false&spec=false&playground=true&code=class%20Foo%20%7B%0A%20%20%40function%20%28target%2C%20key%2C%20descriptor%29%20%7B%20%20%20%0A%20%20%20%20descriptor.writable%20%3D%20false%3B%20%0A%20%20%20%20return%20descriptor%3B%20%0A%20%20%7D%0A%20%20bar%28%29%20%7B%0A%20%20%20%20%0A%20%20%7D%0A%7D&stage=0)

感谢 [Jay Phelps](http://twitter.com/jayphelps)，[Sebastian McKenzie](http://twitter.com/sebmck)，[Paul Lewis](http://twitter.com/aerotwist) 和 [Surma](http://twitter.com/surmair) 对本文的审校以及提供的详细反馈❤


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
