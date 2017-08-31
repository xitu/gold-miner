
  > * 原文地址：[How do you separate components?](https://reactarmory.com/answers/how-should-i-separate-components)
  > * 原文作者：[James K Nelson](https://twitter.com/james_k_nelson)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-should-i-separate-components.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-should-i-separate-components.md)
  > * 译者：
  > * 校对者：

  # How do you separate components?

  React components have a habit of growing over time. Before I know it, some of my app's components will be monstrosities.

But is this actually a problem? After all, it seems a little odd to create many small components that are used only once...

There is nothing inherently wrong with having large components in a React app. In fact, for *stateful* components, it is absolutely expected that they’ll have a bit of size.

## Fat components happen

The thing about state is that it generally doesn’t decompose very well. If there are multiple actions that act on a single piece of state, they’ll all need to be placed in the same component. The more ways that the state can change, the larger the component gets. And if a component has actions that affect multiple [types of state](http://jamesknelson.com/5-types-react-application-state/), the component will become massive. This is unavoidable.

**But even if large components are inevitable, they’re still horrible to work with.** And that’s why you’ll want to factor out smaller components where possible, following the principle of [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns).

Of course, this is easier said than done.

Finding the lines that separate concerns is more art than science. But there are a few common patterns you can follow…

## 4 Types of Components

In my experience, there are four types of components that you can factor out from larger components.

### View components

For more information on view components (which some people call presentational components), read Dan Abramov’s classic, [Presentational and Container Components](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0).

View components are the simplest type of component. All they do is **display information and emit user input** via callbacks. They:

- Distribute their props to child elements.
- Have callbacks that forward data from child elements to parent components.
- Are often function components, but may be classes if they need to bind callbacks for performance.
- Generally do not use lifecycle methods, except for performance optimization.
- *Do not* directly store state, with the exception of UI-centric state like animation state.
- *Do not* use refs or interact with the DOM directly (as the DOM is state).
- *Do not* modify the environment; they should never directly dispatch actions to a redux store, call an API, etc.
- *Do not* use React context.

Some signs that you can factor out a presentation component from a larger component include:

- Your component has DOM markup or styles.
- There are repeated sections like list items.
- Something in your component “looks” like a box or a section.
- A section of JSX only relies on a single object for its input data.
- You have a large presentation component with distinct sections.

Some examples of presentation components that can be factored out of larger components:

- Components that perform layout for a number of child elements.
- Cards and list items can be factored out of lists.
- Groups of fields can be factored out of forms (with all updates combined into a single `onChange` callback).
- Markup can be factored out of controls.

### Control components

Control components are components that **store state related to partial input**, i.e. state that keeps track of actions the user has taken, which haven’t yet resulted in a valid value that can be emitted via an `onChange` callback. They are similar to presentation components, but:

- Can store state (when it is related to partial input).
- Can use refs and interact with the DOM.
- Can use lifecycle methods.
- Often don’t have any styles or DOM markup.

Some signs that you can factor out a control component from a larger component include:

- You’re storing partial input in state.
- Your component interacts with the DOM through refs.
- Parts of your component look like native controls – buttons, fields, etc.

Some examples of control components include:

- Date pickers
- Typeaheads
- Switches

You’ll often find that you have a number of controls with the same behavior, but different presentation. In these cases, it makes sense to factor out the presentation into View components, which are passed in via a `theme` or `view` prop.

You can see a real-world example of connector functions in the [react-dnd](https://github.com/react-dnd/react-dnd) library.

When factoring presentation components out of controls, you may find that passing individual ref functions and callbacks to the presentation component via `props` feels a little wrong. In this case, it may help to pass **connector function** instead, which clones refs and callbacks onto a passed in element. For example:

```
class MyControl extends React.Component {
  // A connector function uses React.cloneElement to add event handlers
  // and refs to an element created by the presentation component.
  connectControl = (element) => {
    return React.cloneElement(element, {
      ref: this.receiveRef,
      onClick: this.handleClick,
    })
  }

  render() {
    // You can pass a presentation component into your controls via props,
    // allowing controls to be themed with arbitrary markup and styles.
    return React.createElement(this.props.view, {
      connectControl: this.connectControl,
    })
  }

  handleClick = (e) => { /* ... */ }
  receiveRef = (node) => { /* ... */ }

  // ...
}

// The presentation component can wrap an element in `connectControl` to add
// appropriate callbacks and `ref` functions
function ControlView({ connectControl }) {
  return connectControl(
    <div className='some-class'>
      control content goes here
    </div>
  )
}
```

You’ll find that control components can often end up surprisingly large. They have to deal with the DOM, which is a large chunk of state that doesn’t decompose. And this makes factoring out control components especially useful; by limiting your DOM interactions to control components, you can keep any DOM-related mess in a single place.

### Controllers

Once you’ve split out your presentation and control code into separate components, most of the remaining code will be business logic. And if there is one thing that I want you to remember after reading this, it is that **business logic doesn’t need to be placed in React components**. It often makes sense to implement business logic as plain JavaScript functions and classes. For lack of a better name, I call these *controllers*.

Ok, so there are only three types of *React* components. But there are still four types of components, because not every component is a React Component.

And not every car is a Toyota (but at least in Tokyo, most of them are).

Controllers generally follow a similar pattern. They:

- Store some state.
- Have actions that operate on that state, and possibly cause side effects.
- May have some method of subscribing to state changes that are not directly caused by actions.
- May accept prop-like configuration, or subscribe to the state of some global controller.
- *Do not* rely on any React APIs.
- *Do not* interact with the DOM or have any styles.

Some signs that you can factor out a controller from your component:

- The component has a lot of state that isn’t related to partial input.
- State is used to store information that has been received from the server.
- There are references to global state like drag/drop or navigation state.

Some examples of controllers include:

- A Redux or Flux store.
- A JavaScript class with MobX observables.
- A plain-old JavaScript class with methods and instance variables.
- An event emitter.

Some controllers are globals; they exist entirely separately from your React application. Redux stores are a good example of global controllers. But **not all controllers need to be global**. And not all state needs to go in a single controller or store.

By factoring out controller code for your forms and lists into separate classes, you can instantiate these classes as needed in your container components.

### Container components

Container components are the glue that connects your controllers to presentation and control components. They are more flexible than the other types of components. But they still tend to follow a few patterns. They:

- Store controller instances in component state.
- Render their state with presentation and control components.
- Use lifecycle methods to subscribe to updates in controller state.
- *Do not* use DOM markup or style (with the possible exception of some unstyled divs).
- Are often generated with Higher Order Functions like Redux’s `connect`.
- Can access global controllers (such as a Redux store) through context.

While you can sometimes factor out Container components from other Containers, this is pretty rare. Instead, it is best to focus your effort on factoring out controllers, presentation components and control components, with whatever is left becoming your containers.

Some examples of containers include:

- An `App` component
- Components that are returned by Redux’s `connect`
- Components that are returned by MobX’s `observer`
- The `<Link>` component from react-router (because it uses context and affects the environment)

## Component files

What do you call a component that isn't a View, Control, Controller or Container? You just call it a component! Simple, huh?

Once you’ve found a component to factor out, the question becomes *where do I put it?* And honestly, the answer depends a lot on personal taste. But there is one rule that I think is important:

**If the factored out component is only used in one parent, it goes in the same file as the parent.**

This is in the interest of making it as easy as possible to factor out components. Creating files is bothersome and takes you out of flow. And if you try to put every component in a different file, you’ll soon start asking yourself “Do I really need a new component”? So start by putting related components in the same file.

Of course, once you *do* find a place to re-use that component, you may want to move it to its own file. And that makes figuring out which file to put it in a good problem to have.

## What about performance?

By splitting out one monolithic component into a number of controllers, presentation components and control components, you increase the total amount of code that needs to be run. This may slow things down a little bit. But it won’t slow it down very much.

##### Story

The only time I’ve ever encountered performance issues caused by too many components was when I was rendering 5000 cells in a grid *on each frame*, each with multiple nested components.

The thing about React performance is that even if your application has perceptible lag, the problem is almost certainly *not* to do with having too many components.

**So use as many components as you’d like.**

## If it ain’t broke…

I’ve mentioned a lot of rules in this spiel. So you may be surprised to hear that I don’t actually like hard and fast rules. They’re usually wrong, at least in some cases. So to be clear:

**Just because you *can* factor something out doesn’t mean that you *must* factor it out.**

Let’s say that your goal is to make your code more comprehensible and easier to maintain. This still leaves the question: what is comprehensible? And what is easy to maintain? The answer often depends on who is asking, and that’s why refactoring is more art than science.

For a concrete example, consider this contrived component:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>I'm in a React app!</title>
  </head>
  <body>
    <div id="app"></div>

    <script src="https://unpkg.com/react@15.6.1/dist/react.js"></script>
    <script src="https://unpkg.com/react-dom@15.6.1/dist/react-dom.js"></script>
    <script>
      // JavaScript source goes here
    </script>
  </body>
</html>
```

```
class List extends React.Component {
  renderItem(item, i) {
    return (
      <li key={item.id}>
        {item.name}
      </li>
    )
  }

  render() {
    return (
      <ul>
        {this.props.items.map(this.renderItem)}
      </ul>
    )
  }
}

ReactDOM.render(
  <List items={[
    { id: 'a', name: 'Item 1' },
    { id: 'b', name: 'Item 2' }
  ]} />,
  document.getElementById('app')
)
```

While it would be perfectly possible to factor out the `renderItem` into a separate component, would you actually gain anything by doing so? Probably not. In fact, in a file with a number of different components, using the `renderItem` method would probably be *easier* to follow.

So remember: the four types of components are a pattern that you can use when it feels like they make sense. They’re not hard and fast rules. And if you’re quite unsure about whether something needs to be factored out, just leave it be. Because the world won’t end if some components are fatter than others.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  