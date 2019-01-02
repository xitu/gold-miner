> * 原文地址：[Making Magic with WebSockets and CSS3](https://medium.com/outsystems-engineering/making-magic-with-websockets-and-css3-ec22c1dcc8a8#.4d13ybtra)
* 原文作者：[Hélio Dolores](https://medium.com/@helio.dolores?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[luoyaqifei](https://github.com/luoyaqifei)、[David Lin](https://github.com/wild-flame)

# 使用 WebSocket 和 CSS3 创造魔法 #

![](https://cdn-images-1.medium.com/max/1000/0*Nkkza8wGZFucca1c.)

> **任何特别先进的技术都与魔法无异**
> **—— Arthur C. Clarke**

魔法自有其吸引人们注意和兴趣的方式，如果你想令人感到惊艳，使用魔术绝对没错。

我刚开始编程的时候，只需简单的几行代码就足以深入人心。然而，如今技术在生活中扮演着如此重要的角色，我们需要不断推动自己进步。并且我们要极具创造性才令人感到惊艳。

幸运的是，物联网给了我们许多重拾魔法的机会。

你可以让最不可思议的事物连接到互联网，也可以和用户或者事物之间建立非常多的互动。

### 通过一个购物 app 重回魔法世界？真的吗？ ###

几个月前，我和几个同事参加了黑客马拉松，我们的目标是重新定义人们购买衣服的方式。

我们设计了一款应用，它可以帮助导购查找顾客在本店中的需求物品。导购员只需将这些衣服展示在大屏幕上，顾客就能看到这些衣服的样子。

尽管我们并没有在那场竞赛中获胜——[另一组同事光荣地获胜了](https://www.outsystems.com/blog/2016/10/outsystems-wins-hackathon.html)，但我们注意到这种独特的交互和展示方式给人带来极大的惊喜。

观众能够看到图片从平板电脑被推送并投射到一个更大的屏幕上（有点物联网的意思）。他们好像飞一样，从起点直达目的地，像魔法一样棒！

![](https://cdn-images-1.medium.com/max/800/0*bLcvjqKyjmSrsKst.)

### 揭开魔法把戏的面纱 ###

[![](https://thumbs.gfycat.com/DefiantAdventurousCamel-mobile.jpg)](https://gfycat.com/DefiantAdventurousCamel)
点击图片查看视频

[![](https://thumbs.gfycat.com/UnrulySaltyAnnelida-mobile.jpg)](https://gfycat.com/UnrulySaltyAnnelida)
点击图片查看视频

我来告诉你实现的方法，我将会用到一个非常经典的魔术道具——扑克牌：

[![](https://thumbs.gfycat.com/DefiantAdventurousCamel-mobile.jpg)](https://gfycat.com/DefiantAdventurousCamel)
点击图片查看视频

这个交互中有两个主要因素：实时的 WebSocket 通讯和 CSS3 的视觉幻象。两个设备同步播放两个不同的扑克动画，而观众还以为他们是同一张扑克牌。

### 通过 WebSockets 进行实时通讯 ###

我们所知的互联网主要基于 HTTP 协议，这种协议依赖简单的请求-响应模式。这意味着一个典型的 web 应用如果没有明确请求的话是不会受到任何信息的。

在这个例子中，我必须要让页面知道用户从手机上甩了一张牌出去。最有效的实现方式就是打开一个实时通讯频道，让两个应用都能连接——一个在手机上运行，另一个用来展示牌桌。

我将展示如何搭建一个简单的实时服务来提供这项功能，这需要在服务器上运行 [node.js](https://nodejs.org/en/)。

下面的代码实现了一个简单的 web 服务器来监听 WebSocket 连接。逻辑很简单，当接收到一个名为 **table-connect** 的消息时，服务器将保存该设备的 socket 并转发所有手机端 socket 发来的 **phone-throw-card** 消息。

![Markdown](http://p1.bqimg.com/1949/480525a214b3e257.png)

一旦服务器运行 WebSocket 服务，设备就会连接。

上例中，我使用了名为 [socket.io](http://socket.io) 的库。这个库不仅仅简化了我处理 WebSocket 的方式，它也为不支持 WebSocket 协议的老版本浏览器创建了一个优雅的备用方案。

牌桌应用必须连接到实时服务并发送（使用 emit）一个消息，方便服务器识别并存储 socket（消息内容为 **table-connect**）。

牌桌应用也注册了一个回调函数来处理新的卡牌事件，每收到 **phone-throw-card** 消息时，它将会执行卡牌的进入动画。

![Markdown](http://p1.bqimg.com/1949/2a6c79da0542372c.png)

手机端的代码也非常简单，我只需要保存该 socket，并在丢牌到桌子上的时候使用它。

![Markdown](http://p1.bqimg.com/1949/19bd3c09fc9cbca7.png)

### CSS3 的视觉幻象 ###

只要遵循[这些最佳实践](https://medium.com/outsystems-experts/how-to-achieve-60-fps-animations-with-css3-db7b98610108)，我们就能让 CSS3 动画流畅如水。为了实现这个简单的魔术效果，两个设备需要有相同的动画效果，但是它们移动的方向正好相反。

为了让纸牌像是从手机底部落到桌子上，我在视口外创建了一个元素，之后设置 translateY 的变换让它看起来像是滑入窗口中一样。

我改变了牌桌的脚本（phone-throw-card 事件），并调用函数在页面视口范围之外插入一个 HTML 元素，之后我添加了 CSS 类属性来触发动画。

你可以查看 codepen 上的例子，可能会略有启发哦~

[![](https://s3-us-west-2.amazonaws.com/i.cdpn.io/914234.ZBQJEJ.7422cae8-a613-4170-925f-c19f5c7e2839.png)](https://codepen.io/heliodolores/embed/preview/ZBQJEJ?amp%3Bdefault-tabs=css%2Cresult&amp%3Bembed-version=2&amp%3Bhost=http%3A%2F%2Fcodepen.io&amp%3Bslug-hash=ZBQJEJ&height=600&referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F4ddf88ce43d5a88b77917f85fb079fe7%3FpostId%3Dec22c1dcc8a8)
点击查看源代码

### 锦上添花 ###

所有内容都搭建并运行之后，我们该准备啃些硬骨头了。视频中展示的纸牌像是从手机底部掉在桌子上一样，通过减小尺寸（缩放）的动画效果再加用些阴影，就能让效果更佳逼真。

至于你在手机上设置的纸牌掉落的方向，大部分浏览器都实现了 [Detecting device orientation API](https://developer.mozilla.org/en-US/docs/Web/API/Detecting_device_orientation) 来读取手机的方向值。如果你在手机甩出纸牌事件中添加了方向信息和滑动速度，你应该就能实现这种效果。

寻求帮助请查看 CodePen 上的内容：

[![Markdown](http://i1.piimg.com/1949/bea41e853fc7d113.png)](http://codepen.io/heliodolores/pen/vyLJPL)

现在我已经把这个技巧传授与你啦，我真心希望你能受到启发并创造自己的魔法。

至于下一个魔术，我需要一个志愿者…… 你愿意吗，亲爱的读者？不要害羞。好，现在坐好，我将通过 WebSocket 把你的大脑下载下来！嘿，你去哪儿！？回来！？

哦！你亟不可待地要去将我的魔术表演跑去告诉你朋友吗？非常感谢！试试这几种方式 [Facebook](http://bit.ly/share-magic-websockets-on-facebook)，[LinkedIn](http://bit.ly/share-magic-websockets-linkedin)，[Twitter](http://bit.ly/share-magic-websockets-on-twitter) 和 [Email]()！