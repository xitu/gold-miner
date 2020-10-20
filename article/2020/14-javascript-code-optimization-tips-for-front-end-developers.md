> * 原文地址：[14 JavaScript Code Optimization Tips for Front-End Developers](https://blog.bitsrc.io/14-javascript-code-optimization-tips-for-front-end-developers-a44763d3a0da)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/14-javascript-code-optimization-tips-for-front-end-developers.md](https://github.com/xitu/gold-miner/blob/master/article/2020/14-javascript-code-optimization-tips-for-front-end-developers.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[plusmultiply0](https://github.com/plusmultiply0), [rachelcdev](https://github.com/rachelcdev)

# 给前端开发者的 14 个 JavaScript 代码优化建议

![](https://cdn-images-1.medium.com/max/2560/1*MgoAGKBmwDGomYOe4hspxw.jpeg)

JavaScript 已经成为当下最流行的编程语言之一。根据 [W3Tech](https://w3techs.com/technologies/details/cp-javascript)，全世界几乎 96% 的网站都在使用它。关于网站，你需要知道的最关键的一点是，你无法控制访问你网站的用户的硬件设备规格。访问你的网站的终端用户也许使用了高端或低端的设备，用着好的或差的网络连接。这意味着你必须确保你的网站是尽可能优化的，你能够满足任何用户的要求。

这里有一些技巧，可以帮助你更好地优化 JavaScript 代码，从而提高性能。

顺便提一下，为了共享和复用 JS 组件，需要在高质量代码（需要花时间）和合理交付时间之间保持正确的平衡。你可以使用流行的工具例如 [**Bit**](https://bit.dev) ([Github](https://github.com/teambit/bit))，去共享组件（vanilla JS, TS, React, Vue 等）到 Bit 的 [component hub](https://bit.dev)，而不浪费太多时间。

## 1. 删除不使用的代码和功能

程序包含越多的代码，给客户端传递的数据就越多。浏览器也需要更多的时间去解析和编译代码。

有时，代码里也许会包含完全未使用到的功能，最好只将这些额外的代码保留在开发环境中，并且不要把它们留到生产环境中，因为无用的代码可能会增加客户端浏览器的负担。

**经常问自己那个函数、特性或代码是否是必需的。**

你可以手动的删掉无用的代码，也可以用工具 [Uglify](https://github.com/mishoo/UglifyJS#compressor-options) 或 [谷歌开发的 Closure Compiler](https://developers.google.com/closure/compiler/docs/api-tutorial3) 帮你删。你甚至可以使用一种叫做 tree shaking 的技术来删除程序中未使用的代码。例如打包工具 Webpack 就提供了它。你可以在 [这里](https://medium.com/@bluepnume/javascript-tree-shaking-like-a-pro-7bf96e139eb7) 了解更多关于 tree shaking 信息。还有，如果你想删掉未使用的 npm 包，你可以输入命令 `npm prune` 。阅读 [NPM 文档](https://docs.npmjs.com/cli-commands/prune.html) 了解更多。

## 2. 尽可能缓存

缓存通过减少等待时间和网络请求提高了网站的速度和性能，因此减少了展示资源的时间。可以借助于 [缓存 API](https://developer.mozilla.org/en-US/docs/Web/API/Cache) 或 [HTTP 缓存](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching) 实现它。你也许好奇当内容改变时发生了什么。上述缓存机制能够在满足某些条件（如发布新内容）时处理和重新生成缓存。

## 3. 避免内存泄漏

作为一种高级语言，JS 负责几个低级别的管理，比如内存管理。对于大多数编程语言来说，垃圾回收是一个常见的过程。通俗地说，垃圾回收就是简单地收集和释放，那些已经分配给对象，但目前又不被程序任一部分使用的内存。在像 C 这样的编程语言中，开发者必须使用 `malloc()` 和 `dealloc()` 函数来处理内存分配和回收。

尽管垃圾回收是 JavaScript 自动执行的，但在某些情况下，它可能并不完美。在 JavaScript ES6 中，Map 和 Set 与它们的“weaker”兄弟元素一起被引入。“weaker”对应着 WeakMap 和 WeakSet，持有的是每个键对象的“弱引用”。它们允许对未引用的值进行垃圾收集，从而防止内存泄漏。了解更多关于 [WeakMaps](https://blog.bitsrc.io/downloading-weakmaps-in-javascript-6e323d9eec81) 的信息。

## 4. 尽早跳出循环 Try to Break Out of Loops Early

执行循环在代码量大的循环中肯定会消耗大量宝贵的时间，这就是为什么要尽早打破循环的原因。你可以使用 `break` 关键字和`continue` 关键字跳出循环。编写最有效的代码是开发者们的责任。

在下面的例子中，如果你不在循环中使用 `break` ，你的代码将运行循环 1000000000 次，显然是超出负荷的。

```js
let arr = new Array(1000000000).fill('----');
arr[970] = 'found';
for (let i = 0; i < arr.length; i++) {
  if (arr[i] === 'found') {
        console.log("Found");
        break;
    }
}
```

在下面的例子中，当不满足条件时如果你不使用 `continue`，那么将执行函数 1000000000 次。而我们只处理了位于偶数位置的数组元素，就将循环执行减少了近一半。

```js
let arr = new Array(1000000000).fill('----');
arr[970] = 'found';
for (let i = 0; i < arr.length; i++) {
  if(i%2!=0){
        continue;
    };
    process(arr[i]);
}
```

你可以在 [这里](https://www.oreilly.com/library/view/high-performance-javascript/9781449382308/ch04.html) 了解更多关于循环和性能。

## 5. 最小化变量的计算次数

要减少计算变量的次数，可以使用闭包。JavaScript 中的闭包允许你从内部函数访问外部函数作用域。每次创建一个函数时都会创建闭包——**但不调用**。内部函数可以访问外部作用域的变量，即使外部函数已经调用结束。

让我们看两个例子，看看这是怎么回事。这些例子的灵感来自 Bret 的博客。

```js
function findCustomerCity(name) {
  const texasCustomers = ['John', 'Ludwig', 'Kate']; 
  const californiaCustomers = ['Wade', 'Lucie','Kylie'];
  
  return texasCustomers.includes(name) ? 'Texas' : 
    californiaCustomers.includes(name) ? 'California' : 'Unknown';
};
```

如果我们多次调用上述函数，每次都会创建一个新对象。对于每个调用，不会将内存重新分配给变量 `texasCustometrs` 和 `californiaCustomers`。

通过使用带有闭包的解决方案，我们只能实例化变量一次。让我们看看下面的例子。

```js
function findCustomerCity() {
  const texasCustomers = ['John', 'Ludwig', 'Kate']; 
  const californiaCustomers = ['Wade', 'Lucie','Kylie'];
  
  return name => texasCustomers.includes(name) ? 'Texas' : 
    californiaCustomers.includes(name) ? 'California' : 'Unknown';
};

let cityOfCustomer = findCustomerCity();

cityOfCustomer('John');//Texas
cityOfCustomer('Wade');//California
cityOfCustomer('Max');//Unknown
```

上述例子中，在闭包的帮助下，返回给变量 `cityOfCustomer` 的内部函数可以访问外部函数 `findCustomerCity()` 的常量。并且当调用内部函数并传参 name 时，不需要再次实例化这些常量。如果想要对闭包有更多了解，我建议你浏览Prashant的这篇[博客](https://medium.com/@prashantramnyc/javascript-closures-simplified-d0d23fa06ba4)。

## 6. 最小化 DOM 的访问

与其他 JavaScript 语句相比，访问 DOM 要慢一些。如果你要操作 DOM，从而触发重绘布局，那么操作会变得相当缓慢。

要减少访问 DOM 元素的次数，请访问它一次，并将其作为局部变量使用。当需求完成时，确保通过将变量设置为 `null` 来删除该变量的值。这将防止内存泄漏，因为它允许垃圾回收。


## 7. 压缩文件

通过使用诸如 Gzip 之类的压缩方法，可以减小 JavaScript 文件的大小。这些较小的文件将提升网站性能，因为浏览器只需要下载较小的资源。

这些压缩可以减少多达 80% 的文件大小。 在这里了解更多关于 [压缩](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/optimize-encoding-and-transfer#text_compression_with_gzip)。

![图片来自 JJ Ying](https://unsplash.com/@jjying?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*yUVIcTARWrjWiaPw)

## 8. 缩小你的最终代码

有些人认为缩小和压缩是一样的。但却相反，它们是不同的。在压缩中，使用特殊的算法来改变输出文件的大小。但在缩小中，需要删除 JavaScript 文件中的注释和额外的空格。这个过程可以在网上找到的许多工具和软件包的帮助下完成。缩小已经成为页面优化的标准实践和前端优化的主要组成部分。

缩小可以减少你的文件大小高达 60%。 在这里了解更多关于 [缩小](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/optimize-encoding-and-transfer#minification_preprocessing_context-specific_optimizations)。

## 9. 使用节流 throttle 和防抖 debounce

通过使用这两种技术，我们可以严格执行代码需要处理事件的次数。

节流是指函数在指定时间内被调用的最大次数。例如，“最多每 1000 毫秒执行一次 `onkeyup` 事件函数”。这意味着如果你每秒输入 20 个键，该事件将每秒只触发一次。这将减少代码的加载。

另一方面，防抖是指函数在上次触发后再次触发要间隔的最短时间。换句话说，“仅当经过 600 毫秒而没有调用该函数时才执行该函数”。这将意味着，你的函数将不会被调用，直到 600 毫秒后，最后一次执行相同的函数。要了解更多关于节流和防抖的知识，这里有一个[快速阅读](https://css-tricks.com/the-difference-between-throttling-and-debouncing/)。

你可以实现自己的防抖和节流函数，也可以从 [Lodash](https://lodash.com/) 和 [Underscore](http://underscorejs.org/) 等库导入它们。

## 10. 避免使用 delete 关键字

`delete` 关键字用于从对象中删除属性。关于这个 `delete` 关键字的性能，已经有一些争议。你可以在 [此处](https://github.com/googleapis/google-api-nodejs-client/issues/375) 和 [此处](https://stackoverflow.com/questions/43594092/slow-delete-of-object- propertieses-in-js-in-v8/44008788) 中查看它们。这个问题有望在未来的更新中得到解决。

As an alternative, you can simply to set the unwanted property as `undefined`.
另一种选择是，你可以直接将将不想要的属性设置为 `undefined`。

```js
const object = {name:"Jane Doe", age:43};
object.age = undefined;
```

你还可以使用 Map 对象，因为根据 [Bret](https://jsperf.com/delete-vs-map-prototype-delete)，Map 的 `delete` 方法被认为更快。

## 11. 使用异步代码防止线程阻塞

你应该知道 JavaScript 是同步的，**也是单线程的**。但是在某些情况下，可能会花费大量的时间来执行一段代码。在本质上同步意味着，这段代码将阻止其他代码语句的运行，直到它完成执行，这会降低代码的整体性能。

但其实，我们可以通过实现异步代码来避免这种情况。异步代码以前是以回调的形式编写的，但是在 ES6 中引入了一种处理异步代码的新风格。这种新风格被称为 promises。你可以在 [MDN 的官方文档](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous/Introducing) 中了解更多关于回调和 promises 的信息。

**等等…**

> JavaScript默认是同步的，**也是单线程的**。

为什么在单一线程上运行，还能运行异步代码？这是很多人感到困惑的地方。这要归功于浏览器外壳下运行的 JavaScript 引擎。JavaScript 引擎是执行 JavaScript 代码的计算机程序或解释器。JavaScript 引擎可以用多种语言编写。例如，支持 Chrome 浏览器的 V8 引擎是用 c++ 编写的，而支持 Firefox 浏览器的 SpiderMonkey 引擎是用 C 和 c++ 编写的。

这些 JavaScript 引擎可以在后台处理任务。根据 [Brian](https://dev.to/steelvoltage/if-javascript-is-single-threaded-how-is-it-asynchronous-56gd)，调用栈识别 Web API 的函数，并将它们交给浏览器处理。一旦浏览器处理完成这些任务，它们将返回并作为回调推到堆栈上。

你有时可能想知道，Node.js 在没有浏览器帮助的情况下是如何运行的。事实上，为 Chrome 提供动力的 V8 引擎同样也为 Node.js 提供动力。下面是一篇由 Salil 撰写的非常棒的博客文章：[Node.js真的是单线程吗](https://medium.com/better-programming/is-node-js-really-single-threaded-7ea59bcc8d64)，它解释了节点生态系统上的这个过程。

## 12. 使用代码分割

如果你有使用 Google Light House 的经验，你就会熟悉一个叫做“first contentful paint”的度量。它是 Lighthouse 报告的性能部分跟踪的六个指标之一。

First Contentful Paint（FCP）测量用户导航到页面后浏览器渲染 DOM 第一个内容所花费的时间。页面上的图像、非白色 `<canvas>` 元素和 SVG 被认为是 DOM 内容；iframe 中的任何内容都**不被包含**在内。

获得更高 FCP 分数的最好方法之一是使用代码分割。代码分割是一种在开始时只向用户发送必要模块的技术。减少最初传输的有效内容的大小，会显著地影响 FCP 得分。

流行的模块打包工具（如 webpack）提供了代码分割功能。你可以在原生 ES 模块的帮助下，加载各个模块。你可以阅读更多关于原生 ES 模块的 [详细信息](https://blog.bitsrc.io/downloading-es-modules-in-javascript-a28fec420f73)。

## 13. 使用异步 async 和延迟 defer

在现代网站中，脚本比 HTML 更密集，它们的尺寸更大，消耗更多的处理时间。默认情况下，浏览器必须等待脚本下载、执行，然后处理页面的其余部分。

庞大的脚本可能会阻塞网页的加载。为了避免这种情况，JavaScript 提供了两种技术，即异步和延迟。你只需将这些属性添加到 `<script>` 标签。

异步是告诉浏览器在不影响页面渲染的情况下加载脚本。换句话说，页面不需要等待异步脚本，内容就会被处理和显示。

延迟是在呈现完成后告诉浏览器加载脚本的地方。如果你同时指定了两者，`async` 在现代浏览器中优先执行，而只支持 `defer` 但不支持 `async` 的旧浏览器将退回到 `defer`。

这两个属性可以极大地帮助你减少页面加载时间。强烈建议你阅读一下 Flavio 的 [JavaScript-async-defer](https://flaviocopes.com/javascript-async-defer/)。

## 14. 使用 Web Workers 在后台运行 CPU 密集型任务

Web Workers 允许在后台线程中运行脚本。如果你有一些高度密集的任务，你可以将任务分配给 web workers, web workers 将运行它们而不干扰用户界面。创建之后，web worker 可以通过向 JavaScript 代码指定的事件处理程序发送消息来与 JavaScript 代码通信。反之亦然。

要了解更多关于 web workers 的信息，建议浏览 [MDN 文档](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)。

---

这篇文章就到这里，欢迎在评论中留言。

快乐编码！！

---

**一些资源**

- [Nodesource 的博客](https://nodesource.com/blog/improve-javascript-performance/)
- [Bret Cameron 的博客](https://medium.com/@bretcameron/13-tips-to-write-faster-better-optimized-javascript-dc1f9ab063d8)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
