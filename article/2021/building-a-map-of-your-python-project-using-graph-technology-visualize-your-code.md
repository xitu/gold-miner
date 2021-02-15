> * 原文地址：[Building a Map of Your Python Project Using Graph Technology — Visualize Your Code](https://towardsdatascience.com/building-a-map-of-your-python-project-using-graph-technology-visualize-your-code-6764e81f3500)
> * 原文作者：[Kasper Müller](https://medium.com/@kaspermuller)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/building-a-map-of-your-python-project-using-graph-technology-visualize-your-code.md](https://github.com/xitu/gold-miner/blob/master/article/2021/building-a-map-of-your-python-project-using-graph-technology-visualize-your-code.md)
> * 译者：
> * 校对者：

# Building a Map of Your Python Project Using Graph Technology — Visualize Your Code
# 代码可视化 －使用图技术为 Python 项目绘制示意图

![Image by author](https://cdn-images-1.medium.com/max/4294/1*T9vp27fzwWkKNw681HIGAA.png)

As a mathematician and working data scientist, I am fascinated by programming languages, machine learning, data, and of course, mathematics.
作为一名数学家，同时也是一个正在工作的数据科学家，我对编程语言、机器学习、数据和数学都很感兴趣。

These technologies, arts and tools, are of course of huge importance to society and they are transforming our lives as you read this article, but another emerging technology is growing. And it is growing fast!
这些技术、工具或者艺术对于我们的社会至关重要。就在你阅读这篇文章的同时，这些技术正在改变我们的生活，与此同时另一种技术也正在经历高速发展。

It is a technology based on a mathematical field that I studied at university and which was first discovered (or invented..? let’s safe that talk for another time, shall we?) by the great Leonhard Euler when he was given a challenge that nobody at the time knew how to solve.
这是一种基于数学的技术，并且由伟大的 Leonhard Euler 在解决一个当时无人可解的问题时发现的（或者说发明？我认为我们这里的用词应该进行一个专门的讨论？）

The challenge was all about an underlying shape or structure in the form of connected things — relations.
挑战与一种结构或者是潜在的形状有关，这样的结构或者形状通常以一种连接事物的形式-关系-所表现出来。

Euler needed a tool to study relations and structures in which the distance between certain objects didn’t really matter — only the relations themselves mattered.
Euler 需要一种工具来检查在特定实体之间的关系和结构，在这里特定实体之间的距离并不重要，重要的是它们之间的连接关系。

He needed and discovered what is now known as a mathematical graph (or just **graph** for short).
基于这种需要，他发现了一种被称作数学图的工具（或者简称为**图**）

This was the birth of Graph Theory and Topology.
这就是图理论和拓扑学的诞生。

Fast forward 286 years…
时间迅速向前推进286年...

## Discovering High-Level Structures
## 高阶结构的发现

Not so long ago I was working on a relatively big project (on the job) in a repository containing hundreds of Python classes, methods, and functions that all communicated with each other by sharing data and calling each other.
不久之前，我在工作中需要处理一个相当大的项目，这个项目包含了数百个 Python 的类、方法、和函数，它们彼此之间通过共享数据或者互相调用通信。

I was working in a subfolder that contained code meant to solve a subproblem for the big project and then it hit me:
我主要处理一个文件夹，这个文件夹中的代码是用来解决整个项目中的一个问题，突然我冒出了一个想法：

**Wouldn’t it be nice to be able to visualize where I was in the big picture and how all the different objects was connected by calls and data passing between each other?**
**如果能以可视化的方法看到这个问题在整体项目中的定位并且能看到不同实体之间是怎样通过调用和数据传递来彼此交互的不是更好吗？**

How would that look like?
整个图形看上去会是什么样子？

In a couple of evenings and (17 cups of strong coffee) I managed to build a Python program that takes your code and parses it as nodes and relationships in the form of objects and calls, scopes, and instantiations into a Neo4j graph database.
经过了几个傍晚、喝了十七杯特浓咖啡之后，我写了一个 Python 程序，它处理代码作为输入，将代码解析为以对象形式表示的结点、以调用、作用域和实例化形式表示的关系，并存储到了 Neo4j 图形数据库中。

The image above is the result of parsing an NLP project (machine learning used on human language) of mine through this Python Mapping Project.
本文一开始展示的图片就是使用这个 Python 图形构建项目处理一个 NLP 项目（用于处理人类语言的机器学习技术）得到的结果。

For you that don’t know what a graph database is, let’s pause the story for a second.
如果你不知道图形数据库是什么，我们这里暂停一下主线故事~

First of all, a graph is a mathematical object. It consists of what is known as nodes and edges. The edges are called relationships in the Neo nomenclature and that is quite suiting because that’s really what they represent — some kind of relationship between two nodes.
首先，图是一个数学模型，它由节点和边组成。边在 Neo 命名中叫做关系，这是一个非常合适的命名，因为边代表的含义就是两个节点之间的某种关系。

A classical example of such a graph is a social network like Facebook where the nodes represent persons and the relationships represent friendships between the persons.
一个关于这种图的经典的例子就是类似 Facebook 的社交网络，在社交网络中，节点代表人，关系代表人之间的友情。

A graph database then stores such a graph so that you can explore the patterns that lie hidden inside the huge amounts of paths that it amounts to.
一个图形数据库将这样的图储存起来，这样你就可以探索途中数千条线的背后隐藏的模式。

One very important thing that we should keep in mind is that in a graph database, the nodes, as well as the relationships, are stored in the database. That means that certain queries are much much faster than if you had to join a gazillion tables in a relational database.
我们需要时刻谨记的重要一点是，图形数据库中不仅储存了节点，同样也储存了关系。这意味着某些查找操作比在关系数据库中关联许多张表再进行查询要快得多。

To be a little more explicit about what kind of graph we are building here, I will sketch out the structure.
为了更清楚的说明我们构建了一张什么样的图，我简单画出这里的结构。

We specify the root folder of our Python project.
我们先指定 Python 项目的根目录。

Nodes of the graph represent objects of the files in our project/repository. Specifically, functions, classes, and methods. These nodes have some properties like in which files they are defined if they have a parent (methods have classes as parents, functions can be defined inside other functions, etc.).
图中的节点代表了我们项目中的文件，具体一点说就是函数、类和方法。这些节点有一些特性，比如说哪个文件定义了是否有父节点（类作为方法的父节点、函数也可以被定义在另一个函数中之类的）。

For the relationships, we have calls, instantiations, a relationship showing which class a method belongs to, and so on.
至于关系，我们有调用关系和表示一个方法属于哪个类的实例化关系以及等等其他关系。

![Image by author](https://cdn-images-1.medium.com/max/2000/1*Jk_HIC4c5mLrAGcArdQDcg.png)

The idea is that we want to be able to track the calls and the dependencies in the code.
我们想要跟踪代码中的调用和依赖关系。

So there I was, with a new visualization tool in hand — not a tool meant to visualize data like e.g. Matplotlib, but to visualize the structure of the code itself.
所以这个时候我们手头上有了一个新的可视化工具，他不是用来像 Matplotlib 一样对数据进行可视化，而是可视化代码之中的结构。

At first sight, I didn’t think much of it other than an interesting new way to make awesome posters to the office of “won" projects.
一开始，除了将它看作一种为获奖项目制作海报的有趣工具以外，我没想太多。

However, after having discussed with one of my colleagues, which happens to also be a math/graph DB geek, the many different possible tools that it paves the way to, I soon realized that this is so much more than a visualization tool.
然而，和我一个同样来自数学专业并且对图形数据库感兴趣的同事讨论之后，我们发现很多其他的工具已经为我们指明了方向，我们很快意识到这不仅仅是一个可视化工具。

## Tests and Safety
## 测试和安全

It **is** of course nice that you can actually see the dependencies in your code and it might even help you catch a bug or two, or optimize the code by merely looking at it, but the real power of this comes from the unraveling of the nested code structure.
能够看到代码中的依赖并且用看到的图查出一两个 bug 或者仅仅通过看图就能优化代码是一件非常愉快的事情，但是这一输出图的真正力量在于它能够将彼此嵌入的代码的结构呈现出来。

For instance, unless you are really tight and have separated your code into small testable units that you have then tested one by one in (so-called) unit tests before doing bigger integration tests, you are probably not easily able to answer questions like
例如，除非你真的非常认真的将你的代码分割成为可测试的小单元，并且你在进行更大的集成测试之前对这些小单元挨个进行测试，否则回答下面的问题都是很难的：

* To which degree has your code been tested? i.e. which functions are being tested implicitly but not explicitly and vice versa?
* 你的代码测试到了什么程度？例如：哪些函数被间接测试过但并没有直接测试过，或者相反？
* Are there any functions that are not being used anymore or not being tested?
* 是否有从未使用或者从未测试的代码呢？
* Which functions are implicitly being called the most?
* 哪个函数被调用最多次？

**Hold on, Kasper. First of all, what do you mean by implicitly called?**
**等等，Kasper。首先，间接测试是什么意思？**

Well, when I call a function (or a method, generator, etc.) that function might call another function and so on. These functions that are called by other functions are being called **implicitly**. The first function is called **explicitly** or **directly**.
当我调用一个函数（或者是方法、生成器之类的）时候，这一函数可能又会去调用其他的函数。这些被调用的函数就叫做**间接**的使用。第一个被调用的函数叫做**明确的**或者是**直接的**。

**Okay… Why is this important?**
**好的...这一点为什么那么重要呢？**

Because, if a function that is called (implicitly) many times by many different functions has a subtle bug, then, first of all, the probability that this bug occurs at some point is greater than if it was only called once by the same function every time, and secondly, the more functions that depend on that one function, the more damage a potential bug can do to the whole system/program.
因为，如果一个被不同函数隐式调用很多次的函数有一点微小的 bug ，那么首先，这个 bug 在某处发生的概率就比这个函数每次只被同样的方法调用一次要大，第二点，调用这个函数的函数越多，这个bug对整体系统造成的潜在风险就越大。

It turns out that graphs are the perfect equipment to solve such problems. We can even solve them in a more nuanced way by listing the functions, methods, and classes with respect to their importance by means of a score by using graph algorithms.
这证明了图技术是解决该类问题的完美的工具。我们甚至能够通过根据打分得出它们的重要性，并据此列出函数、方法和类这样的微小的方法来解决这个问题。

## The Solution
## 解决方案

Before actually being able to work with neo4j from Python, we need to install the neo4j desktop environment and do a
在 Python 真正使用 neo4j 之前，我们需要安装 neo4j 的桌面环境，执行以下命令：

```bash
pip install neo4j
```

Let’s build a class that is able to communicate with Neo4j from Python.
让我们用 python 构建一个能够和 neo4j 进行通信的类。

Now we can easily build a graph loader in another class by doing something like the following
现在我们可以简单地在任何一个类中，通过以下代码构建一个图加载器：

```python
self.loader = LoadGraphData("Kasper", "strong_pw_123", "bolt://localhost:7687")
```

Let’s take a look at a hobby project of mine mapped out by my mapping algorithm described above.
让我们看看上面描述的映射算法在我的一个个人项目上的实现结果：

![Image by author](https://cdn-images-1.medium.com/max/2000/1*1HACZ5Po5bFz6kShC-3hvg.png)

In this project, the blue nodes are classes, the orange nodes are methods, and the red nodes are functions.
在这个项目中，蓝色的节点代表类，橙色的节点代表方法，红色的节点代表函数。

Notice that some of this code is dummy code meant for testing this graph project but with correct Python syntax of course.
请注意该项目中的一部分代码是无用的，仅为了测试该图映射算法而写的符合python语法的部分。

We want to know which functions are tested and how implicitly they are tested i.e. how many (nested) calls are there from the closest test function to a given non-test function?
我们想知道哪个方法被测试过以及它们是如何被调用测试的？例如：从最近的测试方法到某指定的非测试方法中经历了多少的调用？

Well, we have the graph. Now we need to query the graph database.
我们现在有了图形，接下来就该查询图形数据库了。

Take a look at the following Cypher query that implements a shortest-path algorithm between tests and functions and compare it to the picture.
看一眼下面这个实现了在测试和功能函数之间最短路径算法的查询并且将它和图片进行比较。

Notice that we assume that test functions are objects that are either in a file with a name starting with “test”, inside a class, or function with a name starting with “test”, or simply functions, methods, or classes with names starting with “test” (in the case of classes it should of course start with “Test").
请注意，在这个时候测试方法是一个以 "test" 为开头的名字的函数或某个类中一个名字以 “test” 开头的文件对象，或者仅仅是一个名字以 "test" 开头的函数、方法、类。（对于类的情况而言，他应该以"Test"开头）

This assumption might at first seem far-fetched but I don’t think I have ever written a test function in a Python file starting with something other than “test”, not to mention that the function name itself almost always starts with “test”.
这一前提似乎很牵强，但我几乎没有在 Python 文件中写过用除了"test"的其他单词开头的测试方法，更不用说在大多数情况下方法名本身就是以"test"开头的。

> If you have a file starting with “test” I assume that all the functions and methods in that file are test functions.
> 如果你有一个以"test"开头的文件，那我猜测所有的函数和方法在这个文件中都是测试方法。

The output from the cypher query is the following table:
上述查询的输出结果在下面的表格中：

![Image by author](https://cdn-images-1.medium.com/max/3152/1*AmPI3Ucswgli45Bm1hkQdw.png)

hmm… It would surely be nice if we could get that table in a Pandas DataFrame…
嗯....如果我们能够用Pandas DataFrame的形式得到这张表那就更好了。

Let’s do that:
让我们改一改代码：

We store the above cypher query as a string (using triple quotes) in the variable **query**. Then inside a function or method of choice, you could do something like
我们将查询语句以字符串形式存储在变量 **query** 中。之后，在所选择的方法或函数内部，你会像下面这样写代码：

```python
loader = self.loader
records = loader.work_with_data(query)
df = pd.DataFrame(records, columns=["distances", "test_functions", "test_source", "targets", "target_source"])
```

Then you will get the table in a DataFrame object that you can then work with.
之后就会得到以DataFrame对象形式存储的可以进一步做处理的表格。

Finding all non-test functions might come in handy, so let’s build that.
接下来我们几乎可以立即找出所有的非测试方法，所以让我们构建这张代码图。

Before moving on, we should define what we mean by safety score.
在继续我们的探索之前，我们应该定义一下在这里我们说的安全分数是什么意思。

> For a given function **f** we define the **test norm** of **f** to be the distance in the graph between the closest test function and **f.**
> 对于一个给定的函数 **f** ，我们定义它的**测试规范**是图中展示出来的它本身和最近的测试方法之间的距离。

* By convention, all the test functions have test norm 0.
* 通常定义所有测试方法的测试规范是0。
* If a function is called by a test function, the norm is 1,
* 如果一个方法被一个测试方法直接调用，那么该方法测试规范为1。
* if a function (which is not called by any test function) is called by another function which is called by a test function, the norm is 2, etc.
* 如果一个方法没有被任何测试方法调用，但是被另一个被测试方法调用的函数调用了，那么该方法测试规范为2，以此类推。

Let’s now define the safety score σ for the whole project. Let **NT** be the set of non-test functions and let N = |NT|. Then we define
接下来我们定义整个项目的安全系数 σ 。定义 **NT** 为所有非测试方法的集合并且定义 N = |NT|。之后我们定义

$$
\sigma=\frac{1}{N} \sum_{f \in \mathbb{N T}} \frac{1}{|f|_{T}}, \quad \text { where }|f|_{T} \text { is the test norm of } f
$$

Note that
请注意

* If all the functions in the project are tested directly i.e. if all the functions have test norm 1, then σ = 1
* 如果项目中所有的函数都是被直接测试的，那么所有的函数的测试规范都为1，那么 σ = 1。
* If none of the functions are tested at all neither directly nor implicit (through other functions), then σ is the empty sum which is 0 by convention.
* 如果无论直接或间接都没有函数被测试，那么 σ 会是空的和，一般来说是0。

Thus 0 \< σ \< 1 and the closer to 1 it is, the more tested and safe the code is.
因此 0 \< σ \< 1 ，并且越接近于1，那么这份代码就被测试的越多，也越安全。

The idea behind this formula is that the further out from the tests a given function is, the weaker tested it is. However, I assume that an “average” weak test is performed on functions further out in the graph. But this is of course just a definition. We can always change this. For example, functions called by many different test functions might be better tested than a function that’s only called by one, and we don’t take this into account at all in this version of the project. It might come in later versions though.
在这一公式之后的想法是：某一给定函数距离测试函数的距离越远，针对它的测试就越不足。然而，在这里我猜测“平均”缺陷测试是针对于在图形边缘部分的函数的。但这仅仅只是一个定义。定义往往可以改变。例如，被很多测试函数调用的方法比仅仅被一个测试函数调用的方法测试的更好，我们在本项目中不将这种情况纳入考虑。虽然这种情况可能会在之后的版本中纳入考虑。

Let’s implement this.
让我们实现它！

This works, and for the project above, we get a score of about 0.2 but we need to keep in mind that this only works if you have the word “test” somewhere at the beginning of your filenames or objects that you test your code with.
这是可行的，并且对于上面的项目得到了大约0.2的分数，但是记住，只有在你的文件名或用来测试代码的对象的开头有“test”这个词时，这才有效。

I will leave it as an exercise to the reader to build this Python mapping him/her-self because I am not allowed to open source the code for this project. However, I will give you some hints as to how to build this yourself.
我将把构建这个Python映射的任务留给读者作为练习，因为不打算将这个项目开放源代码。但是，我将给您一些关于如何自己构建的提示。

* I have a master class that keeps track of, and stores, nodes and relationships while I iterate through the files line by line.
* 我有一个主要的类用来在一行一行迭代文件的时候跟踪和存储节点和关系。
* While iterating, we keep track of where we are with respect to scope. Are we inside a class?, a function?, etc.
* 在迭代的时候，我们区分作用域记录我们在哪里。我们是在一个类里？一个方法里？等等
* We store the objects and create a relationship if there is a call or an instantiation to another function or class respectively
* 如果存在一个对于函数或者类的调用或者是一个实例化，那我们存储对象并且创建一个关系
* If the current line contains a definition, then I store the object and the parent object (if any) e.g. methods and classes. I then store relationships in the form of IS_METHOD_IN, IS_FUNCTION_IN.
* 如果当前的行包含定义语句，那么我存储这个对象和父节点（如果存在），也就是方法或者类。之后，以 IS_METHOD_IN, IS_FUNCTION_IN 的形式存储关系。

So basically it is about coding a python syntax parser.
所以基本上这就是编写一个python 语法解析器的全部要点了

And let me tell you, it is more tricky than one thinks right off the bat.
并且，这比我们一开始想象的要复杂一点。

We need to keep track of imports and calls to other files along with building a file crawler because you don't know how deep the repository is. Every object that we store has a source file where it was created and we need to store that as a property of the node because if two objects are called the same in two different files we need to be careful not to merge them into the same object when we create the graph.
我们需要在构建文件爬取器的时候跟踪对其他文件的引入和调用，因为我们不知道这个项目有多深。我们存储的每个对象都有一个它被创建的源文件，并且我们需要存储这个源文件作为节点的一个属性，因为如果两个对象在两个不同的文件中以相同名字被调用的时候，我们应该小心不要在我们画出来的图中将这两个对象合并到一起。

When I have run through all .py files in the project, I create some CSV's from the data stored which I load into Neo4j from Python via a LOAD CSV query using the LoadGraphData class defined above.
当我跑完项目中所有的.py文件的时候，我从数据存储中创建了csv文件，这些数据存储是python通过之前 LoadGraphData 方法使用 LOAD CSV 查询从neo4j中加载的。

## A Map of a Known Project

Here is a map of a project that you might have heard of.

**Beautiful Soup**

![Image by author](https://cdn-images-1.medium.com/max/12290/1*VEpSuRJLgRZu9VVnPs6cXQ.png)

This is a quite nice map of what is going on in Beautiful Soup. Notice how the big clusters are connected.

While this code is not perfect yet, I believe that it can become quite useful in the future. I am currently working on a more stable version that takes the opening of files from python into account as well.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
