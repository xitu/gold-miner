> * 原文地址：[GopherCon 2018 - Demystifying Binary Search Tree Algorithms](https://about.sourcegraph.com/go/gophercon-2018-binary-search-tree-algorithms/)
> * 原文作者：[Kaylyn Gibilterra](https://twitter.com/kgibilterra)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/gophercon-2018-binary-search-tree-algorithms.md](https://github.com/xitu/gold-miner/blob/master/TODO1/gophercon-2018-binary-search-tree-algorithms.md)
> * 译者：[Changkun Ou](https://github.com/changkun)
> * 校对者：[razertory](https://github.com/razertory)

# GopherCon 2018: 揭秘二叉查找树算法

By Geoffrey Gilmore for the GopherCon Liveblog on August 30, 2018

Presenter: [Kaylyn Gibilterra](https://twitter.com/kgibilterra)

Liveblogger: [Geoffrey Gilmore](https://github.com/ggilmore)

算法的学习势不可挡也令人气馁，但其实大可不必如此。在本次演讲中，Kaylyn 使用 Go 代码作为例子，直接了当的阐述了二叉查找树算法。

* * *

## 介绍

Kaylyn 在最近的一年里尝试通过实现各种算法来找乐子。可能这件事情对于你来说很奇怪，但算法对她而言尤其诡异。她在大学课堂里尤其讨厌算法。她的教授经常使用一些复杂的术语来授课，而且还拒绝解释一些『显然』的概念。结果就是，她只学到了一些能够帮助她找到工作的基本知识。

然而她的态度在当她开始使用 Go 来实现这些算法时就开始转变了。将那些由 C 或者 Java 编写的算法转换到 Go 身上令人意想不到的简单，于是她开始逐渐理解这些算法，并且比在大学期间理解得更为透彻。

Kaylyn 将在演讲中解释为什么会出现这种情况、并为你展示如何使用二叉查找树。在这之前，我们需要问：为什么学习算法的体验如此糟糕？

## 学习算法很可怕

![](https://user-images.githubusercontent.com/9022011/44757761-fdfd3100-aaed-11e8-8efb-bcac3d9aebb4.png)

此截图来自《算法导论》的二叉查找树部分。算法导论被认为是算法书籍的圣经。据作者所说，在 1989 年出版之前，没有一本很好的算法教科书。但是，任何阅读算法导论的人都可以说它是由主要受众具有学术意识的教授编写的。

举几个例子：

* 此页引用了本书在其他地方定义的许多术语。所以你需要了解： 

  * 什么是卫星数据（satellite data）
  * 什么是链表（linked list）
  * 什么是树的先序（pre-order）、后序（post-order）遍历

  如果你没有在书中的每一页上做笔记，你就无法知道这些都是什么。

* 如果你和 Kaylyn 一样，那么你看这一页的第一件事就是去看代码。但是，页面上唯一的代码只解释了一种遍历二叉查找树的方法，而不是二叉查找树实际上是什么。

* 本页的整个底部四分之一是定理和证明，这可能是善意的。许多教科书作者认为向你证明他们的陈述是真实的是相当重要的；否则，你就无法相信他们。可笑的是，算法应该是一本入门教科书。但是，初学者不需要知道算法正确的所有具体细节，因为他们会听你的话。

* 他们确实有一个两句话区域（以绿色框突出显示），解释了二叉查找树算法是什么。但它隐藏在一个几乎看不见的句子中，并称之为二元查找树『性质』，这对于初学者而言是非常令人困惑的术语。

结论:

1. 学术教科书的作者不一定是好老师，最好的老师经常不写教科书。
2. 可惜大多数人都复制了标准教科书使用的教学风格或格式。 在查看二叉查找树之前，他们默认你已经了解了相关的术语。事实上，大多数这种『必需的知识』并不是必需的。

本演讲的其余部分将介绍二叉查找树的内容。如果你是 Go 新手或算法新手，你会发现它很有用。而如果你都不是，那么它可以作为一次很好的回顾，同时你也分享给对 Go 或者算法感兴趣的人。

## 猜数游戏

这是你在接下来全部演讲中唯一需要知道的东西。

![](https://user-images.githubusercontent.com/9022011/44758592-a01f1800-aaf2-11e8-9225-00c9d88ccaf9.png)

这是一个『猜数游戏』，很多人儿时玩过的游戏。你邀请你的朋友来参加在某个范围内（比如 1 至 100）猜一个特定数的游戏。然后你朋友可能会说『57』。一般情况下第一次猜会猜错，但是你会告诉他们猜测的数字是大了还是小了。然后他可以继续猜测知道最后猜中为止。

![](https://user-images.githubusercontent.com/9022011/44758764-7b777000-aaf3-11e8-92d4-ebb4e92c2832.png)

这个猜数游戏基本上就是一个二叉查找的过程了。如果你正确理解了这个猜数游戏，那么你也能够理解二叉查找树算法背后的原理。你朋友猜测的数字就是查找树中的某个节点，『高了』和『低了』决定了移动的方向：右节点或左节点。

## 二叉查找树的规则

1.  每个节点包含一个唯一的 key，用于比较不同的节点大小。一个 key 可以是任何类型：字符串、整数等等
2.  每个节点至多两个子节点
3.  节点的值小于右子树种节点的值
4.  节点的值大于左子树种节点的值
5.  没有重复的 key

二叉查找树包含三个主要操作：

*   查找
*   插入
*   删除

二叉查找树可以让上面这三个操作变得更快，这也是他们为什么如此热门的原因。

## 查找

![](https://cl.ly/dd19a7225c09/Screen%252520Recording%2525202018-08-29%252520at%25252009.03%252520PM.gif)

上面的 GIF 图给出了在树种查找 `39` 的例子。

![](https://cl.ly/908ecf0f3854/Image%2525202018-08-29%252520at%2525209.31.02%252520PM.png)

一个非常重要的性质是二叉查找树一个节点右子树中节点的值总是大于节点自身的值，而左子树中节点的值总是小于节点自身的值。比如图中 `57` 右边的数总是大于 `57` ，而左边总是小于 `57`。

![](https://cl.ly/61dfb3a92722/Image%2525202018-08-29%252520at%2525209.33.32%252520PM.png)

这个性质除了根节点外，对树中每个节点都有效。在上图中，所有右子树的值都大于 `32`，左子树则小于 `32`

好了，我们知道了基本原理，可以开始写代码了。

```go
type Node struct {
    Key   int
    Left  *Node
    Right *Node
}
```

基本结构是一个 `stuct` ，如果你还没有用过 `stuct`，`struct` 基本上可以解释为一些字段的集合。这个结构体你需要的只是一个 `Key`（用于比较其他节点），一个 `Left` 和 `Right` 子节点。

当定义一个 节点（Node）时，你可以使用这样的字面量：，你可以使用这样的字面量：

```go
tree := &Node{Key: 6}
```

它创建了一个 `Key` 为 `6` 的 `Node`。你可能好奇 `Left` 和 `Right` 去哪儿了。事实上他们都被初始化成零值了。

```go
tree := &Node{
    Key:   6,
    Left:  nil,
    Right: nil,
}
```

然而你也可以显式什么这些字段的值（比如上面指定了 `Key`）。

又或者在没有字段名称的情况下指定字段的值：

```go
tree := &Node{6, nil, nil}
```

这种情况下，第一个参数为 `Key`，第二个为 `Left`，第三个为 `Right`。

指定完后你就可以通过点语法来访问他们的值了：

```go
tree := &Node{6, nil, nil}
fmt.Println(tree.Key)
```

现在我们来实现查找算法 `Search`：

```go
func (n *Node) Search(key int) bool {
    // 这是我们的基本情况。如果 n == nil, 则 `key`
    // 在二叉查找树种不存在
    if n == nil {
        return false
    }
    if n.Key < key { // 向右走
        return n.Right.Search(key)
    }
    if n.Key > key { // 向左走
        return n.Left.Search(key)
    }
    // 如果 n.Key == key, 就说明找到了
    return true
}
```

## 插入

![](https://cl.ly/aaa1f718d537/Screen%252520Recording%2525202018-08-29%252520at%25252010.17%252520PM.gif)

上面的 GIF 图片展示了在一个数中插入 `81` 的例子，插入与查找非常类似。我们想要找到应该在什么位置插入 `81`，于是开始查找，然后在合适的位置插入。

```go
func (n *Node) Insert(key int) {
    if n.Key < key {
        if n.Right == nil { // 我们找到了一个空位，结束
            n.Right = &Node{Key: key}
            return
        }
        // 向右边找
        n.Right.Insert(key)
       	return
    } 
    if n.Key > key {
        if n.Left == nil { // 我们找到了一个空位，结束
            n.Left = &Node{Key: key}
            return
        } 
        // 向左边找
        n.Left.Insert(key)
    }
    // 如果 n.Key == key, 则什么也不做
}
```

[如果你没见过 `(n *Node)` 语法，可以看看这里关于指针型 receiver 的说明。](https://tour.golang.org/methods/4)

## 删除

![](https://cl.ly/e261dd30e743/Screen%252520Recording%2525202018-08-29%252520at%25252010.33%252520PM.gif)

上面的 GIF 图展示了从一个树种删除 78 的情况。`78` 的查找过程和之前类似。这种情况下，我们只需要正确的将 `78` 从树中『剪掉』、将右子节点 `57` 连接到 `85` 就行了。

```go
func (n *Node) Delete(key int) *Node {
    // 按 `key` 查找
    if n.Key < key {
        n.Right = n.Right.Delete(key)
        return n
    }
    if n.Key > key {
        n.Left = n.Left.Delete(key)   
        return n
    }

    // n.Key == `key`
    if n.Left == nil { // 只指向反向的节点
        return n.Right
    }
    if n.Right == nil { // 只指向反向的节点
        return n.Left
    }

    // 如果 `n` 有两个子节点，则需要确定下一个放在位置 n 的最大值
    // 使得二叉查找树保持正确的性质
    min := n.Right.Min()

    // 我们只使用最小节点来更新 `n` 的 key
    // 因此 n 的直接子节点不再为空
    n.Key = min
    n.Right = n.Right.Delete(min)
    return n
}
```

## 最小值

![](https://cl.ly/9f703767f7c9/Image%2525202018-08-29%252520at%25252011.20.37%252520PM.png)

如果不停的向左移，你会找到最小值（图中为 `24`）

```go
func (n *Node) Min() int {
    if n.Left == nil {
        return n.Key
    }
    return n.Left.Min()
}
```

## 最大值

![](https://cl.ly/6e4021ed62d9/Image%2525202018-08-29%252520at%25252011.22.20%252520PM.png)

```go
func (n *Node) Max() int {
    if n.Right == nil {
        return n.Key
    }
    return n.Right.Max()
}
```

如果你一直向右移，则会找到最大值（图中为 `96`）。

## 单元测试

既然我们已经为二叉查找树的每个主要函数编写了代码，那么让我们实际测试一下我们的代码吧！ 测试实践过程中最有意思的部分：Go 中的测试比许多其他语言（如 Python 和 C ）更直接。

```go
// 必须导入标准库
import "testing"

// 这个称之为测试表。它能够简单的指定测试用例来避免写出重复代码。
// 见 https://github.com/golang/go/wiki/TableDrivenTests
var tests = []struct {
    input  int
    output bool
}{
    {6, true},
    {16, false},
    {3, true},
}

func TestSearch(t *testing.T) {
    //     6
    //    /
    //   3
    tree := &Node{Key: 6, Left: &Node{Key: 3}}
    
    for i, test := range tests { 
        if res := tree.Search(test.input); res != test.output {
            t.Errorf("%d: got %v, expected %v", i, res, test.output)
        }
    }

}
```

然后只需要运行：

```
> go test
```

Go 会运行你的测试并输出一个标准格式的结果，来告诉你测试是否通过，测试失败的消息以及测试花费的时间。

## 性能测试

等等，还有更多内容！Go 可以让性能测试变得非常简洁，你只需要：

```go
import "testing"

func BenchmarkSearch(b *testing.B) {
    tree := &Node{Key: 6}

    for i := 0; i < b.N; i++ {
        tree.Search(6)
    }
}
```

`b.N` 会反复运行 `tree.Search()` 来获得`tree.Search()`的稳定运行结果。

通过下面的命令运行测试：

```
> go test -bench=
```

输出类似于：

```
goos: darwin
goarch: amd64
pkg: github.com/kgibilterra/alGOrithms/bst
BenchmarkSearch-4       1000000000               2.84 ns/op
PASS
ok      github.com/kgibilterra/alGOrithms/bst   3.141s
```

你需要关注的是下面这行：

```
BenchmarkSearch-4       1000000000               2.84 ns/op
```

它表明了你函数的执行速度。这种情况下，`test.Search()` 的执行时间大约为 2.84 纳秒。

既然可以简单运行性能测试，那么可以开始做一些实验了，比如：

*   如果树非常大或者非常深灰发生什么？
*   如果我修改了需要查找的 key 会发生什么？

发现它特别利于理解 map 和 slice 之间的性能特性。希望你能在网上快速找到相关反馈。

> 译者注：二叉查找树的插入、删除、查找时间复杂度为 O(log(n))，最坏情况为 O(n)；Go 的 map 是一个哈希表，我们知道哈希表的插入、删除、查找的平均时间复杂度为 O(1)，而最坏情况下为 O(n)；而 Go 的 Slice 的查找需要遍历 Slice 复杂度为 O(n)，插入和删除在必要时会重新分配内存，最坏情况为 O(n)。

## 二叉查找树术语

最后我们来看一些二叉查找树的术语。如果你希望了解二叉查找树的更多内容，那么这些术语是有帮助的：

**树的高度**: 从根节点到叶子节点中最长路径的边数，这决定了算法的速度。

![](https://cl.ly/705355d982d4/Image%2525202018-08-30%252520at%25252012.05.11%252520AM.png)

图中树的高度 `5`.

**节点深度**: 从根节点到节点的边数。

`48` 的深度为 `2` 。

![](https://cl.ly/a0058d294af0/Image%2525202018-08-30%252520at%25252012.08.04%252520AM.png)

**满二叉树**: 每个非叶子节点均包含两个子节点。

![](https://cl.ly/3bd94a056d8d/Image%2525202018-08-30%252520at%25252012.10.53%252520AM.png)

**完全二叉树**: 每层结点都完全填满，在最后一层上如果不是满的，则只缺少右边的若干结点。

![](https://cl.ly/d78de1699704/Image%2525202018-08-30%252520at%25252012.12.03%252520AM.png)

**一个非平衡树**

![](https://cl.ly/1669851131fe/Screen%252520Recording%2525202018-08-30%252520at%25252012.14%252520AM.gif)

想象一下在这颗树上查找 `47`，你可以看到找到需要花费七步，而查找 `24` 则只需要花费三步，这个问题随着『不平衡』的增加而变得严重。解决方法就是使树变得平衡：

**一个平衡树**:

![](https://cl.ly/8ba095d064c8/Image%2525202018-08-30%252520at%25252012.20.17%252520AM.png)

此树包含与非平衡树相同的节点，但在平衡树上查找平均比在不平衡树上查找更快。

## 联系方式

Twitter: [@kgibilterra](https://twitter.com/kgibilterra)
Email: [kgibilterra@gmail.com](mailto:kgibilterra@gmail.com)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
