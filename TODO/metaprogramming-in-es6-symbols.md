> * 原文地址：[Metaprogramming in ES6: Symbols and why they're awesome](https://www.keithcirkel.co.uk/metaprogramming-in-es6-symbols/)
> * 原文作者：[Keith Cirkel](https://twitter.com/keithamus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/TODO/metaprogramming-in-es6-symbols.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[Usey95](https://github.com/Usey95) [IridescentMia](https://github.com/IridescentMia)

# 元编程：Symbol，了不起的 Symbol

你已经听说过 ES6 了，是吧？这是一个在多方面表现卓著的 JavaScript 的新版本。每当在 ES6 中发现令人惊叹的新特性，我就会开始对我的同事滔滔不绝起来（但是因此占用了别人的午休时间并不是所有人乐意的）。

一系列优秀的 ES6 的新特性都来自于新的元编程工具，这些工具将底层钩子（hooks）注入到了代码机制中。目前，介绍 ES6 元编程的文章寥寥，所以我认为我将撰写 3 篇关于它们的博文（附带一句，我太懒了，这篇完成度 90% 的博文都在我的草稿箱里面躺了三个月了，自打我说了要撰文之后，[更多内容都已在这里完成](https://hacks.mozilla.org/2015/06/es6-in-depth-symbols/)）：

第一部分：Symbols（本篇文章）、[第二部分：Reflect](/metaprogramming-in-es6-part-2-reflect/) 、[第三部分： Proxies](/metaprogramming-in-es6-part-3-proxies/)

## 元编程

首先，让我们快速认识一下元编程，去探索元编程的美妙世界。元编程（笼统地说）是所有关于一门语言的底层机制，而不是数据建模或者业务逻辑那些高级抽象。如果程序可以被描述为 “制作程序”，元编程就能被描述为 “让程序来制作程序”。你可能已经在日常编程中不知不觉地使用到了元编程。

元编程有一些 “子分支（subgenres）” —— 其中之一是 **代码生成（Code Generation）**，也称之为 `eval` —— JavaScript 在一开始就拥有代码生成的能力（JavaScript 在 ES1 中就有了 `eval`，它甚至早于 `try`/`catch` 和 `switch` 的出现）。目前，其他一些流行的编程语言都具有 **代码生成** 的特性。

元编程另一个方面是反射（Reflection） —— 其用于发现和调整你的应用程序结构和语义。JavaScript 有几个工具来完成反射。函数有 `Function#name`、`Function#length`、以及 `Function#bind`、`Function#call` 和 `Functin#apply`。所有 Object 上可用的方法也算是反射，例如 `Object.getOwnProperties`。JavaScript 也有反射/内省运算符，如 `typeof`、`instancesof` 以及 `delete`。

反射是元编程中非常酷的一部分，因为它允许你改变应用程序的内部工作机制。以 Ruby 为例，你可以声明一个运算符作为方法，从而重写该运算符针对这个类的工作机制（这一手段通常称为 “运算符重载”）：

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

* Symbols 是 **实现了的反射（Reflection within implementation）**—— 你将 Symbols 应用到你已有的类和对象上去改变它们的行为。
* Reflect 是 **通过自省（introspection）实现反射（Reflection through introspection）** —— 通常用来探索非常底层的代码信息。
* Proxy 是 **通过调解（intercession）实现反射（Reflection through intercession）** —— 包裹对象并通过自陷（trap）来拦截对象行为。

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

Symbols 可以指定一个描述，这在 debug 时很有用，当我们能够输出更有用的信息到控制台时，我们的编程体验将更为友好：

```js
console.log(Symbol('foo')); // 输出 "Symbol(foo)" 至控制台
assert(Symbol('foo').toString() === 'Symbol(foo)');
```

### Symbols 能被用作对象的 key

这是 Symbols 真正有趣之处。它们和对象紧密的交织在一起。Symbols 能用作对象的 key （类似字符串 key），这意味着你可以分配无限多的具有唯一性的 Symbols 到一个对象上，这些 key 保证不会和现有的字符串 key 冲突，或者和其他 Symbol key 冲突：

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

稍安勿躁，这有一个小小的警告 —— JavaScript 也有另一个创建 Symbol 的方式来轻易地实现 Symbol 的获得和重用：`Symbol.for()`。该方法在 “全局 Symbol 注册中心” 创建了一个 Symbol。额外注意的一点：这个注册中心也是跨域的，意味着 iframe 或者 service worker 中的 Symbol 会与当前 frame Symbol 相等：

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

上面我们对于 Symbol 是什么以及它们如何工作有一个概览，但更重要的是，我们得知道 Symbol 适合和不适合什么场景，如果认识寥寥，很可能会对 Symbol 产生误区：

* **Symbols 绝不会与对象的字符串 key 冲突**。这一特性让 Symbol 在扩展已有对象时表现卓著（例如，Symbol 作为了一个函数参数），它不会显式地影响到对象：

* **Symbols 无法通过现有的反射工具读取**。你需要一个新的方法 `Object.getOwnPropertySymbols()` 来访问对象上的 Symbols，这让 Symbol 适合存储那些你不想让别人直接获得的信息。使用 `Object.getOwnPropertySymbols()` 是一个非常特殊的用例，一般人可不知道。

* **Symbols 不是私有的**。作为双刃剑的另一面 —— 对象上所有的 Symbols 都可以直接通过 `Object.getOwnPropertySymbols()` 获得 —— 这不利于我们使用 Symbol 存储一些真正需要私有化的值。不要尝试使用 Symbols 存储对象中需要真正私有化的值 —— Symbol 总能被拿到。

* **可枚举的 Symbols 能够被复制到其他对象**，复制会通过类似这样的 `Object.assign` 新方法完成。如果你尝试调用 `Object.assign(newObject, objectWithSymbols)`，并且所有的可迭代的 Symbols 作为了第二个参数（`objectWithSymbols`）传入，这些 Symbols 会被复制到第一个参数（`newObject`）上。如果你不想要这种情况发生，就用 `Obejct.defineProperty` 来让这些 Symbols 变得不可迭代。

* **Symbols 不能强制类型转换为原始对象**。如果你尝试强制转换一个 Symbol 为原始值对象（`+Symbol()`、`-Symbol()`、`Symbol() + 'foo'`），将会抛出一个错误。这防止你将 Symbol 设置为对象属性名时，不小心字符串化了（stringify）它们。

* **Symbols 不总是唯一的**。上文中就提到过了，`Symbol.for()` 将为你返回一个不唯一的 Symbol。不要总认为 Symbol 具有唯一性，除非你自己能够保证它的唯一性。

* **Symbols 与 Ruby 的 Symbols 不是一回事**。二者有一些共性，例如都有一个 Symbol 注册中心，但仅仅如此。JavaScript 中 Symbol 不能当做 Ruby 中 Symbol 去使用。


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

你也可以用 Symbol 来存储一些对于真实对象来说较为次要的元信息属性。把这看作是不可迭代性的另一层面（毕竟，不可迭代的 keys 仍然会出现在 `Object.getOwnProperties` 中）。让我们创建一个可靠的集合类，并为其添加一个 size 引用来获得集合规模这一元信息，该信息借助于 Symbol 不会暴露给外部（只要记住，**Symbols 不是私有的** —— 并且只有当你不在乎应用的其他部分会修改到 Symbols 属性时，再使用 Symbol）：

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

这听起来有点奇怪，但大家不妨多点耐心，听我解释。假定我们有一个 `console.log` 风格的工具函数 —— 这个函数可以接受 __任何__ 对象，并将其输出到控制台。它有自己的机制去决定如何在控制台显示对象 —— 但是你作为一个使用该 API 的开发者，得益于 `inspect` Symbol 实现的一个钩子，你能够提供一个方法去重写显示机制 ：

```js
// 从 API 的 Symbols 常量中获得这个充满魔力的 Inspect Symbol
var inspect = console.Symbols.INSPECT;

var myVeryOwnObject = {};
console.log(myVeryOwnObject); // 日志 `{}`

myVeryOwnObject[inspect] = function () { return 'DUUUDE'; };
console.log(myVeryOwnObject); // 日志输出 `DUUUDE`
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

## 内置的 Symbols

一个使 Symbols 有用的关键部分就是一系列的 Symbol 常量，这些常量被称为 “内置的 Symbols”。这些常量实际上是一堆在 Symbol 类上的由其他诸如数组（Array），字符串（String）等原生对象以及 JavaScript 引擎内部实现的静态方法。这就是真正 “实现了的反射（Reflection within Implementation）” 一部分发生的地方，因为这些内置的 Symbol 改变了 JavaScript 内部行为。接下来，我将详述每个 Symbol 做了什么以及为何这些 Symbols 是如此的棒。

## Symbol.hasInstance: instanceof

`Symbol.hasInstance` 是一个实现了 `instanceof` 行为的 Symbol。当一个兼容 ES6 的引擎在某个表达式中看到了 `instanceof` 运算符，它会调用 `Symbol.hasInstance`。例如，表达式 `lho instanceof rho` 将会调用 `rho[Symbol.hasInstance](lho)` （`rho` 是运算符的右操作数，而 `lho` 则是左运算数）。然后，该方法能够决定是否某个对象继承自某个特殊实例，你可以像下面这样实现这个方法：

```js
class MyClass {
    static [Symbol.hasInstance](lho) {
        return Array.isArray(lho);
    }
}
assert([] instanceof MyClass);
```

### Symbol.iterator

如果你或多或少听说过了 Symbols，你很可能听说的是 `Symbol.iterator`。ES6 带来了一个新的模式 —— `for of` 循环，该循环是调用 `Symbol.iterator` 作为右手操作数来取得当前值进行迭代的。换言之，下面两端代码是等效的：

```js
var myArray = [1,2,3];

// 使用 `for of` 的实现
for(var value of myArray) {
    console.log(value);
}

// 没有 `for of` 的实现
var _myArray = myArray[Symbol.iterator]();
while(var _iteration = _myArray.next()) {
    if (_iteration.done) {
        break;
    }
    var value = _iteration.value;
    console.log(value);
}
```

`Symbol.ierator` 将允许你重写 `of` 运算符 —— 这意味着如果你使用它来创建一个库，那么开发者爱死你了：

```js
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

`Symbol.isConcatSpreadable` 是一个非常特别的 Symbol —— 驱动了 `Array#concat` 的行为。正如你所见到的，`Array#concat` 能够接收多个参数，如果你传入的参数是多个数组，那么这些数组会被展平，又在之后被合并。考虑到下面的代码：

```js
x = [1, 2].concat([3, 4], [5, 6], 7, 8);
assert.deepEqual(x, [1, 2, 3, 4, 5, 6, 7, 8]);
```

在 ES6 下，`Array#concat` 将利用 `Symbol.isConcatSepreadable` 来决定它的参数是否可展开。关于此，应该说是你的继承自 Array 的类不是特别适用于 `Array#concat`，而非其他理由：

```js
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

这个 Symbol 有一些有趣的历史。实际上，当开发 ES6 的时候，TC（Technical Committees：技术委员会）发现在一些流行的 JavaScript 库中，有这样一些老代码：

```js
var keys = [];
with(Array.prototype) {
    keys.push('foo');
}
```

这个代码在 ES5 或者更早版本的 JavaSacript 中工作良好，但是 ES6 现在有了一个 `Array#keys` —— 这意味着当你执行 `with(Array.prototype)` 时，`keys` 指代的是 Array 原型上的 `keys` 方法，即 `Array#keys` ，而不是 with 外部你定义的 `keys`。有三个办法解决这个问题：

1. 检索所有使用了该代码的网站，升级对应的代码库。（这基本是不可能的）
2. 删除 `Array#keys` ，并祈祷类似 bug 不会出现。（这也没有真正解决这个问题）
3. 写一个 hack 包裹所有这样的代码，防止 `keys` 出现在 `with` 语句的作用域中。

技术委员会选择的是第三种方式，因此 `Symbol.unscopables` 应运而生，它为对象定义了一系列 “unscopable（不被作用域的）” 的值，当这些值用在了 `with` 语句中，它们不会被设置为对象上的值。你几乎用不到这个 Symbol —— 在日常的 JavaScript 编程中，你也遇不到这样的情况，但是这仍然体现了 Symbols 的用法，并且保障了 Symbol 的完整性：

```js
Object.keys(Array.prototype[Symbol.unscopables]); // -> ['copyWithin', 'entries', 'fill', 'find', 'findIndex', 'keys']

// 不使用 unscopables:
class MyClass {
    foo() { return 1; }
}
var foo = function () { return 2; };
with (MyClass.prototype) {
    foo(); // 1!!
}

// 使用 unscopables:
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

这是另一个针对于函数的 Symbol。`String#match` 函数将能够自定义 macth 规则流判断给定的值是否匹配。现在，你能够实现自己的匹配策略，而不是使用正则表达式：

```js
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

与 `Symbol.match` 类似，`Symbol.replace` 也允许传递自定义的类来完成字符串的替换，而不仅是使用正则表达式：

```js
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

与 `Symbol.match` 和 `Symbol.replace` 类似，`Symbol.search` 增强了 `String#search` —— 允许传入自定义的类替代正则表达式：

```js
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

现在到了最后一个字符串相关的 Symbol 了 —— `Symbol.split` 对应于 `String#split`。用法如下：

```js
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

`Symbol.species` 是一个非常机智的 Symbol，它指向了一个类的构造函数，这允许类能够创建属于自己的、某个方法的新版本。以 `Array#map` 为例，其能创建一个新的数组，新数组中的值来源于传入的回调函数每次的返回值 —— ES5 的 `Array#map` 实现可能是下面这个样子：

```js
Array.prototype.map = function (callback) {
    var returnValue = new Array(this.length);
    this.forEach(function (item, index, array) {
        returnValue[index] = callback(item, index, array);
    });
    return returnValue;
}
```

ES6 中的 `Array#map`，以及其他所有的不可变 Array 方法（如 `Array#filter` 等），都已经更新到了使用 `Symbol.species` 属性来创建对象，因此，ES6 中的 `Array#map` 实现可能如下：

```js
Array.prototype.map = function (callback) {
    var Species = this.constructor[Symbol.species];
    var returnValue = new Species(this.length);
    this.forEach(function (item, index, array) {
        returnValue[index] = callback(item, index, array);
    });
    return returnValue;
}
```

现在，如果你写了 `class Foo extends Array` —— 每当你调用 `Foo#map`，在其返回一个 `Array` 类型（这并不是我们想要的）的数组之前，你本该撰写一个自己的 Map 实现来创建 `Foo` 的类型数组而不是 `Array` 类的数组，但现在，有了 `Sympbol.species`，`Foo#map` 能够直接返回了一个 `Foo` 类型的数组：

```js
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

可能你会问，为什么使用 `this.constructor` 来替代 `this.constructor[Symbol.species]` ？`Symbol.species` 为需要创建的类型提供了 __可定制的__ 入口 —— 可能你不总是想用子类以及创建子类的方法，以下面这段代码为例：

```js
class TimeoutPromise extends Promise {
    static get [Symbol.species]() {
        return Promise;
    }
}
```

这个 timeout promise 可以创建一个延时的操作 —— 当然，你不希望某个 Promise 会对整个 Prmoise 链上的后续的 Promise 造成延时，所以 `Symbol.species` 能够用来告诉 `TimeoutPromise` 从其原型链方法返回一个 `Promise`（译注：如果返回的是 `TimeoutPromise`，那么由 `Promise#then` 串联的 Promise 链上每个 Promise 都是 TimeoutPromise）。这实在是太方便了。

### Symbol.toPrimitive

这个 Symbol 为我们提供了重载抽象相等性运算符（Abstract Equality Operator，简写是 `==`）。基本上，当 JavaScript 引擎需要将你对象转换为原始值时，`Symbol.toPrimitive` 会被用到 —— 例如，如果你执行 `+object` ，那么 JavaScript 会调用 `object[Symbol.toPrimitive]('number');`，如果你执行 `''+object` ，那么 JavaScript 会调用 `object[Symbol.toPrimive]('string')`，而如果你执行 `if(object)`，JavaScript 则会调用 `object[Symbol.toPrimitive]('default')`。在此之前，我们有 `valueOf` 和 `toString` 来处理这些情况，但是二者多少有些粗糙并且你可能从不会从它们中获得期望的行为。`Symbol.toPrimitive` 的实现如下：

```js
class AnswerToLifeAndUniverseAndEverything {
    [Symbol.toPrimitive](hint) {
        if (hint === 'string') {
            return 'Like, 42, man';
        } else if (hint === 'number') {
            return 42;
        } else {
            // 大多数类（除了 Date）都默认返回一个数值原始值
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

这是最后一个内置的 Symbol。 `Symbol.toStringTag` 确实是一个非常酷的 Symbol —— 如果你尚未尝试实现一个你自己的用于替代 `typeof` 运算符的类型判断，你可能会用到 `Object#toString()` —— 它返回的是奇怪的 `'[object Object]'` 或者 `'[object Array]'` 这样奇怪的字符串。在 ES6 之前，该方法的行为隐藏在了你看不到实现细节中，但在今天，在 ES6 的乐园中，我们有了一个 Symbol 来左右它的行为！任何传递到 `Object#toString()` 的对象将会被检查是否有一个 `[Symbol.toStringTag]` 属性，这个属性是一个字符串 ，如果有，那么将使用该字符串作为 `Object#toString()` 的结果，例子如下：

```js
class Collection {

  get [Symbol.toStringTag]() {
    return 'Collection';
  }

}
var x = new Collection();
Object.prototype.toString.call(x) === '[object Collection]'
```

关于此的另一件事儿是 —— 如果你使用了 [Chai](http://chaijs.com) 来做测试，它现在已经在底层使用了 Symbol 来做类型检测，所以，你能够在你的测试中写 `expect(x).to.be.a('Collection')` （`x` 有一个类似上面 `Symbol.toStringTag` 的属性，这段代码需要运行在支持该 Symbol 的浏览器上）。

## 缺失的 Symbol：Symbol.isAbstractEqual

你可能已经知晓了 ES6 中的 Symbol 的意义和用法，但我真的很喜欢 Symbol 中有关反射的想法，因此还想再多说两句。对于我来说，这还缺失了一个我会为之兴奋的 Symbol：`Symbol.isAbstractEqual`。这个 Symbol 能够让抽象相等性运算符（`==`）重现荣光。像 Ruby、Python 等语言那样，我们能够用我们自己的方式，针对我们自己的类，使用它。当你看见诸如 `lho == rho` 这样的代码时，JavaScript 能够转换为 `rho[Symbol.isAbstractEqual](lho)`，允许类重载运算符 `==` 的意义。这可以以一种向后兼容的方式实现 —— 通过为所有现在的原始值原型（例如 `Number.prototype`）定义默认值，该 Symbol 将使得很多规范更加清晰，并给开发者一个重新拾回 `==` 使用的理由。

## 结论

你是怎样看待 Symbols 的？仍然疑惑不解吗？想对某人大声发泄吗？ 我是 [Titterverse 上的 @keithamus ](https://twitter.com/keithamus) —— 你可以在上面随便叨扰我，说不准某天我就会花上整个午餐时间来告诉你我最喜欢的那些 ES6 新特性。

现在，你已经阅读完了所有关于 Symbols 的东西，接下来你就该阅读 [第二部分 —— Reflect](/metaprogramming-in-es6-part-2-reflect/) 了。

最后我也要感谢那些优秀的开发者  [@focusaurus](https://twitter.com/focusaurus)、 [@mttshw](https://twitter.com/mttshw), [@colby_russell](https://twitter.com/colby_russell)、 [@mdmazzola](https://twitter.com/mdmazzola)，以及 [@WebReflection](https://twitter.com/WebReflection) 对于该文的校对和提升。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
