>* 原文链接 : [HOMEBLOG React JS: newbies tutorial](http://www.leanpanda.com/blog/2016/04/06/react-newbies-tutorial/)
* 原文作者 : Elise Cicognani
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [markzhai](https://github.com/markzhai)
* 校对者:



正如你能从标题猜到的，这篇文章的目标是给那些有很少编程经验的读者的。比如，像我这样的人：因为迄今为止，我才探索了变成编程世界6个月。**所以，这将是一篇新手村教程！** 你只需要拥有对HTML和CSS的理解，以及基本的JavaScript (JS) 知识就能看懂本文。

注意：在接下来的例子中，我们将会利用ES6提供的新能力，来简化写JS代码的过程。然而，你也能完全使用ES5来写React。

预计阅读时间9分钟


### 什么是React?

React是一个JS库，由Facebook和Instagram创建([https://facebook.github.io/react/](https://facebook.github.io/react/))。它通过将应用分为一些动态的，可复用的 **组件**，来使我们可以创建单页应用([Single Page Applications (SPA)](http://www.leanpanda.com/blog/2015/05/25/single-page-application-development/))。

一个React组件是一个继承了由React提供的 **Component** 的JS类。一个组件代表并定义了一块HTML代码，以及任何与这块代码相关的行为，比如点击函数。组件就像是乐高积木，可以用来组建成所需的复杂应用。完全由JS代码构成的组件，可以被隔离和复用。基本方法是 **render()**，它简单地返回一片HTML代码。

用来定义React组件的语法被称为 **JSX**。该语法由React的创建者们所开发，被用来简化JS-HTML代码的组件内交互。使用该语法写的代码在变成实际JS代码前必须被编译。

### 创建一个组件(component)

为了创建我们的组件并将它渲染为一页HTML，我们首先需要定义一个有唯一id的div，在我们的HTML文件里。接着，我们将要在JSX文件里写代码，以连接React组件到使用其id的div，如下面的例子所示。这样做将会指导浏览器在相关DOM标签所在的页面渲染组件。

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/XXdmvL/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/XXdmvL/"&gt;Start&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [Start](http://codepen.io/makhenzi/pen/XXdmvL/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

JSX内的HTML标签属性和普通HTML内的是几乎一样的；唯一不同的是“class”，在JSX里面变成了“className”。类HTML语法使用圆括号闭合，而包含JS的块则使用尖括号闭合。正如你将看到的。render() _总_ 会返回一个div，而在其中开发者可以自由包括他们认为合适的任意多的标签和元素。

## 例子：海盗的灭绝

![](http://ww4.sinaimg.cn/large/a490147fjw1f2x94p1ev2j20m80etjtt.jpg)

如果我们选择使用React来创建这张图，我们将可以可视化屏幕上不同的日期，并在那些日期被点击的时候，才显示对应的温度和海盗数量。

为此我们需要2个组件：第一个用来渲染日期，并链接每个日期到给定数量的海盗和某个温度；第二个则需要用来接收日期上的点击事件对应的信息，如海盗的数量，当时的温度，接着基于这些数据渲染选择的元素。

前者将会扮演为“父亲(parent)”，并包含到多个后者“子”组件的链接，而后者则紧密依赖于它们的“父亲”。

React结构，被称为[虚拟DOM](https://facebook.github.io/react/docs/working-with-the-browser.html)，可以使我们在组件的内容发生改变的时候，不需要刷新整个页面，而可以只更新对应组件。

## 状态(State)和属性(props)

在我们的例子里，独立的变量数据是由日期组成的。这些会根据点击事件所集合的DOM内连锁反应进而根据对应海盗、温度信息而进行改变。所以我们将会根据每个“DATA”对象内的对应日期去保存信息。我们还将利用React在父组件内的 `this.state={}` 属性来以键值对拷贝形式保存变量数据的。

以这种形式组织程序使得我们可以利用React提供的方法，来以“状态(state)”的形式和数据交互，并对其进行任意更改。

考虑到我们想要使用DATA对象的key来渲染HTML内的日期，最好可以找到一种方法来在key上使用JS的 `map()` 方法([Array.prototype.map()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map))，以便能直接显示返回到 `render()` 的HTML。事实上确实有方法可以做到！我们只需要把JS代码包裹在双花括号里，并放置在想要代码输出显示的管理该组件的DOM块内，然后就好了。

在这个特殊例子中，我们将在组件内的方法里定义 `map()` 回调，其将在同一组件的`render()`内返回一片HTML代码。

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/XXdmvL/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/XXdmvL/"&gt;Start&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [State1](http://codepen.io/makhenzi/pen/qbZbxR/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

为了分配点击事件到每个日期，我们将会分配 `onClick` 属性给它们。

在该属性中，我们会调用组件的方法，该方法则会定义我们希望在onClick事件后触发的状态修改和其他变更。

在我们的例子里，我们定义该函数为 `handleClick()`。在 handleClick() 中，我们会调用React方法 `setState()`，其允许我们在在每个点击事件中去更改状态数据。我们只需要插入一个包含我们想要修改的状态key的对象，并在后者括号内分配给它们新的相关联值。

总的来说，每次一个日期被点击，被选中的div的onClick属性会调用 `HandClick()` 方法，该方法会调用 setState() 方法来修改组件的状态。

每次状态改变，一旦发生React就会自动检查组件的 `render()` 函数的返回，以寻找基于新状态需要更新的内容。一旦有那样的数据，React就会自动触发一次新的 `render()` 来更新那些有变更的HTML片段。

(我很抱歉，在接着的例子里，我插入了三行利用了Classnames的代码，一个用来基于状态变更来做CSS管理的小工具，我这么做只是为了给预览一点颜色。我还会使用它在最终的例子里给预览填充一些海盗变量。你可以找到GitHub上Classnames仓库的链接，还有一个[简要使用向导](https://github.com/JedWatson/classnames))

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/EPKwRo/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/EPKwRo/"&gt;State2&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [State2](http://codepen.io/makhenzi/pen/EPKwRo/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

如此，我们的父组件状态已经被设定好根据选中数据去创建子组件（其将会描述海盗数量和对应温度）。

我们将会在JSX文件中创建子组件的实例，正如我们之前对父组件所做的。为了链接子组件到其父亲上，我们只需要在后者的 `render()` 函数使用同一种语法和一个HTML标签去定义关系。如果我们称它为“Child”，它将会在我们插入 `<Child />`处所在的HTML块内出现。

我们的子组件还必须根据现在选中数据所关联的海盗和温度，传递数据到其父亲。为此，我们将利用赋给Child标签的属性，其名字可以随便取，其信息只对父组件可见。

如此一来，子组件将可以通过显式访问归属于其父组件的数据，即利用这些“attribute-bridges”，或者 **属性(props)**，来获取到它自己内部信息的访问权。

所以，每次父组件的状态发生改变，其儿子的属性内容就会自动进行更新。但是，正如子组件的`render()`方法会显示属性内容，它也会基于单向的数据线性流，根据任何收到的新信息去进行更新。

<iframe height="266" scrolling="no" src="//codepen.io/makhenzi/embed/EPKbmO/?height=266&amp;theme-id=0&amp;default-tab=js,result&amp;embed-version=2" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen &lt;a href="http://codepen.io/makhenzi/pen/EPKbmO/"&gt;Props&lt;/a&gt; by Makhenzi (&lt;a href="http://codepen.io/makhenzi"&gt;@makhenzi&lt;/a&gt;) on &lt;a href="http://codepen.io"&gt;CodePen&lt;/a&gt;.</iframe>

See the Pen [Props](http://codepen.io/makhenzi/pen/EPKbmO/) by Makhenzi ([@makhenzi](http://codepen.io/makhenzi)) on [CodePen](http://codepen.io).

搞定了！组件们会互相交互，并根据我们的点击在DOM里渲染不同数据，而不需要单页去进行刷新。以这个为基础，交互的复杂性和组件的数量可以按需增加，使我们能创建复杂高效的应用。

如果你被这个库的潜力启发了，[不妨看看react.rocks网站](https://react.rocks/)，在那里你会找到很多有趣的点子来帮助你开始。(:
