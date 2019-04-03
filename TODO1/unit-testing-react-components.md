> * 原文地址：[Unit Testing React Components](https://medium.com/javascript-scene/unit-testing-react-components-aeda9a44aae2)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/unit-testing-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/unit-testing-react-components.md)
> * 译者：
> * 校对者：

# Unit Testing React Components

![Photo of a first attempt to test a React component by clement127 (CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/4096/1*RzR_S8UJeDn0b_sEQa2V8Q.jpeg)

Unit testing is a great discipline which can lead to [40%-80% reductions in production bug density](https://ieeexplore.ieee.org/document/4163024). Unit testing also has several other important benefits:

* Improves your application architecture and maintainability.
* Leads to better APIs and composability by focusing developers on the developer experience (API) before implementation details.
* Provides quick feedback on file-save to tell you whether or not your changes worked. This can replace `console.log()`and clicking around in the UI to test changes. Newcomers to unit testing might spend an extra 15% - 30% on the TDD process as they figure out how to test various components, but experienced TDD practitioners may experience savings in implementation time using TDD.
* Provides a great safety net which can enhance your confidence when its time to add features or refactor existing features.

But some things are easier to unit test than others. Specifically, unit tests work great for [pure functions](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976): Functions which given the same input, always return the same output, and have no side-effects.

Often, UI components don’t fall into that category of things which are easy to unit test, which makes it harder to stick to the discipline of TDD: Writing tests first.

Writing tests first is necessary to achieve some of the benefits I listed: architecture improvements, better developer experience design, and quicker feedback as you’re developing your app. It takes discipline and practice to train yourself to use TDD. Many developers prefer to tinker before they write tests, but if you don’t write tests first, you rob yourself of a lot of the best features of unit tests.

It’s worth the practice and discipline, though. TDD with unit tests can train you to write UI components which are far simpler, easier to maintain, and easier to compose and reuse with other components.

One recent innovation in my testing discipline is the development of the [RITEway unit testing framework](https://medium.com/javascript-scene/rethinking-unit-test-assertions-55f59358253f), which is a tiny wrapper around [Tape](https://github.com/substack/tape) that helps you write simpler, more maintainable tests.

No matter what framework you use, the following tips will help you write better, more testable, more readable, more composable UI components:

* **Favor pure components for UI code:** given same props, always render the same component. If you need state from the app, you can wrap those pure components with a container component which manages state and side-effects.
* **Isolate application logic/business rules** in pure reducer functions.
* **Isolate side effects** using container components.

## Favor Pure Components

A pure component is a component which, given the same props, always renders the same UI, and has no side-effects. E.g.,

```js
import React from 'react';

const Hello = ({ userName }) => (
  <div className="greeting">Hello, {userName}!</div>
);

export default Hello;
```

These kinds of components are generally very easy to test. You’ll need a way to select the component (in this case, we’re selecting by the `greeting` `className`), and you'll need to know the expected output. To write pure component tests, I use `render-component` from `RITEway`.

To get started, install RITEway:

```bash
npm install --save-dev riteway
```

Internally, RITEway uses `react-dom/server` `renderToStaticMarkup()` and wraps the output in a [Cheerio](https://github.com/cheeriojs/cheerio) object for easy selections. If you're not using RITEway, you can do all that manually to create your own function to render React components to static markup you can query with Cheerio.

Once you have a render function to produce a Cheerio object from your markup, you can write component tests like this:

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

But that’s not very interesting. What if you need to test a stateful component, or a component with side-effects? That’s where TDD gets really interesting for React components, because the answer to that question is the same as the answer to another important question: “How can I make my React components more maintainable and easy to debug?”

The answer: Isolate your state and side-effects from your presentation components. You can do that by encapsulating your state and side-effect management in a container component, and then pass the state into a pure component through props.

But didn’t the hooks API make it so that we can have flat component hierarchies and forget about all that component nesting stuff? Well, not quite. It’s still a good idea to keep your code in three different buckets, and keep these buckets isolated from each other:

* **Display/UI Components**
* **Program logic/business rules** — the stuff that deals with the problem you’re solving for the user.
* **Side effects** (I/O, network, disk, etc.)

In my experience, if you keep the display/UI concerns separate from program logic and side-effects, it makes your life a lot easier. This rule of thumb has always held true for me, in every language and every framework I’ve ever used, including React with hooks.

Let’s demonstrate stateful components by building a click counter. First, we’ll build the UI component. It should display something like, “Clicks: 13” to tell you how many times a button has been clicked. The button will just say “Click”.

Unit tests for the display component are pretty easy. We really only need to test that the button gets rendered at all (we don’t care about what the label says — it may say different things in different languages, depending on user locale settings). We **do** undefinedwant to make sure that the correct number of clicks gets displayed. Let’s write two tests: One for the button display, and one for the number of clicks to be rendered correctly.

When using TDD, I frequently use two different assertions to ensure that I’ve written the component so that the proper value is pulled from props. It’s possible to write a test so that you could hard-code the value in the function. To guard against that, you can write two tests which each test a different value.

In this case, we’ll create a component called `\<ClickCounter>`, and that component will have a prop for the click count, called `clicks`. To use it, simply render the component and set the `clicks` prop to the number of clicks you want it to display.

Let’s look at a pair of unit tests that could ensure we’re pulling the click count from props. Let’s create a new file, click-counter/click-counter-component.test.js:

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

I like to create little factory functions to make it easier to write tests. In this case, `createCounter` will take a number of clicks to inject, and return a rendered component using that number of clicks:

```js
const createCounter = clickCount =>
  render(<ClickCounter clicks={ clickCount } />)
;
```

With the tests written, it’s time to create our `ClickCounter` display component. I've colocated mine in the same folder with my test file, with the name, `click-counter-component.js`. First, let's write a component fragment and watch our test fail:

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
