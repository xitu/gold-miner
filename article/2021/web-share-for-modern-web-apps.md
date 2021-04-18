> * 原文地址：[Web Share for Modern Web Apps](https://blog.bitsrc.io/web-share-for-modern-web-apps-43c3e2329093)
> * 原文作者：[Janaka Ekanayake](https://medium.com/@clickforjanaka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/web-share-for-modern-web-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/web-share-for-modern-web-apps.md)
> * 译者：
> * 校对者：

# Web Share for Modern Web Apps

![](https://cdn-images-1.medium.com/max/5760/1*QXEz4H_A4nons0JRZmblhQ.png)

> Recently, Web Share and Web Share API started to support Windows and Chrome OS, making it interesting for Web Developers.

Have you ever come across the Web Share API? At least many of you may have heard of the term. Web Share API was out there for some time now. However, the initial support for Web Share API was limited to mobile devices.

## Web Share API — Quick Demo

We can do a quick test of Web Share APIs by following the steps given below to share data with other applications from a web page.

![Source: [https://web-share.glitch.me/](https://web-share.glitch.me/)](https://cdn-images-1.medium.com/max/2000/1*sHKOD8KJJxktrFqgPyAQwA.png)

1. First of all, make sure you use the latest version of Google Chrome.
2. Open your browser and go to [this](https://web-share.glitch.me/) link and click the **Share** button.
3. You can open any other application that allows sharing. Besides, it also support sharing with nearby devices.
4. After sharing, you can view the shared data in the target application. I’ve used **Mail** as the application and it added the text data into email body as shown below. The data was passed from the Web Share API.

![](https://cdn-images-1.medium.com/max/2000/1*YSWUxwngdvAWwQOtAHYzvg.png)

> **I hope you are already convinced after trying it out.** At least that was my first impression while checking out the Web Share demo in my browser.

## Using Web Share in Practice

### Sharing Links and Text

You can use a simple `share()` method to share the links and text you want. The code snippet is given below to help you out with Web Share.

```ja
if (navigator.share) {
  navigator.share({
    title: 'google.com',
    text: 'Visit the google.com.',
    url: 'https://www.google.com/',
  })
    .then(() => console.log('Successful share'))
    .catch((error) => console.log('Error sharing', error));
 }
```

### Sharing Files

File sharing is a bit different from URL sharing. For instance, you have to call `navigator.canShare()`. Then you can add an array of files while invoking `navigator.share()`

```js
if (navigator.canShare && navigator.canShare({ files: fileArr })) {
  navigator.share({
    files: fileArr,
    title: 'My image collection',
    text: 'The vacation at north pole',
  })
  .then(() => console.log('Sharing was successful.'))
  .catch((error) => console.log('Sharing failed', error));
 } else {
  console.log(`Your system doesn't support sharing the given files.`);
 }
```

### Sharing Target

For an app to become a Share Target, it needs to fulfill some criteria set by Chrome. You can refer to [this](https://developers.google.com/web/fundamentals/app-install-banners/#criteria) link to check those out.

To register in the web app manifest, you have to add a `share_target`. It alerts the operating system to consider the app as a possible sharing option, as shown below.

1. Accepting basic information
2. Accepting files
3. Accepting application changes

You have to use the Web Share Target API to register as a target. A target can share files and content with other applications.

```js
"share_target": {
  "action": "/?share-target",
  "method": "POST",
  "enctype": "multipart/form-data",
  "params": {
    "files": [
      {
        "name": "file",
        "accept": ["image/*"],
      },
    ],
  },
 },
```

However, it is easier to transfer files between installed applications. You can share multiple contents varying from URLs to files.

```js
async function share(title, text, url) {
  try {
    await navigator.share({title, text, url});
    return true;
  } catch (ex) {
    console.error('Share failed', ex);
    return false;
  }
 }
```

## Web Share API — Features and Limitations

### Features

* Using Web Share, your web application can use the system-provided sharing capabilities just like a platform-specific app.
* Developers get a more comprehensive range of sharing options.
* It is possible to customize the share targets and choices in their devices. Therefore, you can increase the page loading speed.
* Web Share APIs help to share text, URLs, and files. And also, Web Share has expanded its services too.
* It’s available for Chrome OS, Chrome on Window, Safari, and Android in Chromium forks.

### Limitations

However, no matter how good this service is, there are several drawbacks and limitations too.

* Firstly, only the sites accessed via `https` can be used with Web Share.
* Another thing is, you cannot invoke it with something like an `onload `operation. There must be some user action for this. For instance, a user click can invoke it.

* Besides, it is still under development for Chrome for Mac.

## Summary

Web Share API is a modern web platform feature to share content easier across social networks, SMS, and registered target apps.

Chrome is one major browser that supports Web Share Target API. And also, Safari supports it as well.

![](https://cdn-images-1.medium.com/max/2000/1*CtRllCb7OzXfmPxJk4eaew.png)

> However, the Web Share API should be triggered by a user action, as it is developed to reduce inconveniences and abuses.

Thank you for reading. Feel free to leave a comment down below and share your experience.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
