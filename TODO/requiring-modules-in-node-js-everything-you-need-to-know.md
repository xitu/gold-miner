> * 原文地址：[Requiring modules in Node.js: Everything you need to know](https://medium.freecodecamp.com/requiring-modules-in-node-js-everything-you-need-to-know-e7fbd119be8#.wcrwm9c81)
> * 原文作者：本文已获原作者 [Samer Buna](https://medium.freecodecamp.com/@samerbuna) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[zhouzihanntu](https://github.com/zhouzihanntu)
> * 校对者：[lsvih](https://github.com/lsvih), [reid3290](https://github.com/reid3290)

# 关于在 Node.js 中引用模块，知道这些就够了 #

## Node.js 中模块化的工作原理 ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*AL0-iuggGnBLSvSVvt0Xzw.png">

Node 提供了两个核心模块来管理模块依赖：

- `require` 模块在全局范围内可用，不需要写 `require('require')`.    
- `module` 模块同样在全局范围内可用，不需要写 `require('module')`.

你可以将 `require` 模块理解为命令，将 `module` 模块理解为所有引入模块的组织者。

在 Node 中引入一个模块其实并不是个多么复杂的概念。

```
const config = require('/path/to/file');
```

`require` 模块导出的主对象是一个函数（如上例）。当 Node 将本地文件路径作为唯一参数调用 `require()` 时，Node 将执行以下步骤：

- **解析**：找到该文件的绝对路径。
- **加载**：确定文件内容的类型。
- **打包**：为文件划分私有作用域，这样 `require` 和 `module` 两个对象对于我们要引入的每个模块来说就都是本地的。
- **评估**：最后由虚拟机对加载得到的代码做评估。
- **缓存**：当再次引用该文件时，无需再重复以上步骤。

 在本文中，我将尝试举例说明这些不同阶段的工作原理，以及它们是如何影响我们在 Node 中编写模块的方式的。

我先使用终端创建一个目录来托管本文中的所有示例：

```
mkdir ~/learn-node && cd ~/learn-node
```

 之后的所有命令都将在 `~/learn-node` 目录下运行。

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
  paths: [ ... ]}
```

每个模块对象都有一个用于识别该对象的 `id` 属性。这个 `id` 通常是该文件的完整路径，但在 REPL 会话中只会显示为 `<repl>`。

Node 模块与文件系统中的文件有着一对一的关系。我们通过加载模块对应的文件内容到内存中来实现模块引用。

然而，由于 Node 允许使用多种方式引入文件（例如，使用相对路径或预先配置的路径），我们需要在将文件的内容加载到内存前找到该文件的绝对位置。

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

当我们引入一个文件夹时，将默认使用 `index.js` 文件，但是我们可以通过 `package.json` 中的 `main` 属性指定主入口文件。例如，要令 `require('find-me')` 解析到 `find-me` 文件夹下的另一个文件，我们只需要在该文件夹下添加一个 `package.json` 文件来声明解析该文件夹时引用的文件：

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

如果你只想解析模块而不运行，此时可以使用 `require.resolve` 函数。这个方法与 `require` 的主要功能完全相同，但是不加载文件。如果文件不存在，它仍会抛出错误；如果找到了文件，则会返回文件的完整路径。

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

>注意：`index` 主模块 `(id: '.')` 现在被列为 `lib/util` 模块的父模块。但 `lib/util` 模块并没有被列为 `index` 模块的子模块。相反，我们在这里得到的值是 `[Circular]`，因为这是一个循环引用。如果 Node 打印 `lib/util` 模块对象，将进入一个无限循环。 因此 Node 使用 `[Circular]` 代替了 `lib/util` 引用。


重点来了，如果我们在 `lib/util` 模块中引入 `index` 主模块会发生什么？这就是 Node 中所支持的循环依赖。

为了更好理解循环依赖，我们先来了解一些关于 module 对象的概念。

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

为了保持示例简短，我删除了以上输出中的一些属性，但请注意：`exports` 对象现在拥有我们在各模块中定义的属性。你可以向 exports 对象添加任意多的属性，也可以直接将整个 exports 对象替换为其它对象。例如，我们可以通过以下方式将 exports 对象更改为一个函数：

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

>注意：我们并没有使用 `exports = function() {}` 来将 `exports` 对象更改为函数。实际上，由于各模块中的 `exports` 变量仅仅是对管理输出属性的 `module.exports` 的引用，当我们对 `exports` 变量重新赋值时，引用就会丢失，因此我们只需要引入一个新的变量，而不是对 `module.exports` 进行修改。

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

`module` 模块使用 `loaded` 属性对模块的加载状态进行跟踪，判断哪些模块已经加载完成（值为 true）以及哪些模块仍在加载（值为 false）。例如，我们可以使用 `setImmediate` 在下一个事件循环中打印出它的 `module` 对象，以此来判断 `index.js` 模块是否已完全加载。

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

在 Node 完成加载模块（并标记为完成）时，`exports` 对象也就完成了。引入一个模块的整个过程是 **同步的**，因此我们才能在一个事件循环后看见模块被完全加载。

这也意味着我们无法异步地更改 `exports` 对象。例如，我们在任何模块中都无法执行以下操作：

```
fs.readFile('/etc/passwd', (err, data) => {
  if (err) throw err;

  exports.data = data; // 无效
});
```

#### 模块的循环依赖 ####

我们现在来回答关于 Node 中循环依赖的重要问题：当我们在模块1中引用模块2，在模块2中引用模块1时会发生什么？

为了找到答案，我们在 `lib/` 下创建 `module1.js` 和 `module2.js` 两个文件并让它们互相引用：

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

我们在 `module1` 加载完成前引用了 `module2`，而此时 `module1` 尚未加载完，我们从当前的 `exports` 对象中得到的是在循环依赖之前导出的所有属性。这里被列出的只有属性 `a`，因为属性 `b` 和 `c` 都是在 `module2` 引入并打印了 `module1` 后才导出的。

Node 使这个过程变得非常简单。它在模块加载时构建 `exports` 对象。你可以在该模块完成加载前引用它，而你将得到此时已定义的部分导出对象。

#### 使用 JSON 文件和 C/C++ 插件 ####

我们可以使用自带的 require 函数引用 JSON 文件和 C++ 插件。你甚至不需要为此指定文件扩展名。

如果没有指定文件扩展名，Node 会在第一时间尝试解析 `.js` 文件。如果没有找到 `.js` 文件，它将继续寻找 `.json` 文件并在找到一个 JSON 文本文件后将其解析为 `.json` 文件。随后，Node 将会查找二进制的 `.node` 文件。为了避免产生歧义，你最好在引用除 `.js` 文件以外的文件类型时指定文件扩展名。

如果你需要在文件中放置的内容都是一些静态的配置信息，或者需要定期从外部来源读取一些值时，使用 JSON 文件将非常方便。例如，我们有以下 `config.json` 文件：

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


如果 Node 找不到 `.js` 或 `.json` 文件，它会寻找 `.node` 文件并将其作为一个编译好的插件模块进行解析。

Node 文档中有一个用 C++ 编写的[插件示例](https://nodejs.org/api/addons.html#addons_hello_world)，该示例模块提供了一个输出 “world” 的 `hello()` 函数。

你可以使用 `node-gyp` 插件将 `.cc` 文件编译成 `.addon` 文件。只需要配置一个 [binding.gyp](https://nodejs.org/api/addons.html#addons_building) 文件来告诉 `node-gyp` 要做什么。

有了 `addon.node` 文件（你可以在 `binding.gyp` 中声明任意文件名），你就可以像引用其他模块一样引用它了。

```
const addon = require('./addon');

console.log(addon.hello());
```

我们可以在 `require.extensions` 中查看 Node 对这三类扩展名的支持。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*IcpIrifyQIn9M0q8scMZdA.png">

你可以看到每个扩展名分别对应的函数，从中了解 Node 会对它们做出怎样的操作：对 `.js` 文件使用 `module._compile`，对 `.json` 文件使用 `JSON.parse`，对 `.node` 文件使用 `process.dlopen`。

#### 你在 Node 中写的所有代码都将被封装成函数 ####

常常有人误解 Node 的模块封装。要了解它的原理，请回忆一下 `exports` 与 `module.exports` 的关系。

我们可以使用 `exports` 对象导出属性，但是由于 `exports` 对象仅仅是对 `module.exports` 的一个引用，我们无法直接对其执行替换操作。

```
exports.id = 42; // 有效

exports = { id: 42 }; // 无效

module.exports = { id: 42 }; // 有效
```

这个 `exports` 对象看起来对所有模块都是全局的，它是如何被定义成 `module` 对象的引用的呢？

在解释 Node 的封装过程前，让我们再来思考一个问题：

在浏览器中，我们在脚本里声明如下变量：

```
var answer = 42;
```

`answer` 变量对声明该变量的脚本后的所有脚本来说都是全局的。

然而在 Node 中却不是这样的。我们在一个模块中定义了变量，项目中的其他模块却将无法访问该变量。那么 Node 是如何神奇地做到为变量限定作用域的呢？

答案很简单。在编译模块前，Node 就将模块代码封装在一个函数中，我们可以使用 `module` 模块的 `wrapper` 属性来查看。

```
~ $ node
> require('module').wrapper
[ '(function (exports, require, module, __filename, __dirname) { ',
  '\n});' ]
>
```

Node 并不会直接执行你在文件中写入的代码。它执行的是封装着你的代码的函数。这就保证了所有模块中定义的顶级变量的作用域都被限定在该模块中。

这个封装函数包含五个参数：`exports`、`require`、`module`、`__filename` 和 `__dirname`。这些参数看起来像是全局的，实际上却是每个模块特定的。

在 Node 执行封装函数的同时，以上这几个参数都获取到了它们的值。`exports` 被定义为对上一级 `module.exports` 的引用。`require` 和 `module` 都是特定于被执行函数的，而 `__filename`/`__dirname` 变量将包含被封装模块的文件名和目录的绝对路径。

如果你在一个脚本的第一行编写一行错误代码并执行它，你就能看到实际的封装过程：

```
~/learn-node $ echo "euaohseu" > bad.js
~/learn-node $ node bad.js
~/bad.js:1
(function (exports, require, module, __filename, __dirname) { euaohseu
                                                              ^

ReferenceError: euaohseu is not defined
```

>注意：这里脚本第一行是作为封装函数中的代码报错的，而不是错误的引用。

此外，由于每个模块都被封装在一个函数中，我们可以使用 `arguments` 关键字访问该函数的参数：

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

第一个参数是 `exports` 对象，初始值为空。`require`/`module` 对象都与当前执行的 `index.js` 文件的实例关联。它们不是全局变量。最后两个参数分别为当前文件路径和目录路径。

封装函数的返回值是 `module.exports`。在封装函数中，我们可以使用 `exports` 对象更改 `module.exports` 的属性，但是由于它仅仅是一个引用，我们无法对其重新赋值。

情况大致如下：

```
function (require, module, __filename, __dirname) {
  let exports = module.exports;

  // 你的代码…

  return module.exports;
}
```

如果我们更改了整个 `exports` 对象，它将不再是对 `module.exports` 的引用。并不仅仅是在这个上下文中，JavaScript 在任何情况下引用对象都是这样的。

#### require 对象 ####

`require` 没有什么特别的。它作为一个函数对象，接收一个模块名称或路径，返回 `module.exports` 对象。我们也可以用我们自己的逻辑重写 `require` 对象。

举个例子，为了测试的目的，我们希望每个 `require` 的调用都返回一个伪造的 mocked 对象，而不是引用的模块所导出的对象。这个对 require 的简单重新赋值会这样实现：

```
require = function() {

  return { mocked: true };

}
```

经过以上对 `require` 重新赋值后，脚本中的每个 `require('something')` 调用都会返回 mocked 对象。

require 对象也有它自己的属性。我们已经认识了 `resolve` 属性，它是在 require 过程中负责解析步骤的函数。我们也见识了 `require.extensions`。

还有 `require.main` 属性，有助于判断当前脚本是正被引用还是直接执行。

举个例子，我们在 `print-in-frame.js` 中定义一个简单的 `printInFrame` 函数：

```
// 在 print-in-frame.js 中

const printInFrame = (size, header) => {
  console.log('*'.repeat(size));
  console.log(header);
  console.log('*'.repeat(size));
};
```

该函数使用一个数字型参数 `size` 和一个字符串型参数 `header`，并在我们指定大小的星号框中将标题打印出来。

我们希望通过两种方式执行该文件：

1. 在命令行下直接运行：

```
~/learn-node $ node print-in-frame 8 Hello
```

将 8 和 Hello 作为命令行参数，打印出由8个星号组成的框以及 “Hello”。

2. 使用 `require`。假设被引用的模块会导出 `printInFrame` 函数，我们可以这样调用它：

```
const print = require('./print-in-frame');

print(5, 'Hey');
```

打印由五个星号组成的框以及其中的标题 “Hey”。

以上是两种不同的用法。我们需要一种方法来确定该文件是作为独立脚本运行还是被其他脚本引用时运行。

此时我们可以使用简单的 if 声明语句：

```
if (require.main === module) {
  // 该文件正被直接运行
}
```

所以我们可以使用该条件判断来满足上述使用需求，通过不同的方式调用 printInFrame 函数。

```
// 在 print-in-frame.js 中

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

如果文件不是被引用的，我们使用 `process.argv` 的参数来调用 `printInFrame` 函数。否则我们就将 `module.exports` 对象替换为 `printInFrame` 函数。

#### 所有模块都将被缓存 ####

理解缓存非常重要。下面我用一个简单的例子来演示一下。

假设你有以下 `ascii-art.js` 文件，它能打印出一个很酷的标题：


<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*yZ57VtXUuEo-nQSs9VztvQ.png">

我们希望在每次 **引用** 该文件时都显示这个标题。因此如果我们引用了两次该文件，我们希望标题显示两次。

```
require('./ascii-art') // 显示标题
require('./ascii-art') // 不显示标题
```

由于模块缓存，第二次的引用将不会显示标题。Node 会在第一次调用时进行缓存，在第二次调用时不再加载文件。

我们可以通过在第一次引用后打印 `require.cache` 来查看缓存。管理缓存的是一个对象，它的属性值分别对应引用过的模块。这些属性值即用于各模块的 `module` 对象。我们可以通过简单地从 `require.cache` 对象中删除一个属性来令该缓存失效，然后 Node 就会再次加载并缓存该模块。

然而，这并不是应对这种情况最高效的解决方案。简单的解决办法是将 `ascii-art.js` 中的打印代码用一个函数封装起来并导出该函数。通过这种方式，每当我们引用 `ascii-art.js` 文件时，我们就能获取到一个可执行函数，以供我们多次调用打印代码：

```
require('./ascii-art')() // 显示标题
require('./ascii-art')() // 显示标题
```

以上就是我关于本次主题所要讲述的全部内容。回见！
