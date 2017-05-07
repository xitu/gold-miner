> * 原文地址：[How I wrote the world's fastest JavaScript memoization library](https://community.risingstack.com/the-worlds-fastest-javascript-memoization-library/)
> * 原文作者：[Caio Gondim](https://community.risingstack.com/author/caio/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# How I wrote the world's fastest JavaScript memoization library #

**In this article, I’ll show you how I wrote the world’s fastest JavaScript memoization library called [fast-memoize.js](https://github.com/caiogondim/fast-memoize.js) - which is able to do 50 million operations / second.**

We’re going to discuss all the steps and decisions I took in a detailed way, and I’ll also show you the code and benchmarks as proof.

As **fast-memoize.js** is an open source project, I’ll be delighted to read your comments and suggestions for this library!

A while ago I was playing around with some [soon to be released features](http://www.2ality.com/2015/06/tail-call-optimization.html) in V8 using the Fibonacci algorithm as a basis for a benchmark. 

One of the benchmarks consisted a memoized version of the Fibonacci algorithm against a vanilla implementation, and the results showed a huge gap in performance between them.

After realizing this, I started poking around with different memoization libraries and benchmarking them (because... why not?). I was quite surprised to see a huge performance gap between them, since the memoization algorithm is quite straightforward. 

But why?

![Performance of popular JavaScript memoization libraries](https://blog-assets.risingstack.com/2017/01/performance-of-popular-javascript-memoization-libraries.png)

While taking a look at the [lodash](https://github.com/lodash/lodash/blob/master/memoize.js#L50) and [underscore](https://github.com/jashkenas/underscore/blob/master/underscore.js#L810) source code, I also realized that by default, they only could memoize functions that accept one argument (arity one). I was — again — curious, and wondering if I could make a fast enough memoization library that would accept N arguments. 

*(And, maybe, creating one more npm package in the world?)*

Below I explain all the steps and decisions I took while creating the [fast-memoize.js](https://github.com/caiogondim/fast-memoize.js) library.

## Understanding the problem ##

From the [Haskell language wiki](https://wiki.haskell.org/Memoization):

> "Memoization is a technique for storing values of a function instead of recomputing them each time."

**In other words, memoization is a cache for functions.** It only works for deterministic Algorithms though, for those that will always generate the same output for a given input.

Let's break the problem into smaller pieces for better understanding and testability.

### Breaking down the JavaScript memoization problem ###

I broke the memoization algorithm into 3 different pieces:

1. **cache**: stores the previously computed values. 
2. **serializer**: takes the arguments as inputs and generates a string as an output that represents the given input. Think of it as a fingerprint for the arguments. 
3. **strategy**: glues together cache and serializer, and outputs the memoized function.

Now the idea is to implement each piece in different ways, benchmark each one and make the **final algorithm as a combination of the fastest cache, serializer, and strategy**. 

The goal here is to let the computer do the heavy lifting for us!

### #1 - Cache ###

As I just mentioned, the cache stores previously computed values.

#### Interface ####

To abstract implementation details, a similar interface to [Map](http://ecma-international.org/ecma-262/7.0/#sec-properties-of-the-map-prototype-object) was created:

- has(key)
- get(key)
- set(key, value)
- delete(key)

This way we can replace the inner cache implementation without breaking it for consumers, as long we implement the same interface.

#### Implementations ####

One thing that needs to be done every time a memoized function is executed is to check if the output for the given input was already computed.

A good data structure for that is a hash table. Hash table has an O(1) time complexity in Big-O notation for checking the presence of a value. Under the hood, a JavaScript object is a Hash table ([or something similar](https://simplenotions.wordpress.com/2011/07/05/javascript-hashtable/)), so we can leverage this using the input as key for the hash table and the value as the function output.

```
    // Keys represent the input of fibonacci function// Values represent the outputconst cache = {  
      5: 5,
      6: 8,
      7: 13
    }
```
    

I used those different algorithms as a cache:

1. Vanilla object 
2. Object without prototype (to avoid prototype lookup) 
3. [lru-cache](https://www.npmjs.com/package/lru-cache) package 
4. [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map)

Below you can see a benchmark of all cache implementations. To run locally, do `npm run benchmark:cache`. The source for all different implementations can be found on the [project's GitHub page](https://github.com/caiogondim/fast-memoize.js/tree/master/benchmark/cache). 

![Variable JavaScript memoization cache](https://blog-assets.risingstack.com/2017/01/variable-javascript-memoization-cache.png)

#### The need for a serializer ####

There is a problem when a non-literal argument is passed since its string representation is not unique.

```
    functionfoo(arg) { returnString(arg) }
    
    foo({a: 1}) // => '[object Object]'  
    foo({b: 'lorem'}) // => '[object Object]'  
```
    

That is why we need a serializer, to create a *fingerprint* of arguments that will serve as key for the cache. It needs to be as fast as possible as well.

### #2 - Serializer ###

The serializer outputs a string based on the given inputs. It has to be a deterministic algorithm, meaning that it will always produce the same output for the same input.

The serializer is used to create a string that will serve as a key for the cache and represent the inputs for the memoized functions. 

Unfortunately, I could not find any library that came close, performance wise, to `JSON.stringify` — which makes sense, since it's implemented in native code.

I tried to use `JSON.stringify` and a bound `JSON.stringify` hoping there would be one less lookup to be made, but no gains here. 

To run locally, do `npm run benchmark:serializer`. The code for both implementations can be found on the [project's GitHub page](https://github.com/caiogondim/fast-memoize.js/tree/master/benchmark/serializer).

![Variable Serializer](https://blog-assets.risingstack.com/2017/01/variable-serializer.png)

There is one piece left: the **strategy**.

### #3 - Strategy ###
 
The strategy is the consumer of both **serializer** and **cache**. It orchestrates all pieces. For [fast-memoize.js](https://github.com/caiogondim/fast-memoize.js) library, I spent most of the time here. Although a very simple algorithm, some gains were made in each iteration.

Those were the iterations I did in chronological order:

1. Naive (first try) 
2. Optimize for single argument 
3. Infer arity 
4. Partial application

Let's explore them one by one. I will try to explain the idea behind each approach, with as little code as possible. If my explanation is not enough and you want to dive deeper, the code for each iteration can be found in the [project's GitHub page](https://github.com/caiogondim/fast-memoize.js/tree/master/benchmark/strategy). 

To run locally, do `npm run benchmark:strategy`.

#### Naive ####

This was the first iteration and the simplest one. The steps:

1. Serialize arguments 
2. Check if output for given input was already computed 
3. If `true`, get result from cache 
4. If `false`, compute and store value on cache

![Variable strategy](https://blog-assets.risingstack.com/2017/01/variable-strategy.png)

With that first try, we could generate around **650,000 operations per second**. That will serve as a basis for next iterations.

#### Optimize for single argument ####

One simple and effective technique while improving performance is to optimize the hot path. Our hot path here is a function which accepts one argument only (arity one) with primitive values, so we don't need to run the serializer.

1. Check if `arguments.length === 1` and argument is a primitive value 
2. If `true`, no need to run serializer, as a primitive value already works as a key for the cache 
3. Check if output for given input was already computed 
4. If `true`, get result from cache 
5. If `false`, compute and store value on cache

![Optimizing for single argument](https://blog-assets.risingstack.com/2017/01/optimizing-for-single-argument.png)

By removing the unnecessary call to the serializer, we can go much faster (on the hot path). Now running at **5.5 million operations per second**. 

#### Infer arity ####

`function.length` returns the number of expected arguments on a defined function. We can leverage this to remove the dynamic check for `arguments.length === 1` and provide a different strategy for monadic (functions that receive one argument) and not-monadic functions.

```
    functionfoo(a, b) {  
      Return a + b
    }
    foo.length // => 2  
```    

![infer arity](https://blog-assets.risingstack.com/2017/01/infer-arity.png)

An expected small gain, since we are only removing one check on the if condition. Now we’re running at **6 million operations per second**. 

### Partial application ###

It seemed to me that most of the time was being wasted on variable lookup (no data for this), and I had no more ideas on how to improve it. Then, I suddenly remembered that it's possible to inject variables in a function through a partial application with the `bind` method. 

```
    functionsum(a, b) {  
      return a + b
    }
    const sumBy2 = sum.bind(null, 2)  
    sumBy2(3) // => 5  
```
    
The idea here is to create a function with some arguments fixed. Then I fixed the **original function**, **cache** and **serializer** through this method. Let's give it a try!

![partial application](https://blog-assets.risingstack.com/2017/01/partial-application.png)

Wow. That's a big win. I'm out of ideas again, but this time satisfied with the result. We are now running at **20 million operations per second**.

## The Fastest JavaScript Memoization Combination ##

We broke down the memoization problem into 3 parts. 

For each part, we kept the other two parts fixed and ran a benchmark alternating only one. By alternating only one variable, we can be more confident the result was an effect of this change — no JS code is deterministic performance wise, due to unpredictable Stop-The-World pauses on VM.

V8 does a lot of optimizations on runtime based on how frequently a function is called, its shape, ... 

To check that we are not missing a massive performance optimization opportunity in any possible combination of the 3 parts, let's run each part against the other, in all possible ways. 

4 strategies x 2 serializers x 4 caches = **32 different combinations**. To run locally, do `npm run benchmark:combination`. Below the top 5 combinations:

![fastest javascript memoize combinations](https://blog-assets.risingstack.com/2017/01/fastest-javascript-memoize-combinations.png)

Legend:

1. **strategy**: Partial application, **cache**: Object, **serializer**: json-stringify 
2. **strategy**: Partial application, **cache**: Object without prototype, **serializer**: json-stringify 
3. **strategy**: Partial application, **cache**: Object without prototype, **serializer**: json-stringify-binded 
4. **strategy**: Partial application, **cache**: Object, **serializer**: json-stringify-binded 
5. **strategy**: Partial application, **cache**: Map, **serializer**: json-stringify

It seems that we were right. The fastest algorithm is a combination of:

- **strategy**: Partial application
- **cache**: Object
- **serializer**: JSON.stringify

## Benchmarking against popular libraries ##

With all the pieces of the algorithm in place, it's time to benchmark it against the most popular memoization libraries. To run locally, do `npm run benchmark`. Below the results:

![Benchmarking against other memoization libraries](https://blog-assets.risingstack.com/2017/01/benchmarking-against-other-memoization-libraries.png)

[fast-memoize.js](https://github.com/caiogondim/fast-memoize.js) is almost 3 times faster than the second fastest running at **27 million operations per second**.

### Future proof ###

V8 has a new and yet to be officially released new optimization compiler called [TurboFan](http://v8project.blogspot.com.br/2015/07/digging-into-turbofan-jit.html).

We should try it today to see how our code will behave tomorrow since TurboFan will be (very 

likely) added to V8 shortly. To enable it pass the flag `--turbo-fan` to the Node.js binary. To run locally, do `npm run benchmark:turbo-fan`. Below the benchmark with TurboFan enabled:

![Performance with TurboFan](https://blog-assets.risingstack.com/2017/01/performance-with-turbofan.png)

Almost a double gain in performance. We are now running at almost **50 million operations per second**. 

Seems the new [fast-memoize.js](https://github.com/caiogondim/fast-memoize.js) version can be highly optimized with the soon to be released new compiler.

## Conclusion ##

That was my take on creating a faster library on an already crowded market. Creating many solutions for each part, combining them, and letting the computer tell which one was the fastest based on statistically significant data. *(I used [benchmark.js](https://benchmarkjs.com/) for that).*

Hope the process I used can be useful for someone else too.

[fast-memoize.js is currently the best memoization library in #JavaScript, and I will strive for it to always be.](https://twitter.com/share)

[Click To Tweet](https://twitter.com/share)

**Not because I'm the smartest programmer in the world, but because I will keep the algorithm up to date with findings from others.**[Pull requests](https://github.com/caiogondim/fast-memoize.js/pulls) are always welcome.

Benchmarking algorithms that runs on virtual machines can be very tricky, as explained by [Vyacheslav Egorov](https://www.youtube.com/watch?v=g0ek4vV7nEA&amp;t=22s), a former V8 engineer. If you see something wrong on how the tests were set up, please create an issue on [GitHub](https://github.com/caiogondim/fast-memoize.js/issues).

The same goes for the library itself. Create an issue if you spotted anything wrong (issues with a failing test are appreciated). 

Pull requests with improvements are super appreciated!

If you liked the library, please give it a [star](https://github.com/caiogondim/fast-memoize.js/stargazers). That's one of the few feedbacks we open source programmers have.

#### References ####

- [JavaScript & Hashtable](https://simplenotions.wordpress.com/2011/07/05/javascript-hashtable/)
- [Firing up ignition interpreter](http://v8project.blogspot.com.br/2016/08/firing-up-ignition-interpreter.html)
- [Big-O cheat sheet](http://bigocheatsheet.com/)
- [GOTO 2015 • Benchmarking JavaScript • Vyacheslav Egorov](https://www.youtube.com/watch?v=g0ek4vV7nEA&amp;t=22s)

Let me know in the comments if you have any questions!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
