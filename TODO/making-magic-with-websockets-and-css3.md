> * 原文地址：[Making Magic with WebSockets and CSS3](https://medium.com/outsystems-engineering/making-magic-with-websockets-and-css3-ec22c1dcc8a8#.4d13ybtra)
* 原文作者：[Hélio Dolores](https://medium.com/@helio.dolores?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# Making Magic with WebSockets and CSS3 #

# 使用 WebSocket 和 CSS3 创造魔法 #

![](https://cdn-images-1.medium.com/max/1000/0*Nkkza8wGZFucca1c.)

> *“Any sufficiently advanced technology is indistinguishable from magic.”
>  ― Arthur C. Clarke*

> **任何特别先进的技术都与魔法无异**
> **—— Arthur C. Clarke**

Magic has a way of captivating attention and interest, and you can’t go wrong with magic tricks if you want to amaze people.

When I started programming, impressing people was easy to do with just a few lines of code. However, nowadays technology plays such a big role in our lives that we need to push ourselves constantly. And, we have to be really creative to amaze people.

Fortunately, the Internet of Things creates a world of opportunities to bring this kind of magic back.

You have the most unexpected objects getting connected to the internet, as well as a plethora of interactions with users and between… things.

魔法自有其吸引人们注意和兴趣的方式，如果你想让人们惊艳，使用魔术绝对没错。

我刚开始编程的时候，只需简单的几行代码就足以深入人心。然而，如今技术在生活中扮演着如此重要的角色，我们需要不断推动自己进步。并且，我们必须要极具创造性才惊艳到人们。

幸运的是，物联网的世界充满了机会，让我们可以重回魔法世界。

你可以让最不可思议的事物连接到互联网，也可以和用户或者事物之间建立非常多的互动。

### Bringing the Magic Back with … a Shopping App? Seriously? ###

### 通过一个购物 app 重回魔法世界？真的吗？ ###

Just a few months ago, a few colleagues and I participated in a hackathon. The goal was to reinvent the way people shop for clothing.

We designed an application that would help a shopping assistant search for items the customers requested inside the store. The assistant could just easily swipe those clothing items onto a much bigger screen, so the customer would get a visual of what those items would look like.

Even though we didn’t win that particular competition — [a different group of colleagues did](https://www.outsystems.com/blog/2016/10/outsystems-wins-hackathon.html) and brilliantly — we noticed that particular kind of interaction, the swiping, had a big wow effect.

The audience saw images being pushed from a tablet and projected on a much bigger screen (that’s a little bit IoT). They appeared to travel by air, from starting point to destination. It was magically awesome.

几个月前，我和几个同事参加了黑客马拉松，我们的目标是重新定义人们购买衣服的方式。

我们设计了一款应用，它可以帮助导购查找顾客在本店中的需求物品。导购员只需将这些衣服展示在大屏幕上，顾客就能看到这些衣服的样子。

尽管我们并没有在那场竞赛中获胜——[另一组同事光荣地获胜了](https://www.outsystems.com/blog/2016/10/outsystems-wins-hackathon.html)，但我们注意到这种独特的交互和展示方式给人带来极大的惊喜。

观众能够看到由平板电脑推送并投射到一个大屏幕上的图片（这就跟物联网沾边了）。他们好像飞一样，从起点直达目的地，像魔法一样令人敬畏。

![](https://cdn-images-1.medium.com/max/800/0*bLcvjqKyjmSrsKst.)

### Unveiling the Magic Trick ###

### 揭开魔法把戏的面纱 ###

I’m going to show you how we did this. And I’ll be using a very appropriate, classic magician’s tool: a deck of playing cards:

[![](https://thumbs.gfycat.com/DefiantAdventurousCamel-mobile.jpg)](https://gfycat.com/DefiantAdventurousCamel)
点击图片查看视频

There are two main factors in this interaction: real-time communication with WebSockets and optical illusions with CSS3. The devices synchronize the animation of the two different cards so the audience believes they’re the same instance.

[![](https://thumbs.gfycat.com/UnrulySaltyAnnelida-mobile.jpg)](https://gfycat.com/UnrulySaltyAnnelida)
点击图片查看视频

So, let’s dive into the deets of how this magic really happens.

我来告诉你实现的方法，会用到一个非常合适、经典的魔术师工具——一副扑克牌：

[![](https://thumbs.gfycat.com/DefiantAdventurousCamel-mobile.jpg)](https://gfycat.com/DefiantAdventurousCamel)
点击图片查看视频

这个交互中有两个主要因素：实时的 WebSocket 通讯和 CSS3 的视觉幻象。两个设备同步播放两个不同的扑克动画，而观众还以为他们是同一张扑克牌。

### Real-time Communication with WebSockets ###

### 通过 WebSockets 进行实时通讯 ###

The internet we know was mainly built using the HTTP protocol, which relies on a simple request-response paradigm. This means that a typical web application won’t receive any information it did not explicitly request.

我们所知的使用 HTTP 协议的网络是基于简单的请求-响应模式。这意味着一个典型的 web 应用如果没有明确请求的话是不会受到任何信息的。

In my card example, I really need to inform the page that a card was thrown by the user on the phone. The most efficient way to do this is by opening a real-time communication channel both applications can access — the one running on the phone and the one displaying the card table.

在扑克牌的例子中，我必须要让网页知道用户从手机上甩了一张牌出去。最有效的实现方式就是打开一个实时通讯频道，让两个应用都能连接——一个应用在手机上运行另一个用来展示牌桌。

I’ll show you how to build a simple real-time service that provides this capability. It requires running [node.js](https://nodejs.org/en/) on a server.

我将展示如何搭建一个简单的实时服务来提供这项功能，这需要在服务器上运行 [node.js](https://nodejs.org/en/)。

The following code delivers a simple web server that listens to WebSocket connections. The logic is simple. When it receives a message called *table-connect* it stores the device socket to redirect any message called *phone-throw-card* from a mobile phone socket.

下面的代码实现了一个简单的 web 服务器来监听 WebSocket 连接。逻辑很简单，当接收到一个名为 **table-connect** 的消息时，服务器将保存该设备的端口并转发所有手机端口发送来的 **phone-throw-card** 消息。

![Markdown](http://p1.bqimg.com/1949/480525a214b3e257.png)

Once the server is running the WebSocket service, it’s time to connect applications to it.

一旦服务器运行 WebSocket 服务，设备就会连接。

For this example, I used a library called [socket.io](http://socket.io/) . This library does more than just simplify the way I deal with WebSockets. It also creates a nice fallback for older versions of browsers that do not support the WebSocket protocol.

上例中，我使用了名为 [socket.io](http://socket.io) 的库。这个库不仅仅简化了我处理 WebSocket 的方式，它也会为不支持 WebSocket 协议的老版本浏览器创建一个优雅的备用方案。

The card table application must connect to the real-time server and send (emit) a message for the server to identify and store the socket (*table-connect*).

牌桌应用必须连接到实时服务并发送（使用 emit）一个消息，方便服务器识别并存储端口（消息内容为 **table-connect**）。

It also registers a callback to deal with the arrival of the new card event (*phone-throw-card*) that will animate the entry of that card.

牌桌应用也注册了一个回调函数来处理新的卡牌事件，每收到 **phone-throw-card** 消息时，它将会执行卡牌进入的动画。

![Markdown](http://p1.bqimg.com/1949/2a6c79da0542372c.png)

On the phone side, the code is also very simple. I just need to store the socket for use when I want to throw a new card on the table.

手机端的代码也非常简单，我只需要保存端口，并在丢牌到桌子上的时候使用它。

![Markdown](http://p1.bqimg.com/1949/19bd3c09fc9cbca7.png)

### Optical Illusions with CSS3 ###

### CSS3 的视觉幻象 ###

We can make animations smooth as butter with CSS3 [by following the best practices](https://medium.com/outsystems-experts/how-to-achieve-60-fps-animations-with-css3-db7b98610108). For this simple trick and illusion, both devices have the same animation effect, but they are moving in opposite directions.

For the card to appear as if it landed on the table from the bottom of the phone, I created the element outside the viewport. Then, I animated it with a simple translateY transition so that it appears to slide into view.

I changed the table script (phone-throw-card event) to call a function that injects an HTML element on the page, outside the viewport, and after that I added a CSS class to trigger the animation.

You can check the codepen here for an example and — who knows? — maybe get some inspiration.

只要遵循[这些最佳实践](https://medium.com/outsystems-experts/how-to-achieve-60-fps-animations-with-css3-db7b98610108)，我们就能让 CSS3 动画流畅如水。为了实现这个简单的把戏和幻象，两个设备需要有相同的动画效果，但是它们移动的方向正好相反。

为了让纸牌像是从手机底部落到桌子上，我在视口外创建了一个元素，之后设置 translateY 的变换让它看起来像是滑入窗口中一样。

[![](https://s3-us-west-2.amazonaws.com/i.cdpn.io/914234.ZBQJEJ.7422cae8-a613-4170-925f-c19f5c7e2839.png)](https://codepen.io/heliodolores/embed/preview/ZBQJEJ?amp%3Bdefault-tabs=css%2Cresult&amp%3Bembed-version=2&amp%3Bhost=http%3A%2F%2Fcodepen.io&amp%3Bslug-hash=ZBQJEJ&height=600&referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F4ddf88ce43d5a88b77917f85fb079fe7%3FpostId%3Dec22c1dcc8a8)
点击查看源代码

### Going the Extra Mile ###

### 锦上添花 ###

After everything’s up and running, it’s time to do some tweaking. The video showed the cards appearing to drop on the table from the bottom. By animating a reduction of size (scale) and using a shadow, it’s possible to get this more realistic effect.

As for the card dropping in the direction you set from the phone, most browsers already implement an [API](https://developer.mozilla.org/en-US/docs/Web/API/Detecting_device_orientation) to read those values from mobile devices. If you add it, along with swipe intensity, to your previous phone-throw-card event, you should be able to make this example work on your side.

所有内容都搭建并运行之后，我们该准备啃些硬骨头了。视频中展示的纸牌像是从手机底部掉在桌子上一样，通过减小尺寸（缩放）的动画效果再加用些阴影，就能让效果更佳逼真。

至于你在手机上设置的纸牌掉落的方向，大部分浏览器都实现了 [Detecting device orientation](https://developer.mozilla.org/en-US/docs/Web/API/Detecting_device_orientation) 来读取手机的方向值。如果你在手机甩出纸牌事件中添加了方向信息和滑动速度，你应该就能实现这种效果。

For help with these animations, check out this codepen:

寻求帮助请查看 CodePen：

[![Markdown](http://i1.piimg.com/1949/bea41e853fc7d113.png)](http://codepen.io/heliodolores/pen/vyLJPL)

Now that I’ve shared this trick with you, I really hope you’ll be inspired to make some magic of your own.

For my next trick, I need a volunteer… How about you, dear reader? Don’t be shy. Okay, now sit still while I download your brain through a WebSocket — Hey, where are you going!?

Oh! You’re running to tell your friends about my magic show? Good thinking! Try [Facebook](http://bit.ly/share-magic-websockets-on-facebook), [LinkedIn](http://bit.ly/share-magic-websockets-linkedin), [Twitter](http://bit.ly/share-magic-websockets-on-twitter), and [Email]()!

现在我已经把这个技巧传授与你啦，我真心希望你能受到启发并创造自己的魔法。

至于下一个魔术，我需要一个志愿者…… 你愿意吗，亲爱的读者？不要害羞。好，现在坐好，我将通过 WebSocket 把你的大脑下载下来！嘿，你去哪儿！？回来！？

哦！你亟不可待地要去将我的魔术表演跑去告诉你朋友吗？非常感谢！试试这几种方式 [Facebook](http://bit.ly/share-magic-websockets-on-facebook)，[LinkedIn](http://bit.ly/share-magic-websockets-linkedin)，[Twitter](http://bit.ly/share-magic-websockets-on-twitter) 和 [Email]()！