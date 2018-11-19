> * 原文地址：[Abstraction & Composition](https://medium.com/javascript-scene/abstraction-composition-cb2849d5bdd6)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/abstraction-composition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/abstraction-composition.md)
> * 译者：
> * 校对者：

# Abstraction & Composition

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!  
> [< Previous](https://github.com/xitu/gold-miner/blob/master/TODO/nested-ternaries-are-great.md) | [<< Start over at Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-an-introduction.md) | [Next >](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md)

The more I mature in software development, the more I value the fundamentals — insights that seemed trivial when I was a beginner, but now hold profound significance with the benefit of experience.

> “In the martial art of Karate […] the symbol of pride for a black belt is to wear it long enough such that the dye fades to white as to symbolize returning to the beginner state.” ~ John Maeda, [“The Laws of Simplicity: Design, Technology, Business, Life”](https://www.amazon.com/Laws-Simplicity-Design-Technology-Business/dp/0262134721/ref=as_li_ss_tl?ie=UTF8&qid=1516330765&sr=8-1&keywords=the+laws+of+simplicity&linkCode=ll1&tag=eejs-20&linkId=287b1d3357fa799ce7563584e098c5d8)

Abstraction is “the process of considering something independently of its associations, attributes, or concrete accompaniments,” according to Google dictionary.

The word abstraction comes from the latin verb _abstrahere_, which means “to draw away”. I like this insight. Abstraction is about removing things — but what are we removing, and to what end?

Sometimes I like to translate words into other languages and then translate them back to English to get a sense of other associations we don’t commonly think about in English. When I translate “abstraction” into Yiddish and back, the result is “absentminded”. I like this, too. An absentminded person is running on autopilot, not actively thinking about what they’re doing… just doing it.

Abstraction lets us run on autopilot, safely. All software is automation. Given enough time, anything you do on a computer, you could do with paper, ink, and carrier pigeons. Software just takes care of all the little details that would be too time consuming to do manually.

All software is abstraction, hiding away all the hard work and mindless details while we reap the benefits.

A lot of software processes get repeated again and again. If, during the problem decomposition stage, we decided to reimplement the repeated stuff over and over again, that would require a lot of unnecessary work. It would be silly at the very least. In many cases, it would be impractical.

Instead, we remove duplication by writing a component of some kind (a function, module, class, etc…), giving it a name (identity), and reusing it as many times as we like.

The process of decomposition is the process of abstraction. Successful abstraction implies that the result is a set of independently useful and recomposable components. From this we get an important principle of software architecture:

Software solutions should be decomposable into their component parts, and recomposable into new solutions, without changing the internal component implementation details.

### Abstraction is the act of simplification

> “Simplicity is about subtracting the obvious and adding the meaningful.” ~ John Maeda, [“The Laws of Simplicity: Design, Technology, Business, Life”](https://www.amazon.com/Laws-Simplicity-Design-Technology-Business/dp/0262134721/ref=as_li_ss_tl?ie=UTF8&qid=1516330765&sr=8-1&keywords=the+laws+of+simplicity&linkCode=ll1&tag=eejs-20&linkId=287b1d3357fa799ce7563584e098c5d8)

The process of abstraction has two main components:

*   **Generalization** is the process of finding _similarities_ (the obvious) in repeated patterns, and hiding the similarities behind an abstraction.
*   **Specialization** is the process of using the abstraction, supplying _only what is different_ (the meaningful) for each use case.

Abstraction is the process of extracting the underlying essence of a concept. By exploring common ground between different problems from different domains, we learn how to step outside our headspace for a moment and see a problem from a different perspective. When we see the essence of a problem, we find that a good solution may apply to many other problems. If we code the solution well, we can radically reduce the complexity of our application.

> “If you touch one thing with deep awareness, you touch everything.” ~ Thich Nhat Hanh

This principle can be used to radically reduce the code required to build an application.

### Abstraction in Software

Abstraction in software takes many forms:

*   Algorithms
*   Data structures
*   Modules
*   Classes
*   Frameworks

And my personal favorite:

> “Sometimes, the elegant implementation is just a function. Not a method. Not a class. Not a framework. Just a function.” ~ John Carmack (Id Software, Oculus VR)

Functions make great abstractions because they possess the qualities that are essential for a good abstraction:

*   **Identity** — The ability to assign a name to it and reuse it in different contexts.
*   **Composition** — The ability to compose simple functions to form more complex functions.

### Abstraction through composition

The most useful functions for abstraction in software are _pure functions_, which share modular characteristics with functions from math. In math, a function given the same inputs will always return the same output. It’s possible to see functions as relations between inputs and outputs. Given some input `A`, a function `f` will produce `B` as output. You could say that `f` defines a relationship between `A` and `B`:

```
f: A -> B
```

Likewise, we could define another function, `g`, which defines a relationship between `B` and `C`:

```
g: B -> C
```

This _implies_ another function `h` which defines a relationship directly from `A` to `C`:

```
h: A -> C
```

Those relationships form the structure of the problem space, and the way you compose functions in your application forms the structure of your application.

Good abstractions simplify by hiding structure, the same way `h` reduces `A -> B -> C` down to `A -> C`.

![](https://cdn-images-1.medium.com/max/800/1*uFTKDgI0kT878E97K14V1A.png)

### How to do More with Less Code

Abstraction is the key to doing more with less code. For example, imagine you have a function which simply adds two numbers:

```
const add = (a, b) => a + b;
```

But you use it frequently to increment, it might make sense to fix one of those numbers:

```
const a = add(1, 1);
const b = add(a, 1);
const c = add(b, 1);
// ...
```

We can curry the add function:

```
const add = a => b => a + b;
```

And then create a partial application, applying the function to its first argument, and returning a new function that takes the next argument:

```
const inc = add(1);
```

Now we can use `inc` instead of `add` when we need to increment by `1`, which reduces the code required:

```
const a = inc(1);
const b = inc(a);
const c = inc(b);
// ...
```

In this case, `inc` is just a _specialized_ version of add. All curried functions are abstractions. In fact, all higher-order functions are generalizations that you can specialize by passing one or more arguments.

For example, `Array.prototype.map()` is a higher-order function that abstracts the idea of applying a function to each element of an array in order to return a new array of processed values. We can write `map` as a curried function to make this more obvious:

```
const map = f => arr => arr.map(f);
```

This version of `map` takes the specializing function and then returns a specialized version of itself that takes the array to be processed:

```
const f = n => n * 2;

const doubleAll = map(f);
const doubled = doubleAll([1, 2, 3]);
// => [2, 4, 6]
```

Note that the definition of `doubleAll` required a trivial amount of code: `map(f)` — that's it! That's the entire definition. Starting with useful abstractions as our building blocks, we can construct fairly complex behavior with very little new code.

### Conclusion

Software developers spend their entire careers creating and composing abstractions — many without a good fundamental grasp of abstraction or composition.

When you create abstractions, you should be deliberate about it, and you should be aware of the good abstractions that have already been made available to you (such as the always useful `map`, `filter`, and `reduce`). Learn to recognize characteristics of good abstractions:

*   Simple
*   Concise
*   Reusable
*   Independent
*   Decomposable
*   Recomposable

### Learn More at EricElliottJS.com

Video lessons on functional programming are available for members of EricElliottJS.com. If you’re not a member, [sign up today](https://ericelliottjs.com/).

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)

* * *

**Eric Elliott** is the author of [“Programming JavaScript Applications”](http://pjabook.com) (O’Reilly), and cofounder of the software mentorship platform, [DevAnywhere.io](https://devanywhere.io/). He has contributed to software experiences for **Adobe Systems**, **Zumba Fitness**, **The Wall Street Journal**, **ESPN**, **BBC**, and top recording artists including **Usher**, **Frank Oc**.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
