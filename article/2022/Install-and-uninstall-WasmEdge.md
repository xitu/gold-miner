> * 原文地址：[Install and uninstall WasmEdge](https://wasmedge.org/book/en/start/install.html)
> * 原文作者：[wasmedge](https://wasmedge.org/book/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/Install-and-uninstall-WasmEdge.md](https://github.com/xitu/gold-miner/blob/master/article/2022/Install-and-uninstall-WasmEdge.md)
> * 译者：
> * 校对者：
# Install and uninstall WasmEdge

## Quick install

The easiest way to install WasmEdge is to run the following command. Your system should have `git` and `wget` as prerequisites.

```bash
wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash
```

If you would like to install WasmEdge with its [Tensorflow and image processing extensions](https://www.secondstate.io/articles/wasi-tensorflow/), please run the following command. It will attempt to install Tensorflow and image shared libraries on your system.

```bash
wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all
```

Run the following command to make the installed binary available in the current session `source $HOME/.wasmedge/env`

**That's it!** You can now use WasmEdge from the CLI, or launch it from an application. To update WasmEdge to a new release, just re-run the above command to write over the old files.

## Install for all users

By default, WasmEdge is installed in the `$HOME/.wasmedge` directory. You can install it into a system directory, such as `/usr/local` to make it available to all users. To specify an install directory, you can run the `install.sh` script with the `-p` flag. You will need to run the following commands as the `root` user or `sudo` since they write into system directories.

```bash
wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -p /usr/local
```

Or, with all extensions

```bash
wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all -p /usr/local
```

## Install a specific version of WasmEdge

You could install specific versions of WasmEdge, including pre-releases or
old releases by passing the `-v` argument to the install script. Here is an example.

```bash
wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install.sh | bash -s -- -e all -v 0.9.0-rc.5
```

If you are interested in the latest builds from the `HEAD` of the `master` branch, which is basically WasmEdge's nightly builds, you can download the 
release package directly from our Github Action's CI artifact. [Here is an example](https://github.com/WasmEdge/WasmEdge/actions/runs/1521549504#artifacts).

## What's installed

After installation, you have the following directories and files. Here we assume that you installed into the `$HOME/.wasmedge` directory. You could also change it to `/usr/local` if you did a system-wide install.

* The `$HOME/.wasmedge/bin` directory contains the WasmEdge Runtime CLI executable files. You can copy and move them around on your file system.
  * The `wasmedge` tool is the standard WasmEdge runtime. You can use it from the CLI. `wasmedge --dir .:. app.wasm`
  * The `wasmedgec` tool is the AOT compiler to compile a `wasm` file into a native `so` file. `wasmedgec app.wasm app.so` The `wasmedge` can then execute the `so` file. `wasmedge --dir .:. app.so`
  * The `wasmedge-tensorflow`, `wasmedge-tensorflow-lite` and `wasmedgec-tensorflow` tools are runtimes and compilers that support the WasmEdge tensorflow SDK.
* The `$HOME/.wasmedge/lib` directory contains WasmEdge shared libraries, as well as dependency libraries. They are useful for WasmEdge SDKs to launch WasmEdge programs and functions from host applications.
* The `$HOME/.wasmedge/include` directory contains the WasmEdge header files. They are useful for WasmEdge SDKs.


## Uninstall

To uninstall WasmEdge, you can run the following command.

```bash
bash <(wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/uninstall.sh)
```

If `wasmedge` binary is not in `PATH` and it wasn't installed in the default `$HOME/.wasmedge` folder, then you must provide the installation path.

```bash
bash <(wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/uninstall.sh) -p /path/to/parent/folder
```

If you wish to uninstall uninteractively, you can pass in the `--quick` or `-q` flag.

```bash
bash <(wget -qO- https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/uninstall.sh) -q
```

> If a parent folder of the `wasmedge` binary contains `.wasmedge`, the folder will be considered for removal. For example, the script removes the default `$HOME/.wasmedge` folder altogether.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。