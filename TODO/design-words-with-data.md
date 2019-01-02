> * 原文地址：[Design words with data](https://medium.com/dropbox-design/design-words-with-data-fe3c525994e7#.8dg1elnkf)
* 原文作者：[John Saito](https://medium.com/@jsaito)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：[Zhiw](https://github.com/Zhiw), [marcmoore](https://github.com/marcmoore)

![](https://cdn-images-1.medium.com/max/1000/1*M1N7HJEyqpyaT71xVEBVSQ.jpeg)

# 科学写作

## 在 Dropbox，数据是如何帮助我们更合理地写作

写作也是一种艺术创作。有些文字能让我们放声大笑、感动流泪或者激励我们去完成伟大的事业。

但我想说的是，写作也是一门科学。数据能带来额外的写作源泉并且帮助我们更客观的规划写作的内容。

### 孰对孰错？

作为一位在 Dropbox 工作，从事用户体验方面的作者，我们的目标就是确保所写的每一个字都言之有理。一处用词不当就会破坏用户的体验。任何一个意义不明确的按钮、标签或者不太常用的专业术语都很容易让用户受挫。

为了保证我们选用的是正确的文字，我们会使用一些技术手段来帮助我们在写作中做出更合理的选择。

### 1. Google 趋势

假设你尝试在一些不同的专业术语中决定用哪一个最恰当。举个例子来说，以下哪些术语你觉得应该在产品中使用？

- Log in
- Log on
- Sign in
- Sign on

你可以试试看 [Google 趋势](https://www.google.com/trends/)。只需要输入所有的这些术语并用逗号隔开。`Google 趋势`比较人们在 Google 上对这些术语进行搜索的频次。这个搜索结果自动包含类似 "facebook log in" 或者 "can't sign in" 这样的短语。

所以 `Google 趋势`想告诉我们什么呢？

![](https://cdn-images-1.medium.com/max/800/1*9NBykN1q0YApaT2h4s4NCw.png)

哈哈！看上去 "sign in" 是明显的赢家。这意味着当人们提到这个操作的时候，他们更加喜欢使用 "sign in"。如果想让你的文字符合用户的期望，相比其他备选，"sign in" 可能是一个更加安全的选择。 

---

在 Dropbox，我们意识到在 "version history" 这个特性上，我们使用了不同的术语。 

![](https://cdn-images-1.medium.com/max/800/1*ohhKBv3jQfTbFB8CJapZ0Q.png)

我们明白我们需要修正这些不一致性，但是我们并不确定使用哪一个。是应该使用 "version history"、"file history" 或者 "revision history"？我们不得不从多方面进行考虑，但是我们使用 `Google 趋势` 作为一个考量点帮助我们做出正确的选择。

![](https://cdn-images-1.medium.com/max/800/1*HvjhGsKR3ZtutkZlfDToAQ.png)

`Google 趋势`告诉我们人们会更喜欢搜索 "version history"，并且这也是为什么我们现在的产品中都把它称做 "version history" 的一个很重要的原因。

### 2. Google Ngram 观察者

[Ngram 观察者](https://books.google.com/ngrams) 有点类似于 `Google 趋势`，不过它搜索的是那些由 `Google` 收录的出版物。你能使用这些数据看看哪些术语在你的文字表达中是更常用的。

`Dropbox` 最近在我们的 `iOS` 应用程序中启用了一套新的签名工具。在我们进行签名审核之前，你的手机屏幕上会显示 “Sign Your Signature”。

![](https://cdn-images-1.medium.com/max/800/1*sGngF3GxPZhmfU2G7owU-g.png)

我们知道 “sign your signature” 听上去很可笑。但是 “听上去很可笑” 并不足以改变它。我们如何才能说服团队成员来改变它呢？

当我们转向 `Ngram 观察者`来对比 "sign your signature" 和 "sign your name" 的时候。它明确指出，"sign your signature" 根本不会被使用。当我们把这个数据结果分享给团队成员的时候，他们马上就把它替换成了 "Sign your name"。

![](https://cdn-images-1.medium.com/max/800/1*Pg44k4J9VFHaEjQZcr0UwA.png)

### 3. 可读性测试

多年来，语言学家已经开发出了很多可读性测试的工具，它们能测量出你的文字是否容易理解。

这些测试中有很多能对你的写作评定一个等级。举例来说，8 级意味着在美国的 8 年级学生可以理解你写的东西。

我有一篇中篇小说 ([**怎么构思文字**](https://medium.com/@jsaito/how-to-design-words-63d6965051e9#.i3r1l4g4h)) 就是通过其中一个测试完成的。以下是它给出的结果： 

![](https://cdn-images-1.medium.com/max/800/1*Y-EsgPfmIQ_S-2XxMMA9Tg.png)

你能从这里得到很多有趣的数据。例如：

- 我写的这篇小说能达到 **6 年级的水平**
- 我的文中的语气是**中立的**，但是**稍稍偏向乐观。**
- 平均**每句话有 10.7 个单词**。（在 Dropbox，我们尝试把每句话的单词控制在 15 个或者更少。）

如果你想要尝试下这些测试，可以参考以下内容。有些测试甚至能够给你提供修改意见，它们确保你的作品可读性更强。

- [Readability-Score.com](https://readability-score.com/)
- [Hemingway Editor](http://www.hemingwayapp.com/)
- [The Writer’s Readability Checker](http://www.thewriter.com/what-we-think/readability-checker/)

### 4. 研究性的调查问卷

想尝试给新功能起个名字？或者应该关注什么价值？在类似这些情况下，它能帮助你建立一个研究调查问卷。

许多调查问卷的工具允许你选择你的目标受众，所以你能方便地从潜在用户中获得反馈。

你能从以下这些地方建立一些研究性的调查问卷：

- [UserTesting](https://www.usertesting.com/)
- [SurveyMonkey](https://www.surveymonkey.com/)
- [Google Consumer Surveys](https://www.google.com/insights/consumersurveys/home)

在当时，Dropbox 进行了一个问卷调查，为了搞清楚使用我们的产品能获得怎样的最大收益。许多人提到“访问” — 从任何设备上访问文件的能力。结果，我们重新设计了很多在登录页面上的广告词，它们更加关注访问。

![](https://cdn-images-1.medium.com/max/800/1*bbe8abkKDJ7ijX9wo-sD_A.png)

### 5. 用户研究

对于收集那些能对你的作品带来价值的反馈来说，用户研究是一个非常好的方式。以一个典型的用户研究为例，你邀请了很多人读你的文章或者试用一个产品，之后，你通过问题获得相关反馈。这对于看看你的作品是否有意义，会是非常有帮助的。

我们当中的一位研究人员最近进行了一个研究项目，它是有关我们测试的一个新的流程。有一条是这样的:

> 选择“移除本地拷贝”来节省存储空间。

我们问了参与者们他们会否使用这个功能。大部分人都很难理解这个功能并且认为这个功能没什么用。所以之后，我们调整了单词的顺序，把能带给用户的好处放在句子的前部。

> 为了节省存储空间，可通过选择“移除本地拷贝”。

这次，参与者们更快地告诉我们他们想用这个功能。我们真正做的仅是调整了这些单词的顺序。

这显示出一位作者的直觉是怎么转变成一个实验的，并且你能测试它，就好像其他设计的决定。

### 用心写作，用智慧构思

当你正准备构思一些明确的作品的时候，数据是非常有用的。但是这并不意味着你应该如一台机器一般工作。

我的方式是，首份草稿应该出自你内心所想。相信你自己。在你写出你的想法之后，才是你开始研究和让数据精炼你的文字的时候。

写作即是一门艺术又是一门科学。通过心灵创作，智慧构思，你就能创造出即真实又合理的作品。

数据带给你作为一位作者的信心。数据让你的作品更加"准确"。
