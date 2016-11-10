> * 原文地址：[Progressive Web Apps with React.js: Part I — Introduction](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.g5r0gv9j5)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Progressive Web Apps with React.js: Part I — Introduction




### Progressive Web Apps take advantage of new technologies to bring the best of mobile sites & native apps to users. They’re reliable, fast, and engaging. They originate from a secure origin and load regardless of network state.

![](https://cdn-images-1.medium.com/max/1600/1*Ms2muRzG4DHE36YU4kX_ag@2x.png)



There’s much new in the world of [Progressive Web Apps](https://infrequently.org/2015/06/progressive-apps-escaping-tabs-without-losing-our-soul/) (PWAs) and you might be wondering how compatible they are with existing architectures using libraries like [React](https://facebook.github.io/react/) and JS module bundlers like [Webpack](https://webpack.github.io/). Does a PWA require a wholesale rewrite? What web performance metrics do you need to keep an eye on? In this series of posts I’ll share my experience turning React-based web apps into PWAs. We’ll also cover why shipping _just_ what users need for a route & throwing out all other scripts are good ideas for fast perf.

### Lighthouse

Let’s begin with a PWA checklist. For this we’ll be using [**Lighthouse**](https://github.com/GoogleChrome/lighthouse) — a tool for auditing [an app for PWA features](https://infrequently.org/2016/09/what-exactly-makes-something-a-progressive-web-app/) and checking your app meets a respectable bar for web performance under emulated mobile conditions. Lighthouse is available as a [Chrome extension](https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk) (I use this version of it most often) and a [CLI](https://github.com/GoogleChrome/lighthouse#install-cli), both of which present a report that looks a little like this:













![](https://cdn-images-1.medium.com/max/2000/0*EI9JfoDRizcpZolA.)



Results from the Lighthouse Chrome extension







The top-level audits Lighthouse runs effectively a collection of modern web best practices refined for a mobile world:

*   **Network connection is secure**
*   **User can be prompted to Add to Homescreen**
*   **Installed web app will launch with custom splash screen**
*   **App can load on offline/flaky connections**
*   **Page load performance is fast**
*   **Design is mobile-friendly**
*   **Site is progressively enhanced**
*   **Address bar matches brand colors**

Btw, there’s a [getting started guide](https://developers.google.com/web/tools/lighthouse/) for Lighthouse and it also works over [remote debugging](https://github.com/GoogleChrome/lighthouse#lighthouse-w-mobile-devices). Super cool.

Regardless of what libraries are in your stack, I want to emphasize that everything in the above list can be accomplished today with a little work. There are caveats however.

**We know the mobile web is** [**_slow_**](https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/)**_._**

The web has evolved from a document-centric platform to a first-class application platform. At the same time the bulk of our computing has moved from powerful desktop machines with fast, reliable network connections to relatively underpowered mobile devices with connections that are often _slow, flaky or both._ This is especially true in parts of the world where the next billion users are coming online. To unlock a faster mobile web:

*   **We need to collectively shift to testing on real mobile devices under realistic network connections** (e.g [Regular 3G in DevTools](https://developers.google.com/web/tools/chrome-devtools/profile/network-performance/network-conditions?hl=en)). [chrome://inspect](https://developers.google.com/web/tools/chrome-devtools/debug/remote-debugging/remote-debugging?hl=en) and [WebPageTest](https://www.webpagetest.org/) ([video](https://www.youtube.com/watch?v=pOynMwTyRgQ&feature=youtu.be)) are your friend. Lighthouse emulates a Nexus 5X with touch events, viewport emulation and a throttled network connection (150ms latency, 1.6Mbps throughput).
*   **If the JS libraries you’re using aren’t developed with mobile in mind, you may be running an uphill battle for perf** when it comes to being interactive. We’re ideally aiming for being interactive in under 5 seconds on a representative device so more of that budget for our app code is ❤









![](https://cdn-images-1.medium.com/max/1600/1*Qx7aFIAKWbn11heD--nxwg.png)



With some work, it’s possible to write PWAs with React that _do_ perform well on real devices under limited network conditions [as demonstrated by Housing.com](https://twitter.com/samccone/status/771786445015035904). We’ll talk about how to achieve this in great **detail** later on in the series.



That said, this is an area many libraries are working to improve on and may need to if they’re going to stay viable for performance on physical devices. Just take a look at the A+ job [Preact](https://github.com/developit/preact) is doing on [perf with real-world devices.](https://twitter.com/slightlylate/status/770652362985836544)

**Open-source React Progressive Web App samples**









![](https://cdn-images-1.medium.com/max/1600/0*5tmODLoFjo8A_nnW.)





_If you’re after relatively non-trivial examples of PWAs built with React and optimized with Lighthouse, you may be interested in:_ [_ReactHN_](https://github.com/insin/react-hn)_— a HackerNews client with server-side rendering & offline support or_ [_iFixit_](https://github.com/GoogleChrome/sw-precache/tree/master/app-shell-demo)_ — a hardware repair guide built with React but which uses Redux for state management._

Let’s now walk through what we need to do to check off each item in the Lighthouse report, continuing with React.js specific tips throughout the series.

### Network connection is secure

#### Tooling and tips for HTTPS









![](https://cdn-images-1.medium.com/max/1200/1*xRLobGG8a41wGypF9mKI-A.jpeg)





[HTTPS](https://support.google.com/webmasters/answer/6073543?hl=en) prevents bad-actors from tampering with communications between your app and the browser your users are using and you might have read that Google is pushing to [shame](http://motherboard.vice.com/read/google-will-soon-shame-all-websites-that-are-unencrypted-chrome-https) sites that are unencrypted. Powerful new web platform APIs, like [Service Worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API), [require](https://www.chromium.org/Home/chromium-security/prefer-secure-origins-for-powerful-new-features) secure origins via HTTPS but the good news is thanks to services like [LetsEncrypt](https://letsencrypt.org/) providing free [SSL certificates](https://www.globalsign.com/en/ssl-information-center/what-is-an-ssl-certificate/) and low-cost options like [Cloudflare](https://www.cloudflare.com/) enabling end-to-end traffic encryption [for all](https://www.cloudflare.com/ssl/), it’s never been more straight-forward to get this setup.

For my personal projects, I usually deploy to [Google App Engine](https://cloud.google.com/appengine/) which supports serving SSL traffic through an appspot.com domain if you add the [‘secure’](https://cloud.google.com/appengine/docs/python/config/appref) parameter to your app.yaml file. For my React apps that need Node.js support for Universal Rendering, I use [Node on App Engine](https://cloudplatform.googleblog.com/2016/03/Node.js-on-Google-App-Engine-goes-beta.html). [Github Pages](https://github.com/blog/2186-https-for-github-pages) and [Zeit.co](https://zeit.co/blog/now-alias) also now support HTTPS.









![](https://cdn-images-1.medium.com/max/1600/0*OzD-JvnlDlwVS8d-.)





_The_ [_Chrome DevTools Security panel_](https://developers.google.com/web/updates/2015/12/security-panel?hl=en) _allows you to validate issues with security certificates and mixed content errors._

Some more tips to get your site more secure:

*   Upgrade unsecure requests (“HTTP” connections) to “HTTPS” redirecting users as needed. Take a look at [Content Security Policy](https://content-security-policy.com/) and [upgrade-insecure-requests](https://googlechrome.github.io/samples/csp-upgrade-insecure-requests/).
*   Update all links referencing “http://” to “https://”. If you rely on third-party scripts or content, talk to them about making their resources available over HTTPS too
*   Use [HTTP Strict Transport Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) (HSTS) headers when serving pages. It’s a directive that forces browsers to only talk to your site in HTTPS.

I’d recommend watching [Deploying HTTPS: The Green Lock and Beyond](https://developers.google.com/web/shows/cds/2015/deploying-https-the-green-lock-and-beyond-chrome-dev-summit-2015?hl=en)and [Mythbusting HTTPS: Squashing security’s urban legends](https://developers.google.com/web/shows/google-io/2016/mythbusting-https-squashing-securitys-urban-legends-google-io-2016?hl=en) for more.

### User can be prompted to Add to Homescreen

Next up is customizing the “[add to homescreen](https://developer.chrome.com/multidevice/android/installtohomescreen)” experience for your app (favicons, application name displayed, orientation and more). This is achieved by adding a [Web Application Manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest). I usually find customizing cross-browser (and OS) favicons to involve the most work here, but tools like [realfavicongenerator.net](http://realfavicongenerator.net/) take a lot of the pain out of the experience.









![](https://cdn-images-1.medium.com/max/1600/0*00LlyQjpgTUPOh0g.)





There’s been much discussion on the “minimum” number of favicons a site needs to just work in most places. Lighthouse [have proposed](https://github.com/GoogleChrome/lighthouse/issues/291) shipping a 192px icon for the homescreen icon and a 512px one for your splashscreen. I personally stick with the output from realfavicongenerator as despite it involving more metatags, I prefer the assurance my bases are all covered.

Some sites may prefer to ship a highly customized favicon per platform. I recommend checking out [Designing a Progressive Web App icon](https://medium.com/dev-channel/designing-a-progressive-web-app-icon-b55f63f9ff6e#.voxq5imjg) for more guidance on this topic.









![](https://cdn-images-1.medium.com/max/1200/1*xdyHSM4RdSkeN3-U8O1JKg.png)





With a Web App manifest setup, you also get access to [app installer banners](https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/?hl=en), giving you a way to natively prompt for users to install your PWA if they find themselves engaging with it often. It’s also possible to [defer](https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/?hl=en#deferring_or_cancelling_the_prompt)the prompt until a time when a user has a useful interaction with your app. Flipkart [found](https://twitter.com/adityapunjani/status/782426188702633984) the best time to show the prompt was on their order confirmation page.

[_The Chrome DevTools Application Panel_](https://developers.google.com/web/tools/chrome-devtools/progressive-web-apps) supports inspecting your Web App Manifest via Application > Manifest:









![](https://cdn-images-1.medium.com/max/1600/0*-UCHfo1lxUdWUKAD.)





This parses out the favicons listed in your manifest and previews properties like the start URL and theme colors. Btw, there’s a Totally Tooling Tips [episode](https://www.youtube.com/watch?v=yQhFmPExcbs&index=11&list=PLNYkxOF6rcIB3ci6nwNyLYNU6RDOU3YyL) on Web App Manifests if interested 😉

### Installed web app will launch with custom splash screen

In older versions of Chrome for Android, tapping on a homescreen icon for an app would often take up to 200ms (or multiple seconds in slow sites) for the first frame of the document to be rendered to the screen.

During this time, the user would see a white screen, decreasing the perceived performance of your site. Chrome 47 and above [support customising a splash screen](https://developers.google.com/web/updates/2015/10/splashscreen?hl=en) (based on a background_color, name and icons from the Web App Manifest) used to color the screen until the browser is ready to paint something. This makes your webapp feel a lot closer to “native”.









![](https://cdn-images-1.medium.com/max/1600/0*sQHn9k-t--cNcijL.)





[Realfavicongenerator.net](http://realfavicongenerator.net/) also now supports previewing and customising the Splashscreen for your manifest, a handy time saver.

_Note: Firefox for Android and Opera for Android also support the Web Application Manifest, Splash screen and an add to homescreen experience. On iOS, Safari still supports customising add to_ [_homescreen icons_](https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html) _and used to support a_ [_proprietary splashscreen_](https://gist.github.com/tfausak/2222823) _implementation, however this appears to have broken in iOS9\. I’ve filed a feature request for Webkit to support the Web App Manifest so.. fingers crossed I guess._

### Design is mobile-friendly

Apps optimized for multiple devices should include a [meta-viewport in the of their document](https://developers.google.com/web/fundamentals/design-and-ui/responsive/fundamentals/set-the-viewport?hl=en). This might seem super obvious, but I’ve seen plenty of React projects where folks have neglected to include this. Thankfully [create-react-app](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/public/index.html#L5) does include a valid meta-viewport by default and Lighthouse will flag if it is missing:

    

Although we focus heavily on optimizing the mobile web experience in Progressive Web Apps, this [doesn’t mean desktop should be forgotten](https://www.justinribeiro.com/chronicle/2016/09/10/desktop-pwa-bring-the-goodness/). A well-crafted PWA can work well across a range of viewport sizes, browsers and devices, as demonstrated by Housing.com:













![](https://cdn-images-1.medium.com/max/2000/0*bgAmcKHWLB_DxiRC.)









In Part 2 of the series, we’ll look at [**page-load performance with React and Webpack**](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load-performance-33b932d97cf2#.9ebqqaw8k). We’ll dive into code-splitting, route-based chunking and the PRPL pattern for reaching interactivity sooner.

If you’re new to React, I’ve found [React for Beginners](https://goo.gl/G1WGxU) by Wes Bos excellent.

_With thanks to Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews and Owen Campbell-Moore for their reviews._

