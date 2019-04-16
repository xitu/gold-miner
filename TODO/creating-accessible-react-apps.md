> * 原文地址：[Creating accessible React apps](http://simplyaccessible.com/article/react-a11y/)
> * 原文作者：[Scott Vinkle](http://simplyaccessible.com/article/author/scott/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/creating-accessible-react-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/creating-accessible-react-apps.md)
> * 译者：[llp0574](https://github.com/llp0574)
> * 校对者：[smancang](https://github.com/smancang)，[zhaoyi0113](https://github.com/zhaoyi0113)

# 创建无障碍 React 应用

使用 React 库创建可复用的模块组件在项目之间共享是一个非常好的开发方式。但是应该如何确保你的 React 应用适用于所有人？Scott 将通过一个详细且及时的教程来带领我们创建无障碍的 React 应用。

## 学习 React

![](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-1.jpg)

时间回到 2017 年 2 月，我从加拿大的金斯顿坐火车到多伦多。为什么我要经受这两小时的长途跋涉？就是为了去学习 [React](https://reactjs.org/) 库相关的内容。

在为期一天的课程结束之后，我们各自开发了一个完整的应用程序。其中让我感到兴奋的一件事是 React 如何迫使你以模块化的方式来思考。每个组件会做一个任务，而且会完成得非常好。当以这种方式构建组件的时候，它可以帮助你把所有的想法和精力集中，确保你不仅在为当前项目，而且也在为将来的项目做正确的事情。React 组件都是可复用的，而且如果构造得当，还可以在不同的项目之间共享。只要找到合适的乐高积木，就可以把你需要的东西拼凑在一起，从而创造出绝佳的用户体验。

然而，当我从旅途中回来的时候，我开始思考那几天我创建的应用是否无障碍。它是否可以做成无障碍应用？用我的笔记本电脑加载项目之后，我开始用我的键盘和 VoiceOver 屏幕阅读器来对其进行一些基本的检测。

有一些微小、能快速修复的问题，比如在主页链接列表使用 `ul` + `li` 元素来替代当前的 `div` 元素。另外一个可以快速修复的地方：为带有装饰性图片的插图容器添加一个空的 `alt` 属性。

但也有一些更具挑战性的问题要解决。随着每个新页面的加载，`title` 元素内容没有发生改变。不仅如此，键盘的焦点管理也非常糟糕，这就会让那些只使用键盘的用户无法使用这个应用。当一个新页面加载之后，焦点仍旧在前一个页面视图上！

> 有没有什么技术可以用来解决这些更具挑战的无障碍问题？

在花了一点时间阅读 [React 文档](https://reactjs.org/docs/hello-world.html)，并尝试了一些在课程当中习得的技术之后，我已经可以让这款应用更加无障碍了。在这篇文章里，我将带领大家研究一下最为紧迫的无障碍问题，以及如何解决它们，这些问题包括：

* React 保留字；
* 更新页面标题；
* 管理键盘焦点；
* 创建一个实时消息组件；
* 代码分析，再加上一些关于创建无障碍 React 应用的想法。

## Demo 应用

如果你更偏向于看到代码最终运行成果的话，那么可以看一下伴随这篇文章的 React demo 应用：[TV-Db](https://simplyaccessible.github.io/tv-db/)。

[![Screen capture of the TV-Db demo app on an iPad. Text in the middle of the screen reads, "Search TV-Db for your favourite TV shows!" A search form is below, along with a few quick links to TV show info pages.](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-ipad-1.png)](https://simplyaccessible.github.io/tv-db/)

你也可以在阅读这篇文章的时候查看这个 [demo 应用的源码](https://github.com/simplyaccessible/tv-db)来紧跟进度。

准备好让你的 React 应用对有障碍人士及所有类型的用户都可以使用吗？开始吧！

## HTML 属性及保留字

在 React 组件里些 HTML 的时候需要谨记的一点是 HTML 属性需要以驼峰式（`camelCase`）书写。这在一开始很让我吃惊，但我很快就习惯了。如果你最后不小心插入了一个全小写（`lowercase`）的属性，那就会在 JavaScript 控制台里得到一个友好的警告，让你将其调整为驼峰式。

举个例子，`tabindex` 这个属性需要写成 `tabIndex`（注意到大写的 “I” 字母）。这个规则的例外情况是任何 `data-*` 或 `aria-*` 类型的属性仍旧保持原来的写法。

还有一些[ JavaScript 保留字](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Reserved_keywords_as_of_ECMAScript_2015)，它们会匹配上一些特定的 HTML 属性名。这些属性就不能按照你所期望的方式来写：

* `for` 在 JavaScript 里是用来遍历项目的保留字。当在 React 组件里创建 `label` 元素的时候，你必须使用 `htmlFor` 属性来替代 `for`，从而明确地设置 `label` 和 `input` 的关系。
* `class` 也是 JavaScript 里的保留字。当需要在一个 HTML 元素上指派一个 `class` 属性来添加样式的时候，它必须替代写成 `className`。

可能会有更多的属性需要注意，但目前为止当 JavaScript 保留字和 HTML 属性发生冲突的时候我只发现了这两个属性。你有遇到过任何其他的冲突吗？把它们写在评论里，我们就将发布一个后续文章来展示完整的列表。

## 设置页面标题

因为 React 应用都是[单页面应用（SPA）](https://simplyaccessible.com/article/spangular-accessibility/))，`title` 元素将在整个浏览过程中显示相同的内容，这并不理想。

> 页面的 `title` 元素通常会是屏幕阅读器在页面加载的时候首先阅读的一块内容。

标题反映出页面内容是很重要的，因为那些依赖内容并首先接触到它的人就会知道接下来该期待什么。

在 React 应用里，`title` 元素的内容是在 `public/index.html` 文件里设置的，而且之后就不会再修改了。

我们可以通过在父组件里动态设置 `title` 元素的内容从而来解决这个问题，或者在所需“页面”里，通过给全局的 `document.title` 属性赋值来解决它。我们设置标题的地方是在 React 的 `componentWillMount()` [生命周期方法](https://reactjs.org/docs/react-component.html#the-component-lifecycle)。这个方法是让你在页面加载的时候运行一些代码片段。

举个例子，如果这是个“联系我们”的页面，上面有联系信息或者联系表单，我们就会像 `{[Home.js:23](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Home.js#L23)}` 这样调用 `componentWillMount()` 这个生命周期方法：

```
componentWillMount() {
  document.title = ‘Contact us | Site Name';
}
```

当这个组件“页面”加载时，可以看到浏览器选项卡上的标题更新到了 “Contact us | Site Name”。只需确保将上面代码加入所有页面组件里，就可以更新 `title` 元素了。

## 焦点管理（第一部分）

让我们来讨论一下焦点管理，这对于确保你的应用同时具备无障碍和成功的用户体验来说是一个很重要的因素。如果你的客户试图填满一个多“页面”表单，并且你没有对每个视图进行焦点管理，那么就很可能会导致用户的困扰，而且如果他们正在使用辅助技术，那么他们可能很难继续完成这个表单。你可能会为此完全失去他们成为客户的可能。

为了在组件内的特定元素上设置键盘焦点，你需要创建一个叫 “function ref” 的东西，或者简称 `ref`。如果你只是刚开始学习 React 的话，你可以认为 `ref` 就像是使用 jQuery 来选择 DOM 上的 HTML 元素，并将其缓存在一个变量里，比如： 

```
var myBtn = $('#myBtn');
```

而创建 `ref` 时一个独特的地方是它可以命名为任何东西（希望是能对你及团队其他开发者来说有意义的东西），并且它不依赖 `id` 或 `class` 来作为选择器。

举个例子，如果你有一个加载屏幕，那么将焦点发送到“加载”消息的容器以便屏幕阅读器读出当前应用的状态就会是理想的做法。在你的加载组件里，你可以创建一个 `ref` 指向加载容器 `{[Loader.js:29](https://github.com/simplyaccessible/tv-db/blob/master/src/components/Loader.js#L29)}`：

```
<div tabIndex="-1" ref="{(loadingContainer) => {this.loadingContainer = loadingContainer}}">
    <p>Loading…</p>
</div>
```

当这个组件渲染完成后，`function ref` 就会触发并通过创建一个新的类属性来创建这个元素的一个“引用”。在这个例子里，我们对 `div` 元素创建了一个叫 “loadingContainer” 的引用，并将其值通过 `this.loadingContainer = loadingContainer` 赋值语句传递给了一个新的类属性。

当组件加载 {[Loader.js:12](https://github.com/simplyaccessible/tv-db/blob/master/src/components/Loader.js#L12)} 的时候，我们在 `componentDidMount()` 生命周期钩子函数里使用 `ref`，明确地给“加载”容器设置焦点 ：

```
componentDidMount() {
    this.loadingContainer.focus();
}
```

当加载组件从视图中移除的时候，你可以使用不同的 `ref` 来在任何地方转移焦点。

管理焦点移动**到**一个元素，以及**从**一个元素转移到另一个元素，这是相当重要的，毫无夸大。在正确构建无障碍单页面应用的过程中，这是最大的挑战之一。

## 实时消息

在应用里使用实时消息来声明状态改变是一个很好方式。举个例子，当数据被添加到页面的时候，用某些辅助技术来通知用户是很有用的，比如屏幕阅读器，可以告诉用户发生了什么事情，以及现在有哪些项目是可用的。

让我们通过创建一个新的组件来创建一个控制实时声明的方法。我们将把这个新组件叫做：`Announcements`。

当这个组件被渲染的时候，`this.props.message` 的值将被注入到 `aria-live` 元素里，这在之后允许它被屏幕阅读器读出来。

这个组件看上去是一个像 `{[Announcements.js:12](https://github.com/simplyaccessible/tv-db/blob/master/src/components/Announcements.js#L12)}` 的东西：

```
import React from 'react';

class Announcements extends React.Component {
    render() {
        return (
            <div className="visuallyhidden" aria-live="polite" aria-atomic="true">
                {this.props.message}
            </div>
        );
    }
}

export default Announcements;
```

这个组件简单地创建了一个 `div` 元素，并加上了一些无障碍相关的属性：`aria-live` 和 `aria-atomic`。屏幕阅读器将读取这些属性并为使用应用的用户大声朗读 `div` 里的任何文本内容使其听见。`aria-live` 属性真的非常强大，请明智地使用它。

除此之外，一直在模板里渲染 `Announcement` 组件是很重要的，因为有些浏览器或屏幕阅读器技术在 `aria-live` 元素动态加载到 DOM 上的时候是不会朗读内容的。因此，在你的应用里，这个组件应该一直在任意父组件中引入。

你应该像 `{[Results.js:91](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Results.js#L91)}` 一样引入 `Announcement` 组件：

```
<Announcements message={this.state.announcementMessage} />
```

为了传递消息给这些 Announcement 组件，在父组件里需要创建一个状态属性，用于存放消息文本 `{[Results.js:22](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Results.js#L22)}`：

```
this.state = {
    announcementMessage: null
};
```

然后，在需要的时候更新状态，`{[Results.js:62](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Results.js#L62)}`：

```
this.setState({announcementMessage: `Total results found: ${data.length}`});
```

## 焦点管理（第二部分）

我们已经学习过关于用 `ref` 来管理焦点的内容，这是 React 里创建一个变量指向 DOM 元素的概念。现在，让我们来看一下另一种用同样概念实现的重要例子。

当链接到应用另外的页面时，你可以使用 HTML 的 `a` 元素。这样做的话，就会如同预期那样，导致整个页面的重载。但是，如果你在应用里使用 [React Router](https://reacttraining.com/react-router/) 的话，你就可以使用 `Link` 组件了。`Link` 组件在 React 应用里实际上取代了久经考验的 `a` 元素。

你会问，为什么你要用 `Link` 来替代**真正的** HTML 锚点链接？虽说在 React 组件里使用 HTML 链接是完全没问题的，但是使用 React Router 的 `Link` 组件可以让你的应用充分利用 React 虚拟 DOM 的优势。使用 `Link` 组件帮助我们更快地加载“页面”，因为在点击 `Link` 的时候浏览器不需要刷新了，但它们也有所限制。

> 当使用 `Link` 组件的时候，你需要搞清楚键盘焦点的位置，并知道当下个“页面”出现的时候焦点会去到哪里。

这里是我们的朋友 `ref` 来帮忙的地方。

### Link 组件

一个典型的 Link 组件看上去像下面这样：

```
<Link to='/home'>Home</Link>
```

这个语法看起来应该很熟悉，因为它和 HTML 的 `a` 元素非常相像；把 `a` 换成 `Link`，把 `href` 换成 `to` 就可以了。

如同我已经提到过的，使用 `Link` 组件替代 HTML 链接不会刷新浏览器。作为替代，React Router 会按照 `to` 属性描述的内容加载下个组件。

让我们来看一下如何确保键盘焦点会移动到合适的位置。

### 调整键盘焦点

当一个新页面加载的时候，键盘焦点需要明确地设置。否则，焦点会仍然在前一个页面，那么当某用户开始浏览到下一页面的时候，谁会知道焦点在哪里结束呢？我们应该如何显示地设置焦点？又要找我们的老朋友 `ref` 了。

#### 配置 ref

要决定焦点的走向，你需要检查组件是如何配置的，以及使用了哪些小部件。举个例子，如果你有一个“页面”组件，由许多子组件组成剩下的页面内容，那么你可能需要将焦点移动到页面最外层的父元素，有可能是一个 `div` 元素。从这里开始，用户就可以浏览页面内容的其他内容，就像经历了一次浏览器的整体刷新。

让我们来在最外层的父亲 `div` 上创建一个叫 `contentContainer` 的 `ref`，就像 `{[Details.js:84](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Details.js#L84)}`：

```
<div ref={(contentContainer) => { this.contentContainer = contentContainer; }} tabIndex="-1" aria-labelledby="pageHeading">
```

你可能已经注意到元素还包含 `tabIndex` 和 `aria-labelledby` 属性。通过 `ref` 的程序逻辑，`tabIndex` 设为 `-1` 将允许一般不可聚焦的 `div` 元素接受键盘焦点。

> 提示：就像焦点管理，有意地使用 `tabIndex="-1"` 并按照一个明确的计划来处理。

`aria-labelledby` 属性值将程序化地关联页面的标题（也许是一个 id 为 “pageHeading” 的 `h1` 或 `h2` 元素），来帮助描述当前键盘焦点位置的上下文。

既然我们创建了 `ref`，让我们来看看如何**真正地**使用它来转移焦点。

#### 使用 ref

之前我们学习了关于 `componentDidMount()` 的生命周期方法。当在 React 的虚拟 DOM 里加载页面时，我们可以再次使用它来转移键盘焦点，在 `{[Home.js:26](https://github.com/simplyaccessible/tv-db/blob/master/src/pages/Home.js#L26)}` 里使用我们之前在组件里创建的 `contentContainer` 和 `ref`：

```
componentDidMount() {
    this.contentContainer.focus();
}
```

上面的代码告诉 React：“在组件加载的时候，将键盘焦点转移到容器元素”。从这一点上，浏览会从页面的顶部开始，并且如果发生全页面刷新的话，内容就将是可以清楚看见的。

## React 的无障碍性代码分析器

写一篇关于 React 无障碍性的文章不得不提到那个难以置信的开源项目：[`eslint-plugin-jsx-a11y`](https://github.com/evcohen/eslint-plugin-jsx-a11y)。这是一个 [ESLint](https://eslint.org/) 插件，特别为 JSX 和 React 定制的，它会监视并报告你的代码里所有潜在的无障碍性问题。当你创建一个新的 React 项目时，它就会出现，所以你不需要担心任何设置问题。

举个例子，如果你在组件里引入一张图片而没有添加 `alt` 属性，那么你就会在浏览器开发者工具控制台里看到：

[![Screen capture of Chrome’s developer tools console. A warning message states, “img elements must have an alt prop, either with meaningful text, or an empty string for decorative images. (jsx-a11y/alt-text)”](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-console.png)](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-console.png)

像这样的消息在开发应用的时候真的非常有用。即便如此，在代码编辑器看到这些类型的消息总比在浏览器看到更好一些吧？下面介绍如何在编码环境安装及配置 `eslint-plugin-jsx-a11y` 使用。

### 安装 ESLint 插件

首先你需要为编辑器安装 ESLint 插件。在编辑器的插件库里搜索 “eslint” - 就有机会在那里找到可用的插件来安装。

下面是几个编辑器插件的快速链接：

* [Atom](https://atom.io/packages/linter-eslint)
* [Sublime Text](https://packagecontrol.io/packages/SublimeLinter-contrib-eslint)
* [VS Code](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.WebAnalyzer)

### 安装 eslint-plugin-jsx-a11y

下个步骤就是通过 `npm` 安装 `eslint-plugin-jsx-a11y`。只需运行以下命令即可安装它和 ESLint，并在编辑器里使用它：

```
npm install eslint eslint-plugin-jsx-a11y --save-dev
```

在这个命令运行完后，更新项目里的 `.eslintrc` 文件，接着 ESLint 就可以使用这个 `eslint-plugin-jsx-a11y` 插件了。

### 更新 ESLint 配置

如果在项目的根目录里没有 `.eslintrc` 文件，可以轻易地以这个文件名创建一个新文件。查看[如何配置 `.eslintrc` 文件](https://eslint.org/docs/user-guide/configuring)，以及一些可以添加配置 ESLint 的[规则](https://eslint.org/docs/rules/)，以此满足项目的需求。

在 `.eslintrc` 文件创建好之后，打开它进行编辑并在 “plugins” 部分添加下面的代码 {[.eslintrc:43](https://github.com/simplyaccessible/tv-db/blob/master/.eslintrc#L43)}：

```
"plugins": [
    "jsx-a11y"
]
```

这段代码告诉 ESLint 的本地实例在分析项目文件的时候使用 `jsx-a11y` 插件。

为了让 ESLint 在代码里找到无障碍相关的特定错误，我们还需要指定 ESLint 使用的规则集。你可以配置自己的规则，但我推荐至少一开始使用默认的集合。

把下面的代码添加到 `.eslintrc` 文件的 “extends” 部分 `{[.eslintrc:47](https://github.com/simplyaccessible/tv-db/blob/master/.eslintrc#L47)}`：

```
"extends": [
    "plugin:jsx-a11y/recommended"
]
```

这一行告诉 ESLint 使用默认推荐的规则集合，并且我发现非常好用。

在完成这些编辑及重启编辑器之后，在出现无障碍相关问题的时候，你应该就可以看到一些类似下面截图的提示：

[![Screen capture of Atom text editor. A warning message appears overtop of some code with the following message, “img elements must have an alt prop, either with meaningful text, or an empty string for decorative images. (jsx-a11y/alt-text)”](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-atom.png)](http://simplyaccessible.com/wordpress/wp-content/uploads/2017/10/creating-accessible-react-apps-atom.png)

## 继续编写语义化 HTML

在 [“Thinking in React” 帮助文档](https://reactjs.org/docs/thinking-in-react.html)里，鼓励读者去创建组件模块，或者组件驱动开发，编写小型、可复用的代码片段。这么做的好处是可以在不同项目之间复用代码。想象一下，在某个站点创建了一个无障碍部件，然后如果在另一个站点需要同样的部件，只需复制粘贴代码！

从这里可以看出，你通过模块套模块创建出更大的组件来构建你的 UI，然后最终拼凑成一个“页面”。起初这可能会带来一些学习曲线，但不久你就会习惯以这种方式思考，并最终在编写 HTML 的时候享受这种分解过程。

> 因为 React 的组件使用 [ES6 的类](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Classes)组成，所以继续编写良好、干净的语义化 HTML 取决于你自己（是否掌握 ES6）。 

正如我们之前在文中提到的那样，有一些保留字需要注意，如 `htmlFor` 和 `className`，但除此之外，作为开发人员，你仍然有责任按照通常的方式编写和测试 HTML UI 界面。

另外，还可以在适当的时候通过 JSX 在 HTML 里写入 JavaScript。这将大大有助于应用更具动态性和无障碍性。

## 结论

你现在已经完全有能力使 React 应用变得更加无障碍！
你学到的知识有：

* 更新页面 `title`，让用户在应用里保持方向感并明白每个视图内容的目的；
* 管理键盘焦点，以便用户可以顺利地跟随动态内容变化，而不会迷失或迷惑刚刚发生了什么； 
* 创建一个实时消息组件，提醒用户任何重要的状态变化；
* 以及，在项目里加入代码分析，以便你可以在工作的时候及时捕获无障碍性错误。

也许与网页开发人员分享的最好的无障碍性提示就是：在做任何静态、CMS 或基于框架的网站时，在模板里[编写语义化 HTML](https://simplyaccessible.com/article/listening-web-part-two-semantics/)。在创建用户界面应该选择什么元素时，React 不会成为你的拦路虎。这完全取决于你自己，亲爱的开发者，确保你自己创建的内容尽可能对大部分用户来说是有用且无障碍的。

你有没有发现过其他方式来创建更具无障碍性的 React 应用？我十分乐意在评论里听到它们！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
