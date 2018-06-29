> * 原文地址：[Surprising polymorphism in React applications](https://medium.com/@bmeurer/surprising-polymorphism-in-react-applications-63015b50abc)
> * 原文作者：[Benedikt Meurer](https://medium.com/@bmeurer?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/surprising-polymorphism-in-react-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/surprising-polymorphism-in-react-applications.md)
> * 译者： [Candy Zheng](https://github.com/blizzardzheng)
> * 校对者：[goldEli](https://github.com/goldEli)，[老教授](https://juejin.im/user/58ff449a61ff4b00667a745c)

# React 应用中的性能隐患 —— 神奇的多态

基于 React 框架的现代 web 应用经常通过不可变数据结构来管理它们的状态。比如使用比较知名的 Redux 状态管理工具。这种模式有许多优点并且即使在 React/Redux 生态圈外也越来越流行。

这种机制的核心被称作为 ``reducers``。 它们是一些能根据一个特定的映射行为 `action`（例如对用户交互的响应）把应用从一个状态映射到下一个状态的函数。通过这种核心抽象的概念，复杂的状态和 reducers 可以由一些更简单状态和 reducers 组成，这使得它易于对各部分代码隔离做单元测试。我们仔细分析一下 [Redux 文档](http://redux.js.org/docs/basics/ExampleTodoList.html) 中的例子。

```
const todo = (state = {}, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return {
        id: action.id,
        text: action.text,
        completed: false
      }
    case 'TOGGLE_TODO':
      if (state.id !== action.id) {
        return state
      }

      return Object.assign({}, state, {
        completed: !state.completed
      })

    default:
      return state
  }
}
```

这个名叫  `todo` 的 reducer 根据给定的 `action` 把一个已有的 `state` 映射到了一个新的状态。这个状态就是一个普通的 JavaScript 对象。我们单从性能角度来看这段代码，他似乎是符合单态法则的，比如这个对象的形状（key／value）保持一致。

```
const s1 = todo({}, {
  type: 'ADD_TODO',
  id: 1,
  text: "Finish blog post"
});

const s2 = todo(s1, {
  type: 'TOGGLE_TODO',
  id: 1
});

function render(state) {
  return state.id + ": " + state.text;
}

render(s1);
render(s2);
render(s1);
render(s2);
```

表面上来看， `render` 中访问属性应该是单态的，比如说 `state` 对象应该有相同的对象形状- [map 或者 V8 概念中的 hidden class 形式](https://github.com/v8/v8/wiki/Design%20Elements#fast-property-access) — 不管什么时候， `s1` 和 `s2` 都拥有 `id`, `text` 和 `completed` 属性并且它们有序。然而，当通过 `d8` 运行这段代码并跟踪代码的 ``ICs`` (内联缓存) 时，我们发现那个 `render` 表现出来的对象形状不相同， `state.id` 和 `state.text` 的获取变成了多态形式：

![](https://cdn-images-1.medium.com/max/800/1*FrfEaOkxshIj79wJDQyrIQ.png)

那么问题来了，这个多态是从哪里来的？它确实表面看上去一致但其实有微小差异，我们得从 V8 是如何处理对象字面量着手分析。V8 里，每个对象字面量 (比如  `{a:va,...,z:vb}` 形式的表达形式 ) 定义了一个初始的`` map`` （map 在 V8 概念中特指对象的形状）这个 ``map`` 会在之后属性变动时迁移成其他形式的 ``map``。所以，如果你使用一个空对象字面量  {}  时，这棵迁移树（transition tree）的根是一个不包含任何属性的 ``map``，但如果你使用  `{id:id, text:text, completed:completed}` 形式的对象字面量，那么这个迁移树（transition tree）的根就会是一个包含这三个属性，让我们来看一个精简过的例子：

```
let a = {x:1, y:2, z:3};

let b = {};
b.x = 1;
b.y = 2;
b.z = 3;

console.log("a is", a);
console.log("b is", b);
console.log("a and b have same map:", %HaveSameMap(a, b));
```

你可以在 ``Node.js`` 运行命令后面加上 `--allow-natives-syntax` 跑这段代码（开启即可应用内部方法 `%HaveSameMap`），举个例子：

![](https://cdn-images-1.medium.com/max/800/1*yzSaH_AE5z7r9PWBXlvwWg.png)

尽管 `a` and `b` 这两个对象看上去是一样的 —— 依次拥有相同类型的属性，它们 map 结构并不一样。原因是它们的迁移树（transition tree）并不相同，我们可以看以下的示例来解释：

![](https://cdn-images-1.medium.com/max/800/1*fkbEgBWk74icFH1yZIH7Lw.png)

所以当对象初始化期间被分配不同的对象字面量时，迁移树（transition tree）就不同，``map`` 也就不同，多态就隐含的形成了。这一结论对大家普遍用的 `Object.assign`也适用，比如：

```
let a = {x:1, y:2, z:3};

let b = Object.assign({}, a);

console.log("a is", a);
console.log("b is", b);
console.log("a and b have same map:", %HaveSameMap(a, b));
```

这段代码还是产生了不同的 ``map`` ，因为对象  `b` 是从一个空对象( `{}` 字面量) 创建的，而属性是等到`Object.assign` 才给他分配。

![](https://cdn-images-1.medium.com/max/800/1*Xu-nIj21gj-GlHDkzsSOSA.png)

这也表明，当你使用  ``spread`` （拓展运算符）处理属性，并且通过 Babel 来语法转译，就会遇到这个多态的问题。因为 Babel （其他转译器可能也一样）, 对 ``spread`` 语法使用了 `Object.assign` 处理。

![](https://cdn-images-1.medium.com/max/800/1*F2x8lRcZ83pQDvftelFOgA.png)

有一种方法可以避免这个问题，就是始终使用 `Object.assign` ，并且所有对象从一个空的对象字面量开始。但是这也会导致这个状态管理逻辑存在性能瓶颈：

```
let a = Object.assign({}, {x:1, y:2, z:3});

let b = Object.assign({}, a);

console.log("a is", a);
console.log("b is", b);
console.log("a and b have same map:", %HaveSameMap(a, b));
```

不过，当一些代码变成多态也不意味着一切完了。对大部分代码而言，单态还是多态并没啥关系。你应该在决定优化时多思考优化的价值。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
