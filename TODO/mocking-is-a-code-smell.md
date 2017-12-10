> * 原文地址：[Mocking is a Code Smell](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mocking-is-a-code-smell.md](https://github.com/xitu/gold-miner/blob/master/TODO/mocking-is-a-code-smell.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[IridescentMia](https://github.com/IridescentMia) [athena0304](https://github.com/athena0304)

# 模拟是一种代码异味（软件编写）（第十二部分）

![Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

（译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。）

> 这是 “软件编写” 系列文章的第十一部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科
> [< 上一篇](https://juejin.im/post/59e55dbbf265da43333d7652) | [<< 返回第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)

关于 TDD （Test Driven Development：测试驱动开发）和单元测试，我最常听到的抱怨就是，开发者经常要和隔离单元所要求的 mock（模拟）作斗争。一些开发者并不知道单元测试真正意义所在。实际上，我发现开发者迷失在了他们单元测试文件中的 mock（模拟）、fake（伪造对象）、和 stub（桩）（译注：三者都是[ Test Double（测试替身）](https://www.wikiwand.com/en/Test_double)，可参看[单元测试中 Mock 与 Stub 的浅析](https://segmentfault.com/a/1190000004936516)，[Unit Test - Stub, Mock, Fake 簡介](http://blog.csdn.net/wauit/article/details/21470255)），这些测试替身**并没有执行任何现实中实现的代码**。

另一方面，开发者容易陷入 TDD 的教条中，千方百计地要完成 100% 的代码覆盖率，即便这样做会使他们的代码越来越复杂。

我经常告诉开发者模拟是一种代码异味（code smell），但大多数开发者的 TDD 技巧偏离到了追求 100% 单元测试覆盖率的阶段，他们无法想象去掉一个个的模拟该怎么办。为了将模拟置入到应用中，他们尝试对测试单元包裹依赖注入函数，更糟糕地，还会将服务打包进依赖注入容器。

Angular 做得很极端，它为所有的组件添加了依赖注入，试图让人们将依赖注入看作是解耦的主要方式。但事实并非如此，依赖注入并不是完成解耦的最佳手段。

### TDD 应该有更好的设计

> 学习高效的 TDD 的过程也是学习如何构建更加模块化应用的过程。

TDD 不是要复杂化代码，而是要简化代码。如果你发现当你为了让代码更可测试而牺牲掉代码的可读性和可维护性时，或者你的代码因为引入了依赖注入的样板代码而变臃肿时，你正在错误地实践 TDD。

不要以为在项目中引入依赖注入就能模拟整个世界。它们未必能帮到你，相反还会坑了你。编写更多的可测试代码本应当能够简化你的代码。它不仅要求更少的代码行数，还要求代码更加可读、灵活以及可维护，依赖注入却与此相反。

本文将教会你两件事：

1. 你不需要依赖注入来解耦代码
2. 最大化代码覆盖率将引起收益递减（diminishing returns） —— 你越接近 100% 的覆盖率，你就越可能让你的应用变复杂，这与测试的目的（减少程序中的 bug）就背道而驰了。

更复杂的代码通常伴有更加臃肿的代码。你对整洁代码的渴望就像你对房屋整洁的渴望那样：

* 代码越臃肿，意味着 bug 有更多空间藏身，也就意味着程序将存在更多 bug。
* 代码如果整洁精致，你也不会迷失在当中了。

### 什么是代码异味（code smell）？

> “代码异味指的是系统深层次问题反映出来的表面迹象” ~ Martin Fowler

代码异味并不意味着某个东西完全错了，或者是某个东西必须立即得到修正。它只是一个经验法则，来提醒你要做出一些优化了。

本文以及本文的标题没有暗示所有的模拟都是不好的，也没有暗示你别再使用模拟了。

另外，不同类型的代码需要不同程度（或者说不同类型）的模拟。如果代码是为了方便 I/O 操作的，那么测试就应当着眼于模拟 I/O，否则你的单元测试覆盖率将趋近于 0。

如果你的代码不存在任何逻辑（只含有纯函数组成的管道或者组合），0% 的单元测试覆盖率也是可以接受的，因为此时你的集成测试或者功能测试的覆盖率接近 100%。然而，如果代码中存在逻辑（条件表达式，变量赋值，显式函数调用等），你可能需要单元测试覆盖率，此时你有机会去简化你的代码以及减少模拟需求。

### 模拟是什么？

模拟（mock）是一个测试替身（test double），在单元测试过程中，它负责真正的代码实现。在整个测试的运行期内，一个模拟能够产生有关它如何被测试对象所操纵的断言。如果你的测试替身产生了断言，在特定的意义上，它就是一个模拟。

“模拟”一词更常用来指代任何测试替身的使用。考虑到本文的创作初衷，我们将交替使用“模拟”和“测试替身”两个词以符合潮流。所有的测试替身（dummy、spy、fake 等等）都代表了与测试对象紧耦合的真实代码，因此，所有的测试替身都是耦合的标识，优化测试，也间接帮助优化了代码质量。与此同时，减少对于模拟的需求能够大幅简化测试本身，因为你不再需要花费时间去构建模拟。

### 什么是单元测试？

单元测试是测试单个工作单元（模块，函数，类），测试期间，将隔离单元与程序剩余部分。

集成测试是测试两个或多个单元间集成度的，功能测试则是从用户视角来测试应用的，包含了完整的用户交互工作流，从模拟 UI 操作，到数据层更新，再到对用户输出（例如应用在屏幕上的展示）。功能测试是集成测试的一个子集，因为他们测试了应用的所有单元，这些单元集成在了当前运行应用的一个上下文中。

一般而言，只会使用单元的公共接口（也叫做 “公共 API” 或者 “表面积”）来测试单元。这被称为黑盒测试。黑盒测试对于测试的健壮度更有利，因为对于某个测试单元，其公共 API 的变化频度通常小于实现细节的变化频度，即公共 API 一般是稳定的。如果你写白盒测试，这种测试就能知道功能实现细节，因此任何实现细节的改变都将破坏测试，即便公共 API 的功能仍然不变。换言之，白盒测试会引起一些耗时的重复工作。

### 什么是测试覆盖率？


测试覆盖率与被测试用例所覆盖的代码数量有关。覆盖率报告可以通过插桩（[instrumenting](https://www.wikiwand.com/en/Instrumentation_(computer_programming))）代码以及在测试期间记录哪行代码被执行了来创建。一般来说，我们追求高测试覆盖率，但是当覆盖率趋近于 100% 时，将造成收益递减。

个人而言，将测试覆盖率提高到 90% 以上似乎也并不能再降低更多的 bug。

为什么会这样呢？100% 的覆盖率不是意味着我们 100% 确定代码已经按照预期实现了吗？

事实证明，没那么简单。

大多数开发者并不知道其实存在着两种覆盖率：

1. **代码覆盖率：**测试单元覆盖了多少代码逻辑
2. **用例覆盖率：**测试集覆盖了多少用例

用例覆盖率与用例场景有关：代码在真实环境的上下文将如何工作，该环境包含有真实用户，真实网络状况甚至还有黑客的非法攻击。

覆盖率标识了代码覆盖上的弱点或威胁，而不是用例覆盖上的弱点和威胁。相同的代码可能服务于不同的用例，单一用例可能依赖了当前测试对象以外的代码，甚至依赖了另一个应用或者第三方 API。

由于用例可能涉及环境、多个单元、用户以及网络状况，所以不太可能在只包含了一个测试单元的测试集下覆盖所有所要求的用例。从定义上来说，单元测试对各个单元进行独立地测试，而非集成测试，这也意味着，对于只包含了一个测试单元的测试集来说，集成或者功能用例场景下的用例覆盖率趋近于 0%。

100% 的代码覆盖率不能保证 100% 的用例覆盖率。

开发者对于 100% 代码覆盖率的追求看来是走错路了。

### 什么是紧耦合？

使用模拟来完成单元测试中单元隔离的需求是由各个单元间的耦合引起的。紧耦合会让代码变得呆板而脆弱：当需要改变时，代码更容易被破坏。一般来说，耦合越少，代码更易扩展和维护。锦上添花的是，耦合的减少也会减少测试对于模拟的依赖，从而让测试变得更加容易。

从中不难推测，如果我们正模拟某个事物，就存在着通过减少单元间的耦合来提升代码灵活性的空间。一旦解耦完成，你将再也不需要模拟了。

耦合反映了某个单元的代码（模块、函数、类等等）对于其他单元代码的依赖程度。紧耦合，或者说一个高度的耦合，反映了一个单元在其依赖被修改时有多大可能会损坏。换言之，耦合越紧，应用越难维护和扩展。松耦合则可以降低修复 bug 和为应用引入新的用例时的复杂度。

耦合会有不同形式的反映：

* **子类耦合**：子类依赖于整个继承层级上父类的实现，这是面向对象中耦合最紧的形式。
* **控制依赖**：代码通过告知 “做什么（what to do）” 来控制其依赖，例如，给依赖传递一个方法名给告诉依赖该做什么等。如果控制依赖的 API 改变了，该代码就将损坏。
* **可变状态依赖**：代码之间共享了可变状态，例如，共享对象上的属性可以被改变。可变对象变化时序的改变将破坏依赖该对象的代码。如果时序是不定的，除非你对所有依赖单元来个彻底检修，否则就无法保证程序的正确性：一个例子就是当前存在一个无法修缮的竞态紊乱。修复了某个 bug 可能又造成其他单元出现 bug。
* **状态形态依赖**：代码之间共享了数据结构，并且只用了结构的一个子集。如果共享的结构发生了变化，那么依赖于这个结构的代码也会损坏。
* **事件/消息 耦合**：各个单元间的代码通过消息传递、事件等进行通信。

### 什么造成了紧耦合？

紧耦合有许多成因：

* **可变性** 与 **不可变性**
* **副作用** 与 **纯度/隔离副作用**
* **职责过重** 与 **单一职责（只做一件事：DOT —— Do One Thing）**
* **过程式指令** 与 **描述性结构**
* **命令式组合** 与 **声明式组合**

相较于函数式代码，命令式以及面向对象代码更易遭受紧耦合问题。这并非是说函数式编程风格能让你的代码免于紧耦合困扰，只是函数式代码使用了纯函数作为组合的基本单元，并且纯函数天然不易遭受紧耦合问题。

纯函数：

* 给定相同输入，总是返回相同输出
* 不产生副作用

纯函数是如何减少耦合的？

* **不可变性：**纯函数不会改变现有的值，它总是返回新的值。
* **没有副作用：**纯函数唯一可观测的作用就是它的返回值，因此，也就不会和其他观测了外部变量的函数交互，例如屏幕、DOM、控制台、标准输出、网络以及磁盘。
* **单一职责：**纯函数只完成一件事：映射输入到对应的输出，避免了职责过重时污染对象以及基于类的代码。
* **结构，而非指令：**纯函数可以被安全地记忆（memoized），这意味着，如果系统有无限的内存，任何纯函数都能够被替代为一个查找表，该查找表的索引是函数输入，其在表中检索到的值即为函数输出。换言之，纯函数描述了数据间的结构关系，而不是计算机需要遵从的指令，所以在同一时间运行两套不同的有冲突的指令也不会造成问题。

### 组合能为模拟做什么？

一切皆可。软件开发的实质是一个将大的问题划分为若干小的、独立的问题（分解），再组合各个小问题的解决方式来构成应用去解决大问题（合成）的过程。

> 当我们的分解策略失败时，我们才需要模拟。

当测试单元把大问题分解为若干相互依赖的小问题时，我们需要引入模拟。换句话说，**如果我们假定的原子测试单元并不是真正原子的，那么就需要模拟**，此时，分解策略也没能将大的问题划分为小的、独立的问题。

当分解成功时，就能使用一个通用的组合工具来组合分解结果。例如下面这些：

* **函数组合**：例如有 `lodash/fp/compose`
* **组件组合**：例如 React 中使用函数组合来组合高阶组件
* **状态 store/model 组合**：例如 [Redux combineReducers](http://redux.js.org/docs/api/combineReducers.html)
* **过程组合**：例如 transducer
* **Promise 或者 monadic 组合**：例如 `asyncPipe()`，使用 `composeM()`、`composeK()` 的 Kleisli 组合。
* 等等

当你使用通用组合工具时，组合的每个元素都可以在不模拟其它的情况下进行独立的单元测试。

组合自身将是声明式的，所以它们包含了 **0 个可单元测试的逻辑** （可以假定组合工具是一个自己有单元测试的第三方库）。

在这些条件下，使用单元测试是没有意义的，你需要使用集成测试替代之。

我们用一个大家熟悉的例子来比较命令式和声明式的组合：

```js
// 函数组合
// import pipe from 'lodash/fp/flow';
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
// 待组合函数
const g = n => n + 1;
const f = n => n * 2;
// 命令式组合
const doStuffBadly = x => {
  const afterG = g(x);
  const afterF = f(afterG);
  return afterF;
};
// 声明式组合
const doStuffBetter = pipe(g, f);
console.log(
  doStuffBadly(20), // 42
  doStuffBetter(20) // 42
);
```

函数组合是将一个函数的返回值应用到另一个函数的过程。换句话说，你创建了一个函数管道（pipeline），之后向管道传入了一个值，这个值将流过每个函数，这些函数就像是流水线上的某一步，在传入下一个函数之前，这个值都会以某种方式被改变。最终，管道中的最后一个函数将返回最终的值。

```js
initialValue -> [g] -> [f] -> result
```

在每个主流编程语言中，无论这门语言是什么范式，组合都是组织应用代码的主要手段。甚至连 Java 也是使用函数（方法）作为两个不同类实例间传递消息的机制。

你可以手动地组合函数（命令式的），也可以自动地组合函数（声明式的）。在非函数第一类（first-class functions）语言中，你别无选择，只能以命令式的方式来组合函数。但在 JavaScript 中（以及其他所有主流语言中），你可以使用声明式组合来更好地组织代码。

命令式编程风格意味着我们正在命令计算机一步步地做某件事。这是一种如何做（how-to）的引导。在上面的例子中，命令式风格就像在说：

1. 接受一个参数并将它分配给 `x`。
2. 创建一个叫做 `afterG` 的绑定，将 `g(x)` 的结果分配给它。
3. 创建一个叫做 `afterF` 的绑定，将 `f(afterG)` 的结果分配给它。
4. 返回 `afterF` 的结果。

命令式风格的组合要求组合中牵涉的逻辑也要被测试。虽然我知道这里只有一些简单的赋值操作，但是我常在我传递或者返回错误的变量时，看到过（并且自己也写过）bug。

声明式风格的组合意味着我们告诉计算机事物之间的关系。它是一个使用了等式推理（[equational reasoning](http://www.haskellforall.com/2013/12/equational-reasoning.html)）的结构描述。声明式的例子就像在说：

* `doStuffBetter` **是** 函数 `g` 和 `f` 的管道化组合。

仅此而已。

假定 `f` 和 `g` 都有它们自己的单元测试，并且 `pipe()` 也有其自己的单元测试（在 Lodash 中是 [`flow()`](https://lodash.com/docs/4.17.2#flow)，在 Ramda 中是 [`pipe()`](http://ramdajs.com/docs/#pipe)），所以就没有需要进行单元测试的新的逻辑。

为了让声明式组合正确工作，我们组合的单元需要被 **解耦**。

### 我们如何消除耦合？

为了去除耦合，我们首先需要对于耦合来源有更好的认识。下面罗列了一些耦合的主要来源，它们被按照耦合的松紧程度进行了排序：

紧耦合：

* 类继承（耦合随着每一层继承和每一个子孙类而倍增）
* 全局变量
* 其他可变的全局状态（浏览器 DOM、共享存储、网络等等）
* 引入了包含副作用的模块
* 来自组合的隐式依赖，例如在 `const enhancedWidgetFactory = compose(eventEmitter, widgetFactory, enhancements);` 中，`widgetFactory` 依赖了 `eventEmitter`
* 依赖注入容器
* 依赖注入参数
* 控制变量（一个外部单元控制了主题单元该做什么事）
* 可变参数

松耦合：

* 引入的模块不包含副作用（在黑盒测试中，不是所有引入的模块都需要进行隔离）
* 消息的传递/发布订阅
* 不可变参数（在状态形态中，仍然会造成共享依赖）

讽刺的是，多数耦合恰恰来自于最初为了减少耦合所做的设计中。但这是可以理解的，为了能够将小问题的解决方案重新组成完整的应用，单元彼此就需要以某种方式进行集成或者通信。方式有好的，也有不好的。只要有必要，就应当规避紧耦合产生的来源，一个健壮的应用更需要的是松耦合。

对于我将依赖注入容器和依赖注入参数划分到 “紧耦合” 分组中，你可能感到疑惑，因为在许多书上或者是博客上，它们都被分到了 “松耦合” 一组。耦合不是个是非问题，它描述了一种程度。所以，任何分组都带有主观和独断色彩。

对于耦合松紧界限的划分，我有一个立见分晓的检验方法：

测试单元是否能在不引入模拟依赖的前提下进行测试？如果不行，那么测试单元就 **紧耦合** 于模拟依赖。

你的测试单元依赖越多，越可能存在耦合问题。现在我们明白了耦合是怎么发生的，我们可以做什么呢？

1. **使用纯函数** 来作为组合的原子单元，而不是类、命令式过程或者包含可变对象的函数。
2. **隔离副作用** 与程序逻辑。这意味着不要将逻辑和 I/O（包括有网络 I/O、渲染的 UI、日志等等）混在一起。
3. **去除命令式组合中的依赖逻辑** ，这样组合能够变为自身不需要单元测试的、声明式的组合。如果组合中不含逻辑，就不需要被单元测试。

以上几点意味着那些你用来建立网络请求和操纵请求的代码都不需要单元测试，它们需要的是集成测试。

再唠叨一下：

> **不要对 I/O 进行单元测试。**

> **I/O 针对于集成测试。**

在集成测试中，模拟和伪造（fake）都是完全 OK 的。

### 使用纯函数

纯函数的使用需要多加练习，在缺乏练习的情况下，如何写一个符合预期的纯函数不会那么清晰明了。纯函数不能直接改变全局变量以及传给它的参数，如网络对象、磁盘对象或者是屏幕对象。纯函数唯一能做的就是返回一个值。

如果你向纯函数传入了一个数组或者一个对象，并且你要返回对象或者数组变化了的版本，你不要直接改变并返回它们。你应当创建一个满足对应变化的对象拷贝。对此，你可以考虑使用数组的[访问器方法](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype) (**而不是** 可变方法，例如 `Array.prototype.spilce`、`Array.prototype.sort` 等)，或在 `Object.assign()` 中新创建一个空对象作为目标对象，再或者使用数组或者对象的展开语法。例子如下：

```js
// 非纯函数
const signInUser = user => user.isSignedIn = true;
const foo = {
  name: 'Foo',
  isSignedIn: false
};
// Foo 被改变了
console.log(
  signInUser(foo), // true
  foo              // { name: "Foo", isSignedIn: true }
);
```

与：

```js
// 纯函数
const signInUser = user => ({...user, isSignedIn: true });
const foo = {
  name: 'Foo',
  isSignedIn: false
};
// Foo 没有被改变
console.log(
  signInUser(foo), // { name: "Foo", isSignedIn: true }
  foo              // { name: "Foo", isSignedIn: false }
);
```

又或者，你可以选择一个针对于不可变对象类型的第三方库，例如 [Mori](http://swannodette.github.io/mori/) 或者是 [Immutable.js](https://facebook.github.io/immutable-js/)。我希望有朝一日，在 JavaScript 中，有类似于 Clojure 中的不可变数据类型，但我可等不到那会儿了。

你可能觉得返回新的对象会造成一定的性能开销，因为我们创建了新对象，而不是直接重用现有对象，但是一个利好是我们可以使用严格比较（也叫相同比较：identity equality）运算符（`===` 检查）来检查对象是否发生了改变，这时，我们不再需要遍历整个对象来检测其是否发生了改变。

这个技巧可以让你的 React 组件有一个复杂的状态树时渲染更快，因为你可能不需要在每次渲染时进行状态对象的深度遍历。继承 `PureComponent` 组件，它通过状态（state）和属性（prop）的浅比较实现了 `shouldComponentUpdate()`。当它检测到对象相同时，它便知道对应的状态子树没有发生改变，因此也就不会再进行状态的深度遍历。

纯函数也能够记忆化（memoized），这意味着如果接收到了相同输入，你不需要再重复构建完整对象。利用内存和存储，你可以将预先计算好的结果存入一张查找表中，从而降低计算复杂度。对于开销较大、但不会无限需求内存的计算任务来说，这个是非常好的优化策略。

纯函数的另一个属性是，由于它们没有副作用，就能够在拥有大型集群的处理器上安全地使用一个分治策略来部署计算任务。该策略通常用在处理图像、视频或者声音帧，具体说来就是利用服务于图形学的 GPU 并行计算，但现在这个策略有了更广的使用，例如科学计算。

换句话说，可变性不总是很快，某些时候，其优化代价远远大于优化受益，因此还会让性能变慢。

### 隔离副作用与程序逻辑

有若干策略能帮助你将副作用从逻辑中隔离出来，下面罗列了当中的一些：

1. 使用发布/订阅（pub/sub）来将 I/O 从视图和程序逻辑中解耦出来。避免直接在 UI 视图或者程序逻辑中调用副作用，而应当发送一个事件或者描述了事件或意图的动作（action）对象。
2. 将逻辑从 I/O 中隔离出来，例如，使用 `asyncPipe()` 来组合那些返回 promise 的函数。
3. 使用对象来描述未来的计算而不是直接使用 I/O 来驱动计算，例如 [redux-saga](https://github.com/redux-saga/redux-saga) 中的 `call()` 不会立即调用一个函数。取而代之的是，它会返回一个包含了待调用函数引用及所需参数的对象，saga 中间件则会负责调用该函数。这样，`call()` 以及所有使用了它的函数都是**纯函数**，这些函数不需要模拟，从而也利于单元测试。

#### 使用 pub/sub 模型

pub/sub 是 publish/subscribe（发布/订阅） 模式的简写。在该模式中，测试单元不会直接调用彼此。取而代之的是，他们发布消息到监听消息的单元（订阅者）。发布者不知道是否有单元会订阅它的消息，订阅者也不知到是否有发布者会发布消息。

pub/sub 模式被内置到了文档对象模型（DOM）中了。你应用中的任何组件都能监听到来自 DOM 元素分发的事件，例如鼠标移动、点击、滚动条事件、按键事件等等。回到每个人都使用 jQuery 构建 web 应用的时代，经常见到使用 jQuery 来自定义事件使 DOM 转变为一个 pub/sub 的 event bus，从而将视图渲染这个关注点从状态逻辑中解耦出来。

pub/sub 也内置到了 Redux 中。在 Redux 中，你为应用状态（被称为 store）创建一个全局模型。视图和 I/O 操作没有直接修改模型（model），而是分派一个 action 对象到 store。一个 action 有一个称之为 `type` 的属性，不同的 reducer 按照该属性进行监听及响应。另外，Redux 支持中间件，它们也可以监听并且响应特殊的 action 类型。这种方式下，你的视图不需要知道你的应用状态是如何被操纵的，状态逻辑也不需要知道关于视图的任何事。

通过中间件，也能够轻易地打包新的特性到 dispatcher 中，从而驱动[横切关注点（cross-cutting concerns）](https://www.wikiwand.com/en/Cross-cutting_concern)，例如对 action 的日志/分析，使用 storage 或者 server 来同步状态，或者加入 server 和网络节点的实时通信特性。

#### 将逻辑从 I/O 中隔离

有时，你可以使用 monad 组合（例如组合 promise）来减少你组合当中的依赖。例如，下面的函数因为包含了逻辑，你就不得不模拟所有的异步函数才能进行单元测试：

```js
async function uploadFiles({user, folder, files}) {
  const dbUser = await readUser(user);
  const folderInfo = await getFolderInfo(folder);
  if (await haveWriteAccess({dbUser, folderInfo})) {
    return uploadToFolder({dbUser, folderInfo, files });
  } else {
    throw new Error("No write access to that folder");
  }
}
```

我们写一些帮助函数伪代码来让上例可工作：

```js
const log = (...args) => console.log(...args);
// 下面这些可以无视，在真正的代码中，你会使用真实数据
const readUser = () => Promise.resolve(true);
const getFolderInfo = () => Promise.resolve(true);
const haveWriteAccess = () => Promise.resolve(true);
const uploadToFolder = () => Promise.resolve('Success!');
// 随便初始化一些变量
const user = '123';
const folder = '456';
const files = ['a', 'b', 'c'];
async function uploadFiles({user, folder, files}) {
  const dbUser = await readUser({ user });
  const folderInfo = await getFolderInfo({ folder });
  if (await haveWriteAccess({dbUser, folderInfo})) {
    return uploadToFolder({dbUser, folderInfo, files });
  } else {
    throw new Error("No write access to that folder");
  }
}
uploadFiles({user, folder, files})
  .then(log)
;
```

我们使用 `asyncPipe()` 来完成 promise 组合，实现对上面业务的重构：

```js
const asyncPipe = (...fns) => x => (
  fns.reduce(async (y, f) => f(await y), x)
);
const uploadFiles = asyncPipe(
  readUser,
  getFolderInfo,
  haveWriteAccess,
  uploadToFolder
);
uploadFiles({user, folder, files})
  .then(log)
;
```

因为 promise 内置有条件分支，因此，例子中的条件逻辑可以被轻松移除了。由于逻辑和 I/O 无法很好地混合在一起，因此我们想要从依赖 I/O 的代码中去除逻辑。

为了让这样的组合工作，我们需要保证两件事：

1. `haveWriteAccess()` 在用户没有写权限时需要 reject。这能让分支逻辑转到 promise 上下文中，我们不需要单元测试，也无需担忧分支逻辑（promise 本身拥有 JavaScript 引擎支持的测试）。
2. 这些函数都接受并且 resolve 某个数据类型。我们可以创建一个 `pipelineData` 类型来完成组合，该类型只是一个包含了如下 key 的对象：`{ user, folder, files, dbUser?, folderInfo? }`。它创建一个在各个组件间共享的结构依赖，在其它地方，你可以使用这些函数更加泛化的版本，并且使用一个轻量的包裹函数标准化这些函数。

当这些条件满足了，就能很轻松地、相互隔离地、脱离模拟地测试每一个函数。因为我们已经将组合管道中的所有逻辑抽出了，单元测试也就不再需要了，此时应当登场的是集成测试。

> 牢记：**逻辑和 I/O** 是相互隔离的关注点。
> 逻辑是思考，副作用（I/O）是行为。三思而后行！

#### 使用对象来描述未来计算

redux-saga 所使用的策略是使用对象来描述未来计算。该想法类似于返回一个 monad，不过它不总是必须返回一个 monad。monad 能够通过链式操作来组合函数，但是你可以手动的使用命令式风格代码来组合函数。下面的代码大致展示了 redux-saga 是如何做到用对象描述未来计算的：

```js
// console.log 的语法糖，一会儿我们会用它
const log = msg => console.log(msg);
const call = (fn, ...args) => ({ fn, args });
const put = (msg) => ({ msg });
// 从 I/O API 引入的
const sendMessage = msg => Promise.resolve('some response');
// 从状态操作句柄或者 reducer 引入的
const handleResponse = response => ({
  type: 'RECEIVED_RESPONSE',
  payload: response
});
const handleError = err => ({
  type: 'IO_ERROR',
  payload: err
});

function* sendMessageSaga (msg) {
  try {
    const response = yield call(sendMessage, msg);
    yield put(handleResponse(response));
  } catch (err) {
    yield put(handleError(err));
  }
}
```

如你所见，所有的单元测试中的函数调用都没有模拟网络 API 或者调用任何副作用。这样做的好处还有：你的应用将很容易 debug，而不用担心不确定的网络状态等等......

当一个网络错误出现时，想要去模拟看看应用里将发生什么？只需要调用 `iter.throw(NetworkError)`

另外，一些库的中间件将驱动函数执行，从而在应用的生产环境触发副作用：

```js
const iter = sendMessageSaga('Hello, world!');
// 返回一个反映了状态和值的对象
const step1 = iter.next();
log(step1);
/* =>
{
  done: false,
  value: {
    fn: sendMessage
    args: ["Hello, world!"]
  }
}
*/
```

从 `call()` 中解构出 value，来审查或者调用未来计算：

```js
const { value: {fn, args }} = step1;
```

副作用只会在中间件中运行。当你测试和 debug 时你可以跳过这一部分。

```js
const step2 = fn(args);
step2.then(log); // 将打印一些响应
```

如果你不想在使用模拟 API 或者执行 http 调用的前提下模拟一个网络的响应，你可以直接传递模拟的响应到 `.next()` 中：

```js
iter.next(simulatedNetworkResponse);
```

接下来，你可以继续调用 `.next()` 直到返回对象的 `done` 变为 `true`，此时你的函数也会结束运行。

在你的单元测试中使用生成器（generator）和计算描述，你可以模拟任何事物**而不需要**调用副作用。你可以传递值给 `.next()` 调用以伪造响应，也可以使用迭代器对象来抛出错误从而模拟错误或者 promise rejection。

即便牵涉到的是一个复杂的、混有大量副作用的集成工作流，使用对象来描述计算，都让单元测试不再需要任何模拟了。

### “代码异味” 是警告，而非定律。模拟并非恶魔。

使用更优架构的努力是好的，但在现实环境中，我们不得不使用他人的 API，并且与遗留代码打交道，大部分这些 API 都是不纯的。在这些场景中，隔离测试替身是很有用的。例如，express 通过连续传递来传递共享的可变状态和模型副作用。

我们看到一个常见例子。人们告诉我 express 的 server 定义文件需要依赖注入，不然你怎么对所有在 express 应用完成的工作进行单元测试？例如：

```js
const express = require('express');
const app = express();
app.get('/', function (req, res) {
  res.send('Hello World!')
});
app.listen(3000, function () {
  console.log('Example app listening on port 3000!')
});
```

为了 “单元测试” **这个文件**，我们不得不逐步建立一个依赖注入的解决策略，并在之后传递所有事物的模拟到里面（可能包括 `express()` 自身）。如果这是一个非常复杂的文件，包含了使用了不同 express 特性的请求句柄，并且依赖了逻辑，你可能已经想到一个非常复杂的伪造来让测试工作。我已经见过开发者构建了精心制作的伪造（fake）和模拟（mock），例如 express 中的 session 中间件、log 操纵句柄、实时网络协议，应有尽有。我从自己面对模拟时的艰苦卓绝中得出了一个简单的道理：

> 这个文件不需要单元测试。

express 应用的 server 定义主要着眼于应用的 **集成**。测试一个 express 的应用文件从定义上来说也就是测试程序逻辑、express 以及各个操作句柄之间的集成度。即便你已经完成了 100% 的单元测试，也不要跳过集成测试。

你应当隔离你的程序逻辑到分离的单元，并分别对它们进行单元测试，而不应该直接单元测试这个文件。为 server 文件撰写真正的集成测试，意味着你确实接触到了真实环境的网络，或者说至少借助于 [supertest](https://github.com/visionmedia/supertest) 这样的工具创建了一个真实的 http 消息，它包含了完成的头部信息。

接下来，我们重构 Hello World 的 express 例子，让它变得更可测试：

将 `hello` 句柄放入它自己的文件，并单独对其进行单元测试。此时，不再需要对应用的其他部分进行模拟。显然，`hello` 不是一个纯函数，因此我们需要模拟响应对象来保证我们能够调用  `.send()`。

```js
const hello  = (req, res) => res.send('Hello World!');
```

你可以像下面这样来测试它，也可以用你喜欢的测试框架中的期望（expectation）语句来替换 `if`：

```js
{
  const expected = 'Hello World!';
  const msg = `should call .send() with ${ expected }`;
  const res = {
    send: (actual) => {
      if (actual !== expected) {
        throw new Error(`NOT OK ${ msg }`);
      }
      console.log(`OK: ${ msg }`);
    }
  }
  hello({}, res);
}
```

将监听句柄也放入它自己的文件，并单独对其进行单元测试。我们也将面临相同的问题，express 的句柄不是纯函数，所以我们需要模拟 logger 来保证其能够被调用。测试与前面的例子类似。

```js
const handleListen = (log, port) => () => log(`Example app listening on port ${ port }!`);
```

现在，留在 server 文件中的只剩下集成逻辑了：

```js
const express = require('express');
const hello = require('./hello.js');
const handleListen = require('./handleListen');
const log = require('./log');
const port = 3000;
const app = express();
app.get('/', hello);
app.listen(port, handleListen(port, log));
```

你仍然需要对该文件进行集成测试，单多余的单元测试不再能够提升你的用例覆盖率。我们用了一些非常轻量的依赖注入来把 logger 传入 `handleListen()`，当然，express 应用可以不需要任何的依赖注入框架。

### 模拟很适合集成测试

由于集成测试是测试单元间的协作集成的，因此，在集成测试中伪造 server、网络协议、网络消息等等来重现所有你会在单元通信时、CPU 的跨集群部署及同一网络下的跨机器部署时遇到的环境。

有时，你也想测试你的单元如何与第三方 API 进行通信，这些 API 想要进行真实环境的测试将是代价高昂的。你可以记录真实服务下的事务流，并通过伪造一个 server 来重现这些事务，从而测试你的单元和第三方服务运行在分离的网络进程时的集成度。通常，这是测试类似 “是否我们看到了正确的消息头？” 这样诉求的最佳方式。

目前，有许多集成测试工具能够节流（throttle）网络带宽、引入网络延迟、创建网络错误，如果没有这些工具，是无法用单元测试来测试大量不同的网络环境的，因为单元测试很难模拟通信层。

如果没有集成测试，就无法达到 100% 的用例覆盖率。即便你达到了 100% 的单元测试覆盖率，也不要跳过集成测试。有时 100% 并不真的是 100%。

### 接下来

* 在 Cross Cutting Concerns 播客上学习为什么我认为[每一个开发团队都需要使用 TDD]((https://crosscuttingconcerns.com/Podcast-061-Eric-Elliott-on-TDD)。
* JavaScript 啦啦队正在记录[我们在 Instagram 上的探险](https://www.instagram.com/js_cheerleader/)。

## 需要 JavaScript 进阶训练吗？

DevAnyWhere 能帮助你最快进阶你的 JavaScript 能力，如组合式软件编写，函数式编程一节 React：

- 直播课程
- 灵活的课时
- 一对一辅导
- 构建真正的应用产品

[![https://devanywhere.io/](https://cdn-images-1.medium.com/max/800/1*pskrI-ZjRX_Y0I0zZqVTcQ.png)](https://devanywhere.io/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
