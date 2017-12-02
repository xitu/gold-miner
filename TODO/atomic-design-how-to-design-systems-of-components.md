
> * 原文地址：[Atomic design: how to design systems of components](https://uxdesign.cc/atomic-design-how-to-design-systems-of-components-ab41f24f260e)
> * 原文作者：[Audrey Hacq](https://uxdesign.cc/@audreyhacq)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/atomic-design-how-to-design-systems-of-components.md](https://github.com/xitu/gold-miner/blob/master/TODO/atomic-design-how-to-design-systems-of-components.md)
> * 译者：[H2O-2](https://github.com/H2O-2)
> * 校对者：[ZhangFe](https://github.com/ZhangFe)，[LeviDing](https://github.com/leviding)

# 原子设计：如何设计组件系统

如今，数字产品需要同时适用于任何的设备，屏幕尺寸和媒介：

![](https://cdn-images-1.medium.com/max/800/1*q-qsAsIFizbZkalv7TwEOw.jpeg)

所有媒介现在都可以显示我们的界面元素
> **所以我们为啥还在依据「页面」或者屏幕设计自己的产品？！**

我们应该通过设计优美、简洁且兼容一切设备、屏幕尺寸或内容的访问方式取而代之。

依据以上原则以及受到模块化设计的启发，Brad Frost 构想出了从最小的界面元素：原子，着手的原子设计方法。这个巧妙的比喻让我们理解了我们到底在创作什么，尤其是应该如何创作它。

我对这个方法深信不疑：它终于可以让我们同时考虑部分和整体，拥有对产品或品牌的全局视野，并且能够以更接近开发者的工作方式工作。

因此我自忖道：
**「没错儿了，就是这样！我们就需要像这样工作！」**
**但是说实话，我完全不知道该怎么做...**

在花了几个月的时间并且做了几个实打实的项目之后，我才终于对「原子设计方式」的内在含义，以及它将会如何改变我的设计师之路有了些了解。

在这篇文章里，我将会简要介绍一下我学到的知识，以及在通过原子设计方式设计组件系统时需要注意什么。

### 针对何种项目？

对于我来说，每一个项目，无论大小都可以使用原子设计的理念。

这种方式可以统一团队的视野。组件易于复用、编辑和组合，使得项目的发展变得简单。至于小的项目嘛... 每个小项目总有一天都可能成为大项目，不是吗？

和大部分人的认知相左的是，我认为原子设计方法并不只适用于网络相关的项目 ... 事实上截然相反！我成功地在一个个人项目中（一个叫做 [TouchUp](https://itunes.apple.com/fr/app/touchup/id1128944336?mt=8)) 的 iOS 应用，可以清理你的地址簿）引入了原子设计，而且与我合作的开发者非常欣赏这种方式。当我们想快速开发并迭代产品的时候，它帮了大忙。

同时我推荐那些担忧创造性与构建组件系统是否可能共存的人读读这篇文章：「[原子设计与创造性](https://medium.com/@audreyhacq/atomic-design-creativity-28ef74d71bc6)」

### **这和过去有什么不同呢？**

经常有人问我：
**「但是这和我们过去的工作方式有什么不同呢？」**

我认为原子设计对界面设计方法只做出了很小的改变，但最终却带来了巨大的影响。

> **部分塑造整体且整体塑造部分**

直到最近，我们仍会单独设计产品的每一个界面，然后把它们裁剪成小组件，以此来创建设计规格或 UI 套件（UI Kits）：

![](https://cdn-images-1.medium.com/max/800/1*3OFaoY-yLYdgPmO8AhejmQ.jpeg)

之前：我们解构界面来制作组件。

这样制作出来的组件有一个问题，它们并不通用，且互不依赖。因此组件的重复利用是非常有限的：我们的设计系统具有局限性。

---

现如今，原子设计的理念是从可以最终构建出整个项目的通用原材料（原子）入手。

![](https://cdn-images-1.medium.com/max/800/1*yyN6Ki0646UcFLsDabUShw.jpeg)

现如今：我们从原子开始并且用原子构建。

因此我们不仅拥有了充斥在所有界面之间的「家庭气氛」（译注：「家庭气氛」是一部法国的喜剧电影），更拥有了一个带来无限设计可能性的系统！

### 一切始于品牌识别（Brand Identity）

现在你也许在想：
**「如果我们想以原子的方式设计，该从哪开始呢？」**

对这个问题我给出了一个极富逻辑性的回答：从原子开始 ;)

因此我们首先要为产品设计出一个独特的视觉语言作为起点。它将会定义我们的原子和原材料，而且显然它应与品牌识别紧密相连。

这个视觉语言一定要有力度、易于扩展、并且能够从其展示媒体中解放自我；它必须能在所有地方奏效！

比如 [Gretel agency](http://gretelny.com/work/netflix/) 就为 Netflix 的品牌识别做了些出色的工作。

![](https://cdn-images-1.medium.com/max/800/1*Piomy-9oNTP0yT3VcmKH4w.png)

Netflix 的视觉语言：有力度、辨识度高且易于扩展。

多亏了强有力的品牌识别，我们会觉得已经有充足的材料发布最初的一系列原子了：色彩、字体选择、表单、阴影、空白、节奏、动画原则...

因此很有必要花时间设计品牌识别、思考重点是什么、以及如何能让品牌和产品与众不同。

### 让我们回到组件上来

有了原材料（目前仍然比较抽象），我们就可以根据产品目标以及我们辨识出的初始用户流程来设计我们最初的组件了。

#### 从关键特征开始

最让那些构建组件系统的设计师们胆寒的莫过于创建与什么都不关联的组件 ... 很显然，我们不会在没有购物功能的产品里设计购物车组件的！这完全不合常理！

最初的组件将会和产品或品牌目标紧密结合。

重申一遍，忘掉「页面」这个概念，我坚持侧重于产品特色或用户流程，而不是界面...

![](https://cdn-images-1.medium.com/max/800/1*bn-X_RyQCiW375OBOtnZxw.gif)

我们应该侧重于一个行为，而不是某个特定的界面。

我们会把注意力集中在某个我们希望用户去执行的操作以及它所需要的组件上。界面数量则会根据用户环境变化：也许在台式电脑上我们只需半个界面，智能手机却需要三个连续的界面来显示某个组件...

#### 充实组件系统

接下来为了充实组件系统，我们要在已经存在的组件和新功能间循环往复：

![](https://cdn-images-1.medium.com/max/800/1*35_KbPOTixmDVgUnShvitQ.jpeg)

通过在已经存在的组件和新功能间循环往复来充实组件系统。

最初的组件可以帮我们创建出最初的界面，接下来，最初的界面又会帮我们在系统中创造新的组件，或改变已有的组件。

#### 「通用」思维方式

![](https://cdn-images-1.medium.com/max/800/1*pMfHPwQ0dH_ITybJ9mVIGg.png)

在用原子设计方法设计时，我们应该牢记，同一个组件会在不同的上下文环境中被否决或重复使用。

> **因此我们将会把元素的结构和其内容真正区别开来**

例如我要创建一个「联系人列表」组件，我可以马上把它转变成一个通用的「列表」组件。

然后我会想想这个组件可能有的变形：如果我要添加或删除元素怎么办？如果文本占了两行呢？这个组件的响应式行为会是什么？

![](https://cdn-images-1.medium.com/max/800/1*zpLDZgMO0s6R0OsTX0g5NQ.png)

把一个特定组件转变为通用组件。

预见到这些变形后，我可以在这个组件基础上，创建出其他的组件：

![](https://cdn-images-1.medium.com/max/800/1*nn-NcMuzv6VdV3hpgvc7AQ.png)

通用组件的可能变形。

如果想让我们的组件系统内容丰富且可被再利用，这么做是必须的。

#### 「流体」思维方式

我们仍倾向于把响应式设计想成块状元素在特定断点上的重新组合。

然而实际上组件自身必须拥有它们自己的断点和流体行为（fluid behavior）。

多亏了像 Sketch 这样的软件，我们终于可以测试组件的各种响应式行为并且决定哪些组件应该是流体的，哪些组件应该是固定的。

![](https://cdn-images-1.medium.com/max/800/1*LXu8lJ-poM3d6TD3g6y2uw.gif)

我们需要预测组件的流体行为。

我们也可以预想到，一个组件在不同的用户环境中可能会有很大区别。

比如一个在台式电脑上显示为圆角矩形的按钮，在智能手表上可能就会变成一个带有图标的简易的圆形。

#### 部分和整体

通过原子设计构建组件系统有一个有趣的地方：我们在有意识地创建一系列互相依赖的组件。

![](https://cdn-images-1.medium.com/max/800/1*7xilIVazxs1V6rGCY9VuDA.jpeg)

完成细节部分后再后退一步，在更大的格局中审视结果。

我们不断地把视线拉近或拉远来进行作业。我们会先在一个细节、一个微交互、或是一个组件的微调上花时间，接着后退一步在上下文环境中审视其视觉效果，接着再后退一步查看整体效果。

这就是我们改进品牌识别，开发组件以及检验组件系统正常运作的方法。

### 使成品相关联

![](https://cdn-images-1.medium.com/max/800/1*gczpHM7chfldsdtvr7Umtw.png)

我们所有的组件都与原子相连。因此我们将可以轻松地更改部分组件系统，并观察这种更改对系统其余部分的副作用！

> **如今身为设计师的我们是何其幸运：利用改良之后的工具，我们终于可以创造出灵活且不断演化的系统了。**

当然，现在已经有可以让我们创建共享样式并使相似组件相互关联的软件了，例如 Sketch 和 Figma。但是我确信在接下来的几年内会出现更多这样的软件。

我们终于可以像开发者一样拥有自己的风格指南（style guide）并围绕它构建整个组件系统了。对系统中一个原子的微调就会自动反应到所有使用它的组件：

![](https://cdn-images-1.medium.com/max/800/1*xAMdhevJ8lLRMxO_yLljZg.gif)

所有组件都与原子相连。

我们很快就会意识到对组件的修改会如何影响整个系统。

我们也会意识到，通过使组件相连，一个新增的组件将会影响到整个系统的核心部分，而不仅仅是一个孤立的界面。

### 共享系统

为了保持多个产品的一致性，系统的共享是必须的。

我们都知道，当我们独立完成一个项目时，一致性很快就会消失，但当我们越来越多地和其他设计师合作时，保持一致性会更加困难。

这时又一次，我们已经拥有可以围绕一个共同的系统进行团队协作的工具了。

例如 Sketch 的 Craft，或是 Adobe 的[共享库](https://uxdesign.cc/how-to-use-adobe-cc-shared-libraries-and-make-the-most-of-it-d5e114014170)，这些工具使我们拥有一个公有且一直保持最新状态的单一数据源（single source of truth）。

![](https://cdn-images-1.medium.com/max/800/1*ses_KEaaren8CHX6KHoxXg.jpeg)

共享库：一直同步并保持最新状态。

共享库使多个设计师可以从相同的基本组件开始他们的设计。

这些库同时也精简了我们的工作，因为我们一旦在共享库中更新了一个组件，这个更改会自动应用到每个设计师使用的所有与其相关的文件上：

![](https://cdn-images-1.medium.com/max/800/1*jIV9_u7tWnNsmEwzlvYB9w.gif)

在库中的一个更改会自动改变所有与其关联的元素。

我必须承认，在我试用过的所有共享库中，还没有一个完美契合原子设计工作的... 原子和组件间强大的相互依赖性仍然缺乏，这一特点使我们可以创建灵活且不断演化的系统。

另一个问题是我们仍然有两种不同的库：设计师的库和开发者的库... 因此这两种库需要同步维护，带来了错误和许多额外的工作。

我理想中完美的共享库是这样的：一个可以同时满足设计师和开发者需求的的库：

![](https://cdn-images-1.medium.com/max/800/1*E8xw35qc9Iznt_3JB6o1Yg.jpeg)

我理想中的未来：一个可以同时满足设计师和开发者需求的单一的库。

但在我看到如 [React Sketch app](https://github.com/airbnb/react-sketchapp)（由 Airbnb 在近期发布） 这样使代码写成的组件可以直接在 Sketch 文件中使用的插件之后，我对自己说，也许这个未来已经不远了...

![](https://cdn-images-1.medium.com/max/800/1*lOm8j3gpZHjxoAei2g9F1Q.png)

React Sketch 插件：代码写成的组件可以直接在 Sketch 中使用。

### 写在最后

我想你应该已经理解了：我坚信需要使用组件设计界面，考虑灵活且不断演化的系统，并且我认为原子设计方法会帮助我们有效的达成这些目的。

**如果你也有在大小项目上使用组件系统的反馈，就在评论区分享你的经验吧！**

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

**这篇由 Audrey 撰写的文章旨在分享知识并扶持设计社区。所有在 uxdesign.cc 上发表的文章都遵从这一[**理念**](https://uxdesign.cc/the-design-community-we-believe-in-369d35626f2f)**

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
