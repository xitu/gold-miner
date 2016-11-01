> * 原文地址：[What I learned from writing six functions that all did the same thing](https://medium.freecodecamp.com/what-i-learned-from-writing-six-functions-that-all-did-the-same-thing-b38fd48f0d55#.tt79h3s25)
* 原文作者：[Jackson Bates](https://medium.freecodecamp.com/@JacksonBates)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Romeo0906](https://github.com/Romeo0906)
* 校对者：

# What I learned from writing six functions that all did the same thing

# 在我写了六个功能相同的函数之后，我学到了什么


A couple weeks ago, a camper started an unofficial algorithm competition on [Free Code Camp’s Forum](http://forum.freecodecamp.com/t/javascript-algorithm-challenge-october-9-through-16/44096?u=jacksonbates).

几周之前，一个社区在 [Free Code Camp’s Forum](http://forum.freecodecamp.com/t/javascript-algorithm-challenge-october-9-through-16/44096?u=jacksonbates) 上发起了非官方的算法大赛。

The challenge seemed simple enough: return the sum of all multiples of 3 or 5 that are below a number N, where N is an input parameter to the function.

这个题目看似很简单：返回小于数字 N 的所有 3 或者 5 的倍数的和，N 是输入的参数。

But instead of just finding any solution, [P1xt](https://medium.com/u/bf42d244c85)’s competition required you to focus on efficiency. It encouraged you to write your own tests, and to benchmark the performance of your solutions.

但不是简单的找到解决办法，[P1xt](https://medium.com/u/bf42d244c85) 的竞赛要求参赛者把重点放在效率上，它鼓励你写出你自己的方法，同时还鼓励自我评估。

This is a breakdown of every function I tried and tested, including my tests and benchmark scripts. At the end, I’ll show the function that blew all of my own out of the water, and taught me a valuable lesson.

以下是我写出并测试过的每个函数的评估，包括我的测试和评估手稿。最后，我将展示最终的赢家，就是那个将我所有的作品杀的片甲不留然后狠狠地给我上了一课的函数。

![](https://media.giphy.com/media/qhY3EfioLSshO/giphy.gif)

Adding testing to your code rarely hurts…Source: The Simpsons, via [Giphy](http://gph.is/1szb6yu)

给自己的代码做测试，真的是超乎寻常地痛苦啊…… 来自：The Simpsons, 在这里 [Giphy](http://gph.is/1szb6yu)

### Function #1: Array, push, increment

    function arrayPushAndIncrement(n) {
      var array = [];
      var result = 0;
      for (var i = 1; i < n; i ++) {
        if (i % 3 == 0 || i % 5 == 0) {
          array.push(i);
        }
      }
      for (var num of array) {
        result += num;
      }
      return result;
    }

    module.exports = arrayPushAndIncrement; // this is necessary for testing

For problems like this, my brain defaults to: build an array, then do something to that array.

对于这类问题，我的大脑直接闪现：创建一个数组，然后对这个数组进行操作。

This function creates an array and pushes any numbers that meet our condition (divisible by 3 or 5) into it. It then loops through that array, adding all the values together.

这个函数创建了一个数组，并且将符合条件（能够被 3 或者 5 整除）的数字压入数组，之后遍历得到所有单元的和。

### Setting up testing
### 开始测试

Here are the automated tests for this function, which use Mocha and Chai, running on NodeJS.

If you want more information about installing Mocha and Chai, I’ve written [a detailed guide](http://forum.freecodecamp.com/t/testing-your-own-code-using-mocha-and-chai-simple-example/44149?u=jacksonbates) on Free Code Camp’s forum.

I wrote a simple testing script using the values [P1xt](https://medium.com/u/bf42d244c85) provided. Notice that in the script below, the function is included as a module:

    // testMult.js

    var should = require( 'chai' ).should();
    var arrayPushAndIncrement = require( './arrayPushAndIncrement' );

    describe('arrayPushAndIncrement', function() {
      it('should return 23 when passed 10', function() {
        arrayPushAndIncrement(10).should.equal(23);
      })
      it('should return 78 when passed 20', function() {
        arrayPushAndIncrement(20).should.equal(78);
      })
      it('should return 2318 when passed 100', function() {
        arrayPushAndIncrement(100).should.equal(2318);
      })
      it('should return 23331668 when passed 10000', function() {
        arrayPushAndIncrement(10000).should.equal(23331668);
      })
      it('should return 486804150 when passed 45678', function() {
        arrayPushAndIncrement(45678).should.equal(486804150);
      })
    })

When I ran the test using `mocha testMult.js` it returned the following:









![](https://cdn-images-1.medium.com/max/1600/1*tmJwwmFxPQevv_kEKOWPRw.png)





For all future functions in this article, assume they passed all tests. For your own code, add tests for each new function you try.

### Function #2: Array, push, reduce

    function arrayPushAndReduce(n) {
      var array = [];
      for (var i = 1; i < n; i ++) {
        if (i % 3 == 0 || i % 5 == 0) {
          array.push(i);
        }
      }
      return array.reduce(function(prev, current) {
        return prev + current;
      });
    }

    module.exports = arrayPushAndReduce;

So this function uses a similar approach to my previous one, but instead of using a `for` loop to construct the final sum, it uses the fancier `reduce`method.

### Setting up performance benchmark testing

Now that we have two functions, we can compare their efficiency. Again, thanks to [P1xt](https://medium.com/u/bf42d244c85) for providing this script in a previous forum thread.

    // performance.js

    var Benchmark = require( 'benchmark' );
    var suite = new Benchmark.Suite;

    var arrayPushAndIncrement = require( './arrayPushAndIncrement' );
    var arrayPushAndReduce = require( './arrayPushAndReduce' );

    // add tests
    suite.add( 'arrayPushAndIncrement', function() {
      arrayPushAndIncrement(45678)
    })
    .add( 'arrayPushAndReduce', function() {
      arrayPushAndReduce(45678)
    })
    // add listeners
    .on( 'cycle', function( event ) {
        console.log( String( event.target ));
    })
    .on( 'complete', function() {
        console.log( 'Fastest is ' + this.filter( 'fastest' ).map( 'name' ));
    })
    // run async
    .run({ 'async': true });

If you run this with `node performance.js` you’ll see the following terminal output:

    arrayPushAndIncrement x 270 ops/sec ±1.18% (81 runs sampled)
    arrayPushAndReduce x 1,524 ops/sec ±0.79% (89 runs sampled)
    Fastest is arrayPushAndReduce



![](https://media.giphy.com/media/3oGRFKJ8Ea3hKkLRyE/200_s.gif)


Now that’s fast! Source [Giphy](http://gph.is/1UXFu1x)



So using the `reduce` method gave us a function that was **5 times faster**!

If that isn’t encouraging enough to continue with more functions and testing, I don’t know what is!

### Function#3: While, Array, Reduce

Now since I always reach for the trusty `for` loop, I figured I would test a `while` loop alternative:

    function whileLoopArrayReduce(n) {
      var array = [];
      while (n >= 1) {
        n--;
        if (n%3==0||n%5==0) {
          array.push(n);
        }
      }
      return array.reduce(function(prev, current) {
        return prev + current;
      });
    }

    module.exports = whileLoopArrayReduce;

And the result? A tiny bit slower:

    whileLoopArrayReduce x 1,504 ops/sec ±0.65% (88 runs sampled)

### Function#4: While, sum, no arrays

So, finding that the type of loop didn’t make a huge difference, I wondered what would happen if I used a method that avoided arrays altogether:

    function whileSum(n) {
      var sum = 0;
      while (n >= 1) {
        n--;
        if (n%3==0||n%5==0) {
          sum += n;
        }
      }
      return sum;
    }

    module.exports = whileSum;

As soon as I started thinking down this track, it made me realize how wrong I was for _always_ reaching for arrays first…

    whileSum x 7,311 ops/sec ±1.26% (91 runs sampled)

Another massive improvement: nearly **5 times faster** again, and **27 times faster** than my original function!

### **Function#5: For, sum**

Of course, we already know that a for loop should be a little faster:

    function forSum(n) {
      n = n-1;
      var sum = 0;
      for (n; n >= 1 ;n--) {
        (n%3==0||n%5==0) ? sum += n : null;
      }
      return sum;
    }

This uses the ternary operator to do the condition checking, but my testing showed that a non-ternary version of this is the same, performance-wise.

    forSum x 8,256 ops/sec ±0.24% (91 runs sampled)

So, a little faster again.

My final function ended up being **28 times faster** than my original.

I felt like a champion.

I was over the moon.

I rested on my laurels.

### Enter Maths

![](https://media.giphy.com/media/Tf4pP3z2EqowM/giphy.gif)

Learn to love maths: Source [Giphy](http://gph.is/292GnFR) (Originally, [this music video](https://www.youtube.com/watch?v=vpOau9ZxQNY&t=116s))


The week passed and the final solutions from everyone were posted, tested, and collated. The function that performed the fastest avoided loops altogether and used an algebraic formula to crunch the numbers:

    function multSilgarth(N) {
      var threes = Math.floor(--N / 3);
      var fives = Math.floor(N / 5);
      var fifteen = Math.floor(N / 15);

      return (3 * threes * (threes + 1) + 5 * fives * (fives + 1) - 15 * fifteen * (fifteen + 1)) / 2;
    }

    module.exports = multSilgarth;

Wait for it…

    arrayPushAndIncrement x 279 ops/sec ±0.80% (83 runs sampled)
    forSum x 8,256 ops/sec ±0.24% (91 runs sampled)
    maths x 79,998,859 ops/sec ±0.81% (88 runs sampled)
    Fastest is maths

### Fastest is maths

So the winning function was roughly **9,690 times faster** than my best effort, and **275,858 times faster** than my initial effort.

If you need me, I’ll be over at Khan Academy studying math.
