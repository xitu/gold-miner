> * 原文地址：[Demystify Graph Coloring Algorithms](https://medium.com/better-programming/demystify-graph-coloring-algorithms-9ae51351ea5b)
> * 原文作者：[Edward Huang](https://medium.com/@edwardgunawan880)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/demystify-graph-coloring-algorithms.md](https://github.com/xitu/gold-miner/blob/master/article/2021/demystify-graph-coloring-algorithms.md)
> * 译者：
> * 校对者：

# Demystify Graph Coloring Algorithms

#### Solve edge coloring, map coloring, and other fun problems

![Photo by [salvatore ventura](https://unsplash.com/@salvoventura?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12032/0*nMi_GsBxeMO5LlkM)

Graph coloring is a problem where certain colors are assigned to a particular constraint in a graph. For instance, it could be that you must color a graph, either vertices or edges, so that no two identical colors are adjacent to each other — no two adjacent vertices or edges will have the same color.

I stumbled upon this algorithm and I was thinking about what its purpose was. As I look more deeply into graph coloring problems and their use cases, I realized that they’re widely used in the applications we use. This article will briefly talk about this algorithm and use cases of graph coloring.

---

## The Algorithm

There are many ways of graph coloring problems. You can do [vertex coloring](https://mathworld.wolfram.com/VertexColoring.html#:~:text=A%20vertex%20coloring%20is%20an,colors%20for%20a%20given%20graph.), edge coloring, and geographic [map coloring](https://en.wikipedia.org/wiki/Map_coloring#:~:text=Map%20coloring%20is%20the%20act,different%20features%20on%20a%20map.&text=The%20second%20is%20in%20mathematics,features%20have%20the%20same%20color.). There are different questions you can ask in this algorithm. For instance, we can answer the questions of not assigning the same resources dependent on each other at the same time. We can also answer the questions of what is the minimum number of colors needed to color this graph. Moreover, we can make this into a backtracking question, where we want to find all possible coloring methods that can color this graph.

This will be a simple use-case. Once we know the basic algorithm, we can always answer these questions.

Let’s assume it’s vertex coloring, where I want to color the graph so that no two adjacent vertices have the same color.

Let’s assumed we have five vertices in a graph. The maximum number of colors that we can assign to each of the vertices is five. Therefore, we can initialize our list of colors to have five colors.

![](https://cdn-images-1.medium.com/max/2000/0*dX9rqaI1V_1bvgv2.png)

Next, we can start coloring the first vertex on a blank graph. You can choose any random one — it doesn’t matter.

In the following algorithm, we color each vertex in the graph based on the following operation:

* Loop through all its neighbor vertices. If the adjacent vertex has color, put that color into a bucket (set).
* Choose the first color that is not in that bucket (collection) and assign it to the current vertex.
* Empty the bucket and go to the next vertex that’s not yet colored.

![](https://cdn-images-1.medium.com/max/2000/0*d2tx_zFC6IhmcT58.png)

This greedy algorithm is sufficient to solve the graph coloring. Although it doesn’t guarantee the minimum color, it ensures the upper bound on the number of colors assigned to the graph.

We iterate through the vertex and always choose the first color that doesn’t exist in its adjacent vertex. The order in which we start our algorithm matters.

If the vertices that we iterate have fewer incoming edges, we might need more color to color the graph. Therefore, there is another algorithm called the Welsh-Powell algorithm.

I want to explain how Welsh-Powell algorithm works. To prove that it will be guaranteed a minimum number of coloring in a graph, check out the resources below. There are plenty of things to dive deep into in this topic.

The algorithm is as follows:

1. Count the incoming edges on each vertex, and put them in descending order.
2. Choose the first vertex with the most incoming order and assign the vertices to a color — let’s call it vertex A.
3. Loop through the other vertices, assign the vertices a color if only if 1. It is **not** the adjacent of the vertex A. 2. The vertices have not yet been colored. 3. That vertex’s neighbor doesn’t have the same color as vertex A.
4. Keep doing step 3 until all the vertices are colored.

Now that you get a glimpse of what a graph coloring algorithm looks like, you may be wondering, what’s the use of doing this?

---

## Use Cases

Usually, the graph coloring algorithm is used to solve problems where you have a limited amount of resources and other restrictions. The color is just an abstraction of whatever resources you are trying to optimize. The graph is an abstraction of your problem.

Graphs are often model as real-world problems, and we can use algorithms to find any attributes within the graph to answer some of our questions.

Let’s look at some use cases for graph coloring.

---

## Scheduling Algorithm

Imagine you have a set of jobs to do and several workers. It would help if you assigned the workers to a job during a specific time slot. You can assign jobs in any order, but a pair of jobs may conflict in a timeslot — because they share the same resources. How do you assign jobs efficiently so that no jobs are conflicted? In this case, vertices can be jobs, and the edges can be the connection of two jobs if they rely on the same resources. If you have an unlimited number of workers, you can use the graph coloring algorithm to get the optimal time to schedule all jobs without conflict. In this case, the color will be the number of the worker. If the same color is assigned to the two vertices (jobs), that worker will handle those two jobs.

Another example is making a schedule or time table. You want to make an exam scheduler. Each subject will have a list of students and each student will take multiple classes. You want to make sure that the exams that you schedule don’t conflict with each other. In this case, the vertices can be classes, and there are edges between two classes if the same student is in both classes. The color in the graph, in this case, will be the number of time slots needed to schedule the exams. So, the same color on vertex A and vertex B means that A and B will be conducted in the same time slot.

Usually, there are shared resources in this type of problem, and we want to have a scheduler to ensure that no two entities in your system are conflicted. The color usually represents the time slot or workers.

---

## Map Coloring

![](https://cdn-images-1.medium.com/max/2000/0*fiE_-5ZC7cQZdSxN.gif)

Geographical map coloring is a problem where no two adjacent cities or states can be assigned the same color on a map. According to the [four-color theorem](https://mathworld.wolfram.com/Four-ColorTheorem.html#:~:text=The%20four%2Dcolor%20theorem%20states,conjectured%20the%20theorem%20in%201852.), four colors are sufficient to color any map. In this case, the vertex represents each region, and each of its adjacents can be classified as an edge.

---

## Sudoku Puzzle

![from ResearchGate-net](https://cdn-images-1.medium.com/max/2000/0*-aELwvDUPCYaizOI.png)

Sudoku is a variation of the graph coloring problem where every cell represents a vertex. An edge is formed within two vertices if they are in the same row, column and block. Each block will have a different color.

---

## Register Allocation for Compiler

A compiler is a program that transforms source code from high-level (Java, Scala) to machine level code. This is usually done in separate steps. One of the very last steps is to allocate registers to the most frequent values of the programs while putting other ones in memory. We can model the symbolic registers (variables) as vertices, and an edge is formed if two variables are needed simultaneously. If the graph can be colored in K color, then the variables can be stored in k registered.

There are many other use cases of graph coloring algorithms. I hope you learned something!

---

## Resources

There are some great resources on the Graph Coloring algorithm, as well as its use cases. If you are curious to learn more, check out the resources below:

* [Graph algorithms](https://www.cs.cornell.edu/courses/cs3110/2012sp/recitations/rec21-graphs/rec21.html)
* [Scheduling Parallel Tasks using Graph Coloring. (Conference) | OSTI.GOV](https://www.osti.gov/servlets/purl/1524829)
* [Graph Coloring | Set 1 (Introduction and Applications) — GeeksforGeeks](https://www.geeksforgeeks.org/graph-coloring-applications/?ref=rp)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
