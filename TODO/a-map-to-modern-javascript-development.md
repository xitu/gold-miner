> * 原文地址：[A Map To Modern JavaScript Development](https://hackernoon.com/a-map-to-modern-javascript-development-2017-16d9eb86309c#.5veb58lh7)
> * 原文作者：[Santiago de León](https://hackernoon.com/@sdeleon28?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[gy134340](https://github.com/gy134340)
> * 校对者：[IridescentMia](https://github.com/IridescentMia),[Tina92](https://github.com/Tina92)

# 新一代 JavaScript 的开发图谱（2017）

过去 5 年里你一直使用 REST 接口。或者你一直在优化搜索公司里庞大的数据库。又或者你一直在给微波炉写嵌入式软件。自从你用 Prototype.js 来对浏览器进行面向对象编程已经过去很久了，现在你想提升一下你的前端技能，你看了一下发现情况是[这样](https://thefullfool.files.wordpress.com/2010/09/wheres-waldo1.jpg)。

当然你不是要从一堆徐峥里找出葛优，你在找 25 个连名字都不知道的人。这种情况在 JavaScript 社区特别常见，以至于存在 “JavaScript 疲劳” 这个词。当你有时间去看一些关于这个主题的有趣的东西的时候，你会看到[在2016年学习JavaScript是怎样的体验？](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.c7g9ng4e7)绝妙的反映了这个现象。

但你现在没时间了，你在一个大迷宫里，你需要一张地图，所以我做了一张。

一点声明在前：这是一张可以让你快速行动，不必做自己太多决定的作弊表。基本我会给通用的前端开发制定一套工具，这将会给你一个舒服的环境而不会让你太头疼。一旦你搞定了这些问题，你就可以根据需要自信地调整技术栈。

### 地图结构 

我将会将这张地图分为几个你需要解决的问题，对于每个问题，我将会：

* 描述问题或工具需求
* 决定你需要选取哪种工具
* 讨论为什么这样选
* 给一些其他选择

### 包管理

* 问题：需要管理项目和其依赖。
* 解决办法：NPM 和 Yarn
* 原因：NPM 是目前相当多的软件包管理器。Yarn 基于 NPM 但是优化了依赖的解决方案，并且维护一个锁文件（lock file），用来保存库确切的版本号（它可以集成在 NPM 中，它们是相辅相成而不是单独存在的）。
* 可选：暂时未知。

### JavaScript风格

* 问题：ECMAScript5 (老版本 JavaScript) 太烂。
* 解决办法：ES6
* 原因：这是未来的 JavaScript ，但是你可以现在就用了。结合其他多种语言有用的特性。比如说：箭头函数、模块导入/导出功能、解构、模版字符串、let 和 const、生成器、promises。如果你是写 Python 的你会感觉更舒服和习惯。
* 可选：TypeScript、CoffeeScript、PureScript、Elm

### 编译

* 问题：许多浏览器目前不支持 ES6,你需要东西来把你现代的 ES6 编译成 ES5。
* 解决办法：babel
* 原因：在服务端编译，完美的解决办法，也是事实上的标准。
* 可选：Traceur
* 注意：你需要使用 babel-loader，一个 Webpack loader (以及一些其他的)，如果你计划使用任何风格的 JavaScript 你都需要编译。

### Linting

* 问题：有一万种写 JavaScript 的方式所以很难达到一致性。一些 bug 可以用 linter 检查出来。
* 解决办法：ESLint
* 原因：完美的检查和很好的可配置性。airbnb preset 值得遵循。对你熟悉新的语法绝对有帮助。
* 可选：JSLint

### 打包工具

* 问题：你不能使用分开的单独文件，依赖需要被解析和正确的加载。
* 解决办法：Webpack
* 原因：高度可配置性，可以加载所有的依赖和文件，支持热插拔。事实上，他是 React 项目的打包工具。
* 可选：Browserify
* 不利性：一开始可能很难配置
* 注意：你需要一点时间来了解这东西是怎样工作的，你还需要了解一点 babel-loader、style-loader、 css-loader、file-loader、url-loader。

### 测试

* 问题：你的应用很脆弱，很容易崩溃，所以你需要测试。
* 解决办法：mocha (测试运行)，chai (断言库) 和 chai-spies (对于假的对象，你可以查询某些事件应不应该发生)。
* 原因：使用简单，功能强大。
* 可选：Jasmine、Jest、Sinon、Tape。

### UI 库／状态管理

* 问题：这是大家伙，单页应用越来越复杂，状态管理也很麻烦
* 解决办法：React 和 Redux
* 使用 React 的原因：令人兴奋的范式转变，打破许多 web 领域的教条更好的实现。关注比传统方法更好的分离：取代分离 HTML/CSS/JavaScript 而采取组件化的思想。你的交互界面只是状态的反映。
* 使用 Redux 的原因：如果你的应用不是很轻量，你需要你个东西来管理状态 （否则你疲于对于组件间的交互与数据传递，以及组件化的局限性）。网上的每一个采取抽象的 Flux 架构模式的解决办法对会让你摆脱迷惑。帮助你节省时间直接采用 Redux 就行了。 他的实现模式很精简。即使 Facebook 也使用他。另外的美妙之处：重载并保持应用状态，可测试性。
* 可选：Angular2、Vue.js。
* 警告：当你第一次看到 JSX 风格的代码你可能会很吃惊。然后找一个社区大喊，这是多年来认知的失调，事实上将 HTML、JavaScript 和 CSS 写在一起是很棒的。相信我— 不需要在一个文件里写两个蹩脚的引用。

### DOM 操作和动画

* 问题：猜猜看？当你在选择元素和执行操作 DOM 节点时你仍然需要一点权宜之计。
* 解决办法：原生 ES6 或者 jQuery。
* 原因：是的，jQuery还活着，React 和 jQuery 并不冲突，你的大多数需求都可以用 vanilla React 来实现 (和`querySelector`)。添加 jQuery 将会使你的打包速度变慢，我想说在 React 上使用 jQuery 不是很好你应当避免他。如果你被 ES6 和 React 不能解决的问题卡住了，或者你正在处理讨厌的跨浏览器问题，也许需要使用一下jQuery。
* 可选：Dojo (不知还在不？)。

### 样式

* 问题：现在你有了正确的模块，你希望他们都是独立的并且可以有组织化的重用。组件化的样式应该像组件本身一样轻便。
* 解决办法：CSS 模块化。
* 原因：我喜欢内联样式（并且广泛的使用），我必须承认他们有很多弱点。是的，在 React 内可以写行内样式，但是你不能使用伪类选择器（比如`:hover`），这将会导致很多问题。
* 可选：内联样式。我特别喜欢内联风格的原因是他们把样式看作常规的 JavaScript 对象，可以让你程序化的处理。另外，他们在你每一个的组件文件里，可以让你更好的维持。一些人仍推荐 SASS/SCSS/Less。这些语言意味着额外的构建步骤，他们并不像 CSS 模块／内联风格一样便携，但是功能强大。

### 就这样

你现在有一堆的东西来学习，但至少你不要在花费时间来做调查了。如果发现我少做了或者漏了什么东西？在 twitter 上给我留言或者评论吧 [@bug_factory](http://twitter.com/bug_factory)。
