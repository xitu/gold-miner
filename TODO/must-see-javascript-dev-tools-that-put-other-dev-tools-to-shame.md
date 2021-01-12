> * 原文链接: [Must See JavaScript Dev Tools That Put Other Dev Tools to Shame](https://medium.com/javascript-scene/must-see-javascript-dev-tools-that-put-other-dev-tools-to-shame-aca6d3e3d925#.wm0lbpiko)
* 原文作者 : [Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [赵鑫晖](https://github.com/zxc0328)
* 校对者 : [achilleo](https://github.com/achilleo)
* 状态 : 完成  

# 2015 年底 JS 必备工具集

>“Javascript 没法胜任大型应用，因为它甚至不能确定一个变量的类型，而且很难重构”~一大堆困惑的人


当我初识 Javascript 的时候，只有一种浏览器需要关心：NetScape。它在微软开始捆绑销售 IE 和操作系统之前完全统治了世界。在那些日子里，Javascript 的开发者工具很弱这种观点的确是对的。


不过这个观点已经被推翻很久了，今天，Javascript 已经拥有了在我见过的所有语言中最好的开发工具生态系统。


请注意，我没有说“最好的 IDE”。如果你正在寻找一款统一了不同开发工具使用体验的集成式 IDE，请试试微软为 C#打造的 Visual Studio，和 Unity 一起使用风味更佳。虽然我本人并没有使用过，但是听我信任的人说这很靠谱。


我用过 C++和虚幻引擎。当我第一次试用的时候，我意识到 web 平台的开发工具仍然有很长的路要走。


不过我们已经走过了很长一段路，现在我们在 JS 中使用的工具让 IDE 神奇的自动补全看起来就像是 小孩的玩具。尤为是 JavaScript 的运行时工具，在我见过的所有其他语言中都没有对手。


>“Javascript 拥有在我见过的所有语言中最好的开发工具生态系统。”



#### 什么是开发者工具？


开发者工具是一套让开发者更轻松的软件集合。传统上，我们主要将 IDE，linter，编译器，调试器，和性能分析器认为是开发者工具。


不过 JavaScript 是一种动态语言，伴随它的动态特性而来的是对运行时开发者工具的需求。JavaScript 对此的需求程度很高。


为了实现我写这篇文章的初衷，我将包括对运行时工具的介绍，甚至包括一些能提升运行时开发者工具可视化和调试体验的库。开发工具与库之间的界线将开始模糊。与之而来的将是令人震惊的结果。


#### 开发者工具一览表

*   [Atom](https://atom.io/) & [atom-ternjs](https://atom.io/packages/atom-ternjs)
*   [Chrome Dev Tools](https://developer.chrome.com/devtools)
*   [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)
*   [FireFox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/)
*   [BrowserSync](http://www.browsersync.io/)
*   [TraceGL](https://github.com/traceglMPL/tracegl)
*   [ironNode](http://s-a.github.io/iron-node/)
*   [ESLint](http://eslint.org/)
*   [rtype](https://github.com/ericelliott/rtype) (规范) & [rfx](https://github.com/ericelliott/rfx) (库) **提示:** 这些是未完成的开发预览版
*   [Babel](http://babeljs.io)
*   [Greenkeeper.io](http://greenkeeper.io/) & [updtr](https://github.com/peerigon/updtr)
*   [React](https://facebook.github.io/react/)
*   [Webpack](https://webpack.github.io/) + [Hot module replacement](https://github.com/webpack/docs/wiki/list-of-plugins)
*   [Redux](http://redux.js.org/) + [Redux DevTools](https://github.com/gaearon/redux-devtools)


#### 关于这些工具


你的开发者生涯将围绕着这两个东西展开：**编辑器**，和你的**运行环境**（比如，浏览器，平台，和你代码的目标设备）


**编辑器：**我是用着像 Borland IDE，微软 Visual Studio，Eclipse 和 WebStorm 这样的大型，重量级，高度集成的 IDE 开始我的职业生涯的。我认为这些 IDE 中最好的是**WebStorm** 和 **Visual Studio**。



但是我对这些 IDE 体积的膨胀感到厌倦，所以在最近几年里，我的代码都是在更精简的编辑器中写成的。主要是 Sublime Text，不过我最近切换到了[**Atom**<sup>[1]</sup>](https://atom.io/)。你一定会需要[atom-ternjs<sup>[2]</sup>](https://atom.io/packages/atom-ternjs)来启用 JavaScript 智能感知特性。你可能也会对 Visual Studio Code 感兴趣。这是一个简约版 Visual Studio，专为喜欢像 Sublime Text 和 Atom 这样的小型可拓展编辑器的人打造。


我也使用 vim 在终端里进行快速编辑。

**调试器：**在我开始 web 编程之旅时，我想念那些集成的调试器。不过 Chrome 和 FireFox 团队将运行时调试提升到了一个全新的水准。今天似乎每个人都听说过 Chrome DevTools，并且知道如何逐步调试代码。不过你知道它有对性能及内存进行记录和审查（profiling and auditing）的高级特性吗？你用过 flame charts 或者 the dominators view吗？


说到性能审查，你需要了解[PageSpeed Insights<sup>[3]</sup>](https://developers.google.com/speed/pagespeed/insights/):

<iframe width="854" height="480" src="https://www.youtube.com/embed/bDUDuQy3R7Y?list=PLOU2XLYxmsILKwwASNS0xgfcmakbK_8JZ" frameborder="0" allowfullscreen=""></iframe>


除此之外，Chrome DevTools 也有一些酷炫的特性，比如像 CSS 实时编辑，以及可以帮助你编辑动画的超酷特性。去了解 Chrome DevTools吧，你不会后悔的。

<iframe width="700" height="393" src="https://www.youtube.com/embed/hJdqtBeAUNI" frameborder="0" allowfullscreen=""></iframe>


为了不被超过，FireFox 有一个专为开发者打造的浏览器[FireFox Developer Edition<sup>[4]</sup>](https://www.mozilla.org/en-US/firefox/developer/):

<iframe width="700" height="393" src="https://www.youtube.com/embed/g9k4IrtaPMs?list=PLo3w8EB99pqLRJBWRCoyGTIrkctoUgB9W" frameborder="0" allowfullscreen=""></iframe>


**BrowserSync:** [BrowserSync<sup>[5]</sup>](http://www.browsersync.io/)可以一次同时控制几个浏览器，这是检测你的响应式布局的一种好办法。换句话说，你可以使用 BrowserSync CLI 来在桌面，平板和手机上打开你的 app。


你可以设定文件监视（watch files），然后当文件改动时，几个同步的浏览器会自动刷新。滚动，点击，以及表单互动这些动作都将会被同步到所有设备，所以你可以毫不费力地测试 app 的工作流，确保它在任何设备上都能正常运行。

<iframe width="640" height="480" src="https://www.youtube.com/embed/heNWfzc7ufQ" frameborder="0" allowfullscreen=""></iframe>


**TraceGL:** [TraceGL<sup>[6]</sup>](https://github.com/traceglMPL/tracegl) 是一个运行时调试工具，它让你可以观察软件中实时发生的所有函数调用，而不是逐步手动调试你的代码，一次一步。这是一个超级强大和有用的功能。

<iframe width="700" height="393" src="https://www.youtube.com/embed/TW6uMJtbVrk" frameborder="0" allowfullscreen=""></iframe>


**ironNode:** [ironNode<sup>[7]</sup>](http://s-a.github.io/iron-node/) 是一个用于调试 Node 的桌面 app。由 Electron，一个桌面跨平台运行时驱动。Electron 也驱动了 Atom 编辑器。就像 node-inspector，ironNode 允许你使用类似 Chrome DevTools 的特性来追踪你的代码。

<iframe width="640" height="480" src="https://www.youtube.com/embed/pxq6zdfJeNI" frameborder="0" allowfullscreen=""></iframe>


将 ironNode 和 Babel 一起使用，我使用如下的_`debug.js`_ 脚本：
<pre>require('babel-core/register');  
require('./index');
</pre>


加载调试器：

<pre>iron-node source/debug.js
</pre>


这就像魔法一样，不是吗？


**Linting:** [ESLint<sup>[8]</sup>](http://eslint.org/) 是目前为止我用过的各种语言的 linter 中最好的。我喜欢 ESLint 甚于 JSHint，ESLint 比 JSHint 好太多了。如果你不确定使用什么，别担心，使用 ESLint。为什么它这么酷呢？

*   可配置性高 - 每一个选项都可以被开启或关闭。这些选项甚至可以接收参数。
*   创造你自己的规则。你有你想要在你的团队中强制执行的代码规范吗？在 linter 中可能已经有了这样的规则，不过如果没有，你可以写你自己的规则。
*   支持插件 - 使用了某些特殊语法？ES6+或者未来版本 JavaScript 的实验性特性？没问题。使用了 React 的 JSX 语法打造简洁的 UI 组件？没问题。使用了你自己的实验性 JavaScript 语法拓展？没问题。


**类型支持：** JavaScript 具有松散的类型，这意味着你不必注解所有的类型。过去数年我在 C++和 Java 这样的语言中注解所有东西。当我开始使用 JavaScript 之后，我感到如释重负。类型注解在你的源文件中制造了杂音。函数通常在没有类型注解时更易用。


和大众认知相反，**JavaScript 是有类型的**，但是 JavaScript 在**值**层面区别类型而不是变量层面。变量类型可以被类型推断识别并预测出来（这就是 Atom TernJS 插件的作用）。


这就是说，类型注解和签名（signature）声明是为了一个目的：它们对于开发者来说是不错的文档。它们也使 JavaScript 引擎以及编译器作者的一些重要性能优化成为可能。作为一个构建 app 的 JavaScript 程序员，你不应该担心性能问题。把这些留给引擎和制定规范的团队吧。


不过关于类型注解我最喜欢的一点是运行时类型反射。使用类型反射可以开启运行时开发者工具。想知道这样的工具是什么样的，请阅读["The Future of Programming: WebAssembly and Life After JavaScript"<sup>[9]</sup>](http://www.sitepoint.com/future-programming-webassembly-life-after-javascript/)。


数年来，我使用 JSDoc 来注解类型，编写文档以及类型推断。不过我对其麻烦的限制感到厌倦。这感觉就像你使用一种不同的语言编写代码，之后将它挤压成 JavaScript（这是真的）。


我也对 TypeScript 的结构化类型方案感到印象深刻。

不过 TypeScript 存在一些问题：


*   TypeScript 不是标准的 JavaScript - 选择 TypeScript 意味着选择 TypeScript 编译器以及工具生态 - 这通常导致你无法选择为 JavaScript 标准设计的方案。
*   TypeScript 很大程度上基于 class。这与 JavaScript 的原型和对象组合特性八字不合。
*   目前为止，TypeScript 不提供运行时解决方案… - 他们正在使用实验性的新 JavaScript **Reflect** API 构建。不过接下来你可能会依靠这些实验性极高的规范特性，这些特性也许会成为最终标准，也许不会。


因为这些，我启动了（目前还未完成）[rtype<sup>[10]</sup>](https://github.com/ericelliott/rtype)和[rfx<sup>[11]</sup>](https://github.com/ericelliott/rfx)项目。**rtype** 是一个函数和接口反射规范，对于了解 JavaScript 的读者来说，这一规范形成了不言自明的文档。**rfx** 是一个用于封装已经存在的 JS 函数及对象然后添加类型元数据的库。同时，它也可以加入自动运行时类型检查。我正在积极的与人们合作以改进 rtype 和 rfx。也欢迎你们的贡献。


你要记得 rtype 和 rfx 还非常年轻，并且在短期之内几乎必定会有革命性的变化。


**Babel:** [Babel<sup>[12]</sup>](http://babeljs.io/) 是一个让你立即在 JavaScript 代码中使用还不被支持的 ES6+, JSX 以及其他特性的编译器。它的原理是将你的代码翻译成等价的 ES5代码。一旦你开始使用它，我敢说你将很快对新语法上瘾，因为 ES6为这门语言提供了一些真正有价值的语法拓展，像解构赋值（destructuring assignment），默认参数值，剩余和展开参数（rest parameters and spread），简洁对象字面量（concise object literals），以及更多… 阅读["How to Use ES6 for Universal JavaScript Apps"<sup>[13]</sup>](https://medium.com/javascript-scene/how-to-use-es6-for-isomorphic-javascript-apps-2a9c3abe5ea2)来了解细节。


**Greenkeeper.io:** [Greenkeeper<sup>[14]</sup>](http://greenkeeper.io/) 监控你的项目依赖并且自动向你的项目提交一个 pull request。你要确保你已经设定了 CI 解决方案来自动测试 pull requests。如果测试通过，只要点击“merge”，就完工了。如果测试失败，你可以手动跟进并且找出哪里需要修复，或者直接关闭 PR。


如果你偏爱手动的方法，看看[**updtr**<sup>[15]</sup>](https://github.com/peerigon/updtr)。在你第一次开启 Greenkeeper 之前，我推荐先在你的项目上运行 updtr。


**Webpack:** [Webpack<sup>[16]</sup>](https://webpack.github.io/) 将模块和依赖打包成浏览器可用的静态资源。它支持大量有趣的特性，比如模块热替换，这让你正在为浏览器编写的代码在文件更改时自动更新，而不用刷新页面。模块热替换是迈向真正持续实时开发反馈循环的第一步。如果你还没有使用 webpack，你应该使用它。为了更快入门，看看[**Universal React Boilerplate**<sup>[17]</sup>](https://github.com/cloverfield-tools/universal-react-boilerplate)这个项目里的 webpack 配置。


**React:** 这一个有一点跑题，因为[React<sup>[18]</sup>](https://facebook.github.io/react/) 严格意义上来说不是一个开发者工具。它和一个 UI 库有着更多的共同点。请把 React 想象成现代的 jQuery：一种更简单的处理 DOM 的办法。但 React 比这更强大。事实上，你可以把 React 对准一大堆 DOM 之外的平台，包括原生移动 UI APIs(iOS & Android)，WebGL, canvas 以及更多。Netflix 将 React 的目标平台设为了他们自己的 Gibbon TV 设备渲染 API。


所以为什么我将 React 列在开发者工具之中？因为 React 的抽象层被一些不错的开发者工具使用，来驱动代表未来趋势的惊人工具。特性有热加载（更新你的实时运行代码而不刷新页面），时间旅行（time travel），以及更多… 继续阅读！


**Redux + Redux DevTools:** Redux 是由 React/Flux 架构和函数式编程的纯函数概念启发而来的一个应用状态管理库。另一个在开发者工具列表中的库？是的，以下是原因：

<iframe width="700" height="393" src="https://www.youtube.com/embed/xsSnOQynTHs" frameborder="0" allowfullscreen=""></iframe>


Redux 以及 Redux DevTools 使得在你的实时运行代码之上进行真正的下一代调试互动成为可能。这让你可以轻松洞察在你的 app 中已经发生的行为：

![](https://cdn-images-1.medium.com/max/1600/1*lAp8ZAk5uNFTuxjhx4GTdw.gif)


它甚至允许你使用时间旅行调试这个特性在时间中来回穿梭。这是它在滚动视图中看起来的样子：

![](https://cdn-images-1.medium.com/max/1600/1*BTRxlHu8WuCF4Iep4R44lA.gif)



#### 结论


JavaScript 有着我所见过的所有语言中最丰富的开发者工具集。你可以看到，这更像是一个拼凑的过程而不是一个统一的 IDE 环境。不过我们处于 JavaScript 开发的寒武纪大爆炸时期，在未来，我们也许会看到现成的统一集成开发者工具。与此同时，我们将一瞥编程未来走向的究竟。


随着 JavaScript 向统一的应用状态（unified application state）和不变性（immutability）（正是这个特性使得 Redux DevTools 的时间旅行调试成为了可能）的更深处推进，我预测我们将看到更多的实时编程特性上线。


我也相信我们构建的应用和我们用以构建它的开发环境之间的界线会随着时间消逝而渐渐模糊。举个例子，Unreal 游戏引擎将蓝图编辑集成进了引擎自身，这允许开发者和设计师从运行的游戏中构建复杂的行为。我思考了很久，我们将开始看到这些特性出现在 web 和以及原生移动应用中。


JavaScript 的 linting，运行时监视（runtime monitoring）和时间旅行调试特性在我所知道的任何语言中都没有对手。但我们还可以做更多，比如将同等于 Unreal 4引擎中的蓝图系统这样的工具带给我们。我迫不及待的想看接下来会发生什么。

<iframe width="700" height="393" src="https://www.youtube.com/embed/9hwhH7upYFE" frameborder="0" allowfullscreen=""></iframe>

### [跟着 Eric Elliott 学 JavaScript](https://ericelliottjs.com/)

*   在线课程 + 定期在线广播
*   软件测试
*   JavaScript 的两个基石 (原型面向对象 + 函数式编程)
*   通用 JavaScript
*   Node
*   React


**_Eric Elliott_**是[_"Programming JavaScript Applications"_](http://pjabook.com) _(O'Reilly), 和_ [_"Learn JavaScript Universal App Development with Node, ES6, & React"_](https://leanpub.com/learn-javascript-react-nodejs-es6/)_的作者。他在_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_ **_ESPN_**_,_ **_BBC_**_, 和为包括_ **_Usher_**_,_ **_Frank Ocean_**_,_ **_Metallica_**_在内的顶级艺术家, 开发过软件。_

_他的大多数时间花在和世界上最美丽的女人一起呆在旧金山湾区._
