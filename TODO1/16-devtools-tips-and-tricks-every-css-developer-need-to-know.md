> * 原文地址：[16 DevTools tips and tricks every CSS developer needs to know](https://www.heartinternet.uk/blog/16-devtools-tips-and-tricks-every-css-developer-need-to-know/)
> * 原文作者：[Louis Lazaris](https://www.heartinternet.uk/blog/author/louis-lazaris/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/16-devtools-tips-and-tricks-every-css-developer-need-to-know.md](https://github.com/xitu/gold-miner/blob/master/TODO1/16-devtools-tips-and-tricks-every-css-developer-need-to-know.md)
> * 译者：[DEARPORK](https://github.com/Usey95)
> * 校对者：[TiaossuP](https://github.com/TiaossuP), [Baddyo](https://github.com/Baddyo)

# CSS 开发必知必会的 16 个调试工具技巧

大多数开发者基本都使用浏览器的开发者工具调试前端，但即使用了好几年 Chrome 的开发者工具，我仍然会遇到从未见过的技巧和功能。

在本文中，我写了许多在开发者工具中与 CSS 相关的功能和技巧，我认为它们将把你的 CSS 开发水平提升至一个新的台阶。其中一些技巧不仅仅针对 CSS，但是我还是把它们放在了一起。

一些是有关于工作流与调试的简单技巧，另一些则是最近几年推出的新功能。它们大多数基于 Chrome 的开发者工具，但也涵盖了一些 Firefox 的技巧。

## 审查通过 JavaScript 显示的元素的 CSS

在开发者工具的 Elements 面板查找大多数元素的 CSS 并不困难。大多数情况下你只需要右键该元素，点击检查，然后（如有必要）仔细点在 Elements 面板找到它。一旦元素被选中，它的 CSS 会出现在 Styles 面板，随时可以编辑。

有时一个元素会因为一些基于 JavaScript 的用户操作动态显示，例如 click 或者 mouseover。审查它们最直观的方法是暂时更改你的 JavaScript 或 CSS 使它们默认可见，以便于你在无需模仿用户操作的情况下处理它。

但如果你在寻找一种更快捷的方法仅使用开发者工具让元素可见，可以遵循以下步骤：

1. 打开开发者工具
2. 打开 Sources 面板
3. 执行用户操作让对象可见（例如鼠标悬停）
4. 在元素可见的时候按下 F8（与“暂停脚本执行”按钮相同）
5. 点击开发者工具左上角的“选取元素”按钮
6. 点击页面上的元素

我们可以通过 [Bootstrap 的 tooltips](https://getbootstrap.com/docs/3.3/javascript/#tooltips) 测试，只有鼠标悬浮在链接上触发 JavaScript 它才会显示，下面是演示：

![GIF 动图：使用 Bootstrap 的 tooltips 时如何选中元素](https://www.heartinternet.uk/blog/wp-content/uploads/bootstrap-tool-tips-example.gif)

如你所见在 GIF 的开头，我一开始无法选中元素来审查它，因为鼠标一旦移开它就消失了。但如果我在它可见的时候停止脚本运行，它将保持可见状态以便我可以正确地检查它。当然，如果元素只是简单的 CSS `:hover` 效果，那么我可以用 Styles 面板的 “Toggle Element State”（:hov 按钮）切换状态来让它显示。但由 JavaScript 切换样式的情况下，停止脚本也许是获取它们 CSS 样式的最佳方法。

## 通过 CSS 选择器寻找元素

你也许知道你可以用内置功能（CTRL + F 或者 CMD + F）在 Elements 面板搜索一个元素。但注意看 “find” 栏，它会给你以下提示：

![在 Elements 面板使用 CSS 选择器寻找元素的截图](https://www.heartinternet.uk/blog/wp-content/uploads/search-for-a-css-element.png)

正如我在截图中指出的那样，你可以通过字符串、选择器以及 XPath 寻找元素。之前我一直都在使用字符串，直到最近我才意识到我可以使用选择器。

你不一定要使用你 CSS 中用过的选择器，它可以是任意合法的 CSS 选择器。查找功能将告诉你选择器是否与任何元素匹配。这对查找元素很有用，还有助于测试选择器是否有效。

下面是一个使用 `body > div` 选择器来搜索以及遍历 `body` 所有直接子 `div` 元素的 demo：

![演示如何通过指定 CSS 选择器搜索元素的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/body-div-seach-example.gif)

如上所述，这些搜索可以通过任意合法选择器完成，类似于 JavsScript 的 `querySelector()` 和 `querySelectorAll()` 方法。

## 直接编辑盒模型

盒模型是你开始使用 CSS 首先学习的东西之一。由于这是 CSS 布局的一个重要部分，开发者工具允许你直接编辑盒模型。

如果你审查了页面上的一个元素，请在右侧面板单击 Styles 面板旁的 Computed 面板。你将看到该元素的可视化盒模型图示，上面有各部分的数值：

![特定元素盒模型的可视化图示](https://www.heartinternet.uk/blog/wp-content/uploads/model-box-example.png)

也许你不知道，你可以通过双击任意编辑它们的值：

![演示如何编辑盒模型值的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/model-box-editing-example.gif)

所做的任何更改都会以与在 Styles 面板中编辑 CSS 时相同的方式反映在页面上。

## 在 Styles 面板递增或递减属性值

你可能已经意识到可以在 Styles 面板中编辑 CSS。只需单击属性或值，然后键入更改即可。

但也许你没有意识到数值可以以不同的方式递增或递减。

- 上方向键 / 下方向键可以使属性值以 1 递增 / 递减
- ALT + 上方向键 / 下方向键可以使属性值以 0.1 递增 / 递减
- SHIFT + 上方向键 / 下方向键可以使属性值以 10 递增 / 递减
- CTRL + 上方向键 / 下方向键可以使属性值以 100 递增 / 递减

![演示如何用方向键递增或递减属性值的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/incrementing-values-in-the-styles-panel-example.gif)

你也可以使用 Page Up 或 Page Down 按钮代替方向键。

## Sources 面板的文本编辑器功能

比起别的地方，你也许更熟悉在 Styles 面板进行编辑，然而 Sources 面板是开发者工具中被高度低估一个功能，它模仿了常规代码编辑器和 IDE 的工作方式。

以下是一些你可以在 Sources 面板（打开开发者工具并点击 “Sources” 按钮）可以做的有用的事情。

### 使用 CTRL 键进行多项选择

如果需要在单个文件中选择多个区域，可以通过按住 CTRL 键并选择所需内容来完成此操作，即使它不是连续文本也是如此。

![演示如何通过按住 CRTL 键进行多项选择的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/multiple-selections-with-ctrl-key.gif)

在上面的 demo 中，我在 Sources 面板中选择了 main.css 文件的三个任意部分，然后将它们粘贴回文档中。此外，你还可以通过多个光标在多个地方进行同时输入，使用 CTRL 键单击多个位置即可。

### 使用 ALT 键选择列

有的时候，你可能希望选择一列文本，但通常情况下无法办到。某些文本编辑器允许你使用 ALT 键来完成此操作，在 Sources 面板中也是如此。

![演示如何使用 ALT 键选择整列的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/column-selection-with-alt-key.gif)

## 使用 CTRL + SHIFT + O 组合键通过 CSS 选择器搜索元素

在 Sources 面板打开文件后，按下 CTRL + SHIFT + O 组合键，可以打开一个输入框让你跳转到任意地方，这是 Sublime 一个著名的功能。

按下 CTRL + SHIFT + O 之后，你可以输入你在本文件中想查找元素的 CSS 选择器，开发者工具会给你提供匹配选项，点击可跳转到文件的指定位置。

![演示如何在文件中查找特定 CSS 选择器的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/search-with-css-selector-shortcut.gif)

## Chrome 和 Firefox 的响应式设计功能

你也许已经看过一些让你只需点击几下就得以测试你的响应式布局的网站，其实，你可以用 Chrome 的设备模式做同样的事情。

打开你的开发者工具，点击左上角的 “Toggle device toolbar” 按钮（快捷键 CTRL + SHIFT + M）：

![演示如何在 Chrome 的设备模式测试响应式网站的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/testing-responsive-design.gif)

如你所见，设备工具栏有多个选项可根据设备大小和设备类型更改视图，你甚至可以通过手动调整宽度和高度数值或拖动视口区域中的手柄来手动进行更改。

Firefox 附加的 “@media rules” 面板具有类似的功能，它允许你从站点的样式表中单击断点。你可以在下面的 demo 中看到我在我的一个网站上使用它。

![演示如何在 Firefox 测试响应式网站的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/firefox-responsive-design-test.gif)

## 开发者工具的颜色功能

在 CSS 中处理颜色值是常态。开发者工具让可以你更简单地编辑、测试颜色值。以下是你可以做的事情：

### 对比度

首先，开发者工具有查看可访问性功能，当你在 Styles 面板看到 Color 属性值时，你可以点击颜色值旁边的方块打开颜色采集器。在颜色采集器里面，你将看到对比度选项指示你所选择的文本颜色搭配背景是否有可访问的对比度。

![演示特定颜色的可访问对比度的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/css-contrast-ratio.gif)

正如你在上面 demo 所看到的，颜色采集器在色谱中显示出弯曲的白线。这个线表示最小可接受对比度开始和结束的位置。当我将颜色值移到白线上方时，对比度旁的绿勾将会消失，表明对比度较差。

### 调色板

除了查看可访问性的功能之外，你还可以访问不同的调色板，包括 Material Design 调色板以及与当前查看页面关联的调色板。

![演示特定颜色调色盘的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/css-colour-palettes.gif)

### 切换颜色值语法

最后，在开发者工具中一个鲜为人知的小知识是在查看颜色值时你可以切换颜色值的语法。默认情况下，Styles 面板会显示 CSS 里写的颜色的语法。但是开发者工具允许你按住 shift，点击颜色值左边的小方块，在 hex、RGBA 以及 HSLA 之间切换颜色值的语法：

![演示如何切换颜色值语法的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/toggling-colour-value-syntax.gif)

## 编辑 CSS 阴影

text-shadow 和 box-shadow 的 CSS 手写起来很乏味，语法很容易忘记，且两种阴影的语法略有不同。

方便的是，Chrome 的开发者工具允许你使用可视化编辑器添加 text-shadow 或 box-shadow。

![演示如何编辑阴影效果的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/editing-css-shadows.gif)

正如 demo 中显示的，你可以用 Styles 面板中任意样式右下角的选项栏给任意元素添加 text-shadow 或 box-shadow。阴影添加后，你可以用可视化编辑器编辑不同的属性值。已存在的阴影可以通过点击属性值左边的小方块重新呼出可视化编辑器。

## Firefox 的 Grid 布局检查器

现在大多数常用的浏览器都支持 Grid 布局，越来越多的开发者将它们用作默认的布局方法。Firefox 的开发者工具如今把 Grid 选项作为特色功能放到了 Layout 选项卡中。

![演示在 Firefox 中如何使用 Grid 布局检查器的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/grid-layout-inspector-in-firefox.gif)

这个功能允许你开启一个全覆盖的网格帮助可视化 Grid 布局的不同部分。你还可以显示行号、区域名称，甚至可以选择无限延伸网格线 —— 如果这对你有用的话。在示例 demo 中，我在使用 Jen Simmons 的示例网站，它是响应式的，因此当布局因为不同视口改变时，你可以看到可视化网格的好处。

## Firefox 的 CSS filter 编辑器

filter 是现在几乎在移动端和 PC 端都支持的另一个新功能。Firefox 再次提供了一个好用的小工具帮助你编辑 filter 的值。

一旦你代码里有 filter（提示：如果你不知道实际语法，你可以先写上 `filter: none`），你将注意到 filter 值左边有一个黑白相间的堆叠方块，点击它可以打开 filter 编辑器。

![演示如何使用 Firefox CSS filter 编辑器的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/css-filter-editor-in-firefox.gif)

你可以给单个值加不同的 filter，删除单个 filter 值，或者拖动 filter 重新排列它们的层次。

![演示如何拖动单个 filter 的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/css-multiple-filters-in-firefox.gif)

## 在 Chrome 的 Styles 面板编辑 CSS 动画

在 Chrome 的 Styles 面板编辑静态元素非常简单，那么编辑使用 `animation` 属性以及 `@keyframes` 创建的动画呢？

开发者工具有两种编辑动画的方法。首先，当你审查一个元素或者在 Elements 面板选择一个元素，该元素的所有样式都会出现在 Styles 面板 —— 包括已定义的 `@keyframes`。在下面的 demo 中，我选择了一个带动画的元素，然后调整了一些关键帧设置。

![演示如何在 Chrome 的 Styles 面板编辑 CSS 动画的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/editing-animation-keyframe-settings-in-chrome.gif)

但这并不是全部，Chrome 的开发者工具提供了一个 Animation 面板让你可以使用可视化时间线编辑一个动画及它的各个不同部分。你可以通过点击开发者工具右上方的 “Customize and control DevTools” 按钮（三个竖点按钮），选择更多工具，开启 Animations 面板。

![演示 Chrome 开发者工具的 Animations 面板的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/editting-css-animations-in-chrome-style-panel.gif)

如上所示，你可以编辑每个动画元素的时间轴，然后在完成编辑后，你可以浏览动画以查看页面上的更改。这是设计和调试复杂 CSS 动画的一个很酷的功能！

## 在开发者工具中查看未使用的 CSS

最近有大量工具可以帮助你追踪未在特定页面上使用的 CSS。这样你就可以选择完全删除它们或仅在必要时加载它们。这将具有明显的性能优势。

Chrome 允许你通过开发者工具的 “Coverage” 面板查看未使用的 CSS。这个面板可以通过上文提到的点击开发者面板右上角的 “Customize and control DevTools” 选项（三个竖点按钮），选择“更多工具”，找到 “Coverage” 开启。

![演示如何自定义你的 Chrome 开发者工具的 GIF 动图](https://www.heartinternet.uk/blog/wp-content/uploads/view-unused-css-in-dev-tools.gif)

如 demo 所示，一旦你打开了 Coverage 面板，你可以在 Sources 面板打开一个源文件。当文件打开时，你将注意到 CSS 文件中每条样式右侧都有绿色或红色的线，指示样式是否在当前页面被应用。

## 总结

你的浏览器开发工具是 CSS 编辑和调试的宝库。当你将以上建议与 Chrome 的功能例如 —— Workspaces（允许你把在开发者工具所做的变更保存到本地文件）—— 结合，整个调试过程会变得更加完整。

我希望这些技巧与建议将提升你在未来的项目中编辑与调试 CSS 的能力。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
