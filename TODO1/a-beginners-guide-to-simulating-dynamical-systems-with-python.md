> * 原文地址：[A Beginner’s Guide to Simulating Dynamical Systems with Python](https://towardsdatascience.com/a-beginners-guide-to-simulating-dynamical-systems-with-python-a29bc27ad9b1)
> * 原文作者：[Christian Hubbs](https://medium.com/@christiandhubbs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginners-guide-to-simulating-dynamical-systems-with-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginners-guide-to-simulating-dynamical-systems-with-python.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)、[WangNing](https://github.com/w1187501630)
> * 校对者：[PorridgeZero](https://github.com/chzh9311)、[DylanXie123](https://github.com/DylanXie123)

# 使用 Python 模拟动力系统的初学者指南

> 使用 Python 对二阶常微分方程进行数值积分运算

![图由 [Dan Meyers](https://unsplash.com/@dmey503?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*GZYR2gufn9IzhkSu)

考察这样一个单摆模型。

![](https://cdn-images-1.medium.com/max/2048/0*7CYBv0aAMnMcHQr9.png)

一根长度为 L 的绳子下方悬挂一个质量为 m 的重物，绳子来回往复摆动。

这基本上是我们能够上手实践的最简单的系统，但是也不能被其表象上的简单所蒙蔽，因为它可以创建一个有趣的动力系统。我们将以此为起点来介绍一些基本的控制理论并将其和连续控制强化学习做对比。在此之前，我们有必要先花点时间了解下单摆的运动模型以及如何对其进行运动仿真。

## 摘要总结

我们推导出了单摆系统的动力学模型，并且分别使用 Python 的集成包和欧拉法创建了两个仿真模型。机器控制系统中的许多关节和系统都可以采用单摆进行建模，因此这里的仿真模型可以作为分析复杂系统的基础。

原文对文章的公式显示更友好，你可以[点击这里](https://www.datahubbs.com/simulating-dynamical-systems-with-python/)阅读。

## 摆动力学

若要对单摆系统进行仿真，则首先需要理解摆动力学。首先，我们画出单摆系统的受力分析图。其中摆绳的长度、小球的质量、重力及其他作用在这个系统上的力如下图所示。

![Free-body diagram of the simple pendulum.](https://cdn-images-1.medium.com/max/2000/0*8vEjw63JJBOSvML0)

绘制受力分析图有助于明确所有作用力，确保我们不会有所遗漏。接下来就可以使用牛顿第二运动定律来分析其动力学。牛顿第二运动定律的形式为 `F = ma`，我们使用其变体——[转动定律](https://brilliant.org/wiki/rotational-form-of-newtons-second-law/)表达如下：

![](https://cdn-images-1.medium.com/max/2000/1*3xMMMwDVq4IbHx-ku6Z-0g.png)

在这种情况下，τ 是关于原点的扭矩，I 是旋转惯性，α 是角加速度。扭矩由施加在重物上的力的垂直分量 (关于原点的力矩) 给出，旋转惯性即为 `I = mL²`，角加速度是 θ 的二阶导数。我们可以将这些值代入到上面的牛顿第二定律，可以得到：

![](https://cdn-images-1.medium.com/max/2000/1*ZY8xoZWK0WQw6Kr78RlTvQ.png)

为了完整性，我们还可以考虑单摆上的摩擦，这样就得到：

![](https://cdn-images-1.medium.com/max/2000/1*GfLPH68C4RaMzFkjE_y51Q.png)

首先要注意的是，由于方程中存在二阶导数 (θ)，所以这是一个二阶常微分方程（ODE）。我们希望能将其简化为一阶系统以便对其进行积分和模拟。但这是以复杂度为代价的，因为我们要把单个二阶系统分解成两个一阶方程。在我们现在分析的这种情况下，复杂度的成本并不大，但是对于更复杂的模型，这样处理可能会适得其反。

为此，我们需要引入两个新变量，分别命名为 θ_1 和 θ_2，并将它们定义为：

![](https://cdn-images-1.medium.com/max/2000/1*mnqoP1R59QrU_emUHwK4aw.png)

我们定义 `θ˙_2=θ¨` 来简化上述等式

于是可以得出：

![](https://cdn-images-1.medium.com/max/2000/1*_lCFpvFSWmxw1zShrZ4eaQ.png)

上面的方程式已经准备好了，下面将通过编码来对其进行建模。

## 模拟单摆动力学

首先导入相关库。

```python
import numpy as np
from scipy import integrate
import matplotlib.pyplot as plt
```

需要先定义一些常量，让质量和长度分别为 1kg 和 1m，至少现在，我们会暂且忽略摩擦，假设 b=0 。我们将模拟单摆从 π/2 (向右升高90度) 的位置开始摆动，并在没有初始速度的情况下释放。我们可以用 0.02s 作为间隔（Δt）来离散化 10s 的时间段。

```python
# 定义常量
m = 1 # 质量 (kg)
L = 1 # 长度 (m)
b = 0 # 摩擦因素 (kg/m^2-s)
g = 9.81 # 重力加速度 (m/s^2)
delta_t = 0.02 # 时间间隔 (s)
t_max = 10 # 最大模拟时长 (s)
theta1_0 = np.pi/2 # 初始角度 (rad)
theta2_0 = 0 #  初始角加速度 (rad/s)
theta_init = (theta1_0, theta2_0)
# 时间序列
t = np.linspace(0, t_max, t_max/delta_t)
```

我们将演示两种模拟方法，首先使用 `scipy` 库进行数值积分，然后再使用欧拉方法。

## Scipy 数值积分

使用 `scipy` 进行数值积分方法，我们需要为模型构建一个积分函数，称为 `int_pendulum_sim`。该模型将采用 θ_1 和 θ_2 的初始值 (代码中记为 `theta_init`) 对时间间隔（Δt）进行积分，然后返回对应的 theta 值。这个函数正好就是我们上面推导出的 θ˙_1 和 θ˙_2 的两个方程。

```python
def int_pendulum_sim(theta_init, t, L=1, m=1, b=0, g=9.81):
    theta_dot_1 = theta_init[1]
    theta_dot_2 = -b/m*theta_init[1] - g/L*np.sin(theta_init[0])
    return theta_dot_1, theta_dot_2
```

我们可以通过上述将函数作为参数传递给 `scipy.integrate.odeint` 来对我们的系统进行模拟。并且，还需要给出初始值和模拟时长。

```python
theta_vals_int = integrate.odeint(int_pendulum_sim, theta_init, t)
```

函数 `odeint` 将传入的参数与 θ˙ 进行积分运算，计算结果又作为初始值传入该函数自身以进行下一个时间间隔（Δt）的迭代运算，如此迭代直至所有时间间隔集合被遍历完成。

θ 和 θ˙ 随时间变化可以绘制成如下图。

![](https://cdn-images-1.medium.com/max/2000/0*eYACTeCtD68Nw88v)

我们的模型中是没有考虑摩擦力或其他力的，所以单摆只会在 -π/2 和 π/2 之间往复地来回摆动。如果增加初始速度，比如：10 rad/s，会看到单摆的运动位置会随着往复来回摆动不断增加。

## 半隐式欧拉法

通过数值积分来分析这类模型比较简单，但是积分计算的成本相对较大，尤其是处理较大的模型。如果我们想看到模型的长期动态图，我们可以使用[欧拉法](https://en.wikipedia.org/wiki/Semi-implicit_Euler_method)代替数值积分法来进行模拟。欧拉法也是在 OpenAI 中解决像 [Card-Pole](https://gym.openai.com/envs/CartPole-v1/) 这类控制问题的方法，它能解决强化学习（RL）中的控制问题。

首先需要得到上述常微分方程的[泰勒级数展开式](https://en.wikipedia.org/wiki/Taylor_series)。这种计算方法是一种近似法，因此展开式项越多得出的结果也越准确。考虑到当我们当前的场景，只需要扩展到一阶导数并截去高阶项。

首先，需要注意的是我们需要一个关于 θ(t) 的函数。如果我们将 θ(t) 和 t-t_0 代入到泰勒级数展开式（TSE）中，将得到：

![](https://cdn-images-1.medium.com/max/2000/1*Vq7-kN8luxga9VlEK1tJGg.png)

其中 O(t²) 表示我们的高阶项，可以在不失去太多准确度的情况下将其删除。请注意，这仅遵循泰勒展开式（TSE）通用公式。有了这个方程，我们可以参考上面的常微分方程代换式，即：

![](https://cdn-images-1.medium.com/max/2000/1*Nlr4LpUi78LWH3Cw1nBHTA.png)

借此，可以将泰勒展开式与常微分方程关联起来：

![](https://cdn-images-1.medium.com/max/2000/1*BwSlCyQugIxY_XuSpdFA2A.png)

这样我们就得到了一种更方便的方法，可以在每个时间间隔中更新模型以获取 θ_1(t) 的最新值。重复 θ˙(t) 的展开和替换，可以得到以下结果：

![](https://cdn-images-1.medium.com/max/2000/1*JT45PanYmNHq0-o6brpZnQ.png)

在模拟中遍历的过程中，我们将更新 t_0 作为上一个时间步，并逐步向前移动模型。另外，请注意，这是**半隐式欧拉方法** ,这意味着在我们的第二个方程中，我们使用的是最新的 θ_1(t) 而非 θ_1(t_0) 带入到泰勒展开式（TSE）中。我们做出这种微妙的替代是因为，如果没有它，我们的模型将会发散。本质上，我们使用泰勒展开式（TSE）进行的近似计算有一些误差（还记得，前面提到丢弃了那些高阶项）。在这个应用中，这些错误将新能量引入到了的单摆上 —— 这显然违反了热力学第一定律。进行这种替换可以解决所有这些问题。

```python
def euler_pendulum_sim(theta_init, t, L=1, g=9.81):
    theta1 = [theta_init[0]]
    theta2 = [theta_init[1]]
    dt = t[1] - t[0]
    for i, t_ in enumerate(t[:-1]):
        next_theta1 = theta1[-1] + theta2[-1] * dt
        next_theta2 = theta2[-1] - (b/(m*L**2) * theta2[-1] - g/L *
            np.sin(next_theta1)) * dt
        theta1.append(next_theta1)
        theta2.append(next_theta2)
    return np.stack([theta1, theta2]).T
```

接着运行这个新函数：

```python
theta_vals_euler = euler_pendulum_sim(theta_init, t)
```

![](https://cdn-images-1.medium.com/max/2000/0*0IZ-Dh71fulbtlEn)

绘制的图看起来还不错，让我们看下是否和之前方法一的结果相符合。

```python
mse_pos = np.power(
    theta_vals_int[:,0] - theta_vals_euler[:,0], 2).mean()
mse_vel = np.power(
    theta_vals_int[:,1] - theta_vals_euler[:,1], 2).mean()
print("MSE Position:\t{:.4f}".format(mse_pos))
print("MSE Velocity:\t{:.4f}".format(mse_vel))

MSE Position:	0.0009
MSE Velocity:	0.0000
```

不同方法之间的均方误差非常接近，这说明我们得到了一个很好的近似值。

我们使用了两种不同的方法，分别为常微分方程法和欧拉法，其中欧拉法要比常微分方程法 `odeint` 求解速度快。下面我们来测试并验证一下是否真的速度要快些。

```
%timeit euler_pendulum_sim(theta_init, t)

2.1 ms ± 82.8 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

%timeit integrate.odeint(int_pendulum_sim, theta_init, t)

5.21 ms ± 45.5 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

与常微分方程的数值积分相比，欧拉方法的速度提高了约 2 倍。

通过以上这些，我们学会了如何使用微积分的第一法则建立和模拟动态模型，并将其应用于一个简单的无摩擦单摆系统。

像这样的动力系统对于理解自然科学是非常有用的。我最近用同样的技术写了一篇文章，展示了我们如何模拟[病毒在人群中的爆发性传播](https://towardsdatascience.com/how-quickly-does-an-influenza-epidemic-grow-7e95786115b3) 。常微分方程（ODE）也非常适合于反馈控制以及机器人技术和工程领域的其他相关应用，因此必须掌握基本的数值积分原理!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
