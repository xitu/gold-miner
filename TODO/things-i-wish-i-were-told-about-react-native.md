> * 原文链接 : [Things I Wish I Were Told About React Native](http://ruoyusun.com/2015/11/01/things-i-wish-i-were-told-about-react-native.html)
* 原文作者 : [Ruoyu Sun](https://twitter.com/insraq)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

## No. 1 (Really) Read The Document

I list this as first one because it is the single most important time saver. After you really read the document, especially the [“Guide”](https://facebook.github.io/react-native/docs/style.html#content) section, you should already know most of the tips below. But I know people prefer to learn by doing these days - and that’s exactly what I have done. I have wasted hours and hours on some of the things below without reading the documents. So I hope this list can save you some time.

## No.2 Checkout and Run the Official UIExplorer Project

React Native documents does not have live examples (due to its nature) or screenshots of its UI Component and APIs. Therefore it could be a bit difficult to figure out what each Component does. That’s why React Native provides the useful [UIExplorer Project](https://github.com/facebook/react-native/tree/master/Examples/UIExplorer). It could truly save you lots of time guessing and poking around.

I have to admit, I have wasted lots of time porting my code from `NavigatorOS` to `Navigator` and back. Actually React Native has a pretty [detailed comparison](https://facebook.github.io/react-native/docs/navigator-comparison.html) of those two, which I did not read before I dive in. In short, NavigatorIOS has a slightly more native feel but is quite buggy, less supported and has limited API.

## No. 4 You Code Does Not Run on Node.JS

The JavaScript runtime you’ve got is ether JavaScriptCore (non-debug) or V8 (debug). Even though you can use NPM and a node server is running on the background, your code does not actually run on Node.JS. So you won’t be able to use of the Node.JS packages. A typical example is `jsonwebtoken`, which uses NodeJS’s crypto module.

## No. 5 Push Notification is Tricky

Push notification in React Native is tricky. It should work in 0.13, but you will need to set up your project in Xcode (Add Library, Add header files) etc. The official document is quite brief. In v0.12 or below, it does not even work on later iOS versions. You will need to do some patching. [This article](https://medium.com/@DannyvanderJagt/how-to-use-push-notifications-in-react-native-41e8b14aadae#.66tv809um) is incredibly useful.

## No.6 Static Images Only Works for PNG

This one is straightforward, but not so straightforward to figure out. It was not mentioned in the document [until recently](https://facebook.github.io/react-native/docs/image.html). It took me several hours.

The build in Modal Component is really intended for mix React Native into Native App. Therefore lots of components does not work well with `Modal`, like `PickerIOS` does not render.

## No. 7 Read Source Code

React Native is moving fast and documents (and this article) get outdated very soon. Lots of features (like [keyboard events](https://github.com/facebook/react-native/blob/master/React/Base/RCTKeyboardObserver.m), `EventEmitter` and `Subscribable`) are not event documented. By reading how React components are implemented, you can get a pretty good idea on how you should implement your own components.

## No.8 Learn Some Objective C

Sooner or later you will have to use Objective C. For any non-trivial apps, writing native modules and components are inevitable. At least you should feel comfortable reading Objective C. I know it looks overwhelming, but it’s not that difficult once you get used to the syntax.



