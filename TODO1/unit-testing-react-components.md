> * 原文地址：[Unit Testing React Components](https://medium.com/javascript-scene/unit-testing-react-components-aeda9a44aae2)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/unit-testing-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/unit-testing-react-components.md)
> * 译者：[xionglong58](https://github.com/xionglong58)
> * 校对者：

# Unit Testing React Components

![Photo of a first attempt to test a React component by clement127 (CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/4096/1*RzR_S8UJeDn0b_sEQa2V8Q.jpeg)

Unit testing is a great discipline which can lead to [40%-80% reductions in production bug density](https://ieeexplore.ieee.org/document/4163024). 单元测试的主要好处有:

* 改善 apps 的结构和k额维护性。
* Leads to better APIs and composability by focusing developers on the developer experience (API) before implementation details.
* 提供快速的文件保存反馈，告诉你更改是否有效。 这可以替代 console.log() 操作,仅在UI中单击就可以测试更改。单元测试的新手可能会在 TDD 过程上多花15% - 30%的时间，因为他们知道需要知道如何测试各种组件，但是有经验的 TDD 开发者会在因使用 TDD 而节省开发时间。
* 提供了一个很好的 safety net，可以在添加功能或重构现有功能时增强你的信心。

但是有些东西比其他的更容易进行单元测试。 具体来说，单元测试对[纯函数](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)非常有用 ：纯函数是一种给定相同输入，总是返回对应的相同值，并且没有副作用的函数.

通常，针对 UI 组件的单元测试不容易进行,首先编写测试的方法使得坚持使用 TDD 的原则变得更加困难。

首先编写测试对于实现我列出的一些好处是必要的:架构改进、更好的开发人员体验设计、以及在开发应用程序时获得更快的反馈。训练自己使用 TDD 需要规则和实践。许多开发人员喜欢在编写测试之前进行粗劣的修补，但是如果不先编写测试，就会错过单元测试的许多好处。

不过，这是值得的实践和规则。使用单元测试的 TDD 可以训练你编写 UI 组件，使得 UI 组件更简洁、易于维护、并且更容易与其他组件组合和重用。

One recent innovation in my testing discipline is the development of the [RITEway unit testing framework](https://medium.com/javascript-scene/rethinking-unit-test-assertions-55f59358253f), which is a tiny wrapper around [Tape](https://github.com/substack/tape) that helps you write simpler, more maintainable tests.

无论你使用的是什么框架，下面的小窍门将帮助你编写更好、更可测试、更可读、更可组合的 UI 组件:

* **使用纯组件编写 UI 代码：** 鉴于相同的 props 总是渲染同一个组件，如果你需要从应用中获取 state，你可以使用一个容器组件来包裹这些纯组件，并使用容器组件管理 state 和产生副作用。
* 在 reducer 函数中**隔离应用程序逻辑/业务规则**。
* 使用容器组件**隔离副作用**。
## 使用纯组件

纯组件是一种给定相同的 props，始终渲染出相同的 UI，并且没有任何副作用的组件。比如,

```js
import React from 'react';

const Hello = ({ userName }) => (
  <div className="greeting">Hello, {userName}!</div>
);

export default Hello;
```

这种组件一般来说很容易进行测试。你需要的是如何定位组件 (拿上面的例子来说，我们选择类名为 `greeting` 的组件)，还要知道输出的期望值。为了的到纯组件我将使用 `RITEway` 的 `render-component` 方法。

首先安装 RITEway:

```bash
npm install --save-dev riteway
```

Internally, RITEway uses `react-dom/server` `renderToStaticMarkup()` and wraps the output in a [Cheerio](https://github.com/cheeriojs/cheerio) object for easy selections. 如果你不使用 RITEway，你可以手动执行所有操作以创建自己的函数，以将React组件渲染为可以使用 Cheerio 查询的静态标记。

一旦你有一个将标记渲染成 Cheerio 对象的渲染函数，你就可以编写如下的组件测试了：

```js
import { describe } from 'riteway';
import render from 'riteway/render-component';
import React from 'react';

import Hello from '../hello';

describe('Hello component', async assert => {
  const userName = 'Spiderman';
  const $ = render(<Hello userName={userName} />);

  assert({
    given: 'a username',
    should: 'Render a greeting to the correct username.',
    actual: $('.greeting')
      .html()
      .trim(),
    expected: `Hello, ${userName}!`
  });
});
```

但是这样做没啥意思，如果你需要测试一个有状态的组件，或者一个会产生副作用的组件，该怎么办？该问题的答案与另一个重要问题的答案相同：“我如何使 React 组件更易于维护和调试？”，这也是 TDD 对 React 组件真正感兴趣的地方。

答案是：将组件的 state 和副作用从展示组件中隔离出去。为了实现这一目标，你可以将 state 和副作用封装在一个容器组件中，然后通过 props 将 state 传递到纯组件中。

但是 hooks API不也是这样做的吗？使得我们拥有平铺的组件层次结构，并忽略所有的组件嵌套内容。呃...，两者不完全是一样的。将代码保存在三个不同的 bucket 中，并将这些 bucket 彼此隔离，这仍然还是一个好主意。

* **展示/UI 组件**
* **程序逻辑/业务规则** — 这一部分处理用户需要解决的问题。
* **副作用** (I/O、网络、磁盘等等。)

根据我的经验，如果你将展示/UI 问题与程序逻辑和副作用分开，你会觉得更加轻松。对于我来说，这个经验法则始终适用于我曾经使用的每种语言和每个框架，包括React with hooks。

让我们通过构建一个点击计数器来演示有状态的组件。首先，我们将构建 UI 组件。它应该显示类似 “Clicks：13” 的内容，告诉你单击按钮的次数。按钮只有点击功能。

显示组件的单元测试非常简单。我们只需要测试按钮是否被渲染（我们不关心 label 的内容 —— 它可能会用不同的语言表达不同的内容，具体取决于用户的区域设置）。 我们**设置** undefinedwant 以确保显示正确的点击次数。下面我们将编写两个测试：一个用于测试按钮显示，另一个用于测试点击次数的正确呈现。

当使用 TDD 时，我经常使用两个不同的断言来确保我已经编写了组件，以便从 props 中提取适当的。编写一个测试来硬编码函数中的值也是可能的。为了防范这种硬编码情况，你可以编写两个测试，每个测试测试不同的值。

这个例子中，我们将创建一个名为`\<ClickCounter>`的组件，该组件将有一个 `clicks` prop 用于记录按钮单击次数。要使用它，只需渲染组件并将 `clicks` prop 值设置为要显示的单击次数即可。

让我们来看下面两个单元测试，它们可以确保我们从 props 中提取点击计数。创建一个新文件，click-counter/click-counter-component.test.js:

```js
import { describe } from 'riteway';
import render from 'riteway/render-component';
import React from 'react';

import ClickCounter from '../click-counter/click-counter-component';

describe('ClickCounter component', async assert => {
  const createCounter = clickCount =>
    render(<ClickCounter clicks={ clickCount } />)
  ;

  {
    const count = 3;
    const $ = createCounter(count);

    assert({
      given: 'a click count',
      should: 'render the correct number of clicks.',
      actual: parseInt($('.clicks-count').html().trim(), 10),
      expected: count
    });
  }

  {
    const count = 5;
    const $ = createCounter(count);

    assert({
      given: 'a click count',
      should: 'render the correct number of clicks.',
      actual: parseInt($('.clicks-count').html().trim(), 10),
      expected: count
    });
  }
});
```

我会新建一些工厂函数让编写测试变得更简单。在本例中，`createCounter` 将单击次数的数值进行注入, 并使用该次数返回渲染后的组件：
```js
const createCounter = clickCount =>
  render(<ClickCounter clicks={ clickCount } />)
;
```

编写测试后，就是创建 `ClickCounter` 显示组件的时候了。我已经将显示组件和 `click-counter-component.js` 测试文件放在同一个文件夹中。首先，让我们编写一个组件 fragment 来监视测试是否失败：

```js
import React, { Fragment } from 'react';

export default () =>
  <Fragment>
  </Fragment>
;
```

If we save and run our tests, we’ll get a `TypeError`, which currently triggers Node's UnhandledPromiseRejectionWarning — eventually, Node will stop with the irritating warnings with the extra paragraph of `DeprecationWarning` and just throw an UnhandledPromiseRejectionError, instead. We get the `TypeError` because our selection returns `null`, and we're trying to run `.trim()` on it. Let's fix that by rendering the expected selector:

```js
import React, { Fragment } from 'react';

export default () =>
  <Fragment>
    <span className="clicks-count">3</span>
  </Fragment>
;
```

Great. Now we should have one passing test, and one failing test:

```
# ClickCounter component
ok 2 Given a click count: should render the correct number of clicks.
not ok 3 Given a click count: should render the correct number of clicks.
  ---
    operator: deepEqual
    expected: 5
    actual:   3
    at: assert (/home/eric/dev/react-pure-component-starter/node_modules/riteway/source/riteway.js:15:10)
...
```

To fix it, take the count as a prop, and use the live prop value in the JSX:

```js
import React, { Fragment } from 'react';

export default ({ clicks }) =>
  <Fragment>
    <span className="clicks-count">{ clicks }</span>
  </Fragment>
;
```

Now our whole test suite is passing:

```
TAP version 13
# Hello component
ok 1 Given a username: should Render a greeting to the correct username.
# ClickCounter component
ok 2 Given a click count: should render the correct number of clicks.
ok 3 Given a click count: should render the correct number of clicks.

1..3
# tests 3
# pass  3

# ok
```

Time to test the button. First, add the test and watch it fail (TDD style):

```js
{
  const $ = createCounter(0);

  assert({
    given: 'expected props',
    should: 'render the click button.',
    actual: $('.click-button').length,
    expected: 1
  });
}
```

This produces a failing test:

```
not ok 4 Given expected props: should render the click button
  ---
    operator: deepEqual
    expected: 1
    actual:   0
...
```

Now we’ll implement the click button:

```js
export default ({ clicks }) =>
  <Fragment>
    <span className="clicks-count">{ clicks }</span>
    <button className="click-button">Click</button>
  </Fragment>
;
```

And the test passes:

```
TAP version 13
# Hello component
ok 1 Given a username: should Render a greeting to the correct username.
# ClickCounter component
ok 2 Given a click count: should render the correct number of clicks.
ok 3 Given a click count: should render the correct number of clicks.
ok 4 Given expected props: should render the click button.

1..4
# tests 4
# pass  4

# ok
```

Now we just need to implement the state logic and hook up the event handler.

## Unit Testing Stateful Components

The approach I’m going to show you is probably overkill for a click counter, but most apps are far more complex than a click counter. State is often saved to database or shared between components. The popular refrain in the React community is to start with local component state and then lift it to a parent component or global app state on an as-needed basis.

It turns out that if you start your local component state management with pure functions, that process is easier to manage later. For this and other reasons (like React lifecycle confusion, state consistency, avoiding common bugs), I like to implement my state management using pure reducer functions. For local component state, you can then import them and apply the `useReducer` React hook.

If you need to lift the state to be managed by a state manager like Redux, you’re already half way there before you even start: Unit tests and all.

First, I’ll create a new test file for state reducers. I’ll colocate this in the same folder, but use a different file. I’m calling this one click-counter/click-counter-reducer.test.js:

```js
import { describe } from 'riteway';

import { reducer, click } from '../click-counter/click-counter-reducer';

describe('click counter reducer', async assert => {
  assert({
    given: 'no arguments',
    should: 'return the valid initial state',
    actual: reducer(),
    expected: 0
  });
});
```

I always start with an assertion to ensure that the reducer will produce a valid initial state. If you later decide to use Redux, it will call each reducer with no state in order to produce the initial state for the store. This also makes it really easy to create a valid initial state any time you need one for unit testing purposes, or to initialize your component state.

Of course, we’ll need to create a corresponding reducer file. I’m calling it click-counter/click-counter-reducer.js:

```js
const click = () => {};

const reducer = () => {};

export { reducer, click };
```

I’m starting by simply exporting an empty reducer and action creator. To learn more about the important role of things like action creators and selectors, read [“10 Tips for Better Redux Architecture”](https://medium.com/javascript-scene/10-tips-for-better-redux-architecture-69250425af44). We’re not going to take the deep dive into React/Redux architecture patterns right now, but an understanding of the topic will go a long way towards understanding what we’re doing here, even if you are not going to use the Redux library.

First, we’ll watch the test fail:

```
# click counter reducer
not ok 5 Given no arguments: should return the valid initial state
  ---
    operator: deepEqual
    expected: 0
    actual:   undefined
```

Now let’s make the test pass:

```js
const reducer = () => 0;
```

The initial value test will pass now, but it’s time to add more meaningful tests:

```js
  assert({
    given: 'initial state and a click action',
    should: 'add a click to the count',
    actual: reducer(undefined, click()),
    expected: 1
  });

  assert({
    given: 'a click count and a click action',
    should: 'add a click to the count',
    actual: reducer(3, click()),
    expected: 4
  });
```

Watch the tests fail (both return `0` when they should return `1` and `4`, respectively). Then implement the fix.

Notice that I’m using the `click()` action creator as the reducer's public API. In my opinion, you should think of the reducer as something that your application does not interact directly with. Instead, it uses action creators and selectors as the public API for the reducer.

I also don't write separate unit tests for action creators and selectors. I always test them in combination with the reducer. Testing the reducer is testing the action creators and selectors, and vice versa. If you follow this rule of thumb, you'll need fewer tests, but still achieve the same test and case coverage as you would if you tested them independently.

```js
const click = () => ({
  type: 'click-counter/click',
});

const reducer = (state = 0, { type } = {}) => {
  switch (type) {
    case click().type: return state + 1;
    default: return state;
  }
};

export { reducer, click };
```

Now all the unit tests will pass:

```
TAP version 13
# Hello component
ok 1 Given a username: should Render a greeting to the correct username.
# ClickCounter component
ok 2 Given a click count: should render the correct number of clicks.
ok 3 Given a click count: should render the correct number of clicks.
ok 4 Given expected props: should render the click button.
# click counter reducer
ok 5 Given no arguments: should return the valid initial state
ok 6 Given initial state and a click action: should add a click to the count
ok 7 Given a click count and a click action: should add a click to the count

1..7
# tests 7
# pass  7

# ok
```

Just one more step: Connecting our behavior to our component. We can do that with a container component. I’ll just call that `index.js` and colocate it with the other files. It should look something like this:

```js
import React, { useReducer } from 'react';

import Counter from './click-counter-component';
import { reducer, click } from './click-counter-reducer';

export default () => {
  const [clicks, dispatch] = useReducer(reducer, reducer());
  return <Counter
    clicks={ clicks }
    onClick={() => dispatch(click())}
  />;
};
```

That’s it. This component’s only job is to connect our state management and pass the state in as props to our unit-tested pure component. To test it, load the app in your browser and click the click button.

Up until now we haven’t looked at the component in the browser or done any kind of styling. Just to clarify what we’re counting, I’ll add a label and some space to the `ClickCounter` component. I'll also hook up the `onClick` function. Now the code looks like this:

```js
import React, { Fragment } from 'react';

export default ({ clicks, onClick }) =>
  <Fragment>
    Clicks: <span className="clicks-count">{ clicks }</span>&nbsp;
    <button className="click-button" onClick={onClick}>Click</button>
  </Fragment>
;
```

And all the unit tests still pass.

What about tests for the container component? I don’t unit test container components. Instead, I use functional tests, which run in-browser and simulate user interactions with the actual UI, running end-to-end. You need both kinds of tests (unit and functional) in your application, and unit testing your container components (which are mostly connective/wiring components like the one that wires up our reducer, above) would be too redundant with functional tests for my taste, and not particularly easy to unit test properly. Often, you’d have to mock various container component dependencies to get them to work.

In the meantime, we’ve unit tested all the important units that don’t depend on side-effects: We’re testing that the correct data gets rendered and that the state is managed correctly. You should also load the component in the browser and see for yourself that the button works and the UI responds.

Implementing functional/e2e tests for React is the same as implementing them for any other framework. I won’t go into them here, but check out [TestCafe](https://devexpress.github.io/testcafe/), [TestCafe Studio](https://www.devexpress.com/products/testcafestudio/) and [Cypress.io](https://www.cypress.io/) for e2e testing without the Selenium dance.

****Eric Elliott** is a distributed systems expert and author of the books, [“Composing Software”](https://leanpub.com/composingsoftware) and [“Programming JavaScript Applications”](http://pjabook.com). As co-founder of [DevAnywhere.io](https://devanywhere.io), he teaches developers the skills they need to work remotely and embrace work/life balance. He builds and advises development teams for crypto projects, and has contributed to software experiences for **Adobe Systems, Zumba Fitness,** **The Wall Street Journal,** **ESPN,** **BBC,** and top recording artists including **Usher, Frank Ocean, Metallica,** and many more.**

***

**He enjoys a remote lifestyle with the most beautiful woman in the world.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
