
> * 原文地址：[A beginner’s guide to making Progressive Web Apps](https://medium.com/samsung-internet-dev/a-beginners-guide-to-making-progressive-web-apps-beb56224948e)
> * 原文作者：[uve](https://medium.com/@uveavanto)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-beginners-guide-to-making-progressive-web-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-beginners-guide-to-making-progressive-web-apps.md)
> * 译者：[Haichao Jiang](https://github.com/AceLeeWinnie)
> * 校对者：[sun](https://github.com/sunui) [leviding](https://github.com/leviding) 

# 构建渐进式 Web 应用入门指南

你可能已经听过渐进式 Web 应用或 PWA 的大名，然而我并不打算深入 PWA 的构建和工作细节。这篇文章的目的在于说明 **PWA 是一个可以添加到手机主屏幕的网页**，并且它还能够离线运行。

![](https://cdn-images-1.medium.com/max/800/1*2le_ZVx-FUCsK4oCXKcpqg.jpeg)


我知道一些 HTML、CSS、JavaScript 的知识并且了解如何使用 GitHub。

我是 web 开发新手，当下也不想学习 Web 开发的原理和工作机制。我希望有一个简单、基础的方式做出一些东西，而不用连篇累牍地阅读文档和教程。**希望通过这篇文章你会学到所有在开始构建 PWA 时需要的知识。**

要做 PWA 首先要有一个网站。当然，本文假定你已经可以制作多端适配的网站。幸运的是我们不需要通过 scratch 才能做到，我们可以使用模板。我喜欢使用 [HTML5 UP](https://html5up.net/) 和 [Start Bootstrap](https://startbootstrap.com/)。

选择并下载主题，把 index.html 中的所有内容替换成你自己的。如果你对编辑 CSS 有把握的话，你甚至可以更改颜色。

在这个项目里，我为 Web Community Leads UK and IE 组织制作了一个登录页。你可以通过阅读 [Daniel](https://medium.com/@torgo) 的[相关博客](https://medium.com/samsung-internet-dev/web-communities-for-the-people-6440e0c8e543)读到更多内容，或者访问我做的网站 [https://webcommunityukie.github.io/](https://webcommunityukie.github.io/)。

把这个网站做成 PWA 并没有为大多数用户带来更多体验，同时我也不希望每个人都把它加入主屏幕，但是它仍然优化了体验。我只是想要一个小网站来开启自己制作 PWA 之旅。

我真的想要一个简单的网站，我喜欢 [Hacksmiths](http://goldsmiths.tech/) 并且知道它是开源的，所以我下载下来并且消化了源码。我保留了一个链接在下方，指向原网页和源码，人们可以 folk 出一个新网站。

现在我们有个网站了，可以把它变成一个渐进式 web 应用。为了达到目的，我们需要添加一系列东西，待会我会说明为什么我们需要他们。

### 测试你的 PWA

要检查你的网站是否是 PWA，你可以用 [Lighthouse](https://developers.google.com/web/tools/lighthouse/)。Lighthouse 是一个 chrome 插件，可以告诉你访问的网站是不是支持 PWA，如果不支持应该如何优化。

安装插件后打开网站点击浏览器右上角的 Lighthouse 图标然后点击 Generate Report。对网站检测后会打开一个新的 tab 页展示结果，你可以浏览全文或者关注顶部的数字，忽略其他部分。

![](https://cdn-images-1.medium.com/max/800/1*1jPywRVAHcebZeUIyPMllQ.png)

我开始处理网站的 PWA 部分前 Lighthouse 的检测结果。

鉴于还没有对网站开始进行 PWA 改造，36/100 不是一个悲观的数字。

### 制作 app icon

你的网站要放在主屏幕，你需要图标来展示它。

你不需要设计一个专业的 logo。对于大多数小项目来说，通过 [the noun project](https://thenounproject.com/)，找到一至两个喜欢的 icon，用 GIMP 把他们放在一起。然后在图层后面添加渐变背景。当然你也可以使用别的方法来制作 icon，只要确认它是方形的。

![](https://cdn-images-1.medium.com/max/800/1*LiFnOpwAokI_d5uD6gEzvw.png)

这是我做的图标。现在回头看我本来应该再加上圆角的。

现在你有一个 app icon 了。🎉

是时候把它放进你的网站里去了。我的方法是通过 [在线 icon 生成工具](http://www.favicon-generator.org/)。上传 blingbling 的新 icon，它会返回一些列不同尺寸版本和 HTML 代码。
- 下载文件并解压。
- 把 icon 放进网站文件夹。
- 把对应的代码放进 index.html 的 \<head\> 中
- 确保 icon 的路径是正确的。我把 icon 放在子文件夹中，所以我需要添加"/icons"前缀。

![](https://cdn-images-1.medium.com/max/800/1*5LM7_X9cAfH51oyX2aB59g.png)

### Web App Manifest

下一件要做的就是创建 manifest。manifest 是一个文件，包含了网站的数据，例如网站名字、偏好色彩和使用的 icon。
实际上，你已经有了一份 manifest，是 icon 生成工具生成的，接着我们要在上面添加更多内容。
打开 [web app manifest 生成器](https://tomitm.github.io/appmanifest/)，填写网站的相关信息。对要填写的内容不确定的话，设置为默认即可。
页面右侧，有一些 JSON 数据。复制粘贴到 manifest.json 文件头部，为确保格式正确，你可能需要添加一个逗号或删除一个大括号。
我的 manifest 文件是 [这样](https://github.com/webcommunityukie/webcommunityukie.github.io/blob/master/manifest.json) 的。

再次运行 lighthouse，检测 manifest 是否正常工作。

![](https://cdn-images-1.medium.com/max/800/1*QUbNjXriuEi68yOil6ayUg.png)

Lighthouse 给 manifest 打分，并且 icon 也正常添加了。

### 添加 service worker

service worker 是另一个我们要加入项目的文件，它允许网站离线工作。它也是实现 PWA 的一个要求，我们需要添加。
service worker 比较复杂，相关的文档都很长，并且很混乱，整个页面充满了链接，链接内容也同样又长又乱。
幸运的是看到了 [Peter](https://medium.com/@poshaughnessy) 推荐的 sw-toolbox，他还给了我一个他自己的代码链接。
所以我拷贝了他的代码，移除额外的 JavaScript 文件，添加到 service worker， 简化后用到我自己的项目里。

#### 创建 service worker 需要做的 3 件事。

- 在 index.html 的 \<head\> 里添加以下代码，注册 service worker：

```javascript
<script>
if (‘serviceWorker’ in navigator) {
  window.addEventListener(‘load’, function() {
    navigator.serviceWorker.register(‘/sw.js’).then(
      function(registration) {
        // Registration was successful
        console.log(‘ServiceWorker registration successful with scope: ‘, registration.scope); },
      function(err) {
        // registration failed :(
        console.log(‘ServiceWorker registration failed: ‘, err);
      });
  });
}
</script>
```

- 添加 sw-toolbox 到项目里。你只需要添加 [这个文件](https://github.com/GoogleChrome/sw-toolbox/blob/master/sw-toolbox.js) 到根目录下。
- 新建文件，命名为 "sw.js"，拷贝并粘贴以下代码：

```javascript
‘use strict’;
importScripts(‘sw-toolbox.js’); toolbox.precache([“index.html”,”style/style.css”]); toolbox.router.get(‘/images/*’, toolbox.cacheFirst); toolbox.router.get(‘/*’, toolbox.networkFirst, { networkTimeoutSeconds: 5});
```

你想要检查所有文件路径是否正确，编辑预缓存和列出离线时要存储的所有文件，我的站点只用到 index.html 和 style.css，你可能需要其他文件或页面。

现在，用 Lighthouse 再次检测。

![](https://cdn-images-1.medium.com/max/800/1*ySpXMuVi__zP5Pqpd000gg.png)


添加 service worker 之后 —— 测试 localhost
**如果你想要 service worker 做些不一样的事情，而不是仅仅是保存页面，例如网络不通时访问特定的离线页面，你可以试下 [pwabuilder](http://www.pwabuilder.com/generator) 这个 service worker 脚本。**

### 托管到 GitHub Pages 上

你完成了一个 PWA 页面，是时候和全世界分享了。
我发现最简单的分享方法就是 [GitHub Pages](https://pages.github.com/)。因为它是免费的，并且能为你处理所有安全问题。
新建一个仓库并上传代码到仓库，就可以托管你的代码了，GitHub GUI 会帮你做这些工作。
完成以上步骤后，在网站上找到你的仓库，在设置最下面可以选择 master 分支开启 GitHub Pages 功能。
它会返回访问 PWA 的在线 URL。
通过 Lighthouse 运行会得到不（更）同（好）的结果，然后把网址分享给你所有的朋友就好啦，或者只要把它下载到自己的手机主屏幕上就可以了。

![](https://cdn-images-1.medium.com/max/800/1*SzanuiJSVc6yrRjTPE_PbA.png)

在 GitHub Pages 托管网站后 Lighthouse 的结果。

![](https://cdn-images-1.medium.com/max/600/1*luHsbfq_Zc00B8IR7QzVmg.png)

**代码如下：**[https://github.com/webcommunityukie/webcommunityukie.github.io](https://github.com/webcommunityukie/webcommunityukie.github.io)

**完整网站如下：**[https://webcommunityukie.github.io/](https://webcommunityukie.github.io/)
它看起来和我开始时完全一样，但是在 Samsung Internet 上浏览时，地址栏会变成主题色，即浅紫色。会出现一个加号图标让你把它添加到你的主屏幕，允许全屏和离线使用。

还有很多 PWA 相关内容本文没有提到，你可以向他们发送推送通知告知用户你的应用有了新的内容。你可以阅读更多关于 [PWA 构成](https://www.smashingmagazine.com/2016/09/the-building-blocks-of-progressive-web-apps/) 的内容。

我希望本文能帮助你第一次体验到渐进式 web app，如果你在使用的过程中遇到困难，请给我留言或在推特 @ 我。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
