> * 原文地址：[Camera Enumeration on Android](https://medium.com/androiddevelopers/camera-enumeration-on-android-9a053b910cb5)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/camera-enumeration-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/camera-enumeration-on-android.md)
> * 译者：
> * 校对者：

# Android 的多摄像头支持

从 Android P 开始，增加了逻辑多摄像头和 USB 摄像头支持。这对 Android 开发者来说意味着什么？

### 多摄像头

一台设备有多个摄像头没什么新鲜的，但是直到现在，Android 设备仍然最多只有前后两个摄像头。如果你想要打开第一个摄像头，需要进行以下操作：

```
val cameraDevice = Camera.open(0)
```

但是这些是比较简单的操作。如今多摄像头意味着前置或者后置有两个及两个以上的摄像头。有很多镜头可供选择！

### Camera2 API

由于兼容性问题，尽管旧的 Camera API 已经被废弃很长时间，上述的代码仍然有效。但是随着生态系统的发展，需要更先进的相机功能。因此，Android 5.0（Lollipop）引进了 Camera2，适用于 API 21 及以上。用 Camera2 API 来打开第一个存在的摄像头代码如下所示:

```
val cameraManager = activity.getSystemService(Context.CAMERA_SERVICE) as CameraManager
val cameraId = cameraManager.cameraIdList[0]
cameraManager.openCamera(cameraId, object : CameraDevice.StateCallback() {
    override fun onOpened(device: CameraDevice) {
        // Do something with `device`
    }
    override fun onDisconnected(device: CameraDevice) {
        device.close()
    }
    override fun onError(device: CameraDevice, error: Int) {
        onDisconnected(device)
    }
}, null)
```

### 第一个并不是最好的选择

上述代码目前看起来没什么问题。如果我们所需要的只是一个能够打开第一个存在的摄像头的应用程序，那么它在大部分的 Android 手机上都有效。但是考虑到以下场景:

*   如果设备没有摄像头，那么应用程序会崩溃。这看起来似乎不太可能，但是要知道 Android 运用在各种设备上，包括 Android Things、Android Wear 和 Android TV 等这些有数百万用户的设备。
*   如果设备至少有一个后置摄像头，它将会映射到列表中的第一个摄像头。但是当应用程序运行在没有后置摄像头的设备上，比如 PixelBooks 或者其他一些 ChromeOS 的笔记本电脑，将会打开单个的前置摄像头。

那么我们应该怎么做？检查摄像头列表和摄像头特性：

```

val cameraIdList = cameraManager.cameraIdList // may be empty
val characteristics = cameraManager.getCameraCharacteristics(cameraId)
val cameraLensFacing = characteristics.get(CameraCharacteristics.LENS_FACING)
```

变量 `cameraLensFacing` 有以下取值:

*   [CameraMetadata.LENS_FACING_FRONT](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#LENS_FACING_FRONT)
*   [CameraMetadata.LENS_FACING_BACK](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#LENS_FACING_BACK)
*   [CameraMetadata.LENS_FACING_EXTERNAL](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#LENS_FACING_EXTERNAL)

更多有关摄像头配置的信息，请查看[文档](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#LENS_FACING).

### 合理的默认设置

根据应用程序的使用情况，我们希望默认打开特定的相机镜头配置（如果可以提供这样的功能）。比如，自拍应用程序很可能想要打开前置摄像头，而一款增强现实类的应用程序应该希望打开后置摄像头。我们可以将这样的一个逻辑包装成一个函数，它可以正确地处理上面提到的情况:

```
fun getFirstCameraIdFacing(cameraManager: CameraManager,
                           facing: Int = CameraMetadata.LENS_FACING_BACK): String? {
    val cameraIds = cameraManager.cameraIdList
    // Iterate over the list of cameras and return the first one matching desired
    // lens-facing configuration
    cameraIds.forEach {
        val characteristics = cameraManager.getCameraCharacteristics(it)
        if (characteristics.get(CameraCharacteristics.LENS_FACING) == facing) {
            return it
        }
    }
    // If no camera matched desired orientation, return the first one from the list
    return cameraIds.firstOrNull()
}
```

### 切换摄像头

目前为止，我们讨论了如何基于应用程序的用途选择默认摄像头。很多相机应用程序还为用户提供切换摄像头的功能:

![](https://cdn-images-1.medium.com/max/800/0*bv1q93VR4XIoazVZ)

Google 相机应用中切换摄像头按钮

要实现这个功能，尝试从[CameraManager.getCameraIdList()](https://developer.android.com/reference/android/hardware/camera2/CameraManager#getCameraIdList%28%29)提供的列表中选择下一个摄像头，但是这并不是个好的方式。因为从 Android P 开始，我们将会看到在同样的情况下更多的设备有多摄像头，或者通过 USB 连接到外部摄像头。如果我们想要提供给用户切换不同摄像头的 UI，建议 ([按照文档](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA)) 是为每个可能的镜头配置选择第一个可用的摄像头。

尽管没有一个通用的逻辑可以用来选择下一个摄像头，但是下述代码适用于大部分情况：

```
fun filterCameraIdsFacing(cameraIds: Array<String>, cameraManager: CameraManager,
                          facing: Int): List<String> {
    return cameraIds.filter {
        val characteristics = cameraManager.getCameraCharacteristics(it)
        characteristics.get(CameraCharacteristics.LENS_FACING) == facing
    }
}

fun getNextCameraId(cameraManager: CameraManager, currCameraId: String? = null): String? {
    // Get all front, back and external cameras in 3 separate lists
    val cameraIds = cameraManager.cameraIdList
    val backCameras = filterCameraIdsFacing(
            cameraIds, cameraManager, CameraMetadata.LENS_FACING_BACK)
    val frontCameras = filterCameraIdsFacing(
            cameraIds, cameraManager, CameraMetadata.LENS_FACING_FRONT)
    val externalCameras = filterCameraIdsFacing(
            cameraIds, cameraManager, CameraMetadata.LENS_FACING_EXTERNAL)

    // The recommended order of iteration is: all external, first back, first front
    val allCameras = (externalCameras + listOf(
            backCameras.firstOrNull(), frontCameras.firstOrNull())).filterNotNull()

    // Get the index of the currently selected camera in the list
    val cameraIndex = allCameras.indexOf(currCameraId)

    // The selected camera may not be on the list, for example it could be an
    // external camera that has been removed by the user
    return if (cameraIndex == -1) {
        // Return the first camera from the list
        allCameras.getOrNull(0)
    } else {
        // Return the next camera from the list, wrap around if necessary
        allCameras.getOrNull((cameraIndex + 1) % allCameras.size)
    }
}
```

这看起来可能有点复杂，但是我们需要考虑到大量的有不同配置的设备。

### 兼容性行为

对于那些仍然在使用已经废弃的 Camera API 的应用程序，通过 [Camera.getNumberOfCameras()](https://developer.android.com/reference/android/hardware/Camera#getNumberOfCameras%28%29) 得到的摄像头的数量取决于 OEM 的实现。文档上是这样描述的:

> 如果系统中有逻辑多摄像头，为了保持应用程序的向后兼容性，这个方法仅为每个逻辑摄像头和底层的物理摄像头组公开一个摄像头。使用 camera2 API 去查看所有摄像头。

请仔细阅读 [其余文档](https://developer.android.com/reference/android/hardware/Camera.CameraInfo.html#orientation) 获得更多信息。通常来说，类似的建议适用于：使用 [Camera.getCameraInfo()](https://developer.android.com/reference/android/hardware/Camera#getCameraInfo%28int,%20android.hardware.Camera.CameraInfo%29) API 查询所有的摄像头[方向](https://developer.android.com/reference/android/hardware/Camera.CameraInfo.html#orientation), 在用户切换摄像头时，仅仅只为每个可用的方向提供一个摄像头。

### 最佳实践
Android 运行在许多不同的设备上。你不应该假设你的应用程序总是在有一两个摄像头的传统的手持设备上运行,而是应该为你的应用程序选择最适合的摄像头。如果你不需要特定的摄像头，选择有所需默认配置的第一个摄像头。如果设备连接了外部摄像头，则可以合理的假设用户希望首先看到这些外部摄像头中的第一个。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

