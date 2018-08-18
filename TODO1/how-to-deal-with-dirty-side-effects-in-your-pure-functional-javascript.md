> - 原文地址：[HOW TO DEAL WITH DIRTY SIDE EFFECTS IN YOUR PURE FUNCTIONAL JAVASCRIPT](https://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript/)
> - 原文作者：[James Sinclair](https://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript.md)
> - 译者：
> - 校对者：

# 如何使用纯函数式 JavaScript 处理脏副作用

首先，假定你对函数式编程有所涉猎。不久你就会遇到 _pure functions_ 的概念。随着时间的推移，你会发现函数式程序员似乎对纯函数很着迷。他们说：”纯函数让你对代码进行推理。”，“纯函数不太可能引发一场热核战争。“，“纯函数提供了引用透明性”。他们说的并没有错。纯函数是个好东西。但是存在一个问题…

纯函数是没有副作用的函数。[1](#fn:1 "see footnote") 但如果你了解编程，你就会知道副作用是 _重点_。 如果无法读取 𝜋 我们为什么要仔 100 个地方计算它？为了把它打印出来，我们需要写在一个控制台，或发送数据到指针，或有一个可以被读取的*东西*。如果数据库不能输入任何数据，那么它又有什么用呢？我们需要从输入设备读取数据，并从网络请求信息。我们做任何事情都不可能没有副作用。然而，函数式编程是建立在纯函数之上的。那么函数式程序员是如何完成任务的呢？

简单来说就是，做数学家做的事情：欺骗

他们欺骗时严格遵守规则。但他们发现了这些规则中的漏洞，并将其扩大到足以让一群大象通过。有两种主要的方法:

1.  _依赖注入_，或者我们也可以叫它 _搁置问题_；以及
2.  _使用 Effect 函子_, 我们可以把它想象为 _重度拖延_.[2](#fn:2 "see footnote")

## 依赖注入

依赖注入是我们处理副作用的第一种方法。在这种方法中，我们将代码中的不纯的部分放入函数参数中。然后我们就可以把它们看作是其他函数的责任。为了解释我的意思，我们来看看一些代码:

```js
// logSomething :: String -> ()
function logSomething(something) {
  const dt = new Date().toIsoString();
  console.log(`${dt}: ${something}`);
  return something;
}
```

`logSomething()` 函数有两个不纯的地方: 它创建了一个 `Date()` 对象并且把它输出到控制台。因此，它不仅执行了 IO 操作, 而且每次运行的时候都会给出不同的结果。那么，如何使这个函数变纯？使用依赖注入，我们以函数参数的形式接受不纯的部分，因此我们的函数并非接收一个参数而是三个参数：

```js
// logSomething: Date -> Console -> String -> ()
function logSomething(d, cnsl, something) {
  const dt = d.toIsoString();
  cnsl.log(`${dt}: ${something}`);
  return something;
}
```

然后调用它，我们必须自行明确地传入不纯的部分：

```js
const something = "Curiouser and curiouser!";
const d = new Date();
logSomething(d, console, something);
// ⦘ Curiouser and curiouser!
```

现在，你可能会想：”这样做有点傻逼。我们所做就一切把问题变得更严重了，代码还是和之前一样不纯。“你是对的。 这完全就是一个漏洞。

YouTube 视频链接：https://youtu.be/9ZSoJDUD_bU

这就像事在装傻：“噢！不！警官，我不知道在`cnsl`上调用`log()`会执行 IO 操作。这是别人传给我的。我不知道它从哪来的“ 这看起爱有点蹩脚。

这并不想表面上那么愚蠢，注意我们的 `logSomething()` 函数。如果你要处理一些不纯的事情, 你就会它导致不纯。 我们可以简单地传入不同的参数：

```js
const d = { toISOString: () => "1865-11-26T16:00:00.000Z" };
const cnsl = {
  log: () => {
    // do nothing
  }
};
logSomething(d, cnsl, "Off with their heads!");
//  ￩ "Off with their heads!"
```

现在，我们的函数什么事情也没干，除了返回 `something` 参数。但是它是纯的。如果你用相同的参数调用它，它每次都会返回相同的结果。这才是重点。为了使它变得不纯，我们必须采取深思熟虑的行动。或者换句话说，函数依赖于右边的签名。 函数无法访问到像 `console` 或者 `Date` 之类的全局变量。这样所有事情就很明确了。

同样需要注意的是，我们也可以将函数传递给原来不纯的函数。让我们看一下另一个例子。假设表单中有一个 username 字段。我们想要从表单中取到它的值：

```js
// getUserNameFromDOM :: () -> String
function getUserNameFromDOM() {
  return document.querySelector("#username").value;
}

const username = getUserNameFromDOM();
username;
// ￩ "mhatter"
```

在这个例子中，我们尝试去从 DOM 中查询信息。这是不纯的，因为 `document` 是一个随时可能改变的全局变量。把我们的函数转化为纯函数的方法之一就是把 全局 `document` 对象当作一个参数传入。但是我们也可以像这样传入一个 `querySelector()` 函数：

```js
// getUserNameFromDOM :: (String -> Element) -> String
function getUserNameFromDOM($) {
  return $("#username").value;
}

// qs :: String -> Element
const qs = document.querySelector.bind(document);

const username = getUserNameFromDOM(qs);
username;
// ￩ "mhatter"
```

现在，你可能还是会认为：“这样还是一样傻逼啊！” 我们所做只是把不纯的代码从 `getUsernameFromDOM()` 移出来而已。它并没有消失，我们只是把它放在了另一个函数`qs()` 中。除了使代码更长之外，它似乎没什么作用。我们两个函数取代了之前一个不纯的函数，但是其中一个仍然不纯。

再忍受一下我，假设我们想给 `getUserNameFromDOM()` 写测试。现在，比较一下不纯和纯的版本，哪个更容易便携测试？为了对不纯版本的函数进行测试，我们需要一个全局 `document` 对象，除此之外，还需要一个 ID 为 `username` 的元素。如果我想在浏览器之外测试它，那么我必须导入诸如 JSDOM 或无头浏览器之类的东西。都是为了测试一个很小的函数。但是使用第二个版本，我可以这样做：

```js
const qsStub = () => ({ value: "mhatter" });
const username = getUserNameFromDOM(qsStub);
assert.strictEqual("mhatter", username, `Expected username to be ${username}`);
```

现在，这并不意味着你不应该创建在真正的浏览器中运行的集成测试。(或者，至少是像 JSDOM 这样的模拟版本)。但是这个例子所展示的是`getUserNameFromDOM()`现在是完全可预测的。如果我们传递给它 qsStub 它总是会返回 “mhatter” 。我们把不可预测转性移到了更小的函数 qs 中。

如果我们这样做，就可以把这种不可预测性推得越来越远。最终，我们将它们推到代码的边界。因此，我们最终得到了一个由不纯代码组成的薄壳，它包围着一个测试友好的、可预测的核心。当您开始构建更大的应用程序时，这种可预测性就会起到很大的作用。

### 依赖注入的缺点

可以以这种方式创建大型、复杂的应用程序。 我知道是 [因为我做过](https://www.squiz.net/technology/squiz-workplace)。
依赖注入使测试变得更容易，也会使每个函数的依赖关系变得明确。但它也有一些缺点。最主要的一点是，你最终会得到类似这样冗长的函数签名:

```js
function app(doc, con, ftch, store, config, ga, d, random) {
  // 这里是应用程序代码
}

app(document, console, fetch, store, config, ga, new Date(), Math.random);
```

这还不算太糟，除了参数钻井的问题。在一个底层的函数中，你可能需要这些参数中的一个。因此，您必须通过许多层的函数调用来连接参数。这让人恼火。例如，您可能需要通过 5 层中间函数传递日期。所有这些中间函数都不使用 date 对象。这不是世界末日。至少能够看到这些显式的依赖关系还是不错的。但它仍然让人恼火。还有这儿还有另一种方式……

## 懒函数

让我们看看函数式程序员利用的第二个漏洞。它是这样开始的: 发生的副作用才是副作用。我知道这听起来神秘的。让我们试着让它更明确一点。思考一下这段代码:

```js
// fZero :: () -> Number
function fZero() {
  console.log("Launching nuclear missiles");
  // 这里是发射核弹的代码
  return 0;
}
```

我知道这是个愚蠢的例子。如果我们想在代码中有一个 0，我们可以直接写出来。我知道你，文雅的读者，永远不会用 JavaScript 写控制核武器的代码。但它有助于说明这一点。这显然是不纯的代码。因为它输出日志到控制台，也可能开始热核战争。假设我们想要 0。假设我们想要计算导弹发射后的情况。我们可能需要启动倒计时之类的东西。在这种情况下，提前计划如何进行计算是完全合理的。我们会非常小心这些导弹什么时候起飞。我们不想搞混我们的计算结果，以免他们意外发射导弹。那么，如果我们将 `fZero()` 包装在另一个只返回它的函数中呢？有点像安全包装。

```js
// fZero :: () -> Number
function fZero() {
  console.log("Launching nuclear missiles");
  // 这里是发射核弹的代码
  return 0;
}

// returnZeroFunc :: () -> (() -> Number)
function returnZeroFunc() {
  return fZero;
}
```

我可以运行 `returnZeroFunc()` 任意次，只要不调用返回值，我理论上就是安全的。我的代码不会发射任何核弹。

```js
const zeroFunc1 = returnZeroFunc();
const zeroFunc2 = returnZeroFunc();
const zeroFunc3 = returnZeroFunc();
// 没有发射核弹。
```

现在，让我们更正式地定义纯函数。然后，我们可以更详细地检查我们的 `returnZeroFunc()` 函数。如果一个函数满足以下条件就可以称之为纯函数:

1.  没有明显的副作用
2.  引用透明。也就是说，给定相同的输入，它总是返回相同的输出。

Let’s check out `returnZeroFunc()`. Does it have any side effects? Well, we just established that calling `returnZeroFunc()` won’t launch any nuclear missiles. Unless you go to the extra step of calling the returned function, nothing happens. So, no side-effects here.

让我们看看 `returnZeroFunc()`。有副作用吗？嗯，之前我们确定过，调用 `returnZeroFunc()` 不会发射任何核导弹。除非执行调用返回函数的额外步骤，否则什么也不会发生。所以，这个函数没有副作用。

`returnZeroFunc()` 引用透明吗? 也就是说，给定相同的输入，它总是返回相同的输出? 好吧，按照它目前的编写方式，我们可以测试它:

```js
zeroFunc1 === zeroFunc2; // true
zeroFunc2 === zeroFunc3; // true
```

但它还不能算纯。 `returnZeroFunc()` 函数引用函数作用域外的一个变量。为了解决这个问题，我们可以以这种方式进行重写：

```js
// returnZeroFunc :: () -> (() -> Number)
function returnZeroFunc() {
  function fZero() {
    console.log("Launching nuclear missiles");
    // 这里是发射核弹的代码
    return 0;
  }
  return fZero;
}
```

现在我们的函数事纯函数了。 但是，JavaScript 阻碍了我们一会。我们无法再使用 `===` 来验证引用透明性。 这是因为`returnZeroFunc()` 总是返回一个新的函数引用。 但是你可以通过审查代码来检查引用透明。 `returnZeroFunc()` 函数每次除了返回相同的函数其他什么也不做。

这是一个巧妙的小漏洞。但我们真的能把它用在真正的代码上吗？答案是肯定的。但在我们讨论如何在实践中实现它之前，让我们先搁置这个想法。先回到危险的 `fZero()` 函数：

```js
// fZero :: () -> Number
function fZero() {
  console.log("Launching nuclear missiles");
  // 这里是发射核弹的代码
  return 0;
}
```

让我们尝试使用 `fZero()` 返回的零，但不会开始热核战争。我们将创建一个函数，它接受 `fZero()` 最终返回的 0，并在此基础上加一：

```js
// fIncrement :: (() -> Number) -> Number
function fIncrement(f) {
  return f() + 1;
}

fIncrement(fZero);
// ⦘ 发射导弹
// ￩ 1
```

哎呦！我们意外地发动了热核战争。让我们再试一次。这一次，我们不会返回一个数字。相反，我们将返回一个最终返回一个数字的函数：

```js
// fIncrement :: (() -> Number) -> (() -> Number)
function fIncrement(f) {
  return () => f() + 1;
}

fIncrement(zero);
// ￩ [Function]
```

唷！为了避免危机，让我们继续。有了这两个函数，我们可以创建一系列的 “最终数字”：

```js
const fOne = fIncrement(zero);
const fTwo = fIncrement(one);
const fThree = fIncrement(two);
// 等等…
```

我们也可以创建一组 `f*()` 函数来处理最终值：

```js
// fMultiply :: (() -> Number) -> (() -> Number) -> (() -> Number)
function fMultiply(a, b) {
  return () => a() * b();
}

// fPow :: (() -> Number) -> (() -> Number) -> (() -> Number)
function fPow(a, b) {
  return () => Math.pow(a(), b());
}

// fSqrt :: (() -> Number) -> (() -> Number)
function fSqrt(x) {
  return () => Math.sqrt(x());
}

const fFour = fPow(fTwo, fTwo);
const fEight = fMultiply(fFour, fTwo);
const fTwentySeven = fPow(fThree, fThree);
const fNine = fSqrt(fTwentySeven);
// 没有控制台日志或热核战争。干得不错！
```

看到我们做了什么了吗？如果能用普通数字来做的， 那么我们也可以用最终数字（返回数字的函数）。数学称之为[同构](https://en.wikipedia.org/wiki/Isomorphism)。我们总是可以把一个普通的数放在一个函数中，将其变成一个最终的数。我们可以通过调用这个函数得到最终的数字。换句话说，我们建立一个数字和最终数字之间映射。这比听起来更令人兴奋。我保证。我们很快就会回到这个问题上。

这样进行函数包装是合法的策略。我们可以一直躲在函数后面，想躲多久就躲多久。只要我们不调用这些函数，它们理论上都是纯的。没有人发动战争。在常规(非核)代码中，我们实际上最终希望得到那些副作用能够运行。将所有东西包装在一个函数中可以让我们精确地控制这些效果。我们决定这些副作用发生的确切时间。但是，输入那些括号很痛苦。创建每个函数的新版本很烦人。我们在语言中内置了一些非常好的函数，比如 `Math.sqrt()`。如果有一种方法可以用延迟值来使用这些普通函数就好了。进入下一节 Effect 函子。

## Effect 函子

就我们的目的而言，Effect 函子只不过是一个被置入延迟函数的对象。我们将把 `fZero` 函数置入到一个 Effect 对象中。但是，在我们这样做之前，让我们把压强降低一个等级

```js
// zero :: () -> Number
function fZero() {
  console.log("Starting with nothing");
  // 绝对不会在这里发动核打击。
  // 但是这个函数任然不纯
  return 0;
}
```

现在我们创建一个返回 Effect 对象的构造函数

```js
// Effect :: Function -> Effect
function Effect(f) {
  return {};
}
```

到目前为止，还没有什么可看的。让我们做一些有用的事情。我们希望配合 Effetct 使用常规的 `fZero()` 函数。我们将编写一个接收常规函数并延后返回值的方法。它运行时不触发任何效果。我们称之为 `map`。这是因为它在常规函数和效果函数之间创建了一个 _映射_。它可能看起来像这样:

```js
// Effect :: Function -> Effect
function Effect(f) {
  return {
    map(g) {
      return Effect(x => g(f(x)));
    }
  };
}
```

现在，如果你观察仔细的话，你可能想知道 `map()` 的作用。它看起来像是组合。我们稍后会讲到。现在，让我们尝试一下:

```js
const zero = Effect(fZero);
const increment = x => x + 1; // A plain ol' regular function.
const one = zero.map(increment);
```

嗯。我们并没有看到发生了什么。让我们修改一下 Effect，这样我们就有了办法来 “扣动扳机”。可以这写:

```js
// Effect :: Function -> Effect
function Effect(f) {
  return {
    map(g) {
      return Effect(x => g(f(x)));
    },
    runEffects(x) {
      return f(x);
    }
  };
}

const zero = Effect(fZero);
const increment = x => x + 1; // 只是一个普通的函数
const one = zero.map(increment);

one.runEffects();
// ⦘ 什么也没启动
// ￩ 1
```

并且只要我们愿意, 我们可以一直调用 `map` 函数:

```js
const double = x => x * 2;
const cube = x => Math.pow(x, 3);
const eight = Effect(fZero)
  .map(increment)
  .map(double)
  .map(cube);

eight.runEffects();
// ⦘ 什么也没启动
// ￩ 8
```

从这里开始变得有意思了。 我们称这为函子. 这意味着 Effect 有一个 `map` 函数, 它 [遵循一些规则](https://github.com/fantasyland/fantasy-land#functor). 这些规则并不意味着你不能这样做。它们是你可以做的规则。它们更像是优先级。因为 Effect 是函子大家庭的一份子，所以它可以做一些事情。其中一个叫做“合成规则”。它长这样:

如果我们有一个 Effect `e`, 两个函数 `f` 和 `g`  
那么 `e.map(g).map(f)` 等同于 `e.map(x => f(g(x)))`.

换句话说, 一行写两个 `map` 函数等同于组合这两个函数. 也就是说 Effect 可以这样写 (回顾一下上面的例子)):

```
const incDoubleCube = x => cube(double(increment(x)));
// 如果你使用像 Ramda 或者 lodash/fp 之类的库, 我们也可以这样写:
// const incDoubleCube = compose(cube, double, increment);
const eight = Effect(fZero).map(incDoubleCube);
```

当我们这样做的时候，我们可以确认会得到与三重 `map` 版本相同的结果。我们可以使用它重构代码，并确信代码不会崩溃。在某些情况下，我们甚至可以通过在不同方法之间进行交换来改进性能。

但这些例子已经足够了。让我们开始实战吧.

### Effects 简写

我们的 Effect 构造函数接受一个函数作为它的参数。这很方便，因为大多数我们想要延迟的副作用也是函数。例如，`Math.random()` 和 `console.log()` 都是这种类型的东西。但有时我们想把一个普通的旧值压缩成一个 Effect。例如，假设我们在浏览器的 `window`全局对象中附加了某种配置对象。我们想要得到一个 a 值，但这不是一个纯粹的运算。我们可以写一个小快捷方式，使这个任务更容易:[3](#fn:3 "see footnote")

```js
// of :: a -> Effect a
Effect.of = function of(val) {
  return Effect(() => val);
};
```

为了说明这可能很方便，假设我们正在处理一个 web 应用。这个应用有一些标准特性，比如文章列表和用户简介。但是在 HTML 中，这些组件针对不同的客户进行展示。因为我们是聪明的工程师，所以我们决定将他们的位置存储在一个全局配置对象中。这样我们总能找到它们。例如:

```js
window.myAppConf = {
  selectors: {
    "user-bio": ".userbio",
    "article-list": "#articles",
    "user-name": ".userfullname"
  },
  templates: {
    greet: "Pleased to meet you, {name}",
    notify: "You have {n} alerts"
  }
};
```

现在使用`Effect.of()`, 我们可以很快地把我们想要的值包装进一个 Effect 容器, 就像这样

```
const win = Effect.of(window);
userBioLocator = win.map(x => x.myAppConf.selectors['user-bio']);
// ￩ Effect('.userbio')
```

### 内嵌 与 非内嵌 Effect

映射 Effect 可能花了我们比较多的精力. 但是有时候我们会遇到 映射的函数也返回一个 Effect 的情况. 我们已经定义了一个 `getElementLocator()`, 它返回一个包含字符串的 Effect. 如果我们真的想要拿到 DOM 元素, 我们需要调用另外一个非纯函数 `document.querySelector()`. 所以我们可能会通过返回一个 Effect 来纯化它:

```js
// $ :: String -> Effect DOMElement
function $(selector) {
  return Effect.of(document.querySelector(s));
}
```

现在如果想把它两放一起, 我们可以尝试使用 `map()`:

```js
const userBio = userBioLocator.map($);
// ￩ Effect(Effect(<div>))
```

What we’ve got is a bit awkward to work with now. If we want to access that div, we have to map with a function that also maps the thing we actually want to do. For example, if we wanted to get the `innerHTML` it would look something like this:

想要真正运作起来还有点尴尬。如果我们想要访问那个 div，我们必须用一个函数来映射我们想要做的事情。例如，如果我们想要得到 `innerHTML`，它看起来是这样的:

```js
const innerHTML = userBio.map(eff => eff.map(domEl => domEl.innerHTML));
// ￩ Effect(Effect('<h2>User Biography</h2>'))
```

让我们试着分解。我们会回到 `userBio`，然后继续。这有点乏味，但我们想弄清楚这里发生了什么。我们使用的标记 `Effect('user-bio')` 有点误导人。如果我们把它写成代码，它看起来更像这样:

```js
Effect(() => ".userbio");
```

但这也不准确。我们真正做的是:

```js
Effect(() => window.myAppConf.selectors["user-bio"]);
```

Now, when we map, it’s the same as composing that inner function with another function (as we saw above). So when we map with `$`, it looks a bit like so:

现在，当我们进行映射时，它就相当于将内部函数与另一个函数组合(正如我们在上面看到的)。所以当我们用 `$` 映射时，它看起来像这样:

```
Effect(() => window.myAppConf.selectors['user-bio']);
```

把它展开得到:

```js
Effect(
  () => Effect.of(document.querySelector(window.myAppConf.selectors['user-bio'])))
);
```

展开 `Effect.of` 给我们一个更清晰的概览:

```js
Effect(() =>
  Effect(() => document.querySelector(window.myAppConf.selectors["user-bio"]))
);
```

注意: 所有实际执行操作的代码都在最里面的函数中。这些都没有泄露到外部的 Effect。

#### Join

为什么要这样拼写呢? 好吧, 我们想要这些内嵌的 Effects 变成非内嵌的形式. 对于 Effect 而言, 不内嵌的方式就是在外部函数调用 `.runEffects()`. 但这可能会让人困惑。我们已经完成了整个练习，以检查我们不会运行任何 Effect。我们会创建另一个函数做同样的事情，并将其命名为 `join`。 我们使用 `join` 来解除内嵌的 Effect, 使用 `runEffects()` 真正运行所有 Effect. 这使我们的意图更加清晰，即使我们运行的代码是相同的。

```js
// Effect :: Function -> Effect
function Effect(f) {
  return {
    map(g) {
        return Effect(x => g(f(x)));
    },
    runEffects(x) {
        return f(x);
    }
    join(x) {
        return f(x);
    }
  }
}
```

然后，我们可以使用它来解内嵌我们用户简介元素:

```js
const userBioHTML = Effect.of(window)
  .map(x => x.myAppConf.selectors["user-bio"])
  .map($)
  .join()
  .map(x => x.innerHTML);
// ￩ Effect('<h2>User Biography</h2>')
```

#### Chain

`.map()` 之后紧跟 `.join()` 这种模式经常出现. So often in fact, that it would be handy to have a shortcut function. That way, whenever we have a function that returns an Effect, we can use this shortcut. It saves us writing `map` then `join` over and over. We’d write it like so:

事实上，有一个简写函数是很方便的。这样，无论何时我们有一个返回 Effect 的函数，我们都可以使用这个简写函数。它可以把我们从一遍又一遍地写 `map` 然后 `join` 中解救出来。我们这样写:

```js
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        },
        runEffects(x) {
            return f(x);
        }
        join(x) {
            return f(x);
        }
        chain(g) {
            return Effect(f).map(g).join();
        }
    }
}
```

我们调用新的函数 `chain()` 因为它允许我们把 Effect 链接到一起. (其实也是因为标准告诉我们可以这样调用它).[4](#fn:4 "see footnote")取到用户简介元素的 `innerHTML` 可能长这样:

```js
const userBioHTML = Effect.of(window)
  .map(x => x.myAppConf.selectors["user-bio"])
  .chain($)
  .map(x => x.innerHTML);
// ￩ Effect('<h2>User Biography</h2>')
```

不幸的是, 对于这个实现其他函数式语言有着一些不同的名字. 如果你读到它, 你可能会有点疑惑. 有时候它被称之为 `flatMap`, 这个名字很有意义, 因为我们先进行一个普通的映射, 然后使用 `.join()`扁平化结果. 不过在 Haskell 中, `chain` 被赋予了一个令人疑惑的名字 `bind`. 所以如果你在其他地方读到的话, 记住 `chain`, `flatMap` 和 `bind`其实是同一概念的引用.

### 结合 Effects

这是最后一个使用 Effect 有点尴尬的场景, 我们想要在一个函数中组合两个或者多个函子. 例如, 如果我们要从 DOM 中拿到用户的名字要怎么做? 然后根据我的应用设置插入一个模板呢? 因此, 我们可能有一个模板函数(注意我们将创建一个科里化版本的函数)

```js
// tpl :: String -> Object -> String
const tpl = curry(function tpl(pattern, data) {
    return Object.keys(data).reduce(
        (str, key) => str.replace(new RegExp(`{${key}}`, data[key]),
        pattern
    );
});
```

一切都很正常. 但是现在来获取我们需要的数据:

```js
const win = Effect.of(window);
const name = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str});
// ￩ Effect({name: 'Mr. Hatter'});

const pattern = win.map(w => w.myAppConfig.templates('greeting'));
// ￩ Effect('Pleased to meet you, {name}');
```

我们已经有一个模板函数了. 它接收一个字符串和一个对象并且返回一个字符串. 但是我们的 字符串和对象 (`name` 和 `pattern`) 已经包装到 Effect 里了. 我们所要做的就是提升我们 `tpl()` 函数到更高的地方使得它能很好地与 Effect 工作.

让我们看一下如果我们在 pattern Effect 上用`map()` 调用 `tpl()`会发生什么:

```js
pattern.map(tpl);
// ￩ Effect([Function])
```

对照一下类型可能会使得事情更加清晰一点. map 的类型签名可能长这样:

    _map :: Effect a ~> (a -> b) -> Effect b_

模板函数是这样的签名:

    _tpl :: String -> Object -> String_

因此, 当我们在 `pattern` 上调用 `map`, 我们在 Effect 内部得到了一个 _partially applied_ 函数 (记住我们科里化过 `tpl`).

    _Effect (Object -> String)_

现在我们想从 pattern Effect 内部传递值。但我们还没有办法做到。我们将编写另一个效果方法(称为 `ap()`)来处理这个问题:

```js
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        },
        runEffects(x) {
            return f(x);
        }
        join(x) {
            return f(x);
        }
        chain(g) {
            return Effect(f).map(g).join();
        }
        ap(eff) {
             // 如果有人调用了 ap, 我们假定 eff 有一个函数而不是一个值在里面.
            // 我们将用 map 来进入 eff 内部, 并且访问那个函数
            // 一旦我们得到了 g，我们就对它应用 f() 里面的值
            return eff.map(g => g(f()));
        }
    }
}
```

有了它，我们可以运行' .ap() '来应用我们的模板:

```js
const win = Effect.of(window);
const name = win
  .map(w => w.myAppConfig.selectors["user-name"])
  .chain($)
  .map(el => el.innerHTML)
  .map(str => ({ name: str }));

const pattern = win.map(w => w.myAppConfig.templates("greeting"));

const greeting = name.ap(pattern.map(tpl));
// ￩ Effect('Pleased to meet you, Mr Hatter')
```

我们已经实现我们的目标。但我要承认，我发现`ap()`有时会让人感到困惑。很难记住我必须先映射函数，然后再运行' ap() '。然后我可能会忘了参数的顺序。但是有一种方法可以解决这个问题。大多数时候，我想做的是把一个普通函数提升到应用程序的世界。也就是说，我已经有了简单的函数，我想让它们与具有 `.ap()` 方法的 Effect 一起工作。我们可以写一个函数来做这个:

```js
// liftA2 :: (a -> b -> c) -> (Applicative a -> Applicative b -> Applicative c)
const liftA2 = curry(function liftA2(f, x, y) {
  return y.ap(x.map(f));
  // 我们也可以这样写:
  //  return x.map(f).chain(g => y.map(g));
});
```

我们称它为 `liftA2()` 因为它会提升一个接受两个参数的函数. 我们可以写一个与之相似的 `liftA3()`, 像这样:

```js
// liftA3 :: (a -> b -> c -> d) -> (Applicative a -> Applicative b -> Applicative c -> Applicative d)
const liftA3 = curry(function liftA3(f, a, b, c) {
  return c.ap(b.ap(a.map(f)));
});
```

Notice that `liftA2` and `liftA3` don’t ever mention Effect. In theory, they can work with any object that has a compatible `ap()` method.

注意，`liftA2` 和 `liftA3` 从来没有提到 Effect。理论上，它们可以与任何具有兼容 `ap()` 方法的对象一起工作。
使用 `liftA2()` 我们可以像下面这样重写之前的例子:

```js
const win = Effect.of(window);
const user = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str});

const pattern = win.map(w => w.myAppConfig.templates['greeting']);

const greeting = liftA2(tpl)(pattern, user);
// ￩ Effect('Pleased to meet you, Mr Hatter')
```

## 那又怎样?

这时候你可能会想“这似乎为了避免随处可见的奇怪的副作用而付出了很多努力。” 这有什么关系? 传入参数到 Effect 内部，封装 `ap()`似乎是一项艰巨的工作。当不纯代码正常工作时，为什么还要烦恼呢? 在实际场景中，你什么时候会需要这个?

> 函数式程序员听起来有点像一个苦行僧,否认自己的快乐生活,希望慈悲为怀.
>
> —John Hughes[5](#fn:5 "see footnote")

让我们把这些反对意见分成两个问题:

1.  函数纯度真的重要吗? 以及
2.  在真实场景中什么时候有用?

### 函数纯度重要性

函数纯度的确重要. 当你单独观察一个小函数时，一点点的不纯并不重要。写`const pattern = window.myAppConfig.templates['greeting'];` 比写下面这样的代码更加快速简单

```
const pattern = Effect.of(window).map(w => w.myAppConfig.templates('greeting'))
```

如果那是你所做的一切都是是对的, 那么副作用不要紧。但这只是应用程序中的一行代码，其中可能包含数千甚至数百万行代码。当你试图弄清楚为什么你的应用程序莫名其妙地“毫无理由”地停止工作时，函数纯度就变得更加重要了。发生了一些意想不到的事, 你试图把问题分解开来，找出原因。在这种情况下，可以排除的代码越多越好。如果您的函数是纯的，那么您可以确信，影响它们行为的唯一因素是传递给它的输入。这就大大减少了你需要考虑的事情的数量。换句话说，它能让你少思考。在大型、复杂的应用程序中尤为重要。

### 实际场景中的 Effect 模式

好吧。如果你正在构建一个大型的、复杂的应用程序，类似 Facebook 或 Gmail。那么函数纯度可能很重要。但如果你不这么做呢?让我们考虑一个越发普遍的场景。你有一些数据。不只是一点点数据，而是大量的数据--数百万行，在 CSV 文本文件或大型数据库表中。你的任务是处理这些数据。也许你在训练一个人工神经网络来建立一个推理模型。也许你正试图找出加密货币的下一个大动向。无论如何, 问题是要完成这项工作需要大量的处理工作。

Joel Spolsky 令人信服地论证过 [函数式编程可以帮助我们解决这个问题](https://www.joelonsoftware.com/2006/08/01/can-your-programming-language-do-this/).我们可以编写并行运行的 `map` 和 `reduce` 的替代版本。而函数纯度使这成为可能。但这并不是故事的结尾。当然，您可以编写一些奇特的并行处理代码。但即便如此，您的开发机器仍然只有 4 个内核(如果幸运的话，可能是 8 个或 16 个)。那项工作仍然需要很长时间。除非，也就是说，你可以在一堆处理器上运行它，比如 GPU，或者整个处理服务器集群。

要使其工作，您需要描述您想要运行的计算。但是，您需要在不实际运行它们的情况下描述它们。听起来是不是很熟悉?理想情况下，您应该将描述传递给某种框架。该框架将小心地负责读取所有数据，并将其在处理节点之间分割。然后相同的框架会把结果拉回一起，告诉你它是如何进行的。这就是 TensorFlow 的工作流程。

> TensorFlow™ 是一个采用数据流图（data flow graphs），用于数值计算的开源软件库。节点（Nodes）在图中表示数学操作，图中的线（edges）则表示在节点间相互联系的多维数据数组，即张量（tensor）。它灵活的架构让你可以在多种平台上展开计算，例如台式计算机中的一个或多个 CPU（或 GPU），服务器，移动设备等等。TensorFlow 最初由 Google 大脑小组（隶属于 Google 机器智能研究机构）的研究员和工程师们开发出来，用于机器学习和深度神经网络方面的研究，但这个系统的通用性使其也可广泛用于其他计算领域。
>
> —TensorFlow 首页[6](#fn:6 "see footnote")

当您使用 TensorFlow 时，你不会使用你所使用的编程语言中的常规数据类型。而是,你需要创建张量。如果我们想加两个数字，它看起来是这样的:

```python
node1 = tf.constant(3.0, tf.float32)
node2 = tf.constant(4.0, tf.float32)
node3 = tf.add(node1, node2)
```

上面的代码是用 Python 编写的，但是它看起来和 JavaScript 没有太大的区别，不是吗? 和我们的 Effect 类似, `add` 直到我们调用它才会运行 (在这个例子中使用了 `sess.run()`):

```python
print("node3: ", node3)
print("sess.run(node3): ", sess.run(node3))
#⦘ node3:  Tensor("Add_2:0", shape=(), dtype=float32)
#⦘ sess.run(node3):  7.0
```

在调用 `se .run()` 之前，我们不会得到 7.0。正如你看到的，它和我们的延时函数很像。我们提前计划好了计算。然后，一旦我们准备好了，我们就会扣动扳机把一切都踢开。

## 总结

We’ve covered a lot of ground. But we’ve explored two ways to handle functional impurity in our code:
我们覆盖了大范围的知识。但是我们已经探索了两种方法来处理代码中的函数纯度:

1.  依赖注入; 和
2.  Effect 函子

依赖注入的工作原理是将代码的不纯部分移出函数。所以你必须把它们作为参数传递进来。相比之下，Effect functor 的工作原理则是将所有内容包装在一个函数后面。要运行这些 effect，我们必须特意运行包装器函数。

这两种方法都是欺骗。他们不会完全去除不纯，他们只是把它们推到代码的边缘。但这是件好事。它明确说明了代码的哪些部分是不纯的。在调试复杂代码库中的问题时，很有优势。

1.  这不是一个完整的定义，但暂时可以使用。我们稍后会回到正式的定义。 [ ↩](#fnref:1 "return to body")

2.  在其他语言(如 Haskell)中，这称为 IO 函子或 IO 单子。 [PureScript](http://www.purescript.org/) 使用 _Effect_ 作为术语. 我发现它更具有描述性. [ ↩](#fnref:2 "return to body")

3.  注意，不同的语言对这个简写有不同的名称。例如，在 Haskell 中，它被称为“pure”。我不知道为什么。 [ ↩](#fnref:3 "return to body")

4.  在这个例子中, 采用了 [Fantasy Land specification for Chain](https://github.com/fantasyland/fantasy-land#chain) 标准. [ ↩](#fnref:4 "return to body")

5.  John Hughes, 1990, ‘Why Functional Programming Matters’, _Research Topics in Functional Programming_ ed. D. Turner, Addison–Wesley, pp 17–42, [https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf](https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf) [ ↩](#fnref:5 "return to body")

6.  _TensorFlow™: 面向所有人的开源机器学习框架,_ [https://www.tensorflow.org/](https://www.tensorflow.org/), 12 May 2018. [ ↩](#fnref:6 "return to body")

- [通过 Twitter 让我知道你的想法](https://twitter.com/share?url=http://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript&text=%E2%80%9CHow to deal with dirty side effects in your pure functional JavaScript%E2%80%9D+by+%40jrsinclair)
- [Subscribe to receive updates via the electronic mail system](/subscribe.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
