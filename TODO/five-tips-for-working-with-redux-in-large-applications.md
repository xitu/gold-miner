
> * 原文地址：[Five Tips for Working with Redux in Large Applications](https://techblog.appnexus.com/five-tips-for-working-with-redux-in-large-applications-89452af4fdcb)
> * 原文作者：[AppNexus Engineering](https://techblog.appnexus.com/@AppNexus.tech)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/five-tips-for-working-with-redux-in-large-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/five-tips-for-working-with-redux-in-large-applications.md)
> * 译者：
> * 校对者：

# Five Tips for Working with Redux in Large Applications

![](https://cdn-images-1.medium.com/max/1200/0*U2DmhXYumRyXH6X1.png)

Redux is an excellent tool for managing the “state” of an application. The unidirectional flow of data and the focus on immutable state makes reasoning about changes to the state simple. Each update to our state is caused by a dispatched action, which causes our reducer function to return a new state with the desired changes. Many of the user interfaces we create with Redux at AppNexus deal with large amounts of data and very complex user interactions as our customers manage their advertisements or publishing inventory on our platform. Over the course of developing these interfaces, we have arrived at some helpful rules and tips to keep Redux manageable. The following points of discussion should help anyone working with Redux on large, data intensive applications:

- [Section 1:](#2032) Using indices and selectors for storing and accessing state
- [Section 2](#b3eb): Separation of state between data objects, edits to those objects, and other UI state
- [Section 3](#f43d): Sharing of state between multiple screens in a Single Page Application, and when not to
- [Section 4](#fe11): Reusing common reducers between different places in state
- [Section 5](#cb70): Best practices for connecting React components to Redux state

### 1. Store data with an index. Access it with selectors.

Choosing the right data structure can make a big difference for our application’s organization and performance. Storing serializable data from an API will greatly benefit from being stored in an index. An index is a javascript object in which the keys are the ids of the data objects we’re storing, and the value is the actual data objects themselves. This pattern is very similar to using a hashmap to store data, and we get the same benefits in terms of lookup time. This is likely unsurprising to those well-versed in Redux. Indeed, Redux’s creator Dan Abramov recommends this data structure in his [Redux tutorial](https://egghead.io/lessons/javascript-redux-persisting-the-state-to-the-local-storage).

Imagine you have a list of data objects fetched from a REST API, e.g. data from the `/users` service. Let’s assume that we decided to simply store the plain array in our state, just as it is in the response. What happens when we need to retrieve a specific user object? We would need to iterate over all the users in state. If there are many users, this could be a costly operation. What if we wanted to keep track of a subset of users, perhaps selected and unselected users? We either need to store the data in two separate arrays, or keep track of the indices in the main array of the selected and unselected users.

Instead, we decide to refactor our code to store the data in an index. We would store the data in our reducer like so:

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

So how does this data structure help us with these problems? If we need to lookup a specific user object, we simply access the state like so: `const user = state.usersById[userId]`. This method of access does not require us to iterate over the whole list, saving us time and simplifying our retrieval code.

At this point you may be wondering how we actually accomplish rendering a simple list of users with these data structures. To do so, we will use a selector, which is a function that takes the state and returns your data. A simple example would be a function to get all the users in our state:

```
const getUsers = ({ usersById }) => {
  return Object.keys(usersById).map((id) => usersById[id]);
}
```

In our view code, we call that function with our state to produce the list of users. Then we can iterate over those users and produce our view. We could make another function to get just the selected users from our state like so:

```
const getSelectedUsers = ({ selectedUserIds, usersById }) => {
  return selectedUserIds.map((id) => usersById[id]);
}
```

The selector pattern also increases our code’s maintainability. Imagine that later on we wish to change the shape of our state. Without selectors, we will be required to update all of our view code as well to match the new state shape. As the number of view components increases, the burden of changing state shape increases drastically. To avoid this problem, we will use selectors to access state in our views. If the underlying state shape changes, we just update the selector to access state in the correct way. All of the consuming components will still get their data, and we don’t have to update them. For all these reasons, large Redux applications will benefit from the index and selector data storage pattern.

### 2. Separate canonical state from view and edit state

Real-world Redux applications usually need to fetch some kind of data from another service, such as a REST API. When we receive that data, we dispatch an action with the payload of whatever data we got back. We refer to data returned from a service as “canonical state” — i.e. the current correct state of the data as it is stored in our database. Our state also contains other kinds of data such as the state of user interface components or of the application as a whole. The first time we retrieve some canonical data from our API, we might be tempted to store it in the same reducer file as the rest of our state for a given page. Although this approach may be convenient, it is difficult to scale when you need to fetch many kinds of data from a variety of sources.

Instead, we will separate out the canonical state into its own reducer file. This approach encourages better code organization and modularity. Scaling reducer files vertically (adding more lines of code) is less maintainable than scaling them horizontally (adding more reducer files to the `combineReducers` call). Breaking reducers out into their own files makes it easier to reuse those reducers (more on that in [Section 3](http://techblog.appnexus.com/#section3)). Additionally, it discourages developers from adding non-canonical state into the data object reducers.

Why not store other kinds of state with canonical state? Imagine we have the same list of users that we fetched from our REST API. Using the index storage pattern, we would store the data in our reducer like so:

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

Now imagine that our UI allows the users to be edited in the view. When the edit icon is clicked for a user, we need to update our state so that the view renders the edit controls for that user. Instead of keeping our view state out of the canonical state, we just decide to put it in as a new field on the objects stored in the `users/by-id` index. Now our state might look something like this:

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

We make some edits, click the submit button, and the changes are PUT back to our REST service. The service returns back the new state of that object. But how do we merge our new canonical state back into our store? If we just set the new object for the user at their id key in the `users/by-id` index, then our `isEditing` flag will no longer be there. We now need to manually specify which fields on the API payload we need to put back into the store. This complicates our update logic. You may have multiple booleans, strings, arrays, or other new fields necessary for UI state that would get appended on to the canonical state. In this situation it is easy for to add a new action for modifying canonical state but forget to reset the other UI fields on the object, resulting in an invalid state. Instead we ought to keep canonical data in its own independent data store in the reducer, and keep our actions simpler and easier to reason about.

Another benefit to keeping edit state separate is that if the user cancels their edit we can easily reset back to the canonical state. Imagine we have clicked the edit icon for a user, and have edited the name and email address of the user. Now imagine we don’t want to keep these changes, so we click the cancel button. This should cause the changes we made in the view to revert back to their previous state. However, since we overwrote our canonical state with the editing state, we no longer have the old state of the data. We would be forced to re-fetch the data from our REST API to get the canonical state again. Instead, let’s store the editing state in another place in state. Now our state might look like this:

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

Since we now have a copy of both the editing state of the object and the canonical state of the object, resetting back to after clicking cancel is easy. We simply show the canonical state in the view instead of the editing state, and no further calls to the REST API are necessary. As a bonus, we’re still tracking the edit state in our store. If we decide that we did want to keep our edits, we can just click the edit button again and now the edit state is shown with our old changes. Overall, keeping edit and view state separate from the canonical state both provides a better developer experience in terms of code organization and maintainability, as well as a better user experience for interacting with our form.

### 3. Share state between views judiciously

Many applications may start off with a single store and a single user interface. As we grow our application to scale out our features, we will need to manage state between multiple different views and stores. In order to scale out our Redux application, it may help to create one top level reducer per page. Each page and top level reducer corresponds to one view in our application. For example, the users screen will fetch users from our API and store them in the `users` reducer, and another page which tracks the domains for the current user will fetch and store data from our domain API. The state might look something like this now:

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

Organizing our pages like this will help keep the data behind our views decoupled and self-contained. Each page keeps track of its own state, and our reducer files can even be co-located with our view files. As we continue to expand our application, we may discover the need to share some state between two views which both depend on that data. Consider the following when thinking about sharing state:

- How many views or other reducers will depend on this data?
- Does each page need its own copy of the data?
- How frequently does the data change?

For example, our application needs to display some information about the currently logged-in user on every page. We need to fetch their user information from the API, and store it in our reducer. We know that every page is going to depend on this data, so it doesn’t seem to fit with our one reducer per page strategy. We know that each page doesn’t necessarily need a unique copy of the data, since most pages will not be fetching other users or modifying the current user. Also, the data about the currently logged-in user is unlikely to change unless they are editing themselves on the users page.

Sharing the current user state between our pages seems like a good call, so we will pull it out into its own top level reducer in its own file. Now the first page the user visits will check if the current user reducer has loaded, and fetch the data from the API if not. Any view that is connected to the Redux store can view information about the current logged-in user.

What about cases that don’t make sense to share state? Let’s consider another example. Imagine that each domain belonging to a user also has a number of subdomains. We add a subdomain page to the application which shows a list of all the users subdomains. The domains page also has the option to display the subdomains for a given selected domain. Now we have two pages that both depend on the subdomain data. We also know that domains can change on a somewhat frequent basis — users may add, remove, or edit domains and subdomains at any time. Each page will also probably need its own copy of the data. The subdomain page will allow for reading or writing to the subdomain API, and will also potentially need to paginate through multiple pages of data. The domain screen by contrast will only need to fetch subsets of the subdomains at a time (the subdomains for a given selected domain). It seems clear this isn’t a good use case for sharing our subdomain state between these views. Each page should store its own copy of the subdomain data.

### 4. Reuse common reducer functions across state

After writing a few reducer functions, we may decide to try reusing our reducer logic between different places in state. For example, we may create a reducer to fetch users from our API. The API only returns 100 users at a time, and we may have thousands of users in our system or more. To address this, our reducer will also need to keep track of which page of data is currently being displayed. Our fetch logic will read from the reducer to determine the pagination parameters to send with the next API request (such as `page_number`). Later on when we need to fetch the list of domains, we will end up writing the same exact logic to fetch and store the domains, just with a different API endpoint and a different object schema. The pagination behavior remains the same. The savvy developer will realize we can probably modularize this reducer and share the logic between any reducers that need to paginate.

Sharing reducer logic can be a little tricky in Redux. By default, all the reducer functions are called when a new action is dispatched. If we share a reducer function in multiple other reducer functions, then when we dispatch our action it will cause *all* of those reducers to fire. This isn’t the behavior we want for reusing our reducers, though. When we fetch the users and get a total count of 500, we don’t want the domain’s `count` to change to 500 as well.

We recommend two different ways to accomplish this, both using special scopes or prefixes for types. The first way involves passing a scope inside your payload in an action. The action uses the type to infer the key in state to update. For illustrative purposes, let’s imagine that we have a web page containing several different sections, all of which load asynchronously from different API endpoints. Our state to track loading might look like this:

```
const initialLoadingState = {
  usersLoading: false,
  domainsLoading: false,
  subDomainsLoading: false,
  settingsLoading: false,
};
```

Given such a state, we will need reducers and actions to set the loading state for each section of the view. We could write out four different reducer functions with four different actions — each using their own unique action type. That’s a lot of repeated code! Instead, let’s try using a scoped reducer and action. We create just one action type `SET_LOADING`, and a reducer function like so:

```
const loadingReducer = (state = initialLoadingState, action) => {
  const { type, payload } = action;
  if (type === SET_LOADING) {
    return Object.assign({}, state, {
      // sets the loading boolean at this scope
      [`${payload.scope}Loading`]: payload.loading,
    });
  } else {
    return state;
  }
}
```

We also need to provide a scoped action creator function to call our scoped reducer. The action would look something like:

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
// example dispatch call
store.dispatch(setLoading('users', true));
```

By using a scoped reducer like this, we eliminate the need to repeat our reducer logic across multiple actions and reducer functions. This significantly decreases the amount of code repetition and helps us to write smaller action and reducer files. If we need to add another section to our view, we simply add a new key in our initial state and make another dispatch call with a different scope passed to `setLoading`. This solution works great when we have several similar collocated fields that need to be updated in the same way.

Sometimes though we need to share reducer logic between multiple different places in state. Instead of using one reducer and action to set multiple fields in one place in state, we want a reusable reducer function that we can call `combineReducers` with to plug into different places in state. This reducer will be returned by calls to a reducer factory function, which returns a new reducer function with that type prefix added.

A great example for reusing reducer logic is when it comes to pagination information. Going back to our fetching users example, our API might contain thousands of users or more. Most likely our API will provide some information for paginating through multiple pages of users. Perhaps the API response we receive looks something like this:

```
{
  "users": ...,
  "count": 2500, // the total count of users in the API
  "pageSize": 100, // the number of users returned in one page of data
  "startElement": 0, // the index of the first user in this response
  ]
}
```

If we want the next page of data, we would make a GET request with the `startElement=100` query parameter. We could just build a reducer function for each API service we interact with, but that would repeat the same logic across many places in our code. Instead, we will create a standalone pagination reducer. This reducer will be returned from a reducer factory which takes a prefix type and returns a new reducer function:

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
// example usages
const usersReducer = combineReducers({
  usersData: usersDataReducer,
  paginationData: paginationReducerFor('USERS_'),
});
const domainsReducer = combineReducers({
  domainsData: domainsDataReducer,
  paginationData: paginationReducerFor('DOMAINS_'),
});
```

The reducer factory `paginationReducerFor` takes the prefix type which will be added to all of the types that this reducer matches on. The factory returns a new reducer, with its types prefixed. Now when we dispatch an action like `USERS_SET_PAGINATION` it will only cause the pagination reducer for users to update. The domains pagination reducer will remain unchanged. This effectively allows us to reuse common reducer functions in multiple places in our store. For sake of completeness, here is an action creator factory to go along with our reducer factory, also using a prefix:

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
// example usages
const setUsersPagination = setPaginationFor('USERS_');
const setDomainsPagination = setPaginationFor('DOMAINS_');
```

### 5. React Integration and Wrap up

Some Redux applications may never need to render a view to users (like an API), but most of the time you will want some kind of view to render your data inside of. The most popular library for rendering UIs with Redux is React, and that is the one we will choose to demonstrate how to integrate Redux. We can use the strategies we learned in the above sections to make our lives easier when creating our view code. To do this integration, we will use the `react-redux`[library](https://github.com/reactjs/react-redux).

One useful pattern in UI integration is using selectors to access the data in state from our view components. A convenient place to use selectors in `react-redux` is in the `mapStateToProps` function. This function is passed into the call to the `connect` function (the function you call to connect your React component to the Redux store). This is the place where you will map the data in state to the props that your component receives. This is the perfect place to use a selector to retrieve the data from state, and pass to the component as props. An example integration might look like the following:

```
const ConnectedComponent = connect(
  (state) => {
    return {
      users: selectors.getCurrentUsers(state),
      editingUser: selectors.getEditingUser(state),
      ... // other props from state go here
    };
  }),
  mapDispatchToProps // another `connect` function
)(UsersComponent);
```

The integration between React and Redux also provides us a handy location for wrapping our actions in scopes or types. We have to hook up our component’s handlers to actually call the store’s dispatch with our action creators. To accomplish this in `react-redux` we use the `mapDispatchToProps` function, which is also passed to the call to `connect`. This `mapDispatchToProps` function is the place we normally call the Redux `bindActionCreators` function to bind each action to the dispatch method from the store. While we’re at it, we can also bind the scope to the actions like we showed in [Section 4](http://techblog.appnexus.com/#section4). For example, if we wanted to use the scoped reducer pattern with the paginator for our Users page, we would write the following:

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

Now from the perspective of our `UsersPage` component, it just receives the list of users and other pieces of state as props, as well as the bound action creators. The component doesn’t need to be aware of which scoped action it needs or how to access the state; we have handled these concerns instead at the integration level. This allows us to create very decoupled components which don’t necessarily depend on the inner workings of our state. Hopefully by following the patterns discussed here, we can all create Redux applications in a scalable, maintainable, and reasonable way.

**Further Reading:**

- [Redux](http://redux.js.org/) the state management library being discussed
- [Reselect](https://github.com/reactjs/reselect) a library for creating selectors
- [Normalizr](https://github.com/paularmstrong/normalizr) a library for normalizing JSON data against a schema, useful for storing data in indices
- [Redux-Thunk](https://github.com/gaearon/redux-thunk) a middleware library for async actions in Redux
- [Redux-Saga](https://github.com/redux-saga/redux-saga) another middleware for async actions using ES2016 generators


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
