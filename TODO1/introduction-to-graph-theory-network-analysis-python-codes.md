> * 原文地址：[An Introduction to Graph Theory and Network Analysis (with Python codes)](https://www.analyticsvidhya.com/blog/2018/04/introduction-to-graph-theory-network-analysis-python-codes/)
> * 原文作者：[Srivatsa](https://www.analyticsvidhya.com/blog/2018/04/introduction-to-graph-theory-network-analysis-python-codes/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-graph-theory-network-analysis-python-codes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-graph-theory-network-analysis-python-codes.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[xionglong58](https://github.com/xionglong58)，[kasheemlew](https://github.com/kasheemlew)

# 基于 Python 的图论和网络分析

## 引论

“一张照片包含了万千信息”，这句话常常被人们引用。但是一张图能表达的信息要更多。以图的形式可视化数据，帮助我们获得了更可行的见解，并基于此作出更好的数据驱动的决策。

但是，为了真正理解图到底是什么，以及为什么我们要使用它，我们还需要知道图论的概念。知道了这个，可以帮助我们更好的编程。

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/Graph-Theory.jpg)

如果你之前曾经学习过图论，你一定知道你需要学习成千上万的公式和枯燥的理论概念。所以我们决定写这篇博客。我们会首先解释概念然后提供说明示例，方便你跟上我们的进度，并直观的理解函数是如何运作的。本篇博客会写的很详细，因为我们相信，提供正确的解释，是一种比只给出简单定义更受欢迎的选择。

在本篇文章中，我们会了解图是什么，它的应用，以及一些图的历史。同时文章中也会涵盖一些图论概念，然后我们会学习一个基于 Python 的示例，来巩固理解。

准备好了吗？那我们开始进入学习吧！

## 目录

-   图及图的应用
-   图的历史以及我们为什么选择图？
-   你需要知道的术语
-   图论基础概念
-   熟悉 Python 中的图
-   基于数据集的分析

## 图及图的应用

让我们先来观察一个如下所示的简单的图，从而帮助理解概念：

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph1.png)

设想这个图代表了城市中人们经常会光顾的不同地点，然后一位城市游客按照这个路径行进。我们设定 V 表示地点，E 表示地点之间的路径

```python
V = {v1, v2, v3, v4, v5}

E = {(v1,v2), (v2,v5), (v5, v5), (v4,v5), (v4,v4)}
```

边 (u,v) 和边 (v,u) 是一样的 —— 它们是无序数对。

具体来讲 —— **图是一种用来学习对象间和实体间配对关系的数学结构**。它是离散数学的一个分支，并且在计算机科学、化学、语言学、运筹学、社会学等多个领域有广泛的应用。

数据科学和分析领域也同样使用图来模拟不同的结构和问题。作为一个数据学的科学家，你应该能够以高效的方法来解决问题，而在很多场景下，图就可以提供这样高效的机制，因为数据被以一种特别的方式组织了起来。

正式来讲：

-   **图**由两个集合组成。`G = (V,E)`。V 是一个顶点集合。E 是一个边的集合。E 是 V 中元素对组合而来的（无序对）。
-   **有向图**也是集合的配对。`D = (V,A)`。V 是顶点的集合。A 是弧的集合。A 是 V 中元素配对组合（有序对）。

如果是有向图，那么 `(u,v)` 和 `(v,u)` 就是有区别的。这时，边被称为弧，来表明方向的概念。

R 和 Python 中有很多用图论来分析数据的库。在本篇文章中，我们将会使用 Networkx Python 包来简单的学习一些这方面的概念，并做一些数据分析。

```python
from IPython.display import Image
Image('images/network.PNG')
```

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph2.png)

```python
Image('images/usecase.PNG')
```

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph3.png)

在上面的例子中可以很清晰的看出，图在数据分析中的应用非常广泛。我们来看几个案例：

-   **市场分析** —— 图能够用于找出社交网中最具有影响力的人。广告商和营销人员能够通过将信息引导至社交网络中最有影响力的人那里，来试图获取最大的营销效益。
-   **银行交易** —— 图能够用于找出不同寻常的交易者，帮助减少欺诈交易。曾经在很多案例中，恐怖分子的活动都被国际银行网络中货币流分析监测到了。
-   **供给链** —— 图能帮助找出运送货物的最优路线，还能帮助选定仓库和运送中心的位置。
-   **制药** —— 制药公司可以使用图论来优化推销员的路线。这样可以帮助推销员降低成本，并缩短旅途时间。
-   **电信** —— 电信公司通常会使用图（Voronoi 图）来计算出信号塔的数量和位置，并且还能够保证最大覆盖面积。

## 图的历史以及我们为什么选择图？

### 图的历史

如果你想知道图的理论是如何被建立起来的 —— 继续读下去吧！

图论的起源可以追溯到七桥（Konigsberg bridge）问题（大约在 1730 年左右）。这个问题提出，哥尼斯堡城里的七座桥是否能够在满足以下条件的前提下全部被走过一遍：

-   路径无重复
-   路径结束的地方恰好就是你开始的位置

这个问题等同于，有四节点和七边的图是否能拥有一个欧拉圆（欧拉圆指的是，一个开始点和终止点相同的欧拉路径。而欧拉路径指的是，在图中恰好通过每一条边一次的路径。更多的术语将在下文介绍）。这个问题引出了欧拉图的概念。而关于哥尼斯堡桥问题，答案是不能，第一个回答出这个问题的人正是欧拉，你一定已经猜到了。

在 1840 年，A.F Mobius 给出了完全图和二分图的概念，同时 Kuratowski 通过 recreational 问题证明了它们都是平面图。树的概念（无环全连接图）则在 1845 被 Gustav Kirchhoff 提出，并且他在计算电网或电路中的电流时使用了图论的思想。

在 1852 年，Thomas Gutherie 创建了著名的四色问题。而后在 1856 年，Thomas. P. Kirkman 和 William R.Hamilton 共同在多面体上研究圆环，并通过研究如何找出通过指定的每个点仅一次的路径，创建了哈密顿图的概念。1913 年，H.Dudeney 也提到了一个难题。尽管四色问题很早就被提出，而在一个世纪后才被 Kenneth Appel 和 Wolfgang Haken 解答。这个时间才被认为是图论的诞生时间。

Caley 研究了微分学的特定分析形式，从而研究树结构。这在理论化学上已经有了很多应用。这也激发了枚举图论的创建。而在 1878 年，Sylvester 在“量子不变量”与代数和分子图的协变量之间进行了类比时，使用了“图”这个术语。

在 1941 年，Ramsey 研究了着色问题，从而引出了图论另一个分支的定义，即极值图论。在 1969 年，四色问题被 Heinrich 通过计算机解决。渐进图的学习也连带着激发了随机图论的发展。图论和拓扑学的历史同样紧密相关，它们之间有很多共同的概念和理论。

```python
Image('images/Konigsberg.PNG', width = 800)
```

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph4.png)

### 为什么选择图？

以下几点可以激励你在日常数据科学问题中使用图论：

1.  在处理抽象概念，例如关系和交互问题时，图是更好的方法。同时，在你思考这些概念时，它也提供了更直观且可视的方法。而在分析社会关系时，图也自然成了基础。
2.  图行数据库已经成为了很常见的计算机工具，它是 SQL 和 NoSQL 数据库的替代。
3.  图的一种：DAGs（有向无环图），能够被应用于模型化分析流。
4.  一些神经网络框架也使用 DAGs 来对不同层的各个操作建模。
5.  图论被用来学习和模型化社交网络、欺诈模型、功率模型、社交媒体中的病毒性和影响力。社交网络分析（SNA）也许是图论在数据科学中最有名的应用。
6.  它被用于聚类算法 —— 最知名的是 K-Means 算法。
7.  系统动力学也会应用一些图论的概念 —— 最知名的是循环。
8.  路径优化是优化问题的一个子集，它也使用了图的概念。
9.  从计算机科学的角度来看 —— 图让计算更加高效。和表格数据相比，如果数据以图的方式排列，一些算法的复杂度能够更低。

## 你需要知道的术语

在继续深入之前，我们建议你熟悉下面这些术语。

1.  顶点 `u` 和 `v` 被称为边 `(u,v)` 的**端点**（`end vertices`）
2.  如果两条边有相同的**端点**，那么它们被称为**平行的**
3.  形如 `(v,v)` 的边是一个**环**
4.  如果一个图**没有平行边也没有环**，则它被称为**简单图**
5.  如果一个图**没有边**，那么称这个图为**空**（`Empty`）。也就是 `E` 是空的
6.  一个图如果**没有顶点**，那么称之为**空图**（`Null Graph`）。也就是 `V` 和 `E` 全都是空的
7.  只有一个顶点的图称为**平凡图**（`Trivial` graph）
8.  如果两条边有一个公共顶点，则它们是**相邻**（`Adjacent`）边。如果两个顶点有一条公共边，则它们是**相邻**顶点
9.  顶点的**度**，写作`d(v)`，表示以该顶点作为端点的**边**的数量。按照惯例，环对应端点的度为边的两倍，平行边分别对应的两个端点的度都要加
10. 度为 1 的顶点称为**孤立顶点**（Isolated Vertices）。`d(1)` 的顶点是孤立的。
11. 如果一个图的边集包含了所有端点可能组合成的边，则称这个图为**完全图**（Complete）
12. 图中点和边是有限的，可替换的序列 ViEiViEi 称为图 `G = (V,E)` 的一个**路径**（`Walk`）
13. 如果路径的开始顶点和结束顶点是不同的，那么称这个路径是开放的（`Open`）。而如果开始顶点和结束顶点相同，则称为闭合的（`Closed`）
14. 每个边最多通过一次的迹（`Trail`）称为路径
15. 每个顶点最多通过一次的路径（`Path`）称为迹（除了闭路）
16. 闭合的路径是闭环（`Circuit`）—— 类似于一个电路

## 图论基础概念

在这个章节中，我们将会学习一些数据分析相关的有用的概念（内容不分先后）。记住，本文章涉及的内容之外还有很多需要深度学习的概念。现在让我们开始吧。

### 平均路径长度

所有可能的配对点的平均最短路径长度。它给图了一个“紧密”程度的度量，可以被用于描述网络中流的快慢/是否易于通过。

### BFS 和 DFS

**宽度优先搜索**和**深度优先搜索**是两个用于搜索图中节点的不同的算法。它们通常用于查看从已知节点出发，是否能找到某个节点。也被称为**图的遍历**

BFS 的目标是依次搜索距离根节点最近的节点以遍历图，而 DFS 的目标是依次搜索距离根节点尽可能远的节点，从而遍历图。

### 中心性

它的用途最广泛，并且是网络分析最重要的概念工具。中心性的目标是找到网络中最重要的节点。如何定义“重要”可以多种方式，所以就有很多中心的度量方法。中心性的度量方法本身就有分类（或者说中心度量方法的类别）。有的是通过边的流量来度量，而有的则通过图的路径结构。

一些最常见的应用如下：

1.  **度中心性** —— 第一个也是概念上最简单的中心性定义。它表示一个点连接的边的数量。在一个有向图的例子中，我们则可以有两种度中心性的衡量方式。出度和入度的中心性。
2.  **临近中心性** —— 从该节点出发，到所有节点的平均路径长度最短。
3.  **中介中心性** —— 该节点出现在另外两个节点之间最短路径中的次数。

这些中心性度量各有不同，它们的定义可以应用于不同的算法中。总而言之，这意味着会引出大量的定义和算法。

### 网络密度

图中有多少边的度量。定义会随着图的种类以及问题所处的情景而变化。对于一个完全无向图，则网络密度为 1，而对于一个空图，度则为 0。图的网络密度在一些场景下也可以大于一（比如图中包含环的时候）。

### 图形随机化

一些图的指标定义也许很容易计算，但是想要弄清楚它们的相关重要性却并不容易。这时我们就会用到网络/图形随机化。我们同时计算当前图和另一个随机生成的**相似**图的某个指标。相似性可以是图的度和节点数量相等。通常情况下，我们会生成 1000 个相似的随机图，并计算每个图的指标，然后将结果与手头上的图的相同指标进行对比，以得出基准概念。

在数据科学领域中，当你尝试对图作出某个声明的时候，将它与随机生成的图做对比将会很有帮助。

## 熟悉 Python 中的图

我们将会使用 Python 的 `networkx` 工具包。如果你使用的是 Python 的 Anaconda 发行版，则它可以被安装在 Anaconda 的根环境下。你也可以使用 `pip install` 来安装。

下面我们来看看使用 Networkx 包能做的一些事情。包括引入和创建图，以及图的可视化。

### 创建图

```python
import networkx as nx

# 创建一个图
G = nx.Graph() # 现在 G 是空的

# 添加一个节点
G.add_node(1)
G.add_nodes_from([2,3]) # 你也能通过传入一个列表来添加一系列的节点

# 添加边
G.add_edge(1,2)

e = (2,3)
G.add_edge(*e) # * 表示解包元组
G.add_edges_from([(1,2), (1,3)]) # 正如节点的添加，我们也可以这样添加边
```

点和边属性可以随着它们的创建被添加，方法是传入一个包含了点和属性的字典。

除了一个一个点或者一条一条边的来创建图，还可以通过应用经典的图操作来创建，例如：

```
subgraph(G, nbunch)      - 生成由节点集合 nbunch 组成的 G 的子图
union(G1,G2)             - 求图的并集
disjoint_union(G1,G2)    - 图中所有不同节点组成的单元
cartesian_product(G1,G2) - 返回笛卡尔积图（Cartesian product graph）
compose(G1,G2)           - 两图中都有的点所组成的图
complement(G)            - 补图
create_empty_copy(G)     - 返回同一个图的空副本
convert_to_undirected(G) - 返回图的无向形式
convert_to_directed(G)   - 返回图的有向形式
```

对于不同类别的图，有单独的类。例如类 `nx.DiGraph()` 支持新建有向图。包含特定路径的图也可以使用某一个方法直接创建出来。如果想了解所有的创建图的方法，可以参见文档。参考列表在文末给出。

```python
Image('images/graphclasses.PNG', width = 400)
```

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph5.png)

### 获取边和节点

图的所有边和节点可以使用方法 `G.nodes()` 和 `G.edges()` 获取。单独的边和节点可以使用括号/下标的方式获取。

```python
G.nodes()
```

NodeView((1, 2, 3))

```python
G.edges()
```

EdgeView([(1, 2), (1, 3), (2, 3)])

```python
G[1] # 与 G.adj[1] 相同
```

AtlasView({2: {}, 3: {}})

```python
G[1][2]
```

{}

```python
G.edges[1, 2]
```

{}

### 图形可视化

Networkx 提供了基础的图的可视化功能，但是它的主要目标是分析图而不是图的可视化。图的可视化比较难，我们将会使用专门针对它的特殊工具。`Matplotlib` 提供了很多方便的函数。但是 `GraphViz` 则可能是最好的工具，因为它以 `PyGraphViz` 的形式提供了 Python 接口（下面给出了它的文档链接）。

```python
%matplotlib inline
import matplotlib.pyplot as plt
nx.draw(G)
```

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph6.png)

首先你需要从网站安装 Graphviz（如下是下载链接）。然后运行 `pip install pygraphviz --install-option=" <>`。在安装选项中你需要提供 Graphviz 的库和依赖的文件夹地址。

```python
import pygraphviz as pgv
d={'1': {'2': None}, '2': {'1': None, '3': None}, '3': {'1': None}}
A = pgv.AGraph(data=d)
print(A) # 这是图的字符串形式或者简单展示形式
```

Output:

```
strict graph "" {
	1 -- 2;
	2 -- 3;
	3 -- 1;
}
```

PyGraphviz 提供了对边和节点的每个属性的强大掌控能力。我们可以用它得到非常美观的可视化图形。

```python
# 让我们创建另一个图，我们可以控制它每个节点的颜色
B = pgv.AGraph()

# 设置所有节点的共同属性
B.node_attr['style']='filled'
B.node_attr['shape']='circle'
B.node_attr['fixedsize']='true'
B.node_attr['fontcolor']='#FFFFFF'

# 创建并设置每个节点不同的属性（使用循环）
for i in range(16):
	B.add_edge(0,i)
	n=B.get_node(i)
	n.attr['fillcolor']="#%2x0000"%(i*16)
	n.attr['height']="%s"%(i/16.0+0.5)
	n.attr['width']="%s"%(i/16.0+0.5)
B.draw('star.png',prog="circo") # 这行代码会在本地创建一个 .png 格式的文件。如下所示。

Image('images/star.png', width=650) # 我们所创建的图的可视化图片
```

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph7.png)

通常情况下，可视化被认为是图分析的一个独立任务。分析后的图形会导出为点文件。然后这个点文件被另做可视化处理，来展示我们试图证明的观点。

## 基于数据集的分析

我们将会学习一个通用数据集（并不是专门用于图分析的），然后做一些操作（使用 panda 库），这样数据才能以边列表的形式被插入到图中。边列表是一个元组的列表，包含了定义每一条边的顶点对。

这个数据集来自于航空业。它包含了航线的一些基本信息，以及旅程和目的地的资源，对于每个旅程还包含了几栏到达和起飞时间的说明。你能够想象，这个数据集本身就非常适合作为图来分析。想象一下航线（边）连接城市（节点）。如果你在运营航空公司，接下来你可以问如下这几个问题

1.  从 A 到 B 的最近路程是什么？路程最短的是哪条？时间最短的是哪条？
2.  从 C 到 D 有路径可以通过吗？
3.  哪些机场的交通压力最大？
4.  处于最多机场之间的是哪个机场？那么它就可以作为当地枢纽

```python
import pandas as pd
import numpy as np

data = pd.read_csv('data/Airlines.csv')
```

```
data.shape
(100, 16)
```

```
data.dtypes

year                int64
month               int64
day                 int64
dep_time          float64
sched_dep_time      int64
dep_delay         float64
arr_time          float64
sched_arr_time      int64
arr_delay         float64
carrier            object
flight              int64
tailnum            object
origin             object
dest               object
air_time          float64
distance            int64
dtype: object
```

1.  我们注意到，将起始点和终点作为节点是一个很好的选择。这样所有的信息都可以作为节点或者边的属性了。一条边可以被认为是一段旅程。这段旅程将会和不同的时间、航班号、飞机尾号等等相关联。
2.  我们注意到，年月日和其他时间信息被分散在好几栏中。我们希望创建一个能包含所有这些信息时间栏，我们也需要分别保存预计和实际的到达和出发时间。最终，我们应该有 4 个时间栏（预计和实际的到达和出发时间）
3.  另外，时间栏的格式并不合适。下午的 4:30 被表示为 1630 而不是 16:30。该栏中并没有分隔符来分割信息。其中一个方法是使用 pandas 库的字符串方法和正则表达式。
4.  我们也要注意，sched_dep_time 和 sched_arr_time 是 int64 数据类型的，而 dep_time 和 arr_time 是 float64 数据类型的
5.  另一个复杂的因素是 NaN 值

```python
# 将 sched_dep_time 转化为 'std' —— 预计起飞时间
data['std'] = data.sched_dep_time.astype(str).str.replace('(\d{2}$)', '') + ':' + data.sched_dep_time.astype(str).str.extract('(\d{2}$)', expand=False) + ':00'

# 将 sched_arr_time 转化为 'sta' —— 预计抵达时间
data['sta'] = data.sched_arr_time.astype(str).str.replace('(\d{2}$)', '') + ':' + data.sched_arr_time.astype(str).str.extract('(\d{2}$)', expand=False) + ':00'

# 将 dep_time 转化为 'atd' —— 实际起飞时间
data['atd'] = data.dep_time.fillna(0).astype(np.int64).astype(str).str.replace('(\d{2}$)', '') + ':' + data.dep_time.fillna(0).astype(np.int64).astype(str).str.extract('(\d{2}$)', expand=False) + ':00'

# 将 arr_time 转化为 'ata' —— 实际抵达时间
data['ata'] = data.arr_time.fillna(0).astype(np.int64).astype(str).str.replace('(\d{2}$)', '') + ':' + data.arr_time.fillna(0).astype(np.int64).astype(str).str.extract('(\d{2}$)', expand=False) + ':00'
```

现在我们有了我们期望的格式时间栏。最后，我们期望将`year`、`month` 和 `day` 合并为一个时间栏。这一步并不是必需的，但是一旦时间被转化为 `datetime` 的格式，我们可以很容易的获取到年月日以及其他信息。

```python
data['date'] = pd.to_datetime(data[['year', 'month', 'day']])

# 最后，我们删除掉不需要的栏
data = data.drop(columns = ['year', 'month', 'day'])
```

现在使用 networkx 函数导入数据，该函数可以直接获取 pandas 的数据帧。正如图的创建，这里也有很多将不同格式的数据插入图的方法。

```python
import networkx as nx
FG = nx.from_pandas_edgelist(data, source='origin', target='dest', edge_attr=True,)
```

```python
FG.nodes()
```

输出：

```
NodeView(('EWR', 'MEM', 'LGA', 'FLL', 'SEA', 'JFK', 'DEN', 'ORD', 'MIA', 'PBI', 'MCO', 'CMH', 'MSP', 'IAD', 'CLT', 'TPA', 'DCA', 'SJU', 'ATL', 'BHM', 'SRQ', 'MSY', 'DTW', 'LAX', 'JAX', 'RDU', 'MDW', 'DFW', 'IAH', 'SFO', 'STL', 'CVG', 'IND', 'RSW', 'BOS', 'CLE'))
```

```python
FG.edges()
```

输出：

```
EdgeView([('EWR', 'MEM'), ('EWR', 'SEA'), ('EWR', 'MIA'), ('EWR', 'ORD'), ('EWR', 'MSP'), ('EWR', 'TPA'), ('EWR', 'MSY'), ('EWR', 'DFW'), ('EWR', 'IAH'), ('EWR', 'SFO'), ('EWR', 'CVG'), ('EWR', 'IND'), ('EWR', 'RDU'), ('EWR', 'IAD'), ('EWR', 'RSW'), ('EWR', 'BOS'), ('EWR', 'PBI'), ('EWR', 'LAX'), ('EWR', 'MCO'), ('EWR', 'SJU'), ('LGA', 'FLL'), ('LGA', 'ORD'), ('LGA', 'PBI'), ('LGA', 'CMH'), ('LGA', 'IAD'), ('LGA', 'CLT'), ('LGA', 'MIA'), ('LGA', 'DCA'), ('LGA', 'BHM'), ('LGA', 'RDU'), ('LGA', 'ATL'), ('LGA', 'TPA'), ('LGA', 'MDW'), ('LGA', 'DEN'), ('LGA', 'MSP'), ('LGA', 'DTW'), ('LGA', 'STL'), ('LGA', 'MCO'), ('LGA', 'CVG'), ('LGA', 'IAH'), ('FLL', 'JFK'), ('SEA', 'JFK'), ('JFK', 'DEN'), ('JFK', 'MCO'), ('JFK', 'TPA'), ('JFK', 'SJU'), ('JFK', 'ATL'), ('JFK', 'SRQ'), ('JFK', 'DCA'), ('JFK', 'DTW'), ('JFK', 'LAX'), ('JFK', 'JAX'), ('JFK', 'CLT'), ('JFK', 'PBI'), ('JFK', 'CLE'), ('JFK', 'IAD'), ('JFK', 'BOS')])
```

```python
nx.draw_networkx(FG, with_labels=True) # 图的快照。正如我们期望的，我们看到了三个很繁忙的机场
```

![](https://s3-ap-south-1.amazonaws.com/av-blog-media/wp-content/uploads/2018/03/graph8.png)

```python
nx.algorithms.degree_centrality(FG) # Notice the 3 airports from which all of our 100 rows of data originates
nx.algorithms.degree_centrality(FG) # 从一百多行的所有源数据中标注出这三个机场
nx.density(FG) # 图的平均边度
```

输出：

```
0.09047619047619047
```

```python
nx.average_shortest_path_length(FG) # 图中所有路径中的最短平均路径
```

输出：

```
2.36984126984127
```

```python
nx.average_degree_connectivity(FG) # 对于一个度为 k 的节点 —— 它的邻居节点的平均值是什么？
```

输出：

```
{1: 19.307692307692307, 2: 19.0625, 3: 19.0, 17: 2.0588235294117645, 20: 1.95}
```

很明显的可以从上文的图的可视化看出 —— 一些机场之间有很多路径。加入我们希望计算两个机场之间可能的最短路径。我们可以想到这几种方法

1.  距离最短路径
2.  时间最短路径

我们能做的是，通过对比距离或者时间路径，计算最短路径的算法。注意，这是一个近似的答案 —— 实际需要解决的问题是，当你到达转机机场时可选择的航班 + 等待转机的时间共同决定的最短方法。这是一个更加复杂的方法，而也是人们通常用于计划旅行的方法。鉴于本篇文章的目标，我们仅仅假设当你到达机场的时候航班恰好可以搭乘，并在计算最短路径的时候以时间作为计算对象。

我们以 `JAX` 和 `DFW` 机场为例：

```python
# 找到所有可用路径
for path in nx.all_simple_paths(FG, source='JAX', target='DFW'):
	print(path)

# 站到从 JAX 到 DFW 的 dijkstra 路径
# 你可以在这里阅读更多更深入关于 dijkstra 是如何计算的信息 —— https://courses.csail.mit.edu/6.006/fall11/lectures/lecture16.pdf
dijpath = nx.dijkstra_path(FG, source='JAX', target='DFW')
dijpath
```

输出：

```
['JAX', 'JFK', 'SEA', 'EWR', 'DFW']
```

```python
# 我们来试着找出飞行时间的 dijkstra 路径（近似情况）
shortpath = nx.dijkstra_path(FG, source='JAX', target='DFW', weight='air_time')
shortpath
```

输出：

```
['JAX', 'JFK', 'BOS', 'EWR', 'DFW']
```

## 总结

本文只是对图论与网络分析这一非常有趣的领域进行了很简单的介绍。图论的知识和 Python 包能作为任何一个数据科学家非常有价值的工具。关于上文使用的数据集，还有一系列可以提出的问题，例如：

1.  已知费用、飞行时间和可搭乘的航班，找到两个机场间的最短距离？
2.  如果你正管理一家航空公司，并且你有一批飞机。你可以知道人们对航班的需求。你有权再操作两驾飞机（或者在你的机队中增加两架），你将使用那两条线路来获取最大盈利？
3.  你能不能重新安排航班和时间表，来优化某个特定的参数（例如时间合理性或者盈利能力）

如果你真的解决了这些问题，请在评论区评论，好让我们知道！

网络分析将会帮助我们解决一些常见的数据科学问题，并以更大规模和抽象的方式进行可视化。如果你想在某个特定方面了解更多，请留言给我们。

## 参考书目和引用

1.  [History of Graph Theory || S.G. Shrinivas et. al](http://www.cs.xu.edu/csci390/12s/IJEST10-02-09-124.pdf)
2.  [Big O Notation cheatsheet](http://bigocheatsheet.com/)
3.  [Networkx reference documentation](https://networkx.github.io/documentation/stable/reference/index.html)
4.  [Graphviz download](http://www.graphviz.org/download/)
5.  [Pygraphvix](http://pygraphviz.github.io/)
6.  [Star visualization](https://github.com/pygraphviz/pygraphviz/blob/master/examples/star.py)
7.  [Dijkstra Algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
