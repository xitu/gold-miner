> * 原文地址：[How we made Carousell’s mobile web experience 3x faster](https://medium.com/carousell-insider/how-we-made-carousells-mobile-web-experience-3x-faster-bbb3be93e006)
> * 原文作者：[Stacey Tay](https://medium.com/@staceytay?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-made-carousells-mobile-web-experience-3x-faster.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-made-carousells-mobile-web-experience-3x-faster.md)
> * 译者：
> * 校对者：

# How we made Carousell’s mobile web experience 3x faster

## A 6-months retrospective on building our Progressive Web App

[Carousell](https://careers.carousell.com/about/) is a mobile classifieds marketplace made in Singapore and growing in a number of South-East Asian countries, including Indonesia, Malaysia, and Philippines. We released a [Progressive Web Application](https://developers.google.com/web/progressive-web-apps/) for selected mobile web users early this year.

In this write-up, we share (1) our motivations for wanting to build a faster web experience, (2) how we built it, (3) the impact it had on our users, and (4) what helped us move fast.

![](https://cdn-images-1.medium.com/max/1000/1*q1lHcvKCppZvyd4OIFr3Rw.png)

🖼 The PWA at [https://mobile.carousell.com](https://mobile.carousell.com) 🔎

#### Why a faster web experience?

Our app was created for the Singapore market, and we were used to our users having above-average smartphones and high-speed internet. However, as we expanded to more countries in the region, such as Indonesia and Philippines, we faced challenges in providing a similarly delightful and fast web experience. This was because the [median device](https://building.calibreapp.com/beyond-the-bubble-real-world-performance-9c991dcd5342) and [internet speed](https://en.wikipedia.org/wiki/List_of_countries_by_Internet_connection_speeds) in these places tend to be slower and less reliable than what our app was designed for.

As we read more about performance and started auditing our app with [Lighthouse](https://developers.google.com/web/tools/lighthouse/), we [realised that we needed a faster web experience](https://developers.google.com/web/fundamentals/performance/why-performance-matters/) [if we wanted to grow in these new marketplaces](https://en.wikipedia.org/wiki/List_of_countries_by_Internet_connection_speeds). **Having a web page take more than 15s to load over 3G (as ours did) is unacceptable if we wanted to acquire and retain our new users.**

![](https://cdn-images-1.medium.com/max/800/1*1AUcHKLx6hNwnbTKsV9O3w.png)

🌩 The Lighthouse performance score that was a wake up call 🏠

The web is frequently the first place where our new users would discover and learn about Carousell. **We wanted to give them a delightful experience from the start because** [**performance is user experience**](http://designingforperformance.com/performance-is-ux/)**.**

To do this, we designed a new, performance-first web experience. When we were deciding which pages to work on first, we chose our Product Listing Page and Home Page since insights from Google Analytics indicated that these pages had the largest amount of organic traffic.

* * *

### How We Did It

#### Starting with a Real-world Performance Budget

The first thing we did was to draft a performance budget to avoid making the mistake of unchecked bloat (an issue in our previous web application).

> Performance budgets keep everyone on the same \[page\]. They help to create a culture of shared enthusiasm for improving the lived user experience. Teams with budgets also find it easier to track and graph progress. This helps support executive sponsors who then have meaningful metrics to point to in justifying the investments being made.

> — [Can You Afford It?: Real-world Web Performance Budgets](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/).

Since [“there are multiple moments during the load experience that can affect whether a user perceives it as ‘fast’”](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics), we based our budget on a combination of metrics.

> Loading a web page is like a film strip that has three key moments. There’s: Is it happening? Is it useful? And, is it usable?

> — [The Cost Of JavaScript In 2018](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)

We decided on setting an upper limit of 120KB for critical-path resources, and a 2s [_First Contentful Paint_](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#first_paint_and_first_contentful_paint) and 5s [_Time-to-Interactive_](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#time_to_interactive) limit on all pages. These numbers and metrics were based on Alex Russell’s sobering write-up on [Real-world Web Performance Budgets](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) and Google’s [User-centric Performance Metrics](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics).

```
Critical-path Resources         120KB
First Contentful Paint          2s
Time-to-Interactive             5s
Lighthouse Performance Score    > 85
```

🔼 Our performance budget 🌟

To stick within the budget, we were deliberate in choosing the initial set of libraries to use (react, react-router, redux, redux-saga, [unfetch](https://github.com/developit/unfetch)).

We also integrated [bundlesize](https://github.com/siddharthkp/bundlesize) checks into our PR process to enforce our budget for critical-path resources.

![](https://cdn-images-1.medium.com/max/800/1*PKGjihs6JorbhLbygpTNjA.png)

⚠️ bundlesize blocking a PR that exceeded the budget 🚫

Ideally, we would have automated checks for our _First Contentful Paint_ and _Time-to-Interactive_ metrics too. But, we haven’t done this because we wanted to release the initial pages first. We figured we could get away with this with our small team size by auditing our releases with Lighthouse every week to ensure that our changes are within budget.

Suboptimal, but setting up a performance monitoring framework is next on our backlog.

### How we made it (seem) fast

1.  **Adopting part of the** [**PRPL pattern**](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)**.** We send the minimal amount of resources for each page request (using [route-based code-splitting](https://github.com/jamiebuilds/react-loadable)) and [precache the rest of the app bundle using workbox](https://developers.google.com/web/tools/workbox/modules/workbox-precaching). We also split out unnecessary components. For example, if a user is already logged in, the app would not load the login and sign up components. At present, we’re still deviating from the PRPL pattern in a couple of ways. First, the app has more than one app shell due to older pages that we haven’t had the time to redesign. Secondly, we haven’t explored generating separate builds for different browsers.

2.  **Inlining** [**critical CSS**](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery)**.** We use [webpack’s mini-css-extract-plugin](https://github.com/webpack-contrib/mini-css-extract-plugin) to extract and inline each page’s critical CSS to improve Time to First Paint. This is to give the user the perception that [_something_ is happening](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#user-centric_performance_metrics).

3.  **Lazy loading images not in the viewport.** And progressively loading them when they are. We created a scroll observer component, based on [react-lazyload](https://github.com/jasonslyvia/react-lazyload), that listens to the [scroll event](https://developer.mozilla.org/en-US/docs/Web/Events/scroll) and starts loading an image once it’s calculated to be inside the viewport.

4.  **Compressing all images to reduce data transferred over the network.** This came free with our CDN provider’s [automatic image compression](https://blog.cloudflare.com/introducing-polish-automatic-image-optimizati/) service. If you don’t use a CDN, or simply curious about performance for images, Addy Osmani created an amazing [guide on how to automate image optimization](https://images.guide).

5.  **Using service workers to cache network requests.** This reduces data usage for APIs that didn’t change often, and improved our app’s load times for subsequent visits. We found [The Offline Cookbook](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/) helpful in deciding on which caching strategies to adopt. Since we had multiple app shells, Workbox’s default `[registerNavigationRoute](https://developers.google.com/web/tools/workbox/modules/workbox-routing#how_to_register_a_navigation_route)` didn’t work for us and we had to write a custom handler to match the navigation requests to the correct app shell.

```
workbox.navigationPreload.enable();

// From https://hacks.mozilla.org/2016/10/offline-strategies-come-to-the-service-worker-cookbook/.
function fetchWithTimeout(request, timeoutSeconds) {
  return new Promise((resolve, reject) => {
    const timeoutID = setTimeout(reject, timeoutSeconds * 1000);
    fetch(request).then(response => {
      clearTimeout(timeoutID);
      resolve(response);
    }, reject);
  });
}

const networkTimeoutSeconds = 3;
const routes = [
  { name: "collection", path: "/categories/.*/?$" },
  { name: "home", path: "/$" },
  { name: "listing", path: "/p/.*\\d+/?$" },
  { name: "listingComments", path: "/p/.*\\d+/comments/?$" },
  { name: "listingPhotos", path: "/p/.*\\d+/photos/?$" },
];

for (const route of routes) {
  workbox.routing.registerRoute(
    new workbox.routing.NavigationRoute(
      ({ event }) => {
        return caches.open("app-shells").then(cache => {
          return cache.match(route.name).then(response => {
            return (response
              ? fetchWithTimeout(event.request, networkTimeoutSeconds)
              : fetch(event.request)
            )
              .then(networkResponse => {
                cache.put(route.name, networkResponse.clone());
                return networkResponse;
              })
              .catch(error => {
                return response;
              });
          });
        });
      },
      {
        whitelist: [new RegExp(route.path)],
      },
    ),
  );
}
```

⚙️ Using a network-first strategy with a 3s timeout for all our app shells 🐚

Throughout these changes, we relied heavily on [Chrome’s “mid-tier mobile” simulation](https://developers.google.com/web/tools/chrome-devtools/device-mode/) (with the network throttled to 3G speeds), and created multiple Lighthouse audits to evaluate the impact of our work.

### Results: How did we do?

![](https://cdn-images-1.medium.com/max/1000/1*uTOxbHdmHLG6UsVaAj4Dig.jpeg)

🎉 Before and after comparison of the mobile web metrics 🎉

Our new PWA listing page **loads 3x faster** than our old listing page. After releasing this new page, we’ve had a **63% increase in organic traffic** from Indonesia, compared to our our all time-high week. Over a 3 week period, we also saw a **3x increase in ads click-through-rates** and a **46% increase in anonymous users who initiated a chat** on the listing page.

![](https://cdn-images-1.medium.com/max/800/1*6ql8gjD3IKSITGfyQZCZuA.gif)

⏮ [Before and after comparison of our Listing Page on a Nexus 5 with fast 3G](https://www.webpagetest.org/video/compare.php?tests=171020_B8_97732ed88ebc522d6a042f0ad502ccd4,181009_HJ_07aee97a8bbe626fee8b11a3c5661980). Update: [WebPageTest’s “easy” report for this page](https://www.webpagetest.org/result/181031_XQ_e4603b6421fc22743c5790f34abcc4e2/). ⏭

* * *

### Moving Fast, With Confidence

#### A consistent Carousell Design System

While we were working on this, our design team was also simultaneously creating a standardised design system. Since our PWA was a new project, we took the chance to create a standardised set of UI components and CSS constants based on the design system.

Having consistent designs allowed us to iterate fast. We **built each UI component just once, and reused it in multiple places**. For example, we have a `ListingCardList` component that shows a feed of listing cards and triggers a callback to prompt its parent component to load more listings when scrolled to the end. We use it in our Home Page, Listing Page, Search Page, and Profile Page.

We also worked with our designers to determine the appropriate performance tradeoffs in the app design. This allowed us to maintain our performance budget, change some old designs to conform to the new ones, and skip fancy animations if they were too expensive.

#### Going with the Flow

We opted to make [Flow](https://flow.org) typings a requirement for all our files because we wanted to reduce annoying null value or type bugs (I was also a huge fan of gradual typing, but why we chose Flow instead of [TypeScript](https://www.typescriptlang.org) is a topic for another time).

Adopting Flow proved to be super helpful as we developed and created more code. It gave us confidence in adding or changing code, making major code refactoring uncomplicated _and_ safe. This allowed us to move fast without breaking things.

Additionally, the Flow typings have also been useful as documentation for our API contracts and shared library components.

A positive side-effect of having to write out the typings for our Redux actions and React components is that it helped us consider how we’d like to design our APIs. It also served as an easy way to start early PR discussions with the team.

* * *

### Recap

We created a lightweight PWA to serve our users with unreliable internet speeds, released it page by page, and this improved our business metrics _and_ user experience.

#### What helped us stay fast

*   Having and enforcing a perfomance budget
*   Reducing critical rendering path down to the minimum
*   Auditing often with Lighthouse

#### What helped us move fast

*   Having a standardised design system and its corresponding library of UI components
*   Having a fully typed codebase

### Closing Thoughts

Looking back on what we’ve done over the past two quarters, we’re incredibly proud of our new mobile web experience and we’re working hard on making it even better. This is our first platform that’s heavily focused on speed, with thought also put into the loading journey of a page. The improvements in business and user metrics from our PWA has helped convince more people within the company of the importance of app performance and load times.

We hope that this article has inspired you to consider performance when designing and building your web experience.

_Huge shout out to the people who worked on this project: Trong Nhan Bui, Hui Yi Chia, Diona Lin, Yi Jun Tao, and Marvin Chin. Also, to Google, especially Swetha and Minh, for their advice on this project._

_Thanks to Bui,_ [_Danielle Joy_](https://medium.com/@xdaniejoyy)_,_ [_Hui Yi_](https://medium.com/@c_huiyi)_,_ [_Jingwen Chen_](https://medium.com/@jin_)_,_ [_See Yishu_](https://medium.com/@yishu)_, and_ [_Yao Hui Chua_](https://medium.com/@yaohuichua) _for their input and reviews._

Thanks to [Hui Yi](https://medium.com/@c_huiyi?source=post_page), [Yao Hui Chua](https://medium.com/@yaohuichua?source=post_page), [Danielle Joy](https://medium.com/@xdaniejoyy?source=post_page), [Jingwen Chen](https://medium.com/@jin_?source=post_page), and [See Yishu](https://medium.com/@yishu?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
