> * 原文地址：[Using multiple camera streams simultaneously](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-multiple-camera-streams-simultaneously.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-multiple-camera-streams-simultaneously.md)
> * 译者：
> * 校对者：

# Using multiple camera streams simultaneously

This blog post is the latest one in the current series about camera on Android; we have previously covered [camera enumeration](https://medium.com/androiddevelopers/camera-enumeration-on-android-9a053b910cb5) and [camera capture sessions and requests](https://medium.com/androiddevelopers/understanding-android-camera-capture-sessions-and-requests-4e54d9150295).

### Use cases for multiple camera streams

A camera application might want to use more than one stream of frames simultaneously, in some cases different streams even require a different frame resolution or pixel format; some typical use cases include:

*   Video recording: one stream for preview, another being encoded and saved into a file
*   Barcode scanning: one stream for preview, another for barcode detection
*   Computational photography: one stream for preview, another for face / scene detection

As we discussed in our [previous blog post](https://medium.com/androiddevelopers/understanding-android-camera-capture-sessions-and-requests-4e54d9150295), there is a non-trivial performance cost when we process frames, and the cost is multiplied when doing parallel stream / pipeline processing.

Resources like CPU, GPU and DSP might be able to take advantage of the framework’s [reprocessing](https://developer.android.com/reference/android/hardware/camera2/CameraDevice#createReprocessCaptureRequest%28android.hardware.camera2.TotalCaptureResult%29) capabilities, but resources like memory will grow linearly.

### Multiple targets per request

Multiple camera streams can be combined into a single [CameraCaptureRequest](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest) by performing a somewhat bureaucratic procedure. This code snippet illustrates how to setup a camera session with one stream for camera preview and another stream for image processing:

```
val session: CameraCaptureSession = ...  // from CameraCaptureSession.StateCallback

// We will be using the preview capture template for the combined streams, because
// it is optimized for low latency; for high-quality images use
// TEMPLATE_STILL_CAPTURE and for a steady frame rate use
// TEMPLATE_RECORD
val requestTemplate = CameraDevice.TEMPLATE_PREVIEW
val combinedRequest = session.device.createCaptureRequest(requestTemplate)

// Link the Surface targets with the combined request
combinedRequest.addTarget(previewSurface)
combinedRequest.addTarget(imReaderSurface)

// In our simple case the SurfaceView gets updated automatically. ImageReader
// has its own callback that we have to listen to in order to retrieve the frames
// so there is no need to set up a callback for the capture request
session.setRepeatingRequest(combinedRequest.build(), null, null)
```

If you configure the target surfaces correctly, this code will only produce streams that meet the minimum FPS determined by [StreamComfigurationMap.GetOutputMinFrameDuration(int, Size)](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap#getOutputMinFrameDuration%28int,%20android.util.Size%29) and [StreamComfigurationMap.GetOutputStallDuration(int, Size)](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap.html#getOutputStallDuration%28int,%20android.util.Size%29). Actual performance will vary from device to device although, Android gives us some guarantees for supporting specific combinations depending on three variables: **output type**, **output size** and **hardware level**. Using an unsupported combination of parameters may work at a low frame rate; or it may not work at all, triggering one of the failure callbacks. [The documentation](https://developer.android.com/reference/android/hardware/camera2/CameraDevice#createCaptureSession%28java.util.List%3Candroid.view.Surface%3E,%20android.hardware.camera2.CameraCaptureSession.StateCallback,%20android.os.Handler%29) describes in great detail what is guaranteed to work and it is strongly recommended to read it in full, but we will cover the basics here.

### Output type

**Output type** refers to the format in which the frames are encoded. The possible values described in the documentation are PRIV, YUV, JPEG and RAW. The documentation best explains them:

> PRIV refers to any target whose available sizes are found using [StreamConfigurationMap.getOutputSizes(Class)](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap#getOutputSizes%28java.lang.Class%3CT%3E%29) with no direct application-visible format

> YUV refers to a target Surface using the [ImageFormat.YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888) format

> JPEG refers to the [ImageFormat.JPEG](https://developer.android.com/reference/android/graphics/ImageFormat#JPEG) format

> RAW refers to the [ImageFormat.RAW_SENSOR](https://developer.android.com/reference/android/graphics/ImageFormat#RAW_SENSOR) format.

When choosing your application’s output type, if the goal is to maximize compatibility then the recommendation is to use [ImageFormat.YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888) for frame analysis and [ImageFormat.JPEG](https://developer.android.com/reference/android/graphics/ImageFormat#JPEG) for still images. For preview and recording scenarios, you will likely be using a `SurfaceView`, `TextureView`, `MediaRecorder`, `MediaCodec` or `RenderScript.Allocation`. In those cases do not specify an image format and for compatibility purposes it will count as [ImageFormat.PRIVATE](https://developer.android.com/reference/android/graphics/ImageFormat#PRIVATE) (regardless of the actual format used under the hood). To query the formats supported by a device given its [CameraCharacteristics](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics), use the following code:

```
val characteristics: CameraCharacteristics = ...
val supportedFormats = characteristics.get(
            CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP).outputFormats
```

### Output size

All available **output sizes** are listed when we call [StreamConfigurationMap.getOutputSizes()](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap.html#getOutputSizes%28int%29), but as far as compatibility goes we only need to worry about two of them: PREVIEW and MAXIMUM. We can think of those sizes as upper bounds; if the documentation says something of size PREVIEW works, then anything with a size smaller than PREVIEW also works. Same applies to MAXIMUM. Here’s a relevant excerpt from the [documentation](https://developer.android.com/reference/android/hardware/camera2/CameraDevice):

> For the maximum size column, PREVIEW refers to the best size match to the device’s screen resolution, or to 1080p (1920x1080), whichever is smaller. RECORD refers to the camera device’s maximum supported recording resolution, as determined by [CamcorderProfile](https://developer.android.com/reference/android/media/CamcorderProfile.html). And MAXIMUM refers to the camera device’s maximum output resolution for that format or target from [StreamConfigurationMap.getOutputSizes(int)](https://developer.android.com/reference/android/hardware/camera2/params/StreamConfigurationMap.html#getOutputSizes%28int%29).

Note that the available output sizes depend on the choice of format. Given the [CameraCharacteristics](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics) and a format, we can query for the available output sizes like this:

```
val characteristics: CameraCharacteristics = ...
val outputFormat: Int = ...  // e.g. ImageFormat.JPEG
val sizes = characteristics.get(
        CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
        .getOutputSizes(outputFormat)
```

In the camera preview and recording use cases, we should be using the target class to determine supported sizes since the format will be handled by the camera framework itself:

```
val characteristics: CameraCharacteristics = ...
val targetClass: Class<T> = ...  // e.g. SurfaceView::class.java
val sizes = characteristics.get(
        CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
        .getOutputSizes(targetClass)
```

Getting MAXIMUM size is easy — just sort the output sizes by area and return the largest one:

```
fun <T>getMaximumOutputSize(
        characteristics: CameraCharacteristics, targetClass: Class<T>, format: Int? = null):
        Size {
    val config = characteristics.get(
            CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)

    // If image format is provided, use it to determine supported sizes; else use target class
    val allSizes = if (format == null)
        config.getOutputSizes(targetClass) else config.getOutputSizes(format)
    return allSizes.sortedWith(compareBy { it.height * it.width }).reversed()[0]
}
```

Getting PREVIEW size requires a little more thinking. Recall that PREVIEW refers to the best size match to the device’s screen resolution, or to 1080p (1920x1080), whichever is smaller. Keep in mind that the aspect ratio may not match the screen’s aspect ratio exactly, so we may need to apply letter-boxing or cropping to the stream if we plan on displaying it in full screen mode. In order to get the right preview size, we need to compare the available output sizes with the display size while taking into account that the display may be rotated. In this code, we also define a helper class `SmartSize` that will make size comparisons a little easier:

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

    // Find which is smaller: screen or 1080p
    val hdSize = SmartSize(1080, 720)
    val screenSize = getDisplaySmartSize(context)
    val hdScreen = screenSize.long >= hdSize.long || screenSize.short >= hdSize.short
    val maxSize = if (hdScreen) screenSize else hdSize

    // If image format is provided, use it to determine supported sizes; else use target class
    val config = characteristics.get(
            CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
    val allSizes = if (format == null)
        config.getOutputSizes(targetClass) else config.getOutputSizes(format)

    // Get available sizes and sort them by area from largest to smallest
    val validSizes = allSizes
            .sortedWith(compareBy { it.height * it.width })
            .map { SmartSize(it.width, it.height) }.reversed()

    // Then, get the largest output size that is smaller or equal than our max size
    return validSizes.filter {
        it.long <= maxSize.long && it.short <= maxSize.short }[0].size
}
```

### Hardware level

To determine the available capabilities at runtime the most important piece of information a camera application needs is the supported **hardware level**. Once again, we can lean on [the documentation](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#INFO_SUPPORTED_HARDWARE_LEVEL) to explain this to us:

> The supported hardware level is a high-level description of the camera device’s capabilities, summarizing several capabilities into one field. Each level adds additional features to the previous one, and is always a strict superset of the previous level. The ordering is LEGACY < LIMITED < FULL < LEVEL_3.

With a [CameraCharacteristics](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics) object, we can retrieve the hardware level with a single statement:

```
val characteristics: CameraCharacteristics = ...

// Hardware level will be one of:
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_EXTERNAL,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_LIMITED,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_FULL,
// - CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL_3
val hardwareLevel = characteristics.get(
        CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL)
```

### Putting all the pieces together

Once we understand output type, output size and hardware level we can determine which combinations of streams are valid. For instance, here’s a snapshot of the configurations supported by a `CameraDevice` with [LEGACY](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY) hardware level. The snapshot is taken from the documentation for [createCaptureSession](https://developer.android.com/reference/android/hardware/camera2/CameraDevice.html#createCaptureSession%28android.hardware.camera2.params.SessionConfiguration%29) method:

![](https://cdn-images-1.medium.com/max/800/0*GsDVSq0sGzP-p1ou)

Since LEGACY is the lowest possible hardware level, we can infer from the previous table that every device that supports Camera2 (i.e. API level 21 and above) can output up to three simultaneous streams using the right configuration — that’s pretty cool! However, it may not be possible to achieve the maximum available throughput on many devices because your own code will likely incur overhead which invokes other constraints that limit performance, such as memory, CPU and even thermal.

Now that we have the knowledge necessary to set up two simultaneous streams with support guaranteed by the framework, we can dig a little deeper into the configuration of the target output buffers. For example, if we were targeting a device with [LEGACY](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#INFO_SUPPORTED_HARDWARE_LEVEL_LEGACY) hardware level, we could setup two target output surfaces: one using [ImageFormat.PRIVATE](https://developer.android.com/reference/android/graphics/ImageFormat#PRIVATE) and another one using [ImageFormat.YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat#YUV_420_888) . This should be a supported combination as per the table above as long as we use the PREVIEW size. Using the function defined above, getting the required preview sizes for a camera ID is now very simple:

```
val characteristics: CameraCharacteristics = ...
val context = this as Context  // assuming we are inside of an activity

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
        // We do not need to specify image format, and it will be considered of type PRIV
        // Surface is now ready and we could use it as an output target for CameraSession
    }
    ...
})
```

We can even force the `SurfaceView` to match the camera output size by calling [SurfaceHolder.setFixedSize()](https://developer.android.com/reference/android/view/SurfaceHolder#setFixedSize%28int,%20int%29), but it may be better in terms of UI to take an approach similar to [FixedAspectSurfaceView](https://github.com/googlesamples/android-HdrViewfinder/blob/9cd7531ea34b4515b3f300a354149dded9d99332/Application/src/main/java/com/example/android/hdrviewfinder/FixedAspectSurfaceView.java) from the [HDR viewfinder sample on GitHub](https://github.com/googlesamples/android-HdrViewfinder), which sets an absolute size taking into consideration both the aspect ratio and the available space, while automatically adjusting when activity changes are triggered.

Setting up the other surface from `ImageReader` with the desired format is even easier, since there are no callbacks to wait for:

```
val frameBufferCount = 3  // just an example, depends on your usage of ImageReader
val imageReader = ImageReader.newInstance(
        imageReaderSize.width, imageReaderSize.height, ImageFormat.YUV_420_888
        frameBufferCount)
```

When using a blocking target buffer like `ImageReader`, we need to discard the frames after we used them:

```
imageReader.setOnImageAvailableListener({
        val frame =  it.acquireNextImage()
        // Do something with `frame` here
        it.close()
}, null)
```

We should keep in mind that we are targeting the lowest common denominator — devices with LEGACY hardware level. We could add conditional branching and use RECORD size for one of the output target surfaces in devices with LIMITED hardware level or even bump that up to MAXIMUM size for devices with FULL hardware level.

### Summary

In this article, we have covered:

1.  Using a single camera device to output multiple streams simultaneously
2.  The rules for combining different targets in a single capture request
3.  Querying and selecting the appropriate output type, output size and hardware level
4.  Setting up and using a `Surface` provided by `SurfaceView` and `ImageReader`

With this knowledge, now we can create a camera app that has the ability to display a preview stream while performing asynchronous analysis of incoming frames in a separate stream.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
