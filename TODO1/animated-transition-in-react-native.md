> * 原文地址：[Animated Transition in React Native!](https://medium.com/react-native-motion/transition-challenge-9bc9fdef56c7)
> * 原文作者：[Jiří Otáhal](https://medium.com/@xotahal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/animated-transition-in-react-native.md](https://github.com/xitu/gold-miner/blob/master/TODO1/animated-transition-in-react-native.md)
> * 译者：[talisk](https://github.com/talisk)
> * 校对者：

# React Native 中使用转场动画！

> 这篇文章有近 15k 的浏览量。对某些人来说，这可能没什么的，但对我来说是一个很大的动力。这正是我决定构建 [Pineapple — Financial Manager](https://pineapplee.io/) 的原因。仅仅 20 天，我已经完成了 [iOS 版](https://itunes.apple.com/us/app/pineapple-financial-manager/id1369607032?ls=1&mt=8)，[Android 版](https://play.google.com/store/apps/details?id=com.pineapple.android)以及[网页版](https://pineapplee.io/)，花费 300 美金，并写了[几篇关于它的文章](https://medium.com/how-i-built-profitable-application-faster-than)。我无法用言语表达我多么享受这段时间。你也应该试试！

最近我试图为下一个动画挑战获得灵感。我们开始吧 —— [由 Ivan Parfenov 创建](https://medium.muz.li/ui-interactions-of-the-week-116-40eba84eb736)。如果我能用React Native做这个过渡效果，我很好奇。[**您可以在我的 expo 帐户中查看结果**](https://expo.io/@xotahal/react-native-motion-example)！为什么我们还需要这样的动画？来读读 Pablo Stanley 写的[绝佳的 UI 动画技巧](https://uxdesign.cc/good-to-great-ui-animation-tips-7850805c12e5)。

![](https://cdn-images-1.medium.com/max/800/1*D35P0J6_34Yrs_n3i1hvjA.gif)

[Ivan Parfenov](https://dribbble.com/parfenoff) 设计的 [PLΛTES](https://dribbble.com/plates)。

我们可以看到有几个动画。工具栏（显示/隐藏），底栏（显示/隐藏），移动所选项目，隐藏所有其他项目，显示详细信息项目甚至更多。

![](https://cdn-images-1.medium.com/max/800/1*HdpUrmxtI0cptj8BpxsaPw.png)

动画时间线

过渡动画的难点在于同步所有这些动画。因为我们需要等到所有动画都完成，我们无法真正移除列表页面并显示详细信息页面。此外，我对整洁的代码有所追求。代码要易于维护，如果您曾尝试为项目实现动画，则代码通常会变得混乱。到处都是辅助变量，各种计算等。这正是我想介绍 [react-native-motion](https://github.com/xotahal/react-native-motion) 的原因。

![](https://cdn-images-1.medium.com/max/800/1*nfm2A4bKidwuPQ-Oy4vTxQ.gif)

### 对 react-native-motion 的一个小想法

你能看到工具栏标题的动画吗？你只需稍微移动标题并将不透明度设置为 0 或 1。这很简单！但正因为如此，你需要编写这样的代码，甚至在你真正开始为该组件编写 UI 之前。

```
class TranslateYAndOpacity extends PureComponent {
  constructor(props) {
    // ...
    this.state = {
      opacityValue: new Animated.Value(opacityMin),
      translateYValue: new Animated.Value(translateYMin),
    };
    // ...
  }
  componentDidMount() {
    // ...
    this.show(this.props);
    // ...
  }
  componentWillReceiveProps(nextProps) {
    if (!this.props.isHidden && nextProps.isHidden) {
      this.hide(nextProps);
    }
    if (this.props.isHidden && !nextProps.isHidden) {
      this.show(nextProps);
    }
  }
  show(props) {
    // ...
    Animated.parallel([
      Animated.timing(opacityValue, { /* ... */ }),
      Animated.timing(translateYValue, { /*  ... */ }),
    ]).start();
  }
  hide(props) {
    // ...
    Animated.parallel([
      Animated.timing(opacityValue, { /* ... */ }),
      Animated.timing(translateYValue, { /*  ... */ }),
    ]).start();
  }
  render() {
    const { opacityValue, translateYValue } = this.state;

    const animatedStyle = {
      opacity: opacityValue,
      transform: [{ translateY: translateYValue }],
    };

    return (
      <Animated.View style={animatedStyle}>{this.props.children}</Animated.View>
    );
  }
}
```

现在让我们来看看如果用 [react-native-motion](https://github.com/xotahal/react-native-motion) 实现这个动画，要怎么做。我知道动画经常是非常具体的。我知道 React Native 提供了非常强大的动画 API。无论如何，拥有一个带有基本动画的库会很棒。

```
import { TranslateYAndOpacity } from 'react-native-motion';

class ToolbarTitle extends PureComponent {
  render() {
    return (
      <TranslateYAndOpacity duration={250}>
        <View>
          // ...
        </View>
      </TranslateYAndOpacity>
    );
  }
}
```

### 共享的元素

这一挑战的最大问题是移动选定的列表项。列表页面和详细信息页面之间共享的项目。当元素实际上没有绝对定位时，如何将项目从 FlatList 移动到 Detail 的页面顶部？使用 react-native-motion 非常容易。

```
// List items page with source of SharedElement
import { SharedElement } from 'react-native-motion';

class ListPage extends Component {
  render() {
    return (
      <SharedElement id="source">
        <View>{listItemNode}</View>
      </SharedElement>
    );
  }
}
```

我们在 ListPage 上指定了 SharedElement 的 source 元素。现在我们需要对 DetailPage 上的目标元素执行几乎相同的操作，来知道我们想要移动共享元素的位置。

```
// Detail page with a destination shared element
import { SharedElement } from 'react-native-motion';

class DetailPage extends Component {
  render() {
    return (
      <SharedElement sourceId="source">
        <View>{listItemNode}</View>
      </SharedElement>
    );
  }
}
```

### 黑科技在哪里？

我们如何将相对定位的元素从一个页面移动到另一个页面？实际上我们做不到。SharedElement 的工作方式如下：

*   获取源 element 的位置
*   获取目标 element 的位置（显然，没有这一步，动画不能被初始化）
*   创建共享的 element（黑科技！）
*   在屏幕上方渲染一个新图层
*   渲染 element 元素，将覆盖源 element（在源 element 的位置上）
*   开始移动到目标 element 位置
*   一旦移动到目标 element 位置后，删除克隆 element

![](https://cdn-images-1.medium.com/max/800/1*MKDiUHnLdB7WiEPR26IHdw.png)

你可以想象在同一时刻同一个 React Node 有 3 个 element。这是因为在移动动画期间，DetailPage 会覆盖列表页面。这就是为什么我们可以看到所有3个元素。但是我们想要创造一种我们实际移动了原始 element 的幻觉。

![](https://cdn-images-1.medium.com/max/1000/1*m11vVsxY3Pa_e5lDMkOT_w.png)

SharedElement 的时间线。

您可以看到 A 点和 B 点。这是移动正在执行的时间段。您还可以看到 SharedElement 触发一些有用的事件。在这种情况下，我们使用 WillStart 和 DidFinish 事件。在启动移动目标 element 时，将源 element 和目标 element 的不透明度设置为 0，并在动画完成后将目标 element 的不透明度设置为 1。

### 你觉得怎么样？

社区这里一直不断在维护和更新：[react-native-motion](https://github.com/xotahal/react-native-motion)。这绝不是这个库的最终和稳定版本。但是一个好的开始 :) 我很想听听你怎么想！

> 我一直在寻找新的挑战和机会。如果您需要帮助，请告诉我，我很乐意讨论它。

> [LinkedIn](https://www.linkedin.com/in/xotahal/) || [Github](https://github.com/xotahal) || [Twitter](https://twitter.com/xotahal) || [Facebook](https://www.facebook.com/jiri.otahal.96) || [500px](https://500px.com/xotahal)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
