> * 原文地址：[My experiences with API gateways…](https://medium.com/@mahesh.mahadevan/my-experiences-with-api-gateways-8a93ad17c4c4)
> * 原文作者：[Mahesh Mahadevan](https://medium.com/@mahesh.mahadevan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/my-experiences-with-api-gateways.md](https://github.com/xitu/gold-miner/blob/master/article/2020/my-experiences-with-api-gateways.md)
> * 译者：[司徒公子](https://github.com/stuchilde)
> * 校对者：[刘海东](https://github.com/lhd951220), [shixi-li](https://github.com/shixi-li)

# 记一次 —— 构建 API 网关服务的经历......

不久前，我在做一个项目，为我们的云产品实现 API 网关。它背后的主要动机是为所有外部通信和保护后端服务提供单一入口，但还有其他原因。我假设你无意中发现了这篇关于 API 网关的文章，并且已经提前具备了 API 网关相关的知识。如果不是，在深入阅读这篇文章之前，你应该阅读[这里](https://microservices.io/patterns/apigateway.html)和[这里](https://www.nginx.com/learn/api-gateway/)。

找到一个满足需求的 API 网关是[过渡选择](https://en.wikipedia.org/wiki/Overchoice)。如果你把这件事看得太重，你最终心里可能会很崩溃。就像当今业界的其他主流软件技术栈一样，即使是 API 网关也有各种选择和风格。说实话，在做决定的时候，如果没有深入研究每种可选项并将其与你的特定需求相匹配，就会遇到很大的困难。本文是我简化任务的一个小小尝试，并在最后提供了一个流程图，希望能帮助你做出决定。

当我们开始搜索时，我们开始基于我们的研究来分析这些选项。要做到这一点，我们主要依赖网络上已存在的各种比较，我们基于它们当前的流行程度和他们必须提供的特性集做一些筛选。

**免责声明** —— *这篇文章不提供任何 API 网关的性能比较，尽管这也是我们选择的标准。我并不是说这里讨论的实现是唯一的可用选项，但是，当我撰写这篇文章的时候，基于我们的产品需求，这些实现是最受欢迎的选择。*

## 需求列表......

首先，让我们快速列出对 API 网关解决方案最低期待。请注意，这不是一个详细的列表，也不一定是你正在寻找的解决方案与之相匹配的内容。但是，它应该覆盖 API 网关的大部分应用场景。

1. [反向代理](https://en.wikipedia.org/wiki/Reverse_proxy) —— 这是大多数项目采用网关解决方案的最重要原因。任何已对外开放 API 的成熟项目都应该避免由于安全问题而暴露后端的 URL，将后端的复杂服务抽象到客户端。这也能为所有客户端访问后端 API 提供唯一单点入口。
2. [负载均衡](https://www.nginx.com/resources/glossary/load-balancing/) —— 网关能将传入的单个 URL 路由到多个后端目标。在微服务体系结构中，当你想要扩展你的应用程序以获得高可用性，或者在运行某种服务集群的配置时，甚至是在其他方面，这通常非常有用。
3. 身份认证和授权 —— 网关应该能成功的实现身份认证，并且允许已信任的客户端访问 API，也能使用类似于[基于角色的访问控制](https://en.wikipedia.org/wiki/Role-based_access_control)的方式来提供授权服务。
4. IP 清单 —— 允许或者禁止某些 IP 地址通过。为你的生态提供一个额外的安全层，当你发现一组恶意地址想要通过 DDOS 来瘫痪你的应用程序的时候，这非常有用。
5. 分析 —— 提供一种方法记录日志的使用情况以及与 API 调用相关的其他有用指标。应该能分解每个客户端的 API 使用情况，以获取可能的收益。
6. 限速 —— 限制 API 调用的能力，例如，你只希望允许所有使用者每分钟调用 10000 次，或者对特定的使用者允许每个月调用 1000 次。
7. 转换 —— 在转发之前，转换请求和响应（**包括消息头和消息体**）的能力。
8. 版本控制 —— 可以选择同时使用不同版本的 API，或者以[金丝雀发布](https://martinfowler.com/bliki/CanaryRelease.html)或者[蓝绿部署](https://martinfowler.com/bliki/BlueGreenDeployment.html)的形式缓慢推出 API。
9. [断路器](https://martinfowler.com/bliki/CircuitBreaker.html) —— 对于微服务架构模式很有作用，可以避免服务中断。
10. [WebSocket](https://en.wikipedia.org/wiki/WebSocket) 支持 —— 许多动态和实时的功能都能使用 WebSocket 解决，在频繁数据交换的业务场景下，为客户端提供 WebSocket 接口，以便减少多个 HTTP 调用的开销。
11. [gRPC](https://grpc.io/) 支持 —— Google 的 gRPC 承诺通过使用 HTTP/2 进一步减少负载，这样可以有效的用于服务端之间的内部通信。我建议你一定要将此添加到你的需求列表中，以使你的解决方案更加可靠。
12. 缓存 ——  如果频繁请求的数据能被缓存，将会进一步减少网络带宽和往返时间消耗并提升性能。
13. 文档 —— 如果你计划向组织外的开发者公开你的 API，你必须考虑使用 API 文档。例如 [Swagger 或者 OpenAPI](https://swagger.io/docs/specification/about/)。

## API 网关和服务网格

在对比他们实际实现之前，我还必须谈谈在寻找网关、[服务网格](https://www.nginx.com/blog/what-is-a-service-mesh/)的时候，你可能遇到的另一种模式。首先，了解 API 网关和服务网格的区别以及它们各自的用途可能会让人感到困惑。所以在继续之前，我将会详细描述它们。

API 网关应用于 [OSI 模型](https://en.wikipedia.org/wiki/OSI_model)的第七层，或者你也可以说管理来自外部的网络流量（有时也称南北向交通）。而服务网格应用于 OSI 模型的第四层，或者说是管理服务间通信（有时也被称为东西向交通）。API 网关的一些例子包括反向代理、负载均衡、认证与授权、IP 列表和限速等。

另一方面，服务网格的工作方式类似于代理或挎斗模式，它解除了服务间的通信责任，并处理断路器、超时、重试和服务发现等问题。在本文发布的时候， [Istio](https://istio.io/zh/docs/concepts/what-is-istio/) 是服务网格众所周知的一种实现方式。

你一定已经注意到了，我的需求列表中还包括了一些服务网格提供的功能。目前，相当多的 API 网关能实现同时在 OSI 模型的第四层和第七层工作，并处理服务网格的需求。如果我们能得到一个能处理一些网格服务需求的实现，即使不是必须的，那也太好不过了。这里有一篇很好的[文章](https://dzone.com/articles/api-gateway-vs-service-mesh)，详细介绍了它们的区别。

## 比较

## 精华内容

我将对比以下 API 网关...... **（免责声明）**

1. NGINX
2. Kong
3. Tyk
4. Ambassador
5. AWS API gateway

## Nginx

[Nginx](https://www.nginx.com) 已经是七层负载均衡代理和后端应用创建单点入口的最佳选择之一了。它已经在许多不同的产品环境使用并被验证可行，并且以极低的内存使用率代替了许多已存在的负载均衡硬件，这样也为公司节省了许多的成本。许多 [CDN](https://en.wikipedia.org/wiki/Content_delivery_network) 使用 Nginx 作为引擎来缓存边缘节点的数据。

使用 Nginx 作为网关的最大优势是它具有从简单到复杂的功能，允许你选择满足你要求的功能。例如，如果你一开始仅需要负载均衡和反向代理的功能，Nginx 就可以很容易地以最小的代价完成这一任务，最终随着你产品的成熟，你可以升级到其他的功能。你也可以使用它们的商业产品 [NGINX Plus](https://www.nginx.com/blog/whats-difference-nginx-foss-nginx-plus/) 来实现完整的 API 网关服务，即使它的开源产品可以通过现有广泛的插件来实现这一点。

Nginx 以其较小的内存占用以及低延迟下的高性能而闻名。你也可以获取一些[第三方自定义 Nginx 插件](https://www.nginx.com/resources/wiki/modules/)，这些插件可以涵盖广泛的定制场景。当然，当你在某些地方遇到问题的时候，你也可以从它庞大的开发者社区网络中寻求帮助。你唯一可能遇到的问题是，Nginx 的配置可能有点难以掌握，除非你已经亲自动手实践过。否则，你不得不翻阅它文档中的一部分内容，直到你已经熟练掌握它。

## Kong

[Kong](https://konghq.com/) 是一个基于 Nginx 和 [OpenResty](https://openresty.org/cn/) 的 API 网关 + 服务网格，它满足我们以上列出的大部分需求。按照提供的 [Docker 安装说明](https://docs.konghq.com/install/docker/?_ga=2.29592831.1315225771.1553575126-343588371.1553575126) 进行安装相当容易。

Kong 的架构非常简单易懂，它是由许多组件构成......

* Kong 基本模块封装了 OpenResty 和 Nginx，是实际工作的引擎。
* 数据库层，可选择 Cassandra 或者 Postgres 来存储所有的配置数据，以便在发生故障的时候可以轻松恢复。
* 仪表盘提供用于 API 管理和查看分析的用户界面（**尽管 kong 提供了 REST API、上游 API 以及它的使用者的管理服务，但它仅提供企业级服务**）

Kong 既有开源版本也有企业版本的实现，在 nginx 的支持下，它们两者都能在毫秒级别的延迟下稳定工作。想象一下，使用 Nginx 进行网关操作，同时 REST API 和数据库层轻松管理配置。

Kong 提供了多种[插件](https://docs.konghq.com/hub/?_ga=2.135887729.1315225771.1553575126-343588371.1553575126)，这些能满足从访问控制、安全性以及缓存文档的大部分横切关注点。它也允许你使用 Lua 语言编写并使用自定义插件。Kong 的开源是了解它们堆栈的一个良好开端。尽管它没有 Web 界面仪表盘，但是有一些可用的开源仪表盘能帮助你来管理它们的配置。否则，如果你对 REST 很熟悉，你可以直接使用他们的[管理 API](https://docs.konghq.com/1.1.x/admin-api/)。

Kong 也可以部署在[Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)上，并且支持 gRPC 和 Websocket 代理。Kong 的优势是他的底层引擎，它由轻量级但是强大的 Nginx 和 OpenResty 引擎组成，它本身也可以构建成一个成熟的 API 网关，你可以把 Kong 想象成 Nginx 的自动切换版本。这种实现有一个可能的缺点，并不是所有的功能都是开箱即用的，有些必须要激活其各自的插件来手动配置，这可能需要初始设置时间和资源，但是对于许多成熟工程师的团队来说，这可能并不是一个很大的阻碍。

## Tyk

[Tyk](https://tyk.io/) 是另一个承诺具有出色性能的开源网关，它是由 Go 编写的。Tyk 提供多种特性，这些特性是我们需求列表的一部分。Tyk 的 web 仪表盘是同类中最好的，允许你控制几乎 API 配置的方方面面，并提供出色的 API 使用分析。

Tyk 拥有丰富的特性集和漂亮的 Web 用户界面，它对于拥有复杂 API 管理方案的项目来说是一个不错的选择。Tyk 的出色之处在于，它包括 API 仪表盘、分析、安全、版本控制、开发者门户、限速和其他开箱即用的网关特性，你可以免费将其使用在非商业场景下。但是，如果用于商业目的，你就需要购买它们的商业许可证，其中也包括它们的支持。

Tyk 真的很适合那些从第一天开始就寻找开箱即用并准备为其付费的项目（**例如，你打算将其用于商业目的**），而不是去探索像 Nginx 和 Kong 这样的选项，这可能会花费你的开发人员一些时间来获取所有必须的功能。与前两个实现相比，Tyk 的不足之处在于易于安装和成本。Tyk 有太多的组件，这些组件不便于在本地安装和管理。它提供云和混合安装选项，这能减少安装和管理的成本。但它也有自己的定价，它会增加你项目的支出。

## Ambassador

[Ambassador](https://www.getambassador.io/) 是建立在 [Envoy](https://www.envoyproxy.io/) 之上的开源 Kubernetes 本地微服务网关。它可以用做 Kubernetes 入口器和负载均衡器，可以在 Kubernetes 环境上轻松快速的发布和测试微服务。

Ambassador 非常轻量级，所有状态都存储在 Kubernetes 中，因此不需要数据库。Ambassador 的构建是以开发者为核心的，所以，它所有的操作和概念都是以开发者为核心的，例如 —— 在 Ambassador 中添加一个路由，最推荐的方法是在 Kubernetes 服务的 yaml 配置文件中添加注释。它的免费版本包括版本控制、gRPC、WebSocket 支持、身份认证、限速、与 Istio 集成来像服务网格一样工作，然而，OAuth、单点登录、JWT 认证、访问控制策略以及过滤等功能是其付费版本 [Ambassador Pro](https://www.getambassador.io/pro/)的一部分。

它的优势是在 Kubernetes 环境上以低占用空间和最低初始化配置服务为大流量提供服务。然而，它缺乏的是跟之前讨论的网关相比功能不够丰富的问题。因为，它缺少开箱即用的仪表盘和分析的集成，这需要一些设置。

## Amazon API 网关

[Amazon API 网关](https://aws.amazon.com/api-gateway/)是 AWS 提供的托管 API 管理云服务，只需要点击几下，就可以轻松创建、发布和管理 API。你可以公开 REST 或者 WebSocket 节点，使用 Swagger 或者 Open API 导入新的 API，将你的 URL 路由到各种后端，包括 AWS EC2、AWS lambda 甚至是内部节点。通过网关路由上百万个 API 的成本非常小，并且可以预测。因为，对于给定请求数量的场景下是有固定的[定价模型](https://aws.amazon.com/api-gateway/pricing/)可以参考的（**因此，你应该要小心由于外部数据传输带来的成本**）。

AWS API 网关不需要设置，因为它是被管理的，你只需要轻轻点几下就能快速创建或者路由 API，使用 SSL 保护它们，提供身份验证和授权，为 API 的外部客户端创建 API 密钥，管理你的 API 版本，如果你愿意，它还可以生成客户端 SDK。AWS API 网关的服务真的很强大，只需要几分钟就可以轻松设置好一个 API 网关服务。因此，如果你已经使用 AWS 或者计划准备使用 AWS，那么你需要认真考虑将此网关作为首选，除非你有一些强制性的功能，它还无法满足。很明显的一个缺点就是你可能会被 AWS 的服务所束缚，这些依赖关系可能会在未来的某个时刻，使得你向其他框架迁移的难度大大增加。

## 比较矩阵

下面以表格的形式总结了 5 种 API 网关特性的比较。

* 绿色标记：特性中有一部分是开源版本
* 黄色标记：特性仅支持付费版本
* 红叉：特性**尚不**存在（**访问各自的门户网站以获取支持特性集**）

![Comparison matrix](https://blog-private.oss-cn-shanghai.aliyuncs.com/20200609203950.png)

1. 基础特性包括反向代理和负载均衡
2. Tyk 提供了非商业用途的开发者许可证，其中包括所有的特性，对于生产的使用，你需要购买他们的商业许可证，这样就能够以 Saas 或者混合的方式安装。
3. Kong 的开源版本没有仪表盘，但是有一些可用的[第三方开源仪表盘](https://github.com/pantsel/konga)提供 Web 界面来管理你的 API 和插件。
4. [Ambassador](https://www.getambassador.io/user-guide/with-istio/) 可以和 Istio 一起安装来扮演服务网格的角色。

## 决定时刻

最后，这是一张流程图，我故意将其简化。你应该使用以下图表以及上述特性矩阵来简化你的选择。

![](https://blog-private.oss-cn-shanghai.aliyuncs.com/20200609203959.jpeg)

## 值得一提的实现

* [Apigee](https://docs.apigee.com/)
* [WSO2](https://wso2.com/)
* [Zuul](https://github.com/Netflix/zuul)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
