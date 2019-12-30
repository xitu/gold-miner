> * 原文地址：[数学编程 —— 为个人在数据科学领域所有进步而培养的一个关键习惯](https://towardsdatascience.com/mathematical-programming-a-key-habit-to-built-up-for-advancing-in-data-science-c6d5c29533be)
> * 原文作者：[Tirthajyoti Sarkar](https://medium.com/@tirthajyoti)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mathematical-programming-a-key-habit-to-built-up-for-advancing-in-data-science.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mathematical-programming-a-key-habit-to-built-up-for-advancing-in-data-science.md)
> * 译者：[Weirdochr](https://github.com/Weirdochr)
> * 校对者：[TokenJan](https://github.com/TokenJan)、[mymmon](https://github.com/mymmon)

# 数学编程 —— 为个人在数据科学领域有所进步而培养的一个关键习惯

> 我们通过模拟随机向飞镖靶投掷飞镖，向大家展示了如何近似计算圆周率的值。这是朝建立数学编程习惯迈出的一小步，数学编程应是初露头角的数据科学家所有傍身之技中的一项关键技能。

![](https://cdn-images-1.medium.com/max/2000/1*2vPOgrtPqR75SVvCN-lCqQ.jpeg)

## 备注

该 [事迹](https://www.kdnuggets.com/2019/05/mathematical-programming-key-habit-advancing-data-science.html) 被认作是 KDnuggets 平台上最受关注的“金徽章（Gold badge）”之一。

![](https://cdn-images-1.medium.com/max/2000/1*l3ebKpvvkO8JbAp9l2TZLQ.png)

## 简介

**数学编程**的本质在于养成将数学概念编码的习惯，尤其是编码那些以系统性方式涉及的一系列计算任务。

**这种编程习惯对分析和数据科学的职业生涯大有裨益**，从事该类职业的人日常会遇到并需要弄懂各种各样的数值模式。数学编程的能力有助于其快速建立模型以便快速进行数值分析，这通常是建立数据模型的第一步。

## 一些范例

那么，我所说的数学编程究竟是什么？一堆数学函数不是已经内嵌在了许多像 [NumPy](https://towardsdatascience.com/lets-talk-about-numpy-for-datascience-beginners-b8088722309f) 和 [SciPy](https://scipy-lectures.org/intro/language/python_language.html) 这样的 Python 库中并进行过优化了吗？ 

千真万确，但这不应该阻止你从头开始编写各种数值计算任务，并养成数学编程的习惯。

以下是几个随机示例：

* 通过 [蒙特卡洛实验](https://www.palisade.com/risk/monte_carlo_simulation.asp) 计算圆周率 — 该实验模拟了随机向飞镖靶投掷飞镖
* 构建一个包含处理复数所有方法的函数或类（Python 已有这样一个模块，但你能模仿出来一个吗？）
* 通过模拟多种经济场景，考虑每只股票的差异，计算 [一组投资组合的平均回报率](https://www.quantinsti.com/blog/portfolio-optimization-maximum-return-risk-ratio-python)
* [模拟并绘制随机漫步事件](https://www.geeksforgeeks.org/random-walk-implementation-python/)
* 模拟 [两球碰撞，并根据随机的起点和方向计算它们的轨迹](https://github.com/yoyoberenguer/2DElasticCollision)

如你所见，我们可以举出很多有趣并且接近真实生活场景的例子。因此，这项技能也能培养为离散或随机模拟编写代码的能力。

> 你在网上浏览一些数学性质或概念时，有没产生过一种冲动，用你最喜欢的编程语言和一段简单的代码快速测试这个概念？

如果你的回答是“是”，那么恭喜你！你有本身就具备深厚的数学编程习惯，它将带领着你在你理想的数据科学事业中走得更远。

## 为什么数学编程是数据科学的关键技能？

数据科学实践需要在数字和数值分析之间建立起良好的关联。然而，这并不意味着仅是记住复杂的公式和方程式。

对于一个初露头角的数据科学家来说，发现数字模式的能力和通过编写简单代码快速测试想法的能力大有裨益。

![](https://cdn-images-1.medium.com/max/2000/1*A7cfUN2CqZ7OAGq1rm5o5Q.jpeg)

类似于电子工程师直接操作实验室设备和自动化脚本来运行这些设备以捕捉电信号中隐藏的模式。

你也可以想象一位年轻的生物学家，她擅长在载玻片上制作细胞横截面样本，并在显微镜下快速执行自动化测试，以收集数据来测试她的想法。

![](https://cdn-images-1.medium.com/max/2000/1*yyF5NFMCxn9oBJQjpdJEFg.jpeg)

> 关键在于，尽管整个数据科学大厦可能由许多不同的部分组成，如：数据整理、文本处理、文件处理、数据库处理、机器学习和统计建模、可视化、演示等，快速试验想法通常只需要扎实的数学编程能力。

我们很难列举出培养数学编程技能的所有必备要素，但可以给出一些常见要素：

* 模块化编程的习惯
* 关于各种**随机化技术**的清晰想法
* 能够阅读和理解**线性代数、微积分和离散数学**的基本课题
* 熟悉基础的**描述性和推断性统计**
* 具备**离散和连续优化方法**（如：线性规划）的基础概念
* 基本熟练掌握一门偏好的语言的核心**数字库和函数**，并用这门语言测试自己的想法

以下文章讨论了在数据科学基础动手数学实践中应该学些什么，仅供参考：[**数据科学中的基础数学**
**为成为更优秀的数据科学家而掌握的关键主题** towardsdatascience.com](https://towardsdatascience.com/essential-math-for-data-science-why-and-how-e88271367fbd)

本文通过一个非常简单的例子来说明数学编程，即用 [蒙特卡洛方法](https://www.palisade.com/risk/monte_carlo_simulation.asp) 随机向飞镖靶投掷飞镖，来计算圆周率的近似值。

## 投掷（大量）飞镖计算圆周率

这个方法很有意思，它通过模拟向飞镖靶随机投掷飞镖的过程来计算圆周率的值。该方法没有使用任何复杂的数学分析方法或计算公式，而是试图通过模拟纯粹的物理（但 [**随机**](https://en.wikipedia.org/wiki/Stochastic_process)）过程，来计算圆周率的近似值。

> 我们将这种方法命名为**蒙特卡洛方法**，其基本概念是模拟随机过程，当重复多次后，就能得到一些让人感兴趣的数学数量近似值。

请想象此刻在你面前有一个方形镖靶。

镖靶内画了一个圆，该圆内切于镖靶四边。

接着，向镖靶投掷飞镖。记住是**随机**投掷。这意味着，飞镖可能在圆内，也可能在圆外。但此处假设没有飞镖落在镖靶外。

![](https://cdn-images-1.medium.com/max/3020/1*yNBSxo8jPxbvzifAG9jWNg.png)

飞镖投掷训练结束后，计算飞镖落在圆圈内的次数占投掷总数的比列。再把该数字乘以 4。

计算结果应该是圆周率的值。投掷次数越多，计算结果越接近圆周率。

#### 关于该实验的原理

这个想法非常简单。如果你投掷了大量飞镖，那么**飞镖落入圆内的概率就是圆与方形镖靶面积之比**。借助基础数学，你就能计算出这个比率是 π/4。因此，要得到圆周率，只需把该数字乘以 4。

该实验的关键在于，模拟投掷大量飞镖，以便**让（落入圆圈内的飞镖）这一分数等于概率，该结果仅在大量随机实验条件下成立**。这是大数定律或者说是频率派概率的结果。

#### Python 代码

我在自己的 [Github 仓库的 Jupyter notebook](https://github.com/tirthajyoti/Stats-Maths-with-Python/blob/master/Computing_pi_throwing_dart.ipynb) 里给出了这一段 Python 代码。请随意复制或 fork。步骤很简单。

首先，创建一个函数来模拟随机投掷飞镖。

```Python
def throw_dart():
    """
    Simulates the randon throw of a dart. It can land anywhere in the square (uniformly randomly)
    """
    # Center point
    x,y = 0,0
    # Side of the square
    a = 2
    
    # Random final landing position of the dart between -a/2 and +a/2 around the center point
    position_x = x+a/2*(-1+2*random.random())
    position_y = y+a/2*(-1+2*random.random())
    
    return (position_x,position_y)
```

然后编写一个函数，给定飞镖的着陆坐标，确定飞镖是否落在圆圈内，

```Python
def is_within_circle(x,y):
    """
    Given the landing coordinate of a dart, determines if it fell inside the circle
    """
    # Side of the square
    a = 2
    
    distance_from_center = sqrt(x**2+y**2)
    
    if distance_from_center < a/2:
        return True
    else:
        return False
```

最后，编写一个函数来模拟大量投掷飞镖，并根据累积结果计算圆周率的值。

```Python
def compute_pi_throwing_dart(n_throws):
    """
    Computes pi by throwing a bunch of darts at the square
    """
    n_throws = n_throws
    count_inside_circle=0
    for i in range(n_throws):
        r1,r2=throw_dart()
        if is_within_circle(r1,r2):
            count_inside_circle+=1
            
    result = 4*(count_inside_circle/n_throws)
    
    return result
```

本段代码结束了，但是编程不能就此止步。我们必须测试近似值能在多大程度上接近，以及它如何随着随机投掷次数的增多而变化。**与所有蒙特卡洛实验一样，随着实验次数增加，近似值会越来越接近**。

> 这就是数据科学和分析的核心。仅仅编写一个打印预期输出并在那里停止的函数是不够的。基础的编程可以结束，但如果没有进一步的探索和假设检验，科学实验就不能就此停止。

![](https://cdn-images-1.medium.com/max/2000/1*oWOdAKqNc4rFapMNY04YYw.png)

![](https://cdn-images-1.medium.com/max/2000/1*UfMdUzCOZEYQhnqn3woEDA.png)

我们可以看到，重复几次大量随机投掷实验来计算平均值能得到更精确的近似值。

```Python
n = 5000000
sum=0
for i in range(20):
    p=compute_pi_throwing_dart(n)
    sum+=p
    print("Experiment number {} done. Computed value: {}".format(i+1,p))
print("-"*75)
pi_computed = round(sum/20,4)
print("Average value from 20 experiments:",pi_computed)
```

## 代码看似简单，内核却极为丰富

这项实验背后的理论和代码看似极其简单。然而，在这个简单练习的外表之下，隐藏着一些非常有趣的想法。

**函数式编程方法**：用整块代码对实验进行编码，描述整个实验。在这个过程中，我们展示了如何将多个任务划分为简单的函数，来模拟真实人类的行为 ——

* 扔飞镖，
* 检查飞镖的着陆坐标并确定它是否落在圆圈内，
* 重复该过程任意次数

为大型程序编写高质量代码时，使用这种 [**模块化编程**](https://www.geeksforgeeks.org/modular-approach-in-programming/) 方法是非常具有指导意义的。

**突现行为**：这段代码没有使用任何涉及圆周率或圆的性质的公式。圆周率的值是从随机向飞镖靶扔一堆飞镖并计算分数的过程中得到的。这是 [**突现行为**](http://wiki.c2.com/?EmergentBehavior) 的一个示例，即**通过相互作用，大量类似的重复实验形成一种数学模式。**

**频率派概率定义**：对概率的定义有两大类，这两类分属于截然对立的阵营 — [频率派和贝叶斯派](https://stats.stackexchange.com/questions/31867/bayesian-vs-frequentist-interpretations-of-probability)。人们很容易以频率派的思维方式思考，把概率定义为一个事件的频率（随机试验总数的一部分）。在这次编程练习中，我们可以看到，概率这个特殊概念是如何从多次重复随机试验中显现出来的。

**[随机模拟](https://www.andata.at/en/stochastic-simulation.htmlhttps://www.andata.at/en/stochastic-simulation.html)**：掷飞镖实验使用的核心函数是一个随机数发生器。实际上，计算机生成的随机数并非真正随机，但出于实际操作可行性考虑，我们可以假定它生成的都是随机数。在这次编程练习中，我们使用了 Python `随机` 模块中的统一随机生成器函数。使用这种随机化方法是随机模拟的核心，这是数据科学实践中一种有效的方法。

**通过重复模拟和可视化测试断言**：通常，在数据科学中，我们必须通过大量模拟/实验，来测试随机过程和概率模型。因此，必须用这些渐进项来思考，并以统计上合理的方式来测试数据模型或科学断言的有效性。

![](https://cdn-images-1.medium.com/max/2000/1*cbGe3j6lfP_9REbnLlaXQw.jpeg)

## 总结（以及对读者的挑战）

我们展现了培养数学编程习惯的意义。本质上，它是从编程的角度来测试你头脑中正在开发的数学方法或数据模式。这个简单的习惯可以帮助未来的数据科学家开发优质的实践。

我们使用简单的几何恒等式、随机模拟的概念和频率派概率定义演示了一个例子。

如果你还想接受更多挑战，

> 你能通过模拟 [随机漫步事件](https://en.wikipedia.org/wiki/Random_walk) 来计算圆周率吗？

---

点击此处 fork 这个简单练习的代码 [**请 fork 这个 repo**](https://github.com/tirthajyoti/Stats-Maths-with-Python)。

---

若你有任何问题或想法想要分享，请联系作者 [**tirthajyoti[AT]gmail.com**](mailto:tirthajyoti@gmail.com)。另外，你也可以查看作者的 **[GitHub ](https://github.com/tirthajyoti?tab=repositories)仓库** 获取 Python、R 或 MATLAB 中其他有趣的代码片段和机器学习资源。如果你像我一样，对机器学习/数据科学充满热情，请 [添加我的领英](https://www.linkedin.com/in/tirthajyoti-sarkar-2127aa7/) 或者 [关注我的推特账号](https://twitter.com/tirthajyotiS)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
