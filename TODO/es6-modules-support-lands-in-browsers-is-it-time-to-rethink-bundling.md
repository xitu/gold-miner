> * 原文地址：[ES6 modules support lands in browsers: is it time to rethink bundling?](https://www.contentful.com/blog/2017/04/04/es6-modules-support-lands-in-browsers-is-it-time-to-rethink-bundling/)
> * 原文作者：[Stefan Judis](https://www.contentful.com/about-us/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

#  ES6 modules support lands in browsers: is it time to rethink bundling?  #

![](http://images.contentful.com/256tjdsmm689/3xFvPzCb6wUek00gQAuU6q/0e8221e0e5c673f18d20448a9ba8924a/Contentful_ES6Modules_.png) 

Writing performant JavaScript applications is a complex matter these days. Years ago, everything started with script concatenation to save HTTP requests, and then it continued with minification and wrangling of variable names to squeeze out even the last tiny bit of the code we ship.

Today we have [tree shaking](https://blog.engineyard.com/2016/tree-shaking) and module bundlers, and we go back to code splitting to not block the main thread on startup and speed up [the time to interactivity](https://developers.google.com/web/tools/lighthouse/audits/time-to-interactive). We're also transpiling everything: using future features today? No problem – thanks to Babel!

ES6 modules have been defined in the ECMAScript specification [for a while already](http://2ality.com/2014/09/es6-modules-final.html). The community wrote tons of articles on how to use them with Babel and how `import` differs from `require` in Node.js, but it took a while until an actual implementation landed in browsers. I was surprised to see that Safari was the first one shipping ES6 modules in its technology preview channel, and now Edge and Firefox Nightly also ship this feature – even though it's behind a flag. After having used tools like [RequireJS](http://requirejs.org/) and [Browserify](http://browserify.org/) (remember [the AMD and CommonJS discussions](https://addyosmani.com/writing-modular-js/)?) it looks like modules are finally arriving in the browser landscape, so let's see a look what the bright future will bring. 🎉


## The traditional setup ##

The usual way to build web applications is to include one single bundle that is produced using Browserify, Rollup or Webpack (or any other tool out there). A classic website that's not a SPA (single page application) consists of server-side generated HTML, which then includes a single JavaScript bundle.

```
<html>
  <head>
    <title>ES6 modules tryout</title>
    <!-- defer to not block rendering -->
    <script src="dist/bundle.js" defer></script>
  </head>
  <body>
    <!-- ... -->
  </body>
</html>
```

The combined file includes three JavaScript files bundled with Webpack. These files make use of ES6 modules:

```
// app/index.js
import dep1 from './dep-1';

function getComponent () {
  var element = document.createElement('div');
  element.innerHTML = dep1();
  return element;
}

document.body.appendChild(getComponent());

// app/dep-1.js
import dep2 from './dep-2';

export default function() {
  return dep2();
}

// app/dep-2.js
export default function() {
  return 'Hello World, dependencies loaded!';
}
```

The result of this app will be a "Hello world" telling us that all files are loaded.

### Shipping a bundle ###

The Webpack configuration to create this bundle is relatively straightforward. There is not much happening right now except for the bundling and minification of the JavaScript files using UglifyJS.

```
// webpack.config.js

const path = require('path');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  entry: './app/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  plugins: [
    new UglifyJSPlugin()
  ]
};
```

The three base files are relatively small and have a total size of 347 bytes.

```
$ ll app
total 24
-rw-r--r--  1 stefanjudis  staff    75B Mar 16 19:33 dep-1.js
-rw-r--r--  1 stefanjudis  staff    75B Mar  7 21:56 dep-2.js
-rw-r--r--  1 stefanjudis  staff   197B Mar 16 19:33 index.js
```

When I ran this through Webpack, I got a bundle with the size of 856 bytes, which is roughly 500 bytes boilerplate. These additional bytes are acceptable, as it's nothing compared to the bundles most of us ship in production. Thanks to Webpack, we can already use ES6 modules.


```
$ webpack
Hash: 4a237b1d69f142c78884
Version: webpack 2.2.1
Time: 114ms
Asset       Size        Chunks  Chunk Names
bundle.js   856 bytes   0       [emitted]  main
  [0] ./app/dep-1.js 78 bytes {0}[built]
  [1] ./app/dep-2.js 75 bytes {0}[built]
  [2] ./app/index.js 202 bytes {0}[built]
```

## The new setup using native supported ES6 modules ##

Now that we have the "traditional bundle" for all the browsers that don't support ES6 modules yet, we can start playing around with the cool stuff. To do so, let's add in the `index.html` file a new script element pointing to the ES6 module with `type="module"`.


```
<html><head><title>ES6 modules tryout</title><!-- in case ES6 modules are supported --><script src="app/index.js"type="module"></script><script src="dist/bundle.js"defer></script></head><body><!-- ... --></body></html>
```

When we take a look at Chrome, we'll see that there is not much more happening.

![image01](http://images.contentful.com/256tjdsmm689/4JHwnbyrssomECAG2GI8se/e8e35adc37bc0627f0902bcc2fdb52df/image01.png)

The bundle is loaded as before, "Hello world!" is shown, but that's it. And that's excellent, because this is how web works: browsers are forgiving, they won't throw errors when they don't understand markup we send down the wire. Chrome just ignores the script element with the type it doesn't know.

Now, let's check the Safari technology preview:

![Bildschirmfoto 2017-03-29 um 17.06.26](http://images.contentful.com/256tjdsmm689/1mefe0J3JKOiAoSguwMkka/0d76c5666300ed0b631a0fe548ac5b52/Bildschirmfoto_2017-03-29_um_17.06.26.png)

Sadly, there is no additional "Hello world" showing up. The reason is the difference between build tools and native ES modules: whereas Webpack figures out which files to include during the build process, when running ES modules in the browser, we need to define concrete file paths.

```
// app/index.js

// This needs to be changed
// import dep1 from './dep-1';

// This works
import dep1 from './dep-1.js';
```

The adjusted file paths work great, except for the fact that Safari preview now loads the bundle and the three individual modules, meaning that our code will be executed twice.

![image02](http://images.contentful.com/256tjdsmm689/6MeIDF7GuW6gy8om4Ceccc/a0dba00a4e0f301f2a7fd65449d044ab/image02.png)

The solution is the `nomodule` attribute, which we can set on the script element requesting the bundle. This attribute [was added to the spec quite recently](https://github.com/whatwg/html/commit/a828019152213ae72b0ed2ba8e35b1c472091817) and Safari Preview supports it as of the [end of January](https://trac.webkit.org/changeset/211078/webkit). It tells Safari that this script is the "fallback" script for the lack of ES6 modules support, and in this case shouldn't be executed.

```
<html>
  <head>
    <title>ES6 modules tryout</title>
    <!-- in case ES6 modules are supported -->
    <script src="app/index.js" type="module"></script>
    <!-- in case ES6 modules aren't supported -->
    <script src="dist/bundle.js" defer nomodule></script>
  </head>
  <body>
    <!-- ... -->
  </body>
</html>
```

![image03](http://images.contentful.com/256tjdsmm689/1YchZEromA2ueKUCoYqMsc/2c68c46ffd2a3ad73d99d17020d56093/image03.png)

That's good. With the combination of `type="module"` and `nomodule`, we can load a classic bundle in not supporting browsers and load JavaScript modules in supporting browsers.

You can check out this state in production at [es-module-on.stefans-playground.rocks](http://es-module-on.stefans-playground.rocks/).

### Differences between modules and scripts ###

There are a few gotchas here, though. First of all, JavaScript running in an ES6 module is not quite the same as in a regular script element. Axel Rauschmayer covers this quite nicely in [his book Exploring ES6](http://exploringjs.com/es6/ch_modules.html#sec_modules-vs-scripts). I highly recommend you check it out but let's just quickly mention the main differences:

- ES6 modules are running in strict mode by default (no need for `'use strict'` anymore).
- Top-level value of `this` is `undefined`.
- Top-level variables are local to the module.
- ES6 modules are loaded and executed asynchronously after the browser finished parsing the HTML.

In my opinion, these are all huge advantages. Modules are local – there is no need for IIFEs around everything, and also we don't have to fear global variable leaking anymore. Also running in strict mode by default means that we can drop a lot of `'use strict'` statements.

And from a performance point of view (probably the most important one) **modules load and execute deferred by default**. So we won't accidentally add blocking scripts to our website and there is no [SPOF](https://www.stevesouders.com/blog/2010/06/01/frontend-spof/) issue when dealing with script `type="module"` elements. We could place an `async` attribute on it, which overwrites the default deferred behavior, but `defer`[is a good choice these days](https://calendar.perfplanet.com/2016/prefer-defer-over-async/).

```
<!-- not blocking with defer default behavior -->
<script src="app/index.js" type="module"></script>

<!-- executed after HTML is parsed -->
<script type="module">
  console.log('js module');
</script>

<!-- executed immediately -->
<script>
  console.log('standard module');
</script>
```

In case you want to check the details around that, the [script element spec](https://html.spec.whatwg.org/multipage/scripting.html#the-script-element) is an understandable read and includes some examples.

## Minifying of pure ES6 ##

But we're not quite there yet! We serve a minified bundle for Chrome and individual not minified files for Safari Preview now. How can we make these smaller? UglifyJS should do the job just fine, right?

It turns out that UglifyJS is not able to fully deal with ES6 code yet. There is a `harmony` development branch available, but unfortunately it didn't work with my three JavaScript files at the time of writing.

```
$ uglifyjs dep-1.js -o dep-1.min.js
Parse error at dep-1.js:3,23
export default function() {
                      ^
SyntaxError: Unexpected token: punc (()
// ..
FAIL: 1
```


But UglifyJS is in every toolchain today, how does this work for all the projects written in ES6 out there?

The usual flow is that tools like Babel transpile to ES5, and then Uglify comes into play to minify this ES5 code. I want to ignore ES5 transpilation in this article: we're dealing with the future here, Chrome has [97% ES6 coverage](https://kangax.github.io/compat-table/es6/#chrome59) and Safari Preview has already fabulous [100% ES6 coverage since version 10](https://kangax.github.io/compat-table/es6/#safari10_1).

I asked the Twittersphere if there is a minifier available that can deal with ES6, and [Lars Graubner](https://twitter.com/larsgraubner) pointed me towards [Babili](https://github.com/babel/babili). Using Babili, we can easily minify the ES6 modules.


```
// app/dep-2.js

export default function() {
  return 'Hello World. dependencies loaded.';
}

// dist/modules/dep-2.js
export default function(){return 'Hello World. dependencies loaded.'}
```

With the Babili CLI tool, it's almost too easy to minify all the files separately.

```
$ babili app -d dist/modules
app/dep-1.js -> dist/modules/dep-1.js
app/dep-2.js -> dist/modules/dep-2.js
app/index.js -> dist/modules/index.js
```

The result looks then as follows.

```
$ ll dist
-rw-r--r--  1 stefanjudis  staff   856B Mar 16 22:32 bundle.js

$ ll dist/modules
-rw-r--r--  1 stefanjudis  staff    69B Mar 16 22:32 dep-1.js
-rw-r--r--  1 stefanjudis  staff    68B Mar 16 22:32 dep-2.js
-rw-r--r--  1 stefanjudis  staff   161B Mar 16 22:32 index.js
```

The bundle is still roughly around 850B, and all the files are around 300B in total. I'm ignoring GZIP compression here as [it doesn't work well on such small file sizes](http://webmasters.stackexchange.com/questions/31750/what-is-recommended-minimum-object-size-for-gzip-performance-benefits) (we'll get back to that later).

## Speeding up ES6 modules with rel=preload? ##

The minification of the single JS files is a huge success. It's 298B vs. 856B, but we could even go further and speed things up more. Using ES6 modules we are now able to ship less code, but looking at the waterfall again we'll see that the requests are made sequentially because of the defined dependency chain of the modules.

What if we could throw `<link rel="preload" as="script">` elements in the mix which can be used to tell the browser upfront that additionally requests will be made soon? We have build tool plugins like Addy Osmani's [Webpack preload plugin](https://github.com/GoogleChrome/preload-webpack-plugin) for code splitting already – is something like this possible for ES6 modules? In case you don't know how `rel="preload"` works, you should check out the [article on this topic](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) by Yoav Weiss on Smashing Magazine.

Unfortunately, preloading of ES6 modules is not so easy because they behave differently than normal scripts. The question is how a link element with a set `rel="preload"` attribute should treat an ES6 module? Should it fetch all the dependent files, too? This is an obvious question to answer, but there are more browser internal problems to solve, too, if module treatment should go into the `preload` directive. In case you're interested in this topic [Domenic Denicola](https://twitter.com/domenic) discusses these problems [in a GitHub issue](https://github.com/whatwg/fetch/issues/486), but it turns out that there are too many differences between scripts and modules to implement ES6 module treatment in the `rel="preload"` directive. The solution might be another `rel="modulepreload"` directive to clearly separate functionalities, with [the spec pull request](https://github.com/whatwg/html/pull/2383) pending at the time of writing, so let's see how we'll preload modules in the future.

## Bringing in real dependencies ##

Three files don't make a real app, so let's add a real dependency. Fortunately, [Lodash](https://lodash.com/) offers all of its functionality also in split ES6 modules, which I then minified using Babili. So let's modify the `index.js` file to also include a Lodash method.


```
import dep1 from './dep-1.js';
import isEmpty from './lodash/isEmpty.js';

function getComponent() {
  const element = document.createElement('div');
  element.innerHTML = dep1() + ' ' + isEmpty([]);

  return element;
}

document.body.appendChild(getComponent());
```

The use of `isEmpty` is trivial in this case, but let's see what happens now after adding this dependency.

![image07](http://images.contentful.com/256tjdsmm689/13F95Xpl32Mu0MgE0mgS2o/c9dbc002e53bf56ee0eeb0df40b55f9c/image07.png)

The request count went up to over 40, the page load time went up from roughly 100ms to something between 400ms and 800ms on a decent wifi connection, and the shipped overall size increased to approximately 12KB without compression. Unfortunately, Safari Preview is not available on [WebPagetest](https://www.webpagetest.org/) to run some reliable benchmarks.

Chrome receiving the bundled JavaScript, on the other hand, is at a slim ~8KB file size.

![image05](http://images.contentful.com/256tjdsmm689/6xxfWBW9nqAeqQ8ck0MqU/62a74102e9247d785a61a84766356f51/image05.png)

This 4KB difference is definitely something to check. You can find this example at [lodash-module-on.stefans-playground.rocks](https://lodash-module-on.stefans-playground.rocks/).

### Compression works only well on larger files ###

In case you looked closely at the screenshots of the Safari developer tools, you might have noticed that the transferred file size was actually bigger than the source. Especially in a large JavaScript app, including a lot of small chunks makes a big difference and that's because GZIP doesn't play well with small file sizes.

Khan Academy [discovered the same thing](http://engineering.khanacademy.org/posts/js-packaging-http2.htm) a while ago when experimenting with HTTP/2. The idea of shipping smaller files is great to guarantee perfect cache hit ratios, but at the end, it's always a tradeoff and it's depending on several factors. For a large code base splitting the code into several chunks (a *vendor* and an *app* bundle) makes sense, but shipping thousands of tiny files that can't be compressed properly is not the right approach.

### Tree shaking is the cool kid in town ###

Another thing to point out is that thanks to the relatively new tree shaking mechanism, build processes can eliminate code that's not used and imported by any other module. The first build tool that supported this was Rollup, but now Webpack in version 2 supports it as well — [as long as we disable the `module` option in babel](https://medium.freecodecamp.com/tree-shaking-es6-modules-in-webpack-2-1add6672f31b#22c4).

Let's say we changed `dep-2.js` to include things that won't be imported by `dep-1.js`.

```
export default function() {
  return 'Hello World. dependencies loaded.';
}

export const unneededStuff = [
  'unneeded stuff'
];
```

Babili will simply minify the file and Safari Preview, in this case, would receive several code lines that are not used. A Webpack or Rollup bundle, on the other hand, won't include `unneededStuff`. Tree shaking offers huge savings that definitely should be used in a real production code base.

## The future looks bright, but build processes are here to stay ##

So, ES6 modules are on their way, but it doesn't look like anything will change when they finally arrive in all the major browsers. We won't start shipping thousands of tiny files to guarantee good compression, and we won't abandon build processes to make use of tree shaking and dead code elimination. **Frontend development is and will be as complicated as always**.

**The most important thing to remember is that measuring is the key to succees**. Don't split everything and assume that it will lead to an improvement. Just because we might have support for ES6 modules in browsers soon, it doesn't mean that we can get rid of a build process and a proper "bundle strategy". Here at Contentful we'll stick to our build processes, and continue to ship bundles including our [JavaScript SDKs](https://www.contentful.com/developers/docs/javascript/).

Yet, I have to admit that Frontend development still feels great. JavaScript evolves, and we'll finally have a way to deal with modules baked into the language. I can't wait to see how and if this influences the JavaScript ecosystem and what the best practices will be in a couple of years.

## Additional resources ##

- [Article series on ES6 modules](https://blog.hospodarets.com/native-ecmascript-modules-the-first-overview) by Serg Hospodarets
- [The modules chapter](http://exploringjs.com/es6/ch_modules.html) in "[Exploring ES6](http://exploringjs.com/)"

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
