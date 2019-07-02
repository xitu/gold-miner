> * 原文地址：[Courier: Dropbox migration to gRPC](https://blogs.dropbox.com/tech/2019/01/courier-dropbox-migration-to-grpc/)
> * 原文作者：[blogs.dropbox.com](https://blogs.dropbox.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/courier-dropbox-migration-to-grpc.md](https://github.com/xitu/gold-miner/blob/master/TODO1/courier-dropbox-migration-to-grpc.md)
> * 译者：[kasheemlew](https://github.com/kasheemlew)
> * 校对者：[shixi-li](https://github.com/shixi-li)

# Courier: Dropbox 的 gRPC 迁移利器

![](https://dropboxtechblog.files.wordpress.com/2019/01/01-screenshot2018-12-0516.35.14-black.png?w=650&h=352)

Dropbox 运行着几百个服务，它们由不同的语言编写，每秒会交换几百万个请求。在我们面向服务架构的中心就是 Courier，它是我们基于 gRPC 的远过程调用（RPC）框架。在开发 Courier 的过程中，我们学到了很多扩展 RPC 并优化性能和衔接原有 RPC 系统的东西。

**注释：本文只展示了 Python 和 Go 生成代码的例子。我们也支持 Rust 和 Java。**

## The road to gRPC

Courier 不是 Dropbox 的第一个 RPC 框架。在我们正式开始将庞大的的 Python 程序拆成多个服务之前，我们就认识到服务之间的通信需要有牢固的基础，所以选择一个高可靠性的 RPC 框架就显得尤其关键。

开始之前，Dropbox 调研了多个 RPC 框架。首先，我们从传统的手动序列化和反序列化的协议着手，比如我们用 [Apache Thrift](https://github.com/apache/thrift) 搭建的[基于 Scribe 的日志管道](https://blogs.dropbox.com/tech/2015/05/how-to-write-a-better-scribe/)之类的服务。但我们主要的 RPC 框架（传统的 RPC）是基于 HTTP/1.1 协议并使用 protobuf 编码消息。

我们的新框架有几个候选项。我们可以升级遗留的 RPC 框架使其兼容 Swagger（现在叫 [OpenAPI](https://github.com/OAI/OpenAPI-Specification)），或者[建立新标准](https://xkcd.com/927/)，也可以考虑在 Thrift 和 gRPC 的基础上开发。

我们最终选择 gRPC 主要是因为它允许我们沿用 protobuf。对于我们的情况，多路 HTTP/2 传输和双向流也很有吸引力。

> 如果那时候有 [fbthrift](https://github.com/facebook/fbthrift) 的话，我们也许会仔细瞧瞧基于 Thrift 的解决方案。

## Courier 给 gRPC 带来了什么

Courier 不是一个新的 RPC 协议 —— 它只是 Dropbox 用来兼容 gRPC 和原有基础设施的解决方案。例如，只有使用指定版本的验证、授权和服务发现时它才能工作。它还必须兼容我们的统计、事件日志和追踪工具。满足所有这些条件才是我们所说的 Courier。

> 尽管我们支持在一些特殊情况下使用 [Bandaid](https://blogs.dropbox.com/tech/2018/03/meet-bandaid-the-dropbox-service-proxy/) 作为 gRPC 代理，但为了减小 RPC 的延迟，大多数服务间的通信并不使用代理。

我们想减少需要编写的样板文件的数量。作为我们服务开发的通用框架，Courier 拥有所有服务需要的特性。大多数特性都是默认开启的，并且可以通过命令行参数进行控制。有些还可以使用特性标识动态开启。

### 安全性：服务身份和 TLS 相互认证

Courier 实现了我们的标准服务身份机制。我们的服务器和客户端都有各自的 TLS 证书，这些证书由我们内部的权威机构颁发。每个服务器和客户端还有一个使用这个证书加密的身份，用于他们之间的双向验证。

> 我们在 TLS 侧控制通信的两端，并强制进行一些默认的限制。内部的 RPC 通信都强制使用 [PFS](https://scotthelme.co.uk/perfect-forward-secrecy/) 加密。TLS 的版本固定为 1.2+。我们还限制使用对称/非对称算法的安全的子集进行加密，这里比较倾向于使用 `ECDHE-ECDSA-AES128-GCM-SHA256`。

完成身份认证和请求的解码之后，服务器会对客户端进行权限验证。在服务层和独立的方法中都可以设置访问控制表(ACL) 和限制速率，也可以使用我们的分布式配置系统（AFS）进行更新。这样就算服务管理者不重启进程，也能在几秒之内完成分流。订阅通知和更新配置由 Courier 框架完成。

> 服务 “身份” 是用于 ACL、速率限制、统计等的全局标识符。另外，它也是加密安全的。

我们的[光学字符识别（OCR）](https://blogs.dropbox.com/tech/2018/10/using-machine-learning-to-index-text-from-billions-of-images/)服务中有这样一个 Courier ACL/速率限制配置定义的例子：

```
limits:
  dropbox_engine_ocr:
    # 所有的 RPC 方法。
    default:
      max_concurrency: 32
      queue_timeout_ms: 1000

      rate_acls:
        # OCR 客户端无限制。
        ocr: -1
        # 没有其他人与我们通信。
        authenticated: 0
        unauthenticated: 0
```

![](https://dropboxtechblog.files.wordpress.com/2019/01/02-screenshot2018-12-0317.31.03.png?w=650&h=358)

> 我们在考虑使用[每个人都该用的安全生产标识框架](https://spiffe.io/) (SPIFFE)中的 SPIFFE 可验证标识证件。这将使我们的 RPC 框架与众多开源项目兼容。

### 可观察性：统计和追踪

有了标识，我们很容易就能定位到对应 Courier 服务的标准日志、统计、记录等有用的信息。

![](https://dropboxtechblog.files.wordpress.com/2019/01/03-screenshot2018-12-0518.03.17.png?w=650&h=249)

我们的代码生成给客户端和服务端的每个服务和方法都添加了统计。服务端的统计数据按客户端的标识符分类。每个 Courier 服务的负载、错误和延迟都进行了细粒度的归因，由此实现了开箱即用。

![](https://dropboxtechblog.files.wordpress.com/2019/01/gw1uztwk.png?w=650&h=379)

Courier 的统计包括客户端的可用性、延迟和服务端请求率和队列大小。还有各请求延迟直方图、各客户端 TLS 握手等各种分类。

> 拥有自己的代码生成的一个好处是我们可以静态地初始化这些数据结构，包括直方图和追踪范围。这减小了性能的影响。

![](https://dropboxtechblog.files.wordpress.com/2019/01/05-screenshot2018-12-0516.44.06.png?w=650&h=271)

我们传统的 RPC 在 API 边界只传送 `request_id`，因此可以从不同的服务中加入日志。在 Courier 中，我们采用了基于 [OpenTracing](https://opentracing.io/) 规范的一个子集的 API。在客户端，我们编写了自己的库；在服务端，我们基于 Cassandra 和 [Jaeger](https://github.com/jaegertracing/jaeger) 进行开发。关于如何优化这个追踪系统的性能，我们有必要用一片专门的文章来讲解。

![](https://dropboxtechblog.files.wordpress.com/2019/01/06-screenshot2018-12-0516.35.14.png?w=650&h=352)

追踪让我们可以生成一个运行时服务的依赖图，用于帮助工程师理解一个服务所有的传递依赖，也可以在完成部署后用于检查和避免不必要的依赖。

### 可靠性：截止期限和断路限制

Courier 集中管理所有的客户端的基于特定语言实现的功能，例如超时。随着时间的推移，我们还在这一层加入了像检视的任务项之类的功能。

**截止期限**

每个 [gRPC](https://grpc.io/blog/deadlines) [请求都包含一个](https://grpc.io/blog/deadlines) [截止期限](https://grpc.io/blog/deadlines)，用来表示客户端等待回复的时长。由于 Courier 自动传送全部已知的元数据，截止期限会一只存在于请求中，甚至跨越 API 边界。在进程中，截止期限被转换成了特定的表示。例如在 Go 中会使用 `WithDeadline` 方法的返回结构 `context.Context` 进行表示。

在实践过程中，我们要求工程师们在服务的定义中制定截止期限，从而使所有的类都是可靠的。

> 这个上下文甚至可以被传送到 RPC 层之外！例如，我们传统的 MySQL ORM 将 RPC 的上下文和截止期限序列化，放入 SQL 查询的注释中，我们的 SQLProxy 就可以解析这些评论，并在超过截止期限后 `杀死` 这些查询 。附带的好处是我们在调试数据库查询的时候能够找到每个请求的原因。

**断路限制**

另一个常见的问题是传统的 RPC 客户端需要在重试时实现自定义指数补偿和抖动。

在 Courier 中，我们希望用一种更通用的方法解决断路限制的问题，于是在监听器和工作池之间采用了一个 LIFO 队列。

![](https://dropboxtechblog.files.wordpress.com/2019/01/07-screenshot2018-12-0521.54.58.png?w=650&h=342)

在服务过载的时候，这个 LIFO 队列就会像一个自动断路器一样工作。这个队列不仅有大小的限制，还有更严格的**时间限制**。一个请求只能在该队列中存在指定的时间。

> LIFO 在对请求排序时有缺陷。如果想维持顺序，你可以试试 [CoDel](https://queue.acm.org/detail.cfm?id=2209336)。它也有断路限制的功能，且不会打乱请求的顺序

![](https://dropboxtechblog.files.wordpress.com/2019/01/08-screenshot2018-12-0521.54.48.png?w=650&h=342)

### 自省：调试端点

调试端点尽管不是 Courier 本身的一部分，但在 Dropbox 中得到了广泛的使用。它们太有用了，我不能不提！这里有些有用的自省的例子。

> 为了安全考虑，你可能想将这些暴露到一个单独的端口（也许只是一个回环接口）甚至是一个 Unix 套接字（可以用 Unix 文件系统进行控制。）你也一定要考虑使用双向 TLS 验证，要求开发者在访问调试端点时提供他们的证书（特别是非只读的那些。）

**运行时**

能在看到运行时的状态是非常有用的。例如 [堆和 CPU 文件可以暴露为 HTTP 或 gRPC 端点](https://golang.org/pkg/net/http/pprof/)。

> 我们打算在灰度验证的阶段用这个方法自动化新旧版本代码间的对比。

这些调试端点允许在修改运行时的状态，例如，一个用 golang 开发的服务可以动态设置 [GCPercent](https://golang.org/pkg/runtime/debug/#SetGCPercent)。

**库**

动态导出某些特定库的数据作为 RPC 端点对于库的作者来说很有用。[malloc 库转储内部状态](http://jemalloc.net/jemalloc.3.html#malloc_stats_print_opts)就是个很好的例子。

**RPC**  
考虑到对加密的和二进制编码的协议进行故障诊断有点复杂，因此应该在性能允许的情况下向 RPC 层加入尽可能多的工具。最近有个这样的自省 API 的例子，就是 [gRPC 的 channelz 提案](https://github.com/grpc/proposal/blob/master/A14-channelz.md)。

**应用**

查看 API 级别的参数也很有用。将构建/原地址散列、命令行等用于通用应用信息端点就是很好的例子。编排系统可以通过这些信息验证服务部署的一致性。

## 性能优化

在扩展 Dropbox 的 gRPC 规模的时候，我们发现了很多性能瓶颈。

### TLS 握手开销

由于服务要处理大量的连接，累积起来的 TLS 握手开销是不可忽视的。在大规模服务重启时这一点尤其突出。

为了提升签约操作的性能，我们将 RSA 2048 密钥对换成了 ECDSA P-256。下面是 BoringSSL 性能的例子（尽管 RSA 比签名验证还是要快一些）：

RSA:

```
𝛌 ~/c0d3/boringssl bazel run -- //:bssl speed -filter 'RSA 2048'
Did ... RSA 2048 signing operations in ..............  (1527.9 ops/sec)
Did ... RSA 2048 verify (same key) operations in .... (37066.4 ops/sec)
Did ... RSA 2048 verify (fresh key) operations in ... (25887.6 ops/sec)
```

ECDSA:

```
𝛌 ~/c0d3/boringssl bazel run -- //:bssl speed -filter 'ECDSA P-256'
Did ... ECDSA P-256 signing operations in ... (40410.9 ops/sec)
Did ... ECDSA P-256 verify operations in .... (17037.5 ops/sec)
```

> 从性能上说，RSA 2048 验证比 ECDSA P-256 大约快了 3 倍，因此你可以考虑用 RSA 作为根/叶的证书。但是从安全方面考虑，切换安全原语可能有些困难，况且这样会带来最小的安全属性。
> 同样考虑性能因素，你在使用 RSA 4096（或更高）证书之前应该三思。

我们还发现 TLS 库（以及编译标识）在性能和安全方面有很大的影响。例如，下面比较了相同硬件环境下 MacOS X Mojave 的 LibreSSL 构建和 homebrewed OpenSSL：

LibreSSL 2.6.4:

```
𝛌 ~ openssl speed rsa2048
LibreSSL 2.6.4
...
                  sign    verify    sign/s verify/s
rsa 2048 bits 0.032491s 0.001505s     30.8    664.3
```

OpenSSL 1.1.1a:

```
𝛌 ~ openssl speed rsa2048
OpenSSL 1.1.1a  20 Nov 2018
...
                  sign    verify    sign/s verify/s
rsa 2048 bits 0.000992s 0.000029s   1208.0  34454.8
```

但是最快的方法就是不使用 TLS 握手！为了支持会话恢复，[我们修改了 gRPC-core 和 gRPC-python](https://github.com/grpc/grpc/issues/14425)，降低了服务启动时的 CPU 占用。

### 加密开销并不高

人们有个普遍的误解，认为加密开销很高。事实上，对称加密在现代硬件上相当快。桌面级的处理器使用单核就能以 40Gbps 的速率进行加密和验证。

```
𝛌 ~/c0d3/boringssl bazel run -- //:bssl speed -filter 'AES'
Did ... AES-128-GCM (8192 bytes) seal operations in ... 4534.4 MB/s
```

尽管如此，我们最终还是要使 gRPC 适配我们的 [50Gb/s 储存箱](https://blogs.dropbox.com/tech/2018/06/extending-magic-pocket-innovation-with-the-first-petabyte-scale-smr-drive-deployment/)。我们了解到，当加密速度可以和内存拷贝速度相提并论的时候，降低 `memcpy` 操作的次数至关重要。此外，我们[对 gRPC 本身也做了修改](https://github.com/grpc/grpc/issues/14058)

> 验证和加密协议有一些很棘手的问题。例如，处理器、DMA 和 网络数据损坏。即便你不用 gRPC，使用 TLS 进行内部通信也是个好主意。

### 高时延带宽积链接

Dropbox 拥有 [大量通过骨干网络连接的数据中心](https://blogs.dropbox.com/tech/2017/09/infrastructure-update-evolution-of-the-dropbox-backbone-network/)。有时候不同区域的节点可能需要使用 RPC 进行通信，例如为了复制。使用 TCP 的内核是为了限制指定连接（限制在 `/proc/sys/net/ipv4/tcp_{r,w}mem`）的传输中数据的数量。由于 gRPC 是基于 HTTP/2 的，在 TCP 之上还有其特有的流控制。[BDP 的上限硬编码于](https://github.com/grpc/grpc-go/issues/2400) [grpc-go 为 16Mb](https://github.com/grpc/grpc-go/issues/2400)，这可能会成为单一的高 BDP 连接的瓶颈。

### Golang 的 net.Server 和 grpc.Server 对比

在我们的 Go 代码中，我们起初支持 HTTP/1.1 和 gRPC 使用相同的 [net.Server](https://golang.org/pkg/net/http/#Server)。这从逻辑上讲得通，但是在性能上表现不佳。将 HTTP/1.1 和 gRPC 拆分到不同的路径、用不同的服务器管理并且将 gRPC 换成 [grpc.Server](https://godoc.org/google.golang.org/grpc#Server) 大大改进了 Courier 服务的吞吐量和内存占用。

### golang/protobuf 和 gogo/protobuf 对比

如果你使用 gRPC 的话，编组和解组开销会很大。对于我们的 Go 代码，我们使用了 [gogo/protobuf](https://github.com/gogo/protobuf)，它显著降低了对我们最忙碌的 Courier 服务器的 CPU 使用。

> 同样的，[使用 gogo/protobuf 也有一些注意事项](https://jbrandhorst.com/post/gogoproto/)，但坚持使用一个正常的功能子集的话应该没问题。

## 实现细节

从这里开始，我们将会深挖 Courier 的内部，看看不同语言下的 protobuf 模式和存根的例子。下面所有的例子都会用我们的 `Test` 服务（我们在 Courier 中用这个进行集成测试）

### 服务描述

```
service Test {
    option (rpc_core.service_default_deadline_ms) = 1000;

    rpc UnaryUnary(TestRequest) returns (TestResponse) {
        option (rpc_core.method_default_deadline_ms) = 5000;
    }

    rpc UnaryStream(TestRequest) returns (stream TestResponse) {
        option (rpc_core.method_no_deadline) = true;
    }
    ...
}
```

在可用性章节，我们提到了所有的 Courier 方法都必须拥有截止期限。通过下面的 protobuf 选项可以对整个服务进行设置。

```
option (rpc_core.service_default_deadline_ms) = 1000;
```

也可以对每个方法单独设置截止期限，并覆盖服务范围的设置（如果存在的话）。

```
option (rpc_core.method_default_deadline_ms) = 5000;
```

在极少情况下，截止期限确实没用（例如监视资源的方法），这时便允许开发者显式禁用它：

```
option (rpc_core.method_no_deadline) = true;
```

真正的服务定义将会有详细的 API 文档，甚至会有使用的例子。

### 存根生成

Courier 不依赖拦截器（Java 除外，它的拦截器 API 已经足够强大了），它会生成特有的存根，这让我们用起来很灵活。我们来比较下下我们的存根和 Golang 默认的存根。

这是默认的 gRPC 服务器存根：

```
func _Test_UnaryUnary_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
        in := new(TestRequest)
        if err := dec(in); err != nil {
                return nil, err
        }
        if interceptor == nil {
                return srv.(TestServer).UnaryUnary(ctx, in)
        }
        info := &grpc.UnaryServerInfo{
                Server:     srv,
                FullMethod: "/test.Test/UnaryUnary",
        }
        handler := func(ctx context.Context, req interface{}) (interface{}, error) {
                return srv.(TestServer).UnaryUnary(ctx, req.(*TestRequest))
        }
        return interceptor(ctx, in, info, handler)
}
```

这里所有的处理过程都在一行内完成：解码 protobuf、运行拦截器、调用 `UnaryUnary` 处理器。

我们再看看 Courier 的存根：

```
func _Test_UnaryUnary_dbxHandler(
        srv interface{},
        ctx context.Context,
        dec func(interface{}) error,
        interceptor grpc.UnaryServerInterceptor) (
        interface{},
        error) {

        defer processor.PanicHandler()

        impl := srv.(*dbxTestServerImpl)
        metadata := impl.testUnaryUnaryMetadata

        ctx = metadata.SetupContext(ctx)
        clientId = client_info.ClientId(ctx)
        stats := metadata.StatsMap.GetOrCreatePerClientStats(clientId)
        stats.TotalCount.Inc()

        req := &processor.UnaryUnaryRequest{
                Srv:            srv,
                Ctx:            ctx,
                Dec:            dec,
                Interceptor:    interceptor,
                RpcStats:       stats,
                Metadata:       metadata,
                FullMethodPath: "/test.Test/UnaryUnary",
                Req:            &test.TestRequest{},
                Handler:        impl._UnaryUnary_internalHandler,
                ClientId:       clientId,
                EnqueueTime:    time.Now(),
        }

        metadata.WorkPool.Process(req).Wait()
        return req.Resp, req.Err
}
```

这里代码有点多，我们一行一行来看。

首先，我们推迟用于错误收集的应急处理器。这样就可以将未捕获的异常发送到集中的位置，用于后面的聚合和报告：

```
defer processor.PanicHandler()
```

> 设置自定义应急处理器的另一个原因是为了保证我们在出错时终止应用。默认 golang/net HTTP 处理器的行为是忽略这些错误并继续处理新的请求（这有崩溃和状态不一致的风险）

然后我们使用覆盖请求元数据中的值的方式传递上下文：

```
ctx = metadata.SetupContext(ctx)
clientId = client_info.ClientId(ctx)
```

我们还在服务端给每个客户端添加了统计，用于更细粒度的归因：

```
stats := metadata.StatsMap.GetOrCreatePerClientStats(clientId)
```

> 这在运行时给每个客户端（就是每个 TLS 身份）动态添加了统计。每个服务的每个方法也会有统计，并且由于存根生成器在生成代码的时候拥有所有方法的权限，我们可以静态添加，以避免运行时的开销。

然后我们创建请求结构，将它传入工作池，等待完成。

    req := &processor.UnaryUnaryRequest{
            Srv:            srv,
            Ctx:            ctx,
            Dec:            dec,
            Interceptor:    interceptor,
            RpcStats:       stats,
            Metadata:       metadata,
            ...
    }
    metadata.WorkPool.Process(req).Wait()
    

请注意，现在所有的工作都还没完成：没有解码 protobuf，没有执行拦截器等等。在工作池中使用 ACL，优先化和速率限制都在这些之前发生。

> 注意，[golang gRPC 库支持](https://godoc.org/google.golang.org/grpc/tap)[这个](https://godoc.org/google.golang.org/grpc/tap) [Tap 接口](https://godoc.org/google.golang.org/grpc/tap)，这使得初期的请求拦截成为可能，同时给构建高效低耗的速率控制器提供了基础。

### 特定应用的错误代码

我们的存根生成器允许开发者通过自定义选项定义特定应用的错误代码

```
enum ErrorCode {
  option (rpc_core.rpc_error) = true;

  UNKNOWN = 0;
  NOT_FOUND = 1 [(rpc_core.grpc_code)="NOT_FOUND"];
  ALREADY_EXISTS = 2 [(rpc_core.grpc_code)="ALREADY_EXISTS"];
  ...
  STALE_READ = 7 [(rpc_core.grpc_code)="UNAVAILABLE"];
  SHUTTING_DOWN = 8 [(rpc_core.grpc_code)="CANCELLED"];
}
```

在同一个服务中，会传播 gRPC 和应用错误，但是所有的错误在 API 边界都会被替换成 UNKOWN。这避免了不同服务之间的意外错误代理的问题，修改了语义上的意思。

### Python 特定的修改

我们在 Python 存根给所有的 Courier 处理器中加入了显式的上下文参数，例如：

```
from dropbox.context import Context
from dropbox.proto.test.service_pb2 import (
        TestRequest,
        TestResponse,
)
from typing_extensions import Protocol

class TestCourierClient(Protocol):
    def UnaryUnary(
            self,
            ctx,      # 类型：Context
            request,  # 类型：TestRequest
            ):
        # 类型： (...) -> TestResponse
        ...
```

一开始，这看起来有些奇怪，但时候后来开发者们渐渐习惯了显式的 `ctx`，就像他们习惯 `self` 一样。

请注意，我们的存根也都是 mypy 类型的，这在大规模重构期间会得到充分的回报。并且 mypy 在像 PyCharm 这样的 IDE 中也已经得到了很好的集成。

继续静态类型的趋势，我们还可以将 mypy 的注解加入到 proto 中。

```
class TestMessage(Message):
    field: int

    def __init__(self,
        field : Optional[int] = ...,
        ) -> None: ...
    @staticmethod
    def FromString(s: bytes) -> TestMessage: ...
```

这些注解避免了许多常见的漏洞，比如将 `None` 赋值给 Python 中的 `string` 字段。

这些代码在 [dropbox/mypy-protobuf](https://github.com/dropbox/mypy-protobuf) 中开源了。

## 迁移过程

编写一个新的 RPC 栈绝非易事，但就操作的复杂性而言还是不能和跨范围的迁移相提并论。为了保证项目的成功，我们尝试简化开发者从传统 RPC 迁移到 Courier 的过程。由于迁移本身就是个很容易出错的过程，我们决定分成多个步骤来进行。

### 第 0 步： 冻结传统的 RPC

在开始之前，我们会冻结传统 RPC 的特征集，这样他就不会变化了。这样，由于追踪和流之类的新特性只能在 Courier 的服务中使用，大家也会更愿意迁移到 Courier。

### 第 1 步：传统 RPC 和 Courier 的通用接口

我们从给传统 RPC 和 Courier 定义通用接口开始。我们的代码生成会生成适用于这两种版本接口的存根：

```
type TestServer interface {
   UnaryUnary(
      ctx context.Context,
      req *test.TestRequest) (
      *test.TestResponse,
      error)
   ...
}
```

### 第 2 步：迁移到新接口

然后我们将每个服务都切换到新的接口，但还是使用传统 RPC。这对于所有服务和客户端中的方法来说通常都有很大的差异。这个过程很容易出错，为了尽可能降低风险，我们每次只改一个参数。

> 处理只有少数方法和[备用错误预算](https://landing.google.com/sre/sre-book/chapters/embracing-risk/)的低阶服务时可以一步完成迁移，不用管这个警告。

### 第 3 步：将客户端切换到 Courier RPC

作为迁移到 Courier 的一部分，我们需要在不同的端口上同时运行传统和 Courier 服务器的二进制文件。然后将客户端中 RPC 实现的一行进行修改。

```
class MyClient(object):
  def __init__(self):
-   self.client = LegacyRPCClient('myservice')
+   self.client = CourierRPCClient('myservice')
```

请注意，使用上面的模型一次可以迁移一个客户端，我们可以从批处理进程和其他一些异步任务等拥有较低 SLA 的开始。

### 第 4 步：清理

在所有的服务客户端都迁移完成之后，我们需要证明传统的 RPC 已经不再被使用了（可以通过代码检查静态地完成，或者通过检查传统服务器统计来动态地完成。）这一步完成之后，开发者就可以继续进行清理并删掉旧的代码了。

## 经验教训

到了最后，Courier 带给我们的是一个可以加速服务开发的统一 RPC 框架，它简化了操作并加强了 Dropbox 的可靠性。

这里我们总结了开发和部署 Courier 过程中主要的经验教训：

1. 可观察性是一个特性。在排除故障时，所有现成的度量和故障是非常宝贵的。
2. 标准化和一致性很重要。它们可以降低认知压力并简化操作和代码维护。
3. 试着最小化代码开发者需要编写的样板文件。代码生成器是你的伙伴。
4. 尽量让迁移简单些。迁移通常需要比开发更多的时间。同时，迁移只有在清理过程完成之后才算结束。
5. 可以在 RPC 框架中对基础设施范围内的可靠性进行改进，例如，强制截止期限、超载保护等等。常见的可靠性问题可以通过每个季度的事件报告来确定。

## 工作展望

Courier 和 gRPC 本身都在不断变化，所以我们最后来总结一下运行时团队和可靠性团队的工作路线。

在不远的将来，我们会给 Python 的 gRPC 代码加一个合适的解析器 API，切换到 Python/Rust 中的 C++ 绑定，并加上完整的断路控制和故障注入的支持。明年我们准备调研一下 [ALTS 并且将 TLS 握手移到单独的进程](https://cloud.google.com/security/encryption-in-transit/application-layer-transport-security/resources/alts-whitepaper.pdf)（可能甚至与服务容器分离开。）

## 我们在招聘！

你想做运行时相关的工作吗？Dropbox 在山景城和旧金山的小团队负责全球分布的边缘网络、兆比特流量、每秒数百万次的请求。

![](https://dropboxtechblog.files.wordpress.com/2019/01/09-screenshot2018-10-0318.04.58.png?w=650&h=364)

[通信量/运行时/可靠性团队都在招 SWE 和 SRE](https://www.dropbox.com/jobs/listing/1233364?gh_src=f80311fa1)，负责开发 TCP/IP 包处理器和负载均衡器、HTTP/gRPC 代理和我们内部的运行时 service mesh：Courier/gRPC、服务发现和 AFS。感觉不合适？我们[旧金山、纽约、西雅图、特拉维等地的办公室还有各个方向的职位](https://www.dropbox.com/jobs/teams/engineering?gh_src=f80311fa1#open-positions)。

## 鸣谢

**项目贡献者**：Ashwin Amit、Can Berk Guder、Dave Zbarsky、Giang Nguyen、Mehrdad Afshari、Patrick Lee、Ross Delinger、Ruslan Nigmatullin、Russ Allbery 和 Santosh Ananthakrishnan。

同时也非常感谢 gRPC 团队的支持。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
