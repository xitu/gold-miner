>* 原文链接 : [How to Build a News Website Layout with Flexbox](http://webdesign.tutsplus.com/tutorials/how-to-build-a-news-website-layout-with-flexbox--cms-26611)
* 原文作者 : [Jeremy Thomas](http://tutsplus.com/authors/jeremy-thomas)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [zhangzhaoqi](https://github.com/joddiy)
* 校对者: [Galen](https://github.com/galenyuan)，[Jasper Zhong](https://github.com/DeadLion)

![最终产品效果图](https://cms-assets.tutsplus.com/uploads/users/30/posts/26611/final_image/preview.png)

<figcaption>你将要创建的东西</figcaption>

在你刚接触 Flexbox 的时候没有必要理解关于 Flexbox 的 _所有_ 方面。在这篇教程中，我们将介绍 Flexbox 的一些新特性。同时设计一种新的、像 [The Guardian](http://www.theguardian.com) 一样的布局方式。

我们使用 Flexbox 是因为它提供了许多强大的特性：

*   我们可以通过简单的方式来实现响应式的纵列
*   我们可以使列等高
*   我们可以把内容塞入容器的 _底部_

我们开始吧！

## <span class="sectionnum">1.</span> 用两个列开始

在 CSS 中创建列一直是一个挑战。在很长的一段时间里，唯一的选择是使用 float 或者 table，但是这两种方法都有各自的问题。

Flexbox 使流程更加简单，提供了如下：

*   **简洁的代码**：我们仅仅只需要在容器了添加 `display: flex`
*   不需要去 **清除** float, Flexbox 避免出现无法预料的布局行为
*   **语义标记**
*   **灵活性**：我们可以用很少的 CSS 代码来调整列的尺寸、伸缩和对齐方式

让我们从创建两个列开始：一个占容器的 2/3 宽度，另一个占 1/3 。

    <div class="columns">
      <div class="column main-column">
        2/3 column
      </div>
      <div class="column">
        1/3 column
      </div>
    </div>

这里有两个元素：

1.  一个 `columns` 容器
2.  两个 `column` 子容器，其中一个添加名为 `main-column` 的 class 来使它更宽。

    .columns {
      display: flex;
    }

    .column {
      flex: 1;
    }

    .main-column {
      flex: 2;
    }

因为 `main-column` 的 flex 值设为了 `2` ，它将会占用其他列的两倍的空间。

通过添加一些视觉效果，我们将得到：

<iframe src="https://codepen.io/tutsplus/embed/gMbpQM/?height=200&amp;theme-id=12451&amp;default-tab=result" width="850" height="200" frameborder="no" allowfullscreen="true" scrolling="no"></iframe>

## <span class="sectionnum">2.</span> 把每一列都变成 Flexbox 容器

这两列中的每一个都会垂直地堆积数篇文章，所以我们打算也把 `column` 元素移到 Flexbox 容器中。我们想要：

*   文章被垂直堆积
*   文章可 _拉伸_ 并且可用

    .column {
      display: flex;
      flex-direction: column; /* 确保文章垂直堆积 */
    }

    .article {
      flex: 1; /* 拉伸文章填充整个保留空间 */
    }

_容器_ 上的 `flex-direction: column` 规则合并了 _子容器_ 上的 `flex: 1`  规则来确保文章可以充满整个垂直空间，也保证了两个第一列有相同的高度。

<iframe src="https://codepen.io/tutsplus/embed/PzwqXG/?height=400&amp;theme-id=12451&amp;default-tab=result" width="850" height="400" frameborder="no" allowfullscreen="true" scrolling="no"></iframe>

## <span class="sectionnum">3.</span> 把每一篇文章都变成 Flexbox 容器

现在，为了给我们额外的控制，我们要把每一篇文章移到 Flexbox 容器下。这些文章都包含：

*   一个标题
*   一段报道
*   一个带有作者和评论数量的信息栏
*   一张可选的响应图片

我们在这里使用 Flexbox 是为了把信息栏塞入底部。作为参照，这是我们的目标文章布局：

<figure class="post_image">![](https://cms-assets.tutsplus.com/uploads/users/30/posts/26611/image/card.png)</figure>

这里是代码：

    <a class="article first-article">
      <figure class="article-image">
        <img src="">
      </figure>
      <div class="article-body">
        <h2 class="article-title">
          <!-- 标题 -->
        </h2>
        <p class="article-content">
          <!-- 内容 -->
        </p>
        <footer class="article-info">
          <!-- 信息 -->
        </footer>
      </div>
    </a>

    .article {
      display: flex;
      flex-direction: column;
    }

    .article-body {
      display: flex;
      flex: 1;
      flex-direction: column;
    }

    .article-content {
      flex: 1; /* 这将使文本填充保留空间，并且把信息栏塞入底部 */
    }

多亏了 `flex-direction: column;` 规则，文章的元素都被垂直排列了。

我们给 `article-content` 元素使用 `flex: 1` 因此它可以填充整个空白空间，然后把 `article-info` 塞入底部，无论列的高度如何。

<iframe src="https://codepen.io/tutsplus/embed/RRNWNR/?height=500&amp;theme-id=12451&amp;default-tab=result" width="850" height="500" frameborder="no" allowfullscreen="true" scrolling="no"></iframe>

## <span class="sectionnum">4.</span> 添加一些嵌套列

在左边一列，我们真正想要的是 _另一组_ 列。所以我们使用之前相同的 `columns` 容器来替换第二个文章。

    <div class="columns">
      <div class="column nested-column">
        <a class="article">
          <!-- 文章内容 -->
        </a>
      </div>

      <div class="column">
        <a class="article">
          <!-- 文章内容 -->
        </a>
        <a class="article">
          <!-- 文章内容 -->
        </a>
        <a class="article">
          <!-- 文章内容 -->
        </a>
      </div>
    </div>

因为我们想要第一个嵌套列更宽一些，所以我们在附加效果中加入了 `nested-column` class：
    .nested-column {
      flex: 2;
    }

这将使新创建列的宽度是其他列的两倍。

<iframe src="https://codepen.io/tutsplus/embed/wWBKaq/?height=500&amp;theme-id=12451&amp;default-tab=result" width="850" height="500" frameborder="no" allowfullscreen="true" scrolling="no"></iframe>

## <span class="sectionnum">5.</span> 给第一篇文章一个水平布局

第一篇文章太大了。为了优化使用空间，让我们把它的布局变成水平的。

    .first-article {
      flex-direction: row;
    }

    .first-article .article-body {
      flex: 1;
    }

    .first-article .article-image {
      height: 300px;
      order: 2;
      padding-top: 0;
      width: 400px;
    }

这里的 `order` 属性非常有用，因为它允许我们不用影响 HTML 标记就可以修改 HTML 元素的顺序。这里的 `article-image` 在标记中实际上在 `article-body` 之前，但是它表现得好像在之后一样。

<iframe src="https://codepen.io/tutsplus/embed/VjYvve/?height=500&amp;theme-id=12451&amp;default-tab=result" width="850" height="500" frameborder="no" allowfullscreen="true" scrolling="no"></iframe>

## <span class="sectionnum">6.</span> 使布局可响应

这就是我们想要的所有效果，虽然看起来有点破碎。让我们通过响应式来修复它。。

Flexbox 一个非常好的特性是：如果想让 Flexbox 完全失效，你仅仅只需要移除容器上的 `display: flex` 规则即可，其他的所有 Flexbox 属性（比如 `align-items` 或者 `flex`）完全可以保留。

这样一来，仅通过某一特定断点就能触发 “响应式” 布局。

我们将从 `.columns` 和 `.column` 上移除 `display: flex` ，而不是把它们放入  Media Query （响应式布局）中。

    @media screen and (min-width: 800px) {
      .columns,
      .column {
        display: flex;
      }
    }

这就是了！在更小的屏幕上，所有的文章都在另一篇文章的上面。超过 800px 时，它们将会排列成两列。

## <span class="sectionnum">7.</span> 添加一些结束的润色

为了让布局在更大屏设备适应，让我们对 CSS 做一些微调：

    @media screen and (min-width: 1000px) {
      .first-article {
        flex-direction: row;
      }

      .first-article .article-body {
        flex: 1;
      }

      .first-article .article-image {
        height: 300px;
        order: 2;
        padding-top: 0;
        width: 400px;
      }

      .main-column {
        flex: 3;
      }

      .nested-column {
        flex: 2;
      }
    }

第一篇文章的内容是横向布局的，其中文字在左边，图片在右边。同样，主列更宽（ 75% ），嵌套列也是 （ 66% ）。这就是最终效果了！

<iframe src="https://codepen.io/tutsplus/embed/Wxbvdp/?height=500&amp;theme-id=12451&amp;default-tab=result" width="850" height="500" frameborder="no" allowfullscreen="true" scrolling="no"></iframe>

## 结论

我希望我已经展示给你了：在你刚接触 Flexbox 的时候没有必要理解关于 Flexbox 的所有方面。这个可响应的新闻布局是一个非常有用的模版；拆解并且尝试一下，看看你掌握了多少！

