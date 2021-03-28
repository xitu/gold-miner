> * 原文地址：[3 Fallback Techniques To Support CSS Grid in Any Browser](https://betterprogramming.pub/3-fallback-techniques-to-support-css-grid-in-any-browser-1740454d7cdb)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/3-fallback-techniques-to-support-css-grid-in-any-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2021/3-fallback-techniques-to-support-css-grid-in-any-browser.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[sin7777](https://github.com/sin7777)

# 3 种在任何浏览器中使用 CSS 网格的后备方案

![由 [John Schnobrich](https://unsplash.com/@johnschno?utm_source=medium&utm_medium=referral) 上传至 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/9662/0*z99PsHMNipBY051X)

如今，CSS Grid 在浏览器中已经广受支持 —— 支持 Grid 基本功能的浏览器占比约为 95％。不过有时我们无法忽略剩下的 5％，因为我们可能希望自己的 Web 应用的布局在所有浏览器中看起来都一样的棒，而且我们甚至还可能希望去使用一些支持度较低的 Grid 的新功能。

那我们应该做什么？我们应该避免在生产中使用 Grid 布局吗？我们应该抛弃使用旧版浏览器的用户吗？我们应该等待功能得到更好的覆盖吗？当然不，有很多后备方案可以帮助我们克服这些问题。

在本文中，我们将探讨最重要的三种技术。它们将帮助我们在 Grid 布局上轻松兼容旧版浏览器，这样我们就可以根据可用的浏览器功能，调整我们的网页设计。这一切都将是渐进式适应的。

在深入探讨技术方面的内容之前，我们需要制定一个策略。制定适当的策略是成功的关键，因为这将使我们有方向感和一致性。

## 制定策略

Grid 中最常见的用处是构建适合用户屏幕分辨率的多维栅格布局。但当栅格不可用时该怎么办？除了 Grid 之外，还有什么东西可以帮助我们制作灵活且迅速响应的布局？

我们可以尝试使用 Flexbox 重现相同的布局，不过这样做会增加过多的代码。此外，Flexbox 也不是为了栅格布局而开发的功能，如果使用它，我们可能会遇到一些困难。

现在我们该怎么办？解决方案非常简单：作为后备方案，只需向用户展示移动端的布局即可，而只有使用过时浏览器的桌面端用户才会注意到这些改变。他们在我们的总用户数量中占比非常低。你的站点对于所有人来说应该都是可以使用且一致的，而这就是一个公平的权衡。

那么如何使用最新的 Grid 功能？直接采取相同的策略：尝试回退到一个相似的布局。

总结：我们的布局应该逐步增强。使用较旧浏览器的用户可能只能看到一个更简单但可用的版式，而那些使用最新浏览器的用户将获得完整的用户体验。

让我们来看一下可以使用的前 3 种后备工具。

## 1. 使用 CSS 特性查询

让我们从下面的这段描述开始了解：

> “**特性查询** 是使用 CSS 的 at 规则 [`@supports`](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports) 创建的。它给予 Web 开发者一种有效的方法去测试浏览器是否支持某个确定特性，而后提供基于测试结果生效的 CSS 。在此指南中你将学习如何使用特性查询实现渐进式增强。” — [MDN Web文档]（https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Conditional_Rules/Using_Feature_Queries）

如果你曾经使用过媒体查询，那么我想，你也会非常熟悉 `@supports` 的语法，毕竟两者是很相似的。不过在这里我们使用 `@supports` 不是希望基于浏览器的视口大小来调整布局，而是希望基于 CSS 属性的支持与否来定义指定的样式。

根据我们的策略：

1.我们将使用 Flexbox 构建移动布局版本，并将其用作默认版本。 2.通过使用 `@supports`，我们将检查浏览器是否支持 Grid。如果支持，我们就会使用 Grid 来增强布局。

在此示例中，由于我们仅需关注标准的 Grid 行为。在这里我们可以向 `@supports` 查询基本的 `display：grid` 功能：

```css
@supports (display: grid) {
    /* ... code here */
}
```

完整的例子如下：

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

注意，我们并没有断言 Grid 特性 `grid-template-columns`。如果浏览器不支持该怎么办？在这种情况下，Grid 将退回到默认的定位算法 —— 它将堆叠 `div`。在我们的示例中，该方法可以正常运行，因此我们不需要再去进行额外的工作。

让我们看看结果，这是支持 Grid 的浏览器的桌面端视图结果：

![支持 Grid 时的布局](https://cdn-images-1.medium.com/max/2000/1*DuwFq17QtSj96yMWa7KGwA.png)

这是支持 Grid 的浏览器的移动端视图的结果：

![支持 Grid 时的布局](https://cdn-images-1.medium.com/max/2000/1*nm0t3NbuJboHpmEACBUsIw.png)

这是不支持 Grid 的浏览器的任何视图下的结果：

![Fallback 布局](https://cdn-images-1.medium.com/max/2000/1*YfV-AKl5U5bRzX9BVYtMGg.png)

布局没有被破坏，仍然可用于所有浏览器引擎。只有从桌面端访问它的用户才能看到区别。

## 2. 以编程方式使用 CSS 功能查询

有时，仅通过样式表中的 CSS 特性查询无法实现我们想要的功能。尽管它的功能强大，但也有局限性。因此我们可能需要基于浏览器功能，以编程的方式添加或删除元素。那应该如何实现呢？

幸运的是，可以在 JavaScript 以编程方式调用 CSS 功能。我们可以通过 CSS 对象模型接口 [`CSSSupportsRule`](https://developer.mozilla.org/zh-CN/docs/Web/API/CSSSupportsRule) 来访问 `@supports`。

> `CSSSupportsRule` 接口代表一个 CSS `@supports` 和 `at-rule` — [MDN Web文档]（https://developer.mozilla.org/en-US/docs/Web/API/CSSSupportsRule）

让我们看一下它的定义：

```ts
function supports(property: string, value: string): boolean;
```

我们在一个假设的案例中使用看看。如果用户使用的浏览器不支持 Grid 布局功能，它就会给用户发出警告。不过我们可不能在生产环境中这样做，这只是一个有趣的例子。

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

`CSS.supports` 是用于以编程方式创建后备布局的优秀工具。如果我们必须处理非常复杂的布局，那么我们可能需要选用此方法而不是 CSS 特性查询。有了这种程序化的后备方案，我们可以使用它来创建 Web 组件。

## 3. 属性覆盖

有时候，我们不需要 CSS 特性查询之类的奇特功能。这时，我们就可以利用 CSS 属性的工作原理：在 CSS 类中重新定义属性时，最后一个有效的属性会被视作要使用的属性。

这是什么意思？为什么说它好用呢？我们可以通过覆盖 CSS 属性来定义后备样式：

```css
#container {
    display: flex;
    display: grid;

    /* 如果 Grid 不可用，则第二个属性声明将失效，且浏览器会应用第一个属性声明的值 `flex` */
}
```

我们可以以更简单的方式重写先前的 CSS 特性查询示例：

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

这种后备方案虽然简单但是功能强大。在许多情况下它很有用 —— 毕竟我们可能无法对所有要使用的 Grid 功能都进行查询。

让我们用它从最新的 Grid 功能之一：`subgrid` 进行回退吧。我们应该如何使用呢？

让我们想象一下需要对嵌套的 Grid 模板列使用 `subgrid` 的场景，划重点：

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

如你所见，结果看起来是完全一致的，但其实只是非常相似而已，这就是我们的目标。随着越来越多的浏览器采用 `subgrid`，更多的用户都可以看到布局的像素级完美版本！

## 结论

Grid 和 Flexbox 旨在解决不同的情况。我们无法一直使用 Flexbox 构建所有布局，因为仍然有少数浏览器不支持它。

从 Flexbox 升级到 Grid 并不意味着布局在旧设备上突然失效。在本文中，我们探讨了构建渐进式布局有多么容易和有趣。正如我们在一开始所看到的那样，制定一项如何进行的策略非常重要。

这些策略不仅仅是为了添加基本的 Grid 功能。只要我们提供合理的后备方案，我们就可以利用诸如 `subgrid` 之类的最新功能。

我希望这能鼓励你在需要时去生产环境中逐渐应用 Grid。现在，我们不必再躲在 Flexbox 后面了！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
