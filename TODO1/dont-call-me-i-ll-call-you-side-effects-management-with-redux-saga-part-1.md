> * 原文地址：[Don’t call me, I’ll call you: Side effects management with Redux-Saga (Part 1)](https://medium.com/appsflyer/dont-call-me-i-ll-call-you-side-effects-management-with-redux-saga-part-1-d0a92c3f81be)
> * 原文作者：[David Dvora](https://medium.com/@daviddvora?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dont-call-me-i-ll-call-you-side-effects-management-with-redux-saga-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dont-call-me-i-ll-call-you-side-effects-management-with-redux-saga-part-1.md)
> * 译者：
> * 校对者：

# Don’t call me, I’ll call you: Side effects management with Redux-Saga (Part 1)

![](https://cdn-images-1.medium.com/max/800/1*v-_1QMuWsWYoB-AY78nArQ.png)

In this two-part blog post I would like to show basic and advanced use cases of side-effects management in React applications using Redux-Saga. I will explain why we like it here in **AppsFlyer**, and what kind of issues it can solve.

This blog will be introductory and will cover some basic concepts related to Redux-Saga, While the second part will be dedicated to challenges Sagas can solve. Note that I assume you have a prior knowledge of [React](https://reactjs.org/) and [Redux](https://redux.js.org/).

#### Generators first!

In order to understand sagas, we first need to understand what generators are. According to the [docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function%2A):

> Generators are functions which can be exited and later re-entered. Their context will be saved across re-entrances.”

You can think of a generator function as kind of an iterator, which exposes a ‘next’ method. This method will return the next element in the sequence, or let you know you finished iterating over all the elements in the sequence. This behavior requires the generator to maintain an internal state.

This a basic example of a generator, which returns a couple of strings:

```
function* namesEmitter() {
  yield "William";
  yield "Jacob";
  return "Daniel";
}

// execute the generator
var generator = namesEmitter();

console.log(generator.next()); // prints {value: "William", done: false}

console.log(generator.next()); // prints {value: "Jacob", done: false}

console.log(generator.next()); // prints {value: "Daniel", done: true}
```

The generator’s returned value structure is simple - as long as we have values emitted by yield/return, they will appear inside the ‘value’ property. If we don’t have additional values, ‘value’ will be _undefined_ and ‘done’ property will become true.
An important thing to notice is once we execute ‘namesEmitter’, the execution stops when ‘yield’ is called. The execution continues when we call the ‘next’ method of the generator, until the next ‘yield’. Once we use the ‘return’ statement or when a function reaches the end, ‘done’ is positive.

When the sequence length is unknown, we can write the code above like this:

```
var results = generator.next();
while(!results.done){
 console.log(results.value);
 results = generator.next();
}
console.log(results.value);
```

#### What are sagas?

Sagas are based on generator functions. According to the [docs](https://github.com/redux-saga/redux-saga):

> “Saga is like a separate thread in your application that’s solely responsible for side effects.”

Imagine a Saga as a thread that constantly calls the ‘next’ method of a generator function and tries to fetch all of the yielded values as fast as possible. You might ask yourself how it’s related to React and why we should even use it, so first let’s see how sagas are connected to React/Redux:

A common flow of React powered by Redux-Saga will start with a dispatched action. If a reducer is assigned to handle this action - the reducer updates the store with the new state and usually the view is being rendered after.
If a Saga is assigned to handle the action - we usually create a side-effect (like a request to the server), and once it’s finished, the Saga dispatches another action for the reducer to handle.

#### Common use case

We can demonstrate this by showing a common flow:
User interacts with the UI, this interaction triggers a request for data from the server (while displaying a ‘loading’ indication), and finally we use the response value to render something in the page.
Let’s create an action for each step, and see what it looks like with Redux-Saga using a simplified pseudo-code version of the code:

```
// saga.js
import { take } from 'redux-saga/effects'

function* mySaga(){ 
    yield take(USER_INTERACTED_WITH_UI_ACTION);
}
```

The Saga’s generator function is named ‘mySaga’. It uses a Redux-Saga [effect](https://redux-saga.js.org/docs/api/#effect-creators) called ‘[take](https://redux-saga.js.org/docs/api/#takepattern)’, which is **blocking** the execution of the Saga until someone dispatches the action given as a parameter. Once ‘_USER_INTERACTED_WITH_UI_ACTION_’ is dispatched, the method execution will end, just like we saw earlier with the generators (done = true).

Now we will do something in response to this action by causing the UI to render a ‘Loading’ indication. This will be done by dispatching an action for the reducer to handle using a ‘[put](https://redux-saga.js.org/docs/api/#putaction)’ effect which dispatches an action:

```
// saga.js
import { take, put } from 'redux-saga/effects'

function* mySaga(){ 
    yield take(USER_INTERACTED_WITH_UI_ACTION);
    yield put(SHOW_LOADING_ACTION, {isLoading: true});
}

// reducer.js
...
case SHOW_LOADING_ACTION: (state, isLoading) => {
    return Object.assign({}, state, {showLoading: isLoading});
}
...
```

The next step is executing a request by using the ‘[call](https://redux-saga.js.org/docs/api/#callfn-args)’ effect, which takes a function and an argument, and executes the function using those arguments. We will give ‘call’ a ‘GET’ function that executes a server call and returns a promise, which will hold the response content when successful:

```
// saga.js
import { take, put, call } from 'redux-saga/effects'

function* mySaga(){ 
    yield take(USER_INTERACTED_WITH_UI_ACTION);
    yield put(SHOW_LOADING_ACTION, {isLoading: true});
    const data = yield call(GET, 'https://my.server.com/getdata');
    yield put(SHOW_DATA_ACTION, {data: data});
}

// reducer.js
...
case SHOW_DATA_ACTION: (state, data) => {
    return Object.assign({}, state, {data: data, showLoading: false};
}
...
```

To wrap it up, we dispatch SHOW_DATA_ACTION in order to update the UI with the received data.

#### What just happened here?

Once the application started, all Sagas are executed, you can think of it like executing the ‘next’ method of a generator function until nothing is left to be yielded. The ‘take’ effect causes something conceptually similar to a thread sleep, which will be resume execution once ‘_USER_INTERACTED_WITH_UI_ACTION_’ is dispatched.

Once that happens, we continue dispatching ‘_SHOW_LOADING_ACTION_’, which will be handled by the reducer. Since Saga is still running, the ‘call’ effect will run and cause a request to be sent to the server, and the Saga will be sleeping again until the request is returned.

#### Use it again and again

In the example above there will be only one user interaction that will be handled by the Saga, since after we call ‘put’ with ‘_SHOW_DATA_ACTION_’ there is nothing left to be yielded (remember ‘done’ = true?).

If we want to repeat the same series of actions every time ‘_USER_INTERACTED_WITH_UI_ACTION_’ is dispatched, we can wrap the Saga’s generator code with use ‘_while (true)_’ statement. The complete code will look something like this:

```
// saga.js
import { take, put, call } from 'redux-saga/effects'

1. function* mySaga(){ 
2.   while (true){
3.    yield take(USER_INTERACTED_WITH_UI_ACTION);
4.    yield put(SHOW_LOADING_ACTION, {isLoading: true});
5.    const data = yield call(GET, 'https://my.server.com/getdata');
6.    yield put(SHOW_DATA_ACTION, {data: data});
7.  }
8. }

// reducer.js
...
case SHOW_LOADING_ACTION: (state, isLoading) => {
    return Object.assign({}, state, {showLoading: isLoading});
},
case SHOW_DATA_ACTION: (state, data) => {
    return Object.assign({}, state, {data: data, showLoading: false};
}
...
```

No, this infinite loop **won’t** cause a stack overflow and **won’t** crash your client! Since the ‘take’ effect is acting like a thread sleep, the execution of ‘mySaga’ is pending until the specified action is dispatched. This acts the same after the code re-enters the loop.

Let’s go over the flow, step by step:
1. Application starts, and runs all of it’s existing Sagas.
2. _mySaga_ runs, enters the ‘_while (true)_’ loop, and is “sleeping” on line 3.
3. ‘_USER_INTERACTED_WITH_UI_ACTION’_ action is dispatched.
4. Saga’s ‘thread’ is waking up and moves to line 4, where it emits ‘_SHOW_LOADING_ACTION_’ for the reducer to handle (the reducer will now probably cause the view to show some loading indication).
5. We send a request to the server (line 5), and “sleep” until the promise is resolved with content that is stored in the ‘data’ variable.
6. ‘SHOW_DATA_ACTION’ is dispatched with the received data, so now the reducer can use it for updating the view.
7. We enter the loop again, and go back to the second step.

#### What’s next?

In this part I covered some basic concepts related to Redux-Saga and showed how it’s integrated with React application. In the second part I will try to show the actual value we gained from using it in a real-life production application.

Thanks to [Yotam Kadishay](https://medium.com/@kadishay?source=post_page) and [Liron Cohen](https://medium.com/@lironch?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
