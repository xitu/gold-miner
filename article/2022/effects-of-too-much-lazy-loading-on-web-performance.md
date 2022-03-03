> * 原文地址：[Effects of Too Much Lazy Loading on Web Performance](https://blog.bitsrc.io/effects-of-too-much-lazy-loading-on-performance-4dbe8df33c37)
> * 原文作者：[Yasas Sri Wickramasinghe](https://medium.com/@yasassri)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/effects-of-too-much-lazy-loading-on-web-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2022/effects-of-too-much-lazy-loading-on-web-performance.md)
> * 译者：
> * 校对者：

# Effects of Too Much Lazy Loading on Web Performance

![](https://cdn-images-1.medium.com/max/5856/0*u6JBhsu5xQWO8ZfH.jpg)

Today, lazy loading is widely used in web applications to improve application performance. It helps developers reduce loading times, optimize data usage and improve the user experience.

However, overusing lazy loading can affect the application performance negatively. So, in this article, I will discuss the performance effects of lazy loading to help you understand when to use it.

## What is Lazy Loading?

![](https://cdn-images-1.medium.com/max/4320/0*CUGBWo-mhr1DT-wY.png)

Lazy-loading is a handy technique to reduce the data consumption of a webpage by temporarily deferring resource fetching until the required resources are needed.

Nowadays, this is a web standard, and most of the major web browsers support lazy loading by using the `loading="lazy"` attribute.

```html
// with img tag

<img 
  src="bits.jpeg" 
  loading="lazy" 
  alt="an image of a laptop" 
/>



// with IFrame

<iframe 
  src="about-page.html" 
  loading="lazy">
</iframe>
```

Once the lazy loading is enabled, the content will only be displayed when the user scrolls to where the content is required to show.

![**How lazy-loading works**](https://miro.medium.com/proxy/1*hG44JzeROyaiqZteU6Kr8A.gif)

As you can see, lazy loading surely improves the application performance and user experience. That’s why developers choose lazy-loading as an obvious choice for their applications.

However, lazy loading does not always guarantee to improve the application’s performance. So, let’s see what the performance effects of lazy loading are.

## Performance Effects of the Lazy Loading

According to many studies, there are two main advantages that any developer can achieve by lazy loading.

* **Reduced page load time (PLT):** We can reduce the initial page load time by delaying the resource loading.
* **Resource usage optimization:** By lazy loading resources, we can optimize the system resource usage. This works well with mobile devices with lower memory and processing capabilities.

On the other hand, some significant performance impacts can occur if we overuse lazy loading.

### Slows down quick scrolling

If you have a web application such as an online store, you need to allow users to scroll up down quickly and navigate.

Using lazy loading for such applications can slow down the scrolling experience since we need to wait until the data loads. This will decrease the application performance and cause user experience issues.

### Delays due to content shifting

If you have not defined the image width and height properties for lazy loading images, noticeable delays can occur during the image rendering process. Since the resources are not downloading at the initial page load, the browser cannot know the content size to fit into the page layout.

Once the resource is loaded, and a user is scrolled to that particular viewport, the browser needs to process the content and change the page’s layout again. This will cause other elements to shift and bring about a bad user experience.

### Content buffering

If you have used lazy loading unnecessary in your application, it can cause content buffering. This happens when the users scroll down fast while the resources are still downloading.

This situation can occur especially for slow bandwidth connections, and it will impact the speed of webpage rendering.

## When to use the Lazy Loading Technique

Now, you must be thinking about how to decide the right amount of lazy loading to get the best out of it with better web performance.

The following suggestions will be helpful to find the sweet spot.

### 1. Lazy loading right resources at right place

If you have a lengthy webpage with many resources, you can consider adding lazy loading. However, add lazy loading only for the content below the fold or outside the users’ viewpoint.

![](https://cdn-images-1.medium.com/max/2410/0*xq-umzzOZLKPagKn.png)

Make sure that you never Lazy-load any resource required to execute background tasks. For example, it can be a JavaScript component, background image, or other multimedia content. Further, you must not delay the loading for those.

You can use the Lighthouse tool of Chrome browser to perform an audit and identify possible resources to add the Lazy-loading attribute.

### 2. Lazy-load contents which are not blockers to use the web page

It is always better to try lazy loading for non-critical web resources instead of the essential ones. And also, don’t forget to have error handling and a good user experience if the resource does not lazy load as expected.

Please note that native lazy loading is still not universally supported by all platforms and browsers. Moreover, if you are using a library or JavaScript custom implementation, it will not work for all users. Especially, the JavaScript-disabled browsers will face issues with this technique.

### 3. Lazy load contents which are not important for Search Engine Optimization (SEO)

With lazy loading of the content, your website will render gradually. That is to say, some of the content is not available at the initial page load. At a glance, it may sound like lazy loading helps improve the SEO page rank because it makes your page load so much faster. But, if you are overusing the lazy loading, there is a negative impact.

When SEO indexing is in progress, search engines crawl the site to find website data for indexing the page. But due to lazy loading, web crawlers can’t see all the page data. Because they are not available unless a user interacts with the page. Therefore, that information will not be ignored for SEO.

As developers, we do not want our essential business data to be missed out for SEO. So I recommend not to use lazy loading for SEO-targeted content like keywords and business information.

## Conclusion

Lazy loading is a smart tool for web developers to improve the usability and performance of a webpage. However, just like “too many cooks spoil the soup,” overusing this technique can reduce the site’s performance.

In this article, I have focussed your attention on the performance impact of lazy loading with some suggestions to understand when to use it. If you use this technique with care, knowing when and where to use it, you will achieve significant performance.

I hope you have found this article helpful. Thank you for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
