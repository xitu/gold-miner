> * 原文地址：[Building a Map of Your Python Project Using Graph Technology — Visualize Your Code](https://towardsdatascience.com/building-a-map-of-your-python-project-using-graph-technology-visualize-your-code-6764e81f3500)
> * 原文作者：[Kasper Müller](https://medium.com/@kaspermuller)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/building-a-map-of-your-python-project-using-graph-technology-visualize-your-code.md](https://github.com/xitu/gold-miner/blob/master/article/2021/building-a-map-of-your-python-project-using-graph-technology-visualize-your-code.md)
> * 译者：
> * 校对者：

# Building a Map of Your Python Project Using Graph Technology — Visualize Your Code

![Image by author](https://cdn-images-1.medium.com/max/4294/1*T9vp27fzwWkKNw681HIGAA.png)

As a mathematician and working data scientist, I am fascinated by programming languages, machine learning, data, and of course, mathematics.

These technologies, arts and tools, are of course of huge importance to society and they are transforming our lives as you read this article, but another emerging technology is growing. And it is growing fast!

It is a technology based on a mathematical field that I studied at university and which was first discovered (or invented..? let’s safe that talk for another time, shall we?) by the great Leonhard Euler when he was given a challenge that nobody at the time knew how to solve.

The challenge was all about an underlying shape or structure in the form of connected things — relations.

Euler needed a tool to study relations and structures in which the distance between certain objects didn’t really matter — only the relations themselves mattered.

He needed and discovered what is now known as a mathematical graph (or just **graph** for short).

This was the birth of Graph Theory and Topology.

Fast forward 286 years…

## Discovering High-Level Structures

Not so long ago I was working on a relatively big project (on the job) in a repository containing hundreds of Python classes, methods, and functions that all communicated with each other by sharing data and calling each other.

I was working in a subfolder that contained code meant to solve a subproblem for the big project and then it hit me:

**Wouldn’t it be nice to be able to visualize where I was in the big picture and how all the different objects was connected by calls and data passing between each other?**

How would that look like?

In a couple of evenings and (17 cups of strong coffee) I managed to build a Python program that takes your code and parses it as nodes and relationships in the form of objects and calls, scopes, and instantiations into a Neo4j graph database.

The image above is the result of parsing an NLP project (machine learning used on human language) of mine through this Python Mapping Project.

For you that don’t know what a graph database is, let’s pause the story for a second.

First of all, a graph is a mathematical object. It consists of what is known as nodes and edges. The edges are called relationships in the Neo nomenclature and that is quite suiting because that’s really what they represent — some kind of relationship between two nodes.

A classical example of such a graph is a social network like Facebook where the nodes represent persons and the relationships represent friendships between the persons.

A graph database then stores such a graph so that you can explore the patterns that lie hidden inside the huge amounts of paths that it amounts to.

One very important thing that we should keep in mind is that in a graph database, the nodes, as well as the relationships, are stored in the database. That means that certain queries are much much faster than if you had to join a gazillion tables in a relational database.

To be a little more explicit about what kind of graph we are building here, I will sketch out the structure.

We specify the root folder of our Python project.

Nodes of the graph represent objects of the files in our project/repository. Specifically, functions, classes, and methods. These nodes have some properties like in which files they are defined if they have a parent (methods have classes as parents, functions can be defined inside other functions, etc.).

For the relationships, we have calls, instantiations, a relationship showing which class a method belongs to, and so on.

![Image by author](https://cdn-images-1.medium.com/max/2000/1*Jk_HIC4c5mLrAGcArdQDcg.png)

The idea is that we want to be able to track the calls and the dependencies in the code.

So there I was, with a new visualization tool in hand — not a tool meant to visualize data like e.g. Matplotlib, but to visualize the structure of the code itself.

At first sight, I didn’t think much of it other than an interesting new way to make awesome posters to the office of “won" projects.

However, after having discussed with one of my colleagues, which happens to also be a math/graph DB geek, the many different possible tools that it paves the way to, I soon realized that this is so much more than a visualization tool.

## Tests and Safety

It **is** of course nice that you can actually see the dependencies in your code and it might even help you catch a bug or two, or optimize the code by merely looking at it, but the real power of this comes from the unraveling of the nested code structure.

For instance, unless you are really tight and have separated your code into small testable units that you have then tested one by one in (so-called) unit tests before doing bigger integration tests, you are probably not easily able to answer questions like

* To which degree has your code been tested? i.e. which functions are being tested implicitly but not explicitly and vice versa?
* Are there any functions that are not being used anymore or not being tested?
* Which functions are implicitly being called the most?

**Hold on, Kasper. First of all, what do you mean by implicitly called?**

Well, when I call a function (or a method, generator, etc.) that function might call another function and so on. These functions that are called by other functions are being called **implicitly**. The first function is called **explicitly** or **directly**.

**Okay… Why is this important?**

Because, if a function that is called (implicitly) many times by many different functions has a subtle bug, then, first of all, the probability that this bug occurs at some point is greater than if it was only called once by the same function every time, and secondly, the more functions that depend on that one function, the more damage a potential bug can do to the whole system/program.

It turns out that graphs are the perfect equipment to solve such problems. We can even solve them in a more nuanced way by listing the functions, methods, and classes with respect to their importance by means of a score by using graph algorithms.

## The Solution

Before actually being able to work with neo4j from Python, we need to install the neo4j desktop environment and do a

```bash
pip install neo4j
```

Let’s build a class that is able to communicate with Neo4j from Python.

Now we can easily build a graph loader in another class by doing something like the following

```python
self.loader = LoadGraphData("Kasper", "strong_pw_123", "bolt://localhost:7687")
```

Let’s take a look at a hobby project of mine mapped out by my mapping algorithm described above.

![Image by author](https://cdn-images-1.medium.com/max/2000/1*1HACZ5Po5bFz6kShC-3hvg.png)

In this project, the blue nodes are classes, the orange nodes are methods, and the red nodes are functions.

Notice that some of this code is dummy code meant for testing this graph project but with correct Python syntax of course.

We want to know which functions are tested and how implicitly they are tested i.e. how many (nested) calls are there from the closest test function to a given non-test function?

Well, we have the graph. Now we need to query the graph database.

Take a look at the following Cypher query that implements a shortest-path algorithm between tests and functions and compare it to the picture.

Notice that we assume that test functions are objects that are either in a file with a name starting with “test”, inside a class, or function with a name starting with “test”, or simply functions, methods, or classes with names starting with “test” (in the case of classes it should of course start with “Test").

This assumption might at first seem far-fetched but I don’t think I have ever written a test function in a Python file starting with something other than “test”, not to mention that the function name itself almost always starts with “test”.

> If you have a file starting with “test” I assume that all the functions and methods in that file are test functions.

The output from the cypher query is the following table:

![Image by author](https://cdn-images-1.medium.com/max/3152/1*AmPI3Ucswgli45Bm1hkQdw.png)

hmm… It would surely be nice if we could get that table in a Pandas DataFrame…

Let’s do that:

We store the above cypher query as a string (using triple quotes) in the variable **query**. Then inside a function or method of choice, you could do something like

```python
loader = self.loader
records = loader.work_with_data(query)
df = pd.DataFrame(records, columns=["distances", "test_functions", "test_source", "targets", "target_source"])
```

Then you will get the table in a DataFrame object that you can then work with.

Finding all non-test functions might come in handy, so let’s build that.

Before moving on, we should define what we mean by safety score.

> For a given function **f** we define the **test norm** of **f** to be the distance in the graph between the closest test function and **f.**

* By convention, all the test functions have test norm 0.
* If a function is called by a test function, the norm is 1,
* if a function (which is not called by any test function) is called by another function which is called by a test function, the norm is 2, etc.

Let’s now define the safety score σ for the whole project. Let **NT** be the set of non-test functions and let N = |NT|. Then we define

$$
\sigma=\frac{1}{N} \sum_{f \in \mathbb{N T}} \frac{1}{|f|_{T}}, \quad \text { where }|f|_{T} \text { is the test norm of } f
$$

Note that

* If all the functions in the project are tested directly i.e. if all the functions have test norm 1, then σ = 1
* If none of the functions are tested at all neither directly nor implicit (through other functions), then σ is the empty sum which is 0 by convention.

Thus 0 \< σ \< 1 and the closer to 1 it is, the more tested and safe the code is.

The idea behind this formula is that the further out from the tests a given function is, the weaker tested it is. However, I assume that an “average” weak test is performed on functions further out in the graph. But this is of course just a definition. We can always change this. For example, functions called by many different test functions might be better tested than a function that’s only called by one, and we don’t take this into account at all in this version of the project. It might come in later versions though.

Let’s implement this.

This works, and for the project above, we get a score of about 0.2 but we need to keep in mind that this only works if you have the word “test” somewhere at the beginning of your filenames or objects that you test your code with.

I will leave it as an exercise to the reader to build this Python mapping him/her-self because I am not allowed to open source the code for this project. However, I will give you some hints as to how to build this yourself.

* I have a master class that keeps track of, and stores, nodes and relationships while I iterate through the files line by line.
* While iterating, we keep track of where we are with respect to scope. Are we inside a class?, a function?, etc.
* We store the objects and create a relationship if there is a call or an instantiation to another function or class respectively
* If the current line contains a definition, then I store the object and the parent object (if any) e.g. methods and classes. I then store relationships in the form of IS_METHOD_IN, IS_FUNCTION_IN.

So basically it is about coding a python syntax parser.

And let me tell you, it is more tricky than one thinks right off the bat.

We need to keep track of imports and calls to other files along with building a file crawler because you don't know how deep the repository is. Every object that we store has a source file where it was created and we need to store that as a property of the node because if two objects are called the same in two different files we need to be careful not to merge them into the same object when we create the graph.

When I have run through all .py files in the project, I create some CSV's from the data stored which I load into Neo4j from Python via a LOAD CSV query using the LoadGraphData class defined above.

## A Map of a Known Project

Here is a map of a project that you might have heard of.

**Beautiful Soup**

![Image by author](https://cdn-images-1.medium.com/max/12290/1*VEpSuRJLgRZu9VVnPs6cXQ.png)

This is a quite nice map of what is going on in Beautiful Soup. Notice how the big clusters are connected.

While this code is not perfect yet, I believe that it can become quite useful in the future. I am currently working on a more stable version that takes the opening of files from python into account as well.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
