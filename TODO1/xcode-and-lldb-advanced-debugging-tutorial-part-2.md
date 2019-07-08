> * 原文地址：[Xcode and LLDB Advanced Debugging Tutorial: Part 2](https://medium.com/@fadiderias/xcode-and-lldb-advanced-debugging-tutorial-part-2-8bfeae4cdfdb)
> * 原文作者：[Fady Derias](https://medium.com/@fadiderias)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md)
> * 译者：[kirinzer](https://github.com/kirinzer)
> * 校对者：[iWeslie](https://github.com/iWeslie), [JasonWu1111](https://github.com/JasonWu1111)

# Xcode 和 LLDB 高级调试教程：第 2 部分

在三部分教程的第一部分，我们介绍了如何利用 Xcode 断点操作现有的属性值，以及使用表达式语句注入新代码。

我特地开发了一个带有几个错误的演示项目，详细说明了如何使用不同类型的断点配合 LLDB 来修复项目/应用程序中的错误。

在继续阅读本文之前，最好先看过本教程的 [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md)。

让我提醒一下你，本教程的重要规则是：
第一次运行应用程序后，你不必停止编译器或重新运行应用程序，你会在运行时修复这些错误。

## 观察点 👀

让我们向下一个敌人进军。

> 3. 用户可以加载文章 **超过** 7 次。

这里有复现这个错误的步骤：

✦ 打开手机或模拟器的网络连接。

✦ 滚动到表视图的底部，加载更多数据。

✦ 滚动加载更多文章的次数超过 7 次。（记住，对于当前的应用程序，用户只能加载文章 7 次）

考虑这个错误的一个方法是弄清 `pageNumber` 这个整形属性自从它被传入到网络管理器，去取回指定页码的新文章对象后是怎样被改变的。你将会花费一些时间和精力在你还不清楚的代码库里，并且弄清这个错误发生在哪里。

不要担心！现在让我们做一些神奇的事 🎩

在这个教程的第一部分，你了解到 GET HTTP 请求发生在用 pragma mark `Networking` 标记的部分。那里只有一个方法 `loadPosts`。在这个方法的第一行放置一个断点，然后下拉刷新，加载新的文章对象。这个动作会触发你刚才设置的断点。

![Objective-C](https://cdn-images-1.medium.com/max/4052/1*yCeuuv8HfObRgYewJLwhyA.png)

![Swift](https://cdn-images-1.medium.com/max/3256/1*czpn47AuKgaGvyIv5ImIIQ.png)

在底部的调试器窗口，点击“展示变量视图按钮”。接着就会滑出一个包含了 **PostsTableViewController** 所有属性的视图。

![](https://cdn-images-1.medium.com/max/4464/1*PbTSXBMHhfXOKxfe_Tec8Q.png)

找到 `pageNumber` 属性，右键单击，选择 “Watch \_pageNumber” / “Watch pageNumber”。

![Objective-C](https://cdn-images-1.medium.com/max/3280/1*rrJVnhAGpu-pxhNt7CFIBg.png)

![Swift](https://cdn-images-1.medium.com/max/3056/1*bayE0ZKUW5wwccGdtc7gQQ.png)

这会为 `pageNumber` 属性创建一个叫做“观察点”的断点。观察点是一种断点，当下一次观察的属性有变化的时候它会暂停调试器。

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*CSbAyFyweJdaU3lfnXebnw.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*qJXkvHWpGmHI7DquZW5zZA.png)

继续执行程序。调试器将会暂停，你将会看到一些类似下图的东西：

### Objective-C

![](https://cdn-images-1.medium.com/max/5680/1*PEH5x-D85rp9qYo9MtwiJw.png)

1. `pageNumber` 属性旧值和新值的日志。

2. 导致 `pageNumber` 属性发生变化的方法调用栈。

3. 导致`pageNumber` 属性实际发生改变的当前点。这是属性的 setter 方法。

如果你回到方法调用栈的第一个点，它将会引导你找到以下的代码：

![](https://cdn-images-1.medium.com/max/2000/1*6rOdWkY4TxqbzLZfTCZJeg.png)

### Swift

![](https://cdn-images-1.medium.com/max/5672/1*1AGmy4ThuDgFizPn_2mFSA.png)

1. 调试器控制台通知你，所设置的观察点被触发。

2. 导致 `pageNumber` 属性发生变化的方法调用栈。

3. 导致 `pageNumber` 属性实际发生改变的当前点。这是一个叫 `updateForNetworkCallEnd` 的方法。

很显然每当 HTTP GET 请求成功时，只要 `state` 枚举属性处于 active 状态，`pageNumber` 属性就会加 1。`state` 枚举属性可以是 “active” 或者 “inactive”。“active” 状态是指，用户可以继续加载更多文章(就是说没有达到上限数字)。“inactive” 状态则与之相反。结论是，我们需要在 `updateForNetworkCallEnd` 内部实现一些逻辑，可以检查 `pageNumber` 属性，并设置相应的 `state` 枚举属性。

正如你之前所学到的，最好的方式是在不停止编译器的情况下，先测试一下假设，然后再去实际的修改代码。

你猜对了 😉

重要的是，在 pragma mark `Support` 下面已经有了一个实现好的方法，可以设置 `state` 枚举属性。这个方法是 `setToInactiveState`。

在条件语句上一行添加一个断点。接着添加一个调试器动作，然后填写如下的调试器命令。

### Objective-C

```
expression if (self.pageNumber >= 7) {[self setToInactiveState]}
```

![](https://cdn-images-1.medium.com/max/2788/1*2oH3kYHboDK5XUnX0vT3Qg.png)

### Swift

```
expression if (self.pageNumber >= 7) {setToInactiveState()}
```

![](https://cdn-images-1.medium.com/max/2548/1*hcNVcXsvH-sGqP5-PdMjmg.png)

做完这些之后，你需要停用之前设置观察点的断点，同时也停用了观察点。

![Objective-C](https://cdn-images-1.medium.com/max/4140/1*u9im1mihdCdGDJSoAJfAzg.png)

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*-fCWpD7jlLFw8LjxX92JXg.png)

![Swift](https://cdn-images-1.medium.com/max/3336/1*5a1UhRJ5tXFZKJrdjOv2Ow.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*S0ttr15900z7q-6znr19yA.png)

现在回到表视图顶部，下拉刷新，接着向下滚动。

**不要高兴的太早，我们还有一个大问题要解决** 😄⚔️

## 接下来去哪里？

查看 [**第三部分**](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-3.md) 教程修复了最后的错误，并学习一种新的类型断点类型，符号断点。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
