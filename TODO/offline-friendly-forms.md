
> * 原文地址：[Offline-Friendly Forms](https://mxb.at/blog/offline-forms/)
> * 原文作者：[mxbck](https://twitter.com/intent/follow?screen_name=mxbck)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/offline-friendly-forms.md](https://github.com/xitu/gold-miner/blob/master/TODO/offline-friendly-forms.md)
> * 译者：
> * 校对者：

# Offline-Friendly Forms

Forms on the web don't usually play nice with bad connections. If you try to submit a form while offline, you'll most likely just lose your input. Here's how we might fix that.

TL;DR: Here’s the [CodePen Demo](https://codepen.io/mxbck/pen/ayYGGO/) of this post.

With the introduction of Service Workers, developers are now able to supply experiences on the web that will work even without an internet connection. While it’s relatively easy to cache static resources, things like forms that require server interaction are harder to optimize. It is possible to provide a somewhat useful offline fallback though.

First, we have to set up a new class for our offline-friendly forms. We’ll save a few properties of the `<form>` element and then attach a function to fire on submit:

```
class OfflineForm {
  // setup the instance.
  constructor(form) {
    this.id = form.id;
    this.action = form.action;
    this.data = {};
    
    form.addEventListener('submit', e => this.handleSubmit(e));
  }
}
```

In the submit handler, we can include a simple connectivity check using the `navigator.onLine` property. [Browser support for it](http://caniuse.com/online-status/embed/) is great across the board, and it’s trivial to implement.

⚠️ There is however a [possibility of false positives](https://developer.mozilla.org/en-US/docs/Web/API/NavigatorOnLine/onLine) with it, as the property can only detect if the client is connected to a network, not if there’s actual internet access. A `false` value on the other hand can be trusted to mean “offline” with relative certainty. So it’s best to check for that, instead of the other way around.

If a user is currently offline, we’ll hold off submitting the form for now and instead store the data locally.

```
handleSubmit(e) {
  e.preventDefault();
  // parse form inputs into data object.
  this.getFormData();
  
  if (!navigator.onLine) {
    // user is offline, store data on device.
    this.storeData();
  } else {
    // user is online, send data via ajax.
    this.sendData();
  }
}
```

## Storing the Form Input

There are [a few different options](https://developer.mozilla.org/en-US/docs/Web/API/Storage) on how to store arbitrary data on the user’s device. Depending on your data, you could use `sessionStorage` if you don’t want the local copy to persist in memory. For our example, let’s go with `localStorage`.

We can timestamp the form data, put it into a new object and then save it using `localStorage.setItem`. This method takes two arguments: a **key** (the form id) and a **value** (the JSON string of our data).

```
storeData() {
  // check if localStorage is available.
  if (typeof Storage !== 'undefined') {
    const entry = {
      time: new Date().getTime(),
      data: this.data,
    };
    // save data as JSON string.
    localStorage.setItem(this.id, JSON.stringify(entry));
    return true;
  }
  return false;
}
```

Hint: You can check the storage in Chrome’s devtools under the “Application” tab. If everything went as planned, you should see something like this:

![](https://mxb.at/blog/offline-forms/devtools.png)

It’s also a good idea to inform the user of what happened, so they know that their data wasn’t just lost. We could extend the `handleSubmit` function to display some kind of feedback message.

![](https://mxb.at/blog/offline-forms/message.png)

How thoughtful of you, form!

## Checking for Saved Data

Once the user comes back online, we want to check if there’s any stored submissions. We can listen to the `online` event to catch connection changes, and to the `load` event in case the page is refreshed:

```
constructor(form){
  ...
  window.addEventListener('online', () => this.checkStorage());
  window.addEventListener('load', () => this.checkStorage());
}
```

```
checkStorage() {
  if (typeof Storage !== 'undefined') {
    // check if we have saved data in localStorage.
    const item = localStorage.getItem(this.id);
    const entry = item && JSON.parse(item);

    if (entry) {
      // discard submissions older than one day. (optional)
      const now = new Date().getTime();
      const day = 24 * 60 * 60 * 1000;
      if (now - day > entry.time) {
        localStorage.removeItem(this.id);
        return;
      }

      // we have valid form data, try to submit it.
      this.data = entry.data;
      this.sendData();
    }
  }
}
```

The last step would be to remove the data from `localStorage` once we have successfully sent it, to avoid multiple submissions. Assuming an ajax form, we can do this as soon as we get a successful response back from the server. We can simply use the storage object’s `removeItem()` method here.

```
sendData() {
  // send ajax request to server
  axios.post(this.action, this.data)
    .then((response) => {
      if (response.status === 200) {
        // remove stored data on success
        localStorage.removeItem(this.id);
      }
    })
    .catch((error) => {
      console.warn(error);
    });
}
```

If you dont want to use ajax to send your form submission, another solution would be to just repopulate the form fields with the stored data, then calling `form.submit()` or have the user press the button themselves.

☝️ Note: I’ve omitted some other parts like form validation and security tokens in this demo to keep it short, obviously these would have to be implemented in a real production-ready thing. Dealing with sensitive data is another issue here, as you should not store stuff like passwords or credit card data unencrypted locally.

If you’re interested, check out [the full example on CodePen](https://codepen.io/mxbck/pen/ayYGGO).








---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
