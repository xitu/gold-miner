> * 原文地址：[Should You Learn VIM as a Developer in 2020?](https://medium.com/better-programming/should-you-learn-vim-as-a-developer-in-2020-75fde02c5443)
> * 原文作者：[Joey Colon](https://medium.com/@joey_colon)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/should-you-learn-vim-as-a-developer-in-2020.md](https://github.com/xitu/gold-miner/blob/master/TODO1/should-you-learn-vim-as-a-developer-in-2020.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[IAMSHENSH](https://github.com/IAMSHENSH)、[QinRoc](https://github.com/QinRoc)、[Amberlin1970](https://github.com/Amberlin1970)

# 作为 2020 年的开发者，你应该学习 VIM 吗？

![Photo by [Helloquence ](https://unsplash.com/photos/5fNmWej4tAA)on [Unsplash](http://unsplash.com)](https://cdn-images-1.medium.com/max/2000/1*6RF4SWv3nDsFlX1vDzc8Nw.jpeg)

## 开场白

关于使用什么文本编辑器，哪一种 shell 和哪一类操作系统一直是开发者热衷于讨论的话题。我们知道，肯定有人很热衷于 VIM。遗憾的是，这篇文章不打算赞美 VIM，而是来讨论我为什么决定学习 VIM，它能为我解决什么问题，不能为我解决什么问题，以及最重要的：你应不应该学习 VIM？

下文中我会对我的编程背景做一个简要介绍。大概在 2018 年末，我决定把编程作为职业后，就开始认真对待编程。在这之前，我经常为我玩的各种游戏创建（相当糟糕的）脚本，同时也把运行一些网站或游戏服务器作为副业。自从把编程作为事业之后，我涉猎了几种语言，其中在 JavaScript 的生态中我做了很多事情。介绍结束，我们来开始正文吧！

![](https://cdn-images-1.medium.com/max/2400/1*djasmygBIiqOqTCnXUehxA.jpeg)

## VIM 没有为我解决的问题

VIM 没有让我变成更优秀的软件工程师。我要重申一遍：学习 VIM 不会让你变成更优秀的软件工程师。核心意思是，软件工程与你开发所使用的 shell、编辑器或者操作系统无关。我相信肯定有很多人会有这样的观点：为了让你变成一个“优秀”的软件工程师，你需要使用 X 或者 Y。

作为这个行业的新人，我发现这种普遍的“要么不做，要么破产”的心态是畏缩者和精英主义者所有的。我们都是在为复杂问题创造解决方案。而用于解决方案的工具，不会让你成为更好的或者更差的开发者。

## 我为什么决定学习 VIM

#### 建立习惯

既然我是一个相对比较萌新的程序员，我在很多领域有提升的空间，工作流绝对是其中之一。在学习 VIM 之前，我是一个连快捷键都不会设置的人。我非常依赖于鼠标。在 VIM 给我洗脑时，“让手专注于键盘”这个观点吸引了我，因为我打字一直很快。我的潜意识里告诉我，学习 VIM 不会造成任何负面影响。

#### 无限潜能

在纠结应不应该学 VIM 时，我看了一个关于它的科技讨论，唯一能获得的要点是，人们用 VIM 很多年了，现在还能在这个工具上进行改进。

这个观点提示了我很多事情。首先，学会 VIM 需要投资巨多的时间，但更重要的是，你总是在想办法提高你的技能。作为一个萌新的开发者，我想同步我的努力。这是我之前观点的重申，当我把不同的工具（本例中的 VIM ）整合进我的开发工作流中，我就有一石二鸟的能力了。

#### 在 Linux 服务器上，我再也不需要 nano 

这句话有点传闻的味道，说这句话的人，在 Linux 远程环境下，远程运营了很多年的网站和服务器，他肯定不知道 VIM 确实很烦人。如果要为正在运行的服务修改配置文件，我得安装 nano，因为我对 VIM 的认知是用 `:q!` 来操作。

## 我的工作环境

日常工作中，我在 VSCode 上设置了 VIM 的插件。我曾经尝试安装过像 coc.nvim 这样的插件，以便直接用终端进行开发，但是这些都不是我的菜。我一直很喜欢在 VSCode 上写代码的体验。使用 VSCode 上的 VIM 插件提供了与运行 VIM 同样的体验，除此之外，我还能获得 VSCode 生态圈提供的好处。对于我来说，使用这个设置两全其美。

## 总结

你应该学习 VIM 吗？如果你没有任何使用快捷键的习惯，我觉得你至少需要试一下。我过去没有设置“舒服”的热键或者工作流的情况，让学习 VIM 对我充满了吸引力。学完 VIM 之后，我可以说我获得了只有自己才能构建的新的基础知识。

浏览 VIM 的教程（Vimtutor）大概花了我两周的时间，然后我才适应 VSCode 上的 VIM 插件。之后，又花了我另外一周的开发时间，通过肌肉记忆建立用快捷键浏览代码的习惯。这种方式现在看来，我是在用两种方式写代码。学会 VIM 让我的时间更有价值。

但是，我想重申，程序员最终还是为难题创造解决方案的。你想用哪一种快捷键方案、编辑器或者其他的东西，完全基于你的偏好。你编辑文件的速度往往不是你开发工作的瓶颈。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
