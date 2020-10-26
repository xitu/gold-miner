> * 原文地址：[Understanding The Web History API in JavaScript](https://medium.com/javascript-in-plain-english/understanding-the-web-history-api-in-javascript-eac987071d4d)
> * 原文作者：[Mehdi Aoussiad](https://medium.com/@mehdiouss315)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-the-web-history-api-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-the-web-history-api-in-javascript.md)
> * 译者：
> * 校对者：

# Understanding The Web History API in JavaScript

#### The JavaScript Web History API With Practical Examples

![Photo by [Kevin Ku](https://unsplash.com/@ikukevk?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9184/0*wBiqieIBMgVIDeJ_)

## What is a Web API?

**API** stands for **A**pplication **P**rogramming **I**nterface. It is some kind of interface that has a set of functions that allow programmers to access specific features or data of an application, operating system, or other services. A **Web API** is an application programming interface for the web, It could be for a web browser or a web server. We can build our own Web API using different technologies such as Java or Node and etc. There is also another type of API called Third Party API, It is not built into your browser. you will have to download the code from the Web in order to use it, such as the Youtube API or the Twitter API. So in this article, I decided to give you some knowledge about the Web History API.

![Photo by [Joshua Aragon](https://unsplash.com/@goshua13?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/5492/0*crcbHF8nQYE3cCwp)

## The Web History API

The web history API is supported by all the browsers. The **window.history** object has some useful methods on its prototype which I’m going to show you below. It contains all the websites visited by the user. Let’s open up our console to see this object. Have a look at the example below:

![The **window.history** Object in the console.](https://cdn-images-1.medium.com/max/2000/1*CF4GD-BAFVbCyyvkX96P7g.png)

As you can see, the “**window.history**” object has some useful methods on its prototype. I will show you some of them in a second.

## The History back Method

The history **back** method loads the previous **URL** in the history list. It is the same as clicking the “back arrow” in your browser. Let’s have a look at the example below:

```HTML

<button onclick="myFunction()">Go Back</button>

<script>
function myFunction() {
  window.history.back();
}
</script>
```

When we click the button it will take us to the previous link(URL) in our history list in the browser.

## The History go Method

The **go()** method allows us to load a specific URL in our browser history list. Let’s have a look at the example below:

```HTML

<button onclick="myFunction()">Go Back 2 Pages</button>

<script>
function myFunction() {
  window.history.go(-2);
}
</script>
```

So, when we click the button element, we will go 2 pages back as we specified in the above example(-2).

## The History forward Method

The **forward()** method Loads the next URL in the history list. Below this, there is an example of how to use it.

```HTML

<button onclick="myFunction()">Go Back</button>

<script>
function myFunction() {
  window.history.forward();
}
</script>
```

Clicking on the button will load the next URL in our browser history list.

## Conclusion

As you can see, The History Web API is so useful and important when it comes to traveling from a page to another on our website. Make sure that we didn’t cover everything about this web API, that’s why you will need to learn more about it from other resources. I hope you learned something new today.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
