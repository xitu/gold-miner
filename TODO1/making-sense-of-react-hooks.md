> * 原文地址：[Making Sense of React Hooks](https://medium.com/@dan_abramov/making-sense-of-react-hooks-fdbde8803889)
> * 原文作者：[Dan Abramov](https://medium.com/@dan_abramov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-sense-of-react-hooks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-sense-of-react-hooks.md)
> * 译者：
> * 校对者：

# Making Sense of React Hooks

This week, [Sophie Alpert](https://mobile.twitter.com/sophiebits) and I presented the “Hooks” proposal at React Conf, followed by a deep dive from [Ryan Florence](https://mobile.twitter.com/ryanflorence):

* YouTube 视频链接：https://youtu.be/dpw9EHDh2bM

I strongly recommend to watch this opening keynote to see the problems we’re trying to solve with the Hooks proposal. However, even an hour is a big time investment, so I decided to share a few thoughts on Hooks below.

> **Note: Hooks are an experimental proposal to React. You don’t need to learn about them right now. Also, note that this post contains my personal opinions and doesn’t necessarily reflect the positions of the React team.**

### Why Hooks?

We know that components and top-down data flow help us organize a large UI into small, independent, reusable pieces. **However, we often can’t break complex components down any further because the logic is stateful and can’t be extracted to a function or another component.** Sometimes that’s what people mean when they say React doesn’t let them “separate concerns.”

These cases are very common and include animations, form handling, connecting to external data sources, and many other things we want to do from our components. When we try to solve these use cases with components alone, we usually end up with:

*   **Huge components** that are hard to refactor and test.
*   **Duplicated logic** between different components and lifecycle methods.
*   **Complex patterns** like render props and higher-order components.

We think Hooks are our best shot at solving all of these problems. **Hooks let us organize the logic _inside_ a component into reusable isolated units:**

![](https://i.loli.net/2018/10/31/5bd98faa90275.png)

**Hooks apply the React philosophy (explicit data flow and composition) _inside_ a component, rather than just _between_ the components.** That’s why I feel that Hooks are a natural fit for the React component model.

Unlike patterns like render props or higher-order components, Hooks don’t introduce unnecessary nesting into your component tree. They also don’t suffer from the [drawbacks of mixins](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html#why-mixins-are-broken).

Even if you have a visceral first reaction (as I did at first!), I encourage you to give this proposal a fair try and play with it. I think you’ll like it.

### Do Hooks Make React Bloated?

Before we look at Hooks in detail, you might be worried that we’re just adding more concepts to React with Hooks. That’s a fair criticism. I think that while there is definitely going to be a short-term cognitive cost to learning them, the end result will be the opposite.

**If the React community embraces the Hooks proposal, it will _reduce_ the number of concepts you need to juggle when writing React applications.** Hooks let you always use functions instead of having to constantly switch between functions, classes, higher-order components, and render props.

In terms of the implementation size, the Hooks support increases React only by ~1.5kB (min+gzip). While this isn’t much, it’s also likely that **adopting Hooks could _reduce_ your bundle size** because code using Hooks tends to minify better than equivalent code using classes. This example below is a bit extreme but it effectively demonstrates why (click to see the whole thread):

![](https://i.loli.net/2018/10/31/5bd98fde2d939.png)

**The Hooks proposal doesn’t include any breaking changes.** Your existing code would keep on working even if you adopted Hooks in the newly written components. In fact, that’s exactly what we recommend — don’t do any big rewrites! It’s a good idea to wait with adopting Hooks in any critical code. Still, we’d appreciate if you could experiment with the 16.7 alpha to provide us with feedback on the [Hooks proposal](https://github.com/reactjs/rfcs/pull/68) and [report any bugs](https://github.com/facebook/react/issues/new).

### What Are Hooks, Exactly?

To understand Hooks, we need to take a step back and think about code reuse.

Today, there are a lot of ways to reuse logic in React apps. We can write simple functions and call them to calculate something. We can also write components (which themselves could be functions or classes). Components are more powerful, but they have to render some UI. This makes them inconvenient for sharing non-visual logic. This is how we end up with complex patterns like render props and higher-order components. **Wouldn’t React be simpler if there was just _one_ common way to reuse code instead of so many?**

Functions seem to be a perfect mechanism for code reuse. Moving logic between functions takes the least amount of effort. However, functions can’t have local React state inside them. You can’t extract behavior like “watch window size and update the state” or “animate a value over time” from a class component without restructuring your code or introducing an abstraction like Observables. Both approaches hurt the simplicity that we like about React.

Hooks solve exactly that problem. Hooks let you use React features (like state) from a function — by doing a single function call. React provides a few built-in Hooks exposing the “building blocks” of React: state, lifecycle, and context.

**Since Hooks are regular JavaScript functions, you can combine built-in Hooks provided by React into your own “custom Hooks”.** This lets you turn complex problems into one-liners and share them across your application or with the React community:

![](https://i.loli.net/2018/10/31/5bd990044fa52.png)

Note that custom Hooks are not technically a React feature. The possibility of writing your own Hooks naturally follows from the way Hooks are designed.

### Show Me Some Code!

Let’s say we want to subscribe a component to the current window width (for example, to display different content on a narrow viewport).

There are several ways you can write this kind of code today. They involve writing a class, setting up some lifecycle methods, or maybe even extracting a render prop or a higher-order component if you want to reuse it between components. But I think nothing quite beats this:

![](https://cdn-images-1.medium.com/max/800/1*j8U3U0nZvmEKJrSOK7iH5g.png)

**If you read this code, it does exactly what it says.** We _use the window width_ in our component, and React re-renders our component if it changes.  And that’s the goal of Hooks — to make components truly declarative even if they contain state and side effects.

Let’s look at how we could implement this custom Hook. We’d _use the React local state_ to keep the current window width, and _use a side effect_ to set that state when the window resizes:

![](https://cdn-images-1.medium.com/max/800/1*9QhpwSGTKM-c8sc4UNcxqA.png)

As you can see above, the built-in React Hooks like _useState_ and _useEffect_ serve as the basic building blocks. We can use them from our components directly, or we can combine them into custom Hooks like _useWindowWidth_. Using custom Hooks feels as idiomatic as using React’s built-in API.

You can learn more about built-in Hooks from [this overview](https://reactjs.org/docs/hooks-overview.html).

**Hooks are fully encapsulated — each time you call a Hook, it gets isolated local state within the currently executing component.** This doesn’t matter for this particular example (window width is the same for all components!), but it’s what makes Hooks so powerful. They’re not a way to share _state_ — but a way to share _stateful logic_. We don’t want to break the top-down data flow!

Each Hook may contain some local state and side effects. You can pass data between multiple Hooks just like you normally do between functions. They can take arguments and return values because they _are_ JavaScript functions.

Here’s an example of a React animation library experimenting with Hooks:

![](https://i.loli.net/2018/10/31/5bd9904fc600f.png)

[Edit on CodeSandbox](https://codesandbox.io/s/ppxnl191zx?from-embed)

Note how in the demo source code, the staggering animation is implemented by passing values through several custom Hooks in the same render function.

![](https://cdn-images-1.medium.com/max/800/1*NJ2G1R_32k95WiPel5JHpg.png)

(If you want to learn more about this example, check out [this tutorial](https://medium.com/@drcmda/hooks-in-react-spring-a-tutorial-c6c436ad7ee4).)

The ability to pass data between Hooks make them a great fit for expressing animations, data subscriptions, form management, and other stateful abstractions. **Unlike render props or higher-order components, Hooks don’t create a “false hierarchy” in your render tree.** They’re more like a flat list of “memory cells” attached to a component. No extra layers.

### So What About Classes?

Custom Hooks are, in our opinion, the most appealing part of the Hooks proposal. But in order for custom Hooks to work, React needs to provide functions with a way to declare state and side effects. And that’s exactly what built-in Hooks like _useState_ and _useEffect_ let us do. You can learn about them in the [documentation](https://reactjs.org/docs/hooks-overview.html).

It turns out that these built-in Hooks aren’t _only_ useful for creating custom Hooks. They are _also_ sufficient for defining components in general, as they provide us with all the necessary features like state. This is why we’d like Hooks to become the primary way to define React components in the future.

We have no plans to deprecate classes. At Facebook we have tens of thousands of class components and, like you, we have no intention of rewriting them. But if the React community embraces Hooks, it doesn’t make sense to have two different recommended ways to write components. Hooks can cover all use cases for classes while providing more flexibility in extracting, testing, and reusing code. This is why Hooks represent our vision for the future of React.

### But Aren’t Hooks Magic?

You may have been surprised by the [Rules of Hooks](https://reactjs.org/docs/hooks-rules.html).

**While it’s unusual that Hooks have to be called at the top level, you probably wouldn’t want to define state in a condition even if you could.** For example, you can’t define state conditionally in a class either, and over four years of talking to React users I haven’t heard a complaint about this.

This design is crucial to enabling custom Hooks without introducing extra syntactic noise or other pitfalls. We recognize the initial unfamiliarity but we think this tradeoff is worth the features it enables. If you disagree, I encourage you to play with it in practice and see if that changes how you feel.

We’ve been using Hooks in production for a month to see whether engineers get confused by these rules. We found that in practice people get used to them in a matter of hours. Personally, I admit that these rules “felt wrong” to me at first too, but I quickly got over it. This experience mirrored my first impression with React. (Did you like React immediately? I didn’t until my second try.)

Note that there is no “magic” in the implementation of Hooks either. As Jamie [points out](https://mobile.twitter.com/jamiebuilds/status/1055538414538223616), it looks pretty similar to this:

![](https://cdn-images-1.medium.com/max/800/1*xNeUnpwUvFMuQu9Zr6A3AA.jpeg)

We keep a list of Hooks per component, and move to the next item in the list whenever a Hook is used. Thanks to the Rules of Hooks, their order is the same on every render, so we can provide the component with correct state for each call. Don’t forget that React doesn’t need to do anything special to know which component is rendering — React _is_ what’s calling your component.

Perhaps you’re wondering where React keeps the state for Hooks. The answer is it’s kept in the exact same place where React keeps state for classes. React has an internal update queue which is the source of truth for any state, no matter how you define your components.

Hooks don’t rely on Proxies or getters which can be common in modern JavaScript libraries. So arguably Hooks are _less_ magic than some popular approaches to similar problems. I’d say Hooks are about as much magic as calling _array.push_ and _array.pop_ (for which the call order matters too!)

The design of Hooks isn’t tied to React. In fact, during the first few days after the proposal was published, different people came up with experimental implementations of the same Hooks API for Vue, Web Components, and even plain JavaScript functions.

Finally, if you’re a functional programming purist and feel uneasy about React relying on mutable state as an implementation detail, you might find it satisfactory that handling Hooks could be implemented in a pure way using algebraic effects (if JavaScript supported them). And of course React has always relied on mutable state internally — precisely so that _you_ don’t have to.

Whether you were concerned from a more pragmatic or a dogmatic perspective (if you were at all), I hope that at least one of these justifications makes sense. Most importantly, I think Hooks let us build components with less effort, and create better user experiences. And that’s why I’m personally excited about Hooks.

### Spread Love, Not Hype

If Hooks still don’t seem compelling to you, I can totally understand it. I still hope that you’ll give them a try on a small pet project and see if that changes your opinion. Whether you haven’t experienced the problems Hooks solve, or if you have a different solution in mind, please let us know in the RFC!

If I _did_ get you excited, or at least a little bit curious, that’s great! I have just one favor to ask. There are many folks who are learning React right now, and they will get confused if we hurry with writing tutorials and declaring best practices for a feature that has barely been out for a few days. There are some things about Hooks that aren’t quite clear yet even to us on the React team.

**If you create any content about Hooks while they’re unstable, please mention prominently that they are an experimental proposal, and include a link to the** [**official documentation**](https://reactjs.org/hooks)**.** We’ll keep it up to date with any changes to the proposal. We’ve also spent quite a bit of effort to make it comprehensive, so many questions are already answered there.

When you talk to other people who aren’t as excited as you are, please be courteous. If you see a misconception, you can share extra information if the other person is open to it. But any change is scary, and as a community we should try our best to help people instead of alienating them. And if I (or anyone else on the React team) fail to follow this advice, please call us out!

### Next Steps

Check out the documentation for Hooks proposal to learn more about it:

*   [Introducing Hooks](https://reactjs.org/docs/hooks-intro.html) (motivation)
*   [Hooks at a Glance](https://reactjs.org/docs/hooks-overview.html) (walkthrough)
*   [Writing Custom Hooks](https://reactjs.org/docs/hooks-custom.html)
*   [Hooks FAQ](https://reactjs.org/docs/hooks-faq.html) (it’s likely your question is answered there!)

Hooks are still in an early stage, but we’re excited to hear feedback from all of you. You can direct it to the [RFC](https://github.com/reactjs/rfcs/pull/68), but we’ll also do our best to keep up with the conversations on Twitter.

Please let me know if something isn’t clear, and I’d be happy to chat about your concerns. Thank you for reading!

![](https://cdn-images-1.medium.com/max/800/1*_XMyHqfFSyw03BiNjBoV3Q.jpeg)

Vitra — Portemanteau Hang it all

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
