> * 原文地址：[Functional setState is the future of React](https://medium.freecodecamp.com/functional-setstate-is-the-future-of-react-374f30401b6b#.p2n552w6l)
> * 原文作者：[Justice Mba](https://medium.freecodecamp.com/@Daajust)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[reid3290](https://github.com/reid3290)
> * 校对者：[sunui](https://github.com/sunui)，[imink](https://github.com/imink)

# React 未来之函数式 setState

![](https://cdn-images-1.medium.com/max/2000/1*K8A3aXts5rTCHYRcdHIR6g.jpeg)

React 使得函数式编程在 JavaScript 领域流行了起来，这驱使大量框架采用 React 所推崇的基于组件的编程模式，函数式编程热正在大范围涌向 web 开发领域。

[![](https://ww3.sinaimg.cn/large/006tNc79gy1fdtapftrozj312i0fktao.jpg)](https://twitter.com/bluxte/status/819915171929948162)

但是 React 团队却还不“消停”，他们持续深耕，从 React（已经超神了！）中发掘出更多函数式编程的宝藏。

因此本文将展示深藏在 React 中的又一函数式“宝藏” —— **函数式（functional）setState**！

好吧，名字其实是我乱编的，而且这个技术也称不上是**新事物**或者是个秘密。这一模式内建于 React 中，但是只有少数 React 深耕者才知道，而且从未有过正式名称 —— 不过现在它有了，那就是**函数式 setState**！

正如 [Dan Abramov](https://medium.com/@dan_abramov) 所言，在**函数式 setState** 模式中，“组件 state 变化的声明可以和组件类本身独立开来”。

这？

### 你已经知道的是...

React 是一个基于组件的 UI 库，组件基本上可以看作是一个接受某些属性然后返回 UI 元素的函数。

    function User(props) {
      return (
        <div>A pretty user</div>
      );
    }

组件可能需要持有并管理其 state。在这种情况下，一般将组件编写为一个类，然后在该类的 `constructor` 函数中初始化 state：

    class User {
      constructor () {
      this.state = {
          score : 0
        };
      }

      render () {
        return (
          <div>This user scored **{this.state.score}**</div>
        );
      }
    }

React 提供了一个用于管理 state 的特殊函数 —— `setState()`，其用法如下：

    class User {
      ...

      increaseScore () {
      this.setState({score : this.state.score + 1});
      }

      ...
    }

注意 `setState()` 的作用机制：你传递给它一个**对象**，该对象含有 state 中你想要更新的部分。换句话说，该对象的键（keys）和组件 state 中的键相对应，然后 `setState()` 通过将该对象合并到 state 中来更新（或者说 *sets*）state。因此称为 “set-State”。

### 你可能还不知道的是...

记住 `setState()` 的作用机制了吗？如果我告诉你说，`setState()` 不仅能接受一个对象，还能接受一个**函数**作为参数呢？

没错，`setState()` 确实可以接受一个函数作为参数。该函数接受该组件**前一刻**的 state 以及**当前**的 props 作为参数，计算和返回**下一刻**的 state。如下所示：


    this.setState(function (state, props) {
     return {
      score: state.score - 1
     }
    });

注意 `setState()` 本身是一个函数，而且我们传递了另一个函数给它作为参数（函数式编程，**函数式 setState**）。乍一看可能觉得这样写挺丑陋的，set-state 需要的步骤太多了。那为什么还要这样写呢？

### 为什么传递一个函数给 setState？

理由是，[state 的更新可能是异步的](https://facebook.github.io/react/docs/state-and-lifecycle.html#state-updates-may-be-asynchronous)。

思考一下调用 `setState()` 时[发生了什么](https://facebook.github.io/react/docs/reconciliation.html)。React 首先会将你传递给 `setState()` 的参数对象合并到当前 state 对象中，然后会启动所谓的 **reconciliation**，即创建一个新的 React Element tree（UI 层面的对象表示），和之前的 tree 作比较，基于你传递给 `setState()` 的对象找出发生的变化，最后更新 DOM。

呦！工作很多嘛！实际上，这还只是精简版总结。但一定要相信：

> React 不会仅仅简单地 “set-state”。

考虑到所涉及的工作量，调用 `setState()` 并不一定会**即时**更新 state。

> 考虑到性能问题，React 可能会将多次 `setState()` 调用批处理（batch）为一次 state 的更新。

这又意味着什么呢？

首先，**“多次 `setState()` 调用”** 的意思是说在某个函数中调用了多次 `setState()`，例如：

```
    ...

    state = {score : 0};

    // 多次 setState() 调用
    increaseScoreBy3 () {
      this.setState({score : this.state.score + 1});
      this.setState({score : this.state.score + 1});
      this.setState({score : this.state.score + 1});
    }

    ...
```

面对这种 **多次 `setState()` 调用** 的情况，为了避免重复做上述大量的工作，React 并不会真地**完整调用三次** "set-state"；相反，它会机智地告诉自己：“哼！我才不要‘愚公移山’三次呢，每次还得更新部分 state。不行，我得找个‘背包’，把这些部分更新打包装好，一次性搞定。”朋友们，这就是所谓的**批处理**啊！

记住传递给 `setState()` 的纯粹是个对象。现在，假设 React 每次遇到 **多次 `setState()` 调用**都会作上述批处理过程，即将每次调用 `setState()` 时传递给它的所有对象合并为一个对象，然后用这个对象去做真正的 `setState()`。

在 JavaScript 中，对象合并可以这样写：

    const singleObject = Object.assign(
      {},
      objectFromSetState1,
      objectFromSetState2,
      objectFromSetState3
    );

这种写法叫作 **object 组合（composition）**。

在 JavaScript 中，对象“合并（merging）”或者叫对象**组合（composing）**的工作机制如下：如果传递给 `Object.assign()` 的多个对象有相同的键，那么**最后一个**对象的值会“胜出”。例如：

    const me  = {name : "Justice"},
          you = {name : "Your name"},
          we  = Object.assign({}, me, you);

    we.name === "Your name"; //true

    console.log(we); // {name : "Your name"}

因为 `you` 是最后一个合并进 `we` 中的，因此 `you` 的 `name` 属性的值 “Your name” 会覆盖 `me` 的 `name` 属性的值。因此 `we` 的 `name` 属性的值最终为 “Your name”，所以说 `you` 胜了！

综上所述，如果你多次调用 `setState()` 函数，每次都传递给它一个对象，那么 React 就会将这些对象**合并**。也就是说，基于你传进来的多个对象，React 会**组合**出一个新对象。如果这些对象有同名的属性，那么就会取**最后一个**对象的属性值，对吧？

这意味着，上述 `increaseScoreBy3` 函数的最终结果会是 1 而不是 3。因为 React 并不会按照 `setState()` 的调用顺序**即时**更新 state，而是首先会将所有对象合并到一起，得到 `{score : this.state.score + 1}`，然后仅用该对象进行一次 “set-state”，即 `User.setState({score : this.state.score + 1}`。

需要搞清楚的是，给 `setState()` 传递对象本身是没有问题的，问题出在当你想要基于之前的 state 计算出下一个 state 时还给 `setState()` 传递对象。因此可别这样做了，这是不安全的！

> 因为 **`this.props`** 和 **`this.state`** 可能是异步更新的，你不能依赖这些值计算下一个 state。

下面 [Sophia Shoemaker](https://medium.com/@shopsifter) 写的一个例子展示了上述问题，细细把玩一番吧，留意其中好坏两种解决方案。

[代码链接](http://codepen.io/mrscobbler/pen/JEoEgN)

### 让函数式 setState 来拯救你

如果你还未曾把玩上面的例子，我还是强烈建议你玩一玩，因为这有利于你理解本文的核心概念。

在把玩上述例子的时候，你肯定注意到了 **setState** 解决了我们的问题。但究竟是如何解决的呢？

让我们请教一下 React 界的 Oprah（译者注：非知名脱口秀主持人）—— Dan。

[![](https://ww3.sinaimg.cn/large/006tNc79gy1fdtasm2y6fj313o0u6q6h.jpg)](https://twitter.com/dan_abramov/status/824309659775467527?ref_src=twsrc%5Etfw)

注意看他给出的答案，当你编写函数式 setState 的时候，

> 更新操作会形成一个任务队列，稍后会按其调用顺序依次执行。

因此，当面对**多次`函数式 setState()` 调用**时，React 并不会将对象合并（显然根本没有对象让它合并），而是会**按调用顺序**将这些函数**排列**起来。

之后，React 会依次调用**队列**中的函数，传递给它们**前一刻**的 state —— 如果当前执行的是队列中的第一个函数式 `setState()` ，那么就是在该函数式 `setState()` 调用之前的 state；否则就是最近一次函数式 `setState()` 调用并更新了 state 之后的 state。通过这种机制，React 达到 state 更新的目的。

话说回来，我还是觉得代码更有说服力。只不过这次我们会“伪造”点东西，虽然这不是 React 内部真正的做法，但也基本是这么个意思。

还有，考虑到代码简洁问题，下面会使用 ES6，当然你也可以用 ES5 重写一下。

首先，创建一个组件类。在这个类里，创建一个**伪造**的 `setState()` 方法。该组件会使用 `increaseScoreBy3()` 方法来多次调用函数式 setState。最后，会仿照 React 的做法实例化该类。

    class User{
      state = {score : 0};

      //“伪造” setState
      setState(state, callback) {
        this.state = Object.assign({}, this.state, state);
        if (callback) callback();
      }

      // 多次函数式 setState 调用
      increaseScoreBy3 () {
        this.setState( (state) => ({score : state.score + 1}) ),
        this.setState( (state) => ({score : state.score + 1}) ),
        this.setState( (state) => ({score : state.score + 1}) )
      }
    }

    const Justice = new User();

注意 setState 还有一个可选的参数 —— 一个回调函数，如果传递了这个参数，那么 React 就会在 state 更新后调用它。

现在，当用户调用 `increaseScoreBy3()` 后，React 会将多次函数式 setState 调用排成一个队列。本文旨在阐明为什么函数式 setState 是安全的，因此不会在此模拟上述逻辑。但可以想象，所谓“队列化”的处理结果应该是一个函数数组，类似于：

    const updateQueue = [
      (state) => ({score : state.score + 1}),
      (state) => ({score : state.score + 1}),
      (state) => ({score : state.score + 1})
    ];

最后模拟更新过程：

    // 按序递归式更新 state
    function updateState(component, updateQueue) {
      if (updateQueue.length === 1) {
        return component.setState(updateQueue[0](component.state));
      }

    return component.setState(
        updateQueue[0](component.state),
        () =>
         updateState( component, updateQueue.slice(1))
      );
    }

    updateState(Justice, updateQueue);

诚然，这些代码并不能称之为优雅，你肯定能写得更好。但核心概念是，使用**函数式 setState**，你可以传递一个函数作为其参数，当执行该函数时，React 会将更新后的 state 复制一份并传递给它，这便起到了更新 state 的作用。基于上述机制，函数式 setState 便可基于**前一刻的 state** 来更新当前 state。

下面是这个例子的完整代码，请细细把玩以充分理解上述概念（或许还可以改得更优雅些）。

[![](https://ww3.sinaimg.cn/large/006tNc79gy1fdtatkotz1j314g0ao3zp.jpg)](http://jsbin.com/najewe/edit?js,console)

一番把玩过后，让我们来弄清为何将函数式 setState 称之为“宝藏”。

### React 最为深藏不露的秘密

至此，我们已经深入探讨了为什么多次函数式 setState 在 React 中是安全的。但是我们还没有给函数式 setState 下一个完整的定义：“独立于组件类之外声明 state 的变化”。

过去几年，setting-state 的逻辑（即传递给 `setState()` 的对象或函数）一直都存在于组件类内部，这更像是命令式（imperative）而非 声明式（declarative）。（译者注：imperative 和 declarative 的区别参见 [stackoverflow上的问答](http://stackoverflow.com/questions/1784664/what-is-the-difference-between-declarative-and-imperative-programming)）

不过，今天我将向你展示新出土的宝藏 —— **React 最为深藏不露的秘密**：

[![](https://ww4.sinaimg.cn/large/006tNc79gy1fdtau6cvhbj31620qmn0o.jpg)](https://twitter.com/dan_abramov/status/824308413559668744?ref_src=twsrc%5Etfw)

感谢 [Dan Abramov](https://medium.com/@dan_abramov)！

这就是函数式 setState 的强大之处 —— 在组件类**外部**声明 state 的更新逻辑，然后在组件类**内部**调用之。

    // 在组件类之外
    function increaseScore (state, props) {
      return {score : state.score + 1}
    }

    class User{
      ...

    // 在组件类之内
      handleIncreaseScore () {
        this.setState(increaseScore)
      }

      ...
    }

这就叫做 declarative！组件类不用再关心 state 该如何更新，它只须声明它想要的更新**类型**即可。

为了充分理解这样做的优点，不妨设想如下场景：你有一些很复杂的组件，每个组件的 state 都由很多小的部分组成，基于 action 的不同，你必须更新 state 的不同部分，每一个更新函数都有很多行代码，并且这些逻辑都存在于组件内部。不过有了函数式 setState，再也不用面对上述问题了！

此外，我个人偏爱小而美的模块；如果你和我一样，你就会觉得现在这模块略显臃肿了。基于函数式 setState，你就可以将 state 的更新逻辑抽离为一个模块，然后在组件中引入和使用该模块。

    import {increaseScore} from "../stateChanges";

    class User{
      ...

      // 在组件类之内
      handleIncreaseScore () {
        this.setState(increaseScore)
    }

      ...
    }

而且你还可以在其他组件中复用 increaseScore 函数 —— 只须引入模块即可。

函数式 setState 还能用于何处呢？

简化测试！

[![](https://ww1.sinaimg.cn/large/006tNc79gy1fdtav1aeajj313s0yujvy.jpg)](https://twitter.com/dan_abramov/status/824310320399319040/photo/1?ref_src=twsrc%5Etfw)

你还可以传递**额外**的参数用于计算下一个 state（这让我脑洞大开...#funfunFunction）。

[![](https://ww1.sinaimg.cn/large/006tNc79gy1fdtavhi1ofj3132108789.jpg)](https://twitter.com/dan_abramov/status/824314363813232640?ref_src=twsrc%5Etfw)

更多精彩，敬请期待...

### [React 未来式](https://github.com/reactjs/react-future/tree/master/07%20-%20Returning%20State)

![](https://cdn-images-1.medium.com/max/1600/0*uInBa_PPwz5aLo0j.jpg)

最近几年，React 团队一直都致力于更好地实现  [stateful functions](https://github.com/reactjs/react-future/blob/master/07%20-%20Returning%20State/01%20-%20Stateful%20Functions.js)。

函数式 setState 看起来就是这个问题的正确答案（也许吧）。

Hey, Dan！还有什么最后要说的吗？

[![](https://ww1.sinaimg.cn/large/006tNc79gy1fdtavvsxt1j31260cuwg0.jpg)](https://twitter.com/dan_abramov/status/824315688093421568?ref_src=twsrc%5Etfw)

如果你阅读至此，估计就会和我一样兴奋了。即刻开始体验函数式 **setState** 吧！

欢迎扩散，欢迎吐槽（[Twitter](https://twitter.com/Daajust)）。

Happy Coding！

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
