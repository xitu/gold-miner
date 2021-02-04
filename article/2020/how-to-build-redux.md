> * 原文地址：[Build Yourself a Redux](https://zapier.com/engineering/how-to-build-redux/)
> * 原文作者：[Justin Deal](https://github.com/jdeal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-redux.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-redux.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)，[lsvih](https://github.com/lsvih)
> * 校对者：[nia3y](https://github.com/nia3y)，[JohnieXu](https://github.com/JohnieXu)

# 自己写一个 Redux

Redux 是一个简单的库，可以帮助你管理 JavaScript 应用的状态。虽然它很简单，但在学习过程中还是很容易掉坑。我经常需要解释 Redux 的用法和原理，而且我总是会从如何实现 Redux 来开始说明。所以，在此我们做这样一件事：从头开始，写一个能用的 Redux。我们的实现不会考虑所有的情况，但可以揭示大部分 Redux 的原理。

注意，实际上我们将会实现的是 [Redux](https://github.com/reactjs/redux?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) **和** [React Redux](https://github.com/reactjs/react-redux?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)。在这里，我们把 Redux 和著名的 UI 库 [React](https://facebook.github.io/react/) 相结合，而这正是在实际场景中最为常见的组合。哪怕你把 Redux 和其他东西组合，这里讲解的所有东西几乎也还是一样的。

我们开始吧！

## 实现自己的状态对象

大多数应用都会从服务端获取状态。我们先从在本地创建状态开始实现（即使我们是从服务端获取状态，也要先用一些状态来初始化应用）。我们将构建一个简单的笔记本应用，这样可以不用再去做千篇一律的 TODO 应用，而后文也可以看到，做这个笔记本应用也会驱使我们做一些有趣的东西来控制状态。

```js
const initialState = {
  nextNoteId: 1,
  notes: {}
};
```

首先，注意我们的数据只是一个简单的 JS 对象。Redux 会帮助我们**管理状态的改变**，但它并不太关心状态本身。

## 为何使用 Redux？

在我们继续深入之前，首先来看看不使用 Redux 要怎样开发我们创建的应用。首先，我们需要把 `initialState` 对象绑定到 `window` 上，像这样：

```js
window.state = initialState;
```

这就是我们的 store！现在我们不需要什么 Redux，直接来构建一个新的笔记组件吧：

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

你可以在 [JSFiddle](https://jsfiddle.net/justindeal/5j3can1z/102/) 尝试这个例子。

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
        // 显然我们需要显示一些比 id 更有趣的东西。
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

虽然这不是一个很实用的应用，但它能正常工作。看起来我们已经证明了不用 Redux 也能做出记事本，所以这篇文章已经完结了~

并没有…

让我们展望一下：我们之后加入了一些新的特性，开发了一个很好的服务端，成立了一个公司来销售它，得到了大量用户，然后又添加了大量的新特性，赚了些钱，扩大公司……（想太多了）

（在这个简单的记事本应用中很难看出来）在我们通向成功的道路上，这个应用可能不断的增大，包含数百个文件中的数百个组件。我们的应用会执行异步操作，所以我们将会有这样的代码：

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

也会有这样的 bug：

```js
const ARCHIVE_TAG_ID = 0;

const onAddTag = (noteId, tagId) => {
  window.state.onLoading = true;
  // 哎呀，这里忘记渲染了！
  // 使用速度快的本地服务器时，我们可能不会发现。
  api.addTag(noteId, tagId)
    .then(() => {
      window.state.onLoading = false;
      window.state.tagMapping[tagId] = noteId;
      if (ARCHIVE_TAG_ID) {
        // 哎呀，一些命名 bug。可能是由于粗暴的搜索/替换产生的。直到我们测试这个没人真正使用的档案页面时，我们才会发现。
        window.state.archived = window.state.archive || {};
        window.state.archived[noteId] = window.state.notes[noteId];
        delete window.state.notes[noteId];
      }
      renderApp();
    });
};
```

以及一些奇奇怪怪、临时的状态改变，几乎没人知道它们是做什么的：

```js
const SomeEvilComponent = () => {
  <button onClick={() => window.state.pureEvil = true}>Do Evil</button>
};
```

在很长一段时间内，很多开发者在大型代码库中共同添加代码，我们将会遇到一系列的问题：

1. 渲染可能在任何地方触发。将会有奇怪的 UI 卡顿或卡死，而且看起来似乎是随机的。
2. 潜在的竞态条件，甚至在我们看到的少量代码里就存在。
3. 状态太混乱几乎不能进行测试。你必须让**整个**应用处于特定状态，然后不断调试状态，看看**整个**应用的状态是否如你所料。
4. 如果你发现一个 bug，你可以有根据地猜测去哪修复，但最终，你的应用中的每一行代码都有嫌疑。

最后一点是最糟糕的问题，也是我们选择 Redux 的主要原因。如果你想要降低整个应用的复杂性，最好（我个人的观点）通过限制如何、以及在哪里可以改变应用的状态。Redux 不是解决其它问题的灵丹妙药，但是这些限制会让问题出现更少。

## Reducer

所以 Redux 是怎样提供这些限制并帮助你管理状态的呢？从一个输入当前状态并返回新状态的简单函数开始说明。对于我们的笔记本应用，如果我们提供一个添加笔记的动作，应当得到一个添加新笔记后的状态：

```js
const CREATE_NOTE = 'CREATE_NOTE';
const UPDATE_NOTE = 'UPDATE_NOTE';

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE:
      return // 有新笔记的状态
    case UPDATE_NOTE:
      return // 更新笔记之后的状态
    default:
      return state
  }
};
```

如果你不爽 `switch` 语句，也可以用其他方式写 reducer。我经常使用一个对象，并让 key 指向每种类型的 handler，像这样：

```js
const handlers = {
  [CREATE_NOTE]: (state, action) => {
    return // 新笔记的新状态
  },
  [UPDATE_NOTE]: (state, action) => {
    return // 修改笔记后的新状态
  }
};

const reducer = (state = initialState, action) => {
  if (handlers[action.type]) {
    return handlers[action.type](state, action);
  }
  return state;
};
```

写法并不重要。reducer 是你自己写的函数，可以用任何方式来实现它。Redux 完全不关心你怎么做的。

### 不可变性

Redux 关心的是，你的 reducer 必须是**纯函数**。意味着你绝对不能这样写：

```js
const reducer = (state = initialState, action) => {
  switch (action.type) {
    case CREATE_NOTE: {
      // 不要这样改变状态!!!
      state.notes[state.nextNoteId] = {
        id: state.nextNoteId,
        content: ''
      };
      state.nextNoteId++;
      return state;
    }
    case UPDATE_NOTE: {
      // 不要这样改变状态!!!
      state.notes[action.id].content = action.content;
      return state;
    }
    default:
      return state;
  }
};
```

实际上，如果你像这样改变状态，Redux 将不会正常工作。因为虽然你在改变状态，但是对象的引用不会改变（组件绑定的状态是绑定对象的引用），所以你的应用将不会正确地更新。也会导致不能使用一些 Redux 开发者工具，因为这些工具跟踪的是先前的状态。如果你在持续性地修改状态，将不能进行状态回退。

原则上，修改状态使得组建自己的 reducer（也可能包括应用的其他部分）更困难。纯函数是可预测的，因为他们在同样的输入下会产生同样的输出。如果你养成了修改状态的习惯，一切就都完了。函数调用变得不确定。你必须在头脑中记住整棵函数调用树。

这种可预测性的代价很高，尤其是因为 JavaScript 原生不支持不可变对象。在本文的例子中，我们将使用原生 JavaScript，需要多写一些冗余的代码。以下是我们写 reducer 的正确方式：

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

我在使用[对象扩展语法](https://github.com/tc39/proposal-object-rest-spread?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)（`...`）。如果你想使用较传统的 JavaScript 语法，可以使用 `Object.assign`。理念都是一样的：不要改变状态，而是为任何状态、嵌套对象、数组创建浅拷贝。对于任何不变的对象，我们只引用存在的部分。我们再仔细看一下这部分代码：

```js
return {
  ...state,
  notes: {
    ...state.notes,
    [id]: editedNote
  }
};
```

我们只改变 `notes` 属性，而 `state` 属性将保持不变。`...state` 的含义是，复用已经存在的属性。类似地，在 `notes` 中，我们只改变我们正在编辑的部分，`...state.notes` 中的其他部分将不会改变。这样，我们可以借助 [`shouldComponentUpdate`](https://reactjs.org/docs/react-component.html#shouldcomponentupdate) 或 [`PureComponent`](https://reactjs.org/docs/react-api.html#reactpurecomponent)，使得有未改变的 note 作为 props 的组件避免重复渲染。记住，我们还需要避免像这样写 reducer：

```js
const reducer = (state = initialState, action) => {
  // 好了，我们避免了修改，但是……千万别这样做！
  state = _.cloneDeep(state)
  switch (action.type) {
    // ...
    case UPDATE_NOTE: {
      // 现在可以做些改变了
      state.notes[action.id].content = action.content;
      return state;
    }
    default:
      return state;
  }
};
```

你又得到了简练的修改对象的代码，而且**实际上** Redux 可以在这种情况下正常工作，但是将无法进行优化。每个对象和数组在每次状态改变时都会是全新的，所以任何依赖于这些对象和数组的组件都将会重新渲染，哪怕你实际上没有对这些组件的状态做任何修改。

我们不可变的 reducer 肯定需要更多的类型定义，也会有更高的学习成本。但以后，你将会为改变状态的函数是独立的，而且容易测试而感到高兴。对于一个真实的应用，你**可能**想要看一下像 [lodash-fp](https://github.com/lodash/lodash/wiki/FP-Guide?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)，或 [Ramda](http://ramdajs.com/) 或 [Immutable.js](https://facebook.github.io/immutable-js/)。在这里，我们使用 [immutability-helper](https://github.com/kolodny/immutability-helper?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 的一个变种，它很简单。提醒一下，这里有很大的坑，我甚至为此写了[一个新的库](https://github.com/jdeal/qim?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)。原生的 JS 也很不错，而且有很好且强壮的类型定义解决方案，如 [Flow](https://flow.org/) 和 [TypeScript](https://www.typescriptlang.org/)。确保使用较小粒度的函数，就像你使用 React 时的情况一样：虽然总体上会比 jQuery 使用更多代码，但是每个组件都更容易预测。

### 使用我们的 Reducer

我们来把一个 action 接入我们的 reducer，并生成一个新的 state。

```js
const state0 = reducer(undefined, {
  type: CREATE_NOTE
});
```

现在 `state0` 看起来像这样：

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

注意，我们把 `undefined` 作为状态的输入。Redux 总是传入 `undefined` 作为初始状态，而且你一般需要使用 `state = initialState` 这样的方式来选择初始状态对象。下一次， Redux 将会输入先前的状态。

```js
const state1  = reducer(state0, {
  type: UPDATE_NOTE,
  id: 1,
  content: 'Hello, world!'
});
```

现在 `state1` 看起来像这样：

```js
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

你可以在这里使用我们的 reducer[（代码链接）](https://jsfiddle.net/justindeal/kLkjt4y3/37/)：

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

当然，Redux 并不会像这样创建更多的变量，但我们将会很快讲到真正的实现。重点是，Redux 的核心只是你写的一小块代码，一个简单地接收上一个状态，并返回下一个状态的函数。为什么这个函数被叫做 reducer？因为它可以被接入标准的 [`reduce`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce) 函数。

```js
const actions = [
  {type: CREATE_NOTE},
  {type: UPDATE_NOTE, id: 1, content: 'Hello, world!'}
];

const state = actions.reduce(reducer, undefined);
```

然后，`state` 将会看起来和之前的 `state1` 一样：

```js
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

你可以在这里向我们的 `actions` 数组添加元素，并输入给 reducer[（代码链接）](https://jsfiddle.net/justindeal/edogdh33/13/)：

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

现在，你可以理解为什么 Redux 自称为“一个可预测的 JavaScript 应用状态容器”。输入一系列相同的 action，你将得到相同的状态。函数式编程必胜！如果你听说过 Redux 可以复现之前的状态，这就是大致的原理。实际上，Redux 并不会引用一个 action 列表，而是会使用一个变量指向状态对象，然后不断改变这个变量指向下一个状态的对象。这是在你的应用中允许的一个重要的改变（mutation），但是我们需要把这种改变控制在 store 中。

## Store

我们来创建一个 store 吧。它可以保存我们单个的状态变量，并提供一些存取状态的方法。

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

现在你可以看到，我们为什么使用常量而不是字符串。我们对于 action 的检测比 Redux 更宽松，但也足以保证我们不拼错 action 类型。如果我们传入字符串，action 将会直接进入 reducer 的默认分支（switch 的 default），什么都不会发生，错误可能会被忽视。但如果我们使用常量，拼写错误将会导致返回 `undefined` 并抛出错误，让我们立刻发现错误并修复它。

我们来创建一个 store 并且使用吧：

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

现在已经可以使用了。我们有了一个 store，它可以使用任何我们提供的 reducer 来管理状态。但是还缺少一个重要的部分：一种订阅状态改变的方法。没有这种方法，我们就需要用一些笨拙的命令式代码。如果将来我们引入了异步 actions，它就完全不能用了。所以我们来实现订阅吧：

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

这是一点点额外的并不**太**难理解的代码。其中的 `subscribe` 函数接收一个 `handler` 函数并把它添加到 `subscribers` 列表中。它还会返回一个用于取消订阅的函数。任何时候我们调用了 `dispatch`，我们就通知所有这些 handler。现在每次状态改变时，重新渲染就很简单了。

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

可以在 [JSFiddle](https://jsfiddle.net/justindeal/8cpu4ydj/27/) 中尝试这些代码，并发出更多的 action。渲染的 HTML 将总是反映 store 状态。当然，对于真正的应用，我们将会把 `dispatch` 函数和用户的 action 联系起来。我们将会很快讲到这部分。

## 创建自己的组件

如何写出可以和 Redux 配合使用的组件呢？只用简单的接收 props 的 React 组件就行了。你实现了你自己的状态，所以写的组件能和这些状态（至少是一部分状态）配合就可以了。有一些特殊情况**可能会**影响你的组件设计（特别是涉及到性能问题的时候），但是在大多数情况，简单的组件都不会有问题。我们从最简单的组件开始开发我们的应用吧：

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

没什么特别的。我们可以把 props 输入给这些组件，并且渲染它们。但是需要注意传入的 `openNoteId` 属性以及 `onOpenNote` 和 `onCloseNote` 的回调：我们需要决定状态和回调存放在哪里。我们可以直接使用组件的 state，这当然没问题。但当你开始使用 Redux，也没有规定说**所有**的状态都必须放到 Redux store 中。如果你想知道什么时候使用 store 存放状态，只要问自己：

> **组件卸载后，这个状态还需要存在吗？**

如果不需要，很可能采用组件自身的 state 存储状态更合适。对于需要保存在服务器，或者跨组件（各组件独立加载和卸载）共享的状态而言，Redux 很可能是更好的选择。

有时候 Redux 很适用于易变的状态。特别是状态需要随着 store 中状态的改变而改变时，把它存放在 store 中可能更容易一些。对于我们的应用而言，当我们创建一个笔记时，我们需要把 `openNoteId` 设置为新的笔记 id。在组件中做这件事很笨拙，因为我们需要在 `componentWillReceiveProps` 中监控 store 状态的变化。我并不是说这是错的，只是这样很笨拙。所以对于我们的应用，我们将把 `openNoteId` 保存在 store 状态中（在真实的应用中，我们可能还需要用到路由。后文也简单介绍了使用路由的情况）。

另一个需要把易变状态放在 store 中的原因是可能是为了更容易从 Redux 开发者工具中访问它。通过 Redux 开发工具可以更容易的查看 store 中存储的数据，同时还可以使用状态回退之类的有趣的功能。从组件内部状态开始，再切换到 store 状态是很容易的。只要提供一个容器组件来将本地状态进行包装即可，就像用 store 来包装全局状态一样。

那么，我们来修改我们的 reducer 来处理易变状态吧：

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

## 手动组装起来

好了，现在我们可以把整个东西组装起来。我们不会修改现有的组件。我们将会创建新的容器组件，从 store 获取状态并传递给 `NoteApp`：

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

哈哈，可以了！[在 JSFiddle 试试这个应用](https://jsfiddle.net/justindeal/8bL9tL0z/23/)

现在应用通过派发 action 来使得 reducer 更新 store 存储的状态数据，同时使用订阅确保了视图渲染的数据和 store 状态数据保持同步。如果遇到状态数据异常，我们不再需要检查组件本身，只需要检查触发的 actions 和 reducer 即可。

## Provider 和 Connect

好了，所有东西都能用了。但是…还有些问题。

1. 绑定操作看起来是命令式的。
2. 容器组件中有很多重复代码。
3. 每次把 store 绑定到组件时，需要使用全局 `store` 对象。否则，我们就需要将 `store` 传遍整个组件树。或者我们要在顶部节点绑定一次，然后把**所有东西**通过树传递下去。这在大型应用中可不太好。

所以我们需要 React Redux 中提供的 `Provider` 和 `connect`。首先，来创建一个 `Provider` 组件：

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

代码很简单，`Provider` 组件使用 React 的 [context 特性](https://facebook.github.io/react/docs/context.html) 来把 `store` 转变成 context 属性。Context 是一种从顶层组件向底层组件传递信息的方式，它不需要中间的组件显式传递信息。总的来说，你应该避免使用 context，因为 [React 文档](https://facebook.github.io/react/docs/context.html#why-not-to-use-context) 这样说：

> **如果你想要你的应用稳定，不要使用 context。这是个试验 API，并可能在未来的 React 版本中被放弃。**

这就是我们自己使用代码实现而不直接使用 context 的原因。我们把这个试验 API 封装起来，这样如果它变了，我们可以改变自己的实现，而不需要开发者修改代码。

所以我们需要一种方式把 context 转化成 props。这就是 `connect` 的作用。

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

这有一点点复杂。说实话，和真正的实现相比，我们偷懒了**很多**（我们将在本文结尾的性能一节中讨论），但已经和真正的 Redux 的大概原理很接近了。`connect` 是一个[高阶组件](https://facebook.github.io/react/docs/higher-order-components.html)，实际上它更像是高阶函数，它接收两个函数，并返回一个以组件为输入、新的组件为输出的函数。这个组件订阅 store，并且在发生改变时更新你的组件的 props。开始使用这个 `connect` 吧，它会变得更实用的。

## 自动组装

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

嘿，看上去好多了！

传给 `connect` 的首个函数（`mapStateToProps`）从我们的 `store` 中获取当前的 `state` 并返回一些 props。第二个传给 `connect` 的函数（`mapDispatchToProps`）会获取我们 `store` 的 `dispatch` 方法，并返回一些 props。`connect` 给我们返回了一个新的函数，把我们的组件 `NoteApp` 传给这个函数，会得到一个新的组件，它将会自动获取所有这些 props（和我们额外传入的部分）。

现在我们需要使用我们的 `Provider` 组件，以使得 `connect` 不必把 store 放在 `context` 中。

```jsx
ReactDOM.render(
  <Provider store={store}>
    <NoteAppContainer/>
  </Provider>,
  document.getElementById('root')
);

```

很好！我们的 `store` 被在顶部传入一次，然后使用 `connect` 接收 `store` 来完成所有的工作（声明式编程万岁！）。[**这是我们用 `Provider` 和 `connect` 整理好的应用**](https://jsfiddle.net/justindeal/srnf5n20/10/)

## 中间件

现在我们已经写了一些很实用的东西，但还缺了一块：在某些环节中，我们需要和服务器通信。现在我们的 action 是同步的，该如何发出**异步** 的 action 呢？我们可以在组件中获取数据，但是这有一些问题：

1. Redux（除了 `Provider` 和 `connect`）并不是专用于 React 的。最好有一个 Redux 解决方案。
2. 在拉取数据时，我们有时候需要访问状态。我们并不想把状态传递得到处都是。所以我们想要写一个类似于 `connect` 的东西来获取数据。
3. 我们在测试涉及到数据获取的状态变化时，必须要通过组件来测试。我们应该尽量把数据获取解耦。
4. 又有一些工具不能用了。

Redux 是同步的，我们应该怎么做呢？把一些东西放在 dispatch 和改变 store 状态的操作之间。这就是中间件。

首先，我们需要一种把中间件传给 store 的方式：

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

变得复杂了一些。重要的是最后的 `if` 语句：

```js
if (middleware) {
  const dispatch = action => store.dispatch(action);
  store.dispatch = middleware({
    dispatch,
    getState
  })(coreDispatch);
}
```

我们了创建一个”重新派发 action“的函数：

```js
const dispatch = action => store.dispatch(action);
```

如果中间件决定要发出一个新的 action，这个 action 将会通过中间件传递下去。我们需要创建这个函数，因为我们需要修改 store 的 `dispatch` 方法。（这也另一个用可变对象简化问题的例子，我们开发 Redux 时可以破坏规则，只要它能够帮助开发者遵守规则。`^_^`）

```js
store.dispatch = middleware({
  dispatch,
  getState
})(coreDispatch);
```

上面的代码调用了中间件，传给它一个能进行“re-dispatch”的函数和 `getState` 的函数。这个中间件需要返回一个新的函数，拥有用来接收调用下一个 dispatch 函数的能力（原始的 dispatch 函数）。如果你读到这里觉得头晕了，不要担心。创建和使用中间件实际上是很容易的。

Okay，我们来创建一个延迟一秒再 dispatch 的中间件。它没有实际用处，但能够说明异步的原理：

```js
const delayMiddleware = () => next => action => {
  setTimeout(() => {
    next(action);
  }, 1000);
};
```

这个函数的签名就看起来很傻，但是能够嵌入我们之前创建的拼图中。它是一个函数，返回一个接受下一个 dispatch 函数的函数，这个函数接受 action。看起来似乎 Redux 在疯狂使用箭头函数，但这是有原因的，我们将很快说明。

现在，我们开始在 store 中使用这个中间件吧。

```js
const store = createStore(reducer, delayMiddleware);
```

哈，我们把我们的 app 变慢了！这可不妙。但是我们有异步操作了！请试一试[这个糟糕的应用](https://jsfiddle.net/justindeal/56uf0uy7/7/)，打字延时显得非常可笑。

调整 `setTimeout` 时间可以把它变得更糟糕，或更好些。

## 组装中间件

来写一个更有用的中间件，用于记录日志吧：

```js
const loggingMiddleware = ({getState}) => next => action => {
  console.info('before', getState());
  console.info('action', action);
  const result = next(action);
  console.info('after', getState());
  return result;
};
```

这就很有用了。我们把它加入我们的 store 中。但是我们的 store 只能接收一个中间件函数，因此需要一种方式来组装我们的中间件。所以，我们需要一种方法，来把很多中间件函数变成一个中间件函数。来写 `applyMiddleware` 吧：

```js
const applyMiddleware = (...middlewares) => store => {
  if (middlewares.length === 0) {
    return dispatch => dispatch;
  }
  if (middlewares.length === 1) {
    return middlewares[0](store);
  }
  const boundMiddlewares = middlewares.map(middleware =>
    middleware(store)
  );
  return boundMiddlewares.reduce((a, b) =>
    next => a(b(next))
  );
};
```

这不是个优雅的函数，但你应该可以跟得上。首先需要注意的是它接收一个中间件的列表，并返回一个中间件函数。这个新的中间件函数和之前的中间件有同样的签名。它接收一个 store（只包含新的派发 action 的 `dispatch` 和 `getState` 方法，不是整个 store）并返回另一个函数。对于这个函数：

1. 如果我们没有中间件，返回和原来一样的函数。基本上只是一个什么都不做的中间件（很蠢，但我们只是防止人们搞破坏）。
2. 如果我们有一个中间件，直接返回这个中间件函数（也很蠢，只是做了个搬运工而已）。
3. 我们把所有中间件绑定在我们假的 store 上（终于有趣起来了）。
4. 我们把这些函数一个个绑定到下一个 dispatch 函数上。这就是我们的中间件有这么多箭头的原因。我们得到了这么一个函数：能够接收 action，并不断调用下一个 dispatch 函数直至抵达最原始的 dispatch 函数。

好了，现在我们可以按预期使用所有的中间件了：

```js
const store = createStore(reducer, applyMiddleware(
  delayMiddleware,
  loggingMiddleware
));
```

现在我们的 Redux 实现可以做所有的事了！[试试看](https://jsfiddle.net/justindeal/3ukd4mL7/52/)！

在浏览器中打开控制台，可以看到日志中间件发挥作用了。

## Thunk 中间件

我们来做些真的异步操作吧。在此介绍一种“thunk”中间件：

```js
const thunkMiddleware = ({dispatch, getState}) => next => action => {
  if (typeof action === 'function') {
    return action(dispatch, getState);
  }
  return next(action);
};
```

“Thunk”真的只是“函数”的另一个名称，但是它通常意味着“封装了一些未来处理的工作的函数”。如果我们加入 `thunkMiddleware`：

```js
const store = createStore(reducer, applyMiddleware(
  thunkMiddleware,
  loggingMiddleware
));
```

现在我们可以这样做：

```js
store.dispatch(({getState, dispatch}) => {
  // 从 state 中取数据
  const someId = getState().someId;
  // 根据获取到的数据从服务端拉取数据
  fetchSomething(someId)
    .then((something) => {
      // 任何时候都可以派发 action
      dispatch({
        type: 'someAction',
        something
      });
    });
});
```

Thunk 中间件是一柄大锤，我们可以把任何东西从 state 中拉出来，并在任何时候把任何 action 派发出去。这十分方便灵活，但随着你的 app 变得越来越大，它**可能**变得危险。但在这里还挺好用的。我们用它来做一些异步操作吧。

首先，创建一个假的 API：

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

这个 API 只支持一个创建笔记的方法，并返回这个笔记的 id。因为我们从服务端获取 id，我们需要进一步改动我们的 reducer：

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

这里，我们在使用 `CREATE_NOTE` action 来设置加载状态，以及在 store 中创建笔记。我们只用`id` 属性的存在与否来标记这种区别。你可能需要使用不同的 action，但 Redux 并不关心你使用什么。如果你想要一些规范，可以看看 [Flux Standard Actions](https://github.com/acdlite/flux-standard-action?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)。

现在，让我们修改 `mapDispatchToProps` 来发出 thunk 吧：

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

我们的应用在执行异步操作了！[试试看](https://jsfiddle.net/justindeal/o27j5zs1/8/)！

但等等... 除了给我们的组件添加一些丑陋的代码以外，我们还发明了中间件来把这些代码清理出去。但现在又放回去了。如果我们创建了一些定制的 api 中间件而不是使用 thunk，我们就可以避免这种情况。哪怕是使用 thunk 中间件，我们也可以把代码变得更像声明式。

## Action 创建器

我们可以把在组件中发出 thunk 的操作抽象出来，放进一个函数：

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

上面的代码发明了一个 action 创建器。这不是什么奇特的东西，只是一个返回 action 的函数。它可以：

1. 把我们的新 thunk action 等丑陋的 action 抽象出来。
2. 如果多个组件使用同样的 action，可以帮助你实现 DRY 原则。
3. 让我们把创建 action 的操作抽象出来，使我们的组件更简洁。

我们可以早些创建 action 创建器，但是并没有什么理由这样做。我们的应用很简单，所以不需要重复同样的 action。我们的 action 很简单，已经足够简洁和声明式了。

来使用 action 创建器修改一下我们的 `mapDispatchToProps`吧：

```js
const mapDispatchToProps = dispatch => ({
  onAddNote: () => dispatch(createNote()),
  // ...
});
```

这样就好多了！[这是我们最终的应用](https://jsfiddle.net/justindeal/5j3can1z/171/)。

## 就这样！

你自己写了一个 Redux！看起来这篇文章写了很多代码，但是主要是我们的 reducer 和组件。我们实际的 Redux 实现还不到 [140 行代码](https://gist.githubusercontent.com/jdeal/c224026df3bae5803fd9e58cbbd4a60b/raw/623150cb62a7076e78904881b61d4c948639abe8/mini-redux.js)，包括了我们的 thunk 和日志中间件、空行和注释！

真实的 Redux 和真实的应用比这复杂一些。后文中我们将讨论其中一些没讲到的情况，如果你觉得自己掉进 Redux 的坑里了，但愿这能给你带来一些希望。

## 遗留事项

### 性能

我们的实现所缺少的是，监听特定属性是否真的改变了的能力。对于我们的示例应用而言，这并不要紧，因为每个状态变化都造成了属性的改变。但对于有很多 `mapStateToProps` 函数的大型应用而言，我们只想要在组件真的接收新属性时更新。要扩展我们的 `connect` 函数来实现这一点是很容易的。我们只需要在调用 `setState` 时比较前后的数据即可。我们需要更聪明地使用 `mapDispatchToProps`。注意，我们每次都在创建新的函数。真正的 React Redux 库会检查函数的参数，看看它是否依赖`属性`。这样，如果属性没有真的改变，就不需要再做一次映射。

你也需要注意，当我们在属性或者 store 状态改变时，会调用我们的函数。这些改变可能会瞬间同时发生，从而浪费一些性能。React Redux 优化了这一点，也优化了很多其他东西。

除此之外，对于更大的应用，我们需要考虑选择器的性能。比如，如果我们过滤一系列的笔记，我们可不想不停重复计算这个列表。为此，我们需要使用例如 [reselect](https://github.com/reactjs/reselect?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 或者其它的技术来缓存结果。

### 冻结状态

如果你使用原始 JS 数据结构（而不是像 Immutable.js 这样的东西），那么我遗漏的一个很重要的细节是在开发时冻结 reducer 状态。因为这是 JavaScript，没有什么阻止你在从 store 中获取状态之后改变它。你可以在 `render` 方法或者别的任何东西中改变它。这会造成非常糟糕的结果，并且毁坏一些正在通过 Redux 加入的可预见性。我是这样做的：

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

这创建了一个冻结了结果的 reducer。这样，如果你想要改变组件中的 store 状态，它将会在开发环境报错。过一段时间，你将能够避免这些错误。但如果你新接触不可变数据，这可能是最容易的练习方式了，对于你和你的团队来说都是如此。

### 服务端渲染

除了性能以外，我们还在我们的 `connect` 实现上偷了懒，忽略了服务端渲染。`componentWillMount` 可以在服务端被调用，但是我们不想在服务端设置监听。Redux 使用 `componentDidMount` 和一些其他技巧来使它在浏览器中正常工作。

### Store 增强

我们并没有写几个高阶函数，这儿就有一个遗漏的：“store 增强器”是一个高阶函数，接收一个 store 创建器并返回一个“增强版”的 store 创建器。这不是一个常见的操作，但它可以被用来创造 Redux 开发者工具之类的东西。**真正的** [`applyMidleware` 实现](https://github.com/reactjs/redux/blob/4d8700c9631b152f0dff384d528a6c7f74024418/src/applyMiddleware.js?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 就是一个 store 增强器。

### 测试

这个 Redux 的实现都没有进行任何测试。因此无论如何，请不要在任何实际的产品中使用这个实现！这只是在本文中用于说明 Redux 原理的！

### 排序

这款笔记应用目前是将数据保存在以数字作为 key 的对象中。这意味着每一个 JS 引擎都会按照创建的顺序来给它们排序。如果我们的服务器返回 GUID 或者其它未排序的主键，我们将很难排序。我们不想把笔记存放在数组中，因为要通过 id 获取特定笔记就不容易了。所以对于真实应用而言，我们可能需要用数组存放排好序的 id。另外，如果用 `reselect` 来缓存 `find` 操作结果的话，也可以尝试使用数组。

### Action 创建器的副作用

有时候，你可能会想要创建一些这样的中间件：

```js
store.dispatch(fetch('/something'));
```

别这样做，一个返回了 promise 的函数实际上已经开始运行了（除非它是个不正常的延迟 promise）。这也意味着我们无法用任何中间件来处理这个 action。比如，我们就不能使用节流中间件。另外我们也不能正常使用回放，因为这需要关闭 dispatch 函数。但是任何调用这个 `dispatch` 的代码都已经完成了工作，所以不能把它停掉。

确保你的 action 是对副作用的一种描述，而不是副作用本身。Thunk 是不透明的，不是最好的描述，但是它们也是对副作用的描述而不是副作用本身。

### 路由

路由可能会很奇怪，因为浏览器持有当前位置的一些状态，还有一些用于改变位置的方法。你一旦开始使用 Redux，就可能想要把路由状态放在 Redux store 中。我就是这样做的，所以我创建了一个[路由库](https://github.com/zapier/redux-router-kit?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)来做这件事。也可以使用新版本的 [React 路由](https://reacttraining.com/react-router/) 很酷，而且还有其它非 Redux 的路由解决方案。基本上，只要你想用，就可以找一些路由库来完成尽可能多的工作。

### 其它事项

基于 Redux，有大量中间件和工具组成的生态系统。下面罗列了一部分项目，你可以都看看，但推荐还是先熟悉基础知识！

你肯定会想看看 [Redux 开发者工具扩展](https://github.com/zalmoxisus/redux-devtools-extension?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 或者 [Redux 开发者工具](https://github.com/gaearon/redux-devtools?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 本身的代码。这些扩展是最简单的使用开发者工具的方式。

[Logger for Redux](https://github.com/evgenyrodionov/redux-logger?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 是一个很方便的把 action 输出到控制台的中间件。

如果你想要发出多个同步 action，但只触发一次重新渲染，[redux-batched-actions](https://github.com/tshelburne/redux-batched-actions?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 或 [redux-batch](https://github.com/manaflair/redux-batch?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 会有用。

如果异步 action 或副作用在使用 [redux-thunk](https://github.com/gaearon/redux-thunk?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 后看起来难以控制，而你又不想自己写中间件，你可以看看 [redux-saga](https://github.com/redux-saga/redux-saga?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 或 [redux-logic](https://github.com/jeffbski/redux-logic?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier)。或者，你想要继续深挖的话，[redux-loop](https://github.com/redux-loop/redux-loop?utm_source=zapier.com&utm_medium=referral&utm_campaign=zapier) 也很有趣。

如果你想用 GraphQL，可以看看 [Apollo](http://dev.apollodata.com/)，它可以和 Redux 结合在一起。

尽情享受吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
