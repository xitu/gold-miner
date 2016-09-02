> * 原文地址：[Swift Algorithm Club: Swift Binary Search Tree Data Structure](https://www.raywenderlich.com/139821/swift-algorithm-club-swift-binary-search-tree-data-structure)
* 原文作者：[Kelvin Lau](https://www.raywenderlich.com/u/kelvin_lau)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cbangchen](https://github.com/cbangchen)
* 校对者：

[![SwiftAlgClub-BinarySearch-feature](https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature-250x250.png%20250w,%20https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature-320x320.png%20320w,%20https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature.png%20500w,%20https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature-32x32.png%2032w,%20https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature-50x50.png%2050w,%20https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature-64x64.png%2064w,%20https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature-96x96.png%2096w,%20https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature-128x128.png%20128w)](https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/SwiftAlgClub-BinarySearch-feature.png)

The [Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club) is an open source project on implementing data structures and algorithms in Swift.

[Swift 算法俱乐部]是一个致力于使用 Swift 来实现数据结构和算法的一个开源项目。

Every month, Chris Pilcher and I feature a cool data structure or algorithm from the club in a tutorial on this site. If you want to learn more about algorithms and data structures, follow along with us!

每个月，我和 Chris Pilcher 会在俱乐部网站上开建一个教程，来实现一个炫酷的数据结构或者算法。

In this tutorial, you’ll learn how about binary trees and binary search trees. The binary tree implementation was first implemented by [Matthijs Hollemans](https://www.raywenderlich.com/u/hollance), and the binary search tree was first implemented by [Nico Ameghino](https://github.com/nameghino).

在这个教程里面，你将学习到关于二叉树和二叉搜索树的知识。二叉树的实现首先是由 [Matthijs Hollemans](https://www.raywenderlich.com/u/hollance) 实现的，而二叉搜索树是由 [Nico Ameghino](https://github.com/nameghino) 实现的。

_Note:_ New to the Swift Algorithm Club? Check out our [getting started](https://www.raywenderlich.com/135533/join-swift-algorithm-club) post first.

_提示:_ 你是 Swift 算法俱乐部的新成员吗？如果是的话，来看看我们的 [指引文章](https://www.raywenderlich.com/135533/join-swift-algorithm-club) 吧。

## Getting Started

## 开始

The _Binary Tree_ is one of the most prevalent data structures in computer science. More advanced trees like the [Red Black Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Red-Black%20Tree) and the [AVL Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/AVL%20Tree) evolved from the binary tree.

在计算机科学中，_二叉树_ 是一种最普遍的数据结构。更先进的像 [红黑树](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Red-Black%20Tree) 和 [AVL 树](https://github.com/raywenderlich/swift-algorithm-club/tree/master/AVL%20Tree) 都是从二叉树中演技过来的。

Binary trees themselves evolved from the general purpose tree. If you don’t know what that is, check out last month’s tutorial on [Swift Tree Data Structure](https://www.raywenderlich.com/138190/swift-algorithm-club-swift-tree-data-structure).

二叉树自身则是从最通用的树演变过来的。如果你不知道那是什么，来看一下上个月关于 [Swift 树的数据结构](https://www.raywenderlich.com/138190/swift-algorithm-club-swift-tree-data-structure) 的文章吧。

Let’s see how this works.

让我们来看一下这是如何工作的。

## Binary Tree Data Structure

## 二叉树数据结构

A binary tree is a tree where each node has 0, 1, or 2 children. The important bit is that 2 is the max – that’s why it’s binary.

二叉树是一颗每个结点都有0，1或者2个子树的树。最重要的一点是子树的数量最多为2 - 这也是为什么它是二叉树的原因。

Here’s what it looks like:

这里我们来看一下二叉树是什么样子的：

![BinaryTree](https://cdn3.raywenderlich.com/wp-content/uploads/2016/07/BinaryTree.png)

## Terminology

## 术语

Before we dive into the code, it’s important that you understand some important terminology first.

在我们深入研究代码之前，首先去了解一些重要的术语也是很重要的。

On top of all the terms related to a general purpose tree, a binary tree adds the notion of left and right children.

上面所提到的关于通用树的情况，二叉树增加了左右子树的概念。

### Left Child

### 左子树

The _left_ child descends from the left side:

_左_ 子树从左边开始延伸：

![BinaryTree-2](https://cdn4.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2.png)

### Right Child

### 右子树

Surprisingly, the right side is the _right_ child:

令人惊讶的是，右边是 _右_ 子树：

![BinaryTree-2](https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2-1.png)

### Leaf Node

### 叶结点

If a node doesn’t have any children, it’s called a leaf node:

如果一个结点没有任何子树，就被称为叶结点：

![BinaryTree-2](https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2-2.png)

### Root

### 根

The _root_ is the node at the top of the tree (programmers like their trees upside down):

_根_ 一棵树的最顶端的结点（程序员喜欢倒立的树）：

![BinaryTree-2](https://cdn5.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2-3.png)

## Binary Tree Implementation in Swift

## 用 Swift 实现的二叉树

Like other trees, a binary tree composed of nodes. One way to represent a node is using a class (don’t enter this into a Playground yet, this is just an example):

就像其它树一样，一颗二叉树由结点组成。代表一个结点的方法就是使用一个类（暂时不要进入 Playground，这只是一个例子）：


    class Node {
      var value: T
      var leftChild: Node?
      var rightChild: Node?

      init(value: T) {
        self.value = value
      }
    }



In a binary tree, every node holds some data (`value`), and has a left and right child (`leftChild` and `rightChild`). In this implementation, the `leftChild` and `rightChild` are optionals, meaning they can be `nil`.

在一颗二叉树里面，每个结点存储着一些数据（`值`），而且左右边都有子树（`左子树` 和 `右子树`）。
在这种实现方式里，`左子树` 和 `右子树` 是可选的，意味着它们可以为 `nil`。

That’s the traditional way to build trees. However, the thrill seeker you are shall rejoice today, because you’ll try something new! :]

那是一种传统的构建树的方式，然而，作为一个寻求刺激的人，你应该觉得开心了，因为我们今天将要尝试一些新的东西！:]

### Value Semantics

### 语义值

One of the core ideas of Swift is using value types (like `struct` and `enum`) instead of reference types (like `class`) where appropriate. Well, creating a binary tree is a perfect case to use a value type – so in this tutorial, you’ll you’ll implement the binary tree as an enum type.

Swift 的一个核心创意就是直接使用类型值（例如 `struct`（结构） 和 `enum`（枚举））而不是在合适的地方使用引用类型（例如 `class`（类））。好吧，创建一棵树就是一个完美的使用类型值的例子 - 所以在这个教程里面，你将实现二叉树作为枚举类型。

Create a new Swift playground (this tutorial uses Xcode 8 beta 5) and add the following enum declaration:

创建一个新的 Swift playground（这个教程使用 Xcode 8 beta 5）然后加上下面的枚举声明：

```
enum BinaryTree<T> {
 
}
```

You’ve declared a enum named `BinaryTree`. The `` syntax declares this to be a _generic_ enum that allows it to infer it’s own type information at the call site.

你已经声明了一个名为 `BinaryTree`（二叉树） 的枚举。`` 语法声明了这是一个 _通用_ 的且允许推断调用站点类型信息的枚举。

### States

### 声明

Enumerations are rigid, in that they can only be in one state or another. Fortunately, this fits into the idea of binary trees quite elegantly. A binary tree is a finite set of nodes that is either empty, or consists of the value at the node and references to it’s left and right children.

枚举的声明是很严格的，所以只能是唯一声明。幸运的是，这非常符合二叉树的概念。二叉树是一个有限结点的集合，这些结点或者为空，或者是由一个值和一个指向其他结点的指针所构成。

Update your enum accordingly:

相应的更新你的枚举：

    enum BinaryTree {
      case empty
      case node(BinaryTree, T, BinaryTree)
    }

If you’re coming from another programming language, the `node` case may seem a bit foreign. Swift enums allow for _associated values_, which is a fancy term for saying you can attach stored properties with a case.

如果你有其他编程语言的编程经验，这个 `node`（结点）的例子可能相比起来有点不同。Swift 的枚举允许 _associated values_（相关的值），这是一个比较奇特的术语，意味着你可以和一个已存储的属性相互绑定。

In `node(BinaryTree, T, BinaryTree)`, the parameter types inside the brackets correspond to the left child, value, and the right child, respectively.

在 `node(BinaryTree, T, BinaryTree)` 里，括号内的参数分别对应着左子树，值，右子树。

That’s a fairly compact way of modelling a binary tree. However, you’re immediately greeted with a compiler error:

这是一种紧凑的二叉树构建方式。然而，你马上就会看到一个编译器提出的错误：

    Recursive enum 'BinaryTree' is not marked 'indirect'



Xcode should make an offer to fix this for you. Accept it, and your enum should now look like this:

Xcode 应该提供了一种解决这个错误的方法。接受它，然后你的枚举应该看起来像这样：

    indirect enum BinaryTree {
      case empty
      case node(BinaryTree, T, BinaryTree)
    }



### Indirection

### 间接

Enumerations in Swift are value types. When Swift tries to allocate memory for value types, it needs to know exactly how much memory it needs to allocate.

Swift 中的枚举是一种类型值。当 Swift 试图去为类型值分配内存的时候，它需要去确切的知道所需要被分配的内存大小。

The enumeration you’ve defined is a _recursive_ enum. That’s an enum that has an associated value that refers to itself. Recursive value types have a indeterminable size.

你所定义的枚举是一种 _recursive_ （递归）枚举。那是一种有着一个指向自身的相关值（associated value）的一种枚举。递归类型的类型值无法被确定大小。

![Screen Shot 2016-08-01 at 1.27.40 AM](https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-01-at-1.27.40-AM-439x320.png%20439w,%20https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-01-at-1.27.40-AM-650x474.png%20650w,%20https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-01-at-1.27.40-AM.png%20804w)

So you’ve got a problem here. Swift expects to know exactly how big the enum is, but the recursive enum you’ve created doesn’t expose that information.

所以在这里你有一个问题。Swift 希望能准确的知道枚举的大小，然而你所创建的递归类型的枚举却没有暴露这个消息。

Here’s where the `indirect` keyword comes in. `indirect` applies a layer of _indirection_ between two value types. This introduces a thin layer of reference semantics to the value type.

这就是 `indirect`（间接）这个关键字的由来。`indirect`（间接）实现了一个两个类型值之间的 _indirection（间接层）_。这引出了语义与类型值之间的一层薄膜。

The enum now holds references to it’s associated values, rather than their value. References have a constant size, so you no longer have the previous problem.

这个枚举现在引用的是它的关联值而不是自身的值。引用值有着一个确切的大小，所以就不再存在之前的问题。

While the code now compiles, you can be a little bit more concise. Update `BinaryTree` to the following:

在代码编译的过程中，你能够更加的简洁。将 `BinaryTree`（二叉树）更新到下面的样子：

    enum BinaryTree {
      case empty
      indirect case node(BinaryTree, T, BinaryTree)
    }



Since only the `node` case is recursive, you only need to apply `indirect` to that case.

因为只有 `node`（结点）是递归的，所以你只需要在结点处应用 `indirect`（间接）即可。

## Example: Sequence of Arithmetical Operations

## 例子：算数操作序列

An interesting exercise to check out is to model a series of calculations using a binary tree. Take this for an example for modelling `(5 * (a - 10)) + (-4 * (3 / b))`:

检验这一点的有一个有趣的例子是使用一棵二叉树来进行一系列的计算。我们来进行下面这个例子的运算：`(5 * (a - 10)) + (-4 * (3 / b))`：

![Operations](https://cdn4.raywenderlich.com/wp-content/uploads/2016/07/Operations.png)

Write the following at the end of your playground file:

在你的 playground 文件里写下下面的语句：

    // leaf nodes
    let node5 = BinaryTree.node(.empty, "5", .empty)
    let nodeA = BinaryTree.node(.empty, "a", .empty)
    let node10 = BinaryTree.node(.empty, "10", .empty)
    let node4 = BinaryTree.node(.empty, "4", .empty)
    let node3 = BinaryTree.node(.empty, "3", .empty)
    let nodeB = BinaryTree.node(.empty, "b", .empty)

    // intermediate nodes on the left
    let Aminus10 = BinaryTree.node(nodeA, "-", node10)
    let timesLeft = BinaryTree.node(node5, "*", Aminus10)

    // intermediate nodes on the right
    let minus4 = BinaryTree.node(.empty, "-", node4)
    let divide3andB = BinaryTree.node(node3, "/", nodeB)
    let timesRight = BinaryTree.node(minus4, "*", divide3andB)

    // root node
    let tree = BinaryTree.node(timesLeft, "+", timesRight)



You need to build up the tree in reverse, starting with the leaf nodes and working your way up to the top.

你需要反向构建这棵树，从叶结点开始一直到树的顶部。

### CustomStringConvertible

### CustomStringConvertible 协议

Verifying a tree structure can be hard without any console logging. Swift has a handy protocol named `CustomStringConvertible`, which allows you define a custom output for `print` statements. Add the following code just below your `BinaryTree` enum:

如果没有控制台输出很难去验证一棵树的结构。Swift 有一个名为 `CustomStringConvertible` 的协议可以允许自定义一个 `print` 输出声明。在你的 `BinaryTree` 枚举下加上下面的语句：

    extension BinaryTree: CustomStringConvertible {
      var description: String {
        switch self {
        case let .node(left, value, right):
          return "value: \(value), left = [" + left.description + "], right = [" + right.description + "]"
        case .empty:
          return ""
        }
      }
    }



Print the tree by writing the following at the end of the file:

通过在文件的最后编写下面的语句来打印这棵树：

```
print(tree)
```

You should see something like this:

你应该可以看到类似下面的语句：

    value: +, left = [value: *, left = [value: 5, left = [], right = []], right = [value: -, left = [value: a, left = [], right = []], right = [value: 10, left = [], right = []]]], right = [value: *, left = [value: -, left = [], right = [value: 4, left = [], right = []]], right = [value: /, left = [value: 3, left = [], right = []], right = [value: b, left = [], right = []]]]


With a bit of imagination, you can see the tree structure. ;-) It helps if you indent it:

配合一些联想，你可以看到这棵树的结构。 ;-) 缩进一下可以帮助你的理解：

    value: +, 
        left = [value: *, 
            left = [value: 5, left = [], right = []], 
            right = [value: -, 
                left = [value: a, left = [], right = []], 
                right = [value: 10, left = [], right = []]]], 
        right = [value: *, 
            left = [value: -, 
                left = [], 
                right = [value: 4, left = [], right = []]], 
            right = [value: /, 
                left = [value: 3, left = [], right = []], 
                right = [value: b, left = [], right = []]]]



### Getting The Count

### 得到数值

Another useful feature is being able to get the number of nodes in the tree. Add the following just inside your `BinaryTree` enumeration:

另一个有用的特性就是可以得到树的结点。在你的 `BinaryTree` 枚举里面加上下面的语句：

    var count: Int {
      switch self {
      case let .node(left, _, right):
        return left.count + 1 + right.count
      case .empty:
        return 0
      }
    }



Test it out by adding this to the end of your playground:

通过在你的 playground 程序的最后加上下面的语句来进行测试：

```
tree.count
```

You should see the number 12 in the sidebar, since there are 12 nodes in the tree.

你应该可以看到侧边栏有数字 12，因为这棵树有12个结点。

Great job making it this far. Now that you’ve got a good foundation for binary trees, it’s time to get acquainted with the most popular tree by far – the _Binary Search Tree_!

已经完成到这里了，非常棒。现在你已经有了关于二叉树的良好基础，是时候去了解目前为止最受欢迎的二叉树了 - _Binary Search Tree_（二叉搜索树）!

## Binary Search Trees

## 二叉搜索树

A binary search tree is a special kind of binary tree (a tree in which each node has at most two children) that performs insertions and deletions such that the tree is always sorted.

二叉搜索树是一种特殊的二叉树（普通的二叉树每个结点最多有 2 个子树），这种特殊的二叉树可以执行插入和删除操作，使得这棵树总是按序排列。

### “Always Sorted” Property

### “总是按序排列” 的属性

Here is an example of a valid binary search tree:

这里是一个关于一棵有效二叉搜索树的例子：

![Tree1](https://cdn5.raywenderlich.com/wp-content/uploads/2016/07/Tree1.png)

Notice how each left child is smaller than its parent node, and each right child is greater than its parent node. This is the key feature of a binary search tree.

可以注意到每个子树的数值小于它的父结点的数值，每个右子树的数值大于父结点的数值。这就是二叉搜索树的主要特性。

For example, 2 is smaller than 7 so it goes on the left; 5 is greater than 2 so it goes on the right.

举个例子，2 比 7 小，所以放在左边，5 比 2 大，所以放在右边。

### Insertion

### 插入

When performing an insertion, starting with the root node as the current node:

当执行一个插入操作的时候，将根结点当成当前结点：

*   _If the current node is empty_, you insert the new node here.
*   _If the new value is smaller_, you go down the left branch.
*   _If the new value is greater_, you go down the right branch.

* 	_如果当前结点为空_ ，你在这里插入一个新的结点。
* 	_如果新的值更小_ ，你沿着左边的分支向下。
* 	_如果新的值更大_ ，你沿着右边的分支向下。

You traverse your way down the tree until you find an empty spot where you can insert the new value.

你向下遍历这棵树，直到你找到一个空的地方可以插入新值。

For example, imagine you want to insert the value 9 to the above tree:

例如，假如你想要插入一个值为 9 的数到上面的树中：

1.  Start at the root of the tree (the node with the value 7), and compare it to the new value 9.
2.  9 > 7, so you go down the right branch
3.  Compare 9 with 10\. Since 9
4.  This left branch is empty, thus you’ll insert a new node for 9 at this location.

1.	从树的根结点开始（根结点数值为 7），并与新的值 9 进行比较。
2. 	9 大于 7，所以你沿着右边向下。
3.	比较 9 和 10，因为 9 小于 10，所以你沿着左边向下。
4. 	这个左分支是空的，因此你要插入一个新的结点然后放置这个 9 的数值。


The new tree now looks like this:

这棵新的树现在看起来像这样：

![Tree2](https://cdn2.raywenderlich.com/wp-content/uploads/2016/07/Tree2.png)

Here’s another example. Imagine you want to insert 3 to the above tree:

这里有另一个例子。假如你想插入一个值为 3 的数到上面的树中：

1.  Start at the root of the tree (the node with the value 7), and compare it to the new value 3.
2.  3
3.  Compare 3 with 2\. Since 3 > 2, go down the right branch.
4.  Compare 3 with 5\. Since 3
5.  The left branch is empty, thus you’ll insert a new node for 3 at this location.

1.	从树的根结点开始（根结点数值为 7），并与新的值 3 进行比较。
2. 	3 小于 7，所以你沿着左边向下。
3.	比较 3 和 2，因为 3 大于 2，所以你沿着右边向下。
4. 	这个右分支是空的，因此你要插入一个新的结点然后放置这个 3 的数值。

The new tree now looks like this:

这棵新的树现在看起来像这样：

![added](https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/added-308x320.png)

There is always only one possible place where the new element can be inserted in the tree. Finding this place is usually pretty quick. It takes _O(h)_ time, where _h_ is the height of the tree.

最后这棵树上，总是只有一个可能插入新元素的地方。找到这个可以插入新元素的地方总是比较快的。这个过程会花费 _O(h)_ 的时间，而 _h_ 是树的高度。

_Note:_ If you’re not familiar with the height of a tree, check out the previous article on [Swift Trees.](https://www.raywenderlich.com/138190/swift-algorithm-club-swift-tree-data-structure)

_注意：_ 如果你对于树的高度不熟悉，来看一下之前发的 [Swift Trees（Swift 的树）](https://www.raywenderlich.com/138190/swift-algorithm-club-swift-tree-data-structure) 这篇文章吧。

### Challenge: Implementing Insertion

### 挑战：实现插入

Now that you’ve got an idea of how insertion works, it’s implementation time. Add the following method to your `BinaryTree` enum:

现在你已经知道了应该在哪里插入数值了，是时候来实现这个过程了。在你的 `BinaryTree`（二叉树）枚举中加入下面的方法：

    // 1\. 
    mutating func naiveInsert(newValue: T) {
      // 2.
      guard case .node(var left, let value, var right) = self else {
        // 3\. 
        self = .node(.empty, newValue, .empty)
        return 
      }

      // 4\. TODO: Implement rest of algorithm!

    }



Let’s go over this section by section:

让我们一段一段的来复习一下：

1.  Value types are immutable by default. If you create a method that tries to mutate something within the value type, you’ll need to explicitly specify that by prepending the `mutating` keyword in front of your method.
2.  You’re using the `guard` statement to expose the left child, current value, and right child of the current node. If this node is `empty`, then `guard` will fail into it’s `else` block.
3.  In this block, `self` is `empty`. You’ll insert the new value here.
4.  This is where you come in – hang tight for a second.

1.	类型值默认是不变的。如果你创建了尝试在类型值中改变什么东西的方法的话，你会需要通过显式使用 `mutating`（可变）关键词来标记你的方法。
2. 	你应该在当前结点中使用  `guard` 声明语句来暴露你的左子树，当前值和右子树。而如果这个结点是 `empty`（空）的，那 `guard` 就会失败然后跳入它的 `else` block 语句中去。
3. 	在这个 block 中，`self`（自身对象） 是 `empty`（空）的。你将会在这里插入一个新的值。
4. 	这就是你进来的地方 - 稍等一下。

In a moment, you will try to implement section 4 based on the algorithm discussed above. This is a great exercise not only for understanding binary search trees, but also honing your recursion skills.

基于之前所提到的算法知识，一会你将尝试着去实现上面的四个段落中的内容。这对于你是一个很好的锻炼，不单单是理解二叉搜索树，还包括磨练你的递归技能。

But before you do, you need to make a change to the `BinaryTree` signature. In section 4, you’ll need to compare whether the new value with the old value, but you can’t do this with the current implementation of the binary tree. To fix this, update the `BinaryTree` enum to the following:

但在你开始做之前，你需要对 `BinaryTree` 的签名做一点修改。在第四个段落处，你需要对比新值和旧值，但在目前的二叉树实现机制中你无法做到这一点。为了修复这一个问题，把你的 `BinaryTree`（二叉树）枚举更新成下面的样子：

    enum BinaryTree {
      // stuff inside unchanged
    }



The `Comparable` protocol enforces a guarantee that the type you’re using to build the binary tree can be compared using the comparison operators, such as the `operator.`

`Comparable`（可对比的）协议确保你所构建的二叉树可以使用比较运算符进行值的对比，就像使用 `operator`（操作）一样。

Now, go ahead and try to implement section #4 based on the algorithm above. Here it is again for your reference:

现在，根据之前所提到的算法知道，继续尝试实现第四个段落的内容。下面的内容可以作为参考：

*   _If the current node is empty_, you insert the new node here. Done!
*   _If the new value is smaller_, you go down the left branch. You need to do this.
*   _If the new value is greater_, you go down the right branch. You need to do this.

* 	_如果当前结点为空_ ，你在这里插入一个新的结点，搞定。
* 	_如果新的值更小_ ，你沿着左边的分支向下，你需要这样做。
* 	_如果新的值更大_ ，你沿着右边的分支向下，你需要这样做。

If you get stuck, you can check the solution below.

如果你陷入了困境，你可以查看一下下面提供的解决方案。

```
// 4. TODO: Implement naive algorithm!
if newValue < value {
  left.naiveInsert(newValue: newValue)
} else {
  right.naiveInsert(newValue: newValue)
}
```

### Copy on Write

### 写时拷贝

Though this is a great implementation, it won't work. Test this by writing the following at the end of your playground:

虽然这是一个很好的实现，但它不起作用。在你的 playground 程序中写入下面的语句来测试这个功能：

    var binaryTree: BinaryTree = .empty
    binaryTree.naiveInsert(newValue: 5) // binaryTree now has a node value with 5
    binaryTree.naiveInsert(newValue: 7) // binaryTree is unchanged
    binaryTree.naiveInsert(newValue: 9) // binaryTree is unchanged



![Screen Shot 2016-08-10 at 8.55.46 PM](https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-10-at-8.55.46-PM-328x320.png%20328w,%20https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-10-at-8.55.46-PM-513x500.png%20513w,%20https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-10-at-8.55.46-PM-32x32.png%2032w,%20https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-10-at-8.55.46-PM-50x50.png%2050w,%20https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/Screen-Shot-2016-08-10-at-8.55.46-PM.png%20628w)

Copy-on-write is the culprit here. Every time you try to mutate the tree, a new copy of the child is created. This new copy is not linked with your old copy, so your initial binary tree will never be updated with the new value.

写时拷贝技术就是这里的罪魁祸首。每次你尝试着去修改这棵树的时候，一个新的子树的拷贝就会被创建。这个新的拷贝是不会链接到你的旧的拷贝的，所以你的最开始的二叉树是永远不会被新的值所修改的。

This calls for a different way to do things. Write the following at the end of the `BinaryTree` enum:

这里需要一种不同的方式来实现一些事情。在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

    private func newTreeWithInsertedValue(newValue: T) -> BinaryTree {
      switch self {
      // 1
      case .empty:
        return .node(.empty, newValue, .empty)
      // 2 
      case let .node(left, value, right):
        if newValue < value {
          return .node(left.newTreeWithInsertedValue(newValue: newValue), value, right)
        } else {
          return .node(left, value, right.newTreeWithInsertedValue(newValue: newValue))
        }
      }
    }



This is a method that returns a new tree with the inserted element. The code is relatively straightforward:

这是一个会根据所插入新元素返回一个新的树的方法。代码是相对简单的：

1.  If the tree is empty, you want to insert the new value here.
2.  If the tree isn't empty, you'll need to decide whether to insert into the left or right child.

1.	如果这棵树是空的，你想要去插入一个新值。
2. 	如果这棵树不是空的，你将会需要去决定把新值插入到左子树或者右子树。

Write the following method inside your `BinaryTree` enum:

在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

    mutating func insert(newValue: T) {
      self = newTreeWithInsertedValue(newValue: newValue)
    }



Test your code by replacing the test lines at the bottom of your playground:

通过更换你的 playground 程序最底下的测试语句来进行测试：

    binaryTree.insert(newValue: 5) 
    binaryTree.insert(newValue: 7) 
    binaryTree.insert(newValue: 9)



You should end up with the following tree structure:

你应该可以得到下面的树结构：

    value: 5, 
        left = [], 
        right = [value: 7, 
            left = [], 
            right = [value: 9, 
                left = [], 
                right = []]]



Congratulations - now you've got insertion working!

恭喜 - 现在你已经可以进行插入工作了。

### Insertion Time Complexity

### 插入时间复杂度

As discussed in the spoiler section, you need to create a new copy of the tree every time you make an insertion. Creating a new copy requires going through all the nodes of the previous tree. This gives the insertion method a time complexity of _O(n)_.

就像在剧透过的章节里面说到的，每次进行一个新的插入操作的时候，你都需要创建一份树的拷贝。创建一份拷贝需要遍历之前的所有结点。这会为这个插入方法增加 _O(n)_ 的时间复杂度。

_Note:_ Average time complexity for a binary search tree for the traditional implementation using classes is _O(log n)_, which is considerably faster. Using classes (reference semantics) won't have the copy-on-write behaviour, so you'll be able to insert without making a complete copy of the tree.

_提示：_ 一颗使用传统类实现的二叉搜索树的平均时间复杂度是 _O(log n)_，这是相当快的。使用类（引用语义）是不会有写时拷贝的行为的，所以你将不去做树的复杂拷贝也能实现插入操作。

## Traversal Algorithms

## 遍历算法

Traversal algorithms are fundamental to tree related operations. A traversal algorithm goes through all the nodes in a tree. There are three main ways to traverse a binary tree:

遍历算法是树的相关操作的基础。一个遍历算法会经历一棵树的所有结点。下面是三种遍历一颗树的主要方式：

### In-order Traversal

### 顺序遍历

In-order traversal of a binary search tree is to go through the nodes in ascending order. Here's what it looks like to perform an in-order traversal:

顺序遍历是按照升序来遍历一颗二叉搜索树的。下面是一个顺序遍历看起来的样子：

![Traversing](https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/Traversing.png)

Starting from the top, you head to the left as much as you can. If you can't go left anymore, you'll visit the current node and attempt to traverse to the right side. This procedure continues until you traverse through all the nodes.

从顶部开始，沿着左边尽可能的向下。当你到达左边的底部，你将会看到当前的值，这个时候你尝试着遍历到右边。这个过程将会持续下去直到你遍历完整棵树。

Write the following inside your `BinaryTree` enum:

在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

    func traverseInOrder(process: @noescape (T) -> ()) {
      switch self {
      // 1
      case .empty:
        return 
      // 2
      case let .node(left, value, right):
        left.traverseInOrder(process: process)
        process(value)
        right.traverseInOrder(process: process)
      }
    }



This code is fairly straightforward:

这段代码是相当简单的：

1.  If the current node is empty, there's no way to go down further. You'll simply return here.
2.  If the current node is non empty, then you can go down further. The definition of in-order traversal is to go down the left side, visit the node, and then the right side.

1.	如果这个结点是空的，就没有方法继续前进下去。你将会在这里简单的返回。
2. 	如果这个结点不会空，那你将可以前进的更深一点。顺序遍历的定义是首先走左子树，然后是结点，最后是右子树。

To see this in action, you'll create the binary tree shown above. Delete all the test code at the bottom of your playground and replace it with the following:



看到这里，你将会创建上面提到的二叉树。删除你的 playground 程序最底下所有的测试代码并更换成下面的语句：

    var tree: BinaryTree = .empty
    tree.insert(newValue: 7)
    tree.insert(newValue: 10)
    tree.insert(newValue: 2)
    tree.insert(newValue: 1)
    tree.insert(newValue: 5)
    tree.insert(newValue: 9)

    tree.traverseInOrder { print($0) }



You've created a binary search tree using your insert method. `traverseInOrder` will go through your nodes in ascending order, passing the value in each node to the trailing closure.

你已经创建了一棵可以使用你的插入方法的二叉搜索树。`traverseInOrder` 将会在按照升序遍历你的结点后，传递每个结点的值给结尾闭包。

Inside the trailing closure, you're printing the value that was passed in by the traversal method. `$0` is a shorthand syntax that references the parameter that is passed in to the closure.

在这个结尾闭包里，你将打印通过你的遍历方法传递过来的值。`$0` 是一种对于传递到闭包的元素进行引用到一种缩写语法。

You should see the following output in your console:

你将会看到在你的控制台会有这样的输出：

```
1
2
5
7
9
10
```

### Pre-order Traversal

### 前序遍历

Pre-order traversal of a binary search tree is to go through the nodes whilst visiting the current node first. The key here is calling `process` before traversing through the children. Write the following inside your `BinaryTree` enum:

二叉搜索树的前序遍历是一种在遍历过程中首先遍历节点的遍历方法。这里的关键是在遍历子树之前首先调用  `process` 方法。在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

    func traversePreOrder( process: @noescape (T) -> ()) {
      switch self {
      case .empty:
        return
      case let .node(left, value, right):
        process(value)
        left.traversePreOrder(process: process)
        right.traversePreOrder(process: process)
      }
    }



### Post-order Traversal

### 后序遍历

Post-order traversal of a binary search tree is to visit the nodes only after traversing through it's left and right children. Write the following inside your `BinaryTree` enum:

二叉搜索树的后序遍历是一种在遍历过程中首先遍历左子树和右子树的遍历方法。在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

    func traversePostOrder( process: @noescape (T) -> ()) {
      switch self {
      case .empty:
        return
      case let .node(left, value, right):
        left.traversePostOrder(process: process)
        right.traversePostOrder(process: process)
        process(value) 
      }
    }



These 3 traversal algorithms serve as a basis for many complex programming problems. Understanding them will prove useful for many situations, including your next programming interview!

这三种遍历方法是很多复杂的编程问题的基础。理解它们被证明在很多情况下都是有用的，包括你的下一个编程面试。

### Mini Challenge

### 小小的挑战

What is the time complexity of the traversal algorithms?

遍历算法的时间复杂度是什么?

The time complexity is _O(n)_, where n is the number of nodes in the tree.

时间复杂度是 _O(n)_ ，这里的 _n_ 指的是树的结点数。

This should be obvious, since the idea of traversing a tree is to go through all the nodes!  

这应该是很明显的，因为这个遍历的想法就是要遍历一棵树的所有结点。

## Searching

## 搜索

As the name suggests, a binary search tree is known best for facilitating efficient searching. A proper binary search tree will have all it's left child less than it's parent node, and all it's right children equal or greater than it's parent node.

就像二叉搜索树的名字提示我们的一样，一棵二叉搜索树是已知的最好的高效搜索方式。一棵合格的二叉搜索树的所有的左子树的数目会小于它的父结点的数目，而它的所有右结点的数目会大于或等于它的父结点的数目。

By exploiting this guarantee, you'll be able to determine which route to take - the left child, or the right child - to see if your value exists within the tree. Write the following inside your `BinaryTree` enum:

利用这个前提，你就可以知道决定选择哪条路线 - 左边或者右边 - 去知道你所要的值是否存在于这棵树上。在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

    func search(searchValue: T) -> BinaryTree? {
      switch self {
      case .empty:
        return nil
      case let .node(left, value, right):
        // 1
        if searchValue == value {
          return self
        }

        // 2
        if searchValue < value {
          return left.search(searchValue: searchValue)
        } else {
          return right.search(searchValue: searchValue)
        }
      }
    }



Much like the traversal algorithms, searching involves traversing down the binary tree:

很想遍历算法，搜索包括着遍历二叉树：

1.  If the current value matches the value you're searching for, you're done searching. Return the current subtree
2.  If execution continues to this point, it means you haven't found the value. You'll need to decide whether you want to go down to the left or right. You'll decide using the rules of the binary search tree.

1.	如果你的当前值与你想要搜索的值相同，停止搜索。返回当前子树。
2. 	如果你继续执行到这个点，说明你还没有找到你的值。你将会需要去决定往左子树的方向前进或者往右子树的方向前进。你会使用二叉搜索树的规则来决定。

Unlike the traversal algorithms, the search algorithm will traverse only 1 side at every recursive step. On average, this leads to a time complexity of _O(log n)_, which is considerably faster than the _O(n)_ traversal.

与遍历算法不同，每一个递归步骤搜索算法只会遍历一次。平均而言,这会导致时间复杂度为 _O(o(log n))_ ,远远大于 _O(n)_ 时间复杂度的遍历操作。

You can test this by adding the following to the end of your playground:

在你的 playground 文件里写下下面的语句来进行测试：

    tree.search(searchValue: 5)



## Where To Go From Here?

## 从这里开始去哪里？

I hope you enjoyed this tutorial on making a Swift Binary Tree data structure!

我希望你喜欢这个构建 Swift 二叉树数据结构的教程！

Here is a [Swift playground](https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftBinaryTree.playground.zip) with the above code. You can also find alternative implementations and further discussion in the [Binary Search Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search%20Tree) section of the Swift Algorithm Club repository.

这里是一个关于上述代码的 [Swift playground](https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftBinaryTree.playground.zip)  文件。你也可以在 Swift 算法俱乐部的 [Binary Search Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search%20Tree) 章节里面找到关于二叉树可替代的实现方式和进行进一步的讨论。

This was just one of the many algorithm clubs focused on the Swift Algorithm Club repository. If you're interested in more, check out the [repo](https://github.com/raywenderlich/swift-algorithm-club).

这只是 Swift 算法俱乐部所关注的其中一个算法实现。如果你感兴趣，请查看 [repo](https://github.com/raywenderlich/swift-algorithm-club)。

It's in your best interest to know about algorithms and data structures - they're solutions to many real world problems, and are frequently asked as interview questions. Plus it's fun!

这是你的最好的了解算法和数据结构的机会 - 它们解决很多现实问题，和经常被问及的面试问题。而且很有趣！

So stay tuned for many more tutorials from the Swift Algorithm club in the future. In the meantime, if you have any questions on implementing trees in Swift, please join the forum discussion below!

所以后面请持续关注来自 Swift 算法俱乐部的教程。如果你对于在 Swift 中实现二叉树有任何问题，请加入下面的论坛进行讨论。

_Note:_ The [Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club) is always looking for more contributors. If you've got an interesting data structure, algorithm, or even an interview question to share, don't hesitate to contribute! To learn more about the contribution process, check out our [Join the Swift Algorithm Club](https://www.raywenderlich.com/135533/join-swift-algorithm-club) article.

_注意：_ [Swift 算法俱乐部](https://github.com/raywenderlich/swift-algorithm-club) 一直在寻找更多的贡献者。如果你对于数据结构，算法有兴趣，或者甚至是有一个面试问题想要分享，不要犹豫，来贡献给大家！了解更多贡献流程，请查看 [加入算法俱乐部](https://www.raywenderlich.com/135533/join-swift-algorithm-club) 这篇文章。

