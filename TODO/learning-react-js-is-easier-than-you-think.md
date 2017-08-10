
> * 原文地址：[Learning React.js is easier than you think](https://edgecoders.com/learning-react-js-is-easier-than-you-think-fbd6dc4d935a)
> * 原文作者：[Samer Buna](https://edgecoders.com/@samerbuna)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/learning-react-js-is-easier-than-you-think.md](https://github.com/xitu/gold-miner/blob/master/TODO/learning-react-js-is-easier-than-you-think.md)
> * 译者：[Cherry](https://github.com/sunshine940326)
> * 校对者：

# 学习 React.js 比你想象的要简单

## 通过 Medium 中的一篇文章来学习 React.js 的基本原理

![](https://cdn-images-1.medium.com/max/1600/1*YsPpBr_PgtyTR6CFDmKU9g.png)

你有没有注意到在 React 的 logo 中 有一个 Star of David（犹太教的六芒星形）？只是说。。。（这里不知道怎么翻译 Just saying 合适，校对者给个意见）
去年我写了一个简短的书关于学习 React.js，有 100 页左右。今年，我要挑战自己 —— 总结出中的一篇文章向 Medium 投稿。

这篇文章不是讲什么是 React 或者 [你该怎样学习React](https://medium.freecodecamp.org/yes-react-is-taking-over-front-end-development-the-question-is-why-40837af8ab76)。这是在已经熟悉 React.js 基本原理 —— JavaScript 和 [DOM API](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model) 之后的实用介绍。

> 本文采用嵌入式 jsComplete 代码段，所以为了方便阅读需要一个合适的屏幕宽度。

下面所有的代码都是参考代码。他们也纯粹是为了表达概念而提供的例子。他们中的大多数可以用更好的方式。

您可以编辑和执行下面的任何代码段。使用**Ctrl+Enter**执行代码。每一段的右下角有一个链接到编辑/运行代码全屏在[jsComplete/repl](https://jscomplete.com/repl).

---

#### 1 React 全部都是组件

React 是围绕可重用组件的概念设计的。你定义小组件并将它们组合在一起形成更大的组件。

无论大小，所有组件都是可重用的，甚至在不同的项目中也是如此。

React 组件最简单的形式，这是一个普通的 JavaScript 函数：

```
function Button (props) {
  // 这里返回一个 DOM 元素，例如：
  return <button type="submit">{props.label}</button>;
}
// 将按钮组件呈现给浏览器
ReactDOM.render(<Button label="Save" />, mountNode)
```

例 1：编辑上面的代码并按 Ctrl+Enter 键执行

> 括号中的 button 标签将稍后解释。现在不要担心它们。`ReactDOM` 也将稍后解释，但如果你想测试这个例子和所有接下来的例子，上述 `render` 函数是必须的。（React 将要接管和控制的是 `ReactDOM.render` 的第 2 个参数即目标 DOM 元素）。

例 1 的注意事项：

- 组件名称首字母大写，是一个 `Button` 元素。必须要这样做因为我们将处理 HTML 元素和 React 元素的混合。小写名称保留为 HTML 元素。事实上，将 React 组件命名为 “button” 然后你就会发现 ReactDOM 会忽略这个函数，仅仅是将其作为一个普通的空的 HTML 按钮来渲染。
- 每个组件都接收一个属性列表，就像 HTML 元素一样。在 React 中，这个列表被称为**属性**。虽然你可以将一个函数随意命名。
- 在上面组件中的 `Button` 函数中，我们在返回的输出中写看上去像是 HTML 的代码会很奇怪，这是 JavaScript 而不是 HTML，老实说，这甚至不是 React.js。然而它非常流行，以至于成为 React 应用程序中的默认值。这就是所谓的 [*JSX*](https://facebook.github.io/jsx/) ，这是一个JavaScript的扩展。JSX 也是一个**折中方案**！继续尝试并在上面的函数中返回其他 HTML 元素，看看它们是如何被支持的（例如，返回一个文本输入元素）。

#### 2 JSX 输出的是什么？

上面的例 1 可以用没有 JSX 的纯 React.js 编写，如下：

```
function Button (props) {
  return React.createElement(
    "button",
    { type: "submit" },
    props.label
  );
}

// 使用 Button，你将会做这样做
ReactDOM.render(
  React.createElement(Button, { label: "Save" }),
  mountNode
);
```

例 2：不使用 JSX 编写 React 组件

在 React 顶级 API 中，`createElement` 函数是主函数。这是你需要学习的 7 个 API 中的 1 个。React 的 API 就是这么小。

就像 DOM 本身具有 `document.createElement` 函数可以通过标签名称来创建一个指定元素一样， React 的 `createElement` 函数是一个高级函数，有和 `document.createElement` 同样的功能，但它也可以被用来创建一个元素代表一个 React 组件。当我们使用上面例 2 中的按钮组件时，我们使用的是后者。

不像 `document.createElement`，React 的 `createElement` 在第二个代表创建元素的**子元素**在接受一个动态参数之后。所以 `createElement` 实际上创造了一个**树**。

这里就是这样的一个例子：

```
const InputForm = React.createElement(
  "form",
  { target: "_blank", action: "https://google.com/search" },
  React.createElement("div", null, "Enter input and click Search"),
  React.createElement("input", { className: "big-input" }),
  React.createElement(Button, { label: "Search" })
);

// InputForm 使用 Button 组件，所以我们需要这样做：
function Button (props) {
  return React.createElement(
    "button",
    { type: "submit" },
    props.label
  );
}

// 然后我们可以直接使用 InputForm 通过 .render 方法
ReactDOM.render(InputForm, mountNode);
```
例 3：React 创建元素的 API

上面例子中的一些事情值得注意：

- `InputForm` 不是一个 React 组件；它仅仅是一个 React **元素**。这就是为什么我们可以在 `ReactDOM.render` 中直接使用它并且可以在调用时不使用 `<InputForm />` 的原因。
- `React.createElement` 函数接收多个参数后的前两个。从参数列表的第三开始包含创建元素的子列表。
- 我们可以调用 `React.createElement` 因为它是 JavaScript。
- `React.createElement` 的第二个参数可以为空或者是一个空对象，当这个元素不需要属性或方法时。
- 我们可以在 React 组件中混合 HTML 元素。你可以将 HTML 元素作为内置的 React 组件。
- React 的 API 试图和 DOM API 一样，这就是为什么我们使用 `className` 代替 `class` 为输入元件的原因。我们都希望如果 React 的 API 成为 DOM API 本身的一部分，因为，你知道，它要好得多。

上述的代码是当你引入 React 库的时候浏览器是怎样理解的。浏览器不会处理任何的 JSX 业务。然而，我们更喜欢看到和使用 HTML 而不是那些 `createElement` 调用（想象一下只使用 `document.createElement` 构建一个网站，你可以的！）。这就是 JSX 存在的原因。取代上述调用 `React.createElement` 的方式，我们可以使用一个非常简单类似于 HTML 的语法：

```
const InputForm =
  <form target="_blank" action="https://google.com/search">
    <div>Enter input and click Search</div>
    <input className="big-input" name="q" />
    <Button label="Search" />
  </form>;

// InputForm “仍然”使用 Button 组件，所以我们也需要这样。
// JXS 或者普通的表单都会这样做
function Button (props) {
  // 这里返回一个 DOM 元素。例如：
  return <button type="submit">{props.label}</button>;
}

// 然后我们可以直接通过 .render 使用 InputForm
ReactDOM.render(InputForm, mountNode);
```

例 4：为什么在 React 中 JSX 受欢迎（和例 3 相比）

注意上面的几件事：

- 这不是 HTML 代码。比如，我们仍然可以使用 `className` 代替 `class`。
- 我们仍在考虑怎样让上述的 JavaScript 看起来像是 HTML。看一下我在最后是怎样添加的。

我们在上面（例 4）中写的就是 JSX。然而，我们要将编译后的版本（例 3）给浏览器。要做到这一点，我们需要使用一个预处理器将 JSX 版本转换为 `React.createElement` 版本。

这就是 JSX。这是一种折中的方案，允许我们用类似 HTML 的语法来编写我们的 React 组件，这是一个很好的方法。

> “Flux” 在头部作为韵脚来使用，但它也是一个非常受欢迎的 [应用架构](https://facebook.github.io/flux/)，由 Facebook 推广。最出名的是 Redux，Flux 和 React 非常合适。

JSX，可以自己使用，不仅仅适用于 React。

#### 3 你可以再 JavaScript 的任何地方使用 JSX

在 JSX 中，你可以在一对花括号内使用任何 JavaScript 表达式。

```
const RandomValue = () =>
  <div>
    { Math.floor(Math.random() * 100) }
  </div>;

// 使用：
ReactDOM.render(<RandomValue />, mountNode);
```

例 5：在 JSX 中使用 JavaScript 表达式

任何 JavaScript 表达式可以直接放在花括号中。这相当于在 JavaScript 中插入 `${}` [模板](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)。

这是 JSX 内唯一的约束：只有表达式。例如，你不能使用 `if` 语句，但三元表达式是可以的。

JavaScript 变量也是表达式，所以当组件接受属性列表时（不包括 `RandomValue` 组件，`props` 是可选择的），你可以在花括号里使用这些属性。我们在上述（例 1）的 `Button` 组件是这样使用的。

JavaScript 对象也是表达式。有些时候我们在花括号中使用 JavaScript 对象，这看起来像是使用了两个花括号，但是在花括号中确实只有一个对象。其中一个用例就是将 CSS 样式对象传递给响应中的特殊样式属性：

```
const ErrorDisplay = ({message}) =>
  <div style={ { color: 'red', backgroundColor: 'yellow' } }>
    {message}
  </div>;

// 使用
ReactDOM.render(
  <ErrorDisplay
    message="These aren't the droids you're looking for"
  />,
  mountNode
);
```
例 6：一个对象传递特殊的 React 样式参数

注意我**解构**的只是在属性参数之外的信息。这只是 JavaScript。还要注意上面的样式属性是一个特殊的属性（同样，它不是 HTML，它更接近 DOM API）。我们使用一个对象作为样式属性的值并且这个对象定义样式就像我们使用 JavaScript 那样（我们可以这样做）。

你可以在 JSX 中使用 React 元素。因为这也是一个表达式（记住，一个 React 元素只是一个函数调用）：

```
const MaybeError = ({errorMessage}) =>
  <div>
    {errorMessage && <ErrorDisplay message={errorMessage} />}
  </div>;

// MaybeError 组件使用 ErrorDisplay 组件
const ErrorDisplay = ({message}) =>
  <div style={ { color: 'red', backgroundColor: 'yellow' } }>
    {message}
  </div>;

// 现在我们使用 MaybeError 组件：
ReactDOM.render(
  <MaybeError
    errorMessage={Math.random() > 0.5 ? 'Not good' : ''}
  />,
  mountNode
);
```

例 7：一个 React 元素是一个可以通过 {} 使用的表达式

上述 `MaybeError` 组件只会在有 `errorMessage` 传入或者另外有一个空的 `div` 才会显示 `ErrorDisplay` 组件。React 认为 `{true}`、 `{false}`
`{undefined}` 和 `{null}` 是有效元素，不呈现任何内容。

我们也可以在 JSX 中使用所有的 JavaScript 的集合方法（`map`、`reduce` 、`filter`、 `concat` 等）。因为他们返回的也是表达式：

```
const Doubler = ({value=[1, 2, 3]}) =>
  <div>
    {value.map(e => e * 2)}
  </div>;

// 使用下面内容 
ReactDOM.render(<Doubler />, mountNode);
```

例 8：在 {} 中使用数组

请注意我是如何给出上述 `value` 属性的默认值的，因为这全部都只是 JavaScript。注意我只是在 div 中输出一个数组表达式。React 是完全可以的。它只会在文本节点中放置每一个加倍的值。

#### 4 你可以使用 JavaScript 类写 React 组件

简单的函数组件非常适合简单的需求，但是有的时候我们需要的更多。React 也支持通过使用 [JavaScript 类](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes)来创建组件。这里 `Button` 组件（在例 1 中）就是使用类的语法编写的。

```
class Button extends React.Component {
  render() {
    return <button>{this.props.label}</button>;
  }
}

// 使用（相同的语法）
ReactDOM.render(<Button label="Save" />, mountNode);
```

例 9：使用 JavaScript 类创建组件

类的语法是非常简单的：定义一个扩展的 `React.Component` 类（另一个你需要学习的 React 的顶级 API）。该类定义了一个单一的实例函数 —— `render()`，并使函数返回虚拟 DOM 对象。每一次我们使用基于类的 `Button` 组件（例如，通过 `<Button ... />`）,React 将从这个基于类的组件中实例化对象，并在 DOM 树中使用该对象。

这就是为什么上面的例子中我们可以在 JSX 中使用 `this.props.label` 渲染输出的原因，因为每一个组件都有一个特殊的称为 `props` 的 **实例** 属性，这让所有的值传递给该组件时被实例化。

由于我们有一个与组件的单个使用相关联的实例，所以我们可以按照自己的意愿定制该实例。例如，我们可以通过使用常规 JavaScript 构造函数来构造它：

```
class Button extends React.Component {
  constructor(props) {
    super(props);
    this.id = Date.now();
  }
  render() {
    return <button id={this.id}>{this.props.label}</button>;
  }
}

// 使用
ReactDOM.render(<Button label="Save" />, mountNode);
```

例 10：自定义组件实例

我们也可以定义类的原型并且在任何我们希望的地方使用，包括在返回的 JSX 输出的内部：

```
class Button extends React.Component {
  clickCounter = 0;

  handleClick = () => {
    console.log(`Clicked: ${++this.clickCounter}`);
  };

  render() {
    return (
      <button id={this.id} onClick={this.handleClick}>
        {this.props.label}
      </button>
    );
  }
}

// 使用
ReactDOM.render(<Button label="Save" />, mountNode);
```

例 11：使用类的属性（通过单击保存按钮进行测试）

注意上述例 11 中的几件事情

- `handleClick` 函数使用 JavaScript 新提出的 [class-field syntax](https://github.com/tc39/proposal-class-fields) 语法。这仍然是 stage-2，但是这是访问组件安装实例（感谢箭头函数）最好的选择（因为很多原因）。然而，你需要使用类似 Babel 的编译器解码为 stage-2（或者仅仅是类字段语法）来让上述代码工作。 jsComplete REPL 有预编译功能。

```
// 错误：
onClick={this.handleClick()}

// 正确：
onClick={this.handleClick}
```

#### 5 React 中的事件：两个重要的区别

当处理 React 元素中的事件时，我们与 DOM API 的处理方式有两个非常重要的区别：

- 所有 React 元素属性（包括事件）都使用 **camelCase** 命名，而不是 **camelCase**。例如是 `onClick` 而不是 `onClick`。
- 我们将实际的 JavaScript 函数引用传递给事件处理程序，而不是字符串。例如是 `onClick={**handleClick**}` 而不是 `onClick="**handleClick"**`。

React 用自己的对象包装 DOM 对象事件以优化事件处理的性能，但是在事件处理程序内部，我们仍然可以访问 DOM 对象上所有可以访问的方法。React 将经过包装的事件对象传递给每个调用函数。例如，为了防止表单提交默认提交操作，你可以这样做：


```
class Form extends React.Component {
  handleSubmit = (event) => {
    event.preventDefault();
    console.log('Form submitted');
  };

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <button type="submit">Submit</button>
      </form>
    );
  }
}

// 使用
ReactDOM.render(<Form />, mountNode);
```

例 12：使用包装过的对象

#### 6 每一个 React 组件都有一个故事：第 1 部分

以下仅适用于类组件（扩展 `React.Component`）。函数组件有一个稍微不同的故事。

1. 首先，我们定义了一个模板来创建组件中的元素。
2. 然后，我们在某处使用 React。例如，在 `render` 内部调用其他的组件，或者直接使用 `ReactDOM.render`。
3. 然后，React 实例化一个对象然后给它设置**props**然后我们可以通过 `this.props` 访问。这些属性都是我们在第 2 步传入的。
4. 因为这些全部都是 JavaScript，`constructor` 方法将会被调用（如果定义的话）。这是我们称之为的第一个：**组件生命周期方法**。
5. 接下来 React 计算渲染之后的输出方法（虚拟 DOM 节点）。
6. 因为这是 React 第一次渲染元素，React 将会与浏览器连通（代表我们使用 DOM API）来显示元素。这整个过程称为 **mounting**。
7. 接下来 React 调用另一个生命周期函数，称为 `componentDidMount`。我们可以这样使用这个方法，例如：在 DOM 上做一些我们现在知道的在浏览器中存在的东西。在此生命周期方法之前，我们使用的 DOM 都是虚拟的。
8. 一些组件的故事到此结束，其他组件得到卸载浏览器 DOM 中的各种原因。在后一种情况发生时，会调用另一个生命周期的方法，`componentWillUnmount`。
9. 任何 mounted 的元素的**状态**都可能会改变。该元素的父级可能会重新渲染。无论哪种情况，mounted 的元素都可能接收到不同的属性集。React 的魔力就在这里发生，我们实际上需要 React 在这一点上！在这一点之前，说实话，我们并不需要 React。
10. 组价的故事还在继续，但是在此之前，我们需要理解我所说的这种**状态**。

#### 7 React 组件可以具有私有状态

以下只适用于类组件。我有没有提到有人叫表象而已的部件**dumb**？

状态类是任何 React 类组件中的一个特殊字段。React 检测每一个组件状态的变化，但是为了 React 更加有效，我们必须通过 React 的另一个 API 改变状态字段，这就是我们要学习的另一个 API —— `this.setState`：


```
class CounterButton extends React.Component {
  state = {
    clickCounter: 0,
    currentTimestamp: new Date(),
  };

  handleClick = () => {
    this.setState((prevState) => {
     return { clickCounter: prevState.clickCounter + 1 };
    });
  };

  componentDidMount() {
   setInterval(() => {
     this.setState({ currentTimestamp: new Date() })
    }, 1000);
  }

  render() {
    return (
      <div>
        <button onClick={this.handleClick}>Click</button>
        <p>Clicked: {this.state.clickCounter}</p>
        <p>Time: {this.state.currentTimestamp.toLocaleString()}</p>
      </div>
    );
  }
}

// 使用
ReactDOM.render(<CounterButton />, mountNode);
```

例 13：setState 的 API

这可能是最重要的一个例子因为这将是你完全理解 React 基础知识的方式。这个例子之后，还有一些小事情需要学习，但从那时起主要是你和你的 JavaScript 技能。

让我们来看一下例 13，从类开始，总共有两个，一个是一个初始化的有初始值为 `0` 的 `clickCounter` 对象和一个从 `new Date()` 开始的 `currentTimestamp`。

另一个类是 `handleClick` 函数，在渲染方法中我们给按钮元素传入 `onClick` 事件。通过使用 `setState` 的 `handleClick` 方法修改了组件的实例状态。要注意到这一点。

另一个我们修改状态的地方是在一个内部的定时器，开始在内部的 `componentDidMount` 生命周期方法。它每秒钟调用一次并且执行另一个函数调用 `this.setState`。

在渲染方法中，我们使用具有正常读语法的状态上的两个属性（没有专门的 API）。

现在，注意我们更新状态使用两种不同的方式： 

1. 通过传入一个函数然后返回一个对象。我们在 `handleClick` 函数内部这样做。
2. 通过传入一个正则对象，我们在在区间回调中这样做。

这两种方式都是可以接受的，但是当你同时读写状态时，第一种方法是首选的（我们这样做）。在区间回调中，我们只向状态写入而不读它。当有问题时，总是使用第一个函数作为参数语法。伴随着竞争条件这更安全，因为 `setstate` 实际上是一个异步方法。

我们应该怎样更新状态呢？我们返回一个有我们想要更新的的值的对象。注意，在调用 `setState` 时，我们全部都从状态中传入一个属性或者全都不。这完全是可以的因为 `setState` 实际上 **合并** 了你通过它（返回值的函数参数）与现有的状态，所以，没有指定一个属性在调用 `setState` 时意味着我们不希望改变属性（但不删除它）。

[![](https://ws4.sinaimg.cn/large/006tNc79gy1fi6sqg2ygbj31320dawg9.jpg)](https://twitter.com/samerbuna/status/870383561983090689)

#### 8 React 将要反应

React 的名字是从状态改变的**反应**中得来的（虽然没有反应，但也是在一个时间表中）。这里有一个笑话，React 应该被命名为**Schedule**！

然而，当任何组件的状态被更新时，我们用肉眼观察到的是对该更新的反应，并自动反映了浏览器 DOM 中的更新（如果需要的话）。

将渲染函数的输入视为两种：
- 通过父元素传入的属性
- 以及可以随时更新的内部私有状态

当渲染函数的输入改变时，输出也会改变。

React 保存了渲染的历史记录，当它看到一个渲染与前一个不同时，它将计算它们之间的差异，并将其有效地转换为在 DOM 中执行的实际 DOM 操作。

#### 9 React 是你的代码

您可以将 React 看作是我们用来与浏览器通信的代理。以上面的当前时间戳显示为例。取代每一秒我们都需要手动去浏览器调用 DOM API 操作来查找和更新 `p#timestamp` 元素，我们仅仅改变组件的状态属性， React 做的工作代表我们与浏览器的通信。我相信这就是为什么 React 这么受欢迎的真正原因；我们只是不喜欢和浏览器先生谈话（以及它所说的 DOM 语言的很多方言），并且 React 自愿传递给我们，免费的！

#### 10 每一个 React 组件都有一个故事：第 2 部分

现在我们知道了一个组件的状态，当该状态发生变化的时候，我们来了解一下关于这个过程的最后几个概念。


1. 当组件的状态被更新时，或者它的父进程决定更改它传递给组件的属性时，组件可能需要重新渲染。
2. 如果后者发生，React 会调用另一个生命周期方法：`componentWillReceiveProps`。
3. 如果状态对象或传递的属性改变了，React 有一个重要的决定要做：组件是否应该在 DOM 中更新？这就是为什么它调用另一个重要的生命周期方法 `shouldComponentUpdate` 的原因 。此方法是一个实际问题，因此，如果需要自行定制或优化渲染过程，则必须通过返回 true 或 false 来回答这个问题。
4. 如果没有自定义 `shouldComponentUpdate`，React 的默认事件在大多数情况下都能处理的很好。
5. 首先，这个时候会调用另一生命周期的方法：`componentWillUpdate`。然后，React 将计算新渲染过的输出，并将其与最后渲染的输出进行对比。
6. 如果渲染过的输出和之前的相同，React 不进行处理（不需要和浏览器先生对话）。
7. 如果有不同的地方，React 将不同传达给浏览器，像我们之前看到的那样。
8. 在任何情况下，一旦一个更新程序发生了，无论以何种方式（即使有相同的输出），React 会调用最后的生命周期方法：`componentDidUpdate`。

生命周期方法是逃生舱口。如果你没有做什么特别的事情，你可以在没有它们的情况下创建完整的应用程序。它们非常方便地分析应用程序中正在发生的事情，并进一步优化 React 更新的性能。

---

信不信由你，通过上面所学的知识（或部分知识），你可以开始创建一些有趣的 React 应用程序。如果你渴望更多，看看我的[**Pluralsight 的 React.js入门课程**](https://www.pluralsight.com/courses/react-js-getting-started?aid=701j0000001heIoAAI&amp;promo=&amp;oid=&amp;utm_source=google&amp;utm_medium=ppc&amp;utm_campaign=US_Dynamic&amp;utm_content=&amp;utm_term=&amp;gclid=CNOAj_2-j9UCFUpNfgod4V0Fdg).

**感谢阅读。如果您觉得这篇文章有帮助，请点击下面。跟着我下面的 React.js 和 JavaScript 的更多文章**

---

我 [Pluralsight](https://app.pluralsight.com/profile/author/samer-buna) 和 [Lynda](https://www.lynda.com/Samer-Buna/7060467-1.html) 创建了在线课程。我最新的文章在[Advanced React.js](https://www.pluralsight.com/courses/reactjs-advanced)、 [Advanced Node.js](https://www.pluralsight.com/courses/nodejs-advanced) 和  [Learning Full-stack JavaScript](https://www.lynda.com/Express-js-tutorials/Learning-Full-Stack-JavaScript-Development-MongoDB-Node-React/533304-2.html)中。我也做小组的在线和现场培训，覆盖初学者在高级 JavaScript 和 Node.js、 React.js、 and GraphQL。如果你需要一个导师，[请来找我](mailto:samer@jscomplete.com) 。如果你对此篇文章或者我写的其他任何文章有疑问，[通过这个联系我](https://slack.jscomplete.com/)，并且在 #questions 中提问.

---

感谢很多读者检验和改进的文章，Łukasz Szewczak、Tim Broyles、 Kyle Holden、 Robert Axelse、 Bruce Lane、Irvin Waldman 和 Amie Wilt.

特别要感谢“惊人的” [Amie](https://www.linkedin.com/in/amiewilt/)，经验是一个实际的 [Unicorn](https://medium.com/@katherinemartinez/the-unicorn-hybrid-designer-developer-5e89607d5fe0)。有你们的帮助，我真的很感激。谢谢Amie。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
