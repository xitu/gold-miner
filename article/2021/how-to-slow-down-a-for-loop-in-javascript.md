> * 原文地址：[How To Slow Down A For-Loop in JavaScript](https://medium.com/javascript-in-plain-english/javascript-slow-down-for-loop-9d1caaeeeeed)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-slow-down-a-for-loop-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-slow-down-a-for-loop-in-javascript.md)
> * 译者：
> * 校对者：

# How To Slow Down A For-Loop in JavaScript

![Photo by [Charlotte Coneybeer](https://unsplash.com/@she_sees?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*kcAWzuiAUolF3Zkr)

For loops are indispensable. They help us to program sequences. But there is one problem with them — the for loop runs through as fast as possible. If we iterate through an array, this is, of course, desirable.

But if we do, e.g., requests in the loop, this can lead to problems. It would be nice if each loop's execution takes a fixed time interval — for example, one pass per second.

I will show you how to do this — here is how to time a for-loop.

## First — how it does not work

If you’re looking for a direct solution to your problem, feel free to skip this part. If you want to learn something about JS, then stay for a moment. 
I want to explain why common solutions don’t work.

Thanks to setTimeout,d we can specify that a certain code should be executed only after x-time. This sounds like the solution to our problem. Just put the timeout in the for-loop, and the loop is less fast:

When we run the code with **setTimeout**, the following happens: 
nothing happens for 1 second; then all the logs come up in a flash. 
Not really what we had hoped for.

The reason for this is a small error in thinking. It seems like the timeout doesn’t apply to every element — yes, it does.

But we forget how JavaScript executes code. The loop creates all timeouts immediately, not sequentially. Of course, this is very fast — so all timeouts have almost the same **start time**. 
As soon as the time is up, the logs are made — all at once.

We see the same effect when we rewrite the code minimally.

From the idea, this would work in some other programming languages. 
The loop starts to create the timeout. Only when it has been executed does it continue — at least in other programming languages. In JavaScript, however, the timeout is created, and the code continues to execute immediately. 
So JavaScript creates two flows that run parallel.

## How to slow down the for-loop properly

So with a **setTimeout,** it does not work as it should. 
The rescue is a simple promise.

We call the Promise via a function. It gets the time in milliseconds that the **setTimeout** should receive. All the timeout does after the time expires is to execute the resolve function. This means the promise is fulfilled — it can continue. We can simplify the code shown above:

The Promise is ready. Now we can add it to our for-loop:

The log is executed once per second. So to output all numbers of the loop, we need 100 seconds. So we have successfully slowed down our for-loop.

Thank you for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
