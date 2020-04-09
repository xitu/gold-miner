> * 原文地址：[Why is object immutability important?](https://levelup.gitconnected.com/why-is-object-immutability-important-d6882929e804)
> * 原文作者：[Alex Pickering](https://medium.com/@pickeringacw)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-is-object-immutability-important.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-is-object-immutability-important.md)
> * 译者：
> * 校对者：

# Why is object immutability important?

## Why Object Immutability?

To understand the importance of immutability, we should first take a look at the concept of mutability. We should understand what it is, what it means, and what the implications are or could be.

In this post, we’ll be taking a look at some concepts of mutability using JavaScript. These principles are language agnostic though.

![](https://cdn-images-1.medium.com/max/8544/0*2Y6wJDRrY8O8c-TB)

## Muta…What?

Mutability! In essence, the concept of mutability describes whether or not the state of an object can be modified after it has been declared. It’s that simple.

Consider this, we have a variable and we assign it a value when we declare it. Later in our code, we run into a scenario where we need to now modify the value of this variable. If we now go ahead and are able to change the value of this variable, changing its state, the object is considered to be **mutable**.

```js
// Original array
const foo = [ 1, 2, 3, 4, 5 ]

// Mutating original array
foo.push(6) // [ 1, 2, 3, 4, 5, 6 ]

// Original object
const bar = { becky: 'lemme' }

// Mutating original object
bar.becky = true
```

When it comes to arrays, it’s almost too easy to mutate the array and change the state of it’s value. In order to prevent this from happening, so we remain in an immutable state, we should create a new array that is derived from the original, with the new item inserted into it.

Likewise with the object, a new object should be created from the existing object, with the changes required added to it.

Here comes the but…

JavaScript has the concept of primitive types which are **String** and **Number**. These are considered to be immutable out of the box. The tricky part to understand here is that while the string itself is immutable, the variable assignment is still mutable. Meaning if we were to create a variable and assign it a string, if we reassign that variable to a new string, it’s technically not mutating the original string but rather the variables assignment. This is an important distinction to make.

```js
// Instantiate and declare variable
let foo = 'something'

// Instantiate and declare variable to existing primitive type
let bar = foo

// Reassign the value of initial variable
foo = 'else'

// Log out the results
console.log(foo, bar)
> 'else', 'something'
```

The primitive type was created immutably — meaning that when `bar` was instantiated, although it was set to `foo`, the value in memory was stored separately. This is happens with all primitive types! This results in the new assignment not leaking over into any other variables using it as a pointer!

## Try Immutability On For Size

The flip side of mutability is immutability. This is where once the variable has been declared and the state set, it can not be modified again. Instead a new object, based off the original, **needs** to be created with any changes included in it.

Let’s take a look at how we would insert an item into an array immutably.

```js
const foo = [ 1, 2, 3, 4, 5 ]

// Immutable, not mutating original array (ES6 Spread)
const bar = [ ...foo, 6 ]
const arr = [ 6, ...foo ]
```

We are now creating `bar` and `arr` from the original array and including the change we want at the end and beginning respectively. We use the [spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax) to list the existing array items into the new array.

If we had a more complex array, such as an array of objects, how could we modify each object without breaking immutability? Simple! We could use `.map` which is a native array function.

```js
const foo = [{ a: 'b', c: 'd' }]

// Immutable, not mutating original array
const bar = foo.map(item => ({
  ...item,
  a: 'something else'
}))
```

What about objects? How would we update properties on a standalone object without mutating the original? Well yet again, we can simply use the spread syntax.

```js
const foo = { becky: 'lemme' }

// Immutable, not mutating original object
const bar = { ...foo, smash: false }
```

The initial object of `foo` remains untouched and in the same state that we found it — and we have created a new object with the changes we wanted to see. Cool!

Let’s however for a moment assume that we can’t use ES6 standards. How could we achieve the immutability?

```js
const foo = { becky: 'lemme' }

// Immutable, not mutating original object
const bar = Object.assign({}, foo, { smash: false })
```

In the above example, we’re using an older method of assigning values to a new object.

NB — Be aware that using a spread operator at the top level of a nested object does not guarantee immutability in the objects nested within it. As we can see in the below example.

```js
const personA = {
  address: {
   city: 'Cape Town'
  }
}

const personB = {
  ...personA
}

const personC = {
  address: {
    ...personA.address,
  }
}

personA.address.city = 'Durban' // This mutates both person A & B

console.log(personB.address.city) // 'Durban'
console.log(personC.address.city) // 'Cape Town'
```

In order to ensure that the nested objects remain immutable, each nested object would need to be spread or assigned as illustrated in the above snippets.

![](https://cdn-images-1.medium.com/max/10368/0*e8XYkZ1MhoFTSaNu)

## You’ve Answered How, But Not Why?

In most applications, data integrity and consistency is usually of paramount importance. We don’t want data being mutated in odd fashions and, as a result, being erroneously stored in our database or returned to the user. We want to ensure with the best predictability that the data we are using remains consistent with what we expect. This is vital when it comes to asynchronous and multi-threaded applications.

To better understand the above, let’s take a gander at the diagram below. Let’s assume that `foo` contains some vaguely important data about a user of our system. If we have Promise A and Promise B which are both running concurrently in a Promise.All and both promises accept the `foo` object as a parameter, if one of the promises mutates `foo`, then the new state of `foo` is leaked into the second promise.

![Illustration of the flow for the issue described above.](https://cdn-images-1.medium.com/max/2000/1*9FYWNTJUvpL2b_4-kqjwWw.png)

This could potentially cause complications in the execution of that promise if it were relying on `foo` being in it’s original state.

The result of the diagram above, depending on which promise happens to resolve first, may differ if both promises mutate the `foo` object. This is known as a race-condition. When the object is passed in, it’s merely a pointer to the underlying object that is passed instead of a new object.

```js
// Initial object
const obj = {
  a: 'b',
  c: 'd'
}

// Log out the `item` being passed in after a simulated 1 second of computing
const foo = item => setTimeout(() => console.log(item), 1000)

// Modify the `item` being passed in
const bar = item => item.a = 'something'

// Run both functions as a promise and provide `obj` as input for both functions
Promise.all([ foo(obj), bar(obj) ])

// Expected outcome
> { a: "b", c: "d" }

// Actual outcome
> { a: "something", c: "d" }
```

This could potentially cause some headaches when debugging your code or even trying to implement a new feature. I would suggest remaining immutable!

## So I Should Create A New Object?

In short, yes. However you should **not** simply set your new variable to the old one directly. This could also cause complications and may not go quite as we expect it to.

```js
const foo = { a: 'b', c: 'd' }

// This creates a pointer or shallow copy
const bar = foo

// This creates a deep copy
const bar = { ...foo }
```

The difference is a fundamental one in JavaScript, specifically when it comes to how the variables are stored in memory.

The somewhat more technical explanation is that when creating the object `foo`, the object is stored in what’s known as the [heap](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e), and a pointer to this memory allocation is created on the [stack](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e). When creating a shallow copy, as with the first declaration above, a new item is placed onto the [stack ](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e)but it points to the same memory allocation in the [heap](https://medium.com/javascript-in-plain-english/understanding-javascript-heap-stack-event-loops-and-callback-queue-6fdec3cfe32e).

![Simplistic illustration of the stack and heap allocations for the objects created in the example above.](https://cdn-images-1.medium.com/max/2000/1*06XtgCM-VsMXRtBtpzf40w.png)

This means that if `foo` were to be mutated, then `bar` would reflect these mutations as well. **Unintended consequences**!

## But What About The Performance?

Well, when it comes to performance, you may assume that this would be a more tedious and heftier process than simply mutating the existing object, and you’d be correct. However, it’s not as bad as you may initially believe.

JavaScript uses the concept of structural sharing which means that creating a new modified object derived from your first object, doesn’t actually generate too much overhead. When you consider this, as well as the benefits that immutability brings to the table, it begins to look like a serious option. To name a few benefits…

* Thread safety (for multi-threaded languages)
* Easier to test and use
* Failure atomicity
* Mitigates temporal coupling

Ultimately, if used correctly, immutability will almost certainly improve the overall performance of the application and development even though certain functions may, in isolation, be computationally heavier.

![](https://cdn-images-1.medium.com/max/12000/0*QNgRdXP9gZPEyJSW)

## Are We There Yet?

In conclusion, it’s up to you whether or not you want to utilize the concept of immutability. In my personal opinion, I think it solves a lot more issues and potential issues than it is, at least at face value, often given credit for. I try to ensure my objects are always immutable.

Here are some references to resources that may peak your interest should you wish to either learn more or begin to implement immutability into your codebase.

[Immutable.js](https://immutable-js.github.io/immutable-js/)
[Benefits of Immutability](https://hackernoon.com/5-benefits-of-immutable-objects-worth-considering-for-your-next-project-f98e7e85b6ac)

[MDN — Arrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)
[MDN — Objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)

Thank you for reading, I hope you enjoyed and learned something. If you happen to have any feedback, criticism or contributions, feel free to jot them down in the comment section below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
