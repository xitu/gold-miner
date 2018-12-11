> * 原文地址：[Understanding Android’s vector image format: VectorDrawable](https://medium.com/androiddevelopers/understanding-androids-vector-image-format-vectordrawable-ab09e41d5c68)
> * 原文作者：[Nick Butcher](https://medium.com/@crafty?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-androids-vector-image-format-vectordrawable.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-androids-vector-image-format-vectordrawable.md)
> * 译者：
> * 校对者：

# 了解 Android 的矢量图片格式：`VectorDrawable`

![](https://cdn-images-1.medium.com/max/2000/1*C9YTPhelGjw4AoXlHeuqig.png)

Android 设备有不同的尺寸、形状和屏幕密度。这正是我为什么喜欢使用与分辨率无关的 vector assets 的原因。但它们究竟是什么？有什么益处？需要什么成本？什么时候应该使用它们？怎么创建和使用它们？在这一系列文章中，我将会探讨这些问题并解释为什么在你的应用中应该大量的使用 vector assets 以及怎样最大限度的使用它们。

### 光栅 vs 矢量

大多数的图像格式（png、jpeg、bmp、gif、webp 等等）都是栅格，这意味着他们将图像描绘为一个固定的像素网格。因此，对于固定分辨率的栅格图像，我们只了解每个像素的颜色，却不理解其中包含的内容。然而，矢量图像是通过在抽象大小的画布上定义一系列形状来描绘图像。

### 为什么使用矢量？

矢量资源有三大好处，分别是：

*   好用
*   占用资源少
*   动态

#### 好用

矢量图可以优雅的调整大小；这是因为它们将图像绘制在抽象大小的画布上，你可以放大或缩小画布，然后重新绘制对应尺寸的图像。但是，栅格资源在重新调整大小后会变得很糟糕。缩小栅格资源是 OK 的（意味着会丢失一些信息），但是放大它们会导致模糊或者色带状的失真，因为它们必须插入缺失的像素。

![](https://cdn-images-1.medium.com/max/800/1*Z_ol_Ajp2SsMNx3DHKUgfQ.png)

放大的光栅图像（左）与放大的矢量图像（右）

这就是为什么在 Android 上我们需要为不同密度的屏幕提供多个版本的栅格资源：

*   res/drawable-mdpi/foo.png
*   res/drawable-hdpi/foo.png
*   res/drawable-xhdpi/foo.png
*   …

在需要的时候，Android 会选择最接近的较大密度并将其缩小。随着设备具有越来越高的屏幕密度,应用开发者对相同的资源必须不断创建、囊括、转换更多的版本。需要注意的是，许多现代设备的屏幕密度并不是精确的（例如，Piexl 3 XL 是 552 dpi，介于 xxhdpi 和 xxxhdpi 之间），所以资源通常会被缩放。

因为矢量资源可以优雅的调整大小, 你只需包含单个资源，它就会在任何屏幕密度的设备上安全运行。

#### 占用资源少

矢量资源通常会比光栅资源占用资源更少，因为你只需要提供一个版本，而且矢量资源很好被压缩。

例如 [Google I/O app](https://play.google.com/store/apps/details?id=com.google.samples.apps.iosched) [做的改变](https://github.com/google/iosched/commit/78c5d25dfbb4bf8193c46c3fb8b73c9871c44ad6) 通过将一些 PNG 图标从栅格转换成矢量，节约了 482 KB。尽管听上去不是很多，但这仅仅是对小图像而言；更大的图片 (如插图) 会节省更多。

这张 [插图](https://github.com/google/iosched/blob/71f0c4cc20c5d75bc7b211e99fcf5205330109a0/android/src/main/res/drawable-nodpi/attending_in_person.png) 来自于上一年的 Google I/O 示例 APP 流程：

![](https://cdn-images-1.medium.com/max/800/1*tzT8u-ungCXb_CHGAyAiPA.png)

对于插图，矢量是很好的选择

我们无法用 VectorDrawable 替换它，因为当时没有广泛支持渐变（现在已经支持），所以我们不得不发布一个栅格版本 😔。如果我们能够使用矢量，那么这将只有其大小的 30%，而且会取得更好的效果:

*   Raster: Download Size = 53.9KB (Raw file size = 54.8KB)
*   Vector: Download Size = 3.7KB (Raw file size = 15.8KB)

> 请注意，虽然 [Android App Bundle](https://developer.android.com/platform/technology/app-bundle/) 是通过向设备提供所需的密度资源而带来相同的好处，但 VectorDrawable 通常会更小，并且无需创建更大的栅格资源。


#### 动态

由于矢量图像描述它们的内容并不是将自己”扁平化“为像素，这为动画、交互或动态主题等有趣的新可能打开了新大门。将来会写更多关于这方面的文章。

![](https://cdn-images-1.medium.com/max/800/1*rJQEzHNMyBrZxjzpPDb84w.gif)

矢量会保持图像结构，所以单个元素可以是主题或动画。

### 权衡

矢量确实也有一些需要考虑的缺点：

#### 解码

正如前面所诉，矢量图像描述了自己包含的内容，因此它们需要在使用前进行 inflate 和 draw 操作。

![](https://cdn-images-1.medium.com/max/800/1*OsKMU2enRRjNVo09fEb08A.png)

在渲染之前解码矢量所涉及的步骤

有如下两步：

1.  **Inflation**. 你的矢量文件必须被读取和解析成为 `[VectorDrawable](https://developer.android.com/reference/android/graphics/drawable/VectorDrawable)` 对你声明的 [paths](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/graphics/drawable/static/src/main/java/androidx/vectordrawable/graphics/drawable/VectorDrawableCompat.java#1809), [groups](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/graphics/drawable/static/src/main/java/androidx/vectordrawable/graphics/drawable/VectorDrawableCompat.java#1440) 进行建模。
2.  **Drawing**. 然后必须通过执行 `Canvas` 绘制命令来绘制这些模型对象。

这两步的执行时间与矢量的复杂性和你执行的操作类型成正比。如果你使用非常复杂的形状，将会花费更长的时间将之解析成为 `[Path](https://developer.android.com/reference/android/graphics/Path)` 。类似地，更多的绘制操作将花费更长的时间来执行（还有一些更耗费时间的，例如剪辑操作）。

对于静态矢量，绘图阶段只需执行一次，然后可以缓存为 `Bitmap`。 对于动画矢量，就无法进行此优化，因为它们的属性必然会发生变化，需要重新绘制。

将其与像 PNG 这样只需要解码文件内容的栅格资源进行比较，这些资源随着时间的推移已经经过高度优化。

这是栅格与矢量的基本权衡。矢量提供上诉好处，但代价是渲染更加昂贵。在 Android 早期, 设备性能差一点，屏幕密度差别不大。现在，Android 设备性能越来越好，屏幕密度却各不相同。这就是为什么我认为现在是所有 APP 使用矢量资源的时候。

#### 适应性

![](https://cdn-images-1.medium.com/max/800/1*PyZVYFWUF5bH9DYpwW16aQ.png)

由于格式的性质，矢量在在描述一下矢量资源（如简单图标等）时 **非常有用** 。他们在编码摄影类型图像时非常糟糕，因为它很难将其内容描述为一系列形状，使用光栅格式（如 webp）可能会更有效率。这当然是一个范围，取决于你的资源的复杂度。

#### 转变

据我所知，没有设计工具能够直接创建 `VectorDrawable' ，这意味着有一个来自其他格式的转换步骤。 这会使设计人员和开发人员之间的工作流程复杂化 我们将在以后的文章中深入讨论这个主题。

### 为什么不用 SVG？

如果你曾经使用矢量图像格式，你可能会遇到网络上的行业标准 SVG 格式（可缩放矢量图形）。它是强大、成熟的建模工具，它同时也是一个强大的标准。它包括许多复杂的功能，如执行任意 javascript，模糊和滤镜效果或嵌入其他图像，甚至 GIF 动画。 Android 在受限制的移动设备上运行，因此支持整个 SVG 规范并不是一个现实的目标。

然而，SVG 包含一个 [路径规范](https://www.w3.org/TR/SVG/paths.html)，它定义了如何描述和绘制形状。使用此 API，您可以表达大多数矢量形状。这基本上和Android 支持的 SVG 路径规范相同，只不过Android中增加了一些内容。

此外，通过定义自己的格式，VectorDrawable 可以与 Android 平台功能集成。例如，使用 Android 资源系统引用 @colors、@dimens 或 @strings，使用标准Animators 处理主题属性或 AnimatedVectorDrawable。

### `VectorDrawable` 的功能

如上所述，VectorDrawable 支持 [SVG路径规范](https://www.w3.org/TR/SVG/paths.html)，允许您指定要绘制的一个或多个形状。它是通过 XML 文件实现的，如下所示：

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector xmlns:android="http://schemas.android.com/apk/res/android"
  android:width="24dp"
  android:height="24dp"
  android:viewportWidth="24"
  android:viewportHeight="24">

    <path
      android:name="cross"
      android:pathData="M6.4,6.4 L17.6,17.6 M6.4,17.6 L17.6,6.4"
      android:strokeWidth="2"
      android:strokeLineCap="square"
      android:strokeColor="#999" />

</vector>
```

请注意，您需要指定资源的固有大小，即通过 ImageView 的 wrap_content 设置它的大小。第二个 `视口` 大小定义虚拟画布，或者定义所有后续绘制命令的空间坐标。固有和视口尺寸可以不同（但应该以相同的比例） - 如果你需要，可以在 1*1 画布中定义矢量。

`<vector>` 元素包含一个或多个 `<path>`  元素。它们可以被命名（以供稍后参考，例如动画），但至关重要的是必须指定描述形状的 `pathData` 元素。这个神秘的字符串可以被认为是控制虚拟画布上的笔的一系列命令：

![](https://cdn-images-1.medium.com/max/800/1*6BxPXqBgeJIpMoiYLoOygA.gif)

可视化路径操作

上面的命令移动虚拟笔，然后画一条线到另一个点，抬起并移动笔，然后绘制另一条线。 只用 4 个最常用的命令，我们几乎可以描述任何形状（更多的命令参见 [规范](https://www.w3.org/TR/SVG/paths.html#PathData)）：

*   `M` move to
*   `L` line to
*   `C` (cubic bezier) curve to
*   `Z` close (line to first point)

_(大写命令使用绝对路径 & 小写命令使用相对路径)_

你可能想知道是否需要关注这些细节 — 你可能直接从 SVG 文件中获取这些内容？虽然你不需要能够阅读路径并了解它将绘制什么，但大概了解`VectorDrawable` 正在做什么对于理解我们稍后将要学习的一些高级功能非常有用和必要。

路径本身不会绘制任何东西，它们需要被 stroke 或 fill。

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>

    <path
      android:pathData="..."
      android:fillColor="#ff00ff"
      android:strokeColor="#999"
      android:strokeWidth="2"
      android:strokeLineCap="square" />

</vector>
```

本系列的第 2 部分详细介绍了填充和描边路径的不同方法。

你还可以定义路径组。这允许你定义应用于组内所有路径的转换操作。

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>

    <path .../>

    <group
        android:name="foo"
        android:pivotX="12"
        android:pivotY="0"
        android:rotation="45"
        android:scaleX="1.2"
        android:translateY="-4">

        <path ... />

    </group>

</vector>
```

请注意，你无法旋转、缩放、转化单个路径。如果你想要这种行为，则需要将它们放在一个组中。 这些变换对静态图像毫无意义，因为静态图像可以直接将它们“烘焙”到它们的路径中 - 但它们对于动画非常有用。

您还可以定义 `clip-path`，即屏蔽 _同一组_ 中其他路径可以绘制的区域。它们的定义与  `path` 完全相同。

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>
  
  <clip-path
    android:name="mask"
    android:pathData="..." />

  <path .../>

</vector>
```

值得注意的一个限制是 clip-path 没有消除锯齿。
![](https://cdn-images-1.medium.com/max/800/1*mfAEoYPOzVBf2Ne2-lKE3w.png)

声明非抗锯齿 clip path

这个例子（我必须放大以显示效果）显示了两种绘制相机快门图标的方法。第一个绘制路径，第二个绘制一个实心方块，屏蔽快门形状。遮罩可以帮助创建有趣的效果（特别是在动画时），但它成本相对较高，所以你需要以不同的方式绘制形状来避免它。

路径可以修剪；这只是绘制整个路径的一个子集。你可以修剪填充的路径，但结果可能会令人惊讶！修剪描边路径更常见。

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector...>

  <path
    android:pathData="..."
    android:trimPathStart="0.1"
    android:trimPathEnd="0.9" />

</vector>
```

![](https://cdn-images-1.medium.com/max/800/1*7BaeX8n1mu2j7UTMRq-cLA.gif)

修剪路径

您可以从路径的开头或结尾进行修剪，也可以对任何修剪使用偏移。它们被定义为路径 [0,1] 的一部分。了解如何设置不同的修剪值会更改绘制线条的部分。另请注意，偏移可以使修剪值“环绕”。再一个，这个属性对静态图像没有多大意义，但对动画很方便。

根`矢量`元素支持 `alpha` 属性 [0,1]。Group 没有 alpha 属性，但各个路径支持 `fillAlpha` 和 `strokeAlpha`。

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...
  android:alpha="0.7">

  <path
    android:pathData="..."
    android:fillColor="#fff"
    android:fillAlpha="0.5" />

</vector>
```

### 宣布独立

所以希望这篇文章可以让您了解什么是矢量资源、使用矢量资料的好处以及使用时的权衡取舍。Android 的矢量格式已经得到广泛的支持。鉴于市场上的设备种类繁多，你应该将矢量资源作为默认选择，仅在特殊情况下使用栅格资源。阅读我们的下一篇文章，了解更多信息：

_即将到来: 绘制路径  
即将到来: 创建Android矢量资源  
即将到来: 在 Android 应用中使用 vector assets  
即将到来:分析 Android 中的 `VectorDrawable`_
感谢 [Ben Weiss](https://medium.com/@keyboardsurfer?source=post_page), [Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_page), 和 [Chris Banes](https://medium.com/@chrisbanes?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
