> * 原文地址：[Getting the Most from the New Multi-Camera API](https://medium.com/androiddevelopers/getting-the-most-from-the-new-multi-camera-api-5155fb3d77d9)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/getting-the-most-from-the-new-multi-camera-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/getting-the-most-from-the-new-multi-camera-api.md)
> * 译者：
> * 校对者：

# Getting the Most from the New Multi-Camera API

This blog post complements our [Android Developer Summit 2018 talk](https://youtu.be/u38wOv2a_dA), done in collaboration with Vinit Modi, the Android Camera PM, and Emilie Roberts, from the Partner Developer Relations team. Check out our previous blog posts in the series including [camera enumeration](https://medium.com/androiddevelopers/camera-enumeration-on-android-9a053b910cb5), [camera capture sessions and requests](https://medium.com/androiddevelopers/understanding-android-camera-capture-sessions-and-requests-4e54d9150295) and [using multiple camera streams simultaneously](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482).

### Multi-camera use-cases

Multi-camera was introduced with [Android Pie](https://developer.android.com/about/versions/pie/android-9.0#camera), and since launch a few months ago we are now seeing devices coming to market that support the API like the Google Pixel 3 and Huawei Mate 20 series. Many multi-camera use-cases are tightly coupled with a specific hardware configuration; in other words, not all use-cases will be compatible with every device — which makes multi-camera features a great candidate for [dynamic delivery](https://developer.android.com/studio/projects/dynamic-delivery) of modules. Some typical use-cases include:

*   Zoom: switching between cameras depending on crop region or desired focal length
*   Depth: using multiple cameras to build a depth map
*   Bokeh: using inferred depth information to simulate a DSLR-like narrow focus range

### Logical and physical cameras

To understand the multi-camera API, we must first understand the difference between logical and physical cameras; the concept is best illustrated with an example. For instance, we can think of a device with three back-facing cameras and no front-facing cameras as a reference. In this example, each of the three back cameras is considered a _physical camera_. A _logical camera_ is then a grouping of two or more of those physical cameras. The output of the logical camera can be a stream that comes from one of the underlying physical cameras, or a fused stream coming from multiple underlying physical cameras simultaneously; either way that is handled by the camera HAL.

Many phone manufacturers also develop their first-party camera applications (which usually come pre-installed on their devices). To utilize all of the hardware’s capabilities, they sometimes made use of private or hidden APIs or received special treatment from the driver implementation that other applications did not have privileged access to. Some devices even implemented the concept of logical cameras by providing a fused stream of frames from the different physical cameras but, again, this was only available to certain privileged applications. Often, only one of the physical cameras would be exposed to the framework. The situation for third party developers prior to Android Pie is illustrated in the following diagram:

![](https://cdn-images-1.medium.com/max/800/0*jHgc12zW0MnFXf8V)

Camera capabilities typically only available to privileged applications

Beginning in Android Pie, a few things have changed. For starters, [private APIs are no longer OK](https://developer.android.com/about/versions/pie/restrictions-non-sdk-interfaces) to use in Android apps. Secondly, with the inclusion of [multi-camera support](https://source.android.com/devices/camera/multi-camera) in the framework, Android has been [strongly recommending](https://source.android.com/compatibility/android-cdd#7_5_4_camera_api_behavior) that phone manufacturers expose a logical camera for all physical cameras facing the same direction. As a result, this is what third party developers should expect to see on devices running Android Pie and above:

![](https://cdn-images-1.medium.com/max/800/0*xnN-9_1XtmuWq-Lx)

Full developer access to all camera devices starting in Android P

It is worth noting that what the logical camera provides is entirely dependent on the OEM implementation of the Camera HAL. For example, a device like Pixel 3 implements its logical camera in such a way that it will choose one of its physical cameras based on the requested focal length and crop region.

### The multi-camera API

The new API consists in the addition of the following new constants, classes and methods:

*   `CameraMetadata.REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA`
*   `CameraCharacteristics.getPhysicalCameraIds()`
*   `CameraCharacteristics.getAvailablePhysicalCameraRequestKeys()`
*   `CameraDevice.createCaptureSession(SessionConfiguration config)`
*   `CameraCharactersitics.LOGICAL_MULTI_CAMERA_SENSOR_SYNC_TYPE`
*   `OutputConfiguration` & `SessionConfiguration`

Thanks to changes to the [Android CDD](https://source.android.com/compatibility/android-cdd#7_5_4_camera_api_behavior), the multi-camera API also comes with certain expectations from developers. Devices with dual cameras existed prior to Android Pie, but opening more than one camera simultaneously involved trial and error; multi-camera on Android now gives us a set of rules that tell us when we can open a pair of physical cameras as long as they are part of the same logical camera.

As stated above, we can expect that, in most cases, new devices launching with Android Pie will expose all physical cameras (the exception being more exotic sensor types such as infrared) along with an easier to use logical camera. Also, and very crucially, we can expect that for every combination of streams that are guaranteed to work, one stream belonging to a logical camera can be replaced by **two** streams from the underlying physical cameras. Let’s cover that in more detail with an example.

### Multiple streams simultaneously

In our last blog post, we covered extensively the rules for [using multiple streams simultaneously](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482) in a single camera. The exact same rules apply for multiple cameras with a notable addition explained in [the documentation](https://developer.android.com/reference/android/hardware/camera2/CameraMetadata#REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA):

> For each guaranteed stream combination, the logical camera supports replacing one logical [YUV_420_888](https://developer.android.com/reference/android/graphics/ImageFormat.html#YUV_420_888) or raw stream with two physical streams of the same size and format, each from a separate physical camera, given that the size and format are supported by both physical cameras.

In other words, each stream of type YUV or RAW can be replaced with _two_ streams of identical type and size. So, for example, we could start with a camera stream of the following guaranteed configuration for single-camera devices:

*   Stream 1: YUV type, MAXIMUM size from logical camera `id = 0`

Then, a device with multi-camera support will allow us to create a session replacing that logical YUV stream with two physical streams:

*   Stream 1: YUV type, MAXIMUM size from physical camera `id = 1`
*   Stream 2: YUV type, MAXIMUM size from physical camera `id = 2`

The trick is that we can replace a YUV or RAW stream with two equivalent streams if and only if those two cameras are part of a logical camera grouping — i.e. listed under [CameraCharacteristics.getPhysicalCameraIds()](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#getPhysicalCameraIds%28%29).

Another thing to consider is that the guarantees provided by the framework are just the bare minimum required to get frames from more than one physical camera simultaneously. We can expect for additional streams to be supported in most devices, sometimes even letting us open multiple physical camera devices independently. Unfortunately, since it’s not a hard guarantee from the framework, doing that will require us to perform per-device testing and tuning via trial and error.

### Creating a session with multiple physical cameras

When we interact with physical cameras in a multi-camera enabled device, we should open a single [CameraDevice](https://developer.android.com/reference/android/hardware/camera2/CameraDevice) (the logical camera) and interact with it within a single session, which must be created using the API [CameraDevice.createCaptureSession(SessionConfiguration config)](https://developer.android.com/reference/android/hardware/camera2/CameraDevice#createCaptureSession%28android.hardware.camera2.params.SessionConfiguration%29) available since SDK level 28. Then, the [session configuration](https://developer.android.com/reference/android/hardware/camera2/params/SessionConfiguration) will have a number of [output configurations](https://developer.android.com/reference/android/hardware/camera2/params/OutputConfiguration), each of which will have a set of output targets and, optionally, a desired physical camera ID.

![](https://cdn-images-1.medium.com/max/800/0*OY88erAolXSr5bA9)

SessionConfiguration and OutputConfiguration model

Later, when we dispatch a capture request, said request will have an output target associated with it. The framework will determine which physical (or logical) camera the request will be sent to based on what output target is attached to the request. If the output target corresponds to one of the output targets that was sent as an [output configuration](https://developer.android.com/reference/android/hardware/camera2/params/OutputConfiguration) along with a physical camera ID, then that physical camera will receive and process the request.

### Using a pair of physical cameras

One of the most important developer-facing additions to the camera APIs for multi-camera is the ability to identify logical cameras and finding the physical cameras behind them. Now that we understand that we can open physical cameras simultaneously (again, by opening the logical camera and as part of the same session) and the rules for combining streams are clear, we can define a function to help us identify potential pairs of physical cameras that can be used to replace one of the logical camera streams:

```
/**
* Helper class used to encapsulate a logical camera and two underlying
* physical cameras
*/
data class DualCamera(val logicalId: String, val physicalId1: String, val physicalId2: String)

fun findDualCameras(manager: CameraManager, facing: Int? = null): Array<DualCamera> {
    val dualCameras = ArrayList<DualCamera>()

    // Iterate over all the available camera characteristics
    manager.cameraIdList.map {
        Pair(manager.getCameraCharacteristics(it), it)
    }.filter {
        // Filter by cameras facing the requested direction
        facing == null || it.first.get(CameraCharacteristics.LENS_FACING) == facing
    }.filter {
        // Filter by logical cameras
        it.first.get(CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES)!!.contains(
                CameraCharacteristics.REQUEST_AVAILABLE_CAPABILITIES_LOGICAL_MULTI_CAMERA)
    }.forEach {
        // All possible pairs from the list of physical cameras are valid results
        // NOTE: There could be N physical cameras as part of a logical camera grouping
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

State handling of the physical cameras is controlled by the logical camera. So, to open our “dual camera” we just need to open the logical camera corresponding to the physical cameras that we are interested in:

```
fun openDualCamera(cameraManager: CameraManager,
                   dualCamera: DualCamera,
                   executor: Executor = AsyncTask.SERIAL_EXECUTOR,
                   callback: (CameraDevice) -> Unit) {

    cameraManager.openCamera(
            dualCamera.logicalId, executor, object : CameraDevice.StateCallback() {
        override fun onOpened(device: CameraDevice) = callback(device)
        // Omitting for brevity...
        override fun onError(device: CameraDevice, error: Int) = onDisconnected(device)
        override fun onDisconnected(device: CameraDevice) = device.close()
    })
}
```

Up until this point, besides selecting which camera to open, nothing is different compared to what we have been doing to open any other camera in the past. Now it’s time to create a capture session using the new [session configuration](https://developer.android.com/reference/android/hardware/camera2/params/SessionConfiguration) API so we can tell the framework to associate certain targets with specific physical camera IDs:

```
/**
 * Helper type definition that encapsulates 3 sets of output targets:
 *
 *   1. Logical camera
 *   2. First physical camera
 *   3. Second physical camera
 */
typealias DualCameraOutputs =
        Triple<MutableList<Surface>?, MutableList<Surface>?, MutableList<Surface>?>

fun createDualCameraSession(cameraManager: CameraManager,
                            dualCamera: DualCamera,
                            targets: DualCameraOutputs,
                            executor: Executor = AsyncTask.SERIAL_EXECUTOR,
                            callback: (CameraCaptureSession) -> Unit) {

    // Create 3 sets of output configurations: one for the logical camera, and
    // one for each of the physical cameras.
    val outputConfigsLogical = targets.first?.map { OutputConfiguration(it) }
    val outputConfigsPhysical1 = targets.second?.map {
        OutputConfiguration(it).apply { setPhysicalCameraId(dualCamera.physicalId1) } }
    val outputConfigsPhysical2 = targets.third?.map {
        OutputConfiguration(it).apply { setPhysicalCameraId(dualCamera.physicalId2) } }

    // Put all the output configurations into a single flat array
    val outputConfigsAll = arrayOf(
            outputConfigsLogical, outputConfigsPhysical1, outputConfigsPhysical2)
            .filterNotNull().flatMap { it }

    // Instantiate a session configuration that can be used to create a session
    val sessionConfiguration = SessionConfiguration(SessionConfiguration.SESSION_REGULAR,
            outputConfigsAll, executor, object : CameraCaptureSession.StateCallback() {
        override fun onConfigured(session: CameraCaptureSession) = callback(session)
        // Omitting for brevity...
        override fun onConfigureFailed(session: CameraCaptureSession) = session.device.close()
    })

    // Open the logical camera using our previously defined function
    openDualCamera(cameraManager, dualCamera, executor = executor) {

        // Finally create the session and return via callback
        it.createCaptureSession(sessionConfiguration)
    }
}
```

At this point, we can refer back to the [documentation](https://developer.android.com/reference/android/hardware/camera2/CameraDevice.html#createCaptureSession%28android.hardware.camera2.params.SessionConfiguration%29) or our [previous blog post](https://medium.com/androiddevelopers/using-multiple-camera-streams-simultaneously-bf9488a29482) to understand which combinations of streams are supported. We just need to remember that those are for multiple streams on a single logical camera, and that the compatibility extends to using the same configuration and replacing one of those streams with two streams from two physical cameras that are part of the same logical camera.

With the [camera session](https://developer.android.com/reference/android/hardware/camera2/CameraCaptureSession) ready, all that is left to do is dispatching our desired [capture requests](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest). Each target of the capture request will receive its data from its associated physical camera, if any, or fall back to the logical camera.

### Zoom example use-case

To tie all of that back to one of the initially discussed use-cases, let’s see how we could implement a feature in our camera app so that users can switch between the different physical cameras to experience a different field-of-view — effectively capturing a different “zoom level”.

![](https://cdn-images-1.medium.com/max/800/0*WaZN9bicOXI4mpUp)

Example of swapping cameras for zoom level use-case (from [Pixel 3 Ad](https://www.youtube.com/watch?v=gJtJFEH1Cis))

First, we must select the pair of physical cameras that we want to allow users to switch between. For maximum effect, we can search for the pair of cameras that provide the minimum and maximum focal length available, respectively. That way, we select one camera device able to focus on the shortest possible distance and another that can focus at the furthest possible point:

```
fun findShortLongCameraPair(manager: CameraManager, facing: Int? = null): DualCamera? {

    return findDualCameras(manager, facing).map {
        val characteristics1 = manager.getCameraCharacteristics(it.physicalId1)
        val characteristics2 = manager.getCameraCharacteristics(it.physicalId2)

        // Query the focal lengths advertised by each physical camera
        val focalLengths1 = characteristics1.get(
                CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS) ?: floatArrayOf(0F)
        val focalLengths2 = characteristics2.get(
                CameraCharacteristics.LENS_INFO_AVAILABLE_FOCAL_LENGTHS) ?: floatArrayOf(0F)

        // Compute the largest difference between min and max focal lengths between cameras
        val focalLengthsDiff1 = focalLengths2.max()!! - focalLengths1.min()!!
        val focalLengthsDiff2 = focalLengths1.max()!! - focalLengths2.min()!!

        // Return the pair of camera IDs and the difference between min and max focal lengths
        if (focalLengthsDiff1 < focalLengthsDiff2) {
            Pair(DualCamera(it.logicalId, it.physicalId1, it.physicalId2), focalLengthsDiff1)
        } else {
            Pair(DualCamera(it.logicalId, it.physicalId2, it.physicalId1), focalLengthsDiff2)
        }

        // Return only the pair with the largest difference, or null if no pairs are found
    }.sortedBy { it.second }.reversed().lastOrNull()?.first
}
```

A sensible architecture for this would be to have two [SurfaceViews](https://developer.android.com/reference/android/view/SurfaceView), one for each stream, that get swapped upon user interaction so that only one is visible at any given time. In the following code snippet, we demonstrate how to open the logical camera, configure the camera outputs, create a camera session and start two preview streams; leveraging the functions defined previously:

```
val cameraManager: CameraManager = ...

// Get the two output targets from the activity / fragment
val surface1 = ...  // from SurfaceView
val surface2 = ...  // from SurfaceView

val dualCamera = findShortLongCameraPair(manager)!!
val outputTargets = DualCameraOutputs(
        null, mutableListOf(surface1), mutableListOf(surface2))

// Here we open the logical camera, configure the outputs and create a session
createDualCameraSession(manager, dualCamera, targets = outputTargets) { session ->

    // Create a single request which will have one target for each physical camera
    // NOTE: Each target will only receive frames from its associated physical camera
    val requestTemplate = CameraDevice.TEMPLATE_PREVIEW
    val captureRequest = session.device.createCaptureRequest(requestTemplate).apply {
        arrayOf(surface1, surface2).forEach { addTarget(it) }
    }.build()

    // Set the sticky request for the session and we are done
    session.setRepeatingRequest(captureRequest, null, null)
}
```

Now all we need to do is provide a UI for the user to switch between the two surfaces, like a button or double-tapping the `SurfaceView`; if we wanted to get fancy we could try performing some form of scene analysis and switch between the two streams automatically.

### Lens distortion

All lenses produce a certain amount of distortion. In Android, we can query the distortion created by lenses using [CameraCharacteristics.LENS_DISTORTION](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#LENS_DISTORTION) (which replaces the now-deprecated [CameraCharacteristics.LENS_RADIAL_DISTORTION](https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics#LENS_RADIAL_DISTORTION)). For logical cameras, it is reasonable to expect that the distortion will be minimal and our application can use the frames more-or-less as they come from the camera. However, for physical cameras, we should expect potentially very different lens configurations — especially on wide lenses.

Some devices may implement automatic distortion correction via [CaptureRequest.DISTORTION_CORRECTION_MODE](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest#DISTORTION_CORRECTION_MODE). It is good to know that distortion correction defaults to being on for most devices.The documentation has some more detailed information:

> FAST/HIGH_QUALITY both mean camera device determined distortion correction will be applied. HIGH_QUALITY mode indicates that the camera device will use the highest-quality correction algorithms, even if it slows down capture rate. FAST means the camera device will not slow down capture rate when applying correction. FAST may be the same as OFF if any correction at all would slow down capture rate […] The correction only applies to processed outputs such as YUV, JPEG, or DEPTH16 […] This control will be on by default on devices that support this control.

If we wanted to take a still shot from a physical using the highest possible quality, then we should try to set correction mode to HIGH_QUALITY if it’s available. Here’s how we should be setting up our capture request:

```
val cameraSession: CameraCaptureSession = ...

// Use still capture template to build our capture request
val captureRequest = cameraSession.device.createCaptureRequest(
        CameraDevice.TEMPLATE_STILL_CAPTURE)

// Determine if this device supports distortion correction
val characteristics: CameraCharacteristics = ...
val supportsDistortionCorrection = characteristics.get(
        CameraCharacteristics.DISTORTION_CORRECTION_AVAILABLE_MODES)?.contains(
        CameraMetadata.DISTORTION_CORRECTION_MODE_HIGH_QUALITY) ?: false

if (supportsDistortionCorrection) {
    captureRequest.set(
            CaptureRequest.DISTORTION_CORRECTION_MODE, 
            CameraMetadata.DISTORTION_CORRECTION_MODE_HIGH_QUALITY)
}

// Add output target, set other capture request parameters...

// Dispatch the capture request
cameraSession.capture(captureRequest.build(), ...)
```

Keep in mind that setting a capture request in this mode will have a potential impact on the frame rate that can be produced by the camera, which is why we are only setting the distortion correction in still image captures.

### To be continued

Phew! We covered a bunch of things related to the new multi-camera APIs:

*   Potential use-cases
*   Logical vs physical cameras
*   Overview of the multi-camera API
*   Extended rules for opening multiple camera streams
*   How to setup camera streams for a pair of physical cameras
*   Example “zoom” use-case swapping cameras
*   Correcting lens distortion

Note that we have not covered frame synchronization and computing depth maps. That is a topic worthy of its own blog post 🙂

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
