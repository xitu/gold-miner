> * 原文地址：[UX Design Practices: How to Make Web Interface Scannable](https://uxplanet.org/ux-design-practices-how-to-make-web-interface-scannable-2010125c710e)
> * 原文作者：[Tubik Studio](https://uxplanet.org/@tubikstudio?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ux-design-practices-how-to-make-web-interface-scannable.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ux-design-practices-how-to-make-web-interface-scannable.md)
> * 译者：[Ivocin](https://github.com/Ivocin)
> * 校对者：[生糸](https://github.com/Mcskiller), [Junkai Liu](https://github.com/Moonliujk)

# UX 设计实践：如何设计可扫描的 Web 界面

![](https://cdn-images-1.medium.com/max/1000/1*F6I_CHGUZzQ6mekt2H2C8A.png)

我们每天被大量的线上或线下的信息流压的不堪重负。由于新技术的发展和快速的互联网连接，人们生成的内容比他们能够接受的更多。面对众多网站和应用程序时，用户不会逐字逐句地阅读所有内容 —— 他们会首先扫描页面，看一下这些内容对他们是否有用。因此，可扫描性是当今网站可用性的重要因素之一。本文探究了这一现象，并且提供了如何使数字产品可扫描的技巧。

![](https://cdn-images-1.medium.com/max/1000/1*93f_FurS9JjwZS6lXwJDow.png)

### 什么是可扫描性？

对于页面或屏幕，动词“扫描”意味着匆匆一瞥或匆匆阅读。因此，可扫描性是将内容和导航元素呈现为可被轻松扫描的布局的方式。尤其是首次与网站交互时，用户一般都是快速查看内容，然后分析这些内容是不是他们所需要的。任何以下内容都可能成为这个过程的一个障碍：单词、句子、图像或动画。

顺便说一句，这种行为并不是什么新鲜事。几十年来，人们经常在新的杂志或报纸上做着相同的事情：在开始仔细阅读文章之前先浏览一遍。另外，从屏幕上阅读比在纸上阅读更累，因此用户会更具选择性地阅读，当他们开始厌烦的时候就会放弃阅读。

为什么可扫描性很重要？大约十年前，[Jacob Nielsen](https://www.nngroup.com/articles/how-users-read-on-the-web/) 回答了“人们如何在网上阅读？”的问题。他的回答非常简单：“他们没有。人们很少逐字阅读网页；相反，他们扫描页面，挑选个别的单词和句子阅读”。从那时起没有太大变化的是：当我们不确定一个网站是否满足我们的需求时，我们不太会花时间和精力去浏览它。因此，如果没有在第一分钟抓住用户的眼球，那么用户离开网页的风险会很高。无论网站的类型是什么，可扫描性都是其用户友好性的重要因素之一。

如何检查网页是否可扫描？可以尝试将自己视为首次使用者并回答如下两个问题：

 - **你在前几分钟看到的内容是否符合目标受众对此页面的期望？**

- **你能在前两分钟了解页面上的信息类型吗？**

如果这两个答案不都是正面的，也许是时候考虑如何加强网站的可扫描性了。加强网站可扫描性是值得投入时间的，因为扫描性好的页面在以下方面会变得更加高效：

* 用户更快速地完成任务并实现目标
* 用户在搜索他们需要的内容时会更少出错
* 用户可以更快地了解网站的结构和导航
* 跳出率降低
* 保留用户的水平越来越高
* 网站看起来更可信
* SEO 率受到积极影响

![](https://cdn-images-1.medium.com/max/1000/1*jUY-rctiYdE64lhAmouZlw.png)

### 流行的扫描模式

界面设计师必须考虑的重要事项是眼睛扫描模式，它表明用户在最初的几秒内与网页交互的方式。当你了解了人们如何扫描页面或屏幕时，就可以将内容进行优先级排序，并将用户需要的内容放入最明显的区域。这个[用户研究](https://uxplanet.org/user-research-empathy-is-the-best-ux-policy-5f966ba5bbdc)领域得到了 [Nielsen Norman 集团](https://www.nngroup.com/articles/eyetracking-study-of-web-readers/)的支持，帮助设计师和可用性专家更好地理解用户行为和交互。

收集用户眼动追踪数据的不同实验表明，通常访客扫描网站会使用几种典型的模型。

![](https://cdn-images-1.medium.com/max/800/0*XhTRNfV97UzNppny.png)

**Z 模式** 对于具有统一信息呈现和弱视觉层次的网页而言是非常典型的。

![](https://cdn-images-1.medium.com/max/800/0*hLPvt_yft0P_ZT_2.png)

另一种模式具有 **Z 字形图案**，该模式通常用于具有视觉上分割内容块的页面。同样，读者的眼睛从左上角开始从左到右移动，并在整个页面上移动到右上角，扫描这个初始交互区域中的信息。

![](https://cdn-images-1.medium.com/max/800/0*wNMOr8uiYFLMGAb_.jpg)

另一个模型是 [Nielsen Norman 集团](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/)探索发现的 **F 模式**，表明用户经常会经历以下交互流程：

* 用户首先水平移动阅读，通常跨越内容区域的上部。这个初始元素构成了 F 的顶部栏。
* 接下来，用户稍微向下移动页面，然后在第二个水平移动中读取，该移动通常覆盖比先前移动更短的区域。这个额外的元素形成了 F 的下栏。
* 最后，用户以垂直移动扫描内容的左侧。有时这是一个相当缓慢和系统的过程，在眼动追踪热图上显示为实心条纹。有时用户扫描得更快，会创建一个带有斑点的热力图。最后构成了字母 F 的主干。

### 提高可扫描性的技巧

#### 1.使用视觉层次对内容进行优先级排序

基本上，[视觉层次](https://tubikstudio.com/9-effective-tips-on-visual-hierarchy/)是按照人类感知最自然的方式，在页面上排列和组织内容的方式。其背后的主要目标是让用户了解每块内容的重要性级别。因此，如果应用了视觉层次，用户将会首先看到关键内容。

例如，当我们在博客中阅读文章时，我们首先会看到标题，然后是副标题，然后才是副本块。这是否意味着副本块中的信息不重要？其实不是这样，但通过这种方式用户就可以扫描标题和副标题，以了解文章是否对他们有吸引力，而不用阅读全文。如果标题和副标题起的恰当，它们能够告知用户文章的结构和内容，这会是说服用户去阅读更多的因素。另一方面，如果用户看到又大又长的没有分块的文本，他们会感到很害怕，因为无法得知阅读这篇文章需要多长时间，以及是否值得投入时间和精力。

有助于建立视觉层次的几个主要因素：

* 尺寸
* 颜色
* 对比
* 相近性
* 负空间
* 重复

所有这些都有助于设计人员将元素、链接、图像和副本集转换为由该页面布局组成的可扫描系统。

#### 2.将核心导航放入网站头部

所有上文提到的眼动扫描模式都显示，无论特定用户遵循哪种模式，扫描过程都会从网页的顶部水平区域开始。用它来展示交互和品牌的关键区域效果非常好。这也是 UI / UX 设计师、内容管理者和营销专家都认为[网站头部设计](https://uxplanet.org/best-practices-for-website-header-design-e0d55bf5f1e2)是一个关键点的原因。

另一方面，标题不应该过长：太多的信息使得无法集中注意力。将所有内容放入页面顶部的尝试会将布局变得混乱不堪。因此，在每个特定情况下，必须分析核心目标受众的目标，他们如何与网站背后的业务目标交叉，并以此为基础 —— 哪些信息或导航应该作为最重要头部内容。例如，如果是大型电商网站，搜索功能必须立即可见，并且通常可以在头部找到，并能从任何交互点访问到。对于小型企业网站而言，搜索功能根本不需要，但是直接看到的投资组合的链接是至关重要的。

![](https://cdn-images-1.medium.com/max/800/0*3w2BkBHrjlTYVgTw.gif)

[**Gourmet 网站**](https://dribbble.com/shots/3858039-The-Gourmet-Website-Interactions)

#### 3.保持负空间的平衡

负空间 —— 或者通常称为空白区域 —— 是布局里的空白区域，不仅在布局中的对象周围，而且在它们之间和内部。[负空间](https://tubikstudio.com/negative-space-in-design-tips-and-best-practices/)是页面或屏幕上所有对象的一种呼吸空间。 它定义了对象的界限，根据 [Gestalt 原则](https://uxplanet.org/gestalt-theory-for-ux-design-principle-of-proximity-e56b136d52d1)在它们之间创造了必要的联系，并建立了有效的视觉表现。在网站和移动应用程序的 UI 设计中，负空间是界面高[可导航性](https://uxplanet.org/ui-ux-design-glossary-navigation-elements-b552130711c8)的一个重要因素：没有足够的空气，布局元素没有被正确看到，因此用户可能会错过他们真正需要的东西。这可能是眼睛和大脑紧张的一个强有力的原因，尽管许多用户将无法明确表述这个问题。适量的负空间，特别是微空间，解决这个问题，并且使过程更自然。

#### 4.检查能否立即看到 CTA

显然，绝大多数网页目的在于用户必须完成的特定操作。包含号召性用语（CTA）的元素（通常是[按钮](https://uxplanet.org/ux-practices-8-handy-tips-on-cta-button-design-682fdb9c65bc)）应在几秒钟内显示，以便用户了解他们可以在此页面上执行的操作。 在黑白和模糊模式下检查页面可以很好地测试这一点。如果在这两种情况下都可以快速区分 CTA 元素，说明这一点做的不错。例如，在下面显示的[面包店网站](https://uxplanet.org/case-study-vinnys-bakery-ui-design-for-e-commerce-2ffe7fae3600)的网页上，可以很容易地在其他元素中看到将物品添加到列表中的 CTA 按钮。

![](https://cdn-images-1.medium.com/max/800/0*RI-R_E56dkdJ1DeN.png)

[**Vinny’s 的面包店网站**](https://uxplanet.org/case-study-vinnys-bakery-ui-design-for-e-commerce-2ffe7fae3600)

#### 5.测试副本内容的可读性

可读性定义了人们阅读单词，短语和副本块的容易程度。易读性衡量用户如何快速直观地区分特定字体中的字母。应该仔细考虑这些特性，尤其是对于填充了大量文本的界面。[背景色](https://uxplanet.org/light-or-dark-ui-tips-to-choose-a-proper-color-scheme-for-user-interface-9a12004bb79e)、副本块周围的空间量、字距，行距、字体类型和字体配对 —— 所有这些因素都会影响快速扫描文本和捕获令用户留下的内容的能力。为了防止这个问题，设计人员必须检查是否遵循[排版](https://uxplanet.org/typography-in-ui-guide-for-beginners-7ee9bdbc4833)规则以及所选字体是否支持一般的视觉层次和可读性。[用户测试](https://uxplanet.org/tests-go-first-usability-testing-in-design-574ffa18d81)将有助于检查用户能够快速轻松地感知文本。

#### 6.使用数字，而不是单词

这条建议是基于[Nielsen Norman 集团](https://www.nngroup.com/articles/web-writing-show-numbers-as-numerals/)的另一项调查。他们分享了一个重要的发现：眼动追踪研究表明，在扫描网页的过程中，数字通常会阻止用户徘徊并吸引注视，相反大量可以没有数字的单词会被用户忽略。我们潜意识地将数字与事实、统计数据、大小和距离相关联 —— 这些数据可能是有用的。因此，副本中的数字可以吸引用户注意，而代表数字的单词可能在大量副本中被遗漏。更重要的是，数字比文本数字更紧凑，因此它使内容更简洁，更省时。

#### 7.一个段落，一个想法

在可扫描性方面处理副本内容，尽量不要使文本的内容太长。简短的段落看起来更容易消化，如果信息对读者没有价值，可以更容易跳过。因此，当你在一个段落中提出一个想法并为另一个段落开始另一个想法时，请遵循该规则。

![](https://cdn-images-1.medium.com/max/800/0*fuMEd3aJ3gviUZZP.gif)

[**Bjorn 设计工作室网站**](https://dribbble.com/shots/2680255-Tubik-Studio-Bjo-rn)

#### 8.使用编号和项目符号列表

使文本更易于扫描的另一个好方法是使用带有数字或项目符号的列表。它们有助于清晰地组织数据。此外，它们会引起用户的注意，因此信息不会在文本主体中丢失。

#### 9.突出显示文本中的关键信息

加粗、斜体和颜色高亮显示虽然老派，但仍然有效。通过这种方式，你可以将注意力集中在段落中包含的重要想法、定义、引用或其他类型的特定数据上。更重要的是，**文本的可点击部分（链接）必须在视觉上标注出来**。我们习惯于看到它们加下划线、但使用颜色高亮或加粗字体会更有效。

#### 10. 使用图像和插图

在 Web 用户界面设计中，[图像](https://uxplanet.org/3c-of-interface-design-color-contrast-content-235b68fbd9a1)在表达情绪或传递消息方面是非常有帮助的，它们饱含信息和吸引力。原始插图，突出的英雄横幅，引人入胜的照片可以很容易地吸引用户的注意力，并支持一般的风格概念。更重要的是，它们在构建视觉层次方面发挥了重要作用，并使副本内容与插图或照片相结合，更容易消化。人们感知图像比理解文字更快，这是提高可扫描性的重要因素。

![](https://cdn-images-1.medium.com/max/800/0*cTIMfaqYBRGeppEn.png)

[**金融服务网站**](https://dribbble.com/shots/3905908-Financial-Service-Website)

提高网页的可扫描性，是设计人员和内容创建者对网站用户的真正尊重。这样我们就可以节省用户的时间和精力，为他们提供有组织，和谐的，有价值和有吸引力的内容。

* * *

**最初为 [**tubikstudio.com**](https://tubikstudio.com/) 而写**

** 欢迎到 [**Dribbble**](https://dribbble.com/Tubik) 和 [**Behance**](https://www.behance.net/Tubik) 观看 Tubik Studio 的设计。**


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
