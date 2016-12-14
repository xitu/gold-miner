#	Progressive Web AMPs

If you’ve been following the web development community these last few months, chances are you’ve read about [progressive web apps](https://www.smashingmagazine.com/2016/08/a-beginners-guide-to-progressive-web-apps/)(PWAs). It’s an umbrella term used to describe web experiences so advanced that they compete with ever-so-rich and immersive native apps: [full offline support](https://www.smashingmagazine.com/2016/02/making-a-service-worker/),[installability](https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/?hl=en), “Retina,” full-bleed imagery, sign-in support for personalization, fast, smooth in-app browsing, push notifications and a great UI.

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-2.png)

A few of Google’s sample progressive web apps.

But even though the new [Service Worker API](https://developers.google.com/web/fundamentals/primers/service-worker/)allows you to cache away all of your website’s assets for an almost instant *subsequent* load, like when meeting someone new, the first impression is what counts. If the first load takes more than 3 seconds, the latest [DoubleClick study](https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/) shows that more than 53% of all users will drop off.

And 3 seconds, let’s be real, is already a quite *brutal* target. On mobile connections, which often average around a 300-millisecond latency and come with other constraints such as limited bandwidth and a sometimes poor signal connection, you might be left with a total load performance budget of less than 1 second to actually do the things you need to do to initialize your app.

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-7.png) 

The delays that sit between your user and your content.

Sure, there are ways to [mitigate](https://codelabs.developers.google.com/codelabs/your-first-pwapp/#4) this problem of a slow first load — prerendering a basic layout on the server, lazy-loading chunks of functionality and so on — but you can only get so far with this strategy, and you have to employ, or be, a front-end performance wizard.

So, if an almost instant first load is fundamentally at odds with a native-like app experience, what can we do?

### AMP, For Accelerated Mobile Pages 

One of the most significant advantages of a website is almost frictionless entry — that is, no installation step and almost instant loading. A user is always just a click away.

To really benefit from this opportunity for effortless, ephemeral browsing, all you need is a crazy-fast-loading website. And all you need to make your website crazy fast? A proper diet: no megabyte-sized images, no render-blocking ads, no 100,000 lines of JavaScript, just the content, please.

[AMPs](https://www.ampproject.org/), short for Accelerated Mobile Pages, are [very good at this](https://www.ampproject.org/docs/get_started/technical_overview.html)[10](#10). In fact, it is their *raison d’être*. It’s like a car-assist feature that forces you to stay in the fast lane by enforcing a set of sensible rules to always prioritize your page’s main content. And by creating this strict, [statically](https://www.ampproject.org/docs/get_started/technical_overview.html#size-all-resources-statically)[11](#11) laid out environment, it enables platforms such as Google Search to get one step closer to “instant” by [preloading just the first viewport](https://www.ampproject.org/docs/get_started/technical_overview.html#load-pages-in-an-instant)[12](#12).

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-0.png)

The (first) hero image and the headline of this AMP will be prerendered, so that the visitor can see its (above-the-fold) content instantly.

### AMP Or PWA? 

To make the experience reliably fast, you need to live with some constraints when implementing AMP pages. AMP isn’t useful when you need highly dynamic functionality, such as Push Notifications or Web Payments, or really anything requiring additional JavaScript. In addition, since AMP pages are usually served from an AMP Cache, you won’t get the biggest Progressive Web App benefits on that first click, since your own Service Worker can’t run. On the other hand, a Progressive Web App can never be as fast as AMP on that first click, as platforms can safely and cheaply prerender AMP pages – a feature that also makes embedding simpler (e.g. into an inline viewer).

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-8.png)

Once the user leaves the AMP Cache as they click an internal link, you can enhance the website by installing service workers to make the website available offline (and more).

So, AMP or progressive web app? Instant delivery and optimized delivery, or the latest advanced platform features and flexible application code? What if there was a way to combine the two, to reap the benefits of both?

### The Perfect User Journeyr 

In the end, what matters is the ideal user experience you’re aiming for — the **user journey**. It goes like this:

1. A user discovers a link to your content and clicks it.
2. The content loads almost instantly and is a pleasure to consume.
3. The user is invited and automatically upgraded to an even richer experience, with smoother in-app navigation, push notifications and offline support.
4. The user exclaims, “Why, hello. Heck yeah!” and is instantly redirected to an app-like experience and they can install the site onto their home screen.

The first hop to your website should feel almost instant, and the browsing experience should get more and more engaging afterwards.

Sound too good to be true? Well, what if we **combine the two technologies** — although at the first glance, they are seemingly unrelated and solve different needs?

### PWAMP Combination Patterns 

To get to instant-loading, auto-upgrading experience, all you need to do is combine the laser-sharp leanness of AMPs with the richness of progressive web apps in one (or multiple) of the following ways:

- **AMP as PWA**

When you can live with AMP’s limitations.

- **AMP to PWA**

When you want to smoothly transition between the two.

- **AMP in PWA**

When you want to reuse AMPs as a data source for your PWA.

Let’s walk through each of them individually.

#### AMP as PWA

Many websites won’t ever need things beyond the boundaries of AMPs. [Amp by Example](https://ampbyexample.com/)[16](#16)[15](#15), for instance, is both an AMP and a progressive web app:

- It has a service worker and, therefore, allows offline access, among other things.
- It has a manifest, prompting the “Add to Homescreen” banner.

When a user visits [Amp by Example](https://ampbyexample.com/)[16](#16)[15](#15) from a Google search and then clicks on another link on that website, they navigate away from the AMP Cache to the origin. The website still uses the AMP library, of course, but because it now lives on the origin, it can use a service worker, can prompt to install and so on.

You can use this technique to enable offline access to your AMP website, as well as extend your pages as soon as they’re served from the origin, because you can modify the response via the service worker’s `fetch` event, and return as a response whatever you want:

```
function createCompleteResponse (header, body){return Promise.all([
    header.text(),getTemplate(RANDOM STUFF AMP DOESN’T LIKE),
    body.text()]).then(html =>{returnnewResponse(html[0]+ html[1]+ html[2],{
      headers:{'Content-Type':'text/html'}});});}
      
```

This technique allows you to insert scripts and more advanced functionality outside of the scope of AMPs on subsequent clicks.

#### AMP to PWA 

When the above isn’t enough, and you want a dramatically different PWA experience around your content, it’s time for a slightly more advanced pattern:

- All content “leaf” pages (those that have specific content, not overview pages) are published as AMPs for that nearly instant loading experience.
- These AMPs use AMP’s special element [`<amp-install-serviceworker>`](https://www.ampproject.org/docs/reference/extended/amp-install-serviceworker.html)[17](#17) to warm up a cache and the PWA shell **while the user is enjoying** your content.
- When the user clicks another link on your website (for example, the call to action at the bottom for a more app-like experience), the service worker intercepts the request, takes over the page and loads the PWA shell instead.

You can implement the experience above in three easy steps, provided you are familiar with how service workers work. (If you aren’t, then I greatly recommend my colleague [Jake’s Udacity course](https://www.udacity.com/course/offline-web-applications--ud899)[18](#18)). First, install the service worker on all of your AMPs:

```
<amp-install-serviceworker
      src="https://www.your-domain.com/serviceworker.js"
      layout="nodisplay"></amp-install-serviceworker>
      
```

Secondly, in the service worker’s installation step, cache any resources that the PWA will need:

```
var CACHE_NAME ='my-site-cache-v1';var urlsToCache =['/','/styles/main.css','/script/main.js'];

self.addEventListener('install',function(event){// Perform install steps
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache){
        console.log('Opened cache');return cache.addAll(urlsToCache);}));});
        
```

Finally, again in the service worker, respond with the PWA instead of the requested AMP on navigation requests. (The code below, while functional, is overly simplified. A more advanced example follows in the demo at the end.)

```
self.addEventListener('fetch', event =>{if(event.request.mode ==='navigate'){
      event.respondWith(fetch('/pwa'));
      
      // Immediately start downloading the actual resource.
      
      fetch(event.request.url);}});

```

Now, whenever a user clicks on a link on your page served from the AMP Cache, the service worker registers the `navigate` request mode and takes over, then responds with the full-blown, already-cached PWA instead.

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-6.png)

You can progressively enhance the website by installing service workers. For browsers that don’t support service workers, they will just move to another page within the AMP Cache.

What’s especially interesting about this technique is that you are now using progressive enhancement to go from AMP to PWA. However, this also means that, as is, browsers that don’t yet support service workers will jump from AMP to AMP and will never actually navigate to the PWA.

AMP solves this with something called [shell URL rewriting](https://www.ampproject.org/docs/reference/components/amp-install-serviceworker#shell-url-rewrite)[20](#20). By adding a fallback URL pattern to the `<amp-install-serviceworker>` tag, you are instructing AMP to rewrite all matching links on a given page to go to another legacy shell URL instead, if no service worker support has been detected:

```
<amp-install-serviceworker
      src="https://www.your-domain.com/serviceworker.js"
      layout="nodisplay"
      data-no-service-worker-fallback-url-match=".*"
      data-no-service-worker-fallback-shell-url="https://www.your-domain.com/pwa"></amp-install-serviceworker>

```

With these attributes in place, all subsequent clicks on an AMP will go to your PWA, regardless of any service worker. Pretty neat, huh?

#### AMP in PWA 

So, now the user is in the progressive web app, and chances are you’re using some AJAX-driven navigation that fetches content via JSON. You can certainly do that, but now you have these crazy infrastructure needs for two totally different content back ends — one generating AMP pages, and the other offering a JSON-based API for your progressive web app.

But think for a second about what an AMP really is. It’s not just a website. It’s designed as a ultra-portable content unit. An AMP is self-contained by design and can be safely embedded into another website. What if we could dramatically simplify the back-end complexity by ditching the additional JSON API and instead reuse AMP as the data format for our progressive web app?

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-3.png)

AMP pages can be safely embedded into another website — the AMP library is compiled and loaded only once for the entire PWA.

Of course, one easy way to do this would be simply to load AMP pages in frames. But iframes are slow, and then you’d need to recompile and re-initialize the AMP library over and over. Today’s cutting-edge web technology offers a better way: the shadow DOM.

The process looks like this:

1. The PWA hijacks any navigation clicks.
2. Then, it does an XMLHttpRequest to fetch the requested AMP page.
3. It puts the content into a new shadow root.
4. And it tells the main AMP library, “Hey, I have a new document for you. Check it out!” (calling `attachShadowDoc` on runtime).

Using this technique, the AMP library is compiled and loaded only once for the entire PWA, and then is responsible for every shadow document you attach to it. And, because you’re fetching pages via XMLHttpRequests, you can modify the AMP source before inserting it into a new shadow document. You could do this, for instance, to:

- strip out unnecessary things, such as headers and footers;
- insert additional content, such as more obnoxious ads or fancy tooltips;
- replace certain content with more dynamic content.

Now, you’ve made your progressive web app much less complex, and you’ve dramatically reduced the complexity of your back-end infrastructure.

### Ready, Set, Action! 

To demonstrate the shadow DOM approach (i.e. an AMP within a PWA), the AMP team has created a [React-based demo called The Scenic,](https://choumx.github.io/amp-pwa/)[22](#22) a fake travel magazine:

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-4.png) 

The [whole demo](https://github.com/ampproject/amp-publisher-sample/blob/master/amp-pwa)is on GitHub, but the magic happens in [`amp-document.js`’ React component](https://github.com/ampproject/amp-publisher-sample/blob/master/amp-pwa/src/components/amp-document/amp-document.js#L92)[25](#25).

#### Show me something real

For a real production example, take a look at [Mic’s new PWA)](https://beta.mic.com) (in beta): If you shift-reload a [random article](https://beta.mic.com/articles/161568/arrow-season-5-episode-9-a-major-character-returns-in-midseason-finale-maybe)[27](#27) (which will ignore the Service Worker temporarily) and look at the source code, you’ll notice it’s an AMP page. Now try clicking on the hamburger menu: It reloads the current page, but since `<amp-install-serviceworker>` has *already installed* the PWA app shell, the reload is almost *instant*, and the menu is open after the refresh, making it look like no reload has happened. But now you’re in the PWA (that embeds AMP pages), bells and whistles and all. Sneaky, but magnificent.

### (Not So) Final Thoughts 

Needless to say, I’m extremely excited about the potential of this new combination. It’s a combination that brings out the best of both.

Recapping the highlights:

- always fast, no matter what;
- great distribution built-in (through AMP’s platform partners);
- progressively enhanced;
- one back end to rule them all;
- less client complexity;
- less overall investment;

But we’re just starting to discover variations of the pattern, as well as completely new ones. Build the best web experiences that 2016 and beyond have to offer. Onward, to a new chapter of the web!

*(al)*


1. [1 https://www.smashingmagazine.com/2016/08/a-beginners-guide-to-progressive-web-apps/](#note-1)
2. [2 https://www.smashingmagazine.com/2016/02/making-a-service-worker/](#note-2)
3. [3 https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/?hl=en](#note-3)
4. [4 https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-2.png](#note-4)
5. [5 https://developers.google.com/web/fundamentals/primers/service-worker/](#note-5)
6. [6 https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/](#note-6)
7. [7 https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-7.png](#note-7)
8. [8 https://codelabs.developers.google.com/codelabs/your-first-pwapp/#4](#note-8)
9. [9 https://www.ampproject.org/](#note-9)
10. [10 https://www.ampproject.org/docs/get_started/technical_overview.html](#note-10)
11. [11 https://www.ampproject.org/docs/get_started/technical_overview.html#size-all-resources-statically](#note-11)
12. [12 https://www.ampproject.org/docs/get_started/technical_overview.html#load-pages-in-an-instant](#note-12)
13. [13 https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-0.png](#note-13)
14. [14 https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-8.png](#note-14)
15. [15 https://ampbyexample.com/](#note-15)
16. [16 https://ampbyexample.com/](#note-16)
17. [17 https://www.ampproject.org/docs/reference/extended/amp-install-serviceworker.html](#note-17)
18. [18 https://www.udacity.com/course/offline-web-applications--ud899](#note-18)
19. [19 https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-6.png](#note-19)
20. [20 https://www.ampproject.org/docs/reference/components/amp-install-serviceworker#shell-url-rewrite](#note-20)
21. [21 https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-3.png](#note-21)
22. [22 https://choumx.github.io/amp-pwa/](#note-22)
23. [23 https://choumx.github.io/amp-pwa/](#note-23)
24. [24 https://github.com/ampproject/amp-publisher-sample/blob/master/amp-pwa](#note-24)
25. [25 https://github.com/ampproject/amp-publisher-sample/blob/master/amp-pwa/src/components/amp-document/amp-document.js#L92](#note-25)
26. [26 https://beta.mic.com](#note-26)
27. [27 https://beta.mic.com/articles/161568/arrow-season-5-episode-9-a-major-character-returns-in-midseason-finale-maybe](#note-27)

