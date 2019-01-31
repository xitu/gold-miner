> * 原文地址：[Why Isn’t X a Hook?](https://overreacted.io/why-isnt-x-a-hook/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-isnt-x-a-hook.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-isnt-x-a-hook.md)
> * 译者：
> * 校对者：

# X为啥不是hook?

> Translated by readers into: [Español](https://overreacted.io/es/why-isnt-x-a-hook/)

自 [React Hooks](https://reactjs.org/hooks) 第一个 alpha 版本发布以来, 这个问题一直被激烈讨论: “为什么 *\< API \>* 不是 hook?”

提示你一下, 这些*是* Hooks:

* [`useState()`](https://reactjs.org/docs/hooks-reference.html#usestate) 用来定义一个可变的状态（state）.
* [`useEffect()`](https://reactjs.org/docs/hooks-reference.html#useeffect) 用来定义一个副作用.
* [`useContext()`](https://reactjs.org/docs/hooks-reference.html#usecontext) 用来读取一些上下文.

 但是像 `React.memo()` 和 `<Context.Provider>`，这些 API 它们 *不是* Hooks 。一般来说，这些 Hook 版本的 API 被认为是 *非组件化* 或 *反模块化*的. 这篇文章将帮助你理解其中的原理。

**注: 这篇文章是针对 API 爱好者所讨论的。你不必担心把 React 作为生产工具的使用**

---

以下两个重要的属性是我们希望 React 的 APIs 应该拥有的：

1. **可组合:** [Custom Hooks（自定义 Hooks）](https://reactjs.org/docs/hooks-custom.html)是我们觉得 Hooks 的 API 非常好用的部分. 我们希望开发者们经常使用自定义 hooks, 这样就需要确保不同开发者所写的hooks [不会冲突](/why-do-hooks-rely-on-call-order/#flaw-4-the-diamond-problem)。 (撰写干净并且不会相互冲突的组件实在太棒了)

2. **可调试:** 随着应用的膨胀，我们希望 bug 很[容易被发现](/the-bug-o-notation/) 。 React最棒的特性之一就是，当你发现某些渲染错误的时候，你可以顺着组件树寻找，直到找出是哪一个组件的 props 或 state 的值导致的错误。

把这两个约束作为指导，就可以告诉我们哪些是或*不是* 一个标准 Hook。 我们来一起看一些例子。

---

##  一个真正的 Hook: `useState()`

### 可组合

多个自定义 Hooks 各自调用 `useState()` 不会冲突：

```js
function useMyCustomHook1() {
  const [value, setValue] = useState(0);
  // 无论这里做了什么，它都只会作用在这里
}

function useMyCustomHook2() {
  const [value, setValue] = useState(0);
  // 无论这里做了什么，它都只会作用在这里
}

function MyComponent() {
  useMyCustomHook1();
  useMyCustomHook2();
  // ...
}
```

添加一个新的无条件的 `useState()` 总是安全的。你不需要了解任何其他用来声明新状态变量的 Hook。 你也不会因为更新了他们中的其中一个而导致破坏了其他的状态变量。

**结论:** ✅ `useState()` 不会使自定义 Hooks 变得脆弱.

### 可调试

Hooks 非常好用，因为你可以在 Hooks *之间*传值:

```js{4,12,14}
function useWindowWidth() {
  const [width, setWidth] = useState(window.innerWidth);
  // ...
  return width;
}

function useTheme(isMobile) {
  // ...
}

function Comment() {
  const width = useWindowWidth();
  const isMobile = width < MOBILE_VIEWPORT;
  const theme = useTheme(isMobile);
  return (
    <section className={theme.comment}>
      {/* ... */}
    </section>
  );
}
```

但是如果我们的代码出错了呢？我们又该怎么调试？

我们先假设，从 `theme.comment` 拿到的 CSS 的类是错的。我们该怎么调试? 我们可以打一个断点或者在我们的组件体内加一些log。

我们可能会发现 `theme` 是错的，但是 `width` 和 `isMobile` 是对的。这会提示我们问题出在 `useTheme()` 内部。 又或许我们发现 `width` 本身是错的。这可以指引我们去查看 `useWindowWidth()`。

**简单看一下中间值就能指导我们哪个顶层的 Hooks 有 bug。** 我们不需要挨个去查看他们*所有的*实现。

这样，我们就能 “放大” 查看有 bug 的部分，重复此操作。

如果我们的自定义 Hook 嵌套的层级加深的时候，这一点就显得很重要了。
假设一下我们有一个3级嵌套的自定义 Hook , 每一层级的内部又用了 3 个不同的自定义 Hooks 。在 **3 处**找bug和最多**3 + 3×3 + 3×3×3 = 39 处**找bug的[区别](/the-bug-o-notation/)是巨大的。幸运的是， `useState()` 不会魔法般的 “影响” 其他 Hooks 或组件。 当一个容易出 bug 的值被返回出来的时候，会在它后面留下长长的痕迹， 就像任何多变的🐛一样。

**结论:** ✅ `useState()` 不会使你的代码逻辑变得模糊不清，我们可以跟着面包屑寻找直接找到 bug 。

---

## 它不是一个Hook: `useBailout()`

作为一个优化点, 组件使用 Hooks 可以避免重复渲染（re-rendering）。

其中一个方法是使用 [`React.memo()`](https://reactjs.org/blog/2018/10/23/react-v-16-6.html#reactmemo) 包裹住整个组件。 如果 props 和上次渲染完之后对比浅相等，就可以避免重复渲染 。这和classes中的`PureComponent` 很像。

`React.memo()` 接受一个组件作为参数，并返回一个组件：

```js{4}
function Button(props) {
  // ...
}
export default React.memo(Button);
```

**但它为什么就不是 Hook?**

不论你叫它 `useShouldComponentUpdate()`, `usePure()`, `useSkipRender()`, 还是 `useBailout()`, 它看起来都差不多长这样：

```js
function Button({ color }) {
  // ⚠️ Not a real API
  useBailout(prevColor => prevColor !== color, color);

  return (
    <button className={'button-' + color}>  
      OK
    </button>
  )
}
```

还有一些其他的变种 (比如：一个简单的 `usePure()` ) 但是大体上来说，他们都有一些相同的缺陷。

### 可组合

我们来试试把 `useBailout()` 放在2个自定义 Hooks 中:

```js{4,5,19,20}
function useFriendStatus(friendID) {
  const [isOnline, setIsOnline] = useState(null);

  // ⚠️ Not a real API
  useBailout(prevIsOnline => prevIsOnline !== isOnline, isOnline);

  useEffect(() => {
    const handleStatusChange = status => setIsOnline(status.isOnline);
    ChatAPI.subscribe(friendID, handleStatusChange);
    return () => ChatAPI.unsubscribe(friendID, handleStatusChange);
  });

  return isOnline;
}

function useWindowWidth() {
  const [width, setWidth] = useState(window.innerWidth);
  
  // ⚠️ Not a real API
  useBailout(prevWidth => prevWidth !== width, width);

  useEffect(() => {
    const handleResize = () => setWidth(window.innerWidth);
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  });

  return width;
}
```

现在如果你在同一个组件中同时用到他们会怎么样呢？


```js{2,3}
function ChatThread({ friendID, isTyping }) {
  const width = useWindowWidth();
  const isOnline = useFriendStatus(friendID);
  return (
    <ChatLayout width={width}>
      <FriendStatus isOnline={isOnline} />
      {isTyping && 'Typing...'}
    </ChatLayout>
  );
}
```

什么时候会 re-render 呢?

如果每一个 `useBailout()` 的调用都有能力跳过这次更新， 那么来自 `useWindowWidth()` 的更新会被来自`useFriendStatus()`的更新阻塞， 反之亦然. **这些 Hooks 会相互阻塞。**

然而，如果 `useBailout()` 只在作用于  在一个组件的内部*所有的* calls to it  “agree” to block an update, 那么当prop中的`isTyping`改变的时候我们的 `ChatThread` 将不会更新。

更糟糕的是，如果这么定义的话 **任何新加在 `ChatThread` 中的 Hooks，如果他们不*重复*调用 `useBailout()`， 那么他们也会失效**。 否则，他们不会 “投反对票” the bailout inside `useWindowWidth()` and `useFriendStatus()`。

**结论:** 🔴 `useBailout()` 破坏了可组合性。添加一个 Hook 会破坏其他 Hooks 的状态更新。我们希望这些APIs 是[稳定的](/optimized-for-change/)，但是这个特性显然是与之相反了。

### 可调试

`useBailout()` 对调试有什么影响呢?

我们用相同的例子： 

```js
function ChatThread({ friendID, isTyping }) {
  const width = useWindowWidth();
  const isOnline = useFriendStatus(friendID);
  return (
    <ChatLayout width={width}>
      <FriendStatus isOnline={isOnline} />
      {isTyping && 'Typing...'}
    </ChatLayout>
  );
}
```

事实上即使 prop 上层的某处改变了，`Typing...` 这个标记也不会像我们期望的那样出现。 那么我们怎么调试呢？

**一般来说， 在 React 中你可以通过向*上*寻找的办法，自信的回答这个问题。** 如果 `ChatThread` 没有得到新的 `isTyping` 的值， 我们可以打开那个渲染`<ChatThread isTyping={myVar} />`的组件，检查 `myVar`，诸如此类。 在其中的某一层， 我们会发现要么是容易出错的 `shouldComponentUpdate()` 跳过了渲染, 要么是一个错误的 `isTyping`的值被传递了下来。通常来说查看这条链路上的每个组件，已经足够定位到问题的来源了。

然而, 假如这个 `useBailout()` 真是个 Hook，如果你不检查我们在`ChatThread`中用到的*每一个自定义 Hook* (深的) 和在各自链路上的所有组件，你永远都不会知道跳过这次更新的原因。  更因为任何父组件*也*可能会用到自定义 Hooks， 这个[规模](/the-bug-o-notation/) 很恐怖。

这就像你要在抽屉里找一把螺丝刀， 而每一层抽屉里都包含一堆小抽屉，这样的话你无法想象爱丽丝仙境中的兔子洞有多深。

**结论:** 🔴 `useBailout()` 不仅破坏了可组合性, 也极大的增加了调试的步骤和找 bug 过程的认知负担 — 某些时候，是指数级的。

---

我们回头来看看一个真正的 Hook，`useState()`， 和一个一般意义上来说*不是* Hook的 — `useBailout()`。 我们从可组合和可调试的这两个方面来对比他们，来讨论为什么其中一个可以工作，但是另一个不可以。

尽管现在没有 “Hook 版本的 `memo()` 或 `shouldComponentUpdate()`， 但 React *确实*提供了一个名叫[`useMemo()`](https://reactjs.org/docs/hooks-reference.html#usememo)的 Hook 。 它有类似的作用，但是他的语义足够让人们不陷入我们之前说的陷阱。

`useBailout()` 只是一个作为 Hook 不好用的例子。这里还有一些其他的例子 - 例如， `useProvider()`， `useCatch()`， `useSuspense()`.

现在你能明白为什么了吗

*(小声嘀咕: 可组合... 可调试...)*

[Discuss on Twitter](https://mobile.twitter.com/search?q=https%3A%2F%2Foverreacted.io%2Fwhy-isnt-x-a-hook%2F) • [Edit on GitHub](https://github.com/gaearon/overreacted.io/edit/master/src/pages/why-isnt-x-a-hook/index.md)


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
