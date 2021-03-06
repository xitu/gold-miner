> * 原文地址：[Designing Offline-First Web Apps](https://alistapart.com/article/offline-first/)
> * 原文作者：[Alex Feyerke](https://alistapart.com/author/afeyerke/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/offline-first.md](https://github.com/xitu/gold-miner/blob/master/TODO1/offline-first.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[Alfxjx](https://github.com/Alfxjx)，[xionglong58](https://github.com/xionglong58)

# 设计离线优先的网络应用

![](https://alistapart.com/wp-content/uploads/2013/12/ALA386_designoffline_300.png)

当我们构建网络应用时，总是会假设用户和我们所拥有的外部条件是一样的。我们认为他们也拥有最先进的设备、最新版的软件，以及最快的网络连接速度。虽然我们可能会一直使用一套用过时的设备和浏览器用于测试，但是却花很多时间在现代的、在线的台式机设备上进行开发。

对于我们来说，连接失败或者连接服务的速度很慢，都只是暂时性的问题，我们只用一个错误信息来处理即可。从这个角度来看，我们很容易认为，随着网络覆盖范围的扩大和服务速度的加快，连通性、移动端或其他方面的问题会随着时间的推移自行解决。而只要我们的用户位于地面上开阔的、信号良好并且不那么拥挤的城市里，这样确实是可行的。

但是一旦这些用户进入位于地下的地铁，或者登上飞机航行，又或者生活在乡下，那么会如何呢？再比如，他们位于一个信号不好的房间里，或者在拥挤的人群中？此时我们精心构建的应用体验就变成了烦恼之源，因为我们的这些体验极大的依赖于对服务端的连接。

这种依赖忽视了一个基本事实：离线情况是生活中很正常的现象。如果你移动的话，在某些位置确实会遭受离线。但是都没关系，我们是有方法应对的。

## 问题盘点

在过去的时间里，网络应用是要全权依赖于服务端的：服务端完成所有的事务，而客户端只是负责展示结果。任何网络连接失败都是致命的：一旦你离线了，应用就不能用了。

支持前端渲染的客户端部分的解决了这个问题，例如，在类似于浏览器的 Google 文档中可以运行更多的应用程序逻辑。但是为了更佳的离线优先体验，你也需要在前端存储数据，并需要将这些数据和服务端的数据库同步。好消息是，浏览器端数据库现在已经发展得很成熟了，并且有越来越多的解决方案涌现出来 —— 例如 [derby.js](http://derbyjs.com/#introduction_to_racer)、[Lawnchair](http://brian.io/lawnchair/)、[Hoodie](http://hood.ie)、[Firebase](http://firebase.com)、[remotestorage.io](http://remotestorage.io/)、[Sencha touch](http://www.sencha.com/learn/taking-sencha-touch-apps-offline/)等等，所以寻找技术方面的解决方案已经越来越容易了。

但是我们却还有更大、更难的问题要去解决：为间歇性连接设计应用程序及其接口会导致一系列的新场景和问题。

当然离线优先的用户体验已经有一些先例，它们其中之一已经非常普遍了：电子邮件的收件箱和发件箱。离线的时候，邮件可以先收入发件箱。一旦用户入网，发件箱中的邮件就会被发送出去。非常简单平白的逻辑，并且很好用。

同样的，收件体验也可以这般流畅：当你重新连接到网络的时候，来自服务端的新邮件将会在收件箱的顶部出现。而在你打开应用到重新获取网络连接这之间的时刻，由于你已经在本地多少存储了你的所有邮件的副本，所以你永远也不会看到一个空空如也的应用界面。客户端推送失败，客户端拉取数据或服务端推送数据失败，以及离线情况下本地可用数据，这三个场景都被很好的考虑到了。

然而事实是，收发邮件处理逻辑是相对容易的。它们是不可编辑的，只需要简单的罗列出来，并且是基于文本的，也不存在冲突问题，同时邮件的用户对本地备份这种理念也已经非常熟悉了。但是在此之外，还是存在很多其他的可能性。比如，我们该如何处理协作绘图应用的场景？如果我们要处理的内容不是像邮件这样的不可修改的对象，而是具有动态的地图标签、midi 轨迹、多问题、多任务、多操作的地图应用呢？浏览器是运行时应用的新选择，同时如果我们参考 [Atwood’s 准则](http://www.codinghorror.com/blog/2007/07/the-principle-of-least-power.html)（“任何可以用 JavaScript 写的应用，最终都会用 JavaScript 完成”），那么在未来几年里，我们又能在浏览器中作出什么之前闻所未闻的应用呢？难道我们依旧要把离线模式作为一种边缘情景，并采取一种处理失败，或者展示让人讨厌的空面板，又或者报错的方式来处理吗？

离线使用网站或者应用的体验应该要更优，要给人更少的不良体验，并且更强大。我们需要和响应式网站设计同等的用户体验：可用于无网络、多设备的健壮的多种准则和模式。

## 网络连接的生命周期

大多数的网络应用都有两个与连接有关的故障点：客户端推送错误以及客户端拉取/服务端推送错误。基于应用功能，你也许希望：

* 告知用户或直接隐藏掉网络连接状态和变化（例如，聊天软件会告知用户，新编辑好消息没有被立刻发送出去）；
* 离线时也能够在客户端进行创建和编辑，保证这些数据会被保存，并最终会发送到服务端（回想以下，很多照片分享类的应用都允许你在任何条件下拍摄并发送图片）；
* 将那些不能离线运作的功能禁止、修改或者隐藏掉，而不让用户在使用的时候遇到问题（例如，“发送”按钮会在离线的时候变成“入网后发送”按钮）。

在用户使用过程中，还有其他很多问题会在网络连接状态发生改变的时候浮现出来，例如，服务端想要推送一条消息修改或查看用户正在使用或者甚至是在编辑的对象。这时候，你就需要

* 通知用户，有一条新的、并可能和本地数据有冲突的数据可查看；
* 可能的话，提供给用户一款好用的冲突处理工具。

下面就让我们一起看一些真实应用场景下的例子。

## 棘手的网络连接场景

### 本地数据的丢失

在除了 Chrome 之外的浏览器上离线使用 Google 文档可能会让人感觉很不好：此时你根本无法编辑文件。而尽管文档还是可以阅读的，但是想拷贝部分内容却不行。这时候你想对文档或者表格做什么操作都不行了，甚至是将它们拷贝到另一个程序里以继续都不行。尽管如此，其实这也比之前的版本要好很多了，当时会有弹窗蒙层告知用户已处于离线状态，并阻止用户查看文档。

不管是在原生还是在网页应用上，这都是一个很常见的场景：当你断开网络连接的时候，刚刚获取的数据马上就不能用了。而应用应当尽可能的维护断网前最后的状态，同时即使数据不能被修改，也要保证至少是可用的。这就需要在本地留存一份数据，当服务不可用的时候将其作为备份，这样应用的用户就永远不会面对一个空空的应用面板了。

### 像处理错误那样处理离线

请停止像处理错误那样处理离线状态这种行为。你的应用应当能够妥善处理离线，并尽可能保证让用户可以愉快地继续他们的工作。不要展示那些你无法填充数据的页面，并保证提示信息内容准确。以 Instagram 为例：当用户无法发送照片的时候，Instagram 会认为这是一个错误 —— 而与其提示用户图片没有丢失，不如在连接网络后自动发送。离线其实没什么大不了。你也许也希望根据网络连接状态修改用户界面，例如将“保存”改为“保存到本地”。

你有时候可能需要将所有功能都置为不可用，但是更多的场景下，却并不需要这样。例如：

* 如果你无法更新数据，那就展示旧的数据并提供一个相关的提示。不要在获取到新数据之前就废弃旧数据，此时如果失败了，那你就只能展示一个空的、没用的界面了。
* 如果你的应用可以允许用户创建本地数据，那么就让用户在离线时创建，并提示用户数据会被保存，并且在连接到网络后会被发送到服务端。此外，还可以在数据真的要被同步到服务端的时候，提示用户确认。以 Instagram 为例，它能获取到图片的拍摄时位置，但是当处于离线状态时，它无法请求到该位置地名，而无论如何，一旦用户重新连接网络，Instagram 就会让用户回到图片界面中并选择一个位置名。

### 处理冲突

如果你的应用提供了协作编辑，或者其他多设备同步使用的功能，你可能会遇到内容对象的版本冲突问题。这是不可避免的，但我们可以提供给用户简单易用的冲突处理界面，而其实这些用户可能都不理解同步冲突是什么。

例如 Evernote 的功能就极大的依赖于可同步记录：处理冲突的办法就是简单地将不同的记录拼接起来。而对于多行的记录，这就需要大量的逻辑方面的探索以及接下来的编辑工作。

而另一方面，[Draft](http://draftin.com) 却简单漂亮的解决了协作者间的冲突。它会在三个不同的列中展示两个版本以及他们之间的区别，每处差别都配有“接受”和“忽略”按钮。至少对于单纯的文本而言，直观并可视的解决冲突是绝对可行的。

有时候，细节化的处理每一处差别是没必要的。更多的情况下，你只需要提供一个漂亮的界面即可，这个界面要能突出差别，并且允许用户选择具有冲突的版本中的一个。

还有更多其他可能的冲突类型在等待我们发现和处理，这其中可能很多都不是基于文字的：可能是有争议的地图标签位置，条形图的颜色，图像中的线条，以及成千上万的我们没想到的其他更多可能。

但并不是所有技术问题都需要用技术的方法解决。假设在一个很大、多层的餐厅里，有两名使用无线点餐设备的服务员。其中一个连接了餐厅的服务，而另一个在顶层，他的连接暂时失效了。两桌都同时点了一样的超贵的限量版红酒。而离线的服务员的设备此时并不知道这个冲突。但是它可以做的是，意识到可能存在冲突的风险（库存很少，并且处于离线状态），并建议服务员反馈给这一桌客户一个合理的回复（“哇哦，您眼光真好，这可是限量款。让我先看看今天是否还有供应”）。

### 提前满足用户需求

在某些情况下，应用可以提前采取某些低开销的行为，以求给用户更佳的体验。当 Google 地图监测到用户在异地城市并且处于 wifi 连接下的时候，它就会快速的缓存用户周围环境的地图，以备用户稍后的离线使用，或者漫游时使用。

但是在很多场景下，因为内容太多而并不适合提前缓存 —— 例如，新闻网站的视频。在这种场景下，用户必须自己选择想要同步的内容，这就会要求他们将视频下载到本地设备，并在其他应用中播放。视频在线时具有的任何附加信息 —— 比如视频相关的信息或者相关的评论 —— 下载后都会丢失，同时此时用户也不能对视频发表评论了。

### 刷新按时间排序的数据

上面所有的这些例子都是关于客户端发送消息的，但是服务端推送消息的场景也是存在的：需要按时间排序的数据通常都会遇到这样的问题，即当服务端想要更新用户活跃的界面，或者推送的数据不能简单的加入到列表顶端的时候，我们需要做什么呢？

例如，如果你在多设备上使用 iMessage，那么在同步过程中，消息可能并没有按照时间排序。iMessage **本来可以**进行排序 —— 毕竟消息都有时间戳 —— 但是它却并没有这么做，而是就按照消息到达设备的顺序排列了。这会让消息更显眼，但是同时也容易造成用户的困惑。

假设我们用一种更直观的方式来处理：信息总是会按照时间排列，而不考虑其被设备接收的时间。乍一看这样好像更加合理，但是这就意味着你可能需要向前滚动才能读取到刚收的新消息，因为这些消息可能是很早之前就发出了的。更糟糕的是，你可能都不会注意到这些新消息，因为它可能被挤出了可视界面，你根本看不到它们。

如果你按时间排序现实数据，而数据本身的顺序是有意义的，例如在一个聊天中（和邮件不同，邮件是线性排列），离线功能就会造成这样一个问题：最新收到的消息并不一定是时间上最新的，按照时间排序的话，它就可能会出现在任何用户可能看不到的地方。你需要维护上下文和序列顺序，但是你的界面也需要让用户知道，**实时收到的**最新的消息在**哪里**。

### 为多种数据类型做好准备

很多例子都基于纯文本，但是即使他们不是纯文本（比如地图标签），可想而知他们中的一些也可以一些使用基于文本的帮助功能（例如地图边上的标签列表），而它们是可以简单的进行同步的更新和通知。

但是，我们都知道，网页应用的数量、种类和复杂度都会持续攀升，同时用户处理的数据类型也会跟着上升。这些数据有些是可协作的，同时大部分是会在多设备上应用，因此会产生很多新的同步问题。学习它们，并研发用于处理离线场景和其解决方案的通用类型表，是很明智的选择。

## 离线匿名用户

当我们开始向全世界的开发者提出这些问题的时候，我们非常吃惊的发现，很多人都忽然发现应用的离线场景简直就是灾难 —— 并意识到他们过去都遇到过类似的问题，但是却从未正式讨论过它们。很多人都努力想要改变，但是最终还是放弃了或者拖延了，但他们心里都希望可以有人给出一些离线应用相关的建议。

我们并不需要匿名。你可以看看 13 年前 [John Allsopp 的文章](https://alistapart.com/article/dao/)，他在文章中呼吁将网页应用视作一种未知的流体介质，要去“容纳所有事物的潮起潮落”。现在，我们已经意识到了，网页应用已经不仅仅要兼容设备屏幕大小、像素、功能支持和渲染实现，甚至是对于应用与网络连接情况也应如此。

如今是一个流动性更强，变化更快，甚至是有些令人生畏的世界，我们都需要互相扶持。我们要保证自己，以及那些追随我们的人，能够用可靠的工具和模式来武装自己，去面对各种不确定性以及不断增长的移动端世界，这是为了我们的用户，也为了我们自己。

为了帮助我们自己，以及下一代的设计师、开发者，还有用户界面专家，我们邀请您参与到 [offlinefirst.org](http://offlinefirst.org) 的讨论中来。我们最终的目标就是创建一份离线手册，内容包括用户体验模式和反模式，技术选型，以及用户设备模型调研等 —— 我们想要创建一个可以供大家获取或贡献知识的库，如此这样，我们共同的努力和经验就不会浪费掉了。

现在，我们需要听到来自你的声音：关于你在此领域的经验，你掌握的工具的知识，以及技巧和窍门，甚至是你面对的挑战。解决它们并不容易，但是一旦成功，必将会改善我们的用户体验 —— 而无论这些用户是在何时何地需要我们的服务。这难道不就是我们做这一切的目的吗？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
