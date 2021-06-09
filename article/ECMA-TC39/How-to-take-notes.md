> * 原文地址：[How to take notes](https://github.com/tc39/how-we-work/blob/master/how-to-take-notes.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-take-notes.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-take-notes.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)，[greycodee](https://github.com/greycodee)

# 如何做会议记录

### 简介

在 TC39 会议期间，我们的目标是对会议进行详细连贯的记录，以便对上次会议感兴趣的人即使没有参加会议也能及时了解最新情况并参与到过程中。对于首次参加 TC39 会议的新人来说，记笔记是一项极好的工作，因为它会让您直接投入到行动中。

### 应该如何做记录

捕捉所说的内容很重要，但不应逐字逐句。如果有人多次重复相同的观点，请不要担心无法记录他们所说的一切。试着专注于理解所说的内容，并掌握核心观点。这样我们就可以减少为公众编辑笔记的工作！另外，不要担心记下您不太明白的内容，其他人会随着您的记录进行纠正。

### 记录的位置

TC39 某一天的笔记保存在 etherpad 里。 *永远不要分享 etherpad 的链接*。鉴于谈话的节奏，笔记可能会变得非常混乱，并且可能不连贯。为了让演讲者有时间在特定对话中阐明他们的意图，笔记在几周内不会向公众发布，因此 etherpad 网址是私密的。如果您是一个新的笔记记录者，请不要犹豫，询问特定日期的笔记 URL 地址是什么。

## 笔记的结构

笔记的结构如下：
- 日期
- 与会者名单
- 议程项目的说明

### 日期

在笔记的顶部，您应该看到（或添加）日期：

```
# <月> <日>, <年> 会议记录
-----
```

例如 `# 3月 22, 2018 会议记录`

### 出席者名单


人们通常在此处添加自己的信息，首先是他们的名字，然后是名字的缩写，用于在笔记中识别他们。

姓名缩写必须是唯一的，并且在会议中应该是稳定的。否则我们将无法分辨笔记中的主体。通常我们使用三个字母：名字的第一个字母，姓氏的第一个字母，姓氏的最后一个字母。老前辈们习惯于使用两个单词的首字母缩写。

通常他们看起来像这样（这些是虚构的成员）：

```
Joseph Beuys (JB), Martin Kippenberger (MKR)
```
其中 Joseph Beuys 是一个老前辈，Martin Kippenberger 是一个新成员。

### 模板

笔记可能已经初始化，也可能尚未初始化。如果没有，您可以使用此模板：


```
-------------------------------------------------------------------------------------------------------------------------------------------
Template:
-------------------------------------------------------------------------------------------------------------------------------------------
    
    
## X.Y.Z 议程项目
 
(演讲者姓名)
 
 - [提议](...提议的链接...)
 - [幻灯片](...幻灯片的链接...)
 
JB: Ja ja ja....
 
MKR: Ne! Ne! Ne!
 
#### 结论/决议
 
- 阶段 -1 
```

这个模板可以分解为如下

#### 标题

X.Y.Z 应与议程中的议程编号相对应，后跟议程项目的标题。例如：`## 8.i.c Expand text included in "function code”`

#### 链接

与议程项目相关的任何链接都被添加到每个主题的第二部分。这可能包括提案存储库或一组幻灯片。这取决于议程项目。

#### 讨论

发言人由与会者列表中列出的姓名缩写标识。姓名缩写应始终使用大写字母。在这种情况下，我们有 [Joseph Beuys](https://www.youtube.com/watch?v=py_uEHL-la4) (JB) 与 [Martin Kippenberger](https://www.youtube.com/watch?v=MJxktqTgRlM) (MKR)

#### 结论

一旦讨论得出结论，我们就会记录讨论的决定或结果。这应该是一个单线点，例如阶段推进，或者需要返工。

## 建议

- 尝试合作记笔记，但不要同时有太多人。
- 如果有两个人，可以一个人完成最后一句的同时另一个人开始写第二句。
- 如果 etherpad 实例上的人太多，记笔记者可能会被锁定 —— 如果你当前不需要记笔记，尽量不要打开笔记。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
