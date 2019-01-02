> * 原文地址：[Overview of JavaScript ES6 features (a.k.a ECMAScript 6 and ES2015+)](http://adrianmejia.com/blog/2016/10/19/Overview-of-JavaScript-ES6-features-a-k-a-ECMAScript-6-and-ES2015/)
* 原文作者：[Adrian Mejia](http://adrianmejia.com/#about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[L9m](https://github.com/L9m)
* 校对者：[Tina92](https://github.com/Tina92)，[luoyaqifei](https://github.com/luoyaqifei)，[theJian](https://github.com/theJian)

# JavaScript ES6 核心功能一览（ES6 亦作 ECMAScript 6 或 ES2015+）

JavaScript 在过去几年里发生了很大的变化。这里介绍 12 个你马上就能用的新功能。

# JavaScript 历史

新的语言规范被称作 ECMAScript 6。也称为 ES6 或 ES2015+ 。

自从 1995 年 JavaScript 诞生以来，它一直在缓慢地发展。每隔几年就会增加一些新内容。1997 年，ECMAScript 成为 JavaScript 语言实现的规范。它已经有了好几个版本，比如 ES3 , ES5 , ES6 等等。

![](http://adrianmejia.com/images/history-javascript-evolution-es6.png "JavaScript 发展史")

如你所见，ES3，ES5 和 ES6 之间分别存在着 10 年和 6 年的间隔。像 ES6 那样一次进行大幅修改的模式被逐年渐进式的新模式所替代。

# 浏览器支持

所有现代浏览器和环境都已支持 ES6。

![](http://adrianmejia.com/images/es6-javascript-support.png "ES6 Support")

来源: [https://kangax.github.io/compat-table/es6/](https://kangax.github.io/compat-table/es6/)

Chrome，MS Edge，Firefox，Safari，Node 和许多其他的环境都已内置支持大多数的 JavaScript ES6 功能。所以，在本教程中你学到的每个知识，你都可以马上开始应用。

让我们开始学习 ECMAScript 6 吧！

# 核心 ES6 功能

你可以在浏览器的控制台中测试所有下面的代码片段。

![](http://adrianmejia.com/images/javascript-es6-classes-on-browser-console.png "Testing Javascript ES6 classes on browser console")

不要笃信我的话，而是要亲自去测试每一个 ES5 和 ES6 示例。让我们开始动手吧 💪

## 变量的块级作用域

使用 ES6，声明变量我们可以用 `var` ，也可以用 `let` 或 `const`。

`var` 有什么不足？

使用 `var` 的问题是变量会漏入其他代码块中，诸如 `for` 循环或 `if` 代码块。

```
// ES5
var x = 'outer';
function test(inner) {
  if (inner) {
    var x = 'inner'; // 作用于整个 function
    return x;
  }
  return x; // 因为第四行的声明提升，被重新定义
}
test(false); // undefined 😱
test(true); // inner
```

对于 `test(fasle)` ，你期望返回 `outer`，**但是**，你得到的是 `undefined`。

为什么？

因为尽管没有执行 `if` 代码块，第四行中的表达式 `var x` 也会被提升。

> var **提升**：
> 
> *   `var` 是函数作用域。在整个函数中甚至是声明语句之前都是可用的。
> *   声明被提升。所以你能在声明之前使用一个变量。
> *   初始化是不被提升的。如果你使用 `var` 声明变量，请总是将它放在顶部。
> *   在应用了声明提升规则之后，我们就能更容易地理解发生了什么：
>     
>    
            ```
            // ES5
            var x = 'outer';
            function test(inner) {
                var x; // 声明提升
                if (inner) {
                    x = 'inner'; // 初始化不被提升
                    return x;
                }
                return x;
            }
            ```

ECMAScript 2015 找到了解决的办法：



```
// ES6
let x = 'outer';
function test(inner) {
  if (inner) {
    let x = 'inner';
    return x;
  }
  return x; // 从第一行获取到预期结果
}
test(false); // outer
test(true); // inner
```

将 `var` 改为 `let`，代码将像期望的那样运行。如果 `if` 代码块没有被调用，`x` 变量也就不会在代码块外被提升。

> let **提升** 和“暂存死区（temporal dead zone）”
> 
> *   在 ES6 中，`let` 将变量提升到代码块的顶部（不是像 ES5 那样的函数顶部）。
> *   然而，代码块中，在变量声明之前引用它会导致 `ReferenceError` 错误。
> *   `let` 是块级作用域。你不能在它被声明之前引用它。
> *   “暂存死区（Temporal dead zone）”是指从代码块开始直到变量被声明之间的区域。

**IIFE**

在解释 IIFE 之前让我们看一个例子。来看一下：

```
// ES5
{
  var private = 1;
}
console.log(private); // 1
```

如你所见，`private` 漏出(代码块)。你需要使用 IIFE（immediately-invoked function expression，立即执行函数表达式）来包含它：

```
// ES5
(function(){
  var private2 = 1;
})();
console.log(private2); // Uncaught ReferenceError
```

如果你看一看 jQuery/loadsh 或其他开源项目，你会注意到他们用 IIFE 来避免污染全局环境而且只在全局中定义了诸如 `_`，`$`和`jQuery`。 

在 ES6 上则一目了然，我们可以只用代码块和 `let`，也不再需要使用 IIFE了。

```
// ES6
{
  let private3 = 1;
}
console.log(private3); // Uncaught ReferenceError
```

**Const**

如果你想要一个变量保持不变（常量），你也可以使用 `const`。

![](http://adrianmejia.com/images/javascript-es6-const-variables-example.png "const variable example")

> 总之：用 `let`，`const` 而不是 `var`
> 
> *   对所有引用使用 `const`；避免使用 `var`。
> *   如果你必须重新指定引用，用 `let` 替代 `const`。

## 模板字面量

有了模板字面量，我们就不用做多余的嵌套拼接了。来看一下：

```
// ES5
var first = 'Adrian';
var last = 'Mejia';
console.log('Your name is ' + first + ' ' + last + '.');
```

现在你可以使用反引号 (\`) 和字符串插值 `${}`：

```
// ES6
const first = 'Adrian';
const last = 'Mejia';
console.log(`Your name is ${first} ${last}.`);
```

## 多行字符串

我们再也不需要添加 + `\n` 来拼接字符串了：

```
// ES5
var template = '<li *ngFor="let todo of todos" [ngClass]="{completed: todo.isDone}" >\n' +
'  <div class="view">\n' +
'    <input class="toggle" type="checkbox" [checked]="todo.isDone">\n' +
'    <label></label>\n' +
'    <button class="destroy"></button>\n' +
'  </div>\n' +
'  <input class="edit" value="">\n' +
'</li>';
console.log(template);
```

在 ES6 上， 我们可以同样使用反引号来解决这个问题：

```
// ES6
const template = `<li *ngFor="let todo of todos" [ngClass]="{completed: todo.isDone}" >
  <div class="view">
    <input class="toggle" type="checkbox" [checked]="todo.isDone">
    <label></label>
    <button class="destroy"></button>
  </div>
  <input class="edit" value="">
</li>`;
console.log(template);
```

两段代码的结果是完全一样的。

## 解构赋值

ES6 的解构不仅实用而且很简洁。如下例所示：

**从数组中获取元素**


```
// ES5
var array = [1, 2, 3, 4];
var first = array[0];
var third = array[2];
console.log(first, third); // 1 3
```

等同于：

```
const array = [1, 2, 3, 4];
const [first, ,third] = array;
console.log(first, third); // 1 3
```

**交换值**

```
// ES5
var a = 1;
var b = 2;
var tmp = a;
a = b;
b = tmp;
console.log(a, b); // 2 1
```

等同于：

```
// ES6
let a = 1;
let b = 2;
[a, b] = [b, a];
console.log(a, b); // 2 1
```

**多个返回值的解构**

```
// ES5
function margin() {
  var left=1, right=2, top=3, bottom=4;
  return { left: left, right: right, top: top, bottom: bottom };
}
var data = margin();
var left = data.left;
var bottom = data.bottom;
console.log(left, bottom); // 1 4
```


在第 3 行中，你也可以用一个像这样的数组返回（同时省去了一些编码）：

```
return [left, right, top, bottom];
```

但另一方面，调用者需要考虑返回数据的顺序。

```
var left = data[0];
var bottom = data[3];
```


用 ES6，调用者只需选择他们需要的数据即可（第 6 行）：

```
// ES6

function margin() {
  const left=1, right=2, top=3, bottom=4;
  return { left, right, top, bottom };
}
const { left, bottom } = margin();
console.log(left, bottom); // 1 4
```

*注意：* 在第 3 行中，我们使用了一些其他的 ES6 功能。我们将 `{ left: left }` 简化到只有 `{ left }`。与 ES5 版本相比，它变得如此简洁。酷不酷？

**参数匹配的解构**


```
// ES5
var user = {firstName: 'Adrian', lastName: 'Mejia'};
function getFullName(user) {
  var firstName = user.firstName;
  var lastName = user.lastName;
  return firstName + ' ' + lastName;
}
console.log(getFullName(user)); // Adrian Mejia
```

等同于（但更简洁）：

```
// ES6
const user = {firstName: 'Adrian', lastName: 'Mejia'};
function getFullName({ firstName, lastName }) {
  return `${firstName} ${lastName}`;
}
console.log(getFullName(user)); // Adrian Mejia
```

**深度匹配**

```
// ES5
function settings() {
  return { display: { color: 'red' }, keyboard: { layout: 'querty'} };
}
var tmp = settings();
var displayColor = tmp.display.color;
var keyboardLayout = tmp.keyboard.layout;
console.log(displayColor, keyboardLayout); // red querty
```

等同于（但更简洁）：

```
// ES6
function settings() {
  return { display: { color: 'red' }, keyboard: { layout: 'querty'} };
}
const { display: { color: displayColor }, keyboard: { layout: keyboardLayout }} = settings();
console.log(displayColor, keyboardLayout); // red querty
```

这也称作对象的解构。


如你所见，解构是非常实用的而且有利于促进良好的编码风格。

> 最佳实践:
> 
> *   使用数组解构去获取元素或交换值。它可以避免创建临时引用。
> *   不要对多个返回值使用数组解构，而是要用对象解构。

## 类和对象

用 ECMAScript 6，我们从“构造函数”🔨 来到了“类”🍸。

> 在 JavaScript 中，每个对象都有一个原型对象。所有的 JavaScript 对象都从它们的原型对象那里继承方法和属性。

在 ES5 中，为了实现面向对象编程（OOP），我们使用构造函数来创建对象，如下：
```
// ES5
var Animal = (function () {
  function MyConstructor(name) {
    this.name = name;
  }
  MyConstructor.prototype.speak = function speak() {
    console.log(this.name + ' makes a noise.');
  };
  return MyConstructor;
})();
var animal = new Animal('animal');
animal.speak(); // animal makes a noise.
```

ES6 中有了一些语法糖。通过像 `class` 和 `constructor` 这样的关键字和减少样板代码，我们可以做到同样的事情。另外，`speak()` 相对照 `constructor.prototype.speak = function ()`  更加清晰：

```
// ES6
class Animal {
  constructor(name) {
    this.name = name;
  }
  speak() {
    console.log(this.name + ' makes a noise.');
  }
}
const animal = new Animal('animal');
animal.speak(); // animal makes a noise.
```

正如你所见，两种式样（ES5 与 6）在幕后产生相同的结果而且用法一致。

> 最佳实践：
> 
> *   总是使用 `class` 语法并避免直接直接操纵 `prototype`。为什么？因为它让代码更加简洁和易于理解。
> *   避免使用空的构造函数。如果没有指定，类有一个默认的构造函数。

## 继承

基于前面的 `Animal` 类。 让我们扩展它并定义一个 `Lion` 类。

在 ES5 中，它更多的与原型继承有关。

```
// ES5
var Lion = (function () {
  function MyConstructor(name){
    Animal.call(this, name);
  }
  // 原型继承
  MyConstructor.prototype = Object.create(Animal.prototype);
  MyConstructor.prototype.constructor = Animal;
  MyConstructor.prototype.speak = function speak() {
    Animal.prototype.speak.call(this);
    console.log(this.name + ' roars 🦁');
  };
  return MyConstructor;
})();
var lion = new Lion('Simba');
lion.speak(); // Simba makes a noise.
// Simba roars.
```

我不会重复所有的细节，但请注意：

*   第 3 行中，我们添加参数显式调用了 `Animal` 构造函数。
*   第 7-8 行，我们将 `Lion` 原型指派给 `Animal` 原型。
*   第 11行中，我们调用了父类 `Animal` 的 `speak` 方法。

在 ES6 中，我们有了新关键词 `extends` 和 `super` <img src="http://adrianmejia.com/images/superman_shield.svg" width="25" height="25" alt="superman shield" style="display:inline-block;" data-pin-nopin="true">。

```
// ES6
class Lion extends Animal {
  speak() {
    super.speak();
    console.log(this.name + ' roars 🦁');
  }
}
const lion = new Lion('Simba');
lion.speak(); // Simba makes a noise.
// Simba roars.
```

虽然 ES6 和 ES5 的代码作用一致，但是 ES6 的代码显得更易读。更胜一筹！

> 最佳实践：
> 
> *   使用  `extends` 内置方法实现继承。

## 原生 Promises

从回调地狱 👹 到 promises 🙏。

```
// ES5
function printAfterTimeout(string, timeout, done){
  setTimeout(function(){
    done(string);
  }, timeout);
}
printAfterTimeout('Hello ', 2e3, function(result){
  console.log(result);
  // 嵌套回调
  printAfterTimeout(result + 'Reader', 2e3, function(result){
    console.log(result);
  });
});
```

我们有一个接收一个回调的函数，当 `done` 时执行。我们必须一个接一个地执行它两次。这也是为什么我们在回调中第二次调用  `printAfterTimeout` 的原因。

如果你需要第 3 次或第 4 次回调，可能很快就会变得混乱。来看看我们用 promises 的写法：

```
// ES6
function printAfterTimeout(string, timeout){
  return new Promise((resolve, reject) => {
    setTimeout(function(){
      resolve(string);
    }, timeout);
  });
}
printAfterTimeout('Hello ', 2e3).then((result) => {
  console.log(result);
  return printAfterTimeout(result + 'Reader', 2e3);
}).then((result) => {
  console.log(result);
});
```

如你所见，使用 promises 我们能在函数完成后进行一些操作。不再需要嵌套函数。

## 箭头函数

ES6 没有移除函数表达式，但是新增了一种，叫做箭头函数。

在 ES5 中，对于 `this` 我们有一些问题：

```
// ES5
var _this = this; // 保持一个引用
$('.btn').click(function(event){
  _this.sendData(); // 引用的是外层的 this
});
$('.input').on('change',function(event){
  this.sendData(); // 引用的是外层的 this
}.bind(this)); // 绑定到外层的 this
```

你需要使用一个临时的 `this` 在函数内部进行引用或用 `bind` 绑定。在 ES6 中，你可以用箭头函数。

```
// ES6
// 引用的是外部的那个 this
$('.btn').click((event) =>  this.sendData());
// 隐式返回
const ids = [291, 288, 984];
const messages = ids.map(value => `ID is ${value}`);
```

## For…of

从 `for` 到 `forEach` 再到 `for...of`：

```
// ES5
// for
var array = ['a', 'b', 'c', 'd'];
for (var i = 0; i < array.length; i++) {
  var element = array[i];
  console.log(element);
}
// forEach
array.forEach(function (element) {
  console.log(element);
});
```

ES6 的 for…of 同样可以实现迭代。
```
// ES6
// for ...of
const array = ['a', 'b', 'c', 'd'];
for (const element of array) {
    console.log(element);
}
```

## 默认参数

从检查一个变量是否被定义到重新指定一个值再到 `default parameters`。
你以前写过类似这样的代码吗？

```
// ES5
function point(x, y, isFlag){
  x = x || 0;
  y = y || -1;
  isFlag = isFlag || true;
  console.log(x,y, isFlag);
}
point(0, 0) // 0 -1 true 😱
point(0, 0, false) // 0 -1 true 😱😱
point(1) // 1 -1 true
point() // 0 -1 true
```

可能有过，这是一种检查变量是否赋值的常见模式，不然则分配一个默认值。然而，这里有一些问题：

*  第 8 行中，我们传入 `0, 0` 返回了 `0, -1`。
*  第 9 行中， 我们传入 `false` 但是返回了 `true`。

如果你传入一个布尔值作为默认参数或将值设置为 0，它不能正常起作用。你知道为什么吗？在讲完 ES6 示例后我会告诉你。

用 ES6，现在你可以用更少的代码做到更好！

```
// ES6
function point(x = 0, y = -1, isFlag = true){
  console.log(x,y, isFlag);
}
point(0, 0) // 0 0 true
point(0, 0, false) // 0 0 false
point(1) // 1 -1 true
point() // 0 -1 true
```

请注意第 5 行和第 6 行，我们得到了预期的结果。ES5 示例则无效。首先检查是否等于 `undefined`，因为 `false`，`null`，`undefined` 和 `0` 都是假值，我们可以避开这些数字，


```
// ES5
function point(x, y, isFlag){
  x = x || 0;
  y = typeof(y) === 'undefined' ? -1 : y;
  isFlag = typeof(isFlag) === 'undefined' ? true : isFlag;
  console.log(x,y, isFlag);
}
point(0, 0) // 0 0 true
point(0, 0, false) // 0 0 false
point(1) // 1 -1 true
point() // 0 -1 true
```

当我们检查是否为 `undefined` 后，获得了期望的结果。

## 剩余参数

从参数到剩余参数和扩展操作符。

在 ES5 中，获取任意数量的参数是非常麻烦的：


```
// ES5
function printf(format) {
  var params = [].slice.call(arguments, 1);
  console.log('params: ', params);
  console.log('format: ', format);
}
printf('%s %d %.2f', 'adrian', 321, Math.PI);
```

我们可以用 rest 操作符 `...` 做到同样的事情。

```
// ES6

function printf(format, ...params) {
  console.log('params: ', params);
  console.log('format: ', format);
}
printf('%s %d %.2f', 'adrian', 321, Math.PI);
```

## 展开运算符

从 `apply()` 到展开运算符。我们同样用 `...` 来解决：

> 提醒：我们使用 `apply()` 将数组转换为一列参数。例如，`Math.max()` 作用于一列参数，但是如果我们有一个数组，我们就能用 `apply` 让它生效。

![](http://adrianmejia.com/images/javascript-math-apply-arrays.png "JavaScript Math apply for arrays")

正如我们较早之前看过的，我们可以使用 `apply` 将数组作为参数列表传递：


```
// ES5
Math.max.apply(Math, [2,100,1,6,43]) // 100
```

在 ES6 中，你可以用展开运算符：

```
// ES6
Math.max(...[2,100,1,6,43]) // 100
```

同样，从 `concat` 数组到使用展开运算符：


```
// ES5
var array1 = [2,100,1,6,43];
var array2 = ['a', 'b', 'c', 'd'];
var array3 = [false, true, null, undefined];
console.log(array1.concat(array2, array3));
```

在 ES6 中，你可以用展开运算符来压平嵌套：

```
// ES6
const array1 = [2,100,1,6,43];
const array2 = ['a', 'b', 'c', 'd'];
const array3 = [false, true, null, undefined];
console.log([...array1, ...array2, ...array3]);
```

# 总结

JavaScript 经历了相当多的修改。这篇文章涵盖了每个 JavaScript 开发者都应该了解的大多数核心功能。同样，我们也介绍了一些让你的代码更加简洁，易于理解的最佳实践。

如果你认为还有一些没有提到的**必知**的功能，请在下方留言，我会更新这篇文章。

