> * 原文地址：[Function in JavaScript Has Much More Secrets Than You Think](https://medium.com/javascript-in-plain-english/function-in-javascript-has-much-more-secrets-than-you-think-b3bf64055c99)
> * 原文作者：[bitfish](https://medium.com/@bf2)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/function-in-javascript-has-much-more-secrets-than-you-think.md](https://github.com/xitu/gold-miner/blob/master/article/2020/function-in-javascript-has-much-more-secrets-than-you-think.md)
> * 译者：[Isildur46](https://github.com/Isildur46)
> * 校对者：[Chorer](https://github.com/Chorer)

# JavaScript 函数中一些你不知道的秘密

![Photo by [Luca Bravo](https://unsplash.com/@lucabravo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*9flb0rn0PvVk8f88)

每个程序员对函数语法都非常熟悉。JavaScript 中函数有非常高的地位，经常被称为一等公民。但是你真的擅长使用函数吗？

接下来我将介绍一些函数的进阶用法，希望能对你有所帮助。本文包含以下几个章节：

* 纯函数
* 高阶函数
* 函数缓存
* 惰性函数
* 柯里化
* 组合函数

## 纯函数

#### 什么是纯函数？

当一个函数满足以下 2 个条件，它就是纯函数：

* 传入的参数相同时，函数总是返回相同的结果。
* 函数执行时不产生副作用。

例子 1：

```js
function circleArea(radius){
  return radius * radius * 3.14
}
```

当参数 `radius` 的值相同时，函数总是会返回相同的结果，同时执行过程中函数没有对外产生副作用，所以这是一个纯函数。

例子 2：

```js
let counter = (function(){
  let initValue = 0
  return function(){
    initValue++;
    return initValue
  }
})()
```

![](https://cdn-images-1.medium.com/max/2000/1*-ao0govuJNMZH1Pg_vAu8g.png)

这个计数器函数每次执行结果都不同，因此它不是一个纯函数。

例子 3：

```js
let femaleCounter = 0;
let maleCounter = 0;

function isMale(user){
  if(user.sex = 'man'){
    maleCounter++;
    return true
  }
  return false
}
```

例子中的函数 `isMale` 传入了相同的参数时总是返回相同的结果，但是它有副作用。它的副作用是改变全局变量 `maleCounter` 的值，所以它不是纯函数。

#### 纯函数有何用处？

我们为何要区分纯函数和非纯函数？因为纯函数有很多优势，我们可以在编程过程中使用纯函数来提升代码质量。

1. 纯函数读起来更明确、更简洁。

每个纯函数都能完成特定任务并产生一个明确的结果，这会大大增加代码的可读性、降低编写文档的难度。

2. 编译器对纯函数能做更多优化。

比如说我们有这样一段代码：

```js
for (int i = 0; i < 1000; i++){
    console.log(fun(10));
}
```

如果 `fun` 不是纯函数，那么 `fun(10)` 在代码执行时需要调用 1,000 次。

如果 `fun` 是纯函数，那么编辑器就可以在编译时优化代码，优化后的代码可能像这样：

```js
let result = fun(10)
for (int i = 0; i < 1000; i++){
    console.log(result);
}
```

3. 纯函数更容易测试

纯函数测试时不需要依赖上下文。当我们给纯函数写单元测试时，我们只需简单地传入一个值，然后检验输出值是否符合我们预期就行了。

举个简单的例子：一个纯函数接受以数字组成的数组作为参数，并将数组中每个数字都加 1。

```js
const incrementNumbers = function(numbers){
  // ...
}
```

我们只需要编写如下的单元测试就行了：

```js
let list = [1, 2, 3, 4, 5];

assert.equals(incrementNumbers(list), [2, 3, 4, 5, 6])
```

如果它不是纯函数，我们需要考虑很多外部因素，这可不是一个简单的工作。

## 高阶函数

什么是高阶函数？

高阶函数至少需要满足以下 1 项条件：

* 以一个或多个函数作为参数；
* 将一个函数作为返回值返回。

使用高阶函数能够提升我们代码的灵活性，让我们编写更加灵活和简洁的代码。

假设我们现在有一个整数组成的数组，我们希望基于它创建一个新数组。新数组元素的数量和原数组相同，新数组中每个元素是原数组对应元素的两倍。

不使用高阶函数的话，代码可能类似这样：

```js
const arr1 = [1, 2, 3];
const arr2 = [];

for (let i = 0; i < arr1.length; i++) {
    arr2.push(arr1[i] * 2);
}
```

在 JavaScript 中，数组对象有一个 `map()` 方法。

> `map(callback)` 方法创建一个新数组，该方法在调用它的数组上依次**执行给定的函数**，并将返回值作为内容来填充新数组。

```js
const arr1 = [1, 2, 3];
const arr2 = arr1.map(function(item) {
  return item * 2;
});
console.log(arr2);
```

`map` 函数就是一个高阶函数。

正确使用高阶函数能够提高代码质量。下一章节都是和高阶函数有关的，让我们继续吧。

## 函数缓存

比如我们有这样一个纯函数：

```js
function computed(str) {    
    // 假设函数中的计算非常耗时
    console.log('2000s have passed')
      
    // 假设这是函数返回值
    return 'a result'
}
```

为了提升程序运行速度，我们希望将函数执行的结果缓存起来。当我们之后再调用它时，如果参数相同，函数就不会再次执行，而是直接将缓存中的结果返回出去。我们该怎么做？

我们可以写一个 `cached` 函数来包装我们的目标函数。这个缓存函数将目标函数作为参数，并返回一个包装后的函数。在 `cached` 函数里面，我们可以用 `Object` 或 `Map` 缓存函数之前调用的结果。

```JavaScript
function cached(fn){
  // 创建一个对象来存储每次函数执行后的返回结果
  const cache = Object.create(null);

  // 返回包装后的函数
  return function cachedFn (str) {

    // 如果没有缓存过，则执行函数
    if ( !cache[str] ) {
        let result = fn(str);

        // 在缓存中记录函数的执行结果
        cache[str] = result;
    }

    return cache[str]
  }
}
```

这里有个例子：

![](https://cdn-images-1.medium.com/max/2528/0*iLTBkgsiO05dd_XZ.png)

## 惰性函数

函数体通常包含某些条件判断语句，有时候这些语句只需要执行一次。

我们可以在第一次执行后“删除”这些语句来提升函数的性能，这样一来函数就不必在之后的调用过程中再去执行这些语句了。这种函数就是所谓的惰性函数。

举个例子，我们需要编写一个叫做 `foo` 的函数，它总是返回**第一次调用**时的日期对象，请注意是**第一次调用**。

```js
let fooFirstExecutedDate = null;
function foo() {
    if ( fooFirstExecutedDate != null) {
      return fooFirstExecutedDate;
    } else {
      fooFirstExecutedDate = new Date()
      return fooFirstExecutedDate;
    }
}
```

每次函数运行时，都会执行判断语句，如果条件判断很复杂，那么最终就会降低我们程序的性能。针对这一问题，我们可以使用惰性函数来优化这段代码。

我们可以写成这样：

```js
var foo = function() {
    var t = new Date();
    foo = function() {
        return t;
    };
    return foo();
}
```

第一次执行之后，我们用一个新函数覆盖了原函数。以后再执行这个函数的话，就不会再执行条件判断语句了，这提升了我们代码的性能。

然后我们再来看看一个更实际的例子。

当我们在元素中添加 DOM 事件时，为了兼容现代浏览器和 IE 浏览器，我们需要判断浏览器环境：

```js
function addEvent (type, el, fn) {
    if (window.addEventListener) {
        el.addEventListener(type, fn, false);
    }
    else if(window.attachEvent){
        el.attachEvent('on' + type, fn);
    }
}
```

每次我们调用 `addEvent` 函数的时候，都需要去判断。使用惰性函数的话，我们可以这么写：

```js
function addEvent (type, el, fn) {
    if (window.addEventListener) {
        addEvent = function (type, el, fn) {
            el.addEventListener(type, fn, false);
        }
    }
    else if(window.attachEvent){
        addEvent = function (type, el, fn) {
            el.attachEvent('on' + type, fn);
        }
    }
}
```

总而言之，如果函数中只需要进行一次条件判断，那么我们可以用惰性函数来优化它。更具体地说，第一次条件判断之后，原函数会被新函数所覆盖，新函数会移除条件判断语句。

## 函数柯里化

柯里化指的是将接受多参数的函数，转化为多个接受单一参数的函数的技术。

换言之，柯里化是将原本一次性接受所有参数的函数做一个转化，转化后，第一次调用时接受第一个参数并返回新函数，这个新函数调用时接受第二个参数并再次返回一个新函数，接着这个新函数调用时接受第三个参数，以此类推，直到囊括所有参数为止。

当我们给 `add(1,2,3)` 这种函数调用逻辑进行柯里化之后，我们会得到 `add(1)(2)(3)` 这样的形式。通过使用此技术，我们可以轻松地配置和复用代码片段。

柯里化有什么好处？

* 在柯里化帮助下，你可以不用重复传入相同的参数。
* 它可以创建高阶函数，在处理事件时极为有用。
* 小段代码可以轻松地配置和复用。

让我们来看一个简单的 `add` 函数，它接受三个操作数作为参数并返回它们相加的结果。

```js
function add(a,b,c){
 return a + b + c;
}
```

你可以用较少的参数来调用（结果会比较奇怪），或者传入更多的参数（会忽略多余参数）。

```js
add(1,2,3) // --> 6 
add(1,2) // --> NaN
add(1,2,3,4) --> 6 // 会忽略多余的参数
```

怎么把一个现有的函数转化为柯里化函数？

#### 代码：

```JavaScript
function curry(fn) {
    if (fn.length <= 1) return fn;
    const generator = (...args) => {
        if (fn.length === args.length) {

            return fn(...args)
        } else {
            return (...args2) => {

                return generator(...args, ...args2)
            }
        }
    }
    return generator
}
```

#### 例子：

![](https://cdn-images-1.medium.com/max/3172/1*xWlaYdGM43c5UtE-2sDbLw.png)

## 组合函数

假设我们要写一个函数实现以下功能：

> 输入“bitfish”，返回“HELLO, BITFISH”。

如你所见，这个函数有两个职责：

* 进行字符串拼接
* 将字符串转为大写

所以我们代码可以这么写：

```js
let toUpperCase = function(x) { return x.toUpperCase(); };
let hello = function(x) { return 'HELLO, ' + x; };

let greet = function(x){
    return hello(toUpperCase(x));
};
```

![](https://cdn-images-1.medium.com/max/2836/1*jK2JpMEe_O4ZSdC1c75y8g.png)

这个例子中只有两个步骤，所以 `greet` 函数看上去并不复杂。如果有更多操作，那么 `greet` 函数可能会产生更多的内部嵌套，导致我们编写类似 `fn3(fn2(fn1(fn0(x))))` 这样的代码。

为了做到这一点，我们需要写一个 `compose` 函数，专门用于组合函数：

```js
let compose = function(f,g) {
    return function(x) {
        return f(g(x));
    };
};
```

因此，`greet` 函数可以通过 `compose` 函数来得到：

```js
let greet = compose(hello, toUpperCase);
greet('kevin');
```

使用 `compose` 函数将两个函数合二为一，使得代码可以从右往左地运行，而不是从内到外地运行，这提升了代码的可读性。

但是现在 `compose` 函数只支持两个参数，我们非常希望它能够接受任意数量的参数。

著名的开源项目 [underscore](https://underscorejs.org/) 是这样实现组合器函数的。

![](https://cdn-images-1.medium.com/max/2372/1*UW-P_I4wRqvbneYQh5ZrUw.png)

```js
function compose() {
    var args = arguments;
    var start = args.length - 1;
    return function() {
        var i = start;
        var result = args[start].apply(this, arguments);
        while (i--) result = args[i].call(this, result);
        return result;
    };
};
```

通过组合函数，我们可以优化函数之间的逻辑关系、提升代码可读性，便于将来扩展和重构。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
