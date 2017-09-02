
  > * 原文地址：[How do you separate components?](https://reactarmory.com/answers/how-should-i-separate-components)
  > * 原文作者：[James K Nelson](https://twitter.com/james_k_nelson)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-should-i-separate-components.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-should-i-separate-components.md)
  > * 译者：[undead25](https://github.com/undead25)
  > * 校对者：[薛定谔的猫](https://github.com/Aladdin-ADD)、[Germxu](https://github.com/germxu)

  # 你是如何拆分组件的？

  React 组件会随着时间的推移而逐步增长。幸好我意识到了这一点，不然我的一些应用程序的组件将变得非常可怕。

但这实际上是一个问题吗？虽然创建许多只使用一次的小组件似乎有点奇怪……

在一个大型的 React 应用程序中，拥有大量的组件本身没有什么错。实际上，对于**状态**组件，我们当然是希望它们越小越好。

## 臃肿组件的出现

关于状态它通常不会很好地分解。如果有多个动作作用于同一状态，那么它们都需要放在同一个组件中。状态可以被改变的方式越多，组件就越大。另外，如果一个组件有影响多个[状态类型](http://jamesknelson.com/5-types-react-application-state/)的动作，那么它将变得非常庞大，这是不可避免的。

**但即使大型组件不可避免，它们使用起来仍然是非常糟糕的**。这就是为什么你会尽可能地拆分出更小的组件，遵循[关注点分离](https://en.wikipedia.org/wiki/Separation_of_concerns)的原则。

当然，说起来容易做起来难。

寻找关注点分离的方法是一门技术，更是一门艺术。但你可以遵循以下几种常见模式……

## 4 种类型的组件

根据我的经验，有四种类型的组件可以从较大的组件中拆分出来。

### 视图组件

有关视图组件（有些人称为展示组件）的更多信息，请参阅 Dan Abramov 的名著 —— [展示组件和容器组件](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)。

视图组件是最简单的组件类型。它们所做的就是**显示信息，并通过回调发送用户输入**。它们：

- 将属性分发给子元素。
- 拥有将数据从子元素转发到父组件的回调。
- 通常是函数组件，但如果为了性能，它们需要绑定回调，则可能是类。
- 一般不使用生命周期方法，性能优化除外。
- **不**直接存储状态，除了以 UI 为中心的状态，例如动画状态。
- **不**使用 refs 或直接与 DOM 进行交互（因为 DOM 的改变意味着状态的改变）。
- **不**修改环境。它们不应该直接将动作发送给 redux 的 store 或者调用 API 等。
- **不**使用 React 上下文。

你可以从较大的组件中拆分出展示组件的一些迹象：

- 有 DOM 标记或者样式。
- 有像列表项这样重复的部分。
- 有“看起来”像一个盒子或者区域的内容。
- JSX 的一部分仅依赖于单个对象作为输入数据。
- 有一个具有不同区域的大型展示组件。

可以从较大的组件中拆分出展示组件的一些示例：

- 为多个子元素执行布局的组件。
- 卡片和列表项可以从列表中拆分出来。
- 字段可以从表单中拆分出来（将所有的更新合并到一个 `onChange` 回调中）。
- 标记可以从控件中拆分出来。

### 控制组件

控制组件指的是**存储与部分输入相关的状态**的组件，即跟踪用户已发起动作的状态，而这些状态还未通过 `onChange` 回调产生有效值。它们与展示组件相似，但是：

- 可以存储状态（当与部分输入相关时）。
- 可以使用 refs 和与 DOM 进行交互。
- 可以使用生命周期方法。
- 通常没有任何样式，也没有 DOM 标记。

你可以从较大的组件中拆分出控制组件的一些迹象：

- 将部分输入存储在状态中。
- 通过 refs 与 DOM 进行交互。
- 某些部分看起来像原生控件 —— 按钮，表单域等。

控制组件的一些示例：

- 日期选择器
- 输入提示
- 开关

你经常会发现你的很多控件具有相同的行为，但有不同的展现形式。在这种情况下，通过将展现形式拆分成视图组件，并作为 `theme` 或 `view` 属性传入是有意义的。

你可以在 [react-dnd](https://github.com/react-dnd/react-dnd) 库中查看连接器函数的实际示例。

当从控件中拆分出展示组件时，你可能会发现通过 `props` 将单独的 `ref` 函数和回调传递给展示组件感觉有点不对。在这种情况下，它可能有助于传递**连接器函数**，这个函数将 refs 和回调克隆到传入的元素中。例如：

```jsx
class MyControl extends React.Component {
  // 连接器函数使用 React.cloneElement 将事件处理程序
  // 和 refs 添加到由展示组件创建的元素中。
  connectControl = (element) => {
    return React.cloneElement(element, {
      ref: this.receiveRef,
      onClick: this.handleClick,
    })
  }

  render() {
    // 你可以通过属性将展示组件传递给控件，
    // 从而允许控件以任意标记和样式来作为主题。
    return React.createElement(this.props.view, {
      connectControl: this.connectControl,
    })
  }

  handleClick = (e) => { /* ... */ }
  receiveRef = (node) => { /* ... */ }

  // ...
}

// 展示组件可以在 `connectControl` 中包裹一个元素，
// 以添加适当的回调和 `ref` 函数。
function ControlView({ connectControl }) {
  return connectControl(
    <div className='some-class'>
      control content goes here
    </div>
  )
}
```

你会发现控制组件通常会非常大。它们必须处理和状态密不可分的 DOM，这就使得控制组件的拆分特别有用；通过将 DOM 交互限制为控制组件，你可以将任何与 DOM 相关的杂项放在一个地方。

### 控制器

一旦你将展示和控制代码拆分到独立的组件中后，大部分剩余的代码将是业务逻辑。如果有一件事我想你在阅读本文之后记住，那就是**业务逻辑不需要放在 React 组件**中。将业务逻辑用普通 JavaScript 函数和类来实现通常是有意义的。由于没有一个更好的名字，我将它称之为**控制器**。

所以只有三种类型的 **React** 组件。但仍然有四种类型的组件，因为不是每个组件都是一个 React 组件。

并不是每辆车都是丰田（但至少在东京大部分都是）。

控制器通常遵循类似的模式。它们：

- 存储某个状态。
- 有改变那个状态的动作，并可能引起副作用。
- 可能有一些订阅状态变更的方法，而这些变更不是由动作直接造成的。
- 可以接受类似属性的配置，或者订阅某个全局控制器的状态。
- **不**依赖于任何 React API。
- **不**与 DOM 进行交互，也没有任何样式。

你可以从你的组件中拆分出控制器的一些迹象：

- 组件有很多与部分输入无关的状态。
- 状态用于存储从服务器接收到的信息。
- 引用全局状态，如拖放或导航的状态。

一些控制器的示例：

- 一个 Redux 或者 Flux 的 store。
- 一个带有 MobX 可观察的 JavaScript 类。
- 一个包含方法和实例变量的普通 JavaScript 类。
- 一个事件发射器。

一些控制器是全局的；它们完全独立于你的 React 应用程序。Redux 的 stores 就是一个是全局控制器很好的例子。但**并不是所有的控制器都需要是全局的**，也并不是所有的状态都需要放在单独的控制器或者 store 中。

通过将表单和列表的控制器代码拆分为单独的类，你可以根据需要在容器组件中实例化这些类。

### 容器组件

容器组件是将控制器连接到展示组件和控制组件的粘合剂。它们比其他类型的组件更具有灵活性。但仍然倾向于遵循一些模式，它们：

- 在组件状态中存储控制器实例。
- 通过展示组件和控制组件来渲染状态。
- 使用生命周期方法来订阅控制器状态的更新。
- **不**使用 DOM 标记或样式（可能出现的例外是一些无样式的 div）。
- 通常由像 Redux 的 `connect` 这样的高阶函数生成。 
- 可以通过上下文访问全局控制器（例如 Redux 的 store）。

虽然有时候你可以从其他容器中拆分出容器组件，但这很少见。相反，最好将精力集中在拆分控制器、展示组件和控制组件上，并将剩下的所有都变成你的容器组件。

一些容器组件的示例：

- 一个 `App` 组件
- 由 Redux 的 `connect` 返回的组件。
- 由 MobX 的 `observer` 返回的组件。
- react-router 的 `<Link>` 组件（因为它使用上下文并影响环境）。

## 组件文件

你怎么称呼一个不是视图、控制、控制器或容器的组件？你只是把它叫做组件！很简单，不是吗？

一旦你拆分出一个组件，问题就变成了**我把它放在哪里**？老实说，答案很大程度上取决于个人喜好，但有一条规则我认为很重要：

**如果拆分出的组件只在一个父级中使用，那么它将与父级在同一个文件中**。

这是为了尽可能容易地拆分组件。创建文件比较麻烦，并且会打断你的思路。如果你试着将每个组件放在不同的文件中，你很快就会问自己“我真的需要一个新组件吗？”因此，请将相关的组件放在同一个文件中。

当然，一旦你找到了重用该组件的地方，你可能希望将它移动到单独的文件中。这就使得把它放到哪个文件中去成为一个甜蜜的烦恼了。

## 性能怎么样？

将一个庞大的组件拆分成多个控制器、展示组件和控制组件，增加了需要运行的代码总量。这可能会减慢一点点，但不会减慢很多。

##### 故事

我遇到过唯一一次由于使用太多组件而引起性能问题 —— 我在**每一帧**上渲染 5000 个网格单元格，每个单元格都有多个嵌套组件。

关于 React 性能的是，即使你的应用程序有明显的延迟，问题肯定**不是**出于组件太多。

**所以你想使用多少组件都可以**。

## 如果没有拆分……

我在本文中提到了很多规则，所以你可能会惊讶地听到我其实并不喜欢严格的规则。它们通常是错的，至少在某些情况下是这样。所以必须要明确的是:

**『可以』拆分并不意味着『必须』拆分**。

假设你的目标是让你的代码更易于理解和维护，这仍然留下了一个问题：怎样才是易于理解？怎样才是易于维护？而答案往往取决于谁在问，这就是为什么重构是技术，更是艺术。

有一个具体的例子，考虑下这个组件的设计：

```html
<!DOCTYPE html>
<html>
  <head>
    <title>I'm in a React app!</title>
  </head>
  <body>
    <div id="app"></div>

    <script src="https://unpkg.com/react@15.6.1/dist/react.js"></script>
    <script src="https://unpkg.com/react-dom@15.6.1/dist/react-dom.js"></script>
    <script>
      // 这里写 JavaScript
    </script>
  </body>
</html>
```

```jsx
class List extends React.Component {
  renderItem(item, i) {
    return (
      <li key={item.id}>
        {item.name}
      </li>
    )
  }

  render() {
    return (
      <ul>
        {this.props.items.map(this.renderItem)}
      </ul>
    )
  }
}

ReactDOM.render(
  <List items={[
    { id: 'a', name: 'Item 1' },
    { id: 'b', name: 'Item 2' }
  ]} />,
  document.getElementById('app')
)
```

尽管将 `renderItem` 拆分成一个单独的组件是完全可能的，但这样做实际上会有什么好处呢？可能没有。实际上，在具有多个不同组件的文件中，使用 `renderItem` 方法可能会**更容易**理解。

请记住：四种类型的组件是当你觉得它们有意义的时候，你可以使用的一种模式。它们并不是硬性规定。如果你不确定某些内容是否需要拆分，那就不要拆分，因为即使某些组件比其他组件更臃肿，世界末日也不会到来。


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  