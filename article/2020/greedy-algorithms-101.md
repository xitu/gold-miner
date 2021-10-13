> * 原文地址：[Greedy Algorithms 101](https://codeburst.io/greedy-algorithms-101-957842232cf2)
> * 原文作者：[Mario Osorio](https://medium.com/@mario5o)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/greedy-algorithms-101.md](https://github.com/xitu/gold-miner/blob/master/article/2020/greedy-algorithms-101.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[PingHGao](https://github.com/PingHGao)、[司徒公子](https://github.com/stuchilde)


# 贪心算法，你入门了吗？

![](https://cdn-images-1.medium.com/max/2000/0*udmPDWYUmHDNJX5D)

贪心算法在大多数情况下都易于实现，在求解最优问题时，也是最常用的编码套路之一，而且它的资源消耗也比较低。

不过这个算法也有缺点，它不能保证每次都能找到最优解，有时候只能找到接近最优解的方案。不管怎样，在很多情况下，接近最优解就足够了。

这个算法一般是对规模为 “**n**” 的问题迭代 “**n**” 次，所以它的复杂度可能是 O(n)，O(n × log(n))，但是不会超过 O(n²)。

这个算法能解决的大多数问题都有以下两个特性：

1. **贪心属性**：它的意思是每次迭代时都采用局部最优解，而无需考虑对全局的影响。我们相信通过不断求解局部最优解终会得到全局最优解，但是正如我之前所说，这个结论不一定成立。为了证明在每次迭代中都求得了最优解，我们需要使用归纳法（显然不是简单的证明）。
2. **最优子结构**: 我之前提到过一些。求解的问题必须能划分为子问题，每个子问题都有最优解。

本文中，我们将学习如何编写自己的贪心算法，然后用这个算法解决一个非常著名的难题。

## 贪心算法通用模版 (Java)

```Java
public ArrayList greedy(ArrayList candidates) {
    solution;
    while (!isSolution(solution) && (candidatesLeft(candidates)) {
            cadidate = selectCandidate(candidates);
            removeCandidate(candidate, candidates);
            if (isGoodCandidate(candidate, solution)) {
                addCandidate(candidate, solution);
            }
        }
        if (isSolution(solution)) {
            return solution;
        } else {
            return null;
        }
    }
}
```

在解释代码之前，我先给出一些在伪代码中用到的术语的定义。

1. **Candidates:** 所有可能的解集。它可以是任意的数据类型，但通常是可迭代的。在我们处理示例问题时，会加深对它的理解。现在请先记住结论 😁。
2. **Candidate:** 在解集中，我们当前选中的一个解。
3. **Solution:** 解变量的第一个实例只需是一种数据结构，在这里我们将存储当前的解。
4. **isSolution, candidatesLeft, removeCandidate, addCandidate, isGoodCandidate:** 这些也是我们要创建的方法，其中的某些方法在一些实际问题中不必是完整的，但是为了总结代码模版，我把它们全部定义为方法。

首先，我们初始化解的数据结构，它可以是数组，布尔值，整数…… 我们只需要声明一下。

```
solution
```

然后，我们看一下这个 while 循环，它的循环条件中有两个方法。这些方法必须编写，但有时并不需要完整的方法体，例如，判断是否有剩余备选解的这个方法。

```js
while (!isSolution(solution) && (candidatesLeft(candidates))
```

当我们发现当前尚未找到解，并且有剩余备选解可以尝试时，我们将选择一个备选解，并立即将其从我们的备选解集中删除。

```js
cadidate = selectCandidate(candidates);
removeCandidate(candidate, candidates);
```

下一步很简单。如果候选解是正确的解，则只需将其添加到解结构中。

```js
if (isGoodCandidate(candidate, solution)) { 
    addCandidate(candidate, solution); 
}
```

然后，我们只需检查问题是否已达到解决的状态，然后将解返回。

```js
if (isSolution(solution)) { 
    return solution; 
} else { 
    return null; 
}
```

至此我们已经看完了代码并对其进行了粗略的解释，现在我给您出道题，请您尝试自己解答。这是一个众所周知的问题，在网上很容易就能搜到答案，但我建议您还是尝试自己解决。

---

## 零钱兑换的问题

有6种硬币，每种硬币的值分别为 {50，20，10，5，2，1}，它们按递减排序作为参数传递。 **每种硬币都可能成为我们的候选解**。您必须找到一种最佳的兑换方式。（**用最少的硬币找零**）

**示例输入：** 15（**我们必须以最少的硬币数量凑齐 15 并返回硬币集合**）

**示例输出：** 10、5（**我们返回了和为 15 的硬币集合，且硬币数量最少**）

在这个确定的硬币系统 {50，20，10，5，2，1} 中，该算法能找到最优解，但是请注意，如果候选解发生改变，可能会导致该算法无法找到最优解。

#### 提示

如果您没有足够努力尝试，就不应该看这一段内容 🤨…… 开个玩笑，继续吧，我确信~~我希望~~您已经学到了一些新知识 😄。

* 在 **selectCandidate()**   方法中，首先选择面额最大的硬币，然后用较小的硬币填充剩余的零钱。在这个过程中，您要一直检查是否超出剩余的零钱。

#### 解法

我提供的解法用 Java 编写的，其中用到了面向对象的知识。

```Java
public class Coin {
    private int value;
    private int quantity;
    Moneda(int value, int quantity) {
        this.value = value;
        this.quantity = quantity;
    }
    /* getters & setters */
}

/* This is actually the "hard" part */
int selectCandidate(ArrayList < Integer > values) {
    int biggest = Integer.MIN_VALUE;
    for (Integer coin: values)
        if ((biggest < coin)) biggest = coin;
    return biggest;
}

/* Now the actual schema */

ArrayList < Coin > greedySchema(ArrayList < Integer > values, int quantity) {
    /* We initialize our solution structure */
    ArrayList < Coin > solution = new ArrayList < Coin > ();
    /* Any auxiliary variable is ok */
    int value;
    
    while ((quantity > 0) && (!values.isEmpty())) {
        /* Select and remove the coin from our monetary system */
        value = selectCandidate(values);
        values.remove(new Integer(value));
        
        /* If this is true, it meanwe can still look for coins to give */
        if ((quantity / value) > 0) {
            solution.add(new Coin(value, quantity / value));
            /* This will lower the quantity we need to give back */
            quantity = quanity % value;
        }
    }
    
    /* Once the quantity is 0 we are DONE! */
    if (quantity == 0) {
        return solution;
    } else return null;
}
```

#### 资源

如果您喜欢贪心算法的工作原理，并且想深入研究，请访问 [Hackerrank](https://www.hackerrank.com/) 或者 [Hackerearth](https://www.hackerearth.com/practice/)，这里有有很多要解决的问题，我相信您已经对它们有一定了解 😊。

有时，我个人也会把 GitHub 作为搜索引擎，并简单地写下我寻找的主题 [[贪心算法](https://github.com/search?q=greedy+algorithm)]。

## 结论

综上所述，即使对于简单的个人项目，贪心算法也能表现优异，它不需要你花费太多时间去思考，并且只消耗很少的资源。而且，使用贪心算法可以轻松解决很多面试问题。大多数时候，使用贪心或动态规划都可以满足内存和复杂度方面的要求，但这就是另一个话题了 😉。

感谢您的阅读，欢迎评论 😄。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
