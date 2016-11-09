> * 原文地址：[Swift Algorithm Club: Swift Binary Search Tree Data Structure](https://www.raywenderlich.com/139821/swift-algorithm-club-swift-binary-search-tree-data-structure)
* 原文作者：[Kelvin Lau](https://www.raywenderlich.com/u/kelvin_lau)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cbangchen](https://github.com/cbangchen)
* 校对者：[mypchas6fans](https://github.com/mypchas6fans) [Zheaoli](https://github.com/Zheaoli)

# 实现二叉树以及二叉树遍历数据结构

![](http://ww1.sinaimg.cn/large/7853084cgw1f7fm5z89h4j20dw0dwgm4.jpg)

[Swift 算法俱乐部](https://github.com/raywenderlich/swift-algorithm-club) 是一个致力于使用 Swift 来实现数据结构和算法的一个开源项目。

每个月，我和 Chris Pilcher 会在俱乐部网站上开建一个教程，来实现一个炫酷的数据结构或者算法。如果你想要去学习更多关于算法和数据结构的知识，请跟随我们的脚步吧。

在这个教程里面，你将学习到关于二叉树和二叉搜索树的知识。二叉树的实现首先是由 [Matthijs Hollemans](https://www.raywenderlich.com/u/hollance) 实现的，而二叉搜索树是由 [Nico Ameghino](https://github.com/nameghino) 实现的。

**提示：** 你是 Swift 算法俱乐部的新成员吗？如果是的话，来看看我们的 [指引文章](https://www.raywenderlich.com/135533/join-swift-algorithm-club) 吧。

## 开始

在计算机科学中，**二叉树** 是一种最普遍的数据结构。更先进的像 [红黑树](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Red-Black%20Tree) 和 [AVL 树](https://github.com/raywenderlich/swift-algorithm-club/tree/master/AVL%20Tree) 都是从二叉树中演进过来的。

二叉树自身则是从最通用的树演变过来的。如果你不知道那是什么，来看一下上个月关于 [Swift 树的数据结构](https://www.raywenderlich.com/138190/swift-algorithm-club-swift-tree-data-structure) 的文章吧。

让我们来看一下这是如何工作的。

## 二叉树数据结构

二叉树是一颗每个结点都有 0，1 或者 2 个子树的树。最重要的一点是子树的数量最多为 2 - 这也是为什么它是二叉树的原因。

这里我们来看一下二叉树是什么样子的：

![BinaryTree](https://cdn3.raywenderlich.com/wp-content/uploads/2016/07/BinaryTree.png)

## 术语

在我们深入研究代码之前，首先去了解一些重要的术语也是很重要的。

在上面提到的通用树的基础上，二叉树增加了左右子树的概念。

### 左子树

**左** 子树从左边开始延伸：

![BinaryTree-2](https://cdn4.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2.png)

### 右子树

令人惊讶的是，右边是 **右** 子树：

![BinaryTree-2](https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2-1.png)

### 叶结点

如果一个结点没有任何子树，就被称为叶结点：

![BinaryTree-2](https://cdn3.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2-2.png)

### 根

**根** 是一棵树的最顶端的结点（程序员喜欢倒立的树）：

![BinaryTree-2](https://cdn5.raywenderlich.com/wp-content/uploads/2016/08/BinaryTree-2-3.png)

## 用 Swift 实现的二叉树

就像其它树一样，一颗二叉树由结点组成。代表一个结点的方法就是使用一个类（暂时不要进入 Playground，这只是一个例子）：


    class Node<T> {
      var value: T
      var leftChild: Node?
      var rightChild: Node?

      init(value: T) {
        self.value = value
      }
    }


在一颗二叉树里面，每个结点存储着一些数据（`值`），而且左右边都有子树（`左子树` 和 `右子树`）。
在这种实现方式里，`左子树` 和 `右子树` 是可选的，意味着它们可以为 `nil`。

那是一种传统的构建树的方式，然而，作为一个寻求刺激的人，你应该觉得开心了，因为我们今天将要尝试一些新的东西！:]

### 语义值

Swift 的一个核心创意就是直接使用类型值（例如 `struct`（结构） 和 `enum`（枚举））而不是在合适的地方使用引用类型（例如 `class`（类））。好吧，创建一棵树就是一个完美的使用类型值的例子 - 所以在这个教程里面，你将实现二叉树作为枚举类型。

创建一个新的 Swift playground（这个教程使用 Xcode 8 beta 5）然后加上下面的枚举声明：

    enum BinaryTree<T> {

    }

你已经声明了一个名为 `BinaryTree`（二叉树） 的枚举。`` 语法声明了这是一个 **通用** 的且允许推断调用站点类型信息的枚举。

### 声明

枚举的声明是很严格的，所以只能是唯一声明。幸运的是，这非常符合二叉树的概念。二叉树是一个有限结点的集合，这些结点或者为空，或者是由一个值和一个指向其他结点的指针所构成。

相应的更新你的枚举：

    enum BinaryTree<T> {
      case empty
      case node(BinaryTree, T, BinaryTree)
    }

如果你有其他编程语言的编程经验，这个 `node`（结点）的例子可能相比起来有点不同。Swift 的枚举允许 _associated values_（相关的值），这是一个比较奇特的术语，意味着你可以和一个已存储的属性相互绑定。

在 `node(BinaryTree, T, BinaryTree)` 里，括号内的参数分别对应着左子树，值，右子树。

这是一种紧凑的二叉树构建方式。然而，你马上就会看到一个编译器提出的错误：

    Recursive enum 'BinaryTree' is not marked 'indirect'

Xcode 应该提供了一种解决这个错误的方法。根据报错信息来修正错误，然后你的枚举应该看起来像这样：

    indirect enum BinaryTree<T> {
      case empty
      case node(BinaryTree, T, BinaryTree)
    }


### 间接

Swift 中的枚举是一种类型值。当 Swift 试图去为类型值分配内存的时候，它需要去确切的知道所需要被分配的内存大小。

你所定义的枚举是一种 _recursive_ （递归）枚举。那是一种有着一个指向自身的相关值（associated value）的一种枚举。递归类型的类型值内存大小无法被确定。

![Screen Shot 2016-08-01 at 1.27.40 AM](http://ww4.sinaimg.cn/large/7853084cgw1f7fm49qv5oj20mc0gagng.jpg)

所以在这里你有一个问题。Swift 希望能准确的知道枚举的大小，然而你所创建的递归类型的枚举却没有暴露这个消息。

这就是 `indirect`（间接）这个关键字的由来。`indirect`（间接）实现了一个两个类型值之间的 _indirection（间接层）_。这引出了语义与类型值之间的一层中间层。

这个枚举现在引用的是它的关联值而不是自身的值。引用值有着一个确切的大小，所以就不再存在之前的问题。

代码现在可以通过编译了，但是你能够更加的简洁。将 `BinaryTree`（二叉树）更新到下面的样子：

    enum BinaryTree<T> {
      case empty
      indirect case node(BinaryTree, T, BinaryTree)
    }


因为只有 `node`（结点）是递归的，所以你只需要在结点处应用 `indirect`（间接）即可。

## 例子：算数操作

检验这一点的有一个有趣的例子是使用一棵二叉树来进行一系列的计算。我们来进行下面这个例子的运算：`(5 * (a - 10)) + (-4 * (3 / b))`：

![Operations](https://cdn4.raywenderlich.com/wp-content/uploads/2016/07/Operations.png)

在你的 playground 文件的最后写下下面的语句：

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


你需要通过从叶结点开始一直到树的顶部来反向构建这棵树。

### CustomStringConvertible 协议

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



通过在文件的最后编写下面的语句来打印这棵树：

    tree.count

你应该可以看到类似下面的语句：

    value: +, left = [value: *, left = [value: 5, left = [], right = []], right = [value: -, left = [value: a, left = [], right = []], right = [value: 10, left = [], right = []]]], right = [value: *, left = [value: -, left = [], right = [value: 4, left = [], right = []]], right = [value: /, left = [value: 3, left = [], right = []], right = [value: b, left = [], right = []]]]

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



### 得到数值

另一个有用的特性就是可以得到树的结点。在你的 `BinaryTree` 枚举里面加上下面的语句：

    var count: Int {
      switch self {
      case let .node(left, _, right):
        return left.count + 1 + right.count
      case .empty:
        return 0
      }
    }

通过在你的 playground 程序的最后加上下面的语句来进行测试：

```
tree.count
```

你应该可以看到侧边栏有数字 12，因为这棵树有 12 个结点。

已经完成到这里了，非常棒。现在你已经有了关于二叉树的良好基础，是时候去了解目前为止最受欢迎的二叉树了 - _Binary Search Tree_（二叉搜索树）!

## 二叉搜索树

二叉搜索树是一种特殊的二叉树（普通的二叉树每个结点最多有 2 个子树），这种特殊的二叉树可以执行插入和删除操作，使得这棵树总是按序排列。

### “总是按序排列” 的属性

这里是一个关于一棵有效二叉搜索树的例子：

![Tree1](https://cdn5.raywenderlich.com/wp-content/uploads/2016/07/Tree1.png)

可以注意到每个左子树的数值小于它的父结点的数值，每个右子树的数值大于父结点的数值。这就是二叉搜索树的主要特性。

举个例子，2 比 7 小，所以放在左边，5 比 2 大，所以放在右边。

### 插入

当执行一个插入操作的时候，将根结点当成当前结点：

* 	**如果当前结点为空** ，你在这里插入一个新的结点。
* 	**如果新的值更小** ，你沿着左边的分支向下。
* 	**如果新的值更大** ，你沿着右边的分支向下。

你向下遍历这棵树，直到你找到一个空的地方可以插入新值。

例如，假如你想要插入一个值为 9 的数到上面的树中：

1.	从树的根结点开始（根结点数值为 7），并与新的值 9 进行比较。
2. 	9 大于 7，所以你沿着右边向下。
3.	比较 9 和 10，因为 9 小于 10，所以你沿着左边向下。
4. 	这个左分支是空的，因此你要插入一个新的结点然后放置这个 9 的数值。

这棵新的树现在看起来像这样：

![Tree2](https://cdn2.raywenderlich.com/wp-content/uploads/2016/07/Tree2.png)

这里有另一个例子。假如你想插入一个值为 3 的数到上面的树中：

1.	从树的根结点开始（根结点数值为 7），并与新的值 3 进行比较。
2. 	3 小于 7，所以你沿着左边向下。
3.	比较 3 和 2，因为 3 大于 2，所以你沿着右边向下。
4. 	这个左分支是空的，因此你要插入一个新的结点然后放置这个 3 的数值。

这棵新的树现在看起来像这样：

![added](https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/added-308x320.png)

最后这棵树上，总是只有一个可能插入新元素的地方。找到这个可以插入新元素的地方总是比较快的。这个过程会花费 _O(h)_ 的时间，而 _h_ 是树的高度。

**注意：** 如果你对于树的高度不熟悉，来看一下之前发的 [Swift Trees（Swift 的树）](https://www.raywenderlich.com/138190/swift-algorithm-club-swift-tree-data-structure) 这篇文章吧。

### 挑战：实现插入

现在你已经知道了应该在哪里插入数值了，是时候来实现这个过程了。在你的 `BinaryTree`（二叉树）枚举中加入下面的方法：

    // 1. 
    mutating func naiveInsert(newValue: T) {
      // 2.
      guard case .node(var left, let value, var right) = self else {
        // 3. 
        self = .node(.empty, newValue, .empty)
        return 
      }

      // 4. TODO: Implement rest of algorithm!

    }


让我们一段一段的来复习一下：

1.	类型值默认是不变的。如果你创建了尝试在类型值中改变什么东西的方法的话，你会需要通过显式使用 `mutating`（可变）关键词来标记你的方法。
2. 	你应该在当前结点中使用  `guard` 声明语句来暴露你的左子树，当前值和右子树。而如果这个结点是 `empty`（空）的，那 `guard` 就会失败然后跳入它的 `else` block 语句中去。
3. 	在这个 block 中，`self`（自身对象） 是 `empty`（空）的。你将会在这里插入一个新的值。
4. 	这就是你进来的地方 - 稍等一下。

基于之前所提到的算法知识，一会你将尝试着去实现上面的四个段落中的内容。这对于你是一个很好的锻炼，不单单是理解二叉搜索树，还包括磨练你的递归技能。

但在你开始做之前，你需要对 `BinaryTree` 的签名做一点修改。在第四个段落处，你需要对比新值和旧值，但在目前的二叉树实现机制中你无法做到这一点。为了修复这一个问题，把你的 `BinaryTree`（二叉树）枚举更新成下面的样子：

    enum BinaryTree<T: Comparable> {}
      // stuff inside unchanged
    }

`Comparable`（可对比的）协议确保你所构建的二叉树可以使用比较运算符进行值的对比，就像使用 `operator`（操作）一样。

现在，根据之前所提到的算法知道，继续尝试实现第四个段落的内容。下面的内容可以作为参考：

* 	**如果当前结点为空** ，你在这里插入一个新的结点，搞定。
* 	**如果新的值更小** ，你沿着左边的分支向下，你需要这样做。
* 	**如果新的值更大** ，你沿着右边的分支向下，你需要这样做。

如果你陷入了困境，你可以查看一下下面提供的解决方案。

```
// 4. TODO: Implement naive algorithm!
if newValue < value {
  left.naiveInsert(newValue: newValue)
} else {
  right.naiveInsert(newValue: newValue)
}
```

### 写时拷贝

虽然这是一个很好的实现，但它不起作用。在你的 playground 程序中写入下面的语句来测试这个功能：

    var binaryTree: BinaryTree = .empty
    binaryTree.naiveInsert(newValue: 5) // binaryTree now has a node value with 5
    binaryTree.naiveInsert(newValue: 7) // binaryTree is unchanged
    binaryTree.naiveInsert(newValue: 9) // binaryTree is unchanged



![Screen Shot 2016-08-10 at 8.55.46 PM](http://ww2.sinaimg.cn/large/7853084cgw1f7fm570bnhj20hg0h0gmr.jpg)

写时拷贝技术就是这里的罪魁祸首。每次你尝试着去修改这棵树的时候，一个新的子树的拷贝就会被创建。这个新的拷贝是不会链接到你的旧的拷贝的，所以你的最开始的二叉树是永远不会被新的值所修改的。

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


这是一个会根据所插入新元素返回一个新的树的方法。代码是相对简单的：

1.	如果这棵树是空的，你想要去插入一个新值。
2. 	如果这棵树不是空的，你将会需要去决定把新值插入到左子树或者右子树。

在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

    mutating func insert(newValue: T) {
      self = newTreeWithInsertedValue(newValue: newValue)
    }

通过更换你的 playground 程序最底下的测试语句来进行测试：

    binaryTree.insert(newValue: 5) 
    binaryTree.insert(newValue: 7) 
    binaryTree.insert(newValue: 9)

你应该可以得到下面的树结构：

    value: 5, 
        left = [], 
        right = [value: 7, 
            left = [], 
            right = [value: 9, 
                left = [], 
                right = []]]

恭喜 - 现在你已经可以进行插入工作了。

### 插入时间复杂度

就像在剧透过的章节里面说到的，每次进行一个新的插入操作的时候，你都需要创建一份树的拷贝。创建一份拷贝需要遍历之前的所有结点。这会为这个插入方法增加 _O(n)_ 的时间复杂度。

**提示：** 一颗使用传统类实现的二叉搜索树的平均时间复杂度是 _O(log n)_，这是相当快的。使用类（引用语义）是不会有写时拷贝的行为的，所以你将不去做树的复杂拷贝也能实现插入操作。

## 遍历算法

遍历算法是树的相关操作的基础。一个遍历算法会经历一棵树的所有结点。下面是三种遍历一颗树的主要方式：

### 中序遍历

中序遍历是按照升序来遍历一颗二叉搜索树的。下面是一个中序遍历看起来的样子：

![Traversing](https://cdn2.raywenderlich.com/wp-content/uploads/2016/08/Traversing.png)

从顶部开始，沿着左边尽可能的向下。当你到达左边的底部，你将会看到当前的值，这个时候你尝试着遍历到右边。这个过程将会持续下去直到你遍历完整棵树。

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



这段代码是相当简单的：

1.	如果这个结点是空的，就没有方法继续前进下去。这里只要返回就好了。
2. 	如果这个结点不为空，那你将可以前进的更深一点。中序遍历的定义是首先走左子树，然后是结点，最后是右子树。

看到这里，你将会创建上面提到的二叉树。删除你的 playground 程序最底下所有的测试代码并更换成下面的语句：

    var tree: BinaryTree<Int> = .empty

    tree.insert(newValue: 7)
    tree.insert(newValue: 10)
    tree.insert(newValue: 2)
    tree.insert(newValue: 1)
    tree.insert(newValue: 5)
    tree.insert(newValue: 9)

    tree.traverseInOrder { print($0) }


你已经创建了一棵可以使用你的插入方法的二叉搜索树。`traverseInOrder` 将会在按照升序遍历你的结点后，传递每个结点的值给结尾闭包。

在这个结尾闭包里，你将打印通过你的遍历方法传递过来的值。`$0` 是一种对于传递到闭包的元素进行引用到一种缩写语法。

你将会看到在你的控制台会有这样的输出：

```
1
2
5
7
9
10
```

### 先序遍历

二叉搜索树的先序遍历是一种在遍历过程中首先遍历节点的遍历方法。这里的关键是在遍历子树之前首先调用  `process` 方法。在你的 `BinaryTree`（二叉树）枚举中写入下面的语句：

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

### 后序遍历

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


这三种遍历方法是很多复杂的编程问题的基础。理解它们被证明在很多情况下都是有用的，包括你的下一个编程面试。

### 小小的挑战

遍历算法的时间复杂度是什么?


时间复杂度是 _O(n)_ ，这里的 _n_ 指的是树的结点数。

这应该是很明显的，因为这个遍历的想法就是要遍历一棵树的所有结点。

## 搜索

就像二叉搜索树的名字提示我们的一样，一棵二叉搜索树是已知的最好的高效搜索方式。一棵合格的二叉搜索树的所有的左子树的数目会小于它的父结点的数目，而它的所有右结点的数目会大于或等于它的父结点的数目。

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

很像遍历算法，搜索包括着遍历二叉树：

1.	如果你的当前值与你想要搜索的值相同，停止搜索。返回当前子树。
2. 	如果你继续执行到这个点，说明你还没有找到你的值。你将会需要去决定往左子树的方向前进或者往右子树的方向前进。你会使用二叉搜索树的规则来决定。

与遍历算法不同，搜索算法在每一个递归步骤只会遍历其中一边。平均而言,这会导致时间复杂度为 _O(log n)_ ,速度远远快于 _O(n)_ 时间复杂度的遍历操作。

在你的 playground 文件里写下下面的语句来进行测试：

    tree.search(searchValue: 5)

## 下一站是哪里？

我希望你喜欢这个构建 Swift 二叉树数据结构的教程！

这里是一个关于上述代码的 [Swift playground](https://cdn1.raywenderlich.com/wp-content/uploads/2016/08/SwiftBinaryTree.playground.zip)  文件。你也可以在 Swift 算法俱乐部的 [Binary Search Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search%20Tree) 章节里面找到关于二叉树可替代的实现方式和进行进一步的讨论。

这只是 Swift 算法俱乐部所关注的其中一个算法实现。如果你感兴趣，请查看 [repo](https://github.com/raywenderlich/swift-algorithm-club)。

这是你的最好的了解算法和数据结构的机会 - 它们解决很多现实问题，和经常被问及的面试问题。而且很有趣！

所以后面请持续关注来自 Swift 算法俱乐部的教程。如果你对于在 Swift 中实现二叉树有任何问题，请加入下面的论坛进行讨论。

**注意：** [Swift 算法俱乐部](https://github.com/raywenderlich/swift-algorithm-club) 一直在寻找更多的贡献者。如果你对于数据结构，算法有兴趣，或者甚至是有一个面试问题想要分享，不要犹豫，来贡献给大家！了解更多贡献流程，请查看 [加入算法俱乐部](https://www.raywenderlich.com/135533/join-swift-algorithm-club) 这篇文章。

