> * 原文地址：[Familiarity Bias is Holding You Back: It’s Time to Embrace Arrow Functions](https://medium.com/javascript-scene/familiarity-bias-is-holding-you-back-its-time-to-embrace-arrow-functions-3d37e1a9bb75)
> * 原文作者：本文已获原作者 [Eric Elliott](https://medium.com/@_ericelliott) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Germxu](https://github.com/Germxu),[GangsterHyj](https://github.com/GangsterHyj)

# 别让你的偏爱拖了后腿：快拥抱箭头函数吧！ #

![题图："锚"——锚212——(CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/800/1*Dwv24VW3sEuGBo4BqrsRQg.jpeg)

我以教 JavaScript 为生。最近我给学生上了柯里化箭头函数这个课程——这还是最开始的几节课。我认为它是一个很好用的技能，因此将这个内容提到了课程的前面。而学生们没有让我失望，比我想象中地**更快地**掌握了使用箭头函数进行柯里化。

如果学生们能够理解它，并且能尽快由它获益，为什么不早点将箭头函数教给他们呢？

> Note：我的课程并不适合那些从来没有接触过代码的人。大多数学生在加入我们的课程之前至少有几个月的编程经历——无论他们是自学，还是通过培训班学习，或者本身就是专业的。然而，我发现许多只有一点经验或者没有经验的年轻开发者们能够很快地接受这些主题。

我看到很多的学生在上了 1 小时的课之后就能很熟练地使用箭头函数工作了。（如果你是[“和 Eric Elliott 一起学习 JavaScript”](https://ericelliottjs.com/product/lifetime-access-pass/)培训班的同学，你可以看这个约 55 分钟的视频——[ES6 的柯里化与组合](https://ericelliottjs.com/premium-content/es6-curry-composition/)）。

看到学生们如此之快地掌握与应用他们新发现的柯里化方法，我想起了我在推特上发了柯里化箭头函数的帖子，然后被一群人喷“可读性差”的事。我很惊讶为什么他们会坚持这个观点。

首先，我们先来看看这个例子。我在推特发了这个函数，然后我发现有人强烈反对这种写法：

```
const secret = msg => () => msg;
```

我对有人在推特上指责我在误导别人感到不可思议。我写这个函数是为了示范在 ES6 中写柯里化函数是多么的**简单**。它是我能想到的在 JavaScript 中**最简单**的实际运用与闭包表达式了。（相关阅读：[什么是闭包](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-closure-b2f0d2152b36)）

它和下面的函数表达式等价：

```
const secret = function (msg) {
  return function () {
    return msg;
  };
};
```

`secret()` 是一个函数，它需要传入 `msg` 这个参数，然后会返回一个新的函数，这个函数将会返回 `msg` 的值。无论你向 `secret()` 中传入什么值，它都会利用闭包固定 `msg` 的值。

你可以这么用它：

```
const mySecret = secret('hi');
mySecret(); // 'hi'
```

事实证明，双箭头并没有让人感到困惑。我坚信：

> 对于熟悉的人来说，单行的箭头函数是 JavaScript 表达柯里化函数**最具有可读性**的方法了。

有许多人指责我，告诉我将代码写的长一些比简短的代码更容易阅读。他们有时也许是对的，但是大多数情况都错了。更长、更详细的代码不一定更容易阅读——至少，对熟悉箭头函数的人来说就是如此。

我在推特上看到的持反对意见的人，并没有像我的学生一样享受平滑的学习箭头函数的过程。在我的经验里，学生学习柯里化箭头函数就像鱼在水里生活一样。仅仅学了几天，他们就开始使用箭头了。它帮助学生们轻松地跨过了各种编程问题的鸿沟。

我没有看到学习、阅读、理解箭头函数对那些学生造成了任何的“困难”——一旦他们决定学习，只要上个大概一小时的课就能基本掌握。

他们能够很轻松地读懂柯里化箭头函数，尽管他们从来没有见过这类的东西，他们还是能够告诉我这些函数做了什么事。当我给他们布置任务后他们也能够很自如地自己完成任务。

从另一方面说，他们能够很快**熟悉**柯里化箭头函数，并且没有为此产生任何**问题**。他们阅读这些函数就像你读一句话一样，他们对其的理解让他们写出了更简单、更少 bug 的代码。

### 为什么一些人认为传统的函数表达式看起来“更具有可读性”？ ###

**偏爱**是一种显著的[人类认知偏差](https://www.psychologytoday.com/blog/mind-my-money/200807/familiarity-bias-part-i-what-is-it)，它会让我们在有更好的选择的情况下做出自暴自弃的选择。我们会因此无视更舒服更好的方法，习惯性地选用以前使用过的老方法。

你可以从这本书中更详细地了解“偏爱”这种心理：[《The Undoing Project: A Friendship that Changed Our Minds》](https://www.amazon.com/Undoing-Project-Friendship-Changed-Minds-ebook/dp/B01GI6S7EK/ref=as_li_ss_tl?ie=UTF8&qid=1492606452&sr=8-1&keywords=the+undoing+project&linkCode=ll1&tag=eejs-20&linkId=4ebd1476f97023e8acb4bba37ea18b90)（很多情况都是我们自欺欺人）。每个软件工程师都应该读一读这本书，因为它会鼓励你辩证地去看待问题，以及鼓励你多对假设进行实验，以免掉入各种认知陷阱中。书中那些发现认知陷阱的故事也很有趣。

### 传统的函数表达式可能会在你的代码中导致 Bug 的出现 ###

今天我用 ES5 的语法重写了一个 ES6 写的柯里化箭头函数，以便发布开源模块让人们无需编译就能在老浏览器中用。然而 ES5 版本让我震惊。

ES6 版本的代码非常简短、简介、优雅——仅仅只需要 4 行。

我觉得，这件事可以发个推特，告诉大家箭头函数是一种更加优越的实现，是时候如同放弃自己的坏习惯一样，放弃传统函数表达式的写法了。

所以我发了一条推特：

[![Markdown](http://i2.muimg.com/1949/15826825ba3ae5a9.png)](https://twitter.com/_ericelliott/status/854608052967751680/photo/1)

为了防止你看不清图片，下面贴上这个函数的文本：

```
// 使用箭头函数柯里化
const composeMixins = (...mixins) => (
  instance = {},
  mix = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x)
) => mix(...mixins)(instance);
// 对比一下 ES5 风格的代码：
var composeMixins = function () {
  var mixins = [].slice.call(arguments);
  return function (instance, mix) {
    if (!instance) instance = {};
    if (!mix) {
      mix = function () {
        var fns = [].slice.call(arguments);
        return function (x) {
          return fns.reduce(function (acc, fn) {
            return fn(acc);
          }, x);
        };
      };
    }
    return mix.apply(null, mixins)(instance);
  };
};
```

这里的函数封装了一个 `pipe()`，它是标准的函数式编程的工具函数，通常[用于组合函数](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-function-composition-20dfb109a1a0)。这个 `pipe()` 函数在 lodash 中是 `lodash/flow`，在 Ramda 中是 `R.pipe()`，在一些函数式编程语言中它甚至本身就是一个运算符号。

每个[熟悉函数式编程](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0)的人都应该很熟悉它。它的实现主要依赖于[Reduce](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d)。

在这个例子中，它用来组合混合函数，不过这点无关紧要（有专门写这方面的博客文章）。我们需要注意是以下几个重要的细节：

这个函数可以将任何数量的函数混合，最终返回一个函数，这个函数在管道中应用了其它的函数——就像流水线一样。每个混合函数都将实例（`instance`）作为输入，然后在将自己传递给管道中下一个函数之前，将一些变量传入。

如果你没有传入 `instance`，它将会为你创建一个新的对象。

有时你可能会想用别的混合方式。例如，使用 `compose()` 代替 `pipe()` 来传递函数，让组合顺序反过来。

如果你不需要自定义函数混合时的行为，你可以简单地使用默认设定，使用 `pipe()` 来完成过程。

### 事实 ###

除了可读性的区别之外，以下列举了一些与这个例子有关的**客观事实**：

- 我有多年的 ES5 与 ES6 编程经验，无论是箭头函数表达式还是别的函数表达式我都很熟悉。因此“偏爱”对我来说**不是**一个变化无常的因素。
- 我没几秒就写好了 ES6 版本的代码，它没有任何 bug（它通过了所有的单元测试，因此我敢肯定这点）。
- 写 ES5 版本的代码花了我好几分钟。一个是几秒，一个是几分钟，差距还是挺大的。写 ES5 代码时，我有 2 次弄错了函数的作用范围；写出了 3 个 bug，然后要花时间去分别调试与修复；还有 2 次我不得不使用 `console.log()` 来弄清函数执行的情况。
- ES6 版本代码仅仅只有 4 行。
- ES5 版本代码有 21 行（其中真正有代码的有 17 行）。
- 尽管 ES5 版本的代码更加冗长，但是它比起 ES6 版本的代码来说仍然缺少了一些信息。它虽然长，但是**表达的东西更少**。这个问题在后面会提到。
- ES6 版本代码在代码中有 2 个 speard 运算符。而 ES5 版本代码中没有这个运算符，而是使用了**意义晦涩**的 `arguments` 对象，它将严重影响函数内容的可读性。（不推荐原因之一）
- ES6 版本代码在函数片段中定义了 `mix` 的默认值，由此你可以很清楚地看到它是参数的值。而 ES5 版本代码却混淆了这个细节问题，将它隐藏在函数体中。（不推荐原因之二）
- ES6 版本代码仅有 2 层代码块，这将会帮助读者理解代码结构，以及知道如何去阅读这个代码。而 ES5 代码有 6 层代码块，复杂的层级结构会让函数结构的可读性变得很差。（不推荐原因之三）

在 ES5 版本代码中，`pipe()` 占据了函数体的大部分内容——要把它们放到同一行中去简直是个荒唐的想法。非常**有必要**将 `pipe()` 这个函数单独抽离出来，让我们的 ES5 版本代码更具有可读性：

```
var pipe = function () {
  var fns = [].slice.call(arguments);

  return function (x) {
    return fns.reduce(function (acc, fn) {
      return fn(acc);
    }, x);
  };
};

var composeMixins = function () {
  var mixins = [].slice.call(arguments);

  return function (instance, mix) {
    if (!instance) instance = {};
    if (!mix) mix = pipe;

    return mix.apply(null, mixins)(instance);
  };
};
```

这样，我觉得它更具可读性，并且更容易理解它的意思了。

让我们看看如果我们对 ES6 版本代码做一些可读性“优化”会怎么样：

```
const pipe = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x);

const composeMixins = (...mixins) => (
  instance = {},
  mix = pipe
) => mix(...mixins)(instance);
```

就像 ES5 版本代码的优化一样，这个“优化”后的代码更加冗长（它加入了之前没有的新变量）。与 ES5 版本代码不同，这个版本在将管道的概念抽象出来后**并没有明显的提高代码可读性**。不过毕竟函数里已经清楚的写明了 `mix` 这个变量，它还是更容易让人理解一些。

`mix` 的定义本身在它的那一行就已经存在了，它不太可能会让阅读代码的人找不到何时结束 `mix`、剩下的代码何时执行。

而现在我们用了 2 个变量来表示同一个东西。我们因此而获益了吗？完全没有。

那么为什么 ES5 函数在对函数进行抽象之后会变得**更具可读性**呢？

因为之前 ES5 版本的代码**明显更复杂**。这种复杂度的来源是我们讨论的问题重点。我可以断言，它的复杂度的来源归根结底就是**语法干扰**，这种语法干扰只会让**函数的本身含义变得费解**，并没有别的用处。

让我们换种方法，把一些多余的变量去掉，在例子中都使用 ES6 代码，只比较**箭头函数**与**传统函数表达式**：

```
var composeMixins = function (...mixins) {
  return function (
    instance = {},

    mix = function (...fns) {
      return function (x) {
        return fns.reduce(function (acc, fn) {
          return fn(acc);
        }, x);
      };
    }
  ) {
    return mix(...mixins)(instance);
  };
};
```

现在，至少我觉得它的可读性显著的提升了。我们利用 **rest** 语法以及**默认参数**语法对它进行了修改。当然，你得对 rest 语法和默认参数语法很熟悉才会觉得这个版本的代码更可读。不过即使你不了解这些，我觉得这个版本也会看起来更加**有条理**。

现在已经改进了许多了，但是我觉得这个版本还是比较简洁。将 `pipe()` 抽象出来，写到它自己的函数里可能会**有所帮助**：

```
const pipe = function (...fns) {
  return function (x) {
    return fns.reduce(function (acc, fn) {
      return fn(acc);
    }, x);
  };
};

// 传统函数表达式
const composeMixins = function (...mixins) {
  return function (
    instance = {},
    mix = pipe
  ) {
    return mix(...mixins)(instance);
  };
};
```

这样是不是更好了？现在 `mix` 只占了单独的一样，函数结构也更加的清晰——但是这样做不符合我的胃口，它的语法干扰实在是太多了。在现在的 `composeMixins()` 中，我觉得描述一个函数在哪结束、另一个函数从哪开始还不够清楚。

除了调用函数体之外，`funcion` 这个关键字似乎和其它的代码**混淆**在一起了。我的函数的真正的功能被**隐藏**了起来！参数的调用和函数体的起始到底在哪里？如果我仔细看也能够分析出来，但是它对我来说实在是不容易阅读。

那么如果我们去掉 `function` 这个关键字，然后通过一个**大箭头** `=>` 指向返回值来代替 `return` 关键字，避免它们和其它关键部分混在一起，现在会怎么样呢？

我们当然可以这么做，代码会是这样的：

```
const composeMixins = (...mixins) => (
  instance = {},
  mix = pipe
) => mix(...mixins)(instance);
```

现在应该可以很清楚这段代码做了什么事了。`composeMixins()` 是一个函数，它传入了任意数量的 `mixins`，最终会返回一个得到两个额外参数（`instance` 与 `mix`）的函数。它返回了通过 `mixins` 管道组合的 `instance` 的结果。

还有一件事……如果我们对 `pipe()` 进行同样的优化，可以神奇地将它写到一行中：

```
const pipe = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x);
```

当它在一行内被定义的时候，将它抽象成一个函数这件事反而变得不那么明了了。

另外请记住，这个函数在 Lodash、Ramda 以及其它库中都有用到，但是仅仅为了用这个函数就去 import 这些库并不是一件划得来的事。

那么我们自己写一行这个函数有必要吗？应该有的。它实际上是两个不同的函数，把它们分开会让代码更加清晰。

另一方面，如果将其写在一行中，当你看参数命名的时候，你就已经明了了其类型以及用例。我们将它写在一行，就如下面代码所示：

```
const composeMixins = (...mixins) => (
  instance = {},
  mix = (...fns) => x => fns.reduce((acc, fn) => fn(acc), x)
) => mix(...mixins)(instance);
```

现在让我们回头看看最初的函数。无论我们后面做了什么调整，**我们都没有丢弃任何本来就有的信息**。并且，通过在行内声明变量和默认值，我们还给这个函数**增加了信息量**，描述了这个函数是怎么使用的以及参数值是什么样子的。

ES5 版本中增加的额外的代码其实都是语法干扰。这些代码对于**熟悉**柯里化箭头函数的人来说**没有任何有用之处**。

只要你熟悉柯里化箭头函数，你就会觉得最开头的代码更加清晰并具有**可读性**，因为它没有多余的语法糊弄人。

柯里化箭头函数还能**减少错误的藏身之处**，因为它能让 bug 隐藏的部分更少。我猜想，在传统函数表达式中一定隐藏了许多的 bug，一旦你升级使用箭头函数就能找到并排除这些 bug。

我希望你的团队也能支持、学习与应用 ES6 的更加简洁的代码风格，提高工作效率。

有时，在代码中详细地进行描述是正确的行为，但通常来说，代码越少越好。如果更少的代码能够实现同样的东西，能够传达更多的信息，不用丢弃任何信息量，那么它**明显**更加优越。认知这些不同点的关键就是看它们表达的信息。如果加上的代码没有更多的意义，那么这种代码就不应该存在。这个道理很简单，就和自然语言的风格规范一样（不说废话）。将这种表达风格规范应用到代码中。拥抱它，你将能写出更好的代码。

一天过去，天色已黑，仍然有其它推特的回复在说 ES6 版本的代码更加缺乏可读性：

[![Markdown](http://i2.muimg.com/1949/4287b75aa0b58a9d.png)](https://twitter.com/blakenewman)

我只想说：是时候熟练去掌握 ES6、柯里化与组合函数了。

### 下一步 ###

[“与 Eric Elliott 一起学习 JavaScript”](https://ericelliottjs.com/product/lifetime-access-pass/)会员现在可以看这个大约 55 分钟的视频课程——[ES6 柯里化与组合](https://ericelliottjs.com/premium-content/es6-curry-composition/)。

如果你还不是我们的会员，你可会遗憾地错过这个机会哦！

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/) 

### 作者简介

***Eric Elliott*** 是 O'Reilly 出版的[*《Programming JavaScript Applications》*](http://pjabook.com)书籍、[“与 Eric Elliott 学习 JavaScript”](http://ericelliottjs.com/product/lifetime-access-pass/)课程作者。他曾经帮助 Adobe、莱美、华尔街日报、ESPN、BBC 进行软件开发，以及帮助 Usher、Frank Ocean、Metallica 等著名音乐家做网站。

最后~~喂狗粮~~：

**他与世界上最美丽的女人在旧金山湾区共度一生。**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
