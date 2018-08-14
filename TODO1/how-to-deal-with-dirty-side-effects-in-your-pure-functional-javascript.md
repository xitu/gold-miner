> - 原文地址：[HOW TO DEAL WITH DIRTY SIDE EFFECTS IN YOUR PURE FUNCTIONAL JAVASCRIPT](https://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript/)
> - 原文作者：[James Sinclair](https://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript.md)
> - 译者：
> - 校对者：

# 如何使用纯函数式 JavaScript 处理脏副作用

首先，假定你对函数式编程有所涉猎。不久你就会遇到 _pure functions_ 的概念。随着时间的推移，你会发现函数式程序员似乎对纯函数很着迷。他们说：”纯函数让你对代码进行推理。”，“纯函数不太可能引发一场热核战争。“，“纯函数提供了引用透明性”。他们说的并没有错。纯函数是个好东西。但是存在一个问题…

纯函数是没有副作用的函数。[1](#fn:1 "see footnote") 但如果你了解编程，你就会知道副作用是 _重点_。 如果无法读取 𝜋 我们为什么要仔 100 个地方计算它？为了把它打印出来，我们需要写在一个控制台，或发送数据到指针，或有一个可以被读取的*东西*。如果数据库不能输入任何数据，那么它又有什么用呢？我们需要从输入设备读取数据，并从网络请求信息。我们做任何事情都不可能没有副作用。然而，函数式编程是建立在纯函数之上的。那么函数式程序员是如何完成任务的呢？

The short answer is, they do what mathematicians do: They cheat.

简单来说就是，做数学家做的事情：欺骗

Now, when I say they cheat, they technically follow the rules. But they find loopholes in those rules and stretch them big enough to drive a herd of elephants through. There’s two main ways they do this:
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

```
const d = {toISOString: () => '1865-11-26T16:00:00.000Z'};
const cnsl = {
    log: () => {
        // do nothing
    },
};
logSomething(d, cnsl, "Off with their heads!");
//  ￩ "Off with their heads!"
```

现在，我们的函数什么事情也没干，除了返回 `something` 参数。但是它是纯的。如果你用相同的参数调用它，它每次都会返回相同的结果。这才是重点。为了使它变得不纯，我们必须采取深思熟虑的行动。或者换句话说，函数依赖于右边的签名。 函数无法访问到像 `console` 或者 `Date` 之类的全局变量。这样所有事情就很明确了。

同样需要注意的是，我们也可以将函数传递给原来不纯的函数。让我们看一下另一个例子。假设表单中有一个 username 字段。我们想要从表单中取到它的值：

```
// getUserNameFromDOM :: () -> String
function getUserNameFromDOM() {
    return document.querySelector('#username').value;
}

const username = getUserNameFromDOM();
username;
// ￩ "mhatter"
```

在这个例子中，我们尝试去从 DOM 中查询信息。这是不纯的，因为 `document` 是一个随时可能改变的全局变量。把我们的函数转化为纯函数的方法之一就是把 全局 `document` 对象当作一个参数传入。但是我们也可以像这样传入一个 `querySelector()` 函数：

```
// getUserNameFromDOM :: (String -> Element) -> String
function getUserNameFromDOM($) {
    return $('#username').value;
}

// qs :: String -> Element
const qs = document.querySelector.bind(document);

const username = getUserNameFromDOM(qs);
username;
// ￩ "mhatter"
```

现在，你可能还是会认为：“这样还是一样傻逼啊！” 我们所做只是把不纯的代码从 `getUsernameFromDOM()` 移出来而已。它并没有消失，我们只是把它放在了另一个函数`qs()` 中。除了使代码更长之外，它似乎没什么作用。我们两个函数取代了之前一个不纯的函数，但是其中一个仍然不纯。

再忍受一下我，假设我们想给 `getUserNameFromDOM()` 写测试。现在，比较一下不纯和纯的版本，哪个更容易便携测试？为了对不纯版本的函数进行测试，我们需要一个全局 `document` 对象，除此之外，还需要一个 ID 为 `username` 的元素。如果我想在浏览器之外测试它，那么我必须导入诸如 JSDOM 或无头浏览器之类的东西。都是为了测试一个很小的函数。但是使用第二个版本，我可以这样做：

```
const qsStub = () => ({value: 'mhatter'});
const username = getUserNameFromDOM(qsStub);
assert.strictEqual('mhatter', username, `Expected username to be ${username}`);
```

现在，这并不意味着你不应该创建在真正的浏览器中运行的集成测试。(或者，至少是像 JSDOM 这样的模拟版本)。但是这个例子所展示的是`getUserNameFromDOM()`现在是完全可预测的。如果我们传递给它 qsStub 它总是会返回 “mhatter” 。我们把不可预测转性移到了更小的函数 qs 中。

如果我们这样做，就可以把这种不可预测性推得越来越远。最终，我们将它们推到代码的边界。因此，我们最终得到了一个由不纯代码组成的薄壳，它包围着一个测试友好的、可预测的核心。当您开始构建更大的应用程序时，这种可预测性就会起到很大的作用。

### 依赖注入的缺点

可以以这种方式创建大型、复杂的应用程序。 我知道是 [因为我做过](https://www.squiz.net/technology/squiz-workplace)。
依赖注入使测试变得更容易，也会使每个函数的依赖关系变得明确。但它也有一些缺点。最主要的一点是，你最终会得到类似这样冗长的函数签名:

```
function app(doc, con, ftch, store, config, ga, d, random) {
    // 这里是应用程序代码
 }

app(document, console, fetch, store, config, ga, (new Date()), Math.random);
```

这还不算太糟，除了参数钻井的问题。在一个底层的函数中，你可能需要这些参数中的一个。因此，您必须通过许多层的函数调用来连接参数。这让人恼火。例如，您可能需要通过 5 层中间函数传递日期。所有这些中间函数都不使用 date 对象。这不是世界末日。至少能够看到这些显式的依赖关系还是不错的。但它仍然让人恼火。还有这儿还有另一种方式……

## 懒函数

让我们看看函数式程序员利用的第二个漏洞。它是这样开始的: 发生的副作用才是副作用。我知道这听起来神秘的。让我们试着让它更明确一点。思考一下这段代码:

```
// fZero :: () -> Number
function fZero() {
    console.log('Launching nuclear missiles');
    // 这里是发射核弹的代码
    return 0;
}
```

我知道这是个愚蠢的例子。如果我们想在代码中有一个 0，我们可以直接写出来。我知道你，文雅的读者，永远不会用 JavaScript 写控制核武器的代码。但它有助于说明这一点。这显然是不纯的代码。因为它输出日志到控制台，也可能开始热核战争。假设我们想要 0。假设我们想要计算导弹发射后的情况。我们可能需要启动倒计时之类的东西。在这种情况下，提前计划如何进行计算是完全合理的。我们会非常小心这些导弹什么时候起飞。我们不想搞混我们的计算结果，以免他们意外发射导弹。那么，如果我们将 `fZero()` 包装在另一个只返回它的函数中呢？有点像安全包装。

```
// fZero :: () -> Number
function fZero() {
    console.log('Launching nuclear missiles');
    // 这里是发射核弹的代码
    return 0;
}

// returnZeroFunc :: () -> (() -> Number)
function returnZeroFunc() {
    return fZero;
}
```

我可以运行 `returnZeroFunc()` 任意次，只要不调用返回值，我理论上就是安全的。我的代码不会发射任何核弹。

```
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

```
// fZero :: () -> Number
function fZero() {
    console.log('Launching nuclear missiles');
    // 这里是发射核弹的代码
    return 0;
}
```

让我们尝试使用 `fZero()` 返回的零，但不会开始热核战争。我们将创建一个函数，它接受 `fZero()` 最终返回的 0，并在此基础上加一：

```
// fIncrement :: (() -> Number) -> Number
function fIncrement(f) {
    return f() + 1;
}

fIncrement(fZero);
// ⦘ 发射导弹
// ￩ 1
```

哎呦！我们意外地发动了热核战争。让我们再试一次。这一次，我们不会返回一个数字。相反，我们将返回一个最终返回一个数字的函数：

```
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

This function wrapping thing is a legitimate strategy. We can keep hiding behind functions as long as we want. And so long as we never actually call any of these functions, they’re all theoretically pure. And nobody is starting any wars. In regular (non-nuclear) code, we actually _want_ those side effects, eventually. Wrapping everything in a function lets us control those effects with precision. We decide exactly when those side effects happen. But, it’s a pain typing those brackets everywhere. And it’s annoying to create new versions of every function. We’ve got perfectly good functions like `Math.sqrt()` built into the language. It would be nice if there was a way to use those ordinary functions with our delayed values. Enter the Effect functor.

这样的函数包装是合法的策略。我们可以一直躲在函数后面，想躲多久就躲多久。只要我们不调用这些函数，它们理论上都是纯的。没有人发动战争。在常规(非核)代码中，我们实际上最终希望得到那些副作用能够运行。将所有东西包装在一个函数中可以让我们精确地控制这些效果。我们决定这些副作用发生的确切时间。但是，输入那些括号很痛苦。创建每个函数的新版本很烦人。我们在语言中内置了一些非常好的函数，比如 `Math.sqrt()`。如果有一种方法可以用延迟值来使用这些普通函数就好了。进入下一节 Effect 函子。

## Effect 函子

For our purposes, the Effect functor is nothing more than an object that we stick our delayed function in. So, we’ll stick our `fZero` function into an Effect object. But, before we do that, let’s take the pressure down a notch:

```
// zero :: () -> Number
function fZero() {
    console.log('Starting with nothing');
    // Definitely not launching a nuclear strike here.
    // But this function is still impure.
    return 0;
}
```

Now we create a constructor function that creates an Effect object for us:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {};
}
```

Not much to look at so far. Let’s make it do something useful. We want to use our regular `fZero()` function with our Effect. We’ll write a method that will take a regular function, and _eventually_ apply it to our delayed value. And we’ll do it _without triggering the effect_. We call it `map`. This is because it creates a _mapping_ between regular functions and Effect functions. It might look something like this:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        }
    }
}
```

Now, if you’re paying attention, you may be wondering about `map()`. It looks suspiciously like compose. We’ll come back to that later. For now, let’s try it out:

```
const zero = Effect(fZero);
const increment = x => x + 1; // A plain ol' regular function.
const one = zero.map(increment);
```

Hmm. We don’t really have a way to see what happened. Let’s modify Effect so we have a way to ‘pull the trigger’, so to speak:

```
// Effect :: Function -> Effect
function Effect(f) {
    return {
        map(g) {
            return Effect(x => g(f(x)));
        },
        runEffects(x) {
            return f(x);
        }
    }
}

const zero = Effect(fZero);
const increment = x => x + 1; // Just a regular function.
const one = zero.map(increment);

one.runEffects();
// ⦘ Starting with nothing
// ￩ 1
```

And if we want to, we can keep calling that map function:

```
const double = x => x * 2;
const cube = x => Math.pow(x, 3);
const eight = Effect(fZero)
    .map(increment)
    .map(double)
    .map(cube);

eight.runEffects();
// ⦘ Starting with nothing
// ￩ 8
```

Now, this is where it starts to get interesting. We called this a ‘functor’. All that means is that Effect has a `map` function, and it [obeys some rules](https://github.com/fantasyland/fantasy-land#functor). These rules aren’t the kind of rules for things you _can’t_ do though. They’re rules for things you _can_ do. They’re more like privileges. Because Effect is part of the functor club, there are certain things it gets to do. One of those is called the ‘composition rule’. It goes like this:

If we have an Effect `e`, and two functions `f`, and `g`  
Then `e.map(g).map(f)` is equivalent to `e.map(x => f(g(x)))`.

To put it another way, doing two maps in a row is equivalent to composing the two functions. Which means Effect can do things like this (recall our example above):

```
const incDoubleCube = x => cube(double(increment(x)));
// If we're using a library like Ramda or lodash/fp we could also write:
// const incDoubleCube = compose(cube, double, increment);
const eight = Effect(fZero).map(incDoubleCube);
```

And when we do that, we are _guaranteed_ to get the same result as our triple-map version. We can use this to refactor our code, with confidence that our code will not break. In some cases we can even make performance improvements by swapping between approaches.

But enough with the number examples. Let’s do something more like ‘real’ code.

### A shortcut for making Effects

Our Effect constructor takes a function as its argument. This is convenient, because most of the side effects we want to delay are also functions. For example, `Math.random()` and `console.log()` are both this type of thing. But sometimes we want to jam a plain old value into an Effect. For example, imagine we’ve attached some sort of config object to the `window` global in the browser. We want to get a a value out, but this is will not be a pure operation. We can write a little shortcut that will make this task easier:[3](#fn:3 "see footnote")

```
// of :: a -> Effect a
Effect.of = function of(val) {
    return Effect(() => val);
}
```

To show how this might be handy, imagine we’re working on a web application. This application has some standard features like a list of articles and a user bio. But _where_ in the HTML these components live changes for different customers. Since we’re clever engineers, we decide to store their locations in a global config object. That way we can always locate them.fe For example:

```
window.myAppConf = {
    selectors: {
        'user-bio':     '.userbio',
        'article-list': '#articles',
        'user-name':    '.userfullname',
    },
    templates: {
        'greet':  'Pleased to meet you, {name}',
        'notify': 'You have {n} alerts',
    }
};
```

Now, with our `Effect.of()` shortcut, we can quickly shove the value we want into an Effect wrapper like so:

```
const win = Effect.of(window);
userBioLocator = win.map(x => x.myAppConf.selectors['user-bio']);
// ￩ Effect('.userbio')
```

### Nesting and un-nesting Effects

Mapping Effects thing can get us a long way. But sometimes we end up mapping a function that also returns an Effect. We’ve already defined `getElementLocator()` which returns an Effect containing a string. If we actually want to locate the DOM element, then we need to call `document.querySelector()`—another impure function. So we might purify it by returning an Effect instead:

```
// $ :: String -> Effect DOMElement
function $(selector) {
    return Effect.of(document.querySelector(s));
}
```

Now if we want to put those two together, we can try using `map()`:

```
const userBio = userBioLocator.map($);
// ￩ Effect(Effect(<div>))
```

What we’ve got is a bit awkward to work with now. If we want to access that div, we have to map with a function that also maps the thing we actually want to do. For example, if we wanted to get the `innerHTML` it would look something like this:

```
const innerHTML = userBio.map(eff => eff.map(domEl => domEl.innerHTML));
// ￩ Effect(Effect('<h2>User Biography</h2>'))
```

Let’s try picking that apart a little. We’ll back all the way up to `userBio` and move forward from there. It will be a bit tedious, but we want to be clear about what’s going on here. The notation we’ve been using, `Effect('user-bio')` is a little misleading. If we were to write it as code, it would look more like so:

```
Effect(() => '.userbio');
```

Except that’s not accurate either. What we’re really doing is more like:

```
Effect(() => window.myAppConf.selectors['user-bio']);
```

Now, when we map, it’s the same as composing that inner function with another function (as we saw above). So when we map with `$`, it looks a bit like so:

```
Effect(() => window.myAppConf.selectors['user-bio']);
```

Expanding that out gives us:

```
Effect(
    () => Effect.of(document.querySelector(window.myAppConf.selectors['user-bio'])))
);
```

And expanding `Effect.of` gives us a clearer picture:

```
Effect(
    () => Effect(
        () => document.querySelector(window.myAppConf.selectors['user-bio'])
    )
);
```

Note: All the code that actually does stuff is in the innermost function. None of it has leaked out to the outer Effect.

#### Join

Why bother spelling all that out? Well, we want to un-nest these nested Effects. If we’re going to do that, we want to make certain that we’re not bringing in any unwanted side-effects in the process. For Effect, the way to un-nest, is to call `.runEffects()` on the outer function. But this might get confusing. We’ve gone through this whole exercise to check that we’re _not_ going to run any effects. So we’ll create another function that does the same thing, and call it `join`. We use `join` when we’re un-nesting Effects, and `runEffects()` when we actually want to run effects. That makes our intention clear, even if the code we run is the same.

```
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

We can then use this to un-nest our user biography element:

```
const userBioHTML = Effect.of(window)
    .map(x => x.myAppConf.selectors['user-bio'])
    .map($)
    .join()
    .map(x => x.innerHTML);
// ￩ Effect('<h2>User Biography</h2>')
```

#### Chain

This pattern of running `.map()` followed by `.join()` comes up often. So often in fact, that it would be handy to have a shortcut function. That way, whenever we have a function that returns an Effect, we can use this shortcut. It saves us writing `map` then `join` over and over. We’d write it like so:

```
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

We call the new function `chain()` because it allows us to chain together Effects. (That, and because the standard tells us to call it that).[4](#fn:4 "see footnote") Our code to get the user biography inner HTML would then look more like this:

```
const userBioHTML = Effect.of(window)
    .map(x => x.myAppConf.selectors['user-bio'])
    .chain($)
    .map(x => x.innerHTML);
// ￩ Effect('<h2>User Biography</h2>')
```

Unfortunately, other programming languages use a bunch of different names for this idea. It can get a little bit confusing if you’re trying to read up about it. Sometimes it’s called `flatMap`. This name makes a lot of sense, as we’re doing a regular mapping, then flattening out the result with `.join()`. In Haskell though, it’s given the confusing name of `bind`. So if you’re reading elsewhere, keep in mind that `chain`, `flatMap` and `bind` refer to similar concepts.

### Combining Effects

There’s one final scenario where working with Effect might get a little awkward. It’s where we want to combine two or more Effects using a single function. For example, what if we wanted to grab the user’s name from the DOM? And then insert it into a template provided by our app config? So, we might have a template function like this (note that we’re creating a curried version):

```
// tpl :: String -> Object -> String
const tpl = curry(function tpl(pattern, data) {
    return Object.keys(data).reduce(
        (str, key) => str.replace(new RegExp(`{${key}}`, data[key]),
        pattern
    );
});
```

That’s all well and good. But let’s grab our data:

```
const win = Effect.of(window);
const name = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str});
// ￩ Effect({name: 'Mr. Hatter'});

const pattern = win.map(w => w.myAppConfig.templates('greeting'));
// ￩ Effect('Pleased to meet you, {name}');
```

We’ve got a template function. It takes a string and an object, and returns a string. But our string and object (`name` and `pattern`) are wrapped up in Effects. What we want to do is _lift_ our `tpl()` function up into a higher plane so that it works with Effects.

Let’s start out by seeing what happens if we call `map()` with `tpl()` on our pattern Effect:

```
pattern.map(tpl);
// ￩ Effect([Function])
```

Looking at the types might make things a little clearer. The type signature for map is something like this:

    _map :: Effect a ~> (a -> b) -> Effect b_

And our template function has the signature:

    _tpl :: String -> Object -> String_

So, when we call map on `pattern`, we get a _partially applied_ function (remember we curried `tpl`) inside an Effect.

    _Effect (Object -> String)_

We now want to pass in the value from inside our pattern Effect. But we don’t really have a way to do that yet. We’ll write another method for Effect (called `ap()`) that will take care of this:

```
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
             // If someone calls ap, we assume eff has a function inside it (rather than a value).
            // We'll use map to go inside off, and access that function (we'll call it 'g')
            // Once we've got g, we apply the value inside off f() to it
            return eff.map(g => g(f()));
        }
    }
}
```

With that in place, we can run `.ap()` to apply our template:

```
const win = Effect.of(window);
const name = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str}));

const pattern = win.map(w => w.myAppConfig.templates('greeting'));

const greeting = name.ap(pattern.map(tpl));
// ￩ Effect('Pleased to meet you, Mr Hatter')
```

We’ve achieved our goal. But I have a confession to make… The thing is, I find `ap()` confusing sometimes. It’s hard to remember that I have to map the function in first, and then run `ap()` after. And then I forget which order the parameters are applied. But there is a way around this. Most of the time, what I’m trying to do is _lift_ an ordinary function up into the world of applicatives. That is, I’ve got plain functions, and I want to make them work with things like Effect that have an `.ap()` method. We can write a function that will do this for us:

```
// liftA2 :: (a -> b -> c) -> (Applicative a -> Applicative b -> Applicative c)
const liftA2 = curry(function liftA2(f, x, y) {
    return y.ap(x.map(f));
    // We could also write:
    //  return x.map(f).chain(g => y.map(g));
});
```

We’ve called it `liftA2()` because it lifts a function that takes two arguments. We could similarly write a `liftA3()` like so:

```
// liftA3 :: (a -> b -> c -> d) -> (Applicative a -> Applicative b -> Applicative c -> Applicative d)
const liftA3 = curry(function liftA3(f, a, b, c) {
    return c.ap(b.ap(a.map(f)));
});
```

Notice that `liftA2` and `liftA3` don’t ever mention Effect. In theory, they can work with any object that has a compatible `ap()` method.

Using `liftA2()` we can rewrite our example above as follows:

```
const win = Effect.of(window);
const user = win.map(w => w.myAppConfig.selectors['user-name'])
    .chain($)
    .map(el => el.innerHTML)
    .map(str => ({name: str});

const pattern = win.map(w => w.myAppConfig.templates['greeting']);

const greeting = liftA2(tpl)(pattern, user);
// ￩ Effect('Pleased to meet you, Mr Hatter')
```

## So What?

At this point, you may be thinking ‘This seems like a lot of effort to go to just to avoid the odd side effect here and there.’ What does it matter? Sticking things inside Effects, and wrapping our heads around `ap()` seems like hard work. Why bother, when the impure code works just fine? And when would you ever _need_ this in the real world?

> The functional programmer sounds rather like a mediæval monk, denying himself the pleasures of life in the hope it will make him virtuous.
>
> —John Hughes[5](#fn:5 "see footnote")

Let’s break those objections down into two questions:

1.  Does functional purity really matter? and
2.  When would this Effect thing ever be useful in the real world?

### Functional Purity Matters

It’s true. When you look at a small function in isolation, a little bit of impurity doesn’t matter. Writing `const pattern = window.myAppConfig.templates['greeting'];` is quicker and simpler than something like this:

```
const pattern = Effect.of(window).map(w => w.myAppConfig.templates('greeting'));
```

And _if that was all you ever did_, that would remain true. The side effect wouldn’t matter. But this is just one line of code—in an application that may contain thousands, even millions of lines of code. Functional purity starts to matter a lot more when you’re trying to work out why your app has mysteriously stopped working ‘for no reason’. Something unexpected has happened. You’re trying to break the problem down and isolate its cause. In those circumstances, the more code you can rule out the better. If your functions are pure, then you can be confident that the only thing affecting their behaviour are the inputs passed to it. And this narrows down the number of things you need to consider… err… considerably. In other words, it allows you to _think less_. In a large, complex application, this is a Big Deal.

### The Effect pattern in the real world

Okay. Maybe functional purity matters if you’re building a large, complex applications. Something like Facebook or Gmail. But what if you’re not doing that? Let’s consider a scenario that will become more and more common. You have some data. Not just a little bit of data, but a _lot_ of data. Millions of rows of it, in CSV text files, or huge database tables. And you’re tasked with processing this data. Perhaps you’re training an artificial neural network to build an inference model. Perhaps you’re trying to figure out the next big cryptocurrency move. Whatever. The thing is, it’s going to take a lot of processing grunt to get the job done.

Joel Spolsky argues convincingly that [functional programming can help us out here](https://www.joelonsoftware.com/2006/08/01/can-your-programming-language-do-this/). We could write alternative versions of `map` and `reduce` that will run in parallel. And functional purity makes this possible. But that’s not the end of the story. Sure, you can write some fancy parallel processing code. But even then, your development machine still only has 4 cores (or maybe 8 or 16 if you’re lucky). That job is still going to take forever. Unless, that is, you can run it on _heaps_ of processors… something like a GPU, or a whole cluster of processing servers.

For this to work, you’d need to _describe_ the computations you want to run. But, you want to describe them _without actually running them_. Sound familiar? Ideally, you’d then pass the description to some sort of framework. The framework would take care of reading all the data in, and splitting it up among processing nodes. Then the same framework would pull the results back together and tell you how it went. This how TensorFlow works.

> TensorFlow™ is an open source software library for high performance numerical computation. Its flexible architecture allows easy deployment of computation across a variety of platforms (CPUs, GPUs, TPUs), and from desktops to clusters of servers to mobile and edge devices. Originally developed by researchers and engineers from the Google Brain team within Google’s AI organization, it comes with strong support for machine learning and deep learning and the flexible numerical computation core is used across many other scientific domains.
>
> —TensorFlow home page[6](#fn:6 "see footnote")

When you use TensorFlow, you don’t use the normal data types from the programming language you’re writing in. Instead, you create ‘Tensors’. If we wanted to add two numbers, it would look something like this:

```
node1 = tf.constant(3.0, tf.float32)
node2 = tf.constant(4.0, tf.float32)
node3 = tf.add(node1, node2)
```

The above code is written in Python, but it doesn’t look so very different from JavaScript, does it? And like with our Effect, the `add` code won’t run until we tell it to (using `sess.run()`, in this case):

```
print("node3: ", node3)
print("sess.run(node3): ", sess.run(node3))
#⦘ node3:  Tensor("Add_2:0", shape=(), dtype=float32)
#⦘ sess.run(node3):  7.0
```

We don’t get 7.0 until we call `sess.run()`. As you can see, it’s much the same as our delayed functions. We plan out our computations ahead of time. Then, once we’re ready, we pull the trigger to kick everything off.

## Summary

We’ve covered a lot of ground. But we’ve explored two ways to handle functional impurity in our code:

1.  Dependency injection; and
2.  The Effect functor.

Dependency injection works by moving the impure parts of the code out of the function. So you have to pass them in as parameters. The Effect functor, in contrast, works by wrapping everything behind a function. To run the effects, we have to make a deliberate effort to run the wrapper function.

Both approaches are cheats. They don’t remove the impurities entirely, they just shove them out to the edges of our code. But this is a good thing. It makes explicit which parts of the code are impure. This can be a real advantage when attempting to debug problems in complex code bases.

---

1.  This is not a complete definition, but will do for the moment. We will come back to the formal definition later. [ ↩](#fnref:1 "return to body")

2.  In other languages (like Haskell) this is called an IO functor or an IO monad. [PureScript](http://www.purescript.org/) uses the term _Effect_. And I find it is a little more descriptive. [ ↩](#fnref:2 "return to body")

3.  Note that different languages have different names for this shortcut. In Haskell, for example, it's called `pure`. I have no idea why. [ ↩](#fnref:3 "return to body")

4.  In this case, the standard is the [Fantasy Land specification for Chain](https://github.com/fantasyland/fantasy-land#chain). [ ↩](#fnref:4 "return to body")

5.  John Hughes, 1990, ‘Why Functional Programming Matters’, _Research Topics in Functional Programming_ ed. D. Turner, Addison–Wesley, pp 17–42, [https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf](https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf) [ ↩](#fnref:5 "return to body")

6.  _TensorFlow™: An open source machine learning framework for everyone,_ [https://www.tensorflow.org/](https://www.tensorflow.org/), 12 May 2018. [ ↩](#fnref:6 "return to body")

- [Let me know your thoughts via the Twitters](https://twitter.com/share?url=http://jrsinclair.com/articles/2018/how-to-deal-with-dirty-side-effects-in-your-pure-functional-javascript&text=%E2%80%9CHow to deal with dirty side effects in your pure functional JavaScript%E2%80%9D+by+%40jrsinclair)
- [Subscribe to receive updates via the electronic mail system](/subscribe.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
