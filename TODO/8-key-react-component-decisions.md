> * 原文地址：[8 Key React Component Decisions: Standardize your React development with these key decisions](https://medium.freecodecamp.org/8-key-react-component-decisions-cc965db11594)
> * 原文作者：[Cory House](https://medium.freecodecamp.org/@housecor?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/8-key-react-component-decisions.md](https://github.com/xitu/gold-miner/blob/master/TODO/8-key-react-component-decisions.md)
> * 译者：[undead25](https://github.com/undead25)
> * 校对者：

# React 组件的 8 个关键决策

## 通过这些关键决策来标准化你的 React 开发

![选择困难证](https://cdn-images-1.medium.com/max/1000/1*XgHYXVXoyziBKd7Or5IliQ.jpeg)


React 自 2013 年被开源以来，一直在更新演进。当你在搜索网页时，可能会被一些使用了过时的方法的文章坑到。所以，现在在写 React 组件时，你的团队需要作出以下八个关键决策。

### 决策 1：开发环境

在编写第一个组件之前，你的团队需要就开发环境达成一致。太多选择了……

![](https://i.loli.net/2017/10/17/59e5d90a25a0a.jpg)

当然，你可以[从头开始构建 JS 开发环境](https://www.pluralsight.com/courses/javascript-development-environment)，有 25% 的 React 开发者是这么做的。我目前的团队使用的是 create-react-app 的 fork，并拓展了一些功能，例如[支持 CRUD 的 mock API](https://medium.freecodecamp.org/rapid-development-via-mock-apis-e559087be066)、[可复用的组件库](https://www.pluralsight.com/courses/react-creating-reusable-components)和增强的代码检测功能（我们会检测 create-react-app 忽略了的测试文件）。我是喜欢 create-react-app 的，但[这个工具可以帮助你比较许多不错的替代方案](http://andrewhfarmer.com/starter-project/)。想在服务端进行渲染？可以了解下 [Gatsby](http://gatsbyjs.org) 或者 [Next.js](https://github.com/zeit/next.js/)。你甚至可以考虑使用在线编辑器，例如 [CodeSandbox](https://codesandbox.io)。

### 决策 2：类型检测

你可以使用 [prop-types](https://reactjs.org/docs/typechecking-with-proptypes.html)、[Flow](https://flow.org) 或 [TypeScript](https://www.typescriptlang.org) 来进行类型检测。需要注意的是，在 React 15.5 中，prop-types 被提取到了[单独的库](https://www.npmjs.com/package/prop-types)，因此按照较老的文章进行导入会报警告（React 16 会报错）。

社区在这个话题上依然存在着分歧：

![](https://i.loli.net/2017/10/17/59e5da85a81b6.jpg)

我更倾向于 prop-types，因为我发现它在 React 组件中提供了足够的类型安全性，几乎没有任何阻碍。使用 Babel、[Jest](https://facebook.github.io/jest/)、[ESLint](http://www.eslint.org) 和 prop-types 的组合，我很少看到运行时的类型问题。

### 决策 3：createClass 和 ES 类

React.createClass 是原始 API，但在 15.5 中已被弃用。有点感觉[我们将枪头指向了 ES 类](https://medium.com/dailyjs/we-jumped-the-gun-moving-react-components-to-es2015-class-syntax-2b2bb6f35cb3)。不管怎样，createClass 已经从 React 的核心中移除，并被[归类到 React 官方文档中一个名为“React without ES6”的页面](https://reactjs.org/docs/react-without-es6.html)。所以很清楚的是：ES 类是趋势。你可以使用 [react-codemod](https://github.com/reactjs/react-codemod) 轻松地从 createClass 转换为 ES 类。

### 决策 4：类和函数

你可以通过类或函数来声明 React 组件。当你需要 refs 或者生命周期方法时，类是必须的。这里有[尽可能考虑使用函数的 9 个理由](https://hackernoon.com/react-stateless-functional-components-nine-wins-you-might-have-overlooked-997b0d933dbc)。但值得注意的是，[函数组件有一些缺点](https://medium.freecodecamp.org/7-reasons-to-outlaw-reacts-functional-components-ff5b5ae09b7c)。

### Decision 5: State

You can use plain React component state. It’s sufficient. [Lifting state](https://reactjs.org/docs/lifting-state-up.html) scales nicely. Or, you may enjoy Redux or MobX:

![1508235965(1).jpg](https://i.loli.net/2017/10/17/59e5daca05632.jpg)

[I’m a fan of Redux](https://www.pluralsight.com/courses/react-redux-react-router-es6), but I often use plain React since it’s simpler. In my current role, we’ve shipped about a dozen React apps, and decided Redux was worth it for two. I prefer shipping many, small, autonomous apps over a single large app.

On a related note, if you’re interested in immutable state, there are at least [4 ways to keep your state immutable](https://medium.com/@housecor/handling-state-in-react-four-immutable-approaches-to-consider-d1f5c00249d5).

### Decision 6: Binding

There are at least [half a dozen ways you can handle binding](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56) in React components. In React’s defense, this is mostly because modern JS offers many ways to handle binding. You can bind in the constructor, bind in render, use an arrow function in render, use a class property, or use decorators. [See the comments on this post](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56) for even more options! Each approach has its merits, but assuming you’re comfortable with experimental features, [I suggest using class properties (aka property initializers) by default today](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56).

This poll is from Aug 2016\. Since then, it appears class properties have grown in popularity, and createClass has reduced in popularity.

![](https://i.loli.net/2017/10/17/59e5daf6be182.jpg)

**Side note**: Many are confused about why arrow functions and bind in render are potentially problematic. The real reason? [It makes shouldComponentUpdate and PureComponent cranky](https://medium.freecodecamp.org/why-arrow-functions-and-bind-in-reacts-render-are-problematic-f1c08b060e36).

### Decision 7: Styling

Here’s where the options get seriously intense. There are 50+ ways to style your components including React’s inline styles, traditional CSS, Sass/Less, [CSS Modules](https://github.com/css-modules/css-modules), and [56 CSS-in-JS options](https://github.com/MicheleBertoli/css-in-js). Not kidding. I explore React styling approaches in detail [in the styling module of this course](https://www.pluralsight.com/courses/react-creating-reusable-components), but here’s the summary:

![](https://cdn-images-1.medium.com/max/1000/1*5Q3FXqxI6akM-GWV2rqlcw.png)

Red is bad. Green is good. Gray is warning.

See why there is so much fragmentation in React’s styling options? There’s no clear winner.

![](https://cdn-images-1.medium.com/max/800/1*_K-z-ZfTXNFwyedAXrS5sA.png)

Looks like CSS-in-JS is gaining steam. CSS modules is losing steam.

My current team uses Sass with BEM and are happy enough, but I also enjoy [styled-components](https://www.styled-components.com).

### Decision 8: Reusable Logic

React initially embraced [mixins](https://reactjs.org/docs/react-without-es6.html#mixins) as a mechanism for sharing code between components. But mixins caused issues and are [now considered harmful](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html). You can’t use mixins with ES class components, so now people [utilize higher-order components](https://reactjs.org/docs/higher-order-components.html) and [render props](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce) (aka function as child) to share code between components.

![1508236093(1).jpg](https://i.loli.net/2017/10/17/59e5db5a8f656.jpg)

Higher-order components are currently more popular, but I prefer render props since they’re often easier to read and create. [Michael Jackson recently sold me with this](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce):

[Video-YouTube](https://youtu.be/BcVAq3YFiuc)

### And that’s not all…

There are more decisions:

* Will you use a [.js or .jsx extension](https://github.com/facebookincubator/create-react-app/issues/87#issuecomment-234627904)?
* Will you place [each component in its own folder](https://medium.com/styled-components/component-folder-pattern-ee42df37ec68)?
* Will you enforce one component per file? Will you [drive people nuts by slapping an index.js file in each directory](https://hackernoon.com/the-100-correct-way-to-structure-a-react-app-or-why-theres-no-such-thing-3ede534ef1ed)?
* If you use propTypes, will you declare them at the bottom, or within the class itself using [static properties](https://michalzalecki.com/react-components-and-class-properties/#static-fields)? Will you [declare propTypes as deeply as possible](https://iamakulov.com/notes/deep-proptypes/?utm_content=buffer57abf&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer)?
* Will you initialize state traditionally in the constructor or utilize the [property initializer syntax](http://stackoverflow.com/questions/35662932/react-constructor-es6-vs-es7)?

And since React is mostly just JavaScript, you have the usual long list of JS development style decisions such as [semicolons](https://eslint.org/docs/rules/semi), [trailing commas](https://eslint.org/docs/rules/comma-dangle), [formatting](https://github.com/prettier/prettier), and [event handler naming](https://jaketrent.com/post/naming-event-handlers-react/) to consider too.

### Choose a Standard, Then Automate Enforcement

And all this up, and there are dozens of combinations you may see in the wild today.

So, these next steps are key:

> 1. Discuss these decisions as a team and document your standard.

> 2. Don’t waste time manually policing inconsistency in code reviews. Enforce your standards using tools like [ESLint](https://eslint.org), [eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react), and [prettier](https://github.com/prettier/prettier).

> 3. Need to restructure existing React components? Use [react-codemod](https://github.com/reactjs/react-codemod) to automate the process.

Other key decisions I’ve overlooked? Chime in via the comments.

### Looking for More on React? ⚛️

I’ve authored [multiple React and JavaScript courses](http://bit.ly/psauthorpageimmutablepost) on Pluralsight ([free trial](http://bit.ly/pstrialimmutablepost)).

[![](https://cdn-images-1.medium.com/max/800/1*BkPc3o2d2bz0YEO7z5C2JQ.png)](https://www.pluralsight.com/authors/cory-house)

* * *

[Cory House](https://twitter.com/housecor) is the author of [multiple courses on JavaScript, React, clean code, .NET, and more on Pluralsight](http://pluralsight.com/author/cory-house). He is principal consultant at [reactjsconsulting.com](http://www.reactjsconsulting.com), a Software Architect at VinSolutions, a Microsoft MVP, and trains software developers internationally on software practices like front-end development and clean coding. Cory tweets about JavaScript and front-end development on Twitter as [@housecor](http://www.twitter.com/housecor).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
