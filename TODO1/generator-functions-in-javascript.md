> * 原文地址：[Generator Functions in JavaScript](https://medium.com/better-programming/generator-functions-in-javascript-571ba4cda69e)
> * 原文作者：[Sachin Thakur](https://medium.com/@thakursachin467)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/generator-functions-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/generator-functions-in-javascript.md)
> * 译者：
> * 校对者：

# JavaScript 中的 Generator 函数

![Photo by [matthew Feeney](https://unsplash.com/@matt__feeney?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/wait?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10180/1*T-HFCdKSrA6dhlyN66g1uw.jpeg)

在 ES6 中, EcmaScript 发布了一种使用函数的新方法。在本文中，我们将研究这种函数以及研究如何使用和在哪里使用它们

## 什么是 Generator 函数？

Generator 函数是一种特殊的函数，它允许你暂停执行，之后你可以随时恢复。

它们还简化了迭代器的创建，稍后我们将介绍。让我们简单地从一些示例中了解它们是什么开始。

创建 Generator 函数很简单。这个 `function*` 声明（`function` 关键字后跟一个星号）定义了一个 Generator 函数。

```js
function* generatorFunction() {
   yield 1;
}
```

现在，在 Generator 函数中，我们不用使用 return 语句，而是使用一个 `yield` 来指定从迭代器返回的值。现在，在上面的示例中，它将返回 1。

当我们像调用常规的 ES6 函数那样调用 Generator 函数时，它不直接执行该函数，而是返回一个 `Generator` 对象。

这个 `Generator` 对象包含 `next()`、`return` 和 `throw`，可用于和 Generator 函数进行交互。它的工作原理类似于 `iterator`，但是你可以有更多的控制权。

让我们看一下示例，了解如何使用 `generatorFunction`。现在，正如我前文所说的那样，我们得到了 `next()` 方法。

这个 `next()` 方法返回一个对象，包含了两个属性，`done` 和 `value`。你也可以为 `next` 方法提供一个参数传递给 Generator。让我们看一下这个例子。

```JavaScript
function* generatorFunction() {
   yield 1;
}
const iterator = generatorFunction()
const value=iterator.next().value
console.log(value)
```

![Output after calling next on generator function](https://cdn-images-1.medium.com/max/2000/1*CuDQhYcZ3xLZKvFTosFFrg.png)

现在，正如我前文所说，我们可以通过 `next` 传递一个值给 Generator 函数，并且这个值可以在 `Generator` 函数内部使用。让我们通过另一个示例看一下它是如何工作的。

```JavaScript
function* generatorFunction() {
   let value = yield null
   yield value + 2;
   yield 3 + value
}
const iterator:Generator = generatorFunction()
const value=iterator.next(10).value // returns null
console.log(iterator.next(11).value) //return 13
```

![Passing Value to generator function through next](https://cdn-images-1.medium.com/max/2000/1*ywIGvmfO_r3j0rTdccplEQ.png)

当你首次调用 Generator 函数的时候， 没有一个可以传入值的 `yield` 。因此，必须通过调用 Generator 上的 next 来获取到 yield。它将始终返回 `null`。

无论是否传递参数，都没问题。它始终返回 `null`。完成这个操作后，就可以使用 `yield` 了，你可以通过 `iterator.next()` 传递一个值，通过 `next` 传递的输入值将高效的替换掉 `yield null`。

然后，当它找到另一个 `yield` 时， it returns to the consumer of the generator which is our `iterator` here.

现在，让我们谈谈关于 `yield` 关键字。它看起来像 return 一样工作，但是更加的强大，因为 return 只是返回当函数调用后，从函数中返回一个值。

在正常的函数中，不允许在 `return` 关键字后执行任何操作，但是在 Generator 函数中，`yield` 可以做的更多。它会返回一个值，但是当你再次调用时，它会继续执行下一个 `yield` 语句。

`yield` 关键字用于暂停和恢复一个 Generator 函数。`yield` 返回一个包含 `value` 和 `done` 的对象。

`value` 是 generator 函数求值后的结果，`done` 表明是否 generator 函数完全地执行完成,，它的值为可为 `true` 或者 `false`。

在 generator 函数中也可以使用 `return` 关键字，它会返回相同的对象，但是不会像 `yield` 一样继续执行下去，`return` 之后的代码将永远不会执行，即使后面有许多 `yield`。

因此，需要非常小心的使用 `return`，仅当确定 generator 函数的工作完成后才能使用。

```JavaScript
function* generatorFunction() {
   yield  2;
   return 2;
   yield 3; // generator 函数永远不会到达这
}
const iterator:Generator = generatorFunction()
```

## Uses of the Generator Function

Now, generator functions can very easily simplify the creation of iterators, implementation of the recursion, and better async functionality. Let’s look at some examples.

```JavaScript
function* countInfinite(){
   let i=0;
   while(true){
      yield i;
      i++
   }
}
const iterator= countInfinite()
console.log(iterator.next().value)
console.log(iterator.next().value)
console.log(iterator.next().value)
```

![Count infinity example](https://cdn-images-1.medium.com/max/2504/1*YVzFY7yj2GwKBQUKbnhkug.png)

In the above, it’s an infinite loop but it will only be executed as many times as we call `next` on the iterator since it preserves the previous state of the function it continues to count.

This is just a very basic example of how it can be used but we can use more complex logic inside the generator functions, giving us more power.

```JavaScript
function* fibonacci(num1:number, num2:number) {
while (true) {
   yield (() => {
         num2 = num2 + num1;
         num1 = num2 - num1;
         return num2;
      })();
   }
}
const iterator = fibonacci(0, 1);
for (let i = 0; i < 10; i++) {
   console.log(iterator.next().value);
}
```

![Fibonacci series Example](https://cdn-images-1.medium.com/max/2700/1*UOMv0GIOFyRWOqhFMSxgMA.png)

In the above example, we implemented a Fibonacci series without any recursion. The generator functions are really powerful and are only limited by your own imagination.

Another big advantage of generator functions is that they are really memory efficient. We generate a value that is needed.

In the case of a normal function, we generate a lot of values without even knowing whether we are going to use them or not. However, in the case of the generator function, we can defer the computation and only use it when needed.

Before using the generator function, just keep some things in mind. You cannot access a value again if you have already accessed it.

## Conclusion

Iterator functions are a great and efficient way to do a lot of things in JavaScript. There are many other possible ways of using a generator function.

For example, working with asynchronous operations can be made easy. Since a generator function can emit many values over time, it can be used as an observable too.

I hope this article helped you understand a little about the `generator` function and let me know what else you can do or are doing with the `generator` function.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
