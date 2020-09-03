> * 原文地址：[How to handle JavaScript comparison corner cases](https://medium.com/javascript-in-plain-english/how-to-handle-comparison-corner-cases-c96ae9a17d4a)
> * 原文作者：[Alen Vlahovljak](https://medium.com/@AlenVlahovljak)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-handle-comparison-corner-cases.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-handle-comparison-corner-cases.md)
> * 译者：
> * 校对者：

# How to handle JavaScript comparison corner cases

![Photo by [Joshua Aragon](https://unsplash.com/@goshua13?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/javascript?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/7622/1*cNArmsLDeouV0GoryF4IlA.jpeg)

**“Any sufficiently advanced technology is indistinguishable from magic.”** — Arthur C. Clarke (3rd Clarke’s law)

Before we start to get familiar with JavaScript corner cases, I’d like to make a distinction between **Corner Case** and **Edge Case**.

We can say that **Edge Case is an issue that can occur only at minimum or maximum parameters**. Predicting it can be a significant task since those situations may be neglected or underestimated. For example, a PC at full power can overheat, and its performance may deteriorate a little.

I’d love to introduce a **Boundary Case** also (a subject of the doubt too). It can occur if one of the parameters is beyond the minimum or maximum limits.

What about **Corner Cases**? I won’t give any definition since you’ll be able to do by yourself after you take a look at the next examples.

## You won’t believe this

If I ask you can something be coercive equal to the negation of itself, what would be your answer? You’d probably said that is a nonsense question, but:

```JavaScript
var arr1 = [];
var arr2 = [];


if (arr1 == !arr2) {
    console.log("Yes, it's true!");
}

if (arr1 != arr2) {
    console.log("It's true again!");
}
```

You may think that JS is a crazy language, and this should not happen for a popular language like JS. This example is silly because you will never compare value to the negation of itself in a real example. **But this is a great example to help you clarify and adopt the right mental model.**

**You won’t ever have a situation where are you comparing array with negative arrays.** You won’t ever design code on this way. That is an excellent example of how you don’t want to manage the codebase.

In the next example, I’ll explain what happens in great details, so you can have a clear image of what an algorithm is doing:

```JavaScript
var arr1 = [];
var arr2 = [];


//1. arr1 == !arr2
//2. [] == false 
//3. "" == false
//4. "" == 0
//5. 0 == 0 
//6. 0 === 0 
if (true) console.log("Yes, it's true!");
```

Firstly, I’ll refer to the [documentation](http://documentation). On line 6, we have a comparison of primitive and non-primitive value. In this case, the rule №11 applied. **The result of this algorithm is an empty string.**

In the next step, we’re comparing an empty string with **false**. According to the algorithm, rule №9 applied. The next step (line 8) is to apply rule №5. The 5th step is to compare two numbers. Since we’re using equality comparison, **we’re going to call strict equality comparison algorithm**.

The last step is to return a **true** from the strict equality comparison. The second example is a bit more practical because we’re using not equals (double equality negation) - **checking if is not coercively equal**:

```JavaScript
var arr1 = [];
var arr2 = [];


//1. arr1 != arr2
//2. (!(arr1 == arr2))
//3. (!(false))
if (true) console.log("It's true again!");
```

**As we are comparing two non-primitive types, it means that we’re going to perform an identity comparison.** The same applies when using strict equality comparison.

## Don’t mess with Booleans

Let’s talk about booleans and their connections to abstract equality. That is something you work with a lot. We should take a look at corner cases that can occur:

```JavaScript
var students = [];


if (students) {
    console.log("You can see this message!");
}

if (students == true) {
    console.log("You can't see this message!");
}

if (students == false) {
    console.log("Working!");
}
```

**Being explicit can sometimes produce unnecessary problems.** In the second if-clause, we compare array with boolean. You may have thought that the result of this operation is boolean **true**, but it isn’t. **The same effect will be with strict equality.**

Comparison of an array and a boolean value will go throughout lots of corner cases. Before we take a look at examples, I’ll give you a hint: **Don’t ever use double equals with boolean (true and false)**. Let’s analyze how the algorithm works:

```JavaScript
var students = [];


//** if(students) **//
// 1. students 
// 2. Boolean(students)
if (true) console.log("You can see this message!");

//** if(students == true) **//
// 1. "" == true
// 2. "" == 1
// 3. 0 === 1
if (false) console.log("You can't see this message!");

//** if(students == false) **//
// 1. "" == false
// 2. "" == 0
// 3. 0 === 0
if (true) console.log("Working!");
```

The first if-clause is self-explanatory, so I won’t waste time explaining. Like in the previous example, **I refer to the [documentation](https://www.ecma-international.org/ecma-262/#sec-abstract-equality-comparison)**. Comparing array and boolean is going to invoke [**ToPrimitive()**](https://www.ecma-international.org/ecma-262/#sec-toprimitive) abstract operation (rule №11) as one of the compared values is a non-primitive type.

Next three steps are straight forward. Firstly, we convert a boolean to a number (rule №9: [**ToNumber(true)**](https://www.ecma-international.org/ecma-262/#sec-tonumber)), in the next step the string becomes number (rule №5: [**ToNumber(“”)**](https://www.ecma-international.org/ecma-262/#sec-tonumber)), and the last step is to perform a strict equality comparison. The third clause is the same as the previous.

One of the downsides of the coercion is an abstract operation **ToNumber()**. I’m not sure that converting an empty string to a number should return **0**. **It would be much better to return NaN since NaN is representing an invalid number.**

Conclusion: **Senseless input will always produce senseless output. We don’t have to be explicit all time. Implicitly can sometimes be better than explicitly.**

The best thing you could do when you’re checking the existence of the values in the array is to be more explicit and check the presence of `.length` to make sure it’s a string or an array:

```JavaScript
const arr1 = [1, 2, 3];
const arr2 = [];


if (arr1) {
    console.log("You should see this message!");
}

if (arr1.length) {
    console.log("Array is not empty!");
}


if (arr2) {
    console.log("You should not see this message!");
}

if (arr2.length) {
    console.log("You can't see this message!");
}
```

Deep checking is more reliable. As you can see, an empty array is going to return **true** (after boolean coercion). The same thing adopts for objects - **always do deep checking**. When we make sure that the type is a string or an array, we’ll use the `typeof` operator (or `Array.isArray()` method).

## Clarification

There are guidelines you have to follow to avoid falling into the traps of corner cases. **Using double equals everywhere can be a two-edged sword.** Have on mind that using double equals when either side of compared values is **0**, an empty string or string with only white-space is a bad practice.

The next big thing to memorise is to avoid using double equals with non-primitive types. **The only time you can use it is for identity comparison.** I cannot say that this is 100% safe as it’s close enough to corner case that it’s not worth it.

[ECMAScript 6](https://www.w3schools.com/js/js_es6.asp) introduced a new utility [**Object.is()**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/is). With this method, we can finally perform identity comparison without the risk of side effects. In the end, we can say that using double equals is only safe with primitive types, but not with non-primitives.

Last but not least is to avoid using double equals with booleans (**true** and **false**). It’s much better to allow implicit boolean coercion (invoke **ToBoolean()** abstract operation). If you cannot enable implicit coercion, and you’re limited to use double equals with booleans (**true** and **false**), then **use triple equals**.

#### Conclusion

Most of the corner case can be avoided by refactoring our codebase.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
