> * 原文地址：[Avoiding Memory Leaks in Node.js: Best Practices for Performance](https://blog.appsignal.com/2020/05/06/avoiding-memory-leaks-in-nodejs-best-practices-for-performance.html)
> * 原文作者：[Deepu K Sasidharan](https://twitter.com/deepu105)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/avoiding-memory-leaks-in-nodejs-best-practices-for-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2020/avoiding-memory-leaks-in-nodejs-best-practices-for-performance.md)
> * 译者：
> * 校对者：

# Avoiding Memory Leaks in Node.js: Best Practices for Performance

Memory leaks are something every developer has to eventually face. They are common in most languages, even if the language automatically manages memory for you. Memory leaks can result in problems such as application slowdowns, crashes, high latency, and so on.

In this blog post, we will look at what memory leaks are and how you can avoid them in your NodeJS application. Though this is more focused on NodeJS, it should generally apply to JavaScript and TypeScript as well. Avoiding memory leaks helps your application use resources efficiently and it also has performance benefits.

> 👋 As you’re exploring memory leaks in Node.js, you might want to explore [AppSignal for Node.js](https://appsignal.com/nodejs) as well. [We provide you with out-of-the-box support for Node.js Core, Express, Next.js, Apollo Server, node-postgres and node-redis](https://blog.appsignal.com/2020/10/07/launching-appsignal-monitoring-for-nodejs.html).

## Memory Management in JavaScript

To understand memory leaks, we first need to understand how memory is managed in NodeJS. This means understanding how memory is managed by the JavaScript engine used by NodeJS. NodeJS uses the **[V8 Engine](https://v8.dev/)** for JavaScript. You should check out [Visualizing memory management in V8 Engine](https://dev.to/deepu105/visualizing-memory-management-in-v8-engine-javascript-nodejs-deno-webassembly-105p) to get a better understanding of how memory is structured and utilized by JavaScript in V8.

Let’s do a short recap from the above-mentioned post:

Memory is mainly categorized into Stack and Heap memory.

* **Stack**: This is where static data, including method/function frames, primitive values, and pointers to objects are stored. This space is managed by the operating system (OS).
* **Heap**: This is where V8 stores objects or dynamic data. This is the biggest block of memory area and it’s where **Garbage Collection(GC)** takes place.

> V8 manages the heap memory through garbage collection. In simple terms, it frees the memory used by orphan objects, i.e, objects that are no longer referenced from the Stack, directly or indirectly (via a reference in another object), to make space for new object creation.
> 
> The garbage collector in V8 is responsible for reclaiming unused memory for reuse by the V8 process. V8 garbage collectors are generational (Objects in Heap are grouped by their age and cleared at different stages). There are two stages and three different algorithms used for garbage collection by V8.

![Mark-sweep-compact GC](https://d33wubrfki0l68.cloudfront.net/e3979bee7b7b51e6124594ea36dfde4eb7015da5/5c860/images/blog/2020-05/mark-sweep-compact.gif)

## What Are Memory Leaks

In simple terms, a memory leak is nothing but an orphan block of memory on the heap that is no longer used by the application and hasn’t been returned to the OS by the garbage collector. So in effect, it’s a useless block of memory. An accumulation of such blocks over time could lead to the application not having enough memory to work with or even your OS not having enough memory to allocate, leading to slowdowns and/or crashing of the application or even the OS.

## What Causes Memory Leaks in JS

Automatic memory management like garbage collection in V8 aims to avoid such memory leaks, for example, circular references are no longer a concern, but could still happen due to unwanted references in the Heap and could be caused by different reasons. Some of the most common reasons are described below.

* **Global variables**: Since global variables in JavaScript are referenced by the root node (window or global `this`), they are never garbage collected throughout the lifetime of the application, and will occupy memory as long as the application is running. This applies to any object referenced by the global variables and all their children as well. Having a large graph of objects referenced from the root can lead to a memory leak.
* **Multiple references**: When the same object is referenced from multiple objects, it might lead to a memory leak when one of the references is left dangling.
* **Closures**: JavaScript closures have the cool feature of memorizing its surrounding context. When a closure holds a reference to a large object in heap, it keeps the object in memory as long as the closure is in use. Which means you can easily end up in situations where a closure holding such reference can be improperly used leading to a memory leak
* **Timers & Events**: The use of setTimeout, setInterval, Observers and event listeners can cause memory leaks when heavy object references are kept in their callbacks without proper handling.

## Best Practices to Avoid Memory Leaks

Now that we understand what causes memory leaks, let’s see how to avoid them and the best practices to use to ensure efficient memory use.

### Reduce Use of Global Variables

Since global variables are never garbage collected, it’s best to ensure you don’t overuse them. Below are some ways to ensure that.

**Avoid Accidental Globals**

When you assign a value to an undeclared variable, JavaScript automatically hoists it as a global variable in default mode. This could be the result of a typo and could lead to a memory leak. Another way could be when assigning a variable to [`this`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this), which is still a holy grail in JavaScript.

1
2
3
4
5
6
7
8
9
10

// This will be hoisted as a global variable
function hello() {
    foo = "Message";
}

// This will also become a global variable as global functions have
// global \`this\` as the contextual \`this\` in non strict mode
function hello() {
    this.foo = "Message";
}

To avoid such surprises, always write JavaScript in strict mode using the `'use strict';` annotation at the top of your JS file. In strict mode, the above will result in an error. When you use ES modules or transpilers like TypeScript or Babel, you don’t need it as it’s automatically enabled. In recent versions of NodeJS, you can enable strict mode globally by passing the `--use_strict` flag when running the `node` command.

1
2
3
4
5
6
7
8
9
10
11
12

"use strict";

// This will not be hoisted as global variable
function hello() {
    foo = "Message"; // will throw runtime error
}

// This will not become global variable as global functions
// have their own \`this\` in strict mode
function hello() {
    this.foo = "Message";
}

When you use arrow functions, you also need to be mindful not to create accidental globals, and unfortunately, strict mode will not help with this. You can use the `no-invalid-this` rule from ESLint to avoid such cases. If you are not using ESLint, just make sure not to assign to `this` from global arrow functions.

1
2
3
4
5

// This will also become a global variable as arrow functions
// do not have a contextual \`this\` and instead use a lexical \`this\`
const hello = () => {
    this.foo = 'Message";
}

Finally, keep in mind not to bind global `this` to any functions using the `bind` or `call` method, as it will defeat the purpose of using strict mode and such.

**Use Global Scope Sparingly**

In general, it’s a good practice to avoid using the global scope whenever possible and to also avoid using global variables as much as possible.

1. As much as possible, don’t use the global scope. Instead, use local scope inside functions, as those will be garbage collected and memory will be freed. If you have to use a global variable due to some constraints, set the value to `null` when it’s no longer needed.
2. Use global variables only for constants, cache, and reusable singletons. Don’t use global variables for the convenience of avoiding passing values around. For sharing data between functions and classes, pass the values around as parameters or object attributes.
3. Don’t store big objects in the global scope. If you have to store them, make sure to nullify them when they are not needed. For cache objects, set a handler to clean them up once in a while and don’t let them grow indefinitely.

### Use Stack Memory Effectively

Using stack variables as much as possible helps with memory efficiency and performance as stack access is much faster than heap access. This also ensures that we don’t accidentally cause memory leaks. Of course, it’s not practical to only use static data. In real-world applications, we would have to use lots of objects and dynamic data. But we can follow some tricks to make better use of stack.

1. Avoid heap object references from stack variables when possible. Also, don’t keep unused variables.
2. Destructure and use fields needed from an object or array rather than passing around entire objects/arrays to functions, closures, timers, and event handlers. This avoids keeping a reference to objects inside closures. The fields passed might mostly be primitives, which will be kept in the stack.

1
2
3
4
5
6
7
8
9
10
11
12
13

function outer() {
    const obj = {
        foo: 1,
        bar: "hello",
    };

    const closure = () {
        const { foo } = obj;
        myFunc(foo);
    }
}

function myFunc(foo) {}

### Use Heap Memory Effectively

It’s not possible to avoid using heap memory in any realistic application, but we can make them more efficient by following some of these tips:

1. Copy objects where possible instead of passing references. Pass a reference only if the object is huge and a copy operation is expensive.
2. Avoid object mutations as much as possible. Instead, use object spread or `Object.assign` to copy them.
3. Avoid creating multiple references to the same object. Instead, make a copy of the object.
4. Use short-lived variables.
5. Avoid creating huge object trees. If they are unavoidable, try to keep them short-lived in the local scope.

### Properly Using Closures, Timers and Event Handlers

As we saw earlier, closures, timers and event handlers are other areas where memory leaks can occur. Let’s start with closures as they are the most common in JavaScript code. Look at the code below from the Meteor team. This leads to a memory leak as the `longStr` variable is never collected and keeps growing memory. The details are explained in [this blog post](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156).

1
2
3
4
5
6
7
8
9
10
11
12
13
14

var theThing = null;
var replaceThing = function () {
    var originalThing = theThing;
    var unused = function () {
        if (originalThing) console.log("hi");
    };
    theThing = {
        longStr: new Array(1000000).join("*"),
        someMethod: function () {
            console.log(someMessage);
        },
    };
};
setInterval(replaceThing, 1000);

The code above creates multiple closures, and those closures hold on to object references. The memory leak, in this case, can be fixed by nullifying `originalThing` at the end of the `replaceThing` function. Such cases can also be avoided by creating copies of the object and following the immutable approach mentioned earlier.

When it comes to timers, always remember to pass copies of objects and avoid mutations. Also, clear timers when done, using `clearTimeout` and `clearInterval` methods.

The same goes for event listeners and observers. Clear them once the job is done, don’t leave event listeners running forever, especially if they are going to hold on to any object reference from the parent scope.

## Conclusion

Memory leaks in JavaScript are not as big of a problem as they used to be, due to the evolution of the JS engines and improvements to the language, but if we are not careful, they can still happen and will cause performance issues and even application/OS crashes. The first step in ensuring that our code doesn’t cause memory leaks in a NodeJS application is to understand how the V8 engine handles memory. The next step is to understand what causes memory leaks. Once we understand this, we can try to avoid creating those scenarios altogether. And when we do hit memory leak/performance issues, we will know what to look for. When it comes to NodeJS, some tools can help as well. For example, [Node-Memwatch](https://github.com/lloyd/node-memwatch) and [Node-Inspector](https://nodejs.org/en/docs/guides/debugging-getting-started/) are great for debugging memory issues.

## References

* [Memory leak patterns in JavaScript](https://www.ibm.com/developerworks/web/library/wa-memleak/wa-memleak-pdf.pdf)
* [Memory Management](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management)
* [Cross-Browser Event Handling Using Plain ole JavaScript](https://docs.microsoft.com/en-us/previous-versions/msdn10/ff728624(v=msdn.10))
* [Four types of leaks in your JavaScript code and how to get rid of them](https://auth0.com/blog/four-types-of-leaks-in-your-javascript-code-and-how-to-get-rid-of-them/)
* [An interesting kind of JS memory leak](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156)

**P.S. If you liked this post, [subscribe to our new JavaScript Sorcery list](https://blog.appsignal.com/javascript-sorcery) for a monthly deep dive into more magical JavaScript tips and tricks.**

**P.P.S. If you’d love an all-in-one APM for Node or you’re already familiar with AppSignal, go and [check out the first version of AppSignal for Node.js](https://docs.appsignal.com/nodejs/).**

**Our guest author [Deepu K Sasidharan](https://twitter.com/deepu105) is the co-lead of the [JHipster](https://www.jhipster.tech/) platform. He is a polyglot developer and Cloud-Native Advocate currently working as a Developer Advocate at Adyen. He is also a published author, conference speaker, and blogger.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
