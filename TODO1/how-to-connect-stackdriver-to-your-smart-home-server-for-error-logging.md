> * 原文地址：[How to connect Stackdriver to your smart home server for error logging](https://medium.com/google-developers/how-to-connect-stackdriver-to-your-smart-home-server-for-error-logging-8a7a477241c2)
> * 原文作者：[Nick Felker](https://medium.com/@fleker?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-connect-stackdriver-to-your-smart-home-server-for-error-logging.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-connect-stackdriver-to-your-smart-home-server-for-error-logging.md)
> * 译者：[Starriers](https://github.com/Starriers)

# 如何将 Stackdriver 连接到智能家居服务器以进行错误记录

当[你的智能家居设备与 Google Assistant 集成](http://developers.google.com/smarthome)时，你可能会遇到以下错误：“无法更新设置，请检查你的连接。”

![](https://cdn-images-1.medium.com/max/800/1*r2idup5FQDZmC42mzmgI8Q.png)

**Google Assistant 设置中报告的常见错误**

这个错误可能源于账号连接和 SYNC 同步过程的许多原因。

为了更好地了解这些错误，你可以使用 [Stackdriver](https://cloud.google.com/stackdriver/)，Google Cloud 的日志系统。当账户连接或随后的 SYNC 事件发生错误时，它会自动记录错误并向你提供信息。

![](https://cdn-images-1.medium.com/max/1000/0*IJ00VIZ-VbVAVCDo)

**可能来自堆栈驱动程序的错误报告消息的屏幕截图**

你收到的日志会自动清除并移除任何个人可识别信息（PII），而且不会包含详细的追踪。

启动时，你可以导航到项目的 Google Cloud 控制台，在抽屉导航的 **Stackdriver** 部分中选择 **Logging** 选项：

![](https://cdn-images-1.medium.com/max/800/0*NmViOR5WTQg1EaMA)

你可以通过 **Google Assistant Action > All version_id** 来查看专门为你的智能家居实现而出现的错误：

![](https://cdn-images-1.medium.com/max/800/0*3V2nv9H5ixwHnHZZ)

尽管很方便，但必须转到单独的页面去查看错误可能不适合你的开发流，而且它可能不会为你提供易于访问的数据，例如，包含在每周统计报表中的数据。让我们看看如何将你的日志从 Stackdriver 导出到你的基础设施中，让你在这些数据之上构建额外的集成。

使用 Stackdriver，你可以设置包含带有特定过滤器的日志接收装置。这个接收装置中的日志可以通过 Cloud 发布/订阅发送到你拥有的端点。

### 域名验证

在将消息推送到端点之前，你需要验证你自己的域名。你可以通过 Google Cloud 控制台的 [**APIs & Services**](https://console.cloud.google.com/apis/credentials) 部分进行注册。

![](https://cdn-images-1.medium.com/max/800/1*NnaTFrEa1aLKMHkUzcCwKw.png)

在 **Credentials > Domain Verification** 下，添加一个域名。在添加完你自己的域名之后，你将被带到 Google 搜索控制。在继续操作之前，按照说明完成对你完整的验证：

![](https://cdn-images-1.medium.com/max/800/0*xSL__AZHX5S-B5I2)

### 配置发布/订阅

使用[Google Cloud 发布/订阅](https://cloud.google.com/pubsub/)，你可以静任务配置为在某些事件上运行，例如，当新日志出现在 Stackdriver 中时，通过添加过滤器你可以限制触发事件的日志类型。你也可以配置服务器端点来订阅这些事件。

要开始导出 SYNC 错误，请输入过滤器 “text:SYNC”，点击 **CREATE EXPORT** 按钮。在这里，你可以创建一个连接到 Google Cloud 发布/订阅的主题接收器。这将是你能够在每次出现日志条目时处理事件：

![](https://cdn-images-1.medium.com/max/800/0*7BR2AOyLdL5T3nav)

在抽屉导航中，打开发布/订阅概述，创建一个新的订阅：

![](https://cdn-images-1.medium.com/max/800/0*_LSoY1bG3eenfsRN)

这里，你可以新建一个订阅。对于交付类型，输入用于接收订阅的的 URL。为了进行验证域名验证，你必须拥有自己的服务器：

![](https://cdn-images-1.medium.com/max/800/0*h30i-CpLpUr6LnXR)

在你的服务器上，为了接受端点，你需要添加一个处理器。在这个示例中，它是 **/alerts/stackdriver**。这是你服务器上的一个钩子。Cloud 发布/订阅会向 URL 发送一个在请求体重包含日志数据的 POST 请求。下面的代码片段显示了使用 Node.js 的实现：

```
app.post('/alerts/stackdriver', (req, res) => {
  console.log('post stackdriver called', req.body);
  res.status(204).send('success');
  if (!!req.body.message && !!req.body.message.data) {
    const data = Buffer.from(req.body.message.data, 'base64')
      .toString('utf8');
    console.log('data: ', data);
    // optionally use regexp here to find request id and failure reason
  }
});
```

我们现在可以测试这个发布/订阅主题是否有效。在你的智能家居集成中，设置你的 SYNC 回复返回一个无效的设备类型，例如 **LART**。以下代码片段是这个响应示例：

```
const app = smarthome();
app.onSync(body => {
  return {
    requestId: body.requestId,
    payload: {
      agentUserId: '123',
      devices: [{
        type: 'action.devices.types.LART' 
        // More metadata
      }]
    }
  }
})
```

当你尝试连接你的账户时，你会在 Google Assistant 设置中看到一个错误，然后在 StackDriver 中看到与之对应的错误：

![](https://cdn-images-1.medium.com/max/800/0*uQkduKOXIjQj58lH)

![](https://cdn-images-1.medium.com/max/800/0*aIv-TNfo2xn2A5G9)

在你的服务器中，你也会看到此错误正在被记录。当你遇到此错误时，你可以查看已发送的 SYNC，并确定该错误来自设备类型的错误。你可以通过修复返回此设备信息的字符串来修复 webhook 中的错误。你可以在以下代码片段中看到更正的内容：

```
const app = smarthome();
  app.onSync(body => {
    return {
      requestId: body.requestId,
      payload: {
        agentUserId: '123',
        devices: [{
          type: 'action.devices.types.LIGHT'
          // More metadata
        }]
      }
   }
})
```

一旦你开始获取这些错误，你可以做许多事情来提高你的智能家居集成的可靠性，例如添加电子邮件警告或创建常见问题的仪表盘。通过及时发现这些问题并获取正在发生的事件的详细信息，你可以更快、更有信心地进行更正。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
