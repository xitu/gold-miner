> * 原文地址：[Redux vs. The React Context API](https://daveceddia.com/context-api-vs-redux/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/context-api-vs-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO1/context-api-vs-redux.md)
> * 译者：
> * 校对者：

# Redux vs. The React Context API

![](https://daveceddia.com/images/context-vs-redux.png)

React 16.3 added a new Context API – _new_ in the sense that the _old_ context API was a behind-the-scenes feature that most people either didn’t know about, or avoided using because the docs said to avoid using it.

Now, though, the Context API is a first-class citizen in React, open to all (not that it wasn’t before, but it’s, like, official now).

As soon as React 16.3 came out there were articles all across the web proclaiming the death of Redux because of this new Context API. If you asked Redux, though, I think it would say “the reports of my death [are greatly exaggerated](https://blog.isquaredsoftware.com/2018/03/redux-not-dead-yet/).”

In this post I want to cover how the new Context API works, how it is similar to Redux, when you might want to use Context _instead of_ Redux, and why Context doesn’t replace the need for Redux in every case.

**If you just want an overview of Context, you can [skip down to that](#how-to-use-the-react-context-api).**

## A Plain React Example

I’m going to assume you’ve got the basics of React down pat (props & state), but if you don’t, take my free 5-day course to learn the basics of React:

Let’s look at an example that would cause most people to reach for Redux. We’ll start with a plain React version, and then see what it looks like in Redux, and finally with Context.

![The component hierarchy](https://daveceddia.com/images/context-v-redux-app-screenshot.png)

This app has the user’s information displayed in two places: in the nav bar at the top-right, and in the sidebar next to the main content.

(You might notice it looks suspiciously like Twitter. Not an accident! One of the best ways to hone your React skills is through [copywork – building replicas of existing apps](https://daveceddia.com/learn-react-with-copywork/))

The component structure looks like this:

![The component hierarchy](https://daveceddia.com/images/context-v-redux-app-tree.png)

With pure React (just regular props), we need to store the user’s info high enough in the tree that it can be passed down to the components that need it. In this case, the keeper of user info has to be `App`.

Then, in order to get the user info down to the components that need it, App needs to pass it along to Nav and Body. They, in turn, need to pass it down _again_, to UserAvatar (hooray!) and Sidebar. Finally, Sidebar has to pass it down to UserStats.

Let’s look at how this works in code (I’m putting everything in one file to make it easier to read, but in reality these would probably be split out into separate files following [some kind of standard structure](https://daveceddia.com/react-project-structure/)).

```
import React from "react";
import ReactDOM from "react-dom";
import "./styles.css";

const UserAvatar = ({ user, size }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
);

const UserStats = ({ user }) => (
  <div className="user-stats">
    <div>
      <UserAvatar user={user} />
      {user.name}
    </div>
    <div className="stats">
      <div>{user.followers} Followers</div>
      <div>Following {user.following}</div>
    </div>
  </div>
);

const Nav = ({ user }) => (
  <div className="nav">
    <UserAvatar user={user} size="small" />
  </div>
);

const Content = () => <div className="content">main content here</div>;

const Sidebar = ({ user }) => (
  <div className="sidebar">
    <UserStats user={user} />
  </div>
);

const Body = ({ user }) => (
  <div className="body">
    <Sidebar user={user} />
    <Content user={user} />
  </div>
);

class App extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    const { user } = this.state;

    return (
      <div className="app">
        <Nav user={user} />
        <Body user={user} />
      </div>
    );
  }
}

ReactDOM.render(<App />, document.querySelector("#root"));
```

[Here’s a working example on CodeSandbox](https://codesandbox.io/s/q8yqx48074).

Here, `App` [initializes the state](https://daveceddia.com/where-initialize-state-react/) to contain the “user” object – in a real app you’d probably [fetch this data from a server](https://daveceddia.com/ajax-requests-in-react/) and keep it in state for rendering.

In terms of prop drilling, this isn’t _terrible_. It works just fine. “Prop drilling” is not discouraged by any means; it’s a perfectly valid pattern and core to the way Reat works. But deep drilling can be a bit annoying to write. And it gets more annoying when you have to pass down a lot of props (instead of just one).

There’s a bigger downside to this “prop drilling” strategy though: it creates coupling between components that would otherwise be decoupled. In the example above, `Nav` needs to accept a “user” prop and pass it down to `UserAvatar`, even though Nav does not have any need for the `user` otherwise.

Tightly-coupled components (like ones that forward props down to their children) are more difficult to reuse, because you’ve gotta wire them up with their new parents whenever you plop one down in a new location.

Let’s look at how we might improve it.

## Before You Reach for Context or Redux…

If you can find a way to _coalesce_ your app structure and take advantage of the `children` prop, it can lead to cleaner code without having to resort to deep prop drilling, _or Context, or Redux_.

The children prop is a great solution for components that need to be generic placeholders, like `Nav`, `Sidebar`, and `Body` in this example. Also know that you can pass JSX elements into _any_ prop, not just the one named “children” – so if you need more than one “slot” to plug components into, keep that in mind.

Here’s a version of the React example where `Nav`, `Body`, and `Sidebar` accept children and render them as-is. This way, the user of the component doesn’t need to worry about passing down specific pieces of data that the component needs – the user can simply render what it needs to, in place, using the data it already has in scope. This example also shows how to use _any_ prop to pass children.

(Thanks to Dan Abramov for [this suggestion](https://twitter.com/dan_abramov/status/1021850499618955272)!)

```
import React from "react";
import ReactDOM from "react-dom";
import "./styles.css";

const UserAvatar = ({ user, size }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
);

const UserStats = ({ user }) => (
  <div className="user-stats">
    <div>
      <UserAvatar user={user} />
      {user.name}
    </div>
    <div className="stats">
      <div>{user.followers} Followers</div>
      <div>Following {user.following}</div>
    </div>
  </div>
);

// Accept children and render it/them
const Nav = ({ children }) => (
  <div className="nav">
    {children}
  </div>
);

const Content = () => (
  <div className="content">main content here</div>
);

const Sidebar = ({ children }) => (
  <div className="sidebar">
    {children}
  </div>
);

// Body needs a sidebar and content, but written this way,
// they can be ANYTHING
const Body = ({ sidebar, content }) => (
  <div className="body">
    <Sidebar>{sidebar}</Sidebar>
    {content}
  </div>
);

class App extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    const { user } = this.state;

    return (
      <div className="app">
        <Nav>
          <UserAvatar user={user} size="small" />
        </Nav>
        <Body
          sidebar={<UserStats user={user} />}
          content={<Content />}
        />
      </div>
    );
  }
}

ReactDOM.render(<App />, document.querySelector("#root"));
```

Here’s the [working example on CodeSandbox](https://codesandbox.io/s/mj19ywz0oy).

If your app is too complex (more complex than this example!), maybe it’s tough to figure out how to adapt the `children` pattern. Let’s see how you might replace the prop drilling with Redux.

## Redux Example

I’m going to go through the Redux example quickly so we can look more deeply at how Context works, so if you are fuzzy on Redux, read my [intro to Redux](https://daveceddia.com/how-does-redux-work/) first (or [watch the video](https://youtu.be/sX3KeP7v7Kg)).

Here’s the React app from above, refactored to use Redux. The `user` info has been moved to the Redux store, which means we can use react-redux’s `connect` function to directly inject the `user` prop into components that need it.

This is a big win in terms of decoupling. Take a look at `Nav`, `Body`, and `Sidebar` and you’ll see that they’re no longer accepting and passing dow the `user` prop. No more playing hot potato with props. No more needless coupling.

The reducer here doesn’t do much; it’s pretty simple. I’ve got more elsewhere about [how Redux reducers work](https://daveceddia.com/what-is-a-reducer/) and [how to write the immutable code](https://daveceddia.com/react-redux-immutability-guide/) that goes in them.

```
import React from "react";
import ReactDOM from "react-dom";

// We need createStore, connect, and Provider:
import { createStore } from "redux";
import { connect, Provider } from "react-redux";

// Create a reducer with an empty initial state
const initialState = {};
function reducer(state = initialState, action) {
  switch (action.type) {
    // Respond to the SET_USER action and update
    // the state accordingly
    case "SET_USER":
      return {
        ...state,
        user: action.user
      };
    default:
      return state;
  }
}

// Create the store with the reducer
const store = createStore(reducer);

// Dispatch an action to set the user
// (since initial state is empty)
store.dispatch({
  type: "SET_USER",
  user: {
    avatar: "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
    name: "Dave",
    followers: 1234,
    following: 123
  }
});

// This mapStateToProps function extracts a single
// key from state (user) and passes it as the `user` prop
const mapStateToProps = state => ({
  user: state.user
});

// connect() UserAvatar so it receives the `user` directly,
// without having to receive it from a component above

// could also split this up into 2 variables:
//   const UserAvatarAtom = ({ user, size }) => ( ... )
//   const UserAvatar = connect(mapStateToProps)(UserAvatarAtom);
const UserAvatar = connect(mapStateToProps)(({ user, size }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
));

// connect() UserStats so it receives the `user` directly,
// without having to receive it from a component above
// (both use the same mapStateToProps function)
const UserStats = connect(mapStateToProps)(({ user }) => (
  <div className="user-stats">
    <div>
      <UserAvatar />
      {user.name}
    </div>
    <div className="stats">
      <div>{user.followers} Followers</div>
      <div>Following {user.following}</div>
    </div>
  </div>
));

// Nav doesn't need to know about `user` anymore
const Nav = () => (
  <div className="nav">
    <UserAvatar size="small" />
  </div>
);

const Content = () => (
  <div className="content">main content here</div>
);

// Sidebar doesn't need to know about `user` anymore
const Sidebar = () => (
  <div className="sidebar">
    <UserStats />
  </div>
);

// Body doesn't need to know about `user` anymore
const Body = () => (
  <div className="body">
    <Sidebar />
    <Content />
  </div>
);

// App doesn't hold state anymore, so it can be
// a stateless function
const App = () => (
  <div className="app">
    <Nav />
    <Body />
  </div>
);

// Wrap the whole app in Provider so that connect()
// has access to the store
ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.querySelector("#root")
);
```

[Here’s the Redux example on CodeSandbox](https://codesandbox.io/s/943yr0qp3o).

Now you might be wondering how Redux achieves this magic. It’s a good thing to wonder. How is it that React doesn’t support passing props down multiple levels, but Redux is able to do it?

The answer is, Redux uses React’s _context_ feature. Not the modern Context API (not yet) – the old one. The one the React docs said not to use unless you were writing a library or knew what you were doing.

Context is like an electrical bus running behind every component: to receive the power (data) passing through it, you need only plug in. And (React-)Redux’s `connect` function does just that.

This feature of Redux is just the tip of the iceberg, though. Passing data around all over the place is just the most _apparent_ of Redux’s features. Here are a few other benefits you get out of the box:

### `connect` is pure

`connect` automatically makes connected components “pure,” meaning they will only re-render when their props change – a.k.a. when their slice of the Redux state changes. This prevents needless re-renders and keeps your app running fast. DIY method: Create a class that extends `PureComponent`, or implement `shouldComponentUpdate` yourself.

### Easy Debugging with Redux

The ceremony of writing actions and reducers is balanced by the awesome debugging power it affords you.

With the [Redux DevTools extension](https://github.com/zalmoxisus/redux-devtools-extension) you get an automatic log of every action your app performed. At any time you can pop it open and see which actions fired, what their payload was, and the state before and after the action occurred.

![Redux devtools demo](https://daveceddia.com/images/redux-devtools.gif)

Another great feature the Redux DevTools enable is _time travel debugging_ a.k.a. you can click on any past action and jump to that point in time, basically replaying every action up to and including that one (but no further). The reason this can work is because each action _immutably_ update’s the state, so you can take a list of recorded state updates and replay them, with no ill effects, and end up where you expect.

Then there are tools like [LogRocket](https://logrocket.com/) that basically give you an always-on Redux DevTools _in production_ for every one of your users. Got a bug report? Sweet. Look up that user’s session in LogRocket and you can see a replay of what they did, and exactly which actions fired. That all works by tapping into Redux’s stream of actions.

### Customize Redux with Middleware

Redux supports the concept of _middleware_, which is a fancy word for “a function that runs every time an action is dispatched.” Writing your own middleware isn’t as hard as it might seem, and it enables some powerful stuff.

For instance…

*   Want to kick off an API request every time an action name starts with `FETCH_`? You could do that with middleware.
*   Want a centralized place to log events to your analytics software? Middleware is a good place for that.
*   Want to prevent certain actions from firing at certain times? You can do that with middleware, transparent to the rest of your app.
*   Want to intercept actions that have a JWT token and save them to localStorage, automatically? Yep, middleware.

Here’s a good article with some [examples of how to write Redux middleware](https://medium.com/@jacobp100/you-arent-using-redux-middleware-enough-94ffe991e6).

## How to Use the React Context API

But hey, maybe you don’t need all those fancy features of Redux. Maybe you don’t care about the easy debugging, the customization, or the automatic performance improvements – all you want to do is pass data around easily. Maybe your app is small, or you just need to get something working and address the fancy stuff later.

React’s new Context API will probably fit the bill. Let’s see how it works.

I published a quick Context API lesson on Egghead if you’d rather watch than read (3:43):

[![Context API lesson on Egghead.io](https://daveceddia.com/images/context-api-egghead-video.png)](https://egghead.io/lessons/react-pass-props-through-multiple-levels-with-react-s-context-api)

There are 3 important pieces to the context API:

*   The `React.createContext` function which creates the context
*   The `Provider` (returned by `createContext`) which establishes the “electrical bus” running through a component tree
*   The `Consumer` (also returned by `createContext`) which taps into the “electrical bus” to extract the data

The `Provider` is very similar to React-Redux’s `Provider`. It accepts a `value` prop which can be whatever you want (it could even be a Redux store… but that’d be silly). It’ll most likely be an object containing your data and any actions you want to be able to perform on the data.

The `Consumer` works a little bit like React-Redux’s `connect` function, tapping into the data and making it available to the component that uses it.

Here are the highlights:

```
// Up top, we create a new context
// This is an object with 2 properties: { Provider, Consumer }
// Note that it's named with UpperCase, not camelCase
// This is important because we'll use it as a component later
// and Component Names must start with a Capital Letter
const UserContext = React.createContext();

// Components that need the data tap into the context
// by using its Consumer property. Consumer uses the
// "render props" pattern.
const UserAvatar = ({ size }) => (
  <UserContext.Consumer>
    {user => (
      <img
        className={`user-avatar ${size || ""}`}
        alt="user avatar"
        src={user.avatar}
      />
    )}
  </UserContext.Consumer>
);

// Notice that we don't need the 'user' prop any more,
// because the Consumer fetches it from context
const UserStats = () => (
  <UserContext.Consumer>
    {user => (
      <div className="user-stats">
        <div>
          <UserAvatar user={user} />
          {user.name}
        </div>
        <div className="stats">
          <div>{user.followers} Followers</div>
          <div>Following {user.following}</div>
        </div>
      </div>
    )}
  </UserContext.Consumer>
);

// ... all those other components go here ...
// ... (the ones that no longer need to know or care about `user`)

// At the bottom, inside App, we pass the context down
// through the tree using the Provider
class App extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    return (
      <div className="app">
        <UserContext.Provider value={this.state.user}>
          <Nav />
          <Body />
        </UserContext.Provider>
      </div>
    );
  }
}
```

Here’s the [full code in a CodeSandbox](https://codesandbox.io/s/q9w2qrw6q4).

Let’s go over how this works.

Remember there’s 3 pieces: the context itself (created with `React.createContext`), and the two components that talk to it (`Provider` and `Consumer`).

### Provider and Consumer are a Pair

The Provider and Consumer are bound together. Inseperable. And they only know how to talk to _each other_. If you created two separate contexts, say “Context1” and “Context2”, then Context1’s Provider and Consumer would not be able to communicate with Context2’s Provider and Consumer.

### Context Holds No State

Notice how the context _does not have its own state_. It is merely a conduit for your data. You have to pass a value to the `Provider`, and that exact value gets passed down to any `Consumer`s that know how to look for it (Consumers that are bound to the same context as the Provider).

When you create the context, you can pass in a “default value” like this:

```
const Ctx = React.createContext(yourDefaultValue);
```

This default value is what the `Consumer` will receive when it is placed in a tree with no `Provider` above it. If you don’t pass one, the value will just be `undefined`. Note, though, that this is a _default_ value, not an _initial_ value. A context doesn’t retain anything; it merely distributes the data you pass in.

### Consumer Uses the Render Props Pattern

Redux’s `connect` function is a higher-order component (or HoC for short). It _wraps_ another component and passes props into it.

The context `Consumer`, by contrast, expects the child component to be a function. It then calls that function at render time, passing in the value that it got from the `Provider` somewhere above it (or the context’s default value, or `undefined` if you didn’t pass a default).

### Provider Accepts One Value

Just a single value, as the `value` prop. But remember that the value can be anything. In practice, if you want to pass multiple values down, you’d create an object with all the values and pass _that object_ down.

That’s pretty much the nuts and bolts of the Context API.

## Context API is Flexible

Since creating a context gives us two components to work with (Provider and Consumer), we’re free to use them however we want. Here are a couple ideas.

### Turn the Consumer into a Higher-Order Component

Not fond of the idea of adding the `UserContext.Consumer` around every place that needs it? Well, it’s your code! You can do what you want. You’re an adult.

If you’d rather receive the value as a prop, you could write a little wrapper around the `Consumer` like this:

```
function withUser(Component) {
  return function ConnectedComponent(props) {
    return (
      <UserContext.Consumer>
        {user => <Component {...props} user={user}/>}
      </UserContext.Consumer>
    );
  }
}
```

And then you could rewrite, say, `UserAvatar` to use this new `withUser` function:

```
const UserAvatar = withUser(({ size, user }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
));
```

And BOOM, context can work just like Redux’s `connect`. Minus the automatic purity.

Here’s an [example CodeSandbox with this higher-order component](https://codesandbox.io/s/jpy76nm1v).

### Hold State in the Provider

The context’s Provider is just a conduit, remember. It doesn’t retain any data. But that doesn’t stop you from making your _own_ wrapper to hold the data.

In the example above, I left `App` holding the data, so that the only new thing you’d need to understand was the Provider + Consumer components. But maybe you want to make your own “store”, of sorts. You could create a component to hold the state and pass them through context:

```
class UserStore extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    return (
      <UserContext.Provider value={this.state.user}>
        {this.props.children}
      </UserContext.Provider>
    );
  }
}

// ... skip the middle stuff ...

const App = () => (
  <div className="app">
    <Nav />
    <Body />
  </div>
);

ReactDOM.render(
  <UserStore>
    <App />
  </UserStore>,
  document.querySelector("#root")
);
```

Now your user data is nicely contained in its own component whose _sole_ concern is user data. Awesome. `App` can be stateless once again. I think it looks a little cleaner, too.

Here’s an [example CodeSandbox with this UserStore](https://codesandbox.io/s/jpy76nm1v).

### Pass Actions Down Through Context

Rememeber that the object being passed down through the `Provider` can contain whatever you want. Which means it can contain functions. You might even call them “actions.”

Here’s a new example: a simple Room with a lightswitch to toggle the background color – err, I mean lights.

![the fire is dead. the room is freezing.](https://daveceddia.com/images/lightswitch-app.gif)

The state is kept in the store, which also has a function to toggle the light. Both the state and the function are passed down through context.

```
import React from "react";
import ReactDOM from "react-dom";
import "./styles.css";

// Plain empty context
const RoomContext = React.createContext();

// A component whose sole job is to manage
// the state of the Room
class RoomStore extends React.Component {
  state = {
    isLit: false
  };

  toggleLight = () => {
    this.setState(state => ({ isLit: !state.isLit }));
  };

  render() {
    // Pass down the state and the onToggleLight action
    return (
      <RoomContext.Provider
        value={{
          isLit: this.state.isLit,
          onToggleLight: this.toggleLight
        }}
      >
        {this.props.children}
      </RoomContext.Provider>
    );
  }
}

// Receive the state of the light, and the function to
// toggle the light, from RoomContext
const Room = () => (
  <RoomContext.Consumer>
    {({ isLit, onToggleLight }) => (
      <div className={`room ${isLit ? "lit" : "dark"}`}>
        The room is {isLit ? "lit" : "dark"}.
        <br />
        <button onClick={onToggleLight}>Flip</button>
      </div>
    )}
  </RoomContext.Consumer>
);

const App = () => (
  <div className="app">
    <Room />
  </div>
);

// Wrap the whole app in the RoomStore
// this would work just as well inside `App`
ReactDOM.render(
  <RoomStore>
    <App />
  </RoomStore>,
  document.querySelector("#root")
);
```

Here’s the [full working example in CodeSandbox](https://codesandbox.io/s/jvky9o0nvw).

## Should You Use Context, or Redux?

Now that you’ve seen both ways – which one should you use? Well, if there’s one thing that will make your apps _better_ and _more fun to write_, it’s **taking control of making the decisions**. I know you might just want “The Answer,” but I’m sorry to have to tell you, “it depends.”

It depends on things like how big your app is, or will grow to be. How many people will work on it – just you, or a larger team? How experienced are you or your team with functional concepts (the ones Redux relies upon, like immutability and pure functions).

One big pernicious fallacy that pervades the JavaScript ecosystem is the idea of _competition_. The idea that every choice is a zero-sum game: if you use _Library A_, you must not use _its competitor Library B_. The idea that when a new library comes out that’s better in some way, that it must supplant an existing one. There’s a perception that everything must be either/or, that you must either choose The Best Most Recent or be relegated to the back room with the developers of yesteryear.

A better approach is to look at this wonderful array of choices like a _toolbox_. It’s like the choice between using a screwdriver or an impact driver. For 80% of the jobs, the impact driver is gonna put the screw in faster than the screwdriver. But for that other 20%, the screwdriver is actually the better choice – maybe because the space is tight, or the item is delicate. When I got an impact driver I didn’t immediately throw away my screwdriver, or even my non-impact drill. The impact driver didn’t _replace_ them, it simply gave me another _option_. Another way to solve a problem.

Context doesn’t “replace” Redux any more than React “replaced” Angular or jQuery. Heck, I still use jQuery when I need to do something quick. I still sometimes use server-rendered EJS templates instead of spinning up a whole React app. Sometimes React is more than you need for the task at hand. Sometimes Redux is more than you need.

Today, when Redux is more than you need, you can reach for Context.

### Translations

*   [Russian](https://habr.com/post/419449/) (by Maxim Vashchenko)
*   [Japanese](https://qiita.com/ossan-engineer/items/c3e5bd4d9bb4db04f80d) (by Kiichi)
*   [Portuguese](https://www.linkedin.com/pulse/redux-vs-react-context-api-wenderson-pires/) (by Wenderson Pires)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
