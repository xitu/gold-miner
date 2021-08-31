> * 原文地址：[5 String Manipulation Libraries for JavaScript](https://blog.bitsrc.io/5-string-manipulation-libraries-for-javascript-9ca5da8b4eb8)
> * 原文作者：[Mike Chen](https://medium.com/@gitgit6)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-string-manipulation-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-string-manipulation-libraries-for-javascript.md)
> * 译者：
> * 校对者：

# 5 String Manipulation Libraries for JavaScript

![](https://cdn-images-1.medium.com/max/2560/1*pdPTFvogzT9vzmc7k-qY2Q.jpeg)

Working with strings can be a cumbersome task as there are many different use cases. For example, a simple task like converting a string to camel case can require several lines of code to achieve the end goal.

```js
function camelize(str) {
  return str.replace(/(?:^\w|[A-Z]|\b\w|\s+)/g, function(match, index) {
    if (+match === 0) return ""; // or if (/\s+/.test(match)) for white spaces
    return index === 0 ? match.toLowerCase() : match.toUpperCase();
  });
}
```

The above code snippet is the most voted answer in StackOverflow. But that too fails to address cases where the string is `---Foo---bAr---` .

![](https://cdn-images-1.medium.com/max/2000/1*B2BkvkI5nmrksHi8UpLHIQ.png)

This is where string manipulation libraries come to the rescue. They make it easy to implement complex string manipulations and also consider all possible use cases for a given problem. This helps on your end as you simply need to call a single method to get a working solution.

Let’s look at a few string manipulation libraries for JavaScript.

## 1. String.js

`string.js`, or simply `S` is a lightweight (**\< 5 kb** minified and gzipped) JavaScript library for the browser or for Node.js that provides extra String methods.

### Installation

```bash
npm i string
```

### Notable Methods

* between(left, right) — Extracts a string between `left` and `right` strings

This can be used when trying to get the elements between two tags in HTML.

```js
var S = require('string');
S('<a>This is a link</a>').between('<a>', '</a>').s 
// 'This is a link'
```

* camelize() — Remove any underscores or dashes and convert a string into camel casing.

This function can be used to solve the problem mentioned at the beginning of this article.

```js
var S = require('string');
S('---Foo---bAr---').camelize().s; 
//'fooBar'
```

* humanize() — Transforms the input into a human-friendly form.

This function implemented from scratch would definitely require quite a number of lines of code.

```js
var S = require('string');
S('   capitalize dash-CamelCase_underscore trim  ').humanize().s //'Capitalize dash camel case underscore trim'
```

* stripPunctuation() — Strip all of the punctuation in the given string.

If you implement this function from scratch, there is a high chance that you might miss a punctuation.

```js
var S = require('string');
S('My, st[ring] *full* of %punct)').stripPunctuation().s; 
//My string full of punct
```

You can check out more methods over [here](https://github.com/jprichardson/string.js).

## 2. Voca

Voca is a JavaScript string manipulation library. **Change case**, **trim**, **pad**, **slugify**, **latinise**, **sprintf’y**, **truncate**, **escape** and other useful string manipulation methods are available in the Voca library. To reduce application builds, the **modular design** allows you to load the complete library or specific functions. The library has been **completely tested**, is **well documented**, and provides **long-term support**.

### Installation

```bash
npm i voca
```

### Notable Methods

* Camel Case(String data)

Converts the data to camel case.

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

Latinises the `data` by removing diacritic characters.

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

Checks whether `data` contains only alpha and digit characters. (Alphanumeric)

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

Counts the number of words in the `data`.

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

Escapes the regular expression special characters - [ ] / { } ( ) * + ? . \ ^ $ | in `data`.

```js
var v = require('voca');
v.escapeRegExp('(hours)[minutes]{seconds}');
// => '\(hours\)\[minutes\]\{seconds\}'
```

You can check out more over [here](https://vocajs.com/#).

## 3. Anchorme.js

This is a tiny, fast Javascript library that helps detect links / URLs / Emails in text and convert them to clickable HTML anchor links.

* It’s Highly sensitive with the least false positives.
* It validates URLs and Emails against full IANA list.
* Validates port numbers (if present).
* Validates IP octet numbers (if present).
* Works on nonlatin alphabets URLs.

### Installation

```bash
npm i anchorme
```

### Usage

```js
import anchorme from "anchorme"; 
//or 
//var anchorme = require("anchorme").default;

const input = "some text with a link.com"; 
const resultA = anchorme(input);
//some text with a <a href="http://link.com">link.com</a>
```

You can pass in additional extensions to customize the function further.

## 4. Underscore String

[Underscore.string](https://github.com/epeli/underscore.string) is string manipulation extension for JavaScript that you can use with or without Underscore.js. Underscore.string is a JavaScript library for comfortable manipulation with strings, an extension for Underscore.js inspired by [Prototype.js](http://api.prototypejs.org/language/String/), [Right.js](http://rightjs.org/docs/string), and [Underscore](http://documentcloud.github.com/underscore/).

Underscore.string provides you several useful functions: capitalize, clean, includes, count, escapeHTML, unescapeHTML, insert, splice, startsWith, endsWith, titleize, trim, truncate and so on.

### Installation

```bash
npm install underscore.string
```

### Notable Methods

* numberFormat(number) — Formats the numbers

Format numbers into strings with decimal and order separation.

```js
var _ = require("underscore.string");

_.numberFormat(1000, 3)
=> "1,000.000"

_.numberFormat(123456789.123, 5, '.', ',');
=> "123,456,789.12300"
```

* levenshtein(string1,string2) — Calculates Levenshtein distance between two strings.

Learn more about the levenshtein distance algorithm [here](https://dzone.com/articles/the-levenshtein-algorithm-1).

```js
var _ = require("underscore.string");

_.levenshtein('kitten', 'kittah');
=> 2
```

* chop(string, step) — chops the given string into pieces

```js
_.chop('whitespace', 3);
=> ['whi','tes','pac','e']
```

Learn more about Underscore String over [here](http://gabceb.github.io/underscore.string.site/#chop).

## 5. Stringz

The main highlight of this library is that it is unicode aware. If you run this below code, the output will be 2.

```js
"🤔".length
// -> 2
```

This is because String.length() returns the number of code units in the string, not the number of characters. Actually some chars, in the range **010000–03FFFF** and **040000–10FFFF** can use up to 4 bytes (32 bits) per code point, but this doesn’t change the answer: some chars require more than 2 bytes to be represented, so they need more than 1 code point.

You can read more about the JavaScript unicode problem [here](https://mathiasbynens.be/notes/javascript-unicode).

### Installation

```bash
npm install stringz
```

### Notable Methods

* limit(string, limit, padString, padPosition)

Limit the string to a given width.

```js
const stringz = require('stringz');

// Truncate:
stringz.limit('Life’s like a box of chocolates.', 20); 
// "Life's like a box of"

// Pad:
stringz.limit('Everybody loves emojis!', 26, '💩'); 
// "Everybody loves emojis!💩💩💩"
stringz.limit('What are you looking at?', 30, '+', 'left'); 
// "++++++What are you looking at?"

// Unicode Aware:
stringz.limit('🤔🤔🤔', 2); 
// "🤔🤔"
stringz.limit('👍🏽👍🏽', 4, '👍🏽'); 
// "👍🏽👍🏽👍🏽👍🏽"
```

* toArray(string)

Convert the string to an Array

```js
const stringz = require('stringz');

stringz.toArray('abc');
// ['a','b','c']

//Unicode aware
stringz.toArray('👍🏽🍆🌮');
// ['👍🏽', '🍆', '🌮']
```

To know more about Stringz, visit their Github [here](https://github.com/sallar/stringz).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
