> * 原文地址：[The Smart Ways to Correct Mistakes in Git](https://css-tricks.com/the-smart-ways-to-correct-mistakes-in-git/)
> * 原文作者：[Tobias Günther](https://css-tricks.com/author/tobiasgunther/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-smart-ways-to-correct-mistakes-in-git.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-smart-ways-to-correct-mistakes-in-git.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[shixi-li](https://github.com/shixi-li)，[kezhenxu94](https://github.com/kezhenxu94)

# 修改 Git 错误的高明方法

在软件开发的世界，有**无穷无尽**的方法能够把事情搞得一团糟：错删东西，代码混乱，提交信息写错了字，这些都仅仅是冰山一角。

幸运的是，当我们使用版本控制时，Git 提供给我们了一个很完美的安全网。当然啦，不是咱俩需要它，因为我们从来不犯错的，对吧？嗯嗯当然当然。但是为了他人的利益，我们还是一起来看看那些可以拯救我们的 Git “撤回”工具。

### 修改最后提交

搞砸一次提交非常容易。经典的场景包括：提交信息里写了错字。其他的？还有忘记将修改添加到临时区（staging area）。还有很多时候，我们忽然意识到代码中有错误 —— 但是当然是在点击了提交的确认键之后。

幸运的是，Git 让修改最后一次提交这件事出乎意料的简单。假如我们刚刚确认了下面这个命令：

```
git commit -m "Massage full of typohs"
```

并且（好像这个拼写错误还没那么糟糕）假如我们还忘记了添加某个已经修改的文件到临时区。我们可以使用如下两行命令修正这两个错误：

```
git add forgotten-changes.js
​​git commit --amend -m "A sensible message"
```

神奇之处就在于 `--amend​` 标识：当我们跟着 commit 命令使用它的时候，Git 将会修改最后一次提交 —— 添加临时区的修改，并替换为新的说明信息。

但是有一点需要提示：只能在没有推送到远端仓库的提交上使用 `--amend`。原因是 Git 会用修改了的版本**取代原来的**，有错误的提交。这之后，看上去就像是原来的提交从来没有过。是的，这种方式用来处理错误很好，但是必须是当我们还没有将过这个错误**发布**到远端仓库的时候。

### 撤销本地修改

每个人都有类似的经历：用了一早晨的时间寻找解决办法，但是最后只好承认这几个小时就是在浪费时间。必须从头开始了，并且要撤销大部分（或者所有）的代码。

但是这其实是使用 Git 的初衷之一 —— 它能让你不用害怕破坏了什么，而可以随意的尝试不同的方法。

让我们来看一个例子：

```
git status
​​  modified: about.html
​​  deleted:  imprint.html
​​  modified: index.html
```

现在我们假设，这些修改就是在前文说的浪费时间的场景。我们需要撤销 about.html 的修改并且恢复已经删除的 imprint.html。我们现在想要的就是，**丢弃**这些文件当前的更改 —— 但是保留 index.html 中的超赞的已经写好的代码。这时，`git checkout​` 命令就能够有所帮助。但是，我们需要像这样指明是哪些文件：

```
git checkout HEAD about.html imprint.html
```

这行命令将 about.html 和 imprint.html 恢复到了最后提交的状态。哎，我们可以不用熬夜来撤销它们了！

我们可以更进一步，可以在一个修改过的文件里**仅丢弃特定几行代码**，而不是恢复整个文件！我必须承认，在命令行完成这项任务比较复杂，但使用 [像 Tower 这样的 Git 桌面客户端](https://www.git-tower.com/) 则是一个很好的方法：

![](https://css-tricks.com/wp-content/uploads/2019/02/tower-discard-single-lines-2.gif)

在代码**真的**糟透了的时候，我们就想掏出一把大枪：

```
git reset --hard HEAD
```

这次我们不是仅仅使用 `checkout`​ 恢复**指定的**文件，而是重置了**所有修改过的副本**。换句话说，`reset` 将所有项目文件恢复到了最后一次提交的状态。和 `--amend` 类似，使用 `checkout`​ 和 `reset`​ 的时候需要牢记：使用这些命令丢弃的本地修改无法恢复！它们还从来没有被提交到仓库中，所以不能被恢复也是合理的。请确认你真的想要删除它们，因为删除了就没法找回了！

### 撤销并还原更早的提交

很多情况下，我们一段时间后才意识到代码的错误，而它已经被提交到仓库里很久了。

![](https://res.cloudinary.com/css-tricks/image/upload/v1548698897/F9D13FDA-F04C-467F-A910-B944BB7AA196_a71qfi.png)

我们如何才能删除掉这个错误的提交呢？答案是在大多数场景下，我们其实不应该这样做。就算是“撤销”内容的时候，通常情况下 Git 并没有真的删除数据。它**通过添加新的数据来修正内容**。用这个例子，我们来看看它是如何工作的：

```
git revert 2b504bee
```

通过对这个提交执行 `git revert`，我们并没有删除任何东西。相反的是：

![](https://res.cloudinary.com/css-tricks/image/upload/v1548698922/F4BA4EB6-68CB-4ADB-B840-157A0FB094B8_pt0t26.png)

Git 自动创建了一个**新的**提交来**撤销**错误提交所造成的修改。所以，如果我们一开始有三个提交，然后试图修正中间的那个，那么我们就会有四个提交了，新增的那个用来修改 `revert` 的目标提交。

### 恢复项目之前的版本

另一个情境是我们希望恢复到项目之前的版本。我们不是仅仅撤销提交历史中的一个特定的版本，而是想让时间倒流，直接退回到这个版本。
​​  
在下面的场景中，我们声明“C2”之后的所有提交都是**不需要的**。我们想要回到“C2”这次提交的状态，它之后的提交统统删除：

![](https://res.cloudinary.com/css-tricks/image/upload/v1548698945/9F2F3E84-7499-4047-B3A1-812AD45D32A1_qcy0xt.png)

根据我们已经讲述过的内容，我想你已经（至少部分）熟悉了所需的命令：

```
git reset --hard 2b504bee
```

这个命令通知了 `git reset` 我们想要返回的提交的 SHA-1 哈希值。C3 和 C4 提交将会从项目历史中消失。
​​
如果你在使用 Git 客户端，例如 Tower，提交项目的右键菜单中的 `git revert` 和 `git reset` 两者都可以使用：

![](https://res.cloudinary.com/css-tricks/image/upload/v1548699011/23F90DCB-BD37-4948-A309-0682FB961824_lc3t8d.png)

### 删除提交，恢复删除的分支，处理冲突等等

当然，软件项目中还有很多其他会把事情搞砸的方式。但是幸运的是，Git 提供了很多工具来撤销错误。

如果你想要学习本篇文章提到的场景中的更多的内容，或者其他题目，例如如何在分支之间移动提交，删除旧提交，恢复删除的分支，或者优雅的处理冲突，看一下项目 ["Git 急救包"](https://www.git-tower.com/learn/git/first-aid-kit)，它是我和其他一些 Tower 团队的人创建的。这是一份完全免费的教程，包括了 17 个视频以及一份很方便的备忘单，你可以下载并保存到你的设备上。

[![](https://res.cloudinary.com/css-tricks/image/upload/v1548699043/7A41F2B2-96C4-483C-8639-B7A35F305681_vafnlo.png)](https://www.git-tower.com/learn/git/first-aid-kit)

同时，祝你撤销得愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
