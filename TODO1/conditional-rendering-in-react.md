> * 原文地址：[8 React conditional rendering methods](https://blog.logrocket.com/conditional-rendering-in-react-c6b0e5af381e)
> * 原文作者：[Esteban Herrera](https://blog.logrocket.com/@eh3rrera?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/conditional-rendering-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/conditional-rendering-in-react.md)
> * 译者：[Dong Han](https://github.com/IveHD)
> * 校对者：[Jessica Shao](https://github.com/tutaizi)

# 8 React 实现条件渲染的多种方式和性能考量

![](https://cdn-images-1.medium.com/max/800/1*iePG8qczEBX1ICAMR5U-JQ.png)

[JSX](https://facebook.github.io/jsx/) 是对 JavaScript 强大的扩展，允许我们来定义 UI 组件。但是它不直接支持循环和条件表达式（尽管添加 [条件表达式已经被讨论过了](https://github.com/reactjs/react-future/issues/35)）。

如果你想要遍历一个集合来渲染多个组件或者实现一些条件逻辑，你不得不使用纯 Javascript，你也并没有很多的选择来处理循环。更多的时候，`map` 将会满足你的需要。

但是条件表达式呢？

那就是另外一回事了。

### 有几种方案可供你选择

在 React 中有多种使用条件语句的方式。并且，和编程中的大多数事情一样，依赖于你所要解决的实际问题，有些方式是更适合的。

本教程介绍了最流行的条件渲染方法：

*   If/Else
*   避免使用 `null` 渲染
*   元素变量
*   三元运算符
*   与运算 (&& )
*   立即调用函数（IIFE）
*   子组件
*   高阶组件（HOCs）

作为所有这些方法如何工作的示例，接下来将实现具有查看/编辑功能的组件：

![](https://cdn-images-1.medium.com/max/800/0*vS8AU_xnc4VHcHrK.)

你可以在 [JSFiddle](https://jsfiddle.net/) 中尝试和拷贝（fork）所有例子。

让我们从使用 if/else 这种最原始的实现开始并在这里构建它。

### If/else

让我们使用如下状态来构建一个组件：

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
  }
}
```

你将使用一个属性来保存文本，并且使用另外一个属性存储正在被编辑的文本。第三个属性将用来表示你是在 `edit` 还是 `view` 模式下。

接下来，添加一些方法来处理输入文本、保存和输入事件：

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
}
```

现在，对于渲染方法，除了保存的文本之外，还要检查模式状态属性，以显示编辑按钮或文本输入框和保存按钮：

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
}
```

下面是完整的代码，可以在 fiddle 中尝试执行它：

Babel + JSX:

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  render () {
    if(this.state.mode === 'view') {
      return (
        <div>
          <p>Text: {this.state.text}</p>
          <button onClick={this.handleEdit}>
            Edit
          </button>
        </div>
      );
    } else {
      return (
        <div>
          <p>Text: {this.state.text}</p>
            <input
              onChange={this.handleChange}
              value={this.state.inputText}
            />
          <button onClick={this.handleSave}>
            Save
          </button>
        </div>
      );
    }
  }
}

ReactDOM.render(
    <App />,
  document.getElementById('root')
);
```

if/else 是最简单的方式来解决这个问题，但是我确定你知道这并不是一种好的实现方式。

它适用于简单的用例，每个程序员都知道它是如何工作的。但是有很多重复，`render` 方法看起来并不简洁。

所以让我们通过将所有条件逻辑提取到两个渲染方法来简化它，一个来渲染文本框，另一个来渲染按钮：

```
class App extends React.Component {
  // …
  
  renderInputField() {
    if(this.state.mode === 'view') {
      return <div></div>;
    } else {
      return (
          <p>
            <input
              onChange={this.handleChange}
              value={this.state.inputText}
            />
          </p>
      );
    }
  }
  
  renderButton() {
    if(this.state.mode === 'view') {
      return (
          <button onClick={this.handleEdit}>
            Edit
          </button>
      );
    } else {
      return (
          <button onClick={this.handleSave}>
            Save
          </button>
      );
    }
  }

  render () {
    return (
      <div>
        <p>Text: {this.state.text}</p>
        {this.renderInputField()}
        {this.renderButton()}
      </div>
    );
  }
}
```

下面是完整的代码，可以在 fiddle 中尝试执行它：

Babel + JSX:

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  renderInputField() {
    if(this.state.mode === 'view') {
      return <div></div>;
    } else {
      return (
          <p>
            <input
              onChange={this.handleChange}
              value={this.state.inputText}
            />
          </p>
      );
    }
  }
  
  renderButton() {
    if(this.state.mode === 'view') {
      return (
          <button onClick={this.handleEdit}>
            Edit
          </button>
      );
    } else {
      return (
          <button onClick={this.handleSave}>
            Save
          </button>
      );
    }
  }
  
  render () {
    return (
      <div>
        <p>Text: {this.state.text}</p>
        {this.renderInputField()}
        {this.renderButton()}
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

需要注意的是当组件在预览模式下时，方法 `renderInputField` 返回了一个空的 `div` 元素。

然而这并不是必要的。

### 避免渲染空元素

如果你想要**隐藏**一个组件，你可以让它的渲染方法返回 `null`，因为没必要渲染一个空的（和不同的）元素来占位。

需要注意的重要一点是当返回 `null` 时，即使组件并不会被看见，但是生命周期方法仍然被触发了。

举个例子，下面的代码实现了两个组件之间的计数器：

Babel + JSX:

```
class Number extends React.Component {
  constructor(props) {
    super(props);
  }
  
  componentDidUpdate() {
    console.log('componentDidUpdate');
  }
  
  render() {
    if(this.props.number % 2 == 0) {
        return (
            <div>
                <h1>{this.props.number}</h1>
            </div>
        );
    } else {
      return null;
    }
  }
}

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 }
  }
  
  onClick(e) {
    this.setState(prevState => ({
      count: prevState.count + 1
    }));
  }

  render() {
    return (
      <div>
        <Number number={this.state.count} />
        <button onClick={this.onClick.bind(this)}>Count</button>
      </div>
    )
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

`Number` 组件只有在父组件传递偶数时渲染父组件传递的值，否则，将返回 `null`。然后，当观察控制台输出时，将会发现不管 `render` 返回什么， `componentDidUpdate` 总是会被调用。

回头来看我们的例子，像这样来改变 `renderInputField` 方法：

```
  renderInputField() {
    if(this.state.mode === 'view') {
      return null;
    } else {
      return (
          <p>
            <input
              onChange={this.handleChange}
              value={this.state.inputText}
            />
          </p>
      );
    }
  }
```

下面是完整的代码：

Babel + JSX:

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  renderInputField() {
    if(this.state.mode === 'view') {
      return null;
    } else {
      return (
          <p>
            <input
              onChange={this.handleChange}
              value={this.state.inputText}
            />
          </p>
      );
    }
  }
  
  renderButton() {
    if(this.state.mode === 'view') {
      return (
          <button onClick={this.handleEdit}>
            Edit
          </button>
      );
    } else {
      return (
          <button onClick={this.handleSave}>
            Save
          </button>
      );
    }
  }
  
  render () {
    return (
      <div>
        <p>Text: {this.state.text}</p>
        {this.renderInputField()}
        {this.renderButton()}
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

返回 `null` 来替代一个空元素的优势在于这将会对组建的性能有一些改善，因为 React 不必要解绑组件来替换它。

例如，当执行返回空 `div` 元素的代码时，打开检阅页面元素，将会看到在跟元素下的 `div` 元素是如何被刷新的：

![](https://cdn-images-1.medium.com/max/800/0*1f--Ics8DXB3UFp_.)

对比这个例子，当返回 `null` 来隐藏组件时，`Edit` 按钮被点击时 `div` 元素是不更新的：

![](https://cdn-images-1.medium.com/max/800/0*7SzdmNMiVje-msFz.)

[这里](https://reactjs.org/docs/reconciliation.html)，你将明白更多关于 React 是如何更新 DOM 元素的和“对比”算法是如何运行的。

可能在这个简单的例子中，性能的改善是微不足道的，但是当在一个需要频繁更新的组件中时，情况将是不一样的。

稍后会详细讨论条件渲染的性能影响。现在，让我们继续改进这个例子。

### 元素变量

我不喜欢的一件事是在一个方法中有不止一个 `return` 声明。

所以我将会使用一个变量来存储 JSX 元素并且只有当条件判断为 `true` 的时候才初始化它：

```
renderInputField() {
    let input;
    
    if(this.state.mode !== 'view') {
      input = 
        <p>
          <input
            onChange={this.handleChange}
            value={this.state.inputText} />
        </p>;
    }
      
      return input;
  }
  
  renderButton() {
    let button;
    
    if(this.state.mode === 'view') {
      button =
          <button onClick={this.handleEdit}>
            Edit
          </button>;
    } else {
      button =
          <button onClick={this.handleSave}>
            Save
          </button>;
    }
    
    return button;
  }
```

这样做是等同于那些返回 `null` 的方法的。

以下是优化后的完整代码：

Babel + JSX:

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  renderInputField() {
    let input;
    
    if(this.state.mode !== 'view') {
      input = 
        <p>
          <input
            onChange={this.handleChange}
            value={this.state.inputText} />
        </p>;
    }
      
      return input;
  }
  
  renderButton() {
    let button;
    
    if(this.state.mode === 'view') {
      button =
          <button onClick={this.handleEdit}>
            Edit
          </button>;
    } else {
      button =
          <button onClick={this.handleSave}>
            Save
          </button>;
    }
    
    return button;
  }
  
  render () {
    return (
      <div>
        <p>Text: {this.state.text}</p>
        {this.renderInputField()}
        {this.renderButton()}
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

使用这种方式使主 `render` 方法更有可读性，但是可能并没有必要使用 if/else 判断（或者像 `switch` 这样的语句）和辅助的渲染方法。

让我们尝试一种更简单的方法。

### 三元运算符

我们可以使用 [三元运算符](https://en.wikipedia.org/wiki/%3F:) 来代替 if/else 语句：

```
condition ? expr_if_true : expr_if_false
```

该运算符用大括号包裹，表达式可以包含JSX，可选择将其包含在圆括号中以提高可读性。

它可以应用于组件的不同部分。让我们将它应用到示例中，以便您可以看到这个实例。

我将在 `render` 方法中删除 `renderInputField` 和 `renderButton`，并添加一个变量用来表示组件是在 `view` 还是 `edit` 模式：

```
render () {
  const view = this.state.mode === 'view';

  return (
      <div>
      </div>
  );
}
```

现在，你可以使用三元运算符，当组件被设置为 `view` 模式时返回 `null`，否则返回输入框：

```
  // ...

  return (
      <div>
        <p>Text: {this.state.text}</p>
        
        {
          view
          ? null
          : (
            <p>
              <input
                onChange={this.handleChange}
                value={this.state.inputText} />
            </p>
          )
        }

      </div>
  );
```

使用三元运算符，你可以通过改变组件的事件处理函数和现实的标签文字来动态的声明它的按钮是保存还是编辑：

```
  // ...

  return (
      <div>
        <p>Text: {this.state.text}</p>
        
        {
          ...
        }

        <button
          onClick={
            view 
              ? this.handleEdit 
              : this.handleSave
          } >
              {view ? 'Edit' : 'Save'}
        </button>

      </div>
  );
```

正如前面所说，三元运算符可以应用在组件的不同位置。

可以在 fiddle 中运行查看效果：

[https://jsfiddle.net/eh3rrera/y6yff8rv/](https://jsfiddle.net/eh3rrera/y6yff8rv/)

### 与运算符

在某种特殊情况下，三元运算符是可以简化的。

当你想要一种条件下渲染元素，另一种条件下不渲染元素时，你可以使用 `&&` 运算符。

不同于 `&` 运算符，当左侧的表达式可以决定最终结果时，`&&` 是不会再执行右侧表达式的判断的。
 
例如，如果第一个表达式被判定为 false（`false && …`），就没有必要再执行判断下一个表达式了，因为结果将永远是 `false`。

在 React 中，你可以使用像下面这样的表达式：

```
return (
    <div>
        { showHeader && <Header /> }
    </div>
);
```

如果 `showHeader` 被判定为 `true`，`<Header/>` 组件将会被这个表达式返回。

如果 `showHeader` 被判定为 `false`，`<Header/>` 组件将会被忽略并且一个空的 `div` 将会被返回。

使用这种方式，下面的表达方式：

```
{
  view
  ? null
  : (
    <p>
      <input
        onChange={this.handleChange}
        value={this.state.inputText} />
    </p>
  )
}
```

可以被改写为：

```
!view && (
  <p>
    <input
      onChange={this.handleChange}
      value={this.state.inputText} />
  </p>
)
```

下面是可在 fiddle 中执行的完整代码：

Banel + JSX:

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  render () {
    const view = this.state.mode === 'view';
    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        
        {
          !view && (
            <p>
              <input
                onChange={this.handleChange}
                value={this.state.inputText} />
            </p>
          )
        }
        
        <button
          onClick={
            view 
              ? this.handleEdit 
              : this.handleSave
          }
        >
          {view ? 'Edit' : 'Save'}
        </button>
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

看起来更好了，不是吗？

然而，三元表达式不总是看起来这么好。

考虑一组复杂的嵌套条件：

```
return (
  <div>
    { condition1
      ? <Component1 />
      : ( condition2
        ? <Component2 />
        : ( condition3
          ? <Component3 />
          : <Component 4 />
        )
      )
    }
  </div>
);
```

这可能会很快变得混乱。

出于这个原因，有时您可能想要使用其他技术，例如立即执行函数。

### 立即执行函数表达式 (IIFE)

顾名思义，立即执行函数就是在定义之后被立即调用的函数，他们不需要被显式地调用。

通常情况下，你一般会这样定义并执行（定义后执行）一个函数：

```
function myFunction() {

// ...

}

myFunction();
```

但是如果你想要在定义后立即执行一个函数，你必须使用一对括号来包裹这个函数（把它转换成一个表达式）并且通过添加另外两个括号来执行它（括号里面可以传递函数需要的任何参数）。

就像这样：

```
( function myFunction(/* arguments */) {
    // ...
}(/* arguments */) );
```

或者这样：

```
( function myFunction(/* arguments */) {
    // ...
} ) (/* arguments */);
```

因为这个函数不会在其他任何地方被调用，所以你可以省略函数名：

```
( function (/* arguments */) {
    // ...
} ) (/* arguments */);
```

或者你也可以使用箭头函数：

```
( (/* arguments */) => {
    // ...
} ) (/* arguments */);
```

在 React 中，你可以使用大括号来包裹立即执行函数，在函数内写所有你想要的逻辑（if/else、switch、三元运算符等等），然后返回任何你想要渲染的东西。

例如， 下面的立即执行函数中就是如何判断渲染保存还是编辑按钮的逻辑：

```
{
  (() => {
    const handler = view 
                ? this.handleEdit 
                : this.handleSave;
    const label = view ? 'Edit' : 'Save';
          
    return (
      <button onClick={handler}>
        {label}
      </button>
    );
  })()
} 
```

下面是可以在 fiddle 中执行的完整代码：

Babel + JSX:

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  render () {
    const view = this.state.mode === 'view';
    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        
        {
          !view && (
            <p>
              <input
                onChange={this.handleChange}
                value={this.state.inputText} />
            </p>
          )
        }
        
        {
          (() => {
            const handler = view 
                ? this.handleEdit 
                : this.handleSave;
            const label = view ? 'Edit' : 'Save';
          
            return (
              <button onClick={handler}>
                {label}
              </button>
            );
          })()
        }  
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

```
<div id="root"></div>
```

### 子组件

很多时候，立即执行函数看起来可能是一种不那么优雅的解决方案。

毕竟，我们在使用 React，React 推荐使用的方案是将你的应用逻辑分解为尽可能多的组件，并且推荐使用函数式编程而非命令式编程。

所以修改条件渲染逻辑为一个子组件，这个子组件会依据父组件传递的 props 来决定在不同情况下的渲染，这将会是一个更好的方案。

但在这里，我将做一些有点不同的事情，向您展示如何从一个命令式的解决方案转向更多的声明式和函数式解决方案。

我将从创建一个 `SaveComponent` 组件开始：

```
const SaveComponent = (props) => {
  return (
    <div>
      <p>
        <input
          onChange={props.handleChange}
          value={props.text}
        />
      </p>
      <button onClick={props.handleSave}>
        Save
      </button>
    </div>
  );
};
```

正如函数式编程的属性，`SaveComponent` 的功能逻辑都来自于它接收的参数所指定的。同样的方式定义另一个组件 `EditComponent`：

```
const EditComponent = (props) => {
  return (
    <button onClick={props.handleEdit}>
      Edit
    </button>
  );
};
```

现在 `render` 方法就会变成这样：

```
render () {
    const view = this.state.mode === 'view';
    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        
        {
          view
            ? <EditComponent handleEdit={this.handleEdit}  />
            : (
              <SaveComponent 
               handleChange={this.handleChange}
               handleSave={this.handleSave}
               text={this.state.inputText}
             />
            )
        } 
      </div>
    );
}
```

下面是可以在 fiddle 中执行的完整代码：

Babel + JSX:

```
const SaveComponent = (props) => {
  return (
    <div>
      <p>
        <input
          onChange={props.handleChange}
          value={props.text}
        />
      </p>
      <button onClick={props.handleSave}>
        Save
      </button>
    </div>
  );
};

const EditComponent = (props) => {
  return (
    <button onClick={props.handleEdit}>
      Edit
    </button>
  );
};

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  render () {
    const view = this.state.mode === 'view';
    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        
        {
          view
            ? <EditComponent handleEdit={this.handleEdit}  />
            : (
              <SaveComponent 
               handleChange={this.handleChange}
               handleSave={this.handleSave}
               text={this.state.inputText}
             />
            )
        } 
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

### If 组件

有像 [jsx-control-statements](https://github.com/AlexGilleran/jsx-control-statements) 这样的库可以扩展JSX来添加如下条件语句：

```
<If condition={ true }>

  <span>Hi!</span>

</If>
```

这些库提供更高级的组件，但是如果我们需要简单的 if/else，我们可以参考 [Michael J. Ryan](https://github.com/tracker1) 在 [issue](https://github.com/facebook/jsx/issues/65) 下的 [评论](https://github.com/facebook/jsx/issues/65#issuecomment-255484351)：

```
const If = (props) => {
  const condition = props.condition || false;
  const positive = props.then || null;
  const negative = props.else || null;
  
  return condition ? positive : negative;
};

// …

render () {
    const view = this.state.mode === 'view';
    const editComponent = <EditComponent handleEdit={this.handleEdit}  />;
    const saveComponent = <SaveComponent 
               handleChange={this.handleChange}
               handleSave={this.handleSave}
               text={this.state.inputText}
             />;
    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        <If
          condition={ view }
          then={ editComponent }
          else={ saveComponent }
        />
      </div>
    );
}
```

下面是可以在 fiddle 中执行的完整代码：

Babel + JSX:

```
const SaveComponent = (props) => {
  return (
    <div>
      <p>
        <input
          onChange={props.handleChange}
          value={props.text}
        />
      </p>
      <button onClick={props.handleSave}>
        Save
      </button>
    </div>
  );
};

const EditComponent = (props) => {
  return (
    <button onClick={props.handleEdit}>
      Edit
    </button>
  );
};

const If = (props) => {
  const condition = props.condition || false;
  const positive = props.then || null;
  const negative = props.else || null;
  
  return condition ? positive : negative;
};

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  render () {
    const view = this.state.mode === 'view';
    const editComponent = <EditComponent handleEdit={this.handleEdit}  />;
    const saveComponent = <SaveComponent 
               handleChange={this.handleChange}
               handleSave={this.handleSave}
               text={this.state.inputText}
             />;
    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        <If
          condition={ view }
          then={ editComponent }
          else={ saveComponent }
        />
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

### 高阶组件

[高阶组件](https://reactjs.org/docs/higher-order-components.html)（HOC）是一个函数，它接收一个已经存在的组件并且基于这个组件返回一个新的带有更多附加功能的组件：

```
const EnhancedComponent = higherOrderComponent(component);
```

应用于条件渲染时，一个组件被传递给一个高阶组件，高阶组件可以依据一些条件返回一个不同于原组件的组件：

```
function higherOrderComponent(Component) {
  return function EnhancedComponent(props) {
    if (condition) {
      return <AnotherComponent { ...props } />;
    }

    return <Component { ...props } />;
  };
}
```

这里有一篇 [Robin Wieruch](https://www.robinwieruch.de/about/) 写的 [关于高阶组件的极好的文章](https://www.robinwieruch.de/gentle-introduction-higher-order-components/)，这篇文章深入讨论了高阶组件在条件渲染中的应用。

在我们这篇文章中，我将会借鉴一些 `EitherComponent` 的概念。

在函数式编程中，`Either` 这一类方法的实现通常是作为一个包装，来返回两个不同的值。

所以让我们从定义一个接收两个参数的函数开始，另一个函数返回一个布尔值（判断条件的结果），如果这个布尔值为 `true` 则返回组件：

```
function withEither(conditionalRenderingFn, EitherComponent) {

}
```

通常高阶组件的函数名都以 `with` 开头。

这个函数将会返回另一个函数，这个被返回的函数接收一个原组件并返回一个新的组件：

```
function withEither(conditionalRenderingFn, EitherComponent) {
    return function buildNewComponent(Component) {

    }
}
```

这个被一个内部函数返回的组件（函数）就是你将在你的应用中使用的，所以它接收一个对象，这个对象具有它运行所需的所有属性：

```
function withEither(conditionalRenderingFn, EitherComponent) {
    return function buildNewComponent(Component) {
        return function FinalComponent(props) {

        }
    }
}
```

内部函数可以访问到外部函数的参数，因此，根据函数 `conditionalRenderingFn` 的返回值，你可以判断返回 `EitherComponent` 或者原 `Component`：

```
function withEither(conditionalRenderingFn, EitherComponent) {
    return function buildNewComponent(Component) {
        return function FinalComponent(props) {
            return conditionalRenderingFn(props)
                ? <EitherComponent { ...props } />
                 : <Component { ...props } />;
        }
    }
}
```

或者使用箭头函数：

```
const withEither = (conditionalRenderingFn, EitherComponent) => (Component) => (props) =>
  conditionalRenderingFn(props)
    ? <EitherComponent { ...props } />
    : <Component { ...props } />;
```

通过这个方式，使用原来定义的 `SaveComponent` 和 `EditComponent`，你可以创建一个 `withEditConditionalRendering` 高阶组件，并且通过它可以创建一个 `EditSaveWithConditionalRendering` 组件：

```
const isViewConditionFn = (props) => props.mode === 'view';

const withEditContionalRendering = withEither(isViewConditionFn, EditComponent);
const EditSaveWithConditionalRendering = withEditContionalRendering(SaveComponent);
```

这样一来你就只需在render方法中使用该组件，并向它传递所有需要用到的属性：

```
render () {    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        <EditSaveWithConditionalRendering 
               mode={this.state.mode}
               handleEdit={this.handleEdit}
               handleChange={this.handleChange}
               handleSave={this.handleSave}
               text={this.state.inputText}
             />
      </div>
    );
}
```

下面是可以在 fiddle 中执行的完整代码：

Babel + JSX:

```
const SaveComponent = (props) => {
  return (
    <div>
      <p>
        <input
          onChange={props.handleChange}
          value={props.text}
        />
      </p>
      <button onClick={props.handleSave}>
        Save
      </button>
    </div>
  );
};

const EditComponent = (props) => {
  return (
    <button onClick={props.handleEdit}>
      Edit
    </button>
  );
};

const withEither = (conditionalRenderingFn, EitherComponent) => (Component) => (props) =>
  conditionalRenderingFn(props)
    ? <EitherComponent { ...props } />
    : <Component { ...props } />;

const isViewConditionFn = (props) => props.mode === 'view';

const withEditContionalRendering = withEither(isViewConditionFn, EditComponent);
const EditSaveWithConditionalRendering = withEditContionalRendering(SaveComponent);

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
    
    this.handleChange = this.handleChange.bind(this);
    this.handleSave = this.handleSave.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
  }
  
  handleChange(e) {
    this.setState({ inputText: e.target.value });
  }
  
  handleSave() {
    this.setState({text: this.state.inputText, mode: 'view'});
  }

  handleEdit() {
    this.setState({mode: 'edit'});
  }
  
  render () {    
    return (
      <div>
        <p>Text: {this.state.text}</p>
        <EditSaveWithConditionalRendering 
               mode={this.state.mode}
               handleEdit={this.handleEdit}
               handleChange={this.handleChange}
               handleSave={this.handleSave}
               text={this.state.inputText}
             />
      </div>
    );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById('root')
);
```

### 性能考量

条件渲染可能是复杂的。就像前面我所展示的那样，每种方式的性能也可能是不同的。

然而，在大多数时候这种差别是不成问题的。但当它确实造成问题时，你将需要深入理解 React 的虚拟 DOM 的工作原理，并且使用一些技巧来[优化性能](https://reactjs.org/docs/optimizing-performance.html)。

这里有一篇关于很好的文章，关于 [优化React的条件渲染](https://medium.com/@cowi4030/optimizing-conditional-rendering-in-react-3fee6b197a20)，我非常推荐你读一下。

基本的思想是条件渲染导致改变组件的位置将会引起回流，从而导致应用内组件的解绑/绑定。

基于这篇文章的例子，我写了两个例子：

第一个例子使用 if/else 来控制 `SubHeader` 组件的显示/隐藏：

Babel + JSX:

```
const Header = (props) => {
  return <h1>Header</h1>;
}

const Subheader = (props) => {
  return <h2>Subheader</h2>;
}

const Content = (props) => {
  return <p>Content</p>;
}

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};
    
    this.handleClick = this.handleClick.bind(this);
  }
  
  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }
  
  render() {
    if(this.state.isToggleOn) {
      return (
        <div>
          <Header />
          <Subheader /> 
          <Content />
          <button onClick={this.handleClick}>
            { this.state.isToggleOn ? 'ON' : 'OFF' }
          </button>
        </div>
      );
    } else {
      return (
        <div>
          <Header />
          <Content />
          <button onClick={this.handleClick}>
            { this.state.isToggleOn ? 'ON' : 'OFF' }
          </button>
        </div>
      );
    }
  }
}

ReactDOM.render(
    <App />,
  document.getElementById('root')
);
```

第二个例子使用与运算（`&&`）做同样的事情：

Babel + JSX:

```
const Header = (props) => {
  return <h1>Header</h1>;
}

const Subheader = (props) => {
  return <h2>Subheader</h2>;
}

const Content = (props) => {
  return <p>Content</p>;
}

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {isToggleOn: true};
    
    this.handleClick = this.handleClick.bind(this);
  }
  
  handleClick() {
    this.setState(prevState => ({
      isToggleOn: !prevState.isToggleOn
    }));
  }
  
  render() {
    return (
      <div>
        <Header />
        { this.state.isToggleOn && <Subheader /> }
        <Content />
        <button onClick={this.handleClick}>
          { this.state.isToggleOn ? 'ON' : 'OFF' }
        </button>
      </div>
    );
  }
}

ReactDOM.render(
    <App />,
  document.getElementById('root')
);
```

打开元素检查并且点击几次按钮。

你将看到在每一种实现中 `Content` 是被如何处理的。

### 结论

就像编程中的很多事情一样，在 React 中有很多种方式实现条件渲染。

我会说除了第一种方式（有多种返回的if/else），你可以任选你喜欢的方式。

基于下面的原则，你可以决定哪一种方式在你的实际情况中是最好的：

*   你的编程风格
*   条件逻辑的复杂程度
*   使用 JavaScript、JSX和高级的 React 概念（比如高阶组件）的舒适度。

如果所有的事情都是相当的，那么就追求简明度和可读性。

* * *

### Plug: LogRocket, a DVR for web apps

[![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)](http://logrocket.com)

[LogRocket](https://logrocket.com) 是一款前端日志工具，能够在你自己的浏览器上复现问题。而不是去猜为什么发生错误或者向用户要截图和日志，LogRocket 帮助你复现场景来快速理解发生了什么错误。 它适用于任何应用程序，且和框架无关，并且具有从Redux，Vuex和@ngrx/store记录其他上下文的插件。

除了记录Redux动作和状态之外，LogRocket 还记录控制台日志，JavaScript 错误，堆栈跟踪，带有头信息+主体的网络请求/响应，浏览器元数据和自定义日志。它还可以检测 DOM 来记录页面上的 HTML 和 CSS，即使是最复杂的单页面应用，也能还原出像素级的视频。

免费试用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
