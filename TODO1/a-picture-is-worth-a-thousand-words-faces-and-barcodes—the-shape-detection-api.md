> * 原文地址：[A Picture is Worth a Thousand Words, Faces, and Barcodes—The Shape Detection API](https://developers.google.com/web/updates/2019/01/shape-detection)
> * 原文作者：[Thomas Steiner](https://developers.google.com/web/resources/contributors/thomassteiner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-picture-is-worth-a-thousand-words-faces-and-barcodes—the-shape-detection-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-picture-is-worth-a-thousand-words-faces-and-barcodes—the-shape-detection-api.md)
> * 译者：
> * 校对者：

# 一张图片可能由数千个文字、人脸或者二维码组成 —— 形状检测 API

> 注意：我们目前正在使用此API的规范作为 [功能项目](https://developers.google.com/web/updates/capabilities) 的一部分， 随着这个新的 API 从设计转向实现，我们将保持这篇文章的不断更新。

## 什么是形状检测 API ？

借助 API [`navigator.mediaDevices.getUserMedia`](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia) 和新版的 Chrome for Android [photo picker](https://bugs.chromium.org/p/chromium/issues/detail?id=656015)，从移动设备上的相机获取图像或者实时上传视频数据或本地图像变得相当容易。在此之前，这些动态的图像数据以及页面上的静态图像一直都是个黑盒我们无法操作，即使图像实际上可能包含许多有趣的特征，如人脸、条形码和文本。

过去，如果开发人员想要在客户端提取这些特征，例如构建一个 [ QR 代码识别器](https://qrsnapper.appspot.com/)，他们必须借助外部的 JavaScript 库。从性能的角度来看，这可能是昂贵的，并且会增加整体页面的资源体积。另一方面，诸如 Android 、iOS 和 macOS 这些操作系统，以及他们的相机模块中的硬件芯片，通常已经具有高性能和高度优化的特征检测器，例如 Android 的  [`FaceDetector`](https://developer.android.com/reference/android/media/FaceDetector) 或者 iOS 自带的特征检测器 [`CIDetector`](https://developer.apple.com/documentation/coreimage/cidetector?language=objc)。

而 Shape Detection API 做的便是调用这些原生实现，并暴露一组 JavaScript 接口。目前，这个 API 支持的功能是通过 `FaceDetector` 接口进行人脸检测，通过  `BarcodeDetector` 接口进行条形码检测以及通过 `TextDetector` 接口进行文本检测（光学字符识别，OCR）。


> **小提示：** 尽管文本检测是一个有趣的领域，但在目前要标准化的计算平台或字符集中，文本检测还不够稳定，这也是文本检测已经有一套单独的[信息规范](https://wicg.github.io/shape-detection-api/text.html)的原因。

[相关论文](https://docs.google.com/document/d/1QeCDBOoxkElAB0x7ZpM3VN3TQjS1ub1mejevd2Ik1gQ/edit)

### Shape Detection API 实践用例

如上所述，Shape Detection API 目前支持检测人脸、条形码和文本。以下列表包含了所有三个功能的用例示例：

*   人脸检测
    *   在线社交网络或照片共享网站通常会让用户在图像中标记出人物。通过边缘检测识别人脸，能使这项工作更为便捷。
    *   内容网站可以根据可能检测到的面部动态裁剪图像，而不是依赖于其他启发式方法，或者使用 [Ken Burns](https://en.wikipedia.org/wiki/Ken_Burns_effect) 提出的通过平移或者缩放检测人脸。
    *   多媒体消息网站可以允许其用户在检测到的面部的不同位置上添加 [太阳镜或胡须](https://beaufortfrancois.github.io/sandbox/media-recorder/mustache.html) 之类的有趣贴图。

*   条形码检测
    *   能够读取 QR 码的 We b应用程序可以实现很多有趣的用例，如在线支付或 Web 导航，或使用条形码在应用程序上传递社交连接。
    *   购物应用可以允许其用户扫描实体店中物品的 [EAN](https://en.wikipedia.org/wiki/International_Article_Number) 或者 [UPC](https://en.wikipedia.org/wiki/Universal_Product_Code) 条形码，以在线比较价格。
    *   机场可以设立网络信息亭，乘客可以在那里扫描登机牌的 [Aztec codes](https://en.wikipedia.org/wiki/Aztec_Code) 以显示与其航班相关的个性化信息。

*   文字检测
    *   当没有提供其他描述时，在线社交网站可以通过将检测到的文本添加为 `img[alt]` 属性值来改善用户生成的图像内容的体验。
    *   内容网站可以使用文本检测来避免将标题置于包含文本的主要图像之上。
    *   Web应用程序可以使用文本检测来翻译文本，例如，翻译餐馆菜单。

## 当前进度

| ---- | ------ |
| 步骤 | 状态 |
| 1、创建解释器| [完成](https://docs.google.com/document/d/1QeCDBOoxkElAB0x7ZpM3VN3TQjS1ub1mejevd2Ik1gQ/edit) |
| 2、创建规范的初始草案	 | [进行中](https://wicg.github.io/shape-detection-api) |
| 3、收集反馈并迭代 | [进行中](#feedback) |
| **4、投入实验** | **[进行中](https://developers.chrome.com/origintrials/#/view_trial/-2341871806232657919)** |
| 5. 发布 | 未开始 |

## 如何使用 Shape Detection API

三个检测器向外暴露的接口 `FaceDetector`、`BarcodeDetector` 和 `TextDetector` 都非常相似，它们都提供了一个异步方法 `detect` ，它接受一个 [`ImageBitmapSource`](https://html.spec.whatwg.org/multipage/imagebitmap-and-animations.html#imagebitmapsource) 输入（或者是一个 [`CanvasImageSource`](https://html.spec.whatwg.org/multipage/canvas.html#canvasimagesource)、 [`Blob`] 对象(https://w3c.github.io/FileAPI/#dfn-Blob) 或者 [`ImageData`](https://html.spec.whatwg.org/multipage/canvas.html#imagedata))。

在使用 `FaceDetector` 和 `BarcodeDetector` 的情况下，可选参数可以被传递到所述检测器的构造函数中，其允许向底层原生检测器发起调用指示。

> **小提示：** 如果你的 `ImageBitmapSource` 来自一个 [独立的脚本源](https://html.spec.whatwg.org/multipage/#concept-origin) 并且与 document 的源不同， 那么 `detect` 将会调用失败并抛出一个名为 SecurityError 的 [`DOMException`](https://heycam.github.io/webidl/#idl-DOMException) 。如果你的图片对跨域设置了 CORS，那么你可以使用 [`crossorigin`](https://developer.mozilla.org/en-US/docs/Web/HTML/CORS_settings_attributes) 属性来请求 CORS 访问。

### 在项目里使用 `FaceDetector`

```
const faceDetector = new FaceDetector({
  // (Optional) Hint to try and limit the amount of detected faces
  // on the scene to this maximum number.
  maxDetectedFaces: 5,
  // (Optional) Hint to try and prioritize speed over accuracy
  // by, e.g., operating on a reduced scale or looking for large features.
  fastMode: false
});
try {
  const faces = await faceDetector.detect(image);
  faces.forEach(face => console.log(face));
} catch (e) {
  console.error('Face detection failed:', e);
}
```

### 在项目里使用 `BarcodeDetector`

```
const barcodeDetector = new BarcodeDetector({
  // (Optional) A series of barcode formats to search for.
  // Not all formats may be supported on all platforms
  formats: [
    'aztec',
    'code_128',
    'code_39',
    'code_93',
    'codabar',
    'data_matrix',
    'ean_13',
    'ean_8',
    'itf',
    'pdf417',
    'qr_code',
    'upc_a',
    'upc_e'
  ]
});
try {
  const barcodes = await barcodeDetector.detect(image);
  barcodes.forEach(barcode => console.log(barcode));
} catch (e) {
  console.error('Barcode detection failed:', e);
}
```

### 在项目里使用 `TextDetector`

```
const textDetector = new TextDetector();
try {
  const texts = await textDetector.detect(image);
  texts.forEach(text => console.log(text));
} catch (e) {
  console.error('Text detection failed:', e);
}
```

## 特征检测

在使用 Shape Detection API 接口之前检查构造函数是否存在是必须的，因为虽然 Linux 和 Chrome OS 上的 Chrome 目前已经暴露了检测器的接口，但它们却没法正常使用 ([bug](https://crbug.com/920961))。作为临时措施，我们建议在使用特征检测应当这么做：

```
const supported = await (async () => 'FaceDetector' in window &&
    await new FaceDetector().detect(document.createElement('canvas'))
    .then(_ => true)
    .catch(e => e.name === 'NotSupportedError' ? false : true))();
```

## 最佳做法

所有检测器都是异步工作的，也就是说，它们不会阻塞主线程 🎉 ，因此不要过分追求实时检测，而是给检测器一段时间来完成其工作。

如果你是 [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API) 的忠实粉丝 （难道还有人不是吗？）最棒的是检测器的接口也暴露在那里。检测结果也是可序列化的，因此可以通过 `postMessage` 将其从 worker 线程传回主线程。 这里有个 [demo](https://shape-detection-demo.glitch.me/) 展示了一些简单实践。

并非所有平台实现都支持所有功能，因此请务必仔细检查支持情况，并将 API 看作是渐进增强功能。例如，某些平台本身可能支持人脸检测，但不支持面部标志检测（眼睛、鼻子、嘴巴等等），或者可以识别文本的存在和位置，但不识别实际的文本内容。

> **小提示：** 此API是一种优化，并不能保证每个用户都可以正常使用。期望开发人员将其与他们自己的图像识别代码相结合，当其可用时将其作为原生的一种优化手段。

## 意见反馈

我们需要您的帮助，以确保 Shape Detection API 能够满足您的需求，并且我们不会错过任何关键方案。

**我们需要你的帮助！** —— Shape Detection API 的当前设计是否满足您的需求？如果不能，请在 [Shape Detection API repo](https://github.com/WICG/shape-detection-api) 提交 issue 并提供尽可能详细的信息。

我们也很想知道您打算如何使用 Shape Detection API：

*   有一个独到的使用场景或者说你知道在哪些情况下可以用到它？
*   你打算用这个吗？
*   喜欢它，并想表达你对它的支持？

在 [Shape Detection API WICG Discourse](https://discourse.wicg.io/t/rfc-proposal-for-face-detection-api/1642/3) 上分享您的讨论与看法。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
