> * 原文地址：[How do you create an Efficient Data Structure for Spatial Indexing?](https://edward-huang.com/algorithm/programming/tech/java/2021/01/11/data-structure-for-spatial-indexing/)
> * 原文作者：[Edward Huang](https://edward-huang.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-do-you-create-an-efficient-data-structure-for-spatial-indexing.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-do-you-create-an-efficient-data-structure-for-spatial-indexing.md)
> * 译者：[Starriers](https://github.com/Starriers)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[zhangcong2711](https://github.com/zhangcong2711)、[PassionPenguin](https://github.com/PassionPenguin)、[haiyang-tju](https://github.com/haiyang-tju)、[timerring](https://github.com/timerring)

# 如何为空间索引创建高效的数据结构？

数据结构不仅能存储值，还可以帮助我们高效地对数据进行操作。比如，当我们想存储一些一维数据点、自然数或是字符串时，我们通常会使用[一维数组](https://medium.com/javarevisited/20-array-coding-problems-and-questions-from-programming-interviews-869b475b9121)。为了能快速地检索数据，我们一般会使用自然次序索引（1 \< 2 \< 3），或者是像字典树、[二叉树](https://medium.com/javarevisited/20-binary-tree-algorithms-problems-from-coding-interviews-c5e5a384df30)这样的数据结构。

假如我们需要使用二维空间存储数据，那我们该如何设计一个快速索引？假如我们需要按邻近度排序（如找到某一点的所有临近点），那又该如何设计？

按自然次序检索是行不通的，因为我们将有两个不同的索引 —— 一个用于横坐标，另一个用于纵坐标。这样一来，我们就必须在数据库中搜索所有位置为 `X + delta` 或 `Y + delta` 的点，之后再对两个集合进行交集操作。

这时我们需要采用空间索引的方法。

**空间索引**通常作为二维空间高效访问的手段。空间索引的实际应用场景包括但不限于：共享汽车（来福车、优步）、餐饮配送（DoorDash、Yelp）等。举例来说，DoorDash 通过空间索引来获取最靠近的配送点，Yelp 也利用空间索引搜寻离你最近的餐饮店的位置。

类似的应用还包括 **KNN 算法**，该算法用于搜索给定样本在特征空间中的所有邻近样本。

**范围查询**：查找一个包含给定坐标的对象（坐标查询），或者是与特定区域重叠的对象（窗口查询）。

**空间连接**：查找在空间上相互影响的对象对。我们能从空间方面了解对象之间的相交、邻近和包含关系。

现在你已经知道了什么是空间索引，那么哪种数据结构能提高索引数据点的效率呢？如果你想到了四叉树，那么恭喜你，回答正确。在接下来的内容中，我们将讨论什么是四叉树，以及它是如何存储稀疏数据来实现索引的。

## 什么是四叉树？

四叉树通过划分空间来提高遍历和搜索的效率。它是一种将数据划分为四个部分的树形数据结构。叶节点中保存的值取决于具体的应用场景。被细分的区域可以是正方形也可以是矩形。四叉树和字典树类似，不同之处在于四叉树只有四个子节点，并且子节点需要按照某些特征决定存储位置。比方说，如果某点的条件符合左上象限的范围，那么就遍历左上象限。

对于需要进行搜索的稀疏数据，四叉树可以是一个很好的选择。它可以保存化学反应中的数据片段，图像处理中的像素等等。

我将会在本中实现一个四叉树。

在开始之前，需要说明的是，四叉树的实现将包含三个部分。第一个是 `Point`，用于存储坐标（以 `x` 和 `y` 表示）。第二个是 `QuadNode`，用于保存在四叉树中的节点。最后一个是 `QuadTree`，也就是四叉树本身。

## `Point` 类

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
        return "(x: " + x + " y: " + y + ")";
    }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Point)) {
            return false;
        }
        Point p = (Point) o;
        return x == p.x && y == p.y;
    }
}
```

## `QuadNode` 类

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

## `QuadTree` 类

```Java
class QuadTree<P> {    
    Point topLeft;
    Point bottomRight;
    Set<QuadNode<P>> nodes;
    // 子树（这也可以像字典树一样使用，它是一个四叉树数组）
    QuadTree<P> topLeftTree;
    QuadTree<P> topRightTree;
    QuadTree<P> bottomLeftTree;
    QuadTree<P> bottomRightTree;
    int maxLen;

    public QuadTree(Point topLeft, Point bottomRight, int maxLen) {
        if (maxLen <= 0) {
            throw new IllegalArgumentException("maxLen should be a non-negative integer");
        }
        this.topLeft = topLeft;
        this.bottomRight = bottomRight;
        this.maxLen = maxLen;
        nodes = new HashSet<>();
    }
    
    // 如果是叶子节点，那么所有的节点将存储于 nodes 中，四个子树都为 null
    public boolean isLeaf() {
        return topLeftTree == null;
    }

    // 当存储节点超过上限（maxLen）时，细分该四叉树
    public boolean shouldSubDivide() {
        return nodes.size() > maxLen;
    }

    public void subDivide() {
        int midX = (topLeft.x + bottomRight.x) / 2;
        int midY = (topLeft.y + bottomRight.y) / 2;

        // 创建四个子树（象限）
        topLeftTree = new QuadTree<>(
            new Point(topLeft.x, topLeft.y),
            new Point(midX, midY),
            maxLen
        );
        topRightTree = new QuadTree<>(
            new Point(midX, topLeft.y),
            new Point(bottomRight.x, midY),
            maxLen
        );
        bottomLeftTree = new QuadTree<>(
            new Point(midX, bottomRight.y),
            new Point(topLeft.x, midY),
            maxLen
        );
        bottomRightTree = new QuadTree<>(
            new Point(bottomRight.x, bottomRight.y),
            new Point(midX, midY),
            maxLen
        );

        // 重新分配当前的所有节点至子树中
        for (QuadNode<P> node : nodes) {
            insert(node.point, node.data);
        }
        nodes.clear();
    }
}
```

## 插入

和[二叉搜索树](https://javarevisited.blogspot.com/2015/10/how-to-implement-binary-search-tree-in-java-example.html)一样，我们需要从根节点开始，查找当前坐标所属的节点，然后递归遍历当前节点，直到到达叶子节点。

然后我们将坐标插入到四叉树中，检查是否需要进一步**细分**。如果需要进一步细分，我们需要将该区域细分为四个象限，并将内部数据重新分配给子节点。

```Java
public void insert(Point p, P data) {
    System.out.println("插入 " + p + " data: " + data);
    QuadTree<P> curr = this;

    while (!curr.isLeaf()) {
        if (p.x < (curr.topLeft.x + curr.bottomRight.x) / 2) {
            if (p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) { // 左上
                System.out.println("位于左上四叉树");
                curr = curr.topLeftTree;
            } else { // 左下
                System.out.println("位于左下四叉树");
                curr = curr.bottomLeftTree;
            }
        } else {
            if (p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) { // 右上
                System.out.println("位于右上四叉树");
                curr = curr.topRightTree;
            } else { // 右下
                System.out.println("位于右下四叉树");
                curr = curr.bottomRightTree;
            }
        }
    }

    // curr 现在是叶子节点
    QuadNode<P> quadNode = new QuadNode<>(p, data);
    curr.nodes.add(quadNode);
    // 如果当坐标是 maxLen，那我们就需要做进一步的划分
    if (curr.shouldSubDivide()) {
        System.out.println("细分 " + curr);
        System.out.println("--- 重新分配节点至子树 ---");
        curr.subDivide();
        System.out.println("------ 重新分配完毕 ------");
    }
}
```

## 搜索

从根节点开始，校验当前坐标所属的区域，然后[递归遍历](https://javarevisited.blogspot.com/2016/12/how-to-count-number-of-leaf-nodes-in-java-recursive-iterative-algorithm.html)该区域，直到到达叶节点，接着返回所有匹配的节点。

```Java
public Set<QuadNode<P>> search(Point p) {
    System.out.println("搜索 " + p);
    QuadTree<P> curr = this;

    while (!curr.isLeaf()) {
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

    Set<QuadNode<P>> matchedNodes = new HashSet<>();
    for (QuadNode<P> node : curr.nodes) {
        if (p.equals(node.point)) {
            matchedNodes.add(node);
        }
    }
    return matchedNodes;
}
```

## 总结

* 在需要存储地理位置信息时，自然次序搜索并不能满足实际的需求。因此我们一般使用空间索引来搜索二维空间。
* 四叉树等效于一维空间中的二叉树。当你对稀疏数据有搜索要求时，不妨考虑使用四叉树。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
