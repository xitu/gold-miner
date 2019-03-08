> * 原文地址：[Understanding a Performance Issue with “Polymorphic” JSON Data](https://medium.com/wolfram-developers/understanding-a-performance-issue-with-polymorphic-json-data-e7e4cd079be0)
> * 原文作者：[Jan Pöschko](https://medium.com/@poeschko)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-a-performance-issue-with-polymorphic-json-data.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-a-performance-issue-with-polymorphic-json-data.md)
> * 译者：
> * 校对者：

# Understanding a Performance Issue with “Polymorphic” JSON Data

> How objects with the same shape but different kinds of values can have a surprising effect on JavaScript performance

![Photo by [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11520/0*g6D9UP-cs6jMRzrx)

While working on some [low-level performance optimizations](https://medium.com/wolfram-developers/performance-through-elegant-javascript-15b98f0904de) for rendering of [Wolfram Cloud](https://www.wolframcloud.com/) notebooks, I noticed a rather strange issue where a function entered a slower execution path due to dealing with floating-point numbers, even though all data ever passed into it were integers. Specifically, *cell counters* were treated as floating-point numbers by the JavaScript engine, which slowed down rendering of large notebooks quite a bit (at least in Chrome).

We represent cell counters (defined by [CounterAssignments](https://reference.wolfram.com/language/ref/CounterAssignments.html) and [CounterIncrements](https://reference.wolfram.com/language/ref/CounterIncrements.html)) as an array of integers, with a separate mapping from counter names to offsets in the array. This is a bit more efficient than storing a dictionary for each set of counters. E.g. instead of

```js
    {Title: 1, Section: 3, Input: 7}
```

we store an array

```js
    [1, 3, 7]
```

and keep a separate (global) mapping

```js
    {Title: 0, Section: 1, Input: 2}
```

from names to indices. As we render a notebook, each cell keeps its own copy of the current counter values, performs its own assignments and increments (if any), and passes on a new array to the next cell.

I found out that — at least sometimes — V8 (the JS engine in Chrome and Node.js) treated the numeric arrays as if they contained floating-point numbers. This slows down many operations on them, since the memory layout for floats is not as efficient as for (small) integers. This felt strange since the arrays never contained anything but such [*Smi*s](https://v8.dev/blog/elements-kinds) (integers in the signed 31-bit range, i.e. from -2³⁰ to 2³⁰-1).

I found a workaround, “forcing” all values to turn into integers by applying value | 0 before putting them into the counter arrays, after reading them from some JSON object — even though they already were integers in the JSON data anyway. While I had a workaround, I didn’t fully understand *why* it was actually working — until recently…

## The explanation

The talk [JavaScript engine fundamentals: the good, the bad, and the ugly](https://slidr.io/bmeurer/javascript-engine-fundamentals-the-good-the-bad-and-the-ugly#1) by [Mathias Bynens](https://twitter.com/mathias) and [Benedikt Meurer](https://twitter.com/bmeurer) at [AgentConf](https://www.agent.sh/) finally cleared things up for me: It’s all about the internal representation of objects in the JS engine, and how each object is linked to a certain *shape*.

The JS engine keeps track of the property names defined on an object, and whenever a property is added or removed, a different shape is used in the background. Objects of the same shape keep the same property at the same offset in memory (relative to the object’s address), allowing the engine to speed up property access significantly and reducing the memory boilerplate of individual object instances (they don’t have to maintain a whole dictionary themselves).

What I hadn’t known before was that the shape also distinguishes between different *kinds* of property values. Particularly, a property with small-integer values implies a different shape than a property that (sometimes) contains other numeric values. E.g. in

```js
const b = {};
b.x = 2;
b.x = 0.2;
```

a shape transition happens with the second assignment, from a shape where property x is known to have a *Smi* value to a shape where property x can be any *Double*. The previous shape is then “deprecated” and not used anymore moving forward. Even other objects that never actually used a non-Smi value will switch to the new shape as soon as their property x is used in any way. [This slide](https://slidr.io/bmeurer/javascript-engine-fundamentals-the-good-the-bad-and-the-ugly#140) sums it up very well.

So this is exactly what happened in our case with counters: The definitions of CounterAssignments and CounterIncrements came from JSON data such as

```js
    {"type": "MInteger", "value": 2}
```

but we also had values like

```js
    {"type": "MReal", "value": 0.2}
```

for other parts of a notebook. Even though no MReal objects were used for counters, the *mere existence* of such objects caused all MInteger objects to also change their shape. Copying their value into the counter arrays then caused those arrays to switch to a less efficient representation as well.

## Inspecting internal types in Node.js

We can inspect what’s going on under the hood in V8 by using *natives syntax*. This is enabled with the command-line argument --allow-natives-syntax. The full list of special functions is not officially documented but there is [an unofficial list](https://gist.github.com/totherik/3a4432f26eea1224ceeb). There is also a package [v8-natives](https://github.com/NathanaelA/v8-Natives) for slightly more convenient access.

In our case, we can use %HasSmiElements to determine whether a given array has Smi elements:

```js
const obj = {};
obj.value = 1;
const arr1 = [obj.value, obj.value];
console.log(`arr1 has Smi elements: ${%HasSmiElements(arr1)}`);

const otherObj = {};
otherObj.value = 1.5;

const arr2 = [obj.value, obj.value];
console.log(`arr2 has Smi elements: ${%HasSmiElements(arr2)}`);
```

Running this program gives the following output:

```shell
$ node --allow-natives-syntax inspect-types.js
arr1 has Smi elements: true
arr2 has Smi elements: false
```

After constructing an object with the same shape but a floating-point value, using the original object (containing an integer value) again yields a non-Smi array.

## Measuring the impact on a standalone example

To illustrate the effect on performance, let’s use the following JS program (counters-smi.js):

```js
function copyAndIncrement(arr) {
  const copy = arr.slice();
  copy[0] += 1;
  return copy;
}

function main() {
  const obj = {};
  obj.value = 1;
  let arr = [];
  for (let i = 0; i < 100; ++i) {
    arr.push(obj.value);
  }
  for (let i = 0; i < 10000000; ++i) {
    arr = copyAndIncrement(arr);
  }
}

main();
```

We construct an array of 100 integers extracted from an object obj, and then we call copyAndIncrement 10 million times, which creates a copy of the array, changes one item in the copy, and returns the new array. This is essentially what happens when cell counters are processed while rendering a (large) notebook.

Let’s change the program a bit and add the following code in the beginning (counters-float.js):

```js
    const objThatSpoilsEverything = {};
    objThatSpoilsEverything.value = 1.5;
```

The mere existence of this object will cause the other obj to change its shape and slow down operations on the arrays constructed from its value.

Note that creating an empty object and adding a property later has the same effect as parsing a JSON string:

```js
    const objThatSpoilsEverything = JSON.parse('{"value": 1.5}');
```

Now compare the execution of these two programs:

``` shell
$ time node counters-smi.js
node counters-smi.js  0.87s user 0.11s system 103% cpu 0.951 total

$ time node counters-float.js
node counters-float.js  1.22s user 0.13s system 103% cpu 1.309 total
```

This is with Node v11.9.0 (running V8 version 7.0.276.38-node.16). But let’s try all major JS engines:

![](https://cdn-images-1.medium.com/max/2000/1*DBcx2JPXO70Sw72-nPF60g.jpeg)

```shell
$ npm i -g jsvu

$ jsvu

$ v8 -v
V8 version 7.4.221

$ spidermonkey -v
JavaScript-C66.0

$ chakra -v
ch version 1.11.6.0

$ jsc
```

V8 is used in Chrome, SpiderMonkey in Firefox, Chakra in IE and Edge, JavaScriptCore in Safari.

Measuring execution time of the whole process isn’t ideal, but we can mitigate outliers by focusing on the median of 100 runs per example (in randomized order, sleeping 1 second between runs) using [multitime](https://github.com/ltratt/multitime):

```shell
$ multitime -n 100 -s 1 -b examples.bat
===> multitime results
1: v8 counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        0.767       0.014       0.738       0.765       0.812
user        0.669       0.012       0.643       0.666       0.705
sys         0.086       0.003       0.080       0.085       0.095

2: v8 counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        0.854       0.016       0.829       0.851       0.918
user        0.750       0.019       0.662       0.750       0.791
sys         0.088       0.004       0.082       0.087       0.107

3: spidermonkey counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        1.378       0.024       1.355       1.372       1.538
user        1.362       0.011       1.346       1.360       1.408
sys         0.074       0.005       0.067       0.073       0.101

4: spidermonkey counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        1.406       0.021       1.385       1.400       1.506
user        1.389       0.011       1.374       1.387       1.440
sys         0.075       0.005       0.068       0.074       0.093

5: chakra counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        2.285       0.051       2.193       2.280       2.494
user        2.359       0.044       2.291       2.354       2.560
sys         0.203       0.032       0.141       0.202       0.268

6: chakra counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        2.292       0.050       2.195       2.286       2.444
user        2.365       0.042       2.284       2.360       2.501
sys         0.207       0.031       0.141       0.209       0.277

7: jsc counters-smi.js
            Mean        Std.Dev.    Min         Median      Max
real        1.042       0.031       1.009       1.034       1.218
user        1.051       0.013       1.030       1.050       1.093
sys         0.336       0.013       0.319       0.333       0.394

8: jsc counters-float.js
            Mean        Std.Dev.    Min         Median      Max
real        1.041       0.025       1.012       1.038       1.246
user        1.054       0.012       1.032       1.056       1.099
sys         0.338       0.014       0.315       0.335       0.397
```

A few things to note here:

* Only in V8, there’s a significant difference (about 0.08s or 10%) between the two approaches.

* V8 is faster than all other engines, for both the Smi and the float approach.

* Standalone V8 as used here was significantly faster than Node 11.9 (which uses an older version of V8). I guess this is mostly due to general performance improvements in more recent V8 versions (notice how the difference between Smi and float approach was reduced from 0.35s to 0.08s), but some overhead of Node compared to V8 might also be at play.

You can look at the [full source of the test file](https://gist.github.com/poeschko/7e94a825f5be4fb509ee54e27b4f18c0). All tests were performed on a late-2013, 15" MacBook Pro running macOS 10.14.3 with a 2.6 GHz i7 CPU.

## Conclusion

Shape transitions in V8 can have some surprising performance consequences. Usually, you don’t have to worry about this in practice (especially since V8, even on its “slow” path, might still be faster than other engines). But in a highly performance-critical application, it’s good to keep in mind the effects of a “global” shape table, where distant parts of an application can affect one another.

If you’re dealing with external JSON data not under your control, you can “convert” a value to an integer using bitwise OR as in value | 0, which will also make sure its internal representation is a Smi.

If you have control over the JSON data, it might be a good idea to only use the same property names for properties with the same underlying value type. E.g. in our case it might be better to use

```js
{"type": "MInteger", "intValue": 2}
{"type": "MReal", "realValue": 2.5}
```

instead of calling the property value in both cases. In other words: Avoid “polymorphic” objects.

Even if the effects on performance are neglible in practice, it’s always interesting to get a better understanding of what’s going on under the hood, in this case of V8. For me personally, it was a great aha moment when I found out *why* an optimization I made a year ago actually worked.

For further information, here are links to various talks again:

* Slides: [JavaScript engine fundamentals: the good, the bad, and the ugly](https://slidr.io/bmeurer/javascript-engine-fundamentals-the-good-the-bad-and-the-ugly#1)

* Video & material: [Shapes and Inline Caches](https://benediktmeurer.de/2018/06/14/javascript-engine-fundamentals-shapes-and-inline-caches/), [Optimizing Prototypes](https://benediktmeurer.de/2018/08/16/javascript-engine-fundamentals-optimizing-prototypes/)

* Talk: [Element kinds in V8](https://v8.dev/blog/elements-kinds)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
