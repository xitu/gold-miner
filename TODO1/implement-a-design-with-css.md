> * 原文地址：[Implementing a Mockup: CSS Layout Step by Step](https://daveceddia.com/implement-a-design-with-css/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/implement-a-design-with-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/implement-a-design-with-css.md)
> * 译者：[Baddyo](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[cyz980908](https://github.com/cyz980908)，[Moonliujk](https://github.com/Moonliujk)

# 从原型图到成品：步步深入 CSS 布局

![用 CSS 将原型实现](https://daveceddia.com/images/css-layout-header.png)

对很多人来说，创建布局是前端开发领域中最难啃的骨头之一。

你肯定经历过耗费数个小时，换着花样地尝试所有可能起作用的 CSS 属性、一遍遍地从 Stack Overflow 上复制粘贴代码，寄希望于误打误撞地赌中那个能实现预期效果的**魔幻组合**。

如果你的惯用策略就是按部就班地组合布局 —— 先把 A 元素放在这儿，好了，A 元素就位了，我再看怎么把 B 放在那儿 …… 那你没有挫败感才怪呢。CSS 的玩法可与 SKetch 或者 Photoshop 的玩法不一样。

在本文中，我将向你展示如何以统筹全局的思维实现 CSS 布局，根治布局难产的顽疾。

我们将用一个小案例贯穿全文，我会把所有的 CSS 代码都解释给你听，因此即使你不知道或者忘记了 `position` 和 `display` 的用法，即使你分不清 `align-items` 和 `justify-content` 的区别，你仍会有所斩获。

而且我们会用纯 HTML 和 CSS 代码来演示，因此你不需要 React、Vue、Angular、CSS-in-JS 甚至是 JavaScript 方面的知识储备。

听起来很棒吧？那就开始吧。

## 布局小例子

在本文中，我们要比照 Twitter 的推文组件自己仿写一个：

![推文组件的草图](https://daveceddia.com/images/tweet-sketch.jpg)

不论是一个像这样的草图，还是一个细节精美的原型图，“有章可循” 总是个好主意。

要避免一边在脑海里设计，一边在浏览器中七拼八凑地攒布局，这样的开发过程才会更顺畅。你当然**可以**达到那种手脑合一的境界！但鉴于你还在乖乖地读这篇文章，我可以假设你**还没有**那么神通广大。:)

## 第一步：分而治之

在动手敲代码之前，我们先把布局的各个单元区分开来：

![划分推文组件的各个单元](https://daveceddia.com/images/tweet-highlighted.jpg)

在用 CSS 铺排布局时，用行和列的形式去构思大有裨益。因此，要么你把元素从上到下排列，要么从左到右排列。这种行和列的思路完美对应了 CSS 中两种布局技术：Flexbox 和 Grid。

当然了，我们的示例布局并不是中规中矩的行列。它有一张图片镶嵌在左侧，其他元素排列在右侧。

## 第二步：沿着各个单元画方框

画一些方框把这些元素框起来，看看行和列是否初具规模。我们把方向一致的单元归到同一个方框中。

![将推文组件的不同单元框起来](https://daveceddia.com/images/tweet-first-level-layout-boxes.jpg)

在页面中的 HTML 元素基本上都可视为矩形。当然，有些元素有圆角，有些元素是圆形，或者是复杂的 SVG 形状等。通常你**看不到**页面上有一堆矩形。但你可以用矩形边框的模式去分析它们。这样的想象能帮你理解布局。

之所以提到矩形，是因为你要把一系列元素对齐 —— 如第一行的用户名、@handle（译者注：handle 属于专有名词，指 Twitter 中的用户 ID，所以在本文中保留不译。详见 [https://www.urbandictionary.com/define.php?term=twitter%20handle](https://www.urbandictionary.com/define.php?term=twitter%20handle)）和时间以及最后一行的图标 —— 把它们用方框包起来便于规划。

按目前的规划，把布局用 HTML 代码实现出来大概如下所示：

```html
<article>
  <img
    src="http://www.gravatar.com/avatar"
    alt="Name"
  />
  <div>
    <span>@handle</span>
    <span>Name</span>
    <span>3h ago</span>
  </div>
  <p>
    Some insightful message.
  </p>
  <ul>
    <li><button>Reply</button></li>
    <li><button>Retweet</button></li>
    <li><button>Like</button></li>
    <li><button>...</button></li>
  </ul>
</article>
```

展示出的效果是这样的（可以点击[这里](https://codesandbox.io/embed/wo6wvvynlw)调试代码）：

![推文组件的默认样式](https://daveceddia.com/images/tweet-default-layout.png)

这离我们想要的效果还远呢。但是！所有所需的内容都齐全了。有些元素还以从左到右的顺序排列。

我们可以认为，即使不用进一步设置样式，目前的布局效果也能达到网页想表达的要点，这也是一个优秀的 HTML 应该达到检查标准。

### 关于语义化 HTML 的说明

你可能会好奇，为何我选的是那些元素 —— `article`、`p` 等等。为何不都用 `div` 呢？

为何要这样写：

```html
<article>
  <img ... />
  <div>
    <span/>
    <span/>
    <span/>
  </div>
  <p> ... </p>
  <ul>
    <li>
      <button> ... </button>
    </li>
  </ul>
</article>
```

而不这样写？

```html
<div>
  <img ... />
  <div>
    <div/>
    <div/>
    <div/>
  </div>
  <div> ... </div>
  <div>
    <button> ... </button>
  </div>
</div>
```

其实，每个 HTML 元素的名称都有其特定含义，在不同场景中恰如其分地使用语义上与它们所表示的内容匹配的元素，是很好的语义化实践。

这种写法，首先，有助于开发者理解代码；其次，对使用屏幕阅读器等辅助设备的用户比较友好。同时这样用标签也有利于 SEO —— 搜索引擎会试着理解这个页面的含义，以便于显示相关广告来盈利、帮助搜索者找到满意结果。

`article` 标签代表文章类内容，而你可以认为推文这种东西有点类似于一篇文章。

`p` 标签代表段落，而推文的内容文本有点类似于一个段落。

`ul` 标签代表无序列表（与有序列表或数字序号列表相对应），在本示例中，你可以用它来存放列表信息。

我们无法用只言片语就说清楚 HTML 元素的语义，以及何种情况用何种标签。但大多数情况下，一个语义化元素即使其语义再不贴切，也比用 `div` 强，`div` 标签只代表 “一块区域”。

### 元素的默认样式

是什么决定了元素的样式？为什么有的元素独占一行，而有的元素能共处一行？

![默认样式下的推文组件](https://daveceddia.com/images/tweet-default-layout.png)

这要归因于元素的**默认样式**，这其中就有我们要探讨的第一个 CSS 知识点：**行内元素**和**块级元素**。

**行内元素**们肩并肩挤在一行里（就像句子中的词一样，必要时会折行）。根据再浏览器中的默认样式划分，`span`、`button` 以及 `img` 都是行内元素。

而**块级元素**，总是踽踽独行。以控制台输出的方式去理解，你可以认为块级元素前后各有一个换行符 `\n`。就好像`console.log("\ndiv\n")`。`article`、`div`、`li`、`ul` 以及 `p` 标签都是块级元素。

注意，在上面的例子中，为什么即使 `img` 标签是行内元素，头像图片依然独占一行？因为它下方的 `div` 是块级元素。

然后要注意，为什么 @handle、用户名和时间都在同一行？原因是它们都在 `span` 标签中，而 `span` 是行内元素。

这三个 `span` 和 文字 “insightful message” 处于不同行，因为（a）它们被包在一个 `div` 中，`div` 后面自然要另起一行；（b）`p` 标签同样是块级元素，它自然从新行开始排列。（之所有没有出现两个空行，是因为 HTML 合并了相邻的空行，与相邻空格同理。）

如果你再看得仔细点，你会发现 “insightful message” 的上下方空间，要比头像图片以及 handle、用户名、时间的上下方空间要大。此空间的大小也由默认样式控制：`p` 标签的顶部和底部都有 **margin**。

你也会注意到按钮列表的圆点，以及列表的缩进行为。这些也都是默认样式。我们马上就要修改这些默认样式了。

## 第三步：再画一些方框

我们想把头像图片放在左侧，其余元素放在右侧。你可能会根据刚刚探讨的行内和块级知识来推断，认为只要把右侧的元素都包裹到一个如 `span` 标签般的行内元素中，就完事大吉了。

但这是行不通的。行内元素并不能阻止其内部的块级元素另起一行。

为了把这些元素收拾得服服帖帖，我们需要用一些更强大的技术，比如 Flexbox 或者 Grid 布局。这次我们选用 Flexbox 来解决。

### Flexbox 的原理

CSS 的 Flex 布局能够把元素以行**或者**列的形式排布。这是一种单向的布局系统。为了实现交叉的行和列（正如推文组件的设计那样），我们需要添加一些容器元素来扭转方向。

![每一层布局都用方框包围](https://daveceddia.com/images/tweet-all-layout-boxes.jpg)

你可以在容器上设置 `display: flex;` 来启用 Flex 布局。容器本身是块级元素（得以独占一行），其内部元素会成为 “Flex 子项” —— 即它们不再是行内或块级元素了；它们都受 Flex 容器控制。

在本例中，我们会设置一些嵌套的 Flex 容器，让该成行的成行，该成列的成列。

我们把外层容器（绿色方框）设置为列，蓝色方框设置为行，而红色方框中的元素排布在列中。

![箭头方向即为 Flex 布局方向](https://daveceddia.com/images/tweet-layout-arrows.jpg)

### 为何选 Flexbox 布局，不选 Grid 布局？

由于一些原因，我决定用 Flexbox 布局而不用 Grid 布局。我觉得 Flexbox 布局更易于学习，也更适用于轻量级的布局。当布局中**主要是行**或者**主要是列**时，Flexbox 布局的表现更出色。

另一个重点就是，即使 Grid 布局比 Flexbox 布局年轻，前者也撼动不了后者的地位。它们各自适用于不同的场景，对于二者，我们都要学习，技不压身。有些情况你甚至会同时使用二者 —— 例如 Grid 布局排布整体页面，而 Flexbox 布局调控页面中的一个表单。

没错没错，在 Web 开发的世界，普遍的更替法则是后浪推前浪，但 CSS 并不如此。Flexbox 和 Grid 能够和谐共存。

用 CSS 解决问题，条条大路通罗马！

### 第四步：应用 Flexbox

好了，既然我们已经打定主意，那就开动吧。我把左侧元素包进一个 `div`，并给元素们设置类名，便于应用 CSS 选择器。

```html
<article class="tweet">
  <img
    class="avatar"
    src="http://www.gravatar.com/avatar"
    alt="Name"
  />
  <div class="content">
    <div class="author-meta">
      <span class="handle">@handle</span>
      <span class="name">Name</span>
      <span class="time">3h ago</span>
    </div>
    <p>
      Some insightful message.
    </p>
    <ul class="actions">
      <li><button>Reply</button></li>
      <li><button>Retweet</button></li>
      <li><button>Like</button></li>
      <li><button>...</button></li>
    </ul>
  </div>
</article>
```

（[代码在这里](https://codesandbox.io/s/0y98qov0rn)）

看着好像没有变化。

![默认样式下的推文组件](https://daveceddia.com/images/tweet-default-layout.png)

这是因为 `div` 作为块级元素（如果没有空行就引入一个）是看不见的。当你需要一个包裹其他元素的容器，除了 `div` 之外没有更贴合语义的选择了。

下面咱们的第一段 CSS 代码，我们会把它放在 HTML 文档中 `head` 标签的 `style` 里：

```css
.tweet {
  display: flex;
}
```

干得漂亮！我们用**类选择器**锁定了**所有**类名为 `tweet` 的元素。当然目前只有一个这样的元素，但如果有十个，那它们将都会是 Flex 容器了。

CSS 中以 `.` 开头的选择器代表类选择器。为什么是 `.`？我可不知道。你只要记住这条规则就行了。

![设置了 display:flex](https://daveceddia.com/images/tweet-display-flex.png)

现在文字内容都到头像右侧去了。问题是头像图片都扭曲变形了。

因为 Flex 容器会默认：

* 把子项排成一行；
* 让子项与其内容等宽，并 ——
* 把所有子项的高度拉平为最高子项的高度。

我们可以用 `align-items` 属性来控制垂直方向的对齐方式。

```css
.tweet {
  display: flex;
  align-items: flex-start;
}
```

`align-items` 的默认值是 `stretch`，而将其设为 `flex-start` 后，会让子项沿着容器顶部对齐，**并且**让子项保持各自的高度。

### 方向的辩证：行还是列？

另外，Flex 容器的默认排列方向是 `flex-direction: row;`。是的，这个方向是 “行”，即使我们可能感觉那更像是两列。要把它想成是子项们排成一**行**，这样理解就舒服多了。

有点像这张花瓶的图片，或者说两张脸的图片。横看成岭侧成峰。

![Rubin 的花瓶](https://daveceddia.com/images/Rubins-vase.jpg)

[Wikipedia](https://en.wikipedia.org/wiki/Rubin_vase)

### 给文字内容更多的空间

Flex 布局的子项仅取其所需宽度，但我们需要 `content` 区域尽量宽敞一些。

因此，我们要给 `content` 这个 div 设置 `flex: 1;` 属性。（该 div 有类名，那我们就又可以用类选择器啦！）

```css
.content {
  flex: 1;
}
```

我们也要给头像设置 `margin`，好在头像和文字之间加点空隙：

```css
.avatar {
  margin-right: 10px;
}
```

![设置了 display:flex](https://daveceddia.com/images/tweet-with-avatar-margin.png)

看起来顺眼一些了吧！

### margin 和 padding

那…… 为什么用 `margin` 而不用 `padding`？为什么要设置在头像右侧，而不是文字内容左侧呢？

这是一条约定俗成的规则：在元素右侧和下方设置 margin，不去碰左侧和上方的 margin。

至少是在英文界面的布局中，文档流的方向是从左到右、从上到下的，因此，每个元素都 “依赖” 其左侧和上方的元素。

在 CSS 中，每个元素的定位都受到其左侧和上方的元素的影响。（至少在你遇见 `position: absolute` 那帮家伙之前是这样的。）

### [SoC 原则（Separation of Concerns）](https://www.cnblogs.com/wenhongyu/archive/2017/12/06/7992028.html)

从技术实现的角度来说，怎样设置 `avatar` 和 `content` 之间的空隙都一样。该是多宽就是多宽，没有 `border` 的干扰（`padding` 在 `border` 的内侧；而 `margin` 在外侧）。

但当事关可维护性、对元素的全局观时，这就有区别了。

我曾尝试把元素理解为一个个独立个体，就像每个 JavaScript 函数只实现单一功能一样：如果它们都仅仅扮演单一的角色，那么写起代码来就很容易，报错时调试也很容易。

如果我们把 margin 设置到 `content` 的左侧，后来有一天我们去掉了 `avatar`，可是以前的缝隙还留在那。我们还得排查导致额外空间的原因（是来自 `tweet` 容器吗？ 还是来自 `content` 呢？）并把它处理掉。

或者，如果 `content` 设置了左侧的 margin，而我们想要把 `content` 替换成别的元素，我们还要记着再**把之前那个空隙补上**。

好了好了，为了 10 像素的事，没必要费这么多口舌，干脆就把 margin 设在头像的右侧和下方。让我们继续埋头敲代码吧。

### 移除列表的样式

无序列表 `ul` 和其中的列表项 `li` 在左侧窝藏了很大空间，还有一些圆点。这都不是我们想要的效果。

我们可以把无序列表左侧的空隙都清除掉。我们还要把它变成一个 Flex 容器，这样里面的按钮就能排成一行了（用 `flex-direction: row`）。

列表项有个属性是 `list-style-type`，默认值为 `disc`，使得每个列表项以圆点开头，我们用 `list-style: none;` （`list-style` 是一个**缩写属性**，整合了几个其他属性，其中就包括 `list-style-type`）将该效果关闭。

```css
.actions {
  display: flex;
  padding: 0;
}
.actions li {
  list-style: none;
}
```

![按钮排成一排](https://daveceddia.com/images/tweet-actions-display-flex.png)

`.actions` 又是一个类选择器。原汁原味。

而 `.actions li` 选择器，意即 “`actions` 类元素中所有的 `li` 元素”。它是类选择器和元素选择器的结合。

复合选择器中用以分隔的空格代表着**选择范围的缩小**。事实上，CSS 是以倒序读取选择器的。其过程是 “先找到页面中所有的 `li`，然后在这些 `li` 中找到类名是 `actions` 的那些”。但无论你用正序还是倒序的方式去理解，结果都是一样的。（在 [StackOverflow](https://stackoverflow.com/questions/5797014/why-do-browsers-match-css-selectors-from-right-to-left) 查看更多详解）

### 横排按钮

要横排按钮有好几种方式。

一种就是设置 Flex 子项的对齐方式。你应该对设置对齐方式很熟悉，每个富文本编辑器顶部都有这种功能的按钮：

![对齐按钮：左对齐/居中对齐/右对齐/两端对齐](https://daveceddia.com/images/justify-buttons.png)

它们把文本进行左对齐、居中对齐、右对齐以及 “两端对齐”，也就是铺满整行。

在 Flexbox 布局中，你可以用 `justify-content` 属性来实现对齐。设置了 `flex-direction: row`（默认值，也是本文中一直在用的设置）后，可以通过 `justify-content` 把子项进行或左或右地对齐。`justify-content` 的默认值为 `flex-start`（因此所有元素都向左看齐）。如果我们给 `.actions` 元素设置 `justify-content: space-between`，它们就会均匀地铺满整行，就像这样：

![按钮对齐：justify-content:space-between](https://daveceddia.com/images/tweet-justify-content-space-between.png)

可我们想要的不是这样的效果。如果这几个按钮可以不占满整行会更好。所以得换一种方式。

这次，我们给每个列表项设置一个右侧的 margin，把它们分隔开来。还要给整个推文组件设置一个边框，以便我们能够直观地衡量效果。用 `1px solid #ccc` 设置一个 1 像素宽的灰色实线边框。

```css
.tweet {
  display: flex;
  align-items: flex-start;
  border: 1px solid #ccc;
}
.actions li {
  list-style: none;
  margin-right: 30px;
}
```

现在效果如下：

![组件带边框，按钮分隔排列](https://daveceddia.com/images/tweet-bordered-buttons-spaced.png)

按钮的排列看起来优雅多了，但灰色边框告诉我们，所有元素都过于靠左了。还是用 `padding` 分配点空间吧。

```css
.tweet {
  display: flex;
  align-items: flex-start;
  border: 1px solid #ccc;
  padding: 10px;
}
```

现在推文组件有内边距了，但有些地方还是很空。如果我们用浏览器调试工具将元素高亮显示，就会发现 `p` 和 `ul` 元素有默认的上下 margin（在 Chrome 的调试工具中，margin 以橙色显示，而 padding 以绿色显示）：

![p 和 ul 周围的间隔](https://daveceddia.com/images/tweet-showing-padding.gif)

还有一处有意思的细节；**行与行之间**的上下 margin 是等距的 —— 并没有叠加出双倍间距！因为 CSS 在竖直方向上有 **margin 坍塌**现象。当上下两个 margin 短兵相接时，数值大的 margin 会 “吃掉” 小的。详情参见 [CSS 技巧：margin 坍塌](https://css-tricks.com/what-you-should-know-about-collapsing-margins/)。

对于本例的布局，我会手动调整 `.author-meta`、`p` 和 `ul` 的右侧 margin。如果要真刀真枪地开发网站，建议你考虑用 [CSS reset](https://bitsofco.de/a-look-at-css-resets-in-2018/) 作为开发基础，有利于跨浏览器兼容。

```css
p, ul {
  margin: 0;
}
.author-meta, p {
  margin-bottom: 1em;
}
```

用 `,` 将选择器隔开，可以一次性把样式应用到多个选择器上。因此 `p , ul` 的含义就是 “所有的 `p` 元素，以及所有的 `ul` 元素”。亦即二者的合集。

在这里我们使用了新的尺寸单位，`1em` 中的 `em`。一个单位的 `em` 等于 `body` 标签上的以像素为单位的字号大小。`body` 标签的默认字号为 `16px`（16 像素高），所以本例中的 `1em` 相当于 `16px`。`em` 随字号改变而改变，因此可以用 `1em` 来表达 “我想让文字下方的 margin 和文字的高度一样，不论文字高度是多少”。

现在的效果如下：

![设置 margin](https://daveceddia.com/images/tweet-margins-fixed.png)

现在让我们把图片缩小一些，并将其设置为圆形。我们将其宽高设置为 48 像素，正和 Twitter 的头像宽高一样。

```css
.avatar {
  margin-right: 10px;
  width: 48px;
  border-radius: 50%;
}
```

我们用 `border-radius` 属性来设置圆角，有好几种方式来定义该属性的值。如果你想要小圆角效果，可以用带 `px`、`em` 或其他单位名称的数字赋值。例如 `border-radius: 5px` 的效果：

![圆角半径为 5 像素的头像](https://daveceddia.com/images/border-radius-5px.png)

如果将 `border-radius` 设为宽和高的一半（在本例中即为 24 像素），其效果就是一个圆形。但更方便的写法是 `border-radius:50%`，这样我们就不必知道具体尺寸，CSS 会计算出确切结果。甚至，如果以后宽高值变了，也无需重新修改属性值了！

![圆形头像](https://daveceddia.com/images/tweet-round-avatar.png)

## 再接再厉

眼下还有一些需要润色之处。

我们要把字体设为 Helvetica（Twitter 用的那一款）、把字号缩小一些、把用户名加粗，还有，翻转 “@handle 用户名 的顺序（在 HTML 代码中），使之与 Twitter 一模一样。:D

```css
.tweet {
  display: flex;
  align-items: flex-start;
  border: 1px solid #ccc;
  padding: 10px;
  /* 
    更改字体和字号。
    在 .tweet 选择器上设置的 CSS 效果，其所有子元素都会继承。
    （除了按钮。按钮不太合群）
  */
  font-family: Helvetica, Arial, sans-serif;
  font-size: 14px;
}

.name {
  font-weight: 600;
}

.handle,
.time {
  color: #657786;
}
```

`font-weight: 600;` 的效果等同于 `font-weight: bold;`。字体有很多不同程度的字重，范围是从 100 到 900（最淡到最浓）。`normal`（默认值）等价于 400。

**另外**，CSS 中的注释写法与 JavaScript 或其他语言不用，不允许以 `//` 开头。某些浏览器支持 `//` 风格的 CSS 注释，但并非所有浏览器都如此。用 C 语言风格的 `/* */` 包围注释内容即可高枕无忧。

还有一个小窍门：可以用 **伪元素**在 “handle” 与 “时间” 之间添加一个凸点。这个凸点符号单纯为了装饰，不具有具体语义，所以用 CSS 实现不会污染 HTML 语义结构。

```css
.handle::after {
  content: " \00b7";
}
```

`::after` 创建了一个伪元素，它位于 `.handle` 元素内部的最后方（“落后” 于元素的内容）。你还可以用 `::before` 创建伪元素。可以给 `content` 属性赋值任何文字内容，包括 Unicode 字符。你可以恣意发挥，像给任何其他元素设置样式一样。伪元素用来实现标记（badge）、消息提醒或其他小花样最合适不过了。

### 图标按钮

还有一项工作要做，那就是用图标替换按钮。我们要在 `head` 标签里添加 Font Awesome 图标字体：

```html
<link
  rel="stylesheet"
  href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
  integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf"
  crossorigin="anonymous"
/>
```

然后用下列代码替换原来的 `ul`，新列表中的每个按钮里有图标和隐藏文字：

```html
<ul class="actions">
  <li>
    <button>
      <i
        class="fas fa-reply"
        aria-hidden="true"
      ></i>
      <span class="sr-only">Reply</span>
    </button>
  </li>
  <li>
    <button>
      <i
        class="fas fa-retweet"
        aria-hidden="true"
      ></i>
      <span class="sr-only">Retweet</span>
    </button>
  </li>
  <li>
    <button>
      <i
        class="fas fa-heart"
        aria-hidden="true"
      ></i>
      <span class="sr-only">Like</span>
    </button>
  </li>
  <li>
    <button>
      <span aria-hidden="true">...</span>
      <span class="sr-only">More Actions</span>
    </button>
  </li>
</ul>
```

Font Awesome 是一款图标字体，它配合斜体标签 `i` 可以展示图标。正因为它是字体，那些可以用于文字的 CSS 属性（例如 `color` 和 `font-size`）都适用于图标字体。

我们在这儿做了些微调，来提升按钮的可访问性：

* 特性 `aria-hidden="true"` 使屏幕阅读器忽略此图标。
* `sr-only` 类是 Font Awesome 内置的类。它让元素在你眼前隐身，但屏幕阅读器能读取到它。

这里有一门由 Marcy Sutton 讲授的[关于图标按钮可访问性的免费 Egghead 课程](https://egghead.io/lessons/css-accessible-icon-buttons)。

现在我们将要给按钮添加一些样式 —— 移除边框、上色以及加大字号。还要设置 `cursor: pointer`，把鼠标光标变成 “手” 型，就像超链接的效果那样。最后，用 `.actions button:hover` 选择处于 hover 状态的按钮，把它们变成蓝色。

```css
.actions button {
  border: none;
  color: #657786;
  font-size: 16px;
  cursor: pointer;
}
.actions button:hover {
  color: #1da1f2;
}
```

下面就是推文组件光芒四射的最终效果：

![最终效果](https://daveceddia.com/images/tweet-finished-hover-button.png)

如果你想自己调试代码，到[沙箱](https://codesandbox.io/s/q88k8n337w)里来。

## 如何精进 CSS 水平

最能提高 CSS 水平的就是实践。

仿写你喜欢的网站。设计者和艺术家称其为 “临摹”。我写过一篇[用临摹的方法学 React](https://daveceddia.com/learn-react-with-copywork/)，其中的原则也适用于 CSS。

选一些有意思的、你觉得难度大的样式效果。用 HTML 和 CSS 临摹该效果。如果卡壳了，用浏览器的调试工具看看原网站的效果是如何实现的。“栽秧苗、腿跟上、抬头看看直不直。” :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
