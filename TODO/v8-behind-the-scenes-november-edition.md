
  > * 原文地址：[V8: Behind the Scenes](http://benediktmeurer.de/2016/11/25/v8-behind-the-scenes-november-edition/)
  > * 原文作者：[Benedikt Meurer](http://benediktmeurer.de/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/v8-behind-the-scenes-november-edition.md](https://github.com/xitu/gold-miner/blob/master/TODO/v8-behind-the-scenes-november-edition.md)
  > * 译者：[逆寒](https://github.com/thisisandy)
  > * 校对者：[Yuuoniy](https://github.com/Yuuoniy) [ahonn](https://github.com/ahonn)

  # V8: 引擎背后

  这是我就 V8 幕后发生的故事所尝试撰写的一系列博文，目的是使我们为 [Node.js](https://nodejs.org) 和 [Chrome](https://www.google.com/chrome) 所做的工作以及其对开发者的影响更加公开透明。在文中，我将对我主动参与的部分进行详细阐述，内容大致涉及 JavaScript 执行优化、新的语言特性及工具/嵌入器相关事务。

在这一系列的博文中，所有观点均为个人观点，并不代是 Google 或 Chrome/V8 团队的官方口径。这一系列文章针对 V8 引擎的主要受众，他们通过 Node.js，Chrome 或者其他嵌入器使用 V8 引擎，为终端用户提供了一流的产品。在文中，我尽量提及一些背景信息和有趣的细节，避免浅尝辄止、走马观花之嫌。

在首篇，我会简要介绍我们目前在 TurboFan 编译架构 和 Ignition 解释器上的工作内容，ES2015 的进度以及一些性能相关的内容。



## 基于 Ignition 和 Turbofan 的更新

![Brace yourself - TurboFan and Ignition are coming](http://benediktmeurer.de/images/2016/brace-yourself-turbofan-ignition-are-coming.jpeg)



在 V8 工作内容方面，如一些人预料到的那样，我们终于着手为 V8 升级新的架构了。 新的架构基于 [Ignition 解释器](http://v8project.blogspot.de/2016/08/firing-up-ignition-interpreter.html) 和 [TurboFan 编译器](http://v8project.blogspot.de/2015/07/digging-into-turbofan-jit.html)。有可能你在 [arewefastyet](http://arewefastyet.com) 上看到了*Chrome (Ignition)* 和 *Chrome (TurboFan, Ignition)* 的图表，两种可能的配置正在评估中。


1.  *Chrome (Ignition)*，即`--ignition-staging`配置，在现有的编译器架构（例如由 fullcodegen 基线编译器和 TurboFan、Crankshaft 优化编译器组成的架构）前加入了 Ignition 解释器作为第三层，但是从 Ignition 到 TurboFan 有一个直接的 tier up 策略以处理那些 Crankshaft 无法应对的情况（如 `try`-`catch`/-`finally`、`eval`、`for`-`of`、解构、`class` 字面量等）。这是对我们[今年早些时候宣布 Ignition 时](http://v8project.blogspot.de/2016/08/firing-up-ignition-interpreter.html)的原流水线进行的微调。
2.  在 *Chrome (TurboFan, Ignition)*，即 `--ignition-staging --turbo` 配置下，一切只经过 Ignition 和 TurboFan，fullcodegen 和 Crankshaft 丝毫不参与这个过程。

除此之外，[昨天](https://codereview.chromium.org/2505933008)我们终于停止了 fullcodegen， 支持在默认配置中（Crankshaft 打死都不支持的）JavaScript 新特性。也就是说，当在代码中使用了 `try`-`catch` 后，这些函数的运行会经过 Ignition 和 TurboFan 处理，而不是先经过 fullcodegen 处理最后通过 TurboFan 优化 （有时甚至没有 TurboFan 优化这一环节）。从此你无须再为某些框架的限制做多余的工作，代码性能更强，也更加整洁干净。另一个好处是让我们能够大大简化整体架构。当前 V8 的整体编译架构仍然长这个样子：


![Old V8 pipeline](http://benediktmeurer.de/images/2016/v8-old-pipeline-20161125.png)

同时，这种架构也带来了许多问题：尤其是考虑到新的语言特性需要通过管道的各个部分得以实现，不同的编译器（大部分是不兼容的）也要做出一致的优化。此外，类似 DevTools 的工具，其整合的管理成本也在攀升。像调试器或分析器等工具，则需独立于编译器而良好运行。所以在中期，我们会大致依照下图简化整体的编译管道。

![New V8 pipeline](http://benediktmeurer.de/images/2016/v8-new-pipeline-20161125.png)



简化管道有诸多好处，不仅扔掉了些技术的历史包袱，过去无法实现的优化也成了可能，又因为各个编译器不需要完全依照 AST，所以这对减少长期的内存使用和启动消耗大有裨益。因此我们才可能大幅降低 AST 的大小和复杂性。

时至今日，我们对 Ignition 和 TurboFan 的使用又走到了哪一步了呢？我们已经花了大量时间实现默认配置，对于 Ignition 而言是在启动延迟和基线性能方面加紧改进，而对于 TurboFan 而言，大部分时间花在了提高传统（与现代） JavaScript 运行的性能极限上。这实际上比我们三年前刚开始接触 TurboFan 的预期要复杂很多。但想到差不多 10 个优秀工程师花了将近 6 年的时间才优化了旧的 V8 编译器管道，特别是那些 [Octane](https://developers.google.com/octane)， [Kraken](http://krakenbenchmark.mozilla.org) 和 [JetStream](http://browserbench.org/JetStream) 静态测试套件测量的工作，这其实合情合理了。自从 8 月份我们开始全面使用 TurboFan 和 Ignition 管道后，我们在 Ostane 上的分数翻了将近三倍，而且在 Kraken 上获得了大概 14 倍的性能提升 （不过这个数字有一些夸张，只是强调一下我们最初做不到在一个函数执行期间将它从 Ignition 层提升到 TurboFan）。

![Octane score](http://benediktmeurer.de/images/2016/octane-20161125.png)

![Kraken score](http://benediktmeurer.de/images/2016/kraken-20161125.png)

可能这些基准代表的只是性能峰值，更别谈这些基准本身精准与否。但当你需要替换当前的架构时，又需要一个参考以便得知自己进度如何。与默认配置相比，性能其实相差无几了。

![Octane score (including default)](http://benediktmeurer.de/images/2016/octane-cs-20161125.png)

还有诸多基准测试结果表明 TurboFan 与 Ignition 的性能远远超过了默认配置（通常是因为 Crankshaft 无法完成一些极端情况的优化），但也在一些基准测试中，即使 Octane 上 Crankshaft 已经生成相当可观的代码，结果还是被 TurboFan 比下去。例如在 Navier Stoker 的案例中，TurboFan 受益于所谓的 [sane inlining heuristics](https://docs.google.com/document/d/1VoYBhpDhJC4VlqMXCKvae-8IGuheBGxy32EOgC2LnT8)：

![Octane score (Navier Stokes)](http://benediktmeurer.de/images/2016/octane-navier-stokes-20161125.png)

别急， Ignition 和 TurboFan的性能未来更值得期待。 我们一直在加强 TurboFan，直追 Crankshaft，甚至要求它在旧标准上也依旧出色（例如传统的 ES3/ES5 高峰性能标准）。我们亦在谷歌内部就 TurboFan 和相关话题上进行了一些演说：

- [An overview of the TurboFan compiler](https://docs.google.com/document/d/1VoYBhpDhJC4VlqMXCKvae-8IGuheBGxy32EOgC2LnT8)
- [TurboFan IR](https://docs.google.com/presentation/d/1Z9iIHojKDrXvZ27gRX51UxHD-bKf1QcPzSijntpMJBM)
- [CodeStubAssembler: Redux](https://docs.google.com/presentation/d/1u6bsgRBqyVY3RddMfF1ZaJ1hWmqHZiVMuPRw_iKpHlY)

- [TurboFan 编译器一瞥](https://docs.google.com/document/d/1VoYBhpDhJC4VlqMXCKvae-8IGuheBGxy32EOgC2LnT8)
- [TurboFan IR](https://docs.google.com/presentation/d/1Z9iIHojKDrXvZ27gRX51UxHD-bKf1QcPzSijntpMJBM)
- [CodeStubAssembler: Redux](https://docs.google.com/presentation/d/1u6bsgRBqyVY3RddMfF1ZaJ1hWmqHZiVMuPRw_iKpHlY)

现如今，我们也在将这些讯息尽可能的传达给公众（更多资料可以查找 [TurboFan](https://github.com/v8/v8/wiki/TurboFan)  和 V8 的wiki）。我们也打算明年在各种 JavaScript 和 Node.js 会议上发表演讲（如果想让我们在某些会议上聊聊 Ignition 和 TurboFan 尽请戳[我](https://twitter.com/bmeurer) ）。

##ES2015 和未来标准的态势

我参与提升 ES2015 和 ES.Next 的性能又是另一个一言难尽的话题了。今年年初，我们决定了要使 ES2015 和后面的标准可用需要投入多大的资源，可用不单单意味着重大特性的发行，也意味着一些开发工具（比如 [Chrome 开发者工具](https://developer.chrome.com/devtools)的调试器和性能分析器）也得整合在内。此外，编译后的版本（比如 [Babel](http://babeljs.io/) 或者其他编译器生成的文件）相比，性能自然也得不一般。在提升性能方面的工作上，我们制定了[性能计划](https://docs.google.com/document/d/1EA9EbfnydAmmU_lM8R_uEMQ-U_v4l9zulePSBkeYWmY)，并公之于众。这份计划记录了工作涉及的方方面面和详细进度。

为了找到可怕的性能天堑，追踪解决相关问题，目前我们采用了所谓的 [six-speed](https://github.com/kpdecker/six-speed) 性能测试，这份测试致力于比较原生 ES5 和 ES6 对应特性的性能，对应特性是指不一定 100% 语义上的吻合，而是程序员退而选择的原生版本。拿数组解构举例：

```
var data = [1, 2, 3];

function fn() {
  var [c] = data;
  return c;
}
```

在 ES6 大致相当于：

```
var data = [1, 2, 3];

function fn() {
  var c = data[0];
  return c;
}
```

在 ES5 中，这两段代码语义是不相同的：第一段代码采用了 ES6 的[遍历方式](https://tc39.github.io/ecma262/#sec-iteration)，第二段代码则使用了普通的索引访问[数组奇异对象](https://tc39.github.io/ecma262/#sec-array-exotic-objects)。

实际上，我们使用的这套性能测试经过了一些修改和拓展，包含了其他的测试。这套测试在[这里](https://github.com/fhinkel/six-speed)。所有的测试都是微观标准，所以我们并不会着眼于分数（每秒钟的操作）多少，我们在乎的是 ES6 相较 ES5 时，影响性能的因素。我们的目的是将这些因素降低到标准的 1 倍，至少也要在 2 倍之内。这个夏天开始，我们在这方面做了大量的优化。

![Improvements M54 to M56](http://benediktmeurer.de/images/2016/six-speed-20161125.png)

这张图表展示了从 V8 5.4 版本到 到 5.6 版本（Chorme M56 将采用）的提升。在分析过程中，我还通过 `--turbo-escape` 额外给 V8 加了一些限制，因为 Turbofan 逃逸分析当时并不成熟（自[crrev.com/2512733003 ](https://codereview.chromium.org/2512733003)已在 TOT 上线）,也就是说，这还不是 5.6 的实力。图表显示了 ES5 到 ES6 各部分的优化百分比。还有一些标准未提及但成绩也在 2x 以内。目前我们的工作仍在继续，我们希望能为下次 Node.js LTS 版本发布时提供 ES2015（性能和功能方面）卓越的体验。

### 细看 `instanceof`

除了 [six-speed](https://github.com/fhinkel/six-speed) 表所展现的，我们也积极提升了其他新语言特性的交互，这些提升乍一看或许并不起眼。我在这里想提及的是 ES2015 里的 `instanceof` 操作符和新引入的symbol [@@hasInstance](https://tc39.github.io/ecma262/#sec-symbol.hasinstance) 。一开始在 V8 上实现 ES2015 时，我们无法充分优化每一个特性，我们也不想因为 ES2015 新的语言特性就减少工作量、降低标准（当时我们还没有 100% 地实现 ES2015，但去年年底，在保证没有任何性能明显衰退的前提下，我们基本上实现了 ES2015）。然而，新加入的 symbol 类型也导致了一些麻烦。

![InstanceofOperator EcmaScript specification](http://benediktmeurer.de/images/2016/instanceof-20161125.png)

拿 `instanceof` 来说，你总得检查右值是否有 `@@hasInstance` 的方法，并取代 ES5 中 [OrdinaryHasInstance](https://tc39.github.io/ecma262/#sec-ordinaryhasinstance) 的旧算法--即使 99% 的情况下调用的是 [Function.prototype[@@hasInstance]](https://tc39.github.io/ecma262/#sec-function.prototype-@@hasinstance)，也是通过 OrdinaryHasInstance 实现的。例如有如下函数 `isA`

```
function A() { ... }

...

function isA(o) { return o instanceof A; }
```

如果采用 ES2015 的方式，函数性能将大打折扣，因为运行 `instanceof` 不光要追踪原型链产生额外开销，还需要检查  `A `  的原型链上是否有  `@@hasInstance`  属性以便调用。为了降低影响，我们一开始决定采用 *protector cell* 的机制。这套机制让一部分 V8 假定一部分事件尚未发生， 从而跳过某些检测。在这个例子中， protector cell 确保 V8 没有添加其他 Symbol.hasInstance 的属性。如果 `@@hasInstance` 没有在其他地方添加，并且保护器完好，就可以继续调用 OrdinaryHasInstance  来实现 `instanceof`。

如果短期内没人使用这种补丁版的 `instanceof` , 那就相当于为实现伸缩性良好的、自定义的`Symbol.hasInstance` 匀出了时间。然而这不可能，在 Node.js v7中，实现 `Writable` 类时已经采用了 [`Symbol.hasInstance`](https://github.com/nodejs/node/commit/2a4b068acaa160a2d76ec5a3728e29ac6cdc715b)，结果在 Node.js 里使用 `instanceof` 时，甚至要比原来慢100倍。我们只能寻求其他解决方式。功夫不负有心人，有一种简单的方式能够优化 Crankshaft 和 TurboFan，并且不依赖于全局的 protector cell，我们因此顺利解决了这个问题，issue 记录在 [crrev.com/2504263004](https://codereview.chromium.org/2504263004) 和 [crrev.com/2511223003](https://codereview.chromium.org/2511223003) 中。

对于 TurboFan，除了解决性能倒退的问题外，我还一并适度优化了自定义的`Symbol.hasInstance` 句柄，有可能导致（误）用 `instanceof ` 做一些奇妙的事，譬如下面这段代码：

```
var Even = {[Symbol.hasInstance](x) { return x % 2 == 0; } }

function isEven(x) {
  return x instanceof Even;
}

isEven(1); // false
isEven(2); // true
```

假设我们通过 `--turbo`  和 `--ignition-staging` 用新的编译器流水线（Ignition and TurboFan）运行这段代码，TurboFan 在 x64 位上得出以下（近乎完美的）结果：

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

我们不仅能够内联自定义的 `Even[Symbol.hasInstance]()` 方法，Ignition 为模块化的操作符收集的整数反馈后，被 TurboFan 在消化后将 `x % 2` 转换为按位与操作。这个过程还有一些细节可以改善，但如上文提及，我们仍在努力提升 TurboFan。

![Prepare for instanceof boost](http://benediktmeurer.de/images/2016/instanceof-20161125.jpg)

### 幕后的工程师们

最重要的是，有了[前人](https://en.wikipedia.org/wiki/Lars_Bak_(computer_programmer))的[努力](https://twitter.com/mraleph)和以下工程师的辛勤付出才有了所有可能。下面是参与到 ES2015、Node.js 和 Chrome 幕后工作的人员名单：

- [Adam Klein](mailto:adamk@chromium.org)
- [Caitlin Potter](https://twitter.com/caitp)
- [Daniel Ehrenberg](https://twitter.com/littledan)
- [Franziska Hinkelmann](https://twitter/fhinkel)
- [Georg Neis](mailto:neis@chromium.org)
- [Jakob Gruber](https://twitter.com/schuay)
- [Michael Starzinger](mailto:mstarzinger@chromium.org)
- [Peter Marshall](mailto:petermarshall@chromium.org)
- [Sathya Gunasekaran](https://twitter.com/_gsathya)

当然也有其他人在 ES6 和 V8 实现上贡献颇多，他们是:

- [Andreas Rossberg](mailto:rossberg@chromium.org)
- [Dmitry Lomov](https://twitter.com/mulambda)
- [Erik Arvidsson](https://twitter.com/ErikArvidsson)

要是你碰巧遇到他们了，而且中意他们对 V8 做的贡献，那就顺便请他们小酌一两杯吧。

---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
