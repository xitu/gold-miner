> * 原文地址：[Can Machine Learning model simple Math functions?](https://towardsdatascience.com/can-machine-learning-model-simple-math-functions-d336cf3e2a78)
> * 原文作者：[Harsh Sahu](https://medium.com/@hsahu)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/can-machine-learning-model-simple-math-functions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/can-machine-learning-model-simple-math-functions.md)
> * 译者：[Minghao23](https://github.com/Minghao23)
> * 校对者：[lsvih](https://github.com/lsvih)，[zoomdong](https://github.com/fireairforce)

# 机器学习可以建模简单的数学函数吗？

> 使用机器学习建模一些基础数学函数

![Photo Credits: [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/7276/1*lG0d-oazOpw92Z_GaSAzcw.jpeg)

近来，在各种任务上应用机器学习已经成为了一个惯例。似乎在每一个 [Gartner's 技术循环曲线](https://en.wikipedia.org/wiki/Hype_cycle) 上的新兴技术都对机器学习有所涉及，这是一种趋势。这些算法被当做 figure-out-it-yourself 的模型：将任何类型的数据都分解为一串特征，应用一些黑盒的机器学习模型，对每个模型求解并选择结果最好的那个。

但是机器学习真的能解决所有的问题吗？还是它只适用于一小部分的任务？在这篇文章中，我们试图回答一个更基本的问题，即机器学习能否推导出那些在日常生活中经常出现的数学关系。在这里，我会尝试使用一些流行的机器学习技术来拟合几个基础的函数，并观察这些算法能否识别并建模这些基础的数学关系。

我们将要尝试的函数：

* 线性函数
* 指数函数
* 对数函数
* 幂函数
* 模函数
* 三角函数

将会用到的机器学习算法：

* XGBoost
* 线性回归
* 支持向量回归（SVR）
* 决策树
* 随机森林
* 多层感知机（前馈神经网络）

![](https://cdn-images-1.medium.com/max/2642/1*_660b9dw5ItbLqQmFEND9w.png)

### 数据准备

我会保持因变量（译者注：原文错误，应该为自变量）的维度为 4（选择这个特殊的数字并没有什么原因）。所以，X（自变量）和 Y（因变量）的关系为：

![](https://cdn-images-1.medium.com/max/2000/1*VrJYX9Y5cHPDPAOo_kC1-g.png)

f :- 我们将要拟合的函数

Epsilon:- 随机噪声（使 Y 更加真实一点，因为现实生活中的数据中总是存在一些噪声）

每个函数类型都会用到一系列的参数。这些参数通过生成随机数得到，方法如下：

```python
numpy.random.normal()
numpy.random.randint()
```

randint() 用于获取幂函数的参数，以免 Y 的值特别小。normal() 用于所有其他情况。

生成自变量（即 X）：

```python
function_type = 'Linear'

if function_type=='Logarithmic':
    X_train = abs(np.random.normal(loc=5, size=(1000, 4)))
    X_test = abs(np.random.normal(loc=5, size=(500, 4)))
else:
    X_train = np.random.normal(size=(1000, 4))
    X_test = np.random.normal(size=(500, 4))
```

对于对数函数，使用均值为 5（均值远大于方差）的正态分布来避免得到负值。

获取因变量（即 Y）：

```python
def get_Y(X, function_type, paras):
    X1 = X[:,0]
    X2 = X[:,1]
    X3 = X[:,2]
    X4 = X[:,3]
    if function_type=='Linear':
        [a0, a1, a2, a3, a4] = paras
        noise = np.random.normal(scale=(a1*X1).var(), size=X.shape[0])
        Y = a0+a1*X1+a2*X2+a3*X3+a4*X4+noise
    elif function_type=='Exponential':
        [a0, a1, a2, a3, a4] = paras
        noise = np.random.normal(scale=(a1*np.exp(X1)).var(), size=X.shape[0])
        Y = a0+a1*np.exp(X1)+a2*np.exp(X2)+a3*np.exp(X3)+a4*np.exp(X4)+noise
    elif function_type=='Logarithmic':
        [a0, a1, a2, a3, a4] = paras
        noise = np.random.normal(scale=(a1*np.log(X1)).var(), size=X.shape[0])
        Y = a0+a1*np.log(X1)+a2*np.log(X2)+a3*np.log(X3)+a4*np.log(X4)+noise
    elif function_type=='Power':
        [a0, a1, a2, a3, a4] = paras
        noise = np.random.normal(scale=np.power(X1,a1).var(), size=X.shape[0])
        Y = a0+np.power(X1,a1)+np.power(X2,a2)+np.power(X2,a2)+np.power(X3,a3)+np.power(X4,a4)+noise
    elif function_type=='Modulus':
        [a0, a1, a2, a3, a4] = paras
        noise = np.random.normal(scale=(a1*np.abs(X1)).var(), size=X.shape[0])
        Y = a0+a1*np.abs(X1)+a2*np.abs(X2)+a3*np.abs(X3)+a4*np.abs(X4)+noise
    elif function_type=='Sine':
        [a0, a1, b1, a2, b2, a3, b3, a4, b4] = paras
        noise = np.random.normal(scale=(a1*np.sin(X1)).var(), size=X.shape[0])
        Y = a0+a1*np.sin(X1)+b1*np.cos(X1)+a2*np.sin(X2)+b2*np.cos(X2)+a3*np.sin(X3)+b3*np.cos(X3)+a4*np.sin(X4)+b4*np.cos(X4)+noise
    else:
        print('Unknown function type')

    return Y


if function_type=='Linear':
    paras = [0.35526578, -0.85543226, -0.67566499, -1.97178384, -1.07461643]
    Y_train = get_Y(X_train, function_type, paras)
    Y_test = get_Y(X_test, function_type, paras)
elif function_type=='Exponential':
    paras = [ 0.15644562, -0.13978794, -1.8136447 ,  0.72604755, -0.65264939]
    Y_train = get_Y(X_train, function_type, paras)
    Y_test = get_Y(X_test, function_type, paras)
elif function_type=='Logarithmic':
    paras = [ 0.63278503, -0.7216328 , -0.02688884,  0.63856392,  0.5494543]
    Y_train = get_Y(X_train, function_type, paras)
    Y_test = get_Y(X_test, function_type, paras)
elif function_type=='Power':
    paras = [2, 2, 8, 9, 2]
    Y_train = get_Y(X_train, function_type, paras)
    Y_test = get_Y(X_test, function_type, paras)
elif function_type=='Modulus':
    paras = [ 0.15829356,  1.01611121, -0.3914764 , -0.21559318, -0.39467206]
    Y_train = get_Y(X_train, function_type, paras)
    Y_test = get_Y(X_test, function_type, paras)
elif function_type=='Sine':
    paras = [-2.44751615,  1.89845893,  1.78794848, -2.24497666, -1.34696884, 0.82485303,  0.95871345, -1.4847142 ,  0.67080158]
    Y_train = get_Y(X_train, function_type, paras)
    Y_test = get_Y(X_test, function_type, paras)
```

噪声是在 0 均值的正态分布中随机抽样得到的。我设置了噪声的方差等于 f(X) 的方差，借此保证我们数据中的“信号和噪声”具有可比性，且噪声不会在信号中有损失，反之亦然。

### 训练

注意：在任何模型中都没有做超参数的调参。
我们的基本想法是只在这些模型对所提及的函数上的表现做一个粗略的估计，因此没有对这些模型做太多的优化。

```python
model_type = 'MLP'

if model_type=='XGBoost':
    model = xgb.XGBRegressor()
elif model_type=='Linear Regression':
    model = LinearRegression()
elif model_type=='SVR':
    model = SVR()
elif model_type=='Decision Tree':
    model = DecisionTreeRegressor()
elif model_type=='Random Forest':
    model = RandomForestRegressor()
elif model_type=='MLP':
    model = MLPRegressor(hidden_layer_sizes=(10, 10))

model.fit(X_train, Y_train)
```

![](https://cdn-images-1.medium.com/max/2642/1*_660b9dw5ItbLqQmFEND9w.png)

### 结果

![Results](https://cdn-images-1.medium.com/max/2000/1*4labvDJR1p8-yOsm8PeeNw.png)

大多数的表现结果比平均基线要好很多。计算出的平均R方是 **70.83%**，**我们可以说，机器学习技术对这些简单的数学函数确实可以有效地建模**。

但是通过这个实验，我们不仅知道了机器学习能否建模这些函数，同时也了解了不同的机器学习技术在各种基础函数上的表现是怎样的。

有些结果是令人惊讶的（至少对我来说），有些则是合理的。总之，这些结果重新认定了我们的一些先前的想法，也给出了新的想法。

最后，我们可以得到下列结论：

* 尽管线性回归是一个简单的模型，但是在线性相关的数据上，它的表现是优于其他模型的
* 大多数情况下，决策树 \< 随机森林 \< XGBoost，这是根据实验的表现得到的（在以上 6 个结果中有 5 个是显而易见的）
* 不像最近实践中的流行趋势那样，XGBoost（6 个结果中只有 2 个表现最好）不应该成为所有类型的列表数据的一站式解决方案，我们仍然需要对每个模型进行公平地比较。
* 和我们的猜测相反的是，线性函数不一定是最容易预测的函数。我们在对数函数上得到了最好的聚合R方结果，达到了 92.98%
* 各种技术在不同的基础函数上的效果（相对地）差异十分大，因此，对一个任务选择何种技术必须经过完善的思考和实验

完整代码见我的 [github](https://github.com/SahuH/Model-math-functions-using-ML)。

***

来点赞，评论和分享吧。建设性的批评和反馈总是受欢迎的！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
