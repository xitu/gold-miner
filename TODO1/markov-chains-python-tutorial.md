> * 原文地址：[Markov Chains in Python: Beginner Tutorial](https://www.datacamp.com/community/tutorials/markov-chains-python-tutorial)
> * 原文作者：[Sejal Jaiswal](https://www.datacamp.com/profile/cjsejal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/markov-chains-python-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/markov-chains-python-tutorial.md)
> * 译者：[cdpath](https://github.com/cdpath)
> * 校对者：

# 用 Python 实现马尔可夫链的初学者教程

## 学习马尔可夫链及其性质，了解转移矩阵，并用 Python 动手实现！

马尔可夫链是通常用一组随机变量定义的数学系统，可以根据具体的概率规则进行状态转移。转移的集合满足**马尔可夫性质**，也就是说，转移到任一特定状态的概率只取决于当前状态和所用时间，而与其之前的状态序列无关。马尔可夫链的这个独特性质就是**无记忆性**。

跟随本教程学会使用马尔可夫链，你就会懂得离散时间马尔可夫链是什么。你还会学习构建（离散时间）马尔可夫链模型所需的组件及其常见特性。接着学习用 Python 及其 `numpy` 和 `random` 库来实现一个简单的模型。还要学习用多种方式来表示马尔可夫链，比如状态图和转移矩阵。

想用 Python 处理更多统计题目？了解一下 DataCamp 的 [Python 统计学思维课程](https://www.datacamp.com/courses/statistical-thinking-in-python-part-1)！

开始吧……

## 为什么要用马尔可夫链？

马尔可夫链在数学中有广泛使用。同时也在经济学，博弈论，通信原理，遗传学和金融学领域有广泛应用。通常出现在统计学，尤其是贝叶斯统计，和信息论上下文中。在现实中，马尔可夫链为研究机动车辆的巡航定速系统，抵达机场的乘客的排队序列，货币汇率等问题提供了解决思路。最早由 Google 搜索引擎提出的 PageRank 就是基于马尔可夫过程的算法。Reddit 有个叫子版块模拟器的子版块，帖子和评论全部用马尔可夫链自动生成生成，厉害吧！

## 马尔可夫链

马尔可夫链是具有马尔可夫性质的随机过程。随机过程或者说具有随机性质是指由一组随机变量定义的数学对象。马尔可夫链要么有离散状态空间（一组随机变量的可能值的集合）要么有离散索引集合（通常表示时间），鉴于此，马尔可夫链有众多变种。而通常所说的「马尔可夫链」是指具有离散时间集合的过程，也就是离散时间马尔可夫链（DTMC）。

## 离散时间马尔可夫链

离散时间马尔可夫链所包含的系统的每一步都处于某个状态，步骤之间的状态随机变化。这些步骤常被比作时间的各个瞬间（不过你也可以想成物理距离或者随便什么离散度量）。离散时间马尔可夫链是随机变量 X1，X2，X3 … 的序列，不过要满足马尔可夫性质，所以转移到协议状态的概率只和现在的状态有关，与之前的状态无关。用概率数学公式表示如下：

Pr( Xn+1 = x | X1 = x1, X2 = x2, …, Xn = xn) = Pr( Xn+1 = x | Xn = xn)

可见 Xn+1 的概率只和之前的 Xn 的概率有关。所以只需要知道上一个状态就可以确定现在状态的概率分布，符合条件独立（也就是说：只需要知道现在状态就可以确定下一个状态）。

Xi 的可能取值构成的可数集合 S 称为马尔可夫链**状态空间**。状态空间可以是任何东西：字母，数字，篮球比分或者天气情况。虽说时间参数通常是离散的，离散时间马尔可夫链的状态空间却没有什么广泛采用的约束条件，还不如参考任意状态空间下的过程。不过许多马尔可夫链的应用都用到了统计分析更简单的有限或可数无穷状态空间。

## 模型

马尔可夫链用概率自动机表示（相信我它没有听上去那么复杂！）。系统状态的改变叫做转移。各个状态改变的概率叫做转移概率。概率自动机包括从已知转移到转移方程的概率，将其转换为转移矩阵。

还可以将马尔可夫链看作有向图，其中图 n 的边标注的是 n 时刻状态转移到 n+1 时刻状态的概率，Pr(Xn+1 = x | Xn = xn)。这个式子可以读做，从已知状态 Xn 转移到状态 Xn+1 的概率。这个概念也可以用从时刻 n 到时刻 n+1 的**转移矩阵**来表示。状态空间的每个状态第一次出现是作为转移矩阵的行，第二次是列。矩阵的每个元素都表示从这一行表示的状态转移到列状态的概率。

如果马尔可夫链有 N 种状态，转移矩阵就是 N x N 维，其中 (I, J) 表示从状态 I 转移到状态 J 的概率。此外，转移矩阵一定是概率矩阵，也就是每一行元素之和一定是 1。为什么？因为每一行表示自身的概率分布。

所以模型的主要特征包括：状态空间，描述了特定转移发生的概率的转移矩阵以及由初始分布给出的状态空间的初始状态。

好像很复杂？

我们来看一个简单的例子帮助理解这些概念：

如果 Cj 难得心情不好，她会跑步，或者大吃特吃冰淇淋（译者注：原文 gooble 应为 gobble），要么打个盹儿来调整。

根据以往数据，如果她睡了一觉调整心情，第二天她有 60% 的可能去跑步，20% 的可能继续待在床上，还有 20% 的可能吃一大份冰淇淋。

如果她跑步散心，第二天她有 60% 的可能接着跑步，30% 的可能吃冰淇淋，只有 10% 的可能会去睡觉。

最后，如果她难过时纵情冰淇淋，第二天只有 10% 的可能性继续吃冰淇淋，有 70% 的可能性跑步，还有 20% 的可能性睡觉。

![](http://res.cloudinary.com/dyd911kmh/image/upload/f_auto,q_auto:best/v1523011817/state_diagram_pfkfld.png)

上面由状态图表示的马尔可夫链有 3 个可能状态：睡觉，跑步和冰淇淋。所以转移矩阵是 3 x 3 矩阵。注意，离开某一状态的箭头的值的和一定是 1，这跟状态矩阵每一行元素之和是 1 一样，都表示概率的分布。转移矩阵中每个元素的含义跟状态图的每个状态类似。

![](http://res.cloudinary.com/dyd911kmh/image/upload/f_auto,q_auto:best/v1523011817/transition_matrix_gj27nq.png)

这个例子应该会帮助你理解与马尔可夫链有关的几个不同概念。不过在现实世界中如何应用这一理论呢？

借助这个例子，你应该能够回答这种问题：「从睡觉状态开始，2 天后 Cj 最后选择跑步（跑步状态）的概率是多少？」

我们一起算一下。要从睡觉状态移动到跑步状态，Cj 有如下选择：第一天继续睡觉，第二天跑步（0.2 ⋅ 0.6）；第一天换成跑步，第二天继续跑步（0.6 ⋅ 0.6）；第一天去吃冰淇淋，第二天换成跑步（0.2 ⋅ 0.7）。算下来概率是：((0.2 ⋅ 0.6) + (0.6 ⋅ 0.6) + (0.2 ⋅ 0.7)) = 0.62。所以说，从睡觉状态开始，2天后 Cj 处于跑步状态的概率是 62%。

希望这个例子可以告诉你马尔可夫链网络都可以解决哪些问题。

同时，还可以更好地理解马尔可夫链的几个重要性质：

* 可还原性：如果一个马尔可夫链可以从任何状态转移至任何状态，那么它就是不可还原的。换句话说，如果任两个状态之间存在一系列步骤的概率为正，就是不可还原的。
* 周期性：如果马尔可夫链只有在大于 1 的某个整数的倍数时返回某状态，那么马尔可夫链的状态是周期性的。因此，从状态「i」开始，只有经过整数倍个周期「k」才能回到「i」，k 是所有满足条件的整数的最大值。如果 k = 1 状态「i」不是周期性的，如果 k \> 1，「i」才是周期性的。
* 瞬态性和重现性：如果从状态「i」开始，无法回到状态「i」的可能性非零，那么状态「i」有瞬态性。如果状态「i」不具有瞬态性，就称其具有重现性（或者说持续性）。如果某状态可以在有限步内重现，该状态具有正重现性，否则没有重现性。
* 遍历性：状态「i」如果满足非周期性和正重现性，它就有遍历性。如果不具有可还原性的马尔可夫链的每个状态都有遍历性，那么这个马尔可夫链也具有遍历性。
* 吸收态：如果无法从状态「i」转移到其他状态，「i」处于吸收态。因此，如果 当 i ≠ j 时，pii = 1 且 pij = 0，状态「i」处于吸收态。如果马尔可夫链的每个状态都可以达到吸收态，称其为具有吸收态的马尔可夫链。

**窍门**：可以看看[这个网站](http://setosa.io/ev/markov-chains/)给出的马尔可夫链的可视化解释。

## 用 Python 实现马尔可夫链

我们用 Python 来实现一下上面这个例子。当然实际使用的库实现的马尔可夫链的效率会高得多，这里还是给出实例代码帮助你入门……

先 import 用到的库。

``` python
import numpy as np
import random as rm
```

然后定义状态及其概率，也就是转移矩阵。要记得，因为有三个状态，矩阵是 3 X 3 维的。此外还要定义转移路径，也可以用矩阵表示。

``` python
# 状态空间
states = ["Sleep","Icecream","Run"]

# 可能的事件序列
transitionName = [["SS","SR","SI"],["RS","RR","RI"],["IS","IR","II"]]

# 概率矩阵（转移矩阵）
transitionMatrix = [[0.2,0.6,0.2],[0.1,0.6,0.3],[0.2,0.7,0.1]]
```

别忘了，要保证概率之和是 1。另外在写代码时多打印一些错误信息没什么不好的！

``` python
if sum(transitionMatrix[0])+sum(transitionMatrix[1])+sum(transitionMatrix[1]) != 3:
    print("Somewhere, something went wrong. Transition matrix, perhaps?")
else: print("All is gonna be okay, you should move on!! ;)")
```

``` 
All is gonna be okay, you should move on!! ;)
```

现在就要进入正题了。我们要用 `numpy.random.choice` 从可能的转移集合选出随机样本。代码中大部分参数的含义从参数名就能看出来，不过参数 `p` 可能比较费解。它是可选参数，可以传入样品集的概率分布，这里传入的是转移矩阵。

``` python
# 实现了可以预测状态的马尔可夫模型的函数。
def activity_forecast(days):
    # 选择初始状态
    activityToday = "Sleep"
    print("Start state: " + activityToday)
    # 应该记录选择的状态序列。这里现在只有初始状态。
    activityList = [activityToday]
    i = 0
    # 计算 activityList 的概率
    prob = 1
    while i != days:
        if activityToday == "Sleep":
            change = np.random.choice(transitionName[0],replace=True,p=transitionMatrix[0])
            if change == "SS":
                prob = prob * 0.2
                activityList.append("Sleep")
                pass
            elif change == "SR":
                prob = prob * 0.6
                activityToday = "Run"
                activityList.append("Run")
            else:
                prob = prob * 0.2
                activityToday = "Icecream"
                activityList.append("Icecream")
        elif activityToday == "Run":
            change = np.random.choice(transitionName[1],replace=True,p=transitionMatrix[1])
            if change == "RR":
                prob = prob * 0.5
                activityList.append("Run")
                pass
            elif change == "RS":
                prob = prob * 0.2
                activityToday = "Sleep"
                activityList.append("Sleep")
            else:
                prob = prob * 0.3
                activityToday = "Icecream"
                activityList.append("Icecream")
        elif activityToday == "Icecream":
            change = np.random.choice(transitionName[2],replace=True,p=transitionMatrix[2])
            if change == "II":
                prob = prob * 0.1
                activityList.append("Icecream")
                pass
            elif change == "IS":
                prob = prob * 0.2
                activityToday = "Sleep"
                activityList.append("Sleep")
            else:
                prob = prob * 0.7
                activityToday = "Run"
                activityList.append("Run")
        i += 1  
    print("Possible states: " + str(activityList))
    print("End state after "+ str(days) + " days: " + activityToday)
    print("Probability of the possible sequence of states: " + str(prob))

# 预测 2 天后的可能状态
activity_forecast(2)
```

``` 
Start state: Sleep
Possible states: ['Sleep', 'Sleep', 'Run']
End state after 2 days: Run
Probability of the possible sequence of states: 0.12
```

结果可以得到从睡觉状态开始的可能转移及其概率。进一步拓展这个函数，可以让它从睡觉状态开始，迭代上几百次，就能得到终止于特定状态的预期概率。下面改写一下 `activity_forecast` 函数，加一些循环 ……

``` python
def activity_forecast(days):
    # 选择初始状态
    activityToday = "Sleep"
    activityList = [activityToday]
    i = 0
    prob = 1
    while i != days:
        if activityToday == "Sleep":
            change = np.random.choice(transitionName[0],replace=True,p=transitionMatrix[0])
            if change == "SS":
                prob = prob * 0.2
                activityList.append("Sleep")
                pass
            elif change == "SR":
                prob = prob * 0.6
                activityToday = "Run"
                activityList.append("Run")
            else:
                prob = prob * 0.2
                activityToday = "Icecream"
                activityList.append("Icecream")
        elif activityToday == "Run":
            change = np.random.choice(transitionName[1],replace=True,p=transitionMatrix[1])
            if change == "RR":
                prob = prob * 0.5
                activityList.append("Run")
                pass
            elif change == "RS":
                prob = prob * 0.2
                activityToday = "Sleep"
                activityList.append("Sleep")
            else:
                prob = prob * 0.3
                activityToday = "Icecream"
                activityList.append("Icecream")
        elif activityToday == "Icecream":
            change = np.random.choice(transitionName[2],replace=True,p=transitionMatrix[2])
            if change == "II":
                prob = prob * 0.1
                activityList.append("Icecream")
                pass
            elif change == "IS":
                prob = prob * 0.2
                activityToday = "Sleep"
                activityList.append("Sleep")
            else:
                prob = prob * 0.7
                activityToday = "Run"
                activityList.append("Run")
        i += 1    
    return activityList

# 记录每次的 activityList
list_activity = []
count = 0

# `range` 从第一个参数开始数起，一直到第二个参数（不包含）
for iterations in range(1,10000):
        list_activity.append(activity_forecast(2))

# 查看记录到的所有 `activityList`    
#print(list_activity)

# 遍历列表，得到所有最终状态是跑步的 activityList
for smaller_list in list_activity:
    if(smaller_list[2] == "Run"):
        count += 1

# 计算从睡觉状态开始到跑步状态结束的概率
percentage = (count/10000) * 100
print("The probability of starting at state:'Sleep' and ending at state:'Run'= " + str(percentage) + "%")
```

``` 
The probability of starting at state:'Sleep' and ending at state:'Run'= 62.419999999999995%
```

那么问题来了，这里计算得到的实际结果为何会解决预计的 62% 的？

**注意** 这实际是「大数定律」在发挥作用。大数定律是概率论定律，用来说明在试验次数足够多时，可能性相同的事件发生的频率趋于一致。也就是说，随着试验次数的增加，结果的实际概率会趋于理论或预测的概率。

## 马尔可夫思维

马尔可夫链教程就到此为止了。本文介绍了马尔可夫链及其性质。简单的马尔可夫链是开始学习 Python 数据科学的必经之路。如果想要更多 Python 统计学资源，请参阅[这个网站](https://www.datacamp.com/community/tutorials/python-statistics-data-science)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
