> * 原文地址：[Detect Faces, Texts and Even Barcodes With Chrome’s Shape Detection API](https://blog.bitsrc.io/detect-faces-texts-and-even-barcodes-with-chromes-shape-detection-api-34e40c55bb30)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/detect-faces-texts-and-even-barcodes-with-chromes-shape-detection-api.md](https://github.com/xitu/gold-miner/blob/master/article/2020/detect-faces-texts-and-even-barcodes-with-chromes-shape-detection-api.md)
> * 译者：[rocwong-cn](https://github.com/rocwong-cn)
> * 校对者：[zenblo](https://github.com/zenblo)、[Chorer](https://github.com/Chorer)

# 使用 Chrome 的 Shape Detection API 检测人脸，文本甚至条形码

![](https://cdn-images-1.medium.com/max/2560/1*sw-UYEsreElKPUGOtHHkfg.jpeg)

## 初步介绍

作为一名 Web 开发人员，我们会有很多场景需要安装外部库来处理，诸如人脸、文本和条形码之类的元素的检测。这是因为没有 Web 标准 API 供开发人员使用。

Chrome 团队正在尝试通过在 Chrome 浏览器中提供实验性的 [形状检测 API（Shape Detection API）](https://web.dev/shape-detection/)并将其设为 Web 标准来改善这种情况。

---

此特性目前是实验性的，但可以通过启用 `chrome://flags` 中的 #enable-experimental-web-platform-features 标志来在本地访问。

## 使用场景

以上三个特性的使用场景是没有界限的。您可以使用这些 API 代替这些天来一直在使用的库。以下是一些可以使用这些 API 的案例。

#### 条码检测

* Web 应用可能在各种各样的场景中使用条码，包括在线支付，甚至可以应用在社交软件中建立用户间的联系。
* 机场可以提供自助服务终端，这些自助服务终端可以使用网络摄像头轻松地扫描乘客的登机牌。
* 只需通过商店的 Web 应用扫描条码，即可获得产品的更多详细信息。
* 随着 PWA（Progressive Web App）的兴起，这些新特性最终将使它们能够用于上述的使用场景中。

![Photo by [Simon Bak](https://unsplash.com/@simon_bak?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*XpBiW2yV0QShFeT3)

#### 人脸检测

* 通过检测用户是否在设备前面来提供交互式多媒体播放。（用户视线移开时自动暂停视频）
* 使用人脸检测功能自动裁剪和调整图像大小。
* 允许标记个人的面孔 —— 类似于在 Facebook 等网站上找到的面孔。
* 产品模型在面部特征上的实时叠加 —— 虚拟试戴产品，例如太阳镜，眼镜等。
* 应用类似于 Snapchat 之类的自拍实时滤镜。

![Photo by [Aditya Ali](https://unsplash.com/@aditya_ali?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*fMdy36i2XzHSyqkC)

#### 文本检测

* 将图像翻译为文字，例如餐厅菜单，简历或者甚至语言翻译（英语翻译为其它语言）以及数字检测。
* 动态地为 `<img>` 标签提供由文本组成的 `alt` 属性。
* 图像转文字，文字再转语音。

![Photo by [Jason Leung](https://unsplash.com/@ninjason?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*rlAeIQ_f994PC7ca)

## 来让我们一探究竟

`FaceDetector`、`BarcodeDetector` 和 `TextDetector` 这三个检测器的接口类似。它们都提供一个名为 `detect()` 的异步方法，该方法以一个 `ImageBitmapSource` 作为输入（即 `CanvasImageSource`、`Blob` 或 `ImageData`）。

此外，可以将可选参数传到 `FaceDetector` 和 `BarcodeDetector` 中，以获得自定义程度更高的检测。

**注意：目前，这些功能取决于平台。 尽管启用 #enable-experimental-web-platform-features 标志后即可访问这三个 JavaScript 接口，但仍不能保证您的平台支持这些 API。 正如我之前所说，这仍在开发中。**

![Platform Support — Source: [Repo Readme](https://github.com/WICG/shape-detection-api#overview)](https://cdn-images-1.medium.com/max/2000/1*5iilBTzWa_E_5V23Jduutw.png)

---

您可以在[此处]((https://github.com/WICG/shape-detection-api#platform-specific-implementation-notes-computer))阅读更多有关特定平台的实现信息。

## 人脸检测

您可以向 `FaceDetector` 构造函数提供可选参数，例如 `maxDetectedFaces` 和 `fastMode`。`maxDetectedFaces` 属性指定要检测的最大面孔数量（有限制），而 `fastMode` 属性则指定是否优先考虑速度而不是准确性。

该 API 始终返回图像中检测到的面部的边界框。根据平台的不同，可能会提供有关眼睛，鼻子或嘴等面部标志的更多信息。

> 注意：此 API 用于**人脸检测**，而不是人脸识别。您可以在“**人脸检测**”中检测到是否存在人脸，如果存在，则可以检测其面部特征的位置，例如嘴，眼，鼻子等。但是在“**面部识别**”中，您能够区分两个面孔。到目前为止，此 API 尚未提供该功能。

```js
async function detectFace(image) {
    const faceDetector = new FaceDetector({
        // （可选）提示，尝试将场景中检测到的面部数量
        // 限制为该最大数量。
        maxDetectedFaces: 3,
        // （可选）提示，例如通过缩小规模操作或寻找大的特性
        // 来尝试优先考虑速度而不是准确性。
        fastMode: false
    });
    try {
        const faces = await faceDetector.detect(image);
        console.log(faces);
    } catch (e) {
        console.error('Face detection failed:', e);
    }
}

function readFace() {
    let img = document.getElementById("img");
    detectFace(img);
}
```

只需在以上示例中调用 `readFace()` 方法即可。就是这么简单。

## 条码检测

`BarcodeDetector` 构造函数接收一个名为 `formats` 的可选参数。此参数是要搜索的条形码格式的 `Array`。应该注意的是，并非所有平台都支持所有条形码格式。

该 API 返回图像中检测到的条形码的边界框以及条形码的 `rawValue`。它还将返回所识别的条形码的格式，例如：`qr_code`，`data_matrix` 等。

```js
async function detectBarcode(image) {
    const barcodeDetector = new BarcodeDetector({
        //（可选）要搜索的一系列条形码格式。
        // 并非所有平台都支持所有格式
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
        console.log(barcodes);
    } catch (e) {
        console.error('Barcode detection failed:', e);
    }
}

function readBarcode() {
    let img = document.getElementById("img");
    detectBarcode(img);
}
```

您可以调用 `readBarcode()` 方法来检测图像中的条形码。

## 文本检测

> 注意：`TextDetector` 不是通用的。尽管这是一个有趣的领域，但该功能仍不够稳定。根据文档，“目前，它在任何计算平台或字符集上都不够稳定，无法标准化，这就是为什么文本检测已移至单独的 [信息规范](https://wicg.github.io/shape-detection-api/text.html) ”。

`TextDetector` API 会始终返回检测到的文本的边界框，并且在某些平台上会返回识别出的字符。

这是示例实现代码。

```js
async function detectText(image) {
    const textDetector = new TextDetector();
    try {
        const texts = await textDetector.detect(image);
        console.log(texts);
    } catch (e) {
        console.error('Text detection failed:', e);
    }
}

function readText() {
    let img = document.getElementById("img1");
    detectText(img);
}
```

## 结论

以上 API 的应用不胜枚举。由于它们仍处于实验阶段，因此您可以随便折腾，以更好地了解它们。

要简单地确定您的设备是否支持这些 API，只需启用文章中提到的标志，然后访问团队提供的 [demo](https://shape-detection-demo.glitch.me/) 。如果您的平台不提供某功能，则会提醒您。您也可以在 [此处](https://glitch.com/edit/#!/shape-detection-demo?path=index.html%3A3%3A8) 查看 demo 的源代码。

如果您打算在您的网站上使用该 API，可以联系 Chrome 团队并告知他们。这将有助于他们确定功能的优先级，同时也向其他浏览器厂商展示支持这些 API 的重要性。

根据团队的说法，您可以通过以下方式与他们联系。

* 在 [WICG 讨论主题](https://discourse.wicg.io/t/rfc-proposal-for-face-detection-api/1642/3) 上分享您打算如何使用它
* 发送一条带 `#shapedetection` 标签的推特给 [@ChromiumDev](https://twitter.com/chromiumdev)，并告诉我们您是在哪种场景、以何种方式使用它的。

希望您从本文中学到了新东西。您可以浏览下面附带的资源以获取更多信息。

感谢您的阅读，编码愉快！

**参考资料**

- [Chrome Shape Detection API](https://web.dev/shape-detection/)
- [W3C Drafts](https://wicg.github.io/shape-detection-api/)
- [Repo](https://github.com/WICG/shape-detection-api)
- [Project by Eyevinn Technology](https://medium.com/@eyevinntechnology/using-shape-detection-api-in-chrome-to-detect-if-anyone-is-watching-the-video-f3f898d2912)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
