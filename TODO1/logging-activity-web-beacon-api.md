> * 原文地址：[Logging Activity With The Web Beacon API](https://www.smashingmagazine.com/2018/07/logging-activity-web-beacon-api/)
> * 原文作者：[Drew](https://www.smashingmagazine.com/author/drew-mclellan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/logging-activity-web-beacon-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/logging-activity-web-beacon-api.md)
> * 译者：
> * 校对者：

# Logging Activity With The Web Beacon API

The Beacon API is a lightweight and efficient way to log information from a web page back to a server. Find out how that can be used and what makes it so different from traditional Ajax techniques.

![](https://d33wubrfki0l68.cloudfront.net/a2b586e0ae8a08879457882013f0015fa9c31f7c/9e355/images/drop-caps/t.svg)

The Beacon API is a JavaScript-based Web API for sending small amounts of data from the browser to the web server without waiting for a response. In this article, we’ll look at what that can be useful for, what makes it different from familiar techniques like `XMLHTTPRequest` (‘Ajax’), and how you can get started using it.

If you know why you want to use Beacon already, feel free to jump directly to the [Getting Started](#getting-started) section.

### What Is The Beacon API For?

The Beacon API is used for sending small amounts of data to a server _without waiting for a response_. That last part is critical and is the key to why Beacon is so useful — our code never even gets to see a response, even if the server sends one. Beacons are specifically for sending data and then forgetting about it. We don’t expect a response and we don’t get a response.

Think of it like a postcard sent home when on vacation. You put a small amount of data on it (a bit of “Wish you were here” and “The weather’s been lovely”), put it in the mailbox, and you don’t expect a response. No one sends a return postcard saying “Yes, I do wish I was there actually, thank you very much!”

For modern websites and applications, there’s a number of use cases that fall very neatly into this pattern of send-and-forget.

Getting the process _just_ right ain't an easy task. That's why we've set up **'this-is-how-I-work'-sessions** — with smart cookies sharing what works really well for them. A part of the [Smashing Membership](http://smashed.by/casestudypanelmembership), of course.

#### Tracking Stats And Analytics Data

The first use case that comes to mind for most people is analytics. Big solutions like Google Analytics might give a good overview of things like page visits, but what if we wanted something more customized? We could write some JavaScript to track what’s happening in a page (maybe how a user interacts with a component, how far they’ve scrolled to, or which articles have been displayed before they follow a CTA) but we then need to send that data to the server when the user leaves the page. Beacon is perfect for this, as we’re just logging the data and don’t need a response.

There’s no reason we couldn’t also cover the sort of mundane tasks often handled by Google Analytics, reporting on the user themselves and the capability of their device and browser. If the user has a logged in session, you could even tie those stats back to a known individual. Whatever data you gather, you can send it back to the server with Beacon.

#### Debugging And Logging

Another useful application for this behavior is logging information from your JavaScript code. Imagine you have a complex interactive component on your page that works perfectly for all your tests, but occasionally fails in production. You know it’s failing, but you can’t see the error in order to begin debugging it. If you can detect a failure in the code itself, you could then gather up diagnostics and use Beacon to send it all back for logging.

In fact, any logging task can usefully be performed using Beacon, be that creating save-points in a game, collecting information on feature use, or recording results from a multivariate test. If it’s something that happens in the browser that you want the server to know about, then Beacon is likely a contender.

### Can’t We Already Do This?

I know what you’re thinking. None of this is new, is it? We’ve been able to communicate from the browser to the server using `XMLHTTPRequest` for more than a decade. More recently we also have the Fetch API which does much the same thing with a more modern promise-based interface. Given that, why do we need the Beacon API at all?

The key here is that because we don’t get a response, the browser can queue up the request and send it _without blocking execution_ of any other code. As far as the browser is concerned, it doesn’t matter if our code is still running or not, or where the script execution has got to, as there’s nothing to return it can just background the sending of the HTTP request until it’s convenient to send it.

That might mean waiting until CPU load is lower, or until the network is free, or even just sending it right away if it can. The important thing is that the browser queues the beacon and returns control immediately. It does not hold things up while the beacon sends.

To understand why this is a big deal, we need to look at how and when these sorts of requests are issued from our code. Take our example of an analytics logging script. Our code may be timing how long the users spend on a page, so it becomes critical that the data is sent back to the server at the last possible moment. When the user goes to leave a page, we want to stop timing and send the data back home.

Typically, you’d use either the `unload` or `beforeunload` event to execute the logging. These are fired when the user does something like following a link on the page to navigate away. The trouble here is that code running on one of the `unload` events can block execution and delay the unloading of the page. If unloading of the page is delayed, then the loading next page is also delayed, and so the experience feels really sluggish.

Keep in mind how slow HTTP requests can be. If you’re thinking about performance, typically one of the main factors you try to cut down on is extra HTTP requests because going out to the network and getting a response can be super slow. The very last thing you want to do is put that slowness between the activation of a link and the start of the request for the next page.

Beacon gets around this by queuing the request without blocking, returning control immediately back to your script. The browser then takes care of sending that request in the background without blocking. This makes everything much faster, which makes users happier and lets us all keep our jobs.

### Getting Started

So we understand what Beacon is, and why we might use it, so let’s get started with some code. The basics couldn’t be simpler:

```
let result = navigator.sendBeacon(url, data);
```

The result is boolean, `true` if the browser accepted and queued the request, and `false` if there was a problem in doing so.

#### Using `navigator.sendBeacon()`

`navigator.sendBeacon` takes two parameters. The first is the URL to make the request to. The request is performed as an HTTP POST, sending any data provided in the second parameter.

The data parameter can be in one of several formats, all if which are taken directly from the Fetch API. This can be a `Blob`, a `BufferSource`, `FormData` or `URLSearchParams` — basically any of the body types used when making a request with Fetch.

I like using `FormData` for basic key-value data as it’s uncomplicated and easy to read back.

```
// URL to send the data to
let url = '/api/my-endpoint';
    
// Create a new FormData and add a key/value pair
let data = new FormData();
data.append('hello', 'world');
    
let result = navigator.sendBeacon(url, data);
    
if (result) { 
  console.log('Successfully queued!');
} else {
  console.log('Failure.');
}
```

#### Browser Support

Support in browsers for Beacon is very good, with the only notable exceptions being Internet Explorer (works in Edge) and Opera Mini. For most uses, that should be fine, but it’s worth testing for support before trying to use `navigator.sendBeacon`.

```
That’s easy to do:

    if (navigator.sendBeacon) {
      // Beacon code
    } else {
      // No Beacon. Maybe fall back to XHR?
    }
```

If Beacon isn’t available and your request is important, you could fall back to a blocking method such as XHR. Depending on your audience and purpose, you might equally choose to not bother.

### An Example: Logging Time On A Page

To see this in practice, let’s create a basic system to time how long a user stays on a page. When the page loads we’ll note the time, and when the user leaves the page we’ll send the start time and current time to the server.

As we only care about time spent (not the actual time of day) we can use `performance.now()` to get a basic timestamp as the page loads:

```
let startTime = performance.now();
```

If we wrap up our logging into a function, we can call it when the page unloads.

```
let logVisit = function() {
  // Test that we have support
  if (!navigator.sendBeacon) return true;
      
  // URL to send the data to, e.g.
  let url = '/api/log-visit';
      
  // Data to send
  let data = new FormData();
  data.append('start', startTime);
  data.append('end', performance.now());
  data.append('url', document.URL);
      
  // Let's go!
  navigator.sendBeacon(url, data);
};
```

Finally, we need to call this function when the user leaves the page. My first instinct was to use the `unload` event, but Safari on a Mac seems to block the request with a security warning, so `beforeunload` works just fine for us here.

```
window.addEventListener('beforeunload', logVisit);
```

When the page unloads (or, just before it does) our `logVisit()` function will be called and provided the browser supports the Beacon API our beacon will be sent.

(Note that if there is no Beacon support, we return `true` and pretend it all worked great. Returning `false` would cancel the event and stop the page unloading. That would be unfortunate.)

### Considerations When Tracking

As so many of the potential uses for Beacon revolve around tracking of activity, I think it would be remiss not to mention the social and legal responsibilities we have as developers when logging and tracking activity that could be tied back to users.

#### GDPR

We may think of the recent European GDPR laws as they related to email, but of course, the legislation relates to storing any type of personal data. If you know who your users are and can identify their sessions, then you should check what activity you are logging and how it relates to your stated policies.

Often we don’t need to track as much data as our instincts as developers tell us we should. It can be better to deliberately _not_ store information that would identify a user, and then you reduce your likelihood of getting things wrong.

#### DNT: Do Not Track

In addition to legal requirements, most browsers have a setting to enable the user to express a desire not to be tracked. Do Not Track sends an HTTP header with the request that looks like this:

```
DNT: 1
```

If you’re logging data that can track a specific user and the user sends a positive `DNT` header, then it would be best to follow the user’s wishes and anonymize that data or not track it at all.

In PHP, for example, you can very easily test for this header like so:

```
if (!empty($_SERVER['HTTP_DNT'])) { 
  // User does not wish to be tracked ... 
}
```

### In Conclusion

The Beacon API is a really useful way to send data from a page back to the server, particularly in a logging context. Browser support is very broad, and it enables you to seamlessly log data without negatively impacting the user’s browsing experience and the performance of your site. The non-blocking nature of the requests means that the performance is much faster than alternatives such as XHR and Fetch.

If you’d like to read more about the Beacon API, the following sites are worth a look.

*   “[W3C Beacon specification](https://www.w3.org/TR/beacon/),” W3C Candidate Recommendation
*   “[MDN Beacon documentation](https://developer.mozilla.org/en-US/docs/Web/API/Beacon_API),” MDN web docs, Mozilla
*   “[Browser support information](https://caniuse.com/#feat=beacon),” caniuse.com

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
