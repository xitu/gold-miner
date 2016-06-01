>* 原文链接 : [UX: Infinite Scrolling vs. Pagination](https://uxplanet.org/ux-infinite-scrolling-vs-pagination-1030d29376f1#.4mfu0ijhu)
* 原文作者 : [Nick Babich](https://medium.com/@101)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :  [Ruixi](https://github.com/Ruixi)
* 校对者:[Velacielad](https://github.com/Velacielad), [wild-flame](https://github.com/wild-flame)


“我应该为我的项目选择无限下拉模式还是分页模式呢？” 一些设计师依然在为项目应该选择这两种模式之间的哪个来实现而纠结。每种模式都有他们的优势和劣势，而在这篇文章中，我们会概述这两种模式，并决定为我们的项目选择哪一个。

### 无限下拉模式

无限下拉模式使用户在浏览包含大量信息时能够使页面无穷无尽，它实现起来也并不复杂，只要在用户下滑时更新页面就行。听上去似乎还挺诱人的，然而这种模式并不是应对所有网站或应用的万全之策。

![](https://cdn-images-1.medium.com/freeze/max/30/1*4YjR_KzD2wsFP_MDM5lE0Q.png?q=20)![](https://cdn-images-1.medium.com/max/800/1*4YjR_KzD2wsFP_MDM5lE0Q.png)</div>

<figcaption>无限下拉</figcaption>


#### **优势 #1: 用户参与和内容发现**

当你使用滚动作为检索数据的主要方式的时候，它_可能_会让用户在你的网页上停留得更久，用户参与也随之增加。随着社交网络的普及，大量的信息被消耗；无限下拉提供了一种无需等待页面预加载即可_畅游信息之海的有效方法_。

无限下拉是几乎每个_发现界面_的必备功能。在用户并不搜索特定内容，而是需要阅览海量信息来发现他们感兴趣的事物的状况下。

![](https://cdn-images-1.medium.com/max/800/1*ufczGiC2hnW3ogCNsXNzuQ.png)</div>

<figcaption>_Pinterest的海量pins_</figcaption>

你可能会把 Facebook news feed 作为估量无限下拉模式优势的例证。显然，因为内容的刷新实再是频繁，用户清楚自己不会在信息流中看到_所有_的东西。 通过使用无限下拉模式，Facebook 尽力向用户展现尽可能多的信息，而用户则浏览着，_消耗_着这股信息流。

![](https://cdn-images-1.medium.com/max/800/1*Tp7uqBoVLSOIfwngtJMeGg.png)</div>

<figcaption>Facebook news feed 促使用户不断下滑以刷新内容</figcaption>

#### 优势 #2: 下拉比点击更易于操作

_相对于点击来说用户更熟悉下拉_。鼠标滚轮或者触摸屏让下拉（的动作）要比点击来的轻松迅捷。对于连续而冗长的内容，比如一篇教程，下拉模式相对将文本分为几个不同的屏幕或页面提供了 [更好的可用性<sup></sup>](http://www.hugeinc.com/ideas/perspective/everybody-scrolls)。

![](https://cdn-images-1.medium.com/max/800/1*UFQxw3Mvf7XgdRGNYZ_2yA.jpeg)</div>

<figcaption>点击事件: 每次内容刷新都需要一次额外的点击动作，还有等待页面加载的时间。下拉: 内容刷新只需要一个下拉动作。 图片来源:[designbolts<sup></sup>](http://www.designbolts.com/2014/12/30/10-of-the-most-anticipated-web-design-trends-to-look-for-in-2015/)</figcaption>

#### 优势 #3: 下拉适用于移动设备

_屏幕越小，拉得越长_。移动浏览的普及是长下拉的又一重要支撑。移动设备的手势使下拉（的动作）直观易用。其结果是，无论所使用的设备如何，用户都能享受到真正的响应式体验。

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3p890yozrg30m80go7wo.gif)</div>

<figcaption>来源: [Dribbble<sup></sup>](https://dribbble.com/shots/2352597-Craigslist-redesign-mobile)</figcaption>

#### 劣势 #1: 页面性能和设备资源

_页面加载速度对于良好的用户体验来说意味着一切_。 多项研究已经[表明<sup></sup>](https://blog.kissmetrics.com/loading-time/) 缓慢的加载速度会导致人们离开你的网站或者卸载你的应用，而这些则意味着低转化率。这对于那些使用了无限下拉模式的人们来说是个坏事。用户下拉的越多，在同一页面加载的内容也就越多。其结果是，_页面性能会越来越慢_。

另一个问题是用户设备的性能限制。在很多能够无限下拉的网站，特别是有很多图片的那种，性能有限的设备，比如iPad，可能会由于大量加载的数据而变慢。

#### **劣势 #2: 项目搜索和定位**

无限下拉的另一个问题是当用户在信息流中选定一个点的时候，他们_无法标记_并稍后返回到这里。一旦离开站点，他们会丢失所有的进度，还不得不重新下拉到原来的位置。 无法确定下拉的位置不仅会为用户带来烦恼或困惑，也会导致对整体用户体验的损害。

2012年 Etsy 花了些时间实现了无限下拉的界面，却 [发现<sup></sup>](http://www.slideshare.net/danmckinley/design-for-continuous-experimentation) 新界面的运行并不如分页模式的界面。尽管交易额坚挺如旧，用户参与却有所降低——现在人们使用搜索已经不再那么频繁。

![](https://cdn-images-1.medium.com/max/800/1*fzb-pg0noBPYBia8ZhsLBw.png)

<figcaption>Etsy 的无限下拉式搜索界面。目前的版本有分页。</figcaption>

Dmitry Fadeyev [指出<sup></sup>](http://usabilitypost.com/2013/01/07/when-infinite-scroll-doesnt-work/): “人们会想要回去看一眼搜索结果列表来检查他们刚过看过的项目，将它们与自己在列表中的其他地方看到的进行比对。无限下拉模式不但破坏了这种动态，更将其中的上下移动列表变得的困难起来，特别是你在其他时间回到这个页面，却发现你又要从头再来，不得不重新向下滑动列表，还要等待加载结果的时候。这样的话，无限下拉模式实际上比分页模式要慢。”

#### 劣势 #3: 不相干的滚动条

另一个烦人的东西是不反映实际可用数据量的滚动条。 你可能愉悦的滑动页面，以为自己正靠近底部，这可能会让你稍微多滑了那么一点，结果就会是在当你抵达的时候，（内容）刚好翻了一倍。从可达性(accessibility)的角度来说的话，影响用户对滚动条的使用这一点真是糟糕。

![](https://cdn-images-1.medium.com/freeze/max/30/1*8ArcBlJK19mNRGIg3jBa-g.jpeg?q=20)![](https://cdn-images-1.medium.com/max/800/1*8ArcBlJK19mNRGIg3jBa-g.jpeg)

<figcaption>滚动条应反映实际的页面长度</figcaption>

#### 劣势 #4: 缺少底栏

底栏是有理由存在的：它们包含用户有时会需要的信息——一旦用户找不到什么东西或者想要获取更多信息的话，他们常常会去找找底栏。但因为无限下拉的缘故，用户在触及底部的同时，会有更多的数据加载，每次都会将底栏推到视线之外。
![](https://cdn-images-1.medium.com/freeze/max/30/1*wywLjoN1ngn3ngTYu6p9qw.jpeg?q=20)

![](https://cdn-images-1.medium.com/max/800/1*wywLjoN1ngn3ngTYu6p9qw.jpeg)

<figcaption>LinkedIn 在2012引入了无限下拉时，在用户加载新的内容之前截取屏幕。</figcaption>

使用无限下拉的网站，应该让底栏_固定在（网页）底部_或将链接移至顶栏或_侧边栏_。

![](https://cdn-images-1.medium.com/max/800/1*S0DOI2NG84PBMGO0gPn71A.png)

<figcaption>Facebook 把所有底部链接 (比如“法律声明”“招贤纳士”) 移到了右侧边栏。</figcaption>

另一个解决方案是通过使用一个加载更多的按钮，_根据需要_加载。新内容不会自动加载，除非点击_加载更多_的按钮。这样以来用户不用追逐就能容易的到达你的底栏。

![](https://cdn-images-1.medium.com/max/800/1*du1cepjlGiMG-yMfV2RRSw.png)

<figcaption>Instagram 使用“加载更多”按钮以期让用户可以触及底栏。</figcaption>

### 分页模式

分页模式是一种将内容分解到不同的独立页面的用户界面模型。如果你下拉到页面底部，看到了一串数字——那就是这个网站或者应用的分页。

![](https://cdn-images-1.medium.com/max/800/1*Cmf8-zXra4FXC7sRlS0yzw.jpeg)

<figcaption>分页</figcaption>

#### **优势 #1: 优秀的转化效果**

分页模式适用于用户需要在搜索结果列表中_检索_特定内容的时候，而不是仅仅对信息流进行_浏览_。

你可能会把 Google 搜索作为估量分页模式优势的例证。寻找最好的搜索结果，短只需要几秒钟，长则花个把小时，都取决于你的搜索内容。但当你决定不再按当前模式在 Google 搜索时，你知道搜索结果的具体数量。 你可以决定在何处停止或有多少搜索结果需要阅览。

![](https://cdn-images-1.medium.com/max/800/1*UkscmldH9wnnFEGV70OtuA.png)

<figcaption>Google 搜索结果数据</figcaption>

#### **优势 #2: 掌控感**

_无限下拉像是一场无休止的游戏 _——不论你已经下拉了多长，你都会觉得这永远都不会有尽头。用户在知道搜索结果数目时更能够作出更明智的决定，而不是在被留在那里面对着一个无限下拉的表单时。 根据 David Kieras 的研究[人机交互中的心理学<sup></sup>](http://videolectures.net/chi08_kieras_phc/): “抵达终点提供了一种掌控感。_”。这项研究也阐明了当用户受限但是依然有相关结果时，他们很容易确定自己在找的到底在不在这里。

当用户看到的结果总数时（当结果的总数不是无限的）他们会多估计长时间自己寻找所需的时间。

#### 优势 #3: 项目位置

一个有分页的界面会让用户对项目的大致位置有所感观。他们可能不清楚具体的页码，但会记得大致位置，而分页的链接则让这个过程更加轻松。

![](https://cdn-images-1.medium.com/max/800/1*yHj3EYY8ebffjwyM-bwjoQ.png)

<figcaption>在使用分页时，用户可以掌控自己的浏览方式，因为他们知道可以点击哪个页面来回到之前浏览的地方。</figcaption>

分页模式很适合哪些电子商务性质的网站和应用。当用户在线购物时，他们会想要回到刚才离开的位置，继续购物。

![](https://cdn-images-1.medium.com/max/800/1*osnIWtLG6UusQjDJZGRpDw.jpeg)

<figcaption>MR Porter 网站使用了分页模式</figcaption>

#### 劣势: 额外的动作

在分页模式下，如果要去下一个页面，用户需要找到目标链接（比如“下一页”），把鼠标悬停在其上方，点击，还要等待新页面加载完毕。

![](https://cdn-images-1.medium.com/max/800/1*l5djDDvsP0_JU7oP1EQIbg.png)

<figcaption>点击获取内容</figcaption>

这里主要的问题是，大多数网站都只为用户在一个单一的页面中显示非常有限的内容。只有在使你的网页更长且不影响加载速度的情况下，才可以使用户在单一页面无需点击分页按钮获得的更多的内容。

### 什么时候选用无限下拉/分页模式?

只有在少数几种情境下无限下拉模式才会相当好用。它非常适合那些_用户产生内容_(Twitter, Facebook) 或者 _视觉内容_ (Pinterest, Instagram)的网站和应用。 另一方面，分页模式则是一种安全的选择， 也是那些满足用户的目标导向活动(goal-oriented activities)的网站和应用的优秀解决方案。

在这一点上 Google 的经验就是一个很好的例子。 Google 图片选用了无限下拉模式，因为用户浏览和理解图像的速度要快于文本。阅读搜索结果需要更长的时间。这就是为什么 Google 搜索依然使用分页模式。

### 结论

设计师们需要在权衡这两种模式的优劣之后作出选择。选择取决于你的设计情境和内容的传达方式。总的来说，无限下拉模式适用于类似 Twitter 这种网站，用户消耗着永不停歇的信息流，_不需要寻找什么特定的东西_；而分页模式则适用于_用户需要查找特定项目，而且已浏览记录也是很重要的_搜索页。

在以后的文章中我们将介绍无限下拉模式和分页模式的最佳实践。敬请期待！

