> * 原文地址：[Implementing Heaps in JavaScript](https://blog.bitsrc.io/implementing-heaps-in-javascript-c3fbf1cb2e65)
> * 原文作者：[Ankita Masand](https://medium.com/@amasand23)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/implementing-heaps-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/implementing-heaps-in-javascript.md)
> * 译者：[HurryOwen](https://github.com/HurryOwen)
> * 校对者：[z0gSh1u](https://github.com/z0gSh1u)、[kezhenxu94](https://github.com/kezhenxu94)、[JohnieXu](https://github.com/JohnieXu)

# 用 JavaScript 实现堆

![](https://miro.medium.com/max/1400/1*QaLcagYMG4iC9W6qjuHpDA.jpeg)

大部分编程语言都支持一些特定数据类型，例如 `int`、`string`、`boolean` 等等。我们可以自定义数据类型来存储一类数据，并且这个数据类型有一定的方法。这些功能可以应用于数据点以获取有意义的结果。自定义数据结构的逻辑模型叫做**抽象数据结构（Abstract Data Type，简称 ADT）**，其物理实现是一种**数据结构**。数据结构是计算机科学中最基础的单元，为了高效地解决问题，使用正确的数据结构也非常重要。比较大众化的数据结构有**数组**、**栈**、**队列**、**链表**、**树**、**堆**等等。不像其他高级语言，大部分数据类型并没有包含在原生的 JavaScript 运行时。

在这篇文章中，我们将去看看一个有趣的数据结构 —— 堆！

> 堆数据结构不像 Object、Map 和 Set，在原生 JavaScript 中并不支持。

我们将要从头开始实现堆。但是首先，让我们尝试理解堆是什么以及堆解决了什么样的计算机科学问题？

## 什么是堆

堆是一种满足堆属性的完全二叉树。

**完全二叉树是指，除了最后一层外每一层都被完全填满，并且所有结点都尽可能向左。**

马上我们就会讲到未知的堆属性。现在先来看看二叉堆是什么样子：

![二叉堆示意图](https://cdn-images-1.medium.com/max/2000/1*ahBuj8eiKkIALwvlxJdzeQ.png)

堆基本上是用来及时地获取在任何位置的优先级最高的元素。基于堆的属性有两种类型的堆 —— **小顶堆（MinHeap）**和**大顶堆（MaxHeap）**。

- **小顶堆**: 父母结点都小于子节点
- **大顶堆**: 父母结点都大于或等于子节点

![小顶堆、大顶堆示意图](https://cdn-images-1.medium.com/max/2000/1*5-_bPyIEw3-XtPVi3lCVzA.png)

在**小顶堆**中，根结点 `10` 小于它的两个子节点 `23` 和 `36`，并且 `23` 和 `36` 也小于它们各自的子节点。

在**大顶堆**中，根结点 `57` 大于它的两个子节点 `38` 和 `45 `，并且 `38` 和 `45 ` 也大于它们各自的子节点。

## 为什么我们需要堆

堆主要用于获取堆中的最大值或者最小值，时间复杂度为 `O(1)` 。当数据元素个数为`n`时，**数组**或者**链表**这种线性数据结构获取这个值的时间复杂度为 `O(n)` ，二叉查找树（BST）获取这个值的时间复杂度为 `O(log n)` 。

下面是堆上执行各种操作的时间复杂度：

- **获取最小或最大值**: `O(1)`
- **插入一个元素**: `O(log n)`
- **删除一个元素**: `O(log n)`

堆使得访问优先级元素的速度非常快。[优先队列](https://en.wikipedia.org/wiki/Priority_queue) 数据结构就是用堆来实现的。顾名思义，你可以使用优先队列在 `O(1)` 时间内按优先级访问元素。它通常用在 [Dijkstra 算法](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)，[Huffman 编码](https://en.wikipedia.org/wiki/Huffman_coding)中。如果你不知道这些算法也不用担心！接下来的文章中将会详细介绍它们。

**我们已经知道了，堆可以让我们更快地访问到最大或最小的元素，但是，首先为什么我们需要这些元素？**

下面是一些使用堆的真实案例：

1. 操作系统使用堆按优先级调度作业。
2. 生产者消费者模型可以用堆来实现，让消费者先访问高优先级的元素。在[阻塞优先队列](https://www.geeksforgeeks.org/priorityblockingqueue-class-in-java/)的实现中用到了。
3. 其他运用包括，在数组中找到第 K 小或者第 K 大的元素这样的顺序统计、堆排序算法、Dijkstra 这样的找到最短路径的图算法，以及 Prim 最小生成树。

## 怎么实现堆？

我们用树来表示堆，但是它们并不像树那样存储在内存中。让我们尝试把堆转换成数组，看看结果如何：

![使用数组实现二进制堆](https://cdn-images-1.medium.com/max/2000/1*ZyMG4K50VjgBVkY_Bfcxaw.png)

请注意我在数组中添加元素的顺序。元素 `10` 在位置 `0`，它的两个孩子在位置 `1` 和 `2` 。然后我添加了 `23` 的孩子结点 —— `32` & `38`。在这些结点之后，又添加了 `36` 的两个孩子结点。我一层一层地在数组中添加这些元素，同样得到了大顶堆！

**但是为什么我们要遵循这种一层一层地填充数组的特殊排列呢？**

如果你仔细观察，最小或最大元素都被放在各自数组的第 `0` 个位置。我们访问到这些元素的 时间复杂度为常量 `O(1)`。

如果父母结点在第 `0` 个位置，它的两个孩子结点在这个数组的第 `1` 和第 `2` 个位置。这就是父母结点和孩子结点在二叉堆中的关系：

![二进制堆中父节点和子节点的数组索引关系](https://cdn-images-1.medium.com/max/2000/1*VzH_-Gq0LOMRLTktzflc5g.png)

通过上图，我们可以推断在第 `i` 个位置的任意元素的孩子结点分别位于 `2*i + 1` 和 `2*i + 2`。同时我们也可以通过公式 `i/2` 反推出第 `i` 个位置的元素的父母结点。请注意：这仅适用于二叉堆。

堆可以用数组或者链表实现，但是通常我们还是用数组来实现。现在让我们进入最有趣部分，开始实现堆！

我们将要实现 `MinHeap`，它将拥有在堆中获取最小元素和插入新元素、删除元素的方法。让我们从创建一个 `MinHeap` 的类开始：

```JavaScript
class MinHeap {

    constructor () {
        /* 初始化数组堆，并且在位置 0 加一个额外的元素 */
        this.heap = [null]
    }

    getMin () {
        /* 获取在位置 1 的最小元素 */
        return this.heap[1]
    }
}
```

这里什么事都没有发生！我只是创建了一个叫 `heap` 的数组并且位置 `0` 上初始化为`null`。实际的堆将会从第一个位置开始填充。这么做只是为了更好理解。`getMin` 是一个简单的方法，用来返回堆中的第一个元素。

**在堆中访问最小或最大元素的时间复杂度是 `O(1)`**

前面提到，堆除了最后一层都是完全二叉树。从左往右插入新结点，并且每次每次插入都要维护堆属性。让我们看看实际操作：

![二叉堆中插入元素](https://cdn-images-1.medium.com/max/2000/1*to65iKzq3VLUYPyOclk2lQ.png)

上图清晰的揭示了二叉堆中的插入，但为了更好的理解，让我用语言来表达：

`insert(10)`：二叉堆是空的，我们想插入 `10` 作为第一个结点。`10` 添加在第一个位置，简单！

`insert(23)`：堆是从左往右填充的。现在 `23` 作为 `10`的左孩子添加。由于父母结点 `10` 已经小于子节点了，所以我们在这里不用做任何事！

`insert(36)`：结点 `36` 作为结点 `10` 的右孩子被添加。我们不需要在这里转移任何结点，因为小顶堆的属性已经被处理了。

`insert(18)`：结点 `18` 作为结点 `23` 的左孩子被添加，这扰乱了小顶堆的属性 —— **孩子结点应该小于父母结点**。现在我们向上遍历堆给结点 `18` 找一个合适的位置。先让结点 `18` 与父母结点 `23` 比较，由于节点 `18` 小于 `23`，于是这两个结点对调。现在比较 `18` 和 `10` ，`18`  是大于 `10` 的，这意味着，现在结点 `18` 是在这个堆上的正确位置上。

这就是我们在一个二叉堆中插入一个结点的方式！让我们写一些代码去实现这个插入函数：

```JavaScript
insert (node) {

    /* 在堆数组的末尾插入新结点 */
    this.heap.push(node)
    
    /* 给新结点找到正确的位置 */

    if (this.heap.length > 1) {
        let current = this.heap.length - 1
        
        /* 遍历父母结点直到当前结点（current）比父母结点（current/2）大 */
        while (current > 1 && this.heap[Math.floor(current/2)] > this.heap[current]) {
        
            /* 通过 ES6 解构语法 交换两个结点 */
            [this.heap[Math.floor(current/2)], this.heap[current]] = [this.heap[current], this.heap[Math.floor(current/2)]]
            current = Math.floor(current/2)
        }
    }
}
```

上面的代码应该不难理解！我们首先在数组末尾添加新结点（记住，一个堆是一个完全树，除了最后一层，并且它从左往右填充）。

现在我们开始检查当前元素及其父元素。如果当前节点比父母结点小，就交换他们的位置。请注意：当前节点的索引为 `current`，其父母节点的索引为` current/2`。我们用 **ES6 的数组结构语法**来交换着两个元素。插入或删除元素之后平衡堆的过程叫做**堆化（heapify）**。当我们遍历堆去给新结点找到合适的位置时，通常叫做**往上堆化（heapifyUp）**。

往一个有 `n` 个元素二叉堆插入一个新元素的时间复杂度是 `O(log n)`。在每次迭代中要比较的元素减少一半，因此是 `log n`。

现在，让我们看看从堆中删除一个元素会发生什么：

![从二进制堆中删除最小元素](https://cdn-images-1.medium.com/max/2042/1*STrcM_P_ns8nxv0cktdRWw.png)

纠正上图：第四幅图的标题应该删除改为 —— **57 比它的两个孩子结点 32 和 38 大，所以 32 和 57 交换**

在这里，我们移除了堆中的最小结点`10`。
根结点移除后，最右的结点（`57`）就放在了根结点的位置上。你可以看到第二幅图上结点 `57` 变成了根结点。我们必须恢复小顶堆的属性。

我们先往下遍历堆，然后检查孩子结点是不是比父母节点小。如果有孩子结点比父母节点小，把父母节点跟它最小的孩子结点交换。

请注意在第三幅图中，我们交换了 `23` 和 `57`，在第四幅图中我们交换了 `32` and `57`。现在第四幅图是一个合法的堆了！

让我们实现这个删除方法。这有点难！请仔细阅读插图，了解谁在哪里转移以及为什么要转移！

下面是删除方法的代码：

```JavaScript
remove() {
    /* 堆数组中的最小元素在位置 1 */
    let smallest = this.heap[1]
    
    /* 当数组中的元素超过两个，我们把最右的元素放在第一个位置上，然后开始跟它的孩子结点比较 */
    if (this.heap.length > 2) {
        this.heap[1] = this.heap[this.heap.length-1]
        this.heap.splice(this.heap.length - 1)

        if (this.heap.length === 3) {
            if (this.heap[1] > this.heap[2]) {
                [this.heap[1], this.heap[2]] = [this.heap[2], this.heap[1]]
            }
            return smallest
        }

        let current = 1
        let leftChildIndex = current * 2
        let rightChildIndex = current * 2 + 1

        while (this.heap[leftChildIndex] &&
                this.heap[rightChildIndex] &&
                (this.heap[current] > this.heap[leftChildIndex] ||
                    this.heap[current] > this.heap[rightChildIndex])) {
            if (this.heap[leftChildIndex] < this.heap[rightChildIndex]) {
                [this.heap[current], this.heap[leftChildIndex]] = [this.heap[leftChildIndex], this.heap[current]]
                current = leftChildIndex
            } else {
                [this.heap[current], this.heap[rightChildIndex]] = [this.heap[rightChildIndex], this.heap[current]]
                current = rightChildIndex
            }

            leftChildIndex = current * 2
            rightChildIndex = current * 2 + 1
        }
    }
    
    if (this.heap[rightChildIndex] === undefined && this.heap[leftChildIndex] < this.heap[current]) {
        [this.heap[current], this.heap[leftChildIndex]] = [this.heap[leftChildIndex], this.heap[current]]
    }
    
    /* 如果数组中只有两个元素，我们直接把第一个元素 splice 出去 */
    
    else if (this.heap.length === 2) {
        this.heap.splice(1, 1)
    } else {
        return null
    }

    return smallest
}
```

我们首先用变量 `smallest` 存储在位置 `1` 的最小值。如果这个堆的元素大于 2 个，我们就要去检查是否符合小顶堆的属性。如果这个堆的元素是 2 个，我们无需检查。只要简单的用 `splice` 函数移除在位置 `1` 的元素。你可以在 `else if` 块中看到这个操作。

现在让我们转入巨大的 `if` 块，它做了大部分工作。我们首先把最后一个元素放在位置 `1` ，然后删除堆中的最后一个元素，如下：

```js
this.heap[1] = this.heap[this.heap.length-1]
this.heap.splice(this.heap.length - 1)
```

如果堆中仅剩三个元素的话，要保持堆的属性很简单。我们只需要简单地把最小的结点与根结点交换。就是这样！

如果堆中还有三个元素以上，我们向下遍历堆去给根结点找一个合适的位置。这个向下遍历堆的过程通常叫做**向下堆化**。

while 块中的条件看起来很大一块，实际上并没有发挥太大作用！它仅检查了当前元素是不是比它的两个孩子结点都要小。然后最小的孩子结点和父母结点交换，相应地，`current` 也改变了。

`leftChildIndex` 和 `rightChildIndex` 的值也改变了，如下：

```js
leftChildIndex = current * 2 // i* 2
rightChildIndex = current * 2 + 1 // i * 2 + 1
```

`remove` 方法现在看起来很简单了！我建议你自己编写整个代码，以便对 `insert` 和 `remove` 等操作是如何在二叉堆中工实现的有一个牢固的理解。

下面是实现小顶堆的完整代码

```JavaScript
class MinHeap {

    constructor () {
        /* 初始化数组堆，并且在位置 0 加一个假元素 */
        this.heap = [null]
    }

    getMin () {
        /* 获取在位置 1 的最小元素 */
        return this.heap[1]
    }
    
    insert (node) {

        /* 在堆数组的末尾插入新结点 */
        this.heap.push(node)

        /* 给新结点找到正确的位置 */

        if (this.heap.length > 1) {
            let current = this.heap.length - 1

            /* 遍历父母结点直到当前结点（current）比父母结点（current/2）大 */ 
            while (current > 1 && this.heap[Math.floor(current/2)] > this.heap[current]) {

                /* 通过 ES6 解构语法 交换两个结点 */ 
                [this.heap[Math.floor(current/2)], this.heap[current]] = [this.heap[current], this.heap[Math.floor(current/2)]]
                current = Math.floor(current/2)
            }
        }
    }
    
    remove() {
        /* 堆数组中的最小元素在位置1 */ 
        let smallest = this.heap[1]

        /* 当数组中的元素超过两个，我们把最右的元素放在第一个位置上，然后开始跟它的孩子结点比较 */ 
        if (this.heap.length > 2) {
            this.heap[1] = this.heap[this.heap.length-1]
            this.heap.splice(this.heap.length - 1)

            if (this.heap.length === 3) {
                if (this.heap[1] > this.heap[2]) {
                    [this.heap[1], this.heap[2]] = [this.heap[2], this.heap[1]]
                }
                return smallest
            }

            let current = 1
            let leftChildIndex = current * 2
            let rightChildIndex = current * 2 + 1

            while (this.heap[leftChildIndex] &&
                    this.heap[rightChildIndex] &&
                    (this.heap[current] < this.heap[leftChildIndex] ||
                        this.heap[current] < this.heap[rightChildIndex])) {
                if (this.heap[leftChildIndex] < this.heap[rightChildIndex]) {
                    [this.heap[current], this.heap[leftChildIndex]] = [this.heap[leftChildIndex], this.heap[current]]
                    current = leftChildIndex
                } else {
                    [this.heap[current], this.heap[rightChildIndex]] = [this.heap[rightChildIndex], this.heap[current]]
                    current = rightChildIndex
                }

                leftChildIndex = current * 2
                rightChildIndex = current * 2 + 1
            }
        }

        /* 如果数组中只有两个元素，我们直接把第一个元素 splice 出去 */

        else if (this.heap.length === 2) {
            this.heap.splice(1, 1)
        } else {
            return null
        }

        return smallest
    }
}
```

自己尝试着写大顶堆的代码。你只需要轻微地调整一些 `if` 条件，并不难。

## 总结

我们了解到，堆数据结构就是一个符合堆属性的近乎完全的树。我们拿到堆中最小或最大的元素，时间复杂度为 `O(1)` 。我们可以使堆来实现优先队列，堆主要用于按优先级访问元素。在下一篇文章中，我们看一些比较受欢迎的关于堆的面试题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
