> * 原文地址：[React hooks: not magic, just arrays](https://medium.com/@ryardley/react-hooks-not-magic-just-arrays-cd4f1857236e)
> * 原文作者：[Rudi Yardley](https://medium.com/@ryardley?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-hooks-not-magic-just-arrays.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-hooks-not-magic-just-arrays.md)
> * 译者：[Xekin-FE](https://github.com/Xekin-FE)
> * 校对者：

# 揭开 React Hooks 的神秘面纱:数组解构融成魔法

## 用模型解析此提案的执行规则

我是一个对 React Hooks 这个 API 非常感兴趣的忠实粉丝。关于如何使用它，这里有一些[奇怪的规则](https://reactjs.org/docs/hooks-rules.html)。为了那些纠结于如何使用这些规则的人，在这里我会以模型图的方式来向你们展示这个新的 API。

### 警告: Hooks 这项提案仍在测试阶段

_这篇文章主要讲述的是关于 React hooks 这项新 API，此时这个提案仍处于 alpha 测试版本。你可以在 [React 官方文档](https://reactjs.org)中找到稳定的 React API_

* * *

![](https://cdn-images-1.medium.com/max/2000/1*TharLROVH7aX2MotovHOBQ.jpeg)

图片来自网站 Pexels(rawpixel.com)

### 拆解 Hooks 的工作方式

“就像魔法一样无法理解”，这是我从一些人口中听到的对于这项新提案的评价，所以我愿意尝试通过拆解这项提案的代码语法去了解它是如何在代码中工作的，至少也要了解它最表层的执行逻辑。

#### Hooks 的规则

React 的核心团队规定我们在使用 hooks 时必须遵从他们的 [hooks 提案文档](https://reactjs.org/docs/hooks-rules.html)，而在文档中主要有两条使用规定。

*   **不要在循环、条件语句或者嵌套函数中调用 Hooks**
*   **只能在 React 函数中调用 Hooks**

对于后者我觉得是不言而喻的。要将自己的业务代码嵌入到功能组件当中你自然需要以通过某种方式将你的代码和组件联系起来。

至于前者我认为也是令人感到困惑的一点，因为这与正常编程时调用 API 的方式相比可能看起来并不寻常，这也是我今天正想探索的地方。

#### 在 hooks 中，状态管理都与数组有关

为了让我们更直白地理解这个模型，让我们直接实现一个简单的 hooks API 实例看看它可能长什么样子。

**_请注意这只是推测，并且只是可能的 API 实现方法，主要是为了展示应该通过怎样的思维去理解它。当然这并不一定就是 API 实际的内部工作方式。而且目前这也只是一个提案，在未来一切都可能发生改变_**

#### 我们可以怎样实现 \`useState()\` ?

让我们通过剖析一个例子来演示一下状态钩子的实现可能会怎么运行吧。

首先让我们从一个组件开始:

```
function RenderFunctionComponent() {
  const [firstName, setFirstName] = useState("Rudi");
  const [lastName, setLastName] = useState("Yardley");

  return (
    <Button onClick={() => setFirstName("Fred")}>Fred</Button>
  );
}
```

实现 hooks API 的基本思想是把一个 setter 方法作为钩子函数返回的第二个数组项，之后通过这个 setter 方法来控制钩子管理的状态。

### 所以让我们来看看 React 将利用它来做些什么?

让我先解释一下在 React 的内部中它可能会怎么工作。下面图表将为我们展示在渲染一个特定组件时其内部执行上下文的执行过程。这也意味着存储在这里的数据位于被渲染的组件外面的一层。虽然这里的状态没有与其他组件共享，但是它会继续保留在一定范围之内以供后续渲染对应的特殊组件时使用。

#### 1) 初始化

声明两个空数组：`setters` 和 `state`

设置一个 cursor 参数为 0

![](https://cdn-images-1.medium.com/max/1600/1*LAZDuAEm7nbcx0vWVKJJ2w.png)

初始化：两个空数组，cursor 参数为 0

* * *

#### 2) 初次渲染

第一次执行组件方法

当调用 `useState()` 时，第一次会将一个 setter 方法（就是以 cousor 为下标时的参数）添加到 `setters` 数组当中然后再把一些状态添加到 `state` 数组当中。

![](https://cdn-images-1.medium.com/max/1600/1*8TpWnrL-Jqh7PymLWKXbWg.png)

初次渲染： cursor ++，变量分别被写入数组当中

* * *

#### 3) 后续渲染

后续的每一次渲染过程当中 cursor 都将被重置，而渲染的值都只是从每一次的数组当中取出来的。

![](https://cdn-images-1.medium.com/max/1600/1*qtwvPWj-K3PkLQ6SzE2u8w.png)

后续渲染：从数组（以 cursor 为下标）中读取了每一项变量的值

* * *

#### 4) 事件代理

因为每一个 setter 方法都和其 cursor 绑定以至于通过触发来调用任何 `setter` 时它都将改变对应索引位置的状态数组的状态值。

![](https://cdn-images-1.medium.com/max/1600/1*3L8YJnn5eV5ev1FuN6rKSQ.png)

Setters “记住”了他们的索引并根据它来写入内存。

* * *

#### 以及底层的实现

这里用一段代码示例来展示：

```
let state = [];
let setters = [];
let firstRun = true;
let cursor = 0;

function createSetter(cursor) {
  return function setterWithCursor(newVal) {
    state[cursor] = newVal;
  };
}

// 这是我仿写的 useState 辅助类
export function useState(initVal) {
  if (firstRun) {
    state.push(initVal);
    setters.push(createSetter(cursor));
    firstRun = false;
  }

  const setter = setters[cursor];
  const value = state[cursor];

  cursor++;
  return [value, setter];
}

// 我们在组件代码中使用上面的钩子
function RenderFunctionComponent() {
  const [firstName, setFirstName] = useState("Rudi"); // cursor: 0
  const [lastName, setLastName] = useState("Yardley"); // cursor: 1

  return (
    <div>
      <Button onClick={() => setFirstName("Richard")}>Richard</Button>
      <Button onClick={() => setFirstName("Fred")}>Fred</Button>
    </div>
  );
}

// 这里模拟了 React 的渲染周期
function MyComponent() {
  cursor = 0; // resetting the cursor
  return <RenderFunctionComponent />; // render
}

console.log(state); // Pre-render: []
MyComponent();
console.log(state); // First-render: ['Rudi', 'Yardley']
MyComponent();
console.log(state); // Subsequent-render: ['Rudi', 'Yardley']

// click the 'Fred' button

console.log(state); // After-click: ['Fred', 'Yardley']
```

### 为什么这样的规则不可避免？

现在如果我们根据一些外部因素或者甚至是组件状态去把 hooks 命令放在渲染周期里执行会怎样呢？

让我们尝试写一些 React 团队规定限制之外的逻辑：

```
let firstRender = true;

function RenderFunctionComponent() {
  let initName;
  
  if(firstRender){
    [initName] = useState("Rudi");
    firstRender = false;
  }
  const [firstName, setFirstName] = useState(initName);
  const [lastName, setLastName] = useState("Yardley");

  return (
    <Button onClick={() => setFirstName("Fred")}>Fred</Button>
  );
}
```

这破坏了规则!

在这里我们在条件语句中调用了一个 `useState`。一起来看这样会对整个系统造成多大的影响。

#### 被“破坏”的组件第一次渲染

![](https://cdn-images-1.medium.com/max/1600/1*C4IA_Y7v6eoptZTBspRszQ.png)

渲染一个外部的“坏”钩，之后它将会在下次渲染时消失不见。

在此时我们在实例中声明的 `firstName` 和 `lastName` 暂时还带着正确的数据，但接下来让我们看看在第二次渲染时会发生什么：

#### 被“破坏”的组件第二次渲染

![](https://cdn-images-1.medium.com/max/1600/1*aK7jIm6oOeHJqgWnNXt8Ig.png)

在渲染时移除了钩子之后，我们发现了一个错误。

由于在此时我们的状态存储了错位的数据使 `firstName` 和 `lastName` 被同时赋值为 `“Rudi”`。这很明显是不正确的而且它也没有任何作用，但是这也给我们说明了为什么 hooks 具有这样的规则限制。

> React 团队正在制定使用规范因为不遵守它们将会使数据错位。

#### 思考一下如何在不违反规则的情况下使用 hooks 操作一组数组

所以现在我们应该非常清楚为什么我们不能在循环或者条件语句中调用 `use` 钩子。因为事实上我们的代码处理是基于数组解构赋值的，如果你更改了渲染时的调用顺序，那么就会使我们的数据或者事件处理器在解构后没有匹配正确。

所以技巧是考虑让 hooks 用一致的 cursor 来管理数组业务，如果你这么做就可以让它正常的工作。

### 结论

希望我是建立了一个比较清晰的模型向你们展示了这个新 hooks API 在底层是如何进行工作的。记住这里真正的价值是如何把我们所好奇的点一步步解析出来所以你只要多注意 hooks API 的规则，这样我们就能更好的利用它。

在 React 组件中 Hooks 是一个高效率的 API。这也是人们对它趋之若鹜的原因，如果你还没想到答案，那么只要把数组存储为状态的形式，就会发现你并没有破坏他们的规则。

我希望将来可以持续再了解一下 `useEffects` 方法并且尝试对比一下它和 React 的那些生命周期方法有什么区别。

* * *

_这篇文章尚有不足之处，如果你有更好的建议或者发现了文章中的错误纰漏请及时跟我联系。_

_你可以在 Twitter 上关注 Rudi Yardley_[_@rudiyardley_](https://twitter.com/rudiyardley)_或者关注 github_[_@_ryardley](https://github.com/ryardley)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
