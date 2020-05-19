> * 原文地址：[The Latest Features Added to JavaScript in ECMAScript 2020](https://www.telerik.com/blogs/latest-features-javascript-ecmascript-2020)
> * 原文作者：[Thomas Findlay](https://www.telerik.com/blogs/author/thomas-findlay)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/latest-features-javascript-ecmascript-2020.md](https://github.com/xitu/gold-miner/blob/master/article/2020/latest-features-javascript-ecmascript-2020.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[Chorer](https://github.com/Chorer)，[CoolRice](https://github.com/CoolRice)

# ECMAScript 2020 新特性

![JavaScriptT2 Light_1200x303](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/templates/javascriptt2-light_1200x303.png?sfvrsn=cc305226_2 "JavaScriptT2 Light_1200x303")

JavaScript 是最流行的编程语言之一，每年都会添加新的特性。本文介绍了添加在 ECMAScript 2020（又称ES11）中的新特性。

在引入 ECMAScript 2015（又称 ES6）之前，JavaScript 发展的非常缓慢。但自 2015 年起，每年都有新特性添加进来。需要注意的是，不是所有特性都被现代浏览器支持，但是由于 JavaScript 编译器 [Babel](https://babeljs.io/) 的存在，我们已经可以使用新特性了。本文将介绍 ECMAScript 2020（ES11）的一些最新特性。

## Optional Chaining 可选链式调用

大部分开发者都遇到过这个问题：

`TypeError: Cannot read property ‘x’ of undefined`

这个错误表示我们正在访问一个不属于对象的属性。

### 访问对象的属性

```javascript
const flower = {
    colors: {
        red: true
    }
}

console.log(flower.colors.red) // 正常运行

console.log(flower.species.lily) // 抛出错误：TypeError: Cannot read property 'lily' of undefined
```

在这种情况下，JavaScript 引擎会像这样抛出错误。但是某些情况下值是否存在并不重要，因为我们知道它会存在。于是，可选链式调用就派上用场了！

我们可以使用由一个问号和一个点组成的可选链式操作符，去表示不应该引发错误。如果没有值，应该返回 **undefined**。

```javascript
console.log(flower.species?.lily) // 输出 undefined
```

当访问数组或调用函数时，也可以使用可选链式调用。

### 访问数组

```javascript
let flowers =  ['lily', 'daisy', 'rose']

console.log(flowers[1]) // 输出：daisy

flowers = null

console.log(flowers[1]) // 抛出错误：TypeError: Cannot read property '1' of null
console.log(flowers?.[1]) // 输出：undefined
```

### 调用函数

```javascript
let plantFlowers = () => {
  return 'orchids'
}

console.log(plantFlowers()) // 输出：orchids

plantFlowers = null

console.log(plantFlowers()) // 抛出错误：TypeError: plantFlowers is not a function

console.log(plantFlowers?.()) // 输出：undefined
```

## Nullish Coalescing 空值合并

目前，要为变量提供回退值，逻辑操作符 **`||`** 还是必须的。它适用于很多情况，但不能应用在一些特殊的场景。例如，初始值是布尔值或数字的情况。举例说明，我们要把数字赋值给一个变量，当变量的初始值不是数字时，就默认其为 7 ：

```javascript
let number = 1
let myNumber = number || 7
```

变量 **myNumber** 等于 1，因为左边的（**number**）是一个 [**真**](https://developer.mozilla.org/en-US/docs/Glossary/Truthy) 值 1。但是，当变量 **number** 不是 1 而是 0 呢？

```javascript
let number = 0
let myNumber = number || 7
```

0 是 [**假**](https://developer.mozilla.org/en-US/docs/Glossary/Falsy) 值，所以即使 0 是数字。变量 **myNumber** 将会被赋值为右边的 7。但结果并不是我们想要的。幸好，由两个问号组成：**`??`** 的合并操作符就可以检查变量 **number** 是否是一个数字，而不用写额外的代码了。

```javascript
let number = 0
let myNumber = number ?? 7
```

操作符右边的值仅在左边的值等于 **null** 或 **undefined** 时有效，因此，例子中的变量 **myNumber** 现在的值等于 0 了。

## Private Fields 私有字段

许多具有 **classes** 的编程语言允许定义类作为公共的，受保护的或私有的属性。**Public** 属性可以从类的外部或者子类访问，**protected** 属性只能被子类访问，**private** 属性只能被类内部访问。JavaScript 从 **ES6** 开始支持类语法，但直到现在才引入了私有字段。要定义私有属性，必须在其前面加上散列符号：**`#`**。

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

console.log(orchid.get_color()); // 输出：green
console.log(orchid.#leaf_color) // 报错：SyntaxError: Private field '#leaf_color' must be declared in an enclosing class
```

如果我们从外部访问类的私有属性，势必会报错。

## Static Fields 静态字段

如果想使用类的方法，首先必须实例化一个类，如下所示：

```javascript
class Flower {
  add_leaves() {
    console.log("Adding leaves");
  }
}

const rose = new Flower();
rose.add_leaves();

Flower.add_leaves() // 抛出错误：TypeError: Flower.add_leaves is not a function
```

试图去访问没有实例化的 **Flower** 类的方法将会抛出一个错误。但由于 **static** 字段，类方法可以被 **static** 关键词声明然后从外部调用。

```javascript
class Flower {
  constructor(type) {
    this.type = type;
  }
  static create_flower(type) {
    return new Flower(type);
  }
}

const rose = Flower.create_flower("rose"); // 正常运行
```

## Top Level Await 顶级 Await

目前，如果用 **await** 获取 promise 函数的结果，那使用 **await** 的函数必须用 **async** 关键字定义。

```javascript
const func = async () => {
    const response = await fetch(url)
}
```

头疼的是，在全局作用域中去等待某些结果基本上是不可能的。除非使用 **立即调用的函数表达式（IIFE）**。

```javascript
(async () => {
    const response = await fetch(url)
})()
```

但引入了 **顶级 Await** 后，不需要再把代码包裹在一个 async 函数中了，如下即可：

```javascript
const response = await fetch(url)
```

这个特性对于解决模块依赖或当初始源无法使用而需要备用源的时候是非常有用的。

```javascript
let Vue
try {
    Vue = await import('url_1_to_vue')
} catch {
    Vue = await import('url_2_to_vue)
} 
```

## Promise.allSettled 方法

等待多个 promise 返回结果时，我们可以用 **Promise.all(\[promise\_1, promise\_2\])**。但问题是，如果其中一个请求失败了，就会抛出错误。然而，有时候我们希望某个请求失败后，其他请求的结果能够正常返回。针对这种情况 **ES11** 引入了 **Promise.allSettled** 。

```javascript
promise_1 = Promise.resolve('hello')
promise_2 = new Promise((resolve, reject) => setTimeout(reject, 200, 'problem'))

Promise.allSettled([promise_1, promise_2])
    .then(([promise_1_result, promise_2_result]) => {
        console.log(promise_1_result) // 输出：{status: 'fulfilled', value: 'hello'}
        console.log(promise_2_result) // 输出：{status: 'rejected', reason: 'problem'}
    })
```

成功的 promise 将返回一个包含 **status** 和 **value** 的对象，失败的 promise 将返回一个包含 **status** 和 **reason** 的对象。

## Dynamic Import 动态引入

你也许在 **webpack** 的模块绑定中已经使用过动态引入。但对于该特性的原生支持已经到来：

```javascript
// Alert.js
export default {
    show() {
        // 代码
    }
}


// 使用 Alert.js 的文件
import('/components/Alert.js')
    .then(Alert => {
        Alert.show()
    })
```

考虑到许多应用程序使用诸如 webpack 之类的模块打包器来进行代码的转译和优化，这个特性现在还没什么大作用。

## MatchAll 匹配所有项

如果你想要查找字符串中所有正则表达式的匹配项和它们的位置，MatchAll 非常有用。

```javascript
const regex = /\b(apple)+\b/;
const fruits = "pear, apple, banana, apple, orange, apple";


for (const match of fruits.match(regex)) {
  console.log(match); 
}
// 输出 
// 
// 'apple' 
// 'apple'
```

相比之下，**matchAll** 返回更多的信息，包括找到匹配项的索引。

```javascript
for (const match of fruits.matchAll(regex)) {
  console.log(match);
}

// 输出
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

## globalThis 全局对象

JavaScript 可以在不同环境中运行，比如浏览器或者 Node.js。浏览器中可用的全局对象是变量 **window**，但在 Node.js 中是一个叫做 **global** 的对象。为了在不同环境中都使用统一的全局对象，引入了 **globalThis** 。

```javascript
// 浏览器
window == globalThis // true

// node.js
global == globalThis // true
```

## BigInt

JavaScript 中能够精确表达的最大数字是 2^53 - 1。而 BigInt 可以用来创建更大的数字。

```javascript
const theBiggerNumber = 9007199254740991n
const evenBiggerNumber = BigInt(9007199254740991)
```

## 结论

我希望这篇文章对您有用，并像我一样期待 JavaScript 即将到来的新特性。如果想了解更多，可以看看 tc39 委员会的[官方Github仓库](https://github.com/tc39/proposals/blob/master/finished-proposals.md)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
