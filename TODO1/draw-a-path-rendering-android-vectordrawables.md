> * 原文地址：[Draw a Path: Rendering Android VectorDrawables](https://medium.com/androiddevelopers/draw-a-path-rendering-android-vectordrawables-89a33b5e5ebf)
> * 原文作者：[Nick Butcher](https://medium.com/@crafty)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/draw-a-path-rendering-android-vectordrawables.md](https://github.com/xitu/gold-miner/blob/master/TODO1/draw-a-path-rendering-android-vectordrawables.md)
> * 译者：[xiaxiayang](https://github.com/xiaxiayang)
> * 校对者：[Mirosalva](https://github.com/Mirosalva), [siegeout](https://github.com/siegeout)

# 绘制路径：Android 中矢量图渲染

![](https://cdn-images-1.medium.com/max/2600/1*t4yigvVn3kGRHnTu0yAlqQ.png)

插图来自 [Virginia Poltrack](https://twitter.com/VPoltrack)

在上一篇文章中，我们研究了 Android 的 VectorDrawable 格式，了解了它的优点和功能。

- [了解 Android 的矢量图片格式：VectorDrawable](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-androids-vector-image-format-vectordrawable.md)

我们讨论了如何定义组成 assets 中形状的路径。`VectorDrawable` 支持许多实际绘制这些形状的方法，我们可以使用这些方法创建丰富的、灵活的、可配置主题的和可交互的资源。在这篇文章中，我将深入探讨这些技巧：颜色资源、主题颜色、颜色状态列表和渐变的使用。

### 简单的颜色

绘制路径最简单的方法是指定一种硬编码的 fill/stroke 颜色。

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

你可以定义这两个属性中的一个或者两个，但每个路径只能应用一组 fill/stroke (这与某些图形包不同)。首先绘制填充内容，然后绘制描边内容。描边总是居中的（不像一些图形应用程序定义了内边缘和外边缘），它需要被明确的指定 `strokeWidth` 属性，而 `strokeLineCap`、`strokeLineJoin` 属性是可以选择性定义的，这些属性控制描边线的端点/连接处的形状（也可以定义 `strokeMiterLimit` 来控制 `miter` 线的交点的形状）。不支持虚线描边。

填充和描边都提供单独的 alpha 属性：`fillAlpha` 和 `strokeAlpha` [0-1] 都默认为 1，即完全不透明。如果为一个设置了 alpha 值的组件指定 `fillColor` 或 `strokeColor`，结果是这两个值的结合。例如，如果指定 50% 透明的红色 `fillColor`（`#80ff0000`）和 0.5 的 `fillAlpha`，那么结果将是 25% 透明的红色。单独的 alpha 属性使路径的不透明度更容易动画化。

### 颜色资源

矢量图形中填充和描边颜色的设置都支持 `@color` 资源的语法：

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>

  <path
    android:pathData="..."
    android:fillColor="@color/teal"
    android:strokeColor="@color/purple"
    android:strokeWidth="2" />

</vector>
```

这允许你可以提取颜色以便于维护，并帮助你约束应用程序的色调一致性。

它还允许你使用 Android 的 [资源限定符](https://developer.android.com/guide/topics/resources/providing-resources#AlternativeResources) 在不同配置中提供不同的颜色值。例如，你可以在夜间模式（`res/colors-night/colors.xml`）或如果 [设备支持宽色域](https://medium.com/google-design/android-color-management-what-developers-and-designers-need-to-know-4fdd8054557e)（`res/colors-widecg/colors.xml`）下提供替代的颜色值。

### 主题色

所有版本的矢量（从 API14 到 AndroidX）都支持使用主题属性（例如 `?attr/colorPrimary`）来指定颜色。这些颜色是由主题提供的，对于创建灵活的资源非常有用，这种资源可以在应用的不同位置使用。

使用主题颜色主要有两种方式。

#### 为 fills/strokes 设置主题色

你可以直接引用主题颜色来设置填充或描边路径：

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>

  <path
    android:pathData="..."
    android:fillColor="?attr/colorPrimary" />

</vector>
```

如果你希望资源中的元素依据主题有所不同，那么这是非常有用的。例如，一个体育类型的应用程序可以设置一个主题色的占位符图像来显示球队的颜色；使用单一绘图：

![](https://cdn-images-1.medium.com/max/1600/1*bC0qT04NmBsM5wQdiDYPgw.png)

用主题颜色填充路径

#### 着色

`<vector>` 根元素提供了 `tint` 和 `tintMode` 属性值：

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...
  android:tint="?attr/colorControlNormal">

    <path ... />

</vector>
```

虽然你可以使用它来采取静态着色，但它在与主题属性组合时更有用。这允许您根据引入的主题更改整个资源文件的颜色。例如，你可以使用 `?attr/colorControlNormal`，它定义了图标的标准颜色，并在明暗主题之间变化。这样你就可以在不同主题的屏幕上使用一个图标：

![](https://cdn-images-1.medium.com/max/1600/1*h1z2s8mJ6giKx5_Ixx0DQQ.png)

在明/暗屏幕上对图标进行着色，使其具有适当的颜色

使用着色的一个好处是，你不需要依赖于你的资源文件(通常来自你的设计师)是正确的颜色。对图标使用 `?attr/colorControlNormal` 属性既能主题化，又能保证资源文件的颜色完全相同、正确。

`tintMode` 属性允许你更改用于着色绘制的混合模式，它支持：`add`、`multiply`、`screen`、`src_atop`、`src_over`或`src_in`；对应于类似的 [PorterDuff.Mode](https://developer.android.com/reference/android/graphics/PorterDuff.Mode)。通常你使用的默认属性是 `src_in`，它将图像作为 alpha 蒙版应用于整个图标，忽略单个路径中的任何颜色信息（尽管 alpha 通道是维护的）。因此，如果你打算给图标着色，那么最好使用完全不透明的填充/描边颜色（惯例是使用 `#fff`）。

你可能想知道什么时候为资源着色？什么时候在单独的路径上使用主题颜色？因为这两种颜色都可以获得类似的结果。如果你只想在某些路径上使用主题颜色，那么必须直接使用它们。另一个需要考虑的问题是，你的资源是否具有重叠渲染。如果是这样的话，那么用半透明的主题颜色填充可能不会产生你想要的效果，但应用着色模式可能达到这种效果。

![](https://cdn-images-1.medium.com/max/1600/1*3hsEvZy71AHHAPAz-f9AHw.png)

具有重叠路径和半透明主题颜色的资源:比较着色和填充模式

请注意，你可以通过设置 `android:theme` 属性，在`Activity`/`View` 级别改变可绘制对象的主题，或者在代码中使用 [ContextThemeWrapper](https://developer.android.com/reference/android/view/ContextThemeWrapper.html) 设置一个特定的主题来 [填充](https://developer.android.com/reference/android/support/v7/content/res/AppCompatResources.html#getDrawable%28android.content.Context,%20int%29) 这个矢量图形。

```
/* Copyright 2018 Google LLC.
   SPDX-License-Identifier: Apache-2.0 */
val themedContext = ContextThemeWrapper(context, R.style.baz)
val drawable = AppCompatResources.getDrawable(themedContext, R.drawable.vector)
```

覆盖主题 `baz`

### 颜色状态列表

对于 填充/描边，`VectorDrawable` 支持 [ColorStateLists](https://developer.android.com/reference/android/content/res/ColorStateList.html) 的引用。通过这种方式，你可以创建一个单独的绘图，其中路径根据视图/绘图的状态（如按下、选择、激活等）来改变颜色。

![](https://cdn-images-1.medium.com/max/1600/1*6ZTTJcAjPO6cUU5yk3tahQ.gif)

矢量图形对按下和选择的状态作出响应的例子

这是在 API24 中引入的，但最近添加到 AndroidX 中，从 1.0.0 版本也支持 API14。这也使用了 [AndroidX 颜色状态列表填充](https://developer.android.com/reference/android/support/v7/content/res/AppCompatResources.html#getColorStateList%28android.content.Context,%20int%29)，这意味着你也可以在 `ColorStateList` 中使用主题属性和 alpha（它们本身只在 API23 中被添加到平台中）。

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<selector ...>
  <item android:state_pressed="true"
    android:color="?attr/colorPrimary"
    app:alpha="0.8"/>
  <item android:color="#ec407a"/>
</selector>
```

虽然在 `StateListDrawable` 中使用多个可绘制对象也可以获得类似的结果，但是如果状态之间的呈现差异很小，则可以减少重复，并且更容易维护。

我也非常喜欢为自定义视图创建自己的状态，这些视图可以与此支持结合使用，以控制资源中的元素，例如在某个特定状态触发之前将路径设为透明。

### 渐变

![](https://cdn-images-1.medium.com/max/1600/1*v9DUfuae-a0oX12Dw88pmw.png)

支持 3 种类型的渐变

`VectorDrawable` 支持线性、径向和扫描（也称为角）渐变的填充和描边。在 AndroidX 包往前可支持到 API4 版本。渐变是在它们自己的文件中以 `res/colors/` 的形式声明的，但是我们可以使用 [内嵌资源技术](https://developer.android.com/guide/topics/resources/complex-xml-resources) 来代替在矢量图形中声明的渐变，这样更方便：

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<vector ...>
  <path android:pathData="...">
    <aapt:attr name="android:fillColor">
      <gradient .../>
    </aapt:attr>
  </path>
</vector>
```

在构建时，渐变被提取到它自己的资源中，并在父元素中插入对它的引用。如果要多次使用相同的渐变，最好声明一次并引用它，因为内联版本每次都会创建一个新资源。

当指定渐变时，任何坐标都位于根矢量元素的视觉空间中。让我们看看每一种渐变，以及如何使用它们。

#### 线性

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<gradient
  android:type="linear"
  android:startX="12"
  android:startY="0"
  android:endX="12"
  android:endY="24"
  android:startColor="#1b82bd"
  android:endColor="#a242b4"/>
```

线性渐变必须指定 开始/结束的 X/Y 坐标和 `type="linear"`。

#### 径向

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<gradient
  android:type="radial"
  android:centerX="0"
  android:centerY="12"
  android:gradientRadius="12"
  android:startColor="#1b82bd"
  android:endColor="#a242b4"/>
```

径向渐变必须指定一个中心点 X/Y 的坐标和一个半径（同样在视觉坐标中），以及 `type="radial"`。

#### 扫描

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<gradient
  android:type="sweep"
  android:centerX="0"
  android:centerY="12"
  android:startColor="#1b82bd"
  android:endColor="#a242b4"/>
```

扫描渐变必须指定一个中心点坐标 X/ Y和 `type="sweep"`。

#### 起止颜色

渐变的使用很方便，你可以直接在渐变中指定一个 `startColor`、`centerColor` 和 `endColor`。如果你需要更细粒度的控制它或者设置更多起止颜色，你也可以通过添加指定了 `color` 和 [0–1] `offset`（可以把这个看成控制渐变程度的百分比）的子 `item` 来实现。

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<gradient ...>
  <item
    android:offset="0.0"
    android:color="#1b82bd"/>
  <item
    android:offset="0.72"
    android:color="#6f5fb8"/>
  <item
    android:offset="1.0"
    android:color="#a242b4"/>
</gradient>
```

#### 平铺模式

线性和径向(不是扫描)渐变提供了平铺的概念——也就是说，如果渐变没有覆盖它填充/描边的整个路径，那么应该怎么做。默认值是 `clamp`, 它只是延续开始/结束的颜色。或者你可以指定 `repeat` 或者 `mirror` 平铺模式，这些模式……正如它们的名称所暗示的那样!在以下示例中,定义了一个径向渐变：中心蓝色 → 紫色圆形，但充满更大的正方形路径。

![](https://cdn-images-1.medium.com/max/1600/1*8ngJx7igxFyEc48mjrN4xA.png)

渐变平铺模式

#### 模式

我们可以结合使用起止颜色和平铺模式来实现矢量图形中的基本模式支持。例如，如果指定了一致的起止颜色，就可以实现突然的颜色更改。将其与重复的平铺模式结合起来，就可以创建条纹模式。[例如](https://gist.github.com/nickbutcher/1e6c2309ee075ac62d2f8a6c285f0ce8) 这是一个由单个模式的填充形状组成的加载指示器。通过在持有此模式的 group 上动画化 `translateX` 属性，我们可以实现以下效果:

![](https://cdn-images-1.medium.com/max/1600/1*uXCjERVWWepz-1AyHIy2Ow.gif)

注意，这种技术与完整的 [SVG 模式](https://www.w3.org/TR/SVG/pservers.html#Patterns) 支持相去甚远，但它可能很有用。

#### 插图

![](https://cdn-images-1.medium.com/max/1600/1*Rk-FXON4_Y5RqsD_koB-ow.png)

另一幅由非常有才华的 [Virginia Poltrack](https://twitter.com/VPoltrack) 绘制的可爱插图

渐变在像插图这样的大型矢量图形中非常常见。矢量图非常适合插图，但是在放大时要注意内存的权衡。我们将在本系列的后面讨论这个问题。

#### 阴影

`VectorDrawable`s 不支持阴影效果；然而，简单的阴影可以用渐变来模拟实现。例如，这个 app 图标使用径向渐变来近似白色圆圈的投影，三角形下方的阴影使用线性渐变:

![](https://cdn-images-1.medium.com/max/1600/1*LtNVL0GpyFlFei434XS-0Q.png)

使用渐变近似阴影

同样，这离完全的支持阴影还有很长的路要走，因为只能绘制线性/径向/扫描渐变，而不能沿着任意路径绘制。你可以近似一些形状；特别是像如下 [示例](https://gist.github.com/nickbutcher/b9c726e956d25b354ee1d19dcb105a88) 对渐变元素应用变换，它使用 `scaleY` 属性将一个径向渐变的圆转换成一个椭圆形来创建阴影：

![](https://cdn-images-1.medium.com/max/1600/1*CPo9LovW1xgD5jCkWRu0Ow.gif)

转换包含渐变的路径

### 颜色的数量

希望这篇文章已经表明 `VectorDrawable`支持许多高级特性，你可以使用这些特性在应用程序中渲染更复杂的资源，甚至可以用一个文件替换多个资源，帮助你构建更精简的应用程序。

我建议所有的应用程序都应该使用主题色彩的图标。`ColorStateList` 和渐变支持就合适，但是如果你需要它，最好知道矢量图形支持的这些用例。

与矢量图形的兼容性非常好，因此这些特性现在可以在大多数应用程序中使用（下一期将详细介绍）。

加入我们下一部分关于矢量图形的探索：

- [**在 Android 应用中使用矢量资源**：在之前的文章中我们已经了解了 Android 的VectorDrawable 图像格式和它的功能](https://medium.com/androiddevelopers/using-vector-assets-in-android-apps-4318fd662eb9 "https://medium.com/androiddevelopers/using-vector-assets-in-android-apps-4318fd662eb9")

即将展示：为 Android 创建矢量资源
即将展示：分析 Android 的 `VectorDrawable`

感谢 [Ben Weiss](https://medium.com/@keyboardsurfer?source=post_page)、[Don Turner](https://medium.com/@donturner?source=post_page) 和 [Doris Liu](https://medium.com/@doris4lt?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
