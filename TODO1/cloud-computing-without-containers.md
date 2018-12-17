> * 原文地址：[Cloud Computing without Containers](https://blog.cloudflare.com/cloud-computing-without-containers/)
> * 原文作者：[Zack Bloom](https://blog.cloudflare.com/author/zack-bloom/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cloud-computing-without-containers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cloud-computing-without-containers.md)
> * 译者：
> * 校对者：

# Cloud Computing without Containers

Cloudflare has a cloud computing platform called [Workers](https://www.cloudflare.com/products/cloudflare-workers/). **Unlike essentially every other cloud computing platform I know of, it doesn’t use containers or virtual machines.** We believe that is the future of Serverless and cloud computing in general, and I’ll try to convince you why.

### Isolates

![](https://blog.cloudflare.com/content/images/2018/10/Artboard-42@3x.png)

Two years ago we had a problem. We were limited in how many features and options we could build in-house, we needed a way for customers to be able to build for themselves. We set out to find a way to let people write code on our servers deployed around the world (we had a little over a hundred data centers then, 155 as of this writing). Our system needed to run untrusted code securely, with low overhead. We sit in front of ten million sites and process millions and millions of requests per second, it also had to run very very quickly.

The Lua we had used previously didn’t run in a sandbox; customers couldn’t write their own code without our supervision. Traditional virtualization and container technologies like Kubernetes would have been exceptionally expensive for everyone involved. Running thousands of Kubernetes pods in a single location would be resource intensive, doing it in 155 locations would be even worse. Scaling them would be easier than without a management system, but far from trivial.

What we ended up settling on was a technology built by the Google Chrome team to power the Javascript engine in that browser, V8: Isolates.

Isolates are lightweight contexts that group variables with the code allowed to mutate them. Most importantly, a single process can run hundreds or thousands of Isolates, seamlessly switching between them. They make it possible to run untrusted code from many different customers within a single operating system process. They’re designed to start very quickly (several had to start in your web browser just for you to load this web page), and to not allow one Isolate to access the memory of another.

We pay the overhead of a Javascript runtime once, and then are able to run essentially limitless scripts with almost no individual overhead. Any given Isolate can start around a hundred times faster than I can get a Node process to start on my machine. Even more importantly, they consume an order of magnitude less memory than that process.

They have all the lovely function-as-a-service ergonomics of getting to just write code and not worry how it runs or scales. Simultaneously, they don’t use a virtual machine or a container,  which means **you are actually running _closer_ to the metal than any other form of cloud computing I’m aware of**. I believe it’s possible with this model to get close to the economics of running code on bare metal, but in an entirely Serverless environment.

This is not meant to be an ad for Workers, but I do want to show you a chart to reflect just how stark the difference is, to showcase why I believe this is not iterative improvement but an actual paradigm shift:

![](https://blog.cloudflare.com/content/images/2018/10/image-2.png)

This data reflects actual requests (including network latency) made from a data center near where all the functions were deployed, performing a CPU intensive workload. [Source](https://blog.cloudflare.com/serverless-performance-with-cpu-bound-tasks/)

### Cold Starts

![](https://blog.cloudflare.com/content/images/2018/10/Cold-start@3x.png)

Not everyone fully understands how a traditional Serverless platform like Lambda works. It spins up a containerized process for your code. It isn’t running your code in any environment more lightweight than running Node on your own machines. What it does do is auto-scale those processes (somewhat clumsily). That auto-scaling creates cold-starts.

A cold-start is what happens when a new copy of your code has to be started on a machine. In the Lambda world this amounts to spinning up a new containerized process which can take between 500 milliseconds and 10 seconds. Any requests you get will be left hanging for as much as ten seconds, a terrible user experience. As a Lambda can only process a single request at a time, a new Lambda must be cold-started every time you get an additional concurrent request. This means that laggy request can happen over and over. If your Lambda doesn’t get a request soon enough, it will be shut down and it all starts again. Whenever you deploy new code it all happens again as every Lambda has to be redeployed. This has been correctly cited as a reason Serverless is not all it’s cracked up to be.

Because Workers don’t have to start a process, Isolates start in 5 milliseconds, a duration which is imperceptible. Isolates similarly scale and deploy just as quickly, entirely eliminating this issue with existing Serverless technologies.

### Context Switching

![](https://blog.cloudflare.com/content/images/2018/10/multitasking-bars@3x.png)

One key feature of an operating system is it gives you the ability to run many processes at once. It transparently switches between the various processes which would like to run code at any given time. To accomplish that it does what’s called a ‘context switch’: moving all of the memory required for one process out, and the memory required for the next in.

That context switch can take as much as 100 microseconds. When multiplied by all the Node, Python or Go processes running on your average Lambda server this creates a heavy overhead which means not all of the CPUs power can actually be devoted to running the customer’s code; it’s spent switching between them.

An Isolate-based system runs all of the code in a single process and uses its own mechanisms to ensure safe memory access. This means there are no expensive context switches, the machine spends virtually all of its time running your code.

### Memory

**The Node or Python runtimes were meant to be run by individual people on their own servers. They were never intended to be run in a multi-tenant environment with thousands of other people’s code and strict memory requirements.** A basic Node Lambda running no real code consumes 35 MB of memory. When you can share the runtime between all of the Isolates as we do, that drops to around 3 MB.

Memory is often the highest cost of running a customer’s code (even higher than the CPU), lowering it by an order of magnitude dramatically changes the economics.

Fundamentally V8 was designed to be multi-tenant. It was designed to run the code from the many tabs in your browser in isolated environments within a single process. Node and similar runtimes were not, and it shows in the multi-tenant systems which are built atop it.

### Security

Running multiple customers' code within the same process obviously requires paying careful attention to security. It wouldn’t have been productive or efficient for Cloudflare to build that isolation layer ourselves. It takes an astronomical amount of testing, fuzzing, penetration testing, and bounties required to build a truly secure system of that complexity.

The only reason this was possible at all is the open-source nature of V8, and its standing as perhaps the most well security tested piece of software on earth. We also have a few layers of security built on our end, including various protections against timing attacks, but V8 is the real wonder that makes this compute model possible.

### Billing

This is not meant to be a referendum on AWS billing, but it’s worth a quick mention as the economics are interesting. Lambdas are billed based on how long they run for. That billing is rounded up to the nearest 100 milliseconds, meaning people are overpaying for an average of 50 milliseconds every execution. Worse, they bill you for the entire time the Lambda is running, even if it’s just waiting for an external request to complete. As external requests can take hundreds or thousands of ms, you can end up paying ridiculous amounts at scale.

Isolates have such a small memory footprint that we, at least, can afford to only bill you while your code is actually executing.

In our case, due to the lower overhead, Workers end up being around 3x cheaper per CPU-cycle. A Worker offering 50 milliseconds of CPU is $0.50 per million requests, the equivalent Lambda is $1.84 per million. I believe lowering costs by 3x is a strong enough motivator that it alone will motivate companies to make the switch to Isolate-based providers.

### The Network is the Computer

Amazon has a product called Lambda@Edge which is deployed to their CDN data centers. Unfortunately, it’s three times more expensive than traditional Lambda, and it takes 30 minutes to deploy initially. It also doesn't allow arbitrary requests, limiting its usefulness to CDN-like-purposes.

Conversely, as I mentioned, with Isolates we are able to deploy every source file to 155 data centers at better economics than Amazon can do it to one. It might actually be cheaper to run 155 Isolates than a single container, or perhaps Amazon is charging what the market will bear and it’s much higher than their costs. I don’t know Amazon’s economics, I do know we’re very comfortable with ours.

Long-ago it became clear that to have a truly reliable system it must be deployed to more than one place on earth. A Lambda runs in a single availability zone, in a single region, in a single data center.

### Disadvantages

No technology is magical, every transition comes with disadvantages. An Isolate-based system can’t run arbitrary compiled code. Process-level isolation allows your Lambda to spin up any binary it might need. In an Isolate universe you have to either write your code in Javascript (we use a lot of TypeScript), or a language which targets WebAssembly like Go or Rust.

If you can’t recompile your processes, you can’t run them in an Isolate. This might mean Isolate-based Serverless is only for newer, more modern, applications in the immediate future. It also might mean legacy applications get only their most latency-sensitive components moved into an Isolate initially. The community may also find new and better ways to transpile existing applications into WebAssembly, rendering the issue moot.

### Your Help

![](https://blog.cloudflare.com/content/images/2018/10/no-VM-@3x-3.png)

I would love for you to [try Workers](https://developers.cloudflare.com/workers/about/) and let us and the community know about your experience. There is still a lot for us to build, we could use your feedback.

We also need engineers and product managers who think this is interesting and want to take it in new directions. If you’re in San Francisco, Austin, or London, please reach out.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
