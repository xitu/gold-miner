> * 原文地址：[Fun places to learn CSS Layout –  Part 1: Flexbox](https://stephaniewalter.design/blog/fun-places-learn-css-layout-part-1-flexbox/)
> * 原文作者：[Stéphanie](https://stephaniewalter.design)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ces-learn-css-layout-part-1-flexbox.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ces-learn-css-layout-part-1-flexbox.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：[sleepingxixi](https://github.com/sleepingxixi), [Stevens1995](https://github.com/Stevens1995)

# 趣味学习 CSS 布局 —— 第一部分：弹性布局

![](https://stephaniewalter.design/wp-content/uploads/2017/05/flexboxfun.jpg)

> 这个内容已经是 2 年前的了。请记住，以下内容可能已过时。

在我开始学习 CSS 时，一切都是关于用浮动、绝对定位与相对定位实现你想要做的事。今天，我们有了很棒的新工具来创建布局：[弹性布局](https://www.w3.org/TR/css-flexbox-1/)和[网格布局](https://www.w3.org/TR/css3-grid-layout/)。如果你忽略 IE9 以及更早的版本，则 Flexbox [几乎在任何地方都受到很好的支持](http://caniuse.com/#feat=css-grid)，可用于创建灵活且可扩展的布局。目前，网格布局[并非在任何地方都受到支持](http://caniuse.com/#feat=css-grid)，但是如果您正在寻找一种构建复杂而通用的响应式网格的方法，那还是很有希望的。

掌握这两个模块可能有些棘手。幸运的是，一些很棒的人制作了许多有趣的工具来帮助你学习并掌握这些它们，所以当它们被各处支持时你也准备好了。

**这是帮助您学习 CSS 布局的可能性系列的第一篇文章，今天我们将专注于学习[弹性布局](https://www.w3.org/TR/css-flexbox-1/)。**  
**如果你要查找本文的法文版本，可以查看 “[Apprendre le positionnement en s’amusant – Partie 1 : Flexbox](https://www.creativejuiz.fr/blog/css-css3/apprendre-positionnement-flexbox-s-amusant)“**

## 学习弹性布局的小游戏

### [Flexbox Froggy 小游戏](http://flexboxfroggy.com/)

Flexbox Froggy 是一款有趣的小游戏。您需要使用不同的弹性布局属性将可爱的小青蛙带到睡莲。([Thomas H. Park](https://twitter.com/thomashpark) 制作)

![Flexbox Froggy 小游戏](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-1-1040x734.png)

### [Flexbox defense 小游戏](http://www.flexboxdefense.com/)

Flexbox defense 是一款小游戏，您将在其中使用弹性布局阻止传入的敌人越过防线。([Channing Allen](https://twitter.com/ChanningAllen) 制作)

![Flexbox defense 小游戏](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-2-1040x734.png)

## 弹性布局可视化实验面板

有时最好的学习方法是自己做实验。这里有一些可视的弹性布局实验面板，您可以在这里探索和解构东西，以更好地理解语法。

### [CSS3 弹性布局的视觉指南](https://demos.scotch.io/visual-guide-to-css3-flexbox-flexbox-playground/demos/)

添加、移除和定位子元素，并测试您在布局中所有要用到的弹性布局属性。([Dimitar Stojanov](https://twitter.com/justd100) 制作)

![Yoksel 的弹性布局备忘单](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-5-1040x734.png)

### [弹性布局实验面板](http://codepen.io/enxaneta/full/adLPwv/)

在这个由 [Gabi](https://twitter.com/w3unpocodetodo) 制作的 codepen 实验面板上，你将能够测试不同的弹性布局属性，并使用它们的值来观察结果。

![弹性布局实验面板](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-7-1040x734.png)

### [Flexplorer](http://bennettfeely.com/flexplorer/)

在另一个由 [Bennett Feely](https://twitter.com/bennettfeely) 制作的小型可视化实验面板中，您可以进行测试并使用不同的属性来探索弹性布局 CSS 模块的可能性。

![Flexplorer](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-11-1040x734.png)

## 弹性布局可以帮助您实现什么

### [弹性布局的解决方案](https://philipwalton.github.io/solved-by-flexbox/)

在弹性布局之前，垂直居中曾是一个噩梦，这个站点将向您展示一些现在使用弹性布局可以轻松解决的技巧。([Phil Walton](https://twitter.com/philwalton) 制作)

![弹性布局的解决方案](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-9-1040x734.png)

### [弹性布局模式](http://www.flexboxpatterns.com/home)

弹性布局用来构建布局很好，但是像标签或卡片这样更复杂的模式呢？弹性布局模式可以满足您的需求。([CJ Cenizal](https://twitter.com/thecjcenizal) 制作)

![弹性布局的解决方案](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-8-1040x734.png)

## 弹性布局备忘单

弹性布局的语法并不总是那么容易，这里有一些备忘单可以帮助您记住不同的属性和值。

### [弹性布局的 CSS 技巧指南](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

![弹性布局的 CSS 技巧指南](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-3-1040x734.png)

### [Joni Bologna 的丰富的弹性布局备忘单](http://jonibologna.com/flexbox-cheatsheet/)

![Joni Bologna 的丰富的弹性布局备忘单](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-4-1040x734.png)

### [Yoksel 的弹性布局备忘单](http://yoksel.github.io/flex-cheatsheet/)

![Yoksel 的弹性布局备忘单](https://stephaniewalter.design/wp-content/uploads/2017/05/learn-flexbox-6-1040x734.png)

## 需要更多的帮助？

[Wes Boss 创建了 20 个免费视频](https://flexbox.io/#/)帮助您学习弹性布局，并且您也可以查看这篇文章[用一些 gif 动画解释弹性布局](https://medium.freecodecamp.com/an-animated-guide-to-flexbox-d280cf6afc35)。  
这是针对弹性布局的，稍后请参见第二部分网格布局。

您是否正在为网站或移动应用程序寻找 UX 或 UI 设计师？如果您想邀请我参加您的会议，或只是想了解更多关于我的信息？您可以查看[我的作品](https://stephaniewalter.design/#work)、[与我联系](#contact)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
