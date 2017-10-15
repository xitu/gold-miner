
  > * 原文地址：[How I do Developer UX at Google](https://medium.com/google-design/how-i-do-developer-ux-at-google-b21646c2c4df)
  > * 原文作者：[Tao Dong](https://medium.com/@taodong)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-i-do-developer-ux-at-google.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-i-do-developer-ux-at-google.md)
  > * 译者：[Lai](https://github.com/laiyun90)
  > * 校对者：[临书](https://github.com/tmpbook)  [Cherry]（https://github.com/sunshine940326）

  # 我是如何在谷歌做开发者用户体验的

  **基于 Flutter 的用户调研进行说明**

![](https://cdn-images-1.medium.com/max/1600/1*-fxLDg9RoGtL2X8zYmb2pA@2x.jpeg)

人们谈论用户体验（UX）时，谈论的对象通常是他们所热爱的消费产品，比如：智能手机、消息应用或者一副耳机。

但是当你为开发者构建产品时，用户体验同样也很重要。人们往往会忘记开发人员也是用户，从本质上来说，软件开发是一项不仅受限于计算机的工作方式，而且也受限于程序员工作方式的人类活动。诚然，通常情况下开发人员的数量要比普通消费者少，但是开发人员所使用工具的可用性越高，越能使他们花费精力去为用户创造价值。因此，就产品来说，开发人员的用户体验和普通消费者的同样重要。在本文中，我将介绍为开发人员设计的开发者体验，阐述我们在谷歌对它进行评估的一种方法，并分享一些我们在开展  [Flutter](https://flutter.io/)（一个构建美观移动应用的新型 SDK）项目时，从一个具体研究中学到的经验教训。

为开发人员设计开发者体验并不是一个新鲜的想法。开发人员用户体验的相关研究可以追溯到早期计算时代，因为在一定程度上，当时所有的用户都是开发者。出版于 1971 年的 「[程序开发心理学](https://book.douban.com/subject/4734656/)」 是这个领域的里程碑式的著作。当我们谈到开发者体验，特别是将这个术语应用于 SDK 或库时，我们通常会考虑产品的三个方面：

- **API 设计**，包括类、方法和变量的命名，API 的抽象级别，API 的组织以及 API 的调用方式。
- **文档**，包括 API 参考和其他学习资源，如教材、操作指南和开发人员指南。 
- **工具**，涉及到有助于编辑、调试和测试代码的命令行界面（CLI）和 GUI 工具。比如，[研究](https://www.cl.cam.ac.uk/~mcm79/pdf/2015-PPIG.pdf) 表明，IDE 中的自动完成功能对如何在编程中发现和使用 API 有很大的影响

开发者体验的这三大支柱相辅相成，所以需要打包来设计和评估。

#### 我们如何观察开发人员的用户体验？

![](https://cdn-images-1.medium.com/max/1200/1*4kBtrc2qTpzT89KgnBmGVA.png)

我们用来评估开发人员用户体验的一种研究方法是**观察**真正的开发者如何使用我们的 SDK 和开发工具来执行一个实际的编程任务。这种被称为用户测试的方法，被广泛应用于消费者 UX 研究，我们对它做出调整来评估为开发者设计的产品。在关于 [Flutter](http://flutter.io) 的具体研究中，我们邀请了 8 位专业开发人员，请他们分别执行上面的模型。

在这个过程中涉及到的一个关键方法是 [有声思维法](https://en.wikipedia.org/wiki/Think_aloud_protocol)。这是 Clayton Lewis 在 IBM 研发的口头报告协议，能够帮助我们了解参与者行为背后的原因。我们给了参与者以下说明：

> 「当你在编程练习时，请『出声思考』。也就是说口头描述你的思维发展变化的过程，包括你的疑惑和问题、你所考虑的解决策略，以及你做出决定的理由。」

我们进一步向参与者保证，我们评估的是 Flutter，而不是他们的编程技能：

> 「请记住我们正在测试 Flutter 的开发人员使用体验，并非对您的考验。所以任何让您感到困惑的事情都是我们需要解决的。」

每一次的开发者测试，都是从访问参与者的背景作为热身，然后留给他们大约 70 分钟的时间来完成任务。在最后 10 分钟，我们会询问参与者的体验。每次测试中，我们都会向身处单独会议室的产品工程师团队不公开地直播测试情况，包括测试者电脑显示屏的内容。为了保护参与者的隐私，我们将使用编号（例如，P1、P2、P3 等）来标识他们，而非他们在本文中的姓名。

---

所以，从这次的研究中我们对开发者的体验有什么了解呢？

#### 1. 提供大量的示例，并有效地展示

在几轮用户测试之后，能够明显看出开发人员想从示例中学习如何使用新的 SDK。但是问题并不在于 Flutter 没有提供足够的例子 -- 它的 Github 资料库中有 [大量的例子](https://github.com/flutter/flutter/tree/master/examples)。问题在于，这些例子没有被组织起来，以一种真正对我们研究的参与者有帮助的方式呈现。出现这样的问题有两个原因：

首先，Flutter 的 Github 库里的代码示例缺少截图。当时，Flutter 的网站提供了一个链接，可以在其 Github 库里搜索到包括特定小部件在内的所有代码示例，但是参与者很难确认哪个示例会产生预期的结果。你必须在设备或模拟器上运行示例代码，才能看到小部件的外观，这是没有人愿意费心去做的。 

![](https://cdn-images-1.medium.com/max/1200/1*wl0E4X5dwf8ffO5U5WB6SQ.png)

> 「链接到实际的代码是很好的。但是除非看到输出，否则很难选择要使用哪一个。」 (P4)

第二，参与者期望在 API 文档中看到示例代码，而不是其他零散的地方。试错是学习 API 的常用方法，API 文档中的片段可以使这种学习方法得以实现。

> 「我点击『文档』，但它是 API，而不是示例。」 (P4)

几个 Flutter 团队的工程师通过直播观察了用户测试，他们被一些参与者经历的挑战所触动。因此，该团队已经开始持续地向 Flutter 的 API 文档（例如，[ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html) 和 [Card](https://docs.flutter.io/flutter/material/Card-class.html)）中增加更多示例代码。

[![](https://cdn-images-1.medium.com/max/1600/0*4U5ykS-eke_6ridl.)](https://docs.flutter.io/flutter/widgets/ListView-class.html)

此外，团队开始为更大的代码示例构建 [一个精心策划的视觉目录](https://flutter.io/catalog/samples/)。现在只有少数示例，但是每个示例都有截图和完整可运行的代码，所以发开人员可以很快确定一个示例是否对其问题有用。

[![](https://cdn-images-1.medium.com/max/1600/0*mOqhzOt9tm8Z81m5.)](https://flutter.io/catalog/samples/)

#### 2. 适应开发人员的认知能力

编程是一种认知高度紧张的活动。在这种情况下，我们发现一些开发人员很难只用代码编写 UI 布局。在 Fluttter 应用程序中，构建布局涉及在树中选择和嵌套小部件。例如，要在咖啡馆信息卡中构建布局，需要正确地组织几个行小部件和列小部件。这看起来并不是一项艰巨的任务，但是三名参与者在试图创建这个布局时，搞混了行和列。

![](https://cdn-images-1.medium.com/max/1600/1*ZsPJlXU8Kuy1ljzQMufy8Q.png)

```
new Card(
 child: new Container(
   child: new Row(
       children: [
         titleSection,
         new Container(
           child: new Row(
               children: [
                 phoneNumber,
                 new Container(
                   child: emailWidget
                 ),
                 ]
            )
          )
        ]
     )
   )
)
```

> 「你能告诉我你想输出什么吗？」（主持人）

> [出声思考] 「哦，我或许应该用列而不是行。」（P6）

我们转向认知心理学寻求解释。事实证明，用代码构建布局需要对物体之间的空间关系进行推理的能力，认知心理学家将其视为 [空间可视化能力](https://en.wikipedia.org/wiki/Spatial_visualization_ability)。正是这种能力影响了一个人有多么擅长解释驾驶方向或者转动魔方。

这一发现改变了一些团队成员对于可视化 UI 构建器的看法。该团队非常高兴能够看到社区驱动在这方面的探索，例如名为 [Flutter Studio](http://mutisya.com/) 的基于 Web 的 UI 构建器。

#### 3. 促进识别而非回忆

用户界面应该避免强迫用户回忆信息（比如一个隐晦的命令或者参数），是众所周知的 [用户体验原则](https://www.nngroup.com/articles/recognition-and-recall/)。相反，用户界面应该允许用户识别出可能的操作过程。

这个原则和软件开发有什么关系？我们观察到的一个问题是，很难直观的了解 Flutter 部件的默认布局行为并弄明白如何改变它们。例如，参与者 P3 不知道为什么卡片在默认情况下会缩小到它所包含的文本的大小。P3 难以解决如何使卡片填充整个屏幕宽度的问题。

![](https://cdn-images-1.medium.com/max/1200/1*HAbAkFXFMzPhTSRcwtpHvQ.png)

    body: new Card(
      child: new Text(
        ‘1625 Charleston Road, Mountain View, CA 94043’
      )
    ),

> 「我想要的是让它占据屏幕的整个宽度。」（P3）

当然，很多程序员最终会弄明白这个问题，但是他们下一次遇到同样的问题时，他们需要**回忆**如何去做。对于开发人员来说，在这种情况下没有可视的线索来**识别出**解决方案。

该团队正在探索几个方向，来减少构建布局中回忆的负担：

- 总结小部件的布局行为，使它们更易于理解。
- 提供同时含有代码和图片的布局样例，将一些回忆任务转变为识别任务。
- 提供一个 Chrome-style 的检查器来显示小部件属性的“计算值”。

#### 4. 预料到开发人员会对“就在眼前”的东西视而不见

一个让 Flutter 团队感到自豪的特性是 Hot Reload。它允许开发人员在一秒内将改变应用到一个运行态的 App 中，而不会丢失应用程序的状态。执行一次 Hot Reload 就像点击 IntelliJ IDE 中的一个按钮，或者在控制台按下 “r” 一样简单。

然而，在前几次的用户测试研究中，研究小组对一些参与者在文件保存时触发 Hot Reload 的预期感到困惑。尽管事实上，Hot Reload 按钮启动指令时就显示在 入门引导的 gif 动画中，他们怎么会看不到 Hot Reload 按钮呢？
![](https://cdn-images-1.medium.com/max/1600/1*oE-etcL1SzjYrNWTac9RtQ.gif)

结果表明，无视 Hot Reload 按钮并期望在保存时触发重新加载的的参与者是 React Native 的用户。他们告诉我们，在 React Native 中，Hot Reload 是在文件保存时自动执行的。

开发人员预先存在的心智模型会改变他们的感知，并在一定程度上对 UI 元素产生『盲目性』。团队增加了更多的视觉提示来帮助发现 Hot Reload 按钮。此外，一些工程师一直在研究一种可靠的方法，为需要它的用户提供保存时重新加载的功能。

#### 5. 不要假定程序员会像你期望的那样阅读出现在代码中的英语

在 Flutter 中，[一切都是一个部件](https://flutter.io/technical-overview/)。用户界面主要通过嵌套部件组成。一些部件只有一个子部件，而其他部件则有多个子部件。这个区别是由于部件类的属性是『一个子部件』（child）」还是『多个子部件』（children）。听起来很明确，对吧？

我们也是这样认为的。然而，对一些参与者来说，单词的单数形式并不能成功的表明只有一个部件可以嵌套在当前的部件中。他们怀疑『子部件』（child）是否真的意味着『只有一个』。

> 「我在想『子部件』（child）是否可以是多个。我能传递一批子部件进去，或者说真的可能只有一个子部件？」(P2)

> 「所以『子部件』（child）将是四件事，第一项、一个分隔符和另外两项。」(P2)

这种对属性名称语义的错误理解导致了以下的错误代码：

![](https://cdn-images-1.medium.com/max/1600/0*BARfNXeq3DpabHxq.)

而且在这种情况下显示的错误消息虽然准确，却不足以将参与者推回到正确的路径上：

![](https://cdn-images-1.medium.com/max/1600/0*HOBxZmDvGc_TAukH.)

新手程序员在这儿所犯的错误很容易被忽视。然而，看到专业开发人员浪费时间来处理简单的问题让团队成员感到很不爽。所以在调查结果报告出来的几天后，团队成员进行了短期的修复工作。通过运行「flutter create」命令，将一个最有用的多个子部件『列』，添加到你获得的应用程序模板中。我们的目标是让新手发开人员尽早了解『子部件』（child）和『多个子部件』（children）的区别，避免他们以后再浪费时间去弄清楚。除此之外，一些团队成员也在研究一个更长期的解决方案，以改善错误信息在此种情况和其他情况下的可操作性。

### 结论

我们可以从观察程序员使用 API 和应用所学中学到很多，来提高面对开发人员产品的用户体验。如果你编写了代码或构建了其他开发人员使用的工具，我们建议你观察他们是如何使用它的。正如一位 Flutter 的工程师所说的，你总是能从观察用户研究中学到一些新的东西。随着软件不断推动世界的变化，我们要关爱研发人员，让他们能尽可能高效开发，并保持心情愉快。

  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
