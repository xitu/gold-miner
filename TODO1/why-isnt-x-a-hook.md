> * 原文地址：[Why Isn’t X a Hook?](https://overreacted.io/why-isnt-x-a-hook/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-isnt-x-a-hook.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-isnt-x-a-hook.md)
> * 译者：
> * 校对者：

# Why Isn’t X a Hook?

> Translated by readers into: [Español](https://overreacted.io/es/why-isnt-x-a-hook/)

Since the first alpha version of [React Hooks](https://reactjs.org/hooks) was released, there is a question that keeps coming up in discussions: “Why isn’t *\<some other API\>* a Hook?”

To remind you, here’s a few things that *are* Hooks:

* [`useState()`](https://reactjs.org/docs/hooks-reference.html#usestate) lets you declare a state variable.
* [`useEffect()`](https://reactjs.org/docs/hooks-reference.html#useeffect) lets you declare a side effect.
* [`useContext()`](https://reactjs.org/docs/hooks-reference.html#usecontext) lets you read some context.

But there are some other APIs, like `React.memo()` and `<Context.Provider>`, that are *not* Hooks. Commonly proposed Hook versions of them would be *noncompositional* or *antimodular*. This article will help you understand why.

**Note: this post is a deep dive for folks who are interested in API discussions. You don’t need to think about any of this to be productive with React!**

---

There are two important properties that we want React APIs to preserve:

1. **Composition:** [Custom Hooks](https://reactjs.org/docs/hooks-custom.html) are largely the reason we’re excited about the Hooks API. We expect people to build their own Hooks very often, and we need to make sure Hooks written by different people [don't conflict](/why-do-hooks-rely-on-call-order/#flaw-4-the-diamond-problem). (Aren’t we all spoiled by how components compose cleanly and don’t break each other?)

2. **Debugging:** We want the bugs to be [easy to find](/the-bug-o-notation/) as the application grows. One of React's best features is that if you see something wrong rendered, you can walk up the tree until you find which component's prop or state caused the mistake.

These two constraints put together can tell us what can or *cannot* be a Hook. Let’s try a few examples.

---

##  A Real Hook: `useState()`

### Composition

Multiple custom Hooks each calling `useState()` don’t conflict:

```js
function useMyCustomHook1() {
  const [value, setValue] = useState(0);
  // What happens here, stays here.
}

function useMyCustomHook2() {
  const [value, setValue] = useState(0);
  // What happens here, stays here.
}

function MyComponent() {
  useMyCustomHook1();
  useMyCustomHook2();
  // ...
}
```

Adding a new unconditional `useState()` call is always safe. You don’t need to know anything about other Hooks used by a component to declare a new state variable. You also can’t break other state variables by updating one of them.

**Verdict:** ✅ `useState()` doesn’t make custom Hooks fragile.

### Debugging

Hooks are useful because you can pass values *between* Hooks:

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

But what if we make a mistake? What’s the debugging story?

Let's say the CSS class we get from `theme.comment` is wrong. How would we debug this? We can set a breakpoint or a few logs in the body of our component.

Maybe we’d see that `theme` is wrong but `width` and `isMobile` are correct. That would tell us the problem is inside `useTheme()`. Or perhaps we'd see that `width` itself is wrong. That would tell us to look into `useWindowWidth()`.

**A single look at the intermediate values tells us which of the Hooks at the top level contains the bug.** We don't need to look at *all* of their implementations.

Then we can “zoom in” on the one that has a bug, and repeat.

This becomes more important if the depth of custom Hook nesting increases. Imagine we have 3 levels of custom Hook nesting, each level using 3 different custom Hooks inside. The [difference](/the-bug-o-notation/) between looking for a bug in **3 places** versus potentially checking **3 + 3×3 + 3×3×3 = 39 places** is enormous. Luckily, `useState()` can't magically “influence” other Hooks or components. A buggy value returned by it leaves a trail behind it, just like any variable. 🐛

**Verdict:** ✅ `useState()` doesn’t obscure the cause-effect relationship in our code. We can follow the breadcrumbs directly to the bug.

---

## Not a Hook: `useBailout()`

As an optimization, components using Hooks can bail out of re-rendering.

One way to do it is to put a [`React.memo()`](https://reactjs.org/blog/2018/10/23/react-v-16-6.html#reactmemo) wrapper around the whole component. It bails out of re-rendering if props are shallowly equal to what we had during the last render. This makes it similar to `PureComponent` in classes.

`React.memo()` takes a component and returns a component:

```js{4}
function Button(props) {
  // ...
}
export default React.memo(Button);
```

**But why isn’t it just a Hook?**

Whether you call it `useShouldComponentUpdate()`, `usePure()`, `useSkipRender()`, or `useBailout()`, the proposal tends to look something like this:

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

There are a few more variations (e.g. a simple `usePure()` marker) but in broad strokes they have the same flaws.

### Composition

Let’s say we try to put `useBailout()` in two custom Hooks:

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

Now what happens if you use them both in the same component?


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

When does it re-render?

If every `useBailout()` call has the power to skip an update, then updates from `useWindowWidth()` would be blocked by `useFriendStatus()`, and vice versa. **These Hooks would break each other.**

However, if `useBailout()` was only respected when *all* calls to it inside a single component “agree” to block an update, our `ChatThread` would fail to update on changes to the `isTyping` prop.

Even worse, with these semantics **any newly added Hooks to `ChatThread` would break if they don’t *also* call `useBailout()`**. Otherwise, they can’t “vote against” the bailout inside `useWindowWidth()` and `useFriendStatus()`.

**Verdict:** 🔴 `useBailout()` breaks composition. Adding it to a Hook breaks state updates in other Hooks. We want the APIs to be [antifragile](/optimized-for-change/), and this behavior is pretty much the opposite.

### Debugging

How does a Hook like `useBailout()` affect debugging?

We’ll use the same example:

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

Let’s say the `Typing...` label doesn’t appear when we expect, even though somewhere many layers above the prop is changing. How do we debug it?

**Normally, in React you can confidently answer this question by looking *up*.** If `ChatThread` doesn’t get a new `isTyping` value, we can open the component that renders `<ChatThread isTyping={myVar} />` and check `myVar`, and so on. At one of these levels, we’ll either find a buggy `shouldComponentUpdate()` bailout, or an incorrect `isTyping` value being passed down. One look at each component in the chain is usually enough to locate the source of the problem.

However, if this `useBailout()` Hook was real, you would never know the reason an update was skipped until you checked *every single custom Hook* (deeply) used by our `ChatThread` and components in its owner chain. Since every parent component can *also* use custom Hooks, this [scales](/the-bug-o-notation/) terribly.

It’s like if you were looking for a screwdriver in a chest of drawers, and each drawer contained a bunch of smaller chests of drawers, and you don’t know how deep the rabbit hole goes.

**Verdict:** 🔴 Not only `useBailout()` Hook breaks composition, but it also vastly increases the number of debugging steps and cognitive load for finding a buggy bailout — in some cases, exponentially.

---

We just looked at one real Hook, `useState()`, and a common suggestion that is intentionally *not* a Hook — `useBailout()`. We compared them through the prism of Composition and Debugging, and discussed why one of them works and the other one doesn’t.

While there is no “Hook version” of `memo()` or `shouldComponentUpdate()`, React *does* provide a Hook called [`useMemo()`](https://reactjs.org/docs/hooks-reference.html#usememo). It serves a similar purpose, but its semantics are different enough to not run into the pitfalls described above.

`useBailout()` is just one example of something that doesn’t work well as a Hook. But there are a few others — for example, `useProvider()`, `useCatch()`, or `useSuspense()`.

Can you see why?

*(Whispers: Composition... Debugging...)*

[Discuss on Twitter](https://mobile.twitter.com/search?q=https%3A%2F%2Foverreacted.io%2Fwhy-isnt-x-a-hook%2F) • [Edit on GitHub](https://github.com/gaearon/overreacted.io/edit/master/src/pages/why-isnt-x-a-hook/index.md)


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
