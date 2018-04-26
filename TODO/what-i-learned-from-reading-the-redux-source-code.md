> * 原文地址：[What I learned from reading the Redux source code](https://medium.freecodecamp.org/what-i-learned-from-reading-the-redux-source-code-836793a48768)
> * 原文作者：[Anthony Ng](https://medium.freecodecamp.org/@newyork.anthonyng?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/what-i-learned-from-reading-the-redux-source-code.md](https://github.com/xitu/gold-miner/blob/master/TODO/what-i-learned-from-reading-the-redux-source-code.md)
> * 译者：[缪宇](https://juejin.im/user/57df39fca0bb9f0058a3c63d/posts)
> * 校对者：[anxsec](https://github.com/anxsec) [轻舞飞扬](https://github.com/FateZeros)

# 我们能从 Redux 源码中学到什么？

![](https://cdn-images-1.medium.com/max/2000/1*BpaqVMW2RjQAg9cFHcX1pw.png)

我总是听人说，想拓展开发者自身视野就去读源码吧。

所以我决定找一个高质量的 JavaScript 库来深入学习。

我选择了 [Redux](https://github.com/reactjs/redux)，因为它的代码比较少。

这篇文章不是 Redux 教程，而是阅读源码后的收获。如果你对学习 Redux 感兴趣，强烈推荐你去看 [Redux 教程](https://egghead.io/courses/getting-started-with-redux)，这个系列文章是 Redux 的作者 Dan Abramov 写的。

### 从源码中学习

一些新来的开发者经常问我，怎样才是最好的学习方式？我往往会告诉他们在项目中学习。

当你构建一个项目来实践你的想法时，由于你对它的热爱，会让你度过难熬的 debug 阶段，即使遇到困难也不会放弃。这是一个非常神奇的现象。

但是一个人闭门造车也是有问题的。你不会注意到你开发过程中的坏习惯，你也学不到任何最优的解决方案。你可能都不知道又出了哪些新的框架和技术。在独自写项目的过程中，你很快会发现你的技能达到瓶颈。

只要有可能，我建议你找些小伙伴和你一起开发。

试想一下，坐在你旁边的小伙伴（如果你够幸运，他恰好是个大神），你可以观察他思考问题的过程。你可以看他是如何敲代码的。你可以看他是如何解决算法问题的。你可以学到新的开发工具和快捷键。你会学到许多你一个人开发时学不到的东西。

![](https://cdn-images-1.medium.com/max/800/1*p7CG3FIp5uxS5GYkJnPJzw.jpeg)

斯特拉迪瓦里小提琴。

我用斯特拉迪瓦里的小提琴举个例子。斯特拉迪瓦里小提琴以出色的音质闻名世界，在业界可以说是一枝独秀。许多人尝试用各种方法去解释为什么它这么牛逼，从古老教堂抢救出来的木材到特殊的木材的防腐剂。许多人想要复制一把斯特拉迪瓦里小提琴，结果都失败了，因为他们不知道安东尼·斯特拉迪瓦里到底是怎么做的。

设想一下，如果你和安东尼·斯特拉迪瓦里在一个房间里工作，那么所有的独门秘籍你都可以学到。

这下你知道该如何与你的开发小伙伴相处了吧。你只需要安静的坐他旁边，看着他写出一行行斯特拉迪瓦里式的代码。

对于与多人来说，协同编程是一个很好的机会，可以通过别人的代码学到很多东西。

阅读高质量的代码就像读一本精彩的小说一样，比起直接和作者交流，你可能理解起来比较困难。但是你可以通过看注释和代码，获取到有价值的信息。

对于那些认为看源码没什么用的的同学，你可以去看一个故事，一个叫比尔·盖茨的高中生，为了了解某个公司的机密，他甚至去翻人家的垃圾桶找源码。

如果你也可以像比尔·盖茨那样不厌其烦的看源码，那还在等什么？找一个 github 仓库，看源码吧！

![](https://cdn-images-1.medium.com/max/800/1*ZUdEQv1ZgNGknJuzof9SDQ.jpeg)

咦，源码呢？

阅读源码的同时，你也可以去看官方文档，官方文档的结构就像作者写的代码一样，写得好的官方文档就让你仿佛坐在作者旁边一样。你也可以在上面看到别人遇到的问题。官方文档中的超链接提供了丰富的扩展阅读的资源。在评论区你还可以和大神一起交流。

平时我也会在 YouTube 看别人写代码，我推荐大家去看[SuperCharged  直播写代码系列](https://www.youtube.com/watch?v=rBSY7BOYRo4)，来自 Google Chrome 开发者的 Youtube 频道。看两个 Google 工程师直播写一个项目，看他们是如何处理性能问题的，和大家一样，他们也会被自己拼写错误导致的 bug 卡住。

### 读 Readux 源码的收获

#### ESLint

Linting 用于检查代码，发现潜在的错误。它帮助我们保持代码风格的一致性和整洁。你可以自己定制规则，也可以用预设的规则（比如 Airbnb 提供的规则）。

Linting 在团队开发中特别有用。它让所有代码看起来像一个人写的。它可以强迫开发人员按照公司的代码风格来写代码（同事不用在阅读代码上花太多时间）。

Linters 不仅仅是为了美观，它会让你的代码更符合语言特性。比如它会告诉你什么时候使用 “const” 关键字来处理那些没有被重新赋值的变量。

如果你使用了 React 插件，它会警告你关于组件可以被重构成无状态的函数式组件。也是可以让你学习 ES6 语法，告诉你的某段代码可以用语法新特性来写。

在你的项目中轻松使用 ESlint：

1. 安装 ESlint。

```
$ npm install --save-dev eslint
```

2. 配置 ESlint。

```
./node_modules/.bin/eslint --init
```

3. 在你的 package.json 文件中设置 npm 脚本来运行你的 Linter（可选）。

```
"scripts": {
  "lint": "./node_modules/.bin/eslint"
}
```

4. 运行 Linter.

```
$ npm run lint
```

查看[它们的官方文档](http://eslint.org/docs/user-guide/getting-started)，了解更多。

许多编辑器也有插件来检查你的代码。

有些时候 Linter 会对一些正确的代码报错，比如 console.log。你可以告诉 Linter 忽略这行代码，不对其进行检查。

在 ESlint 中忽略检查，你可以这样写代码注释：

```
// 忽略一行
 console.log(‘Hello World’); // eslint-disable-line no-console
// 忽略多行
 /* eslint-disable no-console */
 console.log(‘Hello World’);
 console.log(‘Goodbye World’);
 /* eslint-enable no-console */
```

#### 检查代码是否被压缩了

在源码中我发现一个 “isCrushed()” 的空函数，很奇怪。

后来我发现它的目的是为了检查代码是否被压缩了。在代码压缩过程中，函数名字和变量会被缩写。当你在开发的时候如果使用了压缩后的代码，如果一个条语句被检测到仍然有 “isCrushed()” 存在，就会有警告提示。

#### 不要害怕报错

在学习 Redux 源码之前我很少在代码中抛异常。JavaScript 是一个弱类型，所以我们不知道函数中传入参数的类型。所以我们必须要像强类型语言那样对于错误要抛出异常。

使用 `try…catch…finally` 语句来抛出异常。这样做可以方便你 debug，以及理清代码逻辑。

在控制台中产生的错误，可以很方便堆栈跟踪。

![](https://cdn-images-1.medium.com/max/800/1*03Y3lQPmF8Hl1pNMvm4Fsg.png)

很有用的栈跟踪。

做异常信息处理让你的代码逻辑清晰。比如，如果有一个 "add()" 函数，只允许传入数字，如果传入的不是数字就要抛出异常。

```
function add(a, b) {
    if(typeof a !== ‘number’ || typeof b !== ‘number’) {
	throw new Error(‘Invalid arguments passed. Expected numbers’);
    }
    return a + b;
}
var sum = add(‘foo’, 2); 
// 抛出异常后会终止代码执行
```

#### 组合函数

源码中有一个 “compose()” 函数，根据已有的函数构建出新的函数:

```
 function compose(…funcs) {
   if (funcs.length === 0) {
     return arg => arg
   }
   if (funcs.length === 1) {
     return funcs[0]
   }
   const last = funcs[funcs.length — 1]
   const rest = funcs.slice(0, -1)
   return (…args) => rest.reduceRight((composed, f) => f(composed),    last(…args))
 }
```

如果我有两个已知的 square 函数和另一个 double 函数，我可以把它们组成一个新函数。

```
 function square(num) {
   return num * num;
 }
function double(num) {
   return num * 2;
}
function squareThenDouble(num) {
   return compose(double, square)(num);
}
console.log(squareThenDouble(7)); // 98
```

如果我没看过 Redux 的源码，我都不知道还有这种犀利的操作。

#### 原生方法

当我在看 “compose” 函数的时候，我发现了一个原生数组方法 “reduceRight()”，我之前都没听到过。这让我想知道还有多少我没听过的原生方法。

我们来看一个代码片段，一个使用了原生数组方法 “filter()”，一个没有，通过对比看原生方法存在的价值。

```
 function custom(array) {
   let newArray = [];
   for(var i = 0; i < array.length; i++) {
     if(array[i]) {
       newArray.push(array[i]);
     }
   }
   return newArray;
 }
 function native(array) {
   return array.filter((current) => current);
 }
 const myArray = [false, true, true, false, false];
 console.log(custom(myArray));
 console.log(native(myArray));
```

你可以看到使用 “filter()” 会让你的代码变得简洁。更重要的是，避免了重复造轮子。“filter()” 会被使用上百万次，比起你自己造轮子，可以避免很多 bug。

当你想造轮子的时候，先看看你的问题是否已经被原生方法解决了。你会惊喜的发现有非常多的实用方法在你用的编程语言中。（比如，可以看看 Ruby 的数组的重新排列的[方法](https://ruby-doc.org/core-2.2.0/Array.html#method-i-repeated_permutation)）

#### 描述性的函数名

在源码中，我看到了许多有很长名字的函数。

1.  getUndefinedStateErrorMessage
2.  getUnexpectedStateShapeWarningMessage
3.  assertReducerSanity

虽然这函数名读起来会让你的舌头打结，但你可以清楚的知道这个函数是做什么的。

在你的代码中使用描述性的函数名，让你更多的是读代码而不是写代码，别人也可以很轻松的阅读你的代码。

用较长的描述性函数名带来的好处远超过敲击键盘所带来的快感。现代的文本编辑器都有自动补全功能，它可以帮助你输入，所以没有理由再使用类似 “x” 或者 “y” 的变量名。

#### console.error vs. console.log

不要总是使用 console.log，如果你要抛出异常，请使用 console.error，你可以在 console 中看到红色的打印内容和栈的跟踪。

![](https://cdn-images-1.medium.com/max/800/1*1N-RGnFLtEhcuS9QTCF56w.png)

console.error()

查看 console [文档](https://developer.mozilla.org/en-US/docs/Web/API/Console)，看看其他的方法。比如计算运行时间的计时器（console.time()）,用表格方式打印信息（console.table()），等等。

* * *

不要害怕去读源代码。你肯定会学到一些东西，甚至可以为它贡献代码。

在评论中分享你在阅读源码中的收获吧！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
