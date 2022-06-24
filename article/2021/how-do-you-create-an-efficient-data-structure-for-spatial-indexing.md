> * 原文地址：[How do you create an Efficient Data Structure for Spatial Indexing?](https://edward-huang.com/algorithm/programming/tech/java/2021/01/11/data-structure-for-spatial-indexing/)
> * 原文作者：[Edward Huang](https://edward-huang.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-do-you-create-an-efficient-data-structure-for-spatial-indexing.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-do-you-create-an-efficient-data-structure-for-spatial-indexing.md)
> * 译者：[Starriers](https://github.com/Starriers)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[zhangcong2711](https://github.com/zhangcong2711)、[PassionPenguin](https://github.com/PassionPenguin)

# 如何为空间索引创建高效的数据结构？

数据结构不仅可以帮我们存储值，还可以帮助我们高效地对需要的数据进行操作。比如，我们想存储一维数据点、画在一条直线上的自然数，或是一个字符串，我们通常使用一维数组来存储这些数据。我们一般会使用自然次序索引（1 \< 2 \< 3）或者是像前缀树或[二叉树](https://medium.com/javarevisited/20-binary-tree-algorithms-problems-from-coding-interviews-c5e5a384df30)这样的数据结构来创建快速索引（检索）。

假如我们需要使用 2D 空间存储数据，那我们该如何设计一个快速索引？假如我们需要邻近度排序，比方说是需要找到当前定位点附近所有的临近点，那又该如何设计？

由于我们需要使用一个 X 和一个 Y 来表示坐标，所以在真实场景中，我们并不会使用自然次序。如果那样的话，我们不得不根据输入，在数据集中搜索所有符合 `X + delta` 和 `Y + delta` 的空间，并以此来获取交集。

是的，我们需要空间索引。

**空间索引**通常作为2D空间高效访问的手段。空间索引的实际应用场景包括但不限于：共享骑行（Lyft、Uber），需要获取最近餐点的餐饮配送（DoorDash），Yelp 也借此帮助你了解距离最近的餐饮店位置。诸如此类的都是空间索引的实际应用场景。

类似的应用程序还包括**查找附近的邻居** —— 一款从当前目标获取最近邻居的应用。

**范围查询**：查找一个包含给定坐标（坐标查询）的目标或者是坐标与一个区域有所关联的的重叠目标（窗口查询）。

**空间连接**：查找在空间上相互影响的对象对。使用空间谓词的相交，邻接和包含来执行空间连接。

现在你已经了解了什么是空间索引，下面我接着讨论数据结构的种类。我们需要存储这些坐标来达到快速索引的目的。如果你第一时间想到的是四叉树，那么恭喜你，你是正确的。接下来的内容，我会解释什么是四叉树，以及它是如何存储稀疏数据来实现索引的。

## 什么是四叉树？

因为四叉树是一种划分空间的方法，因此更容易遍历和搜索。它是一种将值划分为四个部分的树形数据结构。叶节点保存的值取决于你具体实现的应用程序。被划分的区域可以是正方形也可以是矩形。四叉树和字典树类似，不同之处在于它们只有四个子级，并且确定这些子级必须要符合某些条件。比方说，某点的条件符合符合左象限的规则，那么就遍历左象限。

对于需要进行搜索的稀疏数据，四叉树是一种很好的选择。它可以保存化学反应中的数据片段，图像处理中的像素等等。

我会在本中说明如何实现一个四叉树。

在开始之前，需要说明的是，四叉树有三个组件。第一个是使用 `x` 和 `y` 来表示用于存储的坐标的对象。第二个是保存在四叉树中的四叉树节点。最后一个就是四叉树本身。

## Point 类

```Java
static class Point {
    int x;
    int y;
    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // 更像是一个深拷贝
    public Point(Point p) {
        this.x = p.x;
        this.y = p.y;
    }

    @Override
    public String toString() {
        return "x: " + x + " y: " + y;
    }
}
```

## QuadNode 类

```Java
static class QuadNode<T> {
    T data;
    Point point;

    public QuadNode(Point p, T data) {
        this.data = data;
        this.point = p;
    }

    public QuadNode(int x, int y, T data) {
        this.data = data;
        this.point = new Point(x, y);
    }

    @Override
    public String toString() {
        return "data: " + data + " point: " + point;
    }
}
```

## QuadTree 类

```Java
class QuadTree<P> {    
    Point topLeft;
    Point bottomRight;
    Set<QuadNode<P>> nodes;
    // 子类 (作为四叉树的数组，也可以当做字典树使用)
    QuadTree<P> topLeftTree;
    QuadTree<P> topRightTree;
    QuadTree<P> bottomLeftTree;
    QuadTree<P> bottomRightTree;
    int maxLen;

    public QuadTree(Point topLeft, Point bottomRight, int maxLen) {
        this.topLeft = topLeft;
        this.bottomRight = bottomRight;
        this.maxLen = maxLen;
        nodes = new HashSet<>();
    }
}
```

## 插入

和[二叉搜索树](https://javarevisited.blogspot.com/2015/10/how-to-implement-binary-search-tree-in-java-example.html)一样，我们需要从根节点开始，查找当前坐标所属的节点，然后递归遍历当前节点，直到到达叶节点。

然后我们将坐标插入到四叉树中，检查是否需要进一步**细分**。如果需要进一步细分，我们需要将该区域细分为四个象限，并将内部值重新分配给子级。

```Java
public void insert(Point p, P data) {
    QuadTree<P> curr = this;

    while (!curr.isLeaf()) {
        System.out.println("Inserting " + p + " data " + data);

        // 根据 x 来检查左上角和右下角的值
        if (p.x < (curr.topLeft.x + curr.bottomRight.x) / 2) {
            // 通过比对 y 来检查左上角和左下角的数据
            if (p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) { // 是左上角
                System.out.println("Is within topLeftTree py: " + p.y + " " + " mid: " + ((curr.topLeft.y + curr.bottomRight.y) / 2));
                curr = curr.topLeftTree;
            } else { // 是左下角
                System.out.println("Is within bottomLeft");
                curr = curr.bottomLeftTree;
            }

        } else { // 检查右上角和右下角的数据
            // 通过比对 y 来检查右上角和右下角的数据
            if (p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) { // 是右上角
                System.out.println("Is within topRight");
                curr = curr.topRightTree;

            } else { // 在右下角中
                System.out.println("Is within bottomRight");
                curr = curr.bottomRightTree;
            }
        }
    }

    // 当前是叶子
    QuadNode < P > quadNode = new QuadNode < > (p, data);
    curr.nodes.add(quadNode);
    // System.out.println("curr " + curr);
    // 如果当坐标是 maxLen，那我们就需要做进一步的划分
    if (curr.shouldSubDivide()) {
        // System.out.println("data " + data +  " need to be subdivide");
        curr.subDivide();
    }
}
```

## 搜索

从根节点开始，校验当前坐标所属的区域，然后递归遍历所属区域，直到到达叶节点，返回包含坐标列表的[叶节点](https://javarevisited.blogspot.com/2016/12/how-to-count-number-of-leaf-nodes-in-java-recursive-iterative-algorithm.html) 的值。

```Java
public Set<QuadNode<P>> search(Point p) {
    QuadTree<P> curr = this;

    while (!curr.isLeaf()) {
        // 通过检查是否在边界内来进行递归
        if (p.x < (curr.topLeft.x + curr.bottomRight.x) / 2) {
            if (p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) {
                curr = curr.topLeftTree;
            } else {
                curr = curr.bottomLeftTree;
            }
        } else {
            if (p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) {
                curr = curr.topRightTree;
            } else {
                curr = curr.bottomRightTree;
            }
        }
    }
    return curr.node;
}
```

## 总结

* 在地理存储领域，自然次序搜索并不能满足实际的需求。因此我们一般使用空间索引来搜索 2D 空间。
* 四叉树等效于一维空间中二叉树的[数据结构](https://medium.com/javarevisited/7-best-courses-to-learn-data-structure-and-algorithms-d5379ae2588)。然而，只要你对稀疏数据有搜索要求，我们就可以使用四叉树。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
