> * 原文地址：[New Standards to Access User Device Hardware using JavaScript](https://blog.bitsrc.io/new-standards-to-access-user-device-hardware-using-javascript-86b0c156dd3d)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-standards-to-access-user-device-hardware-using-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-standards-to-access-user-device-hardware-using-javascript.md)
> * 译者：
> * 校对者：

# New Standards to Access User Device Hardware using JavaScript

## New Standards to Access Device Hardware using JavaScript

#### WebHID, WebNFC, and WebUSB have opened up new avenues to interact with user’s device hardware for web apps.

![](https://cdn-images-1.medium.com/max/5760/1*qfJbVEgiwXf7b-nEviGJHg.jpeg)

Have you ever come across the need to access a user’s device hardware and implement a desktop application only for that feature? You are not alone. Until recently, the way to achieve the above would have been far-fetched and cumbersome. However, with recent Chrome DevTools updates, talking to hardware using JavaScript has become a reality.

---

So, in this article, I would be introducing three new JavaScript APIs, namely **WebHID**, **WebNFC**, and **WebUSB** became available for device hardware access. Let’s look at each of these technologies separately.

## 1. What is WebHID?

One major problem developers face when integrating an HID (Human Interface Device) into software is that the software should accommodate a large number of varieties; old devices, new devices, common models, uncommon models, etc.

> # WebHID solves this issue by providing an API to implement device-specific logic in JavaScript.

Basically, if you wanted to play the Chrome Dino 🦖 offline game using a Nintendo Switch Joy-Con controller, WebHID makes it possible for you to do so. Pretty cool isn’t it?

You can find out whether WebHID is supported using the following code snippet.

```
if ("hid" in navigator) { /* The WebHID API is supported. */ }
```

When an application has implemented WebHID to connect a device, it’ll show up a prompt as below.

![](https://cdn-images-1.medium.com/max/2560/1*jGpe3g9CW13dDzmCCbBaYQ.jpeg)

All you need to do is, select the correct device and click connect. It’s as simple as that.

> # WebHID API is asynchronous. Therefore it doesn’t block the UI when awaiting a new device connection or an input.

#### Security considerations

I’m sure this is something that came to your mind after finding what WebHID could do.

The API has been developed using the core principles defined in [Controlling Access to Powerful Web Platform Features](https://chromium.googlesource.com/chromium/src/+/lkgr/docs/security/permissions-for-powerful-web-platform-features.md), including user control, transparency, and ergonomics. Further, only one HID device is allowed to connect at a single time.

Besides, Chrome DevTools has made it easier to debug connections with devices by providing a log of devices the browser is connected to. This can be viewed at `**chrome://device-log**` (An internal page in Chrome).

We won’t go into in-depth implementation details in this article. Let me know in the comment section if you need to know such information.

#### Browser compatibility

WebHID is currently supported by Chrome and Edge in desktops.

![Reference [https://developer.mozilla.org/en-US/docs/Web/API/WebHID_API](https://developer.mozilla.org/en-US/docs/Web/API/WebHID_API)](https://cdn-images-1.medium.com/max/2004/1*F47jvMuDaIypYRjt_PFbaA.png)

---

Let’s have a look at WebNFC next.

#### Tip: Build & share independent components with Bit

[**Bit**](https://bit.dev/) is an ultra-extensible tool that lets you create **truly** modular applications ****with **independently** authored, versioned, and maintained components.

Use it to build modular apps & design systems, author and deliver micro frontends, or simply share components between applications.

---

![Material UI components shared individually on [Bit.dev](https://bit.dev/)](https://cdn-images-1.medium.com/max/4000/0*Zdd8UHQHimqwYPU7.png)

## 2. What is WebNFC?

I’m sure that you have come across the abbreviation NFC ( Near field communications) before.

With WebNFC, now you are able to read from or write to an NFC tag when it is within range of your device. This is done via NDEF (NFC Data Exchange Format) which is supported by NFC tag formats.

#### Using WebNFC

Let’s say you need to manage the inventory in your shop. You can build an inventory management site with WebNFC which can read/write data into NFC tags on your inventory stocks.

The possibilities are endless. This is an opportunity to automate many things and make our day-to-day work more efficient.

Similar to WebHID, you can check for WebNFC support using the code snippet below.

```
if ('NDEFReader' in window) { /* Scan and write NFC tags */ }
```

#### Security considerations

> # As a security precaution, Web NFC is only available to top-level frames and secure browsing contexts (HTTPS only).

If the web page that implements WebNFC disappears or isn’t visible, all connections to NFC tags will be suspended. These will be resumed when the page gets visible again. The page visibility API helps you to identify the connection status of NFC operations.

If you are not familiar with the Page Visibility API, refer to this [article](https://blog.bitsrc.io/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know-b1c74948bd74) for more info.

#### Browser compatibility

WebNFC is only supported by Chrome Android so far.

![Reference [https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API](https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API)](https://cdn-images-1.medium.com/max/4048/1*fN-b18bMyZ8OPvq3eYzNvQ.png)

Next, let’s have a look at the WebUSB APIs together.

## 3. What is WebUSB?

The WebUSB API allows you to communicate with USB ports using JavaScript became available from Chrome 61.

However, you might wonder how we access the relevant drivers for each USB device, right? With the support of WebHID API, it allows hardware manufactures to build cross-platform JavaScript SDKs for their hardware devices.

Similar to the APIs discussed above, the support for WebUSB can be detected using the following code snippet.

```
if ("usb" in navigator) { /* The WebUSB API is supported. */ }
```

#### Security

There are many controls in place to protect unauthorized USB access in terms of security, and it only works on secure contexts supporting HTTPS only to protect any data at transit. Besides, the standard browser consent process is there to request and grant access.

Debugging WebUSB API-related tasks is also available via the internal `**chrome://device-log**` page, which lists all the USB devices connected and the related events.

#### Browser compatibility

WebUSB is supported by Chrome, Edge on desktops, and Chrome on Android devices.

![Reference [https://developer.mozilla.org/en-US/docs/Web/API/USB](https://developer.mozilla.org/en-US/docs/Web/API/USB)](https://cdn-images-1.medium.com/max/2006/1*l3vDUrDveghLc6IUMAD2Mg.png)

---

For more details about the WebUSB API, you can refer [Access USB Devices on the Web](https://web.dev/usb/).

## Conclusion

Whether it’s your site that interacts with your hardware or your hardware that can interact with web applications, it’s a win-win situation because they don’t need to install special drivers or software to connect anymore.

---

In my opinion, this is such a cool new feature which will make life a lot easier. 
Let me know your thoughts about this too. Thanks for reading!

## Learn More
[**Independent Components: The Web’s New Building Blocks**
**Why everything you know about microservices, micro frontends, monorepos, and even plain old component libraries, is…**blog.bitsrc.io](https://blog.bitsrc.io/independent-components-the-webs-new-building-blocks-59c893ef0f65)
[**Explore JavaScript DOM traversal**
**There are many ways for JavaScript DOM traversal. Let’s find out how to traverse using parent, child, and sibling…**blog.bitsrc.io](https://blog.bitsrc.io/explore-javascript-dom-traversal-96352ec3bcf8)
[**Web Caching Best Practices**
**Web Caching: How to avoid common pitfalls.**blog.bitsrc.io](https://blog.bitsrc.io/web-caching-best-practices-ae9580ceb4b3)
[**The Dark Side of Javascript: A Look at 3 Features You Never Want to Use**
**JavaScript has some dark corners filled with spiders, and here are 3 of them**blog.bitsrc.io](https://blog.bitsrc.io/the-dark-side-of-javascript-a-look-at-3-features-you-never-want-to-use-83b6f0b3804b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
