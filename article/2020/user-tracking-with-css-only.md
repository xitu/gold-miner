> * 原文地址：[User-Tracking With CSS Only](https://medium.com/javascript-in-plain-english/tracking-with-css-ec98e3d81046)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/user-tracking-with-css-only.md](https://github.com/xitu/gold-miner/blob/master/article/2020/user-tracking-with-css-only.md)
> * 译者：
> * 校对者：

# User-Tracking With CSS Only

![Source: The author](https://cdn-images-1.medium.com/max/2800/1*5AecJjiH3Z50F_BfOIaEYw.png)

User Tracking in the browser causes discussions about privacy and data protection time and again. Tools like Google Analytics can find out almost everything — origin, language, device, retention time, and so on.

But to get some interesting information, you don’t need any external trackers — and not even JavaScript. This article will show you how to track user behavior even if the user has JavaScript disabled.

## How trackers normally work

So, the rule is that JavaScript is used for such analytics tools — so most of the information is very easy to read and can be sent immediately to a server.

That’s why there are more and more ways to block tracker tools in the browser. Browsers like the Brave Browser or certain chrome extensions block the loading of trackers like google analytics. 
The trick is that, e.g., Google Analytics is always externally integrated — so the JavaScript comes from a Google CDN. The URL for embedding is almost always the same — so it can easily be blocked.

So tracking almost always has something to do with JavaScript. And even if you block trackers by URL, the site owner might have embedded JavaScript code on the page. The strongest protection is to deactivate JavaScript — even if the price you pay for it is very high.

In the end, we can still track some things without JavaScript — with some CSS tricks that were certainly not meant for that. Let’s get started.

## Finding out the device type

Media queries should be known to every web developer. With them, we can activate CSS code only for certain screen conditions. So we can write our own Queries for smartphones or tablets.

The whole magic behind all our CSS trackers is the attributes for which we can call a URL as value. A good example is a background-image attribute, which allows us to set a background image for an element. The image is retrieved from a URL — it is first requested during execution, so a GET request is sent to the URL: background-image: url('/dog.png');

But in the end, nobody forces us to make sure that there really is an image behind the URL. The server doesn’t even have to answer the request, but we can still make a database entry in response to a GET request, for example.

```js
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/index.html");
});

app.get("/mobile", (req, res) => {
  console.log("is mobile")
  res.end()
)}
        
app.listen(8080)
```

As a backend, I use an Express.js server here. It delivers a simple HTML website; the/mobile-route is called if the device is a smartphone. So our backend is the only place where we use JavaScript.

```css
@media only screen and (max-width: 768px) {
  body {
    background-image: url("http://localhost:8080/mobile");
  }
}
```

In our index.html, we then have the CSS code from above. The background image is only requested if the user’s device matches the media query.

If a smartphone now calls the page, the media query is executed, the background image is requested, and the server outputs that it is a smartphone — fully without JavaScript.

And since we do not send a picture in reply, nothing on the website will change.

## Finding out the Operating System

Now it gets even crazier — we can find out the user’s operating system roughly with the fonts it supports. In CSS, we can create fallbacks, i.e., specify multiple fonts. If the first one does not work on the system, the browser will try the second one.

`font-family: BlinkMacSystemFont, "Arial";` — when I embed this code into our website, my Macbook uses the first font — the Apple standard font, which is only available on Mac OS. On my Windows PC, Arial is used.

With a font face, we can define a custom font and specify a source for it. Google Fonts works the same way — if we use the defined font somewhere, it must be loaded from the server first. We can use this again.

```css
 @font-face {
  font-family: Font2;
  src: url("http://localhost:8080/notmac");
 }

body {
  font-family: BlinkMacSystemFont, Font2, "Arial";
}
```

Here we set the font for the entire body. Logically you can only use one font. So on a Macbook, the first font is used, the system’s own font. On all other systems like Windows, we check if the font exists. Of course, this fails, so the next font is tried — the one we have defined ourselves. It still has to be loaded from the server, so our CSS code fires a GET request again.

Since **Font2** is, of course, not a real font, we keep trying — Arial will be used. Despite everything, we can still use a reasonable font — the user doesn’t notice anything.

## Tracking elements

What we have done so far is to evaluate information as soon as the user arrives on the site. Of course, we can also react to individual events with CSS.

For this, we can use, e.g., Hover or active-events.

```html
<head>
  <style>
    #one:hover {
      background-image: url("http://localhost:8080/one-hovered/");
    }
  </style>
</head>
<body>
  <button id="one">Hover me</button>
</body>
```

When the button is hovered, it tries again to set a background image. A GET-request is sent again.

We can do the same when the button is clicked. In CSS, this is the active-event.

```html
<head>
  <style>
    #one:active {
      background-image: url("http://localhost:8080/one-clicked/");
    }
  </style>
</head>
<body>
  <button id="one">Click me</button>
</body>
```

There is a whole series of other events. And, e.g., the hover-event works for almost every element. So theoretically, we could track almost every movement of the user.

#### A hesitation counter

With a little more code, we can also combine the events and learn more, not only which events have happened.

It is interesting for many website owners to see how long users have hesitated to click on something after seeing or hovered over the element. With the following code, we can measure the time it took the user to click after hovering.

```js
let counter;
app.get("/one-hovered", (req, res) => {
  counter = Date.now();
});

app.get("/one-active", (req, res) => {
  console.log("Clicked after", (Date.now() - counter) / 1000, "seconds");
});
```

As soon as the user hovers, the counter goes off. In the end, we spend the seconds until the click.

You might think that because it is embedded in CSS code, it might be imprecise — but it is not. The requests are tiny, and therefore immediately at the server. I tested several times and measured the time — what the server finally spits out is incredibly precise.

Scary, isn’t it?

## Making the whole thing more beautiful

In order not to get caught, it makes sense to use less obvious URLs. 
In the end, the complete front-end code is visible to everyone.

Instead of using such obvious terms for the individual routes, you can also use keywords that you have thought of yourself — in the end, only the URL in the front-end and the one in the back-end must match.

For the examples above, I always used my own routes for the GET requests. Simple so that it is easier to understand. A more elegant way is to use URL parameters or queries, which also works in CSS.

```css
@font-face {
  font-family: Font2;
  src: url("http://192.168.2.110:8080/os/mac");
  /* or: */ 
  src: url("http://192.168.2.110:8080/?os=mac");
}
```

For a detailed tutorial on query and URL parameters in Express.js, you can look here:

[**Query vs. URL Parameters in Express.js**](https://medium.com/javascript-in-plain-english/query-strings-url-parameters-d1a35b9a694f)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
