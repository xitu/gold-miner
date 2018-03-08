> * 原文地址：[Express.js and AWS Lambda — a serverless love story](https://medium.freecodecamp.org/express-js-and-aws-lambda-a-serverless-love-story-7c77ba0eaa35)
> * 原文作者：[Slobodan Stojanović](https://medium.freecodecamp.org/@slobodan?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/express-js-and-aws-lambda-a-serverless-love-story.md](https://github.com/xitu/gold-miner/blob/master/TODO/express-js-and-aws-lambda-a-serverless-love-story.md)
> * 译者：[刘嘉一](https://github.com/lcx-seima)
> * 校对者：[FateZeros](https://github.com/FateZeros)，[Han Song](https://github.com/song-han)

# Express.js 与 AWS Lambda — 一场关于 serverless 的爱情故事

无论你是 Node.js 的职业开发者，亦或是使用 Node.js 开发过 API 的普通开发者，你都极有可能使用了 [Express.js](https://expressjs.com)。Express 可以称得上是 Node.js 中最流行的框架了。

构建 Express App 极为容易。你仅需添加一些路由规则和对应的处理函数，一个简单的应用就此诞生。

![](https://cdn-images-1.medium.com/max/800/1*FOKLXN58KdHMIXnq9XmMbQ.jpeg)

图注：一个使用传统托管方法的简单 Express.js App —— 响应单次请求的过程。

下列代码展示了一个最简单的 Express App：

```
'use strict'

const express = require('express')
const app = express()

app.get('/', (req, res) => res.send('Hello world!'))

const port = process.env.PORT || 3000
app.listen(port, () => 
  console.log(`Server is listening on port ${port}.`)
)
```

如果将上面的代码片段保存为 **app.js**，那么再需三步你就可以让这个简单的 Express App 运行起来。

1.  首先将终端的工作目录切换到 `app.js` 所在的文件夹，之后执行 `npm init -y` 命令以初始化一个新的 Node.js 项目。
2.  使用终端执行 `npm install express --save` 命令以从 NPM 安装 Express 模块。
3.  执行 `node app.js` 命令，终端会回显 “Server is listening on port 3000.” 字样。

瞧，这就完成了一个 Express App。若使用浏览器访问 http://localhost:3000，你便可以在打开的网页中看到 “Hello world!” 信息。

### 应用部署

麻烦的问题来了：如何才能将你构建的 Express App 展示给你的朋友或者家人？如何才能让每个人都能访问到它？

应用部署是一个耗时且痛苦的过程，但现在我们就假定你已经很快、很好地完成了部署的工作。你的应用已经能被所有人访问了，并且之后也运转良好。

就这样直到一天，突然有一大批用户涌入开始使用你的应用。

你的服务器开始变得疲惫不堪，不过仍然还能工作。

![](https://cdn-images-1.medium.com/max/800/1*oRxOi15ZwmxllRruaUrajg.jpeg)

图注：一个使用传统托管方法的简单 Express.js App —— 处于较大负载下。

就这样持续了一段时间后，它终于宕机了。☠️

![](https://cdn-images-1.medium.com/max/800/1*rLrZQImeF1JAAemPMsT4CA.jpeg)

图注：一个使用传统托管方法的简单 Express.js App —— 因为过多用户访问导致应用挂掉。

一大批用户因为应用无法访问而变得不开心（无论他们是否为此应用付费）。你对此感到绝望，并开始在 Google 上寻求解决方法。如果在云（Cloud）上部署可以改善现状吗？

![](https://cdn-images-1.medium.com/max/800/1*zzz5m1-ZSKeYQwtshfx_6A.jpeg)

图注：在云上部署应该就可以解决应用规模伸缩的问题了，对吧？

此时你遇到了之前一个恼人的朋友，她又在给你谈论 Serverless（无服务器）技术的种种。但是等等，你现在可是有一台服务器的呀。虽然这台服务器是某个服务商提供的，并且它的状态也不怎么好暂时失去了控制，但总归是能供你使用的。

![](https://cdn-images-1.medium.com/max/800/1*hkjYPGxG2q_r_-bUk1qSWw.jpeg)

图注：但是，Serverless 背后还是有一堆服务器呀！

走投无路的你愿意尝试一切方法 “挽救” 你的应用，管它是 Serverless 还是其他什么黑魔法。“不过，这个 Serverless 究竟是个什么东西呢?”

你翻阅了数个网页，包括 “Serverless Apps with Node and Claudia.js” 这本书的 [第一章试读](https://livebook.manning.com/?utm_source=twitter&utm_medium=social&utm_campaign=book_serverlessappswithnodeandclaudiajs&utm_content=medium#!/book/serverless-apps-with-node-and-claudiajs/chapter-1/)（由 Manning Publications Co. 出版）。

在这一章中，作者使用洗衣机类比说明了 Serverless 的原理，这听起来很疯狂不过解释起原理来还蛮有用。你的应用已经到了 🔥 烧眉毛的地步了，因此你决定马上试试 Serverless。

### 让你的 Express.js App Serverless 化

上面书中的一整章都是基于 AWS 的 Serverless 进行编写的。你已经知道了 Serverless API 是由 API Gateway 和 AWS Lambda function 组成的。现在需要考虑的是如何让你的 Express App Serveless 化。

就像 Matt Damon 出演的电影《缩小人生》中描绘的桥段，Serverless 在未来也具有无限的潜力和可能性。

![](https://cdn-images-1.medium.com/max/800/1*Yo4lpTU11g0vYE4vn3kA-w.jpeg)

图注：如何才能让你的 Express.js App 无缝接入 AWS Lambda？

[Claudia](https://claudiajs.com) 有能力帮助你把你的 App 部署到 AWS Lambda — 让我们向它请教一番！

在运行 Claudia 命令前，请确保你已经参照 [教程](https://claudiajs.com/tutorials/installing.html) 配置好了 AWS 的访问凭证。

为了能接入 AWS Lambda 和使用 Claudia 进行部署，你的代码需要稍微调整一下。你需要 export 你的 `app`，而不是调用 `app.listen` 去启动它。你的 `app.js` 内容应该类似下列代码：

```
'use strict'

const express = require('express')
const app = express()

app.get('/', (req, res) => res.send('Hello world!'))

module.exports = app
```

这样修改后你可能无法在本地启动 Express 服务器了，不过你可以通过额外添加 `app.local.js` 文件进行解决：

```
'use strict'

const app = require('./app')

const port = process.env.PORT || 3000
app.listen(port, () => 
  console.log(`Server is listening on port ${port}.`)
)
```

之后想启动本地服务器执行下面的命令就可以了：

```
node app.local.js
```

为了将你的应用正确接入 AWS Lambda，你还需要编写一些代码将你的 Express App ”包裹“ 一番。在 Claudia 的帮助下，你只需要在终端中执行一条命令就可以生成 AWS Lambda 需要的 ”包裹“ 代码了：

```
claudia generate-serverless-express-proxy --express-module app
```

命令结尾处的 `app` 指明了 Express App 的入口文件名，这里无需附加 `.js` 扩展名。

这一步会生成 `lambda.js` 文件，它的内容如下：

```
'use strict'
const awsServerlessExpress = require('aws-serverless-express')
const app = require('./app')
const binaryMimeTypes = [
  'application/octet-stream',
  'font/eot',
  'font/opentype',
  'font/otf',
  'image/jpeg',
  'image/png',
  'image/svg+xml'
]
const server = awsServerlessExpress
  .createServer(app, null, binaryMimeTypes)
exports.handler = (event, context) =>
  awsServerlessExpress.proxy(server, event, context
)
```

至此已经完成了所有的准备工作！接下来你只需要执行 `claudia create` 命令就可以将你的 Express App（含 `lambda.js` 文件）部署到 AWS Lambda 和 API Gateway 了。

```
claudia create --handler lambda.handler --deploy-proxy-api --region eu-central-1
```

等待上述命令执行完成后，终端会输出类似下面的响应信息：

```
{
  "lambda": {
    "role": "awesome-serverless-expressjs-app-executor",
    "name": "awesome-serverless-expressjs-app",
    "region": "eu-central-1"
  },
  "api": {
    "id": "iltfb5bke3",
    "url": "https://iltfb5bke3.execute-api.eu-central-1.amazonaws.com/latest"
  }
}
```

在浏览器中打开响应信息中返回的链接，若网页展示出 “Hello world!” 那么证明应用已经成功部署起来了！🙀

![](https://cdn-images-1.medium.com/max/800/1*vEl8mct7Hz-HWJ6_N9Gyqw.png)

图注：Serverless Express App。

将你的应用 Serverless 化后，你不再畏惧用户群体的进一步扩大，应用会始终保持为可用状态。

这并不是言过其实，因为在默认情况下 AWS Lambda 可通过弹性伸缩最高支持 1000 个 function 并发执行。当 API Gateway 接收到请求后，新的 function 会在短时间内处于可用状态。

![](https://cdn-images-1.medium.com/max/800/1*F8bP1pP4Pc-eTKj0wLNzhA.jpeg)

图注：在高负载下的 Serverless Express.js App。

这并不是你接入 Serverless 后唯一的收益。在保证应用不会因为高负载宕机的前提下，你同样削减了不少应用的运行开销。使用 AWS Lambda，你仅需按你应用的实际访问量付费。同样，AWS 的免费试用计划还将给予你每应用每月一百万的免费流量（按访问次数计算）。

![](https://cdn-images-1.medium.com/max/800/1*_SyXSIVxi0a5UKA5nQCBOQ.jpeg)

图注：你的 Serverless App 真是太替你省钱了！

想了解更多关于使用 Serverless 带来的好处，请点击查看 [这篇](https://hackernoon.com/7-ways-your-business-will-benefit-through-serverless-522b3f628a33) 文章。

### Serverless Express.js App 的短板

即便 Serverless Express App 听起来超赞，却同样有它的不足之处。

![](https://cdn-images-1.medium.com/max/800/1*PglAqQmPs9k3ovYiwD2BBQ.jpeg)

图注：Serverless，”阉割“ 版。

下面是 Serverless Express App 一些最 “致命” 的短板：

*   **Websockets** 无法在 AWS Lambda 中使用。这是因为在 AWS Lambda 中，若应用没有任何的访问，那么你的服务器在客观上也是不存在的。[AWS IOT websockets over MQTT protocol](https://docs.aws.amazon.com/iot/latest/developerguide/protocols.html#mqtt) 可以提供一个 “阉割” 版的 Websockets 支持。
*   **上传** 文件到文件系统同样是无法工作的，除非你的上传目录是 `/tmp` 文件夹。这是因为 AWS Lambda function 对文件系统是只读的，即使你将文件上传到了 `/tmp` 文件夹，它们也只会在 function 处于 “工作态” 时存在。为确保你应用中的上传功能运转正常，你应当把文件上传并保存到 AWS S3 上。
*   **执行限制** 也将影响你的 Serverless Express App 功能。例如 API Gateway 有 30 秒的超时时间限制，AWS Lambda 最大执行时间不能超过 5 分钟等。

这仅仅算是你的应用与 AWS Lambda 之间关于 Serverless 爱情故事的一个序章，期待尽快涌现更多的爱情故事！

**如往常一样，感谢来自我的朋友 [Aleksandar Simović](https://twitter.com/simalexan) 以及 [Milovan Jovičić](https://twitter.com/violinar) 的帮助和对文章的反馈意见。**

> 所有的插图均是使用 [SimpleDiagrams4](https://www.simplediagrams.com) 创作的。

如果你想了解更多关于 Serverless Express 和 Serverless App 的信息，“Serverless Apps with Node and Claudia.js” 这本书不容错过。这本书由我和 [Aleksandar Simovic](https://medium.com/@simalexan) 合作完成，Manning Publications 负责出版：

- [**Serverless Apps with Node and Claudia.js**: First the buzzwords: Serverless computing. AWS Lambda. API Gateway. Node.js. Microservices. Cloud-hosted functions…www.manning.com](https://www.manning.com/books/serverless-apps-with-node-and-claudiajs)

这本书除了会包含不少 Serverless Express App 的知识，它还将教会你如何使用 Node 和 Claudia.js 去构建、调试真实场景下的 Serverless API（含 DB 和身份校验）。随书还将讲解如何构建 Facebook Messenger 和短信（使用 Twilio）的聊天机器人，以及如何构建亚马逊的 Alexa skills。

再次向 [Aleksandar Simovic](https://medium.com/@simalexan?source=post_page) 表示衷心的感谢。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
