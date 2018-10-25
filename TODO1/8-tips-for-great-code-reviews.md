> * 原文地址：[8 Tips for Great Code Reviews](https://kellysutton.com/2018/10/08/8-tips-for-great-code-reviews.html)
> * 原文作者：[Kelly Sutton](https://kellysutton.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/8-tips-for-great-code-reviews.md](https://github.com/xitu/gold-miner/blob/master/TODO1/8-tips-for-great-code-reviews.md)
> * 译者：[xiaoxi666](https://github.com/xiaoxi666)
> * 校对者：[Augustwuli](https://github.com/Augustwuli), [Raoul1996](https://github.com/Raoul1996)

# 代码评审的 8 点建议

**如果你想获得本系列博客的最近更新，请加入我们由几百个开发者组建的社区，并[订阅我的专栏](https://buttondown.email/kellysutton)。**

学校有一点没有教你的是：如何进行代码评审。你学习了算法、数据结构，以及编程语言基础，但没有人坐下来说：“这是一些能让你提出更好的反馈的办法”。

代码评审是编写良好软件过程中的关键步骤。代码评审在于尽可能使得其具备[高质量且 bug 少](https://blog.codinghorror.com/code-reviews-just-do-it/)的特点。良好的代码评审文化也会带来其他收益：你减少了[产生 bug 的因素](https://en.wikipedia.org/wiki/Bus_factor)；同时代码评审也是培养新成员和分享知识的良好途径。

## 假设

阅读本文之前，有必要作出几点假设，如下：

*   你在一个受信任的环境中工作，或者你和你的团队正在改善你的信任度。
*   你可以在非代码环境中提出反馈，也可以在你的团队中提出反馈。
*   你的团队希望产出更好的代码，也理解 _perfect_ 是一个动词而非形容词。我们可能会为明天的工作找到更好的解决方案，同时我们需要保持开放的心态。
*   你的公司注重代码的质量，并且理解高质量代码或许无法快速“上线”。这里引用“上线”是为了说明：很多时候未经测试和评审的代码实际上可能不起作用。

有了上述假设条件，接下来让我们进入正文。

## 1. 我们是人类

要知道其他人在你将要评审的代码中投入了很多时间，他们也想让代码质量更高。你的同事（通过代码）努力地表达自己的意图，谁也不想写出蹩脚的代码。

保持客观是很困难的。请确保总是评判代码本身，并试着去理解上下文的含义。尽可能减轻评判带来的不良影响。不要说：

> 你写的这个方法令人费解。

尝试换个说法以针对代码本身，并增加你的解释：

> 这个方法有点不好理解，我们是否可以为这个变量起一个更好的名字呢？

这个例子中解释了我们作为读者时对代码的感觉，这关乎于我们自己以及我们对代码的解释，而与编写者的编码方式或意图无关。

每个的 Pull Request 都有它本身的[高难度交流](https://www.amazon.com/Difficult-Conversations-Discuss-What-Matters/dp/0143118447)。尝试与你的队友达成共识, 共同努力以实现更好的代码。

如果你刚刚认识一名团队成员，并且针对某个 Pull Request 有一些重要反馈，请共同浏览一遍代码。这将是发展同事关系的一个好机会。以这种方式与每个同事合作，直到你不再感到难为情。

## 2. 自动检查

如果计算机可以决定并执行一条规则的话，那就让计算机完成它。争论应使用空格还是 tabs 属于浪费时间。相反，应把时间花在制定规则上并且达成一致。这也是观察团队如何在低风险情景下处理“反对还是提交代码”的机会。

编程语言和现代工具流不缺乏执行规则（的辅助检查程序）并反复应用它们的方法。在 Ruby 中，有 [Rubocop](https://github.com/rubocop-hq/rubocop)；在JavaScript中，有 [eslint](https://eslint.org/)。找到语言这类辅助检查程序，并将其嵌入到构建流中。

如果你发现现有的辅助检查程序存在不足，那么可以自己编写！定制规则相当简单。在 Gusto 中，我们使用定制的辅助检查规则来捕获类的废弃用法，或者适当地提醒人们遵守某些 [Sidekiq](https://sidekiq.org/) 最佳实践。

## 3. 全员评审

听起来，把全部的代码评审工作交给 Shirley 是一个好主意。

Shieley 是一位大牛，她总是知道如何有效编程。她清楚系统的输入输出，在公司呆的时间比团队成员的总和都要长。

然而对于某些事情，Shirley 理解它并不代表其他团队成员也理解了。评审 Shirley 的代码时，年轻的团队成员或许会在指出某些问题时犹豫不决。

我意识到将评审工作分配给不同的成员会产生有益的的团队动力和更好的代码。一名初级工程师在某次代码评审中作出的最有力的评论是：“我看不太懂。”这是使代码变得更加清晰简单的机会。

在团队中推广代码评审。

## 4. 保持可读性

在 [Gusto](https://gusto.com) 中，我们使用 GitHub 管理我们的项目。GitHub 中的每个 `<textarea>` 都支持 [Markdown](https://github.github.com/gfm/)，这是一种在注释中添加 HTML 格式文本的简单方法。

使用 MarkDown 是一种增加内容易读性的方式。GitHub 及你选用的工具可能会具备语法高亮功能，这对代码片段的阅读非常友好。使用一对反引号 (`` ` ``) 嵌入代码或三个反引号 (` ``` `) 增加代码块，带来更好的交流体验。

善于利用 Markdown 语法（尤其当你写的代码包含注释时）。这样做将有助于使你的评论内容具体且重点突出。

## 5. 至少反馈一条正面评价

代码评审本质上是带有消极影响的事情。**在我把代码发到网上前，可以告诉我这个代码有什么问题**。这就是代码评审应该干的事情。开发者投入时间编写代码，同时希望你能指出如何能够做得更好。

为此，总是应该给出至少一条正面评价，并且使其富有意义和充满人情味儿。如果有人最终解决了长期攻关的问题，请无保留地表露出兴奋，它可以是简单的一个 👍 或者 “赞一个”。

在每次的代码评审中留下正面评价会微妙地提醒我们在一起共事。如果我们生产良好的代码，我们都将受益。

## 6. 提供替代方案

我尝试去做的一件事是：用替代方案来实现（相同的功能），尤其是刚刚开始学习一种编程语言和框架的时候。

谨慎一些。如果表述不恰当，可能会让人觉得你傲慢或自私：“这是我实现的方式。”尽量保持客观，并讨论你所提供的备选方案的优缺点。如果你的方案很棒，将有助于拓展每个成员的技术视野。

## 7. 延迟是关键因素

快速修正代码非常重要。（下面的规则会使它变得更容易：**保持小代码量**。）

长时间地延迟代码评审会降低生产力和斗志。被分配去评审 3 天前的 PR 会让人感到不舒服。**噢，的确如此。我究竟在干什么？反复地在上下文构建环境中切换。要纠正这一点，你需要提醒你的团队，进度依赖于整个团队而非个人。促使你的团队关注代码审查的延迟情况，并把它做得更好。**

如果你希望减少自己的代码评审延迟，我建议遵循这条规则：**编写任何新代码之前，首先评审代码。**

作为一种直接处理延迟的策略，尝试在代码评审时进行配对。找一个结对编程工作台，或者共享屏幕来浏览和评审代码。生成解决方案时采用配对方式，使大家都赞成它。

## 8. 对提 pr 者的忠告：保持小代码量

在一次代码评审中，你收到的反馈的质量与 Pull Request 的代码量成反比。

为作出令人信服且有建设性的反馈，要知道更小的 Pull Request 更易于阅读。

如果你保持 Pull Request 足够小（避免 [The Teeth](https://kellysutton.com/2018/07/20/the-teeth.html)）（译注：原文中用牙齿的大小类比代码块的大小，如果牙齿太大则可能会戳破皮肤，同理，代码块也不宜太大），你将需要结合上下文进行更大范围的交流。这个 Pull Request 如何合入本周本月的工作中？我们下一步要做什么，以及这个 Pull Request 是怎么推进工作的？诸如白板编程和面对面讨论这些形式的讨论非常重要。更小的 Pull Request 很难让人记住它的上下文。 

不同的编程语言和团队对“小”有不同的定义。对我而言，我尽量保持 Pull Request 少于 300 行代码。

## 结论

希望这 8 条建议能够帮助你和你的团队作出更好的代码评审。通过改进你们的代码评审流程，你可以收获更好的代码、更融洽的队员，以及更好的业务发展。

你的团队在实施代码评审的过程中使用到了哪些方法？[欢迎到我的 Twitter 上留言。](https://twitter.com/kellysutton)

* * *

需要更多博客资料？请查看系列 [**Feedback for Engineers**](https://kellysutton.com/2018/10/15/feedback-for-engineers.html)。

特别感谢 [Omar Skalli](https://www.linkedin.com/in/omarskalli/)、[Justin Duke](https://twitter.com/justinmduke) 和 [Emily Field](https://www.linkedin.com/in/emily-field-50b1a555/) 在本文成稿过程中给予的反馈。

如果你想获得本系列博客的最近更新，请参与由数百人组成的开发者社区，并[订阅我的专栏](https://buttondown.email/kellysutton)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
