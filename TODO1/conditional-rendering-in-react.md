> * 原文地址：[8 React conditional rendering methods](https://blog.logrocket.com/conditional-rendering-in-react-c6b0e5af381e)
> * 原文作者：[Esteban Herrera](https://blog.logrocket.com/@eh3rrera?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/conditional-rendering-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/conditional-rendering-in-react.md)
> * 译者：
> * 校对者：

# 8 React conditional rendering methods

![](https://cdn-images-1.medium.com/max/800/1*iePG8qczEBX1ICAMR5U-JQ.png)

[JSX](https://facebook.github.io/jsx/) is a powerful extension to JavaScript that allows us to define UI components. But it doesn’t support loops or conditional expressions directly (although the addition of [conditional expressions has been discussed](https://github.com/reactjs/react-future/issues/35) before).

If you want to iterate over a list to render more than one component or implement some conditional logic, you have to use pure Javascript. You don’t have a lot of options with looping either. Most of the time, `map` will cover your needs.

But conditional expressions?

That’s another story.

### You’ve got options

There’s more than one way to use conditional expressions in React. And, as with most things in programming, some are better suited than others depending on the problem you’re trying to solve.

This tutorial covers the most popular conditional renderings methods:

*   If/Else
*   Prevent rendering with `null`
*   Element variables
*   Ternary operator
*   Short-circuit operator (&& )
*   Immediately-Invoked Function Expressions (IIFE)
*   Subcomponents
*   High Order Components (HOCs)

As an example of how all these methods work, a component with a view/edit functionality will be implemented:

![](https://cdn-images-1.medium.com/max/800/0*vS8AU_xnc4VHcHrK.)

You can try and fork all the examples in [JSFiddle](https://jsfiddle.net/).

Let’s start with the most naive implementation using an if/else block and build it from there.

### If/else

Let’s create a component with the following state:

```
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {text: '', inputText: '', mode:'view'};
  }
}
```

You’ll use one property for the saved text and another one or the text that is being edited. A third property will indicate if you are in `edit` or `view` mode.

Next, add some methods for handling input text and the save and edit events:

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

Now for the `render` method, check the `mode` state property to either render an edit button or a text input and a save button, in addition to the saved text:

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

Here’s the complete fiddle to try it out:

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

An if/else block is the easiest way to solve the problem, but I’m sure you know this is not a good implementation.

It works great for simple use cases and every programmer knows how it works. But there’s a lot of repetition and the `render` method looks crowded.

So let’s simplify it by extracting all the conditional logic to two render methods, one to render the input box and another one to render the button:

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

Here’s the complete fiddle to try it out:

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

Notice that the method `renderInputField` returns an empty `div` element when the app is in view mode.

However, this is not necessary.

### Prevent rendering with null

If you want to **hide** a component, you can make its render method return `null`, there’s no need to render an empty (and different) element as a placeholder.

One important thing to keep in mind when returning `null` is that even though the component doesn’t show up, its lifecycle methods are still fired.

Take, for example, the following fiddle that implements a counter with two components:

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

The `Number` component only renders the counter for even values, otherwise, `null` is returned. However, when you look at the console, you’ll see that `componentDidUpdate` is always called regardless of the value returned by `render`.

Back to our example, change the `renderInputField` method to look like this:

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

Here’s the complete fiddle:

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

One advantage of returning `null` instead of an empty element is that you’ll improve a little bit the performance of your app because React won’t have to unmount the component to replace it.

For example, when trying the [fiddle](https://jsfiddle.net/eh3rrera/q0w1aamt/) that renders the empty `div` element, if you open the Inspector tab, you’ll see how the `div` element under the root is always updated:

![](https://cdn-images-1.medium.com/max/800/0*1f--Ics8DXB3UFp_.)

Unlike the case when `null` is returned to hide the component, where that `div` element is not updated when the `Edit` button is clicked:

![](https://cdn-images-1.medium.com/max/800/0*7SzdmNMiVje-msFz.)

[Here](https://reactjs.org/docs/reconciliation.html), you can learn more about how React updates the DOM elements and how the “diffing” algorithm works.

Maybe in this simple example, the performance improvement is insignificant, but when working when big components, there can be a difference.

I’ll talk more about the performance implications of conditional rendering later. For now, let’s continue to improve this example.

### Element variables

One thing I don’t like is having more than one `return` statement in methods.

So I’m going to use a variable to store the JSX elements and only initialize it when the condition is `true`:

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

This gives the same result as returning `null` from those methods.

Here’s the fiddle to try it out:

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

The main `render` method is more readable this way but maybe it isn’t necessary to use if/else blocks (or something like a `switch` statement) and secondary render methods.

Let’s try a simpler approach.

### Ternary operator

Instead of using an if/else block we can use the [ternary conditional operator](https://en.wikipedia.org/wiki/%3F:):

```
condition ? expr_if_true : expr_if_false
```

The operator is wrapped in curly braces and the expressions can contain JSX, optionally wrapped in parentheses to improve readability.

And it can be applied in different parts of the component. Let’s apply it to the example so you can see this in action.

I’m going to remove `renderInputField` and `renderButton` and in the `render` method, I’m going to add a variable to know if the component is in `view` or `edit` mode:

```
render () {
  const view = this.state.mode === 'view';

  return (
      <div>
      </div>
  );
}
```

Now you can use the ternary operator to return `null` if the `view` mode is set, or the input field otherwise:

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

Using a ternary operator, you can declare one component to render either a save or edit button by changing its handler and label correspondingly:

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

As said before, this operator can be applied in different parts of the component.

Here’s the fiddle to try it out:

[https://jsfiddle.net/eh3rrera/y6yff8rv/](https://jsfiddle.net/eh3rrera/y6yff8rv/)

### Short-circuit operator

The ternary operator has a special case where it can be simplified.

When you want to render either something or nothing, you can only use the `&&` operator.

Unlike the `&` operator, `&&` doesn’t evaluate the right-hand side expression if just by evaluating the left-hand expression can decide the final result.

For example, if the first expression evaluates to false (`false && …`), it’s not necessary to evaluate the next expression because the result will always be `false`.

In React, you can have expressions like the following:

```
return (
    <div>
        { showHeader && <Header /> }
    </div>
);
```

If `showHeader` evaluates to `true`, the `<Header/>`component will be returned by the expression.

If `showHeader` evaluates to `false`, the `<Header/>`component will be ignored and an empty `div` will be returned.

This way, the following expression:

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

Can be turned into:

```
!view && (
  <p>
    <input
      onChange={this.handleChange}
      value={this.state.inputText} />
  </p>
)
```

Here’s the complete fiddle:

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

Looks better, right?

However, the ternary operator doesn’t always look better.

Consider a complex, nested set of conditions:

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

This can become a mess pretty quickly.

For that reason, sometimes you might want to use other techniques, like immediately-invoked functions.

### Immediately-invoked function expressions (IIFE)

As the name implies, IIFEs are functions that are executed immediately after they are defined, there’s no need to call them explicitly.

Generally, this is how you define and execute (at a later point) a function:

```
function myFunction() {

// ...

}

myFunction();
```

But if you want to execute the function immediately after it is defined, you have to wrap the whole declaration in parenthesis (to convert it to an expression) and execute it by adding two more parentheses (passing any arguments the function may take.

Either this way:

```
( function myFunction(/* arguments */) {
    // ...
}(/* arguments */) );
```

Or this way:

```
( function myFunction(/* arguments */) {
    // ...
} ) (/* arguments */);
```

Since the function won’t be called in any other place, you can drop the name:

```
( function (/* arguments */) {
    // ...
} ) (/* arguments */);
```

Or you can also use arrow functions:

```
( (/* arguments */) => {
    // ...
} ) (/* arguments */);
```

In React, you use curly braces to wrap an IIFE, put all the logic you want inside it (if/else, switch, ternary operators, etc), and return whatever you want to render.

For example, here’s how the logic to render the save/edit button could look with an IIFE:

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

Here’s the complete fiddle:

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

### Subcomponents

Sometimes, an IFFE might seem like a hacky solution.

After all, we’re using React, where the recommended approaches are things like splitting up the logic of your app in as many components as possible and using functional programming instead of imperative programming.

So moving the conditional rendering logic to a sub-component that renders different things based on its props would be a good option.

But here, I’m going to do something a bit different to show you how you can go from an imperative solution to more declarative and functional solutions.

I’m going to start by creating a `SaveComponent`:

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

As properties, it receives everything it needs to work. In the same way, there’s an `EditComponent`:

```
const EditComponent = (props) => {
  return (
    <button onClick={props.handleEdit}>
      Edit
    </button>
  );
};
```

Now the `render` method can look like this:

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

Here’s the complete fiddle:

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

### If component

There are libraries like [JSX Control Statements](https://github.com/AlexGilleran/jsx-control-statements) that extend JSX to add conditional statements like:

```
<If condition={ true }>

  <span>Hi!</span>

</If>
```

These libraries provide more advanced components, but if we need something like a simple if/else, we can do something like what [Michael J. Ryan](https://github.com/tracker1) showed in one of the [comments](https://github.com/facebook/jsx/issues/65#issuecomment-255484351) of this [issue](https://github.com/facebook/jsx/issues/65):

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

Here’s the complete fiddle:

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

### Higher-order components

A [higher-order component](https://reactjs.org/docs/higher-order-components.html) (HOC) is a function that that takes an existing component and returns a new one with some added functionality:

```
const EnhancedComponent = higherOrderComponent(component);
```

Applied to conditional rendering, an HOC could return a different component than the one passed based on some condition:

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

There’s an [excellent article about HOCs](https://www.robinwieruch.de/gentle-introduction-higher-order-components/) by [Robin Wieruch](https://www.robinwieruch.de/about/) that digs deeper into conditional renderings with higher order components.

For this article, I’m going to borrow the concepts of the `EitherComponent`.

In functional programming, the `Either` type is commonly used as a wrapper to return two different values.

So let’s start by defining a function that takes two arguments, another function that will return a boolean value (the result of the conditional evaluation), and the component that will be returned if that value is `true`:

```
function withEither(conditionalRenderingFn, EitherComponent) {

}
```

It’s a convention to start the name of the HOC with the word `with`.

This function will return another function that will take the original component to return a new one:

```
function withEither(conditionalRenderingFn, EitherComponent) {
    return function buildNewComponent(Component) {

    }
}
```

The component (function) returned by this inner function will be the one you’ll use in your app, so it will take an object with all the properties that it will need to work:

```
function withEither(conditionalRenderingFn, EitherComponent) {
    return function buildNewComponent(Component) {
        return function FinalComponent(props) {

        }
    }
}
```

The inner functions have access to the outer functions’ parameters, so now, based on the value returned by the function `conditionalRenderingFn`, you either return the `EitherComponent` or the original `Component`:

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

Or, using arrow functions:

```
const withEither = (conditionalRenderingFn, EitherComponent) => (Component) => (props) =>
  conditionalRenderingFn(props)
    ? <EitherComponent { ...props } />
    : <Component { ...props } />;
```

This way, using the previously defined `SaveComponent` and `EditComponent`, you can create a `withEditConditionalRendering` HOC and with this, create a `EditSaveWithConditionalRendering` component:

```
const isViewConditionFn = (props) => props.mode === 'view';

const withEditContionalRendering = withEither(isViewConditionFn, EditComponent);
const EditSaveWithConditionalRendering = withEditContionalRendering(SaveComponent);
```

That you can use in the `render` method passing all the properties needed:

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

Here’s the complete fiddle:

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

### Performance considerations

Conditional rendering can be tricky. As I showed you before, the performance of each option can be different.

However, most of the time, the differences don’t matter a lot. But when they do, you’ll need a good understanding of how React works with the Virtual DOM and a few tricks to [optimizing performance](https://reactjs.org/docs/optimizing-performance.html).

Here’s a good article about [optimizing conditional rendering in React](https://medium.com/@cowi4030/optimizing-conditional-rendering-in-react-3fee6b197a20), I totally recommend you read it.

The essential idea is that changing the position of the components due to conditional rendering can cause a reflow that will unmount/mount the components of the app.

Based on the example of the article, I created two fiddles.

The first one uses an if/else block to show/hide the `SubHeader` component:

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

The second one uses the short circuit operator (`&&`) to do the same:

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

Open the Inspector and click on the button a few times.

You’ll see how the `Content` component is treated differently by each implementation.

### Conclusion

Just as with many things in programming, there are many ways to implement conditional rendering in React.

I’d say that with exception of the first method (if/else with many returns), you’re free to choose whatever method you want.

You can decide which one is best for your situation based on:

*   Your programming style
*   How complex the conditional logic is
*   How comfortable you are with JavaScript, JSX, and advanced React concepts (like HOCs)

And all things being equal, always favor simplicity and readability.

* * *

### Plug: LogRocket, a DVR for web apps

[![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)](http://logrocket.com)

[LogRocket](https://logrocket.com) is a frontend logging tool that lets you replay problems as if they happened in your own browser. Instead of guessing why errors happen, or asking users for screenshots and log dumps, LogRocket lets you replay the session to quickly understand what went wrong. It works perfectly with any app, regardless of framework, and has plugins to log additional context from Redux, Vuex, and @ngrx/store.

In addition to logging Redux actions and state, LogRocket records console logs, JavaScript errors, stacktraces, network requests/responses with headers + bodies, browser metadata, and custom logs. It also instruments the DOM to record the HTML and CSS on the page, recreating pixel-perfect videos of even the most complex single page apps.

Try it for free.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
