> * 原文地址：[Why VueX Is The Perfect Interface Between Frontend and API](https://zendev.com/2018/05/21/vuex-perfect-interface-frontend-backend.html)
> * 原文作者：[KBall](https://zendev.com/category/vue.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/vuex-perfect-interface-frontend-backend.md](https://github.com/xitu/gold-miner/blob/master/TODO1/vuex-perfect-interface-frontend-backend.md)
> * 译者：[zhmhhu](https://github.com/zhmhhu)
> * 校对者：

# 为什么 VueX 是前端与 API 之间的完美接口

前端 Web 开发[复杂性的增加](https://blog.logrocket.com/the-increasing-nature-of-frontend-complexity-b73c784c09ae)促进了前后端专业化和前后端分离。

这种专业化和复杂性的增加有许多好处 —— 网络用户体验的质量呈指数级增长，同时，更多的人将通过多种设备连接彼此，这是史无前例的。

但是，它也带来了一些挑战。

### 挑战：前端和 API 之间的集成

前端和 API 之间接口的摩擦、挑战和复杂性是一个常见的问题。

理想状态下，后端和前端将通过紧密的通信和谐共处，后端提供的数据将完全匹配前端所需的数据。

实际上，应用程序的这两个部分通常由完全不同的团队甚至不同的公司开发。 在设计部门和前端部门之外建立一个专门的团队并不罕见，而你自己的团队正在进行后端开发。

### 典型解决方案

结果是一个通常看起来如下所示的流程：

1. 使用伪造的 'stubbed' （“存根”）数据构建 UI，也可以直接嵌入模板和代码中，或者通过一个工具包加载。
2. 当 API 准备就绪时，迅速使用真实的 API 调用和数据替换每一处集成点。

这种方法存在的问题是双重的：

1. 数据集成通常分散在整个应用程序中，需要跟踪并重新编写大量代码。
2. 即使数据是相对独立的，前端期望与API最终提供的内容之间往往存在不匹配。 前端期望的数据与 API 最终返回的数据往往存在不匹配。

### 更好的解决方案：VueX

如果您使用 Vue.js 开发您的前端，那么一个更好的解决此问题的方法信手拈来。

深度集成到 Vue 中的 [VueX](https://vuex.vuejs.org/en/) 库提供了一种完美的解决方案，可以为您的数据创建一个**干净的**、**隔离的**接口，从而使存根数据（stubbed data）和实际 API 之间的转换变得轻而易举。

## 什么是 VueX

VueX 是受 Flux，Redux 和 Elm 架构的启发下开发的状态管理库，并且专门设计并调整为与 Vue.js 良好集成并利用 Vue 的响应式特性。

所有这些库都旨在解决一个简单问题：当许多组件共享状态时，尤其是兄弟组件或在不同视图下的组件时，管理该状态的分发和更新具有挑战性。

像 VueX 这样的库可以通过结构化和可维护的方式管理组件间的共享状态，方法是创建一个全局状态树，可以按结构化方式访问和更新每个组件。

## VueX 是如何工作的

VueX 将状态管理分为 3 个关键部分：**state**，**mutations** 和 **actions**。 当你实例化一个 VueX store时，你可以定义这三个对象：

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

State 代表实际数据本身。 这只是一个包含数据树的 JavaScript 对象。 在 VueX 中，您可以拥有单个全局状态树或按模块组织（例如用户状态树，产品状态树等）

例如，我们可以使用这个状态树来跟踪我们当前的用户，如果用户没有登录，则从 null 开始：

```
state: {
    currentUser: null
}
```  

### Mutations

Mutations 是我们改变状态树的机制。 状态的所有变化**必须**通过 mutations 来实现，这使得 VueX 能够以可预测的方式管理状态。

一个关于 mutation 的例子也许是这样：

```
mutations: {
    setCurrentUser(currentState, user) {
    currentState.currentUser = user;
    }
}
```

Mutations 是**同步的**，并**直接**修改状态对象（比如，与 Redux 相比，有一个同等的概念称为 reducer 并返回一个 **new** 对象）。

这种状态对象的同步、直接变化与 Vue 的响应式概念完美匹配。 VueX 状态对象是响应式的，所以这些变化向外延伸到所有的依赖。

你可以通过 `commit` 函数来调用一个 mutation：

```
store.commit('setCurrentUser', user);
```

### Actions

Actions 是 VueX 的最后一块，是**意图**和**修改**之间的中介。

Actions是**异步的**，并且**间接地**通过`commititting` mutations 来修改 store。 但是，由于它们是异步的，因此它们可以做的远不止这些。

异步允许 actions 处理诸如 API 调用，用户交互和整个 action 流程等事情。

一个简单的例子，一个 action 可能会进行一次 API 调用并记录结果：

```
actions: {
    login(context, credentials) {
    return myLoginApi.post(credentials).then((user) => {
        context.commit('setCurrentUser', user)
    })
    }
}
```

Actions 可以返回 promises，允许视图或其他代码分派 actions ，等待它们完成并根据其结果做出响应。你应该使用 `dispatch` 来分派一个 action 。而不是使用 `commit`。 例如，我们的调用代码可能如下所示：

```
store.dispatch('login', credentials).then(() => {
    // 重定向到登录区域
}).catch((error) => {
    // 显示有关错误密码的消息
});
```

## 为什么说 VueX 操作是 API 的完美接口

如果您正在开发一个后端和前端同时进行的项目，或者您是一个 UI/前端团队，您甚至可能在后端存在之前就构建用户界面，那么您可能会在开发前端时经常面临这样的问题，即需要将后端的部分数据截取出来。

这种场景的常见做法是如同纯静态模板或内容一样，在前端模板中使用合适的占位符和文本。

从这一步骤开始，就是某种形式的固定写法，由前端静态加载数据并把它们放置到正确的位置。

这些都经常遇到同样的挑战：当后端终于可以使用的时候，需要进行大量的重构工作来获取真实的数据。

即使（奇迹般地）来自后端的数据结构与您的固定写法相匹配，您仍然需要全方位排查以找到每个集成点。如果结构不同（让我们面对它，通常情况下都会这样），您不仅必须这样做，而且必须弄清楚如何更改前端或创建转换数据的抽象层。

### 进入 VueX Actions

VueX 的优点在于，actions 提供了一种**完美的**方式来对前端和后端进行隔离和抽象，并且以这种方式进行操作，以便从存根数据（stubbed data）更新到真正的后端是无缝而简单的。

让我们展开来说。以我们的登录功能作为例子。如果我们的登录 API 尚不存在，但我们仍然准备构建前端，我们可以像这样实施我们的操作：

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

现在，我们的前端可以通过测试数据实现一种登录方式，这种登录方式在将来也是以**同样的**方式运行的，可以同时实现成功和失败的登录请求。 这种行为将**立即**发生，而不是通过 API 异步实现，但通过返回 promises ，现在任何调用者都可以像对待真正的 API 调用一样对待它。

当我们的 API 可用时，我们可以简单地修改这个 action 以使用它，并且我们的代码库中的其他所有内容都保持不变。

### 处理数据不匹配的问题

将我们的 API 调用与 VueX 隔离也为我们提供了一种简洁优雅的方式来处理后端和前端之间的数据格式不匹配的问题。

继续使用我们的登录示例，或许我们假设 API 将返回我们在登录时需要的所有用户信息，但是我们需要在通过身份验证后从单独的端点获取首选项，即使此格式与我们预期的格式不同

我们可以将这种差异完全隔离在我们的 VueX 的 action 中，防止我们需要改变我们前端的其他任何地方。 由于 promises 可以链式调用和嵌套，我们可以在我们的行为被视为完成之前，通过一系列需要完成的 API 调用。

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

从我们的状态修改和 dispatch 给我们的 `login`  action 的代码的角度来看，最终的结果是**完全相同**的。

借助 VueX，将新的或变化的后端 API 集成到我们的前端的挑战已经大大简化。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
