
  > * 原文地址：[Evolving the Facebook News Feed to Serve You Better](https://medium.com/facebook-design/evolving-the-facebook-news-feed-to-serve-you-better-f844a5cb903d)
  > * 原文作者：[Ryan Freitas](https://medium.com/@ryanchris)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/evolving-the-facebook-news-feed-to-serve-you-better.md](https://github.com/xitu/gold-miner/blob/master/TODO/evolving-the-facebook-news-feed-to-serve-you-better.md)
  > * 译者：[Lai](https://github.com/laiyun90)
  > * 校对者：[kyrieliu](https://github.com/KKKyrie)  [Sean Shao](https://github.com/angilent) 

  # 优化 Facebook 新鲜事，使其为您提供更好的服务

  ![](https://cdn-images-1.medium.com/max/2000/1*jQtKO4-gLZ1Y937qKDupKQ.jpeg)

从去年年底开始，我们就着手探索如何让新鲜事（News Feeds）更加易于阅读、易于交流和易于浏览。可以想象，为一个连接 20 亿用户的社区进行设计，可能会面临一些不同寻常的挑战。

作为将 News Feed 带到每天生活中的两个设计团队的管理人员，我们清楚地意识到，我们做出的任何改变都会在整个 Facebook 体验中产生共鸣。在与世界各地使用 Facebook 的用户沟通中，他们觉得 News Feed 变得很混乱、难以浏览。解决这个问题意味着需要优化 News Feed 的设计系统，这对于一个高度优化的产品而言，无疑是一个重大的挑战。一些类似额外像素的填充或者调整按钮的色调之类的小变化，可能会带来巨大的、意想不到的影响。

[![](https://fb-s-b-a.akamaihd.net/h-ak-fbx/v/t15.0-10/20903038_10155513750176390_6456020927531450368_n.jpg?oh=dc35a79787ee18078e1890f7f255d086&oe=5A37A267&__gda__=1508549353_65f797c69507a2979e014c72da9f149c)](https://www.facebook.com/v2.3/plugins/post.php?app_id=52049637695&channel=https%3A%2F%2Fstaticxx.facebook.com%2Fconnect%2Fxd_arbiter%2Fr%2FXBwzv5Yrm_1.js%3Fversion%3D42%23cb%3Dfa753d97d77ac8%26domain%3Dcdn.embedly.com%26origin%3Dhttps%253A%252F%252Fcdn.embedly.com%252Ff32992607cee04c%26relation%3Dparent.parent&container_width=700&href=https%3A%2F%2Fwww.facebook.com%2Fdesign%2Fvideos%2F10155513748726390%2F&locale=en_US&sdk=joey&width=700)

#### 提高 News Feed 的可读性

我们的设计和研发团队坚持每天和真实的用户交流。日积月累，我们了解到用户最关心的是以下几点：

1. **内容**本身，例如分享的照片
2. 分享内容的**人**
3. 他们如何对正在浏览的内容留下**反馈**(像是评论或是交互操作)

带着从真实用户那里得来的反馈，我们深入分析了常见的 story 类型的结构。我们的想法是，将问题分解成一个一个的小问题，再从我们之前所完成的设计中确定一个能立刻满足我们用户的需求的选择。

![](https://cdn-images-1.medium.com/max/2000/1*vQMq6O3HmzHVPP5twX5TiQ.png)

改版前：这是在我们优化前现有的 News Feed 的 story 样式。

我们问自己，是否符合 3 个主要目标：

> 我们如何改进 News Feed 使其更易读阅读，并能与内容的主要部分区分开来？

> 我们如何让内容自身更具吸引力和沉浸感？

> 如何才能让用户更容易地留下反馈？

这些问题促使我们在设计 sprint 中不断地探索和实验，在两个设计师团队、研究人员和内容战略师中展开了为期一周的头脑风暴，并为新想法绘制原型。这次 sprint 的成品成为了一个指引，对形成未来的 News Feed 提供了很大的帮助。

![](https://cdn-images-1.medium.com/max/2000/1*-Kkl2bNRuk02FZ7tMipTEw.png)

我们设计 sprint 的第一版迭代更新的 story 样式

我们尝试了各种设计处理，以找寻机会去改进每种内容类型展示的方式。

- 通过优化视觉层次结构、增加文字大小和颜色对比来增加 News Feed 详情的易读性
- 通过改进图标样式、放大点击目标尺寸来帮助用户更好地理解 News Feeds 的操作并与之进行交互
- 通过扩大内容展示区域、减少不必要的 UI 元素来提供更精彩的内容体验

我们的设计 sprint 都会有一个研究机会来验证我们的探索。在 sprint 中，我们确保把作品展现在真实的用户面前，来看看他们的反应。

![](https://cdn-images-1.medium.com/max/2000/1*COSpLOU6nblSxB45OzKIUQ.png)

第一轮测试的用户反馈。

通过几轮迭代和测试，我们了解到我们最初的一些设计方案有助于让界面整洁，但是诸如将文案放置在照片顶部、删除明确的文本标签等决定，又引发了新的易读性问题。每次迭代都让我们离最终的设计又进了一步，我们的目标是布局和板式更易使用而又不牺牲可理解性。

![](https://cdn-images-1.medium.com/max/2000/1*KMsUJuKyk8UeWqt6PDOm-A.png)

改版后：我们最后一轮的 News Feed 的 story 优化。

#### 让评论更具对话性和吸引力

我们的目标是让人们容易参与到有意义的交流中去，让交流更为集中的同时产生更多的互动，并为人们提供更多元的表达自己的方式。我们现有的样式植根于留言板的风格，可供个人表达的方式大多相似且有限。当我们开始寻求其他评论样式时，很明显，消息传递设计范能够使人们比以前更好地进行交流。

![](https://cdn-images-1.medium.com/max/2000/1*wVbXLamvms92BPrapEBigw.png)

以前的评论样式（左图）以及优化后的（右图）。

#### 让 News Feed 详情间的浏览更容易

我们想改进的另一个方面是用户如何在整个系统间进入和离开 News Feed。根据内容类型，我们观察发现实验室研究中的用户打开他们的 Feed 后，仅仅只是陷于消费内容。我们也注意到，用户如何努力寻找「返回」按钮，而这是因为多年来我们与执行一致的功能可见性原则相违背。

![](https://cdn-images-1.medium.com/max/2000/1*pzPdxt8EiRfeJ8tfSlgLqA.png)

以前的导航（左图）以及优化后的（右图）。 

除了减少导航栏和 story 标题间的冗余之外，我们团队选择了在所有沉浸式视图中一致的返回可供性。我们还优化了从 News Feed 到 story 视图页的跳转，通过扩展内容显示区域，营造一种专注于情境的感觉。我们也改善了导航的手势，让用户可以滑动屏幕回到 News Feed。

[![](https://fb-s-d-a.akamaihd.net/h-ak-fbx/v/t15.0-10/20884290_10155513754036390_2163201085114679296_n.jpg?oh=054fbfb96418565834359c970c76b092&oe=5A1F9814&__gda__=1512720282_b3d048b53c0060bfcabd3f090b8a4b86)](https://medium.com/media/dd89d805e790715d32a15a67ce6e814d?postId=f844a5cb903d)

我们将继续从这里开始构建系统，在 Facebook 没有什么事情「做完」过。作为 Facebook 的设计师，我们以用户为中心，所以我们着手以有意义的方式改进用户体验。这将是一个独特的设计挑战，因为我们不希望仅仅「在无关痛痒的地方瞎搞」，而是真正让数十亿人每天使用的东西不那么令人沮丧。我们会在新基础上继续学习、迭代和改进，但是我们希望这一步可以迈向更好的 Facebook 体验。

在这里，我想祝贺我们成功发版，并衷心感谢团队的每位成员！没有你们的巨大努力和牺牲，是不可能做到的。

还要感谢 Geoff Teehan、John Evans、Julie Zhuo、Lars Backstrom、Hady ElKheir、John Hegeman、Mark Hull、Adam Mosseri、Tom Alison、Chris Cox 和 Mark Zuckerberg，以及其他参与过这个项目的所有人，感谢你们提供的支持和咨询，并最终帮助推进项目上线。 


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
