> * 原文地址：[A Beginner’s Guide to Simulating Dynamical Systems with Python](https://towardsdatascience.com/a-beginners-guide-to-simulating-dynamical-systems-with-python-a29bc27ad9b1)
> * 原文作者：[Christian Hubbs](https://medium.com/@christiandhubbs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginners-guide-to-simulating-dynamical-systems-with-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginners-guide-to-simulating-dynamical-systems-with-python.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)
> * 校对者：

# Python 模拟动力系统的初学者指南

> Numerically Integrate ODEs in Python

![图由 [Dan Meyers](https://unsplash.com/@dmey503?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*GZYR2gufn9IzhkSu)

回想一下以下单摆模型。

![](https://cdn-images-1.medium.com/max/2048/0*7CYBv0aAMnMcHQr9.png)

一根长度为 L 的绳子下方悬挂一个质量为 m 的重物，来回往复摆动。

这是非常简单的系统足够我们上手实践，但是也不能被其表象上的简易程度所蒙蔽，因为这套系统可以创建一个有趣的动力系统。我们将以此为起点来介绍一些基本的控制理论以及对比学习更深入的连续控制理论。在此之前，我们有必要先花点时间了解下单摆的运动模型以及如何对其进行运动仿真。

## 全文总结

我们推导出了单摆系统的动力学模型，并且分别使用 Python 的集成包和欧拉法创建了两个仿真模型。机器控制系统中的许多关节和系统都可以采用单摆进行建模，因此这里的仿真模型可以作为分析复杂系统的垫脚石。

原文对文章的公式显示更友好，你可以[点击这里](https://www.datahubbs.com/simulating-dynamical-systems-with-python/)阅读。

## 摇摆动力学

若要对单摆系统进行仿真，则首先需要理解摇摆动力学。首先，我们画出单摆系统的受力分析图。其中摆绳的长度、小球的质量、重力及力的方向如下图所示。

![Free-body diagram of the simple pendulum.](https://cdn-images-1.medium.com/max/2000/0*8vEjw63JJBOSvML0)

Drawing the FBD helps to make all of the forces explicit to ensure we don’t miss anything. Once we have that, we can use Newton’s 2nd Law of Motion to get the dynamics. You’re probably familiar with the F=ma form, but we’ll modify this slightly for [rotational motion](https://brilliant.org/wiki/rotational-form-of-newtons-second-law/) by writing it as:
绘制受力分析图有助于明确所有力，以确保我们不会有所遗漏。接下来就可以使用牛顿第二运动定律来分析其动力学。牛顿第二运动定律的形式为 `F = ma`，我们使用其变体——[转动定律](https://brilliant.org/wiki/rotational-form-of-newtons-second-law/)表达如下:

![](https://cdn-images-1.medium.com/max/2000/1*3xMMMwDVq4IbHx-ku6Z-0g.png)

在这种情况下，τ 是关于原点的扭矩，III 是旋转惯性，α 是角加速度。扭矩由施加在质量上的力的垂直分量 (关于原点的力矩) 给出，旋转惯性仅为 `I = mL²`，角加速度是 θ 的二阶导数。我们可以将这些值代入到上面的牛顿第二定律，可以得到:

![](https://cdn-images-1.medium.com/max/2000/1*ZY8xoZWK0WQw6Kr78RlTvQ.png)

为了完整性，我们还可以考虑钟摆上的摩擦，这样就得到:

![](https://cdn-images-1.medium.com/max/2000/1*GfLPH68C4RaMzFkjE_y51Q.png)

首先要注意的是，由于方程中存在二阶导数 (θ)，所以这是一个二阶常微分方程（ODE）。我们希望能将其简化为一阶系统以便对其进行集成和模拟。基于复杂性代价的考虑，我们将单二阶系统分解成两个一阶方程。在我们现在分析的这种情况下，复杂度的成本并不大，但是对于更复杂的模型，这样处理可能会适得其反。

为此，我们需要引入两个新变量，分别命名为 θ_1 和 θ_2，并将它们定义为:

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

需要先定义一些常量，让质量和长度分别为 1kg 和 1m，至少现在，当前先暂且忽略摩擦，假设 b=0 。我们将模拟单摆从 π/2 (向右升高90度) 的位置开始摆动，并在没有初始速度的情况下释放。我们可以用 0.02s 作为间隔（Δt）来离散化 10s 的时间段。

```python
# 定义常量
m = 1 # mass (kg)
L = 1 # length (m)
b = 0 # damping value (kg/m^2-s)
g = 9.81 # gravity (m/s^2)
delta_t = 0.02 # time step size (seconds)
t_max = 10 # max sim time (seconds)
theta1_0 = np.pi/2 # initial angle (radians)
theta2_0 = 0 # initial angular velocity (rad/s)
theta_init = (theta1_0, theta2_0)
# 时间序列
t = np.linspace(0, t_max, t_max/delta_t)
```

我们将演示两种模拟方法，首先使用 `scipy` 库进行数值积分，然后再次使用欧拉方法。

## Scipy 数值积分

使用 scipy 进行数值积分方法，我们需要为模型构建一个积分函数，称为 `int_pendulum_sim`。该模型将采用 θ_1 和 θ_2 的初始值 (代码中记为 `theta_init`) 对时间间隔（Δt）进行积分，然后返回对应的 theta 值。这个函数正好就是我们上面推导出的 θ˙_ 1 和 θ˙_ 2 的两个方程。

```python
def int_pendulum_sim(theta_init, t, L=1, m=1, b=0, g=9.81):
    theta_dot_1 = theta_init[1]
    theta_dot_2 = -b/m*theta_init[1] - g/L*np.sin(theta_init[0])
    return theta_dot_1, theta_dot_2
```

我们可以通过上述将函数作为参数传递给 `scipy.integrate.odeint`。并且，还需要给出初始值和模拟时长。

```python
theta_vals_int = integrate.odeint(int_pendulum_sim, theta_init, t)
```

`odeint` 函数将传入的参数与 θ˙ 进行积分运算，计算结果又作为初始值传入该函数自身以进行下一个时间间隔（Δt）的迭代运算，如此递归直至所有时间间隔集合被遍历完成。

θ 和 θ˙ 随时间变化可以绘制成如下图。

![](https://cdn-images-1.medium.com/max/2000/0*eYACTeCtD68Nw88v)

We have no friction or other force in our model, so the pendulum is just going to oscillate back and forth indefinitely between −π/2 and π/2. If you increase the initial velocity, to say, 10 rad/s, you’ll see the position continue to increase as the model shows it circling around again and again.
我们的模型中是没有考虑摩擦力或其他力的，所以钟摆只会在 -π/2 和 π/2 之间往复地来回摆动。如果你增加初始速度，比如：10rad/s，会看到单摆的运动位置会随着往复来回摆动不断增加。

## 半隐式欧拉法

Solving the model via integration is relatively easy, but integration can be very expensive, particularly for larger models. If we want to see the long-term dynamics of the model, we can use [欧拉法](https://en.wikipedia.org/wiki/Semi-implicit_Euler_method) to integrate and simulate the system instead. This is how control problems such as Cart-Pole are solved in OpenAI and allows us to set-up problems for RL control.

To do this, we need to get the [Taylor Series Expansion](https://en.wikipedia.org/wiki/Taylor_series) (TSE) of our ODE’s. The TSE is just a way to approximate a function. You get more accurate the more you expand the series. For our purposes, we’re only going to expand to the first derivative and truncate the higher order terms.

First, note we need a function for θ(t). If we apply the TSE to θ(t) about t-t_0​, we get:

![](https://cdn-images-1.medium.com/max/2000/1*Vq7-kN8luxga9VlEK1tJGg.png)

Where O(t²) simply represents our higher order terms, which can be dropped without losing much fidelity. Note that this just follows from the general formula for the TSE. With this equation, we can then refer back to our ODE substitutions above, namely:

![](https://cdn-images-1.medium.com/max/2000/1*Nlr4LpUi78LWH3Cw1nBHTA.png)

With this, we can link the TSE with our ODE’s such that:

![](https://cdn-images-1.medium.com/max/2000/1*BwSlCyQugIxY_XuSpdFA2A.png)

This gives us a convenient way to update our model at each time step to get the new value for θ_1​(t). We can repeat the expansion and substitution for θ˙(t) to get the following:

![](https://cdn-images-1.medium.com/max/2000/1*JT45PanYmNHq0-o6brpZnQ.png)

As we loop through these in our simulation, we’ll update t0t_0t0​ to be the previous time step, so we’ll be incrementally moving the model forward. Also, note that this is the **semi-implicit Euler method**, meaning that in our second equation, we’re using the most recent θ_1​(t) that we calculated rather than θ_1​(t_0​) as a straight application of the Taylor Series Expansion would warrant. We make this subtle substitution because, without it, our model would diverge. Essentially, the approximation we make using TSE has some error in it (remember, we threw away those higher order terms) and this error compounds. In this application, the error introduces new energy into our pendulum — something clearly in violation of the first law of thermodynamics. Making this substitution fixes all of that.

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

Now running this new function:

```python
theta_vals_euler = euler_pendulum_sim(theta_init, t)
```

![](https://cdn-images-1.medium.com/max/2000/0*0IZ-Dh71fulbtlEn)

The plot looks good, so let’s see if it matches our previous results.

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

The mean-squared error between the different methods are incredibly close, meaning we’ve got a pretty good approximation.

We did this using two different methods because I said it’s faster to apply the Euler method than to solve via integration with `odeint`. Rather than take my word for it, let’s test that claim.

```
%timeit euler_pendulum_sim(theta_init, t)

2.1 ms ± 82.8 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)

%timeit integrate.odeint(int_pendulum_sim, theta_init, t)

5.21 ms ± 45.5 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

And the Euler method comes out on top with a ~2X speed up vs. the integration approach.

With that, we learned how to build and simulate a dynamic model from first principles and apply it to a simple, frictionless pendulum.

Dynamical systems like this are incredibly powerful for understanding nature. I recently wrote a post using these same techniques which show how we can simulate the [spread of a virus outbreak through a population](https://towardsdatascience.com/how-quickly-does-an-influenza-epidemic-grow-7e95786115b3). ODE’s are also great for feedback control and other relevant applications in robotics and engineering, so getting a handle on basic numeric integration is a must!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
