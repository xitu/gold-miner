> * 原文地址：[Using BLoC Pattern with React](https://blog.bitsrc.io/using-bloc-pattern-with-react-cb6fdcfa623b)
> * 原文作者：[Charuka Herath](https://medium.com/@charuka95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-bloc-pattern-with-react.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-bloc-pattern-with-react.md)
> * 译者：
> * 校对者：

# Using BLoC Pattern with React

![](https://cdn-images-1.medium.com/max/5760/1*_x7UbeBdjCqJd3oA5ADpUg.jpeg)

Initially, the Business Logic Component (BLoC) pattern was introduced by Google as a solution to handle states in Flutter applications. It allows you to reduce the workload on UI components by separating the business logic from them.

Over time, other frameworks also started to support the BLoC pattern. And, in this article, I will discuss how we can use this BLoC pattern with React.

## Benefits of Using BLoC Pattern with React

![BLOC architecture diagram](https://cdn-images-1.medium.com/max/5760/1*BaiP-jhLnxgXA1XSU8YY_A.jpeg)

The concept behind the BLoC pattern is straightforward. As you can see in the above figure, business logic will be separated from UI components. First, they will send events to the BLoC using an observer. And then, after processing the request, UI components will be notified by the BLoC using observables**.**

So, let’s look at the advantages of this approach in detail.

### 1. Flexibility to update application logic

When the business logic is standalone from UI components, the impact on the application will be minimum. You will be able to change the business logic any time you want without affecting the UI components.

### 2. Reuse logic

Since the business logic is in one place, UI components can reuse logic without duplicating the code so that the simplicity of the app will increase.

### 3. Ease of testing

When writing test cases, developers can focus on the BLoC itself. So the code base is not going to be messed up.

### 4. Scalability

Over time, application requirements may change, and business logic can keep growing. In such situations, developers can even create multiple BLoCs to maintain the clarity of the codebase.

Moreover, BLoC patterns are platform and environment independent so that developers can use the same BLoC pattern in many projects.

## Concept into Practice

Let’s build a small counter app to demonstrate the usage of the BLoC pattern.

### Step 01: Create a React application and structure it.

First, we need to start by setting up a React app. I will name it bloc-counter-app. Also, I will be using `rxjs` as well.

```bash
// Create React app
npx create-react-app bloc-counter-app

// Install rxjs
yarn add rxjs
```

Then you need to remove all unnecessary code and structure the application as follows.

* Blocs — Keep all the bloc classes we need.
* Components — Keep the UI components.
* Utils — Keep utility files of the project.

![Solder Structure](https://cdn-images-1.medium.com/max/2000/1*NGsidZ0MP3iREtYL1mDHUg.png)

### Step 02: Implementation of the BLoC.

Now, let’s implement the BLoC class. The BLoC class will be responsible for implementing all subjects related to business logic. In this example, it is responsible for the counter logic.

So, I have created a file named `CounterBloc.js` inside the bloc directory and used a pipe to pass the counter to the UI components.

```JavaScript
import { Subject } from 'rxjs';
import { scan } from 'rxjs/operators';

export default class CounterBloc {
  constructor() {
    this._subject = new Subject();
  }

  get counter() {
    return this._subject.pipe(scan((count, v) => count + v, 0));
  }

  increase() {
    this._subject.next(1);
  }

  decrease() {
    this._subject.next(-1);
  }

  dispose() {
    this._subject.complete();
  }
}
```

As you can see, there is simple logic in this class. However, when an app grows in size, imagine the complexity if we do not separate the business logic.

### Step 03: Adding more beauty to the BLoC by an intermediate class.

In this step, I will create the `StreamBuilder.js` inside the utils directory to handle the counter request from the UI. Moreover, developers can handle errors and implement customer handlers within this.

```JavaScript
class AsyncSnapshot {
  constructor(data, error) {
    this._data = data;
    this._error = error;
    this._hasData = data ? true : false;
    this._hasError = error ? true : false;
  }

  get data() {
    return this._data;
  }

  get error() {
    return this._error;
  }

  get hasData() {
    return this._hasData;
  }

  get hasError() {
    return this._hasError;
  }
}
```

In the `AsyncSnapshot` class, we can initialize a constructor, handle our data (check availability, etc. ), and handle errors. But in this example, I have only returned the data for ease of demonstration.

```JavaScript
class StreamBuilder extends Component {
  constructor(props) {
    super(props);

    const { initialData, stream } = props;

    this.state = {
      snapshot: new AsyncSnapshot(initialData),
    };

    stream.subscribe(
      data => {
        this.setState({
          snapshot: new AsyncSnapshot(data, null),
        });
      }
    );
  }

  render() {
    return this.props.builder(this.state.snapshot);
  }
}
```

The initial data is passed into `AysncSnapshot` class and stored in the snapshot state for each subscription. Then it will get rendered in the UI components.

```JavaScript
import { Component } from 'react';

class AsyncSnapshot {
  constructor(data) {
    this._data = data;
  }
  get data() {
    return this._data;
  }
}

class StreamBuilder extends Component {
  constructor(props) {
    super(props);

    const { initialData, stream } = props;

    this.state = {
      snapshot: new AsyncSnapshot(initialData),
    };

    stream.subscribe(
      data => {
        this.setState({
          snapshot: new AsyncSnapshot(data, null),
        });
      }
    );
  }

  render() {
    return this.props.builder(this.state.snapshot);
  }
}

export default StreamBuilder;

```

> **Note:** Ensure to unsubscribe from all the observables and dispose of the BLoCs upon unmounting UI components.

### Step 04: Implementing UI components.

As you can see now, `increase()` and `decrease()` methods are called directly within the UI component. However, output data is handle by a stream builder.

> It is better to have an intermediate layer to implement custom handlers to handle errors.

```JavaScript
import { Fragment } from 'react';

import StreamBuilder from '../utils/StreamBuilder';

const Counter = ({ bloc }) => (
    <Fragment>
        <button onClick={() => bloc.increase()}>+</button>
        <button onClick={() => bloc.decrease()}>-</button>
        <lable size="large" color="olive">
            Count:
            <StreamBuilder
                initialData={0}
                stream={bloc.counter}
                builder={snapshot => <p>{snapshot.data}</p>}
            />
        </lable>
    </Fragment>
);

export default Counter;
```

In the `app.js` file, the BLoC is initialized using the `CounterBloc` class. Thus, the `Counter` component is used by passing the BLoC as a prop.

```JavaScript
import React, { Component } from 'react';
import Counter from './components/Counter';
import CounterBloc from './blocs/CounterBloc';

const bloc = new CounterBloc();

class App extends Component {
  componentWillUnmount() {
    bloc.dispose();
  }
  render() {
    return (
      <div>
        <Counter bloc={bloc} />
      </div>
    );
  }
}
export default App;
```

That’s it. Now you can treat your business logic as a separate entity outside your UI components and change it as you need.

To use and improve this example app please refer to the project [repository](https://github.com/Charuka09/react-counter-bloc) and do not forget to make a PR. 😃

## Final Thoughts

Based on my experience, the BLoC pattern could become an overhead for small-scale projects.

> But, as the project grows, using BLoC patterns helps to build modular applications.

Also, you must have a basic understanding of rxjs and how observables work to implement the BLoC pattern for your React projects.

So, I invite you to try out BLoC pattern and share your thoughts in the comment section.

Thank you for Reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
