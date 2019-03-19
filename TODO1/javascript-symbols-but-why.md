> * 原文地址：[JavaScript Symbols: But Why?](https://medium.com/intrinsic/javascript-symbols-but-why-6b02768f4a5c)
> * 原文作者：[Thomas Hunter II](https://medium.com/@tlhunter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-symbols-but-why.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-symbols-but-why.md)
> * 译者：[xionglong58](https://github.com/xionglong58)
> * 校对者：

# JavaScript Symbols: But Why?

![](https://cdn-images-1.medium.com/max/3840/1*-6P9pSYh8qCbyzKu4AG88w.jpeg)

作为最新的基本类型，Symbols 为 JavaScript 语言带来了很多好处，特别是当其用在对象属性上时。但是，相比较于 String 类型，Symbol 有哪些 String 没有的功能呢？ 

在深入探讨 Symbols 之前，让我们先看看一些许多开发人员可能都不知道的 JavaScript 特性。

## 背景

JavaScript 中有两种数据类型：基本数据类型和对象（对象也包括函数），基本数据类型包括简单数据类型，比如 number（从整数到浮点数，从无穷到 NaN 都属于 Number 类型）、boolean、string、`undefined`、`null`（注意尽管 `typeof null=='object'`，`null` 仍然是一个基本数据类型）。

基本数据类型的值是不可以改变的，即不能更改变量的原始值。当然**可以**重新对变量进行赋值。例如，代码 `let x=1;x++`，虽然你通过重新赋值改变了变量 `x` 的值，但是变量的原始值 `1` 仍没有被改变。

Some languages, such as C, have the concept of pass-by-reference and pass-by-value. JavaScript sort of has this concept too, though, it’s inferred based on the type of data being passed around. If you ever pass a value into a function, reassigning that value will not modify the value in the calling location. However, if you **modify** a non-primitive value, the modified value **will** also be modified where it has been called from.

考虑下面的例子：

```js
function primitiveMutator(val) {
  val = val + 1;
}

let x = 1;
primitiveMutator(x);
console.log(x); // 1

function objectMutator(val) {
  val.prop = val.prop + 1;
}

let obj = { prop: 1 };
objectMutator(obj);
console.log(obj.prop); // 2
```

基本数据类型(`NaN` 除外)总是与另一个具有相同值的基本数据类型完全相等。如下:

```js
const first = "abc" + "def";
const second = "ab" + "cd" + "ef";

console.log(first === second); // true
```

然而，构造两个值相同的非基本数据类型则得到**不相等**的结果。我们可以看到发生了什么:

```js
const obj1 = { name: "Intrinsic" };
const obj2 = { name: "Intrinsic" };

console.log(obj1 === obj2); // false

// 但是，当两者的.name 属性为基本数据类型时:
console.log(obj1.name === obj2.name); // true
```

对象在 JavaScript 中扮演着重要的角色，几乎**到处**可以见到它们的身影。集合通常是键/值对的集合，然而这种形式的最大限制是：对象的键只能是字符串，直到 symbol 出现这一限制才得到解决。如果我们使用非字符串的值作为对象的键，该值会被强制转换成字符串。在下面的程序中可以看到这种强制转换：

```js
const obj = {};
obj.foo = 'foo';
obj['bar'] = 'bar';
obj[2] = 2;
obj[{}] = 'someobj';

console.log(obj);
// { '2': 2, foo: 'foo', bar: 'bar',
     '[object Object]': 'someobj' }
```

**注意**：虽然有些离题，但是需要知道的是创建 `Map` 数据结构的部分原因是为了在键不是字符串的情况下允许键/值方式存储。

## Symbol 是什么？

现在既然我们已经知道了基本数据类型是什么，也就终于可以定义 symbol。symbol 是不能被重新创建的基本数据类型。在这种情况下，symbol 类似于对象，因为对象创建多个实例也将导致不完全相等的值。但是，符号也是原始的，因为它不能被改变。下面是 symbol 用法的一个例子:

```js
const s1 = Symbol();
const s2 = Symbol();

console.log(s1 === s2); // false
```

当实例化一个 symbol 时，有一个可选的首选参数，你可以赋值一个字符串。此值用于调试代码，不会真正影响 symbol本身。

```js
const s1 = Symbol('debug');
const str = 'debug';
const s2 = Symbol('xxyy');

console.log(s1 === str); // false
console.log(s1 === s2); // false
console.log(s1); // Symbol(debug)
```

## Symbols 作为对象属性

symbols 还有另一个重要的用法，它们可以当作对象中的键!下面是一个在对象中使用 symbol 作为键的例子:


```js
const obj = {};
const sym = Symbol();
obj[sym] = 'foo';
obj.bar = 'bar';

console.log(obj); // { bar: 'bar' }
console.log(sym in obj); // true
console.log(obj[sym]); // foo
console.log(Object.keys(obj)); // ['bar']
```

注意，symbols 键不会被在 `Object.keys()` 返回。这也是为了满足向后兼容性。旧版本的 JavaScript 没有 symbol 数据类型，因此不应该从旧的 `Object.keys()` 方法中被返回。

乍一看，这就像是可以用 symbols 在对象上创建私有属性！许多其他编程语言可以在其类中有私有属性，而 JavaScript 却遗漏了这种功能，长期以来被视为其语法的一种缺点。

Unfortunately, it is still possible for code which interacts with this object to access properties whose keys are symbols. This is even possible in situations where the calling code does **not** already have access to the symbol itself. As an example, the `Reflect.ownKeys()` method is able to get a list of **all** keys on an object, both strings and symbols alike:

```js
function tryToAddPrivate(o) {
  o[Symbol('Pseudo Private')] = 42;
}

const obj = { prop: 'hello' };
tryToAddPrivate(obj);

console.log(Reflect.ownKeys(obj));
        // [ 'prop', Symbol(Pseudo Private) ]
console.log(obj[Reflect.ownKeys(obj)[1]]); // 42
```

**注意**:目前有些工作旨在处理在 JavaScript 中向类添加私有属性的问题。这个特性就是 [Private Fields](https://github.com/tc39/proposal-class-fields#Private-Fields) 虽然这不会对**所有**对象都有好处，但会对类实例的对象有好处。Private Fields 在 Chrome 74 中开始可用。

## 防止属性名冲突

symbols 可能不会直接有助于 JavaScript 中对象获得私有属性。它们之所以有用的另一个理由是，当不同的库希望向对象添加属性时 symbols 可以避免命名冲突的风险。

如果有两个不同的库希望将某种元数据附加到一个对象上，两者可能都想在对象上设置某种标识符。仅仅使用两个字符串 类型的 `id` 作为键来标识，就有很大的风险，就是多个库使用相同的键。

```js
function lib1tag(obj) {
  obj.id = 42;
}

function lib2tag(obj) {
  obj.id = 369;
}
```

应用 symbols，每个库都可以通过实例化 Symbol 类生成所需的 symbols。然后不管什么时候，都可以在相应的对象上检查、赋值 symbols对应的键值。

```js
const library1property = Symbol('lib1');
function lib1tag(obj) {
  obj[library1property] = 42;
}

const library2property = Symbol('lib2');
function lib2tag(obj) {
  obj[library2property] = 369;
}
```

For this reason it would seem that symbols **do** benefit JavaScript.
基于这个原因 symbols **确实**有益于 JavaScript。

然而，你可能会怀疑，为什么每个库不能在实例化时简单地生成一个随机字符串，或者使用一个特殊的命名空间？

```js
const library1property = uuid(); // 随机方法
function lib1tag(obj) {
  obj[library1property] = 42;
}

const library2property = 'LIB2-NAMESPACE-id'; // namespaced approach
function lib2tag(obj) {
  obj[library2property] = 369;
}
```

你有可能是正确的，上面的两种方法与使用 symbols 的方法很相似。除非两个库使用了相同的属性名，否则不会有冲突的风险。

在这一点上，机灵的读者会指出，这两种方法并不完全相同。具有唯一名称的属性名仍然有一个缺点：它们的键非常容易找到，特别是当运行代码来迭代键或以其他方式序列化对象时。请考虑以下示例：

```js
const library2property = 'LIB2-NAMESPACE-id'; // namespaced
function lib2tag(obj) {
  obj[library2property] = 369;
}

const user = {
  name: 'Thomas Hunter II',
  age: 32
};

lib2tag(user);

JSON.stringify(user);
// '{"name":"Thomas Hunter II","age":32,"LIB2-NAMESPACE-id":369}'
```

如果我们为对象的属性名使用了一个 symbol，那么 JSON 的输出将不包含 symbol 对应的值。为什么会这样？因为仅仅是 JavaScript 支持了symbols，并不意味着 JSON 规范也改变了！JSON 只允许字符串作为键，而 JavaScript 不会尝试在最终的 JSON 负载中呈现 symbol 属性。

We can easily rectify the issue where our library object strings are polluting the JSON output by making use of `Object.defineProperty()`:

```js
const library2property = uuid(); // namespaced approach
function lib2tag(obj) {
  Object.defineProperty(obj, library2property, {
    enumerable: false,
    value: 369
  });
}

const user = {
  name: 'Thomas Hunter II',
  age: 32
};

lib2tag(user);

// '{"name":"Thomas Hunter II",
"age":32,"f468c902-26ed-4b2e-81d6-5775ae7eec5d":369}'
console.log(JSON.stringify(user));
console.log(user[library2property]); // 369
```

String keys which have been “hidden” by setting their `enumerable` [descriptor](https://medium.com/intrinsic/javascript-object-property-descriptors-proxies-and-preventing-extension-1e1907aa9d10) to false behave very similarly to symbol keys. Both are hidden by `Object.keys()`, and both are revealed with `Reflect.ownKeys()`, as seen in the following example:

```js
const obj = {};
obj[Symbol()] = 1;
Object.defineProperty(obj, 'foo', {
  enumberable: false,
  value: 2
});

console.log(Object.keys(obj)); // []
console.log(Reflect.ownKeys(obj)); // [ 'foo', Symbol() ]
console.log(JSON.stringify(obj)); // {}
```

At this point we’ve **nearly** recreated symbols. Both our hidden string properties and symbols are hidden from serializers. Both properties can be extracted using the `Reflect.ownKeys()` method and are therefor not actually private. Assuming we use some sort of namespace / random value for the string version of the property name then we've removed the risk of multiple libraries accidentally having a name collision.

But, there’s still just one tiny difference. Since strings are immutable, and symbols are always guaranteed to be unique, there is still the potential for someone to generate every single possible string combination and come up with a collision. Mathematically this means symbols do provide a benefit that we just can’t get from strings.

In Node.js, when inspecting an object (such as using `console.log()`), if a method on the object named `inspect` is encountered, that function is invoked and the output is used as the logged representation of the object. As you can imagine, this behavior isn't expected by everyone and the generically-named `inspect` method often collides with objects created by users. There is now a symbol available for implementing this functionality and is available at require('util').inspect.custom. The `inspect` method is deprecated in Node.js v10 and entirely ignored in v11. Now no one will ever change the behavior of inspect by accident!

## Simulating Private Properties

Here’s an interesting approach that we can use to simulate private properties on an object. This approach will make use of another JavaScript feature available to us today: proxies. A proxy essentially wraps an object and allows us to interpose on various interactions with that object.

A proxy offers many ways to intercept actions performed on an object. The one we’re interested in affects when an attempt at reading the keys of an object occurs. I’m not going to entirely explain how proxies work, so if you’d like to learn more, check out our other post: [JavaScript Object Property Descriptors, Proxies, and Preventing Extension](https://medium.com/intrinsic/javascript-object-property-descriptors-proxies-and-preventing-extension-1e1907aa9d10).

We can use a proxy to then lie about which properties are available on our object. In this case we’re going to craft a proxy which hides our two known hidden properties, one being the string `_favColor`, and the other being the symbol assigned to `favBook`:

It’s easy to come up with the `_favColor` string: just read the source code of the library. Additionally, dynamic keys (e.g., the `uuid` example from before) can be found via brute force. But without a direct reference to the symbol, no one can access the 'Metro 2033' value from the `proxy` object.

**Node.js Caveat**: There is a feature in Node.js which breaks the privacy of proxies. This feature doesn’t exist in the JavaScript language itself and doesn’t apply in other situations, such as a web browser. It allows one to gain access to the underlying object when given a proxy. Here is an example of using this functionality to break the above private property example:

```js
const [originalObject] = process
  .binding('util')
  .getProxyDetails(proxy);

const allKeys = Reflect.ownKeys(originalObject);
console.log(allKeys[3]); // Symbol(fav book)
```

We would now need to either modify the global `Reflect` object, or modify the `util` process binding, to prevent them from being used in a particular Node.js instance. But that's one heck of a rabbit hole. If you're interested in tumbling down such a rabbit hole, check out our other blog post: [Protecting your JavaScript APIs](https://medium.com/intrinsic/protecting-your-javascript-apis-9ce5b8a0e3b5).

This article was written by me, Thomas Hunter II. I work at a company called [Intrinsic](https://intrinsic.com/) (btw, [we’re hiring](mailto:jobs@intrinsic.com)!) where we specialize in writing software for securing Node.js applications. We currently have a product which follows the Least Privilege model for securing applications. Our product proactively protects Node.js applications from attackers, and is surprisingly easy to implement. If you are looking for a way to secure your Node.js applications, give us a shout at [hello@intrinsic.com](mailto:hello@intrinsic.com).

---

**Banner photo by [Chunlea Ju](https://unsplash.com/photos/8fs1X0JFgFE?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
