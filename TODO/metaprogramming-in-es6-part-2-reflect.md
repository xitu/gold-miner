> * 原文地址：[Metaprogramming in ES6: Part 2 - Reflect](https://www.keithcirkel.co.uk/metaprogramming-in-es6-part-2-reflect/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-2-reflect.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-part-2-reflect.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[IridescentMia](https://github.com/IridescentMia) [ParadeTo](https://github.com/ParadeTo)

# ES6 中的元编程：第二部分 —— 反射（Reflect）

在我的[上一篇博文](/metaprogramming-in-es6-symbols/)，我们探索了 Symbols，以及它们是如何为 JavaScript 添加了有用的元编程特性。这一次，我们（终于！）要开始讨论反射了。如果你尚未读过 [第一部分：Symbols](/metaprogramming-in-es6-symbols/)，那我建议你先去读读。在上一篇文章中，我不厌其烦地强调一点：

* Symbols 是 **实现了的反射（Reflection within implementation）**—— 你将 Symbols 应用到你已有的类和对象上去改变它们的行为。
* Reflect 是 **通过自省（introspection）实现反射（Reflection through introspection）** —— 通常用来探索非常底层的代码信息。
* Proxy 是 **通过调解（intercession）实现反射（Reflection through intercession）** —— 包裹对象并通过自陷（trap）来拦截对象行为。

`Reflect` 是一个新的全局对象（类似 `JSON` 或者 `Math`），该对象提供了大量有用的内省（introspection）方法（内省是 “看看那个东西” 的一个非常华丽的表述）。内省工具已经存在于 JavaScript 了，例如 `Object.keys`，`Object.getOwnPropertyNames` 等等。所以，为什么我们仍然新的 API ，而不是直接在 Object 上做扩展呢？ 

## “内置方法”

所有的 JavaScript 规范，以及因此诞生的引擎，都来源于一系列的 “内置方法”。这些内置方法能够有效地让 JavaScript 引擎在对象上执行一些遍布你代码的基础操作。如果你通读了规范，你会发现这些方法散落各处，例如 `[[Get]]`、`[[Set]]`、`[[HasOwnProperty]]` 等等（如果你没有耐心通读所有规范，那么这些内置方法列表在 [ES5 8.12 部分](https://es5.github.io/#x8.12) 以及 [ES6 9.1 部分](https://www.ecma-international.org/ecma-262/6.0/index.html#sec-ordinary-object-internal-methods-and-internal-slots) 可以查阅到）。

其中一些 “内置方法” 对 JavaScript 代码是隐藏的，另一些则应用在了其他方法中，即使这些方法可用，它们仍被隐藏于难于窥见的缝隙之中。例如，`Object.prototype.hasOwnProperty` 是 `[[HasOwnProperty]]` 的一个实现，但不是所有的对象都继承自 Object，为此，有时你不得不写出一些古怪的代码才能用上 `hasOwnProperty`，如下例所示：

```js
var myObject = Object.create(null); // 这段代码比你想象得更加常见（尤其是在使用了新的 ES6 的类的时候）
assert(myObject.hasOwnProperty === undefined);
// 如果你想在 `myObject` 上使用 hasOwnProperty：
Object.prototype.hasOwnProperty.call(myObject, 'foo');
```

再看到另一个例子，`[[OwnPropertyKeys]]` 这一内置方法能获得对象上所有的字符串 key 和 Symbol key，并作为一个数组返回。在不使用 Reflect 的情况下，能一次性获得这些 key 的方式只有连接 `Object.getOwnPropertyNames` 和 `Object.getOwnPropertySymbols` 的结果：

```js
var s = Symbol('foo');
var k = 'bar';
var o = { [s]: 1, [k]: 1 };
// 模拟 [[OwnPropertyKeys]]
var keys = Object.getOwnPropertyNames(o).concat(Object.getOwnPropertySymbols(o));
assert.deepEqual(keys, [k, s]);
```

## 反射方法

反射是一个非常有用的集合，它囊括了所有 JavaScript 引擎内部专有的 **“内部方法”**，现在被暴露为了一个单一、方便的对象 —— Reflect。你可能会问：“这听起来不错，但是为什么不直接将内置方法绑定到 Object 上呢？就像 `Object.keys`、`Object.getOwnPropertyNames` 这样”。现在，我告诉你这么做的理由：

1. 反射拥有的方法不仅针对于 Object，还可能针对于函数，例如 `Reflect.apply`，毕竟调用 `Object.apply(myFunction)` 看起来太怪了。  
2. 用一个单一对象贮存内置方法能保持 JavaScript 其余部分的纯净性，这要优于将反射方法通过点操作符挂载到构造函数或者原型上，更要优于直接使用全局变量。 
3. `typeof`、`instanceof` 以及 `delete` 已经作为反射运算符存在了 —— 为此添加同样功能的新关键字将会加重开发者的负担，同时，对于向后兼容性也是一个梦魇，并且会让 JavaScript 中的保留字数量急速膨胀。

### Reflect.apply ( target, thisArgument [, argumentList] )

`Reflect.apply` 与 `Function#apply` 类似 —— 它接受一个函数，一个调用该函数的上下文以及一个参数数组。从现在开始，你 **可以** 认为 `Function#call`/`Function#apply` 的已经是过时版本了。这不是翻天覆地的变化，但却有很大意义。下面展示了 `Reflect.apply` 的用法：

```js
var ages = [11, 33, 12, 54, 18, 96];

// Function.prototype 风格：
var youngest = Math.min.apply(Math, ages);
var oldest = Math.max.apply(Math, ages);
var type = Object.prototype.toString.call(youngest);

// Reflect 风格：
var youngest = Reflect.apply(Math.min, Math, ages);
var oldest = Reflect.apply(Math.max, Math, ages);
var type = Reflect.apply(Object.prototype.toString, youngest);
```

从 Function.prototype.apply 到 Reflect.apply 的变迁的真正益处是防御性：任何代码都能够尝试改变函数的 `call` 或者 `apply` 方法，这会让你受困于崩溃的代码或者某些糟糕的情境。在现实世界中，这不会成为一件大事，但是下面这样的代码可能真正存在：

```js
function totalNumbers() {
  return Array.prototype.reduce.call(arguments, function (total, next) {
    return total + next;
  }, 0);
}
totalNumbers.apply = function () {
  throw new Error('Aha got you!');
}

totalNumbers.apply(null, [1, 2, 3, 4]); // 抛出 Error('Aha got you!');

// ES5 中保证防御性的代码看起来很糟糕：
Function.prototype.apply.call(totalNumbers, null, [1, 2, 3, 4]) === 10;

// 你也可以这样做，但看起来还是不够整洁：
Function.apply.call(totalNumbers, null, [1, 2, 3, 4]) === 10;

// Reflect.apply 会是救世主！
Reflect.apply(totalNumbers, null, [1, 2, 3, 4]) === 10;
```

### Reflect.construct ( target, argumentsList [, constructorToCreateThis] )

类似于 `Reflect.apply` —— `Reflect.construct` 让你传入一系列参数来调用构造函数。它能够服务于类，并且设置正确的对象来使 Constructor 有正确的 `this` 引用以匹配对应的原型。在 ES5 时期，你会使用 `Object.create(Constructor.prototype)` 模式，然后传递对象到 `Constructor.call` 或者 `Constructor.apply`。 `Reflect.construct` 的不同之处在于，你只需要传递构造函数，而不需要传递对象 —— `Reflect.construct` 处理好一切（如果省略第三个参数，那么构造的对象原型将默认绑定到 `target` 参数）。在之前的风格中，完成对象构造是一件繁重的事儿，而在新的风格之下，这事儿简单到一行代码即可完成：

```js
class Greeting {

    constructor(name) {
        this.name = name;
    }

    greet() {
      return Hello ${this.name};
    }

}

// ES5 风格的工厂函数：
function greetingFactory(name) {
    var instance = Object.create(Greeting.prototype);
    Greeting.call(instance, name);
    return instance;
}

// ES6 风格的工厂函数：
function greetingFactory(name) {
    return Reflect.construct(Greeting, [name], Greeting);
}

// 如果省略第三个参数，那么默认绑定对象原型到第一个参数
function greetingFactory(name) {
  return Reflect.construct(Greeting, [name]);
}

// ES6 下顺滑无比的线性工厂函数：
const greetingFactory = (name) => Reflect.construct(Greeting, [name]);
```

### Reflect.defineProperty ( target, propertyKey, attributes )

`Reflect.definedProperty` 很大程度上源于 `Object.defineProperty` —— 它允许你定义一个属性的元信息。 相较于 `Object.defineProperty`，`Reflect.defineProperty` 要更加适合，因为 Obejct.* 暗示了它是作用在对象字面量上（毕竟 Object 是对象字面量的构造函数），然而 Reflect.defineProperty 仅只暗示了你正在做反射，这要更加的语义化。

要留心的是 `Reflect.defineProperty` —— 正如 `Object.defineProperty` 一样 —— 对于无效的 `target`，例如 Number 或者 String 原始值（`Reflect.defineProperty(1, 'foo')`），将抛出一个 `TypeError`。相较于静默失败，当参数类型错误时，抛出错误以引起你的注意是一件更好的事儿。

再重复一次，你可以认为 `Object.defineProperty` 从现在起过时了，并使用 `Reflect.defineProperty` 代替：

```js
function MyDate() {
  /*…*/
}

// 老的风格下，我们使用 Object.defineProperty 来定义一个函数的属性，显得很奇怪
// （为什么我们不用 Function.defineProperty ？）
Object.defineProperty(MyDate, 'now', {
  value: () => currentms
});

// 新的风格下，语义就通畅得多，因为 Reflect 只是在做反射。
Reflect.defineProperty(MyDate, 'now', {
  value: () => currentms
});
```

### Reflect.getOwnPropertyDescriptor ( target, propertyKey )

同上面一样，我们优先使用 `Reflect.getOwnPropertyDescriptor` 代替 `Object.getOwnPropertyDescriptor` 来获得一个属性的描述子元信息。与 `Object.getOwnPropertyDescriptor(1, 'foo')` 会静默失败，返回 `undefined` 不同，`Reflect.getOwnPropertyDescriptor(1, 'foo')` 将抛出一个 `TypeError` 错误 —— 与 `Reflect.defineProperty` 一样，该错误是针对于 `target` 无效抛出的。你现在也知道了，我们可以使用 `Reflect.getOwnPropertyDescriptor` 替换掉 `Object.getOwnPropertyDescriptor` 了：

```js
var myObject = {};
Object.defineProperty(myObject, 'hidden', {
  value: true,
  enumerable: false,
});
var theDescriptor = Reflect.getOwnPropertyDescriptor(myObject, 'hidden');
assert.deepEqual(theDescriptor, { value: true, enumerable: true });

// 老的风格
var theDescriptor = Object.getOwnPropertyDescriptor(myObject, 'hidden');
assert.deepEqual(theDescriptor, { value: true, enumerable: true });

assert(Object.getOwnPropertyDescriptor(1, 'foo') === undefined)
Reflect.getOwnPropertyDescriptor(1, 'foo'); // throws TypeError
```

### Reflect.deleteProperty ( target, propertyKey )

非常非常令人兴奋，`Reflect.deleteProperty` 能够删除目标对象上的一个属性。在 ES6 之前，你一般是通过 `delete obj.foo`，现在，你可以使用 `Reflect.deleteProperty(obj, 'foo')` 来删除对象属性了。`Reflect.deleteProperty` 稍显冗长，在语义上与 `delete` 关键字有些不同，但对于删除对象却有相同的作用。二者都是调用内置的 `target[[Delete]](propertyKey)` 方法 —— 但是 `delete` 运算也能 “工作” 在非对象引用上（例如变量），因此它会对传递给它的运算数做更多的检查，潜在地，也就存在抛出错误的可能性：

```js
var myObj = { foo: 'bar' };
delete myObj.foo;
assert(myObj.hasOwnProperty('foo') === false);

myObj = { foo: 'bar' };
Reflect.deleteProperty(myObj, 'foo');
assert(myObj.hasOwnProperty('foo') === false);
```

再重复一遍，如果你想的话，你可以考虑使用这个 “新的方式” 来删除属性。这个方式显然意图更加明确，就是删除属性。

### Reflect.getPrototypeOf ( target )

关于替代/淘汰 Object 方法的议题还在继续 —— 这一次该是 `Object.getPrototypeOf` 了。正如其兄妹方法一样，如果你传入了一个诸如 Number 和 String 字面量、`null` 或者是 `undefined` 这样无效的 `target`，`Reflect.getPropertyOf` 将抛出一个 `TypeError` 错误，而 `Object.getPropertyOf` 强制转化 `target` 为一个对象 —— 所以 `'a'` 变为了 `Object('a')`。除了语法以外，二者几乎相同：

```js
var myObj = new FancyThing();
assert(Reflect.getPrototypeOf(myObj) === FancyThing.prototype);

// 老的风格
assert(Object.getPrototypeOf(myObj) === FancyThing.prototype);

Object.getPrototypeOf(1); // undefined
Reflect.getPrototypeOf(1); // TypeError
```

### Reflect.setPrototypeOf ( target, proto )

当然，`getProtopertyOf` 不能没了 `setPropertyOf`。现在，`Object.setPrototypeOf` 对于传入非对象参数，将抛出错误，但它会尝试将传入参数强制转换为 Object，并且如果内置的 `[[SetPrototype]]` 操作失败，将抛出 `TypeError`，而如果成功的话，将返回 `target` 参数。`Reflect.setPrototypeOf` 则更加简单基础 —— 如果其收到了一个非对象参数，它就将抛出一个 `TypeError` 错误，但除此之外，它还会返回 `[[SetPrototypeOf]]` 的结果 —— 这是一个 Boolean 值，指出了操作是否错误。这是很有用的，因为你可以直接知晓操作错误与否，而不需要使用 `try`/`catch`，这将会俘获其他由于参数传递错误造成的 `TypeErrors`。 

```js
var myObj = new FancyThing();
assert(Reflect.setPrototypeOf(myObj, OtherThing.prototype) === true);
assert(Reflect.getPrototypeOf(myObj) === OtherThing.prototype);

// 老的风格
assert(Object.setPrototypeOf(myObj, OtherThing.prototype) === myObj);
assert(Object.getPrototypeOf(myObj) === FancyThing.prototype);

Object.setPrototypeOf(1); // TypeError
Reflect.setPrototypeOf(1); // TypeError

var myFrozenObj = new FancyThing();
Object.freeze(myFrozenObj);

Object.setPrototypeOf(myFrozenObj); // TypeError
assert(Reflect.setPrototypeOf(myFrozenObj) === false);
```

### Reflect.isExtensible (target)

再一次强调这是用来替代 `Object.isExtensible` 的 —— 但是它比后者要更加复杂。在 ES6 之前（例如说 ES5），如果你传入了非对象参数（`typeof target !== object`），`Object.isExtensible` 会抛出一个 `TypeError`。ES6 则在语义上发生了改变（天哪！居然改变了现有的 API！）使得传入非对象参数时，`Object.isExtensible` 返回 `false` —— 因为非对象确实就是不可扩展。所以在 ES6 下，这个早先会抛出错误的语句：`Object.isExtensible(1) === false` 现在表现得如你所想，语义更加准确。

上面简短的历史回顾引出关键点就是 `Reflect.isExtensible` 使用的是老旧行为，即当传入非对象参数时，抛出错误。我不真正确定为什么它要这么做，但它确实这么做了。所以技术上 `Reflect.isExtensible` 改变了 `Object.isExtensible` 的语义，但是 `Object.isExtensible` 自己也发生了语义改变。下面的代码说明了这些：

```js
var myObject = {};
var myNonExtensibleObject = Object.preventExtensions({});

assert(Reflect.isExtensible(myObject) === true);
assert(Reflect.isExtensible(myNonExtensibleObject) === false);
Reflect.isExtensible(1); // 抛出 TypeError
Reflect.isExtensible(false);  // 抛出 TypeError

// 使用 Object.isExtensible
assert(Object.isExtensible(myObject) === true);
assert(Object.isExtensible(myNonExtensibleObject) === false);

// ES5 Object.isExtensible 语义
Object.isExtensible(1); // 在老版本的浏览器下，会抛出 TypeError
Object.isExtensible(false);  // 在老版本的浏览器下，会抛出 TypeError

// ES6 Object.isExtensible 语义
assert(Object.isExtensible(1) === false); // 只工作在新的浏览器
assert(Object.isExtensible(false) === false); // 只工作在新的浏览器
```

### Reflect.preventExtensions ( target )

这是最后一个反射对象从 Object 上借鉴的方法。它和 `Reflect.isExtensible` 有类似的故事；ES5 的 `Object.preventExtensions` 过去会对非对象参数抛出错误，但是现在，在 ES6 中，它会返回传入值，而 `Reflect.preventExtensions` 遵从的则是老的 ES5 行为 —— 即对非对象参数抛出错误。另外，在操作成功的情况下，`Object.preventExtensions` 可能抛出错误，但 `Reflect.preventExtension` 仅简单地返回 true 或者 false，允许你优雅地操控失败场景：

```js
var myObject = {};
var myObjectWhichCantPreventExtensions = magicalVoodooProxyCode({});

assert(Reflect.preventExtensions(myObject) === true);
assert(Reflect.preventExtensions(myObjectWhichCantPreventExtensions) === false);
Reflect.preventExtensions(1); // 抛出 TypeError
Reflect.preventExtensions(false);  // 抛出 TypeError

// 使用 Object.preventExtensions
assert(Object.preventExtensions(myObject) === true);
Object.preventExtensions(myObjectWhichCantPreventExtensions); // throws TypeError

// ES5 Object.preventExtensions 语义
Object.preventExtensions(1); // 抛出 TypeError
Object.preventExtensions(false);  // 抛出 TypeError

// ES6 Object.preventExtensions 语义
assert(Object.preventExtensions(1) === 1);
assert(Object.preventExtensions(false) === false);
```

### Reflect.enumerate ( target )

> 更新：在 ES2016（也称 ES7）中，这被删除了。`myObject[Symbol.iterator]()` 是在对象 key 或者 value 上迭代的唯一方式。

最后，将引出一个全新的 Reflect 方法！`Reflect.enumerate` 使用了和新的 `Symbol.iterator` 函数（在前一章节，已对此有过讨论） 一样的语法，二者都使用了隐藏的，只有 JavaScript 引擎知道的 `[[Enumerate]]` 方法。换句话说，`Reflect.enumerate` 的唯一替代只是 `myObject[Symbol.iterator()]`，只是后者可以被重写，而前者不行。使用范例如下：

```js
var myArray = [1, 2, 3];
myArray[Symbol.enumerate] = function () {
  throw new Error('Nope!');
}
for (let item of myArray) { // error thrown: Nope!
}
for (let item of Reflect.enumerate(myArray)) {
  // 1 then 2 then 3
}
```

### Reflect.get ( target, propertyKey [ , receiver ])

`Reflect.get` 也是一个全新的方法。它是一个非常简单的方法，其有效地调用了 `target[propertyKey]`。如果 `target` 是一个非对象，函数调用将抛出错误 —— 这是很有用的，因为目前如果你写了 `1['foo']` 这样的代码，它只会静默返回 `undefined`，而 `Reflect.get(1, 'foo')` 将抛出一个 `TypeError` 错误！`Reflect.get` 一个有趣的部分是它的 `receiver` 参数，如果 `target[propertyKey]` 是一个 getter 函数，它则作为该函数的 this，例子如下所示：

```js
var myObject = {
  foo: 1,
  bar: 2,
  get baz() {
    return this.foo + this.bar;
  },
}

assert(Reflect.get(myObject, 'foo') === 1);
assert(Reflect.get(myObject, 'bar') === 2);
assert(Reflect.get(myObject, 'baz') === 3);
assert(Reflect.get(myObject, 'baz', myObject) === 3);

var myReceiverObject = {
  foo: 4,
  bar: 4,
};
assert(Reflect.get(myObject, 'baz', myReceiverObject) === 8);

// 非对象将抛出错误
Reflect.get(1, 'foo'); // 抛出 TypeError
Reflect.get(false, 'foo'); // 抛出 TypeError

// 老的风格下，静默返回 `undefined`：
assert(1['foo'] === undefined);
assert(false['foo'] === undefined);
```

### Reflect.set ( target, propertyKey, V [ , receiver ] )

你大致能够猜出该方法是做什么的。它是 `Reflect.get` 的兄弟方法，它接收另外一个参数 —— 需要被设置的值。如 `Reflect.get` 一样，`Reflect.set` 将在传入非对象参数时，抛出错误，并且也有一个 `receiver` 参数指明 `target[propertyKey]` 为 setter 函数时使用的 `this`。必须上个代码示例：

```js
var myObject = {
  foo: 1,
  set bar(value) {
    return this.foo = value;
  },
}

assert(myObject.foo === 1);
assert(Reflect.set(myObject, 'foo', 2));
assert(myObject.foo === 2);
assert(Reflect.set(myObject, 'bar', 3));
assert(myObject.foo === 3);
assert(Reflect.set(myObject, 'bar', myObject) === 4);
assert(myObject.foo === 4);

var myReceiverObject = {
  foo: 0,
};
assert(Reflect.set(myObject, 'bar', 1, myReceiverObject));
assert(myObject.foo === 4);
assert(myReceiverObject.foo === 1);

// 非对象将抛出错误
Reflect.set(1, 'foo', {}); // 抛出 TypeError
Reflect.set(false, 'foo', {}); // 抛出 TypeError

// 老的风格下，静默返回 `undefined`：
1['foo'] = {};
false['foo'] = {};
assert(1['foo'] === undefined);
assert(false['foo'] === undefined);
```

### Reflect.has ( target, propertyKey )

`Reflect.has` 是一个非常有趣的方法，因为它本质上与 `in` 运算符有一样的功能（在循环之外）。二者都使用了内置的 `[[HasProperty]]`，并且都会在 `target` 不为对象时抛出错误。除非你更偏向于函数调用的风格，相较于 `in`，没有多少使用 `Reflect.has` 的理由，但是它在语言的其他方面有重要的使用，这将在下一章有清楚的讲述。无论如何，先看看怎么用它：

```js
myObject = {
  foo: 1,
};
Object.setPrototypeOf(myObject, {
  get bar() {
    return 2;
  },
  baz: 3,
});

// 不使用 Reflect.has：
assert(('foo' in myObject) === true);
assert(('bar' in myObject) === true);
assert(('baz' in myObject) === true);
assert(('bing' in myObject) === false);

// 使用 Reflect.has：
assert(Reflect.has(myObject, 'foo') === true);
assert(Reflect.has(myObject, 'bar') === true);
assert(Reflect.has(myObject, 'baz') === true);
assert(Reflect.has(myObject, 'bing') === false);
```

### Reflect.ownKeys ( target )

该方法已经在本文有所提及了，你可以看到 `Reflect.ownKeys` 实现了 `[[OwnPropertyKeys]]`，你回想一下上文的内容，你知道它连接了 `Object.getOwnPropertyNames` 和 `Object.getOwnPropertySymbols` 的结果。这让 `Reflect.ownKeys` 有着不可替代的作用。下面看到用法： 

```js
var myObject = {
  foo: 1,
  bar: 2,
  [Symbol.for('baz')]: 3,
  [Symbol.for('bing')]: 4,
};

assert.deepEqual(Object.getOwnPropertyNames(myObject), ['foo', 'bar']);
assert.deepEqual(Object.getOwnPropertySymbols(myObject), [Symbol.for('baz'), Symbol.for('bing')]);

// 不使用 Reflect.ownKeys：
var keys = Object.getOwnPropertyNames(myObject).concat(Object.getOwnPropertySymbols(myObject));
assert.deepEqual(keys, ['foo', 'bar', Symbol.for('baz'), Symbol.for('bing')]);

// 使用 Reflect.ownKeys：
assert.deepEqual(Reflect.ownKeys(myObject), ['foo', 'bar', Symbol.for('baz'), Symbol.for('bing')]);
```

## 结论

我们对各个 Reflect 方法进行了彻底的讨论。我们看到了一些现有方法的新版本，一些做了微调，一些则是完完全全新的方法 —— 这将 JavaScript 的反射提升到了一个新的层面。如果你想的话，大可以完全的抛弃 `Object`.`*/Function.*` 方法，用 `Reflect` 替代之，如果你不想的话，别担心，不用就不用，什么都不会改变。

现在，我不想你看完两手空空，毫无所获。如果你想要使用 `Reflect`，我们已经给予了你支持 —— 作为这个文章背后工作的一部分，我提交了一个 [pull request 到 eslint](https://github.com/eslint/eslint/pull/2996)，在 `v1.0.0` 版本，[ESlint 有了一个](http://eslint.org/docs/rules/prefer-reflect) `prefer-reflect` [规则](http://eslint.org/docs/rules/prefer-reflect)，这可以让你在使用老旧版本的 Reflect 方法时，得到 ESLint 的提示。你也可以看下我的 [eslint-config-strict](https://github.com/keithamus/eslint-config-strict) 配置，该开启 `prefer-reflect` 规则（也添加了许多额外的规则）。当然，如果你决定你想要使用 Reflect，你可能需要 polyfill 它；幸运的是，现在已经有了一些好的 polyfill，如 [core-js](https://github.com/zloirock/core-js) 和 [harmony-reflect](https://github.com/tvcutsem/harmony-reflect)。

对于新的 Reflect API ，你是怎么看待的 ？计划在你的项目中使用它了 ？可以在我的 Twitter 给我留言，我是 [@keithamus](https://twitter.com/keithamus)。

也别忘了，这个系列的第三部分 —— 代理（Proxy）也快发布了，我不会再拖延两个月了。

最后，要谢谢 [@mttshw](https://twitter.com/mttshw) 和 [@WebReflection](https://twitter.com/WebReflection) 对我工作的审视，才让文章比预计的更加高质。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
