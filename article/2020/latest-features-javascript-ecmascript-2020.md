> * 原文地址：[The Latest Features Added to JavaScript in ECMAScript 2020](https://www.telerik.com/blogs/latest-features-javascript-ecmascript-2020)
> * 原文作者：[Thomas Findlay](https://www.telerik.com/blogs/author/thomas-findlay)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/latest-features-javascript-ecmascript-2020.md](https://github.com/xitu/gold-miner/blob/master/article/2020/latest-features-javascript-ecmascript-2020.md)
> * 译者：
> * 校对者：

# The Latest Features Added to JavaScript in ECMAScript 2020

![JavaScriptT2 Light_1200x303](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/templates/javascriptt2-light_1200x303.png?sfvrsn=cc305226_2 "JavaScriptT2 Light_1200x303")

JavaScript is one of the most popular programming languages, and features are now added to the language every year. This article covers new features added in ECMAScript 2020, also known as ES11.

Before the introduction of ECMAScript 2015, also known as ES6, JavaScript language development had a very slow pace. Fortunately, since then, new features are added every year. Be aware that not all features might be supported in all modern browsers yet, but thanks to transpilers like [Babel](https://babeljs.io/), we can use them already today. This article will cover some of the latest additions to JavaScript — ECMAScript 2020 (ES11).

## Optional Chaining

I’m sure that most developers are familiar with an error of this kind:

`TypeError: Cannot read property ‘x’ of undefined`

This error basically means that we tried to access a property on something that is not an object.

### Accessing an Object Property

```javascript
const flower = {
    colors: {
        red: true
    }
}

console.log(flower.colors.red) // this will work

console.log(flower.species.lily) // TypeError: Cannot read property 'lily' of undefined
```

JavaScript engine will always throw an error in a scenario like this. However, there are cases in which it doesn't matter that the value isn't there yet, because we might know it will be. Fortunately, here is the optional chaining feature to the rescue!

We can use the optional chaining operator, which consists of a question mark and a dot: **`?.`**, to indicate that an error should not be thrown. Instead, if there is no value, **undefined** will be returned.

```javascript
console.log(flower.species?.lily) // undefined
```

Optional chaining can also be used when accessing array values or calling a function.

### Accessing an Array

```javascript
let flowers =  ['lily', 'daisy', 'rose']

console.log(flowers[1]) // daisy

flowers = null

console.log(flowers[1]) // TypeError: Cannot read property '1' of null
console.log(flowers?.[1]) // undefined
```

### Calling a Function

```javascript
let plantFlowers = () => {
  return 'orchids'
}

console.log(plantFlowers()) // orchids

plantFlowers = null

console.log(plantFlowers()) // TypeError: plantFlowers is not a function

console.log(plantFlowers?.()) // undefined
```

## Nullish Coalescing

Until recently, whenever there was a need to provide a fallback value, the logical operator **`||`** had to be used. It works in most cases, but it can't be applied in some scenarios. For instance, if the initial value is a Boolean or a number. Let's take a look at an example below, where we want to assign a number to a variable, or default it to 7 if the initial value is not a number:

```javascript
let number = 1
let myNumber = number || 7
```

The **myNumber** variable is equal to 1, because the left-hand value (**number**) is a [**truthy**](https://developer.mozilla.org/en-US/docs/Glossary/Truthy) value, as 1 is a positive number. However, what if the **number** variable is not 1, but 0?

```javascript
let number = 0
let myNumber = number || 7
```

0 is a [**falsy**](https://developer.mozilla.org/en-US/docs/Glossary/Falsy) value, and even though it is a number, the **myNumber** variable will have the right-hand value assigned to it. Therefore, **myNumber** is now equal to 7. However, that's not really what we want. Fortunately, instead of writing additional code and checks to confirm if the **number** variable is indeed a number, we can use the nullish coalescing operator. It consists of two question marks: **`??`**.

```javascript
let number = 0
let myNumber = number ?? 7
```

The right-hand side value will only be assigned if the left-hand value is equal to **null** or **undefined**. Therefore, in the example above, the **myNumber** variable is equal to 0.

## Private Fields

Many programming languages that have **classes** allow defining class properties as public, protected, or private. **Public** properties can be accessed from outside of a class and by its subclasses, while **protected** classes can only be accessed by subclasses. However, **private** properties can only be accessed from inside of a class. JavaScript supports class syntax since **ES6**, but only now were private fields introduced. To define a private property, it has to be prefixed with the hash symbol: **`#`**.

```javascript
class Flower {
  #leaf_color = "green";
  constructor(name) {
    this.name = name;
  }

  get_color() {
    return this.#leaf_color;
  }
}

const orchid = new Flower("orchid");

console.log(orchid.get_color()); // green
console.log(orchid.#leaf_color) // Private name #leaf_color is not defined 
```

If we try to access a private property from outside, an error will be thrown.

## Static Fields

To use a class method, a class had to be instantiated first, as shown below.

```javascript
class Flower {
  add_leaves() {
    console.log("Adding leaves");
  }
}

const rose = new Flower();
rose.add_leaves();

Flower.add_leaves() // TypeError: Flower.add_leaves is not a function
```

Trying to access a method without instantiating the **Flower** class would result in an error. Thanks to **static** fields, a class method can now be declared with the **static** keyword and called from outside of a class.

```javascript
class Flower {
  constructor(type) {
    this.type = type;
  }
  static create_flower(type) {
    return new Flower(type);
  }
}

const rose = Flower.create_flower("rose"); // Works fine
```

## Top Level Await

So far, to **await** for a promise to finish, a function in which **await** is used would need to be defined with the **async** keyword.

```javascript
const func = async () => {
    const response = await fetch(url)
}
```

Unfortunately, if there was a need to await for something in a global scope, it would not be possible, and usually required an **immediately invoked function expression (IIFE)**.

```javascript
(async () => {
    const response = await fetch(url)
})()
```

Thanks to **Top Level Await**, there is no need for wrapping code in an async function anymore, and this code will work.

```javascript
const response = await fetch(url)
```

This feature could be useful for resolving module dependencies or using a fallback source if the initial one failed.

```javascript
let Vue
try {
    Vue = await import('url_1_to_vue')
} catch {
    Vue = await import('url_2_to_vue)
} 
```

## Promise.allSettled

To wait for multiple promises to finish, **Promise.all(\[promise\_1, promise\_2\])** can be used. The problem is that if one of them fails, then an error will be thrown. Nevertheless, there are cases in which it is ok for one of the promises to fail, and the rest should still resolve. To achieve that, **ES11** introduced **Promise.allSettled**.

```javascript
promise_1 = Promise.resolve('hello')
primise_2 = new Promise((resolve, reject) => setTimeout(reject, 200, 'problem'))

Promise.allSettled([promise_1, promise_2])
    .then(([promise_1_result, promise_2_result]) => {
        console.log(promise_1_result) // {status: 'fulfilled', value: 'hello'}
        console.log(promise_2_result) // {status: 'rejected', reason: 'problem'}
    })
```

A resolved promise will return an object with **status** and **value** properties, while rejected ones will have **status** and **reason**.

## Dynamic Import

You might have used dynamic imports when using **webpack** for module bundling. Finally, native support for this feature is here.

```javascript
// Alert.js file
export default {
    show() {
        // Your alert
    }
}


// Some other file
import('/components/Alert.js')
    .then(Alert => {
        Alert.show()
    })
```

Considering the fact that a lot applications use module bundlers like webpack for transpiling and optimizing code, this feature isn't such a big deal right now.

## MatchAll

MatchAll is useful for applying the same regular expression to a string if you need to find all matches and get their positions. The **match** method only returns items that were matched.

```javascript
const regex = /\b(apple)+\b/;
const fruits = "pear, apple, banana, apple, orange, apple";


for (const match of fruits.match(regex)) {
  console.log(match); 
}
// Output 
// 
// 'apple' 
// 'apple'
```

**matchAll** in contrast, returns a bit more information, including index of the string found.

```javascript
for (const match of fruits.matchAll(regex)) {
  console.log(match);
}

// Output
// 
// [
//   'apple',
//   'apple',
//   index: 6,
//   input: 'pear, apple, banana, apple, orange, apple',
//   groups: undefined
// ],
// [
//   'apple',
//   'apple',
//   index: 21,
//   input: 'pear, apple, banana, apple, orange, apple',
//   groups: undefined
// ],
// [
//   'apple',
//   'apple',
//   index: 36,
//   input: 'pear, apple, banana, apple, orange, apple',
//   groups: undefined
// ]
```

## globalThis

JavaScript can run in different environments like browsers or Node.js. A global object in browsers is available under **window** variable, but in Node it is an object called **global**. To make it easier to use a global object no matter in which environment code is running, **globalThis** was introduced.

```javascript
// In a browser
window == globalThis // true

// In node.js
global == globalThis // true
```

## BigInt

The maximum number that can be reliably represented in JavaScript is 2^53 - 1. BigInt will allow creation of numbers even bigger than that.

```javascript
const theBiggerNumber = 9007199254740991n
const evenBiggerNumber = BigInt(9007199254740991)
```

## Conclusion

I hope you found this article useful and are as excited as I am about the new features that are coming to JavaScript. If you would like to know more about different features you can check the official GitHub repository of the ES committee [here](https://github.com/tc39/proposals/blob/master/finished-proposals.md).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
