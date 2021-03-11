> * 原文地址：[3 Fallback Techniques To Support CSS Grid in Any Browser](https://betterprogramming.pub/3-fallback-techniques-to-support-css-grid-in-any-browser-1740454d7cdb)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/3-fallback-techniques-to-support-css-grid-in-any-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2021/3-fallback-techniques-to-support-css-grid-in-any-browser.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 3 中在任何浏览器中使用 CSS 网格的 Fallback 技术

![由 [John Schnobrich](https://unsplash.com/@johnschno?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/9662/0*z99PsHMNipBY051X)

如今，CSS Grid 在浏览器中已经有了强壮的支持基础 —— 支持 Grid 基本功能的浏览器占比约为 95％。不过有时我们可能无法忽略这 5％，因为我们可能希望我们的 Web 应用程序的布局在所有浏览器中都看起来一样的棒，而且我们甚至还可能希望去使用一些支持率较少的较新的 Grid 功能。

那我们应该做什么？我们应该避免在生产中使用 Grid 吗？我们应该抛弃使用旧版浏览器的用户吗？我们应该等待功能得到更好的覆盖吗？当然不，有很多 Fallback 技术可以帮助我们克服这些问题。

在本文中，我们将探讨最重要的三种技术。它们将帮助我们在网格布局上轻松兼容旧版浏览器，这样我们就可以根据可用的浏览器功能，调整我们的网页设计。这些新功能们，都会被浏览器以及 Fallback 技术所逐渐适应。

在深入探讨技术方面的内容之前，我们需要定下一个策略。制定适当的策略是成功的关键，因为这将使我们有方向感和一贯性。

## 制定策略

Grid 中最常见的用处是构建适合用户屏幕分辨率的多维栅格布局。但当栅格不可用时该怎么办？除了 Grid 之外，还有什么东西可以帮助我们制作灵活且迅速响应的布局？

我们可以尝试使用 Flexbox 复制相同的布局，不过这样做会增加过多的代码。此外，Flexbox 也不是为了栅格布局而开发的功能，如果使用它，我们可能会遇到一些困难。

现在我们该怎么办？解决方案非常简单：作为 Fallback，只需向用户展示移动端的版式即可，而只有使用过时浏览器的台式机用户会注意到这些改变。他们在我们的总用户数量中所占的比例非常低。该站点应该面对所有人来说都是可以使用且一致的，而这就是一个公平的权衡。

那么如何使用最新的 Grid 功能？直接采取相同的策略：尝试回退到一个相似的布局。

总结：我们的布局应该逐步增强。使用较旧浏览器的用户可能只能看到一个更简单但可用的版式，而那些使用最新浏览器的用户将获得完整的 UX 体验。

让我们来看一下我们可以使用的前 3 种 Fallback 工具。

## 1. 使用 CSS 功能查询

让我们从下面的这段描述开始了解：

> “**特性查询** 使用 CSS 的 at 规则 [`@supports`](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports) 创建。它给予 Web 开发者一种测试浏览器是否有对某个确定特性的支持，而后提供基于测试结果生效的 CSS 的方法。在此指南中你将学习如何使用特性查询实现渐进式增强。” — [MDN Web文档]（https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Conditional_Rules/Using_Feature_Queries）

如果你曾经使用过媒体查询，那么我想，你大概非常熟悉 `@supports` 的使用语法，毕竟这是很相似的。不过在这里我们使用 `@supports` 不是希望基于浏览器的视口大小来调整布局，而是需要基于 CSS 属性的支持与否来定义指定的样式。

根据我们的策略：

1.我们将使用 Flexbox 构建移动布局版本，并将其用作默认版本。 2.通过使用 `@supports`，我们将检查浏览器是否支持 Grid。如果支持，我们就会使用 Grid 来增强布局。

在此示例中，由于我们仅需关注标准的 Grid 行为。在这里我们可以向 `@supports` 查询基本的 `display：grid` 功能：

```css
@supports (display: grid) {
    /* ... code here */
}
```

完整的例子如下

```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <title>生产中的 Grid</title>
    <meta charset="UTF-8"/>
</head>

<body>
<style>
    #container {
        display: flex;
        flex-direction: column;
        gap: 10px;
        border: 1px solid #000;
        padding: 10px;
    }

    @supports (display: grid) {
        #container {
            display: grid;
        }

        @media (min-width: 768px) {
            #container {
                grid-template-columns: 100px 1fr 100px;
            }
        }
    }

    .side1 {
        padding: 10px;
        background-color: #CEB992;
    }

    .side2 {
        padding: 10px;
        background-color: #CEB992;
    }

    .content {
        padding: 10px;
        min-height: 400px;
        background-color: #5B2E48;
    }

    body {
        color: #FFF;
        font-weight: 500;
    }
</style>
<div id="container">
    <div class="side1">
        侧边栏
    </div>
    <div class="content">
        主要内容
    </div>
    <div class="side2">
        侧边栏
    </div>
</div>
</body>
</html>
```

注意，我们并没有断言 Grid 特性 `grid-template-columns`。如果浏览器不支持该怎么办？在这种情况下，Grid 将退回到默认的定位算法 —— 它将堆叠 `div`。在我们的示例中，该方法正常的执行了，因此我们并不需要再去进行别的什么工作。

让我们看看结果，这是支持 Grid 的浏览器的桌面端视图的结果：

![支持网格时的布局](https://cdn-images-1.medium.com/max/2000/1*DuwFq17QtSj96yMWa7KGwA.png)

这是来自支持 Grid 的浏览器的移动端视图下的结果：

![支持网格时的布局](https://cdn-images-1.medium.com/max/2000/1*nm0t3NbuJboHpmEACBUsIw.png)

这是来自不支持 Grid 的浏览器的任何视图下的结果：

![Fallback 布局](https://cdn-images-1.medium.com/max/2000/1*YfV-AKl5U5bRzX9BVYtMGg.png)

布局没有损坏，仍然可用于所有浏览器引擎。只有从桌面访问它的用户才能看到不同。

## 2. 以编程方式使用 CSS 功能查询

有时，仅通过 CSS 样式中的 CSS 功能查询无法实现我们想要的功能。尽管它的功能强大，但也有局限性，因为我们可能需要基于浏览器功能，以编程方式让程序自动添加或删除元素。那应该如何实现？

幸运的是，可以在 JavaScript 以编程方式调用 CSS 功能。我们可以通过 CSS 对象模型接口 [`CSSSupportsRule`](https://developer.mozilla.org/zh-CN/docs/Web/API/CSSSupportsRule) 来访问 `@supports`。

> `CSSSupportsRule` 接口代表一个 CSS `@supports` 和 `at-rule` — [MDN Web文档]（https://developer.mozilla.org/en-US/docs/Web/API/CSSSupportsRule）

让我们看一下它的定义：

```ts
function supports(property: string, value: string): boolean;
```

让我们在一个假设的案例中使用它。如果用户使用的浏览器不支持网格布局功能，它就会警告我们不能使用。不过我们可不能在生产中这样做，这只是一个有趣的例子。

这是我们有条件地检查是否不支持 Grid 的方式：

```js
if (!CSS || !CSS.supports('display', 'grid')) {
    // ...
}
```

请注意，某些浏览器可能不支持 `CSS.supports`，因此我们还添加了空检查。

让我们来看一个有效的代码示例：

```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <title>生产中的 Grid</title>
    <meta charset="UTF-8"/>
</head>
<body>
<style>
    #container {
        display: flex;
        flex-direction: column;
        gap: 10px;
        border: 1px solid #000;
        padding: 10px;
    }

    @supports (display: grid) {
        #container {
            display: grid;
        }

        @media (min-width: 768px) {
            #container {
                grid-template-columns: 100px 1fr 100px;
            }
        }
    }

    .side1 {
        padding: 10px;
        background-color: #CEB992;
    }

    .side2 {
        padding: 10px;
        background-color: #CEB992;
    }

    .content {
        padding: 10px;
        min-height: 400px;
        background-color: #5B2E48;
    }

    body {
        color: #FFF;
        font-weight: 500;
    }
</style>
<script>
    (function warnSupport() {
        if (!CSS || !CSS.supports('display', 'grid')) {
            alert('Warning your Browser does not support the latests features. Consider switching to a newer one')
        }
    })();
</script>
<div id="container">
    <div class="side1">
        侧边栏
    </div>
    <div class="content">
        主要内容
    </div>
    <div class="side2">
        侧边栏
    </div>
</div>
</body>
</html>
```

`CSS.supports` 是用于以编程方式创建备用布局的好工具。如果我们必须处理非常复杂的布局，那么我们可能需要选择此方法而不是 CSS 功能查询。我们可以使用它来创建具有程序化备用功能的 Web 组件。

## 3. 属性的覆写

有时候，我们不需要 CSS 功能查询之类的奇特功能。我们可以利用 CSS 属性的工作原理：在 CSS 类中重新定义属性时，最后一个有效的属性会被视作要使用的属性。

那是什么意思？它怎么个好用？我们可以通过覆盖 CSS 属性来定义备用样式：

```css
#container {
    display: flex;
    display: grid;

    /* 如果 Grid 不可用，则第二句代码将无效，且浏览器会应用第一句的属性值 `flex` */
}
```

我们可以以更简单的方式重写我们先前的 CSS 功能查询示例：

```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <title>生产中的 Grid</title>
    <meta charset="UTF-8"/>
</head>
<body>
<style>
    #container {
        display: flex;
        display: grid;
        flex-direction: column;
        gap: 10px;
        border: 1px solid #000;
        padding: 10px;
    }

    @media (min-width: 768px) {
        #container {
            grid-template-columns: 100px 1fr 100px;
        }
    }

    .side1 {
        padding: 10px;
        background-color: #CEB992;
    }

    .side2 {
        padding: 10px;
        background-color: #CEB992;
    }

    .content {
        padding: 10px;
        min-height: 400px;
        background-color: #5B2E48;
    }

    body {
        color: #FFF;
        font-weight: 500;
    }
</style>
<script>
    (function warnSupport() {
        if (!CSS || !CSS.supports('display', 'grid')) {
            alert('Warning your Browser does not support the latests features. Consider switching to a newer one')
        }
    })();
</script>
<div id="container">
    <div class="side1">
        侧边栏
    </div>
    <div class="content">
        主要内容
    </div>
    <div class="side2">
        侧边栏
    </div>
</div>
</body>
</html>
```

此 Fallback 简单但功能强大。在许多情况下它很有用 —— 毕竟我们可能无法对要使用的所有 Grid 功能使用支持查询。

让我们用它来摆脱最新的 Grid 功能之一：`subgrid`，我们应该如何使用它？

让我们检查一下我们想对嵌套的 Grid 模板列使用 `subgrid` 的情况，划重点：

```css
#content {
    grid-template-columns: inherit;
    grid-template-columns: subgrid;
}
```

在此示例中，当不支持 `subgrid` 时候，它将仅继承父级的 Grid 定义。这将创建一个大致相似的布局。

这只是一个简单的例子。 我们可以将 `grid-template-columns` 微调到某些固定大小，或者在我们的特定情况下最适合的大小。

这是完整的示例：

```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Grid 案例</title>
    <meta charset="UTF-8"/>
</head>
<body>
<style>
    body {
        color: white;
        text-align: center;
        box-sizing: content-box;
        margin: 20px;
    }

    .palette-1 {
        background-color: #CEB992;
    }

    .palette-2 {
        background-color: #471323;
    }

    .palette-3 {
        background-color: #73937E;
    }

    .palette-4 {
        background-color: #5B2E48;
    }

    .palette-5 {
        background-color: #585563;
    }

    #container {
        padding: 10px;
        background-color: #73937E;
        height: 500px;
        width: calc(100vw - 60px);
        display: grid;
        grid-template-rows: repeat(8, 1fr);
        grid-template-columns: max-content 1fr 1fr 1fr;
        row-gap: 1rem;

    }

    .item {
        padding: 20px;
    }

    .content-main {
        grid-column: span 3;
    }

    #content {
        background-color: #73937E;
        grid-column: 1 / -1;
        display: grid;
        grid-template-columns: inherit;
        grid-template-columns: subgrid;
        column-gap: 1rem;
    }


</style>
<div id="container">
    <div id="content">
        <div class="content-left item palette-5">
            标题
        </div>
        <div class="content-main item palette-4">
        </div>
    </div>
    <div id="content">
        <div class="content-left item palette-5">
            另一个标题
        </div>
        <div class="content-main item palette-4">
        </div>
    </div>
</div>
</script>
</body>
</html>
```

至于结果：

![`subgrid` 可用时](https://cdn-images-1.medium.com/max/2000/1*vk89GdczF9r3hEZI6841gw.png)

![`subgrid` 不可用时](https://cdn-images-1.medium.com/max/2000/1*j8rPVYjENApqFPg--2Be_A.png)

如我们所见，结果是完全一致的，但是它们的实现非常相似，这就是我们的目标。随着越来越多的浏览器采用 `subgrid`，更多的用户将看到布局的像素完美版本。

## 结论

Grid 和 Flexbox 旨在解决不同的情况。我们无法继续使用 Flexbox 构建所有内容，因为仍然有少数浏览器不支持它。

从 Flexbox 升级到 Grid 并不意味着布局在旧设备上突然失效。在本文中，我们探讨了构建渐进式布局有多么容易和有趣。正如我们在一开始所看到的那样，制定一项如何进行的战略非常重要。

这些策略不仅仅是为了添加基本的 Grid 功能。只要我们提供合理的 Fallback，我们就可以利用诸如 subgrid 之类的最新功能。

我希望这能激发我们在需要时逐步在生产中使用 Grid 的动机，现在，我们不必再躲在 Flexbox 后面了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
