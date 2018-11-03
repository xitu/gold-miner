> * 原文地址：[React hooks: not magic, just arrays](https://medium.com/@ryardley/react-hooks-not-magic-just-arrays-cd4f1857236e)
> * 原文作者：[Rudi Yardley](https://medium.com/@ryardley?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-hooks-not-magic-just-arrays.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-hooks-not-magic-just-arrays.md)
> * 译者：
> * 校对者：

# React hooks: not magic, just arrays

## Untangling the rules around the proposal using diagrams

I am a huge fan of the new hooks API. However, it has some [odd constraints](https://reactjs.org/docs/hooks-rules.html) about how you need to use it. Here I present a model for how to think about using the new API for those that are struggling to understand the reasons for those rules.

### WARNING: Hooks are experimental

_This article is about the hooks API which currently is an experimental proposal. You can find documentation for the stable React API_ [_here_](https://reactjs.org)_._

* * *

![](https://cdn-images-1.medium.com/max/2000/1*TharLROVH7aX2MotovHOBQ.jpeg)

Photo by rawpixel.com from Pexels

### Unpacking how hooks work

I have heard some people struggling with the ‘magic’ around the new hooks API draft proposal so I thought I would attempt to unpack how the syntax proposal works at least on a superficial level.

#### The rules of hooks

There are two main usage rules the React core team stipulates you need to follow to use hooks which they outline in the [hooks proposal documentation](https://reactjs.org/docs/hooks-rules.html).

*   **Don’t call Hooks inside loops, conditions, or nested functions**
*   **Only Call Hooks from React Functions**

The latter I think is self evident. To attach behaviour to a functional component you need to be able to associate that behaviour with the component somehow.

The former however I think can be confusing as it might seem unnatural to program using an API like this and that is what I want to explore today.

#### State management in hooks is all about arrays

To get a clearer mental model, let’s have a look at what a simple implementation of the hooks API might look like.

**_Please note this is speculation and only one possible way of implementing the API to show how you might want to think about it. This is not necessarily how the API works internally. Also this is only a proposal. This all may change in the future._**

#### How could we implement \`useState()\` ?

Let’s unpack an example here to demonstrate how an implementation of the state hook might work.

First let’s start with a component:

```
function RenderFunctionComponent() {
  const [firstName, setFirstName] = useState("Rudi");
  const [lastName, setLastName] = useState("Yardley");

  return (
    <Button onClick={() => setFirstName("Fred")}>Fred</Button>
  );
}
```

The idea behind the hooks API is that you can use a setter function returned as the second array item from the hook function and that setter will control state which is managed by the hook.

### So what’s React going to do with this?

Let’s annotate how this might work internally within React. The following would work within the execution context for rendering a particular component. That means that the data stored here lives one level outside of the component being rendered. This state is not shared with other components but it is maintained in a scope that is accessible to subsequent rendering of the specific component.

#### 1) Initialisation

Create two empty arrays: `setters` and `state`

Set a cursor to 0

![](https://cdn-images-1.medium.com/max/1600/1*LAZDuAEm7nbcx0vWVKJJ2w.png)

Initialisation: Two empty arrays, Cursor is 0

* * *

#### 2) First render

Run the component function for the first time.

Each `useState()` call, when first run, pushes a setter function (bound to a cursor position) onto the `setters` array and then pushes some state on to the `state` array.

![](https://cdn-images-1.medium.com/max/1600/1*8TpWnrL-Jqh7PymLWKXbWg.png)

First render: Items written to the arrays as cursor increments.

* * *

#### 3) Subsequent render

Each subsequent render the cursor is reset and those values are just read from each array.

![](https://cdn-images-1.medium.com/max/1600/1*qtwvPWj-K3PkLQ6SzE2u8w.png)

Subsequent render: Items read from the arrays as cursor increments

* * *

#### 4) Event handling

Each setter has a reference to it’s cursor position so by triggering the call to any `setter` it will change the state value at that position in the state array.

![](https://cdn-images-1.medium.com/max/1600/1*3L8YJnn5eV5ev1FuN6rKSQ.png)

Setters “remember” their index and set memory according to it.

* * *

#### And the naive implementation

Here is a code example to demonstrate that implementation:

```
let state = [];
let setters = [];
let firstRun = true;
let cursor = 0;

function createSetter(cursor) {
  return function setterWithCursor(newVal) {
    state[cursor] = newVal;
  };
}

// This is the pseudocode for the useState helper
export function useState(initVal) {
  if (firstRun) {
    state.push(initVal);
    setters.push(createSetter(cursor));
    firstRun = false;
  }

  const setter = setters[cursor];
  const value = state[cursor];

  cursor++;
  return [value, setter];
}

// Our component code that uses hooks
function RenderFunctionComponent() {
  const [firstName, setFirstName] = useState("Rudi"); // cursor: 0
  const [lastName, setLastName] = useState("Yardley"); // cursor: 1

  return (
    <div>
      <Button onClick={() => setFirstName("Richard")}>Richard</Button>
      <Button onClick={() => setFirstName("Fred")}>Fred</Button>
    </div>
  );
}

// This is sort of simulating Reacts rendering cycle
function MyComponent() {
  cursor = 0; // resetting the cursor
  return <RenderFunctionComponent />; // render
}

console.log(state); // Pre-render: []
MyComponent();
console.log(state); // First-render: ['Rudi', 'Yardley']
MyComponent();
console.log(state); // Subsequent-render: ['Rudi', 'Yardley']

// click the 'Fred' button

console.log(state); // After-click: ['Fred', 'Yardley']
```

### Why order is important

Now what happens if we change the order of the hooks for a render cycle based on some external factor or even component state?

Let’s do the thing the React team say you should not do:

```
let firstRender = true;

function RenderFunctionComponent() {
  let initName;
  
  if(firstRender){
    [initName] = useState("Rudi");
    firstRender = false;
  }
  const [firstName, setFirstName] = useState(initName);
  const [lastName, setLastName] = useState("Yardley");

  return (
    <Button onClick={() => setFirstName("Fred")}>Fred</Button>
  );
}
```

This breaks the rules!

Here we have a `useState` call in a conditional. Let’s see the havoc this creates on the system.

#### Bad Component First Render

![](https://cdn-images-1.medium.com/max/1600/1*C4IA_Y7v6eoptZTBspRszQ.png)

Rendering an extra ‘bad’ hook that will be gone next render

At this point our instance vars `firstName` and `lastName` contain the correct data but let’s have a look what happens on the second render:

#### Bad Component Second Render

![](https://cdn-images-1.medium.com/max/1600/1*aK7jIm6oOeHJqgWnNXt8Ig.png)

By removing the hook between renders we get an error.

Now both `firstName` and `lastName` are set to `“Rudi”` as our state storage becomes inconsistent. This is clearly erroneous and doesn’t work but it gives us an idea of why the rules for hooks are laid out the way they are.

> The React team are stipulating the usage rules because not following them will lead to inconsistent data

#### Think about hooks manipulating a set of arrays and you wont break the rules

So now it should be clear as to why you cannot call `use` hooks within conditionals or loops. Because we are dealing with a cursor pointing to a set of arrays, if you change the order of the calls within render, the cursor will not match up to the data and your use calls will not point to the correct data or handlers.

So the trick is to think about hooks managing it’s business as a set of arrays that need a consistent cursor. If you do this everything should work.

### Conclusion

Hopefully I have laid out a clearer mental model for how to think about what is going on under the hood with the new hooks API. Remember the true value here is being able to group concerns together so being careful about order and using the hooks API will have a high payoff.

Hooks is an effective plugin API for React Components. There is a reason why people are excited about this and if you think about this kind of model where state exists as a set of arrays then you should not find yourselves breaking the rules around their usage.

I hope to have a look at the `useEffects` method in the future and try to compare that to React’s component lifecycle methods.

* * *

_This article is a living document please reach out to me if you want to contribute or see anything inaccurate here._

_You can follow Rudi Yardley on Twitter as_ [_@rudiyardley_](https://twitter.com/rudiyardley) _or on Github as_ [_@_ryardley](https://github.com/ryardley)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
