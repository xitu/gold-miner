> * 原文地址：[The easy way to turn a website into a Progressive Web App](https://dev.to/pixeline/the-easy-way-to-turn-a-website-into-a-progressive-web-app-77g)
> * 原文作者：[Alexandre Plennevaux](https://dev.to/pixeline)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-easy-way-to-turn-a-website-into-a-progressive-web-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-easy-way-to-turn-a-website-into-a-progressive-web-app.md)
> * 译者：[bambooom](https://github.com/bambooom)
> * 校对者：[MechanicianW](https://github.com/MechanicianW) [tvChan](https://github.com/tvChan)

## 什么是渐进式 Web 应用程序？

基本上来说，PWA 是一个网站，当用手机访问时，网站可以保存在手机，并且体验就像一个原生应用程序一样。它会有一个加载显示，你可以删除 Chrome 的界面，如果网络连接断开，它仍然可以正常显示内容。最重要的是它提高了用户的参与度：在 Android 上的 Chrome 浏览器（不确定其他移动端浏览器上行为是否一致）如果检测到网站是 PWA，它会提示用户使用你选择的图标将其保存在设备的主屏幕上。

## 为何它如此重要？

**PWA 对客户端上的业务有好处。**中国的亚马逊，阿里巴巴注意到由于浏览器“安装”网站的提示，用户的参与度提高了 48%（[来源](https://developers.google.com/web/showcase/2016/alibaba)）。

这说明 PWA 完全值得为之努力奋斗！

这极大可能要归功于一种叫 **Service Workers** 的技术，它允许你在用户系统中保存静态资源（html、css、javascript、json…），同时还有一个 `manifest.json` 文件，指定网站如何像一个已安装的应用一样运行。

## 例子

这些都是我用本教程里描述的相同的方法做的网站：

* [plancomptablebelge.be](https://plancomptablebelge.be) （一个单页网站）
* [didiermotte.be](https://didiermotte.be) （一个基于 WordPress 的网站）

更多例子可以在这里看到：[pwa.rocks](https://pwa.rocks)

## 设置

将网站变成 PWA 可能听上去很复杂（Service workers？是什么？），但其实并不难。

### 1. 要求：https 而不是 http


最困难的部分就是 PWA 只能在安全域的网站上运行（也就是在 **https://** 后，而不是 http://）。

通常这些很难手动设置，但是如果你有自己的服务器，你可以使用 [letsencrypt](https://letsencrypt.org/) 很简单并自动化的完成这个步骤，并且完全**免费**。

### 2. 工具

#### 2.1 lighthouse 测试

* [lighthouse 测试](https://developers.google.com/web/tools/lighthouse/) 是由 Google 创建并维护的自动化测试工具，它通过三个标准来测试网站：渐进性、性能、可访问性。它会对每一项给出一个百分比分数，并提出优化建议，是个非常好用的学习工具。
* ![Lighthouse test result for didiermotte.be](https://res.cloudinary.com/practicaldev/image/fetch/s--DigZaUAj--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://www.dropbox.com/s/rwfesahj7haglsc/Capture%2520d%2527%25C3%25A9cran%25202017-11-21%252010.03.29.png%3Fdl%3D1)
* [realfavicongenerator.net](https://realfavicongenerator.net)
* [UpUp.js 库](https://www.talater.com/upup/getting-started-with-offline-first.html)

#### 2.2 realfavicongenerator.net

[realfavicongenerator.net](https://realfavicongenerator.net) 注重你的 PWA 的视觉层。它会生成上面提到的 `manifest.json` 文件，以及网站保存到任意移动设备上时所需要的各个版本的图标文件，以及添加到页面 `<head>` 标签的一段 html 代码。

**建议**：虽然 RFG 将你的资源放在子文件夹中，但这会使得启用 PWA 更困难。所以为了简单方便，将所有图片等资源全部放在根目录下即可。

#### 2.3 通过 upup.js 使用 service workers

Service workers 是一项 JavaScript 技术，对我疲倦而急躁的大脑来说很难理解。但幸运的是，[一位聪明的德国女孩](https://vimeo.com/103221949)告诉我 [Tal Atler](https://twitter.com/TalAter)，她希望推进“离线优先”的理念，所以她创建了一个 JavaScript 库能够让你的网站在掉线的时候依然轻松保持正常运作。谢谢你，Ola Gasidlo！

只需要快速浏览一下 [UpUp 的教程](https://www.talater.com/upup/getting-started-with-offline-first.html)就够了。

#### 2.4 Manifest 文件

编辑 RFG 生成的 `manifest.json` 文件，它至少应包含这些条目："scope"、"start_url"、"short_name"、"display"。以下是一个示例：

```json
{
    "name": "My PWA Sample App",
    "short_name" : "PWA",
    "start_url": "index.html?utm_source=homescreen",
    "scope" : "./",
    "icons": [
        {
            "src": "./android-chrome-192x192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "./android-chrome-512x512.png",
            "sizes": "512x512",
            "type": "image/png"
        }
    ],
    "theme_color": "#ffee00",
    "background_color": "#ffee00",
    "display": "standalone"
}
```

更多相关信息见此处：[developers.google.com](https://developers.google.com/web/updates/2017/02/improved-add-to-home-screen#navigating_outside_of_your_progressive_web_app) 。

### 3. 步骤

1. 使用 Realfavicongenerator 生成需要的 html 和图片，将代码添加到你的网站代码中。
2. 在你的 https 域上发布网站。
3. 做 lighthouse 测试。
4. 分析结果。
5. 解决每个问题。
6. 回到第 3 步重复。
7. 重复直到你在几乎所有地方拿到接近 100 的分数，并且在“Progress”一项拿到 100。
8. 在你的手机上测试看看。有一定机会，你会看到底部弹出窗口，邀请你将网站保存都手机主屏幕上。![](https://res.cloudinary.com/practicaldev/image/fetch/s--YezWkN00--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://github.com/becodeorg/Lovelace-promo-2/raw/master/Parcours/PWA%2520-%2520progressive%2520web%2520apps/assets/add-to-homescreen.jpg)

## 如果你想深入了解...

这是一个我用 Github Pages 做的 PWA 的例子，我在 [BeCode](http://www.becode.org/) 时给我的后辈现场编写的，你可以用你的手机来访问并测试，点击[这里](https://pixeline.github.io/pwa-example/index.html)，它的代码在[这里](https://github.com/pixeline/pwa-example)。

你可以在下面这本书中找到所有有关 PWA 的信息：

[Building Progressive Web Apps](https://www.amazon.fr/_/dp/1491961651?tag=oreilly20-20)

![](https://res.cloudinary.com/practicaldev/image/fetch/s--joTnFRw3--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://images-na.ssl-images-amazon.com/images/I/51xL1wjYrHL._SX379_BO1%2C204%2C203%2C200_.jpg).

以上就是所有内容，PWA 快乐！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
