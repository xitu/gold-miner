> * 原文地址：[Before you bury yourself in packages, learn the Node.js runtime itself](https://medium.freecodecamp.com/before-you-bury-yourself-in-packages-learn-the-node-js-runtime-itself-f9031fbd8b69#.91p6p8nkz)
> * 原文作者：该文章已获得作者 [Samer Buna](https://medium.freecodecamp.com/@samerbuna) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： 
> * 校对者：

# Before you bury yourself in packages, learn the Node.js runtime itself

![](https://cdn-images-1.medium.com/max/2000/1*LSfLSMQ1kPuHnyCPLNEKgQ.png)

This article will challenge the very limits of your Node.js knowledge.

I started learning Node.js shortly after Ryan Dahl first [presented](https://www.youtube.com/watch?v=ztspvPYybIY) it, and I wasn’t able to answer a lot of the questions I ask in this article even a year ago. If you can truly answer all of these questions, then your knowledge of Node.js is beyond great. We should be friends.

The reason I think this challenge will take you by surprise is that many of us have been mostly learning Node the wrong way. Most tutorials, books, and courses about Node focus on the Node ecosystem — not the Node runtime itself. They focus on teaching what can be done with all the packages available for you when you work with Node, like Express and Socket.IO, rather than teaching the capabilities of the Node runtime itself.

There are good reasons for this. Node is raw and flexible. It doesn’t provide complete solutions, but rather provides a rich runtime that enables you to implement solutions of your own. Libraries like Express.js and Socket.IO are more of complete solutions, so it makes more sense to teach those libraries, so you can enable learners to use these complete solutions.

The conventional wisdom seems to be that only those whose job is to write libraries like Express.js and Socket.IO need to understand everything about the Node.js runtime. But I think this is wrong. A solid understanding of the Node.js runtime itself is the best thing you can do before using those complete solutions. You should at least have the knowledge and confidence to judge a package by its code, so you can make an educated decision about using it.

This is why I decided to create a [Pluralsight course](https://www.pluralsight.com/courses/nodejs-advanced) fully dedicated to pure Node. While doing the research for the course, I put together a list of specific questions for you to determine whether your knowledge of the Node runtime is already strong enough, or if it could be improved.

If you can answer most of these questions and you’re looking for a job, let me know! If on the other hand, most of these questions take you by surprise, you just need to make learning the Node runtime itself a priority. Your knowledge of that will make you a much more desirable developer.

### The Node.js knowledge challenge:

Some of these questions are short and easy while others require longer answers and deeper knowledge. They are all presented here in no particular order.

I know that you’re going to want answers after reading this list. The advice section below has some answers, but I’ll also be answering all of these questions in a series of freeCodeCamp articles after this one. But let me tease your knowledge first!

1. What is the relationship between Node.js and V8? Can Node work without V8?
2. How come when you declare a global variable in any Node.js file it’s not really global to all modules?
3. When exporting the API of a Node module, why can we sometimes use `exports` and other times we have to use `module.exports`?
4. Can we require local files without using relative paths?
5. Can different versions of the same package be used in the same application?
6. What is the Event Loop? Is it part of V8?
7. What is the Call Stack? Is it part of V8?
8. What is the difference between `setImmediate` and `process.nextTick`?
9. How do you make an asynchronous function return a value?
10. Can callbacks be used with promises or is it one way or the other?
11. What Node module is implemented by most other Node modules?
12. What are the major differences between `spawn`, `exec`, and `fork`?
13. How does the cluster module work? How is it different than using a load balancer?
14. What are the `--harmony-*` flags?
15. How can you read and inspect the memory usage of a Node.js process?
16. What will Node do when both the call stack and the event loop queue are empty?
17. What are V8 object and function templates?
18. What is libuv and how does Node.js use it?
19. How can you make Node’s REPL always use JavaScript strict mode?
20. What is `process.argv`? What type of data does it hold?
21. How can we do one final operation before a Node process exits? Can that operation be done asynchronously?
22. What are some of the built-in dot commands that you can use in Node’s REPL?
23. Besides V8 and libuv, what other external dependencies does Node have?
24. What’s the problem with the process `uncaughtException` event? How is it different than the `exit` event?
25. What does the `_` mean inside of Node’s REPL?
26. Do Node buffers use V8 memory? Can they be resized?
27. What’s the difference between `Buffer.alloc` and `Buffer.allocUnsafe`?
28. How is the `slice` method on buffers different from that on arrays?
29. What is the `string_decoder` module useful for? How is it different than casting buffers to strings?
30. What are the 5 major steps that the require function does?
31. How can you check for the existence of a local module?
32. What is the `main` property in `package.json` useful for?
33. What are circular modular dependencies in Node and how can they be avoided?
34. What are the 3 file extensions that will be automatically tried by the require function?
35. When creating an http server and writing a response for a request, why is the `end()` function required?
36. When is it ok to use the file system `*Sync` methods?
37. How can you print only one level of a deeply nested object?
38. What is the `node-gyp` package used for?
39. The objects `exports`, `require`, and `module` are all globally available in every module but they are different in every module. How?
40. If you execute a node script file that has the single line: `console.log(arguments);`, what exactly will node print?
41. How can a module be both requirable by other modules and executable directly using the `node` command?
42. What’s an example of a built-in stream in Node that is both readable and writable?
43. What happens when the line cluster.fork() gets executed in a Node script?
44. What’s the difference between using event emitters and using simple callback functions to allow for asynchronous handling of code?
45. What is the `console.time` function useful for?
46. What’s the difference between the Paused and the Flowing modes of readable streams?
47. What does the `--inspect` argument do for the node command?
48. How can you read data from a connected socket?
49. The `require` function always caches the module it requires. What can you do if you need to execute the code in a required module many times?
50. When working with streams, when do you use the pipe function and when do you use events? Can those two methods be combined?

### My take on the best way to learn the Node.js runtime

Learning Node.js can be challenging. Here are some of the guidelines that I hope will help along that journey:

#### Learn the good parts of JavaScript and learn its modern syntax (ES2015 and beyond)

Node is a set of libraries on top of a VM engine which can compile JavaScript so it goes without saying that the important skills for JavaScript itself is a subset of the important skills for Node. You should start with JavaScript itself.

Do you understand functions, [scopes](https://edgecoders.com/function-scopes-and-block-scopes-in-javascript-25bbd7f293d7#.2h7c9bt6l), binding, this keyword, new keyword, [closures](https://medium.freecodecamp.com/whats-a-javascript-closure-in-plain-english-please-6a1fc1d2ff1c#.fs8bxulzo), classes, module patterns, prototypes, callbacks, and promises? Are you aware of the various methods that can be used on Numbers, Strings, Arrays, Sets, Objects, and Maps? Getting yourself comfortable with the items on this list will make learning the Node API much easier. For example, trying to learn the ‘fs’ module methods before you have a good understanding of callbacks may lead to unnecessary confusion.

#### Understand the non-blocking nature of Node

Callbacks and promises (and generators/async patterns) are especially important for Node. You need to understand how asynchronous operations are first class in Node.

You can compare the non-blocking nature of lines of code in a Node program to the way you order a Starbucks coffee (in the store, not the drive-thru):

1. Place your order | Give Node some instructions to execute (a function)
2. Customize your order, no whipped cream for example | Give the function some arguments: `({whippedCream: false})`
3. Give the Starbucks worker your name with the order | Give Node a callback with your function: `({whippedCream: false}, callback)`
4. Step aside and the Starbucks worker will take orders from people who were after you in line | Node will take instructions from lines after yours.
5. When your order is ready, the Starbucks worker will call your name and give you your order | When your function is computed and Node.js has a ready result for you, it’ll call your callback with that result: `callback(result)`

I’ve written a blog post about this: [Asynchronous Programming as Seen at Starbucks](https://edgecoders.com/asynchronous-programming-as-seen-at-starbucks-fc242cf16aa#.mx2cxr3hi)

### Learn the JavaScript concurrency model and how it is based on an event loop

There is a Stack, a Heap, and a Queue. You can read books on this subject and still not understand it completely, but I guarantee you’ll do if you watch [this guy](https://www.youtube.com/watch?v=8aGhZQkoFbQ).

[![](https://i.ytimg.com/vi/8aGhZQkoFbQ/maxresdefault.jpg)](https://www.youtube.com/embed/8aGhZQkoFbQ?wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.freecodecamp.com%2Fmedia%2Fa661a28c8cc4ab11cdfc9f9487ebd139%3FpostId%3Df9031fbd8b69&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)

Philip explains the Event Loop that’s in the browser, but almost the exact same thing applies to Node.js (there are some differences).

#### Understand how a Node process never sleeps, and will exit when there is nothing left to do

A Node process can be idle but it never sleeps. It keeps track of all the callbacks that are pending and if there is nothing left to execute it will simply exit. To keep a Node process running you can for example use a `setInterval` function because that would create a permanent pending callback in the Event Loop.

#### Learn the global variables that you can use like process, module, and Buffer

They’re all defined on a global variable (which is usually compared to the `window` variable in browsers). In a Node’s REPL, type `global.` and hit tab to see all the items available (or simple double-tab on an empty line). Some of these items are JavaScript structures (like `Array` and `Object`). Some of them are Node library functions (like `setTimeout`, or `console` to print to `stdout`/`stderr`), and some of them are Node global objects that you can use for certain tasks (for example, `process.env` can be used to read the host environment variables).

![](https://cdn-images-1.medium.com/max/2000/1*6ejru9JVwgJ9iGxBYpysJw.png)

You need to understand most of what you see in that list.

#### Learn what you can do with the built-in libraries that ship with Node and how they have a focus on “networking”

Some of those will feel familiar, like *Timers* for example, because they also exist in the browser and Node is simulating that environment. However, there is much more to learn, like `fs`, `path`, `readline`, `http`, `net`, `stream`, `cluster`, ... (The auto-complete list above has them all).

For example, you can read/write files with `fs`, you can run a streaming-ready web server using “`http`”, and you can run a tcp server and program sockets with “`net`”. Node today is so much more powerful than it was just a year ago, and it’s getting better by the commit. Before you look for a package to do some task, make sure that you can’t do that task with the built-in Node packages first.

The `events` library is especially important because most of Node architecture is event-driven.

There’s always [more that you can learn about the Node API](https://nodejs.org/api/all.html), so keep expanding your horizons.

#### Understand why Node is named Node

You build simple single-process building blocks (nodes) that can be organized with good networking protocols to have them communicate with each other and scale up to build large distributed programs. Scaling a Node application is not an afterthought — it’s built right into the name.

#### Read and try to understand some code written for Node

Pick a framework, like Express, and try to understand some of its code. Ask specific questions about the things you don’t understand. I try to answer questions on the [jsComplete slack channel](https://slackin-bfcnswvsih.now.sh/) when I can.

Finally, write a web application in Node without using any frameworks. Try to handle as many cases as you can, respond with an HTML file, parse query strings, accept form input, and create an endpoint that responds with JSON.

Also try writing a chat server, publishing an npm package, and contributing to an open-source Node-based project.

Good luck!
