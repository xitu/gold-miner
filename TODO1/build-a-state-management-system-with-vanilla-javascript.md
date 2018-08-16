> * 原文地址：[Build a state management system with vanilla JavaScript](https://css-tricks.com/build-a-state-management-system-with-vanilla-javascript/)
> * 原文作者：[ANDY BELL](https://css-tricks.com/author/andybell/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-state-management-system-with-vanilla-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-a-state-management-system-with-vanilla-javascript.md)
> * 译者：[Shery](https://github.com/shery)
> * 校对者：[IridescentMia](https://github.com/IridescentMia) [coconilu](https://github.com/coconilu)

# 使用原生 JavaScript 构建状态管理系统

状态管理在软件方面并不新鲜，但在 JavaScript 构建的应用中仍然相对较新。习惯上，我们会直接将状态保持在 DOM 上，甚至将其分配给 window 中的全局对象。但是现在，我们已经有了许多选择，这些库和框架可以帮助我们管理状态。像 Redux，MobX 和 Vuex 这样的库可以轻松管理跨组件状态。它大大提升了应用程序的扩展性，并且它对于状态优先的响应式框架（如 React 或 Vue）非常有用。

这些库是如何运作的？我们自己写个状态管理会怎么样？事实证明，它非常简单，并且有机会学习一些非常常见的设计模式，同时了解一些既有用又能用的现代 API。

在我们开始之前，请确保你已掌握中级 JavaScript 的知识。你应该了解数据类型，理想情况下，你应该掌握一些更现代的 ES6+ 语法特性。如果没有，[这可以帮到你](https://css-tricks.com/learning-gutenberg-4-modern-javascript-syntax/)。值得注意的是，我并不是说你应该用这个代替 Redux 或 MobX。我们正在一起开发一个小项目来提升技能，嘿，如果你在乎的是 JavaScript 文件规模的大小，那么它确实可以应付一个小型应用。

### 入门

在我们深入研究代码之前，先看一下我们正在开发什么。它是一个汇总了你今天所取得成就的“完成清单”。它将在不依赖框架的情况下像魔术般更新 UI 中的各种元素。但这并不是真正的魔术。在幕后，我们已经有了一个小小的状态系统，它等待着指令，并以一种可预测的方式维护单一来源的数据。

[查看演示](https://vanilla-js-state-management.hankchizljaw.io)

[查看仓库](http://github.com/hankchizljaw/vanilla-js-state-management)

很酷，对吗？我们先做一些配置工作。我已经整理了一些模版，以便我们可以让这个教程简洁有趣。你需要做的第一件事情是 [从 GitHub 上克隆它](https://github.com/hankchizljaw/vanilla-js-state-management-boilerplate), 或者 [下载并解压它的 ZIP 文件](https://github.com/hankchizljaw/vanilla-js-state-management-boilerplate/archive/master.zip)。

当你下载好了模版，你需要在本地 Web 服务器上运行它。我喜欢使用一个名为 [http-server](https://www.npmjs.com/package/http-server) 的包来做这些事情，但你也可以使用你想用的任何东西。当你在本地运行它时，你会看到如下所示：

![](https://cdn.css-tricks.com/wp-content/uploads/2018/07/state-js-1.png)

我们模版的初始状态。

#### 建立项目结构

用你喜欢的文本编辑器打开根目录。这次对我来说，根目录是：

```
~/Documents/Projects/vanilla-js-state-management-boilerplate/
```

你应该可以看到类似这样的结构：

```
/src
├── .eslintrc
├── .gitignore
├── LICENSE
└── README.md
```

### 发布/订阅

接下来，打开 `src` 文件夹，然后进入里面的 `js` 文件夹。创建一个名为 `lib` 的新文件夹。在里面，创建一个名为 `pubsub.js` 的新文件。

你的 `js` 目录结构应该是这样的：

```
/js
├── lib
└── pubsub.js
```

因为我们准备要创建一个小型的 [Pub/Sub 模式（发布/订阅模式）](https://msdn.microsoft.com/en-us/magazine/hh201955.aspx)，所以请打开 `pubsub.js`。我们正在创建允许应用程序的其他部分订阅具名事件的功能。然后，应用程序的另一部分可以发布这些事件，通常还会携带一些相关的载荷。

Pub/Sub 有时很难掌握，那举个例子呢？假设你在一家餐馆工作，你的顾客点了一个前菜和主菜。如果你曾经在厨房工作过，你会知道当侍者清理前菜时，他们让厨师知道哪张桌子的前菜已经清理了。这是该给那张桌子上主菜的提示。在一个大厨房里，有一些厨师可能在准备不同的菜肴。他们都**订阅**了侍者发出的顾客已经吃完前菜的提示，因此他们自己知道要**准备主菜**。所以，你有多个厨师订阅了同一个提示（具名事件），收到提示后做不同的事（回调）。

![](https://cdn.css-tricks.com/wp-content/uploads/2018/07/state-management-restaurant.jpg)

希望这样想有助于理解。让我们继续！

PubSub 模式遍历所有订阅，并触发其回调，同时传入相关的载荷。这是为你的应用程序创建一个非常优雅的响应式流程的好方法，我们只需几行代码即可完成。

将以下内容添加到 `pubsub.js`：

```
export default class PubSub {
  constructor() {
    this.events = {};
  }
}
```

我们得到了一个全新的类，我们将 `this.events` 默认设置为空对象。`this.events` 对象将保存我们的具名事件。

在 constructor 函数的结束括号之后，添加以下内容：

```
subscribe(event, callback) {

  let self = this;

  if(!self.events.hasOwnProperty(event)) {
    self.events[event] = [];
  }

  return self.events[event].push(callback);
}
```

这是我们的订阅方法。你传递一个唯一的字符串 `event` 作为事件名，以及该事件的回调函数。如果我们的 `events` 集合中还没有匹配的事件，那么我们使用一个空数组创建它，这样我们不必在以后对它进行类型检查。然后，我们将回调添加到该集合中。如果它已经存在，就直接将回调添加到该集合中。我们返回事件集合的长度，这对于想要知道存在多少事件的人来说会方便些。

现在我们已经有了订阅方法，猜猜看接下来我们要做什么？你知道的：`publish` 方法。在你的订阅方法之后添加以下内容：

```
publish(event, data = {}) {

  let self = this;

  if(!self.events.hasOwnProperty(event)) {
    return [];
  }

  return self.events[event].map(callback => callback(data));
}
```

该方法首先检查我们的事件集合中是否存在传入的事件。如果没有，我们返回一个空数组。没有悬念。如果有事件，我们遍历每个存储的回调并将数据传递给它。如果没有回调（这种情况不应该出现），也没事，因为我们在 `subscribe` 方法中使用空数组创建了该事件。

这就是 PubSub 模式。让我们继续下一部分！

### Store 对象（核心）

我们现在已经有了 Pub/Sub 模块，我们这个小应用程序的核心模块 Store 类有了它的唯一依赖。现在我们开始完善它。

让我们先来概述一下这是做什么的。

Store 是我们的核心对象。每当你看到 `@import store from'../lib/store.js` 时，你就会引入我们要编写的对象。它将包含一个 `state` 对象，该对象又包含我们的应用程序状态，一个 `commit` 方法，它将调用我们的 **>mutations**，最后一个 `dispatch` 函数将调用我们的 **actions**。在这个应用和 `Store` 对象的核心之间，将有一个基于代理的系统，它将使用我们的 `PubSub` 模块监视和广播状态变化。

首先在 `js` 目录中创建一个名为 `store` 的新目录。在那里，创建一个名为 `store.js` 的新文件。现在你的 `js` 目录应该如下所示：

```
/js
└── lib
    └── pubsub.js
└──store
    └── store.js
```

打开 `store.js` 并导入我们的 Pub/Sub 模块。为此，请在文件顶部添加以下内容：

```
import PubSub from '../lib/pubsub.js';
```

对于那些经常使用 ES6 的人来说，这将是非常熟悉的。但是，在没有打包工具的情况下运行这种代码可能不太容易被浏览器识别。对于这种方法，已经获得了很多[浏览器支持](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import#Browser_compatibility)！

接下来，让我们开始构建我们的对象。在导入文件后，直接将以下内容添加到 `store.js`：

```
export default class Store {
  constructor(params) {
    let self = this;
  }
}
```

这一切都一目了然，所以让我们添加下一项。我们将为 `state`，`actions` 和 `mutations` 添加默认对象。我们还添加了一个 `status` 属性，我们将用它来确定对象在任意给定时间正在做什么。这是在 `let self = this;` 后面的：

```
self.actions = {};
self.mutations = {};
self.state = {};
self.status = 'resting';
```

之后，我们将创建一个新的 `PubSub` 实例，它将作为 `store` 的 `events` 属性的值：

```
self.events = new PubSub();
```

接下来，我们将搜索传入的 `params` 对象以查看是否传入了任何 `actions` 或 `mutation`。当实例化 `Store` 对象时，我们可以传入一个数据对象。其中包括 `actions` 和 `mutation` 的集合，它们控制着我们 store 中的数据流。在你添加的最后一行代码后面添加以下代码：

```
if(params.hasOwnProperty('actions')) {
  self.actions = params.actions;
}

if(params.hasOwnProperty('mutations')) {
  self.mutations = params.mutations;
}
```

这就是我们所有的默认设置和几乎所有潜在的参数设置。让我们来看看我们的 `Store` 对象如何跟踪所有的变化。我们将使用 [Proxy（代理）](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)来完成此操作。Proxy（代理）所做的工作主要是代理 state 对象。如果我们添加一个 `get` 拦截方法，我们可以在每次询问对象数据时进行监控。与 `set` 拦截方法类似，我们可以密切关注对象所做的更改。这是我们今天感兴趣的主要部分。在你添加的最后一行代码之后添加以下内容，我们将讨论它正在做什么：

```
self.state = new Proxy((params.state || {}), {
  set: function(state, key, value) {

    state[key] = value;

    console.log(`stateChange: ${key}: ${value}`);

    self.events.publish('stateChange', self.state);

    if(self.status !== 'mutation') {
      console.warn(`You should use a mutation to set ${key}`);
    }

    self.status = 'resting';

    return true;
  }
});
```

这部分代码说的是我们正在捕获状态对象 `set` 操作。这意味着当 mutation 运行类似于 `state.name ='Foo'` 时，这个拦截器会在它被设置之前捕获它，并为我们提供了一个机会来处理更改甚至完全拒绝它。但在我们的上下文中，我们将会设置变更，然后将其记录到控制台。然后我们用 `PubSub` 模块发布一个 `stateChange` 事件。任何订阅了该事件的回调将被调用。最后，我们检查 `Store` 的状态。如果它当前不是一个 `mutation`，则可能意味着状态是手动更新的。我们在控制台中添加了一点警告，以便给开发人员一些提示。

这里做了很多事，但我希望你们开始看到这一切是如何结合在一起的，重要的是，我们如何能够集中维护状态，这要归功于 Proxy（代理）和 Pub/Sub。

#### Dispatch 和 commit

现在我们已经添加了 `Store` 的核心部分，让我们添加两个方法。一个是将调用我们 `actions` 的 `dispatch`，另一个是将调用我们 `mutation` 的 `commit`。让我们从 `dispatch` 开始，在 `store.js` 中的 `constructor` 之后添加这个方法：

```
dispatch(actionKey, payload) {

  let self = this;

  if(typeof self.actions[actionKey] !== 'function') {
    console.error(`Action "${actionKey} doesn't exist.`);
    return false;
  }

  console.groupCollapsed(`ACTION: ${actionKey}`);

  self.status = 'action';

  self.actions[actionKey](self, payload);

  console.groupEnd();

  return true;
}
```

此处的过程是：查找 action，如果存在，则设置状态并调用 action，同时创建日志记录组以使我们的所有日志保持良好和整洁。记录的任何内容（如 mutation 或 Proxy（代理）日志）都将保留在我们定义的组中。如果未设置任何 action，它将记录错误并返回 false。这非常简单，而且 `commit` 方法更加直截了当。

在 `dispatch` 方法之后添加：

```
commit(mutationKey, payload) {
    let self = this;

    if(typeof self.mutations[mutationKey] !== 'function') {
    console.log(`Mutation "${mutationKey}" doesn't exist`);
    return false;
    }

    self.status = 'mutation';

    let newState = self.mutations[mutationKey](self.state, payload);

    self.state = Object.assign(self.state, newState);

    return true;
}
```

这种方法非常相似，但无论如何我们都要自己了解这个过程。如果可以找到 mutation，我们运行它并从其返回值获得新状态。然后我们将新状态与现有状态合并，以创建我们最新版本的 state。

添加了这些方法后，我们的 `Store` 对象基本完成了。如果你愿意，你现在可以模块化这个应用程序，因为我们已经添加了我们需要的大部分功能。你还可以添加一些测试来检查所有内容是否按预期运行。我不会就这样结束这篇文章的。让我们实现我们打算去做的事情，并继续完善我们的小应用程序！

### 创建基础组件

为了与我们的 store 通信，我们有三个主要区域，根据存储在其中的内容进行独立更新。我们将列出已提交的项目，这些项目的可视化计数，以及另一个在视觉上隐藏着为屏幕阅读器提供更准确的信息。这些都做着不同的事情，但他们都会从共享的东西中受益，以控制他们的本地状态。我们要做一个基础组件类！

首先，让我们创建一个文件。在 `lib` 目录中，继续创建一个名为 `component.js` 的文件。我的文件路径是：

```
~/Documents/Projects/vanilla-js-state-management-boilerplate/src/js/lib/component.js
```

创建该文件后，打开它并添加以下内容：

```
import Store from '../store/store.js';

export default class Component {
    constructor(props = {}) {
    let self = this;

    this.render = this.render || function() {};

    if(props.store instanceof Store) {
        props.store.events.subscribe('stateChange', () => self.render());
    }

    if(props.hasOwnProperty('element')) {
        this.element = props.element;
    }
    }
}
```

让我们来谈谈这段代码吧。首先，我们要导入 `Store` **类**。这不是因为我们想要它的实例，而是更多用于检查 `constructor` 中的一个属性。说到这个，在 `constructor` 中我们要看看我们是否有一个 render 方法。如果这个 `Component` 类是另一个类的父类，那么它可能会为 `render` 设置自己的方法。如果没有设置方法，我们创建一个空方法来防止事情出错。

在此之后，我们像上面提到的那样对 `Store` 类进行检查。我们这样做是为了确保 `store` 属性是一个 `Store` 类实例，这样我们就可以放心地使用它的方法和属性。说到这一点，我们订阅了全局 `stateChange` 事件，所以我们的对象可以做到**响应式**。每次状态改变时都会调用 `render` 函数。

这就是我们需要为该类所要写的全部内容。它将被用作其他组件类 `extend` 的父类。让我们一起来吧！

### 创建我们的组件

就像我之前说过的那样，我们要完成三个组件，它们都通过 `extend` 关键字，继承了基类 `Component`。让我们从最大的一个组件开始开始：项目清单！

在你的 `js` 目录中，创建一个名为 `components` 的新文件夹，然后创建一个名为 `list.js` 的新文件。我的文件路径是：

```
~/Documents/Projects/vanilla-js-state-management-boilerplate/src/js/components/list.js
```

打开该文件并将这整段代码粘贴到其中：

```
import Component from '../lib/component.js';
import store from '../store/index.js';

export default class List extends Component {

    constructor() {
    super({
        store,
        element: document.querySelector('.js-items')
    });
    }

    render() {
    let self = this;

    if(store.state.items.length === 0) {
        self.element.innerHTML = `<p class="no-items">You've done nothing yet &#x1f622;</p>`;
        return;
    }

    self.element.innerHTML = `
        <ul class="app__items">
        ${store.state.items.map(item => {
            return `
            <li>${item}<button aria-label="Delete this item">×</button></li>
            `
        }).join('')}
        </ul>
    `;

    self.element.querySelectorAll('button').forEach((button, index) => {
        button.addEventListener('click', () => {
        store.dispatch('clearItem', { index });
        });
    });
    }
};
```

我希望有了前面教程，这段代码的含义对你来说是不言而喻的，但是无论如何我们还是要说下它。我们先将 `Store` 实例传递给我们继承的 `Component` 父类。就是我们刚刚编写的 `Component` 类。

在那之后，我们声明了 render 方法，每次触发 Pub/Sub 的 `stateChange` 事件时都会调用的这个 render 方法。在这个 `render` 方法中，我们会生成一个项目列表，或者是没有项目时的通知。你还会注意到每个按钮都附有一个事件，并且它们会触发一个 action，然后由我们的 store 处理 action。这个 action 还不存在，但我们很快就会添加它。

接下来，再创建两个文件。虽然是两个新组件，但它们很小 —— 所以我们只是向其中粘贴一些代码即可，然后继续完成其他部分。

首先，在你的 `component` 目录中创建 `count.js`，并将以下内容粘贴进去：

```
import Component from '../lib/component.js';
import store from '../store/index.js';

export default class Count extends Component {
    constructor() {
    super({
        store,
        element: document.querySelector('.js-count')
    });
    }

    render() {
    let suffix = store.state.items.length !== 1 ? 's' : '';
    let emoji = store.state.items.length > 0 ? '&#x1f64c;' : '&#x1f622;';

    this.element.innerHTML = `
        <small>You've done</small>
        ${store.state.items.length}
        <small>thing${suffix} today ${emoji}</small>
    `;
    }
}
```

看起来跟 list 组件很相似吧？这里没有任何我们尚未涉及的内容，所以让我们添加另一个文件。在相同的 `components` 目录中添加 `status.js` 文件并将以下内容粘贴进去：

```
import Component from '../lib/component.js';
import store from '../store/index.js';

export default class Status extends Component {
    constructor() {
    super({
        store,
        element: document.querySelector('.js-status')
    });
    }

    render() {
    let self = this;
    let suffix = store.state.items.length !== 1 ? 's' : '';

    self.element.innerHTML = `${store.state.items.length} item${suffix}`;
    }
}
```

与之前一样，这里没有任何我们尚未涉及的内容，但是你可以看到有一个基类 `Component` 是多么方便，对吧？这是[面向对象编程](https://en.wikipedia.org/wiki/Object-oriented_programming)众多优点之一，也是本教程的大部分内容的基础。

最后，让我们来检查一下 `js` 目录是否正确。这是我们目前所处位置的结构：

```
/src
├── js
│   ├── components
│   │   ├── count.js
│   │   ├── list.js
│   │   └── status.js
│   ├──lib
│   │  ├──component.js
│   │  └──pubsub.js
└───── store
        └──store.js
        └──main.js
```

### 让我们把它连起来

现在我们已经有了前端组件和主要的 `Store`，我们所要做的就是将它全部连接起来。

我们已经让 store 系统和组件通过数据来渲染和交互。现在让我们把应用程序的两个独立部分联系起来，让整个项目一起协同工作。我们需要添加一个初始状态，一些 `actions` 和一些 `mutations`。在 `store` 目录中，添加一个名为 `state.js` 的新文件。我的文件路径是：

```
~/Documents/Projects/vanilla-js-state-management-boilerplate/src/js/store/state.js
```

打开该文件并添加以下内容：

```
export default {
    items: [
    'I made this',
    'Another thing'
    ]
};
```

这段代码的含义不言而喻。我们正在添加一组默认项目，以便在第一次加载时，我们的小程序将是可完全交互的。让我们继续添加一些 `actions`。在你的 `store` 目录中，创建一个名为 `actions.js` 的新文件，并将以下内容添加进去：

```
export default {
    addItem(context, payload) {
    context.commit('addItem', payload);
    },
    clearItem(context, payload) {
    context.commit('clearItem', payload);
    }
};
```

这个应用程序中的 actions 非常少。本质上，每个 action 都会将 payload（关联数据）传递给 mutation，而 mutation 又将数据提交到 store。正如我们之前所了解的那样，`context` 是 `Store` 类的实例，`payload` 是触发 action 时传入的。说到 mutations，让我们来添加一些。在同一目录中添加一个名为 `mutation.js` 的新文件。打开它并添加以下内容：

```
export default {
    addItem(state, payload) {
    state.items.push(payload);

    return state;
    },
    clearItem(state, payload) {
    state.items.splice(payload.index, 1);

    return state;
    }
};
```

与 actions 一样，这些 mutations 很少。在我看来，你的 mutations 应该保持简单，因为他们有一个工作：改变 store 的 state。因此，这些例子就像它们最初一样简单。任何适当的逻辑都应该发生在你的 `actions` 中。正如你在这个系统中看到的那样，我们返回新版本的 state，以便 `Store` 的 `<code>commit` 方法可以发挥其魔力并更新所有内容。有了这个，store 系统的主要模块就位。让我们通过 index 文件将它们结合到一起。

在同一目录中，创建一个名为 `index.js` 的新文件。打开它并添加以下内容：

```
import actions from './actions.js';
import mutations from './mutations.js';
import state from './state.js';
import Store from './store.js';

export default new Store({
    actions,
    mutations,
    state
});
```

这个文件把我们所有的 store 模块导入进来，并将它们结合在一起作为一个简洁的 `Store` 实例。任务完成！

### 最后一块拼图

我们需要做的最后一件事是添加本教程开头的 _waaaay_ 页面 `index.html` 中包含的 `main.js` 文件。一旦我们整理好了这些，我们就能够启动浏览器并享受我们的辛勤工作！在 `js` 目录的根目录下创建一个名为 `main.js` 的新文件。这是我的文件路径：

```
~/Documents/Projects/vanilla-js-state-management-boilerplate/src/js/main.js
```

打开它并添加以下内容：

```
import store from './store/index.js'; 

import Count from './components/count.js';
import List from './components/list.js';
import Status from './components/status.js';

const formElement = document.querySelector('.js-form');
const inputElement = document.querySelector('#new-item-field');
```

到目前为止，我们做的就是获取我们需要的依赖项。我们拿到了 `Store`，我们的前端组件和几个 DOM 元素。我们紧接着添加以下代码使表单可以直接交互：

```
formElement.addEventListener('submit', evt => {
    evt.preventDefault();

    let value = inputElement.value.trim();

    if(value.length) {
    store.dispatch('addItem', value);
    inputElement.value = '';
    inputElement.focus();
    }
});
```

我们在这里做的是向表单添加一个事件监听器并阻止它提交。然后我们获取文本框的值并修剪它两端的空格。我们这样做是因为我们想检查下一步是否会有任何内容传递给 store。最后，如果有内容，我们将使用该内容作为 payload（关联数据）触发我们的 `addItem` action，并且让我们闪亮的新 `store` 为我们处理它。

让我们在 `main.js` 中再添加一些代码。在事件监听器下，添加以下内容：

```
const countInstance = new Count();
const listInstance = new List();
const statusInstance = new Status();

countInstance.render();
listInstance.render();
statusInstance.render();
```

我们在这里所做的就是创建组件的新实例并调用它们的每个 `render` 方法，以便我们在页面上获得初始状态。

随着最后的添加，我们完成了！

打开你的浏览器，刷新并沉浸在新状态管理应用程序的荣耀中。来吧，添加一些类似于**“完成这个令人敬畏的教程”**的条目。很整洁，是吧？

### 下一步

你可以借助我们一起整合的小系统来做很多事情。以下是你自己进一步探索的一些想法：

*   你可以实现一些本地存储，以保持状态，即使当你重新加载时
*   你可以分离出前端模块，只为你的项目提供一个小型状态系统
*   你可以继续开发此应用程序的前端模块并使其看起来很棒。（我真的很想看到你的作品，所以请分享！）
*   你可以使用一些远程数据，甚至可以使用 API
*   你可以整理你所学到的关于 `Proxy` 和 Pub/Sub 模式的知识，并进一步学习那些可用于不同工作的技能

### 总结

感谢你同我一起学习状态系统是如何工作的。那些大型的主流状态管理库比我们所做的事情要复杂，智能得多 —— 但了解这些系统如何运作并揭开它们背后的神秘面纱仍然有用。无论如何，了解 JavaScript 在不使用框架下的强大能力也很有用。

如果你想要这个小系统的完成版本，请查看这个 [GitHub 仓库](https://github.com/hankchizljaw/vanilla-js-state-management)。你还可以在[此处](https://vanilla-js-state-management.hankchizljaw.io)查看演示。

如果你在此基础上进一步开发，我很乐意看到它，所以如果你这样做，请在[推特](https://twitter.com/hankchizljaw)上跟我联络或发表在下面的评论中！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
