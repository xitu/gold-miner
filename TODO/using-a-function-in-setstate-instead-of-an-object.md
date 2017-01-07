> * 原文地址：[Using a function in `setState` instead of an object](https://medium.com/@shopsifter/using-a-function-in-setstate-instead-of-an-object-1f5cfd6e55d1#.hwznlbxsa)
* 原文作者：[Sophia Shoemaker](https://medium.com/@shopsifter?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# Using a function in `setState` instead of an object #

# 在 `setState` 使用函数替代对象 #

The [React documentation](https://facebook.github.io/react/docs/hello-world.html) has recently been revamped — if you haven’t checked it out yet, you should! I have been helping out a little bit with the documentation by writing up a “Glossary of React Terms” and in that process I’ve been thoroughly reading all the new documentation. In reading the documentation I found out about a relatively unknown aspect of `setState` and inspired by this tweet:

[React 文档](https://facebook.github.io/react/docs/hello-world.html) 最近改版了——如果你还没看过，你的确应该去看看！通过写一份“React 术语词典”我已经对文档有点豁然开朗的感觉，过程中我也深入地通读了新的文档。阅读文档的时候，我发现了 `setState` 相对不为人知的一面，并被这个推文醍醐灌顶：

![Markdown](http://i1.piimg.com/1949/60dac91b11e33375.png)

I thought I’d write a blog post explaining how it works.

我想我要写一篇博文来解释一番。

### First, a little background ###

### 首先，介绍一下背景 ###

Components in React are independent and reusable pieces of code that often contain their own state. They return React elements that make up the UI of an application. Components that contain local state have a property called `state` When we want to change our how application looks or behaves, we need to change our component’s state. So, how do we update the state of our component? React components have a method available to them called `setState` Calling `this.setState` causes React to re-render your application and update the DOM.

React 中的组件是独立、可重用的代码块，它们经常有自己的状态，组件返回的 React 元素组成了应用的 UI 界面。含有本地状态的组件会有一个名为 `state` 的属性，当我们想要改变应用的外观或表现形式时，我们需要改变组件的状态。那么我们如何更新组件的状态呢？React 组件中有一个可用的方法叫做 `setState`，它通过调用 `this.setState` 来使得 React 重新渲染你的应用并升级 DOM。

Normally, when we want to update our component we just call `setState` with a new value by passing in an object to the `setState` function: `this.setState({someField:someValue})`

通常更新组件的时候，我们调用 `setState` 函数并以对象的形式传入一个新的值：`this.setState({someField:someValue})`。

But, often there is a need to update our component’s state using the current state of the component. Directly accessing `this.state` to update our component is not a reliable way to update our component’s next state. From the React documentation:

但是经常会需要使用当前状态去更新组件的状态，直接访问 `this.state` 来更新组件并不能可靠地更新组件的下个状态。根据 React 的文档：

> Because `this.props` and `this.state` may be updated asynchronously, you should not rely on their values for calculating the next state.

> 因为 `this.props` 和 `this.state` 存在异步更新的可能，你不应该依赖他们的值来计算下一个状态。

The key word from that documentation is **asynchronously. **Updates to the DOM don’t happen immediately when `this.setState` is called. React batches updates so elements are re-rendered to the DOM efficiently.

文档中的关键词是**异步**！当调用 `this.setState` 时，DOM 并不能马上更新，React 会分批次地更新，这样才能更高效地重新渲染所有的组件。

### An example ###

### 示例 ###

Let’s look at a typical example of how to use `setState` In Shopsifter, I have a feedback form which, after the user submits his/her feedback, shows a thank you message like so:

我们来看一下在 Shopsifter 中使用 `setState` 的典型例子（我用于收集反馈信息），在用户提交他/她的反馈信息之后，页面会显示感谢信息如下：

![](https://cdn-images-1.medium.com/freeze/max/30/1*2G0xhu4tOAAEODKSsRB_2w.gif?q=20) 

![](https://cdn-images-1.medium.com/max/800/1*2G0xhu4tOAAEODKSsRB_2w.gif) 

The component for the feedback page has a `showForm` boolean which determines whether the form or the thank you message should display. The initial state of my feedback form component looks like this:

反馈页面的组件拥有一个布尔值的 `showForm` 属性，该属性决定了应该显示表单还是感谢信息。我的反馈表单组件的初始化状态是这样的：

```
this.state = { showForm : true}
```

Then, when the user clicks the submit button, I call this function:

然后，当用户点击了提交按钮，我调用了这个函数：

```
submit(){
  this.setState({showForm : !this.state.showForm});
}
```

I am relying on the value of `this.state.showForm` to modify the next state of my form. In this simple example, we probably would not run into any issues by relying on this value, but you might imagine that as an application gets more complex and there are multiple `setState` calls happening and queuing up data to be rendered to the DOM, there is a possibility that the actual value of `this.state.showForm` might not be what you think.

我依赖于 `this.state.showForm`的值来改变表单的下一个状态。这个简单的例子中，依赖这个值可能并不会导致任何问题，但是想象一下，当一个应用变得更加复杂，会有很多次调用 `setState` 并将待渲染至 DOM 的数据存储在队列中，可能 `this.state.showForm` 的实际状态并不是你所认为的样子。

![](https://cdn-images-1.medium.com/max/800/1*LY5htRQwi_NOHhMRI2cTSw.jpeg)

If we shouldn’t rely on `this.state` to calculate the next value, how do we calculate the next value?

如果我们不依赖于 `this.state` 来计算下一个值，我们该怎样做呢？

### Function in `setState` to the rescue! ###

### `setState` 中的函数来拯救你了！ ###

Instead of passing in an object to `this.setState` we can pass in a function and reliably get the value of the current state of our component. My submit function from above now looks like this:

我们可以向 `this.setState` 传入一个函数来替代传入对象，并且可以可靠地获取组件的当前状态。上文的提交函数现在是这样写的：

```
submit(){
   this.setState(function(prevState, props){
      return {showForm: !prevState.showForm}
   });

}
```

Passing in a function into `setState` instead of an object will give you a reliable value for your component’s `state` and `props`. One thing to note is that the React documentation makes use of arrow functions in their examples (which is also on my list of things to migrate to in my Shopsifter app!) so in my example above I’m using ES5 syntax for my function.

通过使用函数替代对象传入 `setState` 的方式能够得到组件的 `state` 和 `props` 属性可靠的值。值得注意的一点是，在 React 文档的例子中使用了箭头函数（这也是我将要应用到我的 Shopsifter 应用中的一项内容），因此上文的例子中我的函数使用的仍然是 ES5 的语法。

If you know you’re going to use `setState` to update your component and you know you’re going to need the current state or the current props of your component to calculate the next state, passing in a function as the first parameter of `this.setState` instead of an object is the recommended solution.

如果你知道自己将要使用 `setState` 来更新组件，并且你知道自己将要使用当前组件的状态或者属性值来计算下一个状态，我推荐你传入一个函数作为 `this.setState` 的第一个参数而不用数组的解决方案。

![Markdown](http://p1.bpimg.com/1949/d70206a3c3c06515.png) 

I hope this helps you make better, more reliable React applications!

我希望这能帮助你做出更好、更可靠的 React 应用！