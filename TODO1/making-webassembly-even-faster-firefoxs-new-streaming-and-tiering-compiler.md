> * 原文地址：[Making WebAssembly even faster: Firefox’s new streaming and tiering compiler](https://hacks.mozilla.org/2018/01/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler/)
> * 原文作者：[Lin Clark](http://code-cartoons.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler.md)
> * 译者：
> * 校对者：

# Making WebAssembly even faster: Firefox’s new streaming and tiering compiler

People call WebAssembly a game changer because it makes it possible to run code on the web faster. Some of these [speedups are already present](https://hacks.mozilla.org/2017/02/what-makes-webassembly-fast/), and some are yet to come.

One of these speedups is streaming compilation, where the browser compiles the code while the code is still being downloaded. Up until now, this was just a potential future speedup. But with the release of Firefox 58 next week, it becomes a reality.

Firefox 58 also includes a new 2-tiered compiler. The new baseline compiler compiles code 10–15 times faster than the optimizing compiler.

Combined, these two changes mean we compile code faster than it comes in from the network.

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/ezgif-5-73711fc5d3.gif)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/ezgif-5-73711fc5d3.gif)

On a desktop, we compile 30-60 megabytes of WebAssembly code per second. That’s [faster than the network](http://www.speedtest.net/global-index) delivers the packets.

If you use Firefox Nightly or Beta, you can [give it a try](https://lukewagner.github.io/test-tanks-compile-time/) on your own device. Even on a pretty average mobile device, we can compile at 8 megabytes per second —which is faster than the average download speed for pretty much any mobile network.

This means your code executes almost as soon as it finishes downloading.

### Why is this important?

Web performance advocates get prickly when sites ship a lot of JavaScript. That’s because downloading lots of JavaScript makes pages load slower.

This is largely because of the parse and compile times. As [Steve Souders points out](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/), the old bottleneck for web performance used to be the network. But the new bottleneck for web performance is the CPU, and particularly the main thread.

[![Old bottleneck, the network, on the left. New bottleneck, work on the CPU such as compiling, on the right](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/02-500x295.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/02.png)

So we want to move as much work off the main thread as possible. We also want to start it as early as possible so we’re making use of all of the CPU’s time. Even better, we can do less CPU work altogether.

With JavaScript, you can do some of this. You can parse files off of the main thread, as they stream in. But you’re still parsing them, which is a lot of work, and you have to wait until they are parsed before you can start compiling. And for compiling, you’re back on the main thread. This is because JS is usually [compiled lazily](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/), at runtime.

[![Timeline showing packets coming in on the main thread, then parsing happening simultaneously on another thread. Once parse is done, execution begins on main thread, interrupted occassionally by compiling](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/03-500x167.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/03.png)

With WebAssembly, there’s less work to start with. Decoding WebAssembly is much simpler and faster than parsing JavaScript. And this decoding and the compilation can be split across multiple threads.

This means multiple threads will be doing the baseline compilation, which makes it faster. Once it’s done, the baseline compiled code can start executing on the main thread. It won’t have to pause for compilation, like the JS does.

[![Timeline showing packets coming in on the main thread, and decoding and baseline compiling happening across multiple threads simultaneously, resulting in execution starting faster and without compiling breaks.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/04-500x202.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/04.png)

While the baseline compiled code is running on the main thread, other threads work on making a more optimized version. When the more optimized version is done, it can be swapped in so the code runs even faster.

This changes the cost of loading WebAssembly to be more like decoding an image than loading JavaScript. And think about it… web performance advocates do get prickly about JS payloads of 150 kB, but an image payload of the same size doesn’t raise eyebrows.

[![Developer advocate on the left tsk tsk-ing about large JS file. Developer advocate on the right shrugging about large image.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/05-500x218.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/05.png)

That’s because load time is so much faster with images, as Addy Osmani explains in [The Cost of JavaScript](https://medium.com/dev-channel/the-cost-of-javascript-84009f51e99e), and decoding an image doesn’t block the main thread, as Alex Russell discusses in [Can You Afford It?: Real-world Web Performance Budgets](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/).

This doesn’t mean that we expect WebAssembly files to be as large as image files. While early WebAssembly tools created large files because they included lots of runtime, there’s currently a lot of work to make these files smaller. For example, Emscripten has a [“shrinking initiative”](https://github.com/kripken/emscripten/issues/5836). In Rust, you can already get pretty small file sizes using the wasm32-unknown-unknown target, and there are tools like [wasm-gc](https://github.com/alexcrichton/wasm-gc) and [wasm-snip](https://github.com/fitzgen/wasm-snip) which can optimize this even more.

What it does mean is that these WebAssembly files will load much faster than the equivalent JavaScript.

This is big. As [Yehuda Katz points out](https://twitter.com/wycats/status/942908325775077376), this is a game changer.

[![Tweet from Yehuda Katz saying it's possible to parse and compile wasm as fast as it comes over the network.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/06-500x444.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/06.png)

So let’s look at how the new compiler works.

### Streaming compilation: start compiling earlier

If you start compiling the code earlier, you’ll finish compiling it earlier. That’s what streaming compilation does… makes it possible to start compiling the .wasm file as soon as possible.

When you download a file, it doesn’t come down in one piece. Instead, it comes down in a series of packets.

Before, as each packet in the .wasm file was being downloaded, the browser network layer would put it into an ArrayBuffer.

[![Packets coming in to network layer and being added to an ArrayBuffer](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/07-500x255.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/07.png)

Then, once that was done, it would move that ArrayBuffer over to the Web VM (aka the JS engine). That’s when the WebAssembly compiler would start compiling.

[![Network layer pushing array buffer over to compiler](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/08-500x218.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/08.png)

But there’s no good reason to keep the compiler waiting. It’s technically possible to compile WebAssembly line by line. This means you should be able to start as soon as the first chunk comes in.

So that’s what our new compiler does. It takes advantage of WebAssembly’s streaming API.

[![WebAssembly.instantiateStreaming call, which takes a response object with the source file. This has to be served using MIME type application/wasm.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/09-500x132.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/09.png)

If you give `WebAssembly.instantiateStreaming` a response object, the chunks will go right into the WebAssembly engine as soon as they arrive. Then the compiler can start working on the first chunk while the next one is still being downloaded.

[![Packets going directly to compiler](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/10-500x248.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/10.png)

Besides being able to download and compile the code in parallel, there’s another advantage to this.

The code section of the .wasm module comes before any data (which will go in the module’s memory object). So by streaming, the compiler can compile the code while the module’s data is still being downloaded. If your module needs a lot of data, the data can be megabytes, so this can be significant.

[![File split between small code section at the top, and larger data section at the bottom](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/11-500x260.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/11.png)

With streaming, we start compiling earlier. But we can also make compiling faster.

### Tier 1 baseline compiler: compile code faster

If you want code to run fast, you need to optimize it. But performing these optimizations while you’re compiling takes time, which makes compiling the code slower. So there’s a tradeoff.

We can have the best of both of these worlds. If we use two compilers, we can have one that compiles quickly without too many optimizations, and another that compiles the code more slowly but creates more optimized code.

This is called a tiered compiler. When code first comes in, it’s compiled by the Tier 1 (or baseline) compiler. Then, after the baseline compiled code starts running, a Tier 2 compiler goes through the code again and compiles a more optimized version in the background.

Once it’s done, it hot-swaps the optimized code in for the previous baseline version. This makes the code execute faster.

[![Timeline showing optimizing compiling happening in the background.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/12-500x204.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/12.png)

JavaScript engines have been using tiered compilers for a long time. However, JS engines will only use the Tier 2 (or optimizing) compiler when a bit of code gets “warm”… when that part of the code gets called a lot.

In contrast, the WebAssembly Tier 2 compiler will eagerly do a full recompilation, optimizing all of the code in the module. In the future, we may add more options for developers to control how eagerly or lazily optimization is done.

This baseline compiler saves a lot of time at startup. It compiles code 10–15 times faster than the optimizing compiler. And the code it creates is, in our tests, only 2 times slower.

This means your code will be running pretty fast even in those first few moments, when it’s still running the baseline compiled code.

### Parallelize: make it all even faster

In the [article on Firefox Quantum](https://hacks.mozilla.org/2017/11/entering-the-quantum-era-how-firefox-got-fast-again-and-where-its-going-to-get-faster/), I explained coarse-grained and fine-grained parallelization. We use both for compiling WebAssembly.

I mentioned above that the optimizing compiler will do its compilation in the background. This means that it leaves the main thread available to execute the code. The baseline compiled version of the code can run while the optimizing compiler does its recompilation.

But on most computers that still leaves multiple cores unused. To make the best use of all of the cores, both of the compilers use fine-grained parallelization to split up the work.

The unit of parallelization is the function. Each function can be compiled independently, on a different core. This is so fine-grained, in fact, that we actually need to batch these functions up into larger groups of functions. These batches get sent to different cores.

### … then skip all that work entirely by caching it implicitly (future work)

Currently, decoding and compiling are redone every time you reload the page. But if you have the same .wasm file, it should compile to the same machine code.

This means that most of the time, this work could be skipped. And in the future, this is what we’ll do. We’ll decode and compile on first page load, and then cache the resulting machine code in the HTTP cache. Then when you request that URL, it will pull out the precompiled machine code.

This makes load time disappear for subsequent page loads.

[![Timeline showing all work disappearing with caching.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/13-500x217.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/13.png)

The groundwork is already laid for this feature. We’re [caching JavaScript byte code like this](https://blog.mozilla.org/javascript/2017/12/12/javascript-startup-bytecode-cache/) in the Firefox 58 release. We just need to extend this support to caching the machine code for .wasm files.

## About [Lin Clark](http://code-cartoons.com)

Lin is an engineer on the Mozilla Developer Relations team. She tinkers with JavaScript, WebAssembly, Rust, and Servo, and also draws code cartoons.

*   [code-cartoons.com](http://code-cartoons.com)
*   [@linclark](http://twitter.com/linclark)

[More articles by Lin Clark…](https://hacks.mozilla.org/author/lclarkmozilla-com/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
