> * 原文地址：[Performance-tuning a React application](https://codeburst.io/performance-tuning-a-react-application-f480f46dc1a2)
> * 原文作者：[Joshua Comeau](https://codeburst.io/@joshuawcomeau?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/performance-tuning-a-react-application.md](https://github.com/xitu/gold-miner/blob/master/TODO/performance-tuning-a-react-application.md)
> * 译者：
> * 校对者：

# Performance-tuning a React application.

## A Case Study.

In recent weeks, I’ve been working on [**Tello**](https://tello.tv), a web app to track and manage television shows:

![](https://cdn-images-1.medium.com/max/800/1*UfHV4_HWAK4I_yGl0wSq0Q.png)

As web apps go, it’s relatively small — about 10,000 lines of code. It’s a React/Redux app, bundled by Webpack, served by a thin Node backend (using Express and MongoDB). 90% of the code is on the front-end.
Source code is available [**on Github**](https://github.com/joshwcomeau/Tello)**.**

There are a lot of aspects to web performance. Historically, I’ve focused more on the post-load front-end side of things: stuff like making sure scrolling is jank-free, and animations are smooth.

In contrast, I don’t often pay much attention to page-load time, at least not on small pet-projects. After all, there isn’t _that_ much code being shipped; it has to be pretty fast out-of-the-box, right?

After doing an initial benchmark, however, I was surprised to see that my 10k-LOC pet project was _slowwww:_ on a 3G connection, it took around 5 seconds for anything meaningful to show up, and more than _15 seconds_ for all network requests to resolve.

I realized that I needed to invest some time and energy on this problem. It doesn’t matter how beautiful my animations are if folks bail after staring at a blank white screen for 5 seconds!

All in all, I experimented with half a dozen techniques, over the course of a weekend. The end result is that the page shows meaningful content after ~2300ms — A reduction of over 50%!

This blog post is a case-study in the specific techniques I tried, and how well they worked. More broadly, though, it’s about what I learned along the way about diagnosing problems, and what my thought process was for coming up with solutions.


### Methodology

All profiling done uses the same settings:

*   “Fast 3G” throttled network speed.
*   Desktop resolution.
*   Disabled HTTP cache.
*   Logged-in, to an account with 16 tracked TV shows.

### Baseline

We need a baseline that we can compare results against!

The page we’ll be testing is the main logged-in Summary view. it’s the most data-heavy page, and so it offers the most room for optimization.

The Summary view contains a set of cards, like this:

![](https://cdn-images-1.medium.com/max/800/1*cag88WlFXxx_I452R5PEUA.png)

Each show gets its own card, and each episode gets its own square. Blue squares = seen episodes.

Here’s our baseline profile, on 3G speed. It’s… not great.

![](https://cdn-images-1.medium.com/max/800/1*116YOrGo-_hRvGUjMCieSA.png)

First Meaningful Paint: ~5000ms
First image loaded: ~6500ms
All requests finished: >15,000ms

Oof. The page doesn’t display anything useful until ~5 seconds in. The first image only finishes loading around 6.5 seconds, and it takes _well_ _over 15 seconds_ for all network requests to complete.

This timeline view offers a bunch of insights. Let’s walk through it and examine what it’s doing:

1.  The initial HTML page is fetched. This is nice and quick, because the app is not server-rendered.
2.  The monolithic JS bundle has to be downloaded. This takes forever. 🚩
3.  React traverses the component tree, computes the initial mount state, and pushes it to the DOM. It’s a header, a footer, and a lot of black space. 🚩
4.  After mount, the application realizes that it needs some data, so it makes a GET request to _/me_, an API endpoint that returns the user’s data, as well as an array of shows they care about, and which episodes they’ve seen.
5.  Once we have that crucial list of shows, the application can fetch:
    - an image for each show,
    - an array of episodes for each show*.

    This data comes from the wonderful [**TV Maze API**](https://www.tvmaze.com/api).

> * You may be wondering why I don’t just store episode info in my database, so I can skip all those calls to TV Maze. Ultimately, TV Maze is the source of truth; it has all the info about new episodes. I could make these requests on the server during Step 4, but that would greatly increase the amount of time that step takes, while a user stares into a sea of empty black space. Plus, I like having a lean server layer.
> 
> One potential workaround could be to set up a cron job that does daily syncs with TV Maze, and only request episodes directly if I don’t already have recent data. I kinda like that the data is realtime, though… this avenue will be left unexplored, at least for now.

### The Obvious Improvement

The biggest bottleneck right now is that initial JS bundle’s size; it takes too long to download!

The bundle size is 526kb, and it’s not currently being compressed at all. Gzipping to the rescue!

With a Node/Express backend, this is easy; we just need to install the [**compression**](https://www.npmjs.com/package/compression) module, and use it as an Express middleware.

```
const path = require('path');

const express = require('express');
const compression = require('compression');


const app = express();

// Simply pass `compression` as an Express middleware!
app.use(compression());

app.use(express.static(path.join(rootDir, 'build')));
```

With that incredibly simple fix, let’s see what effect it has on our timeline:

![](https://cdn-images-1.medium.com/max/800/1*N1pczEBknaQ_P6u-1S_FQw.png)

First meaningful paint: 5000ms -> **3100ms**
First image loaded: 6500ms -> **4600ms
**All data loaded: 6500ms -> **4750ms
**All images loaded: ~15,000ms -> ~13,000ms

The bundle went from 526kb over-the-wire to just 156kb, and it make a huge difference on page-load speed.

### Caching with LocalStorage

With the obvious first step taken, I looked at the timeline. The first paint is at 2400ms, but it isn’t meaningful. It gets better at 3100ms, but all that episode data isn’t received until almost 5000ms.

I started thinking about server-rendering, but that wouldn’t actually fix the problem; the server would still have to make a call to the DB, and then a call to the TV Maze API. Worse, the user would be staring at a white screen while the server did its work.

Why not use local-storage? We can persist all state changes to the browser, and rehydrate from that state when the user returns. The data will be stale, but that’s OK! The real data won’t be far behind, and this will make the initial load feel so much faster.

Because this app uses Redux, persisting/hydrating state is pretty straightforward. First, I needed a way to update localStorage whenever the Redux state changed:

```
import { LOCAL_STORAGE_REDUX_DATA_KEY } from '../constants';
import { debounce } from '../utils'; // generic debounce util

// When our page first loads, a bunch of redux actions are dispatched rapidly
// (each show needs to request and then receive their episodes, so the minimum
// number of actions is 2n, where `n` is the number of shows).
// We don't need to update localStorage _that_ often, so let's debounce it.
//
// If `null` is provided, we erase the existing data. Useful during login/logout,
// where we want to obliterate the persisted state.
const updateLocalStorage = debounce(
  value =>
    value !== null
      ? localStorage.setItem(LOCAL_STORAGE_REDUX_DATA_KEY, value)
      : localStorage.removeItem(LOCAL_STORAGE_REDUX_DATA_KEY),
  2500
);


// Whenever the store updates, store relevant parts in localStorage.
export const handleStoreUpdates = function handleStoreUpdates(store) {
  // Omit modals and flash messages: they don't need to be restored.
  const { modals, flash, ...relevantState} = store.getState();

  updateLocalStorage(JSON.stringify(relevantState));
}

// Helper to clear existing data, on logout.
export const clearReduxData = () => {
  // Immediately erase the data stored in localStorage.
  window.localStorage.removeItem(LOCAL_STORAGE_REDUX_DATA_KEY);

  // A subtle bug was introduced, because while the removal was synchronous,
  // persisting new data is async, with that debounce above. And so the storage
  // would be cleared, but then re-populated a second later.
  // To solve that, we'll send a null update, which will kill any updates
  // currently in the queue.
  updateLocalStorage(null);
  
  // We need to do both the synchronous one and the asynchronous one.
  // The synchronous one ensures data is deleted immediately, so if the user
  // closes the tab immediately after clicking "logout", their data is gone.
};
```

Next, we need to subscribe our Redux store to this method, as well as initialize it with any data from previous sessions:

```
import { LOCAL_STORAGE_REDUX_DATA_KEY } from './constants';
import { handleStoreUpdates } from './helpers/local-storage.helpers';
import configureStore from './store';


const localState = JSON.parse(
  localStorage.getItem(LOCAL_STORAGE_REDUX_DATA_KEY) || '{}'
);

const store = configureStore(history, localState);

store.subscribe(() => {
  handleStoreUpdates(store);
});
```

There were a few kinks to work out, but for the most part, this was a really simple change, thanks to how Redux is architected.

Let’s take a gander at the new timeline:

![](https://cdn-images-1.medium.com/max/800/1*wJ6uOFLCWUmhMpKtB7XuYw.png)

Cool! It’s hard to tell from how small the captured screenshots are, but our very first paint is meaningful now; it contains a full list of the shows and episodes from our previous session: at 2600ms

First meaningful paint: 3100ms -> **2600ms
**Episode data available: 4750ms -> **2600ms (!)**

While this hasn’t actually affected the loading time (we still do make those API requests and they still take a while), the user has data immediately, and so the _perceived_ speed improvement is very noticeable.

Gone is the staggered, things-keep-changing second where content appears as it’s available. While this is often a popular technique for getting stuff on the page sooner, it can be overwhelming when the page keeps updating as new content is available. I much prefer being able to render the “final” UI immediately.

As an extra bonus, this winds up being pretty useful in non-perf ways too. For example, users have the ability to change the sorting of shows, but before this change, that preference would be forgotten when the session ends. Now, that preference is restored when they come back!

> There is a downside to this, though: it’s no longer clear whether you’re still waiting for new data or not. I plan to add a spinner in the corner that shows whether additional requests are still being waited on or not.

> Also, you may be thinking “This is great for returning users, but does nothing for new users!”. You’re right, but actually, this isn’t applicable for new users. New users have no tracked shows, and so their page load is super quick; just a call-to-action to start adding shows. So we’ve effectively killed the experience of “staring at a black screen forever” for **all** users, new and returning.

### Images and Lazy Loading

Even with this latest improvement, images are still taking forever to load; this timeline doesn’t show it, but it still takes 12+ seconds for all images to be loaded, with 3G speeds.

The reason for this is simple: TV Maze returns large movie-poster-style photos, whereas I only need a narrow strip, used to help tell shows apart at-a-glance.

![](https://cdn-images-1.medium.com/max/800/1*wIhn8j9QkPIBvxAA6ulTxQ.jpeg)

**Left**: what gets downloaded ················ **Right**: what gets used

To solve this problem, my initial thought was to use something like ImageMagick, a wonderful CLI tool I used while making [**ColourMatch**](http://colourmatch.ca/).

When the user adds a new show, the server would request a copy of the image, use ImageMagick to crop out the middle of the image, send it over to S3, and use the S3 URL on the client, rather than using the TV Maze image link.

Rather than deal with this myself, though, I decided to outsource this concern to [**Imgix**](https://www.imgix.com/). Imgix is a service that sits in front of S3 (or other cloud storage providers) and allows you to dynamically create cropped, resized images. You just use a URL like this, and it creates and serves an appropriate image:

```
https://tello.imgix.net/some_file?w=395&h=96&crop=faces
```

> A nice bonus is being able to crop based on interesting areas of the photos. You’ll notice in the left/right comparison photo above that it crops the 4 kids on the bikes, instead of just cropping the exact center of the image.

For Imgix to work, the image has to be available via S3 or similar. Here’s a snippet from my back-end code, which uploads an image when a new show is added:

```
const ROOT_URL = 'https://tello.imgix.net';

const uploadImage = ({ key, url }) => (
  new Promise((resolve, reject) => {
    // Sometimes, shows don't have a URL. In those cases, skip this one.
    if (!url) {
      resolve();
      return;
    }

    request({ url, encoding: null }, (err, res, body) => {
      if (err) {
        reject(err);
      }

      s3.putObject({
        Key: key,
        Bucket: BUCKET_NAME,
        Body: body,
      }, (...args) => {
        resolve(`${ROOT_URL}/${key}`);
      });
    });
  })
);
```

By running every new show through this promise, we get images that are ready to be dynamically cropped.

On the client, I use image properties _srcset_ and _sizes_ make sure that images are being served based on the window size and display pixel ratio:

```
const dpr = window.devicePixelRatio;

const defaultImage = 'https://tello.imgix.net/placeholder.jpg';

const buildImageUrl = ({ image, width, height }) => (`
  ${image || defaultImage}?fit=crop&crop=entropy&h=${height}&w=${width}&dpr=${dpr} ${width * dpr}w
`);


// Later, in a render method:
<img
  srcSet={`
    ${buildImageUrl({
      image,
      width: 495,
      height: 128,
    })},
    ${buildImageUrl({
      image,
      width: 334,
      height: 96,
    })}
  `}
  sizes={`
    ${BREAKPOINTS.smMin} 334px,
    495px
  `}
/>
```

This helps ensure that mobile clients get the larger version of the image (since those cards wind up taking up the whole viewport’s width), whereas desktop clients get a slightly smaller version.

#### Lazy Loading

Each image is now way smaller, but we’re still loading an entire page worth of shows at once! On my large desktop window, only 6 shows are visible at once, but we fetch all 16 images at once, on page-load.

Happily, the awesome package [**react-lazyload**](https://github.com/jasonslyvia/react-lazyload) offers really simple lazy loading. The code is as simple as:

```
import LazyLoad from 'react-lazyload';

// In some render method somewhere:
<LazyLoad once height={UNITS_IN_PX[6]} offset={50}>
  <img
    srcSet={`...omitted`}
    sizes={`...omitted`}
  />
</LazyLoad>
```

Alright, it’s been a while since we looked at a timeline.

![](https://cdn-images-1.medium.com/max/800/1*YLyKF1rKx1MMaLA-1jnZrg.png)

Our first-meaningful-paint numbers haven’t changed, but image download times are way better:

First image: 4600ms -> **3900ms**
All visible images: ~9000ms -> **4100ms**

> Eagle-eyed readers might have noticed that this timeline only downloads episode data for 6 episodes, instead of all 16\. This is because my initial attempt (and the only one I remembered to capture) lazy-loaded the episode card, not just the show’s image.

> Ultimately this introduced more problems than I was able to solve in this weekend-long-perf-tune, and so I simplified it. The impact on above-the-fold image load-times is unchanged, though.

### Codesplitting

We’re definitely getting to a pretty good place, perf-wise.

One obvious issue is that we only have a single bundle. Let’s use codesplitting to reduce the amount of on-request code needed!

Because I’m using React Router 4, it’s a simple matter of [**following the docs**](https://reacttraining.com/react-router/web/guides/code-splitting) to create a `<Bundle />` component. I played around with a few different configurations, but ultimately, there wasn’t a lot of splitting that made sense.

In the end, I split out the mobile views from the desktop ones. The mobile version has its own views, which use a swiping library, custom assets, and a few extra components. This bundle wound up being surprisingly small — about 30kb before compression — but it nevertheless had a noticeable impact:

![](https://cdn-images-1.medium.com/max/800/1*0eWlF3VGsWLqHulZtLzkDQ.png)

First meaningful paint: 2600ms -> **2300ms**
First image loaded: 3900ms -> **3700ms**

> Lesson learned: codesplitting’s effectiveness is hugely dependent on the given application. In this case, the biggest dependencies — React and its ecosystem packages — are used across the site, and don’t need to be split off.
> 
> The components themselves could be split off at the route level for marginal gains in initial page load, but then you introduce additional latency on every route change; dealing with spinners everywhere isn’t fun.

* * *

### Other Approaches Tried or Considered

#### Serverside Rendering

I did toy with the idea of rendering a “shell” — a placeholder with the right layout, but without data — on the server.

The issue I foresaw was that the client already has access to the previous session’s data, through localStorage, and it initializes with that data. The server isn’t privy to that, and so I’d wind up with the warning about markup not matching between client and server.

I figure that I might’ve been able to shave half a second off my first-meaningful-paint time with SSR, but the site wouldn’t be interactive in that time; a personal pet-peeve of mine is when a site _looks_ ready, but isn’t.

Plus, SSR introduces a lot of complexity, and can slow down development time. Performance is important, but “good enough” is good enough.

Something I’m interested in exploring, but haven’t found the time, is _compile-time SSR_. This would only work for static pages like the logged-out homepage, but I can imagine it being hugely effective. As part of my build process, I’d create and persist the `index.html`. This would get served to the users by the Node server as the plain HTML file that it is. The client would still download and run React, so the page would become interactive, but there would be zero server-side build time, since we’ve paid that cost before the code was even deployed.

#### CDN Dependencies

An idea I thought had a lot of potential was to serve React and ReactDOM from a CDN.

Webpack makes this easy; you can specify an _externals_ key to have it not bundle the given dependency.

```
// webpack.config.prod.js
{
  externals: {
    react: 'React',
    'react-dom': 'ReactDOM',
  },
}
```

It seemed as though there were two strong benefits to this approach:

*   Serving a popular library from a CDN means it’s likely to already be cached for the user
*   Dependencies could be _parallelized_, downloading in tandem with the app bundle, instead of being a single large file.

I was surprised to see, at least in the worst case where the CDN hasn’t cached it, that moving React to a CDN was _harmful_:

![](https://cdn-images-1.medium.com/max/800/1*JaujId8Or-HOxLuJGcKWSw.png)

First meaningful paint: **2300ms** -> 2650ms

You’ll notice that React and React DOM are downloaded in parallel to my main desktop bundle, and yet… it actually slows down the total time.

> I don’t want to imply that using CDNs like this are never a good idea. I’m not an expert in this stuff and it’s entirely possible that this is something I’m doing wrong, not a flaw with the idea! At least in my case, though, it didn’t pan out.

* * *

### Conclusion

There are two main ideas I hope this post communicates:

1.  Small side-project apps are pretty fast out-of-the-box, but a weekend of experimentation can yield _huge_ speed improvements. The Chrome developer tools make it really easy to poke around and see where the bottlenecks are, and it may surprise you how much low-hanging fruit there is. Servicers like Imgix allow you to defer hard problems to other people, often for free or for very low cost.
2.  Every application is different. This post details specific tricks for Tello, which has a very unique set of concerns. Even if these tips aren’t directly applicable in your app, I hope I’ve showcased how _performance is a creative part of web development_.

    For example, the conventional wisdom is that server-side rendering is the way to go. In many applications it is, but maybe a client-side solution using local-storage and/or service-workers would be better! Maybe you can pay some of the cost of SSR during compile-time, or maybe you can do what Netflix does for some pages, and [skip shipping React to the client entirely](https://jakearchibald.com/2017/netflix-and-react/)!

    Performance is actually really fun when you realize how much creativity and outside-the-box thinking is involved.

> Thanks for reading! I hope this was helpful :) Lemme know what you think [on Twitter](http://twitter.com/joshwcomeau).

> **View Tello’s source** [**on Github**](https://github.com/joshwcomeau/Tello)**.**🌟


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
