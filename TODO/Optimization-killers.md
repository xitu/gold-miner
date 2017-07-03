> * 原文地址：[Optimization killers](https://github.com/petkaantonov/bluebird/wiki/Optimization-killers)
> * 原文作者：[github.com/petkaantonov/bluebird](https://github.com/petkaantonov/bluebird)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Aladdin-ADD](https://github.com/Aladdin-ADD),[zhaochuanxing](https://github.com/zhaochuanxing)

# V8 性能优化杀手

## 简介

这篇文章给出了一些建议，让你避免写出性能远低于期望的代码。特别指出有一些代码会导致 V8 引擎（涉及到 Node.JS、Opera、Chromium 等）无法对相关函数进行优化。

vhf 正在做一个类似的项目，试图将 V8 引擎的性能杀手全部列出来：[V8 Bailout Reasons](https://github.com/vhf/v8-bailout-reasons)。

### V8 引擎背景知识

V8 引擎中没有解释器，但有 2 种不同的编译器：普通编译器与优化编译器。编译器会将你的 JavaScript 代码编译成汇编语言后直接运行。但这并不意味着运行速度会很快。被编译成汇编语言后的代码并不能显著地提高其性能，它只能省去解释器的性能开销，如果你的代码没有被优化的话速度依然会很慢。

例如，在普通编译器中 `a + b` 将会被编译成下面这样：

```nasm
mov eax, a
mov ebx, b
call RuntimeAdd
```

换句话说，其实它仅仅调用了 runtime 函数。但如果 `a` 和 `b` 能确定都是整型变量，那么编译结果会是下面这样：

```nasm
mov eax, a
mov ebx, b
add eax, ebx
```

它的执行速度会比前面那种去在 runtime 中调用复杂的 JavaScript 加法算法快得多。

通常来说，使用普通编译器将会得到前面那种代码，使用优化编译器将会得到后面那种代码。走优化编译器的代码可以说比走普通编译器的代码性能好上 100 倍。但是请注意，并不是任何类型的 JavaScript 代码都能被优化。在 JS 中，有很多种情况（甚至包括一些我们常用的语法）是不能被优化编译器优化的（这种情况被称为“bailout”，从优化编译器降级到普通编译器）。

记住一些会导致整个函数无法被优化的情况是很重要的。JS 代码被优化时，将会逐个优化函数，在优化各个函数的时候不会关心其它的代码做了什么（除非那些代码被内联在即将优化的函数中。）。

这篇文章涵盖了大多数会导致函数坠入“无法被优化的深渊”的情况。不过在未来，优化编译器进行更新后能够识别越来越多的情况时，下面给出的建议与各种变通方法可能也会变的不再必要或者需要修改。

## 主题

1. [工具](#1-工具)
2. [不支持的语法](#2-不支持的语法)
3. [使用 `arguments`](#3-使用-arguments)
4. [Switch-case](#4-switch-case)
5. [For-in](#5-for-in)
6. [退出条件藏的很深，或者没有定义明确出口的无限循环](#6-退出条件藏的很深-或者没有定义明确出口的无限循环)

## 1. 工具

你可以在 node.js 中使用一些 V8 自带的标记来验证不同的代码用法对优化的影响。通常来说你可以创建一个包括特定模式的函数，然后使用所有允许的参数类型去调用它，再使用 V8 的内部去优化与检查它：

test.js:

```js
//创建包含需要检查的情况的函数（检查使用 `eval` 语句是否能被优化）
function exampleFunction() {
    return 3;
    eval('');
}

function printStatus(fn) {
    switch(%GetOptimizationStatus(fn)) {
        case 1: console.log("Function is optimized"); break;
        case 2: console.log("Function is not optimized"); break;
        case 3: console.log("Function is always optimized"); break;
        case 4: console.log("Function is never optimized"); break;
        case 6: console.log("Function is maybe deoptimized"); break;
        case 7: console.log("Function is optimized by TurboFan"); break;
        default: console.log("Unknown optimization status"); break;
    }
}

//识别类型信息
exampleFunction();
//这里调用 2 次是为了让这个函数状态从 uninitialized -> pre-monomorphic -> monomorphic
exampleFunction();

%OptimizeFunctionOnNextCall(exampleFunction);
//再次调用
exampleFunction();

//检查
printStatus(exampleFunction);
```

运行它：

```
$ node --trace_opt --trace_deopt --allow-natives-syntax test.js
(v0.12.7) Function is not optimized
(v4.0.0) Function is optimized by TurboFan 
```

https://codereview.chromium.org/1962103003

为了检验我们做的这个工具是否真的有用，注释掉 `eval` 语句然后再运行一次：

```bash
$ node --trace_opt --trace_deopt --allow-natives-syntax test.js
[optimizing 000003FFCBF74231 <JS Function exampleFunction (SharedFunctionInfo 00000000FE1389E1)> - took 0.345, 0.042, 0.010 ms]
Function is optimized
```

事实证明，使用这个工具来验证处理方法是可行且必要的。

## 2. 不支持的语法

有一些语法结构是不支持被编译器优化的，用这类语法将会导致包含在其中的函数不能被优化。

**请注意**，即使这些语句不会被访问到或者不会被执行，它仍然会导致整个函数不能被优化。

例如下面这样做是没用的：

```js
if (DEVELOPMENT) {
    debugger;
}
```

即使 debugger 语句根本不会被执行到，上面的代码将会导致包含它的整个函数都不能被优化。

目前不可被优化的语法有：

- ~~Generator 函数~~ （[V8 5.7](https://v8project.blogspot.de/2017/02/v8-release-57.html) 对其做了优化）
- ~~包含 for of 语句的函数~~ （V8 commit [11e1e20](https://github.com/v8/v8/commit/11e1e20) 对其做了优化）
- ~~包含 try catch 语句的函数~~ （V8 commit [9aac80f](https://github.com/v8/v8/commit/9aac80f) / V8 5.3 / node 7.x 对其做了优化）
- ~~包含 try finally 语句的函数~~ （V8 commit [9aac80f](https://github.com/v8/v8/commit/9aac80f) / V8 5.3 / node 7.x 对其做了优化）
- ~~包含[`let` 复合赋值](http://stackoverflow.com/q/34595356/504611)的函数~~ （Chrome 56 / V8 5.6! 对其做了优化）
- ~~包含 `const` 复合赋值的函数~~ （Chrome 56 / V8 5.6! 对其做了优化）
- 包含 `__proto__` 对象字面量、`get` 声明、`set` 声明的函数

看起来永远不会被优化的语法有：

- 包含 `debugger` 语句的函数
- 包含字面调用 `eval()` 的函数
- 包含 `with` 语句的函数

最后明确一下：如果你用了下面任何一种情况，整个函数将不能被优化：

```js
function containsObjectLiteralWithProto() {
    return {__proto__: 3};
}
```

```js
function containsObjectLiteralWithGetter() {
    return {
        get prop() {
            return 3;
        }
    };
}
```

```js
function containsObjectLiteralWithSetter() {
    return {
        set prop(val) {
            this.val = val;
        }
    };
}
```

另外在此要特别提一下 `eval` 和 `with`，它们会导致它们的调用栈链变成动态作用域，可能会导致其它的函数也受到影响，因为这种情况无法从字面上判断各个变量的有效范围。

**变通办法**

前面提到的不能被优化的语句用在生产环境代码中是无法避免的，例如 `try-finally` 和 `try-catch`。为了让使用这些语句的影响尽量减小，它们需要被隔离在一个最小化的函数中，这样主要的函数就不会被影响：

```js
var errorObject = {value: null};
function tryCatch(fn, ctx, args) {
    try {
        return fn.apply(ctx, args);
    }
    catch(e) {
        errorObject.value = e;
        return errorObject;
    }
}

var result = tryCatch(mightThrow, void 0, [1,2,3]);
//明确地报出 try-catch 会抛出什么
if(result === errorObject) {
    var error = errorObject.value;
}
else {
    //result 是返回值
}
```



## 3. 使用 `arguments`

有许多种使用 `arguments` 的方式会导致函数不能被优化。因此当使用 `arguments` 的时候需要格外小心。

#### 3.1. 在非严格模式中，对一个已经被定义，同时在函数体中被 `arguments` 引用的参数重新赋值。典型案例：

```js
function defaultArgsReassign(a, b) {
     if (arguments.length < 2) b = 5;
}
```

**变通方法** 是将参数值保存在一个新的变量中：

```js
function reAssignParam(a, b_) {
    var b = b_;
    //与 b_ 不同，可以安全地对 b 进行重新赋值
    if (arguments.length < 2) b = 5;
}
```

如果仅仅是像上面这样用 `arguments`（上面代码作用为检测第二个参数是否存在，如果不存在则赋值为 5），也可以用 `undefined` 检测来代替这段代码：

```js
function reAssignParam(a, b) {
    if (b === void 0) b = 5;
}
```

但是之后如果需要用到 `arguments`，很容易忘记需要在这儿加上重新赋值的语句。

**变通方法 2**：为整个文件或者整个函数开启严格模式 （`'use strict'`）。

#### 3.2. arguments 泄露：

```js
function leaksArguments1() {
    return arguments;
}
```

```js
function leaksArguments2() {
    var args = [].slice.call(arguments);
}
```

```js
function leaksArguments3() {
    var a = arguments;
    return function() {
        return a;
    };
}
```

`arguments` 对象在任何地方都不允许被传递或者被泄露。

**变通方法** 可以通过创建一个数组来代理 `arguments` 对象：

```js
function doesntLeakArguments() {
                    //.length 仅仅是一个整数，不存在泄露
                    //arguments 对象本身的问题
    var args = new Array(arguments.length);
    for(var i = 0; i < args.length; ++i) {
                //i 是 arguments 对象的合法索引值
        args[i] = arguments[i];
    }
    return args;
}

function anotherNotLeakingExample() {
    var i = arguments.length;
    var args = [];
    while (i--) args[i] = arguments[i];
    return args
}
```

但是这样要写很多让人烦的代码，因此得判断是否真的值得这么做。后面一次又一次的优化会代理更多的代码，越来越多的代码意味着代码本身的意义会被逐渐淹没。

不过，如果你有 build 这个过程，可以将上面这一系列过程由一个不需要 source map 的宏来实现，保证代码为合法的 JavaScript：

```js
function doesntLeakArguments() {
    INLINE_SLICE(args, arguments);
    return args;
}
```

Bluebird 就使用了这个技术，上面的代码经过 build 之后会被拓展成下面这样：

```js
function doesntLeakArguments() {
    var $_len = arguments.length;
    var args = new Array($_len); 
    for(var $_i = 0; $_i < $_len; ++$_i) {
        args[$_i] = arguments[$_i];
    }
    return args;
}
```

#### 3.3. 对 arguments 进行赋值：

在非严格模式下可以这么做：

```js
function assignToArguments() {
    arguments = 3;
    return arguments;
}
```

**变通方法**：犯不着写这么蠢的代码。另外，在严格模式下它会报错。

#### 那么如何安全地使用 `arguments` 呢？

只使用：

- `arguments.length`
- `arguments[i]` **`i` 需要始终为 arguments 的合法整型索引，且不允许越界**
- 除了 `.length` 和 `[i] `，不要直接使用 `arguments`
- 严格来说用 `fn.apply(y, arguments)` 是没问题的，但除此之外都不行（例如 `.slice`）。 `Function#apply` 是特别的存在。
- 请注意，给函数添加属性值（例如 `fn.$inject = ...`）和绑定函数（即 `Function#bind` 的结果）会生成隐藏类，因此此时使用 `#apply` 不安全。

如果你按照上面的安全方式做，毋需担心使用 `arguments` 导致不确定 arguments 对象的分配。

## 4. Switch-case

在以前，一个 switch-case 语句最多只能包含 128 个 case 代码块，超过这个限制的 switch-case 语句以及包含这种语句的函数将不能被优化。

```js
function over128Cases(c) {
    switch(c) {
        case 1: break;
        case 2: break;
        case 3: break;
        ...
        case 128: break;
        case 129: break;
    }
}
```
你需要让 case 代码块的数量保持在 128 个之内，否则应使用函数数组或者 if-else。

这个限制现在已经被解除了，请参阅此 [comment](https://bugs.chromium.org/p/v8/issues/detail?id=2275#c9)。

## 5. For-in

For-in 语句在某些情况下会导致整个函数无法被优化。

这也解释了”For-in 速度不快“之类的说法。

#### 5\.1\. 键不是局部变量：

```js
function nonLocalKey1() {
    var obj = {}
    for(var key in obj);
    return function() {
        return key;
    };
}
```

```js
var key;
function nonLocalKey2() {
    var obj = {}
    for(key in obj);
}
```

这两种用法db都将会导致函数不能被优化的问题。因此键不能在上级作用域定义，也不能在下级作用域被引用。它必须是一个局部变量。

#### 5.2. 被遍历的对象不是一个”简单可枚举对象“

##### 5.2.1. 处于”哈希表模式“（又被称为”归一化对象“或”字典模式对象“ - 这种对象将哈希表作为其数据结构）的对象不是简单可枚举对象。

```js
function hashTableIteration() {
    var hashTable = {"-": 3};
    for(var key in hashTable);
}
```
如果你给一个对象动态增加了很多的属性（在构造函数外）、`delete` 属性或者使用不合法的标识符作为属性，这个对象将会变成哈希表模式。换句话说，当你把一个对象当做哈希表来用，它就真的会变成哈希表。请不要对这种对象使用 `for-in`。你可以用过开启 Node.JS 的 `--allow-natives-syntax`，调用 `console.log(%HasFastProperties(obj))` 来判断一个对象是否为哈希表模式。

<hr>

##### 5.2.2. 对象的原型链中存在可枚举属性

```js
Object.prototype.fn = function() {};
```

上面这么做会给所有对象（除了用 `Object.create(null)` 创建的对象）的原型链中添加一个可枚举属性。此时任何包含了 `for-in` 语法的函数都不会被优化（除非仅遍历 `Object.create(null)` 创建的对象）。

你可以使用 `Object.defineProperty` 创建不可枚举属性（不推荐在 runtime 中调用，但是在定义一些例如原型属性之类的静态数据的时候它很高效）。

<hr>

##### 5.2.3. 对象中包含可枚举数组索引

[ECMAScript 262 规范](http://www.ecma-international.org/ecma-262/5.1/#sec-15.4) 定义了一个属性是否有数组索引：

> 数组对象会给予一些种类的属性名特殊待遇。对一个属性名 P（字符串形式），当且仅当 ToString(ToUint32(P)) 等于 P 并且 ToUint32(P) 不等于 2<sup>32</sup>−1 时，它是个 数组索引 。一个属性名是数组索引的属性也叫做元素 。

一般只有数组有数组索引，但是有时候一般的对象也可能拥有数组索引： `normalObj[0] = value;`

```js
function iteratesOverArray() {
    var arr = [1, 2, 3];
    for (var index in arr) {

    }
}
```

因此使用 `for-in` 进行数组遍历不仅会比 for 循环要慢，还会导致整个包含 `for-in` 语句的函数不能被优化。

<hr>

如果你试图使用 `for-in` 遍历一个非简单可枚举对象，它会导致包含它的整个函数不能被优化。 

**变通方法**：只对 `Object.keys` 使用 `for-in`，如果要遍历数组需使用 for 循环。如果非要遍历整个原型链上的属性，需要将 `for-in` 隔离在一个辅助函数中以降低影响：

```js
function inheritedKeys(obj) {
    var ret = [];
    for(var key in obj) {
        ret.push(key);
    }
    return ret;
}
```
## 6. 退出条件藏的很深，或者没有定义明确出口的无限循环

有时候在你写代码的时候，你需要用到循环，但是不确定循环体内的代码之后会是什么样子。所以这时候你用了一个 `while (true) {` 或者 `for (;;) {`，在之后将终止条件放在循环体中，打断循环进行后面的代码。然而你写完这些之后就忘了这回事。在重构时，你发现这个函数很慢，出现了反优化情况 - 上面的循环很可能就是罪魁祸首。

重构时将循环内的退出条件放到循环的条件部分并不是那么简单。

1. 如果代码中的退出条件是循环最后的 if 语句的一部分，且代码至少要运行一轮，那么你可以将这个循环重构为 `do{} while ();`。
2. 如果退出条件在循环的开头，请将它放在循环的条件部分中去。
3. 如果退出条件在循环体中部，你可以尝试”滚动“代码：试着依次将一部分退出条件前的代码移到后面去，然后在之前的位置留下它的引用。当退出条件可以放在循环条件部分，或者至少变成一个浅显的逻辑判断时，这个循环就不再会出现反优化的情况了。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
