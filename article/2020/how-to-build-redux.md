> * 原文地址：[Build Yourself a Redux](https://zapier.com/engineering/how-to-build-redux/)
> * 原文作者：[Justin Deal](https://github.com/jdeal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-redux.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-redux.md)
> * 译者：
> * 校对者：

# Build Yourself a Redux

Redux is a simple library that helps you manage the state of your JavaScript app. Despite that simplicity, it's easy to fall down rabbit holes when learning it. I often find myself explaining Redux, and almost always start by showing how I'd implement it. So that's what we'll do here: Start from scratch and build a working Redux implementation. Our implementation won't cover every nuance, but we'll remove most of the mystery.

Note that technically we'll be building [Redux](https://github.com/reactjs/redux?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) **and** [React Redux](https://github.com/reactjs/react-redux?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier). At Zapier, we pair Redux with the (awesome) UI library [React](https://facebook.github.io/react/), and that's the pairing that shows up most in the wild. But even if you use Redux with something else, most everything here will still apply.

Let's get started!

## Bring Your Own State Object

Most useful apps will get their state from a server, but let's start by creating our state locally. Even if we are retrieving from the server, we have to seed the app with something anyway. Our app will be a simple note-taking app. This is mostly to avoid making yet another todo app, but it will also force us to make an interesting state decision later.

```js
const initialState = {
  nextNoteId: 1,
  notes: {}
};
```

So first of all, notice our data is just a plain JS object. Redux helps **manage changes to your state**, but it doesn't really care much about the state itself.

## Why Redux?

Before we dig any deeper, let's see what it's like to build our app without Redux. Let's just go ahead and attach our `initialState` object to `window` like this:

```js
window.state = initialState;
```

Boom, there's our store! We don't need no stinking Redux. Let's make a component that adds new notes.

```jsx
const onAddNote = () => {
  const id = window.state.nextNoteId;
  window.state.notes[id] = {
    id,
    content: ''
  };
  window.state.nextNoteId++;
  renderApp();
};

const NoteApp = ({notes}) => (
  <div>
    <ul className="note-list">
    {
      Object.keys(notes).map(id => (
        // Obviously we should render something more interesting than the id.
        <li className="note-list-item" key={id}>{id}</li>
      ))
    }
    </ul>
    <button className="editor-button" onClick={onAddNote}>New Note</button>
  </div>
);

const renderApp = () => {
  ReactDOM.render(
    <NoteApp notes={window.state.notes}/>,
    document.getElementById('root')
  );
};

renderApp();
```

You can try out this example live with [JSFiddle](https://jsfiddle.net/justindeal/5j3can1z/102/):

```jsx
const initialState = {
  nextNoteId: 1,
  notes: {}
};

window.state = initialState;

const onAddNote = () => {
  const id = window.state.nextNoteId;
  window.state.notes[id] = {
    id,
    content: ''
  };
  window.state.nextNoteId++;
  renderApp();
};

const NoteApp = ({notes}) => (
  <div>
    <ul className="note-list">
    {
      Object.keys(notes).map(id => (
        // Obviously we should render something more interesting than the id.
        <li className="note-list-item" key={id}>{id}</li>
      ))
    }
    </ul>
    <button className="editor-button" onClick={onAddNote}>New Note</button>
  </div>
);

const renderApp = () => {
  ReactDOM.render(
    <NoteApp notes={window.state.notes}/>,
    document.getElementById('root')
  );
};

renderApp();
```

Not a very useful app, but what's there works fine. Seems like we've proved we can get by without Redux. So this blog post is done, right?

Not just yet…

Let's look down the road a little bit. We add a bunch of features, build a nice backend for it, start a company so we can sell subscriptions, get lots of customers, add lots of new features, make some money, grow the company… okay, we're getting a little ahead of ourselves.

It's difficult to see in this simple example, but on our road to success, our app may grow to include hundreds of components across hundreds of files. Our app will have asynchronous actions, so we'll have code like this:

```js
const onAddNote = () => {
  window.state.onLoading = true;
  renderApp();
  api.createNote()
    .then((note) => {
      window.state.onLoading = false;
      window.state.notes[id] = note;
      renderApp();
    });
};
```

And we'll have bugs like this:

```js
const ARCHIVE_TAG_ID = 0;

const onAddTag = (noteId, tagId) => {
  window.state.onLoading = true;
  // Whoops, forgetting to render here!
  // For quick local server, we might not notice.
  api.addTag(noteId, tagId)
    .then(() => {
      window.state.onLoading = false;
      window.state.tagMapping[tagId] = noteId;
      if (ARCHIVE_TAG_ID) {
        // Whoops, some naming bugs here. Probably from a
        // rogue search and replace. Won't be noticed till
        // we test that archive page that nobody really uses.
        window.state.archived = window.state.archive || {};
        window.state.archived[noteId] = window.state.notes[noteId];
        delete window.state.notes[noteId];
      }
      renderApp();
    });
};
```

And some hacky ad-hoc state changes like this that nobody even knows what they do:

```js
const SomeEvilComponent = () => {
  <button onClick={() => window.state.pureEvil = true}>Do Evil</button>
};
```

Add this all up across a large codebase with many developers over a long period of time, and we have a mounting set of problems:

1. Rendering can be kicked off from anywhere. There will probably be weird UI glitches or unresponsiveness at seemingly random times.
2. Race conditions are lurking, even in the little bit of code we see here.
3. This mess is nearly impossible to test. You have to get the **whole** app in a specific state, then poke at it with a stick, and check the state of the **whole** app to see if it's what you expect.
4. If you have a bug, you can make some educated guesses about where to look, but ultimately, every single line of your app is a potential suspect.

That last point is by far the worst problem and the main reason to choose Redux. If you want to shrink the complexity of your app, the best thing to do (in my opinion) is to constrain how and where you can change the state of your app. Redux isn't a panacea for the other problems, but they will likely diminish because of the same constraints.

## The Reducer

So how does Redux provide those constraints and help you manage state? Well, you start with a simple function that takes the current state and an action and returns the new state. So for our note-taking app, if we provide an action that adds a note, we should get a new state that has our note added to it.

```js
const CREATE_NOTE = 'CREATE_NOTE';
const UPDATE_NOTE = 'UPDATE_NOTE';

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE:
      return // some new state with new note
    case UPDATE_NOTE:
      return // some new state with note updated
    default:
      return state
  }
};
```

If `switch` statements make you nauseous, you don't have to write your reducer that way. I usually use an object and point a key for each type to its corresponding handler like this:

```js
const handlers = {
  [CREATE_NOTE]: (state, action) => {
    return // some new state with new note
  },
  [UPDATE_NOTE]: (state, action) => {
    return // some new state with note updated
  }
};

const reducer = (state = initialState, action) => {
  if (handlers[action.type]) {
    return handlers[action.type](state, action);
  }
  return state;
};
```

That part isn't too important though. The reducer is your function, and you can implement it however you want. Redux really doesn't care.

### Immutability

What Redux **does** care about is that your reducer is a **pure** function. Meaning, you should never, ever, ever in a million years implement your reducer like this:

```js
const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      // DO NOT MUTATE STATE LIKE THIS!!!
      state.notes[state.nextNoteId] = {
        id: state.nextNoteId,
        content: ''
      };
      state.nextNoteId++;
      return state;
    }
    case UPDATE_NOTE: {
      // DO NOT MUTATE STATE LIKE THIS!!!
      state.notes[action.id].content = action.content;
      return state;
    }
    default:
      return state;
  }
};
```

As a practical matter, if you mutate state like that, Redux simply won't work. Because you're mutating state, the object references won't change, so the parts of your app simply won't update correctly. It'll also make it impossible to use some Redux developer tools, because those tools keep track of previous states. If you're constantly mutating state, there's no way to go back to those previous states.

As a matter of principal, mutating state makes it harder to build your reducer (and potentially other parts of your app) from composable parts. Pure functions are predictable, because they produce the same output when given the same input. If you make a habit of mutating state, all bets are off. Calling a function becomes indeterminate. You have to keep the whole tree of functions in your head at once.

This predictability comes at a cost though, especially since JavaScript doesn't natively support immutable objects. For our examples, we'll make do with vanilla JavaScript, which will add some verbosity. Here's how we really need to write that reducer:

```js
const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      const id = state.nextNoteId;
      const newNote = {
        id,
        content: ''
      };
      return {
        ...state,
        nextNoteId: id + 1,
        notes: {
          ...state.notes,
          [id]: newNote
        }
      };
    }
    case UPDATE_NOTE: {
      const {id, content} = action;
      const editedNote = {
        ...state.notes[id],
        content
      };
      return {
        ...state,
        notes: {
          ...state.notes,
          [id]: editedNote
        }
      };
    }
    default:
      return state;
  }
};
```

I'm using [object spread properties](https://github.com/tc39/proposal-object-rest-spread?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) (`...`) here which aren't technically part of ECMAScript yet, but it's a pretty safe bet that they will be. `Object.assign` can be used if you want to avoid non-standard features. The concept is the same either way: Don't change the state. Instead, create shallow copies of the state and any nested objects/arrays. For any parts of an object that don't change, we just reference the existing parts. If we take a closer look at this code:

```js
return {
  ...state,
  notes: {
    ...state.notes,
    [id]: editedNote
  }
};
```

We're only changing the `notes` property, so other properties of `state` will remain exactly the same. The `...state` just says to re-use those existing properties as-is. Similarly, within `notes`, we're only changing the one note we're editing. The other notes that are part of `...state.notes` will remain untouched. This way, we can leverage [`shouldComponentUpdate`](https://reactjs.org/docs/react-component.html#shouldcomponentupdate) or [`PureComponent`](https://reactjs.org/docs/react-api.html#reactpurecomponent). If a component has an unchanged note as a prop, it can avoid re-rendering. Keeping that in mind, we also have to avoid writing our reducer like this:

```js
const reducer = (state = initialState, action) => {
  // Well, we avoid mutation, but still... DON'T DO THIS!
  state = _.cloneDeep(state)
  switch (action.type) {
    // ...
    case UPDATE_NOTE: {
      // Hey, now I can do good old mutations.
      state.notes[action.id].content = action.content;
      return state;
    }
    default:
      return state;
  }
};
```

That gives back your terse mutation code, and Redux will **technically** work if you do that, but you'll knee-cap all potential optimizations. Every single object and array will be brand-new for every state change, so any components depending on those objects and arrays will have to re-render, even if you didn't actually do any mutations.

Our immutable reducer definitely requires more typing and a little more cognitive effort. But over time, you'll tend to appreciate that your state-changing functions are isolated and easy to test. For a real app, you **might** want to look at something like [lodash-fp](https://github.com/lodash/lodash/wiki/FP-Guide?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier), or [Ramda](http://ramdajs.com/) or [Immutable.js](https://facebook.github.io/immutable-js/). At Zapier, we use a variant of [immutability-helper](https://github.com/kolodny/immutability-helper?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) which is pretty simple. I'll warn you that this is a pretty big rabbit hole though. I even started writing a [library with a different spin](https://github.com/jdeal/qim?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier). Vanilla JS is fine too and will likely play better with strong typing solutions like [Flow](https://flow.org/) and [TypeScript](https://www.typescriptlang.org/). Just make sure to stick with smaller functions. It's much like the tradeoff you make with React: you might end up with more code than the equivalent jQuery solution, but each component is far more predictable.

### Using our Reducer

Let's plug an action into our reducer and get out a new state.

```js
const state0 = reducer(undefined, {
  type: CREATE_NOTE
});
```

Now `state0` looks like this:

```js
{
  nextNoteId: 2,
  notes: {
    1: {
      id: 1,
      content: ''
    }
  }
}
```

Notice we fed `undefined` in as the state in this case. Redux always passes in `undefined` as the initial state, and typically you use a default parameter like `state = initialState` to pick up your initial state object. The next time through, Redux will feed in the previous state.

```js
const state1  = reducer(state0, {
  type: UPDATE_NOTE,
  id: 1,
  content: 'Hello, world!'
});
```

Now `state1` looks like this:

```json
{
  nextNoteId: 2,
  notes: {
    1: {
      id: 1,
      content: 'Hello, world!'
    }
  }
}
```

You can play with our reducer [here (JSFiddle)](https://jsfiddle.net/justindeal/kLkjt4y3/37/):

```jsx
const CREATE_NOTE = 'CREATE_NOTE';
const UPDATE_NOTE = 'UPDATE_NOTE';

const initialState = {
  nextNoteId: 1,
  notes: {}
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      const id = state.nextNoteId;
      const newNote = {
        id,
        content: ''
      };
      return {
        ...state,
        nextNoteId: id + 1,
        notes: {
          ...state.notes,
          [id]: newNote
        }
      };
    }
    case UPDATE_NOTE: {
      const {id, content} = action;
      const editedNote = {
        ...state.notes[id],
        content
      };
      return {
        ...state,
        notes: {
          ...state.notes,
          [id]: editedNote
        }
      };
    }
    default:
      return state;
  }
};

const state0 = reducer(undefined, {
  type: CREATE_NOTE
});

const state1  = reducer(state0, {
  type: UPDATE_NOTE,
  id: 1,
  content: 'Hello, world!'
});

ReactDOM.render(
  <pre>{JSON.stringify(state1, null, 2)}</pre>,
  document.getElementById('root')
);
```

Of course, Redux doesn't keep making more variables like this, but we'll get to a real implementation soon enough. The point is that the core of Redux is really just a piece of code that you write, a simple function that takes the previous state and an action and returns the next state. Why is that function called a reducer? Because it would plug right into a standard [`reduce`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce) function.

```js
const actions = [
  {type: CREATE_NOTE},
  {type: UPDATE_NOTE, id: 1, content: 'Hello, world!'}
];

const state = actions.reduce(reducer, undefined);
```

After this, `state` would look identical to our previous `state1`:

```json
{
  nextNoteId: 2,
  notes: {
    1: {
      id: 1,
      content: 'Hello, world!'
    }
  }
}
```

Play around with adding actions to our `actions` array and feeding them into the reducer [(JSFiddle link)](https://jsfiddle.net/justindeal/edogdh33/13/):

```jsx
const CREATE_NOTE = 'CREATE_NOTE';
const UPDATE_NOTE = 'UPDATE_NOTE';

const initialState = {
  nextNoteId: 1,
  notes: {}
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      const id = state.nextNoteId;
      const newNote = {
        id,
        content: ''
      };
      return {
        ...state,
        nextNoteId: id + 1,
        notes: {
          ...state.notes,
          [id]: newNote
        }
      };
    }
    case UPDATE_NOTE: {
      const {id, content} = action;
      const editedNote = {
        ...state.notes[id],
        content
      };
      return {
        ...state,
        notes: {
          ...state.notes,
          [id]: editedNote
        }
      };
    }
    default:
      return state;
  }
};

const actions = [
  {type: CREATE_NOTE},
  {type: UPDATE_NOTE, id: 1, content: 'Hello, world!'}
];

const state = actions.reduce(reducer, undefined);

ReactDOM.render(
  <pre>{JSON.stringify(state, null, 2)}</pre>,
  document.getElementById('root')
);
```

Now you can understand why Redux bills itself as "a predictable state container for JavaScript apps". Feed in the same set of actions, and you'll end up in the same state. Functional programming for the win! If you hear about Redux facilitating replay, this is roughly how that works. Out of the box though, Redux doesn't hold onto a list of actions. Instead, there's a single variable that points to the state object, and we keep changing that variable to point to the next state. That is one important mutation that **is** allowed in your app, but we'll control that mutation inside a store.

## The Store

Let's build a store now, which will hold onto our single state variable as well as some useful methods for setting and getting the state.

```js
const validateAction = action => {
  if (!action || typeof action !== 'object' || Array.isArray(action)) {
    throw new Error('Action must be an object!');
  }
  if (typeof action.type === 'undefined') {
    throw new Error('Action must have a type!');
  }
};

const createStore = (reducer) => {
  let state = undefined;
  return {
    dispatch: (action) => {
      validateAction(action)
      state = reducer(state, action);
    },
    getState: () => state
  };
};
```

Now you can see why we use constants instead of strings. Our action validation is a little looser than Redux's, but it's close enough to enforce that we don't misspell action types. If we pass along strings, then our action will just fall through to the default case of our reducer, and nothing much will happen, and the error may go unnoticed. But if we use constants, then typos will go through as `undefined`, which will throw an error. So we'll know right away and fix it.

Let's create a store now and use it.

```js
// Pass in the reducer we made earlier.
const store = createStore(reducer);

store.dispatch({
  type: CREATE_NOTE
});

store.getState();
// {
//   nextNoteId: 2,
//   notes: {
//     1: {
//       id: 1,
//       content: ''
//     }
//   }
// }
```

This is fairly functional at this point. We have a store that can use any reducer we provide to manage the state. But it's still missing an important bit: A way to subscribe to changes. Without that, it's going to require some awkward imperative code. And later when we introduce asynchronous actions, it's not going to work at all. So let's go ahead and implement subscriptions.

```js
const createStore = reducer => {
  let state;
  const subscribers = [];
  const store = {
    dispatch: action => {
      validateAction(action);
      state = reducer(state, action);
      subscribers.forEach(handler => handler());
    },
    getState: () => state,
    subscribe: handler => {
      subscribers.push(handler);
      return () => {
        const index = subscribers.indexOf(handler);
        if (index > 0) {
          subscribers.splice(index, 1);
        }
      };
    }
  };
  store.dispatch({type: '@@redux/INIT'});
  return store;
};
```

A little more code, but not **too** hard to follow. The `subscribe` function takes a `handler` function and adds that to the list of `subscribers`. It also returns a function to unsubscribe. Any time we call `dispatch`, we notify all those handlers. Now it's easy to re-render every time the state changes.

```jsx
///////////////////////////////
// Mini Redux implementation //
///////////////////////////////

const validateAction = action => {
  if (!action || typeof action !== 'object' || Array.isArray(action)) {
    throw new Error('Action must be an object!');
  }
  if (typeof action.type === 'undefined') {
    throw new Error('Action must have a type!');
  }
};

const createStore = reducer => {
  let state;
  const subscribers = [];
  const store = {
    dispatch: action => {
      validateAction(action);
      state = reducer(state, action);
      subscribers.forEach(handler => handler());
    },
    getState: () => state,
    subscribe: handler => {
      subscribers.push(handler);
      return () => {
        const index = subscribers.indexOf(handler);
        if (index > 0) {
          subscribers.splice(index, 1);
        }
      };
    }
  };
  store.dispatch({type: '@@redux/INIT'});
  return store;
};

//////////////////////
// Our action types //
//////////////////////

const CREATE_NOTE = 'CREATE_NOTE';
const UPDATE_NOTE = 'UPDATE_NOTE';

/////////////////
// Our reducer //
/////////////////

const initialState = {
  nextNoteId: 1,
  notes: {}
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      const id = state.nextNoteId;
      const newNote = {
        id,
        content: ''
      };
      return {
        ...state,
        nextNoteId: id + 1,
        notes: {
          ...state.notes,
          [id]: newNote
        }
      };
    }
    case UPDATE_NOTE: {
      const {id, content} = action;
      const editedNote = {
        ...state.notes[id],
        content
      };
      return {
        ...state,
        notes: {
          ...state.notes,
          [id]: editedNote
        }
      };
    }
    default:
      return state;
  }
};

///////////////
// Our store //
///////////////

const store = createStore(reducer);

///////////////////////////////////////////////
// Render our app whenever the store changes //
///////////////////////////////////////////////

store.subscribe(() => {
  ReactDOM.render(
    <pre>{JSON.stringify(store.getState(), null, 2)}</pre>,
    document.getElementById('root')
  );
});

//////////////////////
// Dispatch actions //
//////////////////////

store.dispatch({
  type: CREATE_NOTE
});

store.dispatch({
  type: UPDATE_NOTE,
  id: 1,
  content: 'Hello, world!'
});
```

[Play with the code](https://jsfiddle.net/justindeal/8cpu4ydj/27/) and dispatch more actions. The rendered HTML will always reflect the store state. Of course, for a real app, we want to wire up those `dispatch` functions to user actions. We'll get to that soon enough!

## Bring Your own Components

How do you make components that work with Redux? Just make plain old React components that take props. You bring your own state, so make components that work with that state (or parts of it). There are some nuances that **might** affect your design later, particularly with respect to performance, but for the most part, boring components are a good place to start. So let's do that for our app now.

```jsx
const NoteEditor = ({note, onChangeNote, onCloseNote}) => (
  <div>
    <div>
      <textarea
        className="editor-content"
        autoFocus
        value={note.content}
        onChange={event => onChangeNote(note.id, event.target.value)}
        rows={10} cols={80}
      />
    </div>
    <button className="editor-button" onClick={onCloseNote}>Close</button>
  </div>
);

const NoteTitle = ({note}) => {
  const title = note.content.split('\n')[0].replace(/^\s+|\s+$/g, '');
  if (title === '') {
    return <i>Untitled</i>;
  }
  return <span>{title}</span>;
};

const NoteLink = ({note, onOpenNote}) => (
  <li className="note-list-item">
    <a href="#" onClick={() => onOpenNote(note.id)}>
      <NoteTitle note={note}/>
    </a>
  </li>
);

const NoteList = ({notes, onOpenNote}) => (
  <ul className="note-list">
    {
      Object.keys(notes).map(id =>
        <NoteLink
          key={id}
          note={notes[id]}
          onOpenNote={onOpenNote}
        />
      )
    }
  </ul>
);

const NoteApp = ({
  notes, openNoteId, onAddNote, onChangeNote,
  onOpenNote, onCloseNote
}) => (
  <div>
    {
      openNoteId ?
        <NoteEditor
          note={notes[openNoteId]} onChangeNote={onChangeNote}
          onCloseNote={onCloseNote}
        /> :
        <div>
          <NoteList notes={notes} onOpenNote={onOpenNote}/>
          <button className="editor-button" onClick={onAddNote}>New Note</button>
        </div>
    }
  </div>
);
```

Not much to see there. We could feed props into these components and render them right now. But let's look at the `openNoteId` prop and those `onOpenNote` and `onCloseNote` callbacks. We'll need to decide where that state and those callbacks live. We could just use component state for that. And there's nothing wrong with that. Once you start using Redux, there's no rule that says **all** your state needs to go into the Redux store. If you want to know when you have to use store state, just ask yourself:

> Does this state need to exist after this component is unmounted?

If the answer is no, there's a good chance component state is appropriate. For state that has to be persisted to the server or shared across many components that may independently mount and unmount, Redux is probably a better choice.

There are some times when Redux does work well for transient state though. In particular, when transient state needs to change as the result of changes to store state, it can be a little easier to just keep the transient state in the store. For our app, when we create a note, we want the `openNoteId` to be set to the new note id. This would be cumbersome to reflect inside component state, because we'd have to monitor for changes to the store state in `componentWillReceiveProps`. That's not to say it's wrong, just that it can be awkward. So for our app, we'll store `openNoteId` in our store state. (In a real app, we might want to involve a router for this. See [the end of this post](#routing) for a bit on that.)

The other reason you might want transient state in the store is simply to have access to it from Redux developer tools. It's really easy to peek into store state, and fancy things like replay will just work. It's pretty easy to start with local component state and switch to store state later, though. Just make sure to create container components for local state just like you would store state.

So, let's tweak our reducer to handle this transient state.

```js
const OPEN_NOTE = 'OPEN_NOTE';
const CLOSE_NOTE = 'CLOSE_NOTE';

const initialState = {
  // ...
  openNoteId: null
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      const id = state.nextNoteId;
      // ...
      return {
        ...state,
        // ...
        openNoteId: id,
        // ...
      };
    }
    // ...
    case OPEN_NOTE: {
      return {
        ...state,
        openNoteId: action.id
      };
    }
    case CLOSE_NOTE: {
      return {
        ...state,
        openNoteId: null
      };
    }
    default:
      return state;
  }
};
```

## Wire Things up, the Manual Way

Okay, now we can wire this thing up. We won't touch our existing components for this. Instead, we'll create a new container component that gets the state from the store and passes it along to our `NoteApp`.

```jsx
class NoteAppContainer extends React.Component {
  constructor(props) {
    super();
    this.state = props.store.getState();
    this.onAddNote = this.onAddNote.bind(this);
    this.onChangeNote = this.onChangeNote.bind(this);
    this.onOpenNote = this.onOpenNote.bind(this);
    this.onCloseNote = this.onCloseNote.bind(this);
  }
  componentWillMount() {
    this.unsubscribe = this.props.store.subscribe(() =>
      this.setState(this.props.store.getState())
    );
  }
  componentWillUnmount() {
    this.unsubscribe();
  }
  onAddNote() {
    this.props.store.dispatch({
      type: CREATE_NOTE
    });
  }
  onChangeNote(id, content) {
    this.props.store.dispatch({
      type: UPDATE_NOTE,
      id,
      content
    });
  }
  onOpenNote(id) {
    this.props.store.dispatch({
      type: OPEN_NOTE,
      id
    });
  }
  onCloseNote() {
    this.props.store.dispatch({
      type: CLOSE_NOTE
    });
  }
  render() {
    return (
      <NoteApp
        {...this.state}
        onAddNote={this.onAddNote}
        onChangeNote={this.onChangeNote}
        onOpenNote={this.onOpenNote}
        onCloseNote={this.onCloseNote}
      />
    );
  }
}

ReactDOM.render(
  <NoteAppContainer store={store}/>,
  document.getElementById('root')
);
```

Yay, it's alive! [Try it out!](https://jsfiddle.net/justindeal/8bL9tL0z/23/)

Our app is dispatching actions, which update the store state via our reducer, and our subscription is keeping our view in sync. If we end up in a weird state, we don't have to peek into all of our components—we just look at our reducer and actions.

## Provider and Connect

Okay, so everything is working. But… there are some problems.

1. Wiring feels imperative.
2. There's a lot of repetition within our container component.
3. Every time we want to wire the store to a component, we're going to have to use a global `store` object. Or we're going to have to pass a `store` prop through the entire tree. Or we're going to have to wire it up once at the top and pass **everything** down through the tree, which might not be so great in a big app.

This is why we need `Provider` and `connect` from React Redux. First, let's make a `Provider` component.

```js
class Provider extends React.Component {
  getChildContext() {
    return {
      store: this.props.store
    };
  }
  render() {
    return this.props.children;
  }
}

Provider.childContextTypes = {
  store: PropTypes.object
};
```

Pretty simple. The `Provider` component uses React's [context feature](https://facebook.github.io/react/docs/context.html) to convert a `store` prop into a context property. Context is a way to pass information from a top-level component down to descendant components without components in the middle having to explicitly pass props. In general, you should avoid context, because the [React documentation](https://facebook.github.io/react/docs/context.html#why-not-to-use-context) says so:

> If you want your application to be stable, don't use context. It is an experimental API and it is likely to break in future releases of React.

And that's why our implementation won't require anyone to use context directly. Instead, we're wrapping up that experimental API inside components so if it does change, we can change our implementation without requiring developers to change their code.

So now we need a way to convert context back into props. That's where `connect` comes in.

```js
const connect = (
  mapStateToProps = () => ({}),
  mapDispatchToProps = () => ({})
) => Component => {
  class Connected extends React.Component {
    onStoreOrPropsChange(props) {
      const {store} = this.context;
      const state = store.getState();
      const stateProps = mapStateToProps(state, props);
      const dispatchProps = mapDispatchToProps(store.dispatch, props);
      this.setState({
        ...stateProps,
        ...dispatchProps
      });
    }
    componentWillMount() {
      const {store} = this.context;
      this.onStoreOrPropsChange(this.props);
      this.unsubscribe = store.subscribe(() => this.onStoreOrPropsChange(this.props));
    }
    componentWillReceiveProps(nextProps) {
      this.onStoreOrPropsChange(nextProps);
    }
    componentWillUnmount() {
      this.unsubscribe();
    }
    render() {
      return <Component {...this.props} {...this.state}/>;
    }
  }

  Connected.contextTypes = {
    store: PropTypes.object
  };

  return Connected;
}
```

That one is a little more complicated. And truth be told, we've cheated **a lot** compared to the actual implementation. (We'll discuss that a little [at the end](#performance).) But this is close enough to get the idea. `connect` is a [higher-order component](https://facebook.github.io/react/docs/higher-order-components.html). Well, actually, it's more of a higher order component factory. It takes two functions and returns a function that takes a component and returns a new component. That component subscribes to the store and updates your component's props when there are changes. Let's use it, and it will make more sense.

## Wire Things up the Automatic Way

```js
const mapStateToProps = state => ({
  notes: state.notes,
  openNoteId: state.openNoteId
});

const mapDispatchToProps = dispatch => ({
  onAddNote: () => dispatch({
    type: CREATE_NOTE
  }),
  onChangeNote: (id, content) => dispatch({
    type: UPDATE_NOTE,
    id,
    content
  }),
  onOpenNote: id => dispatch({
    type: OPEN_NOTE,
    id
  }),
  onCloseNote: () => dispatch({
    type: CLOSE_NOTE
  })
});

const NoteAppContainer = connect(
  mapStateToProps,
  mapDispatchToProps
)(NoteApp);
```

Hey, that looks nicer!

The first function passed to `connect` (`mapStateToProps`) takes the current `state` from our `store` and returns some props. The second function passed to `connect` (`mapDispatchToProps`) takes the `dispatch` method of our `store` and returns some more props. That gives us back a new function, and we pass our component to that function. That gives us a new component, which will automatically get all those mapped props (plus any extra ones we pass in).

Now we just need to use our `Provider` component so `connect` can get the `store` off of the `context`.

```jsx
ReactDOM.render(
  <Provider store={store}>
    <NoteAppContainer/>
  </Provider>,
  document.getElementById('root')
);

```

Nice! Our `store` is passed in once at the top, and `connect` picks it up and does all the work. Declarative for the win! [Here is our app](https://jsfiddle.net/justindeal/srnf5n20/10/) again cleaned up with `Provider` and `connect`.

## Middleware

So, we've built something pretty useful now. But there's a big missing piece. At some point we're going to want to talk to a server. And our actions are synchronous. How do we do **asynchronous** actions? Well, we could fetch data in our components, but there are some problems with that.

1. Redux (aside from `Provider` and `connect`) isn't meant to be React specific. It would be nice to have a Redux solution.
2. We sometimes need access to the state when fetching data. We don't want to pass around that state everywhere. So we'd end up having to build something like `connect` for data fetching.
3. We won't be able to test state changes that involve data fetching without involving our components. If we can keep data fetching separate, we probably should.
4. Once again, we'll lose out on some tooling benefits.

Since Redux is synchronous, how is this going to work? By putting something in the middle of your dispatches and changes to the store state. That something is middleware.

We need a way to pass middleware into our store, so let's do that.

```js
const createStore = (reducer, middleware) => {
  let state;
  const subscribers = [];
  const coreDispatch = action => {
    validateAction(action);
    state = reducer(state, action);
    subscribers.forEach(handler => handler());
  };
  const getState = () => state;
  const store = {
    dispatch: coreDispatch,
    getState,
    subscribe: handler => {
      subscribers.push(handler);
      return () => {
        const index = subscribers.indexOf(handler)
        if (index > 0) {
          subscribers.splice(index, 1);
        }
      };
    }
  };
  if (middleware) {
    const dispatch = action => store.dispatch(action);
    store.dispatch = middleware({
      dispatch,
      getState
    })(coreDispatch);
  }
  coreDispatch({type: '@@redux/INIT'});
  return store;
}
```

Things are a little more complicated now, but the important part is that last `if` statement:

```js
if (middleware) {
  const dispatch = action => store.dispatch(action);
  store.dispatch = middleware({
    dispatch,
    getState
  })(coreDispatch);
}
```

We make a function that will "re-dispatch".

```js
const dispatch = action => store.dispatch(action);
```

That's so if a middleware decides to dispatch a new action, that new action goes back through the middleware. We have to create this function because we're about to change the store's `dispatch` function. This is another place where mutation makes things easier. Redux can break the rules as long as it helps you enforce them. :-)

```js
store.dispatch = middleware({
  dispatch,
  getState
})(coreDispatch);
```

That calls the middleware, passing it an object that has access to our re-dispatch function as well as our `getState` function. The middleware should return a new function that accepts the ability to call the next dispatch function, which in this case is just the original dispatch function. If your head is spinning a little, don't worry, creating and using middleware is actually pretty easy.

Okay, let's create a piece of middleware that delays dispatch for a second. Pretty useless, but it will illustrate async.

```js
const delayMiddleware = () => next => action => {
  setTimeout(() => {
    next(action);
  }, 1000);
};
```

That signature looks super goofy, but it fits into the puzzle we created before. It's a function that returns a function that takes the next dispatch function. That function takes the action. Okay, it may seem like Redux went arrow function crazy here, but there's a reason, which we'll point out soon.

Now, let's use that middleware for our store.

```js
const store = createStore(reducer, delayMiddleware);
```

Yay, we made our app slower! Wait, no, boo! But we have async now. Yay! [Experience this terrible app](https://jsfiddle.net/justindeal/56uf0uy7/7/) for yourself. Typing is particularly humorous.

Play with the `setTimeout` time to make it more or less terrible.

## Composing Middleware Together

Now let's make another (more useful) middleware for logging.

```js
const loggingMiddleware = ({getState}) => next => action => {
  console.info('before', getState());
  console.info('action', action);
  const result = next(action);
  console.info('after', getState());
  return result;
};
```

Hey, that's useful. Let's add that to our store. Hmm, our store only takes one middleware function. No problem! We just need a way to compose our middleware together. So, let's make a way to turn lots of middleware functions into one middleware function. Let's build `applyMiddleware`!

```js
const applyMiddleware = (...middlewares) => store => {
  if (middlewares.length === 0) {
    return dispatch => dispatch;
  }
  if (middlewares.length === 1) {
    return middlewares[0](store);
  }
  const boundMiddlewares = middlewares.map(middleware =>
    middleware(store);
  );
  return boundMiddlewares.reduce((a, b) =>
    next => a(b(next));
  );
};
```

That's a funky function, but hopefully you can kind of follow along. First thing to notice is it takes a list of middlewares and returns a middleware function. (Not sure if middlewares is a word, but it comes in handy here.) That new middleware function has the same signature as our earlier middleware. It takes a store (really just our re-`dispatch` and `getState` methods, not really the whole store) and returns another function. For that function:

1. If we have no middleware, we return an identity function. Basically, just a no-op middleware. This is silly, but we're just keeping people from breaking things.
2. If we have one middleware function, we return that middleware function. Again, silly, we're just carrying somebody's groceries here.
3. We bind all the middleware to our pseudo-store. Okay, finally something interesting.
4. We bind each of those functions to the next dispatch function. This is why our middleware has to be arrows all the way down. We're left with a function that will take an action and is able to keep calling the next dispatch function until it finally reaches the original dispatch function.

Phew! Okay, now we can use all the middleware we want.

```js
const store = createStore(reducer, applyMiddleware(
  delayMiddleware,
  loggingMiddleware
));
```

Yay! Now our Redux implementation can handle all the things! [Try it out](https://jsfiddle.net/justindeal/3ukd4mL7/52/)!

Open the console in your browser to see the logging middleware at work.

## Thunk middleware

Let's really do some async now. To do that we'll introduce a "thunk" middleware:

```js
const thunkMiddleware = ({dispatch, getState}) => next => action => {
  if (typeof action === 'function') {
    return action(dispatch, getState);
  }
  return next(action);
};
```

"Thunk" is really just another name for "function", but it typically means "a function that is wrapping some work to be done later". If we add in `thunkMiddleware`:

```js
const store = createStore(reducer, applyMiddleware(
  thunkMiddleware,
  loggingMiddleware
));
```

Now we can do something like this:

```js
store.dispatch(({getState, dispatch}) => {
  // Grab something from the state
  const someId = getState().someId;
  // Fetch something that depends on knowing that something
  fetchSomething(someId)
    .then((something) => {
      // Dispatch whenever we feel like it
      dispatch({
        type: 'someAction',
        something
      });
    });
});
```

The thunk middleware is a big hammer. We can pull anything we want out of state, and we can dispatch any action we want at any time. This is really flexible, but as your app grows, it **may** become a little dangerous. It's a good place to start though. Let's use it to do some async work.

First, let's create a fake API.

```js
const createFakeApi = () => {
  let _id = 0;
  const createNote = () => new Promise(resolve => setTimeout(() => {
    _id++
    resolve({
      id: `${_id}`
    })
  }, 1000));
  return {
    createNote
  };
};

const api = createFakeApi()
```

This API only supports one method to create a note and returns the new id for that note. Since we're now getting the id from the server, we'll want to tweak our reducer again.

```js
const initialState = {
  notes: {},
  openNoteId: null,
  isLoading: false
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      if (!action.id) {
        return {
          ...state,
          isLoading: true
        };
      }
      const newNote = {
        id: action.id,
        content: ''
      };
      return {
        ...state,
        isLoading: false,
        openNoteId: action.id,
        notes: {
          ...state.notes,
          [action.id]: newNote
        }
      };
    }
    // ...
  }
};
```

Here, we're using the `CREATE_NOTE` action to set the loading state and for actually creating the note in the store. We just use the presence or absence of the `id` property to signal the difference. You may want to use different actions for your app, but once again, Redux doesn't really care what you use. If you want something prescriptive, you can look at [Flux Standard Actions](https://github.com/acdlite/flux-standard-action?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier).

Now let's tweak our `mapDispatchToProps` to dispatch a thunk.

```js
const mapDispatchToProps = dispatch => ({
  onAddNote: () => dispatch(
    (dispatch) => {
      dispatch({
        type: CREATE_NOTE
      });
      api.createNote()
        .then(({id}) => {
          dispatch({
            type: CREATE_NOTE,
            id
          });
        });
    }
  ),
  // ...
});
```

Our app is doing async work now! [Try it out](https://jsfiddle.net/justindeal/o27j5zs1/8/)!

But wait… besides that being some ugly code we dumped in our component, we invented middleware to try to get that out of our code. And now we put it right back in. If we made some custom api middleware instead of using the thunk hammer, we could get rid of that. But even when using thunk middleware, we can still make things more declarative.

## Action Creators

Instead of dispatching the thunk from our component, let's abstract it away by putting it inside a function.

```js
const createNote = () => {
  return (dispatch) => {
    dispatch({
      type: CREATE_NOTE
    });
    api.createNote()
      .then(({id}) => {
        dispatch({
          type: CREATE_NOTE,
          id
        })
      });
  }
};
```

We just invented an action creator. Action creators are nothing fancy. They're just functions that return actions to be dispatched. They help to:

1. Abstract away ugly actions like our new thunk action.
2. They help DRY up your code, if you're dispatching the same action from multiple components.
3. They let us move our action creating code away from our components, so our components stay simple and declarative.

We could have introduced action creators earlier, but there really was no reason. Our app was simple, so we weren't repeating any of the same actions. And our actions were simple, so they were already pretty concise and declarative.

Let's tweak our `mapDispatchToProps` again to use our action creator.

```js
const mapDispatchToProps = dispatch => ({
  onAddNote: () => dispatch(createNote()),
  // ...
});
```

Much better! [Here's our final app](https://jsfiddle.net/justindeal/5j3can1z/171/).

## That's About it!

You built yourself a Redux! It might seem like we wrote a lot of code, but most of that was our reducer and components. Our actual Redux implementation is pretty tiny at less than [140 lines](https://gist.githubusercontent.com/jdeal/c224026df3bae5803fd9e58cbbd4a60b/raw/623150cb62a7076e78904881b61d4c948639abe8/mini-redux.js). And that includes our thunk and logging middleware, blank lines, and some comments!

Yes, there's a little more to the real Redux and to making a real app. Keep reading, and we'll talk about a few of those things. But if you find yourself in a rabbit hole with Redux, hopefully this guide has shined a little light!

## Some things we left out

### Performance

One thing our implementation is sorely lacking is any concern over whether our selected props have actually changed. For our example app, it doesn't actually matter, because every state change also causes our props to change. But for a larger app with many different `mapStateToProps` functions, we only want components to update when they actually have new props. It's pretty easy to extend our `connect` function to do this. We just need to compare the previous mapping to the next mapping before we call `setState`. We do have to be smarter about `mapDispatchToProps` though. Notice we're creating new functions every time. The actual React Redux implementation detects the arity of that function to see if it depends on `props`. That way it doesn't have to do another mapping if the props haven't actually changed.

You'll also notice that we call our function when props change or when the store state changes. Those might both happen simultaneously, so we'll waste some effort. React Redux optimizes for this and many other things.

Beyond that, for larger apps, we have to start thinking about performance of any selectors. For example, if we filter a subset of notes, we don't want to keep recalculating that filtered list. For this, we have to reach for something like [reselect](https://github.com/reactjs/reselect?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) or other memoization techniques.

### Freezing the State

If you use plain JS data (and not something like Immutable.js), then one important detail I left out is freezing the reducer state in development. Because this is JavaScript, nothing is stopping you from mutating the state once you get it from the store. You could mutate it in a `render` method or wherever. This leads to very bad things and ruins some of the predictability you're trying to add with Redux. At Zapier, we do something like this:

```js
import deepFreeze from 'deep-freeze';
import reducer from 'your-reducer';

const frozenReducer = process.env.NODE_ENV === 'production' ? reducer : (
  (...args) => {
    const state = reducer(...args);
    return freezeState(state);
  }
);
```

This creates a reducer that freezes its results. This way, if you try to mutate the store state in a component, it will throw errors (in development). After a while, you'll train yourself to avoid making these mistakes. But if you're new to immutable data, this is probably one of the easiest ways to train yourself (and the rest of your team) to stop mutating.

### Server Rendering

Besides performance, we also cheated on our `connect` implementation with respect to server rendering. `componentWillMount` gets called on the server, but we don't want to set up subscriptions on the server. Redux uses `componentDidMount` along with some trickery to make it properly work in a browser.

### Store Enhancers

As if we didn't have enough higher order functions, Redux has another one we left out. A "store enhancer" is a higher order function that takes a store creator and returns an "enhanced" store creator. This is not a common thing to need to do, but it is used to create things like the Redux developer tools. The [**real** implementation](https://github.com/reactjs/redux/blob/4d8700c9631b152f0dff384d528a6c7f74024418/src/applyMiddleware.js?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) of `applyMidleware` is actually a store enhancer.

### Tests

There are no tests for our implementation. In general, don't actually use this implementation for anything real! It was written just for funsies for this blog post!

### Ordering

We stored our notes in an object that just so happens to have numeric keys. That means every JS engine will order those in the order they were created. If instead our server returns GUIDs or some other unordered keys, we'll get crazy ordering. We don't want to store our notes in an array though, because then we can't easily pick out a note by id. So for a real app, we might want to store an array of ordered ids. Alternatively, we **might** be able to get by with an array if we use `reselect` to memoize the `find` operation.

### Side Effects from Action Creators

At some point, you may be tempted to create some middleware that works with promises like this:

```js
store.dispatch(fetch('/something'));
```

Don't do that. A function that returns a promise has already started doing the work. (Unless it's a weird lazy promise, which is not a normal promise.) That means we've prevented ourselves from building any middleware around this action. We can't create a smart throttling middleware for example. We also can't properly do replay, because replay needs to turn off dispatching. But any code calling this `dispatch` has already done the work, so it can't be stopped.

Just make sure that your actions are descriptions of side effects and not actually side effects. Thunks are opaque so not the best descriptions, but they are lazy and thus count as descriptions of side effects.

### Routing

Routing can get a little weird, because the browser owns some of the state about the current location, and it owns some actions for changing the location. Once you start using Redux, you might start wanting your routing state inside the Redux store. I did, so I built a [router to do that](https://github.com/zapier/redux-router-kit?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)! The new version of [React Router](https://reacttraining.com/react-router/) is very cool, and there are other non-Redux routing solutions you may want to use. For the most part, if you do that, you'll probably want to have the routing library do as much of its job as possible without trying to sync state.

### Everything Else

There's a big ecosystem of middleware and tools built on top of Redux. Following are just a **few** of the many things available. Feel free to look around, but I recommend getting confident with the basics first!

You’ll definitely want to check out the [Redux DevTools extension](https://github.com/zalmoxisus/redux-devtools-extension?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) or the [Redux DevTools](https://github.com/gaearon/redux-devtools?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) themselves. The extension is generally the easiest way to use the DevTools.

The [Logger for Redux](https://github.com/evgenyrodionov/redux-logger?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) is a handy piece of middleware for logging actions to the console.

If you want to dispatch multiple synchronous actions but only want to kick off a single re-render, [redux-batched-actions](https://github.com/tshelburne/redux-batched-actions?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) or [redux-batch](https://github.com/manaflair/redux-batch?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) can help.

If asynchronous actions or side effects seem to be getting unwieldy with [redux-thunk](https://github.com/gaearon/redux-thunk?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier), and you don’t want to write your own middleware solution, you can check out something like [redux-saga](https://github.com/redux-saga/redux-saga?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) or [redux-logic](https://github.com/jeffbski/redux-logic?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier). Or, if you want to go further down the rabbit hole, [redux-loop](https://github.com/redux-loop/redux-loop?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) is pretty interesting.

If you want to use GraphQL, check out [Apollo](http://dev.apollodata.com/) which integrates with Redux.

Have fun!

### Build Great APIs

Get new articles about API design, documentation, and success delivered to your inbox.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
