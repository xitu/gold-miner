>* 原文链接 : [Understanding JavaScript Promises, Pt. I: Background & Basics](https://scotch.io/tutorials/understanding-javascript-promises-pt-i-background-basics)
* 原文作者 : [Peleke Sengstacke](https://pub.scotch.io/@pelekes)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [hpoenixf](https://github.com/hpoenixf)，[MAYDAY1993](https://github.com/MAYDAY1993)

# 如何理解 JavaScript 中的 Promise 机制

## Promise 的世界

[原生 Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) 是在 ES2015 对 JavaScript 做出最大的改变。它的出现消除了采用 callback 机制的很多潜在问题，并允许我们采用近乎同步的逻辑去写异步代码。

可以说 promises 和 [generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*) ，代表了异步编程的新标准。不论你是否用它，你都得 _必须_ 明白它们究竟是什么。

Promise 提供了相当简单的 API ，但也增加了一点学习曲线。如果你以前从没见过它们，你会觉得这个概念很奇特，然而让你的大脑习惯它。你只需要一个平缓的介绍和大量的练习。

读完这篇文章后，你将会得到：

By the end of this article, you'll be able to:

*   清晰的知道 _为什么_ 要有 promises，以及它解决了什么问题；
*   通过它们的 _实现_ 和 _使用_ ，解释 _什么是_ promises；
*   使用 promises 重写常见的 callback 模式。

对了，有一点要注意。示例代码是跑在 Node 上的。你可以手动复制粘贴，或者直接[克隆我的仓库](https://github.com/Peleke/promises/)。

只需要 clone 到本地，然后 checkout `Part_1` 分支：

    git clone https://github.com/Peleke/promises/
    git checkout Part_1-Basics

. . . 现在可以开始了。下面是我们学习 promises 的大纲路径。


*   使用 Callbacks 的问题
*   Promises: 通过异步来说明定义  
*   Promises & 不颠倒的管理
*   使用 Promises 的控制流
*   运用 `then`， `reject`， 和 `resolve`


## 异步机制

如果你用过 JavaScript 的话，你可能知道它的基础是 [ _非阻塞_ ](https://developer.mozilla.org/en-US/docs/Web/JavaScript/EventLoop)， or _异步_ 。但这究竟是什么意思？

### 同步 & 异步

**同步代码** 将会在任何跟在它后面的代码 _之前_ 运行。你也可以吧**阻塞**作为同步的同义词，因为它  _阻塞_ 了程序接下来的执行，直到这部分代码结束。

    // readfile_sync.js

    "use strict";

    //这个例子用的是 Node ，因此不能运行在浏览器中。
    const filename = 'text.txt', 
           fs        = require('fs');

    console.log('Reading file . . . ');

    // readFileSync 操作阻塞后面代码的执行，直到它返回才能继续运行。
    //  程序将会等到这个操作结束后才会执行其它的操作。 

    const file = fs.readFileSync(`${__dirname}/${filename}`); 
    
    //这段代码只会在readFileSync返回结果后才执行 。。。
    console.log('Done reading file.');

    //而这段永远打印的是 `file` 的内容。
    console.log(`Contents: ${file.toString()}`); 

![Predictable results from readFileSync.](https://cdn.scotch.io/1/YFAlIhhTpyghE3mzYSXw_6203660244.png)

**异步代码** 则恰恰相反：它允许程序执行剩余的部分的同时处理一些耗时的操作，比如 I/O 或者网络操作。异步又叫**非阻塞代码**。下面是一段用异步实现上面功能的例子：

    // readfile_async.js

    "use strict";

    //例子用的是 Node ，因此不能运行在浏览器中。
    const filename      = 'text.txt', 
            fs            = require('fs'),
            getContents = function printContent (file) {
            try {
              return file.toString();
            } catch (TypeError) {
              return file; 
            } 
          }

    console.log('Reading file . . . ');
    console.log("=".repeat(76));

    // readFile 异步执行。 
    //   程序会继续执行 LINE A 后面的代码，
    //   与此同时 readFile 也会做自己该做到事情。接下来将深入讨论 callback (回调)  
    //   现在把注意力放在日志输出的顺序上。
    let file;
    fs.readFile(`${__dirname}/${filename}`, function (err, contents) {
      file = contents;
      console.log( `Uh, actually, now I'm done. Contents are: ${ getContents(file) }`);
    }); // LINE A

    // 下面这些日志总会在文件读取完成之前打印  

    // 好吧，这似乎有点误导和糟糕。
    console.log(`Done reading file. Contents are: ${getContents(file)}`); 
    console.log("=".repeat(76));

![Async I/O can make for confusing results.](https://cdn.scotch.io/1/eSFXleTTiVtdfMn2RFng_61ff5d552e.png)

同步代码的主要优势在于可读性强，很好理解：同步程序会自顶向下逐行执行。

同步代码的主要劣势在于经常很慢。每次你的用户点击服务时总会让浏览器卡顿两秒是多么糟糕的用户体验啊。

这就是为什么 JavaScript 内核要采用非阻塞的原因

### 异步编程的挑战

采用异步可以加快速度，但也给我们带来麻烦。即使上面这段并没有什么卵用的代码也说明了这个问题，注意：

1. 无法知道什么时候 `file` 是可用的，除非接管 `readFile` 的控制，让 _它_ 在准备好时通知我们；
2. 而且我们的程序不会像它读起来那样执行，导致我们很难理解它。


说明这些问题的篇幅足够占用我们这篇文章的剩余部分了。


## 回调(Callback) & 回退(Fallback)

接下来我们梳理一下异步 `readFile` 例子。


    "use strict";

    const filename = 'throwaway.txt',
          fs       = require('fs');

    let file, useless;

    useless = fs.readFile(`${__dirname}/${filename}`, function callback (error, contents) {
      file = contents;
      console.log( `Got it. Contents are: ${contents}`);
      console.log( `. . . But useless is still ${useless}.` );
    });

    console.log(`File is ${undefined}, but that'll change soon.`);

因为 `readFile` 是非阻塞的，它会立即返回让程序继续执行。 而 _立即_这点时间 对 I/O 操作来说远远不够，它会返回 `undefined` ，我们可以在 `readFile` 结束之前尽可能的向后执行。。。当然了，文件还在读。

问题是 _我们怎么知道读操作什么时候完成_ ？

不幸的是，我们无法知道。但 `readFile` 可以。在上面的代码片段中，我们给 `readFile` 传递了两个参数：文件名，以及名为 **callback** 的函数，这个函数会在读操作之后立即执行。

用自然语言描述就是：“ `readFile` 看看 `${__dirname}/${filename}` 里都有些什么，别着急。等你读完了把 `contents` 传给 `callback` 运行，并让我们知道是否有 `error`”

需要解决的最重要的问题是_我们_不能知道什么时候读完文件内容：只有 `readFile` 可以。这就是为什么我们要把它交给回调函数 callback，并相信_它_可以正确处理。

这就是异步函数通常的处理模式：通过多个参数调用，并传递一个回调函数来处理结果。


回调函数是 _一个_ 解决方案，但它并不完美。两个很大的问题是：

1.  颠倒的控制；
2.  糟糕的错误处理。

#### 颠倒的控制

首先这是一个信任问题。

当我们给 `readFile` 传递回调函数时，我们_相信_它会调用这个回调函数的。但并没有绝对的保证这件事。关于是否会调用，是否会传递正确的参数，是否是正确的顺序，执行次数是否正确都没有绝对的保证。

在现实中，这显然不是致命的错误：我们已经写了20多年的的回调函数也没有搞坏互联网。当然，在这种情况下，我们基本可以放心的把控制权交给 Node 内核代码了。

但把你应用的关键任务表现交个第三方是很冒险的行为，在过去这是产生大量难以解决的 [heisenbug](https://en.wikipedia.org/wiki/Heisenbug) 。

#### 糟糕的错误处理

在同步代码中我们用 `try`/`catch`/`finally` 处理错误。

    "use strict";

    //例子用的是 Node ，因此不能运行在浏览器中。
    const filename = 'text.txt', 
           fs        = require('fs');

    console.log('Reading file . . . ');

    let file;
    try {
      // Wrong filename. D'oh!
      file = fs.readFileSync(`${__dirname}/${filename + 'a'}`); 
      console.log( `Got it. Contents are: '${file}'` );
    } catch (err) {
      console.log( `There was a/n ${err}: file is ${file}` );
    }

    console.log( 'Catching errors, like a bo$.' );

异步代码会很有爱的把错误仍出窗外。
Async code lovingly tosses that out the window.

    "use strict";

    //例子用的是 Node ，因此不能运行在浏览器中。
    const filename = 'throwaway.txt', 
            fs       = require('fs');

    console.log('Reading file . . . ');

    let file;
    try {
      // Wrong filename. D'oh!
      fs.readFile(`${__dirname}/${filename + 'a'}`, function (err, contents) {
        file = contents;
      });

      // 如果文件未定义这句不会执行
      console.log( `Got it. Contents are: '${file}'` );
    } catch (err) {
      // 这种情形中 catch 应该运行，但它并不会。
      //   这是因为 readFile 把错误传给回调函数了，而不是抛出错误。
      console.log( `There was a/n ${err}: file is ${file}` );
    }

运行过程并不是我们所预想的。这是因为 `try` 语句块包裹的 `readFile`， _总会成功返回 `undefined`_ 。也就意味着 `try`  _总是_ 捕获不到异常。

让 `readFile` 通知你有错误的唯一方法就是把它传递给你的回调函数，在那里再自行处理。


    "use strict";

    // This example uses Node, and so won't run in the browser. 
    const filename = 'throwaway.txt',
            fs       = require('fs');

    console.log('Reading file . . . ');

    fs.readFile(`${__dirname}/${filename + 'a'}`, function (err, contents) {
      if (err) { // catch
        console.log( `There was a/n ${err}.` );
      } else   { // try
        console.log( `Got it. File contents are: '${file}'`);
      }
    });

这个例子还凑合，但在大型程序中会增长出大量的错误信息并且很快会变得笨重不堪。

Promises 着重解决了这两个问题，以及一些其它的问题，通过不那么颠倒的控制，以及“同步化”我们的异步代码以便我们用更加熟悉的方式做错误处理。


## Promises

想象一下你刚刚订阅了 O'Reilly [You Don't Know JS](https://github.com/getify/You-Dont-Know-JS/blob/master/README.md#you-dont-know-js-book-series) 的目录。为了换取你"血汗钱"，他们会在给你发一个承诺收据，然后你下周一会收到一堆新书。直至这之前你并不会收到这些新书。但你相信它们会发，因为它们承诺(promise)会发的。

这个 promise 已经足够了，你可以计划每天腾出一些时间来读它，答应给你朋友看，告诉你的老板你这周将要忙于读书没时间去他办公室报告工作。你制定计划时并不需要这些书，你只需要知道将你会收到它们。

当然，O'Reilly 可能会在几天后告诉你他们不能履行订单，或者其它什么原因，这时你会取消你每天安排的读书时间，告诉你朋友你无法收到图书了，告诉你的老板你下周可以去给他汇报工作了。


**promise** 就像一个收据。它代表着还没有准备好的值，但等它准备好了才可以用，换句话说它是一个 _未来值_ 。你把 promises 当做你等待的值，并在写代码时假设它是可用的。

在这里有个个小问题，Promises 会立即处理打断控制流，并允许你使用 `catch` 关键字处理错误。它和同步版本有些小小的不同，但不管怎么说在处理协调多个错误处理上要比回调机制更方便。

因为 promises 会在值准备好时把它交给你，由你来决定怎么用它。这修复了颠倒控制的问题：你可以直接处理你的应用逻辑，没必要把控制权给第三方。

### Promise 生命周期：关于状态的简单介绍

想象一下你用 Promises 实现 API 调用。

因为服务器不能即刻响应，Promises 不会立即包含最终值，当然也不能立即报告错误。这种状态对 Promises 来说叫做 **pending**。这就相当于你在等你的新书的状态。

一旦服务器响应了，将可能有两种可能的输出。

1.  Promise 获得了它想要的值，这是 **fulfilled** 状态。这就相当于你收到你书的订单。
2.  在事件中传递路径的某个地方出了错，这是 **rejected** 状态。这相当于你收到你不能得到书的通知。

总之，在 Promise 有三种可能的**状态**。一旦 Promise 处于 fulfilled 或者 rejected 状态， 就再_不能_转换为其它任何状态。

现在术语介绍完了，现在看看我们怎么用它。


## Promises 的基本方法

引用自[Promises/A+ spec](https://promisesaplus.com/):

> Promise 代表着异步操作的最终结果。与 promise 交互的最主要方式就是使用 `then` 方法，注册回调函数可以接收 promises 的最终值，或者失败原因。

这节将会详细了解 Promises 的基本用法：

1.  用构造器创建 Promises；
2.  用 `resolve` 处理成功；
3.  用 `reject` 处理失败；
4.  以及用 `then` 和 `catch` 设置控制流。

在这个例子中，我们会用 Promises 优化上面的 `fs.readFile` 代码。

## 创建 Promises

创建 Promise 的最基本方法就是直接使用构造器。

    'use strict';

    const fs = require('fs');

    const text = 
      new Promise(function (resolve, reject) {
          // Does nothing
      })

注意我们给 Promise 构造器传递了一个函数作为参数。在这里我们告诉 Promise _怎么_ 执行异步操作，得到我们想要的值之后做什么，以及如果发生错误怎么处理。细节:

1.  `resolve` 参数是一个函数，包括我们收到**期待值**时做什么。当我们得到期待的值 (`val`)时 用 `resolve(val)` 调用 `resolve`。
2.  `reject` 参数也是一个函数，代表着我们接到错误之后怎么处理。如果接到错误 (`err`)，通过 `reject(err)` 调用 `reject` 。
3.  最后我们传给 Promise 构造器的函数自己处理异步代码。如果返回值和预期一样，用接收到的值调用 `resolve`；如果抛出异常，用错误调用 `reject`。

我们运行的例子是把 `fs.readFile` 包裹在 Promise 中。那么 `resolve` 和 `reject` 长什么样呢?

1.  事件成功时，我们用 `console.log` 打印内容。
2.  事件错误时，也用 `console.log` 打印错误。

像下面这样。

    // constructor.js

    const resolve = console.log, 
          reject = console.log;

接下来，我们需要完成给构造器传递的函数。记着，我们的任务是：

1.  读文件
2.  当成功时 `resolve` 内容；
3.  否则， `reject` 。

Thus:

    // constructor.js

    const text = 
      new Promise(function (resolve, reject) {
        // 普通的 fs.readFile 调用，但是在 Promise constructor 内部 . . . 
        fs.readFile('text.txt', function (err, text) {
          // . . . 如果有错误调用 reject . . . 
          if (err) 
            reject(err);
          // . . . 否则调用 resolve 。
          else
        //  fs.readFile 返回的是 buffer ，我们需要 toString() 转为 String。
            resolve(text.toString());
        })
      })
      
到这，技术部分结束了：这段代码代码创建了一个 Promises 它会严格按照我们的意愿执行。但如果你执行这段代码，你会发现它既没有打印结果也没有打印错误。


## 她做出了承诺(Promise)，然后(then) . . .

问题是我们写了 `resolve` 和 `reject` 方法，但没有传递给 Promise！接下来我们介绍设置 Promise 的流程控制： `then`。

每个 Promise 都有个叫 `then` 的方法，它接受两个函数做参数：`resolve` 和 `reject`， _按照顺序传递_。 调用 Promise 的 `then` 并把这些函数传给构造器，构造器将能够调用这些传入的函数。

    // constructor.js

    const text = 
      new Promise(function (resolve, reject) {
        fs.readFile('text.txt', function (err, text) {
          if (err) 
            reject(err);
          else
            resolve(text.toString());
        })
      })
      .then(resolve, reject);

这样我们的 Promise 就可以读文件并调用 `resolve` 方法。

一定要记得调用 `then` **返回的一定是一个 Promise 对象**。这意味着你可以链式调用 `then` 方法，从而为异步操作创建复杂，类似同步那样的控制流。再下一篇文章时我们会就这点更深入一些细节，下一个小节我们将会深入讲解 `catch` 的例子。

## 捕获异常的语法糖。

我们需要传递两个函数给 `then`： `resolve`，用于事件成功时调用， `reject`用于错误产生时调用。



Promises 还提供了类似 `then`的函数， `catch`。它接受一个 reject 作为处理器(handler)。

因为 `then` 总是返回一个 Promise，所以在上面的例子中，我们可以只给 `then` 传递一个 resolve 处理器(handler),然后链式调用 `catch` 并传一个 reject  处理器(handler)。

    const text = 
      new Promise(function (resolve, reject) {
        fs.readFile('tex.txt', function (err, text) {
          if (err) 
            reject(err);
          else
            resolve(text.toString());
        })
      })
      .then(resolve)
      .catch(reject);

最后值得一提的是 `catch(reject)`  只是 `then(undefined, reject)` 形式的一个语法糖。因此也可以这样写：

    const text = 
      new Promise(function (resolve, reject) {
        fs.readFile('tex.txt', function (err, text) {
          if (err) 
            reject(err);
          else
            resolve(text.toString());
        })
      })
      .then(resolve)
      .then(undefined, reject);

. . . 但这样可读性就下降了好多。

## 结束语


Promises 在异步编程中不可缺少的编程工具。起初看起来挺吓人，但这仅仅是因为你不熟悉而已：用过一段时间，你就会觉得它们像 `if`/`else` 一样自然了。

下一次，我们将会把回调模式的代码转换为用 Promises 实现，并学习一下 [Q](https://github.com/kriskowal/q)，一个很流行的 Promises 库。

现在可以读读我们开头订阅的系列书中 Domenic Denicola 的[States and Fates](https://github.com/domenic/promises-unwrapping/blob/master/docs/states-and-fates.md) 来掌握术语，读 Kyle Simpson 关于 [Promises](https://github.com/getify/You-Dont-Know-JS/blob/master/async%20%26%20performance/ch3.md) 章节。

像往常一样，你可以在文章下面评论，或者在 Twitter 上([@PelekeS](http://www.twitter.com/PelekeS))。我一定会回复的！


