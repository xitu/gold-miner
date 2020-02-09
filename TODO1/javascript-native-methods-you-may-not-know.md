> * 原文地址：[JavaScript Native Methods You May Not Know](https://medium.com/better-programming/javascript-native-methods-you-may-not-know-ccc4b8aa5cfd)
> * 原文作者：[Moon](https://medium.com/@moonformeli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-native-methods-you-may-not-know.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-native-methods-you-may-not-know.md)
> * 译者：
> * 校对者：

# JavaScript Native Methods You May Not Know

#### Powerful but often overlooked native methods in JavaScript

![](https://cdn-images-1.medium.com/max/2000/1*v0O86GFV7H15ol_r9xwNPA.jpeg)

Since ES6's release, many new, comfy, and handy native methods have been added into the new standard of JavaScript.

Yet, I’ve seen many old codes from GitHub repositories. It doesn’t necessarily mean they’re bad — but these features I’m going to introduce to you will help your code be more readable and prettier.

---

## Number.isNaN vs. isNaN

`NaN` is a number type.

```js
typeof NaN === 'number'
```

So you can’t distinguish `NaN` and numbers.

Even Object.prototype.toString.call returns `[object Number]` for both `NaN` and numbers. You might have known there’s the `isNaN` method to check if the parameter is `NaN`. But since ES6, the `number` constructor has started to include `isNaN` as its method. Then what’s different?

* `isNaN` — checks whether the passed value isn’t a number or can’t be converted into a number.
* `Number.isNaN` — checks whether the passed value isn’t a number.

Here’s the example. And this topic was already dealt with by people at [Stack Overflow](https://stackoverflow.com/questions/33164725/confusion-between-isnan-and-number-isnan-in-javascript).

```js
Number.isNaN({});
// <- false, {} is not NaN
Number.isNaN('ponyfoo')
// <- false, 'ponyfoo' is not NaN
Number.isNaN(NaN)
// <- true, NaN is NaN
Number.isNaN('pony'/'foo')
// <- true, 'pony'/'foo' is NaN, NaN is NaN

isNaN({});
// <- true, {} is not a number
isNaN('ponyfoo')
// <- true, 'ponyfoo' is not a number
isNaN(NaN)
// <- true, NaN is not a number
isNaN('pony'/'foo')
// <- true, 'pony'/'foo' is NaN, NaN is not a number
```

---

## Number.isFinite vs. isFinite

In JavaScript, calculations such as 1/0 don’t create an error. Instead, it gives you `Infinit` , which is a global property.

Then, how can you check if a value is an infinite value? You can’t. But you can check if a value is a finite value with `isFinite` and `Number.isFinite`.

Basically how they work is the same, but they’re slightly different from each other.

* `isFinite` — checks if the passed value is finite. The passed value is converted to `Number` if its type isn’t `Number`.
* `Number.isFinite` — checks if the passed value is finite. The passed value isn’t converted to `Number`.

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

## Math.floor vs. Math.trunc

In the past, when you needed to take out the digits on the right side of the dot of a number value, you probably used to use `Math.floor`. But from now on, try to use `Math.trunc` if what you really want is the integer part only.

* `Math.floor` — returns the largest integer less than or equal to a given number.
* `Math.trunc` — truncates the dot and the digits to the right of it.

Basically, they give you exactly the same result if a given number is positive. But the results are different if a given number is negative.

```js
Math.floor(1.23) // 1
Math.trunc(1.23) // 1

Math.floor(-5.3) // -6
Math.trunc(-5.3) // -5

Math.floor(-0.1) // -1
Math.trunc(-0.1) // -0
```

---

## Array.prototype.indexOf vs. Array.prototype.includes

When you’re looking for some value in a given array, how do you find it? I’ve seen many developers use `Array.prototype.indexOf`, like in the following example.

```js
const arr = [1, 2, 3, 4];

if (arr.indexOf(1) > -1) {
  ...
}
```

* `Array.prototype.indexOf` — returns the first index at which a given element can be found in the array or `-1` if it’s not present
* `Array.prototype.includes `— checks if a given array includes a particular value you’re looking for and returns `true`/`false` as the result

```js
const students = ['Hong', 'James', 'Mark', 'James'];

students.indexOf('Mark') // 1
students.includes('James') // true

students.indexOf('Sam') // -1
students.includes('Sam') // false
```

Be careful. The passed value is case-sensitive because of the Unicode differences.

---

## String.prototype.repeat vs. for Loop Manually

Before this feature was added, the way you made strings, such as `abcabcabc`, was to copy the strings and concatenate them to an empty string for however many times you wanted.

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

But this is so unnecessarily long, quite messy, and hard to read sometimes. For this purpose, you can use `String.prototype.repeat`. All you need to do is pass the number that refers to how many times you want to copy the strings.

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

The passed value must not be negative and must be less than infinity and not the overflow maximum string size.

---

## String.prototype.match vs. String.prototype.includes

To check if certain words are included in the strings, there are two ways to do it — `match` and `includes`.

* `String.prototype.match` — takes a parameter that is a RegExp type. All the flags that are supportive in RegExp are able to be used.
* `String.prototype.includes` — takes two parameters, `searchString` as the first parameter and `position` as the second one. If `position` isn’t passed, the default value `0` will be used.

The difference is that `includes` is case-sensitive, while `match` isn’t. You can put the `i` flag in the RegExp to make it perform as case-insensitive.

```js
const name = 'jane';
const nameReg = /jane/i;

const str = 'Jane is a student';

str.includes(name) // false
str.match(nameReg) 
// ["Jane", index: 0, input: "Jane is a student", groups: undefined]
```

---

## String.prototype.concat vs. String.prototype.padStart

`padStart` is a powerful method when you want to append some strings at the beginning of some strings.

Also, `concat` can perform this as well nicely. But the main difference is `padStart` repeats the strings that’ll be padded from the first index of the result string to the first index of the current string.

I’ll show you how to use this function.

```js
const rep = 'abc';
const str = 'xyz';
```

Here are two strings. What I want to do isadd `rep` in front of `xyz `— but not only one time. I want it to be repeated several times.

```js
str.padStart(10, rep);
```

`padStart` takes two parameters — the total length for the newly created result string and the strings that’ll be repeated. The easiest way to understand this function is to write down the letters with blanks.

```
// create empty 10 blanks
1) _ _ _ _ _ _ _ _ _ _ 

// fill out 'xyz' in str
2) _ _ _ _ _ _ _ x y z

// repeat 'abc' in rep, 
// up until the first letter of 'xyz' appears
3) a b c a b c a x y z

// the result will be
4) abcabcxyz
```

This function is very useful for this feature, and it’s definitely hard to do this with `concat`, which also performs a string append.

`padEnd` starts at the end of the position.

---

## Conclusion

There are many fun and useful methods in JavaScript that aren’t widely common. But it doesn’t mean they’re useless. It’s all up to you how to use them in each situation.

#### Resources

* [Confusion Between isNaN and Number.isNaN in JavaScript](https://stackoverflow.com/questions/33164725/confusion-between-isnan-and-number-isnan-in-javascript)
* [Number.isFinite — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isFinite)
* [isFinite — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/isFinite)
* [Math.trunc — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/trunc)
* [Math.floor — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/floor)
* [Array.prototype.indexOf — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/indexOf)
* [Array.prototype.includes — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes)
* [String.prototype.repeat — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/repeat)
* [String.prototype.math — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match)
* [String.prototype.includes — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/includes)
* [String.prototype.padStart — MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padStart)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
