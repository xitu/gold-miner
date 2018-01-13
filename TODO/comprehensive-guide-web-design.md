> * 原文地址：[A Comprehensive Guide To Web Design](https://www.smashingmagazine.com/2017/11/comprehensive-guide-web-design/?utm_source=frontendfocus&utm_medium=email)
> * 原文作者：[Nick Babich](https://www.smashingmagazine.com/author/nickbabich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/comprehensive-guide-web-design.md](https://github.com/xitu/gold-miner/blob/master/TODO/comprehensive-guide-web-design.md)
> * 译者：[horizon13th](https://github.com/horizon13th)
> * 校对者：[pot-code](https://github.com/pot-code)
        
# A Comprehensive Guide To Web Design
# 网站设计综合指南

**摘要**

**（此博文为赞助博文）** 网站设计往往是个棘手的问题。在设计网站时，设计师和开发者往往需要考虑很多要素，从视觉表现（网页看起来如何）到功能设计（网站用起来如何）。为了细化网站设计任务，我们为读者呈上此文。

本文将着重讲述设计主旨，设计启发，设计方法，为你的网站打造更好的用户体验。我们从大方向着手，例如用户旅程（怎样定义网站“骨架”），细化到单一页面（网页设计需要考虑什么）。同时我们也会提及其他的设计要素，例如移动端支持与测试。

#### 目录

**设计用户旅程 Designing The User Journey**

1.  [信息架构 Information Architecture](#information-architecture)
2.  [全局导航 Global Navigation](#global-navigation)
3.  [链接与菜单项 Links and Navigation Options](#links-and-navigation－Options)
4.  [浏览器的“后退”按钮 “Back” Button in Browser ](#back-button-in-browser)
5.  [面包屑导航 Breadcrumbs](#breadcrumbs)
6.  [搜索栏 Search](#search)

**设计独立页面 Designing Individual Pages**

1.  [内容策略 Content Strategy](#content-strategy)
2.  [页面结构 Page Structure](#page-structure)
3.  [视觉层级 Visual Hierarchy](#visual-hierarchy)
4.  [滚动行为 Scrolling Behavior](#scrolling-behavior)
5.  [内容加载 Content Loading](#content-loading)
6.  [按钮 Buttons](#buttons)
7.  [图像 Imagery](#图片来源ry)
8.  [视频 Video](#video)
9.  [CTA 按钮 Call-to-Action Buttons](#call-to-action-buttons)
10.  [网页表单 Web Forms](#web-forms)
11.  [动画 Animation](#animation)

**移动端支持 Mobile Considerations**

1.  [响应式网页设计 Practice Responsive Web Design](#practice-responsive-web-design)
2.  [从鼠标点击到手势 Going From Clickable to Tappable](#going-from-clickable-to-tappable)

**无障碍设计 Accessibility**

1.  [弱视用户 Users With Poor Eyesight](#users-with-poor-eyesight)
2.  [色盲用户 Color Blind Users](#color-blind-users)
3.  [盲人用户 Blind Users](#blind-users)
4.  [键盘流用户体验 Keyboard-Friendly Experience](#keyboard-friendly-experience)

**测试 Testing**

1.  [迭代测试 Iterative Testing](#iterative-testing)
2.  [网页加载时间测试 Test Page-Loading Time](#test-page-loading-time)
3.  [A/B 测试 A/B Testing](#a-b-testing)

[**开发者交接 Developer Handoff**](#developer-handoff)

[**结语 Conclusion**](#conclusion)

### Designing The User Journey 设计用户旅程

#### Information Architecture 信息架构

“信息架构”（IA）这个术语通常被误用来表示网站的目录结构。但其实这是不正确的，尽管网站菜单是信息架构的一部分，但它也仅仅是一个方面。

信息架构指，将信息以清晰逻辑的方式组织。这种结果遵循一个目标：**帮助用户在复杂信息集合中导航**。好的信息架构提供了与用户预期一致的层级结构。然而优秀的层级结构，直观的导航都不是偶然出现的，而是用户调研和用户测试的结果。

调研用户需求的方法众多。通常来说，信息架构多用于用户调研（如用户访谈，卡片分类法）：调研人员倾听用户期望，观察潜在用户如何将复杂的信息组进行归类。信息架构同样需要可用性测试的结果，来看用户是否可以方便地导航。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/37-A-Comprehensive-Guide-To-Web-Design-800w-opt.jpg)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/37-A-Comprehensive-Guide-To-Web-Design-800w-opt.jpg)

卡片分类法简单实操，志于帮设计人员弄清：如何最优地基于用户输入将内容组织分类。信息架构与卡片分类法相似，都能典型地呈现出清晰的模式。（图片来源： [FosterMilo](http://www.fostermilo.com/articles/card-sorting-with-creative-albuquerque)）

在设计网页界面前，往往要进行例行步骤：设计者基于用户访谈设计网站导航结构，用卡片分类法测试该结构是否符合用户的思维模式，用户体验研究者用“树形测试法”对导航结构进行验证。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/36-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/36-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

树形测试法能够可靠地验证，用户能否根据现有目录结构进行导航。
（图片来源: [Nielsen Norman Group](https://www.nngroup.com/articles/tree-testing/)) ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/36-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### Global Navigation 全局导航

导航是可用性的基石。如果用户在网站中难以定位，无所适从，网站再怎么好也没用。网站导航设计需要遵从下列原则：

*   **简易性** 导航应以这样的方式设计，访问者到达目的地点击次数越少越好。
*   **清晰性** 用户不需要猜测导航选项的含义，每一个菜单项对于来访者来说不言自明。
*   **一致性** 对于整个网站的所有页面，导航体系必须统一。

设计导航时需要考虑如下几点：

*   **根据用户需求选择导航模式** 导航设计必须遵循主流用户的需求。目标用户群期望某种特定类型的网站交互，那就以你独到的方式，让用户满足预期吧～例如：如果大部分用户都不知道汉堡包图标是啥意思，就避免使用该图标展示导航。
*   **将导航选项区分优先次序** 有一种简单的方法来区分导航选项优先级：将用户行为任务按照不同优先级排序（高级，中级，低级），然后在布局中突出显示高优先级的用户行为路径，以及被频繁访问的节点。
*   **使重要选项可见** 正如 [Jakob Nielsen](https://www.nngroup.com/articles/ten-usability-heuristics/) 所言，识别出某事比回忆起某事容易。为了减小用户记忆负担，将所有重要菜单项设为一直可见。这些最重要的菜单项应该一直可用，而不仅在我们预期用户需要的时候展现。
*   **传达当前位置信息** “我在哪”是用户进行有效导航时需要回答的最基本问题。许多网站有此常见错误：不显示用户的当前位置，因而如何定位的问题也值得深究。

#### Links and Navigation Options 链接与菜单项

链接、菜单项是导航过程中的要素，直接作用于用户旅程，这些交互元素遵循下列规律：

*   **区别站内链接与外部链接** 用户期望站内链接和外部链接为不同的交互行为。所有内部链接应当在当前标签页打开，这样用户便可以在当前窗口使用“后退”按钮。如果决定在新窗口打开外部链接，应当在自动打开新标签页／新窗口前提醒用户。这可能需要声明（在新窗口打开），将其以文本的形式添加到链接文本中。
*   **标记已经访问过的页面** 如果访问过的链接没有修改颜色标记，用户很可能无意中重复访问。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/20-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/20-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

<figcaption>用户通过颜色标记，识别出曾访问过的页面，避免无意重复访问同一页面。

*   **认真核实所有链接** 当用户点击链接却返回 404 错误时，会极其不爽。当访问者浏览内容时，期望所有的链接都指向链接所指，而不是其它不相关页面，更不能容忍 404 页面。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/11-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/11-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

#### “Back” Button in Browser 浏览器的“后退”按钮

后退按钮是浏览器上第二重要的界面控制（仅次于最最重要的 URL 地址栏），要确认“后退”按钮符合用户预期。当用户跟着链接来到某页面，然后点击“后退”键时，他们期望恰好返回到前一网页的离开的位置。**尤其要避免点击“后退”按钮却回到了原页面顶端的情况**。失去用户原先的焦点会使用户被迫重复浏览已读内容。由于没有恰好“后退”原位，用户会迅速失去耐心。

#### Breadcrumbs 面包屑导航

面包屑导航是系列链接的集合，用于索引网站的当前位置。它是一种次级定位规则，常用于显示用户当前在网站的位置。

虽然该元素不需要过多解释，有几点还是值得注意：

*   **不要使用面包屑作为主导航的替代品** 主导航是引导用户的主导元素，然而面包屑只是支持元素。使用面包屑而非其他元素作为主导航，通常意味着导航设计较差。
*   **使用箭头作为分隔符，而非斜杠。清晰分离导航层级** 推荐使用大于号（>）或右箭头（→），因为此类符号包含方向信息。不推荐在电商网站中使用左斜杠（／）作为分隔符。如果你非要用的话，请确保商品类别不包含斜杠。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/27-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/27-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

此面包屑的层级关系简直难以分辨 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/27-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### Search 搜索栏

有些用户为了某特定目标访问网站，他们并不想使用导航功能。此时用户只想在搜索栏输入文字，提交搜索查询，返回他们寻找的页面。

设计搜索栏时考虑下列基本规则：

*   **将搜索栏放在用户所期望的地方** 下图是基于 A. Dawn Shaikh 和 Keisi Lenz 的研究，通过对 142 名参与者的问卷调查，画出的用户对于搜索栏的期望位置。这一研究发现，搜索栏的最佳摆放位置是网站的左上角和右上角。这样用户通过"F-型"浏览模式可以轻易找到搜索栏。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/34-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/34-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

*   **富文本网站中突出显示搜索功能**
    如果搜索功能是你的网站重要功能，显著地显示出来，因为这可以是用户探索的最快路径。
*   **合理设计输入栏尺寸**
    输入框太窄是设计者的常犯错误。诚然，用户可以在短文本框中输入长文字，但是一次只能显示部分文字。这固然是不好的设计，因为不能同一时刻显示整个查询条件。实际上，当搜索栏很短时，用户被迫使用短小，模糊的查询条件，因为搜索条件太长看不到。Nielsen Norman Group 推荐使用 [27-字符输入框](https://www.nngroup.com/articles/top-ten-guidelines-for-homepage-usability/) ，适用于 90% 的查询。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/35-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/35-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)

*   **在所有页面放置搜索栏**
    在所有页面放置搜索栏的好处是，当用户不能定位他们想要查看的内容时，便会尝试搜索功能，无论他们当时在页面哪个地方。

### Designing Individual Pages 设计独立页面

#### Content Strategy 内容策略

内容策略的重点在于页面对象的设计。理解页面目标，根据目标定位绘制页面。

我们提出如下提高页面内容理解的实践技巧：

*   **避免信息过载** 信息过载是非常严重的问题，它阻碍了用户交互和用户决策，这是由于用户感到信息量多到难以消化。减小信息过载有一些简单的方法。最常用的方法便是组块算法 —— 分解内容为更小的内容块，这有助于用户更好地理解整个流程。结账表单便是一个很好的例子。在同一时刻最多显示五到七个输入框，将整个结账流程分解在不同页面，渐进地按需展示字段。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/43-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/43-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

(图片来源: [Witteia](https://twitter.com/witteia)) ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/43-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

*   **避免生僻词和专业术语** 页面上任意一个生僻难懂的术语都会激增用户的认知负载。最安全的策略是将受众定位所有阶段用户，选择清晰易懂的词语以适应不同类组的用户。
*   **长段落细分** 对于信息过载这一点，除非网站定位主打内容消费，否则在设计时要尽量避免长段文字。举例说明，如果你想写个服务介绍或产品介绍，尽量一步一步来，慢慢展开细节。使用短小、视野内可见的模块以让用户逐步探索。根据 [Robert Gunning](https://www.amazon.com/How-Take-Fog-Business-Writing/dp/0850132320) 的《看透商业评论编写》，一句话字数最好在 20 个字以内。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/29-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/29-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)

(图片来源： [The Daily Rind](http://www.dailyrindblog.com/wp-content/uploads/2013/04/Presentations_UsePlainEnglish.png))

*   **避免所有字母大写** 英文内容中，全字母大写的模式，仅适用于短小文字如缩略语或 Logo。避免对长单词使用全大写模式：段落、表格标注、错误提示、通知信息等。正如 [Miles Tinker](http://en.wikipedia.org/wiki/Miles_Tinker) 的 《字体的可读性》所说，全字母大写会使阅读速度骤减，且多数读者会感到全字母大写的可读性较低。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/24-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/24-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

英文全大写使读者感到阅读困难。

#### Page Structure 页面结构

一个结构恰当的页面会使用户界面布局上的元素清晰。尽管我们没有适用于所有场景的统一的尺寸标准，遵循下列几个指导方针有助于设计一个靠谱的页面结构：

*   **使结构具有可预见性** 设计要与用户预期保持一致，在设计时考虑相似类型的网站，看看它们都使用了什么元素，摆放在哪里。尽量使用目标受众熟悉的视觉模式。
*   **使用网格布局** 网格布局将页面分割成几个主要区块，根据元素大小、位置定义元素之间的关系。使用网格布局，可以轻松的将众多元素组合成高内聚型的布局。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/15-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/15-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

网格和布局系统是设计届的传统，Adobe XD 的网格布局帮助设计稿适用于多种屏幕尺寸的设备并保持一致性，定制化网格系统以调整元素间比例。

*   **使用低保真的线框稿图避免杂乱** 乱七八糟的杂项使界面超负荷难以理清。每个新增的按钮，图片，甚至文字都会增加页面的复杂度。在使用真实元素构造页面前，先画简单的线框原型并分析，删除所有非必须元素。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/06-A-Comprehensive-Guide-to-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/06-A-Comprehensive-Guide-to-Web-Design-large-opt.png)

使用 [Adobe XD](http://www.adobe.com/products/xd.html) 绘制的低保真原型图 (图片来源： [Tim Hykes](http://timhykes.com/lcblog.php)) ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/06-A-Comprehensive-Guide-to-Web-Design-large-opt.png))

#### Visual Hierarchy 视觉层级

人们通常更喜欢快速浏览页面，而不是细细品味每一个细节。因此，当来访者想找某个内容或者完成某个任务时，往往会扫视页面寻找目标。此时，设计师对视觉层级关系的良好呈现就帮用户了一个大忙。视觉层级特指：元素的展示方式能够表现其重要程度。简单来说就是，用户第一眼该看哪儿，第二眼该看哪。一个好的视觉层级使页面浏览更加便捷。

*   **遵循本能的浏览布局** 作为设计师，我们可以在很多方面操控用户浏览页面的焦点。为访客的眼动设定正确的浏览路径，我们可以遵循两类本能的浏览布局：[“F-形”布局](https://uxplanet.org/f-shaped-pattern-for-reading-content-80af79cd3394) 和 [“Z-形”布局](https://uxplanet.org/z-shaped-pattern-for-reading-web-content-ce1135f92f1c). 对于富文本页面，如文章、搜索结果，“F-形”布局效果更好；“Z-形”布局更适用于非文本式页面。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/09-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/09-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

CNN 使用的“F-形”布局 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/09-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/40-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/40-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

Basecamp 使用的“Z-形”布局 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/40-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

*   **重要元素视觉优先** 使页面标题、登录表单、导航栏、这类重要内容成为焦点，供用户更好地使用。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/01-A-Comprehensive-Guide-to-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/01-A-Comprehensive-Guide-to-Web-Design-large-opt.png)

图中 Learn More About Brains 按钮（了解更多关于大脑产品）突出吸引用户行为，突出显示。([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/01-A-Comprehensive-Guide-to-Web-Design-large-opt.png))

*   **画原型使视觉层级更清晰** 原型设计（Mockup）帮助设计师通览整个布局，看到页面填充真实数据之后可能的样子。而且，在原型中重组元素比开发过程中再重新排列要简单得多。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/28-A-Comprehensive-Guide-To-Web-Design-800w-opt.jpg)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/28-A-Comprehensive-Guide-To-Web-Design-large-opt.jpg)

使用 Adobe XD 设计原型。 (图片来源： [Coursetro](https://coursetro.com/posts/design/28/Website-Design-in-Adobe-XD-Tutorial)) ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/28-A-Comprehensive-Guide-To-Web-Design-large-opt.jpg))

#### Scrolling Behavior 滚动行为

很多网页设计者有个固执的错误观念：用户不会使用滚动条。我再重申一次：如今，[人人都会用滚动条](http://www.hugeinc.com/ideas/perspective/everybody-scrolls)!

提高网页滚动体验可以通过以下几点：

*   **鼓励用户的滚动行为** 尽管用户实际在页面加载时就开始[滚动滑轮](http://www.lukew.com/ff/entry.asp?1946)，页面顶端的内容同样非常重要。顶端的内容限定了用户对网站的印象和期望。用户的确会向下拉滚动条，但仅仅会发生在非隐藏内容足够吸引人。因而，记得将最引人注目的内容放在页面顶端：
    *   **展示好的[网站介绍](https://www.nngroup.com/articles/blah-blah-text-keep-cut-or-kill/).** 优秀的网站简介创造了良好的内容场景，回答用户最初的疑问“这是干什么的网站？”
    *   **使用[吸引人的影像](https://www.smashingmagazine.com/2017/01/more-than-just-pretty-how-图片来源ry-drives-user-experience/)** 用户会对相关的图片影像特别感兴趣。
*   **固定导航栏** 当你需要建一个长页面时，记住：用户需要有定位感（当前位置）和方向感（访问其他路径）。长页面会使用户有定位困难。当页面很深时，如果下滑时顶部导航消失，用户必须持续向上滑动返回顶端。 显然， [粘性导航栏](https://www.smashingmagazine.com/2012/09/sticky-menus-are-quicker-to-navigate/) 既可以显示当前位置，又可以使屏幕长时间保持一致性。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/14-A-Comprehensive-Guide-To-Web-Design.gif)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/14-A-Comprehensive-Guide-To-Web-Design.gif)

滚动触发的粘性导航栏 (图片: Zenman)

*   **加载新内容时提供视觉反馈** 当网页是动态加载时，视觉反馈异常重要（比如新闻流）。由于滚动时内容需要很快加载（不能超过 10 秒 ），你可以使用[加载中](https://www.smashingmagazine.com/2016/12/best-practices-for-animated-progress-indicators/#types-of-progress-indicators)动画表示系统正在处理。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/04-A-Comprehensive-Guide-to-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/04-A-Comprehensive-Guide-to-Web-Design-800w-opt.png)

细节动画（例：Tumblr的加载提示）告诉用户更多内容正在加载。

*   **不要绑架用户的滚动行为** 对滚动行为进行绑架最烦人了，由于这种行为从用户手里抢夺了控制权，使其对滚动行为无法预知。设计网站时，请让用户能够主动控制浏览和滚动行为。

[![Tumbler’s signup page uses scroll hijacking.](https://www.smashingmagazine.com/wp-content/uploads/2017/11/tumblr-blogs-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/tumblr-blogs-large-opt.png)

Tumbler 的注册页对用户的滚动条进行绑架 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/tumblr-blogs-large-opt.png))

#### Content Loading 内容加载

内容加载得多说几句才讲得清楚些。尽管立即响应是最好的，但在某些场景下你的网站需要多点时间来为访客传递内容。网络链接差会减慢反应速度，或者有些操作需要多点时间来完成。但是不论这些行为是由什么原因造成的，网站必须看起来是快速响应的。

*   **确保常态加载不需要过多时间** 网站访客的注意力范围和耐心都较低。根据 [Nielsen Norman Group 的研究](https://www.nngroup.com/articles/powers-of-10-time-scales-in-ux/)，10 秒大概是用户在同一任务上集中注意力的极限了。当访客不得不等待网站加载时，他们会非常沮丧，如果响应速度不够快用户很可能马上关窗口走人。

*   **加载时显示网页骨架** 许多网站使用进度条显示数据加载进度。进度条背后的动机很好（提供视觉反馈），但有时适得其反。正如 [Luke Wroblewski 提到的](http://www.lukew.com/ff/entry.asp?1797)，“进度条从定义上就提示用户一个事实：给我等着。就好像看着钟表滴答倒数 —— 当你等待时会感到时间过得更慢。进度条有一个很棒的替代元素：页面框架。这些容器在本质上可看作是网站空白页面的临时版本，信息可以逐渐加载进容器。使用页面框架替代进度条，设计师能聚焦用户的注意力于实际的页面加载，为之后将要加载的页面搭建用户的心理预期。而且这种方式给用户创造了一种事件发生的很快的幻觉。因为信息是逐步加载显示的，用户在等待过程中能切身感到，网站正在一步步处理页面并显示。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/10-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/10-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

Facebook 使用网站骨架，填充页面时内容逐步加载。([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/10-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### Buttons 按钮

按钮在创建流畅的交互体验中至关重要。基本实践中值得注意以下几点：

*   **确保可点击的元素看起来可以点击** 使用按钮和其他交互元素时，需要考虑设计如何传递可用性信息。用户如何将设计元素理解为按钮？表单应当遵循如下功能：对象的表现形式反映了其使用方式。视觉元素看起来像链接或者按钮，但实际上不能点击（例如：下划线文字不是链接、方形按钮形状但是不能点击）诸如此类情况会困扰到用户。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/08-A-Comprehensive-Guide-to-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/08-A-Comprehensive-Guide-to-Web-Design-large-opt.png)

左上角的橙色框是按钮吗？ 不是，但其形状和标签让它看起来像一个按钮。 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/08-A-Comprehensive-Guide-to-Web-Design-large-opt.png))

*   **基于实际用途命名按钮** 可交互的界面元素命名应该和它的实际用途一致，以符合用户的期望。当用户知道这个按钮的作用时，会用起来更舒适。含糊的标签例如“提交”，或者抽象的标签例如下图中的例子，都无法给用户提供交互的有效信息。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/12-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/12-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

别让用户对界面元素产生疑惑 (图片来源： [UX Matters](http://www.uxmatters.com/mt/archives/2012/05/7-basic-best-practices-for-buttons.php))

*   **设计按钮时保持一致性** 不论是否是下意识地，用户都会记住网站的细节。当浏览网站时，他们会将特定形状和功能联系到一起。因此，一致性不仅有利于设计美观，且增强了用户的熟悉感。下图完美例证了这一点。在应用的同一模块（例如系统工具栏）使用三种不同的形状不仅很迷惑用户，而且看起来很不专业。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/31-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/31-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

保持一致

#### Imagery 图像化

俗话说得好，一张图片胜过千言万语。人类都是视觉动物，几乎能够瞬间处理视觉信息；我们所感知的  [90% 的信息](http://www.webmarketinggroup.co.uk/blog/why-every-seo-strategy-needs-infographics/) 都是通过视觉传达给大脑。图像是捕捉用户注意力以区分产品的最有力方式。相比于一段精心设计的文本，一张图片能够传递给读者更多信息。而且，图像能跨语言障碍，表达文字所不能表述的内容。

下列原则可以帮助你在网站设计中融入图像元素：

*   **确保图像相关性** 设计中最怕传递错误信息的图像。选择最符合你产品目标的图像，确保它与上下文相关。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/space-image25-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/space-图片来源25-large-opt.png)

与主题无关的图像引起用户的困惑 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/space-图片来源25-large-opt.png))

*   **避免使用通用的人像** 在设计中使用人脸是吸引用户的有效方式。看到人脸能让用户感觉与他们联系在一起，而不仅仅是在销售产品。然而，许多企业网站使用通用的照片来建立信任感是非常糟糕的。[可用性测试](https://articles.uie.com/deciding_when_graphics_help/)表明这样的照片很难增加设计的价值，反倒会使用户体验变差。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/46-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/46-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

不真实的图像给用户带来一种虚伪的感觉。 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/46-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

*   **使用高质量不失焦的图片资源** 网站使用资源质量很大程度上影响着用户印象和对服务的期望。确保图像大小在各平台合比例显示。图像不能出现像素化，因而要测试各种比例、各种分辨率的设备。以原始的长宽比例显示图像。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/45-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/45-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

低质量的照片 VS 高质量不失焦的图片 (图片来源： [Adobe](https://blogs.adobe.com/creativecloud/more-than-just-pretty-how-图片来源ry-drives-ux/)) ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/45-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### Video 视频

随着网速的提快，视频越来越流行，尤其考虑到视频[延长了用户停留时长](https://www.forbes.com/sites/forbesagencycouncil/2017/02/03/video-marketing-the-future-of-content-marketing/). 如今视频无处不在：PC 端，平板端，移动端。将视频有效利用起来，它能最有效的吸引用户 —— 视频传递更多情感，更用心的带给用户产品服务体验。

*   **将视频设置为默认静音，用户可以选择性开启音量** 当用户访问一个页面时，并没有对声音的预期。而且大多数用户并不会使用耳机，这时他们会紧张的想要快点关闭声音。甚至在大多数情况下，一听到声音立即关闭网站。


[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/22-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/22-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

Facebook 的视频会在用户访问时自动播放，除非用户主动打开声音，否则会默认静音。([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/22-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

*   **广告视频越短越好** 根据 [D-Mak Productions](http://dmakproductions.com/blog/what-is-the-ideal-length-for-web-video-production/) 的研究，短视频对大多数用户更有吸引力。因此，最好将商业视频保持在两到三分钟的范围内。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/26-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/26-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

(图片来源： [Dmakproductions](https://dmakproductions.com/blog/what-is-the-ideal-length-for-web-video-production/))

*   **提供内容的其它展示方式** 如果视频是内容的唯一消费方式，这会限制到那些看不懂，听不懂的用户。建议提供字幕、完整的视频文字版作为辅助选项。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/38-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/38-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

字幕使用户更易获取视频内容。 (图片来源： [TED](https://www.ted.com)) ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/38-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### Call-to-Action Buttons CTA 按钮

召唤行动 Calls to action (CTA) 指的是引导用户实现转化率的按钮。CTA 重点在于引导用户执行我们期望的行为。 常见的CTA的例如：

*   开始试用
*   立即下载查看
*   立即注册获取最新资讯
*   开始咨询

设计 CTA 按钮时需要考虑以下几点：

*   **尺寸** CTA 按钮应该足够大，稍远距离也能看见；但又不能太大，会影响到用户对其它内容的关注。想要确认 CTA 按钮是该页面上最显著的元素，试一下五秒钟测试法：浏览网页五秒钟，然后记录下你还记得的内容。 如果 CTA 被你记下来了，那它的大小合适~
*   **视觉优先** CTA 按钮的颜色很大程度上影响着用户的注意力。通过颜色增加视觉冲击力，可以让某些按钮比其他按钮更突出。对比色非常适合用于 CTA，使其特别醒目。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/42-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/42-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

火狐页面上绿色的 CTA 按钮非常醒目，立马抓住用户眼球。([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/42-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

*   **对比空间** CTA 按钮周围的空间大小也很重要。白色（或对比色）的空间为按钮创建了留白区域，将按钮与界面中其他元素分割开。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/16-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/16-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

 旧版本的 Dropbox 主页是使用对比空间来突出 CTA 的很好例证。深蓝色的“免费注册”CTA 按钮与淡蓝色的背景形成对比反差。([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/16-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

*   **基于行为的文案** 编写吸引用户行动的文案。以“开始”，“获取”或“加入”这类动词开头。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/30-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/30-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

 Evernote 的 CTA 虽然常见但也最有效得传达了行动。 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/30-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

**提示：** 你可以通过模糊效果快速测试 CTA。模糊测试是判断用户的眼神是否会落在想要位置的最便捷方法。将网页截图在 [Adobe XD](https://helpx.adobe.com/experience-design/help/background-blur.html) 中应用模糊效果（参考下图示例）。看看页面的模糊版本，哪些元素会突出显示？如果这不是你想要的效果，再次修改。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/02-A-Comprehensive-Guide-to-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/02-A-Comprehensive-Guide-to-Web-Design-large-opt.png)

<figcaption>模糊测试是一种检验设计焦点和视觉层次的技术。([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/02-A-Comprehensive-Guide-to-Web-Design-large-opt.png))

#### Web Forms 网页表单

表单填写是网页最重要的互动类型之一。事实上，表单通常被认为是完成目标的最后一步。确保用户可以快速填写表单，不会出现疑问。表单就像是一个对话框：用户和网站双方之间应该有逻辑的沟通。

*   **只问必须问的问题** 只要求用户填写真正需要的内容。表单的任意一个额外字段都会影响转换率。每次都想清楚你为什么需要这些信息，你将如何使用这些信息。
*   **合理排列表单问题** 表单上的问题应该从用户视角出发，符合用户逻辑。例如，在填写名字之前先填写地址就不合逻辑。
*   **整合相关联的字段** 将相关的字段信息整理在同一个逻辑单元中。从一系列问题到下一系列问题的流程更像是一个对话。将相关字段整合分组更有助于用户理解信息。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/50-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/50-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

将相关字段整合在一起 (图片来源: Nielsen Norman Group)

#### Animation 动画

越来越多的设计师提倡 [动画即功能](https://www.smashingmagazine.com/2017/01/how-functional-animation-helps-improve-user-experience/) 来提升用户体验。动画不再仅仅为了有趣，它是提高交互效率的重要工具之一。然而，动画只有在合适的时间和场景下才能提升用户体验。好的交互动画有这样的目标：它是有意义的、功能性的。

以下是动画提升用户体验的一些场景：

*   **对用户行为的视觉反馈** 好的交互设计提供了视觉反馈。当你需要告知用户操作的结果时，视觉反馈非常有效。如果操作执行失败，动画可以简捷地为用户提供反馈。例如，输入密码错误时可以使用摇动效果。这很好理解，摇动效果作为常用体势，在人际沟通中普遍意味着“不”。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/44-A-Comprehensive-Guide-To-Web-Design.gif)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/44-A-Comprehensive-Guide-To-Web-Design.gif)

 用户看到动画后，秒懂问题出在哪 (图片来源： [The Kinetic UI](http://thekineticui.com/your-app-login-is-boring/))

*   **系统状态的可见性**[Jakob Nielsen 的十大启发式可用性](http://www.nngroup.com/articles/ten-usability-heuristics/)中，系统状态的可见性是用户界面设计最重要的原则之一。用户随时随地都想知道当前的位置，而不能让他们一直猜测 —— 应用应该通过适当的视觉反馈告诉用户现在的状态。数据上传和下载操作是功能性动画的常见场景。例如，加载动画显示了任务的进度、处理的速度，并在用户心中奠定了后续可能的处理速度。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/39-A-Comprehensive-Guide-To-Web-Design.gif)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/39-A-Comprehensive-Guide-To-Web-Design.gif)

(图片来源： [xjw](https://dribbble.com/xjw))

*   **导航式动画** 导航式动画是指网站上各个状态间的切换 —— 例如，从概述视图到详细视图。状态切换往往涉及到大面积场景更换，有时候用户思维难以跟上。功能性动画能简化用户对场景转变过程的适应，在场景切换之间平滑过渡，并通过在场景的状态变化中插入视觉连接来凸出变化所在。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/47-A-Comprehensive-Guide-To-Web-Design.gif)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/47-A-Comprehensive-Guide-To-Web-Design.gif)

(图片来源： [Ramotion](http://ramotion.com))

*   **品牌推广** 假设你有十几个相同功能的网站，帮用户完成相同任务。它们都能提供良好的用户体验，但用户最喜欢的不仅仅是良好的用户体验。网站应该与用户建立情感联系。此时品牌动画在吸引用户方面起着决定性作用。它会形成公司的品牌价值，突出产品优势，使用户真正感到愉悦，令人难忘。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/05-A-Comprehensive-Guide-to-Web-Design.gif)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/05-A-Comprehensive-Guide-to-Web-Design.gif)

(图片来源： [Heco](https://www.helloheco.com/))

### 移动端支持

如今，将近 [50% 的用户](https://www.statista.com/topics/779/mobile-internet/)通过移动设备访问网页。这对网站设计师意味着什么？这意味着我们设计的每一个页面都必须支持移动端。

#### 响应式网页设计

针对不同的桌面浏览器、移动浏览器优化你的网站，每一平台的浏览器都有不同的屏幕分辨率，技术支持和用户基础。

*   **单栏布局目标** 单栏布局通常在移动设备上效果很好。单栏布局不仅能有效应对小屏幕的有限空间，而且在不同分辨率的设备上、横竖屏模式中自如伸缩。
*   **使用 Priority+ 模式优化断点式导航栏** [Priority+](http://justmarkup.com/log/2012/06/19/responsive-multi-level-navigation/) 是 Michael Scharnagl 提出的术语，用来描述导航栏展示重要的导航选项，隐藏次要的导航选项于“更多”按钮中。这种模式充分利用了可用的屏幕空间。当屏幕拉伸时，导航选项随之增加，从而提高了网站的可视性和参与度。这种模式在多模块富内容的网站尤为有效（例如新闻网站、大型电商网站）。图例中卫报使用 Priority+ 模式进行模块导航。次要选项仅在用户点击“All”按钮时显示。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/51-A-Comprehensive-Guide-To-Web-Design.gif)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/51-A-Comprehensive-Guide-To-Web-Design.gif)

卫报使用 Priority+ 模式进行模块导航(图片来源： [Brad Frost](http://bradfrost.com/blog/post/revisiting-the-priority-pattern/))

*   **确保图像在多个设备端适应尺寸** 网站必须完美适应于所有设备，适应不同分辨率的屏幕、像素密度、放置方向。在设计者构建响应式网站时，主要挑战之一便是图像的管理适配与呈现。为了简化这个任务，可以使用 [响应式图片断点生成器](http://www.responsivebreakpoints.com/) 这类工具处理图像。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/52-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/52-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

响应式图片断点生成器可以管理适配多尺寸图片，动态生成响应式图片断点。 ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/52-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### 从鼠标点击到手势

移动网页端的交互是通过手指完成的，而非鼠标点击。这意味着设计触碰对象和交互时要应对不同的规则。

*   **合理设置交互对象尺寸** 所有交互元素（链接、按钮、菜单）都应该是可用手势点击的。PC 端网页的交互区域（可点击区域）小而精确，而移动端网页需要较大较宽的按钮，方便手指交互。如果你的网站需要大量手势操作进行输入，参考 [MIT Touch Lab 的研究](http://touchlab.mit.edu/publications/2003_009.pdf)来为你的按钮选择适当的尺寸。研究发现手指面的平均尺寸在 10 到 14 毫米间， 指尖在 8 到 10 毫米间，10 × 10 毫米是恰当的触点尺寸。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/07-A-Comprehensive-Guide-to-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/07-A-Comprehensive-Guide-to-Web-Design-preview-opt.png)

小按钮比大按钮难点击 (图片来源： [Apple](https://developer.apple.com/design/tips/))

*   **交互需要更强烈的视觉标记** 在移动端的网页上，不存在悬停态。而在 PC 端，用户可以将鼠标悬浮在元素上获得额外的视觉反馈，比如悬停展开下拉菜单。移动端用户不得不点击得到反馈。因此，用户应该具有通过观察来正确预判页面元素行为的能力。

### Accessibility 无障碍设计

如今的产品必须设计为可被所有人使用，无论用户的是否有障碍。为障碍群体设计实际上是设计师培养同情心，试着以他人视角体验世界的另一种方式。

#### Users With Poor Eyesight 弱视用户

许多网站文本采用低对比度。虽然低对比度文本可能比较新潮，但也更加难阅读难识别。低对比度内容使视力较低的用户、对比度敏感用户产生阅读困难，

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/41-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/41-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

灰色文字在浅灰色北京下难以阅读。当体验很不好的时候，设计再好也毫无意义。([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/41-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

低对比度文字在 PC 端难以阅读，移动端更是难上加难。想象下你走在烈日中，尝试阅读低对比度的文本。这提醒我们无障碍的视觉设计是能更好针对所有用户的设计。

永远不要为了美观牺牲可用性。网站上文本和其他视觉元素最重要的特性就是可读性。可读性要求文本与背景有足够对比。为了确保视觉障碍人士也能阅读，W3C 网页内容无障碍设计指南（WCAG）提出了[建议对比度](https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html)。 建议对文本文字和图像文字使用以下对比度：

*   字号较小的文本与背景的对比度至少为 4.5:1，最优对比度为 7:1。
*   字号较大的文本（18号字体、14号粗体以上）与背景的对比度至少为 3:1。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/49-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/49-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

**差的例子：** 这几行字不符合颜色建议对比度，在该背景下难以阅读。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/03-A-Comprehensive-Guide-to-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/03-A-Comprehensive-Guide-to-Web-Design-preview-opt.png)

**好的例子：** 这几行字符合颜色建议对比度，在该背景下清晰易读。

你可以使用 WebAIM 的[色彩对比度检测](http://webaim.org/resources/contrastchecker/) 快速得知是否在最佳视觉范围内。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/13-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/13-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/13-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### Color Blind Users 色盲用户

据估，[全球 4.5% 人口](http://www.colourblindawareness.org/colour-blindness/)为色盲（每 12 名男性中就有 1 名，每 200 名女性中有 1 名）。4% 人口为低视力（每 30 人中有 1 人），0.6% 为盲人（每 188 人中有 1 人）。我们很容易忽视为这些用户群设计，因为大多数设计师都没有经历过这样的问题。

为了让这些用户正常访问，请避免使用颜色维度来传达内容。正如 [W3C 声明](https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-without-color.html)所说，不应该使用颜色“作为唯一的视觉方式传达信息，指定行为，提示回应，或区分视觉元素。

一个常见的例子：表单中用颜色作为唯一方式传达警告信息。成功和错误消息分别以绿色和红色表示。但是红绿色盲是最常见的色盲群体 —— 对他们来说这些颜色很难分辨。你可能经常看到这样的错误信息，比如“红色标识区域为必填项”。虽然这看起来问题不大，但对色盲用户来讲，这种表单错误提示超烦。颜色应该被用来突出显示或补充显示可见信息。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/32-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/32-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

**不好的例子：** 这种表单仅靠红色和绿色来表示字段是否有错。色盲用户是无法识别。

上表中，设计师应该给出更具体的提示，比如“您输入的电子邮件地址无效”或者至少在需要注意的地方显示图标。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/33-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/33-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

**好的例子** 图标和文字标签显示哪些字段无效，更好地将信息传递给色盲用户。

#### Blind Users 盲人用户

照片和插画是网站用户体验的重要组成部分。但盲人用户需要屏幕阅读器等辅助技术来翻译网站。屏幕阅读器通过图像的文本标注来“阅读”图片。如果没有文本标注或者描述不够清楚，他们将难以按照预期获取信息。

考虑两个例子 — 一个是 [Threadless](https://www.threadless.com/)：一个流行 T 恤的电商网站。这个页面并没有太多在售商品的相关信息，唯一可见的文本信息是商品的价格和尺寸。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/19-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/19-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/19-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

第二个例子是 ASOS 网站。同样是销售T恤的网页，它为商品提供了准确的文字表述。这有助于使用屏幕阅读器的用户想象商品的外观。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/48-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/48-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

为图像创建解释性文本时，请遵循以下指南：

*  所有“有含义的”图像都需要描述性的替代文字。（“有含义的”图片为信息传达提供场景）
*  如果图像仅仅是装饰性效果，未提供帮助用户理解页面内容的有用信息，则文本描述并非必要。

#### Keyboard-Friendly Experience 键盘流用户体验

一些用户使用键盘而非鼠标浏览网站。例如，有运动障碍的用户在使用鼠标这类精细运动工具时有困难。可以为此类用户简化交互和网页定位，通过将交互元素适配 Tab 键，并显示键盘指示符。
键盘导航的基本规则如下：

*   **检查键盘指示符是否明显可见** 有些网页设计师会删除键盘指示符，因为他们觉得碍眼。但这阻碍了键盘用户与网站的正常交互。如果您不喜欢浏览器提供的默认指示符，请别直接删除; 而是通过设计来满足你的品味。
*   **所有交互元素都应该可以通过键盘访问** 键盘用户应当可以访问所有交互元素，而不是仅仅能使用导航栏和主要的 CTA  按钮。

W3C 的 WAI-ARIA 创作实践 [“设计模式和工具” ](http://www.w3.org/TR/wai-aria-practices/#aria_ex) 章节，可以找到更多键盘交互的需求细节。

### Testing 测试

#### Iterative Testing 迭代测试

测试是 [UX 设计流](https://blogs.adobe.com/creativecloud/what-is-ux-and-why-should-you-care/) 中的重要一步。
如同设计周期的其它步骤一样，它是迭代的过程，从早期开始收集反馈，自始至终进行迭代。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/18-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/18-A-Comprehensive-Guide-To-Web-Design-large-opt.png)

(图片来源： [Extreme Uncertainty](https://www.extremeuncertainty.com/why-agile-projects-need-to-fund-bml-properly/)) ([点击查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/18-A-Comprehensive-Guide-To-Web-Design-large-opt.png))

#### Test Page-Loading Time 网页加载时间测试

用户很讨厌加载缓慢的网页，正因如此，响应时间是现代网站的关键因素。根据 Nielsen Norman Group 的研究，主要有[三大响应时间界线：](https://www.nngroup.com/articles/response-times-3-important-limits/)

*   **0.1 秒** 对用户来说是瞬间。
*   **1 秒** 短短一秒对用户认知流几乎无缝，但还是会感到一丝延迟。
*   **10 秒** 这几乎是用户注意力的极限了，10 秒的延迟通常会逼走用户马上关闭页面。

显然，我们不能让用户为了任何事务等待 10 秒之久。但即便是几秒的延迟（实际上经常发生），也会降低用户体验。用户会因为等待操作而恼怒。

通常是什么导致加载缓慢呢？

*   繁重的内容对象（例如嵌入视频或是幻灯片控件）
*   未经优化的后台代码
*   硬件问题（基础设施不足以支持快速操作）

诸如 [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) 类的工具能帮助你找到加载速度过慢的原因。

#### A/B Testing  A/B 测试

A/B 测试适用于：当你纠结于两个版本的设计（比如现有版本和重新设计的版本）。这种测试方法包含：对相同数量的两类用户随机显示两个版本，然后对数据进行分析，查看哪个版本更有效地实现目标。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/17-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/17-A-Comprehensive-Guide-To-Web-Design-preview-opt.png)

(图片来源： [VWO](https://vwo.com/ab-testing/))

### Developer Handoff 开发者交接

[UX 设计流程](https://blogs.adobe.com/creativecloud/ux-process-what-it-is-what-it-looks-like-and-why-its-important/) 包含两个重要的步骤：原型设计工作、解决方案的开发。两步之间的衔接可以称作为交接 （handoff）。当设计到最后阶段，准备投入开发时，设计师准备设计规范，也就是设计实现的文档描述。设计规范确保设计稿会遵循原始意向进行开发工作。

**设计规范的精度十分重要** 如果存在不精准的设计规范，开发者在网站开发阶段要么边猜边做，要么回来找设计师寻找答案。但是手工填写设计规范非常头疼，取决于设计的复杂性，这通常需要大量时间成本。

Adobe XD 的设计规格功能（测试版）可以发布公开访问的 URL 供开发工程师检查工作流。设计师不再需要花费大量时间创作设计规范，与程序员沟通元素位置，字体样式。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/25-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/25-A-Comprehensive-Guide-To-Web-Design-800w-opt.png)

Adobe XD 的设计规格功能（测试版）

### 结语

与任何方面的设计一样，这里的建议都只是一个开始。将这些想法与你的实践相结合以达到最好的效果。把你的网站看作是一个循序渐进的项目，使用分析手段和用户反馈逐步改善体验。记住：设计并不是为了设计师而设计 —— 为用户而设计。

> 这篇文章是由 Adobe 赞助的 UX 设计系列其中一篇。Adobe XD 工具是志于 [快速流畅的 UX 设计流](https://adobe.ly/2hI52UE)，帮你快速由想法到实现原型。设计，原型，分享 —— 只需一个应用。点击[Adobe XD on Behance](https://www.behance.net/galleries/adobe/5/XD)查看更多使用 Adobe XD 创作出得灵性作品，[注册 Adobe experience design newsletter ](https://adobe.ly/2yKueO8) 接收最新 UX/UI 设计趋势和灵感。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
