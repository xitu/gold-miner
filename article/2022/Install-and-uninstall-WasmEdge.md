> * 原文地址：[Install and uninstall WasmEdge](https://wasmedge.org/book/en/start/install.html)
> * 原文作者：[wasmedge](https://wasmedge.org/book/en/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/Install-and-uninstall-WasmEdge.md](https://github.com/xitu/gold-miner/blob/master/article/2022/Install-and-uninstall-WasmEdge.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Chorer](https://github.com/Chorer)

# WasmEdge 的安装与卸载

## 快速安装

安装 WasmEdge 最简单的方式是执行以下的命令（前提是你的系统已经安装了 `git` 和 `curl`）：

```bash
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
```

如果你希望一并安装 [Tensorflow 和图像处理扩展](https://www.secondstate.io/articles/wasi-tensorflow/)，请执行以下命令。它将尝试在你的系统上安装 Tensorflow 和图像共享库。

```bash
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all
```

执行 `source $HOME/.wasmedge/env` 命令能使已安装的二进制文件在当前会话中可用。

**就这么简单！**你现在可以通过命令行使用 WasmEdge，或者直接将其作为应用打开。要想升级 WasmEdge，你只需要重新执行以上的命令，它会覆盖旧的文件。

## 为所有用户安装 WasmEdge

在默认情况下，WasmEdge 将安装在 `$HOME/.wasmedge` 目录中。你也可以将它安装在系统目录中，如 `/usr/local`，以便所有用户都能使用 WasmEdge。要想指定一个安装路径，你可以在执行 `install.sh` 脚本时附上 `-p` 参数。由于文件将写入系统目录，你需要以 `root` 用户或 `sudo` 权限执行以下命令：

```bash
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p /usr/local
```

或者（包含图像扩展）：

```bash
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all -p /usr/local
```

## 安装指定版本的 WasmEdge

你可以将 `-v` 参数传递给 `install.sh` 脚本来安装指定版本的 WasmEdge（包括预发行版本和历史版本）。例子如下：

```bash
curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all -v 0.9.0-rc.5
```

如果你对 `master` 分支的 `HEAD` 中的最新的构建感兴趣（也就是 WasmEdge 的 nightly 版本），你可以直接从 Github Action 的 CI artifact 中下载已发布的包。[例子请看这里。](https://github.com/WasmEdge/WasmEdge/actions/runs/1521549504#artifacts)

## 安装内容

安装完成后，你将会得到以下的目录和文件。这里我们假设你将 WasmEdge 安装到 `$HOME/.wasmedge` 目录中。如果你想进行系统范围的安装，你也可以将安装目录更改为 `/usr/local`。

* The `$HOME/.wasmedge/bin` 目录包含 WasmEdge Runtime CLI 可执行文件。你可以拷贝这些文件并放置到任意目录中。
  * `wasmedge` 工具是标准的 WasmEdge 运行时。你可以在命令行中使用它：`wasmedge --dir .:. app.wasm`。
  * `wasmedgec` 工具是 AOT 编译器，它能将 `wasm` 文件编译为原生 `so` 文件：`wasmedgec app.wasm app.so`。之后，`wasmedge` 就能执行 `so` 文件了：`wasmedge --dir .:. app.so`。
  * `wasmedge-tensorflow`、`wasmedge-tensorflow-lite` 和 `wasmedgec-tensorflow` 工具是运行时和编译器。这些工具都支持 WasmEdge Tensorflow SDK。
* `$HOME/.wasmedge/lib` 目录包含 WasmEdge 的共享库和依赖库。从主程序中启动 WasmEdge 程序和功能会用到这些文件。
* `$HOME/.wasmedge/include` 目录包含了 WasmEdge 的头文件。这些文件用于 WasmEdge SDK 中。

## 卸载

要想卸载 WasmEdge，你可以执行以下的命令：

```bash
bash <(curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/uninstall.sh)
```

如果 `wasmedge` 这个二进制文件不在 `PATH` 中，且 WasmEdge 不是安装在默认的`$HOME/.wasmedge` 目录，那么你必须在执行命令时附上安装路径。

```bash
bash <(curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/uninstall.sh) -p /path/to/parent/folder
```

如果你希望以非交互的方式卸载 WasmEdge，你可以附上 `--quick` 或 `-q` 参数。

```bash
bash <(curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/uninstall.sh) -q
```

> 如果 `wasmedge` 二进制文件的父目录中包含 `.wasmedge`，那么该目录将会被一并删除。举例来说，该脚本将会完全删除默认的 `$HOME/.wasmedge` 目录。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。