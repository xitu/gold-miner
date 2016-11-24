> * 原文地址：[Webhooks do’s and dont’s: what we learned after integrating +100 APIs](https://restful.io/webhooks-dos-and-dont-s-what-we-learned-after-integrating-100-apis-d567405a3671)
* 原文作者：[Giuliano Iacobelli](Giuliano Iacobelli)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Webhooks do’s and dont’s: what we learned after integrating +100 APIs


As modern applications are becoming more and more a composite of APIs and the serverless architectures are getting more attention, API providers can’t afford any longer to expose only traditional REST endpoints.

Traditional REST API are designed for when you want to allow a programmatical retrieve or post content, far from being optimal when you just want your application to be told when something changed. If that is the case, it would require polling at regular intervals, and that just doesn’t scale.



![](https://cdn-images-1.medium.com/max/800/1*dEmrcTajSG5A4Z_JjrGqfw.png)

Picture credits [Lorna Mitchell](https://medium.com/u/e6dd3fdb7c2d)



Polling an API is generally a wasteful and messy way of trying to retrieve that piece of information. Some events may only happen once in a while, so you have to figure out how often to make the polling calls, and you might miss it.

> Don’t call us, we’ll call you!

Well webhooks are the answer. **A webhook is a way for web service to provide other services with near real-time information using HTTP POST requests.**



![](https://cdn-images-1.medium.com/max/800/1*8t-MNjY-6rJ79rsDnZt0rA.png)

Picture credits [Lorna Mitchell](https://medium.com/u/e6dd3fdb7c2d)



A webhook delivers data to other applications as it happens, meaning you get data immediately. This makes webhooks much more efficient for both the provider and the consumer, if your API doesn’t support them you should really do something about it (you hear me [Salesforce](https://medium.com/u/f4fb2a348280)?).

When it comes to designing webhooks there is nothing really close to a standard in the HTTP API literacy. Every service implements webhook differently leading to many different flavors of webhooks implementations out there.

After integrating APIs from more than 100 different services I can tell that the way a service exposes webhooks can be a deal breaker. So here are the things that make us happy when we need to integrate with a service exposing webhooks.

#### Self explanatory and consistent

A good webhook service should provide as much information as possible about the event that is being notified, as well as additional information for the client to act upon that event.

The POST request should contain a `timestamp` and `webhook_id` if one was given by the client when creating it. A `type` attribute should be included if you're providing different types of webhooks whether or not they are being sent to a single endpoint.



![](https://cdn-images-1.medium.com/max/600/1*Yi85OX2kNJw-bbn8O0VVQQ.png)

Sample of Github’s webhook payload



[GitHub](https://medium.com/u/d18563e4f2b9) does that perfectly. Please don’t send just an ID that has to be resolved with another API request like Instagram or Eventbrite do.

If you think your payload is too heavy to be sent all at once give me the chance to make it lighter.

[Stripe](https://medium.com/u/3ecae35d6d66)’s [event types](https://stripe.com/docs/api) are a good example of this done well.

#### Allow consumers to define multiple URLs

When you build your webhooks you should think about the people on the other end of the wire that have to receive your data. Giving them the chance to subscribe to events under one single URL is not the best developer experience that you can offer. If I need to listen for the same event across different systems I’m going to end up in troubles and I need to put in between some Reflector.io type of thing. [Clearbit](https://medium.com/u/ce5450a7b906) please you have such good APIs, step up your webhook game accordingly.

[Intercom](https://medium.com/u/7ca8972daf76) does this very well giving you the chance to add multiple URLs and define for each one of them the events that you want to listen for.



![](https://cdn-images-1.medium.com/max/800/1*lGfFqT7G4x3swfm1qkxjfA.png)

Webhook management panel on Intercom



#### UI based subscription vs API based subscription

Once the integration is in place how should we handle the creation of an actual subscription? Some services opted for a UI that guides you through the setup of a subscription some others built an API for that.



![](https://cdn-images-1.medium.com/max/600/1*lQ5VTo4IF50IjaimPq-F4Q.png)



[Slack](https://medium.com/u/26d90a99f605) killed it by supporting both.

It provides a slick UI that makes creating subscription very easy and exposing a solid Event API (which still doesn’t support as much events as their Real Time Messaging API does but I’m sure their working on it).

An important thing to keep in mind when choosing whether or not providing an API for your webhooks is at what scale and granularity your subscriptions are going be available and who is going to configure them.

I find it curious that a tool like [MailChimp](https://medium.com/u/772bf2413f17) forces a non technical audience to mess with webhooks configurations. By making webhooks available via API, any third-service (e.g. Stamplay, Zapier or IFTTT) that has a Mailchimp integration could just make that happen programmatically and build better user experiences.



![](https://cdn-images-1.medium.com/max/600/1*EEMaCdPa63smJ3oOSpQ60w.png)



For creating new webhooks subscriptions via API, you should treat the _subscription_ like any other resource in an HTTP API.

A very good one we’ve been working with recently is the completely renewed webhook implementation made by the Box team which was released [this summer](https://blog.box.com/blog/box-webhooks/).

#### Securing webhooks

Once someone configured his service to receive payloads from your webhook, it’ll listen for any payload sent to the endpoint.

If consumer’s application exposes sensitive data, it can (optionally) verify that requests are generated by your service and not a third-party pretending to be you. This isn’t required, but offers an additional layer of verification.

There are a bunch of ways to go about this — if you want to put the burden on the consumer side, you could opt to give him a whitelist requests from IP address — but a far easier method is to set up a secret token and validate the information.

This can be done at different degrees of complexity starting from a plain text shared secret like Slack or Facebook do



![](https://cdn-images-1.medium.com/max/800/1*qyzDKFf4CfPwJEozGIah0w.png)



To more complex implementations. As an example Mandrill signs webhook requests including an additional HTTP header with webhook POST requests, `X-Mandrill-Signature`, which will contain the signature for the request. To verify a webhook request, generate a signature using the same key that Mandrill uses and compare that to the value of the `X-Mandrill-Signature` header.

#### Subscriptions with expiration date

The odds to face an integration of a service that exposes subscriptions with an expiration date is not very high today but we can see this becoming a more common feature. Microsoft Graph API is an example. Any subscription you perform over API expires 72hours later unless you renew it.

From a data provider standpoint it makes sense. You do not want to keep sending out POST requests to services that could be no longer up and running or interested in your data but for all those who are actually interested it’s an unpleasant surprise. You’re Microsoft: if you can’t afford the heavy lifting who is supposed to do it?

#### Conclusions

The webhook landspace is still fragmented but common patterns are eventually coming up tough.

At [**Stamplay**](https://stamplay.com/) API integration is a thing. We face the integration challenges on a daily basis and OpenAPI specifications like Swagger, RAML or API Blueprint can’t help because none of them supports webhook scenarios.

So if you’re thinking about implementing webhooks I invite you to think about their consumption and look at examples like [GitHub](https://medium.com/u/d18563e4f2b9), [Stripe](https://medium.com/u/3ecae35d6d66), [Intercom](https://medium.com/u/7ca8972daf76) and [Slack API](https://medium.com/u/272cd95a3742).

PS. [Medium](https://medium.com/u/504c7870fdb6) any plans for webhooks? Come on, RSS feeds are so old school.

**Update**: Medium actually does provide a way to get realtime notifications through [http://medium.superfeedr.com/](http://medium.superfeedr.com/) 👌

