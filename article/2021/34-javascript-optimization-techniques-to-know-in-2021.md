> * 原文地址：[34 JavaScript Optimization Techniques to Know in 2021](https://medium.com/javascript-in-plain-english/34-javascript-optimization-techniques-to-know-in-2021-d561afdf73c3)
> * 原文作者：[atit53](https://atit53.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/34-javascript-optimization-techniques-to-know-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/34-javascript-optimization-techniques-to-know-in-2021.md)
> * 译者：
> * 校对者：

# 34 JavaScript Optimization Techniques to Know in 2021

The life of a developer is always learning new things and keeping up with the changes shouldn’t be harder than it already is, and my motive is to introduce all the JavaScript best practices such as Shorthand and features which we must know as a frontend developer to make our life easier in 2021.

![Image for post](https://miro.medium.com/max/2400/0*K49jVcTGrpgm_5mX.png)

You might be doing JavaScript development for a long time but sometimes you might be not updated with the newest features which can solve your issues without doing or writing some extra codes. These techniques can help you to write clean and optimized JavaScript Code. Moreover, these topics can help you to prepare yourself for JavaScript interviews in 2021.

Here I am coming with a new series to cover **Shorthand techniques** that help you to write more clean and optimized JavaScript Code. This is a **Cheat list for JavaScript** Coding you must know in 2021.

### 1. If with multiple conditions

We can store multiple values in the array and we can use the array includes method.

```js
// Longhand

if (x === 'abc' || x === 'def' || x === 'ghi' || x === 'jkl') {
    // logic
}

// Shorthand

if (['abc', 'def', 'ghi', 'jkl'].includes(x)) {
    // logic
}
```

### 2. If true … else Shorthand

This is a greater short cut for when we have if-else conditions that do not contain bigger logics inside. We can simply use the ternary operators to achieve this Shorthand.

```js
// Longhand
let test: boolean;

if (x > 100) {
    test = true;
} else {
    test = false;
}

// Shorthand
let test = (x > 10) ? true : false;

// or we can use directly
let test = x > 10;

console.log(test);
```

When we have nested conditions we can go this way.

```js
let x = 300,
    test2 = (x > 100) ? 'greater 100' : (x < 50) ? 'less 50' : 'between 50 and 100';

console.log(test2); // "greater than 100"
```

### 3. Declaring variables

When we want to declare the two variables which have the common value or common type we can use this Shorthand.

```js
// Longhand 
let test1;
let test2 = 1;

// Shorthand 
let test1, test2 = 1;
```

### 4. Null, Undefined, Empty Checks

When we do create new variables sometimes we want to check if the variable we are referencing for its value is not null or undefined. JavaScript does have a really good Shorthand to achieve these functions.

```js
// Longhand
if (test1 !== null || test1 !== undefined || test1 !== '') {
    let test2 = test1;
}

// Shorthand
let test2 = test1 || '';
```

### 5. Null Value checks and Assigning Default Value

```js
let test1 = null,
    test2 = test1 || '';

console.log("null check", test2); // output will be ""
```

### 6. Undefined Value checks and Assigning Default Value

```js
let test1 = undefined,
    test2 = test1 || '';

console.log("undefined check", test2); // output will be ""
```

Normal Value checks

```js
let test1 = 'test',
    test2 = test1 || '';

console.log(test2); // output: 'test'
```

(BONUS: Now we can use `??` operator for topic 4, 5 and 6)

### Nullish coalescing Operator

The `**nullish coalescing Operator ??**` is returned the right-hand side value if the left-hand side is null or undefined. By default, it will return the left-side value.

```js
const test = null ?? 'default';
console.log(test);
// expected output: "default"const test1 = 0 ?? 2;
console.log(test1);
// expected output: 0
```

[**13 Methods To Remove/Filter an Item in an Array (and Array of Objects) in JavaScript**](https://medium.com/javascript-in-plain-english/13-methods-to-remove-filter-an-item-in-an-array-and-array-of-objects-in-javascript-2211216790d5)

### 7. Assigning values to multiple variables

When we are dealing with multiple variables and want to assign different values to the different variables this Shorthand technique is really useful.

```js
// Longhand 
let test1, test2, test3;
test1 = 1;
test2 = 2;
test3 = 3;

// Shorthand 
let [test1, test2, test3] = [1, 2, 3];
```

### 8. Assignment Operators Shorthand

We deal with a lot of arithmetic operators in our programming. This is one of the useful techniques for assignment operators to JavaScript variables.

```js
// Longhand
test1 = test1 + 1;
test2 = test2 - 1;
test3 = test3 * 20;

// Shorthand
test1++;
test2--;
test3 *= 20;
```

**If you are looking for array and object-related tips please check out this article.**

[21 Arrays and Object Tricks in JavaScript/TypeScript](https://medium.com/javascript-in-plain-english/21-arrays-and-object-tricks-in-javascript-typescript-9d41f5f4966c)

### 9. If Presence Shorthand

This is one of the common Shorthand which we all are using but still, it is worth mentioning here.

```js
// Longhand
if (test1 === true) or
if (test1 !== "") or
if (test1 !== null)

// Shorthand //it will check empty string,null and undefined too
if (test1)
```

Note: If test1 has any value it will fall into the logic after the if loop, this operator mostly used for null or undefined checks.

### 10. AND(&&) Operator for Multiple Conditions

If we are calling a function only if the variable is true then we can use && Operator.

```js
// Longhand 
if (test1) {
    callMethod();
}

// Shorthand 
test1 && callMethod();
```

### 11. foreach Loop Shorthand

This is one of the common Shorthand technique for iteration.

```js
// Longhand
for (var i = 0; i < testData.length; i++)

// Shorthand
for (let i in testData) or for (let i of testData)
```

Array for each variable

```js
function testData(element, index, array) {
    console.log('test[' + index + '] = ' + element);
}

[11, 24, 32].forEach(testData);
// logs: test[0] = 11, test[1] = 24, test[2] = 32
```

### 12. Comparison Returns

We can use the comparison in the return statements too. It will avoid our 5 lines of code and reduced them to 1 line.

```js
// Longhand
let test;

function checkReturn() {
    if (!(test === undefined)) {
        return test;
    } else {
        return callMe('test');
    }
}

var data = checkReturn();
console.log(data); //output test

function callMe(val) {
    console.log(val);
}

// Shorthand

function checkReturn() {
    return test || callMe('test');
}
```

### 13. Arrow Function

```js
// Longhand 
function add(a, b) {
    return a + b;
}

// Shorthand 
const add = (a, b) => a + b;
```

More examples.

```js
function callMe(name) {
    console.log('Hello', name);
}

callMe = name => console.log('Hello', name);
```

### 14. Short Function Calling

We can use the ternary operator to achieve these functions.

```js
// Longhand
function test1() {
    console.log('test1');
};

function test2() {
    console.log('test2');
};

var test3 = 1;
if (test3 == 1) {
    test1();
} else {
    test2();
}

// Shorthand
(test3 === 1 ? test1 : test2)();
```

**12 Methods for Finding an Item in an Array (and Array of Objects) in JavaScript**

[12 Methods for Finding an Item in an Array (and Array of Objects) in JavaScript](https://medium.com/javascript-in-plain-english/12-methods-for-finding-an-item-in-an-array-and-array-of-objects-in-javascript-484a1ba66324)

### 15. Switch Shorthands

We can save the conditions in the key-value objects and can be used based on the conditions.

```js
// Longhand
switch (data) {
    case 1:
        test1();
        break;

    case 2:
        test2();
        break;

    case 3:
        test();
        break;
    // And so on...
}

// Shorthand
var data = {
    1: test1,
    2: test2,
    3: test
};

data[something] && data[something]();
```

### 16. Implicit Return Shorthand

With the use of arrow functions, we can return the value directly without having to write a return statement.

```js
// Longhand
function calculate(diameter) {
    return Math.PI * diameter
}

// Shorthand
calculate = diameter => (
    Math.PI * diameter
)
```

### 17. Decimal base exponents

```js
// Longhand
for (var i = 0; i < 10000; i++) {

}

// Shorthand
for (var i = 0; i < 1e4; i++) {

}
```

**If you are looking to Optimize your JavaScript code using modern techniques, tips, and tricks check out this article.**

[42 Tips and Tricks to Write Faster, Better-Optimized JavaScript Code](https://medium.com/javascript-in-plain-english/42-tips-and-tricks-to-write-faster-better-optimized-javascript-code-3a82c53d051e)

### 18. Default Parameter Values

```js
// Longhand

function add(test1, test2) {
    if (test1 === undefined)
        test1 = 1;
    if (test2 === undefined)
        test2 = 2;
    return test1 + test2;
}

// Shorthand

add = (test1 = 1, test2 = 2) => (test1 + test2);

add() //output: 3
```

### 19. Spread Operator Shorthand

```js
// Longhand

// joining arrays using concat
const data = [1, 2, 3];
const test = [4, 5, 6].concat(data);

// Shorthand

// joining arrays
const data = [1, 2, 3];
const test = [4, 5, 6, ...data];
console.log(test); // [ 4, 5, 6, 1, 2, 3]
```

For cloning also we can use a spread operator.

```js
// Longhand

// cloning arrays
const test1 = [1, 2, 3];
const test2 = test1.slice()

// Shorthand

// cloning arrays
const test1 = [1, 2, 3];
const test2 = [...test1];
```

### 20. Template Literals

If you have tired of using + to concatenate multiple variables in a single string then this Shorthand removes your headache.

```js
// Longhand

const welcome = 'Hi ' + test1 + ' ' + test2 + '.'

// Shorthand

const welcome = `Hi ${test1} ${test2}`;
```

**How to Remove Duplicates from an Array or Array of Objects in JavaScript**

[How to Remove Duplicates from an Array or Array of Objects in JavaScript](https://medium.com/javascript-in-plain-english/how-to-remove-duplicates-from-an-array-or-array-of-objects-in-javascript-9ab417cb9667)

### 21. Multi-line String Shorthand

When we are dealing with a multi-line string in code we can go for this function:

```js
// Longhand

const data = 'abc abc abc abc abc abc\n\t'
    + 'test test,test test test test\n\t'

// Shorthand

const data = `abc abc abc abc abc abc
         test test,test test test test`

```

### 22. Object Property Assignment

```js
let test1 = 'a';
let test2 = 'b';

// Longhand 
let obj = {test1: test1, test2: test2};
// Shorthand 
let obj = {test1, test2};
```

**9 Methods for Sorting an Item in an Array (and Array of Objects) in JavaScript**

[9 Methods for Sorting an Item in an Array (and Array of Objects) in JavaScript](https://medium.com/javascript-in-plain-english/9-methods-for-sorting-an-item-in-an-array-and-array-of-objects-in-javascript-8226f5d39590)

### 23. String into a Number

```js
// Longhand 
let test1 = parseInt('123');
let test2 = parseFloat('12.3');

// Shorthand 
let test1 = +'123';
let test2 = +'12.3';
```

### 24. Destructuring Assignment Shorthand

```js
// Longhand

const test1 = this.data.test1;
const test2 = this.data.test2;
const test2 = this.data.test3;

// Shorthand

const {test1, test2, test3} = this.data;
```

### 25. Array.find Shorthand

When we do have an array of objects and we want to find the specific object based on the object properties find method is really useful.

```js
const data = [{
    type: 'test1',
    name: 'abc'
},
    {
        type: 'test2',
        name: 'cde'
    },
    {
        type: 'test1',
        name: 'fgh'
    },
]

function findtest1(name) {
    for (let i = 0; i < data.length; ++i) {
        if (data[i].type === 'test1' && data[i].name === name) {
            return data[i];
        }
    }
}

// Shorthand
filteredData = data.find(data => data.type === 'test1' && data.name === 'fgh');
console.log(filteredData); // { type: 'test1', name: 'fgh' }
```

**How to Handle Multiple Service Calls Inside a Loop**

[How to Handle Multiple Service Calls Inside a Loop](https://medium.com/javascript-in-plain-english/how-to-handle-multiple-service-calls-inside-a-loop-7488f4df2826)

### 26. Lookup Conditions Shorthand

If we have code to check the type and based on the type need to call different methods we either have the option to use multiple else ifs or go for the switch, but what if we have better Shorthand than that?

```js
// Longhand
if (type === 'test1') {
    test1();
} else if (type === 'test2') {
    test2();
} else if (type === 'test3') {
    test3();
} else if (type === 'test4') {
    test4();
} else {
    throw new Error('Invalid value ' + type);
}

// Shorthand
var types = {
    test1: test1,
    test2: test2,
    test3: test3,
    test4: test4
};

var func = types[type];
(!func) && throw new Error('Invalid value ' + type);
func();
```

### 27. Bitwise IndexOf Shorthand

When we are iterating an array to find a specific value we do use **indexOf()** method.What if we find a better approach for that? Let’s check out the example.

```js
// Longhand

if (arr.indexOf(item) > -1) { // item found 

}

if (arr.indexOf(item) === -1) { // item not found

}

// Shorthand

if (~arr.indexOf(item)) { // item found

}

if (!~arr.indexOf(item)) { // item not found

}
```

The `bitwise(~)` the operator will return a truthy value for anything but `-1`. Negating it is as simple as doing `!~`. Alternatively, we can also use the `includes()` function:

```js
if (arr.includes(item)) {
// true if the item found
}
```

**7 Methods for Comparing Arrays in JavaScript**

[7 Methods for Comparing Arrays in JavaScript](https://medium.com/javascript-in-plain-english/7-methods-for-comparing-arrays-in-javascript-88f10c071897)

### 28. Object.entries()

This feature helps to convert the object to an array of objects.

```js
const data = {test1: 'abc', test2: 'cde', test3: 'efg'};
const arr = Object.entries(data);
console.log(arr);

/** Output:
 [ [ 'test1', 'abc' ],
 [ 'test2', 'cde' ],
 [ 'test3', 'efg' ]
 ]
 **/
```

### 29. Object.values()

This is also a new feature introduced in ES8 that performs a similar function to `Object.entries()`, but without the key part:

```js
const data = {test1: 'abc', test2: 'cde'};
const arr = Object.values(data);
console.log(arr);

/** Output:
 [ 'abc', 'cde']
 **/
```

### 30. Double Bitwise Shorthand

**(The double NOT bitwise operator approach only works for 32-bit integers)**

```js
// Longhand  
Math.floor(1.9) === 1 // true

// Shorthand  
~~1.9 === 1 // true
```

### 31. Repeat a string multiple times

To repeat the same characters again and again we can use the for loop and add them in the same loop but what if we have a Shorthand for this?

```js
// Longhand 
let test = '';
for (let i = 0; i < 5; i++) {
    test += 'test ';
}
console.log(str); // test test test test test 
// Shorthand 
'test '.repeat(5);
```

### 32. Find max and min number in the array

```js
const arr = [1, 2, 3];
Math.max(...arr); // 3
Math.min(...arr); // 1
```

### 33. Get character from string

```js
let str = 'abc';
// Longhand 
str.charAt(2); // c
// Shorthand 
// Note: If we know the index of the array then we can directly use index insted of character.If we are not sure about index it can throw undefined
str[2]; // c
```

> Wanna take some rest after too much reading?I have an article to lighten up your mood.

**30 Stress Relievers For Programmers**

[30 Stress Relievers For Programmers](/30-friday-stress-relievers-for-programmers-fbcfede676f7)

### 34. Power Shorthand

Shorthand for a Math exponent power function:

```js
// Longhand

Math.pow(2, 3); // 8

// Shorthand

2 ** 3 // 8
```

> Preparing for Interviews? Need Help?

**22 Utility Functions To Ace Your JavaScript Coding Interview**

[22 Utility Functions To Ace Your JavaScript Coding Interview](https://medium.com/javascript-in-plain-english/22-utility-functions-to-ace-your-javascript-coding-interview-21ca676ad70)

## If you would like to get up to date yourself with the latest features of JavaScript versions check below:

### ES2021/ES12

1. **replaceAll():** *returns a new string with all matches of a pattern replaced by the new replacement word.*
2. **Promise.any():** *It takes an iterable of Promise objects and as one promise fulfills, return a single promise with the value.*
3. **weakref:** *This object holds a weak reference to another object without preventing that object from getting garbage-collected.*
4. **FinalizationRegistry:** *Lets you request a callback when an object is garbage collected.*
5. **Private visibility modifier for methods and accessors:** *Private methods can be declared with #.*
6. **Logical Operators :** *&& and || operators.*
7. **Numeric Separators:** *enables underscore as a separator in numeric literals to improve readability.*
8. **Intl.ListFormat :** *This object enables language-sensitive list formatting.*
9. **Intl.DateTimeFormat :** *This object enables language-sensitive date and time formatting.*

**ES2020/ES11**

10. **BigInt:** *provides a way to represent numbers(whole) larger than 253–1*

11. **Dynamic Import:** *Dynamic imports give the option to import JS files dynamically as modules. It will help you to get modules on demand.*

12. **Nullish coalescing Operator:** *returned the right-hand side value if the left-hand side is null or undefined. By default, it will return the left-side value.*

13. **globalThis:** *contains the global* ***this*** *value, which basically works as a global object.*

14. **Promise.allSettled():** *returns a promise which basically contains the array of objects with the outcome of each promise.*

15. **Optional Chaining:** *read the value with any connected objects or check methods and check if property existing or not.*

16. **String.prototype.matchAll():** *returns an iterator of all results matching a string against the regex.*

17. **Named Export:** *With this feature, we can have multiple named exports per file.*

18. **Well defined for-in order:**

19. **import.meta:** *object exposes context-specific metadata to a JS module*

### ES2019/ES10

20. **Array.flat():** *creates a new array by* `*combining*` *the other arrays in the main array. Note: we can set the depth to combine arrays.*

21. **Array.flatmap:** *creates a new array by applying* `*callback*` *function to each element of the array.*

22. **Object.fromEntries():** *transforms a list of key-value pairs into an* `*object.*`

23. **String.trimStart() & String.trimEnd():** *method removes whitespace from the beginning and end of a string.*

24. **try…catch:** *statement marks a block of statements to try and if any error occurs catch will handle it.*

25. **Function.toString():** *converts any method/code to* `*string*`*.*

26. **Symbol.prototype.description:** *returns optional description of* `***Symbol***` *objects.*

### ES2018/ES9

27. **Asynchronous Iteration:** *With the help of* `***async***` *and* `***await***` *now we can run the series of asynchronous iterations in the for a loop.*

28. **Promise.finally():** *returns a promise when it is settled or rejected. It will help to avoid duplicating* `***then***` *and* `***catch***` *handlers.*

29. **Rest/Spread Properties:** *for object* `*destructuring*` *and arrays.*

30. **Regular Expression Named Capture Groups:** *can group to be named using the notation* `***?<name>***`*after the opening bracket.*

31. **Regular Expression s (dotAll) Flag:** *matches any single character except carriage returns. The* `*s*` *flag changes this behavior so line terminators are permitted*

32. **Regular Expression Unicode Property Escapes:** *can set the Unicode property escapes with Unicode* `*u*` *flag set and* `*\p{…}*` *and* `*\p{…}*`

### ES2017/ES8

33. **Object.entries():***returns an array of a given objects* `*key and value pairs*`*.*

34. **Object.values():** *returns an array of given object’s property values.*

35. **padStart():** *pads the current string with another string until the resulting string reaches the length.*

36. **padEnd():** *pads the current string with the given string from the end of the current string.*

37. **Object.getOwnPropertyDescriptors():** *returns all own property descriptors of a given object.*

38. **Async functions:** *expand on Promises to make asynchronous calls.*

### ES2016/ES7

39. **Array.prototype.includes():** *determines whether an array includes a certain value among the given value. It returns true or false.*

40. **Exponentiation:** *returns a result of raising the first operand to the power of the second operand.*

### ES2015/ES6

41. **Arrow function expressions:** *is alternative to traditional functional expression for some cases*

42. **Enhanced Object Literals:** *extended to support setting the object constructions.*

43. **Classes:** *create class using* `*class*` *keyword.*

44. **Template Literals:** *can add parameters directly in the string using* `*${param}*`

45. **Destructuring Assignment:** *helps to unpack values from arrays or properties from objects.*

46. **Default + Rest + Spread:** *supports the default value, spread parameter or array as arguments.*

47. **Let + Const:**

48. **Promises:** *used for async operations.*

49. **Modules:**

50. **Map + Set + WeakMap + WeakSet:**

51. **Math + Number + String + Array + Object APIs:**

**For more details and examples you can check out this article.**

[51 JavaScript Features covered from ES12 to ES5 you might not know yet](https://medium.com/javascript-in-plain-english/51-javascript-features-covered-from-es12-to-es5-you-might-not-know-yet-47ae27b46133)

**## Top 100 Questions You Must Prepare For Your Next Angular Interview**

[Top 100 Questions You Must Prepare For Your Next Angular Interview](https://medium.com/javascript-in-plain-english/top-100-questions-you-must-prepare-for-your-next-angular-interview-fcd344ca822e)

## Conclusion

And there we have it. 34 ways to optimize your code with modern JavaScript techniques.

Enjoyed this article? If so, get more similar content by [**subscribing to our YouTube channel**](https://www.youtube.com/channel/UCtipWUghju290NWcn8jhyAw?sub_confirmation=true)**!**


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
