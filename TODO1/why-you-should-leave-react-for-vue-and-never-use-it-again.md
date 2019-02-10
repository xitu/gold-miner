> * 原文地址：[Why I left React for Vue.](https://blog.sourcerer.io/why-you-should-leave-react-for-vue-and-never-use-it-again-5e274bef27c2)
> * 原文作者：[Gwenael P](https://blog.sourcerer.io/@gwenael.pluchon?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-leave-react-for-vue-and-never-use-it-again.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-leave-react-for-vue-and-never-use-it-again.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[luochen1992](https://github.com/luochen1992)，[Moonliujk](https://github.com/Moonliujk)

# 为什么我放弃了 React 而转向 Vue。

![](https://cdn-images-1.medium.com/max/2000/1*QIg6vEjZmT5YMVKU5Rxr2A.png)

[今日随机的开源者个人简介：https://sourcerer.io/posva]

最近，在 Github 上 Vue.js 比 React 获得更多的 star。该框架受欢迎程度近期飙升，并且由于它并没有类似于 Facebook（React）或者 Google（Angular）这样的公司支持，看到它从不知名的地方崛起，着实让人惊讶。

### 网页研发的进化

回顾过去的光辉岁月，在 90 年代时，我们写网页，就是纯 HTML，以及一些简单的 CSS 样式。好处就是非常简单。但缺点是许多功能的缺失。

然后有了 PHP，能写像这样的代码，我们很开心了：

![](https://cdn-images-1.medium.com/max/800/1*0QbOoPYacDrJjETxbhHMmw.jpeg)

来源：[https://www.webplanex.com/blog/php-good-bad-ugly-wonderful/](https://www.webplanex.com/blog/php-good-bad-ugly-wonderful/)

这些在现在看来简直可怕，但是在那个时候，已经是很惊人的进步了。这是它的全部意义所在：使用新的语言，框架，还有工具，我们热衷于此，直到竞争对手做得远远更好的那一天。

在 React 如此流行之前，我使用的是 Ember。然后我转到了 React，它将我们所需要的开发抽象为网页组件，它使用虚拟 DOM 并且高效渲染，这些非常棒的方法都让我觉得眼前一亮。虽然对于我来说并不是十全十美的，但是相比于之前我写代码的方式，它已经有了巨大的进步。

**之后，我决定尝试 Vue.js，再之后我将不会回头使用 React 了。**

虽然 React 不是糟糕透了，但我发现它很笨重，难以管理，并且有时候我写的代码对于我来说看上去简直毫无逻辑可言。发现了 Vue 并知道了它是如何解决了它老哥 React 的一些问题，对我来说真是一种解脱。

让我来解释一下原因吧。

### 性能

首先，我们来讨论一下体积。

由于所有 web 开发者的工作都需要考虑网络带宽，所以限制网页大小就很重要。网页越小越好。现在，随着移动端浏览量快速上升，这一点甚至比在之前几年要更加重要。

事实上很难评估和比较 React 和 Vue 的体积大小。如果你想要使用 React 构建网站，你也将会使用 React-dom。同样，它们有一系列不同的功能。但是 Vue 以轻量闻名，同时你也可能会因为使用了 Vue 而减少依赖包的大小。

关于原生性能，这里有一些数据：

![](https://cdn-images-1.medium.com/max/800/1*8apjMq6HAKJzu5mkeryLmA.png)

数据来源：[https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html](https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)

![](https://cdn-images-1.medium.com/max/800/1*LahiEV9jeiJDNj3AXcSvyg.png)

数据来源：[https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html](https://www.stefankrause.net/js-frameworks-benchmark6/webdriver-ts-results/table.html)

如你所见，这个基准测试详细地说明了，相比于使用 React，使用 Vue.js 的网页应用程序占用的内存更少，运行速度也更快。

Vue 将会为你提供更快的渲染管线，帮助你构建复杂的网页应用。由于你的项目能被更高效的渲染，你就不用那么顾虑代码优化，这能够让你能腾出时间用于项目的更重要的功能上。移动端性能也是如此，你将不怎么需要调整算法来保证手机上的平滑渲染。

> 当你放弃 React 而选择了 Vue.js，你就不需要在应用大小和性能之间折中。你将能兼顾应用大小和性能。

### 学习曲线

学习 React 是可以的。了解一个完全围绕网页组件而构建的库是很好的事情。React 的核心是完美且稳固的，但是在我处理高级路由配置的时候我遇到了很多问题。所有这些路由版本的实际情况是什么？目前已经到了第四版（+ React-router-dom），我最终使用的是第三版。只要你习惯了这个技术栈，选择版本其实很容易，但是学习的过程却很痛苦。

#### 第三方库

大多数近代框架都普遍遵从一个原理：内核简单，没有太多功能，你可以通过在它们之上配置其他的库，来丰富它们。构建一个技术栈可以非常简单，条件是可以毫不费力的集成其他库，并用相同的方式为每个库集成。对我来说至关重要是，这一步应该尽可能的简单明了。

React 和 Vue 都有工具，用来帮助你使用附加的工具开启项目配置。在 React 生态系统中，可用库很难掌握，因为有时候很多个库解决的是同一个问题。

在这部分，React 和 Vue 都很出色。

#### 代码清晰度

我的观点是，React 糟糕透了。JSX，写 html 代码的内建语法，在清晰度方面是很让人头疼的。

这是一个使用 JSX 写 “if” 条件句的常规方法：

```
(
	<div>
	  {unreadMessages.length > 0 &&
	    <h1>
	      You have {unreadMessages.length} unread messages.
	    </h1>
	  }
	</div>
);
```

这则是 vue 的写法：

```
<template>
	<div v-if="unreadMessages.length > 0">
	    <h1>
	      You have {unreadMessages.length} unread messages.
	    </h1>	
	</div>
</template>
```

你将会遇到其他问题。在组件模版中调用方法经常会遇到无法获取 “this” 的问题，结果是你需要手动绑定：`<div onClick={this.someFunction.bind(this, listItem)} />`。

![](https://cdn-images-1.medium.com/max/800/1*AmMOMOzb_rAfA7MOUPWSfA.gif)

在某些时候，使用 React 让事情变得非常不合逻辑...

假设你需要在应用中写很多条件判断语句，用 JSX 的方法就很不好。而用这个方法来写循环的话，对我来说简直像看笑话。当然你可以改变模版系统，把 JSX 从 React 技术栈中移除，或者和 Vue 一起使用 JSX，但是当你学习一个框架的时候，这不是首先要做的事情，这不是解决问题的重点。

另一方面，使用 Vue 你不需要使用 **setState** 或者其他类似的东西。你仍然需要在一个 “data” 方法中定义所有状态属性，如果你忘了，你将会在控制台看到提示。余下的部分将会自动的在内部被处理，你只需要像操作常规 Javascript 对象那样，在组件中修改属性的值。

使用 React 你将会遇到很多代码错误。所以尽管潜在的规则其实非常简单，你的学习进程还是会非常慢。

考虑到简明性，使用 Vue 写的代码要比使用其他框架更加轻量。这其实是 Vue 框架最棒的部分。所有的东西都很简单，你将会发现你能够仅使用几行易懂的代码，就写出很复杂的功能，而使用其他框架，将会多使用 10%，20%，有时候会是 50% 更多的代码量。

你也不需要额外学习什么。所有的内容都很简明直接。写 Vue.js 代码可以让你非常靠近实现你想法的最简路径。

这样易用性使得 Vue 成为了一个很好的帮助你适应和交流的工具。不管是你想要修改你项目技术栈的其他部分，由于紧急情况为团队招募更多的人，还是在产品上施展实验，它都绝对能让你花费更少的时间和金钱。

时间预算也非常容易，因为实现一个功能的时间不需要比开发者估计的多很多，结果就是更少可能的引起的冲突，错误或疏忽。要理解的概念很少，这使得与项目经理的沟通变得更加容易。

### 总结

不管是体积，性能，简易性，或者学习曲线哪个方面，拥抱 Vue.js 吧，这绝对是当前非常好的选择，让你能够节省时间和金钱。

它的重量和性能也让你能够有一个同时使用两个框架（比如 Angular 和 Vue）的网络项目，这将能让你轻松的转型到 Vue。

考虑到社区和用户量，现在即使是 Vue 也有了更多人给的 star，但我们也不能说它已经赶上了 React。但是事实上一个框架没有 IT 巨头公司在后面支持却如此流行，它也是绝对足够好而值得一看的。在前端开发的领域，它的市场占比已经很快的从一个不知名的项目成长为一个很强的竞争者。

建立在 Vue 基础上的模块正在激增，而如果你没有找到你个能够满足你需求的，你也不会花太长的时间去开发出你所需要的那个。

这个框架让理解，分享和编辑都变得容易。你在研究其他人的代码的时候不仅会觉得很舒适，而且还能很容易的修改他们的实现方法。几个月的时间，Vue 让我在处理项目的子项目和外部贡献者的时候自信了很多。它为我节省了时间，让我能专注于我真正想要设计的事物。

React 被设计为需要使用像 setState 这样的帮助方法，你**将会**忘记去用他们。你在写模版的时候会很痛苦，这样写将会让你的项目很难被理解，很难维护。

关于在大型项目中使用这些框架，如果使用 React 你将会需要管理其他库并且训练你的团队也去使用。这会导致很多连带的问题（X 不喜欢这个库，Y 不懂那个库）。Vue 技术栈则简单很多，对团队大有好处。

> 作为开发者，我感到愉悦自信和自由。作为项目经理，我能和我的团队更加轻松的计划和交流。作为自由职业者，我节省了时间和金钱。

Vue 依旧有很多没有覆盖到的需求（特别是如果你想要构建本地应用）。在这个领域 React 的性能很好，但是 Evan You 和 Vue 团队也已经在这方面作出努力了。

> React 很流行，因为它的一些很好的观念以及观念实现的方法。但是回头看看，它却看起来像在一个混乱海洋里的一堆点子。

写 React 代码就是整天在寻找解决办法（可以比照“代码清晰度”那部分），在已经有意义的代码上挣扎，最后破解了它并产生了一个真的很不明确的方案。这个方案在你几个月后回头重新看它的时候将会非常难以阅读。为了发布项目你需要更努力的工作，并且它还会很难维护，会出错，并且需要很多的学习才能修改。

没人想要这些缺点在自己的项目里出现。为什么你还要继续面对这些问题呢？社区和第三方库？每天都变得不那么成问题的几点，却可以让你避免这么多痛苦。

这么多年一直和框架打交道，它们有时候让我的生活更轻松，有时候实现一个功能却复杂很多，这之后 Vue 对我来说是一种解脱。实现方法和我计划如何开发功能很接近，然后开发过程中，除了你真正想要实现的东西，几乎没有什么特别需要思考的。它和原生的 Javascript 逻辑非常相近（不会有 **setState**，实现条件语句的特别方式以及算法）。你只需要随心所欲的写代码。它快速，安全，让你愉快 :D。我很高兴看到 Vue 正在被更多的前端开发者和公司接纳，我希望它能够很快终结 React。

**免责声明：这篇文章仅代表我个人此刻的看法。随着科技的进步，它们也将会改变（更好或者更坏）。**

[编辑] 根据 [James Y Rauhut](https://medium.com/@seejamescode?source=post_header_lockup) 的意见，修改了题目。

[编辑] 修改了谈论关于比较框架大小的段落。正如文章指出的，评估很困难，并且基于需求不同，也经常会在人和框架之间引起争论。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
