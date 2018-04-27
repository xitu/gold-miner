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

[这一提案](https://github.com/tc39/proposal-async-iteration) 目前处于 stage 3，浏览器已经开始实现了。处于这一阶段意味着它很有可能会被合并入标准并可以在主流浏览器中使用。但是，在此之前，规范可能会有一些小修改，因此现在使用异步迭代器会带来一定程度的风险。

[regenerator](https://github.com/facebook/regenerator) 项目目前已为异步迭代器提案提供了基本支持。但是，它本身并不支持 for-await-of 循环语法。Babel 插件 [transform-async-generator-functions](https://www.npmjs.com/package/babel-plugin-transform-async-generator-functions) 既支持异步生成器又支持 for-await-of 循环语法。

### Class 优化

[这个提案](https://github.com/tc39/proposal-private-methods) 建议向 [ECMAScript 2015 中引进的 class 语法] (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) 中加入公共字段，私有字段与私有方法。该提案是经过多个竞争提案漫长讨论和竞争后的结果。

使用私有字段和方法与它们对应的公共项是类似的，但是私有字段名方法名前会有一个 # 号。任何被标记为私有的方法和字段都不会在类之外可见，从而确保内部类成员的强封装。

下面是一个类 React 组件的假设示例，组件在私有方法中使用了公共和私有字段：

```javascript
class Counter {
  // 公共字段
  text = ‘Counter’;

  // 私有字段
  #state = {
    count: 0,
  };

  // 私有方法
  #handleClick() {
    this.#state.count++;
  }

  // 公共方法
  render() {
    return (
      <button onClick={this.handleClick.bind(this)}>
        {this.text}: {this.#state.count.toString()}
      </button>
    );
  }
}
```

使用了私有字段与私有方法的类 React 组件。

Babel 目前还没有提供私有类字段与方法的 polyfill，[但是不久就会实现](https://github.com/babel/proposals/issues/12)。公共字段已有 Babel 的[transform-class-properties](https://babeljs.io/docs/plugins/transform-class-properties/) 插件支持，但它依赖于一个已被合并入统一公共/私有字段提案的老提案。此提案于 [2017 年 9 月 1 日](https://tc39.github.io/proposal-class-fields/) 进入 stage 3，因此使用任何可用的 polyfill 都是安全的。

### Class 装饰器

装饰器是一个好例子，它在引入之后却发生了翻天覆地的变化。Babel 的第五代版本实现了[原本 stage 2 阶段装饰器的规范](https://github.com/wycats/javascript-decorators)，其将装饰器定义为接收 target，name 与属性描述的函数。现在最流行的转译装饰器方式是通过 Babel 的[transform-legacy-decorators](https://github.com/loganfsmyth/babel-plugin-transform-decorators-legacy) 插件，其实现的是旧版的规范。

[新的提案](https://tc39.github.io/proposal-decorators/) 大不相同。不再作为具有三个属性的函数，现在我们对改变描述符的类成员 —— 装饰器进行了正式描述。新的“成员描述符”与ES5中引入的属性描述符接口非常相似。

现在有两种具有不同 API 的不同类型的装饰器：成员装饰器与类装饰器。

*   成员装饰器接收成员描述符并返回成员描述符。
*   类装饰器接受每个类成员(即每个属性或方法)的构造函数、父类和成员描述符数组。

在规范中，“额外”是指可由装饰器添加的成员描述符的可选数组。这将允许装饰器动态创建新的属性与方法。比如，你可以让装饰器给属性创建 getter 与 setter 函数。

与旧规范类似，新规范允许修改类成员的描述符。此外，仍然允许在对象字面量的属性上使用装饰器。

在最终确定之前，规范很可能会发生重大变化。语法中有一些模棱两可之处，旧规范的许多痛点还没有得到解决。装饰器是语言的一个大型语法扩展，因此可以预料到这种延迟。遗憾的是，如果新的提案议被采纳，你将不得不完全重构你的装饰器函数，以适用于新的接口。

许多库作者选择继续支持旧的提案和 Babel 的 legacy-decorators 插件，即使新的提案已经处于 stage 2，旧的仍然处于 stage 0。[core-decorators](https://github.com/jayphelps/core-decorators) 作为最受欢迎的使用装饰器的 JavaScript 开源库，就采用了这种方法。未来几年中，库的作者们很有可能会继续支持旧的提案。

为了支持作者这一新提案也有可能被撤回，装饰器提案有可能不会在 2018 年并入 JavaScript。你可以在 Babel 完成[新的转译插件](https://github.com/babel/proposals/issues/11) 后使用新的装饰器提案。

### import 函数

ECMAScript 第六版中添加了 [import 语句](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)，并最终确定了新的模块系统的语义。就在近期，[主流浏览器发布更新以提供对其的支持](https://jakearchibald.com/2017/es-modules-in-browsers/)，尽管它们对于规范的实现略有不同。NodeJS 在 8.5.0 版本中对于仍带有实验标志的 ECMAScript 的模块规范提供了初步支持。

但是，该提案缺少一种异步导入模块的方法，这使得难以在运行时动态导入模块。现在，在浏览器中动态加载模块的唯一方法，就是动态插入类型为 “module” 的 script 标签，将 import 声明作为其文本内容。

实现异步导入模块的一种内置方法是提案 [动态 import 语法](https://github.com/tc39/proposal-dynamic-import)，它会调用一个“类函数”的导入模块加载表单。这种动态导入语法可以在模块代码与普通脚本代码中使用，从而为模块代码提供了一个方便的切入点。

去年有一个提案提出 System.import() 函数来解决这个问题，但是该提案没有被采纳进入最终的规范。新提案目前处于 stage 3，有望在年底前被列入规范中。

### Observables

[提议的可观察类型 Observable type](https://github.com/tc39/proposal-observable) 提供了一种处理异步数据流的标准化方法。它们已经以某种形式在许多流行的 JavaScript 框架如 RxJS 中实现。目前的提案很大程度上借鉴了这些框架的思路。

Observable 对象由 Observable 构造器创建，接收订阅函数作为参数：

```javascript
function listen(element, eventName) {
 return new Observable(observer => {
   // 创建一个事件处理函数，可以将数据输出
   let handler = event => observer.next(event);

   // 绑定事件处理函数
   element.addEventListener(eventName, handler, true);

   // 返回一个函数，调用它即去掉订阅
   return () => {
     // 解除元素的事件监听
     element.removeEventListener(eventName, handler, true);
   };
 });
}
```

Observable 构造器的使用。

使用订阅函数去订阅一个 observable 对象：

```javascript
const subscription = listen(inputElement, “keydown”).subscribe({
  next(val) { console.log("Got key: " + val) },
  error(err) { console.log("Got an error: " + err) },
  complete() { console.log("Stream complete!") },
});
```

使用 observable 对象。

subscribe() 函数返回了一个订阅对象。这个对象具有取消订阅的方法。

Observable 不应混淆于 [已废弃的 Object.observe](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/observe) 函数，Object.observe 是可以观察对象变化的一种方法。其已被 ECMAScript 2015 中更通用的的实现 [Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/observe) 所替代。

Observable 目前处于 stage 1，但它已被 TC39 委员会标记为 “ready to advance” 并获得了浏览器厂商的大力支持，因此有望很快推进到下一阶段。现在你就已经可以开始使用这一提案的特性了，有[三种 polyfill 实现](https://github.com/tc39/proposal-observable#implementations) 可供选择。

### Do Expression

CoffeeScript was well known for [making everything an expression](http://coffeescript.org/#expressions), and although the popularity of coffeescript has waned it has had an impact on the recent evolution of JavaScript.

Do-expressions are a proposed new syntax for wrapping multiple statements in a single expression. This would allow you to do the following:

```javascript
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

```javascript
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

```javascript
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
