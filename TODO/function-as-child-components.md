> * 原文地址：[Function as Child Components](http://merrickchristensen.com/articles/function-as-child-components.html)
> * 原文作者：[Merrick](http://merrickchristensen.com/about.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[rottenpen](https://github.com/rottenpen)
> * 校对者：[loveky](https://github.com/loveky) [avocadowang](https://github.com/avocadowang) 

# 将函数作为子组件的组件 #

我最近在 Twitter 上发起了关于高阶组件和将函数作为子类的组件的投票，得到的结果让我很意外。

如果你不知什么是“函数作为子组件的组件”，我试图通过这篇文章告诉你：

1. 函数作为子组件的组件是什么。

2. 它为什么有用。

3. 我只想享受分享的快乐，而不是收获一些 Twitter 转发，点赞，或是上一些 newsletter 等等。你懂我的意思吧？


## 什么是函数作为子组件的组件？ ##

“函数作为子组件的组件”是接收一个函数当作子组件的组件。这种模式的实施和执行得益于 React 的 property types。

```
class MyComponent extends React.Component{   
  render() {  
    return (  
        <div>
          {this.props.children('Scuba Steve')}
        </div>
    );  
  }  
}

MyComponent.propTypes = {  
  children: React.PropTypes.func.isRequired,  
};

```

没错！通过函数作为子类组件的组件我们就能解耦父类组件和它们的子类组件，让设计者决定选用哪些参数及怎么将参数应用于子类组件。例如：

```
<MyComponent>
  {(name) => (
    <div>{name}</div>
  )}
</MyComponent>

```

其他使用这一组件的人可能考虑以不同的方式使用 name ，比如使之作为一个元素的属性：

```
<MyComponent>
  {(name) => (
    <img src=’/scuba-steves-picture.jpg’ alt={name} />
  )}
</MyComponent>
```

这里真正奇妙的地方在于，MyComponent ，可以让函数作为子类组件的组件管理状态而不用关心它们是如何使用这些状态的。让我们再来一个更真实的例子。

### 百分比组件 ###

Ratio 组件将使用设备的宽度，监听 resize 事件并将宽度、高度以及一些描述是否完成尺寸计算的信息传给它的子组件。

首先我们从函数作为子类组件的组件的代码片段开始，这片段在所有子组件函数中都是常见的，它只是让 Comsumer 知道我们期望一个函数作为子组件，而不是 React 节点。

```
class Ratio extends React.Component{  
  render() {  
    return (  
        {this.props.children()}  
    );  
  }  
}

Ratio.propTypes = {  
 children: React.PropTypes.func.isRequired,  
};

```

接下来让我们设计 API ，我们想要一个 X Y 轴的比率，然后我们使用当前的宽度来计算，可以设置一些内部 state 来管理宽度和高度，无论我们是否已经计算了。此外，也该让 propTypes 和 defaultProps 在使用组件时发挥点作用。

```
class Ratio extends React.Component{  

  constructor() {  
    super(...arguments);  
    this.state = {  
      hasComputed: false,  
      width: 0,  
      height: 0,   
    };  
  }

  render() {  
    return (  
      {this.props.children()}  
    );  
  }  
}

Ratio.propTypes = {  
  x: React.PropTypes.number.isRequired,  
  y: React.PropTypes.number.isRequired,  
  children: React.PropTypes.func.isRequired,  
};

Ratio.defaultProps = {  
  x: 3,  
  y: 4  
};

```

实际上我们还没有做什么有趣的事情，让我们来添加一些事件监听，并计算实际宽度（根据我们比率的变化）：

```
class Ratio extends React.Component{

  constructor() {
    super(...arguments);
    this.handleResize = this.handleResize.bind(this);
    this.state = {
      hasComputed: false,
      width: 0,
      height: 0, 
    };
  }

  getComputedDimensions({x, y}) {
    const {width} = this.container.getBoundingClientRect();
return {
      width,
      height: width * (y / x), 
    };
  }

  componentWillReceiveProps(next) {
    this.setState(this.getComputedDimensions(next));
  }

  componentDidMount() {
    this.setState({
      ...this.getComputedDimensions(this.props),
      hasComputed: true,
    });
    window.addEventListener('resize', this.handleResize, false);
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize, false);
  }

  handleResize() {
    this.setState({
      hasComputed: false,
    }, () => {
      this.setState({
        hasComputed: true,
        ...this.getComputedDimensions(this.props),
      });
    });
  }

  render() {
    return (
      <div ref={(ref) => this.container = ref}>
        {this.props.children(this.state.width, this.state.height, this.state.hasComputed)}
      </div>
    );
  }
}

Ratio.propTypes = {
  x: React.PropTypes.number.isRequired,
  y: React.PropTypes.number.isRequired,
  children: React.PropTypes.func.isRequired,
};

Ratio.defaultProps = {
  x: 3,
  y: 4
};

```

好吧，在这我做了很多东西。我们添加了一些事件监听来监听 resize 事件以及使用提供的比率计算实际的宽度高度。所以我们得到的宽高在组件的 state 里，那我们如何与其他组件共享它们呢？

这是一件难以理解的事情，因为它很容易让人认为“这就完了？”，但事实这就是全部了。

#### 子类组件只是一个 Javascript 函数 ####

这意味着想要计算出宽度和高度，我们只需要提供参数：

```
render() {
    return (
      <div ref='container'>
        {this.props.children(this.state.width, this.state.height, this.state.hasComputed)}
      </div>
    );
}

```

现在任何人都可以使用比例组件通过提供的宽度以他们喜欢的方式来正确计算出高度！例如，有人可以使用比例组件来设置 img 上的比例：

```
<Ratio>
  {(width, height, hasComputed) => (
    hasComputed 
      ? <img src='/scuba-steve-image.png' width={width} height={height} /> 
      : null
  )}
</Ratio>
```

同时，在另一个文件中，有人决定使用它来设置 CSS 属性。

```
<Ratio>
  {(width, height, hasComputed) => (
    <div style={{width, height}}>Hello world!</div>
  )}
</Ratio>

```

在另一个 app 里，有人正根据计算高度使用不同的子类组件:

```
<Ratio>
  {(width, height, hasComputed) => (
    hasComputed && height > TOO_TALL
      ? <TallThing />
      : <NotSoTallThing />
  )}
</Ratio>
```

### 优势 ###
1. 构造组件的开发人员能自主控制如何传递和使用这些属性。
2. 函数作为子类组件的组件的作者不强制组件的值如何被利用，允许它非常灵活的使用。
3. 组件使用者不需要创建另一个组件来决定怎样从“高阶组件”传入属性。高阶组件通常在组成的组件上强制执行属性名称。 为了解决这个问题，许多“高阶组件”提供了一个选择器函数，允许组件使用者选择属性名称（请参考 redux 里 connect 选择函数）。而函数子组件没有这样的问题。
4. 不污染 “props” 命名空间，这允许你同时使用 “Ratio” 组件和 “Pinch to Zoom” 组件，不管它们是否都会计算宽度。高阶组件带有与它们组成的组件相关的隐式契约，不幸的是这可能意味着 prop 的名称会发生冲突以至于高阶组件无法与其他组件进行组合。
5. 高阶组件在你的开发工具和组件本身中创建一个间接层，例如设置在组件上的常量被高阶组件封装后将无法使用。例如：

```
MyComponent.SomeContant = 'SCUBA';

```

然后被高阶组件封装，

```
exportdefault connect(...., MyComponent);

```

和你的常量说再见吧。因为如果没有高阶组件提供的函数，你将再也不能访问到这个常量。哭。

#### 总结 ####
大多数时候我们会认为“我需要一个高阶组件来实现这个共享功能！”根据我的经验，我相信在多数情况下函数作为子类组件的组件是一个更好的替代方法来抽象你的 UI 问题，除非你的子组件与其组合的高阶组件真正耦合。

#### 关于高阶组件的不幸事实 ####
补充一下，我认为高阶组件的名称不正确，尽管现在尝试修改已经有点晚了。高阶函数是至少执行以下操作之一的函数：
1. 将n个函数作为参数。
2. 返回一个函数作为结果。

事实上，我们常说的高阶组件做了类似的事情，也就是拿一个组件作为参数并返回一个组件，但是我更容易将高阶组件看作是工厂函数，它是一个能动态创建的组件将允许的功能用于组件的运行组合。然而，在运行组合的时候他们是**不知道**你的 React 的 state 和 props 。

函数作为子类组件的组件允许你的组件们在作出组合决策时可以访问 state ， props 和上下文。当函数作为子组件：

1. 将一个函数作为参数。
2. 渲染此函数的结果。

我觉得它们应该被命名为真正的“高阶组件”，因为它像高阶函数只使用组件组合技术而不是功能组合。好吧，现在我们还是继续用“将函数作为子类的组件”这个粗暴的名字。
### 例子 ###

1. [Pinch to Zoom - Function as Child Component](https://gist.github.com/iammerrick/c4bbac856222d65d3a11dad1c42bdcca)
2. [react-motion](https://github.com/chenglou/react-motion) 这个项目在讲了很长一段时间这个概念之后，高阶组件才演变出函数作为子类组件的组件。

### 不好之处（补充翻译 by 老教授） ###

虽然函数作为子组件的组件这种模式可以让你在渲染的时候更灵活，但是，在不特地改动你的组件的前提下，你没法用标准的 SCU 对它进行优化。这个 Dan（Redux 作者）在 tweeter 上说过了。

不过 Dan 也提到这里有一个灰色地带：“很多情况下其实这并不是问题，react-motion 就用了这种模式，依然跑得好好的”。

目前为止我个人并没有发现它成为性能的阻碍。即便是高阶组件也会有类似问题，也时常要接收一些未知的属性，所以也经常要做些特殊优化。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
