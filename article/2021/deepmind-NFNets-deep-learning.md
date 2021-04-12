> * 原文地址：[Google DeepMind’s NFNets Offers Deep Learning Efficiency](https://www.infoq.com/news/2021/03/deepmind-NFNets-deep-learning/)
> * 原文作者：[Bruno-Santos](https://www.infoq.com/profile/Bruno-Santos/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/deepmind-NFNets-deep-learning.md](https://github.com/xitu/gold-miner/blob/master/article/2021/deepmind-NFNets-deep-learning.md)
> * 译者：[chzh9311](https://github.com/chzh9311)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[Shentaowang](https://github.com/shentaowang)

# 谷歌 DeepMind 发布 NFNet：高效的深度网络

谷歌旗下的 AI 公司 DeepMind 最近发布了 NFNet，一个不需要标准化的 ResNet 图像分类模型。相比于当前表现最佳的 [EfficientNet](https://ai.googleblog.com/2019/05/efficientnet-improving-accuracy-and.html)，这一模型的[训练速度快了 8.7 倍](https://arxiv.org/abs/2102.06171)。

据谷歌 DeepMind 的研究员所说（参考下面的图表）：

> NFNet-F1 模型达到了和 EfficientNet-B7 相近的精度，但训练速度却比后者快了 8.7 倍。而且我们最大的模型在不利用额外数据的情况下 top-1 精度达到了 86.5%，树立了新的前沿标准。

![](https://res.infoq.com/news/2021/03/deepmind-NFNets-deep-learning/en/resources/11figure-1-1616684541530.jpg)

对于大规模的图像识别任务，通常神经网络会使用一种叫[批标准化（batch normalization）](http://cs231n.stanford.edu/slides/2018/cs231n_2018_lecture07.pdf)的技术来让模型训练更高效。此外，这种技术也让神经网络泛化性能更好，换言之，它正则化的作用。

然而，批标准化存在一些缺点，比如训练和预测的时候表现不相符。而且由于[反向传播](https://www.wikiwand.com/en/Backpropagation)（backpropagation，神经网络的学习过程）的需要而在每一层网络存储一些特定的参数，这一操作也提高了计算成本。

DeepMind 提出了 NFNet 以将标准化从等式中移除并提高训练表现。此外，该公司还提出了一项技术叫做

[自适应梯度裁剪（adaptive gradient clipping）](https://arxiv.org/pdf/2102.06171.pdf)

这项技术可以对类似 ResNet 的神经网络使用更大的 batch size 进行训练，从而使网络的训练更加高效。在和 EfficientNet 保持相同精度的前提下，每单位计算资源（使用 GPU 的数量）下该方法能比前者减少 20-40% 的训练时间。

![**来源：**[不需要标准化的高性能的大规模图像识别](https://arxiv.org/abs/2102.06171) **图4. ImageNet 验证精度 vs. 测试用的 GFLOP.** 所有数字都对应单个模型和单个片段。即便是为了训练而被优化过，我们的 NFNet 模型在给定的 FLOP 预算前提下依然与大体量 EfficientNet 变体有一战之力。](https://res.infoq.com/news/2021/03/deepmind-NFNets-deep-learning/en/resources/6figure-2-1616684540852.jpg)

[源代码](https://github.com/deepmind/deepmind-research/tree/master/nfnets)已在谷歌 DeepMind 的 GitHub 仓库发布，基于名为 [JAX](https://github.com/google/jax) 的新框架实现。如果想在 NFNet 上执行一步前向操作，只需要运行下面[这段代码](https://colab.research.google.com/github/deepmind/deepmind-research/blob/master/nfnets/nfnet_demo_colab.ipynb#scrollTo=qeotZfkBYrIg)：

```py
def forward(inputs, is_training):
    model = nfnet.NFNet(num_classes=1000,  variant=variant)
    return model(inputs, is_training=is_training)['logits']
net = hk.without_apply_rng(hk.transform(forward))
fwd = jax.jit(lambda inputs: net.apply(params, inputs, is_training=False))
# 我们将它分成两个 cell 以便我们不用重复地对 fwd fn 进行 jit 操作。
logits = fwd(x[None]) # 给 X 一个新的维度来让它的 batch size 变成 1。
which_class = imagenet_classlist[int(logits.argmax())]
print(f'ImageNet class: {which_class}.')
```

NFNet 也有一个 [Pytorch 实现版本](https://github.com/vballoli/nfnets-pytorch)，这表明社区已经接纳了这个发行版：

```py
import torch
from torch import nn, optim
from torchvision.models import resnet18

from nfnets import WSConv2d
from nfnets.agc import AGC # 需要测试

conv = nn.Conv2d(3,6,3)
w_conv = WSConv2d(3,6,3)

optim = optim.SGD(conv.parameters(), 1e-3)
optim_agc = AGC(conv.parameters(), optim) # 需要测试

# 应用 AGC 时，忽略模型的 fc。
model = resnet18()
optim = torch.optim.SGD(model.parameters(), 1e-3)
optim = AGC(model.parameters(), optim, model=model, ignore_agc=['fc'])
```

最后，[YouTube 上一个关于 NFNet 的视频](https://www.youtube.com/watch?v=rNkHjZtH0RQ)已经收获了超过 30,000 的播放量。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
