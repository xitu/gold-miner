> * 原文地址：[How to read code without ripping your hair out](https://medium.com/launch-school/how-to-read-source-code-without-ripping-your-hair-out-e066472bbe8d)
> * 原文作者：[Sun-Li Beatteay](https://medium.com/@SunnyB)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-read-source-code-without-ripping-your-hair-out.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-read-source-code-without-ripping-your-hair-out.md)
> * 译者：[Mcskiller](https://github.com/Mcskiller)
> * 校对者：[xionglong58](https://github.com/xionglong58), [Endone](https://github.com/Endone)

# 如何心平气和地阅读代码

![](https://cdn-images-1.medium.com/max/10944/1*Vv0HNvRhU0ihKVaBIpDUww.jpeg)

1. 多写代码
2. 多读代码
3. 每天都完成以上内容

这是我在两年前转向编程时给我自己的要求。幸运的是，现在有很多在线编写代码的课程和教程可以教你写代码，然而他们却基本上都没有去教你如何阅读代码。

这是一个重要的区分点。随着进入科技领域的编程训练营毕业生数量的 [飞速增长](https://www.coursereport.com/reports/2016-coding-bootcamp-market-size-research)。强调阅读源码变得更加重要。Brandon Bloom [写道](https://news.ycombinator.com/item?id=3769446)：
> 如果它在 **你** 的机器上运行，它就是 **你** 的软件。**你** 应该对此负责，所以 **你** 必须对它了如指掌。

![Yes, you.](https://cdn-images-1.medium.com/max/2000/1*r_K_SnPFHV6BRZMcShNiPQ.gif)

虽然每个程序员都应该阅读源码，但 [事实](https://blog.codinghorror.com/learn-to-read-the-source-luke/) 并非如此。许多程序员不愿意阅读源码是因为它阅读起来很难，容易打击他们的信心，并且让他们感到自己很蠢。我知道，因为这就是我的感受。

**其实只是方法不对**

在我阅读其他人的代码时，我想出了一个只需要三步的阅读方法。可能有些人已经在遵循这些步骤，但我相信大部分人是没有的。

我的步骤如下。

## 1. 选一个你感兴趣的点

![Image Source: [https://thenextweb.com/wp-content/blogs.dir/1/files/2010/04/twitter-location-300x200.jpg](https://thenextweb.com/wp-content/blogs.dir/1/files/2010/04/twitter-location-300x200.jpg)](https://cdn-images-1.medium.com/max/2000/1*1jtCApS-67hwSYHOqwsDDw.png)

回想我第一次阅读源码的时候，那简直是一场灾难。

我当时正在学习 Sinatra，然后我想更好的了解底层运行机制。然而，我并不知道应该从哪里开始读，于是我找到了它在 Github 上的 repo 然后随便打开了一个文件。不开玩笑，我确实是这样做的。

我想我可以花一个下午来研究它，然后在吃晚饭的时候就可以完全掌握。毕竟，阅读我自己的代码很容易，阅读别人有什么不同？

我们都知道接下来会发生什么。可以这么说，我当时的感受像一头撞在了一堵文字墙上一样。

![](https://cdn-images-1.medium.com/max/2000/1*RSW1LI69w3Bgb1H7ynxDjw.gif)

我一次想学的东西太多了。许多初学者在第一次阅读源码的时候也会犯同样的错误。

**心智模型是一点一点建立起来的，阅读代码也应该如此。**

不要去试图以坚持努力来消化 1000 行代码，专注于一个主题。如果能够细化到单个方法更好。

有一个细化的焦点能够让你分清什么是相关的，什么是不相关的。没有必要去理会那些不相关的东西。

然而，选择一个特定的主题并不能解决你的所有问题。知道它在代码库中的位置仍然是个难题。

这就是第二步的问题了。

## 2. 找到一个切入点

![Image Source: [https://glenelmadventblog.files.wordpress.com/2012/12/loose-thread.jpg](https://glenelmadventblog.files.wordpress.com/2012/12/loose-thread.jpg)](https://cdn-images-1.medium.com/max/2000/1*suh4cGspVlBGRqF1QAVK_Q.png)

现在你有了一个想要学习的目标，接下来应该怎么做？

幸运的是，编程语言附带了检查工具。

对象的类，类的祖先，堆栈跟踪，还是某种方法的所有者，这是大多数语言都有的特性。无论你是想知道哪一个，一旦你开始分析代码库，你会遇到一系列问题。

与其用文字来解释这个概念，不如用代码展示来得更快。

### 开始分析

假设我想学习更多 ActiveRecord 的相关知识。然后我已经把重点缩小到了 `belongs_to` 方法上，现在我想了解它如何影响 ActiveRecord 模型。

ActiveRecord 是 [Rails](https://github.com/rails/rails) 的一部分，它是用 Ruby 构建的。Ruby 提供了大量开发工具。

我的第一种方法是使用调试工具，比如用 `pry` gem 来剖析我的 ActiveRecord 模型。对于之前的假设，这就是我选择调试的模型的代码。

```
class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  belongs_to :post
  binding.pry
  validates :body, presence: true
end
```

注意 `binding.pry` 语句。当 Rails 遇到这行代码时，`pry` 将会在执行中期暂停应用程序并打开命令行提示符。

下面是我研究 `belongs_to` 关联的时候在控制台使用的示例交换。

* 我的所有的输入内容都是在 `pry >` 之后。

* `=>` 显示控制台的输出。

```
pry> class = belongs_to(:post).class
=> ActiveRecord::Reflection::AssociationReflection

pry> class.ancestors
=> [ActiveRecord::Reflection::AssociationReflection,        
    ActiveRecord::Reflection::MacroReflection,
     ...omitted for brevity ]

pry> defined? belongs_to
=> "method"

pry> method(:belongs_to).owner
=> ActiveRecord::Associations::ClassMethods
```

如果你不太能理解 Ruby，并且这个交换让你感到困惑，可以看看我的提示。

* 当 `belongs_to :post` 运行时，它返回一个 `AssociationReflection` 类的实例。

* `MacroReflection` 是 `AssociationReflection` 的父类。

* `belongs_to` 是一个类方法，它是在 `ActiveRecord::Associations` 内部的 `ClassMethods` 模块上定义的。

现在我有了一些线索，但是我应该遵循哪一条呢？因为我对 `belongs_to` 方法本身更感兴趣，而不是它的返回值，所以我决定去查看 `ClassMethods` 模块。

## 3. 跟随线索

![](https://cdn-images-1.medium.com/max/2000/1*VP1Zze3OGAZnalmuvzJhhQ.png)

现在你已经有了想要跟随的目标，剩下的就是跟随它，直到找到你的答案。这似乎是一个简单的步骤，但这正是大多数初学者犯错的地方。

其中一个原因是，仓库是没有目录的。我们任由维护人员以可读的方式组织他们的文件。

对于有很多维护者的大型项目，这通常不是问题。

但对于一个小项目，你可能会发现自己要费力地逐个处理文件，逐个破译名称变量，然后就会多次遇到“这是从哪里来的”的情况。

### GitHub 搜索

有一个工具可以帮助我们更容易完成这个任务，就是 GitHub 搜索（我们假设你正在阅读的项目是在 Github 上的）。Github 搜索非常方便，因为他能够显示所有匹配搜索查询的文件。它还能显示符合查询的内容在文件中的位置。

![](https://cdn-images-1.medium.com/max/2000/1*bgk8AkVP2Uuk-Msj_LDrPg.png)

为了得到最好的结果，你需要让你的搜索尽可能具体。这需要你对你想找的内容有一个概念。盲目的搜索 Github 是没有用的。

回到步骤 2 中的示例，我试图在 `ActiveRecord::Associations` 中找到 `ClassMethods` 模块。用外行人的话来说，我正在寻找位于 `ActiveRecord` 模块内部的模块 `Associations` 中的 `ClassMethods` 模块。此外，我也在寻找 `belongs_to` 方法。

***

这是我的搜索查询。

![](https://cdn-images-1.medium.com/max/2000/1*iUg2iDC5kaqC8mbw2RZEUw.png)

结果准确地显示了我正在寻找的东西。

![](https://cdn-images-1.medium.com/max/2000/1*XWliUt7xdo2z2WUIwnBmYw.png)

![belongs_to method inside of ClassMethods](https://cdn-images-1.medium.com/max/2000/1*PDjJRgT-JEHgIEwJb5hWkw.png)

### 可能需要更多研究

***

Github 搜索将会显著的缩小你的搜索范围。因此，你可以更容易的找到一个深入代码库的切入点。

不幸的是，找到类或者方法不一定能给出问题的答案。你可能发现你从一个模块跳到另一个模块，直到你了解全局。

在我的例子中，`belongs_to` 类把我导向了 `BelongsTo` 中的 `build` 方法。这让我找到了 `Association` 的父类。

![build method in BelongsTo class](https://cdn-images-1.medium.com/max/2000/1*Mjx30BZtTxjPqMkdSINoqA.png)

![build method in Association class](https://cdn-images-1.medium.com/max/2000/1*WfqZWDnjg_rUiPZfdH1jGQ.png)

最后，我发现 `belongs_to` 让 Rails 向我的模型添加了几个实例方法，包括 getter 和 setter。它使用一种叫做元编程的高级编程技术来实现这一点。

Rails 还创建了一个 `Reflection` 类实例用于存储 association 中的信息。

来自 Rails API [文档](http://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html):
> Reflection 启用了检查 ActiveRecord 类和对象的关系和聚合的功能。例如，这种功能可以在 form builder 中使用，该 builder 接受一个 Active Record 对象然后根据其类型为所有属性创建输入字段，并显示它与其他对象的关联。

挺简洁的。

## 总结

虽然我不能保证解析别人的代码会很有意思，但这是值得的。它会给你的技术栈添加一项关键的技能，让你更加自由。你将不会再依赖于完整的文档和示例，虽然文档很棒，但它并不是万能的。正如 Jeff Atwood 说的：
> **你可能可以找到最好的，最权威和最新的文档，但是无论文档说什么，源代码才是最真实的。**

所以快去练习这项技能吧！

我相信你现在肯定有一些你一直都想了解的东西。不要纠结于代码库的大小。打开你最喜欢的框架的仓库然后开始学习。如果你按照我在文章中的步骤来，你很快就能成为一名源码专家。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
