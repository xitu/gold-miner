> * 原文地址：[Mocking is a Code Smell](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mocking-is-a-code-smell.md](https://github.com/xitu/gold-miner/blob/master/TODO/mocking-is-a-code-smell.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：

# 模拟是一种代码异味（Code Smell）

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> _Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!
> _[_< Previous_](https://medium.com/javascript-scene/javascript-monads-made-simple-7856be57bfe8) _|_ [_<< Start Over_](https://medium.cm/javascript-scene/composing-software-an-introduction-27b72500d6ea)

关于 TDD （Test Driven Development：测试驱动开发）和单元测试，我最常听到的抱怨就是，开发者经常要和隔离单元所要求的 mock（模拟）作斗争。部分开发者并不知道单元测试是一件非常有意义的事。实际上，我发现开发者迷失在了他们单元测试文件中的 mock（模拟）、fake（伪造对象）、和 stub（桩）（译注：三者都是[ Test Double（测试替身）](https://www.wikiwand.com/en/Test_double)，可参看[单元测试中Mock与Stub的浅析](https://segmentfault.com/a/1190000004936516)，[Unit Test - Stub, Mock, Fake 簡介](http://blog.csdn.net/wauit/article/details/21470255)），这些单元测试中**并没有任何实际中的实现代码被执行**。

另一方面，开发者容易卷入 TDD 的教条中，千方百计地要完成 100% 的代码覆盖率，即便这样做会使他们的代码越来越复杂。

我经常告诉开发者模拟是一种代码异味，但是大多数开发者的 TDD 陷入到了追求 100% 单元测试覆盖率的阶段，他们无法想象去掉一个个的模拟该怎么办。为了将模拟置入到应用中，他们尝试对测试单元包裹依赖注入函数，更糟糕地，还会将服务打包进依赖注入容器。

Angular 做得很极端，它为所有的组件添加了依赖注入，试图让人们将依赖注入看作是解耦的主要方式。但事实并非如此，依赖注入并不是完成解耦的最佳手段。

### TDD 应该有更好的设计

> 学习高效的 TDD 的过程也是学习如何构建更加模块化应用的过程。

TDD 不是要复杂化代码，而是要简化代码。如果你发现当你为了让代码更可测试缺牺牲掉代码的可读性和可维护性时，或者你的代码因为引入了依赖注入的样板代码而变臃肿时，你正在错误地实践 TDD。

不要浪费时间在引入依赖注入到项目中来模拟整个世界了。它们未必能帮到你，相反还会坑了你。更多可测试代码的撰写应当能够简化你的代码。可测试代码不仅要求更少的代码行数，还要求代码更加可读、灵活以及可维护，依赖注入却与此相反。

本文将教会你两件事：

1. 你不需要依赖注入来解耦代码
2. 最大化代码覆盖率将引起受益递减（diminishing returns） —— 你越接近 100% 的覆盖率，你就越可能让你的应用变复杂，这与测试的目的（减少程序中的 bug）就背道而驰了。

更复杂的代码通常伴有更加臃肿的代码。你对整洁代码的渴望就像你对房屋整洁的渴望那样：

* 代码越臃肿，意味着 bug 有更多空间藏身，亦即程序将存在更多 bug。
* 代码如果整洁精致，你也不会迷失在当中了。

### 什么是代码异味（code smell）？

> “代码异味指的是系统深层次问题反映出来的表面迹象” ~ Martin Fowler

代码异味并不意味着某个东西完全错了，或者是某个东西必须得到修正。它只是一个经验法则来提醒你需要优化某个事物了。

本文以及本文的标题没有暗示所有的模拟都是不好的，也没有暗示你别再使用模拟了。

另外，不同类型的代码需要不同程度（或者说不同类型）的模拟。如果代码是为了方便 I/O 操作的，那么测试就应当着眼于模拟 I/O，否则你的单元测试覆盖率将趋近于 0。

如果你的代码不存在任何逻辑（只有含有纯函数组成的管道或者组合），0% 的单元测试覆盖率也是可以接受的，此时你的集成测试或者功能测试的覆盖率接近 100%。然而，如果代码中存在逻辑（条件表达式，变量赋值，显式函数调用等），你可能需要单元测试覆盖率，此时你需要简化代码并减少模拟需求。

### 模拟是什么？

模拟是一个测试替身（test double），在单元测试过程中，它负责真正的代码实现。在整个测试的运行期内，一个模拟能够产生有关它如何被测试对象操纵的断言。如果你的测试替身产生了断言，在特定的意义上，它就是一个模拟。

“模拟” 一词更常用来反映任何测试替身的使用。考虑到本文的创作初衷，我们将交替使用 “模拟” 和 “测试替身” 以符合潮流。所有的测试替身（dummy、spy、fake 等等）都负责与测试对象紧耦合的真实代码，因此，所有的测试替身都是耦合的标识，因此，优化测试，也间接帮助优化了代码质量。与此同时，减少对于模拟的需求能够大幅简化测试本身，因为你不再需要构建模拟。

### 什么是单元测试？

Unit tests test individual units (modules, functions, classes) in isolation from the rest of the program.

Contrast unit tests with integration tests, which test integrations between two or more units, and functional tests, which test the application from the point of view of the user, including complete user interaction workflows from simulated UI manipulation, to data layer updates, and back to the user output (e.g., the on-screen representation of the app). Functional tests are a subset of integration tests, because they test all of the units of an application, integrated in the context of the running application.

In general, units are tested using only the public interface of the unit (aka “public API” or “surface area”). This is referred to as black box testing. Black box testing leads to less brittle tests, because the implementation details of a unit tend to change more over time than the public API of the unit. If you use white box testing, where tests are aware of implementation details, any change to the implementation details could break the test, even if the public API continues to function as expected. In other words, white-box testing leads to wasted rework.

### 什么是测试覆盖率？

Code coverage refers to the amount of code covered by test cases. Coverage reports can be created by instrumenting the code and recording which lines were exercised during a test run. In general, we try to produce a high level of coverage, but code coverage starts to deliver diminishing returns as it gets closer to 100%.

In my experience, increasing coverage beyond ~90% seems to have little continued correlation with lower bug density.

Why would that be? Doesn’t 100% tested code mean that we know with 100% certainty that the code does what it was designed to do?

It turns out, it’s not that simple.

What most people don’t realize is that there are two kinds of coverage:

1.  **Code coverage:** how much of the code is exercised, and
2.  **Case coverage:** how many of the use-cases are covered by the test suites

Case coverage refers to use-case scenarios: How the code will behave in the context of real world environment, with real users, real networks, and even hackers intentionally trying to subvert the design of the software for nefarious purposes.

Coverage reports identify code-coverage weaknesses, not case-coverage weaknesses. The same code may apply to more than one use-case, and a single use-case may depend on code outside the subject-under-test, or even in a separate application or 3rd party API.

Because use-cases may involve the environment, multiple units, users, and networking conditions, it is impossible to cover all required use-cases with a test suite that only contains unit tests. Unit tests by definition test units in isolation, not in integration, meaning that a test suite containing only unit tests will always have close to 0% case coverage for integration and functionaluse-case scenarios.

100% code coverage does not guarantee 100% case coverage.

Developers targeting 100% code coverage are chasing the wrong metric.

### 什么是紧耦合？

The need to mock in order to achieve unit isolation for the purpose of unit tests is caused by coupling between units. Tight coupling makes code more rigid and brittle: more likely to break when changes are required. In general, less coupling is desirable for its own sake because it makes code easier to extend and maintain. The fact that it also makes testing easier by eliminating the need for mocks is just icing on the cake.

From this we can deduce that if we’re mocking something, there may be an opportunity to make our code more flexible by reducing the coupling between units. Once that’s done, you won’t need the mocks anymore.

Coupling is the degree to which a unit of code (module, function, class, etc…) depends upon other units of code. Tight coupling, or a high degree of coupling, refers to how likely a unit is to break when changes are made to its dependencies. In other words, the tighter the coupling, the harder it is to maintain or extend the application. Loose coupling reduces the complexity of fixing bugs and adapting the application to new use-cases.

Coupling takes different forms:

*   **Subclass coupling:** Subclasses are dependent on the implementation and entire hierarchy of the parent class: the tightest form of coupling available in OO design.
*   **Control dependencies:** Code that controls its dependencies by telling them what to do, e.g., passing method names, etc… If the control API of the dependency changes, the dependent code will break.
*   **Mutable state dependencies:** Code that shares mutable state with other code, e.g., can change properties on a shared object. If relative timing of mutations change, it could break dependent code. If timing is nondeterministic, it may be impossible to achieve program correctness without a complete overhaul of all dependent units: e.g., there may be an irreparable tangle of race conditions. Fixing one bug could cause others to appear in other dependent units.
*   **State shape dependencies:** Code that shares data structures with other code, and only uses a subset of the structure. If the shape of the shared structure changes, it could break the dependent code.
*   **Event/message coupling:** Code that communicates with other units via message passing, events, etc…

### 什么造成了紧耦合？

Tight coupling has many causes:

*   **Mutation** vs _immutability_
*   **Side-Effects** vs _purity/isolated side-effects_
*   **Responsibility overload** vs _Do One Thing (DOT)_
*   **Procedural instructions** vs _describing structure_
*   **Imperative composition** vs _declarative composition_

Imperative and object-oriented code is more susceptible to tight coupling than functional code. That doesn’t mean that programming in a functional style makes your code immune to tight coupling, but functional code uses pure functions as the elemental unit of composition, and pure functions are less vulnerable to tight coupling by nature.

Pure functions:

*   Given the same input, always return the same output, and
*   Produce no side-effects

How do pure functions reduce coupling?

*   **Immutability:** Pure functions don’t mutate existing values. They return new ones, instead.
*   **No side effects:** The only observable effect of a pure function is its return value, so there’s no chance for it to interfere with the operation of other functions that may be observing external state such as the screen, the DOM, the console, standard out, the network, or the disk.
*   **Do one thing:** Pure functions do one thing: Map some input to some corresponding output, avoiding the responsibility overload that tends to plague object and class-based code.
*   **Structure, not instructions:** Pure functions can be safely memoized, meaning that, if the system had infinite memory, any pure function could be replaced with a lookup table that uses the function’s input as an index to retrieve a corresponding value from the table. In other words, pure functions describe structural relationships between data, not instructions for the computer to follow, so two different sets of conflicting instructions running at the same time can’t step on each other’s toes and cause problems.

### 组合与模拟

Everything. The essence of all software development is the process of breaking a large problem down into smaller, independent pieces (decomposition) and composing the solutions together to form an application that solves the large problem (composition).

> Mocking is required when our decomposition strategy has failed.

Mocking is required when the units used to break the large problem down into smaller parts depend on each other. Put another way, _mocking is required when our supposed atomic units of composition are not really atomic,_ and our decomposition strategy has failed to decompose the larger problem into smaller, independent problems.

When decomposition succeeds, it’s possible to use a generic composition utility to compose the pieces back together. Examples:

*   **Function composition** e.g., `lodash/fp/compose`
*   **Component composition** e.g., composing higher-order components with function composition
*   **State store/model composition** e.g., [Redux combineReducers](http://redux.js.org/docs/api/combineReducers.html)
*   **Object or factory composition** e.g., mixins or functional mixins
*   **Process composition** e.g., transducers
*   **Promise or monadic composition** e.g., `asyncPipe()`, Kleisli composition with `composeM()`, `composeK()`, etc...
*   etc…

When you use generic composition utilities, each element of the composition can be unit tested in isolation _without mocking the others._

The compositions themselves will be declarative, so they’ll contain _zero unit-testable logic_ (presumably the composition utility is a third party library with its own unit tests).

Under those circumstances, there’s nothing meaningful to unit test. You need integration tests, instead.

Let’s contrast imperative vs declarative composition using a familiar example:

```
// Function composition OR
// import pipe from 'lodash/fp/flow';
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
// Functions to compose
const g = n => n + 1;
const f = n => n * 2;
// Imperative composition
const doStuffBadly = x => {
  const afterG = g(x);
  const afterF = f(afterG);
  return afterF;
};
// Declarative composition
const doStuffBetter = pipe(g, f);
console.log(
  doStuffBadly(20), // 42
  doStuffBetter(20) // 42
);
```

Function composition is the process of applying a function to the return value of another function. In other words, you create a pipeline of functions, then pass a value to the pipeline, and the value will go through each function like a stage in an assembly line, transforming the value in some way before it’s passed to the next function in the pipeline. Eventually, the last function in the pipeline returns the final value.

```
initialValue -> [g] -> [f] -> result
```

It is the primary means of organizing application code in every mainstream language, regardless of paradigm. Even Java uses functions (methods) as the primary message passing mechanism between different class instances.

You can compose functions manually (imperatively), or automatically (declaratively). In languages without first-class functions, you don’t have much choice. You’re stuck with imperative. In JavaScript (and almost all the other major popular languages), you can do it better with declarative composition.

Imperative style means that we’re commanding the computer to do something step-by-step. It’s a how-to guide. In the example above, the imperative style says:

1.  Take an argument and assign it to `x`
2.  Create a binding called `afterG` and assign the result of `g(x)` to it
3.  Create a binding called `afterF` and assign the result of `f(afterG)` to it
4.  Return the value of `afterF`.

The imperative style version requires logic that should be tested. I know those are just simple assignments, but I’ve frequently seen (and written) bugs where I pass or return the wrong variable.

Declarative style means we’re telling the computer the relationships between things. It’s a description of structure using equational reasoning. The declarative example says:

*   `doStuffBetter` _is_ the piped composition of `g` and `f`.

That’s it.

Assuming `f` and `g` have their own unit tests, and `pipe()` has its own unit tests (use `flow()` from Lodash or `pipe()` from Ramda, and it will), there's no new logic here to unit test.

In order for this style to work correctly, the units we compose need to be _decoupled._

### 我们如何消除组合？

To remove coupling, we first need a better understanding of where coupling dependencies come from. Here are the main sources, roughly in order of how tight the coupling is:

Tight coupling:

*   Class inheritance (coupling is multiplied by each layer of inheritance and each descendant class)
*   Global variables
*   Other mutable global state (browser DOM, shared storage, network, etc…)
*   Module imports with side-effects
*   Implicit dependencies from compositions, e.g., `const enhancedWidgetFactory = compose(eventEmitter, widgetFactory, enhancements);` where `widgetFactory` depends on `eventEmitter`
*   Dependency injection containers
*   Dependency injection parameters
*   Control parameters (an outside unit is controlling the subject unit by telling it what to do)
*   Mutable parameters

Loose coupling:

*   Module imports without side-effects (in black box testing, not all imports need isolating)
*   Message passing/pubsub
*   Immutable parameters (can still cause shared dependencies on state shape)

Ironically, most of the sources of coupling are mechanisms originally designed to reduce coupling. That makes sense, because in order to recompose our smaller problem solutions into a complete application, they need to integrate and communicate somehow. There are good ways, and bad ways. The sources that cause tight coupling should be avoided whenever it’s practical to do so. The loose coupling options are generally desirable in a healthy application.

You might be confused that I classified dependency injection containers and dependency injection parameters in the “tight coupling” group, when so many books and blog post categorize them as “loose coupling”. Coupling is not binary. It’s a gradient scale. That means that any grouping is going to be somewhat subjective and arbitrary.

I draw the line with a simple, objective litmus test:

Can the unit be tested without mocking dependencies? If it can’t, it’s _tightly coupled_ to the mocked dependencies.

The more dependencies your unit has, the more likely it is that there may be problematic coupling. Now that we understand how coupling happens, what can we do about it?

1.  **Use pure functions** as the atomic unit of composition, as opposed to classes, imperative procedures, or mutating functions.
2.  **Isolate side-effects** from the rest of your program logic. That means don’t mix logic with I/O (including network I/O, rendering UI, logging, etc…).
3.  **Remove dependent logic** from imperative compositions so that they can become declarative compositions which don’t need their own unit tests. If there’s no logic, there’s nothing meaningful to unit test.

That means that the code you use to set up network requests and request handlers won’t need unit tests. Use integration tests for those, instead.

That bears repeating:

> _Don’t unit test I/O._

> _I/O is for integrations. Use integration tests, instead._

It’s perfectly OK to mock and fake for integration tests.

### 使用纯函数

Using pure functions takes a little practice, and without that practice, it’s not always clear how to write a pure function to do what you want to do. Pure functions can’t directly mutate global variables, the arguments passed into them, the network, the disk, or the screen. All they can do is return a value.

If you’re passed an array or an object, and you want to return a changed version of that object, you can’t just make the changes to the object and return it. You have to create a new copy of the object with the required changes. You can do that with the array [accessor methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/prototype) (**not** the mutator methods), `Object.assign()`, using a new empty object as the target, or the array or object spread syntax. For example:

```
// Not pure
const signInUser = user => user.isSignedIn = true;
const foo = {
  name: 'Foo',
  isSignedIn: false
};
// Foo was mutated
console.log(
  signInUser(foo), // true
  foo              // { name: "Foo", isSignedIn: true }
);
```

vs…

```
// Pure
const signInUser = user => ({...user, isSignedIn: true });
const foo = {
  name: 'Foo',
  isSignedIn: false
};
// Foo was not mutated
console.log(
  signInUser(foo), // { name: "Foo", isSignedIn: true }
  foo              // { name: "Foo", isSignedIn: false }
);
```

Alternatively, you can try a library for immutable data types, such as [Mori](http://swannodette.github.io/mori/) or [Immutable.js](https://facebook.github.io/immutable-js/). I’m hopeful that we’ll someday get a nice set of immutable datatypes similar to Clojure’s in JavaScript, but I’m not holding my breath.

You may think that returning new objects could cause a performance hit because we’re creating a new object instead of reusing the existing ones, but a fortunate side-effect of that is that we can detect changes to objects by using an identity comparison (`===` check), so we don't have to traverse through the entire object to discover if anything has changed.

You can use that trick to make React components render faster if you have a complex state tree that you may not need to traverse in depth with each render pass. Inherit from `PureComponent` and it implements `shouldComponentUpdate()` with a shallow prop and state comparison. When it detects identity equality, it knows that nothing has changed in that part of the state tree and it can move on without a deep state traversal.

Pure functions can also be memoized, meaning that you don’t have to build the whole object again if you’ve seen the same inputs before. You can trade computation complexity for memory and store pre-calculated values in a lookup table. For computationally expensive processes which don’t require unbounded memory, this may be a great optimization strategy.

Another property of pure functions is that, because they have no side-effects, it’s safe to distribute complex computations over large clusters of processors, using a divide-and-conquer strategy. This tactic is often employed to process images, videos, or audio frames using massively parallel GPUs originally designed for graphics, but now commonly used for lots of other purposes, like scientific computing.

In other words, mutation isn’t always faster, and it is often orders of magnitude slower because it takes a micro-optimization at the expense of macro-optimizations.

### 隔离副作用与程序逻辑

There are several strategies that can help you isolate side-effects from the rest of your program logic. Here are some of them:

1.  Use pub/sub to decouple I/O from views and program logic. Rather than directly triggering side-effects in UI views or program logic, emit an event or action object describing an event or intent.
2.  Isolate logic from I/O e.g., compose functions which return promises using `asyncPipe()`.
3.  Use objects that represent future computations rather than directly triggering computation with I/O, e.g., `call()` from [redux-saga](https://github.com/redux-saga/redux-saga) doesn't actually call a function. Instead, it returns an object with a reference to a function and its arguments, and the saga middleware calls it for you. That makes `call()` and all the functions that use it _pure functions_, which are easy to unit test with _no mocking required._

#### 使用 Pub/Sub 模型

Pub/sub is short for the publish/subscribe pattern. In the publish/subscribe pattern, units don’t directly call each other. Instead, they publish messages that other units (subscribers) can listen to. Publishers don’t know what (if any) units will subscribe, and subscribers don’t know what (if any) publishers will publish.

Pub/sub is baked into the Document Object Model (DOM). Any component in your application can listen to events dispatched from DOM elements, such as mouse movements, clicks, scroll events, keystrokes, and so on. Back when everyone built web apps with jQuery, it was common to jQuery custom events to turn the DOM into a pub/sub event bus to decouple view rendering concerns from state logic.

Pub/sub is also baked into Redux. In Redux, you create a global model for application state (called the store). Instead of directly manipulating models, views and I/O handlers dispatch action objects to the store. An action object has a special key, called `type` which various reducers can listen for and respond to. Additionally, Redux supports middleware, which can also listen for and respond to specific action types. This way, your views don't need to know anything about how your application state is handled, and the state logic doesn't need to know anything about the views.

It also makes it trivial to patch into the dispatcher via middleware and trigger cross-cutting concerns, such as action logging/analytics, syncing state with storage or the server, and patching in realtime communication features with servers and network peers.

#### 将逻辑从 I/O 中隔离

Sometimes you can use monad compositions (like promises) to eliminate dependent logic from your compositions. For example, the following function contains logic that you can’t unit test without mocking all of the async functions:

```
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

Let’s throw in some helper pseudo-code to make it runnable:

```
const log = (...args) => console.log(...args);
// Ignore these. In your real code you'd import
// the real things.
const readUser = () => Promise.resolve(true);
const getFolderInfo = () => Promise.resolve(true);
const haveWriteAccess = () => Promise.resolve(true);
const uploadToFolder = () => Promise.resolve('Success!');
// gibberish starting variables
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

And now refactor it to use promise composition via `asyncPipe()`:

```
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

The conditional logic is easily removed because promises have conditional branching built-in. The idea is that logic and I/O don’t mix well, so we want to remove the logic from the I/O dependent code.

In order to make this kind of composition work, we need to ensure 2 things:

1.  `haveWriteAccess()` will reject if the user doesn't have write access. That moves the conditional logic into the promise context so we don't have to unit test it or worry about it at all (promises have their own tests baked into the JS engine code).
2.  Each of these functions takes and resolves with the same data type. We could create a `pipelineData` type for this composition which is just an object containing the following keys: `{ user, folder, files, dbUser?, folderInfo? }`. This creates a structure sharing dependency between the components, but you can use more generic versions of these functions in other places and specialize them for this pipeline with thin wrapping functions.

With those conditions met, it’s trivial to test each of these functions in isolation from each other without mocking the other functions. Since we’ve extracted all of the logic out of the pipeline, there’s nothing meaningful left to unit test in this file. All that’s left to test are the integrations.

> Remember: _Logic and I/O are separate concerns.
> Logic is thinking. Effects are actions. Think before you act!_

#### 使用对象来描述未来计算

The strategy used by redux-saga is to use objects that represent future computations. The idea is similar to returning a monad, except that it doesn’t always have to be a monad that gets returned. Monads are capable of composing functions with the chain operation, but you can manually chain functions using imperative-style code, instead. Here’s a rough sketch of how redux-saga does it:

```
// sugar for console.log we'll use later
const log = msg => console.log(msg);
const call = (fn, ...args) => ({ fn, args });
const put = (msg) => ({ msg });
// imported from I/O API
const sendMessage = msg => Promise.resolve('some response');
// imported from state handler/Reducer
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

You can see all the calls being made in your unit tests without mocking the network API or invoking any side-effects. Bonus: This makes your application extremely easy to debug without worrying about nondeterministic network state, etc…

Want to simulate what happens in your app when a network error occurs? Simply call `iter.throw(NetworkError)`

Elsewhere, some library middleware is driving the function, and actually triggering the side-effects in the production application:

```
const iter = sendMessageSaga('Hello, world!');
// Returns an object representing the status and value:
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

Destructure the `call()` object from the yielded value to inspect or invoke the future computation:

```
const { value: {fn, args }} = step1;
```

Effects run in the real middleware. You can skip this part when you’re testing and debugging.

```
const step2 = fn(args);
step2.then(log); // "some response"
```

If you want to simulate a network response without mocking APIs or the http calls, you can pass a simulated response into `.next()`:

```
iter.next(simulatedNetworkResponse);
```

From there you can keep calling `.next()` until `done` is `true`, and your function is finished running.

Using generators and representations of computations in your unit tests, you can simulate everything _up to but excluding_ invoking the real side-effects. You can pass values into `.next()` calls to fake responses, or throw errors at the iterator to fake errors and promise rejections.

Using this style, there’s no need to mock anything in unit tests, even for complex integrational workflows with lots of side-effects.

### “代码” 异味是警告，而非定律。模拟并非恶魔。

All this stuff about using better architecture is great, but in the real world, we have to use other people’s APIs, and integrate with legacy code, and there are lots of APIs that aren’t pure. Isolated test doubles may be useful in those cases. For example, express passes shared mutable state and models side-effects via continuation passing.

Let’s look at a common example. People try to tell me that the express server definition file needs dependency injection because how else will you unit test all the stuff that goes into the express app? E.g.:

```
const express = require('express');
const app = express();
app.get('/', function (req, res) {
  res.send('Hello World!')
});
app.listen(3000, function () {
  console.log('Example app listening on port 3000!')
});
```

In order to “unit test” _this file,_ we’d have to work up a dependency injection solution and then pass mocks for everything into it (possibly including `express()` itself). If this was a very complex file where different request handlers were using different features of express, and counting on that logic to be there, you'd probably have to come up with a pretty sophisticated fake to make that work. I've seen developers create elaborate fakes and mocks of things like express, the session middleware, log handlers, realtime network protocols, you name it. I've faced hard mocking questions myself, but the correct answer is simple.

> This file doesn’t need unit tests.

The server definition file for an express app is by definition the app’s main **integration** point. Testing an express app file is by definition testing an integration between your program logic, express, and all the handlers for that express app. You absolutely should not skip integration tests even if you can achieve 100% unit test coverage.

Instead of trying to unit test this file, isolate your program logic into separate units, and unit test those files. Write real integration tests for the server file, meaning you’ll actually hit the network, or at least create the actual http messages, complete with headers using a tool like [supertest](https://github.com/visionmedia/supertest).

Let’s refactor the Hello World express example to make it more testable:

Pull the `hello` handler into its own file and write unit tests for it. No need to mock the rest of the app components. This obviously isn't a pure function, so we'll need to spy or mock the response object to make sure we call `.send()`.

```
const hello  = (req, res) => res.send('Hello World!');
```

You could test it something like this. Swap out the `if` statement for your favorite test framework expectation:

```
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

Pull the listen handler into its own file and write unit tests for it, too. We have the same problem here. Express handlers are not pure, so we need to spy on the logger to make sure it gets called. Testing is similar to the previous example:

```
const handleListen = (log, port) => () => log(`Example app listening on port ${ port }!`);
```

All that’s left in the server file now is integration logic:

```
const express = require('express');
const hello = require('./hello.js');
const handleListen = require('./handleListen');
const log = require('./log');
const port = 3000;
const app = express();
app.get('/', hello);
app.listen(port, handleListen(port, log));
```

You still need integration tests for this file, but further unit tests won’t meaningfully enhance your case coverage. We use some very minimal dependency injection to pass a logger into `handleListen()`, but there is certainly no need for any dependency injection framework for express apps.

### 模拟很适合集成测试

Because integration tests test collaborative integrations between units, it’s perfectly OK to fake servers, network protocols, network messages, and so on in order to reproduce all the various conditions you’ll encounter during communication with other units, potentially distributed across clusters of CPUs or separate machines on a network.

Sometimes you’ll want to test how your unit will communicate with a 3rd party API, and sometimes those API’s are prohibitively expensive to test for real. You can record real workflow transactions against the real services and replay them from a fake server to test how well your unit integrates with a third party service actually running in a separate network process. Often this is the best way to test things like “did we see the correct message headers?”

There are lots of useful integration testing tools that throttle network bandwidth, introduce network lag, produce network errors, and otherwise test lots of other conditions that are impossible to test using unit tests which mock away the communication layer.

It’s impossible to achieve 100% case coverage without integration tests. Don’t skip them even if you manage to achieve 100% unit test coverage. Sometimes 100% is not 100%.

### 接下来

*   Learn why I think [every development team should be using TDD](https://crosscuttingconcerns.com/Podcast-061-Eric-Elliott-on-TDD) on the Cross Cutting Concerns podcast.
*   JS Cheerleader is documenting [our adventures on Instagram](https://www.instagram.com/js_cheerleader/).

### Need advanced JavaScript training for your team?

DevAnywhere is the fastest way to level up to advanced JavaScript skills with composable software, functional programming and React:

*   1:1 mentorship
*   Live group lessons
*   Flexible hours
*   Build a mentorship culture on your team

![](https://cdn-images-1.medium.com/max/800/1*pskrI-ZjRX_Y0I0zZqVTcQ.png)

[https://devanywhere.io/](https://devanywhere.io/)

**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com) _(O’Reilly), and cofounder of_ [_DevAnywhere.io_](https://devanywhere.io/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_ **_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_ **_Metallica_**_, and many more._

He works anywhere he wants with the most beautiful woman in the world.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
