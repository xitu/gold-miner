> * 原文地址：[CSS Architecture for Multiple Websites](https://medium.com/@elad/css-architecture-for-multiple-websites-ad696c9d334)
> * 原文作者：[Elad Shechter](https://medium.com/@elad)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-architecture-for-multiple-websites.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-architecture-for-multiple-websites.md)
> * 译者：[Baddyo](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[xionglong58](https://github.com/xionglong58)，[lgh757079506](https://github.com/lgh757079506)

# 多网站项目的 CSS 架构

> CSS 架构 —— 第三部分

复杂的 CSS 架构，可不是你在科班里能学到的东西。

我在互联网行业的第四份工作，是在我国一家领先的媒体新闻公司中任职一名 CSS/HTML 专家，我的主要职责就是开发可重用的、可扩展的、用于多网站的 CSS 架构。

![](https://cdn-images-1.medium.com/max/2000/1*WreGgi4zIgKz_cb5vRjGTA.png)

在本文中，我将与大家分享我在构建多网站架构领域中积累的知识和经验。

附注：如今，正规的项目都会用到 CSS 预处理器。而在本文中，我会使用 Sass 预处理器。

本文是我写的讨论 CSS 架构的系列文章中的第三篇。建议大家最好先读读此系列的第二篇 —— [《CSS 架构：文件夹和文件结构》](https://medium.com/@elad/css-architecture-folders-files-structure-f92b40c78d0b)，有助于加深对本文的理解。

## 用层构建世界

在开始开发一个大型项目之前，我们应该放眼全局，把多个网站的共同之处提炼出来。高楼大厦始于一砖一瓦，而项目的基石就是样式规格化、混入（Mixins）、通用图标以及局部模块层（元素、组件、图形逻辑、实体、页面……不一而足）等。

为了使多重项目（即多个网站）正常运转，我们必须决定哪些样式是通用样式、哪些是专有样式 —— 通用样式写进基础层，而专有样式写在与其对应的层中。这是一条充满摸索和碰壁的实践之路。每当思考的角度发生变化，我们都需要逐层地挪动样式代码，直到我们觉得顺眼为止，这都是家常便饭了。

理解了这项原则后，我们就可以开始着手构建作为基础的全局层了。这个全局层是整个多重项目（多个网站）的起始点。

下面的示例图向我们演示了彼时我司的项目需求。

![层架构](https://cdn-images-1.medium.com/max/2000/1*zYZV-QHyYrA_1XwxibQw2A.png)

基础层要保持轻量，其中只包含 CSS 初始化、基本的 SASS mixins、通用图标、通用字体（如需）以及功能类，如果某些网格布局适用于所有网站，就将其作为通用网格添加到基础层中。在 `_partials.scss` 层（元素、组件等）中，我们主要用到的是 `_elements.scss` 层，该层中包含诸如通用弹窗、通用表单和通用标题等此类局部模块。我们应该在基础样式中添加的是所有（或者大多数）底层样式共有的部分。（更多关于文件夹和文件结构的细节，参见我的[上一篇文章](https://medium.com/@elad/css-architecture-folders-files-structure-f92b40c78d0b)）

#### 如何组织多个层

在我们的架构中，每个层都至少包含三个文件：两个私有文件（局部样式文件和配置文件，称之为私有是因为它们不会被编译成一个 CSS 文件）和一个公共文件（本层的主文件）。每层的配置文件 **`_config.scss`** 通常包含变量。**`_local.scss`** 文件则包含内容样式，为当前层充当控制器或者包管理器的角色。而**第三个**文件（layer-name.scss）会**调用**前二者。

**layer-name.scss 文件：**

```
@import "config";
@import "local";
```

另外一个我们要给自己定下的原则就是，尽可能把每个文件都拆分成尽可能小的部分（小文件）。这个原则会让重构非常方便。

在每一层中，都要保证**只编译 layer-name.scss 文件**，即使某些层代表的是一个“虚拟项目”（如上面示例图中的“基础层框架”）。

对于不会被编译成单独文件的私有文件，我们用一个下划线（`_`）作为其文件名的前缀。这里的下划线代表着此文件不能单独存在。

**注意：**当导入私有文件时，我们书写其文件名时可以不必带上前缀下划线。

**层架构示例：**

![**_local.scss 文件导入了 local 文件夹中所有的 *.scss 文件**，而这些 local 文件夹中的 *.scss 文件按序调用私有文件夹中所有的 *.scss 文件。同理，**_config.scss 文件调用 config 文件夹中所有的 *.scss 文件**。](https://cdn-images-1.medium.com/max/2000/1*0hwUrfXGWkZR-aTVfoojyA.png)

**文件夹结构长这样：**

```
sass/ 
 |
 |- base-layer/
     |- config/     
     |- local/
     |- _config.scss
     |- _local.scss
     |- base-layer.css  (编译后的层样式)
     |- base-layer.scss
```

## 继承

假设我们想要从基础层开始创建一个项目。我们需要根据 base-layer 文件夹的内部结构，用新项目的名称照猫画虎地克隆一套出来。在后续例子中，我们把这个新项目称为 **inherited-project**。

**提示**：把所有的层目录和项目目录都放在 Sass 的根目录中。

该项目至少包含一个 **`_config.scss`** 文件、一个 **`_local.scss`** 文件和此层的核心 Sass 文件 —— 在本例中即为 **`inherited-project.scss`**。

所有的层和项目都位于 Sass 的根目录中。

```
sass/ 
 |
 |- base-layer
 |   |- config/     
 |   |- local/
 |   |- _config.scss
 |   |- _local.scss
 |   |- base-layer.css  (编译后的层样式)
 |   |- base-layer.scss 
 |
 |- inherited-project
     |- config/     
     |- local/
     |- _config.scss
     |- _local.scss
     |- inherited-project.css  (编译后的层样式)
     |- inherited-project.scss
```

项目 **inherited-project** 的配置文件引入了 **base-layer** 中的配置文件。这样一来，我们就能增加新变量或者覆写上层（**base-layer**）中的已有变量了。

以下为 **inherited-project/_config.scss** 的一个**例子**：

```
/*加载 base-layer 配置信息 */
@import "../base-layer/config.scss";

/** 局部的 Config 层 (按需添加或覆写变量)**/
@import "config/directions.scss";
```

内容样式文件 **inherited-project/_local.scss** 亦同理：

```
/* 导入 base-layer 局部组件  */
@import "../base-layer/local.scss";

/* 局部字体 */
@import "local/font-almoni.scss";

/* 局部组件 */
@import "local/elements.scss";
@import "local/components.scss";
```

如果要创建的新层既有通用样式又有独特样式，那么从 `base-layer` 文件夹继承基础层样式再合适不过了。

这一层会创建一个名为 **`inherited-project.css`** 的 CSS 文件。

#### 在内部层中覆写变量

使用“层”的方式覆写变量非常简单。

比方说在基础层中有一个名为 **`$base-color`** 的变量，其值为 blue（**`$base-color: blue;`**）。要想覆写此变量，就需要在**局部文件** `_config.scss` 中更新它的值。现在，所有使用该变量的组件 —— 不论是继承于**基础层**还是定义于**局部层** —— 都会更新对应变量的的颜色值。

## Global Story 全局

某些模块并非在所有层中都会用到，因此如果你在基础层中定义它们，其他项目就会导入冗余代码。为了解决这个问题，我走了另一条路线，采用了**全局模块**的概念。

这个概念是说，把仅用于某些层的模块放置于一个新的根目录（`_partials`）中，这个新的根目录位于所有层之外。然后，任何层都可以从全局目录 `_partials` 中导入所需模块。

**下图**展示了将模块分离的例子：

![](https://cdn-images-1.medium.com/max/2000/1*F43F_4fEqXCCTLNz07nrqg.png)

每一层都可以按需从全局目录 **`_partials`** 中调用一个或多个模块。

**全局目录 **`_partials`** 示例：**

```
sass/ 
 |
 |- _partials/ 
 |- base-layer/ 
 |- inherited-project/
```

**从 **`_partials`** 导入模块的 local.scss 文件：**

```
/* 导入 base-layer 中的局部组件 */
@import "../base-layer/local.scss";

/* 局部组件 */
@import "local/partials.scss";

/* 添加全局模块 */
@import "../_partials/last-connection";
```

**些许额外忠告**

* **组织结构要有条理**。要一直记得以满足需求的方式规划项目、保持最佳结构。
* **别重蹈覆辙**。仅用 `@import` 即可轻松导入另一层的组件。比如说，某些组件定义在一个“体育”项目中，而这些组件与另一个项目中的“新闻”网站有关联。那我们就可以直接把这些组件 `@import` 进“新闻”网站中。（网站 = 层 = 项目）
* **充分利用 IDE 快捷方式**。选用一款便于重构的编辑器，免于导致报错或故障。
* **立新不可破旧**。在开发和后续重构中，每次都要把所有 Sass 根文件一同编译，以免新旧脱节。

## 总结

在本文中，我向大家展示了针对多网站项目的 CSS 体系结构的构建方法，这套思想提炼于我经年积累的知识和经验。

本文是系列文章 **CSS 架构文章新篇**的第三篇，我会每隔几周跟大家分享后续篇章。

如果觉得本文有趣，欢迎在 [**twitter**](https://twitter.com/eladsc) 上或者 [**medium**](https://medium.com/@elad) 上关注我。

## 我的 CSS 架构系列文章：

1. [规格化 CSS 还是 CSS 重置？！](https://medium.com/@elad/normalize-css-or-css-reset-9d75175c5d1e)
2. [CSS 架构 —— 文件夹和文件架构](https://medium.com/@elad/css-architecture-folders-files-structure-f92b40c78d0b)
3. [多网站项目的 CSS 架构](https://medium.com/@elad/css-architecture-for-multiple-websites-ad696c9d334)

## 结束语

好了，这次就分享到这里。
衷心希望大家喜欢本文，并能从我的经验中获益一二。
如果你喜欢本文，请点赞并和大家分享你的心得，我将不胜感激。:-)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
