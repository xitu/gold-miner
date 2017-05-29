> * 原文地址：[Understanding Node.js Event-Driven Architecture](https://medium.freecodecamp.com/understanding-node-js-event-driven-architecture-223292fcbc2d)
> * 原文作者：[Samer Buna](https://medium.freecodecamp.com/@samerbuna)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# 理解NodeJS中基于事件驱动的架构 #

![](https://cdn-images-1.medium.com/max/2000/1*Nozl2qd0SV8Uya2CEkF_mg.jpeg)

对于绝大部分的nodejs中的对象，比如HTTP请求、相应以及'流',他们都是使用了`eventEmitter`模块的支持来监听和发射事件。

![](https://cdn-images-1.medium.com/max/800/1*74K5OhiYt7WTR0WuVGeNLQ.png)

最简单的基于事件驱动的样子是一些流行的nodejs函数回调风格,例如：fs.readFile.在这个类比模型中，callback扮演着事件处理者的角色，当Node准备好调用callback的时候：事件将会被发射一次。

让我们来探究一下这个基础形式。

#### Node,在你准备好的时候调用我把！ ####

在很久以前，当没有原生的promise、async/await特性支持的时候，Node最原始的处理异步的方式是使用callback。

callback函数基本上是你传给其他函数的函数，在JS中这是可能的，因为方法是第一级的对象。

理解`callback函数并不是在代码中被异步调用的`非常重要的，在函数中，我们可以随心所欲的同步/异步调用callback。

例如,在下面这种情况中，主函数fileSize包含一个回调函数cb,并且会在同步和异步的情况下调用这个回调函数：

```
function fileSize (fileName, cb) {
  if (typeof fileName !== 'string') {
    return cb(new TypeError('argument should be string')); // Sync
  }
  
  fs.stat(fileName, (err, stats) => {
    if (err) { return cb(err); } // Async
    
    cb(null, stats.size); // Async
  });
}
```

但是我们要记住，这种把主函数在处理callback的时候同时采用同步和异步的方式并不是一个好的实践，它也许会带来一些难以处理的错误。

我们再来看看下面这种典型的用callback风格处理的异步node函数：

```
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

readFileAsArray有文件的路径和callback，它把文件读取并切割成一行一行的数组来当做参数调用callback

这里有一个使用他的实例，假设同目录下我们有一个numbers.txt文件中有如下内容:

```
10
11
12
13
14
15
```

我们想求这个文件中的基数之和，我们可以像下面这样调用readFileAsArray这个函数：

```
readFileAsArray('./numbers.txt', (err, lines) => {
  if (err) throw err;

  const numbers = lines.map(Number);
  const oddNumbers = numbers.filter(n => n%2 === 1);
  console.log('Odd numbers count:', oddNumbers.length);
});
```

代码会读取数组中的字符串内容，解析成数字并求奇数之和。

在NodeJS的回调风格中的写法是这样的：第一个参数err代表着错误处理，当是null的时候我们就是正常调用callback,用户和作者都习惯了这样写，主函数接受callback作为最后一个参数并且调用的时候给callback第一个参数传递err对象。

#### The modern JavaScript alternative to Callbacks ####

在高版本的JS中，我们有Promise对象，作为callback的有力竞争者，它的异步API替代了把callback作为一个参数传递并且同时处理错误信息，一个Promise对象允许我们分别处理成功和失败两种情况，并且链式的调用多个异步方法避免了回调地狱。

如果刚刚的readFileAsArray方法允许使用Promise，它的调用将是这个样子的：

```
readFileAsArray('./numbers.txt')
  .then(lines => {
    const numbers = lines.map(Number);
    const oddNumbers = numbers.filter(n => n%2 === 1);
    console.log('Odd numbers count:', oddNumbers.length);
  })
  .catch(console.error);
```

作为调用callback的替代品，我们用.then函数来接受主方法的返回值；.then函数通常给我们和之前callback一样的参数，我们处理起来和以前一样，但是对于错误我们使用.catch函数来处理。

这要非常感谢新的Promise对象， 它让现代JavaScript中主函数支持Promise接口更加EZ，我们把刚刚的readFileAsArray方法用Promise来改写一下：

```
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

现在这个函数返回了一个Promise对象，这里面包含着`fs.readFile`这个异步调用，Promise对象中同时包含一个resolve函数和reject函数。

reject函数的作用就和我们之前callback中处理错误是一样的，而resolve函数也就和我们正常处理返回值是一样的。

我们剩下唯一要做的就是在实例中制定一个reject resolve函数的默认值，在Promise中，我们只要写一个空函数即可，例如\(\) =&gt; {}.

#### Consuming promises with async/await ####

当你需要一个常常的异步loop函数的时候，使用promise会让你coding的时候比callback的回调地狱简单一些，

Promise是一个小小的进步，generator也是一个小小的进步，但是async/await函数的到来，让这一步变得更有力了，它的编码风格让函数的可读性就像同步函数一样轻松。

我们用async/await函数特性来改写一下刚刚的调用readFileAsArray过程：

```
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

首先我们创建了一个async函数，只是在定义functiond的时候前面加了async关键字，在async函数里，我们把readFileAsArray这个异步方法用await来作为一个普通变量，这样我们的代码看起来真的是同步的呢！

当async函数执行的过程是非常易读的，处理错误，我们只需要使用try/catch即可。

在async/await函数中我们没有使用特殊API\(像: .then and .catch这种\)，我们仅仅使用了特殊关键字，但是像普通函数那样coding.

我们可以在支持Promise的函数中嵌套async/await函数，但是不能在callback风格的异步方法中使用它，比如setTimeout等等。

### The EventEmitter Module ###

EventEmitter是NodeJS中基于事件驱动的架构的核心，它是促进了各个对象之间交流的模块，很多nodejs的原生模块都使用了这个模块。

关于概念这一块很简单，Emitter对象emit命名好的事件，使得之前注册好的监听器被调用起来，Emitter对象有两个显著特点：

* emit注册好的事件
* 注册和取消注册listener方法

如何使用呢？我们只需要穿件一个类来继承EventEmitter即可：

```
class MyEmitter extends EventEmitter {

}
```

Emitter objects are what we instantiate from the EventEmitter-based classes:

```
const myEmitter = new MyEmitter();
```

有了实例，就可以在实例的全部生命周期里，emit任何我们命名好的方法了。

```
myEmitter.emit('something-happened');
```

emit一个事件就代表着有些情况的发生，这些情况通常是关于Emitter对象的状态改变的。

我们使用on方法来注册，然后这些监听的方法将会在每一个Emitter对象emit的时候执行。

#### Events !== Asynchrony ####

让我们看一个例子：

```
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

定义的WithLog类是一个event emitter.它有个方法excutej接受一个参数，并且有很多执行顺序的输出log,并且分别在开始和结束的时候emit了两次。

让我们来看看运行它会有什么样的结果：

```
Before executing
About to execute
*** Executing task ***
Done with execute
After executing
```

需要我们注意的是所有的输出log都是同步的，在代码里没有任何异步操作。

* 第一步‘’Before executing‘’
* 命名为begin的事件的emit导致了‘’About to execute‘’
* 内含方法的执行输出了“\*\*\* Executing task \*\*\*”
* 另一个命名事件输出“Done with execute”
* 最后“After executing”

就像之前的callback,我们在events中并没有假设同步或者异步的代码

这一点很重要，假如我们有异步代码，那么很多结果就会迥然不同。

We can simulate the case with a `setImmediate` call:

```
// ...

withLog.execute(() => {
  setImmediate(() => {
    console.log('*** Executing task ***')
  });
});
```

Now the output would be:

```
Before executing
About to execute
Done with execute
After executing
*** Executing task ***
```

这明显有问题，它的输出看起来不再精确了。

当异步方法结束的时候emit一个事件,我们需要把callback/promise与合并事件驱动的交流合并起来，刚刚的例子证明了这一点。

使用事件驱动来代替传统callback有一个好处是在定义多个listener后，我们可以多次对同一个emit做出反应。如果要用callback来做到这一点的话，我们需要些很多的逻辑在同一个callback中，事件是应用程序允许多个外部插件在应用程序核心之上构建功能的一个好方法，你可以把它们当作钩子点来允许围绕状态变化来做更多自定义的事。

#### Asynchronous Events ####

我们把刚刚的例子修改一下，在同步代码中加入一点异步代码，让它更有意思一点：

```
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


执行WithTime类的asyncFunc方法，使用console.time和console.timeEnd来返回执行的时间，他emit了正确的序列在执行之前和之后，同样emit  error/data来保证函数的正常工作。

执行之后的结果如下，正如我们期待的正确事件序列，我们得到了执行的时间，这是很有用的：

```
About to execute
execute: 4.507ms
Done with execute
```

请注意，我们如何结合一个callback在事件发射器上完成它，如果asynFunc同样支持Promise的话，我们可以使用async/await特性来做到同样的事情：

```
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

这真的看起来更易读了呢！用async/await真的是我们的coding越来越接近JavaScript语言的一大进步。

#### Events Arguments and Errors ####

在之前的例子中，我们使用了额外的参数来发射两个事件。

错误的事件使用了错误对象，data事件使用了data对象

```
this.emit('error', err);
```

The data event is emitted with a data object.

```
this.emit('data', data);
```

在listener函数调用的时候我们可以传递很多的参数，这些参数在执行的时候都会切实可用。

例如：data事件执行的时候，listener函数在注册的时候就会允许我们的接纳事件发射的data参数，而asyncFunc函数也实实在在暴露给了我们。

```
withTime.on('data', (data) => {
  // do something with data
});
```

error事件也是同样是典型的一个。在我们基于callback的例子中，如果没用listener函数来处理错误，node进程就会直接终止-。-

我们写个例子来展示这一点：

```
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

The first execute call above will trigger an error. The node process is going to crash and exit:

```
events.js:163
      throw er; // Unhandled 'error' event
      ^
Error: ENOENT: no such file or directory, open ''

```

第二个执行调用将受到之前崩溃的影响，并可能不会得到执行。

如果我们注册一个listener来处理它，情况就不一样了：

```
withTime.on('error', (err) => {
  // do something with err, for example log it somewhere
  console.log(err)
});
```

If we do the above, the error from the first execute call will be reported but the node process will not crash and exit. The other execute call will finish normally:

```
{ Error: ENOENT: no such file or directory, open '' errno: -2, code: 'ENOENT', syscall: 'open', path: '' }
execute: 4.276ms
```

记住：Node目前的表现和Promise不同 ：只是输出警告，但最终会改变：

```
UnhandledPromiseRejectionWarning: Unhandled promise rejection (rejection id: 1): Error: ENOENT: no such file or directory, open ''

DeprecationWarning: Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code.
```

另一种方式处理emit的error的方法是注册一个全局的uncaughtException进程事件，但是，全局的捕获错误对象并不是一个好办法。

标准的关于uncaughtException的建议是不要使用他，你一定要用的话，应该让进程在此结束：

```
process.on('uncaughtException', (err) => {
  // something went unhandled.
  // Do any cleanup and exit anyway!

  console.error(err); // don't do just that.

  // FORCE exit the process too.
  process.exit(1);
});
```

然而，想象在同一时间发生多个错误事件。这意味着上述的uncaughtException听众会多次触发，这可能对一些清理代码是一个问题。典型的一个例子是，当对数据库关闭操作进行多次调用时。

EventEmitter模块暴露一个once方法。这种方法只需要调用一次监听器，而不是每次发生。所以，这是一个实际使用的uncaughtException用例因为第一未捕获的异常我们就开始做清理工作，无论如何我们要知道退出的过程。

#### Order of Listeners ####

如果我们在一个事件上注册多个队列，并且期望这些listener是有顺序的，会按顺序来调用
```
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

上面代码的输出结果里，“Length”将会比“Characters”在前，因为我们就是这样定义他们的。

如果你想定义一个Listener,还想插队到前面的话，要使用prependListener方法来注册

```
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

这时“Characters”会在“Length”之前。

最后，想移除的话，用removeListener方法就好啦！



感谢阅读，下次再会，以上。

*If you found this article helpful, please click the💚 below. Follow me for more articles on Node and JavaScript.*

If you have any questions about this article or any other article I wrote, find me on [this slack account](https://slack.jscomplete.com/) (you can invite yourself) and ask in the #questions room.

I create online courses for [Pluralsight](https://www.pluralsight.com/search?q=samer+buna&amp;categories=course) and [Lynda](https://www.lynda.com/Samer-Buna/7060467-1.html) . My most recent courses are [Getting Started with React.js](https://www.pluralsight.com/courses/react-js-getting-started) , [Advanced Node.js](https://www.pluralsight.com/courses/nodejs-advanced) , and [Learning Full-stack JavaScript](https://www.lynda.com/Express-js-tutorials/Learning-Full-Stack-JavaScript-Development-MongoDB-Node-React/533304-2.html) .

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
