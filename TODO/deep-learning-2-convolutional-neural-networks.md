
> * 原文地址：[Deep Learning 2: Convolutional Neural Networks](https://medium.com/towards-data-science/deep-learning-2-f81ebe632d5c)
> * 原文作者：[Rutger Ruizendaal](https://medium.com/@r.ruizendaal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-2-convolutional-neural-networks.md](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-2-convolutional-neural-networks.md)
> * 译者：
> * 校对者：

# Deep Learning 2: Convolutional Neural Networks

## How and what do CNNs learn?

*This post is part of a series on deep learning. Check-out part 1 *[*here*](https://medium.com/towards-data-science/deep-learning-1-1a7e7d9e3c07)* and part 3 *[*here*](https://medium.com/@r.ruizendaal/deep-learning-3-more-on-cnns-handling-overfitting-2bd5d99abe5d)*.*

![](https://cdn-images-1.medium.com/max/1600/1*z7hd8FZeI_eodazwIapvAw.png)

This week we will explore the inner workings of a Convolutional Neural Network (CNN). You might be wondering what happens inside these networks? And how do they learn?

The teaching philosophy behind the course I’m following is based on a top-down approach. Basically, we immediately get to play with the full models and as we go along we learn more and more about its inner workings. Therefore, these blog posts will gradually dive deeper into the inner workings of neural networks. This is only week 2 so we are starting to make steps towards that goal.

Last week I trained the Vgg16 model on a dataset of cat and dog images. I want to first start by addressing why using a pre-trained model is a good approach. In order to do this it is important to think about what these models are learning. In essence a CNN is learning filters and applying them to the images. These are not the same filters you apply to your Instagram selfies but the concept is not that different. The CNN takes a small square and starts applying it over the image, this square is often referred to as a ‘window’. The network than looks for parts of the image where this filter matches the contents of the image. In the first layer the network might learn simple things like diagonal lines. In each layer the network is able to combine these findings and continually learn more complex concepts. This all still sounds pretty vague, so let’s look at some examples. [Zeiler and Fergus (2013)](https://arxiv.org/abs/1311.2901) did a great job of visualizing what a CNN learns. This is the CNN they used in their paper. The Vgg16 model that won the Imagenet competition is based on this model.

![](https://cdn-images-1.medium.com/max/1600/1*vKyUGyRnJnZ3XOVVlvp80g.png)

CNN by Zeiler & Fergus (2013)
This image might look very confusing to you right now, don’t panic! Let’s start with some things that we can all see from this picture. First, the input images are square and 224x224 pixels. The filters that I talked about earlier are 7x7 pixels. The model has an input layer, 7 hidden layers and an output layer. C in the output layer refers to the number of classes the model will predict for. Now let’s go to the most interesting stuff: What the model learns in different layers!

![](https://cdn-images-1.medium.com/max/1600/1*k57FsdDndnfb4FendDdnAw.png)

Layer 2 of the CNN. The left image represents what the CNN has learned and the right image has parts of actual images.
In layer 2 of the CNN the model is already picking up more interesting shapes than just diagonal lines. In the sixth square (counting horizontally) you can see that the model is picking up circular shapes. Also, the last square is looking at corners.

![](https://cdn-images-1.medium.com/max/1600/1*7J5H2D0WSRBnEvI-BXfONg.png)

Layer 3 of the CNN
In layer 3 we can see that the model is starting to learn more specific things. The first square shows that the model is now able to recognize geographical patterns. The sixth square is recognizing car tires. And the eleventh square is recognizing people.

![](https://cdn-images-1.medium.com/max/2000/1*QKxqFAp83WDU94N0a7AIpg.png)

Layers 4 and 5 of the CNN

Finally, layers 4 and 5 continue this trend. Layer 5 is picking up tings that are very useful for our dogs and cats problem. It is also recognizing unicycles and bird/reptile eyes. Be aware that these images only show a very small fraction of things learned by each layer.

Hopefully this shows you why using pre-trained models is useful. You can look up ‘transfer learning’ if you want to learn more about this research area. The Vgg16 model already knows a lot about recognizing dogs and cats. The training set for our cats and dogs problem has only 25.000 images. A new model might not be able to learn all these features from those images. Through a process called finetuning we can change the last layer of the Vgg16 model so that it does not output probabilities for a 1000 classes but only for 2, cats and dogs.

If you are interested in reading more about the math behind deep learning, [Stanford’s CNN pages](http://cs231n.github.io/) provide a great resource. They also refer to shallow Neural Networks as “mathematically cute”, that’s a first.

---

#### Finetuning and Linear Layers

The pre-trained Vgg16 model that I used last week to classify cats and dogs does not naturally output these two categories. It actually puts out 1000 classes. Additionally, the model does not even output the classes ‘cats and dogs’ but it outputs specific breeds of cats and dogs. So how can we change this model efficiently to only classify the images as cats or dogs?

One option would be to manually map these breeds to cats and dogs and sum the probabilities. However, this method ignores some critical information. For example, if there is a bone in the picture that image is probably of a dog. But if we only look at the probabilities per breed this information would be lost. There we replace the linear (dense) layer at the end of the model and replace it with one that only outputs 2 classes. The Vgg16 model actually has 3 linear layers at the end. We can finetune all these layers and train them through backpropagation. Backpropagation is often seen as some kind of abstract magic, but it simply is calculating gradients using the chain rule. You’ll never have to worry about the details of the math. TensorFlow, Theano and other deep learning libraries will do that for you.

If you are going through the notebook for lesson 2 of the Fast AI course be aware of memory issues. I recommend that you first run the notebook using only the sample images. If you are using a p2 instance you can otherwise run out of memory if you keep saving and loading the numpy arrays.

---

#### Activation Functions

We just discussed the linear layer at the end of the network. However, all layers in a Neural Network are not linear. After calculating the values for each of the neurons in the Neural Network we put these values through an activation function. An Artificial Neural Network basically consists of matrix multiplications. If we would only use linear calculations we could just stack these on top of each other. That would not be a very deep network … Therefore, we often use non-linear activation functions at each layer in the network. By stacking layers of linear and non-linear functions on top each other we can theoretically model anything. These are the three most popular non-linear activation functions:

- Sigmoid *(parses a value to be between 0 and 1)*
- TanH *(parses a value to be between -1 and 1)*
- ReLu *(If the value is negative it becomes 0, otherwise it stays the same)*

![](https://cdn-images-1.medium.com/max/1600/1*feheZP3rz5va0QVpi9DVNg.png)

Three most used activation functions: Sigmoid, Tanh & Rectified Linear Unit (ReLu)
Currently, the ReLu is by far the most used non-linear activation function. The main reasons for this are that it reduces the likelihood of a vanishing gradient and sparsity. We will discuss these reasons in more detail later. The last layer of the model generally uses a different activation function, because we want this layer to have a certain output. The softmax function is very popular when doing classification.

After finetuning the last layers in the Vgg16 model the model has 138.357.544 parameters. Thankfully we do not have the calculate all the gradients by hand :). Next week I will dive further into the workings of a CNN and we will discuss underfitting and overfitting.

If you liked this posts be sure to recommend it so others can see it. You can also follow this profile to keep up with my process in the Fast AI course. See you there!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
