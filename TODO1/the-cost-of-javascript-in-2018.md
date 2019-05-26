> * 原文地址：[The Cost Of JavaScript In 2018](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)
> * 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-cost-of-javascript-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-cost-of-javascript-in-2018.md)
> * 译者：
> * 校对者：

# The Cost Of JavaScript In 2018

Building [**interactive**](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/) **sites** can involve sending JavaScript to your users. Often, **too much** of it. Have you been on a mobile page that looked like it had loaded only to tap on a link or tried to scroll and _nothing_ happens?

**Byte-for-byte, JavaScript is still the most expensive resource we send to mobile phones, because it can delay interactivity in large ways.**

![](https://cdn-images-1.medium.com/max/2000/1*0WzELcRwNUj0gS89mTxFHg.png)

JavaScript processing times for CNN.com as measured by [WebPageTest](https://webpagetest.org) ([src](http://bit.ly/jscost-wpt)). A high-end phone (iPhone 8) processes script in ~4s. Compare to the ~13s an [average phone](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) (Moto G4) takes or the ~36s taken by a low-end 2018 phone (Alcatel 1X).

Today we’ll cover some strategies you can use to deliver JavaScript efficiently while still giving users a valuable experience.

### tl;dr:

*   **To stay fast**, **only load JavaScript needed for the current page.** Prioritize what a user will _need_ and lazy-load the rest with [code-splitting](https://webpack.js.org/guides/code-splitting/). This gives you the best chance at loading and _getting interactive_ fast. Stacks with route-based code-splitting by _default_ are game-changers.
*   **Embrace performance budgets and learn to live within them.** For mobile, aim for a [JS budget of < 170KB minified/compressed](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/). Uncompressed this is still ~0.7MB of code. Budgets are critical to success, however, they can’t magically fix perf in isolation. [Team culture, structure and enforcement matter](https://twitter.com/tkadlec/status/1018529148862652417?s=19). Building without a budget invites performance regressions and failure.
*   **Learn how to** [**audit**](https://nolanlawson.com/2018/03/20/smaller-lodash-bundles-with-webpack-and-babel/) **and trim your JavaScript bundles.** There’s a high chance you’re [shipping full-libraries when you only need a fraction](https://github.com/GoogleChromeLabs/webpack-libs-optimizations), polyfills for browsers that don’t need them, or duplicate code.
*   **Every interaction is the start of a new ‘Time-to-Interactive’; consider optimizations in this context.** Transmission size is critical for low-end mobile networks and JavaScript parse time for CPU-bound devices.
*   **If client-side JavaScript isn’t benefiting the user-experience, ask yourself if it’s really necessary.** Maybe server-side-rendered HTML would actually be faster. Consider limiting the use of client-side frameworks to pages that absolutely require them. Server-rendering _and_ client-rendering are a disaster if done poorly.

* YouTube 视频链接：https://youtu.be/63I-mEuSvGA

Video for my recent talk on “The Cost of JavaScript” on which this write-up is based.

### The web is bloated by user “experience”

When users access your site you’re probably sending down a lot of files, many of which are scripts. From a web browsers’ perspective this looks a little bit like this:

![](https://cdn-images-1.medium.com/max/1600/1*9s1xVNn5DdkszfTTcYpaAQ.gif)

A mad rush of files being thrown at you.

As much as I love JavaScript, it’s _always_ the most expensive part of your site. I’d like to explain why this can be a major issue.

![](https://cdn-images-1.medium.com/max/1600/0*_hiZH3mzu13KzyXK)

The median webpage today currently ships about [350 KB of minified and compressed JavaScript](https://beta.httparchive.org/reports/state-of-javascript#bytesJs). Uncompressed, that bloats up to over 1MB of script a browser needs to process.

**Note: Unsure if your JavaScript bundles are delaying how quickly users interact with your site? Check out** [**Lighthouse**](https://developers.google.com/web/tools/lighthouse/)**.**

![](https://cdn-images-1.medium.com/max/1600/0*Nkmoqw_iDSXAv92W)

Statistics from the [HTTP Archive state of JavaScript report, July 2018](https://httparchive.org/reports/state-of-javascript) highlight the median webpage ships ~350KB of minified and compressed script. These pages take up to 15s to get interactive.

**Experiences that ship down this much JavaScript take more than** [**14+ seconds to load and get interactive**](https://beta.httparchive.org/reports/loading-speed#ttci) **on mobile devices.**

A large factor of this is how long it takes to download code on a mobile network and then process it on a mobile CPU.

Let’s look at mobile networks.

![](https://cdn-images-1.medium.com/max/1600/1*BJLqjBqX0n7mNg0YRKIimA.png)

Countries that perform better in a particular metric are shaded darker. Countries not included are in grey. It’s also worth [noting](https://www.telecompetitor.com/report-u-s-rural-mobile-broadband-speeds-are-20-9-slower-than-urban/) that rural broadband speeds, even in the US, can be 20% slower than urban areas.

This [chart from OpenSignal](https://opensignal.com/reports/2018/02/global-state-of-the-mobile-network) shows how consistently 4G networks are globally available and the average connection speed users in each country experience. As we can see, many countries still experience lower connection speeds than we may think.

Not only can that 350 KB of script for a median website from earlier take a while to download, the reality is if we look at popular sites, they actually ship down a _lot_ more script than this:

![](https://cdn-images-1.medium.com/max/1600/1*NPopFbfbpNG63w2Q9dyBXA.jpeg)

Uncompressed JS bundle size numbers from “[Bringing Facebook.com and the web up to speed](https://www.youtube.com/watch?v=XhOIE3l8GEY)”. Sites like Google Sheets are highlighted as shipping up to 5.8MB of script (when decompressed).

We’re hitting this ceiling across both desktop and mobile web, where sites are sometimes shipping multiple megabytes-worth of code that a browser then needs to process. The question to ask is, [**can you afford this much JavaScript**](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)**?**

### JavaScript has a cost

![](https://cdn-images-1.medium.com/max/1600/1*rLRvJH6gJcTTipr7FwzS2g.jpeg)

“Sites with this much script are simply inaccessible to a broad swath of the world’s users; statistically, users do not (and will not) wait for these experiences to load” — Alex Russell

**Note: If you’re sending too much script, consider** [**code-splitting**](https://webpack.js.org/guides/code-splitting/) **to break up bundles or** [**reducing JS payloads using tree-shaking**](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/tree-shaking/)**.**

Sites today will often send the following in their JS bundles:

*   A client-side framework or UI library
*   A state management solution (e.g. Redux)
*   Polyfills (often for modern browsers that don’t need them)
*   Full libraries vs. only what they use (e.g. all of lodash, Moment + locales)
*   A suite of UI components (buttons, headers, sidebars etc.)

This code adds up. The more there is, the longer it will take for a page to load.

**Loading a web page is like a film strip that has three key moments.**

**There’s: Is it happening? Is it useful? And, is it usable?**

![](https://cdn-images-1.medium.com/max/2000/1*cY6o73ABky4uEQYZs-xa1w.png)

Loading is a journey. We’re shifting to increasing caring about user-centric happiness metrics. Rather than just looking at onload or domContentLoaded, we now ask “when can a user actually \*use\* the page?”. If they tap on a piece of user-interface, does it respond right away?

**_Is it happening_** is the moment you’re able to deliver some content to the screen. (_has the navigation started? has the server started responding?)_

**_Is it useful_** is the moment when you’ve painted text or content that allows the user to derive value from the experience and engage with it.

And then **_is it usable_** is the moment when a user can start meaningfully interacting with the experience and have something happen.

I mentioned this term “‘interactive” earlier, but what does that _mean?_

![](https://cdn-images-1.medium.com/max/1600/1*ow6eliCJiSeX7-Ri4hOA5Q.gif)

A visualization of Time-to-Interactive highlighting how a poorly loaded experience makes the user think they can accomplish a goal, when in fact, the page hasn’t finished loading all of the code necessary for this to be true. With thanks to Kevin Schaaf for the interactivity animation

**For a page to be interactive, it must be capable of responding quickly to user input. A small JavaScript payload can ensure this happens fast.**

Whether a user clicks on a link, or scrolls through a page, they need to see that something is actually happening in response to their actions. An experience that can’t deliver on this will frustrate your users.

![](https://cdn-images-1.medium.com/max/1600/1*AWph87YYR1HXfg5CqM-92w.png)

Lighthouse measures a range of user-centric performance metrics, like Time-to-Interactive, in a lab setting.

One place this commonly happens is when folks server-side render an experience, _and_ then ship a bunch of JavaScript down afterward to “hydrate” the interface (attaching event handlers and extra behaviors).

When a browser runs many of the events you’re probably going to need, it’s likely going to do it on the same thread that handles user input. This thread is called the main thread.

**Loading too much JavaScript into the main thread (via <script>, etc) is the issue. Pulling JS into a [Web Worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) or caching via a [Service Worker](https://developers.google.com/web/fundamentals/primers/service-workers/) doesn’t have the same negative Time-to-Interactive impact.**

* YouTube 视频链接：https://youtu.be/N5vFvJUBS28

Here’s an example where a user may tap around some UI. Ordinarily, they might check a checkbox or click a link and everything’s going to work perfectly fine. But if we simulate blocking the main thread, nothing’s able to happen. They are not able to check that checkbox or click links because the main thread is blocked.

Avoid blocking the main thread as much as possible. **For more, see “**[**Why web developers need to care about interactivity**](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/)**”**

We’re seeing teams we partner with suffer JavaScript impacting interactivity across many types of sites.

![](https://cdn-images-1.medium.com/max/2000/0*BGDRqwiFeqauZCjG)

JavaScript can delay interactivity for visible elements. Visualized are a number of UI elements from Google Search where

**Too much (main thread) JavaScript can delay interactivity for visible elements. This can be a challenge for many companies.**

Above are a few examples from Google Search where you could start tapping around the UI, but if a site is shipping too much JavaScript down, there could be a delay before something actually happens. This can leave the user feeling a bit frustrated. Ideally, we want all experiences to get interactive as soon as possible.

![](https://cdn-images-1.medium.com/max/1600/1*aOLAh7nA_fXh_FM8akr63g.png)

Time-to-Interactive of news.google.com as measured by WebPageTest and Lighthouse ([source](https://docs.google.com/spreadsheets/d/1x0LQV5oQsX3MdYe1lcy_gw3FzdJ0kNPUP2-cAl4N2g4/edit?usp=sharing))

Measuring the Time-to-Interactive of Google News on mobile, we observe large variance between a high-end getting interactive in ~7s vs. a low-end device getting interactive in 55s. So, **what is a good target for interactivity?**

![](https://cdn-images-1.medium.com/max/1600/0*meHJxq_65q6xDDzx)

When it comes to [Time to Interactive](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/), we feel your baseline should be getting interactive in under five seconds on a slow 3G connection on a median mobile device. **“But, my users are all on fast networks and high-end phones!”** …are they? You may be on “fast” coffee-shop WiFi but effectively only getting 2G or 3G speeds. Variability matters.

**Who has shipped less JavaScript and reduced their Time-to-Interactive?**

![](https://i.loli.net/2018/08/05/5b664175e3215.png)

*   [Pinterest reduced their JavaScript bundles from 2.5MB to < 200KB and Time-to-Interactive reduced from 23s to 5.6s](https://medium.com/dev-channel/a-pinterest-progressive-web-app-performance-case-study-3bd6ed2e6154). Revenue went up 44%, sign-ups are up 753%, [weekly active users on mobile web are up 103%](https://medium.com/@Pinterest_Engineering/a-one-year-pwa-retrospective-f4a2f4129e05).
*   [AutoTrader reduced their JavaScript bundle sizes by 56% and reduced Time-to-Interactive for their pages by ~50%](https://engineering.autotrader.co.uk/2017/07/24/how-we-halved-page-load-times.html).
*   [Nikkei reduced their JavaScript bundle size by 43% and Time-to-Interactive improved by 14s.](https://youtu.be/Mv-l3-tJgGk?t=1967)

**Let’s design for a more resilient mobile web that doesn’t rely as heavily on large JavaScript payloads.**

Interactivity impacts a lot of things. It can be impacted by a person loading your website on a mobile data plan, or coffee shop WiFi, or just them being on the go with intermittent connectivity.

![](https://cdn-images-1.medium.com/max/1600/0*FmOIooRFANn297xe)

When this happens, and you have a lot of JavaScript that needs to be processed, users can end up waiting for the site to actually render anything. Or, if something _does_ render, they can be waiting a long time before they can interact with anything on the page. Ideally, shipping less JavaScript would alleviate these issues.

### Why is JavaScript so expensive?

To explain how JavaScript can have such a large cost, I’d like to walk you through what happens when you send content to a browser. A user types a URL into the browser’s address bar:

![](https://cdn-images-1.medium.com/max/1600/1*coL6SP0HpbXNhplgquE6dQ.gif)

A request is sent to a server which then returns some markup. The browser then parses that markup and discovers the necessary CSS, JavaScript, and images. Then, the browser has to fetch and process all of those resources.

The above scenario is an accurate depiction of what happens in Chrome when it processes everything that you send down (yes, it’s a giant emoji factory).

One of the challenges here is that JavaScript ends up being a bottleneck. Ideally, we want to be able to paint pixels quickly, and then have the page interactive. But if JavaScript is a bottleneck, you can end up just looking at something that you can’t actually interact with.

**We want to prevent JavaScript from being a bottleneck to modern experiences.**

One thing to keep in mind as an industry is that, if we want to be fast at JavaScript, we have to download it, parse it, compile it, _and_ execute it quickly.

![](https://cdn-images-1.medium.com/max/1600/1*SGGG24veeEwKusauwhIeUA.png)

That means we have to be fast at the network transmission _and_ the processing side of things for our scripts.

**If you spend a long time parsing and compiling script in a JavaScript engine, that delays how soon a user can interact with your experience.**

To provide some data about this, here’s a breakdown of where [V8](https://developers.google.com/v8/) (Chrome’s JavaScript engine) spends its time while it processes a page containing script:

![](https://cdn-images-1.medium.com/max/2000/1*NPtzv8seEPgfftIBQ1Fh7Q.png)

JavaScript parse/compile = 10–30% of the time spent in V8 (Chrome’s JS engine) during page load

The orange represents all the time spent parsing JavaScript that popular sites are sending down. In yellow, is the time spent compiling. Together, these take anywhere up to 30% of the time it takes to process the JavaScript for your page — this is a real cost.

As of Chrome 66, V8 [compiles code on a background thread](https://v8project.blogspot.com/2018/03/v8-release-66.html), reducing compile time by up to 20%. But parse and compile are still very costly and it’s rare to see a large script actually execute in under 50ms, even if compiled off-thread.

**Another thing to keep in mind with JavaScript is that all bytes are not equal. A 200 KB script and a 200 KB image have very different costs.**

![](https://cdn-images-1.medium.com/max/1600/0*fFKw1fQlh2zs_BuT)

Not all bytes weigh the same. A 200KB script has a very different set of costs to a 200KB JPG outside of the raw network transmission times for both sets of bytes.

They might take the same amount of time to download, but when it comes to processing we’re dealing with very different costs.

A JPEG image needs to be decoded, rasterized, and painted on the screen. A JavaScript bundle needs to be downloaded and then parsed, compiled, executed —and there are a number of [other steps](https://www.youtube.com/watch?v=5nmpokoRaZI) that an engine needs to complete. Just be aware that these costs are not quite equivalent.

One of the reasons why they start to add up and matter is mobile.

### Mobile is a spectrum.

![](https://cdn-images-1.medium.com/max/1600/0*hq6y6Ga2dBFA3T8m)

Mobile is a spectrum composed of cheap/low-end, median and high-end devices.

**If we’re fortunate, we may have a high-end or median end phone. The reality is that not all users will have those devices**.

They may be on a low-end or median phone, and the disparity between these multiple classes of devices can be quite stark due too; thermal throttling, difference in cache sizes, CPU, GPU — you can end up experiencing quite different processing times for resources like JavaScript, depending on the device you’re using. [Your users on low-end phones may even be in the U.S](https://www.androidauthority.com/android-go-usa-market-773723/).

![](https://cdn-images-1.medium.com/max/2000/1*l25BNM-2lJrwFXDJkcs6vw.png)

“Insights into the 2.3 Billion Android Smartphones” by [newzoo](https://newzoo.com/insights/articles/insights-into-the-2-3-billion-android-smartphones-in-use-around-the-world/). Android has a 75.9% share of the global market with a predicted 300m more smartphones joining the market in 2018. Many of these will be budget Android devices.

Here’s a breakdown of how long it takes to parse JavaScript across a spectrum of hardware available in 2018:

![](https://cdn-images-1.medium.com/max/2000/1*fA-I6ujh-3sJAZVKGsQYLw.png)

Processing (parse/compile) times for 1MB of uncompressed JavaScript (<200KB minified and gzipped) manually profiled on real devices. ([src](http://bit.ly/jscost-wpt))

At the top we have high-end devices, like the iPhone 8, which process script relatively quickly. Lower down we have more average phones like the Moto G4 and the <$100 Alcatel 1X. Notice the difference in processing times?

[**Android phones are getting cheaper, not faster, over time**](https://twitter.com/slightlylate/status/919989184881876992)**. These devices are frequently CPU poor with tiny L2/L3 cache sizes.** You are failing your average users if you’re expecting them to all have high-end hardware.

Let’s look at a more practical version of this problem using script from a real-world site. Here’s the JS processing time for CNN.com:

![](https://cdn-images-1.medium.com/max/1600/1*0WzELcRwNUj0gS89mTxFHg.png)

JavaScript processing times for CNN.com via WebPageTest ([src](http://bit.ly/jscost-wpt))

**On an iPhone 8 (using the** [**A11**](https://en.wikipedia.org/wiki/Apple_A11) **chip) it takes nine seconds less to process CNN’s JavaScript than it does on an average phone**. That’s nine seconds quicker that experience could get interactive.

Now that WebPageTest supports the Alcatel 1X (~$100 phone sold in the U.S, [sold out at launch](https://www.androidpolice.com/2018/06/05/100-android-go-powered-alcatel-1x-goes-sale-amazon-us-next-week/)) we can also look at filmstrips for CNN loading on mid-lower end hardware. Slow doesn’t even **begin** to describe this:

![](https://cdn-images-1.medium.com/max/2000/1*PUR1dshgh8en2CDjXbg4NQ.png)

Comparison of loading CNN.com, a JavaScript-heavy site, over 3G on mid-lower end hardware ([source](https://www.webpagetest.org/video/compare.php?tests=180721_V8_c83c67c7e43ea7fa25e2be44183cc613,180721_HA_06d4462ee963136187e4faf2b079ee8f,180721_3D_8b2177b325796754562f03b755b8dca0)). The Alcatel 1X takes **65s** to fully load.

**This hints that maybe we need to stop taking fast networks and fast devices for granted.**

![](https://cdn-images-1.medium.com/max/1600/0*2MLoORpHqgI5McaN)

Some users are not going to be on a fast network or have the latest and greatest phone, so it’s vital that we start testing on real phones and real networks . Variability is a real issue.

**“Variability is what kills the User Experience” — Ilya Grigorik. Fast devices can actually sometimes be slow. Fast networks can be slow, variability can end up making absolutely everything slow.**

When variance can kill the user experience, developing with a slow baseline ensures everyone (both on fast and slow setups) benefits. If your team can take a look at their analytics and understand exactly what devices your users are actually accessing your site with, that’ll give you a hint at what devices you should probably have in the office to test your site with.

![](https://cdn-images-1.medium.com/max/1600/0*RY3I1IoGDBk9Un5V)

Test on real phones & networks.

[webpagetest.org/easy](https://www.webpagetest.org/easy) has a number of Moto G4 preconfigured under the “Mobile” profiles. This is valuable in case you’re unable to purchase your own set of median-class hardware for testing.

There’s a number of profiles set up there that you can use today that already have popular devices pre-configured. For example, we’ve got some median mobile devices like the Moto G4 ready for testing.

It’s also important to test on representative networks. Although I’ve talked about how important low end and median phones are, [Brian Holt](https://twitter.com/holtbt?lang=en) made this [great point](https://twitter.com/michaellnorth/status/935547616682827776): **it’s really important to know your audience.**

![](https://cdn-images-1.medium.com/max/1600/0*mrAZ1DHd5AQa9Y5m)

“Knowing your audience and then appropriately focusing the performance of your application is critical” — Brian Holt ([src](https://www.oreilly.com/ideas/brian-holt-on-learning-javascript-and-understanding-how-to-scale-a-website))

**Not every site needs to perform well on 2G on a low-end phone**. That said, **aiming for a high level of performance across the entire spectrum is not a bad thing to do.**

![](https://cdn-images-1.medium.com/max/1600/1*52chYK9_1rc9UNvz3w3q2Q.jpeg)

Google Analytics > Audience > Mobile > Devices visualizes what devices & operating systems visit your site.

You may have a wide range of users on the higher end of the spectrum, or in a different part of the spectrum. Just be aware of the data behind your sites, so that you can make a reasonable call on how much all of this matters.

If you want JavaScript to be fast, pay attention to download times for low end networks. The improvements you can make there are: ship less code, minify your source, take advantage of compression (i.e., [gzip](https://www.gnu.org/software/gzip/), [Brotli](https://github.com/google/brotli), and [Zopfli](https://github.com/google/zopfli)).

![](https://cdn-images-1.medium.com/max/1600/0*LhfsHPuEcxoQUZSx)

Take advantage of caching for repeat visits. Parse time is critical for phones with slow CPUs.

![](https://cdn-images-1.medium.com/max/1600/0*fBvFPfP9WjFldWSP)

If you’re a back-end or full stack developer, you know that you kind of get what you pay for with respect to CPU, disk, and network.

**As we build sites that are increasingly more reliant on JavaScript, we sometimes pay for what we send down in ways that we don’t always easily see.**

### How to send less JavaScript

The shape of success is whatever let’s us send the least amount of script to users while still giving them a useful experience. [Code-splitting](https://survivejs.com/webpack/building/code-splitting/) is one option that makes this possible.

![](https://cdn-images-1.medium.com/max/1600/1*kdQGs03dZVZS6VbTEDdZuw.png)

Splitting large, monolithic JavaScript bundles can be done on a page, route or component basis. You’re even better setup for success if “splitting” is the default for your toolchain from the get-go.

**Code-splitting is this idea that, instead of shipping down your users a massive monolithic JavaScript bundle — sort of like a massive full pizza — what if you were to just send them one slice at a time? Just enough script needed to make the current page usable.**

Code-splitting can be done at the page level, route level, or component level. It’s something that’s well supported by many modern libraries and frameworks through bundlers like [webpack](https://webpack.js.org/concepts/) and [Parcel](https://parceljs.org/). Guides to accomplish this are available for [React](https://reactjs.org/docs/code-splitting.html), [Vue.js](https://router.vuejs.org/guide/advanced/lazy-loading.html) and [Angular](https://angular.io/guide/lazy-loading-ngmodules).

```
import OtherComponent from './OtherComponent';

const MyComponent = () => (
  <OtherComponent/>
);
```

```
mport Loadable from 'react-loadable';

const LoadableOtherComponent = Loadable({
  loader: () => import('./OtherComponent'),
  loading: () => <div>Loading...</div>,
});

const MyComponent = () => (
  <LoadableOtherComponent/>
);
```

Adding code-splitting in a React app using [React Loadable](https://github.com/jamiebuilds/react-loadable) — a higher-order component that wraps dynamic imports in a React-friendly API for adding code-splitting to your app at a given component.

Many large teams have seen big wins off the back of investing in code-splitting recently.

![](https://cdn-images-1.medium.com/max/1600/0*sqx0dLL0SA6hVjBK)

In an effort to rewrite their mobile web experiences to try to make sure users were able to interact with their sites as soon as possible, both [Twitter](https://blog.twitter.com/engineering/en_us/topics/open-source/2017/how-we-built-twitter-lite.html) and [Tinder](https://medium.com/@addyosmani/a-tinder-progressive-web-app-performance-case-study-78919d98ece0) saw anywhere up to a 50% improvement in their Time to Interactive when they adopted aggressive code splitting.

Stacks like [Gatsby.js](http://gatsbyjs.org) (React), [Preact CLI](https://github.com/developit/preact-cli), and [PWA Starter Kit](https://github.com/Polymer/pwa-starter-kit) attempt to enforce good defaults for loading & getting interactive quickly on average mobile hardware.

Another thing many of these sites have done is adopted auditing as part of their workflow.

![](https://cdn-images-1.medium.com/max/2000/1*AzG1zXjLLAdJPAtQ9uvT5g.png)

Audit your JavaScript bundles regularly. Tools like webpack-bundle-analyzer are great for analyzing your built JavaScript bundles and import-cost for Visual Code is excellent for visualizing expensive dependencies during your local iteration workflow (e.g. when you `npm install` and import a package)

Thankfully, the JavaScript ecosystem has a number of great tools to help with bundle analysis.

**Tools like** [**Webpack Bundle Analyzer**](https://www.npmjs.com/package/webpack-bundle-analyzer), [**Source Map Explorer**](https://www.npmjs.com/package/source-map-explorer) **and** [**Bundle Buddy**](https://github.com/samccone/bundle-buddy) **allow you to audit your bundles for opportunities to trim them down.**

These tools visualize the content of your JavaScript bundles: they highlight large libraries, duplicate code, and dependencies you may not need.

![](https://cdn-images-1.medium.com/max/2000/1*fdX-6h2HnZ_Mo4fBHflh2w.png)

From “[Put your Webpack bundle on a diet](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/)” by Benedikt Rötsch

Bundle auditing often highlights opportunities to swap **heavy** dependencies (like Moment.js and its locales) for **lighter** alternatives (such as [date-fns](https://github.com/date-fns/date-fns)).

If you use webpack, you may find our repository of [common library issues](https://github.com/GoogleChromeLabs/webpack-libs-optimizations) in bundles useful.

### Measure, Optimize, Monitor, and Repeat.

If you’re unsure whether you have any issues with JavaScript performance in general, check out [Lighthouse](https://developers.google.com/web/tools/lighthouse/):

![](https://cdn-images-1.medium.com/max/1600/0*hJCNqwEXfkdMaetB)

Lighthouse recently added a number of useful new [performance audits](https://developers.google.com/web/updates/2018/05/lighthouse) that you may not be aware of.

Lighthouse is a tool baked into the Chrome Developer Tools. It’s also available as a [Chrome extension](https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk?hl=en). It gives you an in-depth performance analysis that highlights opportunities to improve performance.

![](https://cdn-images-1.medium.com/max/2000/1*IoS-SMK40vqW2Gkwp4jZhQ.png)

We’ve recently added support for flagging high “[JavaScript boot-up time](https://developers.google.com/web/updates/2018/05/lighthouse#javascript_boot-up_time_is_high)” to Lighthouse. This audit highlights scripts which might be spending a long time parsing/compiling, which delays interactivity. You can look at this audit as opportunities to either split up those scripts, or just be doing less work there.

Another thing you can do is make sure you’re not shipping unused code down to your users:

![](https://cdn-images-1.medium.com/max/1600/0*LtmKFazhFnfMNLpP)

Find unused CSS and JS code with the [Coverage tab in Chrome DevTools](https://developers.google.com/web/updates/2017/04/devtools-release-notes#coverage).

[Code coverage](https://developers.google.com/web/updates/2017/04/devtools-release-notes#coverage) is a feature in DevTools that allows you to discover unused JavaScript (and CSS) in your pages. Load up a page in DevTools and the coverage tab will display how much code was executed vs. how much was loaded. You can improve the performance of your pages by only shipping the code a user needs.

![](https://i.loli.net/2018/08/05/5b6642993ba95.png)

**Tip: With coverage recording, you can interact with your app and DevTools will update how much of your bundles were used.**

This can be valuable for identifying opportunities to split up scripts and defer the loading of non-critical ones until they’re needed.

If you’re looking for a pattern for serving JavaScript efficiently to your users, check out the [PRPL pattern](https://developers.google.com/web/fundamentals/performance/prpl-pattern/).

![](https://cdn-images-1.medium.com/max/1600/0*Knu-rZagK3SBXgI0)

PRPL is a performance pattern for efficient loading. It stands for (P)ush critical resources for the initial route, (R)ender initial route, (P)re-cache remaining routes, (L)azy-load and create remaining routes on demand

**PRPL (Push, Render, Precache and Lazy-Load) is a pattern for aggressively splitting code for every single route, then taking advantage of a** [**service worker**](https://developers.google.com/web/fundamentals/primers/service-workers/) **to pre-cache the JavaScript and logic needed for future routes, and lazy load it as needed.**

What this means is that when a user navigates to other views in the experience, there’s a good chance it’s already in the browser cache, and so they experience much more reduced costs in terms of booting scripts up and getting interactive.

If you care about performance or you’ve ever worked on a performance patch for your site, you know that sometimes you could end up working on a fix, only to come back a few weeks later and find someone on your team was working on a feature and unintentionally broke the experience. It goes a little like this:

![](https://cdn-images-1.medium.com/max/1600/0*s2gm_VH0P_QJyGi-)

Thankfully, there are ways we can we can try to work around this, and one way is having a [**performance budget**](https://timkadlec.com/2013/01/setting-a-performance-budget/) in place.

![](https://cdn-images-1.medium.com/max/1600/0*5CCzBapxi5OdC1jC)

**Performance budgets are critical because they keep everybody on the same page. They create a culture of shared enthusiasm for constantly improving the user experience and team accountability.**

Budgets define measurable **constraints** to allow a team to meet their performance goals. As you have to live within the constraints of budgets, performance is a consideration at each step, as opposed to an after-thought.

Based on the work by [Tim Kadlec](https://timkadlec.com/2014/11/performance-budget-metrics/), metrics for perf budgets can include:

*   **Milestone timings** — timings based on the _user-experience_ loading a page (e.g Time-to-Interactive). You’ll often want to pair several milestone timings to accurately represent the complete story during page load.
*   **Quality-based metrics** — based on raw values (e.g. weight of JavaScript, number of HTTP requests). These are focused on the _browser_ experience.
*   **Rule-based metrics** — scores generated by tools such as Lighthouse or WebPageTest. Often, a single number or series to grade your site.

![](https://i.loli.net/2018/08/05/5b6642e8e47c6.png)

Alex Russell had a [tweet-storm](https://twitter.com/slightlylate/status/1018508800590876672?s=19) about performance budgets with a few salient points worth noting:

*   [**“Leadership buy-in is important**](https://twitter.com/slightlylate/status/1018508800590876672?s=19)**. The willingness to put feature work on hold to keep the overall user experience good defines thoughtful management of technology products.”**
*   “Performance is about culture supported by tools. Browsers optimize HTML+CSS as much as possible. Moving more of your work into JS puts the burden on your team and their tools”
*   “Budgets aren’t there to make you sad. They’re there to make the organization self-correct. Teams need budgets to constrain decision space and help hitting them”

Everyone who impacts the user-experience of a site has a relationship to how it performs.

![](https://cdn-images-1.medium.com/max/1600/1*RoL5P_sW9rxFg6ft-ccvSg.jpeg)

Make performance part of the conversation.

**Performance is more often a cultural challenge than a technical one.**

Discuss performance during planning sessions and other get-togethers. Ask business stakeholders what their performance expectations are. Do they understand how perf can impact the business metrics they care about? Ask eng. teams how they plan to address perf bottlenecks. While the answers here can be unsatisfactory, they get the conversation started.

![](https://cdn-images-1.medium.com/max/1600/1*6xC-ydreiA8OMNxCTcF2rA.jpeg)

“Make performance relevant to your stakeholders’ goals by showing how it can impact the key metrics they care about. Without a performance culture, performance is not sustainable” — [Allison McKnight](https://vimeo.com/254947097)

Here’s an action plan for performance:

- **Create your performance vision**. This is a one-page agreement on what business stakeholders and developers consider “good performance”  
- **Set your performance budgets**. Extract key performance indicators (KPIs) from the vision and set realistic, measurable targets from them. e.g. “Load and get interactive in 5s”. Size budgets can fall out of this. e.g “Keep JS < 170KB minified/compressed”  
- **Create regular reports on KPIs.** This can be a regular report sent out to the business highlighting progress and success.

[Web Performance Warrior](https://www.oreilly.com/webops-perf/free/web-performance-warrior.csp) by Andy Still and [Designing for Performance](http://designingforperformance.com/) by Lara Hogan are both excellent books that discuss how to think about getting a performance culture in place.

**What about tooling for perf budgets?** You can setup Lighthouse scoring budgets in continuous integration with the [Lighthouse CI](https://github.com/ebidel/lighthouse-ci) project:

![](https://cdn-images-1.medium.com/max/1600/1*Y-1sdlIzFBRfEQPprzLnbA.png)

Prevent pull requests from being merged if your perf scores fall below a certain value with [Lighthouse CI](https://github.com/ebidel/lighthouse-ci). [Lighthouse Thresholds](https://github.com/luke-j/lighthouse-thresholds) is another configuration-based approach to setting perf budgets.

A number of performance monitoring services support setting perf budgets and budget alerts including [Calibre](https://calibreapp.com/), [Treo](https://treo.sh/a/addyosmani/3), [Webdash](https://webdash.xyz/) and [SpeedCurve](https://speedcurve.com/about/):

![](https://cdn-images-1.medium.com/max/1600/1*zgDjVn3QBQTx-BG3xx2oCw.png)

JavaScript perf budgets for my site [teejungle.net](https://teejungle.net/) using SpeedCurve which supports a range of [budget metrics](http://support.speedcurve.com/get-the-most-out-of-speedcurve/create-performance-budgets-and-set-alerts).

Embracing performance budgets encourages teams to think seriously about the consequences of any decisions they make from early on in the design phases right through to the end of a milestone.

Looking for further reference? The [U.S Digital Service](https://designsystem.digital.gov/performance/how/) document their approach to tracking performance with Lighthouse by setting goals and budgets for metrics like Time-to-Interactive.

Next up..

**Each site should have access to** [**both lab and field performance data**](https://developers.google.com/web/fundamentals/performance/speed-tools/)**.**

To track the impact JavaScript can have on user-experience in a RUM (Real User Monitoring) setting, there are two things coming to the web I’d recommend checking out.

![](https://cdn-images-1.medium.com/max/1600/1*mAfpN7k-PJehxCaJLZS1lA.png)

Field data (or RUM — Real User Monitoring) is performance data collected from real page loads your users are experiencing in the wild. Sites with heavy JavaScript payloads would benefit from measuring main-thread of this work through Long Tasks and First Input Delay.

The first is [Long Tasks ](https://w3c.github.io/longtasks/)— an API enabling you to gather real-world telemetry on tasks (and their attributed scripts) that last longer than 50 milliseconds that could block the main thread. You can record these tasks and log them back to your analytics.

[First Input Delay](https://developers.google.com/web/updates/2018/05/first-input-delay) (FID) is a metric that measures the time from when a user first interacts with your site (i.e. when they tap a button) to the time when the browser is actually able to respond to that interaction. FID is still an early metric, but we have a [polyfill](https://github.com/GoogleChromeLabs/first-input-delay) available for it today that you can check out.

* YouTube 视频链接：https://youtu.be/ULU-4-ApcjM

Between these two, you should be able to get enough telemetry from real users to see what JavaScript performance problems they’re running into.

![](https://cdn-images-1.medium.com/max/1600/1*j8TtZ6oCcwShwboZTz9R5w.jpeg)

Marcel Freinbichler had a [viral tweet](https://twitter.com/fr3ino/status/1000166112615714816) about USA Today shipping a slim version of their site to EU users. It loaded 42 seconds faster than their normal pages.

It’s well known that third-party JavaScript can have a dire impact on page load performance. While this remains true, it’s important to acknowledge that many of today’s experiences ship a lot of first-party JavaScript of their own, too. If we’re to load fast, we need to chip away at the impact both sides of this problem can have on the user experience.

There are several common slip-ups we see here, including teams using blocking JavaScript in the document head to decide what A/B test to show users. Or, shipping the JS for all variants of an A/B test down, even if only one is going to actually be used 🤯

![](https://i.loli.net/2018/08/05/5b66437ce814c.png)

**We have a separate guide on loading** [**Third-party JavaScript**](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/loading-third-party-javascript/) **if this is currently the primary bottleneck you’re experiencing.**

### Get fast, stay fast.

**Performance is a journey. Many small changes can lead to big gains.**

Enable users to interact with your site with the _least_ amount of friction. Run the smallest amount of JavaScript to deliver real value. This can mean taking incremental steps to get there.

In the end, your users will thank you.

![](https://cdn-images-1.medium.com/max/2000/0*0OQb3eca-tDFTMeX)

**References**

*   [Can You Afford It?: Real-world Web Performance Budgets](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)
*   [Progressive Performance](https://www.youtube.com/watch?v=4bZvq3nodf4&list=PLNYkxOF6rcIBTs2KPy1E6tIYaWoFcG3uj&index=18&t=0s)
*   [Reducing JavaScript payloads with Tree-shaking](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/tree-shaking)
*   [Ouch, your JavaScript hurts!](https://speedcurve.com/blog/your-javascript-hurts/)
*   [Fast & Resilient — Why carving out the “fast” path isn’t enough](https://docs.google.com/presentation/d/169gop22hzmu-NEUiNQyoIZ_oRiMqNLFMKNJVvX42iC8/edit?usp=drivesdk)
*   [Web performance optimization with Webpack](https://developers.google.com/web/fundamentals/performance/webpack/)
*   [JavaScript Start-up Optimization](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/javascript-startup-optimization/)
*   [The Impact Of Page Weight On Load Time](https://paulcalvano.com/index.php/2018/07/02/impact-of-page-weight-on-load-time/)
*   [Beyond The Bubble — Real-world Performance](https://building.calibreapp.com/beyond-the-bubble-real-world-performance-9c991dcd5342)
*   [How To Think About Speed Tools](https://developers.google.com/web/fundamentals/performance/speed-tools/)
*   [Thinking PRPL](https://houssein.me/thinking-prpl)

_With great thanks to_ [_Thomas Steiner_](https://twitter.com/tomayac)_,_ [_Alex Russell_](https://twitter.com/slightlylate)_,_ [_Jeremy Wagner_](https://twitter.com/malchata)_,_ [_Patrick Hulce_](https://twitter.com/patrickhulce)_, Tom Ankers and_ [_Houssein Djirdeh_](https://twitter.com/hdjirdeh) _for their contributions to this write-up. Also thanks to Pat Meenan for his continued work on WebPageTest — here’s a Lighthouse report for_ [_this page_](https://www.webpagetest.org/lighthouse.php?test=180801_55_0cb6a6efefd4067b9b3ac7655ab13a26&run=1) _if interested. You can follow my work on_ [_Twitter_](https://twitter.com/addyosmani)_._

Thanks to [Houssein Djirdeh](https://medium.com/@hdjirdeh?source=post_page), [Thomas Steiner](https://medium.com/@steiner.thomas?source=post_page), and [Patrick Hulce](https://medium.com/@patrickhulce?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
