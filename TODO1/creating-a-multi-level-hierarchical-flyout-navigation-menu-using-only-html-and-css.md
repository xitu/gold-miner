> * 原文地址：[Creating a multi-level hierarchical flyout navigation menu using only HTML and CSS](https://www.ghosh.dev/posts/creating-a-multi-level-hierarchical-flyout-navigation-menu-using-only-html-and-css/)
> * 原文作者：[Abhishek Ghosh](https://www.ghosh.dev/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-multi-level-hierarchical-flyout-navigation-menu-using-only-html-and-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-multi-level-hierarchical-flyout-navigation-menu-using-only-html-and-css.md)
> * 译者：[Seven](https://github.com/yzw7489757)
> * 校对者：[Pingren](https://github.com/Pingren)

# 仅使用 HTML 和 CSS 创建多级嵌套弹出式导航菜单

![alt](https://www.ghosh.dev/static/media/css-nav-menu-1.jpg)

今天，我将为你提供一个关于如何创建分层导航弹出式菜单的快速教程，该菜单可以跨多个级别进行深层嵌套。

作为抛砖引玉，我们将从一个具体的实际用例开始 —— 一个桌面应用程序的示例菜单栏。我将选择 Chrome 浏览器菜单栏中的一个子列表来说明这一点。

我们将从一个简单的界面和外观入手，源自经典的 Windows™ 主题，这里有个短视频告诉你它长什么样：

[css-nav-menu-3.mp4](https://www.ghosh.dev/static/media/css-nav-menu-3.mp4)

在最后，我们会增加一些样式，让它有点像 MacOS™ 的感觉。

### 基础

让我们先了解一下菜单项通常由什么组成。它们应该具有以下属性:

* **Label**：（**必选**）这基本上是菜单项的显示名称
* **Target**：（**可选**）超链接，将用户带到一个页面，作为对单击菜单项的响应。我们现在将坚持它只是链接。在页面中添加更多的动态特性需要用到JavaScript，我们暂时不需要这么做。这是你以后可以随时轻松添加的东西。
* **Shortcut**：（**可选**）在我们的例子中，显示一个可用于此菜单项的快捷键组合。例如，“文件 > 新建”在Mac上会是 “Cmd + N”（⌘N）。
* **Children**：（**可选**）指的是此菜单项的子菜单。想想我们的菜单和子菜单的形式 **递归结构**，从视觉效果来说，具有子菜单的菜单项上还应具有箭头图标 （▶）指示悬停时它可以展开。
* **Disabled**：（**可选**）指示菜单项是否可以进行交互。
* 一个概念 **Type** 参数吗？（**可选**）可以用这个模拟不同类型的菜单项。比如，菜单列表中的一些条目应该只起分隔符的作用。

请注意，我们可以继续向菜单添加更复杂的行为。例如，某个菜单可以是一个 **切换** 项，所以，需要某种形式的记号（✔）或与之关联的复选框，以指示其打开/关闭状态。

我们将使用 **CSS classes** 在 HTML 标记上指示这些属性，并编写一些巧妙的样式来传递所有相应的行为。

### 构建 HTML

基于上文，我们的基本菜单 HTML 应该是什么样子：

1. 菜单列表由 HTML `ul` 元素定义，单个菜单项当然是 `li`。
2. **label** 和 **shortcut** 将作为 `span` 元素放置在 `li` 中的锚（`a`）标签内并带有相应 CSS 类（`label` 或 `shortcut`），所以点击它会调用导航事件，还可以提供一些 UI 反馈，例如在 **Hover** 时突出显示菜单项。
3. 当菜单项目包含一栏 **子菜单**（Children）们将该子菜单放在当前菜单 `li` 元素（父）中的另一个 `ul` 元素中，依此类推。这个特定的菜单项包含一个子菜单，并且能够添加一些特定的样式以使其正常工作（以及诸如 ▶ 指示符之类的可视元素，）们将向 `li` 此父级添加 `has-children` CSS 类。
4. 对于像这样的子项 **分隔符**，我们将在 `li` 上中添加一个名为 `separator` 的相应 CSS 类来表示它。
5. 菜单项可以被 **禁用**，在这种情况下，我们将添加相应的 `disabled` CSS 类。它的作用是使此项无法响应鼠标事件，如悬停或点击。
6. 我们将把所有东西包装在一个 HTML `nav` 容器元素中。（这样[语义化](https://en.wikipedia.org/wiki/Semantic_HTML)很好）并为其添加 `flyout-nav` 类，以获取我们将添加的CSS样式的一些基本命名空间。

```html
<nav class="flyout-nav">
    <ul>
        <li>
            <a href="#"><span class="label">File</span></a>
            <ul>
                <li>
                    <a href="#">
                        <span class="label">New Tab</span>
                        <span class="shortcut">⌘T</span>
                    </a>
                </li>
                <li>
                    <a href="#">
                        <span class="label">New Window</span>
                        <span class="shortcut">⌘N</span>
                    </a>
                </li>
                <li class="separator"></li>
                <li class="has-children">
                    <a href="#">
                        <span class="label">Share...</span>
                    </a>
                    <ul>
                        <li>
                            <a href="#">
                                <span class="label">✉️ Email</span>
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <span class="label">💬 Messages</span>
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </li>
    </ul>
</nav>
```

### 在 CSS 中添加行为

我撒了谎。我们将使用 [SCSS](https://sass-lang.com/) 代替。

不开玩笑了，有趣的部分来了！

默认情况下应该 **隐藏** 菜单（第一级 `导航菜单条` 除外）。

只有在使用鼠标指针悬停相应的菜单项时，才应显示第一级下的任何内容。你可能已经猜到了，为了这个我们将严重依赖 CSS 的 [`hover`伪类](https://developer.mozilla.org/en-US/docs/Web/CSS/:hover)。

#### 排列菜单和子菜单元素

理解我们如何使子菜单位置的正确并将其自身与父菜单项对齐也许是整个谜题中最棘手的一点。这就是 CSS [定位](https://developer.mozilla.org/en-us/docs/web/css/position)的一些知识来源。让我们看看这个。

我们之所以选择将子菜单 `ul` 元素放在“父” `li` 元素中是有原因的。当然，它有助于我们在逻辑上适当地将分层内容的标记组合在一起。它还有另一个目的，即允许我们轻松编写一些 CSS 来**相对**于父元素的位置定位子元素。然后我们将这个概念一直延伸到根元素 `ul` 和 `li`。

为此，我们将使用 `absolute` 定位和 `top` 的组合，`left` CSS 属性将帮助我们相对于其最近的**非静态定位祖先（closest non-static positioned ancestor）** 定位子元素定义[包含块](https://developer.mozilla.org/en-US/docs/Web/CSS/Containing_block)。非静态（non-static）的意思是元素的 CSS position 属性不是 `static`（这默认发生在 HTML 文档流中），但它是 `relative`、`absolute`、`fixed` 或者 `sticky` 其中之一。为了确保这一点，我们将把 position `relative` 分配给 `li` 元素，并将其子元素 `ul` 的 position 设置为 `absolute`。

```scss
.flyout-nav {
    // 任何级别的菜单项列表
    ul {
        margin: 0;
        padding: 0;
        position: absolute;
        display: none;
        list-style-type: none;
    }

    // 菜单项
    li {
        position: relative;
        display: block;

        // 显示上的下一级下拉列表
        // 在同一高度的右边
        &:hover {
            & > ul {
                display: block;
                top: 0;
                left: 100%;
            }
        }
    }
```

其效果如下图所示，并在红色框中突出显示以供说明。为了使图片看起来更漂亮，我们在图片中添加了一些用于视觉样式的 CSS，但是核心行为是由上面的内容定义的。这使其在 N 层嵌套内（在实用性的限制范围内）保持良好的工作状态。

![子菜单位置](https://www.ghosh.dev/static/media/css-nav-menu-4.jpg)

但有一个例外，即第一级菜单项列表（在我们的示例中，File、Edit、View...），其子菜单项需要放在 **下方** 而不是右侧。为了处理这个问题，我们添加了一些新的样式重写了之前的 CSS。

```scss
.flyout-nav {
    // ... 其他的东西

    // 一级行为的覆盖（导航菜单条）
    & > ul {
        display: flex;
        flex-flow: row nowrap;
        justify-content: flex-start;
        align-items: stretch;

        // 应显示第一级下拉列表
        // 在同一左侧位置
        & > li:hover > ul {
            top: 100%;
            left: 0;
        }
    }
}
```

请注意，在这里不一定非要使用弹性盒子 `flex-box`，这只是我做的选择。你也可以使用其他方法实现类似的行为，例如在 `ul` 和 `li` 项上组合 `display: block` 和 `display: inline-block`。

##### UI 美化

一旦我们完成了对菜单项定位的基本操作，我们将继续编写一些额外的样式，如字体、大小、颜色、背景和阴影等，以使 UI 感觉更好。

为了一致性和重用，我们采取使用一组 SCSS 变量定义和共享了这些值。像这样...

```scss
// 变量
$page-bg: #607d8b;
$base-font-size: 16px; // 变成 1rem
$menu-silver: #eee;
$menu-border: #dedede;
$menu-focused: #1e88e5;
$menu-separator: #ccc;
$menu-text-color: #333;
$menu-shortcut-color: #999;
$menu-focused-text-color: #fff;
$menu-text-color-disabled: #999;
$menu-border-width: 1px;
$menu-shadow: 2px 2px 3px -3px $menu-text-color;
$menu-content-padding: 0.5rem 1rem 0.5rem 1.75rem;
$menu-border-radius: 0.5rem;
$menu-top-padding: 0.25rem;
```

我们还剩下一些部分要添加合适的样式和特性。我们现在将会快速地把它们过一遍。

##### Anchors、Labels 和 Shortcuts —— 真正的视觉元素

```scss
.flyout-nav {
    // ... 其他的东西

    li {
        // ... 其他的东西

        // 菜单项-文本、快捷方式信息和悬停效果（蓝色背景）
        a {
            text-decoration: none;
            color: $menu-text-color;
            position: relative;
            display: table;
            width: 100%;

            .label,
            .shortcut {
                display: table-cell;
                padding: $menu-content-padding;
            }

            .shortcut {
                text-align: right;
                color: $menu-shortcut-color;
            }

            label {
                cursor: pointer;
            }

            // 对于切换的菜单项
            input[type='checkbox'] {
                display: none;
            }

            input[type='checkbox']:checked + .label {
                &::before {
                    content: '✔️';
                    position: absolute;
                    top: 0;
                    left: 0.25rem;
                    padding: 0.25rem;
                }
            }

            &:hover {
                background: $menu-focused;
                .label,
                .shortcut {
                    color: $menu-focused-text-color;
                }
            }
        }
    }
}
```

这段代码的大部分内容都是简单明了的。但是，你注意到什么有趣的事情了吗？关于 `input[type='checkbox']` ？

##### 切换项

对于切换，我们使用隐藏的 HTML 复选框元素来维护状态（打开或关闭）并相应地使用 [`::before`伪元素](https://developer.mozilla.org/en-US/docs/Web/CSS/::before)为标签设置样式。我们可以使用一个简单的 CSS [相邻兄弟选择器](https://developer.mozilla.org/en-US/docs/Web/CSS/Adjacent_sibling_combinator)来做到这一点。

该菜单项的相应 HTML 标记如下所示：

```html
<li>
    <a href="#">
        <input type="checkbox" id="alwaysShowBookmarksBar" checked="true" />
        <label class="label" for="alwaysShowBookmarksBar">Always Show Bookmarks Bar</label>
        <span class="shortcut">⇧⌘B</span>
    </a>
</li>
```

##### 分隔符

```scss
.flyout-nav {
    // ... 其他的东西

    li {
        // ... 其他的东西

        // 分隔符项
        &.separator {
            margin-bottom: $menu-top-padding;
            border-bottom: $menu-border-width solid $menu-separator;
            padding-bottom: $menu-top-padding;
        }
    }
}
```

##### 禁用

```scss
.flyout-nav {
    // ... 其他的东西

    li {
        // ... 其他的东西

        // 不要让禁用的选项响应 hover
        // 或者点击并给它们涂上不同的颜色
        &.disabled {
            .label,
            .shortcut {
                color: $menu-text-color-disabled;
            }
            pointer-events: none;
        }
    }
}
```

CSS [pointer-events](https://developer.mozilla.org/en-US/docs/Web/CSS/pointer-events) 在这有个实用的技巧。将其设置为 `none` 将变成不可选的鼠标事件目标对象。

### 把它们组合一起...

现在我们已经了解了这些构造块，让我们把它们组合一起。这里有一个 CodePen 链接到我们的多层次弹出式导航菜单的行动！

示例:[仅限于CSS的多级嵌套弹出式导航菜单](https://codepen.io/abhishekcghosh/pen/WqjOaX)

#### 更漂亮的主题

如果你不喜欢复古 Windows 的外观，这是同一代码的另一个版本，对 CSS 进行了一些细微的调整，使其看起来和感觉更像 MacOS。

示例：[仅限于 CSS 的多级嵌套弹出式导航菜单（类似于 MacOS）](https://codepen.io/abhishekcghosh/pen/qzmEWd)

### 什么不管用？

有一些事情我们还没有处理。首先，

* 如果你对此非常挑剔的话，虽然大多数效果都很好，但刻意只使用 CSS 的方法有局限性，与现实世界的 Windows 和 MacOS 应用程序菜单不同，我们的菜单会在鼠标移出外部时立即隐藏。为了使用起来更方便，通常我们想要做的是在点击之后再隐藏（总是可以用一点 JS 来实现）。
* 如果菜单中的项目列表太长怎么办？以书签列表为例。在某些情况下，可能需要将其限制在可滚动视图中，例如按视口高度的某个百分比表示。归根结底，它取决你正在构建的用户体验，但我也想把这些讲清楚。

希望这是有用的。干杯！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
