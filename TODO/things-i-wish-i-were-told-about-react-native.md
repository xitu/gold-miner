> * 原文链接 : [Things I Wish I Were Told About React Native](http://ruoyusun.com/2015/11/01/things-i-wish-i-were-told-about-react-native.html)
* 原文作者 : [Ruoyu Sun](https://twitter.com/insraq)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [void-main](https://github.com/void-main)
* 校对者:
* 状态 :  翻译完成

## 第一条 (说真的)阅读文档

我把这个列作第一条因为这是节省时间最重要的一条。当你读完了文档，尤其是["指导"](https://facebook.github.io/react-native/docs/style.html#content)这部分，你就应该已经了解了接下来要介绍的其它几点提示。但是我知道现在的开发者更倾向于通过实践来学习——我就是这么做的。由于没有阅读文档，我为了解决下面的几个问题浪费了大量的时间。因此我希望这个列表可以帮你节省一些时间。


## 第二条 获取并运行官方UIExplorer项目

React Native文档中既没有可以实时运行的例子(这是它的特性决定的)也没有UI组件的截图和API说明。因此想要弄清楚每个组件做什么可能有点困难。为此React Native提供了一个非常有用的[UIExplorer项目](https://github.com/facebook/react-native/tree/master/Examples/UIExplorer)。这个项目真的可以帮你节省很多猜测和尝试的时间。


## 第三条 选择合适的导航组件

我必须承认，我浪费了很多时间把我的代码在`NavigatorIOS`和`Navigator`之间来回迁移。实际上React Native关于这两者有非常[详尽的比较](https://facebook.github.io/react-native/docs/navigator-comparison.html)，然而我在使用之前并没有阅读。简而言之，NavigatorIOS虽然有更加原生的体验，但是却有很多bug，支持和可用的API也不是很多。

(注：原文是NavigatorOS，但是实际RN的组件是NavigatorIOS，应该是作者的typo)


## 第四条 你的代码不是运行在Node.JS上

你能使用的JavaScript运行时要么是JavaScriptCore(非调试模式)要么是V8(调试模式)。尽管你可以使用NPM，而且在后台确实有一个正在运行的node服务器，但是你的代码并不是运行在Node.JS上。因此你不能使用Node.JS包。一个典型的不能使用的例子是`jsonwebtoken`这个包，因为它依赖NodeJS提供的加密(crypto)模块。


## 第五条 推送通知有点麻烦

在React Native中使用推送通知有点麻烦。0.13版本应该可以正常工作了，但是你仍然需要在Xcode中配置你的项目 (引入类库，添加头文件) 等等。在这方面官方文档非常简略。在0.12或者更低版本中，推送通知甚至不能在iOS 8或者更新版本中使用。你需要手动打些补丁。[这篇文章](https://medium.com/@DannyvanderJagt/how-to-use-push-notifications-in-react-native-41e8b14aadae#.66tv809um)非常有帮助。

（注：作者只提到更新的操作iOS版本，太含糊。通过查阅他提到的那篇文章可以了解在iOS 8或者更高版本中无法使用）


## 第六条 静态图片只能使用PNG格式

这一条很简单明了，但是想要发现这一点并不那么容易。[直到最近](https://facebook.github.io/react-native/docs/image.html)官方文档才提到这一点。我花费了几个小时才发现。

模式(Modal)组件是为在原生App中使用React Native的组件设计的。因此许多组件在`Modal`组件中表现都有问题，例如`PickerIOS`就不会渲染。

（注：这里说的原生App是指那种希望混用原生与React Native的应用）


## 第七条 阅读代码

React Native的发展非常迅速，导致许多文档（包括这篇文章）很快都会失效。很多特性(例如[键盘事件](https://github.com/facebook/react-native/blob/master/React/Base/RCTKeyboardObserver.m)，`EventEmitter`和`Subscribable`)根本没有说明。通过阅读这些React组件是如何实现的，你可以更好的实现你自己的组件。


## 第八条 学一些Objective C

总有一天你会需要写Objective C的代码。对于稍微复杂一点的应用来说，写原生模块与组件都是不可避免的。至少你应该能顺利的阅读Objective C代码。我知道这看起来很困难，但是当你适应了这种语法之后会发现其实没有这么困难。
