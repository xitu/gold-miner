> * 原文地址：[Getting creative with the Console API!](https://areknawo.com/getting-creative-with-the-console-api/)
> * 原文作者：[Areknawo](https://areknawo.com/author/areknawo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/getting-creative-with-the-console-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/getting-creative-with-the-console-api.md)
> * 译者：[wznonstop](https://github.com/wznonstop)
> * 校对者：[Tammy-Liu](https://github.com/Tammy-Liu), [ezioyuan](https://github.com/ezioyuan)

# 创意运用 Console API！

在 Javascript 中 **[Console API](https://developer.mozilla.org/en-US/docs/Web/API/Console)** 和 **Debugging** 总是密不可分的，其大多通过 `console.log()` 的方式使用。然而，你知道它不仅仅只有这种使用方法吗？你是否也已经对 `console.log()` 的**单一**输出方式感到厌倦了呢？你是否也想让你的 log 更出色更**优美**吗？ 💅 如果你的你的答案是肯定的话，跟随我，让我们一起发现 Console API 真正的多姿多彩和趣味性！

## [Console.log()](https://developer.mozilla.org/en-US/docs/Web/API/Console/log)

无论你是否相信，`console.log()` 本身还是有一些你可能不知道的额外功能。当然，她的基础目的 — **logging** — 是不变的。我们唯一能做的就是使它更加出色。让我们尝试一下怎么样？ 😁

### String subs

与 `console.log()` 这一方法紧密相关的唯一事情是你可以将它与所谓的 **字符串替换** 一同使用。这基本上就是为你提供了使用字符串特定表达式的选项，然后将其替换为提供的参数。它看起来有点像这样：

```
console.log("Object value: %o with string substitution",
    {string: "str", number: 10});
```

是不是很棒呢？关键是字符串替换表达式有多种变化：

*   **%o / %O** — 用于对象;
*   **%d / %i** — 用于整数;
*   **%s** — 用于字符串;
*   **%f** — 用于浮点数;

但是，看了上面这些，你可能要问，为什么要使用这样一个特征？尤其是当你可以简单的传递多个值给 log 的时候，如下所示：

```
console.log("Object value: ",
    {string: "str", number: 10},
    " with string substitution");
```

此外，对于字符串和数字，你可以只使用 **字符串字面值**！那么，有什么问题呢？首先，我将讲一下当你做一些不错的 console log 时，你只需要一些不错的字符串，log subs 可以允许你轻松做到这一点。至于上文所讲的字符串替换 — 你必须认同的是 — 你需要睁大眼睛看看这些空间。🛸 使用 subs，它更方便。至于字符串字面值，他们并没有像这些 subs 一样长（惊喜！🤯），并且他们不会为对象提供相同的，良好的格式。但是，只要你只使用数字和字符串，你可能更倾向于 **一个不同的方法**。

### CSS

我们再学一种以往尚未学过的类子字符串编译指令，就是 **%c**，它允许你应用 **css 风格的** 字符串去记录信息！😮 让我来为你们展示下如何使用！

```
console.log("Example %cCSS-styled%c %clog!",
    "color: red; font-family: monoscope;",
    "", "color: green; font-size: large; font-weight: bold");
```

上面的例子是 %c 指令的广泛应用。正如你所见到的那样，样式应用于处在该编译指令 **后面** 的所有内容，除非你使用其他的编译指令，而这是我们正要做的。如果你使用普通的无样式的 log 格式，你将需要传递一个空字符串。不言而喻，这个提供给 %c 编译指令和子字符串的值需要按照预期的顺序一个一个地提交给下一步的参数。 😉

## Grouping & tracing

我们已经在 log 中引入了 CSS，这仅仅只是一个开始，那么 Console API 还有哪些秘密呢？

### Grouping

加入过多的 console log 并不是很健康，它可能导致更糟糕的可读性，从而出现无意义的 log 的情形。然而适当地建立一些 **结构** 总是好的。你可以通过使用 `[console.group()](https://developer.mozilla.org/en-US/docs/Web/API/Console/group)` 的方法精准地实现。通过使用该方法，你可以在 console group 中创建深层次的、可折叠的结构，这允许你隐藏并组织你的 log。如果你希望在默认情况下将 log group 折叠，还有一个方法是使用 `[console.groupCollapsed()](https://developer.mozilla.org/en-US/docs/Web/API/Console/groupCollapsed)`。当然，console group 可以根据你的需要进行嵌套（就像你想的那样）。你还可以通过向其传递参数列表来使得你的 log group 具有类 header-log（就像使用 console.log()）。在调用 log group 方法后完成，每个控制台调用都将在创建的组中找到它的位置。要退出的话，需要使用一个特殊的方法叫做 `[console.groupEnd()](https://developer.mozilla.org/en-US/docs/Web/API/Console/groupEnd)`。很简单，对吗？😁

```
console.group();
console.log("Inside 1st group");
console.group();
console.log("Inside 2nd group");
console.groupEnd();
console.groupEnd();
console.log("Outer scope");
```

我想你已经注意到，你只需将所有提供的代码段中的代码 复制并粘贴 到你的控制台，然后以你想要的方式使用它们！

### Tracing

另外一个关于 Console API 的有用的信息是获取当前调用的路径（**执行路径**/**堆栈跟踪**）。你知道吗，代码列表通过放置了被执行的链接（例如函数链接）去获取当前的调用 `[console.trace()](https://developer.mozilla.org/en-US/docs/Web/API/Console/trace)`，这也正式是我们所谈论的方法。无论是检测副作用还是检查代码流，这些信息都非常有用。只需将下面的代码放到你的代码中，你就明白我说的意思啦。

```
console.trace("Logging the way down here!");
```

## Console.XXX

你可能已经了解了一些关于 Console API 的不同方法。我将要讲的这些能够给你的 logs 增添一些 **额外的信息**。让我们快速的概括一下它们，好吗？

### Warning

`[console.warn()](https://developer.mozilla.org/en-US/docs/Web/API/Console/warn)` 这一方法操作起来就像 console.log（就像大多数这些 logging 方法一样）。但是，它还具有 **类似警告的样式**。⚠ 在大多数浏览器中，它应该是 **黄色** 的并且在有一个警告符号（出于自然因素）。默认情况下，对此方法的调用也会返回跟踪，因此你可以快速找到警告（以及可能的错误）的来源。

```
console.warn("This is a warning!");
```

### Error

`[console.error()](https://developer.mozilla.org/en-US/docs/Web/API/Console/error)`这一方法与 console.warn() 输出具有堆栈跟踪的消息类似，具有特殊的样式。它通常是 **红色** 的，添加了错误图标。❌ 它清楚地通知用户某些事情是不对的。一个重要的知识点是 .error（）这个方法输出的只是一个没有任何附加选项的控制台消息，类似于停止代码执行（为此你需要抛出一个错误）。它 **只是一个简单的说明**，因为许多新使用者可能会对这种操作感到有些不确定性。

```
console.error("This is an error!");
```

### Info & debug

还有两种方法可用于向 logs 添加一些指令：`[console.info()](https://developer.mozilla.org/en-US/docs/Web/API/Console/info)` 和 `[console.debug()](https://developer.mozilla.org/en-US/docs/Web/API/Console/debug)`。 🐞 运用这两种方式输出的内容并不总是具有独特的风格，在某些浏览器中它只是一个信息图标。这些和上文提及的其他方法都允许你在你的控制台消息中应用某一特定的类别。在不同的浏览器中（例如基于 Chromium 的浏览器中），dev-tools UI 为你提供了选项，可以选择显示的特定类别的 log，例如错误，调试消息或信息。这只是一个组织功能！

```
console.info("This is very informative!");
console.debug("Debugging a bug!");
```

### Assert

还有一个特别的 Console API 方法，它为你在任何条件下进行 log（**断言**）提供了捷径。它就是 `[console.assert()](https://developer.mozilla.org/en-US/docs/Web/API/Console/assert)`。就像标准的 console.log() 方法一样，它可以采用无数个参数，不同的是它的第一个参数需要是布尔值。如果它解析为 true，则断言不会被 log，否则，它会将错误和传入的参数在控制台中 log 出来（与 .error（）方法相同）。

```
console.assert(true, "This won't be logged!");
console.assert(false, "This will be logged!");
```

而且，在使用大量的 log 方法之后，你可能希望让你的控制台消息板看起来更整洁一些。没问题！只需使用 `[console.clear()](https://developer.mozilla.org/en-US/docs/Web/API/Console/clear)` 这一方法，即可看到所有之前 log 的信息消失！这是一个非常有用的功能，它甚至在大多数浏览器的控制台界面中都有自己的按钮（和快捷方式）！

## Timing

Console API 甚至提供了一组与定时器相关的功能。⌚ 在他们的帮助下，你可以对部分代码快速地进行性能测试。正如我之前所说，这个 API 很简单。你可以使用这一方法 `[console.time()](https://developer.mozilla.org/en-US/docs/Web/API/Console/time)`，将可选参数作为标签或者 id 赋给定时器。当你进行调用的时候定时器便启动了。然后你可以使用 `[console.timeLog()](https://developer.mozilla.org/en-US/docs/Web/API/Console/timeLog)` 和 `[console.timeEnd()](https://developer.mozilla.org/en-US/docs/Web/API/Console/timeEnd)` 这两种方法（带有可选的标签参数）来 log 你的时间（以毫秒为单位）以及结束定时器。

```
console.time();
// code snippet 1
console.timeLog(); // default: [time] ms
// code snippet 2
console.timeEnd(); // default: [time] ms
```

当然，如果你正在进行一些真正的基准测试或性能测试，我建议使用专门为此目的而设计的 **[Performance API](https://developer.mozilla.org/en-US/docs/Web/API/Performance_API)**。

## Counting

如果你有很多的 log，而你不知道这部分被执行的代码出现了多少次 log，你已经猜到了！接下来这个 API 可以解决这个问题！`[console.count()](https://developer.mozilla.org/en-US/docs/Web/API/Console/count)` 这一方法可能是最基础的东西，它可以计算被调用的次数。当然，你可以传递一个可选参数作为计数器的标签（设定默认值）。稍后，你可以使用 `[console.countReset()](https://developer.mozilla.org/en-US/docs/Web/API/Console/countReset)` 这一方法重置所选计数器。

```
console.count(); // default: 1
console.count(); // default: 2
console.count(); // default: 3
console.countReset();
console.count(); // default: 1
```

就个人而言，我没有看到很多对这个特殊功能的运用，但这样的方法存在总是好的。也许只是我的一己之见...

## Tables

我认为这是 Console API 最被低估的功能之一（超过之前提到的 CSS 样式）。👏 当调试和检查平面或二维对象和数组时，向控制台输出真实的、可排序的表格这一能力是非常有用的。是的，你真的可以在控制台中显示一个表格。它只需使用带有一个参数的简单调用 `[console.table()](https://developer.mozilla.org/en-US/docs/Web/API/Console/table)`，该参数很可能是对象或数组（原始值通常只是正常的 log，超过 2 维结构将被截断为较小的对应物。只需试一下如下的代码来来看一下我想表达的意思！

```
console.table([[0,1,2,3,4], [5,6,7,8,9]]);
```

## Console ASCII art

如果没有 ASCII art，console art 就不一样了！借助 **[image-to-ascii](https://github.com/IonicaBizau/image-to-ascii)** 模块（可以在 **[NPM](https://www.npmjs.com/package/image-to-ascii)** 上找到），你可以轻松地将普通图像转换为 ASCII 对应模块！🖼 除此之外，该模块还提供了许多可自定义的设置和选项，用以创建你所需的输出。以下是使用该库的简单示例：

```
import imageToAscii from "image-to-ascii";

imageToAscii(
"https://d2vqpl3tx84ay5.cloudfront.net/500x/tumblr_lsus01g1ik1qies3uo1_400.png",
{
    colored: false,
}, (err, converted) => {
    console.log(err || converted);
});
```

使用上面的代码，你可以创建令人惊叹的 JS 徽标，就像你现在在控制台中创建的徽标一样！ 🤯

借助 CSS 样式，一些填充和背景属性，你也可以将完整的图像输出到控制台！例如，你可以查看 **[console.image](https://github.com/adriancooney/console.image)** 模块（也可以在 **[NPM](https://www.npmjs.com/package/console.image)** 上使用）来使用此功能。但是，我认为 ASCII 更加时尚。 💅

## Modern logs

如你所见，你的 logs 和调试过程整体上不必如此单调！除了简单的 console.log() 之外，还有更多的好方法。有了这篇文章中的知识，选择权现在就在你的手里！你可以使用传统的 console.log() 这一方法和你的浏览器提供的各种精美款样式的结构，或者你可以使用上文描述的技巧为你的控制台增添一些新意。浏览器提供的不同结构的传统和精美格式，或者你可以使用上述技术为控制台添加一些新鲜感。无论如何，即使你正在和讨厌的 bug 🐞 斗争，你也要找到其中的乐趣！

我希望你喜欢这篇文章，它可以让你学到新东西。和往常一样，可以考虑与他人分享，让每个人都可以让他们的控制台充满色彩 🌈 ，并通过反馈或评论将你的意见留在下面！此外，请关注我的 **[Twitter](https://twitter.com/areknawo)** 和 **[Facebook](https://www.facebook.com/areknawoblog)** 上，并注册 newsletter（即将登场）！再次，感谢阅读，希望在下一篇文章中依旧看到你的身影！✌

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
