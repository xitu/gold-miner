> * 原文地址：[Understanding JavaScript’s ‘undefined’](https://javascriptweblog.wordpress.com/2010/08/16/understanding-undefined-and-preventing-referenceerrors/)
> * 原文作者：[Angus Croll](https://javascriptweblog.wordpress.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-undefined-and-preventing-referenceerrors.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-undefined-and-preventing-referenceerrors.md)
> * 译者：[yanyixin](https://github.com/yanyixin)
> * 校对者：

# 理解 JavaScript 中的 undefined

与其他的语言相比，JavaScript 中 undefined 的概念是有些令人困惑的。特别是试图去理解 ReferenceError （“x is not defined”）以及如何针对它们写出优雅的代码是很令人沮丧的。

本文是我试图把这件事情弄清楚的一些尝试。如果你还不熟悉 JavaScript 中变量和属性的区别（包括内部的 VariableObject），那么最好先去阅读一下我的[上一篇文章](https://javascriptweblog.wordpress.com/2010/08/09/variables-vs-properties-in-javascript/)。

#### 什么是 undefined？
  
在 JavaScript 中有 Undefined (type)、 undefined (value) 和 undefined (variable)。
  
**Undefined (type)** 是 JavaScript 的内置类型。

**undefined (value)** 是 Undefined 类型的唯一的值。任何未被赋值的属性都被假定为 `undefined`（ECMA 4.3.9 和 4.3.10）。没有 return 语句的函数，或者 return 空的函数将返回 undefined。函数中没有被定义的参数的值也被认为是 undefined。

```
var a;
typeof a; //"undefined"
 
window.b;
typeof window.b; //"undefined"
 
var c = (function() {})();
typeof c; //"undefined"
 
var d = (function(e) {return e})();
typeof d; //"undefined"
```

**undefined (variable)** 是一个初始值为 undefined (value) 的全局属性，因为它是一个全局属性，我们还可以将其作为变量访问。为了保持一致性，我在本文中统一称它为变量。

```
typeof undefined; //"undefined"
 
var f = 2;
f = undefined; //re-assigning to undefined (variable)
typeof f; //"undefined"
```

从 ECMA 3 开始，它可以被重新赋值：

```
undefined = "washing machine"; // 把一个字符串赋值给 undefined (变量）
typeof undefined //"string"
 
f = undefined;
typeof f; //"string"
f; //"washing machine"
```

毋庸置疑，给 undefined 变量重新赋值是非常不好的做法。事实上，ECMA 5 不允许这样做（不过，在当前的浏览器中，只有 Safari 强制执行了）。

#### 然后是 null ？

是的，一般都很好理解，但是还需要重申的是：`undefined` 与 `null` 不同，`null` 表示**有意的**缺少值的原始值。`undefined` 和 `null` 唯一的相似之处是，它们都为 false。

#### 所以，什么是 ReferenceError（引用错误）？

ReferenceError 说明检测到了一个无效的引用值。（ECMA 5 15.11.6.3）

在实际项目中，这意味着当 JavaScript 试图获取一个不可被解析的引用时，会抛出 ReferenceError。（还有一些其他的情况会抛出 ReferenceError，尤其是在 ECMA 5 严格模式下运行的时候。如果你有兴趣的话，可以看本文末尾的阅读列表。）

需要注意不同浏览器发出的消息语法是如何变化的，正如我们将看到的，这些信息没有一个是特别有启发性的：

```
alert(foo)
//FF/Chrome: foo is not defined
//IE: foo is undefined
//Safari: can't find variable foo
```

#### 仍然不清楚“无法解析的引用（unresolvable reference）”？

在 ECMA 术语中，引用由基值（base value）和引用名（reference name）构成（ECMA 5 8.7 - 我再次忽略了严格模式。还要注意，ECMA 3 的术语略有不同，但实际意义是相同的）。

如果引用是属性，那么基值和引用名位于 `.` 的两侧（或第一个括号或其他）：

```
window.foo; //base value = window, reference name = foo;
a.b; //base value = a, reference name = b;
myObj['create']; // base value = myObj, reference name = 'create';
//Safari, Chrome, IE8+ only
Object.defineProperty(window,"foo", {value: "hello"}); //base value = window, reference name = foo;
```

对于变量引用，基值是当前执行上下文的 VariableObject。全局上下文的 VariableObject 是全局对象本身（浏览器中的 `window`）。每个函数上下文都有一个抽象的变量对象，称为 ActivationObject。

```
var foo; //base value = window, reference name = foo
function a() {
    var b; base value = <code>ActivationObject</code>, reference name = b
}
```

**如果基值是 undefined，则认为引用是无法被解析的。**

因此，如果在 `.` 之前的变量值为 undefined，那么属性引用是不可被解析的。下面的示例本会抛出一个 ReferenceError，但实际上它不会，因为 TypeError 会先被抛出。这是因为属性的基值受 CheckObjectCoercible （ECMA 5 9.10 到 11.2.1）的影响，在它尝试将 Undefined 类型转换为 Object 的时候会抛出 TypeError。（感谢 kangax 在 twitter 上提前发布的消息）

```
var foo;
foo.bar; //TypeError （基值，foo 是未定义的）
bar.baz; //ReferenceError （bar 是不能被解析的）
undefined.foo; //TypeError （基值是未定义的）
```

变量引用永远会被解析，因为 var 关键字确保 VariableObject 总是被赋给基值。

根据定义，既不是属性也不是变量的引用是不可解析的，并且会抛出一个 ReferenceError:

```
foo; //ReferenceError
```

上面的 JavaScript 中没有看到显式的基值，因此会查找 VariableObject 来引用名称为 `foo` 的属性。确定 `foo` 没有基值，然后抛出 ReferenceError。

#### 但是 `foo` 不是一个未声明的变量吗？

技术上不是的。虽然我们有时会发现 “undeclared variable” 是一个错误诊断时有用的术语，但实际上，在变量被声明之前不是变量。

#### 那么隐式全局变量呢？

的确，从未被 var 关键字声明过的标识符将被创建为全局变量 —— 但只有当它们被赋值时才会这样。

```
function a() {
    alert(foo); //ReferenceError
    bar = [1,2,3]; //没有错误，foo 是全局的
}
a();
bar; //"1,2,3"
```

当然，这很烦人。如果 JavaScript 在遇到无法解析的引用时始终抛出 ReferenceErrors 那就更好了（实际上这是它在 ECMA 严格模式下所做的）。

#### 什么时候需要针对 ReferenceError 进行编码?

如果你的代码写得够好的话，其实很少需要这样做。我们已经看到，在典型的用法中，只有一种方法可以获得不可解析的引用：使用既不是属性也不是变量的仅在语法上正确的引用。在大多数情况下，确保记住 var 关键字可以避免这种情况。只有在引用只存在于某些浏览器或第三方代码中的变量时，才会出现运行时异常。

一个很好的例子是 **console**。在 Webkit 浏览器中，console 是内置的，console 的属性总是可用的。然而 firefox 中的 console 依赖于安装和打开Firebug（或其他附加组件）。IE7 没有 console，IE8 有 console，但 console 属性只在 IE 开发工具启动时存在。显然 Opera 有 console，但我从来没有使用过。

结论是，下面的代码片段在浏览器中运行时很可能会抛出 ReferenceError：

```
console.log(new Date());
```

#### 如何对可能不存在的变量进行编码？

检查一个不可解析的引用而且不抛出 ReferenceError 的一种方法是使用 `typeof` 关键字。

```
if (typeof console != "undefined") {
    console.log(new Date());
}
```

然而，这在我看来总是很繁琐的，更不用说可疑的了（它不是引用名称是 undefined，而是基值为 undefined）。但是无论如何，我更喜欢保留 `typeof` 来进行类型检查。

幸运的是，还有另一种方法：我们已经知道，如果 undefined 属性的基值被定义，那么它就不会抛出 ReferenceError —— 而且由于 console 属于全局对象，我们就可以这样做:

```
window.console && console.log(new Date());
```

实际上，只需要检查全局上下文中是否存在变量（函数中存在其他执行上下文，而且你可以控制自己的函数中存在哪些变量）。所以，理论上你应该能够避免使用 `typeof` 来检查引用错误。

#### 我在哪里可以阅读更多？


Mozilla 开发者中心：[undefined](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/undefined)

Angus Croll: [JavaScript 中的变量与属性](https://javascriptweblog.wordpress.com/2010/08/09/variables-vs-properties-in-javascript/)  

Juriy Zaytsev (“kangax”): [理解 Delete](http://perfectionkills.com/understanding-delete/)  

Dmitry A. Soshnikov: [ECMA-262-3 - 第二章 - 变量对象。](http://dmitrysoshnikov.com/ecmascript/chapter-2-variable-object/)  

[ECMA-262 第五版](http://www.ecmascript.org/docs/tc39-2009-043.pdf)  

**undefined**: 4.3.9, 4.3.10, 8.1

**Reference Error**: 8.7.1, 8.7.2, 10.2.1, 10.2.1.1.4, 10.2.1.2.4, and 11.13.1.

**ECMAScript 的严格模式** Annex C

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
