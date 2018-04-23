> * 原文地址：[Interesting ECMAScript 2017 proposals that weren’t adopted](https://blog.logrocket.com/interesting-ecmascript-2017-proposals-163b787cf27c)
> * 原文作者：[Kaelan Cooter](https://blog.logrocket.com/@eranimo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/interesting-ecmascript-2017-proposals.md](https://github.com/xitu/gold-miner/blob/master/TODO1/interesting-ecmascript-2017-proposals.md)
> * 译者：[Colafornia](https://github.com/Colafornia)
> * 校对者：

# 那些好玩却没有被 ECMAScript 2017 采纳的提案

![](https://cdn-images-1.medium.com/max/1000/1*kEpd3JC1gUOkupbYpik4jQ.jpeg)

要跟上所有新功能提案的进度并不容易。每年，管理 JavaScript 发展的委员会 [TC39](https://github.com/tc39) 都会收到数十个提案。由于大多数提案都不会到达第二阶段，因此很难确定哪些提案值得关注，哪些提案只是奇思妙想（或者称之为异想天开）。

由于现在又越来越多的提案，因此保持领先会非常困难。在过去的六年里，ES5 与 ES6 之间，JavaScript 的发展脚步非常保守。自 ECMAScript 2016 (ES7) 发布，发布过程要求为每年发布一次，并且[更加标准化](https://tc39.github.io/process-document/)。

随着近些年来 polyfills 和转译器的流行，一些尚属早期（early-stage）的提案甚至在还未最终确定前就已经被广泛使用了。并且，由于提案在被采纳之前会有很大变动，一些开发者可能会发现他们所使用的特性永远不会变成 JavaScript 的语言实现。

在深入研究那些我觉得很好玩的提案之前，我们先花点时间熟悉一下目前的提案流程。

### **ECMAScript 提案流程中的 5 个 stage**

Stage 0 “稻草人” —— 这是所有提案的起点。在进入下一阶段之前，提案的内容可能会发生重大变化。目前还没有提案的接收标准，任何人都可以为这一阶段提交新的提案。无需任何代码实现，规范也无需合乎标准。这个阶段的目的是开始针对该功能特性的讨论。目前已经有[超过 20 个处于 stage 0 的提案](https://github.com/tc39/proposals/blob/master/stage-0-proposals.md)。

Stage 1 “提案” —— 一个真正的正式提案。此阶段的提案需要一个[“拥护者”](https://github.com/tc39/ecma262/blob/master/FAQ.md#what-is-the-process-for-proposing-a-new-feature)（即 TC39 委员会的成员）。需仔细考虑 API 并描述出任何潜在的，代码实现方面的挑战。此阶段也需开发 plyfill 并产出 demo。在这一阶段之后提案可能会发生重大变化，因此需小心使用。目前仍处于这一阶段的提案包括了已望穿秋水的 [Observables type](https://github.com/tc39/proposal-observable) 与 [Promise.try](https://github.com/tc39/proposal-promise-try) 功能。

Stage 2 “草案” —— 此阶段将使用正式的 TC39 规范语言来精确描述语法。在此阶段后仍由可能发生一些小修改，但是规范应该足够完整，无需进行重大修订。如果一个提案走到了这一步，那么很有可能委员会是希望最终可以实现该功能的。

Stage 3 “候选” —— 该提案已获批准，仅当执行作者提出要求时才会做进一步的修改。此时你可以期待 JavaScript 引擎中开始实现提案的功能了。在这一阶段草案的 polyfill 可以安全无忧使用。

Stage 4 “完成” —— 说明提案已被采纳，提案规范将与 JavaScript 规范合并。预计不会再发生变化。JavaScript 引擎将发布它们的实现。截至 2017 年 10 月，已经有 [9 个已完成的提案](https://github.com/tc39/proposals/blob/master/finished-proposals.md)，其中最引人关注的是 [async functions](https://github.com/tc39/ecmascript-asyncawait)。

由于提案越来越多，思考一番，以下几个提案是其中更有趣的。

![](https://cdn-images-1.medium.com/max/800/1*9nMBMt-OugnruBr_M-WuEQ.png)

图源 [https://xkcd.com/927/](https://xkcd.com/927/)

### Asynchronous Iteration 异步遍历器

ECMAScript 2015 中引入了遍历器 iterator，其中包含了 **for-of** 循环语法。这使得循环遍历可迭代对象变得相当容易，并且可以实现你自己的可迭代数据结构。

遗憾的是，遍历器无法用于表示异步的数据结构如访问文件系统。虽然你可以运行 Promise.all 来遍历一系列的 promise，但这需要同步确定“已完成”的状态。

例如，可以使用异步迭代器来遍历异步内容，按需读取文件中内容，而不是提前读取文件中的所有内容。

你可以通过简单地同时使用 generator 生成器语法和 async-await 语法来定义异步生成器函数：

```javascript
async function* readLines(path) {
  let file = await fileOpen(path);

  try {
    while (!file.EOF) {
      yield await file.readLine();
    }
  } finally {
    await file.close();
  }
}
```

异步生成器函数示例。

#### 示例

可以在 for-await-of 循环中使用这个异步生成器：

```javascript
for await (const line of readLines(filePath)) {
  console.log(line);
}
```

在 for-await-of 中使用

任意具有 Symbol.asyncIterator 属性的对象都被定义为 **async iterable**，并且可使用于新的 for-await-of 语法中。这有一个具体可运行的示例：

```javascript
class LineReader() {
 constructor(filepath) {
   this.filepath = filepath;
   this.file = fileOpen(filepath);
 }

 [Symbol.asyncIterator]: {
   next() {
     return new Promise((resolve, reject) => {
       if (this.file.EOF) {
         resolve({ value: null, done: true });
       } else {
         this.file.readLine()
           .then(value => resolve({ value, done: false }))
           .catch(error => reject(error));
       }
     });
   }
 }
}
```

使用 Symbol.asyncIterator 的示例。

[The proposal](https://github.com/tc39/proposal-async-iteration) is currently at stage 3, and browsers are starting to implement it. At this stage it’s likely going to be included in the standard and eventually implemented by major browsers. However, there may be minor changes to the spec might happen before that so using async iterators today carries some degree of risk.

The [regenerator](https://github.com/facebook/regenerator) project currently has basic support for this async iterator proposal. However, regenerator alone does not support the for-await-of loop syntax. The Babel compiler has the [transform-async-generator-functions](https://www.npmjs.com/package/babel-plugin-transform-async-generator-functions) plugin which supports both async generator functions and the for-await-of loop syntax.

### Class Improvements

There is a [proposal](https://github.com/tc39/proposal-private-methods) to add public and private fields and private methods to the class syntax that was [introduced in ECMAScript 2015](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes). This proposal is the culmination of a long period of discussion and competition between various competing proposals.

Using private fields and methods is similar to their public counterparts, but with their names prepended with a hash symbol. Any method or field marked private will not be visible outside of the class, ensuring strong encapsulation of internal class members.

Here’s an example of hypothetical of a React-like component using public and private fields with a private method:

```
class Counter {
  // public field
  text = ‘Counter’;

  // private field
  #state = {
    count: 0,
  };

  // private method
  #handleClick() {
    this.#state.count++;
  }

  // public method
  render() {
    return (
      <button onClick={this.handleClick.bind(this)}>
        {this.text}: {this.#state.count.toString()}
      </button>
    );
  }
}
```

React-like component with private fields and methods.

The private class fields and methods are not currently polyfilled by Babel, [although it will be soon](https://github.com/babel/proposals/issues/12). Public fields are supported by Babel’s [transform-class-properties](https://babeljs.io/docs/plugins/transform-class-properties/) plugin, however this is based on an older proposal that was merged into this unified public / private class fields proposal. This proposal reached Stage 3 on [September 1, 2017](https://tc39.github.io/proposal-class-fields/), so it will be safe to use any polyfill when they become available.

### Class Decorators

Decorators are a good example of a proposal that has changed completely after being introduced. Babel v5 implemented the [original stage 2 decorators spec](https://github.com/wycats/javascript-decorators) which defined a decorator as a function that accepts a target, name, and property descriptor. Today the most popular way to transpile decorators is Babel’s [transform-legacy-decorators](https://github.com/loganfsmyth/babel-plugin-transform-decorators-legacy) plugin, which implements this old spec.

The [new spec](https://tc39.github.io/proposal-decorators/) is quite different. Instead of a function with three properties, we now have a formalized description of a class member — decorators being functions which mutate that descriptor. This new “member descriptor” is quite similar to the property descriptor interface introduced in ES5.

There now two different kinds of decorators with different APIs: member decorators and class decorators.

*   Member decorators takes a member descriptor and returns a member descriptor.
*   Class decorators takes a constructor, parent class, and array of member descriptors for each class member (i.e. each property or method).

In the spec, “extras” refers to an optional array of member descriptors that can be added by a decorator. This would allow a decorator to create new properties and methods dynamically. For example, you might have a decorator create getter and setter functions for a property.

Like the old spec, the new one allows you to mutate property descriptors of class members. Additionally, decorators are still allowed on properties on object literals.

It’s likely that the spec will change significantly before it’s finalized. There are ambiguities in the syntax and many of the pain points of the old spec have not been addressed. Decorators are a huge syntax extension to the language, so this delay is to be expected. Unfortunately, if the new proposal is accepted you will have to significantly refactor your decorator functions to work with the new interface.

Many library authors are choosing to continue to support the old proposal and the legacy-decorators Babel transform — even though the new proposal is at stage 2 and the old one is still at stage 0. The most popular open-source JavaScript library that uses decorators, [core-decorators](https://github.com/jayphelps/core-decorators), has taken this approach. It’s likely that decorator library authors will continue to support the old spec for years to come.

There is also a chance that this new proposal will be withdrawn in favor of another, and decorators might not make it into Javascript in 2018. You will be able to use the new decorators proposal after Babel finishes work on the [new transform plugin](https://github.com/babel/proposals/issues/11).

### Import Function

ECMAScript 6th edition added the [import statement](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) and finalized the semantics around the new module system. Major browsers [just recently](https://jakearchibald.com/2017/es-modules-in-browsers/) released support, although there are minor differences in how much of the spec they have implemented. NodeJS has released preliminary support for the ECMAScript modules in version 8.5.0 behind the — experimental-modules flag.

However, the proposal was missing an asynchronous way to import modules, makes it difficult to dynamically import module code at runtime. Right now the only way to dynamically load modules in the browser is to dynamically insert a script tag of type “module” with the import declaration as its textContent.

A build-in way of doing this is the proposed [dynamic import](https://github.com/tc39/proposal-dynamic-import) syntax, which calls for a “function-like” import module loading form. This new dynamic import syntax would be allowed in module code as well as normal script code, offering a convenient entry point for module code.

Last year there was a proposal to solve this problem by proposing a System.import() function, but that idea was eventually left out from the final specification. This new proposal is currently at stage 3, and will likely be included by the end of the year.

### Observables

The [proposed Observable type](https://github.com/tc39/proposal-observable) offers a standardized way of handling asynchronous streams of data. They have already been implemented in some form in many popular JavaScript frameworks like RxJS. The current proposal draws heavily from those libraries.

Observables are created via the Observable constructor, which takes a subscriber function:

```
function listen(element, eventName) {
 return new Observable(observer => {
   // Create an event handler which sends data to the sink
   let handler = event => observer.next(event);

   // Attach the event handler
   element.addEventListener(eventName, handler, true);

   // Return a  function which will be called to unsubscribe
   return () => {
     // Detach the event handler from the element
     element.removeEventListener(eventName, handler, true);
   };
 });
}
```

Observable constructor usage.

Use the subscribe function to subscribe to an observable:

```
const subscription = listen(inputElement, “keydown”).subscribe({
  next(val) { console.log("Got key: " + val) },
  error(err) { console.log("Got an error: " + err) },
  complete() { console.log("Stream complete!") },
});
```

Using an observable.

The subscribe() function returns a subscription object. This object has a unsubscribe method that can be used to cancel the subscription.

Observables shouldn’t be confused with the [deprecated Object.observe](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/observe) function, which was a way to observe changes to an object. That method was replaced with a more generic [Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/observe) implementation in ECMAScript 2015.

Observables are currently stage 1, but it will likely advance to the next stage soon since it has been marked as “ready to advance” by the TC39 committee and there is strong support from browser vendors. There are already [three polyfill implementations](https://github.com/tc39/proposal-observable#implementations) to choose from, so you can start using it today.

### Do Expression

CoffeeScript was well known for [making everything an expression](http://coffeescript.org/#expressions), and although the popularity of coffeescript has waned it has had an impact on the recent evolution of JavaScript.

Do-expressions are a proposed new syntax for wrapping multiple statements in a single expression. This would allow you to do the following:

```
let activeToDos = do {
  let result;
  try {
    result = fetch('/todos');
  } catch (error) {
    result = []
  }
  result.filter(item => item.active);
}
```

Do expression example.

The last statement in a do expression is implicitly returned as the completion value.

Do expressions would be quite useful inside [JSX](https://reactjs.org/docs/jsx-in-depth.html). Instead of using complicated ternary operators, a do expression would make control flow inside JSX more readable.

```
const FooComponent = ({ kind }) => (
 <div>
   {do {
     if (kind === 'bar') { <BarComponent /> }
     else if (kind === 'baz') { <BazComponent /> }
     else { <OtherComponent /> }
   }}
 </div>
)
```

The future of JSX?

Babel has a [plugin](https://babeljs.io/docs/plugins/transform-do-expressions/) to transform do-expressions. The proposal is currently at stage one and there are significant open questions around how do-expressions work with generators and async functions, so the spec might change significantly.

### Optional Chaining

Another proposal inspired by CoffeeScript is the [optional chaining proposal](https://github.com/tc39/proposal-optional-chaining) which adds an easy way to access object properties that could be undefined or null without lengthy ternary operators. This is similar to CoffeeScript’s [existential operator](http://coffeescript.org/#existential-operator) but with a few notable features missing such as scope checking and optional assignment.

Example:

```
a?.b // undefined if `a` is null/undefined, `a.b` otherwise.
a == null ? undefined : a.b // using ternary operators
```

This proposal is at stage 1 and there is a Babel plugin called [babel-plugin-transform-optional-chaining](https://www.npmjs.com/package/babel-plugin-transform-optional-chaining) which implements the proposal. The TC39 committee had concerns about the syntax in their [last meeting in October 2017](https://github.com/tc39/tc39-notes/blob/master/es8/2017-09/sep-28.md#13iii-nullary-coalescing-operator), but it seems likely that an optional chaining proposal will be adopted eventually.

### Standardized Global Object

It’s difficult to write code that can run in every JavaScript environment. In the browser, the global object is window — unless you’re in a [web worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API), then its self. In NodeJS it’s global, but that’s something added on top of the V8 engine, not a part of the specification so it’s not available when running code directly on the V8 engine.

There is a [proposal to standardize](https://github.com/tc39/proposal-global) a global object that would be available across all engines and runtime environments. It’s currently a stage 3 proposal and will therefore be accepted soon.

### And many more

There are over fifty active proposals under consideration right now by the TC39 committee, not including over twenty stage 0 proposals which haven’t advanced yet.

You can see a list of all active proposals on the TC39 committee’s [GitHub page](https://github.com/tc39/proposals). You can find some of the more rough ideas on the [stage 0 proposals](https://github.com/tc39/proposals/blob/master/stage-0-proposals.md) section, which includes ideas like [method parameter decorators](https://docs.google.com/document/d/1Qpkqf_8NzAwfD8LdnqPjXAQ2wwh8BBUGynhn-ZlCWT0/edit) and new [pattern matching syntax](https://github.com/tc39/proposal-pattern-matching).

There are also repositories of [meeting notes](https://github.com/tc39/tc39-notes) and [agendas](https://github.com/tc39/agendas) from previous TC39 meetings where you can get a interesting look at the committee’s priorities and what problems are currently being addressed. If you are interested in Presentations are also archived along with meeting nodes,

There has been several major syntax-changing proposals in recent editions of ECMAScript and this trend seems to be continuing. The pace of change is accelerating — every year there are more proposals and the 2018 edition looks like it’s going to have more accepted proposals than the 2017 edition.

This year there have been smaller proposals to add “quality of life” enhancements to the language like the proposal to add better [type checking of build-in objects](https://github.com/jasnell/proposal-istypes) or the proposal adding [degrees and radian helpers](https://github.com/rwaldron/proposal-math-extensions) to the Math module. Proposals like these add to the standard library instead of changing the syntax. They are easier to polyfill and help reduce the need to install third-party libraries. Because they don’t change syntax, they are adopted quickly and often spend less time in the proposal process.

New syntax is nice and all, but I hope we see more of these kinds of proposals in the future. Javascript is often said to be lacking a nice standard library but it’s clear that people are working to change that.

* * *

### Plug: LogRocket, a DVR for web apps

![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)

[LogRocket](https://logrocket.com) is a frontend logging tool that lets you replay problems as if they happened in your own browser. Instead of guessing why errors happen, or asking users for screenshots and log dumps, LogRocket lets you replay the session to quickly understand what went wrong. It works perfectly with any app, regardless of framework, and has plugins to log additional context from Redux, Vuex, and @ngrx/store.

In addition to logging Redux actions and state, LogRocket records console logs, JavaScript errors, stacktraces, network requests/responses with headers + bodies, browser metadata, and custom logs. It also instruments the DOM to record the HTML and CSS on the page, recreating pixel-perfect videos of even the most complex single page apps.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
