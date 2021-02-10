> * 原文地址：[Machine Learning with Android 11: What’s new](https://proandroiddev.com/machine-learning-with-android-11-whats-new-1a8d084c7398)
> * 原文作者：[Rishit Dagli](https://medium.com/@rishit.dagli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/machine-learning-with-android-11-whats-new.md](https://github.com/xitu/gold-miner/blob/master/article/2021/machine-learning-with-android-11-whats-new.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 使用 Android 11 进行机器学习：新功能

![使用 Android 11 进行机器学习：新功能](https://cdn-images-1.medium.com/max/3840/1*_6zTCa-SeOV2q549ey3b5Q.jpeg)

本文将会向大家展示如何使用专门在 [Android 11](https://developer.android.com/11) 上启动的工具或插件来开始使用设备上的机器学习功能。如果你以前在 Android 中使用过机器学习，则可以跟随本文一起探索将机器学习应用程序与 Android 应用程序集成的更简便方法。而如果你以前没有在 Android 中使用过机器学习，那么这可能是你使用 Android 进行机器学习的起点，并开始你使用机器学习为你的 Android 应用程序提供超强功能之旅。在此博客中，我将主要演示 Android 11 的两个最强大的更新：[机器学习模型绑定插件](https://developer.android.com/studio/preview/features#tensor-flow-lite-models)和[新的机器学习套件](https://g.co/mlkit)。我们下面讨论的所有示例应用程序代码都在[此 GitHub 存储库](https://github.com/Rishit-dagli/ML-with-Android-11)中可以找到。

你也可以在 [GitHub 存储库](https://github.com/Rishit-dagli/ML-with-Android-11/blob/master/talks.md)中查看有关该主题的讨论。

## 为什么我们要关心 Android 设备上机器学习功能？

如你所见，我们在本文中主要关注设备上的机器学习。Android 11 对设备上的机器学习做出了许多很酷的更新，但让我们简单地谈一谈你为什么要对此加以关注，你还将了解为什么有这么多人宣传设备上的机器学习或边缘机器学习。

**设备上的机器学习这个思路的背后：**

这里使用机器学习的想法与我们的旧有方法恰好相反，我们不再将设备上的数据发送到服务器或某个基于云的系统，在上面执行机器学习，然后再输出返回给设备。取而代之的是，直接利用设备本身上的机器学习模型获取输出或推断，即不再让设备发送数据给服务器判断数据，利用移动设备本身，完成所有的处理和推断。

![设备上的机器学习这个思路的背后](https://cdn-images-1.medium.com/max/3836/1*O1a_Su6P-XggXk9IXTSzMQ.jpeg)

你不会直接将模型用于你的设备，而需要压缩或优化模型，以便可以在设备上运行它，因为它的计算能力、网络可用性和磁盘空间有限。但是，在本文中，我们将不讨论优化过程。我们将直接部署 `.tflite` 模型文件。您可以通过使用 TensorFlow Lite 进一步了解 [TensorFlow Lite](https://www.tensorflow.org/lite/)和[模型优化过程](https://www.tensorflow.org/lite/performance/model_optimization)。

**内置机器学习的优势**

在这里，我列出了使用设备上机器学习的一些优点：

* 能量消耗 我所能够想到的第一件事就是功耗：你本来是需要花费大量的精力将视频数据连续发送或流式传输到服务器，但有时这样做是不可行的。值得一提的是，当你进行大量预处理时，有些时候倒是能够实现节省功耗。

* 推断时间 要考虑的另一重要事项是我获得输出或实质上运行模型所花费的时间。对于实时应用程序，这是一个非常重要的方面。在不发送数据且不必接收数据的情况下，我也加快了推理速度。

* 网络可用性 就网络可用性而言，使用传统方法是依赖于网络通信的。设备必须在带宽或网络的连接下才能够连续发送数据并从服务器接收推论。

* 安全 最后，安全性也将提升：设备不再需要将数据发送到服务器或基于云的系统，即不再将数据发送出设备，从而增强了安全性。

## ML模型绑定插件

> 注意：您需要 Android Studio 4.1 或更高版本才能使用模型绑定插件

**模型绑定插件关注什么？**

您可以从“模型构建”这个名称中做出足够合理的猜测，以了解[机器学习模型绑定插件]的用途(https://developer.android.com/studio/preview/features#tensor-flow-lite-models)确实可以使我们非常轻松地使用自定义 TF Lite 模型。这使开发人员可以导入任何 TFLite 模型，读取模型的输入或输出的签名，并将其与仅几行代码一起使用，以调用开源 TensorFlow Lite Android 支持库。

机器学习模型绑定插件使您可以在应用程序中轻松使用 TF 模型。从本质上讲，你需要编写的代码少得多，可以调用 TensorFlow Lite Android 支持库。如果您使用过 TensorFlow Lite 模型，则可能知道您首先需要将所有内容都转换为 `ByteArray`，而不再需要使用机器学习模型绑定插件将所有内容都转换为 `ByteArray`。

我也喜欢这个新插件，因为您可以轻松地轻松使用 GPU 和 NN API。使用模型绑定插件，使用它们从未如此简单。现在，使用它们只是一个依赖项调用，而只需要一行代码就不能像使用 Model Binding 插件那样酷。借助 Android 11 The Neural Network API，您还具有无符号整数权重支持和新的服务质量（QOS）API，也支持更多边缘场景。当然，这将使您使用我们刚刚谈到的功能可以更快地进行开发。

**使用模型绑定插件**

现在让我们看看如何实现所讨论的所有内容。

因此，第一步是导入带有元数据的 TensorFlow Lite 模型。 Android Studio 现在有一个用于导入 TensorFlow 模型的新选项，只需右键单击要导入它的模块，您就会在“其他”下看到一个名为 `TF Lite Model` 的选项。

![Android Studio中的导入模型选项](https://cdn-images-1.medium.com/max/2500/1*fnNNyLYKqafERAjUfwPsxQ.jpeg)

现在，您只需传递 `tflite` 模型的路径即可，它将在您之前选择的模块 `ml` 中的目录中为您导入模型，您可以在其中使用该模型。只需单击即可添加依赖性和 GPU 加速。

![导入 `tflite` 模型](https://cdn-images-1.medium.com/max/2502/1*wJmnVf7wtCOV50HnXXmmPQ.jpeg)

因此，现在从我的模型元数据中，我还可以知道输入，输出形状以及需要使用的更多信息，您可以通过在 Android Studio 中打开 `tflite` 模型文件来查看此信息。因此，在此屏幕截图中，我使用的是我制作的开源模型来对石头，纸张和剪刀进行分类。因此，您只需将手放在相机前即可识别出是石头纸还是剪刀，这也是我在此处演示的内容。

![查看模型元数据](https://cdn-images-1.medium.com/max/2502/1*ZHuSORcTLhxtSWr60TzxWA.jpeg)

最后，让我们开始使用该模型，以便进行流推断，这很可能是您想要执行的操作；实时图像分类。最简单的方法是使用 Camera X，并将每个帧传递给可以执行推理的功能。因此，到目前为止，我感兴趣的是进行推断的函数。您将看到执行此操作非常容易，在导入可以使用的 TF Lite 模型时，似乎也会有一个示例代码。

```kotlin
private val rpsModel = RPSModel.newInstance(ctx)
```

因此，我们将首先实例化一个 `rps` 模型，该模型是剪刀石头布模型的缩写，并将其传递给上下文。使用该插件，我的模型名称为 `RPS Model.tflite`，因此将为您创建一个完全相同名称的类，因此我有一个名为 `RPS Model` 的类。

```kotlin
val tfImage = TensorImage.fromBitmap(toBitmap(imageProxy))
```

完成此操作后，您需要将数据转换为可使用的格式，以便将其从 `Bitmap` 转换为 `Tensor Image`，如果您使用 TF 解释器，则知道需要将图像转换为一个`ByteArray`，您无需再这样做了，您将输入一个图像代理

```kotlin
val outputs = rpsModel.process(tfImage)
    .probabilityAsCategoryList.apply {
        sortByDescending { it.score } // Sort with highest confidence first
    }.take(MAX_RESULT_DISPLAY) // take the top results
```

所以现在我们将数据传递给模型，所以首先我们将处理模型中的图像并获得输出，我们将基本上得到一个概率数组并对其进行降序排序，因为我们想显示标签中具有最大数量的标签。概率，然后选择第一个 `n` 个结果进行显示。

```kotlin
for (output in outputs) {
    items.add(
        Recognition(
            output.label,
            output.score
        )
    )
}
```

最后，我想向用户显示标签，以便在输出中添加与每个条目相对应的标签。这就是您所需要的 🚀～

**利用GPU加速**

如果您想再次使用 GPU 加速，这对您来说非常容易，那么您将在我指定要使用 GPU 并进行构建的地方创建一个 `options` 对象。在实例化部分，我只是将其作为参数传递，您可以使用 GPU。这也使得使用 NN API 加速并在 Android 11 上执行更多操作变得非常容易。

```kotlin
private val options = Model.Options.Builder().setDevice(Model.Device.GPU).build()
private val rpsModel = rpsModel.newInstance(ctx, options)
```

## 一个新的机器学习套件

> 你现在不再需要 Firebase 项目来与 ML Kit 一起使用，即使在 Firebase 中也可以使用它。

另一个值得注意的更新另一个实现 TensorFlow Lite 模型的方法是通过 [ML Kit](https://g.co/mlkit)。而且，即使我无需使用 Firebase 项目，现在也可以使用 ML Kit，而现在即使没有 Firebase 项目也可以使用 ML Kit。

正如我之前提到的，由于我之前提到的好处，Android 11 中的许多更新都集中在设备上的机器学习上。现在，新的 ML Kit 在设备上具有更好的可用性。ML Kit [图像分类](https://developers.google.com/ml-kit/vision/image-labeling/custom-models/android)和[对象检测和跟踪（ODT）](https://developers.google.com/ml-kit/vision/object-detection/custom-models/android)现在也支持自定义模型，这意味着您现在还可以拥有一个 `tflite` 模型文件。这也意味着如果您正在处理某些通用用例，例如特定类型的对象检测，那么 ML Kit 是最好的选择。

**使用 ML Kit**

让我们在代码中看到这一点，并看到一个示例。因此，在此我以一个示例为例，建立一个可以对不同食品分类的模型，

```kotlin
private localModel = LocalModel.Builder()
    .setAssetFilePath("lite-model_aiy_vision_classifier_food_V1_1.tflite").
    .build()
```

因此，我将首先通过设置模型并为其指定 `tflite` 模型文件路径开始。

```kotlin
private val customObjectDetectorOptions = CustomObjectDetectorOptions
    .Builder(localModel)
    .setDetectorMode(CustomObjectDetectorOptions.STREAM_MODE) 
    .setClassificationConfidenceThreshold(0.8f) 
    .build()
```

然后，此 `tflite` 模型将在带有 ML Kit 的对象检测模型的顶部运行，因此您可以稍微自定义这些选项。在这里，由于要使用流输入并指定置信度阈值，因此我专门使用了 `STREAM_MODE`。

```kotlin
private val objectDetector = ObjectDetection.getClient(customObjectDetectorOptions) objectDetector.process(image) 
    .addOnFailureListener(Log.d(...))

    .addOnSuccessListener{ 
        graphicsOverlay.clear() 
        for (detectedObject in it){ 
            graphicsOverlay.add(ObjectGraphic(graphicsOverlay, detectedObject))
        } 
        graphicsOverlay.postInvalidate()} 

    .addOnCompleteListenerl imageProxy.close() }
```

因此，让我们进入运行模型的那一部分，这样您可能会看到一些类似于此处前面示例的语法。我将处理我的图像，这里需要注意的是，所有处于失败或成功状态的侦听器都是必不可少的任务，因此每次运行都需要附加这些侦听器。这就是您需要做的，我们已经完成 🚀～

## 查找模型

我们讨论了很多有关模型制作后的内容，让我们看看如何为您的用例找到模型。

* TF Lite Model Maker

TensorFlow 团队也于 2020 年初开启了 TF Lite Model Maker。这使得制作好的模型超级容易使用，具有很高的性能，还可以进行大量的自定义。您可以简单地传递数据并使用很少的代码来构建 `tflite` 模型。您可以查看回购中存在的 [TensorFlow Lite Model Maker 示例](https://github.com/Rishit-dagli/ML-with-Android-11/blob/dev/TensorFlow_Lite_Model_Maker_example.ipynb)。

* TensorFlow Hub

TensorFlow Hub 是一个开放源代码存储库，其中包含最新技术和有据可查的模型。我们使用 ML Kit 构建的食品分类应用程序也出现在 TF Hub 上。您还可以使用社区中的模型。您可以在 [tfhub.dev](https://tfhub.dev/) 上找到它们。

![tfhub.dev 上的一些发布者](https://cdn-images-1.medium.com/max/2022/0*cv-fzgw2WPuf4PQI.png)

![TF Hub 中的过滤器](https://cdn-images-1.medium.com/max/2000/1*Cu-XiVrzOi2MdKatQ1dpzw.png)

如果您只想查找基于图像或文本的模型，则可以在 TF Hub 中搜索带有多个过滤器的模型，例如“问题域”；如果要在网络，边缘设备或 Corals 上运行，请使用“模型”格式，过滤架构，使用的数据集等等。

您可以进一步直接从 TF Hub 下载这些模型，也可以非常轻松地使用您自己的数据对其进行转移学习。但是，在本博客的范围内，我们将不介绍 TF Hub 的转移学习，您可以在[我的博客](https://towardsdatascience.com/building-better-ai-apps-and-tf-hub-88716b302265)看到更多信息。

还有很多！有很多服务，例如 [Teachable Machine](https://teachablemachine.withgoogle.com/)，[AutoML](https://cloud.google.com/automl)，还有许多其他服务，但这是主要的服务。

---

[GitHub 仓库](https://github.com/Rishit-dagli/ML-with-Android-11) 中提供了此处展示的有关 TF Lite Model Maker 的示例的所有代码。在回购中，我还为您提供了一些经过训练的模型，供您入门和尝试使用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
