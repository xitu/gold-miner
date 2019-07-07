> * 原文地址：[Xcode and LLDB Advanced Debugging Tutorial: Part 3](https://medium.com/@fadiderias/xcode-and-lldb-advanced-debugging-tutorial-part-3-8238aca63e7c)
> * 原文作者：[Fady Derias](https://medium.com/@fadiderias)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-3.md)
> * 译者：[kirinzer](https://github.com/kirinzer)
> * 校对者：

# [译] Xcode 和 LLDB 高级调试教程：第 3 部分

在这三部分教程的第一部分和第二部分中，我们已经介绍了如何利用 Xcode 断点来控制一个存在的属性值，并且通过表达式语句注入新的代码行。 我们还探索了观察点这种特殊类型断点的。

我开发了一个带有几个特殊错误的演示项目，详细说明了如何使用不同类型的断点配合 LLDB 来修复项目/应用程序中的错误。

如果你还没有看过本教程的 **[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md)** 和 **[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md)**，最好先看过它们再继续阅读本文。

最后，本教程的重要规则是： 

第一次运行应用程序后，你不必停止编译器或重新运行应用程序，你会在运行时修复这些错误。

## 符号断点 🔶

到目前为止我们怎么样了？

> 4. 导航栏左侧指示用户加载次数的标签没有更新。

这里有一些步骤可以复现这最后一个需要处理的错误：

✦ 滚动到表视图的顶部，然后下拉刷新。

✦ 滚动到表视图的底部去加载更多文章。[7 次 😉]

✦ 在每次成功获取到新的文章之后，左侧标签并没有被更新。

需要指出的是整形属性 `pageNumber` 回答了这个问题，用户已经加载了文章多少次？（换句话说，导航栏左侧的标签应该被 `pageNumber` 属性的值更新）。我们可以确信的是，在之前的修复中 `pageNumber` 属性的值已经可以更新了。因此现在的问题在于没有将它的值设置给导航栏左侧的标签。

在这种情况下，符号断点会进入。想象一下，符号断点就像调试器在玩寻宝，而你会提供一些寻宝的线索。对你来说，这会发生在更新导航栏左侧标签的代码片段中。

让我告诉你接下来怎么做。

展开断点导航器，接着点击左下角 + 按钮，选择符号断点。

![](https://cdn-images-1.medium.com/max/2000/1*nI_n_rCvxBS5ZILJqDVzrA.png)

添加如下符号

```
[UILabel setText:]
```

![](https://cdn-images-1.medium.com/max/2052/1*bd0Xm4s2qxGAAlPafpuHgQ.png)

**不要** 勾选 “Automatically continue after evaluating actions” 选项框。

What we’re simply doing here is informing the debugger that whenever the setText function of any UILabel is called, it should pause. Notice that after creating the symbolic breakpoint, a child has been added.

![](https://cdn-images-1.medium.com/max/2000/1*pCPLepbfpWKJrNUfpprfow.png)

It’s a feedback from the debugger that it was able to resolve the created symbolic breakpoint to a specific location inside `UIKitCore` framework. In other cases, the debugger might resolve the symbolic breakpoint to multiple locations.

Now you’re all set, pull down to refresh the posts table view. As soon as you release, the debugger will pause, and you’ll be seeing something like this:

![](https://cdn-images-1.medium.com/max/5676/1*qxcTdnmPUempljXsANz62Q.png)

At this point, you’re looking at some assembly code of the UIKitCore framework and on the left side is the stack trace that did cause the debugger to pause. The next thing we want to do is to inspect the arguments passed into the Objective-C message the debugger did pause at. In the lldb console, type the following:

```
po $arg1
```

![](https://cdn-images-1.medium.com/max/4448/1*V33e1RQgoWtwNI8qy-AVJQ.png)

This does point out to the register that holds the first argument. We can clearly see that the receiver of that Objective-C message is a UILabel instance. The UILabel instance has a text value that refers to a post label. It’s not what we are interested in, but let’s proceed with the registers inspection.

In the lldb console, type the following:

```
po $arg2
```

![](https://cdn-images-1.medium.com/max/2000/1*RF7qzO66OUAAZ61TwKg2GA.png)

The $arg2 does always refer to the selector of the Objective-C message. In some cases, the lldb doesn’t implicitly know the types of the arguments, and hence we need to do some typecasting.

In the lldb console, type the following:

```
po (SEL)$arg2
```

![](https://cdn-images-1.medium.com/max/2000/1*f7lc9OC3NZGDTpOssJ3PBQ.png)

Now, we can clearly see the selector of the current Obj-c message.

In the lldb console, type the following:

```
po $arg3
```

![](https://cdn-images-1.medium.com/max/2000/1*saKLYWOujvPhkmf3qcBD5g.png)

The $arg3 does always refer to the first parameter passed into the method. In our case, that is the string that is passed to the setText method.

Continue the execution of the program. The debugger will pause again. Repeat the above steps and eventually, you’ll figure out that the objective-c message belongs to another label of a post in the table view. It’s quite nonsense to keep doing this over and over again till we reach the UILabel instance that we are interested in. Things can definitely be better.

One thing you can do is to set a condition for the symbolic breakpoint to pause the debugger upon the success/fulfilment of that condition. This can be checking on a boolean value or waiting for a specific state to be reached .. etc.

![](https://cdn-images-1.medium.com/max/2060/1*bDOd5KQn_VzWy8mA6OEcVA.png)

However, we’re going for a different approach.

### One Shot!

Disable the symbolic breakpoint you’ve created.

Logically speaking, the left navigation bar label that indicates how many times the user did load posts is updated after the posts are successfully retrieved via the HTTP GET request. Navigate to the section with the pragma mark `Networking`. Place a breakpoint inside the success completion handler of `loadPosts`. It should be **below**:

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

This will assure that the symbolic breakpoint will get triggered only after the table view has been reloaded and all of its equivalent labels have been updated.

**Don’t** check the “Automatically continue after evaluating actions” box. Add the following debugger command action:

```
breakpoint set --one-shot true -name '-[UILabel setText:]'
```

🤨🧐🤔

Let’s break that command:

1. breakpoint set --one-shot true does create a “one-shot” breakpoint. A one-shot breakpoint is a type of breakpoint that only exists till it’s triggered then it gets automatically deleted.

2. `-name ‘- [UILabel setText:]’` does set a symbolic name to the created one-shot breakpoint. It’s quite similar to the one you created in the last section.

Let me recap this part. Here’s what you did:

1. Adding a breakpoint (A) in the success completion handler of the function that executes the posts GET request.

2. Adding a debugger command action to ****create**** a symbolic breakpoint (B) similar to the one you created the last section. Its symbol is the `UILabel` `setText` function.

3. Setting the symbolic breakpoint (B) you created to be a one-shot breakpoint. It’s guaranteed that the symbolic breakpoint will pause the debugger only once since a one-shot breakpoint gets deleted automatically after it has been triggered.

4. Breakpoint (A) is located after reloading the table view so that the created symbolic breakpoint (B) doesn’t pause the debugger for any of the labels related to the table view.

Now pull down the table view to refresh. Here’s what you’ll get:

![Objective-C](https://cdn-images-1.medium.com/max/2332/1*JLBQAj7srx3twyCnScnVSg.png)

![Swift](https://cdn-images-1.medium.com/max/2044/1*2gcJPkL-VZ3HIebwOsqMZA.png)

The debugger did pause at the breakpoint (A) and hence setting the one-shot symbolic breakpoint.

Continue the program execution.

You’re back to the assembly code of the UIKitCore framework.

![](https://cdn-images-1.medium.com/max/5676/1*qxcTdnmPUempljXsANz62Q.png)

Let’s inspect the Objective-C message of the symbolic breakpoint arguments.

In the lldb console, type the following:

```
po $arg1
```

![](https://cdn-images-1.medium.com/max/3712/1*U7on9rNp2KTxH0vBu_5pwg.png)

WELL WELL WELL, looks like you finally found your treasure !! 🥇🏆🎉

Time to shift our sights to the stack trace. **Step to point 1.**

![Objective-C](https://cdn-images-1.medium.com/max/4728/1*kx3XCFR0kcnpD5XC1tqtng.png)

![Swift](https://cdn-images-1.medium.com/max/3788/1*42LvhyQXygvMOF0dWphR2g.png)

It led you to the piece of code that is updating the `pageNumberLabel` text. It’s quite obvious that the text is always set to a string with a format of integer value `0` rather than the `pageNumber` property. Let’s test it before we make actual changes to our code.

You’re an expert now 🧢

Add a breakpoint in a separate line below the marked line of code. Add the following debugger command action:

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

Remove/Disable breakpoint(A), accordingly, this will disable breakpoint(B)

Now pull to refresh and scroll to load more posts. The left navigation bar label is being updated. 🎉

Mission Accomplished !! 💪 💪

You can now stop the compiler and add the fixes we discussed in your code.

### Summary

In this tutorial, you’ve learned

1. How to use breakpoints alongside debugger action expression statements to manipulate existing values/properties.

2. How to use breakpoints alongside debugger action expression statements to inject lines of code.

3. How to set watchpoints to certain properties to monitor their values when being updated.

4. How to use symbolic breakpoints to pause the debugger based on defined symbols.

5. How to use one-shot breakpoints.

6. How to use one-shot breakpoints alongside symbolic breakpoint.

Happy Debugging!! 😊

### Third-party tools

I’ve used the following third-party tools for the convenience of this tutorial

* [typicode](https://github.com/typicode)/[json-server](https://github.com/typicode/json-server)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
