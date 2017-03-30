> * 原文地址：[Requiring modules in Node.js: Everything you need to know](https://medium.freecodecamp.com/requiring-modules-in-node-js-everything-you-need-to-know-e7fbd119be8#.wcrwm9c81)
> * 原文作者：[Samer Buna](https://medium.freecodecamp.com/@samerbuna?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[zhouzihanntu](https://github.com/zhouzihanntu)
> * 校对者：

# Requiring modules in Node.js: Everything you need to know #
# 在 Node.js 中引用模块 #

## Node.js 中模块化的工作原理 ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*AL0-iuggGnBLSvSVvt0Xzw.png">

Node 提供了两个核心模块来管理模块依赖：

- `require` 模块在全局范围内可用，不需要写 `require('require')`.    
- `module` 模块同样在全局范围内可用，不需要写 `require('module')`.

你可以将 `require` 模块理解为命令，将 `module` 模块理解为组织所有被引用模块的工具。

在 Node 中引入一个模块其实不像概念那么复杂。

```
const config = require('/path/to/file');
```

`require` 模块导出的主对象是一个函数（如上例）。当 Node 将本地文件路径作为唯一参数调用 `require()` 时，Node 将执行以下步骤：

- **解析**：找到该文件的绝对路径。
- **加载**：确定文件内容的类型。
- **打包**：为文件划分私有作用域，这样 `require` 和 `module` 两个对象对于我们要引入的每个模块来说就都是本地的。
- **评估**：最后由虚拟机对加载得到的代码做评估。
- **缓存**：当再次引用该文件时，无需再重复以上所有步骤。

在本文中，我将试着用示例说明这些不同阶段的运行原理，以及它们如何影响我们在 Node 中编写模块的方式。

我先使用终端创建一个目录来托管本文中的所有示例：

```
mkdir ~/learn-node && cd ~/learn-node
```

本文余下部分的所有命令都将在 `~/learn-node` 目录下运行。

#### 解析本地路径 ####

首先，让我来介绍一下 `module` 对象。你可以在一个简单的 REPL 会话中查看该对象：

```
~/learn-node $ node
> module
Module {
  id: '<repl>',
  exports: {},
  parent: undefined,
  filename: null,
  loaded: false,
  children: [],
  paths: [ ... ]
}
```

每个模块对象都有一个用于识别该对象的 `id` 属性。这个 `id` 通常是该文件的完整路径，但在 REPL 会话中只会显示为 `<repl>`。

Node 模块与文件系统中的文件有着一一对应的关系。我们通过加载模块对应的文件内容到内存中来实现模块引用。

然而，由于 Node 允许使用许多方式引入文件（例如，使用相对路径或预先配置的路径），我们需要在将文件的内容加载到内存前找到该文件的绝对位置。

例如，我们不声明路径，直接引入一个 `'find-me'` 模块时：

```
require('find-me');
```

Node 会在 `module.paths` 声明的所有路径中依次查找 `find-me.js` 。

```
~/learn-node $ node
> module.paths
[ '/Users/samer/learn-node/repl/node_modules',
  '/Users/samer/learn-node/node_modules',
  '/Users/samer/node_modules',
  '/Users/node_modules',
  '/node_modules',
  '/Users/samer/.node_modules',
  '/Users/samer/.node_libraries',
  '/usr/local/Cellar/node/7.7.1/lib/node' ]
```

Node 从当前目录开始一级级向上寻找 node_modules 目录，这个数组大致就是当前目录到所有 node_modules 目录的相对路径。其中还包括一些为了兼容性保留的目录，不推荐使用。

如果 Node 在以上路径中都无法找到 `find-me.js` ，将抛出一个 “找不到该模块” 错误。

```
~/learn-node $ node
> require('find-me')
Error: Cannot find module 'find-me'
    at Function.Module._resolveFilename (module.js:470:15)
    at Function.Module._load (module.js:418:25)
    at Module.require (module.js:498:17)
    at require (internal/module.js:20:19)
    at repl:1:1
    at ContextifyScript.Script.runInThisContext (vm.js:23:33)
    at REPLServer.defaultEval (repl.js:336:29)
    at bound (domain.js:280:14)
    at REPLServer.runBound [as eval] (domain.js:293:12)
    at REPLServer.onLine (repl.js:533:10)
```

如果你现在创建一个本地的 `node_modules` 目录，并向目录中添加一个 `find-me.js` 文件，就能通过 `require('find-me')` 找到它了。

```
~/learn-node $ mkdir node_modules

~/learn-node $ echo "console.log('I am not lost');" > node_modules/find-me.js

~/learn-node $ node
> require('find-me');
I am not lost
{}
>
```

如果在其他路径下也有 `find-me.js` 文件呢？例如，我们在主目录下的 `node_modules` 目录中放置一个不同的 `find-me.js` 文件：

```
$ mkdir ~/node_modules
$ echo "console.log('I am the root of all problems');" > ~/node_modules/find-me.js
```

当我们在 `learn-node` 目录下执行 `require('find-me')` 时，`learn-node` 目录会加载自己的 `node_modules/find-me.js`，主目录下的 `find-me.js` 文件并不会被加载：

```
~/learn-node $ node
> require('find-me')
I am not lost
{}
>
```

此时，如果我们将 `~/learn-node` 下的 `node_modules` 移除，再一次引入 `find-me` 模块，那么主目录下的 `node_modules` 将会被加载：

```
~/learn-node $ rm -r node_modules/

~/learn-node $ node
> require('find-me')
I am the root of all problems
{}
>
```

#### 引入文件夹 ####

模块不一定是单个文件。我们也可以在 `node_modules` 目录下创建一个 `find-me` 文件夹，然后向其中添加一个 `index.js` 文件。`require('find-me')` 会引用该文件夹下的 `index.js` 文件：

```
~/learn-node $ mkdir -p node_modules/find-me

~/learn-node $ echo "console.log('Found again.');" > node_modules/find-me/index.js

~/learn-node $ node
> require('find-me');
Found again.
{}
>
```

>注意，由于我们现在有一个本地目录，它再次忽略了主目录的 `node_modules` 路径。

当我们引入一个文件夹时，将默认执行 `index.js` 文件，但是我们可以通过 `package.json` 中的 `main` 属性指定主入口文件。例如，要令 `require('find-me')` 解析到 `find-me` 文件夹下的另一个文件，我们只需要在该文件夹下添加一个 `package.json` 文件来声明解析该文件夹时引用的文件：

```
~/learn-node $ echo "console.log('I rule');" > node_modules/find-me/start.js

~/learn-node $ echo '{ "name": "find-me-folder", "main": "start.js" }' > node_modules/find-me/package.json

~/learn-node $ node
> require('find-me');
I rule
{}
>
```

#### require.resolve 方法 ####

如果你只想解析模块而不运行，此时可以使用 `require.resolve` 函数。这个方法与 `require` 的主要功能完全相同，但是不加载文件。如果文件不存在，它仍会抛出错误，并在找到文件时返回文件的完整路径。

```
> require.resolve('find-me');
'/Users/samer/learn-node/node_modules/find-me/start.js'
> require.resolve('not-there');
Error: Cannot find module 'not-there'
    at Function.Module._resolveFilename (module.js:470:15)
    at Function.resolve (internal/module.js:27:19)
    at repl:1:9
    at ContextifyScript.Script.runInThisContext (vm.js:23:33)
    at REPLServer.defaultEval (repl.js:336:29)
    at bound (domain.js:280:14)
    at REPLServer.runBound [as eval] (domain.js:293:12)
    at REPLServer.onLine (repl.js:533:10)
    at emitOne (events.js:101:20)
    at REPLServer.emit (events.js:191:7)
>
```

这个方法可以用于检查一个可选安装包是否安装，并仅在该包可用时使用。

#### 相对路径和绝对路径 ####

除了从 `node_modules` 目录中解析模块以外，我们还可以将模块放置在任意位置，使用相对路径（ `./` 和 `../` ）或以 `/` 开头的绝对路径引入。

举个例子，如果 `find-me.js` 文件并不在 `node_modules` 中，而在 `lib` 文件夹中。我们可以使用以下代码引入它：

```
require('./lib/find-me');
```

#### 文件间的父子关系 ####

现在我们来创建一个 `lib/util.js` 文件，向文件添加一行 `console.log` 代码作为标识。打印出 `module` 对象本身：

```
~/learn-node $ mkdir lib
~/learn-node $ echo "console.log('In util', module);" > lib/util.js
```

同样的，向 `index.js` 文件中也添加一行打印 `module` 对象的代码，并在文件中引入 `lib/util.js`，我们将使用 node 命令运行该文件：

```
~/learn-node $ echo "console.log('In index', module); require('./lib/util');" > index.js
```

用 node 运行 `index.js` 文件：

```
~/learn-node $ node index.js
In index Module {
  id: '.',
  exports: {},
  parent: null,
  filename: '/Users/samer/learn-node/index.js',
  loaded: false,
  children: [],
  paths: [ ... ] }
In util Module {
  id: '/Users/samer/learn-node/lib/util.js',
  exports: {},
  parent:
   Module {
     id: '.',
     exports: {},
     parent: null,
     filename: '/Users/samer/learn-node/index.js',
     loaded: false,
     children: [ [Circular] ],
     paths: [...] },
  filename: '/Users/samer/learn-node/lib/util.js',
  loaded: false,
  children: [],
  paths: [...] }
```

>注意：`index` 主模块 `(id: '.')` 现在被列为 `lib/util` 模块的父类。但 `lib/util` 模块并没有被列为 `index` 模块的子目录。相反，我们在这里得到的值是 `[Circular]`，因为这是一个循环引用。如果 Node 打印 `lib/util` 模块对象，将进入一个无限循环。这就是为什么 Node 使用 `[Circular]` 代替了 `lib/util` 引用。


重点来了，如果我们在 `lib/util` 模块中引入 `index` 主模块会发生什么？这就是 Node 中所支持的循环模块依赖关系。

为了更好理解循环模块依赖，我们先来了解一些关于 module 对象的概念。

#### exports、module.exports 和模块异步加载 ####

在所有模块中，exports 都是一个特殊对象。你可能注意到了，以上我们每打印一个 module 对象时，它都有一个空的 exports 属性。我们可以向这个特殊的 exports 对象添加任意属性。例如，我们现在为 `index.js` 和 `lib/util.js` 的 exports 对象添加一个 id 属性：

```
// 在 lib/util.js 顶部添加以下代码
exports.id = 'lib/util';

// 在 index.js 顶部添加以下代码
exports.id = 'index';
```

然后运行 `index.js`，我们将看到：

```
~/learn-node $ node index.js
In index Module {
  id: '.',
  exports: { id: 'index' },
  loaded: false,
  ... }
In util Module {
  id: '/Users/samer/learn-node/lib/util.js',
  exports: { id: 'lib/util' },
  parent:
   Module {
     id: '.',
     exports: { id: 'index' },
     loaded: false,
     ... },
  loaded: false,
  ... }
```

为了保持示例简短，我删除了以上输出中的一些属性，但请注意：`exports` 对象现在拥有我们在各模块中定义的属性。你可以向 exports 对象添加任意多的属性，也可以直接将整个对象改为其它对象。例如，我们可以通过以下方式将 exports 对象更改为一个函数：

```
// 将以下代码添加在 index.js 中的 console.log 语句前

module.exports = function() {};
```

再次运行 `index.js`，你将看到 `exports` 对象是一个函数：

```
~/learn-node $ node index.js
In index Module {
  id: '.',
  exports: [Function],
  loaded: false,
  ... }
```

>注意：我们并没有使用 `exports = function() {}` 来将 `exports` 对象更改为函数。实际上，由于各模块中的 `exports` 变量仅仅是对管理输出属性的 `module.exports` 的引用，当我们对 `exports` 变量重新赋值时，引用就会丢失，此时我们只是引入了一个新的变量，而没有对 `module.exports` 做修改。

各模块中的 `module.exports` 对象就是我们在引入该模块时 `require` 函数的返回值。例如，我们将 `index.js` 中的 `require('./lib/util')` 改为：

```
const UTIL = require('./lib/util');

console.log('UTIL:', UTIL);
```

以上代码会将 `lib/util` 输出的属性赋值给 `UTIL` 常量。我们现在运行 `index.js`，最后一行将输出以下结果：

```
UTIL: { id: 'lib/util' }
```

我们再来谈谈各模块中的 `loaded` 属性。到目前为止我们打印的所有 module 对象中都有一个值为 `false` 的 `loaded` 属性。

`module` 模块使用 `loaded` 属性对模块的加载状态进行跟踪，判断哪些模块已经加载完成（值为 true）以及哪些模块仍在加载（值为 false）。例如，要判断 `index.js` 模块是否已完全加载，我们可以在下一个事件循环中使用一个 `setImmediate` 回调打印出他的 `module` 对象。

```
// index.js 中
setImmediate(() => {
  console.log('The index.js module object is now loaded!', module)
});
```

以上输出将得到：

```
The index.js module object is now loaded! Module {
  id: '.',
  exports: [Function],
  parent: null,
  filename: '/Users/samer/learn-node/index.js',
  loaded: true,
  children:
   [ Module {
       id: '/Users/samer/learn-node/lib/util.js',
       exports: [Object],
       parent: [Circular],
       filename: '/Users/samer/learn-node/lib/util.js',
       loaded: true,
       children: [],
       paths: [Object] } ],
  paths:
   [ '/Users/samer/learn-node/node_modules',
     '/Users/samer/node_modules',
     '/Users/node_modules',
     '/node_modules' ] }
```

>注意：这个延迟的 `console.log` 的输出显示了 `lib/util.js` 和 `index.js` 都已完全加载。

The `exports` object becomes complete when Node finishes loading the module (and labels it so). The whole process of requiring/loading a module is *synchronous.* That’s why we were able to see the modules fully loaded after one cycle of the event loop.
`exports` 对象在 Node 完成引入/加载所有模块并标记时（becomes complete……构建完成？？）。引入一个模块的整个过程是 **同步的**，因此我们才能在一个事件循环结束后看见模块被完全加载。

这也意味着我们无法异步地更改 `exports` 对象。例如，我们在任何模块中都无法执行以下操作：

```
fs.readFile('/etc/passwd', (err, data) => {
  if (err) throw err;

  exports.data = data; // 无效
});
```

#### 循环模块依赖 ####

我们现在来回答关于 Node 中循环依赖的重要问题：当我们在模块1中引用模块2，在模块2中引用模块1时会发生什么？

为了找到答案，我们在 `lib/` 下创建 `module1.js` 和 `module.js` 两个文件并让它们互相引用：

```
// lib/module1.js

exports.a = 1;

require('./module2');

exports.b = 2;
exports.c = 3;

// lib/module2.js

const Module1 = require('./module1');
console.log('Module1 is partially loaded here', Module1);
```

执行 `module1.js` 后，我们将看到：

```
~/learn-node $ node lib/module1.js
Module1 is partially loaded here { a: 1 }
```

我们在 `module1` 加载完成前引用了 `module2`，而此时 `module1` 尚未加载完，我们从当前的 `exports` 对象中得到的是在循环依赖之前导出的所有属性。这里只列出的只有属性 `a`，因为属性 `b` 和 `c` 都是在 `module2` 引入并打印了 `module1` 后导出的。

Node 使这个过程变得非常简单。它在模块加载时构建 `exports` 对象。你可以在该模块完成加载前引用它，而你将得到此时已定义的部分导出对象。

#### JSON and C/C++ addons ####
#### 使用 JSON 和 C/C++ 插件 ####

我们可以使用自带的 require 函数引用 JSON 文件和 C++ 插件。你甚至不需要为此去指定一个文件扩展。

如果一个文件扩展未被声明，Node 会在第一时间解析 `.js` 文件。如果没有找到 `.js` 文件，它将继续寻找 `.json` 文件并在找到一个 JSON 文本文件后将其解析为 `.json` 文件。随后，Node 将会查找二进制的 `.node` 文件。但是为了避免歧义，你最好在引用除 `.js` 文件以外的文件类型时声明文件扩展。

如果你需要在文件中放置的内容都是一些静态的配置信息，或定期从外部来源读取的一些值，那么使用 JSON 文件非常有用。例如，我们有以下 `config.json` 文件：

```
{
  "host": "localhost",
  "port": 8080
}
```

我们可以这样直接引用它：

```
const { host, port } = require('./config');

console.log(`Server will run at [http://${host}:${port}](http://$%7Bhost%7D:$%7Bport%7D`));

```

执行以上代码将输出以下结果：

```
Server will run at [http://localhost:8080](http://localhost:8080)
```


如果 Node 找不到 `.js` 或 `.json` 文件，它将查找一个 `.node` 文件并将其解释为一个编译后的插件模块。

Node 文档站点有一个用 C++ 编写的[插件示例](https://nodejs.org/api/addons.html#addons_hello_world)，该示例模块提供了一个输出 “world” 的 `hello()` 函数。

你可以使用 `node-gyp` 插件将 `.cc` 文件编译成 `.addon` 文件。只需要配置一个 [binding.gyp](https://nodejs.org/api/addons.html#addons_building) 文件来告诉 `node-gyp` 要做什么。

有了 `addon.node` 文件（你可以在 `binding.gyp` 中声明任意文件名），你就可以像引用其他模块一样引用它了。

```
const addon = require('./addon');

console.log(addon.hello());
```

我们可以通过 `require.extensions` 查看 Node 对这三类扩展的支持。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*IcpIrifyQIn9M0q8scMZdA.png">

你可以从各个扩展对应的函数中清楚了解 Node 对它们分别所做的操作：对 `.js` 文件使用 `module._compile`，对 `.json` 文件使用 `JSON.parse`，对 `.node` 文件使用 `process.dlopen`。

#### All code you write in Node will be wrapped in functions ####
#### 你在 Node 中写的所有代码都将被包装成函数 ####

Node 的模块打包经常被误解。要了解它的原理，请回忆一下 `exports` 与 `module.exports` 的关系。

我们可以使用 `exports` 对象导出属性，但是由于 `exports` 对象仅仅是对 `module.exports` 的一个引用，我们无法直接对其执行替换操作。

```
exports.id = 42; // 有效

exports = { id: 42 }; // 无效

module.exports = { id: 42 }; // 有效
```

这个 `exports` 对象看起来对所有模块都是全局的，它是如何被定义成 `module` 对象的引用的呢？

Let me ask one more question before explaining Node’s wrapping process.
在解释 Node 的打包进程前，再

In a browser, when we declare a variable in a script like this:

```
var answer = 42;
```

That `answer` variable will be globally available in all scripts after the script that defined it.

This is not the case in Node. When we define a variable in one module, the other modules in the program will not have access to that variable. So how come variables in Node are magically scoped?

The answer is simple. Before compiling a module, Node wraps the module code in a function, which we can inspect using the `wrapper` property of the `module` module.

```
~ $ node
> require('module').wrapper
[ '(function (exports, require, module, __filename, __dirname) { ',
  '\n});' ]
>
```

Node does not execute any code you write in a file directly. It executes this wrapper function which will have your code in its body. This is what keeps the top-level variables that are defined in any module scoped to that module.

This wrapper function has 5 arguments: `exports`, `require`, `module`, `__filename`, and `__dirname`. This is what makes them appear to look global when in fact they are specific to each module.

All of these arguments get their values when Node executes the wrapper function. `exports` is defined as a reference to `module.exports` prior to that. `require` and `module` are both specific to the function to be executed, and `__filename`/`__dirname` variables will contain the wrapped module’s absolute filename and directory path.

You can see this wrapping in action if you run a script with a problem on its first line:

```
~/learn-node $ echo "euaohseu" > bad.js
~/learn-node $ node bad.js
~/bad.js:1
(function (exports, require, module, __filename, __dirname) { euaohseu
                                                              ^

ReferenceError: euaohseu is not defined
```

Note how the first line of the script as reported above was the wrapper function, not the bad reference.

Moreover, since every module gets wrapped in a function, we can actually access that function’s arguments with the `arguments` keyword:

```
~/learn-node $ echo "console.log(arguments)" > index.js

~/learn-node $ node index.js
{ '0': {},
  '1':
   { [Function: require]
     resolve: [Function: resolve],
     main:
      Module {
        id: '.',
        exports: {},
        parent: null,
        filename: '/Users/samer/index.js',
        loaded: false,
        children: [],
        paths: [Object] },
     extensions: { ... },
     cache: { '/Users/samer/index.js': [Object] } },
  '2':
   Module {
     id: '.',
     exports: {},
     parent: null,
     filename: '/Users/samer/index.js',
     loaded: false,
     children: [],
     paths: [ ... ] },
  '3': '/Users/samer/index.js',
  '4': '/Users/samer' }
```

The first argument is the `exports` object, which starts empty. Then we have the `require`/`module` objects, both of which are instances that are associated with the `index.js` file that we’re executing. They are not global variables. The last 2 arguments are the file’s path and its directory path.

The wrapping function’s return value is `module.exports`. Inside the wrapped function, we can use the `exports` object to change the properties of `module.exports`, but we can’t reassign exports itself because it’s just a reference.

What happens is roughly equivalent to:

```
function (require, module, __filename, __dirname) {
  let exports = module.exports;

  // Your Code...

  return module.exports;
}
```

If we change the whole `exports` object, it would no longer be a reference to `module.exports`. This is the way JavaScript reference objects work everywhere, not just in this context.

#### The require object ####

There is nothing special about `require`. It’s an object that acts mainly as a function that takes a module name or path and returns the `module.exports` object. We can simply override the `require` object with our own logic if we want to.

For example, maybe for testing purposes, we want every `require` call to be mocked by default and just return a fake object instead of the required module exports object. This simple reassignment of require will do the trick:

```
require = function() {

  return { mocked: true };

}
```

After doing the above reassignment of `require`, every `require('something') `call in the script will just return the mocked object.

The require object also has properties of its own. We’ve seen the `resolve` property, which is a function that performs only the resolving step of the require process. We’ve also seen `require.extensions` above.

There is also `require.main` which can be helpful to determine if the script is being required or run directly.

Say, for example, that we have this simple `printInFrame` function in `print-in-frame.js`:

```
// In print-in-frame.js

const printInFrame = (size, header) => {
  console.log('*'.repeat(size));
  console.log(header);
  console.log('*'.repeat(size));
};
```

The function takes a numeric argument `size` and a string argument `header` and it prints that header in a frame of stars controlled by the size we specify.

We want to use this file in two ways:

1. From the command line directly like this:

```
~/learn-node $ node print-in-frame 8 Hello
```

Passing 8 and Hello as command line arguments to print “Hello” in a frame of 8 stars.

2. With `require`. Assuming the required module will export the `printInFrame` function and we can just call it:

```
const print = require('./print-in-frame');

print(5, 'Hey');
```

To print the header “Hey” in a frame of 5 stars.

Those are two different usages. We need a way to determine if the file is being run as a stand-alone script or if it is being required by other scripts.

This is where we can use this simple if statement:

```
if (require.main === module) {
  // The file is being executed directly (not with require)
}
```

So we can use this condition to satisfy the usage requirements above by invoking the printInFrame function differently:

```
// In print-in-frame.js

const printInFrame = (size, header) => {
  console.log('*'.repeat(size));
  console.log(header);
  console.log('*'.repeat(size));
};

if (require.main === module) {
  printInFrame(process.argv[2], process.argv[3]);
} else {
  module.exports = printInFrame;
}
```

When the file is not being required, we just call the `printInFrame` function with `process.argv` elements. Otherwise, we just change the `module.exports` object to be the `printInFrame` function itself.

#### All modules will be cached ####

Caching is important to understand. Let me use a simple example to demonstrate it.

Say that you have the following `ascii-art.js` file that prints a cool looking header:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*yZ57VtXUuEo-nQSs9VztvQ.png">

We want to display this header every time we *require* the file. So when we require the file twice, we want the header to show up twice.

```
require('./ascii-art') // will show the header.
require('./ascii-art') // will not show the header.
```

The second require will not show the header because of modules’ caching. Node caches the first call and does not load the file on the second call.

We can see this cache by printing `require.cache` after the first require. The cache registry is simply an object that has a property for every required module. Those properties values are the `module` objects used for each module. We can simply delete a property from that `require.cache` object to invalidate that cache. If we do that, Node will re-load the module to re-cache it.

However, this is not the most efficient solution for this case. The simple solution is to wrap the log line in `ascii-art.js` with a function and export that function. This way, when we require the `ascii-art.js` file, we get a function that we can execute to invoke the log line every time:

```
require('./ascii-art')() // will show the header.
require('./ascii-art')() // will also show the header.
```

That’s all I have for this topic. Until next time!
