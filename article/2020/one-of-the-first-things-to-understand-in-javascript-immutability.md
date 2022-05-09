> * 原文地址：[One of the first things to understand in JavaScript — Immutability](https://medium.com/javascript-in-plain-english/one-of-the-first-things-to-understand-in-javascript-immutability-629fabdf4fee)
> * 原文作者：[Daryll Wong](https://medium.com/@daryllwong)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/one-of-the-first-things-to-understand-in-javascript-immutability.md](https://github.com/xitu/gold-miner/blob/master/article/2020/one-of-the-first-things-to-understand-in-javascript-immutability.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)、[finalwhy](https://githu.com/finalwhy)
> * 校对者：[finalwhy](https://githu.com/finalwhy)、[DylanXie123](https://github.com/DylanXie123)

# JavaScript 首要知识之不可变性

![](https://cdn-images-1.medium.com/max/6136/1*4PrMNL-FF9Z5G5BXJliAYg.png)

我们来回顾一下基础：“在 JavaScript 中，变量和常量是不可变的吗？”

答案是 **都不是**，如果你对这个答案有任何疑惑，请继续读下去。每种编程语言有自己的特性，在 JavaScript 中，这是最值得注意的几件事情之一，尤其是当我们正在学习另一些语言（如 Python, Java 等）的时候。

你不必立即改变编写 JavaScript 代码的方式，但是尽早地了解这一点，将会防止你在未来陷入难以调试的困难局面。我也会介绍一些能够防止你陷入这种问题的方法 —— 浅拷贝和深拷贝的一些不同的方法。

我们在开始之前，先快速浏览一下摘要：

**变量**（使用 `let` 初始化）—— 可变，可重新赋值
**常量**（使用 `const` 初始化）—— 不可变，不可重新赋值

---

在我们开始解释 JavaScript 的可变性之前，首先看一下基础知识…… 你可以略过这部分。

在 JavaScript 中，有几组数据类型：

1. **原生（基本）类型** —— Boolean, Number, String
2. **非原始（引用）类型或对象** —— Object, Array, Function
3. **特殊** —— Null, Undefined

**提示：你可以使用 console.log(typeof unknownVar) 来获取你正在使用的变量的数据类型**

#### 原生数据类型默认是不可变的

对于原生数据类型而言 (如 boolean、number、string 等), 如果使用常量来声明的话，它们是**不可变**的。因为对于这些数据类型而言，你不能加入额外的属性，或改动已有的属性。

要「改变」原生数据类型，你就需要重新赋值。这只有在将其作为变量声明的时候才有可能。

```js
let var1 = 'apple' //'apple' is stored in memory location A
var1 = 'orange' //'orange' is stored in memory location B

const var2 = 'apple'
var2 = 'orange' // ERROR: Re-assignment not allowed for constants
```

![](https://cdn-images-1.medium.com/max/2464/1*xyaMxzBMpouTQbMr-O0pXg.png)

在上述例子中，如果我们修改 var1 这个 string，JavaScript 将会在内存中的另一个位置创造另一个 string，而 var1 将会指向这个新的内存位置，这被称为 **重新赋值**。这对于所有 **原生数据类型** 都适用，无论是被声明为变量还是常量。

而所有的常量都不能被重新赋值。

## 在 JavaScript 中，对象是引用传递的

当我们在处理**对象**时，问题开始出现了……

#### 对象并非不可变的

对象基本上指的是非原生的数据类型 （对象、 数组 和 函数），哪怕被作为常量声明，它们也是可变的。

**（在本文的剩余部分，我将以对象数据类型举例。因为大多数问题是出在这里的。对于数组和函数而言，概念也会是一样的）**

所以这是什么意思？

```js
const profile1 = {'username':'peter'}
profile1.username = 'tom'
console.log(profile1) //{'username':'tom'}
```

![](https://cdn-images-1.medium.com/max/3448/1*FluTwbCYFCQO6pW5enoLoQ.png)

在这种情况下，profile1 一直指向位于同一内存位置的对象。我们所做的是修改位于内存该位置的对象的属性。

好吧，这看起来非常简单，但为什么会有问题呢？

#### 当对对象的修改出现了问题……

```js
const sampleprofile = {'username':'name', 'pw': '123'}
const profile1 = sampleprofile

profile1.username = 'harry'

console.log(profile1) // {'username':'harry', 'pw': '123'}
console.log(sampleprofile) // {'username':'harry', 'pw': '123'}
```

**看起来像是几行你可能会不小心写下的代码，对吧？其实，这里已经有一个问题了！**

因为对象在 JavaScript 中是引用传递的。

![](https://cdn-images-1.medium.com/max/3720/1*K7JS9v4pbm1b0W4yaf-fZQ.png)

这里所谓的「**引用传递**」是指，我们把对常量 sampleprofile 的引用传递给 profile1。换句话说，profile1 和 sampleprofile 两个常量指向 **位于同一内存位置** 的同一个对象。

所以，当我们修改常量 profile1 的属性时，它同时也影响了 sampleprofile，因为它们都指向同一个对象。

```js
console.log(sampleprofile===profile1)//true
```

**这只是引用传递（也是修改变量）会造成问题的一个简单例子。我们可以想象，当代码逐步变得复杂时，情况将变得多么危险。如果我们不清楚这一点，修复特定 bug 将变得相当困难。**

所以，我们如何避免这些潜在的问题呢？

为了更有效地面对修改对象的问题，有两个概念我们应当清楚：

* **通过冻结对象来防止修改**
* **使用浅拷贝和深拷贝**

我将向你展示一些使用 JavaScript 实现的例子，包括使用 vanilla JavaScript 方法，以及一些我们可以使用的有用的三方库。

## 防止修改对象

#### 1. 使用 Object.freeze() 方法

如果你想要防止一个对象的属性被改变，你可以使用 `Object.freeze()` 。它的作用是，防止对象已有的属性被改变。任何改变的尝试都会静默失败，意味着它不会成功，也不会有任何警告。


```js
const sampleprofile = {'username':'name', 'pw': '123'}

Object.freeze(sampleprofile)

sampleprofile.username = 'another name' // no effect

console.log(sampleprofile) // {'username':'name', 'pw': '123'}
```

但是，这是一种 **浅冻结**，即它对于深层嵌套的对象将不会有用：

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

在上面的例子中，嵌套对象的属性仍然可以改变。

你可以创造一个简单的函数来递归地冻结嵌套的对象，但如果你比较懒的话，可以使用以下这些库：

#### 2. 使用深层冻结

但说真的，如果你看看 [深层冻结](https://www.npmjs.com/package/deep-freeze) 的[源代码](https://github.com/substack/deep-freeze/blob/master/index.js), 它基本上只是一个简单的递归调用函数，但不管怎样，这是一种更便捷的选择...

```js
var deepFreeze = require('deep-freeze');

const sampleprofile = {
  'username':'name',
  'pw': '123',
  'particulars':{'firstname':'name', 'lastname':'name'}
}

deepFreeze(sampleprofile)
```

深层冻结的另一个选择是 [ImmutableJS](https://immutable-js.github.io/immutable-js/) ，一些人可能更喜欢使用它，因为当你试图修改一个用这个库创造的对象时，它会抛出错误。

---

## 避免和引用传递相关的问题

关键在于理解 JavaScript 中的 **深浅 拷贝/克隆/融合**。

你可能会使用浅拷贝或使用深拷贝，这取决于你程序中对象的具体实现方式，也可能存在内存或性能方面的考虑，会影响你对深拷贝和浅拷贝的选择。但我会在涉及到的时候再讲的 😉。

让我们从浅拷贝开始，然后再到深拷贝。

## 浅拷贝

#### 1. 使用展开操作符 (…)

ES6 引入的展开操作符给我们提供了一种更干净的方式来合并数组和对象。

```js
const firstSet = [1, 2, 3];
const secondSet= [4, 5, 6];
const firstSetCopy = [...firstset]
const resultSet = [...firstSet, ...secondSet];

console.log(firstSetCopy) // [1, 2, 3]
console.log(resultSet) // [1,2,3,4,5,6]
```

ES2018 把展开操作符扩展到了对象字面量，所以我们可以对对象做同样的事。所有对象的属性将被合并在一起，但对于冲突的属性，后展开的对象有更高的优先级。

```js
const profile1 = {'username':'name', 'pw': '123', 'age': 16}
const profile2 = {'username':'tom', 'pw': '1234'}
const profile1Copy = {...profile1}
const resultProfile = {...profile1, ...profile2}

console.log(profile1Copy) // {'username':'name', 'pw': '123', 'age': 16}
console.log(resultProfile) // {'username':'tom', 'pw': '1234', 'age': 16}
```

#### 2. 使用 Object.assign() 方法

这和使用上面的展开操作符相似，可以被用于数组和对象。

```js
const profile1 = {'username':'name', 'pw': '123', 'age': 16}
const profile2 = {'username':'tom', 'pw': '1234'}
const profile1Copy = Object.assign({}, profile1)
const resultProfile = Object.assign({},...profile1, ...profile2)
```

注意，我使用了一个空对象 `{}` 作为第一个输入，因为这个方法使用浅融合的结果更新第一个输入。

#### 3. 使用 Array.slice()

这只是 **浅克隆数组** 的一种简便方法！

```js
const firstSet = [1, 2, 3];
const firstSetCopy = firstSet.slice()

console.log(firstSetCopy) // [1, 2, 3]

//note that they are not the same objects
console.log(firstSet===firstSetCopy) // false
```

#### 4. 使用 lodash.clone()

注意，lodash 也有一种方法可以做浅克隆。我觉得这有些小题大做了（除非你已经引入了 lodash），但我仍然要在这里留一个例子。

```js
const clone = require('lodash/clone')

const profile1 = {'username':'name', 'pw': '123', 'age': 16}
const profile1Copy = clone(profile1)

// ...
```

#### 浅克隆的问题:

对于所有这些浅克隆的例子，一旦涉及 **对象的深层嵌套**，问题就开始出现了，就像下面的例子一样。

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

注意，修改 `profile1` 的嵌套属性 `firstname`，同样会影响 `sampleprofile`。

![](https://cdn-images-1.medium.com/max/4912/1*7QbV9c0-yJ98rgeciFYgCg.png)

对于浅克隆，对于嵌套对象的复制也是复制引用。 所以 `sampleprofile` 和 `profile1` 的 ‘particulars’ 指向位于内存同个位置的对象。

为防止上述问题发生，并实现 100% 真实的拷贝，没有外部引用，我们需要使用 **深拷贝**。

## 深拷贝

#### 1. 使用 JSON.stringify() 和 JSON.parse()

这在之前是不可能的，但是对于 ES6 而言，JSON.stringify() 方法也可以做嵌套对象的深拷贝。但是，注意这个方法只对于 Number, String 和 Boolean 数据类型适用。这是一个 JSFiddle 中的例子，你可以用它来试试什么被拷贝了，什么没有。

基本上如果你只使用原生数据类型和简单的对象，可以简单地用一行代码搞定。

#### 2. 使用 lodash.deepclone()

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

**供参考，lodash 包含在通过 create-react-app 创建的 react app 中**

#### 3. 自定义递归函数

如果你不想要下载一个库来做深拷贝，你也完全可以使用简单的递归函数。

下面的代码（虽然不包括所有情况）给出了一个大概的想法。

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

也许下载一个库来实现深克隆更简单？也有其他的 **微型库** 像 [rfdc](https://www.npmjs.com/package/rfdc), [clone](https://www.npmjs.com/package/clone), [deepmerge](https://www.npmjs.com/package/deepmerge) 等可以做这件事，而且比 lodash 小很多。你不必为了使用一个函数而下载整个 lodash 库。

---

希望这可以帮助你理解 JavaScript 面向对象特性，以及如何处理涉及到修改对象的 bug。这也是常见的 JavaScript 面试问题。感谢阅读！ :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
