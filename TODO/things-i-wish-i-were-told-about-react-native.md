> * 原文链接 : [Things I Wish I Were Told About React Native](http://ruoyusun.com/2015/11/01/things-i-wish-i-were-told-about-react-native.html)
* 原文作者 : [Ruoyu Sun](https://twitter.com/insraq)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo) 
* 校对者: [Void Main](https://github.com/void-main)  [aleen42](https://github.com/aleen42) 
* 状态 :  翻译结束

## No. 1 读文档（一定要读）
  1   我之所以把它列在第一位是因为这真的是最节省时间的一条。等你真正读了文档，尤其是["指导"](https://facebook.github.io/react-native/docs/style.html#content)这节，那么我相信你应该会对下面的大部分建议有所了解。但人们更愿意通过实践学习而不是读文档-我之前也是这样做的。我浪费的大把的时间在下面的事情上，而不是读文档。因此我希望这篇文章可以节约你不少的时间。

## No. 2 检出并运行 UIExplorer  项目

  React Native 文档没有快速演示（由于框架本生原因）或者是 UI 组件和 API 的截图。因此弄清楚每个组件具体的样子和功能有些困难。这就是他们为什么提供了这个非常有用的 [UIExplorer Project](https://github.com/facebook/react-native/tree/master/Examples/UIExplorer)项目。它真的可以节省你很多猜测和尝试的时间。

## NO. 3 选择合适的导航组件

  我不得不承认我浪费了大量的时间在把我的代码从`NavigatorOS` 和  `Navigator` 之间来回切换 。事实React Native 提供了相当 [ 详细的对比](https://facebook.github.io/react-native/docs/navigator-comparison.html) ,当然在我把时间浪费之前我也没读过它。简而言之就是 NavigatorOS 更像原生的组件，但提供了有限的 API 并且 bug 比较多。

## No. 4 你的代码不是运行在 nodejs 上的

  你的 javascript 运行时要么是 JavaScriptCore（不支持 dubug） 要么是 V8 （可以 dbug）。尽管，你使用 NPM 并且有一个 node 服务 在后台运行，但你的代码并不是真正运行在 nodejs 上的。因此是不可以使用 NodeJs 包的。一个典型的例子就是`jsonwebtoken`，它用了 NodeJs 的 crypto 模块。

## No. 5 推送通知很不靠谱

  在 React Native 中推送通知很不靠谱。这项特性是在 0.13 版上是能有效使用的，但你得在你的 Xcode 工程中配置好你的项目（添加库，添加头文件等等）。官方文档相当简要。在 0.12 版或者之前的版本中甚至对后来的 IOS  版本不支持。你需要自己打补丁来实现。这篇[文章](https://medium.com/@DannyvanderJagt/how-to-use-push-notifications-in-react-native-41e8b14aadae#.66tv809um)相当有用。

## No. 6 静态图片暂时只支持 PNG 格式
	
	这样的要求是简单易懂的，但想要明白个中缘由，绝非易事。直到最近的[文档](https://facebook.github.io/react-native/docs/image.html)中才提及这点。浪费了我好多时间。
  
  Modal 构件是专门为混合 React Native 框架和 Native 应用而度身定做的。因此，很多 React Native 框架下的构件都不能与Modal兼容使用。PickerIOS无法渲染的问题。

## No. 7 读源码

  React Native 发展的很快,以至于文档过（包括这篇文章）很快就失去参考价值了。许多的特性（比如[键盘事件](https://github.com/facebook/react-native/blob/master/React/Base/RCTKeyboardObserver.m),`EventEmitter`以及`Subscribable`) 都没有写在文档里。因此，为了更清楚如何完成属于自己的构件，你必须事先通过阅读源码来了解 React 是怎样实现的。
## No. 8 学习Objective C

  迟早你会用到 Objective C 的。对于任何优秀的app，写原生模块和组件都是不可避免的。因此，至少你得能读懂 Objective C 代码。我知道这可能有些吓人，但一旦你习惯了它的语法就好了。


