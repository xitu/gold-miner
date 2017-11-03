> * 原文地址：[Using a function in `setState` instead of an object](https://medium.com/@shopsifter/using-a-function-in-setstate-instead-of-an-object-1f5cfd6e55d1#.hwznlbxsa)
* 原文作者：[Sophia Shoemaker](https://medium.com/@shopsifter?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[John Chong](https://github.com/Goshin)、[Tina92](https://github.com/Tina92)

# 在 `setState` 中使用函数替代对象 #

[React 文档](https://facebook.github.io/react/docs/hello-world.html) 最近改版了——如果你还没看过，你的确应该去看看！通过写一份“React 术语词典”我越来越有豁然开朗的感觉了，其过程中我也深入地通读了新文档的全部内容。阅读文档的时候，我发现了 `setState` 相对不为人知的一面，并由这个推文大受启发：

![Markdown](http://i1.piimg.com/1949/60dac91b11e33375.png)

我想我要写一篇博文来解释其原理。

### 先介绍一下背景 ###

React 中的组件是独立、可重用的代码块，它们经常有自己的状态。组件返回的 React 元素组成了应用的 UI 界面。含有本地状态的组件会有一个名为 `state` 的属性，当我们想要改变应用的外观或表现形式时，我们需要改变组件的状态。那么我们如何更新组件的状态呢？React 组件中有一个可用的方法叫做 `setState`，它通过调用 `this.setState` 来使得 React 重新渲染你的应用并更新 DOM。

通常更新组件的时候，我们只要调用 `setState` 函数并以对象的形式传入一个新的值：`this.setState({someField:someValue})`。

但是经常会需要使用当前状态去更新组件的状态，直接访问 `this.state` 来更新组件到下一个状态并是不可靠的方式。根据 React 的文档：

> 因为 `this.props` 和 `this.state` 存在异步更新的可能，你不应该根据这些值计算下一个状态。

文档中的关键词是**异步**！当调用 `this.setState` 时，DOM 并不能马上更新，React 会分批次地更新，这样才能更高效地重新渲染所有的组件。

### 示例 ###

我们来看一下在 Shopsifter 中使用 `setState` 的典型例子（我用于收集反馈信息），在用户提交他/她的反馈信息之后，页面会显示感谢信息如下：

![](https://cdn-images-1.medium.com/freeze/max/30/1*2G0xhu4tOAAEODKSsRB_2w.gif?q=20) 

![](https://cdn-images-1.medium.com/max/800/1*2G0xhu4tOAAEODKSsRB_2w.gif) 

反馈页面的组件拥有一个布尔值的 `showForm` 属性，该值决定了应该显示表单还是感谢信息。我的反馈表单组件的初始化状态是这样的：

```
this.state = { showForm : true}
```

然后，当用户点击了提交按钮，我调用了这个函数：

```
submit(){
  this.setState({showForm : !this.state.showForm});
}
```

我依赖于 `this.state.showForm`的值来改变表单的下一个状态。这个简单的例子中，依赖这个值可能并不会导致任何问题，但是想象一下，当一个应用变得更加复杂，会有很多次调用 `setState` 并依次将数据渲染至 DOM ，可能 `this.state.showForm` 的实际状态并不是你所认为的样子。

![](https://cdn-images-1.medium.com/max/800/1*LY5htRQwi_NOHhMRI2cTSw.jpeg)

如果我们不依赖于 `this.state` 来计算下一个值，我们该怎样做呢？

### `setState` 中的函数来拯救你了！ ###

我们可以向 `this.setState` 传入一个函数来替代传入对象，并且可以可靠地获取组件的当前状态。上文的提交函数现在是这样写的：

```
submit(){
   this.setState(function(prevState, props){
      return {showForm: !prevState.showForm}
   });

}
```

通过使用函数替代对象传入 `setState` 的方式能够得到组件的 `state` 和 `props` 属性可靠的值。值得注意的一点是，在 React 文档的例子中使用了箭头函数（这也是我将要应用到我的 Shopsifter 应用中的一项内容），因此上文的例子中我的函数使用的仍然是 ES5 的语法。

如果你知道自己将要使用 `setState` 来更新组件，并且你知道自己将要使用当前组件的状态或者属性值来计算下一个状态，我推荐你传入一个函数作为 `this.setState` 的第一个参数而不用对象的解决方案。

![Markdown](http://p1.bpimg.com/1949/d70206a3c3c06515.png) 

我希望这能帮助你做出更好、更可靠的 React 应用！