> * 原文地址：[Inside Fiber: in-depth overview of the new reconciliation algorithm in React](https://medium.com/react-in-depth/inside-fiber-in-depth-overview-of-the-new-reconciliation-algorithm-in-react-e1c04700ef6e)
> * 原文作者：[Max Koretskyi, aka Wizard](https://medium.com/@maxim.koretskyi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/inside-fiber-in-depth-overview-of-the-new-reconciliation-algorithm-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-fiber-in-depth-overview-of-the-new-reconciliation-algorithm-in-react.md)
> * 译者：
> * 校对者：

# Inside Fiber: in-depth overview of the new reconciliation  algorithm in React

## The how and why on everything from React elements to Fiber nodes

![](https://cdn-images-1.medium.com/max/800/1*8Xi7apFuZ2M5Fw3CirwyDw.png)

* * *

React is a JavaScript library for building user interfaces. At its core lies [the mechanism](https://medium.freecodecamp.org/what-every-front-end-developer-should-know-about-change-detection-in-angular-and-react-508f83f58c6a) that tracks changes in a component state and projects the updated state to the screen. In React we know this process as reconciliation. We call the `setState` method and the framework checks if the state or props have changed and re-renders a component on UI.

React’s docs provide [a good high-level overview](https://reactjs.org/docs/reconciliation.html) of the mechanism: the role of React elements, lifecycle methods and the `render` method, and the diffing algorithm applied to a component’s children. The tree of immutable React elements returned from the `render` method is commonly known as “virtual DOM”. That term helped explain React to people early on, but it also caused confusion and isn’t used in the React documentation anymore. In this article I’ll stick to calling it a tree of React elements.

Besides the tree of React elements, the framework have always had a tree of internal instances (components, DOM nodes etc.) used to keep the state. Starting from version 16, React rolled out a new implementation of that internal instances tree and the algorithm that manages it code-named Fiber. To learn about the advantages which fiber architecture brings check out [The how and why on React’s usage of linked list in Fiber](https://medium.com/dailyjs/the-how-and-why-on-reacts-usage-of-linked-list-in-fiber-67f1014d0eb7).

> This article would take me a lot longer to write and would be less comprehensive without the help of [Dan Abramov](https://medium.com/@dan_abramov)! _👍_

This is the first article in the series aimed to teach you internal architecture of React. In this article I want to provide in-depth overview of important concepts and data structures relevant to the algorithm. Once we have enough background, we’ll explore the algorithm and main functions used to traverse and process the fiber tree. Next articles in the series will demonstrate how React uses the algorithm to perform first render and process state and props updates. From there we’ll move to the details of scheduler, children reconciliation process and the mechanism of building an effects list.

[**Follow me to stay tuned!**](https://twitter.com/maxim_koretskyi)

I’m going to give you pretty advanced knowledge here 🧙‍. I encourage you to read it to understand the magic behind the inner workings of concurrent React. This series of articles will also serve you as a great guide if you plan to start contributing to React. I’m [a hard believer of reverse-engineering](https://blog.angularindepth.com/level-up-your-reverse-engineering-skills-8f910ae10630), so there will be a lot of links to the sources from the recent version 16.6.0.

There’s definitely quite a lot to take in, so don’t feel stressed if you can’t understand something right away. It takes time as everything worthwhile. **Note that you don’t need to know any of it to use React. This article is about how React works internally.**

> I work as a developer advocate at [ag-Grid](https://react-grid.ag-grid.com/?utm_source=medium&utm_medium=blog&utm_campaign=reactcustom). If you’re curios to learn about data grids or looking for the ultimate react data grid solution, get in touch or give it a try with the guide “[Get started with React grid in 5 minutes](https://medium.com/ag-grid/get-started-with-react-grid-in-5-minutes-f6e5fb16afa)”. I’m happy to answer any questions you may have.

* * *

### Setting the background

Here’s a simple application that I’ll use throughout the series. We have a button that simply increments a number rendered on the screen:

![](https://cdn-images-1.medium.com/max/800/1*jTWOx6Yr6JyBV5ETnp4TRQ.gif)

And here’s the implementation:

```
class ClickCounter extends React.Component {
    constructor(props) {
        super(props);
        this.state = {count: 0};
        this.handleClick = this.handleClick.bind(this);
    }

    handleClick() {
        this.setState((state) => {
            return {count: state.count + 1};
        });
    }


    render() {
        return [
            <button key="1" onClick={this.handleClick}>Update counter</button>,
            <span key="2">{this.state.count}</span>
        ]
    }
}
```

You can play with it [here](https://stackblitz.com/edit/react-t4rdmh). As you can see, it’s a simple component that returns two child elements `**button**`  and `**span**`  from the `**render**`  method. As soon as you click on the button, the state of the component is updated inside the handler. This, in turn, results in the text update for the `**span**`  element.

There are various activities React performs during reconciliation. For example, here are the high-level operations React performs during the first render and after state update in our simple application:

*   updates `**count**`  property in the `**state**`  of `**ClickCounter**`
*   retrieves & compares children of `**ClickCounter**`  and their props
*   updates props for the `**span**`  element
*   updates `**textContent**`  property of the `**span**`  element.

There are other activities performed during reconciliation like calling [lifecycle methods](https://reactjs.org/docs/react-component.html#updating) or updating [refs](https://reactjs.org/docs/refs-and-the-dom.html). **All these activities are collectively referred to as “work” in Fiber architecture.** The type of work usually depends on the type of a React element. For a class component, for example, React needs to create an instance, while it doesn’t do that for a functional component. As you know, we have many kinds of elements in React, e.g. class and functional components, host components (DOM nodes), portals etc. The type of a React element is defined by the first parameter to the [createElement](https://github.com/facebook/react/blob/b87aabdfe1b7461e7331abb3601d9e6bb27544bc/packages/react/src/ReactElement.js#L171) function. This function is generally used in the `**render**`  method to create an element.

Before we begin our exploration of the activities and the main fiber algorithm, let’s first get ourselves familiar with data structures used internally by React.

### From React Elements to Fiber nodes

Every component in React has a UI representation we can call a view or a template that’s returned from the `**render**`  method. Here’s the template for our `**ClickCounter**`  component:

```
<button key="1" onClick={this.onClick}>Update counter</button>
<span key="2">{this.state.count}</span>
```

#### React Elements

Once a template goes through JSX compiler, you end up with a bunch of React elements. This is what’s really returned from the `**render**`  method of React components, not HTML. Since we’re not required to use JSX compiler, the `**render**`  method for our `**ClickCounter**`  component could be re-written like this:

```
class ClickCounter {
    ...
    render() {
        return [
            React.createElement(
                'button',
                {
                    key: '1',
                    onClick: this.onClick
                },
                'Update counter'
            ),
            React.createElement(
                'span',
                {
                    key: '2'
                },
                this.state.count
            )
        ]
    }
}
```

The calls to `**React.createElement**` in the `**render**`  method will create two data structures like this:

```
[
    {
        $$typeof: Symbol(react.element),
        type: 'button',
        key: "1",
        props: {
            children: 'Update counter',
            onClick: () => { ... }
        }
    },
    {
        $$typeof: Symbol(react.element),
        type: 'span',
        key: "2",
        props: {
            children: 0
        }
    }
]
```

You can see that React adds the property `**$$typeof**`  to these objects to uniquely identify them as React elements. Then we have properties `**type**`, `**key**`  and `**props**`  that describe the element. The values are taken from what you pass to the `**React.createElement**` function. Notice how React represents text content as children of a `**span**`  and `**button**`  nodes. And how the click handler is part of the `**button**`  element props. There are other fields on React elements like the `**ref**`  field that are beyond the scope of this article.

The React element for `**ClickCounter**` doesn’t have any props or a key:

```
{
    $$typeof: Symbol(react.element),
    key: null,
    props: {},
    ref: null,
    type: ClickCounter
}
```

#### Fiber nodes

During reconciliation data from every React element returned from the `**render**` method is merged into the tree of fiber nodes. Every React element has a corresponding fiber node. Unlike React elements, fibers aren’t re-created on every render. These are mutable data structures that hold components state and DOM.

We discussed earlier that depending on the type of a React element the framework needs to perform different activities. In our sample application, for the class components `**ClickCounter**` it calls lifecycle methods and the `render` method, whereas for the `**span**` host component (DOM node) it performs DOM mutation. So each React element is converted into a fiber node of [corresponding type](https://github.com/facebook/react/blob/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/shared/ReactWorkTags.js) that describes the work that needs to be done.

**You can think of a fiber as a data structure that represents some work to do or, in other words, a unit of work. Fiber’s architecture also provides a convenient way to track, schedule, pause and abort the work.**

When React element is converted into a fiber node for the first time, React uses the data from the element to create a fiber in the [createFiberFromTypeAndProps](https://github.com/facebook/react/blob/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/react-reconciler/src/ReactFiber.js#L414) function. In the consequent updates React reuses the fiber node and just updates the necessary properties using data from a corresponding React element. React may also need to move the node in the hierarchy based on the `key` prop or deletes it if the corresponding React element is no longer returned from the `render` method.

> Check out the [**ChildReconciler**](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactChildFiber.js#L239) function to see the list of all activities and corresponding functions React performs for existing fiber nodes.

Because React creates a fiber for each React element and since we have a tree of those elements, we’re going to have a tree of fiber nodes. In the case of our sample application it looks like this:

![](https://cdn-images-1.medium.com/max/800/1*cLqBZRht7RgR9enHet_0fQ.png)

All fiber nodes are connected through a linked list using the following properties on fiber nodes: `**child**`, `**sibling**` and `**return**`. For more details on why it works this way, check out my article [The how and why on React’s usage of linked list in Fiber](https://medium.com/p/67f1014d0eb7/edit) if you haven’t read it already.

#### Current and work in progress trees

After the first render, React ends up with a fiber tree that reflects the state of the application that was used to render the UI. This tree is often referred to as **current**. When React starts working on updates it builds a so-called **workInProgress** tree that reflects the future state to be flushed to the screen.

All work is performed on fibers from the `**workInProgress**`  tree. As React goes through the `**current**`  tree, for each existing fiber node it creates an alternate node that constitutes the `**workInProgress**`  tree. This node is created using the data from React elements returned by the `**render**`  method. Once the updates are processed and all related work is completed, React will have an alternate tree ready to be flushed to the screen. Once this `**workInProgress**`  tree is rendered on the screen, it becomes the `**current**`  tree.

One of React’s core principles is consistency. React always updates the DOM in one go — it doesn’t show partial results. The `**workInProgress**` tree serves as a “draft” that’s not visible to the user, so that React can process all components first, and then flush their changes to the screen.

In the sources you’ll see a lot of functions that take fiber nodes from both the `**current**`  and `**workInProgress**`  trees. Here’s the signature of one of such functions:

```
function updateHostComponent(current, workInProgress, renderExpirationTime) {...}
```

Each fiber node holds a reference to its counterpart from the other tree in the **alternate** field. A node from the `**current**`  tree points to the node from the `**workInProgress**`  tree and vice versa.

#### Side-effects

We can think of a component in React as a function that uses the state and props to compute the UI representation. Every other activity like mutating the DOM or calling lifecycle methods should be considered a side-effect or, simply, an effect. There’s also mentioning of effects [in the docs](https://reactjs.org/docs/hooks-overview.html#%EF%B8%8F-effect-hook):

> You’ve likely performed data fetching, subscriptions, or manually **changing the DOM** from React components before. We call these operations “side effects” (or “effects” for short) because they can affect other components and can’t be done during rendering.

You can see how most state and props updates will lead to side-effects. And since applying effects is a type of work, a fiber node is a convenient mechanism to track effects in addition to updates. Each fiber node can have effects associated with it. They are encoded in the `**effectTag**` field.

So effects in Fiber basically define the [work](https://github.com/facebook/react/blob/b87aabdfe1b7461e7331abb3601d9e6bb27544bc/packages/shared/ReactSideEffectTags.js) that needs to be done for instances after updates have been processed. For host components (DOM elements) the work consists of adding, updating or removing elements. For class components React may need to update refs and call `componentDidMount` and `componentDidUpdate` lifecycle methods. There are also other effects corresponding to other types of fibers.

#### Effects list

React processes updates very quickly and to achieve that level of performance it employs a few interesting techniques. **One of them is building a linear list of fiber nodes with effects for quick iteration.** Iterating the linear list is much faster than a tree, and there’s no need to spend time on nodes without side-effects.

The goal of this list is to mark nodes that have DOM updates or other effects associated with them. This list is a subset of the `**finishedWork**` tree and is linked using the `**nextEffect**` property instead of the `**child**` property used in the `**current**` and `**workInProgress**` trees.

[Dan Abramov](https://medium.com/@dan_abramov) offered an analogy for an effects list. He likes to think of it as a Christmas tree, with “Christmas lights” binding all effectful nodes together. To visualize this, let’s image the following tree of fiber nodes where the highlighted nodes have some work to do. For example, our update caused `**c2**` to be inserted into the DOM, `**d2**` and `**c1**` to change attributes, and `**b2**` to fire a lifecycle method. The effect list will link them together so React can skip other nodes later:

![](https://cdn-images-1.medium.com/max/800/1*Q0pCNcK1FfCttek32X_l7A.png)

You can see how the nodes with effects are linked together. When going over the nodes, React uses the `**firstEffect**` pointer to figure out where the list starts. So the diagram above can be represented as a linear list like this:

![](https://cdn-images-1.medium.com/max/800/1*mbeZ1EsfMsLUk-9hOYyozw.png)

As you can see, React applies effects in the order from children and up to parents.

#### Root of the fiber tree

Every React application has one or multiple DOM elements that act as containers. In our case it’s the `**div**` element with the ID `**container**`. React creates a [fiber root](https://github.com/facebook/react/blob/0dc0ddc1ef5f90fe48b58f1a1ba753757961fc74/packages/react-reconciler/src/ReactFiberRoot.js#L31) object for each of those containers. You can access it using the reference to the DOM element:

```
const fiberRoot = query('#container')._reactRootContainer._internalRoot
```

This fiber root is where React holds the reference to a fiber tree. It is stored in the `**current**` property of the fiber root:

```
const hostRootFiberNode = fiberRoot.current
```

The fiber tree starts with [the special type](https://github.com/facebook/react/blob/cbbc2b6c4d0d8519145560bd8183ecde55168b12/packages/shared/ReactWorkTags.js#L34) of a fiber node which is `**HostRoot**`. It’s created internally and acts as a parent for your topmost component. There’s a back link from the `**HostRoot**` fiber node to the `**FiberRoot**` through the `**stateNode**` property:

```
fiberRoot.current.stateNode === fiberRoot; // true
```

You can explore the fiber tree by accessing the topmost `**HostRoot**` fiber node through the fiber root. Or you can get an individual fiber node from a component instance like this:

```
compInstance._reactInternalFiber
```

#### Fiber node structure

Let’s now take a look at the structure of fiber nodes created for the `**ClickCounter**` component

```
{
    stateNode: new ClickCounter,
    type: ClickCounter,
    alternate: null,
    key: null,
    updateQueue: null,
    memoizedState: {count: 0},
    pendingProps: {},
    memoizedProps: {},
    tag: 1,
    effectTag: 0,
    nextEffect: null
}
```

and the `**span**` DOM element:

```
{
    stateNode: new HTMLSpanElement,
    type: "span",
    alternate: null,
    key: "2",
    updateQueue: null,
    memoizedState: null,
    pendingProps: {children: 0},
    memoizedProps: {children: 0},
    tag: 5,
    effectTag: 0,
    nextEffect: null
}
```

There’s quite a lot of fields on fiber nodes. I’ve described the purpose of the fields `**alternate**`, `**effectTag**`  and `**nextEffect**` in previous sections.  Let’s now see why we need others.

**stateNode**  
Holds the reference to the class instance of a component, a DOM node or other React element type associated with the fiber node. In general, we can say that this property is used to hold the local state associated with a fiber.

**type**  
Defines the function or class associated with this fiber. For class components, it points to the constructor function and for DOM elements it specifies the HTML tag. I use this field quite often to understand what element a fiber node is related to.

**tag  
**Defines [the type of a fiber node](https://github.com/facebook/react/blob/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/shared/ReactWorkTags.js). It’s used in the reconciliation algorithm to determine what work needs to be done. As mentioned earlier, the work varies depending on the type of a React element. The function [createFiberFromTypeAndProps](https://github.com/facebook/react/blob/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/react-reconciler/src/ReactFiber.js#L414) maps a React element to corresponding fiber node type. In our application, the property `**tag**` for the `**ClickCounter**` component is `**1**` which denotes a `**ClassComponent**` and for the `**span**` element it’s `**5**` denoting a `**HostComponent**`.

**updateQueue  
**A queue of state updates, callbacks and DOM updates.

**memoizedState**  
State of the fiber that was used to create the output. When processing updates it reflects the state that’s currently rendered on the screen.

**memoizedProps  
**Props of the fiber that were used to create the output during previous render.

**pendingProps  
**Props that have been updated from new data in React elements and need to be applied to child components or DOM elements.

**key  
**Unique identifier with a group of children to help React figure out which items have changed, have been added or removed from the list. It’s related to the “lists and keys” functionality of React described [here](https://reactjs.org/docs/lists-and-keys.html#keys).

You can find the complete structure of a fiber node [here](https://github.com/facebook/react/blob/6e4f7c788603dac7fccd227a4852c110b072fe16/packages/react-reconciler/src/ReactFiber.js#L78). I’ve omitted a bunch of fields in the demonstration above. Particularly, the pointers `**child**,`, `**sibling**`  and `**return**`  that make up a tree data structure [described in my previous article](http://df). And a category of fields like `**expirationTime**`, `**childExpirationTime**`  and `**mode**`  that are specific to `**Scheduler**`.

* * *

### General algorithm

React performs work in two main phases: **render** and **commit**.

During the first `**render**` stage React applies updates to components scheduled through `**setUpdate**` or `**React.render**` and figures out what needs to be updated on UI. If it’s the initial render, React creates a new fiber node for each element returned from the `**render**` method. In the following updates, fibers for existing React elements are re-used and updated. **The result of the phase is a tree of fiber nodes marked with side-effects.** The effects describe the work that needs to be done during the following `**commit**` phase. During this phase React takes a fiber tree marked with effects and applies them to instances. It goes over the list of effects and performs DOM updates and other changes visible to a user.

**It’s important to understand that the work during the first** `**render**` **phase can be performed asynchronously.** React can process one or more fiber nodes depending on the available time, then stop to stash the work done and yield to some event. It then continues from where it’s left. Sometimes, though, it may need to discard the work done and start from the top again. These pauses are made possible by the fact that the work performed during this phase doesn’t lead to any user-visible changes, like DOM updates. **In contrast, the following** `**commit**` **phase is always synchronous**. This is because the work performed during this stage leads to changes visible to the user, e.g. DOM updates. That’s why React needs to do them in a single pass.

Calling lifecycle methods is one type of work performed by React. Some methods are called during the `**render**` phase and others during the `**commit**` phase. Here’s the list of lifecycles called when working through the first `**render**` phase:

*  [UNSAFE_]componentWillMount (deprecated)
*  [UNSAFE_]componentWillReceiveProps (deprecated)
*  getDerivedStateFromProps
*  shouldComponentUpdate
*  [UNSAFE_]componentWillUpdate (deprecated)
*  render

As you can see, some legacy lifecycle methods that are executed during the `**render**` phase are marked as `**UNSAFE**` from the version 16.3. They are now called legacy lifecycles in the docs. They will be deprecated in future 16.x releases and their counterparts without the `**UNSAFE**` prefix will be removed in 17.0. You can read more about these changes and the suggested migration path [here](https://reactjs.org/blog/2018/03/27/update-on-async-rendering.html).

Are you curious about the reason for this?

Well, we’ve just learned that because the `**render**` phase doesn’t produce side-effects like DOM updates, React can process updates asynchronously to components asynchronously (potentially even doing it in multiple threads). However, the lifecycles marked with `**UNSAFE**` have often been misunderstood and subtly misused. Developers tended to put the code with side-effects inside these methods which may cause problems with the new async rendering approach. Although only their counterparts without the `**UNSAFE**`  prefix will be removed, they are still likely to cause issues in the upcoming Concurrent Mode (which you can opt out of).

Here’s the list of lifecycle methods executed during the second `**commit**` phase:

*   getSnapshotBeforeUpdate
*   componentDidMount
*   componentDidUpdate
*   componentWillUnmount

Because these methods execute in the synchronous `**commit**` phase, they may contain side effects and touch the DOM.

Okay, so now we have the background to take a look at generalized algorithm used to walk the tree and perform work. Let’s dive in.

### Render phase

The reconciliation algorithm always starts from the topmost `**HostRoot**` fiber node using the [renderRoot](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactFiberScheduler.js#L1132) function. However, React bails out of (skips) already processed fiber nodes until it finds the node with unfinished work. For example, if you call `**setState**` deep in the components tree, React will start from the top but quickly skip over the parents until it gets to the component that had its `**setState**` method called.

#### Main steps of the work loop

All fiber nodes are processed [in the work loop](https://github.com/facebook/react/blob/f765f022534958bcf49120bf23bc1aa665e8f651/packages/react-reconciler/src/ReactFiberScheduler.js#L1136). Here is the implementation of the synchronous part of the loop:

```
function workLoop(isYieldy) {
  if (!isYieldy) {
    while (nextUnitOfWork !== null) {
      nextUnitOfWork = performUnitOfWork(nextUnitOfWork);
    }
  } else {...}
}
```

In the code above the `**nextUnitOfWork**` holds a reference to the fiber node from the `**workInProgress**` tree that has some work to do. As React traverses the tree of Fibers, it uses this variable to know if there’s any other fiber node with unfinished work. After the current fiber is processed, the variable will either contain the reference to the next fiber node in a tree or `**null**`. In that case React exits the work loop and is ready to commit the changes.

There are 4 main functions that are used to traverse the tree and initiate or complete the work:

*   [performUnitOfWork](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactFiberScheduler.js#L1056)
*   [beginWork](https://github.com/facebook/react/blob/cbbc2b6c4d0d8519145560bd8183ecde55168b12/packages/react-reconciler/src/ReactFiberBeginWork.js#L1489)
*   [completeUnitOfWork](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactFiberScheduler.js#L879)
*   [completeWork](https://github.com/facebook/react/blob/cbbc2b6c4d0d8519145560bd8183ecde55168b12/packages/react-reconciler/src/ReactFiberCompleteWork.js#L532)

To demonstrate how they are used, take a look at the following animation of traversing a fiber tree. I’ve used the simplified implementation of these functions for the demo. Each function takes a fiber node to process and as React goes down the tree you can see the currently active fiber node changes. You can clearly see on the video how the algorithm goes from one branch to the other. It first completes the work for children before moving to parents.

![](https://cdn-images-1.medium.com/max/800/1*A3-yF-3Xf47nPamFpRm64w.gif)

[Here’s the link to the video](https://vimeo.com/302222454) where you can pause the playback and inspect the current node and the state of functions. Conceptually, you can think of “begin” as “stepping into” a component, and “complete” as “stepping out” of it. You can also [play with the example and the implementation here](https://stackblitz.com/edit/js-ntqfil?file=index.js) as I explain what these functions do.

Let’s start with the first two functions `**performUnitOfWork**` and `**beginWork**`:

```
function performUnitOfWork(workInProgress) {
    let next = beginWork(workInProgress);
    if (next === null) {
        next = completeUnitOfWork(workInProgress);
    }
    return next;
}

function beginWork(workInProgress) {
    console.log('work performed for ' + workInProgress.name);
    return workInProgress.child;
}
```

The function `**performUnitOfWork**` receives a fiber node from the `**workInProgress**`  tree and starts the work by calling `**beginWork**`  function. This is function that will start all the activities that need to be performed for a fiber. For the purposes of this demonstration, we simply log the name of the fiber to denote that the work has been done. **The function** `**beginWork**` **always returns a pointer to the next child to process in the loop or** `**null**`**.**

If there’s a next child, it will be assigned to the variable `**nextUnitOfWork**` in the `**workLoop**`  function. However, if there’s no child, React knows that it reached the end of the branch and so it can complete the current node. **Once the node is completed, it’ll need to perform work for siblings and backtrack to parent after that.** This is done in the `**completeUnitOfWork**` function:

```
function completeUnitOfWork(workInProgress) {
    while (true) {
        let returnFiber = workInProgress.return;
        let siblingFiber = workInProgress.sibling;

        nextUnitOfWork = completeWork(workInProgress);

        if (siblingFiber !== null) {
            // If there is a sibling, return it
            // to perform work for this sibling
            return siblingFiber;
        } else if (returnFiber !== null) {
            // If there's no more work in this returnFiber,
            // continue the loop to complete the parent.
            workInProgress = returnFiber;
            continue;
        } else {
            // We've reached the root.
            return null;
        }
    }
}

function completeWork(workInProgress) {
    console.log('work completed for ' + workInProgress.name);
    return null;
}
```

You can see that the gist of the function is a big `**while**` loop. React gets into this function when a `**workInProgress**` node has no children. After completing the work for the current fiber, it checks if there’s a sibling. If found, React exits the function and returns the pointer to the sibling. It will be assigned to the `**nextUnitOfWork**` variable and React will perform the work for the branch starting with this sibling. It’s important to understand that at this point React has only completed work for the preceding siblings. It hasn’t completed work for the parent node. **Only once all branches starting with child nodes are completed, it completes work for the parent node and backtracks.**

As you can see from the implementation, both `**performUnitOfWork**` and `**completeUnitOfWork**` are used mostly for iteration purposes, whereas the main activities take place in the `**beginWork**` and `**completeWork**`  functions. In the following articles in the series we’ll learn what happens for the `**ClickCounter**` component and the `**span**` node as React steps into `**beginWork**` and `**completeWork**` functions.

#### Commit phase

The phase begins with the function [completeRoot](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactFiberScheduler.js#L2306). This is where React updates the DOM and calls pre and post mutation lifecycle methods.

When React gets to this phase, it has 2 trees and the effects list. First tree represents the state currently rendered on the screen. Then there’s an alternate tree built during `**render**` phase. It’s called `**finishedWork**` or `**workInProgress**` in the sources and represents the state that needs to be reflected on the screen. This alternate tree is linked similarly to the current tree through the `**child**` and `**sibling**` pointers.

And then, there’s an effects list —a subset of nodes from the `**finishedWork**`  tree linked through the `**nextEffect**` pointer. Remember that the effect list is the _result_ of running the `**render**` phase. The whole point of rendering was to determine which nodes need to be inserted, updated, or deleted, and which components need to have their lifecycle methods called. And that’s what the effect list tells us. **And it’s exactly the set of nodes that’s iterated during the commit phase.**

> For debugging purposes, the `**current**` tree can be accessed through the `**current**` property of the fiber root. The `**finishedWork**` tree can be accessed through the `**alternate**` property of the `**HostFiber**` node in the current tree.

The main function that runs during the commit phase is [commitRoot](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactFiberScheduler.js#L523). Basically, it does the following:

*   Calls the `**getSnapshotBeforeUpdate**` lifecycle method on nodes tagged with the `**Snapshot**`  effect
*   Calls the `**componentWillUnmount**`  lifecycle method on nodes tagged with the `**Deletion**` effect
*   Performs all the DOM insertions, updates and deletions
*   Sets the `**finishedWork**`  tree as current
*   Calls `**componentDidMount**` lifecycle method on nodes tagged with the `**Placement**` effect
*   Calls `**componentDidUpdate**`  lifecycle method on nodes tagged with the `**Update**` effect

After calling the pre-mutation method `**getSnapshotBeforeUpdate**`, React commits all the side-effects within a tree. It does it in two passes. The first pass performs all DOM (host) insertions, updates, deletions and ref unmounts. Then React assigns the `**finishedWork**` tree to the `**FiberRoot**` marking the `**workInProgress**` tree as the `**current**`  tree. This is done after the first pass of the commit phase, so that the previous tree is still current during `**componentWillUnmount**`, but before the second pass, so that the finished work is current during `**componentDidMount/Update**`. In the second pass React calls all other lifecycle methods and ref callbacks. These methods are executed as a separate pass so that all placements, updates, and deletions in the entire tree have already been invoked.

Here’s the gist of the function that runs the steps described above:

```
function commitRoot(root, finishedWork) {
    commitBeforeMutationLifecycles()
    commitAllHostEffects();
    root.current = finishedWork;
    commitAllLifeCycles();
}
```

Each of those sub-functions implements a loop that iterates over the list of effects and checks the type of effects. When it finds the effect pertaining to the function’s purpose, it applies it.

#### Pre-mutation lifecycle methods

Here is, for example, the code that iterates over an effects tree and checks if a node has the `**Snapshot**`  effect:

```
function commitBeforeMutationLifecycles() {
    while (nextEffect !== null) {
        const effectTag = nextEffect.effectTag;
        if (effectTag & Snapshot) {
            const current = nextEffect.alternate;
            commitBeforeMutationLifeCycles(current, nextEffect);
        }
        nextEffect = nextEffect.nextEffect;
    }
}
```

For a class component, this effect means calling the `**getSnapshotBeforeUpdate**` lifecycle method.

#### DOM updates

[commitAllHostEffects](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactFiberScheduler.js#L376) is the function where React performs DOM updates. The function basically defines the type of operation that needs to be done for a node and executes it:

```
function commitAllHostEffects() {
    switch (primaryEffectTag) {
        case Placement: {
            commitPlacement(nextEffect);
            ...
        }
        case PlacementAndUpdate: {
            commitPlacement(nextEffect);
            commitWork(current, nextEffect);
            ...
        }
        case Update: {
            commitWork(current, nextEffect);
            ...
        }
        case Deletion: {
            commitDeletion(nextEffect);
            ...
        }
    }
}
```

It’s interesting that React calls the `**componentWillUnmount**`  method as part of the deletion process in the `**commitDeletion**` function.

#### Post-mutation lifecycle methods

[commitAllLifecycles](https://github.com/facebook/react/blob/95a313ec0b957f71798a69d8e83408f40e76765b/packages/react-reconciler/src/ReactFiberScheduler.js#L465) is the function where React calls all remaining lifecycle methods. In the current implementation of React the only post mutation method is `**componentDidUpdate**`.

* * *

We’re finally done. Let me know what you think about the article or ask questions in the comments. I have many more articles in the works providing in-depth explanation for scheduler, children reconciliation process and how effects list is built. I also have plans to create a video where I’ll show how to debug the application using this article as a basis.

**For more insights follow me on [Twitter](https://twitter.com/maxim_koretskyi) and on [Medium](https://medium.com/@maxim.koretskyi).** Thanks for reading! If you liked this article, hit that clap button below 👍. It means a lot to me and it helps other people see the story.

Thanks to [Dan Abramov](https://medium.com/@dan_abramov?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
