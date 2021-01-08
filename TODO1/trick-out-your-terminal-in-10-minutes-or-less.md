> * 原文地址：[Trick Out Your Terminal in 10 Minutes or Less](https://towardsdatascience.com/trick-out-your-terminal-in-10-minutes-or-less-ba1e0177b7df)
> * 原文作者：[Anne Bonner](https://medium.com/@annebonner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/trick-out-your-terminal-in-10-minutes-or-less.md](https://github.com/xitu/gold-miner/blob/master/TODO1/trick-out-your-terminal-in-10-minutes-or-less.md)
> * 译者：[lihaobhsfer](https://github.com/lihaobhsfer)
> * 校对者：[Wangalan30](https://github.com/Wangalan30), [Baddyo](https://github.com/Baddyo)

# 10 分钟爆改终端

> 如何在几分钟内打造出一个更好、更快、更强、更性感的终端

![图片来自于 [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3510850) 摄影：[khamkhor](https://pixabay.com/users/khamkhor-3614842/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3510850)](https://cdn-images-1.medium.com/max/3840/1*13Yt-tL66o7n-jwSTiLefA.jpeg)

**让你看着自己的终端时不再痛苦**

无需花费太多的时间和精力，你就能将你的终端从一个难看的白块变成一个美观、流畅、有趣又实用的强大工具。

终端是一个非常棒的工具。你可以在那里面运行整个世界。何必把时间浪费在一个你并不喜欢的工具上呢？

当你刚开始你的编程旅程时，你很快会发现，你会花**很多**时间使用终端。你可能想成为一个程序员或者开发者，或者对人工智能、机器学习、数据科学，或者任何其他一种职业生涯感兴趣。无论你选择哪条路，你都该花几分钟，适应你的终端，让它变得得心应手。

> 如果你是个使用 Mac 的编程新手，而且讨厌那个空白的白框，那么，你的救星来了。

![图片来自于 [Unsplash 平台](https://unsplash.com?utm_source=medium&utm_medium=referral) 摄影：[Nicola Gypsicola](https://unsplash.com/@nicolagypsicola?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9792/0*xky7cW4UjPinIF1S)

#### 内置的 Mac 终端

如果你有一台 Mac，那么你就已经有了一个终端窗口。即使你已经做了一些基础的自定义，但你一定不想整天盯着这个硕大的白框：

![](https://cdn-images-1.medium.com/max/2952/1*IWG_NGwb9448sTZ4hd_idA.png)

它就在那，它能运行、功能齐全，这已经很好了。但是，几乎不用花费任何精力，你就可以把你的终端变成一个你乐于使用的工具，它能让你的人生变得更简单。

#### Terminal vs. iTerm

你不是必须用 Terminal！这里有一个大幅改良过的终端应用，叫做 [iTerm](https://www.iterm2.com/downloads.html)，它更易于定制，有着非常多很酷的特性。你可以在里面搜索，你可以分栏显示。你可以做许许多多你甚至之前都没想到过的事情。

你可以把它变得十分性感、实用，且无需花费太多力气！

![](https://cdn-images-1.medium.com/max/3078/1*T35YHM5YVwRY26Y7voJubQ.png)

直接去[官网](https://www.iterm2.com)，然后点那个大大的下载按钮。下载完成后，像任何其他应用一样打开并安装它。（如果你感兴趣，你可以点[这里](https://www.iterm2.com/version3.html)查看 iTerm3 的下载链接）

![](https://cdn-images-1.medium.com/max/4776/1*S6ZiopaexKNCNaSGvTU3Hw.png)

一开始你看到的窗口长这样：

![](https://cdn-images-1.medium.com/max/5564/1*dqIkqInvfJE17smbf6uoxg.png)

> 我们才刚刚开始。

#### 取消显示登录

你可能并不想看到每次打开终端时显示的那条“最近登录”的消息。执行下面这条命令关掉它：

```
touch ~/.hushlogin
```

#### 下载些不错的东西

> 注意，为使修改生效，你可能需要关闭并重启终端。
>
> 如果看不到修改效果，关掉终端并重开一个试试。

#### Homebrew

[Homebrew](https://brew.sh/) 是你装备库中的必备神器之一。他们称自己为 “Mac OS 里那个缺失的包管理器”，他们不是在开玩笑。它们可以为你安装那些你需要但 Apple 没有为你安装的东西。

运行以下命令以安装 Homebrew

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

它会暂停并告诉你它的安装进程。这一指令非常有用，我强力推荐。Homebrew 是我们的救世主。

#### Zsh

默认的 shell 是 bash，如果你想继续使用它也完全可以。但是 [Zsh](http://zsh.org/) 更加可定制，并有着运行更快的声誉。[Zsh](http://zsh.org/) 做的一件很酷的事情是自动补全。任何时候，你可以敲 `git c` 再按 tab 键，然后你就会看到一个提供了自动补全建议的帮助窗口。

![](https://cdn-images-1.medium.com/max/2304/1*cMHcc4NBWhuakaGW526wyw.png)

并且，Zsh 有一些很棒的插件，你一定不想错过。它也是 Mac 预置的，但总是不能自动更新到最新版，所以你需要运行：

```
brew install zsh
```

#### Oh-My-Zsh

喜欢 Zsh？那你一定要安装 [Oh-My-Zsh](https://github.com/robbyrussell/oh-my-zsh)！它是一个开源的框架，有着上千帮助、函数、插件和主题，用于管理你的 Zsh 配置。运行如下命令以下载：

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### 插件

你可以在这里找到[完整的官方插件列表](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)。它们即装即用，你只需要在你的 `~/.zshrc` 文件中启用它们。（先不要走开，这比听上去简单很多！）

要看都有什么是立即可用的，请跳转到[插件页](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)。向下滑动可以查看有什么你可以即装即用的插件。你可能会需要 Git、Github、Python、Sublime、VSCode，或者其他更方便实用的工具。

你一定会想要安装插件 Z。

添加插件非常容易，但是如果你是个终端新手，那些说明可能不太好理解。如果你想做一些像这样的修改，你需要编辑 `~/.zshrc` 文件。这听上去很复杂，但实际上很简单。运行如下命令以打开文件：

```
open ~/.zshrc
```

![](https://cdn-images-1.medium.com/max/5764/1*t6dR5kpaYvhUqUBfMZlQOQ.png)

这就会打开你要修改的文件。**一定要善待这个文件**。这里的任何修改都会影响最终的运行。

当你滚动鼠标浏览这个文件时，你会发现可以通过取消注释来修改一些配置。你也可以在空白处添加自己的修改。

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

你需要 Zsh 语法高亮功能。它会在运行前告诉你指令是否有效。这很方便。

要启用语法高亮，运行

```
cd ~/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

然后运行如下指令以启用它

```
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

重启终端使修改生效。

#### Z

我很爱 Z 插件。非常非常非常爱！Z 插件让我们更上一层楼。它让使用终端变得非常简单！运行如下命令安装它：

```
brew install z
```

（希望你已经添加了 Z 插件。）

Z 非常棒，非常聪明。如果你一直敲下面这样的完整路径：

```
cd this/is/the/path/to/the_file/ThisOne
```

现在你可以这样敲：

```
z thisone
```

这样你就可以到达这个目录！你只需几次平常操作，Z 就会知道你喜欢做什么，接下来，你就省事儿了。

举个例子，如果你经常需要访问 “Repos” 文件夹，随便在哪个目录下敲 `cd repos` 都不太可能会生效。

![](https://cdn-images-1.medium.com/max/2592/1*PZy0iqA2A9Q6UIHiY1DYvg.png)

但是你现在可以直接敲 `z repos` 然后立刻就能从任意位置跳转到那个目录！

![](https://cdn-images-1.medium.com/max/2592/1*iZzK-Xm6XePLpSUadeC8cw.png)

#### Sublime Text

如果你的首选文本编辑器是 [Sublime Text](https://www.sublimetext.com/)，你可以设置一个 Sublime 的快捷方式来简化这个过程。这样的话，每当你要用 Sublime 打开一个文件（或创建一个新文件并用 Sublime 打开）时，你便可以用 `subl` 这一指令。

如果你想创建一个名为 `test.txt` 的新文件，并用 `Sublime` 打开它，可以敲：

```
subl test.txt
```

这会打开 Sublime 并创建一个全新的、名为 `test.txt` 的文本文件。

![](https://cdn-images-1.medium.com/max/2592/1*EPVtMSki6OGGUG7xQ67SoQ.png)

在一台有 Zsh 的 Mac 上，[这是我发现的最简方法](https://gist.github.com/barnes7td/3804534)。首先**请确认你的 Sublime Text 是安装在应用程序文件夹中**。让这个指令生效，运行如下命令，以在 `~/bin` 下创建一个新目录：

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

这样可以立即为你打开 Sublime！

#### 我们来把它变得更美观

虽然你有很多的主题可以用来修改你终端窗口的外观，但你也许想从最简单的开始。

打开 iTerm，在菜单栏中 iTerm 一栏中点击“偏好设置”。这会弹出一个有很多选项的窗口。在 “Colors” 标签中，你可以选择你喜欢的颜色，或者你也可以选择 “Color Presets” 下拉菜单中的选项。你可以选择一个暗色主题，或者选一些简单的颜色。在 “Text” 标签下修改字体及字号也很简单。

你随时可以导入你喜欢的主题。我一般使用 Atom 里的颜色方案，当然你也有很多选择。你可以浏览[这个 GitHub 仓库](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes)查看一些示例。

如果你想安装一个自定义的 iTerm 主题，直接去 [这个 GitHub 仓库](https://github.com/mbadolato/iTerm2-Color-Schemes) 然后点击顶部的图标来下载主题。（我直接下载了 zip 文件，下载完成后，双击解压缩）

![](https://cdn-images-1.medium.com/max/4750/1*aOffDydw0Gr-qO4M6BZ39w.png)

下一步，去“偏好设置”，点击 “Colors” 标签然后在 “Color Presets” 下拉菜单中点击 “Import”。你可以在这选择想要的颜色主题。它会弹出一个访达窗口。如果你想用 Atom 主题，可以在你下载了的那个文件夹中，去 `schemes` 文件夹里，然后选择 `Atom.itermcolors`，然后点“打开”。

![](https://cdn-images-1.medium.com/max/2880/1*NB6Xu0uTYkh1ATEHK6E_KA.png)

然后你就可以从下拉菜单中选择 “Atom” 了！

![](https://cdn-images-1.medium.com/max/NaN/1*Y3Xak-agj0Nr1NaOG6_iPw.png)

如果你想改字体或字号，去 “Text” 那个标签中，然后点击 “Change Font” 来做调整。

![](https://cdn-images-1.medium.com/max/4752/1*VQUAxh01edXPx-r9N-kv0g.png)

14 号的 Monaco 看上去不错。

调整窗口透明度也很简单。有时你可能需要留意被覆盖在终端窗口下面的进程。作为一个编程新手，你可能需要确保你的工作严格按照教程在走。那这个功能会对你有所帮助！

去 “Window” 菜单，调整 “Transparency” 下的滑动条，找到你觉得合适的透明度。

![](https://cdn-images-1.medium.com/max/NaN/1*boCIYhyPwYZcnCKr69YQNw.png)

#### 做你想做的事情

永远不要忘了：**你的地盘你做主**。让你的世界变得酷起来吧！这篇文章仅仅介绍了皮毛。想要自定义自己的终端，方法多得是。

玩得开心！

如果你搞出了一个让你心满意足的终端配置，在下面的评论中让大家看一看吧！和往常一样，任欢迎随时在领英上与我联系 [@annebonnerdata](https://www.linkedin.com/in/annebonnerdata/)。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
