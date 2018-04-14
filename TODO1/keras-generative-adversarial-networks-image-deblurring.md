> * 原文地址：[GAN with Keras: Application to Image Deblurring](https://blog.sicara.com/keras-generative-adversarial-networks-image-deblurring-45e3ab6977b5)
> * 原文作者：[Raphaël Meudec](https://blog.sicara.com/@raphaelmeudec?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/keras-generative-adversarial-networks-image-deblurring.md](https://github.com/xitu/gold-miner/blob/master/TODO1/keras-generative-adversarial-networks-image-deblurring.md)
> * 译者：
> * 校对者：

# GAN with Keras: Application to Image Deblurring

![](https://cdn-images-1.medium.com/max/2000/1*WFQmmhJM8HMD0D5Ax4vROw.jpeg)

In 2014, Ian Goodfellow introduced the **Generative Adversarial Networks** (GAN). This article focuses on applying **GAN to Image Deblurring with** [**Keras**](https://keras.io/)**.** All the Keras code is available [here](https://github.com/RaphaelMeudec/deblur-gan).

Have a look at the original [scientific publication](https://arxiv.org/pdf/1711.07064.pdf) and its [Pytorch version](https://github.com/KupynOrest/DeblurGAN/).

* * *

### Quick Reminder on Generative Adversarial Networks

In Generative Adversarial Networks, two networks train against each other. The generator misleads the discriminator by **creating compelling fake inputs**. The discriminator **tells if an input is real or artificial**.

![](https://cdn-images-1.medium.com/max/800/1*N4oqJsGmH-KZg3Vqrm_uYw.jpeg)

GAN Training Process — [Source](https://www.kdnuggets.com/2017/01/generative-adversarial-networks-hot-topic-machine-learning.html)

There are **3 major steps** in the training:

- use the generator to **create fake inputs** based on noise
- **train the discriminator** with both real and fake inputs
- **train the whole model:** the model is built with the discriminator chained to the generator.

Note that discriminator’s weights are frozen during the third step.

The reason for chaining both networks is that there is no possible feedback on the generator’s outputs. **Our only measure is whether the discriminator accepted the generated samples.**

This is a brief reminder of GAN’s architecture. If you don’t feel at ease, you can refer to this [excellent introduction](https://towardsdatascience.com/gan-by-example-using-keras-on-tensorflow-backend-1a6d515a60d0).

* * *

### The Data

Ian Goodfellow first applied GAN models to generate MNIST data. In this tutorial, we use **generative adversarial networks for image deblurring**. Therefore, the generator’s input isn’t noise but blurred images.

The dataset is the **GOPRO dataset**. You can download a [light version](https://drive.google.com/file/d/1H0PIXvJH4c40pk7ou6nAwoxuR4Qh_Sa2/view?usp=sharing) (9GB) or the [complete version](https://drive.google.com/file/d/1SlURvdQsokgsoyTosAaELc4zRjQz9T2U/view?usp=sharing) (35GB). It contains **artificially blurred images from multiple street views**. The dataset is decomposed in subfolders by scenes.

We first distribute the images into two folders A (blurred) and B (sharp). This A&B architecture corresponds to the original [pix2pix article](https://phillipi.github.io/pix2pix/). I created a [custom script](https://github.com/RaphaelMeudec/deblur-gan/blob/master/organize_gopro_dataset.py) to perform this task in the repo, follow the README to use it!

* * *

### The Model

The training process stays the same. First, let’s take a look at the neural network architectures!

#### The Generator

The generator aims at reproducing sharp images. The network is based on [**ResNet**](https://arxiv.org/pdf/1512.03385.pdf) **blocks.** It keeps track of the evolutions applied to the original blurred image. The publication also used a [**UNet**](https://arxiv.org/pdf/1505.04597.pdf) based version, which I haven’t implemented. Both blocks should perform well for image deblurring.

![](https://cdn-images-1.medium.com/max/1000/1*OhuvC1YUdHyLbGO6rWWHhA.png)

The Architecture of the DeblurGAN generator network — [Source](https://arxiv.org/pdf/1711.07064.pdf)

The core is **9 ResNet blocks** applied to an upsampling of the original image. Let’s see the Keras implementation!

```
from keras.layers import Input, Conv2D, Activation, BatchNormalization
from keras.layers.merge import Add
from keras.layers.core import Dropout

def res_block(input, filters, kernel_size=(3,3), strides=(1,1), use_dropout=False):
    """
    Instanciate a Keras Resnet Block using sequential API.
    :param input: Input tensor
    :param filters: Number of filters to use
    :param kernel_size: Shape of the kernel for the convolution
    :param strides: Shape of the strides for the convolution
    :param use_dropout: Boolean value to determine the use of dropout
    :return: Keras Model
    """
    x = ReflectionPadding2D((1,1))(input)
    x = Conv2D(filters=filters,
               kernel_size=kernel_size,
               strides=strides,)(x)
    x = BatchNormalization()(x)
    x = Activation('relu')(x)

    if use_dropout:
        x = Dropout(0.5)(x)

    x = ReflectionPadding2D((1,1))(x)
    x = Conv2D(filters=filters,
                kernel_size=kernel_size,
                strides=strides,)(x)
    x = BatchNormalization()(x)

    # Two convolution layers followed by a direct connection between input and output
    merged = Add()([input, x])
    return merged
```

This ResNet layer is basically a convolutional layer, with input and output added to form the final output.

```
from keras.layers import Input, Activation, Add
from keras.layers.advanced_activations import LeakyReLU
from keras.layers.convolutional import Conv2D, Conv2DTranspose
from keras.layers.core import Lambda
from keras.layers.normalization import BatchNormalization
from keras.models import Model

from layer_utils import ReflectionPadding2D, res_block

ngf = 64
input_nc = 3
output_nc = 3
input_shape_generator = (256, 256, input_nc)
n_blocks_gen = 9


def generator_model():
    """Build generator architecture."""
    # Current version : ResNet block
    inputs = Input(shape=image_shape)

    x = ReflectionPadding2D((3, 3))(inputs)
    x = Conv2D(filters=ngf, kernel_size=(7,7), padding='valid')(x)
    x = BatchNormalization()(x)
    x = Activation('relu')(x)

    # Increase filter number
    n_downsampling = 2
    for i in range(n_downsampling):
        mult = 2**i
        x = Conv2D(filters=ngf*mult*2, kernel_size=(3,3), strides=2, padding='same')(x)
        x = BatchNormalization()(x)
        x = Activation('relu')(x)

    # Apply 9 ResNet blocks
    mult = 2**n_downsampling
    for i in range(n_blocks_gen):
        x = res_block(x, ngf*mult, use_dropout=True)

    # Decrease filter number to 3 (RGB)
    for i in range(n_downsampling):
        mult = 2**(n_downsampling - i)
        x = Conv2DTranspose(filters=int(ngf * mult / 2), kernel_size=(3,3), strides=2, padding='same')(x)
        x = BatchNormalization()(x)
        x = Activation('relu')(x)

    x = ReflectionPadding2D((3,3))(x)
    x = Conv2D(filters=output_nc, kernel_size=(7,7), padding='valid')(x)
    x = Activation('tanh')(x)

    # Add direct connection from input to output and recenter to [-1, 1]
    outputs = Add()([x, inputs])
    outputs = Lambda(lambda z: z/2)(outputs)

    model = Model(inputs=inputs, outputs=outputs, name='Generator')
    return model
```

Keras Implementation of Generator’s Architecture

As planned, the 9 ResNet blocks are applied to an upsampled version of the input. We add a **connection from the input to the output** and divide by 2 to keep normalized outputs.

That’s it for the generator! Let’s take a look at the discriminator’s architecture.

#### The Discriminator

The objective is to determine if an input image is artificially created. Therefore, the discriminator’s architecture is convolutional and **outputs a single value**.

```
from keras.layers import Input
from keras.layers.advanced_activations import LeakyReLU
from keras.layers.convolutional import Conv2D
from keras.layers.core import Dense, Flatten
from keras.layers.normalization import BatchNormalization
from keras.models import Model

ndf = 64
output_nc = 3
input_shape_discriminator = (256, 256, output_nc)


def discriminator_model():
    """Build discriminator architecture."""
    n_layers, use_sigmoid = 3, False
    inputs = Input(shape=input_shape_discriminator)

    x = Conv2D(filters=ndf, kernel_size=(4,4), strides=2, padding='same')(inputs)
    x = LeakyReLU(0.2)(x)

    nf_mult, nf_mult_prev = 1, 1
    for n in range(n_layers):
        nf_mult_prev, nf_mult = nf_mult, min(2**n, 8)
        x = Conv2D(filters=ndf*nf_mult, kernel_size=(4,4), strides=2, padding='same')(x)
        x = BatchNormalization()(x)
        x = LeakyReLU(0.2)(x)

    nf_mult_prev, nf_mult = nf_mult, min(2**n_layers, 8)
    x = Conv2D(filters=ndf*nf_mult, kernel_size=(4,4), strides=1, padding='same')(x)
    x = BatchNormalization()(x)
    x = LeakyReLU(0.2)(x)

    x = Conv2D(filters=1, kernel_size=(4,4), strides=1, padding='same')(x)
    if use_sigmoid:
        x = Activation('sigmoid')(x)

    x = Flatten()(x)
    x = Dense(1024, activation='tanh')(x)
    x = Dense(1, activation='sigmoid')(x)

    model = Model(inputs=inputs, outputs=x, name='Discriminator')
    return model
```

Keras Implementation of Discriminator’s architecture

The last step is to build the full model. A **particularity of this GAN** is that inputs are real images and not noise. Therefore, we have a **direct feedback on the generator’s outputs.**

```
from keras.layers import Input
from keras.models import Model

def generator_containing_discriminator_multiple_outputs(generator, discriminator):
    inputs = Input(shape=image_shape)
    generated_images = generator(inputs)
    outputs = discriminator(generated_images)
    model = Model(inputs=inputs, outputs=[generated_images, outputs])
    return model
```

Let’s see how we make the most of this particularity by using two losses.

* * *

### The Training

#### Losses

We extract losses at two levels, at the end of the generator and at the end of the full model.

The first one is a **perceptual loss** computed directly on the generator’s outputs. This first loss ensures the GAN model is oriented towards a deblurring task. It compares the **outputs of the first convolutions of VGG**.

```
import keras.backend as K
from keras.applications.vgg16 import VGG16
from keras.models import Model

image_shape = (256, 256, 3)

def perceptual_loss(y_true, y_pred):
    vgg = VGG16(include_top=False, weights='imagenet', input_shape=image_shape)
    loss_model = Model(inputs=vgg.input, outputs=vgg.get_layer('block3_conv3').output)
    loss_model.trainable = False
    return K.mean(K.square(loss_model(y_true) - loss_model(y_pred)))
```

The second loss is the **Wasserstein loss** performed on the outputs of the whole model. It takes the **mean of the differences between two images**. It is known to improve convergence of generative adversarial networks.

```
import keras.backend as K

def wasserstein_loss(y_true, y_pred):
    return K.mean(y_true*y_pred)
```

#### Training Routine

The first step is to load the data and initialize all the models. We use our custom function to load the dataset, and add Adam optimizers for our models. We set the Keras trainable option to prevent the discriminator from training.

```
# Load dataset
data = load_images('./images/train', n_images)
y_train, x_train = data['B'], data['A']

# Initialize models
g = generator_model()
d = discriminator_model()
d_on_g = generator_containing_discriminator_multiple_outputs(g, d)

# Initialize optimizers
g_opt = Adam(lr=1E-4, beta_1=0.9, beta_2=0.999, epsilon=1e-08)
d_opt = Adam(lr=1E-4, beta_1=0.9, beta_2=0.999, epsilon=1e-08)
d_on_g_opt = Adam(lr=1E-4, beta_1=0.9, beta_2=0.999, epsilon=1e-08)

# Compile models
d.trainable = True
d.compile(optimizer=d_opt, loss=wasserstein_loss)
d.trainable = False
loss = [perceptual_loss, wasserstein_loss]
loss_weights = [100, 1]
d_on_g.compile(optimizer=d_on_g_opt, loss=loss, loss_weights=loss_weights)
d.trainable = True
```

Then, we start launching the epochs and divide the dataset into batches.

```
for epoch in range(epoch_num):
  print('epoch: {}/{}'.format(epoch, epoch_num))
  print('batches: {}'.format(x_train.shape[0] / batch_size))

  # Randomize images into batches
  permutated_indexes = np.random.permutation(x_train.shape[0])

  for index in range(int(x_train.shape[0] / batch_size)):
      batch_indexes = permutated_indexes[index*batch_size:(index+1)*batch_size]
      image_blur_batch = x_train[batch_indexes]
      image_full_batch = y_train[batch_indexes]
```

Finally, we successively train the discriminator and the generator, based on both losses. We generate fake inputs with the generator. We train the discriminator to distinguish fake from real inputs, and we train the whole model.

```
for epoch in range(epoch_num):
  for index in range(batches):
    # [Batch Preparation]

    # Generate fake inputs
    generated_images = g.predict(x=image_blur_batch, batch_size=batch_size)
    
    # Train multiple times discriminator on real and fake inputs
    for _ in range(critic_updates):
        d_loss_real = d.train_on_batch(image_full_batch, output_true_batch)
        d_loss_fake = d.train_on_batch(generated_images, output_false_batch)
        d_loss = 0.5 * np.add(d_loss_fake, d_loss_real)

    d.trainable = False
    # Train generator only on discriminator's decision and generated images
    d_on_g_loss = d_on_g.train_on_batch(image_blur_batch, [image_full_batch, output_true_batch])

    d.trainable = True
```

You can refer to the [Github](https://www.github.com/raphaelmeudec/deblur-gan) repo to see the full loop!

#### **Material**

I used an [AWS Instance](https://aws.amazon.com/fr/ec2/instance-types/p2/) (p2.xlarge) with the Deep Learning AMI (version 3.0). Training time was around 5 hours (for 50 epochs) on the light [GOPRO dataset](https://drive.google.com/file/d/1H0PIXvJH4c40pk7ou6nAwoxuR4Qh_Sa2/view?usp=sharing).

#### Image Deblurring Results

![](https://cdn-images-1.medium.com/max/800/1*W5KK68s2UslTQO98f1K73w.png)

From Left to Right: Original Image, Blurred Image, GAN Output.

The output above is the result of our Keras Deblur GAN. Even on heavy blur, the network is able to reduce and form a more convincing image. Car lights are sharper, tree branches are clearer.

![](https://cdn-images-1.medium.com/max/800/1*RQ4fqQb30amM_Pxso0UhnA.png)

Left: GOPRO Test Image, Right: GAN Output.

A limitation is the **induced pattern on top of the image**, which might be caused by the use of VGG as a loss.

![](https://cdn-images-1.medium.com/max/800/1*uQRVkF3-ktbTqRUuJ0wFCQ.png)

Left: GOPRO Test Image, Right: GAN Output.

I hope you enjoyed this article on Generative Adversarial Networks for Image Deblurring! Feel free to comment, follow us or [contact me](https://www.sicara.com/contact-2/?utm_source=blog&utm_campaign=keras-generative-adversarial-networks-image-deblurring-45e3ab6977b5).

If you have interest in computer vision, we did an article on [**Content-Based Image Retrieval with Keras**](https://blog.sicara.com/keras-tutorial-content-based-image-retrieval-convolutional-denoising-autoencoder-dc91450cc511). Below is the list of resources for Generative Adversarial Networks.

![](https://cdn-images-1.medium.com/max/800/1*HjooSUMv2MVXnOhqvhiuow.png)

Left: GOPRO Test Image, Right: GAN Output.

#### Resources for Generative Adversarial Networks

- [NIPS 2016: Generative Adversarial Networks](https://channel9.msdn.com/Events/Neural-Information-Processing-Systems-Conference/Neural-Information-Processing-Systems-Conference-NIPS-2016/Generative-Adversarial-Networks) by Ian Goodfellow
- [ICCV 2017: Tutorials on GAN](https://sites.google.com/view/iccv-2017-gans/schedule)

- [GAN Implementations with Keras](https://github.com/eriklindernoren/Keras-GAN) by [Eric Linder-Noren](http://www.eriklindernoren.se/)
- [A List of Generative Adversarial Networks Resources](https://deeplearning4j.org/generative-adversarial-network) by deeplearning4j
- [Really-awesome-gan](https://github.com/nightrome/really-awesome-gan) by [Holger Caesar](http://www.it-caesar.com/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
