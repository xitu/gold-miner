> * 原文地址：[Surprising polymorphism in React applications](https://medium.com/@bmeurer/surprising-polymorphism-in-react-applications-63015b50abc)
> * 原文作者：[Benedikt Meurer](https://medium.com/@bmeurer?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/surprising-polymorphism-in-react-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/surprising-polymorphism-in-react-applications.md)
> * 译者：
> * 校对者：

# Surprising polymorphism in React applications

Modern web applications based on the [React](https://facebook.github.io/react/) framework usually manage their state via immutable data structures, i.e. using the popular [Redux](http://redux.js.org/) state container. This pattern has a couple of benefits and is becoming ever more popular even outside the React/Redux world.

The core of this mechanism are so-called _reducers_. Those are functions that map one state of the application to the next one according to a specific action — i.e. in response to user interaction. Using this core abstraction, complex state and reducers can be composed of simpler ones, which makes it easy to unit test the code in separation. Consider the following example from the [Redux documentation](http://redux.js.org/docs/basics/ExampleTodoList.html):

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

The `todo` reducer maps an existing `state` to a new state in response to a given `action`. The state is represented as plain old JavaScript object. Looking at this code from a performance perspective, it seems to follow the principles for monomorphic code, i.e. keeping the object shape the same.

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

Speaking naively the property accesses in `render` should be monomorphic, i.e. the `state` objects should have the same shape — [map or hidden class in V8 speak](https://github.com/v8/v8/wiki/Design%20Elements#fast-property-access) — all the time, both `s1` and `s2` have `id`, `text` and `completed` properties in this order. However, running this code in the `d8` shell and tracing the ICs (inline caches), we observe that `render` sees different object shapes and the `state.id` and `state.text` property accesses become polymorphic:

![](https://cdn-images-1.medium.com/max/800/1*FrfEaOkxshIj79wJDQyrIQ.png)

So where does this polymorphism comes from? It’s actually pretty subtle and has to do with the way V8 handles object literals. Each object literal — i.e. expression of the form `{a:va,...,z:vb}` defines a root map in the transition tree of maps (remember map is V8 speak for object shape). So if you use an empty object literal `{}` than the transition tree root is a map that doesn’t contain any properties, whereas if you use `{id:id, text:text, completed:completed}` object literal, then the transition tree root is a map that contains these three properties. Let’s look at a simplified example:

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

You can run this code in Node.js passing the `--allow-natives-syntax` command line flag (which enables the use of the `%HaveSameMap` intrinsic), i.e.:

![](https://cdn-images-1.medium.com/max/800/1*yzSaH_AE5z7r9PWBXlvwWg.png)

So despite these objects `a` and `b` looking the same — having the same properties with the same types in the same order — they don’t have the same map. The reason being that they have different transition trees, as illustrated by the following diagram:

![](https://cdn-images-1.medium.com/max/800/1*fkbEgBWk74icFH1yZIH7Lw.png)

So polymorphism hides where objects are allocated via different (incompatible) object literals. This especially applies to common uses of `Object.assign`, for example

```
let a = {x:1, y:2, z:3};

let b = Object.assign({}, a);

console.log("a is", a);
console.log("b is", b);
console.log("a and b have same map:", %HaveSameMap(a, b));
```

still yields different maps, because the object `b` starts out as empty object (the `{}` literal) and `Object.assign` just slaps properties on it.

![](https://cdn-images-1.medium.com/max/800/1*Xu-nIj21gj-GlHDkzsSOSA.png)

This also applies if you use spread properties and transpile it using Babel, because Babel — and probably other transpilers as well — use `Object.assign` for spread properties.

![](https://cdn-images-1.medium.com/max/800/1*F2x8lRcZ83pQDvftelFOgA.png)

One way to avoid this is to consistently use `Object.assign` so that all objects start from the empty object literal. But this can become a performance bottleneck in the state management logic:

```
let a = Object.assign({}, {x:1, y:2, z:3});

let b = Object.assign({}, a);

console.log("a is", a);
console.log("b is", b);
console.log("a and b have same map:", %HaveSameMap(a, b));
```

That being said, it’s not the end of the world if some code becomes polymorphic. Staying monomorphic might not matter at all for most of your code. You should measure really carefully before making the decision to optimize the wrong thing.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
