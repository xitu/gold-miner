> * 原文地址：[Dragging React performance forward](https://medium.com/@alexandereardon/dragging-react-performance-forward-688b30d40a33)
> * 原文作者：[Alex Reardon](https://medium.com/@alexandereardon?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/dragging-react-performance-forward.md](https://github.com/xitu/gold-miner/blob/master/TODO/dragging-react-performance-forward.md)
> * 译者：
> * 校对者：

# **Dragging React performance forward**

![](https://cdn-images-1.medium.com/max/800/1*I6CQ27V59uP_i7p1liMFtA.jpeg)

Photo by [James Padolsey](https://unsplash.com/photos/6JCANHNBNGw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/collections/1584252/drag-blog?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).

I work on a drag and drop library for [React](https://reactjs.org/): [**react-beautiful-dnd**](https://github.com/atlassian/react-beautiful-dnd) 🎉. The goal of the [Atlassian](https://medium.com/@Atlassian) library is to provide a beautiful and accessible drag and drop experience for lists on the web. You can read the introduction blog here: [Rethinking drag and drop](https://medium.com/@alexandereardon/rethinking-drag-and-drop-d9f5770b4e6b). The library is **completely driven by state** — user inputs result in state changes which then updates what the user sees. This conceptually allows for dragging with any input type. Doing state driven dragging at scale is full of performance traps. 🦑

We recently released `[version 4](https://github.com/atlassian/react-beautiful-dnd/releases/tag/v4.0.0)` of react-beautiful-dnd which contained some **massive performance improvements**

![](https://cdn-images-1.medium.com/max/800/1*cn48EAW1k9TcDpfTtkySog.png)

Based on configurations with 500 draggable items. Recording was done using development builds and with instrumentation enabled — both of which slows things down. However, the recording was also done on a fairly powerful development machine. Exact improvements will vary depending on size of data set, device performance and so on.

You read correctly, **we saw performance improvements of** **99%** 🤘.The improvements are even more impressive given that the library was already [extremely optimised](https://github.com/atlassian/react-beautiful-dnd#performance). You can have a play with the improvements for yourself on our [large list example](https://react-beautiful-dnd.netlify.com/iframe.html?selectedKind=single%20vertical%20list&selectedStory=large%20data%20set) or [large board example](https://react-beautiful-dnd.netlify.com/iframe.html?selectedKind=board&selectedStory=large%20data%20set) 😎.

* * *

In this blog I will explore the performance challenges that we faced and how we overcame them to get such impressive results. The solutions that I will talk about are very tailored for our problem domain. There are some principles and techniques that will emerge — but the specifics might be different across problem domains.

Some of the techniques I describe in this blog are fairly advanced and the majority of them would be best to be used within the boundaries of a React library rather than directly in your React applications.

### TLDR;

Hey we are all super busy! Here is a really high level overview of this blog:

Avoid `render` calls as much as possible. In addition to previously explored techniques ([round 1](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-b453c597b191), [round 2](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-round-2-2042e5c9af97)), here are some new learnings for me:

*   Avoid using props for message passing
*   Calling `render` is not the only way you can update styles
*   Avoid offscreen work
*   Batch related Redux state updates if you can

### State management

react-beautiful-dnd uses [Redux](https://redux.js.org/docs/introduction/) under the hood for a big part of it’s state management. It is an implementation detail and consumers of the library are welcome to use whatever state management they like. A lot of the specifics in this blog are geared towards Redux applications — however, there are general techniques that are universally applicable. For the purpose of clarity here are some terms for those unfamiliar with Redux:

*   _store:_ a global state container — usually put on the `[context](https://reactjs.org/docs/context.html)` so that _connected components_ can subscribe to updates
*   _connected components_: components that have direct subscriptions to the _store_. Their responsibility is to respond to state updates in the store and pass props onto unconnected components. These are commonly referred to as _smart or container_ components
*   _unconnected components_: components that are not aware of Redux at all. They are often wrapped by connected components to hydrate them with props from the state. These are commonly referred to as _dumb_ or _presentational_ components

_Here is some_ [_more detailed information_](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0) _on these concepts from_ [_Dan Abramov_](https://medium.com/@dan_abramov) _if you are interested._

### First principles

![Snipaste_2018-03-10_19-58-28.png](https://i.loli.net/2018/03/10/5aa3c874e327e.png)

When it comes to React performance as a general rule you want to avoid calling a component’s `render()` function as much as possible. A `render` call can be expensive due to:

*   Heavy processing in `render` functions.
*   Reconciliation

[Reconciliation](https://reactjs.org/docs/reconciliation.html) is the process where React builds up a new tree and then _reconciles it_ with its current view of the world (the virtual DOM) — performing actual DOM updates if required. A reconciliation is triggered after a component calls `render`.

`render` function processing and reconciliation is expensive at scale. If you have 100’s or 10,000’s of components you probably do not want each component reconciling on every update to shared state in a `store`. Ideally only the components that **need** to update have their `render` function called. This is especially true for drag and drop where we are pushing for 60 updates per second (60fps).

I explore techniques for avoiding unnecessary `render` calls in two blogs I have previously written ([round 1](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-b453c597b191), [round 2](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-round-2-2042e5c9af97)) and the React docs [talk on this subject](https://reactjs.org/docs/optimizing-performance.html) also. As with everything there is a balance to be struck, if you are too aggressive with avoiding `render` you can introduce a lot of potentially redundant memoization checks. This topic has been covered [elsewhere](https://cdb.reacttraining.com/react-inline-functions-and-performance-bdff784f5578) so I will not go into any more detail here.

In addition to `render` costs, when using Redux the more connected components you have the more state queries (`[mapStateToProps](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options)`) and memoization checks you need to run on every update. I talk about state queries, selectors and memoization relevant to Redux in detail in the [round 2 blog](https://medium.com/@alexandereardon/performance-optimisations-for-react-applications-round-2-2042e5c9af97#.zflzltn15).

### Problem 1: A long pause before a drag starts

![](https://cdn-images-1.medium.com/max/800/1*tgrL8LuY9xY46qFo7HhuLQ.gif)

Notice the difference in time from when the mouse down circle appears and when the card turns green. Yuck!

When lifting an item in a big list it would take considerable time for the drag to start, in a list of 500 items this was **2.6 seconds 😢**! This is a terrible experience for users who rightly expect drag and drop interactions to be instant. Let’s take a look at what was going on, and a few techniques we used to overcome the issue.

### Issue 1: Naive dimension publishing

In order to perform a drag we took a snapshot of the dimensions (coordinates, sizes, margins and so on) of all the relevant components and put them into our `state` and the beginning of a drag. We would then use this information during the drag to calculate what needs to move. Let’s take a look at how we did this initial snapshot:

1.  When we start a drag we put a `request` on the `state`
2.  _Connected_ dimension publishing components read this `request` and see if they need to publish anything
3.  If they need to publish they set a `shouldPublish` prop on the _unconnected_ dimension publisher
4.  The _unconnected_ dimension publisher collects the dimensions from the DOM and publishes them using a `publish` callback

Okay, so here are some of the pain points:

> 1. When we start a drag we put a `request` on the `state`
> 2. Connected dimension publishing components read this request and see if they need to publish anything

At this point every connected dimension publisher needs to execute a check against the store to see if they need to request dimensions. Not ideal, but not terrible. Let’s move on

> 3. If they need to publish they set a `shouldPublish` prop on the unconnected dimension publisher

We were using a `shouldPublish` prop to _pass a message_ to a component to perform an action. An unfortunate by-product of this is that it would cause a `render` of the component — which would cause a reconciliation of itself and it’s children. When you do this for a lot of components it is expensive.

> 4. The _unconnected_ dimension publisher collects the dimensions from the DOM and publishes them using a `publish` callback

There is where things get even **worse**. First off, we would read a lot of dimensions from the DOM at once which can take a bit of time. From there each dimension publisher would individually `publish` a dimension. These dimensions would get stored on the `state`. This change in `state` would cause store subscriptions to fire which would execute the connected component state queries and memoization checks in step 2\. It would also cause other connected components in the application to similarly run redundant checks. So whenever an unconnected dimension publisher published a dimension it would cause redundant work for all of the other connected components. It was a `O(n²)` algorithm — or worse! Ouch.

#### The dimension marshal

To get around these problems we created a new actor to manage the dimension collecting flow: a `dimension marshal`. Here is how the new dimension publishing works now:

Pre drag work:

1.  We create a `dimension marshal` and put it on the `[context](https://reactjs.org/docs/context.html)`
2.  When a dimension publisher mounts into the DOM it reads the `dimension marshal` off the `context` and registers itself with the `dimension marshal`. Dimension publishers no longer watch the store directly. As such there is no more unconnected dimension publisher.

Drag start work:

1.  When we start a drag we put a `request` on the `state` **_(unchanged)_**
2.  The `dimension marshal` receives the `request` and directly requests the critical dimensions (the dragging item and its container) from the required dimension publishers for a drag to start. These are published to the store and the drag can start.
3.  The `dimension marshal` then asynchronously requests the dimensions from all the other dimension publishers in a following frame. Doing this splits the cost of collecting dimensions from the DOM and the publishing of the dimensions (next step) into seperate frames.
4.  In another frame the `dimension marshal` performs a batch `publish` of all of the collected dimensions. At this point the state is completely hydrated and it only took three frames.

Other performance advantages of this approach:

*   Fewer state updates which results in less work for all connected components
*   No more connected dimension publishers which means that the processing that was done in these components no longer needs to occur.

Because the `dimension marshal` is aware of all of the `id`s and `index`es in the system it is able to directly request any dimension directly `O(1)`. This also enables it to decide how and when to collect and publish dimensions. Previously we had a single message `shouldPublish` which everything responded to all at once. The `dimension marshal` gives us a lot of flexibility in tuning the performance of this part of the lifecycle. We could even implement different collection algorithms depending on device performance if required.

#### Summary

We improved the performance of dimension collecting by:

*   Not using props to pass messages which had no visible updates.
*   Breaking up work into multiple frames
*   Batching state updates across multiple components

### Issue 2: Style updates

When a drag starts, we need to apply some styles to every `Draggable` (such as `pointer-events: none;`). To do this we were applying an inline style. In order to apply the inline style we needed to `render` every `Draggable`. This had the result of calling `render` on potentially 100’s of `Draggable` items right when the user was trying to start dragging — at the cost of about 350ms for 500 items.

So, how would we go about updating these styles without causing a `render`?

#### Dynamic shared styles 💫

For all `Draggable` components we now apply a shared `data` attribute (eg `data-react-beautiful-dnd-draggable` ). At no point do the `data` attributes change. However, we dynamically change what styles that are applied to these `data` attributes through a **shared style element** that we create in the `head` of the page.

Here is a simplified version of this technique:

```
// Create a new style element
const el = document.createElement('style');
el.type = 'text/css';

// Add it to the head of the document
const head = document.querySelector('head');
head.appendChild(el);

// At some future point we can totally redefine the entire content of the style element
const setStyle = (newStyles) => {
  el.innerHTML = newStyles;
};

// We can apply some styles at one point in the lifecyle
setStyle(`
  [data-react-beautiful-dnd-drag-handle] {
    cursor: grab;
  }
`);

// At another point we can change these styles
setStyle(`
  body {
    cursor: grabbing;
  }
  [data-react-beautiful-dnd-drag-handle] {
    point-events: none;
  }
  [data-react-beautiful-dnd-draggable] {
    transition: transform 0.2s ease;
  }
`);
```

_You can see how we_ [_actually do it_](https://github.com/atlassian/react-beautiful-dnd/blob/0fb4dc75ea9b625f64cac48602635ac2822f26ec/src/view/style-marshal/style-marshal.js) _if you are interested_

At different points of the drag lifecycle we redefine the content of the style rules themselves. You would usually do change styles on an element by toggling a `class`. However, by using dynamic style definitions we can avoid needing to `render` any components to apply a new `class` name 👍

_We use a_ `_data_` _attribute rather than a_ `_class_` _name to make using the library easier for consumers — they do not need to merge our provided_ `_class_` _name with their own_ `_class_` _names._

Using this technique we were also able to optimise other phases in the drag and drop lifecycle. We are now able to update styles items without the need to `render` them.

_Note: you could achieve a similar technique by creating pre-baked style rule sets and then changing a_ `_class_` _on the_ `_body_` _to activate the different rule sets. However, by using our dynamic approach we were able to avoid needing to add_ `_class_`_es on the_ `_body_` _as well as allowing us to have rule sets with different values over time rather that just fixed ones._

Do not fear, the selector performance of `data` attributes [is good](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/) and is orders of magnitude in difference from `render` performance.

### Issue 3: Blocking unwanted drag starts

When a drag started we also called `render` on a `Draggable` to update a `canLift` prop to `false`. This was used to prevent the starting of a new drag at particular times in the drag lifecycle. We need this prop as there are some combinations of mouse and keyboard inputs that can allow a user to start a drag while already dragging something else. We still really needed this `canLift` check — but how could we do it without calling `render` on all of the `Draggables`?

#### State hydrated context function

Rather than updating a prop to each `Draggable` through a `render` to stop a drag from occurring, we added a `canLift` function onto the `context`. This function was able to get to the current state from the store and execute the required checks. In this way we were able to execute the same checks but without needing to update a `Draggable`'s props.

_This code is drastically simplified, but it illustrates the approach_

```
import React from 'react';
import PropTypes from 'prop-types';
import createStore from './create-store';

class Wrapper extends React.Component {
 // Putting the canLiftFn on the context 
 static childContextTypes = {
   canLiftFn: PropTypes.func.isRequired,
 }

 getChildContext(): Context {
   return {
    canLiftFn: this.canLift,
   };
 }

 componentWillMount() {
   this.store = createStore();
 }

 canLift = () => {
   // At this location we have access to the store
   // so we can perform the required checks
   return this.store.getState().canDrag;
 }
 
 // ...
}

class DraggableHandle extends React.Component {
  static contextTypes = {
    canLiftFn: PropTypes.func.isRequired,
  }

  // we can use this to check if the we are allowed to start a drag
  canStartDrag() {
    return this.context.canLiftFn();
  }

  // ...
}
```

It is probably obvious that you only want to do this very sparingly. However, we found it to be a really useful way of providing store hydrated information to components _without_ updating their props. Given that this check happens in response to a user input and has no rendering implications we were able to get away with it.

### No more long pause before a drag starts

![](https://cdn-images-1.medium.com/max/800/1*RTkP4pJmX_4eGQUzkUVTIw.gif)

Starting a drag with 500 items now occurs instantly.

By using the techniques outlined above we where able to bring the time to start dragging down from 2.6s with 500 draggable items to 15ms (within a single frame) which is a **reduction of 99% 😍!**

### Problem 2: Slow displacement

![](https://cdn-images-1.medium.com/max/800/1*xio-0VMqqAzA2t45_Uzkzw.gif)

Frame rate drop when displacing large amount of items.

When moving from one big list to another there was a significant frame rate drop. Moving into a new list would cost about 350ms for when there are 500 draggable items.

### Issue 1: Too much movement

One of the core design features of react-beautiful-dnd is that items naturally move out of the way of other items while a drag is occurring. However, when you move into a new list you can often be displacing large amounts of items all at the one time. If you move to the top of a list it would need to push down everything in the whole list to make room. The offscreen css transitions themselves are [not too expensive](https://codepen.io/alexreardon/full/Ozwxqa/). However, communicating with the `Draggables` to tell them to move out of the way is done through a `render` which is expensive to do for lots of items all at once.

#### Virtualised displacement

Rather than displacing items that the user cannot see, we now only move things that are partially visible to the user. So items that are completely invisible are not moved. This drastically reduces the amount of work we need to do when moving into a big list as we only need to `render` the visible draggable items.

When detecting what is visible we need to consider the current browser viewport as well as scroll containers (elements with their own scrollbars). Once the user scrolls we update the displacement based on what is now visible. There were some complications in ensuring that this displacement looks correct as the user scrolls. They should not be able to tell that we are not moving items that are not visible. Here are some rules we came up with to create an experience that looks correct to the user.

*   If an item needs to move and it is visible: move the item and animate its movement
*   If an item needs to move but it it invisible: do not move it
*   If an item needs to move and is visible and it previously needed to move but was invisible: move it but do not animate its movement.

Because we are only displacing visible items, it now does not matter how big the list you are moving into is from a performance perspective, as we only move the items that the user can see.

#### Why not use virtualised lists?

![](https://cdn-images-1.medium.com/max/800/1*IC1HCd7gv48oIEnKazC0Gg.gif)

An example of a 10,000 item virtual list from [react-virtualized](https://github.com/bvaughn/react-virtualized).

Avoiding offscreen work is a difficult task and the techniques you use will be different depending on your application. We wanted to avoid moving and animating already mounted elements that are not visible during a drag and drop interaction. This is different to avoiding rendering offscreen components completely using some sort of virtualisation solution such as [react-virtualized](https://github.com/bvaughn/react-virtualized). Virtualisation is amazing, but adds considerable complexity to a code base. It also breaks some native browser functionality such as printing and finding (`command / control + f`). Our decision was to provide great performance for React applications even when they are not using virtualised lists. This makes it really easy to add beautiful, performant drag and drop to your existing applications with very little overhead. That said, we are planning on [supporting virtualised lists](https://github.com/atlassian/react-beautiful-dnd/issues/68) as well — so consumers will be able to choose if they want to use virtualised lists to reduce big list `render` times. This would be useful if you had lists comprised of 1000’s of items.

### Issue 2: Droppable updates

When a user drags over a `Droppable` list we let the consumer know by updating a `isDraggingOver` property. However, doing this causes a `render` of a `Droppable` — which in turn causes a `render` on all its children — which could be 100’s of `Draggable` items!

#### We do not control a consumers children

To avoid this we created a performance optimisation [recommendation in the docs](https://github.com/atlassian/react-beautiful-dnd#recommended-droppable-performance-optimisation) for consumers of react-beautiful-dnd to avoid rendering the children of a `Droppable` if it is unneeded. The library itself does not control the rendering of a `Droppable`'s children and so the best we can do is offer a suggested optimisation. This suggestion allows users to style a `Droppable` in response to being dragged over, while avoiding calling `render` on all of its children.

```
import React, { Component } from 'react';

class Student extends Component<{ student: Person }> {
  render() {
    // Renders out a draggable student
  }
}

class InnerList extends Component<{ students: Person[] }> {
  // do not re-render if the students list has not changed
  shouldComponentUpdate(nextProps: Props) {
    if(this.props.students === nextProps.students) {
      return false;
    }
    return true;
  }
  // You could also not do your own shouldComponentUpdate check and just
  // extend from React.PureComponent

  render() {
    return this.props.students.map((student: Person) => (
      <Student student={student} />
    ))
  }
}

class Students extends Component {
  render() {
    return (
      <Droppable droppableId="list">
        {(provided: DroppableProvided, snapshot: DroppableStateSnapshot) => (
          <div
            ref={provided.innerRef}
            style={{ backgroundColor: provided.isDragging ? 'green' : 'lightblue' }}
          >
            <InnerList students={this.props.students} />
            {provided.placeholder}
          </div>
        )}
      </Droppable>
    )
  }
}
```

### Instant displacement

![](https://cdn-images-1.medium.com/max/800/1*zwqHyu4wDUTY7Pa4yEdZCA.gif)

Butter smooth movement between large lists.

By implementing these optimisations we were able to reduce the time to move between lists comprised of 500 items with large amounts of displacement from 380ms to 8ms — a single frame! **Another 99% reduction**

### Other: lookup tables

_This optimisation is not specific to React — but it was useful when dealing with ordered lists_

In react-beautiful-dnd we often use arrays to store ordered data. However, we also want to do fast lookups of this data to retrieve an entry, or to see if an entry exists. Normally you would need to do an `array.prototype.find` or something similar to get the entry from the list. If you are doing this a lot this can be punishing for large arrays.

![Snipaste_2018-03-10_20-03-13.png](https://i.loli.net/2018/03/10/5aa3c987332f2.png)

There are lot of techniques and tools to get around this problem (including [normalizr](https://github.com/paularmstrong/normalizr)). A common approach is to store your data in an`Object` map and have an array of `id`’s to maintain the order. This is such a great optimisation and speeds things up a lot if you need to regularly look up values in a list.

We did things a little differently. We use `[memoize-one](https://github.com/alexreardon/memoize-one)` (a memoization function which only remembers the latest arguments) to create lazy `Object` maps for instant lookups where needed. The idea is that you create a function that takes an `Array` and returns a `Object` map. If you pass the same array to the function multiple times, you return the previously computed `Object` map. If the array changes, you recompute the map. This lets you have an instant lookup table without needing to recompute it regularly or needing to explicitly store it in your `state`.

```
const getIdMap = memoizeOne((array) => {
  return array.reduce((previous, current) => {
   previous[current.id] = array[current];
   return previous;
  }, {});
});

const foo = { id: 'foo' };
const bar = { id: 'bar' };

// our lovely ordered structure
const ordered = [ foo, bar ];

// lazily computed map for fast lookups
const map1 = getMap(ordered);

map1['foo'] === foo; // true
map1['bar'] === bar; // true
map1['baz'] === undefined; // true

const map2 = getMap(ordered);
// returned the same map as before - no recomputation required
const map1 === map2;
```

Using look up tables drastically sped up drag movements where we were checking if an item was present in an array in every connected `Draggable` component on every drag update (`O(n²)` across the system). By using this approach we are able to compute a `Object` map once per `state` change and let the connected `Draggable` components use a shared map for `O(1)` lookups.

### Final words ❤️

I hope you have found this blog useful in thinking about some optimisations you could apply to your own libraries and applications. Check out [react-beautiful-dnd](https://github.com/atlassian/react-beautiful-dnd) for yourself and have a play with [our examples](https://react-beautiful-dnd.netlify.com).

Thank you to [Jared Crowe](https://medium.com/@jaredjcrowe) and [Sean Curtis](https://medium.com/@seancurtis) for their assistance in coming up with the optimisations and [Daniel Kerris](https://medium.com/@DanielKerris), [Jared Crowe](https://medium.com/@jaredjcrowe), [Marcin Szczepanski](https://medium.com/@mszczepanski), [Jed Watson](https://medium.com/@jedwatson), [Cameron Fletcher](https://medium.com/@cameronfletcher92), [James Kyle](https://medium.com/@thejameskyle), Ali Chamas and other assorted [Atlassian](https://medium.com/@Atlassian)’s for their help putting this blog together.

### Recording

I gave a talk which goes over the main points of this blog at [React Sydney](https://twitter.com/reactsydney).

YouTube 视频链接：[这儿](https://youtu.be/3REMkuIg23k)

Dragging React performance forward at React Sydney.

Thanks to [Marcin Szczepanski](https://medium.com/@mszczepanski?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
