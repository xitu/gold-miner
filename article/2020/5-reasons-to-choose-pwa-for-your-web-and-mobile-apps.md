> * 原文地址：[5 Reasons to Choose PWA for Your Web and Mobile Apps](https://blog.bitsrc.io/5-reasons-to-choose-pwa-for-your-web-and-mobile-apps-515c6d0e784d)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga87)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-to-choose-pwa-for-your-web-and-mobile-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-to-choose-pwa-for-your-web-and-mobile-apps.md)
> * 译者：
> * 校对者：

# 5 Reasons to Choose PWA for Your Web and Mobile Apps

![Photo by **[Lisa Fotios](https://www.pexels.com/@fotios-photos) on [Pixels](https://www.pexels.com/)**](https://cdn-images-1.medium.com/max/12000/1*tNa6Nnn7Ffq8uDEomL_pWw.jpeg)

I’m sure that most of you must have heard about Progressive Web Apps (PWAs). PWA is an exciting piece of technology that has the potential of transforming the way we develop web and mobile apps. However, some may say that PWA is just a website that is converted to a mobile app while some are arguing about its capabilities, security issues, and performance over native mobile apps.

So, In this article, I will explain five valuable features of PWA, useful for your future web and mobile apps.

---

## 1. Single Technology for Web and Mobile Platforms

In the modern technical world, we can see that developers have branded themselves as web developers, mobile developers, etc.

Looking at the reasons, we can see that technologies, tools, and different platforms have been playing a significant part in this division.

If we take native app development as an example, it requires knowledge about a few specialized technologies such as Java, Kotlin, Swift, Flutter, etc., and toolkits like Android Studio, XCode, etc.

![Screenshot by Auther (Source — [StackOverflow](https://insights.stackoverflow.com/survey/2019#technology))](https://cdn-images-1.medium.com/max/2000/1*ugxSh7SYNtRB_CmJD_gn_A.png)

In contrast, it’s easy to get going with JavaScript/TypeScript, HTML, CSS, and use a framework like Angular or a library like React. If we looked at the [survey result from stack overflow in 2019](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted), we could see that those web development languages are the most popular ones.

These results influence the technology adoption by developers, and as a result, it’s easier to find developers on the web track.

#### Reduce Development Costs, Deliver Faster

Using the same stack for Native and Web is not only a way to avoid learning new languages and frameworks, but it is also a way to reuse code as much as possible.

By sharing and managing your reusable components/modules in [cloud component hubs](https://bit.dev/frontend-teams), you’re able to focus on composing awesome apps instead of wasting your time building from scratch for multiple technologies and platforms.

![Example: React components shared and managed on [Bit.dev](https://bit.dev/frontend-teams)](https://cdn-images-1.medium.com/max/2000/1*Nj2EzGOskF51B5AKuR-szw.gif)
[**Bit · UI component library for frontend teams**
**Organize all your shared components in your team's hub, making them easy to find, choose and use in your apps. Found…**bit.dev](https://bit.dev/frontend-teams)

## 2. Reliable Performance

Being fast, reliable, and engaging are some significant features we can see in PWAs. Application Shell Architecture is one of the best approaches to achieve those features. This architecture provides fast, reliable performance to users even they are on a slow connection or offline. Let’s see what’s are the main advantage of this architecture.

![Shell vs. Content Structure](https://cdn-images-1.medium.com/max/4000/0*Fi5V2irPUGri9v-D)

If we follow application shell architecture, we can divide the application into two main parts as **Shell** and **Content.** Minimum app content required to initiate user interface is called Shell, and other dynamic parts that need an internet connection are called content. So this shell is responsible for providing fast, reliable user experience for users by caching its content to be used in offline environments. This approach is perfect for single-page applications, and it offers economical data usage, reliable and fast performance, native interaction experience to users.

## 3. Provides Best User Experience using Service Workers

If you are a web developer, I’m sure you must have used or heard about Service Workers. Service Worker runs in the background of your web application and handles a large number of tasks that don’t need user’s attention. These service workers are often used in new web apps and also can be used in Progressive Web Apps as well. Let’s look at the main features Service Workers offers for PWAs.

#### Working Offline

Being able to work offline is one of the competitive features of PWA compared to native apps, and PWA acquires this ability because of service workers. With Service Workers, you can cache the application Shell, and it will load instantly when the user visits back. These background operations allow improving the user experience of the application since the user won’t see any significant differences between online and offline modes. But the dynamic content will only be refreshed when there is a connection. For example, we can take telegram, which is a messaging platform. The application will open as usual, and you will be able to see and read previous chat, even when you are offline. The application will refresh with new messages once you are online.

#### Background Sync

Background sync is another feature provided by Service Workers, and this allows the application to respond to any critical request when the connection is available, even you make that call during offline mode. For example, if you send a message when you are offline service worker will take care of that and complete that request when the connection is available. Demo implementation of background sync is shown below:

```
navigator.serviceWorker.register('/service_worker.js');

navigator.serviceWorker.ready.then(function(swRegistration) {
  return swRegistration.sync.register('backGroundSync');
});

self.addEventListener('sync', function(event) {
  if (event.tag == 'backGroundSync') {
    event.waitUntil(yourFunction());
  }
});
```

As I mentioned earlier, the service worker is used as the event target to make background sync work even when the application is closed. `yourFunction()` will return a promise it will indicate the status of the activity as success or failure. If it’s a success, background sync is completed and if it is a failure, another sync will be scheduled later. Also, please note that `yourFunction()` name should be unique for a given sync.

Apart from these two, there are many features provided by Service Workers to PWAs like receiving Push Notifications even when the app is not active, caching network requests, caching static contents, etc.

## 4. Native App Look and Feel

If we take a simple explanation, the web app manifest is the JSON file responsible for the native look of the progressive web app. If we install an application from the play store or app store, we can see an app icon on our mobile phone, and it makes users more interactive with mobile apps rather than websites. For PWA, the web app manifest file is the entry point for all user interactions, and all the metadata about how we display the application to the user is included in here. Using this JSON file, we can easily change many elements of the application, including app icons, theme colors, orientation, and splash screen. Let’s talk a bit more about those properties using an example.

```
{
  "name": "My Example App",
  "short_name": "My App",
  "start_url": ".",
  "display": "standalone"  
  "background_color": "#ffffff",
  "theme_color": "red"
  "description": "Demo App.",
  "orientation": "portrait-primary",
  "icons": [{
    "src": "images/logo.png",
    "sizes": "48x48",
    "type": "image/png"
  } ... ],
  "related_applications": [{
    "platform": "play",
    "url": "https://play.google.com/store/apps/details?..."
  }]
}
```

Simple web manifest JSON file will look like the above example and **name, short_name** properties are used for the applications display name. Here, the **icons’ property** contains a list of app icons in different sizes. **display** property can have fullscreen, standalone, minimal-UI, browser vales, and fullscreen mode removes all browser elements and provides the best native feeling to your application. **start_url** defines the page loaded when the user launches your progressive web app from their home screen. Apart from these, there are many properties that you can use to bring the native feeling to your PWA. The most important thing is as a developer, you have complete control over the starting process of the application, and you can easily compete with native apps using these properties.

## 5. Enhance Security and Transparent Access to Device Capabilities

Security is another significant aspect that we need to consider. With the increase of security incidents happening around the globe, users are concerned about the security of their data devices from malicious attacks more than ever. So we as developers have to establish security best practices with any technology we select to avoid these issues. So let’s see how we can ensure security to our users with PWA.

PWA enforces transport layer security. So, users, sensitive information will be encrypted during transmission, and data can only be decrypted using a private key stored in the server. Due to this reason, the website of the PWA should be served using HTTPS, and installing an SSL certificate in the server is a must.

Also, PWA does not interact with the device hardware without users’ permission, and it is not easy to hide any malicious codes inside PWA applications. If we follow the best practices to request only the necessary access to the device and use trusted JavaScript libraries kept up to date, the risk becomes significantly lower.

---

## Conclusion

In addition to those 5, PWA contains many qualities that we expect from any web or mobile application like speed, reliability, user experience, etc. As developers, it is easy to develop PWA since you don’t have a burden about languages and frameworks. PWA takes very little time to develop when compared to native app development.

On the business side, the cost will be less, the market reach will be high and can be optimized very quickly in search engines if you decided to go with PWA. So don’t hesitate to try PWA when you seek for a web or mobile solution next time.

## Learn More
[**Build Scalable React Apps by Sharing UIs and Hooks**
**How to build scalable React apps with independent and shareable UI components and hooks.**blog.bitsrc.io](https://blog.bitsrc.io/build-scalable-react-apps-by-sharing-uis-and-hooks-fa2491e48357)
[**14 JavaScript Code Optimization Tips for Front-End Developers**
**Tips and tricks to increase performance and website load time**blog.bitsrc.io](https://blog.bitsrc.io/14-javascript-code-optimization-tips-for-front-end-developers-a44763d3a0da)
[**5 Service Worker Caching Strategies for Your Next PWA App**
**There are ways or strategies we can use in Service Workers to respond to “fetch” events. These strategies determine how…**blog.bitsrc.io](https://blog.bitsrc.io/5-service-worker-caching-strategies-for-your-next-pwa-app-58539f156f52)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
