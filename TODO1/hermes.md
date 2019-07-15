> * 原文地址：[Hermes: An open source JavaScript engine optimized for mobile apps, starting with React Native](https://code.fb.com/android/hermes/)
> * 原文作者：[Marc Horowitz](https://code.fb.com/android/hermes/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/hermes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/hermes.md)
> * 译者：
> * 校对者：

# Hermes: An open source JavaScript engine optimized for mobile apps, starting with React Native

![](https://code.fb.com/wp-content/uploads/2019/07/HermesOSSChainReact_blog_FIN_1-1.gif)

Mobile applications are growing larger and more complex. Larger apps using JavaScript frameworks often experience performance issues as developers add features and complexity. These issues are generated from various spots, but the people using these apps expect them to run smoothly, regardless of the device they are on.

To increase the performance of Facebook’s apps, we have teams that continuously improve our JavaScript code and platforms. As we analyzed performance data, we noticed that the JavaScript engine itself was a significant factor in startup performance and download size. With this data in hand, we knew we had to optimize JavaScript performance in the more constrained environments of a mobile phone compared with a desktop or laptop. After exploring other options, we built a new JavaScript engine we call Hermes. It is designed to improve app performance, focusing on our React Native apps, even on mass-market devices with limited memory, slow storage, and reduced computing power.

At [Chain React 2019](https://infinite.red/ChainReactConf), we announced the Hermes JavaScript engine. We have [open-sourced the Hermes engine](https://github.com/facebook/hermes), as well as [integration with Hermes for React Native](https://facebook.github.io/react-native/docs/hermes/). We are excited to work with the open source community and have developers start using Hermes today.

## How Hermes improves React Native performance

For JavaScript-based mobile applications, user experience benefits from attention to a few primary metrics:

* The time it takes for the app to become usable, called time to interact (TTI)
* The download size (on Android, APK size)
* Memory utilization

![](https://code.fb.com/wp-content/uploads/2019/07/hermesstats-1.jpg)

Metrics for MatterMost React Native app running on a Google Pixel, similar in performance to popular phones in markets like India.

Notably, our primary metrics are relatively insensitive to the engine’s CPU usage when executing JavaScript code. Focusing on these metrics leads to strategies and trade-offs that differ from most existing JavaScript engines today. Consequently, our team designed and built Hermes from scratch. As a result of this focus, our implementation provides substantial improvement for React Native applications. 

Because Hermes is optimized for mobile apps, we do not have plans to integrate it with any browsers or with server infrastructure such as Node.js. Existing JavaScript engines remain preferable in those environments.

## Key Hermes architectural decisions

Mobile device limitations, such as smaller amounts of RAM and slower flash, led us to make certain architectural decisions. To optimize for this environment, we implemented the following:

### Bytecode precompilation

Commonly, a JavaScript engine will parse the JavaScript source after it is loaded, generating bytecode. This step delays the start of JavaScript execution. To skip this step, Hermes uses an ahead-of-time compiler, which runs as part of the mobile application build process. As a result, more time can be spent optimizing the bytecode, so the bytecode is smaller and more efficient. Whole-program optimizations can be performed, such as function deduplication and string table packing.

The bytecode is designed so that at runtime, it can be mapped into memory and interpreted without needing to eagerly read the entire file. Flash memory I/O adds significant latency on many medium and low-end mobile devices, so loading bytecode from flash only when needed and optimizing bytecode for size leads to significant TTI improvements. In addition, because the memory is mapped read-only and backed by a file, mobile operating systems that don’t swap, such as Android, can still evict these pages under memory pressure. This reduces out-of-memory process kills on memory constrained devices.

![](https://code.fb.com/wp-content/uploads/2019/07/HermesOSSChainReact_blog_FIN_1-1.gif)

Although compressed bytecode is a bit larger than compressed JavaScript source code, because Hermes’s native code size is smaller, Hermes decreases overall application size for Android React Native apps.

### No JIT

To speed execution, most widely used JavaScript engines can lazily compile frequently interpreted code to machine code. This work is performed by a just-in-time (JIT) compiler.

Hermes today has no JIT compiler. This means that Hermes underperforms some benchmarks, especially those that depend on CPU performance. This was an intentional choice: These benchmarks are generally not representative of mobile application workloads. We have done some experimentation with JITs, but we believe that it would be quite challenging to achieve beneficial speed improvements without regressing our primary metrics. Because JITs must warm up when an application starts, they have trouble improving TTI and may even hurt TTI. Also, a JIT adds to native code size and memory consumption, which negatively affects our primary metrics. A JIT is likely to hurt the metrics we care about most, so we chose not to implement a JIT. Instead, we focused on interpreter performance as the right trade-off for Hermes.

### Garbage collector strategy

On mobile devices, efficient use of memory is especially important. Lower-end devices have limited memory, OS swapping does not generally exist, and operating systems aggressively kill applications that use too much memory. When apps are killed, slow restarts are required and background functionality suffers. In early testing, we learned that virtual address (VA) space, especially contiguous VA space, can be a limited resource in large applications on 32-bit devices even with lazy allocation of physical pages. 

To minimize memory and VA space used by the engine, we have built a garbage collector with the following features:

* On-demand allocation: Allocates VA space in chunks only as needed.
* Noncontiguous: VA space need not be in a single memory range, which avoids resource limits on 32-bit devices.
* Moving: Being able to move objects means memory can be defragmented and chunks that are no longer needed are returned to the operating system.
* Generational: Not scanning the entire JavaScript heap every GC reduces GC times.

## Developer experience

To start using Hermes, developers will need to make a few changes to their `build.gradle` files and recompile the app. See the [full instructions for the migration to use Hermes on React Native.](https://facebook.github.io/react-native/docs/hermes/)

```javascript
 project.ext.react = [
  entryFile: "index.js",
  enableHermes: true
]
```

### Lazy compilation

Iteration speed is one of the main benefits of a JavaScript-based platform, but compiling bytecode in advance would chip away at this advantage. To keep reloads fast, Hermes debug builds don’t use ahead-of-time compilation; instead, they generate bytecode lazily on device. This allows for rapid iteration using Metro or another source of plain JavaScript code to run. The trade-off is that lazy-compiled bytecode does not include all the optimizations of a production build. In practice, although we can measure the difference in performance, we have found this approach is sufficient to provide a good developer experience without affecting production metrics.

### Standards-compliant

Hermes currently targets the ES6 specification, and we intend to keep current with the JavaScript specification as it evolves. To keep the engine’s size small, we have chosen not to support a few language features that do not appear to be commonly used in React Native apps, such as proxies and local `eval()`. A [complete list can be found at our GitHub](https://github.com/facebook/hermes/blob/master/doc/Features.md#excluded-from-support).

### Debugging

To provide a great debugging experience, we implemented support for Chrome remote debugging via the DevTools protocol. Until today, React Native has supported debugging using only an in-app proxy to run the application JavaScript code in Chrome. This support made it possible to debug apps, but not synchronous native calls in the React Native bridge. Support for the remote debugging protocol allows developers to attach to the Hermes engine running on their device and debug their applications natively, using the same engine as in production. We are also looking into implementing additional support for the Chrome DevTools protocol besides debugging.

![](https://code.fb.com/wp-content/uploads/2019/07/Hermes-screenshot.jpg)

## Enabling improvements to React Native

To ease migration efforts to Hermes and continue supporting JavaScriptCore on iOS, we built JSI, a lightweight API for embedding a JavaScript engine in a C++ application. This API has made it possible for React Native engineers to implement their own infrastructure improvements. JSI is used by Fabric, which allows for preemption of React Native rendering, and by TurboModules, which allow for lighter weight native modules that can be lazy loaded as needed by a React Native application.

React Native was our initial use case and has informed much of our work to date, but we aren’t stopping there. We intend to build time and memory profiling tools to make it easier for developers to improve their applications. We would like to fully support the Visual Studio Code debugger protocol, including completion and other features not available today. We’d also like to see other mobile use cases. 

No open source project can be successful without engagement from the community. We’d love for you to [try Hermes in your React Native apps](https://facebook.github.io/react-native/docs/hermes/), see how it works, and help us [make Hermes better for everyone](https://github.com/facebook/hermes/issues). We are especially interested in seeing which use cases the community finds useful, both inside and outside of React Native.

We’d like to thank Tzvetan Mikov, Will Holen, and the rest of the Hermes team for their work to build and open-source Hermes.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
