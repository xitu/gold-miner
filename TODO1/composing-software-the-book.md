> * 原文地址：[Composing Software: The Book](https://medium.com/javascript-scene/composing-software-the-book-f31c77fc3ddc)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-the-book.md](https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-the-book.md)
> * 译者：
> * 校对者：

# Composing Software: The Book

![Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)](https://cdn-images-1.medium.com/max/10302/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

> **Note:** This is part of the [**“Composing Software” book**](https://leanpub.com/composingsoftware) that started life right here as a blog post series. It covers functional programming and compositional software techniques in JavaScript (ES6+) from the ground up. [“Composing Software” is also available in Print](https://www.amazon.com/Composing-Software-Exploration-Programming-Composition/dp/1661212565/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=eee1371063c82dea4c2fc72c097868c6&language=en_US).

"Composing Software”, the hit blog post series on functional programming and software composition in JavaScript is now a [best selling book on Leanpub](https://leanpub.com/composingsoftware). Also available [in print](https://www.amazon.com/Composing-Software-Exploration-Programming-Composition/dp/1661212565/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=eee1371063c82dea4c2fc72c097868c6&language=en_US).

On February 18th, 2017, I started writing a blog post on functional programming. [“The Rise and Fall and Rise of Functional Programming”](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c) was to serve as an introductory article for a series of articles on software composition. I had no idea when I started writing that it would attract more than 100,000 readers, or that the articles that followed would attract over a million aggregate reads, or that it would become [a book](https://leanpub.com/composingsoftware) and jump up the Leanpub best sellers list the week it was announced.

My sincere thanks go out to JS Cheerleader, who made the book better in too many ways to list. If you find the text readable, it is because she carefully poured over every page and offered insightful feedback and encouragement every step of the way. Without her help, you would not be reading this right now.

Thanks to the blog readers, who’s support and enthusaism helped us turn a little blog post series into a phenomenon that attracted millions of reads and provided the momentum we needed to turn it into a book.

Thanks to the legends of computer science who paved the way.

> “If I have seen further it is by standing on the shoulders of giants.” ~ Sir Isaac Newton

All software development is composition: The act of breaking a complex problem down to smaller parts, and then composing those smaller solutions together to form your application.

But I noticed while interviewing candidates for software development jobs, almost none of them could describe what composition is in the context of software. When I asked “what is function composition?” or “what is object composition?” in interviews, I got… stammers. Crickets. Nothing.

How could this be? How could 99% of professional developers — some with 10+ years’ of software development experience not know definitions or examples of the two most basic forms of composition in software engineering? Everybody composes functions and objects in the process of building software on a daily basis, so how could so many people not understand the basic foundations of those techniques?

The fact is that composition simply isn’t a subject that people pay attention to, or teach well, or learn. It occurred to me that maybe this is why [overcomplicating things is the single biggest mistake software developers make every day](https://medium.com/javascript-scene/the-single-biggest-mistake-programmers-make-every-day-62366b432308). When you don’t know how to fit lego blocks together, you might break out the duct-tape and crazy glue and go nuts… to the detriment of the software, your teammates, and your users.

You can’t get away from composing software — that’s how software comes together. But if you don’t do it conscientiously, you’ll do it badly, which leads to a lot of wasted time, wasted money, bugs, and even critical human safety issues. I wrote this series — and book — to change that.

The trouble with the blog posts is that they never had an official index. Welcome to the official blog post index for “Composing Software: The Blog Posts”.

* [Composing Software: An Introduction](https://medium.com/javascript-scene/composing-software-an-introduction-27b72500d6ea)
* [The Dao of Immutability](https://medium.com/javascript-scene/the-dao-of-immutability-9f91a70c88cd)
* [The Rise and Fall and Rise of Functional Programming](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c)
* [Why Learn Functional Programming in JavaScript?](https://medium.com/javascript-scene/why-learn-functional-programming-in-javascript-composing-software-ea13afc7a257)
* [Pure Functions](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)
* [What is Functional Programming?](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0)
* [A Functional Programmer’s Introduction to JavaScript](https://medium.com/javascript-scene/a-functional-programmers-introduction-to-javascript-composing-software-d670d14ede30)
* [Higher Order Functions](https://medium.com/javascript-scene/higher-order-functions-composing-software-5365cf2cbe99)
* [Curry and Function Composition](https://medium.com/javascript-scene/curry-and-function-composition-2c208d774983)
* [Abstraction and Composition](https://medium.com/javascript-scene/abstraction-composition-cb2849d5bdd6)
* [Functors & Categories](https://medium.com/javascript-scene/functors-categories-61e031bac53f)
* [Monads](https://medium.com/javascript-scene/javascript-monads-made-simple-7856be57bfe8)
* [The Forgotten History of OOP](https://medium.com/javascript-scene/the-forgotten-history-of-oop-88d71b9b2d9f)
* [Object Composition](https://medium.com/javascript-scene/the-hidden-treasures-of-object-composition-60cd89480381)
* [Factory Functions](https://medium.com/javascript-scene/javascript-factory-functions-with-es6-4d224591a8b1)
* [Functional Mixins](https://medium.com/javascript-scene/functional-mixins-composing-software-ffb66d5e731c)
* [Why Composition is Harder with Classes](https://medium.com/javascript-scene/why-composition-is-harder-with-classes-c3e627dcd0aa)
* [Composable Custom Datatypes](https://medium.com/javascript-scene/composable-datatypes-with-functions-aec72db3b093)
* [Lenses](https://medium.com/javascript-scene/lenses-b85976cb0534)
* [Transducers](https://medium.com/javascript-scene/transducers-efficient-data-processing-pipelines-in-javascript-7985330fe73d)
* [Elements of JavaScript Style](https://medium.com/javascript-scene/elements-of-javascript-style-caa8821cb99f)
* [Mocking is a Code Smell](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a)

---

****Eric Elliott** is a distributed systems expert and author of the books, [“Composing Software”](https://leanpub.com/composingsoftware) and [“Programming JavaScript Applications”](https://ericelliottjs.com/product/programming-javascript-applications-ebook/). As co-founder of [DevAnywhere.io](https://devanywhere.io/), he teaches developers the skills they need to work remotely and embrace work/life balance. He builds and advises development teams for crypto projects, and has contributed to software experiences for **Adobe Systems,Zumba Fitness,** **The Wall Street Journal,** **ESPN,** **BBC,** and top recording artists including **Usher, Frank Ocean, Metallica,** and many more.**

**He enjoys a remote lifestyle with the most beautiful woman in the world.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
