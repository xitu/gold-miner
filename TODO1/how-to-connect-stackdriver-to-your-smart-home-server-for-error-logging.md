> * 原文地址：[How to connect Stackdriver to your smart home server for error logging](https://medium.com/google-developers/how-to-connect-stackdriver-to-your-smart-home-server-for-error-logging-8a7a477241c2)
> * 原文作者：[Nick Felker](https://medium.com/@fleker?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-connect-stackdriver-to-your-smart-home-server-for-error-logging.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-connect-stackdriver-to-your-smart-home-server-for-error-logging.md)
> * 译者：
> * 校对者：

# How to connect Stackdriver to your smart home server for error logging

When [integrating your smart home devices with the Google Assistant](http://developers.google.com/smarthome), you may have run into this error: “Couldn’t update the setting. Check your connection.”

![](https://cdn-images-1.medium.com/max/800/1*r2idup5FQDZmC42mzmgI8Q.png)

_A common error message reported in the Google Assistant settings_

This error can stem from a number of reasons during the account linking and SYNC process.

To get better insight into these errors, you can use [Stackdriver](https://cloud.google.com/stackdriver/), Google Cloud’s logging system. When an error happens during account linking or the subsequent SYNC events, it is automatically logged and provides you with information.

![](https://cdn-images-1.medium.com/max/1000/0*IJ00VIZ-VbVAVCDo)

_Screenshot of error messages that may come from Stackdriver_

The logs you receive are automatically cleaned to remove any Personally Identifiable Information (PII) and will not include a detailed trace.

To get started, you can navigate to the Google Cloud Console for your project and select the **Logging** option in the **Stackdriver** section of the navigation drawer:

![](https://cdn-images-1.medium.com/max/800/0*NmViOR5WTQg1EaMA)

You can filter by **Google Assistant Action > All version_id** to see errors specifically for your smart home fulfillment:

![](https://cdn-images-1.medium.com/max/800/0*3V2nv9H5ixwHnHZZ)

While this is handy, having to go to a separate page to view errors may not fit with your development workflow, and it may not present you with easily accessible data to include in a weekly stats report, for example. Let’s see how to export your logs from Stackdriver and into your infrastructure, letting you build additional integrations on top of this data.

Using StackDriver, you can set up a sink that will contain logs with a particular filter. The logs in this sink can be sent through Cloud Pub/Sub to an endpoint that you own.

### Domain verification

Before you can push messages to an endpoint, you will need to verify that you own the domain. You can register it through the [**APIs & Services**](https://console.cloud.google.com/apis/credentials) section in the Google Cloud Console.

![](https://cdn-images-1.medium.com/max/800/1*NnaTFrEa1aLKMHkUzcCwKw.png)

Under **Credentials > Domain Verification**, add a domain. After adding your domain, you will be taken to the Google Search console. Follow the instructions there to finish verifying your website before proceeding:

![](https://cdn-images-1.medium.com/max/800/0*xSL__AZHX5S-B5I2)

### Configure Pub/Sub

With [Google Cloud Pub/Sub](https://cloud.google.com/pubsub/), you can configure tasks to be run on certain events such as when a new log appears in Stackdriver. By adding a filter, you can limit the types of logs that will trigger an event. You can configure a server endpoint to subscribe to these events.

To start exporting your SYNC errors, type in the filter “text:SYNC” and click the **CREATE EXPORT** button. Here, you can create a sink which connects to a Google Cloud Pub/Sub topic. This will enable you to handle an event each time a new log entry appears:

![](https://cdn-images-1.medium.com/max/800/0*7BR2AOyLdL5T3nav)

In the navigation drawer, open up the Pub/Sub overview and create a new subscription:

![](https://cdn-images-1.medium.com/max/800/0*_LSoY1bG3eenfsRN)

Here, you can create a new subscription. For the Delivery Type, enter the URL that you want to use to receive subscriptions. This has to be to a server that you own for purposes of domain verification:

![](https://cdn-images-1.medium.com/max/800/0*h30i-CpLpUr6LnXR)

On your server, you will need to add a handler for your receiving endpoint. In this example, it is _/alerts/stackdriver_. This is a webhook on your server. Cloud Pub/Sub will send a POST request to that URL with the log data in the request body. An implementation using Node.js is shown in the code snippet below:

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

Now we can test to see if this pub/sub topic works. In your smart home integration, set your SYNC response to return an invalid device type, such as _LART_. An example of this response can be seen in the code snippet below:

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

When you try to link your account, you will see an error in the Google Assistant settings and a corresponding error in StackDriver:

![](https://cdn-images-1.medium.com/max/800/0*uQkduKOXIjQj58lH)

![](https://cdn-images-1.medium.com/max/800/0*aIv-TNfo2xn2A5G9)

In your server, you will also see this error being logged. When you encounter this error, you can look at the SYNC response that you have sent and identify that the error has come from a typo in your device type. You can fix this error in your webhook by fixing the string where you return this device information. You can see the corrected code snippet below:

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

Once you start ingesting these errors, there are many things that you can do to improve the reliability of your smart home integration, such as adding email alerts or creating a dashboard of common issues. By identifying these problems early and getting detailed information about what is happening, you will be able to make changes faster and with greater confidence.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
