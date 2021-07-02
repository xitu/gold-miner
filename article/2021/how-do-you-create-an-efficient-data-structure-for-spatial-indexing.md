> * 原文地址：[How do you create an Efficient Data Structure for Spatial Indexing?](https://edward-huang.com/algorithm/programming/tech/java/2021/01/11/data-structure-for-spatial-indexing/)
> * 原文作者：[Edward Huang](https://edward-huang.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-do-you-create-an-efficient-data-structure-for-spatial-indexing.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-do-you-create-an-efficient-data-structure-for-spatial-indexing.md)
> * 译者：
> * 校对者：

# How do you create an Efficient Data Structure for Spatial Indexing?

Data structure helps us store values within our data and help us efficiently do the operation with those data if we need them. For instance, if we want to store 1-dimensional data points, natural numbers that you will plot in a single line or a string, we can use a [1D array](https://medium.com/javarevisited/20-array-coding-problems-and-questions-from-programming-interviews-869b475b9121) to store these data. To create a fast retrieval (search), we will use a natural order indexing (1 \< 2 \< 3) or using a data structure like Trie or [Binary Tree](https://medium.com/javarevisited/20-binary-tree-algorithms-problems-from-coding-interviews-c5e5a384df30).

What if we want to work with the 2D space and store our data to do a fast retrieval? What if we’re going to find proximity ordering, such as find all the nearby points that are close to this point?

A natural order indexing will not work since we need to have two different indexes, one for point X and the other for point Y, and we have to search for all the places that are `X + delta` and `Y + delta` in the database and do an intersection.

We will need to use Spatial Indexing.

**Spatial Indexing** is often used for accessing 2D space efficiently. Use-cases that use Spatial Indexing are: ride-sharing application (Lyft, Uber), Food delivery service (Door dash) which needs to find the nearest food deliver to, Yelp wants to let you know the nearest restaurant from your location, hit detection, and more.

A couple of Spatial Indexing applications include **finding the K nearest neighbor** — an application that needs to get the nearest neighbor from the target object.

**Range Query:** finding an object containing a given point (point query) or overlapping with an area of interest (window of the query).

**Spatial Join**: Finding pairs of the object that interact spatially with each other. Using intersection, adjacency, and containment of spatial predicates to perform a spatial join.

Now that you get a glimpse of what spatial Indexing is, let’s talk about what sort of data structure, we need to store these data points for fast retrieval. If you think it is QuadTree, then you are correct. In the section below, I will explain what a QuadTree is and how it is useful to store sparse data for searching.

## What is a QuadTree?

Quadtrees are a way to partition space so that it is easier to traverse and search. It is a tree data structure that divides the value into four children, quad. A leaf node can hold some values depending on what application you are implementing. The subdivided region can be square or rectangle. A quadTree is similar to a Trie, except that they only have four children, and the way of determining those four children is with some criteria, such as if this point is in a particular range, traverse the top left quadrant.

Quadtree can help you anytime when you need to store sparse data that you need to search. It keeps data particles in the chemical reaction, pixels (image processing), and more.

For this article, I will implement the region quadtree.

Before we start, there are three components in the QuadTree. One is the point object you need to store. In this case, we can do `x` and `y`. Second is the QuadNode, which is the node that you want to hold inside your QuadTree. Lastly is the Tree itself.

## Point class

```Java
static class Point {
        int x;
        int y;
        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }

        // more like a deep clone
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

## QuadNode Class

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
            return "data " + data + " point " + point;
        }
    }

```

## QuadTree Class

```Java
class QuadTree<P> {    
    Point topLeft;
    Point bottomRight;
    Set<QuadNode<P>> nodes;
    // children (this can also be used like Trie, where it is an Array of QuadTree)
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

## Insertion

Like the [Binary Search tree](https://javarevisited.blogspot.com/2015/10/how-to-implement-binary-search-tree-in-java-example.html), we will need to start from the root and check which region the point belongs to. Then, we can recursively traverse down that region until we hit a leaf node.

Then, we insert the point in the quadtree’s leaf node and check if the quadtree needs to further `subdivide`. If it needs to promote `subdivide`, we will `subdivide` the region into four quadrants and redistribute the value inside to its children.

```Java
public void insert(Point p, P data) {
        QuadTree<P> curr = this;

        while(!curr.isLeaf()) {
            System.out.println("Inserting " + p + " data " + data);

            // check the topLeft and bottomLeft value based on x
            if(p.x < (curr.topLeft.x + curr.bottomRight.x) / 2) {
                // check for topLeft or bottomLeft by comparing it with y
                if(p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) { // it is in the topLeft
                    System.out.println("Is within topLeftTree py: " + p.y + " " + " mid: " + ((curr.topLeft.y + curr.bottomRight.y) / 2));
                    curr = curr.topLeftTree;
                } else { // it is in the bottomLeft
                    System.out.println("Is within bottomLeft");
                    curr = curr.bottomLeftTree;
                }

            } else { // check for topRight and bottomRight portion
                // check for topRight or bottomRight by comparing it with y
                if(p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) { // it is in the topRight
                    System.out.println("Is within topRight");
                    curr = curr.topRightTree;

                } else { // it is in the bottomRight
                    System.out.println("Is within bottomRight");
                    curr = curr.bottomRightTree;
                }
            }
        }

        // curr is Leaf
        QuadNode<P> quadNode = new QuadNode<>(p, data);
        curr.nodes.add(quadNode);
        // System.out.println("curr " + curr);
        // if the the point is the maxLen then we will need ot subdivide
        if(curr.shouldSubDivide()) {
            // System.out.println("data " + data +  " need to be subdivide");
            curr.subDivide();
        }
    }
```

## Search

Start from the root, check which region the point belongs to. Recursively traverse down that region until we reach the leaf node. Return the value of that [leaf node](https://javarevisited.blogspot.com/2016/12/how-to-count-number-of-leaf-nodes-in-java-recursive-iterative-algorithm.html), which contains a list of points.

```Java
public Set<QuadNode<P>> search(Point p) {
        QuadTree<P> curr = this;

        while(!curr.isLeaf()) {
            
            // recurse by checking if it is within the boundary
            if(p.x < (curr.topLeft.x + curr.bottomRight.x) / 2) {
                if(p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) {
                    curr = curr.topLeftTree;
                } else {
                    curr = curr.bottomLeftTree;
                }
            } else {
                if(p.y < (curr.topLeft.y + curr.bottomRight.y) / 2) {
                    curr = curr.topRightTree;
                } else {
                    curr = curr.bottomRightTree;
                }

            }
        }
  return curr.node;
 }
```

## Conclusion

* To store geolocation, a sequential search with natural ordering is not fast enough. We will use spatial Indexing to search for a 2D space.
* A quadTree is like an equivalent [data structure](https://medium.com/javarevisited/7-best-courses-to-learn-data-structure-and-algorithms-d5379ae2588) for a binary tree in the 1D space. However, we can use **QuadTree** for any time you have sparse data that you need to search.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
