> * 原文地址：[Avoid trusting const in JavaScript](https://medium.com/front-end-weekly/avoid-trusting-const-in-javascript-69c1c0b59942)
> * 原文作者：[rahuulmiishra](https://rahuulmiishra.medium.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/avoid-trusting-const-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/avoid-trusting-const-in-javascript.md)
> * 译者：
> * 校对者：

![](https://miro.medium.com/max/1400/1*iT9aLA6A823qTKMa4jF3Xw.jpeg)

# Avoid trusting const in JavaScript

Hello World!!! 🌏

In about all of our JavaScript applications we tend to create constants, these constants could be Strings, Objects, Arrays, Numbers or Boolean, in order to save our component or view file from being polluted with large number of magic 🧙🏻‍♂️ values.

Everything is fine until we start using **Object** and **Arrays** as constant values. Let us see what problem we may encounter in case object and arrays constant:

Below are the few code snippets demonstrating the problem with the use of **const** for object and arrays

![](https://miro.medium.com/max/1400/1*SSrNp4tvzDNwdznCyB5J8Q.png)

![](https://miro.medium.com/max/1400/1*b184e2M6cG67X8uTUhh3mA.png)

![](https://miro.medium.com/max/1400/1*h0AbFC4Xqp9RvkV2pyWLCg.png)

Basically, what `const` do is, it adds a **restriction** that **we can’t re-assign** something to the created variable.

In the above code, I am **not re-assigning** something, I was simply changing the value on an object in other words I am mutating. And due to JavaScript Mutability concept this is possible to do. [Read more about Immutability in JS Here](https://rahuulmiishra.medium.com/immutability-in-javascript-892129a41497).  
`const` **does not guarantee immutability.**

We have two ways to overcome modification of Object and Arrays .

## 1. Using **Object.freeze()** ❄️

`Object.freeze()` does following things:  
a. It will make sure the object can’t be modified.  
b. We won’t be able to change or add keys after freezing an object.

No Addition + No Modification

![](https://miro.medium.com/max/1096/1*L9Za0baN7NLlqQ1gGH_bgQ.png)

## 2. Using Object.seal() 🔒

If we seal an object then we won’t be able to add keys, but we can update the data under on key.

No Addition But Can be Modified.

![](https://miro.medium.com/max/1400/1*P2EXj8JPvqaWFwLG-MioBg.png)

**When to use .seal() and .freeze() methods** 😃.  
- When you have a large team working on a same code base and you don’t want to risk some changing or updating some config values. In that Case we can seal or freeze our objects.  
- For high risk config constants, like user Roles, Base URL we can use freezing.

**Performance Benefits** 🚀:  
- The iteration on sealed and frozen objects are faster than normal objects. [https://stackoverflow.com/questions/8435080/any-performance-benefit-to-locking-down-javascript-objects](https://stackoverflow.com/questions/8435080/any-performance-benefit-to-locking-down-javascript-objects)

**Caviat: Hmmmm, why this world is so rude** 🤯

Object.seal() and Object.freeze() does **shallow** sealing and freezing. Meaning only one level of values are frozen or sealed in a nested object and in array of object, only array will be sealed/frozen, one can still modify objects inside array.

**Solution**: We have to write our own method, which will loop through array and object and froze, seal at every level separately.  
[DeepFreeze code mentioned in MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
