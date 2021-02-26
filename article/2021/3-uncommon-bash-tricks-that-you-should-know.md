> * 原文地址：[3 Uncommon Bash Tricks That You Should Know](https://medium.com/better-programming/3-uncommon-bash-tricks-that-you-should-know-c0fc988065c7)
> * 原文作者：[Adam Green](https://medium.com/@adgefficiency)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/3-uncommon-bash-tricks-that-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/3-uncommon-bash-tricks-that-you-should-know.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[flashhu](https://github.com/flashhu)、[plusmultiply0](https://github.com/plusmultiply0)

# 3 个鲜为人知的 Bash 技巧

![图源 Matera，摄于意大利](https://cdn-images-1.medium.com/max/4000/0*-UdH52A57htDgdu0.png)

优秀的开发人员往往键入的内容更少 —— 这也让他们能够：

* 更快地工作
* 更准确地工作
* 减少错误
* 减轻双手疲劳的压力

一种减少键入的方法是恰当地使用你的命令行（通常是 Bash），**而本文将要向大家介绍的内容就是 —— 3 个减少键入的 Bash 技巧。**

本文中介绍的 3 个 Bash 技巧是：

1. 使用 `{a,b}` —— 扩展参数，以避免再次键入单个命令
2. 使用 `$_` —— 访问最后一个参数，以避免从最后一个命令中重新键入
3. 使用 `^old^new` —— 快速更改最后一条命令的一部分

所有这些技巧都与 zsh 兼容。

**本文输入的命令均以 `$` 开头。对于命令行解析后的代码，我将在相关代码下面以不带 `$` 的单独一行写出这句代码等同的解析后的代码。**

## `{a,b}` 拓展参数

当我们在编写命令时，我们常会重复输入同一个命令。

以更改文件后缀为例，我们一般使用的是 `mv`：

```bash
$ mv README.txt README.md
```

注意到我们写了两次 README，而参数扩展就可以避免这种重复 —— 更改文件的后缀而无需输入 README 两次：

```bash
$ mv README.{txt,md}
mv README.txt README.md
```

我们使用的参数扩展为 `{txt,md}`，而它将会扩展为两个参数 —— `txt md`（会以空格分隔）。

**参数扩展会为花括号内，以逗号分割的每个元素分别创建一个参数：**

```bash
$ echo {1,2,3}
1 2 3

$ echo pre{1,2,3}
pre1 pre2 pre3
```

空元素将创建不带任何替换项的参数：

```bash
$ echo pre{,1,2}fix
prefix pre1fix pre2fix
```

另一个例子 —— 我们将要把 `data` 文件夹中的 `models` 文件夹重命名为 `ml`：

```bash
$ mv data/models data/ml
```

我们可以使用参数扩展来节省重新输入 `data/`  的时间：

```bash
$ mv data/{models,ml}
mv data/models data/ml
```

我们可以使用带有数字序列的参数扩展 —— 这在创建顺序编号目录时很有用：

```bash
$ mkdir data{0..2}
mkdir data0 data1 data2
```

我们还可以在**参数内部进行参数扩展** —— 例如，更改路径中的文件夹名称：

```bash
$ cat models/{baseline,final}/data.csv
cat models/baseline/data.csv models/final/data.csv
```

最后一个示例：在 `mv` 命令中，我们使用了 3 个参数 —— 将两个 Python 文件移动到 tests 文件夹中：

```bash
$ mv test_unit.py test_system.py tests
```

### 小结

**每当你在单个命令中多次键入某些内容时，参数扩展极大可能可以帮助你节省精力。**

## 使用 `$_` 使用访问最后一个参数

终端由一系列命令操作构成，而我们经常在多个命令之间重用信息。

如果说我们前面的技巧，参数扩展，是用于减少在单个命令上的键入的。那么现在这个技巧则是用于减少对多个命令的键入。

以创建文件夹并将当前目录转移到其中的情况为例：

```bash
$ mkdir temp
$ cd temp
```

现在我们其实可以通过使用 `$_` **将上个命令的参数传递过来**，避免让自己重复键入同样的内容：

```bash	
$ mkdir temp	
$ cd $_	
cd temp	
```	

上面的代码中，我们使用了 `$_` 访问上一个命令的最后一个参数，在本例中这个参数为 `temp`。

想要重用上一个命令的最后一个参数（本例中为 `temp`）的场景其实非常普遍，以至于 Bash 会将其存储在一个特殊的变量 `_` 中。我们需要使用 `$` 前缀来访问它（与 `$PATH` 或 `$HOME` 相同）。

下面是使用 `$_` 的另一个示例 —— 移动文件并借助 `cat` 使用打印内容到 `STDOUT`：

```bash
$ mv main.py src/main.py 
$ cat src/main.py
```

那么现在我们该如何再次重用最后一个参数 `src/main.py`？

你可以使用以下命令重写此代码，`$_` 在第二个命令中会自动替换为 `src/main.py`：

```bash
$ mv main.py src/main.py 
$ cat $_
cat src/main.py
```

使用 `$_` 意味着你不需要重写复杂的文件路径，从而不会在重新键入时出错。

### 小结

**每当你需要在多个命令重复键入某些内容时，使用 `$_` 可能有助于减轻疲惫的双手的压力。**

## 使用 `^old^new` 快速替换

有时，我们可能在命令行管理程序中运行了一个命令，并很快意识到自己在命令中犯了一个错误。

但其实我们无需再次键入命令，我们可以使用快速替换，通过更换上一个命令中的内容来修复错误。

举个例子 —— 你希望通过 ssh 连接到服务器，并运行了命令去连接 —— 运行后才意识到用户名应该是 user 而非 ubuntu！

```bash
$ ssh ubuntu@198.compute.com
```

你可以**使用快速替换来更改所需的部分**，而不必再次重新键入整个命令以在此处将 ubuntu 改为 user：

```bash
$ ^ubuntu^user
ssh user@198.compute.com
```

快速替换的格式是 `^old^new`，等效于：

```bash
$ !!:s/old/new
```

`!!` 用于获取最后一个命令，而 `:s` 是替换的正则表达式。我想你会同意 `^old^new` 减轻了不少工作负担！

### 小结

**当你写错了命令，并且命令不方便重写（例如很长），那么，使用 `^old^new` 能够极大的减轻你的麻烦。**

---

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
