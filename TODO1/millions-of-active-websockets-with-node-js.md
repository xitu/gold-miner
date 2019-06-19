> * 原文地址：[Millions of active WebSockets with Node.js](https://medium.com/@alexhultman/millions-of-active-websockets-with-node-js-7dc575746a01)
> * 原文作者：[Alex Hultman](https://medium.com/@alexhultman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/millions-of-active-websockets-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/millions-of-active-websockets-with-node-js.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[portandbridge](https://github.com/portandbridge)，[sunui](https://github.com/sunui)

# 使用 Node.js 提供百万的活跃 WebSocket 连接

> 仅使用消费级笔记本和一些 Wifi 资源便可提供大量的 WebSocket 服务

通过最新发布的 TypeScript web 服务工程 [uWebSockets.js](https://github.com/uNetworking/uWebSockets.js)，我们看到它带来的不仅有提升的性能，还有提升的内存利用率。对 Node.js 使用者尤其如此，所以为了演示我想在实际使用环境中开展大规模的测试。

我们计划使用我那购买了 6 年的笔记本电脑，它具有 8GB 运行内存和 72Mbit 速率的 Wifi 网络适配器（这是网络链接速度）的笔记本电脑。它还有一个 1Gbit 速率的以太网适配器，我们可以稍后使用。所有配置都是消费级的，在 2013 年购买后没有任何硬件升级。这个笔记本将运行安装了 uWebSockets.js v15.1.0 的 Node.js。

![服务器硬件](https://cdn-images-1.medium.com/max/2000/1*rXwVs5rZXES07sHY29xrKw.jpeg)

我们首先需要做一些 Linux 系统的配置工作 —— 主要是需要通过修改文件 /etc/security/limits.conf（在你的系统上文件路径可能不同，我这里用的是 Ubuntu 18.04 版本）来提升最大打开文件数量的限制。添加如下几行：

```
* soft nofile 1024000
* hard nofile 1024000
```

然后我们需要设置一些其他变量（同样的，你的路径可能不同）：

```bash
sudo sysctl net.ipv4.tcp_tw_reuse=1
sudo sysctl fs.file-max=1024000
```

然后你需要需要配置某一网段内的大约 50 个 IP 地址。对于我的 Wifi 适配器，我添加了这行配置：

```bash
for i in {135..185}; do sudo ip addr add 192.168.0.$i/24 dev wlp3s0; done
```

理论上，每个 IP 地址有 65k 个连接限制，但是实际上限值经常大约在 20k 左右，所以我们使用多个地址且使每个地址支撑 20k 个连接数（50 * 20 千 = 1 百万）。

然后我使用命令 **sudo -i** 将 web 服务以 root 身份运行，这之后执行 **ulimit -n 1024000** 命令，接着对 **node examples/WebSocket.js**（在 uWebSockets.js 文件夹中）也这么做。

真得就是这样的。客户端侧做了类似的配置，但是显然不需要设置多个 IP 地址。客户端电脑运行一个由 [uSockets](https://github.com/uNetworking/uSockets) 编写的单线程 C 客户端。这个测试的源代码都是开源的，同时客户端的代码是位于 uWebSockets/benchmarks 文件夹的『scale_test.c』。你可能需要为你自己的运行做一些小改动。

WebSocket 连接数量需要花几分钟才能达到 100 万个，如果我们想做的改进的话可以增加每批次的连接数和使用多个线程的客户端（诸如此类），但是这与我们对服务端感兴趣的点无关。服务端运行在单个线程上并且在连接阶段或之后 CPU 占用率都很低。

![](https://cdn-images-1.medium.com/max/3840/1*-gdCkfDWjOxShtjPP8H8ng.png)

首先，让我们讨论一下 5k 个关闭的连接。uWebSockets.js 被配置为丢弃和杀死所有闲置已超过 60s 的 WebSocket 连接。『idleTimeout』就被用到了，这意味着我们需要在每 60s 就要与每 100 万个 WebSocket 连接主动发送和接收一条 WebSocket 消息。

你可以在这上面这张网络图中看到与 ping 消息相关的流量峰值。每秒最少有 16.7k 条 WebSocket 消息需要到达服务器 —— 都变少了之后我们开始关闭连接。

显然我们通过 Wifi 网络没有很好地满足这个标准。我们是丢失了一些连接，但在一个没有花哨配置的 WiFi 网络环境下仍存活 995k 个 WebSocket 连接却是很酷的事情！

![](https://cdn-images-1.medium.com/max/3840/1*Os3oBCZSt_nHOLrORmHp9g.png)

服务端的 CPU 使用率保持在 0–2% 范围，用户控空间内存使用大约为 500MB 而整体系统范围的内存使用大约为 4.7GB。CPU 使用率或者内存使用一直都没有出现服务端激增走势，它始终处于完全稳定状态。

好吧！那么让我们拿出大杀器吧 —— Ethernet。我们将服务器和客户端连接到 1Gbit 消费级路由器并重新运行测试：

![](https://cdn-images-1.medium.com/max/3840/1*1v2fewfRAR21nryDIj_I6w.png)

结果是服务运行状况稳定，而且没有连接丢失，WiFi 网络稳定性不足但是 Ethernet 却表现很好。为了保证每项都是稳定的，我让客户端和服务器持续运行了一个小时，这样没有一个连接丢失，然后有约 1.2 亿条 WebSocket 消息（16.7k * 60 * 60 * 2）：

![](https://cdn-images-1.medium.com/max/3840/1*jp2Nm_t67771fNdo4eeRYQ.png)

每项都是稳定良好运行。事实上，我在运行服务的笔记本上写着本文，并且被关闭的 socket 连接数量始终为 0，同时系统也是响应及时的。甚至我开启一个简单的游戏的情况下服务还能让连接继续。

此时我们已经实现了一个非常酷的概念验证场景。有一部分归因于稳定的 Ethernet 连接，但当然很大程度上也依赖服务端软件。任何其他的 Node.js 软件栈都无法实现这一壮举 —— 它们都不具备像这样足以在笔记本上维持这么多 WebSocket 连接的轻量级和高性能特点。你可以在系统变得无响应时停止 swap 分区交换，并且下面看到的这样来停止获取 ping 结果：

![如果我们使用另一个服务软件栈可能运行不太好，这里『websockets/ws』 发生彻底崩溃并触发了重试](https://cdn-images-1.medium.com/max/3840/1*wXez3KLeKPCEhodP5UvcGQ.png)

使用 uWebSockets.js，我们可以在这台笔记本上运行几十万个 WebSocket 连接，但是超过 100 万的常规连接则需要重新编译具备不同限制的 Linux 内核，这也是我们把它作为边界值的原因。

这里我们不打算去研究底层的嵌入式 C 开发，并且我认为这是明智的选择。只需启动一个新应用实例，一台新笔记本，通过这种方式继续扩展你的问题。

如果你对这个软件栈感兴趣，有 I/O 扩展性问题，或者想要避免陷入许多常见陷阱，一定要联系我们，我们可以通过公司对公司的形式来研讨问题。

感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
