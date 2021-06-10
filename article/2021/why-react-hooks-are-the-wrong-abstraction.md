> * 原文地址：[Why React Hooks Are the Wrong Abstraction](https://medium.com/better-programming/why-react-hooks-are-the-wrong-abstraction-8a44437747c1)
> * 原文作者：[Austin Malerba](https://medium.com/@austinmalerba)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-react-hooks-are-the-wrong-abstraction.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-react-hooks-are-the-wrong-abstraction.md)
> * 译者：[fltenwall](https://github.com/fltenwall)
> * 校对者：[zenblo](https://github.com/zenblo) [PassionPenguin](https://github.com/PassionPenguin)

# 为什么 React Hooks 是错误的抽象

![Photo by the author.](https://cdn-images-1.medium.com/max/5576/1*LVjLXZ8-mBmhJZoJj3w_3w.png)

在开始之前, 我想表达我对 React 团队多年来所付出的努力的感激。他们创建了一个很棒的框架，从很多方面来说，它是我对现代 Web 开发的引路人。他们为我铺平了道路，让我确信我的想法是正确的，如果没有他们的聪明才智，我不可能得出这些结论。

在今天的文章中，我将提出我所观察到的 Hooks 的缺点，并提出一种同样强大但不需要太多注意事项的替代 API 。我要说的是，这个 [替代API](https://malerba118.github.io/elementos-docs/) 有点冗长，但它对计算的浪费较少，概念上更准确，而且与框架无关。

## Hooks 的问题 #1: 附加渲染

作为设计的一般规则，我认识到我们应该首先禁止用户犯错误。只有当我们无法阻止用户犯错误时，我们才应该在他们犯了错误后通知他们。

举个例子，当允许用户在输入字段中输入数量时，我们可以允许他们输入字母数字字符，如果在他们的输入中发现字母字符，就向他们显示错误消息。但是，如果我们只允许用户在字段中输入数字字符，我们就可以提供更好的用户体验，这样就不需要检查是否包含字母字符了。

React 的行为与此非常相似。如果我们从概念上考虑 Hooks，它们在组件的整个生命周期内都是静态的。我的意思是说，一旦声明了，我们就不能从组件中移除它们，也不能改变它们相对于其他 Hooks 的位置。 React 使用 lint 规则并抛出错误，试图阻止开发人员违反这个 Hooks 的细节。

从这个意义上说，React 允许开发者犯错误，然后试图警告用户他们的错误。为了说明白我的意思，看下这个例子:

```JSX
const App = () => {
  const [countOne, setCountOne] = useState(0);
  if (countOne === 0) {
    const [countTwo, setCountTwo] = useState(0);
  }

  return (
    <button
      onClick={() => {
        setCountOne((prev) => prev + 1);
      }}
    >
      Increment Count One: {countOne}
    </button>
  );
};
```

当计数器增加时，会在第二次渲染时产生一个错误，因为组件将删除第二个 `useState` Hooks:

```
Error: Rendered fewer hooks than expected. This may be caused by an accidental early return statement.
```

组件第一次渲染时，Hooks 的位置决定了 React 在后续渲染时必须在哪里找到 Hooks。

既然 Hooks 在组件的生命周期内都是静态的，那么我们在组件构造时声明它们不是比在渲染阶段声明它们更有意义吗？如果我们在组件的构造过程中附加了 Hooks，我们就不再需要担心强制执行 Hooks 的规则，因为在组件的生命周期中，Hooks 不会再有机会改变位置或被移除。

不幸的是，函数组件没有构造函数的概念，但是让我们假设它们是构造函数。我想它会像下面这样:

```JSX
const App = createComponent(() => {
  // This is a constructor function that only runs once 
  // per component instance.
  
  // We would declare our hooks in the constructor.
  const [count, setCount] = useState(0)
  
  // The constructor function returns a render function.
  return (props, state) => (
    <div>
      {/*...*/}
    </div>
  );
});
```

通过在构造函数中将 Hooks 附加到组件上，我们不必担心它们在重新渲染时发生移位。

如果你在想，“你不能仅仅将 Hooks 移动到构造函数。他们**需要**在每次渲染时运行，以获取最新的值”在这一点上，那么你是完全正确的!

我们不能只是将 Hooks 移出渲染函数，因为我们会破坏它们。所以我们要用别的东西来代替它们。但首先，Hooks 的第二个主要问题是：

## Hooks 的问题 #2: 假设状态改变

我们知道，任何时候组件的状态发生变化，React 都会重新渲染该组件。当我们的组件因大量的状态和逻辑而变得臃肿时，这就会成为一个问题。假设我们有一个组件，它有两个不相关的状态: A 和 B。如果我们更新状态 A，我们的组件会因为状态的改变而重新呈现。即使B没有改变，任何依赖于它的逻辑都会重新运行，除非我们用 `useMemo`/`useCallback` 包装这个逻辑。

这是一种浪费，因为 React 本质上是说“好吧，在渲染函数中重新计算所有这些值”，然后当它遇到 `useMemo` 或者 `useCallback` 时，它就会返回那个决定，并在碎片上退出。但是，如果 React 只运行它需要运行的内容，那就更有意义了。

## 响应式编程

响应式编程已经存在很长一段时间了，但最近在 UI 框架中成为一种流行的编程范式。

响应式编程的核心思想是，变量是可观察的，当一个可观察对象的值发生变化时，观察者会通过回调函数来通知这个变化:

```JavaScript
const count$ = observable(5)

observe(count$, (count) => {
  console.log(count)
})

count$.set(6)
count$.set(7)

// Output:
// 6
// 7
```

注意，当我们修改可观察的 `count$` 值时，传递给 `observe` 的回调函数是如何执行的。您可能想知道 `count$` 后面的 `$`。这就是所谓的 [Finnish Notation](https://medium.com/@benlesh/observables-and-finnish-notation-df8356ed1c9b)，它简单地指出变量包含一个可观察对象。

在响应式编程中，还有一个计算或派生的可观察对象的概念，它既可以观察也可以被观察。下面是一个派生的可观察对象的例子，它跟踪另一个可观察对象的值，并对它应用 `transform`：

```JavaScript
const count$ = observable(5)
const doubledCount$ = derived(count$, (count) => count * 2)

observe(doubledCount$, (doubledCount) => {
  console.log(doubledCount)
})

count$.set(6)
count$.set(7)

// Output:
// 12
// 14
```

这与我们前面的示例类似，只是现在我们将记录重复的计数。

## 用响应式来改造 React

在介绍了响应式编程的基础知识之后，让我们看一下 React 中的一个示例，并通过使其更具响应性来改进它。

考虑一个应用程序有两个计数器和一个依赖于其中一个计数器的派生状态：

```JSX
const App = () => {
  const [countOne, setCountOne] = useState(0);
  const [countTwo, setCountTwo] = useState(0);

  const countTwoDoubled = useMemo(() => {
    return countTwo * 2;
  }, [countTwo]);

  return (
    <div>
      <button
        onClick={() => {
          setCountOne((prev) => prev + 1);
        }}
      >
        Increment Count One: {countOne}
      </button>
      <button
        onClick={() => {
          setCountTwo((prev) => prev + 1);
        }}
      >
        Increment Count Two: {countTwo}
      </button>
      <p>Count Two Doubled: {countTwoDoubled}</p>
    </div>
  );
};
```

在这里，我们有逻辑将 `countTwo` 的值在渲染两次，但如果 `useMemo` 发现 `countTwo` 的值与它在前一个渲染上的值相同，那么再次渲染的值将不会在该渲染上重新派生。

结合我们早期的想法，我们可以从 React 中提取状态职责，并在构造函数中将状态设置为可观察对象的图形。当 `observable` 发生变化时，它就会通知组件，这样组件就知道要重新渲染了：

```JSX
const App = createComponent(({ setState }) => {
  // This is a constructor layer that only runs once.
  // Create observables to hold our counter state.
  const countOne$ = observable(0);
  const countTwo$ = observable(0);
  const countTwoDoubled$ = derived(countTwo$, (countTwo) => {
    return countTwo * 2;
  });

  observe(
    [countOne$, countTwo$, countTwoDoubled$],
    (countOne, countTwo, countTwoDoubled) => {
      setState({
        countOne,
        countTwo,
        countTwoDoubled
      });
    }
  );

  // The constructor returns the render function.
  return (props, state) => (
    <div>
      <button
        onClick={() => {
          countOne$.set((prev) => prev + 1);
        }}
      >
        Increment Count One: {state.countOne}
      </button>
      <button
        onClick={() => {
          countTwo$.set((prev) => prev + 1);
        }}
      >
        Increment Count Two: {state.countTwo}
      </button>
      <p>Count Two Doubled: {state.countTwoDoubled}</p>
    </div>
  );
});
```

在上面的例子中，我们在构造函数中创建的可观察对象通过闭包在 render 函数中可用，闭包允许我们设置它们的值以响应单击事件。只有当 `countwo$` 的值改变时，`doubledCountTwo$` 观察 `countwo$` 并将其值加倍。注意，我们不是在渲染过程中而是在渲染之前获得重复计数。最后，当任何可观察对象发生变化时，我们使用 `observe` 函数重新渲染组件。

这是一个优雅的解决方案，有以下几个原因：

1. 状态和效果不再是 React 的责任，而是一个专用的状态管理库的责任，这个库可以跨框架使用，甚至不需要框架。
2. 我们的可观察对象只在构造时进行初始化，所以我们不必担心违反 Hooks 规则或在呈现期间不必要地重新运行 Hooks 逻辑。
3. 通过选择仅在依赖项发生变化时重新派生值，我们避免了在不必要的时候重新运行派生逻辑。

通过对 React API 进行一些修改，我们可以实现上面的代码。

[**在这个沙盒中尝试我们的演示!**](https://codesandbox.io/s/alternate-react-api-kyutz)

这实际上与 Vue 3 使用其组合API的方式非常相似。尽管命名不同，但是可以看到这个 Vue 代码片段惊人地相似:

```JavaScript
// 示例来自 https://composition-api.vuejs.org/#usage-in-components
import { reactive, computed, watchEffect } from 'vue'

function setup() {
  const state = reactive({
    count: 0,
    double: computed(() => state.count * 2)
  })

  function increment() {
    state.count++
  }

  return {
    state,
    increment
  }
}

const renderContext = setup()

watchEffect(() => {
  renderTemplate(
    `<button @click="increment">
      Count is: {{ state.count }}, double is: {{ state.double }}
    </button>`,
    renderContext
  )
})
```

如果这还不够令人信服，看看当我们引入一个构造函数层来反应函数组件时，“引用”变得多么简单：

```JSX
const App = createComponent(() => {  
  // We can achieve ref functionality via closures
  let divEl = null;
  
  return (props, state) => (
    <div ref={(el) => divEl = el}>
      {/*...*/}
    </div>
  );
});
```

实际上，我们不需要使用 `useRef`，因为我们可以在构造函数中声明变量，然后在组件的生命周期中从任何地方读写它们。

也许更酷的是，我们可以很容易地将 `refs` 变成可观察的：

```JSX
const App = createComponent(() => {  
  const divEl$ = observable(null);
  
  // Do something any time our "ref" changes
  observe(divEl$, (divEl) => {
    console.log(divEl)
  });
  
  return (props, state) => (
    <div ref={divEl$.set}>
      {/*...*/}
    </div>
  );
});
```

当然，我的 `observable`，`derived`，和 `observe` 的实现都有 bug，并没有形成一个完整的状态管理解决方案。更不用说这些精心设计的示例忽略了一些考虑因素，但不用担心：我在这个问题上花了很多心思，我的想法在名为 [Elementos](https://malerba118.github.io/elementos-docs/)的新响应式状态管理库中达到了顶峰！

![Photo by the author.](https://cdn-images-1.medium.com/max/5020/1*k1YTEm4t8HpWLaUcM7yfmg.png)

Elementos 是一个与框架无关的响应式状态管理库，强调状态的可组合性和封装性。如果你喜欢这篇文章，我强烈建议你去看看！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
