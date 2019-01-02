> * 原文地址：[ES6 modules support lands in browsers: is it time to rethink bundling?](https://www.contentful.com/blog/2017/04/04/es6-modules-support-lands-in-browsers-is-it-time-to-rethink-bundling/)
> * 原文作者：本文已获原作者 [Stefan Judis](https://www.contentful.com/about-us/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Aladdin-ADD](https://github.com/Aladdin-ADD),[yzgyyang](https://github.com/yzgyyang)

#  ES6 模块原生支持在浏览器中落地，是时候该重新考虑打包了吗？  #

![](http://images.contentful.com/256tjdsmm689/3xFvPzCb6wUek00gQAuU6q/0e8221e0e5c673f18d20448a9ba8924a/Contentful_ES6Modules_.png) 

最近一段日子，编写高效的 JavaScript 应用变得越来越复杂。早在几年前，大家都开始合并脚本来减少 HTTP 请求数；后来有了压缩工具，人们为了压缩代码而缩短变量名，甚至连代码的最后一字节都要省出来。

今天，我们有了 [tree shaking](https://blog.engineyard.com/2016/tree-shaking) 和各种模块打包器，我们为了不在首屏加载时阻塞主进程又开始进行代码分割，加快[交互时间](https://developers.google.com/web/tools/lighthouse/audits/time-to-interactive)。我们还开始转译一切东西：感谢 Babel，让我们能够在现在就使用未来的特性。

ES6 模块由 ECMAScript 标准制定，[定稿有些时日了](http://2ality.com/2014/09/es6-modules-final.html)。社区为它写了很多的文章，讲解如何通过 Babel 使用它们，以及 `import` 和 Node.js 的  `require` 的区别。但是要在浏览器中真正实现它还需要一点时间。我惊喜地发现 Safari 在它的 technology preview 版本中第一个装载了 ES6 模块，并且 Edge 和 Firefox Nightly 版本也将要支持 ES6 模块——虽然目前还不支持。在使用 `RequireJS` 和 `Browserify` 之类的工具后（还记得关于 [AMD 与 CommonJS  的讨论吗](https://addyosmani.com/writing-modular-js/)？），至少看起来浏览器终于能支持模块了。让我们来看看明朗的未来带来了怎样的礼物吧！🎉

## 传统方法 ##

构建 web 应用的常用方式就是使用由 Browserify、Rollup、Webpack 等工具构建的代码包（bundle）。而不使用 SPA（单页面应用）技术的网站则通常由服务端生成 HTML，在其中引入一个 JavaScript 代码包。

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

我们使用 Webpack 打包的代码包中包括了 3 个 JavaScript 文件，这些文件使用了 ES6 模块：

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

这个 app 将会显示“Hello world”。在下文中显示“Hello world”即表示脚本加载成功。

### 装载一个代码包（bundle）

配置使用 Webpack 创建一个代码包相对来说比较直观。在构建过程中，除了打包和使用 UglifyJS 压缩 JavaScript 文件之外并没有做别的什么事。

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

3 个基础文件比较小，加起来只有 347 字节。

```
$ ll app
total 24
-rw-r--r--  1 stefanjudis  staff    75B Mar 16 19:33 dep-1.js
-rw-r--r--  1 stefanjudis  staff    75B Mar  7 21:56 dep-2.js
-rw-r--r--  1 stefanjudis  staff   197B Mar 16 19:33 index.js
```

在我通过 Webpack 构建之后，我得到了一个 856 字节的代码包，大约增大了 500 字节。增加这么些字节还是可以接受的，这个代码包与我们平常生产环境中做代码装载没啥区别。感谢 Webpack，我们已经可以使用 ES6 模块了。


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

## 使用原生支持的 ES6 模块的新设定 ##

现在，我们得到了一个“传统的打包代码”，现在所有还不支持 ES6 模块的浏览器都支持这种打包的代码。我们可以开始玩一些有趣的东西了。让我们在 `index.html` 中加上一个新的 script 元素指向 ES6 模块，为其加上 `type="module"`。


```
<html><head><title>ES6 modules tryout</title><!-- in case ES6 modules are supported --><script src="app/index.js"type="module"></script><script src="dist/bundle.js"defer></script></head><body><!-- ... --></body></html>
```

然后我们在 Chrome 中看看，发现并没有发生什么事。

![image01](http://images.contentful.com/256tjdsmm689/4JHwnbyrssomECAG2GI8se/e8e35adc37bc0627f0902bcc2fdb52df/image01.png)

代码包还是和之前一样加载，“Hello world!” 也正常显示。虽然没看到效果，但是这说明浏览器可以接受这种它们并不理解的命令而不会报错，这是极好的。Chrome 忽略了这个它无法判断类型的 script 元素。

接下来，让我们在 Safari technology preview 中试试：

![Bildschirmfoto 2017-03-29 um 17.06.26](http://images.contentful.com/256tjdsmm689/1mefe0J3JKOiAoSguwMkka/0d76c5666300ed0b631a0fe548ac5b52/Bildschirmfoto_2017-03-29_um_17.06.26.png)

遗憾的是，它并没有显示另外的“Hello world”。造成问题的原因是构建工具与原生 ES 模块的差异：Webpack 是在构建的过程中找到那些需要 include 的文件，而 ES 模块是在浏览器中运行的时候才去取文件的，因此我们需要为此指定正确的文件路径：

```
// app/index.js

// 这样写不行
// import dep1 from './dep-1';

// 这样写能正常工作
import dep1 from './dep-1.js';
```

改了文件路径之后它能正常工作了，但事实上 Safari Preview 加载了代码包，以及三个独立的模块，这意味着我们的代码被执行了两次。

![image02](http://images.contentful.com/256tjdsmm689/6MeIDF7GuW6gy8om4Ceccc/a0dba00a4e0f301f2a7fd65449d044ab/image02.png)

这个问题的解决方案就是加上 `nomodule` 属性，我们可以在加载代码包的 script 元素里加上这个属性。这个属性[是最近才加入标准中的](https://github.com/whatwg/html/commit/a828019152213ae72b0ed2ba8e35b1c472091817)，Safari Preview 也是在[一月底](https://trac.webkit.org/changeset/211078/webkit)才支持它的。这个属性会告诉 Safari，这个 script 是当不支持 ES6 模块时的“退路”。在这个例子中，浏览器支持 ES6 模块因此加上这个属性的 script 元素中的代码将不会执行。

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

现在好了。通过结合使用 `type="module"` 与 `nomodule`，我们现在可以在不支持 ES6 模块的浏览器中加载传统的代码包，在支持 ES6 模块的浏览器中加载 JavaScript 模块。

你可以在 [es-module-on.stefans-playground.rocks](http://es-module-on.stefans-playground.rocks/) 查看这个尚在制定的规范。

### 模块与脚本的不同 ###

这儿有几个问题。首先，JavaScript 在 ES6 模块中运行与平常在 script 元素中不同。Axel Rauschmayer 在他的[探索 ES6](http://exploringjs.com/es6/ch_modules.html#sec_modules-vs-scripts)一书中很好地讨论了这个问题。我推荐你点击上面的链接阅读这本书，但是在此我先快速地总结一下主要的不同点：

- ES6 模块默认在严格模式下运行（因此你不需要加上 `use strict` 了）。
- 最外层的 `this` 指向 `undefined`（而不是 window）。
- 最高级变量是 module 的局部变量（而不是 global）。
- ES6 模块会在浏览器完成 HTML 的分析之后异步加载与执行。

我认为，这些特性是巨大进步。模块是局部的——这意味着我们不再需要到处使用 IIFE 了，而且我们不用再担心全局变量泄露。而且默认在严格模式下运行，意味着我们可以在很多地方抛弃 `use strict` 声明。

> 译注：IIFE 全称 immediately-invoked function expression，即立即执行函数，也就是大家熟知的在函数后面加括号。

从改善性能的观点来看（可能是最重要的进步），**模块默认会延迟加载与执行**。因此我们将不再会不小心给我们的网站加上了阻碍加载的代码，使用 `type="module"` 的 script 元素也不再会有 [SPOF](https://www.stevesouders.com/blog/2010/06/01/frontend-spof/) 问题。我们也可以给它加上一个 `async` 属性，它将会覆盖默认的延迟加载行为。不过使用  `defer` [在现在也是一个不错的选择](https://calendar.perfplanet.com/2016/prefer-defer-over-async/)。

> 译注：SPOF 全称 Single Points Of Failure——单点故障

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

如果你想详细了解这方面内容，可以阅读 [script 元素说明](https://html.spec.whatwg.org/multipage/scripting.html#the-script-element)，这篇文章简单易读，并且包含了一些示例。

## 压缩纯 ES6 代码 ##

还没完！我们现在能为 Chrome 提供压缩过的代码包，但是还不能为 Safari Preview 提供单独压缩过的文件。我们如何让这些文件变得更小呢？UglifyJS 能完成这项任务吗？

然而必须指出，UglifyJS 并不能完全处理好 ES6 代码。虽然它有个 `harmony` 开发版分支（[地址](https://github.com/mishoo/UglifyJS2/tree/harmony)）支持ES6，但不幸的是在我写这 3 个 JavaScript 文件的时候它并不能正常工作。

```
$ uglifyjs dep-1.js -o dep-1.min.js
Parse error at dep-1.js:3,23
export default function() {
                      ^
SyntaxError: Unexpected token: punc (()
// ..
FAIL: 1
```

但是现在 UglifyJS 几乎存在于所有工具链中，那全部使用 ES6 编写的工程应该怎么办呢？

通常的流程是使用 Babel 之类的工具将代码转换为 ES5，然后使用 Uglify 对 ES5 代码进行压缩处理。但是在这篇文章里我不想使用 ES5 翻译工具，因为我们现在是要寻找面向未来的处理方式！Chrome 已经[覆盖了 97% ES6 规范](https://kangax.github.io/compat-table/es6/#chrome59) ，而 Safari Preview 版[自 verion 10 之后已经 100% 很好地支持 ES6](https://kangax.github.io/compat-table/es6/#safari10_1)了。

我在推特中提问是否有能够处理 ES6 的压缩工具，[Lars Graubner](https://twitter.com/larsgraubner) 告诉我可以使用 [Babili](https://github.com/babel/babili)。使用 Babili，我们能够轻松地对 ES6 模块进行压缩。


```
// app/dep-2.js

export default function() {
  return 'Hello World. dependencies loaded.';
}

// dist/modules/dep-2.js
export default function(){return 'Hello World. dependencies loaded.'}
```

使用 Babili CLI 工具，可以轻松地分别压缩各个文件。

```
$ babili app -d dist/modules
app/dep-1.js -> dist/modules/dep-1.js
app/dep-2.js -> dist/modules/dep-2.js
app/index.js -> dist/modules/index.js
```

最终结果：

```
$ ll dist
-rw-r--r--  1 stefanjudis  staff   856B Mar 16 22:32 bundle.js

$ ll dist/modules
-rw-r--r--  1 stefanjudis  staff    69B Mar 16 22:32 dep-1.js
-rw-r--r--  1 stefanjudis  staff    68B Mar 16 22:32 dep-2.js
-rw-r--r--  1 stefanjudis  staff   161B Mar 16 22:32 index.js
```

代码包仍然是大约 850B，所有文件加起来大约是 300B。我没有使用 GZIP，因为[它并不能很好地处理小文件](http://webmasters.stackexchange.com/questions/31750/what-is-recommended-minimum-object-size-for-gzip-performance-benefits)。（我们稍后会提到这个）

## 能通过 rel=preload 来加速 ES6 的模块加载吗？ ##

对单个 JS 文件进行压缩取得了很好的效果。文件大小从 856B 降低到了 298B，但是我们还能进一步地加快加载速度。通过使用 ES6 模块，我们可以装载更少的代码，但是看看瀑布图你会发现，request 会按照模块的依赖链一个一个连续地加载。

那如果我们像之前在浏览器中对代码进行预加载那样，用 `<link rel="preload" as="script">` 元素告知浏览器要加载额外的 request，是否会加快模块的加载速度呢？在 Webpack 中，我们已经有了类似的工具，比如 Addy Osmani 的 [Webpack 预加载插件](https://github.com/GoogleChrome/preload-webpack-plugin)可以对分割的代码进行预加载，那 ES6 模块有没有类似的方法呢？如果你还不清楚 `rel="preload"` 是如何运作的，你可以先阅读 Yoav Weiss 在 Smashing Magazine 发表的相关文章：[点击阅读](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/)

但是，ES6 模块的预加载并不是那么简单，他们与普通的脚本有很大的不同。那么问题来了，对一个 link 元素加上  `rel="preload"` 将会怎样处理 ES6 模块呢？它也会取出所有的依赖文件吗？这个问题显而易见（可以），但是使用 `preload` 命令加载模块，需要解决更多浏览器的内部实现问题。[Domenic Denicola](https://twitter.com/domenic) 在[一个 GitHub issue](https://github.com/whatwg/fetch/issues/486) 中讨论了这方面的问题，如果你感兴趣的话可以点进去看一看。但是事实证明，使用 `rel="preload"` 加载脚本与加载 ES6 模块是截然不同的。可能以后最终的解决方案是用另一个 `rel="modulepreload"` 命令来专门加载模块。在本文写作时，[这个 pull request](https://github.com/whatwg/html/pull/2383) 还在审核中，你可以点进去看看未来我们可能会怎样进行模块的预加载。

## 加入真实的依赖 ##

仅仅 3 个文件当然没法做一个真正的 app，所以让我们给它加一些真实的依赖。[Lodash](https://lodash.com/) 根据 ES6 模块对它的功能进行了分割，并分别提供给用户。我取出其中一个功能，然后使用 Babili 进行压缩。现在让我们对 `index.js` 文件进行修改，引入这个 Lodash 的方法。


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

在这个例子中，`isEmpty` 基本上没有被使用，但是在加上它的依赖后，我们可以看看发生了什么：

![image07](http://images.contentful.com/256tjdsmm689/13F95Xpl32Mu0MgE0mgS2o/c9dbc002e53bf56ee0eeb0df40b55f9c/image07.png)

可以看到 request 数量增加到了 40 个以上，页面在普通 wifi 下的加载时间从大约 100 毫秒上升到了 400 到 800 毫秒，加载的数据总大小在没有压缩的情况下增加到了大约 12KB。可惜的是  [WebPagetest](https://www.webpagetest.org/) 在 Safari Preview 中不可用，我们没法给它做可靠的标准检测。

但是，Chrome 收到打包后的 JavaScript 数据比较小，只有大约 8KB。

![image05](http://images.contentful.com/256tjdsmm689/6xxfWBW9nqAeqQ8ck0MqU/62a74102e9247d785a61a84766356f51/image05.png)

这 4KB 的差距是不能忽视的。你可以在 [lodash-module-on.stefans-playground.rocks](https://lodash-module-on.stefans-playground.rocks/) 找到本示例。

### 压缩工作仅对大文件表现良好 ###

如果你仔细看上面 Safari 开发者工具的截图，你可能会注意到传输后的文件大小其实比源码还要大。在很大的 JavaScript app 中这个现象会更加明显，一堆的小 Chunk 会造成文件大小的很大不同，因为 GZIP 并不能很好地压缩小文件。

Khan Academy 在前一段时间[探究了同样的问题](http://engineering.khanacademy.org/posts/js-packaging-http2.htm)，他是用 HTTP/2 进行研究的。装载更小的文件能够很好地确保缓存命中率，但到最后它一般都会作为一个权衡方案，而且它的效果会被很多因素影响。对于一个很大的代码库来说，分解成若干个 chunk（一个 *vendor* 文件和一个 app bundle）是理所当然的，但是要装载数千个不能被压缩的小文件可能并不是一种明智的方法。

### Tree shaking 是个超 COOL 的技术 ###

必须要说：感谢非常新潮的 tree shaking 技术，通过它，构建进程可以将没有使用过以及没有被其它模块引用的代码删除。第一个支持这个技术的构建工具是 Rollup，现在 Webpack 2 也支持它——[只要我们在 babel 中禁用 `module` 选项](https://medium.freecodecamp.com/tree-shaking-es6-modules-in-webpack-2-1add6672f31b#22c4)。

我们试着改一改 `dep-2.js`，让它包含一些不会在 `dep-1.js` 中使用的东西。

```
export default function() {
  return 'Hello World. dependencies loaded.';
}

export const unneededStuff = [
  'unneeded stuff'
];
```

Babili 只会压缩文件， Safari Preview 在这种情况下会接收到这几行没有用过的代码。而另一方面，Webpack 或者 Rollup 打的包将不会包含这个 `unnededStuff`。Tree shaking 省略了大量代码，它毫无疑问应当被用在真实的产品代码库中。

## 尽管未来很明朗，但是现在的构建过程仍然不会变动 ##

ES6 模块即将到来，但是直到它最终在各大主流浏览器中实现前，我们的开发并不会发生什么变化。我们既不会装载一堆小文件来确保压缩率，也不会为了使用 tree shaking 和死码删除来抛弃构建过程。**前端开发现在及将来都会一如既往地复杂**。

不要把所有东西都进行分割然后就假设它会改善性能。我们即将迎来 ES6 模块的浏览器原生支持，但是这不意味着我们可以抛弃构建过程与合适的打包策略。在我们 Contentful 这儿，将继续坚持我们的构建过程，以及继续使用我们的  [JavaScript SDKs](https://www.contentful.com/developers/docs/javascript/) 进行打包。

然而，我们必须承认现在前端的开发体验仍然良好。JavaScript 仍在进步，最终我们将能够使用语言本身提供的模块系统。在几年后，原生模块对 JavaScript 生态的影响以及最佳实践方法将会是怎样的呢？让我们拭目以待。

## 其它资源 ##

- [ES6 模块系列文章](https://blog.hospodarets.com/native-ecmascript-modules-the-first-overview) 作者：Serg Hospodarets
- [《探索 ES6》](http://exploringjs.com/) 的 [模块章节](http://exploringjs.com/es6/ch_modules.html)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
