> * 原文地址：[setState() Gate](https://medium.com/javascript-scene/setstate-gate-abc10a9b2d82#.z148awo8n)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# setState() Gate #

## Navigating React setState() Behavior Confusion ## 

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YvimnE7n9gk2Oesw_Dmxhg.jpeg">

It all started last week. 3 different React learners encountered 3 different obstacles trying to use `setState()` in their projects. I mentor new React users a lot, and consult with teams making transitions from other architectures to React.

One of those learners was working on a production project that is a good fit for Redux, so instead of working out how to fix the timing with `setState()`, I recommended that we just replace `setState()` with Redux, which has the effect of removing the timing of state updates from the component drawing the DOM. Then the module simply has to decide what to render based on the props from the store, and the timing complexity is magically side-stepped.

That inspired this tweet:


[“React has a setState() problem: Asking newbies to use setState() is a recipe for headaches. Advanced users have learned to avoid it. ;)](https://twitter.com/_ericelliott)

After that, some advanced users chimed in to correct me:

[“React team member checking in. Please learn to use setState before other approaches.”](https://twitter.com/dan_abramov/status/842490428440150017?ref_src=twsrc%5Etfw)

[“Those ‘adanced’ users will get left behind when we turn on async scheduling by default in React 17”](https://twitter.com/acdlite/status/842499250822950912?ref_src=twsrc%5Etfw)

On that second point:

[“Fiber has a strategy for pausing, splitting, rebasing, aborting updates that doesn’t work if you deviate from component state”](https://twitter.com/acdlite/status/842506455232143360?ref_src=twsrc%5Etfw)

Both fair points. Other people made memes:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YvimnE7n9gk2Oesw_Dmxhg.jpeg">

It’s great to make fun of a frustrating situation, but let’s not pretend there’s no problem.

In my very next meeting with a different mentee, *he was also confused* about how `setState()` works, and had just given up and stuffed his state in a closure, which of course wouldn’t automatically trigger a render if the closure state changed.

Given the *constant influx* of confused React newbies, I stand by the first part of my tweet, but if I had it to do again, I’d change the second part *a little,* because some advanced users (notably, lots of Facebook and Netflix) use `setState()` extensively:

> “React has a setState() problem: Asking newbies to use setState() is a recipe for headaches. Advanced users have secret cures.”

Of course, Twitter would probably still lose its collective mind. After all, React is *perfect*, and we must all agree that `setState()` is beautiful just as it is, or face ridicule and scorn.

If `setState()` confuses you, it’s *your fault.* You must be crazy or stupid. (Have I mentioned that [the JavaScript community has a bullying problem?](https://medium.com/javascript-scene/the-js-community-has-a-bullying-problem-96c10f11c85d#.wagjqz54o) )

Let’s check our egos for a moment and stop patting ourselves on the back for our `setState()` mastery while we mock everybody who hasn’t learned the same lessons.

That behavior is absurd, elitist, and very uninviting to newcomers. If people frequently get confused about an API, it could be an opportunity to improve that API, or at least improve the documentation.

Making the community and our tools more friendly and inviting is good for everybody.

### What’s Wrong with setState()? ###

This question has two answers:

1. Not much. It (mostly) behaves like it needs to to solve the problem it’s designed to solve.
2. Learning curve. Users new to React and `setState()` frequently encounter obstacles while trying to do things that *just work* with vanilla JS and direct DOM manipulation.

React is designed to make it easier to build apps, but:

- You can’t just grab bits of DOM and update them any way you like.
- You can’t just set the state to anything at any time, depending on any data source you like.
- You can’t just observe the rendered DOM or element visibility on screen at any part of the component lifecycle, which limits when and how you can use `setState()` for render dependent state (the state you’re working on may not have been rendered to the screen, yet).

In all of these cases, the confusion is caused by the *(intentional, good)* limitations of the React component lifecycle.

#### Dependent State ####

When we’re updating state, sometimes the value of the update depends on things that React tries to help us with:

- The current state
- Previous attempts to update state in the same cycle
- The rendered DOM (e.g., component coordinates, visibility, calculated CSS values, etc…)

If you try to simply update the state in a straightforward way when you have these kinds of dependent state, React’s behavior might surprise you in an obnoxiously hard-to-debug way. Frequently, whatever you just tried to do simply doesn’t work. You’ll end up with incorrect state, or you’ll see an error in the console.

My gripe with `setState()` is that its restrictive behavior is not made obvious to newcomers in the API documentation, and common patterns for dealing with its restrictive behavior are not well explained. This forces users to resort to trial and error, Google, and help from other community members, when there could be better guide-posts built into `setState()` and it’s API documentation.

The current API documentation for `setState()` leads with this:

```
setState(nextState, callback)
```

> Performs a shallow merge of nextState into current state. This is the primary method you use to trigger UI updates from event handlers and server request callbacks.

It does make very brief mention at the end that it has async behavior:

> There is no guarantee of synchronous operation of calls to `setState` and calls may be batched for performance gains.

The consequence of both of those things together is the root of many userland bugs:

```
// assuming state.count === 0
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
// state.count === 1, not 3
```

It’s essentially equivalent to:

```
Object.assign(state,
  {count: state.count + 1},
  {count: state.count + 1},
  {count: state.count + 1}
); // {count: 1}
```

This is not mentioned explicitly in the API docs (it is covered elsewhere in a special guide).

The API docs also makes mention of a function alternative to the `setState()` signature:

> It’s also possible to pass a function with the signature `function(state, props) => newState`. This enqueues an atomic update that consults the previous value of state and props before setting any values.

> `...`

> `setState()` does not immediately mutate `this.state` but creates a pending state transition. Accessing `this.state` after calling this method can potentially return the existing value.

The API docs are dropping some breadcrumbs, but they don’t really explain the behavior that newbies frequently encounter in a way that clearly guides the reader on the right path, and though React is famous for generating useful errors in dev mode, no such warnings get logged when `setState()` timing bugs crop up.

[![](https://ww2.sinaimg.cn/large/006tNc79gy1fdwma23qp0j30jk077mxt.jpg)](https://twitter.com/JikkuJose/status/842915627899670528?ref_src=twsrc%5Etfw) 

[![](https://ww3.sinaimg.cn/large/006tNc79gy1fdwmac1hwlj30ji06rq3h.jpg)](https://twitter.com/PierB/status/842590294776451072?ref_src=twsrc%5Etfw)

Lifecycle timing issues account for a lot of the questions asked about `setState()` on StackOverflow. Of course, React is very popular, so those questions have been [asked](http://stackoverflow.com/questions/25996891/react-js-understanding-setstate)[many](http://stackoverflow.com/questions/35248748/calling-setstate-in-a-loop-only-updates-state-1-time) [times](http://stackoverflow.com/questions/30338577/reactjs-concurrent-setstate-race-condition/30341560#30341560), with answers of various quality and correctness.

So how can newbies learn the right way to manage `setState()` timing issues?

There is more in-depth information in a separate guide in the React docs called [“State and Lifecycle”](https://facebook.github.io/react/docs/state-and-lifecycle.html) :

> “…To fix it, use a second form of `setState()` that accepts a function rather than an object. That function will receive the previous state as the first argument, and the props at the time the update is applied as the second argument:”

```
// Correct
this.setState((prevState, props) => ({
  count: prevState.count + props.increment
}));
```

This function-parameter form (sometimes called “functional `setState()`”) works more like this:

```
[
  {increment: 1},
  {increment: 1},
  {increment: 1}
].reduce((prevState, props) => ({
  count: prevState.count + props.increment
}), {count: 0}); // {count: 3}
```

Not sure how reduce works? See [“Reduce”](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d#.8d8kw0l40)  from [“Composing Software”](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c#.7k9w6v9ok) .

The key is the **updater function**:

```
(prevState, props) => ({
  count: prevState.count + props.increment
})
```

This is basically a reducer, where `prevState` acts like an accumulator, and `props` acts as the source for the new update data. Like reducers from Redux, you can reduce with this function using any standard reduce utility (including `Array.prototype.reduce()`). Also like Redux, the reducer should be a [pure function](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976) .

> Note: Trying to directly mutate `prevState` is a common source of confusion among new users.

These properties and expectations of the updater function are not mentioned in the API documentation, so the rare, lucky newbie who chances across the fact that the functional `setState()` form does something useful that isn’t supported by the object literal form is probably still going to be confused.

### Just A Newbie Problem? ###

I still bump into rough edges now and then when I’m dealing with forms or DOM element coordinates because, when you use `setState()`, you have to deal with the component lifecycle directly. When you use a container component or store and pass your state through props, React handles the timing issues for you.

Shared mutable state and state locks can be painful to navigate [*regardless of your experience level*](https://medium.com/@mweststrate/3-reasons-why-i-stopped-using-react-setstate-ab73fc67a42e#.saj7jn6wh) *.* Experienced users are just better at identifying the problem quickly and jumping to a handy workaround.

Since newbies haven’t seen the problem before, and aren’t aware of workarounds, it just happens to hit them hardest.

[](https://twitter.com/_ericelliott/status/842546271944564737?ref_src=twsrc%5Etfw) 

[](https://twitter.com/dan_abramov/status/842548605525331969?ref_src=twsrc%5Etfw) 

You can fight with React over when things happen, or you can let React do its thing and go with the flow. That’s what I mean when I say that Redux is *sometimes* easier than `setState()`, *even for beginners.*

In concurrent systems, updates to state are typically handled in 1 of 2 ways:

- Locking or restricting access to state updates while other things are using the state, (e.g., `setState()`)or…
- Employing immutability to eliminate shared mutable state, which allows unrestricted access to state, and new state creation at any point in time. (e.g., Redux)

In my opinion (after teaching both techniques to lots of students), the first way is much more error prone and confusing than the second way. When state updates are simply blocked (or in the case of `setState()`, batched or deferred), the correct solution to the problem is not immediately clear.

My default reaction when I encounter a `setState()` timing issue is simple: Move my state management up the tree, either to Redux (or MobX), or to a container component. I usually use and recommend Redux for [lots of reasons](https://medium.com/javascript-scene/10-tips-for-better-redux-architecture-69250425af44) , but obviously, that’s *not the right advice for everybody.*

Redux has its own *gigantic learning curve,* but sidesteps shared mutable state and state update timing complexity, so I find that once I teach students to avoid mutations, it’s pretty smooth sailing, *without too many gotchas or roadblocks.*

A newbie trying to learn Redux without any functional programming experience is probably going to have more trouble with Redux than they would with `setState()` — but at least there is a great set of [free](https://egghead.io/courses/getting-started-with-redux) [courses](https://egghead.io/courses/building-react-applications-with-idiomatic-redux)  on the topic, by the author of Redux.

React should take a page out of the Redux book: A great video tutorial on common React patterns and `setState()` gotchas would make an amazing addition to the React home-page.

#### Decide the State Before You Render ####

Moving state management to a container component (or Redux) forces you to think differently about your component state by making it clear that *before you can render* a component, *its state must already be decided* (because you have to pass it in as props).

That’s worth repeating:

> Before you render, decide the state!

An obvious corollary is that trying to use `setState()` inside your `render()` method is an anti-pattern.

Calculating dependent state inside your render method is fine (e.g., if you have `firstName` and `lastName` and you want to calculate `fullName`, it’s OK to do that in `render()`), but I prefer to calculate dependent state in a container and pass it in as props to presentation components.

### How Can setState() be Fixed? ###

My preference would be to deprecate the object literal form of `setState()`. I know it’s (superficially) easier to understand and more convenient, but it’s also how a lot of new users get stuck, and I think it’s self-evident that somebody doing this:

```
state.count; // 0
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
```

Expects to see `{count: 3}` afterwards. I have not yet seen a case where a batched object merge on the same property was expected behavior. I would argue that if such cases exist, they’re too tightly coupled to implementation details of React to be advisable valid use-cases.

I would also like to see the API section of the `setState()` docs link to the in-depth [“State and Lifecycle”](https://facebook.github.io/react/docs/state-and-lifecycle.html)  guide, to provide much more detail on this topic to users who are trying to learn the ins and outs of `setState()`. Because it does not operate synchronously or return anything meaningful, simply describing its function signature without more thoroughly discussing its effects and behavior is not successfully onboarding new users.

They have to resort to hours of troubleshooting, Google searches, StackOverflow, and GitHub issues.

### Why is setState() so Strict? ###

The quirky behavior of setState() is not a bug. It’s a feature. In fact, you might say *it’s the whole reason that React exists in the first place.*

One of the driving motivations for React was to ensure deterministic renders: Given some application state, render some specific output. Ideally, given the same state, always render the same output.

In order to make that happen, React has to *manage mutation* by limiting when it can happen. We don’t just grab hold of the DOM and mutate it in place. Instead, React renders the DOM, and when some state changes, React decides how to render again. *We don’t render the DOM. React does.*

But to do this in a way that doesn’t retrigger renders during the update cycle, React introduces a rule:

The state that React uses to render can’t mutate during the DOM render process. *We don’t decide when component state gets updated. React does.*

Hence the confusion. When you call `setState()`, you think you’re setting the state. You’re not.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*cGqz_qxBGnJTsGygPe8ItQ.jpeg">

“You keep using that word. I don’t think it means what you think it means.”

### When Should We Use setState()? ###

I use `setState()` almost exclusively for self-contained units of functionality that don’t need to persist state. In other words, things like reusable form validation components, custom date or time block selection widgets, data visualization widgets that let you customize their view state, etc…

I call components like that “widgets”, and they’re really made up of two or more components: a container for internal state management, and one or more child components which handle the actual DOM and presentation aspects.

Here are some simple litmus tests:

- Do other components rely on the state?
- Do you need to persist the state? (Save it to local storage or send it to a server?)

If the answers to both of those questions is “no”, maybe it’s OK to use `setState()`. Otherwise, you might want to consider something else.

At Facebook, as far as I understand, they use `setState()` managed by a [Relay container](https://facebook.github.io/relay/) to encapsulate different parts of the Facebook UI like mini applications inside the larger Facebook application. For them, it’s a great way to colocate their many complex data dependencies with the components that actually use them.

I recommend similar strategies for very large (enterprise scale) applications. If your app has a whole lot of code (hundreds of thousands of LOC+), this may be a good strategy for you, too — but there’s no reason the approach can’t also scale down as well.

There’s also no reason you can’t use a similar approach by instead breaking those different pieces into actually separate mini-applications which get composed into the larger application. I have done that with Redux for enterprise software. For example, I often separate analytics dashboards, messaging, admin, team/user role management, and billing management into totally separate apps with their own Redux stores. Such apps can share a domain along with common login/session management using API tokens and OAuth so that the apps feel like one connected app.

For most apps, I recommend **defaulting to Redux**. It’s worth noting that Dan Abramov (the creator of Redux) disagrees with me on that point. He rightly favors keeping apps as simple as they can be until they can’t be that simple anymore. The conventional community wisdom says “don’t use Redux until you feel the pain.”

My response is this:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*z_XSyNy2GoSEOipCeOVM_g.jpeg">

“Those who are unaware they are walking in darkness will never seek the light”.
As I mentioned already, *in some cases,* Redux is a simpler path than `setState()`. Redux simplifies state management by eliminating entire classes of bugs related to shared mutable state and timing dependencies.

Do learn `setState()`, but even if you decide you don’t want to use Redux in your app, **you should still learn Redux.** It will teach you new ways to think about application state, and probably help you simplify your application state no matter what other solution you choose for your app.

For apps with a whole lot of derived state, [MobX](https://github.com/mobxjs/mobx)  is probably a better solution than `setState()` or Redux, because it’s very good at efficiently managing and organizing calculated state.

Because of its granular observable subscription model, it’s also very good at rendering LOTS of dynamic DOM elements efficiently (tens of thousands). So if you’re building a graphical game, or a console that monitors all the instances of your enterprise microservices, it might be a great choice for visually displaying all that complex information in realtime.

### Next Steps ###

Want to learn a whole lot more about building software with React and Redux?

[Learn JavaScript with Eric Elliott](http://ericelliottjs.com/product/lifetime-access-pass/) . If you’re not a member, you’re missing out!

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">
](https://ericelliottjs.com/product/lifetime-access-pass/)

***Eric Elliott*** *is the author of* [*“Programming JavaScript Applications”*](http://pjabook.com) *(O’Reilly), and* [*“Learn JavaScript with Eric Elliott”*](http://ericelliottjs.com/product/lifetime-access-pass/) . He has contributed to software experiences for **Adobe Systems** , **Zumba Fitness** , **The Wall Street Journal** , **ESPN** , **BBC** , and top recording artists including **Usher** , **Frank Ocean** , **Metallica**, and many more.

*He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world.*
