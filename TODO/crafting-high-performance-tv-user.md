> * 原文链接: [Crafting a high-performance TV user interface using React](http://techblog.netflix.com/2017/01/crafting-high-performance-tv-user.html)
* 原文作者 : [Ian McKay](https://twitter.com/madcapnmckay)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 : 

# Crafting a high-performance TV user interface using React

The Netflix TV interface is constantly evolving as we strive to figure out the best experience for our members. For example, after [A/B testing](http://techblog.netflix.com/2016/04/its-all-about-testing-netflix.html), eye-tracking research, and customer feedback we recently rolled out [video previews](https://www.fastcompany.com/3066166/innovation-agents/netflix-launches-video-previews-how-the-company-landed-on-its-biggest-rede) to help members make better decisions about what to watch. We’ve [written before](http://techblog.netflix.com/2013/11/building-new-netflix-experience-for-tv.html) about how our TV application consists of an SDK installed natively on the device, a JavaScript application that can be updated at any time, and a rendering layer known as Gibbon. In this post we’ll highlight some of the strategies we’ve employed along the way to optimize our JavaScript application performance.

## React-Gibbon

In 2015, we embarked on a wholesale rewrite and modernization of our TV UI architecture. We decided to use React because its one-way data flow and declarative approach to UI development make it easier to reason about our app. Obviously, we’d need our own flavor of React since at that time it only targeted the DOM. We were able to create a prototype that targeted Gibbon pretty quickly. This prototype eventually evolved into React-Gibbon and we began to work on building out our new React-based UI.

React-Gibbon’s API would be very familiar to anyone who has worked with React-DOM. The primary difference is that instead of divs, spans, inputs etc, we have a single “widget” drawing primitive that supports inline styling.

```
React.createClass({
    render() {
        return <Widget style={{ text: 'Hello World', textSize: 20 }} />;
    }
});
```

## Performance is a key challenge

Our app runs on hundreds of different devices, from the latest game consoles like the PS4 Pro to budget consumer electronics devices with limited memory and processing power. The low-end machines we target can often have sub-GHz single core CPUs, low memory and limited graphics acceleration. To make things even more challenging, our JavaScript environment is an older non-JIT version of JavaScriptCore. These restrictions make super responsive 60fps experiences especially tricky and drive many of the differences between React-Gibbon and React-DOM.

### Measure, measure, measure

When approaching performance optimization it’s important to first identify the metrics you will use to measure the success of your efforts. We use the following metrics to gauge overall application performance:

- 
Key Input Responsiveness - the time taken to render a change in response to a key press

- 
Time To Interactivity - the time to start up the app

- 
Frames Per Second - the consistency and smoothness of our animations

- 
Memory Usage

The strategies outlined below are primarily aimed at improving key input responsiveness. They were all identified, tested and measured on our devices and are not necessarily applicable in other environments. As with all “best practice” suggestions it is important to be skeptical and verify that they work in your environment, and for your use case. We started off by using profiling tools to identify what code paths were executing and what their share of the total render time was; this lead us to some interesting observations. 

### Observation: React.createElement has a cost

When Babel transpiles JSX it converts it into a number of React.createElement function calls which when evaluated produce a description of the next Component to render. If we can predict what the createElement function will produce, we can inline the call with the expected result at build time rather than at runtime.

```
// JSX
render() {
    return <MyComponent key='mykey' prop1='foo' prop2='bar' />;
}

// Transpiled
render() {
    return React.createElement(MyComponent, { key: 'mykey', prop1: 'foo', prop2: 'bar' });
}

// With inlining
render() {
    return {
        type: MyComponent,
        props: {
            prop1: 'foo', 
            prop2: 'bar'
        },
        key: 'mykey'
    };
}
```

As you can see we have removed the cost of the createElement call completely, a triumph for the “can we just not?” school of software optimization.

We wondered whether it would be possible to apply this technique across our whole application and avoid calling createElement entirely. What we found was that if we used a ref on our elements, createElement needs to be called in order to hook up the owner at runtime. This also applies if you’re using the [spread operator](https://facebook.github.io/react/docs/jsx-in-depth.html#spread-attributes) which may contain a ref value (we’ll come back to this later). 

We use a custom Babel plugin for element inlining, but there is an official [plugin](https://babeljs.io/docs/plugins/transform-react-inline-elements/) that you can use right now. Rather than an object literal, the official plugin will emit a call to a helper function that is likely to disappear thanks to the magic of V8 [function inlining](https://ariya.io/2013/04/automatic-inlining-in-javascript-engines). After applying our plugin there were still quite a few components that weren’t being inlined, specifically Higher-order Components which make up a decent share of the total components being rendered in our app.

### Problem: Higher-order Components can’t use Inlining

We love [Higher-order Components](https://facebook.github.io/react/docs/higher-order-components.html) (HOCs) as an alternative to mixins. HOCs make it easy to layer on behavior while maintaining a separation of concerns. We wanted to take advantage of inlining in our HOCs, but we ran into an issue: HOCs usually act as a pass-through for their props. This naturally leads to the use of the spread operator, which prevents the Babel plug-in from being able to inline. 

When we began the process of rewriting our app, we decided that all interactions with the rendering layer would go through declarative APIs. For example, instead of doing:

```
componentDidMount() {
    this.refs.someWidget.focus()
}
```

In order to move application focus to a particular Widget, we instead implemented a declarative focus API that allows us to describe what should be focused during render like so:

```
render() {
    return <Widget focused={true} />;
}
```

This had the fortunate side-effect of allowing us to avoid the use of refs throughout the application. As a result we were able to apply inlining regardless of whether the code used a spread or not.

```
// before inlining
render() {
    return <MyComponent {...this.props} />;
}

// after inlining
render() {
    return {
        type: MyComponent,
        props: this.props
    };
}
```

This greatly reduced the amount of function calls and property merging that we were previously having to do but it did not eliminate it completely. 

### Problem: Property interception still requires a merge

After we had managed to inline our components, our app was still spending a lot of time merging properties inside our HOCs. This was not surprising, as HOCs often intercept incoming props in order to add their own or change the value of a particular prop before forwarding on to the wrapped component. 

We did analysis of how stacks of HOCs scaled with prop count and component depth on one of our devices and the results were informative.

![Screenshot 2017-01-11 12.31.30.png](https://lh4.googleusercontent.com/9S0doBpyo_e_ON1Odxef6Ak3y74xqxIcFL5EjsrFfBUy81gKwu1svsNVxe-nbzdEmymB4kPhPKJEJI5La8iIzNc5opZToVe4GB0g6AuoZU60tGY33-_zvpyuHTJRUQRw50BvoUCx)

They showed that there is a roughly linear relationship between the number of props moving through the stack and the render time for a given component depth.

**Death by a thousand props**

Based on our findings we realized that we could improve the performance of our app substantially by limiting the number of props passed through the stack. We found that groups of props were often related and always changed at the same time. In these cases, it made sense to group those related props under a single “namespace” prop. If a namespace prop can be modeled as an immutable value, subsequent calls to shouldComponentUpdate calls can be optimized further by checking referential equality rather than doing a deep comparison. This gave us some good wins but eventually we found that we had reduced the prop count as much as was feasible. It was now time to resort to more extreme measures.

**Merging props without key iteration**

Warning, here be dragons! This is not recommended and most likely will break many things in weird and unexpected ways.

After reducing the props moving through our app we were experimenting with other ways to reduce the time spent merging props between HOCs. We realized that we could use the prototype chain to achieve the same goals while avoiding key iteration.

```
// before proto merge
render() {
    const newProps = Object.assign({}, this.props, { prop1: 'foo' })
    return <MyComponent {...newProps} />;
}

// after proto merge
render() {
    const newProps = { prop1: 'foo' };
    newProps.__proto__ = this.props;
    return {
        type: MyComponent,
        props: newProps
    };
}
```

In the example above we reduced the 100 depth 100 prop case from a render time of ~500ms to ~60ms. Be advised that using this approach introduced some interesting bugs, namely in the event that this.props is a [frozen object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze) . When this happens the prototype chain approach only works if the __proto__ is assigned after the newProps object is created. Needless to say, if you are not the owner of newProps it would not be wise to assign the prototype at all.

### Problem: “Diffing” styles was slow

Once React knows the elements it needs to render it must then diff them with the previous values in order to determine the minimal changes that must be applied to the actual DOM elements. Through profiling we found that this process was costly, especially during mount - partly due to the need to iterate over a large number of style properties. 

**Separate out style props based on what’s likely to change**

We found that often many of the style values we were setting were never actually changed. For example, say we have a Widget used to display some dynamic text value. It has the properties text, textSize, textWeight and textColor. The text property will change during the lifetime of this Widget but we want the remaining properties to stay the same. The cost of diffing the 4 widget style props is spent on each and every render. We can reduce this by separating out the things that could change from the things that don't.

```
const memoizedStylesObject = { textSize: 20, textWeight: ‘bold’, textColor: ‘blue’ };
```

```
<Widget staticStyle={memoizedStylesObject} style={{ text: this.props.text }} />
```

If we are careful to memoize the ```memoizedStylesObject``` object, React-Gibbon can then check for referential equality and only diff its values if that check proves false. This has no effect on the time it takes to mount the widget but pays off on every subsequent render.

**Why not avoid the iteration all together?**

Taking this idea further, if we know what style props are being set on a particular widget, we can write a function that does the same work without having to iterate over any keys. We wrote a custom Babel plugin that performed static analysis on component render methods. It determines which styles are going to be applied and builds a custom diff-and-apply function which is then attached to the widget props. 

```
// This function is written by the static analysis plugin
function __update__(widget, nextProps, prevProps) {
    var style = nextProps.style,
        prev_style = prevProps && prevProps.style;


    if (prev_style) {
        var text = style.text;
        if (text !== prev_style.text) {
            widget.text = text;
        }
    } else {
        widget.text = style.text;
    }
}
```

```
React.createClass({
    render() {
        return (
            <Widget __update__={__update__} style={{ text: this.props.title }}  />
        );
    }
});
```

Internally React-Gibbon looks for the presence of the “special” __update__ prop and will skip the usual iteration over previous and next style props, instead applying the properties directly to the widget if they have changed. This had a huge impact on our render times at the cost of increasing the size of the distributable.

## Performance is a feature

Our environment is unique, but the techniques we used to identify opportunities for performance improvements are not. We measured, tested and verified all of our changes on real devices. Those investigations led us to discover a common theme: key iteration was expensive. As a result we set out to identify merging in our application, and determine whether they could be optimized. Here’s a list of some of the other things we’ve done in our quest to improve performance:

- 
Custom Composite Component - hyper optimized for our platform

- 
Pre-mounting screens to improve perceived transition time

- 
Component pooling in Lists

- Memoization of expensive computations
