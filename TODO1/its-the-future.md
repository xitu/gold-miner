> * 原文地址：[It's The Future](https://circleci.com/blog/its-the-future/)
> * 原文作者：[CircleCI](https://circleci.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/its-the-future.md](https://github.com/xitu/gold-miner/blob/master/TODO1/its-the-future.md)
> * 译者：[Hopsken](https://hopsken.com)
> * 校对者：[jasonxia23](https://github.com/jasonxia23) [Starrier](https://github.com/Starrier)

# Web 应用的未来：Heroku vs Docker

![](https://d3r49iyjzglexf.cloudfront.net/blog/content/rabbit_hole-001c07c5072ff2970876cbc92caedfc5803e0ea4b9c65cff2f35f83ceedc0b8f.jpg)

嗨，我老板让我跟你谈谈，听说你很懂 web 应用？

> 嗯，我对分布式系统确实挺了解的。我刚从 ContainerCamp 和 Gluecon 回来，下星期我还打算去参加 Dockercon。这个行业的发展方向令人兴奋，让所有事情都变得更简单，也更可靠。这就是未来！

666。我最近在做一个简单的 web 应用 —— 一个普通的基于 Rails 的 CRUD（译者注：增删查改）应用，准备搭建在 Heroku 上面。现在还是这么做吗？

> 不不不，这已经是老掉牙的做法了。Heroku 已死，没人再用这玩意儿了。现在你得用 Docker，这才是大势所趋。

额，好吧。不过，那是啥？

> Docker 是实现容器化的新方案。它跟 LXC 差不多，不过它也是一种打包格式，一种分发平台，以及一套可以方便地构建分布式系统的工具。

哈？啥容器？LXE 又是啥？

> 是 LXC。它就像 chroot on steroids！

cher-oot 又是啥？

> 行吧。听着，Docker、容器化，这就是未来。跟虚拟化很类似，但是更快，也更经济。

哦，懂了，所以就跟 Vagrant 差不多咯？

> 不不不，Vagrant 已死。未来是容器化的天下。

好吧，所以现在我没必要去了解的虚拟化了对吧？

> 不，你还得用到虚拟化，因为容器目前还不能提供完整的安全层级。所以，如果你希望程序运行在多用户环境中，你得确保你不能跳出沙盒。

额，等等，我有点跟不上了。我们来捋一捋，也就是说，有这么个东西，叫做容器，和虚拟化很像。而且我可以在 Heroku 上使用它？

> 这么说吧，Heroku 确实在某种程度上支持 Docker，但是我刚说了：Heroku 已死。你应该把容器运行在 CoreOS 上面。

好吧，那是啥？

> 那是个宿主操作系统，可以跟 Docker 结合使用。讲道理，你甚至不需要用 Docker，你可以用 rkt。

啥啥？Rocket？

> 不，是 rkt。

没错啊，Rocket。

> 不，我说的是 rkt。这完全是两码事。它是另一种容器化格式，没有 Docker 那么高的集成度，但也因此拥有更高的组件化程度。

所以这是件好事？

> 这当然是件好事，组件化就是未来。

好的吧，那要怎么用它？

> 不知道，我不认为有人在用这玩意。

行吧。你之前有提到 CoreOS？

> 哦，对，这是一个可以跟 Docker 搭配使用的宿主操作系统。

宿主操作系统是啥？

> 一个宿主操作系统可以运行你所有的容器。

运行我的容器？

> 没错，你总得把你的容器运行在某个东西上吧。这么说吧，先配置好一个实例，比方说 EC2，装好 CoreOS，然后运行 Docker 后台程序，再然后你就可以把 Docker 镜像部署上去了。

所以这里面哪一步是所谓的容器？

> 全部都是。这么说吧，你先准备好你的应用，写一个 Dockerfile，在本地把它们转成一个镜像，然后你就可以把它们推送到任何 Docker 主机上去了。

额，比方说，Heroku？

> 不对，不是 Heroku。我都跟你说了，Heroku 已死。现在，借助 Docker，你可以运行你自己云服务了。

哈？

> 没错，很容易做到。你查一下 #gifee 就知道了。

啥？Gify？

>「Google’s infrastructure for everyone else.」你只需要取一些已有的工具和技术栈，借助容器技术，然后你就可以拥有和 Google 一样的架构了。

那我为啥不能直接使用 Google 的呢？

> 你认为半年内会出现吗？

好吧，那么还有其他提供此类托管服务的厂商吗？我实在是不想自己托管。

> 呃，Amazon 有提供 ECS 服务，但是你得去写一些 XML 或者其它乱七八糟的玩意。

那 OpenStack 呢？

> 呵呵。

啊？

> 呵呵。

讲真，我真心不想自己来托管服务。

> 别啊，这真的很简单。你只需要配置一个 Kubernetes 集群。

我还需要一个集群？

> Kubernetes 集群。它会负责管理你所有服务的部署工作。

我只有一个服务。

> 你说啥呢？只有一个应用是没错，但是至少得有 8-12 个服务吧？

哈？不不，就一个应用。呃，服务...反正不管怎么说，就一个。

> 不不不，你再想想微服务。对吧，这才是未来。现在大家都这么干。先拿到一个大型的应用，然后把它分成大约 12 个左右的服务，每一个都只负责一部分工作。

这也太多了。

> 这是确保可用性的唯一方法。这样当你的认证服务下线的时候...

认证服务？我只是打算用我之前用过的 gem 而已。

> 没错。使用那个 gem，把它放到它本身的项目中，再给它写一个 RESTful API。这样你的其它服务就可以调用那个 API，从而优雅地处理错误和事务。把它放到一个容器中，然后持续交付它们。

行吧，那么既然我已经有了十多个没有被管理的服务，现在该怎么办？

> 我刚提到了 Kubernetes，对吧。它允许你将你所有的服务协同到一起。

协同起来？

> 没错。现在你已经有了若干服务，并且它们得保持可用性，所以你需要多拷贝几份服务出来。Kubernetes 可以确保你有足够多的相同服务，把它们分布到位于服务器群上的多个主机上，这样，这些服务就可以一直都能被访问啦。

我现在又需要一个服务器群了？

> 没错，为了可靠性。但是 Kubernetes 可以替你管好这些。而且，你知道，Kubernetes 肯定是有用的，因为是 Google 打造了它，并且它是运行在 etcd 上的。

etcd 是啥？

> 它是 RAFT 的一种实现。

好吧，那么问题来了，RAFT 又是啥？

> 类似于 Paxos。

天啦噜，我们究竟要在这条路上走多远啊？我只是想运行一个应用而已啊。哎，奶奶个腿的，OK，冷静，深呼吸。苍天呐。行吧，Paxos 又是啥？

> Paxos 算是个 70 年代就提出的古老的分布式协议，但是没人真正理解，也没人去用。

太好了，谢谢你告诉我这些。所以 Raft 是啥？

> 既然没人能理解 Paxos，有个叫做 Diego 的人...

哦，你认识他？

> 没，他在 CoreOS 工作。总之，Diego 为了他的博士论文打造了 Raft，因为 Paxos 实在是太难了。聪明的家伙。然后他实现了 Raft，写出了 etcd。再然后，Aphyr 说这玩意还不赖。

Aphyr 是谁？

> Aphyr 就是那个写了『Call Me Maybe』的人。就是那个分布式系统和 BDSM 的？

哈？你刚是不是说了『BDSM』？

> 没错，BDSM。这可是旧金山，所有人都懂分布式系统和 BDSM。

好的吧。所以是他写了 Katy Parry 的那首歌？

> 没，他写了一系列博客解释为什么所有的数据库都不符合 CAP。

CAP 是啥？

> 就是 CAP 定理。定理说，在连贯性、可访问性和可分割性这三个中你只能保证其中两个。

行吧。所以说，所有的数据库都不符合 CAP 定理？那是什么意思？

> 这意味，它们都是垃圾。比方说 Mongo。

我原以为 Mongo 是 web 层面上的？

> 没人这么认为。

好吧，所以 etcd 是啥？

> etcd 是一种分布式的键值对仓库。

哦，就像 Redis。

> 不，一点都不像。etcd 是分布式的，而一旦网络被断开，Redis 就丧失了一半的写入能力。

好吧，所以这是个**分布式**的键值对仓库。这有啥用？

> Kubernetes 具有一个标准的 5 节点的集群，使用 etcd 作为消息总线。它会整合 Kubernetes 自带一些服务来提供非常具有弹性的协同系统。

5 个节点？我只有一个应用啊。这样我需要多少设备啊？

> 这样，你大约要有 12 个服务，当然对于每一个你还需要一些冗余服务作为拷贝，一些用于负载均衡，一些 etcd 集群，数据库，还有 Kubernetes 集群，这些加起来差不多要 50 个容器。

什么！

> 这没什么！容器是非常高效的，所以你应该可以把它们分布到 8 台设备上！是不是很厉害？

话是这么说。所以有了这些，我就可以部署我的应用了？

> 当然。我是说，对于 Docker 和 Kubernetes，仍然存在一个开放性的存储问题。关于网络通信也需要花些功夫，不过差不多就是这样了。

我懂了。我想我理解你的意思了。

> 棒极了！

谢谢你解释这么多。

> 不用谢。

让我回顾一遍，看看我理解的对不对。

> 没问题！

所以，我只需要把我这个简单的 CRUD 应用划分成 12 个微服务，每一个都有它们独立的 API，这些 API 互相之间可以调用，且可以弹性地处理问题，把它们整合到 Docker 容器中，启动一个拥有 8 个运行着 CoreOS 的设备集群作为 Docker 主机，使用运行着 etcd 的一个小 Kubernetes 集群来协同管理它们，解决好网络和存储这些『开放性』问题，最后把每个微服务的多份冗余拷贝持续交付到我的服务器集群上。是这样吧？

> 对！是不是酷炫？

我还是滚回去用 Heroku 吧。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
