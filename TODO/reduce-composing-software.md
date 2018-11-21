> * 原文地址：[Reduce (Composing Software)(part 5)](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[avocadowang](https://github.com/avocadowang) [Aladdin-ADD](https://github.com/Aladdin-ADD)

# [第五篇] Reduce（软件编写）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0) （译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。））

> 注意：这是 “软件编写” 系列文章的第五部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科 [Composability](https://en.wikipedia.org/wiki/Composability)）。后续还有更多精彩内容，敬请期待！
> > [<上一篇](https://github.com/xitu/gold-miner/blob/master/TODO/higher-order-functions-composing-software.md) | [<< 返回第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)

在函数式编程中，**reduce**（也称为：fold，accumulate）允许你在一个序列上迭代，并应用一个函数来处理预先声明的累积值和当前迭代到的元素。当迭代完成时，将返回这个累积值。许多其他有用的功能都可以通过 reduce 实现。多数时候，reduce 可以说是处理集合（collection）最优雅的方式。

reduce 接受一个 reducer 函数以及一个初始值，最终返回一个累积值。对于 `Array.prototype.reduce()` 来说， 初始列表将由 `this` 指明， 所以列表本身不会作为该函数的参数：

```
array.reduce(
  reducer: (accumulator: Any, current: Any) => Any,
  initialValue: Any
) => accumulator: Any
```

我们利用如下方式对一个数组进行求和:

```
[2, 4, 6].reduce((acc, n) => acc + n, 0); // 12
```

对于数组的每步迭代，reducer 函数都会被调用，并且向其传入了累积值和当前迭代到的数组元素。reducer 的职责在于以某种方式将当前迭代的元素 “合拢（fold）” 到累加值中。reducer 规定了 “合拢” 的手段和方式，完成了对当前元素的 “合拢” 后，reducer 将返回新的累加值，然后， `.reduce()` 将开始处理数组中的下一个元素。reducer 需要一个初始值才能开始工作，所以绝大多数的 `.reduce()` 实现都需要接收一个初始值作为参数。

在数组元素求和一例中，reducer 函数第一次调用时，`acc` 将会以 `0` 值（该值是传入 `.reduce()` 方法的第二个参数）开始。然后，reducer 返回了 `0` + `2`（`2` 是数组的第一个元素）， 也就是返回了 `2` 作为新的累积值。下一步，`acc = 2, n = 4` 传入了 reducer，reducer返回了 `2 + 4`（`6`）。在最后一步迭代中，`acc = 6, n = 6`, reducer 返回了 `12`。迭代完成，`.reduce（）` 返回了最终的累积值 `12`。

在这一例子中，我们传入了一个匿名函数作为 reducer，但是我们也可以抽象出每次求和的过程为一个具名函数，这使得我们代码的复用程度更高：

```
const summingReducer = (acc, n) => acc + n;
[2, 4, 6].reduce(summingReducer, 0); // 12
```

通常，`reduce` 的工作过程为由左向右。在 JavaScript 中，我们也有一个 `[].reduceRight()` （译注：[MDN -- Array.prototype.reduceRight()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/ReduceRight)）方法来让 reduce 由右向左地工作。 具体说来，如果你对数组 `[2, 4, 6]` 应用 `.reduceRight()` ，第一个被迭代到的元素就将是 `6`，最后一个迭代到的元素就是 `2`。

### 无所不能的 reduce ###

别吃惊，reduce 确实无所不能，你所熟悉的 `map()`，`filter()`，`forEach()` 以及其他函数都可借助于 reduce 来创建。

**Map:**

```
const map = (fn, arr) => arr.reduce((acc, item, index, arr) => {
  return acc.concat(fn(item, index, arr));
}, []);
```

对于 map 来说，我们的累积值就是一个新的数组对象，该数组对象中的每个元素都由原数组对应元素映射得到。累积数组中新的元素由传入 map 的映射函数（`fn`）所确定：对于当前迭代到的元素 `item`，我们通过 `fn` 计算出新的元素，并将其拼接入累加数组 `acc` 中。

**Filter:**

```
const filter = (fn, arr) => arr.reduce((newArr, item) => {
  return fn(item) ? newArr.concat([item]) : newArr;
}, []);
```

filter 的工作方式与 map 类似，只不过原数组的元素只有通过一个真值检测函数（predicate function）才能被送入新的累积数组中。亦即，相较于 map，filter 是**有条件**地选择元素到累积数组中，并且不会改变元素的值。

上面几个例子，你处理的数据都是一些数值序列，你在数值序列上应用指定的函数迭代数据，并将结果合拢到累积值中。大多数应用都因此开始雏形初备，但是你想过这个问题：**假如你的序列是函数序列呢？**

**Compose:**

reduce 也是实现函数组合的便捷渠道。假如你想用将函数 `g` 的输出作为函数 `f` 的输入，即组合这两个函数： `f . g`，那么你可以使用下面的 JavaScript 代码片，它没有任何的抽象：

```
f(g(x))
```

reduce 让我们能抽象出函数组合过程，从而让你也能轻易地实现更多层次的函数组合：

```
f(g(h(x)))
```

为了使函数组合是由右向左的，我们就要使用上面提到的 `.reduceRight()` 方法来抽象函数组合过程：

```
const compose = (...fns) => x => fns.reduceRight((v, f) => f(v), x);
```

> 注意：如果 JavaScript 的版本没有提供 `[].reduceRight()`，你可以借助于 `reduce` 实现该方法。该实现留给读者自己思考。

**Pipe:**

`compose()` 很好地描述了由内至外的组合过程，某种程度上，这是数学上的关于输入输出的组合。如果你想从事件发生顺序上来思考函数组合呢？

假设我们想要对一个数值加 `1`，然后对新得到的数值进行翻倍。如果是利用 `compose()`，就需要这么做：

```
const add1 = n => n + 1;
const double = n => n * 2;

const add1ThenDouble = compose(
  double,
  add1
);

add1ThenDouble(2); // 6
// ((2 + 1 = 3) * 2 = 6)
```

发现问题没有？第一步（加1操作）是 compose 序列上的最后一个元素，所以，`compose` 需要你自底向上地分析流程的执行。

我们使用 reduce 由左向右的常用特性取代由右向左的组合方式，以示区别，我们用 `pipe` 来描述新的组合方式：

```
const pipe = (...fns) => x => fns.reduce((v, f) => f(v), x);
```

现在，新的流程就可以这么撰写：

```
const add1ThenDouble = pipe(
  add1,
  double
);

add1ThenDouble(2); // 6
// ((2 + 1 = 3) * 2 = 6)
```

如你所见，在组合中，顺序是非常重要的，如果你调换了 `double` 和 `add1` 的顺序，你将得到截然不同的结果：

```
const doubleThenAdd1 = pipe(
  double,
  add1
);

doubleThenAdd1(2); // 5
```

之后，我们还会讨论跟多的关于 `compose()` 和 `pipe()` 的细节。现在，你所要知道的只是，`reduce()` 是一个极为强大的工具，因此一定要掌握它。 如果在学习过程中遇到了挫折，也大可不必灰心，很多开发者都花了大量时间才能掌握 reduce。

### Redux 中的 reduce ###

你可能听说过 “reducer” 这个术语被用于描述 [Redux](https://github.com/reactjs/redux) 的状态更新。这篇文章撰写之时，对于使用了 React 或者 Angular 进行构建的 web 应用来说，Redux 是最流行的状态管理库/架构（Angualar 中的类 Redux 管理是 ngrx/store ）。

Redux 使用了 reducer 函数来管理应用状态。一个 Redux 风格的 reducer 接收一个当前应用状态 `state` 和 和交互对象 `action` 作为参数（译注：当前状态就相当于累积值，而 action 就相当于目前处理的元素），处理完成后，返回一个新的应用状态：

```
reducer(state: Any, action: { type: String, payload: Any}) => newState: Any
```

Redux 的一些 reducer 规则需要你牢记在心：

1. 一个 reducer 如果进行了无参调用，它要返回它的初始状态。
2. 如果 reducer 操纵的 action 没有声明类型，他要返回当前状态。
3. 最最重要的是，Redux reducer 必须是纯函数。

现在，我们以 Redux 风格重写上面的求和 reducer，该 reducer 的行为将由 action 类型决定：

```
const ADD_VALUE = 'ADD_VALUE';

const summingReducer = (state = 0, action = {}) => {
  const { type, payload } = action;

  switch (type) {
    case ADD_VALUE:
      return state + payload.value;
    default: return state;
  }
};
```

关于 Redux 的一个非常美妙的事儿就是，其 reducer 都是标准的 reducer （译注：即接收 `accumulator` 和 `current` 两个参数的 reducer ），这意味着你将 Redux 中的 reducer 插入到任何现有的 `reduce()` 实现中去，比如最常用的 `[].reduce()`。以此为例，我们可以创建一个 action 对象的数组，并对其进行 reduce 操作，传入 `reduce()` 的将是我们定义好的 `summingReducer`，据此，我们获得一个状态快照。之后，一旦对 Redux 中的状态树（store）分派了同样的 action 序列，那么一定能俘获到相同的状态快照：

```
const actions = [
  { type: 'ADD_VALUE', payload: { value: 1 } },
  { type: 'ADD_VALUE', payload: { value: 1 } },
  { type: 'ADD_VALUE', payload: { value: 1 } },
];

actions.reduce(summingReducer, 0); // 3
```

这使得对 Redux 风格的 reducer 的单元测试变得极为容易。

### 总结 ###

现在，你应该可以瞥见 reduce 的强大甚至是无所不能了。虽然，理解 reduce 要比理解 map 或者 filter 难一些，还是函数式编程中重要的工具，这个工具强大在它是一个基础工具，能够通过它构建出更多更强大的工具。

[**下一篇: Functors 与 Categories  >**](https://github.com/xitu/gold-miner/blob/master/TODO/functors-categories.md)


### 接下来 ###

想学习更多 JavaScript 函数式编程吗？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">](https://ericelliottjs.com/product/lifetime-access-pass/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
