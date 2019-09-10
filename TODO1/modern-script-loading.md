> * 原文地址：[Modern Script Loading](https://jasonformat.com/modern-script-loading/)
> * 原文作者：[Jason Miller](https://jasonformat.com/author/developit/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/modern-script-loading.md](https://github.com/xitu/gold-miner/blob/master/TODO1/modern-script-loading.md)
> * 译者：
> * 校对者：

# Modern Script Loading

> Serving the right code to the right browsers can be tricky. Here are some options.

![](https://res.cloudinary.com/wedding-website/image/upload/v1562702391/modern-script-loading_ku0eml.jpg)

Serving modern code to modern browsers can be great for performance. Your JavaScript bundles can contain more compact or optimized modern syntax, while still supporting older browsers.

The tooling ecosystem has consolidated on using the [module/nomodule pattern](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/) for declaratively loading modern VS legacy code, which provides browsers with both sources and lets them decide which to use:

```html
<script type="module" src="/modern.js"></script>  
<script nomodule src="/legacy.js"></script>  
```

Unfortunately, it's not quite that straightforward. The HTML-based approach shown above triggers [over-fetching of scripts in Edge and Safari](https://gist.github.com/jakub-g/5fc11af85a061ca29cc84892f1059fec).

### What can we do?

What can we do? We want to deliver two compile targets depending on the browser, but a couple older browsers don't quite support the nice clean syntax for doing so.

First, there's the [Safari Fix](https://gist.github.com/samthor/64b114e4a4f539915a95b91ffd340acc). Safari 10.1 supports JS Modules not the `nomodule` attribute on scripts, which causes it to execute both the modern and legacy code **(yikes!)**. Thankfully, Sam found a way to use a non-standard `beforeload` event supported in Safari 10 & 11 to polyfill `nomodule`.

#### Option 1: Load Dynamically

We can circumvent these issues by implementing a tiny script loader, similar to how [LoadCSS](https://github.com/filamentgroup/loadCSS) works. Instead of relying on browsers to implement both ES Modules and the `nomodule` attribute, we can attempt to execute a Module script as a "litmus test", then use the result of that test to choose whether to load modern or legacy code.

```html
<!-- use a module script to detect modern browsers: -->  
<script type=module>  
  self.modern = true
</script>

<!-- now use that flag to load modern VS legacy code: -->  
<script>  
  addEventListener('load', function() {
    var s = document.createElement('script')
    if (self.modern) {
      s.src = '/modern.js'
      s.type = 'module'
    }
    else {
      s.src = '/legacy.js'
    }
    document.head.appendChild(s)
  })
</script>  
```

However, this solution requires waiting until our first "litmus test" module script has run before it can inject the correct script. This is because `<script type=module>` is always asynchronous. There is a better way!

A standalone variant of this can be implemented by checking if the browser supports `nomodule`. This would mean browsers like Safari 10.1 are treated as legacy even though they support Modules, but that [might be](https://github.com/web-padawan/polymer3-webpack-starter/issues/33#issuecomment-474993984) a [good thing](https://github.com/babel/babel/pull/9584). Here's the code for that:

```js
var s = document.createElement('script')  
if ('noModule' in s) {  // notice the casing  
  s.type = 'module'
  s.src = '/modern.js'
}
else  
  s.src = '/legacy.js'
}
document.head.appendChild(s)  
```

This can be quickly rolled into a function that loads modern or legacy code, and also ensures both are loaded asynchronously:

```html
<script>  
  $loadjs("/modern.js","/legacy.js")
  function $loadjs(src,fallback,s) {
    s = document.createElement('script')
    if ('noModule' in s) s.type = 'module', s.src = src
    else s.async = true, s.src = fallback
    document.head.appendChild(s)
  }
</script>  
```

**What's the trade-off?** **preloading**.

The trouble with this solution is that, because it's completely dynamic, the browser won't be able to discover our JavaScript resources until it runs the bootstrapping code we wrote to inject modern vs legacy scripts. Normally, browsers scan HTML as it is being streamed to look for resources they can preload. There's a solution, though it's not perfect: we can use `<link rel=modulepreload>` to preload the modern version of a bundle in modern browsers. Unfortunately, [only Chrome supports `modulepreload`](https://developers.google.com/web/updates/2017/12/modulepreload) so far.

```html
<link rel="modulepreload" href="/modern.js">  
<script type=module>self.modern=1</script>  
<!-- etc -->  
```

Whether this technique works for you can come down to the size of the HTML document you're embedding those scripts into. If your HTML payload is as small as a splash screen or just enough to bootstrap a client-side application, giving up the preload scanner is less likely to impact performance. If you are server-rendering a lot of meaningful HTML for the browser to stream, the preload scanner is your friend and this might not be the best approach for you.

Here's what this solution might look like in prod:

```html
<link rel="modulepreload" href="/modern.js">  
<script type=module>self.modern=1</script>  
<script>  
  $loadjs("/modern.js","/legacy.js")
  function $loadjs(e,d,c){c=document.createElement("script"),self.modern?(c.src=e,c.type="module"):c.src=d,document.head.appendChild(c)}
</script>  
```

It's also be pointed out that the set of [browsers supporting JS Modules](https://caniuse.com/#feat=es6-module) is quite similar to [those that support](https://caniuse.com/#feat=link-rel-preload) `<link rel=preload>`. For some websites, it might make sense to use `<link rel=preload as=script crossorigin>` rather than relying on modulepreload. This may have performance drawbacks, since classic script preloading doesn't spread parsing work out over time as well as modulepreload.

#### Option 2: User Agent Sniffing

I don't have a concise code sample for this since User Agent detection is nontrivial, but there's a great [Smashing Magazine article](https://www.smashingmagazine.com/2018/10/smart-bundling-legacy-code-browsers/) about it.

Essentially, this technique starts with the same `<script src=bundle.js>` in the HTML for all browsers. When `bundle.js` is requested, the server parses the requesting browser's User Agent string and chooses whether to return modern or legacy JavaScript, depending on whether that browser is recognized as modern or not.

While this approach is versatile, it comes with some severe implications:

* since server smarts are required, this doesn't work for static deployment (static site generators, Netlify, etc)
* caching for those JavaScript URLs now varies based on User Agent, which is highly volatile
* UA detection is difficult and can be prone to false classification
* the User Agent string is easily spoofable and new UA's arrive daily

One way to address these limitations is to combine the module/nomodule pattern with User Agent differentiation in order to avoid sending multiple bundle versions in the first place. This approach still reduces cacheability of the page, but allows for effective preloading, since the server generating our HTML knows whether to use `modulepreload` or `preload`.

```js
function renderPage(request, response) {  
  let html = `<html><head>...`;

  const agent = request.headers.userAgent;
  const isModern = userAgent.isModern(agent);
  if (isModern) {
    html += `
      <link rel=modulepreload href=modern.mjs>
      <script type=module src=modern.mjs></script>
    `;
  } else {
    html += `
      <link rel=preload as=script href=legacy.js>
      <script src=legacy.js></script>
    `;
  }

  response.end(html);
}
```

For websites already generating HTML on the server in response to each request, this can be an effective solution for modern script loading.

#### Option 3: Penalize older browsers

The ill-effects of the module/nomodule pattern are seen in old versions of Chrome, Firefox and Safari - browser versions with very limited usage, since users are automatically updated to the latest version. This doesn't hold true for Edge 16-18, but there is hope: new versions of Edge will use a Chromium-based renderer that doesn't suffer from this issue.

It might be perfectly reasonable for some applications to accept this as a trade-off: you get to deliver modern code to 90% of browsers, at the expense of some extra bandwidth on older browsers. Notably, none of the User Agents suffering from this over-fetching issue have significant mobile market share - so those bytes are less likely to be coming from an expensive mobile plan or through a device with a slow processor.

If you're building a site where your users are primarily on mobile or recent browsers, the simplest form of the module/nomodule pattern will work for the vast majority of your users. Just be sure to include the [Safari 10.1 fix](https://gist.github.com/samthor/64b114e4a4f539915a95b91ffd340acc) if you have usage from slightly older iOS devices.

```html
<!-- polyfill `nomodule` in Safari 10.1: -->  
<script type=module>  
!function(e,t,n){!("noModule"in(t=e.createElement("script")))&&"onbeforeload"in t&&(n=!1,e.addEventListener("beforeload",function(e){if(e.target===t)n=!0;else if(!e.target.hasAttribute("nomodule")||!n)return;e.preventDefault()},!0),t.type="module",t.src=".",e.head.appendChild(t),t.remove())}(document)
</script>

<!-- 90+% of browsers: -->  
<script src=modern.js type=module></script>

<!-- IE, Edge <16, Safari <10.1, old desktop: -->  
<script src=legacy.js nomodule async defer></script>  
```

#### Option 4: Use conditional bundles

One clever approach here is to use `nomodule` to conditionally load bundles containing code that isn't needed in modern browsers, such as polyfills. With this approach, the worst-case is that the polyfills are loaded or possibly even executed (in Safari 10.1), but the effect is limited to "over-polyfilling". Given that the current prevailing approach is to load and execute polyfills in all browsers, this can be a net improvement.

```html
<!-- newer browsers won't load this bundle: -->  
<script nomodule src="polyfills.js"></script>

<!-- all browsers load this one: -->  
<script src="/bundle.js"></script>  
```

Angular CLI can be configured to use this approach for polyfills, as [demonstrated by Minko Gechev](https://blog.mgechev.com/2019/02/06/5-angular-cli-features/#conditional-polyfill-serving). After reading about this approach, I realized we could switch the automatic polyfill injection in preact-cli to use it - [this PR](https://github.com/preactjs/preact-cli/pull/833/files) shows how easy it can be to adopt the technique.

For those using Webpack, there's a [handy plugin](https://github.com/swimmadude66/webpack-nomodule-plugin) for `html-webpack-plugin` that makes it easy to add nomodule to polyfill bundles.

---

### What should you do?

The answer depends on your use-case. If you're building a client-side application and your app's HTML payload is little more than a `<script>`, you might find **Option 1** to be compelling. If you're building a server-rendered website and can afford the caching impact, **Option 2** could be for you. If you're using [universal rendering](https://developers.google.com/web/updates/2019/02/rendering-on-the-web#rehydration), the performance benefits offered by preload scanning might be very important, and you look to **Option 3** or **Option 4**. Choose what fits your architecture.

Personally, I tend to make the decision to optimize for faster parse times on mobile rather than the download cost on some desktop browsers. Mobile users experience parsing and data costs as actual expenses - battery drain and data fees - whereas desktop users don't tend to have these constraints. Plus, it's optimizing for the 90% - for the stuff I work on, most users are on modern and/or mobile browsers.

### Further Reading

Interested in diving deeper into this space? Here's some places to start digging:

* There's some great additional context on Phil's [webpack-esnext-boilerplate](https://github.com/philipwalton/webpack-esnext-boilerplate/issues/1). 
* Ralph [implemented module/nomodule in Next.js](https://github.com/zeit/next.js/pull/7704), and is working on solving these issues there.

Thanks to [Phil](https://twitter.com/philwalton), [Shubhie](https://twitter.com/shubhie), [Alex](https://twitter.com/atcastle), [Houssein](https://twitter.com/hdjirdeh), [Ralph](https://twitter.com/Janicklas) and [Addy](https://twitter.com/addyosmani) for the feedback.

**2019-07-16:** fixed code sample in Option 1, which was broken due to the asynchronous `self.modern` initialization.  

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
