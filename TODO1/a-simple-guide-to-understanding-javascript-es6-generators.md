> * 原文地址：[A Simple Guide to Understanding Javascript (ES6) Generators](https://medium.com/dailyjs/a-simple-guide-to-understanding-javascript-es6-generators-d1c350551950)
> * 原文作者：[Rajesh Babu](https://medium.com/@rajeshdavid?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-understanding-javascript-es6-generators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-understanding-javascript-es6-generators.md)
> * 译者：
> * 校对者：

# A Simple Guide to Understanding Javascript (ES6) Generators

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

If you’ve been a JavaScript developer for the last two to five years you will have definitely come across posts talking about **Generators** and **Iterators**. While **Generators** and **Iterators** are inherently associated, Generators seem a bit more intimidating than the other.

![](https://cdn-images-1.medium.com/max/800/1*bwQSEHpbaNHte95IW2kTCw.jpeg)

Generator Turbine

> **Iterators** are an implementation of **Iterable** objects such as maps, arrays and strings which enables us to iterate over them using next(). They have a wide variety of use cases across Generators, Observables and Spread operators.

> I recommend the following link for those of you who are new to iterators, [Guide to Iterators](https://codeburst.io/a-simple-guide-to-es6-iterators-in-javascript-with-examples-189d052c3d8e).

To check if your object conforms to the iterable protocol, verify using the built-in Symbol.iterator:

```
new Map([[1, 2]])[Symbol.iterator]() // MapIterator {1 => 2}
“hi”[Symbol.iterator]() // StringIterator {}
[‘1’][Symbol.iterator]() // Array Iterator {}
new Set([1, 2])[Symbol.iterator]() // SetIterator {1, 2}
```

**Generators** introduced as part of ES6 have not undergone any changes for the further JavaScript releases and they are here to stay longer. I mean really long! So there is not running away from it. Although ES7 and ES8 have some new updates, they do not have the same magnitude of change that ES6 had from ES5, which took JavaScript to the next level, so to speak.

**By the end of this post, I am positive that you will have a solid understanding of how function Generators work**. If you are a pro, please help me improve the content by adding your comments in the responses. Just in case if you have difficulty following the code, I have also added explanation for most of the code to help you understand better.

![](https://cdn-images-1.medium.com/max/800/1*ZrJKJqBsksWd-8uKM9OvgA.png)

### Introduction

Functions in JavaScript, as we all know, **_“run until return/end”. Generator Functions_** on the other hand, **_“run until yield/return/end”._** Unlike the normal functions **Generator Functions** once called, returns the **Generator Object,** which holds the entire **Generator Iterable** that can be iterated using **next()** method or **for…of** loop.

> Every next() call on the generator executes every line of code until the next yield it encounters and suspends its execution temporarily.

Syntactically they are identified with a *****, either **function* X** or **function *X**,— both mean the same thing.

Once created, calling the generator function returns the **Generator Object.** This generator object needs to be assigned to a **variable** to keep track of the subsequent **next()** methods called on itself. **_If the generator is not assigned to a variable then it will always yield only till first yield expression on every next()._**

The generator functions are normally built using **_yield expressions_**. Each **_yield_** inside the generator function is a stopping point before the next execution cycle starts. Each execution cycle is triggered by means of **_next()_** method on the generator.

On each **_next()_** call, the **_yield_** expression returns its value in the form of an object containing the following parameters.

`{ value: 10, done: false } // assuming that 10 is the value of yield`

*   **Value** — is everything that is written on the right side of the **_yield_** keyword, it can be a function call, object or practically anything. For empty yields this value is **_undefined_**.
*   **Done** — indicates the status of the generator, whether it can be executed further or not. When done returns true, it means that the function has finished its run.

_(If you feel that its a bit over your head, you will get more clarity once you see the example below…)_

![](https://cdn-images-1.medium.com/max/800/1*YnOJNuFe-r9T7pO47mVYaw.png)

Basic generator function

> **Note:** In the above example the **generator function** accessed directly without a wrapper always executes only until the first yield. Hence, by definition you need to assign the Generator to a variable to properly iterate over it.

### Lifecycle of a Generator Function

Before we proceed further, let’s take a quick look at the block diagram of the Generator Function’s life-cycle:

![](https://cdn-images-1.medium.com/max/800/1*0pLkX6yrbV2r6_pZ10AIvQ.png)

Life-cycle of a Generator Function

Each time a **_yield_** is encountered the generator function returns an object containing the **_value_** of the encountered yield and the **_done_** status. Similarly, when a **_return_** is encountered, we get the return value and also **_done_** status as **_true_**. Whenever, done status is returned as true, is essentially means that the **_generator function_** has completed its run, and no further yield is possible.

> Everything after the first **return** is ignored, including other **yield** expressions.

_Read further to understand the block diagram better._

### Assigning Yield to a Variable

In the previous code sample we saw an introduction to creating a basic generator with a yield. And got the expected output. Now, let’s assume that we assign the entire yield expression to a variable in the code below.

![](https://cdn-images-1.medium.com/max/800/1*zdJQlUaqIiD3eV0j0QzrZA.png)

Assigning yield to a variable

> What is the result of the entire yield expression passed to the variable ? **_Nothing or Undefined …_**

> Why ? **_Starting from second next(), the previous yield is replaced with arguments passed in the next function. Since, we do not pass anything here in the next method, its assumed that the entire ‘previous-yield expression’ as undefined._**

With this in mind, let’s jump to the next section to understand more about passing argument to the next() method.

### Passing Arguments to the next() Method

With reference to the block diagram above, let’s talk about passing arguments into the next function. **_This is one of the most trickiest part of the whole generator implementation_**.

Let’s consider the following piece of code, where the yield is assigned to a variable, but this time we pass a value in the next() method.

Let’s look at the code below in the console. And the explanation right after that.

![](https://cdn-images-1.medium.com/max/800/1*aYCKrAkgSyfEeN9cswZzbA.png)

Passing arguments to the next()

#### Explanation:

1.  When we call the **_first next(20)_**, every line of code till the first yield is printed. As we do not have any previous yield expression this value 20 is discarded. In the output we get yield value as i*10, which is 100 here. Also the state of the execution stops with first yield and the **_const j_** is not yet set.
2.  The second **_next(10)_** call, replaces the entire first yield expression with 10, imagine **_yield (i * 10) = 10,_** which goes on to set the value of **_const j to 50_** before returning the second yield’s value. The yield value here is **_2 * 50 / 4 = 25_**.
3.  Third **_next(5)_**, replaces the entire second yield with 5, bringing the value of k to 5. And further continues to execute return statement and return **_(x + y + z) => (10 + 50 + 5) = 65_** as the final yield value along with done true.

> **This might be bit overwhelming for the first time readers, but take a good 5 minutes to read it over and over again to understand completely.**

### Passing Yield as an Argument of a Function

There are n-number of use-cases surrounding yield regarding how it can be used inside a function generator. Let’s look at the code below for one such interesting usage of yield, along with the explanation.

![](https://cdn-images-1.medium.com/max/800/1*Y6pwTwJ7stPZzAeCKBfv4Q.png)

Yield as an argument of a function

#### Explanation

1.  The first next() yields undefined value because yield expression has no value.
2.  The second next() yields “I am usless”, the value which was passed. And prepares argument for function call.
3.  The third next(), calls the function with an **_undefined_** argument. As mentioned above, the next() method called without any arguments essentially means that the **_entire previous yield expression is undefined_**. Hence, this prints **_undefined_** and finishes the run.

### Yield with a Function Call

Apart from returning values yield can also call functions and return the value or print the same. Let’s look at the code below and understand better.

![](https://cdn-images-1.medium.com/max/800/1*zXpsq-hlqla3z3mZGWyTJw.png)

Yield calling a function

The code above returns the function’s return obj as the yield value. And ends the run by setting **_undefined_** to the **_const user_**.

### Yield with Promises

Yield with promises follows the same approach as the function call above, instead of returning a value from the function, it returns a promise which can be evaluated further for success or failure. Let’s look at the code below to understand how it works.

![](https://cdn-images-1.medium.com/max/800/1*100c_wLxJHmcKtjZAYwJzw.png)

Yield with promises

The apiCall returns the promises as the yield value, when resolved after 2 seconds prints the value we need.

### Yield*

So far we have been looking at the use cases for yield expression, now we are going to look at another expression called **_yield*_**_._ **_Yield*_** when used inside a generator function  delegates another generator function. Simply put, it synchronously completes the generator function in its expression before moving on to the next line.

Let’s look at the code and the explanation below to understand better. This code is from the MDN web docs.

![](https://cdn-images-1.medium.com/max/800/1*eMlOmBoi2XGCE3qwUIj3qA.png)

Basic yield*

#### Explanation

1.  The first next() call yields a value of 1.
2.  The second next() call, however, is a **_yield* expression_**, which inherently means that we are going to complete another generator function specified in the **_yield* expression_** before continuing the current generator function.
3.  In your mind, you can assume that the code above is replaced like the one below

```
function* g2() {
  yield 1;
  yield 2;
  yield 3;
  yield 4;
  yield 5;
}
```

> This will go on to finish the generator run. However, there is one distinct ability of the **_yield*_** which you should keep in mind while using **_return_**, in the next section.

### Yield* with Return

Yield* with a return behaves a bit differently than the normal yield*. When yield* is used with a return statement it evaluates to that value, meaning the entire yield* function() becomes equal to the value returned from the associated generator function.

Let’s look at the code and the explanation below to understand it better.

![](https://cdn-images-1.medium.com/max/800/1*HxJtIuXhBnOMAK0cwVElsQ.png)

Yield* with return

#### **Explanation**

1.  In the first next() we go straight to the yield 1 and return its value.
2.  The second next() yields 2.
3.  The third next(), **_returns ‘foo’_** and goes on to yield the ‘the end’, assigning ‘foo’ to the **_const result_** on the way.
4.  The last next() finishes the run.

### **Yield* with a Built-in Iterable Object**

There is one more interesting yield* property worth-mentioning, similar to the return value, **_yield*_** can also iterate over iterable objects like Array, String and Map.

Let’s look at how it works in real-time.

![](https://cdn-images-1.medium.com/max/800/1*u6RQVCQBCqw5UsF3Kger1w.png)

Yield over built-in iterables

Here in the code the yield* iterates over every possible iterable object that is passed as its expression. I guess the code itself is self-explanatory.

### Best Practices

On top of all this, every iterator/generator can be iterated over a **for…of** loop. Similar to our next() method which is called explicitly, for…of loop internally moves on to the next iteration based on the **_yield keyword_**. And it iterates only till the **_last yield_** and doesn’t process the return statements like the next() method.

You can verify the same in the code below.

![](https://cdn-images-1.medium.com/max/800/1*dDYt_xElLC7wjUDN7HfDJg.png)

Yield with for…of

> The final return value is not printed, because for…of loop iterates only till the last yield. So, it comes under best practice to avoid return statements inside a generator function as it would affect the reusability of the function when iterated over a **for…of**.

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### Conclusion

I hope this covers the basic use-cases of generator functions and I sincerely hope that it gave a better understanding of how generators work in JavaScript ES6 and above. If you like my content please leave **_1, 2, 3 or even 50 claps :)_**.

Please follow me on my GitHub account for more JavaScript and Full-Stack projects:

* [**rajeshdavidbabu (Rajesh Babu)**: rajeshdavidbabu has 11 repositories available. Follow their code on GitHub.](https://github.com/rajeshdavidbabu)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
