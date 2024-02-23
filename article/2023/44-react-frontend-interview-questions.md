> * 原文地址：[44 React Frontend Interview Questions](https://dev.to/m_midas/44-react-frontend-interview-questions-2o63)
> * 原文作者：[TYan Levin](https://dev.to/m_midas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2023/44-react-frontend-interview-questions.md](https://github.com/xitu/gold-miner/blob/master/article/2023/44-react-frontend-interview-questions.md)
> * 译者：
> * 校对者：

## 介绍

在面试 React 前端开发之前，为技术问题做好充分准备是至关重要的。React 已经成为最流行的用于构建用户界面的 JavaScript 库之一，并且雇主比较热衷于评估应聘者对 React 的核心概念、最佳实践和相关技术的理解程度。在这篇文章中，我们将探讨一下React 前端开发面试中涉及到的一系列问题。通过了解这些问题的答案，你可以提高你面试成功的次数，并展现你在 React 开发中的熟练程度。因此，让我们深入探讨一下你在 React 前端开发面试中应该准备好的题目。

![](https://i.giphy.com/media/AYECTMLNS4o67dCoeY/giphy.gif)

### 1. 你知道那些 React 钩子?

-   `useState`: 管理函数组件中的状态。
-   `useEffect`: 在函数组件中执行副作用，例如获取数据或订阅事件。
-   `useContext`: 访问函数组件中的 React 上下文的值。
-   `useRef`: 创建渲染过程持久存在的元素或者值的可变的引用。
-   `useCallback`: 缓存函数以防止不必要的重新渲染。
-   `useMemo`: 缓存值，通过缓存昂贵的计算结果来提高性能。
-   `useReducer`: 使用 reducer 函数管理状态，类似于 Redux 的工作方式。
-   `useLayoutEffect`: 类似于 useEffect，但是在所有 DOM 更新之后会同步执行副作用函数。

这些钩子为 React 函数组件提供了强有力的工具，用来管理状态、处理副作用和复用逻辑。

[了解更多](https://react.dev/reference/react)

### 2. 什么是虚拟 DOM？

虚拟 DOM 是 React 中的一个概念，它存储在内存中，并且可以更加轻量地表达真实的 DOM 结构（文档对象模型）。它是一种用于优化 Web 应用程序性能的编程技术。

对 React 组件的数据或状态进行更改之后，React 将更新虚拟 DOM，而不是直接操作真实的 DOM。然后，虚拟 DOM 会对比组件的旧状态和新状态之间的差异，这就是我们熟知的`diff`过程。

一旦对比出差异之后，React 就会高效地更新 DOM 实际发生改变的部分。这种方法将 DOM 操作的次数降到了最少，提高了应用程序的整体性能。

通过使用虚拟 DOM，React 提供了一种创建动态和交互式用户界面的方法，同时确保了最佳的效率和渲染速度。

### 3. 怎么渲染数组类型的元素？

要渲染一个数组类型的元素，你可以使用 `map()` 方法遍历数组并返回一个新数组，在这个新数组中每一项都是一个 React 元素。

```tsx
const languages = [
  "JavaScript",
  "TypeScript",
  "Python",
];

function App() {
  return (
    <div>
      <ul>{languages.map((language) => <li>{language}</li>)}</ul>
    </div>
  );
}
```

[了解更多](https://react.dev/learn/rendering-lists)

### 4. 受控组件与非受控组件有什么区别？

受控组件和非受控组件之间的区别在于它们如何管理和更新状态。

受控组件的状态由 React 控制。组件接收最新的状态值并通过 props 进行更新。当值更改时，它还会触发一个回调函数。这意味着组件不存储它自己的内部状态，而是交给父组件管理状态，然后父组件将最新的状态值其传递给受控组件。

```tsx
import { useState } from 'react'; 

function App() { 
  const [value, setValue] = useState(''); 

  return ( 
    <div> 
      <h3>Controlled Component</h3> 
      <input name="name" value={name} onChange={(e) => setValue(e.target.value)} />
      <button onClick={() => console.log(value)}>Get Value</button> 
    </div> 
  ); 
} 
```

另一方面，非受控组件通过引用或其他方法在内部管理自己的状态。它们独立存储和更新状态，不依赖于 props 或回调。父组件对非受控组件的状态的控制较少。

```tsx
import { useRef } from 'react'; 

function App() { 
  const inputRef = useRef(null); 

  return ( 
    <div className="App"> 
      <h3>Uncontrolled Component</h3> 
      <input type="text" name="name" ref={inputRef} /> 
      <button onClick={() => console.log(inputRef.current.value)}>Get Value</button> 
    </div> 
  ); 
} 

```

[了解更多](https://react.dev/learn/sharing-state-between-components#controlled-and-uncontrolled-components)

### 5. 类组件和函数组件的区别？

类组件和函数组件的主要区别在于 **声明它们的方式以及它们的语法**。

类组件由 ES6 中的类构造出来，并继承了`React.Component` 类。他们使用`render`方法 来返回定义了组件输出的 JSX (JavaScript XML)。类组件可以通过`this.state`和`this.setState()`访问组件生命周期方法和状态管理。

```tsx
class App extends React.Component {
  state = {
    value: 0,
  };

  handleAgeChange = () => {
    this.setState({
      value: this.state.value + 1 
    });
  };

  render() {
    return (
      <>
        <p>Value is {this.state.value}</p>
        <button onClick={this.handleAgeChange}>
        Increment value
        </button>
      </>
    );
  }
}
```

与类组件不同的是，函数组件由简单的 JavaScript 函数定义。它们以参数形式接收 props，并直接返回 JSX。函数式组件不能访问生命周期方法或者状态。但是，随着 React 16.8 中引入的 React Hooks，函数式组件现在可以管理状态，并使用诸如 context 和 effects 等特性

```tsx
import { useState } from 'react';

const App = () => {
  const [value, setValue] = useState(0);

  const handleAgeChange = () => {
    setValue(value + 1);
  };

  return (
      <>
        <p>Value is {value}</p>
        <button onClick={handleAgeChange}>
        Increment value
        </button>
      </>
  );
}
```

总体上来说，函数式组件比类组件更简单，更容易阅读和测试。除非有特定需要，否则建议尽可能使用函数式组件。

### 6. 组件有哪些生命周期？

生命周期方法是一种连接到组件生命周期的不同阶段的方法，允许你在特定的时间执行特定的代码。

下面是主要的生命周期方法列表:

1.  `constructor`: 这是在创建组件时调用的第一个方法。它用于初始化状态和绑定事件处理程序。在函数组件中，可以使用`useState`钩子来实现类似的目的。
    
2.  `render`: 这个方法负责渲染 JSX 标记，并返回要显示在屏幕上的内容。
    
3.  `componentDidMount`: 在 DOM 中渲染组件之后立即调用这个方法。它通常用于初始化任务，例如 API 调用或设置事件侦听器。
    
4.  `componentDidUpdate`: 当组件的 props 或 state 发生变化时调用这个方法。它允许你执行副作用、基于数据改变更新组件或触发其他 API 调用。
    
5.  `componentWillUnmount`: 从 DOM 中卸载组件之前调用这个方法。它用于清理在`componentDidMount`中设置的所有任务，例如删除事件侦听器或取消计时器。
    

一些生命周期方法，比如 `componentWillMount`、`componentWillReceiveProps` 和 `componentWillUpdate`, 已经被弃用或替换为替代方法或钩子。

至于`this`，它指的是类组件的当前实例。它允许你访问组件中的属性和方法。在函数组件中，不使用`this`，因为函数不绑定到特定的实例。

### 7. 如何使用 useState?

`useState` 返回了一个状态和一个更新状态的函数。  

```ts
const [value, setValue] = useState('Some state');
```

在首次渲染时，组件将以 useState 第一个参数的值作为 state 返回。 `setState` 函数用于更新状态。 它接受一个新的状态值作为参数 并且 **会触发一个队列去重新渲染组件**。`setState` 函数还可以接受一个回调函数作为参数，这个回调函数以最新的 state 为参数。

[了解更多](https://react.dev/reference/react/useState)

### 8. 如何使用 useEffect？

`useEffect` 钩子允许你在函数组件中执行副作用。 
在 React 渲染阶段，在函数组件的函数体内不允许执行 Mutations、 subscriptions、 timers、 logging 或者其他副作用。这可能导致用户界面产生异常以及状态与渲染的不一致。
这种场景下建议使用 useEffect。传递给 useEffect 的函数将在渲染更新之后执行，或者如果你将依赖项数组作为第二个参数传递，那么每当依赖项之一发生更改时，就会调用该函数。

```ts
useEffect(() => {
  console.log('Logging something');
}, [])
```

[了解更多](https://react.dev/reference/react/useEffect)

### 9. 如何追踪函数组件的卸载？

通常，`useEffect`会创建一些任务，例如订阅或者定时器标识符，这些任务一般都会在关闭界面之后被重置或者清理掉。
为了做到这一点，传递给 `useEffect` 的函数可以返回一个 **清理函数**。这个函数在组件卸载之前执行，以防止内存泄漏。
此外，如果组件渲染多次（通常是这种情况），则在执行下一个副作用之前清除前一个副作用。

```ts
useEffect(() => {
  function handleChange(value) {
    setValue(value);
  }
  SomeAPI.doFunction(id, handleChange);

  return function cleanup() {
    SomeAPI.undoFunction(id, handleChange);
  };
})
```

### 10. React 中的 props 是什么？

Props 是从父组件传递过来的数据，它是只读的，不能在子组件内修改。

```tsx
// Parent component
const Parent = () => {
  const data = "Hello, World!";

  return (
    <div>
      <Child data={data} />
    </div>
  );
};

// Child component
const Child = ({ data }) => {
  return <div>{data}</div>;
};
```

[了解更多](https://react.dev/learn/passing-props-to-a-component)

### 11. 什么是状态管理，你使用过或者了解过哪些状态管理工具？

状态管理器是帮助应用程序管理状态的工具或库。它提供了一个集中的仓库或容器，用于存储和管理应用程序中不同组件都可以访问和更新的数据。

状态管理器可以解决几个问题。首先，将数据和与之相关的逻辑从组件中分离出来是一个很好的做法。其次，当使用局部状态并在组件之间传递时，由于组件可能进行深度嵌套，代码可能会变得复杂。通过全局状态管理，我们可以访问和修改来自任何组件的数据。

和 React Context 一样，Redux 或 MobX 也是常用状态管理库之一。

[了解更多](https://mobx.js.org/README.html)  

[了解更多](https://redux-toolkit.js.org/)

### 12. 什么情况下应该使用本地状态和全局状态？

如果状态仅仅被一个组件使用并且不会传递给其他组件，此时推荐使用本地状态。本地状态还用来渲染列表项。然而，如果组件之间的组合导致数据需要在多个嵌套组件之间传递，那么推荐使用全局状态。

### 13. 在 Redux 中什么是 reducer，它接收哪些参数？

reducer是一个接收 state 和 action 作为参数的纯函数。
在 reducer 内部，我们获取到 action 的type，根据不同的类型我们去修改 state 并返回新的 state。

```ts
export default function appReducer(state = initialState, action) {
  // The reducer normally looks at the action type field to decide what happens
  switch (action.type) {
    // Do something here based on the different types of actions
    default:
      // If this reducer doesn't recognize the action type, or doesn't
      // care about this specific action, return the existing state unchanged
      return state
  }
}
```

[了解更多](https://redux.js.org/tutorials/fundamentals/part-3-state-actions-reducers)

### 14. 在Redux中什么是 action，如何修改 state？
 
Action 是一个含有 type 属性的 js 对象

```ts
{
  type: "SOME_TYPE"
}
```

你还可以选择性地新增一些数据 例如 **payload**. 为了改变 state，我们必须调用 dispatch 函数，这个函数会帮助我们传递 action 对象

```ts
{
  type: "SOME_TYPE",
  payload: "Any payload",
}
```

[了解更多](https://redux.js.org/tutorials/fundamentals/part-3-state-actions-reducers)

### 15. Redux 实现了什么模式？

Redux 实现了 **Flux 模式**, 它是应用程序中的一种可预测的状态管理模式。它通过引入单向数据流和应用程序状态的集中存储来帮助管理应用程序的状态。

[了解更多](https://www.newline.co/fullstack-react/30-days-of-react/day-18/#:~:text=Flux%20is%20a%20pattern%20for,default%20method%20for%20handling%20data.)

### 16. Mobx 实现了什么模式？

Mobx 实现了 **观察者模式**, 也被称作发布订阅模式。  

[了解更多](https://www.patterns.dev/posts/observer-pattern)

### 17. 使用Mobx有什么特点？

Mobx 提供了`observable` 和 `computed` 等装饰器来定义可观察的状态和响应式函数。装饰之后的 action 被用来修改 state，以确保所有的改变都能够被追踪到。Mobx 还提供了自动追踪依赖、不同类型的响应式、对响应式的细粒度的控制，以及通过 mobx-react 库与 React 无缝集成。总的来说，Mobx 通过监听 observable state 的变化自动触发状态更新来简化状态管理。

### 18. 在 Mobx 状态中如何访问一个变量？

你可以使用`observable`这个装饰器将变量变为可观察状态，从而在 state 中访问这个变量。举例说明:  

```ts
import { observable, computed } from 'mobx';

class MyStore {
  @observable myVariable = 'Hello Mobx';

  @computed get capitalizedVariable() {
    return this.myVariable.toUpperCase();
  }
}

const store = new MyStore();
console.log(store.capitalizedVariable); // Output: HELLO MOBX

store.myVariable = 'Hi Mobx';
console.log(store.capitalizedVariable); // Output: HI MOBX
```

在这个例子中, 通过`observable`装饰器，`myVariable` 被定义为可观察的变量.然后你可以通过`store.myVariable`访问这个变量。任何对`myVariable`变量的修改都会自动触发组件或者副作用的更新。

[了解更多](https://mobx.js.org/actions.html)

### 19. Redux 和 Mobx有什么区别？

Redux 是一个更简单、更保守的状态管理库，它遵循严格的单向数据流，并提高了不可变性。它需要更多的样板代码和显式的更新，但是与 React 有很好的集成
另一方面，Mobx 提供了一个更加灵活和直观的 API，而且样板代码更少。它允许你直接修改状态并自动跟踪更改以获得更好的性能。Redux 和 Mobx 之间的选择取决于你的具体需求和偏好。

### 20. 什么是 JSX？

默认情况下, 在 react 中可以用下面的语法来创建元素。

```tsx
const someElement = React.createElement(
  'h3',
  {className: 'title__value'},
  'Some Title Value'
);
```

但是我们是这样创建元素的：

```tsx
const someElement = (
  <h3 className='title__value'>Some Title Value</h3>
);
```
 
这就是所谓的 jsx，它是一种语言扩展，简化了对代码和开发的理解。

[了解更多](https://react.dev/learn/writing-markup-with-jsx#jsx-putting-markup-into-javascript)

### 21. 什么是 props drilling？

Props drilling 指的是多级嵌套的组件之间层层传递 props 的一种情况, 即使某些组件并不会直接使用这些 props。 这可能导致代码结构非常复杂和冗余。 

```tsx
// Parent component
const Parent = () => {
  const data = "Hello, World!";

  return (
    <div>
      <ChildA data={data} />
    </div>
  );
};

// Intermediate ChildA component
const ChildA = ({ data }) => {
  return (
    <div>
      <ChildB data={data} />
    </div>
  );
};

// Leaf ChildB component
const ChildB = ({ data }) => {
  return <div>{data}</div>;
};
```

在这个例子中，`data` prop 从 Parent 组件传递给 ChildA，然后从 ChildA 传递给 ChildB，尽管 ChildA 并没有直接使用该prop。当嵌套层次很多，或者需要在非常深的层级中访问数据时，这可能会成为问题。这会使代码更难维护和理解。

通过使用其他模式，如context或状态管理库（如 Redux 或 MobX） ，可以减少 Props drilling。这些方法允许组件访问数据，而无需通过每个中间组件传递 props。

### 22. 如何条件渲染？
 
你可以使用任何条件操作符，包括三元表达式。

```tsx
return (
  <div>
    {isVisible && <span>I'm visible!</span>}
  </div>
);
```

```tsx
return (
  <div>
    {isOnline ? <span>I'm online!</span> : <span>I'm offline</span>}
  </div>
);
```

```tsx
if (isOnline) {
  element = <span>I'm online!</span>;
} else {
  element = <span>I'm offline</span>;
}

return (
  <div>
    {element}
  </div>
);
```

[了解更多](https://react.dev/learn/conditional-rendering)

### 23. useMemo 用处是什么，它是如何运作的?

`useMemo`被用来缓存计算结果。
需要传递一个创建值的函数以及一个依赖数组。只有当依赖数组中的值发生变化时`useMemo`才会重新计算被缓存的数据。
这个优化帮助 React 应用程序降低了渲染时的计算开销。
对于第一个参数，函数接受执行计算的回调，对于第二个参数，函数接受依赖项数组，只有当至少一个依赖项被更改时，函数才会重新执行计算。

```ts
const memoValue = useMemo(() => computeFunc(paramA, paramB), [paramA, paramB]);
```

[了解更多](https://react.dev/reference/react/useMemo)

### 24. useCallback是什么，它是如何运作的？

`useCallback`钩子会返回一个被缓存的回调函数，这个回调函数只有在依赖数组中任何一个值发生改变时才会更新。
当需要传递给子组件函数时，使用它可以减少不必要的重新渲染。

```ts
const callbackValue = useCallback(() => computeFunc(paramA, paramB), [paramA, paramB]);
```

[了解更多](https://react.dev/reference/react/useCallback)

### 25. useMemo 与 useCallback有什么不同？

1.  `useMemo` 用来缓存计算结果, 而 `useCallback` 用来缓存函数。
2.  如果依赖没有发生变化，`useMemo` 会缓存计算值并且在后续的渲染中都会返回这个值。
3.  如果依赖没有发生变化，`useCallback` 会缓存这个函数，并且在后续渲染中都会返回同一个函数。

### 26. 什么是 React Context？

React Context 是一个特性，它提供了一种通过组件树传递数据的方法，而无需在每个层级手动传递 props。它允许你创建一个全局状态，该状态可以被树中的任何组件访问，而不管其位置如何。当你需要在组件之间共享数据并且这些组件无法直接通过 props 进行传递时 context 就可以派上用场了。

React Context API 包括以下三个主要部分:

1.  `createContext`: 该函数用来创建一个新的 context 对象。
2.  `Context.Provider`: 该组件用来为 context 提供值。它包裹了需要访问该值的组件。
3.  `Context.Consumer` 或 `useContext` hook: 该组件或者钩子用来消费来自 context 的值。他能在任何组件中使用，只要被包裹在 context 的 provider 中。

通过使用 React Context，你可以避免 prop drilling（在多个层级组件之间传递 props），可以在更高层级方便地管理状态，并且可以让你的代码更有条理也更高效。

[了解更多](https://react.dev/learn/passing-data-deeply-with-context)

### 27. useContext 的用处，它是如何运行的？

在一个典型的 React 应用中，一般都是使用 props 将数据自顶向下传递（从父组件到子组件）。然而，这样的使用方法对于某些类型的props（例如，选中的语言，UI 主题）来说可能太麻烦了
，在这些情况下props 需要在应用程序中多个组件之间传递。context 提供了一种组件树各个层级之间共享数据的方式。
调用 useContext 的组件会在 context 值改变时重新渲染。如果重新渲染组件非常消耗性能的话你可以通过缓存值来进行优化。

```tsx
const App = () => {
  const theme = useContext(ThemeContext);

  return (
    <div style={{ color: theme.palette.primary.main }}>
      Some div
    </div>
  );
}
```

[了解更多](https://react.dev/reference/react/useContext)

### 28. useRef 的用处，它是如何运行的？

`useRef` 返回一个可修改的 ref 对象，一个属性。其当前值由传递的参数初始化。返回的对象将在组件的整个生存期内持续存在，并且不会随着渲染的不同而改变。
通常的案例是命令式访问子代。
例如，使用 ref，我们可以显式地引用 DOM 元素。
```tsx
const App = () => {
  const inputRef = useRef(null);

  const buttonClick = () => {
    inputRef.current.focus();
  }

  return (
    <>
      <input ref={inputRef} type="text" />
      <button onClick={buttonClick}>Focus on input tag</button>
    </>
  )
}
```

[了解更多](https://react.dev/reference/react/useRef)

### 29. 什么是 React.memo()？

`React.memo()` 是一个高阶组件。 如果你的组件不存在 props 改变的情况，并且一直渲染着相同的内容，那么某些情况下你可以用“React.memo()“去包裹该组件以缓存结果，从而提升性能。
这意味着 React 将会复用上一次 渲染 的结果，这样就避免了重新渲染。`React.memo()` 只有在 props 改变时才会起作用。如果一个函数组件被 React.memo 包裹，并且又使用了 useState、 useReducer 或者 useContext，它将会在 state 或者 context 改变时重新渲染。

```tsx
import { memo } from 'react';

const MemoComponent = memo(MemoComponent = (props) => {
  // ...
});
```

[了解更多](https://react.dev/reference/react/memo)

### 30. 什么是 React Fragment？

在 React 的一个组件中返回多个元素是很常见的。Fragments 允许你创建一个子元素列表，而无需在 DOM 中创建不必要的节点。

```tsx
<>
  <OneChild />
  <AnotherChild />
</>
// or
<React.Fragment>
  <OneChild />
  <AnotherChild />
</React.Fragment>
```

[了解更多](https://react.dev/reference/react/Fragment)

### 31. 什么是 React Reconciliation？

Reconciliation 是 React 中的一个算法，用来从组件树中筛选出需要被替换的部分。
Reconciliation 是 以前我们所谓的虚拟 DOM 背后的算法。它的定义类似于这样: 当你渲染一个 React 程序, 描述应用程序的元素树是在内存中生成并保留的。这棵树被囊括在渲染环境中，例如在一个浏览器应用程序，这棵树被转化为一系列的 DOM 操作。
当应用程序的状态更新时，一棵新的树就会生成。然后将新旧树进行对比，准确地计算出下一次渲染更新需要做那些操作。


[了解更多](https://react.dev/learn/preserving-and-resetting-state)

### 32. 在列表中使用 map() 为什么需要 key？

key 帮助 React 确定哪些元素被改变了，新增了那些元素，删除了哪些元素。这些元素必须被准确地标记出来，这样 React 才能够匹配不断更新的数组元素。选择 key 最好的方式是用一个能区别其他所有元素的字符串。通常，你会使用数据中的 ID 作为 key。

```tsx
const languages = [
  {
    id: 1,
    lang: "JavaScript",
  },
  {
    id: 2,
    lang: "TypeScript",
  },
  {
    id: 3,
    lang: "Python",
  },
];

const App = () => {
  return (
    <div>
      <ul>{languages.map((language) => (
        <li key={“${language.id}_${language.lang}“}>{language.lang}</li>
      ))}
      </ul>
    </div>
  );
}
```

[了解更多](https://react.dev/learn/rendering-lists#keeping-list-items-in-order-with-key)

### 33. 在 Redux Thunk 中怎么处理异步 actions？

要使用 Redux Thunk, 你需要把它作为一个中间件导入进来。 Action creators 不应该仅仅返回一个对象而是一个接收 dispatch 参数的函数。  

```ts
export const addUser = ({ firstName, lastName }) => {
  return dispatch => {
    dispatch(addUserStart());
  }

  axios.post('https://jsonplaceholder.typicode.com/users', {
    firstName,
    lastName,
    completed: false
  })
  .then(res => {
    dispatch(addUserSuccess(res.data));
  })
  .catch(error => {
    dispatch(addUserError(error.message));
  })
}
```

[了解更多](https://redux.js.org/usage/writing-logic-thunks)

### 34. 在函数式组件中怎么追踪对象中某个字段的变化？

要做到这一点, 你需要使用 `useEffect` 钩子并且把该字段传入依赖数组。  

```ts
useEffect(() => {
  console.log('Changed!')
}, [obj.someField])
```

### 35. 怎么访问一个 DOM 节点？

Refs 可以通过 `React.createRef()` 或者 `useRef()` 钩子创建，它可以通过 ref 属性应用到 React 元素上。 通过访问创建的 ref 的引用, 我们可以使用 `ref.current` 访问 DOM 节点。  

```tsx
const App = () => {
  const myRef = useRef(null);

  const handleClick = () => {
    console.log(myRef.current); // Accessing the DOM element
  };

  return (
    <div>
      <input type="text" ref={myRef} />
      <button onClick={handleClick}>Click Me</button>
    </div>
  );
}

export default App;
```

### 36. 什么是自定义钩子？

自定义钩子是一个函数，这个函数允许你在不同组件之间复用代码逻辑。
它是封装可复用逻辑的一种方法，这样就可以方便地跨多个组件共享和复用它。
自定义钩子是通常以单词 * _ use * _ 开头的函数，如果需要，也可以调用其他钩子。

[了解更多](https://react.dev/learn/reusing-logic-with-custom-hooks)

### 37. 什么是 Public API？

在索引文件的上下文中，Public API 通常指的是外部模块或组件可以公开和访问的接口或函数。
下面是表示 Public API 的索引文件的代码示例

```js
// index.js

export function greet(name) {
  return “Hello, ${name}!“;
}

export function calculateSum(a, b) {
  return a + b;
}
```

在这个示例中，index.js 文件充当一个公共 API，其中导出了函数`greet()`和`calculateSum()`，并且可以通过导入它们从其他模块访问它们。其他模块可以导入并使用这些函数作为其实现的一部分

```js
// main.js

import { greet, calculateSum } from './index.js';

console.log(greet('John')); // Hello, John!
console.log(calculateSum(5, 3)); // 8
```

通过从索引文件导出特定的函数，我们定义了模块的 Public API，允许其他模块使用这些函数。

### 38. 创建一个自定义 hook 有哪些规则？

1.  以 use 开头来命名 hook。
2.  如果需要的话使用已有的 hook。
3.  不要在条件语句中调用 hook。
4.  把可复用的逻辑抽离到自定义 hook 中。
5.  自定义 hook 必须是纯函数。
6.  自定义 hook 可以返回值或者其他 hook。
7.  描述性地命名自定义hook。

[了解更多](https://react.dev/learn/reusing-logic-with-custom-hooks)

### 39. 什么是 SSR（Server-Side Rendering）？

服务器端呈现（SSR）是一种用于在服务器上呈现页面并将完全呈现的页面发送到客户端以供显示的技术。它允许服务器生成网页的完整 HTML 标记，包括其动态内容，并将其作为对请求的响应发送给客户机。

在传统的客户端呈现方法中，客户端接收最小的 HTML 页面，然后向服务器发出额外的数据和资源请求，这些数据和资源用于在客户端呈现页面。由于搜索引擎爬虫难以索引 JavaScript 驱动的内容，这可能导致初始页面加载时间变慢，并对搜索引擎搜索引擎优化(SEO)造成负面影响。

使用 SSR，服务器通过执行必要的 JavaScript 代码来生成最终的 HTML，从而负责呈现网页。这意味着客户端从服务器接收完全呈现的页面，从而减少对额外资源请求的需求。SSR 提高了初始页面加载时间，并允许搜索引擎轻松索引内容，从而实现更好的 SEO。

SSR 通常用于框架和库中，比如用于 React 的 Next.js 和用于 Vue.js 的 Nuxt.js，以支持服务器端呈现功能。这些框架为你处理服务器端呈现逻辑，使得实现 SSR 更加容易。

### 40. 使用 SSR 的好处是什么？

1.  **优化初始加载时间**: SSR 允许服务器向客户端发送完整的 HTML 页面，从而减少客户端所需的处理量。这优化了初始加载时间，因为用户可以更快地看到完整的页面。
    
2.  **对SEO友好**: 搜索引擎可以有效地抓取和索引 SSR 页面的内容，因为完整的 HTML 在初始响应中是可用的。这提高了搜索引擎的可见性，并有助于更好的搜索排名。
    
3.  **可访问性**: SSR 确保禁用 JavaScript 或使用辅助技术的用户可以访问内容。通过在服务器上生成 HTML，SSR 为所有用户提供了可靠和可访问的用户体验。
    
4.  **低带宽环境下的性能**: SSR 可以减少客户端需要下载的数据量，从而有利于低带宽或高延迟环境中的用户。这对于移动用户或互联网连接较慢的用户尤其重要。
    

虽然 SSR 提供了这些好处，但是需要注意的是，与客户端渲染方法相比，它可能会引入更多的服务器负载和维护复杂性。应该仔细考虑缓存、可伸缩性和服务器端渲染性能优化等因素。

### 41. 你所知道的 Next.js 的主要功能是什么？

1.  `getStaticProps`: 此方法用于在生成时获取数据并预先将页面呈现为静态 HTML。它确保数据在构建时可用，并且不会在后续请求中更改。

```tsx
export async function getStaticProps() {
  const res = await fetch('https://api.example.com/data');
  const data = await res.json();

  return {
    props: {
      data
    }
  };
}
```

1.  `getServerSideProps`: 此方法用于获取每个请求的数据并在服务器上预渲染页面。当你需要获取可能经常更改或特定于用户的数据时，可以使用它。

```ts
export async function getServerSideProps() {
  const res = await fetch('https://api.example.com/data');
  const data = await res.json();

  return {
    props: {
      data
    }
  };
}
```

1.  `getStaticPaths`: 此方法在动态路由中用于指定应在生成时预渲染的路径列表。它通常用于带参数的动态路由获取数据。

```ts
export async function getStaticPaths() {
  const res = await fetch('https://api.example.com/posts');
  const posts = await res.json();

  const paths = posts.map((post) => ({
    params: { id: post.id }
  }));

  return {
    paths,
    fallback: false
  };
}
```

[了解更多](https://nextjs.org/docs/app/building-your-application/data-fetching/fetching-caching-and-revalidating)

### 42. 什么是 linters？

Linters 是用来检查源代码是否存在潜在错误、 bug、风格不一致和可维护性问题的工具。它们有助于强制执行编码标准，并确保代码质量和跨代码库的一致性。

Linters 通过扫描源代码并将其与一组预定义的规则或指南进行比较来工作。这些规则包含语法和格式约定、最佳实践、潜在的 bug 和代码异味。当一个 linter 辨别出不符合规则的代码，它会生成一个警告或错误，高亮展示需要注意的特定行或代码行。

使用 Linter 可以带来几个好处:

1.  **代码质量**: Linters 有助于识别和防止潜在的 bug、代码味道和反模式，从而提高代码质量。
    
2.  **一致性**: Linters 强制执行编码约定和样式指南，确保跨代码库的一致格式和代码结构，即使当多个开发人员在同一个项目中工作时也是如此。
    
3.  **可维护性**: 通过及早发现问题和促进良好的编码实践，linter 有助于代码的可维护性，使代码库更容易理解、修改和扩展。
    
4.  **高效性**: 通过自动化代码审查过程和在常见错误导致开发过程或生产过程中出现问题之前捕捉常见错误，Linters 可以节省开发人员的时间。
    

一些流行的 linters 有用于 JavaScript 的 ESLint 和用于 CSS 和 Sass 的 Stylelint。

[了解更多](https://eslint.org/docs/latest/use/getting-started)

### 43. 你知道 React 的什么架构解决方案吗？

有几种架构解决方案和模式可以用来构建 React 项目，其中一些比较流行的方案包括:

1.  **MVC (Model-View-Controller)**: MVC 是一种传统的体系结构模式，它将应用程序分为三个主要组件——模型、视图和控制器。React 可用于视图层呈现 UI，而其他库或框架可用于模型和控制器层。
    
2.  **Flux**: Flux 是 Facebook 专门为 React 应用程序引入的应用程序架构。它遵循单向数据流，其中数据沿单个方向流动，从而更容易理解和调试应用程序的状态更改。
    
3.  **原子设计**: 原子设计并不是 React 特有的，而是一种将 UI 划分为更小的可重用组件的设计方法。它鼓励构建小型的、自包含的、可以组合以创建更复杂的 UI 的组件。
    
4.  **容器与组件模式**: 此模式将表现(组件)与逻辑和状态管理(容器)分离。组件负责呈现 UI，而容器负责处理业务逻辑和状态管理。
    
5.  **特性切片设计**: 它是一种用于组织和构建 React 应用程序的现代体系结构方法。它旨在通过基于特性或模块划分应用程序代码库来解决可伸缩性、可维护性和可重用性方面的挑战。
    

### 44. 什么是特性切片设计?

它是一种用于组织和构建 React 应用程序的现代体系结构方法。它旨在通过基于特性或模块划分应用程序代码库来解决可伸缩性、可维护性和可重用性方面的挑战。

在功能切片设计中，应用程序的每个功能或模块被组织到一个单独的目录中，包含所有必要的组件、操作、减少器和其他相关文件。这有助于保持代码库的模块化和隔离性，使其更容易开发、测试和维护。

功能切片设计促进了一个清晰的关注点分离，并将功能封装在个别功能中。这允许不同的团队或开发人员独立处理不同的特性，而不必担心冲突或依赖性。

[![Feature-Sliced Design](https://res.cloudinary.com/practicaldev/image/fetch/s--Cuy79Z1p--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/amysbtftfjkuss87yu8v.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Cuy79Z1p--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_800/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/amysbtftfjkuss87yu8v.png)

**我强烈建议你点击“了解更多”按钮来学习“特性切片设计”**  

[了解更多](https://dev.to/m_midas/feature-sliced-design-the-best-frontend-architecture-4noj)

## 了解更多

如果你还没有读过我关于前端面试问题的其他文章，我强烈建议你读一读。

## 结语

总之，应聘 React Fronend Developer 职位需要对框架的核心概念、原则和相关技术有扎实的理解。通过准备本文讨论的问题，你可以展示你的 React 知识，并展示你创建高效和可维护的用户界面的能力。记住，不仅要专注于记忆答案，还要理解基本概念，并能够清楚地解释它们。
此外，请记住，面试不仅仅是技术方面的问题，也是展示你解决问题的技巧、沟通能力以及如何在团队中工作的问题。通过结合技术专业知识和强大的整体技能集，你将有充分的准备，在前端开发面试中有出色的表现，并且能够在这个令人兴奋的和迅速发展的领域找到你的理想工作。
祝你好运！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
