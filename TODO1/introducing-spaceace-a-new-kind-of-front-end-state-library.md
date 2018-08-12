> * 原文地址：[Introducing SpaceAce, a new kind of front-end state library](https://medium.com/dailyjs/introducing-spaceace-a-new-kind-of-front-end-state-library-5215b18adc11)
> * 原文作者：[Jon Abrams](https://medium.com/@jonathanabrams?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-spaceace-a-new-kind-of-front-end-state-library.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-spaceace-a-new-kind-of-front-end-state-library.md)
> * 译者：[Noah Gao](https://noahgao.net)
> * 校对者：

# SpaceAce 了解下，一个新的前端状态管理库

开发前端应用的大家都知道，状态管理是开发中最重要，最具挑战性的一部分。目前流行的基于组件的视图库，如 React，包括功能齐全的（最基本的）状态管理能力。它们使应用中的每个组件都能够管理自己的状态。这对于小型应用程序来说足够了，但您很快就会感到挫败。因为决定哪些组件具有状态以及如何在组件之间共享来自每个状态的数据是一个挑战。最后还要弄清楚状态是如何或为何被改变。

为了解决面向组件状态的上述问题，Redux 一类的库被引入。它们将该状态集中到一个集中的“store”中，每个组件都可以读写它。为了维护顺序，他们将改变状态的逻辑集中到应用程序的中心部分，称为 [** reducer **](https://redux.js.org/basics/reducers)，使用 **actions**，并使其产生新的状态副本。它非常有效，但学习曲线很高，需要大量的样板代码，并强迫您将更新状态的代码与渲染视图的代码分开。

[SpaceAce](https://github.com/JonAbrams/SpaceAce) 是一个新的库，它具有 Redux 的所有优点，例如集中的 store，不可变状态，单向数据流，明确定义的 actions，它 **还** 极大地简化了代码更新 store 中状态的方式。

我们已经在 [Trusted Health](https://www.trustedhealth.com/) 的主 React 应用上用 SpaceAce 来管理状态将近一年了，取得了巨大的成功。我们的工程师团队相对较小（只有三个人），它在不加大代码复杂度和牺牲可测试性的基础上，加速了我们的功能开发。

### SpaceAce 是什么？

SpaceAce 提供一个状态管理的 **store** 叫做一个 **space**。一个 space 包括只读（不可变）的状态，还有一些用于更新它的工具集。但是这个 store 里面不只是 **有** 状态，而是它本身就 **是** 状态。同时，他还提供了很多方法来生成新版本的状态。怎么做到？是一些带有属性的函数！很多 JS 开发者不知道 JS 函数也是对象。只是它能执行而已，所以他也能有一些属性，就像对象一样（因为它就是个对象！）。

每个 space 都是一个有属性的不可变对象，但是只能被读取，不能直接写入。每个 space **也是** 一个函数，能够创建应用改动后的状态副本。

最后，放个例子:

```javascript
import Space from 'spaceace';

const space = new Space({
    appName: "SpaceAce demoe",
    user: { name: 'Jon', level: 9001 }
});

const newSpace = space({ appName: "SpaceAce demo" });

console.log(`Old app name: ${space.appName}, new app name: ${newSpace.appName}`);
```

将会输出：“Old app name: SpaceAce demoe, new app name: SpaceAce demo”

上面的例子展示了如何创建一个 space 并通过调用它将一个对象合并到状态来直接“更改”它。这和 [React 的 setState](https://itnext.io/react-setstate-usage-and-gotchas-ac10b4e03d60) 很像，应用了一次浅合并。记住，原本的 space 并没有变化，只是被一个应用了改动的副本给替换了。

然而，这对应用在有新状态时需要进行重新渲染的场景来说，没用。为了让解决这个场景更简单，一个 **subscribe** 函数被提供出来。它能在相关 space 被“改动”时去调用回调：

```javascript
import Space, { subscribe } from 'spaceace';

const space = new Space({
    appName: "SpaceAce demoe",
    user: { name: 'Jon', level: 9001 }
});

subscribe(space, ({ newSpace, causedBy }) => {
  console.log(`State updated by ${causedBy}`);
  ReactDOM.render(
    <h1>{newSpace.appName}</h1>, 
    document.getElementById('app')
  );
});

// 将使 React 重新渲染
space({ appName: "SpaceAce demo" });
```

大多数情况下，状态都是因为用户做的事情而发生变化。比如，他们单击一个复选框、从下拉列表中选择一个选项或填入一个字段。SpaceAce 通过这些简单的交互来更新状态 **非常简单**。如果使用字符串调用 space，它将生成并返回处理函数：

```javascript
export const PizzaForm = ({ space }) => (
  <form>
    <label>Name</label>
    <input
      type="text"
      value={space.name || ''}
      onChange={space('name')} // 当用户输入时，`space.name` 会被更新
    />
    <label>Do you like pizza?</label>
    <input
      type="checkbox"
      checked={space.pizzaLover || false}
      onChange={space('pizzaLover')} // 分配 true 或 false 给 `space.pizzaLover`
     />
  </form>
);
```

虽然大多数应用只有许多简单的交互，但它们有时也会包含一些复杂的 action。SpaceAce 允许您自定义 action，所有 action 都与组件再同一文件中。调用时，会为这些 action 提供一个对象，其中包含用于更新状态的便捷函数：

```javascript
import { fetchPizza } from '../apiCalls';

/*
  handleSubmit 是一个自定义 action。
  第一个参数由 SpaceAce 提供。
  其余参数是需要传入的，
  在这个案例中由React的事件对象组成。
*/
const handleSubmit = async ({ space, merge }, event) => {
  event.preventDefault();

  // merge 函数将进行浅合并，允许一次分配多个属性
  merge({ saving: true }); // 立即更新 space，将触发重新渲染

  const { data, error } = await fetchPizza({ name: space.name });
  if (error) return merge({ error: errorMsg, saving: false });

  merge({
    saving: false,
    pizza: data.pizza // 期待得到 'Pepperoni'
  });
};

/*
  handleReset 是另一个自定义 action。
  这个函数可以用来将 space 的所有属性抹除，
  将它们用另一些替换掉。
*/
const handleReset = ({ replace }) => {
  replace({
    name: '',
    pizzaLover: false
  });
};

export const PizzaForm = ({ space }) => (
  <form onSubmit={space(handleSubmit)}>
    {/* ... 一些 input 元素 */}
    <p className="error">{space.errorMsg}</p>
    {space.pizza && <p>You’ve been given: {space.pizza}</p>}
    <button disabled={space.saving} type="submit">Get Pizza</button>
    <button disabled={space.saving} type="button" onClick={space(handleReset)}>Reset</button>
  </form>
);
```

您可能会注意到，所有这些改变空间状态的方式都会假定状态相对较浅，但如果每个应用程序只有一个 space，那怎么可能呢？不可能的！每个 space 都可以有任意数量的 sub-space，它们也只是 space，但它们有父级。每当更新其中一个 sub-space 时，改动会冒泡，一旦更改到达根 sapce，就会触发应用的重新渲染。

有关子 space 最棒的地方在于，你不用特地去制造它，他将在你访问 space 中的对象或是数组时，自动被创建出来：

```javascript
const handleRemove = ({ remove }, itemToBeRemoved) => {
  // `remove` 将在数组型 space 中可用，
  // 它将为每个元素运行回调。
  // 如果回调的结果是 true，元素将被删除。
  remove(item => item === itemToBeRemoved);
};

/*
  一个购物车的 space 将是一个物品的数组，
  每个物品都是对象，它也将是一个 space。
*/
export const ShoppingCart = ({ space }) => (
  <div>
    <ul>
      {space.map(item => (
        <li key={item.uuid}>
          <CartItem
            space={item}
            onRemove={space(handleRemove).bind(null, item)}
           />
        </li>
      )}
    </ul>
  </div>
);
const CartItem = ({ space, onRemove }) => (
  <div>
    <strong>{space.name}</strong>
    <input
      type="number"
      min="0"
      max="10"
      onChange={space('count')}
      value={space.count}
     />
    <button onClick={onRemove}>Remove</button>
  </div>
);
```

还有很多功能可以继续探索，我很快就会分享这些有趣的技巧。请继续关注我的下一篇文章！

与此同时，您可以在 [Github 上的代码和文档](https://github.com/JonAbrams/SpaceAce) 中了解更多信息，也可以 [让我知道你的想法](https://twitter.com/JonathanAbrams)！

感谢 [Zivi Weinstock](https://medium.com/@z1v1?source=post_page) 的付出。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
