> * 原文地址：[8 Useful Tree Data Structures Worth Knowing](https://towardsdatascience.com/8-useful-tree-data-structures-worth-knowing-8532c7231e8c)
> * 原文作者：[Vijini Mallawaarachchi](https://medium.com/@vijinimallawaarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/8-useful-tree-data-structures-worth-knowing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/8-useful-tree-data-structures-worth-knowing.md)
> * 译者：
> * 校对者：

# 8 Useful Tree Data Structures Worth Knowing

What comes to your mind when you think of a tree? Roots, branches and leaves? A big oak tree with roots, branches and leaves may come to your mind. Similarly, in computer science, the tree data structure has roots, branches and leaves, but it is drawn upside-down. A tree is a hierarchical data structure which can represent relationships between different nodes. In this article, I will briefly introduce you to 8 types of tree data structures.

#### Properties of a Tree

* A tree can contain no nodes or it can contain one special node called the **root** with zero or more subtrees.
* Every edge of the tree is directly or indirectly originated from the root.
* Every child has only one parent, but one parent can have many children.

![Fig 1. Terminology of trees](https://cdn-images-1.medium.com/max/2000/1*PWJiwTxRdQy8A_Y0hAv5Eg.png)

In this article, I will be briefly explaining the following 10 tree data structures with their usage.

1. General tree
2. Binary tree
3. Binary search tree
4. AVL tree
5. Red-black tree
6. Splay tree
7. Treap
8. B-tree

## 1. General Tree

A **general tree** is a tree data structure where there are no constraints on the hierarchical structure.

#### Properties

1. Follow properties of a tree.
2. A node can have any number of children.

![Fig 2. General tree](https://cdn-images-1.medium.com/max/2000/1*rInucvqb9X8bqM5yE143SQ.png)

#### Usage

1. Used to store hierarchical data such as folder structures.

## 2. Binary Tree

A **binary tree** is a tree data structure where the following properties can be found.

#### Properties

1. Follow properties of a tree.
2. A node can have at most two child nodes (children).
3. These two child nodes are known as the **left child** and **right child**.

![Fig 3. Binary tree](https://cdn-images-1.medium.com/max/2000/1*abunFFnReygaqVt93xNr2A.png)

#### Usage

1. Used by compilers to build syntax trees.
2. Used to implement expression parsers and expression solvers.
3. Used to store router-tables in routers.

## 3. Binary Search Tree

A **binary search tree** is a more constricted extension of a binary tree.

#### Properties

1. Follow properties of a binary tree.
2. Has a unique property known as the **binary-search-tree property**. This property states that the value (or key) of the left child of a given node should be less than or equal to the parent value and the value of the right child should be greater than or equal to the parent value.

![Fig 4. Binary search tree](https://cdn-images-1.medium.com/max/2000/1*jBgV9A847f_pHMbO67tcgw.png)

#### Usage

1. Used to implement simple sorting algorithms.
2. Can be used as priority queues.
3. Used in many search applications where data are constantly entering and leaving.

## 4. AVL tree

An **AVL tree** is a self-balancing binary search tree. This is the first tree introduced which automatically balances its height.

#### Properties

1. Follow properties of binary search trees.
2. Self-balancing.
3. Each node stores a value called a **balance factor** which is the difference in height between its left subtree and right subtree.
4. All the nodes must have a balance factor of -1, 0 or 1.

After performing insertions or deletions, if there is at least one node that does not have a balance factor of -1, 0 or 1 then rotations should be performed to balance the tree (self-balancing). You can read more about the rotation operations in my previous article from [**here**](https://towardsdatascience.com/self-balancing-binary-search-trees-101-fc4f51199e1d).

![Fig 5. AVL tree](https://cdn-images-1.medium.com/max/2000/1*aI575o1BBE3B4cAFUG73pw.png)

#### Usage

1. Used in situations where frequent insertions are involved.
2. Used in Memory management subsystem of the Linux kernel to search memory regions of processes during preemption.

## 5. Red-black tree

A red-black tree is a self-balancing binary search tree, where each node has a colour; red or black. The colours of the nodes are used to make sure that the tree remains approximately balanced during insertions and deletions.

#### Properties

1. Follow properties of binary search trees.
2. Self-balancing.
3. Each node is either red or black.
4. The root is black (sometimes omitted).
5. All leaves (denoted as NIL) are black.
6. If a node is red, then both its children are black.
7. Every path from a given node to any of its leaf nodes must go through the same number of black nodes.

![Fig 6. AVL tree](https://cdn-images-1.medium.com/max/2000/1*11zvjUozpAenuez03oUeYA.png)

#### Usage

1. As a base for data structures used in computational geometry.
2. Used in the **Completely Fair Scheduler** used in current Linux kernels.
3. Used in the **epoll** system call implementation of Linux kernel.

## 6. Splay tree

A **splay tree** is a self-balancing binary search tree.

#### Properties

1. Follow properties of binary search trees.
2. Self-balancing.
3. Recently accessed elements are quick to access again.

After performing a search, insertion or deletion, splay trees perform an action called **splaying** where the tree is rearranged (using rotations) so that the particular element is placed at the root of the tree.

![Fig 7. Splay tree search](https://cdn-images-1.medium.com/max/2000/1*w5MA0XAEk1vX1lef4cUbdA.png)

#### Usage

1. Used to implement caches
2. Used in garbage collectors.
3. Used in data compression

## 7. Treap

A **treap** (the name derived from **tree + heap**) is a binary search tree.

#### Properties

1. Each node has two values; a **key** and a **priority**.
2. The keys follow the binary-search-tree property.
3. The priorities (which are random values) follow the heap property.

![Fig 8. Treap (red coloured alphabetic keys follow BST property and blue coloured numeric values follow max heap order)](https://cdn-images-1.medium.com/max/2000/1*iH-zgLTHTHYe2E56aa2MWw.png)

#### Usage

1. Used to maintain authorization certificates in public-key cryptosystems.
2. Can be used to perform fast set operations.

## 8. B-tree

B tree is a self-balancing search tree and contains multiple nodes which keep data in sorted order. Each node has 2 or more children and consists of multiple keys.

#### Properties

1. Every node x has the following:
 * x.n (the number of keys)
 * x.keyᵢ (the keys stored in ascending order)
 * x.leaf (whether x is a leaf or not)
2. Every node x has (x.n + 1) children.
3. The keys x.keyᵢ separate the ranges of keys stored in each sub-tree.
4. All the leaves have the same depth, which is the tree height.
5. Nodes have lower and upper bounds on the number of keys that can be stored. Here we consider a value t≥2, called **minimum degree** (or **branching factor**) of the B tree.
 * The root must have at least one key.
 * Every other node must have at least (t-1) keys and at most (2t-1) keys. Hence, every node will have at least t children and at most 2t children. We say the node is **full** if it has (2t-1) keys.

![Fig 9. B-tree](https://cdn-images-1.medium.com/max/2788/1*GXwr5PFqDNOOk8ae-8W5zA.png)

#### Usage

1. Used in database indexing to speed up the search.
2. Used in file systems to implement directories.

## Final Thoughts

A cheat sheet for the time complexities of the data structure operations can be found in this [link](https://www.bigocheatsheet.com/).

I hope you found this article useful as a simple introduction to tree structures. I would love to hear your thoughts. 😇

Thanks a lot for reading!

Cheers! 😃

## References

 - [1] Introduction to Algorithms (Third Edition) by Thomas H. Cormen, Charles E. Leiserson, Ronald L. Livest and Clifford Stein.
 - [2] [https://en.wikipedia.org/wiki/List_of_data_structures](https://en.wikipedia.org/wiki/List_of_data_structures)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
