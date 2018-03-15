> * 原文地址：[TypeScript — JavaScript with superpowers — Part II](https://medium.com/@wesharehoodies/typescript-javascript-with-superpowers-part-ii-69a6bd2c6842)
> * 原文作者：[Indrek Lasn](https://medium.com/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-superpowers-part-ii.md](https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-superpowers-part-ii.md)
> * 译者：
> * 校对者：

# TypeScript — JavaScript with superpowers — Part II

![](https://cdn-images-1.medium.com/max/800/1*ijxYcfk-rHyfAWLq6bPr1Q.png)

_Welcome back, for more_ articulated experience —[ _read the part I first_](https://medium.freecodecamp.org/typescript-javascript-with-super-powers-a333b0fcabc9)_._

![](https://cdn-images-1.medium.com/max/800/1*lrVNbYOEn_ni9NNRTY0r7w.png)

Enums (**_enum_**_erations_) allow you to group values together with friendlier names. Imagine you had a list of names, here’s how you would structure the `enum`

![](https://cdn-images-1.medium.com/max/800/1*4qFIKpovAtDdkA0HkrqEVw.png)

You can grab the values from the enum like so

![](https://cdn-images-1.medium.com/max/800/1*KaoKC7ZCuXwLPR_1ntY9SQ.png)

But wait. It returns the integer which represents the index of the value. Like arrays, enums begin indexing their members starting at `0`

How do we get the value `"Indrek"` instead of `0` ?

![](https://cdn-images-1.medium.com/max/800/1*ymUuAzpdwzeMc3522yb0MA.png)

Notice how the values are presented as a string.

![](https://cdn-images-1.medium.com/max/800/1*XnRIFhuCMpJFp8CmVUnf3g.png)

Another great example would be using enums to store the application states.

![](https://cdn-images-1.medium.com/max/800/1*nOLoMIf6YLl0XbFoPWeHmw.png)

In case you’re interested in learning more about `enum`— I found [a great answer](https://stackoverflow.com/a/28818850/5073961) going in the nitty and gritty of `enum`

* * *

![](https://cdn-images-1.medium.com/max/800/1*DKPVSnf7PVjrdDY_Fvz6EQ.png)

Let’s say we fetched some data from an API. We always expect the data to be fetched — but what if we can’t fetch the data?

Perfect time to return the `never` type (special case scenario)

![](https://cdn-images-1.medium.com/max/800/1*lkfWaSP6G8YfqWjoFWqh4w.png)

Notice the error message we passed.

We can call the `error` function inside another function (callback)

![](https://cdn-images-1.medium.com/max/800/1*oZ4Ya3w5ypd6BM3AeF1nRA.png)

Notice how we don’t use the `void` but `never` since inferred return type is `never`.

* * *

![](https://cdn-images-1.medium.com/max/800/1*bgzesRZpes2KJYFRWRgFkw.png)

*   **null** — the absence of any value.
*   **undefined** — a variable has been declared but has not yet been assigned a value.

Not very useful on their own.

![](https://cdn-images-1.medium.com/max/800/1*PwsNVPPzy7qav43uRHKBRg.png)

By default `null` and `undefined` are subtypes of all other types. That means you can assign `null` and `undefined` to something like `number`.

![](https://cdn-images-1.medium.com/max/800/1*q6FsoxR0Qou54lG040J2KQ.jpeg)

[Source](https://stackoverflow.com/a/44388246/5073961)

[Here’s a great post about](http://2ality.com/2013/04/quirk-undefined.html) `[null](http://2ality.com/2013/04/quirk-undefined.html)` [and](http://2ality.com/2013/04/quirk-undefined.html) `[defined](http://2ality.com/2013/04/quirk-undefined.html)` [by Dr. Axel Rauschmayer.](http://2ality.com/2013/04/quirk-undefined.html)

* * *

![](https://cdn-images-1.medium.com/max/800/1*x3Y773t23Pc1VlhYWXB0TQ.png)

Type assertions usually happen if you know the type of some entity could be more specific than its current type.

Type assertions have no runtime impact, and is used purely by the compiler. TypeScript assumes that you, the programmer, have performed any special checks that you need.

Here’s a quick demonstration

![](https://cdn-images-1.medium.com/max/800/1*LGa_fcmyWZSCzduOKqHgpw.png)

the bracket `<>` syntax collides with [JSX](https://reactjs.org/docs/jsx-in-depth.html) so we use the `as` syntax instead.

![](https://cdn-images-1.medium.com/max/800/1*GgrkjRVkPhwu7hHAacWwaQ.png)

[Here’s a lot more about type assertions.](https://basarat.gitbooks.io/typescript/docs/types/type-assertion.html)

#### Cool stuff to consider

*   `[interface](https://basarat.gitbooks.io/typescript/docs/types/interfaces.html)s`
*   [DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped)
*   `[unions](https://basarat.gitbooks.io/typescript/docs/types/discriminated-unions.html)`
*   `[classes](https://www.typescriptlang.org/docs/handbook/classes.html)`
*   [awesome typescript](https://github.com/dzharii/awesome-typescript)

Now — build something awesome with Typescript! 📙

Thanks for reading, hope you enjoyed and found it useful! Stay awesome!

- [**Indrek Lasn - Medium**: Read writing from Indrek Lasn on Medium.](https://medium.com/@wesharehoodies)

- [**Indrek Lasn (@lasnindrek) | Twitter**: The latest Tweets from Indrek Lasn (@lasnindrek).](https://twitter.com/lasnindrek)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
