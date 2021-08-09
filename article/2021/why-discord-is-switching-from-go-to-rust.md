> * 原文地址：[Why Discord is switching from Go to Rust
](https://blog.discord.com/why-discord-is-switching-from-go-to-rust-a190bbca2b1f)
> * 原文作者：[jesse_11222](https://medium.com/@jesse_11222)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-discord-is-switching-from-go-to-rust.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-discord-is-switching-from-go-to-rust.md)
> * 译者：
> * 校对者：
# Why Discord is switching from Go to Rust
![https://miro.medium.com/max/3274/1*BYeVEgTVQia4MD5LSLoUlA.png](https://miro.medium.com/max/3274/1*BYeVEgTVQia4MD5LSLoUlA.png)

Rust is becoming a first class language in a variety of domains. At Discord, we’ve seen success with Rust on the client side and server side. For example, we use it on the client side for our video encoding pipeline for Go Live and on the server side for [Elixir NIFs](https://blog.discordapp.com/using-rust-to-scale-elixir-for-11-million-concurrent-users-c6f19fc029d3). Most recently, we drastically improved the performance of a service by switching its implementation from Go to Rust. This post explains why it made sense for us to reimplement the service, how it was done, and the resulting performance improvements.

# **The Read States service**

Discord is a product focused company, so we’ll start with some product context. The service we switched from Go to Rust is the “Read States” service. Its sole purpose is to keep track of which channels and messages you have read. Read States is accessed every time you connect to Discord, every time a message is sent and every time a message is read. In short, Read States is in the hot path. We want to make sure Discord feels super snappy all the time, so we need to make sure Read States is quick.

With the Go implementation, the Read States service was not supporting its product requirements. It was fast most of the time, but every few minutes we saw large latency spikes that were bad for user experience. After investigating, we determined the spikes were due to core Go features: its memory model and garbage collector (GC).

# **Why Go did not meet our performance targets**

To explain why Go wasn’t meeting our performance targets, we first need to discuss the data structures, scale, access patterns, and architecture of the service.

The data structure we use to store read state information is conveniently called “Read State”. Discord has billions of Read States. There is one Read State per User per Channel. Each Read State has several counters that need to be updated atomically and often reset to 0. For example, one of the counters is how many @mentions you have in a channel.

In order to get quick atomic counter updates, each Read States server has a Least Recently Used (LRU) cache of Read States. There are millions of Users in each cache. There are tens of millions of Read States in each cache. There are hundreds of thousands of cache updates per second.

For persistence, we back the cache with a Cassandra database cluster. On cache key eviction, we commit your Read States to the database. We also schedule a database commit for 30 seconds in the future whenever a Read State is updated. There are tens of thousands of database writes per second.

In the picture below, you can see the response time and system cpu for a peak sample time frame for the Go service.¹ As you might notice, there are latency and CPU spikes roughly every 2 minutes.

![https://miro.medium.com/max/2134/1*3v779KSfo2OkxUPfPptq_Q.png](https://miro.medium.com/max/2134/1*3v779KSfo2OkxUPfPptq_Q.png)

# **So why 2 minute spikes?**

In Go, on cache key eviction, memory is not immediately freed. Instead, the garbage collector runs every so often to find any memory that has no references and then frees it. In other words, instead of freeing immediately after the memory is out of use, memory hangs out for a bit until the garbage collector can determine if it’s truly out of use. During garbage collection, Go has to do a lot of work to determine what memory is free, which can slow the program down.

These latency spikes definitely smelled like garbage collection performance impact, but we had written the Go code very efficiently and had very few allocations. We were not creating a lot of garbage.

After digging through the Go source code, we learned that Go will force a garbage collection run every [2 minutes at minimum](https://github.com/golang/go/blob/895b7c85addfffe19b66d8ca71c31799d6e55990/src/runtime/proc.go#L4481-L4486). In other words, if garbage collection has not run for 2 minutes, regardless of heap growth, go will still force a garbage collection.

We figured we could tune the garbage collector to happen more often in order to prevent large spikes, so we implemented an endpoint on the service to change the garbage collector [GC Percent](https://golang.org/pkg/runtime/debug/#SetGCPercent) on the fly. Unfortunately, no matter how we configured the GC percent nothing changed. How could that be? It turns out, it was because we were not allocating memory quickly enough for it to force garbage collection to happen more often.

We kept digging and learned the spikes were huge not because of a massive amount of ready-to-free memory, but because the garbage collector needed to scan the entire LRU cache in order to determine if the memory was truly free from references. Thus, we figured a smaller LRU cache would be faster because the garbage collector would have less to scan. So we added another setting to the service to change the size of the LRU cache and changed the architecture to have many partitioned LRU caches per server.

We were right. With the LRU cache smaller, garbage collection resulted in smaller spikes.

Unfortunately, the trade off of making the LRU cache smaller resulted in higher 99th latency times. This is because if the cache is smaller it’s less likely for a user’s Read State to be in the cache. If it’s not in the cache then we have to do a database load.

After a significant amount of load testing different cache capacities, we found a setting that seemed okay. Not completely satisfied, but satisfied enough and with bigger fish to fry, we left the service running like this for quite some time.

During that time we were seeing more and more success with Rust in other parts of Discord and we collectively decided we wanted to create the frameworks and libraries needed to build new services fully in Rust. This service was a great candidate to port to Rust since it was small and self-contained, but we also hoped that Rust would fix these latency spikes. So we took on the task of porting Read States to Rust, hoping to prove out Rust as a service language and improve the user experience.²

# **Memory management in Rust**

> Rust is blazingly fast and memory-efficient: with no runtime or garbage collector, it can power performance-critical services, run on embedded devices, and easily integrate with other languages.³

Rust does not have garbage collection, so we figured it would not have the same latency spikes Go had.

Rust uses a relatively unique memory management approach that incorporates the idea of memory “ownership”. Basically, Rust keeps track of who can read and write to memory. It knows when the program is using memory and immediately frees the memory once it is no longer needed. It enforces memory rules at compile time, making it virtually impossible to have runtime memory bugs.⁴ You do not need to manually keep track of memory. The compiler takes care of it.

So in the Rust version of the Read States service, when a user’s Read State is evicted from the LRU cache it is immediately freed from memory. The read state memory does not sit around waiting for the garbage collector to collect it. Rust knows it’s no longer in use and frees it immediately. There is no runtime process to determine if it should be freed.

# **Async Rust**

But there was a problem with the Rust ecosystem. At the time this service was reimplemented, Rust stable did not have a very good story for asynchronous Rust. For a networked service, asynchronous programming is a requirement. There were a few community libraries that enabled asynchronous Rust, but they required a significant amount of ceremony and the error messages were extremely obtuse.

Fortunately, the Rust team was hard at work on making asynchronous programming easy, and it was available in the unstable nightly channel of Rust.

Discord has never been afraid of embracing new technologies that look promising. For example, we were early adopters of Elixir, React, React Native, and Scylla. If a piece of technology is promising and gives us an advantage, we do not mind dealing with the inherent difficulties and instability of the bleeding edge. This is one of the ways we’ve quickly reached 250+ million users with less than 50 engineers.

Embracing the new async features in Rust nightly is another example of our willingness to embrace new, promising technology. As an engineering team, we decided it was worth using nightly Rust and we committed to running on nightly until async was fully supported on stable. Together we dealt with any problems that arose and at this point Rust stable supports asynchronous Rust.⁵ The bet paid off.

# **Implementation, load testing, and launch**

The actual rewrite was fairly straight forward. It started as a rough translation, then we slimmed it down where it made sense. For instance, Rust has a great type system with extensive support for generics, so we could throw out Go code that existed simply due to lack of generics. Also, Rust’s memory model is able to reason about memory safety across threads, so we were able to throw away some of the manual cross-goroutine memory protection that was required in Go.

When we started load testing, we were instantly pleased with the results. The latency of the Rust version was just as good as Go’s and **had no latency spikes!**

Remarkably, we had only put very basic thought into optimization as the Rust version was written. **Even with just basic optimization, Rust was able to outperform the hyper hand-tuned Go version.** This is a huge testament to how easy it is to write efficient programs with Rust compared to the deep dive we had to do with Go.

But we weren’t satisfied with simply matching Go’s performance. After a bit of profiling and performance optimizations, **we were able to beat Go on every single performance metric**. Latency, CPU, and memory were all better in the Rust version.

The Rust performance optimizations included:

1. Changing to a BTreeMap instead of a HashMap in the LRU cache to optimize memory usage.
2. Swapping out the initial metrics library for one that used modern Rust concurrency.
3. Reducing the number of memory copies we were doing.

Satisfied, we decided to roll out the service.

The launch was fairly seamless because we load tested. We put it out to a single canary node, found a few edge cases that were missing, and fixed them. Soon after that we rolled it out to the entire fleet.

Below are the results.

Go is purple, Rust is blue.

![https://miro.medium.com/max/2142/1*-q1B4t622mnxoV8kvT9RwA.png](https://miro.medium.com/max/2142/1*-q1B4t622mnxoV8kvT9RwA.png)

# **Raising the cache capacity**

After the service ran successfully for a few days, we decided it was time to re-raise the LRU cache capacity. In the Go version, as mentioned above, raising the cap of the LRU cache resulted in longer garbage collections. We no longer had to deal with garbage collection, so we figured we could raise the cap of the cache and get even better performance. We increased the memory capacity for the boxes, optimized the data structure to use even less memory (for fun), and increased the cache capacity to 8 million Read States.

The results below speak for themselves. **Notice the average time is now measured in microseconds and max @mention is measured in milliseconds.**

![https://miro.medium.com/max/1076/1*DkLOxc-PzkqgXUj_nnOPpA.png](https://miro.medium.com/max/1076/1*DkLOxc-PzkqgXUj_nnOPpA.png)

# **Evolving ecosystem**

Finally, another great thing about Rust is that it has a quickly evolving ecosystem. Recently, tokio (the async runtime we use) released version 0.2. We upgraded and it gave us CPU benefits for free. Below you can see the CPU is consistently lower starting around the 16th.

![https://miro.medium.com/max/1060/1*eT1PAnwaAcfCUikJ281v2g.png](https://miro.medium.com/max/1060/1*eT1PAnwaAcfCUikJ281v2g.png)

# **Closing thoughts**

At this point, Discord is using Rust in many places across its software stack. We use it for the game SDK, video capturing and encoding for Go Live, [Elixir NIFs](https://blog.discordapp.com/using-rust-to-scale-elixir-for-11-million-concurrent-users-c6f19fc029d3), several backend services, and more.

When starting a new project or software component, we consider using Rust. Of course, we only use it where it makes sense.

Along with performance, Rust has many advantages for an engineering team. For example, its type safety and borrow checker make it very easy to refactor code as product requirements change or new learnings about the language are discovered. Also, the ecosystem and tooling are excellent and have a significant amount of momentum behind them.

If you made it this far, you’re probably newly excited about Rust or have been excited for quite some time. If you want to work on interesting problems using Rust professionally, you should consider working here at Discord.

Also, a fun fact: the Rust team uses Discord to coordinate. There’s even a very helpful Rust community server that you can find us chatting in from time to time. [Click here to check it out.](https://discord.gg/tcbkpyQ)

[1] Go version 1.9.2. Edit: Graphs are from 1.9.2. We tried versions 1.8, 1.9, and 1.10 without any improvement. The initial port from Go to Rust was completed in May 2019.

[2] To be clear, we don’t think you should rewrite everything in rust just because.

[3] Quote from [https://www.rust-lang.org/](https://www.rust-lang.org/)

[4] Unless, of course, you use **unsafe**.

[5] [https://areweasyncyet.rs/](https://areweasyncyet.rs/)


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
