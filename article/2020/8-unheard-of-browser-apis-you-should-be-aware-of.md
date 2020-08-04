> * 原文地址：[8 Unheard of Browser APIs You Should Be Aware Of](https://medium.com/better-programming/8-unheard-of-browser-apis-you-should-be-aware-of-45247e7d5f3a)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/8-unheard-of-browser-apis-you-should-be-aware-of.md](https://github.com/xitu/gold-miner/blob/master/article/2020/8-unheard-of-browser-apis-you-should-be-aware-of.md)
> * 译者：
> * 校对者：

# 8 Unheard of Browser APIs You Should Be Aware Of

![Photo by [Szabo Viktor](https://unsplash.com/@vmxhu?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9990/0*WzOJqPzOSrcQrX5b)

With the increase in popularity, browsers started shipping APIs for complex functionalities that sometimes can only be implemented via a native application. Fast-forward to the present: It’s indeed quite rare to find a web application that doesn’t make use of at least one browser API.

As the field of web development continues to grow, browser vendors also try to keep up with the rapid development around them. They constantly develop newer APIs that can bring new nativelike functionalities to your web application. Furthermore, there are some APIs that people don’t know much about, even though they’re fully supported in modern browsers.

Here are some APIs you should be aware of — as they will play a vital role in the future.

## The Web Locks API

This [API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Locks_API) allows you to run a web application on multiple tabs to access and coordinate resource sharing. Although it’s quite uncommon for simple everyday web applications to run on multiple tabs, there can be advanced use cases where you’d need to run multiple browser tabs of a web application and keep them synced. This API can come in handy at those instances.

Although APIs such as SharedWorker, BroadcastChannel, localStorage, sessionStorage, postMessage, unload handler can be used to manage tab communication and synchronization, they each have their shortcomings and require workarounds, which decreases code maintainability. The Web Locks API tries to simplify this process by bringing in a more standardized solution.

Even though it’s enabled by default in Chrome 69, it’s still not supported by major browsers such as Firefox and Safari.

**Note:** You should know your way around concepts like **deadlocks** to avoid falling into one when using this API.

## The Shape Detection API

As a web developer, you’ve probably had many instances requiring the installation of external libraries to handle the detection of elements such as faces, text, and barcodes in images. This was because there was no web standard API for developers to utilize.

The Chrome team is trying to change this by providing an experimental [Shape Detection API](https://web.dev/shape-detection/) in Chrome browsers and making it a web standard.

Although this feature is experimental, it can be accessed locally by enabling the #enable-experimental-web-platform-features flag in `chrome://flags`.

![Photo by [Element5 Digital](https://unsplash.com/@element5digital?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9542/0*0NoSa7j_eQ1npFws)

## The Payment Request API

The [Payment Request API](https://developer.mozilla.org/en-US/docs/Web/API/Payment_Request_API) helps customers and sellers complete the checkout process more seamlessly. This new approach eliminates checkout forms and improves the user’s payment experience from the ground up. With support for Apple Pay and Google Pay, this API can be expected to be a major component in the e-commerce sector.

Furthermore, as the credentials are managed in the browser, it’s easier for the customer to switch from mobile to desktop browsers and still access their card information. This API also allows for customization from the merchant’s end. You can mention the supported payment methods and supported cards and even provide shipping options based on the shipping address.

## The Page Visibility API

It’s quite common for you to come across a PC with around 20 odd tabs opened in the browser. I once had a friend who just closed around 100+ tabs, after fixing a bug. Browsers have even started to [implement features](https://blog.google/products/chrome/manage-tabs-with-google-chrome/) to group your tabs to make them more organized.

With the help of the [Page Visibility API](https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API), you can detect whether your web page is idle or not. In other words, you can find out whether the tab that contains your web page is being viewed by the user.

Although this sounds straightforward, it can be very effective in increasing the user experience of a website. There are several use cases where this API can be used.

* Download the remainder of the application bundle resources and media resources while the browser tab is inactive. This will help you use the idle time very efficiently.
* Pause videos when the user minimizes or switches to another tab.
* Pause the image slideshow/carousal when the tab is inactive.

Although developers have used events such as `blur` and `focus` on the window in the past, they didn’t tell whether your page was actually hidden to the user. The Page Visibility API helped addresses this issue.

This browser API is compatible with most browsers.

![Source: [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API#Browser_compatibility)](https://cdn-images-1.medium.com/max/2000/1*I743ncklwG4-veVjsVFfSA.png)

## The Web Share API

The [Web Share API](https://www.w3.org/TR/web-share/) allows you to share links, text, and files to other apps installed on the device in the same way as native apps. This API can help increase user engagement with your web application. You can read this blog [post](https://web.dev/web-share/) by Joe Medley to learn more about this cool API.

As of mid-2020, this API is only available on Safari and on Android in Chromium forks. The [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share#Browser_compatibility) has more details regarding browser compatibility.

![The native Share interface. Screenshot by the author.](https://cdn-images-1.medium.com/max/2000/1*uhEtWw7OEueQkMPXrn6Akw.png)

## The Web Share Target API

Progressive web apps are changing the way we understand applications by providing an applike experience in the web form. According to the website StateOfJS, around 48.2% of users have used PWAs and 45.5% of users are aware of what PWAs are. This shows the impact of PWAs. You can read more about PWAs in my article over [here](https://medium.com/better-programming/progressive-web-apps-an-overview-c6e4328ef2d2?source=friends_link&sk=94b7cf9919c4bb86e407604dd975dadb).

Although PWAs have many nativelike features, they lacked a way to receive files from native apps. This API allows you to receive links, text, and files from other native applications. It’s supported on Chrome 76 and above for Android only. You can read more about this API over [here](https://web.dev/web-share-target/).

## The Push API

The [Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API) allows web applications to receive messages pushed to them from a server, regardless of whether the app is in the foreground or not. It can work even when the app isn’t loaded on a browser. This enables developers to deliver asynchronous notifications to the user in a timely manner. But for this to work, the user permission should be obtained prior to the API being used.

You can read more about the Push API in this awesome [article](https://flaviocopes.com/push-api/) by Flavio.

## The Cookie Store API

Working with cookies is known to be a bit slow, as it’s synchronous. But the [Cookie Store API](https://developers.google.com/web/updates/2018/09/asynchronous-access-to-http-cookies) provides asynchronous access to HTTP cookies. Furthermore, this API also exposes these HTTP cookies to service workers.

Although there are helper libraries to facilitate all of the usual cookie operations, with the Cookie Store API, it’ll be much easier and more performant. This API is also sometimes referred to as the Async Cookies API.

You can read more about this API over [here](https://wicg.github.io/cookie-store/explainer.html).

## Conclusion

I was surprised by how cool the above APIs were when I played around with them. The only letdown of the above APIs, as mentioned before, is the lack of support from major browsers. This means it’s not simple to use these in production. But it can be assured that these APIs will definitely play a vital role in the future of browsers and web development.

Thank you for reading, and happy coding.

## References

* [MDN web docs](https://developer.mozilla.org/en-US/)
* [SitePen](https://www.sitepen.com/blog/cross-tab-synchronization-with-the-web-locks-api/)
* [StateOFJS](https://2019.stateofjs.com/)
* [Creative Bloq](https://www.creativebloq.com/features/15-web-apis-youve-never-heard-of)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
