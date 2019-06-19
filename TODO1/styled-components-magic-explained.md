> * 原文地址：[The magic behind 💅 styled-components](https://mxstbr.blog/2016/11/styled-components-magic-explained/)
> * 原文作者：[https://mxstbr.blog](https://mxstbr.blog)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/styled-components-magic-explained.md](https://github.com/xitu/gold-miner/blob/master/TODO1/styled-components-magic-explained.md)
> * 译者：[WangLeto](https://github.com/WangLeto)
> * 校对者：[kezhenxu94](https://github.com/kezhenxu94)，[ziyin feng](https://github.com/Fengziyin1234)

# 💅 styled-components 背后的魔法

如果你不曾了解 [`styled-components`](https://styled-components.com)，下面是 styled component 中定义 React 组件的形式：

```javascript
const Button = styled.button`
  background-color: papayawhip;
  border-radius: 3px;
  color: palevioletred;
`
```

你可以用 `Button` 变量来渲染组件，就如同其他任何 React 组件一样。

```javascript
<Button>Hi Dad!</Button>
```

所以原理是什么？你觉得是哪种 webpack、babel 之类的神奇转译器能做到这样？

## 标签模板字符串（Tagged Template Literals）

实际上，`styled.button`` ` 这种古怪的声明，是 JavaScript 语法的一部分！这是一种叫做“标签模板字符串”的特性，在 ES6 中引入。

本质上来说，调用函数 `styled.button()` 和使用 `styled.button`` ` 几乎是一回事！但是当你传入参数时就会看到不同之处了。

我们先创建一个简单的函数用于探索：

```javascript
const logArgs = (...args) => console.log(...args)
```

这个函数会输出调用时传入的参数，别的什么都不做。

> 你可以在（任何现代浏览器）控制台中，粘贴上面的函数，然后执行接下来的代码，来跟随我的分析。

一个简单的使用例子：

```javascript
logArgs('a', 'b')
// -> a b
```

> `->` 在本文中表示输出内容

现在，试着用标签模板字符串来调用它：

```javascript
logArgs``
// -> [""]
```

只打印出来一个数组，里面有且仅有一个空字符串。有趣！当传入一个简单的字符串进去又会发生什么呢？

```javascript
logArgs`I like pizza`
// -> ["I like pizza"]
```

好吧，所以这个数组的第一个元素正是传入的字符串，不管里面是什么内容。那为什么还要搞个数组出来呢？

### 插值

模板字符串可以进行**插值**，类似于：`` `I like ${favoriteFood}` ``。让我们将一个模板字符串作为参数，使用小括号调用 `logArgs`：

```javascript
const favoriteFood = 'pizza'

logArgs(`I like ${favoriteFood}.`)
// -> I like pizza.
```

如你所见，JavaScript 继续运行，将插入字符串的值放入字符串，然后传递给了函数。那么我们直接使用模板字符串来调用 `logArgs` 呢？

```javascript
const favoriteFood = 'pizza'

logArgs`I like ${favoriteFood}.`
// -> ["I like ", "."] "pizza"
```

开始有趣起来了：可以看到，我们不再仅仅是得到了一个内容为 `"I like pizza"` 的字符串（像我们使用小括号调用的时候）。

传入参数的第一位仍然是数组，不过现在有了 2 个元素：位于插值左侧的 `I like`，作为数组第一个元素；位于插值的右侧的 `.`，是数组第二个元素。插值内容 `favoriteFoor` 成为了第二个传入参数。

![](https://mxstbr.blog/img/logargs-explanation.png)

可以看到，差别在于当我们使用标签模板字符串调用 `logArgs` 时，模板字符串被分解了，首先是原始文字组成的数组，然后是插值。

如果我们插入不止一个变量呢，你能猜到吗？

```javascript
const favoriteFood = 'pizza'
const favoriteDrink = 'obi'

logArgs`I like ${favoriteFood} and ${favoriteDrink}.`
// -> ["I like ", " and ", "."] "pizza" "obi"
```

每个插入的变量，都成为了调用函数传入的下个参数。你尽可以插入新的变量，会一直向后继续！

与通常调用函数的方法比较一下：

```javascript
const favoriteFood = 'pizza'
const favoriteDrink = 'obi'

logArgs(`I like ${favoriteFood} and ${favoriteDrink}.`)
// -> I like pizza and obi.
```

我们仅仅得到了一个长字符串，所有东西都揉在一起了。

## 为什么这很有用?

哎呦不错哦，这样我们就能用用重音符（`` ` ``）调用函数了，而且传参也别具一格，哇哦 —— 不过这又有什么了不起的？

好吧，事实证明可以用它进行一些很酷的探索。我们将 [`styled-components`](https://styled-components.com) 作为案例，分析一下。

对于 React 组件，你希望使用 props 值调整他们的样式。比如我们通过传入一个 `primary` 的 prop 值，让 `<Button />` 组件变大一些，像这样：`<Button primary />`。

当你使用 `styled-components` 传入一个插值函数，我们其实就向组件传入了一个 `props`，使用它就可以进行组件样式调整。

```javascript
const Button = styled.button`
  font-size: ${props => props.primary ? '2em' : '1em'};
`
```

现在如果 `Button` 是个基本按钮（primary），就有 2em 大小的字体，否则为 1em。

```javascript
// font-size: 2em;
<Button primary />

// font-size: 1em;
<Button />
```

回头看一眼 `logArgs` 函数。我们尝试使用插值函数调用它，就像上面 `styled.button` 一样，只不过我们没有使用插值模板字符串。我们传入什么呢？

```javascript
logArgs(`Test ${() => console.log('test')}`)
// -> Test () => console.log('test')
```

函数被 `toString` 转化了，`logArgs` 获取到一个字符串，看上去就是：`"Test () => console.log('test')"`。（**注意现在只是一个字符串，不是真的函数**）

比较一下直接使用插值模板字符串调用：

```javascript
logArgs`Test ${() => console.log('test')}`
// -> ["Test", ""] () => console.log('test')
```

我知道上面的文字现在还是不明显，但是我们拿到的第二个传入参数确实是个函数了！（不仅是函数声明时的字符串）在你的控制台多试几次，仔细观察，来更好地感受它。

这表示我们现在能够拿到函数了，也能直接运行它！为了深入测试，让我们来创建一个稍有不同的函数，它可以执行所有传入参数中的函数：

```javascript
const execFuncArgs = (...args) => args.forEach(arg => {
  if (typeof arg === 'function') {
    arg()
  }
})
```

当调用这个函数时，它会忽略所有不是函数的参数，但是如果传入参数是函数，它就会执行这个函数：

```javascript
execFuncArgs('a', 'b')
// -> undefined

execFuncArgs(() => { console.log('this is a function') })
// -> "this is a function"

execFuncArgs('a', () => { console.log('another one') })
// -> "another one"
```

让我们试着用小括号包裹着模板字符串来再调用一次：

```javascript
execFuncArgs(`Hi, ${() => { console.log('Executed!') }}`)
// -> undefined
```

什么都没发生，因为 `execFuncArgs` 没有被传入函数。它不过得到了一个字符串：`"Hi, () => { console.log('I got executed!') }"`。

现在看一下，当我们使用标签模板字符串调用函数会发生什么：

```javascript
execFuncArgs`Hi, ${() => { console.log('Executed!') }}`
// -> "Executed!"
```

与之前相比，`execFuncArgs` 获得的第二个参数是一个**真正的函数**，并且执行了它。

`styled-components` 底层就是这么做的！在渲染时，我们向所有插值函数中传入 props，以便用户可以基于 props 修改样式。

标签模板字符串使得 `styled-components` API 得以实现，没有这个特性 `styled-compnents` 就不可能出现。期待大家能以不同的方式利用标签模板字符串！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
