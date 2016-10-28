> * 原文地址：[So You Want to be a Functional Programmer (Part 6)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-6-db502830403#.2bgj637a5)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# So You Want to be a Functional Programmer (Part 6)


Taking that first step to understanding Functional Programming concepts is the most important and sometimes the most difficult step. But it doesn’t have to be. Not with the right perspective.

Previous parts: [Part 1](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536), [Part 2](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a), [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7), [Part 4](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49), [Part 5](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-5-c70adc9cf56a)

#### Now What?









![](https://cdn-images-1.medium.com/max/1600/1*yVZA0aT5t6crvBPAMn46Kg.png)





Now that you’ve learned all this great new stuff, you’re probably thinking, “Now what? How can I use this in my everyday programming?”

It depends. If you can program in a Pure Functional Language like Elm or Haskell, then you can leverage all of these ideas. And these languages make it easy to do so.

If you can only program in an Imperative Language like Javascript, as many of us must, then you can still use a lot of what you’ve learned but there will be a great deal more discipline required.

#### Functional Javascript









![](https://cdn-images-1.medium.com/max/1600/1*w_gG-CXQX4TV3B5bN24nqg.png)





Javascript has many features that let you program in a more functional manner. It’s not pure but you can get some immutability in the language and even more with libraries.

It’s not ideal, but if you have to use it, then why not gain some of the benefits of a Functional Language?

**Immutability**

The first thing to consider is immutability. In ES2015, or ES6 as it was called, there is a new keyword called **_const_**. This means that once a variable is set, it cannot be reset:

    const a = 1;
    a = 2; // this will throw a TypeError in Chrome, Firefox or Node
           // but not in Safari (circa 10/2016)

Here **_a_** is defined to be a constant and therefore cannot be changed once set. This is why **_a = 2_** throws an exception (except for Safari).

The problem with **_const_** in Javascript is that it doesn’t go far enough. The following example illustrates its limits:

    const a = {
        x: 1,
        y: 2
    };
    a.x = 2; // NO EXCEPTION!
    a = {}; // this will throw a TypeError

Notice how **_a.x = 2_** does NOT throw an exception. The only thing that’s immutable with the **_const_** keyword is the variable **_a_**. Anything that **_a_** points to can be mutated.

This is terribly disappointing because it would have made Javascript so much better.

So how do we get immutability in Javascript?

Unfortunately, we can only do so via a library called [Immutable.js](https://facebook.github.io/immutable-js/). This may give us better immutability but sadly, it does so in a way that makes our code look more like Java than Javascript.

**Currying and Composition**

Earlier in this series, we learned how to write functions that are curried. Here’s a more complex example:

    const f = a => b => c => d => a + b + c + d

Notice that we had to write the currying part by hand.

And to call **_f,_** we have to write:

    console.log(f(1)(2)(3)(4)); // prints 10

But that’s enough parentheses to make a Lisp programmer cry.

There are many libraries which make this process easier. My favorite one is [Ramda](http://ramdajs.com/).

Using Ramda we can now write:

    const f = R.curry((a, b, c, d) => a + b + c + d);
    console.log(f(1, 2, 3, 4)); // prints 10
    console.log(f(1, 2)(3, 4)); // also prints 10
    console.log(f(1)(2)(3, 4)); // also prints 10

The function definition isn’t much better but we’ve eliminated the need for all those parenthesis. Notice that we can apply as many or as few parameters as we want each time we invoke **_f_**.

By using Ramda, we can rewrite the **_mult5AfterAdd10_** function from [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7)and [Part 4](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49):

    const add = R.curry((x, y) => x + y);
    const mult5 = value => value * 5;
    const mult5AfterAdd10 = R.compose(mult5, add(10));

It turns out that Ramda has a lot of helper functions for doing these sorts of things, e.g. **_R.add_** and **_R.multiply_**, which means we can write less code:

    const mult5AfterAdd10 = R.compose(R.multiply(5), R.add(10));

**Map, Filter and Reduce**

Ramda also has its own versions of **_map_**, **_filter_** and **_reduce_**. Although these functions exist in **_Array.prototype_** in vanilla Javascript, Ramda’s versions are curried:

    const isOdd = R.flip(R.modulo)(2);
    const onlyOdd = R.filter(isOdd);
    const isEven = R.complement(isOdd);
    const onlyEven = R.filter(isEven);

    const numbers = [1, 2, 3, 4, 5, 6, 7, 8];
    console.log(onlyEven(numbers)); // prints [2, 4, 6, 8]
    console.log(onlyOdd(numbers)); // prints [1, 3, 5, 7]

**_R.modulo_** takes 2 parameters. The first is the **_dividend_** (what’s being divided) and the second is the **_divisor_** (what we’re dividing by).

The **_isOdd_** function is just the remainder of dividing by 2\. A remainder of 0 is **_falsy_**, not odd, and a remainder of 1 is **_truthy_**, odd. We flipped the first and second parameters of **_modulo_** so that we could specify 2 as the divisor.

The **_isEven_** function is just the **_complement_** of **_isOdd_**.

The **_onlyOdd_** function is the **_filter_** function with the **_predicate_** (a function that returns a boolean) of **_isOdd_**. It’s waiting for the list of numbers, its final parameter, before it executes.

The **_onlyEven_** function is a **_filter_** that uses **_isEven_** as its predicate.

When we pass **_numbers_** to **_onlyEven_** and **_onlyOdd,_** **_isEven_** and **_isOdd_** get their final parameters and can finally execute returning the numbers we’d expect.

#### Javascript Shortcomings









![](https://cdn-images-1.medium.com/max/1600/1*GjSzT5C7dKD0GPgSZVFGIw.png)





With all of the libraries and language enhancements that have gotten Javascript this far, it still suffers from the fact that it’s an Imperative Language that’s trying to be all things to all people.

Most front end developers are stuck using Javascript in the browser because it’s been the only choice for so long. But many developers are now moving away from writing Javascript directly.

Instead, they are writing in a different language and compiling, or more accurately, transpiling to Javascript.

CoffeeScript was one of the first of these languages. And now, Typescript has been adopted by Angular 2\. Babel can also be considered a transpiler for Javascript.

More and more people are taking this approach in production.

But these languages started with Javascript and only made it slightly better. Why not go all the way and transpile to Javascript from a Pure Functional Language?

#### Elm









![](https://cdn-images-1.medium.com/max/1600/1*oVJSlb6bJfNCXYacQmcvew.png)





In this series, we’ve looked at Elm to help understand Functional Programming.

**_But what is Elm? And how can I use it?_**

Elm is a Pure Functional Language that compiles to Javascript so you can use it to create Web Applications using [The Elm Architecture](https://guide.elm-lang.org/architecture/), aka TEA (this architecture inspired the developers of Redux).

Elm programs do NOT have any Runtime Errors.

Elm is being used in production at companies such as [NoRedInk](https://www.noredink.com/), where Evan Czapliki the creator of Elm now works (he previously worked for [Prezi](https://prezi.com/)).

See this talk, [6 Months of Elm in Production](https://www.youtube.com/watch?v=R2FtMbb-nLs), by Richard Feldman from NoRedInk and Elm evangelist for more information.

**_Do I have to replace all of my Javascript with Elm?_**

No. You can incrementally replace parts. See this blog entry, [How to use Elm at Work](http://elm-lang.org/blog/how-to-use-elm-at-work), to learn more.

**_Why learn Elm?_**

1.  Programming in a Pure Functional Language is both limiting and freeing. It limits what you can do (mostly by keeping you from shooting yourself in the foot) but at the same time it frees you from bugs and bad design decisions since all Elm programs follow The Elm Architecture, a Functionally Reactive Model.
2.  Functional Programming will make you a better programmer. The ideas in this article are only the tip of the iceberg. You really need to see them in practice to really appreciate how your programs will shrink in size and grow in stability.
3.  Javascript was initially built in 10 days and then patched for the last two decades to become a somewhat functional, somewhat object-oriented and a fully imperative programming language.  
    Elm was designed using what has been learned in the last 30 years of work in the Haskell community, which draws from decades of work in mathematics and computer science.  
    The Elm Architecture (TEA) was designed and refined over the years and is a result of Evan’s thesis in Functional Reactive Programming. Watch [Controlling Time and Space](https://www.youtube.com/watch?v=Agu6jipKfYw) to appreciate the level of thinking that went into the formulation of this design.
4.  Elm is designed for front-end web developers. It’s aimed at making their lives easier. Watch [Let’s Be Mainstream](https://www.youtube.com/watch?v=oYk8CKH7OhE) to better understand this goal.

#### The Future









![](https://cdn-images-1.medium.com/max/1600/1*0FpreasFPaa5rYns6Mpe6w.png)





It’s impossible to know what the future will hold, but we can make some educated guesses. Here are some of mine:

> There will be a clear move toward languages that compile to Javascript.

> Functional Programming ideas that have been around for over 40 years will be rediscovered to solve our current software complexity problems.

> The state of hardware, e.g. gigabytes of cheap memory and fast processors, will make functional techniques viable.

> CPUs will not get faster but the number of cores will continue to increase.

> Mutable state will be recognized as one of the biggest problems in complex systems.

I wrote this series of articles because I believe that Functional Programming is the future and because I struggled over the last couple of years to learn it (I’m still learning).

My goal is to help others learn these concepts easier and faster than I did and to help others become better programmers so that they can have more marketable careers in the future.

Even if my prediction that Elm will be a huge language in the future is wrong, I can say with certainty that Functional Programming and Elm will be on the trajectory to whatever the future holds.

I hope that after reading this series, you feel more confident in your abilities and your understanding of these concepts.

I wish you luck in your future endeavors.

_If you liked this, click the![💚](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f49a.png) below so other people will see this here on Medium._

If you want to join a community of web developers learning and helping each other to develop web apps using Functional Programming in Elm please check out my Facebook Group, **_Learn Elm Programming_**[https://www.facebook.com/groups/learnelm/](https://www.facebook.com/groups/learnelm/)

