> * 原文地址：[Genuine guide to testing React & Redux applications](https://blog.pragmatists.com/genuine-guide-to-testing-react-redux-applications-6f3265c11f63)
> * 原文作者：[Jakub Żmuda](https://blog.pragmatists.com/@goodguykuba?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/genuine-guide-to-testing-react-redux-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/genuine-guide-to-testing-react-redux-applications.md)
> * 译者：
> * 校对者：

# **Genuine guide to** testing **React & Redux applications**

![](https://cdn-images-1.medium.com/max/800/1*8UPDi2_tJ-4P8rkhfN8uAg.jpeg)

The times when a front-end was just a thin layer of static pages are long gone. Modern web applications grow ever more complex, and logic continues to shift from the back-end to the front-end. Yet when it comes to testing, many keep the same, outdated mentality. If you work with React and Redux, but for some reason aren’t interested in testing your code, I’m here to show you how and why we do it on a daily basis.

_Note: I’m going to be using_ [_Jest_](https://facebook.github.io/jest/) _and_ [_Enzyme_](https://github.com/airbnb/enzyme)_. It’s the most popular stack for testing React and Redux applications. I assume you’ve had a try or are familiar with them to some extent._

#### A word on unit tests vs integration tests

React and Redux applications are built upon three basic building blocks: actions, reducers and components. The choice of whether to test them independently (unit tests), or together (integration tests) is up to you. Integration tests cover the whole functionality, treating it like a black box, whereas unit tests focus on a specific building block. From my experience, integration tests fit very well in applications that tend to grow in size, but are rather simple. On the other hand, unit tests come in handy when you’re building non-trivial solutions with logic usually spread between building blocks. Although most systems fit the first group, I’ll start with unit-testing to better explain the application layers.

#### What we’ll build (and test)

The app is available [here](https://kubaue.github.io/React-TDD/). When you first enter, no image is displayed. You can fetch one by clicking the button. I’m using free [Dog API](https://dog.ceo/dog-api/). Now, without further ado, let’s write some tests. The code is available [here](https://github.com/kubaue/React-TDD).

#### Unit tests: Action creators

In order to display a dog, we first need to fetch it. If you’re not familiar with [thunk](https://github.com/gaearon/redux-thunk), don’t worry. Thunk is a middleware that allows us to return a function instead of a plain action object. We can use that to dispatch the success action or failure action, based on the HTTP request result.

We want to test if retrieving data from the API actually results in dispatching the success action along with the data. In order to do that, we’ll use [redux-mock-store](https://github.com/arnaudbenard/redux-mock-store).

_Note: I’m using_ [_axios_](https://github.com/axios/axios) _for a http client, and_ [_axios-mock-adapter_](https://github.com/ctimmerm/axios-mock-adapter) _to stub calls to the actual API. You’re free to pick whatever suits you best._

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

For the setup, let’s initialize the mock store and stubbed http client in beforeEach(). In the test itself, we specify the response for a request. Later, we execute our actual action creator. Since we use thunk, it returns a function that accepts the store’s dispatch method. Before any assertion, the request needs to be resolved, therefore we flush all of the pending promises.

```
  const flushAllPromises = () => new Promise(resolve => setImmediate(resolve));
```

This line resolves every promise in a single event loop-tick. [window.setImmediate](https://developer.mozilla.org/en-US/docs/Web/API/Window/setImmediate) _is used to break up long-running operations and run a callback function immediately after the browser has completed other operations such as events and display updates._ In this case, our hanging HTTP request is this operation we want to finish.Also, since it’s not a standard feature, you shouldn’t use it in production code.

#### Unit tests: Reducers

I like to think about reducers as the heart of the application. If you develop feature-rich, non-trivial systems, a big part of the complexity will end up here. If you introduce a bug, it’s likely to be hard to track down later. That’s why it’s so important to test reducers. The application we’re building is very simple, but I hope you get the picture.

Every reducer is invoked at the start of the app, hence the need for an initial state. Leaving your state undefined will make you write pesky, defensive checks in components.

```
  it('returns initial state', () => {
    expect(dogReducer(undefined, {})).toEqual({url: ''});
  });
```

It’s rather straightforward. We run the reducer with an undefined state and check whether it returns the state with initial values.

We must also ensure that the reducer properly reacts to a successful fetch and assigns an image URL.

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

Reducers should be pure functions. No side-effects. That’s what makes testing them so easy. Provide a before state, an action to be dispatched, and verify whether an output is correct.

#### Unit tests: Components

Before we start, let’s talk about what aspects of components are worth testing. We obviously can’t test if the component looks pleasant. However, we should definitely test if certain conditional elements are in fact displayed or not; or whether performing some action on a component (not to be confused with Redux actions) results in the function passed in the component’s props being called.

In our system, we rely solely on the Redux as the application state, hence all our components are stateless.

_Note: If you’re looking for classy Enzyme assertions, go check out_ [_enzyme-matchers_](https://github.com/FormidableLabs/enzyme-matchers)_._

The component structure is simple. We have DogApp root components and RandomDog components for fetching and displaying dog images. RandomDog props look like this:

```
  static propTypes = {
    dogUrl: PropTypes.string,
    fetchDog: PropTypes.func,
  };
```

Enzymes allow us to render a component in two ways. Shallow rendering means that only a root will be rendered. If you print the text of a shallow rendered component, you can see that all below components are not rendered. Shallow rendering is perfect for testing components in isolation, and since Enzyme 3 onwards (and optionally Enzyme 2), it invokes lifecycle methods, such as componentDidMount(). We will cover the second way later.

Now let’s write test cases for the RandomDog component.

First, we want to ensure that the placeholder is displayed when no image URL is provided. Also, no image should be displayed.

```
  it('should render a placeholder', () => {
    const wrapper = shallow(<RandomDog />);
    expect(wrapper.find('.dog-placeholder').exists()).toBe(true);
    expect(wrapper.find('.dog-image').exists()).toBe(false);
  });
```

Second, when provided with the dogUrl, the image should be displayed in place of the placeholder.

```
  it('should render actual dog image', () => {
    const wrapper = shallow(<RandomDog dogUrl="http://somedogurl.dog" />);
    expect(wrapper.find('.dog-placeholder').exists()).toBe(false);
    expect(wrapper.find('img[src="http://somedogurl.dog"]').exists()).toBe(true);
  });
```

Finally, clicking the fetch dog button should result in executing the _fetchDog()_ function.

```
  it('should execute fetchDog', () => {
    const fetchDog = jest.fn();
    const wrapper = shallow(<RandomDog fetchDog={fetchDog}/>);
    wrapper.find('.dog-button').simulate('click');
    expect(fetchDog).toHaveBeenCalledTimes(1);
  });
```

_Note: In this example, I’m using element and class selectors. If you find it fragile and refactor your code a lot, consider switching to_ [_custom attributes_](https://developer.mozilla.org/en-US/docs/Learn/HTML/Howto/Use_data_attributes)_._

#### 2 unit tests, 0 integration tests

I’ll explain the problem with unit tests with this contemporary cliché meme.

![](https://cdn-images-1.medium.com/max/800/1*KoTFh3xRPgkzD0FlzsYKjA.gif)

Although unit tests are a great tool, they don’t presume that we properly connect our components, or that a reducer is subscribed to the right action. It’s a common place for bugs, and that’s why we need integration tests.

And yeah, there are people who claim that because of the above, unit tests are useless, but I think they haven’t faced a system complicated enough to acknowledge their value.

#### Integration tests

Instead of testing building blocks separately and in detail, we’ll now bundle them together and put them in a black box. We don’t care anymore how the stuff inside works. What happens in the component, stays in the component. That’s why integration tests are so resilient and refactor-proof. **You can switch the entire underlying mechanism without the need to update the test.**

In integration tests, we don’t want to use the mock store anymore. Let’s bring a real one.

```
import { applyMiddleware, createStore } from 'redux';
import thunk from 'redux-thunk';
import reducers from './reducers/index';

export default function setupStore(initialState) {
  return createStore(reducers, {...initialState}, applyMiddleware(thunk));
}
```

That’s it. Now, that we have a fully functional store, it’s time to move on to the first test. We’ll use Enzyme’s mount type of render for that purpose. Mount is a perfect fit for integration tests, since it renders the whole underlying component tree.

As we did in unit tests, we want to check if on application startup there is no image displayed. But now I’m not passing the empty image URL as a component’s prop, but rather wrapping it in Provider, passing the store we created.

```
  it('should render a placeholder when no dog image is fetched', () => {
    let wrapper = mount(<Provider store={store}><App /></Provider>);
    expect(wrapper.find('div.dog-placeholder').text()).toEqual('No dog loaded yet. Get some!');
    expect(wrapper.find('img.dog-image').exists()).toBe(false);
  });
```

Nothing fancy, huh? Let’s look at the second test case.

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

See how easy this is? The test is very descriptive and we perform real interactions with our component. It covers every aspect unit tests did, and even more. Now we can actually tell if building blocks not only work well separately, but are coupled together in the right way.

Oh, if you’re familiar with Enzyme and wondered why I had to call wrapper.update(), [here’s why](https://github.com/airbnb/enzyme/issues/1153). TLDR: It’s a bug in Enzyme 3. Perhaps by the time you’re reading this, it will be fixed.

#### A word on snapshot testing

Jest offers a way to ensure code changes won’t alter the output of a component’s render() method. Although writing snapshot tests is quick and easy, they aren’t descriptive and you cannot test-drive your development process. The only use case I see is when you’re about to make some changes in your friend’s untested legacy code that you don’t care about enough to clean up, but don’t want to get blamed for breaking it at the same time.

#### So what type of tests shall I use?

Simply start with integration tests. It’s very likely that you won’t feel the urge to implement a single unit test in your project. That means your complexity isn’t divided between building blocks, and it’s perfectly fine. You’ll save quite some time. On the other hand, there are systems that will leverage the power of unit tests. There is room for both.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
