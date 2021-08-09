> * 原文地址：[Rust in production at Figma](https://www.figma.com/blog/rust-in-production-at-figma/)
> * 原文作者：[Evan Wallace](https://twitter.com/evanwallace)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Rust-in-production-at-Figma.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Rust-in-production-at-Figma.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[lsvih](https://github.com/lsvih)、[zhuzilin](https://github.com/zhuzilin)、[youngjuning](https://github.com/youngjuning)

# Figma 生产环境中的 Rust

> Mozilla 的新语言究竟是如何显著地提升了我们服务端的性能的呢？

![](https://miro.medium.com/max/4320/1*LoKiYs4SoAtkpFufNdD0AA.png)

对于我们 [Figma](https://www.figma.com/) 来说，性能永远是我们最重要的卖点之一。我们力争去让团队能够所思即所得，而我们的多人同步引擎就是决定这个愿景能否实现的关键部分。我们希望能够让每个协作者都可以实时看到别人在 Figma 文档中所做的修改！

我们[两年前开启的](https://blog.figma.com/multiplayer-editing-in-figma-8f8076c6c3a6)这个多人服务器是用 TypeScript 编写的，并且出奇完美地服务了我们的客户。但我们也没有想到，Figma 的扩张如此迅速，让服务器无力追及。我们决定使用 Rust 语言重写这个服务器以解决这个问题。

[Rust](https://www.rust-lang.org/) 是由创建了 Firefox 的非盈利组织 Mozilla 所创建的一款新的程序语言，而 Mozilla 也正使用它来构建跨时代的浏览器原型，[Servo](https://research.mozilla.org/servo-engines/)，向全世界证明了浏览器可以比现如今速度更快的浏览器。Rust 和 C++ 在性能和底层上很相像，但是它拥有一个类型系统，自然而然地避免了[一大堆令人作呕的 Bug](https://polyfloyd.net/post/how-rust-helps-you-prevent-bugs/) 的这种经常会在 C++ 程序中出现的情况的出现。

我们之所以选择 Rust 作为重写服务器的语言，它兼具一流的速度和较低的资源使用率，同时提供了标准服务器语言所需的安全性保障。而这其中，较低资源使用率对我们尤其重要，因为我们旧服务器的部分性能问题，就是垃圾回收导致的。

我们也觉得这会是一个非常好的在生产中使用 Rust 的案例，并且希望分享我们在这个过程中所遇到的麻烦和我们所取得的成效，以期对其他有着类似考虑去重写代码的开发者们有些许帮助。

## 用 Rust 扩展我们的服务

我们的多人服务是运行在固定数量的一些机器，每个服务都拥有着固定数目的进程（Worker），并且每个文档都独立运行在一个特定的进程上。这意味着每一个进程都负责当前打开的 Figma 的文档的一部分。这看起来会是这样的：

![https://miro.medium.com/max/2230/1*b_L0C2dgCIsZSuRtdT2aOg.png](https://miro.medium.com/max/2230/1*b_L0C2dgCIsZSuRtdT2aOg.png)

我们遇到的最主要的问题，就是旧服务器会在同步时候遇到无法预计的延迟高峰。这个服务器是使用 TypeScript 编写的，并且是单线程的，完全不能同时处理多项操作。这意味着单一一个操作的缓慢会导致整个进程在这个操作完成前的停止。而常见的操作就是对文档的解码。Figma 上的文档可能会非常大，因此这个操作会显然会消耗一长段时间，让连接在这个进程上的用户暂时无法同步他们的更改。

扔给这项服务更多的硬件丝毫不能缓解这个问题，因为一个缓慢的操作就会让这个进程所负责的所有文件都无法使用，而且我们无法为每一个文档都单独创建一个 Node.js 线程，因为 JavaScript 虚拟机的内存开销实在太大了。事实上只有很少一部分大文件会造成麻烦，但这就会影响所有用户的服务体验啊！我们的临时解决方法是将那些疯了的巨大的文档独立，隔离到一个单独的进程池中：

![https://miro.medium.com/max/2230/1*8bzkHy9Fg3fZXTEHIm65kg.png](https://miro.medium.com/max/2230/1*8bzkHy9Fg3fZXTEHIm65kg.png)

这能让服务器跟上来了，但是这个方案注定让我们被迫持续关注所有这类型的文档，并将它们人工独立出去。我们借助这个方案还是争取来了一些时间，并且通过将对性能敏感的服务移动到单独的子进程中，我们能够继续去探索解决这些问题的方法了。这些子进程是用 Rust 编写的，并且通过标准输入输出与它的父进程沟通。而这些新的小不点使用的内存，也像他们的年龄那般 —— 对比起那些年老珠黄的旧服务来说嘛。现在我们完全可以通过为每一个文档提供一个单独的子进程来让所有的文档能够并行使用了，并且序列化时间是原有的 10 倍那么快，甚至在最差的情况下也完全可以接受了。新的架构看起来是这样的：

![https://miro.medium.com/max/2350/1*JvrV35TNvuARMRcvFpeMaQ.png](https://miro.medium.com/max/2350/1*JvrV35TNvuARMRcvFpeMaQ.png)

## 服务端的性能提升

我们的服务器的性能提升令人难以置信。下图显示了逐步的推出新服务架构之前、之时和之后一周的各种性能指标。图片中间的大幅下降的部分是我们完全部署时候的指标。请记住，这些改进是针对服务器端的性能，而不是客户端的性能，因此，它们的主要作用只是为了让该进程能够为所有人不会造成任何麻烦顺利进行他们的工作

![https://miro.medium.com/max/1440/1*s7uU1Sd7IF7xOjR2mv4xRA.png](https://miro.medium.com/max/1440/1*s7uU1Sd7IF7xOjR2mv4xRA.png)

![https://miro.medium.com/max/2230/1*1sXGPC5m0cc_u_L-tt0m-Q.png](https://miro.medium.com/max/2230/1*1sXGPC5m0cc_u_L-tt0m-Q.png)

![https://miro.medium.com/max/1440/1*b3y9hIkhXJFe4aeVQQBOqQ.png](https://miro.medium.com/max/1440/1*b3y9hIkhXJFe4aeVQQBOqQ.png)

![https://miro.medium.com/max/1440/1*Ta8MtAg17e_L9qo09r-IxA.png](https://miro.medium.com/max/1440/1*Ta8MtAg17e_L9qo09r-IxA.png)

![https://miro.medium.com/max/2230/1*YxXXHIm6PTXEx-muh_h2xQ.png](https://miro.medium.com/max/2230/1*YxXXHIm6PTXEx-muh_h2xQ.png)

与旧服务器相比，这是峰值指标的数字变化：

![https://miro.medium.com/max/2230/1*48agi3zbT2Ifc2rDxE85pQ.png](https://miro.medium.com/max/2230/1*48agi3zbT2Ifc2rDxE85pQ.png)

## Rust 的优缺点

Rust 的确在编写高性能服务器这件事上帮了我们，但事实证明，这门语言也并没有我们想象中的那么好。即便它比标准的服务器端语言更年轻，但是仍然有不少粗糙待需继续磨平改良之处（见下文）。

最终，我们放弃了使用 Rust 重写整个服务器的那份最初的计划，而是选择只重写对性能敏感的那部分服务。这是我们在重写过程中遇到的一些优缺点：

### 优点

- **内存使用率低**

Rust 因为没有垃圾回收从而可以进行更细致地控制内存布局，并且具有体积非常小的标准库。Rust 使用的内存很少，因此在现实中为每个文档启动一个单独的 Rust 进程是可行的。

- **优秀的性能**

Rust 肯定兑现了它在最佳性能方面的承诺，既因为它可以利用上 LLVM 的所有优化，又因为该语言本身在设计时就看重了性能。Rust 的 [切片（slice）](https://doc.rust-lang.org/1.22.0/std/slice/) 使传递原始指针变得容易，很适合使用也很是安全。我们大量地使用了它，避免在的解析过程中数据的复制这一不必要的操作。[HashMap](https://doc.rust-lang.org/std/collections/struct.HashMap.html) 则是借助 [Linear Probing（线性探测）](https://zh.wikipedia.org/wiki/%E7%BA%BF%E6%80%A7%E6%8E%A2%E6%B5%8B) 和 [Robin Hood Hashing](https://en.wikipedia.org/wiki/Hash_table#Robin_Hood_hashing) 实现的，因此与 C++ 的[unordered_map](http://zh.cppreference.com/w/cpp/container/unordered_map) 不同，内容可以内联存储在单个分配中，从而带来更高的缓存的效率。

- **坚实的工具链**

Rust 内置有 [cargo](https://doc.rust-lang.org/cargo/index.html)，一款集构建工具、包管理、测试运行和文档生成于一体的工具，一种新时代语言的标准附带品，脱胎于 C++（我们考虑重写上使用的另一种语言）的过时之中。 Cargo 拥有着非常全面的文档，并且非常容易上手，并拥有着便利的默认配置。

- **更友善的错误信息**

Rust 比其他语言更复杂，因为 Rust 的使用上还有着另一部分，即借用检查器，一款拥有着需要学习的独特规则的检查器。社区开发者们已经付出了很多，努力使错误消息变得更利于阅读，能够真正显示出来问题所在。他们真的让 Rust 的学习变得更简单更完美！

### 缺点

- **生命周期是很令人迷惑的**

在 Rust 中，将指针存储在变量中可以防止我们更改它指向的对象，只要该变量仍然在作用域内。这样大大的保证了安全性，但有时候又过于严苛，因为在发生变化时可能不再需要该变量。即使是从一开始就关注 Rust 的开发者们，或是编写那些有趣的编译器并且知道如何像借阅检查器一样思考的开发者，仍然不得不沮丧地停下手中的工作，着手解决可能出现的一些不必要的借阅检查器带来的难题，而这会不停止的间断发生。[这篇博客](http://smallcultfollowing.com/babysteps/blog/2016/04/27/non-lexical-lifetimes-introduction/)中就有蛮多的例子拥有着这类问题。

*我们所做的事情：* 我们将程序简化为单个事件循环，该循环从 `stdin` 中读取数据并将数据写入 `stdout`（`stderr` 用于记录）。数据可以永久保存，也可以仅在事件循环期间保存。这消除了几乎所有借阅检查器的复杂性。

*如何解决：* Rust 社区正计划用 [Non Lexical Lifecycle](https://github.com/rust-lang/rfcs/blob/master/text/2094-nll.md) 解决这个问题。这个功能将缩短变量的生命，使其在使用后停止它的生命周期，让这个指针将不再能够阻止指向其余范围的事物的变化，从而消除了许多借阅检查器的伪阴性（即，让很多本身有问题但没有报错的错误重新显示出来）。

- **错误是很难调试的**

Rust 中的错误处理旨在通过返回一个可以表示成功或失败的值 `Result` 来完成。与 Exception 不同，在 Rust 中创建错误值不会捕获堆栈跟踪，因此我们获得的任何堆栈跟踪都是针对报告错误的代码，而不是引起错误的代码。

*我们所做的事情：* 我们最终将所有错误立即转换为字符串，然后使用一个宏，在字符串中包含失败的行和列。这很冗杂麻烦，但我们还是解决了这个问题。

*如何解决：* Rust 社区显然针对此问题提出了几种解决方法。其中一个称为 [Error Chain](https://docs.rs/error-chain/*/error_chain/)，另一个称为 [Failure](https://boats.gitlab.io/failure/)。我们没有注意到这些方法的存在，也不确定是否存在什么标准的解决方法。

- **许多库还很年轻**

Figma 的文档都是压缩过后的，因此我们的服务器需要能够处理压缩的数据的工具。我们尝试使用两个 Rust 压缩库（这两个库都被 Mozilla 的跨时代浏览器原型 Servo 使用着），但是两个库都存在一些细微纠正上的问题，导致文档的数据丢失。

*我们所做的：* 我们最终只使用了经过实践检验的 C 库 —— Rust 是基于 LLVM 构建的，因此从 Rust 调用 C 代码是非常简单的，毕竟所有东西最后都是变成 LLVM 代码嘛。

*如何修复：* 我们报告了受影响的库中的错误，现在问题已修复。

- **Rust 很难实现异步操作**

我们的多人服务器通过 WebSocket 进行通信，需要频繁发出 HTTP 请求。我们尝试在 Rust 中编写这些请求的处理程序，但遇到了 [Futures](https://docs.rs/futures/*/futures/) 上的人机工程学的问题（Rust 的异步编程答案）。`Futures` 的效率很高，但有时候使用起来很是复杂。

例如，将操作链接在一起是通过构造一个代表整个操作链的巨型嵌套类型来完成的。虽说这意味着该链的所有内容只需要一次分配，但是这也意味着错误消息会是很长一段，令人难以阅读的错误，让人想起 C++ 中的模板错误（[示例](https://gist.github.com/evanw/ 06a672db1897482eadfbbf37ebf9b9ec)）。再加上其他问题，例如需要在不同的错误类型之间进行调整以及必须解决复杂的生命周期问题，我们决定放弃这种方法。

*我们做了什么：* 我们没有全力以赴地使用 Rust，而是决定暂时将网络处理保留在 Node.js 中。Node.js 进程为每个文档创建一个单独的 Rust 子进程，并使用基于消息的协议通过标准输入输出与之沟通，让所有网络流量都在进程之间传递。

*如何解决：* Rust 团队正在努力[向 Rust 添加异步功能](https://github.com/rust-lang/rfcs/blob/master/text/2033-experimental-coroutines.md)，这应该通过隐藏 `Futures` 本身在语言本身之下的复杂性来解决其中的许多问题。这将允许 `?` 这个目前仅适用于同步代码的错误处理运算符也能够在异步代码中使用，减少样板操作。

### Rust 以及它的未来

即便我们在速度上遇到一些问题，我仍然希望去强调，我们与 Rust 的经历总体而言真的是非常棒的。这真是一款有着一颗坚硬的内核和健康的社区的，一款拥有着极度美好前景的语言！我对这些问题很快就会被解决很有信心～

我们的多人服务器是很少的对性能敏感的代码，组合一些很小的依赖库所构成的，因此在 Rust 中重写，即便遇到了问题，也仍然对我们来说是非常棒的。它让我们能够将服务端多人编写的性能提升一个数量级，让我们 Figma 的多人服务得以获得一个更广阔的未来！

**感谢 Figma～**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
