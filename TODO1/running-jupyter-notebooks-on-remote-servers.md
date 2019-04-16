> * 原文地址：[Running Jupyter Notebooks on Remote Servers](https://towardsdatascience.com/running-jupyter-notebooks-on-remote-servers-603fbcc256b3)
> * 原文作者：[Tobias Skovgaard Jepsen](https://medium.com/@tobiasskovgaardjepsen)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/running-jupyter-notebooks-on-remote-servers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/running-jupyter-notebooks-on-remote-servers.md)
> * 译者：[Daltan](https://github.com/Daltan)
> * 校对者：[TloveYing](https://github.com/TloveYing)，[xionglong58](https://github.com/xionglong58)

# 如何在远程服务器上运行 Jupyter Notebooks

![](https://cdn-images-1.medium.com/max/3840/1*rhhk7heUKv1KA8p50I-ElA.jpeg)

[Jupyter Notebook](https://jupyter.org/) 是许多数据科学家工具库中的主要工具。Jupyter Notebook 作为一种工具，可以让人们通过交互的方式，更容易地进行数据分析、建立模型原型、进行试验等等，从而提高生产率，缩短「写代码 —— 看结果」这个循环反馈的时间。

很多情况下在笔记本或工作站上运行 Jupyter Notebook 已经足够了。但如果是在对大型数据集操作，或处理数据要消耗大量运算力，或建立的学习模型相当复杂，就需要比笔记本电脑更强大的计算力。可能你在规模较大的图上运行 [图卷积网络（Graph Convolutional Networks, GCNN）](https://towardsdatascience.com/how-to-do-deep-learning-on-graphs-with-graph-convolutional-networks-7d2250723780)，或在大量文本语料中运用带递归神经网络的机器翻译算法，就需要更多 CPU 内核、RAM、或多个 GPU。幸运的是，你需要的这些资源，可能在远程服务器上都有！

如果你的服务器支持图形用户界面（Graphical User Interface, GUI），那么你可以直接使用 [远程桌面软件](https://en.wikipedia.org/wiki/Remote_desktop_software) 直接访问服务器，就跟平时在笔记本上使用 Jupyter Notebook 一样。

然而很多服务器并没有 GUI。这样的话，可以先在你笔记本电脑上写好 Python 脚本，然后使用小部分的数据进行试验，证明脚本可以正确运行，最后再复制到远程服务器上用命令行运行。甚至可以先在 Notebook 上试验，再使用 `jupyter nbconvert --to script your_notebook.ipynb` 命令，将 Notebook 内容导出到脚本。这样虽然可以让代码在远程服务器上运行，可惜的是，你再也不能使用 Jupyter Notebook 来交互式地进行诸如对模型进行试验或对结果可视化了。

本文将向你展示，如何在远程服务器上运行 Jupyter Notebook，如何笔记本电脑上访问，以及如何用两条 `bash` 命令，让整个过程更简单。

## 启动远程 Notebook 服务器

使用 [Secure Shell Protocol](https://en.wikipedia.org/wiki/Secure_Shell) （SSH）在远程服务器上启动 Jupyter Notebook 服务器。 SSH 可以给远程服务器发送命令，基本语法如下：

```
ssh username:password@remote_server_ip command
```

具体命令要根据你情况来定。就我而言，由于跟其他人共享同一个远程服务器，因此没有在共享环境中安装 Jupyter。第一步是进入到我自己的工程目录，启动虚拟环境，再启动 Notebook 服务器。具体而言，就是在远程服务器上执行以下三个 `bash` 命令：

```
cd project_folder
. virtual_environment/bin/activate
jupyter notebook --no-browser --port=8889
```

我使用 `jupyter notebook` 命令来启动 Jupyter Notebook，该命令带有 `--no-browser` 标识，因而没有启动浏览器，因为远程服务器如果没有 GUI 的话，并不能显示浏览器。我还使用 `--port=8889` 把默认端口 8888 改为 8889，这是我个人的偏好，这样本地和远程的两个 Notebook 用的就是不同的端口，就更容易查看代码究竟是在哪运行了。

要在远程服务器上运行命令，先运行以下组合代码。

```
nohup ssh -f username:password@remote_server_ip "cd project_folder; . virtual_environment/bin/activate; jupyter notebook --no-browser --port=8889"
```

注意，我用 `;` 将一行代码的三个命令分开，而没有用行分隔符。执行这段代码后，Jupyter Notebook 会在 8889 端口启动，并在后台运行。最后我加了给 `ssh` 命令加了 `-f` 把进程推进后台，还加了 `nohup` 命令，静默了进程的所有输出，这样就能继续使用终端窗口了。[这里](https://www.computerhope.com/unix/unohup.htm) 有更多关于 `nohup` 命令的信息。

## 访问你的 Notebook

键入以下 URL 就能访问 Notebook 了

```
remote_server_ip:8889
```

需要你记住 IP 地址，或把网页加入书签也可。不过使用 [转发端口](https://en.wikipedia.org/wiki/Port_forwarding) 命令，就能跟在本地 Notebook 一样简单地访问远程 Notebook 了，命令如下：

```
nohup ssh -N -f -L localhost:8889:localhost:8889 username:password@remote_server_ip
```

`-N` 是在告诉 `ssh` 没有远程命令要执行，此刻不用执行任何远程命令。跟前面一样，`-f` 将 `ssh` 进行推入后台。最后的 `-L` 则明确了端口转发的配置，语法是 `local_server:local_port:remote_server:remote_port`。该配置使所有本地（比如你的笔记本电脑）给 `8889` 端口的请求，全都发给远程服务器的 `8889` 端口，远程服务器的地址是 `username:password@remote_server_ip`。跟上文一样，`nohup` 命令静默了输出。

上面命令的主要作用就是，在你自己浏览器上也能访问远程 Jupyter Notebook 了，地址是

```
localhost:8889
```

这就仿佛在本地运行 Notebook 一样。

## 终止远程 Notebook 服务器

原则上可以让 Notebook 服务在远程服务器上一直运行（除非重启或崩溃），但也可能要终止服务，比如要升级 `jupyter`。有两种方式终止：一是通过浏览器，二是通过命令行。

### 通过浏览器窗口

新版本的 Jupyter Notebook 中，能在浏览窗口右上方找到退出按钮，如下图所示。单击后，就得使用之前的启动命令重启服务器了。

![The Quit Button](https://cdn-images-1.medium.com/max/6208/1*-_e16uYLCzydswb1COVosA.png)

### 通过命令行

你要是不能把 Jupyter 升级到有退出按钮的较新版本，或你更喜欢用终端，也可以通过命令行终止服务器：

```
jupyter notebook stop 8889
```

其中 `8889` 是端口号。要在远程服务器执行这段代码，先使用以下命令：

```
ssh username:password@remote_server_ip "`jupyter notebook stop 8889"`
```

不幸的是，[这个命令有 bug](https://github.com/jupyter/notebook/issues/2844#issuecomment-371220536)，但我依然将这个写在这，期待以后或许可行。不过还有变通做法，就是直接使用以下命令，将 `jupyter` 进程终止。

```
ssh username:password@remote_server_ip "pkill -u username jupyter`"`
```

其中 `-u username` 表示只终止由 `username` 启动的 `jupyter` 进程。这样做的缺点是，你正在运行的所有 Notebook 服务都将被终止。当然也可以登陆远程服务器，启动 Notebook 服务，把终端窗口开着，手动管理服务器。还能使用常用的 `CTRL+C` 键盘命令关闭 Notebook 服务器。

## 工作流程梳理

记住所有命令很累赘。幸亏我们能给每个命令起别名，以简化流程。将下列代码加入 `~/.bashrc` 文件： 

```
alias port_forward='nohup ssh -N -f -L localhost:8889:localhost:8889 username:password@remote_server_ip'
alias remote_notebook_start='nohup ssh -f username:password@remote_server_ip "cd rne; . virtual_environment/bin/activate; jupyter notebook --no-browser --port=8889"; port_forward'
alias remote_notebook_stop='ssh username:password@remote_server_ip "pkill -u username jupyter"'
```

在终端输入 `source .bashrc` 载入这些命令。这样就能在终端上用 `remote_notebook_start` 和 `remote_notebook_stop` 命令，分别启动（同时设置端口转发）和关闭远程 Notebook 服务器了。

## 总结

本文展示了如何使用 bash 命令来启动，访问和终止远程服务器上的 Jupyter Notebook，还展示了如何创建 bash 别名使上述流程更容易。

希望这些命令能够提到你在数据科学上的工作效率，并几乎无缝地让你从 Jupyter Notebook 和远程服务器上可用的计算资源中同时获益。

* * *

_如果你喜欢刚才读的文章，欢迎在 [*Twitter*](https://twitter.com/TobiasSJepsen) 上关注我，我会在那儿分享论文、视频和文章，而且都是和实践、理论、数据科学伦理和我感兴趣的机器学习相关，上面还有我自己的帖子。_

_有专业需求，在 [*LinkedIn*](https://www.linkedin.com/in/tobias-skovgaard-jepsen/) 上联系我，或直接在 [*Twitter*](https://twitter.com/TobiasSJepsen) 上发消息。_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
