
> * 原文地址：[Switching Your Site to HTTPS on a Shoestring Budget](https://css-tricks.com/switching-site-https-shoestring-budget/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[CHRISTOPHER SCHMITT](https://css-tricks.com/author/schmitt/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/switching-site-https-shoestring-budget.md](https://github.com/xitu/gold-miner/blob/master/TODO/switching-site-https-shoestring-budget.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[ahonn](https://github.com/ahonn), [Cherry](https://github.com/sunshine940326)

# 低成本将你的网站切换为 HTTPS

Google 的 Search Console 小组最近向所有站长发了一封 email，警告 Google Chrome 将从 10 月起，在包含表单但没有使用安全措施的网站中显示警告信息。

下图为我收件箱里的通知：

![图为 Google Search Console 团队发来的关于 HTTPS 支持的通知](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_610,f_auto,q_auto/v1504368007/https-google-letter_h3h2a7.jpg)

如果你的网站还不支持 HTTPS，那这个通知就直接与你相关。即使你的网站并没有用到表单，也应当早日将网站迁移为 HTTPS。因为现在这项措施只不过是 Google“标识非安全网站”策略的第一步。他们在消息中明确表示：

> 这个新的警告仅仅是将所有通过 HTTP 提供服务的页面标记为“不安全”的长期计划的一部分。

![当前 Chrome 用以表示支持 HTTP 的站点以及支持 HTTPS 站点的 UI 设计](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_401,f_auto,q_auto/v1504414046/chrome-http-secure-ui-v2_g208mc.png)

问题在于：安装 SSL 证书、将网站 URL 从 HTTP 转换为 HTTPS、以及将所有链接和图像链接等都换成 HTTPS 并不是一项简单的任务。谁会为了自己的个人网站去费时费钱呢？

我使用 GitHub Pages 免费托管了一系列的网站和项目，其中的一部分还使用了自定义域名。因此，我想看看我能否快速、低成本地将这些网站从 HTTP 迁移为 HTTPS。最后我找到了一种相对简单且低成本的方案，希望能够帮助到你们。下面让我们来探究一下这种方法吧。

## 对 GitHub Pages 强制启用 HTTPS

托管在 GitHub Pages 上的网站可以通过设置很方便地启用 HTTPS。进入项目设置页面，勾上“Enforce HTTPS”即可。

![在 GitHub Pages 设置中启用项目的 HTTPS 支持](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_789,f_auto,q_auto/v1504368069/https-github-pages_iekrru.png)

## 但我们仍然需要 SSL

第一步十分的简单，但它并不符合 Google 对安全网站定义的要求。我们启用了 HTTPS 设置，但是没有为使用[自定义域名](https://help.github.com/articles/using-a-custom-domain-with-github-pages/)的网站安装、提供 SSL 证书。直接使用 GitHub Pages 提供的网址的站点已经完全符合要求了，但是使用自定义域名的站点必须要进行一些额外的步骤，让其在域名的层面上使用安全证书。

还有个问题，SSL 证书虽然并不贵，但也需要花一笔钱，在你尽可能希望降低成本时可不想为此增加花费。所以得找个办法解决这个问题。

## 我们可以通过 CDN 免费试用 SSL！

在这儿就不得不提 Cloudflare 了。Cloudflare 是一个内容分发网络（CDN）提供商，同时它也提供分布式域名服务，这也意味着我们可以利用他们的网络来设置 HTTPS。使用这个服务真正的好处在于他们提供了免费的方案，让这一切成为可能。

另外，值得一提的是在 CSS-Tricks 论坛里也有[许多帖子](https://css-tricks.com/?s=cdn)描述了使用 CDN 的好处。虽然这篇文章中主要探讨的是安全性问题，但其实 CDN 除了能帮你使用 HTTPS 之外，还是降低服务器负载、[提升网站性能](https://css-tricks.com/adding-a-cdn-to-your-website/)的绝佳方式。

在下文中，我将简述我使用 Cloudflare 连接 Github Pages 的步骤。如果你还没有 Cloudflare 账号，你可以[点击这儿注册账号](https://www.cloudflare.com/a/sign-up)再跟着步骤操作。

### 第一步：选择“+ Add Site”选项

首先，我们需要告诉 Cloudflare 我们使用的域名。Cloudflare 将会扫描 DNS 记录，以验证域名是否存在，并检查域名的公开信息。

![Cloudflare 的“Add Website”设置](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_992,f_auto,q_auto/v1504368119/https-cloudflare-add-website_m8cxbg.png)

### 第二步：查看 DNS 记录

Cloudflare 扫描 DNS 记录后会将结果展示出来供你查看。如果 Cloudflare 认为这些信息符合要求，就会在“Status”列中显示一个橙色的云的图标。你需要检查这份报告，确认其中的信息与你在域名注册商中留的信息相符，如果没问题的话，点击“Continue”按钮继续。

![Cloudflare 给出的 DNS 记录报告](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_959,f_auto,q_auto/v1504368181/https-cloudflare-nameservers_yvfca2.png)

### 第三步：获取免费方案

Cloudflare 会询问你需要哪种级别的服务。瞧~你可以在这儿选择“免费”选项。

![Cloudflare 的免费方案选项](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_997,f_auto,q_auto/v1504368222/https-cloudflare-free-plan_oxgbp0.png)

### 第四步：更新域名解析服务器（NS 服务器）

这一步中，Cloudflare 给我们提供了其服务器地址，我们要做的就是将这个地址粘贴到自己的域名注册商中的 DNS 设置里。

![在域名注册商设置中使用 Cloudflare 提供的域名解析服务器](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_976,f_auto,q_auto/v1504368295/https-cloudflare-nameservers-2_yhr2up.jpg)

这一步其实并不困难，但你可能会有些疑惑。你的域名注册商可能会提供这一步的操作指南。例如[点此查看 GoDaddy 的指南](https://www.godaddy.com/help/set-nameservers-for-domains-hosted-and-registered-with-godaddy-12316)，了解如何通过他们的服务更新域名解析服务器。

完成这一步之后，你的域名将会很快被映射到 Cloudflare 的服务器上，这些服务器将成为域名与 Github Pages 之间的中间层。不过，这一步需要耗费一些时间，Cloudflare 可能需要 24 小时来处理这个请求。

**如果你没有用主域名，而是用了子域名来使用 GitHub Pages**，则需要额外进行一步操作。打开你的 GitHub Pages 设置页面，在 DNS 设置中添加一条 CNAME 记录，设置它指向 `<your-username>.github.io`，其中 `<your-username>` 是你的 Github 账号。此外，你需要在 GitHub 项目的根目录下添加一个文件名为 CNAME 的无后缀名文本文档，其内容为你的域名。

下面的屏幕截图为在 Cloudflare 设置中将 GitHub Pages 子域名添加为 CNAME 记录的例子：

![将 GitHub Pages 子域名加入 Cloudflare](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_985,f_auto,q_auto/v1504368357/https-cloudflare-github-pages-subdomain_mtnvep.png)

### 第五步：在 Cloudflare 中启用 HTTPS

现在，我们从技术上说已经为 GitHub Pages 启用了 HTTPS，但是我们还需要在 Cloudflare 中做同样的事。Cloudflare 把这个功能称为“Crypto”，不仅强制开启了 HTTPS，还提供了我们梦寐以求的 SSL 证书。现在先让我们为 HTTPS 启用 Crypto，之后的步骤中我们会获取到证书的。

![Cloudflare 主菜单中的 Crypto 选项](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_581,f_auto,q_auto/v1504368403/https-cloudflare-crypto_y44ged.png)

开启“Always use HTTPS”选项：

![在 Cloudflare 设置中开启 HTTPS](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_954,f_auto,q_auto/v1504368456/https-cloudflare-enable_e5povd.png)

此时，任何来自浏览器的 HTTP 请求都会被切换成更安全的 HTTPS。我们离“取悦” Google Chrome 又进了一步。

### 第六步：使用 CDN

我们现在正在用 CDN 来获取 SSL 证书，所以我们还可以利用它的性能优势来得到更多的好处。我们可以通过自动压缩文件、延长浏览器缓存过期时间来提升网站性能。

选择“Speed”选项，允许 Cloudflare 自动压缩网站资源：

![允许 Cloudflare 自动压缩网站资源](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_983,f_auto,q_auto/v1504368507/https-cloudflare-minify_dzk1a4.png)

我们还可以通过设置浏览器缓存过期时间来最大化地提升性能：

![在 Cloudflare 的 Speed 设置中指定浏览器缓存](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_972,f_auto,q_auto/v1504368548/https-cloudflare-cache_diayym.png)

将过期时间设置为比默认选项更长，可以让浏览器在访问网站时不再需要每次都去请求那些没有变更过的网站资源。这将让访客在一个月内再次访问你的网站时节省额外的下载量。

### 第七步：使用安全的外部资源

如果你的网站还使用了一些外部资源（我们很多人都这么做），那么还需要确保这些外部资源是安全的。例如，如果你使用了一个 Javascript 框架，但没有使用 HTTPS 源，那么 Google Chrome 将会认为其降低了我们网站的安全性，因此我们需要对其进行改进。

如果你使用的外部资源不提供 HTTPS 源，那么你可以考虑自己对其进行托管。反正我们现在已经有了 CDN，做托管服务的负载并不成问题。

### 第八步：激活 SSL

已经做到这一步啦！我们已经在 GitHub Pages 设置中开启了 HTTPS，现在还缺少自定义域名与 GitHub Pages 的连接证书。Cloudflare 提供了免费的 SSL 证书，我们可以在网站中使用它。

打开 Cloudflare 的 Crypto 设置页面，确认 SSL 证书处于激活状态：

![Cloudflare 的 Crypto 设置中显示 SSL 证书为激活状态](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_954,f_auto,q_auto/v1504368600/https-cloudlfare-ssl_nbbkyy.png)

如果证书处于激活状态，在主菜单中切换到“Page Rules”页面，选择“Create Page Rule”选项：

![在 Cloudflare 设置中创建页面规则](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_962,f_auto,q_auto/v1504368647/https-cloudflare-page-rule_hzmbvv.png)

然后点击“Add a Setting”，选择“Always use HTTPS”选项：

![对整个域名都强制使用 HTTPS！注意图中文本中的星号很重要](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_797,f_auto,q_auto/v1504368689/https-cloudflare-force-https_vgouyf.png)

点击“Save and Deply”，恭喜你！现在，我们拥有了一个在 Google Chrome 眼中完全安全的网站，并且在迁移的过程中我们并不需要接触、修改很多代码。

## 总结

Google 这样推进 HTTPS 意味着前端开发者们在开发自己的网站、公司网站、客户网站的时候需要优先考虑 SSL 支持。这一举措将会促使我们将站点向 HTTPS 迁移。而使用 CDN 可以让我们使用免费的 SSL 并提升网站性能，如此超值的事何乐而不为呢？

你记录过迁移到 HTTPS 的经历吗？在评论里留言你的迁移方法，让我们相互对比吧。

享受你的既安全又快速的网站吧！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
