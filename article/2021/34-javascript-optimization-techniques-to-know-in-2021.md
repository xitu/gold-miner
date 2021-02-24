> * 原文地址：[34 JavaScript Optimization Techniques to Know in 2021
](https://medium.com/javascript-in-plain-english/34-javascript-optimization-techniques-to-know-in-2021-d561afdf73c3)
> * 原文作者：[atit53](https://atit53.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/34-javascript-optimization-techniques-to-know-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/34-javascript-optimization-techniques-to-know-in-2021.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：

# 2021 年需要了解的 34 个 JavaScript 优化技巧
使用先进的速记技巧优化你的 JavaScript 代码

开发者需要持续学习新技术，跟以前相比，如今跟随技术变化是比较容易做到的，我写这篇文章的目的是介绍诸如速写法之类的 JavaScript 最佳实践和其中的特性，这些都是我们作为一名前端开发人员必须了解的，它会给我们的工作生活带来便利。

![https://miro.medium.com/max/2400/0*K49jVcTGrpgm_5mX.png](https://miro.medium.com/max/2400/0*K49jVcTGrpgm_5mX.png)

可能你做了多年的 JavaScript 开发工作，但有时候对一些最新的技术不了解，这些新技术可能有助于某些问题的解决，因此你需要编写额外的代码。这些新技术也能帮助你进行代码优化。此外，如果你今年需要为 JavaScript 面试作准备，本文也是一份实用的参考资料。

在这里，我会介绍一些新的**速记方法**，它可以优化你的 JavaScript 代码，使代码更简洁。下面是一份 **JavaScript 偷懒法列表**，你需要了解一下。

# **1. 含有多个条件的 if 语句**

我们可以在数组中存储多个值，并且可以使用数组的 includes 方法。

```
//longhandif (x === 'abc' || x === 'def' || x === 'ghi' || x ==='jkl') {
    //logic
}//shorthandif (['abc', 'def', 'ghi', 'jkl'].includes(x)) {
   //logic
}
```

# **2. If … else 的速记法**

当我们的 if-else 条件中的逻辑比较简单时，可以使用这种简洁的方式——三元条件运算符。

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

如果包含嵌套的条件，我们也可以这样写。

```
let x = 300,
test2 = (x > 100) ? 'greater 100' : (x < 50) ? 'less 50' : 'between 50 and 100';console.log(test2); // "greater than 100"
```

# **3. 定义变量**

当我们定义两个值相同或类型相同的变量，可以使用这样的速记法

```
//Longhand 
let test1;
let test2 = 1;//Shorthand 
let test1, test2 = 1;

```

# **4. 对 Null、Undefined、Empty 这些值的检查**

我们创建一个新变量，有时候需要检查是否为 Null 或 Undefined。JavaScript 本身就有一种速记法能实现这种功能。

```
// Longhand
if (test1 !== null || test1 !== undefined || test1 !== '') {
    let test2 = test1;
}// Shorthand
let test2 = test1 || '';
```

# **5. 对 Null 值的检查以及默认赋值**

```
let test1 = null,
    test2 = test1 || '';console.log("null check", test2); // output will be ""
```

# **6. 对 Undefined 值的检查以及默认赋值**

```
let test1 = undefined,
    test2 = test1 || '';console.log("undefined check", test2); // output will be ""
```

Normal Value checks对正常值的检查

```
let test1 = 'test',
    test2 = test1 || '';console.log(test2); // output: 'test'
```

利好消息：关于第 4、5、6 条还可以使用 ?? 运算符

# **聚合运算符**

 **??**是聚合运算符，如果左值为 null 或 undefined，就返回右值。默认返回左值。

```
const test= null ?? 'default';
console.log(test);
// expected output: "default"const test1 = 0 ?? 2;
console.log(test1);
// expected output: 0
```

# **7. 同时为多个变量赋值**

当我们处理多个变量，并且需要对这些变量赋不同的值，这个速记法很有用。

```
//Longhand 
let test1, test2, test3;
test1 = 1;
test2 = 2;
test3 = 3;//Shorthand 
let [test1, test2, test3] = [1, 2, 3];
```

# **8. 赋值运算符速记法**

我们在编码时可能需要处理很多算法，所以需要使用赋值运算符。以下是 JavaScript 中赋值运算符的应用。

```
// Longhand
test1 = test1 + 1;
test2 = test2 - 1;
test3 = test3 * 20;// Shorthand
test1++;
test2--;
test3 *= 20;
```


# **9. 判断变量是否存在的速记法**

这是普遍使用的速记法，但在这里应当提一下。

```
// Longhand
if (test1 === true) or if (test1 !== "") or if (test1 !== null)

// Shorthand //it will check empty string,null and undefined too
if (test1)
```

注意：当 test1 为任何值时，程序都会执行 if(test1){ } 内的逻辑，这种写法在判断 NULL 或 undefined 值时普遍使用。

# **10. 用于多个条件的与(&&)运算符**

如果需要实现某个变量为 true 时调用一个函数，可以使用 && 运算符。

```
//Longhand 
if (test1) {
 callMethod(); 
} //Shorthand 
test1 && callMethod();
```

# **11. foreach 循环速记法**

这是循环结构对应的速记法。

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

# **12. 比较结果的返回**

在 return 语句中，我们也可以使用比较的语句。这样，原来需要 5 行代码才能实现的功能，现在只需要 1 行，大大减少了代码量。

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

# **13. 箭头函数**

```
//Longhand 
function add(a, b) { 
   return a + b; 
} 
//Shorthand 
const add = (a, b) => a + b;
```

More examples.再举个例子

```
function callMe(name) {
  console.log('Hello', name);
}callMe = name => console.log('Hello', name);
```

# **14. 简短的函数调用语句**

我们可以使用三元运算符实现如下功能。

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

# **15. switch 对应的速记法**

我们可以把条件值保存在名值对中，基于这个条件使用名值对代替 switch。

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

# **16. 隐式返回速记法**

使用箭头函数，我们可以直接得到函数执行结果，不需要写 return 语句。

Longhand:

```
//longhandfunction calculate(diameter) {
  return Math.PI * diameter
}//shorthandcalculate = diameter => (
  Math.PI * diameter;
)
```

# **17. 十进制数的指数形式**

```
// Longhand
for (var i = 0; i < 10000; i++) { ... }

// Shorthand
for (var i = 0; i < 1e4; i++) {
```

# **18. 默认参数值**

```
//Longhandfunction add(test1, test2) {
  if (test1 === undefined)
    test1 = 1;
  if (test2 === undefined)
    test2 = 2;
  return test1 + test2;
}//shorthandadd = (test1 = 1, test2 = 2) => (test1 + test2);add() //output: 3
```

# **19. 延展操作符的速记法**

```
//longhand// joining arrays using concat
const data = [1, 2, 3];
const test = [4 ,5 , 6].concat(data);
//shorthand// joining arrays
const data = [1, 2, 3];
const test = [4 ,5 , 6, ...data];
console.log(test); // [ 4, 5, 6, 1, 2, 3]

```

我们也可以使用延展操作符来克隆。

```
//longhand

// cloning arrays
const test1 = [1, 2, 3];
const test2 = test1.slice()//shorthand

// cloning arrays
const test1 = [1, 2, 3];
const test2 = [...test1];
```

# **20. 文本模板**

如果你对使用 + 符号来连接多个变量感到厌烦，这个速记法可以帮到你。

```
//longhandconst welcome = 'Hi ' + test1 + ' ' + test2 + '.'//shorthandconst welcome = `Hi ${test1} ${test2}`;
```


# **21. 跟多行文本有关的速记法**

When we are dealing with a multi-line string in code we can go for this function:当我们在代码中处理多行文本时，可以使用这样的技巧

Longhand:

```
//longhandconst data = 'abc abc abc abc abc abc\n\t'
    + 'test test,test test test test\n\t'//shorthandconst data = `abc abc abc abc abc abc
         test test,test test test test`
```

# **22. 对象属性的赋值**

```
let test1 = 'a'; 
let test2 = 'b';//Longhand 
let obj = {test1: test1, test2: test2}; 
//Shorthand 
let obj = {test1, test2};
```

# **23. 字符串转换为数字**

```
//Longhand 
let test1 = parseInt('123'); 
let test2 = parseFloat('12.3'); //Shorthand 
let test1 = +'123'; 
let test2 = +'12.3';
```

# **24. 解构赋值速记法**

```
//longhandconst test1 = this.data.test1;
const test2 = this.data.test2;
const test2 = this.data.test3;//shorthandconst { test1, test2, test3 } = this.data;
```

# **25. Array.find 速记法**

当我们需要在一个对象数组中按属性值查找特定对象时，find 方法很有用。

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

# **26. 查询条件速记法**

如果我们要检查类型，并根据类型调用不同的函数，我们既可以使用多个 else if 语句，也可以使用 switch，除此之外，如果有速记法，代码会是怎么样呢？

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

# **27. 按位非和 indexOf 速记法**

我们以查找特定值为目的迭代一个数组是，通常用到 **indexOf()** 方法。

```
//longhandif(arr.indexOf(item) > -1) { // item found }if(arr.indexOf(item) === -1) { // item not found}//shorthandif(~arr.indexOf(item)) { // item found}if(!~arr.indexOf(item)) { // item not found}
```

对除 `-1` 外的任何数进行 `按位非(~)` 运算都会返回真值。把按位非的结果再次进行逻辑取反就是 `!~`，这非常简单。或者我们也可以使用 `includes()` 函数：

```
if (arr.includes(item)) { 
// true if the item found
}
```

# **28. Object.entries()**

该特性可以把对象转换成一个由若干对象组成的数组。

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

这也是 ES8 中介绍的一个新特性，它的功能与 `Object.entries()` 类似，但没有其核心功能：

```
const data = { test1: 'abc', test2: 'cde' };
const arr = Object.values(data);
console.log(arr);/** Output:
[ 'abc', 'cde']
**/
```

# **30. 两个位运算符简写**

**(两个按位非运算符只适用于 32 位整型)**

```
// Longhand
Math.floor(1.9) === 1 // true

// Shorthand
~~1.9 === 1 // true
```

# **31. 把一个字符串重复输出多次**

我们可以使用 for 循环把一个字符串反复输出多次，那这种功能有没有速记法呢？

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

# **32. 找出一个数组中最大和最小的值**

```
const arr = [1, 2, 3]; 
Math.max(…arr); // 3
Math.min(…arr); // 1
```

# **33. 获取字符串中的字符**

```
let str = 'abc';
//Longhand 
str.charAt(2); // c//Shorthand 
注意：如果事先知道目标字符在字符串中的索引，我们可以直接使用该索引值。如果索引值不确定，运行时就有可能抛出 undefined。
str[2]; // c
```

# **34. 幂运算的速记法**

指数幂函数的速记法:

```
//longhandMath.pow(2,3); // 8//shorthand2**3 // 8
```
