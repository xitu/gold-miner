> * 原文地址：[Xcode and LLDB Advanced Debugging Tutorial: Part 2](https://medium.com/@fadiderias/xcode-and-lldb-advanced-debugging-tutorial-part-2-8bfeae4cdfdb)
> * 原文作者：[Fady Derias](https://medium.com/@fadiderias)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md)
> * 译者：
> * 校对者：

# Xcode and LLDB Advanced Debugging Tutorial: Part 2

In the first part of this three parts tutorial, we’ve covered how to utilize Xcode breakpoints to manipulate an existing property value and inject a new line of code via expression statements.

I developed a demo project with several intentional bugs to elaborate on how to use different types of breakpoints alongside the LLDB to fix bugs in your project/application.

If you didn’t go through [**part 1**](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md) of this tutorial, it’s crucial to check it before proceeding with this part.

Let me remind you of the golden rule of this tutorial:
You’re not to stop the compiler or re-run the application after running it for the very first time. You’re fixing the bugs at runtime.

## Watchpoints 👀

Let’s march to our next enemy.

> 3. The user is allowed to load posts **more** undefinedthan 7 times.

Here are the steps to reproduce this one:

✦ Turn your iPhone’s/Simulator’s internet connection on.

✦ Scroll to the bottom of the table view to load more posts.

✦ Scrolling/loading more posts is valid for more than 7 times. (Bear in mind that for the current application, the user is only allowed to load posts for 7 times only)

One approach to consider this bug is to figure out how the `pageNumber` integer property is being updated since it’s passed to the networking manager to retrieve new posts objects for a specific page. In a code base that you’re still unaware of, it would take you some time and effort to figure out where exactly this is happening.

Worry not! Let’s do some magic 🎩

From part 1 of this tutorial, you learned that the GET HTTP request is executed in the section with the pragma mark `Networking`. It only includes one function which is `loadPosts`. Place a breakpoint on the first line of this function and pull down to refresh to reload new posts objects. This will trigger the breakpoint you’ve just added.

![Objective-C](https://cdn-images-1.medium.com/max/4052/1*yCeuuv8HfObRgYewJLwhyA.png)

![Swift](https://cdn-images-1.medium.com/max/3256/1*czpn47AuKgaGvyIv5ImIIQ.png)

In the bottom debugger window, tap on the “Show variables view button”. This will slide a new view that includes all of the properties for **PostsTableViewController**.

![](https://cdn-images-1.medium.com/max/4464/1*PbTSXBMHhfXOKxfe_Tec8Q.png)

Head to the `pageNumber` property, right-click, and select “Watch _pageNumber” / “Watch pageNumber”.

![Objective-C](https://cdn-images-1.medium.com/max/3280/1*rrJVnhAGpu-pxhNt7CFIBg.png)

![Swift](https://cdn-images-1.medium.com/max/3056/1*bayE0ZKUW5wwccGdtc7gQQ.png)

That resulted in creating what is so-called a “Watchpoint” to the `pageNumber` property. A watchpoint is a type of breakpoint that pauses the debugger the next time the value of the property it’s set to get changed.

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*CSbAyFyweJdaU3lfnXebnw.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*qJXkvHWpGmHI7DquZW5zZA.png)

Continue the program execution. The debugger will pause and you’ll see something like this:

### Objective-C

![](https://cdn-images-1.medium.com/max/5680/1*PEH5x-D85rp9qYo9MtwiJw.png)

1. Logs of the old and new values of the `pageNumber` property.

2. The stack trace of the code that resulted in the change of the `pageNumber` property.

3. The current point that is causing the actual change of the `pageNumber` property. That is the setter method of the property.

If you fall back to point 1 in the stack trace, it will lead you to the following piece of code:

![](https://cdn-images-1.medium.com/max/2000/1*6rOdWkY4TxqbzLZfTCZJeg.png)

### Swift

![](https://cdn-images-1.medium.com/max/5672/1*1AGmy4ThuDgFizPn_2mFSA.png)

1. Debugger console informing you that the watchpoint you did set got hit.

2. The stack trace of the code that resulted in the change of the `pageNumber` property.

3. The current point that is causing the actual change of the `pageNumber` property. That is the `updateForNetworkCallEnd` function.

It’s obvious to conclude that for every time the HTTP GET request succeeds, the `pageNumber` property will increment by 1 as long as the `state` enum property is active. The `state` enum property can be one of two values either “active” or “inactive”. An active state refers that the user is able to load more posts (i.e didn’t reach the load limit [7]). The inactive state is the mere opposite to that. In conclusion, we need to implement some logic inside the `updateForNetworkCallEnd` that checks on the `pageNumber` property and sets the `state` enum property accordingly.

As you’ve learned, it’s quite better to test the hypothesis first and then make actual changes to your code without stopping the compiler.

You’ve guessed it right 😉

It’s important to note that there’s an already implemented function under the section with the pragma mark `Support` that does set the `state` enum property to inactive. That is `setToInactiveState`.

Add a breakpoint one line above the if condition. Add a debugger command action. Add the following debugger command.

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

After doing that, you need to deactivate the very first breakpoint you did utilize to set the watchpoint. Disable the watchpoint as well.

![Objective-C](https://cdn-images-1.medium.com/max/4140/1*u9im1mihdCdGDJSoAJfAzg.png)

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*-fCWpD7jlLFw8LjxX92JXg.png)

![Swift](https://cdn-images-1.medium.com/max/3336/1*5a1UhRJ5tXFZKJrdjOv2Ow.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*S0ttr15900z7q-6znr19yA.png)

Now get back to the top of the table view, pull down to refresh, and then start scrolling down.

**Don’t party yet, we still have one more bug to kill** 😄⚔️

## Where to go?

Check out the [**third and final part**](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-3.md) of this tutorial to fix the last bug and learn about a new type of breakpoints that is symbolic breakpoints.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
