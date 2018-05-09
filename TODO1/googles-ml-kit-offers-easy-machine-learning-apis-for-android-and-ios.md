> * 原文地址：[Google’s ML Kit offers easy machine learning APIs for Android and iOS](https://arstechnica.com/gadgets/2018/05/googles-ml-kit-offers-easy-machine-learning-apis-for-android-and-ios/)
> * 原文作者：[RON AMADEO](https://arstechnica.com/author/ronamadeo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/googles-ml-kit-offers-easy-machine-learning-apis-for-android-and-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/googles-ml-kit-offers-easy-machine-learning-apis-for-android-and-ios.md)
> * 译者：
> * 校对者：

# Google’s ML Kit offers easy machine learning APIs for Android and iOS

Mere mortals can add machine learning features to their apps with a simple API call.

![](https://cdn.arstechnica.net/wp-content/uploads/2018/05/social-1-800x400.png)

MOUNTAIN VIEW, CALIF.—Google is launching a new SDK for machine learning for its Firebase developer platform called "ML Kit." The new SDK offers ready-to-use APIs for some of the most common computer-vision use cases, allowing developers that aren't machine learning experts to still add some ML magic to their apps. This isn't just an Android SDK; it works on iOS apps, too.

Typically, setting up a machine learning environment is a ton of work. You'd have to learn how to use a machine learning library like TensorFlow, acquire a ton of training data to teach your neutral net to do something, and at the end of the day you need it to spit out a model that is light enough to run on a mobile device. ML Kit simplifies all of this by just making certain machine learning features an API call on Google's Firebase platform.

![](https://cdn.arstechnica.net/wp-content/uploads/2018/05/Introducing_ML_Kit_Embarg-001-980x628.jpg)

The new APIs support text recognition, face detection, bar code scanning, image labeling, and landmark recognition. There are two versions of each API: a cloud-based version offers higher accuracy in exchange for using some data, and an on-device version works even if you don't have Internet. For photos, the local version of the API could identify a dog in a picture, while the more accurate cloud-based API could determine the specific dog breed. The local APIs are free, while the cloud-based APIs use the usual Firebase cloud API pricing.

If developers do use the cloud-based APIs, none of the data stays on Google's cloud. As soon as the processing is done, the data is deleted.

In the future, Google will add an API for Smart Reply. This machine learning feature is debuting in Google Inbox and will scan emails to generate several short replies to your messages, which you can send with a single tap. This feature will first launch in an early preview, and the computing will always be done locally on the device. There's also a "high density face contour" feature coming to the face detection API, which will be perfect for those augmented reality apps that stick virtual items on your face.

* YouTube 视频链接：https://youtu.be/ejrn_JHksws

ML Kit will also offer an option to decouple a machine learning model from an app and store the model in the cloud. Since these models can be "tens of megabytes in size," according to Google, offloading this to the cloud should make app installs a lot faster. The models first are downloaded at runtime, so they will work offline after the first run, and the app will download any future model updates.

The huge size of some of these machine learning models is a problem, and Google is trying to fix it a second way with a future cloud-based machine learning compression scheme. Google's plan is to eventually take a full uploaded TensorFlow model and spit out a compressed TensorFlow Lite model with similar accuracy.

This also works well with Firebase's other features, like Remote Config, which enables A/B testing of machine learning models across a user base. Firebase can also switch or update models on the fly, without the need for an app update.

Developers looking to try out ML Kit can find it in the [Firebase console](https://console.firebase.google.com/u/0/project/_/ml?pli=1).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
