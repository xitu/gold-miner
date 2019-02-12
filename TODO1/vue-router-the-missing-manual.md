> * 原文地址：[Vue Router — The Missing Manual](https://blog.webf.zone/vue-router-the-missing-manual-ce51c21430b0)
> * 原文作者：[Harshal Patil](https://blog.webf.zone/@mistyHarsh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vue-router-the-missing-manual.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vue-router-the-missing-manual.md)
> * 译者：[Sam](https://github.com/xutaogit)
> * 校对者：[Ranjay](https://github.com/jerryOnlyZRJ), [shixi-li](https://github.com/shixi-li)

# Vue Router 实战手册

![](https://cdn-images-1.medium.com/max/2600/1*0rItCaXRjYFvhdhtLahUXw.png)

除了 DOM 操作，事件处理，表单和组件之外，每个单页应用程序（SPA）框架如果要用于大型应用程序都需要两个核心部分：

1.  客户端路由
2.  显示状态管理（通常是单向的）

幸运的是，Vue 为路由和状态管理提供了**官方解决方案**。这篇文章里，我们将要探寻 [vue-router](https://router.vuejs.org/)，以了解路由在诸多场景中的行为表现，并探索一些编写优雅代码的模式。这里假设你已经对 vue，vue-router 和 SPA 有了一个很好的理解。

我们将使用下面开启了 HTML5 路由模式的示例应用程序。

#### 路由:

1. 项目中所有用户的列表 `/projects/:projectId/users`
2. 单个用户的详细信息视图 `/projects/:projectId/users/:userId`
3. 单个用户的简要信息视图 `/projects/:projectId/users/:userId/profile`
4. 创建一个新用户 `/projects/:projectId/users/new`

#### 组件树结构：

![](https://cdn-images-1.medium.com/max/1600/1*tTCwKlFNQiHQaN3QVqKM7Q.png)

从应用程序路由派生出的组件层次结构

* * *

### 1. 当前的路由对象是共享且不可变的

Vue-router 在每一个组件里注入**当前路由对象**。每个组件里可以通过 `this.$route` 访问到。但关于这个对象有两点需要注意的事项。

> 路由对象是**不可改变的**。

如果你使用 `$router.push()`，`$router.replace()` 或者链接导航到任何路由上，则会创建 `$route` 对象的新副本。已有的（路由）对象是不会被修改的。由于它（路由对象）是不可变的，所以你**不需要设置 deep 属性监听**这个 `$route` 对象：

```
Vue.component('app-component', {
    watch: {
        $route: {
             handler() {},
             deep: true // <-- 并不需要
        }
    }
});
```

> 路由对象是**共享的**。

不可变性带来了进一步的优势。路由在所有组件内部共享同一个 `$route` 对象实例。所以下面这些内容都将生效：

```
// 父组件
Vue.component('app-component', {
    mounted() { window.obj1 = this.$route; }
});
// 子组件
Vue.component('user-list', {
    mounted() { window.obj2 = this.$route; }
});
// 一旦 App 实例化
window.obj1 === window.obj2; // <-- 返回 true
```

### 2. Vue-router 不是状态路由

> 理论上来说，**路由**是分解大型网络应用程序的**第一级抽象**。状态管理更晚一些。

有两种关于分解网络应用程序的思考方式。一种是把应用程序分解成一系列的页面（例如，每个页面都根据 URL 边界进行拆分），另一种是把应用程序理解成已经定义好的一组状态（可选择让每个状态都有一个 URL）。

> state-router 会把应用程序拆解成**一组状态**。url-router 会把应用程序拆解成**一组页面**。

Vue-router 是 **url-router**。Vue 没有官方 state-router。有 Angular 背景的人员马上会意识到它们的区别。状态路由器相较于 URL 路由器方式的区别：

*   状态路由器像状态机一样工作。
*   状态路由器中 URL 是非必要的。
*   状态是可以嵌套的。
*   一个应用程序被拆分成一组定义好的状态集合而不是页面。从一个状态转变为另一个状态时可选择性的改变 URL。
*   当从一个状态转变成另一个状态时可以传递任何复杂的数据。使用 URL 路由器，在页面间传递数据一般是将它作为 URL 地址的一部分或查询参数。
*   使用状态路由器，当整体页面发生刷新的时候已传递的数据会丢失（除非你使用了 session 或者 local storage）。使用URL路由器，可以重建状态，因为大部分传递的数据都存在于 URL 中。

### 3. 路由之间传递的隐式数据

即便不是状态路由器，在转变过程中，你仍然可以把复杂数据从一个路径传递到另一个上，而不用将数据作为 URL 的一部分。

> 当使用 vue-router 从一个路由导航到另一个路由时，你可以传递隐式数据/状态。

这在哪里有用？**主要是优化的时候。**考虑下面的例子：

1.  我们有两个页面：
    详情页 —— `/users/:userId`
    简介页 —— `/users/:userId/profile`
2.  在详情页面里，我们调起一个 API 请求获取用户信息。并且，页面上有一个链接帮助用户跳转到简介页面。
3.  第二个页面上，我们需要发起两个 API 请求 —— 获取用户信息和用户概要。
4.  这里的问题是 —— 当我从详情页面导航到简介页面时做了两次一样的 API 请求。最佳的解决方案是当我们用户从详情视图页转变成简介视图页时，把已检索的用户数据传递给下一个路由。另外，这些已检索的数据不需要作为 URL 的一部分（就像状态路由器一样，传递一个隐式的状态）。
5.  如果用户通过任何其他方式直接跳转到简介页面，比如整个页面刷新或者从其他视图，那么在 `created` 钩子函数里，我们可以选择检查数据可用性。

```
// 用户详情组件内部
Vue.component('user-details', {
    methods: {
        onLinkClick() {
            this.$router.push({ 
                name: 'profile',
                params: { 
                    userId: 123,
                    userData  // 隐式数据/状态
                }
            });
        }
    }
});

// 用户简介组件内部
Vue.component('user-profile', {
    created() {
        // 访问附带过来的数据
        if (this.$route.params.userData) {
            this.userData = this.$route.params.userData;
        } else {
            // 不然就发起 API 请求获取用户数据
            this.getUserDetails(this.$route.params.userId)
                .then(/* handle response */);
        }
    }
});
```

**注意：能够这样处理是因为 _`$route`_ 对象注入在每个组件中且是共享不可变的。不然很难实现。**

### 4. 导航保护阻塞父组件

如果你有嵌套配置，那么任何子组件上的保护都有可能阻塞父组件的渲染。例如：

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

如果你直接导航到 `/projects/100/users/list`，那么由于 `beforeEnter` 的异步保护，导航会被当作**等待中（pending）**，并且 `ParentComp` 组件不会被渲染。所以，如果你希望看到`进程加载器（progress-loader）`直到保护解除，这应该是不会发生。对于你可能从父组件发起的任何 API 请求也是如此。

在这种情况下，如果你希望显示**父级组件**而不顾子级路由的保护策略，解决方案是改变你组件的层级结构并且通过某种方式更新 `进程加载器（progress-loader）`的逻辑。如果你做不到，那么你可以像这样**使用双重传递 —— 先导航到父组件然后再到子组件：**

```
goToUserList () {
    this.$router.push('/projects/100',
        () => this.$router.replace('users'))
}
```

> 这个行为是有道理的。如果父级视图不等待子级的保护，那么它可能先渲染一会父级视图，然后如果保护失败则导航到其他地方。

> **注意**：相比之下，Angular 的路由是完全相反地。父级组件一般不会等待任何子级保护的触发。那么哪种方案是正确的？都不是。乍看上去，Angular 采取的方法感觉自然而有序，但如果开发者不仔细的话它很容易搞砸用户体验（UX）。
>
> 使用 vue-router，渲染层级似乎有点尴尬。但却少有机会破坏用户体验（UX）。Vue 隐含地预先强制执行这项决定。同时，不要忘记 vue-router 提供的作用域。你可以使用全局级别，路由级别或者组件内级别的保护。你会拥有真正细粒度的控制。

在理解了关于 vue-router 的一些概念之后，是时候讨论关于编写优雅代码的模式了。

### 5. Vue-router 不是基于前缀（trie-based）的路由器

Vue-router 是构建在 [path-to-regexp](https://github.com/pillarjs/path-to-regexp) 之上的。Express.js 路由也是使用相同的库。URL 匹配是基于正则表达式的。这意味着你可以像这样定义你的路由：

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
        // 这个不会造成问题吗？
        path: `${prefix}/new`,
        name: 'user-new',
        component: NewUser
    }
];
```

这里不那么明显的问题是路径 `${prefix}/new` 永远不会被匹配，因为它定义在路由列表的最后。这是基于**正则表达式**路由的缺点。不止一个路由会被匹配上（译者注：路径 `${prefix}/:userId` 会覆盖匹配路径 `${prefix}/new`）。当然，这对于小型网络应用程序不是问题。或者，你可以像这样定义**一棵路由树**：

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

基于树结构配置有一些优点：

1.  结构清晰。易于维护。 
2.  授权/保护的管理变得容易。基于 CRUD (增删改查) 的权限执行变得非常简单。		
3.  比起扁平的路由列表有更可预见的路由。

使用基于树结构的配置的细微差别是创建中间组件，它们可能只包含一个 `router-view` 组件。Vue-router 没有将 `RouterView` 组件直接暴露给最终开发者。但是一个包装 `router-view` 的小技巧可以极大地帮助减少中间组件：

```
const RouterViewWrapper = Vue.extend({ 
    template: `<router-view></router-view>`
});

// 现在，可以在路由配置树的任何位置
// 使用 RouterViewWrapper 组件。
```

> 注意：**Trie**是一种搜索树数据结构的类型（译者注：[前缀树](https://zh.wikipedia.org/wiki/Trie)）。基于前缀的路由是可预见的，并且不管路由的定义顺序。在 Nodejs 生态环境里，存在很多基于前缀或者类似的路由。Hapi.js 和 Fastify.js 使用的是基于前缀的路由。

简而言之：

> 树结构配置优于扁平结构配置。

### 6. 路由器的依赖注入

当你使用导航保护的时候，你可能在这些保护函数里需要一些依赖。大多数常见的例子是 Vuex/Redux 的 store。这个解决方案过于简单。比起路由器本身，还有更多关于代码组织的工作要做。假定你有以下这些文件：

```
src/
  |-- main.js
  |-- router.js
  |-- store.js
```

你可以创建一个在定义导航守护时的存储（store）注入函数：

```
// 在你的 store.js 里，定义存储注入器
export const store = new Vuex.Store({ /* config */ });

export function storeInjector(fn) {
    return (...args) => fn(...args, store);
}

// 在你的 router.js 里，使用存储注入器
const routeConfig = {
    // 其他内容
    beforeEnter: storeInjector((to, from, next, store) => {})
}
```

或者，你也可以将路由创建器封装到可以传递任何依赖的函数中：

```
// main.js 文件
import { makeStore } from './store.js';

const store = makeStore();
const router = makeRouter(store);

const app = new Vue({ store, router, template: `<div></div>` });

// router.js 文件
export function makeRouter(store) {

    // 使用 store 处理任何事情
    return new VueRouter({
        routes: []
    })
}
```

### 7. 单次监听路由对象

设想你在一个异步组件里使用路由配置。异步组件是通过懒加载方式引入的。这通常是使用像 Webpack 或 Rollup 这样的工具进行包（bundle）拆分实现的。配置看起来将会是这样的：

```
const routes = [{
    path: '/projects/:projectId/users',
    name: 'user-list',

    // 异步组件（Webpack 的代码拆分）
    component: import('../UserList.js'),
}];
```

在根实例或者父级 `AppComponent` 组件里，你可能希望检索 `projectId` 用来做一些引导性的 API 调用。典型的代码是：

```
Vue.component('app-comp', {

    created() {
        // 问题：projectId 未定义         
        console.log(this.$route.params.projectId);
    }
}
```

这里的问题是 `projectId` 将是未定义的，因为子组件没有准备好，路由器还没有完成转换。

> 当你在路由配置里使用异步组件时，在未创建子组件之前，父组件中将不提供路径或查询参数。

这里的解决方案是在父组件里监听 `$route`。另外，**你必须只监听它一次，因为它只是一个引导性 API 请求**并且不应该再被触发：

```
Vue.component('app-comp', {

    created() {
        const unwatch = this.$watch('$route', () => {
            const projectId = this.$route.params.projectId;
            
            // 做剩余的工作 
            this.getProjectInfo(projectId);

            // 立即解开监听
            unwatch();
        });
    }
}
```

### 8. 使用扁平路由混合监听嵌套组件

```
const routes = [{
    path: '/projects/:projectId',
    name: 'project',
    component: ProjectView,

    beforeEnter(to, from, next) {
        next();
    },

    children: [{
        // 仔细观察
        // 嵌套路由以 `/` 开头 
        path: '/users',
        name: 'list',
        component: UserList,
    }]
}];
```

在上面的配置中，子级路由以 `/` 开头因此被当作根路径。所以你可以使用 `https://example.com/users` 而不是 `https://example.com/projects/100/users` 就可以访问 `UserList` 组件。然而，`UserList` 组件将被渲染成 `ProjectView` 组件的子组件。这种路径被称为**根相对嵌套路径**。

当然，组件层级，导航保护依然在处理中。你仍然需要嵌套的 `<router-view>` 组件。唯一改变的事情是 URL 的结构。其他的都还保持原样。这意味着 `beforeEnter` 保护将在 `UserList` 组件之前执行。

**这个技巧是纯粹的便利，因此需要谨慎的使用它**。从长远来看，它往往会产生令人困惑的代码。然而 —— 

> 根相对嵌套路径在构建 [App Shell Model](https://developers.google.com/web/fundamentals/architecture/app-shell) 的 PWA 时非常有用。

* * *

Vue 提供的官方路由解决方案是非常灵活的。除去简单的路由，它提供了许多功能，如 `meta` 字段，`transition`，高级 `scroll-behavior`，`lazy-loading` 等。

此外，当我们使用导航保护，预路由数据获取时，vue-router 设计了关于用户体验（UX）的考量。你可以使用全局或者组件内保护，但需谨慎地使用它们，因此你应该牢记关注点分离并把路由职责从组件中移除。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
