
  > * 原文地址：[V8: Behind the Scenes](http://benediktmeurer.de/2016/11/25/v8-behind-the-scenes-november-edition/)
  > * 原文作者：[Benedikt Meurer](http://benediktmeurer.de/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/v8-behind-the-scenes-november-edition.md](https://github.com/xitu/gold-miner/blob/master/TODO/v8-behind-the-scenes-november-edition.md)
  > * 译者：
  > * 校对者：

  # V8: Behind the Scenes

  So this is my attempt to start a series of blog posts about what’s going on behind the scenes of V8 in order to bring more transparency to what we do for [Node.js](https://nodejs.org) and [Chrome](https://www.google.com/chrome), and how this affects developers targeting either Node.js or Chrome. I’ll mostly talk about stuff where I’m actively involved, so mostly things that are related to JavaScript Execution Optimization, new language features and a few tooling/embedder related issues.

Any opinions expressed in these posts are my own and don’t necessarily reflect the official position of Google or the Chrome/V8 teams. Also these articles are clearly targeting the primary audience of V8 itself, which are developers utilizing V8 through Node.js, Chrome or some other embedder to build and deliver awesome products to the end user. I’ll try to not only scratch the surface, but also provide some background information and interesting details whenever feasible.

In this first article I’m going to give a brief update on our ongoing work on the TurboFan compiler architecture and the Ignition interpreter, and the current progress on the ES2015 and beyond performance front.

## An update on Ignition and TurboFan

![Brace yourself - TurboFan and Ignition are coming](http://benediktmeurer.de/images/2016/brace-yourself-turbofan-ignition-are-coming.jpeg)

As those of you following the work on V8 somewhat closely have probably already figured out, we’re finally starting to ship the new architecture for V8, which is based on the [Ignition interpreter](http://v8project.blogspot.de/2016/08/firing-up-ignition-interpreter.html) and the [TurboFan compiler](http://v8project.blogspot.de/2015/07/digging-into-turbofan-jit.html). You have probably also already spotted the *Chrome (Ignition)* and *Chrome (TurboFan, Ignition)* graphs on [arewefastyet](http://arewefastyet.com). These reflect two possible configurations, which are currently being evaluated:

1. The *Chrome (Ignition)* aka `--ignition-staging` configuration, which adds the Ignition interpreter as a third tier in front of the existing compiler architecture (i.e. in front of the fullcodegen baseline compiler, and the optimizating compilers TurboFan and Crankshaft), but with a direct tier up strategy from Ignition to TurboFan for features that Crankshaft cannot deal with (i.e. `try`-`catch`/-`finally`, `eval`, `for`-`of`, destructuring, `class` literals, etc.). This is a slight modification of the pipeline we had initially when [Ignition was announced earlier this year](http://v8project.blogspot.de/2016/08/firing-up-ignition-interpreter.html).
2. The *Chrome (TurboFan, Ignition)* aka `--ignition-staging --turbo` configuration, where everything goes through Ignition and TurboFan only, and where both fullcodegen and Crankshaft are completely unused.

In addition to that, [as of yesterday](https://codereview.chromium.org/2505933008) we are finally starting to pull the plug on fullcodegen for (modern) JavaScript features - that Crankshaft was never able to deal with - in the default configuration, which means that for example using `try`-`catch` in your code will now always route these functions through Ignition and TurboFan, instead of fullcodegen and eventually TurboFan (or even leaving the function unoptimized in fullcodegen). This will not only boost the performance of your code, and allow you to write cleaner code because you no longer need to work-around certain architectural limitations in V8, but also allows us to simplify our overall architecture quite significantly. Currently the overall compilation architecture for V8 still looks like this:

除此之外，昨天我们终于



![Old V8 pipeline](http://benediktmeurer.de/images/2016/v8-old-pipeline-20161125.png)

This comes with a lot of problems, especially considering new language features that need to be implemented in various parts of the pipeline, and optimizations that need to be applied consistently across a couple of different (mostly incompatible) compilers. This also comes with a lot of overhead for tooling integration, i.e. DevTools, as tools like the debugger and the profiler need to function somewhat well and behave the same independent of the compiler being used. So middle-term we’d like to simplify the overall compilation pipeline to something like this:

同时，许多问题相继出现：尤其是考虑到新的语言特性需要通过管道的各个部分得以实现，不同的编译器（大部分是不兼容的）也要做出一致的优化。此外，类似 DevTools 的工具，其整合的管理成本也在攀升。像调试器或分析器等工具需独立于编译器而良好运行。所以在中期，我们会大致依照下图简化整体的编译管道。

![New V8 pipeline](http://benediktmeurer.de/images/2016/v8-new-pipeline-20161125.png)

This simplified pipeline offers a lot of opportunities, not only reducing the technical debt that we accumulated over the years, but it will enable a lot of optimizations that weren’t possible in the past, and it will help to reduce the memory and startup overhead significantly long-term, since for example the AST is no longer the primary source of truth on which all compilers need to agree on, thus we will be able to reduce the size and complexity of the AST significantly.

简化管道后有诸多好处，不仅减少了技术了历史包袱，过去无法实现的优化也成了可能，又因为各个编译器不需要完全依照 AST，所以 对减少长期的内存使用和启动消耗大有裨益。所以我们才可能大幅降低 AST 的大小和复杂性。

So where do we stand with Ignition and TurboFan as of today? We’ve spend a lot of time this year catching up with the default configuration. For Ignition that mostly meant catching up with startup latency and baseline performance, while for TurboFan a lot of that time was spend catching up on peak performance for traditional (and modern) JavaScript workloads. This turned out to be a lot more involved than we expected three years ago when we started TurboFan, but it’s not really surprising given that an average of 10 awesome engineers spent roughly 6 years optimizing the old V8 compiler pipeline for various workloads, especially those measured by static test suites like [Octane](https://developers.google.com/octane), [Kraken](http://krakenbenchmark.mozilla.org) and [JetStream](http://browserbench.org/JetStream). Since we started with the full TurboFan and Ignition pipeline in August, we almost tripled our score on Octane and got a roughly 14x performance boost on Kraken (although this number is a bit misleading as it just highlights the fact that initially we couldn’t tier up a function from Ignition to TurboFan while the function was already executing):

时至如今，我们又如何安放Ignition 和 TurboFan 呢？我们已经花了大量时间实现默认配置，对于 Ignition 而言是

![Octane score](http://benediktmeurer.de/images/2016/octane-20161125.png)

![Kraken score](http://benediktmeurer.de/images/2016/kraken-20161125.png)

Now arguably these benchmarks are just a proxy for peak performance (and might not even be the best proxy), but you need to start somewhere and you need to measure and prove your progress if you want to replace the existing architecture. Comparing this to the default configuration, we can see that we almost closed the performance gap:

这些代表高峰性能的基准又饱受争议，更别谈这些基准精准与否。但当你需要替换当前的架构时，又需要一个参考以便得知自己进度如何。我们与默认配置相比，便发现性能其实相差无几了。

![Octane score (including default)](http://benediktmeurer.de/images/2016/octane-cs-20161125.png)

There are also a couple of benchmarks where TurboFan and Ignition beat the default configuration significantly (often because Crankshaft would bailout from optimization due to some corner case that it cannot handle), but there are also benchmarks even on Octane where Crankshaft already generates pretty decent code, but TurboFan can generate even better code. For example in case of Navier Stokes, TurboFan benefits from somewhat [sane inlining heuristics](https://docs.google.com/document/d/1VoYBhpDhJC4VlqMXCKvae-8IGuheBGxy32EOgC2LnT8):

还有诸多评判标准，指出默认性能和 TurboFan 及Ignition相比早是望其项背了。

![Octane score (Navier Stokes)](http://benediktmeurer.de/images/2016/octane-navier-stokes-20161125.png)

So stay tuned, and expect to see a lot more Ignition and TurboFan in the wild. We’re constantly working to improve TurboFan to catch up with Crankshaft even in the *old world* (i.e. on the traditional ES3/ES5 peak performance benchmarks). We already gave a few talks internally at Google on TurboFan and TurboFan-related topics, i.e.

别急， Ignition 和 TurboFan的性能未来更值得期待。 我们一直在加强 TurboFan，直追 Crankshaft，甚至要求在旧标准上也依旧出色（例如传统的 ES3/ES5 高峰性能标准）。我们亦在谷歌内部就 TurboFan 和相关话题上进行了一些演说：

- [An overview of the TurboFan compiler](https://docs.google.com/document/d/1VoYBhpDhJC4VlqMXCKvae-8IGuheBGxy32EOgC2LnT8)
- [TurboFan IR](https://docs.google.com/presentation/d/1Z9iIHojKDrXvZ27gRX51UxHD-bKf1QcPzSijntpMJBM)
- [CodeStubAssembler: Redux](https://docs.google.com/presentation/d/1u6bsgRBqyVY3RddMfF1ZaJ1hWmqHZiVMuPRw_iKpHlY)

- [TurboFan 编译器一瞥](https://docs.google.com/document/d/1VoYBhpDhJC4VlqMXCKvae-8IGuheBGxy32EOgC2LnT8)
- [TurboFan IR](https://docs.google.com/presentation/d/1Z9iIHojKDrXvZ27gRX51UxHD-bKf1QcPzSijntpMJBM)
- [CodeStubAssembler: Redux](https://docs.google.com/presentation/d/1u6bsgRBqyVY3RddMfF1ZaJ1hWmqHZiVMuPRw_iKpHlY)

and we will now try to make as much of this information available to the public as possible (check the [TurboFan](https://github.com/v8/v8/wiki/TurboFan) page on the V8 wiki for additional resources). We also plan to give talks at various JavaScript and Node.js conferences next year (ping [me](https://twitter.com/bmeurer) if you would like us to talk about Ignition and TurboFan at some particular conference).

现如今，我们也在将这些讯息尽可能的传达给公众（更多资料可以查找 [TurboFan](https://github.com/v8/v8/wiki/TurboFan)  和 V8 的wiki）。我们也打算明年在各种 JavaScript 和 Node.js 会议上发表演讲（如果想让我们在某些会议上聊聊Ignition 和 TurboFan 尽请戳[我](https://twitter.com/bmeurer) ）。

## State of the union wrt. ES2015 and beyond

The performance (and to some extend feature) work on ES2015 and ES.Next features is the other big topic that I’m involved in. Earlier this year we decided that we will have to invest resources in making ES2015 and beyond viable for usage in practice, which means that we must not only ship the fundamental feature, but we also need to integrate it with tooling (i.e. the debugger and profiler mechanisms in [Chrome Developer Tools](https://developer.chrome.com/devtools)) and we need to provide somewhat decent performance, at least compared to the transpiled version (i.e. as generated by [Babel](http://babeljs.io/) or other transpilers) and a naive ES5 version (which doesn’t need to match the sematics exactly). For the performance work, we set up a publicly available [performance plan](https://docs.google.com/document/d/1EA9EbfnydAmmU_lM8R_uEMQ-U_v4l9zulePSBkeYWmY) where we record the areas of work and track the current progress.

For finding horrible performance cliffs and tracking progress on the relevant issues, we’re currently mostly using the so-called [six-speed](https://github.com/kpdecker/six-speed) performance test, which tests the performance of ES6 (and beyond) features compared to their naive ES5 counterparts, i.e. not a 100% semantically equivalent version, but the naive version that a programmer would likely pick instead. For example an array destructuring like this

```
var data = [1, 2, 3];

function fn() {
  var [c] = data;
  return c;
}
```

in ES6 roughly corresponds to this code

```
var data = [1, 2, 3];

function fn() {
  var c = data[0];
  return c;
}
```

in ES5, even though these are not semantically equivalent since the first example is using [ES6 iteration](https://tc39.github.io/ecma262/#sec-iteration) while the second example is just using a plain indexed access to an [Array Exotic Object](https://tc39.github.io/ecma262/#sec-array-exotic-objects).

在 ES5 中，这两段代码语义是不相同的：第一段代码采用了 ES6 的[遍历方式](https://tc39.github.io/ecma262/#sec-iteration)，第二段代码则使用了普通的索引访问[数组奇异对象](https://tc39.github.io/ecma262/#sec-array-exotic-objects)。

We are actually using a slightly modified and extended version of the performance test, which can be found [here](https://github.com/fhinkel/six-speed), that contains additional tests. All of these tests are obviously micro benchmarks, that’s why we don’t really pay attention to the absolute score (operations per second), but we only care about the slowdown factor between the ES5 and the ES6 versions. Our goal is to eventually get the slowdown close to **1x** for all the (relevant) benchmarks, but at the very least get it below **2x** for all of the line items. We made tremendous improvements on the most important line items since we started working on this in summer:

![Improvements M54 to M56](http://benediktmeurer.de/images/2016/six-speed-20161125.png)

This shows the improvements from V8 5.4 (which ships in current stable Chrome) to V8 5.6 (which will be in Chrome M56), with the additional constraint that I passed the `--turbo-escape` flag to V8, which unfortunately didn’t make it into 5.6 because the TurboFan Escape Analysis was not considered ready for prime time (it’s now on in ToT since [crrev.com/2512733003](https://codereview.chromium.org/2512733003)). The chart shows the percentage of improvements on the *ES5 to ES6* factor. There are still a couple of benchmarks left where we are not yet below **2x**, and we are actively working on those, and we hope that we will be able to offer a solid ES2015 experience (performance- and tooling-wise) for the next Node.js LTS release.

### A closer look at `instanceof`

细看 `instanceof`

Besides the line items on the [six-speed](https://github.com/fhinkel/six-speed) table, we’re also actively working to improve the interaction of other new language features, that might not be so obvious on first sight. One particular, recent example that I’d like to mention here, is the [`instanceof` operator](https://tc39.github.io/ecma262/#sec-instanceofoperator) in ES2015 and the newly introduced well-known symbol [@@hasInstance](https://tc39.github.io/ecma262/#sec-symbol.hasinstance). When we worked on implementing ES2015 in V8, we didn’t have the resources to fully optimize every feature from the beginning, and we had to make sure that we don’t regress existing workloads and benchmarks just because of new ES2015 language features (which was still not possible 100% of the time, but nevertheless we managed to ship almost all of ES2015 by the end of last year without any major performance regressions). But especially the newly added well-known symbols caused some trouble there, as they are not local in the sense of *pay for what you use*, but are sort of global.

除了 [六速表](https://github.com/fhinkel/six-speed)所展现的，我们也主动提升了其他新语言特性的交互，这些提升或许乍一看并不起眼。我在这里想提及的是 ES2015 里的 `instanceof` 操作符和新引入的symbol [@@hasInstance](https://tc39.github.io/ecma262/#sec-symbol.hasinstance) 。一开始在V8上实现 ES2015 时，我们无法充足优化每一个特性，我们也不想因为 ES2015 新的语言特性就减少工作量、降低标准（当时我们还没有100%地实现ES2015，但在去年年底，在保证没有任何明显的性能衰退的前提下，我们基本部署了ES2015）。然而，新加入的 symbol 类型也导致了一些麻烦。

![InstanceofOperator EcmaScript specification](http://benediktmeurer.de/images/2016/instanceof-20161125.png)

For example, for `instanceof`, you now need to always check whether the right-hand side has a method `@@hasInstance`, and use that instead of the old ES5 algorithm - now known as [OrdinaryHasInstance](https://tc39.github.io/ecma262/#sec-ordinaryhasinstance) - when present, even though in 99.99% of the cases this will be [Function.prototype[@@hasInstance]](https://tc39.github.io/ecma262/#sec-function.prototype-@@hasinstance), which itself just calls to OrdinaryHasInstance. So for example a function `isA` like this

拿 `instanceof` 来说，你总得检查右值是否有 `@@hasInstance` 的方法，并取代 ES5 中 [OrdinaryHasInstance](https://tc39.github.io/ecma262/#sec-ordinaryhasinstance) 的老算法--即使99%的情况下调用的是 [Function.prototype[@@hasInstance]](https://tc39.github.io/ecma262/#sec-function.prototype-@@hasinstance) ，也就是通过 OrdinaryHasInstance 实现的。例如有如下函数 `isA`

```
function A() { ... }

...

function isA(o) { return o instanceof A; }
```

would be slowed down a lot if you implement ES2015 naively, because in addition to the actual prototype chain walk that you need to perform for `instanceof`, you know also need to lookup the `@@hasInstance` property on `A`’s prototype first and call that method. To mitigate that problem we decided to go with a mechanism called a *protector cell* in the beginning, which allows certain parts of V8 to assume that a certain event didn’t happen so far, so we don’t need to perform certain checks. In this case the protector cell would guard against the addition of a property named `Symbol.hasInstance` anywhere in V8. Assuming that no one installed any other `@@hasInstance` function anywhere, we could just continue to always implement `instanceof` via OrdinaryHasInstance as long as the protector is intact.

如果采用ES2015的方式，函数性能将大打折扣，因为运行 instanceof  不光要追踪原型链产生额外开销，还需要检查  `A `  的原型链上是否有  `@@hasInstance`  属性以便调用。为了降低影响，我们一开始决定采用 *protector cell* 的机制。这套机制让一部分 V8 假定一部分事件尚未发生， 从而跳过某些检测。在这个例子中， protector cell 确保 V8 没有添加其他 Symbol.hasInstance 的属性。如果 `@@hasInstance` 没有在其他地方添加，只要保护器完好，就可以继续调用 OrdinaryHasInstance  来实现 `instanceof`。

The assumption was that no one would use this monkey-patching ability for `instanceof` anytime soon, which buys us some time to come up with a better solution that scales well even in the presence of custom `Symbol.hasInstance` methods. But apparently this assumption was invalid, since Node.js v7 [started using `Symbol.hasInstance`](https://github.com/nodejs/node/commit/2a4b068acaa160a2d76ec5a3728e29ac6cdc715b) for their `Writable` class. This slowed down any use of `instanceof` in any Node.js by up to a [factor of 100](https://github.com/nodejs/node/issues/9634) depending on the exact usage pattern. So we had to look for mitigations of the problem, and as it turned out, there is at least an easy way to avoid depending on the global protector cell for the optimizing compilers Crankshaft and TurboFan, and so we got that fixed with [crrev.com/2504263004](https://codereview.chromium.org/2504263004) and [crrev.com/2511223003](https://codereview.chromium.org/2511223003).



For TurboFan, I did not only fix the regression, but also made it possible to optimize appropriately in the presence of custom `Symbol.hasInstance` handlers, which makes it possible to (mis)use `instanceof` for rather crazy things like this

```
var Even = {[Symbol.hasInstance](x) { return x % 2 == 0; } }

function isEven(x) {
  return x instanceof Even;
}

isEven(1); // false
isEven(2); // true
```

and still generate awesome code for it. Assuming we run this example function with the new pipeline (Ignition and TurboFan) using `--turbo` and `--ignition-staging`, TurboFan is able to produce the following (close to perfect) code on x64:

```
...SNIP...
0x30e579704073    19  488b4510       REX.W movq rax,[rbp+0x10]
0x30e579704077    23  48c1e820       REX.W shrq rax, 32
0x30e57970407b    27  83f800         cmpl rax,0x0
0x30e57970407e    30  0f9cc3         setll bl
0x30e579704081    33  0fb6db         movzxbl rbx,rbx
0x30e579704084    36  488b5510       REX.W movq rdx,[rbp+0x10]
0x30e579704088    40  f6c201         testb rdx,0x1
0x30e57970408b    43  0f8563000000   jnz 148  (0x30e5797040f4)
0x30e579704091    49  83fb00         cmpl rbx,0x0
0x30e579704094    52  0f8537000000   jnz 113  (0x30e5797040d1)
                  -- B4 start --
0x30e57970409a    58  83e001         andl rax,0x1
                  -- B9 start --
0x30e57970409d    61  83f800         cmpl rax,0x0
0x30e5797040a0    64  0f8409000000   jz 79  (0x30e5797040af)
                  -- B10 start --
0x30e5797040a6    70  498b45c0       REX.W movq rax,[r13-0x40]
0x30e5797040aa    74  e904000000     jmp 83  (0x30e5797040b3)
                  -- B11 start --
0x30e5797040af    79  498b45b8       REX.W movq rax,[r13-0x48]
                  -- B12 start (deconstruct frame) --
0x30e5797040b3    83  488be5         REX.W movq rsp,rbp
0x30e5797040b6    86  5d             pop rbp
0x30e5797040b7    87  c21000         ret 0x10
...SNIP...
```

We are not only able to inline the custom `Even[Symbol.hasInstance]()` method, but TurboFan also consumes the integer feedback that Ignition collected for the modulus operator and turns the `x % 2` into a bitwise-and operation. There are still a couple of details that could be better about this code, but as mentioned above we’re still working to improve TurboFan.

![Prepare for instanceof boost](http://benediktmeurer.de/images/2016/instanceof-20161125.jpg)

### The engineers behind all of this

Last but not least, I’d like to highlight that all of this is only possible because we have so many great engineers working on this, and we are
obviously standing on the [shoulders](https://twitter.com/mraleph) of [giants](https://en.wikipedia.org/wiki/Lars_Bak_(computer_programmer)).
Here are the people currently working on features related to ES2015 and beyond for Node.js and Chrome:

- [Adam Klein](mailto:adamk@chromium.org)
- [Caitlin Potter](https://twitter.com/caitp)
- [Daniel Ehrenberg](https://twitter.com/littledan)
- [Franziska Hinkelmann](https://twitter/fhinkel)
- [Georg Neis](mailto:neis@chromium.org)
- [Jakob Gruber](https://twitter.com/schuay)
- [Michael Starzinger](mailto:mstarzinger@chromium.org)
- [Peter Marshall](mailto:petermarshall@chromium.org)
- [Sathya Gunasekaran](https://twitter.com/_gsathya)

And obviously there are the people who contributed a lot to ES6 itself and the initial V8 implementation:

- [Andreas Rossberg](mailto:rossberg@chromium.org)
- [Dmitry Lomov](https://twitter.com/mulambda)
- [Erik Arvidsson](https://twitter.com/ErikArvidsson)

So if you ever happen to meet one of them, and you like what they’re doing, consider inviting them for a beer or two.

---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
