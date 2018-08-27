> * 原文地址：[Before you bury yourself in packages, learn the Node.js runtime itself](https://medium.freecodecamp.com/before-you-bury-yourself-in-packages-learn-the-node-js-runtime-itself-f9031fbd8b69#.91p6p8nkz)
> * 原文作者：该文章已获得作者 [Samer Buna](https://medium.freecodecamp.com/@samerbuna) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[fghpdf](https://github.com/fghpdf)
> * 校对者：[rccoder](https://github.com/rccoder)，[reid3290](https://github.com/reid3290)

# 在你沉迷于包的海洋之前，还是了解一下运行时 Node.js 的本身

![](https://cdn-images-1.medium.com/max/2000/1*LSfLSMQ1kPuHnyCPLNEKgQ.png)

这篇文章将挑战你 Node.js 的知识极限。

我在 Ryan Dahl 第一次 [介绍](https://www.youtube.com/watch?v=ztspvPYybIY) Node.js 之后不久就开始学习它，甚至一年前我也不能回答我在这篇文章中提出的许多问题。 如果你能真正地回答所有的问题，那么你的 Node.js 的知识储备是迥乎常人的。 我们应该成为朋友。

我发起这个挑战的原因可能会让你大吃一惊，我们中的许多人一直采用着错误的方式来学习 Node。大多数关于 Node 的教程，书籍和课程都关注于 Node 生态，而不是 Node 本身。 他们专注于教你使用的所有的 Node 包，例如 Express 和 Socket.IO，而不是教会你使用 Node 本身的功能。

这样做也有很好的理由。Node 是原生的和灵活的。它不提供完整的解决方案，而是提供一个丰富的，你自己能够实现的解决方案。像 Express.js  和Socket.IO 这样的库则是更完整的解决方案，因此教这些库是更有意义的，这样可以让学习者使用这些完整的解决方案。

传统的观念似乎觉得只有那些编写类库如 Express.js 和 Socket.IO 的人需要了解 Node.js 运行时的一切。但我认为这样的观点是错误的。深入理解 Node.js 本身是使用这些完整的解决方案之前最好的做法。你至少应该有足够的知识和信心来通过一个包的代码来判断你是否应该学习使用它。

这就是为什么我决定开一个完完全全专攻于 Node 本身的 [Pluralsight 课程](https://www.pluralsight.com/courses/nodejs-advanced)。在备课时，我会列出一些具体问题来确定你对 Node 本身的了解是否已经足够深入，还是需要改进。

如果你能回答这些问题并且正在找工作，请联系我！反过来说，如果大多数这些问题使你感到茫然，你则需要优先学习 Node 本身了。你所学的知识将使你成为一个更加理想的开发人员。

### Node.js 知识挑战：

其中一些问题简短而容易，而另一些则需要更长的答案和更深入的知识。它们的排名不分先后。

我知道你会在阅读这个列表后想要它们的答案。下面的建议部分有一些答案，但我也将在这篇的 freeCodeCamp 文章之后回答所有这些问题。 但让我试试你的底！

1. Node.js 和 V8 之间的关系是什么？可以在没有 V8 的情况下运行 Node 吗？
2. 当你在任何一个 Node.js 文件中声明一个全局变量时，它对于所有模块都是真的全局吗？
3. 当暴露一个 Node 模块的 API 时, 为什么我们有时候用 `exports` 有时候用 `module.exports`?
4. 我们可以依赖不使用相对路径的本地文件吗？
5. 可以在同一个应用中使用相同包的不同版本吗？
6. 什么是事件循环？它是 V8 的一部分吗？
7. 什么是调用栈？它是 V8 的一部分吗？
8. `setImmediate` 和 `process.nextTick` 的区别在哪里?
9. 如何使异步函数返回值？
10. 回调可以与 promise 一起使用吗？他们还是同一种方式还是两种不同的方式？
11. 什么 Node 模块由许多其他 Node 模块实现？
12. `spawn`、 `exec` 和 `fork` 的主要区别是什么?
13. 集群模块如何工作？它与使用负载均衡有何不同？
14. `--harmony-*` 标志是什么?
15. 如何读取和检查 Node.js 进程的内存使用情况？
16. 当调用栈和事件循环队列都为空时，Node 将做什么？
17. 什么是 V8 对象和函数模板？
18. 什么是libuv, Node.js 如何使用它？
19. 如何使 Node 的 REPL 总是使用 JavaScript 严格模式？
20. 什么是 `process.argv`？ 它拥有什么类型的数据？
21. 在 Node 进程结束之前，我们该如何做最后一个操作？该操作可以异步完成吗？
22. 你可以在 Node REPL 中使用哪些内置命令？
23. 除了 V8 和 libuv，Node 还有什么其他外部依赖？
24. 进程 `uncaughtException` 事件的问题是什么? 它和 `exit` 事件的区别是什么?
25. 在 Node’s REPL 中 `_` 意味着什么?
26. Node buffer 使用V8内存吗？可以调整他们的大小吗？
27. `Buffer.alloc` 和 `Buffer.allocUnsafe` 的区别是什么?
28. `slice` 在 buffer 上与在 array 上有什么不同?
29. `string_decoder` 模块有什么用? 它和 buffer 转字符串有何不同?
30. require 函数需要执行的 5 个主要步骤是什么？
31. 如何检查本地模块是否存在？
32.  `package.json` 的 `main` 属性有什么用?
33. 什么是 Node 中的模块循环依赖，如何避免？
34. require 函数自动尝试的 3 个文件扩展名是什么？
35. 当创建一个 HTTP 服务并对请求作出响应时, 为什么 `end()` 函数是必须的?
36. 什么情况下适合使用文件系统的 `*Sync` 方法?
37. 如何只打印深层嵌套对象的一个级别？
38. `node-gyp` 包有什么用?
39. 对象 `exports`、 `require` 和 `module` 在所有模块中都是全局的但在每一个模块中它们都不相同. 这是怎么做到的?
40. 如果你执行一个只有 `console.log(arguments);` 的 Node 脚本文件 , 实际 Node 会输出什么?
41. 如何做到一个模块可以同时被其他模块使用，并且可以通过 `node` 命令执行？
42. 举一个可读写的内置流的例子。
43. 当在 Node 脚本中执行 cluster.fork() 时会发生什么？
44. 使用事件发射器和使用简单的回调函数来允许异步处理代码有什么区别？
45. `console.time` 函数有什么用?
46. 可读流的“已暂停”和“流动”模式之间有什么区别？
47. `--inspect` 参数对于 node 命令有什么用?
48. 如何从已连接的套接字中读取数据？
49. `require` 函数总是缓存它依赖的模块. 如果需要多次执行所需模块中的代码，你可以做什么?
50. 使用流时，你何时使用管道功能以及何时使用事件？ 这两种方法可以组合吗？

### 我采取了最好的方式来学习 Node.js

学习 Node.js 可能很具有挑战性。以下的一些指南希望能在这个旅程中帮到你：

#### 学习 JavaScript 的好的部分并学习它的现代语法（ ES2015 及更高版本）

Node 是一个基于 VM 引擎的可以编译 JavaScript 的库，所以不言而喻，JavaScript 本身的重要功能是 Node 的重要功能的一个子集。故你应该从 JavaScript 本身开始学习之旅。

你理解函数、[作用域](https://edgecoders.com/function-scopes-and-block-scopes-in-javascript-25bbd7f293d7#.2h7c9bt6l)、绑定这个关键字以及新的关键字，[闭包](https://medium.freecodecamp.com/whats-a-javascript-closure-in-plain-english-please-6a1fc1d2ff1c#.fs8bxulzo)、类、模块模式、原型、回调和 promise 吗？你知道可以在 Number、String、Array、Set、Object 和 map 上使用的各种方法吗？适应这个列表上的项目，将使得学习 Node API 更容易。例如，在你很好地理解回调之前，试图学习 'fs' 模块方法可能会导致不必要的混乱。

#### 了解 Node 的非阻塞性质

回调和 promise（以及 generators/async 模式）对于 Node 特别重要。异步操作是你在 Node 中的第一课。

你可以将一个 Node 程序中的几行代码的非阻塞性质你订购星巴克咖啡的方式（在商店中，而不是得来速）相比较：

1. 下订单 | 给 Node 一些执行指令（一个函数）
2. 自定义你的订单，例如没有生奶油 | 给函数一些参数：`({whippedCream: false})`
3. 在你的订单上告诉星巴克员工你的命令 | 通过回调告诉 Node 执行你的函数： `({whippedCream: false}, callback)`
4. 然后靠边站，星巴克的员工会从排在你后面的人接到订单 | Node 将从你的后面的代码接收指令。
5. 当你要的咖啡准备好了，星巴克员工会叫你的名字，并给咖啡 | 当你的函数计算结束 Node.js 就会根据计算结果执行回调：`callback(result)`

我写了一篇博客文章来描述这个过程：[在星巴克参悟异步编程](https://edgecoders.com/asynchronous-programming-as-seen-at-starbucks-fc242cf16aa#.mx2cxr3hi)

### 了解 JavaScript 并发模型及其如何基于事件循环而运作

栈，堆和队列。如果你阅读了有关这个主题的书却仍然不完全理解，可以看看 [这个家伙](https://www.youtube.com/watch?v=8aGhZQkoFbQ)，我保证你就懂了。

[![](https://i.ytimg.com/vi/8aGhZQkoFbQ/maxresdefault.jpg)](https://www.youtube.com/embed/8aGhZQkoFbQ?wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.freecodecamp.com%2Fmedia%2Fa661a28c8cc4ab11cdfc9f9487ebd139%3FpostId%3Df9031fbd8b69&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)

Philip 解释了在浏览器中的事件循环，但在 Node.js 中其实是几乎完全相同的事情（尽管有一些差异）。

#### 了解一个 Node 进程如何不进如入 sleep 状态，并且当没有什么要做的时候就会结束进程

Node 进程可以空闲，但它从不进入 sleep 状态。它跟踪所有正在等待执行的回调，如果没有可以执行的回调它将直接结束进。为了保持 Node 进程持续运行，你可以使用一个 `setInterval` 函数，因为这将在事件循环中创建一个永久处于挂起状态的回调。

#### 学习可以使用的全局变量，如 process、module 和 Buffer

它们都定义在一个全局变量里（通常与浏览器中的 `window` 变量相比较）。在 Node 的 REPL 中，键入 `global`。并点击选项卡以查看所有可用的项目（或在空行上的简单双击标签）。其中一些项目是 JavaScript 结构（如 `Array` 和 `Object`）。其中一些是 Node 库函数（如 `setTimeout` 或 `console` 输出到 `stdout` / `stderr`），其中一些是 Node 全局对象，你可以将其用于处理某些任务（例如，`process.env` 可用于读取主机的环境变量）。

![](https://cdn-images-1.medium.com/max/2000/1*6ejru9JVwgJ9iGxBYpysJw.png)

你在表中看到大部分内容的都应该理解。

#### 了解你可以使用 Node 附带的内置库做什么，以及它们如何专注于“网络”

其中一些人会觉得熟悉，比如 *Timers*，因为他们也存在于浏览器和 Node 模拟的环境中。但是，还有更多要学习的，如 `fs`、`path`、`readline`、`http`、`net`、`stream`、`cluster`、……（上面的列表已经包含它们）。

例如，你可以使用 `fs` 读、写文件，可以使用 “`http`” 运行流式 Web 服务器，并且可以运行 tcp 服务器和使用 “`net`” 编程套接字。今天的 Node 比一年前的功能要强大得多，而且它通过社区的代码提交越来越好。在为你的任务寻找可用的包之前，请确保你无法首先使用 Node 内置的程序包完成该任务。

`event` 库特别重要，因为大多数 Node 架构都是事件驱动的。

[在这里你可以总是更多地了解 Node API](https://nodejs.org/api/all.html), 所以请继续扩展你的视野吧.

#### 理解 Node 为什么要叫 Node

你构建简单的单进程构建块（节点），可以使用良好的网络协议组织它们，以使它们彼此通信并扩展以构建大型分布式程序。简化成 Node 应用不是在此之后——它的名字就是从这里产生的。

#### 阅读并尝试理解为 Node 编写的一些代码

选择一个框架，如 Express，并尝试理解它的一些代码。告诉我你不懂的地方。当条件允许我会试着在 [slack 频道](https://slackin-bfcnswvsih.now.sh/)回答问题。

最后，用 Node 编写一个 Web 应用，而且不使用任何框架。尝试处理尽可能多的情况，使用 HTML 文件，解析查询字符串，接受表单输入，并创建一个以 JSON 响应的终端。

还可以尝试编写聊天服务器，发布 npm 包，并为开源的基于 Node 的项目做出贡献。

祝君码运昌隆！
