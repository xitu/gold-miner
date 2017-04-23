> * 原文地址：[Putting comments in code: the good, the bad, and the ugly.](https://medium.freecodecamp.com/code-comments-the-good-the-bad-and-the-ugly-be9cc65fbf83)
> * 原文作者：[Bill Sourour](https://medium.freecodecamp.com/@BillSourour?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [bambooom](https://github.com/bambooom)
> * 校对者：

# 代码中添加注释之好坏丑

![](https://cdn-images-1.medium.com/max/1000/1*ddM-OL7PF36NZ6QYCa95bQ.jpeg) 

题图是克林特 · 伊斯特伍德在《黄金三镖客》中。


如果你以前听过这句话就打断我...

> 「好的代码自身就是文档」。

在我 20 多年以写代码为生的经历中，这是我听得最多的一句话。

**陈词滥调**。

像其他许多陈词滥调一样，它的核心是一个真理。但是这个真理已经被滥用，大多数说出这句话的人并不知道它实际上是什么意思。

这句话正确吗？**是的**。

那是不是意味着你不应该给你的代码写注释？**不是**。

本文中，我们将介绍一下给代码写注释的好处、坏处和丑处。（？）

初学者需要了解，实际上有两种不同类型的代码注释，我称之为**文档注释**和**说明性注释**。

### 文档注释 ###

文档注释是为了给任何可能使用你的源代码的人看的，但他们不一定可以完全通读代码。如果你正在构建给其他开发者使用的库或框架，你需要某种形式的 API 文档。

源代码中 API 文档越少，越有可能变得过时或不准确。减少这种情况的一个好策略就是直接将文档嵌入代码中，之后再使用工具提取文档。

下面是一个文档注释的例子，来自一个流行的 JavaScript 库，叫做 [Lodash](https://lodash.com)。

```javascript
/**
     * Creates an object composed of keys generated from the results of running
     * each element of `collection` thru `iteratee`. The corresponding value of
     * each key is the number of times the key was returned by `iteratee`. The
     * iteratee is invoked with one argument: (value).
     *
     * @static
     * @memberOf _
     * @since 0.5.0
     * @category Collection
     * @param {Array|Object} collection The collection to iterate over.
     * @param {Function} [iteratee=_.identity] The iteratee to transform keys.
     * @returns {Object} Returns the composed aggregate object.
     * @example
     *
     * _.countBy([6.1, 4.2, 6.3], Math.floor);
     * // => { '4': 1, '6': 2 }
     *
     * // The `_.property` iteratee shorthand.
     * _.countBy(['one', 'two', 'three'], 'length');
     * // => { '3': 2, '5': 1 }
     */
    var countBy = createAggregator(function(result, value, key) {
      if (hasOwnProperty.call(result, key)) {
        ++result[key];
      } else {
        baseAssignValue(result, key, 1);
      }
    });
```

如果你[将这些注释与他们的线上文档做对比](https://lodash.com/docs/#countBy)，你会发现它们完全一致。

如果你开始使用文档注释，则需要确保遵循一致的标准，并且使它们与其他说明性的注释可以轻易区分开。一些广泛使用、有良好支持的标准和工具包括 JavaScript 的 [JSDoc](http://usejsdoc.org)，dotNet 的 [DocFx](https://github.com/dotnet/docfx)，Java 的 [JavaDoc](http://www.oracle.com/technetwork/java/javase/documentation/index-jsp-135444.html)。

这种注释的缺点就是使你的代码非常「嘈杂」，并使得积极参与维护的人更难阅读代码。好消息是，大多是代码编辑器都支持「代码折叠」的功能，这样就可以折叠这部分注释，专注在代码上。

![](https://cdn-images-1.medium.com/max/800/1*o9d-IZKFtlHf4ycY_n4H2Q.gif) 

上图演示在 Visual Studio Code 中折叠注释。

### 说明性注释 ###

说明性注释是给任何可能需要维护、重构或扩展你的代码的人（包括你自己）看的。

通常来说，说明性注释是一种代码警示（？）。它告诉你，你的代码太复杂了。你应该尽量简化代码并删除这种注释，因为「好的代码自身就是文档」。

以下是一个不好的 —— 虽然很有趣 —— 说明性注释的[例子](http://stackoverflow.com/a/766363)。

```
/* 
 * Replaces with spaces 
 * the braces in cases 
 * where braces in places 
 * cause stasis.
 * (将大括号替换为空格，如果大括号造成停滞)
**/ 
$str = str_replace(array("\{","\}")," ",$str);
```

如果作者不花时间在使用韵脚诗装点这个稍微令人疑惑的代码，肯定可以将代码本身写的更加易读易懂。也许使用函数名，`removeCurlyBraces` 在另一个函数 `sanitizeInput` 中调用？

不要会错意，的确有不少时候 —— 特别当你正在拼命应对繁重的工作时 —— 注入一些幽默对身心都有好处。但是当你写了一个有趣的注释来修饰不好的代码时，实际上人们不太可能稍后重构或修复代码。

你真的想为掠夺所有未来程序员阅读这首聪明的押韵诗的乐趣而负责吗？大多数的程序员会笑起来，而忽略了这段代码本身的问题。

你也会遇到多余的注释。如果代码已经足够简单明了，就不需要再添加注释了。

比如说，不要做下面这种毫无意义的事：

```
/*
将年龄的整数值设为 32
*/
int age = 32;
```

不过，有时候，无论你对代码本身做了什么，一个说明性注释还是需要的。

通常这发生在，你需要添加一些上下文解释非直观的解决方法。

以下是一个来自 Lodash 的很好的例子：

```javascript
function addSetEntry(set, value) {   
  /* 
   Don't return `set.add` because it's not chainable in IE 11.
   不要返回 `set.add`，因为它在 IE 11 中不可链接。
  */  
  set.add(value);    
  return set;  
}
```

也有一些情况是 ，在经过很多思考和实验后 ，看上去天真的解决方法事实上是最好的。在这些情况下，其他的程序员会不可避免地认为他们更聪明并开始自己动手实践，最后却发现你的方法是最好的。

有时上面提到的其他程序员就是未来的你自己。

在这些情况下，最好的做法就是写下注释，节省所有人的时间，避免尴尬。

[以下这个注释](http://stackoverflow.com/a/482129)完美地诠释了这种情况：

```
/**
Dear maintainer:
亲爱的维护者：

Once you are done trying to 'optimize' this routine,
and have realized what a terrible mistake that was,
please increment the following counter as a warning
to the next guy:
只要你完成了尝试「优化」这部分代码，
并意识到这是个多么大的错误时，
请给下面的计数器加一以给下一个人警告：

total_hours_wasted_here = 42
**/
```

当然，上面的例子更多是有趣，而不是有帮助。但是你**应该**留下注释，警告其他人不要追求一些看似明显的「更好的解决方法」，因为你已经尝试过并否决了。当你这样做的时候，应该明确指出你尝试了哪些方案，为什么否决了这些方案。

以下是一个 JavaScript 中的简单例子：

```javascript
/* 
don't use the global isFinite() because it returns true for null values
不要使用全局 isFinite()，因为它对 null 值会返回 true.
*/
Number.isFinite(value)
```

### 丑处 ###

我们介绍了好处、坏处，那么丑处呢？

有时候你会感到沮丧，特别当你为谋生而写代码时，在代码注释中你倾向于将这种沮丧的情绪发泄出来。

使用过很多的代码库后，你会见到各种各样愤世嫉俗、沮丧到黑暗或意味深长的注释。

像这种[看似无害的东西](http://stackoverflow.com/a/185550)...

```
/*
This code sucks, you know it and I know it.  
Move on and call me an idiot later.
这段代码很糟糕，你知道，我也知道。
继续往前，之后再叫我白痴。
*/
```

...到[彻底的意思？](http://stackoverflow.com/a/184673)

```
/* 
Class used to workaround Richard being a f***ing idiot
这部分以前是 Richard 的工作，他是个白痴
*/
```

这些可能看起来很有趣，或者在当时帮助你发泄了一部分情绪。但是当你把它们变成生产环境代码时，它们使得编写它们的程序员以及他们的雇主看起来不专业和苦大仇深似的。

不要这么做。


如果你喜欢这篇文章，请在这篇文章下方戳一下 ❤ 点个赞，帮助我传播。如果你想阅读更多其他的文章，欢迎登记订阅我每周的 Dev Mastery 简报。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
