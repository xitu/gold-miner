> * 原文地址：[Build time travel debugging in Redux from scratch](https://levelup.gitconnected.com/build-time-travel-debugging-in-redux-from-scratch-665fea8fc6cc)
> * 原文作者：[Trey Huffine](https://levelup.gitconnected.com/@treyhuffine?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-time-travel-debugging-in-redux-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-time-travel-debugging-in-redux-from-scratch.md)
> * 译者：
> * 校对者：

# 从零开始，在 Redux 中构建时间旅行式调试

![](https://cdn-images-1.medium.com/max/2000/1*WoJnfVeCnfT2cGzlsgAjJw.jpeg)

在这篇教程中，我们将从零开始一步步构建时间旅行式调试。我们会先介绍 Redux 的核心特性，及这些特性怎么让时间旅行式调试这种强大功能成为可能。接着我们会用原生 JavaScript 来构建一个 Redux 核心库以及时间旅行式调试，并将它应用到一个简单的不含 React 的 HTML 应用里面去。

![](https://cdn-images-1.medium.com/max/800/1*cRt1u7SCt376nCWu_Ae7mA.gif)

### 使用 Redux 进行时间旅行的基础

时间旅行式调试指的是让你的应用程序状态（state）向前走和向后退的能力，这就使得开发者可以确切了解应用的生命周期的每一点发生了什么。

Redux 是使用单向数据流的 flux 模式的一个拓展。Redux 在 flux 的思路体系上额外加入了 3 条准则。

1.  **唯一的状态来源**。应用程序的全部状态都存储在一个 JavaScript 对象里面。
2.  **状态是只读的**。这就是不可变的概念了。状态是永远不能修改的，不过每一个动作（action）都会产生一个全新的状态对象，然后用它来替换老的。
3.  **由纯函数来产生修改**。这意味着任何时候当一个新的状态生成了，并不会触发其他的副作用。

Redux 应用程序的状态是在一个线性的可预测的时间线上生成的，借助这个概念，时间旅行式调试进一步拓展，将触发的每一个动作（action）产生的状态树都做了一个副本保存下来。

UI 界面可以被当做是 Redux 状态的一个纯函数（译者注：纯函数意味着输入确定的 Redux 状态肯定产生确定的 UI 界面）。时间旅行允许我们给应用程序状态设置一个特定的值，从而在那些条件下产生一个准确的 UI 界面。这种应用程序的可视化和透明化的能力对开发者来说是极为有用的，可以帮他们透彻地理解应用程序里面发生了什么，并显著地减少调试程序耗费的精力。

### 使用 Redux 和时间旅行式调试搭建一个简单的应用

我们接下来会搭建一个简单的 HTML 应用，它会在每次点击的时候产生一个随机的背景颜色并使用 Redux 将颜色的 RGB 值存下来。我们还会建立一个时间旅行拓展，它可以帮我们回放应用程序的每一个状态，并让我们可视化地看到每一步的背景色变化。

#### 搭建 Redux 核心库

如果你对搭建时间旅行式调试感兴趣，那我将会假设你熟练掌握 Redux。如果你是 Redux 的新手或者需要对 store 和 reducer 这些概念重温一下，那建议在接下去的详细讲解前阅读下[这篇文章](https://levelup.gitconnected.com/learn-redux-by-building-redux-from-scratch-dcbcbd31b0d0?source=user_profile---------8----------------)。在这部分教程中，你将一步步搭建 `createStore` 和 reducer。

Redux 核心库就是这个 `createStore` 函数。Redux 的 store 管理着状态对象（这个状态对象代表着应用的全局状态）并暴露出必要的接口供读取和更新状态。调用 `createStore` 会初始化状态并返回一个包含 `getState()`、`subscribe()` 和 `dispatch()` 等方法的对象。

`createStore` 函数接受一个 reducer 函数作为必要参数，并接受一个 `initialState` 作为可选参数。整个 `createStore` 如下文所示（不可思议的简短，对吧？）：

```
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

#### 实施时间旅行时调试

We will implement time traveling by subscribing a new listener to the Redux store and also extending the store’s functionality. Each change in state will be added to an array, giving us a synchronous representation of every change in state of the application. We will print the list of states to the DOM for clarity.

First we initialize the timeline and index of the active state in the history (line 1–2). We also create a `saveTimeline` function that adds the current state to the timeline array, prints the state to the DOM, and increments the index of the given state tree that is being rendered by the app. To ensure we capture every state change, we subscribe the `saveTimeline` function as a listener to the Redux store.

```
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

Next add a new function to the store — `setState`. This will allow us to inject any state into the Redux store. It will be called as we time travel between states using buttons on the DOM that we will create in the next section. The following is the implementation of the `setState` function on the store.

```
// FOR DEBUGGING PURPOSES ONLY
store.setState = desiredState => {
  store.state = desiredState;

// Assume the debugger is injected last. We don't want to update
// the saved states as we are debugging, so we slice it off.
  const applicationListeners = store.listeners.slice(0, -1);
  applicationListeners.forEach(listener => listener());
};
```

> Keep in mind that this is for educational purposes only. You should extend the Redux store or set the state in this manner.

When we build the full application in the following section, we will also build out the DOM. For now, all you need to know is that there will be a “previous” and a “next” button to enable time traveling. These buttons will update the active index for the timeline state being shown, allowing us to easily move forward and backward through the state changes. The follow shows how we register the event listeners to navigate the timeline:

```
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

Putting this all together yields the following code to create time travel debugging.

```
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

// FOR DEBUGGING & EDUCATIONAL PURPOSES ONLY
// The store should not be extended like this.
store.setState = desiredState => {
  store.state = desiredState;

  // Assume the debugger is injected last. We don't want to update
  // the saved states as we're debugging.
  const applicationListeners = store.listeners.slice(0, -1);
  applicationListeners.forEach(listener => listener());
};

// This assumes there are previous/next buttons with the give IDs to control the time travel
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

#### Building an application with time travel debugging

We will now create a visual representation to understand time travel debugging. We add an event listener to the document body that will generate three random numbers between 0–255 and save those as `r`, `g`, and `b` in the Redux store. A function subscribed to the store that will update the background color as well as display the current RGB value on the screen. In addition, our time travel debugger will be subscribed to the state changes and add each change to the timeline.

We begin by initializing the HTML document as follows.

```
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
      // Application logic will be added here...
    </script>
  </body>
</html>
```

Notice that we also create a `<div>` for the debugger. There are buttons to navigate the different states and a node to list each update in the state.

Inside the script, we begin by referencing the DOM nodes and our `createStore`.

```
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

Next, we create the reducer to track the RGB values and initialize the store. The initial state will be a white background.

```
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

Now we can subscribe a function to the store that will set the background color and add the text RGB value to the DOM. This is cause any update to the state to be represented our UI.

```
const setBackgroundColor = () => {
  const state = store.getState();
  const { r, g, b } = state;
  const rgb = `rgb(${r}, ${g}, ${b})`;

  document.body.style.backgroundColor = rgb;
  textNode.innerHTML = rgb;
};

store.subscribe(setBackgroundColor);
```

Finally we add a function to generate a random number 0–255 and an `onClick` event listener that will dispatch a new RGB value to the store.

```
const generateRandomColor = () => {
  return Math.floor(Math.random() * 255);
};

// A simple event to dispatch changes
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

This is the entirety of our application logic. We add the time travel code from the previous section below and at the bottom of the script tag call `store.dispatch({})` to generate the initial state.

![](https://cdn-images-1.medium.com/max/800/1*i3L6QvShxky5wkcloijdqA.gif)

Below is the full working code of the application.

```
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
      // A simple event to dispatch changes
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
      // FOR DEBUGGING PURPOSES ONLY
      store.setState = desiredState => {
        store.state = desiredState;
        // Assume the debugger is injected last. We don't want to update
        // the saved states as we're debugging.
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
      store.dispatch({}); // Sets the inital state
    </script>
  </body>
</html>
```

### Wrap up

Our educational implementation of time travel debugging depicts the core principles of Redux. We can effortlessly track the ongoing state of our application, making it easy to debug and understand fully what is happening.

* * *

If you found this article helpful, please tap the ❤. [Follow me](https://medium.com/@treyhuffine) for more articles on blockchain, React, Node.js, JavaScript, and open source software! You can also find me on [Twitter](https://twitter.com/treyhuffine) or [gitconnected](https://gitconnected.com/treyhuffine).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
