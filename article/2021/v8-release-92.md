> - 原文地址：[V8 release v9.2](https://v8.dev/blog/v8-release-92)
> - 原文作者：[Ingvar Stepanyan](https://twitter.com/RReverser)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/v8-release-92.md](https://github.com/xitu/gold-miner/blob/master/article/2021/v8-release-92.md)
> - 译者：[finalwhy](https://github.com/finalwhy)
> - 校对者：[Z招锦](https://github.com/zenblofe)

# V8 v9.2 发布

每隔六周，我们会为 V8 创建一个新的分支作为 [发布计划](https://v8.dev/docs/release-process) 的一部分。每个版本都在里程碑 Chrome Beta 之前从 V8 的 master 中创建分支。今天我们很荣幸地宣布我们最新的分支：[V8 v9.2](https://chromium.googlesource.com/v8/v8.git/+log/branch-heads/9.2)，它目前仍处于测试阶段，会在几周后随着 Chrome 92 的稳定版一起发布。V8 v9.2 新增了很多面向开发者的新特性。这篇文章提供了对于本次发布版本中的一些亮点的预览。

## JavaScript

### `at` 方法

新的 `at` 方法现在可以在 `Array`、`TypedArray`、和 `String` 中使用了。当传入的是一个负数时，它将会反向索引可索引的元素。当传入一个正值时，它的行为和直接进行属性访问相同。

## 共享的指针压缩笼

V8 在 64 位平台（包括 x64 和 arm64）上支持[指针压缩](https://v8.dev/blog/pointer-compression)。这是通过将 64 位长度指针拆分为两段来实现的。即将高 32 位视为基数，而将低 32 位视为该基数的索引（译者注：即偏移量）。

```
            |----- 32 bits -----|----- 32 bits -----|
Pointer:    |________base_______|_______index_______|

```

目前，Isolate（译者注：即一个 V8 运行实例，可参见[V8 bindings 设计 isolate，context，world，frame 之间的关系](https://zhuanlan.zhihu.com/p/54135666)） 在一个 4GB 大小的虚拟内存“笼子”内的 GC 堆中执行所有内存分配，这确保了所有指针具有相同的高 32 位基址。由于基址保持不变，因此 64 位指针在传递时只需要传递 32 位的索引，因为完整的指针地址可以通过「基址+索引」来计算。

在 v9.2 中，默认行为变成了进程内的所有 Isolate 共享同一个 4GB 虚拟内存笼。这样做是为了对 JS 中实验性的共享内存功能进行原型设计。由于每个工作线程都有自己的 Isolate，因此各自的 4GB 虚拟内存笼是相互独立的，指针无法在各 Isolate 的内存笼之间传递，因为它们不共享相同的基地址。这项改动还带来了一个额外的提升，即在启动程序时减少了虚拟内存的压力。

这项改动是出于对 V8 总的堆内存大小限制的权衡，V8 将同一个进程中所有线程所使用的堆内存大小限制为 4GB。这种限制对于那些每个进程产生多个线程的服务端工作程序来说是很不友好的，因为这样会更快的耗尽虚拟内存。嵌入器可以使用 GN 参数 `v8_enable_pointer_compression_shared_cage = false` 关闭指针压缩笼的共享。

## V8 API

请使用 `git log branch-heads/9.1..branch-heads/9.2 include/v8.h` 获取 API 改动的完整列表。

对于拥有活跃的 V8 账号的开发者，可以使用 `git checkout -b 9.2 -t branch-heads/9.2` 来试验 V8 v9.2 的新功能。你也可以[订阅 Chrome 的 Beta 版频道](https://www.google.com/chrome/browser/beta.html) 以便尝试新功能。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
