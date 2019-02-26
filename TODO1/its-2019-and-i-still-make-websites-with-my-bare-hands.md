> * 原文地址：[It’s 2019 and I Still Make Websites with my Bare Hands](https://medium.com/@mattholt/its-2019-and-i-still-make-websites-with-my-bare-hands-73d4eec6b7)
> * 原文作者：[Matt Holt](https://medium.com/@mattholt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/its-2019-and-i-still-make-websites-with-my-bare-hands.md](https://github.com/xitu/gold-miner/blob/master/TODO1/its-2019-and-i-still-make-websites-with-my-bare-hands.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234)，[TUARAN](https://github.com/TUARAN)

# 已经 2019 年了，我依然赤手空拳制作网站

我完全不知道该怎样像现在那些酷小孩一样制作网站。

我所知道的是，我们的前端团队为新网站花费了一天的时间来搭建基础框架，然后，第二天我运行 `git pull`，下载了这些东西（在合并钩子之后）：

![](https://cdn-images-1.medium.com/max/1200/1*9YY47IfhbjQnKxW0AgKqWw.png)

![](https://cdn-images-1.medium.com/max/1200/1*Ppd2YF0XThfea1HJV-Jt8Q.png)

（我必须杀掉了计算文件体积的进程，因为它占用太多 CPU 资源了。）

它显示出了 **Hello world**，但是他们告诉我，它**有能力**做更多的事情！我想他们是想说它甚至可以让我为 [toasts](https://material.angularjs.org/latest/demo/toast) 敬酒了。

我认为，如果有一件事（一项技术），大多数的网站开发者，甚至并非从事计算机科学的人，在谈论到自己的网站的时候，都能或多或少说一点，那么这件事（技术） 一定是 frameworks 或者 hosted services（因为我不知道这些单词是什么，但它们也不在我的 CS 课程里），而且说实话，它们听起来都很**神奇**。我将他们描述的和我正在做的事情做了比较，我感觉我自己的知识真的非常匮乏。而他们在像 DevMountain 这样的代码学校，或者最新的在线课程里学习最热门的技术。

![](https://cdn-images-1.medium.com/max/1200/1*jRlmvu9hgYO-uEIMmEyBag.png)

无论如何，看来我已经是“老学派”了，尽管我从事网络开发只有差不多 10 年。

**仅仅靠自己的双手搭建代码**

19 年了。就像当初 `<FONT>` 标签[是正确的方法](https://www.amazon.com/Teach-Yourself-HTML-VISUALLY-Visually/dp/0764534238)。（我...11 岁的时候，教会我 HTML 的那本有趣的书的链接）

然后就发生了下面的事，由于他们知道了我有多年网络开发的经验，有人就来请求我的帮助。随后我就知道了我对现在的情况已经一无所知，所以我就在谷歌搜索了 React 的双向数据绑定和 SCSS 的动态变量，还有其他那些我不知道的东西，但是他们却没有得到和我相同的理解，因为他们本该看到答案的时候就完全明白了，然而我本应该什么都不懂，只能询问“这个怎么样？”，但是其实他们找不到我给出的答案。

因为我会对这些框架感到无能为力，迟早我就必须开始询问他们：“啊，请等等，这个是做什么的？”**指着那段我以为是函数调用的代码...额，哦不，这是一个类型定义，这就尴尬了**！他们的回答通常也是很不让人不满意（答案都比较浅薄），所以我就更努力的钻研更多知识，好帮他们调试应用：

> “但是这部分是如何工作的呢？比如说，它实际上是在做什么？”我问道

> 我通常得到的都是一段无言的凝视。他们几乎全都不知道。

所以我就处于了这样的境地，已经 2019 年了，我已经写了近 20 年的代码，我周围的人的薪资都是我的 2-10 倍（但是我还是个学生）但是他们却不知道如何解释他们自己的代码是如何运作的。所以我认为，那其实并不是他们自己完成的代码。就像我并不知道我的车是如何工作的，但是我依旧可以每天都驾驶它。

但是，在你不知道工作原理的情况下，你要如何构建应用程序呢？

为什么一个需要展示几个列表，发送几个 AJAX 请求的网络应用需要超过 500M 的文件呢？（没错，我依然这样称呼它们。我也把它们称为 XHR，尽管 XML 已经很过时了。）

为什么很多网站要破坏我的返回按钮或者滚动条？就像是，**你必须自己努力来**实现它们。

为什么打包一个有 5 个路由的网站应用需要花费时间是我的 25000 行代码的 Go 程序**交叉-编译**时间的十倍？

### Papa Parse 是怎么变的越来越重了

在 2013 年，我在飞往迪士尼的航班上写了一个 CSV 解析器。我的浏览器需要一个快速准确的 CSV 解析器，但是已有的都不符合我的要求。所以我自己写了一个，这就是 [Papa Parse](https://www.papaparse.com/)，现在被很多知名的用户使用 —— 从联合国到各地的公司和组织，甚至是 Wikipedia —— 我很为它而骄傲（有点不谦虚的说，按理说它是服务于 JavaScript 的[最好 CSV 解析器](https://mwholt.blogspot.com/2014/11/papa-parse-4-fastest-csv-parser.html)）。最开始它就是个很简单的库，运行也非常好。

然后有需求需要它兼容老版本的浏览器，所以我加上了 shims，嗯，也还好吧。

然后有需求希望可以在 Node 上使用它。

接下来，不止是需求，还有**问题反馈** —— 它在 `<insert JavaScript framework here>` 的时候无法正常运行。这就有点让人发狂了：添加对一个框架或者工具链的支持，就会让其他的失灵。Papa Parse 从只有几百行代码增加到几千行。**这已经是不同的数量级了**。从只有一个文件，到大概有十几个。从不需要构建，到大概 3 到 4 个系统构建以及分布式打包。

所有都是为了浏览器中 `Papa.parse("csv,file")` 的丰富功能。

我最终放弃了它的维护，交给了社区中的其他人。他们非常好的完成了维护工作。它的功能远远超出了我所能支持的。在此之前，我在我自己的小世界里，完成很轻量、拥有它自己本来样子的库，自得其乐。但是现在，尽管 Papa Parse 依然是一个很棒的库，但是我已经不再知道它究竟是做什么的了。

（顺便说一句，我依然很喜欢并且推荐 Papa Parse，万一你正好需要 JavaScript CSV 解析器。）

### 按照老样子，我如何制作我的网站

我不认为自己是一名网络设计师，甚至也不是网站开发者，但是当我需要的时候我还是会制作网站（并且我经常这样做 —— 次数非常多，所以我写了一个完整的网络服务，[Caddy](https://caddyserver.com)，来让这个的过程更加快速）。

我不是开玩笑的，我仍然是这样制作网站的：

打开一个编辑器，写下这些（手写，大概只需要 30 秒 —— 为了这篇文章的真实性，我甚至真的写了一遍 —— 除非烦人的标签在这里并不起作用）：

```
<!DOCTYPE html>
<html>
  <head>
    <title>I code stuff with my bare hands</title>
    <meta charset="utf-8">
  </head>
  <body>
     Hi there
  </body>
</html>
```

然后我打开了一个新的标签页，写了 CSS 文件；也就是像这样的代码：

```
* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  font-size: 18px;
  color: #333;
}

p {
  line-height: 1.4em;
}
```

JavaScript 怎么办呢？我当然也用了。但是，仅用了我懂的那部分。我有很多需要学习，尤其是现在还出现了 ES6，以及很多新的 API 比如 fetch，但是我仍旧会在一些场景（[强调下**一些**](http://youmightnotneedjquery.com/)）中使用 jQuery —— 它能完成特定的任务，比如能够非常简单直接的操作多个 DOM 元素，而且它几乎是模版代码，我可以积累下来，还可以从一个项目复制粘贴到另一个项目。并不存在依赖地狱。

无论如何，我仅在这里加入了需要的 JS 代码。我偶尔也会加入一些仅基于原生 JS 的库，例如用 Papa Parse 来满足[**高级、高性能 CSV 解析需求**](https://www.youtube.com/watch?v=EX69fn2Wi9A)。（UtahJS 视频的链接，我在这段视频中介绍了将浏览器性能发挥到极限的惊人方法。）

大多数的时候，传统的表单请求或者页面导航没什么缺点。我确实经常将表单请求改成 AJAX 请求，但是却没什么需要修改 URL（它们中**任何一个**都不需要）。

然后我开始保存文件，在我们项目文件夹中运行 `caddy`，然后打开浏览器。我每次修改都需要刷新页面。十多年以后，我终于安装了第二个屏幕，所以我不需要切换桌面了。

JavaScript 并不是我吝啬使用的唯一技术：CSS，SVG，Markdown 还有静态站点生成器也是如此。我几乎从不使用 CSS 库。我只是在 CSS 3 和一些新特性比如 flexbox 和 grid 没有被支持的时候坚持用几个 hack 技术。但是所有的也就现在我说的这些了。就浏览器支持而言，SVG 依旧还处于发展中，而 Markdown 嘛...嗯...多数情况下我还是宁愿写 HTML/CSS，因为至少这样子在所有浏览器上表现都是相同的。

我很喜欢静态站点生成器的思想，但是通常它们都过于复杂。多数情况下，我所需要的就只是将代码片嵌入到我的 HTML 文件中，Caddy 只需要简单的几个模版操作就可以完成：`{{.Include "/includes/header.html"}}`。（我甚至可以用 [**git push**](https://caddyserver.com/docs/http.git) 来部署使用了 Caddy 的网站，不需要静态站点生成器！尽管它也支持这些功能）

### 优势

不使用那些花哨的，用途普适的，或者功能过多的库、框架和工具能够：

*   网站代码量少
*   更容易管理测试环境
*   调试速度快，解决问题的方法更普适
*   服务配置更简单（**我了解这方面**，相信我）
*   网站加载更快

它还能够为你省下好几个 GB 的硬盘空间！

### 代价

既然我不了解 React，Angular，Polymer，Vue，Ember，Meteor，Electron，Bootstrap，Docker，Kubernetes，Node，Redux，Meteor，Babel，Bower，Bower，Firebase，Laravel，Grunt 等等，我就没办法真正的帮助我的朋友们，或者在我的答案中惊艳他们，或者达到现在很多网站开发工作的要求。

尽管如此，但是从技术上讲，我并**不能**做很多事 —— 这是关键！仅有真正需要工具的时候，我才引入它们，否则我就选择自己写代码或者从 Stack Overflow 复制粘贴过来一些小功能（我很诚实）。（提示：和 YouTube 或者 HN 不同，**请阅读 Stack Overflow 上的评论。**）（需要绝对的了解你借用的代码是什么！）

我开发的效率降低了吗？

也许吧。但是，其实我并不这么认为。

### 结果

这里有几个网站，都是我这样赤手空拳的搭建起来的 —— 相信我，如果我有资源能够雇佣专业的前端开发者，我更愿意雇佣他们的 —— 但是所有这些网站都没有用任何框架，没有不必要的、笨重的依赖库。

我甚至没有最小化页面资源（除了图片压缩，只要拖动到 [tinypng.com](https://tinypng.com) 就可以了），基本上是因为我比较懒。但是你知道吗？页面的加载时间依旧非常短。

但是我认为，他们的代码中和“网络应用”最相关的，就只是一些毛糙的 jQuery。（毛糙，其实仅仅因为我很忙）。

![](https://cdn-images-1.medium.com/max/2000/1*zziUiqYBKpwkEYi8-gPM5w.png)

![](https://cdn-images-1.medium.com/max/1600/1*Ox4fKq-xvS9STRyuVUSHKg.png)

![](https://cdn-images-1.medium.com/max/800/1*mnhVan8aVQp2Rb1iM8OFhA.png)

![](https://cdn-images-1.medium.com/max/1200/1*V9M0Pmy_ZsyXQBM11i0o-w.png)

![](https://cdn-images-1.medium.com/max/1200/1*yckUvqs6ByWudzJ_rBGCcA.png)

网站链接：

*   [https://caddyserver.com](https://caddyserver.com)
*   [http://goconvey.co/](http://goconvey.co/)
*   [https://www.papaparse.com](https://www.papaparse.com)
*   [https://relicabackup.com](https://relicabackup.com) **（羞耻的提一句：现在有五折优惠！）**

每个网站大概都会花费我一天到一个礼拜的时间完成（取决于页面有多少，以及能够有多少的收入）。实质的内容当然会需要更长时间，但这都是给定的。

下面是一些我收到的反馈，是我“经典”路线 的结果：

*   我很喜欢你网站设计的简洁性。你是自己写的吗，还是用了模版/主题？
*   你的网站是一个优秀的榜样，好的网站设计应该如此。它快速，干净，不会加载很多没用的东西，而且几乎所有内容都能脱离 JavaScript 工作。
*   我很好奇你使用了什么框架或者工具来构建你的文档网站！它真的非常棒，非常轻量。

我并不是说我的网站是十全十美的 —— 它们距离完美还差得远，我只是小心的将它们用作案例研究 —— 但是无论如何，它们的功能都实现了。

给你一个小奖励：这里有一个很有意思的 API 示例，是我在几年前为了当时的工作，使用 vanilla HTML，CSS，和 JS 制作的。

* Youtube [视频链接](https://youtu.be/7T97vf-lrXk)

我知道每行代码都是什么意思，并且，包括了最小化的 jQuery（未压缩），所有内容加在一起大概是 50KB。很明显，显示地图图块时使用了另外一个依赖（Leaflet），但这是很合理的，因为它们是必需的功能。例如，如果你在做复杂的和时间相关运算以及时间渲染，那么使用 Moment.js 就没什么问题。我只是想要避免**广适性**的框架、库、以及工具，除非我真的需要他们或者明白它们在做什么。

### 开发过程

我收到了一些请求，所以我写下了构建网站的过程，并且这篇文章已经是我想到的最好的了。也许这篇文章很粗俗，**但是我的开发过程真的非常简单，很难解释，因为...其实没有任何过程。**

除了最低需求（文字编辑器和一个本地网络服务），我的“开发过程”不需要其他特别的工具：没有表意，没有安装，没有包管理。就只有我本人，我的文字编辑器，我的网络服务，并且懂得网站运行的基础。

### 要点

我并不是一个专家。网络开发需要很多年的实践才能获得真知灼见，就算没有使用华丽的工具也是一样的。

我相信随着时间流逝，一个人能够获取到所有需要的技术和知识，能以相同的速度来做现在酷小孩做的事情，但是却有一下优势：

*   大大减小代码量
*   更少出故障
*   更直观
*   更短，更有效率的调试会话
*   更高的知识转移
*   更灵活，面向未来的软件结构

所有这一切都是通过只消费**你所需要的**而来。

这也正是技术债的治愈方法。

（嗯，本文可能更像是一剂“预防针”。）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
