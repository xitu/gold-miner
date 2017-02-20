> * 原文地址：[Our Best Practices for Writing React Components](https://medium.com/code-life/our-best-practices-for-writing-react-components-dec3eb5c3fc8#.aufjnbwo5)
* 原文作者：[Scott Domes](https://medium.com/@scottdomes)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# Our Best Practices for Writing React Components

![](https://cdn-images-1.medium.com/max/800/1*GEniDHmmO0nkVuKQ8fhLYw.png)

When I first started writing React, I remember seeing many different approaches to writing components, varying greatly from tutorial to tutorial. Though the framework has matured considerably since then, there doesn’t seem to yet be a firm ‘right’ way of doing things.

Over the past year at [MuseFind](https://musefind.com/), our team has written a lot of React components. We’ve gradually refined our approach until we’re happy with it.

This guide represents our suggested best practices. We hope it will be useful, whether you’re a beginner or experienced.

Before we get started, a couple of notes:

- We use ES6 and ES7 syntax.
- If you’re not sure of the distinction between presentational and container components, we recommend you [read this first](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0#.kuvqndiqq).
- Please let us know in the comments if you have any suggestions, questions, or feedback.

### Class Based Components

Class based components are stateful and/or contain methods. We try to use them as sparingly as possible, but they have their place.

Let’s incrementally build our component, line by line.

#### Importing CSS

    import React, {Component} from 'react'
    import {observer} from 'mobx-react'

    import ExpandableForm from './ExpandableForm'
    import './styles/ProfileContainer.css'

I like [CSS in JavaScript](https://medium.freecodecamp.com/a-5-minute-intro-to-styled-components-41f40eb7cd55), I do — in theory. But it’s still a new idea, and a mature solution hasn’t emerged. Until then, we import a CSS file to each component.

We also separate our dependency imports from local imports by a newline.

#### Initializing State

    import React, {Component} from 'react'
    import {observer} from 'mobx-react'

    import ExpandableForm from './ExpandableForm'
    import './styles/ProfileContainer.css'

    export default class ProfileContainer extends Component {
      state = { expanded: false }

If you’re using ES6 and NOT ES7, initialize state in the constructor. Else, use this ES7 approach. More on that [here](http://stackoverflow.com/questions/35662932/react-constructor-es6-vs-es7).

We also make sure to export our class as the default.

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

All your components should have propTypes.

#### Methods

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

We think this approach is cleaner and easier, maintaining the correct context automatically via the ES6 arrow function.

#### Destructuring Props

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

#### Decorators

[@observer](http://twitter.com/observer)

    export default class ProfileContainer extends Component {

If you’re using something like [mobx](https://github.com/mobxjs/mobx), you can decorate your class components like so — which is the same as passing the component into a function.

[Decorators](http://javascript.info/tutorial/decorators) are flexible and readable way of modifying component functionality. We use them extensively, with mobx and our own [mobx-models](https://github.com/musefind/mobx-models) library.

If you don’t want to use decorators, do the following:

    class ProfileContainer extends Component {
      // Component code
    }

    export default observer(ProfileContainer)

#### Closures

Avoid passing new closures to subcomponents, like so:

              <input
                type="text"
                value={model.name}
                // onChange={(e) => { model.name = e.target.value }}
                // ^ Not this. Use the below:
                onChange={this.handleChange}
                placeholder="Your Name"/>

Here’s why: every time the parent component renders, a new function is created and passed to the input.

If the input were a React component, this would automatically trigger it to re-render, regardless of whether its other props have actually changed.

Reconciliation is the most expensive part of React. Don’t make it harder than it needs to be! Plus, passing a class method is easier to read, debug, and change.

Here’s our full component:

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

These components have no state and no methods. They’re pure, and easy to reason about. Use them as often as possible.

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

#### Destructuring Props and defaultProps

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

Avoid the following ES6 syntax:

    const ExpandableForm = ({ onExpand, expanded, children }) => {

Looks very modern, but the function here is actually unnamed.

This lack of name will not be a problem if your Babel is set up correctly — but if it’s not, any errors will show up as occurring in << anonymous >> which is terrible for debugging.

Unnamed functions can also cause problems with Jest, a React testing library. Due to the potential for difficult-to-understand bugs (and the lack of real benefit) we recommend using *function instead of const.*

#### Wrapping

Since you can’t use decorators with functional components, you simply pass it the function in as an argument:

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

Chances are you’re going to do a lot of conditional rendering. Here’s what you want to avoid:

![](https://cdn-images-1.medium.com/max/800/1*4zdSbYcOXTVchgSJqtk0Ig.png)

No, nested ternaries are not a good idea.

There are some libraries that solve this problem ([JSX-Control Statements](https://github.com/AlexGilleran/jsx-control-statements)), but rather than introduce another dependency, we settled on this approach for complex conditions:

![](https://cdn-images-1.medium.com/max/800/1*IVFlMaSGKqHISJueTC26sw.png)

Use curly braces wrapping an [IIFE](http://stackoverflow.com/questions/8228281/what-is-the-function-construct-in-javascript), and then put your if statements inside, returning whatever you want to render. Note that IIFE’s like this can cause a performance hit, but in most cases it will not be significant enough to warrant losing the readability factor.

Also, when you only want to render an element on one condition, instead of doing this…

    {
      isTrue
       ? <p>True!</p>
       : <none/>
    }

… use short-circuit evaluation:

    {
      isTrue && 
        <p>True!</p>
    }