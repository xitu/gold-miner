> * 原文地址：[Vue Router — The Missing Manual](https://blog.webf.zone/vue-router-the-missing-manual-ce51c21430b0)
> * 原文作者：[Harshal Patil](https://blog.webf.zone/@mistyHarsh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vue-router-the-missing-manual.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vue-router-the-missing-manual.md)
> * 译者：
> * 校对者：

# Vue Router — The Missing Manual

![](https://cdn-images-1.medium.com/max/2600/1*0rItCaXRjYFvhdhtLahUXw.png)

Beyond DOM manipulations, events handling, forms and components, every Single Page Application (SPA) framework need two core pieces if it is intended to be used for large-scale applications:

1.  Client-side Routing
2.  Explicit State Management (often unidirectional)

Fortunately, Vue provides **official solutions** for routing as well as state management. In this article, we are going to take a look at [vue-router,](https://router.vuejs.org/) understand router behavior in various scenarios and explore some patterns to write elegant code. It assumes that you already have a decent understanding of vue, vue-router, and SPA in general.

We will use the following example application with HTML5 routing mode enabled.

#### Routes:

1.  List of all the users in a project `/projects/:projectId/users`
2.  Details view of a single user `/projects/:projectId/users/:userId`
3.  Profile view of a single user `/projects/:projectId/users/:userId/profile`
4.  Create a new user `/projects/:projectId/users/new`

#### Component tree:

![](https://cdn-images-1.medium.com/max/1600/1*tTCwKlFNQiHQaN3QVqKM7Q.png)

Component hierarchy derived from the application routes

* * *

### 1. Current route object is shared and immutable

Vue-router injects **current route object** into every component. It is accessible with `this.$route` inside each component. There are two things to note about this object.

> Route object is **immutable**.

If you navigate to any route using `$router.push()`, `$router.replace()` or a link, then fresh copy of `$route` object is created. Existing object is not modified. Since it is immutable, you **don’t need to** **deep watch** this `$route` object:

```
Vue.component('app-component', {
    watch: {
        $route: {
             handler() {},
             deep: true // <-- Not really required
        }
    }
});
```

> Route object is **shared**.

Immutability brings further advantages. Router internally shares the same instance of `$route` object with all the components. Thus following will work:

```
// Parent component
Vue.component('app-component', {
    mounted() { window.obj1 = this.$route; }
});
// Child component
Vue.component('user-list', {
    mounted() { window.obj2 = this.$route; }
});
// Once the app is instantiated
window.obj1 === window.obj2; // <-- This is true
```

### 2. Vue-router is not a state-router

> In theory, **routing is the first level of abstraction** to decompose large web application. State management comes later.

There are two ways to think about decomposing your web application. Either you split your application into series of pages (i.e. each page is split at a URL boundary) or think about your application as a set of well-defined states (Optionally every state has a URL).

> With state-router, decompose an application into the **set of states**. With url-router, split an application into the **set of pages**.

Vue-router is a **url-router**. Vue doesn’t have official state-router. People with the Angular background will instantly recognize the difference. State router is different than URL router in ways:

*   State router works like a state machine
*   URL is optional for state router
*   States can be nested
*   An application is split in a well-defined set of states. instead of pages. A transition from one-state to another can optionally change the URL.
*   Any complex data can be passed when transitioning from one state to another. With URL router, data to be passed between pages usually becomes part of URL path or query params.
*   With state router, passed data is lost when a full page refresh happens (unless you use session or local storage). With URL router, it is possible to reconstruct state since most of the passed data is present in the URL.

### 3. Implicit data passing between routes

Even if not a state-router, you can still pass complex data from one-route to another during transition without making the data part of URL.

> You can pass hidden data/state when navigating from one route to another with vue-router.

Where is this useful? **Mostly optimization**. Consider the following case:

1.  We have two pages:
    Details — `/users/:userId`
    Profile — `/users/:userId/profile`
2.  On the details page, we make one API call to get user information. Also, a link on this page helps a user navigate to the profile page.
3.  On a second page, we need to make two API calls —get user information and get user feed.
4.  The problem here is — I have to make same API call twice when I navigate from details to profile page. An optimal solution is when our user is transitioning from Details view to Profile view, pass already retrieved user data to next route. Additionally, this retrieved data need not be made part of the URL (just like a state router, pass a hidden state)
5.  If a user directly jumps to profile page by any other means, say, complete page refresh or any other view, then in `created` hook, I can optionally check for data availability.

```
// Inside user-details component
Vue.component('user-details', {
    methods: {
        onLinkClick() {
            this.$router.push({ 
                name: 'profile',
                params: { 
                    userId: 123,
                    userData  // Hidden data/state
                }
            });
        }
    }
});

// Inside user-profile component
Vue.component('user-profile', {
    created() {
        // Accessing piggy-bagged data
        if (this.$route.params.userData) {
            this.userData = this.$route.params.userData;
        } else {
            // Otherwise, make API call to get userData
            this.getUserDetails(this.$route.params.userId)
                .then(/* handle response */);
        }
    }
});
```

_Note: This is possible because_ `$route` _object injected into each component is shared and immutable. Otherwise, it is difficult._

### 4. Navigation guards block Parent component

If you have a nested configuration, then guard on any children may block Parent component from rendering. For example:

```
const ParentComp = Vue.extend({ 
    template: `<div>
        <progress-loader></progress-loader>
        <router-view>
    </div>` 
});

{
    path: '/projects/:projectId',
    name: 'project',
    component: ParentComp,

    children: [{
        path: 'users',
        name: 'list',
        component: UserList,
        beforeEnter (to, from, next) {
            setTimeout(() => next(), 2000);
        }
    }]
}
```

If you directly navigate to `/projects/100/users/list`, then due to async guard `beforeEnter`, navigation will be considered **pending** and `ParentComp` will not be rendered. So, if you anticipate seeing `progress-loader` till the guard is resolved, that won’t happen. Same goes for any API calls that you may have triggered from Parent Component.

In this scenario, if you wish to show the **Parent** irrespective of child route guard resolution, the solution is to change your component hierarchy and update `progress-loader` logic by some means. If you cannot do that, then you can **use double transition — first navigate to parent and then children** like:

```
goToUserList () {
    this.$router.push('/projects/100',
        () => this.$router.replace('users'))
}
```

> This behavior makes sense. If parent view doesn’t wait for child guard, then it may render parent view for a moment and then navigate somewhere else if the guard fails.

> **Note:** In contrast, Angular routing is exactly the opposite. Parent component typically doesn’t wait for any child guard to activate. So which is the right approach? It is neither. At first glance, the approach taken by Angular feels more natural and ordered, but it can easily screw up UX if a developer is not careful.
>
> With vue-router, routing hierarchy seems a little awkward. But there is less chance for UX damage. Vue implicitly enforces this decision upfront. Also, do not forget the scope provided by vue-router. You can have a global, route-level or in-component guard. You can have a really fine-grained control.

Having understood a few concepts around vue-router, it is time to talk about patterns to write elegant code.

### 5. Vue-router is not a trie-based router

Vue-router is built on top of [path-to-regexp](https://github.com/pillarjs/path-to-regexp). Express.js routing also uses the same library. URL matching is based on regular expressions. It means you can define your routes as:

```
const prefix = `/projects/:projectId/users`;

const routes = [
    {
        path: `${prefix}/list`,
        name: 'user-list',
        component: UserList,
    },

    {
        path: `${prefix}/:userId`,
        name: 'user-details',
        component: UserDetails
    },

    {
        // IS THIS NOT PROBLEMATIC?
        path: `${prefix}/new`,
        name: 'user-new',
        component: NewUser
    }
];
```

The not-so-obvious problem here that path `${prefix}/new` will never be matched as it is defined later in a route list. That is the downside of **RegExp** based routing. More than one routes can match. Of course, it is not a problem for small web applications. Alternately, you can define **routes as a tree**:

```
const routes = [{
    path: '/projects/:projectId/users',
    name: 'project',
    component: ProjectUserView,

    children: [
        {
            path: '',
            name: 'list',
            component: UserList,
        },
        {
            path: 'new',
            name: 'user-details',
            component: NewUser,
        },
        {
            path: ':userId',
            name: 'user-new',
            component: UserDetails,
        }
    ]
}];
```

There are a few advantages of tree-based configuration:

1.  It is obvious. Easy to maintain.
2.  Authorization/Guards are easy to manage. CRUD based rights become very trivial to implement.
3.  More predictable routing than flat route list.

The small nuance with tree-based configuration is the creation of intermediate components which probably contain nothing but a `router-view` component. Vue-router doesn’t expose `RouterView` component directly to end-developers. But a small trick of wrapping `router-view` can greatly help reduce intermediate components:

```
const RouterViewWrapper = Vue.extend({ 
    template: `<router-view></router-view>`
});

// Now, use RouterViewWrapper component wherever you 
// need in route config tree.
```

> Note: **Trie** is a type of search-tree data structure. Trie-based routing is predictable, and irrespective of the routes definition order. In Node ecosystem, many trie-based or similar routers exist. Hapi.js and Fastify.js employ trie-based routing.

In a nutshell:

> Prefer tree configuration over a flat configuration.

### 6. Injecting dependencies into router

When you have navigation guards, you might need some dependencies into these guard functions. Most common example is Vuex/Redux store. The solution is very trivial. It has more to do with code organization than the router itself. Assuming you have, following files:

```
src/
  |-- main.js
  |-- router.js
  |-- store.js
```

You can create a store injector function that can be used when defining navigation guards:

```
// In your store.js, define storeInjector
export const store = new Vuex.Store({ /* config */ });

export function storeInjector(fn) {
    return (...args) => fn(...args, store);
}

// In your router.js, use storeInjector
const routeConfig = {
    // Other fields
    beforeEnter: storeInjector((to, from, next, store) => {})
}
```

Or, you can also wrap your route creation into a function to which any dependencies can be passed:

```
// main.js file
import { makeStore } from './store.js';

const store = makeStore();
const router = makeRouter(store);

const app = new Vue({ store, router, template: `<div></div>` });

// router.js file
export function makeRouter(store) {

    // Do anything with store
    return new VueRouter({
        routes: []
    })
}
```

### 7. Watching route object once

Imagine you have a route configuration with an asynchronous component. Async components are required for lazy loading. It is often achieved with bundle splitting using tools like Webpack or Rollup. The configuration will look like:

```
const routes = [{
    path: '/projects/:projectId/users',
    name: 'user-list',

    // Async component (Webpack code splitting)
    component: import('../UserList.js'),
}];
```

In the root instance or the parent `AppComponent`, you might want to retrieve `projectId` to make some bootstrapping API calls. The typical code for this is:

```
Vue.component('app-comp', {

    created() {
        // PROBLEM: projectId is undefined         
        console.log(this.$route.params.projectId);
    }
}
```

The problem here is that `projectId` will be undefined as the child component is not ready and router has not finished the transition.

> When you have Async component in route config, path or query parameters will not be available within parent component till the child component is not created.

The solution here is to watch `$route` in your parent. Additionally, **you must watch it only once as it is only bootstrapping API call** which should not be fired again:

```
Vue.component('app-comp', {

    created() {
        const unwatch = this.$watch('$route', () => {
            const projectId = this.$route.params.projectId;
            
            // Do remaining work
            this.getProjectInfo(projectId);

            // Unwatch immediately
            unwatch();
        });
    }
}
```

### 8. Mix-match nested components with flat routes

```
const routes = [{
    path: '/projects/:projectId',
    name: 'project',
    component: ProjectView,

    beforeEnter(to, from, next) {
        next();
    },

    children: [{
        // OBSERVE CAREFULLY
        // Nested routes begin with `/`
        path: '/users',
        name: 'list',
        component: UserList,
    }]
}];
```

In the above configuration, child route begins with `/` and thus treated as a root path. So, instead of `https://example.com/projects/100/users` you can use `https://example.com/users` to access `UserList` component. However, the `UserList` component will be rendered as a child of `ProjectView` component. Such paths are known as **root-relative nested paths**.

Of course, component hierarchy, navigation guards are still processed. You still need nested `<router-view>` components. The only thing that changes is the URL structure. Everything else stays the same. It means `beforeEnter` guard will be executed before the `UserList` component.

**This is pure convenience and thus use it judiciously**. It has a tendency to create confusing code in a long run. However —

> Root-relative nested paths are very useful in building PWA where [App Shell Model](https://developers.google.com/web/fundamentals/architecture/app-shell) is very prominent.

* * *

Official routing solution provided by Vue is very flexible. Beyond simple routing, it provides many features like `meta` fields, `transitions`, advanced `scroll-behavior`, `lazy-loading`, etc.

Also, vue-router designed with UX considerations in mind when we think about features like navigation guards, pre-route data fetching. You can use a global or in-component guards but use them judiciously as you should keep separation of concern in mind and move routing responsibilities out of components.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
