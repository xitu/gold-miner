> * 原文地址：[React 16 Lifecycle Methods: How and When to Use Them](https://blog.bitsrc.io/react-16-lifecycle-methods-how-and-when-to-use-them-f4ad31fb2282)
> * 原文作者：[Scott Domes](https://medium.com/@scottdomes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-16-lifecycle-methods-how-and-when-to-use-them.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-16-lifecycle-methods-how-and-when-to-use-them.md)
> * 译者：
> * 校对者：

# React 16 Lifecycle Methods: How and When to Use Them

#### A revised and up-to-date guide to the new React component lifecycle

![](https://cdn-images-1.medium.com/max/5000/1*bqLzlcQEU8e7yWQ3tKSaxQ.png)

Since [my first article](https://engineering.musefind.com/react-lifecycle-methods-how-and-when-to-use-them-2111a1b692b1) on this subject, the React component API has changed significantly. Some lifecycle methods have been deprecated, and some new ones have been introduced. So it’s time for an update!

(See how I resisted making a `shouldArticleUpdate` joke? That’s restraint.)

Since the lifecycle API is a bit more complex this time around, I’ve split the methods into four sections: mounting, updating, unmounting, and errors.

If you’re not super comfortable with React, [my article](https://medium.freecodecamp.org/everything-you-need-to-know-about-react-eaedf53238c4) here provides a thorough intro.

**Tip**:

Build React apps faster with a collection of reusable components. Use **[Bit](https://github.com/teambit/bit)** to share your components and use them to build new apps. Give it a try.

![Discovery, try, use React omponents with Bit](https://cdn-images-1.medium.com/max/2726/1*pqRT9FOXRyCYMWB3WSUEjg.png)

[**Component Discovery and Collaboration · Bit**](https://bit.dev/)

## The Problem

Our example app for this tutorial is going to simple: a grid of blocks, each with a random size, arranged into a masonry layout (think Pinterest).

Every couple of seconds, a new bunch of blocks load at the bottom of the page, and need to be arranged.

You can view the final app [here](https://blissful-ptolemy-8b66a6.netlify.com/), and its code [here](https://github.com/scottdomes/react-lifecycle-example).

Not a complex idea, but here’s the wrinkle: we’re going to be using the [bricks.js library](http://callmecavs.com/bricks.js/) to align our grid.

Brick.js is a great tool, but it’s not optimized for integrating with React. It is better suited for vanilla JavaScript or jQuery.

So why are we using it? Well, this is a common use case for lifecycle methods: **to integrate non-React tools into the React paradigm**.

Sometimes, the best library for the job won’t be the easiest one to work with. Lifecycle methods help bridge that gap.

---

## One last note before we dive in

As alluded to above, lifecycle methods are a last resort.

They’re to be used in **special** cases, when other fallbacks like rearranging your components or moving your state around won’t work.

Lifecycle methods (with the exception of `constructor`) are hard to reason about. They add complexity to your app. Don’t use them unless you must.

That said, let’s check them out.

## Mounting

#### constructor

The first thing that gets called is your component constructor, **if** your component is a class component. This does not apply to functional components.

Your constructor might look like so:

```JavaScript
class MyComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      counter: 0,
    };
  }
}
```

The constructor gets called with the component props. **You must call `super` and pass in the props.**

You can then initialize your state, setting the default values. You can even base the state on the props:

```JavaScript
class MyComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      counter: props.initialCounterValue,
    };
  }
}
```

Note that using a constructor is optional, and you can initialize your state like so if your Babel setup has support for [class fields](https://github.com/tc39/proposal-class-fields):

```JavaScript
class MyComponent extends Component {
  state = {
    counter: 0,
  };
}
```

**This approach is widely preferred.** You can still base your state off props:

```JavaScript
class MyComponent extends Component {
  state = {
    counter: this.props.initialCounterValue,
  };
}
```

You may still need a constructor, though, if you need to use a [ref](https://reactjs.org/docs/refs-and-the-dom.html). Here’s an example from our grid app:

```JavaScript
class Grid extends Component {
  constructor(props) {
    super(props);
    this.state = {
      blocks: [],
    };
    this.grid = React.createRef();
  }
```

We need the constructor to call `createRef`, to create a reference to the grid element, so we can pass it to `bricks.js`.

You can also use the constructor for function binding, which is also optional. See [here](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56) for more:

[**React Binding Patterns: 5 Approaches for Handling `this`**](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)

**Most Common Use Case For Constructor:** Setting up state, creating refs and method binding.

#### getDerivedStateFromProps

When mounting, `getDerivedStateFromProps` is the last method called before rendering. You can use it to set state according to the initial props. Here’s the code from the example `Grid` component:

```JavaScript
static getDerivedStateFromProps(props, state) {
  return { blocks: createBlocks(props.numberOfBlocks) };
}
```

We look at the `numberOfBlocks` prop, and then use that to create a set of randomly sized blocks. We then return our desired state object.

Here’s what calling `console.log(this.state)` afterwards looks like:

```JavaScript
console.log(this.state);
// -> {blocks: Array(20)}
```

Note that we could have placed this code in the `constructor`. The advantage of `getDerivedStateFromProps` is that it is more intuitive—it’s **only** meant for setting state, whereas a constructor has multiple uses. `getDerivedStateFromProps` is also called both before mount and before updating, as we’ll see in a bit.

**Most Common Use Case For getDerivedStateFromProps (during mount):** Returning a state object based on the initial props.

#### render

Rendering does all the work. It returns the JSX of your actual component. When working with React, you’ll spend most of your time here.

**Most Common Use Case For Render:** Returning component JSX**.**

#### componentDidMount

After we’ve rendered our component for the first time, this method is called.

If you need to load data, here’s where you do it. Don’t try to load data in the constructor or render or anything crazy. I’ll let [Tyler McGinnis](https://twitter.com/tylermcginnis33) explain why:

> You can’t guarantee the AJAX request won’t resolve before the component mounts. If it did, that would mean that you’d be trying to setState on an unmounted component, which not only won’t work, but React will yell at you for. Doing AJAX in componentDidMount will guarantee that there’s a component to update.

You can read more of his answer [here](https://tylermcginnis.com/react-interview-questions/).

`componentDidMount` is also where you can do all the fun things you couldn’t do when there was no component to play with. Here are some examples:

* draw on a \<canvas> element that you just rendered
* initialize a [masonry](http://masonry.desandro.com/) grid layout from a collection of elements (that’s us!)
* add event listeners

Basically, here you want to do all the setup you couldn’t do without a DOM, and start getting all the data you need.

Here’s our example app:

```JavaScript
componentDidMount() {
    this.bricks = initializeGrid(this.grid.current);
    layoutInitialGrid(this.bricks)

    this.interval = setInterval(() => {
      this.addBlocks();
    }, 2000);
  }
```

We use the `bricks.js` library (called from the `initializeGrid` method) to create and arrange the grid.

We then set an interval to add more blocks every two seconds, mimicking the loading of data. You can imagine this being a `loadRecommendations` call or something in the real world.

**Most Common Use Case for componentDidMount:** Starting AJAX calls to load in data for your component.

## Updating

#### getDerivedStateFromProps

Yep, this one again. Now, it’s a bit more useful.

If you need to update your state based on a prop changing, you can do it here by returning a new state object.

**Again, hanging state based on props is not recommended.** It should be considered a last resort. Ask yourself—do I need to store state? Can I not just derive the right functionality from the props themselves?

That said, edge cases happen. Here’s some examples:

* resetting a video or audio element when the source changes
* refreshing a UI element with updates from the server
* closing an accordion element when the contents change

Even with the above cases, there’s usually a better way to do it. But `getDerivedStateFromProps` will have your back when worst comes to worst.

With our example app, let’s say our `Grid` component’s `numberOfBlocks` prop increases. But we’ve already “loaded” past more blocks than the new amount. There’s no point using the same value. So we do this:

```JavaScript
static getDerivedStateFromProps(props, state) {
  if (state.blocks.length > 0) {
    return {};
  }

  return { blocks: createBlocks(props.numberOfBlocks) };
}
```

If the current number of blocks we have in state exceeds the new prop, we don’t update state at all, returning an empty object.

(One last point about `static` methods like `getDerivedStateFromProps`: you don’t have access to the component via`this`. So we couldn’t access our grid ref, for example.)

**Most Common Use Case:** Updating state based on props, when the props themselves aren’t enough.

#### shouldComponentUpdate

We have new props. Typical React dogma says that when a component receives new props, or new state, it should update.

But our component is a little bit anxious and is going to ask permission first.

Here’s what we get — a `shouldComponentUpdate` method, called with `nextProps` as the first argument, and `nextState` is the second.

`shouldComponentUpdate` should always return a boolean — an answer to the question, “should I re-render?” Yes, little component, you should. The default is that it always returns true.

But if you’re worried about wasted renders and other nonsense — `shouldComponentUpdate` is an awesome place to improve performance.

I wrote an article on using `shouldComponentUpdate` in this way — check it out:

[**How to Benchmark React Components: The Quick and Dirty Guide**](https://engineering.musefind.com/how-to-benchmark-react-components-the-quick-and-dirty-guide-f595baf1014c)

In the article, we talk about having a table with many many fields. The problem was that when the table re-rendered, each field would also re-render, slowing things down.

`shouldComponentUpdate` allows us to say: only update if the props you care about change.

But keep in mind that it can cause major problems if you set it and forget it, because your React component will not update normally. So use with caution.

In our grid app, we’ve previously established that sometimes we are going to ignore the new value of `this.props.numberOfBlocks`. Default behavior says our component will still rerender, since it received new props. That’s wasteful.

```JavaScript
shouldComponentUpdate(nextProps, nextState) {
  // Only update if bricks change
  return nextState.blocks.length > this.state.blocks.length;
}
```

Now we say: the component should update **only** if the number of blocks in state change.

**Most Common Use Case:** Controlling exactly when your component will re-render.

#### render

Same as before!

#### getSnapshotBeforeUpdate

This method is a fun new addition.

Note it’s called between `render` and the updated component actually being propagated to the DOM. It exists as a last-chance-look at your component with its previous props and state.

Why? Well, there may be a delay between calling `render` and having your changes appear. If you need to know what the DOM is **exactly** at the time of integrating the result of the latest `render` call, here’s where you can find out.

Here’s an example. Let’s say our team lead decided that if a user is at the bottom of our grid when new blocks are loaded, they should be scrolled down to the **new** bottom of the screen.

In other words: when the grid expands, if they’re at the bottom, keep them there.

```JavaScript
getSnapshotBeforeUpdate(prevProps, prevState) {
    if (prevState.blocks.length < this.state.blocks.length) {
      const grid = this.grid.current;
      const isAtBottomOfGrid =
        window.innerHeight + window.pageYOffset === grid.scrollHeight;

      return { isAtBottomOfGrid };
    }

    return null;
  }
```

Here’s what this says: if the user has scrolled to the bottom, return an object like so: `{ isAtBottomOfGrid: true }`. If they aren’t, return `null`.

**You should either return `null` or a value from `getSnapshotBeforeUpdate`.**

Why? We’ll see in a second.

**Most Common Use Case:** Taking a look at some attribute of the current DOM, and passing that value on to `componentDidUpdate`.

#### componentDidUpdate

Now, our changes have been committed to the DOM.

In `componentDidUpdate`, we have access to three things: the previous props, the previous state, and whatever value we returned from `getSnapshotBeforeUpdate`.

Completing the above example:

```JavaScript
componentDidUpdate(prevProps, prevState, snapshot) {
  this.bricks.pack();

  if (snapshot.isAtBottomOfGrid) {
    window.scrollTo({
      top: this.grid.current.scrollHeight,
      behavior: 'smooth',
    });
  }
}
```

First, we re-layout the grid, using the Bricks.js `pack` method.

Then, if our snapshot shows the user was at the bottom of the grid, we scroll them down to the bottom of the new blocks.

**Most Common Use Case for componentDidUpdate:** Reacting (hah!) to committed changes to the DOM.

## Unmounting

#### componentWillUnmount

It’s almost over.

Your component is going to go away. Maybe forever. It’s very sad.

Before it goes, it asks if you have any last-minute requests.

Here you can cancel any outgoing network requests, or remove all event listeners associated with the component.

Basically, clean up anything to do that solely involves the component in question — when it’s gone, it should be completely gone.

In our case, we have one `setInterval` call from `componentDidMount` to tidy up:

```JavaScript
componentWillUnmount() {
  clearInterval(this.interval);
}
```

**Most Common Use Case for componentWillUnmount:** Cleaning up any leftover debris from your component.

## Errors

#### getDerivedStateFromError

Something broke.

Not in your component itself, but one of its descendants.

We want to show an error screen. The easiest way to do so is to have a value like `this.state.hasError`, which gets flipped to `true` at this point.

```JavaScript
static getDerivedStateFromError(error) {
  return { hasError: true };
}
```

Note that you must return the updated state object. Don’t use this method for any side effects. Instead, use the below `componentDidCatch`.

**Most Common Use Case for getDerivedStateFromError:** Updating state to display an error screen.

#### componentDidCatch

Very similar to the above, in that it is triggered when an error occurs in a child component.

The difference is rather than updating state in response to an error, we can now perform any side effects, like logging the error.

```JavaScript
componentDidCatch(error, info) {
  sendErrorLog(error, info);
}
```

`error` would be the actual error message (Undefined Variable blah blah blah ) and `info` would be the stack trace (`In Component, in div, etc`).

**Note that componentDidCatch only works for errors in the render/lifecycle methods. If your app throws an error in a click handler, it will not be caught.**

You would commonly use `componentDidCatch` only in special **error boundary** components. These components wrap a child tree with the sole purpose of catching and logging errors.

For example, this error boundary will catch an error and render an ‘Oops!’ message instead of the child components:

```JavaScript
class ErrorBoundary extends Component {
  state = { errorMessage: null };

  static getDerivedStateFromError(error) {
    return { errorMessage: error.message };
  }

  componentDidCatch(error, info) {
    console.log(error, info);
  }

  render() {
    if (this.state.errorMessage) {
      return <h1>Oops! {this.state.errorMessage}</h1>;
    }

    return this.props.children;
  }
}
```

**Most Common Use Case for componentDidCatch:** Catching and logging errors.

## Conclusion

That’s it! Those are all the lifecycle methods are your disposal.

You can check the example app code [here](https://github.com/scottdomes/react-lifecycle-example) and the final product [here](https://blissful-ptolemy-8b66a6.netlify.com/).

Thanks for reading! Feel free to comment below and ask anything, I’d love to talk.

---

## Learn more

* [**5 Tools for Faster Development in React**](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
* [**Understanding React Render Props and HOC**](https://blog.bitsrc.io/understanding-react-render-props-and-hoc-b37a9576e196)
* [**11 React UI Component Libraries you Should Know in 2019**](https://blog.bitsrc.io/11-react-component-libraries-you-should-know-178eb1dd6aa4)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
