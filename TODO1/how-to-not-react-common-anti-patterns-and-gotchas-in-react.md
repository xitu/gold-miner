> * 原文地址：[How to NOT React: Common Anti-Patterns and Gotchas in React](https://codeburst.io/how-to-not-react-common-anti-patterns-and-gotchas-in-react-40141fe0dcd)
> * 原文作者：[NeONBRAND](https://unsplash.com/photos/-Cmz06-0btw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-not-react-common-anti-patterns-and-gotchas-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-not-react-common-anti-patterns-and-gotchas-in-react.md)
> * 译者：
> * 校对者：

# How to NOT React: Common Anti-Patterns and Gotchas in React

What is an anti-pattern? Anti-patterns are certain patterns in software development that are considered bad programming practices. The same pattern may have been considered correct at one point in the past, but now developers have realised that they cause more pain and hard-to-track bugs in long term.

React has matured as an UI library and with that a lot of best development practices have evolved over the years. We are going to learn from the collective wisdom of thousands of programmers and developers who learnt those things the hard way.

![](https://cdn-images-1.medium.com/max/800/1*kD905dFJGIzg7DCjKIqwMw.gif)

Truly said!

Let’s begin!

### 1. bind() and arrow functions in Components

You must have bound your custom functions in the `constructor` function before using them as props for components. If you declare components using the `extends` keyword, then the custom functions (such as `updateValue` below) lose their `this` bindings. So, if you want to access `this.state`, or `this.props` or `this.setState` then you need to re-bind them.

#### Demo

```
class app extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: ''
    };
    this.updateValue = this.updateValue.bind(this);
  }

updateValue(evt) {
    this.setState({
      name: evt.target.value
    });
  }

render() {
    return (
      <form>
        <input onChange={this.updateValue} value={this.state.name} />    
      </form>
    )
  }
}
```

#### Problems

There are two ways to bind the custom functions to the component’s `this`. One way is to bind them in the `constructor` as done above. The other way is to bind at the time of passing as prop value —

```
<input onChange={this.updateValue.bind(this)} value={this.state.name} />
```

This method suffers from a problem. Since `.bind()` creates a **new** function each time it is run, **this method would lead to a new function being created every time the** `render` **function executes.** This has some performance implications. However, in a small app it may not be noticeable. As the app grows large, the difference will start to materialise. One case study is [here](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f).

Arrow functions entails the same performance concerns that were there with `bind`.

```
<input onChange={ (evt) => this.setState({ name: evt.target.value }) } value={this.state.name} />
```

This way of writing is definitely clearer. You can see what’s going on in the `onChange` prop itself. But, this also creates new anonymous function every time `input` renders. So it has the same performance penalty as above.

#### Solutions

The best way to avoid the above performance penalty is to bind the functions in the constructor itself. This way only one extra function is created at the time of component creation, and that function is used even when `render` is executed again.

It often happens that you forget to `bind` your functions in the constructor, and then you get an error (_Cannot find X on undefined._). Babel has a plugin that let’s you write auto-bound function using the fat-arrow syntax. The plugin is [_Class properties transform_](https://babeljs.io/docs/plugins/transform-class-properties/)_._ Now you can write components like this —

```
class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: ''
    };

// Look ma! No functions to bind!

}
updateValue = (evt) => {
    this.setState({
      name: evt.target.value
    });
  }

render() {
    return (
      <form>
        <input onChange={this.updateValue} value={this.state.name} />
      </form>
    )
  }
}
```

#### Read More —

*   [React Binding Patterns: 5 Approaches for Handling `this`](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)
*   [React.js pure render performance anti-pattern](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f)
*   [React — to Bind or Not to Bind](https://medium.com/shoutem/react-to-bind-or-not-to-bind-7bf58327e22a)
*   [Why and how to bind methods in your React component classes?](http://reactkungfu.com/2015/07/why-and-how-to-bind-methods-in-your-react-component-classes/)

### 2. Using indexes in key Prop

Key is an essential prop when you iterate over a collection of elements. Keys should be stable, predictable, and unique so that React can keep track of elements. Keys are used to help React easily reconcile(read: update) the differences between the virtual DOM and the real DOM. However, using certain set of values such as array _indexes_ **may break your application or render wrong data**.

#### Demo

```
{elements.map((element, index) =>
    <Display
       {...element}
       key={index}
       />
   )
}
```

#### Problems

When children have keys, React uses the key to match children in the original tree with children in the subsequent tree. **The keys are used for identification.** If two elements have same keys, React considers them same. When the keys collide, that is, more than 2 elements have the same keys, React shows a warning.

![](https://cdn-images-1.medium.com/max/1000/1*3C-F1fs7E5fK9R8XlLk62g.png)

Warning for duplicate keys.

[Here](https://reactjs.org/redirect-to-codepen/reconciliation/index-used-as-key) is an example of the issues that can be caused by using indexes as keys on CodePen.

#### Solutions

Any key that you are going to use should be —

*   **Unique** — The key of an element should be unique among its siblings. It is not necessary to have globally unique keys.
*   **Stable** — The key for the same element should not change with time, or page refresh, or re-ordering of elements.
*   **Predictable** — You can always get the same key again if you want. That is, the key should not be generated randomly.

Array indexes are unique, and predictable. However, they are not stable. In the same vein, **random numbers or timestamps should not be used as keys.**

Using random number is equivalent to not using keys at all since random numbers are not unique or stable. The components **will** be re-rendered every time even if the content inside the element has not changed.

Timestamps are unique but not stable or predictable. **They are also always increasing.** So on every page refresh, you are going to get new timestamps.

In general, you should rely on the ID generated by databases such as primary key in Relational databases, and Object IDs in Mongo. If a database ID is not available, you can generate a hash of the content and use that as a key. You can read about more about hashes [here](https://en.wikipedia.org/wiki/Hash_function).

#### Read More —

*   [Index as a key is an anti-pattern](https://medium.com/@robinpokorny/index-as-a-key-is-an-anti-pattern-e0349aece318)
*   [Why you need keys for collections in React.](https://paulgray.net/keys-in-react/)
*   [On why you shouldn’t use Random values as keys](https://github.com/facebook/react/issues/1342#issuecomment-39230939).

### 3. setState() is async

React components essentially comprises 3 things: `state` ,`props` and markup (or other components). Props are immutable. However, the state is mutable. Changing the state causes the component to re-render. If the state is managed internally by the component, `this.setState` function is employed to update the state. There are a few important things to note about this function. Let’s look —

#### Demo

```
class MyComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      counter: 350
    };
  }

  updateCounter() {
    // this line will not work
    this.state.counter = this.state.counter + this.props.increment;
    
    // ---------------------------------
    
    // this will not work as intended
    this.setState({
      counter: this.state.counter + this.props.increment; // May not render
    });
    
    this.setState({
      counter: this.state.counter + this.props.increment; // what value this.state.counter have?
    });
    
    // ---------------------------------
  
    // this will work
    this.setState((prevState, props) => ({
      counter: prevState.counter + props.increment
    }));
    
    this.setState((prevState, props) => ({
      counter: prevState.counter + props.increment
    }));
  }
}
```

#### Problems

Focus on line 11. If you mutate the state _directly,_ the component will **not** be re-rendered and the changes will not be reflected. This is because the state is compared [shallowly](https://stackoverflow.com/questions/36084515/how-does-shallow-compare-work-in-react). You should always use `setState` for changing the value of the state.

Now, in `setState` if you use the value of current `state` to update to the next state (as done in line 15), React **may or may not** **re-render**. This is because, `state` and `props` are updated asynchronously. That is, the DOM is not updated as soon as `setState` is invoked. Rather, React batches multiple updates into one update and then renders the DOM. You may receive outdated values while querying the `state` object. The [docs](https://reactjs.org/docs/state-and-lifecycle.html#state-updates-may-be-asynchronous) also mention this —

> Because `this.props` and `this.state` may be updated asynchronously, you should not rely on their values for calculating the next state.

Another problem is when you have multiple `setState` calls in a single function, as shown above on line 16 and 20. Initial value of the counter is 350. Assume the value of `this.props.increment` is 10. You might think that after the first `setState` invocation on line 16, the counter’s value will change to 350+10 = **360.** And, when the next `setState` is called on line 20, the counter’s value will change to 360+10 = **370**. However, this does not happen. The second call still sees the value of `counter` as 350. **This is because setState is async**. The counter’s value does not change until the next update cycle. The execution of setState is waiting in the [event loop](https://developer.mozilla.org/en-US/docs/Web/JavaScript/EventLoop) and until `updateCounter` finishes execution, `setState` won’t run and hence won’t update the `state`.

#### Solution

You should use the other form of `setState` as done on line 27 and 31. In this form, you can pass a function to `setState` which receives _currentState_ and _currentProps_ as arguments. The return value of this function is merged in with the existing state to form the new state.

#### Read More —

*   A wonderful [explanation](https://github.com/facebook/react/issues/11527) of why `setState` is async by [Dan Abramov](https://medium.com/@dan_abramov).
*   [Using a function in `setState` instead of an object](https://medium.com/@wisecobbler/using-a-function-in-setstate-instead-of-an-object-1f5cfd6e55d1)
*   [Beware: React setState is asynchronous!](https://medium.com/@wereHamster/beware-react-setstate-is-asynchronous-ce87ef1a9cf3)

### 4. Props in Initial State

The React docs mention this anti-pattern as —

> _Using props to generate state in_ getInitialState _often leads to duplication of “source of truth”, i.e. where the real data is. This is because getInitialState is only invoked when the component is first created._

#### Demo

```
import React, { Component } from 'react'

class MyComponent extends Component {
  constructor(props){
    super(props);
    this.state = {
      someValue: props.someValue,
    };
  }
}
```

#### Problems

The `constructor` or (getInitialState) is called **only at the time of component creation**. That is, `constructor` is invoked only once. Hence, when you change the `props` next time, the state won’t be updated and will retain its previous value.

Young developers often assume that the `props` values will be in sync with the state, and as `props` change, the `state` will reflect those values. However, that is not true.

#### Solutions

You can use this pattern if you want a specific behaviour. That is, **you want the state to be _seeded_ by the values of props only once**. The state will be managed internally by the component.

In other cases, you can use `componentWillReceiveProps` lifecycle method to keep the state and props in sync, as shown here.

```
import React, { Component } from 'react'

class MyComponent extends Component {
  constructor(props){
    super(props);
    this.state = {
      someValue: props.someValue,
    };
  }
  
  componentWillReceiveProps(nextProps){
    if (nextProps.inputValue !== this.props.inputValue) {
      this.setState({ inputVal: nextProps.inputValue })
    }
  } 
}
```

Beware that using `componentWillReceiveProps` has it own caveats. You can read about it the [Docs](https://reactjs.org/docs/react-component.html#componentwillreceiveprops).

The best approach would be to use a state management library such as Redux to [_connect_](https://github.com/reactjs/react-redux) the state and the component.

#### Read More —

*   [Props in Initial State](https://github.com/vasanthk/react-bits/blob/master/anti-patterns/01.props-in-initial-state.md)

### 5. Components Name

In React, if you are rendering your component using JSX, the name of that component has to begin with with a capital letter.

#### Demo

```
<MyComponent>
    <app /> // Will not work :(
</MyComponent>

<MyComponent>
    <App /> // Will work!
</MyComponent>
```

#### Problems

If you create a component `app` and render it using JSX as `<app label="Save" />`, React will throw an error.

![](https://cdn-images-1.medium.com/max/1000/1*xCB4cI255tVV41NvIozL7g.png)

Warning when using non-capitalised custom components.

The error says that `<app>` is not recognised. Only HTML elements and SVG tags can begin with a lowercase. Hence, `<div />` is okay but `<app>` is not.

#### Solution

You need to make sure that while using custom component in JSX, it ashould begin with a capital letter.

But, also understand that declaring components does not adhere to this rule. Hence, you can do this —

```
// Here lowercase is fine.
class primaryButton extends Component {
  render() {
    return <div />;
  }
}

export default primaryButton;

// In a different file, import the button. However, make sure to give a name starting with capital letter.

import PrimaryButton from 'primaryButton';

<PrimaryButton />
```

#### Read More —

*   [React Gotchas](https://daveceddia.com/react-gotchas/)

These were some unintuitive hard-to-understand bug-makers in React. If you know about any other anti-pattern, respond to this article. 😀

* * *

I have also written [Top React and Redux Packages for Faster Development](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)

- [**Top React and Redux Packages for Faster Development**: React has grown in popularity over the last few years. With that, a lot of tools have emerged that make developer’s… codeburst.io](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)

If you are still learning how to setup a React Project, this [two-part series](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22) might be helpful in understanding various aspects of React build system.

- [**Yet another Beginner’s Guide to setting up a React Project — Part 1**: React has gained considerable momentum in the last few years and has turned into a mature and stable UI library. It has… codeburst.io](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22)

- [**Yet another Beginner’s Guide to setting up a React Project — Part 2**: We set up a simple React App in Part 1\. We used React, React DOM and webpack-dev-server as our dependencies. We will… codeburst.io](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-2-5d3151814333)

* * *

**I write about JavaScript, web development, and Computer Science. Follow me for weekly articles. Share this article if you like it.**

**Reach out to me on @** [**Facebook**](https://www.facebook.com/arfat.salman) **@** [**Linkedin**](https://www.linkedin.com/in/arfatsalman/) **@** [**Twitter**](https://twitter.com/salman_arfat)**.**

[![](https://cdn-images-1.medium.com/max/1000/1*i3hPOj27LTt0ZPn5TQuhZg.png)](http://bit.ly/codeburst)

> ✉️ _Subscribe to_ CodeBurst’s _once-weekly_ [**_Email Blast_**](http://bit.ly/codeburst-email)**_,_ **🐦 _Follow_ CodeBurst _on_ [**_Twitter_**](http://bit.ly/codeburst-twitter)_, view_ 🗺️ [**_The 2018 Web Developer Roadmap_**](http://bit.ly/2018-web-dev-roadmap)_, and_ 🕸️ [**_Learn Full Stack Web Development_**](http://bit.ly/learn-web-dev-codeburst)_._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
