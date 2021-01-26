> * 原文地址：[3 Uncommon Bash Tricks That You Should Know](https://medium.com/better-programming/3-uncommon-bash-tricks-that-you-should-know-c0fc988065c7)
> * 原文作者：[Adam Green](https://medium.com/@adgefficiency)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/3-uncommon-bash-tricks-that-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/3-uncommon-bash-tricks-that-you-should-know.md)
> * 译者：想念苏苏的 [PassionPenguin](https://github.com/PassionPenguin)
> * 校对者：


# 你应该知道的 3 个罕见的 Bash 技巧
![图源 Matera，摄于意大利](https://cdn-images-1.medium.com/max/4000/0*-UdH52A57htDgdu0.png)

优秀开发人员键入的内容更少 —— 这让他们：
* 工作更快 
* 更准确地工作
* 减少错误
* 减轻双手疲劳的压力

一种减少键入的方法是恰当地使用你的命令行（通常是 Bash）。**这就是本文章要介绍的 —— 3 个减少键入的 Bash 技巧。**

本文中介绍的 3 个 Bash 技巧是：
1. 使用 `{a,b}` —— 扩展参数，以避免再次键入单个命令
2. 使用 `$_` —— 访问最后一个参数，以避免从最后一个命令中重新键入
3. 使用 `^old^new` —— 快速更改最后一条命令的一部分

所有这些技巧都与 zsh 兼容。
   
**全文输入的命令均以 `$` 开头。对于命令行解析后的代码，我将在相关代码下面显示不带 `$` 的扩展命令。**
   
## `{a,b}` 拓展参数

当我们在编写单个命令时，我们通常会重复输入多次同一个命令。

以更改文件后缀的示例为例，我们可以使用 `mv`：

```bash
$ mv README.txt README.md
```

注意我们写了两次 README，而参数扩展将会避免这种重复 —— 允许我们更改文件的后缀而无需键入 README 两次：

```bash
$ mv README.{txt,md}
mv README.txt README.md
```

我们使用的参数扩展为 `{txt,md}`，而它扩展为两个参数—— `txt md`（以空格分隔）。

**参数扩展会为花括号内的每个元素创建一个参数，而你需要用逗号分隔各个元素：**

```bash
$ echo {1,2,3}
1 2 3

$  echo pre{1,2,3}
pre1fix pre2fix pre3fix
```

空元素将创建不带任何替换项的参数：

```bash
$ echo pre{,1,2}fix
prefix pre1fix pre2fix
```

另一个示例 —— 将 `data` 文件夹中的 `models` 文件夹重命名为文件夹 `ml`：

```bash
$ mv data/models data/ml
```

我们可以使用参数扩展 `data/` 来节省重新输入的时间：

```bash
$ mv data/{models,ml}
mv data/models data/ml
```

我们可以使用带有数字序列的参数扩展 —— 在创建顺序编号目录时候这个技巧很有用：

```bash
$ mkdir data{0..2}
mkdir data0 data1 data2
```

我们还可以在**参数内部进行参数扩展** —— 例如，更改路径中间的文件夹：

```bash
$ cat models/{baseline,final}/data.csv
cat models/baseline/data.csv models/final/data.csv
```

最后一个示例：我们对 `mv` 命令使用了3个参数 —— 将两个 Python 测试文件移动到一个 tests 文件夹中：

```bash
$ mv test_unit.py test_system.py tests
```

#### 小结

**每当你在单个命令中多次键入某些内容时，参数扩展极大可能可以帮助你节省精力。**

## 使用 `$_` 使用访问最后一个参数

终端由一系列命令操作-我们经常在多个命令之间重用信息。

我们前面的技巧，参数扩展，用于减少在单个命令上的键入 —— 现在这个技巧则是用于减少对多个命令的键入。

以制作文件夹并将当前目录转移到其中的简单情况为例：

```bash
$ mkdir temp
$ cd temp
```

上面，我们用于 `$_` 访问上一个命令的最后一个参数，在本例中这个参数为 `temp`。

想要重用上一个命令的最后一个参数（在此处 `temp`）的用例非常普遍，以至于 Bash 将其存储在一个特殊的变量 `_` 中。我们需要使用 `$` 前缀来访问它（与 `$PATH` 或 `$HOME` 相同）。

使用 `$_` 的另一个示例 —— 移动文件并借助 `cat` 使用 `STDOUT` 打印内容：

```bash
$ mv main.py src/main.py 
$ cat src/main.py
```

请注意，我们如何再次重用最后一个参数 `src/main.py`？

你可以使用以下命令重写此代码，`$_` 在第二个命令中会自动替换为 `src/main.py`：

```bash
$ mv main.py src/main.py 
$ cat $_
cat src/main.py
```

使用$_意味着你不需要重写复杂的文件路径，从而没有机会错误地重新键入它。

#### 小结
每当你需要在多个命令重复键入某些内容时，使用 `$_` 可能有助于减轻疲惫的双手的压力。

## `^old^new` 快速替换

有时（在我们的情况下），我们在命令行管理程序中运行了一个命令，并很快意识到自己犯了一个错误。

但其实我们无需再次键入命令，我们可以使用快速替换通过替换上一个命令中的内容来解决错误。

一个例子 —— 你希望通过 ssh 连接到服务器并运行了命令去连接 —— 运行后才意识到应该是 user 而非 ubuntu！

```bash
$ ssh ubuntu@198.compute.com
```

你可以使用快速替换来更改所需的部分，而不必再次重新键入整个命令以在此处将 ubuntu 改为 user：

```bash
$ ^ubuntu^user
ssh user@198.compute.com
```

快速替换的格式是 `^old^new`，等效于：

```bash
$ !!:s/old/new
```

`!!` 用户获取最后一个命令，而 `:s` 是替换的正则表达式。我想你会同意 `^old^new` 稍微容易操作一些！

#### 小结

**每当你通过多个命令多次重新键入某些内容时，使用 `$_` 很有可能可以帮助减轻手破旧时的压力。**

---

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
