> * 原文地址：[Which Should You Use: Asynchronous Programming or Multi-Threading?](https://medium.com/better-programming/which-should-you-use-asynchronous-programming-or-multi-threading-7435ec9adc8e)
> * 原文作者：[Patrick Collins](https://medium.com/@patrick.collins_58673)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/which-should-you-use-asynchronous-programming-or-multi-threading.md](https://github.com/xitu/gold-miner/blob/master/article/2020/which-should-you-use-asynchronous-programming-or-multi-threading.md)
> * 译者：
> * 校对者：

# Which Should You Use: Asynchronous Programming or Multi-Threading?

![Image source: Author](https://cdn-images-1.medium.com/max/4608/1*G-JcOwcbJfFe70evn2FoNA.png)

When it comes to software engineering, there is often a little confusion about these two concepts. They are both forms of [concurrency,](https://en.wikipedia.org/wiki/Concurrency_(computer_science)) but they do not mean the same thing and are not applied the same way, or used in the same scenarios.

The simple explanation is that t[hreading is about workers; asynchrony is about tasks](https://stackoverflow.com/questions/34680985/what-is-the-difference-between-asynchronous-programming-and-multithreading). But let’s explore that a bit.

Analogously, let’s say we want to cook a breakfast of eggs and toast. How would we do it?

## Synchronous Approach

The simplest way would be to do it in sequence:

1. Get out the eggs, bread, and pan, and turn on the stove.
2. Crack eggs and pour them into the pan.
3. Wait for eggs to finish cooking.
4. Take eggs off and add seasoning.
5. Place bread into the toaster.
6. Wait for the toaster to complete.
7. Take out toast.

Total time for breakfast: 15 minutes.

Simple enough right? If we say the cooking of the eggs in this fashion is analogous to executing a program, we’d say that this was a [synchronous way](https://stackoverflow.com/questions/748175/asynchronous-vs-synchronous-execution-what-does-it-really-mean) to cook the eggs.

We have one person doing all the tasks, in a series ([serialism](https://en.wikipedia.org/wiki/Serialism)). We are doing each step in order, and we can’t move on to the next step without completion of the last. A more technical definition is that each task is blocked from execution from the previous step, and it’s all being done by one worker. We can’t move forward without doing the last step. In this example, we are our computer’s [central processing unit](https://en.wikipedia.org/wiki/Central_processing_unit), or CPU. Every task completed is done by one person (one CPU).

![Single-threaded synchronous way to cook breakfast](https://cdn-images-1.medium.com/max/4608/1*tqb0_sHBGF4TlSWPDY7j7w.png)

Ok cool, we’ve cooked eggs. But what if we wanted to make our morning even faster? You may be saying to yourself, “I don’t wait for my eggs to finish to put the toast in.”

You’re thinking like an engineer now. Let’s try this again, but this time, we decide we want to cook the eggs and the toast at the same time, and silently thank the inventor of the toast-timer.

## Asynchronous Approach

We can still have one person doing everything, but we can work on a separate task while we wait for another task to complete. Here’s what that looks like:

1. Get out the eggs, bread, and pan, and turn on the stove.
2. Crack eggs and pour them into the pan.
3. Wait for eggs to finish cooking.
4. Place bread into the toaster.
5. Wait for the toaster to complete.
6. **Once eggs are complete**, take eggs off, and add seasoning.
7. **Once toast is complete**, take out toast.

Total time for breakfast: eight minutes.

It looks like all the same steps, right? Except for one major upgrade. Instead of finishing the eggs and moving on to the toast, we put the toast in while we’re waiting for the eggs to finish. We still have only one worker doing all the tasks, but they are doing this asynchronously now. Now it doesn’t seem like much with only two tasks to make asynchronous, you can imagine how having thousands of eggs and toast and thousands of frying pans and toasters would make doing each one at a time ridiculous!

This is one of the biggest advantages of [asynchronous](https://en.wikipedia.org/wiki/Asynchrony_(computer_programming)) engineering. Often we have to wait for an action to complete that is out of our control. In this case, it’s waiting for the eggs and toast to cook. We can have the most efficient and best cook on the planet, but for the most part, those eggs just have to sit and wait to finish. Waiting for these to cook is analogous to [input/output (I/O)](https://en.wikipedia.org/wiki/Input/output), and when we are building something with a lot of waiting on I/O, it’s a great time to use asynchronous programming.

If we make an API call, have to get input from a user, or something of the like, no matter how many processors we have or how fast our computer is, we have to wait. We have to wait for the API call to complete, wait for the user to input information. It’s out of our control and not something that becoming faster or dedicating resources to will have any impact on.

![Single-threaded asynchronous way to cook breakfast](https://cdn-images-1.medium.com/max/4608/1*WXtQa9WJYl96TjkCB2Fu9w.png)

Great! Now we have two approaches to making eggs. But let’s say our roommate Kevin wants to help out making eggs. What would this look like?

## Multi-Threading Approach

1. Get out the eggs, bread, and pan, and turn on the stove.
2. Crack eggs and pour them into the pan. **1. Kevin puts bread into the toaster.**
3. Wait for eggs to finish cooking. **2. Kevin waits for toast to finish.**
4. Take eggs off and add seasoning. **3. Kevin takes out toast.**

Total time for breakfast: eight minutes.

We have two people making breakfast, each assigned to one sequence of tasks. This is an example of synchronous [multi-threading](https://en.wikipedia.org/wiki/Multithreading_(computer_architecture)) since neither you nor Kevin is performing more than one task at a time (including waiting).

In computer science, a process can have one or multiple threads. In this case, we have two threads (people). You can learn more about what a thread is [here](https://www.computerhope.com/jargon/t/thread.htm).

You might say, “Well, I can only cook breakfast with two people if there are two people around.” It’s the same with computers. You can only multi-thread if your computer has the resources to do so. Multi-threading is often used when there are tasks that are more computationally complex, require more resources, or for a number of other reasons.

![Multi-threaded synchronous way to cook breakfast](https://cdn-images-1.medium.com/max/4608/1*qQOr-cdzcg2S3bqQLMjcvg.png)

[So which one is better](https://www.quora.com/What-is-the-difference-between-asynchronous-programming-and-multi-threading), multi-threading or asynchronous? That really depends on a lot of factors, but if you understand how they work, that should give you some insight on which one to use. [Does it have a lot of I/O? Maybe try async. Is it computationally intensive? Maybe try multi-thread.](https://stackify.com/when-to-use-asynchronous-programming/) It can be much easier to write a multithreaded application than an asynchronous one, language depending, but that’s something to keep in mind. Can you build a [multi-threaded asynchronous system](https://codewala.net/2015/07/29/concurrency-vs-multi-threading-vs-asynchronous-programming-explained/)? Of course! Just as often, these two are used in tandem with each other.

## Python Example

Let’s look at how the three examples above (single-threaded synchronous, single-threaded asynchronous, and multi-threaded synchronous) would work in a Python example.

Let’s look at a few different ways to get stock data from the [Alpha Vantage](https://www.alphavantage.co/) API, using the Python wrapper `pip install alpha_vantage`

#### Synchronous

We want to get the current price of four tickers, 'AAPL', ‘GOOG’, ‘TSLA', ‘MSFT' , and print them out only when we have all four. The simplest way to do this is with a `for` loop.

```Python
from alpha_vantage.timeseries import TimeSeries
key = 'API_KEY'
symbols = ['AAPL', 'GOOG', 'TSLA', 'MSFT']
results = []
for symbol in symbols:
    ts = TimeSeries(key = key)
    results.append(ts.get_quote_endpoint(symbol))
print(results)
```

This is the most brute-force way. Once we get a value from our API call (done in `ts.get_quote_endpoint(symbol)` ) we print it out and then start the next symbol.

But after learning about async and multi-threading, we know we can start another API call while we wait for a value to be returned.

#### Asynchronous

```Python
import asyncio
from alpha_vantage.async_support.timeseries import TimeSeries
symbols = ['AAPL', 'GOOG', 'TSLA', 'MSFT']
async def get_data(symbol):
    ts = TimeSeries()
    data, _ = await ts.get_quote_endpoint(symbol)
    await ts.close()
    return data
loop = asyncio.get_event_loop()
tasks = [get_data(symbol) for symbol in symbols]
group1 = asyncio.gather(*tasks)
results = loop.run_until_complete(group1)
print(results)
```

In Python, we have the keywords `await` and `async` that give us the new power of asynchronous programming. These are new as of Python 3.5, so you’ll need to update if you’re still on Python 2. A lot of Python 2 is being depreciated anyway, so please update.

It may be a little confusing as to what is happening here, so let’s break it down. The `loop` is where the processor will keep looping between waiting tasks and doing other tasks. This is to keep checking to see if a task (an API call, in our case) is done.

The `tasks` variable is a list of method calls. We put those tasks in a gathered list for asyncio, called `group1` and then run them in `loop.run_until_complete`. This is much faster than our original synchronous version since we can make multiple API calls without waiting for each one to finish.

NOTE: Asyncio is odd in Python notebooks, s[ee here for more information](https://stackoverflow.com/questions/47518874/how-do-i-run-python-asyncio-code-in-a-jupyter-notebook).

#### Multi-threading

I have already written a little bit more intensely about some multithreading, so if you’d like to learn more and see some examples in Python, [check out this link](https://medium.com/alpha-vantage/data-is-taking-to-long-to-get-back-d48e3bf8f59b) to learn more!

---

There are a few more layers to learn about, like what parallelism is, deeper interaction of each application, how to sync threads, channels, and how each language handles them differently.

Think I missed something? Don’t understand something? Leave a question, comment, or insight below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
