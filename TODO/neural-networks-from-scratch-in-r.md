> * 原文地址：[Neural Networks from Scratch (in R)](https://medium.com/@iliakarmanov/neural-networks-from-scratch-in-r-dcf97867c238)
> * 原文作者：[Ilia Karmanov](https://medium.com/@iliakarmanov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/neural-networks-from-scratch-in-r.md](https://github.com/xitu/gold-miner/blob/master/TODO/neural-networks-from-scratch-in-r.md)
> * 译者：[CACppuccino](https://github.com/CACppuccino)
> * 校对者：[Isvih](https://github.com/lsvih)

# Scratch 平台的神经网络实现（R 语言）

这篇文章是针对那些有统计或者经济学背景的人们，帮助他们通过 R 语言上的 Scratch 平台更好地学习和理解机器学习知识。

Andrej Karpathy 在 CS231n 课程中[这样说道](https://medium.com/@karpathy/yes-you-should-understand-backprop-e2f06eab496b) ：

>“我们有意识地在设计课程的时候，于反向传播算法的编程作业中包含了对最底层的数据的计算要求。学生们需要在原始的 numpy 库中使数据在各层中正向、反向传播。一些学生因而难免在课程的留言板上抱怨（这些复杂的计算）”

如果框架已经为你完成了反向传播算法（BP 算法）的计算，你又何苦折磨自己而不去探寻更多有趣的深度学习问题呢？


    import keras
    model = Sequential()
    model.add(Dense(512, activation=’relu’, input_shape=(784,)))
    model.add(Dense(10, activation=’softmax’))
    model.compile(loss=’categorical_crossentropy’, optimizer=RMSprop())
    model.fit()

Karpathy教授,将“智力上的好奇”或者“你可能想要晚些提升核心算法”的论点抽象出来，认为计算实际上是一种[泄漏抽象](https://en.wikipedia.org/wiki/Leaky_abstraction)（译者注：“抽象泄漏”是软件开发时，本应隐藏实现细节的抽象化不可避免地暴露出底层细节与局限性。抽象泄露是棘手的问题，因为抽象化本来目的就是向用户隐藏不必要公开的细节--维基百科）：

>“人们很容易陷入这样的误区中-认为你可以简单地将任意的神经层组合在一起然后反向传播算法会‘令它们自己在你的数据上工作起来’。”

因此，我写这篇文章的目的有两层：

1. 理解神经网络背后的抽象泄漏（通过在 Scratch 平台上操作），而这些东西的重要性恰恰是我开始所忽略的。这样如果我的模型没有达到预期的学习效果，我可以更好地解决问题，而不是盲目地改变优化方案（甚至更换学习框架）。

2. 一个深度神经网络（DNN），一旦被拆分成块，对于 AI 领域之外的人们也再也不是一个黑箱了。相反，对于大多数有基本的统计背景的人来说，是一个个非常熟悉的话题的组合。我相信他们只需要学习很少的一些（只是那些如何将这一块块知识组合一起）知识就可以在一个全新的领域获得不错的洞察力。

从线性回归开始，借着 R-notebook，通过解决一系列的数学和编程问题直至了解深度神经网络（DNN）。希望能够借此展示出来，你所需学习的新知识其实只有很少的一部分。

![](https://cdn-images-1.medium.com/max/800/1*nzwaX3XqlaRGAf0kpN9ShA.png)

**笔记**

[https://github.com/ilkarman/DemoNeuralNet/blob/master/01_LinearRegression.ipynb](https://github.com/ilkarman/DemoNeuralNet/blob/master/01_LinearRegression.ipynb)
[https://github.com/ilkarman/DemoNeuralNet/blob/master/02_LogisticRegression.ipynb](https://github.com/ilkarman/DemoNeuralNet/blob/master/02_LogisticRegression.ipynb)
[https://github.com/ilkarman/DemoNeuralNet/blob/master/03_NeuralNet.ipynb](https://github.com/ilkarman/DemoNeuralNet/blob/master/03_NeuralNet.ipynb)
[https://github.com/ilkarman/DemoNeuralNet/blob/master/04_Convolutions.ipynb](https://github.com/ilkarman/DemoNeuralNet/blob/master/04_Convolutions.ipynb)

### **一、线性回归（[见笔记(github-ipynb)](https://github.com/ilkarman/DemoNeuralNet/blob/master/01_LinearRegression.ipynb)）**  

![](https://cdn-images-1.medium.com/freeze/max/30/1*OqXD5Z73f433hLfoMEYqyg.jpeg?q=20)<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*OqXD5Z73f433hLfoMEYqyg.jpeg">

在 R 中解决最小二乘法的计算器的闭包解决方案只需如下几行：

    # Matrix of explanatory variables
    X <- as.matrix(X)
    # Add column of 1s for intercept coefficient
    intcpt <- rep(1, length(y))
    # Combine predictors with intercept
    X <- cbind(intcpt, X)
    # OLS (closed-form solution)
    beta_hat <- solve(t(X) %*% X) %*% t(X) %*% y

变量 beta_hat 所形成的向量包含的数值，定义了我们的“机器学习模型”。线性回归是用来预测一个连续的变量的（例如：这架飞机会延误多久）。在预测分类的时候（例如：这架飞机会延误吗-会/不会），我们希望我们的预测能够落在0到1之间，这样我们可以将其转换为各个种类的事件发生的可能性（根据所给的数据）。

当我们只有两个互斥的结果时我们将使用一个二项逻辑回归。当候选结果（或者分类）多于两个时，即多项互斥（例如：这架飞机延误时间可能在5分钟内、5-10分钟或多于10分钟），我们将使用多项逻辑回归（或者“Softmax 回归”）（译者注：Softmax 函数是逻辑函数的一种推广，更多知识见[知乎](https://www.zhihu.com/question/23765351)）。在这种情况下许多类别不是互斥的（例如：这篇文章中的“R”，“神经网络”和“统计学”），我们可以采用二项式逻辑回归（译者注：不是二项逻辑回归）。

另外，我们也可以用[梯度下降（GD）](https://en.wikipedia.org/wiki/Gradient_descent)这种迭代法来替代我们上文提到的闭包方法。整个过程如下：

- 从随机地猜测权重开始
- 将所猜测的权重值代入损失函数中
- 将猜测值移向梯度的相反方向移动一小步（即我们所谓的“学习频率”）
- 重复上述步骤 N 次

GD 仅仅使用了 [Jacobian](https://en.wikipedia.org/wiki/Jacobian_matrix_and_determinant) 矩阵 (而不是 [Hessian](https://en.wikipedia.org/wiki/Hessian_matrix) 矩阵)，不过我们知道， 当我们的损失函数为凸函数时，所有的极小值即（局部最小值）为（全局）最小值，因此 GD 总能够收敛至全局最小值。

线性回归中所用的损失函数是均方误差函数：

![](https://cdn-images-1.medium.com/max/800/1*RarCa--RxFLE29XXs62LsQ.jpeg)

要使用 GD 方法我们只需要找出 beta_hat 的偏导数（即 'delta'/梯度）

在 R 中实现方法如下：

    # Start with a random guess
    beta_hat <- matrix(0.1, nrow=ncol(X_mat))
      # Repeat below for N-iterations
      for (j in 1:N)
      {
        # Calculate the cost/error (y_guess - y_truth)
        residual <- (X_mat %*% beta_hat) - y
        # Calculate the gradient at that point
        delta <- (t(X_mat) %*% residual) * (1/nrow(X_mat))
        # Move guess in opposite direction of gradient
        beta_hat <- beta_hat - (lr*delta)
      }

200次的迭代之后我们会得到和闭包方法一样的梯度与参数。除了这代表着我们的进步意外（我们使用了 GD），这个迭代方法在当闭包方法因矩阵过大，而无法计算矩阵的逆的时候，也非常有用（因为有内存的限制）。

### **第二步 - 逻辑回归 (**[**见笔记(github-ipynb)**](https://github.com/ilkarman/DemoNeuralNet/blob/master/02_LogisticRegression.ipynb)**)**

![](https://cdn-images-1.medium.com/max/800/1*MNQueiCKMXqP6V5V5AvN3w.jpeg)

逻辑回归即一种用来解决二项分类的线性回归方法。它与标准的线性回归主要的两种不同在于：

1. 我们使用一种称为 logistic-sigmoid 的 ‘激活’/链接函数来将输出压缩至 0 到 1 的范围内
2. 不是最小化损失的方差而是最小化伯努利分布的负对数似然

其它的都保持不变。

我们可以像这样计算我们的激活函数：

    sigmoid <- function(z){1.0/(1.0+exp(-z))}

我们可以在 R 中这样创建对数似然函数：

    log_likelihood <- function(X_mat, y, beta_hat)
    {
      scores <- X_mat %*% beta_hat
      ll <- (y * scores) - log(1+exp(scores))
      sum(ll)
    }

这个损失函数（逻辑损失或对数损失函数）也叫做交叉熵损失。交叉熵损失根本上来讲是对“意外”的一种测量，并且会成为所有接下来的模型的基础，所以值得多花一些时间。

如果我们还像以前一样建立最小平方损失函数，由于我们目前拥有的是一个非线性激活函数（sigmoid），那么损失函数将因不再是凸函数而使优化变得困难。

![](https://cdn-images-1.medium.com/max/800/1*RarCa--RxFLE29XXs62LsQ.jpeg)

我们可以为两个分类设立自己的损失函数。当 y=1 时，我们希望我们的损失函数值在预测值接近0的时候变得非常高，在接近1的时候变得非常低。当 y=0 时，我们所期望的与之前恰恰相反。这导致了我们有了如下的损失函数：

![](https://cdn-images-1.medium.com/max/800/1*Nj7sNRh1aufj8OVePHbOWA.jpeg)

这里的损失函数中的 delta 与我们之前的线性回归中的 delta 非常相似。唯一的不同在于我们在这里将 sigmoid 函数也应用在了预测之中。这意味着逻辑回归中的梯度下降函数也会看起来很相似：

    logistic_reg <- function(X, y, epochs, lr)
    {
      X_mat <- cbind(1, X)
      beta_hat <- matrix(1, nrow=ncol(X_mat))
      for (j in 1:epochs)
      {
        # For a linear regression this was:
        # 1*(X_mat %*% beta_hat) - y
        residual <- sigmoid(X_mat %*% beta_hat) - y
        # Update weights with gradient descent
        delta <- t(X_mat) %*% as.matrix(residual, ncol=nrow(X_mat)) *  (1/nrow(X_mat))
        beta_hat <- beta_hat - (lr*delta)
      }
      # Print log-likliehood
      print(log_likelihood(X_mat, y, beta_hat))
      # Return
      beta_hat
    }

### **三、Softmax 回归函数（无笔记）**

![](https://cdn-images-1.medium.com/max/800/1*yTtVwA4kNcKEM4ETIJwdcQ.jpeg)

逻辑回归的推广即为多项逻辑回归（也称为 ‘softmax 函数’），是对两项以上的分类进行预测的。我尚未在 R 中建立这个例子，因为下一步的神经网络中也有一些东西简化之后与之相似，然而为了完整起见，如果你仍然想要创建它的话，我还是要强调一下这里主要的不同。

首先，我们不再用 sigmoid 函数来讲我们所得的值压缩在 0 至 1 之间：

![](https://cdn-images-1.medium.com/max/800/1*aTpB9Ibo-RbemepyDvfYbQ.png)

我们用 softmax 函数来将 n 个值的和压缩至 1：

![](https://cdn-images-1.medium.com/max/800/1*fkB_2c-KYd_tqzo6A9dZEw.png)

这样意味着每个类别所得的值，可以根据所给的条件，被转化为该类的概率。同时也意味着当我们希望提高某一分类的权重来提高它所获得的概率的时候，其它分类的出现概率会有所下降。也就是说，我们的各个类别是互斥的。

其次，我们使用一个更加通用的交叉熵损失函数：

![](https://cdn-images-1.medium.com/max/800/1*iJWZqkYxBTXwyotU2daAmQ.jpeg)

要想知道为什么-记住对于二项分类（如之前的例子）我们有两个类别：j = 2，在每个类别是互斥的，a1 + a2 = 1 且 y 是[一位有效编码（one-hot）](https://www.quora.com/What-is-one-hot-encoding-and-when-is-it-used-in-data-science)所以 y1+y2=1，我们可以将通用公式重写为：
（译者注：one-hot是将分类的特征转化为更加适合分类和回归算法的数据格式（Quora-Håkon Hapnes Strand），[中文资料可见此](http://blog.csdn.net/google19890102/article/details/44039761)）

![](https://cdn-images-1.medium.com/max/800/1*M_zxupHutdBfXE0pg_ZkRg.jpeg)

这与我们刚开始的等式是相同的。然而，我们现在将 j=2 的条件放宽。这里的交叉熵损失函数可以被看出来有着与二项分类的逻辑输出的交叉熵有着相同的梯度。

![](https://cdn-images-1.medium.com/max/800/1*l9Vq97wHTVOBVJisti21-Q.png)

然而，即使梯度有着相同的公式，也会因为激活函数代入了不同的值而不一样（用了 softmax 而不是逻辑中的 sigmoid）。

在大多数的深度学习框架中，你可以选择‘二项交叉熵（binary_crossentropy）’或者‘分类交叉熵（categorical_crossentropy）’损失函数。这取决于你的最后一层神经包含的是 sigmoid 还是 softmax 激活函数，相对应着，你可以选择‘二项交叉熵（binary_crossentropy）’或者‘分类交叉熵（categorical_crossentropy）’。而由于梯度相同，神经网络的训练并不会被影响，然而所得到的损失（或评测值）会由于搞混它们而错误。

之所以要涉及到 softmax 是因为大多数的神经网络，会在各个类别互斥的时候，用 softmax 层作为最后一层（读出层），用多项交叉熵（也叫分类交叉熵）损失函数，而不是用 sigmoid 函数搭配二项交叉熵损失函数。尽管多项 sigmoid 也可以用于多类别分类（并且会被用于下个例子中），但这总体上仅用于多项不互斥的时候。有了 softmax 作为输出，由于输出的和被限制为 1，我们可以直接将输出转化为概率。

### **四、神经网络（**[**见笔记(github-ipynb)**]((https://github.com/ilkarman/DemoNeuralNet/blob/master/03_NeuralNet.ipynb))**）**

![](https://cdn-images-1.medium.com/max/800/1*j1cC_Uh46f_wlLpBzkoYsQ.jpeg)

一个神经网络可以被看作为一系列的逻辑回归堆叠在一起。这意味着我们可以说，一个逻辑回归实际上是一个（带有 sigmoid 激活函数）无隐藏层的神经网络。

隐藏层，使神经网络具有非线性且导致了用于[通用近似定理](https://en.wikipedia.org/wiki/Universal_approximation_theorem)所描述的特性。该定理声明，一个神经网络和一个隐藏层可以逼近任何线性或非线性的函数。而隐藏层的数量可以扩展至上百层。

如果将神经网络看作两个东西的结合会很有用：1）很多的逻辑回归堆叠在一起形成‘特征生成器’ 2）一个 softmax 回归函数构成的单个读出层。近来深度学习的成功可归功于‘特征生成器’。例如：在以前的计算机视觉领域，我们需要痛苦地声明我们需要找到各种长方形，圆形，颜色和结合方式（与经济学家们如何决定哪些相互作用需要用于线性回归中相似）。现在，隐藏层是对决定哪个特征（哪个‘相互作用’）需要提取的优化器。很多的深度学习实际上是通过用一个训练好的模型，去掉读出层，然后用那些特征作为输入（或者是促进决策树（boosted decision-trees））来生成的。

隐藏层同时也意味着我们的损失函数在参数中不是一个凸函数，我们不能够通过一个平滑的山坡来到达底部。我们会用随机梯度下降（SGD）而不是梯度下降（GD），不像我们之前在逻辑回归中做的一样，这样基本上在每一次小批量（mini-batch）（比观察总数小很多）被在神经网络中传播后都会重编观察（随机）并更新梯度。[这里](http://sebastianruder.com/optimizing-gradient-descent)有很多 SGD 的替代方法，Sebastian Ruder 为我们做了很多工作。我认为这确实是个迷人的话题，不过却超出这篇博文所讨论的范围了，很遗憾。简要来讲，大多数优化方法是一阶的（包括 SGD，Adam，RMSprop和 Adagrad）因为计算二阶函数的计算难度过高。然而，一些一阶方法有一个固定的学习频率（SGD）而有一些拥有适应性学习频率（Adam），这意味着我们通过成为损失函数所更新权重的‘数量’-将会在开始有巨大的变化而随着我们接近目标而逐渐变小。

需要弄清楚的一点是，最小化训练数据上的损失并非我们的主要目标-理论上我们希望最小化‘不可见的’（测试）数据的损失；因此所有的优化方法都代表着已经一种假设之下，即训练数据的的低损失会以同样的（损失）分布推广至‘新’的数据。这意味着我们可能更青睐于一个有着更高的训练数据损失的神经网络；因为它在验证数据上的损失很低（即那些未曾被用于训练的数据）-我们则会说该神经网络在这种情况下‘过度拟合’了。这里有一些近期的[论文](https://arxiv.org/abs/1705.08292)声称，他们发现了很多很尖的最小值点，所以适应性优化方法并不像 SGD 一样能够很好的推广。（译者注：即算法在一些验证数据中表现地出奇的差）

之前我们需要将梯度反向传播一层，现在一样，我们也需要将其反向传播过所有的隐藏层。关于反向传播算法的解释，已经超出了本文的范围，然而理解这个算法却是十分必要的。这里有一些不错的[资源](http://neuralnetworksanddeeplearning.com/chap2.html)可能对各位有所帮助。

我们现在可以在 Scratch 平台上用 R 通过四个函数建立一个神经网络了。

1. 我们首先初始化权重：
    
	neuralnetwork <- function(sizes, training_data, epochs, mini_batch_size, lr, C, verbose=FALSE, validation_data=training_data)

由于我们将参数进行了复杂的结合，我们不能简单地像以前一样将它们初始化为 1 或 0，神经网络会因此而在计算过程中卡住。为了防止这种情况，我们采用高斯分布（不过就像那些优化方法一样，这也有许多其他的方法）：

    biases <- lapply(seq_along(listb), function(idx){
        r <- listb[[idx]]
        matrix(rnorm(n=r), nrow=r, ncol=1)
        })

    weights <- lapply(seq_along(listb), function(idx){
        c <- listw[[idx]]
        r <- listb[[idx]]
        matrix(rnorm(n=r*c), nrow=r, ncol=c)
        })

2. 我们使用随机梯度下降（SGD）作为我们的优化方法：

    
    	SGD <- function(training_data, epochs, mini_batch_size, lr, C, sizes, num_layers, biases, weights,verbose=FALSE, validation_data)
    	{
    	  # Every epoch
    	  for (j in 1:epochs){
    	# Stochastic mini-batch (shuffle data)
    	training_data <- sample(training_data)
    	# Partition set into mini-batches
    	mini_batches <- split(training_data,
    	  ceiling(seq_along(training_data)/mini_batch_size))
    	# Feed forward (and back) all mini-batches
    	for (k in 1:length(mini_batches)) {
    	  # Update biases and weights
    	  res <- update_mini_batch(mini_batches[[k]], lr, C, sizes, num_layers, biases, weights)
    	  biases <- res[[1]]
    	  weights <- res[[-1]]
    	}
    	  }
    	  # Return trained biases and weights
    	  list(biases, weights)
    	}
    

3. 作为 SGD 方法的一部分，我们更新了
	    
	    update_mini_batch <- function(mini_batch, lr, C, sizes, num_layers, biases, weights)
	    {
	      nmb <- length(mini_batch)
	      listw <- sizes[1:length(sizes)-1]
	      listb <-  sizes[-1]
	    
	    # Initialise updates with zero vectors (for EACH mini-batch)
	      nabla_b <- lapply(seq_along(listb), function(idx){
	    r <- listb[[idx]]
	    matrix(0, nrow=r, ncol=1)
	      })
	      nabla_w <- lapply(seq_along(listb), function(idx){
	    c <- listw[[idx]]
	    r <- listb[[idx]]
	    matrix(0, nrow=r, ncol=c)
	      })
	    
	    # Go through mini_batch
	      for (i in 1:nmb){
	    x <- mini_batch[[i]][[1]]
	    y <- mini_batch[[i]][[-1]]
	    # Back propagation will return delta
	    # Backprop for each observation in mini-batch
	    delta_nablas <- backprop(x, y, C, sizes, num_layers, biases, weights)
	    delta_nabla_b <- delta_nablas[[1]]
	    delta_nabla_w <- delta_nablas[[-1]]
	    # Add on deltas to nabla
	    nabla_b <- lapply(seq_along(biases),function(j)
	      unlist(nabla_b[[j]])+unlist(delta_nabla_b[[j]]))
	    nabla_w <- lapply(seq_along(weights),function(j)
	      unlist(nabla_w[[j]])+unlist(delta_nabla_w[[j]]))
	      }
	      # After mini-batch has finished update biases and weights:
	      # i.e. weights = weights - (learning-rate/numbr in batch)*nabla_weights
	      # Opposite direction of gradient
	      weights <- lapply(seq_along(weights), function(j)
	    unlist(weights[[j]])-(lr/nmb)*unlist(nabla_w[[j]]))
	      biases <- lapply(seq_along(biases), function(j)
	    unlist(biases[[j]])-(lr/nmb)*unlist(nabla_b[[j]]))
	      # Return
	      list(biases, weights)
	    }

4. 我们用来计算 delta 的算法是反向传播算法。

在这个例子中我们使用交叉熵损失函数，产生了以下的梯度：

    cost_delta <- function(method, z, a, y) {if (method=='ce'){return (a-y)}}

同时，为了与我们的逻辑回归例子保持连续，我们在隐藏层和读出层上使用 sigmoid 激活函数：

    # Calculate activation function
        sigmoid <- function(z){1.0/(1.0+exp(-z))}
        # Partial derivative of activation function
        sigmoid_prime <- function(z){sigmoid(z)*(1-sigmoid(z))}

如之前所说，一般来讲 softmax 激活函数适用于读出层。对于隐藏层，[线性整流函数（ReLU）](https://en.wikipedia.org/wiki/Rectifier_%28neural_networks%29)更加地普遍，这里就是最大值函数（负数被看作为0）。隐藏层使用的激活函数可以被想象为一场扛着火焰同时保持它（梯度）不灭的比赛。sigmoid 函数在0和1处平坦化，成为一个平坦的梯度，相当于火焰的熄灭（我们失去了信号）。而线性整流函数（ReLU）帮助保存了这个梯度。

反向传播函数被定义为：

    backprop <- function(x, y, C, sizes, num_layers, biases, weights)

请在笔记中查看完整的代码-然而原则还是一样的：我们有一个正向传播，使得我们在网络中将权重传导过所有神经层，并产生预测值。然后将预测值代入损失梯度函数中并将所有神经层中的权重更新。

这总结了神经网络的建成（搭配上你所需要的尽可能多的隐藏层）。将隐藏层的激活函数换为 ReLU
函数，读出层换为 softmax 函数，并且加上 L1 和 L2 的归一化，是一个不错的练习。把它在笔记中的 [iris 数据集](http://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html)跑一遍，只用一个隐藏层，包含40个神经元，我们就可以在大概30多回合训练后得到一个96%精确度的神经网络。

笔记中还提供了一个100个神经元的[手写识别系统](http://yann.lecun.com/exdb/mnist/)的例子，来根据28*28像素的图像预测数字。

### **五、卷积神经网络（**[**见笔记(https://github.com/ilkarman/DemoNeuralNet/blob/master/04_Convolutions.ipynb)**]**）**

![](https://cdn-images-1.medium.com/max/800/1*1-jeLcRrMSoUEL9YTMYpCw.jpeg)

在这里，我们只会简单地测试卷积神经网络（CNN）中的**正向传播**。CNN 首次受到关注是因为1998年的[LeCun的精品论文](http://yann.lecun.com/exdb/publis/pdf/lecun-98b.pdf)。自此之后，CNN 被证实是在图像、声音、视频甚至文字中最好的算法。

图像识别开始时是一个手动的过程，研究者们需要明确图像的哪些比特（特征）对于识别有用。例如，如果我们希望将一张图片归类进‘猫’或‘篮球’，我们可以写一些代码提取出颜色（如篮球是棕色）和形状（猫有着三角形耳朵）。这样我们或许就可以在这些特征上跑一个线性回归，来得到三角形个数和图像是猫还是树的关系。这个方法很受图片的大小、角度、质量和光线的影响，有很多问题。[规模不变的特征变换(SIFT)](https://en.wikipedia.org/wiki/Scale-invariant_feature_transform) 在此基础上做了大幅提升并曾被用来对一个物体提供‘特征描述’，这样可以被用来训练线性回归（或其他的关系型学习器）。然而，这个方法有个一成不变的规则使其不能被为特定的领域而优化。

CNN 卷积神经网络用一种很有趣的方式看待图像（提取特征）。开始时，他们只观察图像的很小一部分（每次），比如说一个大小为 5*5 像素的框（一个过滤器）。2D 用于图像的卷积，是将这个框扫遍整个图像。这个阶段会专门用于提取颜色和线段。然而，下一个神经层会转而关注之前过滤器的结合，因而‘放大来观察’。在一定数量的层数之后，神经网络会放的足够大而能识别出形状和更大的结构。

这些过滤器最终会成为神经网络需要去学习、识别的‘特征’。接着，它就可以通过统计各个特征的数量来识别其与图像标签（如‘篮球’或‘猫’）的关系。这个方法看起来对图片来讲很自然-因为它们可以被拆成小块来描述（它们的颜色，纹理等）。CNN 看起来在图像分形特征分析方面会蓬勃发展。这也意味着它们不一定适合其他形式的数据，如 excel 工作单中就没有固有的样式：我们可以改变任意几列的顺序而数据还是一样的——不过在图像中交换像素点的位置就会导致图像的改变。

在之前的例子中我们观察的是一个标准的神经网络对手写字体的归类。在神经网络中的 i 层的每个神经元，与 j 层的每个神经元相连-我们所框中的是整个图像（译者注：与 CNN 之前的 5*5 像素的框不同）。这意味着如果我们学习了数字 2 的样子，我们可能无法在它被错误地颠倒的时候识别出来，因为我们只见过它正的样子。CNN 在观察数字 2 的小的比特时并且在比较样式的时候有很大的优势。这意味着很多被提取出的特征对各种旋转，歪斜等是免疫的（译者注：即适用于所有变形）。对于更多的细节，Brandon 在[这里](https://www.youtube.com/watch?v=FmpDIaiMIeA)解释了什么是真正的 CNN。

我们在 R 中如此定义 2D 卷积函数：

    convolution <- function(input_img, filter, show=TRUE, out=FALSE)
    {
      conv_out <- outer(
        1:(nrow(input_img)-kernel_size[[1]]+1),
        1:(ncol(input_img)-kernel_size[[2]]+1),
        Vectorize(function(r,c) sum(input_img[r:(r+kernel_size[[1]]-1),
                                              c:(c+kernel_size[[2]]-1)]*filter))
      )
    }

并用它对一个图片应用了一个 3*3 的过滤器：

    conv_emboss <- matrix(c(2,0,0,0,-1,0,0,0,-1), nrow = 3)
    convolution(input_img = r_img, filter = conv_emboss)

你可以查看笔记来看结果，然而这看起来是从图片中提取线段。否则，卷积可以‘锐化’一张图片，就像一个3*3的过滤器：

    conv_sharpen <- matrix(c(0,-1,0,-1,5,-1,0,-1,0), nrow = 3)
    convolution(input_img = r_img, filter = conv_sharpen)

很显然我们可以随机地随机地初始化一些个数的过滤器（如：64个）：

    filter_map <- lapply(X=c(1:64), FUN=function(x){
        # Random matrix of 0, 1, -1
        conv_rand <- matrix(sample.int(3, size=9, replace = TRUE), ncol=3)-2
        convolution(input_img = r_img, filter = conv_rand, show=FALSE, out=TRUE)
    })

我们可以用以下的函数可视化这个 map：

    square_stack_lst_of_matricies <- function(lst)
    {
        sqr_size <- sqrt(length(lst))
        # Stack vertically
        cols <- do.call(cbind, lst)
        # Split to another dim
        dim(cols) <- c(dim(filter_map[[1]])[[1]],
                       dim(filter_map[[1]])[[1]]*sqr_size,
                       sqr_size)
        # Stack horizontally
        do.call(rbind, lapply(1:dim(cols)[3], function(i) cols[, , i]))
    }

![](https://cdn-images-1.medium.com/max/800/1*s-TR-n5n2-4ZwwZ962X3LQ.png)

在运行这个函数的时候我们意识到了整个过程是如何地高密度计算（与标准的全连接神经层相比）。如果这些 feature-map 不是那些那么有用的集合（也就是说，很难在此时降低损失）然后反向传播会意味着我们将会得到不同的权重，与不同的 feature-map 相关联，对于进行的聚类很有帮助。


很明显的我们将卷积建立在其他的卷积中（而且因此需要一个深度网络）所以线段构成了形状而形状构成了鼻子，鼻子构成了脸。测试一些训练的网络中的[feature map](https://adeshpande3.github.io/assets/deconvnet.png)来看看神经网络实际学到了什么也是一件有趣的事。

### References

[http://neuralnetworksanddeeplearning.com/](http://neuralnetworksanddeeplearning.com/)

[https://www.youtube.com/user/BrandonRohrer/videos](https://www.youtube.com/user/BrandonRohrer/videos)

[http://colah.github.io/posts/2014-07-Conv-Nets-Modular/](http://colah.github.io/posts/2014-07-Conv-Nets-Modular/)

[https://houxianxu.github.io/2015/04/23/logistic-softmax-regression/](https://houxianxu.github.io/2015/04/23/logistic-softmax-regression/)

[https://www.ics.uci.edu/~pjsadows/notes.pdf](https://www.ics.uci.edu/~pjsadows/notes.pdf)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
