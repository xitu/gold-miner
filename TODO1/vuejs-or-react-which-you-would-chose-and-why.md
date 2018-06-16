> * 原文地址：[Vue.js or React ? Which you would chose and why?](https://www.reddit.com/r/javascript/comments/8o781t/vuejs_or_react_which_you_would_chose_and_why/e01qn55/)
> * 原文作者：[evilpingwin](https://www.reddit.com/user/evilpingwin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vuejs-or-react-which-you-would-chose-and-why.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vuejs-or-react-which-you-would-chose-and-why.md)
> * 译者：[allenlongbaobao](https://github.com/allenlongbaobao)
> * 校对者：[KyleLan329](https://github.com/KyleLan329)、[weberpan](https://github.com/weberpan)

# Vue.js 还是 React？你会选择哪一个？为什么？

两者之间的区别很有意思，但不仅仅局限于 JSX 与 Templates 或者丰富的 API 与少量的 API 的区别。React 和 Vue 两者之间的选择可能导致截然不同的结果，这一点在你一开始选择的时候可能并没有意识到。当选择一个框架的时候，一个重要的问题是「我希望项目的复杂性在哪个部分」。

React 和 Vue 可以完成很多相同的东西，但它们的实现方式截然不同。从一些反馈来看，我很好奇是否有人真的同时使用这两个框架来做一些东西，而不是写一些简单的组件，只有那样才能透过表面肤浅的差异，真正了解两者之间的内在区别。

不知你是否知道，Vue 深化了单文件组件的思想。一个文件由模版、脚本、样式，这些相互独立的模块组成。有人发现这种方式开发起来很舒服，因为每个模块的开发和传统的前端开发流程相似。我个人很喜欢这种模块，不是因为它「长得像 html」，而是它就像页面上的地标一样，层次分明，容易识别，通过地标就能很快地寻找到文件本身。React 中 JS 和 JSX 的组合运行得很好，但还是有点混乱（特别是当你添加样式组件到组合中去的时候）。而你无视这些，并习惯它了。有必要指出的是：React 使用 SFC（无状态组件）时需要一个编译步骤，但 Vue 不需要。正因为 JSX 需要一个编译步骤，所以当你考虑用 React 时你要多加考虑。如果你想要在不需要编译的前提下把几个 script 文件合并到一个项目中，那么 React 真的不是一个很好地选择，除非你打算放弃 JSX 改用 `React.createElement()`。这种情况下，Vue 是显而易见更好的选择。

关于 Vue 的其他评论是：它使用了 DSL(领域专用语言) 并且有大量的 API。两者都是真的，至少它的 API 比 React 要多，但相对于其他的库来说，它还是算少的。这两个情况是分离但相关的。Vue 使用的 DSL 只是另一个抽象概念，就像 SFC 一样。它们被设计出来是为了你能更加高产，并使你的代码保持整洁，表述清晰。JXS 的存在是同样的原因，它也是非标准化抽象，但是允许你发挥 JavaScript 全部的能量。JSX 不是 JavaScript，并且永远不会是，比如说 airbnb 的代码风格指南禁止在 `.js` 文件中包含 JSX，因为它们是非标准化的。它们必须在自己的 `.jsx` 文件中运行。

一旦你知道 Vue 的 DSL 包含了一系列辅助方法和简写来让你更高效，那要不要选择它就看你个人喜好了。换句话说（译者注：如果选择 Vue）你有更多的特殊语法要学。有的人讨论学习新的 API 会带来认知上的负担，这个质疑是有必要的（虽然我存有异议），但是我会和他们争论：正因如此，反过来说，简单的 API 意味着我们需要使用相对复杂的模式去完成特定的内容，React 因此也给我们带来大量认知负担。我会解释这个。~我们不要忘记 React 的 API 数量在不断增加，并以合理的速度持续增加。我们最近获得了 context API，在将来的某个时间点，我们还将获得 Time Slicing 和 Suspense。~ 另外要注意到，React 同样被驱动着更新。React 团队很在意用户的需要，并且在他们觉得有意义的地方做出改变。Context、Time Slicing、Suspense 这些特性已经或者即将被添加。尽管这样，React API 仍然可能保持简洁而且只有当有意义的时候，特性才会被添加。

值得一提的是，Vue 的文档是 API 文档的典范，它极其简洁。React 文档在平均水平，也还可以，它的 API 更简单所以按道理说你不需要过多地查阅文档。**这一评论已经被批评了，但我坚持这一点，因为其他文档太糟糕了，也没让 React 文档看上去很好，相对于 Vue，它们确实很一般。我不是说 React 的文档特别糟糕，只是相对于你所期待的优秀的库而言，它很一般。**

下面让我们来讨论抽象。所有的前端框架都在做抽象，有的抽象到更高的层级，有的更低。使用纯 JS 以声明式的风格来写 UI 组件是极其困难的，所以 React 和 Vue 提供了很多方法来做到这一点，并带上许多有用的插件，允许我们绑定状态到 DOM，而无需存储状态到 DOM，以及在内容变化时可以高效地渲染。

所有的这些意味着，如果你不想，你不必使用 Vue 的模板和 DSL。你可以只使用 React 中的 JSX 或者 createElement() 函数。你也可以自己选择模板语言，比如 Pug。不知你有没发现，Vue 在这方面非常灵活。它能够使用 SFC 来写真正的 UI 组件，只用 JS 来写非渲染组件（只输出 script 代码块，不包括 template 和 style），然后根据你的需要切换到 JSX 或者渲染函数。这种方法会给予你对工作方式难以置信的控制力，并让你的代码保持整洁。

当你开始写更加高级的组件或者想要写真正的可复用组件（特别是那种包装其他组件为它赋能的组件），你会开始发现一些明显的区别。使用 React，你需要使用一个或多个高阶组件，render props 或者函数作为子组件的开发模式。这些模式没有任何问题，对于现实问题它们是很好地解决方式，但它们增加了明显的认知困难（比学习新的语法更加多），因为它们真的是很复杂的模式。使用 Vue，这些模式没有必要，因为它有更多的 API，暴露了一系列传递数据的方法（如果你有兴趣的话了解一下嵌套插槽）。这意味着在 Vue 中，你可以使用上面那些模式，也可以使用其他形式的模式（嵌套插槽类似于 render props）。

**这不是说 Vue 比 React 简单，也不是说 React 特别让人疑惑（嵌套插槽至少和 render props/ FaCC 一样复杂）。很多人忽略的关键点是使用 React 你需要尽快学会这些模式（很多流行的库使用它们），但是 Vue 中的嵌套插槽使用得不是很频繁。这一点有很多理由，再次说明，重要的区别不在于这些框架各自能做些什么，而是解决普通问题使用到复杂模式的频率。**

它们都是拥有各自优点的强大框架，任何你可以使用一个做到的事，另一个也可以（真的很多）。React 拥有更大的生态系统以及更好的工具，拥有更多的工作机会。Vue 更容易上手，拥有出色的灵活性，它的 API 能让你避免使用 React 中的一些复杂模式，它以一种更符合语言习惯的 'Vue' 的方式运行。比如向父组件传递消息，而不是将回调函数作为属性向下传递。它能让你的代码更整洁，但这也是额外的抽象。Vue 还有更多核心库，和 Vue 紧密结合在一起，它们运行的方式和其他框架的类似方法基本相同。React 拥有的核心库少一些（Vue的一些标准函数到了 React 就需要引一个库，比如检查 prop 类型），但总体上拥有的库却更多（由社区提供）。值得牢记的是，随着生态圈的发展，你最终能得到大量做相同事情的库，我在 React 或者 Vue 中使用的大多数库抛开样式写法基本上和你选用的框架（React 还是 Vue）无关（React 会让你重新思考样式布局，这不是一件坏事），所以你达成目标需要做的事可能会发生变化。**在我看来，一个强大的生态系统的最终影响是，你面临的问题很可能别人已经解决了，这是 React 的流行带来的巨大红利，，也是重要的考虑因素。**

我两个都使用，也都很喜欢。它们用不同的方式让我困惑。它们都有各自的特性你需要去习惯。如果我不得不选择一个？我会选择 Vue。但这并不意味着你应该选。亲自去试试，看看你感觉怎么样。对于任何严厉的批评或者过高的赞许都要保持怀疑态度，因为它们都是由真正聪明的人开发的优秀框架，你选择任何一个都不会太差。我已经试着保持中立，给出重要的区别。我可能已经失败了，因为有些东西在一个框架让人很恼火，而另一个框架不会。

作者按：我忘了提到 vue-cli，它类似于 create-react-app+。这真的是一个非常棒的工具，能够快速建立可视化 UI，这一点很有趣。所以从某种意义上来说，Vue 中的工具真的很棒。我同样忘了提 Typescript 在 Vue 中的整合目前还不是很好，可能在 React 中会有更好的 TS 体验。值得继续深究。

去尝试吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
