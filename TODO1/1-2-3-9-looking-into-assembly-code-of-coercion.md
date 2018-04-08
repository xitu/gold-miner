> * 原文地址：[[1] + [2] - [3] === 9!? Looking into assembly code of coercion](https://wanago.io/2018/04/02/1-2-3-9-looking-into-assembly-code-of-coercion/)
> * 原文作者：[wanago.io](https://wanago.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/1-2-3-9-looking-into-assembly-code-of-coercion.md](https://github.com/xitu/gold-miner/blob/master/TODO1/1-2-3-9-looking-into-assembly-code-of-coercion.md)
> * 译者：
> * 校对者：

# [1] + [2] - [3] === 9!? Looking into assembly code of coercion

Variable values have certain types. In fact, you can cast a value of one type to the other. If you do it explicitly, it is **type casting** (also called explicit coercion). If it happens in the background when you are trying to perform an operation on types that do not match, it is called **coercion** (sometimes referred to as implicit coercion). In this article, I will walk you through both, so that you can better understand the process. Let’s dig in!

## Type casting

### Primitive types wrappers

As I described in [one of my previous articles](https://wanago.io/2018/02/12/cloning-objects-in-javascript-looking-under-the-hood-of-reference-and-primitive-types/), almost all primitive types in JavaScript (besides **null** and **undefined**) have object wrappers around their native value. In fact, you have access to their constructors. You can use that knowledge to convert the type of one value to another.

```
String(123); // '123'
Boolean(123); // true
Number('123'); // 123
Number(true); // 1
```

> The wrapper for that particular variable of primitive type is not kept for long though: as soon as the work is done, it is gone.

You need to watch out for that because if you use a new keyword there, this is not the case.

```
const bool = new Boolean(false);
bool.propertyName = 'propertyValue';
bool.valueOf(); // false

if (bool) {
  console.log(bool.propertyName); // 'propertyValue'
}
```

Since bool is a new object here (not a primitive value), it evaluates to true.

I will even go a little further and tell you that

```
if (1) {
  console.log(true);
}
```

is actually the same as doing

```
if ( Boolean(1) ) {
  console.log(true);
}
```

Don’t believe me, try it yourself! Bear with me, I will use **Bash** here.

1. Compile the code into the assembly using node.js

```
$ node --print-code ./if1.js >> ./if1.asm
```

```
$ node --print-code ./if2.js >> ./if2.asm
```

2. Prepare a script to compare the 4th column (assembly operands) – I intentionally skip memory addresses here, because they might differ.

```
#!/bin/bash

file1=$(awk '{ print $4 }' ./if1.asm)
file2=$(awk '{ print $4 }' ./if2.asm)

[ "$file1" == "$file2" ] && echo "The files match"
```

3. Run it

```
"The files match"
```

### parseFloat

This function works similar to **Number** constructor but is less strict when it comes to the argument passed. If it encounters a character that can’t be a part of the number it returns a value up to that point and ignores the rest of characters.

```
Number('123a45'); // NaN
parseFloat('123a45'); // 123
```


### parseInt

It rounds the number down while parsing it. It can work with different radixes.

```
parseInt('1111', 2); // 15
parseInt('0xF'); // 15

parseFloat('0xF'); // 0
```

Function parseInt can either guess the radix or have it passed as a second argument. For a list of rules it takes into consideration, check out [MDN web docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt).

It has troubles with very big numbers, so it should not be considered an alternative to [**Math.floor**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/floor) (which will also do a typecast):

```
parseInt('1.261e7'); // 1
Number('1.261e7'); // 12610000
Math.floor('1.261e7') // 12610000

Math.floor(true) // 1
```

### toString

You can convert values to strings using a **toString** function. Implementation of this function differs between prototypes.

> If you feel like you’d like to grasp the concept of the prototype better first, feel free to check out my other article: [Prototype. The big bro behind ES6 class](https://wanago.io/2018/03/19/prototype-the-big-bro-behind-es6-class/).

#### String.prototype.toString

returns a value of a string

```
const dogName = 'Fluffy';

dogName.toString() // 'Fluffy'
String.prototype.toString.call('Fluffy') // 'Fluffy'

String.prototype.toString.call({}) // Uncaught TypeError: String.prototype.toString requires that 'this' be a String
```

#### Number.prototype.toString

returns a number converted to String (you can pass appendix as a first argument)

```
(15).toString(); // "15"
(15).toString(2); // "1111"
(-15).toString(2); // "-1111"
```

#### Symbol.prototype.toString

returns  `Symbol(${description})`

> If you are lost here: I’m using a concept of [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) as a way to explain for you how the output strings look.

#### Boolean.prototype.toString

returns “true” or “false”

#### Object.prototype.toString

Objects have internal value called **[[Class]]**. It is a tag that represents the type of an object.

**Object.prototype.toString** returns a string `[object ${tag}]` . Either it is one of the built-in tags (for example “Array”, “String”, “Object”, “Date”), or it is set explicitly.

```
const dogName = 'Fluffy';

dogName.toString(); // 'Fluffy' (String.prototype.toString called here)
Object.prototype.toString.call(dogName); // '[object String]'
```

With the introduction of ES6, setting tags is done with the usage of [**Symbols**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol).

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

You can also use ES6 class with a getter here:

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

#### Array.prototype.toString

calls **toString** on every element and returns a string with all the outputs separated by commas.

```
const arr = [
  {},
  2,
  3
]

arr.toString() // "[object Object],2,3"
```

## Coercion

If you have a knowledge of how type casting works, it will be a lot easier for you to understand coercion.

## Mathematical operators

### Plus sign

Expression with two operands and with  `+`  that involves a string will result in a string.

```
'2' + 2 // 22
15 + '' // '15'
```

You can use it with one operand to cast it to a number:

```
+'12' // 12
```

### Other mathematical operators

With other mathematical operators such as `-` or `/` operands will always be cast to numbers.

```
new Date('04-02-2018') - '1' // 1522619999999
'12' / '6' // 2
-'1' // -1
```

Date, cast to a number gives a [Unix timestamp](https://en.wikipedia.org/wiki/Unix_time).

## Exclamation mark

Using it will output true if the original value is falsy, and false if it is truthy. Therefore, it can be used to cast the value to corresponding boolean if used twice.

```
!1 // false
!!({}) // true
```

## ToInt32 with bitwise OR

It is worth mentioning, even though ToInt32 is, in fact, an abstract operation (internal-only, not callable). It will cast a value to a [signed 32-bit integer](https://en.wikipedia.org/wiki/32-bit).

```
0 | true          // 1
0 | '123'         // 123
0 | '2147483647'  // 2147483647
0 | '2147483648'  // -2147483648 (too big)
0 | '-2147483648' // -2147483648
0 | '-2147483649' // 2147483647 (too small)
0 | Infinity      // 0
```

Performing a bitwise OR operation when one of the operands is 0 will result in not changing the value of the other operand.

### Other cases of coercion

While coding, you may encounter more situations in which values will be coerced. Consider this example:

```
const foo = {};
const bar = {};
const x = {};

x[foo] = 'foo';
x[bar] = 'bar';

console.log(x[foo]); // "bar"
```

This happens because both foo and bar, when cast to strings, result in `"[object Object]"`. What really happens is this:

```
x[bar.toString()] = 'bar';
x["[object Object]"]; // "bar"
```

Coercing also happens with [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals). Try overriding **toString** function here:

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

Coercion is also a reason why **abstract equality comparison** (==) might be considered a bad practice since it is attempting to coerce values if their types don’t match.

Check out this example for an interesting fact about the comparison:

```
const foo = new String('foo');
const foo2 = new String('foo');

foo === foo2 // false
foo >= foo2 // true
```

Because we used the **new** keyword here, *foo* and *foo2* both preserved wrappers around their native value (which is *‘foo‘*). Since they are referencing to two different objects now,  `foo === foo2` will result in false. Relational operators ( `>=` here) call the **valueOf** function on both operands. Due to that, the comparison of native values is taking place, and  `'foo' >= 'foo'` evaluates to **true**.

## [1] + [2] – [3] === 9

I hope all that knowledge helped you to demystify the equation from the title of this article. Let’s debunk it anyway!

1. `[1] + [2]` these are cast to strings applying the rules of **Array.prototype.toString** and then concatenated. The result will be `"12"`.
  * `[1,2] + [3,4]` would result in `"1,23,4"`.
2. `12 - [3]` will result in subtracting `"3"` from `12` giving us `9`
  * `12 - [3,4]` would result in **NaN** because `"3,4"` can’t be cast to a number

## Summary

Even though many may advise you to just avoid coercion, I think it is important to understand how it works. It might not be a good idea to rely on it, but it will help you greatly both in debugging your code and avoiding the bugs in the first place.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
