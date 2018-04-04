> * 原文地址：[10x Performance Increases: Optimizing a Static Site](https://hackernoon.com/optimizing-a-static-site-d5ab6899f249)
> * 原文作者：[JonLuca De Caro](https://hackernoon.com/@jonluca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-a-static-site.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-a-static-site.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[dandyxu](https://github.com/dandyxu)、[Hopsken](https://github.com/Hopsken)

# 提高 10 倍性能：优化静态网站

几个月前，我在国外旅行，想给朋友看我个人（静态）网站上的一个链接。我试着浏览我的网站，但花费的时间比我预期的要长。网站绝对没有任何动态内容--只有动画和一些响应式设计，而且内容始终保持不变。 我对结果感到震惊，DOMContentLoaded 要 4 s，整个页面加载要 6.8 s。有 20 项关于**静态网站**的请求（总数据的 1MB）被转移。我习惯了从洛杉矶到我在旧金山的服务器之间用 1 GB/s 的低延迟互联网连接，这使得这个怪物看起来像闪电一样快。在意大利，8 MB/s 的速度让情况变得完全不同。

![](https://cdn-images-1.medium.com/max/800/1*OgqdIBjziyfhE_tbip24ww.png)

这是我第一次尝试优化。到目前为止，每次我想添加一个库或者资源时，我都只是将它引入并使用 **src=""** 指向它。从缓存到内联，再到延迟加载，对任何形式的性能我都没有给予关注。

我开始寻找有相似经历的人。不幸的是，许多有关静态优化的文献很快就过时--那些来自 2010 或者 2011 年的建议，要么是在讨论库，要么做一些根本不再试用的假设，要么就是不断地重复某些相同的准则。

不过我确实找到了两个很好的信息源 -- [高性能浏览器网络](https://hpbn.co)和 [Dan Luu 类似的静态网站优化经历](https://danluu.com/octopress-speedup/)。尽管在剥离格式和内容方面还不如 Dan，但是我确实成功地让我的页面加载速度提高了大约 10 倍。DOMContentLoaded 大约需要五分之一秒，而整个页面加载只有 388 ms（实际上有点不准确，下文将解释延迟加载的原因）。

![](https://cdn-images-1.medium.com/max/800/1*OBt9rTFK8KhlnPI1-olkmg.png)

### 过程

过程的第一步是对网站进行分析梳理，我想弄清楚哪些地方花费了最长的时间，以及如何最好地并行化一切。我运行了各种工具来分析我的网站，并在世界各地测试它，包括：

*   [https://tools.pingdom.com/](https://tools.pingdom.com/)
*   [www.webpagetest.org/](http://www.webpagetest.org/)
*   [https://tools.keycdn.com/speed](https://tools.keycdn.com/speed)
*   [https://developers.google.com/web/tools/lighthouse/](https://developers.google.com/web/tools/lighthouse/)
*   [https://developers.google.com/speed/pagespeed/insights/](https://developers.google.com/speed/pagespeed/insights/)
*   [https://webspeedtest.cloudinary.com/](https://webspeedtest.cloudinary.com/)

其中一些提供了改进建议，但当静态站点有 50 个请求时，您只能做这么多 -- 从 90 年代遗留下来的间隔 gif 到不再使用的资源（我加载了 6 种字体但只使用了 1 种字体）。

![](https://cdn-images-1.medium.com/max/800/1*61ngDdpQfLqBo-I8F_tuqw.png)

我的网站时间线 -- 我在 Web Archive(译者注：一家提供网站历史快照的服务商)上测试了这个却没有截取原始图片，可是它看起来和我几个月前看到的还是很相似。

我想改进我所能控制的一切 -- 从 JavaScript 的内容和速度到实际的 Web 服务器（Ngnix）和 DNS 设置。 

### 优化

#### 简化与合并资源

我注意到的第一件事是，不管是对于 CSS 还是 JS，我都向各种网站发起十几个请求（没有任何形式的 HTTP keepalive），其中还有一些是 https 请求。这增加了对各种 CDN 或 服务器的多次往返，一些 JS 文件正在请求其他文件，这导致了上面所示的阻塞级联。

我使用 [webpack](https://webpack.js.org/) 将所有资源合并到一个 js 文件中。每当我对内容进行更改时，它都会自动简化并将我的所有依赖项转换为单文件。

```
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const ZopfliPlugin = require("zopfli-webpack-plugin");

module.exports = {
  entry: './js/app.js',
  mode: 'production',
  output: {
    path: __dirname + '/dist',
    filename: 'bundle.js'
  },
  module: {
    rules: [{
      test: /\.css$/,
      loaders: ['style-loader', 'css-loader']
    }, {
      test: /(fonts|images)/,
      loaders: ['url-loader']
    }]
  },
  plugins: [new UglifyJsPlugin({
    test: /\.js($|\?)/i
  }), new ZopfliPlugin({
    asset: "[path].gz[query]",
    algorithm: "zopfli",
    test: /\.(js|html)$/,
    threshold: 10240,
    minRatio: 0.8
  })]

};
```

我尝试了各种不同的配置。现在，这个 bundle.js 文件在我网站的 `<head>` 中，并且处于阻塞状态。它的最终大小是 829 kb，包括每个非图像资源（字体、css、所有的库、依赖项以及 js）。绝大多数字体使用的是 font-awesome，它们占 829 kb 中的 724。

我浏览了 Font Awesome 库，除了我要使用的 fa-github、fa-envelope 和 fa-code 三个图标外，其他的所有图标都已经删除。我使用叫做 [fontello](http://fontello.com/) 的服务来提取我需要的图标。新的大小只有 94 kb。

按照目前网站的构建方式，如果我们只有样式表，它看起来是不正确的，所以我接受了单个 bundle.js 的阻塞特性。加载时间为 118 ms，比之前提高了一个数量级。

这也带来了一些额外的好处--我不再指向第三方资源或 CDN，因此用户不需要：（1）执行对该资源的 DNS 查询，（2）执行 https 握手，（3）等待该资源被完整地下载。

虽然 CDN 和分布式缓存对于大规模的分布式网站可能是有意义的，但对于我的小型静态网站来说却没有意义。是否需要优化这额外的 100 ms 左右时间是值得权衡的。

#### 压缩资源

我加载了一个 8 MB 大小的头像，然后以 10% 的宽高比显示它。这不仅仅是缺少优化，这几乎**是忽略了用户对带宽使用**。

![](https://cdn-images-1.medium.com/max/800/1*h79KSROW3oY6KWfQm6u5yA.png)

我使用 [https://webspeedtest.cloudinary.com/](https://webspeedtest.cloudinary.com/) 来压缩所有的图像 -- 它还建议我切换到  [webp](https://developers.google.com/speed/webp/)，但我希望尽可能多的与其他浏览器进行兼容，所以我坚持使用 jpg。尽管完全有可能建立一个只将 webp 交付给支持它的浏览器系统，但我希望尽可能地保持简单，添加抽象层的好处似乎并不明显。

#### 改进 Web Server — HTTP2, TLS 等

我做的第一件事是过度到 https -- 一开始，我在 80 端口运行 Ngnix，只服务于来自 /var/www/html 的文件。

```
server{
    listen 80;
    server_name jonlu.ca www.jonlu.ca;

    root /var/www/html;
    index index.html index.htm;
    location ~ /.git/ {
          deny all;
    }
    location ~ / {
        allow all;
    }
}
```

首先设置 https 并将所有 http 请求重定向到 https。我从 [Let’s Encrypt](https://letsencrypt.org/) (一个刚开始签署通配符证书的伟大组织！[wildcard certificates](https://community.letsencrypt.org/t/acme-v2-and-wildcard-certificate-support-is-live/55579) )那里获得了自己的 TLS 证书。

```
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name jonlu.ca www.jonlu.ca;

    root /var/www/html;
    index index.html index.htm;

    location ~ /.git {
        deny all;
    }
    
    location / {
        allow all;
    }

    ssl_certificate /etc/letsencrypt/live/jonlu.ca/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/jonlu.ca/privkey.pem; # managed by Certbot
}
```

只要添加 http2 的指令，Ngnix 就能够利用 HTTP 最新特性的所有优点。注意，如果要利用 HTTP2（以前的 SPDY），您**必须**使用 HTTPS，在[这里](https://hpbn.co/http2/)阅读更多内容。

您还可以利用 HTTP2 push 指令，使用 **http2** push images/Headshot.jpg；

注意：启用 gzip 和 TLS 可能会使您面临 [BREACH](https://en.wikipedia.org/wiki/BREACH) 风险。由于这是一个静态网站，而 BREACH 实际的风险很低，所以保持压缩状态让我感觉舒服。

#### 利用缓存和压缩指令

仅通过使用 Ngnix 还能完成什么呢？首先是缓存和压缩指令。

我之前一直都是发送未经压缩的原始 HTML。只需要一个单独的 **gzip**；是的，我就可以从 16000 字节减少到 8000 字节，减少 50%。

实际上，我们能够进一步改进这个数字，如果将 Ngnix 的 **gzip** 静态设置为开启，它会事先查找所有请求文件的预压缩版本。这与我们上面的 webpack 配置结合在一起 -- 我们可以在构建时使用 [ZopflicPlugin](https://github.com/webpack-contrib/zopfli-webpack-plugin) 预压缩所有文件！这节省了计算资源，并允许我们在不牺牲速度的情况下最大限度地实现压缩。

此外，我的站点变化很少，所以我希望尽可能长时间地缓存资源。这样，在以后的访问中，用户就不需要重新下载所有资源（特别是 bundle.js）。

我更新的服务器配置如下所示。请注意，我不会涉及我所做的所有更改，例如 TCP 设置更改、gzip 指令和文件缓存。如果您想了解更多，请[阅读这篇关于 Ngnix 调优的文章](https://www.nginx.com/blog/tuning-nginx/)。

```
worker_processes auto;
pid /run/nginx.pid;
worker_rlimit_nofile 30000;

events {
    worker_connections 65535;
    multi_accept on;
    use epoll;
}

http {

    ##
    # Basic Settings
    ##

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    # Turn of server tokens specifying nginx version
    server_tokens off;

    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    add_header Referrer-Policy "no-referrer";

    ##
    # SSL Settings
    ##

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_dhparam /location/to/dhparam.pem;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';

    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload';

    ssl_certificate /location/to/fullchain.pem;
    ssl_certificate_key /location/to/privkey.pem;

    ##
    # Logging Settings
    ##

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    ##
    # Gzip Settings
    ##

    gzip on;
    gzip_disable "msie6";

    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;
    gzip_min_length 256;

    ##
    # Virtual Host Configs
    ##

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

以及相应的服务器块

```
server {
    listen 443 ssl http2;

    server_name jonlu.ca www.jonlu.ca;

    root /var/www/html;
    index index.html index.htm;

    location ~ /.git/ {
        deny all;
    }

    location ~* /(images|js|css|fonts|assets|dist) {
        gzip_static on; # 告诉 Nginx 首先查找所有请求文件的压缩版本。
        expires 15d; # 15 day expiration for all static assets
    }

}
```

#### 延迟加载

最后我的实际网站有一个小的变化，它所带来的优化是不可忽视的。有 5 张图片直到您按下相应选项卡后才能看到，但它们是与其他所有内容同时加载的（因为它们位于 `<img src=”…”>` 标签中）。

我编写了一个简短的脚本，用 **lazyload 类**修改每个元素的属性。只有单击相应的框后才会加载这些图像。

```
$(document).ready(function() {
    $("#about").click(function() {
        $('#about > .lazyload').each(function() {
            // set the img src from data-src
            $(this).attr('src', $(this).attr('data-src'));
        });
    });

    $("#articles").click(function() {
        $('#articles > .lazyload').each(function() {
            // set the img src from data-src
            $(this).attr('src', $(this).attr('data-src'));
        });
    });

});
```

因此一旦文档完成加载，它将修改 `<img>` 标签，使他们从 `<img data-src=”…”>` 转到 `<img src=”…”>` 然后将其加载到后台。

#### 未来的改进

还有一些其他的更改可以提高页面加载速度 -- 最显著的是使用 Service Workers 缓存并拦截所有请求，让站点甚至脱机运行，在 CDN 上缓存内容，这样用户就不需要在 SF 中对服务器进行完整的往返操作。这些都是有价值的改变，但对于个人静态网站来说并不是特别重要，因为它是一个在线简历（关于我）的页面。

### 结论

这使我的页面加载时间从第一次加载的 8 s 提高到 350 ms，之后的页面加载速度达到了 200 ms。我真的建议阅读[高性能浏览器网络](https://hpbn.co/#toc) -- 您可以很快就阅读完它，它提供了对现代互联网的一个非常好的概述，并在互联网模型的每一层都进行了优化。

**我遗漏了什么事情吗？是否有任何违反最优做法？或者可以改善我的叙述内容甚至是其他方面？请随时指正 --** [_JonLuca De Caro_](https://medium.com/@jonluca)**！**

![](https://cdn-images-1.medium.com/max/800/1*PZjwR1Nbluff5IMI6Y1T6g@2x.png)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
