> * 原文地址：[Why you should replace forEach with map and filter in JavaScript](https://gofore.com/en/why-you-should-replace-foreach/)
> * 原文作者：[Roope Hakulinen](https://disqus.com/by/roopehakulinen/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-replace-foreach.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-replace-foreach.md)
> * 译者：
> * 校对者：

# Why you should replace forEach with map and filter in JavaScript

_TL;DR Prefer `map` and `filter` over `forEach` when you need to copy an array or part of it to a new one._

One of the best parts for me in the consulting line of work is that I get to see countless projects. These projects vary widely in size, the programming languages used and in developer competence. While there are multiple patterns that I feel should be abandoned, there is a clear winner in the JavaScript world: forEach to create new arrays. The pattern is actually really simple and looks something like this:

```
const kids = [];
people.forEach(person => {
  if (person.age < 15) {
    kids.push({ id: person.id, name: person.name });
  }
});
```

What is happening here is that the array for all people is processed to find out everyone aged less than 15. Each of these ‘kids’ is then copied to the kids array by selecting a few fields of the person object.

While this works, it is a very imperative (see [Programming paradigms](https://en.wikipedia.org/wiki/Programming_paradigm)) way to code. So what is wrong? you might be wondering. To understand this, let’s first familiarize ourselves with the two friends `map` and `filter`.

## `map` & `filter`

`map` and `filter` were introduced to JavaScript as part of the ES6 feature set in 2015. They are methods of arrays that allow a more functional style coding in JavaScript. As usual in the functional programming world, neither of the methods is mutating the original array. Rather they both return a new array. They both accept a single parameter that is of type function. This function is then called on each item in the original array to produce the resulting array. Let’s see what the methods do:

*   `map`: the result of the function called for each item is placed in the new array returned by the method.
*   `filter`: the result of the function called for each item determines whether the item should be included in the array returned by the method.

They also have a third friend in the same gang but it is a little less used. This friend’s name is [`reduce`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce).

Here are simple examples to see them in action:

```
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(number => number * 2); // [2, 4, 6, 8, 10]
const even = numbers.filter(number => number % 2 === 0); // [2, 4]
```

Now that we know what `map` and `filter` do, let’s next see an example of how I would prefer the earlier example to be written:

```
const kids = people
  .filter(person => person.age < 15)
  .map(person => ({ id: person.id, name: person.name }));
```

In case you are wondering about the syntax of lambda used in `map`, see this [Stack Overflow answer](https://stackoverflow.com/a/28770578/1744702) for an explanation.

So what exactly is better with this implementation:

*   Separation of concerns: Filtering and changing the format of the data are two separate concerns and using a separate method for both allows separating the concerns.
*   Testability: Having a simple, [pure function](https://en.wikipedia.org/wiki/Pure_function) for both purposes can easily be unit tested for various behaviours. It is worth noting that the initial implementation is not as pure as it relies on some state outside of its scope (`kids` array).
*   Readability: As the methods have clear purposes to either filter out data or change the format of the data, it is easy to see what kind of manipulations are being done. Especially as there are those functions of the same category like `reduce`.
*   Asynchronous programming: `forEach` and `async`/`await` don’t play nicely together. `map` on the other hand provides a useful pattern with promises and `async`/`await`. More about this in the next blog post.

It is also worth noting here that `map` is not to be used when you want to cause side effects (e.g. mutate global state). Especially in a case where the return value of the `map` method is not even used or stored.

## Conclusions

Usage of `map` and `filter` provides many benefits such as the separation of concerns, testability, readability and support for asynchronous programming. Thus, it is a no-brainer for me. Yet, I constantly encounter developers using `forEach`. While functional programming might be a little scary, there is nothing to be afraid of with these methods even though they have some traits from that world. `map` and `filter` are also heavily used in [reactive programming](https://en.wikipedia.org/wiki/Reactive_programming) that is used nowadays more and more in the JavaScript world too thanks to [RxJS](http://reactivex.io/rxjs/). So next time you are about to write a `forEach` first think about the alternative approaches. But be warned, they might change the way you code permanently.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
