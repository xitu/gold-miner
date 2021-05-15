> * 原文地址：[Top 3 CSS Grid Features To Start Using in Production](https://medium.com/better-programming/top-3-css-grid-features-to-start-using-in-production-b0fe59b2e0f7)
> * 原文作者：[Jose Granja](https://medium.com/@dioxmio)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/top-3-css-grid-features-to-start-using-in-production.md](https://github.com/xitu/gold-miner/blob/master/article/2021/top-3-css-grid-features-to-start-using-in-production.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Usualminds](https://github.com/Usualminds)、[zqp1226358](https://github.com/zqp1226358)

# 3 个最棒的最值得你去在产品中使用的 CSS Grid 功能

![由 [Sigmund](https://unsplash.com/@sigmund?utm_source=medium&utm_medium=referral) 拍摄并在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 上传的图片](https://cdn-images-1.medium.com/max/8096/0*mWiTIfu6BVlYQ5lf)

Grid 最初是由 Microsoft 团队起草的，并于 2011 年在 IE 10 中落实的。经过近 9 年的发展，我们现在可以说，浏览器对 Grid 的支持已经变得足够好，这样我们可以安心在生产环境中中使用 Grid 了。

本篇文章我们主要讨论浏览器支持且使用频率最高的 3 个 Grid 布局相关的特性。即使有一些更酷的新功能的出现，例如 `subgrid` 等的问世，也请注意谨慎在生产中不要使用这些功能。在发布产品前，请先检查 [Can I Use](https://www.caniuse.com) 网站上的浏览器支持信息。养成这样一个好习惯，百利而无一害。

## 一个简要的复习

究竟什么是 Grid？Grid 其实就是一个以容器为中心的多维布局系统。简而言之：它可以在任何 x / y 方向上拓展，并且所有布局信息都存储在父节点中，而子节点则大多掌握有关如何将自己放置在 Grid 上的信息。

![一维布局与二维布局](https://cdn-images-1.medium.com/max/2000/1*6YeEVVXSRcJwnZBHo2EgpQ.png)

在使用 Grid 开发时，建议使用 Firefox 浏览器，因为它的 Dev Tools 比其他浏览器的都要好 —— 支持 Grid 相关属性最棒的浏览器，而且它也是目前唯一支持 `subgrid` 属性的浏览器。

现在，让我们深入研究可用于生产的三大 CSS Grid 功能。

## 1.  Grid 模板区域

这是我一直以来最喜欢的 CSS Grid 功能，允许我们以声明的方式定义 Grid 布局。

我们可以使用几行 CSS 行创建一个非常复杂且响应迅速的布局：

```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Grid Playground</title>
    <meta charset="UTF-8"/>
    <style type="text/css">
        body {
            color: white;
            text-align: center;
        }

        #grid {
            background-color: #73937E;
            height: calc(100vh - 20px);
            display: grid;
            grid-template-rows: 1fr 3fr 1fr;
            grid-template-areas:
                "navigation navigation navigation navigation"
                "left content content right"
                "footer footer footer footer";
        }

        @media screen and (max-width: 700px) {
            #grid {
                grid-template-rows: 1fr 3fr 1fr 1fr 1fr;
                grid-template-areas:
                    "navigation"
                    "content"
                    "left"
                    "right"
                    "footer";
            }
        }

        .navigation {
            padding: 10px;
            background-color: #471323;
            grid-area: navigation;
        }

        .content {
            padding: 10px;
            background-color: #5B2E48;
            grid-area: content;
        }

        .left {
            padding: 10px;
            background-color: #585563;
            grid-area: left;
        }

        .right {
            padding: 10px;
            background-color: #585563;
            grid-area: right;
        }

        .footer {
            padding: 10px;
            background-color: #CEB992;
            grid-area: footer;
        }
    </style>
</head>

<body>
<div id="grid">
    <div class="navigation">Nav</div>
    <div class="left">Left</div>
    <div class="content">Content</div>
    <div class="right">Right</div>
    <div class="footer">Footer</div>
</div>
</body>
</html>
```

![复杂的 Grid 布局](https://cdn-images-1.medium.com/max/2000/1*kxxETOv_yi4ECBfYz_D-mw.png)

所有的变化都由 `grid-templates-areas` 和 `grid-area` 两个属性产生。前者定义了所有 Grid 轨迹，而后者将 Grid 元素定位在那些区域上。

提示： Grid 轨迹是两条 Grid 线之间的空间。

让我们使用 Firefox Inspector 审查页面元素，能够清晰地了解我们所创建的 Grid 布局。

![ Grid 布局的内部](https://cdn-images-1.medium.com/max/2090/1*U9o4_M-wfMeBHindl1H4sw.png)

如果我们想在内容周围留一些空白，而不是直接挨着左右两列，我们可以使用`.` / `...` 符号。

```css
#grid {
    background-color: #73937E;
    height: calc(100vh - 20px);
    display: grid;
    grid-template-rows:1fr 2fr 1fr;
    grid-template-areas:
    "navigation navigation navigation navigation"
    ". content content ."
    "footer footer footer footer";
}
```

![在主要内容两边定义空白 Grid](https://cdn-images-1.medium.com/max/2074/1*frMRKP1wKAGbxlAuQVI_SQ.png)

注意：使用 `grid-template-areas` 时，需要注意以下几点：

* 每个区域名称只能定义一次。如果没有连接具有相同区域名称的单元，则将会被视为两个声明。
*  Grid 区域单元必须形成一个矩形。如果不是，则声明无效。

```css
/* 一个无效的 Grid */
#grid {
    background-color: #73937E;
    height: calc(100vh - 20px);
    display: grid;
    grid-template-areas:
    "navigation navigation navigation navigation"
    "left content content right"
    "content content content content"
    "left content content right"
    "footer footer footer footer";
}
```

上面的示例不起作用。因为 `right` 和 `left` 的定义都重复了。删除 `content content content content` 一行，让 `left` 和 `right` 连接起来，就能够解决该问题。

```css
/* 一个无效的 Grid */
#grid {
    background-color: #73937E;
    height: calc(100vh - 20px);
    display: grid;
    grid-template-areas:
    "navigation navigation navigation navigation"
    "content right"
    "content content"
    "right"
    "footer";
}
```

上面的示例不起作用，因为我们定义了描述了一个非矩形区域，而 Grid 并非为此而建，也不支持它。

提示：我们可以将 `grid-template-rows` 和 `grid-template-areas` 结合使用，但是结果将有所不同。我们必须选择一种适合我们特定场景的方案。

```css
/* 方法 A */
#grid {
    grid-template-rows: 1fr 3fr 1fr;
    grid-template-areas:
	  "navigation navigation navigation navigation"
	  "left content content right"
	  "footer footer footer footer";
}

/* 方法 B */
#grid {
    grid-template-areas:
	  "navigation navigation navigation navigation"
	  "left content content right"
	  "left content content right"
	  "left content content right"
	  "footer footer footer footer";
}
```

![方法 A](https://cdn-images-1.medium.com/max/2090/1*U9o4_M-wfMeBHindl1H4sw.png)

![方法 B](https://cdn-images-1.medium.com/max/2082/1*18VMr9MkDmUHOS-biKfckQ.png)

提示：使用 `grid-template-area` 可以简单创建 Grid 线。这意味着即使使用 `grid-template-area`，我们仍然可以使用 Grid 线的位置逻辑。接下来，让我们简要介绍一下负索引 `-1`。

```css
.customContent {
    background-color: white;
    grid-row: 1 / -1;
    grid-column: 1;
}
```

添加负索引会使我们的 CSS 更强大。我们可能会对 Grid 线的数量不了解：通过负索引，我们可以将内容设置为扩展到最后一个 Grid 线。

![行上面使用负索引的结果](https://cdn-images-1.medium.com/max/2078/1*mFCCFIxCWZ_EA5H80t-BjQ.png)

## 2. Grid 间隔

Grid 的 `gap` 特性的使用是很简捷的。我们仅需使用 `column-gap`、`row-gap` 或 `gap` 就能定义 Grid 布局中的间隙。

```css
#grid {
    background-color: #73937E;
    height: calc(100vh - 20px);
    display: grid;
    row-gap: 5px;
    column-gap: 15px;
    grid-template-areas:
    "navigation navigation navigation navigation"
    "left content content right"
    "content content content content"
    "left content content right"
    "footer footer footer footer";
}
```

![使用 gap 功能](https://cdn-images-1.medium.com/max/2000/1*aajG-IirnfyHHYyPb2YKsw.png)

注意：请勿使用 `grid-gap`、`grid-column-gap` 或 `grid-column-gap`：现在它们已过时，浏览器的支持会不断下降。

## 3. MinMax

起初，`MinMax` 看起来并不像一个令人兴奋的功能。这个功能非常简单：

```
minmax(min, max)
```

它将在 `min` 和 `max` 之间获取最大值。它接受：`length`、`percentage`、`max-content`、`min-content` 和 `auto` 五种类型的值。它就是专门为 Grid 打造的，因此能够在 Grid 上发挥出超强的作用。

让我们创建一个包含三列的布局，并使用 `minmax` 将其扩展到整个 Grid 区域。

```
grid-template-columns: repeat(3, minmax(100px, 1fr));
```

![使用 minmax 定义三列布局](https://cdn-images-1.medium.com/max/2000/1*DqLyXYT5DlN7k8NHejQ1nQ.png)

注意：这看起来很棒，但是有一个很大的缺点 —— 如果容器小于 `3 * 100px + 2 * 10px`，则内容将溢出。

![没有足够的空间来渲染最小宽度为 100px 的三列布局](https://cdn-images-1.medium.com/max/2000/1*q-y32_HSK0RUABQregRtJw.png)

我们该如何解决？直接以响应方式构建 Grid 布局！我们可以让 Grid 容器通过使用 `auto-fill` 或 `auto-fit` 来确定列数。

通过简单的更改，我们的三列布局现在可以响应视口的大小：

```HTML
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Grid Playground</title>
    <meta charset="UTF-8"/>
    <style type="text/css">
        body {
            color: white;
            text-align: center;
            box-sizing: content-box;
        }

        #grid {
            background-color: #73937E;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px;
            padding: 20px;
        }

        .item {
            padding: 20px;
            background-color: #5B2E48;
        }
    </style>
</head>
<body>
<div id="grid">
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
    <div class="item"></div>
</div>
</body>
</html>
```

![响应式 Grid 布局](https://cdn-images-1.medium.com/max/2000/1*wu16vXlLxgjnrI8Gragp1g.png)

那就是我们所有变化所发生的源头：

```
grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
```

我们告诉 Grid 布局创建填充 Grid 空间的轨迹，并且它们的最小值应为 `200px`，最大值应为 `1fr`。

注意：我们不能使用 `auto-fill` 来设置最大列数。但这并不是要那样工作。为了设置最大列数，我们必须使用媒体查询并调整 `minMax` 的值。 另一种选择是使用 `css变量`。任一选项都需要使用媒体查询。

```css
/* 使用媒体查询 + CSS 变量去构建响应式的固定栏目布局 */

.grid {
    --repeat: auto-fit;
}

@media screen and (max-width: 700px) {
    .grid {
        --repeat: 3;
    }
}

/* 使用： grid-template-columns: repeat(var(--repeat, auto-fit), minmax(200px, 1fr)); */
```

最后，让我们进一步了解 `auto-fill` 和 `auto-fit` 之间的区别：

*`auto-fill`：尝试在给定约束条件下用尽可能多的列填充行
*`auto-fit`：行为与`auto-fill`相同，但是任何空的重复轨道将被折叠，它将扩展其他轨道以占用所有可用空间（如果有）。

![自动填充与自动调整](https://cdn-images-1.medium.com/max/2000/1*Be3yz9t1oZ-OzfWghQ_l0g.png)

当有足够的元素填充 Grid 时，两个属性的效果将相同。这意味着根据分辨率的不同，它们可能渲染的效果是一样的。这就是为什么了解他们的内部情况是很重要的。

![在某些分辨率下，它们的作用效果可能相同](https://cdn-images-1.medium.com/max/2000/1*bjQpF-R9e7ki-5u2c5zOwg.png)

## 总结

![[Denys Nevozhai](https://unsplash.com/@dnevozhai?utm_source=medium&utm_medium=referral) 拍摄并发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 的照片](https://cdn-images-1.medium.com/max/10944/0*qOzhnK7sH5tZyk_T)

我们介绍了最突出的三个 Grid 特性并深入探讨了如何以最恰当的方式使用它们。现在，我想我们已经可以使用更少的 CSS 代码以更高效的方式构建布局。使用 Flex API 的日子已经过去了，现在就让我们一起使用 Grid 功能来美化我们的页面吧～

不幸的是，我们无法等待 IE 11 的终结，因为它至少在 4 年内不会发生，毕竟它仍然在企业级别被广泛地使用着。现在我们需要添加一些 polyfill 确保 100％ 的用户都能够正常地使用。

我希望我的文章能为阅读的你提供开始在生产中使用 Grid 的信心。毕竟一旦开始使用它，就再也没有回头路了，这玩意真是太好用了！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
