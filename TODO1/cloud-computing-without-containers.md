> * 原文地址：[Cloud Computing without Containers](https://blog.cloudflare.com/cloud-computing-without-containers/)
> * 原文作者：[Zack Bloom](https://blog.cloudflare.com/author/zack-bloom/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cloud-computing-without-containers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cloud-computing-without-containers.md)
> * 译者：[TrWestdoor](https://github.com/TrWestdoor)
> * 校对者：

# 无容器下的云计算

Cloudflare 有一个云计算平台称为 [Workers](https://www.cloudflare.com/products/cloudflare-workers/)。**不像据我所知道的其它云计算平台所必须的那样，它无需容器或虚拟机**。我们相信这将是无服务器和云计算的未来，我也将努力说服你这是为什么。

### Isolate

![](https://blog.cloudflare.com/content/images/2018/10/Artboard-42@3x.png)

两年前我们面临一个问题。受限于应当在内部建立多少特性和选项，我们需要为用户找到一个方法来使得他们能自己完成构建。因此我们着手寻找一个方法可以让人们在我们部署在全球各地的服务器上（我们有一百多个数据中心，截止本文写作时这个数字为 155）写代码。我们的系统需要可以安全且低开销的运行不可信的代码。我们坐在上千万的站点前，每秒执行数百万个请求，同时还要求必须执行得非常非常快。

之前我们使用的 Lua 并不在沙盒中运行；用户不能在没有我们监督的情况下写他们自己的代码。像 Kubernetes 这种传统的虚拟化和容器技术对每个相关用户来说都格外昂贵。在单一位置运行数千个 Kubernetes pods 将会是资源密集型的，在 155 个地方运行则将更糟。相比于没有管理系统，扩展他们会更容易些，但也绝非易事。

最后我们用上了由 Google Chrome 团队构建的一项为其浏览器中的 Javascript 引擎提供动力的技术 -- V8: Isolates。

Isolates 是一个轻量的上下文，包含了被分组过的若干变量及用来改变它们的代码。更重要的是，一个单一的进程可以运行成百上千个 Isolates，并且在它们之间无缝切换。这使得在一个操作系统进程上运行来自不同用户的不可信代码成为可能。它们被设计的可以快速启动（有几个不得不在你的浏览器中启动，这仅仅是为你加载这个网页），并且不允许一个 Isolate 访问其它 Isolate 的内存。

我们承担一次 Javascript 的运行开销，然后基本上可以无限执行这个脚本，并且几乎无需再单独承担某次的开销。启动任何给定的 Isolate 都比在我的机器上启动 Node 进程快一百倍。更重要的是，它们比该进程所需的内存消耗要少一个数量级。

它们具有所有友善的功能即服务（function-as-a-service）的人体工程学，只需要编写代码而不必担心它如何运行或缩放。与此同时，它们不使用虚拟机或容器，这意味着你实际上以一种我所知的其他任何一种云计算方式都更接近裸金属的方式运行着。我相信这种模型更接近在裸金属上运行代码的经济型，但却运行在完全无服务器的环境中。

本文并不是 Workers 的一个软广，但是我想要展示一个图表来反映差别有多么明显，以展示为什么我认为这不是一个迭代式的改进，而是一个实际的模式转换：

![](https://blog.cloudflare.com/content/images/2018/10/image-2.png)

这个数据反映了从最近的数据中心执行请求的反应时间（包括网络延迟），这个数据中心部署了所有的功能，按照 CPU 密集型执行。[来源](https://blog.cloudflare.com/serverless-performance-with-cpu-bound-tasks/)

### 冷启动

![](https://blog.cloudflare.com/content/images/2018/10/Cold-start@3x.png)

并非所有人都充分理解类似于 Lambda 这样的传统无服务器平台是如何工作的。它给你的代码构建一个容器进程。相比于在你自己的机器上运行 Node，它不会在一个更轻量级的环境中运行你的代码。它所做的是自动缩放这些进程（稍显笨拙）。这个自动缩放过程则会导致冷启动。

冷启动是指你的代码的新副本必须在一个机器上启动时而发生的事情。在 Lambda 的世界中，这相当于构建一个新的容器进程，这大概会花费500毫秒到10秒的时间。任何来自于你的请求都会被挂起十秒之多，相当糟糕的用户体验。一个 Lambda 在某一时刻只能处理一个请求，所以每次有额外的并发请求时一个新的 Lambda 就必须冷启动了。这意味着延迟请求可能会一再发生。如果你的 Lambda 没有及时收到请求，它将被关闭然后再重头开始。无论何时你部署新代码这都会重新发生，因为每个 Lambda 必须被重新部署。这常被认为是无服务器化并非吹嘘的那么好的原因。

因为 Workers 无需开始一个进程，Isolates 在5毫秒内启动，这个时间是令人难以察觉的。同样的，Isolates 测量和部署的非常快，完全消除了现有无服务器技术面临的问题。

### 上下文切换

![](https://blog.cloudflare.com/content/images/2018/10/multitasking-bars@3x.png)

操作系统的一个关键特性是允许你一次执行多个进程。它在任何时刻你想运行的代码的进程上透明地切换。为了实现这一点而将其称之为‘上下文切换’：将一个进程所需的内存全部移出，并将下一个进程所需的内存加载进来。

上下文切换大概需要花费 100 多毫秒。当该时间与运行在你的 Lambda 服务器上的所有 Node、Python 或 Go 进程相乘时，会导致繁重的开销，这意味着 CPU 们的算力并没有全部应用到用户的代码执行上来，因为它被花费在了上下文切换中。

基于 Isolate 的系统会在一个进程中执行完所有代码，并且使用自己的机制来保证安全的内存访问。这意味着无需在上下文切换中花费过多，机器实际上将几乎所有时间都用来执行你的代码。

### 内存

**Node 或 Python 的运行时旨在运行于独立用户的自有服务器上。这些代码从来没有被考虑过将其运行在多租户环境中，这种环境有成千上万个其他用户代码和严格的内存要求。** 一个基本的 Node Lambda 运行的内存消耗大约是 35 MB。当你像我们这样在所有 Isolates 之间共享运行时的时候，这个数字会降到大约 3 MB。

内存常常是运行用户代码时最大的成本消耗（甚至高过 CPU），降低它一个数量级可以极大程度改善经济性。

基本的 V8 被设计成多租户模式。它被设计成在单个进程的隔离环境中，在你的浏览器的多个标签里运行代码。Node 和类似的运行时则并非如此，它显示在构建在其上的多租户系统中。

### 安全性

在同一个进程里面运行多个用户的代码显然需要仔细注意安全性。对于 Cloudflare 来说，自己构建这个隔离层既没有生产力也没有效率。它需要大量的测试、模糊、渗透测试，以及建立一个真正安全且如此复杂的系统所需要的资源。

使得这一切可行的唯一原因就是 V8 的开源性，以及它作为或许是世界上最好的安全测试软件的地位。我们也构建了少量的安全层，包括对定时攻击的各种保护，但是 V8 才是确保这个计算模型可行的真正奇迹。

### 计费

这并不意味着要对 AWS 的计费进行公投，但是却有一个很有趣的经济现象值得简单提一下。Lambda 的计费是按照它们的运行时间来计算的。该计费被四舍五入到最近的 100 毫秒，这意味着人们每次平均执行达到 50 毫秒就要多付钱。更糟的是，他们给你开的账单是整个 Lambda 的运行时间，即使时间是花费在等待外部请求的完成。由于外部请求的时间一般都是数百上千毫秒，你最终可能会支付一个很荒谬的价钱。

Isolates 只占有非常少量的内存空间，这样至少我们仅仅会为你的代码的实际执行时间开具账单。

在我们的例子中，由于更低的开销，Workers 最终在每个 CPU 周期上可以便宜 3 倍。一个 Worker 对每百万请求提供 50 毫秒 CPU 的价钱是 0.50 美元，同样的 Lambda 对每百万请求的价钱是 1.84 美元。我相信降低 3 倍的成本可以有效的推动公司们转向基于 Isolate 的提供商。

### 网络就是电脑

亚马逊有一个名为 Lambda@Edge 的产品，它被部署在他们的 CDN 数据中心。不幸的是，它比传统的 Lambda 要贵三倍，并且它需要在初次部署时花费大约 30 分钟。它还不允许任意请求，将其用途限制为与 CDN 类似的用途。

相反，正如我提到的，使用 Isolate 我们可以将源文件部署到 155 个数据中心，并且在经济性上比亚马逊做的更好。实际上在 155 个 Isolates 上运行比在一个容器中运行要更加便宜，也或许是亚马逊在向市场收取一个大家能承受但是比他们的成本高得多的费用。我不知道亚马逊的经济状况，我只知道我们对我们自己的很满意。

很久以前人们就确定，要有一个真实可靠的系统那它必须部署在地球上的多个地方。但 Lambda 运行在一个单一的有效区，单一的区域和一个单一的数据中心。

### 缺陷

没有技术是完美无瑕的，每一次转变都会伴随一些缺陷。基于 Isolate 的系统不能任意编译代码。进程级隔离允许你的 Lambda 拥有任何它需要的二进制文件。在一个 Isolate 空间中，你必须使用 Javascript 来编写你的代码（我们使用了大量的 TypeScript），或者使用像 Go 或 Rust 这种针对 WebAssembly 的语言。

如果你不能重新编译进程，你就不能在一个 Isolate 中运行它们。这或许意味着基于 Isolate 的无服务器化只能用于更新的、更现代化的、当下流行的应用程序。它也可能意味着遗留的应用程序仅仅能将最敏感的部件移动到 Isolate 的初始化中。社区也在寻找更新更好的方法来将现有的应用程序转到 WebAssembly，使得这些问题还有讨论的余地。

### 我们需要你

![](https://blog.cloudflare.com/content/images/2018/10/no-VM-@3x-3.png)

我希望你可以[尝试一下 Workers](https://developers.cloudflare.com/workers/about/)并且让我们和社区知道你的经历。仍然有很多需要我们去完善建立的内容，我们可以利用你的反馈来做这些。

我们同样需要一些对这感兴趣并想将其应用到新方向的工程师和产品经理。如果你是在旧金山，奥斯丁或者伦敦，请加入我们吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
