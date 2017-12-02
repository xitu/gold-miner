> * 原文地址：[A million requests per second with Python](https://medium.freecodecamp.com/million-requests-per-second-with-python-95c137af319#.59n519vvy)
* 原文作者：[Paweł Piotr Przeradowski](https://medium.freecodecamp.com/@squeaky_pl?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cdpath](https://github.com/cdpath)
* 校对者：[Kangkang](https://github.com/xuxiaokang), [独步清风](https://github.com/dubuqingfeng)

# 用 Python 实现每秒百万级请求

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*nAr_UQ1RcT-2mcfstPLocQ.jpeg">

用 Python 可以每秒发出百万个请求吗？这个问题终于有了肯定的回答。

许多公司抛弃 Python 拥抱其他语言就为了提高性能节约服务器成本。但是没必要啊。Python 也可以胜任。

Python 社区近来针对性能做了很多优化。CPython 3.6 新的字典实现方式提升了解释器的总体性能。得益于更快的调用约定和字典查询缓存，CPython 3.7 会更快。

对于计算密集型工作，可以利用 PyPy 的即时编译。Numpy 的测试组件亦可一试，其对 C 拓展的兼容性已有全面提升。预计今年晚些时候 PyPy 会兼容 Python 3.5。

所有这些杰出的贡献鼓舞我在 Python 应用最广泛的领域 —— web 和微服务 —— 开拓创新。

### 欢迎来到 Japronto 的世界！

[Japronto](https://github.com/squeaky-pl/japronto) 是为你的需求量身打造的全新微服务框架。其主要目标就是**快，可拓展并且轻量**。通过 asyncio 使得同时**同步**和**异步**编程变成可能。而且 Japronto 出人意料的**快**，甚至快过 NodeJS 和 Go。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*FThTeS_kxx3j7AkTgmMKNw.png">

Python 微框架（蓝色），黑暗力量（绿色）和 Japronto（紫色）

**勘误**：@heppu 指出， Go 标准库 HTTP 服务端如果写得更小心些可以获得比图表所示要高 **12% 的速度提升**。此外还有个出色的 Go 语言 fasthttp 服务端实现，据说在这个基准测试中只比 Japronto **慢 18%**。赞！详见 [https://github.com/squeaky-pl/japronto/pull/12](https://github.com/squeaky-pl/japronto/pull/12)  和 [https://github.com/squeaky-pl/japronto/pull/14](https://github.com/squeaky-pl/japronto/pull/14)。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*z0kap1TTsGimPXTafpW0gw.png">

我们同时注意到 Meinheld WSGI 服务端几乎跟 NodeJS 和 Go 一样快。尽管其内部采用阻塞设计，它和前面四个 Python 异步方案比起来性能也不差。所以不要轻信任何人所说的异步系统一定更快的言论。异步几乎一定意味着更高的并发，但是往往并发过了头了。

我用 “Hello world！” 做了这个小基准测试，足够说明一些服务器框架解决方案的系统开销。

这些测试是在 AWS São Paulo 区的 c4.2xlarge 实例上进行的，配置是 8 VCPU，默认配置的共享带宽，HVM 虚拟化和弹性存储。操作系统是 Ubuntu 16.04.1 LTS (Xenial Xerus)，内核是 Linux 4.4.0–53-generic x86_64，CPU 是 Xeon® E5–2666 v3，主频是 2.90GHz。Python 版本是最近从源码编译的 Python 3.6。

公平起见，所有评比对象（包括 Go）都运行在单工作进程上。服务端则使用单线程的 [wrk](https://github.com/wg/wrk) 做负载测试，100 个连接，每个连接 24 个（管线化的）同步请求，累积起来相当于 2400 个请求。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*dy-91Ek-ecUy2kvYUe0Thg.png">

HTTP 管线化（图片版权维基百科） 

[HTTP 管线化](https://zh.wikipedia.org/zh-cn/HTTP%E7%AE%A1%E7%B7%9A%E5%8C%96)至关重要，因为这是 Japronto 在执行请求时考虑到的优化手段之一。

大多数服务器执行管线化客户端请求的方式并不会和处理非管线化客户端请求有什么不同。也不会尝试进行优化。（事实上 Sanic 和 Meinheld 会静默丢弃管线化客户端发来的请求，这不符合 HTTP 1.1 协议。）

简而言之，管线化技术让客户端不必等待响应就可以复用同一 TCP 连接发送后续的请求。为保证通信的完整性，服务端发送响应的顺序要和收到的请求的顺序一致。

### 关于优化的有趣细节

客户端在合并许多小 GET 请求的时候，这些请求很有可能会发到服务端的同一个 TCP 包中去（这要归功于[纳格算法](https://zh.wikipedia.org/zh-cn/%E7%B4%8D%E6%A0%BC%E7%AE%97%E6%B3%95)），随后被一次**系统调用读取**。

进行一次系统调用并将数据从内核空间移动到用户空间比在进程空间内移动内存要更加昂贵。这就是为什么只执行必需的系统调用非常重要（但是也不能过少）。

Japronto 收到数据并成功地解析了几个请求后，就会尝试尽快搞定所有的请求，并将响应以正确的顺序组合在一起，然后用**一次系统调用写回**。实际上内核在组合响应时亦可发挥作用，这要归功于 [scatter/gather IO](https://en.wikipedia.org/wiki/Vectored_I/O) 系统调用，不过 Japronto 还没有利用它。

不过要注意管线化并不总是可行，因为个别请求可能会耗费过长时间，等待它们会毫无必要地增加延迟。

在调整试探方法时请务必小心，既要考虑到系统调用的成本也要考虑到预估的完成请求的耗时。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*Xy5aoOtYNpq4DzPJUU6ihA.png">

Japronto 可以发出每秒请求数 (RPS) 中位数达 1,214,440 的分组连续数据，该数字使用内插法，取第五十百分位数算出。

除了延迟对管线化客户端的写操作外，Japronto 还用到了其他技术。

[Japronto](https://github.com/squeaky-pl/japronto) 几乎完全用 C 语言实现。解析器，协议，连接收割机（connection reaper)，路由以及请求和响应对象都是 C 语言拓展。

除非明确要求，[Japronto](https://github.com/squeaky-pl/japronto) 会尽量推迟创建其内部结构对应的 Python 对象。比如除非在 view 中明确要求，Japronto 不会创建头部字典。所有的符号边界都已标记，但是标准化请求头的键名并创建字符串对象这种事只有在第一次被访问时才会做。

Japronto 使用出色的 picohttpparser 库来解析状态行，头部以及分块的 HTTP 消息体。Picohttpparser 直接调用有（几乎所有十年来的 x86_64 CPU 都有的） SSE4.2 拓展的现代 CPU 的文字处理指令，来迅速匹配 HTTP 符号边界。I/O 交由超级赞的 uvloop 处理，uvloop 本身就是 libuv 的包装器。在最底层这就是 epoll 系统调用的桥梁，提供了异步的读写就绪通知。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*I_QzQDSDqTVf04SwsEe3IQ.png">

Picohttpparser 依赖 SSE4.2 和 CMPESTRI x86_64 intrinsic 进行解析。

Python 具有垃圾回收机制，所以设计高性能系统时要小心不要给垃圾回收器带来不必要的压力。[Japronto](https://github.com/squeaky-pl/japronto) 的内部设计尽量避免循环引用，分配/释放内存亦非常节制。这是通过预先分配一些对象到所谓的「竞技场」实现的。Japronto 还会尝试复用不再被引用的 Python 对象到将来的请求上，而不是直接丢弃掉。

所有分配的内存大小都是 4KB 的整数倍。精心排布的内部结构将频繁使用的数据放在非常接近的内存区域中，这就最小化了缓存未命中的概率。

Japronto 尝试避免不必要的跨缓冲区拷贝，许多操作都就地完成。比如它先百分比解码（注：即 URL 解码）路径，再进行路由的匹配。

### 开源贡献者们，我需要你的帮助

我连续开发 [Japronto](https://github.com/squeaky-pl/japronto) 已有三月 —— 通常是在周末，也有工作日。这还是因为我放下了日常的开发工作，全身心投入到了这个项目。

我想是时候和社区分享我劳动的果实了。

[Japronto](https://github.com/squeaky-pl/japronto) 已实现了许多完善的特性：

- 实现了 HTTP 1.x ，支持分块上传
- 完善的 HTTP 管线化支持
- Keep-alive 连接，可配置的 reaper
- 支持同步和异步 view
- 基于 fork 的 Master-multiworker 模型
- 支持变化时重载代码
- 简化的路由

我接下来还打算研究一下 Websockets 和异步 HTTP 响应。

还有许多文档和测试的工作有待完成。如果你想伸出援手，请直接在 [Twitter](http://twitter.com/squeaky_pl) 上与我联系。这是 Japronto 的 [GitHub 地址](https://github.com/squeaky-pl/japronto)。

 同时，如果你的公司在招募热衷于压榨性能同时还会 DevOps 的 Python 开发者，请联系我。国外的公司我也会考虑。

### 最后的话

我这里提到的所有技术其实都不是 Python 独占的。它们可能也可以用在其他语言上，比如 Ruby、JavaScript 甚至 PHP。我也想做这一部分的开发，不过除非有人赞助这基本上不太现实。

我想感谢 Python 社区在优化性能方面持续的投入。具体就是感谢 Victor Stinner [@VictorStinner](https://twitter.com/VictorStinner)，INADA Naoki [@methane](https://twitter.com/methane)，Yury Selivanov [@1st1](https://twitter.com/1st1) 以及全体 PyPy 团队。

出于对 Python 的爱。
