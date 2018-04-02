> * 原文地址：[10x Performance Increases: Optimizing a Static Site](https://hackernoon.com/optimizing-a-static-site-d5ab6899f249)
> * 原文作者：[JonLuca De Caro](https://hackernoon.com/@jonluca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-a-static-site.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-a-static-site.md)
> * 译者：
> * 校对者：

# 10x Performance Increases: Optimizing a Static Site

A couple months ago, I was traveling outside of the U.S. and wanted to show a friend a link on my personal (static) site. I tried navigating to my website, but it took much longer than I anticipated. There’s absolutely nothing dynamic about it — it has animations and some responsive design, but the content always stays the same. I was pretty appalled at the results, ~4s to DOMContentLoaded, and 6.8s for a full page load. There were 20 requests for a _static site_, with 1mb of total data transferred. I was accustomed to my 1Gb/s, low latency internet in Los Angeles connecting to my server in San Francisco, which made this monstrosity seem lightning fast. In Italy, at 8mb/s, it was a different picture entirely.

![](https://cdn-images-1.medium.com/max/800/1*OgqdIBjziyfhE_tbip24ww.png)

This was my first foray into optimizations. Up to this point, any time I wanted to add a library or resource, I would just throw it in and point to it with _src=”…”_. I had paid zero attention to any form of performance, from caching to inlining to lazy loading.

I started looking around for people with similar experiences. Unfortunately, a lot of the literature on static optimizations gets dated fairly quickly — recommendations from 2010 or 2011 discussed libraries or made assumptions that simply weren’t true anymore, or just repeated the same maxims over and over.

However, I did find two great sources of information — [High Performance Browser Networking](https://hpbn.co) and [Dan Luu’s similar experience with optimizing static sites](https://danluu.com/octopress-speedup/). While I didn’t go as far as Dan in stripping formatting and content, I did manage to get my page load to be roughly 10x faster, to about a fifth of a second for DOMContentLoaded and only 388ms for full page load (which is actually a little inaccurate, as it tacks on the lazy loading explained below).

![](https://cdn-images-1.medium.com/max/800/1*OBt9rTFK8KhlnPI1-olkmg.png)

### The Process

The first step of the process was to profile the site. I wanted to figure out what was taking the longest, and how to best parallelize everything. I ran various tools to profile my site and test it from various locations around the world, including:

*   [https://tools.pingdom.com/](https://tools.pingdom.com/)
*   [www.webpagetest.org/](http://www.webpagetest.org/)
*   [https://tools.keycdn.com/speed](https://tools.keycdn.com/speed)
*   [https://developers.google.com/web/tools/lighthouse/](https://developers.google.com/web/tools/lighthouse/)
*   [https://developers.google.com/speed/pagespeed/insights/](https://developers.google.com/speed/pagespeed/insights/)
*   [https://webspeedtest.cloudinary.com/](https://webspeedtest.cloudinary.com/)

Some of these offered suggestions on improvements, but there’s only so much you can do when your static site has 50 requests — everything from a spacer gif left as a remnant from the 90s to assets that aren’t used (I was loading 6 fonts and only using 1).

![](https://cdn-images-1.medium.com/max/800/1*61ngDdpQfLqBo-I8F_tuqw.png)

Timeline for my site — I tested this on the Web Archive as I didn’t screenshot the original one, but it looks similar enough to what I saw a few months ago.

I wanted to improve everything that I had control over — from the contents and speed of the javascript to the actual web server (Nginx) and DNS settings.

### Optimizations

#### Minify and Coalesce Resources

The first thing I noticed was that I was making a dozen requests each for CSS and JS (without any form of HTTP keepalive), and to various sites, some of which were https. This added multiple round trips to various CDNs or servers, and some JS files were requesting others, which caused the blocking cascade seen above.

I used [webpack](https://webpack.js.org/) to coalesce all my resources into a single js file. Any time I make a change to my content, it automatically minifies and turns all my dependencies into a single file.

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

I played around with different options — currently, this single bundle.js file is in the `<head>` of my site, and is blocking. It’s final size is 829kb, and that includes every single non-image asset (fonts, css, all libraries and dependencies, and js). The vast majority of this is are the font-awesome fonts, which make up 724 of the 829kb.

I went through the Font Awesome library and stripped all but the three icons I was using — fa-github, fa-envelope, and fa-code. I used a service called [fontello](http://fontello.com/) to only pull the icons I needed. The new size was just 94kb.

The way the site is currently built, it won’t look correct if we only have stylesheets, so I accepted the blocking nature of a single bundle.js. Load times are ~118ms, which is more than an order of magnitude better than above.

This also had a few added benefits — I was no longer pointing to 3rd party resources or CDNs, so the user would not need to 1) perform a DNS query to that resource, 2) Perform the https handshake, and 3) actually wait for the full download from that resource.

While CDNs and distributed caching might make sense for large scale, distributed sites, it does not make sense for my small static site. The additional hundred milliseconds or so are a worthwhile tradeoff.

#### Compress Resources

I was loading an 8mb sized headshot and then displaying it at 10% width/height. This wasn’t just a lack of optimization — this was _almost negligent usage of users bandwidth_.

![](https://cdn-images-1.medium.com/max/800/1*h79KSROW3oY6KWfQm6u5yA.png)

I compressed all my images using [https://webspeedtest.cloudinary.com/](https://webspeedtest.cloudinary.com/) — it also suggested I switch to [webp](https://developers.google.com/speed/webp/), but I wanted to remain as compatible with as many browsers as possible, so I stuck to jpg. It’s possible to set up a system in which webp only gets delivered to browsers that support it, but I wanted to remain as simple as possible, and the benefits for that added layer of abstraction did not seem worth it.

#### Improve Web Server — HTTP2, TLS, and More

The first thing I did was transition to https — when I started, I was running Nginx bare on port 80, just serving files from /var/www/html

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

I started by setting up https and redirecting all http requests to https. I got my TLS certificate from [Let’s Encrypt](https://letsencrypt.org/) (an great organization that just started signing [wildcard certificates](https://community.letsencrypt.org/t/acme-v2-and-wildcard-certificate-support-is-live/55579) as well!).

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

Just by adding the http2 directive, Nginx was able to take advantage of all the modern, baked in advantages of the newest HTTP features. Note that if you want to take advantage of HTTP2 (previously SPDY), you _must_ use HTTPS. Read more about it [here](https://hpbn.co/http2/).

You can also take advantage of HTTP2 push directives with _http2_push images/Headshot.jpg;_

Note: Enabling gzip and TLS might put you at risk for [BREACH](https://en.wikipedia.org/wiki/BREACH). As this is a static site, and the actual risks for BREACH are fairy low, I felt comfortable keeping compression on.

#### Utilize Caching & Compression Directives

What more could be accomplished through just Nginx? The first things that jump out are caching and compression directives.

I was sending raw, uncompressed HTML. With just a single _gzip on;_ line, I was able to go from 16000 bytes to 8000 bytes, a decrease of 50%.

We are actually able to improve this number even further — if set Nginx’s _gzip_static on,_ it’ll look for precompressed versions of all requested files before hand. This goes hand in hand with our webpack config above — we can use the [ZopflicPlugin](https://github.com/webpack-contrib/zopfli-webpack-plugin) to precompress all our files, at build time! This saves computational resources, and allows us to maximize our compression with no tradeoff to speed.

Additionally, my site changes fairly infrequently, so I wanted the resources to be cached for as long as possible. This would make it so that, on subsequent visits, users would not need to redownload all assets (especially bundle.js).

My updated server config looks like this. Note that I won’t touch on all the changes I made, such as TCP settings changes, gzip directives, and file cache. If you’d like to know more about these, [read this article on tuning Nginx.](https://www.nginx.com/blog/tuning-nginx/)

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

And the corresponding server block

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
        gzip_static on; # Tells nginx to look for compressed versions of all requested files first
        expires 15d; # 15 day expiration for all static assets
    }

}
```

#### Lazy Loading

Lastly there was a small change to my actual site that would improve things by a non-negligible amount. There are 5 images that aren’t seen until you press on their corresponding tabs, but that were loaded at the same time as everything else (due to their being in a `<img src=”…”>` tag.

I wrote a short script to modify the attribute with every element with the _lazyload class._ These images would only be loaded once the corresponding box was clicked.

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

So once the document had completed loading, it would modify the `<img>` tags so that they went from `<img data-src=”…”>` to `<img src=”…”>`, and load it in the background.

#### Future Improvements

There are a few other changes that could improve the page load speeds — most notably, using Service Workers to cache and intercept all requests, and have the site operate even offline, and caching content on CDNs so that users do not need to do a full round trip to the server in SF. These are worthwhile changes, but not particularly important for a personal static site that serves as an online resume/about me page.

### Conclusion

This improved my page load times from more than 8 seconds to ~350ms on first page load, and an insane ~200ms on subsequent ones. I really recommend reading through all of [High Performance Browser Networking](https://hpbn.co/#toc) — it’s a fairly quick read, and provides an incredibly well written overview of the modern internet, and optimizing at every layer of the modern internet model.

_Did I miss anything? See anything that violates best practices or that could improve my performance even more? Feel free to reach out — _[_JonLuca De Caro_](https://medium.com/@jonluca)_!_

![](https://cdn-images-1.medium.com/max/800/1*PZjwR1Nbluff5IMI6Y1T6g@2x.png)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
