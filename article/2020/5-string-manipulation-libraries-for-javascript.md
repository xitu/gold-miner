> * 原文地址：[5 String Manipulation Libraries for JavaScript](https://blog.bitsrc.io/5-string-manipulation-libraries-for-javascript-5de27e48ee62)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-string-manipulation-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-string-manipulation-libraries-for-javascript.md)
> * 译者：
> * 校对者：

# 5 String Manipulation Libraries for JavaScript

#### Handle Case Conversions, Removing Diacritic Characters, Unicode Handling, Url Handling and More

![](https://cdn-images-1.medium.com/max/2560/1*pdPTFvogzT9vzmc7k-qY2Q.jpeg)

Working with strings can be a cumbersome task as there are many different use cases. For example, a simple task like converting a string to camel case can require several lines of code to achieve the end goal.

```
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

#### Making Your Own Reusable String Manipulation Components

If you’ve found something useful, try to wrap it as a component of your framework of choice (React, Vue, Angular, etc.). This way, you’d have a reusable component with a declarative API, always ready to be used.

You can publish it to a cloud component hub, like [**Bit.dev**](https://bit.dev/), with documentation and code examples. Once published, you can keep updating it from whatever project using it and of course, share it with your team.

![Exploring published React components in [Bit.dev](https://bit.dev/)](https://cdn-images-1.medium.com/max/2000/0*XauNZ51FpyhblC6k.gif)

---

## 1. String.js

`string.js`, or simply `S` is a lightweight (**\< 5 kb** minified and gzipped) JavaScript library for the browser or for Node.js that provides extra String methods.

#### Installation

```
npm i string
```

#### Notable Methods

* between(left, right) — Extracts a string between `left` and `right` strings

This can be used when trying to get the elements between two tags in HTML.

```
var S = require('string');
S('<a>This is a link</a>').between('<a>', '</a>').s 
// 'This is a link'
```

* camelize() — Remove any underscores or dashes and convert a string into camel casing.

This function can be used to solve the problem mentioned at the beginning of this article.

```
var S = require('string');
S('---Foo---bAr---').camelize().s; 
//'fooBar'
```

* humanize() — Transforms the input into a human-friendly form.

This function implemented from scratch would definitely require quite a number of lines of code.

```
var S = require('string');
S('   capitalize dash-CamelCase_underscore trim  ').humanize().s //'Capitalize dash camel case underscore trim'
```

* stripPunctuation() — Strip all of the punctuation in the given string.

If you implement this function from scratch, there is a high chance that you might miss a punctuation.

```
var S = require('string');
S('My, st[ring] *full* of %punct)').stripPunctuation().s; 
//My string full of punct
```

You can check out more methods over [here](https://github.com/jprichardson/string.js).

---

## 2. Voca

Voca is a JavaScript library for manipulating strings. The Voca library offers helpful functions to make string manipulations comfortable: **change case, trim, pad, slugify, latinise, sprintf’y, truncate, escape** and much more. The **modular design** allows to load the entire library, or individual functions to minimize the application builds. The library is **fully tested**, **well documented** and **long-term supported**.

#### Installation

```
npm i voca
```

#### Notable Methods

* Camel Case(String data)

Converts the data to camel case.

```
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

```
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

```
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

```
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

```
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

#### Installation

```
npm i anchorme
```

#### Usage

```
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

#### Installation

```
npm install underscore.string
```

#### Notable Methods

* numberFormat(number) —Formats the numbers

Format numbers into strings with decimal and order separation.

```
var _ = require("underscore.string");

_.numberFormat(1000, 3)
=> "1,000.000"

_.numberFormat(123456789.123, 5, '.', ',');
=> "123,456,789.12300"
```

* levenshtein(string1,string2) — Calculates Levenshtein distance between two strings.

Learn more about the levenshtein distance algorithm [here](https://dzone.com/articles/the-levenshtein-algorithm-1).

```
var _ = require("underscore.string");

_.levenshtein('kitten', 'kittah');
=> 2
```

* chop(string, step) — chops the given string into pieces

```
var _ = require("underscore.string");

_.chop('whitespace', 3);
=> ['whi','tes','pac','e']
```

Learn more about Underscore String over [here](http://gabceb.github.io/underscore.string.site/#chop).

## 5. Stringz

The main highlight of this library is that it is unicode aware. If you run this below code, the output will be 2.

```
"🤔".length
// -> 2
```

This is because String.length() returns the number of code units in the string, not the number of characters. Actually some chars, in the range **010000–03FFFF** and **040000–10FFFF** can use up to 4 bytes (32 bits) per code point, but this doesn’t change the answer: some chars require more than 2 bytes to be represented, so they need more than 1 code point.

You can read more about the JavaScript unicode problem [here](https://mathiasbynens.be/notes/javascript-unicode).

#### Installation

```
npm install stringz
```

#### Notable Methods

* limit(string, limit, padString, padPosition)

Limit the string to a given width.

```
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

```
const stringz = require('stringz');

stringz.toArray('abc');
// ['a','b','c']

//Unicode aware
stringz.toArray('👍🏽🍆🌮');
// ['👍🏽', '🍆', '🌮']
```

To know more about Stringz, visit their Github [here](https://github.com/sallar/stringz).

---

If you have any suggestions or comments, kindly let me know in the comments.

**Resources
**[Stringjs](https://www.javascripting.com/view/string-js)
[Voca](https://vocajs.com/)
[Stringz](https://github.com/sallar/stringz)
[Underscore String](http://gabceb.github.io/underscore.string.site/)
[Anchorme](https://github.com/alexcorvi/anchorme.js)

## Learn More
[**Tools for Consistent JavaScript Code Style**
**Tools and methodologies that will help you maintain consistency in your JavaScript code style.**blog.bitsrc.io](https://blog.bitsrc.io/tools-for-consistent-javascript-code-style-56a6e93d75d)
[**13 Top Serverless Solutions for 2020**
**Best serverless solutions for different categories.**blog.bitsrc.io](https://blog.bitsrc.io/13-top-serverless-solutions-for-2020-c84157f8c9d7)
[**10 Top Javascript Libraries and Tools for an Awesome UI/UX**
**Recommended tools and libraries that will help you build a stunning web app in 2020**blog.bitsrc.io](https://blog.bitsrc.io/10-top-javascript-libraries-and-tools-for-an-awesome-ui-ux-828a314752cc)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
