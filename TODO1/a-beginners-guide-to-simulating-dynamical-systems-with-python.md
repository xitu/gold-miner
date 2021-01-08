> * 原文地址：[A Beginner’s Guide to Simulating Dynamical Systems with Python](https://towardsdatascience.com/a-beginners-guide-to-simulating-dynamical-systems-with-python-a29bc27ad9b1)
> * 原文作者：[Christian Hubbs](https://medium.com/@christiandhubbs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginners-guide-to-simulating-dynamical-systems-with-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-beginners-guide-to-simulating-dynamical-systems-with-python.md)
> * 译者：
> * 校对者：

# A Beginner’s Guide to Simulating Dynamical Systems with Python

> Numerically Integrate ODEs in Python

![Photo by [Dan Meyers](https://unsplash.com/@dmey503?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*GZYR2gufn9IzhkSu)

Consider the simple pendulum.

![](https://cdn-images-1.medium.com/max/2048/0*7CYBv0aAMnMcHQr9.png)

We’ve just got a mass of m hanging from a string with length L that is swinging back and forth.

It’s basically as simple of a system as we can work with. Don’t let this simplicity fool you though, it can create some interesting dynamics. We’ll use this as a starting point to introduce some control theory and compare that to continuous control reinforcement learning. Before we get to that, we need to spend some time understanding the dynamics of the system and how to simulate it!

## TL;DR

We derive the dynamics of the mass and pendulum system, and build two separate simulation models using one of Python’s integration packages and using Euler’s Method. This provides a good stepping stone for more complex systems; many joints and systems in robotic control can even be modeled as pendulums that are linked together.

You can also view the [original post here](https://www.datahubbs.com/simulating-dynamical-systems-with-python/) where the equations are formatted much more nicely than Medium allows.

## Dynamics of Swinging

If we want to simulate this system, we need to understand the dynamics. To start, we’ll draw a free-body diagram (FBD) of the simple pendulum where we show the length, mass, gravity, and force vectors acting on the system.

![Free-body diagram of the simple pendulum.](https://cdn-images-1.medium.com/max/2000/0*8vEjw63JJBOSvML0)

Drawing the FBD helps to make all of the forces explicit to ensure we don’t miss anything. Once we have that, we can use Newton’s 2nd Law of Motion to get the dynamics. You’re probably familiar with the F=ma form, but we’ll modify this slightly for [rotational motion](https://brilliant.org/wiki/rotational-form-of-newtons-second-law/) by writing it as:

![](https://cdn-images-1.medium.com/max/2000/1*3xMMMwDVq4IbHx-ku6Z-0g.png)

n this case, τ is the torque about the origin, III is the rotational inertia, and α is the angular acceleration. The torque is given by the perpendicular component of force applied to the mass (the moment about the origin), rotational inertia is just I=mL², and the angular acceleration is the second time derivative of θ. We can plug these values into Newton’s 2nd Law above, and we get:

![](https://cdn-images-1.medium.com/max/2000/1*ZY8xoZWK0WQw6Kr78RlTvQ.png)

For completeness, we can also consider friction on the pendulum, which gives us:

![](https://cdn-images-1.medium.com/max/2000/1*GfLPH68C4RaMzFkjE_y51Q.png)

The first thing to notice, we have a second-order ODE (ordinary differential equation) on our hands by virtue of the second derivative (θ¨) in our equation. We want to reduce this to a first-order system to integrate and simulate it. This comes at a cost of complexity because we will break our single, second-order system into two first-order equations. The cost is relatively minor in this case, but for more complicated models (which we’ll get to in future posts) this can become hairy.

To do this, we need to introduce two new variables, we’ll call them θ_1​ and θ_2​ and define them as:

![](https://cdn-images-1.medium.com/max/2000/1*mnqoP1R59QrU_emUHwK4aw.png)

This helps because we now can say θ˙_2=θ¨ and reduce the order of our equation.

Now, we have:

![](https://cdn-images-1.medium.com/max/2000/1*_lCFpvFSWmxw1zShrZ4eaQ.png)

With our equations set up, let’s turn to the code to model this.

## Simulating the Pendulum Dynamics

Start by importing the relevant libraries.

```python
import numpy as np
from scipy import integrate
import matplotlib.pyplot as plt
```

We need to set some of our values. Let the mass and length be 1 kg and 1 m respectively, and for now at least, we’ll ignore friction by setting b=0. We’ll simulate the pendulum swinging starting from π/2 (raised 90 degrees to the right) and released with no initial velocity. We can simulate this for 10 seconds with a time discretization (Δt) of 0.02 seconds.

```python
# Input constants 
m = 1 # mass (kg)
L = 1 # length (m)
b = 0 # damping value (kg/m^2-s)
g = 9.81 # gravity (m/s^2)
delta_t = 0.02 # time step size (seconds)
t_max = 10 # max sim time (seconds)
theta1_0 = np.pi/2 # initial angle (radians)
theta2_0 = 0 # initial angular velocity (rad/s)
theta_init = (theta1_0, theta2_0)
# Get timesteps
t = np.linspace(0, t_max, t_max/delta_t)
```

We’ll demonstrate two ways to simulate this, first by numerical integration using `scipy`, and then again using Euler’s method.

## Scipy Integration

To integrate using `scipy`, we need to build a function for our model. We’ll call it `int_pendulum_sim` for our integrated simulation. This model will take our initial values for θ_1​ and θ_2​ (labeled `theta_init` above) and integrate for a single time step. It then returns the resulting theta values. The function itself is just going to be two equations for θ˙_1​ and θ˙_2​ that we derived above.

```python
def int_pendulum_sim(theta_init, t, L=1, m=1, b=0, g=9.81):
    theta_dot_1 = theta_init[1]
    theta_dot_2 = -b/m*theta_init[1] - g/L*np.sin(theta_init[0])
    return theta_dot_1, theta_dot_2
```

We can simulate our system by passing our function as an argument to `scipy.integrate.odeint`. In addition, we need to give our initial values and the time to simulate over.

```python
theta_vals_int = integrate.odeint(int_pendulum_sim, theta_init, t)
```

The `odeint` function takes these inputs and integrates our θ˙\dot{\theta}θ˙ values for us, then feeds those results back into the function again as the initial conditions for the next time step. This gets repeated until we’ve integrated over all of the time steps t.

We can plot θ and θ˙ to see how the position and velocity evolve over time.

![](https://cdn-images-1.medium.com/max/2000/0*eYACTeCtD68Nw88v)

We have no friction or other force in our model, so the pendulum is just going to oscillate back and forth indefinitely between −π/2 and π/2. If you increase the initial velocity, to say, 10 rad/s, you’ll see the position continue to increase as the model shows it circling around again and again.

## Semi-Implicit Euler Method

Solving the model via integration is relatively easy, but integration can be very expensive, particularly for larger models. If we want to see the long-term dynamics of the model, we can use [Euler’s Method](https://en.wikipedia.org/wiki/Semi-implicit_Euler_method) to integrate and simulate the system instead. This is how control problems such as Cart-Pole are solved in OpenAI and allows us to set-up problems for RL control.

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
