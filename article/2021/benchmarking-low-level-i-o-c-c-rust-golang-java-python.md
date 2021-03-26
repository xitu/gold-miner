> * 原文地址：[Benchmarking low-level I/O: C, C++, Rust, Golang, Java, Python](https://medium.com/star-gazers/benchmarking-low-level-i-o-c-c-rust-golang-java-python-9a0d505f85f7)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/benchmarking-low-level-i-o-c-c-rust-golang-java-python](https://github.com/xitu/gold-miner/blob/master/article/2021/benchmarking-low-level-i-o-c-c-rust-golang-java-python)
> * 译者：
> * 校对者：

# Benchmarking low-level I/O: C, C++, Rust, Golang, Java, Python

*This post is a continuation of [Measuring network service performance](https://xnuter.medium.com/measuring-network-service-performance-fc987a794ba8).*

When my computer doesn’t have an Internet connection, I find that there is not much I can do with it. Indeed, we mostly use our laptops and smartphones to access information stored or generated somewhere else. It’s even hard to imagine the utility of non-user facing apps without network communication. While the proportion of I/O operations vs. data processing may vary, such operations’ contribution to the service’s latency might well be tangible.

There are many programming languages used for implementing backend services. Because of this, people have a natural interest in comparing the performance of these languages, and there are various benchmarks. For example, there’s [Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/rust-gpp.html), which compares different languages solving different off-line tasks. Another set of benchmarks, [TechEmpower](https://www.techempower.com/benchmarks/), measures the performance of web-frameworks. These measurements are useful and give a rough idea of language performance capabilities. However, they typically measure some specific use-cases and sets of operations, which are not necessarily representative.

All of this made me curious about the irreducible cost of bare-bones I/O on different platforms. Benchmarking TCP Proxies is probably the simplest case. There is no data processing, only handling incoming/outgoing connections and relaying raw byte data. It’s nearly impossible for a micro-service to be faster than a TCP proxy because it cannot do less than that. It can only do more. Any other functionality is built on top of that — parsing, validating, traversing, packing, computing, etc.

The following solutions are being compared:

- `HAProxy`— in TCP-proxy mode. To compare to a mature solution written in C: [http://www.haproxy.org/](http://www.haproxy.org/)
- `draft-http-tunnel` — a simple C++ solution with very basic functionality (`trantor`) (running in TCP mode): [https://github.com/cmello/draft-http-tunnel/](https://github.com/cmello/draft-http-tunnel/) (thanks to [Cesar Mello,](https://github.com/cmello/) who coded it to make this benchmark possible).
- `http-tunnel` — a simple HTTP-tunnel/TCP-proxy written in Rust (`tokio`) (running in TCP mode): [https://github.com/xnuter/http-tunnel/](https://github.com/xnuter/http-tunnel/) (you can read more about it [here](https://medium.com/swlh/writing-a-modern-http-s-tunnel-in-rust-56e70d898700)).
- `tcp-proxy` — a Golang solution: [https://github.com/jpillora/go-tcp-proxy](https://github.com/jpillora/go-tcp-proxy)
- `NetCrusher` — a Java solution (`Java NIO`). Benchmarked on JDK 11, with G1: [https://github.com/NetCrusherOrg/NetCrusher-java/](https://github.com/NetCrusherOrg/NetCrusher-java/)
- `pproxy` — a Python solution based on `asyncio` (running in TCP Proxy mode): [https://pypi.org/project/pproxy/](https://pypi.org/project/pproxy/)

All of the solutions above use Non-blocking I/O. In [my previous post](https://medium.com/swlh/distributed-systems-and-asynchronous-i-o-ef0f27655ce5), I tried to convince the reader that it’s the best way to handle network communication, if you need highly available services with low-latency and large throughput.

A quick note — I tried to pick the best solutions in Golang, Java, and Python, but if you know of better alternatives, feel free to reach out to me.

The actual backend is [Nginx](https://nginx.org/), which is configured to serve 10kb of data in HTTP mode.

Benchmark results are split into two groups:

- *Baseline, C, C++, Rust* —high-performance languages.
- *Rust, Golang, Java, Python* —memory-safe languages.

Yep, Rust belongs to both worlds.

## Brief description of the methodology

- Two cores allocated for TCP Proxies (using [cpuset](https://man7.org/linux/man-pages/man7/cpuset.7.html)).
- Two cores allocated for the backend (Nginx).
- Request rate starts at 10k, ramping up to 25k requests per second (rps).
- Connections being reused for 50 requests (10kb each request).
- Benchmarks ran on the same VM to avoid any network noise.
- The VM instance type is compute optimized (exclusively owns all allocated CPUs) to avoid “noisy neighbors” issues.
- The latency measurement resolution is microsecond (µs).

We are going to compare the following statistics:

- Percentiles (from p50 to p99) — key statistics.
- Outliers (p99.9 and p99.99) — critical for components of large distributed systems.
- Maximum latency — the worst case should never be overlooked.
- Trimmed mean tm99.9 — the mean without the best/worst 0.1%, to capture the central tendency (without outliers).
- Standard deviation — to assess the stability of the latency.

Feel free to [learn more](https://github.com/xnuter/perf-gauge/wiki/Benchmarking-TCP-Proxies-written-in-different-languages:-C,-CPP,-Rust,-Golang,-Java,-Python) about the methodology and why these stats were chosen. To collect data, I used [perf-gauge](https://github.com/xnuter/perf-gauge).

Okay, let’s talk about the results!

## Comparing high-performance languages: C, C++, Rust

I’d often heard that Rust is on par with C/C++ in terms of performance. Let’s see what “on par” exactly means for handling network I/O.

See the four graphs below in the following order: Baseline, C, C++, Rust:

![https://miro.medium.com/max/5200/0*TpgjGrmFE7adwFfJ.png](https://miro.medium.com/max/5200/0*TpgjGrmFE7adwFfJ.png)

Green — p50, Yellow — p90, Blue— p99 in µs (on the left). Orange — rate (on the right)

Below, you’ll see how many microseconds are added on top of the backend for each statistic. The numbers below are averages of the interval at the max request rate (the ramp-up is not included):

![https://miro.medium.com/max/3176/1*5AgvnQCOavorhQ7bRzMFQQ.png](https://miro.medium.com/max/3176/1*5AgvnQCOavorhQ7bRzMFQQ.png)

Overhead, µs

In relative terms (overhead as the percentage of the baseline):

![https://miro.medium.com/max/3168/1*QnPGGlKoGK8_4bPp6Et2VA.png](https://miro.medium.com/max/3168/1*QnPGGlKoGK8_4bPp6Et2VA.png)

Overhead in % of the baseline statistic

Interestingly, while the proxy written in C++ is slightly faster than both HAProxy and Rust at the p99.9 level, it is worse at p99.99 and the max. However, it’s probably a property of the implementation, which is very basic here (and implemented via callbacks, not handling futures).

Also, CPU and Memory consumption was measured. You can see those [here](https://github.com/xnuter/perf-gauge/wiki/Moderate-request-rate#cpu-and-memory-consumption).

> **In conclusion, all three TCP proxies, written in C, C++, and Rust, showed similar performance: lean and stable.**

## Comparing memory-safe languages: Rust, Golang, Java, Python

Now, let’s compare memory-safe languages. Unfortunately, Java and Python’s solutions could not handle 25,000 rps on just two cores, so Java was benchmarked at 15,000 rps and Python at 10,000 rps.

See four graphs below in the following order: Rust, Golang, Java, Python.

![https://miro.medium.com/max/5200/0*lcKL3aLXrgRAw7Ss.png](https://miro.medium.com/max/5200/0*lcKL3aLXrgRAw7Ss.png)

Green — p50, Yellow — p90, Blue— p99 in µs (on the left). Orange — rate (on the right)

Well, now we see a drastic difference. What seemed “noisy” on the previous graph, at the new scale, seems quite stable for Rust. Also, notice a cold-start spike for Java. The numbers below are averages of the interval at the max request rate (the ramp-up is not included):

![https://miro.medium.com/max/3496/1*5SLX8Ei_xGHeFEfUJ_xPtg.png](https://miro.medium.com/max/3496/1*5SLX8Ei_xGHeFEfUJ_xPtg.png)

Overhead, µs

As you can see, Golang is somewhat comparable at the p50/p90 level. However, the difference grows dramatically for higher percentiles, which is reflected by the standard deviation. But look at the Java numbers!

It’s worth looking at the outlier (p99.9 and p99.99) percentiles. It’s easy to tell that the difference with Rust is dramatic:

![https://miro.medium.com/max/5200/0*ojY2YxRh_opeD-HV.png](https://miro.medium.com/max/5200/0*ojY2YxRh_opeD-HV.png)

Green — p99.9, Blue — p99.99 in µs (on the left). Orange — rate (on the right)

In relative terms (the percentage to the baseline Nginx):

![https://miro.medium.com/max/3492/1*BJoEXHHpfx6CvmqUnNbKSw.png](https://miro.medium.com/max/3492/1*BJoEXHHpfx6CvmqUnNbKSw.png)

Overhead in % of the baseline statistic

> **In conclusion, Rust has a much lower latency variance than Golang, Python, and especially Java. Golang is comparable at the p50/p90 latency level with Rust.**

## Maximum throughput

Another interesting question — what is the maximum request rate that each proxy can handle? Again, you can read the [full benchmark](https://github.com/xnuter/perf-gauge/wiki/Maximum-rate) for more info, but for now, here’s a brief summary.

Nginx was able to handle a little over 60,000 rps. If we put a TCP proxy between the client and the backend, it will decrease the throughput. As you can see below, C, C++, Rust, and Golang achieved about 70%–80% of what Nginx served directly, while Java and Python performed worse:

![https://miro.medium.com/max/3632/1*-5c6s4V-gJo6C8ZBQFa9PQ.png](https://miro.medium.com/max/3632/1*-5c6s4V-gJo6C8ZBQFa9PQ.png)

Left axis: latency overhead. Right axis: throughput

- The blue line is `tail` latency (Y-axis on the left) — the lower, the better.
- The grey bars are throughput (Y-axis on the right) — the higher, the better.

## Conclusion

These benchmarks are not comprehensive, and the goal was to compare bare-bones I/O of different languages.

However, along with [Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/rust-gpp.html) and [TechEmpower](https://www.techempower.com/benchmarks/) they show that Rust might be a better alternative to Golang, Java, or Python if predictable performance is crucial for your service. Also, before starting to write a new service in C or C++, it’s worth considering Rust. Because it’s as performant as C/C++, and on top of that:

- Memory-safe
- Data race-free
- Easy to write expressive code.
- In many ways it’s as accessible and flexible as Python.
- It forces engineers to develop an up-front design and understanding of data ownership before launching it in production.
- It has a fantastic community and a vast [library](https://crates.io/) of components.
- Those who have tried it, [love it!](https://stackoverflow.blog/2020/06/05/why-the-developers-who-use-rust-love-it-so-much)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
