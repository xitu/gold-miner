> * 原文地址：[3 Uncommon Bash Tricks That You Should Know](https://medium.com/better-programming/3-uncommon-bash-tricks-that-you-should-know-c0fc988065c7)
> * 原文作者：[Adam Green](https://medium.com/@adgefficiency)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/3-uncommon-bash-tricks-that-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/3-uncommon-bash-tricks-that-you-should-know.md)
> * 译者：
> * 校对者：

# 3 Uncommon Bash Tricks That You Should Know

#### Type less on the terminal with these underused Bash patterns

![Image by author — Matera, Italy](https://cdn-images-1.medium.com/max/4000/0*-UdH52A57htDgdu0.png)

**Good developers type less** — allowing them to:

* Work faster
* Work more accurately
* Make fewer mistakes
* Reduce stress on their ever-so-tired hands

One way to type less is to make proper use of your shell (commonly Bash). **That’s what this post is about — three Bash tricks that will allow you to type less.**

The three Bash tips covered in this post are:

1. **Parameter expansion** with `{a,b}` — to avoid retyping on a single command
2. **Accessing the last argument** with `$_` — to avoid retyping from the last command
3. **Quick substitution** with `^old^new` — to quickly change part of the last command

All of these tricks are also compatible with zsh.

**This post follows the convention of starting shell commands with a** `$`. **For commands that would be expanded by the shell, I will show the expanded command below without a** `$`.

---

## Parameter Expansion With {a,b}

When writing a single command, it’s common to repeat yourself.

Take the example of changing the suffix on a file, which we can do using `mv`:

```
$ mv README.txt README.md
```

Notice how we write `README` twice?

Parameter expansion will avoid this repetition — allowing us to change the suffix on our file without typing `README` twice:

```
$ mv README.{txt,md}
mv README.txt README.md
```

The parameter expansion we use is `{txt,md}`, which is expanded to two arguments — `txt md` (separated by a space).

**Parameter expansion creates one argument for each element inside the curly braces, separated by a comma**:

```
$ echo {1,2,3}
1 2 3

$  echo pre{1,2,3}
pre1fix pre2fix pre3fix
```

An empty entry will create an argument with nothing substituted:

```
$ echo pre{,1,2}fix
prefix pre1fix pre2fix
```

Another example — renaming a `models` folder to `ml` inside a `data` folder:

```
$ mv data/models data/ml
```

We can save retyping `data/` by using parameter expansion:

```
$ mv data/{models,ml}
mv data/models data/ml
```

We can use parameter expansion with a sequence of numbers — useful to create numbered directories:

```
$ mkdir data{0..2}
mkdir data0 data1 data2
```

**We can also do parameter expansion inside an argument** — for example, to change a folder halfway up a path:

```
$ cat models/{baseline,final}/data.csv
cat models/baseline/data.csv models/final/data.csv
```

A final example, using three parameters — moving two Python test files into a `tests` folder:

```
$ mv test_unit.py test_system.py tests
```

#### Summary

**Any time you are retyping something multiple times in a single command, it’s likely parameter expansion can help save your exhausted hands.**

---

## Accessing the Last Argument With $_

Terminals are operated by a sequence of commands — we often reuse information across multiple commands.

Our previous tip, parameter expansion, is about typing less on a single command — **this tip is about typing less across multiple commands**.

Take the simple case of making a folder and moving into it:

```
$ mkdir temp
$ cd temp
```

Notice that we reuse the argument `temp` again in our second command?

**We can save retyping** `temp` **and bring it forward from the previous command using** `$_`:

```
$ mkdir temp
$ cd $_
cd temp
```

Above, we use `$_` to access the last argument of the previous command, which in this case is `temp`.

This use case of wanting to reuse the last argument of the last command (here `temp`) is so common that Bash stores it in a special variable `_`, which we access using a `$` prefix (same as for `$PATH` or `$HOME`).

Another example of using `$_`— moving a file and printing to `STDOUT` using `cat`:

```
$ mv main.py src/main.py 
$ cat src/main.py
```

Notice how we are again reusing the last argument `src/main.py`?

You can rewrite this using `$_` to automatically bring forward `src/main.py` into your second command:

```
$ mv main.py src/main.py 
$ cat $_
cat src/main.py
```

Using `$_` means you don't need to rewrite a complicated file path, giving you no chance to incorrectly retype it.

#### Summary

**Any time you are retyping something multiple times across multiple commands, it’s likely using** `$_` **can help reduce the strain on your weary hands.**

---

## Quick Substitution With ^old^new

Sometimes (often in our case) we run a command in the Shell and quickly realize we made a mistake.

Rather than retyping the command again, we can use **quick substitution to fix the mistake by replacing text in the previous command.**

An example — you are SSHing into a server and run the command to connect — only to realise it should have been`user` instead of `ubuntu` all along!

```
$ ssh ubuntu@198.compute.com
```

Instead of retyping the entire command again, you can use quick substitution to change just the part you want — here to change `ubuntu` into `user`:

```
$ ^ubuntu^user
ssh user@198.compute.com
```

The pattern in quick substitution is `^old^new`. It is the equivalent of doing:

```
$ !!:s/old/new
```

`!!` to get the last command and `:s` for a substitute regex. I think you'll agree `^old^new` is a little easier!

#### Summary

**Any time you are retyping something multiple times across multiple commands, it’s likely using** `$_` **can help reduce the strain on your worn out hands.**

---

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
