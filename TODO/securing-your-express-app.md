> * 原文地址：[Putting the helmet on – Securing your Express app](https://www.twilio.com/blog/2017/11/securing-your-express-app.html)
> * 原文作者：[Dominik Kundel](https://www.twilio.com/blog/author/dominik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/securing-your-express-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/securing-your-express-app.md)
> * 译者：
> * 校对者：

# Putting the helmet on – Securing your Express app

![](https://www.twilio.com/blog/wp-content/uploads/2017/11/4Txtn2Pl8SQnB241Dz1jvqSmUCLJksk6M97TAJYyNHPsIZE8Q9PA1NKBYZtua-v2C5UqpyBKBCFr2SaljImM2DGDGkK-XfJs1mfMkbJ7_Sc_hGP4Q70cnqgJHpVjd7NYIgjU4AJj.png)

[Express](https://expressjs.com/) is a great way to build a web server using [Node.js](https://nodejs.org/). It’s easy to get started with and allows you to configure and extend it easily thanks to its concept of middleware. While there are a [variety of frameworks to create web applications](https://www.twilio.com/blog/2016/07/how-to-receive-a-post-request-in-node-js.html) in Node.js, my first choice is always Express. However, out of the box Express doesn’t adhere to all security best practices. Let’s look at how we can use modules like [`helmet`](https://helmetjs.github.io/) to improve the security of an application.

### Set Up

Before we get started make sure you have Node.js and npm (or yarn) installed. You can find the [download and installation instructions on the Node.js website](https://nodejs.org/en/download/).

We’ll work on a new project but you can also apply these features to your existing project.

Start a new project in your command line by running:

```
mkdir secure-express-demo
cd secure-express-demo
npm init -y
```

Install the Express module by running:

```
npm install express --save
```

Create a new file called `index.js` in the `secure-express-demo` folder and add the following lines:

```
const express = require('express');
const PORT = process.env.PORT || 3000;
const app = express();

app.get('/', (req, res) => {
  res.send(`<h1>Hello World</h1>`);
});

app.listen(PORT, () => {
  console.log(`Listening on http://localhost:${PORT}`);
});
```

Save the file and let’s see if everything is working. Start the server by running:

```
node index.js
```

Navigate to [http://localhost:3000](http://localhost:3000) and you should be greeted with `Hello World`.

![hello-world.png](https://www.twilio.com/blog/wp-content/uploads/2017/11/iWq7mudUzwNSEw_IBcqBqZ9ah771qXS-SOzOng3EGIkBPVG6LoDhADeDKyCCFiF53KKrU0ZIDhEeSDz4HdjRzK3JsvigkR5wq4vYMLQS9ffmGhZ_omI9oBvTocxI_7QPLeUcsPNT.png)

### Inspecting the Headers

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/M4qx6F5BhzDuSPYBHPEx74-xorzQFM8qD-Zi7FPS4In-cPvifztKGkHsRKE7wInEw9w6717-_GAC3HczMoXtFo-otYsS3DGTwQsj1IwdBw1gnssD2fW-sMdPuTz2QxBCcseUyIgP.png)

We’ll start by adding and removing a few HTTP headers that will help improve our security. To inspect these headers you can use a tool like `curl` by running:

```
curl http://localhost:3000 --include
```

The `--include` flag makes sure to print out the HTTP headers of the response. If you don’t have `curl` installed you can also use your favorite browser developer tools and the networking pane.

At the moment you should see the following HTTP headers being transmitted in the response:

```
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 20
ETag: W/"14-SsoazAISF4H46953FT6rSL7/tvU"
Date: Wed, 01 Nov 2017 13:36:10 GMT
Connection: keep-alive
```

One header that you should keep an eye on is `X-Powered-By`. Generally speaking headers that start with `X-` are non-standard headers. This one gives away which framework you are using. For an attacker, this cuts the attack space down for them as they can concentrate on the known vulnerabilities in that framework.

### Putting the helmet on

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/24T5xMrL0RCEEObLniOCuiZ4f4p-w6QUJWDJb4UlbayqlUnzn51IvLbbWH04jjVi1GxRzUX12_lseIPgJo0ZeW3TbO6ArTOS_B32kjbeUWfxb6qKp0_HNHbwolL40zF_1gCr3dbC.png)

Let’s see what happens if we start using `helmet`. Install `helmet` by running:

```
npm install helmet --save
```

Now add the `helmet` middleware to your application. Modify the `index.js` accordingly:

```
const express = require('express');
const helmet = require('helmet');
const PORT = process.env.PORT || 3000;
const app = express();

app.use(helmet());

app.get('/', (req, res) => {
  res.send(`<h1>Hello World</h1>`);
});

app.listen(PORT, () => {
  console.log(`Listening on http://localhost:${PORT}`);
});
```

This is using the default configuration of `helmet`. Let’s take a look at what it actually does. Restart the server and inspect the HTTP headers again by running:

```
curl http://localhost:3000 --inspect
```

The new headers should look something like this:

```
HTTP/1.1 200 OK
X-DNS-Prefetch-Control: off
X-Frame-Options: SAMEORIGIN
Strict-Transport-Security: max-age=15552000; includeSubDomains
X-Download-Options: noopen
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Content-Type: text/html; charset=utf-8
Content-Length: 20
ETag: W/"14-SsoazAISF4H46953FT6rSL7/tvU"
Date: Wed, 01 Nov 2017 13:50:42 GMT
Connection: keep-alive
```

The `X-Powered-By` header is gone, which is a good start, but now we have a bunch of new headers. What are they all doing?

#### X-DNS-Prefetch-Control

This header isn’t much of an added security benefit as much as an added privacy benefit. By setting the value to `off` it turns off the DNS lookups that the browser does for URLs in the page. The DNS lookups are done for performance improvements and according to MDN they can [improve the performance of loading images by 5% or more](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control). However this look up can make it appear like the user visited things they never visited.

The default for this is `off` but if you care about the added performance benefit you can enable it by passing `{ dnsPrefetchControl: { allow: true }}` to the `helmet()` call.

#### X-Frame-Options

`X-Frame-Options` allows you to control whether the page can be loaded in a frame like `<frame/>` `<iframe/>` or `<object/>`. Unless you really need to frame your page you should just disable it entirely by passing the option to the `helmet()` call:

```
app.use(helmet({
  frameguard: {
    action: 'deny'
  }
}));
```

[`X-Frame-Options` is supported by all modern browsers](http://caniuse.com/#feat=x-frame-options). It can however also be controlled via a Content Security Policy as we’ll see later.

#### Strict-Transport-Security

This is also known as HSTS (HTTP Strict Transport Security) and is used to ensure that there is no protocol downgrade when you are using HTTPS. If a user visited the website once on HTTPS it makes sure that the browser will not allow any future communication via HTTP. This feature is helpful to avoid Man-In-The-Middle attacks.

You might have seen this feature in action if you tried to access a page like https://google.com while being on a public WiFi with a captive portal. The WiFi is trying to redirect you to their captive portal but since you visited `google.com` before via HTTPS and it set the `Strict-Transport-Security` header, the browser will block this redirect.

You can read more about it on the [MDN page](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security) or the [OWASP wiki page](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet).

#### X-Download-Options

This header is only protecting you from an old IE security vulnerability. Basically if you host untrusted HTML files for download, users were able open these directly (rather than saving them to disk first) and they would execute in the context of your app. This header ensures that users download files before they open them so that they can’t execute in your app’s security context.

You can find more information about this on the [helmet page](https://helmetjs.github.io/docs/ienoopen/) and this [MSDN blog post](https://blogs.msdn.microsoft.com/ie/2008/07/02/ie8-security-part-v-comprehensive-protection/).

#### X-Content-Type-Options

Some browsers perform “MIME sniffing” meaning that rather than loading things based on the `Content-Type` that the server will send, the browser will try to determine the content type based on the file content and execute it based on that.

Say your page offers a way to upload pictures and an attacker uploads some HTML instead, if the browser performs MIME sniffing, it could execute the code as HTML and the attacker would have performed a successful XSS attack.

By setting this header to `nosniff` we are disabling this MIME sniffing.

#### X-XSS-Protection

This header is used to turn on basic XSS protections in the user’s browser. It can’t avoid every XSS opportunity but it can determine basic ones. For example, if it detects that the query string contains something like a script tag, the browser could block the execution of the same code in the page knowing that it’s likely an XSS attack. This header can have three different values. `0`, `1` and `1; mode=block`. If you want to learn more about which mode you should choose, make sure to [check out this blog post about `X-XSS-Protection` and it’s potential dangers](https://blog.innerht.ml/the-misunderstood-x-xss-protection/).

#### Upgrading your helmet

These are just the default settings that [`helmet`](https://helmetjs.github.io/docs/) provides. Additionally it allows you to configure headers like the [`Expect-CT`](https://helmetjs.github.io/docs/expect-ct/), [`Public-Key-Pins`](https://helmetjs.github.io/docs/hpkp/), [`Cache-Control`](https://helmetjs.github.io/docs/nocache/) and [`Referrer-Policy`](https://helmetjs.github.io/docs/referrer-policy/). You can find more about the respective headers and how to configure them in the [`helmet` documentation](https://helmetjs.github.io/docs/).

### Protecting your page from unwanted content

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/CiDkwYBIJX1JQmhyaq8kYH0dkEpphioLjjva6KUWc5pS4KuSyX94eKxSfohWC_v574aYYn6Z2c6ALeyw0hizq7f66Po8ibiV1d_naYdPaoO1B8C72mQ4pLZij6ytKGH0v5WsQSPB.png)

Cross-site scripting is a constant threat to web applications. If an attacker can inject and run code in your application it can be a nightmare for you and your users. One solution that tries to stop the risk of unwanted code being executed on your page is a `Content Security Policy` or `CSP`.

A CSP allows you to specify a set of rules that define the origins from which your page can load various resources. Any resource that violates these rules will be blocked by the browser automatically.

You can specify these rules via the `Content-Security-Policy` HTTP header but you can also set them in an HTML meta tag if you don’t have a way to modify the HTTP headers.

This is what such a header might look like:

```
Content-Security-Policy: default-src 'none';
    script-src 'nonce-XQY ZwBUm/WV9iQ3PwARLw==';
    style-src 'nonce-XQY ZwBUm/WV9iQ3PwARLw==';
    img-src 'self';
    font-src 'nonce-XQY ZwBUm/WV9iQ3PwARLw==' fonts.gstatic.com;
    object-src 'none';
    block-all-mixed-content;
    frame-ancestors 'none';
```

In this example you can see that for fonts we only allow them if they are from our own domain or from fonts.gstatic.com aka Google Fonts. Images we’ll only allow from our own domain and not any external domain. For scripts and styles, however, we only allow them if they have a certain `nonce`. This means we don’t even care about the origin but we care about a very specific value. This nonce has to be specified in a way like below:

```
<script src="myscript.js" nonce="XQY ZwBUm/WV9iQ3PwARLw=="></script>
<link rel="stylesheet" href="mystyles.css" nonce="XQY ZwBUm/WV9iQ3PwARLw==" />
```

When the browser receives the HTML it will make sure to clear out the nonce for security purposes, so other scripts won’t be able to access them to add additional unwanted scripts.

We are also disabling any mixed content meaning that HTTP content inside our HTTPS page is not permitted. Other things that we don’t permit are any `<object />` elements and anything that isn’t an image, stylesheet or script since the `default-src` is mapping to `none`. Additionally we are disabling iframing with the `frame-ancestors` value.

We could write these headers manually but luckily there are plenty of solutions to use CSP in Express. [`helmet` comes with support for CSP](https://helmetjs.github.io/docs/csp/) but in the case of `nonce` it forces you to generate them yourself. I’m personally using a module called `express-csp-header` for this.

Install `express-csp-header` by running:

```
npm install express-csp-header --save
```

Consume and enable CSP by adding the following lines to your `index.js`

```
const express = require('express');
const helmet = require('helmet');
const csp = require('express-csp-header');

const PORT = process.env.PORT || 3000;
const app = express();

const cspMiddleware = csp({
  policies: {
    'default-src': [csp.NONE],
    'script-src': [csp.NONCE],
    'style-src': [csp.NONCE],
    'img-src': [csp.SELF],
    'font-src': [csp.NONCE, 'fonts.gstatic.com'],
    'object-src': [csp.NONE],
    'block-all-mixed-content': true,
    'frame-ancestors': [csp.NONE]
  }
});

app.use(helmet());
app.use(cspMiddleware);

app.get('/', (req, res) => {
  res.send(`
    <h1>Hello World</h1>
    <style nonce=${req.nonce}>
      .blue { background: cornflowerblue; color: white; }
    </style>
    <p class="blue">This should have a blue background because of the loaded styles</p>
    <style>
      .red { background: maroon; color: white; }
    </style>
    <p class="red">This should not have a red background, the styles are not loaded because of the missing nonce.</p>
  `);
});

app.listen(PORT, () => {
  console.log(`Listening on http://localhost:${PORT}`);
});
```

Restart your server and navigate to [http://localhost:3000](http://localhost:3000) you should see one paragraph with a blue background because the styles have been loaded. The other paragraph is not styled because of the missing nonce.

![csp-output.png](https://www.twilio.com/blog/wp-content/uploads/2017/11/OYQ_GhVogC6bcGAZOtqKO9DL4l4KhV8YatnWhJP9sjliXdN7beuXhTbPLwyvCQmqyxmy-z5FN4_mDySsRorhjOxarh2p1EAWKusxZ4qSIsI0CAq_1p_BlrhFiCoG6mPa4iZhR2WO.png)

The CSP header allows you also to specify a report URL that a violation report should be sent to and you can even execute CSP in report-only mode if you want to gather some data first before enforcing it strictly.

You can find more information about [CSP on the respective MDN page](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) and the [current browser support on the caniuse.com page](http://caniuse.com/#feat=contentsecuritypolicy) but overall all major browsers support it.

### Summary

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/JtIZ-AdTwknGCyMvERM7uj2ttVknsuo6KgKDzKGlOS-TWUu3GVTEtqu-TxByxxaptnsZsvoXPll__9_5ScxtUnoTDqPzuPuGcGSuYNDKHljkTF6XP8xUYWuqtCuqScWryS3me3M5.png)

Unfortunately there is no silver bullet in security and new vulnerabilities constantly pop up but setting these HTTP headers in your web applications is easy to do and significantly improve your app’s security. If you want to do a quick check of how your HTTP headers hold up to security best practices, make sure to [check out securityheaders.io](https://securityheaders.io/).

If you want to learn more about web security best practices, make sure to [check out the Open Web Applications Security Project aka. OWASP](https://www.owasp.org/index.php/Main_Page). It covers a wide selection of topics and links to additional helpful resources.

If you have any questions or any other helpful tools to improve the security of your Node.js web applications, feel free to ping me:

*   Twitter: [@dkundel](https://twitter.com/dkundel)
*   Email: [dkundel@twilio.com](mailto:dkundel@twilio.com)
*   GitHub: [dkundel](https://github.com/dkundel)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
