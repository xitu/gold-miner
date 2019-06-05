> * 原文地址：[Xcode and LLDB Advanced Debugging Tutorial: Part 1](https://medium.com/@fadiderias/xcode-and-lldb-advanced-debugging-tutorial-part-1-31919aa149e0)
> * 原文作者：[Fady Derias](https://medium.com/@fadiderias)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md)
> * 译者：
> * 校对者：

# Xcode and LLDB Advanced Debugging Tutorial: Part 1

One of the very intriguing sessions carried out by some of Apple’s finest debugging engineers during 2018’s WWDC was [Advanced Debugging with Xcode and LLDB](https://developer.apple.com/videos/play/wwdc2018/412/). They informed us about some impressive tips and tricks on how to utilize Xcode’s breakpoints and low-level debugger (LLDB) to optimize the debugging process whenever it happens that developers encounter bugs and all out to fix them.

In this 3 parts tutorial, I’ll walk you through most of what has been concluded in that WWDC session. I created a demo project specifically to elaborate on how to use different types of breakpoints alongside the LLDB to fix bugs in your project/application.

## Demo Project

I developed a project of conventional tasks that most of the iOS developers out there have definitely dealt with at some point. It’s important to learn about its features/rules before proceeding with this article. Here’s what the demo project is all about:

1. A table view controller that loads a list of posts when opened for the first time.
2. The table view controller supports loading more posts when reaching the bottom end of the table view.
3. The number of times the user is allowed to load posts is **restricted to 7**.
4. The user is able to reload new posts via a refresh controller (pull down to refresh).
5. There are two labels on the navigation bar that do indicate how many posts have been retrieved (right label) and how many times have the user loaded posts (left label).

You can download it from [here](https://github.com/FadyDerias/IBGPosts) if you’re an Objective-C player.
Swift player? Download it from [here](https://github.com/FadyDerias/IBGPostsSwift). 
Xcode and run it! 😉

## Bugs to Fix!

Now that you’re ready with your project, you might have noticed the following bugs:

1. Pull down to refresh does not reload new posts.
2. The user is not receiving an alert (via an alert controller) whenever the HTTP request fails due to connection problems.
3. The user is allowed to load posts **more** than 7 times.
4. The left navigation bar label that indicates how many times the user did load posts is not being updated.

**Golden Rule:** For the rest of this article, you’re not to stop the compiler or re-run the application after running it for the very first time. You’re fixing the bugs at runtime.

## The Power of Expression

Let’s tackle the first bug.

> 1. Pull down to refresh does not reload new posts.

Here are the steps to reproduce it:

✦ Run the application → the first 10 posts are loaded.
✦ Scroll down to load more posts.
✦ Scroll up to the top of the table view, and pull down to refresh.
✦ New posts are **not** reloaded and the old posts still exist & the posts count is not reset.

A typical approach to fix this bug is to investigate what happens inside the selector method that is assigned to the dedicated UIRefreshControl of the table view controller. Head to `**PostsTableViewController**` and navigate to the section with the pragma mark `Refresh control support`. We can deduce from the`setupRefreshControl` function that the selector dedicated for the refresh control is the `reloadNewPosts` function. Let’s add a breakpoint at the first line of this function and debug exactly what’s going on in there. Now scroll to the top of the table view and pull down to refresh it.

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*t3vOwPZMfYXA33XraHBReQ.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*5o64at1-25xhG8x7MOQCcQ.png)

The debugger has paused at the breakpoint you did set once you have released the refresh control. Now to further explore what happens next, tap on the debugger step over button.

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*NnCfWSc4ALsmVW4MtVDmsQ.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*O9EsnTPL8Bc7eRaDnggkNQ.png)

Now we have a clear idea what wrong is going on !!

The if statement condition is not satisfied (i.e the`isPullDownToRefreshEnabled` boolean property is set to `NO`) and hence the equivalent code for reloading the posts is not executed.

The typical approach to fix this is to stop the compiler, set the `isPullDownToRefreshEnabled` property to `YES`/`true` and that would do it. But it’s more convenient to test such a hypothesis before implementing some actual changes to the code and without the need to stop the compiler. Here come the breakpoint debugger command actions of expression statements really handy.

Double tap on the set breakpoint, or right click, edit breakpoint and tap on the “Add Action” button. Select “Debugger Command” action.

![](https://cdn-images-1.medium.com/max/2000/1*5Q7AfSRWER__yCY-ygHrxA.png)

Now what we want to do is set the `isPullDownToRefreshEnabled` property to `YES`/`true`. Add the following debugger command.

**Objective-C**

```
expression self.isPullDownToRefreshEnabled = YES
```

![](https://cdn-images-1.medium.com/max/2012/1*lAJyDbhVTYjwfBzKszTDig.png)

**Swift**

```
expression self.isPullDownToRefreshEnabled = true
```

![](https://cdn-images-1.medium.com/max/2476/1*xY2IFUHIJQkqBSddN5hmog.png)

The next thing you should do is checking the “Automatically continue after evaluating actions” box. This will cause the debugger **not** to pause at the breakpoint for each and every-time it gets triggered and automatically continue after evaluating the expression you just added.

Now scroll to the top of the table view and pull down to refresh.

**voilà** new ****posts have been retrieved, replacing the old ones, and hence the posts count got updated.

As you’ve just resolved the first bug, pick up your anti-bugs weapons and proceed to the second one.

> 2. The user is not receiving an alert (via an alert controller) whenever the HTTP request fails due to connection problems.

Here are the steps to reproduce this one:

✦ Turn off your iPhone’s/Simulator’s internet connection.
✦ Scroll to the top of the table view, and pull down to refresh.
✦ No new posts are loaded due to network error.
✦ A network error alert controller is not presented to the user.

Head to **PostsTableViewController** and navigate to the section with the pragma mark `Networking`. It only includes one function which is `loadPosts`. It utilizes a shared instance of a networking manager to execute a GET HTTP request that returns an array of posts object via a “success” completion handler or an instance of `NSError` via a “failure” completion handler.

What we want to do is to add some code inside the failure completion handler to present a networking error alert controller. If you navigated to the section with the pragma mark `Support`, you’ll find that there’s an already implemented function presentNetworkFailureAlertController that does handle the presentation of the required alert controller. All that we need to do is to call that function inside the `loadPosts` failure completion handler.

The conventional way is to stop the compiler, add the required line of code and you’re done. Let’s go for the unconventional!

Add a breakpoint inside the failure completion handler **below** the line

**Objective-C**

```
[self updateUIForNetworkCallEnd];
```

**Swift**

```
self.updateUIForNetworkCallEnd()
```

Double tap on the set breakpoint, tap on the “Add Action” button. Select debugger command action. Add the following debugger command

**Objective-C**

```
expression [self presentNetworkFailureAlertController]
```

![](https://cdn-images-1.medium.com/max/3048/1*Q1RqsI7GGn5Nx7MI9oaOFA.png)

**Swift**

```
expression self.presentNetworkFailureAlertController()
```

![](https://cdn-images-1.medium.com/max/2708/1*o1j-d1NS0j0DOBJlySEM6A.png)

Check the “Automatically continue after evaluating actions” box.

With your internet connection disabled, scroll to the top of the table view and pull down to refresh or you can scroll down to the bottom of the table view in an attempt to load more posts. Here’s what you get 🎉🎉

![](https://cdn-images-1.medium.com/max/2000/1*Ohh02CA-HA3rqtgmx7atPQ.png)

What you just did was **“injecting”** a line of code with an expression statement implemented as a debugger command action inside a dedicated breakpoint.

## Recap

Let me just recap what we did with breakpoints debugger command action expression statements:

1. Manipulate an existing property value.
2. Injecting a new line of code.

Both tasks were achieved at runtime. We didn’t really need to stop the compiler, modify things and then re-run the application.

## Where to go?

Check out the [**second part**](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md) of this tutorial to fix extra bugs and learn about a special type of breakpoints, that is watchpoints.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
