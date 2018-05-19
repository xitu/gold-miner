> * 原文地址：[The most uncommon HTML5 tags you can use right now](https://codeburst.io/the-most-uncommon-html5-tags-52273fabc0a7)
> * 原文作者：[Pedro M. S. Duarte](https://codeburst.io/@pedromsduarte?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-most-uncommon-html5-tags.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-most-uncommon-html5-tags.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[sophiayang1997](https://github.com/sophiayang1997)

# 可用但最不常见的 HTML5 标签

`<!DOCTYPE html>` 于 2014 年 10 月由万维网联盟（W3C）发布，旨在通过改进 HTML 语言来支持最新的多媒体设备，在保证计算机与设备（如 Web 浏览器，解析器等）可解析的前提下增强对人类的可读性。

![](https://cdn-images-1.medium.com/max/800/1*V91sgvnersFg5tXuhjVl8A.png)

[http://www.geekchamp.com](http://www.geekchamp.com/html5-tutorials/introduction)

我可以确定你们都已经在使用 HTML5 做网页了，并且会使用一些常见的标签，如 `<header>`、`<section>`、`<article>` 和 `<footer>` 等等，除此之外，还有一些不常用的标签是有助于正确使用 HTML5 的语义化开发。

在此我将其中一些最重要的标签列出来，希望能帮助你遵循 HTML5 语义进行开发。

#### `<details>`

`<details>` 标签指定了用户可以按需查看或隐藏的内容，可以用它来创建能被用户关闭与打开的小工具。在语义上，你可以在其中使用任何类型的内容，不过如果没有对它设置 open 属性，内容将不可见。

`<details open><p>在预定时需要信用卡</p></details>`

#### `<dialog>`

`<dialog>` 定义了一个对话框元素或窗口。

`<dialog open><p>欢迎来到我们的酒店</p></dialog>`

#### `<mark>`

`<mark>` 标签定义了被标记的文本，可以用于将你文本中的一部分高亮。

`<p>在<mark>预定</mark>时需要信用卡</p>`

#### `<summary>`

`<summary>` 标签为 `<details>` 定义了一个可见的标题。点击这个标题可以显示或隐藏  `<details>` 内容。

`<details><summary>支付条件</summary><p>在预定时需要信用卡</p></details>`

#### `<time>` 与 `<datetime>`

`<time>` 标签定义了一个人类可读的日期或者时间。这个元素还能用以机器可读的方式对日期或时间进行编码，以便用户的工具或软件将生日提醒、计划事件之类的时间添加到用户的日历中。此外，还能让搜索引擎产生更智能的搜索结果。

`<p>自助早餐于 <time>7.00 AM</time> 在餐厅开始</p>`

`<p><time datetime="2018-06-20T19:00">6 月 20 日晚上 7 点</time>在大厅举行音乐会</p>`

#### `<small>`

`<small>` 标签的规范解释，这个标签可以用于降低文本或信息的重要性。浏览器将通过缩小字体以减少视觉影响。

`<p>取消预定必须提前 48 小时，<small>以免每房每夜的额外扣款</small></p>`

#### `<datalist>`

你可以用 `<datalist>` 元素来定义 `<input>` 标签中用于有效选择的列表。这个组件在各个浏览器中的样子略有不同，但相同的是在字段右边显示一个小下拉箭头，提示此字段可以进行选择。[点这儿](https://codepen.io/pedromsduarte/pen/GxdNaB)查看效果。

`<datalist><option value="Master Card"><option value="Visa"><option value="American Express"></datalist>`

#### `<progress>`

`<progress>` HTML 元素会显示一个指示器，用于显示某个任务的完成进度，通常显示为进度条。

`<progress value="70" max="100">70 %</progress>`


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
