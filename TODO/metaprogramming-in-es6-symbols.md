> * 原文地址：[Metaprogramming in ES6: Symbols and why they're awesome](https://www.keithcirkel.co.uk/metaprogramming-in-es6-symbols/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-symbols.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：

# 元编程：Symbol，了不起的 Symbol

你已经听说过 ES6 了，是吧？这是一个在多方面表现卓著的 JavaScript 的新版本。每当在 ES6 中发现令人惊叹的新特性，我就会开始对我的同事滔滔不绝起来（但是因此占用了别人的午休时间并不是所有人乐意的）。

一系列优秀的 ES6 的新特性都来自于新的元编程工具，这些工具提供了到代码。目前，介绍 ES6 元编程的文章寥寥，所以我认为我将撰写 3 篇关于它们的博文（附带一句，我太懒了，这篇完成度 90% 的博文都在我的草稿箱里面躺了三个月了，自打我说了要撰文之后，[更多内容都已完成](https://hacks.mozilla.org/2015/06/es6-in-depth-symbols/)）：

第一部分：Symbols（本篇文章）[第二部分：Reflect](/metaprogramming-in-es6-part-2-reflect/) [Part 3: Proxies](/metaprogramming-in-es6-part-3-proxies/)

## 元编程

首先，让我们快速浏览一些元编程，去探索元编程的美妙世界。元编程（宽松地说）是所有关于一门语言的底层机制，而不是数据建模或者业务逻辑那些高级抽象。如果程序可以被描述为 “制作程序”，元编程就能被描述为 “让程序来制作程序”。你可能已经在日常编程中使用到了元编程，即使你并没有注意到它。

元编程有一些 “次主题（subgenres）” —— 其中之一是 **代码生成（Code Generation）**，也称之为 `eval` —— JavaScript 在一开始就拥有代码生成的能力（JavaScript 在 ES1 中就有了 `eval`，它甚至早于 `try`/`catch` 和 `switch` 的出现）。目前，其他一些流行的编程语言都具有 **代码生成** 的特性。

元编程另一个方面是反射（Reflection） —— 反射用于发现和调整你的应用程序结构和语义。JavaScript 有几个工具来完成反射。函数有 `Function#name`、`Function#length`、以及 `Function#bind`、`Function#call` 和 `Functin#apply`。所有 Object 上可用的方法也算是反射，例如 `Object.getOwnProperties`。我们也有反射/内省运算符，如 `typeof`、`instancesof` 以及 `delete`。

反射是元编程中非常酷的一部分，因为它允许你改变应用程序的内部工作机制。以 Ruby 为例，你可以声明一个运算符作为方法，来让你重写运算符在这个类上的工作机制（这一手段通常称为 “运算符重载”）：

```ruby
class BoringClass
end
class CoolClass
  def ==(other_object)
   other_object.is_a? CoolClass
  end
end
BoringClass.new == BoringClass.new #=> false
CoolClass.new == CoolClass.new #=> true!
```

对比到其他类似 Ruby 或者 Python 的语言，JavaScript 的元编程特性要落后不少 —— 尤其考虑到它缺乏诸如运算符重载这样的好工具时更是如此，但是 ES6 开始帮助 JavaScript 在元编程上赶上其他语言。

### ES6 下的元编程

ES6 带来了三个全新的 API：`Symbol`、`Reflect`、以及 `Proxy`。刚看到它们时会有些疑惑 —— 这三个 API 都是服务于元编程的吗？如果你分开看这几个 API，你不难发现它们确实很有意义：

* 
* Symbols 是 **实现了的反射**—— 你将 Symbols 应用到你已有的类和对象上去改变它们的行为。
* Reflect 是 **通过自省（introspection）的反射** —— 通常用来探索非常底层的代码信息。
* Proxy 是 **通过调解（intercession）的反射** —— 包裹对象并通过自陷（trap）来拦截对象行为。

所以，它们是怎么工作的？它们又是怎么变得有用的？这边文章将讨论 Symbols，而后续两篇文章则分别讨论反射和代理。

## Symbols —— 实现了的反射

Symbols 是新的原始类型（primitive）。就像是 `Number`、`String`、和 `Boolean` 一样。Symbols 具有一个 `Symbol` 函数用于创建 Symbol。与别的原始类型不同，Symbols 没有字面量语法（例如，String 有 `''`）—— 创建 Symbol 的唯一方式是使用类似构造函数而又非构造函数的 `Symbol` 函数：

```js
Symbol(); // symbol
console.log(Symbol()); // 输出 "Symbol()" 至控制台
assert(typeof Symbol() === 'symbol')
new Symbol(); // TypeError: Symbol is not a constructor
```

### Symbols 拥有内置的 debug 能力

Symbols 可以指定一个描述，这在 debug 时很有用，当我们能够输出更有用的信息到控制台时，我们的编程体验将得到提高：

```js
console.log(Symbol('foo')); // 输出 "Symbol(foo)" 至控制台
assert(Symbol('foo').toString() === 'Symbol(foo)');
```

### Symbols 能过用作对象的 key

这个能力是 Symbols 真正有趣之处。它们和对象紧密的交织在一起。Symbols 能指定作对象的 key （类似字符串 key），这意味着你可以分配无限多的具有唯一性的 Symbols 到一个对象上，这些 key 保证不会和现有的字符串 key 冲突，或者和其他 Symbol key 冲突：

```js
var myObj = {};
var fooSym = Symbol('foo');
var otherSym = Symbol('bar');
myObj['foo'] = 'bar';
myObj[fooSym] = 'baz';
myObj[otherSym] = 'bing';
assert(myObj.foo === 'bar');
assert(myObj[fooSym] === 'baz');
assert(myObj[otherSym] === 'bing');
```

另外，Symbols key 无法通过 `for in`、`for of` 或者 `Object.getOwnPropertyNames` 获得 —— 获得它们的唯一方式是 `Object.getOwnPropertySymbols`：

```js
var fooSym = Symbol('foo');
var myObj = {};
myObj['foo'] = 'bar';
myObj[fooSym] = 'baz';
Object.keys(myObj); // -> [ 'foo' ]
Object.getOwnPropertyNames(myObj); // -> [ 'foo' ]
Object.getOwnPropertySymbols(myObj); // -> [ Symbol(foo) ]
assert(Object.getOwnPropertySymbols(myObj)[0] === fooSym);
```

这意味着 Symbols 能够给对象提供一个隐藏层，帮助对象实现了一种全新的目的 —— 属性不可迭代，也不能够通过现有的反射工具获得，并且能被保证不会和对象任何已有属性冲突。

### Symbols 是完全唯一的......

默认情况下，每一个新创建的 Symbol 都有一个完全唯一的值。如果你新创建了一个 Symbol（`var mysym = Symbol()`），在 JavaScript 引擎内部，就会创建一个全新的值。如果你不保留 Symbol 对象的引用，你就无法使用它。这也意味着两个 Symbol 将绝不会等同于同一个值，即使它们有一样的描述：

```js
assert.notEqual(Symbol(), Symbol());
assert.notEqual(Symbol('foo'), Symbol('foo'));
assert.notEqual(Symbol('foo'), Symbol('bar'));

var foo1 = Symbol('foo');
var foo2 = Symbol('foo');
var object = {
    [foo1]: 1,
    [foo2]: 2,
};
assert(object[foo1] === 1);
assert(object[foo2] === 2);
```

### ......等等，也有例外

稍安勿躁，这有一个小小的警告 —— 这里也有一个其他的创建 Symbol 的方式来轻易地实现 Symbol 的获得和重用：`Symbol.for`。该方法在 “全局 Symbol 注册中心” 创建了一个 Symbol。额外注意的一点：这个注册中心也是跨域的，意味着 iframe 或者 service worker 中的 Symbol 会与当前 frame Symbol 相等：

```js
assert.notEqual(Symbol('foo'), Symbol('foo'));
assert.equal(Symbol.for('foo'), Symbol.for('foo'));

// 不是唯一的：
var myObj = {};
var fooSym = Symbol.for('foo');
var otherSym = Symbol.for('foo');
myObj[fooSym] = 'baz';
myObj[otherSym] = 'bing';
assert(fooSym === otherSym);
assert(myObj[fooSym] === 'bing');
assert(myObj[otherSym] === 'bing');

// 跨域
iframe = document.createElement('iframe');
iframe.src = String(window.location);
document.body.appendChild(iframe);
assert.notEqual(iframe.contentWindow.Symbol, Symbol);
assert(iframe.contentWindow.Symbol.for('foo') === Symbol.for('foo')); // true!
```

全局 Symbol 会让东西变得更加复杂，但我们又舍不得它好的方面。现在，你们当中的一些人可能会说：“我要怎样知道哪些 Symbol 是唯一的，哪些不是？”，对此，我会说 “别担心，我们还有 `Symbol.keyFor()`”：

```js
var localFooSymbol = Symbol('foo');
var globalFooSymbol = Symbol.for('foo');

assert(Symbol.keyFor(localFooSymbol) === undefined);
assert(Symbol.keyFor(globalFooSymbol) === 'foo');
assert(Symbol.for(Symbol.keyFor(globalFooSymbol)) === Symbol.for('foo'));
```

### Symbols 是什么，又不是什么？

所以，我们完成了一个还不错的对 Symbol 及它怎样工作的概述 —— 但同样重要的是，我们要知道 Symbol 适合和不适合什么场景，下面几点阐述了 Symbol 不是什么：

* **Symbols 绝不会与对象的字符串 key 冲突**。这一特性让 Symbol 在扩展已有对象时表现卓著（例如，Symbol 作为了一个函数参数），它不会显式地影响到对象：

* **Symbols 无法通过现有的反射工具读取**。你需要一个新的方法 `Object.getOwnPropertySymbols()` 来访问对象上的 Symbols，这让 Symbol 适合存储那些你不想让别人直接获得的信息。使用 `Object.getOwnPropertySymbols()` 是一个非常特殊的用例，一般人可不知道。

* **Symbols 不是私有的**。作为双刃剑的另一面 —— 对象上所有的 Symbols 都可以直接通过 `Object.getOwnPropertySymbols()` 获得 —— 这不利于我们使用 Symbol 存储一些真正需要私有化的值。不要尝试使用 Symbols 存储对象中需要真正私有化的值 —— Symbol 总能被拿到。

* **可枚举的 Symbols 能够被复制到其他对象**，复制会通过类似这样的 `Object.assign` 新方法完成。如果你尝试调用 `Object.assign(newObject, objectWithSymbols)`，并且所有的可迭代的 Symbols 作为了第二个参数（`objectWithSymbols`）传入，这些 Symbols 会被复制到第一个参数（`newObject`）上。如果你不想要这种情况发生，就用 `Obejct.defineProperty` 来让这些 Symbols 变得不可迭代。

* **Symbols 不能强制类型转换为原始对象**。如果你尝试强制转换一个 Symbol 为原始值对象（`+Symbol()`、`-Symbol()`、`Symbol() + 'foo'`），将会抛出一个错误。这防止了当你将 Symbol 设置为对象属性名时，不小心字符串化了（stringify）它们。

* **Symbols 不总是唯一的**。上文中就提到过了，`Symbol.for()` 将为你返回一个不唯一的 Symbol。不要总认为 Symbol 具有唯一性，除非你自己能够保证它的唯一性。

* **Symbols 与 Ruby 的 Symbols 不是一回事**。二者有一些共性，例如都有一个 Symbol 注册中心，但仅仅如此了。JavaScript 中 Symbol 不能当做 Ruby 中 Symbol 去使用。


## Symbols 真正适合的是什么？

现实中，Symbols 只是一个略有不同绑定对象属性的方式 —— 你能够轻易地提供一些著名的 Symbols（例如 Symbols.iterator） 作为标准方法，正如 `Object.prototype.hasOwnProperty` 这个方法就出现在了所有继承自 Object 的对象（继承自 Object，基本上也就意味着一切对象都有 `hasOwnProperty` 这个方法了）。实际上，例如 Python 这样的语言是这样提供标准方法的 —— 在 Python 中，等同于 `Symbol.iterator` 的是 `__iter__`，等同于 `Symbole.hasInstance` 的是 `__instancecheck__`，并且我猜 `__cmp__` 也类似于 `Symbole.toPrimitive`。Python 的这个做法可能是一种较差的做法，而 JavaScript 的 Symbols 不需要依赖任何古怪的语法就能提供标准方法，并且，任何情况下用户都不会和这些标准方法遭遇冲突。

在我看来，Symbols 可以被用在下面两个场景：

### 1. 作为一个可替换字符串或者整型使用的唯一值

假定你有一个日志库，该库包含了多个日志级别，例如 `logger.levels.DEBUG`、`logger.levels.INFO`、`logger.levels.WARN` 等等。在 ES5 中，你通过字符串或者整型设置或者判断级别：`logger.levels.DEBUG === 'debug'`、`logger.levels.DEBUG === 10`。这些方式都不是理想方式，因为它们不能保证级别取值唯一，但是 Symbols 的唯一性能够出色地完成这个任务！现在 `logger.levels` 变成了：

```js
log.levels = {
    DEBUG: Symbol('debug'),
    INFO: Symbol('info'),
    WARN: Symbol('warn'),
};
log(log.levels.DEBUG, 'debug message');
log(log.levels.INFO, 'info message');
```

### 2. 作为一个对象中放置元信息（metadata）的场所

你也可以用 Symbol 来存储一些对于真实对象来说较为次要的元信息属性。把这看作是不可迭代性的另一层面（毕竟，不可迭代的 keys 仍然会出现在 `Object.getOwnProperties` 中）。让我们创建一个受信的集合类，并为其添加一个 size 引用来获得集合规模这个元信息，这个引用借助于 Symbol 不会暴露给外部（只要记住，**Symbols 不是私有的** —— 并且只有当你不在乎应用的其他部分会修改到 Symbols 属性时，再使用 Symbol）：

```js
var size = Symbol('size');
class Collection {
    constructor() {
        this[size] = 0;
    }

    add(item) {
        this[this[size]] = item;
        this[size]++;
    }

    static sizeOf(instance) {
        return instance[size];
    }

}

var x = new Collection();
assert(Collection.sizeOf(x) === 0);
x.add('foo');
assert(Collection.sizeOf(x) === 1);
assert.deepEqual(Object.keys(x), ['0']);
assert.deepEqual(Object.getOwnPropertyNames(x), ['0']);
assert.deepEqual(Object.getOwnPropertySymbols(x), [size]);
```

### 3. 给予开发者在 API 中为对象添加钩子（hook）的能力

这听起来有点奇怪，但大家不妨多点耐心，听我解释。假定我们有一个 `console.log` 风格的工具函数 —— 这个函数可以接受 __任何__ 对象，并将其输出到控制台。它有自己的机制去决定如何在控制台显示对象 —— 但是你作为一个使用该 API 的开发者，能够通过提供一个方法去重写显示机制，这得益于 `inspect` Symbol 实现的一个钩子 ：

```js
// 从 API 的 Symbols 常量中获得这个充满魔力的审查 Symbol
var inspect = console.Symbols.INSPECT;

var myVeryOwnObject = {};
console.log(myVeryOwnObject); // logs out `{}`

myVeryOwnObject[inspect] = function () { return 'DUUUDE'; };
console.log(myVeryOwnObject); // logs out `DUUUDE`
```

这个审查（inspect）钩子大致实现如下：

```js
console.log = function (…items) {
    var output = '';
    for(const item of items) {
        if (typeof item[console.Symbols.INSPECT] === 'function') {
            output += item[console.Symbols.INSPECT](item);
        } else {
            output += console.inspect[typeof item](item);
        }
        output += '  ';
    }
    process.stdout.write(output + '\n');
}
```

需要说明的是，这不意味着你应该写一些会改变给定对象的代码。这是决不允许的事（对于此，可以看下 [WeakMaps](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)，它为你提供了辅助对象来收集你自己在对象上定义的元信息）。

> 译注：如果你对 WeakMap 存有疑惑，可以参看 [stackoverflow —— What are the actual uses of ES6 WeakMap?](https://stackoverflow.com/questions/29413222/what-are-the-actual-uses-of-es6-weakmap)。

[Node.js 已经在其 `console.log` 中已经有了类似的实现](https://nodejs.org/api/util.html#util_custom_inspect_function_on_objects)。其使用了一个字符串（`'inspect'`）而不是 Symbol，这意味着你可以设置 `x.inspect = function(){}` —— 这不是聪明的做法，因为某些时候，这可能会和你的类方法冲突。而使用 Symbol __是一个非常有前瞻性的方式来防止这样的情况发生__。

这样使用 Symbols 的方式是意义深远的，这已经成为了这门语言的一部分，借此，我们开始深入到一些有名的 Symbol 中去。

## 有名的 Symbols

A key part of what makes Symbols useful, is a set of Symbol constants, known as “well known symbols”. These are effectively a bunch of static properties on the `Symbol` class which are implemented within other native objects, such as Arrays, Strings, and within the internals of the JavaScript engine. This is where the real “Reflection within Implementation” part happens, as these well known Symbols alter the behaviour of (what used to be) JavaScript internals. Below I’ve detailed what each one does and why they’re just so darn awesome!

## Symbol.hasInstance: instanceof

`Symbol.hasInstance` is a Symbol which drives the behaviour of `instanceof`. When an ES6 compliant engine sees the `instanceof` operator in an expression it calls upon `Symbol.hasInstance`. For example, `lho instanceof rho` would call `rho[Symbol.hasInstance](lho)` (where `rho` is the right hand operand and `lho` is the left hand operand). It’s then up to the method to determine if it inherits from that particular instance, you could implement this like so:

```
class MyClass {
    static [Symbol.hasInstance](lho) {
        return Array.isArray(lho);
    }
}
assert([] instanceof MyClass);
```

### Symbol.iterator

If you’ve heard anything about Symbols, you’ve probably heard about `Symbol.iterator`. With ES6 comes a new pattern - the `for of` loop, which calls `Symbol.iterator` on right hand operand to get values to iterate over. In other words these two are equivalent:

```
var myArray = [1,2,3];

// with `for of`
for(var value of myArray) {
    console.log(value);
}

// without `for of`
var _myArray = myArray[Symbol.iterator]();
while(var _iteration = _myArray.next()) {
    if (_iteration.done) {
        break;
    }
    var value = _iteration.value;
    console.log(value);
}
```

`Symbol.iterator` will allow you to override the `of` operator - meaning if you make a library that uses it, developers will love you:

```
class Collection {
  *[Symbol.iterator]() {
    var i = 0;
    while(this[i] !== undefined) {
      yield this[i];
      ++i;
    }
  }

}
var myCollection = new Collection();
myCollection[0] = 1;
myCollection[1] = 2;
for(var value of myCollection) {
    console.log(value); // 1, then 2
}
```

### Symbol.isConcatSpreadable

`Symbol.isConcatSpreadable` is a pretty specific Symbol - driving the behaviour of `Array#concat`. You see, `Array#concat` can take multiple arguments, which - if arrays - will themselves be flattened (or spread) as part of the concat operation. Consider the following code:

```
x = [1, 2].concat([3, 4], [5, 6], 7, 8);
assert.deepEqual(x, [1, 2, 3, 4, 5, 6, 7, 8]);
```

As of ES6 the way `Array#concat` will determine if any of its arguments are spreadable will be with `Symbol.isConcatSpreadable`. This is more used to say that the class you have made that extends Array won’t be particularly good for `Array#concat`, rather than the other way around:

```
class ArrayIsh extends Array {
    get [Symbol.isConcatSpreadable]() {
        return true;
    }
}
class Collection extends Array {
    get [Symbol.isConcatSpreadable]() {
        return false;
    }
}
arrayIshInstance = new ArrayIsh();
arrayIshInstance[0] = 3;
arrayIshInstance[1] = 4;
collectionInstance = new Collection();
collectionInstance[0] = 5;
collectionInstance[1] = 6;
spreadableTest = [1,2].concat(arrayInstance).concat(collectionInstance);
assert.deepEqual(spreadableTest, [1, 2, 3, 4, <Collection>]);
```

### Symbol.unscopables

This Symbol has a bit of interesting history. Essentially, while developing ES6, the TC found some old code in a popular JS libraries that did this kind of thing:

```
var keys = [];
with(Array.prototype) {
    keys.push('foo');
}
```

This works well in old ES5 code and below, but ES6 now has `Array#keys` - meaning when you do `with(Array.prototype)`, `keys` is now the method `Array#keys` - not the variable you set. So there were three solutions:

1. Try to get all websites using this code to change it/update the libraries (impossible).
2. Remove `Array#keys` and hope another bug like this doesn’t crop up (not really solving the problem)
3. Write a hack around all of this which prevents some properties being scoped into `with` statements.

Well, the TC went with option 3, and so `Symbol.unscopables` was born, which defines a set of “unscopable” values in an Object which should not be set when used inside the `with` statement. You’ll probably never need to use this - nor will you encounter it in day to day JavaScripting, but it demonstrates some of the utility of Symbols, and also is here for completeness:

```
Object.keys(Array.prototype[Symbol.unscopables]); // -> ['copyWithin', 'entries', 'fill', 'find', 'findIndex', 'keys']

// Without unscopables:
class MyClass {
    foo() { return 1; }
}
var foo = function () { return 2; };
with (MyClass.prototype) {
    foo(); // 1!!
}

// Using unscopables:
class MyClass {
    foo() { return 1; }
    get [Symbol.unscopables]() {
        return { foo: true };
    }
}
var foo = function () { return 2; };
with (MyClass.prototype) {
    foo(); // 2!!
}
```

### Symbol.match

This is another Symbol specific to a function. `String#match` function will now use this to determine if the given value can be used to match against it. So, you can provide your own matching implementation to use, rather than using Regular Expressions:

```
class MyMatcher {
    constructor(value) {
        this.value = value;
    }
    [Symbol.match](string) {
        var index = string.indexOf(this.value);
        if (index === -1) {
            return null;
        }
        return [this.value];
    }
}
var fooMatcher = 'foobar'.match(new MyMatcher('foo'));
var barMatcher = 'foobar'.match(new MyMatcher('bar'));
assert.deepEqual(fooMatcher, ['foo']);
assert.deepEqual(barMatcher, ['bar']);
```

### Symbol.replace

Just like `Symbol.match`, `Symbol.replace` has been added to allow custom classes, where you’d normally use Regular Expressions, for `String#replace`:

```
class MyReplacer {
    constructor(value) {
        this.value = value;
    }
    [Symbol.replace](string, replacer) {
        var index = string.indexOf(this.value);
        if (index === -1) {
            return string;
        }
        if (typeof replacer === 'function') {
            replacer = replacer.call(undefined, this.value, string);
        }
        return `${string.slice(0, index)}${replacer}${string.slice(index + this.value.length)}`;
    }
}
var fooReplaced = 'foobar'.replace(new MyReplacer('foo'), 'baz');
var barMatcher = 'foobar'.replace(new MyReplacer('bar'), function () { return 'baz' });
assert.equal(fooReplaced, 'bazbar');
assert.equal(barReplaced, 'foobaz');
```

### Symbol.search

Yup, just like `Symbol.match` and `Symbol.replace`, `Symbol.search` exists to prop up `String#search` - allowing for custom classes instead of Regular Expressions:

```
class MySearch {
    constructor(value) {
        this.value = value;
    }
    [Symbol.search](string) {
        return string.indexOf(this.value);
    }
}
var fooSearch = 'foobar'.search(new MySearch('foo'));
var barSearch = 'foobar'.search(new MySearch('bar'));
var bazSearch = 'foobar'.search(new MySearch('baz'));
assert.equal(fooSearch, 0);
assert.equal(barSearch, 3);
assert.equal(bazSearch, -1);
```

### Symbol.split

Ok, last of the String symbols - `Symbol.split` is for `String#split`. Use like so:

```
class MySplitter {
    constructor(value) {
        this.value = value;
    }
    [Symbol.split](string) {
        var index = string.indexOf(this.value);
        if (index === -1) {
            return string;
        }
        return [string.substr(0, index), string.substr(index + this.value.length)];
    }
}
var fooSplitter = 'foobar'.split(new MySplitter('foo'));
var barSplitter = 'foobar'.split(new MySplitter('bar'));
assert.deepEqual(fooSplitter, ['', 'bar']);
assert.deepEqual(barSplitter, ['foo', '']);
```

### Symbol.species

Symbol.species is a pretty clever Symbol, it points to the constructor value of a class, which allows classes to create new versions of themselves within methods. Take for example `Array#map`, which creates a new Array resulting from each return value of the callback - in ES5 `Array#map`’s code might look something like this:

```
Array.prototype.map = function (callback) {
    var returnValue = new Array(this.length);
    this.forEach(function (item, index, array) {
        returnValue[index] = callback(item, index, array);
    });
    return returnValue;
}
```

In ES6 `Array#map`, along with all of the other non-mutating Array methods have been upgraded to create Objects using the `Symbol.species` property, and so the ES6 `Array#map` code now looks more like this:

```
Array.prototype.map = function (callback) {
    var Species = this.constructor[Symbol.species];
    var returnValue = new Species(this.length);
    this.forEach(function (item, index, array) {
        returnValue[index] = callback(item, index, array);
    });
    return returnValue;
}
```

Now, if you were to make a `class Foo extends Array` - every time you called `Foo#map` while before it would return an Array (no fun) and you’d have to write your own Map implementation just to create `Foo`s instead of `Array`s, now `Foo#map` return a `Foo`, thanks to `Symbol.species`:

```
class Foo extends Array {
    static get [Symbol.species]() {
        return this;
    }
}

class Bar extends Array {
    static get [Symbol.species]() {
        return Array;
    }
}

assert(new Foo().map(function(){}) instanceof Foo);
assert(new Bar().map(function(){}) instanceof Bar);
assert(new Bar().map(function(){}) instanceof Array);
```

You may be asking “why not just use `this.constructor` instead of `this.constructor[Symbol.species]`?”. Well, `Symbol.species` provides a _customisable_ entry-point for what type to create - you might not always want to subclass and have methods create your subclass - take for example the following:

```
class TimeoutPromise extends Promise {
    static get [Symbol.species]() {
        return Promise;
    }
}
```

This timeout promise could be created to perform an operation that times out - but of course you don’t want one Promise that times out to subsequently effect the whole Promise chain, and so `Symbol.species` can be used to tell `TimeoutPromise` to return `Promise` from it’s prototype methods. Pretty handy.

### Symbol.toPrimitive

This Symbol is the closest thing we have to overloading the Abstract Equality Operator (`==` for short). Basically, `Symbol.toPrimitive` is used when the JavaScript engine needs to convert your Object into a primitive value - for example if you do `+object` then JS will call `object[Symbol.toPrimitive]('number');`, if you do `''+object'` then JS will call `object[Symbol.toPrimitive]('string')`, and if you do something like `if(object)` then it will call `object[Symbol.toPrimitive]('default')`. Before this, we had `valueOf` and `toString` to juggle with - both of which were kind of gnarly and you could never get the behaviour you wanted from them. `Symbol.toPrimitive` gets implemented like so:

```
class AnswerToLifeAndUniverseAndEverything {
    [Symbol.toPrimitive](hint) {
        if (hint === 'string') {
            return 'Like, 42, man';
        } else if (hint === 'number') {
            return 42;
        } else {
            // when pushed, most classes (except Date)
            // default to returning a number primitive
            return 42;
        }
    }
}

var answer = new AnswerToLifeAndUniverseAndEverything();
+answer === 42;
Number(answer) === 42;
''+answer === 'Like, 42, man';
String(answer) === 'Like, 42, man';
```

### Symbol.toStringTag

Ok, this is the last of the well known Symbols. Come on, you’ve got this far, you can do this! `Symbol.toStringTag` is actually a pretty cool one - if you’ve ever tried to implement your own replacement for the `typeof` operator, you’ve probably come across  `Object#toString()` - and how it returns this weird `'[object Object]'` or `'[object Array]'` String. Before ES6, this behaviour was defined in the crevices of the spec, however today, in fancy ES6 land we have a Symbol for it! Any Object passed to `Object#toString()` will be checked to see if it has a property of `[Symbol.toStringTag]` which should be a String, and if it is there then it will be used in the generated String - for example:

```
class Collection {

  get [Symbol.toStringTag]() {
    return 'Collection';
  }

}
var x = new Collection();
Object.prototype.toString.call(x) === '[object Collection]'
```

As an aside for this - if you use [Chai](http://chaijs.com) for testing, it now uses Symbols under the hood for type detection, so you can write `expect(x).to.be.a('Collection')` in your tests (provided `x` has the Symbol.toStringTag property like above, oh and that you’re running the code in a browser with `Symbol.toStringTag`).

## The missing well-known Symbol: Symbol.isAbstractEqual

You’ve probably figured it out by now - but I really like the idea of Symbols for Reflection. To me, there is one piece missing that would make them something I’d be really excited about: `Symbol.isAbstractEqual`. Having a `Symbol.isAbstractEqual` well known Symbol could bring the abstract equality operator (`==`) back into popular usage. Being able to use it in your own way, for your own classes just like you can in Ruby, Python, and co. When you see code like `lho == rho` it could be converted into `rho[Symbol.isAbstractEqual](lho)`, allowing classes to override what `==` means to them. This could be done in a backwards compatible way - by defining defaults for all current primitive prototypes (e.g. `Number.prototype`) and would tidy up a chunk of the spec, while giving developers a reason to bring `==` back from the bench.

## Conclusion

What do you think about Symbols? Still confused? Just want to rant to someone? I’m [@keithamus over on the Twitterverse](https://twitter.com/keithamus) - so feel free to hit me up there, who knows, one day I might be taking up your whole lunchtimes telling you about sweet new ES6 features I like way too much.

Now you’re done reading all about Symbols, you should totally read [Part 2 - Reflect](/metaprogramming-in-es6-part-2-reflect/).

Also lastly I’d like to thank the excellent developers [@focusaurus](https://twitter.com/focusaurus), [@mttshw](https://twitter.com/mttshw), [@colby_russell](https://twitter.com/colby_russell), [@mdmazzola](https://twitter.com/mdmazzola), and [@WebReflection](https://twitter.com/WebReflection) for proof reading this, and making much needed improvements.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
