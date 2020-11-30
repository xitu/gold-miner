> * 原文地址：[Xcode and LLDB Advanced Debugging Tutorial: Part 3](https://medium.com/@fadiderias/xcode-and-lldb-advanced-debugging-tutorial-part-3-8238aca63e7c)
> * 原文作者：[Fady Derias](https://medium.com/@fadiderias)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-3.md)
> * 译者：[kirinzer](https://github.com/kirinzer)
> * 校对者：[swants](https://github.com/swants), [iWeslie](https://github.com/iWeslie)

# [译] Xcode 和 LLDB 高级调试教程：第 3 部分

在这三部分教程的第一部分和第二部分中，我们已经介绍了如何利用 Xcode 断点来控制一个存在的属性值，并且通过表达式语句注入新的代码行。我们还探索了观察点这种特殊类型的断点。

我开发了一个特意带有几个错误的演示项目，详细说明了如何使用不同类型的断点配合 LLDB 来修复项目/应用程序中的错误。

如果你还没有看过本教程的 **[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md)** 和 **[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md)**，最好先看过它们再继续阅读本文。

最后，本教程的指导原则是： 

第一次运行应用程序后，你不必停止编译器或重新运行应用程序，你将在运行时修复这些错误。

## 符号断点 🔶

到目前为止我们还要做什么？

> 4. 导航栏左侧指示用户加载次数的标签没有更新。

这里有一些步骤可以复现这最后一个需要处理的错误：

✦ 滚动到表视图的顶部，然后下拉刷新。

✦ 滚动到表视图的底部去加载更多文章。[7 次 😉]

✦ 在每次成功获取到新的文章之后，左侧标签并没有被更新。

需要指出的是整型属性 `pageNumber` 回答了这个问题，用户已经加载了文章多少次？（换句话说，导航栏左侧的标签应该被 `pageNumber` 属性的值更新）。我们可以确信的是，在之前的修复中 `pageNumber` 属性的值已经可以更新了。因此现在的问题在于没有将它的值设置给导航栏左侧的标签。

在这种情况下，符号断点会介入。想象一下，符号断点就像调试器在玩寻宝，而你会提供一些寻宝的线索。对你来说，这会发生在更新导航栏左侧标签的代码片段中。

让我告诉你接下来怎么做。

展开 Breakpoint navigator，接着点击左下角 + 按钮，选择 Symbolic Breakpoint。

![](https://cdn-images-1.medium.com/max/2000/1*nI_n_rCvxBS5ZILJqDVzrA.png)

在 Symbol 栏添加如下符号

```
[UILabel setText:]
```

![](https://cdn-images-1.medium.com/max/2052/1*bd0Xm4s2qxGAAlPafpuHgQ.png)

**不要** 勾选 “Automatically continue after evaluating actions” 选项框。

我们所做的只是告诉调试器，当任何一个 UILabel 的 setText 方法被调用的时候，它就会暂停。注意这里在创建了一个符号断点之后，一个子断点会被添加。

![](https://cdn-images-1.medium.com/max/2000/1*pCPLepbfpWKJrNUfpprfow.png)

这是来自调试器的反馈，它能够解析这个创建的符号断点到 `UIKitCore` 框架的特定位置。在其他情况下，调试器也许会解析到多个位置。

现在一切就绪，下拉以刷新表视图的文章。当你释放之后，调试器就会暂停，接着你会看到如下图的东西：

![](https://cdn-images-1.medium.com/max/5676/1*qxcTdnmPUempljXsANz62Q.png)

在这时你会看到一些 UIKitCore 框架的汇编代码，在左侧的是导致调试器暂停的堆栈信息。下一步我们要做的是，检查在调试器暂停的位置传入 Objective-C 消息的参数。在 lldb 控制台输入下面的命令：

```
po $arg1
```

![](https://cdn-images-1.medium.com/max/4448/1*V33e1RQgoWtwNI8qy-AVJQ.png)

这会指出持有第一个参数的寄存器。我们能清楚的看到接受这个 Objective-C 消息的是一个 UILabel 实例。这个 UILabel 实例有一个文本值指向一个文章的标签。这不是我们所感兴趣的，不过让我们继续寄存器检查。

在 lldb 控制台，输入如下指令：

```
po $arg2
```

![](https://cdn-images-1.medium.com/max/2000/1*RF7qzO66OUAAZ61TwKg2GA.png)

$arg2 始终指向 Objective-C 消息的选择器。在某些情况下，lldb 并不完全的清楚参数的类型，因此我们需要做一些类型转换的工作。

在 lldb 控制台，输入如下指令：

```
po (SEL)$arg2
```

![](https://cdn-images-1.medium.com/max/2000/1*f7lc9OC3NZGDTpOssJ3PBQ.png)

现在我们很清楚的看到了当前 Objective-C 消息的选择器。

在 lldb 控制台，输入如下指令：

```
po $arg3
```

![](https://cdn-images-1.medium.com/max/2000/1*saKLYWOujvPhkmf3qcBD5g.png)

$arg3 始终指向传入方法的第一个参数。在我们的情形下，传入 setText 方法的参数一个字符串。

继续执行程序。调试器会再次暂停。重复前面的步骤，最终，你发现这个 Objective-C 消息属于在表视图里的另一个文章标签。直到我们找到我们感兴趣的那个 UILabel 实例前，一遍又一遍的做这个事情确实很无趣。肯定有更好的方式。

你能够做的一件事就是为符号断点设置条件，以便在成功或满足条件时暂停调试器。它能够检查布尔值或者等待条件达成诸如此类。

![](https://cdn-images-1.medium.com/max/2060/1*bDOd5KQn_VzWy8mA6OEcVA.png)

然而，我们采用一种不同的方法。

### One Shot!

将我们创建的符号断点设置为不可用。

讲道理，导航栏左侧的标签指示了用户加载文章的次数，它会在 HTTP GET 请求成功完成之后被更新。找到有 pragma mark `Networking` 的部分。在 `loadPosts` 成功完成的回调里放置一个断点。这个断点应该放在如下的位置：

**Objective-C**

```
[self.tableView reloadData];
```

![](https://cdn-images-1.medium.com/max/3180/1*7MH01DMLDpUFGrBz0P4MkA.png)

**Swift**

```
self.tableView.reloadData()
```

![](https://cdn-images-1.medium.com/max/2776/1*I69SoCZ3fAlaviM0WUWTXA.png)

这会确保符号断点只有在表视图重新加载数据之后才会被触发，所有相等的标签都已经被更新。

**不要** 勾选 “Automatically continue after evaluating actions” 选项框。添加如下的调试器命令动作：

```
breakpoint set --one-shot true -name '-[UILabel setText:]'
```

🤨🧐🤔

让我们拆解这个命令：

1. breakpoint set --one-shot true 会创建一个 “one-short” 断点。one-shot 断点是一种创建之后，首次触发就会自动删除的断点。

2. `-name ‘- [UILabel setText:]’` 给创建的 one-shot 断点设置了一个符号名。这和你上一节所做的非常相似。

让我总结一下这一部分。你所做的有：

1. 在发起 GET 请求成功完成的回调里添加断点（A）。

2. 添加调试器命令动作去 **创建** 符号断点（B）和上一节创建的很相似。这个符号是 `UILabel` `setText` 方法。

3. 将你创建的符号断点（B）设置为一个 one-shot 断点。one-shot 断点在触发后会被自动删除，这意味着符号断点只会暂停调试器一次。

4. 断点（A）被放置在表视图加载完成之后，因此创建的符号断点（B）不会因任何和表视图相关联的标签而暂停调试器。

现在下拉表视图去刷新。我们会得到如下内容：

![Objective-C](https://cdn-images-1.medium.com/max/2332/1*JLBQAj7srx3twyCnScnVSg.png)

![Swift](https://cdn-images-1.medium.com/max/2044/1*2gcJPkL-VZ3HIebwOsqMZA.png)

由于设置了 one-shot 断点调试器停在了断点（A）的位置。

继续执行程序。

你会返回到 UIKitCore 框架的汇编代码。

![](https://cdn-images-1.medium.com/max/5676/1*qxcTdnmPUempljXsANz62Q.png)

让我们检查一下符号断点参数的 Objective-C 消息。

在 lldb 控制台，输入如下的指令：

```
po $arg1
```

![](https://cdn-images-1.medium.com/max/3712/1*U7on9rNp2KTxH0vBu_5pwg.png)

哇哦，看起来你找到了宝藏！ 🥇🏆🎉

是时候把我们的目光转移到堆栈跟踪信息了。**走到点 1 的位置。**

![Objective-C](https://cdn-images-1.medium.com/max/4728/1*kx3XCFR0kcnpD5XC1tqtng.png)

![Swift](https://cdn-images-1.medium.com/max/3788/1*42LvhyQXygvMOF0dWphR2g.png)

它会引导你到这块更新 `pageNumberLabel` 文本的代码。这块代码很明显为文本始终设置了整型值为 `0` 而不是 `pageNumber` 属性的格式字符串。让我们在实际修改代码前先测试一下。

你现在已经是行家了 🧢

在已标记的代码分隔线下添加一个断点。添加如下的调试器命令动作：

**Objective-C**

```
expression self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %tu", self.pageNumber]
```

![](https://cdn-images-1.medium.com/max/3520/1*VzRgynkwtDmcMFBveP1BrQ.png)

**Swift**

```
expression pageNumberLabel.text = String(format: "Page %tu", pageNumber)
```

![](https://cdn-images-1.medium.com/max/3564/1*IreVT3ZC9rTiC8B60WcxSw.png)

移除或者停用断点（A）,相应地，断点（B）也会被停用。

现在下拉刷新和加载更多文章。左侧导航栏标签将会被更新。 🎉

任务完成！ 💪 💪

现在你可以停止编译器并且在代码中去修复我们讨论的这些问题。

### 总结

在这个教程里，你学会了

1. 如何使用断点配合调试器动作表达式去控制存在的属性值。

2. 如何使用断点配合调试器动作表达式注入代码。

3. 如何为某个属性设置观察点监视属性值的变化。

4. 如何基于定义的符号使用符号断点暂停调试器。

5. 如何使用 one-shot 断点。

6. 如何使用 one-shot 断点配合符号断点。

调试愉快！ 😊

### 第三方工具

为了本教程的方便，我使用了下面的第三方工具。

* [typicode](https://github.com/typicode)/[json-server](https://github.com/typicode/json-server)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
