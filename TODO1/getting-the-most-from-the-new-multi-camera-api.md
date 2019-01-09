> * 原文地址：[Getting the Most from the New Multi-Camera API](https://medium.com/androiddevelopers/getting-the-most-from-the-new-multi-camera-api-5155fb3d77d9)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/getting-the-most-from-the-new-multi-camera-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/getting-the-most-from-the-new-multi-camera-api.md)
> * 译者：
> * 校对者：

# 充分利用多摄像头 API

这篇博客是对我们的 [Android 开发者峰会 2018 演讲](https://youtu.be/u38wOv2a_dA) 的补充，是与来自合作伙伴开发者团队中的 Vinit Modi、Android Camera PM 和 Emilie Roberts 合作完成的。查看我们之前在该系列中的文章，包括 [相机枚举](https://medium.com/androiddevelopers/camera-enumeration-on-android-9a053b910cb5), [相机拍摄会话和请求](https://medium.com/androiddevelopers/understanding-android-camera-capture-sessions-and-requests-4e54d9150295) 和 [同时使用多个摄像机流](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482)。

### 多摄像头用例

多摄像头是在 [Android Pie](https://developer.android.com/about/versions/pie/android-9.0#camera) 中引入的，自几个月前发布以来，现在我们看到支持该 API 的设备进入了市场，比如谷歌 Pixel 3 和华为 Mate 20 系列。许多多摄像头用例与特定的硬件配置紧密结合；换句话说，并非所有的用例都适配每台设备 — 这使得多摄像头功能成为模块 [动态传输](https://developer.android.com/studio/projects/dynamic-delivery) 的一个理想选择。一些典型的用例包括：

*   缩放：根据裁剪区域或所需焦距在相机之间切换
*   深度：使用多个摄像头构建深度图
*   背景虚化：使用推论的深度信息来模拟类似 DSLR 的窄焦距范围

### 逻辑和物理摄像头

要了解多摄像头 API，我们必须首先了解逻辑摄像头和物理摄像头之间的区别；这个概念最好用一个例子来说明。例如，我们可以想像一个有三个后置摄像头而没有前置摄像头的设备作为参考。在本例中，三个后置摄像头中的每一个都被认为是一个物理摄像头。然后逻辑摄像头就是两个或更多这些物理摄像头的分组。逻辑摄像头的输出可以是来自其中一个底层物理摄像机的一个流，也可以是同时来自多个底层物理摄像机的融合流；这两种方式都是由相机的 HAL 来处理的。

许多手机制造商也开发了他们自身的相机应用程序（通常预先安装在他们的设备上）。为了利用所有硬件的功能，他们有时会使用私有或隐藏的 API，或者从驱动程序实现中获得其他应用程序没有特权访问的特殊处理。有些设备甚至通过提供来自不同物理双摄像头的融合流来实现逻辑摄像头的概念，但同样，这只对某些特权应用程序可用。通常，框架只会暴露一个物理摄像头。 Android Pie 之前第三方开发者的情况如下图所示：

![](https://cdn-images-1.medium.com/max/800/0*jHgc12zW0MnFXf8V)

相机功能通常只对特权应用程序可用

从 Android Pie 开始，一些事情发生了变化。首先，在 Android 应用程序中使用 [私有 API 不再可行](https://developer.android.com/about/versions/pie/restrictions-non-sdk-interfaces)。其次，Android 框架中包含了 [多摄像头支持](https://source.android.com/devices/camera/multi-camera)，Android 已经 [强烈推荐](https://source.android.com/compatibility/android-cdd#7_5_4_camera_api_behavior) 手机厂商为面向同一方向的所有物理摄像头提供逻辑摄像头。因此，这是第三方开发人员应该在运行 Android Pie 及以上版本的设备上看到的内容：

![](https://cdn-images-1.medium.com/max/800/0*xnN-9_1XtmuWq-Lx)

开发人员可完全访问从 Android P 开始的所有摄像头设备

值得注意的是，逻辑摄像头提供的功能完全依赖于相机 HAL 的 OEM 实现。例如，像 Pixel 3 这样的设备以这样一种方式实现其逻辑相机，即它将根据请求的焦距和裁剪区域选择其中一个物理摄像头。

### 多摄像头 API

新 API 包含了以下新的常量、类和方法:


*   `CameraMetadata.REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA`
*   `CameraCharacteristics.getPhysicalCameraIds()`
*   `CameraCharacteristics.getAvailablePhysicalCameraRequestKeys()`
*   `CameraDevice.createCaptureSession(SessionConfiguration config)`
*   `CameraCharactersitics.LOGICAL_MULTI_CAMERA_SENSOR_SYNC_TYPE`
*   `OutputConfiguration` & `SessionConfiguration`

由于 [Android CDD](https://source.android.com/compatibility/android-cdd#7_5_4_camera_api_behavior) 的更改, 多摄像头 API 也满足了开发人员的某些期望。双摄像头设备在 Android Pie 之前就已经存在，但同时打开多个摄像头需要反复试验；Android 上的多摄像头 API 现在给了我们一组规则，告诉我们什么时候可以打开一对物理摄像头，只要它们是同一逻辑摄像头的一部分。

如上所述，我们可以预期，在大多数情况下，使用 Android Pie 发布的新设备将公开所有物理摄像头(除了更奇特的传感器类型，如红外线)，以及更容易使用的逻辑摄像头。此外，非常关键的是，我们可以预期，对于每个保证有效的融合流，属于逻辑摄像头的一个流可以被来自底层物理摄像头的**两个**流替换。让我们通过一个例子更详细地介绍它。

### 同时使用多个流

在上一篇博文中，我们详细介绍了在单个摄像头中 [同时使用多个流](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482) 的规则。同样的规则也适用于多个摄像头，但在 [这个文档](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA) 中有一个值得注意的补充说明：

> 对于每个有保证的融合流，逻辑摄像头都支持将一个逻辑 [YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat.html#YUV_420_888) 或原始流替换为两个相同大小和格式的物理流，每个物理流都来自一个单独的物理摄像头，前提是两个物理摄像头都支持给定的大小和格式。

换句话说，YUV 或 RAW 类型的每个流可以用相同类型和大小的两个流替换。例如，我们可以从单摄像头设备的摄像头视频流开始，配置如下:

*   流 1: YUV 类型，' id = 0 ' 的逻辑摄像机的最大尺寸

然后，一个支持多摄像头的设备将允许我们创建一个会话，用两个物理流替换逻辑 YUV 流：

*   流 1: YUV 类型，' id = 1 ' 的物理摄像头的最大尺寸
*   流 2: YUV 类型，' id = 2 ' 的物理摄像头的最大尺寸

诀窍是，当且仅当这两个摄像头是一个逻辑摄像头分组的一部分时，我们可以用两个等效的流替换 YUV 或原始流 — 即被列在 [CameraCharacteristics.getPhysicalCameraIds()](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#getPhysicalCameraIds%28%29) 中的。

另一件需要考虑的事情是，框架提供的保证仅仅是同时从多个物理摄像头获取帧的最低要求。我们可以期望在大多数设备中支持额外的流，有时甚至允许我们独立地打开多个物理摄像头设备。不幸的是，由于这不是框架的硬保证，因此需要我们通过反复试验来执行每个设备的测试和调优。

### 使用多个物理摄像头创建会话

当我们在一个支持多摄像头的设备中与物理摄像头交互时，我们应该打开一个 [CameraDevice](https://developer.android.com/reference/android/hardware/camera2/CameraDevice) (逻辑相机)，并在一个会话中与它交互，这个会话必须使用 API  [CameraDevice.createCaptureSession(SessionConfiguration config)](https://developer.android.com/reference/android/hardware/camera2/CameraDevice#createCaptureSession%28android.hardware.camera2.params.SessionConfiguration%29) 创建，这个 API 自 SDK 级别 28 起可用。 然后, 这个 [会话参数](https://developer.android.com/reference/android/hardware/camera2/params/SessionConfiguration) 将有很多 [输出配置](https://developer.android.com/reference/android/hardware/camera2/params/OutputConfiguration), 其中每个输出配置将具有一组输出目标，以及(可选的)所需的物理摄像头 ID。

![](https://cdn-images-1.medium.com/max/800/0*OY88erAolXSr5bA9)

会话参数 和 输出配置模型

稍后，当我们分派拍摄请求时，该请求将具有与其关联的输出目标。框架将根据附加到请求的输出目标来决定将请求发送到哪个物理(或逻辑)摄像头。如果输出目标对应于作为 [输出配置](https://developer.android.com/reference/android/hardware/camera2/params/OutputConfiguration) 的输出目标之一和物理摄像头 ID 一起发送， 那么该物理摄像头将接收并处理该请求。

### 使用一对物理摄像头

面向开发人员的多摄像头 API 中最重要的一个新增功能是识别逻辑摄像头并找到它们背后的物理摄像头。现在我们明白,我们可以同时打开多个物理摄像头(再次,通过打开逻辑摄像头和作为同一会话的一部分)，并且有明确的融合流的规则，我们可以定义一个函数来帮助我们识别潜在的可以用来替换一个逻辑摄像机视频流的一对物理摄像头：
```
/**
* 帮助类，用于封装逻辑摄像头和两个底层
* 物理摄像头
*/
data class DualCamera(val logicalId: String, val physicalId1: String, val physicalId2: String)

fun findDualCameras(manager: CameraManager, facing: Int? = null): Array<DualCamera> {
    val dualCameras = ArrayList<DualCamera>()

    // 遍历所有可用的摄像头特征
    manager.cameraIdList.map {
        Pair(manager.getCameraCharacteristics(it), it)
    }.filter {
        // 通过摄像头的方向这个请求参数进行过滤
        facing == null || it.first.get(CameraCharacteristics.LENS_FACING) == facing
    }.filter {
        // 逻辑摄像头过滤
        it.first.get(CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES)!!.contains(
                CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA)
    }.forEach {
        // 物理摄像头列表中的所有可能对都是有效结果
        // 注意：可能有 N 个物理摄像头作为逻辑摄像头分组的一部分
        val physicalCameras = it.first.physicalCameraIds.toTypedArray()
        for (idx1 in 0 until physicalCameras.size) {
            for (idx2 in (idx1 + 1) until physicalCameras.size) {
                dualCameras.add(DualCamera(
                        it.second, physicalCameras[idx1], physicalCameras[idx2]))
            }
        }
    }

    return dualCameras.toTypedArray()
}
```

物理摄像头的状态处理由逻辑摄像头控制。因此，要打开我们的“双摄像头”，我们只需要打开与我们感兴趣的物理摄像头相对应的逻辑摄像头:

```
fun openDualCamera(cameraManager: CameraManager,
                   dualCamera: DualCamera,
                   executor: Executor = AsyncTask.SERIAL_EXECUTOR,
                   callback: (CameraDevice) -> Unit) {

    cameraManager.openCamera(
            dualCamera.logicalId, executor, object : CameraDevice.StateCallback() {
        override fun onOpened(device: CameraDevice) = callback(device)
        // 为了简便起见,我们省略……
        override fun onError(device: CameraDevice, error: Int) = onDisconnected(device)
        override fun onDisconnected(device: CameraDevice) = device.close()
    })
}
```

在此之前，除了选择打开哪台摄像头之外，没有什么不同于我们过去打开任何其他摄像头所做的事情。现在是时候使用新的 [会话参数](https://developer.android.com/reference/android/hardware/camera2/params/SessionConfiguration) API 创建一个拍摄会话了，这样我们就可以告诉框架将某些目标与特定的物理摄像机 ID 关联起来:

```
/**
 * 帮助类，封装了定义 3 组输出目标的类型：
 *
 *   1. 逻辑摄像头
 *   2. 第一个物理摄像头
 *   3. 第二个物理摄像头
 */
typealias DualCameraOutputs =
        Triple<MutableList<Surface>?, MutableList<Surface>?, MutableList<Surface>?>

fun createDualCameraSession(cameraManager: CameraManager,
                            dualCamera: DualCamera,
                            targets: DualCameraOutputs,
                            executor: Executor = AsyncTask.SERIAL_EXECUTOR,
                            callback: (CameraCaptureSession) -> Unit) {

    // 创建三组输出配置:一组用于逻辑摄像头，
    // 另一组用于逻辑摄像头。
    val outputConfigsLogical = targets.first?.map { OutputConfiguration(it) }
    val outputConfigsPhysical1 = targets.second?.map {
        OutputConfiguration(it).apply { setPhysicalCameraId(dualCamera.physicalId1) } }
    val outputConfigsPhysical2 = targets.third?.map {
        OutputConfiguration(it).apply { setPhysicalCameraId(dualCamera.physicalId2) } }

    // 将所有输出配置放入单个数组中
    val outputConfigsAll = arrayOf(
            outputConfigsLogical, outputConfigsPhysical1, outputConfigsPhysical2)
            .filterNotNull().flatMap { it }

    // 实例化可用于创建会话的会话配置
    val sessionConfiguration = SessionConfiguration(SessionConfiguration.SESSION_REGULAR,
            outputConfigsAll, executor, object : CameraCaptureSession.StateCallback() {
        override fun onConfigured(session: CameraCaptureSession) = callback(session)
        // 省略...
        override fun onConfigureFailed(session: CameraCaptureSession) = session.device.close()
    })

    // 使用前面定义的函数打开逻辑摄像头
    openDualCamera(cameraManager, dualCamera, executor = executor) {

        // 最后创建会话并通过回调返回
        it.createCaptureSession(sessionConfiguration)
    }
}
```

现在，我们可以参考 [文档](https://developer.android.com/reference/android/hardware/camera2/CameraDevice.html#createCaptureSession%28android.hardware.camera2.params.SessionConfiguration%29) 或 [以前的博客文章](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482) 来了解支持哪些流的融合。我们只需要记住这些是针对单个逻辑摄像头上的多个流的，并且兼容使用相同的配置的并将其中一个流替换为来自同一逻辑摄像头的两个物理摄像头的两个流。

在 [摄像头会话](https://developer.android.com/reference/android/hardware/camera2/CameraCaptureSession) 就绪后，剩下要做的就是发送我们想要的 [拍摄请求](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest). 拍摄请求的每个目标将从相关的物理摄像头(如果有的话)接收数据，或者返回到逻辑摄像头。

### 缩放示例用例

为了将所有这一切与最初讨论的用例之一联系起来，让我们看看如何在我们的相机应用程序中实现一个功能，以便用户能够在不同的物理摄像头之间切换，体验到不同的视野——有效地拍摄不同的“缩放级别”。

![](https://cdn-images-1.medium.com/max/800/0*WaZN9bicOXI4mpUp)

将相机转换为缩放级别用例的示例 (来自 [Pixel 3 Ad](https://www.youtube.com/watch?v=gJtJFEH1Cis))

首先，我们必须选择我们想允许用户在其中进行切换的一对物理摄像机。为了获得最大的效果，我们可以分别搜索提供最小焦距和最大焦距的一对摄像机。通过这种方式，我们选择一种可以在尽可能短的距离上对焦的摄像设备，另一种可以在尽可能远的点上对焦：

```
fun findShortLongCameraPair(manager: CameraManager, facing: Int? = null): DualCamera? {

    return findDualCameras(manager, facing).map {
        val characteristics1 = manager.getCameraCharacteristics(it.physicalId1)
        val characteristics2 = manager.getCameraCharacteristics(it.physicalId2)

        // 查询每个物理摄像头公布的焦距
        val focalLengths1 = characteristics1.get(
                CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS) ?: floatArrayOf(0F)
        val focalLengths2 = characteristics2.get(
                CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS) ?: floatArrayOf(0F)

        // 计算相机之间最小焦距和最大焦距之间的最大差异
        val focalLengthsDiff1 = focalLengths2.max()!! - focalLengths1.min()!!
        val focalLengthsDiff2 = focalLengths1.max()!! - focalLengths2.min()!!

        // 返回相机 ID 和最小焦距与最大焦距之间的差值
        if (focalLengthsDiff1 < focalLengthsDiff2) {
            Pair(DualCamera(it.logicalId, it.physicalId1, it.physicalId2), focalLengthsDiff1)
        } else {
            Pair(DualCamera(it.logicalId, it.physicalId2, it.physicalId1), focalLengthsDiff2)
        }

        // 只返回差异最大的对，如果没有找到对，则返回 null
    }.sortedBy { it.second }.reversed().lastOrNull()?.first
}
```

一个合理的架构应该是有两个 [SurfaceViews](https://developer.android.com/reference/android/view/SurfaceView), 每个流一个，在用户交互时交换，因此在任何给定的时间只有一个是可见的。在下面的代码片段中，我们将演示如何打开逻辑摄像头、配置摄像头输出、创建摄像头会话和启动两个预览流；利用前面定义的功能:

```
val cameraManager: CameraManager = ...

// 从 activity/fragment 中获取两个输出目标
val surface1 = ...  // 来自 SurfaceView
val surface2 = ...  // 来自 SurfaceView

val dualCamera = findShortLongCameraPair(manager)!!
val outputTargets = DualCameraOutputs(
        null, mutableListOf(surface1), mutableListOf(surface2))

// 在这里，我们打开逻辑摄像头，配置输出并创建一个会话
createDualCameraSession(manager, dualCamera, targets = outputTargets) { session ->

    // 为每个物理相头创建一个目标的单一请求
    // 注意:每个目标只会从它相关的物理相头接收帧
    val requestTemplate = CameraDevice.TEMPLATE_PREVIEW
    val captureRequest = session.device.createCaptureRequest(requestTemplate).apply {
        arrayOf(surface1, surface2).forEach { addTarget(it) }
    }.build()

    // 设置会话的粘性请求，就完成了
    session.setRepeatingRequest(captureRequest, null, null)
}
```

现在我们需要做的就是为用户提供一个在两个界面之间切换的 UI，比如一个按钮或者双击 “SurfaceView”; 如果我们想变得更有趣，我们可以尝试执行某种形式的场景分析，并在两个流之间自动切换。

### 镜头失真

所有的镜头都会产生一定的失真。在 Android 中，我们可以使用 [CameraCharacteristics.LENS_DISTORTION](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#LENS_DISTORTION) (它替换了现在已经废弃的 [CameraCharacteristics.LENS_RADIAL_DISTORTION](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#LENS_RADIAL_DISTORTION)) 查询镜头创建的失真。可以合理地预期，对于逻辑摄像头，失真将是最小的，我们的应用程序可以使用或多或少的框架，因为他们来自这个摄像头。然而，对于物理摄像头，我们应该期待潜在的非常不同的镜头配置——特别是在广角镜头上。

一些设备可以通过 [CaptureRequest.DISTORTION_CORRECTION_MODE](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest#DISTORTION_CORRECTION_MODE) 实现自动失真校正。很高兴知道大多数设备的失真校正默认为开启。文档中有一些更详细的信息：

> FAST/HIGH_QUALITY 均表示将应用相机设备确定的失真校正。 HIGH_QUALITY 模式表示相机设备将使用最高质量的校正算法，即使它会降低捕获率。快速意味着相机设备在应用校正时不会降低捕获率。如果任何校正都会降低捕获速率，则 FAST 可能与 OFF 相同[...] 校正仅适用于 YUV、JPEG 或 DEPTH16 等已处理的输出[...] 默认情况下，此控件将在支持此功能的设备上启用控制。

如果我们想用最高质量的物理摄像头拍摄一张照片，那么我们应该尝试将校正模式设置为 HIGH_QUALITY（如果可用）。下面是我们应该如何设置拍摄请求：
```
val cameraSession: CameraCaptureSession = ...

// 使用静态拍摄模板来构建拍摄请求
val captureRequest = cameraSession.device.createCaptureRequest(
        CameraDevice.TEMPLATE_STILL_CAPTURE)

// 确定该设备是否支持失真校正
val characteristics: CameraCharacteristics = ...
val supportsDistortionCorrection = characteristics.get(
        CameraCharacteristics.DISTORTION_CORRECTION_AVAILABLE_MODES)?.contains(
        CameraMetadata.DISTORTION_CORRECTION_MODE_HIGH_QUALITY) ?: false

if (supportsDistortionCorrection) {
    captureRequest.set(
            CaptureRequest.DISTORTION_CORRECTION_MODE,
            CameraMetadata.DISTORTION_CORRECTION_MODE_HIGH_QUALITY)
}

// 添加输出目标，设置其他拍摄请求参数…

// 发送拍摄请求
cameraSession.capture(captureRequest.build(), ...)
```

请记住，在这种模式下设置拍摄请求将对相机可以产生的帧速率产生潜在的影响，这就是为什么我们只在静态图像拍摄中设置设置校正。

### 未完待续

唷! 我们介绍了很多与新的多摄像头 API 相关的东西:

*   潜在的用例
*   逻辑摄像头 vs 物理摄像头
*   多摄像头 API 概述
*   用于打开多个摄像头视频流的扩展规则
*   如何为一对物理摄像头设置摄像机流
*   示例“缩放”用例交换相机
*   校正镜头失真

请注意，我们还没有涉及帧同步和计算深度图。这是一个值得在博客上发表的话题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
