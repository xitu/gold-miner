
> * 原文地址：[Five Tips for Working with Redux in Large Applications](https://techblog.appnexus.com/five-tips-for-working-with-redux-in-large-applications-89452af4fdcb)
> * 原文作者：[AppNexus Engineering](https://techblog.appnexus.com/@AppNexus.tech)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/five-tips-for-working-with-redux-in-large-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/five-tips-for-working-with-redux-in-large-applications.md)
> * 译者：[loveky](https://github.com/loveky)
> * 校对者：[stormrabbit](https://github.com/stormrabbit)

# 在大型应用中使用 Redux 的五个技巧

![](http://img20.360buyimg.com/uba/jfs/t5653/322/6027363778/85125/11c9a206/5967231dNdc56ee51.png)

Redux 是一个很棒的用于管理应用程序“状态（state）”的工具。单向数据流以及对不可变数据的关注使得推断状态的变化变得很简单。每次状态变化都由一个 action 触发，这会导致 reducer 函数返回一个变更后的新状态。由于客户要在我们的平台上管理或发布广告资源，在 AppNexus 使用 Redux 创建的很多用户界面都需要处理大量数据以及非常复杂的交互。在开发这些界面的过程中，我们发现了一些有用的规则和技巧以维持 Redux 易于管理。以下的几点讨论应该可以帮助到任何在大型、数据密集型应用中使用 Redux 的开发者：

- 第一点: 在存储和访问状态时使用索引和选择器
- 第二点: 把数据对象，对数据对象的修改以及其它 UI 状态区分开
- 第三点: 在单页应用的不同页面间共享数据，以及何时不该这么做
- 第四点: 在状态中的不同节点复用通用的 reducer 函数
- 第五点: 连接 React 组件与 Redux 状态的最佳实践

### 1. 使用索引（index）保存数据，使用选择器（selector）读取数据

选择正确的数据结构可以对程序的结构和性能产生很大影响。在存储来自 API 的可序列化数据时可以极大的受益于索引的使用。索引是指一个 JavaScript 对象，其键是我们要存储的数据对象的 id，其值则是这些数据对象自身。这种模式和使用 hashmap 存储数据非常类似，在查询效率方面也有相同的优势。这一点对于精通 Redux 的人来说不足为奇。实际上，Redux 的作者 Dan Abramov 在他的 [Redux 教程中](https://egghead.io/lessons/javascript-redux-persisting-the-state-to-the-local-storage)就推荐了这种数据结构。

设想你有一组从 REST API 获取的数据对象，例如来自 `/users` 服务的数据。假设我们决定直接将这个普通数组原封不动地存储在状态中，就像它在响应中那样。当我们需要获取一个特定用户对象时会怎样呢？我们需要遍历状态中的所有用户。如果用户很多，这可能会是一个代价高昂的操作。如果我们想跟踪用户的一小部分，例如选中和未选中的用户呢？我们要么需要把数据保存在两个数组中，要么就要记录这些选中和未选中用户在主数组中的索引（译者注：此处指的是普通意义上的数组索引）。

然而，我们决定重构代码改用索引的方式存储数据。我们可以在 reducer 中以如下的方式存储数据：

```javascript
{
 "usersById": {
    123: {
      id: 123,
      name: "Jane Doe",
      email: "jdoe@example.com",
      phone: "555-555-5555",
      ...
    },
    ...
  }
}
```

那么这种数据结构到底是如何帮助我们解决以上问题的呢？如果要查找一个特定用户，你可以直接用 `const user = state.usersById[userId]` 读取状态。这种方式不需要我们遍历整个列表，节省时间的同时简化了代码。

此时你可能会好奇我们如何通过这种数据结构来展示一个简单的用户列表呢。为此，我们需要使用一个选择器，它是一个接收状态并返回所需数据的函数。一个简单的例子是一个返回状态中所有用户的函数：

```javascript
const getUsers = ({ usersById }) => {
  return Object.keys(usersById).map((id) => usersById[id]);
}
```

在我们的视图代码中，我们调用该方法以获取用户列表。然后就可以遍历这些用户生成视图了。我们可以创建另一个函数用于从状态中获取指定用户：

```javascript
const getSelectedUsers = ({ selectedUserIds, usersById }) => {
  return selectedUserIds.map((id) => usersById[id]);
}
```

选择器模式还同时增加了代码的可维护性。设想以后我们想要改变状态的结构。在不使用选择器的情况下，我们不得不更新所有的视图代码以适应新的状态结构。随着视图组件的增多，修改状态结构的负担会急剧增加。为了避免这种情况，我们在视图中通过选择器读取状态。即使底层的状态结构发生了改变，我们也只需要更新选择器。所有依赖状态的组件仍将可以获取它们的数据，我们也不必更新它们。出于所有这些原因，大型 Redux 应用将受益于索引与选择器数据存储模式。

### 2. 将标准状态与视图状态、编辑状态分隔开

现实中的 Redux 应用通常需要从一些服务（例如一个 REST API）读取数据。在收到数据以后，我们发送一个包含了收到的数据的 action。我们把这些从服务返回的数据称为“标准状态” —— 即当前在我们数据库中存储的数据的正确状态。我们的状态还包含其他类型的数据，例如用户界面组件的状态或是整个应用程序的状态。当首次从 API 读取到标准状态时，我们可能会想将其与页面的其他状态保存在同一个 reducer 文件中。这种方式可能很省事，但当你需要从不同数据源获取多种数据时，它就会变得难以扩展。

相反，我们会把标准状态保存在它单独的 reducer 文件中。这会促使你编写组织更加良好、更加模块化的代码。垂直扩展 reducer（增加代码行数）比水平扩展 reducer（在 `combineReducers` 调用中引入更多的 reducer）的可维护性要差。将 reducers 拆分到各自的文件中有利于复用这些 reducer（在第三点中会详细讨论）。此外，这还可以阻止开发者将非标准状态添加到数据对象 reducer 中。

为什么不把其他类型的状态和标准状态保存在一起呢？假设我们像第一部分一样从 REST API 获得一组用户数据。利用索引存储模式，我们会像下面这样将其存储在 reducer 中：

```
{
 "usersById": {
    123: {
      id: 123,
      name: "Jane Doe",
      email: "jdoe@example.com",
      phone: "555-555-5555",
      ...
    },
    ...
  }
}
```

现在假设我们的界面允许编辑用户信息。当点击某个用户的编辑图标时，我们需要更新状态，以便视图呈现出该用户的编辑控件。我们决定在 `users/by-id` 索引中存储的数据对象上新增一个字段，而不是分开存储视图状态和标准状态。现在我们的状态看起来是这个样子：

```
{
 "usersById": {
    123: {
      id: 123,
      name: "Jane Doe",
      email: "jdoe@example.com",
      phone: "555-555-5555",
      ...
      isEditing: true,
    },
    ...
  }
}
```

我们进行了一些修改，点击提交按钮，改动以 PUT 形式提交回 REST 服务。服务返回了该用户最新的状态。可是我们该如何将最新的标准状态合并到 store 呢？如果我们直接把新对象存储到 `users/by-id` 索引中对应的 id 下，那么 `isEditing` 标记就会丢失。我们不得不手动指定来自 API 的数据中哪些字段需要存储到 store 中。这使得更新逻辑变得复杂。你可能要追加多个布尔、字符串、数组或其他类型的新字段到标准状态中以维护视图状态。这种情况下，当新增一个 action 修改标准状态时很容易由于忘记重置这些 UI 字段而导致无效的状态。相反，我们在 reducer 中应该将标准状态保存在其独立的数据存储中，并保持我们的 action 更简单，更容易理解。

将编辑状态分开保存的另一个好处是如果用户取消编辑我们可以很方便的重置回标准状态。假设我们点击了某个用户的编辑图标，并修改了该用户的姓名和电子邮件地址。现在假设我们不想保存这些修改，于是我们点击取消按钮。这应该导致我们在视图中做的修改恢复到之前的状态。然而，由于我们用编辑状态覆盖了标准状态，我们已经没有旧状态的数据了。我们不得不再次请求 REST API 以获取标准状态。相反，让我们把编辑状态分开存储。现在我们的状态看起来是这个样子：

```
{
 "usersById": {
    123: {
      id: 123,
      name: "Jane Doe",
      email: "jdoe@example.com",
      phone: "555-555-5555",
      ...
    },
    ...
  },
  "editingUsersById": {
    123: {
      id: 123,
      name: "Jane Smith",
      email: "jsmith@example.com",
      phone: "555-555-5555",
    }
  }
}
```

由于我们同时拥有该对象在编辑状态和标准状态下的两个副本，在点击取消后重置状态变得很简单。我们只需在视图中展示标准状态而不是编辑状态即可，不必再次调用 REST API。作为奖励，我们仍然在 store 中跟踪着数据的编辑状态。如果我们决定确实需要保留这些更改，我们可以再次点击编辑按钮，此时之前的修改状态就又可以展示出来了。总之，把编辑状态和视图状态与标准状态区分开保存既在代码组织和可维护性方面提供了更好的开发体验，又在表单操作方面提供了更好的用户体验。

### 3. 合理地在视图之间共享状态

许多应用起初都只有一个 store 和一个用户界面。随着我们为了扩展功能而不断扩展应用，我们将要管理多个不同视图和 store 之间的状态。为每个页面创建一个顶层 reducer 可能有助于扩展我们的 Redux 应用。每个页面和顶层 reducer 对应我们应用中的一个视图。例如，用户页面会从 API 获取用户信息并存储在 `users` reducer 中，而另一个为当前用户展示域名信息的页面会从域名 API 存取数据。此时的状态看起来会是如下结构：

```
{
  "usersPage": {
    "usersById": {...},
    ...
  },
  "domainsPage": {
    "domainsById": {...},
    ...
  }
}
```

像这样组织页面有助于保持这些页面背后的数据之间的解耦与独立。每个页面跟踪各自的状态，我们的 reducer 文件甚至可以和视图文件保存在相同位置。随着我们不断扩展应用程序，我们可能会发现需要在两个视图之间共享一些状态。在考虑共享状态时，请思考以下几个问题：

- 有多少视图或者其他 reducer 依赖此部分数据？
- 每个页面是否都需要这些数据的副本？
- 这些数据的改动有多频繁？

例如，我们的应用在每个页面都要展示一些当前登录用户的信息。我们需要从 API 获取用户信息并保存在 reducer 中。我们知道每个页面都会依赖于这部分数据，所以它似乎并不符合我们每个页面对应一个 reducer 的策略。我们清楚没必要为每个页面准备一份这部分数据的副本，因为绝大多数页面都不会获取其他用户或编辑当前用户。此外，当前登录用户的信息也不太会改变，除非客户在用户页面编辑自己的信息。

在页面之间共享当前用户信息似乎是个好办法，于是我们把这部分数据提升到专属于它的、单独保存的顶层 reducer 中。现在，用户首次访问的页面会检查当前用户信息是否加载，如果未加载则调用 API 获取信息。任何连接到 Redux 的视图都可以访问到当前登录用户的信息。

不适合共享状态的情况又如何呢？让我们考虑另一种情况。设想用户名下的每一个域名还包含一系列子域名。我们增加了一个子域名页面用以展示某个用户名下的全部子域名。域名页面也有一个选项用以展示该域名下的子域名。现在我们有两个页面同时依赖于子域名数据。我们还知道域名信息可能会频繁改动 —— 用户可能会在任何时间增加、删除或是编辑域名与子域名。每个页面也可能需要它自己的数据副本。子域名页面允许通过子域名 API 读取和写入数据，可能还会需要对数据进行分页。而域名页面每次只需要获取子域名的一个子集（某个特定域名的子域名）。很明显，在这些视图间共享子域名数据并不妥当。每个页面应该单独保存其子域名数据。

### 4. 在状态之间复用 reducer 函数

在编写了一些 reducer 函数之后，我们可能想要在状态中的不同节点间复用 reducer 逻辑。例如，我们可能会创建一个用于从 API 读取用户信息的 reducer。该 API 每次返回 100 个用户，然而我们的系统中可能有成千上万的用户。要解决该问题，我们的 reducer 还需要记录当前正在展示哪一页。我们的读取逻辑需要访问 reducer 以确定下一次 API 请求的分页参数（例如 `page_number`）。之后当我们需要读取域名列表时，我们最终会写出几乎完全相同的逻辑来读取和存储域名信息，只不过 API 和数据结构不同罢了。

在 Redux 中复用 reducer 逻辑可能会有点棘手。默认情况下，当触发一个 action 时所有的 reducer 都会被执行。如果我们在多个 reducer 函数中共享一个 reducer 函数，那么当触发一个 action 时所有这些 reducer 都会被调用。然而这并不是我们想要的结果。当我们读取用户得到总数是 500 时，我们不想域名的 `count` 也变成 500。

我们推荐两种不同的方式来解决此问题，利用特殊作用域（scope）或是类型前缀（prefix）。第一种方式涉及到在 action 传递的数据中增加一个类型信息。这个 action 会利用该类型来决定该更新状态中的哪个数据。为了演示该方法，假设我们有一个包含多个模块的页面，每个模块都是从不同 API 异步加载的。我们跟踪加载过程的状态可能会像下面这样：

```
const initialLoadingState = {
  usersLoading: false,
  domainsLoading: false,
  subDomainsLoading: false,
  settingsLoading: false,
};
```

有了这样的状态，我们就需要设置各模块加载状态的 reducer 和 action。我们可能会用 4 种 action 类型写出 4 个不同的 reducer 函数 —— 每个 action 都有它自己的 action 类型。这就造成了很多重复代码！相反，让我们尝试使用一个带作用域的 reducer 和 action。我们只创建一种 action 类型 `SET_LOADING` 以及一个 reducer 函数：

```
const loadingReducer = (state = initialLoadingState, action) => {
  const { type, payload } = action;
  if (type === SET_LOADING) {
    return Object.assign({}, state, {
      // 在此作用域内设置加载状态
      [`${payload.scope}Loading`]: payload.loading,
    });
  } else {
    return state;
  }
}
```

我们还需要一个支持作用域的 action 生成器来调用我们带作用域的 reducer。这个 action 生成器看起来是这个样子：

```
const setLoading = (scope, loading) => {
  return {
    type: SET_LOADING,
    payload: {
      scope,
      loading,
    },
  };
}
// 调用示例
store.dispatch(setLoading('users', true));
```

通过像这样使用一个带作用域的 reducer，我们消除了在多个 action 和 reducer 函数间重复 reducer 逻辑的必要。这极大的减少了代码重复度同时有助于我们编写更小的 action 和 reducer 文件。如果我们需要在视图中新增一个模块，我们只需在初始状态中新增一个字段并在调用 `setLoading` 时传入一个新的作用域类型即可。当我们有几个相似的字段以相同的方式更新时，此方案非常有效。

有时我们还需要在 state 中的多个节点间共享 reducer 逻辑。我们需要一个可以通过 `combineReducers` 在状态中不同节点多次使用的 reducer 函数，而不是在状态中的某一个节点利用一个 reducer 与 action 来维护多个字段。这个 reducer 会通过调用一个 reducer 工厂函数生成，该工厂函数会返回一个添加了类型前缀的 reducer 函数。

复用 reducer 逻辑的一个绝佳例子就是分页信息。回到之前读取用户信息的例子，我们的 API 可能包含成千上万的用户信息。我们的 API 很可能会提供一些信息用于在多页用户之间进行分页。我们收到的 API 响应也许是这样的：

```
{
  "users": ...,
  "count": 2500, // API 中包含的用户总量
  "pageSize": 100, // 接口每一页返回的用户数量
  "startElement": 0, // 此次响应中第一个用户的索引
  ]
}
```

如果我们想要读取下一页数据，我们会发送一个带有 `startElement=100` 查询参数的 GET 请求。我们可以为每一个 API 都编写一个 reducer 函数，但这样会在代码中产生大量的重复逻辑。相反，我们要创建一个独立的分页 reducer。这个 reducer 会由一个接收前缀类型为参数并返回一个新 reducer 的 reducer 工厂生成：

```
const initialPaginationState = {
  startElement: 0,
  pageSize: 100,
  count: 0,
};
const paginationReducerFor = (prefix) => {
  const paginationReducer = (state = initialPaginationState, action) => {
    const { type, payload } = action;
    switch (type) {
      case prefix + types.SET_PAGINATION:
        const {
          startElement,
          pageSize,
          count,
        } = payload;
        return Object.assign({}, state, {
          startElement,
          pageSize,
          count,
        });
      default:
        return state;
    }
  };
  return paginationReducer;
};
// 使用示例
const usersReducer = combineReducers({
  usersData: usersDataReducer,
  paginationData: paginationReducerFor('USERS_'),
});
const domainsReducer = combineReducers({
  domainsData: domainsDataReducer,
  paginationData: paginationReducerFor('DOMAINS_'),
});
```

reducer 工厂函数 `paginationReducerFor` 接收一个前缀类型作为参数，此参数将作为该 reducer 匹配的所有 action 类型的前缀使用。这个工厂函数会返回一个新的、已经添加了类型前缀的 reducer。现在，当我们发送一个 `USERS_SET_PAGINATION` 类型的 action 时，它只会触发维护用户分页信息的 reducer 更新。域名分页信息的 reducer 则不受影响。这允许我们有效地在 store 中复用通用 reducer 函数。为了完整起见，以下是一个配合我们的 reducer 工厂使用的 action 生成器工厂，同样使用了前缀：

```
const setPaginationFor = (prefix) => {
  const setPagination = (response) => {
    const {
      startElement,
      pageSize,
      count,
    } = response;
    return {
      type: prefix + types.SET_PAGINATION,
      payload: {
        startElement,
        pageSize,
        count,
      },
    };
  };
  return setPagination;
};
// 使用示例
const setUsersPagination = setPaginationFor('USERS_');
const setDomainsPagination = setPaginationFor('DOMAINS_');
```

### 5. React 集成与包装

有些 Redux 应用可能永远都不需要向用户呈现一个视图（如 API），但大多数时间你都会想把数据渲染到某种形式的视图中。配合 Redux 渲染页面最流行的库是 React，我们也将使用它演示如何与 Redux 集成。我们可以利用在前几点中学到的策略简化我们创建视图代码的过程。为了实现集成，我们要用到 `react-redux` [库](https://github.com/reactjs/react-redux)。这里就是将状态中的数据映射到你组件的 props 的地方。

在 UI 集成方面一个有用的模式是在视图组件中使用选择器访问状态中的数据。在 `react-redux` 中的 `mapStateToProps` 函数中使用选择器很方便。该函数会在调用 `connect` 方法（该方法用于将你的 React 组件连接到 Redux store）时作为参数传入。这里是使用选择器从状态中获取数据并通过 props 传递给组件的绝佳位置。以下是一个集成的例子：

```
const ConnectedComponent = connect(
  (state) => {
    return {
      users: selectors.getCurrentUsers(state),
      editingUser: selectors.getEditingUser(state),
      ... // 其它来自状态的 props
    };
  }),
  mapDispatchToProps // 另一个 connect 函数
)(UsersComponent);
```

React 与 Redux 之间的集成也提供了一个方便的位置来封装我们按作用域或类型创建的 action。我们必须连接我们组件的事件处理函数，以便在调用 store 的 dispatch 方法时使用我们的 action 生成器。要在 `react-redux` 中实现这一点，我们要使用 `mapDispatchToProps` 函数，它也会在调用 `connect` 方法时作为参数传入。这个 `mapDispatchToProps` 方法就是通常我们调用 Redux 的 `bindActionCreators` 方法将每个 action 和 store 的 dispatch 方法绑定的地方。在我们这样做的时候，我们也可以像在第四点中那样把作用域绑定到 action 上。例如，如果我们想在用户页面使用带作用域的 reducer 模式的分页功能，我们可以这样写：

```
const ConnectedComponent = connect(
  mapStateToProps,
  (dispatch) => {
    const actions = {
      ...actionCreators, // other normal actions
      setPagination: actionCreatorFactories.setPaginationFor('USERS_'),
    };
    return bindActionCreators(actions, dispatch);
  }
)(UsersComponent);
```

现在，从我们 `UsersPage` 组件的角度看来，它只接收一个用户列表、状态的一部分以及绑定过的 action 生成器作为props。组件不需要知道它需要使用哪个作用域的 action 也不需要知道如何访问状态；我们已经在集成层面处理了这些问题。这使得我们可以创建一些非常独立的组件，它们并不依赖于状态内部的细节。希望通过遵循本文讨论的模式，我们都可以以一种可扩展的、可维护的、合理的方式开发 Redux 应用。

**延伸阅读：**

- [Redux](http://redux.js.org/) 本文讨论的状态管理库
- [Reselect](https://github.com/reactjs/reselect) 一个用于创建选择器的库
- [Normalizr](https://github.com/paularmstrong/normalizr) 一个用于根据模式规范 JSON 数据的库，有助于在索引中存储数据
- [Redux-Thunk](https://github.com/gaearon/redux-thunk) 一个用于处理 Redux 中异步 action 的中间件
- [Redux-Saga](https://github.com/redux-saga/redux-saga) 另一个利用 ES2016 生成器处理异步 action 的中间件


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
