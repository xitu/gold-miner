> * 原文地址：[Git Aliases I Use (Because I'm Lazy)](https://victorzhou.com/blog/git-aliases/)
> * 原文作者：[Victor Zhou](https://victorzhou.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/git-aliases.md](https://github.com/xitu/gold-miner/blob/master/TODO1/git-aliases.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[imononoke](https://github.com/imononoke)，[weisiwu](https://github.com/weisiwu)，[portandbridge](https://github.com/portandbridge)

# 我常用的 Git 别名（因为我实在太懒了）

## 我真的很烦输入 git 命令，即使是很短的。

写于 2019 年 9 月 16 日，更新于 2019 年 9 月 17 日

几年前，当我第一次开始构建一些比较大的[个人项目](https://victorzhou.com/about/)时，我终于开始频繁的使用 [Git](https://git-scm.com)。现在，输入 `git status` 和 `git push` 这样的命令对我来说易如反掌，但是如果你有一些使用 Git 的经验，你一定知道有一些命令会非常冗长。

比如说我常遇到这样的命令：

```shell-session
$ git commit --amend --no-edit
```

这条命令会把你暂存的修改并入你最近的一次 commit，并且不会修改这次 commit 的信息（这样 Git 也就不会打开一个文件编辑界面了）。它最经常的用途是修改**刚刚**提交的 commit。也许我太粗心了，总是在刚提交完一条 commit 还不到 30 秒，就发现一个拼写错误或者忘了删除了调式信息了 😠。

输入 `git commit --amend --no-edit` 这 28 个字符很快就会让人感到乏味。我现在正着迷于[优化项目](https://victorzhou.com/tag/performance/)（甚至是[在还不应该进行优化的时候我就开始行动了](https://victorzhou.com/blog/avoid-premature-optimization/)🤷），所以某天我就开始花时间思考如何优化我的 git 命令…

## [](#my-git-aliases)我配置的 git 别名

当你用 google 搜索下如“**简化 git 命令**”这样的内容，你将会很快的找到关于 [Git 别名](https://git-scm.com/book/zh/v2/Git-%E5%9F%BA%E7%A1%80-Git-%E5%88%AB%E5%90%8D)的信息。事实是，简写命令的方法已经内建在 Git 中了！你只需要告知 Git 你想要配置的 git 别名的信息即可。例如，你可以通过将如下这行代码复制粘贴到你的控制台并执行，就可以将 `status` 简写为 `s`：

```text
git config --global alias.s status
```

这行命令实际上是更新了你的 `.gitconfig` 文件，该文件用来保存全局 Git 配置：

##### ~/.gitconfig

```toml
[alias]
  s = status
```

现在，只要你输入别名 `s`，Git 就会自动用 `status` 来替换掉它！

下面这些是我最常用的 Git 别名：

##### ~/.gitconfig

```toml
[alias]
  s = status
  d = diff
  co = checkout
  br = branch
  last = log -1 HEAD
  cane = commit --amend --no-edit
  lo = log --oneline -n 10
  pr = pull --rebase
```

我的 .gitconfig 文件

##### git 别名

```text
git config --global alias.s status
git config --global alias.d diff
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.last "log -1 HEAD"
git config --global alias.cane "commit --amend --no-edit"
git config --global alias.pr "pull --rebase"
git config --global alias.lo "log --oneline -n 10"
```

如果你也想使用这些 git 别名，将这些命令拷贝并粘贴到控制台执行即可！

最后，这儿还有一个我常用的 bash 命令简写：

##### ~/.bash_profile

```bash
# ... 其他内容

alias g=git
```

你可以使用任何编辑器，来将这些内容加入到你的 [.bash_profile](https://www.quora.com/What-is-bash_profile-and-what-is-its-use) 文件中。

这是一个 [Bash 别名配置](https://www.tldp.org/LDP/abs/html/aliases.html)，它的功能就正如你所想的那样。如果你使用其他的 shell，你可以在它的类似的功能中完成（例如 [Zsh 别名配置](http://zsh.sourceforge.net/Intro/intro_8.html)）。

一切就绪。现在你可以这样使用 Git 了：

```shell-session
$ g s
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
```

```shell-session
$ g br
* master
```

```shell-session
$ g co -b new-branch
Switched to a new branch 'new-branch'
```

```shell-session
$ g lo
Author: Victor Zhou <vzhou842@gmail.com>
Date:   Mon Aug 26 01:16:49 2019 -0700

    Bump version to 1.1.1
```

## [](#is-this-actually-useful-though)实际上它们真的有用吗…

也许有用？这其实是因人而异的。如果你和我一样，需要做一些有点强迫症的事情，比如总是习惯性的重复输入 “git status”，那么它确实可以节省你一些时间：

> — [参见 Victor Zhou (@victorczhou) 发布于 2019 年 9 月 15 日的 twitter](https://twitter.com/victorczhou/status/1173059464036962305?ref_src=twsrc%5Etfw)

我个人认为，这样做代价很小（每台新设备的配置大概只需要 30 秒），而你就能够得到一个速度更快并且更有效率的很好的日常体验。当然，**实际上**你能节约多少时间还是值得商榷的…

## [](#some-quick-maths)粗略计算

我们来粗略计算一下配置了 git 别名实际能节约多少时间。我大概可以一分钟输入 135 个单词，我们假设每个单词有 4 个字母，那么就是每秒可以输入

$$
\frac{135 * 4}{60} = \boxed{9}
$$

个字母。

下面这个表格展示了我最常用的简写可以节省的字母数：


| 原始命令 | 简写命令 | 可节省的字母数 |
| --- | --- | --- |
| `git status` | `g s` | 7 |
| `git diff` | `g d` | 5 |
| `git checkout` | `g co` | 8 |
| `git branch` | `g br` | 6 |
| `git log -1 HEAD` | `g last` | 9 |
| `git commit --amend --no-edit` | `g cane` | 20 |

接下来，我使用 [history](https://en.wikipedia.org/wiki/History_(command)) 命令查看了我最近的 500 条命令。这是数据分析：

| 命令 | 使用数量 |
| --- | --- |
| `g s` | 155 |
| `g d` | 47 |
| `g co` | 19 |
| `g br` | 26 |
| `g last` | 11 |
| `g cane` | 2 |
| 其他 Git 命令 | 94 |
| 非 Git 命令 | 146 |

每个“其他 Git 命令”能节省 2 个字母（因为我将 `git` 简写为 `g`），所以总的节省字母是：

| 命令 | 使用次数 | 可节省的字母数 | 总共节省的字母数 |
| --- | --- | --- | --- |
| `g s` | 155 | 7 | 1085 |
| `g d` | 47 | 5 | 235 |
| `g co` | 19 | 8 | 152 |
| `g br` | 26 | 6 | 156 |
| `g last` | 11 | 9 | 99 |
| `g cane` | 2 | 20 | 40 |
| 其他 Git 命令 | 94 | 2 | 188 |

$$
1085 + 235 + \ldots + 40 + 188 = \boxed{1955}
$$

所以一共节省了 1955 个字母，平均每个 Git 命令节省了 $\frac{1955}{354} = \boxed{5.5}$ 个字母。假设我工作日的八小时内输入大约 100 条 Git 命令，也就是可以节约 **550** 个字母，换算也就是**每天可以节约一分钟**（使用我前文提到的每秒输入 9 个字母的数据）。

## [](#ok-so-this-isnt-that-practically-useful-)好吧，所以实际上并没有节省多少时间。 😢

但是我要重申：配置别名能让你**觉得**提高了效率，这可能会给你一些心里暗示的作用，让你真的变得更加高效了。

你怎么看？你会去使用 Git 别名吗？为什么去用或者为什么不用？你还有什么其他喜欢用的别名？欢迎在评论区写下讨论！

**更新**：在 [lobste.rs 的博客](https://lobste.rs/s/klwbnj/git_aliases_i_use_because_i_m_lazy) 和[原文下面的评论区](https://victorzhou.com/blog/git-aliases/#commento)中有一些不错的讨论。推荐你阅读。

## [](#epilogue)结语

当我写这篇博客的时候，我意识到还有三个常用的 Git 命令，但却被我忽略了：

```shell-session
$ git add .
$ git commit -m 'message'
$ git reset --hard
```

我将会把它们也加入到我的 Git 别名配置中！

##### git aliases

```text
git config --global alias.a "add ."
git config --global alias.cm "commit -m"
git config --global alias.rh "reset --hard"
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
