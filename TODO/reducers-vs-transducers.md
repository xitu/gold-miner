> * 原文地址：[Reducers VS Transducers](http://maksimivanov.com/posts/reducers-vs-transducers)
> * 原文作者：[Maksim Ivanov](http://maksimivanov.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/reducers-vs-transducers.md](https://github.com/xitu/gold-miner/blob/master/TODO/reducers-vs-transducers.md)
> * 译者：
> * 校对者：

# Reducers VS Transducers

Sweet chunk of functional paradigm for you today. I don’t know why did I write “versus” while they compliment each other. Anyway, let’s get to the good stuff…

## Reducers

Simply speaking a `Reducer` is a function that takes an accumulation and a value, and then returns a new accumulation.

![reducers](http://d33wubrfki0l68.cloudfront.net/8da7177f710424f3236cb13803ce8442e4b93127/5e09a/assets/images/reducers_vs_transducers_1.png)

You are already familiar with reducers if you’ve used the `Array.prototype.reduce()` method. The `.reduce()` function itself is not a reducer! It iterates over a collection and passes values to it’s “callback” that is a **reducer** here.

Let’s imagine that we have an array with five numbers: `[1, 2, 3, 14, 21]` and we want to find the biggest of them.

```
const numbers = [1, 2, 3, 14, 21];

const biggestNumber = numbers.reduce(
  (accumulator, value) => Math.max(accumulator, value)
);

// 21
```

The arrow function here is a reducer. The `.reduce()` method only takes the result of previous reduction and calls the reducer with it and next element of an array.

Reducers can work with any kinds of values. The only rule is that the accumulation you return should have the same type that the accumulation you pass in.

For example you can easily create a reducer that will work with strings:

```
const folders = ['usr', 'var', 'bin'];

const path = folders.reduce(
  (accumulator, value) => `${accumulator}/${value}`
, ''); // Here I passed empty string as an initial value

// /usr/var/bin
```

Actually it’s better to illustrate without `Array.reduce()` method. Look:

```
const stringReducer = (accumulator, value) => `${accumulator} ${value}`

const helloWorld = stringReducer("Hello", "world!")

// Hello world!
```

## Map And Filter As Reducers

The other cool thing about reducers is that you can chain them to perform a series of operations on some data. This opens up huge possibilities for composition and reuse of small reducer functions.

Let’s say you have an ordered array of numbers. You want to get even numbers from it and then multiply by 2.

The ordinary way to do it would be to use `.map` and `.filter` functions:

```
[1, 2, 3, 4, 5, 6]
  .filter((x) => x % 2 === 0)
  .map((x) => x * 2)
```

But what if your array had 1000,000 elements? You have to loop through the whole array for every operation, that’s extremely uneffective.

We need some way to combine the functions we passed to `map` and `filter`. But we can’t do this as they have different interface. The function that we passed to `filter` is called **predicate** and it takes a value and returns **True** or **False** depending on inner logic. And the function we passed to `map` is **transformer** function. It takes a value and returns **transformed value**.

We can achieve this with reducers, let’s create our own **reducer** version of `.map` and `.filter` functions.

```
const filter = (predicate) => {
  return (accumulator, value) => {
    if(predicate(value)){
      accumulator.push(value);
    }
    return accumulator;
  }
}

const map = (transformer) => {
  return (accumulator, value) => {
    accumulator.push(transformer(value));
    return accumulator;
  }
}
```

Great, we used **decorator** functions to wrap our reducers. Now we have `map` and `filter` functions that return **reducers** that can be passed to `Array.reduce()` method!

```
[1, 2, 3, 4, 5, 6]
  .reduce(filter((x) => x % 2 === 0))
  .reduce(map((x) => x * 2))
```

Great, now we have a chain of `.reduce` function calls, but we still can’t compose our reducers! Good news is there is only one step left. To be able to compose reducers we need to be able to pass them to each other.

## Transducers FTW

Let’s update our `filter` function so it would also accept **reducer** as an argument. We are going to decompose it and instead of pushing value to **accumulator** we’ll allow the passed in **reducer** to perform it’s logic.

```
const filter = (predicate) => (reducer) => {
  return (accumulator, value) => {
    if(predicate(value)){
      return reducer(accumulator, value);
    }
    return accumulator;
  }
}
```

This pattern where we take a **reducer** as an argument and return another **reducer** is called **transducer**. As it’s a combination of **transformer** and **reducer** (we take a reducer and transform it).

```
const transducer => (reducer) => {
  return (accumulator, value) => {
    // Some logic involving passed in reducer
  }
}
```

So basically transducer looks like this `(oneReducer) => anotherReducer`.

Now we can combine our **mapping** reducer and **filtering** transducer and do our calculations in one run.

```
const evenPredicate = (x) => x % 2 === 0;
const doubleTransformer = (x) = x * 2;

const filterEven = filter(evenPredicate);
const mapDouble = map(doubleTransformer);

[1, 2, 3, 4, 5, 6]
  .reduce(filterEven(mapDouble));
```

Actually we could make our map method a transducer as well and continue this composition indefinitely.

But just imagine having to compose more than 2 transducers. We have to find more convenient way to compose them.

## Better Composition

Basically we need something that would take a number of functions and compose them in that order.

```
compose(fn1, fn2, fn3)(x) => fn1(fn2(fn3(x)))
```

Luckily a lot of libraries provide this kind of function. For instance [RamdaJS](http://ramdajs.com/docs/#compose). But for educational purposes let’s create our own version.

```
const compose = (...functions) =>
  functions.reduce((accumulation, fn) =>
    (...args) => accumulation(fn(args)), x => x)
```

The function is very compact, let’s break it down.

Imagine that we called that function like this `compose(fn1, fn2, fn3)(x)`.

First look at the `x => x` part. In lambda calculus it’s called **identity function**. It just returns whatever it takes as an argument without changing. We need it here to start our unfolding.

So after fist iteration we’ll have that **identity function** (for convenience let’s call it **I**) called with the **fn1** function as an argument:

```
  (...args) => accumulation(fn(args))

  // STEP 1
  // We pass our fn1 to accumulation
  (...args) => accumulation(fn1(args))

  // STEP 2
  // Here we basically substitute accumulation with I
  // and fn and fn1
  (...args) => I(fn1(args))
```

Yay, we calculated the `accumulation` value after the first iteration. Let’s do the second one:

```
  (...args) => I(fn1(args)) // Our new accumulation

  // STEP 3
  // Now we pass fn2 to our accumulation
  (...args) => accumulation(fn2(args))

  // Step 4
  // Lets substitute "accumulation" with it's current value
  (...args) => I(fn1(fn2(args)))
```

I think you got the idea. Now just repeat steps 3 and 4 for `fn3` and voila, you’ve converted your `compose(fn1, fn2, fn3)(x)` to `fn1(fn2(fn3(x)))`.

Now we can compose our `map` and `filter` like this:

```
[1, 2, 3, 4, 5, 6]
  .reduce(filterEven,
          mapDouble);
```

## Conclusion

I suppose you already knew about **reducers**, and if not – you’ve learned a nice abstraction to work with collections. Reducers are great to fold different data structures.

Also you’ve learned how to do your computations effectively using **transducers**.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
