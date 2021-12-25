> * 原文地址：[Distributed Tracing Matters](https://levelup.gitconnected.com/distributed-tracing-matters-aa003d5adab9)
> * 原文作者：[Tobias Schmidt](https://medium.com/@tpschmidt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/distributed-tracing-matters.md](https://github.com/xitu/gold-miner/blob/master/article/2021/distributed-tracing-matters.md)
> * 译者：[ItzMiracleOwO](https://github.com/itzmiracleowo)
> * 校对者：[jaredliw](https://github.com/jaredliw)、[KimYangOfCat](https://github.com/KimYangOfCat)

# 关于分布式追踪的事项

单体式应用的问题大多是易于排查的。你可以查找执行轨迹，并详细调查错误和瓶颈。有时只需快速排查堆栈追踪，就能找出你的业务流程中存在什么问题。

对于分布式系统，尤其是无服务器的云架构，就不是这种情况。单个进程经常调用若干函数或编制事件驱动进程产生的消息。调试这种复杂的分布式系统可能很困难。关联请求和操作并不是一项简单的任务，但你通常需要这样做来找到错误，不一致或瓶颈。

这就是为什么你需要分布式追踪来覆盖你的团队结构和生态系统。它可以让你详细了解一个专项请求或被触发的业务流程的所有已执行代码，从而提供巨大的帮助。

在本文中，我想向你介绍 OpenTracing API，W3C 的 Trace Context 规范，以及如何构建你自己的自定义集成，你可以将其用来为你选择的追踪工具创建和扩展追踪上下文。

* **论证** —— 为什么分布式追踪很重要
* **OpenTracing API** —— 一个独立于供应商的框架
* **概念** —— spans，范围和线程
* **深入探索** —— 了解追踪父级 span 和追踪状态
* **实践** —— 初始化追踪器，打开和关闭 spans
* **主要收获**

## 为什么分布式追踪是必不可少的？

现代软件架构通常是多个系统的融合。在一个系统上的单个请求可能引起生态系统中的许多操作和业务流程。有时，它们甚至不是同步的，而是基于事件的驱动的，完全解耦的。

这使得调试变成了一个繁琐、复杂的任务。此外，观察单一事务也不容易。你不能只依赖单个系统的堆栈追踪，因为代码在多个系统上执行。

![一个包含多个解耦操作的分布式系统](https://cdn-images-1.medium.com/max/2000/1*bbZZ4DGzS9FY3o-Q0WhfwA.png)

通过查看 AWS 上一些虚构架构的示例，我们看到在不同的系统中有很多代码只是一个外部触发器。

* 数据被写入了 DynamoDB，但更动通过 Streams 转发。
* 消息被加入到 SQS 队列，稍后被另一个 Lambda 函数处理。
* 外部服务被调用，进而产生下一步的传入请求。

尽管操作似乎是解耦的，但它们通常与同一个触发器相关，因此从业务的角度来看是耦合的。你通常需要关联整个业务流程中包含的每个操作才能把问题解决。

![一个横跨多个系统，多个独立团队的进程](https://cdn-images-1.medium.com/max/2000/1*SHMu84OF4Eg-6eZhqaUugw.png)

如果你正在处理一个多团队项目，并且产品是由独立团队开发的，那就更明显了。事实上，每个团队都会监控自己负责的资源和微服务。但是，如果客户抱怨请求缓慢，但没有团队报告任何性能瓶颈时该怎么办？如果请求没有团队总体的相关性，你就不可能详细地调查这些问题。

总而言之：种种原因都促使你需要使用分布式追踪。

### 概述

如果要在多个系统上追踪你的请求，则需要收集路由上每一步的数据。

![多个服务上的 Web 事务，将上下文信息发送到追踪收集器](https://cdn-images-1.medium.com/max/2000/1*jHsAJgif51Gw6ZgvJb9scw.png)

我们的浏览器在我们的示例中提交了第一个请求，开始了整个操作的追踪上下文。它需要发送请求本身并附加有关上下文的更多信息，以便你的追踪收集器可以稍后关联请求。所有后续系统都可以通过添加有关它们执行的代码的详细信息来扩展它。

该流程中涉及的每个系统都需要将其有关执行代码的详细信息发送到核心处理实例，我们稍后可以使用该实例来分析我们的结果。

## OpenTracing API

[引用介绍](https://opentracing.io/docs/overview/what-is-tracing/)：

> OpenTracing 由 API 规范、实现规范的框架和库以及项目文档组成。OpenTracing 允许开发人员使用 API 将检测器添加到他们的应用程序代码中，而这些 API 不限定于任何特定产品或供应商。

尽管它不是一个标准，但它仍被许多框架和服务广泛使用，OpenTracing API 允许创建遵循定义指南的自定义实现。

## 概念

本段介绍了核心概念和术语。 我们将详细了解 `Spans`、`Scopes` 和 `Threads`。

### Spans

`Spans` 是分布式追踪的基本概念。`Span` 表示特定的执行代码或工作量。看看 OpenTracing 的规范，它包含：

* 操作的名称
* 开始和结束的时间
* 一组标签（用于查询）和日志（用于特定于跨度的消息）
* 上下文

这意味着，我们生态系统中涉及请求的每个组件都应至少贡献一个跨度。由于跨度可以引用其他跨度，我们可以利用这些跨度来建立一个完整的堆栈追踪，以覆盖单个请求中的所有操作。跨度的精细程度不限。我们可以在任何地方使用它，不论是整个复杂的流程，或是单个功能/操作的跨度。

![一个涵盖了 DynamoDB 查询操作的 span，包含名称和时间戳](https://cdn-images-1.medium.com/max/2000/1*1pu963Zo2U-ZisazG_XC_A.png)

### Scopes 和 Threading

看看应用程序中的专用线程，它一次只能有一个活跃的 span，称为 `ActiveSpan`。 这并不意味着我们不能有多个 span，而是其他 span 会被阻塞。

当生成了一个新的 span 时，如果没有另外指定，当前活跃的 span 会自动成为其父 span。

## 深入探索

在系统之间传输我们的上下文是由两个不同的 HTTP 标头实现的：`traceparent` 和 `tracestate`。它将包含如何关联所有相关 span 信息的全部信息。在 [W3C 的 Trace Context](https://www.w3.org/TR/trace-context/) 中有详细解说。

* `traceparent` —— 指定对追踪系统的请求，不依赖于任何供应商。
* `tracestate` —— 包括关于请求供应商特定的信息。

### 追踪父级 span

`traceparent` 标头携带四种不同类型的信息：版本、追踪标识符、父标识符和标志。

![`traceparent` HTTP 标头的示例](https://cdn-images-1.medium.com/max/2000/1*qBXxYI9Qo_8RcohWoRegUQ.png)

* 版本 — 标识版本，当前为 `00`。
* TraceID — 分布式追踪的唯一标识符。
* ParentID — 调用者已知的请求标识符。
* 追踪标志 — 用于指定采样或追踪级别等选项。

追踪系统需要追踪父级 span 来关联我们的请求并将它们聚合成一个多 span 请求。

### 追踪状态

标头 `tracestate` 是伴随 Trace Parent 的，添加特定供应商的追踪信息。

看看一个 NewRelic 的例子 :

![由 NewRelic 发送的 `tracestate` HTTP 标头示例](https://cdn-images-1.medium.com/max/2000/1*V5wa57TXTNpOEkE_fKkczw.png)

我们可以识别父级、span 的时间戳以及我们的供应商。 追踪状态标头可以携带哪些信息或它必须是什么样子都没有固定的规则，因此它可能会因你使用的跟踪工具而有很大差异。

## 实践

我们已经介绍了这些概念，现在让我们付诸实践，了解如何利用这些概念来初始化追踪器以及如何通过手动打开和关闭 span 来扩展它们。

尽管分布式追踪工具为许多不同的语言和框架提供了代理，但如果你需要手动扩展追踪器，以下信息可能很重要。

让我们看一个基本场景，其中我们想要添加到分布式追踪中的系统仅通过调用另一个外部调用来执行次要业务逻辑。

![](https://cdn-images-1.medium.com/max/2000/1*0o2lIGelr9JtVRFVfuO9ZQ.png)

我们的示例非常简单，因此我们必须采取的基本步骤也相当简单：

* 如果还没有跟踪，我们将初始化一个新的（根 span）
* 我们可以在处理该请求或操作的每个系统上为每个进程边界（例如外部调用）创建一个新的 span
* 我们将在完成后关闭我们打开的 span
* 我们将 span 详细信息提交给我们的追踪收集器系统

我们可以在单个系统中根据需要打开任意数量的 span。我们只需要确保我们正确嵌套它们并分别关闭它们。因此我们需要手动执行追踪 span 堆栈。

![](https://cdn-images-1.medium.com/max/2000/1*7dx9dp0v8bjChH7zWjxAbg.png)

### 设置我们的追踪器

如果我们想以手动方式执行此操作，我们首先需要什么？我们需要一堆我们系统已经打开并因此需要关闭的 span。

如果没有跟踪状态头进入我们的系统，我们可以自行通过生成它来轻松地创建一个新的。如果已经有一个，我们将通过打开新的 span 来扩展跟踪。

```JavaScript
let traceParent = RequestContext.getHeader('traceparent');
let version = "00";
let traceId;
let spanId;
let flags = "00";

if (!traceParent) {
  traceId = randHex(32);
  spanId = "";
} else {
  const split = traceParent.split("-");
  version = split[0];
  traceId = split[1];
  spanId = split[2];
  flags = split[3];
}
```

现在我们有了根 span，我们可以继续在自定义的粒度上为操作或流程创建 span。

### 产生新的 span

如前所述，为了在单个系统中跟踪我们的 span，我们需要一个堆栈来保存我们已经打开的 span。

我更喜欢使用有两个专用对象的请求上下文：

* 一个保存跨度必要细节的对象：打开它时的时间戳和跨度的标识符
* 一个保存 span 必要细节的对象：打开它时的时间戳和 span 的标识符

![](https://cdn-images-1.medium.com/max/2000/1*ZWcuiszwgPfliOMPRAbOVg.png)

我们的根 span 仅用于追踪我们的追踪器标识符。最重要的是，我们将追踪我们打开的所有 span，并在操作或流程完成时删除每个 span。

```JavaScript
const openNewSpan = (spanName) => {
  const spanId = ranHex(16);
  const startTime = Date.now();
  RequestContext.addSpan(spanName, { spanId, startTime });
};
```

### 关闭 span 并提交追踪信息

当我们需要关闭操作或进程结束的 span 时，我们可以从堆栈顶部弹出 span。我们还可以根据我们在 span 中保存的信息或堆栈中剩余的信息来计算所需的信息。

* 我们父级 span 标识符 —— 这是现在在堆栈顶部的 span。
* 当前的时间戳和我们在跨度保存的时间戳的差为操作的持续时间。
* 追踪标识符 —— 保存在我们的根 span 中，它始终在堆栈的底部。

在这个例子中，我们将跨度信息以他们自己的格式提交给 NewRelic。根据你使用的追踪工具，这可能会有所不同。

```JavaScript
const closeSpan = (spanName) => {
  const top = RequestContext.popSpan();
  const spanId = top.spanId;
  const duration = Date.now() - top.startTime;
  const parent = RequestContext.getSpan('root');
  const traceId = parent.traceId;
  const parentId = parent.spanId;
  // set the trace parent of 
  updateTraceParent();
  submitTraceInformation(traceId, spanName, spanId, parentId, duration); 
}

const updateTraceParent = () => {
  const top = RequestContext.getTopSpan();
  const root = RequestContext.getRootSpan();
  const spanId = top.spanId;
  const traceId = root.traceId;
  const version = root.version;
  const flags = root.flags;
  const traceParent = [version, traceId, spanId, flags].join("-")
  RequestContext.setHeader("traceparent", traceParent);
};

const submitTraceInformation = (traceId, spanName, spanId, parentId, duration) => {
  var data = JSON.stringify([
    {
      common: {
        attributes: {
          "service.name": "register-service",
          host: "mydomain.com"
        }
      },
      spans: [
        {
          "trace.id": traceId,
          id: spanId,
          attributes: {
            "parent.id": parentId,
            "duration.ms": duration,
            name: spanName
          }
        }
      ]
    }
  ]);

  var config = {
    method: 'post',
    url: 'https://trace-api.newrelic.com/trace/v1',
    headers: { 
      'Api-Key': 'NRII-xc.........77m5P6O', 
      'Content-Type': 'application/json', 
      'Data-Format': 'newrelic', 
      'Data-Format-Version': '1'
    },
    data
  };

  axios(config)
    .then(res => console.log(JSON.stringify(res.data)))
    .catch(err => console.log(err));
}
```

就是这样。 你现在只需要在所有地方调用 `openNewSpan` 和 `closeSpan` 函数。把这一点放到一些注释中是有意义的，这样你只需注释要追踪的方法或进程，并且自动调用打开和关闭操作。

## 主要收获

构建分布式系统是一项复杂的任务，但可以通过 AWS、Azure 或 GCP 等云提供商以及利用 CloudFormation 的无服务器框架等高级基础设施作为代码工具来快速完成。请记住，你需要分布式追踪来分析系统的表现，并有条理地调试问题。

本文向你介绍了追踪上下文的标准以及如何将它用于追踪跨系统和服务的请求。

感谢你的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
