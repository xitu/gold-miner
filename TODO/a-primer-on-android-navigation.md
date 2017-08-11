
> * 原文地址：[A Primer on Android navigation](https://medium.com/google-design/a-primer-on-android-navigation-75e57d9d63fe)
> * 原文作者：[Liam Spradlin](https://medium.com/@LiamSpradlin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-primer-on-android-navigation.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-primer-on-android-navigation.md)
> * 译者：[horizon13th](https://github.com/horizon13th)
> * 校对者：[SumiMakito](https://github.com/sumimakito), [laiyun90](https://github.com/laiyun90)

# 安卓界面导航初识

> 界面中任何引领用户跳转于页面之间的媒介 —— 这便是导航

当你的应用中的两个不同页面产生联系时，导航便由此而生。跳转链接（不论从哪跳到哪）便是页面间传递用户的媒介。创建导航相对容易，但想要把导航**做好**并不总是那么简单。这篇博文里，我们探讨一下安卓系统下最常见的导航模式，看看它们是怎样影响系统布局，以及如何为你的应用界面，用户量身打造导航栏。

---

### ✏️ 定义导航

在深入探索导航模式前，让我们先退后一步回到起点，做一个小练习，回想一下你的应用中的导航。

在 Material Design 网站中有许多 [优秀设计规范](https://material.io/guidelines/patterns/navigation.html#navigation-defining-your-navigation) 介绍了如何着手定义导航结构。但本文中我们把所有的理论归结为简单的两点：

- 基于**任务和内容**构建导航
- 基于**用户**构建导航

基于**任务和内容**构建导航意味着，将任务分步骤拆分。设想用户在完成任务的过程中应该做什么看到什么，怎样处理步骤之间的关系，决定哪一步更重要，哪些步骤是并列关系，哪些步骤是包含关系，哪些步骤常见或不常见。

至于基于**用户**构建导航，只有真正使用过你设计的界面的用户才能告诉你这适不适合他们。你所设计的导航最好能帮助他们更好地使用应用，带给他们最大化的便利。

当你搞清楚在你的应用中，多个任务怎样协同工作的，便可以着手设计。用户在完成任务的过程中可以看到什么内容，在什么时候，以什么方式来呈现。这个小练习能够让你从根本上思考什么样的设计模式能更好地服务于你的 app 体验。

📚 分解任务行为以设计导航更多内容，详见 [Material Design](https://material.io/guidelines/patterns/navigation.html)。

---

### 🗂 标签页（Tabs）

![](https://cdn-images-1.medium.com/max/2000/1*7VP4nwgLIOSLg2W13Iz6Dg.png)

#### 定义

标签页提供了在相同父页面场景下，同级页面间的快速导航。所有的选项卡是位于同一平面的，这意味着，他们可以放置在同一可扩展的状态栏上，也可以相互改变位置。

标签页是很好的页面内容过滤、分段、分级工具。但是对于毫无关联的内容，或是层级化结构内容，也许其它的导航模式会更合适。

📚 设计标签页的更多细节 [参考此处](https://material.io/guidelines/components/tabs.html#)，更多实现 [参考此处](https://developer.android.com/training/implementing-navigation/lateral.html)。

#### 标签页实例
![](https://cdn-images-1.medium.com/max/800/1*tgbpHME812InaPR0FW6qaw.png)

![](https://cdn-images-1.medium.com/max/800/1*BrOW6gtAXsqg4xymoOq9pQ.png)

![](https://cdn-images-1.medium.com/max/800/1*PJTRuuAemKls6g1l9YJkqQ.png)

Play Music 应用，Google+ 应用，Play Newsstand 应用

Play Music 应用（左）使用标签页增加音乐库的探索深度，以不同的方式组织大致相同的内容，为用户定制不同的探索方法。

Google+ 应用（中）使用标签页将收藏列表分块，每个类别下都是深层异构的内容。

Play Newsstand 应用（右）在媒体库页面使用标签页来呈现相同信息的不同集合 － 其中一个选项卡呈现一个整体的多层次的集合，另一个选项卡显示浓缩集合的大标题。

#### 访问记录

标签页一般为同一级别，因此它们的布局在相同的父级页面下。两个标签页间的切换不需要为系统后退键或应用的返回键新建历史记录。

---

### 🍔 侧边栏／抽屉式导航栏（Nav drawers）

![](https://cdn-images-1.medium.com/max/2000/1*OlvxTeFymVd35TFE1d4QcA.png)

#### 定义

侧边栏（抽屉式导航栏）可以理解为附于页面左部边缘的垂直面板。设计者可以将侧边栏设计在屏幕外或屏幕内可见，持续存在或者不用时隐藏，但这些不同的设计往往有相同的特点。

通常侧边栏会列出一些同级的父级页面们，尤其用于放置较重要的页面，又例如一些“设置”，“帮助”这类特殊页面。

如果你将侧边栏和另一个导航控件相组合——底部导航栏，那么侧边栏可以放置一些二级链接，或者底部导航不能直接到达的重要链接。

当使用侧边栏时，要注意链接**类别**——放过多的链接，或展示过多不同级别的链接，都会让应用的层次结构显得混乱。

还有需要注意的一点是界面的可视性。侧边栏可以很好的帮助应用减少可视性，压缩与主要内容无关的导航区。但是，这也可能成为应用的不足，取决于导航栏的目标链接在具体场景中如何呈现和被访问。

📚 设计侧边栏的更多细节[参考此处](https://material.io/guidelines/patterns/navigation-drawer.html)，更多实现[参考此处](https://developer.android.com/training/implementing-navigation/nav-drawer.html)。

#### 侧边栏实例

![](https://cdn-images-1.medium.com/max/800/1*dFyqnTkAgdbLlFf5unYuTg.png)

![](https://cdn-images-1.medium.com/max/800/1*_3x6wIR1_bJYacP85YcSKg.png)

![](https://cdn-images-1.medium.com/max/800/1*t4KPT6fq_zgLH04hEuDsag.png)

Play Store 应用，Google Camera 应用，Inbox 应用

Play Store 应用（左上）使用侧边栏展示应用商店的不同区域，每一栏都链接到不同区域的内容。

Google Camera（中上）使用侧边栏列出其它支持功能——大部分是提升照相体验的其他应用外链，当然了还有相机设置。

Inbox（右上）邮箱应用使用了伸长版的侧边栏。顶端是电子邮箱的主要功能链接，用于展示不同类别的邮件，侧边栏的下方则为一些支持工具和扩展包。由于电子邮箱的侧边栏非常的长，“设置”和“帮助反馈”按钮固定在侧边栏底端，方便用户随时访问。

#### 访问记录

当应用程序有明显的“返回首页”功能时，侧边栏应当为系统创建“返回首页”的功能。例如，在 Play Store 应用商店中，点击“返回首页”按钮回到页面“应用程序及游戏”，展示给用户的是所有类别的精选应用。因而 Play Store 应用创建了从其它页面到主页面的返回功能。

同样的，在使用 Google Camera 相机应用时，当用户点击返回键时，返回到相机的默认拍摄界面。

![](https://cdn-images-1.medium.com/max/800/1*lVkPA6HXWIXX83XwkLZFuA.png)

![](https://cdn-images-1.medium.com/max/800/1*1JNy36LE4MknD-fzvblvCg.png)

![](https://cdn-images-1.medium.com/max/800/1*IsXPcy3A3NB0DcuypPqG9A.png)

“开始导航” 圆形按钮增强主地图功能。

谷歌地图（如上）也用了相同的方案，侧边栏的选项要么是在地图上加层，要么增强主地图提供辅助功能。所以当用户点击“返回”按钮时回到的也是默认地图界面。

![](https://cdn-images-1.medium.com/max/800/1*cZMuV29jlk2r-SKVWOTCTw.png)

![](https://cdn-images-1.medium.com/max/800/1*-peWUuc8UOhglfOo2yzsSA.png)

![](https://cdn-images-1.medium.com/max/800/1*nq4Zb0Oc_6_pDfpCIUufGw.png)

你可能会注意到，随着你进入其他页面，Play Store 谷歌商店（上图）工具栏中的侧边栏图标并未改变。这是因为侧边栏的按钮在应用的层级结构中为同一级别。由于用户并没有深入到子级页面（例如，点击“音乐与视频”），因而侧边栏的图标并不会改变成返回上一级的样式。用户始终在最顶级的页面，只不过是在同级页面中切换而已。

---

### 🚨 底部导航（Bottom nav）

![](https://cdn-images-1.medium.com/max/2000/1*ucVh0hZm7BLSQiI-yzet3Q.png)

#### 定义

在安卓系统中，底部导航控件通常由三到五个目的地按钮构成。重要的一点是，“更多”按钮并不能看作一个目的地，更不是菜单或对话框。

当你的应用只有有限个数的顶级页面需要被访问时，使用底部导航栏最合适（底部导航千万不能滚动）。底栏最主要的优点在于，可以从子页面迅速跳入毫无关联的顶级页面，而无需先导航到当前页面的父页面。

值得注意的是，尽管底部导航的链接应当在应用中有相同的层级结构，但是他们和标签页截然不同，也绝不能以标签页的形式展现。

切换底部栏，暗示着两个面板是毫无关系的。每个面板是孤立的父节点，而不是其它面板的兄弟节点。如果你的应用中，两个面板有相同内容或者相同的父节点，也许用标签页是更好的选择。

📚 设计底部导航的更多细节[参考此处](https://material.io/guidelines/components/bottom-navigation.html#)，更多实现[参考此处](https://developer.android.com/reference/android/support/design/widget/BottomNavigationView.html)。

#### 底部导航实例

![](https://cdn-images-1.medium.com/max/800/1*FCTrc2tb_5VLXSLmCGd0Qw.png)

![](https://cdn-images-1.medium.com/max/800/1*xqbx9YxgmpibQQEpXoljHQ.png)

![](https://cdn-images-1.medium.com/max/800/1*3_WrkSIhD7Y7jG9h4nCM6Q.png)

Google Photos 相册应用

除了底部导航的基本定义，还有一些有意思的点值得考虑。也许最复杂的问题就是：底部导航栏是否要持续存在？答案和许多设计决策一样，那就是：“看情况”。

通常底部导航在整个应用中是持续存在的，但在某些情况下，导航栏是隐藏的状态。例如用户使用的应用只有很浅的层次结构，像收发短信这类单一功能的页面，又或者应用想给用户更深刻的用户体验，那底部导航或许隐藏起来更好。

在 Google Photos 相册应用中（上图），底部导航在相册中是隐藏的。相册在整个层级结构中处于第二层，比相册更深一层只有查看相片，打开它时从相册页面顶部展现。这种实现方式满足了隐藏底边导航以达到“唯一目的”的规则。当用户进入程序最顶层时，为其创造沉浸式体验。

#### 其它考虑

如果底部导航在整个应用中持续存在，那么下一个需要考虑的问题便是底部导航的跳转逻辑。假设一个用户在深层层级结构中进行跳转，从一个子页面切换到另一个子页面，再点击返回跳转到前一个子页面，那他到底应该看到哪一个页面呢？父级页面？还是他停留过的子级页面？

这个功能应该取决于应用的使用者。一般来说，点击底部按钮应该直接跳转到关联页面，而不是更深层的页面。不过话说回来还是老问题，**看情况**。

#### 访问记录

底部导航栏的点按不应该为系统“返回键”创建历史记录。不过层级结构中进入深层级可以为系统“返回键”创造系统历史记录，为应用创建“返回上级”访问记录，但是底部栏其本身便是一种具有记录历史特性的导航结构。

点按底部导航按钮，应当直接跳转到关联页面。用户再次点击按钮应当跳转到该栏的父页面，或者当用户以及在父级页面时刷新页面。

---

### 🕹 上下文导航（In-context navigation）

![](https://cdn-images-1.medium.com/max/2000/1*urOlDr3ceb6JiqdQsS4GmQ.png)

#### 定义

上下文导航由所有非上述导航控件间的交互组成。这些控件包括像按钮、方块、卡片，还有其它应用内跳转的内容。

通常，上下文导航和常用导航形式相比，更多是非线性操作 —— 交互行为使用户在层级结构，离散型结构之间任意跳转，甚至跳转到应用之外。

📚 设计上下文导航的更多细节[参考此处](https://material.io/guidelines/patterns/navigation.html#navigation-combined-patterns)。

#### 上下文导航实例

![](https://cdn-images-1.medium.com/max/800/1*kAS321rLOPopo2wj5Pt1rQ.png)

![](https://cdn-images-1.medium.com/max/800/1*Obz9UAi5l2lFxjEA107EXA.png)

![](https://cdn-images-1.medium.com/max/800/1*Ks9Fvut3daB1khAkoB7aaQ.png)

时钟应用，Google 搜索应用，Google 日历应用

时钟应用（左上）设计的很巧妙，有一个浮动操作按钮；Google 搜索应用（中上）主要靠下部卡片维护信息；Google 日历（右上）给每一个日历时间创建块状条目。

![](https://cdn-images-1.medium.com/max/800/1*Ns0RzUEA6qmbQpILjMJMwA.png)

![](https://cdn-images-1.medium.com/max/800/1*OoSmQV5q6nN4gNSoVsIRNQ.png)

![](https://cdn-images-1.medium.com/max/800/1*ZWjwDWr61A5r8TprQiHCVw.png)

在时钟应用里（左上）通过点击浮动按钮，即刻查看世界时钟；在 Google 搜索应用（中上）里点击天气卡片，搜索引擎立马为你展示“天气”的搜索结果；Google 日历（右上）点击块状条目进入事件详情页。

我们也能看出来，这些截图展现了上下文导航给用户带来不一样的跳转体验。时钟应用里，用户进入应用的子级页面；Google 搜索应用使用卡片以增强主屏幕，而 Google 日历是点击打开[全屏窗口](https://material.io/guidelines/components/dialogs.html#dialogs-full-screen-dialogs)。

#### 访问记录

对于上下文导航，并没有对访问记录的硬性规定。访问记录的创建与否完全取决于使用什么形式的上下文导航，还有用户通过导航要去哪里。为了以防万一，在某些情况里应用创建什么类型的历史记录并不明确，设计者最好了解下，在通常情况点击返回键和向上键设置会产生什么操作。

---

### ↖️ 向上键、返回键、关闭键（Up, back, and close buttons）

![](https://cdn-images-1.medium.com/max/2000/1*VBBwhx66_hRZApzdLzVrJA.png)

返回键，向上键，关闭键这三个按键在安卓用户界面里都非常重要，但却常常被理解错误。实际上，从用户体验的角度，三个按钮都很简单，只要熟记下面的几条规则，保证再也不会陷入困惑。


- **向上键**往往是当用户沿着应用层级结构返回上级菜单时使用到，常出现于应用工具栏。点击向上键，窗口延时间先后顺序后退直到用户到达最顶级父页面。由于顶级父页面无法再往上跳出应用，向上键不应该出现在顶极父页面中。

- **返回键**存在于系统底部导航栏。它的导航作用是沿时间顺序后退，而非应用页面的层级关系，哪怕前一个时间节点是在其它应用中。它还用于关闭临时页面元素，比如对话框，底部表单等层叠面板。

- **关闭键**通常用于关闭界面临时层，或者放弃修改[全屏对话框](https://material.io/guidelines/components/dialogs.html#dialogs-full-screen-dialogs)。例如 Google 日历事件详情页（下图）。全屏日历事件详情页面属于很明显是临时页，设计时使用关闭键。Google 邮箱应用（下图）中，从收件箱到邮件正文的渐进效果显示，邮件正文是收件箱页面的叠加层，因此使用关闭键较合适。 而 Gmail 应用中（下图）邮件正文是作为一个独立层存在于应用中的，因此返回键更合适。

![](https://cdn-images-1.medium.com/max/800/1*zgH-Iq78hKbjiy-WaGl2uQ.png)

![](https://cdn-images-1.medium.com/max/800/1*BTqU6jg683KlT9cOZ98hpg.png)

![](https://cdn-images-1.medium.com/max/800/1*4NyzX3EnqcytgxgfDRuzLg.png)

日历应用，邮箱应用，Gmail 应用

📚更多关于 后退键 vs 返回键 用户行为探讨，尽在 [Material Design](https://material.io/guidelines/patterns/navigation.html#navigation-up-back-buttons)。

### 🔄 混合模式（Combining patterns）

尽管在这份初学者指南中，我们主要分析了使用单个导航组件的成功案例。实际上，这些应用在组合运用多类导航时仍然表现出色，构建了合理的用户行为框架。在文章结尾，我们来看看几个混搭实例。

![](https://cdn-images-1.medium.com/max/800/1*N_M792Hp2LBETAXjYgC3sw.png)

![](https://cdn-images-1.medium.com/max/800/1*RHPlqE4izZiFmNfXnkYSpg.png)

![](https://cdn-images-1.medium.com/max/800/1*SzghlBq-oWtLHwLaA85t1Q.png)

Google+

可能最显而易见的实例便是 Google+（上图），混合上述所有元素 —— 标签页、底部导航、上下文导航。

分离来看，底部导航是 Google+ 的焦点，可以访问四个顶级页面。而标签页将页面结构化增强，通过不同类别拆分内容。而侧边栏囊括了剩余其它按钮，以访问频率区分主次。

![](https://cdn-images-1.medium.com/max/800/1*cZMuV29jlk2r-SKVWOTCTw.png)

![](https://cdn-images-1.medium.com/max/800/1*IY9Ow4NVywiIC9YgfXlM4Q.png)

![](https://cdn-images-1.medium.com/max/800/1*GcX2vbkwoA8iGm3RwTsJVQ.png)

Google Play 应用商店

Google Play 应用商店（上图）使用侧边栏当作主要导航，大量使用上下文导航，局部使用标签页导航。

上图中，我们看到所有从侧边栏进入的页面中，打开侧边栏的图标始终是可点按的，因为这些页面都是最顶级父页面。在顶端工具栏下方，小椭圆片帮助细分页面内容，是典型的上下文导航。在应用下载统计页面，标签页将排列好的应用分门别类。

![](https://cdn-images-1.medium.com/max/800/1*c2rK-Zvz7W7aFThPSFqrJg.png)

![](https://cdn-images-1.medium.com/max/800/1*reXFTc6r_28x082Iyl74_A.png)

![](https://cdn-images-1.medium.com/max/800/1*ZWjwDWr61A5r8TprQiHCVw.png)

Google 日历应用

Google 日历应用（上图）巧妙得使用了侧边栏导航和上下文导航。此处侧边栏是一个非标准的日历增强面板。日历本身由可扩展的工具栏控制，不同颜色的色块表示用户的日历事项，点击进入详情即可查看详细日程。

📚 更多混合导航实例[参考此处](https://material.io/guidelines/patterns/navigation.html#navigation-patterns)。

### 🤔 更多问题?

导航本身是一个很复杂的话题，希望这篇导航初识能帮助到读者，对安卓导航的设计原理有一个较好的理解。如果你还有其它问题，欢迎留言或在推特 [#AskMaterial](https://twitter.com/search?q=%23AskMaterial) 话题下与 [Material Design](http://Material.io) 进行互动，当然还有我们团队账号，[猛戳这里](https://twitter.com/i/moments/884845596145836032)关注!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
