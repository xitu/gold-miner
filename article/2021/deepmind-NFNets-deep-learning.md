> * 原文地址：[Google DeepMind’s NFNets Offers Deep Learning Efficiency](https://www.infoq.com/news/2021/03/deepmind-NFNets-deep-learning/)
> * 原文作者：[Bruno-Santos](https://www.infoq.com/profile/Bruno-Santos/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/deepmind-NFNets-deep-learning.md](https://github.com/xitu/gold-miner/blob/master/article/2021/deepmind-NFNets-deep-learning)
> * 译者：
> * 校对者：

# Google DeepMind’s NFNets Offers Deep Learning Efficiency

Google’s DeepMind AI company recently released NFNets, a normalizer-free ResNet image classification model that [achieved a training performance 8.7x faster](https://arxiv.org/abs/2102.06171) than current state-of-the-art [EfficientNet](https://ai.googleblog.com/2019/05/efficientnet-improving-accuracy-and.html).

According to Google’s DeepMind researchers (checkplot below):

> NFNet-F1 model achieves similar accuracy to EfficientNet-B7 while being 8.7×faster to train, and our largest model sets a new overall state of the art without extra data of 86.5% top-1 accuracy.

![](https://res.infoq.com/news/2021/03/deepmind-NFNets-deep-learning/en/resources/11figure-1-1616684541530.jpg)

For large-scale image recognition tasks, usually neural networks use a technique called [batch normalization](http://cs231n.stanford.edu/slides/2018/cs231n_2018_lecture07.pdf) to make the model training more efficient. In addition, it helps neural networks to generalize better, i.e., it has a regularizing effect.

Although batch normalization has some disadvantages such as discrepancy behaviour between training and inference time as well as computational overhead due to the storing of certain parameters per network layer necessary for later [backpropagation](https://www.wikiwand.com/en/Backpropagation) (neural networks learning process).

DeepMind introduced NFNets to remove normalization from the equation and improve training performance. Adding to this, it introduces a technique called

[adaptive gradient clipping](https://arxiv.org/pdf/2102.06171.pdf)

that allows to train neural network models such as ResNet with a larger batch size in an efficient manner. This method reduced training time by 20-40% per computational resources (amount of GPUs used) compared with EfficientNet with the same accuracy.

![**Source:** [High-Performance Large-Scale Image Recognition Without Normalization](https://arxiv.org/abs/2102.06171)](https://res.infoq.com/news/2021/03/deepmind-NFNets-deep-learning/en/resources/6figure-2-1616684540852.jpg)

The [code](https://github.com/deepmind/deepmind-research/tree/master/nfnets) was published on Google’s DeepMind GitHub, implemented on this new framework called [JAX](https://github.com/google/jax). In order to run a forward step on NFNet, just run the following [piece of code](https://colab.research.google.com/github/deepmind/deepmind-research/blob/master/nfnets/nfnet_demo_colab.ipynb#scrollTo=qeotZfkBYrIg):

```py
def forward(inputs, is_training):
    model = nfnet.NFNet(num_classes=1000,  variant=variant)
    return model(inputs, is_training=is_training)['logits']
net = hk.without_apply_rng(hk.transform(forward))
fwd = jax.jit(lambda inputs: net.apply(params, inputs, is_training=False))
# We split this into two cells so that we don't repeatedly jit the fwd fn.
logits = fwd(x[None]) # Give X a newaxis to make it batch-size-1
which_class = imagenet_classlist[int(logits.argmax())]
print(f'ImageNet class: {which_class}.')
```

NFNets has as well an [implementation in Pytorch](https://github.com/vballoli/nfnets-pytorch), which shows community has been receptive to this release:

```py
import torch
from torch import nn, optim
from torchvision.models import resnet18

from nfnets import WSConv2d
from nfnets.agc import AGC # Needs testing

conv = nn.Conv2d(3,6,3)
w_conv = WSConv2d(3,6,3)

optim = optim.SGD(conv.parameters(), 1e-3)
optim_agc = AGC(conv.parameters(), optim) # Needs testing

# Ignore fc of a model while applying AGC.
model = resnet18()
optim = torch.optim.SGD(model.parameters(), 1e-3)
optim = AGC(model.parameters(), optim, model=model, ignore_agc=['fc'])
```

Finally, a [YouTube video about NFNets](https://www.youtube.com/watch?v=rNkHjZtH0RQ) had over 30,000 views.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
