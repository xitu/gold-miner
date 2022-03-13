> * 原文地址：[Effects of Too Much Lazy Loading on Web Performance](https://blog.bitsrc.io/effects-of-too-much-lazy-loading-on-performance-4dbe8df33c37)
> * 原文作者：[Yasas Sri Wickramasinghe](https://medium.com/@yasassri)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/effects-of-too-much-lazy-loading-on-web-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2022/effects-of-too-much-lazy-loading-on-web-performance.md)
> * 译者：[tong-h](https://github.com/Tong-H)
> * 校对者：[Isildur46](https://github.com/Isildur46) [xionglong58](https://github.com/xionglong58)

# 过度使用懒加载对 Web 性能的影响

![](https://cdn-images-1.medium.com/max/5856/0*u6JBhsu5xQWO8ZfH.jpg)

如今为了提升应用性能，懒加载被广泛使用于 Web 应用中。它帮助开发者减少网站加载时间，节省流量以及提升用户体验。

但懒加载的过度使用会给应用性能带来负面影响。所以在这篇文章中，我会详述懒加载对性能的影响，来帮助你理解应该何时使用它。

## 什么是懒加载？

![](https://cdn-images-1.medium.com/max/4320/0*CUGBWo-mhr1DT-wY.png)

懒加载是一种常见的技术，通过按需加载资源来减少网页的数据使用。

如今懒加载已经是一种 Web 标准，大部分的主流浏览器都支持通过  `loading="lazy"` 属性使用懒加载。

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

一旦启用懒加载，只有当用户滚动到需要该内容显示的地方才会去加载。

![**懒加载是如何工作的**](https://miro.medium.com/proxy/1*hG44JzeROyaiqZteU6Kr8A.gif)

如你所见，懒加载肯定可以提升应用性能以及用户体验，这也是为什么它已成为开发者在开发应用时的首选优化措施。

但懒加载并不总是保证提升应用性能。那么让我们看看懒加载对性能的影响到底是什么。

## 懒加载对性能的影响

许多研究表明，开发者通过懒加载可以实现两种优势。

* **减少页面加载时间（PLT）：**通过延迟资源加载减少首屏页面加载时间。
* **优化资源消耗：**通过资源懒加载优化系统资源使用，这在内存以及处理能力较低的移动设备上效果比较好。

在另一方面，过度使用懒加载会对性能产生一些明显的影响。

### 减慢快速滚动的速度

如果你有一个 Web 应用，比如在线商店，你需要让用户可以快速上下滚动以及导航。

对这样的应用使用懒加载会减慢滚动速度，因为我们需要等待数据加载完成。这会降低应用性能以及引发用户体验问题。

### 因为内容变化而导致的延迟

如果你还没有为懒加载的图片定义的 `width` 和 `height` 属性，那么在图片渲染过程中会出现明显的延迟。因为资源在页面初始化时没有加载，浏览器不知道适用于页面布局的内容尺寸。

一旦内容加载完成，而用户滚动到特定视图中，浏览器需要处理内容以及再一次改变页面布局。这会使其他元素移位，也会带来糟糕的用户体验。

### 内容缓冲

如果你在应用中使用非必要的懒加载，这会导致内容缓冲。当用户快速向下滚动而资源却还在下载中时会发生这种情况。

尤其是带宽连接较慢时会发生这种情况，这会影响网页渲染速度。

## 应该何时使用懒加载

你现在肯定在想如何合理使用懒加载，使其发挥最大的效果从而创造更好的 Web 性能。

下面的一些建议有助于找到最佳着手点。

### 1. 在正确的地方懒加载正确的资源

如果你有一个需要很多资源的冗长的网页，那你可以考虑使用懒加载，但只能针对用户视图外或者被折叠的内容使用。

![](https://cdn-images-1.medium.com/max/2410/0*xq-umzzOZLKPagKn.png)

确保你没有懒加载后台任务执行所需的资源，比如 JavaScript 组件，背景图片或者其他多媒体内容。而且，你一定不能延迟这些资源的加载。

你可以使用谷歌浏览器的 Lighthouse 工具来检查，识别那些可添加懒加载属性的资源。

### 2. 懒加载那些不妨碍网页使用的内容

懒加载最好是用于不重要的非必需的 Web 资源。另外，如果资源没有像预期那样懒加载，那么不要忘记错误处理和提供良好的用户体验。

请注意，原生懒加载依然没有被所有平台和浏览器普遍支持。而且，如果你在使用一个库或者自定义的 JavaScript 脚本，那么这不会对所有用户都生效。尤其，那些禁止 JavaScript 的浏览器会面临懒加载技术上的问题。

### 3. 懒加载对搜索引擎优化（SEO）而言不重要的资源

随着内容懒加载，网站将逐渐渲染，这也就是说，某些内容在首屏加载时并不可用。咋一听，好像是懒加载有助于提升 SEO 网页排名，因为它使页面加载速度大大加快。但如果你过度使用懒加载，会产生一些负面影响。

当 SEO 索引时，搜索引擎爬行网站抓取数据以便索引页面，但由于懒加载，网络爬虫无法获取所有页面数据。除非用户与页面进行互动，这样 SEO 就不会忽略这些信息。

但作为开发者，我们并不希望 SEO 遗漏我们重要的业务数据。所以我建议不要将懒加载用在针对 SEO 的内容上，比如关键词或者业务信息。

## 总结

懒加载可以提升网页使用率以及性能，对 Web 开发者而言是一个称手的工具。所谓“过度烹饪烧坏汤”，过度使用这项技术也会降低网站性能。

在这篇文章中，我们关注懒加载对性能的影响，通过几个建议帮助你理解应该何时使用它。如果你谨慎的使用这项技术，明白何时何地使用它，你的网站会得到明显的性能提升。

希望你有从中得到有用的知识点，感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
