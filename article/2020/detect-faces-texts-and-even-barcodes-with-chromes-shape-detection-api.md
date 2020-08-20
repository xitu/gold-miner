> * 原文地址：[Detect Faces, Texts and Even Barcodes With Chrome’s Shape Detection API](https://blog.bitsrc.io/detect-faces-texts-and-even-barcodes-with-chromes-shape-detection-api-34e40c55bb30)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/detect-faces-texts-and-even-barcodes-with-chromes-shape-detection-api.md](https://github.com/xitu/gold-miner/blob/master/article/2020/detect-faces-texts-and-even-barcodes-with-chromes-shape-detection-api.md)
> * 译者：
> * 校对者：

# Detect Faces, Texts and Even Barcodes With Chrome’s Shape Detection API

![](https://cdn-images-1.medium.com/max/2560/1*sw-UYEsreElKPUGOtHHkfg.jpeg)

## Introduction

As a web developer, we would have had many instances where we were required to install external libraries to handle the detection of elements such as faces, text, and barcode. This was because there was no web standard API for developers to utilize.

The Chrome team is trying to change this by providing an experimental [Shape Detection API](https://web.dev/shape-detection/) in Chrome browsers and make it a web standard.

---

Although this feature is experimental, it can be accessed locally, by enabling the #enable-experimental-web-platform-features flag in `chrome://flags` .

## Use Cases

The use cases of the above three features are boundless. You can use these APIs in substitute to the libraries you have been using all these days instead. Here are some of the use cases in which you can use these APIs.

#### Barcode Detection

* Web applications will be able to open themselves into a wide variety of use cases which include online payments and they can even be used in social applications to create a connection between users.
* Airports can provide kiosks that can simply scan the boarding pass of the passenger by using a web camera.
* Get more details of a product by simply scanning the barcode via the store’s web application.
* With the rise of Progressive Web Apps, these features would eventually allow them to use all the above-mentioned use cases.

![Photo by [Simon Bak](https://unsplash.com/@simon_bak?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*XpBiW2yV0QShFeT3)

#### Face Detection

* Provide interactive multimedia playback by recognizing whether the user is in front of the device. (Auto pause video when the user looks away)
* Auto crop and resize images using face detection.
* Allow tagging faces of individuals — similar to what’s found on websites like Facebook.
* Realtime overlay of product models over facial features — virtual try-on products such as sunglasses, spectacles, etc.
* Apply real-time filters with selfies similar to applications like Snapchat.

![Photo by [Aditya Ali](https://unsplash.com/@aditya_ali?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*fMdy36i2XzHSyqkC)

#### Text Detection

* Translation to text where the image is, for example, a restaurant menu, a CV, or even language translations — English to Foreign Language, and number recognition.
* Provide `alt` attributes for `\<img>` tags dynamically which are made up of texts.
* Text-to-Speech from images of text.

![Photo by [Jason Leung](https://unsplash.com/@ninjason?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*rlAeIQ_f994PC7ca)

## Let’s Get Into The Details

The interfaces of all three detectors, `FaceDetector`, `BarcodeDetector`, and `TextDetector` are similar. They all provide a single asynchronous method called `detect()` that takes an `ImageBitmapSource` as an input (that is, either a `CanvasImageSource`, a `Blob`, or `ImageData`).

Moreover optional parameters can be fed into the `FaceDetector` and `BarcodeDetector` to get a more customized detection.

**Note: These features are platform dependent for now. Although the three JavaScript interfaces are accessible after enabling the #enable-experimental-web-platform-features flag, it still does not guarantee that your platform would support the APIs. As I said earlier, this is still under development.**

![Platform Support — Source: [Repo Readme](https://github.com/WICG/shape-detection-api#overview)](https://cdn-images-1.medium.com/max/2000/1*5iilBTzWa_E_5V23Jduutw.png)

---

You can read more about this platform-specific implementation over [here](https://github.com/WICG/shape-detection-api#platform-specific-implementation-notes-computer).

## Face Detection

You can provide optional parameters such as `maxDetectedFaces` and `fastMode` to the `FaceDetector` constructor. The `maxDetectedFaces` property specifies the maximum number of faces to be detected (limit) while the `fastMode` property specifies whether to prioritize speed over accuracy.

This API always returns the bounding box of the faces detected in the image. Depending on the platform, more information regarding face landmarks like eyes, nose, or mouth may be available.

> Note: This API is for **face detection**, not face recognition. “**Face Detection**” is where you are able to detect whether a face is present and if present, the location of it’s facial features such as mouth, eyes, nose etc. But in “**Face Recognition**” you are able to differentiate between two faces. This API does not provide that feature as of now.

```js
async function detectFace(image) {
    const faceDetector = new FaceDetector({
        // (Optional) Hint to try and limit the amount of detected faces
        // on the scene to this maximum number.
        maxDetectedFaces: 3,
        // (Optional) Hint to try and prioritize speed over accuracy
        // by, e.g., operating on a reduced scale or looking for large features.
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

Simply call the `readFace()` method in the above example to use this. It’s simple as that.

## Barcode Detection

The `BarcodeDetector` constructor receives an optional parameter named `formats` . This parameter is an `Array` of barcode formats to search for. It should be noted that not all barcode formats are supported on all platforms.

This API returns the bounding boxes of the barcode detected in the image, as well as the `rawValue` of the barcode. It would also return the format of the barcode identified — ex: `qr_code`, `data_matrix`, etc.

```js
async function detectBarcode(image) {
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

You can call the `readBarcode()` method to detect the barcodes in your image.

## Text Detection

> Note: `TextDetector` is not universally available. Although being an interesting domain, this feature is still considered to be not stable enough. According to the docs, “(it) is not considered stable enough across either computing platforms or character sets to be standardized at the moment, which is why text detection has been moved to a separate [informative specification](https://wicg.github.io/shape-detection-api/text.html)”.

The `TextDetector` API would always return the bounding boxes of the detected texts and on some platforms the recognized characters.

Here is a sample implementation code.

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

## Conclusion

The applications of the above APIs are countless. As they are still in the experimental stage, you can play around with them and get to know them better.

To easily find out whether your device supports these APIs, simply enable the flags as mentioned in the article and visit the [demo](https://shape-detection-demo.glitch.me/) provided by the team. You will be alerted if a feature is not available in your platform. You can also view the source code of the demo over [here](https://glitch.com/edit/#!/shape-detection-demo?path=index.html%3A3%3A8).

If you are planning to use the API on your site, you can contact the Chrome team and let them know. This would help them prioritize the features and show other browser vendors that support for these APIs are critical.

According to the team, you can contact them as below.

* Share how you plan to use it on the [WICG Discourse thread](https://discourse.wicg.io/t/rfc-proposal-for-face-detection-api/1642/3)
* Send a Tweet to [@ChromiumDev](https://twitter.com/chromiumdev) with `#shapedetection` and let us know where and how you're using it.

Hope you learned something new from this article. You can go through the below-attached resources for more information.

Thank you for reading & Happy coding!

**Resources**

- [Chrome Shape Detection API](https://web.dev/shape-detection/)
- [W3C Drafts](https://wicg.github.io/shape-detection-api/)
- [Repo](https://github.com/WICG/shape-detection-api)
- [Project by Eyevinn Technology](https://medium.com/@eyevinntechnology/using-shape-detection-api-in-chrome-to-detect-if-anyone-is-watching-the-video-f3f898d2912)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
