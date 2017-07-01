> * 原文地址：[Creating Usability with Motion: The UX in Motion Manifesto](https://medium.com/@ux_in_motion/creating-usability-with-motion-the-ux-in-motion-manifesto-a87a4584ddc)
> * 原文作者：[Issara Willenskomer](https://medium.com/@ux_in_motion?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Ruixi](https://github.com/ruixi)
> * 校对者：[cdpath](https://github.com/cdpath),[osirism](https://github.com/osirism)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*boQYFGPLtlDof3RRs124bQ.gif">

# 用动效创建的可用性：动效中的用户体验宣言 #

下面这段宣言即是我对这个问题的回答——“作为一个UX或者UI设计师，在界面中，如何在合适的时间和位置通过动效的使用来支持可用性呢？” 

在过去的5年中，我有幸指导过来自40多个国家的 UX 和 UI 设计师，而且我为这些顶级品牌和设计咨询公司带来的建议和指导基本上都是关于 UI 动效的。

通过对用户界面动效超过15年的研究，我得到的结论是：这里有12种可以利用动效来支持你的 UX 项目中的可用性的具体时机。

我称这些时机为“动效中 UX 设计的12条准则”，同时它们可以以各种创新形式来进行自由组合协作使用。

我将这份宣言拆分成5个部分：

1. 解答 UI 动效的主题——不是你想象的那样
2. 实时与非实时交互
3. 动效支持可用性的四种方式
4. 原理、技术、性能与价值
5. 动效中 UX 设计的12条准则

插播一条小广告，如果你想要我就令人激动的动效主题以及可用性在你的会议上发言或者为你的团队组织一个现场讨论的话，请移步[这里](https://uxinmotion.net/workshops-and-speaking/) 。 如果你想要在你所在城市参加课程，来[这里](https://uxinmotion.net/workshops-and-speaking/#classes) 。最后，如果你想要向我咨询你的项目，可以看看[这里](https://uxinmotion.net/consulting/) 。添加到我的列表，点击[这里](http://uxinmotion.net/joinnow) 。

### 它无关 UI 动画 ###

由于设计师往往认为用户界面中的动效就是 UI 动画——然而这是两回事——我觉得我有必要在12条法则之前插入一段情境。

设计师们通常会觉得 UI 动效的使用可以让用户体验显得更加生动愉悦，但总体上并没有增加什么价值。所以呢，UI 动效总是姥姥不疼舅舅不爱的。就算有，也是排在最末位的，不足挂齿。

此外，在用户界面语境下的动效被认为是迪士尼的12条动画原则下的，我在‘[UI 动画原则——迪士尼已死](https://medium.com/@ux_in_motion/ui-animation-principles-disney-is-dead-8bf6c66207f9) ’一文中对这一观点进行了反驳。

UI 动效对于“动效中 UX 设计的12条法则”来说就像是建筑物中的架构。我希望在我的宣言中用这个作为实例。

我的意思是，当一个结构需要实际地建立时（需要构造），决定导向建造**什么**的那只手来源于原则范畴。

动效的一切都和工具相关。原则对工具使用方法的实际应用进行指导，为设计师们提供优势机会。

大多数设计师认为的“UI 动效”实际上也是一种高级设计手法：时效和非时效性事件中界面元素的时序表现。


### 实时交互 vs 非实时交互 ###

在这个非常时刻，区分“情景”和“行为”就很重要了。UX 中的**情景**基本上是静态的，就像一个设计合成品。UX 中的**行为**从根本上来讲则是时序化的，基于运动。一个对象可以处于被屏蔽的**情景**中，或者被屏蔽的**行为**中。如果是后者，我们知道它涉及到运动，而且是能够支持可用性的。

此外，交互中的所有时序化行为都可以被认为发生在实时或者非实时。实时意味着用户可以直接于用户界面中的元素进行交互。非实时意味着对象行为是后交互的：它发生在用户动作**之后**，以及过渡之中。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*5FaCRpgM0oUwiqc_j_mL3w.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*SRLhjyyJA43ELZ65Zu6o4w.gif">

这是一个重要的区别。

实时交互也可以理解为“直接交互”，用户可以直接迅速地与界面对象进行交互。界面行为在**用户使用的同时发生**。

非实时交互只发生在用户输入**之后**，而且有暂时锁定用户体验的效果，直到过渡阶段完成。

了解这些差异会帮助我们理解 UX 动效的 12 法则

### 动效支持可用性的4种方式 ###

这四个核心代表着时序性用户体验支持可用性的四种方法。

#### 期望 ####

期望分为两大领域——用户如何感知对象**是什么**，以及它表现出了**何种行为**。换句话说，作为设计师，我们期望尽可能缩小用户期望和用户体验之间的差距。

#### 一致性 ####

一致性代表着用户流以及用户体验的“一致”。一致性也可以理解为“内部一致性”——场景内和场景间的一致。一系列场景的一致性构成了用户体验。

#### 叙述 ####

叙述是用户体验中时间框架内事件的线性进展。它可以被认为是一系列被认真考虑以连接整个用户体验的时刻和事件。

#### 关联 ####

关系是指空间，时间，和层次表示之间引导用户理解和决策的界面对象。

### 准则、技术、特性和值 ###

[Tyler Waye](http://tylerwaye.com/learning-to-learn-principles-vs-techniques/) 这话就和他之前写过的一样好：“准则……是提升技术的基本功能前提和潜在规则。无论发生了什么，这些元素都保持一致。” 重申，原则是不可知的设计。

这样，我们可以想象一个层次结构：准则位于顶层，技术在下一层，接着是性能，最下层的则是值。

**技术**可以认为是原则或原则组合的各种无限制的执行。我觉得技术类似于“风格”。

**特性**则是特定的对象因素来将技术转化为现实。这些包括（但不限于）位置、不透明度、比例、旋转角度、定位点、色彩、笔画宽度、形状等等。

**值**是随时间而变化的实际数值属性值，用以创建我们所称的“动画”。

所以在这里先停一下（再往前说一点），我们可以说一个假想的动画参考是利用遮罩和“毛玻璃”技术：模糊 25px，不透明度 70%。

现在我们有些可利用的工具。更重要的是，有些语言工具对于任何其他特殊原型工具来说都是不可知的。


### UX 动效中的12原理 ###

缓动、偏移和延迟都和**时间**有关。父子关系涉及到的**对象关系**。变形、值变化、遮罩、覆盖和生成都与**对象一致性**有关。视差与**时态层次**有关。蒙层，多维化以及镜头平移与缩放都与**空间一致性**有关。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*FQwVeyJ8pxngEGAxruGW-A.jpeg">

#### **原理1:缓动** ####

**当时序事件发生时，对象行为与用户期望一致。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*KcWZCCOMr7QrFpqxWirtMw.gif">

所有界面对象表现出时间的行为（无论是实时或非实时），都很舒缓。缓动营造并加强用户体验的“自然主义”内在，并在对象表现**符合用户期待时**营造出一种统一连续的感觉。**顺便一说**，**迪士尼把这叫做“[缓进缓出](https://en.wikipedia.org/wiki/12_basic_principles_of_animation#Slow_In_and_Slow_Out)**”。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*NBmptOO9ZTC9bQ-98-mWcg.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*HwK2vxdY0vveZdvqoEY_8w.gif">

左边有直线运动的例子看起来很“糟糕”。上面的第一个有**缓动**动效的例子看起来“很好”。 上述三个例子都有相同数量的帧，而且时长完全相同。唯一的区别就是它们的舒缓度。

作为设计师来思考可用性，我们需要对自身严格要求，提出疑问，美感角度之外，哪个例子对可用性支持来说更好？

我这里呈现的例子是一定程度的拟物设计更为自然舒缓。你可以想象一个“缓动梯度”，即低于用户期望的行为导致更差的可用性交互。在恰当的缓动的动效案例中，用户体验动效本身是不着痕迹的，几乎难以察觉——这很棒，因为它不会因此而**分散注意力**。线性运动很明显，感觉也有一些……不完善，不和谐，让人分神。

现在我将在这里彻底反驳我（刚才）的观点，谈谈右边的例子。动效并**不是**不着痕迹的。实际上，它的感觉是被“设计”过的。我们注意到这个对象是如何停顿的。它给人的感觉很不一样，然而它还是比直线运动的例子感觉上更“对劲”。

你能在不再支持（甚至破坏）可用性的状况下依然坚持利用缓动吗？答案是会。而且有很多种方法。一种是设定时间。如果你的时间设定得太慢（大概借用一下 [Pasquele](https://medium.com/@pasql) ），或者太快，体验就会被破坏，而且分散掉用户的注意力。同理，如果你的缓动效果偏离了品牌或者是综合体验的话，也会对体验和无缝感带来负面影响。

我想给你看的是一个在提到缓动之时充满机会的世界。也有字面意思上的“舒缓”，作为一个设计师，你可以在无数项目中进行实践。所有的这些宽松都有自己在用户触发时有自己期望的响应。

总结：什么时候使用缓动方式？任何时候。

#### 原理2:分隔&延迟 ####

**在引入新元素和场景时定义对象关系和层次结构。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*7rRMvWTms2t7FnR0kyJN3g.gif">

分隔和延迟是 UI 动画两大原则中的第二个，它深受迪士尼动画原则的影响，这里出自“[动作跟随与重叠](https://en.wikipedia.org/wiki/12_basic_principles_of_animation#Follow_Through_and_Overlapping_Action)。”

这一点很重要，值得注意。然而，这种操作在执行中也有相似之处，目的和结果不同。迪士尼的原则指导出了“更吸引人的动画”，而 UI 动效原则引导了更具可用性的体验。

这个原则的作用是可以通过告知用户界面中界面的性质来预先进行成功设置。上面提到的叙述是：上面两个对象是统一的，底层的则是分开的。也许前两个对象会是一个非交互的图像或者文本，而底层对象是个按钮。

甚至在用户了解这些对象都**是什么**之前，设计师们已经通过动效传达给 ta 了：这些对象都是“分开的”。这就很厉害了。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*CCRJjHIyq4PKECbmpUM3rA.gif">

Credit: [InVision](https://dribbble.com/InVisionApp)

在上面的例子中，浮动按钮（FAB）成了包含三个按钮的主导航元素。因为按钮之间相互“独立”，它们最终通过自己的“独立”来支持可用性。换言之，设计师在利用时间本身来说明——甚至在用户了解这些对象都是什么之前——这些对象是相互独立的。这有告知用户界面中对象部分性质的效果，完全独立于视觉设计。

为了更好地给你展示它是如何工作的，我会给你举一个没有依照分隔与延迟原则的例子。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*DJHXB3kDHesSwHxLYeJyFg.gif">

Credit: [Jordi Verdu](https://dribbble.com/jordiverdu)

在上述案例中，静态的视觉设计告诉我们背景上有图标。假设图标都是分开的，有不同的功能。但动画和这个是矛盾的。

图标被暂时分组成行而且被认为是单一的对象。它们的标题也同样被列为行，也表现为单一对象。这个动画告诉用户的是眼睛看不到的东西。在这中情况下，我们可以说，这时此界面中的对象不可用。

#### 原理3:父子关系 ####

**在多个对象交互时创造时间和空间层次关系。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*AK-IvsnBGJFVwZnqxYjqrQ.gif">

父子关系是一个意义重大的原则——“串联”用户界面中的对象。在上面的例子中，顶部的“比例”和“定位点”属性或者底部的“子对象”，以及“父对象”都是如此

父子关系是对象属性与其它对象属性的连接。这可以创建对象关系和层次结构，以支持可用性。

父子关系还可以让设计师们能够在向用户穿搭对象关系性质的时候更好的协调用户界面中的时间事件。

再想想那些包括以下这些在内的对象属性——比例、透明度、定位点、旋转角度、形状、颜色、数值属性，等等。这些属性中的任何一个都可以与其它属性连接，并在用户体验中营造出协调的情景。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*vAAs4k5reIuVNx9KFoZCCw.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*oEKY3b97GnxizyVO2Bdglg.gif">

Credit: [Andrew J Lee](https://dribbble.com/lee_aj) , [Frank Rapacciuolo](https://dribbble.com/frankiefreesbie) 

在上面左边的例子中，“面”元素的“y 轴”属性就是圆指针“x 轴”属性的“子级”。当圆指针沿水平方向运动时，它的“子元素”沿水平方向垂直移动(while being Masked — another Principle).

其结果是同一层次同一时空的描述框架同时发生。 值得注意的是，“面”的对象数值都被分别 “锁定”，“面”是完全不可见的。用户体会到了无缝的感觉，尽管在这个例子中我们可以说这是一个微妙的“可用性骗局”。

继承性功能最好作为实时交互。当用户直接操纵界面对象时，就是设计者在通过动画与用户交流——对象是如何连接的，以及它们之间是何种关系。

父子关系有三种形式：“直接联系”（看上面的两个例子），“延迟的联系”，和“相反的联系”‘（往下看）。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*RsyF9JEfaM1evRFPmhMAjA.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*l2a36kW3kgkYgPZRfDqhog.gif">

延迟的联系 (Credit: [AgenceMe](https://dribbble.com/AgenceMe) ) 和 相反的联系 (Credit: [AgenceMe](https://dribbble.com/AgenceMe) )

#### 原理4:变形 ####

**在对象作用发生变化时，创建一个连续的叙事流状态。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3obIWzQMTkX74ndGcmW_eg.gif">

很多人已经写过了 UX 动效原则中的“变形”。在某些方面，这是最明显最容易被看到的动画原则。

变形非常明显，因为它很突出。我们可以看到一个“提交”按钮的形状变成了一个横向的进度条，并且最终变成了确认检查的标志。它抓住了我们的注意，讲述了一个事件，并最终完成。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*JNE8gIhMViaL-Yri9SiCjg.gif">

Credit: [Colin Garven](https://dribbble.com/ColinGarven) 

变形的作用是在不同的 UX 状态或者“这是”（就像**这是**一个按钮，**这是**一个横向进度条，**这是**一个复选标记）之间为用户提供无缝过渡。这最终都会导致预期的结果。用户被安排通过这些功能来达到最终目的。

“模块”的变化产生的影响适当地将用户体验中的关键时间点分离成为一个无缝和连续的事件序列。这种无缝的体验会带来更好的用户感知，记忆，以及后续行为

#### 原理5:数值变化 ####
**当值的主体发生变化时，产生动态的、连续的叙事关系。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3IWEaIssuoLSu4U7Y-hdgQ.gif">

基于文本的界面对象，即数字和文本，可以改变它们的值。这就是“难以察觉的寻常“中的一个。

文本和数字的变化太过常见，以至于它们可以在我们未曾区分并谨慎评估它们在支持可用性中的角色的时候就被它们越过了。

那么，值发生变化时的用户体验是什么？在用户体验中，UX 动效的12法则是支持可用性的有利条件。这里的三个条件连接用户与数据背后的**现实**，有代理的意思，以及值本身的动态特性。

我们看看 dashboard 的例子。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*Ek1bbmWLyMJU5wQiMZCSJA.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*fY2GeYo6Uj0l9qziupfn3Q.gif">

当基于数值的界面对象在没有**数值变化**时加载，传递给用户的数字是静态对象。它们就像是显示限速每小时55英里的油漆标志牌。

数字和值都是**事实**发生的事件的表征。这个事实可以是时间、收入、游戏分数、商业指标、运动跟踪。我们通过动画来区分的是动态的“值的主体”，以及那些反映了动态值的集合的某些东西。

这种关系不仅失去了静态对象的视觉价值，也失去了一个更深层次的有利条件。

当我们采用基于动态值的形式来进行动态系统陈述的时候，它触发了一种“神经反馈”。用户掌握了他们的数据的动态属性。现在可以通过授权**代理**来改变这些数值。当值为静态的时候，它与其背后的**事实**联系较少，用户失去了**代理权**。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*FmT4vosDI453IK0aJbuW9Q.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*2LB6MevUJaYZdRYg39T3Qw.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*TFFz9-Zl1UIUWRlc1rY11Q.gif">

Credit: [Barthelemy Chalvet](https://dribbble.com/BarthelemyChalvet), [Gal Shir](https://dribbble.com/galshir) , Unknown

在实时和非实时事件中都可能出现数值变化。在实时事件中，用户与对象交互来更改值。在非实时事件中，比如加载和转换，值的变化来源不靠用户的输入来反映动态叙述。

#### 原理6:遮罩 ####

**在功能取决于对象或组的哪一部分显示或隐藏时创造一个界面对象或者一组对象的连续性。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*Ah_FBCcqm7YsqChgz-GYOA.gif">

遮罩请求的**表现**可以被认为是对象的形状和它的功能之间的关系。

因为设计师们对静态设计的情景下对这招很熟悉，我们应当区别 UX 动效准则“遮罩”出现的时间。作为一种**表现**，而非**状态**。

利用显示和隐藏对象来使用时序化，功能的连续，以及无缝转换。这也有保持叙事流的效果。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*OSe67jIPfPzgaSODFaJ5gg.gif">

Credit: [Anish Chandran](https://dribbble.com/anish_chandran) 

在上面的例子中，顶部图片的形状和位置发生了变化，而非内容，它变成了一张专辑。这具有改变对象**为何物**的作用，同时保留被掩盖的内容——**相当巧妙的把戏**。它是非实时发生的，作为一个变化，在用户动作之后才回被激活。

记住，UI 动画原则的出现具有时序性，通过对连续性、叙事性、相互关联和期望来支持可用性。在上面所提到的内容里，当对象本身保持不变的时候，也会有边界和位置，而这两个要素则决定了对象是什么。

#### 原理7:覆盖 ####

**在分层对象的位置有关联的时候营造叙事和视觉的平面对象空间关系。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*XCEmrzdTIbLt0a37pj0nBQ.gif">

覆盖通过允许用户利用平面排序功能克服空间层次的缺乏来支持可用性。

为了安全着陆，覆盖让设计师通过动画来联系位置相关的排在后面或者前面的非3D空间中的对象。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*g-MHVlWPL1RF1W4UZIk6Qg.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*KV5hGH2CVcPQ_e7dfpKsuw.gif">

Credit: [Bady](https://dribbble.com/bady), [Javi Pérez](https://dribbble.com/javiperez) 

在左边的案例中，前景对象滑到了右侧来显示背后的附加对象的位置。而在右边的案例中，整个场景向下滑动来显示附加的内容和选项（同时还利用了分隔和延迟的准则来传达照片对象的特征）。

某种程度上来说，作为设计师，“层”的概念实在是不言自明。利用层和层的概念来做设计对于我们来说已经被深深内化了。然而，我们必须小心区别“创造”和“使用”的过程。

作为不断从事“创造”过程的设计师，我们对我们所设计的对象的每个部分（包括被隐藏的部分）都很了解。但作为用户，那些视觉和认知层次上都不可见的部分是定义和实践。

覆盖原则允许设计师表达“Z 轴”定位层之间的关系，以促使空间定位到他们的用户。

#### 原理8:生成 ####

**在新的对象产生和消失的时候，创造连续性，关联，和叙事。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*XhtrzHD5PBpHKuhoJqB7fQ.gif">

在当前场景中创建新的对象时(来自当前对象)，叙事性地解释其外观尤为重要。在这份宣言中，我强调了创建一个叙事框架的对象起源和出发的重要性。仅仅是对不同明度的调整达不到这种效果。遮罩、生成、以及数值的变化是三种基于可用性来产生强烈叙事性的方法。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*UsnQMriM_Bjz480Ob70egg.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*2tUFeu74yCK-BhXjoTZrEQ.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*knAuRUPJFue8Z-nvxH2bUQ.gif">

Credit: [Jakub Antalík](https://dribbble.com/antalik) , [Jakub Antalík](https://dribbble.com/antalik) , Unknown

在上面的三个例子中，新的对象是在用户的注意力集中在这些对象上时，以现有的主要对象（为基准）创建的。这两个方法——注意力的引导，然后引导眼睛通过生成新的对象——具有沟通的清晰和明确的事件链的有力作用：动作“X”导致了创建新的子对象的“Y”结果。

#### 原理9: 蒙层 ####

**允许用户空间层次而不是在主视觉层次中定位自己的对象或场景的关系。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*dYmhIISFfqIh-w5hMD8-aw.gif">

和 UX 相关的动效原理中的遮罩类似，蒙层同样作为一个静态的暂时现象。

这可能会让那些没有短暂思考经验的设计师感到混乱——就是在时刻**之间**的时刻。设计师通常所做的设计是屏幕到屏幕或任务到任务。可以将蒙层看做是遮蔽的**行为**，而非被遮蔽的**状态**。静态设计代表被遮的状态。引入时间给我们一个物体被遮的行为。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*HrfgNmRzM5VrL0x4xKmGPg.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*QX9BrprmQkvccsKaep_otA.gif">

Credit: [Virgil Pana](https://dribbble.com/virgilpana), [Apple](http://www.apple.com/)

从上面两个例子中，我们可以看到，**看起来像**透明物体或覆盖物的蒙层，也是一个同时涉及多个属性的即时互动。

其中的模糊效果和减少对象整体的透明度设计到各种常见的技术。使用户理解这是她正在操作的一个另外的非主要情景——是另一个世界，就在她的的主对象层次**之后**。

蒙层使设计者能够在用户体验中对单一统一的视野，或**目标导向**进行补充。

#### 原理10:视差 ####

**在用户滚动界面时创造视觉空间层次。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*tVCAaCgws_1Q2u8ViQ6z6w.gif">

“视差”作为一个 UX 动效原理之一，指界面中的不同对象以不同的速度移动。

视差允许用户专注于主要行动和内容，同时保持设计的完整性。背景元素在一个视差事件中为用户“提供”感知和认知。设计师可以使用视差分离出即时内容从环境或支持的内容。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*flKRcXTaSjJ9eyGAIIx4Aw.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*BssDbeOCt1sXpfkh2WxdKw.gif">

Credit: [Austin Neill](https://dribbble.com/austinneill), [Michael Sevilla](https://dribbble.com/SVLA) 

这对用户的影响，是明确定义**持续时间的互动**，各种对象的关系。前景对象，或移动“更快”的对象被认为离用户“更近”。同样，背景对象或对象移动“慢”被认为是“更远”。

设计人员可以利用时间来创建这些关系，告诉用户界面中的哪个对象具有更高的优先级。因此，将背景或非交互元素进一步“推回”是很有意义的。

不仅用户感知的界面对象在视觉设计中具有层次区分，这种层次结构现在可以利用来让用户在意识到设计内容之前掌握用户体验的**本意**。

#### 原理11：多维化 ####

**当新的对象的产生和消失的时候提供了一个空间叙事框架。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*f6MiFmeYfXqGim9Vo8ymwg.gif">

用户体验的关键是连续性的现象，以及对位置的感知。

多维化提供了克服用户体验的二维世界，非逻辑的有力途径。

人类非常善于利用空间框架来引导现实世界和数字世界中的体验。提供空间的起源和偏离参考有助于加强用户在用户体验中的心理模型。

此外，多维化原则在同一平面上的物体存在缺乏深度，发生在其它对象的“前面”或“后面”（的问题）上克服了视觉平面中的分层悖论。

多维化以三种方式呈现——折纸维度，浮动维度，以及对象维度。

**折纸维度**可以被认为是在“折叠”或“翻转”三维界面对象。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*iZuMzfPgGwH_im_9Ofb5vg.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*II33u0hSsLFblYSCQhfxMA.gif">

Examples of Origami Dimensionality (Credit: [Eddie Lobanovskiy](https://dribbble.com/lobanovskiy) , [Virgil Pana](https://dribbble.com/virgilpana))

由于多个对象被组合成“折纸”结构，隐藏的对象仍然可以被称为“存在的”，即使它们在空间上是不可见的。这有效地将用户体验作为一个连续的空间事件：用户导航，创建一个运行环境中的交互模型，还有界面对象本身的时间特性。

**浮动维度** 给界面对象一个空间的起点和消失，使互动模式的更直观且保持高度叙事。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*PhZLxUbjetc5nMgMv90qxg.gif">

浮动维度的例子 (Credit: [Virgil Pana](https://dribbble.com/virgilpana) )

在上面的例子中，维度是通过使用3D“卡片”实现的。这提供了一个支持可视化设计的强大叙事框架。叙事是延长卡片“翻转”访问额外的内容和交互性。维度是引入新的元素，尽量减少突发性的有力途径。

**对象维度**带来有真正的深度和形式的三维对象。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*ni2fxsm6pKMYQ6Jc75DzLw.gif">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*yWhLvwAkVNoYaqmfzlxiYQ.gif">

Examples of Object Dimensionality (Credit: [Issara Willenskomer](https://uxinmotion.net/) , [Creativedash](https://dribbble.com/Creativedash) )

在这里，多个二维层被安排在三维空间，以形成真正的三维对象。他们的维度显示在实时和非实时的过渡时刻。对象维度的作用是用户开发基于非可见空间位置的对象效用的敏锐意识。

#### 原理12：镜头平移与缩放 ####

**在导航界面对象和空间时保留连续性和空间叙述性。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*NwAD-XMtBzzY8n8c9NpXqg.gif">

镜头平移与缩放是电影的概念中的相机和相关物体的运动，而画面本身的大小在画面上平稳地从长镜头变为特写镜头（反之亦然）。

在某些情况下，这是不可能的。比如对象缩放，物体在 3D 空间中朝着摄影机移动，或者是摄影机在 3D 空间中向着物体移动（参见下方参考）。下面的三个例子说明了可能的情况。

![](https://cdn-images-1.medium.com/max/800/1*R9wPWQUu26wjibaTBUstqQ.gif)

这是移动摄像，缩放，或是摄像机的运动吗？
这种，是将“移动影像”和“变焦”的例子进行了分别处理。但类似的，他们也涉及连续元素和景深变化，满足了 UX 的动效设计原理：他们通过运动支持可用性。

![](https://cdn-images-1.medium.com/max/400/1*I4yZ2k1zeo3qc9qrbn0LDw.gif)

![](https://cdn-images-1.medium.com/max/400/1*XVtnYMrp8LhGJzcsF0Lw7Q.gif)

![](https://cdn-images-1.medium.com/max/400/1*o2ellGNN8CTJbwUoJ0ts8Q.gif)

左边的两个图像是移动摄像，而右边的图像是变焦

**移动摄像** 是一个电影术语，适用于摄像机运动，无论是向或远离对象 (它也适用于水平的“跟踪”运动，但在可用性情景中的相关性较小)。

![](https://cdn-images-1.medium.com/max/800/1*8TYALn5P87i2OuuZfhfELg.gif)

Credit: [Apple](http://www.apple.com/)

在 UX 的空间中，这个动作可以指观众视角的改变，也可以指当对象改变位置时保持静止状态。移动摄像原理通过连续性和叙事，无缝过渡接口对象和目的地支持可用性。移动摄影还可以结合维度原理，从而产生更多更深入的空间体验并传达给用户当前视图的“前面”或“后面”的领域或内容。

**变焦** 是指既没有透视也不是物体在空间上移动的事件，而是指对象本身的缩放（或者我们看它的角度导致图像放大）。这传达给观者，额外的界面对象是“内部”其他对象或场景的感觉。

![](https://cdn-images-1.medium.com/max/800/1*I6-dXGCq9cXjAZGyVOkXrA.gif)

Credit: [Apple](http://www.apple.com/)

它可以无缝转换——实时或是非实时——来支持可用性。这种无缝使用移动摄影和变焦原理在创造空间的心理模型的情况下是很强大的。

如果你已经读到了这里，那么恭喜！这真是个野蛮的宣言。我希望这些加载的 gif 没有让你的浏览器陷入瘫痪。我也真的希望你找到一些对自己有价值的东西，一些对你的互动项目有利的新工具和优势。

希望你了解更多关于如何开始使用运动作为支持可用性的设计工具。

最后再插个广告：如果你想要我就令人激动的动效主题以及可用性在你的会议上发言或者为你的团队组织一个现场讨论的话，请移步[这里](https://uxinmotion.net/workshops-and-speaking/)。如果你想要在你所在城市参加课程，来[这里](https://uxinmotion.net/workshops-and-speaking/#classes)。最后，如果你想要向我咨询你的项目，可以看看[这里](https://uxinmotion.net/consulting/)。添加到我的列表，点击[这里](http://uxinmotion.net/joinnow)。

这份宣言离不开来自亚马逊的 [Kateryna Sitner](https://www.linkedin.com/in/katerynasitner/) 慷慨耐心的贡献和不断的反馈——非常感谢！特别致谢 [Alex Chang](https://www.linkedin.com/in/alexychang/)，他的头脑风暴和坚持给了我莫大的支持，感谢来自微软的 [Bryan Mamaril](http://ficuscreative.com/) 的一双慧眼，感谢 Jeremey Hanson 的笔记编辑整理，感谢疯狂的 UI 动效大师 [Eric Braff](https://www.linkedin.com/in/eric-braff-276504b)，[Artefact](http://artefactgroup.com/) 的 Rob Girling 的多年信任，[Matt Silverman](http://www.swordfish-sf.com/)  在 After Effects 会议上鼓动人心的讲话，良心室友 [Bradley Munkowitz](http://gmunk.com/) 为我带来 UI 设计的灵感，[Pasquale D’Silva](https://medium.com/@pasql)  关于动效的令人吃惊的文章，[Rebecca Ussai Henderson](https://medium.freecodecamp.com/@becca_u)对 UI 在编排方面的精彩论述, [Adrian Zumbrunnen](https://medium.com/@azumbrunnen) 在 UI 编排领域的佳作，[Wayne Greenfield](http://www.seattlekombucha.com/) 还有 [Christian Brodin](http://www.theapartmentinvestor.com/author/christian-brodin/) 不断推动我进步的策划兄弟。还有你们，不断创造灵性 gif 的成千上万的 UI 动画师们。 


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
