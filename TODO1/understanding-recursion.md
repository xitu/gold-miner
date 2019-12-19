> * 原文地址：[Understanding Recursion, Tail Call and Trampoline Optimizations](https://marmelab.com/blog/2018/02/12/understanding-recursion.html)
> * 原文作者：[Thiery Michel](https://twitter.com/hyriel_mecrith)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-recursion.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-recursion.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[PingHGao](https://github.com/PingHGao)，[Chorer](https://github.com/Chorer)

# 理解递归、尾调用优化和蹦床函数优化

想要理解递归，您必须先理解递归。开个玩笑罢了，[递归](https://en.wikipedia.org/wiki/Recursion)是一种编程技巧，它可以让函数在不使用 `for` 或 `while` 的情况下，使用一个调用自身的函数来实现循环。

## 例子 1：整数总和

例如，假设我们想要求从 1 到 i 的整数的和，目标是得到以下结果：

```js
sumIntegers(1); // 1
sumIntegers(3); // 1 + 2 + 3 = 6
sumIntegers(5); // 1 + 2 + 3 + 4 + 5 = 15
```

这是不用递归来实现的代码：

```js
// 循环
const sumIntegers = i => {
    let sum = 0; // 初始化
    do { // 重复
        sum += i; // 操作
        i --; // 下一步
    } while(i > 0); // 循环停止的条件

    return sum;
}
```

用递归来实现的代码如下：

```js
// 循环
const sumIntegers = (i, sum = 0) => { // 初始化
    if (i === 0) { // 
        return sum; // 结果
    }

    return sumIntegers( // 重复
        i - 1, // 下一步
        sum + i // 操作
    );
}

// 甚至实现得更简单
const sumIntegers = i => {
    if (i === 0) {
        return i;
    }
    return i + sumIntegers(i - 1);
}
```

这就是递归的基础。

注意，递归版本中是没有**中间变量**的。它不使用 `for` 或者 `do...while`。由此可见，它是**声明式**的。

我还可以告诉您的是，事实上递归版本比循环版本**慢**  —— 至少在 JavaScript 中是这样。但是递归解决的不是性能问题，而是可表达性的问题。

![《盗梦空间》](https://marmelab.com/images/blog/inception1.jpg)

## [](#example-2-sum-of-array-elements)例子 2：数组元素之和

让我们尝试一个稍微复杂一点的例子，一个将数组中的所有数字相加的函数。

```js
sumArrayItems([]); // 0
sumArrayItems([1, 1, 1]); // 1 + 1 + 1 = 3
sumArrayItems([3, 6, 1]); // 3 + 6 + 1 = 10

// 循环
const sumArrayItems = list => {
    let result = 0;
    for (var i = 0; i++; i <= list.length) {
        result += list[i];
    }
    return result;
}
```

正如您所看到的，循环版本是命令性的：您需要确切地告诉程序要**做什么**才能得到所有数字的和。下面是递归的版本：

```js
// 递归
const sumArrayItems = list => {
    switch(list.length) {
        case 0:
            return 0; // 空数组的和为 0
        case 1:
            return list[0]; // 一个元素的数组之和，就是这个唯一的元素。#显而易见
        default:
            return list[0] + sumArrayItems(list.slice(1)); // 否则，数组的和就是数组的第一个元素 + 其余元素的和。
    }
}
```

递归版本中，我们并没有告诉程序要**做什么**，而是引入了简单的规则来**定义**数组中所有数字的和是多少。这可比循环版本有意思多了。

如果您是函数式编程的爱好者，您可能更喜欢 `Array.reduce()` 版本：

```text
// reduce 版本
const sumArrayItems = list => list.reduce((sum, item) => sum + item, 0);
```

这种写法更短，而且更直观。但这是另一篇文章的主题了。

![《盗梦空间》](https://marmelab.com/images/blog/inception2.jpg)

## [](#example-3-quick-sort)例子 3：快速排序

现在，我们来看另一个例子。这次的更复杂一点：[快速排序](https://zh.wikipedia.org/wiki/Quicksort)。快速排序是对数组排序最快的算法之一。

快速排序的排序过程：获取数组的第一个元素，然后将其余的元素分成比第一个元素小的数组和比第一个元素大的数组。然后，再将获取的第一个元素放置在这两个数组之间，并且对每一个分隔的数组重复这个操作。

要用递归实现它，我们只需要遵循这个定义：

```js
const quickSort = array => {
    if (array.length <= 1) {
        return array; // 一个或更少元素的数组是已经排好序的
    }
    const [first, ...rest] = array;

    // 然后把所有比第一个元素大和比第一个元素小的元素分开
    const smaller = [], bigger = [];
    for (var i = 0; i < rest.length; i++) {
        const value = rest[i];
        if (value < first) { // 小的
            smaller.push(value);
        } else { // 大的
            bigger.push(value);
        }
    }

    // 排序后的数组为
    return [
        ...quickSort(smaller), // 所有小于等于第一个的元素的排序数组
        first, // 第一个元素
        ...quickSort(bigger), // 所有大于第一个的元素的排序数组
    ];
};
```

简单，优雅和声明式，通过阅读代码，我们可以读懂快速排序的定义。

现在想象一下用循环来实现它。我先让您想一想，您可以在本文的最后找到答案。

![《盗梦空间》](https://marmelab.com/images/blog/inception3.jpg)

## [](#example-4-get-leaves-of-a-tree)例子 4：取得一棵树的叶节点

当我们需要处理**递归数据结构**（如树）时，递归真的很有用。树是具有某些值和`孩子`属性的对象；孩子们又包含着其他的树或叶子（叶子指的是没有孩子的对象）。例如：

```js
const tree = {
    name: 'root',
    children: [
        {
            name: 'subtree1',
            children: [
                { name: 'child1' },
                { name: 'child2' },
            ],
        },
        { name: 'child3' },
        {
            name: 'subtree2',
            children: [
                {
                    name: 'child1',
                    children: [
                        { name: 'child4' },
                        { name: 'child5' },
                    ],
                },
                { name: 'child6' }
            ]
        }
    ]
};
```

假设我需要一个函数，该函数接受一棵树，返回一个叶子（没有孩子节点的对象）数组。预期结果是：

```js
getLeaves(tree);
/*[
    { name: 'child1' },
    { name: 'child2' },
    { name: 'child3' },
    { name: 'child4' },
    { name: 'child5' },
    { name: 'child6' },
]*/
```

我们先用老方法试试，不用递归。

```js
// 对于没有嵌套的树来说，这是小菜一碟
const getChildren = tree => tree.children;

// 对于一层的递归来说，它会变成：
const getChildren = tree => {
    const { children } = tree;
    let result = [];

    for (var i = 0; i++; i < children.length - 1) {
        const child = children[i];
        if (child.children) {
            for (var j = 0; j++; j < child.children.length - 1) {
                const grandChild = child.children[j];
                result.push(grandChild);
            }
        } else {
            result.push(child);
        }
    }

    return result;
}

// 对于两层：
const getChildren = tree => {
    const { children } = tree;
    let result = [];

    for (var i = 0; i++; i < children.length - 1) {
        const child = children[i];
        if (child.children) {
            for (var j = 0; j++; j < child.children.length - 1) {
                const grandChild = child.children[j];
                if (grandChild.children) {
                    for (var k = 0; k++; j < grandChild.children.length - 1) {
                        const grandGrandChild = grandChild.children[j];
                        result.push(grandGrandChild);
                    }
                } else {
                    result.push(grandChild);
                }
            }
        } else {
            result.push(child);
        }
    }

    return result;
}
```

呃，这已经很令人头疼了，而且这只是两层递归。您想想看如果递归到第三层、第四层、第十层会有多糟糕。

 而且这仅仅是求一些叶子；如果您想要将树转换为一个数组并返回，又该怎么办？更麻烦的是，如果您想使用这个循环版本，您必须确定您想要支持的最大深度。

现在看看递归版本：

```js
const getLeaves = tree => {
    if (!tree.children) { // 如果一棵树没有孩子，它的叶子就是树本身。
        return tree;
    }

    return tree.children // 否则它的叶子就是所有子节点的叶子。
        .map(getLeaves) // 在这一步，我们可以嵌套数组 （[child1, [grandChild1, grandChild2], ...]）
        .reduce((acc, item) => acc.concat(item), []); // 所以我们用 concat 来连接铺平数组 [1,2,3].concat(4) => [1,2,3,4] 以及 [1,2,3].concat([4]) => [1,2,3,4]
}
```

仅此而已，而且它适用于任何层级的递归。

## [](#drawbacks-of-recursion-in-javascript)JavaScript 中递归的缺点

遗憾的是，递归函数有一个很大的缺点：该死的越界错误。

```text
Uncaught RangeError: Maximum call stack size exceeded
```

与许多语言一样，JavaScript 会跟踪**堆栈**中的所有函数调用。这个堆栈大小有一个最大值，一旦超过这个最大值，就会导致 `RangeError`。在循环嵌套调用中，一旦根函数完成，堆栈就会被清除。但是在使用递归时，在所有其他的调用都被解析之前，第一个函数的调用不会结束。所以如果我们调用太多，就会得到这个错误。

![《盗梦空间》](https://marmelab.com/images/blog/inception5.jpg)

为了解决堆栈大小问题，您可以尝试确保计算不会接近堆栈大小限制。这个限制取决于平台，这个值似乎都在 10,000 左右。所以，我们仍然可以在 JavaScript 中使用递归，只是需要小心谨慎。

如果您不能限制递归的大小，这里有两个解决方案：尾调用优化和蹦床函数优化。

## [](#tail-call-optimization)尾调用优化

所有严重依赖递归的语言都会使用这种优化，比如 Haskell。JavaScript 的尾调用优化的支持是在 Node.js v6 中实现的。

[尾调用](https://en.wikipedia.org/wiki/Tail_call) 是指一个函数的最后一条语句是对另一个函数的调用。优化是在于让尾部调用函数替换堆栈中的父函数。这样的话，递归函数就不会增加堆栈。注意，要使其工作，递归调用必须是递归函数的**最后一条语句**。所以 `return loop(..);` 是一次有效的尾调用优化，但是 `return loop() + v;` 不是。

让我们把求和的例子用尾调用优化一下：

```js
const sum = (array, result = 0) => {
    if (!array.length) {
        return result;
    }
    const [first, ...rest] = array;

    return sum(rest, first + result);
}
```

这使运行时引擎可以避免调用堆栈错误。但是不幸的是，它在 Node.js 中已经不再有效，因为[在 Node 8 中已经删除了对尾调用优化的支持](https://stackoverflow.com/questions/42788139/es6-tail-recursion-optimisation-stack-overflow/42788286#42788286)。也许将来它会支持，但到目前为止，是不存在的。

## [](#trampoline-optimization)蹦床函数优化

另一种解决方法叫做[蹦床函数](http://funkyjavascript.com/recursion-and-trampolines/)。其思想是使用延迟计算稍后执行递归调用，每次执行一个递归。我们来看一个例子：

```js
const sum = (array) => {
    const loop = (array, result = 0) =>
        () => { // 代码不是立即执行的，而是返回一个稍后执行的函数：它是惰性的
            if (!array.length) {
                return result;
            }
            const [first, ...rest] = array;
            return loop(rest, first + result);
        };

    // 当我们执行这个循环时，我们得到的只是一个执行第一步的函数，所以没有递归。
    let recursion = loop(array);

    // 只要我们得到另一个函数，递归过程中就还有其他步骤
    while (typeof recursion === 'function') {
        recursion = recursion(); // 我们执行现在这一步，然后重新得到下一个
    }

    // 一旦执行完毕，返回最后一个递归的结果
    return recursion;
}
```

这是可行的，但是这种方法也有一个很大的缺点:它很**慢**。在每次递归时，都会创建一个新函数，在大型递归时，就会产生大量的函数。这就很令人心烦。的确，我们不会得到一个错误，但这会减慢（甚至冻结）函数运行。

![《盗梦空间》](https://marmelab.com/images/blog/inception6.jpg)

## [](#from-recursion-to-iteration)从递归到迭代

如果最终出现性能或者最大调用堆栈大小超出的问题，您仍然可以将递归版本转换为迭代版本。但不幸的是，正如您将看到的，迭代版本通常更复杂。

让我们以 `getLeaves` 的实现为例，并将递归逻辑转换为迭代。我知道结果，我以前试过，很糟糕。现在我们再试一次，但这次是递归的。

```js
// 递归版本
const getLeaves = tree => {
    if (!tree.children) { // 如果一棵树没有孩子，它的叶子就是树本身。
        return tree;
    }

    return tree.children // 否则它的叶子就是所有子节点的叶子。
        .map(getLeaves) // 在这一步，我们可以嵌套数组 （[child1, [grandChild1, grandChild2], ...]）
        .reduce((acc, item) => acc.concat(item), []); // 所以我们用 concat 来连接铺平数组 [1,2,3].concat(4) => [1,2,3,4] 以及 [1,2,3].concat([4]) => [1,2,3,4]
}
```

首先，我们需要重构递归函数以获取累加器参数，该参数将用于构造结果。它写起来甚至会更短：

```js
const getLeaves = (tree, result = []) => {
    if (!tree.children) {
        return [...result, tree];
    }

    return tree.children
        .reduce((acc, subTree) => getLeaves(subTree, acc), result);
}
```

然后，这里技巧就是将递归调用展开到剩余计算的堆栈中。**在递归外部**初始化结果累加器，并将进入递归函数的参数推入堆栈。最后，将堆叠的运算解堆叠，得到最后的结果：

```js
const getLeaves = tree => {
    const stack = [tree]; // 将初始树添加到堆栈中
    const result = []; // 初始化结果累加器

    while (stack.length) { // 只要堆栈中有一个项
        const currentTree = stack.pop(); // 得到堆栈中的第一项
        if (!currentTree.children) { // 如果一棵树没有孩子，它的叶子就是树本身。
            result.unshift(currentTree); // 所以把它加到结果里
            continue;
        }
        stack.push(...currentTree.children);// 否则，将所有子元素添加到堆栈中，以便在下一次迭代中处理
    }

    return result;
}
```

这好像有点难，所以让我们用 quickSort 再次做一次。这是递归版本：

```js
const quickSort = array => {
    if (array.length <= 1) {
        return array; // 一个或更少元素的数组是已经排好序的
    }
    const [first, ...rest] = array;

    // 然后把所有比第一个元素大和比第一个元素小的元素分开
    const smaller = [], bigger = [];
    for (var i = 0; i < rest.length; i++) {
        const value = rest[i];
        if (value < first) { // 小的
            smaller.push(value);
        } else { // 大的
            bigger.push(value);
        }
    }

    // 排序后的数组为
    return [
        ...quickSort(smaller), // 所有小于等于第一个的元素的排序数组
        first, // 第一个元素
        ...quickSort(bigger), // 所有大于第一个的元素的排序数组
    ];
};
```



```js
const quickSort = (array, result = []) => {
    if (array.length <= 1) {
        return result.concat(array); // 一个或更少元素的数组是已经排好序的
    }
    const [first, ...rest] = array;

    // 然后把所有比第一个元素大和比第一个元素小的元素分开
    const smaller = [], bigger = [];
    for (var i = 0; i < rest.length; i++) {
        const value = rest[i];
        if (value < first) { // 小的
            smaller.push(value);
        } else { // 大的
            bigger.push(value);
        }
    }

    // 排序后的数组为
    return [
        ...quickSort(smaller, result), // 所有小于等于第一个的元素的排序数组
        first, // 第一个元素
        ...quickSort(bigger, result), // 所有大于第一个的元素的排序数组
    ];
};
```

然后使用堆栈来存储数组进行排序，在每个循环中应用前面的递归逻辑将其解堆栈。

```js
const quickSort = (array) => {
    const stack = [array]; // 我们创建一个数组堆栈进行排序
    const sorted = [];

    //我们遍历堆栈直到它被清空
    while (stack.length) {
        const currentArray = stack.pop(); // 我们取堆栈中的最后一个数组

        if (currentArray.length == 1) { // 如果只有一个元素，那么我们把它加到排序中
            sorted.push(currentArray[0]);
            continue;
        }
        const [first, ...rest] = currentArray; // 否则我们取数组中的第一个元素

        //然后把所有比第一个元素大和比第一个元素小的元素分开
        const smaller = [], bigger = [];
        for (var i = 0; i < rest.length; i++) {
            const value = rest[i];
            if (value < first) { // 小的
                smaller.push(value);
            } else { // 大的
                bigger.push(value);
            }
        }

        if (bigger.length) {
            stack.push(bigger); // 我们先向堆栈中添加更大的元素来排序
        }
        stack.push([first]); // 我们在堆栈中添加 first 元素，当它被解堆时，更大的元素就已经被排序了
        if (smaller.length) {
            stack.push(smaller); // 最后，我们将更小的元素添加到堆栈中来排序
        }
    }

    return sorted;
}
```

瞧！我们就这样有了快速排序的迭代版本。但是记住，这只是一个优化，

> 不成熟的优化是万恶之源 —— 唐纳德·高德纳

因此，仅在您需要时再这样做。

![《盗梦空间》](https://marmelab.com/images/blog/inception4.jpg)

## [](#conclusion)结论

我喜欢递归。它比迭代版本更具声明式，并且通常情况下代码也更短。递归可以轻松地实现复杂的逻辑。尽管存在堆栈溢出问题，但在不滥用的前提下，在 JavaScript 中使用它是没问题的。并且如果有需要，可以将递归函数重构为迭代版本。

所以尽管它有缺点，我还是向您强烈安利它！

如果您喜欢这种模式，可以看看 Scala 或 Haskell 等函数式编程语言。它们也喜欢递归！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
