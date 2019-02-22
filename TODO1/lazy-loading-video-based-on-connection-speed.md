> * 原文地址：[Lazy Loading Video Based on Connection Speed](https://medium.com/dailyjs/lazy-loading-video-based-on-connection-speed-e2de086f9095)
> * 原文作者：[Ben Robertson](https://medium.com/@bgrobertson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-loading-video-based-on-connec
tion-speed.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-loading-video-based-on-connec
tion-speed.md)
> * 译者：
> * 校对者：

# Lazy Loading Video Based on Connection Speed

A large video hero can be a neat experience when done well — but adding video capability to the homepage is just asking for somebody to go in and add a 25mb video and throw all your performance optimizations out the window.

![](https://cdn-images-1.medium.com/max/800/1*FAfkN32_GGB-8qyJOXYtKQ.jpeg)

Lazy pandas love lazy loading. (Photo by [Elena Loshina](https://unsplash.com/photos/94c2BwxqwXw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText))

I’ve been on a few teams who wanted to do one of those full-screen background videos on the home page. And I’m usually not too thrilled to do it because how often they turn into performance nightmares. I’m embarrassed to say, there was once a day I put a ***40mb*** background video on a page. 😬

The last time someone asked me to do it, I got curious about how I could treat the background video as a *progressive enhancement* for users on connections that could handle a potentially large download. I made sure to emphasize to our team the importance of a small, compressed video file, but I also wanted some programmatic magic to happen too.

**Here’s a breakdown of the solution I ended up with:**

1. Try loading the `<source>` with JavaScript
2. Listen for the `canplaythrough` event.
3. Use `Promise.race()` to timeout the source loading if the `canplaythrough` event doesn’t fire within 2 seconds.
4. Remove the `<source>` and cancel the video loading if we don’t detect the `canplaythrough` event.
5. Fade the video in if we do detect the `canplaythrough` event.

### The Markup

The main thing to note in my video markup is that even though I am using the `<source>` elements inside the `<video>`, I have not set the `src` attribute for either of the sources. If you set the `src` attribute, the browser automatically finds the first `<source>` it can play and immediately starts downloading it.

Since the video is a progressive enhancement in this example, we don’t need or want the video to load by default. In fact, the only thing that will load is the poster, which I have set to be the featured image of the page.

```javascript
  <video class="js-video-loader" poster="<?= $poster; ?>" muted="true" loop="true">
    <source data-src="path/to/video.webm" type="video/webm">
    <source data-src="path/to/video.mp4" type="video/mp4">
  </video>
```

### The JavaScript

I wrote a small JavaScript class that looks for any video that has a `.js-video-loader` class on it so that we could reuse this logic in the future for other videos. [The full source is available on Github](https://gist.github.com/benjamingrobertson/00c5b47eaf5786da0759b63d78dfde9e).

Here’s the constructor:

```javascript
  constructor () {
    this.videos = Array.from(document.querySelectorAll('video.js-video-loader'));
    // Abort when:
    // - The browser does not support Promises.
    // - There no videos.
    // - If the user prefers reduced motion.
    // - Device is mobile.
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

What we are doing in here is finding all the videos on the page that we want to lazy load. If there are none, we can return. I also don’t want to load the video if the user has stated their [preference for reduced motion](https://css-tricks.com/introduction-reduced-motion-media-query/). And to not worry about mobile connection speed and/or phones with low graphics ability, I’m also returning for small screens. (I’m thinking now I could have done this with media queries in the `<source>` elements, but I’m not sure.)

Then I run our video loading logic for each video.

#### loadVideo

`loadVideo()` is a small function that calls some other functions:

```javascript
  loadVideo(video) {
    this.setSource(video);
    // Reload the video with the new sources added.
    video.load();
    this.checkLoadTime(video);
  }
```

#### setSource

`setSource()` is where we find the sources that we included as data attributes and add them as proper `src` attributes.

```javascript
  /**
    * Find the children of the video that are <source> tags.
    * Set the src attribute for each <source> based on the
    * data-src attribute.
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

Basically what I am doing is looping through each child of the `<video>` element. I only want to find children that are `<source>` elements and that have a `data-src` attribute defined (`child.dataset.src`). If both of those conditions are met, we use `setAttribute` to set the `src` attribute of the source.

Now that video element has its sources set, we need to tell the browser to try loading the video again. We did this above in our `loadVideo()` function, with `video.load()`. `load()` is part of the [HTMLMediaElement API](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement) that resets the media element and restarts the loading process.

#### checkLoadTime

Next up is where the magic happens. In `checkLoadTime()` I create two Promises. The first Promise resolves when the `<video>` element fires the [canplaythrough](https://developer.mozilla.org/ro/docs/Web/Events/canplaythrough) event. This event is fired when the browser thinks it can play the media without stopping to buffer. To do this, we add an event listener in the Promise, and `resolve()` only if the event is triggered.

```javascript
  // Create a promise that resolves when the
  // video.canplaythrough event triggers.
  let videoLoad = new Promise((resolve) => {
    video.addEventListener('canplaythrough', () => {
      resolve('can play');
    });
  });
```

We also create another promise that functions as a timer. Inside the Promise, we use `setTimeout` to resolve the Promise after an arbitrary time limit. For my purposes, I set a timeout of 2 seconds (2000 milliseconds).

```javascript
  // Create a promise that resolves after a
  // predetermined time (2sec)
  let videoTimeout = new Promise((resolve) => {
    setTimeout(() => {
      resolve('The video timed out.');
    }, 2000);
  });
```

Now that we have two Promises, we can race them against each other to find out which one finishes first. `Promise.race()` accepts an array of promises and we pass in the promises we created above to this function.

```javascript
  // Race the promises to see which one resolves first.
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

In our `.then()` we are looking to receive the data from the Promise that resolves first. I send the string ‘can play’ through if the video can play, so I am checking against that to see if we can play the video. `video.play()` uses the HTMLMediaElement `play()` function to trigger the video to play.

The `setTimeout()` function adds the `.video-loaded` class after 3 seconds to help the finesse the fade-in animation and the autoplay loop.

If we don’t receive the `can play` string, then we want to cancel the loading of the video.

#### cancelLoad

The `cancelLoad()` method basically does the opposite of our `loadVideo()` function. It removes the `src` attribute from each `<source>` and then triggers `video.load()` to reset the video element.

If we didn’t do this, the video would keep loading in the background even though we aren’t displaying it.

```javascript
  /**
    * Cancel the video loading by removing all
    * <source> tags and then triggering video.load().
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
      // reload the video without <source> tags so it
      // stops downloading.
      video.load();
    }
```

### Wrap Up

The downfall of this method is that we are still attempting to download a potentially large file over a potentially poor connection, but by providing a timeout, I’m hoping to save data and recoup some performance for users on slow connections. In my tests in the Chrome Dev Tools throttled down to a Slow 3G connection, this logic ends up loading <512kb of the video before the timeout fires. Even with a 3–5mb video, this is still a significant saving for users on a slow connection.

What do you think? I’d love to hear suggestions for how to improve this in the comments!

*Interested in learning about how to make your JavaScript more accessible? Checkout my* [*4 tips for writing accessible JavaScript*](https://benrobertson.io/accessibility/javascript-accessibility)

- - -

*Originally published at* [*benrobertson.io*](https://benrobertson.io/front-end/lazy-load-connection-speed).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
