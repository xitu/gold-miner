> * 原文地址：[Function as Child Components](http://merrickchristensen.com/articles/function-as-child-components.html)
> * 原文作者：[Merrick](http://merrickchristensen.com/about.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[rottenpen](https://github.com/rottenpen)
> * 校对者：[loveky](https://github.com/loveky) [avocadowang](https://github.com/avocadowang) 


# 函数式子类组件 #（这个名字待定）

我最近在 Twitter 上关注了高阶组件和函数式子类组件，得到的结果让我很惊喜。

如果你不知什么是“函数式子类组件”，我试图通过这篇文章告诉你：

1. 是什么。

2. 为什么有用。

3. 我只想享受分享的快乐，而获取不是点赞，转发或者别的，你懂我的意思吧？

## 什么是函数式子组件？ ##

“函数式子类组件”是接收一个函数当作父组件的子类组件。

```
classMyComponentextendsReact.Component{   
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

没错！通过子类组件函数我们就能解耦父类组件和他们的子类，让设计者决定选用哪些参数及怎么将参数应用于子类组件。例如：

```
<MyComponent>
  {(name) => (
    <div>{name}</div>
  )}
</MyComponent>

```

有些人打算在同一组件里添加不同名字，或者不同属性：

```
<MyComponent>
  {(name) => (
    <imgsrc=’/scuba-steves-picture.jpg’alt={name} />
  )}
</MyComponent>
```

对 MyComponent 最贴切的说法是，函数子组件作为父类管理状态的组件，而不是对其状态的利用。让我们再来一个更真实的例子。

### 百分比组件 ###

Ratio 组件将使用设备的宽度，监听 resize 事件和返回它的子类们一个宽度，高度和一些关于是否计算了尺寸的信息。

首先我们从函数子组件的片段开始，这片段在所有函数子组件中都是常见的，它只是让消费者知道我们期望一个函数作为子组件，而不是 React 节点。

```
classRatioextendsReact.Component{  
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

接下来让我们设计 API ，我们想要一个 X Y 轴的比率，然后我们使用当前的宽度来计算，可以设置一些内部 state 来管理宽度和高度，无论我们是否已经计算了。此外，propTypes 和 defaultProps 在我们使用组件的时候也该有不错的表现。

```
classRatioextendsReact.Component{  

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

实际上我们没有做任何有趣的事情，让我们来添加一些事件监听，并计算实际宽度（根据我们比率的变化）：

```
classRatioextendsReact.Component{

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
      <divref={(ref) => this.container = ref}>
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

好吧，在这我做了很多东西。我们添加了一些事件监听来监听 resize 事件以及使用提供的比率计算实际的宽度高度。所以我们得到了一个宽高在组件的 state 里，那我们如何与其他组件分享它们呢？

这是一件难以理解的事情，因为它很容易让人认为“这不可能是全部”，但事实这就是全部了。

#### 子类组件只是一个 javascript 函数 ####

这意味着为了计算宽度和高度，我们只需要提供参数：

```
render() {
    return (
      <divref='container'>
        {this.props.children(this.state.width, this.state.height, this.state.hasComputed)}
      </div>
    );
}

```

现在任何人都可以使用比例组件通过提供的宽度以他们喜欢的方式来正确计算出高度！例如，有人可以使用比例组件来设置img上的比例：

```
<Ratio>
  {(width, height, hasComputed) => (
    hasComputed 
      ? <imgsrc='/scuba-steve-image.png'width={width}height={height} /> 
      : null
  )}
</Ratio>
```

同时，在另一个文件中，有人决定使用它来设置CSS属性。

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
2. 函数式子组件的作者不强制组件的值如何被利用，允许它非常灵活的使用。
3. Comsumer 不需要创建另一个组件来决定怎样从“高阶组件”传入属性。高阶组件通常在组成的组件上强制执行属性名称。 为了解决这个问题，许多“高阶组件”提供了一个选择器函数，允许消费者选择你的属性名称（请参考 redux 连接选择功能）。这不是函数子组件的问题。
4. 不污染 “props” 命名空间，这允许你同时使用 “Ratio” 组件和 “Pinch to Zoom” 组件，不管它们是否都会计算宽度。高阶组件带有与它们组成的组件相关的隐式契约，不幸的是这可能意味着 prop 的名称会发生冲突以至于高阶组件无法与其他组件进行组合。
5. 高阶组件在你的开发工具和组件本身中创建一个间接层，例如设置在组件上的常量被高阶组件封装后将无法使用。例如：

```
MyComponent.SomeContant = 'SCUBA';

```

然后被组件封装,

```
exportdefault connect(...., MyComponent);

```
.
RIP 你的常数（？）。如果没有高阶组件提供的函数则不可再访问底层组件。哭。

#### 总结 ####
大多数时候我们会认为“我需要一个高阶组件来实现这个共享功能！”根据我的经验，我相信在多数情况下函数式子组件是一个更好的替代方法来抽象你的UI问题，除非你的子组件与其组合的高阶组件真正耦合。

#### 关于高阶组件的不幸事实 ####
补充一下，我认为高阶组件的名称不正确，尽管现在尝试修改已经有点晚了。高阶函数是至少执行一下操作之一的函数：
1. 将n个函数作为参数。
2. 返回一个函数作为结果。

Indeed Higher Order Components do something similar to this, namely take a Component as and argument and return a Component but I think it is easier to think of a Higher Order Component as a factory function, it is a function that dynamically creates a component to allow for runtime composition of your components. However, they are **unaware** of your React state and props at composition time!
事实上，高阶组件做了类似的事情，也就是拿一个组件作为参数并返回一个组件，但是我更容易将高阶组件看作是工厂函数，它是一个能动态创建的组件将允许的功能用于组件的运行组合。然而，在运行组合的时候他们是**不知道**你的 React 的 state 和 props 。

函数式子组件允许你的组件们在作出组合决策时可以访问 state，props 和上下文。当函数作为子组件：

1. 将一个函数作为参数。
2. 渲染此函数的结果。

我不禁觉得它们应该得到“高阶组件”的标题，因为它像高阶函数只使用组件组合技术而不是功能组合。好吧，现在我们还是继续用“函数式子组件”这个粗暴的名字。
### 例子 ###

1. [Pinch to Zoom - Function as Child Component](https://gist.github.com/iammerrick/c4bbac856222d65d3a11dad1c42bdcca)
2. [react-motion](https://github.com/chenglou/react-motion) 这个项目在讲过很长一段时间的高阶组件转换后才引进了这个概念。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
