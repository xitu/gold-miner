> * 原文地址：[Making JavaScript run fast on WebAssembly](https://bytecodealliance.org/articles/making-javascript-run-fast-on-webassembly)
> * 原文作者：[Lin Clark](https://github.com/linclark)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/making-javascript-run-fast-on-webassembly.md](https://github.com/xitu/gold-miner/blob/master/article/2021/making-javascript-run-fast-on-webassembly.md)
> * 译者：[Badd](https://juejin.cn/user/1134351730353207)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)，[Usualminds](https://github.com/Usualminds)

# 让 JavaScript 在 WebAssembly 上疾速运行

与二十年前相比，如今 JavaScript 在浏览器中的运行速度要快好多倍。而这多亏了浏览器厂商们在此期间坚持不懈地加强性能优化。

而现在，我们又要开始在完全不同的运行环境中优化 JavaScript 的性能 —— 这些新环境中的游戏规则是截然不同的。而让 JavaScript 能够适应不同运行环境的，正是 WebAssembly。

这里我们要明确一点 —— 如果你是在浏览器中运行 JavaScript，那么直接部署 JavaScript 就行了。浏览器中的 JavaScript 引擎已经被精心调校过，可以很快速地运行装载进来的 JavaScript 程序。

但如果是在无服务器（Serverless）功能中运行 JavaScript 呢？又或者说，如果想要在 iOS 或游戏机这类不支持通常的即时编译的环境中运行 JavaScript，又该如何把控性能？

在这些使用场景中，你会需要关注这新一轮的 JavaScript 优化。另外，若想要让 Python、Ruby 或者 Lua 等其他运行时语言在上述使用场景中提速，JavaScript 优化也有参考价值。

但在开始探索如何在不同环境中进行优化前，我们需要了解一下其中的基本原理。

## 原理是什么？

不论你在何时运行 Javascript 程序，JavaScript 代码终归要以机器编码的形式执行。 JavaScript 引擎通过一系列技术来实现这一转换，例如各种解释器和 JIT 编译器。（详情请参见[即时（JIT）编译器速成课](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)。）

![拟人化的 JavaScript 引擎对着 JavaScript 代码大声报出对应的机器编码。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/02-02-interp02.png)

但如果你想要运行程序的平台没有 JavaScript 引擎怎么办？那你就需要把 JavaScript 引擎和程序代码一起部署。

为了能让 JavaScript 随处运行，我们把 JavaScript 引擎部署为一个 WebAssembly 模块，这样就能够跨越不同机器架构之间的差异。而且，借助 WASI，跨操作系统也同样成为可能。

这意味着，整个 JavaScript 运行环境被集成进了 WebAssembly 实例中。部署了 WebAssembly 后， 你只需把 JavaScript 代码喂进去就行了，WebAssembly 实例会自行消化代码。

![外层盒子代表 Wasm 引擎，内层盒子代表 JavaScript 引擎，JavaScript 文件被由外向内传递。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/01-02-how-it-works.png)

JavaScript 引擎并不会直接在机器内存中运转，从二进制码到二进制码的垃圾回收对象，JavaScript 引擎把这一切都放到 Wasm 模块的线性内存中。

![拟人化的 JavaScript 引擎把转译过的机器编码放入本模块内的线性内存中。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/01-03-how-it-works.png)

对于 JavaScript 引擎，我们选用了 SpiderMonkey，就是 Firefox 浏览器中用到的那个。SpiderMonkey 是行业级别的 JavaScript 虚拟机（VM）之一，在浏览器领域里是久经沙场的老将。当你运行不可信代码，或者代码会处理不可信输入信息时，这种皮实耐用、安全性高的特性就显得尤为重要了。

SpiderMonkey 还使用了一种叫做精确堆栈扫描的技术，它对我下面将要说到的部分优化点极其重要。SpiderMonkey 还具有包容度极高的代码库，这一点也很重要，因为协作开发者们来自三个不同的组织 —— Fastly、Mozilla 和 Igalia。

我刚刚描述的运行方式并没有显得具有什么颠覆性特征。几年前大家就已经开始这样用 WebAssembly 运行 JavaScript 了。

但问题在于，这样运行很慢。WebAssembly 并不支持动态地生成新的机器编码，然后在纯 Wasm 代码里运行。这就意味着你无法使用即时编译。你只能使用解释器。

知道了有这种局限性，你可能会问：

## 那为何还要说性能优化？

鉴于即时编译让浏览器能快速运行 JavaScript（且鉴于在 WebAssembly 模块中不能进行即时编译），还想提速似乎是反直觉的。

![大吃一惊的开发者：“这是为什么啊？”](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/02-01-but-why.png)

但假如，即使不能用即时编译，我们还是有办法能让 JavaScript 运行提速呢？

让我们通过几个案例来看看，如果 WebAssembly 可以快速运行 JavaScript，将会产生多么大的效益。

### 在 iOS（以及其他 JIT 受限的环境）中运行 JavaScript

在有些环境下，由于安全原因，你无法使用即时编译，举例来说，无特殊权限的 iOS 应用、部分智能电视以及游戏机设备都属于此范畴。

![iPhone、智能电视和游戏手柄](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/02-02-non-jit-devices.png)

在这些平台上，你必须要使用解释器才行。但你想在这些平台上运行的，都是那种运行周期长、代码量大的应用……正是这些条件让你**不想**用解释器，因为解释器会严重拖慢执行速度。

如果我们能让 JavaScript 在这样的环境中提速，那么开发者们就可以在不支持即时编译的平台使用 JavaScript 而无需顾虑性能了。

### 让无服务器即刻冷启动

在另外一些场景中，即时编译不成问题，但启动时间却拖了后腿，比如在使用无服务器功能时。这就是冷启动延迟的问题，你可能已经有所耳闻。

![图片：一朵被许多边缘网络节点围绕的云](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/02-03-cloud.png)

即使你用精简到极致的 JavaScript 环境 —— 一个仅启动纯 JavaScript 引擎的隔离环境，最低延迟也有 5 毫秒左右。这甚至还没有把初始化应用的时间算进去。

倒是有一些办法可以把收到的请求的启动延迟隐藏起来。但随着 QUIC 这类提案在网络层中对连接时长的优化，想要隐藏延迟越来越困难。而当你链式执行多个无服务器功能等这类操作时，要隐藏延迟更是难上加难。

使用这些技术去隐藏延迟的平台页，常常会在多个请求间复用实例。某些情况下，这意味着在不同请求中都可以观察到全局状态，这就是拿安全当儿戏了。

正是由于这个冷启动问题，开发者们常常无法遵循最佳实践来开发。他们会在一次无服务器部署中，塞入大量功能。这就导致了另一个安全问题 —— 一处暴雷，全盘完蛋。如果这次部署中的一部分破防了，那么攻击者就有了整个部署的访问权限。

![左侧漫画标题为“多个请求之间的风险”。画面内容是四处散落纸张的屋子里有一群盗贼，他们说：“哦耶发达了！看看他们留下了这么多好东西！” 右侧漫画标题为“多个模块之间的风险”。内容是一个模块树的底部有一个模块发生了爆炸，树上的其他模块都被弹片殃及了。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/02-04-serverless-at-risk.png)

但如果我们能把上述场景中 JavaScript 的启动时间降到足够低，那我们自然就无需再费尽心思去隐藏启动时间了。我们能在几微秒之间就启动一个实例。

如果能做到这种程度，我们就能为每个请求提供一个新实例，于是不会再有全局状态横穿多个请求了。

而且，由于这些实例足够轻量，开发者能够任意把代码拆分成粒度更细的片段，把每一段代码的故障范围压缩到最小。

![左侧漫画标题为“不同请求之间隔离”，内容为同一群盗贼在一间整洁的屋子里，他们说：“空荡荡啊，他们什么也没留下。” 右侧漫画标题为“不同模块之间隔离”，内容为一个模块图，其中每个模块都有自己的包裹容器，当某个模块爆炸，爆炸范围被控制在了自己的容器之内。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/02-05-serverless-protected.png)

这种实现还有另外一个安全方面的优点。除了实例能保持轻量、代码隔离粒度更优之外，Wasm 引擎能提供的安全壁垒也更坚固了。

JavaScript 引擎过去用来创建隔离的代码库庞大无比，包含着大量用来进行极其复杂的优化工作的底层代码，所以很容易产生 Bug，从而使得攻击者跳出虚拟机、获取到虚拟机所在系统的访问权限。这就是为何像 [Chrome](https://www.chromium.org/Home/chromium-security/site-isolation) 和 [Firefox](https://blog.mozilla.org/security/2021/05/18/introducing-site-isolation-in-firefox/) 这样的浏览器要竭尽全力确保网站运行在完全隔离的进程中。

相反的是，Wasm 引擎需要的代码极少，因此便于检查，而且它们中有许多是用 Rust 这种内存无害语言写的。而由 WebAssembly 模块生成的原生二进制码，其内存隔离的安全性是[可以验证](http://cseweb.ucsd.edu/~dstefan/pubs/johnson:2021:veriwasm.pdf)的。

通过在 Wasm 引擎中运行 JavaScript 代码，我们构筑起了这座安全性更高的外部沙盒堡垒，以此作为另一道防线。

因此，在上述这些场景中，让 JavaScript 在 Wasm 引擎上运行得更快，是裨益良多的。那我们怎么来实现呢？

要回答这个问题，我们需要弄清楚 JavaScript 引擎把它的时间都消磨在哪里了。

## JavaScript 的两个耗时之处

我们可以粗略地把 JavaScript 引擎所做的工作拆分为两个部分：初始化和运行时。

我把 JavaScript 看作是一个包工头。这位包工头被雇用来完成这样一份工作 —— 运行 JavaScript 代码，并得出结果。

![JavaScript 引擎与 JavaScript 文件握手，并说：“我来帮你运作这个项目！”](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/03-01-office-handshake.png)

### 初始化阶段

在这位包工头真正开始运作项目之前，它需要做一点预备工作。此初始化阶段包括了在执行之初所有那些只需运行一次的操作。

#### 应用初始化

不论是什么项目，我们的合同工都需要了解一下客户的需求，然后配置要完成任务所需的资源。

例如，合同工先生浏览一遍项目概要以及其他支持文档，然后把它们转化成自己能处理的东西，比如搭建一个项目管理系统，把所有文档存储并整理起来。

![JavaScript 引擎坐在自己的办公室里，对 JavaScript 文件说：“来，告诉我你想完成什么任务。”](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/03-03-office-kickoff.png)

在 JavaScript 引擎看来，这个任务更像是通读顶层源码并把各项功能解析为字节码、为声明的变量分配内存、给已经定义过的变量赋值。

#### 引擎初始化

在无服务器等特定场景中，还有另一个需要初始化的部分，发生在应用初始化之前。

那就是引擎初始化。引擎本身需要率先启动起来，内置函数需要添加到环境当中。

我把这个过程看作在开始工作之前要先把办公室布置好 —— 组装宜家桌椅之类的事。

![JavaScript 引擎给自己的办公室组装宜家桌子](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/03-02-office-ikea.png)

这个过程也可能花费一定量的时间，也是导致冷启动成为无服务器使用场景的大问题的原因之一。

### 运行时阶段

一旦初始化阶段结束，JavaScript 引擎就能开始运行代码了。

![JavaScript 引擎在任务看板里挪动任务卡片，最终挪到完成列。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/03-04-office-kanban.png)

我们把这部分工作的完成速度称为吞吐量（Throughput），能影响吞吐量的因素有很多。比如：

* 功能使用哪种语言开发
* JavaScript 引擎是否能预测代码行为
* 使用哪种数据结构
* 代码的运行周期是否足够长到能从 JavaScript 引擎的优化编译中获益

那么这就是 JavaScript 消耗时间的两个阶段。

![上文中的三张图片，表现了办公室的搭建、初始化阶段的需求收集，以及运行时阶段的任务周期。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/03-05-office-sequence.png)

那我们该如何让这两个阶段运行得更快呢？

## 大幅压缩初始化耗时

我们先使用 [Wizer](https://github.com/bytecodealliance/wizer) 这个工具来加快初始化过程。稍后我会解释如何操作，但为了让心急的读者一睹为快，下面先给出运行一个非常简单的 JavaScript 应用时的加速情况。

![柱状图：启动延迟时间对比。纯 JavaScript 消耗 5 毫秒，Wasm 中的 JavaScript 消耗 0.36 毫秒。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/04-01-startup-latency-vs-isolate.png)

当用 Wizer 运行这个小应用时，只消耗了 0.36 毫秒（等于 360 微秒）。这要比纯 JavaScript 的方式快了不止 13 倍。

启动能如此迅速，是因为借助了快照（Snapshot）。Nick Fitzgerald 在 [WebAssembly 峰会上关于 Wizer 的演讲](https://youtu.be/C6pcWRpHWG0?t=1338)中进行了更为详尽的解释。

那么其中的原理是什么？在部署代码之前，作为构建步骤的一部分，我们用 JavaScript 引擎运行 JavaScript 代码，直到初始化结束。

在此处，JavaScript 引擎把所有的 JavaScript 代码解析成了字节码，并存储在了线性内存中。在这一阶段，引擎还会进行大量的内存分配和初始化工作。

由于线性内存的独立完备性非常强，当所有的数据值被存进来后，我们直接把这块内存绑定为 Wasm 模块的数据区块即可。

当 JavaScript 引擎模块被实例化后，它就能访问数据区块中的所有数据了。当引擎需要使用这块内存时，它可以复制所需的区块（或者内存页）到自己的线性内存中去。这样，JavaScript 引擎在启动时就无需再做配置工作了。所有的预初始化的数据就都已经准备就绪、听凭差遣了。

![一个 Wasm 文件分为代码和数据区块两部分，数据区块被灌入线性内存。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/04-02-wasm-file-copy-mem.png)

眼下，我们把这个数据区块和 JavaScript 引擎绑在了一起。但在将来，一旦[模块链接（Module linking）](https://github.com/WebAssembly/module-linking/blob/master/proposals/module-linking/Explainer.md)可用了，我们就能把数据区块装载为一个单独的模块了，也就能让 JavaScript 引擎被多个不同的 JavaScript 应用复用了。

这样就实现了真正干净清爽的解耦。

JavaScript 引擎模块只包含引擎本身的代码。这意味着一经编译完成，这部分代码就可以高效率地被多个不同实例缓存和复用了。

另一方面，特定的应用模块不包含 Wasm 代码。它只含有线性内存，而线性内存只含有 JavaScript 代码字节码，以及初始化生成的 JavaScript 引擎状态数据。这让内存整理和分配十分便利。

![两个相邻的 Wasm 文件。JavaScript 引擎模块文件只包含代码区块，而 JavaScript 应用模块文件只具有数据区块](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/04-03-wasm-file-data-vs-code.png)

就好像是我们的包工头 JavaScript 引擎根本不需要再去布置办公室了。它直接可以拎包入住了。它的包里装下了整个办公室，所有器具一应俱全，全部都调校就绪，就等 JavaScript 引擎破土动工了。

![拟人化的 Wasm 引擎正在放置 JavaScript 引擎的办公室快照，并说：“我会帮你布置好，让你可以立马开工。”](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/04-04-preinitiatlized-engine.png)

而最酷的就是，这不是特地为 JavaScript 实现的 —— 只需要使用 WebAssembly 现有的属性即可。所以你也可以把这个办法用在 Python、Ruby、Lua 或其他运行时环境中。

## 下一步：提升吞吐量

通过这种方式，我们可以让启动时长超级短了。那如何优化吞吐量呢？

对于某些情况来说，吞吐量其实不算差。如果你的 JavaScript 应用运行周期非常短，它怎么也轮不到即时编译来处理 —— 它的全程都在解释器中完成。在这种情况中，吞吐量就和在浏览器中一样了，在传统的 JavaScript 引擎初始化完成之前，程序就已经运行完了。

但是对于运行周期更长的 JavaScript 代码，即时编译用不了多久就得开始介入了。一旦发生这种情况，吞吐量的差异就开始变得悬殊了。

如我上面所言，在纯 WebAssembly 环境中是不可能使用即时编译的。但事实上，我们可以把即时编译的一些想法应用到提前编译模型中。

### 快速 AOT 编译 JavaScript 代码（无分析）

即时编译用到的一个优化技术是内联缓存（Inline caching）。通过内联缓存，即时编译创建一个存根链表，其中包含了机器编码的快捷路径，指向曾经运行过的 JavaScript 字节码的所有运行方式。（详情请参阅文章：[即时编译器速成课](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)）

![拟人化的 JavaScript 引擎对照 JavaScript 代码组成的矩阵，根据监控器的定期反馈创建机器代码存根](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/02-06-jit09.png)

之所以需要用链表，是因为 JavaScript 是动态类型语言。每当一行代码变换了不同的类型，你就需要生成一个新的存根，添加到链表中。但如果之前就处理过这个类型，那就可以直接使用已经生成好的存根。

由于内联缓存（IC）在即时编译中比较常用，人们会认为它们是非常动态化的，并且专用于特定程序。但实际上，它们也可以用于 AOT 场景。

即使我们还没有看到 JavaScript 代码，我们也对要生成的 IC 存根比较熟悉了。这是因为 JavaScript 中有一些模式是经常被使用到的。

访问对象属性就是一个有力的佐证。访问对象属性在 JavaScript 代码中非常常见，而使用 IC 存根就能为这个操作提速。对于那些有确定“形状”或者“隐藏类”（即属性的存储位置相对固定）的对象来说，当你读取这类对象的某个属性，该属性总在同样的偏移位置（Offset）上。

按照传统，即时编译中的这种 IC 存根会硬编码为两种值：一个是指向形状的指针，一个是属性的偏移量。而这所需的信息，是我们提前预知不到的。但我们能做的是把 IC 存根参数化。我们可以把形状和属性偏移量看作是传到存根里的变量。

这样，我们就能创建出一个单独的存根，它从内存中加载值，然后我们可以到处使用这个存根。我们可以把属于常见模式的所有存根合成一个 AOT 编译模块，不去关心 JavaScript 代码的具体功能细节。即使在浏览器设置中，这种 IC 共享也是有益处的，因为这让 JavaScript 引擎生成更少的机器编码，提升启动速度，优化本地指令缓存。

对于我们的使用场景来说，IC 共享尤其重要。它意味着我们可以把属于常见模式的所有存根合成一个 AOT 编译模块，不去关心 JavaScript 代码的具体实现细节。

我们发现，仅需几 KB 的 IC 存根，就能覆盖全部 JavaScript 代码中的绝大部分。例如，只需 2 KB 的 IC 存根，就足以覆盖 Google Octane 基准测试中 95% 的 JavaScript 代码。从初步测试结果来看，通常的网页浏览场景似乎都能保持这个比率。

![左侧是一小叠存根，右侧是一大堆 JavaScript 文件。](https://bytecodealliance.org/articles/img/2021-06-02-js-on-wasm/talk-stub-coverage.png)

因此，使用这种优化手段，我们应该能够达到早期即时编译的吞吐量水平。一旦我们做到这个程度，我们就将加入更细粒度的优化，进一步打磨性能，正如各个浏览器厂商的 JavaScript 引擎开发团队在早期即时编译中所做的那样。

### 下一步：或许该加一点分析？

以上是我们能提前做的，无需知道一个程序是做什么的，也无需知道它都使用了什么类型的数据。

但要是我们能像即时编译一样访问到分析数据呢？那我们就可以全面优化代码了。

但这会引出一个问题 —— 开发者分析起自己的代码来往往十分困难。要想提取出有代表性的代码样本，实非易事。因此我们没法确定是否能得到优质的分析数据。

如果我们能找合适的工具来进行分析，那么我们还是有可能让 JavaScript 代码运行得像如今的即时编译一样快速（连热身的时间都不需要！）的。

## 如今该如何上手？

这种新的方式让我们激动不已，让我们期盼着能更上一层楼。我们也很激动地看到，其他动态类型语言可以用这种方式拥抱 WebAssembly 了。

因此，下面是有几种上手的方式，如果你有任何问题，你可以在 [Zulip](https://bytecodealliance.zulipchat.com/) 中提问。

### 对于其他想支持 JavaScript 的平台

要想在自己的平台运行 JavaScript，你需要嵌入一个支持 WASI 的 WebAssembly 引擎。我们正在使用的是 [Wasmtime](https://github.com/bytecodealliance/wasmtime)。

然后你需要 JavaScript 引擎。在这一步里，我们为 Mozilla 的构建系统添加了对编译 SpiderMonkey 到 WASI 的完全支持。Mozilla 将把 SpiderMonkey 的 WASI 构建添加到用于构建和测试 Firefox 的 CI 设置中。这让 WASI 成为了 SpiderMonkey 的线上质量目标，确保了 WASI 构建能够一直保持运转。这意味着你可以文中所讲的那样使用 [SpiderMonkey](https://spidermonkey.dev/)。

最后，你需要让用户提供预先初始化的 JavaScript 代码。为了能助你一臂之力，我们还开源了 [Wizer](https://github.com/bytecodealliance/wizer)，你可以[集成到构建工具中](https://github.com/bytecodealliance/wizer#using-wizer-as-a-library)，产出针对特定应用的 WebAssembly 模块，以适用于 JavaScript 引擎模块所用的预先初始化内存。

### 对于其他想要使用这种方法的语言

如果你是 Python、Ruby、Lua 等语言的使用者，你也可以针对该语言构建出一个自己的版本。

首先，你需要把运行时编译成 WebAssembly，使用 WASI 作为系统调用，可参考我们对 SpiderMonkey 的处理。然后，你可以按照上文所说，[把 Wizer 集成到构建工具中](https://github.com/bytecodealliance/wizer#using-wizer-as-a-library)，生成内存快照，这样就能用快照来加速启动。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
