> * 原文地址：[Why VueX Is The Perfect Interface Between Frontend and API](https://zendev.com/2018/05/21/vuex-perfect-interface-frontend-backend.html)
> * 原文作者：[KBall](https://zendev.com/category/vue.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vuex-perfect-interface-frontend-backend.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vuex-perfect-interface-frontend-backend.md)
> * 译者：
> * 校对者：

# Why VueX Is The Perfect Interface Between Frontend and API

The [increase in complexity](https://blog.logrocket.com/the-increasing-nature-of-frontend-complexity-b73c784c09ae) in front end web development has driven to increasing amounts of specialization and separation of front and back end.

This specialization and increased complexity has a number of benefits - the quality of user experiences on the web has increased exponentially, while simultaneously reaching more people across more types of devices than ever in history.

However, it also introduces a number of challenges.

### The Challenge: Interfacing between Frontend and API

The interface between frontend and API has become a common point of friction, challenge, and complexity.

In an ideal world, backend and frontend would evolve together in harmony, with close communication, and the data served up by the backend would match exactly what the front-end needs.

In reality, often the two parts of an application are developed by completely different teams, or even different companies. It's not at all uncommon to have a specialized team at an agency building out a design and front-end, while your own development team is working on the backend

### Typical Solutions

The result is a flow that typically looks like the following:

1.  Build a UI using fake 'stubbed' data, either directly inline in the templates and code, or loaded via a set of fixtures.
2.  When the API is ready, scramble to replace every integration point with real API calls and data.

The problems with this approach are twofold:

1.  Data integration is often scattered throughout the application, requiring tracing down and reworking tons of code.
2.  Even if data is relatively isolated, there is often a mismatch between what the frontend expects and what the API eventually delivers.

### A Better Solution Exists: VueX

If you're developing your front-end using Vue.js, a better solution to this problem is right at your fingertips.

The [VueX](https://vuex.vuejs.org/en/) library, deeply integrated into Vue, provides the perfect solution to creating a _clean_, _isolated_ interface to your data that makes transitioning between stubbed data and a real API a breeze.

## What is VueX

VueX is a state-management library inspired by Flux, Redux, and the Elm architecture but specifically designed and tuned to integrate well with Vue.js and take advantage of Vue's Reactivity.

All of these libraries aim to solve a simple problem: When there is state that is shared across many components, particularly components that are siblings or in greatly different views, managing distribution and updating of that state is challenging.

Libraries like VueX make it possible to manage shared state across components in a way that is structured and maintainable, by creating a global state tree that can be be accessed and updated by every component in a structured way.

## How Does VueX Work

VueX divides state management into 3 key pieces: **state**, **mutations**, and **actions**. When you instantiate a VueX store, you define these three objects:

```
const store = new Vuex.Store({
    state: {
    ...
    },
    mutations: {
    ...
    },
    actions: {
    ...
    }
})
```

### State

State represents the actual data itself. This is simply a JavaScript object that contains a tree of data. In VueX you can have a single, global state tree or organize by module (e.g. a users state tree, a products state tree, etc)

For example, we might use this state tree to keep track of our current user, starting with null if the user is not logged in:

```
state: {
    currentUser: null
}
```  

### Mutations

Mutations are the mechanism by which we change our state tree. All changes of state _must_ flow through mutations, which allows VueX to manage the state in a predictable manner.

An example mutation might look like:

```
mutations: {
    setCurrentUser(currentState, user) {
    currentState.currentUser = user;
    }
}
```

Mutations are _synchronous_, and _directly_ modify the state object (as compared to e.g. Redux where the equivalent concept is called a reducer and returns a _new_ object.)

This synchronous, direct change of the state object meshes perfectly with Vue's concept of reactivity. VueX state objects are reactive, so the changes ripple outwards to all dependencies.

You call a mutation via the `commit` function:

```
store.commit('setCurrentUser', user);
```

### Actions

Actions are the final piece of VueX, an intermediary between _intent_ and _modification_.

Actions are _asynchronous_, and _indirectly_ modify the store, via `committing` mutations. However, because they are asynchronous, they can do much more than that.

Asynchronicity allows actions to handle things like API calls, user interaction, and entire flows of action.

As a simple example an action might make an API call and record the result:

```
actions: {
    login(context, credentials) {
    return myLoginApi.post(credentials).then((user) => {
        context.commit('setCurrentUser', user)
    })
    }
}
```

Actions can return promises, allowing views or other code that dispatch actions to wait for them to finish and react based on their results. Instead of using `commit`, you `dispatch` an action. For example, our calling code might look like:

```
store.dispatch('login', credentials).then(() => {
    // redirect to logged in area
}).catch((error) => {
    // Display error messages about bad password
});
```

## Why VueX Actions Are The Perfect Interface to the API

If you're working on a project where the backend and frontend are both evolving at the same time, or you're on a UI/Frontend team that may even be building out a user interface before the backend exists, you're probably familiar with the problem where you need to stub out parts of the backend or data as you develop the front.

A common way this manifests is as purely static templates or content, with placeholder values and text right in your front-end templates.

A step up from this is some form of fixtures, data that is loaded statically by the front-end and put into place.

Both of these often run into the same set of challenges: When the backend is finally available, there is a bunch of refactoring work to get the data in place.

Even if (miraculously), the structure of data from the backend matches your fixtures, you still have to scramble all over to find every integration point. And if the structure is different (and let's face it, it usually is), you not only have to do that but you have to figure out how you can either change the front-end or create an abstraction layer that transforms the data.

### Enter VueX Actions

The beauty of VueX is that actions provide a _perfect_ way to isolate and abstract between the frontend and the backend, and furthermore do so in a way such that updating from stubbed data to a real backend is seamless and simple.

Let me expand a little bit. Lets take our login example. If our login API doesn't exist yet, but we're still ready to build out the front-end, we could implement our action like so:

```
actions: {
    login(context, credentials) {
    const user = MY_STUBBED_USER;
    if(credentials.login === '[email protected]') {
        context.commit('setCurrentUser', user)
        return Promise.resolve();
    } else {
        return Promise.reject(new Error('invalid login'));
    }
    }
}
```

Now our front-end can implement a login that behaves _exactly_ the way it will in the future, with test data, allowing for both success and failure. The behavior will happen _immediately_ rather than asynchronously via an API, but by returning promises now any callers can treat it the same way they would a real API call.

When our API is available, we can simply modify this action to use it, and everything else in our codebase remains the same.

### Handling Data Mismatches

Isolating our API calls to VueX also gives us a beautiful and clean way to handle mismatches in data format between the backend and the frontend.

Continuing our login example, perhaps we assumed that the API would return all the user information we needed upon login, but instead we need to fetch preferences from a separate endpoint once we're authenticated, and even then the format is different than we expected

We can keep this discrepancy completely isolated within our VueX action, preventing us from needing to change anywhere else in our frontend. Because promises can be chained and nested, we can go through a series of API calls that all need to complete before our action is considered complete.

```
actions: {
    login(context, credentials) {
    return myLoginApi.post(credentials).then((userData) => {
        const user = { ...userData };
        return myPreferencesApi.get(userData.id).then((preferencesData) => {
        user.preferences = transformPreferencesData(preferencesData);
        context.commit('setCurrentUser', user)
        });
    })
    }
}
```

The end result from the perspective of both our state modifications and the code that is dispatching our `login` action is _exactly the same_.

With VueX, the challenge of integrating a new or changing backend API into our front-end has been dramatically simplified.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
