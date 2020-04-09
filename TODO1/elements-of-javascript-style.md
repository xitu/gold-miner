> * 原文地址：[Elements of JavaScript Style](https://medium.com/javascript-scene/elements-of-javascript-style-caa8821cb99f)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/elements-of-javascript-style.md](https://github.com/xitu/gold-miner/blob/master/TODO1/elements-of-javascript-style.md)
> * 译者：[febrainqu](https://github.com/febrainqu)
> * 校对者：[Baddyo](https://github.com/Baddyo)、[niayyy-S](https://github.com/niayyy-S)

# JavaScript 风格元素

![Out of the Blue — Iñaki Bolumburu (CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/2400/1*7qYONdlJuS0pkUpdav-LQQ.jpeg)

> **注意：** 这篇文章现在是[“组合软件”系列丛书](https://leanpub.com/composingsoftware)中的一部分。

1920 年，[William Strunk Jr 的《英文写作指南》](https://www.amazon.com/Elements-Style-Fourth-William-Strunk/dp/020530902X/ref=as_li_ss_tl?ie=UTF8&qid=1493260884&sr=8-1&keywords=the+elements+of+style&linkCode=ll1&tag=eejs-20&linkId=f7eb0eacba0eab243899626551113119)出版了，它为经过了时间考验的英语语言风格制定了指导方针。你可以对你的代码使用类似的标准，以提升你的代码质量。

以下只是参考，不是不可改变的法则。如果其他的方式可以使代码更清晰，那么我们有合理的理由偏离这个方针，但是[要保持警惕和自我意识](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75)。这些指导方针能经受住时间考验的理由很充分：它们通常是正确的。只有在有充分理由的情况下才会偏离它们 —— 而不仅仅是一时兴起或个人的风格偏好。

几乎所有**基本组成原则**中的指南都适用于源代码：

* 以段落为单位：每个主题一段。
* 省略不必要的词。
* 使用主动语态。
* 避免连续使用松散的句子。
* 把相关的单词放在一起。
* 用肯定句陈述。
* 在平行概念上使用并列句。

我们可以把基本相同的概念用于代码风格：

1. 以函数为组成单位。每个函数实现一个功能。
2. 省略不必要的代码。
3. 使用主动语态。
4. 避免一连串的松散陈述。
5. 将相关的代码写在一起。
6. 把语句和表达式写成肯定的形式。
7. 对并列概念使用并列代码。

## 1. 以函数为组成单位。每个函数实现一个功能。

> 软件开发的本质是组合。我们通过将模块、函数和数据结构组合在一起来构建软件。

> 理解如何编写和组合函数是软件开发人员的一项基本技能。

模块只是一个或多个函数或数据结构的集合，数据结构是我们表示程序状态的方式，但是在应用函数之前，没有什么有趣的事情发生。

在 JavaScript 中，有以下三种函数：

* 通信函数：执行 I/O 的功能。
* 过程函数：一组指令的列表。
* 映射函数：传入一些参数，返回一些相应的结果。

虽然所有可用的程序都会用到 I/O 操作，而且许多程序都遵循一些过程序列，但是你的大多数函数应该是映射函数：传入一些参数，函数将返回一些相应的结果。

**每个函数处理一个功能**：如果你的函数用于 I/O 操作，不要将 I/O 与映射（计算）混合在一起。如果你的函数用于映射，不要将它和 I/O 操作混合在一起。根据定义，过程函数违反了这条准则。过程函数还违反了另一个准则：避免连续的松散声明。

理想函数是一个简单的、确定性的纯函数：

* 给定相同的调用参数，总是返回相同的结果
* 没有副作用

另见参考，[“什么是纯函数”](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)

## 2. 省略不必要的代码。

> “有力的写作是简洁的。一个句子不应该包含不必要的单词，一个段落不应该包含不必要的句子，就像一幅画不应该有不必要的线条，一台机器不应该有不必要的零件。这并不要求作者把所有的句子都写得很短，或者避免所有的细节，只处理主题的大纲，而是要求每一个词都能说明问题。” [省略不必要的话]
~ William Strunk, Jr.，《英文写作指南》

简洁的代码在软件中是至关重要的，因为越多的代码越容易隐藏 bug。**更少的代码 = 更少的地方隐藏 bug = 更少的 bug。**

简洁的代码更容易读懂，因为它有更高的信噪比：读者有必要从较少的干扰中读懂代码的含义。 **更少的代码 = 更少的干扰 = 更强的含义传达。**

借用《英文写作指南》中的一个词：简洁的代码更**有活力。**

```js
function secret (message) {
  return function () {
    return message;
  }
};
```

可以简化为：

```js
const secret = msg => () => msg;
```

这对于那些熟悉简洁的箭头函数（在 ES6 中引入的）的人来说更容易理解。它省略了不必要的语法：大括号、`function` 关键字和 `return` 语句。

第一种包括不必要的语法。对于那些熟悉简洁箭头语法的人来说，大括号、`function` 关键字和 `return` 语句毫无用处。它的存在只是为了让那些不熟悉 ES6 的人熟悉代码。

自 2015 年以来，ES6 一直是语言标准。是时候[熟悉它](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75)了。

#### 省略不必要的变量

有时我们倾向于给那些不需要命名的东西命名。问题是[人类的大脑在工作记忆方面的资源是有限的](http://www.nature.com/neuro/journal/v17/n3/fig_tab/nn.3655_F2.html)，而且每个变量都要存储为一个离散的量子，占用大脑中的一个可用的工作记忆插槽。

因此，有经验的开发人员学会了消除不必要的变量。

例如，在大多数情况下，应该省略仅为了命名返回值而命名的变量。函数的名称应该提供关于函数返回内容的足够信息。请思考下面的代码：

```js
const getFullName = ({firstName, lastName}) => {
  const fullName = firstName + ' ' + lastName;
  return fullName;
};
```

对比：

```js
const getFullName = ({firstName, lastName}) => (
  firstName + ' ' + lastName
);
```

开发人员减少变量的另一种常见方法是使用函数组合和无参风格。

**无参风格** 是一种定义函数而不引用参数的方法。实现无参风格的常见方法包括柯里化和函数组合。

让我们来看一个使用柯里化的例子：

```js
const add2 = a => b => a + b;

// 现在我们定义一个无参的函数 inc()
// 任何数加 1。
const inc = add2(1);

inc(3); // 4
```

看一下 `inc()` 函数的定义。注意，它没用使用 `function` 关键字，也没有使用 `=>` 语法。没有地方列出参数，因为函数内部没有使用参数。相反，它返回了一个知道如何处理参数的函数。

让我们来看另一个使用函数组合的例子。**函数组合** 是将一个函数用做另一个函数的结果的过程。不管你有没有意识到，你一直都在使用函数组合。例如，每当你使用像 `.map()` 和 `promise.then()` 这样的链式调用的时候都会用到它。它的最基本形式是这样的：`f(g(x))`。在代数中，这种结构通常写为 `f ∘ g` （读为 “f **after** g” 或 “f **composed with** g”）。

当你将两个函数组合在一起时，就不需要创建一个变量来保存两个函数之间的中间值。我们看一下函数组合如何简化代码：

```js
const g = n => n + 1;
const f = n => n * 2;

// 使用中间变量：
const incThenDoublePoints = n => {
  const incremented = g(n);
  return f(incremented);
};

incThenDoublePoints(20); // 42

// compose2 - 取两个函数并返回它们的组合
const compose2 = (f, g) => x => f(g(x));

// Point-free:
const incThenDoublePointFree = compose2(f, g);

incThenDoublePointFree(20); // 42
```

你可以对任何函子做同样的事情。[**函子**](https://medium.com/javascript-scene/functors-categories-61e031bac53f) 是任何你可以映射的东西，例如，数组（`Array.map()`）和 promises （`promise.then()`）。让我们用 map 链写另一个版本的 `compose2`：

```js
const compose2 = (f, g) => x => [x].map(g).map(f).pop();

const incThenDoublePointFree = compose2(f, g);

incThenDoublePointFree(20); // 42
```

每当你使用 promise 链时，你都是在做相同的事情。

实际上，每个函数式编程库都至少有两个组合实用程序版本：从右向左应用函数的 `compose()`，从左向右应用函数的 `pipe()`。

Lodash 把它们命名为 `compose()` 和 `flow()`。当我在 Lodash 中使用它们时，我通常这样引入它们：

```js
import pipe from 'lodash/fp/flow';
pipe(g, f)(20); // 42
```

然而，这不是更多的代码，下面的代码也能够实现：

```js
const pipe = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x);
pipe(g, f)(20); // 42
```

如果这个函数组合的东西听起来很陌生，你不知道该如何使用它，仔细想想：

> 软件开发的本质是组合。我们通过将模块、函数和数据结构组合在一起来构建软件。

由此你可以得出结论，理解函数和对象组合的工具就像房屋建筑商了解钻头和钉子枪一样基础。

当你使用命令式代码将函数与中间变量组合在一起时，那就像用胶带和强力胶把它们拼起来。

记住：

* 如果你能用更少的代码做相同的事情，而不改变或混淆意思，那么你应该这么做。
* 如果你能用更少的变量做相同的事情，而不改变或混淆意思，那么你应该这么做。

## 3. 使用主动语态

> “主动语态通常比被动语态更直接有力。” ~ William Strunk, Jr.，《英文写作指南》

尽可能直接地命名事物。

* `myFunction.wasCalled()` 优于 `myFunction.hasBeenCalled()`
* `createUser()` 优于 `User.create()`
* `notify()` 优于 `Notifier.doNotification()`

将谓语和布尔值命名为用“是”或“否”就能回答的问题：

* `isActive(user)` 优于 `getActiveStatus(user)`
* `isFirstRun = false;` 优于 `firstRun = false;`

使用动词形式命名函数：

* `increment()` 优于 `plusOne()`
* `unzip()` 优于 `filesFromZip()`
* `filter(fn, array)` 优于 `matchingItemsFromArray(fn, array)`

**事件处理程序**

事件处理程序和生命周期方法是动词规则的一个例外，因为它们被用作定语；它们表达的不是要做什么，而是什么时候做。它们的名称应该是这样的：“<何时执行>, \<动词>”。

* `element.onClick(handleClick)` 优于 `element.click(handleClick)`
* component.onDragStart(handleDragStart) 优于 component.startDrag(handleDragStart)

在第二种形式中，看起来我们试图触发事件，而不是响应事件。

#### 生命周期方法

考虑以下组件假设生命周期方法的替代方法，该方法存在于组件更新之前调用处理程序函数：

* componentWillBeUpdated(doSomething)
* componentWillUpdate(doSomething)
* `beforeUpdate(doSomething)`

在第一个例子中，我们使用被动语态(将被更新而不是将更新)。它很拗口，而且与其他方式一样不明了。

第二个例子要好得多，但是这个生命周期方法的关键是调用一个处理程序。`componentWillUpdate(handler)` 读起来好像它会更新处理器，但这不是我们的意思。我们的意思是，“在组件更新之前，调用处理程序”。`beforeComponentUpdate()` 更清楚地表达了这种意思。

我们可以进一步简化。因为这些都是方法，所以 subject（组件）是内置的。在方法名中注明它是多余的。考虑一下，如果你把这些方法直接命名为：component.componentWillUpdate()，它应该怎么读。这就好像说，“吉米吉米晚上吃牛排。” 你不需要重复两次听到 subject 的名字。

* component.beforeUpdate(doSomething) 优于 component.beforeComponentUpdate(doSomething)

**函数式 mixins** 是一种向对象添加属性和方法的函数。函数在管道中一个接一个地应用 —— 就像装配线一样。每个函数式 mixin 都将 `instance` 作为输入，并在将其传递给管道中的下一个函数之前附加一些内容。

我倾向用形容词来命名函数式 mixins。你经常能使用 “ing” 或 “able” 后缀找到可用的形容词，例如：

* const duck = composeMixins(flying, quacking);
* const box = composeMixins(iterable, mappable);

## 4. 避免一系列松散的陈述

> “…一个系列很快就变得单调乏味。”
~ William Strunk, Jr.，《英文写作指南》

开发人员经常将一个过程中的事件序列串在一起：把一组松散相关的语句，设计成一个接一个地运行。过多的过程就会产生面条式代码。

这类序列经常被许多平行形式重复，每一种形式都微妙地、有时出乎意料地发散。例如，用户界面组件与几乎所有其他用户界面组件共享相同的核心需求。它的关注点可以分为生命周期阶段，并由单独的功能进行管理。

思考以下顺序代码：

```js
const drawUserProfile = ({ userId }) => {
  const userData = loadUserData(userId);
  const dataToDisplay = calculateDisplayData(userData);
  renderProfileData(dataToDisplay);
};
```

这个函数实际上处理三种不同的事情：加载数据、从加载的数据计算视图状态、呈现视图。

在大多数现代前端应用程序体系结构中，这些关注点中的每一个都是单独考虑的。通过分离这些关注点，我们可以轻松地混合和匹配每个关注点的不同功能。

例如，我们可以完全替换渲染器，它不会影响程序的其他部分。React 有丰富的自定义渲染器：ReactNative 用于原生 iOS 和 Android 应用程序，AFrame 用于 WebVR，ReactDOM/Server 用于服务器端渲染，等等。

此函数的另一个问题是，加载数据前，不能简单地计算要显示的数据并生成标记。如果你已经加载了数据呢？你最终要做一些在后续调用中不必要的工作。

分离关注点也使得它们可以独立测试。我喜欢在编写代码时对应用程序进行单元测试，并在每次更改时显示测试结果。但是，如果我们将**呈现代码**绑定到**数据加载代码**，我就不能简单地将一些假数据传递到呈现代码以进行测试。我必须对整个组件进行端到端测试 —— 由于浏览器加载、异步网络 I/O 等原因，这个过程可能会很耗时。

我不能从我的单元测试中得到即时反馈。分离这些函数可以让你独立地进行单元测试。

这个例子中有一些独立的函数，我们可以将这些函数提供给程序中的不同生命周期钩子。当程序装入组件时，会触发加载。计算和渲染可以在响应视图状态更新时发生。

这种结果是产生分工更加明确的代码：每个组件可以重用相同的结构和生命周期挂钩，并且代码性能更好；我们不会重复那些不需要在后续循环中重复的工作。

## 5. 保持相关代码在一起。

许多框架和样板都规定了一种程序组织方法，文件按类型分组。如果你要构建小型计算器或“待办事项”应用程序，这很好，但是对于大型项目，通常把文件按功能分组。

例如，这里有两个可供选择的文件层次结构，分别按类型和功能分类：

**按类型分类**

```
.
├── components
│   ├── todos
│   └── user
├── reducers
│   ├── todos
│   └── user
└── tests
    ├── todos
    └── user
```

**按功能分类**

```
.
├── todos
│   ├── component
│   ├── reducer
│   └── test
└── user
    ├── component
    ├── reducer
    └── test
```

当你将文件按功能分组时，你可以避免在文件列表中上下滚动以查找需要编辑的所有文件，从而使单个功能正常工作。

> 根据特性对文件进行排序。

## 6. 把语句和表达式写成肯定的形式。

> “做出明确的断言。避免使用平淡、无趣、犹豫、不置可否的语言。不要用**不是** 这个词作为否定或对立的手段，永远不要用它作为逃避的手段。”
~ William Strunk, Jr.，《英文写作指南》

* `isFlying` 优于 `isNotFlying`
* `late` 优于 `notOnTime`

#### If 语句

```js
if (err) return reject(err);

// 其它代码...
```

…优于：

```js
if (!err) {
  // ... 其它代码
} else {
  return reject(err);
}
```

#### 三元运算符

```js
{
  [Symbol.iterator]: iterator ? iterator : defaultIterator
}
```

…优于：

```js
{
  [Symbol.iterator]: (!iterator) ? defaultIterator : iterator
}
```

#### 最好使用强否定的变量声明

有时我们只关心一个变量是否存在，因此使用正向名称会迫使我们使用 `!` 运算符对其求反。在这种情况下，请选择强否定形式。单词 “not” 和 `!` 运算符会创建弱表达式。

* `if (missingValue)` 优于 `if (!hasValue)`
* `if (anonymous)` 优于 `if (!user)`
* `if (isEmpty(thing))` 优于 `if (notDefined(thing))`

#### 在函数调用中避免 null 和未定义的参数

调用函数时不需要使用 `undefined` 或 `null` 替代可选参数。最好使用命名选项对象：

```js
const createEvent = ({
  title = 'Untitled',
  timeStamp = Date.now(),
  description = ''
}) => ({ title, description, timeStamp });

// 后续代码...
const birthdayParty = createEvent({
  title: 'Birthday Party',
  description: 'Best party ever!'
});
```

…优于：

```js
const createEvent = (
  title = 'Untitled',
  timeStamp = Date.now(),
  description = ''
) => ({ title, description, timeStamp });

// 后续代码...
const birthdayParty = createEvent(
  'Birthday Party',
  undefined, // 这是可以避免的
  'Best party ever!'  
);
```

## 对并列概念使用并列代码

> “……并行结构要求相似内容和功能的表达式在表面上相似。形式的相似性使读者更容易识别内容和功能的相似性。”
~ William Strunk, Jr.，《英文写作指南》

程序中很少有问题是在之前的程序中从未出现过的。我们最终会一遍又一遍做同样的事情。发生这种情况时，这就是抽象化的机会。确定相同的部分，并构建一个抽象，你只需完成不同的部分。这正是库和框架为我们所做的。

UI 组件就是一个很好的例子。不到 10 年前，将使用 jQuery 的 UI 更新与应用程序逻辑和网络 I/O 结合在一起是很常见的。然后人们开始意识到我们可以将 MVC 应用于客户端的 web 应用程序，然后人们开始将模型与 UI 更新逻辑分开。

最终，Web 应用程序采用了组件模型方法，这使我们可以使用 JSX 或 HTML 模板等方式对组件进行声明式建模。

我们最终得到的是一种表示 UI 更新逻辑的方法，对于每个组件都是相同的方式，而不是每个组件都使用不同的命令式代码。

对于熟悉组件的人来说，很容易明白每个组件的工作原理：有一些声明性标记表示 UI 元素、用于连接行为的事件处理程序，以及用于附加回调的生命周期钩子，这些回调将在需要时运行。

当我们针对相似的问题重复使用相似的模式时，熟悉该模式的任何人都应该能够快速学习代码的功能。

## 结论：代码应该简洁而不是过分简单

> 简明扼要的写作。句子不应该包含不必要的单词，段落不应该包含不必要的句子，其原因与图纸不应该包含不必要的线条而机器不应该包含不必要的部分相同。**这不要求作者使所有句子简短，也不必避免所有细节而只在轮廓上对待主题，而要使每个单词都说清楚。** [重点补充。]
~ William Strunk, Jr.，《英文写作指南》

ES6 于 2015 年实现了标准化，但是在 2017 年，ES6 于 2015 年实现了标准化，许多开发人员以编写代码为幌子，拒绝简洁的箭头功能、隐式返回、rest 参数和扩展运算符等功能，因为这样[更为人所熟悉](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75)。那是个大错误。熟悉感会随着实践而增加，ES6中的简洁功能显然优于 ES5 替代品：与语法繁重的替代品相比**简洁的代码更纯粹** 。

代码应该简洁而不是过分简单。

简洁的代码带来了：

* 更少的 bug
* 更简单的 debug

而且这些 bug：

* 修复成本高
* 带来其它 bug
* 中断正常的开发流程

简洁的代码也会带来：

* 更简单的书写
* 更简单的阅读
* 更简单的维护

为了让开发人员能够快速使用诸如简明语法、柯里化和组合等技术，培训投资是值得的。当我们为了熟悉而没有这样做的时候，我们需要与代码的读者进行沟通，他们才能理解代码，就像一个成年人对一个蹒跚学步的孩子讲话一样。

假设读者对实现一无所知，但是不要假设读者是愚蠢的，或者读者不懂这门语言。

要清楚，但不要简化。把事情简化既浪费又侮辱人。在实践和熟悉度上进行投资，以获得更好的编程词汇和更生动的风格。

> 代码应该简洁而不是过分简单。

---

****Eric Elliott** 是 [“Programming JavaScript Applications”](http://pjabook.com)（O’Reilly）的作者，以及 [DevAnywhere.io] (https://devanywhere.io/)的创始人之一。他为**Adobe 系统**，**Zumba 健身**，**华尔街日报**，**ESPN**，**BBC**以及**Usher**，**Frank Ocean**，**Metallica**，等顶级的唱片艺术家**贡献了软件经验。

**他可以和世界上最漂亮的女人一起工作。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
