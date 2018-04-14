> * 原文地址：[Interesting ECMAScript 2017 proposals that weren’t adopted](https://blog.logrocket.com/interesting-ecmascript-2017-proposals-163b787cf27c)
> * 原文作者：[Kaelan Cooter](https://blog.logrocket.com/@eranimo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/interesting-ecmascript-2017-proposals.md](https://github.com/xitu/gold-miner/blob/master/TODO1/interesting-ecmascript-2017-proposals.md)
> * 译者：
> * 校对者：

# Interesting ECMAScript 2017 proposals that weren’t adopted

![](https://cdn-images-1.medium.com/max/1000/1*kEpd3JC1gUOkupbYpik4jQ.jpeg)

It’s hard to keep up to date with all the new feature proposals. Every year dozens are proposed to the [TC39](https://github.com/tc39) committee which controls the evolution of JavaScript. Because many of them will never reach the second stage, it’s difficult to know which ones to keep track of and which are mere novelties (or just crazy ideas).

One reason it can be tough to stay on top of feature proposals is that there are a lot more of them now. The development pace of JavaScript used to be much more conservative — six years passed between ES5 and ES6\. Since ECMAScript 2016 (ES7), the process calls for yearly releases and is [considerably more standardized](https://tc39.github.io/process-document/).

Because polyfills and transpilers have become popular in recent years, some early-stage proposals have gained significant adoption before they’ve even been finalized. And, because proposals can change widely before being accepted, some might find that they’re using a feature that will never be part of the language.

Before getting into the proposals that I think are most interesting, let’s take a second to familiarize ourselves with the current process.

### **The five stages of the ECMAScript proposal process**

Stage 0 “strawman” — The starting point for all proposals. These can change significantly before advancing to the next stage. There is no acceptance criteria and anyone can make a new proposal for this stage. There doesn’t need to be any implementation and the spec isn’t held to any standard. This stage is intended to start a discussion about the feature. There are currently [over twenty](https://github.com/tc39/proposals/blob/master/stage-0-proposals.md) stage 0 proposals.

Stage 1 “proposal” — An actual formal proposal. These require a [“champion”](https://github.com/tc39/ecma262/blob/master/FAQ.md#what-is-the-process-for-proposing-a-new-feature)(i.e. a member of TC39 committee). At this stage the API should be well thought out and any potential implementation challenges should be outlined. At this stage, a polyfill is developed and demos produced. Major changes might happen after this stage, so use with caution. Proposals at this stage include the long-awaited [Observables type](https://github.com/tc39/proposal-observable) and the [Promise.try](https://github.com/tc39/proposal-promise-try) function.

Stage 2 “draft” — At this stage the syntax is precisely described using the formal TC39 spec language. Minor editorial changes might still happen after this stage, but the specification should be complete enough not to need major revisions. If a proposal makes it this far, it’s a good bet that the committee expects the feature to be included eventually.

Stage 3 “candidate” — The proposal has approved and further changes will only occur at the request of implementation authors. Here is where you can expect implementation to begin in JavaScript engines. Polyfills for proposals at this stage are safe to use without worry.

Stage 4 “finished” — Indicates that the proposal has been accepted and the specification has been merged with the main JavaScript spec. No further changes are expected. JavaScript engines are expected to ship their implementations. As of October 2017 there are [nine finished proposals](https://github.com/tc39/proposals/blob/master/finished-proposals.md), most notably [async functions](https://github.com/tc39/ecmascript-asyncawait).

Since there are so many proposals, here are a few of the more interesting ones currently under consideration.

![](https://cdn-images-1.medium.com/max/800/1*9nMBMt-OugnruBr_M-WuEQ.png)

[https://xkcd.com/927/](https://xkcd.com/927/)

### Asynchronous Iteration

ECMAScript 2015 added iterators, including the _for-of_ loop syntax. This made it considerably easy to loop over iterable objects and made it possible to implement your own iterable data structures.

Unfortunately, iterators can’t be used to represent asynchronous data structures like accessing the file system. While you could always run Promise.all and loop over an array of promises, that requires synchronous determination of the “done” state.

For example, instead of reading all the lines from a file before working with them, with async iterators you can simply loop over an async iterable that reads the lines as you need them.

You can define a async generator function by simply using both the generator syntax and the async-await syntax together:

```
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

Async generator function example.

#### Example

You can then use this async generator in a for-await-of loop:

```
for await (const line of readLines(filePath)) {
  console.log(line);
}
```

Using for-await-of.

Any object that has a Symbol.asyncIterator property is defined as being _async iterable_ and can be used with the new for-await-of syntax. Here’s an example of this in action:

```
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

Using Symbol.asyncIterator.

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
