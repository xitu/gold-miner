>* 原文链接 : [Why our website is faster than yours](https://www.voorhoede.nl/en/blog/why-our-website-is-faster-than-yours/)
* 原文作者 : [by Declan](https://www.voorhoede.nl/en/contact/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [hpoenixf](https://github.com/hpoenixf)
* 校对者: [MAYDAY1993](https://github.com/MAYDAY1993),[circlelove](https://github.com/circlelove)

# 如何运用最新的技术提升网页速度和性能

我们最近升级了我们的网站。虽然这主要是界面方面的大调整，但作为一个软件开发者，我们更关注在技术细节上面。我们的目标是加强控制，关注性能，在未来可以灵活地调整和让在网站上撰写内容变得有趣。下面讲述了我们是如何让我们的网站比你的快的（呀，不好意思！）

## 为了性能而设计

开发项目的时候，我们每天都会跟设计师和产品经理讨论性能和美观的平衡。对于我们的网站来说，这是简单的。简单来说：我们相信尽快的展现内容是良好用户体验的开始。这意味着**性能 > 美观**

好的内容，布局，图片和交互对吸引你的用户是必要的，但这些元素都影响着页面的加载时间和用户体验。在每一步我们都在想办法在提升用户体验和设计时的同时给性能带来尽可能小的影响。

## 内容优先

我们想要把核心内容-也就是基本的 HTML 和 CSS -尽可能快的展现给用户。每一个页面都应该支持内容最主要的目标：传达信息。增强的功能，也就是 JavaScript ，完整的 CSS 文件，网络字体，图片和分析相对于核心内容来说都是次要的

## 获取控制

在定义了我们为理想网站设定的标准后，我们总结出我们需要对网站的每一点都需要有完全的控制。我们选择构建我们自己的静态页面生成器，包括资源管道，并且自己搭建它。

### 静态页面生成器

我们使用 Node.js 写了我们自己的静态页面生成器。它可以利用带有简单的 JSON 页面描述的 Markdown 文件来生成具有全部资源和完整结构的页面。它也可以使用包含有页面特征的 JavaScript 代码的 HTML 文件。

下面是一个关于这篇博客的简略的元描述和 markdown 文件，可以用来生成实际的 HTML 文件。

JSON 元描述：


    {
      "keywords": ["performance", "critical rendering path", "static site", "..."],
      "publishDate": "2016-07-13",
      "authors": ["Declan"]
    }
markdown 文件：


    # Why our website is faster than yours
    We've recently updated our site. Yes, it has a complete...
    
    ## Design for performance
    In our projects we have daily discussions...
    
## 图片分发
[页面的平均大小有 2406kb，其中 1535kb 是图片](http://httparchive.org/interesting.php)。
因为对于普通的网站来说，图片占据了如此大的一部分，图片也成了改善性能的最好的目标之一。

![Average bytes per page by content type chart](https://www.voorhoede.nl/assets/images/average-bytes-per-page-chart-l.jpg)

来自httparchive.org对2016年7月不同种类内容在页面的平均大小的统计
### WebP
 
WebP 是一个现代的图片格式，可以对网络图片进行优秀的无损或有损压缩。比起其他的格式 WebP 的体积大幅度的减小，有时可以比 JPEG 对照图片体积要小25%。 WebP 经常被忽视和很少被使用。在写这篇文章的时候， WebP 只有[Chrome, Opera and Android](http://caniuse.com/#feat=webp)支持（对于用户来说仍然超过了50%的份额），但我们可以优雅降级到JPG/PNG。

### `<picture>` 元素

通过使用图片元素，我们可以从WebP优雅降级到更广泛支持的格式如JPEG：


    <picture>
        <source type="image/webp" srcset="image-l.webp" media="(min-width: 640px)">
        <source type="image/webp" srcset="image-m.webp" media="(min-width: 320px)">
        <source type="image/webp" srcset="image-s.webp">
        <source srcset="image-l.jpg" media="(min-width: 640px)">
        <source srcset="image-m.jpg" media="(min-width: 320px)">
        <source srcset="image-s.jpg">
        <img alt="Description of the image" src="image-l.jpg">
    </picture>
我们使用 [ Scott Jehl的 picturefill ](https://github.com/scottjehl/picturefill)去给不支持 `<picture>`元素的浏览器加上兼容补丁使其可以在所有浏览器都能有一样的表现。

我们使用`<img>`格式来防止浏览器不支持`picture`元素或者JavaScript。

### 生成

尽管已经确定了合适的图片分发方法，我们仍然需要寻找一个代价较小的方法来应用它。因为它的强大，我喜欢 picture 元素，但我讨厌写上面的那些片段。特别是在我写内容的时候不得不这样引入它们。我们不想为了给 markdown 文件的每张图片引入六个实例，优化图片和写`<picture>`元素而烦恼，所以我们：

- 在构建的过程**产生**原始图片的多重实例，包括输入格式（JPG，PNG）和 WebP 。我们使用了 [gulp responsive](https://github.com/mahnunchik/gulp-responsive)来完成这步。
- **最小化** 生成的图片
- 在 mardown 文件中**编写** 图片的描述
- 在构建的过程使用自定义的 Markdown 渲染器把普通的 markdown 图片引用**编译**成完整的 `<picture>`元素。

##SVG 动画

我们为我们的网站挑选了一种独特的图片风格，在这里 SVG 图片扮演了主要的角色。我们出于一些原因这样做。


- 首先， SVG （矢量图片）比点阵图片要小。
- 第二， SVG 本质就是响应式的，可以完美的保持清晰。因此不需要图片转换和`<picture>`元素;
- 最后一点我们可以通过 CSS 让他运动和变化！这是为了性能而设计的完美例子。 [我们的页面作品集](https://www.voorhoede.nl/en/portfolio/)有可以被综述页重新使用的一个自定义的动态 SVG 。它在我们的作品集中呈现了一个反复出现的风格，让我们的设计连贯一致，对性能的只有很小的影响。

来看下我们的动画和我们是怎样通过CSS来调整它的



## 自定义网络字体

在深入讲述之前，先初步介绍一下浏览器处理自定义网络字体的过程。当浏览器在 CSS 中发现`@font-face`的指向字体文件的声明而在用户的电脑中找不到的时候，它会尝试下载这个字体文件。在下载的时候，大部分浏览器不会展现使用该字体的文字。这种现象被称为"隐藏文件的闪烁"或是 FOIT 。如果你知道该怎么找，你会发现它几乎存在于网络的每一个地方。在我看来，这给用户体验带来不好的影响。它延迟了用户实现核心目标：阅读内容

我们可以使浏览器把这行为改为“无样式内容的闪烁”或是 FOUT 。我们先告诉浏览器使用普通的字体，像是 Arial 或 Grorgia 。一旦自定义网络字体下载完成，浏览器会替换标准字体并重新渲染全部文本。如果自定义字体加载失败，内容依然可以完美的被阅读。有些人可能把这看成一种回调，我们把这看成一种增强。如果没有它，网站看起来良好并 100% 工作。只需要通过勾选勾选框来切换我们的自定义字体和观察。

切换字体加载的类

使用自定义字体文件会给我们的用户体验带来好处，只要你优化和可靠的分发它们。

构建子集是提升网络字体性能最快的方法。我想把它推荐给每一个使用网络字体的开发者。如果你对内容有完全的控制并知道需要展示哪些字符，你可以构建你的子集。即使仅仅把你的字体构建成“西方语言”也会对你的文件的尺寸有很大的作用。举个例子，我们的 Noto 标准`WOFF`字体，默认有 246KB 大小，一个构建一个西方语言的子集，仅有 31KB 大。我们用这个比较容易使用的[Font squirrel webfont generator](https://www.fontsquirrel.com/tools/webfont-generator)

###  Font face observer


[Bram Stein的Font face observer](https://github.com/bramstein/fontfaceobserver)是一个了不起的用于判断字体是否加载的辅助脚本。你的字体是怎么被加载的是很难确定的，或许是通过网络字体服务，或许是你自己提供。在 font face observer脚本通知我们所有自定义脚本文件加载完成后，我们给`<html>`元素增加一个`fonts-loaded`类。我们以此给页面加入样式：



    html {
       font-family: Georgia, serif;
    }
    
    html.fonts-loaded {
       font-family: Noto, Georgia, serif;
    }

*注意:为了简洁，我没有在上面的 css 中加入 Noto 的`@font-face`的声明*。

我们还设置了 cookie 来记忆加载过的字体，并保存在浏览器的缓存中。我们为了重复浏览使用 cookie ，着我会在后面解释。

在不远的将来，我们可能会不再需要 Bram Stein 的 JavaScript 代码。CSS 工作组提出了新的`@font-face`描述符（叫做`font-display`），这个属性值可以控制可以下载的字体在加载完成之前是怎么渲染的。这个 css 语句 `font-display: swap`会给我们跟上面方法一样的效果。 [阅读更多关于 `font-display` 属性](https://developers.google.com/web/updates/2016/02/font-display).


## 懒加载 JS 和 CSS

通常来说，我们有一个尽可能快加载资源的方法。我们排除了阻塞渲染的请求并对首页浏览做了优化，为了重复浏览用到了浏览器缓存。

### 懒加载 JS

在设计上，我们的网站没有大量的 JavaScript 文件。为了我们已有或是将来打算使用的 js 文件，我们研发了一种 JavaScript 工作流。

JavaScript放在`<head>`的话会阻塞渲染，然而我们不希望这样。 JavaScript 只应该用来提升用户体验。它对用户来说并不是必要的。一个简单的避免 JavaScript 阻塞渲染的方式是把它放到你的页面的尾部。缺点是只有整个 HTML 都下载完成后才会开始下载脚本。

一个替代方案是把脚本放到头部并通过在`<script>`标签上增加`defer`属性来延缓它的执行。这让脚本不会阻塞并几乎可以立刻被下载，不用在整个页面被加载后才执行代码。

还有一件事情，我们不用像 jQuery 之类的库文件因此我们的 JavaScript 使用原生的 JavaScript 特性。我们只想在支持这些特性的浏览器中加载 JavaScript 。最后结果像这样：


    <script>
    if ('querySelector'indocument && 'addEventListener'inwindow) {
      document.write('<script src="index.js" defer><\/script>');
    }
    </script>

我们把这个小巧的内嵌脚本放到页面的头部来侦测原生的`document.querySelector` 和 `window.addEventListener`JavaScript是否被支持。如果是这样的话，我们通过在页面直接写`script`标签来加载脚本，然后使用`defer`属性让它不阻塞。


### 懒加载 CSS

对我们的网站来说，在首屏浏览中最大的阻塞资源是 CSS。浏览器会延迟页面的渲染，直到`<head>`中的 CSS 引用全部被下载和解析。这个行为是经过考虑的，否则浏览器会在渲染页面的时候不断重新计算布局和重新绘制页面。

为了避免 CSS 阻塞渲染，我们需要异步加载 CSS 文件。我们使用了神奇的 Filament Group 的[loadCSS function](https://github.com/filamentgroup/loadCSS).它会在你的 CSS 文件加载后给你一个回调，在回调函数里我们设置 cookie 来说明 CSS 已经加载了。我们是为了重复浏览来使用 cookie，这我会在等一下解释。

异步加载 CSS 会有一个小`问题`，因为在这时候 HTML 会很快的渲染完成展现成只有 HTML 而没有应用到 CSS 的样子，直到全部 CSS 被下载和解析。这就是使用关键 CSS 的原因。

### 关键 CSS

关键 CSS 的定义就是*让页面可以被用户辨识的最小体积的阻塞CSS*。我们关注`首屏`的内容。显然这个位置会根据设备不同而变化，所以我们做了最好的预测。

人工决定关键 CSS 是一个很消耗时间的过程，特别是未来样式改变的时候。这里有一个可以在你的构建过程中生成关键 CSS 的一个很棒的脚本。我们使用了强大的[Addy Osmani的critical](https://github.com/addyosmani/critical)。


看下面的分别使用关键 CSS 和完整 CSS 渲染的我们的主页。注意看在边缘下面的页面是仍然没有样式的。![Fold illustration](https://www.voorhoede.nl/assets/images/voorhoede-fold-l.jpg)左边的页面是只用关键 CSS 渲染的主页，而右边的页面使用完整的 CSS，红线代表边缘线。

## 服务器

我们自己架构了 de Voorhoede站点，因为我们想要控制服务器的环境。我们想实验一下我们可以怎样通过改变服务器配置来提升性能。在这个时候我们有一个 Apache 网站服务器并且我们把我们站点设置为 HTTPS 服务。

### 配置

为了增强性能和安全，我们需要研究一下怎么配置服务器。

我们使用[H5BP boilerplate apache configuration](https://github.com/h5bp/server-configs-apache)，这是提升你的 Apache 网络服务器性能跟安全性的好的开始。他们也有提供别的服务器环境的配置。

我们使用 GZIP 来压缩大部分的 HTML，CSS 和 JavaScript。我们为我们全部的资源设置一致的缓存头。可以阅读[the file level caching section](https://www.voorhoede.nl/en/blog/why-our-website-is-faster-than-yours/#file-level-caching).

### HTTPS

在你的网站使用 HTTPS 服务会对性能有影响。这个不良影响主要来自于设置 SSL 握手，导致大量的等待时间。但是，跟其他地方一样，我们可以在这方面做些工作！

**HTTP严格传输安全**是一个 HTTP 头，可以让服务器告诉浏览器它只允许使用 HTTPS 通讯。这个方法避免了 HTTP 请求被重定向为 HTTPS 。所有试图连接到这个网站的 HTTP 应该自动被转换。它节省了一个来回。

**TLS 错误开端** 允许客户端在第一个 TLS 来回之后立刻发送加密数据。这个优化对于新的 TLS 链接把握手减少到了一个来回。一旦客户端知道密钥便可以开始传输应用数据。剩下的握手用于确认没人在篡改握手记录，并可以并行执行。

**TLS会话恢复** 通过确认浏览器和服务器在过去是否在 TLS 上通信过的节约了另一个来回，浏览器可以记忆 session 标识符，在下一次建立连接时，标识符可以重新使用并节约一个来回。

我听起来像一个开发运营工程师，但我不是。我只是读了一些东西并看了一些视频。我喜欢来自 Google I/O 2016的[Mythbusting HTTPS: Squashing security’s urban legends by Emily Stark](https://www.youtube.com/watch?v=YMfW1bfyGSY)
### cookies 的使用

我们没有服务器端的语言，只有静态的Apache网络服务器。但一个 Apache 网络服务器仍然可以执行 server side includes（SSI）和阅读 cookies。通过巧妙的使用 cookies 和分发部分被 Apache 重写的 HTML，我们可以加速前端的性能。看下面的例子（我们实际的代码要复杂一点，但可以归纳为一样的想法）：


    <!-- #if expr="($HTTP_COOKIE!=/css-loaded/) || ($HTTP_COOKIE=/.*css-loaded=([^;]+);?.*/ && ${1} != '0d82f.css' )"-->
    <noscript><link rel="stylesheet" href="0d82f.css"></noscript><script>
    (function() {
        function loadCSS(url) {...}
        function onloadCSS(stylesheet, callback) {...}
        function setCookie(name, value, expInDays) {...}
    
        var stylesheet = loadCSS('0d82f.css');
        onloadCSS(stylesheet, function() {
            setCookie('css-loaded', '0d82f', 100);
        });
    }());
    </script>
    <style>/* Critical CSS here */</style>
    <!-- #else -->
    <link rel="stylesheet" href="0d82f.css">
    <!-- #endif -->
Apache 服务器端的逻辑是以 `<!-- #`开始的像备注一样的地方。我们一步一步的开始：


- `$HTTP_COOKIE!=/css-loaded/` 检查是否没有 CSS 缓存 cookie 存在
- `$HTTP_COOKIE=/.*css-loaded=([^;]+);?.*/ && ${1} != '0d82f.css'` 检查 CSS 缓存的版本是否最新的版本
- If `<!-- #if expr="..." -->` 如果这是访问者的第一次浏览，我们赋值为`true`
- 对于第一次浏览，我们增加一个 `<noscript>` 标签带有阻塞的`<link rel="stylesheet">`。我们为了可以通过 JavaScript 来异步加载完整CSS而这样做。如果 JavaScript 被禁止了，这是不可能完成的。这代表着一种后备方案，我们 `按照常规` 用阻塞方式加载 CSS.。
- 我们增加一个带有懒加载 CSS 和 `onloadCSS` 回调及设置 cookies 的函数的嵌入脚本
- 在同一个脚本我们异步载入完整 CSS。
- 在 `onloadCSS` 回调我们把带有版本哈希的 cookie 值设置成 cookie。
- 在脚本之后我们增加关键 CSS 的嵌入样式表。这会阻塞，但阻塞很小并避免页面展示无样式的 HTML。
- 这个`<!-- #else -->` 语句(意味着`css-loaded`的 cookie **存在**)说明访问者是再次浏览。因为我们可以预测 CSS 文件之前加载过因此我们可以借助浏览器缓存来使用阻塞的方式来加载样式表。它会从缓存中读取并即时加载。

同样的方法可以用于为了首屏浏览而异步加载字体，假设我们可以在再次浏览中从浏览器缓存中读取他们。
![Cookie overview screenshot](https://www.voorhoede.nl/assets/images/voorhoede-cookies-l.jpg)看我们的 cookies 是如何被用于区分第一次浏览和重复浏览。
## 文件级别缓存

因为我们在重复浏览中很依赖于浏览器缓存，我们需要确认我们的缓存是正确的。我们在理想情况下想永久缓存资源（css,js,fonts,images），仅在文件改变的时候让缓存无效。如果URL是独特的话，缓存是无效的。当我们发布新版本时，我们`git tag`我们的网站，最简单的方式是增加一个带版本号的查询参数来请 URLs。像`https://www.voorhoede.nl/assets/css/main-dddd3f52a5.css?v=1.0.4`。但是，这个方法的缺点是当我们需要写一个新的博客推送（这是我们的代码库的一部分，不是存放在外部的 CMS），我们所有的资源的缓存会无效化，尽管这些资源没有变化。

当尝试升级我们的方法时，我们偶然发现 [gulp-rev](https://github.com/sindresorhus/gulp-rev) 和 [gulp-rev-replace](https://github.com/jamesknelson/gulp-rev-replace)。这些脚本通过在文件名加上内容哈希来帮助我们修订文件版本。这意味着只有文件实际变化时URL请求才会变化。现在我们有了基于每个文件的缓存无效化处理。这让我的心跳变得猛烈了！

## 结果

如果你来到这里（了不起！）你可能想要知道结果。测试你的网站性能可以通过带有比较可行的提示的 [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) 和带有大量网络分析的 [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) 这些工具来完成。我想最好的展现你的网站渲染性能的方法是在极端限制你的网络链接的情况下观察你的页面的变化。这代表着：限制网络到基本不现实的地步。在 Google 你可以限制你的链接（通过 inspector > Network tab）并看请求是怎么慢慢的在你的页面构建的情况下加载。

看一下我们的主页是怎么在被限制的 50KB/S 的 GPRS 连接下加载。
![Network analysis for de Voorhoede site for the first page view](https://www.voorhoede.nl/assets/images/voorhoede-network-analysis-l.jpg)一个关于页面第一次浏览时演化的总览。
在 50KB/S 的 GPRS 网络下首次访问我们的网站的第 2.27 秒，我们的首屏渲染的情况可以在幻灯片的第一张图片和与黄线对应的瀑布流上观察。黄线在 HTML 被加载后的右侧绘制。 HTML 包括关键 CSS，保证了页面是可用的。所有其他的阻塞资源被设置为懒加载的，因此我们可以在别的部分被下载后再跟页面进行交互。这就是我们想要的！

另一个需要注意的是自定义字体在这样的慢连接下是不会被加载的。font face observer 会关注这一点，如果我们不异步加载字体，在大多数浏览器你会在FOIT等待一段时间。

完整的 CSS 文件在 8 秒后才被加载。相反，如果我们使用阻塞方式加载完整CSS而不是嵌入关键 CSS，我们可能会盯着白屏页面 8 秒。

如果你好奇这些时间跟不那么关注性能的页面相比是怎样的结果，就去试试吧。加载时间会涨破屋顶！

利用前面介绍的工具来测试我们的网站也会得到一些好的结果。PageSpeed insights 给我们在移动端的表现 100/100 的分数，多么了不起！

![PageSpeed insights results for voorhoede.nl](https://www.voorhoede.nl/assets/images/pagespeed-insights-voorhoede-l.jpg)Woohoo! 100/100 on speed
当我们看 WebPagetest 我们得到下面的结果：
![WebPagetest results for voorhoede.nl](https://www.voorhoede.nl/assets/images/webpagetest-voorhoede-l.jpg)WebPagetest results for voorhoede.nl
我们可以看到我们的服务端性能很好并且首次浏览性能指数是 693 .这代表我们的页面在网线连接的情况下 693 毫秒后便可以使用。看起来很好！

##发展路线

我们还没完成并在不断的迭代改进我们的方法。在最近我们会关注：

-
**HTTP/2**: 我们最近正在实验使用它。这篇文章描述的很多东西是基于 HTTP/1.1 的限制下的最佳实践。简单来说： HTTP/1.1 诞生在表格布局和内嵌样式都让人觉得惊奇的 1999 年。HTTP/1.1 完全没有为了带有 200 个请求的 2.6MB 的页面而设计。为了减轻我们可怜的旧协议的压力，我们链接 JS，CSS 和内嵌关键 CSS ，为小图片使用 URI 等等。每一个都是用来减少请求的。但是 HTTP/2 可以在同一个 TCP 链接上并行运行多重请求，这些串联和减少请求的方法可能会被证实为反模式。我们会在完成实验后迁移到 HTTP/2。


-
**Service Workers**:这是一个可以运行在后台的现代浏览器的 JavaScript API 。它让很多之前网站不支持的特性如离线支持，推送通知，后台同步等等变得可以使用。我们正在研究 Service Workers，但我们仍然需要把它引入到我们的网站。我向你保证，我们会！

-
**CDN**:因此，我们想要控制和自己架构我们的网站。是的，是的，现在我们想要迁移到 CDN 来避免由于客户端和服务器的物理距离的延迟。尽管我们的客户大部分在荷兰，我们想要通过展现我们的最好一面来跟前端开发社区接触：质量，性能，推动网络向前发展。

谢谢阅读！你享受阅读这篇文章吗？你有评论或者问题吗？让我们知道通过 [Twitter](https://twitter.com/devoorhoede)。如果你享受构建快的网站，为什么不[加入我们](https://www.voorhoede.nl/en/team/)?

