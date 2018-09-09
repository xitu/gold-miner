> * 原文地址：[Using Workers To Make Static Sites Dynamic](https://blog.cloudflare.com/using-workers-to-make-static-sites-dynamic/)
> * 原文作者：[Guest Author](https://blog.cloudflare.com/author/guest-author/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-workers-to-make-static-sites-dynamic.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-workers-to-make-static-sites-dynamic.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：

# 用 Workers 让静态网站动态化

**以下是 Gambling.com 集团首席开发人员 [Paddy Sherry](https://www.linkedin.com/in/paddy-sherry-a7420a47/) 的客座文章。他们使用 Cloudflare 为全球受众提供服务，构建绩效营销网站和工具。Paddy 是一位网站性能狂热爱好者，且对无服务器计算很感兴趣。**

> 选择在大型站点网络上使用的技术是必须正确的关键架构决策。我们构建静态网站，但需要找到一种方法让它们动态地执行地理定位、访问限制和 A/B 测试等操作。这篇文章分享了我们在使用 Workers 解决这些挑战时学到的经验。

### 我们的背景

在 [Gambling.com 集团](https://www.gambling.com/corporate)，我们在所有网站上都使用 Cloudflare，因此我们对 Workers 的好奇心水平高于大多数人。我们是静态网站的忠实粉丝，因为没有什么比纯 HTML 更快。我们一直在寻找这样的技术并应用于部分测试计划，因此是最先获得该功能的人之一。

我们如此热衷于试验 Workers 的原因是，对于任何运行静态站点的人来说，99％ 的时间都可以满足产品要求，但总有一次需要进行一些计算而不是发回静态响应。

直到最近，最合适的选择是添加一些在页面加载后触发的 JavaScript，并改变 UI 或从端点获取数据。这样做的缺点是用户在加载后会看到页面移位，即使脚本是异步加载的。闪烁的页面可能令人愤怒，没有什么比尝试点击链接但打开了别的东西更令人恼火，因为 DOM 在中途改变了。

一个常见的解决方法是隐藏页面内容，直到所有 JavaScript 都已处理完毕，但这会让你停留在一个缓慢加载的脚本，而且用户在浏览器完成下载之前会看到一个空白页。即使所有脚本都迅速下载，也会有网速较慢或远离数据中心的用户可以响应他们的请求。

**输入 Cloudflare Workers**。开发人员可以处理这些请求，并在它们到达服务器之前动态响应。没有延迟加载计算，Workers 在后台响应非常快，过渡基本不可见。

### 我们的 Workers 用例

自使用 Workers 以来，我们一直在尝试各种方法，在不改变我们为网站网络提供的所有智能技术的前提下使我们的静态网站更加动态化。

#### 地理定位

我们以多种语言在全球运营静态网站，并使用 Cloudflare 为其提供服务。用户通过谷歌搜索或点击互联网上其他地方的链接到达网站。通常，他们登陆的网站可能和兴趣不完全匹配，因为他们点击的链接并未指向最佳位置。例如，加拿大的用户登陆英国网站，看到英镑而不是加拿大元的价格，或者意大利的一个人登陆美国网站看到的是英文内容而不是意大利文。

静态网站的难题在于页面加载速度异常快，一旦到达站点，我们就无法根据用户的偏好定制体验了。

有了 Workers，我们可以通过读取边缘的请求报头来解决这个问题。Cloudflare 检测传入请求的原始 IP，并将两个字母的国家代码附加到名为 **“Cf-Ipcountry”**  的报头中。我们可以编写一个简单的 worker 来读取此报头，检查国家代码，然后重定向到相应的站点版本（如果存在的话）。

```
addEventListener('fetch', event => {
 event.respondWith(fetchAndApply(event.request))
})

async function fetchAndApply(request) {

   const country = request.headers.get('Cf-Ipcountry').toLowerCase() 
   let url = new URL(request.url)

   const target_url = 'https://' + url.hostname + '/' + country
   const target_url_response = await fetch(target_url)

   if(target_url_response.status === 200) {
       return new Response('', {
         status: 302,
         headers: {
           'Location': target_url
         }
       })     
   } else {
       return response
   }
}
```

用户现在正在获取该网站的本地化版本，这能更好地为他们的兴趣服务，并且跳出率更低，因为内容是根据他们的位置定制的。

### 限制对内容的访问

对于大多数网站，有时页面需要在线但不向公众开放。例如，代理商在最终获准之前向客户展示的新登陆页。

在某些情况下，公司可能需要多层安全措施来保护其知识产权并避免在准备就绪之前让用户看到某些内容，但对于大多数情况而言，只需要隐藏信息并不需要军事级别的安全性。

使用内容管理系统，这很容易做到，但静态站点很难实现。使用 Workers，我们能够拼凑一个简单的解决方案阻止访问页面，除非请求中存在某个也可以用于查找参数的报头。

```
addEventListener('fetch', event => {
  event.respondWith(fetchAndApply(event.request))
})

async function fetchAndApply(request) {  
  var ua = request.headers.get('user-agent');
    let url = new URL(request.url);

    if (ua.indexOf('MY-TEST-STRING')) {
        return fetch(request)
    } else {
        return new Response('Access Denied',
            { status: 403, statusText: 'Forbidden' })
    }
}
```

现在可以向公众隐藏页面，而无需对安全性或身份验证技术进行大量投入，但对于需要进行这些限制的人来说仍然很容易访问。

#### A/B 测试

优化流量的重要工具需要从 A/B 测试中领悟。虽然不缺乏功能强大的 A/B 测试工具，但大多数都需要添加一个在页面加载后改变 UI 的 JavaScript。在最佳条件下，这可能是肉眼无法察觉的，但并非所有用户都具有最佳的网速，并且有些用户在页面加载后会经历闪烁。如上所述，这是一种带有负面后果的糟糕经历。

我们能够通过调用 A/B 测试脚本 URL 的 Worker 来解决这个问题，在将更改后的响应发送给用户之前获取代码并重新绘制 UI。结果是用户在页面加载时看到变体，并且在第一个像素渲染后不会有任何移动。

### 为什么 Workers 为我们消除了障碍

Workers 允许我们让静态网站变得动态化。当然，我们可以通过延迟加载 JavaScript 完成此操作，但用户的体验会很差。

第二种选择是迁移到服务器渲染的站点，但即使有这样的架构转换，也很难在全球拥有足够的服务器来为所有位置的用户提供相同的体验。进行这样的改变也是一项重大的 IT 投资。

另一方面，Workers 可以插入到我们的架构顶部，无需安装或添加。这是一个单击 Cloudflare 仪表板中的按钮并立即访问 Worker 乐园的问题。在探究任何新技术或供应商时所造成的臭名昭著的时间浪费并没有发生在商定试验或建立开发环境时。

### 为什么我们选择 AWS Lambda 上的 Workers

值得注意的是，Workers 不是无服务器计算的唯一选择，因为这是行业普遍的发展方向。虽然 AWS Lambda 是一个强有力的竞争者，但我们选择了 Workers，因为 Lambda 需要与更多 AWS 服务集成才能启动，而最近的性能测试表明 Workers [比 Lambda 更快](https://blog.cloudflare.com/serverless-performance-comparison-workers-lambda/)。

![](https://blog.cloudflare.com/content/images/2018/08/Screen-Shot-2018-08-15-at-12.15.55-PM-1-1.png)

虽然我们可能因为不同需求选择了 AWS，但 Workers 仍然更容易启动，且运行迅速。

### 我们希望看到的改进

尽管我们获得了压倒性的批准，但我们还是希望看到一些额外的东西。

除非你有企业计划，否则账户当前可以访问单个 Worker 脚本。这意味着许多不相关的代码存放在一个文件中，虽然这本身并不罕见，但是 Worker 只能触发单个 URL 模式。如果想要只在一些页面上触发功能，这可能会有限制，并且意味着你的 Worker 代码中会有一系列 if 语句，用于确定何时触发它。这不是不可行的，但也不是理想的场景。

随着 Worker Recipe 交换的增长，以及 Cloudflare 继续构建出更多内容，我们期待文档随着更多真实世界的示例而增长。

### 结论

我们刚刚开始与 Cloudflare Workers 合作。随着团队知识的增长，我们可以在适当的时候使用它来满足我们的产品要求，并且在没有延迟加载 JavaScript 的情况下执行以前不可能的更高级的事情。Workers 仍处于起步阶段，还可以做出改进。我们将密切关注这些并尝试在新功能发布时找到使用它们的方法。

本指南是一个高级概述。有关更深入的解释和代码片段，请查看 [Cloudflare Workers 的这篇评论](https://leaderinternet.com/blog/cloudflare-workers-review)，其中详细解释了一些示例。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
