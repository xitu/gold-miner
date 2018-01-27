> * 原文地址：[JS things I never knew existed](https://air.ghost.io/js-things-i-never-knew-existed/)
> * 原文作者：[Skyllo](https://air.ghost.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/js-things-i-never-knew-existed.md](https://github.com/xitu/gold-miner/blob/master/TODO/js-things-i-never-knew-existed.md)
> * 译者：
> * 校对者：

# JS things I never knew existed

I was reading through the MDN docs the other day and found these JS features and APIs I never knew existed. So here is a short list of those things, useful or not - learning JS seemingly never ends.

## [Label Statements](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/label)

You can name `for` loops and blocks in JS... who knew (not me)! You can then refer to that name and use `break` or `continue` in `for` loops and `break` in blocks.

```
loop1: // labeling "loop1" 
for (let i = 0; i < 3; i++) { // "loop1"
   loop2: // labeling "loop2"
   for (let j = 0; j < 3; j++) { // "loop2"
      if (i === 1) {
         continue loop1; // continues upper "loop1"
         // break loop1; // breaks out of upper "loop1"
      }
      console.log(`i = ${i}, j = ${j}`);
   }
}

/* 
 * # Output
 * i = 0, j = 0
 * i = 0, j = 1
 * i = 0, j = 2
 * i = 2, j = 0
 * i = 2, j = 1
 * i = 2, j = 2
 */
```

Here is an example of block naming, you can only use `break` in blocks.

```
foo: {
  console.log('one');
  break foo;
  console.log('this log will not be executed');
}
console.log('two');

/*
 * # Output
 * one
 * two
 */
```

## ["void" Operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/void)

I thought I knew all the operators until I saw this one which has been in [JS since 1996](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/1.1). It's supported by all browers and its pretty easy to understand, quote from MDN:

> The void operator evaluates the given expression and then returns undefined.

This allow you to write an alternative IIFE like this:

```
void function iife() {
	console.log('hello');
}();

// is the same as...

(function iife() {
    console.log('hello');
})()
```

One cavaet with `void` is the evaluation of the expression is... void (undefined)!

```
const word = void function iife() {
	return 'hello';
}();

// word is "undefined"

const word = (function iife() {
	return 'hello';
})();

// word is "hello"
```

You can also use `void` with `async`, you could then use it as an asynchronous entry point to your code:

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

// or just stick to this :)

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

## [Comma Operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comma_Operator)

After reading about the comma operator, I realised I was not fully aware of how it works. Here is a good quote from MDN:

> The comma operator evaluates each of its operands (from left to right) and returns the value of the last operand.

```
function myFunc() {
  let x = 0;
  return (x += 1, x); // same as return ++x;
}

y = false, true; // returns true in console
console.log(y); // false (left-most)

z = (false, true); // returns true in console
console.log(z); // true (right-most)
```

### With [Conditional Operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_Operator)

The last value in the comma operator becomes the return value for the conditional. So you can put any number of expressions before it, in the example below I put a console log before the returned boolean value.

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

## [Internationalization API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl)

Internationalization is difficult to get right at the best of times, luckily there is a [well supported](https://caniuse.com/#feat=internationalization) API for it now in most browsers. One of my favourite features from it is the date formatter, see example below.

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

## [Pipeline Operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Pipeline_operator)

At time of writing this is only supported in Firefox 58+ behind a flag, however Babel does already have a proposal plugin for it [here](https://github.com/babel/babel/tree/master/packages/babel-plugin-proposal-pipeline-operator). It looks very bash inspired and I like it!

```
const square = (n) => n * n;
const increment = (n) => n + 1;

// without pipeline operator
square(increment(square(2))); // 25

// with pipeline operator
2 |> square |> increment |> square; // 25
```

## Notable Mentions

### [Atomics](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics)

Atomic operations give predictable read and write values when data is shared between the multiple threads, waiting for other operations to finish before the next one is executed. Useful for keeping data in sync between things like the main thread and another WebWorker.

I really like Atomics in other languages like Java. I feel these will be used more in JS when more of us use WebWorkers to move operations away from the main thread.

### [Array.prototype.reduceRight](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/ReduceRight)

Ok, I've never seen this used because its basically `Array.prototype.reduce()` + `Array.prototype.reverse()` and its quite rare you need to do that. If you do... then `reduceRight` is perfect!

```
const flattened = [[0, 1], [2, 3], [4, 5]].reduceRight(function(a, b) {
    return a.concat(b);
}, []);

// flattened array is [4, 5, 2, 3, 0, 1]
```

### [setTimeout() Parameters](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval)

I could of probably saved myself a `.bind(...)` or two by knowing this - and it's been around forever.

```
setTimeout(alert, 1000, 'Hello world!');

/*
 * # Output (alert)
 * Hello World!
 */

function log(text, textTwo) {
    console.log(text, textTwo);
}

setTimeout(log, 1000, 'Hello World!', 'And Mars!');

/*
 * # Output
 * Hello World! And Mars!
 */
```

### [HTMLElement.dataset](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/dataset)

I had used custom data attributes `data-*` on HTML elements before now but I blissfully was unaware there was an API to query them easily. Apart from a few naming restrictions (see link above) it's essentially dash-case naming for attributes and camelCase when querying them in JS. So attribute `data-birth-planet` would become `birthPlanet` in JS.

```
<div id='person' data-name='john' data-birth-planet='earth'></div>
```

Query:

```
let personEl = document.querySelector('#person');

console.log(personEl.dataset) // DOMStringMap {name: "john", birthPlanet: "earth"}
console.log(personEl.dataset.name) // john
console.log(personEl.dataset.birthPlanet) // earth

// you can programmatically add more too
personEl.dataset.foo = 'bar';
console.log(personEl.dataset.foo); // bar
```

## End

Hope you discovered something new in the list for JS like I did. Shout out to Mozilla for the new MDN site, looks much nicer in my opinion - I spent way longer than I thought reading through it.

_Edit: Fixed some naming and added `try`, `catch` to `async` functions. Thanks Reddit!_

Happy New 2018!

![Nick](/content/images/2018/01/me.jpg)

#### [Nick](/author/skyllo/)

Full Stack Developer 👾 [Read More](/author/skyllo/)</div>


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
