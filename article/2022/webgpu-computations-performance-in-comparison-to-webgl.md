> * 原文地址：[WebGPU computations performance in comparison to WebGL](https://pixelscommander.com/javascript/webgpu-computations-performance-in-comparison-to-webgl/)
> * 原文作者：[Pixels Commander](http://pixelscommander.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/webgpu-computations-performance-in-comparison-to-webgl.md](https://github.com/xitu/gold-miner/blob/master/article/2022/webgpu-computations-performance-in-comparison-to-webgl.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：[Quincy-Ye](https://github.com/Quincy-Ye) 、[finalwhy](https://github.com/finalwhy)

# WebGPU 与 WebGL 的计算性能差异

WebGPU - WebGL 的替代者，一个在浏览器中调用 GPUs 的全新 API。WebGPU 将在 2022 第一季度的常规 Chrome 中可用。与 WebGL 相比，WebGPU 有着更好的性能以及与现代硬件有着更好的兼容性，WebGPU 最显著的特性是一个在 GPU 中执行计算的特殊 API。

[![Matrices multiplication WebGPU vs WebGL](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)

## WebGL 没有相同的特性吗？

是也不是。WebGL 没有用于（GPU）计算的特殊 API，但仍然存在一种较为“hack”的方法可以实现这一功能。即将数据转换为一张图像，图像作为一个纹理上传到 GPU，随着纹理着色器不断地进行计算，纹理同时会被渲染出来。最后，我们得到的计算结果是 `<canvas>` 元素中的一组像素，我们必须用 `getPixelsData` 同步地读取，然后将颜色代码转换回你的数据。这看起来效率很低，对吧？

[![WebGL computation pipeline](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-3.png)](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-3.png)

## WebGPU 有什么不同呢？

WebGPU 为（计算着色器）提供的 API 是不同的，它很容易忽略改进的重要性，但同时，它为开发者提供了全新的功能。它的工作方式是这样的：

[![WebGPU computations pipeline](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-4.png)](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-4.png)

## 两种方式的差异

1. 数据将作为缓存（buffer）上传到 GPU，你无需再将它转换成一张图片，所以它的性能开销更小
2. 计算是异步执行的，它不会阻塞 JS 主线程（这意味着以 60 帧进行实时后置处理与复杂的物理模拟器的时代已经到来！）
3. 我们将再也不需要创建 canvas 元素了，因此我们可以避开它对于图像尺寸的限制
4. 我们无需做昂贵的、同步的 getPixelsData 操作
5. 我们无需花费时间在像素转换回值数据上

所以 WebGPU 可以让我们无需阻塞主线程进行更快的计算，但，能快多少呢？

## 我们如何做基准测试呢？

作为基准测试，我们用矩阵乘法，这让我们更轻松地提高计算的复杂性与计算量。

举个例子，16×16 矩阵乘法需要 7936 次乘法运算，60×60 需要 428400 次乘法运算。

当然，我们需要在一个合适的浏览器中运行测试，此处我们选用开启了 `#unsafe-webgpu-enabled` 选项的 Chrome Canary。

## 结果

首次结果让人诅丧，WebGL 在更大的数字上表现优于 WebGPU：

[![Matrices multiplication benchmark WebGPU incorrect](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-2.png)](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-2.png)

然后，我发现一个工作组的大小(在单个批处理中要计算的操作数量)在代码中被设置为与矩阵边一样大。它可以正常运行，直到矩阵侧低于 GPU 上的 ALUs（运算逻辑单位）数量，这在 WebGPU 中反映为 maximumWorkingGroupSize 属性。对于我，它是 256。当工作组设置小于等于 256 时，这是我们得到的结果：

[![Matrices multiplication WebGPU vs WebGL](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)

这是意料之外，但也在情理之中。WebGPU 初始化与数据传输时间非常短，因为我们不需要转换数据为纹理，也无需从像素中读取它。WebGPU 性能明显更高，比 WebGL 快 3.5 倍有余 ，同时它不会阻塞主线程。

另一件有趣的事是，由于 canvas 和纹理的大小限制，WebGL 在矩阵超过 4096×4096 之后就会失败，同时 WebGPU 能够执行到 5000×5000 的矩阵，这听起来差不多，但实际上多出了 112552823744 次运算和 817216 个值要维护。

一个小但有趣的事实 - WebGL 与 WebGPU 都需要一些时间进行预热操作，而 JS 则可以直接全速运行。

## 结论

实验证明，WebGPU 计算着色器比使用像素着色器的 WebGL 计算速度快 3.5 倍，同时在处理大量数据量方面有明显更高的限制，并且它不会阻塞主线程。这允许在浏览器中执行新类型任务：视频与音频编辑，实时物理模拟器，以及更逼真的视觉效果，机器学习。而这仅仅是（目前可以想到的）能从 WebGPU 中获益的部分业务，我们可以期待新一代应用的出现，以及在 Web 上可能做的事情的边界显著扩展。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
