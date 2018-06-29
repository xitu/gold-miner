> * 原文地址：[JavaScript unit testing frameworks: Comparing Jasmine, Mocha, AVA, Tape and Jest](https://raygun.com/blog/javascript-unit-testing-frameworks/)
> * 原文作者：[Ben Harding](https://raygun.com/blog/javascript-unit-testing-frameworks/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-unit-testing-frameworks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-unit-testing-frameworks.md)
> * 译者：[ClarenceC](https://fe2x.cc)
> * 校对者：[dearpork](https://github.com/Usey95)，[Xekin-FE](https://github.com/Xekin-FE)

# JavaScript 单元测试框架： Jasmine, Mocha, AVA, Tape 和 Jest 的比较

当开始开发新前端项目的时候，我经常会问自己两个问题：“我应该用那一个 JavaScript 单元测试框架呢？” 和 “我应该花时间去添加测试代码吗？”

我的同事经常写一些有关单元测试如何让脑子平静下来且减少软件错误的文章。所以我**也总会花时间来做测试**。但是在你的项目中应该选那个框架来做测试呢？在做出匆忙决定之前，我搜集了 5 个最受欢迎的 JavaScript 单元测试框架，让你决定那一个才是最合适你的。

> [有效的单元测试是减少你软件错误的一部分。要让你的单元测试更健壮还需要用到一些 JavaScript 调试小技巧](https://raygun.com/javascript-debugging-tips)。

**注意:如果你已经有更喜欢的测试框架并且它没有出现在下面列表中,在评论中让我知道我会添加到文章中。**

## JavaScript 单元测试框架:比较

### Jasmine

![Jasmine 是一个我们要比较的 JavaScript 单元测试框架](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks.png)

最受欢迎的 Javascript 单元测试框架之一，[Jasmine](https://jasmine.github.io/)提供所有你所需要的功能并且开箱即用。

*   Jasmine 带有 assertions(断言)，spies (用来模拟函数的执行环境)，和 mocks (mock 工具)，非常完美地配备几乎是你开始写单元测试时需要的所有东西。Jasmine 初始化设置简单同时如果你需要一些单元功能的时候你仍然可以加一些库进来 (括号内容：译者注)
*   全局性使它更容易在你的应用中立即开始测试。虽然我并不喜欢全局性，但是和 Jasmine 提供给开发者全部需要的开箱即用功能，并没有太多的不一致的地方
*   我发现独立版本能让它更容易去理解所有东西是怎样设置的并能让你能立刻开始使用它
*   时至今日已经能和 [Angular 1](https://docs.angularjs.org/guide/unit-testing) 或者 [Angular 2](https://docs.angularjs.org/guide/unit-testing) 或者更多流行库组合使用了

**我对 Jasmine 的看法**

我不是占有全局环境的粉丝，所以 Jasmine 会在我的小本子上面丢些分。在另一方面，它有很多很好的即开即用功能。它看上去会显得稍微 “老些” 比起其它在这列表的框架，但是这并不是一件坏事，其它框架可能遇到的痛点，意味着它们更应更容易被解决。

### AVA

![AVA 是一个我们要比较的 JavaScript 单元测试框架](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-1.png)

一个简约的测试库，[AVA](https://github.com/avajs/ava) 它的优势是 JavaScript 的异步特性和并发运行测试, 这反过来提高了性能。

*   AVA 不会创建全局环境给你，因此你能更容易控制你所使用的内容。我想这会给测试带来额外的清晰度确保你清楚什么正在发生 
*   利用了 JavaScript 的异步特性优势为测试额外的好处。最主要的好处是优化了在部署时的等待时间
*   保留了简单的 API 为你提供你所需要的功能。如果你搭配 mocking 来使用它会显得更加友好，但是你必须安装一个单独的库
*   当你想知道应用 UI 什么时候会有超出预期的改变的时候 [jest-snapshot](https://facebook.github.io/jest/blog/2016/07/27/jest-14.html) 提供了非常好用的快照测试

**我对 AVA 的看法**

Ava “[最有见地的](https://github.com/avajs/ava#why-not-mocha-tape-tap)” 是极简方法， 还有他不是占有全局环境的，这让他在我的小本子上获得很高的分数。简单的 API 让测试更清晰。在你选择 JavaScript 单元测试框架的时候，AVA 测试库你是绝对应该尝试的。

### Tape

![Tape 是一个我们要比较的 JavaScript 单元测试框架](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-2.png)

这是在这份框架列表上最小的一个框架，[Tape](https://github.com/substack/tape) 是最直接开门见山的，提供最基础的功能。

*   就像 AVA 一样，Tape 不提供全局环境，取而代之的是得要你自己导入他们。 这还是很不错的只要它不污染到全局环境
*   Tape 不包括安装/卸载方法. 取儿替之的是， 它选择了一个多模块系统在那里你需要明确定义安装代码在每一个测试里面以使每个测试更清晰。 它同时会阻止状态在测试之间共享
*   支持 Typescript/coffeescript/es6 
*   简易快速地搭建以及运行，Tape 是一个你可以在任何可以运行 JavaScript 的环境中运行的 JavaScript 文件，并且没有过多的配置选项

**我对 Tape 的看法**

Tape 包含更底层，比 AVA 功能更少的 API，并以此为傲。Tape 让所有事情变得简单，只给你所需要的东西。这就是为什么 Tape 在我的小本子上有着高分数并且是最好的 JavaScript 单元测试框架之一，它让你更专注于产品而不是工具的选择。

### Mocha

![Mocha 是一个我们要比较的 JavaScript 单元测试框架](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-3.png "Mocha logo")

作为可以说是使用最多的库，[Mocha](https://mochajs.org/) 是一个灵活的库，提供给开发者的只有一个基础测试结构。然后其它功能性的功能如 assertions， spies，mocks，和像它们一样的其它功能需要引用添加其它库/插件来完成。

*   如果你想要更灵活的配置，导入你特定需要的库，那么 Mocha 额外的安装与所需要的配置是你必须要看的
*   不幸的是，上面的观点确实还存在问题，它必须导入额外的库来实现 assertions (译者注:断言功能)。如果不是长时间使用，这确实意味着比其它的更难一点去设置. 他们说，设置通常只是一次性操作，但是我更喜欢去做一个 “单一来源的事实” (文档) 代替在文档间跳来跳去地设置   
*   Mocha 导入测试结构作为全局变量，省去你的时间你不再需要 `include` 或者请求它在每个文件中。缺点是无论如何那些插件还是要你使用 `require` 导入到里面，这会导致不一致，如果你像我一样是个 OCD (译者注:强迫症患者) 它最终会把你弄疯的！

**我对 Mocha 的看法**

可扩展性和数种不同配置 Mocha 的方式另我印象深刻。必须去学习 Mocha，然后也必须去学习你选择的 assertion 库这的确吓到了我不少。灵活性在于它的 assertions，spies 和 mocks 带给它的高收益。

## Jest

![Jest 是一个我们要比较的 JavaScript 单元测试框架](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-4.png)

被 Facebook 和各种 React 应用推荐和使用，[Jest](https://facebook.github.io/jest/) 得到了很好的支持。Jest 也被发现是一个非常快速的测试库在[平行测试](http://facebook.github.io/jest/blog/2016/03/11/javascript-unit-testing-performance.html)报告中。

*   对于小型项目来说你可能在开始的时候不用过多担心，而性能的提高对于希望全天 [持续部署](https://raygun.com/blog/continuous-deployment/) 的大型应用 app 来说是非常之好的
*   而开发人员主要是用 Jest 去测试 React 应用，Jest 可以很容易地集成到其它应用程序中充许你使用更独特的特性在其它地方
*   快照测试是一个非常好用的工具去确保你的应用 UI 不会有超出预期的错误在产品发布替换的期间发生。虽然大部分功能专门设计都是使用在 React 上，但是它也能在其它框架上面如果你能找到合适的插件 
*   不像在这列表上其它的库，Jest 有着很广阔的 API ，除非你真的需要一些额外的功能需求，不然不需要你导入额外的库
随着他们的每一次更新[Jest 继续大幅改进功能](https://facebook.github.io/jest/blog/) 

**我对 Jest 的看法**

在全局变量下是一个缺点，Jest 是一个不断发展功能强大的库。它有很多易于理解的文档帮助学习，并且支持各种不同环境，当构建项目的时候这些环境都显示很棒。

## 我应该选那一个 JavaScript 单元测试框架？

在我研究了一些不同的框架之后，我得出一个结论，框架并非都是非黑即白的。

大部分框架最终都会(Mocha 除外)在一天结束的时候提供给你你所需要的东西，这是一个测试环境同确保给出的 X -> Y 总回被返回的机制，有几个会简单的会给你更多 “华而不实的东西。”

你在选择他们的时候应该充满自信，而我的选择取决于你和你特定项目想要的和需要的。

*   **如果你要求有一个广泛的 API 和特定 (可能独一无二) 的功能那么 Mocha 可能会是你的选择 因为可扩展性就在那里**
*   **AVA 或者 Tape 会给你最低的环境要求。非常好地为你提供一个坚实的最基础环境让你能快速开展测试**
*   **如果你有一个大项目, 或者想快速开始不需要太多配置，那么 Jest 将会是一个很好的选择**

我希望这将在你选择你的 JavaScript 单元测试框架时有所帮助。如果你希望我还看一下其它 JavaScript 单元测试框，在评论中让我知道！我会将它们稍后加到列表中。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

