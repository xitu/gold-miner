
> * 原文地址：[How an Anti-TypeScript “JavaScript developer” like me became a TypeScript fan](https://chiragswadia.medium.com/how-an-anti-typescript-javascript-developer-like-me-became-a-typescript-fan-a4e043151ad7)
> * 原文作者：[chiragswadia](https://chiragswadia.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-an-anti-typescript-javascript-developer-like-me-became-a-typescript-fan.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-an-anti-typescript-javascript-developer-like-me-became-a-typescript-fan.md)
> * 译者：
> * 校对者：


# How an Anti-TypeScript “JavaScript developer” like me became a TypeScript fan
In this blog post, I am talking about my journey from being an Anti-TypeScript developer to a developer who now could not think about going back to the plain JavaScript world 🚀 Maybe my thoughts can help someone who is in the same boat as I was couple of years back.

# **Why was I Anti-TypeScript?**

I always felt that adding types to the functions/variables and satisfying the TypeScript compiler is an over-engineering and not providing any meaningful benefits. Also it felt slow to work on, as I always used to get some compilation errors which were hard to understand initially, and I scratched my head trying to figure out the problem. This caused some frustration, and I started hating TypeScript

The other reason was Advanced TypeScript concepts like [Generics](https://www.typescriptlang.org/docs/handbook/generics.html) felt very hard to understand initially and I started feeling that I am in the **Java** world where every piece of code is strongly typed and overwhelming. Even simple code like below scared me when I started learning TypeScript

![https://miro.medium.com/max/1544/1*ccNIwcBOISh4ZJ7kAuaY4A.png](https://miro.medium.com/max/1544/1*ccNIwcBOISh4ZJ7kAuaY4A.png)

TypeScript Generics example

So because of the above reasons, even though I was learning TypeScript by watching tutorials or reading books, I never worked on any enterprise application which was written in TypeScript. In fact, I used to choose JavaScript over TypeScript ( if it was a choice ) for take home assignments as a part of interview process of companies 🙈

However, when I moved to my current role, working on JavaScript was not a choice, as all the apps I was going to work on, were written in TypeScript ( with only legacy code in JavaScript).As expected, initially it was overwhelming for me, and my hate for TypeScript was increasing, but eventually after couple of months, I understood the benefits and some motivating reasons as to why someone should prefer TypeScript over JavaScript, which I have listed in the below section

# **Top 3 Reasons why I became a TypeScript Fan**

## **Making impossible states impossible and exhaustive checks**

This is the major reason why I love TypeScript. If you would like to know more about this concept, I would recommend watching the below video. It talks about the Elm language, but the concept is valid for the TypeScript world as well

If you want to see some examples on how to leverage TypeScript in your React applications to avoid impossible states, I would recommend you to read the below blog posts

1. [A real life example on how would a Traffic light system would take care of impossible states](https://zohaib.me/leverage-union-types-in-typescript-to-avoid-invalid-state/) 🚦
2. [A React component with loading, loaded and error states](https://dev.to/housinganywhere/matching-your-way-to-consistent-states-1oag) ⚛️

## **Spotting bugs early**

While working on JavaScript, I have encountered multiple instances where bugs were spotted in production due to some corner case, which happened because of no type-checking on the Frontend. These bugs can be avoided and could be caught at the compile time by the TypeScript compiler, which will save some hours of DEV 🔁 QA cycle

With TypeScript, everything stays the way it was initially defined. If a variable is declared as a Boolean, it will always be a Boolean and won’t turn into a number. This enhances the likelihood of code working the way initially intended. In short, the code is predictable!

## **Rich IDE support and ease of refactoring**

Information about types makes Integrated development environments (IDE) much more helpful. You will get features like code navigation and autocompletion, providing accurate suggestions. You also get feedback while typing: The editor flags errors, including type-related as soon as they occur. All this helps you write maintainable code and results in a huge productivity boost 🚀

If we talk about refactoring, like introducing a new state or getting rid of an unwanted state which is being used across the app, TypeScript compiler will complain if you forget to update some references, and you can be confident about your refactoring, that the app will work the same way as it was before refactoring.

# **Conclusion**

To summarise, there are many other benefits of moving to TypeScript ( if you have not already done ), but these were the main motivating points for me which made me a TypeScript fan.

If you are a TypeScript beginner or would like to improve your knowledge, here are some books I can recommend

1. [TypeScript in 50 Lessons](https://amzn.to/37YslR2) [Affiliate link]
2. [Tackling TypeScript](https://exploringjs.com/tackling-ts/)

Cheers! 🙂

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
