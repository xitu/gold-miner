> * 原文地址：[How to Write Log Files That Save You Hours of Time](https://medium.com/better-programming/how-to-write-log-files-that-save-you-hours-of-time-1ff0cd9ae2ed)
> * 原文作者：[keypressingmonkey](https://medium.com/@keypressingmonkey)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-log-files-that-save-you-hours-of-time.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-write-log-files-that-save-you-hours-of-time.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：[QinRoc](https://github.com/QinRoc)

# 如何编写可节省您时间的日志文件

![Photo by [Pietro Jeng](https://unsplash.com/@pietrozj?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/11232/0*iqdOil183vfy81IT)

我需要在这里大声疾呼：我在工作中维护的程序有很多可爱的怪癖。“发生了错误”并不是其中之一。这不仅是错误消息的开头，也是消息的**结尾**。

或者这种错误消息怎么样呢？“该错误相关的信息保存在服务日志中”，但是根本没有指明哪个服务器抛出了这个异常。

本文介绍如何编写不会出错的日志和错误消息。

## 您真的需要这个吗？

本文大部分内容都是关于提供**更多**信息。但是，让我们看一下一些可以安全删除的日志消息。为什么？好吧，当您需要仔细阅读非常长的日志文件时，您将感激所有节省理智和精力的事情。

* 循环中每个迭代的“一切都好”的日志。在我知道程序已经正常启动并且可能即将进入该循环后，我只关心错误信息。
* 非性能测试时，那些随机记录性能的日志。
* 记录函数/计算的每个步骤的日志。当您已经记录了“a + b = c”时，您实际上不需要再记录“a”和“b”。

就像我说的，在大多数情况下，拥有更多的信息总是比拥有更少的信息好，哪怕信息量比需要的大。但最好还是要谨记避免走向另一个极端。

## 请告诉我错误是什么


日常生活中我们需要处理的大多数异常都没有被明确处理，这意味着我们经常会得到堆栈回溯。它能准确地告诉我们何时何地发生了什么。尽管它的可读性不是很高，但是至少您可以一路追溯到源代码。

但是，如果您要捕获异常并使用该 catch 块在控制台上打印“有些东西无法使用”一类的信息，甚至不将其输出到日志文件中，请不要这样做。如果您编写了一个自定义的异常处理程序，则只需多花一点时间来解释错误是什么。它是错误的数据库条目，例如名称格式错误吗？很好，现在我不必克隆该 repo 并进行调试，只需立即修复数据库中的条目即可。

## 请告诉我错误的出处

我修复错误时最大的痛点是：我们每天都会监控到错误消息，但是如果我甚至不知道错误消息的来源，写得再好的错误消息也不会有太大帮助。就应该像这样写：

```
致命错误：在 serverIWouldLikeToSlaughter 有无效转换
```

这样我就会非常高兴。

## 给我提供一些额外的参数

继续前面的示例，当您在记录错误消息时可能拥有所有的信息，那么为什么不将其提供给我呢？只需打印出您无法反序列化的客户 ID，帐单号和电子邮件地址。

```
致命错误：在 serverIWouldLikeToSlaughter 发生了从 Boolean 到 Integer 的无效的强制类型转换 
```

---

## 仅重载特定异常


如果您想为错误的数据类型或类似的东西抛出异常，则应该挂接到特定的异常上，如“invalidCastException”，而不是通用的“exception”。这样，最常见的错误将带有一个很棒的错误消息，有有意义的名称和描述。但是当发生任何非同寻常的异常时，您仍然会保留并记录完整的堆栈跟踪。
```
Try{thisOrthat();}
Catch castEx as InvalidCastException{
  log.error("detailed description of erro");
}
Catch ex as Exception{
  log.error(ex.stacktrace);
}
```

## 一起看看一些日志文件示例

以下是一些我随机选择的认为有用的日志条目示例，这些示例使您可以更轻松地理解错误的来源和解决方法：

```
-正在启动 server1 application4 
-正在连接 otherServer，端口号为 1337 …… 完成
-正在检查到 databaseServer5 的数据库连接。错误 400 ：当然它不起作用，您的凭据已过时，但是即使数据库管理员也不知道新的凭据是什么。
-程序于 00:34 pm 关闭，成功处理了 1234 个文件，23 失败, 跳过了 45 个
-无法打开文件 asdfadsfa.txt 因为该文件已被其它进程打开
-更新数据库表 tb_xyz 时出错，“name”列超过 50 的最大列长度限制
-处理 HTML 文本框失败，这通常是由数据库方面的格式问题引起的。与数据库管理员联系，从数据库中检索了以下值：<a \“> helloworld \” </a>
```

与根本不记录日志或以无效方式记录日志相比，仅仅是查找特定的错误，每条错误消息都可以为我节省半小时的时间。

## 要点

多花一分钟时间可以为以后节省数小时的时间。

希望您觉得这篇文章有趣。如果您没有数年修复 bug 的经验并且不了解各种错误的日志记录形式，这似乎是个很小并且很老套的问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
