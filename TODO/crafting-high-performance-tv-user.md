> * 原文链接: [Crafting a high-performance TV user interface using React](http://techblog.netflix.com/2017/01/crafting-high-performance-tv-user.html)
* 原文作者 : [Ian McKay](https://twitter.com/madcapnmckay)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Professor-Z](https://github.com/Professor-Z)
* 校对者 : 

# 使用 React 构建高性能的电视用户界面 

在我们努力为我们的会员找到最好的体验的过程中，Netflix的电视界面不断发展。例如，在进行[A/B testing](http://techblog.netflix.com/2016/04/its-all-about-testing-netflix.html) 、眼球追踪研究和用户反馈研究之后，我们最近开展了[video previews](https://www.fastcompany.com/3066166/innovation-agents/netflix-launches-video-previews-how-the-company-landed-on-its-biggest-rede) 来帮助会员们更好地决定看什么。我们 [之前写过一篇文章](http://techblog.netflix.com/2013/11/building-new-netflix-experience-for-tv.html)讲到了我们的电视应用包含了一个预装在设备上面的 SDK，一个可以随时被更新的 JavaScript 应用，和一个被称为 Gibbon 的渲染层。在这篇文章中我们会着重讲解在我们优化 JavaScript 应用性能的过程中使用到的一些方法。

## React-Gibbon

在2015年，我们开始对我们的电视用户界面架构进行批量重写和现代化改造。我们决定使用 React ，因为它的单项数据流和声明式的用户界面开发方法使得我们更容易地理清楚我们的应用。显然，我们需要我们自己特色的 React ，因为在那时候它还只针对 DOM，我们当时很快地创造了一个针对 Gibbon 的原型。这个原型最终进化成为了 React-Gibbon ，我们也开始着手建造我们的 基于 React 的用户界面。

React-Gibbon 的 API 对于任何接触过 React-DOM 的人来说都会非常熟悉。最大的不同是，我们只有一个单一的支持内联样式的叫做 ```widget```的绘图原语，而没有 divs, spans, inputs 等。 
```
React.createClass({
    render() {
        return <Widget style={{ text: 'Hello World', textSize: 20 }} />;
    }
});
```

## 性能是一个关键的挑战

我们的应用运行在数百种设备上，从最大的游戏机如 PS4 Pro 到内存和处理器性能都有限的消费电子产品。我们要面对的低端电子设备常常有着低于 1 GHz 的单核 CPU，低内存和有限的图像处理加速能力。让事情更有挑战性的是，我们的 JavaScript 运行环境是没有 JIT 的老版本的 JavaScriptCore。这些限制让实现超高响应的 60 fps 的体验变得尤其棘手，使得React-Gibbon 和 React-DOM 有了很多差异。

### 测量，测量，测量

在处理性能优化的时候，先明确你用来测量你的工作是否成功的指标是很重要的。我们使用如下的指标来测量综合的应用性能。

- 按键反应时间 - 响应一个按键操作并渲染相关修改所用的时间。
- 启动时间 - 启动这个应用所用的时间。
- 每秒帧数 - 反映在我们动画的连续性和顺滑度。
- 内存使用

下文概述的策略主要的目标都是提高按键反应速度。它们都在我们的设备上被识别、测试、测量过，但在其它的环境中不一定适用。就像所有的『最佳实践』的建议一样，保持怀疑并确认他们在你的环境中和你的用例中可用是非常重要的。我们开始使用性能分析工具来识别正在执行的代码路径以及它们在总渲染时间中的份额; 这让我们观察到了一些有趣的现象。

### 观察结果：React.createElement 有成本

当 Babel 转义 JSX 时，把 JSX 转换成了一些 React.createElement 函数的调用，这些函数执行后产生下一步要渲染的组件。如果我们能预测 createElement 函数会产生什么，我们就能编译时用期望的结果将函数内联调用而不是在运行时执行函数。
```
// JSX
render() {
    return <MyComponent key='mykey' prop1='foo' prop2='bar' />;
}

// 转义后
render() {
    return React.createElement(MyComponent, { key: 'mykey', prop1: 'foo', prop2: 'bar' });
}

// 函数内联调用
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

如你所见，我们完全移除了 createElement 函数调用的成本，一个软件优化上『我们能不能不这样』思维的胜利。
我们想知道有没有可能把这个技术在我们的整个应用中使用，从而完全避免调用 createElement 函数。结果我们发现如果在元素中使用了 ref ，createElement 就需要被调用，以便在运行时连接所有者。如果你使用了 [扩展属性](https://facebook.github.io/react/docs/jsx-in-depth.html#spread-attributes) 而其中包含 ref 值，也是同样的道理。（之后我们会重新谈到这一点）

我们使用了一个定制化的 Babel 插件来进行元素的内联，不过现在你有一个 [官方插件](https://babeljs.io/docs/plugins/transform-react-inline-elements/) 可以用来做这件事。这个官方插件会调用一个之后会消失的辅助函数而不是使用对象字面量，这要归功于 V8 的魔法 [function inlining](https://ariya.io/2013/04/automatic-inlining-in-javascript-engines)。然而，在使用了我们的插件之后，仍然有不少的组件没有被内联，尤其是在我们应用内占有很大比例的高阶组件。

### 问题： 高阶组件不能使用内联

我们很喜欢替代 mixin 了的 [高阶组件](https://facebook.github.io/react/docs/higher-order-components.html)。它既能在行为上分层，又能保持关注的分离。我们希望在我们的高阶组件中利用内联的好处，但是我们碰到了一个难题：高阶组件通常表现为他们的属性的传递者。这就自然的引入了属性扩展符，从而阻止 Babel 插件进行内联操作。

当我们开始重写我们的应用时，我们决定渲染层的所有交互需要经过声明式 API 。例如，我们不会这样做：
```
componentDidMount() {
    this.refs.someWidget.focus()
}
```

相反地，为了把应用的焦点移动到一个特殊的 Widget，我们实现了一个声明式的聚焦 API，它使得我们可以描述哪个组件应该在渲染的时候被聚焦，像下面的代码这样：
```
render() {
    return <Widget focused={true} />;
}
```

这种写法有一个很好的副作用，让我们在整个应用中都避免了使用 ref 。所以，不管代码中是否用到了扩展运算符，我们都可以使用内联技术。
```
// 内联调用之前
render() {
    return <MyComponent {...this.props} />;
}

// 内联调用之后
render() {
    return {
        type: MyComponent,
        props: this.props
    };
}
```

这极大地减少了之前我们不得不做的函数调用和属性合并的操作的数量，但它并没有完全的消除他们的影响。

### 问题：属性拦截仍然需要合并操作

在我们成功地把我们的组件内联化之后，我们的应用仍然在高阶组件中耗费大量的时间进行属性合并。这并不奇怪，因为高阶组件经常拦截新来的属性，在其中某些属性值中做一些改变或者添加自己的属性进去，然后再转发给内部的封装组件。

我们做了一个分析，在我们的一个设备上研究高阶组件的层叠数随着属性数量和组件深度的变化，结果提供了一些有用的信息。

![Screenshot 2017-01-11 12.31.30.png](https://lh4.googleusercontent.com/9S0doBpyo_e_ON1Odxef6Ak3y74xqxIcFL5EjsrFfBUy81gKwu1svsNVxe-nbzdEmymB4kPhPKJEJI5La8iIzNc5opZToVe4GB0g6AuoZU60tGY33-_zvpyuHTJRUQRw50BvoUCx)

这些信息显示，在既定的组件深度下，层层传递的组件属性的数量和渲染时间之间有着大致线性的关系。

**属性太多会让你的应用死掉**

基于我们的研究，我们意识到，可以通过限制层层传递的属性数量来对我们的应用性能进行大幅度的提升。我们发现很多组属性集合经常是相关的并且同时发生改变。在这种情况下，把这些相关属性在一个单一命名空间的属性里面集合起来是很有意义的。如果一个命名空间的属性集合可以被建模为一个不可变值，后续的对 shouldComponentUpdate 函数的调用就可以被优化，通过只检测引用指向的是否是同一个值而不是对对象进行深层比较。这算是一些好的成果，但最终我们发现我们已经尽可能的减少了属性数量。现在是时候采取更极端的措施了。

**合并属性，无需遍历所有属性值**

注意，此处可能有坑！这种做法一般不推荐，而且很有可能以奇怪的意外的方式打乱很多事情。
在减少了应用中传递的属性数量之后，我们开始实验其它方法希望可以减少在高阶组件之间进行属性合并所耗费的时间。我们意识到可以通过使用原型链来完成同样的事情，从而避免进行属性遍历。
```
// proto merge 之前
render() {
    const newProps = Object.assign({}, this.props, { prop1: 'foo' })
    return <MyComponent {...newProps} />;
}

// proto merge 之后
render() {
    const newProps = { prop1: 'foo' };
    newProps.__proto__ = this.props;
    return {
        type: MyComponent,
        props: newProps
    };
}
```

在上面这个例子中，我们成功地把一个有100个属性传递100层的情况的渲染时间从 500ms 左右降到了 60ms 。注意，使用这个方法会引入一些有趣的 bug ，比如说， this.props 是一个 [frozen object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze) 的情况。当这种情况发生时，原型链方法仅在创建 newProps 对象后分配 __proto__ 时有效。不用说，如果你不是 newProps 的所有者，那么分配原型是不明智的。

### 问题：比对样式很慢
一旦 React 知道了它需要渲染的元素，它一定会把这些元素和之前的元素进行比对，以决定必须应用在真实 DOM 元素上面的最小的改变。通过分析我们发现这个过程是成本很高的，尤其是在 mount 的过程中 —— 部分原因是需要遍历大量的样式属性值。

**基于是否可能改变来区分样式属性**

我们发现通常我们设置的许多属性从来没被实际改变过。举个例子，我们有一个 Widget 被用来展示一些动态文字，它有 text, textSize, textWeight 和 textColor 这些属性。text 这个属性在这个 Widget 的生命周期中会改变，但其它的属性我们希望保持不变。比对这 4 个样式属性会在每次渲染都有成本，我们可以通过把可能改变的属性和不会改变的属性分开来消除这个成本。
```
const memoizedStylesObject = { textSize: 20, textWeight: ‘bold’, textColor: ‘blue’ };
```

```
<Widget staticStyle={memoizedStylesObject} style={{ text: this.props.text }} />
```

如果我们谨慎地记忆了这个 ```memoizedStylesObject``` 对象，React-Gibbon 就可以检查引用相等，而且只有在引用不相等的时候改变它的值。这对挂载组件的时间没有影响，但是对每个后续的重新渲染的成本有影响。

**为什么不避免所有的遍历？**

我们来更深入的讨论一下这个想法，如果我们知道在一个特定的组件上面有哪些样式属性被设置了，我们可以写一个不用遍历任何属性键的函数来做之前相同的工作。我们写了一个定制化的 Babel 插件，它可以在组件的渲染方法上面做一些静态分析。它会辨别哪一些样式将会被使用，然后构建一个定制化的 『比对差异——应用更改』的函数，并把这个函数添加到组件的属性里面。 
```
//这个函数是静态分析插件产生的
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

在内部 React-Gibbon 会查找这个特殊的 __update__ 属性，跳过常规的遍历以前的样式属性和下一个样式属性的过程，取而代之的是，如果 __update__ 监测的样式属性有变化，就直接应用这些属性变化到组件上去。这对我们的（应用）渲染时间有巨大的影响，当然这以增加可分发大小为代价。

## 性能是个特点

我们的应用运行环境是独一无二的，但是我们用来寻求性能提升机会的技术却是通用的。我们在真实的设备上面测量，测试和验证了我们所有的改进。这些调查研究让我们发现了一个共同的主题：遍历所有属性代价是昂贵的。因此，我们在我们的应用中辨别属性合并过程，然后决定它们是否能被优化。下面列出了我们在提高性能方面所做的一些其他工作。

- 自定义复合组件 - 为我们的平台进行了超优化
- 预加载场景以提高感知的过渡体验
- 组件放入组件池
- 对昂贵计算进行记忆化处理