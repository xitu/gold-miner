
  > * 原文地址：[An Overview of the Logging Ecosystem in 2017](https://blog.codeship.com/an-overview-of-the-logging-ecosystem-in-2017/)
  > * 原文作者：[Matthew Setter](https://blog.codeship.com/author/matthewsetter/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/an-overview-of-the-logging-ecosystem-in-2017.md](https://github.com/xitu/gold-miner/blob/master/TODO/an-overview-of-the-logging-ecosystem-in-2017.md)
  > * 译者：
  > * 校对者：

  # An Overview of the Logging Ecosystem in 2017

  Logging. It’s fair to say that it’s a fundamental tenet of modern computing. It helps developers debug applications, and systems administrators and DevOps staff debug server outages. Consequently, logs are critical for providing the information and context required to solve problems, both as they occur and to understand them from a historical context.

But like anything in computing, the state of logging never stands still. Existing concepts go out of vogue and new ones take their place, while yet other ideas turn out to be timeless — sometimes enduring for years. The same pattern applies to tools and services, whether commercial or open source, hosted on- or off-site.

So where are we now? What trends, tools, and philosophies currently hold sway and why? Well, today I will consider three areas of the logging ecosystem to get a gauge of where the industry stands in mid-2017.

Specifically, I’m going to look at some of the more notable:

- philosophies
- best practices
- service and tool options

Before we dive in, I’ll give this frank admission: I consider myself a developer first and foremost and a systems administrator and DevOps person second. As a result, my perspective and the choices I make in this article are colored accordingly. Please bear that in mind.

[“What logging trends, tools, and philosophies currently hold sway and why?” via @settermjd](https://twitter.com/share?text=%22What+logging+trends%2C+tools%2C+and+philosophies+currently+hold+sway+and+why%3F%22+via+%40settermjd&amp;url=https://blog.codeship.com/an-overview-of-the-logging-ecosystem-in-2017/)

That said, let’s get going.

## The Philosophies of the Logging Ecosystem

The first area I want to cover is logging philosophies. Within that, I want to look at two concepts: logging storage and logging culture.

### Where and how should logs be stored?

Should logs be kept in a service that you manage yourself, inside your organization? Or should you use a SaaS such as Loggly, or one of the other tools that [we’ll cover later](#service-and-tool-options), storing the log data outside of your direct control?

From what I’ve come to understand, the primary distinction is fundamentally a question of security and data sensitivity. Do you have information that absolutely cannot be seen by someone outside of your organization?

If so, then it’s likely better to host a solution yourself and log to it, something such as [Apache Kafka](https://kafka.apache.org), or [an Elastic (formerly ELK) stack](https://www.elastic.co/webinars/introduction-elk-stack). If your data isn’t as sensitive, then a hosted solution from one of the commercial vendors, such as *Loggly*, *Graylog*, *SumoLogic*, and *ElasticSearch*, may be better choices.

The other consideration that still seems to populate discussions, such as [this one on Hacker News](https://news.ycombinator.com/item?id=12682566), is the question of efficiency. More specifically, is it worth the effort for us as an organization to build and manage an in-house logging solution, such as one based on Elastic Stack? Or is it better to host our data with a vendor?

There’s never a clear, one-size-fits-all answer to a question like this. And the most consistent answer I’m continuing to see still is “it depends.” No two organizations or applications are the same. What works for one won’t necessarily work for the other. One might have more resources and experience available to assign to the task. Another may not.

So if there’s a key philosophical constant in the logging ecosystem in 2017, it’s still the question of where should the log data be stored.

### The sidecar application

What is new — at least for me — is a concept called *the sidecar application*. If you’ve not heard of it before, it’s mainly relevant when deploying applications using containers, as it pertains strongly to container-based deployments.

[Garland Kan from Loggly](https://www.loggly.com/blog/how-to-implement-logging-in-docker-with-a-sidecar-approach/) puts it most succinctly, when he describes it as:

> …the concept of pairing up an application container and a logging container.

Voxxed provides greater depth [when they describe it](https://www.voxxed.com/blog/2015/01/use-container-sidecar-microservices/) this way:

> A sidecar application is deployed alongside each microservice that you have developed and deployed to a server/hosting instance. It is conceptually attached to the “parent” service, in the same manner a motorcycle sidecar is attached to the motorcycle — hence the name. A sidecar runs alongside your service as a second process and provides ‘platform infrastructure features’ exposed via a homogeneous interface such as a REST-like API over HTTP.

In the context of logging, an additional container would be added to the deployed stack where the logs of the application would be stored, and which could also forward those logs on to an external service, such as LogEntries or Splunk. From what I understand, the concept can work well for smaller applications but may be hard to scale efficiently. That said, it’s an interesting concept all the same.

### A culture of logging

Now let’s look at culture — an all too important aspect of any initiative. To get straight to the point, something that struck me recently was a quote [from Stackify](https://stackify.com/java-logging-best-practices/), when they said:

> …we’ve built a “culture of logging”…

I find this one of the best improvements in recent years because without a supporting culture, ideas and concepts are likely to be transitory at best. I’m sure most of us can relate to, in years gone by, when testing was on the way in. It always worked great at first. But if a supporting culture wasn’t in place, it quickly fell by the wayside when deadlines and other pressures started stacking up.

In the post, Stackify goes on to say:

> [The culture of logging] sets out to accomplish these goals:
>
> Log all the things. Log as much as we possibly can, to always have relevant, contextual logs that don’t add overhead. Work smarter, not harder. Consolidate and aggregate all of our logging to a central location, available to all devs, and easy to distil. Also, to find new ways for our logging and exception data to help us proactively improve our product.

There are some excellent points here, two of which in particular are worth unpacking.

#### Log as much as we possibly can

Contrary to what I’ve seen and experienced in previous years, this expresses the importance of logging more, **not less** — so long as that information’s contextual. This ties in well with what [Sumologic wrote back in April](https://www.sumologic.com/blog/log-management-analysis/best-practices-creating-custom-logs-diving-deeper/) 2017 when they said:

> Your logs should tell a story.

To me, this makes perfect sense and is an excellent development to see coming to fruition.

While I don’t believe we should log for the sake of it, the more (contextual) information we have, the better position we will be in to solve the problems that invariably occur.

#### Logging to a central location, available to all devs

That the information is centrally accessible to everyone is another heartening development to see growing ever stronger.

When information is kept in a central location, it’s much easier to work with. And when everyone can access it — *and see it* — it increases the onus of responsibility in determining what goes into the logs, as well as the need to resolve issues quicker. If information can be hidden from view, then it’s easier for issues to be glossed over or buried.

I’d like to believe that as these two philosophies take hold (logging as much as we can and logging to a central location), the quality of our applications will increase and the downtime will decrease, resulting in greater user and developer satisfaction.

[![Sign up](https://resources.codeship.com/hubfs/hub_generated/resized/522f8e9a-4760-42a2-9e7d-21780dfaae2b.png)](https://resources.codeship.com/cs/c/?cta_guid=f9c07177-11c7-44f5-962e-71116a8292a2&placement_guid=964db6a6-69da-4366-afea-b129019aff07&portal_id=1169977&redirect_url=APefjpHK7AUB26fFkV8T6f8w3pa2iXgimx-OwWa0mv7vwuQ9Qn1_WPEopcBxEtxv0oUL4iy6kF57zx0LDmnef1BcqOe0zK9fp7xsE9o4rtHSF8IpBjkJg5SO678peKfJbWgDYpBuPX6GFmTlTZLDhCtdckQ9d2qMT7TAEW2hnqdESN05DqKsxc8pgJzg0g3Mf6ac2ljX6IzrTulkhymu9tJBlcsHgy9TpouYzPpk1cOQhGuZKm_lKXmZDN6GEo2LoUfh-F6AEH5DIEmtUlFcKWLPXWEmwPn0-kPZWSU43p9vnIMZQvFDDArTfWVn3ZbCMyggZCGYSOvgCPFqTvnFGsfYegiJlO5BjA&hsutk=a15127591b468cb7fa682b9b9d7434c5&canon=https%3A%2F%2Fblog.codeship.com%2Fan-overview-of-the-logging-ecosystem-in-2017%2F&click=fbdaa4a3-14b1-4d61-8363-9bab2cc5db38&utm_referrer=https%3A%2F%2Fblog.codeship.com%2Fan-overview-of-the-logging-ecosystem-in-2017%2F&__hstc=209244109.a15127591b468cb7fa682b9b9d7434c5.1503571579504.1503571579504.1503571579504.1&__hssc=209244109.2.1503571579514&__hsfp=3027766740)

## Best Practices

Now I want to look at one of the central themes in best practice that I’ve picked up over the course of the year: do we create logs that are human-readable or ones that are efficient to parse?

It seems to be agreed upon that humans are better at working with data that isn’t logical, consistent, or possessing of a standard pattern, yet computers aren’t. Conversely, humans aren’t good at processing large amounts of data, yet computers are. Given that, we’re presented with a challenge: do we create logs that, on an individual basis, people can work with, or do we make them efficient for computer processing, and make them readable afterward?

I’ve found that unless you’re only logging a small amount of information, the consensus is that it’s better to focus on processing efficiency, with as much context as possible, rather than human readability.

But what does an efficient, context-rich, log entry look like? [Dan Reichart (from SumoLogic) provides the following](https://www.sumologic.com/blog/log-management-analysis/best-practices-creating-custom-logs-diving-even-deeper/), from a fictitious flight-booking service, as an example:

    2017-04-1009:50:32-0700-dan12345-10.0.24.123-GET- /checkout/flights/ -credit.payments.io-Success-2-241.98

To summarize, each element in the entry is separated by a `-` sequence. And the elements, in order, are:

1. The log timestamp
2. The purchaser’s username
3. The user’s IP address
4. The request method
5. The requested resource
6. The request gateway or path
7. The requested status
8. The number of flights purchased
9. The combined flight value

If we just had some of this information, we’d only be able to know a part of the story, if anything. But by storing all this information, which compacts down quite well by the way, we’re in a position to know all we need to know to resolve the issue. The log is concise, yet readable, tells a story, and follows a standard, predictable pattern. There are other ways to be as expressive, of which this is but one.

## Service & Tool Options

Now, let’s finish up by looking at some of the current players in the logging market. These are a mix of hosted SaaS and self-hosted solutions. Some of the more notable who are still going strong are ones that have been around for some time. They include such companies as *Loggly*, *Graylog*, *Splunk*, *ElasticSearch*, *LogEntries*, *Logz.io*, *LogStash*, *SumoLogic*, and *Retrace*.

While each of these has features such as search and analysis, proactive monitoring, creating structured and unstructured data, custom parsing rules, and real-time dashboards, they’ve continued to build on their core functionality, as well as to expand their product offerings and feature sets.

There’s quite a difference in their pricing models as well, including free options, standard plans starting at around $90 USD, and enterprise plans starting as high as $2,000 USD.

But commercial vendors aren’t the only choice in 2017. Some open-source tools are also growing in maturity. In fact, two were singled out for attention in the Linux Foundation’s third annual [Guide to the Open Cloud report](http://go.linuxfoundation.org/l/6342/2016-10-31/3krbjr): [Fluentd](http://www.fluentd.org), the data collector for unified logging layers, and [LogStash](https://www.elastic.co/products/logstash), the server-side data-processing pipeline. Other open-source tools worth considering are [syslog-ng](https://syslog-ng.org/), [LOGalyze](http://www.logalyze.com/), and [Apache Flume](https://cwiki.apache.org/confluence/display/FLUME/Home).

Given that, depending on your experience, needs, and budget, you’re not going to be short of choice this year. There will be a number of options from which you can choose to find the one best suited to your needs.

## Conclusion

And that’s a broad overview of several of the key factors in the logging ecosystem in 2017.

We’ve looked at current philosophies, such as where and how logs should be stored, and the sidecar-application concept. We’ve discussed how important a culture of logging can be to the success of logging within an organization, and how more contextual logging is better than less. And we finished up by looking at some of the key players in the market in 2017.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  