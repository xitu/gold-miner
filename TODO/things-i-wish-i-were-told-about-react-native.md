> * 原文链接 : [Things I Wish I Were Told About React Native](http://ruoyusun.com/2015/11/01/things-i-wish-i-were-told-about-react-native.html)
* 原文作者 : [Ruoyu Sun](https://twitter.com/insraq)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo) 
* 校对者: 
* 状态 :  翻译结束

## No. 1 读文档（一定要读）
  1   我之所以把它列在第一位是因为这真的是最节省时间的一条。等你真正读了文档，尤其是["指导"](https://facebook.github.io/react-native/docs/style.html#content)这节，读完后你就知道下面 tips 中的绝大部分了。但人们更喜欢在接下来的时间里读-这也是我之前做的。我浪费的大把的时间在下面的事情上，而不是读文档。因此我希望我的列表可以节约你的时间。

## No. 2 查看并运行 UIExplorer  项目

  React Native 文档没有快速演示（由于语言天生原因）或者是 UI 组件和 API 的截图。因此弄清楚每个组件的样子有些困难。这就是他们为什么提供了这个非常有用的 [UIExplorer Project](https://github.com/facebook/react-native/tree/master/Examples/UIExplorer)项目。它真的可以节省你很多猜测和尝试的时间。

  我不得不承认我浪费了大量的时间在把我的代码从`NavigatorOS` 转向 `Navigator` 。事实React Native 提供了相当 [ 详细的对比](https://facebook.github.io/react-native/docs/navigator-comparison.html) ,当然在我把时间浪费之前我也没读过它。一句话来说就是 NavigatorIOS 更像原生的组件，但提供了有限的 API 并且 bug 比较多。

## No. 3 你的代码不是运行在 nodejs 上的

  你的 javascript 要么是 JavaScriptCore（不支持 dubug） 要么是 V8 （可以 dbug）。尽管你用 NPM 并且 node server 在后台运行，你的代码并不是真正运行在 nodejs 上的。因此是不可以使用 NodeJs 包的。一个典型的例子就是`jsonwebtoken`，它用了 NodeJs 的加密模块。

## No. 4 推送通知很不靠谱

  在 React Native 中推送通知很不靠谱。这项特性是在 0.13 版上可以使用的，但你得在你的 Xcode 工程中设置（添加库，添加头文件等等）。官方文档相当简明。在 0.12 版或者之前的版本中甚至对后来的 IOS  版本不支持。你需要自己打补丁。这篇[文章](https://medium.com/@DannyvanderJagt/how-to-use-push-notifications-in-react-n    ative-41e8b14aadae#.66tv809um)相当有用。

## No. 5 静态图片只有 PNG 可以用 
  这条建议很直白，但不是那么简单弄懂的。直到最近的[文档](https://facebook.github.io/react-native/docs/image.html)中才提及这点。浪费了我好多时间。
  
  这个模块组件是真的打算把 React Native 混合到 Navive App 中。因此很多组件在 `Modal` 上不是很好 用，比如 `PickerIOS` 不渲染。

## No. 6 读源码

  React Native 发展的很快而且文档过期的很快（包括这篇文章）。许多的特性（比如[键盘事件](https://github.com/facebook/react-native/blob/master/React/Base/RCTKeyboardObserver.m),`EventEmitter`以>及`Subscribable`) 都没有写在文档里。读 React 组件的实现方式，你可以很清楚的明白你该怎样实现你自己的组件。
## No. 7学习Objective C

  迟早你会用到 Objective C 的。对于任何优秀的app，写原生模块和组件都是不可避免的。至少你得能读懂 Objective C 代码。我知道这可能有些吓人，但一旦你习惯了它的语法就好了。



