> * 原文地址：[Understanding WebViews](https://www.kirupa.com/apps/webview.htm)
> * 原文作者：[kirupa](https://www.kirupa.com/me/index.htm)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-webviews.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-webviews.md)
> * 译者：
> * 校对者：

# Understanding WebViews

When it comes to accessing internet content, we typically use a browser like Chrome, Firefox, Safari, Internet Explorer, and Edge. You are probably using one of those browsers right now to read this article! While browsers are pretty popular for the whole task of accessing internet content, they have some serious competition that we probably never paid much attention to. This competition comes in the form of something known as a **WebView**. This article will explain all about what this mysterious WebView is and why it is sorta kinda cool.

Onwards!

## WebView 101

Let's get the boring definition out of the way. **A WebView is an embeddable browser that a native application can use to display web content.** There are a two sets of words to highlight here:

1.  The first set of words is **_native application (aka app)_**. A native app is one written in the language and UI framework designed specifically for a particular platform:

![](https://www.kirupa.com/apps/images/native_app_200.png)

> In other words, the app isn't a cross-platform web app running in the browser. Instead, think of your apps as primarily being written in a language like Swift, Objective-C, Java, C++, C#, etc. that works more closely with the system. To put this into context, most apps you use in your mobile device are going to be native apps. Many popular apps like Microsoft Office on your desktop/laptops are as well.

2.  The second words to highlight are _**embeddable browser**_. We all know what a browser is. It is a standalone app that we can use to surf the internet:

![](https://www.kirupa.com/apps/images/browser_raccoon_200.jpg)

> If you think of the browser as two parts, one part is the UI (address bar, navigation buttons, etc.), and the other part is the engine that turns markup and code into the pixels we can see and interact with:

![](https://www.kirupa.com/apps/images/browser_ui_engine_200.jpg)

> A WebView is just the browser engine part that you can insert sort of like an iframe into your native app and programmatically tell it what web content to load.

Putting all of this together and connecting some dots, a WebView is just a visual component/control/widget/etc. that we would use as part of composing the visuals of our native app. When you are using a native app, a WebView might just be hiding in plain sight next to other native UI elements without you even realizing it:

![](https://www.kirupa.com/apps/images/webview_200.png)

Your WebView is almost like a web-friendly island inside a large ocean of nativeness. The contents of this island don't have to be local to your app. Your WebView will commonly load web content remotely from a http:// or https:// location. This means you can take parts (or all) of your web app that lives on your server and rely on the WebView to display it inside your native app:

![](https://www.kirupa.com/apps/images/webview_html5_remote_200.png)

This flexibility opens up a whole world of code reuse between your browser-focused web app and the parts of your web app that you want to display inside a native app. If all of this doesn't sound crazy awesome...

...your JavaScript running inside your WebView **has the ability to call native system APIs**. This means you aren't limited by the traditional browser security sandbox that your web code normally has to adhere by. The following diagram explains the architectural differences that make this possible:

![](https://www.kirupa.com/apps/images/webview_browser_2_200.png)

By default, any web code running inside a WebView or web browser is kept isolated from the rest of the app. This is done for a host of security reasons that revolve around minimizing the extent of damage some malicious JavaScript might be able to do. If the browser or WebView go down, that's unfortunate but **OK**. If the entire system goes down, that is unfortunate...but **NOT OK**. For arbitrary web content, this level of security makes a lot of sense. You can never fully trust the web content that gets loaded. That isn't the case with WebViews. For WebView scenarios, the developer typically has full control over the content that gets loaded. The chance of malicious code getting in there and causing mayhem on your device is pretty low.

That is why, for WebViews, developers have a variety of supported ways to override the default security behavior and have web code and native app code communicate with each other. This communication commonly happens via something known as a **bridge**. You can see this _bridge_ visualized as part of the Native Bridge and JavaScript Bridge in the earlier diagram. Going into detail on what these bridges look like goes beyond the scope of this article, but the key point to take away is the following: **the same JavaScript you write for the web will not only work inside your WebView, it can also call into native APIs and help your app more deeply integrate with cool system-level functionality like sensors, storage, calendar/contacts, and more.**

## WebView Use Cases

Now that we've gotten an overview of what WebViews are and some of the powerful tricks they have up their sleeve, let's take a step back and look at some of the popular situations we'll see WebViews in our native apps.

### In-App Browsers

One of the most common uses for a WebView is to display the contents of a link. This is especially true on mobile devices where launching a browser, switching the user from one app to another, and hoping they find their way back to the app is an exercise in disappointment. WebViews solve this nicely by loading the contents of the link fully inside the app itself.

Take a look a the following video of what happens when we click on a link in the Twitter or Facebook apps:

Neither Twitter nor Facebook load the linked content in the default browser. They instead use a WebView to fake an in-app browser and render the content as part of the app experience itself. Twitter's in-app browser looks really plain, but Facebook goes one step further with a fancy looking address bar and even a nifty menu:

![](https://www.kirupa.com/apps/images/fb_browser.jpg)

I just happened to pick on Twitter and Facebook since I had those two apps installed and could readily record a video to share with all of you. There are bunch of apps that open links in a similar way by relying on the WebView to behave as an in-app browser.

### Advertisements

Advertising still remains one of the most popular ways native apps make money. How are most of these ads served? **As web content served through a WebView**:

![](https://www.kirupa.com/apps/images/inline_webview.png)

While native ads do exist, most native solutions utilize a WebView behind the scenes and serve the ads from a centralized ad server similar to what you would see in your browser.

### Full Screen Hybrid Apps

So far, we've been looking at WebViews as minor supporting actors in a stage fully dominated by native apps and other native UI elements. WebViews have the depth and range to be the stars, and there is a large class of apps where the web content loaded inside the WebView **forms the entire app user experience**:

![](https://www.kirupa.com/apps/images/hybrid_200.png)

These apps are known as **hybrid apps**. From a technical point of view, these are still native apps. It just happens that the only native thing these apps do is host a WebView that, in turn, loads the web content and all the UI that users will interact with. Hybrid apps are popular for several reasons. The biggest one is _**developer productivity**_. If you have a responsive web app that works in the browser, having the same app work as a hybrid app on a variety of devices is fairly simple:

![](https://www.kirupa.com/apps/images/webview_hybrid_everywhere_200.png)

When you make an update to your web app, the change will be instantly available to all devices that use it since the content is coming from one centralized location, your server:

![](https://www.kirupa.com/apps/images/webview_hybrid_everywhere_updated_200_2.png)

If you had to deal with a pure native app, not only would have you have to update the project for each platform you built the app for, you may have to go through the time-consuming app certification process in order to make your update available via all of the app stores. From a deployment and updating point of view, hybrid apps are very convenient. Combine this convenience with native device access that gives your web apps superpowers, you have a winning technical solution. The WebView makes it all possible.

### Native App Extensions

The last big category you'll see WebViews used in has to do with extensibility. Many native apps, especially on the desktop, provide a way for you to extend their functionality by installing an add-in or extension. Because of how easy and powerful web technologies are, these add-ins and extensions are often built in HTML, CSS, and JavaScript instead of C++, C#, or whatever. One popular example of this is Microsoft Office. The various apps that make up Microsoft Office are as native and old-school as you can get, but one of the ways you can build extensions for them involves web technologies. For example, a popular such extension is the [the Wikipedia app](https://appsource.microsoft.com/en-us/product/office/WA104099688?tab=Overview):

![](https://www.kirupa.com/apps/images/wikipedia_window2.PNG)

The way these web-based extensions like the Wikipedia one are surfaced inside an Office app like Word is through...yep, a WebView:

![](https://www.kirupa.com/apps/images/word_wikipedia_2.png)  

The actual content shown inside the WebView comes from [this URL](https://wikipedia.firstpartyapps.oaspapps.com/wikipedia/wikipedia_dev.html). When you visit that page in the browser, you don't really see a whole lot. It is the intersection between the native app functionality and web code functionality (exposed via the WebView) that makes the full experience work. As a user of the Wikipedia extension inside the Word app, you may never question what is going on under the covers because the functionality is nicely integrated and **_just works_**.

## WebViews (Usually) Aren't Special

WebViews are pretty awesome. While it may look like they are entirely special and unique beasts, remember, they are nothing more than just a browser positioned and sized inside your app without any of their fancy UI thrown in there. There is more to it, but that's the gist of it. For most purposes, you don't have to specially test your web app inside a WebView unless you are calling native APIs. Otherwise, the functionality between what you see inside a WebView is the same as what you would see in the browser, especially if you match the rendering engines:

1.  On iOS the web rendering engine is **_always_** WebKit, the same one that powers Safari...and Chrome. Yes, you read that correctly. Chrome on iOS actually uses WebKit under the covers.
2.  On Android, the rendering engine under the covers is _**usually**_ Blink, the same one that powers Chrome.
3.  On Windows, Linux, and macOS, since these are the more permissive desktop platforms, there is a lot of flexibility in choosing the WebView flavor and rendering engine used under the covers. The popular rendering engines you see will be Blink (Chrome) and Trident (Internet Explorer), but there is no one engine that you can rely on. It all depends on the app and what WebView implementation it is using.

We can spend more time looking at WebViews and going even deeper into some of the specialized behavior they provide, but that gets us a little too into the weeds. For what we are trying to do here, staying on the roads and having a broad view of what WebViews are is just right...for now.

If you have a question about this or any other topic, the easiest thing is to drop by [our forums](http://forum.kirupa.com) where a bunch of the friendliest people you'll ever run into will be happy to help you out!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
