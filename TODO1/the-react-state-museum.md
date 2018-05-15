> * 原文地址：[⚛ The React State Museum: ⚡️View the hottest state management libs for React](https://hackernoon.com/the-react-state-museum-a278c726315)
> * 原文作者：[Gant Laborde](https://hackernoon.com/@gantlaborde?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-react-state-museum.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-react-state-museum.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：

# ⚛ React 状态管理工具博物馆

## ⚡️最热门的 React 状态管理库了解一下

![](https://cdn-images-1.medium.com/max/1000/1*PhVcG3Re-i8ejmhsD6ULRg.png)

### 为什么？

这篇文章是了解复杂的状态管理系统的罗塞塔石碑（关键所在）。一个打包列表应用中使用的状态管理库基本如下：

*   **setState**
*   **React 16.x Context**
*   **Redux — by** [**Dan Abramov**](https://medium.com/@dan_abramov)
*   **MobX — by** [**Michel Weststrate**](https://medium.com/@mweststrate)
*   **unstated — by** [**Jamie Kyle**](https://medium.com/@thejameskyle)
*   **MobX-State-Tree — by** [**Michel Weststrate**](https://medium.com/@mweststrate) **again**
*   **Apollo GraphQL with Amazon AppSync**
*   **setState + react-automata — by** [**Michele Bertoli**](https://medium.com/@michelebertoli)
*   **Freactal — by Dale while at** [**Formidable**](https://medium.com/@FormidableLabs)
*   **ReduxX — by** [**Mikey Stecky-Efantis**](https://medium.com/@mikeysteckyefantis)

当然，你可能对上面的某些库很熟悉，现在你可用你熟悉的那些库的知识来更好地理解其它库。你有机会来看看这些库的细节，还有这些库是多么的相似。

为了通熟易懂地说明这些库，我使用了一个简单的打包列表应用，只有**添加**和**清空**功能。

![](https://cdn-images-1.medium.com/max/800/1*iQNRn15HETzdjALJITCFsQ.gif)

很容易获取到应用 (Native 和 Web 都已实现)。

为了说明状态如何传递的，所有的示例中，添加/清空功能是一个组件，列表功能是另一个组件。

两个主要的组件（添加/列表）被抽象为一个需要导入的库，只留下基本代码来强调状态的选择。代码力求简约。

### 欢迎来到 React 状态管理工具博物馆！

使用每个状态库实现的 React 和 React Native 应用的源码都可以在下面的仓库中找到。

![](https://cdn-images-1.medium.com/max/800/1*jNZ4p0HGFML_ziNS0BPErA.png)

> [https://github.com/GantMan/ReactStateMuseum](https://github.com/GantMan/ReactStateMuseum)

使用上面的仓库亲自进入这些状态库中查看它们吧！🔥

* * *

### 每种解决方案的个人笔记：

如果你想看代码，查看 GitHub 源码，如果你需要建议，请继续阅读下面这段很长的描述。

这里我们会探讨博物馆中每个状态库的差异，正式这些差异让每个都与众不同。如果你有好的建议或经验，请在评论中与大家分享。我也有兴趣把这篇文章当作充满乐趣的会议进行讨论。


#### setState

这是状态管理最基础的结构，仅基于对组件及其封装的理解。很多方面，这对 React 初学者来说是一个很好的例子。显示地将状态提升到所有组件都是其子组件的根组件中，其中定义了 props 与 state 的关系。随着应用的增长，显示连接到组件中的代码越来越复杂、脆弱，这就是不经常使用这种方法的原因。

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/setState) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/setState)

#### React Context

[https://reactjs.org/docs/context.html](https://reactjs.org/docs/context.html)

关于 Context 的更新引发了很多关注。实际上，在 16.x 的版本中 Context 的最终形态有点像状态管理系统本身。为了简单起见，context 设置了 **provider** 和 **consumer**。一个 provider 的所有子组件都可以访问应用给它的值。所有非子组件都会看到它的默认值。下图解释了这种关系。

![](https://cdn-images-1.medium.com/max/800/1*6mJlcm3Ra5PHXwCEnHeTJQ.png)

只有子组件才能继承。

另一个非常重要的观点，我不是消费语法结构的粉丝。很明显，这种关系主要体现为 Consumer 中的函数，但这好像违背了 JSX 同时使用多个大括号的用法。

```
      <PackingContext.Consumer>
        {({newItemName, addItem, setNewItemName, clear}) => (
          <AddPackingItem
            addItem={addItem}
            setNewItemText={setNewItemName}
            value={newItemName}
            clear={clear}
          />
        )}
      </PackingContext.Consumer>
```

一个迂腐的问题，但代码的可读性应该总是考虑到 API，在这方面，Context 有点不整洁。

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/context) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Context)

#### Redux

[https://github.com/reactjs/react-redux](https://github.com/reactjs/react-redux)

在写这篇文章的时候，我敢说 Redux 是最受欢迎的状态管理工具，因此受到的攻击也最多。使用 Redux 编写解决方案需要很多文件，代码行数变为两倍。但 Redux 也有优点，它简单而灵活。

如果你不熟悉 Redux，这是一种状态管理的方法，它以 reducer 函数的形式提供时间旅行和状态清理功能。Dan Abramov 的讲解 redux 的视频已经被观看过**很多**次。

* YouTube 视频链接：https://youtu.be/xsSnOQynTHs

简而言之，就像有人在你的应用中发出命令（Actions），这些命令是通过Action Creators 创建出来的。你的应用中的数据管理器（Reducers）可以听到这些留言，并可以选择对其进行操作。我喜欢我的海盗船比喻，所以大声喊叫『有人落水』可以告诉你的船员们如果反驳，就会少一位一名工作人员，会计师重新分配宝藏，擦拭甲板的人可以忽略它，因为他不在乎。

我喜欢这个比喻，因为『大声呼喊』是管理应用每个角落的一种强大方式，特别是大型复杂应用。结合这种方式无法处理异步并且需要粘在一个不可变结构上才能全部工作，Redux 是逐个开发的开发者的朋友。

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/redux) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Redux)

#### MobX

[https://github.com/mobxjs/mobx-react](https://github.com/mobxjs/mobx-react)

MobX 是上手最简单的状态管理库之一。查看它的 README 文件，然后按照步骤进行操作，马上就可以运行了。这感觉像是可变的 JavaScript，在某种程度上确实是。唯一可能会让你感到迷惑的是在类上使用的像 `@observer` 这些修饰器函数。虽然这种写法有点奇怪，但会让代码更简洁。

> 如果你使用过 redux 的东西，@observer 就像把 `mapStateToProps` 方法和 `reselect` 方法自动组合一样 — [Steve Kellock](https://medium.com/@skellock)

如果想了解更多关于切换到 MobX 的进阶话题，请查看下面 Nader 的文章。

* [**使用 MobX 替换 setState - Nader Dabit - Medium**：在 2017 年底，我在一个使用 MobX 作为状态管理库的团队开发了一个 React Native 项目。](https://medium.com/@dabit3/766c165e4578)

总之，MobX 是最小、最简单的工具之一！

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/mobx) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/MobX)

#### Unstated

[https://github.com/jamiebuilds/unstated](https://github.com/jamiebuilds/unstated)

Unstated 这个库和 MobX 一样简单。和 MobX 一样，这个感觉也是可变的 JavaScript，看上去使用 Unstated 需要添加更多的 React 代码。我觉得实际上 Unstated 比 Context 更像是 React。

使用起来很简单，创建一个 container 组件，就在这个组件内部管理状态。像 `setState` 这样简单的已知函数已将内置在这个状态容器中了。这不仅是一个贴切的名字；还是一个基于 React 的状态管理工具。

![](https://cdn-images-1.medium.com/max/800/1*sRBWrKW_51SILd_CQhy1Aw.png)

我不清楚它如何扩展或处理中间件等。然如果你是状态管理的初学者，MobX  和 Unstated 都是起步最简单的选择！

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/unstated) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Unstated)

#### MobX-State-Tree

[https://github.com/mobxjs/mobx-state-tree](https://github.com/mobxjs/mobx-state-tree)

是的，这个库经常会被人误会和 MobX 有什么关系，其实它们俩非常不同。

![](https://i.loli.net/2018/05/09/5af255441b56f.png)

甚至我的同事也将它的名字缩短为 MobX，我总是推动 MST 作为一种替代方案。正因为如此，重要的是 MobX-State-Tree 这个库集合了 Redux、reselect 和异步管理的所有优点，而且使用的代码量更小。

在这个示例中，最明显的一个优点就是简洁的语法。代码行数几乎比最初的 MobX 的示例更多了。两者都使用了简洁的修饰器语法。虽然需要一点时间才能真正从 MobX-State-Tree 中获得所有好处。

最重要的一点就是如果你使用过 ActiveRecord 或者其它类型的 ORM，MobX-State-Tree 就像一个具有规范化关系干净的数据模型。对于可扩展的应用来说，这是一个非常好的状态管理工具。

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/mobx-state-tree) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/MobXStateTree)

#### **Apollo GraphQL and Amazon AppSync**

[https://github.com/apollographql/react-apollo](https://github.com/apollographql/react-apollo)
[https://aws.amazon.com/appsync/](https://aws.amazon.com/appsync/)

如果你没赶上 GraphQL 这趟列车，那你就落伍了。Apollo GraphQL + AppSync 是管理应用状态、离线处理、请求 API、配置 GraphQL 服务器的一种很好的解决方案。许多人预测 GraphQL 会结束关于状态管理工具的争论。从某些角度看这很容易，但从另个角度来说也很难。

并不是所有人都准备好使用 GraphQL 服务器了，但如果你准备好了，那么 AppSync 是处理 DynamoDB 中数据一种最简单的方式。这可能需要花费更多的时间和精力才能完成并运行，但优势也是显而易见的。

在我的示例中，我并没真正使用那些花哨的功能。你可以看到在等待服务器数据的延迟，我也没有使用订阅功能来获取更新。这个示例可以变得更好。但使用起来足够简单。哇！REST 已经成为了历史。

**特别说明：**请注意本例中你输入的内容，因为它们是共享的。

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/appsync) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/AppSync)

#### setState + react-automata

[https://github.com/MicheleBertoli/react-automata](https://github.com/MicheleBertoli/react-automata)

这个库在这几个中比较陌生。很多时候，你都想知道 setState 是如何使用的，答案非常简单。将状态分解为状态机的做法和大多数状态管理库都不同。

通过创建一个 [xstate](https://github.com/davidkpiano/xstate) 的状态机配置，定义状态如何转换、调用和识别。因此，你必须定义出应用中用到的所有状态，还有从一种状态转换到另一种状态的所有方式。就像在 Redux 中触发一个 action，你需要在一个特定的事件上使用 `transition` 来切换到另一个状态。

它并不是一个完整的状态管理工具；仅仅是一个作为你状态管理的状态机。

[这是我们创建状态图](https://musing-rosalind-2ce8e7.netlify.com/?machine=%7B%22initial%22%3A%22idle%22%2C%22states%22%3A%7B%22idle%22%3A%7B%22on%22%3A%7B%22CLEAR%22%3A%7B%22idle%22%3A%7B%22actions%22%3A%5B%22clear%22%5D%7D%7D%2C%22SET_NEW_ITEM_NAME%22%3A%7B%22loaded%22%3A%7B%22actions%22%3A%5B%22setNewItemName%22%5D%7D%7D%7D%7D%2C%22loaded%22%3A%7B%22on%22%3A%7B%22ADD_ITEM%22%3A%7B%22idle%22%3A%7B%22actions%22%3A%5B%22addItem%22%5D%7D%7D%2C%22CLEAR%22%3A%7B%22loaded%22%3A%7B%22actions%22%3A%5B%22clear%22%5D%7D%7D%2C%22SET_NEW_ITEM_NAME%22%3A%7B%22loaded%22%3A%7B%22actions%22%3A%5B%22setNewItemName%22%5D%7D%2C%22idle%22%3A%7B%22actions%22%3A%5B%22setNewItemName%22%5D%7D%7D%7D%7D%7D%7D)

![](https://cdn-images-1.medium.com/max/800/1*cUt6fM6NwrKzjPypisJuMA.png)

使用状态图的好处令人兴奋。首先，你可以避免不想要的转换。例如，不输入内容就无法转换到 loaded 状态。这样可以避免在我们的列表中增加空白项。

其次，所有的状态转换都可以自动生成和测试。通过一条简单的命令，就可以生成多个状态的快照。

```
import { testStatechart } from 'react-automata'
import { App } from '../App'
import statechart from '../Statecharts/index'

test('all state snapshots', () => {
  // 这个函数会生成对所有状态的测试
  testStatechart({ statechart }, App)
})
```

**注意**：在 React Native 项目中，我不得不使用 `yarn add path` 来导入一些未使用的依赖项。这仅是 native 中一个比较诡异的问题。

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/react-automata) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/ReactAutomata)

#### Freactal

[https://github.com/FormidableLabs/freactal/](https://github.com/FormidableLabs/freactal/)

当然，我们将会展示 Formidable 实验室这个很棒的作品。Freactal 是一个非常先进的库，它可以替代 `[redux](https://redux.js.org/)`、`[MobX](https://mobx.js.org/)`、`[reselect](https://github.com/reactjs/reselect)`、 `[redux-loop](https://github.com/redux-loop/redux-loop)`、`[redux-thunk](https://github.com/gaearon/redux-thunk)`、`[redux-saga](https://github.com/redux-saga/redux-saga)` 等这些库了。

虽然对我来说这是上手最难的一个库了，但我仍然认为它有很大的价值。（译注：这个库中）添加更多的示例将会更有帮助。特别感谢 [Ken Wheeler](https://medium.com/@ken_wheeler)，他回答了我在阅读这个库文档过程中遇到的各种问题。

最终的代码简洁明了。使用到最后感觉有点像 Context 的语法。我特别喜欢使用自己的命名空间来区分 `effects`、`state` 和 `computer`，你也可以在其它库中使用这个约定。

```
import React from 'react'
import { AddPackingItem } from 'packlist-components/native'
import { injectState } from 'freactal'

export const AddItems = ({ state, effects }) => (
  <AddPackingItem
    addItem={effects.addItem}
    setNewItemText={effects.setNewItemName}
    value={state.newItemName}
    clear={effects.clear}
  />
)

export default injectState(AddItems)
```

> 源码：[React](https://github.com/GantMan/ReactStateMuseum/tree/master/React/freactal) | [React Native](https://github.com/GantMan/ReactStateMuseum/tree/master/ReactNative/Freactal)

#### ReduxX

[https://github.com/msteckyefantis/reduxx](https://github.com/msteckyefantis/reduxx)

ReduxX，虽然在搜索引擎优化中有一些麻烦，但仍然是一个非常酷的名字。

> 为什么在某个名字的后面加上 X 就会很酷呢？
> — Gant X（[jonjia X](https://github.com/jonjia) 注：作者名字是 Gant Laborde）

ReduxX 读起来相当不错，因为在某些方面它会让我想起来自 Unstated 的优雅，因为我们还在使用 **React 式**冗长的设置和改变状态的代码。看起来比较陌生的一点是，通过 `getState` 这个函数检索状态。这感觉有点像钥匙串访问，我想知道是否能在其中加入一些证书加密的东西？引人深思啊。果然我看到了 `obscureStateKeys: true`，这个选项可以将键名转化为唯一标识符。这个库在安全方面有一定优点。

至于如何使用它，可以通过键名设置获取状态。就是这样简单！如果你不需要关心中间件，并且熟悉 keychain 全局变量，你就已经掌握了 ReduxX。

**特别感谢这个库的作者 [Mikey Stecky-Efantis](https://medium.com/@mikeysteckyefantis) 能提供这个示例！**

#### pure-store

[https://github.com/gunn/pure-store](https://github.com/gunn/pure-store)

100% 的测试覆盖率，使用 MIT 证书，支持 TypeScript 的最小的状态管理库。这个库感觉最接近『只使用全局变量』。但实际上有一个问题
，如果你确定 `update` 方法接受 `setState` 的签名的话，那就只有一个全局的状态了。

**特别感谢 Arthur Gunn 对这个示例的贡献！**

### 那些错过的工具库？

我知道肯定还有其它的状态管理库在这里并没有提到，如果你知道它们，可以在这个项目的仓库中提交 PR。我非常乐于接受这些建议，这样我们都可以受益。如果有新的库加入，我也会更新这篇文章。所以，请收好你的门票，要提交贡献哦！博物馆欢迎你的到来！😆

### 总结：

**你不想安装其它依赖项吗？**

使用 setState 和 Context 可以获得相当棒的效果！为什么要引入依赖关系呢？如果你不确定你的应用是否需要它，那就尝试不使用外部库。你也可以把 Context 和像 react-automata 这样简单的库结合起来使用，就会得到一份简洁、可测试的代码！

**你想代码尽量简洁吗？**

Unstated、reduxX 和 pure-state 都非常简洁。它们有点不同，有点也不太一样。MobX 也很容易，但你要接受修饰器的语法。如果你可以接受，代码会更加可读、优化，文档和 stackoverflow 上的资源也很有帮助。

**你想要更好的扩张性吗？**

如果确定你的应用需要添加很多东西，是时候拿出真正的武器了。这就是 Redux 的用武之地。如果你使用了 Redux，那么你的技能就得到了锻炼，你知道你可以的。MobX-State-Tree 展现出了结合 MobX、选项、状态、优化等所有的能力。这并不是一次就能全部理解的内容，但每次你学到新的知识时，你就会使你的应用更加强大。

**你想拥抱未来吗？**

毫无疑问，GraphQL 正在技术领域引起轰动。现在，如果使用 AppSync  进行网络请求，或者只是使用 apollo-link-state 来管理本地数据，那么就放弃了一些对细节的控制，但获得了回报。请密切关注上面这些库的发展。很可能上面的许多状态管理库在不久的将来不得不适配 GraphQL。

* * *

![](https://cdn-images-1.medium.com/max/800/1*kePT6qGxTucg__Uz9IC_mQ.png)

[Gant Laborde](https://medium.com/@gantlaborde) 是 [Infinite Red](http://infinite.red)公司首席技术战略师、作家、兼职教授、全球公开演讲者和培训中的科学家。想了解更多，可以访问 [他的网站](http://gantlaborde.com/)。

#### 致谢

* 头图致谢：[https://unsplash.com/photos/uqMBLm8bAdA](https://unsplash.com/photos/uqMBLm8bAdA)

感谢 [Frank von Hoven](https://medium.com/@frankvonhoven?source=post_page) 和 [Derek Greenberg](https://medium.com/@derek_39555?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
