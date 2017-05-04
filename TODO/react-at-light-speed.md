> * 原文地址：[React at Light Speed](https://blog.vixlet.com/react-at-light-speed-78cd172a6411)
> * 原文作者：[Jacob Beltran](https://blog.vixlet.com/@jacob_beltran)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# React at Light Speed #

## Lessons in optimizing performance at Vixlet ##

![](https://cdn-images-1.medium.com/max/1000/1*SJzLm3SW2IegLw0GzlaG-w.jpeg)

Over the past year or so, the web team here at [Vixlet](http://www.vixlet.com) has embarked on an exciting journey of moving our entire web application to a React + Redux architecture. It has been a growing opportunity for our entire team and throughout this process, we have some challenges along the way.

Since our web-app can have very large feed views consisting of hundreds if not thousands of media/text/video/link items, we spent considerable time looking for ways to get the most out of React’s performance. Here we will share some of the lessons we have learned along the way.

**Disclaimer**: *The practices and methods described below have been found applicable to the performance needs of our specific application. However, as with all development advice, it’s important to take the needs of your application and team into account. React is pretty fast out of the box, so you may not need as finely-tuned performance as our use case. Nevertheless, we hope you find this post informative.*

### Fundamentals ###

![](https://cdn-images-1.medium.com/max/800/1*UOGdUM1V_rGUbxLS-eaWdQ.gif)

Taking a first step into a larger world.

#### The render() function ####

As a general principle, do as little work as possible in the render function. If it is necessary to perform complex operations or calculations, perhaps consider moving them to a [memoized](https://en.wikipedia.org/wiki/Memoization) function so that duplicate results can be cached. See [Lodash.memoize](https://lodash.com/docs#memoize) for an out-of-the-box memoization function.

Conversely, it is also important to avoid storing easily computable values in a component’s state. For example, if the props contain both a `firstName` and `lastName`, there is no need to include `fullName` in state, since it’s easy to derive from the provided props. If a value can be derived from props in a performant way, by using simple string concatenation, or basic arithmetic operations, there’s no reason for the derived value to be included in a component’s state.

#### Prop Values and Reconciliation ####

It is important to remember that React will trigger a re-render anytime a prop (or state) value is not equal to the previous value. This includes any changes within nested values if props or state includes an object or array. With this in mind, it is important to be mindful of situations where it’s possible to inadvertently cause a performance hit by creating new values for props or state each render cycle.

**Example:** *Issues with function binding*

```
/*
Passing an inline bound function (including ES6 arrow functions)
directly into a prop value is essentially passing a new 
function for each render of the parent component.
*/
render() {
  return (
    <div>
      <a onClick={ () => this.doSomething() }>Bad</a>
      <a onClick={ this.doSomething.bind( this ) }>Bad</a>
    </div>
  );
}


/*
Instead handle function binding in the constructor and pass the
already bound function as the prop value
*/

constructor( props ) {
  this.doSomething = this.doSomething.bind( this );
  //or
  this.doSomething = (...args) => this.doSomething(...args);
}
render() {
  return (
    <div>
      <a onClick={ this.doSomething }>Good</a>
    </div>
  );
}
```

**Example:** *Object or Array literals*

```
/*
Object literals or Array literals are functionally equivalent to calling
Object.create() or new Array(). This means that if object literals or
array literals are passed as prop values, React will consider these to be new
values for each render.
This is problematic mostly when dealing with Radium or inline styles.
*/

/* Bad */
// New object literal for style each render
render() {
  return <div style={ { backgroundColor: 'red' } }/>
}

/* Good */
// Declare outside of component
const style = { backgroundColor: 'red' };

render() {
  return <div style={ style }/>
}
```

**Example** *: Be careful of literals in fallback values*

```
/*
Sometimes a fallback value or object may be created in the render function
( or prop value ) to avoid undefined value errors. In these cases, it's best
to define the fallbacks as a constant external to the component instead of
creating a new literal.
/*
/* Bad */
render() {
  let thingys = [];
  // If this.props.thingys is not defined a new array literal is created above.
  if( this.props.thingys ) {
    thingys = this.props.thingys;
  }

  return <ThingyHandler thingys={ thingys }/>
}

/* Bad */
render() {
  // This has functionally the same outcome as the above example.
  return <ThingyHandler thingys={ this.props.thingys || [] }/>
}

/* Good */

// Declare outside of component
const NO_THINGYS = [];

render() {
  return <ThingyHandler thingys={ this.props.thingys || NO_THINGYS }/>
}
```

#### Keeping Props (and State) as simple and minimal as possible ####

Ideally, the only props passed to a component should be those directly needed by that component. Passing a large, complex object, or many individual props to a component only for the purpose of passing values to children will cause many unnecessary component renders (as well as add development complexity).

Here at Vixlet, we use Redux as a state container, so in our case, it is most ideal to use the [connect()](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options) function from the [react-redux](https://www.npmjs.com/package/react-redux) library at each level in the component hierarchy to only fetch the direct data needed from the store. The connect() function is highly performant and overhead of using it is very minimal.

#### Component Methods ####

Since component methods are created for each instance of a component, if possible, use either pure functions from a helper/util module or [static class methods](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes). This makes a noticeable difference especially in cases where there are a large number of a component being rendered in the app.

### Advanced ###

![](https://cdn-images-1.medium.com/max/800/1*9n2fdJB1gPYLFJAj5D5RqA.gif)

From my point of view jank is evil!

#### shouldComponentUpdate() ####

React includes a lifecycle method [shouldComponentUpdate()](https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate). This method can be used to tell React whether a component should be re-rendered or not depending on the values of the current and next props/state.

One problem with using this method however, is that the developer must be conscious of accounting for every condition in which a re-render must happen. This can get logically complex and in general, be a pain in the ass. You can use a custom `shouldComponentUpdate()` method if absolutely needed, but for many cases there is a better option...

#### React.PureComponent ####

Starting in React v15, the library includes a PureComponent class which can be used to build components. `React.PureComponent` basically implements it's own `shouldComponentUpdate()`method that performs a shallow compare between current and next props/state automatically. For more info on shallow comparison see this Stack Overflow:

[http://stackoverflow.com/questions/36084515/how-does-shallow-compare-work-in-react](http://stackoverflow.com/questions/36084515/how-does-shallow-compare-work-in-react)

In almost all cases, `React.PureComponent` is a better choice than `React.Component`. When creating new components, try building it as a pure component first and only if the component's functionality requires, use `React.Component`.

More Info: [React.PureComponent](https://facebook.github.io/react/docs/react-api.html#react.purecomponent) in the official React Docs

#### Component Performance Profiling (in Chrome) ####

In the latest versions of Chrome, there is additional functionality built into the timeline tool that can display detailed information as to which React components are rendering and how long they take. To enable this functionality add `?react_perf` as a query string to the url that you want to test. The React rendering timeline data will be under the User Timing section.

More Info: [Profiling Components with Chrome Timeline](https://facebook.github.io/react/docs/optimizing-performance.html#profiling-components-with-chrome-timeline) in the official React docs

#### Useful Utility: [why-did-you-update](https://www.npmjs.com/package/why-did-you-update) ####

This is a nifty NPM package that can monkey patch React to add console notifications when a component re-renders unnecessarily.

**Note**: This module can be initialized with a filter to match the specific component you wish to profile, otherwise your console will be spammed beyond all recognition (SPUBAR?) and possibly your browser will hang/crash. See the [why-did-you-update docs](https://www.npmjs.com/package/why-did-you-update) for more usage details.

### Common Performance Traps

![](https://cdn-images-1.medium.com/max/800/1*GVteDSQnhXZCSui8JRp10A.gif)

#### setTimeout() and setInterval() ####

Use `setTimeout()` or `setInterval()` extremely carefully within a React component. There are almost always better alternatives such as 'resize' and 'scroll' events (note: see next section for caveats).

If you do need to use `setTimeout()` or `setInterval()`, you must **obey the following two commandments**

> Thou shalt not set extremely short time durations.

Setting a short duration is most likely unneeded. Be cautions of anything less than 100ms. If shorter durations are really needed, perhaps use [window.requestAnimationFrame()](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame) instead.

> Thou shalt keep a reference to these functions and cancel/clear them on unmount

Both `setTimeout()` and `setInterval()` return an identifier for the delayed function that can be used to cancel the operation if needed. Since these functions are run at the global scope, they don't care if your component isn't there anymore, and this can lead to errors and/or death.

**Note**: this is also true of `window.requestAnimationFrame()`

The easiest solution to this problem is to use the [react-timeout](https://www.npmjs.com/package/react-timeout) NPM package which provides a higher-order component that can be used that will handle the stuff mentioned above automatically. It adds setTimeout/setInterval, etc functions to the wrapped component’s props. (*Special thanks to Vixlet developer* [*Carl Pillot*](https://twitter.com/@carlpillot) *for pointing this one out*)

If you do not wish to import a dependency and would like to roll your own solution to this problem, something like the following would work well:

```
// How to propery cancel timeouts/intervals

compnentDidMount() {
 this._timeoutId = setTimeout( this.doFutureStuff, 1000 );
 this._intervalId = setInterval( this.doStuffRepeatedly, 5000 );
}
componentWillUnmount() {
 /*
    ProTip: If the operation already completed, or the value is undefinded
    these functions don't give a damn
 */
 clearTimeout( this._timeoutId );
 clearInterval( this._intervalId );
}
```

If you are using requestAnimationFrame() to run an animation loop, you could use a very similar solution with slight modification:

```
// How to ensure that our animation loop ends on component unount

componentDidMount() {
  this.startLoop();
}

componentWillUnmount() {
  this.stopLoop();
}

startLoop() {
  if( !this._frameId ) {
    this._frameId = window.requestAnimationFrame( this.loop );
  }
}

loop() {
  // perform loop work here
  this.theoreticalComponentAnimationFunction()
  
  // Set up next iteration of the loop
  this.frameId = window.requestAnimationFrame( this.loop )
}

stopLoop() {
  window.cancelAnimationFrame( this._frameId );
  // Note: no need to worry if the loop has already been cancelled
  // cancelAnimationFrame() won't throw an error
}
```

#### Non-debounced Rapid-firing Events ####

Certain common events can fire extremely rapidly, e.g. ‘scroll’, ‘resize’. It is wise to debounce these events, especially if the event handler is performing anything more than extremely basic functionality.

Lodash has the [_.debounce](https://lodash.com/docs/#debounce) method. There is also a standalone [debounce](https://www.npmjs.com/package/debounce) package on NPM.

> “But I really need immediate response from the scroll/resize/whatever event”

One pattern I have found that can be used to handle these kind of events and respond in a high performance manner, is to start a `requestAnimationFrame()` watch loop the first time an event is fired. Then, the `[debounce()](https://lodash.com/docs#debounce)` function can be used with the `trailing` option set to `true` (*this means the function only fires after the stream of rapidly firing events has ended*) to stop watching the value. See an example below

```
class ScrollMonitor extends React.Component {
  constructor() {
    this.handleScrollStart = this.startWatching.bind( this );
    this.handleScrollEnd = debounce(
      this.stopWatching.bind( this ),
      100,
      { leading: false, trailing: true } );
  }

  componentDidMount() {
    window.addEventListener( 'scroll', this.handleScrollStart );
    window.addEventListener( 'scroll', this.handleScrollEnd );
  }

  componentWillUnmount() {
    window.removeEventListener( 'scroll', this.handleScrollStart );
    window.removeEventListener( 'scroll', this.handleScrollEnd );
    
    //Make sure the loop doesn't run anymore if component is unmounted
    this.stopWatching();
  }

  // If the watchloop isn't running start it
  startWatching() {
    if( !this._watchFrame ) {
      this.watchLoop();
    }
  }

  // Cancel the next iteration of the watch loop
  stopWatching() {
    window.cancelAnimationFrame( this._watchFrame );
  }

  // Keep running on each animation frame untill stopped.
  watchLoop() {
    this.doThingYouWantToWatchForExampleScrollPositionOrWhatever()

    this._watchFrame = window.requestAnimationFrame( this.watchLoop )
  }

}
```

#### Intensive CPU task Thread blocking ####

Certain tasks will always be CPU intensive and thus can cause issues blocking the main rendering thread. Some examples include very complex math calculations, iterating through very large arrays, reading/writing using the `File` api. Encoding or decoding image data from a `<canvas>` object.

If at all possible in these scenarios, it would be best to use a Web Worker to move that functionality onto another thread, so that our main rendering thread can remain buttery smooth.

**Read These**

MDN Article: [Using Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)

MDN Docs: [Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Worker)

### Closing Words ###

We hope that you have found the above suggestions useful and informative. The above compilation of tips and tricks could not be possible without the great work and research by the web team here at Vixlet. They truly are one of the most awesome groups of people that I’ve ever had the chance to work with.

In your personal quest to get the most out of React, continue to learn and practice, and may the Force be with you!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
