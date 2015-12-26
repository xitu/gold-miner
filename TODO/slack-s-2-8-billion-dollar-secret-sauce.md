> * 原文链接 : [Slack’s $2.8 Billion Dollar Secret Sauce — Medium](https://medium.com/@awilkinson/slack-s-2-8-billion-dollar-secret-sauce-5c5ec7117908#.f792cmg9t)
* 原文作者 : [Andrew Wilkinson](https://medium.com/@awilkinson)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [张晓波](http://weibo.com/u/1897577113)
* 校对者: 
* 状态 :  待定


“So what’s the secret behind [Slack](http://www.slack.com)? What did you guys do that was so special?” the voice crackled over my car’s Bluetooth, “I want you guys to do whatever you did for them.” I was on a call with a prospective client, the CEO of a successful SaaS app who wanted to hire us to redesign his product. I launched into a story that I’ve told hundreds of times.

“[Slack](http://www.slack.com) 成功的秘诀究竟是什么？你们的设计团队究竟为他们做了什么特别的事情让它如此成功？我希望你们也能帮我们做那些帮他们做过的事情。” 车载蓝牙里噼噼啪啪地传来一段声音。电话的另一边是我的一位潜在客户，他是一个成功的Saas软件公司的CEO，想雇用我们帮他做产品设计。于是我又开始讲述起那个我已经说过数百遍的故事。


I’ve been asked this question almost every day for the past year by clients, investors, and fellow designers trying to reverse engineer the secret behind Slack’s success. It seems like Slack is taking over the world these days, now sporting a mind-boggling $2.8 billion dollar valuation, hundreds of thousands of users, and a break-neck growth rate.

在过去的一年中，几乎每天都会有客户、投资人以及想对Slack成功秘密进行逆向学习的设计同行们，对我问起这个同样的问题。这些天以来，全世界都在讨论着Slack，现在Slack拥有令人难以置信的28亿美元估值，数十万的用户，并且还在急速增长。 

Why ask me about Slack? I run a design agency called [MetaLab](http://www.metalab.co). You may not have heard of us — we usually work behind the scenes — but I can pretty much guarantee that you’ve used something that we’ve designed. In late 2013, Slack hired us to help them turn their early prototype into a polished product. We did the logo, the marketing site, and the web and mobile apps, all in just six weeks from start to finish. Apart from a few tweaks here and there, much of the product remains unchanged since the day we handed our designs off to the team at Slack.

为什么大家会问我关于Slack的事儿？事情是这样的。我经营着一家叫[MetaLab](http://www.metalab.co)的设计机构。你可能并没有听说过我们，因为我们通常都是幕后工作者，但我敢确信你一定使用过我们设计的某款产品。2013年年末，Slack聘请我们帮他们把早期的产品原型设计打造成耀眼的产品。我们为其设计了图标，官网以及web应用和移动应用，所有这些工作我们在6周内就完成了。经过一些少量的修改打磨，直到我们把设计稿交给Slack的时候，大部分的产品设计都和最初一模一样。

In almost ten years of business, Slack is, without a doubt, our most successful project to date — and [we’ve worked with some big names](http://www.metalab.co). It’s now valued at $2.8 billion, has over 200,000 paying users, and our favourite part: people can’t stop talking about its great design. But I wouldn’t have predicted that going into it.

在近10年的经营中，至今为止Slack毫无疑问是我们最成功的产品。Slack现在估值28亿美元，拥有超过20万付费用户，而令我们最得意的是：人们一直对Slack卓越的设计津津乐道，这也是我始料未及的。 

In July 2013, I got an email from Stewart Butterfield. I recognized his name immediately. I was a big fan of Flickr, which he co-founded and sold to Yahoo, and we were both based in the Pacific Northwest. He had big news: he was shutting down [Glitch](http://en.wikipedia.org/wiki/Glitch_%28video_game%29), the game he’d started in 2009, and was working on something new. He wanted us to design his new team chat app.

2013年7月，我收到一封来自Stewart Butterfield的邮件。我立刻就认出了这个名字，他正是Flickr的联合创始人，他创办了Flickr并且卖给了雅虎。他在邮件里说，他关闭了从2009年就开始玩的游戏 [Glitch](http://en.wikipedia.org/wiki/Glitch_%28video_game%29)，并开始尝试做新的东西，他想让我们帮他设计新构思的团队协作聊天工具。


I groaned to myself. We were avid users of [Campfire](http://www.campfirenow.com), and had tested out the many copycat products that had come out over the years. I felt the problem had already been solved. It was a crowded market and knew it would be difficult to make his product stand out from the crowd. Regardless, I was excited to get a chance to work with Stewart, and thought it would be fun to solve some of the issues that we’d had with Campfire. We shook hands, kicked things off, and rolled up our sleeves.

我呻吟着自己。我们都是[Campfire](http://www.campfirenow.com)的忠实用户，并且也尝试使用过许多相似的模仿品。我认为聊天需求已经被解决，这已经是一片饱和而嘈杂的市场了，新产品很难在这样的市场中脱颖而出。但是，我非常兴奋能有机会和Stewart共事，并且我也觉得去尝试解决一些Camfire中仍然存在的问题会相当有趣。于是我们达成合作，一切准备就绪。



When he pulled back the curtain and shared their early prototype on day one, it looked like a hacked together version of IRC in the browser. Barebones and stark. Just six weeks later, we had done some of the best work of our careers. So, how did we get from hacky browser IRC to the Slack we all know and love?

![](https://cdn-images-1.medium.com/max/1200/1*quxuSggwBdYkyCoYlE3OAA.png)

Some of our early design iterations (2013)


一些早期迭代版本（2013）

第一天他们给我们展示了早期的原型设计，它们看起来就像拼凑起来的在浏览器的聊天IRC（Internet Relay Chat，互联网中继聊天）。不仅丑陋还缺乏辨识度。然而6周之后，我们做出了职业生涯里最好的作品。那么，我们是如何做到把浏览器IRC打造成现在人见人爱的Slack呢？


Figuring out why something is successful in retrospect is like trying to describe the taste of water. It’s _hard_. We aren’t big on process. We prefer to just put our heads down and design stuff, iterating over and over again until something feels right. Slack was no different — there wasn’t any magic process we used — but looking back, I’ve identified a few key things that helped make it the huge success it’s become.

事后再来尝试分析事物成功的原因，如品尝清水的味道， _难以说清_ 。在整个过程中我们只想埋头做设计，并且一轮又一轮的迭代修改直到看起来没有问题。Slack也并不例外，我们并没有在这个过程中施展什么魔法。但回过头看，就能发现一些使它如此成功的关键因素。


When you hear people talk about Slack they often say it’s “fun”. Using it doesn’t feel like work. It feels like _slacking_ _off_, even when you’re using it to get stuff done. But when you look under the hood, it’s almost identical to every other chat app. You can create a room, add people, share files, and chat as a group or direct message one another. So, what makes Slack different? Three key things.

当你听人们谈论Slack的时候你会经常听他们提到“有趣”这个词。使用它的时候感觉并不是在乏味的工作，而是感到很放松，即使你是在用它来完成一些工作任务。但当你深入看它的本质的时候，它又几乎和别的聊天软件没什么区别。你可以创建聊天室，添加聊天成员，分享文件，群聊或私聊等等。那么，究竟是什么让Slack如此出类拔萃呢。我认为有三个关键因素。

![](https://cdn-images-1.medium.com/max/1200/1*Ryu8xQJ-6KRjP73jZe4HWg.png)

Zeroing in on the branding (2013)


定位商标设计（2013）

To get attention in a crowded market, we had to find a way to get people’s attention. Most enterprise software looks like a cheap 70's prom suit — muted blues and greys everywhere — so, starting with the logo, we made Slack look like a confetti cannon had gone off. Electric blue, yellows, purples, and greens all over. We gave it the color scheme of a video game, not an enterprise collaboration product.

在如此嘈杂饱和的市场中，是需要一些方法才能引起人们注意的。大部分的企业软件就像70年代的廉价舞会套装，全身是冷冰冰的的蓝色和灰色。所以，从商标开始，我们让Slack看起来像是纸花筒爆炸开时候的样子。充满了富有活力的蓝色、黄色、紫色还有绿色。我们给他赋予了游戏般的色彩，而不是传统的企业协作工具的样子。


**Here’s** [**HipChat**](http://www.hipchat.com) **next to Slack:**


HipChat 和 Slack 的对比

![](https://cdn-images-1.medium.com/max/1200/1*Eyy-KRgOtGcOnaAIJPV28Q.png)


Which would you rather use? They both do exactly the same thing, but one feels dull and the other feels electric and playful. The difference? Vibrant colors, a curvy sans-serif typeface, friendly icons, and smiling faces and emojis everywhere.

你会愿意使用哪一个呢？他们的功能是相似的，但一个看起来感觉暗淡沉闷，一个富有活力和乐趣。其中的差别就在于Slack使用了更多活泼的颜色，优美的无衬线字体，友好的图标和无处不在的笑脸及图标。


Slack is also chock full of fun little interactions. The logo animates in a burst of colors as it loads; modals slide down from the top of the screen; changing teams flips the screen around like a deck of cards. Throughout the entire product, everything seems to playfully jump around and pop off the screen. Each of these interactions is designed not only to help the user understand what’s going on, but put a little smile on their face.

Slack中有丰富的有趣的交互细节。Logo在载入的时候会有颜色四溅的动画，各个模块内容从屏幕的顶端滑入，切换团队的时候屏幕如扑克牌一样翻转。整个产品的交互都是在愉快轻松的滑动和跳跃中完成的。这些设计不仅仅让用户更容易理解产品的逻辑，也会让他们会心一笑。


> _“We gave it the color scheme of a video game,  
> not an enterprise collaboration product.”_

> _“我们赋予了它视频游戏般的颜色基调，而不是一个企业协作软件一样"_


Have you ever walked into a house and had an indescribable feeling that it just feels cheap? A professional builder would walk in and give you a laundry list of shortcomings: uneven drywall, gappy hardwood floors, hollow-core doors, and cheap hardware. But most people just have a gut reaction. Like a well-built home, great software focuses on giving its users hundreds of small, satisfying interactions. A great transition in a mobile app gives us the same feeling we get from using a well-made door handle on a solid oak door — you may not be able to put your finger on it, but man, does the house ever feel well built. Slack is really fun to use. It feels like a well-built house.

你是否曾经走入过一个房间，会感到有难以表达出来的廉价感？一个专业的建筑师走进这个房间会给你列出一个详细的问题清单：不平整的墙面，有裂缝的木地板，空心的门板以及廉价的硬件设施。但大部分人普通人来说，只会有一个直觉上的廉价感觉。和精致的房子一样，卓越的软件拥有数百处的细节带给用户满意和愉快的感觉。应用中优秀的过渡效果，就带给人们这样的精致的感觉。Slack就像一所建造的很好的房子，使用起来充满了乐趣和满足感。



But it’s not just how Slack looks and feels, it’s also about what it says. In Slack, every piece of copy is seen as an opportunity to be playful. Where a competitor might just have a loading spinner, Slack has funny quotes like, “Need to whip up a dessert in a hurry? Dump a bag of oreos on the floor and eat the oreos off the floor like an animal.” A strange little injection of fun into an otherwise boring day. Slack acts like your wise-cracking robot sidekick, instead of the boring enterprise chat tool it would otherwise be. Like _Interstellar’s_ TARS, compared to _2001: A Space Odyssey’s_ HAL9000:


而Slack成功不仅仅取决于它精致的外观和使用感受，还有它说独特的表达方式。在Slack中，每一个细小的部分都在展示者它的活泼幽默。通常竞品只会显示加载进度条，而Slack会显示一个有趣的提示，“想让鞭策让甜点来得更快一些么？那就把一包奥利奥倒在地上，并且趴着像牛羊一样把他们吃掉吧。” 为一天的枯燥工作带来一些有趣的小插曲，Slack就像是你的一个俏皮机器人助手，而不像其他竞品只是一个枯燥的聊天工具。。这正如《星际穿越》 中的风趣TARS 和 《2001太空漫游》中冷面的HAL9000的对比一样。


**Slack:**
> TARS: Everybody good? Plenty of slaves for my robot colony?


**Slack:**
> TARS: 大家都还好么? 我的机器人殖民地的有足够的奴隶了么?


**Their competitors:**
> HAL9000: I can give you my complete assurance that my work will be back to normal. I’ve still got the greatest enthusiasm and confidence in the mission.


**竞品:**
> HAL9000: 我可以给你充分的保证我将会恢复正常工作。我仍然对任务保持极高的热情和信心。


Even [Slack’s Twitter account](https://twitter.com/slackhq) sounds more like an emoji-loving comedian than a billion dollar enterprise software company:

甚至 [Slack的Twitter账号](https://twitter.com/slackhq) 也更像一个热爱emoji的喜剧演员而不像一个十亿美元的企业软件公司。


![](https://cdn-images-1.medium.com/max/800/1*WdSRsXcnlyeo2tZSApwYIQ.png)

We humans have a tendancy to anthropomorphize just about everything, from our pets to inanimate objects. We think cars look like they are smiling, or that a lamp “looks lonely over there”. With Slack, a bubbly, bright UI, delightful interactions, and hilarious copywriting come together to create a personality. A personality which has triggered something powerful in its users: they care about it. They want to share it with others. It feels like a favorite co-worker, not a tool or utility.

人们趋向于对所有事物都赋予人性，从宠物到无生命的物品都是这样。我们会觉得汽车的样子看起来像在微笑，或者一只远远的羔羊看起来很孤独。而Slack所拥有的活泼明快的界面、令人愉悦的交互，还有滑稽幽默的文案风格，这些综合起来让Slack赋予了个性。这样的个性会触动用户：用户会关心它，他们愿意把它分享给别人，感觉它更像是贴心的合作伙伴而不仅仅是一个工具。


> _“Slack acts like your wise-cracking robot sidekick, instead of the  
> boring enterprise chat tool it would otherwise be.”_
 

> _“Slack就像是你的一个俏皮机器人助手，而不像其他竞品只是一个枯燥的聊天工具。”_

As a kid, I used to love this burger chain called [White Spot](http://www.whitespot.ca). It started out as a tiny shack at a baseball stadium and over the past 85 years it has grown into a huge chain with locations all over Canada. The secret to its success? The “Triple-O” secret sauce that they put on all their burgers.

我小的时候，特别喜欢一家汉堡连锁店 [White Spot](http://www.whitespot.ca)。它最初只是一间在棒球馆门口的小店，85年之后它已经成为一个遍布加拿大的大型连锁店。它成功的秘密是什么？是他们洒在所有汉堡上的“Triple-O”秘密调味汁。

I used to bug my parents to let us go to White Spot instead of having another gross lovingly home-cooked meal. That is, until my Dad dropped a bomb on me. “We should just make burgers at home,” he said “you know that sauce is just mayonnaise, ketchup, and a bit of relish, right?” Sure enough, we made it at home, and confirmed that their so-called secret sauce was a bunch of grocery store condiments mixed together. Anyone could make it, but few people knew how or bothered. Instead they chalked it up to a some crazy secret recipe.

我曾一直纠缠爸妈让他们带我去White Spot吃汉堡而不是在家自己做饭。直到我的父亲有一天说：“我们在家自己做汉堡”，他说，“你知道那种秘密调味剂就是蛋黄酱、番茄酱和一点点佐料，对吧？” 不出所料，我们在家做出了汉堡，并且证实了他们所称的秘密调味料不过就是便利店的调味品的混合物。任何人都可以做出来，但只有极少的人知道怎么做或者关心怎么做，而他们只是这种调味剂奉为秘密。

Slack’s secret sauce is no different. Sure, it’s hard to get the mix of ingredients just right, but it doesn’t have any features that Hipchat and Campfire can’t build. It’s the same enterprise chat client underneath, but it’s playful, fun to use, and all that comes together to make it feel like a character in your life. It’s TARS, not HAL9000.

Slack的秘密调味剂也同样如此，就是把我们都熟知的调味品和素材合适混合到一起。但是，把原料正确的混合却是非常困难的。在Slack中并没有什么特别的地方是Hipchat和Camfire做不出来的，本质上他们都是相似的企业聊天软件，但Slack活泼有趣，使用的时候充满乐趣，这一切组合起来让它感觉像是你生活中活生生的一个朋友。它是TARS，而不是HAL9000。


Over the past couple months, their competitors have caught on. They’ve all started using casual copy and trying to bone up on design, but it’s a little like your uncle trying to do the macarena. It’s too little too late. Everyone has picked their robot sidekick. Slack has stolen the show.

过去的几个月，竞争对手们似乎终于明白过来了。他们都开始竞相模仿并专心于改进设计，但都已经太迟了。大家都已经选择了自己的机器人助手，Slack已经占据了霸主地位。



_You should_ [_follow me on Twitter_](http://www.twitter.com/awilkinson)_._

[关注我的Twitter](http://www.twitter.com/awilkinson)_._