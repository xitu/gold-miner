
> * 原文地址：[User Breakpoints in Xcode](https://pspdfkit.com/blog/2017/user-breakpoints-in-xcode/)
> * 原文作者：[Michael Ochs](https://twitter.com/_mochs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/user-breakpoints-in-xcode.md](https://github.com/xitu/gold-miner/blob/master/TODO/user-breakpoints-in-xcode.md)
> * 译者：[oOatuo](https://github.com/)
> * 校对者：[fengzhihao123](https://github.com/fengzhihao123), [LeviDing](https://github.com/leviding)

# Xcode 中的用户断点

大家应该都用过 Xcode 中的断点，但你们熟悉用户断点么？下面我将向你们介绍如何使用以及何时使用这种断点。如果你已经对用户断点有所了解了，可以查看下文章后面的清单，看看我们是如何在 PSPDFKit 中使用它们的，也许有一些新的东西可以添加到你的清单中！

## 常规断点

当创建一个常规断点时，它们会出现在 Xcode 的断点导航器中，分列在工作区或者工程下，这取决于你当前所工作的位置。你可以通过点击列表中或者它所指向的代码旁边的的断点符号来激活或禁用一个断点。

![A regular breakpoint](https://pspdfkit.com/images/blog/2017/user-breakpoints-in-xcode/regular-breakpoint@2x-a201ce1c.png)

这些断点保存在特定工作区或工程的个人设置中，仅自己可见。即使你将个人设置提交到项目中，在同一个项目中的同事也不会在他们的 Xcode 中看到你的断点。

## 分享断点

通过右击断点，选择　'Share Breakpoint'，这个断点会对项目中的所有人可见。如果项目中有你希望每次都能停止执行的代码路径，例如自定义的异常处理或其他任何不应在正常情况下执行的特定的项目代码，这是很有用的。结合断点选项和可自动执行的断点，这对于提高调试体验也很有帮助。

另一个你可以用它来做的稍微不那么有用的事：在应用程序的执行代码路径中添加一个共享的断点，比如完成一个网络请求，让它自动地连续运行，并让它在每次被击中时播放一个声音 - 是的，你可以让你的断点发出声音。提交断点，然后看着试图弄清楚声音是从哪里来而抓狂的同事！😁 不过，在远程工作的环境下，恶搞你的同事是很难的，这就是我为什么没有在 PSPDFKit 这么做。。。但可以在[我们的线下团建](https://pspdfkit.com/blog/2016/the-importance-of-retreats-for-a-remote-company/)时拿来娱乐一下。

## 用户断点

你还可以用断点来做另一件事。它是一个很强大的特性，只不过在 Xcode 中有点难找。你可以通过右击断点选择 'Move Breakpoint To > User'，使其变成用户断点。

![A regular breakpoint](https://pspdfkit.com/images/blog/2017/user-breakpoints-in-xcode/move-to-user@2x-d63238f8.png)

这会将断点从工作区或项目范围转移到一个用户范围内。这意味着断点会出现在你的机器上的所有项目中。虽然这对与特定项目相关的事情不是很有帮助，但还是有很多的断点可以被添加到用户范围的列表中。最明显的事情是 Objective-C 的异常和 Swift 的错误断点，可能每个人都会在每个项目中都添加一次相应的断点。使用用户断点的话，你只需添加它们一次，它们就会自动出现在您的所有项目中。

另一个我使用的用户断点是在应用程序启动时激活 Reveal。Reveal 是一个很好的用来调试视图相关问题的工具，我经常使用它。它需要通过一个服务来集成到你的应用中，并且服务需要自己启动，这可以通过调试器来实现，而不必添加相应的调试代码。当你把这个断点移动到用户空间下后，你就不再需要将它添加到每个项目中去。如果你的项目包含了 Reveal 的服务, 当应用程序启动时服务会自动启动。这个方法也在 Reveal 的 [接入指南](http://support.revealapp.com/kb/getting-started/load-the-reveal-server-via-an-xcode-breakpoint) 提到过。

还有一些其他的断点在每个项目中都很有帮助。请记住，你可以停用它们，只在需要的时候打开它们；我的很多断点都是默认关闭的，但如果我需要它们，它们就在那里。这是我们团队在 PSPDFKit 中最喜欢使用的断点清单：

- **Symbol:**`UIViewAlertForUnsatisfiableConstraints`

    当出现自动布局约束的问题时自动停止。这会比仅仅在Xcode的控制台输出一条打印信息更让你注意这个问题。它有助于我们及早地发现布局问题。

- **Symbol:**`NSKVODeallocateBreak`

    在 KVO 抱怨观察者仍在原地的地方中断。   

- **Symbol:**`UIApplicationMain`
*Debugger command:*`e @import UIKit`

    将 UIKit 导入到调试器中，不再需要在很多地方转换类型。你写过很多类似 `p (CGRect)[self bounds]` 的语句么？这消除了将其转换为 CGRect 的需求。

- **Symbol:**`-[UIViewController initWithNibName:bundle:]`
    *Debugger command:*`po $arg1`

     在视图控制器初始化期间打印其类型。当在大型项目中工作或者你是个新来的，你会不知道所有试图控制器的名字。如果你想知道你要修改的视图控制器的名字的话，你只需激活这个断点，然后在应用中导航到这个视图控制器，你会在调试器中看到所打印的名字。

- **Symbol:**`-[UIApplication sendAction:toTarget:fromSender:forEvent:]`

    当有事件发出时中断，例如按钮的触摸。这和上面那个很相似。激活这个断点，如果你不知道按钮被触摸时调用了哪个方法的话。`p (SEL)$arg3` 会打印出调用的选择器，`po $arg4` 会打印调用它的目标。

- **Exception Breakpoint:** Objective-C
    *Debugger command:*`po $arg1`

    当 Objective-C 断点被触发时中断，并打印相应的异常信息。

- **Exception Breakpoint:** C++

    当 C++ 异常抛出时中断。

- **Swift Error Breakpoint**

    在 Swift 错误出现时中断。

- **Symbol:**`_XCTFailureHandler`

    当单元测试产生错误时中断。如果你正在运行单元测试，并想要当错误出现时中断程序，这就是。

如果你的清单中有其他的你觉得有用的断点，[请联系我](https://twitter.com/_mochs)。如果你想了解更多关于 Xcode 断点所能做的事情以及[如何用脚本化的断点调试特定的实例](https://pspdfkit.com/blog/2016/scripted-breakpoints/)的话，可以浏览我们的博客！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
