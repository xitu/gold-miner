> * 原文地址：[How to Use TensorFlow Mobile in Android Apps](https://code.tutsplus.com/tutorials/how-to-use-tensorflow-mobile-in-android-apps--cms-30957?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Ashraff Hathibelagal](https://tutsplus.com/authors/ashraff-hathibelagal?_ga=2.268364494.17284051.1526005734-367499695.1526005732)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-tensorflow-mobile-in-android-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-tensorflow-mobile-in-android-apps.md)
> * 译者：
> * 校对者：

# 	
How to Use TensorFlow Mobile in Android Apps

With [TensorFlow](https://www.tensorflow.org/), one of the most popular machine learning frameworks available today, you can easily create and train deep models—also commonly referred to as deep feed-forward neural networks—that can solve a variety of complex problems, such as image classification, object detection, and natural language comprehension. [TensorFlow Mobile](https://www.tensorflow.org/mobile/) is a library designed to help you leverage those models in your mobile apps.

In this tutorial, I'll show you how to use TensorFlow Mobile in Android Studio projects.

## Prerequisites

To be able to follow this tutorial, you'll need:

*   [Android Studio](https://developer.android.com/studio/index.html) 3.0 or higher
*   [TensorFlow](https://www.tensorflow.org/install/) 1.5.0 or higher
*   an Android device running API level 21 or higher
*   and a basic understanding of the TensorFlow framework

## 1. Creating a Model

Before we start using TensorFlow Mobile, we'll need a trained TensorFlow model. Let's create one now.

Our model is going to be very basic. It will behave like an XOR gate, taking two inputs, both of which can be either zero or one, and producing one output, which will be zero if both the inputs are identical and one otherwise. Additionally, because it's going to be a deep model, it will have two hidden layers, one with four neurons, and another with three neurons. You are free to change the number of hidden layers and the numbers of neurons they contain.

In order to keep this tutorial short, instead of using the low-level TensorFlow APIs directly, we'll be using [TFLearn](https://github.com/tflearn/tflearn), a popular wrapper framework for TensorFlow offering more intuitive and concise APIs. If you don't have it already, use the following command to install it inside your TensorFlow virtual environment:

```
pip install tflearn
```

To start creating the model, create a Python script named **create_model.py**, preferably in an empty directory, and open it with your favorite text editor.

Inside the file, the first thing we need to do is import the TFLearn APIs.

```
import tflearn
```

Next, we must create the training data. For our simple model, there will be only four possible inputs and outputs, which will resemble the contents of the XOR gate's truth table.

```
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

It is usually a good idea to use random values picked from a uniform distribution while assigning initial weights to all the neurons in the hidden layers. To generate the values, use the `uniform()` method.

```
weights = tflearn.initializations.uniform(minval = -1, maxval = 1)
```

At this point, we can start creating the layers of our neural network. To create the input layer, we must use the `input_data()` method, which allows us to specify the number of inputs the network can accept. Once the input layer is ready, we can call the `fully_connected()` method multiple times to add more layers to the network.

```
# Input layer
net = tflearn.input_data(
        shape = [None, 2],
        name = 'my_input'
)
 
# Hidden layers
net = tflearn.fully_connected(net, 4,
        activation = 'sigmoid',
        weights_init = weights
)
net = tflearn.fully_connected(net, 3,
        activation = 'sigmoid',
        weights_init = weights
)
 
# Output layer
net = tflearn.fully_connected(net, 1,
        activation = 'sigmoid', 
        weights_init = weights,
        name = 'my_output'
)
```

Note that in the above code, we have given meaningful names to the input and output layers. Doing so is important because we'll need them while using the network from our Android app. Also note that the hidden and output layers are using the `sigmoid` activation function. You are free to experiment with other activation functions, such as `softmax`, `tanh`, and `relu`.

As the last layer of our network, we must create a regression layer using the `regression()` function, which expects a few hyper-parameters as its arguments, such as the network's learning rate and the optimizer and loss functions it should use. The following code shows you how to use stochastic gradient descent, SGD for short, as the optimizer function and mean square as the loss function:

```
net = tflearn.regression(net,
        learning_rate = 2,
        optimizer = 'sgd',
        loss = 'mean_square'
)
```

Next, in order to let the TFLearn framework know that our network model is actually a deep neural network model, we must call the `DNN()` function.

```
model = tflearn.DNN(net)
```

The model is now ready. All we need to do now is train it using the training data we created earlier. So call the `fit()` method of the model and, along with the training data, specify the number of training epochs to run. Because the training data is very small, our model will need thousands of epochs to attain reasonable accuracy.

```
model.fit(X, Y, 5000)
```

Once the training is complete, we can call the `predict()` method of the model to check if it is generating the desired outputs. The following code shows you how to check the outputs for all valid inputs:

```
print("1 XOR 0 = %f" % model.predict([[1,0]]).item(0))
print("1 XOR 1 = %f" % model.predict([[1,1]]).item(0))
print("0 XOR 1 = %f" % model.predict([[0,1]]).item(0))
print("0 XOR 0 = %f" % model.predict([[0,0]]).item(0))
```

If you run the Python script now, you should see output that looks like this:

![Predictions after training](https://cms-assets.tutsplus.com/uploads/users/362/posts/30957/image/Screenshot%20from%202018-04-12%2007-11-00.png)

Note that the outputs are never exactly 0 or 1. Instead, they are floating-point numbers that are either close to zero or close to one. Therefore, while using the outputs, you might want to use Python's `round()` function.

Unless we explicitly save the model after training it, we will lose it as soon as the script ends. Fortunately, with TFLearn, a simple call to the `save()` method saves the model. However, to be able to use the saved model with TensorFlow Mobile, before saving it, we must make sure we remove all the training-related operations, which are present in the `tf.GraphKeys.TRAIN_OPS` collection, associated with it. The following code shows you how to do so:

```
# Remove train ops
with net.graph.as_default():
    del tf.get_collection_ref(tf.GraphKeys.TRAIN_OPS)[:]
 
# Save the model
model.save('xor.tflearn')
```

If you run the script again, you'll see that it generates a checkpoint file, a metadata file, an index file, and a data file, all of which when used together can quickly recreate our trained model.

## 2 Freezing the Model

In addition to saving the model, we must freeze it before we can use it with TensorFlow Mobile. The process of freezing a model, as you might have guessed, involves converting all its variables into constants. Additionally, a frozen model must be a single binary file that conforms to the Google Protocol Buffers serialization format.

Create a new Python script named **freeze_model.py** and open it using a text editor. We'll be writing all the code to freeze our model inside this file.

Because TFLearn doesn't have any functions for freezing models, we'll have to use the TensorFlow APIs directly now. Import them by adding the following line to the file:

```
import tensorflow as tf
```

Throughout the script, we'll be using a single TensorFlow session. To create the session, use the constructor of the `Session` class.

```
with tf.Session() as session:
    # Rest of the code goes here
```

At this point, we must create a `Saver` object by calling the `import_meta_graph()` function and passing the name of the model's metadata file to it. In addition to returning a `Saver` object, the `import_meta_graph()` function also automatically adds the graph definition of the model to the graph definition of the session.

Once the saver is created, we can initialize all the variables that are present in the graph definition by calling the `restore()` method, which expects the path of the directory containing the model's latest checkpoint file.

```
my_saver = tf.train.import_meta_graph('xor.tflearn.meta')
my_saver.restore(session, tf.train.latest_checkpoint('.'))
```

At this point, we can call the `convert_variables_to_constants()` function to create a frozen graph definition where all the variables of the model are replaced with constants. As its inputs, the function expects the current session, the current session's graph definition, and a list containing the names of the model's output layers.

```
frozen_graph = tf.graph_util.convert_variables_to_constants(
    session,
    session.graph_def,
    ['my_output/Sigmoid']
)
```

Calling the `SerializeToString()` method of the frozen graph definition gives us a binary protobuf representation of the model. By using Python's basic file I/O facilities, I suggest you save it as a file named **frozen_model.pb**.

```
with open('frozen_model.pb', 'wb') as f:
    f.write(frozen_graph.SerializeToString())
```

You can run the script now to generate the frozen model.

We now have everything we need to start using TensorFlow Mobile.

## 3. Android Studio Project Setup

The TensorFlow Mobile library is available on JCenter, so we can directly add it as an `implementation` dependency in the `app` module's **build.gradle** file.

```
implementation 'org.tensorflow:tensorflow-android:1.7.0'
```

To add the frozen model to the project, place the **frozen_model.pb** file in the project's **assets** folder.

## 4. Initializing the TensorFlow Interface

TensorFlow Mobile offers a simple interface we can use to interact with our frozen model. To create the interface, use the constructor of the `TensorFlowInferenceInterface` class, which expects an `AssetManager` instance and the filename of the frozen model.

```
thread {
    val tfInterface = TensorFlowInferenceInterface(assets,
                                        "frozen_model.pb")
     
    // More code here
}
```

In the above code, you can see that we're spawning a new thread. Doing so, although not always necessary, is recommended in order to make sure that the app's UI stays responsive.

To be sure that TensorFlow Mobile has managed to read our model's file correctly, let's now try printing the names of all the operations that are present in the model's graph. To get a reference to the graph, we can use the `graph()` method of the interface, and to get all the operations, the `operations()` method of the graph. The following code shows you how:

```
val graph = tfInterface.graph()
graph.operations().forEach {
    println(it.name())
}
```

If you run the app now, you should be able to see over a dozen operation names printed in Android Studio's **Logcat** window. Among all those names, if there were no errors while freezing the model, you'll be able to find the names of the input and output layers: **my_input/X** and **my_output/Sigmoid**.

![Logcat window showing list of operations](https://cms-assets.tutsplus.com/uploads/users/362/posts/30957/image/Screenshot%20from%202018-04-12%2007-19-01.png)

## 5. Using the Model

To make predictions with the model, we must put data into its input layer and retrieve data from its output layer. To put data into the input layer, use the `feed()` method of the interface, which expects the name of the layer, an array containing the inputs, and the dimensions of the array. The following code shows you how to send the numbers `0` and `1` to the input layer:

```
tfInterface.feed("my_input/X",
            floatArrayOf(0f, 1f), 1, 2)
```

After loading data into the input layer, we must run an inference operation using the `run()` method, which expects the name of the output layer. Once the operation is complete, the output layer will contain the prediction of the model. To load the prediction into a Kotlin array, we can use the `fetch()` method. The following code shows you how to do so:

```
tfInterface.run(arrayOf("my_output/Sigmoid"))
 
val output = floatArrayOf(-1f)
tfInterface.fetch("my_output/Sigmoid", output)
```

You can run the app now to see that the model's prediction is correct.

![Logcat window displaying the prediction](https://cms-assets.tutsplus.com/uploads/users/362/posts/30957/image/Screenshot%20from%202018-04-12%2007-20-12.png)

Feel free to change the numbers you feed to the input layer to confirm that the model's predictions are always correct.

## Conclusion

You now know how to create a simple TensorFlow model and use it with TensorFlow Mobile in Android apps. You don't always have to limit yourself to your own models, though. With the skills you learned today, you should have no problems using larger models, such as MobileNet and Inception, available in the TensorFlow [model zoo](https://github.com/tensorflow/models "Link: https://github.com/tensorflow/models"). Note, however, that such models will lead to larger APKs, which may create issues for users with low-end devices.

To learn more about TensorFlow Mobile, do refer to the [official documentation](https://www.tensorflow.org/mobile/mobile_intro "Link: https://www.tensorflow.org/mobile/mobile_intro").


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
