> * 原文地址：[Can Machine Learning model simple Math functions?](https://towardsdatascience.com/can-machine-learning-model-simple-math-functions-d336cf3e2a78)
> * 原文作者：[Harsh Sahu](https://medium.com/@hsahu)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/can-machine-learning-model-simple-math-functions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/can-machine-learning-model-simple-math-functions.md)
> * 译者：
> * 校对者：

# Can Machine Learning model simple Math functions?

> Modelling some fundamental mathematical functions using machine learning

![Photo Credits: [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/7276/1*lG0d-oazOpw92Z_GaSAzcw.jpeg)

It has become a norm these days to apply machine learning on every kind of task. It is a symptom of the fact that Machine learning is seemingly a permanent fixture in [Gartner’s hype cycle](https://en.wikipedia.org/wiki/Hype_cycle) for emerging technologies. These algorithms are being treated like figure-out-it-yourself models: Breakdown data of any sort into a bunch of features, apply a number of black-box machine learning models, evaluate each and choose the one that works out best.

But can machine learning really solve all those problems or is it just good for a small handful of tasks. We tend to answer an even more fundamental question in this article, and that is, can ML even deduce mathematical relationships that very commonly occur in everyday life. Here, I will try to fit few basic functions using some popular machine learning techniques. Lets see if these algorithms can discern and model these fundamental mathematical relations.

Functions that we will try to fit:

* Linear
* Exponential
* Logarithm
* Power
* Modulus
* Trigonometric

The Machine learning techniques that will be used:

* XGBoost
* Linear Regression
* Support Vector Regression (SVR)
* Decision Tree
* Random Forest
* Multi-layer perceptron (Feed-forward neural network)

![](https://cdn-images-1.medium.com/max/2642/1*_660b9dw5ItbLqQmFEND9w.png)

### Preparing Data

I am keeping dependent variables to be of size 4 (no reason for choosing this specific number). So, the relation between X (Independent variables) and Y(dependent variable) will be:

![](https://cdn-images-1.medium.com/max/2000/1*VrJYX9Y5cHPDPAOo_kC1-g.png)

f :- function we are trying to fit

Epsilon:- Random noise (To make our Y a bit more realistic because real-life data will always have some noise)

Each function type is using a set of parameters. These parameters are chosen via generating random numbers using below methods:

```python
numpy.random.normal()
numpy.random.randint()
```

randint() is used for getting parameters of Power function so as to avoid Y values getting very small. normal() is used for all other cases.

Generate Independent variables (or X):

```python
function_type = 'Linear'

if function_type=='Logarithmic':
    X_train = abs(np.random.normal(loc=5, size=(1000, 4)))
    X_test = abs(np.random.normal(loc=5, size=(500, 4)))
else:
    X_train = np.random.normal(size=(1000, 4))
    X_test = np.random.normal(size=(500, 4))
```

For logarithmic, normal distribution with mean 5 (mean>>variance) is used to avoid getting any negative values.

Get Dependent variable (or Y):

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

Noise is randomly sampled with 0 mean. I have kept variance of noise equal to variance of f(X) to make sure ‘signal and noise’, in our data, are comparable and one does not get lost in the other.

### Training

Note: No hyperparamater tuning is done for any of the model.
The Rationale is to get a rough estimation of performance of these models on mentioned functions and, therefore, not much has been done to optimize these models for each of these cases.

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

### Results

![Results](https://cdn-images-1.medium.com/max/2000/1*4labvDJR1p8-yOsm8PeeNw.png)

Most of the performance outcomes are much better than a mean baseline. With an average R-squared coming out to be **70.83%**, **we can say that machine learning techniques are indeed decent at modelling these simple mathematical functions**.

But by this experiment, we not only get to know if machine learning can model these functions, but also how different techniques perform on these varied underlying functions.

Some results are surprising (at-least for me), while some are reassuring. Overall, these outcomes reinstates some of our prior beliefs and also make some new ones.

In conclusion, we can say that:

* Linear Regression although a simpler model outperforms everything else on linearly correlated data
* In most of the cases, Decision Tree \< Random Forest \< XGBoost, according to performance (as is evident in 5 out of 6 cases above)
* Unlike the trend these days in practice, XGBoost (turning out best in just 2 out of 6 cases) should not be a one-stop-shop for all kinds of tabular data, instead a fair comparison should be made
* As opposed to what we might presume, Linear function may not necessarily be easiest to predict. We are getting best aggregate R-squared of 92.98% for Logarithmic function
* Techniques are working (relatively) quite different on different underlying functions, therefore, technique for a task should be selected via thorough thought and experimentation

Complete code can be found on my [github](https://github.com/SahuH/Model-math-functions-using-ML).

***

Applaud, comment, share. Constructive criticism and feedback is always welcome!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
