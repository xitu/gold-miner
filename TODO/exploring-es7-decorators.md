> * 原文地址：[Exploring EcmaScript Decorators](https://medium.com/google-developers/exploring-es7-decorators-76ecb65fb841)
> * 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/exploring-es7-decorators.md](https://github.com/xitu/gold-miner/blob/master/TODO/exploring-es7-decorators.md)
> * 译者：
> * 校对者：

# Exploring EcmaScript Decorators

![](https://cdn-images-1.medium.com/max/800/1*Ifm00n-npUdYWTDbZag3rQ.png)

[Iterators](http://jakearchibald.com/2014/iterators-gonna-iterate/), [generators](http://www.2ality.com/2015/03/es6-generators.html) and [array comprehensions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Array_comprehensions); The similarities between JavaScript and Python continue to increase over time and I for one could not be more excited. Today we’re going to talk about the next Pythonic proposal for ECMAScript — [Decorators](https://github.com/wycats/javascript-decorators), by Yehuda Katz.

_Update 07/29: Decorators are advancing at TC39\. The latest work on them can be found in the_ [_proposals_](https://github.com/tc39/proposal-decorators) _repo. Several_ [_new examples_](http://tc39.github.io/proposal-decorators/) _are also now up._

### The Decorator Pattern

What the heck are decorators anyway? Well, in Python, decorators provide a very simple syntax for calling [higher-order](https://en.wikipedia.org/wiki/Higher-order_function) functions. A Python decorator is a function that takes another function, extending the behavior of the latter function without explicitly modifying it. The [simplest](http://www.saltycrane.com/blog/2010/03/simple-python-decorator-examples/) decorator in Python could look like this:

![](https://cdn-images-1.medium.com/max/400/1*Np2xWAiiQmq9LfwOquDOuQ.png)

That thing at the very top (`@mydecorator`) is a decorator and isn’t going to look that different in ES2016 (ES7), so pay attention! :).

_`@`_ indicates to the parser that we’re using a decorator while _mydecorator_ references a function by that name. Our decorator takes an argument (the function being decorated) and returns the same function with added functionality.

Decorators are helpful for anything you want to transparently wrap with extra functionality. These include memoization, enforcing access control and authentication, instrumentation and timing functions, logging, rate-limiting, and the list goes on.

### Decorators in ES5 and ES2015 (aka ES6)

In ES5, implementing imperative decorators (as pure functions) is quite trivial. In ES2015 (previously ES6), while classes support extension, we need something better when we have multiple classes that need to share a single piece of functionality; something with a better method of distribution.

Yehuda’s decorators proposal seeks to enable annotating and modifying JavaScript classes, properties and object literals at design time while keeping a syntax that’s declarative.

Let’s look at some ES2016 decorators in action!

### ES2016 Decorators in action

So remember what we learned from Python. An ES2016 decorator is an expression which returns function and can take a target, name and property descriptor as arguments. You apply it by prefixing the decorator with an `@` character and placing this at the very top of what you are trying to decorate. Decorators can be defined for either a class or property.

#### Decorating a property

Let’s take a look at a basic Cat class:

![](https://cdn-images-1.medium.com/max/800/1*vgZrCKk9PtyCAkUQdJC1Dg.png)

Evaluating this class results in installing the meow function onto `Cat.prototype`, roughly like this:

![](https://cdn-images-1.medium.com/max/800/1*rsumqLVuE3FaFZy5mKBZSg.png)

Imagine we want to mark a property or method name as not being writable. A decorator precedes the syntax that defines a property. We could thus define a `@readonly` decorator for it as follows:

![](https://cdn-images-1.medium.com/max/800/1*1rWYZ3XAjD-6Eu1Y_7x8QA.png)

and add it to our meow property as follows:

![](https://cdn-images-1.medium.com/max/800/1*KDIo38_mEWYLS-s2kvsIiw.png)

A decorator is just an expression that will be evaluated and has to return a function. This is why `@readonly` and `@something(parameter)` can both work.

Now, before installing the descriptor onto `Cat.prototype`, the engine first invokes the decorator:

![](https://cdn-images-1.medium.com/max/800/1*hSy8oLzgqEHKOOnX8dzdRg.png)

Effectively, this results in meow now being read only. We can verify this behaviour as follows:

![](https://cdn-images-1.medium.com/max/800/1*Mv24M1ipQtk-HqX3pRr9Hw.png)

Bees-knees, right? We’re going to look at decorating classes (rather than just properties) in just a minute, but let’s talk about libraries for a sec. Despite its youth, libraries of 2016 decorators are already beginning to appear including [https://github.com/jayphelps/core-decorators.js](https://github.com/jayphelps/core-decorators.js) by Jay Phelps.

Similar to our attempt at readonly props above, it includes its own implementation for `@readonly`, just an import away:

![](https://cdn-images-1.medium.com/max/800/1*FJIBx1JqlHmMlRPNVa5glQ.png)

It also includes other decorator utilities such as `@deprecate`, for those times when an API requires hints that methods are likely to change:

> _Calls console.warn() with a deprecation message. Provide a custom message to override the default one. You can also provide an options hash with a url, for further reading._

![](https://cdn-images-1.medium.com/max/800/1*RZcsUApI6TGaIPnD9syfFw.png)

#### Decorating a class

Next let’s look at decorating classes. In this case, per the proposed specification, a decorator takes the target constructor. For a fictional `MySuperHero` class, we can define a simple decorator for it as follows using a `@superhero` decoration:

![](https://cdn-images-1.medium.com/max/800/1*wRKeM_ZJmeqZoD-2sXrvlQ.png)

This can be expanded further, enabling us to supply arguments for defining our decorator function as a factory:

![](https://cdn-images-1.medium.com/max/800/1*HAL1EWF3ekb1nJBskLKRyg.png)

ES2016 Decorators work on property descriptors and classes. They automatically get passed property names and the target object, as we’ll soon cover. Having access to the descriptor allows a decorator to do things like changing a property to use a getter, enabling behaviour that would otherwise be cumbersome such as automatically binding methods to the current instance on first access of a property.

#### ES2016 Decorators and Mixins

I’ve thoroughly enjoyed reading Reg Braithwaite’s recent article on [ES2016 Decorators as mixins](http://raganwald.com/2015/06/26/decorators-in-es7.html) and the precursor [Functional Mixins](http://raganwald.com/2015/06/17/functional-mixins.html). Reg proposed a helper that mixes behaviour into any target (class prototype or standalone) and went on to describe a version that was class specific. The functional mixin that mixes instance behaviour into a class’s prototype looked like this:

![](https://cdn-images-1.medium.com/max/800/1*bB77ghg773qnwCA1aeKPBg.png)

Great. We can now define some mixins and attempt to decorate a class using them. Let’s imagine we have a simple `ComicBookCharacter` class:

![](https://cdn-images-1.medium.com/max/800/1*1YMyHF0gp8F4mVRBtloJ-A.png)

This may well be the world’s most boring character, but we can define some mixins which would provide behaviours granting `SuperPowers` and a `UtilityBelt`. Let’s do this using Reg’s mixin helper:

![](https://cdn-images-1.medium.com/max/800/1*2a3HCBjjQSPZcoER0rSFsg.png)

With this behind us, we can now use the `@` syntax with the names of our mixin functions to decorate the `ComicBookCharacter` with our desired behaviour. Note how we’re prefixing the class with multiple decorator statements:

![](https://cdn-images-1.medium.com/max/800/1*jbX4pzw31FBNp-2QgnfCew.png)

Now, let’s use what we’ve defined to craft a Batman character.

![](https://cdn-images-1.medium.com/max/800/1*_4pUUwbwlqTdBTxV-X111g.png)

These decorators for classes are relatively compact and I could see myself using them as an alternative to function invocation or as helpers for higher-order components.

_Note: @WebReflection has some alternatives takes on the mixin pattern used in this section which you can find in the comments_ [_here_](https://gist.github.com/addyosmani/a0ccf60eae4d8e5290a0#comment-1489585)_._

### Enabling Decorators via Babel

Decorators (at the time of writing) are still but a proposal. They haven’t yet been approved. That said, thankfully Babel supports transpilation of the syntax in an experimental mode, so most of the samples from this post can be tried out with it directly.

If using the Babel CLI, you can opt-in to Decorators as follows:

```
$ babel --optional es7.decorators
```

or alternatively, you can switch on support using a transformer:

![](https://cdn-images-1.medium.com/max/800/1*9dlzSG1EqMCpH-dk1RZ5xg.png)

There’s even an [online Babel REPL](https://babeljs.io/repl/); enable decorators by hitting the “Experimental” checkbox. Try it out!

### Interesting experiments

Paul Lewis, who luckily enough I sit next to, has been [experimenting](https://github.com/GoogleChrome/samples/tree/gh-pages/decorators-es7/read-write) with decorators as a means for rescheduling code that reads and writes to the DOM. It borrows ideas from Wilson Page’s FastDOM, but provides an otherwise small API surface. Paul’s read/write decorators can also warn you via the console if you’re calling methods or properties during a @write (or change the DOM during @read) that trigger layout.

Below is a sample from Paul’s experiment, where attempting to mutate the DOM inside a @read causes a warning to be thrown to the console:

![](https://cdn-images-1.medium.com/max/800/1*A3gYGXlTPdXGtCkfgK_NRA.png)

### Go try Decorators now!

In the short term, ES2016 decorators are useful for declarative decoration and annotations, type checking and working around the challenges of applying decorators to ES2015 classes. In the long term, they could prove very useful for static analysis (which could give way to tools for compile-time type checking or autocompletion).

They aren’t that different from decorators in classic OOP, where the pattern allows an object to be decorated with behaviour, either statically or dynamically without impacting objects from the same class. I think they’re a neat addition. The semantics for decorators on class properties are still in flux, however keep an eye on Yehuda’s repo for updates.

Library authors are currently discussing where Decorators may replace mixins and there are certainly ways in which they could be used for higher-order components in [React](https://github.com/timbur/react-mixin-decorator).

I’m personally excited to see an increase in experimentation around their use and hope you’ll give them a try using Babel, identify repurposeable decorators and maybe you’ll even share your work like Paul did :)

### Further reading and references

* [https://github.com/wycats/javascript-decorators](https://github.com/wycats/javascript-decorators)
* [https://github.com/jayphelps/core-decorators.js](https://github.com/jayphelps/core-decorators.js)
* [http://blog.developsuperpowers.com/eli5-ecmascript-7-decorators/](http://blog.developsuperpowers.com/eli5-ecmascript-7-decorators/)
* [http://elmasse.github.io/js/decorators-bindings-es7.html](http://elmasse.github.io/js/decorators-bindings-es7.html)
* [http://raganwald.com/2015/06/26/decorators-in-es7.html](http://raganwald.com/2015/06/26/decorators-in-es7.html)
* [Jay’s function expression ES2016 Decorators example](https://babeljs.io/repl/#?experimental=true&evaluate=true&loose=false&spec=false&playground=true&code=class%20Foo%20%7B%0A%20%20%40function%20%28target%2C%20key%2C%20descriptor%29%20%7B%20%20%20%0A%20%20%20%20descriptor.writable%20%3D%20false%3B%20%0A%20%20%20%20return%20descriptor%3B%20%0A%20%20%7D%0A%20%20bar%28%29%20%7B%0A%20%20%20%20%0A%20%20%7D%0A%7D&stage=0)

With thanks to [Jay Phelps](http://twitter.com/jayphelps), [Sebastian McKenzie](http://twitter.com/sebmck), [Paul Lewis](http://twitter.com/aerotwist) and [Surma](http://twitter.com/surmair) for reviewing this article and providing detailed feedback ❤


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
