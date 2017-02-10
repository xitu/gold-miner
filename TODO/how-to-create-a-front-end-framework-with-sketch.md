> * 原文地址：[How to create a FRONT END FRAMEWORK with Sketch](https://medium.com/sketch-app-sources/how-to-create-a-front-end-framework-with-sketch-2379edb5e7df#.r6g3tx6wk)
* 原文作者：[Seba Mantel](https://medium.com/@sebamantel)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Ruixi](https://github.com/Ruixi)
* 校对者：[marcmoore](https://github.com/marcmoore),[AceLeeWinnie](https://github.com/AceLeeWinnie)

# 如何用 Sketch 打造「前端框架」

![](https://cdn-images-1.medium.com/max/800/1*5XO0vb0mmbRoCLvB1Laxww.png)

前端框架
**需要考虑的事项：**

当我们与一大群设计师同时推进同一个项目的时候，要做到协调一致非常困难。而在面对有审美要求、对指定行为和互动有明确要求的系统性项目时尤为如此。

我们可用于建立界面的标准化的手段之一就是定义一份风格指南（纯视觉角度），这样可以帮助整个设计团队避免在未来可能出现的改动带来的不必要的工作时间，提高工作效率。让我们可以把精力更好的集中在组件的行为和应用中的交互上。

一份优秀的风格指南需要被团队全员采用，比如开发者、产品负责人、项目经理，甚至客户都要接受。这对各个成员之间的沟通与合作有极大裨益。我们称这种“升级版”的风格指南为 **前端框架(FEF)**。

在开始动手制作 **风格指南** 之前，有几条原则需要你牢记在心： 

> **必须可用** 且必须易于融入不同的工作流之中。

> **必须有教育引导的作用** 且需要包含可以帮助我们创造新的组件和交互的样板。

> **必须可视化** 且规范明确。

> **必须协同**，这样每个成员都可以修改和添加新内容。

> **必须随时更新**，所以它应该放在一个特殊的库里，无论是谁做了修改都得更新文件。 

### 来开始动手打造前端框架吧

#### **第 1 步, 定义 IA：**

**第一步是定义内容（根据项目，划分如下）：**

1. **样式：** 色系，字型字体，icon。（这里 font family 和 typography 的含义比较接近，于是对字体类型的选用和对字体本身的格式要求做了合并，另附[参考文章](http://blog.justfont.com/2013/02/some_nouns/)，译者注）
2. **版式布局和页面模式** 不同的组合元素，网格和主导航。
3. **导航元素：** 链接，标签和分页。
4. **模态对话框：** 弹出框，工具提示（提示框），下拉菜单，消息对话框。
5. **文本输入：** 表单。
6. **组件**

#### **第 2 步， 创建前端框架内容:**

**样式**— 首先需要定义主色，次色和其他辅助色，并指定其所适用的 RGB 色值。

![](https://cdn-images-1.medium.com/max/800/1*0680BvMRMDvOqv4MRA4VQg.png)

色彩
然后在 sketch 里创建 shared style，以便在未来的设计工作中优化工作流程。

![](https://cdn-images-1.medium.com/max/800/1*21VbE5DSGT7keM78gPgmwQ.png)

创建新的 shared style
在前端框架中合理的组件命名会使 sketch 中的样式表更加有条理。

![](https://cdn-images-1.medium.com/max/800/1*HF9eeJVg8B9SPtTZaILG8g.png)

这样，在我们想要快速更改一个组件的颜色的时候，只需要在 style 中进行更改，而且可以确保不会混入其他的色彩。

![](https://cdn-images-1.medium.com/max/800/1*BECrGby5mDvj2CvH0PD7Tw.gif)

对于版式，也是 **类似的步骤** ：

![](https://cdn-images-1.medium.com/max/800/1*7Y7b4PgKIfW0ZjfQRVdeYw.png)

1. 详细定义将会在设计中使用的字体，主要的和次要的。

2. 和颜色类似，在 sketch 中创建 style。

![](https://cdn-images-1.medium.com/max/800/1*r5kXboT_OU3FuvYW-JTdDA.png)

在创建字体和色彩的样式之后，添加将要用到的全系列 icon ，并将其转化为 symbol。这样，如果有人更改它们的话，凡是用到它们的地方都会同时修改。

![](https://cdn-images-1.medium.com/max/800/1*zY38WGccGulaGcDx9mN_pQ.png)

**Tip**: 创建同一 icon 的不同状态，将其按照 **组件名/状态/子状态** 的规则命名。这样我们就可以轻易地从主菜单访问到所有状态，不必再去修改原来的 icon 了。

![](https://cdn-images-1.medium.com/max/800/1*Plvt7vP2xWMqdNddWTpAEg.png)

这也同样适用于那些有多种状态的组件，比如复选框（checkbox）。相应的命名规则为：

![](https://cdn-images-1.medium.com/max/600/1*x7SSpMS1HYyksCeGDlf0ew.png)

1. *checkbox/normal*
2. *checkbox/hover*
3. *checkbox/focus/minus*
4. *checkbox/focus/check*
5. *checkbox/pressed*
6. *checkbox/disabled/check*
7. *checkbox/disabled*

这些都会显示在顶部菜单的 **插入** 里。

![](https://cdn-images-1.medium.com/max/800/1*kBtWUmlgfvJ9eTjD4B3srg.png)

这样，修改状态就简单多了，有效地解决了设计中的不少麻烦。

![](https://cdn-images-1.medium.com/max/800/1*O5oibWdHf0nAw2F_H2o3eQ.gif)

### **第 3 步，创建组件：**

在定义了通用样式并且在 sketch 中创建 style 之后，开始忙活组件吧，它们会在整个应用中不断被重复使用 （比如像是主导航啦，下拉菜单啦，弹出框，数据网格，等等）。这主要就是为了在创建新的界面的时候能让全体设计师保持一致。 

我很喜欢用这些组件来举例子：

![](https://cdn-images-1.medium.com/max/600/1*RsguKlz0WVVfrxnby2cGGg.png)

工具提示，设计师要是想要改变背景色的话，就和在 style 中选择相应颜色一样简单。 

---

![](https://cdn-images-1.medium.com/max/600/1*rmoiLTbljAL_Iv_jREEfqw.gif)

**表单** — **Tip** : 通过将文本框作为 symbol，可以在 sketch 中不访问 symbol 本体的情况下修改内容。*

**每个组件都必须附带一段说明文本（何时使用以及将会产生的反应）。** 必要的话，你可以在右边指定一个部分来说明大小\边距和样式。

![](https://cdn-images-1.medium.com/max/1000/1*XTVyLYKhaCv1sbPbk36HQQ.png)

![](https://cdn-images-1.medium.com/max/600/1*2czyxGfUjQTlZlVcnYSHvQ.png)

此规范的重点在于向开发团队提供信息，以便它们会被添加在同一文档或者 Zeplin 中来作为沟通工具。这样你就可以得到 css 值和下载组件了。

---

![](https://cdn-images-1.medium.com/max/800/1*jkfloUVJ4GNoYqjxhMkPmg.png)

### **第 4 步，行为表现：**

有些组件的大小（宽和高）取决于我们所使用的网格的大小，比如数据列表或数据网格。sketch 为这种类型的组件图提供了一系列的选项，以便预定义每个元素的位置，这个表格将会是响应式的。

![](https://cdn-images-1.medium.com/freeze/max/30/1*GmMBqaF-_o8DSW15ofCA1Q.gif?q=20)

![](https://cdn-images-1.medium.com/max/800/1*lsv9CluG3SLG1IiUtHrsoQ.gif)

如何实现响应式效果呢？在 Sketch V39 中，添加了 4 个新的选项来实现这种效果。

![](https://cdn-images-1.medium.com/max/600/1*2fdvGW7BjPqQJux63bv9BQ.png)

选项如下：

**Stretch** （默认）——在调整分组大小的时候浮动调整图层的大小（此选项适用于分割线和每一行的矩形）。

**Pin to corner** —— 自动将新图层固定在最近的角落。在调整分组大小的时候不影响图层的大小。（适用于图标右上和和复选框。）

**Resize object** —— 在调整分组大小的时候调整图层大小并保持其位置的百分比。（文本框必须有这个选项，来保证它们的边缘和左侧的分界线。）

**Float in place** —— 在调整分组大小的时候图层大小不变，但其位置按照百分比缩放。（适用于必须在列中居中的 icon。）

想要了解更多关于此类表格创建的信息，推荐以下文章： [https://medium.com/sketch-app-sources/https-medium-com-megaroeny-resizing-tables-withsketch-3-9-2e02e6382d3d#.fsx0udd9v](https://medium.com/sketch-app-sources/https-medium-com-megaroeny-resizing-tables-with-sketch-3-9-2e02e6382d3d#.fsx0udd9v)

### **第 5 步，参考**

最后，除了在所有应用中维护一种设计语言之外，每个元素的结构都可能随着产品需求和需要而变化。

所以，建议创建最后一个章节，来展示组件如何依据功能需求来使用。这样设计者们可以分析并学习如何在不同的架构下复用样式。

![](https://cdn-images-1.medium.com/max/1000/1*7dwpsMQbPutwLDEz8cCzfg.png)


### **共同的未来**

在一个复杂的项目中，将团队全体成员的工作建立在一份风格指南之上可以大大提高工作效率，这种协调可以有效避免类似“某个组件在较小分辨率下的行为是什么”的问题。

大多数情况下，我们总是着力于尽快推出最初的版本，因此，问题是随着产品的产生而出现的。在这种情况下，前端框架可以有所作为而且避免一系列让人头疼的问题。

这里是 sketch 文件，可随意下载。[https://www.dropbox.com/s/kknipcg3u0e69ds/FEF.sketch?dl=0](https://www.dropbox.com/s/kknipcg3u0e69ds/FEF.sketch?dl=0)
