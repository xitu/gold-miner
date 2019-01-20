> * 原文地址：[Building HOCs with Recompose](https://medium.com/front-end-developers/building-hocs-with-recompose-7debb951d101)
> * 原文作者：[Abhi Aiyer](https://medium.com/@abhiaiyer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-hocs-with-recompose.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-hocs-with-recompose.md)
> * 译者：[SHERlocked93](https://github.com/SHERlocked93)
> * 校对者：

# 使用 Recompose 来构建高阶组件

在 [Workpop](http://www.workpop.com/careers) 公司，我们不断使用不同的组件设计模式来迭代我们的产品，以适应瞬息万变的 React 生态系统。早些时候，我们从试用高阶组件设计模式（HOC）中尝到一点甜头。

#### 什么是高阶组件？

**高阶组件只是一个函数，只不过它返回的是用来渲染 React 组件的函数。**

这里有个例子：

```jsx
import { Component } from 'React';

export function enhancer() {
 return (BaseComponent) => {
   return class extends Component {
     constructor() {
        this.state = { visible: false }; 
     }
     componentDidMount() {
        this.setState({ visible: true });
     }
     render() {
       return <BaseComponent {...this.props} {...this.state} />;
     }
   }  
 };
}
```

正如你看到的这个例子，我们只有一个给你的组件提供功能的函数。在本例中，我们添加了一些 `state` 来控制可见性。

我们可以看看它的使用方式：

```jsx
// 展示型组件

function Sample({ visible }) {
 return visible ? <div> I am Visible </div> : <div> I am not Visible </div>
}

export default enhance()(Sample);
```

#### 高阶组件模式的意义何在？

当构建组件时，我强烈建议将展示型组件和增强型组件(高阶组件)进行分离。我喜欢使用术语**增强型组件**来描述高阶组件，是因为这个词从字面上可以让我们更好的理解它的用途。

增强型组件的用途：

*   可以给其他的展示型组件进行相同的代码复用；
*   简化可读性较差的臃肿的组件；
*   可以自定义组件的渲染；
*   可以给任何组件增加 `state`，这意味着你不再需要依赖 Redux 或者其他类似的库（如果你正这样做）；
*   操作你传给展示型组件的 `props` （map，reduce 等任何你喜欢的方法）。

#### 为什么不使用类来实现它呢？

如果你想用 ES6 的类语法来实现也可以。我个人倾向于使用函数式无状态的组件来构建应用的 UI。

```jsx
function HellWorld({ message = 'Hello World' }) {
  return <h1>{message}</h1>;
}
```

使用函数式组件的优点：

*   模块化代码 - 可以在整个项目范围内复用你的代码段；
*   只依赖于 props - 默认没有 state；
*   更便于单元测试 - 对 enzyme/jest 更友好的测试接口；
*   更便于 Mock 数据 - 可以对不同场景方便的进行数据 Mock。

#### 我们走过的旅程

然后我们开始在生产环境中深度使用高阶组件了，并在使用过程中遇到了几个问题。比如为简单的场景不断地编写简单地高阶组件就很无聊，没有将多个高阶组件进行合成的方法，也无法避免开发出冗余的高阶组件（这个最麻烦，但我清楚这有时确实会发生）。人们逐渐陷入高阶组件的语法和观念中寸步难行，这种模式似乎也已渐渐失去了价值。

我们真正需要的解决方案是这样的：

*   强制模式
*   易于组合
*   易于使用

这就是我们为何引入 [**Recompose**](https://github.com/acdlite/recompose)。

#### 开始使用 Recompose

> Recompose 是一个为函数式组件和高阶组件开发的 React 工具库。可以把它当做 React 的 Lodash.

这正是我们所需要的。我们的同事们都喜欢用 Lodash，现在跟他们说开发高阶组件将和使用 Lodash 有相似的开发体验。恩，有戏。

我们来写个简单地 DEMO 看看：

假如我们有这样一个组件约束：

*   需要 `state` 来控制可见性；
*   需要将改变可见性的函数放到我们的组件中；
*   需要在组件中添加一些 props。

#### 步骤1 - 编写展示型组件

```jsx
export default function Presentation({ title, message, toggleVisibility, isVisible }) {
 return  (
   <div>
     <h1>{title}</h1>
     {isVisible ? <p>I'm visible</p> : <p> Not Visible </p>}
     <p>{message}</p>
     <button onClick={toggleVisibility}> Click me! </button>
   </div> 
 );
}
```

现在我们需要去提取这个组件的增强型组件了。

#### 步骤2 - 编写容器

我通常会把一些 Recompose 的增强型组件合成在一起，所以这个步骤是建立你的 compose：

```jsx
import { compose } from 'recompose';

export default compose(
  /*********************************** 
   *
   * 我们将把增强型组件放在这里
   *
   ***********************************/
)(Presentation);
```

什么是 Recompose 中的 compose？它相当于 Lodash 中的 flowRight 函数。

我们可以使用 compose 来将多个高阶组件转化为一个高阶组件。

#### 步骤3 - 正确

好了，我们现在需要从这个组件中正确获取 `state`。

在 Recompose 中，我们可以使用 `withState` 增强型组件来设置组件内的 `state`，并且使用 `withHandlers` 增强型组件来设置组件的事件处理函数。

```jsx
import { compose, withState, withHandlers } from 'recompose';

export default compose(
  withState('isVisible', 'toggleVis', false),  
  withHandlers({
    toggleVisibility: ({ toggleVis, isVisible }) => {
     return (event) => {
       return toggleVis(!isVisible);
     };
    },
  })
)(Presentation);
```

这里我们设置了状态属性 `isVisible`，一个控制可见性的方法 `toggleVis`，和一个初始值 false。

`withHandlers` 创建了一个高阶组件，它接受一系列 `props` 并返回一个处理函数，在这个例子中是处理可见性 `state` 的函数。`toggleVisibility` 这个函数将作为 `Presentation` 组件的一个 `prop`。

#### 步骤4 - 添加 props

最后的要做的是给我们的组件附加一些 `props`。

```jsx
import { compose, withState, withHandlers, withProps } from 'recompose';

export default compose(
  withState('isVisible', 'toggleVis', false),  
  withHandlers({
    toggleVisibility: ({ toggleVis, isVisible }) => {
     return (event) => {
       return toggleVis(!isVisible);
     };
    },
  }),
  withProps(({ isVisible }) => {
    return {
      title: isVisible ? 'This is the visible title' : 'This is the default title',
      message: isVisible ? 'Hello I am Visible' : 'I am not visible yet, click the button!',
    };
  })
)(Presentation);
```

这个模式最酷的地方在于我们现在就可以操作组件的 `props` 了，在这里，通过操作控制可见性的 `state`，我们可以展示不同的 title 和 message。依我看，这个增强型组件**远比**原来全写在 render 函数中的方式简洁。

#### 总结

现在你看到了，我们有了一个可复用的高阶组件，它可以被用在其他的展示性组件上。同时可以看到我们移除了原来高阶组件写法中的很多样板语法。

在 Recompose 中还有很多有用的 API，[了解更多](https://github.com/acdlite/recompose/blob/master/docs/API.md)！它真的非常像 `Lodash`，现在就打开文档开始写代码吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
