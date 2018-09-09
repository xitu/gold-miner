> * 原文地址：[Crafting beautiful UX with API requests](https://uxdesign.cc/crafting-beautiful-ux-with-api-requests-56e7dcc2f58e)
> * 原文作者：[Ryan Baker](https://uxdesign.cc/@ryan.da.baker?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-beautiful-ux-with-api-requests.md](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-beautiful-ux-with-api-requests.md)
> * 译者：
> * 校对者：

# Crafting beautiful UX with API requests

## When building web apps, creating a beautiful and responsive experience comes first.

Trying to control experience beyond the bounds of the web app is often left as an afterthought. Engineers forget to handle all the things that can go haywire in requesting data from APIs. In this article, I’m going to arm you with three patterns (complete with code snippets) to make your app resilient in the face of unpredictability.

![](https://cdn-images-1.medium.com/max/1000/1*lEMi48f7LTbhCpaFKQVM6A.jpeg)

Make your users as happy as this silly man

### Pattern 1: Timeouts

The timeout is a simple pattern. Boiled down, it says: “Cancel my request if you’re slower to respond than I want”.

#### When to use

You should use timeouts to set an _upper bound_ on the length of time you want the request to take. What could happen to make your API take longer than expected to respond? It depends on your API, but here are a couple examples of realistic scenarios:

Your server talks to a database. The database goes down, but the server has a connection timeout of 30 seconds. The server will take all 30 seconds to decide that it can’t talk to the database. This translates to your users waiting for 30 seconds!

You use an AWS load balancer, and the server behind it is down (for whatever reason). You left the load balancer timeout at [the default of 60 seconds](https://aws.amazon.com/blogs/aws/elb-idle-timeout-control/) and it tries to connect to the server for that long before failing.

#### When not to use

You shouldn’t use timeouts if your API has known variability in response times. A good example of this might be an API that returns report data. Asking for a day’s worth of data is quick (maybe sub-second response time), but asking for eight months takes about 12 seconds.

**Don’t use timeouts if you can’t establish a reliable upper bound for how long the request should take.**

#### How to use

Imagine you have a method in your app that does this:

![](https://cdn-images-1.medium.com/max/800/1*VrWx5PPIf84n8PKfaxCi8g.png)

example method that may live inside a React component

And you know that your API will respond in under 3 seconds 99.99% of the time. Assuming you use [Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) to fetch data from your API, you can do this:

![](https://cdn-images-1.medium.com/max/800/1*n4ONmQQn8dwfd674LIPfLw.png)

Wrapping your API call with a timeout

_note: most of the libraries you might use to make API calls have a timeout configuration. Please use your tool’s built-in features instead of writing your own_

### Pattern 2: Minimum wait time

A minimum wait time is also a simple pattern. It does the opposite of the timeout: it protects your app from _fast_ API responses.

#### When to use

A min wait is a great pattern to use if you want to show a loading state to the user, but the API might respond quickly. Users will end up seeing loading states and data “pop” into view before they can focus on anything.

This is not a good experience. If you display a loading state, you’re telling the user “take a beat, we’re doing something, and we’ll be right back”. It lets the user take a breath, maybe check their phone — the user _expects to wait_ if she sees a loading state. If you take that away too quickly, it’s jarring. You’ve interrupted her break, made her tense.

#### **When not to use**

It’s good to avoid a min wait pattern when you have an API that consistently responds very quickly. **Don’t** add a loading state just to add one, and **don’t** make the user wait if they don’t need to.

#### How to use

Using the example above, you can write code that says “don’t do anything until both of these things finish” like this:

![](https://cdn-images-1.medium.com/max/800/1*-eXymmc8GfkuGTG4XrBMfw.png)

forcing a minimum wait time on a request

### Pattern 3: Retry

The retry pattern is the most complicated one I’ll cover. The basic idea is that we want to retry sending a request a couple times if we get a bad response. It’s a pretty simple idea, but there are a few caveats to keep in mind when using it.

#### When to use

You want to use this when you make a request to an API that could have intermittent failures. Pretty much, we want to retry when we know that _every now and again_ our request will fail for things beyond our control.

In my case, I use this a lot when I know I’m making a request that uses a specific database. When that database is accessed, sometimes it just fails. Yes, this is bad. Yes, this is a problem that we should fix. As application developers, we might not have the capacity to fix an underlying infrastructure problem and are told “deal with it for now”. This is when you want to retry.

#### When not to use

If we have a reliable and consistently responsive API, we don’t need to retry. We don’t want to retry when retrying won’t get us a successful response after a failed response.

Most APIs are consistent. Here’s why you need to be careful with this pattern:

#### How to use

We want to make sure that when we make the request, we’re not hammering the server. Imagine that the server is actually down due to heavy load. Retrying will make a dead server buried six feet under. For this reason, we want what’s called a **backoff strategy** when making subsequent requests. We don’t want to shoot off 5 requests one immediately after the other just in case the server is actually down. We should stagger them to reduce load on the API server.

Most of the time, we use an **exponential backoff** to determine how long we should wait until we send the next request. We usually only want to retry 3 times, so here’s an example of the wait times you would get with different functions:

![](https://cdn-images-1.medium.com/max/600/1*SrIVlW-y7ihWboBqzM6O9A.png)

We immediately send the first request. It failed. Next we need to determine how long to wait using our backoff strategy before sending the first retry. Let’s take a look at these plots with X equal to the number of retries we’ve already sent.

With our quadratic (y = x²) and linear (y = x) functions, we get 0 for the first amount of time to wait, i.e. we should send the next request immediately.

So that eliminates those two functions from the running.

Using our exponential (y = 2^x) and constant (y = 1) functions we get a wait time of 1 second.

Our constant function doesn’t afford us any flexibility in the number of retries we already sent changing the amount of time we should wait.

This leaves just our exponential function. Let’s write a function that tells us how many seconds to wait based on how many retries we’ve already sent:

![](https://cdn-images-1.medium.com/max/800/1*3D0xaSIUBz-M5-h1ccbZuA.png)

Our simple y = 2^x function

Before we write our retry function, we want a way to determine if a request was bad. Let’s say the request was bad if it has a status code greater than or equal to 500. Here’s a function we can write for that:

![](https://cdn-images-1.medium.com/max/800/1*y2ir3VPSLIbr1aWi_WcERg.png)

Our function throws a custom error if it gets a bad response

Keep in mind that you might have different criteria to determine if a request failed. Finally, we can write our retry function with our exponential backoff strategy:

![](https://cdn-images-1.medium.com/max/1000/1*kcvzvrQ58jm8GaCRmAKYvA.png)

Our retry with an exponential backoff strategy

You’ll notice that I created a function that I didn’t export (_retryWithBackoff). The calling code can’t explicitly pass in the iteration when using our retry function.

### In Conclusion

There are lots of great defensive patterns that provide a good user experience. These are three that you can use today! If you’re interested in learning more I’d recommend [_Release It!_](https://www.amazon.com/Release-Design-Deploy-Production-Ready-Software/dp/1680502395/ref=pd_lpo_sbs_14_t_0?_encoding=UTF8&psc=1&refRID=BNBXXWPWRX7DEQ4CWMKB) A book that goes over these exact problems in building scalable software.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
