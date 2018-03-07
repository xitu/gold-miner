> * 原文地址：[Implementation of Convolutional Neural Network using Python and Keras](https://rubikscode.net/2018/03/05/implementation-of-convolutional-neural-network-using-python-and-keras/)
> * 原文作者：[rubikscode](https://rubikscode.net)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/implementation-of-convolutional-neural-network-using-python-and-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO/implementation-of-convolutional-neural-network-using-python-and-keras.md)
> * 译者：
> * 校对者：

# Implementation of Convolutional Neural Network using Python and Keras

Have you ever wondered, how does Snapchat detect faces? How do self-driving cars know where a road is? You are right, they are using special kind of neural networks used for computer vision – Convolutional Neural Networks. In the **[previous article](https://rubikscode.net/2018/02/26/introduction-to-convolutional-neural-networks/),** we had a chance to examine how they work. We covered layers of these networks and their functionalities. Basically, additional layers of Convolutional Neural Networks preprocess image in the format that standard neural network can work with. The first step in doing so is detecting certain features or attributes on the input image. This is done by convolutional layer.

This layer use filters to detect low-level features, like edges and curves, as well as higher levels features, like a face or a hand. Than Convolutional Neural Network use additional layers to remove linearity from the image, something that could cause overfitting. When linearity is removed, additional layers for compressing the image and flattening the data are used. Finally, this information is passed into a neural network, called Fully-Connected Layer in the world of Convolutional Neural Networks. Again, the goal of this article is to show you how to implement all these concepts, so more details about these layers, how they work and what is the purpose of each of them can be found in the **[previous article](https://rubikscode.net/2018/02/26/introduction-to-convolutional-neural-networks/)**.

![](https://i.imgur.com/Tnkq3Tf.png)

Before we wander off into the problem we are solving and the code itself make sure to setup your environment. As in all previous articles from this **[series](https://rubikscode.net/2018/02/19/artificial-neural-networks-series/)**, I will be using Python 3.6. Also, I am using Anaconda and Spyder, but you can use any IDE that you preffer. However, the important thing to do is to install Tensorflow and Keras. Instructions for installing and using TensorFlow can be found [**here**](https://rubikscode.net/2018/02/05/introduction-to-tensorflow-with-python-example/), while instructions for installing and using Keras are [**here**](https://rubikscode.net/2018/02/12/implementing-simple-neural-network-using-keras-with-python-example/).

## MNIST Dataset

So, in this article, we will teach our network how to recognize digits in the image. For this, we will use another famous dataset – MNIST Dataset. Extending its predecessor **[NIST](https://www.nist.gov/sites/default/files/documents/srd/nistsd19.pdf)**, this dataset has a training set of 60,000 samples and testing set of 10,000 images of handwritten digits. All digits have been size-normalized and centered. Size of the images is also fixed, so preprocessing image data is minimized. This is why this dataset is so popular. It is considered to be a “Hello World” example in the world of Convolutional Neural Networks.

![](https://i.imgur.com/dMRUT6k.png)

###### MNIST Dataset samples

Also, using Convolutional Neural Networks we can get almost human results. Currently, the record is held by the Parallel Computing Center (Khmelnitskiy, Ukraine). They used an ensemble of only 5 convolutional neural networks and got the error rate of 0.21 percent. Pretty cool, isn’t it?

## Importing Libraries and Data

Like in previous articles in this **[series](https://rubikscode.net/2018/02/19/artificial-neural-networks-series/)**, we will first import all necessary libraries. Some of these will be familiar, but some of them we will explain a bit further.

As you can see we will be using _numpy_, the library that we already used in previous examples for operations on multi-dimensional arrays and matrices. Also, you can see that we are using some features from _Keras_ Libraries that we already used in **[this article](https://rubikscode.net/2018/02/12/implementing-simple-neural-network-using-keras-with-python-example/)**, but also a couple of new ones. _Sequential_ and _Dense_ are used for creating the model and standard layers, ie. fully-connected layer.

Also, we can see some new classes we use from _Keras_. _Conv2D_ is class that we will use to create a convolutional layer. _MaxPooling2D_ is class used for pooling layer, and _Flatten_ class is used for flattening level. We use _to_categorical_ from _Keras utils_ as well. This class is used to convert a vector (integers) to a binary class matrix, ie. it is used for [**one-hot encoding**](https://en.wikipedia.org/wiki/One-hot). Finally, notice that we will use _matplotlib_ for displaying the results.

After we imported all necessary libraries and classes, we need to take care of the data. Lucky for us, Keras provided MNIST dataset so we don’t need to download it. As mentioned, all these images are already partially preprocessed. This means that they are having same size and digits displayed on them are properly positioned. So, let’s import this dataset and prepare data for our model:

As you can see we imported MNIST dataset from the Keras _datasets_. Then we loaded data in train and test matrices. After that, we got the dimensions of images using _shape_ property and reshaped input data so it represents one channel input images. Basically, we are using just one channel of this image, not the regular three (RGB). This is done to simplify this implementation. Then we normalized the data in the input matrixes. In the end, we encoded the output matrixes using _to_categorical_.

## Model Creation

Now, when data is prepared, we can proceed to the fun stuff – the creation of the model:

We used _Sequential_ for this, of course, and started off by adding Convolutional Layers using _Conv2D_ class. As you can see there are few parameters this class is using, so let’s explore them. The first parameter is defining a number of filters that will be used, ie. number of features that will be detected. It is a common procedure to start from 32 and then go to bigger number of features from that moment on. That is exactly what we are doing, in first convolutional layer we are detecting 32 features, in second 64 and in third and final 128 features. Size of the filters that will be used is defined using next parameter – _kernel_size,_ and we have chosen 3 by 3 filters.

For the activation function, we are using rectifier function. This way we are adding non-linearity level automatically with every Convolutional layer. Another way to achieve this, and a bit more advanced, is by using _LeakyReLU_ form _keras.layers.advanced_activations_. This is not like standard rectifier function, but instead of squashing all values that are below a certain value to 0 it has a slight negative slope. If you decide to use this, beware that you have to use linear activation in _Conv2D._ Here is an example how that would look like:

We digressed for a bit. Let’s get back to _Conv2D_ and its parameters. Another very important parameter is _input_shape._ Using this parameter we are defining dimensions of our input image. As mentioned, we are only using one channel, that is why the final dimension our _input_shape_ is 1. Other dimensions we picked up from an input image.

Also, we added other layers to our model too. _Dropout_ layer is helping us with overfitting, and after that, we added pooling layer by using _MaxPooling2D_ class. This layer is apparently using the max-pool algorithm, and size of the pooling filter is 2 by 2. Pooling layer is followed by Flattening layer, which is followed by Fully-connected layer. For the final Fully-Connected layer we added the neural network with two layers, for which we used _Dense_ class. In the end, we compiled our model, and we used Adam optimizer.

If you are struggling with some of these concepts, you can check **[previous blog post](https://rubikscode.net/2018/02/26/introduction-to-convolutional-neural-networks/)** where mechanisms of Convolutional Layers are explained. Also, if you have a problem with following some _Keras_ concepts, this [**blog post**](https://rubikscode.net/2018/02/12/implementing-simple-neural-network-using-keras-with-python-example/) can help you.

## Training

Very well, our data is pre-processed and our model created. Let’s merge them together, and train our model. For this we are using, already familiar, function _fit_. We pass the input matrices and define _batch_size_ and number of _epochs._ Another thing we are doing is defining _validation_split._ This parameter is used to define which fraction of testing data is going to be used as validation data.

Basically, the model will set aside part of training data, but it will use it to evaluate the loss and other model metrics at the end of each epoch. This is not the same as testing data because we are using it after every epoch.

After that our model is trained and ready. We are using _evaluate_ method and pass testing set to it. Here we will get the accuracy of our Convolutional Neural Network.

## Predictions

One more thing we could do is to gather predictions of our network on the test dataset. This way we can compare predicted results with actual ones. For this, we will use _predict_ method. Using this method we can also make predictions on a single input.

## Results

Let’s use these predictions we just gathered for the final touch of our implementation. We are going to display predicted digit, with the actual one. And we will display the image for which we made the prediction. Basically, we will make nice visual representation for our implementation, after all, we are processing images here.

Here we used _pyplot_ to display ten images with actual result and our predictions. And this is how it looks like when we run our implementation:

![](https://i.imgur.com/q70wn55.png)

We have run twenty epochs and got the accuracy – 99.39%. Not bad at all. There is always room for improvement, of course.

## Conclusion

Convolutional Neural Networks are one very interesting sub-field and one of the most influential innovations in the field of computer vision. Here you could see how to implement one simple version of these networks and how to use it for detecting digits on MNIST dataset.

Thanks for reading!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
