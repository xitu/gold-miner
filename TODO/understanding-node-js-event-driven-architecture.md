> * 原文地址：[Understanding Node.js Event-Driven Architecture](https://medium.freecodecamp.com/understanding-node-js-event-driven-architecture-223292fcbc2d)
> * 原文作者：[Samer Buna](https://medium.freecodecamp.com/@samerbuna)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# 理解NodeJS中基于事件驱动的架构 #

![](https://cdn-images-1.medium.com/max/2000/1*Nozl2qd0SV8Uya2CEkF_mg.jpeg)

绝大部分的nodejs中的对象，比如HTTP请求、响应以及”流“，都使用了 `eventEmitter` 模块的支持来监听和触发事件。

![](https://cdn-images-1.medium.com/max/800/1*74K5OhiYt7WTR0WuVGeNLQ.png)

事件驱动最简单的形式是常见的 Nodejs 函数回调，例如：`fs.readFile`。事件被触发时，Node 就会调用回调函数，所以回调函数可类比为事件处理程序。

让我们来探究一下这个基础形式。

#### Node,在你准备好的时候调用我吧！ ####

以前没有原生的 promise、async/await 特性支持，Node 最原始的处理异步的方式是使用 callback。

callback 函数从本质上讲就是作为参数传递给其他函数的函数，在JS中这是可能的，因为函数是一等公民。

callback 函数并不必要异步调用，这一点非常重要。在函数中，我们可以随心所欲的同步/异步调用 callback。

例如，在下面例子中，主函数 `fileSize` 接收一个回调函数 `cb` 为参数，根据不同情况以同步/异步方式调用 `cb`：

```js
function fileSize (fileName, cb) {
  if (typeof fileName !== 'string') {
    return cb(new TypeError('argument should be string')); // 同步
  }
  
  fs.stat(fileName, (err, stats) => {
    if (err) { return cb(err); } // 异步
    
    cb(null, stats.size); // 异步
  });
}
```

请注意，这并不是一个好的实践，它也许会带来一些预期外的错误。最好将主函数设计为始终同步或始终异步地使用回调。

我们再来看看下面这种典型的用 callback 风格处理的异步 Node 函数：

```js
const readFileAsArray = function(file, cb) {
  fs.readFile(file, function(err, data) {
    if (err) {
      return cb(err);
    }

    const lines = data.toString().trim().split('\n');
    cb(null, lines);
  });
};
```

`readFileAsArray` 以文件路径和回调函数 callback 为参，读取文件并切割成行的数组来当做参数调用 callback。

这里有一个使用它的示例，假设同目录下我们有一个 `numbers.txt` 文件中有如下内容:

```
10
11
12
13
14
15
```

要找出这个文件中的奇数的个数，我们可以像下面这样调用 `readFileAsArray` 函数：

```js
readFileAsArray('./numbers.txt', (err, lines) => {
  if (err) throw err;

  const numbers = lines.map(Number);
  const oddNumbers = numbers.filter(n => n%2 === 1);
  console.log('Odd numbers count:', oddNumbers.length);
});
```

这段代码会读取数组中的字符串，解析成数字并统计奇数个数。

在 NodeJS 的回调风格中的写法是这样的：回调函数的第一个参数是一个可能为 null 的错误对象 err，而回调函数作为主函数的最后一个参数出传入。 你应该永远这么做, 因为使用者们极有可能是这么以为的。

#### 现代 JavaScript 中回调函数的替代品 ####

在 ES6+ 中，我们有了 Promise 对象。对于异步 API，它是 callback 的有力竞争者。不再需要将 callback 作为参数传递的同时处理错误信息，Promise 对象允许我们分别处理成功和失败两种情况，并且链式的调用多个异步方法避免了回调的嵌套（callback hell，回调地狱）。

如果刚刚的 `readFileAsArray` 方法允许使用 Promise，它的调用将是这个样子的：

```js
readFileAsArray('./numbers.txt')
  .then(lines => {
    const numbers = lines.map(Number);
    const oddNumbers = numbers.filter(n => n%2 === 1);
    console.log('Odd numbers count:', oddNumbers.length);
  })
  .catch(console.error);
```

作为调用 callback 的替代品，我们用 `.then` 函数来接受主方法的返回值；`.then` 中我们可以和之前在回调函数中一样处理数据，但是对于错误我们用`.catch`函数来处理。

现代 JavaScript 中的 Promise 对象，使主函数支持 Promise 接口变得更加容易。我们把刚刚的 `readFileAsArray` 方法用 Promise 来改写一下：

```js
const readFileAsArray = function(file, cb = () => {}) {
  return new Promise((resolve, reject) => {
    fs.readFile(file, function(err, data) {
      if (err) {
        reject(err);
        return cb(err);
      }
      
      const lines = data.toString().trim().split('\n');
      resolve(lines);
      cb(null, lines);
    });
  });
};
```

现在这个函数返回了一个 Promise 对象，该对象包含 `fs.readFile` 的异步调用，Promise 对象暴露了两个参数：一个 resolve 函数和 reject 函数。

reject 函数的作用就和我们之前 callback 中处理错误是一样的，而 resolve 函数也就和我们正常处理返回值是一样的。

我们剩下唯一要做的就是在实例中指定 reject resolve 函数的默认值，在 Promise 中，我们只要写一个空函数即可，例如 `(\) => {}`.

#### 在 async/await 中使用 Promise ####

当你需要循环异步函数时，使用 Promise 会让你的代码更易阅读，而如果使用回调函数，事情只会变得混乱。

Promise 是一个小小的进步，generator 是一个更大一些的小进步，但是 async/await 函数的到来，让这一步变得更有力了，它的编码风格让函数的可读性就像同步函数一样轻松。

我们用 async/await 函数特性来改写一下刚刚的调用 `readFileAsArray` 过程：

```js
async function countOdd () {
  try {
    const lines = await readFileAsArray('./numbers');
    const numbers = lines.map(Number);
    const oddCount = numbers.filter(n => n%2 === 1).length;
    console.log('Odd numbers count:', oddCount);
  } catch(err) {
    console.error(err);
  }
}

countOdd();
```

首先我们创建了一个 `async` 函数，只是在定义 function 的时候前面加了 `async` 关键字。在 `async` 函数里，使用关键字 `await` 使 `readFileAsArray` 函数好像返回普通变量一样，这之后的编码也好像 `readFileAsArray` 是同步方法一样。

当 `async` 函数执行的过程是非常易读的，而处理错误只需要使用 `try/catch` 即可。

在 `async/await` 函数中我们我们不需要使用任何特殊 API（像: `.then` 、 `.catch`\），我们仅仅使用了特殊关键字，并使用普通 JavaScript 编码即可。

我们可以在支持 Promise 的函数中使用 `async/await` 函数，但是不能在 callback 风格的异步方法中使用它，比如 `setTimeout` 等等。

### EventEmitter 模块 ###

EventEmitter 是 NodeJS 中基于事件驱动的架构的核心，它用于对象之间通信，很多 Nodejs 的原生模块都继承自这个模块。

模块的概念很简单，Emitter 对象触发已命名事件，使之前已注册的监听器被调用，所以 Emitter 对象有两个主要特征：

* 触发已命名事件
* 注册和取消注册监听函数

如何使用呢？我们只需要创建一个类来继承 EventEmitter 即可：

```js
class MyEmitter extends EventEmitter {

}
```

实例化前面我们基于 EventEmitter 创建的类，即可得到 Emitter 对象：

```js
const myEmitter = new MyEmitter();
```

在 Emitter 对象的生命周期中的任何一点，我们都可以用 emit 方法发出任何已命名的事件：

```js
myEmitter.emit('something-happened');
```

触发一个事件即某种情况发生生的信号，这些情况通常是关于 Emitter 对象的状态改变的。

我们使用 on 方法来注册，然后这些监听的方法将会在每一个 Emitter 对象 emit 的时候执行。

#### 事件 != 异步 ####

让我们看一个例子：

```js
const EventEmitter = require('events');

class WithLog extends EventEmitter {
  execute(taskFunc) {
    console.log('Before executing');
    this.emit('begin');
    taskFunc();
    this.emit('end');
    console.log('After executing');
  }
}

const withLog = new WithLog();

withLog.on('begin', () => console.log('About to execute'));
withLog.on('end', () => console.log('Done with execute'));

withLog.execute(() => console.log('*** Executing task ***'));
```

WithLog 类是一个 event emitter。它有 excute 方法，接收一个 taskFunc 任务函数作为参数，并将此函数的执行包含在 log 语句之中，分别在开始和结束的时候调用了 emit 方法。

执行结果如下：

```
Before executing
About to execute
*** Executing task ***
Done with execute
After executing
```

需要我们注意的是所有的输出 log 都是同步的，在代码里没有任何异步操作。

* 第一步 “Before executing”
* 命名为 begin 的事件 emit 导致了 “About to execute”
* 内含方法的执行输出了“\*\*\* Executing task \*\*\*”
* 另一个命名事件输出“Done with execute”
* 最后“After executing”

如同之前的 callback，events 并不意味着同步或者异步。

这一点很重要，假如我们给 `excute` 传递异步函数 `taskFunc`，事件的触发就不再精确了。

可以使用 `setImmediate` 来模拟这种情况：

```js
// ...

withLog.execute(() => {
  setImmediate(() => {
    console.log('*** Executing task ***')
  });
});
```

会输出：

```
Before executing
About to execute
Done with execute
After executing
*** Executing task ***
```

这明显有问题，异步调用之后不再精确，“Done with execute” 、 “After executing” 出现在了 “\*\*\* Executing task \*\*\*”之前（应该在后）。

当异步方法结束的时候 emit 一个事件,我们需要把 callback/promise 与事件通信结合起来，刚刚的例子证明了这一点。

使用事件驱动来代替传统 callback 有一个好处是：在定义多个 listener 后，我们可以多次对同一个 emit 做出反应。如果要用 callback 来做到这一点的话，我们需要些很多的逻辑在同一个 callback 中，事件是应用程序允许多个外部插件在应用程序核心之上构建功能的一个好方法，你可以把它们当作钩子点来允许围绕状态变化来做更多自定义的事。

#### 异步事件 ####

我们把刚刚的例子修改一下，将同步改为异步方式，让它更有意思一点：

```js
const fs = require('fs');
const EventEmitter = require('events');

class WithTime extends EventEmitter {
  execute(asyncFunc, ...args) {
    this.emit('begin');
    console.time('execute');
    asyncFunc(...args, (err, data) => {
      if (err) {
        return this.emit('error', err);
      }

      this.emit('data', data);
      console.timeEnd('execute');
      this.emit('end');
    });
  }
}

const withTime = new WithTime();

withTime.on('begin', () => console.log('About to execute'));
withTime.on('end', () => console.log('Done with execute'));

withTime.execute(fs.readFile, __filename);
```


WithTime 类执行 `asyncFunc` 函数，使用 `console.time` 和 `console.timeEnd` 来返回执行的时间，它 emit 了正确的序列在执行之前和之后，同样 emit error/data 来保证函数的正常工作。

执行之后的结果如下，正如我们期待的正确事件序列，我们得到了执行的时间，这是很有用的：

```
About to execute
execute: 4.507ms
Done with execute
```

请注意，注意我们如何将回调函数与事件发生器结合来完成的，如果 `asynFunc` 同样支持 Promise 的话，我们可以使用 `async/await` 特性来做到同样的事情：

```js
class WithTime extends EventEmitter {
  async execute(asyncFunc, ...args) {
    this.emit('begin');
    try {
      console.time('execute');
      const data = await asyncFunc(...args);
      this.emit('data', data);
      console.timeEnd('execute');
      this.emit('end');
    } catch(err) {
      this.emit('error', err);
    }
  }
}
```

这真的看起来更易读了呢！`async/await` 特性使我们的代码更加贴近 JavaScript 本身, 我认为这是一大进步。

#### 事件参数及错误 ####

在之前的例子中，我们使用了额外的参数来发射两个事件。

错误事件使用了错误对象，data 事件使用了 data 对象。

```js
this.emit('error', err);
```

data 事件使用了 data 对象。

```js
this.emit('data', data);
```

在 listener 函数调用的时候我们可以传递很多的参数，这些参数在执行的时候都会切实可用。

例如：data 事件执行的时候，listener 函数在注册的时候就会允许我们的接纳事件发射的 data 参数，而 asyncFunc 函数也实实在在暴露给了我们。

```js
withTime.on('data', (data) => {
  // do something with data
});
```

error 事件通常是特例。在我们基于 callback 的例子中，如果没用 listener 函数来处理错误，Node 进程就会直接终止-。-

我们写个例子来展示这一点：

```js
class WithTime extends EventEmitter {
  execute(asyncFunc, ...args) {
    console.time('execute');
    asyncFunc(...args, (err, data) => {
      if (err) {
        return this.emit('error', err); // Not Handled
      }

      console.timeEnd('execute');
    });
  }
}

const withTime = new WithTime();

withTime.execute(fs.readFile, ''); // BAD CALL
withTime.execute(fs.readFile, __filename);
```

上面代码中调用 excute 会触发一个错误，Node 进程会崩溃然后退出：
```bash
events.js:163
      throw er; // Unhandled 'error' event
      ^
Error: ENOENT: no such file or directory, open ''

```

第二个执行调用将受到之前崩溃的影响，并可能不会得到执行。

如果我们注册一个 listener 来处理 error 对象，情况就不一样了：

```js
withTime.on('error', (err) => {
  // do something with err, for example log it somewhere
  console.log(err)
});
```

加上了上面的错误处理，第一个 excute 调用的错误会被报告，但 Node 进程不会再崩溃退出了，其它的调用也会正常执行：
```bash
{ Error: ENOENT: no such file or directory, open '' errno: -2, code: 'ENOENT', syscall: 'open', path: '' }
execute: 4.276ms
```

记住：Node目前的表现和Promise不同 ：只是输出警告，但最终会改变：

```bash
UnhandledPromiseRejectionWarning: Unhandled promise rejection (rejection id: 1): Error: ENOENT: no such file or directory, open ''

DeprecationWarning: Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code.
```

另一种方式处理 emit 的 error 的方法是注册一个全局的 uncaughtException 进程事件，但是，全局的捕获错误对象并不是一个好办法。

关于 uncaughtException 的建议是不要使用。你一定要用的话，应该让进程在此结束：

```js
process.on('uncaughtException', (err) => {
  // something went unhandled.
  // Do any cleanup and exit anyway!

  console.error(err); // don't do just that.

  // FORCE exit the process too.
  process.exit(1);
});
```

然而，想象在同一时间发生多个错误事件。这意味着上述的 uncaughtException 监听器会多次触发，这可能对一些清理代码是一个问题。一个典型例子是, 多次调用数据库关闭操作。

EventEmitter模块暴露一个once方法。这个方法仅允许调用一次监听器, 而非每次触发都调用。所以，这是一个 uncaughtException 的实际用例,在第一次未捕获的异常发生时，我们开始做清理工作，并且知道我们最终会退出进程。

#### 监听器的顺序 ####

如果我们在同一个事件上注册多个监听器，则监听器会按顺序触发，第一个注册的监听器就是第一个触发的。

```js
// प्रथम
withTime.on('data', (data) => {
  console.log(`Length: ${data.length}`);
});

// दूसरा
withTime.on('data', (data) => {
  console.log(`Characters: ${data.toString().length}`);
});

withTime.execute(fs.readFile, __filename);
```

上面代码的输出结果里，“Length”将会在“Characters”之前，因为我们是按照这个顺序定义的。

如果你想定义一个Listener,还想插队到前面的话，要使用prependListener方法来注册

```js
// प्रथम
withTime.on('data', (data) => {
  console.log(`Length: ${data.length}`);
});

// दूसरा
withTime.prependListener('data', (data) => {
  console.log(`Characters: ${data.toString().length}`);
});

withTime.execute(fs.readFile, __filename);
```

上面的代码使得 “Characters” 在 “Length” 之前。

最后，想移除的话，用removeListener方法就好啦！



感谢阅读，下次再会，以上。

*If you found this article helpful, please click the💚 below. Follow me for more articles on Node and JavaScript.*

If you have any questions about this article or any other article I wrote, find me on [this slack account](https://slack.jscomplete.com/) (you can invite yourself) and ask in the #questions room.

I create online courses for [Pluralsight](https://www.pluralsight.com/search?q=samer+buna&amp;categories=course) and [Lynda](https://www.lynda.com/Samer-Buna/7060467-1.html) . My most recent courses are [Getting Started with React.js](https://www.pluralsight.com/courses/react-js-getting-started) , [Advanced Node.js](https://www.pluralsight.com/courses/nodejs-advanced) , and [Learning Full-stack JavaScript](https://www.lynda.com/Express-js-tutorials/Learning-Full-Stack-JavaScript-Development-MongoDB-Node-React/533304-2.html) .

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
