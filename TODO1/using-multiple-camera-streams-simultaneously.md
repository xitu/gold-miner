> * 原文地址：[Using multiple camera streams simultaneously](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-multiple-camera-streams-simultaneously.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-multiple-camera-streams-simultaneously.md)
> * 译者：[zx-Zhu](https://github.com/zx-Zhu)
> * 校对者：

# 同时使用多个相机流

这篇文章是当前关于 Android 相机介绍中最新的一篇，我们之前介绍过[相机阵列](https://medium.com/androiddevelopers/camera-enumeration-on-android-9a053b910cb5)和[相机会话和请求](https://medium.com/androiddevelopers/understanding-android-camera-capture-sessions-and-requests-4e54d9150295)。

### 多个相机流的使用场景

一个相机应用可能希望同时使用多个帧流，在某些情况下不同的流甚至需要不同的帧分辨率或像素格式；以下是一些典型使用场景：

*   录像：一个流用于预览，另一个用于并编码保存成文件
*   扫描条形码：一个流用于预览，另一个用于条形码检测
*   计算摄影学：一个流用于预览，另一个用于人脸或场景的检测

正如我们在[之前的文章](https://medium.com/androiddevelopers/understanding-android-camera-capture-sessions-and-requests-4e54d9150295)中讨论的那样，当我们处理帧时，存在较大的性能成本，并且这些成本在并行流 / 流水线处理中还会成倍增长。

 CPU、GPU 和 DSP 这样的资源可以利用框架的[重新处理](https://developer.android.com/reference/android/hardware/camera2/CameraDevice#createReprocessCaptureRequest%28android.hardware.camera2.TotalCaptureResult%29)能力，但是像内存这样的资源需求将线性增长。

### 每次请求对应多个目标

通过执行某种官方程序，多相机流可以整合成一个 [CaptureRequest](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest)，此代码段表明了如何使用一个流开启相机会话进行相机预览并使用另一个流进行图像处理：

```
val session: CameraCaptureSession = ...  // from CameraCaptureSession.StateCallback

// 我们将使用预览捕获模板来组合流，因为
// 它针对低延迟进行了优化; 用于高质量的图像时使用
// TEMPLATE_STILL_CAPTURE 用于高速和稳定的帧速率时使用
// TEMPLATE_RECORD
val requestTemplate = CameraDevice.TEMPLATE_PREVIEW
val combinedRequest = session.device.createCaptureRequest(requestTemplate)

// Link the Surface targets with the combined request
combinedRequest.addTarget(previewSurface)
combinedRequest.addTarget(imReaderSurface)

// 在我们的样例中，SurfaceView 会自动更新。
// ImageReader 有自己的回调，我们必须监听，以检索帧
// 所以不需要为捕获请求设置回调
session.setRepeatingRequest(combinedRequest.build(), null, null)
```

如果你正确的配置了目标 surfaces，则此代码将仅生成满足  [StreamComfigurationMap.GetOutputMinFrameDuration(int, Size)](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap#getOutputMinFrameDuration%28int,%20android.util.Size%29) 和 [StreamComfigurationMap.GetOutputStallDuration(int, Size)](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap.html#getOutputStallDuration%28int,%20android.util.Size%29) 确定的最小 FPS 的流。实际表现还会因机型而异，Android 给了我们一些保证，可以根据**输出类型**，**输出大小**和**硬件级别**三个变量来支持特定组合。使用不支持的参数组合可能会以低帧率工作，甚至不能工作，触发其中一个故障回调。[文档](https://developer.android.com/reference/android/hardware/camera2/CameraDevice#createCaptureSession%28java.util.List%3Candroid.view.Surface%3E,%20android.hardware.camera2.CameraCaptureSession.StateCallback,%20android.os.Handler%29)非常详细地描述了保证工作的内容，强烈推荐完整阅读，我们在此将介绍基础知识。

### 输出类型

**输出类型**指的是帧编码格式，文档描述中支持的类型有 PRIV、YUV、JEPG 和 RAW。文档很好的解释了他们：

> PRIV 指的是使用了 [StreamConfigurationMap.getOutputSizes(Class)](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap#getOutputSizes%28java.lang.Class%3CT%3E%29) 获取可用尺寸的任何目标，没有直接的应用程序可见格式

> YUV 指的是目标 surface 使用了[ImageFormat.YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888) 编码格式

> JPEG 指的是 [ImageFormat.JPEG](https://developer.android.com/reference/android/graphics/ImageFormat#JPEG) 格式

> RAW 指的是 [ImageFormat.RAW_SENSOR](https://developer.android.com/reference/android/graphics/ImageFormat#RAW_SENSOR) 格式

当选择应用程序的输出类型时，如果目标是使兼容性最大化，推荐使用 [ImageFormat.YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888) 做帧分析并使用 [ImageFormat.JPEG](https://developer.android.com/reference/android/graphics/ImageFormat#JPEG) 保存图像。对于预览和录像传感器来说，你可能会用一个 `SurfaceView`, `TextureView`, `MediaRecorder`, `MediaCodec` 或者 `RenderScript.Allocation` 。在这些情况下，不指定图像格式，出于兼容性目的，他将被计为 [ImageFormat.PRIVATE](https://developer.android.com/reference/android/graphics/ImageFormat#PRIVATE) （不管它的实际格式是什么）。去查看设备支持的格式可以使用如下代码：

```
val characteristics: CameraCharacteristics = ...
val supportedFormats = characteristics.get(
            CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP).outputFormats
```

### 输出大小

我们调用 [StreamConfigurationMap.getOutputSizes()](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap.html#getOutputSizes%28int%29) 可列出所有可用的**输出大小**，但随着兼容性的发展，我们只需要关心两种：PREVIEW 和 MAXIMUM。我们可以将这种大小视为上限；如果文档中说的 PREVIEW 的大小有效，那么任何比 PREVIEW 尺寸小的都可以，MAXIMUM 同理。这有一个[文档](https://developer.android.com/reference/android/hardware/camera2/CameraDevice)的相关摘录：

> 对于尺寸最大的列，PREVIEW 意味着适配屏幕的最佳尺寸，或 1080p（1920x1080）,以较小者为准。RECORD 指的是相机支持的最大分辨率由 [CamcorderProfile](https://developer.android.com/reference/android/media/CamcorderProfile.html) 确定。MAXIMUM 还指 StreamConfigurationMap.getOutputSizes(int)中相机设备对该格式或目标的最大输出分辨率。

注意，可用的输出尺寸取决于选择的格式。给定 [CameraCharacteristics](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics) ，我们可以像这样查询可用的输出尺寸：

```
val characteristics: CameraCharacteristics = ...
val outputFormat: Int = ...  // 比如 ImageFormat.JPEG
val sizes = characteristics.get(
        CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
        .getOutputSizes(outputFormat)
```

在相机预览和录像的使用场景中，我们应该使用目标类来确定支持的大小，因为文件格式将由相机框架自身处理：

```
val characteristics: CameraCharacteristics = ...
val targetClass: Class<T> = ...  // 比如 SurfaceView::class.java
val sizes = characteristics.get(
        CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
        .getOutputSizes(targetClass)
```

获取到 MAXIMUM 的尺寸很简单——只需要将输出尺寸排序然后返回最大的：

```
fun <T>getMaximumOutputSize(
        characteristics: CameraCharacteristics, targetClass: Class<T>, format: Int? = null):
        Size {
    val config = characteristics.get(
            CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)

    // 如果提供图像格式，请使用它来确定支持的大小; 否则使用目标类
    val allSizes = if (format == null)
        config.getOutputSizes(targetClass) else config.getOutputSizes(format)
    return allSizes.sortedWith(compareBy { it.height * it.width }).reversed()[0]
}
```

获取 PREVIEW 的尺寸就需要动下脑子了。回想一下，PREVIEW 指的是适配屏幕的最佳尺寸，或者 1080p (1920x1080)，取较小者。请记住，长宽比可能与屏幕的不匹配，如果我们打算全屏显示，我们需要显示黑边或者裁剪。为了获取到正确的预览尺寸，我们需要对比可用的输出尺寸和显示尺寸，同时考虑到可以旋转显示。在这段代码里，我们还封装了一个辅助类 `SmartSize` 用来横简单的比较尺寸大小：

```
class SmartSize(width: Int, height: Int) {
    var size = Size(width, height)
    var long = max(size.width, size.height)
    var short = min(size.width, size.height)
}

fun getDisplaySmartSize(context: Context): SmartSize {
    val windowManager = context.getSystemService(
            Context.WINDOW_SERVICE) as WindowManager
    val outPoint = Point()
    windowManager.defaultDisplay.getRealSize(outPoint)
    return SmartSize(outPoint.x, outPoint.y)
}

fun <T>getPreviewOutputSize(
        context: Context, characteristics: CameraCharacteristics, targetClass: Class<T>,
        format: Int? = null): Size {

    // 比较哪个更小：屏幕尺寸还是 1080p
    val hdSize = SmartSize(1080, 720)
    val screenSize = getDisplaySmartSize(context)
    val hdScreen = screenSize.long >= hdSize.long || screenSize.short >= hdSize.short
    val maxSize = if (hdScreen) screenSize else hdSize

    // 如果提供图像格式，请使用它来确定支持的大小; 否则使用目标类
    val config = characteristics.get(
            CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
    val allSizes = if (format == null)
        config.getOutputSizes(targetClass) else config.getOutputSizes(format)

    // 获取可用尺寸并按面积从最大到最小排序
    val validSizes = allSizes
            .sortedWith(compareBy { it.height * it.width })
            .map { SmartSize(it.width, it.height) }.reversed()

    // 然后，获得小于或等于最大尺寸的最大输出尺寸
    return validSizes.filter {
        it.long <= maxSize.long && it.short <= maxSize.short }[0].size
}
```

### 硬件层次

要决定运行时可用能力，相机应用需要的最重要的信息是支持的**硬件级别**。再一次，我们可以从此[文档](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#INFO_SUPPORTED_HARDWARE_LEVEL)学习：

> 支持的硬件级别是摄像机设备功能的上层描述，汇总出多种功能到一个字段中。每一等级相比前一等级都新增了一些功能，并且始终是上一级别的超集。等级的顺序是 LEGACY < LIMITED < FULL < LEVEL_3。

使用 [CameraCharacteristics](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics) 对象，我们可以使用单个语句检索硬件级别：

```
val characteristics: CameraCharacteristics = ...

// 硬件级别将是其中之一：
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_EXTERNAL,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_LIMITED,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_FULL,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_3
val hardwareLevel = characteristics.get(
        CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL)
```

### 把所有部分拼合起来

一旦我们了解了输出类型、输出尺寸和硬件级别，我们就可以确定哪些视频流组合是有效的。举个例子，有一个具有 [LEGACY](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY) 硬件级别的 `CameraDevice` 支持的配置的快照.照来自 [createCaptureSession](https://developer.android.com/reference/android/hardware/camera2/CameraDevice.html#createCaptureSession%28android.hardware.camera2.params.SessionConfiguration%29) 方法的文档：

![](https://cdn-images-1.medium.com/max/800/0*GsDVSq0sGzP-p1ou)

因为 LEGACY 是可能性最低的硬件等级，我们可以从一个表中推断出每一个支持 Camera2 的设备（API 21 及以上）可以使用正确的配置输出最多三个并发流——这非常酷！然而，可能在很多机器上无法实现最大可用吞吐量，因为你的代码可能会产生很大性能开销，引发性能约束，例如内存、CPU 甚至是发热。

现在我们已经掌握了在框架的支持下使用两个并发流的所需知识，我们可以更深入了解目标输出缓冲区的配置。例如，如果我们的目标是具有 [LEGACY](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY) 硬件级别的设备，我们可以设置两个目标输出表面：一个使用 [ImageFormat.PRIVATE](https://developer.android.com/reference/android/graphics/ImageFormat#PRIVATE) 另一个使用 [ImageFormat.YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888)。只要我们使用 PREVIEW 的尺寸，这应该是上表所支持的组合。使用上面定义的方法，获取相机 ID 所需的预览尺寸非常简单：

```
val characteristics: CameraCharacteristics = ...
val context = this as Context  // 假设我们在一个 Activity 中

val surfaceViewSize = getPreviewOutputSize(
        context, characteristics, SurfaceView::class.java)
val imageReaderSize = getPreviewOutputSize(
        context, characteristics, ImageReader::class.java, format = ImageFormat.YUV_420_888)
```

We must wait until `SurfaceView` is ready using the provided callbacks, like this:

```
val surfaceView = findViewById<SurfaceView>(...)
surfaceView.holder.addCallback(object : SurfaceHolder.Callback {
    override fun surfaceCreated(holder: SurfaceHolder) {
        // 我们不需要具体的图片格式，他会被视为 RRIV
        // 现在 Surface 已经就绪，我们可以用它作为 CameraSession 的输出目标
    }
    ...
})
```

我们甚至可以调用 [SurfaceHolder.setFixedSize()](https://developer.android.com/reference/android/view/SurfaceHolder#setFixedSize%28int,%20int%29) 强制 `SurfaceView` 适配输出流的大小，但在 UI 方面更好的做法是采取类似于[GitHub 上 HDR 取景器](https://github.com/googlesamples/android-HdrViewfinder) 中 [FixedAspectSurfaceView](https://github.com/googlesamples/android-HdrViewfinder/blob/9cd7531ea34b4515b3f300a354149dded9d99332/Application/src/main/java/com/example/android/hdrviewfinder/FixedAspectSurfaceView.java) 的方法，这样可以同时在宽高比和可用空间上使用绝对大小，同时可在 Activity 改变时自动调整。

使用所需格式从 `ImageReader` 中设置另一个表面更加容易，因为无需等待回调：

```
val frameBufferCount = 3  // 只是一个例子，取决于你对 ImageReade 的使用
val imageReader = ImageReader.newInstance(
        imageReaderSize.width, imageReaderSize.height, ImageFormat.YUV_420_888
        frameBufferCount)
```

当使用 `ImageReader` 这样的阻塞目标缓冲区时，我们需要在使用后丢弃这些帧：

```
imageReader.setOnImageAvailableListener({
        val frame =  it.acquireNextImage()
        // 在这用 frame 做些什么
        it.close()
}, null)
```

要记住，我们的目标是最低的共同标准——使用 LEGACY 硬件级别的设备。我们可以添加条件分支，为 LIMITED 硬件等级的设备中的一个输出表面使用 RECORD 尺寸，或者甚至为具有 FULL 硬件级别的设备提供高达 MAXIMUM 的大小。

### 总结

这篇文章中，我们介绍了：

1.  用单镜头的设备同时输出多个流
2.  在单次拍照中组合不同的目标规则
3.  查询并选择合适的输出格式，输出尺寸和硬件等级
4.  设置并使用 `SurfaceView` 和 `ImageReader` 提供的 `Surface` 

有了这些知识，现在我们可以创作一个相机 APP，可以显示和预览流，同时在单独的流中对传入帧进行异步分析。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
