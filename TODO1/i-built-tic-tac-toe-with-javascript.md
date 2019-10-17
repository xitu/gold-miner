> * 原文地址：[I Built Tic Tac Toe With JavaScript](https://mitchum.blog/i-built-tic-tac-toe-with-javascript/)
> * 原文作者：[MITCHUM](https://mitchum.blog/author/mitchm/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-tic-tac-toe-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-built-tic-tac-toe-with-javascript.md)
> * 译者：[lgh757079506](https://github.com/lgh757079506)
> * 校对者：[portandbridge](https://github.com/portandbridge)，[TokenJan](https://github.com/TokenJan)

# 用 JavaScript 实现一个井字棋游戏

在我上一篇文章中，我向大家展示了[匹配类游戏](https://www.mitchum.blog/i-built-a-simple-matching-game-with-javascript/)，文中介绍到我是使用 JavaScript 实现并简单谈了一下前端[ web 技术](https://mitchum.blog/how-a-dynamic-web-application-works-an-epic-tale-of-courage-and-sacrifice/)。 我得到了很好的反馈，所以在本周的文章中我决定讲解一个由 Javascript 实现的游戏[井字棋](https://www.mitchum.blog/games/tic-tac-toe/tic-tac-toe.html)并详细介绍其实现方案。在本项目中，我还尝试挑战不使用任何外部 Javascript 依赖库去实现它.

[点这里](https://www.mitchum.blog/games/tic-tac-toe/tic-tac-toe.html) 去玩下井字棋游戏吧！

这里有两个难度等级：小白（moron）和天才（genius）。挑战成功 moron 的话，试下能否挑战成功 genius 级别。genius 要比 moron 更难对付，不过 genius 采取的玩法有点轻敌，并非真的那么精明。正在读文章的朋友，我保证你能凭借你的智慧发现能赢得游戏的奥秘。

## 实现过程

井字棋游戏使用了三个基本的前端技术：HTML、CSS 和 JavaScript。我会向你逐个介绍实现源码并讲解它们各自的作用。以下是这三个文件：

[tic-tac-toe.html](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.html)

[tic-tac-toe.css](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.css)

[tic-tac-toe.js](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.js)

### HTML

##### HTML 的头部

让我们从 head 标签开始。这个标签位于每个 HTML 文档开头。这里将存放一些影响页面整体的元素标签。

```html
<head>
    <title>Tic Tac Toe</title>
    <link rel="stylesheet" href="tic-tac-toe.css">
    <link rel="shortcut icon" 
          href="https://mitchum.blog/wp-content/uploads/2019/05/favicon.png" />
</head>        
```

head 标签中包含了三个子标签：一个 title 标签和两个 link 标签。浏览器中的选项卡处会展示 title 标签中的内容。本例中为“Tic Tac Toe”。第二个 link 标签设定了我们想展示在选项卡中的图标的链接。他们组合起来将是下面的样子：

![Browser tab for javascript Tic Tac Toe game](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/06/tab.png?w=740&ssl=1)

第一个 link 标签包含对[tic-tac-toe.css](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.css)文件的引用。这个文件可以让我们为 HTML 文档添加颜色和定位等样式。如果没有此文件，我们的游戏将会显得比较沉闷。

![Tic Tac Toe game without css applied](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/htmlonly-1.png?w=740&ssl=1)

这个是没有任何样式下的我们页面的样子。

接下来我们展示 HTML 文档主体。我们将其拆分为两部分：游戏界面和控制栏。我们先从游戏界面开始。

##### 游戏界面

我们将使用 table 标签来布局井字棋游戏界面。代码如下：

```html
<table class="board">
<tr>
  <td>
      <div id="0" class="square left top"></div>
  </td>
  <td>
      <div id="1" class="square top v-middle"></div>
  </td>
  <td>
      <div id="2" class="square right top"></div>
  </td>
</tr>
<tr>
  <td>
      <div id="3" class="square left h-middle"></div>
  </td>
  <td>
      <div id="4" class="square v-middle h-middle"></div>
  </td>
  <td>
      <div id="5" class="square right h-middle"></div>
  </td>
</tr>
<tr>
  <td>
      <div id="6" class="square left bottom"></div>
  </td>
  <td>
      <div id="7" class="square bottom v-middle"></div>
  </td>
  <td>
      <div id="8" class="square right bottom"></div>
  </td>
</tr> 
</table>
```

我们为 table 标签添加“board”类，以便为其添加样式。该区域有三个 row 标签，每个标签中包含三个用于存放数据的标签。这就组成了一个 3×3 游戏面板。我们为其中每个格子设置其 id 为数字并且设置一些表示其位置的 class 名。

##### 控制栏

我所说的控制栏部分包含一个消息框，几个按钮和一个下拉列表。代码如下：

```html
<br>
<div id="messageBox">Pick a square!</div>
<br>
<div class="controls">
 <button class="button" onclick="resetGame()">Play Again</button> 
 <form action="https://mitchum.blog/sneaky-subscribe" 
       style="display: inline-block;">
    <button class="button" type="submit">Click Me!</button> 
 </form>
 <select id="difficulty">
   <option value="moron" selected >Moron</option>
   <option value="genius">Genius</option>
 </select>
</div>
```

消息框位于两个换行符之间。第二个换行符后面是一个包含其余部分的 div 标签。play again 按钮有一个点击事件，可以在[tic-tac-toe.js](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.js)文件中调用 Javascript 函数。Click Me 按钮被包含在 form 标签中。最后，select 标签包含两个 options 标签：其内容为 moron 和 genius。moron 为默认选中状态。

每一个 HTML 元素都被指定为各种类名和 id 名，它们在游戏逻辑和样式方面起了不小的作用。我们来看下样式部分是如何编写的。

## CSS

我会分几部分讲解[tic-tac-toe.css](https://mitchum.blog/games/tic-tac-toe/tic-tac-toe.css)文件的内容，因为我觉得这样会使读者更容易理解。

##### 基础元素

第一部分（包含的代码）负责为 body, main 和 h1 标签设置样式。body 标签上使用 RGB 值设置页面背景为浅蓝色。

main 标签上设置 max-width, padding 和 margin 属性将游戏界面居中于屏幕。这个精美而简洁的样式风格是我从[这篇博文](https://jrl.ninja/etc/1/)中借鉴的。

h1 标签包含着大写的标题“Tic Tac Toe”，然后我们将其设置为黄色字体并居中。

代码如下：

![CSS styling for the page](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/css1.png?w=740&ssl=1)

##### 控制栏

接下来我们将讨论 message 框，难度下拉列表和整行控制区的样式.

我们将文本消息框居中并设置字体颜色为黄色。然后我们设置边框并使用圆角。

我们设置难度下拉列表的大小，并且设置了圆角，还设置了字体大小，颜色和位置信息。

我们对控制栏唯一需要调整的是确保其中所有元素都为居中状态。

代码如下：

![ CSS styling for the controls](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/css2.png?w=740&ssl=1)

##### 游戏面板

接下来要处理井字格的样式了。我们需要设置每个格子的大小，颜色和文本位置。更重要的是，我们需要在适当的位置显示边框。我们添加了几个 class 来标识游戏面板上的格子的位置，来实现著名的井字棋游戏。 我们还改变了边框的大小让它更有三维空间的感觉。

![CSS styling for the tic tac toe board](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/css3.png?w=740&ssl=1)

##### 按钮

最后我们来看下按钮的样式。我必须承认，我从[w3schools](https://www.w3schools.com/css/tryit.asp?filename=trycss_buttons_animate3)借用部分样式。但是，我确实进行了修改以适应我们的配色方案。

![CSS styling for the buttons](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/css4.png?w=740&ssl=1)

好啦，这就是 CSS 部分！现在我们终于可以进入有趣的部分：JavaScript。

### JavaScript

正如所料，JavaScript 代码是 tic tac toe 游戏中最复杂的部分。我将描述基本结构和人工智能部分，但我不是去介绍每一个功能。相反，我将把它作为练习让你阅读代码并理解每个函数是如何实现的。方便起见，这些函数已经被“加粗”。

如果代码中的某些部分让你困惑，请留言，我会为你详细解释！如果你能想出更好的实现方式，我也很乐意在评论中听到你的反馈意见。目的是让每个人都学到更多，与此同时可以收获快乐。

##### 基本结构

我们需要做的第一件事就是初始化一些变量。我们有几个变量用于存储游戏状态：一个用于表示游戏是否结束，另一个则表示游戏的难度级别。

我们还有一些变量用于存储一些有用的信息：格子用数组存储，格子数量和胜利条件。我们的游戏面板是有一系列数字代表，还有八种可能的胜利条件。因此，胜利条件由一个包含八个数组的二维数组表示，每个数组对应一个可能获胜的三个格子组合。

代码如下：

![initialization javascript variables](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/css5.png?w=740&ssl=1)

考虑到这点，让我们看下这个程序是如何运作的。这个游戏是[事件驱动](https://en.wikipedia.org/wiki/Event-driven_architecture)型。你点击的某些区域，代码都会作出响应，然后在屏幕上看到效果。当你点击“Play Again”按钮，游戏面板将会重置并且你可以进行下一轮的 tic tac toe 游戏。当你改变难度级别时，游戏会根据你的不同操作作出相应操作。

当然最重要事情的还是当玩家点击某个格子时的反馈。有许多需要检查的地方。这个逻辑大部分在名为**chooseSquare**的顶级函数中。

代码如下:

![Javascript for choosing a tic tac toe square.](https://i1.wp.com/mitchum.blog/wp-content/uploads/2019/06/js2.png?w=740&ssl=1)

##### 代码解读

让我们一起通读代码。

**176 行：** 我们需要做的第一件事就是将变量 difficulty 设置为下拉列表中选择的内容。这很重要，因为我们的人工智能会根据此变量以确定需要进行的操作。

**177 行：** 第二件事是检查游戏是否结束。如果没有我们可以继续。否则，将会停止。

**179 – 181 行：** 第三，我们将显示给玩家的消息默认设置为“Pick a square!”。我们通过调用 **setMessageBox** 函数实现。然后我们变量存储玩家选择的格子的 id 值和此 id 的dom节点。

**182 行：** 我们通过调用 **squareIsOpen** 函数检查格子是否是开放状态。如果已经被标记，玩家就不能对方格进行操作。在相应的 else 代码块中我们提示他。

**184 - 185 行：** 由于格子状态是开放的，我们将标记设为“X”。然后我们通过调用 **checkForWinCondition** 函数检查我们是否胜利。如果我们胜利了，我们将返回一个包含获胜组合的数组。如果输掉游戏我们返回 false。这是行得通的，因为 Javascript 不是[强类型](https://en.wikipedia.org/wiki/Type_safety)语言。

**186 行：** 如果玩家没有赢得比赛，那游戏继续，以便他的对手可以继续下一步操作。如果玩家确实赢了，那么相应的 else 代码块将通过把结束游戏变量变为 true，通过调用 **highlightWinningSquares** 函数将获胜格子变为绿色，并设置获胜消息。

**188 – 189 行：** 现在玩家的操作已完成，我们需要计算机做出操作。名为 **opponentMove** 的函数会解决这个问题，稍后将详细讨论。现在我们需要通过调用我们在 185 行使用的那个函数来检查玩家是否输了，但这次以“O”作为参数。这就是复用！

**190 行：** 如果电脑输了，那么我们必须继续，以便我们可以检查是否平局。如果计算机获胜，那么相应的 else 代码块将通过将结束游戏变量设为 true 来处理它，通过调用 **highlightWinningSquares** 函数，设置失败信息，且将获胜方的格子设为红色。

**192 – 197 行** 我们通过调用 **checkForDraw** 函数检查是否平局。如果没有获胜条件且没有更多可行的操作，那么我们必须定为平局。如果已经为平局，那么我们将游戏结束变量设为 true 并设置平局的消息。

这是游戏的主逻辑！函数剩余部分就是我们已经介绍的相应 else 代码块中的逻辑。正如前面说的，请阅读其他函数以更全面的了解游戏的工作原理。

##### 人工智能

有两个难度级别：moron 和 genius。moron 总是按照 id 的顺序取第一个可用的格子。为了保持这种有序的模式，他将牺牲一场胜利，即使是为了防止失败，他也不会偏离他。他很傻。

genius 会复杂得多。他会在那里获胜，他会尽力防止输掉游戏。后手会使他处于劣势，所以他更喜欢中心的格子保持其防守姿势。但是，他确实有可以利用的弱点。他遵循一套更好的规则，但并不擅长临机应变。当他找不到一个明显的操作步骤时会让他恢复到 moron 模式。

代码如下：

![AI top level javascript function](https://i0.wp.com/mitchum.blog/wp-content/uploads/2019/06/js4.png?w=740&ssl=1)

顶级的 AI 函数

![AI implementation details in javascript](https://i2.wp.com/mitchum.blog/wp-content/uploads/2019/06/js5.png?w=740&ssl=1)

AI 实现细节

你理解算法的话，请在评论中告诉我们可以做出哪些优化将我们的游戏变的更加智能！

(adsbygoogle = window.adsbygoogle || \[\]).push({});

### 总结

这篇文章中我展示了使用 Javascript 实现的 Tic Tac Toe 游戏。然后我们了解了它是如何实现的以及人工智能是如何工作的。让我知道你的想法吧，以及你希望我在未来做一些怎样的游戏。我只是一个人，能力有限，做不出使命召唤那样的游戏大作。

如果你想进一步了解如何用 Javascript 编写更好的程序，我推荐一本由大神 Douglas Crockford 编写的 [JavaScript: The Good Parts](https://amzn.to/2XrvPrt) 书。随时间发展这门语言有显著改善，但由于其发展历史，它仍然具有一些奇怪的特性。这本书很好地帮你了解更多有质疑空间的设计选择。我在学习 JavaScript 的过程中发现它对我的帮助很大。

如果你想购买它，并会浏览上面的链接，我将不胜感激。我将通过亚马逊的联盟计划获得佣金，对你无需额外费用。这样可以支持我继续运营本站。

感谢阅读，下期见！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
