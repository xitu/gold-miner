> * 原文地址：[A Guide To CSS Support In Browsers](https://www.smashingmagazine.com/2019/02/css-browser-support/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-css-support-in-browsers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-css-support-in-browsers.md)
> * 译者：[huimingwu](https://github.com/huimingwu)
> * 校对者：[xionglong58](https://github.com/xionglong58), [QiaoN](https://github.com/QiaoN)

# 浏览器中 CSS 支持指南

摘要：当你想要使用某个特性，发现它不受支持或在不同的浏览器中的行为不同时，这可能会令人沮丧。在本文中，Rachel Andrew 详细介绍了不同类型的浏览器支持问题，并展示了 CSS 是如何发展的，以便更容易地处理这些问题。

我们将永远不会生活在一个每个浏览我们网站的人都拥有相同浏览器和浏览器版本的世界中，就像我们永远不会生活在一个每个人都拥有相同大小的屏幕和分辨率的世界中一样。这意味着应对老版本的浏览器，或者不支持我们想要使用的东西的浏览器，是 Web 开发人员工作的一部分。即便如此，现在的情况比过去好多了。在本文中，我将介绍一下我们可能遇到的不同类型的浏览器支持问题。我将向你们展示一些处理这些问题的方法，并介绍将来可能就会有帮助的东西。

## 为什么我们有这些差异？

即使有一个世界里的大多数浏览器都基于 Chromium，它们运行的 Chromium 版本也不一定和 Google 的 Chrome 浏览器相同。这意味着一个基于 Chromium 的浏览器，比如 Vivaldi，可能比 Google Chrome 落后几个版本。

当然，用户并不总是随时更新他们的浏览器，尽管近年来随着大多数浏览器默认自动升级，这种情况有所改善。

还有一种方式是，新特性首先进入浏览器。这种情况下，CSS 的新特性并不是由 CSS 工作组设计的，而是一个完整的规范交由浏览器厂商实现。通常，只有在实验实现发生时，才能计算出规范的所有细节。 因此，**特性开发是一个迭代过程**，并且要求浏览器在开发中实现这些规范。虽然现在的实现大多是在浏览器的 flag 后面，或者只在 Nightly 或预览版中可用，但是一旦浏览器具有完整特性，即使没有其他浏览器支持，它也可能为所有人开启。

所有的这一切都意味我们永远不会生活在这样一个世界：所有桌面和手机上的特性都能同时可用。尽管我们可能很喜欢这样的世界。如果你是一名专业的 web 开发人员，那么你的工作就要面对这个现实。

## Bug vs. 缺乏支持

关于浏览器支持，我们面临如下三个问题：

1. [特性不支持](#no-support-of-feature)：第一个问题，也是最容易处理的问题，就是浏览器根本不支持这个特性。

2. [涉及浏览器 “Bug”](#dealing-with-browser-bugs)：第二种情况是，浏览器声称支持该特性，但其支持方式与其他浏览器支持该特性的方式不同。由于在不同浏览器中表现出不同的行为，我们通常称这类问题为“浏览器 bug”。

3. [CSS 属性的部分支持](#partial-support-css-properties)：浏览器支持某一特性的一种情况，但仅在一种环境中。这个问题也越来越普遍。

当你看到不同浏览器之间的差异时，理解你正在处理的问题是很有用的，因此让我们依次看看这些问题。

## 1. 特性不支持

如果拟使用浏览器不理解的 CSS 属性或值，浏览器将忽略它。无论你是使用不受支持的特性，还是虚构一个特性并尝试使用它，浏览器都将忽略它。如果浏览器不理解这一行 CSS，它就跳过这一行，继续做它能理解的下一件事。

CSS 的这种设计原则意味着你可以愉快地使用新特性，因为你知道如果浏览器不支持这些特性，也不会有什么坏事发生。对于一些纯粹用作增强的 CSS，使用该特性，确保当该特性不可用时体验仍然良好，这就是你需要做的全部工作，仅此而已。这种方法是渐进式增强背后的基本思想，使用浏览器的这个特性可以在不理解新特性的浏览器中安全使用新特性。

**如果你想检查浏览器是否支持你正在使用的特性，那么你可以查看 [Can I Use](https://caniuse.com/)。另一个寻找详细支持信息的好地方是在 [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference) 上的每个 CSS 属性所在的页面。那里的浏览器支持数据往往非常详细。**

### 新 CSS 理解旧 CSS

随着 CSS 新特性的开发，需要注意它们如何与现有的 CSS 相互影响。例如，在 Grid 和 Flexbox 规范中，详细说明了 “display: Grid” 和 “display: flex” 如何处理浮动项变成网格项或 multicol 容器变成网格等场景。这意味着某些现有的行为会被忽略，从而帮助你简单地覆盖不支持的浏览器的 CSS。这些重写的详细信息参见 [Progressive enhancement and Grid Layout on MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout/CSS_Grid_and_Progressive_Enhancement).

### 使用特性查询检测支持

上面的方法只在你要用的 CSS 不需要其他属性的情况下才有效。你可能需要在 CSS 中为老版本浏览器添加额外的属性，然后支持该特性的浏览器才会对这些属性进行解释。

在网格布局的使用中，可以找到一个很好的例子。当浮动项变成网格项时，将失去所有浮动行为。但如果你试图为带有浮动的网格布局创建回退，则你可能会为这些项添加百分比宽度和可能的边距。

```
.grid > .item {
    width: 23%;
    margin: 0 1%;
}
```

[![A four column layout](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/22e70228-0261-4038-9dff-0bb32828f08c/feature-queries1.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/22e70228-0261-4038-9dff-0bb32828f08c/feature-queries1.png) 

使用浮动，我们可以创建一个四列布局，宽度和边距需要设置为 '%'。([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/22e70228-0261-4038-9dff-0bb32828f08c/feature-queries1.png))

当浮动项是网格项时，这些宽度和边距仍然适用。宽度为网格轨道的百分比，而不是容器的宽度;然后将应用任何边距以及你可能指定的间隙。

```
.grid > .item {
    width: 23%;
    margin: 0 1%;
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr 1fr;
    column-gap: 1%;
}
```

[![A four column layout with squished columns](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/11787bcb-ac53-41ba-8390-7eb1a6b8ac79/feature-queries2.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/11787bcb-ac53-41ba-8390-7eb1a6b8ac79/feature-queries2.png) 

宽度现在是网格轨道的百分比，而不是容器的。 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/11787bcb-ac53-41ba-8390-7eb1a6b8ac79/feature-queries2.png))

幸运的是，现代浏览器的 CSS 中内置了一个特性可以帮助我们处理这种情况。特性查询允许我们直接询问浏览器支持什么，然后对响应进行操作。就像媒体查询测试设备或屏幕的一些属性一样，特性查询测试浏览器对 CSS 属性和值的支持。

#### 测试支持

测试支持是最简单的情况，我们使用 “@supports” 测试 CSS 属性和值。只有当浏览器以 true 响应时，即它确实支持该特性，特性查询中的内容才会运行。

#### 测试不支持

你可以询问浏览器是否不支持某个特性。只有当浏览器表明不支持时，特性查询中的代码才会运行。

```
@supports not (display: grid) {
    .item {
        /* CSS from browsers which do not support grid layout */
    }
}
```

#### 多重测试

如果需要支持多个属性，请使用 “and”。

```
@supports (display: grid) and (shape-outside: circle()){
    .item {
        /* CSS from browsers which support grid and CSS shapes */
    }
}
```

如果你需要一个或另一个属性的支持，请使用 “or”。

```
@supports (display: grid) or (display: flex){
    .item {
        /* CSS from browsers which support grid or flexbox */
    }
}
```

#### 选择要测试的属性和值

你无需测试你想要使用的每个属性，只需要测试一些能够表明支持你计划使用的特性的东西。如果你想使用网格布局，你可以测试 “display: Grid”。一旦将来 [subgrid 支持](https://www.smashingmagazine.com/2018/07/css-grid-2/) 进入浏览器，你可能需要更具体地测试 subgrid 功能。在这种情况下，你将测试 “grid-template-columns: subgrid”，并从那些支持 subgrid 的浏览器获得正确的响应。

如果我们现在回到浮动的回退示例，我们可以看到特性查询将如何为我们排序。我们需要做的是查询一下浏览器的支持情况，看看它是否支持网格布局。如果是这样，我们可以将项目的宽度设置为 “auto”，将边距设置为 “0”。

```
.grid > .item {
    width: 23%;
    margin: 0 1%;
}

@supports(display: grid) {
    .grid {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr 1fr;
        column-gap: 1%;
    }

    .grid > .item {
        width: auto;
        margin: 0;
    }
}
```

请查看 [Rachel Andrew](https://codepen.io/huijing/pen/daNaaV) 在 [CodePen](https://codepen.io) 上写的笔记 [Feature Queries and Grid](https://codepen.io/smashing-magazine/pen/daNaaV/)。

请注意，虽然我已经在特性查询中包含了所有网格代码，但我根本无需这样做。如果浏览器不理解网格属性，它将忽略它们，这样它们就可以安全地位于特性查询之外。在本例中，必须包含在特性查询中的内容是 margin 和 width 属性，因为这些属性对于老版本的浏览器代码是必需的，同时也可以被支持的浏览器所应用。

### 拥抱级联

一种非常简单的提供回退的方法是利用浏览器忽略它们不理解的 CSS 的事实，以及当其它所有内容都具有相同特异性的情况下，根据哪个 CSS 应用于元素来考虑源顺序。

首先为不支持该特性的浏览器编写 CSS。然后测试是否支持要使用的属性，如果浏览器确认支持，则使用新代码覆盖回退代码。

这与你在使用媒体查询进行响应式设计时使用的过程大致相同，遵循的是移动优先的方法。在这种方法中，你从较小屏幕的布局开始，然后随着断点的移动，为较大屏幕添加或覆盖内容。

[我可以使用 CSS 特性查询吗？](http://caniuse.com/#feat=css-featurequeries) 关于跨主要浏览器支持 CSS 特性查询的数据来自 caniuse.com。

上述工作方式意味着你不需要担心不支持特性查询的浏览器。正如你从 **Can I Use** 中所看到的，特性查询得到了很好的支持。不支持它们的浏览器是 Internet Explorer 的任何版本。

然而，你想要使用的新特性很可能在 IE 中也不受支持。因此，目前你基本上总是先为不支持的浏览器编写 CSS，然后使用特性查询进行测试。这个特性查询应该做支持测试。

1.  如果浏览器支持特性查询，且支持正在测试的特性，将返回 true，然后将使用特性查询中的代码，覆盖老版本浏览器的代码。
2.  如果浏览器支持特性查询，但不支持正在测试的特性，则返回 false。特性查询中的代码将被忽略。
3.  如果浏览器不支持特性查询，那么特性查询块中的所有内容都将被忽略，这意味着像IE11这样的浏览器将使用你的老版本浏览器代码，这很可能也正是你想要的!

## 2. 处理浏览器“错误”

值得庆幸的是，第二个浏览器支持问题变得不那么常见了。如果你读过去年年底发表的 “[What We Wished For](https://www.smashingmagazine.com/2018/12/internet-explorer-what-we-wished-for/)”，你就能对过去一些令人困惑的浏览器 bug 有一个小小的了解。也就是说，任何软件都可能有 bug，浏览器也不例外。 如果我们加上这样一个事实：由于规范实现的循环性，有时浏览器实现了一些东西，然后规范发生了变化，所以现在需要发布一个更新。在更新发布之前，我们可能处于这样一种情况，即浏览器之间会做一些不同的事情。

如果浏览器报告某些特性的支持不好，那么特性查询就不能帮助我们。没有哪种模式可以让浏览器说“**是的，但你可能不喜欢它**。”当一个实际的互操作性错误出现时，你可能需要在这些情况下更具创造性。

如果你认为自己看到了一个 bug，那么首先要做的就是确认它。有时候，当我们认为自己看到了错误行为，浏览器做了不同的事情，错误就在我们身上。也许我们使用了一些无效的语法，或者试图对格式不正确的 HTML 设置样式。在这些情况下，浏览器会尝试做一些事情;但是，由于你没有按照设计的那样使用这些语言，每种浏览器可能会以不同的方式处理。快速检查 HTML 和 CSS 是否有效是非常好的第一步。

在这一点上，我可能会做一个快速搜索，看看我的问题是否已经被广泛理解。 有一些已知问题的仓库，例如 [Flexbugs](https://github.com/philipwalton/flexbugs) 和 [Gridbugs](https://github.com/rachelandrew/gridbugs)。 然而，即使是精心挑选的几个关键字，也可能出现涵盖相关主题的 Stack Overflow 的帖子或文章，并可能为你提供一个解决方案。

但是假设你不知道是什么导致了这个 bug，这使得寻找解决方案相当困难。因此，下一步就是为你的问题创建一个简化版的测试用例，即去掉任何与之无关的内容，以帮助你准确地确定触发该 bug 的原因。如果你认为你有一个 CSS 错误，你可以删除所有的 javascript，或者在框架外重新创建相同的样式吗？我经常使用 CodePen 来敲出我正在看到的东西的一个简化的测试用例；这有一个额外的优势，那就是如果我需要问问题，我可以很容易地与其他人共享代码。

大多数时候，一旦你孤立了这个问题，就有可能想出另一种方法来达到你想要的结果。你会发现有人想出了一个巧妙的解决办法，或者你可以在某个地方发帖征求意见。

这样说来，如果你认为你有一个浏览器错误，并且找不到其他任何人谈论相同的问题，那么你很可能发现了一些应该报告的新问题。随着最近所有新的 CSS 的发布，在人们开始将这些新东西与 CSS 的其他部分结合使用的过程中，问题随时可能会出现。

**查看 Lea Verou 关于报告这类问题的帖子，“[Help The Community! Report Browser Bugs!](https://www.smashingmagazine.com/2011/09/help-the-community-report-browser-bugs/)”。 本文还提供了创建简化测试用例的重要提示。**

## 3. CSS 属性的部分支持

由于现代 CSS 规范的设计方式，第三种类型的问题变得更加常见。如果我们考虑网格布局和 Flexbox，这些规范都使用 Box Alignment Level 3 中的属性和值进行对齐。因此，像 `align-items`, `justify-content`,和 `column-gap` 这些属性被指定用于 Grid 和 Flexbox 和其它布局方法一样。

然而，在编写本文时，`gap` 属性在所有支持网格的浏览器中都在网格布局中起作用，而 `column-gap` 属性在 Multicol 中起作用;然而，只有 Firefox 为 Flexbox 实现了这些属性。

如果要使用边距为 Flexbox 创建回退，然后测试 `column-gap` 并删除边距，则在网格或多行中支持 `column-gap` 的浏览器中，框之间将没有空间，因此回退间距也将被删除。

```
@supports(column-gap: 20px) {
    .flex {
        margin: 0; /* almost everything supports column-gap so this will always remove the margins, even if we do not have gap support in flexbox. */
    }
}
```

这是当前特性查询的限制。我们没有办法测试在一个特性中对另一个特性中的支持。在上述情况下，我想问浏览器的是，“你是否支持 FlexBox 中的列间距？”这种情况下，我可能得到一个否定的回答，这样我就可以使用我的回退。

CSS 碎片属性 `break-before`、`break-after` 和 `break-inside` 也有类似的问题。当页面被打印出来时，这些属性有更好的支持，因此浏览器通常会声明支持。然而，如果你在 multicol 中测试支持，你会得到误报结果。[我在 CSS 工作组就这个问题提出了一个问题](https://github.com/w3c/csswg-drafts/issues/3559)，然而，这并不是一个容易解决的问题。如果你有什么想法，请把它们加进去。

## 选择器支持测试

目前，特性查询只能测试 CSS 属性和值。我们可能想要测试的另一件事是较新的选择器的支持，例如选择器规范的 level 4 中的选择器。在 Firefox Nightly 的一个标志后面有一个[解释说明](https://github.com/dbaron/css-supports-functions/blob/master/explainer.md)和一个实现，这是一个功能查询的新功能，它将实现这一点。

如果你在 Firefox 中访问 `about:config`，并启用标志 `layout.css.supports-selector.enabled`，那么你可以测试是否支持各种选择器。当前的语法非常简单，例如测试 `：has` 选择器：

```
@supports selector(:has){
  .item {
      /* CSS for support of :has */
  }
}
```

这是一个正在开发中的规范，不过，在我们陈述的时候，你可以看到如何添加特性来帮助我们管理始终存在的浏览器支持问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
