> * 原文地址：[Our Best Practices for Writing React Components](https://medium.com/code-life/our-best-practices-for-writing-react-components-dec3eb5c3fc8#.aufjnbwo5)
* 原文作者：[Scott Domes](https://medium.com/@scottdomes)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[imink](https://github.com/imink) 
* 校对者：

# Our Best Practices for Writing React Components
![](https://cdn-images-1.medium.com/max/800/1*GEniDHmmO0nkVuKQ8fhLYw.png)

# 写 React 组件的最佳实践
![](https://cdn-images-1.medium.com/max/800/1*GEniDHmmO0nkVuKQ8fhLYw.png)


When I first started writing React, I remember seeing many different approaches to writing components, varying greatly from tutorial to tutorial. Though the framework has matured considerably since then, there doesn’t seem to yet be a firm ‘right’ way of doing things.

当我一开始写 React 的时候，我记得有许多不同的方法来写组件，每个教程都大不相同。虽然从那以后 React 框架已经变得相当的成熟，但似乎仍然没有一种稳定的写组件的“正确”方式。

Over the past year at [MuseFind](https://musefind.com/), our team has written a lot of React components. We’ve gradually refined our approach until we’re happy with it.

过去一年在 [MuseFind](https://musefind.com/) 工作，我们的团队写过了无数的 React 组件。我们也在不断的改善方法直到我们满意为止。

This guide represents our suggested best practices. We hope it will be useful, whether you’re a beginner or experienced.

这篇指南反映了我们用到的最佳实践。不管你是初学者还是有经验的人，我们希望它对你有用。

Before we get started, a couple of notes:

在开始之前，一些注意事项：

- We use ES6 and ES7 syntax.
- If you’re not sure of the distinction between presentational and container components, we recommend you [read this first](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.kuvqndiqq).
- Please let us know in the comments if you have any suggestions, questions, or feedback.

- 我们使用 ES6 和 ES7 语法。
- 如果你还不清楚展示类组件和容器类组件，我们建议先读[这篇](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.kuvqndiqq).
- 请不吝评论，留下你的建议和问题以及反馈。

### Class Based Components

### 基于类的组件

Class based components are stateful and/or contain methods. We try to use them as sparingly as possible, but they have their place.

基于类的组件包含了状态和方法。我们应该尽量保守的去使用它们，但是这类组件有他们的用武之地。

Let’s incrementally build our component, line by line.

接下来，我们来一步步构建我们的组件

#### Importing CSS
#### 引入 CSS

    import React, {Component} from 'react'
    import {observer} from 'mobx-react'

    import ExpandableForm from './ExpandableForm'
    import './styles/ProfileContainer.css'

I like [CSS in JavaScript](https://medium.freecodecamp.com/a-5-minute-intro-to-styled-components-41f40eb7cd55), I do — in theory. But it’s still a new idea, and a mature solution hasn’t emerged. Until then, we import a CSS file to each component.

我理论上比较倾向[CSS in JavaScript](https://medium.freecodecamp.com/a-5-minute-intro-to-styled-components-41f40eb7cd55)，但是这还是一个比较新的想法，到目前为主并没有一个相对成熟的解决方法出现。所以目前，我们对每一个组件都引入 CSS 文件。

We also separate our dependency imports from local imports by a newline.

我们用空行把本地引入和依赖引入分开。

#### Initializing State
#### 初始化状态状态


    import React, {Component} from 'react'
    import {observer} from 'mobx-react'

    import ExpandableForm from './ExpandableForm'
    import './styles/ProfileContainer.css'

    export default class ProfileContainer extends Component {
      state = { expanded: false }

If you’re using ES6 and NOT ES7, initialize state in the constructor. Else, use this ES7 approach. More on that [here](http://stackoverflow.com/questions/35662932/react-constructor-es6-vs-es7).

如果你使用 ES6 而不是 ES7，在构造方法里初始化状态。除此之外，你可以放心使用 ES7。更多信息，请移步[这里](http://stackoverflow.com/questions/35662932/react-constructor-es6-vs-es7)。

We also make sure to export our class as the default.

我们也保证将类默认导出。

#### propTypes and defaultProps

    import React, {Component} from 'react'
    import {observer} from 'mobx-react'

    import ExpandableForm from './ExpandableForm'
    import './styles/ProfileContainer.css'

    export default class ProfileContainer extends Component {
      state = { expanded: false }
    
      static propTypes = {
        model: React.PropTypes.object.isRequired,
        title: React.PropTypes.string
      }
    
      static defaultProps = {
        model: {
          id: 0
        },
        title: 'Your Name'
      }

propTypes and defaultProps are static properties, declared as high as possible within the component code. They should be immediately visible to other devs reading the file, since they serve as documentation.

propTypes 和 defaultProps 是静态的属性，需要尽可能早的在组件代码中申明。因为它们是作为文档存在，所以当其他开发者在阅读代码时候，它们应该尽早被看到。


All your components should have propTypes.

所有的组件都应该有 propTypes。

#### Methods
#### 方法

    import React, {Component} from 'react'
    import {observer} from 'mobx-react'

    import ExpandableForm from './ExpandableForm'
    import './styles/ProfileContainer.css'

    export default class ProfileContainer extends Component {
      state = { expanded: false }
    
      static propTypes = {
        model: React.PropTypes.object.isRequired,
        title: React.PropTypes.string
      }
    
      static defaultProps = {
        model: {
          id: 0
        },
        title: 'Your Name'
      }

      handleSubmit = (e) => {
        e.preventDefault()
        this.props.model.save()
      }
    
      handleNameChange = (e) => {
        this.props.model.name = e.target.value
      }
    
      handleExpand = (e) => {
        e.preventDefault()
        this.setState({ expanded: !this.state.expanded })
      }

With class components, when you pass methods to subcomponents, you have to ensure that they have the right *this* when they’re called. This is usually achieved by passing *this.handleSubmit.bind(this)* to the subcomponent.

在基于类的组件中，当你需要向子组件传递方法的时候，你应该确保他们被调用的时候正确地绑定了 *this*。通常可以由 *this.handleSubmit.bind(this)* 来实现。

We think this approach is cleaner and easier, maintaining the correct context automatically via the ES6 arrow function.

我们认为这种方法更简洁简单，通过 ES6 的箭头函数来自动维护正确的上下文。

#### Destructuring Props
#### 解构 Props

    import React, {Component} from 'react'
    import {observer} from 'mobx-react'

    import ExpandableForm from './ExpandableForm'
    import './styles/ProfileContainer.css'

    export default class ProfileContainer extends Component {
      state = { expanded: false }
    
      static propTypes = {
        model: React.PropTypes.object.isRequired,
        title: React.PropTypes.string
      }
    
      static defaultProps = {
        model: {
          id: 0
        },
        title: 'Your Name'
      }

    handleSubmit = (e) => {
        e.preventDefault()
        this.props.model.save()
      }
    
      handleNameChange = (e) => {
        this.props.model.name = e.target.value
      }
    
      handleExpand = (e) => {
        e.preventDefault()
        this.setState(prevState => ({ expanded: !prevState.expanded }))
      }
    
      render() {
        const {
          model,
          title
        } = this.props
        return ( 
          <ExpandableForm 
            onSubmit={this.handleSubmit} 
            expanded={this.state.expanded} 
            onExpand={this.handleExpand}>
            <div>
              <h1>{title}</h1>
              <input
                type="text"
                value={model.name}
                onChange={this.handleNameChange}
                placeholder="Your Name"/>
            </div>
          </ExpandableForm>
        )
      }
    }

Components with many props should have each prop on a newline, like above.

有许多 props 的组件应该每行只写一个 prop，就像上面一样。

#### Decorators

[@observer](http://twitter.com/observer)

    export default class ProfileContainer extends Component {

If you’re using something like [mobx](https://github.com/mobxjs/mobx), you can decorate your class components like so — which is the same as passing the component into a function.

如果你使用了像[mobx](https://github.com/mobxjs/mobx)的工具，你可以像上面这样来装饰类组件，这和把组件传递到函数一样。

[Decorators](http://javascript.info/tutorial/decorators) are flexible and readable way of modifying component functionality. We use them extensively, with mobx and our own [mobx-models](https://github.com/musefind/mobx-models) library.

[Decorators](http://javascript.info/tutorial/decorators) 是一种灵活可读的用来修饰组件功能的方法，配合 mobx 和 我们自己的 [mobx-models](https://github.com/musefind/mobx-models) 库，我们可以广泛的应用这种方法。


If you don’t want to use decorators, do the following:

如果你不想使用 decorators，可以这么做：

    class ProfileContainer extends Component {
      // Component code
    }

    export default observer(ProfileContainer)

#### Closures

#### 闭包

Avoid passing new closures to subcomponents, like so:

避免向子组件传递新的闭包，比如:

              <input
                type="text"
                value={model.name}
                // onChange={(e) => { model.name = e.target.value }}
                // ^ Not this. Use the below:
                onChange={this.handleChange}
                placeholder="Your Name"/>

Here’s why: every time the parent component renders, a new function is created and passed to the input.

原因在此：每次父级组件渲染的时候，一个新的函数就会被创建，传递到 input 中。

If the input were a React component, this would automatically trigger it to re-render, regardless of whether its other props have actually changed.

如果这里的 input 是一个 React 组件，这会自动触发该组件重新渲染，不管该组件当中的 props 有没有被改变。

Reconciliation is the most expensive part of React. Don’t make it harder than it needs to be! Plus, passing a class method is easier to read, debug, and change.

Reconciliation 是 React 框架中最耗资源的部分。如果不需要，就不要增加难度（使用）。而且，传递一个类方法会更易读，易调试和改变。


Here’s our full component:

以下是组件的全貌：

```
import React, {Component} from 'react'
import {observer} from 'mobx-react'
// Separate local imports from dependencies
import ExpandableForm from './ExpandableForm'
import './styles/ProfileContainer.css'

// Use decorators if needed
@observer
export default class ProfileContainer extends Component {
  state = { expanded: false }
  // Initialize state here (ES7) or in a constructor method (ES6)
 
  // Declare propTypes as static properties as early as possible
  static propTypes = {
    model: React.PropTypes.object.isRequired,
    title: React.PropTypes.string
  }

  // Default props below propTypes
  static defaultProps = {
    model: {
      id: 0
    },
    title: 'Your Name'
  }

  // Use fat arrow functions for methods to preserve context (this will thus be the component instance)
  handleSubmit = (e) => {
    e.preventDefault()
    this.props.model.save()
  }
  
  handleNameChange = (e) => {
    this.props.model.name = e.target.value
  }
  
  handleExpand = (e) => {
    e.preventDefault()
    this.setState(prevState => ({ expanded: !prevState.expanded }))
  }
  
  render() {
    // Destructure props for readability
    const {
      model,
      title
    } = this.props
    return ( 
      <ExpandableForm 
        onSubmit={this.handleSubmit} 
        expanded={this.state.expanded} 
        onExpand={this.handleExpand}>
        // Newline props if there are more than two
        <div>
          <h1>{title}</h1>
          <input
            type="text"
            value={model.name}
            // onChange={(e) => { model.name = e.target.value }}
            // Avoid creating new closures in the render method- use methods like below
            onChange={this.handleNameChange}
            placeholder="Your Name"/>
        </div>
      </ExpandableForm>
    )
  }
}
```

### Functional Components

函数组件

These components have no state and no methods. They’re pure, and easy to reason about. Use them as often as possible.

这部分组件没有状态和方法。此类组件比较纯粹，易于理解。尽量多使用这类组件。

#### propTypes

    import React from 'react'
    import {observer} from 'mobx-react'

    import './styles/Form.css'

    const expandableFormRequiredProps = {
      onSubmit: React.PropTypes.func.isRequired,
      expanded: React.PropTypes.bool
    }

    // Component declaration

    ExpandableForm.propTypes = expandableFormRequiredProps

Here, we assign the propTypes to a variable at the top of the file, so they are immediately visible. Below the component declaration, we assign them properly.

这里，我们在文件最开始给变量赋值 propTypes，所以它们立即可见。在下面的组件声明中，我们更恰当的赋值。

#### Destructuring Props and defaultProps
#### 解构 Props and defaultProps

    import React from 'react'
    import {observer} from 'mobx-react'

    import './styles/Form.css'

    const expandableFormRequiredProps = {
      onSubmit: React.PropTypes.func.isRequired,
      expanded: React.PropTypes.bool
    }

    function ExpandableForm(props) {
      return (
        <form style={props.expanded ? {height: 'auto'} : {height: 0}}>
          {props.children}
          <button onClick={props.onExpand}>Expand</button>
        </form>
      )
    }

Our component is a function, which takes its props as its argument. We can expand them like so:

我们的组件是一个函数，其中 props 作为参数。我们可以像下面这样把它展开：

    import React from 'react'
    import {observer} from 'mobx-react'

    import './styles/Form.css'

    const expandableFormRequiredProps = {
      onExpand: React.PropTypes.func.isRequired,
      expanded: React.PropTypes.bool
    }

    function ExpandableForm({ onExpand, expanded = false, children }) {
      return (
        <form style={ expanded ? { height: 'auto' } : { height: 0 } }>
          {children}
          <button onClick={onExpand}>Expand</button>
        </form>
      )
    }

Note we can also use default arguments to act as defaultProps in a highly readable manner. If expanded is undefined, we set it to false. (A bit of a forced example, since it’s a boolean, but very useful for avoiding ‘Cannot read < property > of undefined’ errors with objects).

注意我们可以通过更可读的方式来使用默认参数作为 defaultProps。如果 expanded 没有被定义，我们设定它为 false。（一种更合理的解释是，虽然它是布尔类型，但是可以避免出现 ‘Cannot read < property > of undefined’ 此类对象错误的问题）。


Avoid the following ES6 syntax:

避免使用如下的 ES6 语法：

    const ExpandableForm = ({ onExpand, expanded, children }) => {

Looks very modern, but the function here is actually unnamed.

看起来非常得时髦，但这里的函数实际上未命名。

This lack of name will not be a problem if your Babel is set up correctly — but if it’s not, any errors will show up as occurring in << anonymous >> which is terrible for debugging.

如果Babel设置正确，这里未命名不会造成问题。但是如果Babel设置错了的话，任何错误都会以 << anonymous >> 的方式呈现，这对于调错是非常糟糕的体验。

Unnamed functions can also cause problems with Jest, a React testing library. Due to the potential for difficult-to-understand bugs (and the lack of real benefit) we recommend using *function instead of const.*

未命名的函数也可以会伴随 Jest (一个 React 测试库)出现问题。由于这些难以理解的 bugs 的潜在问题，我们建议使用 *function instead of const.*


#### Wrapping
#### 打包

Since you can’t use decorators with functional components, you simply pass it the function in as an argument:

既然你不能对函数组件使用 decorators，你可以把函数作为参数传递过去。

    import React from 'react'
    import {observer} from 'mobx-react'

    import './styles/Form.css'

    const expandableFormRequiredProps = {
      onExpand: React.PropTypes.func.isRequired,
      expanded: React.PropTypes.bool
    }

    function ExpandableForm({ onExpand, expanded = false, children }) {
      return (
        <form style={ expanded ? { height: 'auto' } : { height: 0 } }>
          {children}
          <button onClick={onExpand}>Expand</button>
        </form>
      )
    }

    ExpandableForm.propTypes = expandableFormRequiredProps

    export default observer(ExpandableForm)

Here’s our full component:

以下是组件的全貌：

```
import React from 'react'
import {observer} from 'mobx-react'
// Separate local imports from dependencies
import './styles/Form.css'

// Declare propTypes here as a variable, then assign below function declaration 
// You want these to be as visible as possible
const expandableFormRequiredProps = {
  onSubmit: React.PropTypes.func.isRequired,
  expanded: React.PropTypes.bool
}

// Destructure props like so, and use default arguments as a way of setting defaultProps
function ExpandableForm({ onExpand, expanded = false, children }) {
  return (
    <form style={ expanded ? { height: 'auto' } : { height: 0 } }>
      {children}
      <button onClick={onExpand}>Expand</button>
    </form>
  )
}

// Set propTypes down here to those declared above
ExpandableForm.propTypes = expandableFormRequiredProps

// Wrap the component instead of decorating it
export default observer(ExpandableForm)
```

### Conditionals in JSX

### JSX 中的条件语句

Chances are you’re going to do a lot of conditional rendering. Here’s what you want to avoid:
如果你要使用很多有条件限制的渲染，这里是你需要避免的：

![](https://cdn-images-1.medium.com/max/800/1*4zdSbYcOXTVchgSJqtk0Ig.png)

No, nested ternaries are not a good idea.
不，内嵌套的三元不是一个好想法。

There are some libraries that solve this problem ([JSX-Control Statements](https://github.com/AlexGilleran/jsx-control-statements)), but rather than introduce another dependency, we settled on this approach for complex conditions:

有一些第三方的库解决这个问题（[JSX-Control Statements](https://github.com/AlexGilleran/jsx-control-statements)），但这里我们用下面的方法来解决复杂的条件语句，而不去引用这些依赖。

![](https://cdn-images-1.medium.com/max/800/1*IVFlMaSGKqHISJueTC26sw.png)

Use curly braces wrapping an [IIFE](http://stackoverflow.com/questions/8228281/what-is-the-function-construct-in-javascript), and then put your if statements inside, returning whatever you want to render. Note that IIFE’s like this can cause a performance hit, but in most cases it will not be significant enough to warrant losing the readability factor.

使用花括号包装一个[IIFE](http://stackoverflow.com/questions/8228281/what-is-the-function-construct-in-javascript)，然后把声明放进去，返回你想渲染的任何东西。注意 IIFE 可能会导致性能问题，但是绝大多数情况下它带来的性能问题不至于让你放弃代码可读性。

Also, when you only want to render an element on one condition, instead of doing this…
同样，当你只想在一个条件语句中渲染某个元素，不要这么做：
    {
      isTrue
       ? <p>True!</p>
       : <none/>
    }

… use short-circuit evaluation:
短路求值
    {
      isTrue && 
        <p>True!</p>
    }
