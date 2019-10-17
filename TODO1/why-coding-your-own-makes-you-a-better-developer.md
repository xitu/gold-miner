> * 原文地址：[Why Coding Your Own Makes You a Better Developer](https://medium.com/better-programming/why-coding-your-own-makes-you-a-better-developer-5c53439c5e4a)
> * 原文作者：[Danny Moerkerke](https://medium.com/@dannymoerkerke)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-coding-your-own-makes-you-a-better-developer.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-coding-your-own-makes-you-a-better-developer.md)
> * 译者：
> * 校对者：

# Why Coding Your Own Makes You a Better Developer

> To truly understand the wheel, you need to reinvent it

![Photo by [Jon Cartagena](https://unsplash.com/@cartega?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*nbaB-g7qNeIhN7iN)

The other day I interviewed for a senior developer position with a JavaScript developer. My colleague, who was also in the interview, asked the interviewee to write a function that would perform an HTTP call and retry it a number of times if it failed.

Since he was writing it on a whiteboard, pseudo-code would have been enough. If he had just demonstrated a good understanding of the matter we would have been happy. But unfortunately, he wasn’t able to come up with a good solution.

Thinking he may have just been nervous, we decided to make it a bit easier and asked him to convert a callback-based function to a Promise-based function.

No luck.

Yes, I could tell he had seen similar code before. He more or less knew how it worked. A solution in pseudo-code that demonstrated he understood the concept would have been fine.

But the code he wrote on the whiteboard made no sense at all. He only had a vague understanding of the concept of a JavaScript Promise and couldn’t explain it well.

You may get away with that if you’re a junior developer, but if you’re applying for a senior position it’s not enough. How would he debug a complex Promise chain and then explain what he did to others?

---

## Developers Take Abstractions For Granted

As developers, we work with abstractions. We abstract code that we would otherwise have to repeat. So when we focus on more important parts, we take the abstractions we work with for granted and just **assuming** that they work.

Usually, they do, but when things get complicated it pays to **really know** how these abstractions work.

The candidate for the senior developer position took the promise abstraction for granted. He probably knew how to work with it if he found it in a piece of code somewhere, but he didn’t truly **understand** the concept and so he wasn’t able to reproduce it in a job interview.

He could have just memorized the code. It’s really not that complicated:

```
return new Promise((resolve, reject) => {
  functionWithCallback((err, result) => {
   return err ? reject(err) : resolve(result);
  });
});
```

I did that. Probably, we all do that. You just memorize a piece of code so you can work with it. You understand more or less how it works.

But if he had truly understood the concept he wouldn’t **need** to memorize it. He would just **know** it and have no trouble reproducing it.

---

## Know Your Source

Back in 2012, before front-end framework dominance, jQuery ruled the world and I was reading “[Secrets of the JavaScript Ninja](https://www.manning.com/books/secrets-of-the-javascript-ninja)” by John Resig, the creator of jQuery.

This book teaches you how to create your own jQuery from scratch, giving you a unique insight into the thought processes behind the creation of this library. Although jQuery has faded into the background over the past years, I highly recommend reading this book.

What struck me the most about the book, was the constant feeling that I could have thought of this myself. The steps as described were so logical and straightforward that I really got the feeling that **I** could have built jQuery if I had set myself to it.

Of course, in reality, I would never be able to do that — I would consider it to be far too complicated. I would believe my solutions to be too simple and naive to work and I would just give up. I would just take jQuery for granted and trust it to work. After that I would probably not take the time to figure out how it works. I would just use it as a black box.

But reading this book changed me. I started reading source code and found out that many implementations of solutions were pretty straightforward, even obvious.

Now, coming up with these solutions yourself is of course an entirely different thing. But reading source code and reimplementing existing solutions yourself is **exactly** what helps you come up with your own.

The inspiration you get and patterns you discover will change you as a developer. You will find that this great library you use and think of as magic is really not magical, but just a simple and smart solution.

You may take time understanding code, step by step, but it will also make you go through the same small, incremental steps the authors took to create it. This gives you more insight into the process of coding and more confidence to code your own solutions.

When I started using JavaScript Promises I thought they were magic. Then I learned they’re just based on callbacks and my vision of programming was changed forever.

This pattern that was meant to get rid of callbacks was implemented using… **callbacks?**

This changed me. It made me realize that these are not incredibly complex pieces of code that were far too complicated for me to understand. They are patterns that I could easily understand if I had the curiosity and will to dive into them.

That’s how you really learn how to program. That’s how you become a better developer.

---

## Reinvent That Wheel

So go ahead and reinvent that wheel. Code [your own data binding](https://medium.com/swlh/https-medium-com-drmoerkerke-data-binding-for-web-components-in-just-a-few-lines-of-code-33f0a46943b3?source=friends_link&sk=09dd590e07b3300bae4b63dbb716cc39), code [your own Promise](https://hackernoon.com/implementing-javascript-promise-in-70-lines-of-code-b3592565af0f) or even [your own state management solution](https://css-tricks.com/build-a-state-management-system-with-vanilla-javascript/).

It doesn’t matter if no one will ever use it. You will have learned. And if you could use it in one of your own projects, that would already be great. You’ll develop it further and learn even more.

The point is not to use your solution in production but to learn. Coding your own implementation of an existing solution is a great way to learn from the best.

**It’s how you become a better developer.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
