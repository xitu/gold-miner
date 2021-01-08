> * 原文地址：[Algebraic Effects for the Rest of Us](https://overreacted.io/algebraic-effects-for-the-rest-of-us/)
> * 原文作者：[Dan Abramov](https://overreacted.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/algebraic-effects-for-the-rest-of-us.md](https://github.com/xitu/gold-miner/blob/master/TODO1/algebraic-effects-for-the-rest-of-us.md)
> * 译者：[TiaossuP](https://github.com/TiaossuP)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234)、[Baddyo](https://github.com/Baddyo)

# 写给大家的代数效应入门

你听说过**代数效应**（**Algebraic Effects**）么？

我第一次研究「它是什么」以及「我为何要关注它」的尝试以失败告终。我看了[一些](https://www.eff-lang.org/handlers-tutorial.pdf) [PDF](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/08/algeff-tr-2016-v2.pdf)，但最终我更加懵逼了。（其中有一些偏学术性质的 pdf 真是催眠。）

但是我的同事 Sebastian [总](https://mobile.twitter.com/sebmarkbage/status/763792452289343490)[是](https://mobile.twitter.com/sebmarkbage/status/776883429400915968)[将其](https://mobile.twitter.com/sebmarkbage/status/776840575207116800)[称为](https://mobile.twitter.com/sebmarkbage/status/969279885276454912)我们在 React 内部的一些工作的心智模型（Sebastian 在 React 团队，并贡献出了 Hooks、Suspense 等创意）。从某个角度来说，这已经成了 React 团队内部的一个梗 —— 我们很多讨论都会以这张图结束：

[![](https://overreacted.io/static/5fb19385d24afb94180b6ba9aeb2b8d4/79ad4/effects.jpg)](https://overreacted.io/static/5fb19385d24afb94180b6ba9aeb2b8d4/79ad4/effects.jpg) 

事实证明，代数效应是一个很酷的概念，并不像我从那些 pdf 看到得那样可怕。**如果你只是使用 React，你不需要了解它们 —— 但如果你像我一样，对其感到好奇，请继续阅读。**

**（免责声明：我不是编程语言研究员、不是这个话题的权威人士，可能我这里的介绍有错漏，所以哪里有问题的话，请告诉我！）**

### 暂时还不能投产

**代数效应**是一个处在研究阶段的编程语言特性，这意味着其不像 if、functions、async / await 一样，你可能无法在生产环境真正用上它，它现在只被[几个](https://www.eff-lang.org/)[语言](https://www.microsoft.com/en-us/research/project/koka/)支持，而这几个语言是专门为了研究此概念而创造的。在 Ocaml 中实现代数效应的进展还处于[进行中状态](https://github.com/ocaml-multicore/ocaml-multicore/wiki)。换句话说，你碰不到它（原文：[Can’t Touch This](https://www.youtube.com/watch?v=otCpCn0l4Wo)）

> 补充：一些人说 LISP 提供了[类似的功能]((https://overreacted.io/algebraic-effects-for-the-rest-of-us/#learn-more))，所以如果你写 LISP，就可以在生产环境中用上该功能了。

### 所以我为啥关心它？

想象你写 `goto` 的代码时，有人向你介绍了 `if` 与 `for` 语句，或者陷入回调地狱的你看到了 `async / await` —— 是不是碉堡了？

如果你是那种在某些编程概念成为主流之前就乐于了解它们的人，那么现在可能是对代数效应感到好奇的好时机。不过这也不是必须的，这有点像 1999 年的 `async / await` 设想。

### 好的，什么是代数效应？

这个名称可能有点令人生畏，但这个思想其实很简单。如果你熟悉 `try / catch` 块，你会更容易大致理解代数效应。

我们先来回顾一下 `try / catch`。假设你有一个会 throw 的函数。也许它和 `catch` 块之间还有很多层函数：

```js
function getName(user) {
  let name = user.name;
  if (name === null) {
  	throw new Error('A girl has no name');  }
  return name;
}

function makeFriends(user1, user2) {
  user1.friendNames.add(getName(user2));
  user2.friendNames.add(getName(user1));
}

const arya = { name: null };
const gendry = { name: 'Gendry' };
try {
  makeFriends(arya, gendry);
} catch (err) {
  console.log("Oops, that didn't work out: ", err);}
```

我们在 `getName` 里面 `throw`，但它「冒泡」到了离 `makeFriends` 最近的 `catch` 块。这是 `try / catch` 的一个重要属性。**调用的中间层不需要关心错误处理。**

与 C 语言中的错误代码不同，通过 `try / catch`，您不必手动将 error 传递到每个中间层，以免丢失它们。它们会自动冒泡。

### 这与代数效应有什么关系？

在上面的例子中，一旦我们遇到错误，代码就无法继续执行。当我们最终进入 `catch` 块时，就无法再继续执行原始代码了。

完蛋了，一步出错全盘皆输。这太晚了。我们顶多也就只能从失败中恢复过来，也许还可以通过某种方式重试我们正在做的事情，但不可能神奇地「回到」我们代码刚刚所处的位置，并做点儿别的事情。**但凭借代数效应，我们可以。**

这是一个用假想的 JavaScript 方言编写的例子（为了搞事，让我们称其为 ES2025），让我们从缺失的 `user.name`「恢复」一下：

```js
function getName(user) {
  let name = user.name;
  if (name === null) {
  	name = perform 'ask_name';  
  }
  return name;
}

function makeFriends(user1, user2) {
  user1.friendNames.add(getName(user2));
  user2.friendNames.add(getName(user1));
}

const arya = { name: null };
const gendry = { name: 'Gendry' };
try {
  makeFriends(arya, gendry);
} handle (effect) {
  if (effect === 'ask_name') {
    resume with 'Arya Stark'; 
  }
}
```

**（我向 2025 年在网上搜索「ES2025」并找到这篇文章的所有读者致歉。如果未来代数效应成为了 JavaScript 的一部分，我很乐意更新这篇文章！）**

我们使用一个假设的 `perform` 关键字代替 `throw`。同样，我们使用假想的 `try / handle` 语句来代替 `try / catch`。**确切的语法在这里并不重要 —— 我们只是随便编个语法来表达这个思想。**

那么发生了什么？让我们仔细看看。

我们 **perform** 了一个 **effect**，而不是 throw 一个 error。就像我们可以 `throw` 任何值一样，我们可以将任何值传给 `perform`。在这个例子中，我传入了一个字符串，但它可以是一个对象，或任何其他数据类型：

```js
function getName(user) {
  let name = user.name;
  if (name === null) {
  	name = perform 'ask_name';  
  }
  return name;
}
```

当我们 `throw` 了一个 error 时，引擎会在调用堆栈中查找最接近的 `try / catch` error handler。类似地，当我们 `perform` 了一个 effect 时，引擎会在调用堆栈中搜索最接近的 `try / handle` **effect handler**。

```js
try {
  makeFriends(arya, gendry);
} handle (effect) {
  if (effect === 'ask_name') {
  	resume with 'Arya Stark';
  }
}
```

这个 effect 让我们决定如何处理缺少 name 的情况。这里的假想语法（对应错误处理）是 `resume with`：

```js
try {
  makeFriends(arya, gendry);
} handle (effect) {
  if (effect === 'ask_name') {
  	resume with 'Arya Stark';  
  }
}
```

这可是你用 `try / catch` 做不到的事情。它允许我们**跳回到我们 perform effect 的位置，并从 handler 传回一些东西**。🤯

```js
function getName(user) {
  let name = user.name;
  if (name === null) {
  	// 1. 我们在这里 perform 了一个 effect：name = perform 'ask_name';
  	// 4. …… 然后最终回到了这里（name 现在是「Arya Stark」了 
  }
  return name;
}

// ...

try {
  makeFriends(arya, gendry);
} handle (effect) {
  // 2. 我们跳到了handler（就像 try/catch）
  if (effect === 'ask_name') {
  	// 3. 然而我们可以 resume with 一个值（这就不像 try / catch 了！）
  	resume with 'Arya Stark';
  }
}
```

这需要你花一些时间来适应，但它在概念上与「可恢复的 `try / catch`」没有太大的不同。

但是请注意，**代数效应要比 try / catch 更灵活，并且可恢复的错误只是许多可能的用例之一**。我从这个角度开始介绍只是因为这是最容易理解的方式。

### 不会染色的函数

代数效应对异步代码有非常有趣的价值。

在具有 `async / await` 的语言中，[函数通常具有「颜色」](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/)。例如，在 JavaScript 中，我们不能将 `getName` 标识为异步，但不为其调用者 `makeFriends` 及 `makeFriends` 的调用者增加 `async` 关键字。一段代码有时需要同步、有时需要异步时，开发起来其实会比较痛苦。

```js
// 如果我们想在这里加一个 async 关键字
async getName(user) {
  // ...
}

// 那么这里也就必须也是 async 了……
async function makeFriends(user1, user2) {
  user1.friendNames.add(await getName(user2));
  user2.friendNames.add(await getName(user1));
}

// 以此类推……
```

JavaScript 的 generator [同样类似](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*)：如果你用了 generator，那么中间层也都得改为 generator 形式了。

那这跟代数效应有什么关系？

让我们暂时忘记 `async / await` 并回到我们的例子：

```js
function getName(user) {
  let name = user.name;
  if (name === null) {
  	name = perform 'ask_name';  
  }
  return name;
}

function makeFriends(user1, user2) {
  user1.friendNames.add(getName(user2));
  user2.friendNames.add(getName(user1));
}

const arya = { name: null };
const gendry = { name: 'Gendry' };
try {
  makeFriends(arya, gendry);
} handle (effect) {
  if (effect === 'ask_name') {
    resume with 'Arya Stark';
  }
}
```

如果我们的 effect handler 不能同步返回「fallback name」怎么办？如果我们想从数据库中获取它会怎么样？

事实证明，我们在 effect handler 中异步调用 `resume with`，无需对 `getName` 和 `makeFriends` 做任何修改：

```js
function getName(user) {
  let name = user.name;
  if (name === null) {
  	name = perform 'ask_name';
  }
  return name;
}

function makeFriends(user1, user2) {
  user1.friendNames.add(getName(user2));
  user2.friendNames.add(getName(user1));
}

const arya = { name: null };
const gendry = { name: 'Gendry' };
try {
  makeFriends(arya, gendry);
} handle (effect) {
  if (effect === 'ask_name') {
    setTimeout(() => {
      resume with 'Arya Stark';
    }, 1000);
  }
}
```

在这个例子中，我们在 1 秒后，才调用了 `resume with`。您可以将 `resume with` 视为一个只调用一次的回调。（你也可以通过称它为「限定单次延续（one-shot delimited continuation）」来将其安利给你的朋友。）

现在代数效应的机制应该更清晰一些了。当我们 `throw` 了一个 error 时，JavaScript 引擎会「展开堆栈（unwind the stack）」，破坏进程中的局部变量。但是，当我们 `perform` 了一个 effect 时，我们的假设引擎将使用我们的其余函数「创建一个回调」，并用 `resume with` 调用它。

**再次提醒：这些语法和特定的关键字是本文专用的。它们不是重点，重点在于理解机制本身。**

### 关于纯函数的贴士

值得注意的是，代数效应来自函数式编程研究。他们解决的一些问题是纯函数式编程所特有的。例如，那些**不允许**随意副作用的语言（比如 Haskell），你必须使用 Monads 之类的概念来将其适配到你的程序中。如果您曾阅读过 Monad 教程，您会发现这些概念有点难以理解。代数效应有助于做更少的仪式性代码。

这就是为什么关于代数效应的诸多讨论对我来说都是晦涩难懂的。（我之前并[不知道](https://overreacted.io/things-i-dont-know-as-of-2018/) Haskell 和它的小伙伴们）但是，我认为，即使是像 JavaScript 这样的非纯函数式语言，**代数效应仍然是一个非常强力的工具，它可以帮你分离代码中的「做什么」与「怎么做」**

它们使你能够专注于写「做什么」的代码：

```js
function enumerateFiles(dir) {
  const contents = perform OpenDirectory(dir);
  perform Log('Enumerating files in ', dir);
  for (let file of contents.files) {
  	perform HandleFile(file);
  }
  perform Log('Enumerating subdirectories in ', dir);
  for (let directory of contents.dir) {
  	// 我们可以使用递归，或调用其他具有 effect 的函数
  	enumerateFiles(directory);
  }
  perform Log('Done');
}
```

然后用一些描述「怎么做」的代码将其包裹起来。

```js
let files = [];
try {
  enumerateFiles('C:\\');
} handle (effect) {
  if (effect instanceof Log) {
  	myLoggingLibrary.log(effect.message);
  	resume;
  } else if (effect instanceof OpenDirectory) {
  	myFileSystemImpl.openDir(effect.dirName, (contents) => {
      resume with contents;
    });
  } else if (effect instanceof HandleFile) {
    files.push(effect.fileName);
    resume;
  }
}
// `files` 数组现在有所有文件了
```

这意味着还可以将其封装为库：

```js
import { withMyLoggingLibrary } from 'my-log';
import { withMyFileSystem } from 'my-fs';

function ourProgram() {
  enumerateFiles('C:\\');
}

withMyLoggingLibrary(() => {
  withMyFileSystem(() => {
    ourProgram();
  });
});
```

与 `async / await`、Generator 不同，**代数效应不需要「中间层函数」做相应适配**。我们的 `enumerateFiles` 可能在 `ourProgram` 的很深层被调用，但只要**外层**有一个 effect handler 为每一个 effect 提供对应的 perform，我们的代码就仍然可以工作。

Effect handler 让我们可以将程序逻辑与其具体的 effect 实现分离，而无需过多的仪式性代码或样板代码。例如，我们可以完全重载测试中的行为，使用假文件系统，或者用快照日志代替 console 输出：

```js
import { withFakeFileSystem } from 'fake-fs';

function withLogSnapshot(fn) {
  let logs = [];
  try {
  	fn();
  } handle (effect) {
  	if (effect instanceof Log) {
  	  logs.push(effect.message);
  	  resume;
  	}
  }
  // 快照触发日志
  expect(logs).toMatchSnapshot();
}

test('my program', () => {
  const fakeFiles = [/* ... */];
  withFakeFileSystem(fakeFiles, () => {
    withLogSnapshot(() => {
      ourProgram();
    });
  });
});
```

因为没有[「函数颜色」](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/)（中间的代码不需要知道 effect ）并且 effect handler 是**可组合的**（您可以嵌套它们），所以您可以使用它们创建非常富有表现力的抽象。

### 关于类型的注意点

由于代数效应这一概念来自静态类型语言，因此关于它们的大部分争论都集中在它们如何用类型表达上。这无疑是重要的，但也可能使掌握这一概念变得具有挑战性。这就是这篇文章根本不讨论类型的原因。但是，我应该指出，如果一个函数可以 preform 一个 effect 的话，则可以将其编码到类型签名中。所以，就不应该出现一个随机 effect 出现，但无法追踪它们来自何处的情况了。

您可能会认为代数效应在技术上会为静态类型语言中的函数[「赋予颜色」](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/)，因为 effect 是类型签名的一部分。确实如此。但是，「改动中间函数的类型声明以为其包含新 effect」本身并不是语义更改 —— 这与添加 `async` 或将函数转换为 generator 不同。类型推导还可以帮助避免级联更改。一个重要的区别是，您可以通过提供 noop 或 mock 实现（例如，为异步 effect 提供一个同步调用）来「填充」effect，来防止它在必要时到达外部代码，或者将其转换为不同的 effect。

### 我们应该为 JavaScript 添加代数效应吗？

老实说，我不知道。它们非常强大，你甚至可以说，它们可能对 JavaScript 这样的语言来说**太过**强大了。

我认为它们非常适合那些不常出现变化（mutation）、标准库完全拥抱 effect 的语言。如果你主要做 `perform Timeout(1000)`、`perform Fetch('http://google.com')` 以及 `perform ReadFile('file.txt')` 这类工作，并且你的语言有模式匹配和静态 effect 类型，它可能是一个非常好的编程环境。

也许这种语言甚至可以编译成 JavaScript！

### 所有这些都与 React 相关？

并没有那么相关。你甚至可以说这只是一些「延伸知识」。

如果您看过[我关于 Time Slicing 和 Suspense 的探讨](https://reactjs.org/blog/2018/03/01/sneak-peek-beyond-react-16.html)，第二部分涉及从缓存中读取数据的组件：

```js
function MovieDetails({ id }) {
  // 如果它仍然在 fetched 状态怎么办
  const movie = movieCache.read(id);
}
```

**(这场探讨使用了略有不同的 API ，但不重要。)**

这构建于一个名为「Suspense」的 React 功能之上，该功能正积极地开发中，用于请求数据这种场景。当然，有趣的部分是 `movieCache` 中没有数据的情况 —— 在这种情况下我们需要做一些事情，因为我们现在无法继续了。从技术上讲，在这种情况下，`read()`调用会 throw 一个 Promise（没错，就是 **throw** 了一个 Promise —— 让它陷入其中）。这挂起（suspends）了执行。React 捕获到 Promise，并会记得在该 Promise 变为 resolve 后，重新尝试渲染组件树。

即使这个技巧是[受其启发](https://mobile.twitter.com/sebmarkbage/status/941214259505119232)的，但这本身并不是代数效应。不过它实现了相同的目标：调用堆栈中的偏底层的一些代码直接触发了偏上层的一些代码（在这种情况下，为 React），而无需所有中间函数必须知道它为 `async` 或 generator 。当然，我们无法在 JavaScript 中真正地**恢复**（**resume**）执行，但从 React 的角度来看，这跟「当 Promise resolve 时重新渲染组件树」几乎是一回事。当你的编程模型[假设幂等](https://overreacted.io/react-as-a-ui-runtime/#purity)时，你就可以这么取巧！

[Hooks](https://reactjs.org/docs/hooks-intro.html) 是另一个可能提醒你代数效应的例子。人们提出的第一个问题是：一个 `useState` 调用怎么可能知道它所指的是哪个组件？

```js
function LikeButton() {
  // useState 怎么知道它在哪个组件里？
  const [isLiked, setIsLiked] = useState(false);
}
```

我已经在[这篇文章的末尾](https://overreacted.io/zh-hans/how-does-setstate-know-what-to-do/)解释了答案：React 对象（指你现在正在使用的实现（例如`react-dom`））上有一个「current dispatcher」这一可变状态。类似地，还有一个「current component」属性指向我们 `LikeButton` 的内部数据结构。这就是 `useState` 知道该怎么做的原因。

在人们习惯之前，他们常常认为这有点「脏」，原因很明显。依靠共享的可变状态让人「感觉不太对」。**（旁注：您认为 `try / catch` 是如何在 JavaScript 引擎中实现的？）**

但是，从概念上讲，您可以将 `useState()`视为：在 React 执行组件时的一个 `perform State()` effect。这将「解释」为什么 React（调用你的组件的东西）可以为它提供状态（它位于调用堆栈中，因此它可以提供 effect handler）。实际上，[实现状态](https://github.com/ocamllabs/ocaml-effects-tutorial/#2-effectful-computations-in-a-pure-setting)是我遇到的代数效应教程中最常见的例子之一。

当然，这并不是 React 的**真实**工作方式，因为我们在 JavaScript 中没有代数效应。事实上：我们维持当前组件时，还维持了一个隐藏字段，以及一个指向携带 useState 具体实现的 current dispatcher 的字段。比如出于性能优化考虑，有独立的[为 mount 与 update](https://github.com/facebook/react/blob/2c4d61e1022ae383dd11fe237f6df8451e6f0310/packages/react-reconciler/src/ReactFiberHooks.js#L1260-L1290) 特供的 `useState` 实现。但是如果概括考量这段代码，你可能会把它们看做 effect handler。

总而言之，在 JavaScript，throw 可以作为 IO effects 的粗略近似（只要以后可以安全地重新执行代码，并且不受 CPU 限制）；而具有可变的、在 `try / finally` 中被执行的「dispatcher」字段，可以作为 effect handler 的粗略近似值。

您还可以[使用 generator](https://dev.to/yelouafi/algebraic-effects-in-javascript-part-4---implementing-algebraic-effects-and-handlers-2703) 来获得更高保真度的效果实现，但这意味着您必须放弃 JavaScript 函数的「透明」特性，并且您必须把各处都设置成 generator。这有点……emm

### 了解更多

就个人而言，我对代数效应对我有多大意义感到惊讶。我一直在努力理解像 Monads 这样的抽象概念，但代数效果突然让我「开窍」了。我希望这篇文章能帮助你也能对 Monads 等概念「开窍」。

我不知道他们是否会进入主流采用阶段。如果它在 2025 年之前还没有被任何主流语言所采用，我想我会感到失望。请提醒我五年后再回来看看！

我相信你可以用它们做更多的事情 —— 但是如果不用这种方式实际编写代码就很难理解它们的力量。如果这篇文章让你好奇，这里有一些你可能想要查看的资源：

* [https://github.com/ocamllabs/ocaml-effects-tutorial](https://github.com/ocamllabs/ocaml-effects-tutorial)
* [https://www.janestreet.com/tech-talks/effective-programming/](https://www.janestreet.com/tech-talks/effective-programming/)
* [https://www.youtube.com/watch?v=hrBq8R_kxI0](https://www.youtube.com/watch?v=hrBq8R_kxI0)

许多人还指出，如果忽略「类型」这个角度的话（正如我在本文中所做的那样），你可以在 Common Lisp 的[条件系统](https://en.wikibooks.org/wiki/Common_Lisp/Advanced_topics/Condition_System)中找到更早的现有技术。您可能也会喜欢 James Long 的 [post on continuations](https://jlongster.com/Whats-in-a-Continuation) 这篇文章，其解释了 `call / cc` 原语为何也可以作为在用户空间中构建可恢复异常的基础。

如果您为 JavaScript 相关人士找到关于代数效应的其他有用资源，请在 Twitter 上告诉我！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
