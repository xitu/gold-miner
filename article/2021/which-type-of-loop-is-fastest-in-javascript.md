> * 原文地址：[Which type of loop is fastest in JavaScript?](https://medium.com/javascript-in-plain-english/which-type-of-loop-is-fastest-in-javascript-ec834a0f21b9)
> * 原文作者：[kushsavani](https://kushsavani.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Which-type-of-loop-is-fastest-in-JavaScript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Which-type-of-loop-is-fastest-in-JavaScript.md)
> * 译者：
> * 校对者：

# Which type of loop is fastest in JavaScript?
Learn which for loop or iterator suits your requirement and stops you from making silly mistakes that cost your app performance.

[https://miro.medium.com/max/10944/0*FjGuCxH-seN1PrRF](https://miro.medium.com/max/10944/0*FjGuCxH-seN1PrRF)

Photo by [Artem Sapegin](https://unsplash.com/@sapegin?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

JavaScript is a new sensation of web development. Not only JS frameworks like NodeJS, React, Angular Vue, etc. But, also vanilla JS has a large fan base. Let’s talk about modern JavaScript. Loops have always been a big part of most programming languages. Modern JS gives you lots of ways to iterate or looping over your values.

But question is that do you really know which loop or iterate fits best according to your requirement. There are plenty of options available in for loops, `for` , `for(reverse)`, `for...of` , `foreach` , `for...in` , `for...await` . This article will cover one such debate.

# **Which for loop is faster?**

**Answer:** `for (reverse)`

The most surprising thing is when I tested it on a local machine I started believing that `for (reverse)` is the fastest among all the for loops. Let me share one example. Take an `array` with over 1 million items and execute for a loop.

***Disclaimer**: console.time() result accuracy highly depends on your system configuration. Get a closer look at accuracy [here](https://johnresig.com/blog/accuracy-of-javascript-time/).*

```
const million = 1000000; 
const arr = Array(million);console.time('⏳');

for (let i = arr.length; i > 0; i--) {} // for(reverse) :- 1.5msfor (let i = 0; i < arr.length; i++) {} // for          :- 1.6ms

arr.forEach(v => v)                     // foreach      :- 2.1msfor (const v of arr) {}                 // for...of     :- 11.7ms

console.timeEnd('⏳');
```

Reason: Here, forward and reverse for loop take almost the same time. Just a 0.1ms difference is there because `for(reverse)` calculate a starting variable `let i = arr.length` only once. While in the forward `for` loop it checks the condition `i < arr.length` after every increment of a variable. This slightest difference won’t matter, you can ignore it.

On the other half `foreach` is a method of an array prototype. Compare to normal `for` loop, `foreach` and `for...of` spend more time on iteration in the array.

# **Types of loop, and where should you use them**

## **1. For loop (forward and reverse)**

Maybe everyone is familiar with this loop. You can use `for` loop, where you need, run a repeated block of code for fix counter times. The traditional `for` loop is the fastest, so you should always use that right? Not so fast - performance is not the only thing that matters. *Code Readability* is usually more important, so default to the style that fits your application.

## **2. forEach**

This method accepts a callback function as input parameters and for every element from an array, this callback function executes. Also, `foreach` the callback function accepts a current value and respective index. `foreach` also, allow to use `this` for optional parameters within the callback function.

```
const things = ['have', 'fun', 'coding'];const callbackFun = (item, idex) => {
    console.log(`${item} - ${index}`);
}things.foreach(callbackFun); o/p:- have - 0
      fun - 1
      coding - 2
```

Note:- If you use `foreach` you can’t take leverage of short-circuiting in JavaScript. If you don’t know about short-circuiting, let me introduce you. When we use a logical operator like `AND(&&)`, `OR(||)` in JavaScript, It will help us early-terminate and/or skip an iteration of a loop.

## **3. For…of**

The `for...of` is standardized in ES6(ECMAScript 6). The `for...of` create a loop iterating on an iterable object like an array, map, set, string, etc. Another plus point of this loop is better readability.

```
const arr = [3, 5, 7];
const str = 'hello';for (let i of arr) {
   console.log(i); // logs 3, 5, 7
}for (let i of str) {
   console.log(i); // logs 'h', 'e', 'l', 'l', 'o'
}
```

Note:- Don’t reuse `for...of` on generators, even if `for...of` is terminated early. After exiting the loop, the generator is turned off, and trying to repeat it again yields no further results.

## **4. For…in**

The `for...in` iterates a specified variable over all the enumerable properties of an object. For each distinct property, the `for...in` statement will return the name of your user-defined properties in addition to the numeric indexes.

Therefore, it is better to use a traditional `for` loop with a numeric index when iterating over arrays. Because the `for...in` statement iterates over user-defined properties in addition to the array elements, even if you modify the array object (such as adding custom properties or methods).

```
const details = {firstName: 'john', lastName: 'Doe'};
let fullName = '';for (let i in details) {
    fullName += details[i] + ' '; // fullName: john doe
}
```

Difference between `for..of` and `for...in`

The main difference between `for..of` and `for...in` is what they iterate over. The `for...in` loops iterate over the properties of an object while the `for...of` loops iterate over the values of an iterable object.

```
let arr= [4, 5, 6];

for (let i in arr) {
   console.log(i); // '0', '1', '2'
}

for (let i of arr) {
   console.log(i); // '4', '5', '6'
}
```

[https://miro.medium.com/max/12000/0*E9FPH2LFeFnTGWF5](https://miro.medium.com/max/12000/0*E9FPH2LFeFnTGWF5)

Photo by [Tine Ivanič](https://unsplash.com/@tine999?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

## **Conclusion**

- `for` fastest, but poor in readability.
- `foreach` fast, control over iteration property.
- `for...of` slow, but sweeter.
- `for...in` slow, less handy.

In the end, a wise piece of advice for you. Set your priority to readability. When you are developing a complex structure at that time code readability is essential but you should also stay focused on performance. Try to avoid adding unnecessarily extra garnish in your code sometimes it costly for your app performance. Have fun coding.