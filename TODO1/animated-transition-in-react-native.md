> * 原文地址：[Animated Transition in React Native!](https://medium.com/react-native-motion/transition-challenge-9bc9fdef56c7)
> * 原文作者：[Jiří Otáhal](https://medium.com/@xotahal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/animated-transition-in-react-native.md](https://github.com/xitu/gold-miner/blob/master/TODO1/animated-transition-in-react-native.md)
> * 译者：
> * 校对者：

# Animated Transition in React Native!

> This article has got almost 15k views. For someone it could be nothing, but for me it is a big motivation. That’s why I decided to build [Pineapple — Financial Manager](https://pineapplee.io/). During only 22 days, I have done [iOS version](https://itunes.apple.com/us/app/pineapple-financial-manager/id1369607032?ls=1&mt=8), [Android version](https://play.google.com/store/apps/details?id=com.pineapple.android) and [website presentation](https://pineapplee.io/), spent $300 and wrote a [couple of articles](https://medium.com/how-i-built-profitable-application-faster-than) about that. Can’t say how much I enjoyed this time. You should try it as well!

Recently I’ve tried to get an inspiration for a next animation challenge. And here we go — [created by Ivan Parfenov](https://medium.muz.li/ui-interactions-of-the-week-116-40eba84eb736). I was curious if I am able to do this transition effect with React Native. [**You can check out a result on my expo account**](https://expo.io/@xotahal/react-native-motion-example)**!** Why we even need the animations like these? Read [Good to great UI animation tips](https://uxdesign.cc/good-to-great-ui-animation-tips-7850805c12e5) by Pablo Stanley.

![](https://cdn-images-1.medium.com/max/800/1*D35P0J6_34Yrs_n3i1hvjA.gif)

For [PLΛTES](https://dribbble.com/plates) by [Ivan Parfenov](https://dribbble.com/parfenoff).

We can see there is a couple of animations. Toolbar tile (show/hide), bottom bar (show/hide), move a selected item, hide all others, show detail items and maybe even more.

![](https://cdn-images-1.medium.com/max/800/1*HdpUrmxtI0cptj8BpxsaPw.png)

Timeline of animations.

The hard thing about the transition is to synchronize all of those animations. We can’t really unmount the List Page and show the Detail Page because we need to wait till all animations are done. Also, I am a fan of having a clean code. Easy to maintenance. If you have ever tried to implement an animation to your project, the code usually gets messy. Full of helper variables, crazy calculations, etc. That’s why I would like to introduce [react-native-motion](https://github.com/xotahal/react-native-motion).

![](https://cdn-images-1.medium.com/max/800/1*nfm2A4bKidwuPQ-Oy4vTxQ.gif)

### An idea of react-native-motion

Can you see the animation of toolbar’s title? You just need to move the title a bit and animate an opacity to zero/one. No big deal! But because of that, you need to write a code like this. Even before you actually start to write UI for that component.

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

Now let’s take a look how we can use [react-native-motion](https://github.com/xotahal/react-native-motion) for this. I know the animations are quite often very specific. And I know React Native provides very powerful Animated API. Anyway, it would be great to have a library with basic animations.

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

### Shared element

The biggest problem of this challenge was moving of selected list item. The item that is shared between List Page and Detail Page. How to move the item from FlatList to the top of Detail’s Page when the element is actually not absolutely positioned? It is quite easy with react-native-motion.

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

We specified source element of the SharedElement on List Page. Now we need to do almost the same for destination element on the Detail Page. To know the position where we want to move the shared element.

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

### Where is the magic?

How can we move a relatively positioned element from one page to the another one? Actually, we can’t. The SharedElement works like this:

*   get a position of the source element
*   get position of the destination element (obviously, without this step the animation can’t be initiated)
*   create a clone of the shared element (The magic!)
*   render a new layer above the screen
*   render the cloned element that will cover the source element (in his position)
*   initiate move to the destination position
*   once the destination position was reached, remove the cloned element

![](https://cdn-images-1.medium.com/max/800/1*MKDiUHnLdB7WiEPR26IHdw.png)

You can probably imagine there are 3 elements of the same React Node at the same moment. That’s because List Page is covered up by Detail Page during that moving animation. That’s why we can see all 3 elements. But we want to create an illusion that we actually moving the original source item.

![](https://cdn-images-1.medium.com/max/1000/1*m11vVsxY3Pa_e5lDMkOT_w.png)

SharedElement timeline.

You can see point A and point B. That’s a time period when the moving is performing. You can also see the SharedElement fires some useful events. In this case, we use WillStart and DidFinish events. It is up to you to set an opacity for source and destination element to 0 when a moving to destination was initiated, and back to 1 for destination element once the animation was finished.

### What do you think?

There is still work on [react-native-motion](https://github.com/xotahal/react-native-motion). It is definitely not a final and stable version of this library. But it is a good start I hope :) I would love to hear what do you think about that!

> I am constantly looking for new challenges and opportunities. If you need a help with something, let me know, please ;) I will be happy to discuss it.

> [LinkedIn](https://www.linkedin.com/in/xotahal/) || [Github](https://github.com/xotahal) || [Twitter](https://twitter.com/xotahal) || [Facebook](https://www.facebook.com/jiri.otahal.96) || [500px](https://500px.com/xotahal)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
