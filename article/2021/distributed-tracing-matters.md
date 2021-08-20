> * 原文地址：[Distributed Tracing Matters](https://levelup.gitconnected.com/distributed-tracing-matters-aa003d5adab9)
> * 原文作者：[Tobias Schmidt](https://medium.com/@tpschmidt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/distributed-tracing-matters.md](https://github.com/xitu/gold-miner/blob/master/article/2021/distributed-tracing-matters.md)
> * 译者：
> * 校对者：

# Distributed Tracing Matters

Facing issues with a monolith is mostly easy to investigate. You can look up execution traces and have a detailed look into errors and bottlenecks. Sometimes it’s a quick look on the stack trace to find out what’s the issue with your business process.

For a distributed system, especially serverless cloud architectures, that’s not the case. A single process often invokes several functions or schedules messages resulting in event-driven processing. Debugging such a complex distributed system can be difficult. It’s not a simple task to correlate requests and operations, but exactly that is often needed to find bugs, inconsistencies, or bottlenecks.

That’s why you need distributed tracing, overarching your team structure and ecosystem. It helps immensely by giving you detailed insights on all executed code for a dedicated request or triggered business process.

In this article, I want to give you an introduction to the OpenTracing API, W3C’s Trace Context specification, and how you can build your own custom integration which you can use to create and extend trace context for a tracing tool of your choice.

* **Reasoning** — why distributed tracing is important
* **OpenTracing API**—a vendor-independent framework
* **Concepts** — Spans, scopes & threads
* **Deep Dive**— Understanding trace parent & trace state
* **Hands-On**— Initializing traces, opening & closing spans
* **Key Takeaways**

## Why distributed tracing is not optional

Modern software architectures are often a fusion of multiple systems which are working together. Single requests on one system can result in numerous operations and processes around your ecosystem. Sometimes, they are not even synchronous but completely decoupled via an event-based driven architecture.

This makes debugging a tedious and complex task. Also, observing single transactions is not easily possible. You can’t simply rely on stack traces from a single system, because code is executed on multiple systems.

![A distributed system, with multiple decoupled operations](https://cdn-images-1.medium.com/max/2000/1*bbZZ4DGzS9FY3o-Q0WhfwA.png)

Looking at the example for some imaginary architecture on AWS, we see that there’s a lot of code executed on different systems for just a single external trigger.

* data is written to DynamoDB, but changes are forwarded via Streams.
* messages are queued to SQS and later processed by another Lambda function.
* calls to external services are made, which afterward are resulting in further incoming requests.

Even though operations seem to be decoupled, they are often related to the same trigger and therefore coupled from a business perspective. Occurring issues can often only be solved if you’re able to correlate every operation that’s included in the complete business process.

![a process spanning multiple systems of multiple, independent teams](https://cdn-images-1.medium.com/max/2000/1*SHMu84OF4Eg-6eZhqaUugw.png)

If you’re working on a multi-team project and the product is developed by independent teams, it becomes even more obvious. As a matter of fact, each team will monitor its own resources and microservices they are responsible for. But what if there are customer complaints about slow requests and no team has reported any performance bottlenecks? Without any team-overarching correlation of requests, it’s not possible to investigate these issues in detail.

So to summarize: there is a lot of reasoning for having distributed tracing.

### An Overview

If you want to trace your requests over multiple systems, you need to collect data for every step on your route.

![Web Transactions over multiple Services, sending Context information to a Tracing Collector](https://cdn-images-1.medium.com/max/2000/1*jHsAJgif51Gw6ZgvJb9scw.png)

Our browser submits the first request in our example, which starts the context for the whole operation. It needs to send the request itself and attach further information about the context so that your tracing collector can correlate the request later on and that all following systems can extend it by adding details about the code they execute.

Each system involved in the process needs to send its details about the executed code to a central processing instance which we can later use to analyze our results.

## The OpenTracing API

[Quoting the introduction](https://opentracing.io/docs/overview/what-is-tracing/):

> OpenTracing is comprised of an API specification, frameworks and libraries that have implemented the specification, and documentation for the project. OpenTracing allows developers to add instrumentation to their application code using APIs that do not lock them into any one particular product or vendor.

Even though it’s not a standard, it’s widely used by a lot of frameworks and services, allowing the creation of customized implementations that follow defined guidelines.

## Concepts

This paragraph gives an introduction to the core concepts and the terminology. We’ll have a detailed look on `Spans`, `Scopes` and `Threads`.

### Spans

Spans are the fundamental concept of distributed tracing. A span represents a specific amount of executed code or work. Having a look at the OpenTracing specification, it contains:

* the name of the operation
* the start & end time
* a set of tags (for querying) and logs (for span-specific messages)
* a context

That means that each component in our ecosystem that is involved in a request should contribute at least one span. Because a span can reference other spans, we can build a complete stack trace out of those multiple spans to cover all operations in a single request. There’s no limit on how fine-grained a span can be. The line can basically be drawn anywhere, from covering a whole complex process to having spans for single functions or even operations.

![a span covering a DynamoDB query operation, including name and timestamps](https://cdn-images-1.medium.com/max/2000/1*1pu963Zo2U-ZisazG_XC_A.png)

### Scopes and Threading

Having a look at a dedicated thread in an application, it can only have one active span at a time, called the `ActiveSpan`. That does not mean that there can’t be multiple spans, but other need to be for example blocked or waiting.

If a new span is spawned, the currently active span automatically becomes its parent if it’s not specified otherwise.

## Deep Dive

Transmitting our context between systems evolves around two different HTTP headers: `traceparent` and `tracestate`. It will contain all the information about how to correlate the information about all related spans. It’s specified by [W3C’s Trace Context](https://www.w3.org/TR/trace-context/).

* `traceparent`— specifying the request for the tracing system, not dependent on any vendor.
* `tracestate`— includes vendor-specific details about the request.

### Trace Parent

The `traceparent` header carriers four different kinds of information: the version, the trace identifier, the parent identifier, and the flags.

![Example traceparent HTTP header](https://cdn-images-1.medium.com/max/2000/1*qBXxYI9Qo_8RcohWoRegUQ.png)

* Version — identifies the version, currently being `00`.
* TraceID — unique identifier for the distributed trace.
* ParentID — identifier of the request as known by the caller.
* Trace Flags — for specifying options like sampling or trace level.

The trace parent is needed for the tracing system to correlate our requests and aggregate them into a multi-span request.

### Trace State

The `tracestate` header is a companion to the Trace Parent, adding vendor-specific trace information.

Having a look at an example by NewRelic:

![Example tracestate HTTP header sent by NewRelic](https://cdn-images-1.medium.com/max/2000/1*V5wa57TXTNpOEkE_fKkczw.png)

We can identify the parent, the timestamp of the span as well as our vendor. There are no fixed rules on which information the trace state header can carry or how it has to look, so it can hugely vary based on the tracing tool you’re using.

## Hands-On

Now we’ve covered the concepts. Let’s put this into practice by understanding how we can leverage this concept to initialize traces and how to extend them by opening and closing spans ourselves.

Even though distributed tracing tools offer agents for a lot of different languages and frameworks, this can be important if you’re in need of extending your traces manually.

Let’s have a look at a basic scenario where the system that we want to add to our distributed tracing only does minor business logic by invoking another external call.

![](https://cdn-images-1.medium.com/max/2000/1*0o2lIGelr9JtVRFVfuO9ZQ.png)

This keeps our example small and the basic steps we have to take are fairly simple:

* if there’s no trace yet, we’ll initialize a new one (the root span)
* we can open a new span for every process boundary (e.g. an external call) at each system that works on that request or operation
* we’ll close the spans we opened after they are finished
* we submit span details to our tracing collector system

We can open as many spans as we need in a single system. We just need to make sure that we nest them correctly and close each one separately. Therefore a manual implementation needs to keep track of the span stack.

![](https://cdn-images-1.medium.com/max/2000/1*7dx9dp0v8bjChH7zWjxAbg.png)

### Setting up our trace

What do we need in the first place if we want to do this in a manual way? We need a stack of all the spans our system has opened and therefore needs to close.

If there’s no trace state header incoming into our system, we can easily create a new one by generating it ourselves. If there’s already one, we’ll just extend the trace by opening new spans.

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

Now we’ve got our root and we can continue to open spans for operations or processes at our own granularity.

### Spawning new spans

For tracking our spans in a single system, we need a stack that saves us our already opened spans as previously described.

I prefer using a request context where I have two dedicated objects

* a list that tracks the name of the spans, in the order of when the span was opened
* an object that keeps the necessary details for the span: timestamp of when it was opened and the identifier of the span

![](https://cdn-images-1.medium.com/max/2000/1*ZWcuiszwgPfliOMPRAbOVg.png)

Our root is only for tracking our trace identifier. On top of it, we’ll track all spans that we’ve opened and we’ll remove each one at the time when the operation or process finishes.

```JavaScript
const openNewSpan = (spanName) => {
  const spanId = ranHex(16);
  const startTime = Date.now();
  RequestContext.addSpan(spanName, { spanId, startTime });
};
```

### Closing spans & submitting trace information

When we need to close a span the operation or processes ended, we can pop the span from the top of the stack. We can also calculate needed information based on the information we saved at the span or what’s left in our stack.

* the span identifier of our parent — that’s the span which is now on top of the stack
* the duration of the operation — the difference between now and the timestamp we saved at our span
* the trace identifier— saved at our root span, which is always the bottom of the stack.

In this example, we’re submitting the span information to NewRelic (with their own format). Depending on the tracing tool you’re using, this will vary.

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

And that’s it. You now only need to call the`openNewSpan` and `closeSpan` methods at all places. It makes sense to put this into some annotation so that you only have to annotate methods or processes you want to track and that the open and closing operations are called automatically.

## Key Takeaways

Building a distributed system is a complicated task but can be lightning-fast with cloud providers like AWS, Azure, or GCP and advanced infrastructure as code tools like Serverless Framework leveraging CloudFormation. Keep in mind that you need distributed tracing to analyze how your systems and complete ecosystem are performing and to debug issues systematically.

This article gave you an introduction to the trace context standard and how it’s used for tracing requests over multiple systems and services.

Thank you for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
