> * 原文地址：[Introduction to nginScript](https://www.nginx.com/blog/introduction-nginscript/)
> * 原文作者：[Liam Crilly](https://www.nginx.com/blog/author/liam-crilly/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： 
> * 校对者：

# Introduction to nginScript


![](https://cdn.wp.nginx.com/wp-content/uploads/2017/03/introduction-to-nginScript-1000x600.jpg)

### *Harnessing the Power and Convenience of JavaScript for Each Request*

*Editor – This is the first in a series of blog posts about nginScript. It discusses why NGINX, Inc. developed its own implementation of JavaScript, and presents a sample use case. Check out the other posts to explore additional use cases:*

- [*Introduction to nginScript*](https://www.nginx.com/blog/introduction-nginscript/)
- [*Using nginScript to Progressively Transition Clients to a New Server*](https://www.nginx.com/blog/nginscript-progressively-transition-clients-to-new-server/)
- [*Advanced Logging with nginScript*](https://www.nginx.com/blog/scaling-mysql-tcp-load-balancing-nginx-plus-galera-cluster/#nginscript-logging-galera) in "Scaling MySQL with TCP Load Balancing and Galera Cluster"
- [*Data Masking for User Privacy with nginScript*](https://www.nginx.com/blog/data-masking-user-privacy-nginscript/)

Since nginScript launched in [September 2015](https://www.nginx.com/blog/nginscript-new-powerful-way-configure-nginx/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product) it has remained an experimental module while additional capabilities and core language support were added. With NGINX Plus R12 we are pleased to announce that nginScript is now generally available as a stable module for NGINX and NGINX Plus.

nginScript is a unique JavaScript implementation for NGINX and NGINX Plus, designed specifically for server‑side use cases and per‑request processing. It extends NGINX configuration syntax with JavaScript code in order to implement sophisticated configuration solutions.

The use cases are extensive, especially as nginScript is available for both HTTP and TCP/UDP protocols. Example use cases for nginScript include:

- Generating custom log formats with values not available from regular NGINX variables
- Implementing new load‑balancing algorithms
- Parsing TCP/UDP protocols for application‑level sticky sessions

There are of course many more possibilities for nginScript, and more still that have yet to be implemented. Although we are pleased to announce general availability of nginScript and be able to recommend it for production use, there is a roadmap of planned improvements that will enable yet more use cases, such as:

- Inspecting and modifying the body of HTTP requests and responses (already supported for TCP/UDP traffic)
- Making HTTP subrequests from nginScript code
- Writing authentication handlers for HTTP requests (already supported for TCP/UDP traffic)
- Reading and writing files

Before discussing nginScript in more detail, let’s first address two common misconceptions.

## nginScript Is Not Lua

The NGINX community has created several programmatic extensions over the years. At the time of writing, Lua is the most popular of these; it’s available as a [module for NGINX](https://github.com/openresty/lua-nginx-module) and a [certified third‑party module](https://www.nginx.com/products/technical-specs/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product) for NGINX Plus. The Lua module and add‑on libraries provide deep integration with the NGINX core and a rich set of functionality, including a driver for Redis.

Lua is a powerful scripting language. It, however, remains fairly niche in terms of adoption and is not typically found in the “skillset toolbox” of the frontend developer or DevOps engineer.

nginScript does not seek to replace Lua and it will be some time before nginScript has a comparable level of functionality. The goal of nginScript is to provide programmatic configuration solutions to the widest possible community by using a popular programming language.

## nginScript Is Not Node.js

nginScript does not aim to turn NGINX or NGINX Plus into an application server. In simple terms, the use cases for nginScript are akin to middleware, as the code execution happens between the client and the content. Technically speaking, while Node.js shares two things with the combination of nginScript and NGINX or NGINX Plus – an [event‑driven architecture](https://www.nginx.com/blog/inside-nginx-how-we-designed-for-performance-scale/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product) and the JavaScript programming language – the similarities end there.

Node.js uses the Google V8 JavaScript engine, whereas nginScript is a bespoke implementation of the ECMAScript standards, designed specifically for NGINX and NGINX Plus. Node.js has a persistent JavaScript virtual machine in memory and performs routine garbage collection for memory management, whereas nginScript initializes a new JavaScript virtual machine and the necessary memory for each request and frees the memory when the request is completed.

## JavaScript as a Server-Side Language

As mentioned above, nginScript is a bespoke implementation of the JavaScript language. All other existing JavaScript runtime engines are designed to be executed within a web browser. The nature of client‑side code execution is different from server‑side code execution in many ways – from the availability of system resources to the possible number of concurrent runtimes.

We decided to implement our own JavaScript runtime in order to meet the requirements of server‑side code execution and fit elegantly with NGINX’s request‑processing architecture. Our design principles for nginScript are these:

- 
**Runtime environment lives and dies with the request**

nginScript uses single‑threaded bytecode execution, designed for quick initialization and disposal. The runtime environment is initialized per request. Startup is extremely quick, because there is no complex state or helpers to initialize. Memory is accumulated in pools during execution and released at completion by freeing the pools. This memory management scheme eliminates the need to track and free individual objects or to use a garbage collector.

- 
**Non‑blocking code execution**

NGINX and NGINX Plus’ event‑driven model schedules the execution of individual nginScript runtime environments. When an nginScript rule performs a blocking operation (such as reading network data or issuing an external subrequest), NGINX and NGINX Plus transparently suspend execution of that VM and reschedule it when the event completes. This means that you can write rules in a simple, linear fashion and NGINX and NGINX Plus schedule them without internal blocking.

- 
**Implement only the language support that we need**

The specifications for JavaScript are defined by the [ECMAScript](https://en.wikipedia.org/wiki/ECMAScript) standards. nginScript follows [ECMAScript 5.1](http://www.ecma-international.org/ecma-262/5.1/) with some [ECMAScript 6](http://www.ecma-international.org/ecma-262/6.0/) for mathematical functions. Implementing our own JavaScript runtime gives us the freedom to prioritize language support for server‑side use cases and ignore what we don’t need. We maintain a [list of supported and not‑yet‑supported language elements](http://nginx.org/en/docs/njs_about.html).

- 
**Close integration with request‑processing phases**

NGINX and NGINX Plus process requests in distinct phases. Configuration directives typically operate at a specific phase and native NGINX modules often take advantage of the ability to inspect or modify a request at a particular phase. nginScript exposes some of the processing phases through configuration directives to give control over when the JavaScript code is executed. This integration with the configuration syntax promises the power and flexibility of native NGINX modules with the simplicity of JavaScript code.

The table below indicates which processing phases are accessible via nginScript at the time of writing, and the configuration directives that provide it.

|Processing Phase|HTTP Module|Stream (TCP/UDP) Module|
|------|-------|-------|
|Access – Network connection access control|❌|✅ [js_access](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_access)|
|Pre-read – Read/write body|❌|✅ [js_preread](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_preread)|
|Filter – Read/write body during proxy|❌|✅ [js_filter](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_filter)|
|Content – Send response to client|✅ [js_content](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_content)|❌|
|Log / Variables – Evaluated on demand|✅ [js_set](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_set)|✅ [js_set](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_set)|

## Getting Started with nginScript – A Real‑World Example

nginScript is implemented as a module that you can compile into an open source NGINX binary or dynamically load into NGINX or NGINX Plus. [Instructions for enabling nginScript](#nginscript-enable) with NGINX and NGINX Plus appear at the end of this article.

In this example we use NGINX or NGINX Plus as a simple reverse proxy and use nginScript to construct access log entries in a specialized format, that:

- Includes the request headers sent by the client
- Includes the response headers returned by the backend
- Uses key‑value pairs for efficient ingestion into and searching with log processing tools such as the ELK Stack (now called Elastic Stack), Graylog, and Splunk

The NGINX configuration for this example is extremely simple.

```
Failed loading gist 
https://gist.github.com/49e2f6f6b0a36ed9846dd63cddbd742a.json: timeout
```

As you can see, the nginScript code does not sit inline with the configuration syntax. We use the [`js_include`](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_include) directive to specify the file that contains all of our JavaScript code. The [`js_set`](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_set) directive defines a new NGINX variable, `$access_log_with_headers`, and the JavaScript function that populates it. The [`log_format`](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) directive defines a new format called **kvpairs** which writes each log line with the value of `$access_log_with_headers`.

The [`server`](http://nginx.org/en/docs/http/ngx_http_core_module.html#server) block defines a simple HTTP reverse proxy that forwards all requests to **http://www.example.com**. The [`access_log`](http://nginx.org/en/docs/http/ngx_http_log_module.html#access_log) directive specifies that all requests will be logged with the **kvpairs** format.

Let’s now look at the JavaScript code that prepares the log line. We have two functions:

- `kvHeaders` – A support function that converts the `headers` object to a string of key‑value pairs. Support functions must be declared before the function that calls them.
- `kvAccessLog` – The function defined in the `js_set` directive within the NGINX configuration. It receives two object [arguments](http://nginx.org/en/docs/http/ngx_http_js_module.html#arguments) that represent the client request (`req`) and the backend server’s response (`res`). Built‑in objects like these can be passed to all HTTP nginScript functions.

As can be seen in the `kvAccessLog` function, it is the return value that is passed to the [`js_set`](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_set) configuration directive. Bear in mind that NGINX variables are evaluated on demand and this in turn means that the JavaScript function defined by `js_set` is executed when the value of the variable is required. In this example, `$access_log_with_headers` is used in the [`log_format`](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) directive and so `kvAccessLog()` is executed at log time. Variables used as part of [`map`](http://nginx.org/en/docs/http/ngx_http_map_module.html#map) or [`rewrite`](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite) directives trigger the corresponding JavaScript execution at an earlier processing phase.

We can see this nginScript‑enhanced logging solution in action by passing a request through our reverse proxy and observing the resulting log file entry.

```
$ curl http://127.0.0.1/
$ tail --lines=1 /var/log/nginx/access_headers.log
2017-03-14T14:36:53+00:00 client=127.0.0.1 method=GET uri=/ status=200 req.Host=127.0.0.1 req.User-Agent=curl/7.47.0 req.Accept=*/* res.Cache-Control=max-age=604800 res.Etag=\x22359670651+ident\x22 res.Expires='Tue, 21 Mar 2017 14:36:53 GMT' res.Last-Modified='Fri, 09 Aug 2013 23:54:35 GMT' res.Vary=Accept-Encoding res.X-Cache=HIT
```

Much of the utility of nginScript is a result of its access to NGINX internals. This example utilizes several [properties of the request and response objects](http://nginx.org/en/docs/http/ngx_http_js_module.html#arguments). The Stream nginScript module for TCP and UDP applications utilizes a single [session object with its own set of properties](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#properties). See our blog for other examples of nginScript solutions:

- HTTP – [Using nginScript to progressively transition clients to a new server](https://www.nginx.com/blog/nginscript-progressively-transition-clients-to-new-server/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product)
- Stream – [Logging the SQL method when load balancing Galera Cluster](https://www.nginx.com/blog/scaling-mysql-tcp-load-balancing-nginx-plus-galera-cluster/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product#nginscript-logging-galera)

We’d love to hear about the use cases that you come up with for nginScript – please tell us about them in the comments section below.

---

## Enabling nginScript for NGINX and NGINX Plus

- [Loading nginScript for NGINX Plus](#nginscript-nginx-plus-load)
- [Loading nginScript for Open Source NGINX](#nginscript-oss-load)
[#nginscript-oss-load](#nginscript-oss-load)- [#nginscript-oss-load](#nginscript-oss-load)[Compiling nginScript as a Dynamic Module for Open Source NGINX](#nginscript-oss-compile)

### Loading nginScript for NGINX Plus

nginScript is available as a free [dynamic module](https://www.nginx.com/products/dynamic-modules/) for NGINX Plus subscribers (for open source NGINX, see [Loading nginScript for Open Source NGINX](#nginscript-oss-load) below). 

1. 
Obtain the module itself by installing it from the NGINX Plus repository.

- 
For Ubuntu and Debian systems:

```
$ sudo apt‑get install nginx-plus-module-njs
```

For RedHat, CentOS, and Oracle Linux systems:

```
$ sudo yum install nginx-plus-module-njs
```

- 
Enable the module by including a [`load_module`](http://nginx.org/en/docs/ngx_core_module.html#load_module) directive for it in the top‑level ("main") context of the **nginx.conf** configuration file (not in the `http` or `stream` context). This example loads the nginScript module for HTTP traffic.

```
load_module modules/ngx_http_js_module.so;
```

- 
Reload NGINX Plus to load the nginScript module into the running instance.

```
$ sudo nginx -s reload
```

### Loading nginScript for Open Source NGINX

If your system is configured to use the official [pre‑built packages for open source NGINX](http://nginx.org/en/linux_packages.html#mainline) and your installed version is 1.9.11 or later, then you can install nginScript as a pre‑built package for your platform.

1.
Install the pre‑built package.

- 
For Ubuntu and Debian systems:

```
$ sudo apt-get install nginx-module-njs
```

- 
For RedHat, CentOS, and Oracle Linux systems:

```
$ sudo yum install nginx-module-njs
```

2.
Enable the module by including a [`load_module`](http://nginx.org/en/docs/ngx_core_module.html#load_module) directive for it in the top‑level ("main") context of the **nginx.conf** configuration file (not in the `http` or `stream` context). This example loads the nginScript module for HTTP traffic.

```
load_module modules/ngx_http_js_module.so;
```

3.
Reload NGINX Plus to load the nginScript module into the running instance.

    $ sudo nginx -s reload

### Compiling nginScript as a Dynamic Module for Open Source NGINX

If you prefer to compile an NGINX module from source:

1. Follow [these instructions](https://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus/) to build the nginScript module from the [open source repository](http://hg.nginx.org/njs/).
2. Copy the module binary (**ngx_http_js_module.so**) to the **modules** subdirectory of the NGINX root (usually **/etc/nginx/modules**).
3. Perform Steps 2 and 3 in [Loading nginScript for Open Source NGINX](#nginscript-oss-load&quot;).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
