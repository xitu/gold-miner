> * 原文地址：[A million requests per second with Python](https://medium.freecodecamp.com/million-requests-per-second-with-python-95c137af319#.59n519vvy)
* 原文作者：[Paweł Piotr Przeradowski](https://medium.freecodecamp.com/@squeaky_pl?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# A million requests per second with Python #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*nAr_UQ1RcT-2mcfstPLocQ.jpeg">

Is it possible to hit a million requests per second with Python? Probably not until recently.

A lot of companies are migrating away from Python and to other programming languages so that they can boost their operation performance and save on server prices, but there’s no need really. Python can be right tool for the job.

The Python community is doing a lot of around performance lately. CPython 3.6 boosted overall interpreter performance with new dictionary implementation. CPython 3.7 is going to be even faster, thanks to the introduction of faster call convention and dictionary lookup caches.

For number crunching tasks you can use PyPy with its just-in-time code compilation. You can also run NumPy’s test suite, which now has improved overall compatibility with C extensions. Later this year PyPy is expected to reach Python 3.5 conformance.

All this great work inspired me to innovate in one of the areas where Python is used extensively: web and micro-service development.

### Enter Japronto! ###

[Japronto](https://github.com/squeaky-pl/japronto) is a brand new micro-framework tailored for your micro-services needs. Its main goals include being **fast** , **scalable** ,and **lightweight**. It lets you do both **synchronous** and **asynchronous** programming thanks to **asyncio**. And it’s shamelessly **fast**. Even faster than NodeJS and Go.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*FThTeS_kxx3j7AkTgmMKNw.png">

Python micro-frameworks (blue), Dark side of force (green) and Japronto (purple)

**Errata:** As user @heppu points out, Go’s stdlib HTTP server can be **12% faster** than this graph shows when written more carefully. Also there’s an awesome **fasthttp** server for Go that apparently is **only 18% slower** than Japronto in this particular benchmark. Awesome! For details see [https://github.com/squeaky-pl/japronto/pull/12](https://github.com/squeaky-pl/japronto/pull/12)  and [https://github.com/squeaky-pl/japronto/pull/14](https://github.com/squeaky-pl/japronto/pull/14) .

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*z0kap1TTsGimPXTafpW0gw.png">

We can also see that Meinheld WSGI server is almost on par with NodeJS and Go. Despite of its inherently blocking design, it is a great performer compared to the preceding four, which are asynchronous Python solutions. So never trust anyone who says that asynchronous systems are always speedier. They are almost always more concurrent, but there’s much more to it than just that.

I performed this micro benchmark using a “Hello world!” application, but it clearly demonstrates server-framework overhead for a number of solutions.

These results were obtained on an AWS c4.2xlarge instance that had 8 VCPUs, launched in São Paulo region with default shared tenancy and HVM virtualization and magnetic storage. The machine was running Ubuntu 16.04.1 LTS (Xenial Xerus) with the Linux 4.4.0–53-generic x86_64 kernel. The OS was reporting Xeon® CPU E5–2666 v3 @ 2.90GHz CPU. I used Python 3.6, which I freshly compiled from its source code.

To be fair, all the contestants (including Go) were running a single-worker process. Servers were load tested using [wrk](https://github.com/wg/wrk)  with 1 thread, 100 connections, and 24 simultaneous (pipelined) requests per connection (cumulative parallelism of 2400 requests).

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*dy-91Ek-ecUy2kvYUe0Thg.png">

HTTP pipelining (image credit Wikipedia)

[HTTP pipelining](https://en.wikipedia.org/wiki/HTTP_pipelining)  is crucial here since it’s one of the optimizations that Japronto takes into account when executing requests.

Most of the servers execute requests from pipelining clients in the same fashion they would from non-pipelining clients. They don’t try to optimize it. (In fact Sanic and Meinheld will also silently drop requests from pipelining clients, which is a violation of HTTP 1.1 protocol.)

In simple words, pipelining is a technique in which the client doesn’t need to wait for the response before sending subsequent requests over the same TCP connection. To ensure integrity of the communication, the server sends back several responses in the same order requests are received.

### The gory details of optimizations ###

When many small GET requests are pipelined together by the client, there’s a high probability that they’ll arrive in one TCP packet (thanks to [Nagle’s algorithm](https://en.wikipedia.org/wiki/Nagle%27s_algorithm) ) on the server side, then be **read** back by one **system call**.

Doing a system call and moving data from kernel-space to user-space is a very expensive operation compared to, say, moving memory inside process space. That’s why doing it’s important to perform as few as necessary system calls (but no less).

When Japronto receives data and successfully parses several requests out of it, it tries to execute all the requests as fast as possible, glue responses back in correct order, then **write** back in **one system call**. In fact the kernel can aid in the gluing part, thanks to [scatter/gather IO](https://en.wikipedia.org/wiki/Vectored_I/O)  system calls, which Japronto doesn’t use yet.

Note that this isn’t always possible, since some of the requests could take too long, and waiting for them would needlessly increase latency.

Take care when you tune heuristics, and consider the cost of system calls and the expected request completion time.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*Xy5aoOtYNpq4DzPJUU6ihA.png">

Japronto gives a 1,214,440 RPS median of grouped continuous data, calculated as the 50th percentile, using interpolation.

Besides delaying writes for pipelined clients, there are several other techniques that the code employs.

[Japronto](https://github.com/squeaky-pl/japronto) is written almost entirely in C. The parser, protocol, connection reaper, router, request, and response objects are written as C extensions.

[Japronto](https://github.com/squeaky-pl/japronto)  tries hard to delay creation of Python counterparts of its internal structures until asked explicitly. For example, a headers dictionary won’t be created until it’s requested in a view. All the token boundaries are already marked before but normalization of header keys, and creation of several str objects is done when they’re accessed for the first time.

Japronto relies on the excellent picohttpparser C library for parsing status line, headers, and a chunked HTTP message body. Picohttpparser directly employs text processing instructions found in modern CPUs with SSE4.2 extensions (almost any 10-year-old x86_64 CPU has it) to quickly match boundaries of HTTP tokens. The I/O is handled by the super awesome uvloop, which itself is a wrapper around libuv. At the lowest level, this is a bridge to epoll system call providing asynchronous notifications on read-write readiness.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*I_QzQDSDqTVf04SwsEe3IQ.png">

Picohttpparser relies on SSE4.2 and CMPESTRI x86_64 intrinsic to do parsing

Python is a garbage collected language, so care needs to be taken when designing high performance systems so as not to needlessly increase pressure on the garbage collector. The internal design of [Japronto](https://github.com/squeaky-pl/japronto)  tries to avoid reference cycles and do as few allocations/deallocations as necessary. It does this by preallocating some objects into so-called arenas. It also tries to reuse Python objects for future requests if they’re no longer referenced instead of throwing them away.

All the allocations are done as multiples of 4KB. Internal structures are carefully laid out so that data used frequently together is close enough in memory, minimizing the possibility of cache misses.

Japronto tries to not copy between buffers unnecessarily, and does many operations in-place. For example, it percent-decodes the path before matching in the router process.

### Open source contributors, I could use your help. ###

I’ve been working on [Japronto](https://github.com/squeaky-pl/japronto)  continuously for past 3 months — often during weekends, as well as normal work days. This was only possible due to me taking a break from my regular programmer job and putting all my effort into this project.

I think it’s time to share the fruit of my labor with the community.

Currently [Japronto](https://github.com/squeaky-pl/japronto)  implements a pretty solid feature set:

- HTTP 1.x implementation with support for chunked uploads
- Full support for HTTP pipelining
- Keep-alive connections with configurable reaper
- Support for synchronous and asynchronous views
- Master-multiworker model based on forking
- Support for code reloading on changes
- Simple routing

I would like to look into Websockets and streaming HTTP responses asynchronously next.

There’s a lot of work to be done in terms of documenting and testing. If you’re interested in helping, please [contact me directly on Twitter](http://twitter.com/squeaky_pl) . Here’s [Japronto’s GitHub project repository](https://github.com/squeaky-pl/japronto) .

Also, if your company is looking for a Python developer who’s a performance freak and also does DevOps, I’m open to hearing about that. I am going to consider positions worldwide.

### Final words ###

All the techniques that I’ve mentioned here are not really specific to Python. They could be probably employed in other languages like Ruby, JavaScript or even PHP. I’d be interested in doing such work, too, but this sadly will not happen unless somebody can fund it.

I’d like to thank Python community for their continuous investment in performance engineering. Namely Victor Stinner @VictorStinner, [INADA Naoki](https://twitter.com/methane?lang=en)  @methane and Yury Selivanov @1st1 and entire PyPy team.

For the love of Python.
