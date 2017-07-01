> * 原文地址：[Node.js Child Processes: Everything you need to know](https://medium.freecodecamp.com/node-js-child-processes-everything-you-need-to-know-e69498fe970a)
> * 原文作者：本文已获原作者 [Samer Buna](https://medium.freecodecamp.com/@samerbuna) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[熊贤仁](https://github.com/FrankXiong)
> * 校对者：

---

# Node.js Child Processes: Everything you need to know
# Node.js 子进程：你应该知道的一切

## How to use spawn(), exec(), execFile(), and fork()
## 如何使用 spawn()，exec()，execFile() 和 fork()

![](https://cdn-images-1.medium.com/max/2000/1*I56pPhzO1VQw8SIsv8wYNA.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

截图来自我的视频教学课程 - Node.js 进阶

Single-threaded, non-blocking performance in Node.js works great for a single process. But eventually, one process in one CPU is not going to be enough to handle the increasing workload of your application.

Node.js 的单线程、非阻塞执行特性在单进程下工作的很好。但是，单 CPU 中的单进程最终不足以处理应用中增长的工作负荷。

No matter how powerful your server may be, a single thread can only support a limited load.

不管你的服务器性能多么强劲，单个线程只能支持有限的负荷。

The fact that Node.js runs in a single thread does not mean that we can’t take advantage of multiple processes and, of course, multiple machines as well.

Node.js 运行于单线程之上并不意味着我们不能利用多进程，当然，也能运行在多台机器上。

Using multiple processes is the best way to scale a Node application. Node.js is designed for building distributed applications with many nodes. This is why it’s named *Node*. Scalability is baked into the platform and it’s not something you start thinking about later in the lifetime of an application.

使用多进程是扩展 Node 应用的最佳之道。Node.js 是专为在多节点上构建分布式应用。这是它被命名为 “Node” 的原因。可扩展性被深深烙印进平台，自应用诞生之初就已经存在。

> This article is a write-up of part of [my Pluralsight course about Node.js](https://www.pluralsight.com/courses/nodejs-advanced). I cover similar content in video format there.

> 这篇文章是[我的 Node.js 视频教学课程](https://www.pluralsight.com/courses/nodejs-advanced)的补充。在课程中以视频的形式描述了和这篇文章相似的内容。

Please note that you’ll need a good understanding of Node.js *events* and *streams* before you read this article. If you haven’t already, I recommend that you read these two other articles before you read this one:

请注意，在阅读这篇文章之前，你需要对 Node.js 的**事件**和**流**有足够的理解。如果还没有，我推荐你先去读下面两篇文章：

[![](https://ws1.sinaimg.cn/large/006tKfTcgy1fgf9g5mityj314e0aojtf.jpg)](https://medium.freecodecamp.com/understanding-node-js-event-driven-architecture-223292fcbc2d)

[![](https://ws2.sinaimg.cn/large/006tKfTcgy1fgf9h3qicxj31420a2mza.jpg)](https://medium.freecodecamp.com/node-js-streams-everything-you-need-to-know-c9141306be93)

### The Child Processes Module

### 子进程模块

We can easily spin a child process using Node’s `child_process` module and those child processes can easily communicate with each other with a messaging system.

我们可以使用 Node 的 `child_process` 模块来简单地创造子进程，子进程之间可以通过消息系统简单的通信。

The `child_process` module enables us to access Operating System functionalities by running any system command inside a, well, child process.

`child_process` 模块通过在子进程内部运行一些系统指令，赋予我们使用操作系统功能的能力。

We can control that child process input stream, and listen to its output stream. We can also control the arguments to be passed to the underlying OS command, and we can do whatever we want with that command’s output. We can, for example, pipe the output of one command as the input to another (just like we do in Linux) as all inputs and outputs of these commands can be presented to us using [Node.js streams](https://medium.freecodecamp.com/node-js-streams-everything-you-need-to-know-c9141306be93).

我们可以控制子进程的输入流，并监听它的输出流。我们也可以修改传递给底层 OS 命令的参数，并得到任意我们想要的命令输出。举例来说，我们可以将一条命令的输出作为另一条命令的输入（正如 Linux 中那样），因为这些命令的所有输入和输出都能够使用 [Node.js 流](https://medium.freecodecamp.com/node-js-streams-everything-you-need-to-know-c9141306be93)来表示。

*Note that examples I’ll be using in this article are all Linux-based. On Windows, you need to switch the commands I use with their Windows alternatives.*

*注意：这篇文章举的所有例子都基于 Linux。如果在 Windows 上，你要切换为它们对应的 Window 命令。*

There are four different ways to create a child process in Node: `spawn()`, `fork()`, `exec()`, and `execFile()`.

Node.js 里创建子进程有四种不同的方式：`spawn()`, `fork()`, `exec()` 和 `execFile()`。

We’re going to see the differences between these four functions and when to use each.

我们将学习这四个函数之间的区别及其使用场景。

#### Spawned Child Processes

#### 衍生的子进程

The `spawn` function launches a command in a new process and we can use it to pass that command any arguments. For example, here’s code to spawn a new process that will execute the `pwd` command.

`spawn` 函数会在一个新的进程中启动一条命令，我们可以使用它来给这条命令传递一些参数。比如，下面的代码会衍生一个执行 `pwd` 命令的新进程。

    const { spawn } = require('child_process');

    const child = spawn('pwd');

We simply destructure the `spawn` function out of the `child_process` module and execute it with the OS command as the first argument.

我们简单地从 `child_process` 模块中解构 `spawn` 函数，然后将系统命令作为第一个参数执行该函数。

The result of executing the `spawn` function (the `child` object above) is a `ChildProcess` instance, which implements the [EventEmitter API](https://medium.freecodecamp.com/understanding-node-js-event-driven-architecture-223292fcbc2d). This means we can register handlers for events on this child object directly. For example, we can do something when the child process exits by registering a handler for the `exit` event:

`spawn` 函数（上面的`child` 对象）的执行结果是一个 `ChildProcess` 实例，该实例实现了 [EventEmitter API](https://medium.freecodecamp.com/understanding-node-js-event-driven-architecture-223292fcbc2d)。这意味着我们可以直接在这个子对象上注册事件处理器。比如，当在子进程上注册一个 `exit` 事件处理器时，我们可以在事件处理函数中执行一些任务：

    child.on('**exit**', function (code, signal) {
      console.log('child process exited with ' +
                  `code ${code} and signal ${signal}`);
    });

The handler above gives us the exit `code` for the child process and the `signal`, if any, that was used to terminate the child process. This `signal` variable is null when the child process exits normally.

上面的处理器给出了子进程的退出 `code` 和 `signal`，这段代码可以用来终止子进程。子进程正常退出时 `signal` 变量为 null。

The other events that we can register handlers for with the `ChildProcess` instances are `disconnect`, `error`, `close`, and `message`.

`ChildProcess` 实例上还可以注册 `disconnect`、`error`、`close` 和 `message` 事件。

- The `disconnect` event is emitted when the parent process manually calls the `child.disconnect` function.
- The `error` event is emitted if the process could not be spawned or killed.
- The `close` event is emitted when the `stdio` streams of a child process get closed.
- The `message` event is the most important one. It’s emitted when the child process uses the `process.send()` function to send messages. This is how parent/child processes can communicate with each other. We’ll see an example of this below.

- `disconnect` 事件在父进程手动调用 `child.disconnect` 函数时触发
- 如果进程不能被衍生或者杀死，会触发 `error` 事件
- `close` 事件在子进程的 `stdio` 流关闭时触发
- `message` 事件最为重要。它在子进程使用 `process.send()` 函数来传递消息时触发。这就是父/子进程间通信的原理。下面将给出一个例子。

Every child process also gets the three standard `stdio` streams, which we can access using `child.stdin`, `child.stdout`, and `child.stderr`.

每一个子进程还有三个标准 `stdio` 流，我们可以分别使用 `child.stdin`、`child.stdout` 和 `child.stderr` 来使用这三个流。

When those streams get closed, the child process that was using them will emit the `close` event. This `close` event is different than the `exit` event because multiple child processes might share the same `stdio` streams and so one child process exiting does not mean that the streams got closed.

当这几个流被关闭后，使用了它们的子进程会触发 `close` 事件。这里的 `close` 事件不同于 `exit` 事件，因为多个子进程可能共享相同的 `stdio` 流，因此一个子进程退出并不意味着流已经被关闭了。

Since all streams are event emitters, we can listen to different events on those `stdio` streams that are attached to every child process. Unlike in a normal process though, in a child process, the `stdout`/`stderr` streams are readable streams while the `stdin` stream is a writable one. This is basically the inverse of those types as found in a main process. The events we can use for those streams are the standard ones. Most importantly, on the readable streams we can listen to the `data` event, which will have the output of the command or any error encountered while executing the command:

既然所有的流都是事件触发器，我们可以在归属于每个子进程的 `stdio` 流上监听不同的事件。不像普通的进程，在子进程中，`stdout`/`stderr` 流是可读流，而 `stdin` 流是可写的。这基本上和主进程相反。这些流支持的事件都是标准的。最重要的是，在可读流上我们可以监听 `data` 事件，通过 `data` 事件可以得到任一命令的输出或者执行命令过程中发生的错误： 

    child.stdout.on('data', (data) => {
      console.log(`child stdout:\n${data}`);
    });

    child.stderr.on('data', (data) => {
      console.error(`child stderr:\n${data}`);
    });

The above two handlers will log both cases to the main process `stdout` and `stderr`. When we execute the `spawn` function above, the output of the `pwd` command gets printed and the child process exits with code `0`, which means no error occurred.

上述两个处理器会输出两者的日志到主进程的 `stdout` 和 `stderr` 事件上。当我们执行前面的 `spawn` 函数时，`pwd` 命令的输出会被打印出来，并且子进程带着代码 `0` 退出，这表示没有错误发生。

We can pass arguments to the command that’s executed by the `spawn` function using the second argument of the `spawn` function, which is an array of all the arguments to be passed to the command. For example, to execute the `find` command on the current directory with a `-type f` argument (to list files only), we can do:

我们可以给命令传递参数，命令由 `spawn` 函数执行，`spawn` 函数用上了第二个参数，这是一个传递给该命令的所有参数组成的数组。比如说，为了在当前目录执行 `find` 命令，并带上一个 `-type f` 参数（用于列出所有文件），我们可以这样做：

    const child = spawn('find', **['.', '-type', 'f']**);

If an error occurs during the execution of the command, for example, if we give find an invalid destination above, the `child.stderr``data` event handler will be triggered and the `exit` event handler will report an exit code of `1`, which signifies that an error has occurred. The error values actually depend on the host OS and the type of the error.

如果这条命令的执行过程中出现错误，举个例子，如果我们在 find 一个非法的目标文件，`child.stderr``data` 事件处理器将会被触发，`exit` 事件处理器会报出一个退出代码 `1`，这标志着出现了错误。错误的值最终取决于宿主操作系统和错误类型。

A child process `stdin` is a writable stream. We can use it to send a command some input. Just like any writable stream, the easiest way to consume it is using the `pipe` function. We simply pipe a readable stream into a writable stream. Since the main process `stdin` is a readable stream, we can pipe that into a child process `stdin` stream. For example:

子进程中的 `stdin` 是一个可写流。我们可以用它给命令发送一些输入。就跟所有的可写流一样，消费输入最简单的方式是使用 `pipe` 函数。我们可以简单地 将可读流管道化到可写流。既然主线程的 `stdin` 是一个可读流，我们可以将其管道化到子进程的 `stdin` 流。举个例子：

    const { spawn } = require('child_process');

    const child = spawn('wc');

    **process.stdin.pipe(child.stdin)
    **
    child.stdout.on('data', (data) => {
      console.log(`child stdout:\n${data}`);
    });

In the example above, the child process invokes the `wc` command, which counts lines, words, and characters in Linux. We then pipe the main process `stdin` (which is a readable stream) into the child process `stdin` (which is a writable stream). The result of this combination is that we get a standard input mode where we can type something and when we hit `Ctrl+D`, what we typed will be used as the input of the `wc` command.

在这个例子中，子进程调用 `wc` 命令，该命令可以统计 Linux 中的行数、单词数和字符数。我们然后将主进程的 `stdin` 管道化到子进程的 `stdin`（一个可写流）。这个组合的结果是，我们得到了一个标准输入模式，在这个模式下，我们可以输入一些字符。当敲下 `Ctrl+D` 时，输入的内容将会作为 `wc` 命令的输入。

![](https://cdn-images-1.medium.com/max/1000/1*s9dQY9GdgkkIf9zC1BL6Bg.gif)

Gif captured from my Pluralsight course — Advanced Node.js

Gif 截图来自我的视频教学课程 - Node.js 进阶

We can also pipe the standard input/output of multiple processes on each other, just like we can do with Linux commands. For example, we can pipe the `stdout` of the `find` command to the stdin of the `wc` command to count all the files in the current directory:

我们也可以将多个进程的标准输入/输出相互用管道连接，就像 Linux 命令那样。比如说，我们可以管道化 `find` 命令的 `stdout` 到 `wc` 命令的 `stdin`，这样可以统计当前目录的所有文件。

    const { spawn } = require('child_process');

    const find = spawn('find', ['.', '-type', 'f']);
    const wc = spawn('wc', ['-l']);

    **find.stdout.pipe(wc.stdin);
    **
    wc.stdout.on('data', (data) => {
      console.log(`Number of files ${data}`);
    });

I added the `-l` argument to the `wc` command to make it count only the lines. When executed, the code above will output a count of all files in all directories under the current one.

我给 `wc` 命令添加了 `-l` 参数，使它只统计行数。当执行完毕，上述代码会输出当前目录下所有子目录文件的行数。

#### Shell Syntax and the exec function

#### Shell 语法和 exec 函数

By default, the `spawn` function does not create a *shell* to execute the command we pass into it, making it slightly more efficient than the `exec` function, which does create a shell. The `exec` function has one other major difference. It *buffers* the command’s generated output and passes the whole output value to a callback function (instead of using streams, which is what `spawn` does).

默认情况下，`spawn` 函数并不为我们传进的命令而创建一个 `shell` 来执行， 这使得它相比创建 shell 的 `exec` 函数，效率略微更高。`exec` 函数还有另一个主要的区别，它*缓冲*了命令生成的输出，并传递整个输出值给一个回调函数（而不是使用流，那是 `spawn` 的做法）。

Here’s the previous `find | wc `example implemented with an `exec` function.

这里给出了之前 `find | wc ` 例子的 `exec` 函数实现。

    const { exec } = require('child_process');

    exec('find . -type f | wc -l', (err, stdout, stderr) => {
      if (err) {
        console.error(`exec error: ${err}`);
        return;
      }

      console.log(`Number of files ${stdout}`);
    });

Since the `exec` function uses a shell to execute the command, we can use the *shell syntax* directly here making use of the shell *pipe* feature.

既然 `exec` 函数使用 shell 执行命令，我们可以使用 *shell 语法* 来直接利用 shell 管道特性。

The `exec` function buffers the output and passes it to the callback function (the second argument to `exec`) as the `stdout` argument there. This `stdout` argument is the command’s output that we want to print out.

当 `stdout` 参数存在，`exec` 函数缓冲输出并传递它给回调函数（`exec` 的第二个参数）。这里的 `stdout` 参数是命令的输出，我们要将其打印出来。

The `exec` function is a good choice if you need to use the shell syntax and if the size of the data expected from the command is small. (Remember, `exec` will buffer the whole data in memory before returning it.)

如果你需要使用 shell 语法，并且命令期望的数据大小很小，`exec` 函数是个不错的选择。（记住，`exec` 会在返回之前，缓冲所有数据进内存。）

The `spawn` function is a much better choice when the size of the data expected from the command is large because that data will be streamed with the standard IO objects.

当命令期望的数据大小比较大，选择 `spawn` 函数会好得多，因为数据将会和标准 IO 对象被流式处理。

We can make the spawned child process inherit the standard IO objects of its parents if we want to, but also, more importantly, we can make the `spawn` function use the shell syntax as well. Here’s the same `find | wc` command implemented with the `spawn` function:

我们可以令衍生的子进程继承其父进程的标准 IO 对象，但更重要的是，我们同样可以令 `spawn` 函数使用 shell 语法。下面同样是 `find | wc` 命令， 由 `spawn` 函数实现：

    const child = spawn('find . -type f', {
    **stdio: 'inherit',**
    **shell: true**
    });

Because of the `stdio: 'inherit'` option above, when we execute the code, the child process inherits the main process `stdin`, `stdout`, and `stderr`. This causes the child process data events handlers to be triggered on the main `process.stdout` stream, making the script output the result right away.

因为有上面的 `stdio: 'inherit'` 选项，当代码执行时，子进程继承主进程的 `stdin`、`stdout` 和 `stderr`。这造成子进程的数据事件处理器在主进程的 `process.stdout` 流上被触发，使得脚本立即输出结果。

Because of the `shell: true` option above, we were able to use the shell syntax in the passed command, just like we did with `exec`. But with this code, we still get the advantage of the streaming of data that the `spawn` function gives us. *This is really the best of the two worlds.*

`shell: true` 选项使我们可以在传递的命令中使用 shell 语法，就像之前的 `exec` 例子中那样。但这段代码还可以利用 `spawn` 函数带来的数据的流式。*真正实现了共赢。*

There are a few other good options we can use in the last argument to the `child_process` functions besides `shell` and `stdio`. We can, for example, use the `cwd` option to change the working directory of the script. For example, here’s the same count-all-files example done with a `spawn` function using a shell and with a working directory set to my Downloads folder. The `cwd` option here will make the script count all files I have in `~/Downloads`:

除了 `shell` 和 `stdio`，`child_process` 函数的最后一个参数还有其他可以的选项。比如，使用 `cwd` 选项改变脚本的工作目录。举个例子，这里有个和前述相同的统计所有文件数量的例子，它利用 `spawn` 函数实现，使用了一个 shell 命令，并把工作目录设置为我的 Downloads 文件夹。这里的 `cwd` 选项会让脚本统计 `~/Downloads` 里的所有文件数量。

    const child = spawn('find . -type f | wc -l', {
      stdio: 'inherit',
      shell: true,
    **cwd: '/Users/samer/Downloads'**
    });

Another option we can use is the `env` option to specify the environment variables that will be visible to the new child process. The default for this option is `process.env` which gives any command access to the current process environment. If we want to override that behavior we can simply pass an empty object as the `env` option or new values there to be considered as the only environment variables:

另一个可以使用的选项是 `env`，它可以用来指定环境变量，其对于新的子进程是可见的。此选项的默认值是 `process.env`，这会赋予所有命令访问当前进程上下文环境的权限。如果想覆盖默认行为，我们可以简单地传递一个空对象，或者是作为唯一的环境变量的新值给 `env` 选项：

    const child = spawn('echo $ANSWER', {
      stdio: 'inherit',
      shell: true,
    **  env: { ANSWER: 42 },
    **});

The echo command above does not have access to the parent process’s environment variables. It can’t, for example, access `$HOME`, but it can access `$ANSWER` because it was passed as a custom environment variable through the `env` option.

上面的 echo 命令没有访问父进程环境变量的权限。比如，它不能访问 `$HOME` 目录，但它可以访问 `$ANSWER` 目录，因为通过 `env` 选项，它被传递了一个指定的环境变量。

One last important child process option to explain here is the `detached` option, which makes the child process run independently of its parent process.

这里要解释的最后一个重要的子进程选项，`detached` 选项，使子进程独立于父进程运行。

Assuming we have a file `timer.js` that keeps the event loop busy:

假设有个文件 `timer.js`，使事件循环一直忙碌运行：

    setTimeout(() => {
      // keep the event loop busy
    }, 20000);

We can execute it in the background using the `detached` option:

我们可以使用 `detached` 选项，在后台执行这段代码：

    const { spawn } = require('child_process');

    const child = spawn('node', ['timer.js'], {
    **  detached: true,**
      stdio: 'ignore'
    });

    child.unref();

The exact behavior of detached child processes depends on the OS. On Windows, the detached child process will have its own console window while on Linux the detached child process will be made the leader of a new process group and session.

分离的子进程的具体行为取决于操作系统。Windows 上，分离的子进程有自己的控制台窗口，然而在 Linux 上，分离的子进程会成为新的进程组和会话的领导者。

If the `unref` function is called on the detached process, the parent process can exit independently of the child. This can be useful if the child is executing a long-running process, but to keep it running in the background the child’s `stdio` configurations also have to be independent of the parent.

如果 `unref` 函数在分离的子进程中被调用，父进程可以独立于子进程退出。如果子进程是一个长期运行的进程，这个函数会很有用。但为了保持子进程在后台运行，子进程的 `stdio` 配置也必须独立于父进程。

The example above will run a node script (`timer.js`) in the background by detaching and also ignoring its parent `stdio` file descriptors so that the parent can terminate while the child keeps running in the background.

上述例子会在后台运行一个 node 脚本（`timer.js`），通过分离和忽略其父进程的 `stdio` 文件描述符来实现。因此当子进程在后台运行时，父进程可以随时终止。

![](https://cdn-images-1.medium.com/max/1000/1*WhvMs8zv-WS6v7nDXmDUzw.gif)

Gif captured from my Pluralsight course — Advanced Node.js

Gif 来自我的视频教学课程 - Node.js 进阶

#### The execFile function

#### execFile 函数

If you need to execute a file without using a shell, the `execFile` function is what you need. It behaves exactly like the `exec` function but does not use a shell, which makes it a bit more efficient. On Windows, some files cannot be executed on their own, like `.bat` or `.cmd` files. Those files cannot be executed with `execFile` and either `exec` or `spawn` with shell set to true is required to execute them.

如果你需要执行一个文件时不使用 shell，`execFile` 函数正是你想要的。它的行为跟 `exec` 函数一模一样，但没有使用 shell，这会让它更有效率。Windows 上，一些文件不能在它们自己之上执行，比如 `.bat` 或者 `.cmd` 文件。这些文件不能使用 `execFile` 执行，并且执行它们时，需要将 shell 设置为 true，且只能使用 `exec`、`spawn` 两者之一。

#### The *Sync function

#### *Sync 函数 

All of the `child_process` module functions have synchronous blocking versions that will wait until the child process exits.

所有 `child_process` 模块都有同步阻塞版本，它们会一直等待直到子进程退出。

![](https://cdn-images-1.medium.com/max/1000/1*C3uDuWwmqM_qT8X0S5tzPg.png)

Screenshot captured from my Pluralsight course — Advanced Node.js

截图来自我的视频教学课程 - Node.js 进阶

Those synchronous versions are potentially useful to simplify scripting tasks or any startup processing tasks but they should be avoided otherwise.

这些同步版本在简化脚本任务或一些启动进程任务上，一定程度上有所帮助。但除此之外，我们应该避免使用它们。

#### The fork() function

#### fork() 函数

The `fork` function is a variation on the `spawn` function for spawning node processes. The biggest difference between `spawn` and `fork` is that a communication channel is established to the child process when using `fork`, so we can use the `send` function on the forked process along with the global `process` object itself to exchange messages between the parent and forked processes. We do this through the `EventEmitter` module interface. Here’s an example:

`fork` 函数是 `spawn` 函数针对衍生 node 进程的一个变种。`spawn` 和 `fork` 最大的区别在于，使用 `fork` 时，通信频道建立于子进程，因此我们可以在 fork 出来的进程上使用 `send` 函数，这些进程上有个全局 `process` 对象，可以用于父进程和 fork 进程之间传递消息。这个函数通过 `EventEmitter` 模块接口实现。这里有个例子：

The parent file, `parent.js`:

父文件，`parent.js`:

    const { fork } = require('child_process');

    const forked = fork('child.js');

    forked.on('message', (msg) => {
      console.log('Message from child', msg);
    });

    forked.send({ hello: 'world' });

The child file, `child.js`:

子文件，`child.js`:

    process.on('message', (msg) => {
      console.log('Message from parent:', msg);
    });

    let counter = 0;

    setInterval(() => {
      process.send({ counter: counter++ });
    }, 1000);

In the parent file above, we fork `child.js` (which will execute the file with the `node` command) and then we listen for the `message` event. The `message` event will be emitted whenever the child uses `process.send`, which we’re doing every second.

上面的父文件中，我们 fork `child.js`（将会通过 `node` 命令执行文件），并监听 `message` 事件。一旦子进程使用 `process.send`，事实上我们每秒都在执行它，`message` 事件就会被触发，

To pass down messages from the parent to the child, we can execute the `send` function on the forked object itself, and then, in the child script, we can listen to the `message` event on the global `process` object.

为了实现父进程向下给子进程传递消息，我们可以在 fork 的对象本身上执行 `send` 函数，然后在子文件中，在全局 `process` 对象上监听 `message` 事件。

When executing the `parent.js` file above, it’ll first send down the `{ hello: 'world' }` object to be printed by the forked child process, and then the forked child process will send an incremented counter value every second to be printed by the parent process.

执行上面的 `parent.js` 文件时，它将首先向下发送 `{ hello: 'world' }` 对象，该对象会被 fork 的子进程打印出来。然后 fork 的子进程每秒会发送一个自增的计数值，该值会被父进程打印出来。 

![](https://cdn-images-1.medium.com/max/1000/1*GOIOTAZTcn40qZ3JwgsrNA.gif)

Screenshot captured from my Pluralsight course — Advanced Node.js

截图来自我的视频教学课程 - Node.js 进阶

Let’s do a more practical example to using the `fork` function.

我们来用 `fork` 函数实现一个更实用的例子。

Let’s say we have an http server that handles two endpoints. One of these endpoints (`/compute` below) is computationally expensive and will take a few seconds to complete. We can use a long for loop to simulate that:

这里有个 HTTP 服务器处理两个端点。一个端点（下面的 `/compute`）计算密集，会花好几秒种完成。我们可以用一个长循环来模拟：

    const http = require('http');

    const longComputation = () => {
      let sum = 0;
      for (let i = 0; i < 1e9; i++) {
        sum += i;
      };
      return sum;
    };

    const server = http.createServer();

    server.on('request', (req, res) => {
      if (req.url === '/compute') {
    **    const sum = longComputation();
    **    return res.end(`Sum is ${sum}`);
      } else {
        res.end('Ok')
      }
    });

    server.listen(3000);

This program has a big problem; when the the `/compute` endpoint is requested, the server will not be able to handle any other requests because the event loop is busy with the long for loop operation.

这段程序有个比较大的问题：当 `/compute` 端点被请求，服务器不能处理其他请求，因为长循环导致事件循环处于繁忙状态。

There are a few ways with which we can solve this problem depending on the nature of the long operation but one solution that works for all operations is just to move the computational operation into another process using `fork`.

这个问题有一些解决之道，这取决于耗时长运算的性质。但针对所有运算都适用的解决方法是，用 `fork` 将计算过程移动到另一个进程。

We first move the whole `longComputation` function into its own file and make it invoke that function when instructed via a message from the main process:

我们首先移动整个 `longComputation` 函数到它自己的文件，并在主进程通过消息发出通知时，在文件中调用这个函数：

In a new `compute.js` file:

    const longComputation = () => {
      let sum = 0;
      for (let i = 0; i < 1e9; i++) {
        sum += i;
      };
      return sum;
    };

    **process.on('message', (msg) => {
      const sum = longComputation();
      process.send(sum);
    });**

Now, instead of doing the long operation in the main process event loop, we can `fork` the `compute.js` file and use the messages interface to communicate messages between the server and the forked process.

现在，我们可以 `fork` `compute.js` 文件，并用消息接口实现服务器和复刻进程的消息通信，而不是在主进程事件循环中执行耗时操作。

    const http = require('http');
    const { fork } = require('child_process');

    const server = http.createServer();

    server.on('request', (req, res) => {
      if (req.url === '/compute') {
    **    const compute = fork('compute.js');
        compute.send('start');
        compute.on('message', sum => {
          res.end(`Sum is ${sum}`);
        });
    **  } else {
        res.end('Ok')
      }
    });

    server.listen(3000);

When a request to `/compute` happens now with the above code, we simply send a message to the forked process to start executing the long operation. The main process’s event loop will not be blocked.

上面的代码中，当 `/compute` 来了一个请求，我们可以简单地发送一条消息给复刻进程，来启动执行耗时运算。主进程的事件循环并不会阻塞。

Once the forked process is done with that long operation, it can send its result back to the parent process using `process.send`.

一旦复刻进程执行完耗时操作，它可以用 `process.send` 将结果发回给父进程。

In the parent process, we listen to the `message` event on the forked child process itself and when we get that event we’ll have a `sum` value ready for us to send to the requesting user over http.

在父进程中，我们在 fork 的子进程本身上监听 `message` 事件。当该事件触发，我们会得到一个准备好的 `sum` 值，并通过 HTTP 发送给请求。

The code above is, of course, limited by the number of processes we can fork, but when we execute it and request the long computation endpoint over http, the main server is not blocked at all and can take further requests.

上面的代码，当然，我们可以 fork 的进程数是有限的。但执行这段代码时，HTTP 请求耗时运算的端点，主服务器根本不会阻塞，并且还可以接受更多的请求。

Node’s `cluster` module, which is the topic of my next article, is based on this idea of child process forking and load balancing the requests among the many forks that we can create on any system.

我的下篇文章的主题，`cluster` 模块，正是基于子进程 fork 和负载均衡请求的思想，这些子进程来自大量的 fork，我们可以在任何系统中创建它们。

That’s all I have for this topic. Thanks for reading! Until next time!

以上就是我针对这个话题要讲的全部。感谢阅读！再次再见！

---

*If you found this article helpful, please click the💚 below. Follow me for more articles on Node.js and JavaScript.*

I create **online courses** for [Pluralsight](https://www.pluralsight.com/search?q=samer+buna&amp;categories=course) and [Lynda](https://www.lynda.com/Samer-Buna/7060467-1.html). My most recent courses are [Getting Started with React.js](https://www.pluralsight.com/courses/react-js-getting-started), [Advanced Node.js](https://www.pluralsight.com/courses/nodejs-advanced), and [Learning Full-stack JavaScript](https://www.lynda.com/Express-js-tutorials/Learning-Full-Stack-JavaScript-Development-MongoDB-Node-React/533304-2.html).

I also do **online and onsite training** for groups covering beginner to advanced levels in JavaScript, Node.js, React.js, and GraphQL. [Drop me a line](mailto:samer@jscomplete.com) if you’re looking for a trainer. I’ll be teaching 6 onsite workshops this July at Forward.js, one of them is [Node.js beyond the basics](https://forwardjs.com/#node-js-deep-dive).

If you have any questions about this article or any other article I wrote, find me on [this **slack** account](https://slack.jscomplete.com/) (you can invite yourself) and ask in the #questions room.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
