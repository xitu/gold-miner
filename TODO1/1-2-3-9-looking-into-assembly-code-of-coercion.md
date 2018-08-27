> * 原文地址：[[1] + [2] - [3] === 9!? Looking into assembly code of coercion](https://wanago.io/2018/04/02/1-2-3-9-looking-into-assembly-code-of-coercion/)
> * 原文作者：[wanago.io](https://wanago.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/1-2-3-9-looking-into-assembly-code-of-coercion.md](https://github.com/xitu/gold-miner/blob/master/TODO1/1-2-3-9-looking-into-assembly-code-of-coercion.md)
> * 译者：[sunhaokk](https://github.com/sunhaokk)
> * 校对者：[Starrier](https://github.com/Starriers)、[Xekin-FE](https://github.com/Xekin-FE)

# [1] + [2] - [3] === 9!? 类型转换深入研究

变量值拥有多种格式。而且您可以将一种类型的值转换为另一种类型的值。这叫**类型转换**（也叫显式转换）。如果是在后台中尝试对不匹配的类型执行操作时发生, 叫 **强制转换**（有时也叫隐式转换）。在这篇文章中，我会引导你了解这两个过程，以便更好地理解过程。让我们一起深入研究！

## 类型转换

### 原始类型包装

正如我[之前的一篇文章](https://wanago.io/2018/02/12/cloning-objects-in-javascript-looking-under-the-hood-of-reference-and-primitive-types/)所描述的那样,几乎 JavaScript 中的所有原始类型（除了 **null** 和 **undefined** 外）都有围绕它们原始值的对象包装。事实上，你可以直接调用原始类型的构造函数作为包装器将一个值的类型转换为另一个值。

```
String(123); // '123'
Boolean(123); // true
Number('123'); // 123
Number(true); // 1
```

> 一些原始类型的包装器，String、Bollean、Number 不会保留很长时间，一旦工作完成，它就消失。（译者注：JS 中将数据分成两种类型，原始类型（基本数据类型）和对象类型（引用数据类型）。在对象类型中又有三种特殊类型的引用类型分别是，String、Boolean、Number。这三个就是基本包装类型。实际上，每当读取一个基本类型值的时候，后台就会创建一个对应的基本包装类型的对象，从而可以调用这些类型的方法来操作数据。）

您需要注意，如果您这里使用了 new 关键字，就不再是当前实例。

```
const bool = new Boolean(false);
bool.propertyName = 'propertyValue';
bool.valueOf(); // false

if (bool) {
  console.log(bool.propertyName); // 'propertyValue'
}
```

由于 bool 在这里是一个新的对象（不是原始值），它的计算结果为 true。

进一步分析

```
if (1) {
  console.log(true);
}
```

效果一样

```
if ( Boolean(1) ) {
  console.log(true);
}
```

不要畏惧，勇于尝试。 下面用 **Bash** 测试。（译者注：因为没有找到源文件，所以我猜测这里的意思是使用的 if1.js 和 if2.js 是上文的 if 语句文件，这里通过 print-code 输出汇编代码。然后通过 awk 打印汇编文件每句第 4 列字符串到文件里。最后对比两个文件是否一致。借以推论出上面两句 if 在程序中的执行是一致的。）

1. 使用 node.js 将代码编译到程序中

```
$ node --print-code ./if1.js >> ./if1.asm
```

```
$ node --print-code ./if2.js >> ./if2.asm
```

2. 准备一个脚本来比较第四列（汇编操作数）- 我故意跳过这里的内存地址，因为它们可能有所不同。

```
#!/bin/bash

file1=$(awk '{ print $4 }' ./if1.asm)
file2=$(awk '{ print $4 }' ./if2.asm)

[ "$file1" == "$file2" ] && echo "文件匹配"
```

3. 运行

```
"文件匹配"
```

### parseFloat 函数

这个函数的作用类似于 **Number** 的构造函数，但对于传递的参数来说不那么严格。如果它遇到一个不能成为数字一部分的字符，它将返回一个到该点的值并忽略其余字符。

```
Number('123a45'); // NaN
parseFloat('123a45'); // 123
```


### parseInt 函数

它在解析数字时将数字向下舍入。它可以使用不同的基数。

```
parseInt('1111', 2); // 15
parseInt('0xF'); // 15

parseFloat('0xF'); // 0
```

函数 parseInt 可以猜测基数或让它作为第二个参数传递。有关其中需要考虑的规则列表，请查看 [MDN web docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt)。

如果传入的数值过大会出问题，所以它不应该被认为是 [**Math.floor**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/floor) (它也会进行类型转换)的替代品：

```
parseInt('1.261e7'); // 1
Number('1.261e7'); // 12610000
Math.floor('1.261e7') // 12610000

Math.floor(true) // 1
```

### toString 函数

您可以使用 **toString** 函数将值转换为字符串。这个功能的实现在原型之间有所不同。

> 如果您觉得您希望更好地理解原型的概念，请随时查看我的其他文章： [Prototype. The big bro behind ES6 class](https://wanago.io/2018/03/19/prototype-the-big-bro-behind-es6-class/)。

#### String.prototype.toString 函数

返回一个字符串的值

```
const dogName = 'Fluffy';

dogName.toString() // 'Fluffy'
String.prototype.toString.call('Fluffy') // 'Fluffy'

String.prototype.toString.call({}) // Uncaught TypeError: String.prototype.toString requires that 'this' be a String
```

#### Number.prototype.toString 函数

返回转换为 String 的数字（您可以将 appendix 作为第一个参数传递）

```
(15).toString(); // "15"
(15).toString(2); // "1111"
(-15).toString(2); // "-1111"
```

#### Symbol.prototype.toString 函数

返回  `Symbol(${description})`

> 如果你对此感到疑问： 我这里使用的是 [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)的方式，它可以向你解释是怎么输出这种字符串的。

#### Boolean.prototype.toString 函数

返回 “true” 或 “false”

#### Object.prototype.toString 函数

Object 调用内部 **[[Class]]** 。它是代表对象类型的标签。

**Object.prototype.toString** 返回一个 `[object ${tag}]` 字符串。 要么它是内置标签之一 (例如  “Array”, “String”, “Object”, “Date” ), 或者它被明确设置。

```
const dogName = 'Fluffy';

dogName.toString(); // 'Fluffy' （在这调用 String.prototype.toString ）
Object.prototype.toString.call(dogName); // '[object String]'
```

随着 ES6 的推出，设置标签可以使用 [**Symbols**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)来完成。

```
const dog = { name: 'Fluffy' }
console.log( dog.toString() ) // '[object Object]'

dog[Symbol.toStringTag] = 'Dog';
console.log( dog.toString() ) // '[object Dog]'
```

```
const Dog = function(name) {
  this.name = name;
}
Dog.prototype[Symbol.toStringTag] = 'Dog';

const dog = new Dog('Fluffy');
dog.toString(); // '[object Dog]'
```

你也可以在这里使用 ES6 类和 getter：

```
class Dog {
  constructor(name) {
    this.name = name;
  }
  get [Symbol.toStringTag]() {
    return 'Dog';
  }
}

const dog = new Dog('Fluffy');
dog.toString(); // '[object Dog]'
```

#### Array.prototype.toString 函数

在每个元素上调用 **toString** 并返回一个字符串，所有的输出用逗号分隔。

```
const arr = [
  {},
  2,
  3
]

arr.toString() // "[object Object],2,3"
```

## 隐式转换

如果您了解类型转换的工作原理，那么理解隐式转换会容易得多。

## 数学运算符

### 加符号

当在字符串与操作数之间使用 + 时结果将返回一个字符串。

```
'2' + 2 // 22
15 + '' // '15'
```

你可以用加符号将一个操作数转换为数字：

```
+'12' // 12
```

### 其他数学运算符

其他数学运算符，例如 `-` 或 `/` 操作，将自动转成数字。

```
new Date('04-02-2018') - '1' // 1522619999999
'12' / '6' // 2
-'1' // -1
```

日期, 转成数字 [Unix 时间戳](https://en.wikipedia.org/wiki/Unix_time)。

## 叹号

如果原始值是 false 的，则使用它将输出 true，如果 true，则输出为 false。因此，如果使用两次，它可以用于将该值转换为相应的布尔值。

```
!1 // false
!!({}) // true
```

## ToInt32 按位或

值得一提的是，即使 ToInt32 实际上是一个抽象操作（仅限内部，不可调用），它也会把一个值转换为[带符号 32 位整型](https://en.wikipedia.org/wiki/32-bit)。

```
0 | true          // 1
0 | '123'         // 123
0 | '2147483647'  // 2147483647
0 | '2147483648'  // -2147483648 (too big)
0 | '-2147483648' // -2147483648
0 | '-2147483649' // 2147483647 (too small)
0 | Infinity      // 0
```

当其中一个操作数为 0 时执行按位或操作将导致不改变另一个操作数的值。

### 其他隐式转换

在编码时，您可能会遇到更多隐式转换的情况。考虑这个例子

```
const foo = {};
const bar = {};
const x = {};

x[foo] = 'foo';
x[bar] = 'bar';

console.log(x[foo]); // "bar"
```

发生这种情况是因为 foo 和 bar 在转换为字符串时都会转成 “[object Object]” 。真正发生的是这样的：

```
x[bar.toString()] = 'bar';
x["[object Object]"]; // "bar"
```

隐式转换在 [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)也会发生。尝试在这里重载 **toString** 函数：


```
const Dog = function(name) {
  this.name = name;
}
Dog.prototype.toString = function() {
  return this.name;
}

const dog = new Dog('Fluffy');
console.log(`${dog} is a good dog!`); // "Fluffy is a good dog!"
```
隐式转换也是为什么**比较运算符**（==）可能被认为是不好的做法，因为如果它们的类型不匹配，它会尝试通过强制转换进行匹配。

查看这个例子以获得一个关于比较的有趣事实：

```
const foo = new String('foo');
const foo2 = new String('foo');

foo === foo2 // false
foo >= foo2 // true
```

因为我们在这里使用了 **new** 关键字，所以 foo 和 foo2 都保留了它们的原始值（这是 'foo' ）的包装。由于他们现在正在引用两个不同的对象， `foo === foo2` 结果为 false。关系操作 ( `>=` ) 在两边调用 **valueOf** 函数。因此，在这里比较原始值内存地址, `'foo' >= 'foo'` 返回 **true**。

## [1] + [2] – [3] === 9

我希望所有这些知识能帮助你揭开本文标题中问题的神秘面纱。让我们揭开它吧！

1. `[1] + [2]` 这些转换应用 **Array.prototype.toString** 规则然后连接字符串。结果将是 `"12"`。
  * `[1,2] + [3,4]` 结果是 `"1,23,4"`。
2. `12 - [3]` 将导致 `12` 减 `"3"` 得 `9`
  * `12 - [3,4]` 因为 `"3,4"`不能转成数字所以得 **NaN** 

## 总结

尽管很多人可能会建议你避免隐式转换，但我认为了解它的工作原理非常重要。依靠它可能不是一个好主意，但它对您在调试代码和避免首先出现的错误方面大有帮助。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
