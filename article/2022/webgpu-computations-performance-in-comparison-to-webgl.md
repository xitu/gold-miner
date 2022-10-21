> * 原文地址：[WebGPU computations performance in comparison to WebGL](https://pixelscommander.com/javascript/webgpu-computations-performance-in-comparison-to-webgl/)
> * 原文作者：[Pixels Commander](http://pixelscommander.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/webgpu-computations-performance-in-comparison-to-webgl.md](https://github.com/xitu/gold-miner/blob/master/article/2022/webgpu-computations-performance-in-comparison-to-webgl.md)
> * 译者：
> * 校对者：

# WebGPU computations performance in comparison to WebGL

WebGPU – the successor of WebGL, a brand new API to utilize GPUs in the browser. It is promised to be available in regular Chrome in Q1 2022. In comparison to WebGL, WebGPU promises better performance and better compatibility with modern hardware, but the most recognizable feature of WebGPU is a special API for performing computations on GPU.

[![Matrices multiplication WebGPU vs WebGL](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)

## Does not WebGL have the same feature?

Yes and no. WebGL does not have a special API for computation but still, there is a hack that makes it possible. Data is being converted into an image, image uploaded to GPU as a texture, texture rendered synchronously with a pixel shader that does an actual computation. Then the result of computation we have as a set of pixels on a `<canvas>` element and we have to read it synchronously with `getPixelsData` then color codes to be converted back to your data. Looks like an inefficient mess, right?

[![WebGL computation pipeline](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-3.png)](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-3.png)

## How WebGPU is different?

API WebGPU provides for computations (compute shaders) is different in the way it is easy to miss the importance of the improvements, however, it empowers developers with absolutely new features. The way it works is:

[![WebGPU computations pipeline](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-4.png)](http://pixelscommander.com/wp-content/uploads/2021/11/computation_schemas-4.png)

## The differences

1. Data uploaded to GPU as a buffer, you do not convert it to pixels so it is cheaper
2. Computation is being performed asynchronously and does not block JS main thread (say hi to real-time post-processing and complex physics simulation at 60FPS)
3. We do not need canvas element and we avoid its limitation on size
4. We do not do expensive and synchronous getPixelsData
5. We do not spend time converting pixels values back to data

So WebGPU’s promise is that we can compute without blocking the main thread and compute faster, but how much faster?

## How do we benchmark?

As a benchmark, we use matrix multiplication which lets us scale the complexity and amount of computations easily.

For example, 16×16 matrix multiplication requires 7936 multiplication operations and 60×60 already gets us 428400 operations.

Sure thing we run the test in an appropriate browser which is Chrome Canary with `#unsafe-webgpu-enabled` flag on.

## Results

The first results were discouraging and WebGL outperformed WebGPU at the bigger numbers:

[![Matrices multiplication benchmark WebGPU incorrect](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-2.png)](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-2.png)

Then I found that the size of a working group (number of operations to calculate in a single batch) is set in code to be as big as the matrix side. It works fine until the matrix side is lower than the number of ALUs on GPU (arithmetic logical unit) which is reflected in WebGPU API as a maximumWorkingGroupSize property. For me, it was 256. Once the working group was set to be less or equal to 256 this is the result we get:

[![Matrices multiplication WebGPU vs WebGL](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)](http://pixelscommander.com/wp-content/uploads/2021/10/Matrices-multiplication-benchmark-1.png)

This is quite impressive while is expected. WebGPU initialization and data transfer times are remarkably lower because we do not convert data to textures and do not read it from pixels. WebGPU performance is significantly higher and gets to 3.5x faster compared to WebGL while it does not block the main thread.

It is also interesting to see WebGL failing after matrix size gets over 4096×4096 because of canvas and texture size limitations while WebGPU is capable to perform for matrices up to 5000×5000 which sounds not much of a difference but actually is 112552823744 more operations to perform and 817216 more values to hold.

Small but interesting fact – both WebGL / WebGPU require some time to warm up while JS goes full power straight away.

## Conclusion

The experiment proved that WebGPU compute shaders are in practice 3.5x faster than WebGL computing with pixel shaders while having significantly higher limits regarding the amount of data to process also it does not block the main thread. This allows new kinds of tasks in the browser: video and audio editing, real-time physics simulation, and more realistic visual effects, machine learning. This is the incomplete list of jobs to benefit from WebGPU where we can expect the new generation of apps to appear and the boundaries of what is possible to do on the Web significantly expanded.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
