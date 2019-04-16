> * 原文地址：[How to Configure Image Data Augmentation When Training Deep Learning Neural Networks](https://machinelearningmastery.com/how-to-configure-image-data-augmentation-when-training-deep-learning-neural-networks/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/author/jasonb/ "Posts by Jason Brownlee") 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-configure-image-data-augmentation-when-training-deep-learning-neural-networks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-configure-image-data-augmentation-when-training-deep-learning-neural-networks.md)
> * 译者：
> * 校对者：         

# How to Configure Image Data Augmentation When Training Deep Learning Neural Networks

Image data augmentation is a technique that can be used to artificially expand the size of a training dataset by creating modified versions of images in the dataset.

Training deep learning neural network models on more data can result in more skillful models, and the augmentation techniques can create variations of the images that can improve the ability of the fit models to generalize what they have learned to new images.

The Keras deep learning neural network library provides the capability to fit models using image data augmentation via the _ImageDataGenerator_ class.

In this tutorial, you will discover how to use image data augmentation when training deep learning neural networks.

After completing this tutorial, you will know:

*   Image data augmentation is used to expand the training dataset in order to improve the performance and ability of the model to generalize.
*   Image data augmentation is supported in the Keras deep learning library via the _ImageDataGenerator_ class.
*   How to use shift, flip, brightness, and zoom image data augmentation.

Let’s get started.

## Tutorial Overview

This tutorial is divided into eight parts; they are:

1.  Image Data Augmentation
2.  Sample Image
3.  Image Augmentation With ImageDataGenerator
4.  Horizontal and Vertical Shift Augmentation
5.  Horizontal and Vertical Flip Augmentation
6.  Random Rotation Augmentation
7.  Random Brightness Augmentation
8.  Random Zoom Augmentation

## Image Data Augmentation

The performance of deep learning neural networks often improves with the amount of data available.

Data augmentation is a technique to artificially create new training data from existing training data. This is done by applying domain-specific techniques to examples from the training data that create new and different training examples.

Image data augmentation is perhaps the most well-known type of data augmentation and involves creating transformed versions of images in the training dataset that belong to the same class as the original image.

Transforms include a range of operations from the field of image manipulation, such as shifts, flips, zooms, and much more.

The intent is to expand the training dataset with new, plausible examples. This means, variations of the training set images that are likely to be seen by the model. For example, a horizontal flip of a picture of a cat may make sense, because the photo could have been taken from the left or right. A vertical flip of the photo of a cat does not make sense and would probably not be appropriate given that the model is very unlikely to see a photo of an upside down cat.

As such, it is clear that the choice of the specific data augmentation techniques used for a training dataset must be chosen carefully and within the context of the training dataset and knowledge of the problem domain. In addition, it can be useful to experiment with data augmentation methods in isolation and in concert to see if they result in a measurable improvement to model performance, perhaps with a small prototype dataset, model, and training run.

Modern deep learning algorithms, such as the convolutional neural network, or CNN, can learn features that are invariant to their location in the image. Nevertheless, augmentation can further aid in this transform invariant approach to learning and can aid the model in learning features that are also invariant to transforms such as left-to-right to top-to-bottom ordering, light levels in photographs, and more.

Image data augmentation is typically only applied to the training dataset, and not to the validation or test dataset. This is different from data preparation such as image resizing and pixel scaling; they must be performed consistently across all datasets that interact with the model.

### Want Results with Deep Learning for Computer Vision?

Take my free 7-day email crash course now (with sample code).

Click to sign-up and also get a free PDF Ebook version of the course.

[Download Your FREE Mini-Course](https://machinelearningmastery.lpages.co/leadbox/1458ca1e0972a2%3A164f8be4f346dc/4715926590455808/)

## Sample Image

We need a sample image to demonstrate standard data augmentation techniques.

In this tutorial, we will use a photograph of a bird titled “[Feathered Friend](https://www.flickr.com/photos/thenovys/3854468621/)” by AndYaDontStop, released under a permissive license.

Download the image and save it in your current working directory with the filename ‘_bird.jpg_‘.

![Feathered Friend, taken by AndYaDontStop.](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/bird.jpg)

Feathered Friend, taken by AndYaDontStop.  
Some rights reserved.

*   [Download photograph (bird.jpg)](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/bird.jpg)

## Image Augmentation With ImageDataGenerator

The Keras deep learning library provides the ability to use data augmentation automatically when training a model.

This is achieved by using the [ImageDataGenerator class](https://keras.io/preprocessing/image/).

First, the class may be instantiated and the configuration for the types of data augmentation are specified by arguments to the class constructor.

A range of techniques are supported, as well as pixel scaling methods. We will focus on five main types of data augmentation techniques for image data; specifically:

*   Image shifts via the _`width_shift_range`_ and _`height_shift_range`_ arguments.
*   Image flips via the _horizontal_flip_ and _vertical_flip_ arguments.
*   Image rotations via the _rotation_range_ argument
*   Image brightness via the _brightness_range_ argument.
*   Image zoom via the _zoom_range_ argument.

For example, an instance of the ImageDataGenerator class can be constructed.

```
# create data generator
datagen = ImageDataGenerator()
```

Once constructed, an iterator can be created for an image dataset.

The iterator will return one batch of augmented images for each iteration.

An iterator can be created from an image dataset loaded in memory via the _flow()_ function; for example:

```
# load image dataset
X, y = ...
# create iterator
it = dataset.flow(X, y)
```

Alternately, an iterator can be created for an image dataset located on disk in a specified directory, where images in that directory are organized into subdirectories according to their class.

```
...
# create iterator
it = dataset.flow_from_directory(X, y, ...)
```

Once the iterator is created, it can be used to train a neural network model by calling the _fit_generator()_ function.

The _`steps_per_epoch`_ argument must specify the number of batches of samples comprising one epoch. For example, if your original dataset has 10,000 images and your batch size is 32, then a reasonable value for _`steps_per_epoch`_ when fitting a model on the augmented data might be _ceil(10,000/32)_, or 313 batches.

```
# define model
model = ...
# fit model on the augmented dataset
model.fit_generator(it, steps_per_epoch=313, ...)
```

The images in the dataset are not used directly. Instead, only augmented images are provided to the model. Because the augmentations are performed randomly, this allows both modified images and close facsimiles of the original images (e.g. almost no augmentation) to be generated and used during training.

A data generator can also be used to specify the validation dataset and the test dataset. Often, a separate _ImageDataGenerator_ instance is used that may have the same pixel scaling configuration (not covered in this tutorial) as the _ImageDataGenerator_ instance used for the training dataset, but would not use data augmentation. This is because data augmentation is only used as a technique for artificially extending the training dataset in order to improve model performance on an unaugmented dataset.

Now that we are familiar with how to use the _ImageDataGenerator_, let’s look at some specific data augmentation techniques for image data.

We will demonstrate each technique standalone by reviewing examples of images after they have been augmented. This is a good practice and is recommended when configuring your data augmentation. It is also common to use a range of augmentation techniques at the same time when training. We have isolated the techniques to one per section for demonstration purposes only.

## Horizontal and Vertical Shift Augmentation

A shift to an image means moving all pixels of the image in one direction, such as horizontally or vertically, while keeping the image dimensions the same.

This means that some of the pixels will be clipped off the image and there will be a region of the image where new pixel values will have to be specified.

The _`width_shift_range`_ and _`height_shift_range`_ arguments to the _ImageDataGenerator_ constructor control the amount of horizontal and vertical shift respectively.

These arguments can specify a floating point value that indicates the percentage (between 0 and 1) of the width or height of the image to shift. Alternately, a number of pixels can be specified to shift the image.

Specifically, a value in the range between no shift and the percentage or pixel value will be sampled for each image and the shift performed, e.g. [0, value]. Alternately, you can specify a tuple or array of the min and max range from which the shift will be sampled; for example: [-100, 100] or [-0.5, 0.5].

The example below demonstrates a horizontal shift with the _`width_shift_range`_ argument between [-200,200] pixels and generates a plot of generated images to demonstrate the effect.

```
# example of horizontal shift image augmentation
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# load the image
img = load_img('bird.jpg')
# convert to numpy array
data = img_to_array(img)
# expand dimension to one sample
samples = expand_dims(data, 0)
# create image data augmentation generator
datagen = ImageDataGenerator(width_shift_range=[-200,200])
# prepare iterator
it = datagen.flow(samples, batch_size=1)
# generate samples and plot
for i in range(9):
	# define subplot
	pyplot.subplot(330 + 1 + i)
	# generate batch of images
	batch = it.next()
	# convert to unsigned integers for viewing
	image = batch[0].astype('uint32')
	# plot raw pixel data
	pyplot.imshow(image)
# show the figure
pyplot.show()
```

Running the example creates the instance of _ImageDataGenerator_ configured for image augmentation, then creates the iterator. The iterator is then called nine times in a loop and each augmented image is plotted.

We can see in the plot of the result that a range of different randomly selected positive and negative horizontal shifts was performed and the pixel values at the edge of the image are duplicated to fill in the empty part of the image created by the shift.

![Plot of Augmented Generated With a Random Horizontal Shift](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Horizontal-Shift.png)

Plot of Augmented Generated With a Random Horizontal Shift

Below is the same example updated to perform vertical shifts of the image via the _`height_shift_range`_ argument, in this case specifying the percentage of the image to shift as 0.5 the height of the image.

```
# example of vertical shift image augmentation
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# load the image
img = load_img('bird.jpg')
# convert to numpy array
data = img_to_array(img)
# expand dimension to one sample
samples = expand_dims(data, 0)
# create image data augmentation generator
datagen = ImageDataGenerator(height_shift_range=0.5)
# prepare iterator
it = datagen.flow(samples, batch_size=1)
# generate samples and plot
for i in range(9):
	# define subplot
	pyplot.subplot(330 + 1 + i)
	# generate batch of images
	batch = it.next()
	# convert to unsigned integers for viewing
	image = batch[0].astype('uint32')
	# plot raw pixel data
	pyplot.imshow(image)
# show the figure
pyplot.show()
```

Running the example creates a plot of images augmented with random positive and negative vertical shifts.

We can see that both horizontal and vertical positive and negative shifts probably make sense for the chosen photograph, but in some cases, the replicated pixels at the edge of the image may not make sense to a model.

Note that other fill modes can be specified via “_fill_mode_” argument.

![Plot of Augmented Images With a Random Vertical Shift](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Vertical-Shift.png)

Plot of Augmented Images With a Random Vertical Shift

## Horizontal and Vertical Flip Augmentation

An image flip means reversing the rows or columns of pixels in the case of a vertical or horizontal flip respectively.

The flip augmentation is specified by a boolean _horizontal_flip_ or _vertical_flip_ argument to the _ImageDataGenerator_ class constructor. For photographs like the bird photograph used in this tutorial, horizontal flips may make sense, but vertical flips would not.

For other types of images, such as aerial photographs, cosmology photographs, and microscopic photographs, perhaps vertical flips make sense.

The example below demonstrates augmenting the chosen photograph with horizontal flips via the _horizontal_flip_ argument.

```
# example of horizontal flip image augmentation
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# load the image
img = load_img('bird.jpg')
# convert to numpy array
data = img_to_array(img)
# expand dimension to one sample
samples = expand_dims(data, 0)
# create image data augmentation generator
datagen = ImageDataGenerator(horizontal_flip=True)
# prepare iterator
it = datagen.flow(samples, batch_size=1)
# generate samples and plot
for i in range(9):
	# define subplot
	pyplot.subplot(330 + 1 + i)
	# generate batch of images
	batch = it.next()
	# convert to unsigned integers for viewing
	image = batch[0].astype('uint32')
	# plot raw pixel data
	pyplot.imshow(image)
# show the figure
pyplot.show()
```

Running the example creates a plot of nine augmented images.

We can see that the horizontal flip is applied randomly to some images and not others.

![Plot of Augmented Images With a Random Horizontal Flip](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Horizontal-Flip.png)

Plot of Augmented Images With a Random Horizontal Flip

## Random Rotation Augmentation

A rotation augmentation randomly rotates the image clockwise by a given number of degrees from 0 to 360.

The rotation will likely rotate pixels out of the image frame and leave areas of the frame with no pixel data that must be filled in.

The example below demonstrates random rotations via the _rotation_range_ argument, with rotations to the image between 0 and 90 degrees.

```
# example of random rotation image augmentation
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# load the image
img = load_img('bird.jpg')
# convert to numpy array
data = img_to_array(img)
# expand dimension to one sample
samples = expand_dims(data, 0)
# create image data augmentation generator
datagen = ImageDataGenerator(rotation_range=90)
# prepare iterator
it = datagen.flow(samples, batch_size=1)
# generate samples and plot
for i in range(9):
	# define subplot
	pyplot.subplot(330 + 1 + i)
	# generate batch of images
	batch = it.next()
	# convert to unsigned integers for viewing
	image = batch[0].astype('uint32')
	# plot raw pixel data
	pyplot.imshow(image)
# show the figure
pyplot.show()
```

Running the example generates examples of the rotated image, showing in some cases pixels rotated out of the frame and the nearest-neighbor fill.

![Plot of Images Generated With a Random Rotation Augmentation](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Images-Generated-with-a-Rotation-Augmentation.png)

Plot of Images Generated With a Random Rotation Augmentation

## Random Brightness Augmentation

The brightness of the image can be augmented by either randomly darkening images, brightening images, or both.

The intent is to allow a model to generalize across images trained on different lighting levels.

This can be achieved by specifying the _brightness_range_ argument to the _ImageDataGenerator()_ constructor that specifies min and max range as a float representing a percentage for selecting a brightening amount.

Values less than 1.0 darken the image, e.g. [0.5, 1.0], whereas values larger than 1.0 brighten the image, e.g. [1.0, 1.5], where 1.0 has no effect on brightness.

The example below demonstrates a brightness image augmentation, allowing the generator to randomly darken the image between 1.0 (no change) and 0.2 or 20%.

```
# example of brighting image augmentation
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# load the image
img = load_img('bird.jpg')
# convert to numpy array
data = img_to_array(img)
# expand dimension to one sample
samples = expand_dims(data, 0)
# create image data augmentation generator
datagen = ImageDataGenerator(brightness_range=[0.2,1.0])
# prepare iterator
it = datagen.flow(samples, batch_size=1)
# generate samples and plot
for i in range(9):
	# define subplot
	pyplot.subplot(330 + 1 + i)
	# generate batch of images
	batch = it.next()
	# convert to unsigned integers for viewing
	image = batch[0].astype('uint32')
	# plot raw pixel data
	pyplot.imshow(image)
# show the figure
pyplot.show()
```

Running the example shows the augmented images with varying amounts of darkening applied.

![Plot of Images Generated With a Random Brightness Augmentation](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Brightness-Augmentation.png)

Plot of Images Generated With a Random Brightness Augmentation

## Random Zoom Augmentation

A zoom augmentation randomly zooms the image in and either adds new pixel values around the image or interpolates pixel values respectively.

Image zooming can be configured by the _zoom_range_ argument to the _ImageDataGenerator_ constructor. You can specify the percentage of the zoom as a single float or a range as an array or tuple.

If a float is specified, then the range for the zoom will be [1-value, 1+value]. For example, if you specify 0.3, then the range will be [0.7, 1.3], or between 70% (zoom in) and 130% (zoom out).

The zoom amount is uniformly randomly sampled from the zoom region for each dimension (width, height) separately.

The zoom may not feel intuitive. Note that zoom values less than 1.0 will zoom the image in, e.g. [0.5,0.5] makes the object in the image 50% larger or closer, and values larger than 1.0 will zoom the image out by 50%, e.g. [1.5, 1.5] makes the object in the image smaller or further away. A zoom of [1.0,1.0] has no effect.

The example below demonstrates zooming the image in, e.g. making the object in the photograph larger.

```
# example of zoom image augmentation
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# load the image
img = load_img('bird.jpg')
# convert to numpy array
data = img_to_array(img)
# expand dimension to one sample
samples = expand_dims(data, 0)
# create image data augmentation generator
datagen = ImageDataGenerator(zoom_range=[0.5,1.0])
# prepare iterator
it = datagen.flow(samples, batch_size=1)
# generate samples and plot
for i in range(9):
	# define subplot
	pyplot.subplot(330 + 1 + i)
	# generate batch of images
	batch = it.next()
	# convert to unsigned integers for viewing
	image = batch[0].astype('uint32')
	# plot raw pixel data
	pyplot.imshow(image)
# show the figure
pyplot.show()
```

Running the example generates examples of the zoomed image, showing a random zoom in that is different on both the width and height dimensions that also randomly changes the aspect ratio of the object in the image.

![Plot of Images Generated With a Random Zoom Augmentation](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Zoom-Augmentation.png)

Plot of Images Generated With a Random Zoom Augmentation

## Further Reading

This section provides more resources on the topic if you are looking to go deeper.

### Posts

*   [Image Augmentation for Deep Learning With Keras](https://machinelearningmastery.com/image-augmentation-deep-learning-keras/)

### API

*   [Image Preprocessing Keras API](https://keras.io/preprocessing/image/)
*   [Keras Image Preprocessing Code](https://github.com/keras-team/keras-preprocessing/blob/master/keras_preprocessing/image/affine_transformations.py)
*   [Sequential Model API](https://keras.io/models/sequential/)

### Articles

*   [Building powerful image classification models using very little data, Keras Blog](https://blog.keras.io/building-powerful-image-classification-models-using-very-little-data.html).

## Summary

In this tutorial, you discovered how to use image data augmentation when training deep learning neural networks.

Specifically, you learned:

*   Image data augmentation is used to expand the training dataset in order to improve the performance and ability of the model to generalize.
*   Image data augmentation is supported in the Keras deep learning library via the ImageDataGenerator class.
*   How to use shift, flip, brightness, and zoom image data augmentation.

Do you have any questions?  
Ask your questions in the comments below and I will do my best to answer.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。 
