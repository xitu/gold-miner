> * 原文地址：[Using a function in `setState` instead of an object](https://medium.com/@shopsifter/using-a-function-in-setstate-instead-of-an-object-1f5cfd6e55d1#.hwznlbxsa)
* 原文作者：[Sophia Shoemaker](https://medium.com/@shopsifter?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# Using a function in `setState` instead of an object #

The [React documentation](https://facebook.github.io/react/docs/hello-world.html) has recently been revamped — if you haven’t checked it out yet, you should! I have been helping out a little bit with the documentation by writing up a “Glossary of React Terms” and in that process I’ve been thoroughly reading all the new documentation. In reading the documentation I found out about a relatively unknown aspect of `setState` and inspired by this tweet:

![Markdown](http://i1.piimg.com/1949/60dac91b11e33375.png)

I thought I’d write a blog post explaining how it works.

### First, a little background ###

Components in React are independent and reusable pieces of code that often contain their own state. They return React elements that make up the UI of an application. Components that contain local state have a property called `state` When we want to change our how application looks or behaves, we need to change our component’s state. So, how do we update the state of our component? React components have a method available to them called `setState` Calling `this.setState` causes React to re-render your application and update the DOM.

Normally, when we want to update our component we just call `setState` with a new value by passing in an object to the `setState` function: `this.setState({someField:someValue})`

But, often there is a need to update our component’s state using the current state of the component. Directly accessing `this.state` to update our component is not a reliable way to update our component’s next state. From the React documentation:

> Because `this.props` and `this.state` may be updated asynchronously, you should not rely on their values for calculating the next state.

The key word from that documentation is **asynchronously. **Updates to the DOM don’t happen immediately when `this.setState` is called. React batches updates so elements are re-rendered to the DOM efficiently.

### An example ###

Let’s look at a typical example of how to use `setState` In Shopsifter, I have a feedback form which, after the user submits his/her feedback, shows a thank you message like so:

![](https://cdn-images-1.medium.com/freeze/max/30/1*2G0xhu4tOAAEODKSsRB_2w.gif?q=20) 

![](https://cdn-images-1.medium.com/max/800/1*2G0xhu4tOAAEODKSsRB_2w.gif) 

The component for the feedback page has a `showForm` boolean which determines whether the form or the thank you message should display. The initial state of my feedback form component looks like this:

```
this.state = { showForm : true}
```

Then, when the user clicks the submit button, I call this function:

```
submit(){
  this.setState({showForm : !this.state.showForm});
}
```

I am relying on the value of `this.state.showForm` to modify the next state of my form. In this simple example, we probably would not run into any issues by relying on this value, but you might imagine that as an application gets more complex and there are multiple `setState` calls happening and queuing up data to be rendered to the DOM, there is a possibility that the actual value of `this.state.showForm` might not be what you think.

![](https://cdn-images-1.medium.com/max/800/1*LY5htRQwi_NOHhMRI2cTSw.jpeg)

If we shouldn’t rely on `this.state` to calculate the next value, how do we calculate the next value?

### Function in `setState` to the rescue! ###

Instead of passing in an object to `this.setState` we can pass in a function and reliably get the value of the current state of our component. My submit function from above now looks like this:

```
submit(){
   this.setState(function(prevState, props){
      return {showForm: !prevState.showForm}
   });

}
```

Passing in a function into `setState` instead of an object will give you a reliable value for your component’s `state` and `props`. One thing to note is that the React documentation makes use of arrow functions in their examples (which is also on my list of things to migrate to in my Shopsifter app!) so in my example above I’m using ES5 syntax for my function.

If you know you’re going to use `setState` to update your component and you know you’re going to need the current state or the current props of your component to calculate the next state, passing in a function as the first parameter of `this.setState` instead of an object is the recommended solution.

![Markdown](http://p1.bpimg.com/1949/d70206a3c3c06515.png) 

I hope this helps you make better, more reliable React applications!
