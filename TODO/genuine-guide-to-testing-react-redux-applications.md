> * 原文地址：[Genuine guide to testing React & Redux applications](https://blog.pragmatists.com/genuine-guide-to-testing-react-redux-applications-6f3265c11f63)
> * 原文作者：[Jakub Żmuda](https://blog.pragmatists.com/@goodguykuba?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/genuine-guide-to-testing-react-redux-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/genuine-guide-to-testing-react-redux-applications.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[zephyrJS](https://github.com/zephyrJS) [goldEli](https://github.com/goldEli)

# 测试 React & Redux 应用良心指南

![](https://cdn-images-1.medium.com/max/800/1*8UPDi2_tJ-4P8rkhfN8uAg.jpeg)

前端只是一层薄薄的静态页面的时代已经一去不复返了。现代 web 应用程序变得越来越复杂，逻辑也持续从后端向前端转移。然而，当涉及到测试时，许多人都保持着过时的心态。如果你使用的是 React 和 Redux，但是由于某些原因对测试你的代码不感兴趣，我将在这里向你展示如何以及为什么我们每天都这样做。

**注意：我将使用 [Jest](https://facebook.github.io/jest/) 和 [Enzyme](https://github.com/airbnb/enzyme)。它们是测试 React & Redux 应用最流行的工具。我猜你已经用过或者能熟练使用它们了。**

#### 单元测试和集成测试简单对比

React & Redux 应用构建在三个基本的构建块上：actions、reducers 和 components。是独立测试它们（单元测试），还是一起测试（集成测试）取决于你。集成测试会覆盖到整个功能，可以把它想成一个黑盒子，而单元测试专注于特定的构建块。从我的经验来看，集成测试非常适用于容易增长但相对简单的应用。另一方面，单元测试更适用于逻辑复杂的应用。尽管大多数应用都适合第一种情况，但我将从单元测试开始更好地解释应用层。

#### 我们将构建（并测试）什么

这里有一个可用的 [应用](https://kubaue.github.io/React-TDD/)。当你第一次进入页面的时候，不会显示图片。你可以通过点击按钮来获取一张图片。我使用了免费的 [Dog API](https://dog.ceo/dog-api/)。现在让我们写一些测试。可以查看我的 [源码](https://github.com/kubaue/React-TDD)。

#### 单元测试：Action 创建函数

为了展示一只狗的图片，我们首先要获取它，如果你不熟悉 [thunk](https://github.com/gaearon/redux-thunk)，别担心。Thunk 是一个中间件，它可以给我们返回一个函数，而不是 action 对象。我们可以用它根据 HTTP 请求结果来 dispatch 对应的成功的 action 或者失败的 action。

我们要测试从 API 成功取回的数据是否 dispatch 了成功的 action，并且将数据一起传递。为了做到这一点，我们将使用 [redux-mock-store](https://github.com/arnaudbenard/redux-mock-store)。

**注意：我使用 [axios](https://github.com/axios/axios) 来作为客户端请求工具，用 [axios-mock-adapter](https://github.com/ctimmerm/axios-mock-adapter) 来 mock 实际 API 的请求。你可以自由选择适合你的工具。**

```
import configureMockStore from 'redux-mock-store';
import { FETCH_DOG_REQUEST, FETCH_DOG_SUCCESS } from '../../constants/actionTypes';
import fetchDog from './fetchDog';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';

describe('fetchDog action', () => {

  let store;
  let httpMock;

  const flushAllPromises = () => new Promise(resolve => setImmediate(resolve));

  beforeEach(() => {
    httpMock = new MockAdapter(axios);
    const mockStore = configureMockStore();
    store = mockStore({});
  });

  it('fetches a dog', async () => {
    // given
    httpMock.onGet('https://dog.ceo/api/breeds/image/random').reply(200, {
      status: 'success',
      message: 'https://dog.ceo/api/img/someDog.jpg',
    });
    // when
    fetchDog()(store.dispatch);
    await flushAllPromises();
    // then
    expect(store.getActions()).toEqual(
      [
        { type: FETCH_DOG_REQUEST },
        { payload: { url: 'https://dog.ceo/api/img/someDog.jpg' }, type: FETCH_DOG_SUCCESS }
      ]);
  })
});
```

一开始，让我们在 beforeEach() 中进行 mock store 和模拟的 http 客户端的初始化。在测试中，我们为请求指定结果。之后，执行我们的 action 创建函数。因为我们使用了 thunk，因此它会返回一个函数，我们把 store 的 dispatch 方法传给这个函数。在进行任何断言之前，请求需要变为 resolved，因此我们要确保没有 pending 的 Promise。

```
  const flushAllPromises = () => new Promise(resolve => setImmediate(resolve));
```

这行代码会把所有的 promise 放到一个单独的事件循环中。[window.setImmediate](https://developer.mozilla.org/en-US/docs/Web/API/Window/setImmediate) **是用来在浏览器已经完成了比如事件和显示更新等其他操作后，结束这些长时间运行的操作，并立即执行它的回调函数。** 在这个例子中，挂起的 HTTP 请求就是我们要完成的操作。此外，由于这不是一个标准的浏览器特性，所以你不应该在正式代码中使用它。

#### 单元测试：Reducers

我认为 reducers 是应用程序的核心。如果你开发功能丰富、复杂的系统，这部分就会变得很复杂。如果你引入了一个 bug，以后可能很难查找。这就是为什么测试 reducers 非常重要。我们正在构建的应用非常简单，但我希望你能获取到图片。

每个 reducer 都会在应用启动时被调用，因此需要一个初始状态。放任你的初始状态为 undefined 会让你在组件中写好多校验代码。

```
  it('returns initial state', () => {
    expect(dogReducer(undefined, {})).toEqual({url: ''});
  });
```

这段代码很直接，我们使用 undefined 的状态运行 reducer，并检查它是否会返回带有初始值的状态。

我们还必须保证那个 reducer 能正确的响应成功的请求，并获取到图片的 URL。

```
it('sets up fetched dog url', () => {
    // given
    const beforeState = {url: ''};
    const action = {type: FETCH_DOG_SUCCESS, payload: {url: 'https://dog.ceo/api/img/someDog.jpg'}};
    // when
    const afterState = dogReducer(beforeState, action);
    // then
    expect(afterState).toEqual({url: 'https://dog.ceo/api/img/someDog.jpg'});
  });
```

Reducers 应该是纯函数，没有副作用。这会让测试它们变得非常简单。提供一个之前的状态，触发一个 action，然后验证输出状态是否正确。

#### 单元测试：Components

在我们开始之前，让我们先谈谈组件有哪些方面值得测试。我们显然无法测试组件是否好看。但是，我们绝对应该测试某些条件性的元素是否能成功显示；或者对组件执行某些操作（不是 redux 中的 action），通过组件 props 传递的方法是否会被调用。

在我们的系统中，我们完全依赖 redux 管理应用的状态，因此我们所有的组件都是无状态的。

**注意：如果你在寻找优雅的 Enzyme 断言库，可以查看 [_enzyme-matchers_](https://github.com/FormidableLabs/enzyme-matchers)**

组件的结构很简单。我们有 DogApp 根组件和用来获取并显示狗的图片的 RandomDog 组件。
RandomDog 组件的 props 如下：

```
  static propTypes = {
    dogUrl: PropTypes.string,
    fetchDog: PropTypes.func,
  };
```

Enzymes 可以让我们用两种方式来渲染一个组件。Shallow Rendering 意味着只有根组件会被渲染。如果你把 shallow rendered 组件的文本打印出来，你会发现所有子组件都没有被渲染。Shallow rendering 非常适合单独测试组件，并且从 Enzyme 3 开始（Enzyme 2 中也是可选的），它会调用生命周期的方法，比如 componentDidMount()。我们稍后再介绍第二种方法。

现在我们来写 RandomDog 组件的测试用例。

首先，我们要确保没有图片 URL 时，要显示占位符，而且不应该显示图片。

```
  it('should render a placeholder', () => {
    const wrapper = shallow(<RandomDog />);
    expect(wrapper.find('.dog-placeholder').exists()).toBe(true);
    expect(wrapper.find('.dog-image').exists()).toBe(false);
  });
```

其次，在提供图片 URL 时，图片应该替换占位符显示出来。

```
  it('should render actual dog image', () => {
    const wrapper = shallow(<RandomDog dogUrl="http://somedogurl.dog" />);
    expect(wrapper.find('.dog-placeholder').exists()).toBe(false);
    expect(wrapper.find('img[src="http://somedogurl.dog"]').exists()).toBe(true);
  });
```

最后，点击获取狗的图片按钮，应该会执行 **fetchDog()** 方法。

```
  it('should execute fetchDog', () => {
    const fetchDog = jest.fn();
    const wrapper = shallow(<RandomDog fetchDog={fetchDog}/>);
    wrapper.find('.dog-button').simulate('click');
    expect(fetchDog).toHaveBeenCalledTimes(1);
  });
```

**注意：在这个例子中，我使用了元素和类选择器。如果你发现它很脆弱并重构了代码，可以考虑切换到 [_custom attributes_](https://developer.mozilla.org/en-US/docs/Learn/HTML/Howto/Use_data_attributes)。**

#### 只有单元测试，没有集成测试

我用一些陈词滥调来说明单元测试的问题。

![](https://cdn-images-1.medium.com/max/800/1*KoTFh3xRPgkzD0FlzsYKjA.gif)

虽然单元测试是个很好的工具，但它并不能保证我们正确连接了所有的组件，或者 reducer 订阅了正确的 action。这是 bug 容易发生的位置，这就是为什么我们需要集成测试。

是的，有些人认为由于上述原因，单元测试是没用的，但我认为他们没有面对过一个足够复杂的系统来发现单元测试的价值。

#### 集成测试

我们现在将它们捆绑在一起并放在一个黑盒子中，而不是单独和详细地测试构建块。我们不再关心内部是如何工作的，或是组件内部究竟发生了什么。 这就是为什么集成测试非常有弹性和方便重构的原因。**你可以切换整个底层机制而无需更新测试。**

在集成测试中，我们不再需要 mock store。让我们使用真实的吧。

```
import { applyMiddleware, createStore } from 'redux';
import thunk from 'redux-thunk';
import reducers from './reducers/index';

export default function setupStore(initialState) {
  return createStore(reducers, {...initialState}, applyMiddleware(thunk));
}
```

就是这样。现在，我们有一个功能齐全的 store，是时候开始第一个测试了。我们使用 Enzyme 的 mount 来（实现挂载类型的渲染）。Mount 非常适合集成测试，因为它会渲染整个底层组件树。

正如我们在单元测试中所做的那样，我们要检查应用启动时是否没有显示图像。但是现在我没有将空的图像 URL 作为组件的 prop 传递，而是将其包装在 Provider 中，传递了我们创建的 store。

```
  it('should render a placeholder when no dog image is fetched', () => {
    let wrapper = mount(<Provider store={store}><App /></Provider>);
    expect(wrapper.find('div.dog-placeholder').text()).toEqual('No dog loaded yet. Get some!');
    expect(wrapper.find('img.dog-image').exists()).toBe(false);
  });
```

没有什么特别的是吧？我们来看第二个测试用例。

```
  it('should fetch and render a dog', async () => {
    httpMock.onGet('https://dog.ceo/api/breeds/image/random').reply(200, {
      status: 'success',
      message: 'https://dog.ceo/api/img/someDog.jpg'
    });

    const wrapper = mount(<Provider store={store}><App /></Provider>);
    wrapper.find('.dog-button').simulate('click');

    await flushAllPromises();
    wrapper.update();

    expect(wrapper.find('img[src="https://dog.ceo/api/img/someDog.jpg"]').exists()).toBe(true);
  });
```

很容易对吧？这个测试描述了我们和组件之间的真实交互。它涵盖了单元测试所做的每个方面，甚至更多。现在我们可以说构建块不仅能够单独运行，而且能够以正确的方式结合起来。

哦，如果你对 Enzyme 很熟悉，还想知道我为什么调用 wrapper.update()，[这就是原因](https://github.com/airbnb/enzyme/issues/1153)。简而言之：这是 Enzyme 3 的一个 bug。也许在你阅读这篇文章时，它会被修复。

#### 快照测试简介

Jest 提供了一种确保代码更改不会改变组件的 render(）方法输出的方法。虽然编写快照测试非常简单快捷，但它们并不具有描述性，也无法通过测试驱动开发过程。我看到的唯一使用案例是，当你对其他人的未经测试的遗留代码进行一些更改时，你并不想整理这些代码，更不希望因为修改它而受到指责。

#### 那么我们应该使用什么类型的测试？

只需要从集成测试开始。你很可能觉得不会在你的项目中实施一个单元测试。这意味着你的复杂性不会在构建块之间划分，这样非常好。你会节省很多时间。另一方面，有些系统会利用单元测试的能力。两者都有用武之地。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
