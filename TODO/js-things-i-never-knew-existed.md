> * 原文地址：[JS things I never knew existed](https://air.ghost.io/js-things-i-never-knew-existed/)
> * 原文作者：[Skyllo](https://air.ghost.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/js-things-i-never-knew-existed.md](https://github.com/xitu/gold-miner/blob/master/TODO/js-things-i-never-knew-existed.md)
> * 译者：[Yong Li](https://github.com/NeilLi1992)
> * 校对者：[Yukiko](https://github.com/realYukiko)，[dz](https://github.com/dazhi1011)

# 我未曾见过的 JS 特性

有一天我正在阅读 MDN 文档，发现了一些我之前压根没有意识到在 JS 中存在的特性和 API。这里我罗列了一些，不管它们是否有用，JS 的学习永无止境。

## [标记语句](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/label)

有多少人知道在 JS 里你可以给 `for` 循环和语句块命名？反正我不知道…… 命名完新名称之后你可以在 `for` 循环中的 `break` 和 `continue` 之后、语句块中的 `break` 之后使用新名称。

```
loop1: // 标记 "loop1" 
for (let i = 0; i < 3; i++) { // "loop1"
   loop2: // 标记 "loop2"
   for (let j = 0; j < 3; j++) { // "loop2"
      if (i === 1) {
         continue loop1; // 继续外层的 "loop1" 循环
         // break loop1; // 中止外层的 "loop1" 循环
      }
      console.log(`i = ${i}, j = ${j}`);
   }
}

/* 
 * # 输出
 * i = 0, j = 0
 * i = 0, j = 1
 * i = 0, j = 2
 * i = 2, j = 0
 * i = 2, j = 1
 * i = 2, j = 2
 */
```

下面是语句块命名的例子，在语句块中你只能在 `break` 之后使用新命名。

```
foo: {
  console.log('one');
  break foo;
  console.log('这句打印不会被执行');
}
console.log('two');

/*
 * # 输出
 * one
 * two
 */
```

## ["void" 运算符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/void)

我一度以为我已经了解了所有的运算符，直到我看到了这一个。它从 [1996 年](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/1.1) 起就存在于 JS 了。所有的浏览器都支持，并且它也很容易理解，引用自 MDN：

> void 运算符对给定的表达式进行求值，然后返回 undefined。

使用它，你可以换一种方式来写立即调用的函数表达式（IIFE），就像这样：

```
void function iife() {
	console.log('hello');
}();

// 和下面等效

(function iife() {
    console.log('hello');
})()
```

使用 `void` 的一个注意点是，无论给定的表达式返回结果是什么，void 运算符的整体结果都是空的（undefined）！

```
const word = void function iife() {
	return 'hello';
}();

// word 是 `undefined`

const word = (function iife() {
	return 'hello';
})();

// word 是 "hello"
```

你也可以和 `async` 一起使用 `void`，这样你就能把函数作为异步代码的入口：

```
void async function() { 
    try {
        const response = await fetch('air.ghost.io'); 
        const text = await response.text();
        console.log(text);
    } catch(e) {
        console.error(e);
    }
}()

// 或者保持下面的写法

(async () => {
    try {
        const response = await fetch('air.ghost.io'); 
        const text = await response.text();
        console.log(text);
    } catch(e) {
        console.error(e);
    }
})();
```

## [逗号运算符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comma_Operator)

在学习了逗号运算符之后，我意识到了之前我并不完全清楚其工作原理。下面是来自 MDN 的引用：

> 逗号运算符对它的每个操作数求值（从左到右），并返回最后一个操作数的值。

```
function myFunc() {
  let x = 0;
  return (x += 1, x); // 等价于 return ++x;
}

y = false, true; // console 中得到 true
console.log(y); // false，逗号优先级低于赋值

z = (false, true); // console 中得到 true
console.log(z); // true，括号中整体返回 true
```

### 配合 [条件运算符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_Operator)

逗号运算符中的最后一个值作为返回给条件运算符的值，因此你可以在最后一个值前面放任意多个表达式。在下面的例子中，我在返回的布尔值之前放了打印语句。

```
const type = 'man';

const isMale = type === 'man' ? (
    console.log('Hi Man!'),
    true
) : (
    console.log('Hi Lady!'),
    false
);

console.log(`isMale is "${isMale}"`);
```

## [国际化 API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl)

即使在最有利的情况下，国际化还是很难做好。幸好还有一套大部分浏览器都支持得不错的 [API](https://caniuse.com/#feat=internationalization)。其中我最爱的一个特性就是日期格式化，见下面的例子：


```
const date = new Date();

const options = {
  year: 'numeric', 
  month: 'long', 
  day: 'numeric'
};

const formatter1 = new Intl.DateTimeFormat('es-es', options);
console.log(formatter1.format(date)); // 22 de diciembre de 2017

const formatter2 = new Intl.DateTimeFormat('en-us', options);
console.log(formatter2.format(date)); // December 22, 2017
```

## [管道操作符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Pipeline_operator)

在此篇成文之时，该功能只有 Firefox 58 及以上版本通过传入启动参数来支持，不过 Babel 已经有一个针对它的 [插件提议](https://github.com/babel/babel/tree/master/packages/babel-plugin-proposal-pipeline-operator)。它看起来应该是受到 bash 的启发，我觉得很棒！

```
const square = (n) => n * n;
const increment = (n) => n + 1;

// 不使用管道操作符
square(increment(square(2))); // 25

// 使用管道操作符
2 |> square |> increment |> square; // 25
```

## 值得一提

### [Atomics](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics)

当数据被多个线程共享时，原子操作确保正在读和写的数据是符合预期的，即下一个原子操作一定会在上一个原子操作结束之后才会开始。这有利于保持不同线程间的数据同步（比如主线程和另一条 WebWorker 线程）。

我很喜欢如 Java 等其它语言中的原子性。我预感当越来越多的人使用 WebWorkers，将操作从主线程分离出来时，原子操作的使用会越来越广泛。

### [Array.prototype.reduceRight](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/ReduceRight)

好吧，我之前从未见过这个，因为它基本等同于 `Array.prototype.reduce()` + `Array.prototype.reverse()` 并且你很少需要这么做。但如果你有这需求的话，`reduceRight` 是最好的选择！

```
const flattened = [[0, 1], [2, 3], [4, 5]].reduceRight(function(a, b) {
    return a.concat(b);
}, []);

// flattened array is [4, 5, 2, 3, 0, 1]
```

### [setTimeout() 参数](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout)

这个早就存在了，但如果我早点知道的话，我大概可以省去很多的 `.bind(...)`。

```
setTimeout(alert, 1000, 'Hello world!');

/*
 * # alert 输出
 * Hello World!
 */

function log(text, textTwo) {
    console.log(text, textTwo);
}

setTimeout(log, 1000, 'Hello World!', 'And Mars!');

/*
 * # 输出
 * Hello World! And Mars!
 */
```

### [HTMLElement.dataset](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/dataset)

在此之前我一直对 HTML 元素使用自定义数据属性 `data-*`，因为我不曾意识到存在一个 API 来方便地查询它们。除了个别的命名限制之外（见上面的链接），它的作用基本就是在 JS 中查询的时候允许你使用驼峰命名法（camelCase）来查询「减号-命名」（dash-case）的属性。所以属性名 `data-birth-planet` 在 JS 中就变成了 `birthPlanet`。

```
<div id='person' data-name='john' data-birth-planet='earth'></div>
```

查询：

```
let personEl = document.querySelector('#person');

console.log(personEl.dataset) // DOMStringMap {name: "john", birthPlanet: "earth"}
console.log(personEl.dataset.name) // john
console.log(personEl.dataset.birthPlanet) // earth

// 你也可以在程序中添加属性
personEl.dataset.foo = 'bar';
console.log(personEl.dataset.foo); // bar
```

## 结束语

我希望你和我一样在这里学到了一些新知识。在此也赞一下 Mozila 新的 MDN 站点，看起来非常棒，我花了比想象中更多的时间来阅读文档。

_修订: 修正几处命名并且为 `async` 函数添加 `try`, `catch`。感谢 Reddit！_

2018 新年快乐！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
