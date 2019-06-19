> * 原文地址：[Minimize for loop usage in Python](https://towardsdatascience.com/minimize-for-loop-usage-in-python-78e3bc42f03f)
> * 原文作者：[Rahul Agarwal](https://medium.com/@rahul_agarwal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/minimize-for-loop-usage-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/minimize-for-loop-usage-in-python.md)
> * 译者：[qiuyuezhong](https://github.com/qiuyuezhong)
> * 校对者：[MollyAredtana](https://github.com/MollyAredtana)、[shixi-li](https://github.com/shixi-li)

# 减少 Python 中循环的使用

> 如何以及为什么应该在 Python 中减少循环的使用？

![Photo by [Etienne Girardet](https://unsplash.com/@etiennegirardet?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6528/0*aYSzzvJDJ28kV200)

Python 提供给我们多种编码方式。

在某种程度上，这相当具有包容性。

来自于任何语言的人都可以编写 Python。

**然而，学习写一门语言和以最优的方式写一门语言是两件不同的事情。**

在这一系列名为 [**Python Shorts**](https://bit.ly/2XshreA) 的文章中，我将阐述 Python 提供的一些简单但是非常有用的结构，一些小技巧以及一些我在数据科学工作中遇到的案例。

在这篇文章中，**我将讨论 Python 中的 `for` 循环，以及如何尽量避免使用它们。**

## 写 for 循环的 3 种方式：

让我用一个简单的例子来解释下。

假设你想取得**一个列表中的平方和。**

在机器学习中，当我们想计算 n 维情况下两点之间的距离时，我们都会面临这个问题。

你可以使用循环很容易的做到这一点。

事实上，我想展示给你**我看到的用来完成同样任务的三种方式，并让你选择你认为最好的方式。**

```python
x = [1,3,5,7,9]
sum_squared = 0

for i in range(len(x)):
    sum_squared+=x[i]**2
```

当我在 Python 代码中看到以上代码的时候，我知道这个人是拥有 C 或者 Java 背景的。

完成同样的事情，**更 Pythonic 的方式**是：

```python
x = [1,3,5,7,9]
sum_squared = 0

for y in x:
    sum_squared+=y**2
```

这样更好了。

我没有索引这个列表。并且我的代码更具有可读性。

但是，更 Pythonic 的方式一行就可以完成。

```python
x = [1,3,5,7,9]
sum_squared = sum([y**2 for y in x])
```

**这种方法称为 List Comprehension，这很可能是我爱上 Python 的原因之一。**

你也可以在 List Comprehension 中使用 `if`。

假设我们只想要偶数的平方数列表。

```python
x = [1,2,3,4,5,6,7,8,9]
even_squared = [y**2 for y in x if y%2==0]
# 输出结果：
[4,16,36,64]
```

**`if-else`？**

如果我们同时想要偶数的平方数和奇数的立方数呢？

```python
x = [1,2,3,4,5,6,7,8,9]
squared_cubed = [y**2 if y%2==0 else y**3 for y in x]
# 输出结果：
[1, 4, 27, 16, 125, 36, 343, 64, 729]
```

太棒了！

![](https://cdn-images-1.medium.com/max/2000/0*E3GXaHSrdRSdcikf.png)

因此，大体上遵循这个具体的**准则**：每当你想写一个 `for` 语句的时候，你应该问自己以下的问题，

* 可以不用 `for` 做到吗？更 Pythonic 的风格。
* 可以用 **List Comprehension** 做到吗？如果是，使用它。
* 可以不索引数组吗？如果不是，考虑使用 `enumerate`。

什么是 `enumerate`？

有时我们既需要数组中的索引，也需要数组中的值。

在这种情况下，我更喜欢使用 **enumerate** 而不是索引列表。

```python
L = ['blue', 'yellow', 'orange']
for i, val in enumerate(L):
    print("index is %d and value is %s" % (i, val))
# 输出结果：
index is 0 and value is blue
index is 1 and value is yellow
index is 2 and value is orange
```

有个规则是：

> 绝不索引一个列表，如果你能不使用它。

## 尝试使用 Dictionary Comprehension

也可以尝试使用 **Dictionary Comprehension**，它是 Python 中相对较新的补充，语法和 List Comprehension 很相似。

让我用一个例子来解释。我想为 x 中的每个值获取一个 dictionary（key：平方值）。

```python
x = [1,2,3,4,5,6,7,8,9]
{k:k**2 for k in x}
# 输出结果：
{1: 1, 2: 4, 3: 9, 4: 16, 5: 25, 6: 36, 7: 49, 8: 64, 9: 81}
```

如果只想得到偶数值的 dictionary 怎么办？

```python
x = [1,2,3,4,5,6,7,8,9]
{k:k**2 for k in x if x%2==0}
# 输出结果：
{2: 4, 4: 16, 6: 36, 8: 64}
```

如果想同时得到偶数值的平方和奇数值的立方怎么办？

```python
x = [1,2,3,4,5,6,7,8,9]
{k:k**2 if k%2==0 else k**3 for k in x}
# 输出结果：
{1: 1, 2: 4, 3: 27, 4: 16, 5: 125, 6: 36, 7: 343, 8: 64, 9: 729}
```

## 结论

最后，我要说的是，虽然看上去很容易将从其他语言获得的知识移用到 Python 上，但如果继续这样做，你将无法理解到 Python 的优美。当我们用 Python 的方式使用它，它的功能要强大得多，也要有趣得多。

**所以，当需要 `for` 循环的时候，使用 List Comprehensions 和 Dictionary Comprehensions。当需要数组索引的时候，使用 `enumerate`。**

> 避免像传染病一样的循环

从长远来看，你的代码将更具可读性和可维护性。

另外，如果您想了解更多关于 Python 3 的知识，我想推荐密歇根大学的一门优秀课程 [Intermediate level Python](https://bit.ly/2XshreA)。一定要去看看。

将来我也会写更多适合初学者的文章。请让我知道你对这个系列的看法。关注我的 [**Medium**](https://medium.com/@rahul_agarwal) 或订阅我的[**博客**](https://mlwhiz.com/)以了解相关信息。

和往常一样，我欢迎反馈和建设性的评论，可以通过 Twitter 联系 [@mlwhiz](https://twitter.com/mlwhiz)。

**最初在 2019 年 4 月 23 号发布于 [https://mlwhiz.com](https://mlwhiz.com/blog/2019/04/22/python_forloops/)。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
