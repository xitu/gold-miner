> * 原文地址：[Express.js and AWS Lambda — a serverless love story](https://medium.freecodecamp.org/express-js-and-aws-lambda-a-serverless-love-story-7c77ba0eaa35)
> * 原文作者：[Slobodan Stojanović](https://medium.freecodecamp.org/@slobodan?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/express-js-and-aws-lambda-a-serverless-love-story.md](https://github.com/xitu/gold-miner/blob/master/TODO/express-js-and-aws-lambda-a-serverless-love-story.md)
> * 译者：
> * 校对者：

# Express.js and AWS Lambda — a serverless love story

If you are a Node.js developer or you’ve built an API with Node.js, there’s a big chance you used [Express.js](https://expressjs.com). Express is _de facto_ the most popular Node.js framework.

Express apps are easy to build. For a simple app, you just need to add a few routes and route handlers. That’s it.

![](https://cdn-images-1.medium.com/max/800/1*FOKLXN58KdHMIXnq9XmMbQ.jpeg)

A simple, traditionally hosted Express.js app, with a single request.

For example, the simplest Express app looks like the following code snippet:

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

If you save that code snippet as _app.js_ in a new folder, you are just three steps away from having a simple Express app:

1.  Create a new Node.js project. To do so, run the `npm init -y` command in your terminal. Just make sure you navigated to the folder that contains `app.js` first.
2.  Install the Express module from NPM by running the `npm install express --save` command from terminal.
3.  Run the `node app.js` command, and you should see “Server is listening on port 3000.” as a response.

Voila! You have an Express app. Visit http://localhost:3000 in your browser, and you’ll see a “Hello world!” message.

### Application deployment

Now comes the hard part: How can you show it to your friends or family? How to make it available for everyone?

Deployment can be long and painful process, but let’s imagine you manage to do it quickly and successfully. Your app is available to everyone and it lived happily ever after.

Until one day, an unexpected an army of users started using it.

Your server struggled, but it worked.

![](https://cdn-images-1.medium.com/max/800/1*oRxOi15ZwmxllRruaUrajg.jpeg)

A simple, traditionally hosted Express.js app under load.

At least for some time. And then it died. ☠️

![](https://cdn-images-1.medium.com/max/800/1*rLrZQImeF1JAAemPMsT4CA.jpeg)

A simple, but dead, traditionally hosted Express.js, that crashed because too many users accessed it.

An army of users is angry (at least they didn’t pay for the app — or did they?) You are desperate and trying to Google the solution. Can the cloud help?

![](https://cdn-images-1.medium.com/max/800/1*zzz5m1-ZSKeYQwtshfx_6A.jpeg)

Cloud should fix your scaling issues, right?

And you’ve met one of your annoying friends again. She’s talking about that serverless thingy again. But come on, you still have a server. It just belongs to somebody else and you have no control over it.

![](https://cdn-images-1.medium.com/max/800/1*hkjYPGxG2q_r_-bUk1qSWw.jpeg)

But, there are servers!

But you are desperate, you would try anything, including black magic and even serverless. “What the heck is that serverless thingy, anyway?”

You ended up with many links, including the one to the [free first chapter](https://livebook.manning.com/?utm_source=twitter&utm_medium=social&utm_campaign=book_serverlessappswithnodeandclaudiajs&utm_content=medium#!/book/serverless-apps-with-node-and-claudiajs/chapter-1/) of “Serverless Apps with Node and Claudia.js” by Manning Publications.

That chapter explains serverless with washing machines!? Sounds crazy, but it kinda makes sense. 💩 already hit the fan, so you decide to try it.

### Making your Express.js app serverless

That chapter was all about serverless on AWS. And now you know that Serverless API consists of an API Gateway and AWS Lambda functions. But how can you go serverless with your Express app?

This sounds as promising as that movie about Matt Damon shrinking…

![](https://cdn-images-1.medium.com/max/800/1*Yo4lpTU11g0vYE4vn3kA-w.jpeg)

How do you fit your Express.js app into AWS Lambda?

[Claudia](https://claudiajs.com) could help you to deploy your app to AWS Lambda — lets ask her for help!

Make sure you configured your AWS access credentials as explained in [this tutorial](https://claudiajs.com/tutorials/installing.html) before running Claudia commands.

Your code should be slightly modified to suppor AWS Lambda and deployment via Claudia. You need to export your `app` instead of starting the server using `app.listen`. Your `app.js` should look like the following code listing:

```
'use strict'

const express = require('express')
const app = express()

app.get('/', (req, res) => res.send('Hello world!'))

module.exports = app
```

That would break a local Express server, but you can add `app.local.js` file with the following content:

```
'use strict'

const app = require('./app')

const port = process.env.PORT || 3000
app.listen(port, () => 
  console.log(`Server is listening on port ${port}.`)
)
```

And then run the local server using the following command:

```
node app.local.js
```

To make your app work correctly with AWS Lambda, you need to generate AWS Lambda wrapper for your Express app. With Claudia, you can do so by running the following command in your terminal:

```
claudia generate-serverless-express-proxy --express-module app
```

where `app` is a name of an entry file of your Express app, just without the `.js` extension.

This step generated a file named `lambda.js`, with the following content:

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

That’s it! Now you only need to deploy your Express app (with `lambda.js` file) to AWS Lambda and API Gateway using the `claudia create` command.

```
claudia create --handler lambda.handler --deploy-proxy-api --region eu-central-1
```

After a few moments, the command finished and printed the following response:

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

And if you visit the link from that response in your browser, it prints “Hello world!” It worked! 🙀

![](https://cdn-images-1.medium.com/max/800/1*vEl8mct7Hz-HWJ6_N9Gyqw.png)

Serverless Express app.

With a serverless app, your army of users can continue growing and your app will still be working.

It is possible, because AWS Lambda will auto scale up to 1000 concurrent executions by default. New functions are ready a few moments after the API Gateway receives the request.

![](https://cdn-images-1.medium.com/max/800/1*F8bP1pP4Pc-eTKj0wLNzhA.jpeg)

Serverless Express.js app under heavy load.

But this is not your only benefit. You also saved money besides having a stable app under a higher load. With AWS Lambda, you pay only for requests you used. Also, the first million requests each month are free, as part of a free tier.

![](https://cdn-images-1.medium.com/max/800/1*_SyXSIVxi0a5UKA5nQCBOQ.jpeg)

Your serverless app also saves your money!

To read more about the ways your business benefits through serverless, see [this](https://hackernoon.com/7-ways-your-business-will-benefit-through-serverless-522b3f628a33) article.

### Limitations of serverless Express.js apps

Serverless Express apps sound awesome, but they have some limitations.

![](https://cdn-images-1.medium.com/max/800/1*PglAqQmPs9k3ovYiwD2BBQ.jpeg)

Serverless, the limited edition.

Some of the important limitations of serverless Express apps are the following:

*   _Websockets_ don’t work with AWS Lambda. That’s because your server doesn’t exist when there are no requests. Some limited support for websockets is available through [AWS IOT websockets over MQTT protocol](https://docs.aws.amazon.com/iot/latest/developerguide/protocols.html#mqtt).
*   _Upload_ to the file system will not work either, unless you are uploading to the `/tmp` folder. That’s because the AWS Lambda function is read-only. Even if you upload files to `/tmp` folder, they will exist for a short time, while the function is still “warm”. To make sure your upload feature is working fine, you should upload files to AWS S3.
*   _Execution limits_ can also affect your serverless Express app. Because API Gateway has a timeout of 30 seconds, and AWS Lambda’s maximum execution time is 5 minutes.

This is just a beginning of a serverless love story between your apps and AWS Lambda. Expect more stories soon!

_As always, many thanks to my friends_ [_Aleksandar Simović_](https://twitter.com/simalexan) _and_ [_Milovan Jovičić_](https://twitter.com/violinar) _for help and feeback on the article._

> All illustrations are created using [SimpleDiagrams4](https://www.simplediagrams.com) app.

If you want to learn more about serverless Express and serverless apps in general, check out “Serverless Apps with Node and Claudia.js”, the book I wrote with [Aleksandar Simovic](https://medium.com/@simalexan) for Manning Publications:

- [**Serverless Apps with Node and Claudia.js**: First the buzzwords: Serverless computing. AWS Lambda. API Gateway. Node.js. Microservices. Cloud-hosted functions…www.manning.com](https://www.manning.com/books/serverless-apps-with-node-and-claudiajs)

The book will teach you more about serverless Express apps, but you’ll also learn how to build and debug a real world serverless API (with DB and authentication) using Node and Claudia.js. And how to build chatbots, for Facebook Messenger and SMS (using Twilio), and Alexa skills.

Thanks to [Aleksandar Simovic](https://medium.com/@simalexan?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
