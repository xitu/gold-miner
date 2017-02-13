> * 原文地址：[Web Share API brings the native sharing capabilities to the browser](https://blog.hospodarets.com/web-share-api#why-do-we-need-a-new-api)
* 原文作者：[Serg Hospodarets](https://blog.hospodarets.com/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Web Share API brings the native sharing capabilities to the browser #

For many years the Web is moving towards the parity with the Mobile native applications
and adds the missed features.
Today browsers have most of them, from the offline mode and enhancements with the Service Workers
to Geolocation and NFC.

The one huge ability, which is still missed, but highly used in the mobile applications-
the ability to share a page, article or some specific data.

The Web Share API is the first step to fill the gap and bring the
native sharing capabilities to the Web.

# Why do we need a new API #

Previous years there were many tries to deliver some API/agreement for the sharing in
the mobile Web applications:

1) [Web Intents](http://webintents.org/)
were introduced and implemented in Chrome 18 but
[deprecated in Chrome 24](https://developer.chrome.com/apps/app_intents)

2) There are couple solutions with custom URLs:

- [Android intent: URLs](https://developer.chrome.com/multidevice/android/intents).
It is very powerful API, but it’s Android specific and
[there are dozens of problems to use this for the sharing](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#why-cant-sites-just-use-android-intent-urls)

- [Custom URL Schemes on macOS or iOS](https://css-tricks.com/create-url-scheme/)
also work and are provided, but they have similar problems as the Android solution

3) Mozilla proposed [Web Activities](https://developer.mozilla.org/en-US/docs/Archive/Firefox_OS/API/Web_Activities)
but currently, they are obsolete and unsupported.

So the current situation is that there isn’t API to simply share content on the Web.
But users need a way to quickly share URL/text/image data into their favorite apps and services easily.

The current abilities are:

1. Share buttons to the specific services (which resulted in the number of API’s from the services and 
aggregators to provide just share buttons)

2. Many browsers and applications provide their own specific share buttons.

But again, there isn’t a way to simply share content from the Web application.

# The Web Share API #

The current Web Share API uses the best practices of non-blocking
[Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise)-based API.

From the data you can share, as for most other share APIs, there are `title`, `url`, and `text` (one of which is required).
There is a plan to allow image data and/or file blobs.

Here how it looks:

```
function onShareClick(photo){
    // WEB SHARE API
    navigator.share({
        title: 'Checkout this funny photo',
        text: '',
        url: window.location.origin + '/' + photo.id 
    })
    .then(() => console.log('Successfully shared'))
    .catch((error) => console.log('Error sharing:', error));
}
```


[image credits](https://github.com/mgiuca/web-share/blob/master/docs/mocks/README.md)

As you see, the API is quite simple and currently expects at least one of the following fields:

- `title` (string): The title of the document being shared (may be ignored by the handler).
- `text` (string): the text that forms the body of the message being shared.
- `url` (string): URL / URI to a resource being shared.

The method returns a Promise.
 It is resolved if the user chooses a target application, and that application accepts the data without errors.

There may be cases when the Promise is rejected:

- invalid data to be shared (for instance, inappropriate fields passed)
- the user canceled the picker dialog or there is no app to share the data
- the data couldn’t be delivered to the target app

# The data to be shared #

For all the fields passed to the `navigator.share` there are many predefined values usually provided on the sites.

For example, there is popular [Open Graph Markup](http://ogp.me/).
If your site uses it, you can simply reuse the values if you want to share the page data.

I used this approach for the demo:

```
function getOpenGraphData(property){
    return document.querySelector(`meta[property="${property}"]`)
        .getAttribute('content');
}

const sharePage = () => {
        navigator.share({
            title: getOpenGraphData('og:title'),
            text: getOpenGraphData('og:description'),
            url: getOpenGraphData('og:url')
        }) //...
}
```

[Demo](/demos/web-share-api/)

Here is the video how it works 

(tap the share button ➡️  tweet ➡️  check the tweet is added on Twitter):

![](https://hospodarets.com/img/blog/1485720302108099000.gif)

In the most common case, if you want to add an ability to share the data
from any of the pages, but you are not sure if there will be Open Graph or other tags,
here is the common pattern:

```
navigator.share({
    title: document.title,
    url: document.querySelector('link[rel=canonical]') ?
        document.querySelector('link[rel=canonical]').href :
        window.location.href
})
```

Where [`link[rel=canonical]`](https://en.wikipedia.org/wiki/Canonical_link_element) represent the optional but quite popular `<link>` element,
 which represents the URL to be used if the site has e.g. has e.g. a prefixed `mobile.` URL
 or other additions in the URL, which shouldn’t be shared.

If the canonical link is not provided, the default URL is shared.

The latest suggestion, don’t remember to disable or fallback the share functionality if it’s not available
(browsers without support, devices without share capabilities etc.):

```
if(!navigator.share){
  shareButton.hidden = true;
  return;
}
// SHARE CODE
```

# Requirements #

Currently, the Web share API is available in the stable Chrome on Android.

But, first of all, it requires HTTPS and secondary is enabled under the [Origin Trial](https://github.com/jpchase/OriginTrials/blob/gh-pages/developer-guide.md).

In short, the Origin Trial makes a way for developers to enable the API for a fixed period of time.
This will give the feedback for a vendor and the API authors/implementors.
You can interpret that like a flag for the browser you can enable for your site.
You can find the list of the available trials [here](https://github.com/jpchase/OriginTrials/blob/gh-pages/available-trials.md).

To enable the Web Share API you need:

1. [Sign up to get the trial token](https://docs.google.com/forms/d/e/1FAIpQLSfO0_ptFl8r8G0UFhT0xhV17eabG-erUWBDiKSRDTqEZ_9ULQ/viewform)
2. During the next 24 hours, you are sent an email with the Trial Token and details how to include it to the Web App
3. You include the token via header or directly into the page HTML, globally or everywhere where you want to use the API:

```
<metahttp-equiv="origin-trial"data-feature="Web Share"content="TOKEN_FROM_THE_EMAIL">
```

Web Share trial was introduced in Chrome 55 and may end in April 2017, after which may be enabled by default in the browser.

Let’s summarize the steps to make the Web Share API work:

1. The site is served via HTTPS
2. The origin trial header/meta is provided till the API enabled by default
3. `navigator.share()` is called via user action (click, tap..)

# Conclusion #

The Web is moving forward to remove the border between the mobile Web and Native apps, and 
the Web Share API is the next step to it you can use today.

The future work will be around the implementation of the API to other platforms and adding the ability to
provide image data or share files (blob).

Also, there is a discussion for the web apps to receive shares, not just send them.
This is called the
[Web Share Target API](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#how-can-a-web-app-receive-a-share-from-another-page0)
and we may hear more from there after a while.

And the list of the useful links in the end:

- [Web Share API Proposal](https://github.com/WICG/web-share)
- [Intent to Experiment: Web Share on Android](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/zuqQaLp3js8/5V9wpRWhBgAJ)
