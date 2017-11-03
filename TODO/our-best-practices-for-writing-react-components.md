> * 原文地址：[Our Best Practices for Writing React Components](https://medium.com/code-life/our-best-practices-for-writing-react-components-dec3eb5c3fc8#.aufjnbwo5)
* 原文作者：[Scott Domes](https://medium.com/@scottdomes)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[imink](https://github.com/imink) 
* 校对者：[L9m](https://github.com/L9m)、[vuuihc](https://github.com/vuuihc)

# 编写 React 组件的最佳实践
![](https://cdn-images-1.medium.com/max/800/1*GEniDHmmO0nkVuKQ8fhLYw.png)


当我一开始写 React 的时候，我记得有许多不同的方法来写组件，每个教程都大不相同。虽然从那以后 React 框架已经变得相当的成熟，但似乎仍然没有一种明确的写组件的“正确”方式。


过去一年在 [MuseFind](https://musefind.com/) 工作中，我们的团队写过了无数的 React 组件。我们也在不断的改善方法直到我们满意为止。

这篇指南是我们建议的编写 React 组件的最佳方式。不管你是初学者还是有经验的人，我们希望它对你有用。

在开始之前，一些注意事项：

- 我们使用 ES6 和 ES7 语法。
- 如果你还不清楚展示组件和容器组件，我们建议先读[这篇](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.kuvqndiqq).
- 请不吝评论，留下你的建议和问题以及反馈。

### 基于类的组件

基于类的组件包含了状态和方法。我们应该尽量保守的去使用它们，但是这类组件有他们的用武之地。


接下来，我们来逐行地构建我们的组件

#### 引入 CSS

```javascript
import React, {Component} from 'react'
import {observer} from 'mobx-react'

import EexpandableFormRequiredPropsxpandableForm from './ExpandableForm'
import './styles/ProfileContainer.css'
```

我理论上比较倾向 [CSS in JavaScript](https://medium.freecodecamp.com/a-5-minute-intro-to-styled-components-41f40eb7cd55)，但是这还是一个比较新的想法，到目前为止并没有一个相对成熟的解决方法出现。所以目前，我们对每一个组件都引入 CSS 文件。


我们用空行把本地引入和依赖引入分开。

#### 初始化状态

```javascript
import React, {Component} from 'react'
import {observer} from 'mobx-react'

import ExpandableForm from './ExpandableForm'
import './styles/ProfileContainer.css'

export default class ProfileContainer extends Component {
  state = { expanded: false }
```

如果你使用 ES6 而不是 ES7，请在构造方法里初始化状态。除此之外，你可以在 ES7 中使用上面的方法初始化状态。更多信息，请移步[这里](http://stackoverflow.com/questions/35662932/react-constructor-es6-vs-es7)。

当然，我们还需将我们的类作为默认类导出。

#### propTypes 和 defaultProps

```javascript

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
```

propTypes 和 defaultProps 是静态的属性，需要尽可能早的在组件代码中声明。因为它们是作为文档而存在的，所以当其他开发者在阅读代码时候，它们应该尽早被看到。


所有的组件都应该有 propTypes。

#### 方法

```javascript
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
```

在基于类的组件中，当你需要向子组件传递方法的时候，你应该确保他们被调用的时候正确地绑定了 *this*。通常可以由 *this.handleSubmit.bind(this)* 传递给子组件来实现。

我们认为这种方法更简洁易用，通过 ES6 的箭头函数来自动确保正确的上下文。

#### 解构 Props

```javascript
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
```

有多个 props 的组件应该每行只写一个 prop，就像上面一样。


#### 装饰器
```javascript
@observer
export default class ProfileContainer extends Component {
```
如果你使用了像[mobx](https://github.com/mobxjs/mobx)的工具，你可以像上面这样来装饰组件，这和把组件传递到函数一样。


[装饰器](http://javascript.info/tutorial/decorators) 是一种灵活可读的用来修饰组件功能的方法，配合 mobx 和 我们自己的 [mobx-models](https://github.com/musefind/mobx-models) 库，我们可以广泛的应用这种方法。

如果你不想使用装饰器，可以这么做：

```javascript
class ProfileContainer extends Component {
  // Component code
}

export default observer(ProfileContainer)
```

#### 闭包

避免向子组件传递新的闭包，比如:

```javascript
<input
  type="text"
  value={model.name}
  // onChange={(e) => { model.name = e.target.value }}
  // ^ Not this. Use the below:
  onChange={this.handleChange}
  placeholder="Your Name"/>
```

原因在此：每次父级组件渲染的时候，一个新的函数就会被创建，传递到 input 中。

如果这里的 input 是一个 React 组件，这会自动触发该组件重新渲染，不管该组件当中的 props 有没有被改变。

子级校正 （Reconciliation） 是 React 框架中最耗资源的部分。如果不需要，就不要增加难度。而且传递一个类方法会使代码更易于阅读，易于调试，易于修改。

以下是组件的全貌：

```javascript
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

### 函数组件

这部分组件没有状态和方法。此类组件比较纯粹，易于理解。尽量多使用这类组件。

#### propTypes

```javascript
import React from 'react'
import {observer} from 'mobx-react'

import './styles/Form.css'

const expandableFormRequiredProps = {
  onSubmit: React.PropTypes.func.isRequired,
  expanded: React.PropTypes.bool
}

// Component declaration
```

这里，我们在文件最开始给变量赋值 propTypes，所以它们立即可见。在下面的组件声明中，我们来更恰当地赋值。

#### 解构 Props 和 defaultProps

```javascript
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
```

我们的组件是一个函数，其中 props 作为参数。我们可以像下面这样把它展开：


```javascript
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
```

注意我们可以通过更可读的方式来使用默认参数作为 defaultProps。如果 expanded 没有被定义，我们设定它为 false。（一种更合理的解释是，虽然它是布尔类型，但是可以避免出现 ‘Cannot read < property > of undefined’ 此类对象错误的问题）。

避免使用如下的 ES6 语法：

```javascript
const ExpandableForm = ({ onExpand, expanded, children }) => {
```

看起来非常得时髦，但这里的函数实际上未命名。

如果Babel设置正确，这里未命名不会造成问题。但是如果Babel设置错了的话，任何错误都会以 << anonymous >> 的方式呈现，这对于调错是非常糟糕的体验。

未命名的函数也可以会伴随 Jest （一个 React 测试库）出现问题。由于这些难以理解的 bugs 的潜在问题，我们建议使用 *function 代替 const.*


#### 封装

既然你不能对函数组件使用装饰器，你可以把函数作为参数传递过去。

```javascript
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
```

以下是组件的全貌：

```javascript
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

### JSX 中的条件语句

如果你要使用很多有条件限制的渲染，这里是你需要避免的：

![](https://cdn-images-1.medium.com/max/800/1*4zdSbYcOXTVchgSJqtk0Ig.png)

内嵌套的三元运算符不是一个好想法。

虽然有一些第三方的库解决这个问题（[JSX-Control Statements](https://github.com/AlexGilleran/jsx-control-statements)），但这里我们用下面的方法来解决复杂的条件语句，而不去引用这些依赖。

![](https://cdn-images-1.medium.com/max/800/1*IVFlMaSGKqHISJueTC26sw.png)


使用花括号包装一个 [IIFE](http://stackoverflow.com/questions/8228281/what-is-the-function-construct-in-javascript)，然后把 if 语句放进去，返回你想渲染的任何东西。注意 IIFE 可能会导致性能问题，但是在绝大多数情况下，它导致的性能问题还不足以与代码可读性问题相比。

同样，当你只想在一个条件语句中渲染某个元素，不要这么做：
```javascript  
{
  isTrue
   ? <p>True!</p>
   : <none/>
}
```

应该使用短路求值（short-circuit evaluation）的方式
```javascript
{
  isTrue && 
    <p>True!</p>
}
```

完
