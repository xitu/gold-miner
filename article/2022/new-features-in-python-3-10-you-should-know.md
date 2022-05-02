> * 原文地址：[New Features In Python 3.10 You Should Know](https://python.plainenglish.io/new-features-in-python-3-10-you-should-know-18aab7ebc911)
> * 原文作者：[Tola Ore-Aruwaji](https://medium.com/@thecraftman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/new-features-in-python-3-10-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2022/new-features-in-python-3-10-you-should-know.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[Chorer](https://github.com/Chorer), [w1187501630](https://github.com/w1187501630)

# 你需要了解的 Python 3.10 新特性

![](https://cdn-images-1.medium.com/max/3838/1*gcuS-mdPrHGeHLZHfacbUg.jpeg)

**大家好，欢迎关注本文。在本文中，我们将了解 Python 3.10 中的重大变化。**

在这个新版本中，有一些新的特性，程序的性能也有所改进。我们来了解一下。

## 结构化模式匹配

![](https://cdn-images-1.medium.com/max/2000/1*KAPJdxfXRc-EIza11iPcSA.png)

您可以将变量映射到一组不同的可能值，类似于他语言中的 switch-case 语句。你可以将这种特性与带有关联操作模式的 match 语句和 case 语句配合使用。 

在这个例子中，需要注意的是，你如何使用管道操作把几个有序集合组合在一起，但你不仅可以将它跟一个单一值匹配，还可以跟一个集合或一个类进行匹配。

![](https://cdn-images-1.medium.com/max/2000/1*3t1DQqu4Xl5kdgmhjUYzmA.png)

模式匹配是最有趣的新特性，它已经被应用于很多不同的场景。

## 括号内上下文管理器

![](https://cdn-images-1.medium.com/max/2000/1*ZsR8sWRgOwRVU8jQYICLWQ.png)

当上下文管理器与语句一起使用时，可以把上下文管理器放在括号内。同时也支持在多行中格式化一连串的上下文管理器。

## zip 函数的参数

![](https://cdn-images-1.medium.com/max/2000/1*oJNMeoq2Q5vWmYcbIOhhKw.png)

在 zip 方法中添加了一个可选的严格布尔关键字，确保所有可迭代对象具有相同的长度。Zip 方法创建一个迭代器，聚合来自多个可迭代对象的元素。默认行为是当到达长度较短可迭代对象的末尾时停止。在上面的示例中，它合并了两个数组中前两个元素并丢弃 name 数组中的第三个元素。

## 改进的错误提示

这是我发现的又一个有用的改进。很多错误提示不但传递了与错误有关的准确信息，而且提示了错误发生的准确位置。

例如，在这段代码中，缺少了一个括号，以前的错误提示只显示语法错误，甚至连发生错误的行号都没有。

![](https://cdn-images-1.medium.com/max/2000/1*fMuajdCWcyJjUOJhtQ3VBg.png)

现在，我们可以看到发生错误的行号、具体位置以及错误描述。

![](https://cdn-images-1.medium.com/max/2000/1*s1eC1iVuXEIdTBIfX3SV5w.png)

## 新的类型特性

类型模块为类型相关的操作提供了运行时支持，在 Python 3.10 引入了一种新的类型操作符，支持形如 **x pipe y** 的语句。这提供了一种更简洁的方式来表示类型 x 或类型 y，因此就不需要使用 type.union 了。

![](https://cdn-images-1.medium.com/max/2000/1*Q5cvcYoyKneH6MK9OIswAQ.png)

另外，这种新的语法也可用于它的实例或子类的第二个参数。现在，类型模块有一种特殊的值类型 `alias`，可以用于声明类型别名。这对类型检查很有用，可以用来区分类型别名和普通赋值。

## 更新和弃用

如今，Python 的 OpenSSL 环境要求是 111 或更新版本，不再支持较老的版本。这会影响其中的 **hash lib、hmac、SSL** 等模块，同时升级了 CPython 的一个关键依赖。整个 disk-utils 包也被弃用，在 3.12 版中将被移除。

![](https://cdn-images-1.medium.com/max/2000/1*grIH2jt1WZzDMV7i2oLGCA.png)

## 改进

![](https://cdn-images-1.medium.com/max/2000/1*YsQU3mf0oXIl1kHzj_T9NQ.png)

Python 3.10 没有添加新模块，而是更新了很多现有模块。这里有一张更新的模块的列表。

## 优化

![](https://cdn-images-1.medium.com/max/2000/1*FCjAgP7lsTVK0NmqyK9xAQ.png)

为了加快 Python 的速度，人们对它进行了各种优化，其中最重要的是，字符串、字节型数据和字节数组的构造速度加快了 30%~40%。

Python 3.10 实现了很多新特性，性能也有了极大的优化。最有趣的是模式匹配，我也很喜欢该版本中改进的错误信息。

**你可以在评论中谈谈自己喜欢的特性，你是否期待新版本中的升级，或者你是否已经在使用它。**

## 谢谢

喜欢本文吗？在下面点个赞，让其他读者也能看到。🙂

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
