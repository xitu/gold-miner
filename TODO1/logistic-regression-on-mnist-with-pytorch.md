> * 原文地址：[Logistic Regression on MNIST with PyTorch](https://towardsdatascience.com/logistic-regression-on-mnist-with-pytorch-b048327f8d19)
> * 原文作者：[Asad Mahmood](https://medium.com/@asad007mahmood)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/logistic-regression-on-mnist-with-pytorch.md](https://github.com/xitu/gold-miner/blob/master/TODO1/logistic-regression-on-mnist-with-pytorch.md)
> * 译者：
> * 校对者：

# Logistic Regression on MNIST with PyTorch

**Logistic regression** is used to describe data and to explain the relationship between **one dependent binary variable** and one or more nominal, ordinal, interval or ratio-level independent variables[1]. The figure below shows the difference between **Logistic** and **Linear** regression.

![Taken from [https://www.sciencedirect.com/topics/nursing-and-health-professions/logistic-regression-analysis](https://www.sciencedirect.com/topics/nursing-and-health-professions/logistic-regression-analysis)](https://cdn-images-1.medium.com/max/2000/1*xFhICZgdr2VEZQ-C4FLUEA.jpeg)

In this post, I’ll show how to code a Logistic Regression Model in PyTorch.

We’ll try and solve the classification problem of MNIST dataset. First, let’s import all the libraries we’ll need.

```
import torch
from torch.autograd import Variable
import torchvision.transforms as transforms
import torchvision.datasets as dsets
```

I prefer to keep the following list of steps in front of me when creating a model. This list is present on the PyTorch website [2].

```
# Step 1. Load Dataset
# Step 2. Make Dataset Iterable
# Step 3. Create Model Class
# Step 4. Instantiate Model Class
# Step 5. Instantiate Loss Class
# Step 6. Instantiate Optimizer Class
# Step 7. Train Model
```

So let’s go through these steps one by one.

### Load Dataset

To load the dataset, we make use of **torchvision.datasets,** a library which has almost all the popular datasets used in Machine Learning. You can check out the complete list of datasets at [3].

```
train_dataset = dsets.MNIST(root='./data', train=True, transform=transforms.ToTensor(), download=False)
test_dataset = dsets.MNIST(root='./data', train=False, transform=transforms.ToTensor())
```

### Make Dataset Iterable

We will use the DataLoader class to make our dataset iterable using the following lines of code.

```
train_loader = torch.utils.data.DataLoader(dataset=train_dataset, batch_size=batch_size, shuffle=True)
test_loader = torch.utils.data.DataLoader(dataset=test_dataset, batch_size=batch_size, shuffle=False)
```

### Create the Model Class

Now, we will create a class that defines the architecture of Logistic Regression.

```
class LogisticRegression(torch.nn.Module):
    def __init__(self, input_dim, output_dim):
        super(LogisticRegression, self).__init__()
        self.linear = torch.nn.Linear(input_dim, output_dim)

    def forward(self, x):
        outputs = self.linear(x)
        return outputs
```

### Instantiate the Model Class

Before instantiation, we’ll initialize some parameters like following.

```
batch_size = 100
n_iters = 3000
epochs = n_iters / (len(train_dataset) / batch_size)
input_dim = 784
output_dim = 10
lr_rate = 0.001
```

Now, we initialize our Logistic Regression Model.

```
model = LogisticRegression(input_dim, output_dim)
```

### Instantiate the Loss Class

We use the cross-entropy to compute the loss.

```
criterion = torch.nn.CrossEntropyLoss() # computes softmax and then the cross entropy
```

### Instatnitate the Optimizer Class

The optimizer will be the learning algorithm we use. In this case, we will use the Stochastic Gradient Descent.

```
optimizer = torch.optim.SGD(model.parameters(), lr=lr_rate)
```

### Train the Model

Now in the last step, we’ll train the model using the following code.

```
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
            # calculate Accuracy
            correct = 0
            total = 0
            for images, labels in test_loader:
                images = Variable(images.view(-1, 28*28))
                outputs = model(images)
                _, predicted = torch.max(outputs.data, 1)
                total+= labels.size(0)
                # for gpu, bring the predicted and labels back to cpu fro python operations to work
                correct+= (predicted == labels).sum()
            accuracy = 100 * correct/total
            print("Iteration: {}. Loss: {}. Accuracy: {}.".format(iter, loss.item(), accuracy))
```

Training, this model for just 3000 iterations gives an **accuracy of 82%**. You can go ahead and tweak the parameters a bit, to see if the accuracy increases or not.

A good exercise to get a more deep understanding of Logistic Regression models in PyTorch, would be to apply this to any classification problem you could think of. For Example, You could train a Logistic Regression Model to classify the images of your favorite **Marvel superheroes** (shouldn’t be very hard since half of them are gone :) ).

### References

[1] [https://www.statisticssolutions.com/what-is-logistic-regression/](https://www.statisticssolutions.com/what-is-logistic-regression/)

[2] [https://pytorch.org/tutorials/beginner/blitz/neural_networks_tutorial.html#sphx-glr-beginner-blitz-neural-networks-tutorial-py](https://pytorch.org/tutorials/beginner/blitz/neural_networks_tutorial.html#sphx-glr-beginner-blitz-neural-networks-tutorial-py)

[3] [https://pytorch.org/docs/stable/torchvision/datasets.html](https://pytorch.org/docs/stable/torchvision/datasets.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
