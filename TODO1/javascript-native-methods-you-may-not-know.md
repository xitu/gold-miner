> * 原文地址：[JavaScript Native Methods You May Not Know](https://medium.com/better-programming/javascript-native-methods-you-may-not-know-ccc4b8aa5cfd)
> * 原文作者：[Moon](https://medium.com/@moonformeli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-native-methods-you-may-not-know.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-native-methods-you-may-not-know.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[Baddyo](https://github.com/Baddyo)，[Chorer](https://github.com/Chorer)

# 您可能不知道的原生 JavaScript 方法

#### 一些很强大但却经常被忽视的原生 JavaScript 方法

![](https://cdn-images-1.medium.com/max/2000/1*v0O86GFV7H15ol_r9xwNPA.jpeg)

自从 ES6 发布以来，许多新的、方便的原生方法被添加到 JavaScript 的新标准中。

但是，我还是在 GitHub 的仓库中看到了许多旧代码。当然，这并不是说它们不好，而是说如果使用我下面介绍的这些特性，代码将变得更具可读性、更美观。

---

## Number.isNaN 对比 isNaN

`NaN` 是 number 类型。

```js
typeof NaN === 'number'
```

所以您不能直接区分出 `NaN` 和普通数字。

甚至对于 `NaN` 和 普通数字，当调用 Object.prototype.toString.call 方法时都会返回 `[object Number]`。您可能已经知道 `isNaN` 方法可以用于检查参数是否为 `NaN`。但是自从有了 ES6 之后，构造函数 **Number()** 也开始将 isNaN 作为它的方法。那么，这二者有什么不同呢？

* `isNaN` —— 检查值是否不是一个普通数字或者是否不能转换为一个普通数字。
* `Number.isNaN` —— 检查值是否为 NaN。

这里有一些例子。[Stack Overflow](https://stackoverflow.com/questions/33164725/confusion-between-isnan-and-number-isnan-in-javascript) 上的网友已经讨论过这个话题了。

```js
Number.isNaN({});
// <- false，{} 不是 NaN
Number.isNaN('ponyfoo')
// <- false，'ponyfoo' 不是 NaN
Number.isNaN(NaN)
// <- true，NaN 是 NaN
Number.isNaN('pony'/'foo')
// <- true，'pony'/'foo' 是 NaN，NaN 是 NaN

isNaN({});
// <- true，{} 不是一个普通数字
isNaN('ponyfoo')
// <- true，'ponyfoo' 不是一个普通数字
isNaN(NaN)
// <- true，NaN 不是一个普通数字
isNaN('pony'/'foo')
// <- true，'pony'/'foo' 是 NaN, NaN 不是一个普通数字
```

---

## Number.isFinite 对比 isFinite

在 JavaScript 中，类似 1/0 这样的计算不会产生错误。相反，它会返回全局对象的一个属性 `Infinity`。

那么，如何检查一个值是否为无穷大呢？抱歉，您做不到。但是，您可以使用 `isFinite` 和 `Number.isFinite` 检查值是否为有限值。

它们的工作原理基本相同，但彼此之间略有不同。

* `isFinite` —— 检查传入的值是否是有限值。如果传入的值的类型不是 `number` 类型，会尝试将这个值转换为 `number` 类型，再判断。
* `Number.isFinite` —— 检查传入的值是否是有限值。即使传入的值的类型不是 `number` 类型，也不会尝试转换，而是直接判断。

```js
Number.isFinite(Infinity) // false
isFinite(Infinity) // false

Number.isFinite(NaN) // false
isFinite(NaN) // false

Number.isFinite(2e64) // true
isFinite(2e64) // true

Number.isFinite(undefined) // false
isFinite(undefined) // false

Number.isFinite(null) // false
isFinite(null) // true

Number.isFinite('0') // false
isFinite('0') // true
```

---

## Math.floor 对比 Math.trunc

在过去，当您需要取出小数点右边的数字时，您可能会使用 `Math.floor` 这个函数。但是从现在开始，如果您真正想要的只是整数部分，可以尝试使用 `Math.trunc` 函数。

* `Math.floor` —— 返回小于等于给定数字的最大整数。
* `Math.trunc` —— 返回数的整数部分。

基本上，如果给定的数是正数，它们会给出完全相同的结果。但是如果给定的数字是负数，结果就不同了。

```js
Math.floor(1.23) // 1
Math.trunc(1.23) // 1

Math.floor(-5.3) // -6
Math.trunc(-5.3) // -5

Math.floor(-0.1) // -1
Math.trunc(-0.1) // -0
```

---

## Array.prototype.indexOf 对比 Array.prototype.includes

当您想在给定数组中查找某个值时，如何查找它？我见过许多开发人员使用 `Array.prototype.indexOf`，如下面的例子所示。

```js
const arr = [1, 2, 3, 4];

if (arr.indexOf(1) > -1) {
  ...
}
```

* `Array.prototype.indexOf` —— 返回可以在数组中找到给定元素的第一个索引，如果不存在，则返回 `-1`。
* `Array.prototype.includes` —— 检查给定数组是否包含要查找的特定值，并返回 `true`/`false` 作为结果。

```js
const students = ['Hong', 'James', 'Mark', 'James'];

students.indexOf('Mark') // 1
students.includes('James') // true

students.indexOf('Sam') // -1
students.includes('Sam') // false
```

要注意，由于 Unicode 编码的差异，所以传入的值是大小写敏感的。

---

## String.prototype.repeat 对比 for 循环 

在 ES6 添加此特性之前，生成像 `abcabcabc` 这样的字符串的方法是，根据您的需要将字符串复制多次并连接到一个空字符串后面。

```js
var str = 'abc';
var res = '';

var copyTimes = 3;

for (var i = 0; i < copyTimes; i += 1) {
  for (var j = 0; j < str.length; j += 1) {
    res += str[j];
  }
}
```

但是这样写实在是又长又乱，有时候可读性也很差。为此，我们可以使用 `String.prototype.repeat` 函数。您所需要做的只是传入一个数字，该数字表示您希望重复字符串的次数。

```js
'abc'.repeat(3) // "abcabcabc"
'hi '.repeat(2) // "hi hi "

'empty'.repeat(0) // ""
'empty'.repeat(null) // ""
'empty'.repeat(undefined) // ""
'empty'.repeat(NaN) // ""

'error'.repeat(-1) // RangeError
'error'.repeat(Infinity) // RangeError
```

传入的值不能是负数，必须小于无穷大，并且还不能超过字符串的最大长度，不然会造成溢出。

---

## String.prototype.match 对比 String.prototype.includes

要检查字符串中是否包含某些特定字符串，有两种方法 —— `match` 函数和 `includes` 函数。

* `String.prototype.match` —— 接收 RegExp 类型的参数。RegExp 中支持的所有标志都可以使用。
* `String.prototype.includes` —— 接收两个参数，第一个参数是 `searchString`，第二个参数是 `position`。如果没有传入 `position` 参数，则使用默认值 `0`。

这二者的不同之处在于 `includes` 函数是大小写敏感的，而 `match` 函数可以不是。您可以将标记 `i` 放在 RegExp 中，使其不区分大小写。

```js
const name = 'jane';
const nameReg = /jane/i;

const str = 'Jane is a student';

str.includes(name) // false
str.match(nameReg) 
// ["Jane", index: 0, input: "Jane is a student", groups: undefined]
```

---

## String.prototype.concat 对比 String.prototype.padStart

当您希望在一个字符串的开头添加一些字符串时，`padStart` 是一个很有用的方法。

同样，`concat` 函数也可以很好地完成这个任务。但是最主要的区别是 `padStart` 函数会从结果字符串的第一位开始重复地将参数中的字符串填充到结果字符串。

我将向您展示如何使用这个函数。

```js
const rep = 'abc';
const str = 'xyz';
```

这里有两个字符串。我想在 `xyz` 前面添加 `rep` —— 但是，不仅是只添加一次，我希望重复添加。

```js
str.padStart(10, rep);
```

`padStart` 需要两个参数 —— 新创建的结果字符串的总长度和将要重复的字符串。理解这个函数最简单的方法是用空格代替字母写下来。

```
// 新建 10 个空格
1) _ _ _ _ _ _ _ _ _ _ 

// 在空格中将 'xyz' 填入
2) _ _ _ _ _ _ _ x y z

// 在剩下的空格中重复 'abc'
// 直到 'xyz' 的第一个字母出现
3) a b c a b c a x y z

// 结果最终会是
4) abcabcaxyz
```

这个函数对于这个特定场景下非常有用，并且如果用 `concat`（ 一个同样用于执行字符串追加的函数）绝对很难做到。

`padEnd` 函数和 `padStart` 函数一样，只不过从位置的末尾开始。

---

## 总结

在 JavaScript 中有许多有趣又有用的方法。虽然它们并不常见，但这并不意味着它们毫无用武之地。如何巧妙地使用它们就取决于您了。

#### 参考资料

* [JavaScript 中 isNaN 函数和 Number.isNaN 函数之间的混淆](https://stackoverflow.com/questions/33164725/confusion-between-isnan-and-number-isnan-in-javascript)
* [Number.isFinite —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isFinite)
* [isFinite —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/isFinite)
* [Math.trunc —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/trunc)
* [Math.floor —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/floor)
* [Array.prototype.indexOf —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf)
* [Array.prototype.includes —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes)
* [String.prototype.repeat —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/repeat)
* [String.prototype.math —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match)
* [String.prototype.includes —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes)
* [String.prototype.padStart —— MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
