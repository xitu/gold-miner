> * 原文地址：[How to Create Charts from External Data Sources with D3.js](https://blog.bitsrc.io/how-to-create-charts-from-external-data-sources-with-d3-js-4abbcb574706)
> * 原文作者：[Shaumik Daityari](https://medium.com/@ds_mik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-charts-from-external-data-sources-with-d3-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-create-charts-from-external-data-sources-with-d3-js.md)
> * 译者：[Alfxjx](https://github.com/Alfxjx)
> * 校对者：[qq1037305420](https://github.com/qq1037305420)

# 如何基于 D3.js 使用外部数据源创建图表

![](https://cdn-images-1.medium.com/max/12032/1*_2y7jPirLNtPHduWzlgphQ.jpeg)

福布斯于 2018 年年中的统计显示，人类[每天约产生 2.5EB](https://www.forbes.com/sites/bernardmarr/2018/05/21/how-much-data-do-we-create-every-day-the-mind-blowing-stats-everyone-should-read/) 的数据。随着对如此海量数据的机器学习算法的研究，强大的可视化技术有助于将所见以一个正确的方式呈现出来。数据可视化还可以帮助读者更快地处理数据并记住数据的关键特征。在过去的十年中，对可视化专家的需求也在增加。

D3 是一个运行于 web 端的 Javascript 可视化库。D3 的第一个版本发布于 2011 年，并且随着社区支持的增加而成熟。对于早期版本的 D3，学习曲线有些陡峭，但对于 JavaScript 初学者来说，最新版本学习起来更容易。大多数为 Web 构建的可视化都依赖于动态数据源 —— 因此，本文的目的是使您能够在 D3 中使用外部数据源创建图表。

## D3 中的柱状图

在 D3 中加载外部数据之前，让我们创建一个基本的柱状图，并在加载外部数据后，重新绘制该柱状图。首先，通过下面的一行代码来加载 D3 脚本。

```html
<script src="https://d3js.org/d3.v5.min.js"></script>
```

你可能会发现，网络上的绝大部分的 D3 教程都是基于 v3 或者是 v4 版本的。但是本文中我们会使用在 2018 年的早期发布的 v5 版本的 D3 库。[最新版本的 D3 库](https://github.com/d3/d3/releases/tag/v5.12.0)大概是一个月前发布的（译注：最新版本的 D3 发布于 2019 年的 9 月）。

[D3.js 的 changelog](https://github.com/d3/d3/blob/master/CHANGES.md#selections-d3-selection) 记录了版本之间的改动。就本文而言，需要注意 v4 与 v5 的加载方式不同。

首先让我们定义标题和数据。

```js
var title = "Comments on Posts",
  data = [{type: "Post A", amount: 4},
         {type: "Post B", amount: 2},
         {type: "Post C", amount: 7},
         {type: "Post D", amount: 5},
         {type: "Post E", amount: 6}]
;
```

在引入 D3 的脚本库之后，你可以使用全局变量 `d3` 来进行任意的有关 D3 库的操作。接着，通过将一个标题元素追加到 `body` 标签中，从而给图标添加了一个标题。如果你是在某一个确定的 `div` 标签之中创建图表的话，可在创建标题的元素之前选中该元素。另外，如果你知道标题将会保持不变，那么应该不使用 D3 而是在页面加载的时候就将其添加进来。

```js
d3.select("body")
  .append("h3")
  .text(title);
```

在继续操作之前，先添加一些自定义CSS。

```css
body {
  background-color: #3c3c3c;
  color: #cfcfcf;
}

div {
  line-height: 15px;
  margin-bottom: 3px;
  background-color: grey;
}
```

此时，页面上出现了标题。你可以在样式表中为此标题定义自定义样式。接下来，在保持宽度一定的情况下，根据数据的大小设置水平柱状图的长度，创建水平柱状图。

```js
d3.select("body")
  .selectAll("div")
  .data(data)
  .enter()
  .append("div")
  .style("width", function(d) { return d.amount * 40 + "px"; })
  .style("height", "15px");
```

这样一来你的简单柱状图就设置完成了。你可以在 [CodePen](https://codepen.io/shaumik/pen/RwwNLQb) 上查看它。若是需要再向柱状条添加标签，可以遍历数据源从而给与之对应柱状条的 `div` 元素再添加一个文本元素。

现在让我们尝试使用外部文件源。

## 从外部数据源加载数据

如果数据与网页大小（平均约 2 MB），相比足够大，那么如果您声明此数据为内联，可能会通过增加加载时间而带来不便。因此，将其保存在文件中是一个好习惯。CSV（逗号分隔值）文件中的数据结构如下所示。

我们用于创建柱状图的外部数据已经[上传到 Github](https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv)，CSV（逗号分隔值）文件以逗号分隔保存的数据。文件的内容如下所示：

```
type,amount
Post A,4
Post B,2
Post C,7
Post D,5
Post E,6
```

在 D3 中读取 CSV 文件，可以使用 `csv()` 方法。除此之外我们还使用了 `d3.autoType` 解析函数来将文件中的行数据转换成了 JavaScript 的对象。[这个文档](https://github.com/d3/d3-dsv/blob/master/README.md#autoType)列举了诸如将空值转换成 `null` 等之类的转换规则。你可以在加载完成之后的 `then()` 方法中用控制台打印的方式来观察转换之后的对象。

```js
d3.csv('https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv',
  d3.autoType)
  .then(function (data) {
    console.log(data)
  });
```

下面展示的是在 Chrome 开发者工具的控制台中显示的转换之后的 Javascript 对象。

```
(5) [{…}, {…}, {…}, {…}, {…}, columns: Array(2)]
0: {type: "Post A", amount: 4}
1: {type: "Post B", amount: 2}
2: {type: "Post C", amount: 7}
3:
  amount: 5
  type: "Post D"
  __proto__: Object
4: {type: "Post E", amount: 6}
columns: Array(2)
  0: "type"
  1: "amount"
  length: 2
  __proto__: Array(0)
  length: 5
__proto__: Array(0)
```

存在类似的功能来加载其他类型的外部文件。要加载文本文件，请使用以下代码：

```js
d3.text("/path/to/file.txt").then(function(text) {
  // do something
});
```

如果您的文件由其他分隔符分隔，则可以使用 `dsv()` 函数。唯一的区别是第一个参数，用于表明文件的分隔符。您也可以使用 `dsv()` 函数并使用逗号作为分隔符参数来加载 CSV 文件。

```js
d3.dsv(',', 'https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv',
  d3.autoType)
  .then(function (data) {
    console.log(data)
  });
```

另外，以下的几个方法也是可选择的：

* `json()`: to load a file containing data in JSON format
* `xml()`: to load a file containing XML data
* `image()`: to load an image
* `svg()`: to load vector graphics

## 使用外部数据源创建图表

现在您已经成功地从外部源加载了数据，让我们创建图表。

```js
d3.csv('https://raw.githubusercontent.com/sdaityari/my_git_project/master/posts.csv', d3.autoType).then(function (data) {
  d3.select("body")
    .selectAll("div")
    .data(data)
    .enter()
    .append("div")
    .style("width", function(d) { return d.amount * 40 + "px"; })
    .style("height", "15px");
});
```

与前一个函数的唯一区别在于，需要在 `csv()` 函数中进行 `data()` 调用。由于列名相同，因此其余代码保持不变。

利用外部数据绘制的相同柱状图可以在 [CodePen](https://codepen.io/shaumik/pen/mGWRzm) 查看。

## 实时数据

D3的一个优点是可以通过在触发事件后更改包含图表的元素来实时更新图表。 更新图表的流程如下：

* 捕获到事件的触发，并调用函数；
* 覆盖或更新现有数据；
* 刷新包含图表的可视元素；

这里是使用 Python 和 Websockets 描述的整个过程的[示例](https://medium.com/@benjaminmbrown/real-time-data-visualization-with-d3-crossfilter-and-websockets-in-python-tutorial-dba5255e7f0e)。

## 最后的思考

这样，我们就完成了使用 D3 从外部数据源创建图表的教程。我们首先使用 D3 创建了一个简单的柱状图，探索了从外部数据源读取数据的各种方法，最后，使用新加载的数据创建了一个图表。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
