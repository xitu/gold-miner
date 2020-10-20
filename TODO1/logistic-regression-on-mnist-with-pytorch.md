> * 原文地址：[Logistic Regression on MNIST with PyTorch](https://towardsdatascience.com/logistic-regression-on-mnist-with-pytorch-b048327f8d19)
> * 原文作者：[Asad Mahmood](https://medium.com/@asad007mahmood)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/logistic-regression-on-mnist-with-pytorch.md](https://github.com/xitu/gold-miner/blob/master/TODO1/logistic-regression-on-mnist-with-pytorch.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[fireairforce](https://github.com/fireairforce)

# 使用 PyTorch 在 MNIST 数据集上进行逻辑回归

**逻辑回归（Logistic Regression）**既可以用来描述数据，也可以用来解释数据中各个二值变量、类别变量、顺序变量、距离变量、比率变量之间的关系[1]。下图展示了**逻辑回归**与**线性回归**的区别。

![Taken from [https://www.sciencedirect.com/topics/nursing-and-health-professions/logistic-regression-analysis](https://www.sciencedirect.com/topics/nursing-and-health-professions/logistic-regression-analysis)](https://cdn-images-1.medium.com/max/2000/1*xFhICZgdr2VEZQ-C4FLUEA.jpeg)

本文将展示如何使用 PyTorch 编写逻辑回归模型。

我们将尝试在 MNIST 数据集上解决分类问题。首先，导入我们所需要的所有库：

```python
import torch
from torch.autograd import Variable
import torchvision.transforms as transforms
import torchvision.datasets as dsets
```

在创建模型前，我喜欢列一个如下的步骤表。PyTorch 官网[2]上也有这个步骤列表：

```python
# 第一步：加载数据集
# 第二步：使数据集可迭代
# 第三步：创建模型类
# 第四步：将模型类实例化
# 第五步：实例化 Loss 类
# 第六步：实例化优化器类
# 第七步：训练模型
```

下面我们将一步步完成上述的步骤。

### 加载数据集

我们使用 **torchvision.datasets** 来加载数据集。这个库中包含了几乎全部的用于机器学习的流行数据集。在[3]中可以看到完整的数据集列表。

```python
train_dataset = dsets.MNIST(root='./data', train=True, transform=transforms.ToTensor(), download=False)
test_dataset = dsets.MNIST(root='./data', train=False, transform=transforms.ToTensor())
```

### 使数据集可迭代

我们利用 DataLoader 类，使用以下代码来让我们的数据集可被迭代：

```python
train_loader = torch.utils.data.DataLoader(dataset=train_dataset, batch_size=batch_size, shuffle=True)
test_loader = torch.utils.data.DataLoader(dataset=test_dataset, batch_size=batch_size, shuffle=False)
```

### 创建模型类

现在，我们将创建一个用来定义逻辑回归模型结构的类：

```python
class LogisticRegression(torch.nn.Module):
    def __init__(self, input_dim, output_dim):
        super(LogisticRegression, self).__init__()
        self.linear = torch.nn.Linear(input_dim, output_dim)

    def forward(self, x):
        outputs = self.linear(x)
        return outputs
```

### 将模型类实例化

在将模型类实例化之前，我们先初始化如下所示的参数：

```python
batch_size = 100
n_iters = 3000
epochs = n_iters / (len(train_dataset) / batch_size)
input_dim = 784
output_dim = 10
lr_rate = 0.001
```

然后，就能初始化我们的逻辑回归模型了：

```python
model = LogisticRegression(input_dim, output_dim)
```

### 实例化 Loss 类

我们使用交叉熵损失来计算 loss：

```python
criterion = torch.nn.CrossEntropyLoss() # 计算 softmax 分布之上的交叉熵损失
```

### 实例化优化器类

优化器（optimizer）就是我们即将使用的学习算法。在本例中，我们将使用随机梯度下降（SGD）作为优化器：

```python
optimizer = torch.optim.SGD(model.parameters(), lr=lr_rate)
```

### 训练模型

这就是最后一步了。我们将用以下的代码来训练模型：

```python
iter = 0
for epoch in range(int(epochs)):
    for i, (images, labels) in enumerate(train_loader):
        images = Variable(images.view(-1, 28 * 28))
        labels = Variable(labels)

        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        iter+=1
        if iter%500==0:
            # 计算准确率
            correct = 0
            total = 0
            for images, labels in test_loader:
                images = Variable(images.view(-1, 28*28))
                outputs = model(images)
                _, predicted = torch.max(outputs.data, 1)
                total+= labels.size(0)
                # 如果用的是 GPU，则要把预测值和标签都取回 CPU，才能用 Python 来计算
                correct+= (predicted == labels).sum()
            accuracy = 100 * correct/total
            print("Iteration: {}. Loss: {}. Accuracy: {}.".format(iter, loss.item(), accuracy))
```

在训练时，这个模型只需要进行 3000 次迭代就能达到 **82%** 的准确率。你可以试着继续调整一下参数，看看还能不能把准确率再调高一点。

如果你想加深对在 PyTorch 中实现逻辑回归的理解，可以把上面的模型应用于任何分类问题。比如，你可以训练一个逻辑回归模型来对你最喜爱的**漫威英雄**的图像做个分类（有一半已经化灰了，所以做分类应该不是很难）:)

### 引用

[1] [https://www.statisticssolutions.com/what-is-logistic-regression/](https://www.statisticssolutions.com/what-is-logistic-regression/)

[2] [https://pytorch.org/tutorials/beginner/blitz/neural_networks_tutorial.html#sphx-glr-beginner-blitz-neural-networks-tutorial-py](https://pytorch.org/tutorials/beginner/blitz/neural_networks_tutorial.html#sphx-glr-beginner-blitz-neural-networks-tutorial-py)

[3] [https://pytorch.org/docs/stable/torchvision/datasets.html](https://pytorch.org/docs/stable/torchvision/datasets.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
