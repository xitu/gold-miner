> * 原文地址：[Build time travel debugging in Redux from scratch](https://levelup.gitconnected.com/build-time-travel-debugging-in-redux-from-scratch-665fea8fc6cc)
> * 原文作者：[Trey Huffine](https://levelup.gitconnected.com/@treyhuffine?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-time-travel-debugging-in-redux-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-time-travel-debugging-in-redux-from-scratch.md)
> * 译者：[老教授](https://juejin.im/user/58ff449a61ff4b00667a745c/posts)
> * 校对者：

# 从零开始，在 Redux 中构建时间旅行式调试

![](https://cdn-images-1.medium.com/max/2000/1*WoJnfVeCnfT2cGzlsgAjJw.jpeg)

在这篇教程中，我们将从零开始一步步构建时间旅行式调试。我们会先介绍 Redux 的核心特性，及这些特性怎么让时间旅行式调试这种强大功能成为可能。接着我们会用原生 JavaScript 来构建一个 Redux 核心库以及实现时间旅行式调试，并将它应用到一个简单的不含 React 的 HTML 应用里面去。

![](https://cdn-images-1.medium.com/max/800/1*cRt1u7SCt376nCWu_Ae7mA.gif)

### 使用 Redux 进行时间旅行的基础

时间旅行式调试指的是让你的应用程序状态（state）向前走和向后退的能力，这就使得开发者可以确切地了解应用在其生命周期的每一点上发生了什么。

Redux 是使用单向数据流的 flux 模式的一个拓展。Redux 在 flux 的思路体系上额外加入了 3 条准则。

1.  **唯一的状态来源**。应用程序的全部状态都存储在一个 JavaScript 对象里面。
2.  **状态是只读的**。这就是不可变的概念了。状态是永远不能被修改的，不过每一个动作（action）都会产生一个全新的状态对象，然后用它来替换掉旧的（状态对象）。
3.  **由纯函数来产生修改**。这意味着任何时候生成一个新的状态，都不会产生其他的副作用。

Redux 应用程序的状态是在一个线性的可预测的时间线上生成的，借助这个概念，时间旅行式调试进一步拓展，将触发的每一个动作（action）所产生的状态树都做了一个副本保存下来。

UI 界面可以被当做是 Redux 状态的一个纯函数（译者注：纯函数意味着输入确定的 Redux 状态肯定产生确定的 UI 界面）。时间旅行允许我们给应用程序状态设置一个特定的值，从而在那些条件下产生一个准确的 UI 界面。这种应用程序的可视化和透明化的能力对开发者来说是极为有用的，可以帮他们透彻地理解应用程序里面发生了什么，并显著地减少调试程序耗费的精力。

### 使用 Redux 和时间旅行式调试搭建一个简单的应用

我们接下来会搭建一个简单的 HTML 应用，它会在每次点击的时候产生一个随机的背景颜色并使用 Redux 将颜色的 RGB 值存下来。我们还会建立一个时间旅行拓展，它可以帮我们回放应用程序的每一个状态，并让我们可视化地看到每一步的背景色变化。

#### 搭建 Redux 核心库

如果你对搭建时间旅行式调试感兴趣，那我将默认你已熟练掌握 Redux。如果你是 Redux 的新手或者需要对 store 和 reducer 这些概念重温一下，那建议在接下去的详细讲解前阅读下[这篇文章](https://levelup.gitconnected.com/learn-redux-by-building-redux-from-scratch-dcbcbd31b0d0?source=user_profile---------8----------------)。在这部分教程中，你将一步步搭建 `createStore` 和 reducer。

Redux 核心库就是这个 `createStore` 函数。Redux 的 store 管理着状态对象（这个状态对象代表着应用的全局状态）并暴露出必要的接口供读取和更新状态。调用 `createStore` 会初始化状态并返回一个包含 `getState()`、`subscribe()` 和 `dispatch()` 等方法的对象。

`createStore` 函数接受一个 reducer 函数作为必要参数，并接受一个 `initialState` 作为可选参数。整个 `createStore` 如下文所示（不可思议的简短，对吧？）：

```js
const createStore = (reducer, initialState) => {
  const store = {};
  store.state = initialState;
  store.listeners = [];
  
  store.getState = () => store.state;
  
  store.subscribe = (listener) => {
    store.listeners.push(listener);
  };
  
  store.dispatch = (action) => {
    store.state = reducer(store.state, action);
    store.listeners.forEach(listener => listener());
  };
  
  return store;
};
```

#### 实现时间旅行式调试

我们将对 Redux 的 store 实现一个新的监听，并拓展 store 的能力，从而实现时间旅行功能。状态的每一次改变都将被添加到一个数组里，对于应用状态的每次改变都会给我们一个同步表现。为了清晰起见，我们将把这个状态的列表打印到 DOM 节点里面。

首先，我们会对时间轴和历史中处于活动态的状态索引进行初始化（第1、2行）。我们还会创建一个 `savetimeline` 函数，它会将当前状态添加到时间轴数组，将状态打印到 DOM 节点上，并对程序用来渲染的指定状态树的索引进行递增。为了确保我们捕捉到每一次状态变化，我们将 `saveTimeline` 函数作为 Redux store 的一个监听者实施订阅。

```js
const timeline = [];
let activeItem = 0;

const saveTimeline = () => {
  timeline.push(store.getState());
  timelineNode.innerHTML = timeline
    .map(item => JSON.stringify(item))
    .join('<br/>');
  activeItem = timeline.length - 1;
};

store.subscribe(saveTimeline);
```

接着我们在 store 中添加一个新的函数 —— `setState`。它允许我们向 Redux 的 store 中注入任何状态值。当我们要通过一个 DOM 上的按钮（下一节创建）在不同的状态间进行穿梭时，这个函数就会被调用。下面就是 store 里面这个 `setState` 函数的实现：

```js
// 仅供调试
store.setState = desiredState => {
  store.state = desiredState;

  // 假设调试器（译者注：上文的 saveTimeline ）是最后被注入（到 store.listeners ）的，
  // 我们并不想在调试时更新 timeline 中已存储的状态，所以我们把它排除掉。
  const applicationListeners = store.listeners.slice(0, -1);
  applicationListeners.forEach(listener => listener());
};
```

> 谨记，我们这么做仅为了方便学习。仅在此场景下你可以直接拓展 Redux 的 store 或直接设置状态。

当我们在下一节建立好整个应用，我们也就同时把 DOM 节点给建立好了。现在，你只要知道将会有一个“向前走”和一个“向后走”的按钮来用来进行时间旅行。这两个按钮将更新状态时间轴的活动索引（从而改变用来展示的活动状态），允许我们在不同的状态变化间轻松地前进和后退。下面代码将告诉你怎么注册事件监听来穿梭时间轴：

```js
const previous = document.getElementById('previous');
const next = document.getElementById('next');

previous.addEventListener('click', e => {
  e.preventDefault();
  e.stopPropagation();

  let index = activeItem - 1;
  index = index <= 0 ? 0 : index;
  activeItem = index;

  const desiredState = timeline[index];
  store.setState(desiredState);
});

next.addEventListener('click', e => {
  e.preventDefault();
  e.stopPropagation();

  let index = activeItem + 1;
  index = index >= timeline.length - 1 ? 
    timeline.length - 1 :   index;
  activeItem = index;

  const desiredState = timeline[index];
  store.setState(desiredState);
});
```

综合起来，可以得到下面的代码来创建时间旅行式调试。

```js
const timeline = [];
let activeItem = 0;

const saveTimeline = () => {
  timeline.push(store.getState());
  timelineNode.innerHTML = timeline
    .map(item => JSON.stringify(item))
    .join('<br/>');
  activeItem = timeline.length - 1;
};

store.subscribe(saveTimeline);

// 仅供调试
// store 不应该像这样进行拓展。
store.setState = desiredState => {
  store.state = desiredState;

  // 假设调试器（译者注：上文的 saveTimeline ）是最后被注入（到 store.listeners ）的，
  // 我们并不想在调试时更新 timeline 中已存储的状态，所以我们把它排除掉。
  const applicationListeners = store.listeners.slice(0, -1);
  applicationListeners.forEach(listener => listener());
};

// 这里假定通过这两个 ID 就可以拿到向前走、向后走两个按钮，用以控制时间旅行
const previous = document.getElementById('previous');
const next = document.getElementById('next');

previous.addEventListener('click', e => {
  e.preventDefault();
  e.stopPropagation();

  let index = activeItem - 1;
  index = index <= 0 ? 0 : index;
  activeItem = index;

  const desiredState = timeline[index];
  store.setState(desiredState);
});

next.addEventListener('click', e => {
  e.preventDefault();
  e.stopPropagation();

  let index = activeItem + 1;
  index = index >= timeline.length - 1 ? timeline.length - 1 : index;
  activeItem = index;

  const desiredState = timeline[index];
  store.setState(desiredState);
});
```

#### 搭建一个含时间旅行式调试的应用程序

现在我们开始创建视觉上的效果来理解时间旅行式调试。我们在 document 的 body 上添加事件监听，事件触发时会创建三个 0-255 间的随机数，并分别作为 RGB 值存到 Redux 的 store 里面。将会有一个 store 的订阅函数来更新页面背景色并把当前 RGB 色值展现在屏幕上。另外，我们的时间旅行式调试会对状态变化进行订阅，把每个变化记录到时间轴里。

我们以下面的代码来初始化 HTML 文档并开始我们的工作。

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
  </head>
  <body>
    <div>My background color is <span id="background"></span></div>
    <div id="debugger">
      <div>
        <button id="previous">
          previous
        </button>
        <button id="next">
          next
        </button>
      </div>
      <div id="timeline"></div>
    </div>
    <style>
      html, body {
        width: 100vw;
        height: 100vh;
      }

    #debugger {
        margin-top: 30px;
      }
    </style>
    <script>
      // 应用逻辑将会被添加到这里……
    </script>
  </body>
</html>
```

注意我们还创建了一个 `<div>` 用于调试。里面有用于不同状态间穿梭的按钮，还有一个用来列举状态每一次变化的 DOM 节点。

在 JavaScript 里，我们先引用 DOM 节点，引入 `createStore`。

```js
const textNode = document.getElementById('background');
const timelineNode = document.getElementById('timeline');

const createStore = (reducer, initialState) => {
  const store = {};
  store.state = initialState;
  store.listeners = [];

  store.getState = () => store.state;

  store.subscribe = listener => {
    store.listeners.push(listener);
  };

  store.dispatch = action => {
    console.log('> Action', action);
    store.state = reducer(store.state, action);
    store.listeners.forEach(listener => listener());
  };

  return store;
};
```

接着，我们创建一个用于跟踪 RGB 色值变化的 reducer 并初始化 store。初始状态将是白色背景。

```js
const getInitialState = () => {
  return {
    r: 255,
    g: 255,
    b: 255,
  };
};

const reducer = (state = getInitialState(), action) => {
  switch (action.type) {
    case 'SET_RGB':
      return {
        r: action.payload.r,
        g: action.payload.g,
        b: action.payload.b,
      };
    default:
      return state;
  }
};

const store = createStore(reducer);
```

现在我们对 store 添加订阅函数，用于设置页面背景色并把文本形式的 RGB 色值添加到 DOM 节点上。这会让状态的每一个变化都可以在我们的 UI 界面上表现出来。

```js
const setBackgroundColor = () => {
  const state = store.getState();
  const { r, g, b } = state;
  const rgb = `rgb(${r}, ${g}, ${b})`;

  document.body.style.backgroundColor = rgb;
  textNode.innerHTML = rgb;
};

store.subscribe(setBackgroundColor);
```

最后我们添加一个函数用于生成 0-255 间的随机数，并加上一个 `onClick` 的事件监听，事件触发时将新的 RGB 值派发（dispatch）到 store 里面。

```js
const generateRandomColor = () => {
  return Math.floor(Math.random() * 255);
};

// 一个简单的事件用于派发数据变化
document.addEventListener('click', () => {
  console.log('----- Previous state', store.getState());
  store.dispatch({
    type: 'SET_RGB',
    payload: {
      r: generateRandomColor(),
      g: generateRandomColor(),
      b: generateRandomColor(),
    },
  });
  console.log('+++++ New state', store.getState());
});
```

这就是我们所有的程序逻辑了。我们将上一节的时间旅行代码添加到后面，并在 script 标签的最后面调用 `store.dispatch({})` 来产生初始状态。

![](https://cdn-images-1.medium.com/max/800/1*i3L6QvShxky5wkcloijdqA.gif)

下面是应用程序的完整代码。

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
  </head>
  <body>
    <div>My background color is <span id="background"></span></div>
    <div id="debugger">
      <div>
        <button id="previous">
          previous
        </button>
        <button id="next">
          next
        </button>
      </div>
      <div id="timeline"></div>
    </div>
    <style>
      html, body {
        width: 100vw;
        height: 100vh;
      }
      #debugger {
        margin-top: 30px;
      }
    </style>
    <script>
      const textNode = document.getElementById('background');
      const timelineNode = document.getElementById('timeline');
      const createStore = (reducer, initialState) => {
        const store = {};
        store.state = initialState;
        store.listeners = [];
        store.getState = () => store.state;
        store.subscribe = listener => {
          store.listeners.push(listener);
        };
        store.dispatch = action => {
          console.log('> Action', action);
          store.state = reducer(store.state, action);
          store.listeners.forEach(listener => listener());
        };
        return store;
      };
      const getInitialState = () => {
        return {
          r: 255,
          g: 255,
          b: 255,
        };
      };
      const reducer = (state = getInitialState(), action) => {
        switch (action.type) {
          case 'SET_RGB':
            return {
              r: action.payload.r,
              g: action.payload.g,
              b: action.payload.b,
            };
          default:
            return state;
        }
      };
      const store = createStore(reducer);
      const setBackgroundColor = () => {
        const state = store.getState();
        const { r, g, b } = state;
        const rgb = `rgb(${r}, ${g}, ${b})`;
        document.body.style.backgroundColor = rgb;
        textNode.innerHTML = rgb;
      };
      store.subscribe(setBackgroundColor);
      const generateRandomColor = () => {
        return Math.floor(Math.random() * 255);
      };
      // 一个简单的事件用于派发数据变化
      document.addEventListener('click', () => {
        console.log('----- Previous state', store.getState());
        store.dispatch({
          type: 'SET_RGB',
          payload: {
            r: generateRandomColor(),
            g: generateRandomColor(),
            b: generateRandomColor(),
          },
        });
        console.log('+++++ New state', store.getState());
      });
      const timeline = [];
      let activeItem = 0;
      const saveTimeline = () => {
        timeline.push(store.getState());
        timelineNode.innerHTML = timeline
          .map(item => JSON.stringify(item))
          .join('<br/>');
        activeItem = timeline.length - 1;
      };
      store.subscribe(saveTimeline);
      // 仅供调试
      store.setState = desiredState => {
        store.state = desiredState;
        // 假设调试器（译者注：上文的 saveTimeline ）是最后被注入（到 store.listeners ）的，
        // 我们并不想在调试时更新 timeline 中已存储的状态，所以我们把它排除掉。
        const applicationListeners = store.listeners.slice(0, -1);
        applicationListeners.forEach(listener => listener());
      };
      const previous = document.getElementById('previous');
      const next = document.getElementById('next');
      previous.addEventListener('click', e => {
        e.preventDefault();
        e.stopPropagation();
        let index = activeItem - 1;
        index = index <= 0 ? 0 : index;
        activeItem = index;
        const desiredState = timeline[index];
        store.setState(desiredState);
      });
      next.addEventListener('click', e => {
        e.preventDefault();
        e.stopPropagation();
        let index = activeItem + 1;
        index = index >= timeline.length - 1 ? timeline.length - 1 : index;
        activeItem = index;
        const desiredState = timeline[index];
        store.setState(desiredState);
      });
      store.dispatch({}); // 设置初始状态
    </script>
  </body>
</html>
```

### 总结

我们的时间旅行式调试的教学示范实现向我们展现了 Redux 的核心准则。我们可以毫不费劲地跟踪我们应用程序中不断变化的状态，便于调试和了解正在发生的事情。

* * *

如果你觉得本文有用，请点击 ❤。[订阅我](https://medium.com/@treyhuffine) 可以看到更多关于 blockchain、 React、 Node.js、 JavaScript 和开源软件的文章！你也可以在 [Twitter](https://twitter.com/treyhuffine) 或 [gitconnected](https://gitconnected.com/treyhuffine) 上找到我。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
