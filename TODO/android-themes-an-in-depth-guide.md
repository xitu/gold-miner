>* 原文链接 : [Android Themes — An in-depth guide](https://medium.com/@Sserra90/android-themes-an-in-depth-guide-f71f9db6e5bf)
* 原文作者 : [Sérgio Serra](https://medium.com/@Sserra90)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [aidistan](https://github.com/aidistan)
* 校对者: [shixinzhang](https://github.com/shixinzhang), [a-voyager](https://github.com/a-voyager)

# 深度讲解 Android 主题层级

Theme.AppCompat, Theme.Base.AppCompat, Base.V7.Theme.AppCompat, Base.v11.Theme.AppCompat, Base.v21.Theme.AppCompat, ThemeOverlay, Platform.AppCompat, DeviceDefault, Material, Holo, Classic 等等……

当使用安卓主题和支持库时，你可能会遇见以上这些名字，并且好奇：

- `Base.V{something}`, `Theme.Base.AppCompat`, `Platform.AppCompat` 是什么？
- 这些主题是如何组织起来的？
- 我应当用哪一个？

在本文中，我将回答上述问题，并尝试阐明这一切是如何工作的。

### AppCompat v7

鉴于不同的安卓平台定义了不同的主题、样式和属性，最初安卓主题的层级非常繁杂，而且很不直观。直到 v7 支持库带来了全新的主题架构，使得所有安卓平台自 API v7 起能够获得一致的材质外观 (Matertial apperance)。`Base.V...` 和 `Platform.AppCompat` 正是在这个时候被加入了进来。

> 安卓开发者们在 GitHub 上撰写了一篇 [README](https://github.com/android/platform_frameworks_support/blob/master/v7/appcompat/THEMES.txt) 解释主题层级，我推荐你看一看。

在 `AppCompat` 中，主题被划分为四个层次，每个层次继承自更低一层：

**Level1 → Level2 → Level3 → Level4**

除此之外，每个版本的安卓 API 都有一个对应的 `values-v{api}` 文件夹存放各自需要定义或覆写的样式和属性：

**values, values-v11, values-v14, values-v21, values-v22, values-v23**

#### Level 4 （最底层）

最底层包含了 `Platform.AppCompat` 主题。该主题总是继承自当前版本中的默认主题，例如：

**values**

Platform.AppCompat -> android:Theme

**values-v11**

Platform.AppCompat -> android:Theme.Holo

**values-v21**

Platform.AppCompat -> android:Theme.Material

#### Level 3

大部分工作在这一层被完成，`Base.V7.Theme.AppCompat`, `Base.V11.Theme.AppCompat`, `Base.V21.Theme.AppCompat` 等也是在这一层被定义。这些主题都继承自 `Platform.AppCompat`。

**values**

Base.V7.Theme.AppCompat* → Platform.AppCompat → android:Theme

**values-v11**

Base.V11.Theme.AppCompat → Platform.AppCompat → android:Theme.Holo

**values-v21**

Base.V21.ThemeAppCompat → Base.V7.ThemeAppCompat → Platform.AppCompat → android:Theme.Material

> \*: 还包括 Base.V7.Theme.AppCompat.Light, Base.V7.Theme.AppCompat.Dialog 等变体。

绝大多数属性和几乎所有工作在 `Base.V{api}.Theme.AppCompat` 中被定义和完成。ActionBar, DropwDown, ActionMode, Panel, List, Spinner, Toolbar 等控件中的所有属性都在这里被定义。你可以在 [这个链接](https://github.com/android/platform_frameworks_support/blob/master/v7/appcompat/res/values/themes_base.xml) 中查看更多详情。

#### Level 2

根据安卓的官方解释，我们在这一层拿到的主题只是第三层主题的别名：

> There are the themes which are pointers to the correct third level theme.They can also be used to set attributes for that specific platform (and platforms up until the next declaration).
>
> 这些主题指向第三层中相应的主题。它们也可以用来配置那些特定平台的属性。

**values**

Base.Theme.AppCompat* → Base.V7.Theme.AppCompat

**values-v21**

Base.Theme.AppCompat → Base.V21.Theme.AppCompat

> \*: 还包括 Base.Theme.AppCompat.Light, Base.Theme.AppCompat.Dialog 等变体。

#### Level 1 （最顶层）

`Theme.AppCompat`, `Theme.AppCompat.Light`, `Theme.AppCompat.NoActionBar` 等主题在这里被定义。**开发者应该使用这些主题，而非那些更底层的。**

**values**

Theme.AppCompat → Base.Theme.AppCompat

这些主题只在 `values` 文件夹中被定义，并根据安卓应用运行的 API 环境，继承自下层中定义的相应主题。例如：

*   **Running in v7 (Android 2.2)**

Theme.AppCompat → Base.Theme.AppCompat → Base.V7.Theme.AppCompat → Platform.AppCompat → android:Theme

*   **Running in v11 (Android 3.0)**

Theme.AppCompat → Base.Theme.AppCompat → Base.V7.Theme.AppCompat → Platform.AppCompat → Platform.V11.AppCompat → android:Theme.Holo

*   **Running in v21 (Android 5.0)**

Theme.AppCompat → Base.Theme.AppCompat → Base.V21.Theme.AppCompat → Base.V7.Theme.AppCompat → Platform.AppCompat → android:Theme.Material

以上便是我们如何在所有安卓 API 下获得一致的材质外观的答案。正如你所见到的，当我们顺着主题的层级仔细研究时会发现，这一过程有点小复杂。

#### 主题图示（简化版）

![](http://ww1.sinaimg.cn/large/a490147fgw1f52tnel5ggj20ka0ictaz.jpg)

### ThemeOverlays

在所有可用的主题中，我们可以发现一个名字带有 `ThemeOverlay` 的系列：

*   ThemeOverlay
*   ThemeOverlay.Light
*   ThemeOverlay.ActionBar.Light
*   ThemeOverlay.ActionBar.Dark

这些主题又是做什么的呢？答案是 **仅用于为特定的用途定义必要的属性。** 例如 `ThemeOverlay` 主题只定义了 `textColor`，`textAppearance`，窗口的颜色属性和一些类似 _colorControlButton_ 的属性；通常用作于 Toolbar 主题的 `ThemeOverlay.ActionBar.Light`，仅将 _colorControlButton_ 的值定义为 _?attr:textColorSecondary_。

### 结论

我在学习这些 `AppCompat` 主题的时候，顺便写了个 [小应用](http://themekitapp.com) 帮助大家浏览安卓主题和样式。希望能够对大家有所帮助。

**注意：Google Play 商店的链接有时会失效几个小时。**

我希望这篇文章能够帮你了解这些 `AppCompat` 主题是如何被组织到一起。还有一些我原本希望涉及的内容，但那样文章就太长了，或许会放在第二部分中。
