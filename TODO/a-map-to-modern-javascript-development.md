#现代的 JavaScript 开发地图（2017）
过去 5 年里你一直使用 REST 接口。或者你一直在优化搜索公司里庞大的数据库。又或者你一直在给微波炉写嵌入式软件。自从你用 Prototypr.js 来对浏览器进行面向对象编程已经过去很久了，现在你想提升一下你的前端技能，你看了一下发现情况是[这样](https://thefullfool.files.wordpress.com/2010/09/wheres-waldo1.jpg)。
当然你不是从要从一堆徐峥里找出葛优，你在找 25 个连名字都不知道的人。这种情况在 JavaScript 社区特别常见，以至于存在 “JavaScript 疲劳” 这个词。比较喜剧化一点点化，[在2016年学习JavaScript是怎样的体验？](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.c7g9ng4e7)很好的反映了这个现象。
但你现在没时间了，你在一个大迷宫里，你需要一张地图，所以我做了一张。
一点声明在前：这是一张可以让你快速行动，不必做自己太多决定的作弊表。基本我会给通用的前端开发制定一套工具，这将会给你一个舒服的环境而不会让你太头疼。当你想清楚这些问题，你将有足够的信息来根据需求调整你的步伐。
### 地图结构 
我将会将这张地图分为几个你需要解决的问题，对于每个问题，我将会：

* 描述问题或工具需求
* 决定你需要选取哪种工具
* 讨论为什么这样选
* 给一些其他选择

### 项目管理
* 问题：需要管理项目和其依赖。
* 解决办法：NPM 和 Yarn
* 原因：NPM是目前相当多的软件包管理器。Yarn 可以优化依赖解析和保持正确的依赖版本（他可以集成在 NPM 中，他们是相辅相成而不是单独存在的）。
* 可选：暂时未知。

### JavaScript风格
* 问题：ECMAScript5 (老学究) 太烂。
* 解决办法：ES6
* 原因：这是未来的 JavaScript ，但是你可以现在就用了。结合其他多种语言有用的特性。比如说：箭头函数，模块导入/导出功能，解构。模版字符串，let 和 const，生成器，promises。如果你是写 Python 的你会感觉在家一样。
* 可选：TypeScript，CoffeeScript，PureScript，Elm

### 编译
* 问题：许多浏览器目前不支持 ES6,你需要东西来把你现代的 ES6 编译成 ES5.
* 解决办法：babel
* 原因：在服务端编译，完美的解决办法，也是事实上的标准。
* 可选：Traceur
* 注意：你需要使用 Babel-loader，一个 Webpack loader (以及一些其他的)，如果你计划使用任何风格的 JavaScript 你都需要编译。

### Linting
* 问题：有一万种写 JavaScript 的方式所以很难达到一致性。一些 bug 可以用 linter 检查出来。
* 解决办法：ESLint
* 原因：完美的检查和很好的可配置性。airbnb preset 值得遵循。对你熟悉新的语法绝对有帮助。
* 可选：JSLint

### 打包工具
* 问题：你不能使用分开的单独文件，依赖需要被解析和正确的加载。
* 解决办法：Webpack
* 原因：高度可配置性，可以加载所有的依赖和文件，支持热插拔。他是React 项目事实上的工具。
* 可选：Browserify
* 不利性：一开始可能很难配置
* 注意：你需要一点时间来了解这东西是怎样工作的，你还需要了解一点 babel-loader， style-loader， css-loader， file-loader， url-loader。

### 测试
* 问题：你的应用很脆弱，你需要测试。
* 解决办法：mocha (测试远行)，chai (断言库) 和 chai-spies (对于假的对象，你可以查询某些事件应不应该发生)。
* 原因：使用简单，功能强大。
* 可选：Jasmine，Jest，Sinon，Tape。

### UI 库／状态管理
* 问题：这是大家伙，单页应用越来越复杂，状态管理也很麻烦
* 解决办法：React 和 Redux
* 使用 React 的原因：令人兴奋的范式转变，打破许多 web 领域的教条更好的实现。关注比传统方法更好的分离：取代分离 HTML/CSS/JavaScript 而采取组件化的思想。你的交互界面只是状态的反映。
* 使用 Redux 的原因：如果你的应用不是很轻量，你需要你个东西来组织状态 （否则你疲于对于组件间的交互与数据传递，以及组件化的局限性）。网上的每一个采取抽象的 Flux 架构模式的解决办法对会让你摆脱迷惑。帮助你节省时间直接采用 Redux 就行了。 他的实现模式很精简。即使 Facebook 也使用他。另外的美妙之处：重载并保持应用状态，可测试性。
* 可选：Angular2，Vue.js。
* 警告：当你第一次看到 JSX 风格的代码你可能会很吃惊。然后找一个社区大喊，这是多年来认知的失调，事实上将 HTML，JavaScript 和 css写在一起是很棒的。相信我— 不需要在一个文件里写两个蹩脚的引用。

### DOM 操作和动画
* 问题：猜猜看？当你在选择元素和执行操作 DOM 节点时你仍然需要一点权宜之计。
* 解决办法：原生 ES6 或者 jQuery。
* 原因：是的，jQuery还活着，React 和 jQuery 并不冲突，对于你的要求你需要更多的使用 React (和`querySelector`)。添加 jQuery 将会使你的打包速度变慢，我想说在 React 上使用 jQuery 不是很好你应当避免他。如果你被 ES6 和 React 不能解决的问题卡住了，也许需要使用一下jQuery。
* 可选：Dojo (不知还在不？)。

### 样式
* 问题：现在你有了正确的模块，你希望他们可以有组织化可以重用。模块化的样式也是需要的。
* 解决办法：CSS 模块化。
* 原因：我喜欢内联样式（并且广泛的使用），我必须承认他们有很多弱点。是的，在 React 内可以写行内样式，但是你不能使用伪类选择器（比如`:hover`），这将会导致很多问题。
* 可选：内联样式。我特别喜欢内联风格的原因是他们让风格看作常规的 JavaScript 对象，可以让你程序化的处理。另外，他们在你每一个的组件文件里，可以让你更好的维持。一些人仍推荐 SASS/SCSS/Less。这些语言意味着额外的构建步骤，他们并不像 CSS 模块／内联风格一样便携，但是功能强大。
### 就这样
你现在有一堆的东西来学习，但至少你不要在花费时间来做调查了。如果发现我少做了或者漏了什么东西？在 twitter 上给我留言或者评论吧 [@bug_factory](http://twitter.com/bug_factory)。
=======
> * 原文地址：[A Map To Modern JavaScript Development](https://hackernoon.com/a-map-to-modern-javascript-development-2017-16d9eb86309c#.5veb58lh7)
> * 原文作者：[Santiago de León](https://hackernoon.com/@sdeleon28?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# A Map To Modern JavaScript Development (2017) #

So you’ve been doing REST APIs for the past 5 years. Or perhaps you’ve been optimizing searches for your company’s gigantic database. Maybe writing the embedded software for a microwave oven? It’s been a while since you were rocking some Prototype.js to do proper OOP in the browser. And now you’ve decided it’s time to get up to speed with your frontend skills. You take a look at the landscape and it looks like [this](https://thefullfool.files.wordpress.com/2010/09/wheres-waldo1.jpg) .

Of course you’re not looking for Waldo. You’re looking for 25 random guys and don’t even know what their names are. This feeling of being overwhelmed is so common in the JavaScript community that the term “JavaScript fatigue” actually exists. When you have time for some comedy about the subject, [this post](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.1ubvm0x0u) reflects the phenomenon brilliantly.

But you don’t have the time for that now. You’re in a giant maze, and you need a map. So I made a map.

A little disclaimer first: This is a cheat-sheet to get you up and running fast without having to make too many decisions by yourself. Basically I will be laying out a set of tools that just work together for general-purpose frontend development. This will get you comfortable with the environment and will save you a few headaches. Once you’re done with these topics, you’ll be confident enough to adjust the stack to your needs.

#### Structure of the map ####

I will divide the map into problems that you’ll need to tackle. For each problem, I will:

- Describe the problem or the need for a tool
- Decide which tool you will use to solve the problem
- Explain why I chose that tool
- Give a few alternatives

#### Package management ####

- **Problem:** Need to organize your project and your dependencies.
- **Solution:** NPM and Yarn
- **Reason:** NPM is pretty much the de-facto package manager. Yarn runs on top of NPM but optimizes dependency resolution and keeps a lock file of the exact version of your libraries (use it in tandem with NPM’s semantic versioning, they’re not exclusive, they complement each other).
- **Alternatives:** None that I know of.

#### **JavaScript flavor** ####

- **Problem:** ECMAScript 5 (aka old-school JavaScript) sucks.
- **Solution:** ES6
- **Reason:** It’s the future JavaScript but you can use it right now. Incorporates many useful features that have been available to other programming languages for a long time. Interesting new features: arrow functions, module import/export capabilities, de-structuring, template strings, let and const, generators, promises. If you’re a Python coder you’ll feel at home.
- **Alternatives:** TypeScript, CoffeeScript, PureScript, Elm

#### Transpiling ####

- **Problem:** Many browsers that are still massively in use don’t implement ES6. You need a program that translates (transpiles) your modern ES6 into equivalent, well-supported ES5.
- **Solution:** babel
- **Reason:** Works perfectly and it’s pretty much the de-facto standard. Transpiles server-side.
- **Alternatives:** Traceur
- **Notes:** You will use babel-loader, a Webpack loader (more on that later on). You’ll need transpiling if you plan to use any of the other JavaScript flavors as well.

#### **Linting** ####

- **Problem:** There’s a zillion ways of writing JavaScript and consistency is hard to achieve. Some bugs can be prevented with a linter.
- **Solution:** ESLint
- **Reason:** Great code insight and very configurable. The airbnb preset is all you need to get up and running. Really helps you get used to the new syntax.
- **Alternatives:** JSLint

#### Bundling ####

- **Problem:** You are no longer using a flat file or sequence of files. Dependencies need to be resolved and loaded properly.
- **Solution:** Webpack
- **Reason:** Highly configurable. Can load all sorts of dependencies and assets. It’s pluggable. It’s pretty much the de-facto bundler for React projects.
- **Alternatives:** Browserify
- **Disadvantages:** Can be a little hard to configure at first.
- **Notes:** You’ll want to spend some time really understanding how this guy works. You should also learn about babel-loader, style-loader, css-loader, file-loader, url-loader.

#### Testing ####

- **Problem:** Your app is fragile. It will fall apart. You need tests.
- **Solution:** mocha (test runner), chai (assertion library) and chai-spies (for spies, fake objects that you can query for certain events that should or shouldn’t have happened).
- **Reason:** Easy to use and powerful.
- **Alternatives:** Jasmine, Jest, Sinon, Tape.

#### UI framework / state management ####

- **Problem:** This is one of the big ones. SPAs have grown more and more complex. Mutable state is particularly troublesome.
- **Solution:** React and Redux
- **Reasons for using React:** Mind-blowing paradigm shift, breaks a lot of dogmas as old as the web and does it amazingly. Better separation of concerns than traditional approach: instead of separating by technology (HTML/CSS/JavaScript) you break things up by their functionality (cohesive components). Your UI is a pure function of your state.
- **Reasons for using Redux:** If your app is non-trivial, you need a tool to manage the state (otherwise you’ll be doing gymnastics for your components to talk to each other, learn vanilla inter-component communication first to experience the limitations). Every tutorial on the web will walk you through the confusing, abstract Flux pattern and all implementations that there have ever been. Save yourself a decent amount of time and go straight to Redux. It implements the pattern in a very simple manner. Even Facebook uses this. Extra awesomeness: reload and keep application state, time travel, testability.
- **Alternatives:** Angular2, Vue.js.
- **Warning:** You might feel an urge to pry your eyes out with a rusty spoon the first time you see JSX code. Resist the temptation to find a forum and yell in outrage. This is just cognitive dissonance caused by years of indoctrination. Turns out mixing HTML, JavaScript and CSS in a single file is super awesome. Believe me! — Achievement unlocked for using two lame references in a single bullet.

#### DOM manipulation and animations ####

- **Problem:** Guess what? You’ll still need occasional quickfixes where you’ll have to target selectors and perform operations directly on DOM nodes.
- **Solution:** Plain ES6 or jQuery.
- **Reason:** Yes, jQuery is still alive and well. React and jQuery aren’t mutually exclusive. Although, be aware that you should be able to do most of what you need with vanilla React (and `querySelector`). Adding jQuery will also increase your bundle’s footprint slightly. I’d say that using jQuery on top of React is a smell and you should avoid it whenever possible. If you hit a certain corner case that you can’t figure out with just React + ES6 features, or if you’re dealing with some annoying cross-browser quirk, jQuery might save the day.
- **Alternatives:** Dojo (does that still even exist?).

#### Styling ####

- **Problem:** Now that you have proper modules, you want them to be self-contained, reusable pieces of software that you can move around. Component styles should be as portable as the components themselves.
- **Solution:** CSS modules.
- **Reason:** As much as I love inline styles (and use them extensively), I must admit that they’re rather limited. Yes, it’s totally OK to use inline styles in React, but you can’t target pseudo-class selectors (like `:hover`) with them, which is a deal-breaker in many cases.
- **Alternatives:** Inline styles. What I particularly like about inline styles in React is that they allow you to treat styles as regular JavaScript objects, which lets you process them programatically. Also, they live in the same file as your component, which makes them super easy to maintain. Some people still advocate for SASS/SCSS/Less. These languages imply an extra build step and aren’t as portable as CSS modules/inline styles but are as powerful as they’ve ever been.

#### That’s it! ####

You now have a metric shit-ton of stuff to study, but at least you won’t need to spend so much time doing research. Do you think I missed something? Did I drop the ball somewhere? Leave a comment or reach me on twitter [@bug_factory](http://twitter.com/bug_factory).