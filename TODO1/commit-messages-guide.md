> * 原文地址：[Commit messages guide](https://github.com/RomuloOliveira/commit-messages-guide/blob/master/README.md)
> * 原文作者：[RomuloOliveira](https://github.com/RomuloOliveira)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/commit-messages-guide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/commit-messages-guide.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：

# commit 提交指南

[![鸣谢!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/RomuloOliveira)

一份理解 commit 信息重要性以及如何较好它们的指导手册。

It may help you to learn what a commit is, why it is important to write good messages, best practices and some tips to plan and (re)write a good commit history.它可以帮你了解什么是 commit，为什么填写好的信息说明比较重要，最佳实践、计划和重写良好的 commit 历史的一些建议。

## 可参考的语言版本

- [英语版](README.md)
- [葡萄牙语版](README_pt-BR.md)
- [德语版](README_de-DE.md)
- [西班牙语版](README_es-AR.md)
- [意大利语版](README_it-IT.md)

## 什么是『commit』?

简而言之，commit 就是你本地仓库中文件的一个快照。
和一些人的想法相反，[git 不仅存储文件之间的差异，还存储所有文件的完整版本](https://git-scm.com/book/eo/v1/Ekkomenci-Git-Basics#Snapshots,-Not-Differences)。
由于文件并不在每次提交都会发生改变，因此 git 仅存储之前已存的同一份文件的链接。

下面的图片显示了 git 随着时间变化如何存储数据，其中每个『版本』都是一个 commit：

![](https://i.stack.imgur.com/AQ5TG.png)

## 为什么 commit 信息很重要？

- 加快和简化代码审查
- 帮助理解代码变更
- 协助解释仅靠代码无法完全描述的『为什么』
- 帮助未来的维护者明白变更的原因以及如何变更，使故障排查和调试更容易

为了最大化这些好处，我们可以使用下一节描述的一些好的实践和标准。

## 好的实践

这些是从我的经验、网络文章和其他指南中收集的一些实践案列。如果您有其他实践(或有不同意见)，请尽管随时打开 Pull 请求并贡献您的意见。

### 使用必要的形式

```
# 好示例
Use InventoryBackendPool to retrieve inventory backend
```

```
# 坏示例
Used InventoryBackendPool to retrieve inventory backend
```

_但为什么要使用命令式表格?_

一个 Commit 信息描述了提到的变化实际**做了**什么，它的影响，而非做的内容。

[这篇来自 Chris Beams 的优秀文章](https://chris.beams.io/posts/git-commit/) 给我们一个简单的句子，可以帮助我们以命令式表格的形式来书写更好的 commit 信息：

```
If applied, this commit will <commit message>
```

示例:

```
# 好示例
If applied, this commit will use InventoryBackendPool to retrieve inventory backend
```

```
# 坏示例
If applied, this commit will used InventoryBackendPool to retrieve inventory backend
```

### 首字母大写

```
# 好示例
Add `use` method to Credit model
```

```
# 坏示例
add `use` method to Credit model
```

首字母需要被大写的原因是遵守句子开头使用大写字母的语法规则。

这个实践的使用可能因人而异，团队间亦可能不同，甚至不同语言的人群间也会不同。
大写与否，一个重要的点是要保持标准一致并且遵守它。

### 尝试在不必查看源代码的情况下沟通变化内容

```
# 好示例
Add `use` method to Credit model

```

```
# 坏示例
Add `use` method
```

```
# 好示例
Increase left padding between textbox and layout frame
```

```
# 坏示例
Adjust css
```

很多场景中(例子：多次提交、多次变更和重构)这都有助于帮助代码审查者理解代码提交者当时的想法。

### 使用消息体来解释『为什么』、『是什么』、『怎么做』以及附加细节信息

```
# 好示例
修复了 InventoryBackend 子类的方法名

InventoryBackend 派生出的类没有
遵循基类接口

它之所以运行，是因为 cart 以错误地方式
调用了后端实现。
```

```
# 好示例
Cart 中对 credit 与 json 对象间做序列化和反序列化

因两个主要原因将 Credit 实例转化成 dict：

  - Pickle relies on file path for classes and we do not want to break up
    everything if a refactor is needed
  - Dict and built-in types are pickleable by default
```

```
# 好示例
Add `use` method to Credit

Change from namedtuple to class because we need to
setup a new attribute (in_use_amount) with a new value
```

The subject and the body of the messages are separated by a blank line.
Additional blank lines are considered as a part of the message body.

Characters like `-`, `*` and \` are elements that improve readability.

### 避免通用消息或者没有任何上下文的消息

```
# 坏示例
Fix this

Fix stuff

It should work now

Change stuff

Adjust css
```

### 限制字符数量

[推荐](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project#_commit_guidelines)主题使用最多 50 个字符，消息体最多使用 72 个字符。

### 保持语言的一致性

对于项目所有者：选择一个语言并使用该语言书写所有的 commit 信息。理想情况下，它应该匹配代码注释、默认翻译区域（对于做了本地化的应用）等等。

对于项目贡献者：基于已有 commit 历史书写同样语言的 commit 信息。

```
# 好示例
ababab Add `use` method to Credit model
efefef Use InventoryBackendPool to retrieve inventory backend
bebebe Fix method name of InventoryBackend child classes
```

```
# 好示例 (葡萄牙语示例)
ababab Adiciona o método `use` ao model Credit
efefef Usa o InventoryBackendPool para recuperar o backend de estoque
bebebe Corrige nome de método na classe InventoryBackend
```

```
# 坏示例 (混合了英语和葡萄牙语)
ababab Usa o InventoryBackendPool para recuperar o backend de estoque
efefef Add `use` method to Credit model
cdcdcd Agora vai
```

### 样板

这是一个样板, [由 Tim Pope 编写](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html), 出现在文章[_高级 Git 手册_](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project).

```
简化变更内容到 50 字符左右或者更少

More detailed explanatory text, if necessary. Wrap it to about 72
characters or so. In some contexts, the first line is treated as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical (unless
you omit the body entirely); various tools like `log`, `shortlog`
and `rebase` can get confused if you run the two together.

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other unintuitive consequences of this
change? Here's the place to explain them.

Further paragraphs come after blank lines.

 - Bullet points are okay, too

 - Typically a hyphen or asterisk is used for the bullet, preceded
   by a single space, with blank lines in between, but conventions
   vary here

If you use an issue tracker, put references to them at the bottom,
like this:

Resolves: #123
See also: #456, #789
```

## 变基与合并

这节是 Atlassian 优秀教程中的一个 **TL;DR** ， [『合并与变基』](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)。

![](https://wac-cdn.atlassian.com/dam/jcr:01b0b04e-64f3-4659-af21-c4d86bc7cb0b/01.svg?cdnVersion=hq)

### 变基

**TL;DR:** 把你的分支中的 commit 一个接一个地应用到 base 分支，生成一个新树。

![](https://wac-cdn.atlassian.com/dam/jcr:5b153a22-38be-40d0-aec8-5f2fffc771e5/03.svg?cdnVersion=hq)

### 合并

**TL;DR:** 使用两个分支间的差异，创建新的 commit，称作（适当地）_合并提交_。

![](https://wac-cdn.atlassian.com/dam/jcr:e229fef6-2c2f-4a4f-b270-e1e1baa94055/02.svg?cdnVersion=hq)

### 为什么有些人更倾向于合并时变基？

我尤其更倾向于合并时变基，理由包含：

* 它生成了一个『整洁的』提交历史，没有不必要的合并 commit。
* _所见即所得_, 举例, 在一次代码审查中，所有的变更来自对应某种特殊化的标注的 commit，避免了来隐藏在合并 commit 中的变更。
* 更多的合并被提交者解决，并且每个合并变化对应着具备合适信息的 commit。
    * 对合并类 commit 做挖掘和审核并不常见，因此避免这类操作可以确保所有的变更都归属于某个 commit。

### 何时做 squash？

『Squashing』是处理一系列 commit 的过程，将它们压缩为一个 commit。

它在多种情况下都有用，例子：

- 减少包含少量或者没有上下文的 commit（错误修正、格式化、遗忘的内容）
- Joining separate changes that make more sense when applied together将某些合并应用时更合理的独立变更结合起来
- 重写 _正在进行中_ 这类 commit

### 何时避免 merge 和 squash？

Avoid rebase and squash in public commits or in shared branches where multiple people work on.
Rebase and squash rewrite history and overwrite existing commits, doing it on commits that are on shared branches (i.e., commits pushed to a remote repository or that comes from others branches) can cause confusion and people may lose their changes (both locally and remotely) because of divergent trees and conflicts.

## 有用的 git 命令

### rebase -i

使用它来压制 commit，编辑信息，重写/删除/重新排序 commit，等等。

```
pick 002a7cc Improve description and update document title
pick 897f66d Add contributing section
pick e9549cf Add a section of Available languages
pick ec003aa Add "What is a commit" section"
pick bbe5361 Add source referencing as a point of help wanted
pick b71115e Add a section explaining the importance of commit messages
pick 669bf2b Add "Good practices" section
pick d8340d7 Add capitalization of first letter practice
pick 925f42b Add a practice to encourage good descriptions
pick be05171 Add a section showing good uses of message body
pick d115bb8 Add generic messages and column limit sections
pick 1693840 Add a section about language consistency
pick 80c5f47 Add commit message template
pick 8827962 Fix triple "m" typo
pick 9b81c72 Add "Rebase vs Merge" section

# Rebase 9e6dc75..9b81c72 onto 9e6dc75 (15 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into the previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

#### fixup

Use it to clean up commits easily and without needing a more complex rebase.使用它
[This article](http://fle.github.io/git-tip-keep-your-branch-clean-with-fixup-and-autosquash.html) has very good examples of how and when to do it.

### cherry-pick

It is very useful to apply that commit you made on the wrong branch, without the need to code it again.

Example:

```
$ git cherry-pick 790ab21
[master 094d820] Fix English grammar in Contributing
 Date: Sun Feb 25 23:14:23 2018 -0300
 1 file changed, 1 insertion(+), 1 deletion(-)
```

### add/checkout/reset [--patch | -p]

Let's say we have the following diff:

```diff
diff --git a/README.md b/README.md
index 7b45277..6b1993c 100644
--- a/README.md
+++ b/README.md
@@ -186,10 +186,13 @@ bebebe Corrige nome de método na classe InventoryBackend
 ``
 # 坏示例 (mixes English and Portuguese)
 ababab Usa o InventoryBackendPool para recuperar o backend de estoque
-efefef Add `use` method to Credit model
 cdcdcd Agora vai
 ``

+### 样板
+
+这是一个样板, [由 Tim Pope 编写](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html), 出现在文章[_高级 Git 手册_](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project).
+
 ## 贡献者

 Any kind of help would be appreciated. Example of topics that you can help me with:
@@ -202,3 +205,4 @@ Any kind of help would be appreciated. Example of topics that you can help me wi

 - [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)
 - [Pro Git Book - Commit guidelines](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project#_commit_guidelines)
+- [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
```

We can use `git add -p` to add only the patches we want to, without the need to change the code that is already written.
It's useful to split a big change into smaller commits or to reset/checkout specific changes.

```
Stage this hunk [y,n,q,a,d,/,j,J,g,s,e,?]? s
Split into 2 hunks.
```

#### 代码块 1

```diff
@@ -186,7 +186,6 @@
 ``
 # 坏示例 (mixes English and Portuguese)
 ababab Usa o InventoryBackendPool para recuperar o backend de estoque
-efefef Add `use` method to Credit model
 cdcdcd Agora vai
 ``

Stage this hunk [y,n,q,a,d,/,j,J,g,e,?]?
```

#### 代码块 2

```diff
@@ -190,6 +189,10 @@
 ``
 cdcdcd Agora vai
 ``

+### 样板
+
+这是一个样板, [由 Tim Pope 编写](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html), 出现在文章 [_高级 Git 手册_](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)。
+
 ## 贡献

感谢任何形式的帮助，可以帮到我的主题示例：
Stage this hunk [y,n,q,a,d,/,K,j,J,g,e,?]?
```

#### 代码块 3

```diff
@@ -202,3 +205,4 @@ 感谢任何形式的帮助，可以帮到我的主题示例：

 - [如何书写 Git 的 Commit 信息](https://chris.beams.io/posts/git-commit/)
 - [高级 Git 手册 —— Commit 指导](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project#_commit_guidelines)
+- [关于 Git 的 Commit 信息的注意事项](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
```

## 其他有趣的东西

https://whatthecommit.com/

## 喜欢吗？

[Say thanks!](https://saythanks.io/to/RomuloOliveira)

## 贡献

感谢任何形式的帮助，可以帮到我的主题示例：

- 语法和拼写更正
- 翻译和其他语言
- 参考来源的提升
- 不正确和不完备的信息

## 灵感、来源和进一步阅读材料

- [如何书写 Git 的 Commit 信息](https://chris.beams.io/posts/git-commit/)
- [高级 Git 手册 —— Commit 指导](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project#_commit_guidelines)
- [关于 Git 的 Commit 信息的注意事项](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- [合并与变基](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
- [高级 Git 手册 —— 重写历史](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
