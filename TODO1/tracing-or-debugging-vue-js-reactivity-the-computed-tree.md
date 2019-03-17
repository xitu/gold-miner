> * 原文地址：[Tracing or Debugging Vue.js Reactivity: The computed tree](https://medium.com/dailyjs/tracing-or-debugging-vue-js-reactivity-the-computed-tree-9da0ba1df5f9)
> * 原文作者：[Michael Gallagher](https://medium.com/@mike_17305)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tracing-or-debugging-vue-js-reactivity-the-computed-tree.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tracing-or-debugging-vue-js-reactivity-the-computed-tree.md)
> * 译者：
> * 校对者：

# Tracing or Debugging Vue.js Reactivity: The computed tree

![](https://cdn-images-1.medium.com/max/8576/1*0Z1Zbhg127bJ2_wReyrq-A.jpeg)

With all the buzz about the [next major release](https://medium.com/the-vue-point/plans-for-the-next-iteration-of-vue-js-777ffea6fabf) of Vue, there is plenty of intrigue surrounding announced features, one that caught my attention was:

> Better debugging capabilities: we can precisely trace when and why a component re-render is tracked or triggered

In this article, I’ll be talking about what we can do now in Vue 2.x to trace reactivity and maybe tune some stray code that might impact performance.

![](https://cdn-images-1.medium.com/max/2000/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

## Why Reactive code might need tuning

If you work in a large codebase, you are probably using Vuex. You might divide up your store into modules, and you might even be [normalizing](https://redux.js.org/recipes/structuring-reducers/normalizing-state-shape) your state as it is the consensus approach to relational data.

You are probably using Vuex getters to prepare derived data, in fact, you probably use composite derived data, where the derived data in one getter might feed into another.

Within Vue components, you might be leveraging a variety of hierarchical patterns and most certainly **slots**. Within this component tree, there will be computed properties (derived data).

When this happens, the reactive path from the store data to the rendered components can be difficult to understand at a high level.

> This is the computed tree, and if it isn’t clear, then maybe flipping a seemingly innocent boolean could trigger a refresh of 100 components.

## Nuts and Bolts

We’re going to walk through some of the inner workings of reactivity. If you aren’t aware (at a high level) of the relationship between the Dependency class (`Dep`) and the Watcher class, consider reading the very informative and very clear VueMastery lesson on [Building a Reactivity System](https://www.vuemastery.com/courses/advanced-components/build-a-reactivity-system/).

## Ever seen __ob__ when debugging in browser developer tools?

You can admit it. Curiosity got the better of you. Did it look something like this?

![](https://cdn-images-1.medium.com/max/3000/1*7IR58OgtvxiUcgWtCLlvEQ.png)

Well each of these Watchers in `subs` is something that will update when the value of this reactive data changes.

Sometimes you can scan through these objects in developer tools and find something meaningful, sometimes you can’t. And sometimes there are a lot more than 5 watchers.

## By Example

Let’s use some sample code for illustration: [JSFiddle](https://jsfiddle.net/mikeapr4/eqLy1ac3/)

We’ll start with store state containing a hash of `users` and the `currentUserId`. Then have a getter to return the current user record. And a filtered list of active users.

Then spread over two components, there are three computed properties:

* `validCurrentUser` — conditional which is true if the current user is valid
* `total` — referring to total active users, will return the count
* `upperCaseName` — mapped user name, to uppercase

A contrived example for sure, but should hopefully help demonstrate what we talk about.

## How does computed reactivity work?

Generally, reactivity triggers a Watcher function when it is notified from a Dependency class. So if I change my data and a component’s render uses it, a re-render will occur.

But when we look at derived data, it is a little more complex. Firstly, remember that computed data is cached (memoized) so that once it is calculated, the value is available until the cache becomes stale, i.e. when some reactive data it depends is changed.

Let’s look at part of the [JSFiddle](https://jsfiddle.net/mikeapr4/eqLy1ac3/) example. The `currentUserId` state property is used in the `currentUser` getter, then in the `validCurrentUser` computed property, which in turn is part of a `v-if` expression in the render of the root component. This is a nice chain to look at.

In practice, memoization is handled by a configuration option to the Watcher. When we use Watchers from components the [API documentation](https://vuejs.org/v2/api/#vm-watch) describes 2 possible options (`deep`, `immediate`) but there are more undocumented options, I’m not suggesting you use them, but worth understanding them. One option is `lazy`, which means that the Watcher will maintain a flag (`dirty`) that will be true if the reactive data has changed but the Watcher has not yet re-run, i.e. the cache is stale.

So what happens in our example when `currentUserId` is changed to, say, 3. Any lazy Watchers will be flagged as dirty straight away, but not run. Both `currentUser` and `validCurrentUser` are lazy watchers of this state property. The root render function will also depend on this state property, it will fire on next tick. When it runs it will call `validCurrentUser`, now flagged dirty, which will re-run its getter function, in turn calling `currentUser` which also will update. And that’s it, the component has re-rendered correctly and caches have been refreshed.
> # Hold up I hear you say, why would all 3 Watchers depend on the state property?

Don’t they depend on each other? Well, a feature of computed watchers is that their values aren’t reactive, but rather when a computed getter is called, all of its own dependencies are passed to the calling Watcher, if there is one. This flattening of reactivity chains is better for performance not to mention being a simpler solution.

Though worth noting, it means a component will refresh, even if a computed property it depends on, doesn’t change value after being reevaluated.

Some of this behaviour can be read in the elegant 240 line long [watcher class](https://github.com/vuejs/vue/blob/4f111f9225f938f7a2456d341626dbdfd210ff0c/src/core/observer/watcher.js)

## So what can ob tell us about computed reactivity?

We can see how many Watchers are subscribed (`subs`) to reactive data. And keep in mind that reactivity works on:

* Objects
* Arrays
* Object properties

This last one might have escaped you as you can’t see it in the developer tools — The Dependency class is created in the scope of defining a reactive property, but not stored anywhere on the data. We’ll come back to this as I have a cheeky trick to get hold of it!

But we can learn a lot looking at the Watchers for Objects and Arrays, here is a sample watcher:

![](https://cdn-images-1.medium.com/max/3924/1*X-fJ7_K4EFBKUHV9BM93Ug.png)

Open the developer tools when running the sample [JSFiddle](https://jsfiddle.net/mikeapr4/eqLy1ac3/) and it should pause execution after a full render. You can enter the above expression and you should see the same:

```
this.$store.state.users[2].__ob__.dep.subs[5]
```

This is a common one, it is a component re-render. Here you can see the `dirty` and `lazy` flags I mentioned before. Also, I know this isn’t a `user` created watcher.

Sometimes trying to find out which component it relates to can be tough (if components aren’t globally registered or have a name specified, they are essentially anonymous). However when you call one component from another, its `$vnode.tag` normally contains the name it was called by.

![](https://cdn-images-1.medium.com/max/3548/1*BaKMMhR47aMvlJ85W98xKQ.png)

The above Watcher comes from the child component (defined as `Comp` by its parent). It relates to the `upperCaseName` computed property. Computed properties often have a meaningful name specified on their getter functions because they are defined as Object properties.

## Vuex Getters

Although computed properties normally give their name and their component, Vuex getters aren’t so straight forward. Here is what the `currentUser` watcher looks like:

![](https://cdn-images-1.medium.com/max/3322/1*9CNU3NoJf7HCVrDynQteTA.png)

The only clue that it is a Vuex getter is that the function location is in **vuex.min.js**.

So how can we get access to the name of the getter? Well in developer tools the `[[Scopes]]` are available, and you should find the name there, though this isn’t accessible programmatically.

Here is the solution I have, run after the Vuex store has been created:

```
const watchers = store._vm._computedWatchers;
Object.keys(watchers).forEach(key => {
  watchers[key].watcherName = key;
});
```

The first line may look a little odd until I tell you that a Vuex store maintains an internal Vue instance to handle its getter functionality, in fact, getters are actually computed properties in disguise!

Now, when we examine the Watchers in the `subs` array, we can get access to `watcherName` which will have the name of the Vuex getter.

## Dependency instances for Object Properties

Above I mentioned that debugging reactive data won’t give you access to the Dependency instances for Object Properties.

In the example [JSFiddle](https://jsfiddle.net/mikeapr4/eqLy1ac3/), each `user` object has a `name` property, which will itself have Watchers which will be notified if it changes.

Although the Dependency instance isn’t directly available, all Dependency instances can be accessed from any Watcher listener to them. Watchers keep a list of all their Dependencies.
> # My cheeky trick is to add a Watcher to the property and then grab the Dependency off the Watcher.

But it isn’t that simple, I can add a Watcher using the Vue `$watch` interface, but that won’t return the Watcher **instance**. Therefore I need to grab it from internal properties on the Vue instance.

```
const tempVm = new Vue();
tempVm.$watch(() => store.state.users[2].name, () => {});
const tempWatch = tempVm._watchers[0];

// now pull the subs from the deps
tempWatch.deps.forEach(dep => dep.subs
  .filter(s => s !== tempWatch)
  .forEach(s => subs.add(s)));
```

## Want it wrapped up in a tool?

I’ve taken these minimal snippets and stuck them into a utility anyone can just grab, [**vue-pursue**](https://github.com/mikeapr4/vue-pursue).

Here is the [JSFiddle](https://jsfiddle.net/mikeapr4/pyn5djg8/) showing it in action:


The output from **vue-pursue** for `() => this.$store.state.users[2].name` is:

```
{
  "computed": [
    "currentUser",
    "validCurrentUser",
    "Comp.upperCaseName"
  ],
  "components": [
    "Comp"
  ],
  "unrecognised": 1
}
```

Some things to note, the root component will update here, but we don’t have a name for the root component, so it shows up under `unrecognised`. The `currentUser` vuex getter will refresh, but not from a change to `name`.

By passing an arrow to vue-pursue, all dependencies the arrow has will be evaluated for subscribers, meaning the `users` and `users[2]` objects are included. Alternatively, if we pass `(this.$store.state.users[2], ‘name’)` the output is:

```
{
  "computed": [
    "validCurrentUser",
    "Comp.upperCaseName"
  ],
  "components": [
    "Comp"
  ],
  "unrecognised": 1
}
```

## One last point…

Before the **private property police** drop round to lock me up, I need to warn you that tomorrow this code may fail, any properties starting with an underscore aren’t part of a public API and they can disappear without warning. This functionality, based on its purpose, isn’t intended for use in production code or even at runtime, it is a developer tool for debugging.

Ultimately with Vue 3.0 on the horizon, this will likely be deprecated by something more comprehensive, easier to use and reliable from one release to the next.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
