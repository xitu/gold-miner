> * 原文地址：[5 String Manipulation Libraries for JavaScript](https://blog.bitsrc.io/5-string-manipulation-libraries-for-javascript-5de27e48ee62)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-string-manipulation-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-string-manipulation-libraries-for-javascript.md)
> * 译者：[IAMSHENSH](https://github.com/IAMSHENSH)
> * 校对者：[Gesj-yean](https://github.com/Gesj-yean), [CoolRice](https://github.com/CoolRice)

# 5 大 JavaScript 字符串操作库

![](https://cdn-images-1.medium.com/max/2560/1*pdPTFvogzT9vzmc7k-qY2Q.jpeg)

处理字符串可能是项繁琐的任务，因为会有许多不同的情况。例如，将字符串转化为驼峰格式这样的简单的任务，就可能需要几行代码才能实现。

```js
function camelize(str) {
  return str.replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, function(match, index) {
    if (+match === 0) return ""; // 或者对空格进行判断 if (/\s+/.test(match))
    return index === 0 ? match.toLowerCase() : match.toUpperCase();
  });
}
```

上面的代码是 StackOverflow 中点赞最多的答案。但这也无法处理 `---Foo---bAr---` 这样的字符串。

![](https://cdn-images-1.medium.com/max/2000/1*B2BkvkI5nmrksHi8UpLHIQ.png)

这就是字符串处理库的存在价值。这些库会让字符串操作变得简单，并且对所有情况都考虑周全，而你只需要简单地调用一个方法。

下面我们来看一些 JavaScript 的字符串操作库。

## 1. String.js

`string.js`，或简称为 `S`，是一个轻量的（可压缩至 **5kb 以下**）JavaScript 库，为浏览器或 Node.js 提供额外的 String 方法。

#### 安装

```bash
npm i string
```

#### 有趣的方法

* between(left, right) — 提取 `left` 和 `right` 之间的字符串。

这能获取两个 HTML 标签之间的元素。

```js
var S = require('string');
S('<a>This is a link</a>').between('<a>', '</a>').s
// 'This is a link'
```

* camelize() — 删除所有下划线或者连接符，并转化为驼峰格式。

此方法可解决本文开头提到的问题。

```js
var S = require('string');
S('---Foo---bAr---').camelize().s;
//'fooBar'
```

* humanize() — 将输入转换为人性化的形式。

从零开始实现此方法，肯定需要很多行代码。

```js
var S = require('string');
S('   capitalize dash-CamelCase_underscore trim  ').humanize().s
//'Capitalize dash camel case underscore trim'
```

* stripPunctuation() — 删除目标字符串的所有符号。

如果从零开始实现此方法，很大可能会漏掉某个符号。

```js
var S = require('string');
S('My, st[ring] *full* of %punct)').stripPunctuation().s;
//My string full of punct
```

[在这里](https://github.com/jprichardson/string.js)查看更多的方法。

## 2. Voca

Voca 是一个处理字符串的 JavaScript 库。Voca 提供有用的方法来让你舒适地操作字符串：**大小写转换、修剪、填充、Slugify、拉丁化、格式化、截短、转义**等等。它的**模块化设计**允许你加载整个库，或者只加载某个方法，以构建最小化的应用。该库**经过充分的测试**，**拥有良好的文档**并且**提供长期的支持**。

#### 安装

```bash
npm i voca
```

#### 有趣的方法

* Camel Case(String data)

将字符串数据转换为驼峰格式。

```js
var v = require('voca');
v.camelCase('foo Bar');
// => 'fooBar'

v.camelCase('FooBar');
// => 'fooBar'

v.camelCase('---Foo---bAr---');
// => 'fooBar'
```

* Latinise(String data)

通过删除变音字符，拉丁化 `data`。

```js
var v = require('voca');
v.latinise('cafe\u0301'); // or 'café'
// => 'cafe'

v.latinise('août décembre');
// => 'aout decembre'

v.latinise('как прекрасен этот мир');
// => 'kak prekrasen etot mir'
```

* isAlphaDigit(String data)

检查 `data` 是否仅包含字母和数字字符（Alphanumeric）。

```js
var v = require('voca');
v.isAlphaDigit('year2020');
// => true

v.isAlphaDigit('1448');
// => true

v.isAlphaDigit('40-20');
// => false
```

* CountWords(String data)

计算 `data` 中的单词数量。

```js
var v = require('voca');
v.countWords('gravity can cross dimensions');
// => 4

v.countWords('GravityCanCrossDimensions');
// => 4

v.countWords('Gravity - can cross dimensions!');
// => 4
```

* EscapeRegExp(String data)

转义 `data` 中正则表达式的特殊字符 —— `[ ] / { } ( ) * + ? . \ ^ $`。

```js
var v = require('voca');
v.escapeRegExp('(hours)[minutes]{seconds}');
// => '\(hours\)\[minutes\]\{seconds\}'
```

[在这里](https://vocajs.com/#)你可以查到更多的信息。

## 3. Anchorme.js

这是个轻量并快速的 Javascript 库，帮助我们检测文本中的链接、网址、电邮地址，并将它们转化为可点击的 HTML 锚点链接。

* 高敏感，低误报。
* 根据完整的 IANA 列表验证网址和电邮地址。
* 验证端口号（如果有）。
* 验证八位 IP 数字（如果有）。
* 适用于非拉丁字母的地址。

#### 安装

```bash
npm i anchorme
```

#### 用法

```js
import anchorme from "anchorme";
//或者
//var anchorme = require("anchorme").default;

const input = "some text with a link.com";
const resultA = anchorme(input);
//some text with a <a href="http://link.com">link.com</a>
```

你可以传入额外的参数，进一步自定义功能。

## 4. Underscore String

[Underscore.string](https://github.com/epeli/underscore.string) 是 JavaScript 字符串操作扩展库，有无 Underscore.js 你都可以使用它。Underscore.string 受到 [Prototype.js](http://api.prototypejs.org/language/String/)，[Right.js](http://rightjs.org/docs/string) 和 [Underscore](http://documentcloud.github.com/underscore/) 启发，是一个能让你舒适操作字符串的 JavaScript 库。

Underscore.string 提供了一些有用的方法：首字母大写、清除、包含、计数、转义 HTML、反转义 HTML、插入、拼接、头部检查、尾部检查、标题化、修剪、截短等等。

#### 安装

```bash
npm install underscore.string
```

#### 有趣的方法

* numberFormat(number) —— 格式化数字

将数字格式化为带小数点并按序分离的字符串。

```js
var _ = require("underscore.string");

_.numberFormat(1000, 3)
=> "1,000.000"

_.numberFormat(123456789.123, 5, '.', ',');
=> "123,456,789.12300"
```

* levenshtein(string1,string2) — 计算两个字符串之间的 Levenshtein。

[在这里](https://dzone.com/articles/the-levenshtein-algorithm-1)了解更多关于 Levenshtein 距离算法的信息。

```js
var _ = require("underscore.string");

_.levenshtein('kitten', 'kittah');
=> 2
```

* chop(string, step) — 将字符串分块。

```js
var _ = require("underscore.string");

_.chop('whitespace', 3);
=> ['whi','tes','pac','e']
```

[在这里](http://gabceb.github.io/underscore.string.site/#chop)了解更多关于 Underscore.String 的信息。

## 5. Stringz

该库的亮点是支持 Unicode（统一码、万国码、单一码）。如果运行以下代码，则输出为 2。

```js
"🤔".length
// -> 2
```

这是因为 String.length() 返回的是字符串的字节数量，而非字符数量。实际上，在 **010000–03FFFF** 至 **040000–10FFFF** 范围内的字符，每个需要使用 4 个字节（32 位），但这也改变不了答案：有些字符需要 2 个以上的字节来表示，因此，一个字符需要的字节数不止 1 个。

[在这里](https://mathiasbynens.be/notes/javascript-unicode)可以阅读更多关于 JavaScript Unicode 问题。

#### 安装

```js
npm install stringz
```

#### 有趣的方法

* limit(string, limit, padString, padPosition)

限制字符串长度。

```js
const stringz = require('stringz');

// 截短:
stringz.limit('Life’s like a box of chocolates.', 20);
// "Life's like a box of"

// 填充:
stringz.limit('Everybody loves emojis!', 26, '💩');
// "Everybody loves emojis!💩💩💩"
stringz.limit('What are you looking at?', 30, '+', 'left');
// "++++++What are you looking at?"

// 支持 Unicode:
stringz.limit('🤔🤔🤔', 2);
// "🤔🤔"
stringz.limit('👍🏽👍🏽', 4, '👍🏽');
// "👍🏽👍🏽👍🏽👍🏽"
```

* toArray(string)

将字符串转换为数组

```js
const stringz = require('stringz');

stringz.toArray('abc');
// ['a','b','c']

// 支持 Unicode:
stringz.toArray('👍🏽🍆🌮');
// ['👍🏽', '🍆', '🌮']
```

[在这里](https://github.com/sallar/stringz)访问 Stringz 的 Github 了解更多

---

如果您有任何建议或意见，请在评论中告诉我。

**相关资源：**
[Stringjs](https://www.javascripting.com/view/string-js)
[Voca](https://vocajs.com/)
[Stringz](https://github.com/sallar/stringz)
[Underscore String](http://gabceb.github.io/underscore.string.site/)
[Anchorme](https://github.com/alexcorvi/anchorme.js)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
