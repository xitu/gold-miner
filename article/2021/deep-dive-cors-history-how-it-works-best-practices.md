> * 原文地址：[Deep dive in CORS: History, how it works, and best practices](https://ieftimov.com/post/deep-dive-cors-history-how-it-works-best-practices/)
> * 原文作者：[Ilija Eftimov](https://ieftimov.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/deep-dive-cors-history-how-it-works-best-practices.md](https://github.com/xitu/gold-miner/blob/master/article/2021/deep-dive-cors-history-how-it-works-best-practices.md)
> * 译者：
> * 校对者：

# Deep dive in CORS: History, how it works, and best practices

Learn the history and evolution of same-origin policy and CORS, understand CORS and the different types of cross-origin access in depth, and learn (some) best practices.

## The error in your browser’s console

> No ‘Access-Control-Allow-Origin’ header is present on the requested resource.

> Cross-Origin Request Blocked: The Same Origin Policy disallows reading the remote resource at [https://example.com/](https://example.com/)

> Access to fetch at ‘[https://example.com](https://example.com)’ from origin ‘http://localhost:3000’ has been blocked by CORS policy.

I am sure you’ve seen one of these errors, or a variation, in your browser’s console. If you have not – don’t fret, you soon will. There are enough CORS errors for all developers out there.

These popping-up during development can be annoying. But in fact, CORS is an incredibly useful mechanism in a world of misconfigured web servers, hostile actors on the web and organizations pushing the web standards ahead.

But let’s go back the beginning…

## In the beginning was the first subresource

A subresource is an HTML element that is requested to be embedded into the document, or executed in its context. [In the year of 1993](http://1997.webhistory.org/www.lists/www-talk.1993q1/0182.html), the first subresource `<img>` was introduced. By introducing `<img>`, the web got prettier. And more complex.

![Back to 1993](https://ieftimov.com/back-to-the-origin-with-cors/meet-img.png)

You see, if your browser would render a page with an `<img>` on it, it would actually have to go fetch that sub**resource** from an origin. When a browser fetches said subresource from an origin that does not reside on the same scheme, fully qualified hostname or port – that’s a **cross-origin request**.

### Origins & cross-origin

An origin is identified by a triple: scheme, fully qualified hostname and port. For example, `http://example.com` and `https://example.com` are different origins – the first uses `http` scheme and the second `https`. Also, the default `http` port is 80, while the `https` is 443. Therefore, in this example, the two origins differ by scheme and port, although the host is the same (`example.com`).

You get the idea – if any of the three items in the triple are different, then the origin is different.

As an exercise if we run a comparison of the `https://blog.example.com/posts/foo.html` origin against other origins, we would get the following results:

| URL | Result | Reason |
| --- | --- | --- |
| `https://blog.example.com/posts/bar.html` | Same | Only the path differs |
| `https://blog.example.com/contact.html` | Same | Only the path differs |
| `http://blog.example.com/posts/bar.html` | Different | Different protocol |
| `https://blog.example.com:8080/posts/bar.html` | Different | Different port (`https://` is port 443 by default) |
| `https://example.com/posts/bar.html` | Different | Different host |

A cross-origin request means, for example, a resource (i.e. page) such as `http://example.com/posts/bar.html` that would try to render a subresource from the `https://example.com` origin (note the scheme change!).

### The many dangers of cross-origin requests

Now that we defined what same- and cross-origin is, let’s see what is the big deal.

When we introduced `<img>` to the web, we opened the floodgates. Soon after the web got `<script>`, `<frame>`, `<video>`, `<audio>`, `<iframe>`, `<link>`, `<form>` and so on. These subresources can be fetched by the browser after loading the page, therefore they can all be same- or cross-origin requests.

Let’s travel to an imaginary world where CORS does not exist and web browsers allow all sorts of cross-origin requests.

Imagine I got a page on my website `evil.com` with a `<script>`. On the surface it looks like a simple page, where you read some useful information. But in the `<script>`, I have specially crafted code that will send a specially-crafted request to bank’s `DELETE /account` endpoint. Once you load the page, the JavaScript is executed and an AJAX call hits the bank’s API.

![Puff, your account is gone. 🌬](https://ieftimov.com/back-to-the-origin-with-cors/malicious-javascript-injection.png)

Mind-blowing – imagine while reading some information on a web page, you get an email from your bank that you’ve successfully deleted your account. I know I know… if it was THAT easy to do **anything** with a bank’s. I digress.

For my evil `<script>` to work, as part of the request your browser would also have to send your credentials (cookies) from the bank’s website. That’s how the bank’s servers would identify you and know which account to delete.

Let’s look at a different, not-so-evil scenario.

I want to detect folks that work for **Awesome Corp**, whose internal website is on `intra.awesome-corp.com`. On my website, `dangerous.com` I got an `<img src="https://intra.awesome-corp.com/avatars/john-doe.png">`.

For users that do not have a session active with `intra.awesome-corp.com`, the avatar won’t render – it will produce an error. But, if you’re logged in the intranet of Awesome Corp., once you open my `dangerous.com` website I’ll know that you have access.

That means that I will be able to derive some information about you. While it’s definitely harder for me to craft an attack, the knowledge that you have access to Awesome Corp. is still a potential attack vector.

![Leaking info to 3rd parties 💦](https://ieftimov.com/back-to-the-origin-with-cors/resource-embed-attack-vector.png)

While these two are overly-simplistic examples, it is this kind of threats that have made the same-origin policy & CORS neccessary. These are all different dangers of cross-origin requests. Some have been mitigated, others **can’t be** mitigated – they’re rooted in the nature of the web. But for the plethora of attack vectors that have been squashed – it’s because of CORS.

But before CORS, there was the same-origin policy.

## Same-origin policy

The same-origin policy prevents cross-origin attacks by blocking read access to resources loaded from a different origin. This policy still allows some tags, like `<img>`, to embeds resources from a different origin.

The same-origin policy was introduced by Netscape Navigator 2.02 in 1995, originally intended to protect cross-origin access to the DOM.

Even though same-origin policy implementations are not required to follow an exact specification, all modern browsers implement some form of it. The principles of the policy are described in [RFC6454](https://tools.ietf.org/html/rfc6454) of the Internet Engineering Task Force (IETF).

The implementation of the same-origin policy is defined with this ruleset:

| Tags | Cross-origin | Note |
| --- | --- | --- |
| `<iframe>` | Embedding permitted | Depends on `X-Frame-Options` |
| `<link>` | Embedding permitted | Proper `Content-Type` might be required |
| `<form>` | Writing permitted | Cross-origin writes are common |
| `<img>` | Embedding permitted | Cross-origin reading via JavaScript and loading it in a `<canvas>` is forbidden |
| `<audio>` / `<video>` | Embedding permitted | |
| `<script>` | Embedding permitted | Access to certain APIs might be forbidden |

Same-origin policy solves many challenges, but it is pretty restrictive. In the age of single-page applications and media-heavy websites, same-origin does not leave a lot of room for relaxation of or fine-tuning of these rules.

CORS was born with the goals to relax the same-origin policy and to fine-tune cross-origin access.

## Enter CORS

So far we covered what is an origin, how it’s defined, what the drawbacks of cross-origin requests are and the same-origin policy that browsers implement.

Now it’s time to familiarize ourselves with Cross Origin Resource Sharing (CORS). CORS is a mechanism that allows control of access to subresources on a web page over a network. The mechanism classifies three different categories of subresource access:

1. Cross-origin writes
2. Cross-origin embeds
3. Cross-origin reads

Before we go on to explain each of these categories, it’s important to realize that although your browser (by default) might allow a certain type of cross-origin request, that **does not mean that said request will be accepted by the server**.

**Cross-origin writes** are links, redirects, and form submissions. With CORS active in your browser, these are all **allowed**. There is also a thing called **preflight request** that fine-tunes cross-origin writes, so while some writes might be permitted by default it doesn’t mean they can go through in practice. We’ll look into that a bit later.

**Cross-origin embeds** are subresources loaded via: `<script>`, `<link>`, `<img>`, `<video>`, `<audio>`, `<object>`, `<embed>`, `<iframe>` and more. These are all **allowed** by default. `<iframe>` is a special one – as it’s purpose is to literally load a different page inside the frame, its cross-origin framing can be controlled by using the `X-Frame-options` header.

When it comes to `<img>` and the other embeddable subresources – it’s in their nature to trigger cross-origin requests. That’s why in CORS differentiates between cross-origin embeds and cross-origin reads, and treats them differently.

**Cross-origin reads** are subresources loaded via AJAX / `fetch` calls. These are by default **blocked** in your browser. There’s the workaround of embedding such subresources in a page, but such tricks are handled by another policy present in modern browsers.

If your browser is up to date, all of these heuristics are already implemented in it.

### Cross-origin writes

Cross-origin writes can be the very problematic. Let’s look into an example and see CORS in action.

First, we’ll have a simple [Crystal](https://crystal-lang.org/) (using [Kemal](https://kemalcr.com/)) HTTP server:

```crystal
require "kemal"

port = ENV["PORT"].to_i || 4000

get "/" do
  "Hello world!"
end

get "/greet" do
  "Hey!"
end

post "/greet" do |env|
  name = env.params.json["name"].as(String)
  "Hello, #{name}!"
end

Kemal.config.port = port
Kemal.run
```

It simply takes a request at the `/greet` path, with a `name` in the request body, and returns a `Hello #{name}!`. To run this tiny Crystal server, we can boot it with:

```bash
$ crystal run server.cr
```

This will boot the server and listen on `localhost:4000`. If we navigate to `localhost:4000` in our browser, we will be presented a simple “Hello World” page:

![Hello, world! 🌍](https://ieftimov.com/back-to-the-origin-with-cors/hello-world-localhost.png)

Now that we know our server is running, let’s execute a `POST /greet` to the server listening on `localhost:4000`, from the console of our browser page. We can do that by using `fetch`:

```javascript
fetch(
  'http://localhost:4000/greet',
  {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: 'Ilija'})
  }
).then(resp => resp.text()).then(console.log)
```

Once we run it, we will see the greeting come back from the server:

![Hi there! 👋](https://ieftimov.com/back-to-the-origin-with-cors/hello-world-localhost-post.png)

This was a `POST` request, but it was not cross-origin. We sent the request from the browser where `http://localhost:4000` (the origin) was rendered, to that same origin.

Now, let’s try the same request, but cross-origin. We will open `https://google.com` and try to send that same request from that tab in our browser:

![Hello, CORS! 💣](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post.png)

We managed to get the famous CORS error. Athough our Crystal server can fulfil the request, our browser is protecting us from ourselves. It is basically telling us that a website that we have opened wants to make changes to another website as ourselves.

In the first example, where we sent the request to `http://localhost:4000/greet` from the tab that rendered `http://localhost:4000`, our browser looks at that request and lets it through because it appears that our website is calling our server (which is fine). But in the second example where our website (`https://google.com`) wants to write to `http://localhost:4000`, then our browser flags that request and does not let it go through.

### Preflight requests

If we look deeper in our developer console, in the Network tab in particular, we will in fact notice two requests in place of the one that we sent:

![Two outbound requests as seen in the Network panel](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-network.png)

What is interesting to notice is that the first request has a HTTP method of `OPTIONS`, while the second has `POST.`

If we explore the `OPTIONS` request we will see that this is a request that has been sent by our browser prior to sending our `POST` request:

![Looking into the OPTIONS request 🔍](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-network-options.png)

What is interesting is that even though the response to the `OPTIONS` request was a HTTP 200, it was still marked as red in the request list. Why?

This is the **preflight request** that modern browsers do. A preflight request is performed for requests which CORS deems as complex. The criteria for **complex** request is:

* A request that uses methods other than `GET`, `POST`, or `HEAD`
* A request that includes headers other than `Accept`, `Accept-Language` or `Content-Language`
* A request that has a `Content-Type` header value other than `application/x-www-form-urlencoded`, `multipart/form-data`, or `text/plain`

Therefore in the above example, although we send a `POST` request, the browser considers our request complex due to the `Content-Type: application/json` header.

If we would change our server to handle `text/plain` content (instead of JSON), we can work around the need for a preflight request:

```crystal
require "kemal"

get "/" do
  "Hello world!"
end

get "/greet" do
  "Hey!"
end

post "/greet" do |env|
  body = env.request.body

  name = "there"
  name = body.gets.as(String) if !body.nil?

  "Hello, #{name}!"
end

Kemal.config.port = 4000
Kemal.run
```

Now, when we can send our request with the `Content-type: text/plain` header:

```javascript
fetch(
  'http://localhost:4000/greet',
  {
    method: 'POST',
    headers: {
      'Content-Type': 'text/plain'
    },
    body: 'Ilija'
  }
)
.then(resp => resp.text())
.then(console.log)

```

Now, while the preflight request will not be sent, the CORS policy of the browser will keep on blocking:

![CORS standing strong](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-text-plain.png)

But because we have crafted a request which does not classify as **complex**, our browser actually **won’t block the request**:

![Request went through ➡️](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-text-plain-response-blocked.png)

Simply put: our server is **misconfgured** to accept `text/plain` cross-origin requests, without any other protection in place, and our browser can’t do much about that. But still, it does the next best thing – it does not expose our opened page / tab to the response of that request. Therefore in this case, CORS does not block the request - **it blocks the response**.

The CORS policy of our browser considers this effectively a cross-origin read, because although the request is sent as `POST`, the `Content-type` header value makes it essentialy the same as a `GET`. And cross-origin reads are blocked by default, hence the blocked response we are seeing in our network tab.

Working around preflight requests like in the example above is not recommended. In fact, if you expect that your server will have to gracefully handle preflight requests, it should implement the `OPTIONS` endpoints and return the correct headers.

When implementing the `OPTIONS` endpoint, you need to know that the preflight request of the browser looks for three headers in particular that can be present on the response:

* `Access-Control-Allow-Methods` – it indicates which methods are supported by the response’s URL for the purposes of the CORS protocol.
* `Access-Control-Allow-Headers` \- it indicates which headers are supported by the response’s URL for the purposes of the CORS protocol.
* `Access-Control-Max-Age` \- it indicates the number of seconds (5 by default) the information provided by the `Access-Control-Allow-Methods` and `Access-Control-Allow-Headers` headers can be cached.

Let’s go back to our previous example where we sent a complex request:

```javascript
fetch(
  'http://localhost:4000/greet',
  {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name: 'Ilija'})
  }
).then(resp => resp.text()).then(console.log)

```

We already confirmed that when we send this request, our browser will check with the server if it can perform the cross-origin request. To get this request working in a cross-origin environment, we have to first add the `OPTIONS /greet` endpoint to our server. In its response header, the new endpoint will have to inform the browser that the request to `POST /greet`, with `Content-type: application/json` header, from the origin `https://www.google.com`, can be accepted.

We’ll do this by using the `Access-Control-Allow-*` headers:

```crystal
options "/greet" do |env|
  # Allow `POST /greet`...
  env.response.headers["Access-Control-Allow-Methods"] = "POST"
  # ...with `Content-type` header in the request...
  env.response.headers["Access-Control-Allow-Headers"] = "Content-type"
  # ...from https://www.google.com origin.
  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"
end
```

If we boot our server and send the request:

![Still blocked? 🤔](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-blocked.png)

Our request remains blocked. Even though our `OPTIONS /greet` endpoint did allow the request, we are still seeing the error message. In our network tab there’s something interesting going on:

![OPTIONS is green! 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-blocked-network-inspect.png)

The request to the `OPTIONS /greet` endpoint was a success! But the `POST /greet` call still failed. If we take a peek in the internals of the `POST /greet` request we will see a familiar sight:

![POST is green too? 😲](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-blocked-post-inspect.png)

In fact, the request did succeed – the server returned a HTTP 200. The preflight request did work – the browser did make the `POST` request instead of blocking it. But the response of the `POST` request did not contain any CORS headers, so even though the browser did make the request, it blocked any response processing.

To allow the browser also process the response from the `POST /greet` request, we need to add a CORS header to the `POST` endpoint as well:

```crystal
post "/greet" do |env|
  name = env.params.json["name"].as(String)

  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"

  "Hello, #{name}!"
end
```

By adding the `Access-Control-Allow-Origin` header response header, we tell the browser that a tab that has `https://www.google.com` open can also access the response payload.

If we give this another shot:

![POST works!](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-success.png)

We will see that `POST /greet` did get us a response, without any errors. If we take a peek in the Network tab, we’ll see that both requests are green:

![OPTIONS & POST in action! 💪](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-success-network.png)

By using proper response headers on our preflight endpoint `OPTIONS /greet`, we unlocked our server’s `POST /greet` endpoint to be accessed across different origin. On top of that, by providing a correct CORS response header on the response of the `POST /greet` endpoint, we freed the browser to process the response without any blocking.

### Cross-origin reads

As we mentioned before, cross-origin reads are blocked by default. That’s on purpose - we wouldn’t want to load other resources from other origints in the scope of our origin.

Say, we have a `GET /greet` action in our Crystal server:

```crystal
get "/greet" do
  "Hey!"
end
```

From our tab that has `www.google.com` rendered, if we try to `fetch` the `GET /greet` endpoint we will get blocked by CORS:

![CORS blocking 🙅](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-get.png)

If we look deeper in the request, we will found out something interesting:

![A successful GET 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-get-blocked-inspect.png)

In fact, just like before, our browser did let the request through – we got a HTTP 200 back. But it did not expose our opened page / tab to the response of that request. Again, in this case CORS does not block the request - **it blocks the response**.

Just like with cross-origin writes, we can relax CORS and make it available for cross-origin reading - by adding the `Access-Control-Allow-Origin` header:

```crystal
get "/greet" do |env|
  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"
  "Hey!"
end
```

When the browser gets the response back from the server, it will look at the `Access-Control-Allow-Origin` header and will decide based on its value if it can let the page read the response. Given that the value in this case is `https://www.google.com` which is the page that we use in our example the outcome will be a success:

![A successful cross-origin GET 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-get-success.png)

This is how the browser shields us from cross-origin reads and respects the server directives that are sent via the headers.

## Fine-tuning CORS

As we already saw in previous examples, to relax the CORS policy of our website, we can set the `Access-Control-Allow-Origin` of our `/greet` action to the `https://www.google.com` value:

```crystal
post "/greet" do |env|
  body = env.request.body

  name = "there"
  name = body.gets.as(String) if !body.nil?

  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"
  "Hello, #{name}!"
end
```

This will allow the `https://www.google.com` origin to call our server, and our browser will feel fine about that. Having the `Access-Control-Allow-Origin` in place, we can try to execute the `fetch` call again:

![Success! 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-text-plain-success.png)

This made it work! With the new CORS policy, we can call our `/greet` action from our tab that has `https://www.google.com` rendered. Alternatively, we could also set the header value to `*`, which would tell the browser that the server can be called from any origin.

Such a configuration has to be carefully considered. Yet, putting relaxed CORS headers is **almost always** safe. One rule of thumb is: if you open the URL in an incognito tab, and you are happy with the information you are exposing, then you can set a permissive (`*`) CORS policy on said URL.

Another way to fine-tune CORS on our website is to use the `Access-Control-Allow-Credentials` response header. `Access-Control-Allow-Credentials` instructs browsers whether to expose the response to the frontend JavaScript code when the request’s credetials mode is `include`.

The request’s credentials mode comes from the introduction of [the Fetch API](https://fetch.spec.whatwg.org/), which has its roots back the original `XMLHttpRequest` objects:

```javascript
var client = new XMLHttpRequest()
client.open("GET", "./")
client.withCredentials = true
```

With the introduction of `fetch`, the `withCredentials` option was transformed into an optional argument to the `fetch` call:

```javascript
fetch("./", { credentials: "include" }).then(/* ... */)
```

The available options for the `credentials` options are `omit`, `same-origin` and `include`. The different modes are available so developers can fine-tune the outbound request, whereas the response from the server will inform the browser how to behave when credentials are sent with the request (via the `Access-Control-Allow-Credentials` header).

The Fetch API spec contains a well-written and thorough [breakdown](https://fetch.spec.whatwg.org/#cors-protocol-and-credentials) of the interplay of CORS and the `fetch` Web API, and the security mechanisms put in place by browsers.

## Some best practices

Before we wrap it up, let’s cover some best practices when it comes to Cross Origin Resource Sharing (CORS).

### Free for all

A common example is if you own a website that displays content for the public, that is not behind paywalls, or requiring authentication or authorization – you should be able to set `Access-Control-Allow-Origin: *` to its resources.

The `*` value is a good choice in cases when:

* No authentication or authorization is required
* The resource should be accessible to a wide range of users without restrictions
* The origins & clients that will access the resource is of great variety, you don’t have knowledge of it or you simply don’t care

A dangerous prospect of such configuration is when it comes to content served on private networks (i.e. behind firewall or VPN). When you are connected via a VPN, you have access to the files on the company’s network:

![Oversimplification of VPNs](https://ieftimov.com/back-to-the-origin-with-cors/vpn-access-diagram.png)

Now, if an attacker hosts as website `dangerous.com`, which contains a link to a file within the VPN, they can (in theory) create a script on their website that can access that file:

![File leak](https://ieftimov.com/back-to-the-origin-with-cors/vpn-access-attacker-diagram.png)

While such an attack is hard and requires a lot of knowledge about the VPN and the files stored within it, it is a potential attack vector that we must be aware of.

### Keeping it in the family

Continuing with the example from above, imagine we want to implement analytics for our website. We would like our users' browsers to send us data about the experience and behavior of our users on our website.

A common way to do this is to send that data periodically using asynchronous requests using JavaScript in the browser. On the backend we have a simple API that takes these requests from our users' browsers and stores the data on the backend for further processing.

In such cases, our API is public, but we don’t want **any** website to send data to our analytics API. In fact, we are interested only in requests that originate from browsers that have our website rendered – that is all.

![](https://ieftimov.com/back-to-the-origin-with-cors/no-cross-origin-api.png)

In such cases, we want our API to set the `Access-Control-Allow-Origin` header to our website’s URL. That will make sure browsers never send requests to our API from other pages.

If users or other websites try to cram data in our analytics API, the `Access-Control-Allow-Origin` headers set on the resources of our API won’t let the request to go through:

![](https://ieftimov.com/back-to-the-origin-with-cors/failed-cross-origin-api.png)

### NULL origins

Another interesting case are `null` origins. They occur when a resource is accessed by a browser that renders a local file. For example, requests coming from some JavaScript running in a static file on your local machine have the `Origin` header set to `null`.

In such cases, if our servers do now allow access to resources for the `null` origin, then it can be a hindrance to the developer productivity. Allowing the `null` origin within your CORS policy has to be deliberately done, and only if the users of your website / product are developers.

### Skip cookies, if you can

As we saw before with the `Access-Control-Allow-Credentials`, cookies are not enabled by default. To allow cross-origin sending cookies, it as easy as returning `Access-Control-Allow-Credentials: true`. This header will tell browsers that they are allowed to send credentials (i.e. cookies) in cross-origin requests.

Allowing and acepting cross-origin cookies can be tricky. You could expose yourself to potential attack vectors, so enable them only when **absolutely neccessary**.

Cross-origin cookies work best in situations when you know exactly which clients will be accessing your server. That is why the CORS semantics do not allow us to set `Access-Control-Allow-Origin: *` when cross-origin credentials are allowed.

While the `Access-Control-Allow-Origin: *` and `Access-Control-Allow-Credentials: true` combination is technically allowed, it’s a anti-pattern and should absolutely be avoided.

If you would like your servers to be accessed by different clients and origins, you should probably look into building an API (with token-based authentication) instead of using cookies. But if going down the API path is not an option, then make sure you implement cross-site request forgery (CSRF) protection.

## Additional reading

I hope this (long) read gave you a good idea about CORS, how it came to be, and why it’s neccesary. Here are a few more links that I used while writing this article, or that I believe are a good read on the topic:

* [Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
* [`Access-Control-Allow-Credentials` header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials) on MDN Web Docs
* [Authoritative guide to CORS (Cross-Origin Resource Sharing) for REST APIs](https://www.moesif.com/blog/technical/cors/Authoritative-Guide-to-CORS-Cross-Origin-Resource-Sharing-for-REST-APIs/)
* The [“CORS protocol” section](https://fetch.spec.whatwg.org/#http-cors-protocol) of the [Fetch API spec](https://fetch.spec.whatwg.org)
* [Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy) on MDN Web Docs
* [Quentin’s](https://stackoverflow.com/users/19068/quentin) great [summary of CORS](https://stackoverflow.com/a/35553666) on StackOverflow

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
