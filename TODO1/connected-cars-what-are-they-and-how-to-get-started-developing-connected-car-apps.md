> * 原文地址：[Connected cars 🏎 — what are they and how to get started developing connected car apps](https://hackernoon.com/connected-cars-what-are-they-and-how-to-get-started-developing-connected-car-apps-5c6fbbf1f157)
> * 原文作者：[Indrek Lasn](https://hackernoon.com/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/connected-cars-what-are-they-and-how-to-get-started-developing-connected-car-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/connected-cars-what-are-they-and-how-to-get-started-developing-connected-car-apps.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[luochen1992](https://github.com/luochen1992) [allenlongbaobao](https://github.com/allenlongbaobao)

# 互联汽车是什么以及如何开发用于它的应用？

![](https://cdn-images-1.medium.com/max/2000/1*12wBTceui8136CzD6OiIvQ.png)

未来汽车肯定会非常便捷 —— 从用手机直接发动汽车、走到车辆附近车门就会自动打开，到当你太累无法安全驾驶就会给你提醒。

那什么是互联汽车呢？维基百科的解释如下：

> **互联汽车**是可以连接到 [互联网](https://en.wikipedia.org/wiki/Internet) 并配备 [本地无线局域网](https://en.wikipedia.org/wiki/Wireless_local_area_network) 的 [车辆](https://en.wikipedia.org/wiki/Car) <sup><a href="https://en.wikipedia.org/wiki/Connected_car#cite_note-1">[1]</a></sup><sup><a href="https://en.wikipedia.org/wiki/Connected_car#cite_note-2">[2]</a></sup>。因此车辆可以和其他车内或是车外的设备分享网络资源。

毫无疑问，未来汽车的发展趋势就是互联和电动 —— 如特斯拉和保时捷这样的顶级汽车品牌都各自推出了像 Model S 和 Mission E 这样优秀的电动互联汽车。

![](https://cdn-images-1.medium.com/max/800/1*rg5RTZz36b3uDlNFyO-ZLw.jpeg)

像我们真的生活在未来一样 —— 很酷吧？

![](https://cdn-images-1.medium.com/max/800/1*IKj1zBUxGRi8KJyZRDttQg.png)

保时捷 Mission E 的内饰。

![](https://cdn-images-1.medium.com/max/800/1*IcHcbtfttiloO0g79oxuDQ.jpeg)

特斯拉 Model S 在充电。

![](https://cdn-images-1.medium.com/max/800/1*b5UsurrQR5r0WfmQdzCJ8w.png)

特斯拉 Model S 的内饰。

我对汽车了解不多，但通过互联汽车我们可以挽救生命，创造一个生态和地理都更友好的环境，让交通更安全，我们都会从中受益。

驾驶或乘坐互联汽车时，我们终于可以浏览手机中喜欢的内容而不用担心发生交通事故了。

### 开始开发互联应用

我们使用 [保时捷开发环境](http://www.porsche-next-oi-competition.com/)，因为据我所知这是最先进的软件开发工具包**（SDK）** —— 你也可以评论留下你喜欢的互联汽车软件开发工具包。🙂

* * *

![](https://cdn-images-1.medium.com/max/800/1*WGgGSvhOqtub4c9A5gL2Zg.jpeg)

注册保时捷开发环境的账号。

为什么它是最先进的？因为他们会将用于所有连接汽车的 API 实现标准化。

现在每个平台都有自己的 API，意味着每个平台你都要去学习不同的 API —— 还可能和新的标准不兼容！

点击 `register` 按钮后，你会看见一个表单，如果你想跟随我们的例子，请填写注册表格。

![](https://cdn-images-1.medium.com/max/800/1*VDeaEEOZkcJNdc10iO2Wlw.png)

注册完成后，你会看见如下界面：

![](https://cdn-images-1.medium.com/max/800/1*nixNnTtGS0rpma2uFY3R0g.png)

我们先创建一个项目。需要准备如下内容：

* 一个项目（应用程序要连接到项目）
* 一个应用（一个项目可以有多个应用）
* 一辆车（将车辆连接到应用）

简而言之，先创建一个项目、应用和车辆。然后将应用连接到项目，车辆连接到应用。逻辑如下：

**项目** **⟵** **应用** **⟵** **车辆**

![](https://cdn-images-1.medium.com/max/800/1*44xqjBlq7MV1PLTZNaVAEw.png)

创建一个名为“Mario cart”的项目

创建成功后，你会看到下面的控制台。

![](https://cdn-images-1.medium.com/max/800/1*rsmN2x0l8OIbG9CcAatMzQ.png)

下一步，创建一辆车。

![](https://cdn-images-1.medium.com/max/800/1*ubLnPZ9W1yiFhcUMeue8Aw.png)

![](https://cdn-images-1.medium.com/max/800/1*Vf1MotKtmqOgEf0p-8IGZA.gif)

不得不说，用户界面非常流畅直观。我们有了项目、车辆，剩下的就是应用了。

现在来为项目创建一个应用。

![](https://cdn-images-1.medium.com/max/800/1*dS-UFNGRQcCj-GUgk-WAcg.png)

我们可以使用 API 创建 Android、iOS 或 web 应用。我们选择 web 方式。

![](https://cdn-images-1.medium.com/max/800/1*9_uRbNTWH__yTd8I3S_i7Q.gif)

创建应用并连接到车辆

**不要忘记将车辆连接到应用。**

最后来启动模拟器。

![](https://cdn-images-1.medium.com/max/800/1*oVCeK-HBPpmxicN2PC_EHQ.gif)

模拟器页面

这是一个很棒的 web 模拟器。我们终于搭好了脚手架。然后就可以通过 API 来操作模拟器了。

### 通过 API 与模拟器交互

我们用这个 [示例仓库](https://github.com/highmobility/hm-node-scaffold) 作为样板，用你喜欢的编辑器打开它。确保你安装了 8.4 版本及以上的 Node。

```
git clone git@github.com:highmobility/hm-node-scaffold.git && hm-node-scaffold && yarn install
```

打开 `src/app.js` 这个文件，你会看见一段有用的注释。我们需要配置一些凭据信息。

![](https://cdn-images-1.medium.com/max/800/1*PKp-FNVP041G28CufYLKvA.png)

前面的步骤已经完成了，剩下的就是凭据信息了。在 **develop → project → client certificate** 下面可以查看 client certificate。

![](https://cdn-images-1.medium.com/max/800/1*wJzxuWTrg8dL6BQU7r6GLA.gif)

![](https://cdn-images-1.medium.com/max/400/1*lfirzUldQrZht-pjIaH_5Q.png)

Client certificate。

最后我们需要访问 token。脚手架会有很多版本，这个只是 **alpha** 版。在未来的版本里，你可能只需要运行一条命令：`yarn run unpack connectedcar-kit`

![](https://cdn-images-1.medium.com/max/800/1*tDU6p4cs2Cgg2m3rhdM1rw.gif)

权限 token。

好的，通过执行 `yarn run start` 命令来启动发动机吧。

![](https://cdn-images-1.medium.com/max/800/1*d7-z0M6os0CLUgro0BwZ4g.gif)

通过调用 API 来打开模拟器的发动机。

就是这样！感觉是不是很棒！想学习更多，可以查看 [官方文档](https://workspace.porsche-next-oi-competition.com/#/learn/tutorials/sdk/node-js/)。

### 接下来

如果你对这个话题感兴趣，有很多方向可以发展，但我建议你创建几个连接模拟器的应用玩玩。下面是一些应用创意 —— 你可能会赢得 10 万美元的大奖哦！

* 显示禁止或付费停车位的应用。在控制台中，禁止停车位显示红色，付费停车位显示橙色。
* 帮助找到最近的充电桩的应用。
* 可以让驾驶者快速使用谷歌地图、短信、音乐和其他程序的应用。

感谢阅读并坚持到最后，你很厉害！❤


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
