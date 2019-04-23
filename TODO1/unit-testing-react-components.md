> * 原文地址：[Unit Testing React Components](https://medium.com/javascript-scene/unit-testing-react-components-aeda9a44aae2)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/unit-testing-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/unit-testing-react-components.md)
> * 译者：[xionglong58](https://github.com/xionglong58)
> * 校对者：

# 对 React 组件进行单元测试

![Photo of a first attempt to test a React component by clement127 (CC BY-NC-ND 2.0)](https://cdn-images-1.medium.com/max/4096/1*RzR_S8UJeDn0b_sEQa2V8Q.jpeg)

单元测试是一门伟大的学科，它可以[减少 40% - 80% 的 bug](https://ieeexplore.ieee.org/document/4163024)。单元测试的主要好处有:

* 改善应用的结构和可维护性。
* 通过在实现细节之前关注开发人员体验（API），可以获得更好的 API 和可组合性。
* 提供快速的文件保存反馈，告诉你更改是否有效。 这可以替代 console.log() 操作，仅在 UI 中单击就可以测试更改。单元测试的新手可能会在 TDD 过程上多花 15% - 30% 的时间，因为他们需要知道如何去测试各种组件，但是有经验的 TDD 开发者会因使用 TDD 而节省开发时间。
* 提供了一个很好的安全保障，可以在添加功能或重构现有功能时增强你的信心。

但是有些东西比其他的更容易进行单元测试。具体来说，单元测试对[纯函数](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)非常有用：纯函数是一种给定相同输入，总是返回相同的值，并且没有副作用的函数。

通常，针对 UI 组件的单元测试不容易进行，测试先行的方法使得坚持使用 TDD 的原则变得更加困难。

首先编写测试对于实现我列出的一些好处是必要的：架构改进、更好的开发人员体验设计、以及在开发应用程序时获得更快的反馈。训练自己使用 TDD 需要方法和实践。许多开发人员喜欢在编写测试之前进行粗劣的修补，但是如果不先编写测试，就会错过单元测试的许多好处。

不过，这是值得的实践和方法。使用单元测试的 TDD 可以训练你编写 UI 组件，使得 UI 组件更简洁、易于维护、并且更容易与其他组件组合和重用。

我最近关注的一个有创新性的[单元测试框架 RITEway](https://medium.com/javascript-scene/rethinking-unit-test-assertions-55f59358253f), 它是 [Tape](https://github.com/substack/tape) 的一个简单包装版，使得你能够编写更简洁、维护性更强的测试。

无论你使用的是什么框架，下面的小窍门将帮助你编写更好、更可测试、更可读、更可组合的 UI 组件：

* **使用纯组件编写 UI 代码：** 鉴于相同的 props 总是渲染同一个组件，如果你需要从应用中获取 state，你可以使用一个容器组件来包裹这些纯组件，并使用容器组件管理 state 和副作用。
* 在 reducer 纯函数中**隔离应用程序逻辑/业务规则**。
* 使用容器组件**隔离副作用**。

## 使用纯组件

纯组件是一种给定相同的 props，始终渲染出相同的 UI，并且没有任何副作用的组件。比如：

```js
import React from 'react';

const Hello = ({ userName }) => (
  <div className="greeting">Hello, {userName}!</div>
);

export default Hello;
```

这种组件一般来说很容易进行测试。你需要知道的是如何定位组件（拿上面的例子来说，我们选择类名为 `greeting` 的组件），还要知道输出的期望值。为了的到纯组件我将使用 `RITEway` 的 `render-component` 方法。

首先安装 RITEway：

```bash
npm install --save-dev riteway
```

在内部，RITEway 使用 `react-dom/server` `renderToStaticMarkup()`，并将输出包装在 [Cheerio](https://github.com/cheeriojs/cheerio) 对象中，以便选择。如果你不使用 RITEway，你可以手动创建自己的函数，以将 React 组件渲染为可以使用 Cheerio 查询的静态标记。

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

但是这样做没啥意思，如果你需要测试一个有 state 的组件，或者一个会产生副作用的组件，该怎么办？该问题的答案与另一个重要问题的答案相同：“我如何使 React 组件更易于维护和调试？”，这就是 TDD 对于 React 组件变得有趣的地方。

答案是：将组件的 state 和副作用从展示组件中隔离出去。为了实现这一目标，你可以将 state 和副作用封装在一个容器组件中，然后通过 props 将 state 传递到纯组件中。

但是 hooks API 不也是这样做的吗？使得我们拥有平铺的组件层次结构，并忽略所有的组件嵌套内容。呃...，两者不完全是一样的。将代码保存在三个不同的 bucket 中，并将这些 bucket 彼此隔离，这仍然还是一个好主意。

* **展示/UI 组件**
* **程序逻辑/业务规则** —— 这一部分处理用户需要解决的问题。
* **副作用**（I/O、网络、磁盘等等。）

根据我的经验，如果你将展示/UI 问题与程序逻辑和副作用分开，你会觉得更加轻松。对于我来说，这个经验法则始终适用于我曾经使用的每种语言和每个框架，包括React hooks。

让我们通过构建一个点击计数器来演示有 state 的组件。首先，我们将构建 UI 组件。它应该显示类似 “Clicks：13” 的内容，告诉你单击按钮的次数。按钮只有点击功能。

显示组件的单元测试非常简单。我们只需要测试按钮是否被渲染（我们不关心 label 的内容 —— 它可能会用不同的语言表达不同的内容，具体取决于用户的区域设置）。我们**设置** undefinedwant 以确保显示正确的点击次数。下面我们将编写两个测试：一个用于测试按钮显示，另一个用于测试点击次数的正确呈现。

当使用 TDD 时，我经常使用两个不同的断言来确保我已经编写了组件，以便从 props 中提取适当的。编写一个测试来硬编码函数中的值也是可能的。为了防范这种硬编码情况，你可以编写两个测试，每个测试测试不同的值。

这个例子中，我们将创建一个名为 `\<ClickCounter>` 的组件，该组件将有一个 `clicks` prop 用于记录按钮单击次数。要使用它，只需渲染组件并将 `clicks` prop 值设置为要显示的单击次数即可。

让我们来看下面两个单元测试，它们可以确保我们从 props 中提取点击计数。创建一个新文件，click-counter/click-counter-component.test.js：

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

如果保存并测试我们创建的测试，会得到一个 `TypeError` 错误，该错误最终会触发 Node 的 `UnhandledPromiseRejectionWarning` 错误，Node 不会在额外的段落发出 `DeprecationWarning` 这种恼人的警告，而是抛出 `UnhandledPromiseRejectionError`。得到 `TypeError` 错误是由于我们的 selection 返回了我 `null`，并且我们尝试在它上面应用 `.trim()` 方法。让我们通过渲染期望的选择器来解决这个问题：

```js
import React, { Fragment } from 'react';

export default () =>
  <Fragment>
    <span className="clicks-count">3</span>
  </Fragment>
;
```

很好，现在我们拥有了一个可以顺利通过的测试，和一个失败的测试：

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

为了解决这一问题，把 count 作为一个 prop，并在 JSX 中使用 prop 的动态值：

```js
import React, { Fragment } from 'react';

export default ({ clicks }) =>
  <Fragment>
    <span className="clicks-count">{ clicks }</span>
  </Fragment>
;
```

现在，我们的这个测试套件都通过了测试：

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

现在是时候测试 button 了。首先添加测试，并观察错误信息（TDD 惯用方式）：

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

上面的测试用例将产错误的测试：

```
not ok 4 Given expected props: should render the click button
  ---
    operator: deepEqual
    expected: 1
    actual:   0
...
```

现在，我们将应用 click button：

```js
export default ({ clicks }) =>
  <Fragment>
    <span className="clicks-count">{ clicks }</span>
    <button className="click-button">Click</button>
  </Fragment>
;
```

接着测试通过：

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

现在，我们仅需要实现 state 逻辑并将其与事件触发连接起来。

## 单元测试有状态的组件

我下面向你展示的方法对于单击计数器来说可能有点大材小用，毕竟大多数应用程序都比单击计数器复杂得多。state 通常保存到数据库或在组件之间共享。React 社区流行的做法是从本地组件 state 开始，然后根据需要将其提升到父组件或全局应用程序 state。

事实证明，如果使用纯函数启动本地组件 state 管理，那么该过程在以后更容易管理。鉴于此和其他原因（如 React 生命周期混乱、state 一致性、避免常见 bugs），我倾向于使用纯 reducer 函数来实现 state 管理。对于本地组件 state，可以导入它们并应用 `useReducer` React hook。

如果需要将 state 提升到由 Redux 这样的 state 管理器来管理，那么在开始单元测试之前就已经完成了一半。

首先，我将为 state reducers 创建一个新的测试文件。我将把它放在同一个文件夹中，但使用不同的文件名。将这个测试文件命名为 click-counter/click-counter-reducer.test.js：

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

我总是以一个断言开始，以确保 reducer 将产生一个有效的初始 state。如果你稍后决定使用 Redux，它将调用每个没有 state 的 reducer，以生成存储的初始 state。这也使得你在任何时候需要一个有效的初始 state 来进行单元测试或者初始化你的组件 state 变得非常容易。

当然，我们需要创建一个相应的 reducer 文件。将其命名为 click-counter/click-counter-reducer.js：

```js
const click = () => {};

const reducer = () => {};

export { reducer, click };
```

我将从生成简单的空 reducer 和 action 生成器开始。想要了解更多关于 action 生成器和选择器等的内容，请阅读文章 [“10 Tips for Better Redux Architecture”](https://medium.com/javascript-scene/10-tips-for-better-redux-architecture-69250425af44)。我们现在不会深入研究 React/Redux 的架构模式，但是，即便你不打算使用 Redux 库，对其的了解将有助于我们正在进行的测试。

首先，观察下面用例无法通过测试的情况：

```
# click counter reducer
not ok 5 Given no arguments: should return the valid initial state
  ---
    operator: deepEqual
    expected: 0
    actual:   undefined
```

现在，我们将修改测试用例，使其通过测试：

```js
const reducer = () => 0;
```

初始值测试会通过，但是时候添加些更有意义的测试了：

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

观察用例无法通过测试的情况（当它们应该分别返回 `1` 和 `4` 时都返回了 `0`）。然后修改用例，使其通过测试。

注意到我使用了 `click()` action 生成器作为 reducer 的公共 API。我认为你需要明白 reducer 并不会直接与你的应用进行交互。应用使用 action 生成器和选择器作为公共 API 暴露给 reducer。

我也不会为 action 生成器和选择器分别编写测试用例。我总是将它们和 reducer 放在一起进行测试，测试 reducer 就是测试 action 生成器和选择器，反之亦然。 如果你也遵循这个经验法则，你就会少做很多测试。但是如果你分开测试它们，仍旧可以获得相同的测试和用例覆盖率。

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

现在，所有的单元测试都能通过：

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

再往前走一步：将我们的行为与组件联系起来，可以是使用容器组件实现这一点。`index.js` 文件会把其余的文件进行合并，该文件类似下面的样式：

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

可以看到，这个组件的唯一作用就是把我们的 state 管理连接起来，并通过 prop 将 state 传递到用作单元测试的纯组件中。要想测试它，只需要将其加载到浏览器并点击 click 按钮。

截至目前，我们还没有在浏览器中查看任何组件，也没有设置任何样式。为了使我们的计数变得更加清晰，下面将添加一些标记和空间到 `ClickCounter` 组件中。 我还会绑定 `onClick` 函数。代码如下所示：

```js
import React, { Fragment } from 'react';

export default ({ clicks, onClick }) =>
  <Fragment>
    Clicks: <span className="clicks-count">{ clicks }</span>&nbsp;
    <button className="click-button" onClick={onClick}>Click</button>
  </Fragment>
;
```

所有的测试均能通过。

那关于容器组件的测试呢？我并没有对容器组件进行单元测试。取而代之的是, 我使用端到端的功能测试，它运行在浏览器中，模拟用户与实际 UI 的交互。在你的应用中你需要使用两种测试（单元测试和功能测试），并且我觉得将单元测试应用到容器组件（这些容器组件一般是起连接作用的组件，比如上面连接我们 reducer 的容器组件）与将功能测试应用到容器组件相比，前者不仅有些冗余，还不容易进行单元测试。通常，你必须模拟各种容器组件之间的依赖关系，以使它们正常工作。

同时，我们已经对所有不依赖副作用的重要单元进行了单元测试：测试了数据是否被正确的渲染以及 state 是否被正确管理。你还应该在浏览器中加载该组件，并亲自查看该按钮是否工作以及 UI 是否有改变。

功能/端到端测试在 React 上的实现与其它框架上的实现相似，在此不做详细讨论，感兴趣的读者可以查看 [TestCafe](https://devexpress.github.io/testcafe/)、[TestCafe Studio](https://www.devexpress.com/products/testcafestudio/) 和 [Cypress.io](https://www.cypress.io/) 在没有 Selenium dance 的情况下进行端到端测试。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
