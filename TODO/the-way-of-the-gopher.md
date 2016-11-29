> * 原文地址：[Making the Switch from Node.js to Golang](https://medium.com/@theflapjack103/the-way-of-the-gopher-6693db15ae1f#.f1purx7x4)
* 原文作者：[Alexandra Grant](https://medium.com/@theflapjack103)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# Making the Switch from Node.js to Golang

# 从 Node.js 到 Golang 的迁徙之路




_This post was written by Digg Software Engineer [Alexandra Grant](https://twitter.com/TheFlapjack103) and was [originally posted on Medium](http://t.umblr.com/redirect?z=https%3A%2F%2Fmedium.com%2F%40theflapjack103%2Fthe-way-of-the-gopher-6693db15ae1f&t=ZTNjOWEzYTUzMGUzNWQwNDk2NDY4ZDM1YWNlMGQwZWI0ZGMwMDFlMCx2SE41TFFrZg%3D%3D)._

**本文由 Digg 的软件工程师 [Alexandra Grant](https://twitter.com/TheFlapjack103) 而作，最初发表在 [Medium](http://t.umblr.com/redirect?z=https%3A%2F%2Fmedium.com%2F%40theflapjack103%2Fthe-way-of-the-gopher-6693db15ae1f&t=ZTNjOWEzYTUzMGUzNWQwNDk2NDY4ZDM1YWNlMGQwZWI0ZGMwMDFlMCx2SE41TFFrZg%3D%3D)。**

I’ve dabbled in JavaScript since college, made a few web pages here and there and while JS was always an enjoyable break from C or Java, I regarded it as a fairly limited language, imbued with the special purpose of serving up animations and pretty little things to make users go “ooh” and “aah”. It was the first language I taught anyone who wanted to learn how to code because it was simple enough to pick up and would quickly deliver tangible results to the developer. Smash it together with some HTML and CSS and you have a web page. Beginner programmers love that stuff.

我在大学时期就开始涉猎 JavaScript 并会随处写一些网页。我把 JS 当作写 C 语言和 Java 时候的一种小憩，并且我认为它是一种相当受限制的语言，它一直在鼓吹能够实现一些令用户叹为观止的特效和动画。我第一次教人编程就是用的 JS，因为它简单易学、能快速给开发者以可见的结果。将它与 HTML 和 CSS 代码写到一起，就能得到一个网页，初学者对此爱不释手。

Then something happened two years ago. At that time, I was in a researchy position working mostly on server-side code and app prototypes for Android. It wasn’t long before Node.js popped up on my radar. Backend JavaScript? Who would take that seriously? At best, it seemed like a new attempt to make server-side development easier at the cost of performance, scalability, etc. Maybe it’s just my ingrained developer skepticism, but there’s always been that alarm that goes off in my brain when I read about something being fast and easy and production-level.

![image](http://ac-Myg6wSTV.clouddn.com/012e5669d7719053f0ef.gif)![image](http://ac-Myg6wSTV.clouddn.com/a512fa1f20bb772ab90d.gif)

Then came the research, the testimonials, the tutorials, the side-projects and 6 months later I realized I had been doing nothing but Node since I first read about it. It was just too easy, especially since I was in the business of prototyping new ideas every couple months. But Node wasn’t just for prototypes and pet projects. Even big boy companies like Netflix had parts of their stack running Node. Suddenly, the world was full of nails and I had found my hammer.

Fast forward another couple months and I’m at my current job as a backend developer for [Digg](http://t.umblr.com/redirect?z=http%3A%2F%2Fdigg.com&t=Y2ZjZDUzMjNkYmVhZmMyMzk5NTE5MzhhOWZlZGM5ZWNkZjIwNWIwZix2SE41TFFrZg%3D%3D). When I joined, back in April of 2015, the stack at Digg was primarily Python with the exception of two services written in, wait for it, Node. I was even more thrilled to be assigned the task of reworking one of the services which had been causing issues in our pipeline.

Our troublesome Node service had a fairly straightforward purpose. Digg uses Amazon S3 for storage which is peachy, except S3 has no support for batch GET operations. Rather than putting all the onus on our Python web server to request up to 100+ keys at a time from S3, the decision was made to take advantage of Node’s easy async code patterns and great concurrency handling. And so Octo, the S3 content fetching service, was born.

Node Octo performed well except for when it didn’t. Once a day it needed to handle a traffic spike where the requests per minute jump from 50 to 200+. Also keep in mind that for each request, Octo typically fetches somewhere between 10–100 keys from S3\. That’s potentially 20,000 S3 GETs a minute. The logs showed that our service slowed down substantially during these spikes, but the trouble was it didn’t always recover. As such, we were stuck bouncing our EC2 instances every couple weeks after Octo would seize up and fall flat on its face.

The requests to the service also pass along a strict timeout value. After the clock hits X number of milliseconds since receiving the request, Octo is suppose to return to the client whatever it has successfully fetched from S3 and move on. However, even with a max timeout of 1200ms, in Octo’s worst moments we had request handling times spiking up to 10 seconds.

The code was heavily asynchronous and we were caching S3 key values aggressively. Octo was also running across 2 medium EC2 instances which we bumped up to 4.

I reworked the code three times, digging deeper than ever into Node optimizations, gotchas, and tricks for squeezing every last bit of performance out of it. I reviewed benchmarks for popular Node webserver frameworks, like Express or Hapi, vs. Node’s built-in HTTP module. I removed any third party modules that, while nice to have, slowed down code execution. The result was three, one-off iterations all suffering from the same issue. No matter how hard I tried, I couldn’t get Octo to timeout properly and I couldn’t reduce the slow down during request spikes.

A theory eventually emerged and it had to do with the way Node’s event loop works. If you don’t know about the event loop, here’s some insight from [Node Source](http://t.umblr.com/redirect?z=https%3A%2F%2Fnodesource.com%2Fblog%2Funderstanding-the-nodejs-event-loop%2F&t=MWZlZjIwMDE0N2NjMTQzYTU5ZDgzYjBhYTM3ZWYwODQ3OWIwNDFlOSx2SE41TFFrZg%3D%3D):

> Node’s “event loop” is central to being able to handle high throughput scenarios. It is a magical place filled with unicorns and rainbows, and is the reason Node can essentially be “single threaded” while still allowing an arbitrary number of operations to be handled in the background.

![image](http://ac-Myg6wSTV.clouddn.com/188c024ccb691dbf3a08.png)

_Not-So Magic Event Loop Blocking (X-Axis: Time in milliseconds)_

You can see when all the unicorns and rainbows went to hell and back again as we bounced the service.

With event loop blocking as the biggest culprit on my list, it was just a matter of figuring why it was getting so backed up in the first place.

Most developers have heard about Node’s non-blocking I/O model; it’s great because it means all requests are handled asynchronously without blocking execution, or incurring any overhead (like with threads and processes) and as the developer you can be blissfully unaware what’s happening in the backend. However, it’s always important to keep in mind that Node is single-threaded which means none of your code runs in parallel. I/O may not block the server but your code certainly does. If I call sleep for 5 seconds, my server will be unresponsive during that time.

![image](http://ac-Myg6wSTV.clouddn.com/279f90490044dceae89e.png)

_Visualizing the Event Loop: [StrongLoop](http://t.umblr.com/redirect?z=https%3A%2F%2Fstrongloop.com%2Fstrongblog%2Fnode-js-performance-event-loop-monitoring%2F&t=NTJhNDYxN2I2YzkzYmYwYThiZDkyZGNhODFjYjM3MDQwNmVkNWVjNyx2SE41TFFrZg%3D%3D)_

And the non-blocking code? As requests are processed and events are triggered, messages are queued along with their respective callback functions. To explain further, here’s an excerpt from a particularly insightful [blog post from Carbon Five](http://t.umblr.com/redirect?z=http%3A%2F%2Fblog.carbonfive.com%2F2013%2F10%2F27%2Fthe-javascript-event-loop-explained%2F&t=MTA5NWNlODA3NDJjMTM3YTQwMmIwZWM2ZThkMzI2YTk5NzBjZmJmYyx2SE41TFFrZg%3D%3D):

> In a loop, the queue is polled for the next message (each poll referred to as a “tick”) and when a message is encountered, the callback for that message is executed. The calling of this callback function serves as the initial frame in the call stack, and due to JavaScript being single-threaded, further message polling and processing is halted pending the return of all calls on the stack. Subsequent (synchronous) function calls add new call frames to the stack…

Our Node service may have handled incoming requests like champ if all it needed to do was return immediately available data. But instead it was waiting on a ton of nested callbacks all dependent on responses from S3 (which can be god awful slow at times). Consequently, when any request timeouts happened, the event and its associated callback was put on an already overloaded message queue. While the timeout event might occur at 1 second, the callback wasn’t getting processed until all other messages currently on the queue, and their corresponding callback code, were finished executing (potentially seconds later). I can only imagine the state of our stack during the request spikes. In fact, I didn’t need to imagine it. A little bit of CPU profiling gave us a pretty vivid picture. Sorry for all the scrolling.

![image](http://ac-Myg6wSTV.clouddn.com/43280c3b75d49c7558b0.png)

_The flames of failure_  

As a quick intro to flame graphs, the y axis represents the number of frames on the stack, where each function is the parent of the function above it. The x axis has to do with the sample population more so than the passage of time. It’s the width of the boxes which show the total time on-CPU; greater width may indicate slower functions or it may simply mean that the function is called more often. You can see in Octo’s flame graph the huge spikes in our stack depth. More detailed info on profiling and flame graphs can be found [here](http://t.umblr.com/redirect?z=http%3A%2F%2Fwww.brendangregg.com%2FFlameGraphs%2Fcpuflamegraphs.html&t=YTE0MDdhMDEwN2RhYjhmM2E1ZTA3ZDIyOGY3MWE3ZTA2MzVkNmIyMCx2SE41TFFrZg%3D%3D).

In light of these realizations, it was time to entertain the idea that maybe Node.js wasn’t the perfect candidate for the job. My CTO and I sat down and had a chat about our options. We certainly didn’t want to continue bouncing Octo every other week and we were both very interested in a [promising case study](http://t.umblr.com/redirect?z=http%3A%2F%2Fmarcio.io%2F2015%2F07%2Fhandling-1-million-requests-per-minute-with-golang%2F&t=ZTlmMjRlZjVmZmM4NjMxYTEyNGM0NDQ4ZDkxMjE5ODQ1NTFhODM3YSx2SE41TFFrZg%3D%3D) that had cropped up on the internet.

If the title wasn’t tantalizing enough, the topic was on creating a service for making PUT requests to S3 (wow, other people have these problems too?). It wasn’t the first time we had talked about using Golang somewhere in our stack and now we had a perfect test subject.

Two weeks later, after my initial crash course introduction to Golang, we had a brand new Octo service up and running. I modeled it closely after the inspiring solution outlined in [Malwarebyte’s](http://t.umblr.com/redirect?z=https%3A%2F%2Fwww.malwarebytes.org%2F&t=ZDgzZjY3ZTIzMzI0ZGZhZmExNGZhNDNlZjZkODA3ZDM4YmMxYTFmZCx2SE41TFFrZg%3D%3D) Golang article; the service has a worker pool and a delegator which passes off incoming jobs to idle workers. Each worker runs on it’s own goroutine, and returns to the pool once the job is done. Simple and effective. The immediate results were pretty spectacular.

![image](http://ac-Myg6wSTV.clouddn.com/64aafd0bd86b8597ec6c.png)

_A nice simmer_

Our average response time from the service was almost cut in half, our timeouts (in the scenario that S3 was slow to respond) were happening on time, and our traffic spikes had minimal effects on the service.

![image](http://ac-Myg6wSTV.clouddn.com/325e8b4df6f127e0a630.png)

_Blue = Node.js Octo | Green = Golang Octo_

With our Golang upgrade, we are easily able to handle 200 requests per minute and 1.5 million S3 item fetches per day. And those 4 load-balanced instances we were running Octo on initially? We’re now doing it with 2.

Since our transition to Golang we haven’t looked back. While the majority of our stack is (and probably will always be) in Python, we’ve begun the process of modularizing our code base and spinning up microservices to handle specific roles in our system. Alongside Octo, we now have 3 other Golang services in production which power our realtime message system and serve up important metadata for our content. We’re also very proud of the newest edition to our Golang codebase, [DiggBot](http://t.umblr.com/redirect?z=http%3A%2F%2Fdigg.com%2Fdiggbot&t=ZjViNWY1YTAyMDQzMjA1ODNmODlhOGZiY2Y4NWY2MTVmMzdkODQ0Yyx2SE41TFFrZg%3D%3D).

This is not to say that Golang is a silver bullet for all our problems. We’re careful to consider the needs of each of our services. As a company, we make the effort to stay on top of new and emerging technologies and to always ask ourselves, can we be doing this better? It’s a constantly evolving process and one that takes careful research and planning.

I’m proud to say that this story has a happy ending as our Octo service has been up and running for a couple months with great success (a few bug fixes aside). For now, Digg is going the way of the Gopher.

![image](http://ac-Myg6wSTV.clouddn.com/406585559a3d18e43467.png)

[](http://t.umblr.com/redirect?z=https%3A%2F%2Fgithub.com%2Fgengo%2Fgoship&t=ZjlkNmY2NjYzZGE1OWY5ZjY3MDc3ODUwNWEzNDkxYTgzNTc1OTYwZix2SE41TFFrZg%3D%3D)_[https://github.com/gengo/goship](http://t.umblr.com/redirect?z=https%3A%2F%2Fgithub.com%2Fgengo%2Fgoship&t=ZjlkNmY2NjYzZGE1OWY5ZjY3MDc3ODUwNWEzNDkxYTgzNTc1OTYwZix2SE41TFFrZg%3D%3D)_



