> * 原文地址：[How to Use TensorFlow Mobile in Android Apps](https://code.tutsplus.com/tutorials/how-to-use-tensorflow-mobile-in-android-apps--cms-30957?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Ashraff Hathibelagal](https://tutsplus.com/authors/ashraff-hathibelagal?_ga=2.268364494.17284051.1526005734-367499695.1526005732)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-tensorflow-mobile-in-android-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-tensorflow-mobile-in-android-apps.md)
> * 译者：[luochen](https://github.com/luochen1992)
> * 校对者：

# 如何在安卓应用中使用 TensorFlow Mobile

[TensorFlow](https://www.tensorflow.org/) 是当今最流行的机器学习框架之一，您利用它可以轻松创建和训练深度模型 —— 通常也称为深度前馈神经网络，这些模型可以解决各种复杂问题，如图像分类、目标检测和自然语言理解。[TensorFlow Mobile](https://www.tensorflow.org/mobile/) 是一个旨在帮助您在移动应用中利用这些模型的库。

在本教程中，我将向您展示如何在 Android Studio 项目中使用 TensorFlow Mobile。

## 前期准备

为了能够跟上教程，您需要做的是：

*   [Android Studio](https://developer.android.com/studio/index.html) 3.0 或更高版本
*   [TensorFlow](https://www.tensorflow.org/install/) 1.5.0 或更高版本
*   一台能够运行 API level 21 或更高的安卓设备
*   以及对 TensorFlow 框架的基本了解

## 1、创建模型

在我们开始使用 TensorFlow Mobile 之前，我们需要一个已经训练好的 TensorFlow 模型。我们现在创建一个。

我们的模型将非常基础，类似于异或门，接受两个输入，它们可以是零或一，然后有一个输出。如果两个输入相同，则输出为零。此外，因为它将是一个深度模型，它将有两个隐藏层，一个有四个神经元，另一个有三个神经元。您可以自由改变隐藏层的数量以及它们包含的神经元的数量。

为了保持本教程的简洁，我们将使用 [TFLearn](https://github.com/tflearn/tflearn)，这是一个很受欢迎的 TensorFlow 封装框架，它提供更加直接而简洁的 API，而不是直接使用低级别的 TensorFlow API。如果您还没安装它，请使用以下命令将其安装在 TensorFlow 虚拟环境中：

```python
pip install tflearn
```

要开始创建模型，最好在空目录中先新建一个名为 **create_model.py** 的 Python 脚本，然后使用您最喜欢的文本编辑器打开它。

在文件里，我们需要做的第一件事是导入 TFLearn API。

```python
import tflearn
```

接下来，我们必须创建训练数据。对于我们的简单模型，只有四种可能的输入和输出，类似于异或门真值表的内容。

```python
X = [
    [0, 0],
    [0, 1],
    [1, 0],
    [1, 1]
]
 
Y = [
    [0],  # Desired output for inputs 0, 0
    [1],  # Desired output for inputs 0, 1
    [1],  # Desired output for inputs 1, 0
    [0]   # Desired output for inputs 1, 1
]
```

为隐藏层中的所有神经元分配初始权重时，最好的做法通常是使用从均匀分布中产生的随机数。可以使用 `uniform()` 方法生成这些值。

```python
weights = tflearn.initializations.uniform(minval = -1, maxval = 1)
```

此时，我们可以开始构建神经网络层。要创建输入层，我们必须使用 `input_data()` 方法，它允许我们指定网络可以接受的输入数量。一旦输入层准备就绪，我们可以多次调用 `fully_connected()` 方法来向网络添加更多层。

```python
# 输入层
net = tflearn.input_data(
        shape = [None, 2],
        name = 'my_input'
)
 
# 隐藏层
net = tflearn.fully_connected(net, 4,
        activation = 'sigmoid',
        weights_init = weights
)
net = tflearn.fully_connected(net, 3,
        activation = 'sigmoid',
        weights_init = weights
)
 
# 输出层
net = tflearn.fully_connected(net, 1,
        activation = 'sigmoid', 
        weights_init = weights,
        name = 'my_output'
)
```

注意，在上面的代码中，我们赋予了输入层和输出层有意义的名称。这么做很重要，因为我们在使用安卓应用中的网络时需要它们。还要注意隐藏层和输出层使用了 `sigmoid` 激活函数。您可以试试其他激活函数，例如 `softmax`、`tanh` 和 `relu`。

作为我们网络的最后一层，我们必须使用 `regression()` 函数创建一个回归层，该函数需要一些超参数作为其参数，例如网络的学习率以及它应该使用的优化器和损失函数。以下代码向您展示了如何使用随机梯度下降（简称 SGD）作为优化器函数，均方误差作为损失函数：

```python
net = tflearn.regression(net,
        learning_rate = 2,
        optimizer = 'sgd',
        loss = 'mean_square'
)
```

接下来，为了让 TFLearn 框架知道我们的网络模型实际上是一个深度神经网络模型，我们须要调用 `DNN()` 函数。

```python
model = tflearn.DNN(net)
```

模型现在已经准备好了。我们现在要做的就是使用我们之前创建的训练数据进行训练。因此，调用模型的 `fit()` 方法，并指定训练数据与训练周期。由于训练数据非常小，我们的模型将需要数千次迭代才能达到合理的精度。

```python
model.fit(X, Y, 5000)
```

一旦训练完成，我们可以调用模型的 `predict()` 方法来检查它是否生成期望的输出。以下代码展示了如何检查所有有效输入的输出：

```python
print("1 XOR 0 = %f" % model.predict([[1,0]]).item(0))
print("1 XOR 1 = %f" % model.predict([[1,1]]).item(0))
print("0 XOR 1 = %f" % model.predict([[0,1]]).item(0))
print("0 XOR 0 = %f" % model.predict([[0,0]]).item(0))
```

如果现在运行 Python 脚本，您应该看到如下所示的输出：

![训练后的预测结果](https://cms-assets.tutsplus.com/uploads/users/362/posts/30957/image/Screenshot%20from%202018-04-12%2007-11-00.png)

请注意，输出不会完全是 0 或 1。而是接近 0 或 1 的浮点数。因此，在使用输出时，可能需要使用 Python 的 `round()` 函数。

除非我们在训练后明确保存模型，否则只要程序结束，我们就会失去模型。幸运的是，对于 TFLearn，只需调用 `save()` 方法即可保存模型。但是，为了能够在 TensorFlow Mobile 中使用保存的模型，在保存之前，我们必须确保移除所有训练相关的操作。这些操作都在 tf.GraphKeys.TRAIN_OPS 集合中。以下代码展示了怎么去移除相关操作：

```python
# 移除训练相关的操作
with net.graph.as_default():
    del tf.get_collection_ref(tf.GraphKeys.TRAIN_OPS)[:]
 
# 保存模型
model.save('xor.tflearn')
```

如果您再次运行该脚本，您会发现它会生成检查点文件、元数据文件、索引文件和数据文件，所有这些文件一起使用时可以快速重建我们训练好的模型。

## 2、固化模型

除了保存模型外，我们还必须先固化模型，然后才能将其与 TensorFlow Mobile 配合使用。正如您可能已经猜到的那样，固化模型的过程涉及将其所有变量转换为常量。此外，固化模型必须是符合 Google Protocol Buffers 序列化格式的单个二进制文件。

新建一个名为 **freeze_model.py** 的 Python 脚本，并使用文本编辑器打开它。我们将在这个文件中编写固化的模型代码来。

由于 TFLearn 没有任何固化模型的功能，我们现在必须直接使用 TensorFlow API。通过将以下行添加到文件来导入它们：

```python
import tensorflow as tf
```

整个脚本里面，我们将使用单个 TensorFlow 会话。我们使用 `Session` 类的构造函数创建会话。

```python
with tf.Session() as session:
    # 代码的其他部分在这
```

此时，我们必须通过调用 `import_meta_graph()` 函数并将模型的元数据文件的名称传递给它来创建 `Saver` 对象，除了返回 `Saver` 对象外，`import_meta_graph()` 函数还会自动将模型的图定义添加到会话的图定义中。

一旦创建了保存器（saver），我们可以通过调用 `restore()` 方法来初始化图定义中存在的所有变量，该方法需要包含模型最新检查点文件的目录路径。

```python
my_saver = tf.train.import_meta_graph('xor.tflearn.meta')
my_saver.restore(session, tf.train.latest_checkpoint('.'))
```

此时，我们可以调用 `convert_variables_to_constants()` 函数来创建一个固化的图定义，其中模型的所有变量都替换成常量。作为其输入，函数需要当前会话、当前会话的图定义以及包含模型输出层名称的列表。

```
frozen_graph = tf.graph_util.convert_variables_to_constants(
    session,
    session.graph_def,
    ['my_output/Sigmoid']
)
```

调用固化图定义的 `SerializeToString()` 方法为我们提供了模型的二进制 protobuf 表示。通过使用 Python 基本的文件 I/O，我建议您把它保存为一个名为 **frozen_model.pb** 的文件。

```python
with open('frozen_model.pb', 'wb') as f:
    f.write(frozen_graph.SerializeToString())
```

现在可以运行脚本来生成固化模型。

我们现在拥有开始使用 TensorFlow Mobile 所需的一切。

## 3、Android Studio 项目设置

TensorFlow Mobile 库可在 JCenter 上使用，所以我们可以直接将它添加为 `app` 模块 **build.gradle** 文件中的 `implementation` 依赖项。

```
implementation 'org.tensorflow:tensorflow-android:1.7.0'
```

要把固化的模型添加到项目中，请将 **frozen_model.pb** 文件放置到项目的 **assets** 文件夹中。

## 4、初始化 TensorFlow 接口

TensorFlow Mobile 提供了一个简单的接口，我们可以使用它与我们的固化模型进行交互。要创建接口，请使用 `TensorFlowInferenceInterface` 类的构造函数，该类需要一个 `AssetManager` 实例和固化模型的文件名。

```
thread {
    val tfInterface = TensorFlowInferenceInterface(assets,
                                        "frozen_model.pb")
     
    // More code here
}
```

在上面的代码中，您可以看到我们正在产生一个新的线程。这是为了确保应用的 UI 保持响应，虽然不必要，但建议这样做。

为了保证 TensorFlow Mobile 能够正确读取我们模型的文件，现在让我们尝试打印模型图中所有操作的名称。为了得到对图的引用，我们可以使用接口的 `graph()` 方法，并获取所有操作，即图的 `operations()` 方法。以下代码告诉您该怎么做：

```
val graph = tfInterface.graph()
graph.operations().forEach {
    println(it.name())
}
```

如果现在运行该应用，则应该能够看到在 Android Studio 的 **Logcat** 窗口中打印的十几个操作名称。如果固化模型时没有出错，我们可以在这些名称中找到输入和输出层的名称：**my_input/X** 和 **my_output/Sigmoid**。

![Logcat 窗口展示了操作列表](https://cms-assets.tutsplus.com/uploads/users/362/posts/30957/image/Screenshot%20from%202018-04-12%2007-19-01.png)

## 5、使用模型

为了用模型进行预测，我们将数据输入到输入层，在输出层得到数据。将数据输入到输入层需要使用接口的 `feed()` 方法，该方法需要输入层的名称、含有输入数据的数组以及数组的维数。以下代码展示如何将数字 `0` 和 `1` 输入到输入层：

```
tfInterface.feed("my_input/X",
            floatArrayOf(0f, 1f), 1, 2)
```

数据加载到输入层后，我们必须使用 `run()` 方法进行推断操作，该方法需要输出层的名称。一旦操作完成，输出层将包含模型的预测。为了将预测结果加载到 Kotlin 数组中，我们可以使用 `fetch()` 方法。以下代码显示了如何执行此操作：

```
tfInterface.run(arrayOf("my_output/Sigmoid"))
 
val output = floatArrayOf(-1f)
tfInterface.fetch("my_output/Sigmoid", output)
```

您现在可以运行该应用来查看模型的预测是否正确。

![Logcat window displaying the prediction](https://cms-assets.tutsplus.com/uploads/users/362/posts/30957/image/Screenshot%20from%202018-04-12%2007-20-12.png)

可以更改输入到输入层的数字，以确认模型的预测始终正确。

## 总结

您现在知道如何创建一个简单的 TensorFlow 模型以及在安卓应用上通过 TensorFlow Mobile 去使用该模型。不过不必拘泥于自己的模型，用您今天学到的东西，使用更大的模型对您来说应该没有任何问题。例如 MobileNet 以及 Inception，这些都可以在 TensorFlow 的 [模型园](https://github.com/tensorflow/models "Link: https://github.com/tensorflow/models") 里找到。但是请注意，这些模型会使 APK 更大，从而给使用低端设备的用户造成问题。

要了解有关 TensorFlow Mobile 的更多信息，请参阅 [官方文档](https://www.tensorflow.org/mobile/mobile_intro "Link: https://www.tensorflow.org/mobile/mobile_intro").


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
