> * 原文地址：[Lazy Loading Video Based on Connection Speed](https://medium.com/dailyjs/lazy-loading-video-based-on-connection-speed-e2de086f9095)
> * 原文作者：[Ben Robertson](https://medium.com/@bgrobertson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-loading-video-based-on-connection-speed.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-loading-video-based-on-connection-speed.md)
> * 译者：[SHERlocked93](https://github.com/SHERlocked93)
> * 校对者：

# 根据网络速度进行视频播放懒加载

一个大的视频背景 Banner 有时候是一个不错的选择，但是大部分情况下，增加视频功能意味着给首页加一个 25mb 大小的视频，不管是不是给性能带来了消极影响。

![](https://cdn-images-1.medium.com/max/800/1*FAfkN32_GGB-8qyJOXYtKQ.jpeg)

Lazy pandas love lazy loading. (Photo by [Elena Loshina](https://unsplash.com/photos/94c2BwxqwXw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText))

我参加过一些团队，他们希望给首页加上类似的全屏视频背景。我一般不会开心的太早，因为这种做法通常会导致性能上的噩梦。老实说，我曾干过给一个页面加上一个 **40mb** 大的视频。 😬

上次有人让我这么做的时候，我很好奇当用户处于面临视频加载这个潜在的较大下载量的场景时，我到底应如何对这个背景视频的**渐进增强**问题呢。我跟我的组员们着重强调视频文件体积小、经过压缩的重要性，但是有时候我也期待一些编程上的 Hack。

**下面是最终的解决方案：**

1. 尝试使用 JavaScript 加载 `<source>`
2. 监听 `canplaythrough` 事件
3. 如果 `canplaythrough` 事件没有在 2 秒内触发，那么使用 `Promise.race()` 将视频加载超时 
4. 如果没有监听到 `canplaythrough` 事件，那么移除 `<source>`，并且取消视频加载
5. 如果监测到 `canplaythrough` 事件，那么淡入这个视频

### 标记

这里要注意的问题是，即使我在 `<video>` 标签中使用了 `<source>`，但我还没为这些 `<source>` 设置 `src` 属性。如果设置了 `src` 属性，那么浏览器会自动地找到它可以播放的第一个 `<source>`，并立即开始下载它。

Since the video is a progressive enhancement in this example, we don’t need or want the video to load by default. In fact, the only thing that will load is the poster, which I have set to be the featured image of the page.因为这是一个渐进增强的例子，我们不需要也不想要真的去加载视频。事实上，唯一需要加载的是海报图，就是我们要设置为这个页面的预览图片。

```html
  <video class="js-video-loader" poster="<?= $poster; ?>" muted="true" loop="true">
    <source data-src="path/to/video.webm" type="video/webm">
    <source data-src="path/to/video.mp4" type="video/mp4">
  </video>
```

### JavaScript

我编写了一个简单的 JavaScript 类，用于查找带有 `.js-video-loader` 这个 CSS 类的页面元素，让我们以后可以在其他视频中复用这个逻辑。[完整的源码可以从 Github 上看到](https://gist.github.com/benjamingrobertson/00c5b47eaf5786da0759b63d78dfde9e)。

构造函数是这样的：

```javascript
  constructor () {
    this.videos = Array.from(document.querySelectorAll('video.js-video-loader'));
    // 将在下面情况下返回
    // - 浏览器不支持 Promise
    // - 没有 video 元素
    // - 如果用户设置了 prefers reduced motion
    // - 在移动设备上
    if (typeof Promise === 'undefined'
      || !this.videos
      || window.matchMedia('(prefers-reduced-motion)').matches
      || window.innerWidth < 992
    ) {
      return;
    }
    this.videos.forEach(this.loadVideo.bind(this));
  }
```

这里我们所做的就是找到这个页面上所有我们希望懒加载的视频。如果没有，我们可以返回。当用户开启了[减少运动（preference for reduced motion）](https://css-tricks.com/introduction-reduced-motion-media-query/)设置时，我们同样不会懒加载这样的视频。为了不让某些低网速或低图形处理能力的手机用户担心，在小屏幕手机上也会直接返回。（我在考虑是否可以通过 `<source>` 元素的媒体查询来做这些，但也不确定。）

然后给每个视频运行这个视频加载逻辑。

#### loadVideo

`loadVideo()` 是一个调用其他函数的简单的函数：

```javascript
  loadVideo(video) {
    this.setSource(video);
    // 加上了视频链接后重新加载视频
    video.load();
    this.checkLoadTime(video);
  }
```

#### setSource

在 `setSource()` 中，我们找到那些作为数据属性（Data Attributes）插入的视频链接，并且将它们设置为真正的 `src` 属性。

```javascript
  /**
    * 找 video 子元素中是 <source> 的，
    * 基于 data-src 属性，
    * 给每个 <source> 设置 src 属性
    *
    * @param {DOM Object} video
    */
    setSource (video) {
      let children = Array.from(video.children);
      children.forEach(child => {
        if (child.tagName === 'SOURCE' && typeof child.dataset.src !== 'undefined') {
          child.setAttribute('src', child.dataset.src);
        }
      });
    }
```

基本上，我所做的就是遍历每一个 `<video>` 元素的子元素，找一个定义了 `data-src` 属性（`child.dataset.src`）的 `<source>` 子元素。如果找到了，那就用 `setAttribute` 将它的 `src` 属性设置为视频链接。

现在视频链接已经被设置给 `<video>` 元素了，下面需要让浏览器再次加载视频。我们通过在 `loadVideo()` 中的 `video.load()` 来完成这个工作。`load()` 方法是 [HTMLMediaElement API](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement) 的一部分，它可以重置媒体元素并且重启加载过程。 

#### checkLoadTime

接下来是见证奇迹的时刻。在 `checkLoadTime()` 方法中我们创建了两个 Promise。第一个 Promise 将在 `<video>` 元素的 [canplaythrough](https://developer.mozilla.org/ro/docs/Web/Events/canplaythrough)  事件触发时被 `resolve`。这个 `canplaythrough` 事件是浏览器认为这个视频可以在不停下来缓冲的情况下持续播放的时候被触发。我们在这个 Promise 中添加一个这个事件的监听回调，当这个事件触发的时候执行 `resolve()`。

```javascript
  // 创建一个 Promise，将在
  // video.canplaythrough 事件发生时被 resolve
  let videoLoad = new Promise((resolve) => {
    video.addEventListener('canplaythrough', () => {
      resolve('can play');
    });
  });
```

我们同时创建另一个 Promise 作为计时器。在这个 Promise 中，当经过一个设定好的时间后，我们使用 `setTimeout` 来将这个 Promise 给 resolve 掉，我这事呢一个 2 秒的时延（2000毫秒）。   

```javascript
  // 创建一个 Promise 将在
  // 特定时间(2s)后被 resolve
  let videoTimeout = new Promise((resolve) => {
    setTimeout(() => {
      resolve('The video timed out.');
    }, 2000);
  });
```

现在我们有了两个 Promise，我们可以通过 `Promise.race()` 看他们谁先完成。

```javascript
  // 将 promises 进行 Race 看看哪个先被 resolves
  Promise.race([videoLoad, videoTimeout]).then(data => {
    if (data === 'can play') {
      video.play();
      setTimeout(() => {
        video.classList.add('video-loaded');
      }, 3000);
    } else {
      this.cancelLoad(video);
    }
  });
```

在这个 `.then()` 的回调中我们等着拿到最先被 `resolve` 的那个 Promise 传回来的信息。如果这个视频可以播放，那么我就会拿到之前传的 `can play`，然后试一下是否可以播放这个视频。`video.play()` 是使用 HTMLMediaElement 提供的 `play()` 方法来触发视频播放。

3 秒后，`setTimeout()` 将会给这个标签加上 `.video-loaded` 类，这将有助于实现淡入的特效自动循环播放。

如果我们没接收到 `can play` 字符串，那么我们将取消这个视频的加载。

#### cancelLoad

`cancelLoad()` 方法做的基本上跟 `loadVideo()` 方法相反。它从每个 `source` 标签移除 `src` 属性，并且触发 `video.load()` 来重置视频元素。

如果我们不这么做，这个视频元素将会在后台保持加载状态，即使我们都没将它显示出来。

```javascript
  /**
    * 通过移除所有的 <source> 来停止视频加载
    * 然后触发 video.load().
    *
    * @param {DOM object} video
    */
    cancelLoad (video) {
      let children = Array.from(video.children);
      children.forEach(child => {
        if (child.tagName === 'SOURCE' && typeof child.dataset.src !== 'undefined') {
          child.parentNode.removeChild(child);
        }
      });
      // 重新加载没有 <source> 标签的 video
      // 这样它会停止下载
      video.load();
    }
```

### 总结

这个方法的缺点是，我们仍然试图通过一个不一定靠谱的链接来下载一个可能比较大的文件，但是通过提供一个超时时间，我们希望能够给某些网速慢的用户节约一些流量并且获得更好的性能。根据我在 Chrome Dev Tools 里将网速节流到慢 3G 条件下的测试，这个方法将在超时之前加载了 512kb 的视频。即使是一个 3-5mb 的视频，对于一些网速慢的用户来说，这也带来了显著的性能提升。

你觉得怎么样？如果有改进的建议，欢迎在评论里分享！

- - -

*Originally published at* [*benrobertson.io*](https://benrobertson.io/front-end/lazy-load-connection-speed).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
