> * 原文地址：[React vs. Svelte: The War Between Virtual and Real DOM](https://blog.bitsrc.io/react-vs-sveltejs-the-war-between-virtual-and-real-dom-59cbebbab9e9)
> * 原文作者：[Keshav Kumaresan](https://medium.com/@keshavkumaresan1002)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/react-vs-sveltejs-the-war-between-virtual-and-real-dom.md](https://github.com/xitu/gold-miner/blob/master/article/2020/react-vs-sveltejs-the-war-between-virtual-and-real-dom.md)
> * 译者：[niayyy](https://github.com/nia3y)
> * 校对者：[Alfxjx](https://github.com/Alfxjx)、[x1ny](https://github.com/x1ny)

# React vs. Svelte: 虚拟与真实 DOM 间的战争

我最近有幸使用到了 Svelte，并学习到了如何去创建一个简单的购物车应用程序。此外，我不禁注意到了它和 React 的许多相似之处。它能成为如此出色的竞争者，成为最流行的用来构建用户界面的 JavaScript 库之一，非常令人惊讶。这篇文章中，我将比较 Svelte 和 React，看看他们如何在幕后进行对抗。

![Image by [Iván Tamás](https://pixabay.com/users/thommas68-2571842/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2354583) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2354583)](https://cdn-images-1.medium.com/max/3840/1*SVLGTQm3xUZgU8n2QJfmyA.jpeg)

##  Svelte 是一个编译器，而 React 使用虚拟 DOM

React 和 Svelte，都提供了相似的基于组件的架构 —— 这意味着两者都能够进行由组件驱动地自底向上的开发，并且都能够在不同的应用间共享组件。

它们间的显著差异在于 Svelte 是一个编译器，可以让你的应用程序代码在编译阶段转换成理想的 JavaScript 代码片段，而 React 使用虚拟 DOM 在运行时去解释应用程序代码，二者恰恰相反。是的，这有很多术语，让我来解释一下。

![Svelte vs. React Behind the Scenes](https://cdn-images-1.medium.com/max/5916/1*_7upPeJparkaxnpBhOkZig.png)

#### React 虚拟 DOM

React 使用一个叫做虚拟 DOM（VDOM）的概念，它是 UI 在内存中的虚拟表示形式，并通过叫做 [reconciliation](https://reactjs.org/docs/reconciliation.html) 的过程来和真实 DOM 进行同步。 在 reconciliation 过程中将找出虚拟 DOM（内存中的一个对象，保存了最新的 UI 更新）和真实 DOM（DOM 保持更新前渲染的 UI）间的不同（diffing 算法）。使用特定的启发式算法，来决定如何更新 UI。这个过程，大多数情况下是快速的、可靠且反应迅速的。双关语义😄。

为了实现这些，React 打包了一些额外的代码，这些代码运行在浏览器的 JS 引擎中来监视和更新基于各种用户交互的 DOM 节点。

#### Svelte 编译器

Svelte 是一个纯编译器，当你构建线上的应用程序时，它会把你的应用程序代码转换为理想的 JavaScript 代码片段。这意味着当你的应用程序运行更新 DOM 时，它不会注入任何需要在浏览器运行的额外代码。

与通常使用虚拟 DOM 的 React 相比，这个方法相对更加新颖。

## Svelte 的优势

让我们总结一下通过使用 Svelte 我们可以获得的主要好处。

1. 对比 React 及其他框架，Svelte 构建时间更短。秘诀可能在于使用 rollup 插件作为打包工具。
2. 对比 React，当使用 gzipped 压缩时，包的尺寸较小，这是一个巨大的优点。甚至我构建的购物车应用程序，首次加载时间和 UI 渲染时间都非常少，只有较大的图片需要花费更多的时间 :)。
3. 类和变量的绑定相对容易，并且绑定类时不需要自定义逻辑。
4. 在组件本身为 CSS `\<style>` 设置范围允许灵活的样式。
5. 比起其他的框架，Svelte 的重要组成部分是纯 JavaScript、HTML 和 CSS，因此更易于理解和入门。
6. 对比 React 上下文 API 有更直截了当的存储实现，获取上下文 API 提供更多的特性，并且对常见的场景来说，Svelte 可能更简单。

## Svelte 的缺点

让我们找一下 Svelte 的不足。

1. Svelte 不会监听引用更新和数组变动，这很糟糕，开发者需要积极关心这个问题，并确保数组被分配以便 UI 能进行更新。
2. DOM 事件的使用方式可能也是令人恼怒的，我们需要遵循 Svelte 特定的语法代替使用原生的 JS 语法。React 中可以直接使用 `onClick`，但在 Svelte 中需要使用特殊语法 `on:click`。
3. Svelte 是一个新的、年轻的框架，社区支持很少，不能提供大型应用程序可能需要的丰富的插件和集成。React 是这里的一个强力的竞争者。
4. 没有其他改进。React suspense 主动控制你的代码及其运行方式，并尝试优化 DOM 更新的时间，有时甚至在等待数据时提供自动加载微调器。这些额外的特性和持续改进在 Svelte 中非常少。
5. 一些开发者可能不喜欢使用特殊的语法，像模板中的 `#if` 和 `#each`，他们更倾向于使用纯 JavaScript，像在 React 中那样。这可能取决于个人爱好。

## 结论

和 React 相比，Svelte 构建时间更短而且包尺寸较小，这方面非常吸引人，特别是对于小型的日常应用。但是高级特性（上下文 API、suspense 等）、社区支持、丰富的插件和集成以及某些特别语法的简化让 React 更有吸引力。

**Svelte 和 React 孰优孰劣？**

相比 React，Svelte 确实在一些功能有显著改善。但是还不足以完全取代 React。React 仍然强大且被广泛使用。Svelte 还有许多工作要做。但在概念上，Svelte 采取的编译方法证明，虚拟 DOM diffing 算法并不是构建快速响应式应用程序的唯一方法，一个足够好的编译器可以很好地完成相同的工作。

**你的下一个应用程序会使用那个框架？**

在权衡利弊时，在我看来，如果你正在构建一个小的应用程序，像为了你的创业构建一个简单的电子商务应用程序，我会推荐 Svelte。如果你对于 JS、HTML 和 CSS 有很好的了解，那更容易去掌握 Svelte。你也可以使用 Svelte 来构建一些功能强大地快速和轻量的应用程序。

对于大型线上应用程序，需要一些集成和特定的插件，可能 React 是更好的选择。像 React提供了 Next.js，Svelte 也提供了他的生产就绪的单页面应用程序框架，叫做 [Sapper](https://sapper.svelte.dev/)，可能值得去研究。

这两个竞争者都是构建出色的用户界面的实用而有效的工具。到目前为止，在这两者之间进行选择主要取决于你的使用场景和偏好。正如我在上文中提到的，要宣布一名获胜者是一项挑战，因为他们都为实现自己的主要目标而表现出色。

我希望这篇文章能让你对 React 和 Svelte 进行快速对比。这将对你决定下一个应用程序使用哪个库很有帮助。干杯！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
