> * 原文地址：[One of the first things to understand in JavaScript — Immutability](https://medium.com/javascript-in-plain-english/one-of-the-first-things-to-understand-in-javascript-immutability-629fabdf4fee)
> * 原文作者：[Daryll Wong](https://medium.com/@daryllwong)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/one-of-the-first-things-to-understand-in-javascript-immutability.md](https://github.com/xitu/gold-miner/blob/master/article/2020/one-of-the-first-things-to-understand-in-javascript-immutability.md)
> * 译者：
> * 校对者：

# One of the first things to understand in JavaScript — Immutability

![](https://cdn-images-1.medium.com/max/6136/1*4PrMNL-FF9Z5G5BXJliAYg.png)

Let us go back to basics: “In JavaScript, are variables or constants immutable?”

The answer is **neither**, and if you even have a little hesitation on your answer, read on. Every programming language have different flavors and characteristics, and in JavaScript, this is one of the most important things to be aware of, especially while we are picking up a few languages like Python, Java, etc.

You may not necessarily change how you code in JavaScript immediately, but in knowing this early, it will prevent you from getting into nasty situations that are difficult to debug later on. I will include some ways you can adopt to prevent getting into such problems as well — different ways to do shallow & deep copy.

Just a quick summary before we begin:

**Variables** (initialised with `let`) — Re-assignable & Mutable
**Constants** (initialised with `const`) — Non re-assignable & Mutable

---

Before we explain mutability in JavaScript, let us quickly go through some basics… You may skip this part.

There are broadly a few groups of data types in JavaScript:

1. **Primitive (primary)**— Boolean, Number, String
2. **Non-primitive (reference) or Objects** — Object, Array, Function
3. **Special**— Null, Undefined

**Quick tip, you can use console.log(typeof unknownVar) to figure out the data type of the variable you are dealing with**

#### Primitive data types are Immutable by default

For primitive data types (like boolean, number and strings), they are **immutable** if they are declared as constants because for these data types, you cannot add any additional properties or mutate certain properties.

To ‘change/alter’ primitives, it simply means you have to reassign them, which is only possible if they are declared as variables.

```js
let var1 = 'apple' //'apple' is stored in memory location A
var1 = 'orange' //'orange' is stored in memory location B

const var2 = 'apple'
var2 = 'orange' // ERROR: Re-assignment not allowed for constants
```

![](https://cdn-images-1.medium.com/max/2464/1*xyaMxzBMpouTQbMr-O0pXg.png)

In the example above, if we edit the string for var1, JavaScript will simply create another string at another memory location and var1 will point to this new memory location, and this is called **Re-assignment**. This applies for all **primitive data types** regardless if they are declared as variables or constants.

And all constants cannot be re-assigned.

## In JavaScript, Objects are Passed By Reference

Problems start to occur when we are dealing with **objects**…

#### Objects are not Immutable

Objects generally refer to the non-primitive data types (Object, Array and Function), and they are mutable even if they are declared as constants with `const`

**(For the rest of this article, I will give examples for the Object data type as problems arise the most here. The concepts will be the same for Arrays and Functions)**

So what does this mean?

```js
const profile1 = {'username':'peter'}
profile1.username = 'tom'
console.log(profile1) //{'username':'tom'}
```

![](https://cdn-images-1.medium.com/max/3448/1*FluTwbCYFCQO6pW5enoLoQ.png)

In this case, profile1 is pointing to the object located at the same memory location and what we have done is to mutate the properties of this object at the same memory location.

Okay this looks simple enough, why would this be problematic?

#### When Mutation in Objects become a PROBLEM…

```js
const sampleprofile = {'username':'name', 'pw': '123'}
const profile1 = sampleprofile

profile1.username = 'harry'

console.log(profile1) // {'username':'harry', 'pw': '123'}
console.log(sampleprofile) // {'username':'harry', 'pw': '123'}
```

**Looks like a simple piece of code that you may potentially & innocently write right? Guess what, there’s already an issue here!**

This is because Objects are **passed by reference** in JavaScript.

![](https://cdn-images-1.medium.com/max/3720/1*K7JS9v4pbm1b0W4yaf-fZQ.png)

What is meant by ‘**passing by reference**’ in this case is, we are passing the reference of the constant sampleprofile to profile1. In other words, the constants of both profile1 and sampleprofile are pointed to the same object **located at the** **same memory location**.

Hence, when we change the property of the object of the constant profile1, it also affects sampleprofile because both of them are pointed to the same object.

```js
console.log(sampleprofile===profile1)//true
```

**This is just a simple example of how passing by reference (and hence mutation) can potentially be problematic. But we can imagine how this can get really gnarly when our code gets more complex and large, and if we are not too aware of this fact, it will be hard for us to solve certain bugs.**

So, how do we prevent or try to avoid from potentially facing such issues?

There are two concepts that we should be aware of in order to effectively face potential issues related to Mutation in Objects:

* **Preventing Mutation by Freezing Objects**
* **Using Shallow & Deep copy**

I will show you some examples of implementation in JavaScript, using vanilla JavaScript methods, as well as some useful libraries we could use.

## Preventing Mutation in Objects

#### 1. Using Object.freeze() Method

If you want to prevent an object from changing properties, you can use `Object.freeze()` . What this does is it will not allow the existing properties of the object to alter. Any attempts to do so will cause it to ‘silently fail’, meaning it will not be successful but and there will not be any warnings as well.

```js
const sampleprofile = {'username':'name', 'pw': '123'}

Object.freeze(sampleprofile)

sampleprofile.username = 'another name' // no effect

console.log(sampleprofile) // {'username':'name', 'pw': '123'}
```

HOWEVER, this is a form of **shallow freeze** and this will not work with deeply nested objects:

```js
const sampleprofile = {
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'name', 'lastname':'name'}
}

Object.freeze(sampleprofile)

sampleprofile.username = 'another name' // no effect
console.log(sampleprofile)

/*
{
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'name', 'lastname':'name'}
}
*/

sampleprofile.particulars.firstname = 'changedName' // changes
console.log(sampleprofile)

/*
{
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'changedName', 'lastname':'name'}
}
*/
```

In the above example, the properties of the nested object is still able to change.

You can potentially create a simple function to recursively freeze the nested objects (you can try this on your own and comment your answers in this article? 😊), but if you are lazy here are some libraries you could use:

#### 2. Using deep-freeze

But seriously, if you look at the [source code](https://github.com/substack/deep-freeze/blob/master/index.js) of [deep-freeze](https://www.npmjs.com/package/deep-freeze), it is essentially just a simple recursion function, but anyway this is how you can use it easily..

```js
var deepFreeze = require('deep-freeze');

const sampleprofile = {
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'name', 'lastname':'name'}
}

deepFreeze(sampleprofile)
```

Another alternative to deep-freeze is [ImmutableJS](https://immutable-js.github.io/immutable-js/) which some of you may prefer because it will help to throw an error whenever you try to mutate an object that you have created with the library.

---

## Avoiding problems related to Passing By Reference

The key is in understanding **shallow and deep copying/cloning/merging** in JavaScript.

Depending on your individual implementation of the objects in your program, you may want to use shallow or deep copying. There may also be other considerations pertaining to memory and performance, which will affect your choice of shallow or deep copy and even libraries to use. But we shall leave this to another day when we get there 😉

Let’s start off with shallow copying, followed by deep copying.

## Shallow Copying

#### 1. Using spread operator (…)

The spread operator introduced with ES6 provides us with a cleaner way to combine arrays and objects.

```js
const firstSet = [1, 2, 3];
const secondSet= [4, 5, 6];
const firstSetCopy = [...firstset]
const resultSet = [...firstSet, ...secondSet];

console.log(firstSetCopy) // [1, 2, 3]
console.log(resultSet) // [1,2,3,4,5,6]
```

ES2018 also extended spread properties to object literals, so we can also do the same for objects. The properties of all the objects will be merged but for conflicting properties, the subsequent objects will take precedence.

```js
const profile1 = {'username':'name', 'pw': '123', 'age': 16}
const profile2 = {'username':'tom', 'pw': '1234'}
const profile1Copy = {...profile1}
const resultProfile = {...profile1, ...profile2}

console.log(profile1Copy) // {'username':'name', 'pw': '123', 'age': 16}
console.log(resultProfile) // {'username':'tom', 'pw': '1234', 'age': 16}
```

#### 2. Using Object.assign() Method

This is similar to using the spread operators above, which can be used for both arrays and objects.

```js
const profile1 = {'username':'name', 'pw': '123', 'age': 16}
const profile2 = {'username':'tom', 'pw': '1234'}
const profile1Copy = Object.assign({}, profile1)
const resultProfile = Object.assign({},...profile1, ...profile2)
```

Note that I have used an empty object `{}` as the first input because this method updates the first input from the result of the shallow merge.

#### 3. Using .slice()

This is just a convenient method just for **shallow cloning arrays**!

```js
const firstSet = [1, 2, 3];
const firstSetCopy = firstSet.slice()

console.log(firstSetCopy) // [1, 2, 3]

//note that they are not the same objects
console.log(firstSet===firstSetCopy) // false
```

#### 4. Using lodash.clone()

Also note there is a method in lodash to do shallow cloning as well. I think it is a little overkill to use this (unless you already have lodash included) but I’ll just leave an example here.

```js
const clone = require('lodash/clone')

const profile1 = {'username':'name', 'pw': '123', 'age': 16}
const profile1Copy = clone(profile1)
...
```

#### Problem of Shallow Cloning:

For all of these examples of Shallow Cloning, issues start to come if we have **deeper nesting of objects**, like this example below.

```js
const sampleprofile = {
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'name', 'lastname':'name'}
}

const profile1 = {...sampleprofile}
profile1.username='tom'
profile1.particulars.firstname='Wong'

console.log(sampleprofile)
/*
{
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'Wong', 'lastname':'name'}
}
*/

console.log(profile1)
/*
{
  'username':'tom', 
  'pw': '123', 
  'particulars':{'firstname':'Wong', 'lastname':'name'}
}
*/

console.log(sampleprofile.particulars===profile1.particulars) //true
```

Note how mutating the nested property (‘firstname’) of `profile1`, also affects `sampleprofile`.

![](https://cdn-images-1.medium.com/max/4912/1*7QbV9c0-yJ98rgeciFYgCg.png)

For Shallow Cloning, the nested object’s references are copied. So the objects of ‘particulars’ for both `sampleprofile` and `profile1` refer to the same object located at the same memory location.

To prevent such a thing from happening and if you want a 100% true copy with no external references, we need to use **Deep Copy**.

## Deep Copying

#### 1. Using JSON.stringify() & JSON.parse()

This was not possible previously but for ES6, JSON.stringify() method is able to do deep copying of nested objects as well. However, note that this method only works great for Number, String and Boolean data types. Here’s an example in JSFiddle, try playing around to see what is copied and what’s not.

Generally if you are only working with primitive data types and a simple object, this is a short & simple one-liner code to do the job!

#### 2. Using lodash.deepclone()

```js
const cloneDeep = require('lodash/clonedeep')
const sampleprofile = {
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'name', 'lastname':'name'}
}

const profile1 = cloneDeep(sampleprofile)
profile1.username='tom'
profile1.particulars.firstname='Wong'

console.log(sampleprofile)
/*
{
  'username':'name', 
  'pw': '123', 
  'particulars':{'firstname':'name', 'lastname':'name'}
}
*/

console.log(profile1)
/*
{
  'username':'tom', 
  'pw': '123', 
  'particulars':{'firstname':'Wong', 'lastname':'name'}
}
*/
```

**FYI, lodash is included in react apps created with create-react-app**

#### 3. Custom Recursion Function

If you don’t want to download a library just to do a deep copy, feel free to create a simple recursion function too!

The code below (though doesn't cover all cases) gives a rough idea of how you can create this yourself.

```js
function clone(obj) {
    if (obj === null || typeof (obj) !== 'object' || 'isActiveClone' in obj)
        return obj;

    if (obj instanceof Date)
        var temp = new obj.constructor(); //or new Date(obj);
    else
        var temp = obj.constructor();

    for (var key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
            obj['isActiveClone'] = null;
            temp[key] = clone(obj[key]);
            delete obj['isActiveClone'];
        }
    }
    return temp;
}
// taken from https://stackoverflow.com/questions/122102/what-is-the-most-efficient-way-to-deep-clone-an-object-in-javascript
```

Perhaps it is simpler to just download a library to implement deep cloning? There are other **micro-libraries** like [rfdc](https://www.npmjs.com/package/rfdc), [clone](https://www.npmjs.com/package/clone), [deepmerge](https://www.npmjs.com/package/deepmerge) that does the job, in a smaller package size than lodash. You don’t have to download lodash just to use one function.

---

Hope this gives you a perspective of the Object-Oriented nature of JavaScript, and how to handle bugs related to mutation in objects! This is a popular JavaScript interview question too. Thanks for reading! :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
