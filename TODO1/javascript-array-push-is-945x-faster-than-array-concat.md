> * 原文地址：[Javascript Array.push is 945x faster than Array.concat 🤯🤔](https://dev.to/uilicious/javascript-array-push-is-945x-faster-than-array-concat-1oki)
> * 原文作者：[Shi Ling](https://dev.to/shiling)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-array-push-is-945x-faster-than-array-concat.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-array-push-is-945x-faster-than-array-concat.md)
> * 译者：
> * 校对者：

# Javascript Array.push is 945x faster than Array.concat 🤯🤔

If you are merging arrays with thousands of elements across, you can shave off seconds from the process by using `arr1.push(...arr2)` instead of `arr1 = arr1.concat(arr2)`. If you really to go faster, you might even want to write your own implementation to merge arrays.

## Wait a minute... how long does it take to merge 15,000 arrays with `.concat`...

Recently, we had a user complaining of a major slowdown in the execution of their UI tests on [UI-licious](https://uilicious.com). Each `I.click` `I.fill` `I.see` command which usually takes ~1 second to complete (post-processing e.g. taking screenshots) now took over 40 seconds to complete , so test suites that usually completed under 20 minutes took hours instead and was severely limiting their deployment process.

It didn't take long for me to set up timers to narrow down out which part of the code was causing the slowdown, but I was pretty surprised when I found the culprit:

```
arr1 = arr1.concat(arr2)
```

Array's `.concat` method.

In order to allow tests to be written using simple commands like `I.click("Login")` instead of CSS or XPATH selectors `I.click("#login-btn")`, UI-licious works using dynamic code analysis to analyse the DOM tree to determine what and how to test your website based on semantics, accessibility attributes, and popular but non-standard patterns. The `.concat` operations was being used to flatten the DOM tree for analysis, but worked very poorly when the DOM tree was very large and very deep, which happened when our user recently pushed an update to their application that caused their pages to bloat significantly (that's another performance issue on their side, but it's another topic).

**It took 6 seconds to merge 15,000 arrays that each had an average size of 5 elements with `.concat`.**

**What?**

6 seconds...

For 15,000 arrays with the average size of 5 elements?

**That's not a lot data.**

Why is it so slow? Are there faster ways to merge arrays?

* * *

## Benchmark comparisons

### .push vs. .concat for 10000 arrays with 10 elements each

So I started researching (by that, I mean googling) benchmarks for `.concat` compared to other methods to merge arrays in Javascript.

It turns out the fastest method to merge arrays is to use `.push` which accepts n arguments:

```
// Push contents of arr2 to arr1
arr1.push(arr2[0], arr2[1], arr2[3], ..., arr2[n])

// Since my arrays are not fixed in size, I used `apply` instead
Array.prototype.push.apply(arr1, arr2)
```

And it is faster by leaps in comparison.

How fast?

I ran a few performance benchmarks on my own to see for myself. Lo and behold, here's the difference on Chrome:

[![JsPerf - .push vs. .concat 10000 size-10 arrays (Chrome)](https://res.cloudinary.com/practicaldev/image/fetch/s--I6TQ4Ugm--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/txrl0qpb5oz46mqfy3zn.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--I6TQ4Ugm--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/txrl0qpb5oz46mqfy3zn.PNG)

👉 [Link to the test on JsPerf](https://jsperf.com/javascript-array-concat-vs-push/100)

To merge arrays of size 10 for 10,000 times, `.concat` performs at 0.40 ops/sec, while `.push` performs at 378 ops/sec. `push` is 945x faster than `concat`! This difference might not be linear, but it is already is already significant at this small scale.

And on Firefox, here's the results:

[![JsPerf - .push vs. .concat 10000 size-10 arrays (Firefox)](https://res.cloudinary.com/practicaldev/image/fetch/s--1syE91oa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/i8qyutk1h1azih06rn4z.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--1syE91oa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/i8qyutk1h1azih06rn4z.PNG)

Firefox's SpiderMonkey Javascript engine is generally slower compared to Chrome's V8 engine, but `.push` still comes out top, at 2260x faster.

This one change to our code fixed the entire slowdown problem.

### .push vs. .concat for 2 arrays with 50,000 elements each

But ok, what if you are not merging 10,000 size-10 arrays, but 2 giant arrays with 50000 elements each instead?

Here's the the results on Chrome along with results:

[![JsPerf - .push vs. .concat 2 size-50000 arrays (chrome)](https://res.cloudinary.com/practicaldev/image/fetch/s--pmnpnick--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/7euccbt97unwnjjdq5iw.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--pmnpnick--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/7euccbt97unwnjjdq5iw.PNG)

👉 [Link to the test on JsPerf](https://jsperf.com/javascript-array-concat-vs-push/170)

`.push` is still faster than `.concat`, but a factor of 9.

Not as dramatic as 945x slower, but still dang slow.

* * *

### Prettier syntax with rest spread

If you find `Array.prototype.push.apply(arr1, arr2)` verbose, you can use a simple variant using the rest spread ES6 syntax:

```
arr1.push(...arr2)
```

The performance difference between `Array.prototype.push.apply(arr1, arr2)` and `arr1.push(...arr2)` is negligable.

* * *

## But why is `Array.concat` so slow?

It lot of it has to do with the Javascript engine, but I don't know the exact answer, so I asked my buddy [@picocreator](https://dev.to/picocreator) , the co-creator of [GPU.js](http://gpu.rocks/), as he had spent a fair bit of time digging around the V8 source code before. [@picocreator](https://dev.to/picocreator) 's also lent me his sweet gaming PC which he used to benchmark GPU.js to run the JsPerf tests because my MacBook didn't have the memory to even perform `.concat` with two size-50000 arrays.

Apparently the answer has a lot to do with the fact that `.concat` creates a new array while `.push` modifies the first array. The additional work `.concat` does to add the elements from the first array to the returned array is the main reason for the slowdown.

> Me: "What? Really? That's it? But by that much? No way!"  
> @picocreator: "Serious, just try writing some naive implementations of .concat vs .push then!"

So I tried writing some naive implementations of `.concat` and `.push`. Several in fact, plus a comparison with [lodash](https://lodash.com/)'s `_.concat`:

[![JsPerf - Various ways to merge arrays (Chrome)](https://res.cloudinary.com/practicaldev/image/fetch/s--hIgqWvh5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/w00r7grlnl1x5bnprrqy.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--hIgqWvh5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/w00r7grlnl1x5bnprrqy.PNG)

👉 [Link to the test on JsPerf](https://jsperf.com/merge-array-implementations/1)

### Naive implementation 1

Let's talk about the first set of naive implementation:

#### Naive implementation of `.concat`

```
// Create result array
var arr3 = []

// Add Array 1
for(var i = 0; i < arr1Length; i++){
  arr3[i] = arr1[i]
}

// Add Array 2
for(var i = 0; i < arr2Length; i++){
  arr3[arr1Length + i] = arr2[i]
}
```

#### Naive implementation of `.push`

```
for(var i = 0; i < arr2Length; i++){
  arr1[arr1Length + i] = arr2[i]
}
```

As you can see, the only difference between the two is that the `.push` implementation modifies the first array directly.

#### Results of vanilla methods:

*   `.concat` : 75 ops/sec
*   `.push`: 793 ops/sec (10x faster)

#### Results of naive implementation 1

*   `.concat` : 536 ops/sec
*   `.push` : 11,104 ops/sec (20x faster)

It turns that my DIY `concat` and `push` is faster than the vanilla implementations... But here we can see that simply creating a new result array and copying the content of the first array over slows down the process significantly.

### Naive implementation 2 (Preallocate size of the final array)

We can further improve the naive implementations by preallocating the size of the array before adding the elements, and this makes a huge difference.

#### Naive implementation of `.concat` with pre-allocation

```
// Create result array with preallocated size
var arr3 = Array(arr1Length + arr2Length)

// Add Array 1
for(var i = 0; i < arr1Length; i++){
  arr3[i] = arr1[i]
}

// Add Array 2
for(var i = 0; i < arr2Length; i++){
  arr3[arr1Length + i] = arr2[i]
}
```

#### Naive implementation of `.push` with pre-allcation

```
// Pre allocate size
arr1.length = arr1Length + arr2Length

// Add arr2 items to arr1
for(var i = 0; i < arr2Length; i++){
  arr1[arr1Length + i] = arr2[i]
}
```

#### Results of naive implementation 1

*   `.concat` : 536 ops/sec
*   `.push` : 11,104 ops/sec (20x faster)

#### Results of naive implementation 2

*   `.concat` : 1,578 ops/sec
*   `.push` : 18,996 ops/sec (12x faster)

Preallocating the size of the final array improves the performance by 2-3 times for each method.

### `.push` array vs. `.push` elements individually

Ok, what if we just .push elements individually? Is that faster than `Array.prototype.push.apply(arr1, arr2)`

```
for(var i = 0; i < arr2Length; i++){
  arr1.push(arr2[i])
}
```

#### Results

*   `.push` entire array: 793 ops/sec
*   `.push` elements individually: 735 ops/sec (slower)

So doing `.push` on individual elements is slower than doing `.push` on the entire array. Makes sense.

## Conclusion: Why `.push` is faster `.concat`

In conclusion, it is true that the main reason why `concat` is so much slower than `.push` is simply that it creates a new array and does the additional work to copy the first array over.

That said, now there's another mystery to me...

## Another mystery

Why are the vanilla implementations so much slower than the naive implementations?🤔I asked for [@picocreator](https://dev.to/picocreator) 's help again.

We took a look at lodash's `_.concat` implementation for some hints as to what else is vanilla `.concat` doing under the hood, as it is comparable in performance (lodash's is slightly faster).

It turns out that because according to the vanilla's `.concat`'s specs, the method is overloaded, and supports two signatures:

1.  Values to append as n number of arguments, e.g. `[1,2].concat(3,4,5)`
2.  The array to append itself, e.g. `[1,2].concat([3,4,5])`

You can even do both like this: `[1,2].concat(3,4,[5,6])`

Lodash also handles both overloaded signatures, and to do so, lodash puts all the arguments into an array, and flattens it. It make sense if you are passing in several arrays as arguments. But when passed an array to append, it doesn't just use the array as it is, it copies that into another array, and then flattens it.

... ok...

Definitely could be more optimised. And this is why you might want to DIY your own merge array implementation.

Also, it's just my and [@picocreator](https://dev.to/picocreator) 's theory of how vanilla `.concat` works under the hood based on Lodash's source code and his slightly outdated knowledge of the V8 source code.

You can read the lodash's source code at your leisure [here](https://github.com/lodash/lodash/blob/4.17.11/lodash.js#L6913).

* * *

### Additional Notes

1.  The tests are done with Arrays that only contain Integers. Javascript engines are known to perform faster with Typed Arrays. The results are expected to be slower if you have objects in the arrays.
    
2.  Here are the specs for the PC used to run the benchmarks:  

[![PC specs for the performance tests](https://res.cloudinary.com/practicaldev/image/fetch/s--rsJtFcLH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/fl7utbii6ivyifs66q2t.PNG)](https://res.cloudinary.com/practicaldev/image/fetch/s--rsJtFcLH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/fl7utbii6ivyifs66q2t.PNG)
    

* * *

## Why are we doing such large array operations during UI-licious tests anyway?

[![Uilicious Snippet dev.to test](https://res.cloudinary.com/practicaldev/image/fetch/s--5llcnkKt--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/gyrtj5lk2b2bn89z7ra1.gif)](https://snippet.uilicious.com/test/public/1cUHCW368zsHrByzHCkzLE)

Under the hood, the UI-licious test engine scans the DOM tree of the target application, evaluating the semantics, accessible attributes and other common patterns to determine what is the target element and how to test it.

This is so that we can make sure tests can be written as simple as this:

```
// Lets go to dev.to
I.goTo("https://dev.to")

// Fill up search
I.fill("Search", "uilicious")
I.pressEnter()

// I should see myself or my co-founder
I.see("Shi Ling")
I.see("Eugene Cheah")
```

Without the use of CSS or XPATH selectors, so that the tests can be more readable, less sensitive to changes in the UI, and easier to maintain.

### ATTENTION: Public service announcement - Please keep your DOM count low!

Unfortunately, there's a trend of DOM trees growing excessively large these days because people are building more and more complex and dynamic applications with modern front-end frameworks. It's a double-edge sword, frameworks allow us to develop faster, folks often forget how much bloat frameworks add. I sometimes cringe at the number of elements that are just there to wrap other elements when inspecting the source code of various websites.

If you want to find out whether your website has too many DOM nodes, you can run a [Lighthouse](https://developers.google.com/web/tools/lighthouse/) audit.

[![Google Lighthouse](https://res.cloudinary.com/practicaldev/image/fetch/s--OZ3aIjva--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://developers.google.com/web/progressive-web-apps/images/pwa-lighthouse.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--OZ3aIjva--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://developers.google.com/web/progressive-web-apps/images/pwa-lighthouse.png)

According to Google, the optimal DOM tree is:

*   Less than 1500 nodes
*   Depth size of less than 32 levels
*   A parent node has less than 60 children

A quick audit on the Dev.to feed shows that the DOM tree size is pretty good:

*   Total count of 941 nodes
*   Max. depth of 14
*   Max number of child elements at 49

Not bad!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
