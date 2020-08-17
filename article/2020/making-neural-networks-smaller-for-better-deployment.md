> * 原文地址：[Making Neural Networks Smaller for Better Deployment](https://medium.com/data-from-the-trenches/making-neural-networks-smaller-for-better-deployment-55aa9bf4b795)
> * 原文作者：[Vincent Houdebine](https://medium.com/@vhoudebine)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/making-neural-networks-smaller-for-better-deployment.md](https://github.com/xitu/gold-miner/blob/master/article/2020/making-neural-networks-smaller-for-better-deployment.md)
> * 译者：
> * 校对者：

# Making Neural Networks Smaller for Better Deployment

![Credit [JC Gellidon](https://unsplash.com/@jcgellidon?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/2000/1*tGuAv2o2UGUDsC1RDtLPFA.jpeg)

There is a clear trend in the data science and machine learning industry on training bigger and bigger models. These models achieve near-human performance, but they are usually too big to be deployed on a device with constrained resources like a mobile phone or a drone. This is one of the main blockers to the broader adoption of AI in our everyday lives.

**How can I fit my 98Mb ResNet model in a 15Mb mobile app?**

On Android, the average app size is 15Mb, whereas NASNet, a state of the art image classification model released by Google, achieves over 80% accuracy on ImageNet — a famous image classification competition — but has a 355Mb size in its large version and 21.4Mb in its mobile-optimized version.

If you’re a data scientist trying to fit high-performing models into devices with constrained resources, this article will give you practical tips on how you can compress your model size by up to 70% with Keras and NumPy only, without losing performance.

---

In the last few years, there has been a lot of interest in making models smaller for resource-efficient training and inference on such constrained devices. Two main approaches have been used:

The first and most popular method is to train neural networks that are lightweight by design. A good example of this is MobileNet by Google. MobileNet’s architecture only features 4.2 million parameters while achieving a 70% accuracy on ImageNet. This compression maintains reasonable performance and is achieved by the introduction of depth-wise convolution layers which help reduce model size and complexity.

The other type of approach is to leverage large, pre-trained neural networks and compress them to reduce their size while minimizing loss in performance. This article will focus on reviewing and implementing some of these compression techniques on convolutional neural networks (CNNs).

In particular, we will focus on pruning techniques, the low hanging fruit of neural network compression. Network pruning aims at removing specific weights and their respective connections in a neural network to compress its size. Although pruning is less popular than other approaches, it achieves pretty good results and is quite easy to implement, as we will see in the rest of this article.

> **“The ability to simplify means to eliminate the unnecessary so that the necessary may speak.” Hans Hoffman**

It might seem odd that removing weights from a neural network wouldn’t drastically harm its performance. Still, in 1991, Y. LeCun et al. showed in a paper called **[Optimal Brain Damage](http://yann.lecun.com/exdb/publis/pdf/lecun-90b.pdf)** that one could reduce the size of a neural network by selectively deleting weights. They found it was possible to remove half of a network’s weights and end up with a lightweight, sometimes better-performing network.

In the particular case of CNNs, instead of removing individual weights, most approaches focus on removing entire filters and their corresponding feature maps from convolutional layers. The main benefit of this method is that it doesn’t introduce any sparsity in the network’s weight matrices. This is important to take into account as most deep learning frameworks, including Keras, don’t support sparse weight layers.

Although convolution layers only account for a minority of the network’s weights — the bulk of the network is in the fully connected layers — pruning filters eventually reduces the number of weights in the dense layers.

![Pruning convolution filters from CNNs](https://cdn-images-1.medium.com/max/2252/1*nCFPvBeDBmOzwJKzemmYPA.png)

## What Is the Intuition Behind Network Pruning ?

Let’s take a step back for a second and look at the intuition behind network pruning. There are two hypotheses on neural networks that motivate pruning:

The first one is **weight redundancy**. This means that several neurons — or filters in the particular case of CNNs — will be activated by very similar input values. Consequently, most networks are actually over-parameterized and we can safely assume that deleting redundant weights won’t harm performance too much.

The second one is that **not all weights contribute equally** to the output prediction. Instinctively, we can assume that lower magnitude weights will have a lower importance to the network, Y. LeCun calls them **low saliency weights**. Indeed, all things being equal, lower magnitude weights will have a lower effect on the network’s training error.

As we can see in the figure below, a large number of the convolution filters across the network have a low L1 norm while a very small number of filters have a much larger norm.

![**Distribution of L1 norm of filters on all layers of a CNN trained on imagenette.**](https://cdn-images-1.medium.com/max/3612/1*30JNcr-p7ssE-btMwY1BQA.png)

Although using L1 norm is a simplistic heuristic to rank the importance of filters, we can assume that pruning low importance convolution filters away from the network would have a lesser impact than others.

Now that we have a better understanding of pruning and how it can help compress networks without harming their performance, let’s see how we can implement it on a Keras network.

## How to Prune a Model Trained With Keras?

In the remainder of this article, we’ll use a vanilla CNN trained on imagenette, a subset of 10,000 images from 10 ImageNet categories. After training and evaluating our full baseline network, we’ll implement and compare different pruning strategies.

#### Rank-Prune-Retrain

The algorithm we will adopt to efficiently prune our CNN is surprisingly simple: Rank — Prune — Retrain. First, we’ll need to **rank** our filters by importance in order to identify low magnitude, unimportant filters. Then, we’ll **prune** away a certain percentage of them based on their estimated importance. Finally, we’ll **retrain** the network for a few epochs using the same learning rate as for the initial training to fine-tune weights to the new pruned architecture. That’s it, it’s so simple it can fit in one Tweet.

![The NN compression algorithm by Alex Renda](https://cdn-images-1.medium.com/max/2416/0*3zblyMx9iyG9u8FQ)

1. **Rank: Identifying Filters to Prune**

There is no consensus on how to rank weights according to how much they contribute to the output performance of the network. A perfect strategy would be to prune each weight individually and compute the performance of the model without the weight. This method is called oracle pruning, but with several millions (sometimes billions) of weights in a network, it is a very expensive strategy to say the least.

Other proxies to rank weights involve computing their norm (L1 or L2) or computing the mean, standard deviation or percentage of 0 activation values over a batch of input data.

For this experiment, we’ll use both **L1 norm** and **Average Percentage of Zero (APoZ) Activations** of the convolutional filters to rank them by importance.

Since we’re going to use L1 norm to compare filters with different sizes, we’ll have to use a normalized L1 norm:

![](https://cdn-images-1.medium.com/max/2000/0*oYZbmKC0v67e5TiT)

The code below computes L1 norm of the convolutional filters in a Keras model and outputs a matrix of dimension Nb_of_layers x Nb_of_filters.

```Python
import tensorflow as tf
import keras.backend as K
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Model
from kerassurgeon import Surgeon, identify
from kerassurgeon.operations import delete_channels, delete_layer
import os
import numpy as np
import math
  
def get_filter_weights(model, layer=None):
    """function to return weights array for one or all conv layers of a Keras model"""
    if layer or layer==0:
        weight_array = model.layers[layer].get_weights()[0]
        
    else:
        weights = [model.layers[layer_ix].get_weights()[0] for layer_ix in range(len(model.layers))\
         if 'conv' in model.layers[layer_ix].name]
        weight_array = [np.array(i) for i in weights]
    
    return weight_array

def get_filters_l1(model, layer=None):
    """Returns L1 norm of a Keras model filters at a given conv layer, if layer=None, returns a matrix of norms
model is a Keras model"""
    if layer or layer==0:
        weights = get_filter_weights(model, layer)
        num_filter = len(weights[0,0,0,:])
        norms_dict = {}
        norms = []
        for i in range(num_filter):
            l1_norm = np.sum(abs(weights[:,:,:,i]))
            norms.append(l1_norm)
    else:
        weights = get_filter_weights(model)
        max_kernels = max([layr.shape[3] for layr in weights])
        norms = np.empty((len(weights), max_kernels))
        norms[:] = np.NaN
        for layer_ix in range(len(weights)):
            # compute norm of the filters
            kernel_size = weights[layer_ix][:,:,:,0].size
            nb_filters = weights[layer_ix].shape[3]
            kernels = weights[layer_ix]
            l1 = [np.sum(abs(kernels[:,:,:,i])) for i in range(nb_filters)]
            # divide by shape of the filters
            l1 = np.array(l1) / kernel_size
            norms[layer_ix, :nb_filters] = l1
    return norms
```

The second option you can try is to compute the APoZ activations. The intuition is that if a filter is rarely activated over a batch of random input images, it doesn’t contribute much to the output predictions of the model. Note that this metric makes a lot of sense if the activation functions used in the convolutional layers zero out a lot of values. This is the case for ReLU but when using other functions like Leaky ReLU, the APoZ criteria might not be as relevant.

To compute APoZ per filter, we’ll have to select a subset of the dataset, score it with our CNN, and compute each filter’s average percentage of activation values equal to 0. The filters we will prune are the ones with the biggest percentage of zero activations.

![](https://cdn-images-1.medium.com/max/2912/0*lJEZuER30NWzlfmE)

The following function does that for one convolutional layer:

```Python
def compute_apoz(model, layer_ix, nb_filters, generator):
    """Compute Average percentage of zeros over a layer’s activation maps"""
    act_layer = model.get_layer(index=layer_ix)
    node_index = 0
    temp_model = Model(model.inputs,
                       act_layer.get_output_at(node_index)
                        )


    # count the percentage of zeros per activation
    a = temp_model.predict_generator(generator,944, workers=3, verbose=1)
    activations = a.reshape(a.shape[0]*a.shape[1]*a.shape[2],nb_filters).T
    apoz_layer = np.sum(activations == 0, axis=1) / activations.shape[1]
    
    return apoz_layer
```

Generalizing that to all layers, again, we’re outputting a Nb_of_layers x Nb_of_filters matrix with an APoZ value for each individual filter in the network:

```Python
def get_filters_apoz(model, layer=None):
    """Compute Average percentage of zeros over one or all conv layers activation maps, if layer=None, returns a matrix of APoZ"""
    test_generator = ImageDataGenerator(rescale=1./255, validation_split=0.1)
    apoz_dir = "/home/ec2-user/experiments/data/imagenette2-320/train"

    apoz_generator = test_generator.flow_from_directory(
                apoz_dir,
                target_size=(160, 160),
                batch_size=1,
                class_mode='categorical',
                subset='validation',
                shuffle= False)
    
    if layer or layer ==0:
        assert 'conv' in model.layers[layer].name, "The layer provided is not a convolution layer"
        weights_array = get_filter_weights(model, layer)
        act_ix = layer + 1
        nb_filters = weights_array.shape[3]
        apoz = compute_apoz(model, act_ix, nb_filters, apoz_generator)
                
    else :
        weights_array = get_filter_weights(model)
        max_kernels = max([layr.shape[3] for layr in weights_array])

        conv_indexes = [i for i, v in enumerate(model.layers) if 'conv' in v.name]
        activations_indexes = [i for i,v in enumerate(model.layers) if 'activation' \
                       in v.name and 'conv' in model.layers[i-1].name]

        # create nd array to collect values
        apoz = np.zeros((len(weights_array), max_kernels))

        for i, act_ix in enumerate(activations_indexes):
            # score this sample with our model (trimmed to the layer of interest)
            nb_filters = weights_array[i].shape[3]
            apoz_layer = compute_apoz(model, act_ix, nb_filters, apoz_generator)
            apoz[i, :nb_filters] = apoz_layer
        
    return apoz
```

From these two matrices, we can easily identify which filters to prune. Some papers set a hard threshold and prune away all the filters that don’t make the cut, while others rank the filters and set a target percentage of filters to prune away.

In the code below, we are pruning away 10% of the filters in the network by simply computing the number of filters n_pruned corresponding to 10% of the filters and then computing coordinates of the n_pruned lowest (for L1) or biggest (for APoZ) values in the matrix:

```Python
def compute_pruned_count(model, perc=0.1, layer=None):
    if layer or layer ==0:
        # count nb of filters
        nb_filters = model.layers[layer].output_shape[3]
    else:
        nb_filters = np.sum([model.layers[i].output_shape[3] for i, layer in enumerate(model.layers) 
                                if 'conv' in model.layers[i].name])
            
    n_pruned = int(np.floor(perc*nb_filters))
    return n_pruned


def smallest_indices(array, N):
    idx = array.ravel().argsort()[:N]
    return np.stack(np.unravel_index(idx, array.shape)).T

def biggest_indices(array, N):
    idx = array.ravel().argsort()[::-1][:N]
    return np.stack(np.unravel_index(idx, array.shape)).T
```

In addition to these two methods, we also tried pruning away random filters from the network to prove that you can’t just remove random filters from the network and get away with it!

**2. Prune: Pruning Away the Filters**

Now that we have identified the convolutional filters to remove, we’ll have to put on our brain surgeon hat and delete the filters from the network. We’ll also need to be cautious and remove the corresponding output channels in the deeper layers of the network.

Thankfully, the keras-surgeon library provides very simple methods to efficiently modify trained Keras models. Building on the simplicity of Keras, keras-surgeon lets you easily delete neurons or channels from layers using a simple delete_channels_method(). The library also has an identify module that lets you compute the APoZ metrics for neurons in a specific layer. Keras-surgeon is awesome and works on virtually any Keras model (not just CNNs) — shout out to Ben Whetton for his work on this. Here’s the link to the [repo](https://github.com/BenWhetton/keras-surgeon).

Let’s implement keras-surgeon to prune away the channels identified in the previous section. We’ll also have to re-compile the model once it’s been pruned using the standard .compile() module in Keras.

```Python
from kerassurgeon.operations import delete_channels, delete_layer
from kerassurgeon import Surgeon

def prune_one_layer(model, pruned_indexes, layer_ix, opt):
    """Prunes one layer based on a Keras Model, layer index 
    and indexes of filters to prune"""
    model_pruned = delete_channels(model, model.layers[layer_ix], pruned_indexes)
    model_pruned.compile(loss='categorical_crossentropy',
                          optimizer=opt,
                          metrics=['accuracy'])
    return model_pruned

def prune_multiple_layers(model, pruned_matrix, opt):
  """Prunes several layers based on a Keras Model, layer index and matrix 
  of indexes of filters to prune"""
    conv_indexes = [i for i, v in enumerate(model.layers) if 'conv' in v.name]
    layers_to_prune = np.unique(pruned_matrix[:,0])
    surgeon = Surgeon(model, copy=True)
    to_prune = pruned_matrix
    to_prune[:,0] = np.array([conv_indexes[i] for i in to_prune[:,0]])
    layers_to_prune = np.unique(to_prune[:,0])
    for layer_ix in layers_to_prune :
        pruned_filters = [x[1] for x in to_prune if x[0]==layer_ix]
        pruned_layer = model.layers[layer_ix]
        surgeon.add_job('delete_channels', pruned_layer, channels=pruned_filters)
    
    model_pruned = surgeon.operate()
    model_pruned.compile(loss='categorical_crossentropy',
              optimizer=opt,
              metrics=['accuracy'])
    
    return model_pruned

```

We can wrap this up with a nice prune_model() function.

```Python
def prune_model(model, perc, opt, method='l1', layer=None):
    """Prune a Keras model using different methods
    Arguments:
        model: Keras Model object
        perc: a float between 0 and 1
        method: method to prune, can be one of ['l1','apoz','random']
    Returns:
        A pruned Keras Model object
    
    """
    assert method in ['l1','apoz','random'], "Invalid pruning method"
    assert perc >=0 and perc <1, "Invalid pruning percentage"
    
    
    n_pruned = compute_pruned_count(model, perc, layer)
    
    if method =='l1':
        to_prune = prune_l1(model, n_pruned, layer)    
    if method =='apoz':
        to_prune = prune_apoz(model, n_pruned, layer)
    if method =='random':
        to_prune = prune_random(model, n_pruned, layer)    
    if layer or layer ==0:
        model_pruned = prune_one_layer(model, to_prune, layer, opt)
    else:
        model_pruned = prune_multiple_layers(model, to_prune, opt)
            
    return model_pruned
```

During our experiment, we tried different pruning percentages, pruning up to 50% of the convolution filters in the network. This revealed that after a certain point, we removed too many essential filters from the network and the drop of performance was too big to be recovered by further fine tuning.

The best pruning — performance ratio was achieved by pruning away 20% of the filters using APoZ, which enabled us to reduce the number of model weights by 69%!

**3. Retrain: Retraining the Model**

Our model is now stripped of a good chunk of the allegedly unnecessary filters. Pruning the model introduced perturbations in the model and, in order to maintain the model’s performance, it is usually necessary to fine-tune the model for a few epochs. Keras makes it very easy to fine-tune a previously trained model, simply call the .fit() function again using the same optimizer (same optimizer type, same learning rate) as the initial model training.

The amount of fine-tuning to be done will depend on the proportion of filters pruned from the model and the initial model complexity. For our experiments, we chose to retrain for one epoch only on our vanilla CNN, but some papers use up to 10 epochs of retraining on more complex models.

Something interesting to note is for models pruned using L1 and APoZ, the performance actually increased compared to the baseline after pruning and retraining them. Our network, despite being 69% smaller in size, has a 77.8% accuracy, much better than our baseline, over-parameterized model, which is very cool to see.

![Evolution of model performance at increasing pruning % (in number of model weights) using L1, APoZ and random pruning of filters.](https://cdn-images-1.medium.com/max/2512/1*rTpCGds2OqwZPvUrpBMFeQ.png)

![Evolution of model performance at increasing pruning % (in model size) using L1, APoZ and random pruning of filters.](https://cdn-images-1.medium.com/max/2612/1*bva_R5vv7xKJFbrm2PJb0A.png)

This has been observed in several papers and can be interpreted as a post-training network regularization. Even if you’re not looking to compress your model, you might want to have a go at pruning as a way to improve its generalization performance.

**4. Repeat!**

This Rank — Prune — Retrain cycle can be repeated iteratively until a certain criterion is met. For example we could repeat this cycle until the difference between the pruned model’s performance and the original model’s performance is bigger than a certain threshold.

In practice, we found that a single iteration of this cycle could lead to up to a~70% compression in number of weights while maintaining or improving the performance of our baseline CNN.

## Conclusion

To conclude on these experiments, we saw that APoZ gave slightly better compression / performance results than L1. However, in practice, I’d suggest using L1 as a quick win for compression. As opposed to APoZ, L1 doesn’t require any data to identify filters to prune and is thus much less computationally intensive than APoZ.

Overall, we’ve been impressed by the compression results achieved using such a conceptually simple technique. Compared to other compression techniques like quantization, pruning is a much simpler approach to implement while producing very nice results.

It is our hope that this article convinced you to give pruning a try and that we’ll see more pruned models being deployed to production!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
