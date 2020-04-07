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

这个 `Generator` 对象包含 `next()`、`return` 和 `throw` which can be used to interact with our generator functions. It works similarly to an `iterator` but you have more control over it.

Let’s see, with an example, how we can use the `generatorFunction`. Now, as I told you before, we get `next()`.

The `next()` method returns an object with two properties, `done` and `value`. You can also provide a parameter to the `next` method to send a value to the generator. Let’s see this with an example.

```JavaScript
function* generatorFunction() {
   yield 1;
}
const iterator = generatorFunction()
const value=iterator.next().value
console.log(value)
```

![Output after calling next on generator function](https://cdn-images-1.medium.com/max/2000/1*CuDQhYcZ3xLZKvFTosFFrg.png)

Now, as I said earlier, we can also pass values to the generator function through `next` and that value can be used inside the `generator` function. Let’s see how that works with another example.

```JavaScript
function* generatorFunction() {
   let value = yield null
   yield value+ 2;
   yield 3 + value
}
const iterator:Generator = generatorFunction()
const value=iterator.next(10).value // returns null
console.log(iterator.next(11).value) //return 13
```

![Passing Value to generator function through next](https://cdn-images-1.medium.com/max/2000/1*ywIGvmfO_r3j0rTdccplEQ.png)

Here, when you obtain the generator, you don’t have a `yield` you can push values to. So, first you have to reach a yield by calling the next on the generator initially. It will return `null`, always.

You can pass arguments or not, it does not matter, it will always return `null`. Once you have done that, you have a `yield` at your disposal and you can push your value via `iterator.next()` which will effectively replace `yield null` with the input passed through `next`.

Then, when it finds another `yield`, it returns to the consumer of the generator which is our `iterator` here.

Now, let’s talk a little about the `yield` keyword. It looks like it’s working like return but on steroids because return simply returns a value from a function after a function is called.

It will also not allow you to do anything after the `return` keyword in a normal function but in our case, `yield` is doing much more than that. It’s returning a value but when you call it again, it will move on to the next `yield` statement.

The `yield` keyword is used to pause and resume a generator function. The `yield` returns an object and it contains a `value` and `done`.

The `value` is the result of the evaluating of the generator functions and the `done` indicates whether our generator function has been fully completed or not, its values can be either `true` or `false`.

We can also use the `return` keyword in the generator function and it will return the same object but it will not go any further than that and the code after `return` will never be reached, even if you have six `yield`s after that.

So, you need to be very careful using `return` and it should only be used once you are certain the job of the generator function is done.

```JavaScript
function* generatorFunction() {
   yield  2;
   return 2;
   yield 3; //generator function will never reach here
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
