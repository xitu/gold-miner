> * 原文地址：[Optimal Control: LQR](https://towardsdatascience.com/optimal-control-lqr-417b41e10d0d)
> * 原文作者：[Marin Vlastelica Pogančić](https://medium.com/@marinvp)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimal-control-lqr.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimal-control-lqr.md)
> * 译者：
> * 校对者：

# Optimal Control: LQR

![](https://cdn-images-1.medium.com/max/1600/0*SSB8_Rwp0keZZ7uG.jpg)

> Intuitive ground-up explanation to LQR, a fundamental concept in optimal control.

In this article, I am going to talk about optimal control. More specifically I am going to talk about the unbelievably awesome Linear Quadratic Regulator that is used quite often in the optimal control world and also address some of the similarities between optimal control and the recently hyped reinforcement learning. It is fascinating that they are named differently yet they address similar issues in sequential decision-making processes. That being said, a friendly math warning to readers:

> This article contains some linear algebra and calculus, but don't panic, it is easy-peasy, you can do it.

Now that we got that out of the way, let's start. First of all let us define an optimal control problem in general, or better to say an optimization problem. This merely means that we want to maximize or minimize some function subject to certain constraints on the variables. A typical optimal control problem would look like this:

![](https://cdn-images-1.medium.com/max/1600/1*qs2p-_jNvBDeGMEVqrqK9A.png)

Which is quite straight forward, minimizing a function *f* subject to some constraints (the s.t. is short for subject to). Now, in the optimization world this can be arbitrarily difficult based on how the objective function looks like and the constraints. The constraints can, of course, be equality constraints or inequality constraints based on the problem. Needless to say, non-convex functions in an optimization problem are hard to optimize over, but in the case where we have convex functions we can solve the problem efficiently and fast. Anyway, it is so significant that your reaction to finding convexity in your problem should look like this:

![](https://cdn-images-1.medium.com/max/1600/0*5jrHW-EJDsRPZVBx.jpg)

In control problems, we optimize our trajectories to minimize the cost function or rather maximize the reward as it is done in reinforcement learning. Naturally, the dynamics of the environment, i.e. the function that gives us the next state based on current action and current state, are part of the optimization constraints. So we might write our control optimization problem as follows):

![](https://cdn-images-1.medium.com/max/1600/1*VB-syinim9NPm6EIRIQMPg.png)

This is the case for finite horizon till N. Lets break it down in short. x is our state variable at each time step, *u* is our action. E would be the final cost of the final state, *g* the cost function for each state-action pair. *x* bar is our start state from which we want to optimize and *f* is our dynamics function. In this case we have no inequality constraints. As it turns out, if our function *f* is a linear function of *x* and *u* and the function *g* a quadratic function of *x* and *u*, this makes the problem a lot simpler. This is how we arrive at the Linear Quadratic Regulator problem definition:

![](https://cdn-images-1.medium.com/max/1600/1*FUpZDyx377ChcaYhcrEWvw.png)

Here, Q, R and E are the cost matrices that define our polynomial coefficients. We could also write the cost for each time step in block matrix notation to make the expression simpler:

![](https://cdn-images-1.medium.com/max/1600/1*Q5ZAP09bX_o3BYGONcLE2A.png)

In the upper case we leaved out the S or better to say we assumed that S = 0, but this doesn't change the math greatly, S can also be some kind of matrix for interplay between x and u in the cost function.

We are going to make use of the optimality principle, which states a natural fact, namely that if you have an optimal route between points A and C, if we take a point B on this route then the subroute A to B is also the optimal route from A to B. Completely intuitive fact. Based on this, we can define the optimal cost-to-go, or total cost for our trajectory recursively. This is how we arrive to the Hamilton-Jacobi-Bellman equation:

![](https://cdn-images-1.medium.com/max/1600/1*EQdn0DQS8OXgfV2fDsGclg.png)

Where J star is our optimal cost-to-go. In our case we stated the objective function as a polynomial function, so logically we can assume that our optimal cost-to-go is a polynomial function and we can write it as such:

![](https://cdn-images-1.medium.com/max/1600/1*EsHlDB5SV7fHwLo3wrar1g.png)

And logically our final cost would be the following based on our definition of the optimization problem :

![](https://cdn-images-1.medium.com/max/1600/1*FFc0lDhMgGLrJKxbNQZ14Q.png)

Now, if we plug in our definition of the function g and the environment dynamics into the Bellman equation we arrive at something like this:

![](https://cdn-images-1.medium.com/max/1600/1*eQxRS-3O2UtGF2zzO2tQtQ.png)

Thanks to the quadratic cost assumptions, how do we find the minimum of this function? Well, quite simply we take the gradient with respect to u and equate it to 0, we group all the terms into one big central matrix:

![](https://cdn-images-1.medium.com/max/1600/1*ljoF2k4uIRdP3m3ynFABsA.png)

In order to save space we substitute the terms with the following matrices (this is self-explanatory):

![](https://cdn-images-1.medium.com/max/1600/1*QpN6Lh63BxMjgJeYYdxwCQ.png)

After multiplying everything out and looking only at the terms containing *u*, because we want to take the derivative with respect to *u*, we arrive at the following intermediate result:

![](https://cdn-images-1.medium.com/max/1600/1*ALpr9ExoUMQBPNi8gFCqDQ.png)

After calculating the gradient and rearranging, we get the expression for u star that minimizes the cost, the optimal action:

![](https://cdn-images-1.medium.com/max/1600/1*5SCURUpNJuumckGwzyVnDA.png)

Maybe meditate on this a bit for a minute. What does this mean? Well, it means that we have a closed-form solution to the optimal action! This is pretty neat. So what do we need to solve this? We need the matrix P for time step k+1. This we can calculate based on the following equation, recursively from the last time step:

![](https://cdn-images-1.medium.com/max/1600/1*EkgXYabMf3QEFgH_-Ecdqw.png)

This is also known widely as the algebraic Riccati equation. In the case where we want a fixed point solution, for infinite horizon, the equation can be solved for a fixed P. In that case, we don't even need a recursion. We just get the optimal-feedback control for free.

That would be all to it basically. You have to appreciate the power of the LQR. Of course, many problems can't be simplified to linear dynamics, but it is amazing what kind of solution do we get if we make the simplification. This approach is even used in situations where our dynamics that are not linear by linearizing them around fixed points through Taylor expansion. This is an approach that is regularly used in trajectory optimization for complex problems and is called Differential Dynamic Programming (DDP), an instance of which is iLQR (iterative LQR), go figure.

Now that you obtained some LQR-fu, you have obtained the tool to understand many things in optimal control.

![](https://cdn-images-1.medium.com/max/1600/0*4eOi4xHOUcdbeUVK.png)

I hope that this explanation of LQR opened some eyes. It is a very simple yet powerful concept and a building block for many optimal control algorithms!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
