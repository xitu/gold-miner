> * 原文地址：[Introduction to nginScript](https://www.nginx.com/blog/introduction-nginscript/)
> * 原文作者：[Liam Crilly](https://www.nginx.com/blog/author/liam-crilly/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [1992chenlu](https://github.com/1992chenlu)
> * 校对者：[mnikn](https://github.com/mnikn)、[imink](https://github.com/imink)

# nginScript 入门


![](https://cdn.wp.nginx.com/wp-content/uploads/2017/03/introduction-to-nginScript-1000x600.jpg)

### **在 HTTP 请求中发挥出 JavaScript 的强大力量和便捷优势**

**编者的话 – 这是关于 nignScript 这个系列的博文的第一篇。本文中讨论了 NGINX 公司选择自己实现 JavaScript 的原因，并且提供了一个简单的使用案例。探索更多的使用案例，请阅读其他的博文：**

-  [**nginScript 入门**](https://www.nginx.com/blog/introduction-nginscript/)
- [**使用 nginScript 逐步迁移客户端到新的服务器**](https://www.nginx.com/blog/nginscript-progressively-transition-clients-to-new-server/)
- 在“Galera 集群负载均衡过程中 SQL 方法的日志记录”中的 [**nginScript 日志记录进阶**](https://www.nginx.com/blog/scaling-mysql-tcp-load-balancing-nginx-plus-galera-cluster/#nginscript-logging-galera)
- [**使用 nginScript 实现基于数据遮蔽的用户隐私保护**](https://www.nginx.com/blog/data-masking-user-privacy-nginscript/)

自从 nginScript [2015 年 9 月](https://www.nginx.com/blog/nginscript-new-powerful-way-configure-nginx/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product)上线以来，作为一个实验性的模块，持续有新功能和语言的核心支持被加入。随着 NGINX Plus R12 的推出，我们很荣幸的宣布 nginScript 现在已经是一个在 NGINX 和 NGINX Plus 中可被广泛使用的稳定版模块了。

nignScript 是一个只适用于 NGINX 和 NGINX Plus 的 JavaScript 实现，它是专为服务端用例和每次请求处理而设计的。它通过 JavaScript 代码扩展了 NGINX 的配置语法，为复杂配置提供了解决方案。

nignScript 可供 HTTP 和 TCP/UDP 两种协议使用，用例的种类广泛，例如：

- 根据正常情况下 NGINX 变量无法使用的数值，生成自定义的日志格式
- 实现新的负载均衡算法
- 为应用层粘滞会话（sticky sessons）解析 TCP/UDP 协议

当然，nignScript 可以做更多，也有更多可能性有待实现。虽然我们已经宣布 nignScript 能被广泛地应用，并且已经推荐在生产环境使用 nignScript，但我们还有一些在计划中的改良，用来支持更多的用例：

- 查看并修改 HTTP 请求／响应的 body（现已支持 TCP/UDP）
- 在 nginScript 代码中发出 HTTP 子请求（subrequests）
- 给 HTTP 请求写 authentication handlers（现已支持 TCP/UDP）
- 文件读写

在深入讨论 nginScript 之前，我们先澄清一下两个普遍存在的误解。

## nginScript 不是 Lua

多年来，NIGINX 社区创建了一些程序化扩展。目前，Lua 是其中最流行的；使用时，它是一个[ NGINX 模块](https://github.com/openresty/lua-nginx-module)，对于 NGINX Plus 来说，它是一个[经认证的第三方模块](https://www.nginx.com/products/technical-specs/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product)。Lua 模块及其插件库提供了与 NGINX 内核的深度整合和一系列丰富的功能，包括一个 Redis 的驱动程序。

Lua 是一个强大的脚本语言。但是，就采用率来看，它仍是有一定缺陷的。并且，它也不算一个前端工程师或者开发运维工程师必备技能。

nginScript 没有企图取代 Lua，并且 nginScript 还有很长的路要走才能与 Lua 相提并论。nignScript 的目标是给广大 NIGINX 社区的人民群众，提供一个可以基于一种流行的编程语言的、程序化配置的解决方案。

## nginScript 不是 Node.js

nginScript 的目标并不是将 NGINX 或者 NGINX Plus 变成一个应用服务器。简言之，nginScript 的功能相当于中间件，因为脚本的执行是发生于客户端与内容之间的。技术上讲，Node.js 与 nginScript 和 NGINX（或 NGINX Plus）的结合体有两个共同点，那就是[事件驱动的架构](https://www.nginx.com/blog/inside-nginx-how-we-designed-for-performance-scale/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product)，以及，都将 JavaScript 作为编程语言，仅此而已。

Node.js 使用 Google V8 JavaScript 引擎，而 nginScript 则完全是 ECMAScript 标准的实现，专为 NGINX 和 NGINX Plus 设计。Node.js 内置 JavaScript 虚拟机，用来执行垃圾回收和内存管理的操作，而 nginScript 则会对每一个请求都初始化一个 JavaScript 虚拟机和相应的内存空间，并在请求被完成后释放内存空间。

## 作为服务端语言的 JavaScript

如上所述，nginScript 是 JavaScript 语言的标准实现。而目前，所有其他的 JavaScript 运行引擎，都是以运行在网络浏览器为目的而设计的。客户端代码运行与服务端的代码运行有许多本质上的不同 —— 从系统资源的可利用性，到可能存在的并发运行的数量。

我们决定实现自己的 JavaScript runtime，一方面来满足服务端运行的需要，另一方面这种方式可以与 NGINX 请求处理的架构进行优雅适配。以下是我们的设计原则：

- **运行环境与请求有相同的生命周期**

nginScript 使用单线程的字节码执行，这么设计是为了快速的初始化和垃圾清理。对每个请求，都有对应的运行环境被初始化。初始启动是很迅速的，因为初始化没有用到复杂的状态或者帮助类。内存池的消耗在运行的期间逐渐累积，在运行完成的时候被释放。这种内存管理的设计无需为单个对象跟踪和释放内存，或使用垃圾收集器。

- **非阻塞式代码执行**

NGINX 和 NGINX Plus 的事件驱动模式会调度每个 nginScript 运行环境的运行。当一个 nginScript 规则执行一个阻塞操作时（比如读取网络数据，或者发起外部的子请求），NGINX 和 NGINX Plus 会将那个 JavaScript 虚拟机挂起，并在那个操作结束时，重新安排它的运行。这意味着，你可以将规则写的简单、线性，而 NGINX 和 NGINX Plus 在调度它们的时候也不会被阻塞。

- **按照我们的需要实现语言**

JavaScript 的规范是按 [ECMAScript](https://en.wikipedia.org/wiki/ECMAScript) 标准定义的。nginScript 使用 [ECMAScript 5.1](http://www.ecma-international.org/ecma-262/5.1/)，和一部分 [ECMAScript 6](http://www.ecma-international.org/ecma-262/6.0/) 以实现数学相关的功能。实现自己的 JavaScript runtime 让我们能够更自由的调整服务端用例的语言支持的优先级，并忽视掉我们不需要的部分。我们有一个[已经提供支持和尚未提供支持的语言要素的列表](http://nginx.org/en/docs/njs_about.html)。

- **与请求处理阶段的紧密结合**

NGINX 和 NGINX Plus 的请求处理分为不同的阶段。配置指令通常在一个特定的阶段被执行，原生的 NGINX 模块通常会在某个特定阶段，查看或者修改一个请求。nginScript 会将一些处理阶段暴露出去，通过配置指令，将控制权交给运行时的 JavaScript 代码。这种整合配置规则的方式，同时保证了原生 NGINX 模块的功能性和灵活性，并让其 JavaScript 实现代码变得简单。

下面的表格指出了目前可被 nginScript 利用的处理阶段，还有相应的配置指令。

|处理阶段|HTTP 模块|流 (TCP/UDP) 模块|
|------|-------|-------|
|访问 – 网络连接访问控制|❌|✅ [js_access](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_access)|
|预读（Pre-read） – 读／写 body|❌|✅ [js_preread](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_preread)|
|过滤器 – 在代理中读／写 body|❌|✅ [js_filter](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_filter)|
|内容 – 向客户端发送响应|✅ [js_content](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_content)|❌|
|日志/变量 – 应需评估|✅ [js_set](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_set)|✅ [js_set](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#js_set)|

## nginScript 入门 —— 一个真实的例子

nginScript 可以作为一个模块，可以被编译到一个开源的 NGINX 二进制文件里，或者动态地载入 NGINX 或 NGINX Plus。本文的结尾处，有在 NGINX 和 NGINX Plus 中[开始使用 nginScript ](#nginscript-enable)的说明。

在这个例子中，我们使用 NGINX 或 NGINX Plus 作为简单的反向代理，并使用 nginScript 以一种特定的格式构建访问日志记录。

- 包括客户端发来的请求文件头（request headers）
- 包括后端返回的响应文件头（response headers）
- 使用键值对，以便让日志文件处理工具（例如现在被称作 Elastic Stack 的 ELK Stack）高效的搜索和摄入日志记录

这个例子的 NGINX 配置十分简单：

```
Failed loading gist 
https://gist.github.com/49e2f6f6b0a36ed9846dd63cddbd742a.json: timeout
```

如你所见，nginScript 代码与配置规则并不一样。我们用[`js_include`](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_include) 指令来指定包含我们所有的 JavaScript 代码的文件。[`js_set`](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_set) 指令定义了一个新的 NGINX 变量`$access_log_with_headers`，还有填充这个变量所需的 JavaScript 函数。[`log_format`](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format)指令定义了一种名为 **键值对（kvpairs）** 的新格式，它使用`$access_log_with_headers`变量的值输出每一行日志。

[`server`](http://nginx.org/en/docs/http/ngx_http_core_module.html#server)指令定义了一个简单的 HTTP 反向代理，这个反向代理可以将所有的请求转发给一个新地址，例如 **http://www.example.com** 。[`access_log`](http://nginx.org/en/docs/http/ngx_http_log_module.html#access_log)指令可以用来指定所有以 **键值对（kvpairs）** 格式被录入日志的请求。

我们现在来看一下用来准备每一行日志格式的 JavaScript 代码。我们有两个函数：

- `kvHeaders` - 一个将`headers`对象转换为键值对的帮助函数。所有的帮助函数，必须在调用他们的函数前面被声明。
- `kvAccessLog` - 这个函数定义了 NGINX 配置中的 `js_set` 指令。它接收两个对象[参数（arguments）](http://nginx.org/en/docs/http/ngx_http_js_module.html#arguments)，它们分别代表了客户端请求（`req`），与后端服务器的响应（`res`）。像它们这样的内置对象，也可以被传递到所有 HTTP 的 nginScript 函数中。

正如在`kvAccessLog`函数中看到的那样，返回值才会被传递到[`js_set`](http://nginx.org/en/docs/http/ngx_http_js_module.html#js_set)配置指令。要记住， NGINX 变量是应需评估的，这也就意味着被`js_set`定义的 JavaScript 函数只有在变量的值被需要的时候才会执行。在这个例子中，`$access_log_with_headers`被[`log_format`](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format)指令使用，因此`kvAccessLog()`是在输出日志的时候被执行的。而在[`map`](http://nginx.org/en/docs/http/ngx_http_map_module.html#map)指令或者[`rewrite`](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite)指令中被用到的变量，会在更早的处理阶段出发对应的 JavaScript 代码的执行。

我们通过传递一个请求通过我们的反向代理的方式，来观察这种增强版的 nginScript 日志记录解决方案，和它最终产生的日志文件记录。

```
$ curl http://127.0.0.1/
$ tail --lines=1 /var/log/nginx/access_headers.log
2017-03-14T14:36:53+00:00 client=127.0.0.1 method=GET uri=/ status=200 req.Host=127.0.0.1 req.User-Agent=curl/7.47.0 req.Accept=*/* res.Cache-Control=max-age=604800 res.Etag=\x22359670651+ident\x22 res.Expires='Tue, 21 Mar 2017 14:36:53 GMT' res.Last-Modified='Fri, 09 Aug 2013 23:54:35 GMT' res.Vary=Accept-Encoding res.X-Cache=HIT
```

nginScript 的许多功能都来自它访问 NGINX 内部的能力。这个例子使用了一些[请求与响应对象的属性](http://nginx.org/en/docs/http/ngx_http_js_module.html#arguments)。nginScript 针对 TCP 和 UDP 的流模块使用了一个[session 对象和它的属性集](http://nginx.org/en/docs/stream/ngx_stream_js_module.html#properties)。查看我们的博客可以得到更多 nginScript 解决方案的例子。

- HTTP - [使用 nginScript 逐步迁移客户端到新的服务器](https://www.nginx.com/blog/nginscript-progressively-transition-clients-to-new-server/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product)
- 流（Stream） – [Galera 集群负载均衡过程中 SQL 方法的日志记录](https://www.nginx.com/blog/scaling-mysql-tcp-load-balancing-nginx-plus-galera-cluster/?utm_source=introduction-nginscript&amp;utm_medium=blog&amp;utm_campaign=Core+Product#nginscript-logging-galera)

我们会很乐意了解你们想到的 nginScript 用例 - 请在评论里告诉我们。

---

## 在 NGINX 和 NGINX Plus 中开始使用 nginScript

- [给 NGINX Plus 装载 nginScript](#nginscript-nginx-plus-load)
- [给开源 NGINX 装载 nginScript](#nginscript-oss-load)
- [给开源 NGINX 编译动态 nginScript 模块](#nginscript-oss-compile)

### 给 NGINX Plus 装载 nginScript
 
nginScript 是 NGINX Plus 订阅者可以免费使用的[动态模块](https://www.nginx.com/products/dynamic-modules/)（关于开源 NGINX，请参考下面[给开源 NGINX 装载 nginScript](#nginscript-oss-load)的部分。）

1. 从 NGINX Plus repository 获取并安装 nginScript 模块

- Ubuntu 和 Debian 系统使用下面的命令：

```
$ sudo apt‑get install nginx-plus-module-njs
```

- RedHat、CentOS 和 Oracle Linux 系统使用下面的命令：

```
$ sudo yum install nginx-plus-module-njs
```

2. 我们可以在配置文件 **nginx.conf** 的顶级 context 下（"main"）加入一条配置指令[`load_module`](http://nginx.org/en/docs/ngx_core_module.html#load_module)，用来给 HTTP 流量加载 nginScript 模块（注意不是在 http 或者 stream 的 context 下）：

```
load_module modules/ngx_http_js_module.so;
```

3. 重新加载 NGINX Plus，将 nginScript 模块载入到正在运行的实例中。

```
$ sudo nginx -s reload
```

### 给开源 NGINX 装载 nginScript

如果你的系统配置了官方的[开源 NGINX 预建包（pre‑built packages）](http://nginx.org/en/linux_packages.html#mainline)，并且你安装的版本在 1.9.11 或以上，你可以直接将 nginScript 安装为平台的预建包（pre‑built packages）。

1. 安装预建包（pre‑built packages）

- Ubuntu 和 Debian 系统使用下面的命令：

```
$ sudo apt-get install nginx-module-njs
```

- RedHat、CentOS 和 Oracle Linux 系统使用下面的命令：

```
$ sudo yum install nginx-module-njs
```

2. 我们可以在配置文件 **nginx.conf** 的顶级 context 下（"main"）加入一条配置指令[`load_module`](http://nginx.org/en/docs/ngx_core_module.html#load_module)，用来给 HTTP 流量加载 nginScript 模块（注意不是在 http 或者 stream 的 context 下）：

```
load_module modules/ngx_http_js_module.so;
```

3. 重新加载 NGINX Plus，将 nginScript 模块载入到正在运行的实例中。

    $ sudo nginx -s reload

### 给开源 NGINX 编译动态 nginScript 模块

如果你更喜欢直接从源代码编译出一个 NGINX 模块：

1. 跟随 [这些操作说明](https://www.nginx.com/blog/compiling-dynamic-modules-nginx-plus/)，使用[开源 repository ](http://hg.nginx.org/njs/)构建 nginScript 模块。
2. 将这个模块的二进制文件(**ngx_http_js_module.so**)拷贝到 NGINX 根目录（通常是 **/etc/nginx/modules**）下的 **modules** 子目录下。
3. 完成 [给开源 NGINX 装载 nginScript ](#nginscript-oss-load&quot;)的第二步和第三步。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
