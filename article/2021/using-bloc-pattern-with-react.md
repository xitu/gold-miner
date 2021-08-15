> * 原文地址：[Using BLoC Pattern with React](https://blog.bitsrc.io/using-bloc-pattern-with-react-cb6fdcfa623b)
> * 原文作者：[Charuka Herath](https://medium.com/@charuka95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/using-bloc-pattern-with-react.md](https://github.com/xitu/gold-miner/blob/master/article/2021/using-bloc-pattern-with-react.md)
> * 译者：[flashhu](https://github.com/flashhu)
> * 校对者：[jaredliw](https://github.com/jaredliw)，[Tong-H](https://github.com/Tong-H)

# 在 React 中使用 BLoC 模式

![](https://cdn-images-1.medium.com/max/5760/1*_x7UbeBdjCqJd3oA5ADpUg.jpeg)

最初，BLoC 模式 （Business Logic Component）由谷歌提出，作为 Flutter 应用中状态管理的解决方案。它能将业务逻辑从 UI 组件中分离，以此减轻 UI 组件的负担。

随时间的推移，其他框架也开始支持 BLoC 模式。本文将探讨我们该如何在 React 中使用 BLoC 模式。

## 在 React 中使用 BLoC 模式的好处

![BLOC 架构图](https://cdn-images-1.medium.com/max/5760/1*BaiP-jhLnxgXA1XSU8YY_A.jpeg)

BLoC 模式背后的含义与名字所表达的一致。如上图所示，业务逻辑将会从 UI 组件中分离。首先，它们会通过一个观察者（observer）向 BLoC 发送事件。接着，在处理完请求后，BLoC 借助观察项（observable）通知 UI 组件。

让我们具体看看这种模式的优点。

### 1. 更新应用逻辑的灵活性

当业务逻辑独立于 UI 组件时，对应用的影响将是最小的。你将能在任何时候修改业务逻辑而不会影响 UI 组件。

### 2. 复用逻辑

由于业务逻辑写在一个地方，UI 组件能复用逻辑，不需要再复制代码，从而提高程序的简洁程度。

### 3. 测试的便利性

当编写测试用例时，开发者可以关注 BLoC 本身。所以代码库将不会被弄乱。

### 4. 可扩展性

随时间的推移，产品需求可能会改变，业务逻辑也随之增长。在这样的情况下，开发者甚至可以创建多个 BLoC 来保持代码的清晰性。

此外，BLoC 模式是独立于平台和环境的，因此开发者可以在许多项目中使用相同的 BLoC 模式。

## 将概念投入实践

让我们构建一个小型计数程序来演示如何使用 BLoC 模式。

### 第一步：创建 React 应用并初始化结构

首先，我们需要新建 React 应用。我将它命名为 `bloc-counter-app`。此外，我将使用 `rxjs`。

```bash
// 新建 React 应用
npx create-react-app bloc-counter-app

// 安装 rxjs
yarn add rxjs
```

然后，你需要移除所有不必要的代码，按下图所示调整文件结构。

* Blocs — 存放我们需要的 bloc 类
* Components — 存放 UI 组件
* Utils — 存放项目的实用类文件

![文件结构](https://cdn-images-1.medium.com/max/2000/1*NGsidZ0MP3iREtYL1mDHUg.png)

### 第二步：实现 BLoC

现在，让我们来实现 BLoC 类。BLoC 类将负责实现和业务逻辑相关的所有 `subject`。在本例中，它负责实现计数逻辑。

因此，我在 blocs 文件夹中创建了文件 `CounterBloc.js`，并使用 `subject` 上的 `pipe` 方法将计数器传递给 UI 组件。

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

正如你看到的，在这个类中有一些简单的逻辑。然而，当应用的规模不断增长，如果我们不分离业务逻辑，那时的应用可以想象有多复杂。

### 第三步：增加中间类让代码更优雅

在这一步，我将在 utils 文件夹中创建了文件 `StreamBuilder.js`，用来处理来自 UI 组件的计数请求。此外，开发者能在这里处理错误，实现自定义处理函数。

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

在 `AsyncSnapshot` 类中，我们可以初始化构造函数，处理数据（检查可用性等）以及处理错误。但是在本例中，为了方便演示，我只返回了数据。

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

初始数据被传入 `AysncSnapshot`  类，并存储在每个订阅的快照（`snapshot`）状态中。然后它将渲染到 UI 组件内。

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

> **注意**： 确保在卸载 UI 组件时，取消订阅所有观察项（observable）并处理 BLoC。

### 第四步：实现 UI 组件

正如你所见， `increase()` 和 `decrease()` 方法在 UI 组件中被直接调用。然而，输出的数据由流构建器处理（stream builder）。

> 最好由中间层实现自定义处理函数来处理错误。

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

在 `app.js` 文件中，BLoC 使用 `CounterBloc` 类进行初始化。因此，在使用时，`Counter` 组件接收 BLoC 作为 props。

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

就是这样。现在，你可以将业务逻辑视为 UI 组件外的独立实体，并根据你的需要进行修改。

如果想使用或改进这个示例应用，请参考[项目仓库](https://github.com/Charuka09/react-counter-bloc)，不要忘记提 PR。😃

## 最后的想法

根据我的经验，BLoC 模式能变为小型项目的常用方案。

> 但是，随着项目发展，使用 BLoC 模式有助于构建模块化应用。

另外，你必须对 rxjs 有一定的基本了解，并理解在 React 项目中实现 BLoC 模式的过程中，观察项（observable）是如何工作的。

因此，我邀请你尝试使用 BLoC 模式，并在评论区分享你的想法。

非常感谢你的阅读！！！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
