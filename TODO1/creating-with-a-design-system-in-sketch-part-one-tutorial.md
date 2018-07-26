> * 原文地址：[Creating with a Design System in Sketch: Part One [Tutorial]](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-one-tutorial-5116e36213f9)
> * 原文作者：[Marc Andrew](https://medium.com/@marcandrew?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-one-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-one-tutorial.md)
> * 译者：[pmwangyang](https://github.com/pmwangyang)
> * 校对者：[Zheng7426](https://github.com/Zheng7426)

# 在 Sketch 中使用一个设计体系创作：第一部分[教程]

## 在 Sketch 中建立一个设计体系并使用它工作

![](https://cdn-images-1.medium.com/max/1000/1*jwTJroljaX-67eahDjPGKw.png)

### 🎁 想用我的优质 Sketch 设计体系大幅优化你的工作流程吗？你可以点击[这里](https://kissmyui.com/cabana)获取 Cabana。

使用推广码 **MEDIUM25** 购买可享 **75 折**优惠。

![](https://cdn-images-1.medium.com/max/800/1*aEcIFESUCKiFVRpssVQTOA.jpeg)

* * *

**我看到过许多介绍建立 Sketch 设计体系元素的教程，但是很少有教程会实际上教你在练习中创建新的、特别好的设计体系。**

这就是我这一系列教程想要做的 —— 不仅仅是教你创建设计体系的元素，还有如何用你创建的体系设计一个适配多个设备的 iOS App，并且告诉你我如何构建自己的体系以及背后的思考过程和决策。

### 系列导航

*   **第一部分**
*   [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-two-tutorial.md)
*   [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-three-tutorial.md)
*   [第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-four-tutorial.md)
*   [第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-five-tutorial.md)
*   [第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-six-tutorial.md)
*   [第七部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-seven-tutorial.md)
*   [第八部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-eight-tutorial.md)
*   [第九部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-nine-tutorial.md)

* * *

![](https://cdn-images-1.medium.com/max/1000/1*a-kVsheThBDPzeyMSGDLjQ.jpeg)

### 设计体系总览

好，在我们埋头开始设计我们这非常华丽且风格类似 Medium 的 iOS 应用之前（谁说山寨来着？），我们对一会教程中将要用到的设计体系（基于 Cabana-Lite）的 Sketch 文件进行一个快速概览。

在设计版式（开始）文件中有三个页面……

*   _Design System (Setup)_ **设计体系（设置）**
*   _Symbols_ **组件**
*   _Format_ **格式**

让我们按顺序说……

#### 设计体系（设置）

![](https://cdn-images-1.medium.com/max/800/1*5K_jofmNF-5emgDSd7PejA.jpeg)

这就是见证奇迹的地方！这里可以管理你的项目中至少 90% 的样式。

设置这些元素为基准颜色或文字样例，这样你调整它们的时候，你的所有设计都会自动适应变化。

你在这里的所有改动会映射到组件页面（一会我们会涉及），当然，也会自动适应到你当前的画板上。

在这个页面上有 2 个画板……

*   _Colors + Overlays + Duotone_ （译者注：画板名比较小，注意左上角>_<）
*   _Typography_ (我们会在第二部分涉及到这个画板)

#### Colors + Overlays + Duotone （颜色 + 覆盖色 + 双色调）

![](https://cdn-images-1.medium.com/max/800/1*9DjFvdT281n_nZb2sLgejA.jpeg)

通过这个画板你可以看到，我将所有的颜色资源组织到了一起。如基准色（Base Colors），叠加色（Color Overlays）和图片效果（在这个例子里是双色调效果 “Duotone Image”）。

其实在我个人的 Cabana 设计体系里我做了一点分割，将基准色、叠加色添加到了 Colors 画板，像双色调图之类的添加到另一个名为 Various 的画板，这个画板还包含渐变、边框阴影等。但我想让你感觉这个教程更紧凑些，所以采取这样的布局方式，还可以吧？

#### Base Colors（基准颜色）

![](https://cdn-images-1.medium.com/max/800/1*EEaKR_Kq0sLD54eRgFbLJQ.jpeg)

在这个系列教程里，设计我们的 iOS App 只需要 4 种基准色。如果你创建你自己的体系，需要在一个大型项目中覆盖所有的基准色，创建像下面这些基准色是一个明智的选择（当然这只是建议）……

*   _Primary_ **（原色，译者注：或者可以称为“主题色”）**
*   _Secondary_ **（二次色）**
*   _Tertiary_ **（第三色）**
*   _Black_ **（黑色）**
*   _Grey_ **（灰色）**
*   _Light Grey_ **（淡灰色）**
*   _Success_ **（成功色）**
*   _Warning_ **（警告色）**
*   _Error_ **（错误色）**

你可以把上面的列表替换成自己想要的内容，比如移除第三色、添加另一种深度的灰色，以获得一些自定义元素，来完成适合自己设计体系的一些项目。

好，让我们回头看看这些基准色，我给你一些在我自己的设计体系中设置基础颜色的秘诀 —— 使用 **图层样式**。

我们首先设置一下原色描边，创建一个 **200x200** 的矩形（快捷键“R”），移除填充色，用我选定的十六进制颜色设置 **1px** 的描边，并设置圆角半径为 **4**。

![](https://cdn-images-1.medium.com/max/800/1*Vn_ITS4EHqh7sxlvtjujRA.jpeg)

然后创建一个新的图层样式（在 Prototyping 栏中选择 Create new Layer Style）……

![](https://cdn-images-1.medium.com/max/800/1*mK2HsJYdyNqsEJ6rgaytgg.jpeg)

并把它命名为 _Border/Primary_ **（描边/原色）**……

![](https://cdn-images-1.medium.com/max/800/1*rz6lSqepDeLmbYjPreTwEQ.jpeg)

再设置一个原色填充矩形，创建一个**200x200** 的矩形（快捷键“R”），选择我选定的十六进制颜色，并设置圆角半径为 **4**。

![](https://cdn-images-1.medium.com/max/800/1*Q0JRENrjTqBCSwpQHOrvqQ.jpeg)

然后创建一个新的图层样式并命名为 _Fill/Primary_ **（填充/原色）**。

![](https://cdn-images-1.medium.com/max/800/1*Xs9Crw81EXCXdh4MCwHiVA.jpeg)

然后我将这两个矩形重叠，你可能要问，为什么这么做？

这允许我们使用这样的设计体系时，仅仅选择一次就能很容易的修改图层样式，从而改变描边和填充色。

这样占据的屏幕更小，并且最重要的是，比这儿放一个 **A 元素**那儿放一个 **B 元素**改动起来快多了。

接下来，我在合适的位置设置好所有的基准色和对应的图层样式后，给它们设置好名称（比如 Primary、Black、Grey 等等）。

![](https://cdn-images-1.medium.com/max/800/1*zleRk-jDNjwSQM0rnyZXhw.jpeg)

现在我有了方便的参考点，并且鼠标点几下就能调整。比如，如果需要改变原色，选中它，再选择图层样式，就全部搞定了不是吗？不需要任何多余操作，也不用忍受“不不不，我不是要选中这个元素”这种令人抓狂的事。

接下来重复这个过程，将我上文提到过的所有其他基准色（黑色、灰色等等）设置好图层样式，命名为和 _Border/Primary_ 和 _Fill/Primary_ 同样的格式。

#### Color Overlays （颜色叠加层）

![](https://cdn-images-1.medium.com/max/800/1*_NEQy-MOpVB6kRL4PtdjIA.jpeg)

在这个教程里，我只在叠加颜色中建立了一个名为 Black（黑色）的叠加层。

把 Black 层叠加到图片上来调整对比度很容易，它的十六进制色统一地取自基准色 _Black_**（黑色）**。

就像我提到的基准色一样，举一反三，在你的设计体系中，实际上只要让叠加层来匹配以下几个基准色……

*   _Primary_ **原色**
*   _Secondary_ **二次色**
*   _Black_**（刚刚这个例子中使用的）**

我来给你一些指引，告诉你如何创建颜色叠加层，当然，在我的设计体系里，还是使用图层样式。

现在我主要讲解下面教程里将要用到的黑色叠加层。

创建一个 **432x248** （这个尺寸是我随便选的，你可以设置其他尺寸）的矩形（快捷键“R”）并设置圆角半径为 **4**（个人喜好，这样看起来更漂亮一些），粘贴之前创建的 Black 基准色的十六进制色值，然后设置不透明度为 60%。

![](https://cdn-images-1.medium.com/max/800/1*OCNWm39eED210ruevgB85w.jpeg)

然后创建一个新的名为 _Overlay/Black_**（叠加层/黑色）**的图层样式。

![](https://cdn-images-1.medium.com/max/800/1*kVA7DcMOm0NF1oaRrcno-A.jpeg)

这就完成了，但是考虑到这个叠加层 99% 的情况是覆盖在一个图片上，我想现在最明智的事，是在新的叠加图层样式旁边添加一个小小的预览。就像我刚刚提到的，它在我的设计中位于图片的顶部，这意味着我可以更好的预览叠加层的效果，并且允许我调整它的不透明度，直到我对结果满意为止。

让我来教你怎么做……

首先创建一个和前面创建过的颜色叠加层尺寸一致的矩形（R），并且用图片填充它。

![](https://cdn-images-1.medium.com/max/800/1*U8AQvkA5u9n8KCw5loa8gQ.jpeg)

接下来创建一个同样尺寸的矩形（R），覆盖在图片上，然后套用刚刚创建的 _Overlay/Black_**（叠加层/黑色）**图层样式。

![](https://cdn-images-1.medium.com/max/800/1*khyh4RrFpHT1aH4jYjCC_w.jpeg)

就像我刚才说的一样，现在我有一个实时的预览，可以观察叠加层添加到图像时的外观，并可以相应地调整，直到我对结果满意为止。

#### Duotone （双色调图）

最后，让我们来学习双色调图片，我们在教程中只展示了一种双色调图片样式，但是在 Cabana 设计体系中我创建了 9 种之多。

是的，像双色调图片或者渐变的存在只是为了好看，并不是你自己设计体系里像基准色和阴影（译者注：也可译为“图层阴影”）一样的必要元素。但我为什么提到它们呢？因为你永远不会知道你的项目中会包含什么玩意儿。

好，在我们完成这部分教程之前，让我告诉你如何用我自己的体设计系和设计版式（开始）文件快速创建双色调图片，我们可以称之为“奖励关卡” ^_^

像我刚刚做叠加层图像预览一样，创建一个矩形（R），用图像填充它。

![](https://cdn-images-1.medium.com/max/800/1*BYB-1sB80cuCUX2ASs6u-g.jpeg)

然后只需要在元素中添加几个额外的填充颜色，并调整混合模式，直到有一些颜色可以透过来，就像文件中包含的示例那样，这就叫“双色调”（当当当当！过关~）……

*   _#041674_ & _Lighten_ **光照**
*   _#1EDE81_ & _Multiply_ **正片叠底**

![](https://cdn-images-1.medium.com/max/800/1*H_XjH44nZrhzyKyCVev12Q.jpeg)

![](https://cdn-images-1.medium.com/max/800/1*N-Tpy9zVquh_XpAhoL7rew.jpeg)

我们来优化一下，在检查器中拖拽来重新排列填充样式，直到如下图所示

![](https://cdn-images-1.medium.com/max/800/1*dhaaEb1gIlKKkNXTcwMFvA.jpeg)

现在给这个预览起个酷炫狂拽吊炸天的名字（比如：哥布林），机智如我！

* * *

好了，这一系列教程的第一部分就圆满结束了，记得回来和我一起学习第二部分哦。第二部分会涉及设计体系中的文字排版，还有我如何整合这一部分到设计体系中的重要的提示和建议。

**跳转到第二部分点击[这里](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-two-tutorial-445e0264556a)…**

### 🎁 想用我的优质 Sketch 设计体系大幅优化你的工作流程吗？你可以点击[这里](https://kissmyui.com/cabana)获取 Cabana。

使用推广码 **MEDIUM25** 购买可享 **75 折**优惠。

**感谢阅读**

**马克**

**设计师、作家、父亲以及哈什·布朗斯的爱人**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
