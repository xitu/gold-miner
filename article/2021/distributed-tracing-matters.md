> * 原文地址：[Distributed Tracing Matters](https://levelup.gitconnected.com/distributed-tracing-matters-aa003d5adab9)
> * 原文作者：[Tobias Schmidt](https://medium.com/@tpschmidt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/distributed-tracing-matters.md](https://github.com/xitu/gold-miner/blob/master/article/2021/distributed-tracing-matters.md)
> * 译者：[ItzMiracleOwO](https://github.com/itzmiracleowo)
> * 校对者：[jaredliw](https://github.com/jaredliw)

# 关于分布式追踪的事项

单体式应用的问题大多是易于排查的。您可以查找执行轨迹，并详细调查错误和瓶颈。有时解决方法可能是快速排查栈追踪，以找出您的业务流程存在什么问题。

对于分布式系统，尤其是无服务器的云架构，就不是这种情况。单个进程经常调用若干函数或时间表导致事件驱动的处理。调试这种复杂的分布式系统可能很困难。关联请求和操作并不是一项简单的任务，但你通常需要找到错误，不一致或瓶颈。

这就是为什么你需要分布式追踪来覆盖您的团队结构和生态系统。它对您的帮助很大 —— 它能详细地为您提供有关请求所执行的代码或触发的业务流程。

在本文中，我想向您介绍 OpenTracing API，W3C 的 trace context，以及如何构建您自己的自定义集成。您可以将其用于创建和扩展您选择的追踪工具的 trace context。

* **论证** —— 为什么分布式追踪很重要
* **OpenTracing API** —— 一个独立于供应商的框架
* **概念** —— 跨度，范围和线程
* **深入探索** —— 了解跟踪父和追踪状态
* **实践** —— 初始化痕迹，打开和关闭跨度
* **关键要点**

## 为什么分布式追踪是必不可少的？

现代软件架构通常是多个系统的融合。在一个系统上的单个请求可能在生态系统导致许多操作和业务流程。有时，它们甚至不是同步的，而是通过基于事件的驱动架构完全解耦。

这使得调试变成了一个繁琐、复杂的任务。此外，观察单一事务也不容易。您不能只依赖单个系统的 stack trace，因为代码在多个系统上执行。

![一个包含多个解耦合操作的分布式系统](https://cdn-images-1.medium.com/max/2000/1*bbZZ4DGzS9FY3o-Q0WhfwA.png)

通过查看 AWS 上一些虚构架构的示例，我们看到在不同的系统中有很多代码只是一个外部触发器。

* 数据被写入了 DynamoDB，但在更改后通过 Streams 转发。
* 消息被加入到 SQS 队列，稍后被另一个 Lambda 函数处理。
* 调用外部服务，然后进行下一步的传入请求。

尽管操作似乎是解耦的，但它们通常与同一个触发器相关，因此从业务的角度来看是耦合的。您通常需要关联整个业务流程中包含的每个操作才能把问题解决。

![一个横跨多个系统，多个团队的进程](https://cdn-images-1.medium.com/max/2000/1*SHMu84OF4Eg-6eZhqaUugw.png)

如果您正在处理一个多团队项目，并且产品是由独立团队开发的，那就更明显了。事实上，每个团队都会监控自己负责的资源和微服务。但是，如果客户抱怨请求缓慢，但没有团队报告任何性能瓶颈时该怎么办？如果请求没有团队总体的相关性，就不可能详细调查这些问题。

总而言之：种种原因都促使你需要使用分布式追踪。

### 概述

如果要在多个系统上追踪您的请求，则需要收集路由上每一步的数据。

![多个服务上的 Web 事务，将上下文信息发送到追踪收集器](https://cdn-images-1.medium.com/max/2000/1*jHsAJgif51Gw6ZgvJb9scw.png)

我们的浏览器在我们的示例中提交了第一个请求，开始了整个操作的 tracing context。它需要发送请求本身并附加有关上下文的更多信息，以便您的追踪收集器可以稍后关联请求。所有后续系统都可以通过添加有关它们执行的代码的详细信息来扩展它。

该流程中涉及的每个系统都需要将其有关执行代码的详细信息发送到中央处理实例，我们稍后可以使用该实例来分析我们的结果。

## OpenTracing API

[引用介绍](https://opentracing.io/docs/overview/what-is-tracing/)：

> OpenTracing 由 API 规范、实现规范的框架和库以及项目文档组成。OpenTracing 允许开发人员使用 API 将检测添加到他们的应用程序代码中，而这些 API 不限定于任何特定产品或供应商。

尽管它不是一个标准，但它仍被许多框架和服务广泛使用，OpenTracing API 允许创建遵循定义指南的自定义实现。

## 概念

本段介绍了核心概念和术语。 我们将详细了解 `Spans`、`Scopes` 和 `Threads`。

### Spans

`Spans` 是分布式追踪的基本概念。`Span` 表示特定的执行代码或工作量。看看 OpenTracing 的规范，它包含：

* 操作的名称
* 开始和结束的时间
* 一组标签（用于查询）和日志（用于特定于跨度的消息）
* 上下文

这意味着，我们生态系统中涉及请求的每个组件都应至少贡献一个跨度。由于跨度可以引用其他跨度，我们可以利用这些跨度来建立一个完整的 stack trace，以覆盖单个请求中的所有操作。跨度的精细程度不限。我们可以在任何地方使用它，从覆盖整个复杂的过程到单个功能甚至操作的跨度。

![a span covering a DynamoDB query operation, including name and timestamps](https://cdn-images-1.medium.com/max/2000/1*1pu963Zo2U-ZisazG_XC_A.png)

### Scopes 和 Threading

看看应用程序中的专用线程，它一次只能有一个活动跨度，称为 `ActiveSpan`。 这并不意味着不能有多个跨度，而是其他需要被阻塞或等待。

当生成了一个新的跨度时，如果没有另外指定，当前 active 的跨度会自动成为其父跨度。

## 深潛

在系统之间传输我们的上下文围绕两个不同的 HTTP 标头演变：`traceparent` 和 `tracestate`。 它将包含有关如何关联所有相关跨度信息的所有信息。在 [W3C 的 Trace Context](https://www.w3.org/TR/trace-context/) 中有详细解说。

* `traceparent`— 指定对跟踪系统的请求，不依赖于任何供应者。
* `tracestate`— 包括关于请求供应者特定的信息。

### 跟踪父级

`traceparent` 标头携带四种不同类型的信息：版本、追踪标识符、父标识符和标志。

![Example traceparent HTTP header](https://cdn-images-1.medium.com/max/2000/1*qBXxYI9Qo_8RcohWoRegUQ.png)

* 版本 — 标识版本，当前为 `00`。
* TraceID — 分布式追踪的唯一标识符。
* ParentID — 调用者已知的请求标识符。
* 跟踪标志 — 用于指定采样或跟踪级别等选项。

而跟踪系统需要跟踪父级来关联我们的请求并将它们聚合成一个多跨请求。

### 追踪的状态

标头 `tracestate` 是伴随 Trace Parent 的，添加特定于供应者的追踪信息。

看看 NewRelic 的一个例子 :

![由 NewRelic 发送的 `tracestate` HTTP 标头示例](https://cdn-images-1.medium.com/max/2000/1*V5wa57TXTNpOEkE_fKkczw.png)

我们可以识别父级、跨度的时间戳以及我们的供应者。 跟踪状态标头可以携带哪些信息或它的外观没有固定的规则，因此它可能会因您使用的跟踪工具而有很大差异。

## 实践

现在我们已经介绍了这些概念。让我们通过了解如何利用这个概念来初始化追踪以及如何手动打开和关闭跨度来扩展它们来将其付诸实践。

尽管分布式追踪工具为许多不同的语言和框架提供了代理，但如果您需要手动扩展跟踪，这可能很重要。

让我们看一个基本场景，其中我们想要添加到分布式追踪中的系统仅通过调用另一个外部调用来执行次要业务逻辑。

![](https://cdn-images-1.medium.com/max/2000/1*0o2lIGelr9JtVRFVfuO9ZQ.png)

这使我们的示例很小，我们必须采取的基本步骤相当简单 :

* 如果还没有跟踪，我们将初始化一个新的（根跨度）
* 我们可以在处理该请求或操作的每个系统上为每个进程边界（例如外部调用）打开一个新的跨度
* 我们将在完成后关闭我们打开的跨度
* 我们将跨度详细信息提交给我们的追踪收集器系统

我们可以在单个系统中根据需要打开任意数量的跨度。我们只需要确保我们正确嵌套它们并分别关闭它们。因此，我们需要手动实现来跟踪跨度堆栈。

![](https://cdn-images-1.medium.com/max/2000/1*7dx9dp0v8bjChH7zWjxAbg.png)

### 设置我们的追踪

如果我们想以手动方式执行此操作，我们首先需要什么？ 我们需要一堆我们系统已经打开并因此需要关闭的跨度。

如果没有跟踪状态头进入我们的系统，我们可以很容易地通过自己生成一个新的。 如果已经有一个，我们将通过打开新的跨度来扩展跟踪。

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

现在我们有了根跨度，我们可以继续操作或流程打开跨度。

### 产生新的跨度

为了在单个系统中跟踪我们的跨度，我们需要一个堆栈来保存我们已经打开的跨度，如前所述。

我更喜欢使用我有两个专用对象的请求上下文：

* 一个跟踪跨度名称的列表，按照跨度打开时间顺序排列。
* 一个保存跨度必要细节的对象：打开它时的时间戳和跨度的标识符

![](https://cdn-images-1.medium.com/max/2000/1*ZWcuiszwgPfliOMPRAbOVg.png)

我们的根跨度仅用于跟踪我们的跟踪标识符。 最重要的是，我们将跟踪我们打开的所有跨度，并在操作或流程完成时删除每个跨度。

```JavaScript
const openNewSpan = (spanName) => {
  const spanId = ranHex(16);
  const startTime = Date.now();
  RequestContext.addSpan(spanName, { spanId, startTime });
};
```

### 关闭跨度并提交跟踪信息

当我们需要关闭操作或进程结束的跨度时，我们可以从堆栈顶部弹出跨度。 我们还可以根据我们在跨度中保存的信息或堆栈中剩余的信息来计算所需的信息。

* 我们父级的跨度标识符 — 这是现在在堆栈顶部的跨度
* 操作的持续时间 — 现在和我们在跨度保存的时间戳之间的差异
* 跟踪标识符 — 保存在我们的根跨度中，它始终是堆栈的底部。

在这个例子中，我们将跨度信息提交给 NewRelic（使用它们自己的格式）。 根据您使用的跟踪工具，这可能会有所不同。

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

就是这样。 你现在只需要在所有地方调用 `openNewSpan` 和 `closeSpan` 方法。 将其放入某个注释中是有意义的，这样您只需注释要跟踪的方法或进程，并且自动调用打开和关闭操作。

## 关键要点

构建分布式系统是一项复杂的任务，但可以通过 AWS、Azure 或 GCP 等云提供商以及利用 CloudFormation 的无服务器框架等高级基础设施作为代码工具来快速完成。请记住，您需要分布式追踪来分析您的系统和完整生态系统的运行方式并系统地调试问题。

本文向您介绍了追踪上下文的标准以及如何将它用于追踪跨系统和服务的请求。

感谢您的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
