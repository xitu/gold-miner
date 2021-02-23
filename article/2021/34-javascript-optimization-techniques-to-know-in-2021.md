> * 原文地址：[34 JavaScript Optimization Techniques to Know in 2021
](https://medium.com/javascript-in-plain-english/34-javascript-optimization-techniques-to-know-in-2021-d561afdf73c3)
> * 原文作者：[atit53](https://atit53.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/34-javascript-optimization-techniques-to-know-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/34-javascript-optimization-techniques-to-know-in-2021.md)
> * 译者：
> * 校对者：

# 34 JavaScript Optimization Techniques to Know in 2021
Optimize your JavaScript code using modern shorthand techniques, tips, and tricks

The life of a developer is always learning new things and keeping up with the changes shouldn’t be harder than it already is, and my motive is to introduce all the JavaScript best practices such as shorthand and features which we must know as a frontend developer to make our life easier in 2021.

![https://miro.medium.com/max/2400/0*K49jVcTGrpgm_5mX.png](https://miro.medium.com/max/2400/0*K49jVcTGrpgm_5mX.png)

You might be doing JavaScript development for a long time but sometimes you might be not updated with the newest features which can solve your issues without doing or writing some extra codes. These techniques can help you to write clean and optimized JavaScript Code. Moreover, these topics can help you to prepare yourself for JavaScript interviews in 2021.

Here I am coming with a new series to cover **shorthand techniques** that help you to write more clean and optimized JavaScript Code. This is a **Cheat list for JavaScript** Coding you must know in 2021.

# **1. If with multiple conditions**

We can store multiple values in the array and we can use the array includes method.

```
//longhandif (x === 'abc' || x === 'def' || x === 'ghi' || x ==='jkl') {
    //logic
}//shorthandif (['abc', 'def', 'ghi', 'jkl'].includes(x)) {
   //logic
}
```

# **2. If true … else Shorthand**

This is a greater short cut for when we have if-else conditions that do not contain bigger logics inside. We can simply use the ternary operators to achieve this shorthand.

```
// Longhand
let test: boolean;if (x > 100) {
    test = true;
} else {
    test = false;
}// Shorthand
let test = (x > 10) ? true : false;//or we can use directly
let test = x > 10;console.log(test);
```

When we have nested conditions we can go this way.

```
let x = 300,
test2 = (x > 100) ? 'greater 100' : (x < 50) ? 'less 50' : 'between 50 and 100';console.log(test2); // "greater than 100"
```

# **3. Declaring variables**

When we want to declare the two variables which have the common value or common type we can use this shorthand.

```
//Longhand 
let test1;
let test2 = 1;//Shorthand 
let test1, test2 = 1;

```

# **4. Null, Undefined, Empty Checks**

When we do create new variables sometimes we want to check if the variable we are referencing for its value is not null or undefined. JavaScript does have a really good shorthand to achieve these functions.

```
// Longhand
if (test1 !== null || test1 !== undefined || test1 !== '') {
    let test2 = test1;
}// Shorthand
let test2 = test1 || '';
```

# **5. Null Value checks and Assigning Default Value**

```
let test1 = null,
    test2 = test1 || '';console.log("null check", test2); // output will be ""
```

# **6. Undefined Value checks and Assigning Default Value**

```
let test1 = undefined,
    test2 = test1 || '';console.log("undefined check", test2); // output will be ""
```

Normal Value checks

```
let test1 = 'test',
    test2 = test1 || '';console.log(test2); // output: 'test'
```

(BONUS: Now we can use `??` operator for topic 4,5 and 6)

# **Nullish coalescing Operator**

The **`nullish coalescing Operator ??**` is returned the right-hand side value if the left-hand side is null or undefined. By default, it will return the left-side value.

```
const test= null ?? 'default';
console.log(test);
// expected output: "default"const test1 = 0 ?? 2;
console.log(test1);
// expected output: 0
```

# **7. Assigning values to multiple variables**

When we are dealing with multiple variables and want to assign different values to the different variables this shorthand technique is really useful.

```
//Longhand 
let test1, test2, test3;
test1 = 1;
test2 = 2;
test3 = 3;//Shorthand 
let [test1, test2, test3] = [1, 2, 3];
```

# **8. Assignment Operators Shorthand**

We deal with a lot of arithmetic operators in our programming. This is one of the useful techniques for assignment operators to JavaScript variables.

```
// Longhand
test1 = test1 + 1;
test2 = test2 - 1;
test3 = test3 * 20;// Shorthand
test1++;
test2--;
test3 *= 20;
```


# **9. If Presence Shorthand**

This is one of the common shorthand which we all are using but still, it is worth mentioning here.

```
// Longhand
if (test1 === true) or if (test1 !== "") or if (test1 !== null)

// Shorthand //it will check empty string,null and undefined too
if (test1)
```

Note: If test1 has any value it will fall into the logic after the if loop, this operator mostly used for null or undefined checks.

# **10. AND(&&) Operator for Multiple Conditions**

If we are calling a function only if the variable is true then we can use && Operator.

```
//Longhand 
if (test1) {
 callMethod(); 
} //Shorthand 
test1 && callMethod();
```

# **11. foreach Loop Shorthand**

This is one of the common shorthand technique for iteration.

```
// Longhand
for (var i = 0; i < testData.length; i++)

// Shorthand
for (let i in testData) or  for (let i of testData)
```

Array for each variable

```
function testData(element, index, array) {
  console.log('test[' + index + '] = ' + element);
}

[11, 24, 32].forEach(testData);
// logs: test[0] = 11, test[1] = 24, test[2] = 32
```

# **12. Comparison Returns**

We can use the comparison in the return statements too. It will avoid our 5 lines of code and reduced them to 1 line.

```
// Longhand
let test;function checkReturn() {
    if (!(test === undefined)) {
        return test;
    } else {
        return callMe('test');
    }
}
var data = checkReturn();
console.log(data); //output testfunction callMe(val) {
    console.log(val);
}// Shorthandfunction checkReturn() {
    return test || callMe('test');
}
```

# **13. Arrow Function**

```
//Longhand 
function add(a, b) { 
   return a + b; 
} 
//Shorthand 
const add = (a, b) => a + b;
```

More examples.

```
function callMe(name) {
  console.log('Hello', name);
}callMe = name => console.log('Hello', name);
```

# **14. Short Function Calling**

We can use the ternary operator to achieve these functions.

```
// Longhand
function test1() {
  console.log('test1');
};function test2() {
  console.log('test2');
};var test3 = 1;
if (test3 == 1) {
  test1();
} else {
  test2();
}// Shorthand
(test3 === 1? test1:test2)();
```

# **15. Switch Shorthands**

We can save the conditions in the key-value objects and can be used based on the conditions.

```
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

# **16. Implicit Return Shorthand**

With the use of arrow functions, we can return the value directly without having to write a return statement.

Longhand:

```
//longhandfunction calculate(diameter) {
  return Math.PI * diameter
}//shorthandcalculate = diameter => (
  Math.PI * diameter;
)
```

# **17. Decimal base exponents**

```
// Longhand
for (var i = 0; i < 10000; i++) { ... }

// Shorthand
for (var i = 0; i < 1e4; i++) {
```

# **18. Default Parameter Values**

```
//Longhandfunction add(test1, test2) {
  if (test1 === undefined)
    test1 = 1;
  if (test2 === undefined)
    test2 = 2;
  return test1 + test2;
}//shorthandadd = (test1 = 1, test2 = 2) => (test1 + test2);add() //output: 3
```

# **19. Spread Operator Shorthand**

```
//longhand// joining arrays using concat
const data = [1, 2, 3];
const test = [4 ,5 , 6].concat(data);
//shorthand// joining arrays
const data = [1, 2, 3];
const test = [4 ,5 , 6, ...data];
console.log(test); // [ 4, 5, 6, 1, 2, 3]

```

For cloning also we can use a spread operator.

```
//longhand

// cloning arrays
const test1 = [1, 2, 3];
const test2 = test1.slice()//shorthand

// cloning arrays
const test1 = [1, 2, 3];
const test2 = [...test1];
```

# **20. Template Literals**

If you have tired of using + to concatenate multiple variables in a single string then this shorthand removes your headache.

```
//longhandconst welcome = 'Hi ' + test1 + ' ' + test2 + '.'//shorthandconst welcome = `Hi ${test1} ${test2}`;
```


# **21. Multi-line String Shorthand**

When we are dealing with a multi-line string in code we can go for this function:

Longhand:

```
//longhandconst data = 'abc abc abc abc abc abc\n\t'
    + 'test test,test test test test\n\t'//shorthandconst data = `abc abc abc abc abc abc
         test test,test test test test`
```

# **22. Object Property Assignment**

```
let test1 = 'a'; 
let test2 = 'b';//Longhand 
let obj = {test1: test1, test2: test2}; 
//Shorthand 
let obj = {test1, test2};
```

# **23. String into a Number**

```
//Longhand 
let test1 = parseInt('123'); 
let test2 = parseFloat('12.3'); //Shorthand 
let test1 = +'123'; 
let test2 = +'12.3';
```

# **24. Destructuring Assignment Shorthand**

```
//longhandconst test1 = this.data.test1;
const test2 = this.data.test2;
const test2 = this.data.test3;//shorthandconst { test1, test2, test3 } = this.data;
```

# **25. Array.find Shorthand**

When we do have an array of objects and we want to find the specific object based on the object properties find method is really useful.

```
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
]function findtest1(name) {
    for (let i = 0; i < data.length; ++i) {
        if (data[i].type === 'test1' && data[i].name === name) {
            return data[i];
        }
    }
}
//Shorthand
filteredData = data.find(data => data.type === 'test1' && data.name === 'fgh');
console.log(filteredData); // { type: 'test1', name: 'fgh' }
```

# **26. Lookup Conditions Shorthand**

If we have code to check the type and based on the type need to call different methods we either have the option to use multiple else ifs or go for the switch, but what if we have better shorthand than that?

```
// Longhand
if (type === 'test1') {
  test1();
}
else if (type === 'test2') {
  test2();
}
else if (type === 'test3') {
  test3();
}
else if (type === 'test4') {
  test4();
} else {
  throw new Error('Invalid value ' + type);
}// Shorthand
var types = {
  test1: test1,
  test2: test2,
  test3: test3,
  test4: test4
};
 
var func = types[type];
(!func) && throw new Error('Invalid value ' + type); func();
```

# **27. Bitwise IndexOf Shorthand**

When we are iterating an array to find a specific value we do use **indexOf()** method.What if we find a better approach for that? Let’s check out the example.

```
//longhandif(arr.indexOf(item) > -1) { // item found }if(arr.indexOf(item) === -1) { // item not found}//shorthandif(~arr.indexOf(item)) { // item found}if(!~arr.indexOf(item)) { // item not found}
```

The `bitwise(~)` the operator will return a truthy value for anything but `-1`. Negating it is as simple as doing `!~`. Alternatively, we can also use the `includes()` function:

```
if (arr.includes(item)) { 
// true if the item found
}
```

# **28. Object.entries()**

This feature helps to convert the object to an array of objects.

```
const data = { test1: 'abc', test2: 'cde', test3: 'efg' };
const arr = Object.entries(data);
console.log(arr);/** Output:
[ [ 'test1', 'abc' ],
  [ 'test2', 'cde' ],
  [ 'test3', 'efg' ]
]
**/
```

# **29. Object.values()**

This is also a new feature introduced in ES8 that performs a similar function to `Object.entries()`, but without the key part:

```
const data = { test1: 'abc', test2: 'cde' };
const arr = Object.values(data);
console.log(arr);/** Output:
[ 'abc', 'cde']
**/
```

# **30. Double Bitwise Shorthand**

**(The double NOT bitwise operator approach only works for 32-bit integers)**

```
// Longhand
Math.floor(1.9) === 1 // true

// Shorthand
~~1.9 === 1 // true
```

# **31. Repeat a string multiple times**

To repeat the same characters again and again we can use the for loop and add them in the same loop but what if we have a shorthand for this?

```
//longhand 
let test = ''; 
for(let i = 0; i < 5; i ++) { 
  test += 'test '; 
} 
console.log(str); // test test test test test 
//shorthand 
'test '.repeat(5);
```

# **32. Find max and min number in the array**

```
const arr = [1, 2, 3]; 
Math.max(…arr); // 3
Math.min(…arr); // 1
```

# **33. Get character from string**

```
let str = 'abc';
//Longhand 
str.charAt(2); // c//Shorthand 
Note: If we know the index of the array then we can directly use index insted of character.If we are not sure about index it can throw undefined
str[2]; // c
```

# **34. Power Shorthand**

Shorthand for a Math exponent power function:

```
//longhandMath.pow(2,3); // 8//shorthand2**3 // 8
```