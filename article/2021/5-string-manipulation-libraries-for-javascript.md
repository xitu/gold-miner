> * 原文地址：[5 String Manipulation Libraries for JavaScript](https://blog.bitsrc.io/5-string-manipulation-libraries-for-javascript-9ca5da8b4eb8)
> * 原文作者：[Mike Chen](https://medium.com/@gitgit6)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-string-manipulation-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-string-manipulation-libraries-for-javascript.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)

# 5 个 JavaScript 的字符操作库

![](https://cdn-images-1.medium.com/max/2560/1*pdPTFvogzT9vzmc7k-qY2Q.jpeg)

处理字符串可能是一项繁琐的任务，因为我们需要考虑许多不同的用例。举例来说，像将字符串转为驼峰格式这样简单的任务就需要好几行代码来实现。

```js
function camelize(str) {
  return str.replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, function(match, index) {
    if (+match === 0) return ""; // 或 if (/\s+/.test(match)) 来匹配空白字符
    return index === 0 ? match.toLowerCase() : match.toUpperCase();
  });
}
```

上方的代码片段是在 Stack Overflow 中最受好评的答案。然而，它无法解决字符串中包含 `---Foo---bAr---` 的用例。

![运行结果](https://cdn-images-1.medium.com/max/2000/1*B2BkvkI5nmrksHi8UpLHIQ.png)

这时字符串处理库就派上用场了。这些库考虑了给定问题的每一种可能的用例，使得复杂字符串操作的实现变得简单。这对你很有帮助，因为你只需要调用一个函数就能得到有效的解决方案。

让我们看看几个 JavaScript 中的几个字符串处理库。

## 1. String.js

String.js（简称为 `S`）是一个为浏览器或 Node.js 提供额外字符串操作方法的轻量级（压缩后大小小于 5 kB）JavaScript 库。

### 安装方式

```bash
npm i string
```

### 值得注意的方法

* `between(left, right)` —— 提取 `left` 和 `right` 字符串之间的所有字符。

这个方法可以用于提取 HTML 标签之间的元素。

```js
var S = require('string');
S('<a>This is a link</a>').between('<a>', '</a>').s 
// => 'This is a link'
```

* `camelize()` —— 去除所有的下划线和破折号，并将字符串转为驼峰格式。

这个方法可以用来解决这篇文章开头时的问题。

```js
var S = require('string');
S('---Foo---bAr---').camelize().s; 
// => 'fooBar'
```

* `humanize()` —— 将输入转为人性化的形式。

从无到有地实现这个函数必定需要相当多行的代码。

```js
var S = require('string');
S('   capitalize dash-CamelCase_underscore trim  ').humanize().s
// => 'Capitalize dash camel case underscore trim'
```

* `stripPunctuation()` —— 去除给定字符串的所有标点符号。

如果你从头开始实现这个函数，那么你很可能会错过某个标点符号。

```js
var S = require('string');
S('My, st[ring] *full* of %punct)').stripPunctuation().s; 
// => 'My string full of punct'
```

你可以在[这里](https://github.com/jprichardson/string.js)查看更多的方法。

## 2. Voca

Voca 是一个 JavaScript 字符串操作库。这个库包含了**更改大小写**，**修剪**，**填充**，**生成 slug**，**拉丁化**，**sprintf 格式化**，**截断**，**转义**和其他有用的字符串操作方法。为了减少应用程序的构建，Voca 的模块化构建允许你只载入特定的功能。该库已经过**全面的测试**，**文档完整**，且**提供长期的支持**。

### 安装方式

```bash
npm i voca
```

### 值得注意的方法

* `camelCase(String data)`

将 `data` 转为驼峰格式。

```js
var v = require('voca');
v.camelCase('foo Bar');
// => 'fooBar'

v.camelCase('FooBar');
// => 'fooBar'

v.camelCase('---Foo---bAr---');
// => 'fooBar'
```

* `latinise(String data)`

通过删除变音符号来拉丁化 `data`。

```js
var v = require('voca');
v.latinise('cafe\u0301'); // or 'café'
// => 'cafe'

v.latinise('août décembre');
// => 'aout decembre'

v.latinise('как прекрасен этот мир');
// => 'kak prekrasen etot mir'
```

* `isAlphaDigit(String data)`

检查 `data` 是否只包含字母和数字字符（文数字字符串）。

```js
var v = require('voca');
v.isAlphaDigit('year2020');
// => true

v.isAlphaDigit('1448');
// => true

v.isAlphaDigit('40-20');
// => false
```

* `countWords(String data)`

计算 `data` 中的单词数。

```js
var v = require('voca');
v.countWords('gravity can cross dimensions');
// => 4

v.countWords('GravityCanCrossDimensions');
// => 4

v.countWords('Gravity - can cross dimensions!');
// => 4
```

* `escapeRegExp(String data)`

转义正则表达式中的特殊字符 —— `- [ ] / { } ( ) * + ? . \ ^ $ |`。

```js
var v = require('voca');
v.escapeRegExp('(hours)[minutes]{seconds}');
// => '\(hours\)\[minutes\]\{seconds\}'
```

你可以在[此处](https://vocajs.com/#)查看更多的信息。

## 3. Anchorme.js

这是一个小巧且快速的 JavaScript 库。它能帮助你检测链接、URL、电邮地址等，并将它们转为可点击的 HTML 锚链接。

* 高敏感度，低误报率。
* 根据完整的 IANA（互联网号码分配局）列表验证 URL 和电邮地址。
* 验证端口号（如有）。
* 验证 IP 地址（如有）。
* 可检测非拉丁字母的 URL。

### 安装方式

```bash
npm i anchorme
```

### 用法

```js
import anchorme from "anchorme"; 
// 或 
// var anchorme = require("anchorme").default;

const input = "some text with a link.com"; 
const resultA = anchorme(input);
// => 'some text with a <a href="http://link.com">link.com</a>'
```

你可以传入额外的扩展来进一步地自定义这个功能。

## 4. Underscore.string

[Underscore.string](https://github.com/epeli/underscore.string) 是 JavaScript 字符串操作扩展，你可以将它与 Underscore.js 配合使用。Underscore.string 是 Underscore.js 的扩展，受 [Prototype.js](http://api.prototypejs.org/language/String/)，[Right.js](http://rightjs.org/docs/string) 和 [Underscore](http://documentcloud.github.com/underscore/) 所启发。这个 JavaScript 库能让你「惬意的」操作字符串。

Underscore.string 为你提供了几个有用的功能，例如：`capitalize`，`clean`，`includes`，`count`，`escapeHTML`，`unescapeHTML`，`insert`，`splice`，`startsWith`，`endsWith`，`titleize`，`trim`，`truncate` 等等。

### 安装方式

```bash
npm install underscore.string
```

### 值得注意的方法

* `numberFormat(number)` —— 格式化数字。

将数字格式化为带有小数点和万位分隔符的字符串。

```js
var _ = require("underscore.string");

_.numberFormat(1000, 3)
// => "1,000.000"

_.numberFormat(123456789.123, 5, '.', ',');
// => "123,456,789.12300"
```

* `levenshtein(string1, string2)` —— 计算两个字符串的莱文斯坦距离。

你可以在[此处](https://dzone.com/articles/the-levenshtein-algorithm-1)了解更多有关莱文斯坦距离算法的信息。

```js
var _ = require("underscore.string");

_.levenshtein('kitten', 'kittah');
// => 2
```

* `chop(string, step)` —— 将指定字符串切成多段。

```js
_.chop('whitespace', 3);
// => ['whi','tes','pac','e']
```

你可以在[此处](http://gabceb.github.io/underscore.string.site)了解更多有关 Underscore String 的信息。

## 5. Stringz

这个库的主要亮点在于它可以识别 Unicode。如果你运行以下的代码，输出会是 2。

```js
"🤔".length;
// => 2
```

这是因为 `String.length()` 回传的是字符串中的代码单元数，而不是字符数。实际上，在 **010000 至 03FFFF** 和 **040000 至 10FFFF** 区间中的字符需要 4 个字节（32 位），1 个码位来表示。这对结果毫无影响。然而，有些字符需要超过 2 个字节来表示，一次他们需要 1 个以上的码位。

你可以在[此处](https://mathiasbynens.be/notes/javascript-unicode)阅读更多有关 JavaScript Unicode 的问题。

### 安装方式

```bash
npm install stringz
```

### 值得注意的方法

* `limit(string, limit, padString, padPosition)`

将字符串长度限制在给定长度内。

```js
const stringz = require('stringz');

// 截断：
stringz.limit('Life’s like a box of chocolates.', 20); 
// => "Life's like a box of"

// 填充：
stringz.limit('Everybody loves emojis!', 26, '💩'); 
// => "Everybody loves emojis!💩💩💩"
stringz.limit('What are you looking at?', 30, '+', 'left'); 
// => "++++++What are you looking at?"

// 可识别 unicode
stringz.limit('🤔🤔🤔', 2); 
// => "🤔🤔"
stringz.limit('👍🏽👍🏽', 4, '👍🏽'); 
// => "👍🏽👍🏽👍🏽👍🏽"
```

* `toArray(string)`

将字符串转为数组：

```js
const stringz = require('stringz');

stringz.toArray('abc');
// ['a','b','c']

// 可识别 unicode
stringz.toArray('👍🏽🍆🌮');
// ['👍🏽', '🍆', '🌮']
```

欲了解更多关于 Stringz 的信息，请访问 [Stringz 的 Github 仓库](https://github.com/sallar/stringz)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
