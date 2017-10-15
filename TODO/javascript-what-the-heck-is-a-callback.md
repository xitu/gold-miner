> * 原文地址：[JavaScript: What the heck is a Callback?](https://codeburst.io/javascript-what-the-heck-is-a-callback-aba4da2deced)
> * 原文作者：[Brandon Morelli](https://codeburst.io/@bmorelli25)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[reid3290](https://github.com/reid3290)、[wilsonandusa](https://github.com/wilsonandusa)

---

# JavaScript：回调是什么鬼？

配合简单的示例，用短短 6 分钟学习和理解回调的基本知识。

![](https://cdn-images-1.medium.com/max/1000/1*pWGJIKats-zuumA3RQNEWQ.jpeg)

回调  —— 题图来自 [unsplash](https://unsplash.com/search/call?photo=qXn5L9BqRbE)

### 回调是什么？

**简单讲：** 回调是指在另一个函数执行完成**之后**被调用的函数  ——  因此得名“回调”。

**稍复杂地讲：** 在 JavaScript 中，函数也是对象。因此，函数可以传入函数作为参数，也可以被其他函数返回。这样的函数称为**高阶函数**。被作为参数传入的函数就叫做**回调函数**。


^ 这听起来有点啰唆，让我们来看一些例子来简化一下。

### 为什么我们需要回调？

有一个非常重要的原因 —— JavaScript 是事件驱动的语言。这意味着，JavaScript 不会因为要等待一个响应而停止当前运行，而是在监听其他事件时继续执行。来看一个基本的例子：

    function first(){
      console.log(1);
    }

    function second(){
      console.log(2);
    }

    first();
    second();

正如你所料，`first` 函数首先被执行，随后 `second` 被执行 —— 控制台输出下面内容：

    // 1
    // 2

一切都如此美好。

但如果函数 `first` 包含某种不能立即执行的代码会如何呢？例如我们必须发送请求然后等待响应的 API 请求？为了模拟这种状况，我们将使用 `setTimeout`，它是一个在一段时间之后调用函数的 JavaScript 函数。我们将函数延迟 500 毫秒来模拟一个 API 请求，新代码长这样：

    function first(){
    // 模拟代码延迟
      setTimeout( function(){
    console.log(1);
      }, 500 );
    }

    function second(){
      console.log(2);
    }

    first();
    second();

现在理解 `setTimeout()` 是如何工作的并不重要，重要的是你看到了我们已经把 `console.log(1);` 移动到了 500 秒延迟函数内部。那么现在调用函数会发生什么呢？

    first();
    second();

    // 2
    // 1

即使我们首先调用了 `first()` 函数，我们记录的输出结果却在 `second()` 函数之后。

这不是 JavaScript 没有按照我们想要的顺序执行函数的问题，而是 **JavaScript 在继续向下执行 `second()` 之前没有等待 `first()` 响应**的问题。

所以为什么给你看这个？因为你不能一个接一个地调用函数并希望它们按照正确的顺序执行。回调正是确保一段代码执行完毕之后再执行另一段代码的方式。

### 创建一个回调

好了，说了这么多，让我们创建一个回调！

首先，打开你的 Chrome 开发者工具（**Windows: Ctrl + Shift + J**)(**Mac: Cmd + Option + J**），在控制台输入下面的函数声明：

    function doHomework(subject) {
      alert(`Starting my ${subject} homework.`);
    }

上面，我们已经创建了 `doHomework` 函数。我们的函数携带一个变量，是我们正在研究的课题。在控制台输入下面内容调用你的函数：

    doHomework('math');

    // Alerts: Starting my math homework.

现在把我们的回调加进来，我们传入 `callback` 作为 `doHomework()` 的最后一个参数。这个回调函数是我们定义在接下来要调用的 `doHomework()` 函数的第二个参数。

    function doHomework(subject**, callback**) {
      alert(`Starting my ${subject} homework.`);
    **callback();**
    }

    doHomework('math'**, function() {
      alert('Finished my homework');
    }**);

如你所见，如果你将上面的代码输入控制台，你将依次得到两个警告：第一个是“starting homework”，接着是“finished homework”。

但是你的回调函数并不总是必须定义在函数调用里面，它们也可以定义在你代码中的其他位置，比如这样：

    function doHomework(subject, callback) {
      alert(`Starting my ${subject} homework.`);
      callback();
    }

    function alertFinished(){
      alert('Finished my homework');
    }

    **doHomework('math', alertFinished);**

这个例子的结果和之前的例子完全一致。如你所见，我们在 `doHomework()` 函数调用中传入了 `alertFinished` 函数定义作为参数！

### 实际应用案例

上周我发表了一篇关于如何[用 38 行代码构建一个 Twitter 机器人](https://hackernoon.com/build-a-simple-twitter-bot-with-node-js-in-just-38-lines-of-code-ed92db9eb078)的文章。文中的代码可以实现的唯一原因就是我使用了 [Twitters API](https://dev.twitter.com/rest/public)。当你向一个 API 发送请求，在你操作响应内容之前你必须等待这个响应。这是回调在实际应用中的绝佳案例。请求长这样：

    T.get('search/tweets', params, function(err, data, response) {
      if(!err){
        // 这里是施展魔法之处
      } else {
        console.log(err);
      }
    })

- `T.get` 仅仅意味着我们将要向 Twitter 发送一个 get 请求
- 这个请求中有三个参数：`‘search/tweets’` 是请求的路径，`params` 是搜索参数，随后的一个匿名函数是我们的回调。

回调在这里很重要，因为在我们的代码继续运行之前我们需要等待一个来自服务端的响应。我们并不知道 API 请求会成功还是会失败，所以通过 get 向 search/tweets 发送了请求参数以后，我们要等待。一旦 Twitter 响应，我们的回调函数就被调用。Twitter 要么发送一个 `err`（error）对象，要么发送一个 `response` 对象返回给我们。在我们的回调函数中我们可以使用 `if()` 语句来区分请求是否成功，然后相应地处理新数据。

### 你做到了

干得漂亮！你现在（理想状况下）已经理解了回调是什么，回调如何工作。这只是回调的冰山一角，记住学无止境啊！我每周都会更新一些文章/教程，如果你愿意接收每周一次的推送，[点击这里](https://docs.google.com/forms/d/e/1FAIpQLSeQYYmBCBfJF9MXFmRJ7hnwyXvMwyCtHC5wxVDh5Cq--VT6Fg/viewform)输入你的邮箱订阅吧！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
