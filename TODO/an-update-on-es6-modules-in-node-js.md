> * 原文地址：[An Update on ES6 Modules in Node.js ](https://medium.com/@jasnell/an-update-on-es6-modules-in-node-js-42c958b890c#.o3doprfmu)
* 原文作者：[James M Snell](https://medium.com/@jasnell?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[hikperpig](https://github.com/hikerpig)
* 校对者：[showd0wn](https://github.com/showd0wn), [Tina92](https://github.com/Tina92)

# Node.js 支持 ES6 模块的进展 #

（译者注：作者 James M Snell 任职于 IBM，是 Node.js 项目的核心贡献者之一）

几个月前我写了篇[文章](https://hackernoon.com/node-js-tc-39-and-modules-a1118aecf95e)阐述 Node.js 现有的 CommonJS 模块系统与 ES6 模块系统的一些区别，以及由此产生的在 Node.js 中实现 ES6 模块系统的挑战。本文将跟进相关进展。

### 何时知晓 ###

如果你没有读过我之前的文章，在继续阅读之前，建议你[看一下](https://hackernoon.com/node-js-tc-39-and-modules-a1118aecf95e)，里面描述了两种模块系统架构一些重大差异。简单来说：CommonJS 和 ES6 模块的根本差异在于模块结构解析完全并能够在其他代码里使用的时机。

例如，有如下简单的 CommonJS 模块，姑且称为 `foobar` 模块。

```
function foo() {
  return 'bar';
}
function bar() {
  return 'foo';
}
module.exports.foo = foo;
module.exports.bar = bar;
```

现在我们用一个 `app.js` 文件引用此模块：

```
const {foo, bar} = require('foobar');
console.log(foo(), bar());
```

在命令行里执行 `node app.js` 时，Node.js 程序读取并开始解析 `app.js` 文件的内容，执行代码。执行期间 `require()` 函数被调用，**同步**地读取 `foobar.js` 内容载入内存，**同步**解析和编译 JavaScript 代码，而后**同步**执行代码，将 `module.exports` 的返回值 `app.js` 中 `require('foobar')` 的值。`app.js` 中的 `require()` 函数执行完后，`foobar` 模块的结构已知并能被调用。以上所有的一切全发生在 Node.js 事件循环的一次执行中。

理解 CommonJS 和 ES6 差异的重要一点，在于 CommonJS 模块的结构（模块的 API）在模块代码执行完之前是未知的，即便在执行完后，其结构也随时能被其他代码更改。

以下是在 ES6 语法下的“等效”模块:

```
export function foo() {
  return 'bar';
}

export function bar() {
  return 'foo';
}
```

调用的代码如下：

```
import {foo, bar} from 'foobar';
console.log(foo());
console.log(bar());
```

根据 ECMAScript 标准，ES6 模块与 CommonJS 实现步骤有很大差异。第一步，从硬盘读取文件内容的步骤大体相同，不过有可能是**异步**的。得到内容后进行解析时，决定模块结构的 `export` 声明，**优先** 于代码的执行。在结构定义完了以后，才执行代码。很重要的一点是，所有的 `import` 和 `export` 声明指向的目标在代码执行前就都确定了。还有一点，ES6 标准允许分解的步骤**异步**进行。对 Node.js 来说，意味着读取脚本内容、解析模块引用关系、执行模块代码这些步骤可以在事件循环中轮番进行。

### 时机决定一切 ###

我们实现 ES6 模块标准时的一个主要目标，是尽可能地无缝切换。我们希望能够同时兼容两种标准，且对使用者隐藏两种标准细节的差别，例如 `require('es6-module')` 和 `import from 'commonjs-module'` 都能正常工作。

不幸的是，事情没那么简单。

由于 ES6 模块的读取和解析都是异步的，这就不可能 `require()` 一个 ES6 模块，因为 `require()` 是个同步的函数。若通过改变 `require()` 函数的语义去支持异步加载，会让整个社区闹得鸡犬不宁。因此我们考虑过写一个 `require.import()` 作为 ES6 [提议](https://github.com/tc39/proposal-dynamic-import)的 `import()` 函数实现。该函数返回一个 `Promise` 对象, 其于 ES6 模块载入完成时解决 (resolve) 。虽说这不是最理想的方案，但起码能在现有的 CommonJS 风格 Node.js 代码中使用 ES6 模块。

一个小小好消息是，在 ES6 模块中通过 `import` 声明使用 CommonJS 模块应该变得很容易。因为并不总强制异步加载。为更好支持此点，ECMAScript 语言标准将会有一些更改，不过当一切稳定下来后，肯定是能正常使用的。

但是可能有个巨大的坑……

### 哎妈呀，可怜的具名引入 ###

具名引入 (named import) 是 ES6 模块系统的重要功能，如下例：

```
import {foo, bar} from 'foobar';
```

从 `foobar` 模块中引入 `foo` 和 `bar` 变量，这些发生在模块解析阶段 - 在任何实际代码执行**之前**。因为在 ES6 中模块结构是预先定义的。

然而在 CommonJS 中，模块结构在代码执行完之前是未定的。意味着若不大改 ECMAScript 语言标准，不可能具名引入一个 CommonJS 模块的内容。无奈之下，开发者不得不使用 ES6 模块中的 'default' 暴露声明。例如，使用本文开头的 CommonJS 模块样例代码，引入的代码要这样写：

```
import foobar from 'foobar';
console.log(foobar.foo(), foobar.bar());
```

与之前有微小但及其重要的差别。使用 `import` 声明来引入 CommonJS 模块的时候，没法使用如下写法来将 `foo` 和 `bar` 指向 CommonJS 模块暴露的 `foo()` 和 `bar()` 函数。

```
import {foo, bar} from 'foobar';
```

### 但在 Babel 中还是可以用的 ###

正在使用像 Babel 之类的转译工具的人，使用 ES6 模块语法时多半熟悉其具名引入特性。Babel 将 ES6 代码转换为能在 Node.js 中使用的 CommonJS 风格代码。语法和 ES6 似乎一样，但具体**实现却不是**。理解这点很重要：Babel 处理 ES6 具名引入的方式和完整遵循 ES6 标准要求的实现根本不是一回事。

### Michael Jackson Script ###

CommonJS 和 ES6 模块的另一个根本区别在于，ECMAScript 编译器在载入模块之前需要知道它属于哪种模块系统。因为 ES6 模块中的 `export` 和 `import` 声明需要在运行代码之前解析。

这就要求 Node.js 要有预先探知文件模块类型的机制。在多种方案中挣扎后，我们觉得闹心程度最低的是引入一个新的 `*.mjs` 扩展名（过去曾被我们深情地称为 'Michael Jackson Script'）来显式标记该 JavaScript 文件使用 ES6 模块标准处理。

换句话说，对待两个文件 `foo.js` 和 `bar.mjs`，使用 `import * from 'foo'` 会将 `foo.js` 当作 CommonJS 模块引入，而使用 `import * from 'bar'` 会将 `bar.mjs` 当作 ES6 模块。

### 时间规划 ###

目前，在 ES6 和虚拟机层面的标准和实现还需要许多更改，Node.js 才能开始尝试支持 ES6 模块。相关工作已经开始，但离完成还要等一段时间，我们估计**至少**要一年。
