> * 原文地址：[Camera Enumeration on Android](https://medium.com/androiddevelopers/camera-enumeration-on-android-9a053b910cb5)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/camera-enumeration-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/camera-enumeration-on-android.md)
> * 译者：
> * 校对者：

# Camera Enumeration on Android

Starting in Android P, logical multi-camera and USB camera support have been added. What does this mean for Android developers?

### Multiple cameras

Multiple cameras in a single device are nothing new but, until now, Android devices have been limited to at most two cameras: front and back. If you wanted to open the first camera, all you had to do was:

```
val cameraDevice = Camera.open(0)
```

But those were simpler times. Today, multiple cameras can mean two or more cameras in the front and/or in the back. That’s a lot of lenses to choose from!

### Camera2 API

For compatibility reasons, the above code still works even years after the old Camera API was deprecated. But, as the ecosystem evolved, there was a need for more advanced camera features. So Android introduced Camera2 with Android 5.0 (Lollipop), API level 21 and above. The equivalent code to open the first existing camera using the Camera2 API looks like this:

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

### First is not always best

So far so good. If all we need is an app that opens the first existing camera, this will work on most Android phones. But consider the following scenarios:

*   If a device has no cameras, the app will crash. This may seem unlikely, until we realize that Android runs in many kinds of devices, including Android Things, Android Wear and Android TV, which add up to millions of users.
*   If a device has at least one back-facing camera, it will be mapped to the first camera in the list. But apps running on devices with no back cameras, such as PixelBooks and most other ChromeOS laptops, will open the single, front-facing camera.

What should we do? Check the camera list and camera characteristics:

```

val cameraIdList = cameraManager.cameraIdList // may be empty
val characteristics = cameraManager.getCameraCharacteristics(cameraId)
val cameraLensFacing = characteristics.get(CameraCharacteristics.LENS_FACING)
```

The variable `cameraLensFacing` will be one of:

*   [CameraMetadata.LENS_FACING_FRONT](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#LENS_FACING_FRONT)
*   [CameraMetadata.LENS_FACING_BACK](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#LENS_FACING_BACK)
*   [CameraMetadata.LENS_FACING_EXTERNAL](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#LENS_FACING_EXTERNAL)

For more information about lens-facing configuration, take a look at [the documentation](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#LENS_FACING).

### Sensible defaults

Depending on the use-case of the application, we may want to open a specific camera lens configuration by default (if it’s available). For example, a selfie app would most likely want to open the front-facing camera, while an augmented reality app should probably start with the back camera. We can wrap this logic into a function, which properly handles the cases mentioned above:

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

### Switching cameras

So far, we have discussed how to select a default camera depending on what the application wants to do. Many camera applications also give users the option to switch between cameras:

![](https://cdn-images-1.medium.com/max/800/0*bv1q93VR4XIoazVZ)

Switch camera button in the Google Camera app

To implement this feature it’s tempting to select the next camera from the list provided by [CameraManager.getCameraIdList()](https://developer.android.com/reference/android/hardware/camera2/CameraManager#getCameraIdList%28%29), but this is not a good idea. The reason is that starting in Android P, we expect to see more devices with multiple cameras facing the same way, or even have external cameras connected via USB. If we want to provide the user with a UI that lets them switch between different facing cameras, the recommendation ([as per the documentation](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA)) is to choose the first available camera for each possible lens-facing configuration.

Although there is no one-size-fits-all logic for selecting the next camera, the following code works for most use cases:

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

This may appear complicated, but we need to account for a large set of devices with many different configurations.

### Compatibility behavior

For applications still using the deprecated Camera API, the number of cameras advertised by [Camera.getNumberOfCameras()](https://developer.android.com/reference/android/hardware/Camera#getNumberOfCameras%28%29) depends on OEM implementation. The documentation states:

> If there is a logical multi-camera in the system, to maintain app backward compatibility, this method will only expose one camera for every logical camera and underlying physical cameras group. Use camera2 API to see all cameras.

Read [the rest of the documentation](https://developer.android.com/reference/android/hardware/Camera.CameraInfo.html#orientation) closely for more details. In general, a similar advice applies: use the [Camera.getCameraInfo()](https://developer.android.com/reference/android/hardware/Camera#getCameraInfo%28int,%20android.hardware.Camera.CameraInfo%29) API to query all camera [orientations](https://developer.android.com/reference/android/hardware/Camera.CameraInfo.html#orientation), and expose only one camera for each available orientation to users that are switching between cameras.

### Best practices

Android runs on many different devices. You should not assume that your application will always run on a traditional handheld device with one or two cameras. Pick the most appropriate cameras for the application. If you don’t need a specific camera, select the first camera with the desired lens-facing configuration. If there are external cameras connected, it may be reasonable to assume that the user would prefer to see those first.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

