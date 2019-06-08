> * 原文地址：[Trick Out Your Terminal in 10 Minutes or Less](https://towardsdatascience.com/trick-out-your-terminal-in-10-minutes-or-less-ba1e0177b7df)
> * 原文作者：[Anne Bonner](https://medium.com/@annebonner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/trick-out-your-terminal-in-10-minutes-or-less.md](https://github.com/xitu/gold-miner/blob/master/TODO1/trick-out-your-terminal-in-10-minutes-or-less.md)
> * 译者：lihaobhsfer
> * 校对者：

# 不到10分钟，让你的终端变好看

> 如何在几分钟内设置出一个更好、更快、更强、更性感的终端

![Image by [khamkhor](https://pixabay.com/users/khamkhor-3614842/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3510850) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3510850)](https://cdn-images-1.medium.com/max/3840/1*13Yt-tL66o7n-jwSTiLefA.jpeg)

**盯着终端的时间无需是痛苦的**

不需要花太多时间或经历，你就可以把终端从一个令人绝望的白色方块转变成一个漂亮、快速、有趣、好用的强大工具。

终端是一个非常棒的工具。你可以在那里面运行整个世界。何必浪费时间在你不感到那么心潮澎湃的事情上呢？

当你刚开始你的编程旅程时，你很快会发现，你会花**很多**时间使用终端。你可能想成为一个程序员或者开发者，或者对人工智能、机器学习、数据科学，或者任何其他一种职业生涯感兴趣。无论你选择那条路，花几分钟时间适应终端、把它变成一个让你感到愉悦的地方都不失为一个好主意。

> 如何你在使用 Mac，是个编程新手，并痛恨那个空空如也的白色方框，那么，这就是你的菜。

![摄影师 [Nicola Gypsicola](https://unsplash.com/@nicolagypsicola?utm_source=medium&utm_medium=referral) 于 [Unsplash 平台](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9792/0*xky7cW4UjPinIF1S)

#### 内置的 Mac 终端

如果你有 Mac，你就已经有了一个终端窗口，感谢上苍！但即使在它上面做一些基本定制，你也不想每天盯着它看很长时间：

![](https://cdn-images-1.medium.com/max/2952/1*IWG_NGwb9448sTZ4hd_idA.png)

它就在那，它能运行、功能齐全，这已经很好了。但是，几乎不用花费任何精力，你就可以把你的终端变成一个你用着的时候感到很高兴的东西，它能让你的人生变得更简单。

#### Terminal vs. iTerm

你不是必须用 Terminal！有一个大大改进了的终端应用叫做 [iTerm](https://www.iterm2.com/downloads.html)，它更易于定制，有着非常多很酷的特性。你可以在里面搜索，你可以分栏显示。你可以做许许多多你甚至之前都没想到过的事情。

并且你可以把它变得非常性感、非常容易使用，无需费太多力气！

![](https://cdn-images-1.medium.com/max/3078/1*T35YHM5YVwRY26Y7voJubQ.png)

直接去[官网](https://www.iterm2.com)然后点那个大大的下载按钮。下载完成后，像任何其他应用一样打开并安装它。（如果你感兴趣，你可以点[这里](https://www.iterm2.com/version3.html)看看 iTerm3 的下载链接）

![](https://cdn-images-1.medium.com/max/4776/1*S6ZiopaexKNCNaSGvTU3Hw.png)

一开始你看到的窗口长这样：

![](https://cdn-images-1.medium.com/max/5564/1*dqIkqInvfJE17smbf6uoxg.png)

> 我们才刚刚开始

#### 取消显示登录

你可能并不喜欢每次打开终端时“最近登录”的那条信息。使用下面这条命令拜托它。

```
touch ~/.hushlogin
```

#### 获取一些不错的下载

> 需要注意，要让你的修改生效，可能需要关闭再重新打开终端。
>
> 如果你看不到你所做的修改，请关掉终端窗口再打开一个新的。

#### Homebrew

[Homebrew](https://brew.sh/) 是你装备库中要有的上好装备之一。他们称自己为“Mac OS 里那个缺失的包管理器”，他们不是在开玩笑。他们帮你安装苹果公司没有为你装好的东西。

运行以下命令以安装 Homebrew

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

它会停住并告诉你他在安装东西的时候到底在做什么。这一指令非常有用，我强力推荐。Homebrew 是我们的救世主。

#### Zsh

默认的 shell 是 bash，如果你想继续使用它也完全可以。但是 [Zsh](http://zsh.org/) 更加可定制，并有着运行更快的声誉。[Zsh](http://zsh.org/) 做的一件很酷的事情是自动补全。任何时候，你可以敲 `git c` 再按 tab 键，然后你就会看到一个提供了自动补全建议的帮助窗口。

![](https://cdn-images-1.medium.com/max/2304/1*cMHcc4NBWhuakaGW526wyw.png)

并且，Zsh 有一些非常好的不能错过的插件。它也是 Mac 预置的，但是版本似乎永远处在过时状态，所以你需要运行：

```
brew install zsh
```

#### Oh-My-Zsh

喜欢 Zsh？你需要安装 [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh)！它是一个开源的框架，有着上千帮助、函数、插件和主题，用于管理你的 Zsh 配置。运行如下命令以下载：

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### 插件

你可以在这里找到[完整的官方插件列表](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)。它们即装即用，你只需要在你的 `~/.zshrc` 文件中启用它们。（先不要走开，这比听上去简单很多！）

要看都有什么是立即可用的，请跳转到 [插件页](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)。找一找所有的不需费力即可安装的插件。你会想要安装 Git，Github，Python，Sublime，VSCode，或者任何让你人生变得容易的工具。

你一定会想要 Z。

添加插件非常容易，但是如果你是个终端新手，那些说明可能不太好理解。如果你想做一些像这样的修改，你需要编辑 `~/.zshrc` 文件。听上去很复杂，但实际上并不是！运行如下命令以打开文件：

```
open ~/.zshrc
```

![](https://cdn-images-1.medium.com/max/5764/1*t6dR5kpaYvhUqUBfMZlQOQ.png)

这就会打开你要修改的文件。**一定要善待这个文件**。修改里面的内容会影响事情如何（或者到底会不会）运行。

当你滚动鼠标浏览这个文件时，你会发现有一些行可以通过取消注释修改。你也会发现一些空白处供你添加自己的修改。

想要添加或删除插件？向下滚动到这一部分：

```
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)
```

> 看上去，他们想让这变得简单！

现在即可添加你想用的插件了。比如，把最后一行修改成

```
plugins=(git z github history osx pip pyenv pylint python sublime vscode)
```

保存文件，一切就绪！

#### 语法高亮

你需要 Zsh 语法高亮。它会告诉在你运行指令之前告诉你指令是否有效。这很方便。

要启用语法高亮，运行

```
cd ~/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

然后运行如下指令以启用它

```
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

重启终端让你的修改生效。

#### Z

我很爱 Z。非常非常非常爱！Z 让我们更上一层楼。它让使用终端变得非常简单！运行如下命令安装它：

```
brew install z
```

（希望你已经把 Z 加进了插件列表）

Z 非常棒，非常聪明。如果你一直敲下面这样的命令：

```
cd this/is/the/path/to/the_file/ThisOne
```

现在你可以敲：

```
z thisone
```

然后你就到了那个目录！你只需做几次平常做的操作，Z 就会记住你喜欢做什么，然后你就像有了氮气加速。

举个例子，你经常要跳转到你的 “Repos” 文件夹。在所有目录下敲 `cd repos` 都不太可能会生效。

![](https://cdn-images-1.medium.com/max/2592/1*PZy0iqA2A9Q6UIHiY1DYvg.png)

但是你现在可以直接敲 `z repos` 然后立刻就能从任意位置跳转到那个目录！

![](https://cdn-images-1.medium.com/max/2592/1*iZzK-Xm6XePLpSUadeC8cw.png)

#### Sublime Text

如果你的主要文本编辑器是 [Sublime Text](https://www.sublimetext.com/)，你可以设置一个 Sublime 快捷键让人生变得简单。这样，任何时候你想用 Sublime 打开一个文件（或者创建一个新文件并用 Sublime 打开），你可以用 `subl` 这一指令。

如果你想创建并打开一个名为 `test.txt` 的新文件，可以敲：

```
subl test.txt
```

这会打开 Sublime 并创建一个全新的、名为 `test.txt` 的文本文件。

![](https://cdn-images-1.medium.com/max/2592/1*EPVtMSki6OGGUG7xQ67SoQ.png)

在 Mac 的 Zsh 中，[这是我找到的在让它奏效的最简单的办法](https://gist.github.com/barnes7td/3804534)。首先**请确认你的 Sublime Text 是安装在应用程序文件夹中**。让这个指令生效，运行如下命令，以在 `~/bin` 下创建一个新目录：

```
mkdir ~/bin
```

然后运行这个：

```
ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" ~/bin/subl
```

然后运行下面这行命令来在 `~/.zshrc` 文件中添加一行：

```
echo 'export PATH=$PATH:$HOME/bin' >> ~/.zshrc
```

然后用下面这行命令设置 Sublime 为你的默认编辑器：

```
echo "export EDITOR='subl' -w" >> ~/.zshrc
```

重启终端后，使用如下命令来测试这一快捷方式是否生效：

```
subl .
```

这应该会为立即你打开 Sublime！

#### 让我们把它变得更美观

虽然有非常多可用的主题来修改终端窗口的外观，你可能想从简单的开始。

打开 iTerm，在菜单栏中 iTerm 一栏中点击 “偏好设置”。这会弹出一个有很多选择的窗口。在“Colors”标签中，你可以选择你喜欢的颜色，或者用“Color Presets”下拉菜单中的一个选项。你可以选择一个暗色主题，或者选一些简单的颜色。在“Text”标签下可以修改字体和字号也很容易。

你也可以在任何时候导入别的主题。我在用 **Atom** 颜色主题，不过你有成千上万种选择。在 [这个 Github 仓库](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes) 看看一些例子。

如果你想安装一个自定义的 iTerm 主题，直接去 [这个 Github 仓库](https://github.com/mbadolato/iTerm2-Color-Schemes) 然后点击顶部的图标来下载主题。（我直接下载了 zip 文件，下载好之后，双击以解压缩它）

![](https://cdn-images-1.medium.com/max/4750/1*aOffDydw0Gr-qO4M6BZ39w.png)

下一步，去“偏好设置“，点击 ”Colors“ 标签然后在 ”Color Presets“ 下拉菜单中点击 ”Import“。这能让你选择你想用的颜色设置。它会弹出一个访达窗口。如果你想用 Atom 主题，可以在你下载了的那个文件夹中，去 `schemes` 文件夹里，然后选择 `Atom.itermcolors`，然后点”打开“。

![](https://cdn-images-1.medium.com/max/2880/1*NB6Xu0uTYkh1ATEHK6E_KA.png)

然后就可以从下拉菜单中选择 ”Atom“ 了！

![](https://cdn-images-1.medium.com/max/NaN/1*Y3Xak-agj0Nr1NaOG6_iPw.png)

如果你想改字体或字号，去 ”Text“ 那个标签中，然后点击 ”Change Font“ 来做调整。

![](https://cdn-images-1.medium.com/max/4752/1*VQUAxh01edXPx-r9N-kv0g.png)

14 号的 Monaco 看上去令人愉悦。

你也可以轻易调整窗口的透明度。你可能想留意一下终端窗口后面运行这个东西。你可能是个编程新手，并想要确保你仔细地跟着教程走。这样就会很有帮助！

去 ”Window“ 菜单，调整 ”Transparency“ 下的滑动条，找到你觉得合适的透明度。

![](https://cdn-images-1.medium.com/max/NaN/1*boCIYhyPwYZcnCKr69YQNw.png)

#### 做你想做的事情

永远不要忘了：**你的地盘你做主**。让你的世界变得酷起来吧！这篇文章仅仅是触及了你能做的所有事情的表面。想要自定义你的终端，实际上有无限种方法。

玩得开心！

如果你搞出了一个让你心满意足的终端配置，在下面的评论中让大家看一看吧！和往常一样，任何时候都欢迎在领英上与我联系 [@annebonnerdata](https://www.linkedin.com/in/annebonnerdata/)。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
