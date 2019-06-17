> * 原文地址：[An Overview of Go's Tooling](https://www.alexedwards.net/blog/an-overview-of-go-tooling)
> * 原文作者：[Alex Edwards](https://www.alexedwards.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-overview-of-go-tooling.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-overview-of-go-tooling.md)
> * 译者：[iceytea](https://github.com/iceytea)
> * 校对者：[jianboy](https://github.com/jianboy), [cyril](https://github.com/shixi-li)

# Go 语言命令概览

我偶尔会被人问到：**“你为什么喜欢使用 Go 语言？”** 我经常会提到的就是 `go` 工具命令，它是与语言一同存在的一部分。有一些命令 —— 比如 `go fmt` 和 `go build` —— 我每天都会用到，还有一些命令 —— 就像 `go tool pprof` —— 我用它们解决特定的问题。但在所有的场景下，我都很感谢 go 命令让我的项目管理和维护变得更加容易。

在这篇文章中，我希望提供一些关于我认为最有用的命令的背景和上下文，更重要的是，解释它们如何适应典型项目的工作流程。如果你刚刚接触 Go 语言，我希望这是一个良好的开端。

如果你使用 Go 语言已经有一段时间，这篇文章可能不适合你，但同样希望你能在这里发现之前不了解的命令和参数😀

本文中的信息是针对 Go 1.12 编写的，并假设你正在开发一个 [module-enabled](https://github.com/golang/go/wiki/Modules#quick-start) 的项目。

1. **[安装命令](#安装命令)**
2. **[查看环境信息](#查看环境信息)**
3. **[开发](#开发)**
    * [运行代码](#运行代码)
    * [获取依赖关系](#获取依赖关系)
    * [重构代码](#重构代码)
    * [查看 Go 文档](#查看-Go-文档)
4. **[测试](#测试)**
    * [运行测试](#运行测试)
    * [分析测试覆盖率](#分析测试覆盖率)
    * [压力测试](#压力测试)
    * [测试全部依赖关系](#测试全部依赖关系)
5. **[预提交检查](#预提交检查)**
    * [格式化代码](#格式化代码)
    * [执行静态分析](#执行静态分析)
    * [Linting 代码](#linting-代码)
    * [整理和验证依赖关系](#整理和验证依赖关系)
6. **[构建与部署](#构建与部署)**
    * [构建可执行文件](#构建可执行文件)
    * [交叉编译](#交叉编译)
    * [使用编译器和链接器标记](#使用编译器和链接器标记)
7. **[诊断问题和优化](#诊断问题和优化)**
    * [运行和比较基准](#运行和比较基准)
    * [分析和跟踪](#分析和跟踪)
    * [竞争检测](#竞争检测)
8. **[管理依赖](#管理依赖)**
9. **[升级到新版本](#升级到新版本)**
10. **[报告问题](#报告问题)**
11. **[速查表](#速查表)**

## 安装命令

这篇文章中，我将主要关注 go 命令这部分。但这里也将提到一些不属于 Go 12.2 标准发行版的内容。

当你在 Go 12.2 版本下安装命令时，你首先需要确保当前在 module-enabled 的目录**之外**（我通常跳转到 `/tmp` 目录下）。之后你可以使用 `GO111MODULE=on go get` 命令来安装。例如：

```shell
$ cd /tmp
$ GO111MODULE=on go get golang.org/x/tools/cmd/stress
```

这条命令将会下载相关的包和依赖项、构建可执行文件，并将它添加到你设置的 `GOBIN` 目录下。如果你没有显式设定 `GOBIN` 目录，可执行文件将会被添加到 `GOPATH/bin` 目录下。但无论哪种方式，你都应当确保系统路径上有对应的目录。

注意：这个过程有些笨拙，希望能在将来的 Go 版本中有所改进。你可以在 [Issue 30515](https://github.com/golang/go/issues/30515) 跟踪有关此问题的讨论。

## 查看环境信息

你可以使用 `go env` 命令显示当前 Go 工作环境。如果你在不熟悉的计算机上工作，这可能很有用。

```shell
$ go env
GOARCH="amd64"
GOBIN=""
GOCACHE="/home/alex/.cache/go-build"
GOEXE=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOOS="linux"
GOPATH="/home/alex/go"
GOPROXY=""
GORACE=""
GOROOT="/usr/local/go"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/linux_amd64"
GCCGO="gccgo"
CC="gcc"
CXX="g++"
CGO_ENABLED="1"
GOMOD=""
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build245740092=/tmp/go-build -gno-record-gcc-switches"
```

如果你对某些特定值感兴趣，则可以将这些值作为参数传递给 `go env`。例如：

```shell
$ go env GOPATH GOOS GOARCH
/home/alex/go
linux
amd64
```

要显示 `go env` 命令的所有变量和值的内容，你可以运行：

```shell
$ go help environment
```

## 开发

### 运行代码

在开发过程中，用 `go run` 命令执行代码十分方便。它本质上是一个编译代码的快捷方式，在 `/tmp` 目录下创建一个可执行二进制文件，并一步运行它。

```shell
$ go run .          # 运行当前目录下的包
$ go run ./cmd/foo  # 运行 ./cmd/foo 目录下的包
```

注意：在 Go 1.11 版本，当你执行 `go run` 命令时，你可以[传入包的路径](https://golang.org/doc/go1.11#run)，就像我们上面提到的那样。这意味着不再需要使用像 `go run *.go` 这样包含通配符扩展的变通方法运行多个文件。我非常喜欢这个改进。

### 获取依赖关系

假设你已经[启用了模块](https://github.com/golang/go/wiki/Modules#quick-start)，那当你运行 `go run`、`go test` 或者 `go build` 类似的命令时，所有外部依赖项将会自动（或递归）下载，以实现代码中的 `import` 语句。默认情况下，将下载依赖项的最新 tag，如果没有可用的 tag，则使用最新提交的依赖项。

如果你事先知道需要特定版本的依赖项（而不是 Go 默认获取的依赖项），则可以在使用 `go get` 同时带上相关版本号或 commit hash。例如：

```shell
$ go get github.com/foo/bar@v1.2.3
$ go get github.com/foo/bar@8e1b8d3
```

如果获取到的依赖项包含一个 `go.mod` 文件，那么**它的依赖项**将不会列在**你的** `go.mod` 文件中。相反，如果你正在下载的依赖项不包含 `go.mod` 文件，那么它的依赖项**将会**在你的 `go.mod` 文件中列出，并且会伴随着一个 `//indirect` 注释。

这就意味着你的 `go.mod` 文件不一定会在一个地方显示项目的所有依赖项，但是你可以使用 `go list` 工具查看它们，如下所示：

```shell
$ go list -m all
```
有时候你可能会想知道**为什么它是一个依赖？**你可以使用 `go mod why` 命令回答这个问题。这条命令会显示从主模块的包到给定依赖项的最短路径。例如：

```shell
$ go mod why -m golang.org/x/sys
# golang.org/x/sys
github.com/alexedwards/argon2id
golang.org/x/crypto/argon2
golang.org/x/sys/cpu
```

注意：`go mod why` 命令将返回大多数（但不是所有依赖项）的应答。你可以在 [Issue 27900](https://github.com/golang/go/issues/27900) 跟踪这个问题。

如果你对分析应用程序的依赖关系或将其可视化感兴趣，你可能还想查看 `go mod graph` 工具。在[这里](https://github.com/go-modules-by-example/index/tree/master/018_go_list_mod_graph_why)有一个很棒的生成可视化依赖关系的教程和示例代码。

最后，下载的依赖项存储在位于 `GOPATH/pkg/mod` 的**模块缓存**中。如果你需要清除模块缓存，可以使用 `go clean` 工具。但请注意：这将删除计算机上**所有项目**的已下载依赖项。

```shell
$ go clean -modcache
```

### 重构代码

你可能熟悉使用 `gofmt` 工具。它可以自动格式化代码，但是它也支持去**重写规则**。你可以使用它来帮助重构代码。我将在下面证明这一点。

假设你有以下代码，你希望将 `foo` 变量更改为 `Foo`，以便将其导出。

```go
var foo int

func bar() {
    foo = 1
	fmt.Println("foo")
}
```

要实现这一点，你可以使用 `gofmt` 的 `-r` 参数实现重写规则，`-d` 参数显示更改差异，`-w` 参数实现**就地**更改，像这样：

```shell
$ gofmt -d -w -r 'foo -> Foo' .
-var foo int
+var Foo int

 func bar() {
-	foo = 1
+	Foo = 1
 	fmt.Println("foo")
 }
```

注意到这比单纯的查找和替换更智能了吗？ `foo` 变量已被更改，但 `fmt.Println()` 语句中的 `"foo"` 字符串没有被替换。另外需要注意的是 `gofmt` 命令是递归工作的，因此上面的命令会在当前目录和子目录中的所有 `*.go` 文件上执行。

如果你想使用这个功能，我建议你首先不带 `-w` 参数运行重写规则，并先检查差异，以确保代码的更改如你所愿。

让我们来看一个稍复杂的例子。假设你要更新代码，以使用新的 Go 1.12 版本中携带的 [strings.ReplaceAll()](https://golang.org/pkg/strings/#ReplaceAll) 方法替换掉之前的 [strings.Replace()](https://golang.org/pkg/strings/#Replace) 方法。要进行此更改，你可以运行：

```shell
$ gofmt -w -r 'strings.Replace(a, b, c, -1) -> strings.ReplaceAll(a, b, c)' .
```

在重写规则中，单个小写字符用作匹配任意表达式的通配符，这些被匹配到的表达式将会被替换。

### 查看 Go 文档

你可以使用 `go doc` 工具，在终端中查看标准库的文档。我经常在开发过程中使用它来快速查询某些东西 —— 比如特定功能的名称或签名。我觉得这比浏览[网页文档](https://golang.org/pkg)更快，而且它可以离线查阅。

```shell
$ go doc strings            # 查看 string 包的简略版文档 
$ go doc -all strings       # 查看 string 包的完整版文档 
$ go doc strings.Replace    # 查看 strings.Replace 函数的文档
$ go doc sql.DB             # 查看 database/sql.DB 类型的文档 
$ go doc sql.DB.Query       # 查看 database/sql.DB.Query 方法的文档
```

你也可以使用 `-src` 参数来展示相关的 Go 源码。例如：

```shell
$ go doc -src strings.Replace   # 查看 strings.Replace 函数的源码
```

## 测试

### 运行测试

你可以使用 `go test` 工具测试项目中的代码，像这样：

```shell
$ go test .          # 运行当前目录下的全部测试
$ go test ./...      # 运行当前目录和子目录下的全部测试
$ go test ./foo/bar  # 运行 ./foo/bar 目录下的全部测试
```

通常我会在启用 Go 的 [竞争检测](https://golang.org/doc/articles/race_detector.html) 的情况下运行我的测试，这可以帮助我找到在实际使用中可能出现的一些数据竞态情况。就像这样：

```shell
$ go test -race ./...
```

这里有很重要的一点要特别注意，启用竞争检测将增加测试的总体运行时间。因此，如果你经常在 TDD（测试驱动开发）工作流中运行测试，你可能会使用此方法进行预提交测试运行。

从 1.10 版本起，Go 在包级别 [缓存测试结果](https://golang.org/doc/go1.10#test)。如果一个包在测试运行期间没有发生改变，并且你正在使用相同的、可缓存的 `go test` 工具，那么将会展示缓存的测试结果，并用 `"(cached)"` 标记注明。这对于加速大型代码库的测试运行非常有用。如果要强制测试完全运行（并避免缓存），可以使用 `-count=1` 参数，或使用 `go clean` 工具清除所有缓存的测试结果。

```shell
$ go test -count=1 ./...    # 运行测试时绕过测试缓存
$ go clean -testcache       # 删除所有的测试结果缓存
```
注意：缓存的测试结果与构建结果被一同存储在你的 `GOCACHE` 目录中。如果你不确定 `GOCACHE` 目录在机器上的位置，请输入 `go env GOCACHE` 检查。

你可以使用 `-run` 参数将 `go test` 限制为只运行特定测试（和子测试）。`-run` 参数接受正则表达式，并且只运行具有与正则表达式匹配的名称的测试。我喜欢将它与 `-v` 参数结合起来以启用详细模式，这样会显示正在运行的测试和子测试的名称。这是一个有用的方法，以确保我没有搞砸正则表达式，并确保我期望的测试正在运行！

```shell
$ go test -v -run=^TestFooBar$ .          # 运行名字为 TestFooBar 的测试
$ go test -v -run=^TestFoo .              # 运行那些名字以 TestFoo 开头的测试
$ go test -v -run=^TestFooBar$/^Baz$ .    # 只运行 TestFooBar 的名为 Baz 的子测试
```

值得注意的两个参数是 `-short`（可以用来[跳过长时间运行的测试](https://golang.org/pkg/testing/#hdr-Skipping)）和 `-failfast`（第一次失败后停止运行进一步的测试）。请注意，`-failfast` 将阻止测试结果缓存。

```shell
$ go test -short ./...      # 跳过长时间运行的测试
$ go test -failfast ./...   # 第一次失败后停止运行进一步的测试
```

### 分析测试覆盖率

当你在运行测试时使用 `-cover` 参数，你就可以开启测试覆盖率分析。这将显示每个包的输出中测试所涵盖的代码百分比，类似于：

```shell
$ go test -cover ./...
ok  	github.com/alexedwards/argon2id	0.467s	coverage: 78.6% of statements
```
你也可以通过使用 `-coverprofile` 参数生成覆盖率总览，并使用 `go tool cover -html` 命令在浏览器中查看。像这样：

```shell
$ go test -coverprofile=/tmp/profile.out ./...
$ go tool cover -html=/tmp/profile.out
```

![](https://www.alexedwards.net/static/images/tooling-1.png)

这将为你提供所有测试文件的可导航列表，其中绿色代码是被测试覆盖到的，红色代码未被测试覆盖。

如果你愿意的话，可以再进一步。设置 `-covermode=count` 参数，使覆盖率配置文件记录测试期间每条语句执行的确切**次数**。

```shell
$ go test -covermode=count -coverprofile=/tmp/profile.out ./...
$ go tool cover -html=/tmp/profile.out
```

在浏览器中查看时，更频繁执行的语句以更饱和的绿色阴影显示，类似于：

![](https://www.alexedwards.net/static/images/tooling-2.png)

注意：如果你在测试中使用了 `t.Parallel()` 命令，你应该用 `-covermode=atomic` 替换掉 `-covermode=count` 以确保计数准确。

最后，如果你没有可用于查看覆盖率配置文件的 Web 浏览器，则可以使用以下命令在终端中按功能/方法查看测试覆盖率的细分：

```shell
$ go tool cover -func=/tmp/profile.out
github.com/alexedwards/argon2id/argon2id.go:77:		CreateHash		87.5%
github.com/alexedwards/argon2id/argon2id.go:96:		ComparePasswordAndHash	85.7%
...
```

### 压力测试

你可以使用 `go test -count` 命令连续多次运行测试。如果想检查偶发或间歇性故障，这可能很有用。例如：

```shell
$ go test -run=^TestFooBar$ -count=500 .
```

在这个例子中，`TestFooBar` 测试将连续重复 500 次。但有一点你要特别注意，测试将串行**重复**执行 —— 即便它包含一个 `t.Parallel()` 命令。因此，如果你的测试要做的事相对较慢，例如读写数据库、磁盘或与互联网有频繁的交互，那么运行大量测试可能会需要相当长的时间。

这种情况下，你可能希望使用 [`stress`](golang.org/x/tools/cmd/stress) 工具并行执行重复相同的测试。你可以像这样安装它：

```shell
$ cd /tmp
$ GO111MODULE=on go get golang.org/x/tools/cmd/stress
```

要使用 `stress` 工具，首先需要为要测试的特定包编译**测试二进制**文件。你可以使用 `go test -c` 命令。例如，为当前目录中的包创建测试二进制文件：

```shell
$ go test -c -o=/tmp/foo.test .
```
在这个例子中，测试二进制文件将输出到 `/tmp/foo.test`。之后你可以使用 `stress` 工具在该文件中执行特定测试，如下所示：

```shell
$ stress -p=4 /tmp/foo.test -test.run=^TestFooBar$
60 runs so far, 0 failures
120 runs so far, 0 failures
...
```

注意：在上面的例子中，我使用 `-p` 参数来限制 `stress` 使用的并行进程数为 4。如果没有这个参数，该工具将默认使用和 `runtime.NumCPU()` 方法执行结果相同数量的进程（当前系统的 CPU 核数量的进程数）。

### 测试全部依赖关系

在为发布或部署构建可执行文件或公开发布代码之前，你可能希望运行 `go test all` 命令：

```shell
$ go test all
```

这将对模块中的所有包和依赖项运行测试 —— 包括对**测试依赖项**和必要的**标准库包**的测试 —— 它可以帮助验证所使用的依赖项的确切版本是否互相兼容。可能需要相当长的时间才能运行，但测试结果可以很好地缓存，因此任何将来的后续测试都会更快。如果你愿意，你也可以使用 `go test -short all` 跳过任何需要长时间运行的测试。

## 预提交检查

### 格式化代码

Go 提供了两个工具 `gofmt` 和 `go fmt` 来根据 Go 约定自动格式化代码。使用这些有助于保持代码在文件和项目中保持一致，并且 —— 在提交代码之前使用它们 —— 有助于在检查文件版本之间的差异时减少干扰项。

我喜欢使用带有以下参数的 `gofmt` 工具：

```shell
$ gofmt -w -s -d foo.go  # 格式化 foo.go 文件
$ gofmt -w -s -d .       # 递归格式化当前目录和子目录中的所有文件
```

在这些命令中，`-w` 参数指示工具重写文件，`-s` 参数指示工具尽可能的[简化](https://golang.org/cmd/gofmt/#hdr-The_simplify_command)代码，`-d` 参数指示工具输出变化的差异（因为我很想知道改变了什么）。如果你只想显示已更改文件的名称而不是差异，则可以将其替换为 `-l` 参数。

注意：`gofmt` 命令以递归方式工作。如果你传递一个类似 `.` 或 `./cmd/foo`的目录，它将格式化目录下的所有 `.go` 文件。

另一种格式化工具 `go fmt` 是一个包装器，它在指定的文件或目录上调用 `gofmt -l -w`。你可以像这样使用它：

```shell
$ go fmt ./...
```

### 执行静态分析

`go vet` 工具对你的代码进行静态分析，并对你**可能**是代码错误但不被编译器指出（语法正确）的东西提出警告。诸如无法访问的代码，不必要的分配和格式错误的构建标记等问题。你可以像这样使用它：

```shell
$ go vet foo.go     # 对 foo.go 文件进行静态分析 
$ go vet .          # 对当前目录下的所有文件进行静态分析
$ go vet ./...      # 对当前目录以及子目录下的所有文件进行静态分析
$ go vet ./foo/bar  # 对 ./foo/bar 目录下的所有文件进行静态分析
```

`go vet` 在背后运行了许多[不同的分析器](https://golang.org/cmd/vet/)，你可以根据具体情况禁用特定的分析器。例如，要禁用 `composite` 分析器，你可以使用：

```shell
$ go vet -composites=false ./...
```

在 [golang.org/x/tools](https://godoc.org/golang.org/x/tools) 中有几个实验性的分析器，你可能想尝试一下：

- [nilness](https://godoc.org/golang.org/x/tools/go/analysis/passes/nilness/cmd/nilness)：检查多余或不可能的零比较
- [shadow](https://godoc.org/golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow)： 检查可能的非预期变量阴影

如果要使用这些，则需要单独安装和运行它们。例如，如果安装 `nilness`，你需要运行：

```shell
$ cd /tmp
$ GO111MODULE=on go get golang.org/x/tools/go/analysis/passes/nilness/cmd/nilness
```

之后你可以这样使用：

```shell
$ go vet -vettool=$(which nilness) ./...
```

注：自 Go 1.10 版本起，`go test` 工具会在运行任何测试之前自动运行 `go vet` 检查的一个小的、高可信度的子集。你可以在运行测试时像这样关闭此行为：

```shell
$ go test -vet=off ./...
```

### Linting 代码

你可以使用 `golint` 工具识别代码中的**样式错误**。与 `go vet` 不同，这与代码的**正确性**无关，但可以帮助你将代码与 [Effective Go](https://golang.org/doc/effective_go.html) 和 Go [CodeReviewComments](https://golang.org/wiki/CodeReviewComments) 中的样式约定对齐。

它不是标准库的一部分，你需要执行如下命令安装：

```shell
$ cd /tmp
$ GO111MODULE=on go get golang.org/x/lint/golint
```

之后你可以这样运行：

```shell
$ golint foo.go     # Lint foo.go 文件
$ golint .          # Lint 当前目录下的所有文件
$ golint ./...      # Lint 当前目录及其子目录下的所有文件
$ golint ./foo/bar  # Lint ./foo/bar 目录下的所有文件
```

### 整理和验证依赖关系

在你对代码进行任何更改之前，我建议你运行以下两个命令来整理和验证你的依赖项：

```shell
$ go mod tidy
$ go mod verify
```
`go mod tidy` 命令将删除你的 `go.mod` 和 `go.sum` 文件中任何未使用的依赖项，并更新文件以包含所有可能的构建标记/系统/体系结构组合的依赖项（注意：`go run`，`go test`，`go build` 等命令是“懒惰的”，只会获取当前构建标记/系统/体系结构所需的包。在每次提交之前运行此命令将使你更容易确定哪些代码更改负责在查看版本控制历史记录时添加或删除哪些依赖项。

我还建议使用 `go mod verify` 命令来检查计算机上的依赖关系是否已被意外（或故意）更改，因为它们已被下载并且它们与 `go.sum` 文件中的加密哈希值相匹配。运行此命令有助于确保所使用的依赖项是你期望的完全依赖项，并且该提交的任何构建将可以在以后重现。

## 构建与部署

### 构建可执行文件

要编译 `main` 包并创建可执行二进制文件，可以使用 `go build` 工具。通常可以将它与`-o`参数结合使用，这允许你明确设置输出目录和二进制文件的名称，如下所示：

```shell
$ go build -o=/tmp/foo .            # 编译当前目录下的包 
$ go build -o=/tmp/foo ./cmd/foo    # 编译 ./cmd/foo 目录下的包
```

在这些示例中，`go build` 将**编译**指定的包（以及任何依赖包），然后调用**链接器**以生成可执行二进制文件，并将其输出到 `/tmp/foo`。

值得注意的是，从 Go 1.10 开始，`go build` 工具在[**构建缓存**](https://golang.org/cmd/go/#hdr-Build_and_test_caching)中被缓存。此缓存将在将来的构建中适当时刻重用，这可以显著加快整体构建时间。这种新的缓存行为意味着“使用 `go install` 替换 `go build` 改进缓存”的[老旧准则](https://peter.bourgon.org/go-best-practices-2016/#build-and-deploy)不再适用。

如果你不确定构建缓存的位置，可以通过运行 `go env GOCACHE` 命令进行检查：

```shell
$ go env GOCACHE
/home/alex/.cache/go-build
```

使用构建缓存有一个[重要警告](https://golang.org/pkg/cmd/go/internal/help/) - 它不会检测用 `cgo` 导入的 C 语言库的更改。因此，如果你的代码通过 `cgo` 导入 C 语言库，并且自上次构建以来你对其进行了更改，则需要使用 `-a` 参数来强制重建所有包。或者，你可以使用 `go clean` 来清除缓存：

```shell
$ go build -a -o=/tmp/foo .     # 强制重新构建所有包
$ go clean -cache               # 移除所有构建缓存
```

注意：运行 `go clean -cache` 也会删除测试缓存。

如果你对 `go build` 在背后执行的过程感兴趣，你可能想用下面的命令：

```shell
$ go list -deps . | sort -u     # 列出在构建可执行文件过程中用到的所有包
$ go build -a -x -o=/tmp/foo .  # 全部重新构建，并展示运行的所有命令
```
最后，如果你在非 `main` 包上运行 `go build`，它将被编译在一个临时位置，并且结果将再次存储在构建缓存中。这个过程不会生成可执行文件。

### 交叉编译

这是我最喜欢的 Go 功能之一。

默认情况下，`go build` 将输出适合你当前操作系统和体系结构的二进制文件。但它也支持交叉编译，因此你可以生成适合在不同机器上使用的二进制文件。如果你在一个操作系统上进行开发并在另一个操作系统上进行部署，这将特别有用。

你可以通过分别设置 `GOOS` 和 `GOARCH` 环境变量来指定要为其创建二进制文件的操作系统和体系结构。例如：

```shell
$ GOOS=linux GOARCH=amd64 go build -o=/tmp/linux_amd64/foo .
$ GOOS=windows GOARCH=amd64 go build -o=/tmp/windows_amd64/foo.exe .
```

如果想查看所有支持的操作系统和体系结构，你可以运行 `go tool dist list`：

```shell
$ go tool dist list
aix/ppc64
android/386
android/amd64
android/arm
android/arm64
darwin/386
darwin/amd64
...
```

提示：你可以使用 Go 的交叉编译[创建 WebAssembly 二进制文件](https://github.com/golang/go/wiki/WebAssembly)。

想了解更深入的交叉编译信息，推荐你阅读[这篇精彩的文章](https://rakyll.org/cross-compilation/)。

### 使用编译器和链接器标记

在构建可执行文件时，你可以使用 `-gcflags` 参数来更改编译器的行为，并查看有关它正在执行的操作的更多信息。你可以通过运行以下命令查看可用编译器参数的完整列表：

```shell
$ go tool compile -help
```
你可能会感兴趣的一个参数是 `-m`，它会触发打印有关编译期间所做的优化决策信息。你可以像这样使用它：

```shell
$ go build -gcflags="-m -m" -o=/tmp/foo . # 打印优化决策信息
```

在上面的例子中，我两次使用了 `-m` 参数，这表示我想打印两级深度的决策信息。如果只使用一个，就可以获得更简单的输出。

此外，从 Go 1.10 开始，编译器参数仅适用于传递给 `go build` 的特定包 —— 在上面的示例中，它是当前目录中的包（由 `.` 表示）。如果要为所有包（包括依赖项）打印优化决策信息，可以使用以下命令：

```shell
$ go build -gcflags="all=-m" -o=/tmp/foo .
```

从 Go 1.11 开始，你会发现[调试优化的二进制文件](https://golang.org/doc/go1.11#debugging)比以前更容易。但如果有必要的话，你仍然可以使用参数 `-N` 来禁用优化，使用 `-l` 来禁用内联。例如：

```shell
$ go build -gcflags="all=-N -l" -o=/tmp/foo .  # Disable optimizations and inlining
```

通过运行以下命令，你可以看到可用链接参数列表：

```shell
$ go tool link -help
```

其中最著名的可能是 `-X` 参数，它允许你将（字符串）值“插入”应用程序中的特定变量。这通常用于[添加版本号或提交 hash](https://blog.alexellis.io/inject-build-time-vars-golang/)。例如：

```shell
$ go build -ldflags="-X main.version=1.2.3" -o=/tmp/foo .
```

有关 `-X` 参数和示例代码的更多信息，请参阅[这个 StackOverflow 问题](https://stackoverflow.com/questions/11354518/golang-application-auto-build-versioning)和[这篇文章](https://blog.alexellis.io/inject-build-time-vars-golang/)。

你可能还有兴趣使用 `-s` 和 `-w` 参数来从二进制文件中删除调试信息。这通常会削减 25% 的最终大小。例如：

```shell
$ go build -ldflags="-s -w" -o=/tmp/foo .  # 从二进制文件中删除调试信息
```

注意：如果你需要优化可执行文件的大小，可能需要使用 [upx](https://upx.github.io/) 来压缩它。详细信息请参阅 [这篇文章](https://blog.filippo.io/shrink-your-go-binaries-with-this-one-weird-trick/)。

## 诊断问题和优化

### 运行和比较基准

Go 可以轻松的对代码进行基准测试，这是一个很好的功能。如果你不熟悉编写基准测试的一般过程，你可以在[这里](https://dave.cheney.net/2013/06/30/how-to-write-benchmarks-in-go)和[这里](https://dave.cheney.net/2013/06/30/how-to-write-benchmarks-in-go)阅读优秀指南。

要运行基准测试，你需要使用 `go test` 工具，将 `-bench` 参数设置为与你要执行的基准匹配的正则表达式。例如：

```shell
$ go test -bench=. ./...                        # 进行基准检查和测试
$ go test -run=^$ -bench=. ./...                # 只进行基准检查，不测试
$ go test -run=^$ -bench=^BenchmarkFoo$ ./...   # 只进行 BenchmarkFoo 的基准检查，不进行测试
```

我几乎总是使用 `-benchmem` 参数运行基准测试，这会在输出中强制包含内存分配统计信息。

```shell
$  go test -bench=. -benchmem ./...
```

默认情况下，每个基准测试一次运行**最少**一秒。你可以使用 `-benchtime` 和 `-count` 参数来更改它：

```shell
$ go test -bench=. -benchtime=5s ./...       # 每个基准测试运行最少 5 秒
$ go test -bench=. -benchtime=500x ./...     # 运行每个基准测试 500 次
$ go test -bench=. -count=3 ./...            # 每个基准测试重复三次以上
```

如果你并发执行基准测试的代码，则可以使用 `-cpu` 参数来查看更改 `GOMAXPROCS` 值（实质上是可以同时执行 Go 代码的 OS 线程数）对性能的影响。例如，要将 `GOMAXPROCS` 设置为 1 、4 和 8 来运行基准测试：

```shell
$ go test -bench=. -cpu=1,4,8 ./...
```

要比较基准测试之间的更改，你可能需要使用 [benchcmp](https://godoc.org/golang.org/x/tools/cmd/benchcmp) 工具。这不是标准 `Go` 命令的一部分，所以你需要像这样安装它：

```shell
$ cd /tmp
$ GO111MODULE=on go get golang.org/x/tools/cmd/benchcmp
```

然后你就可以这样使用：

```shell
$ go test -run=^$ -bench=. -benchmem ./... > /tmp/old.txt
# 做出改变
$ go test -run=^$ -bench=. -benchmem ./... > /tmp/new.txt
$ benchcmp /tmp/old.txt /tmp/new.txt
benchmark              old ns/op     new ns/op     delta
BenchmarkExample-8     21234         5510          -74.05%

benchmark              old allocs     new allocs     delta
BenchmarkExample-8     17             11             -35.29%

benchmark              old bytes     new bytes     delta
BenchmarkExample-8     8240          3808          -53.79%
```

### 分析和跟踪

Go 可以为 CPU 使用，内存使用，goroutine 阻塞和互斥争用创建诊断**配置文件**。你可以使用这些来深入挖掘并确切了解你的应用程序如何使用（或等待）资源。

有三种方法可以生成配置文件：

* 如果你有一个 Web 应用程序，你可以导入 [`net/http/pprof`](https://golang.org/pkg/net/http/pprof/) 包。这将使用 `http.DefaultServeMux` 注册一些处理程序，然后你可以使用它来为正在运行的应用程序生成和下载配置文件。[这篇文章](https://artem.krylysov.com/blog/2017/03/13/profiling-and-optimizing-go-web-applications/)很好的提供了解释和一些示例代码。
* 对于其他类型的应用程序，你可以使用 `pprof.StartCPUProfile()` 和 `pprof.WriteHeapProfile()` 函数来分析正在运行的应用程序 有关示例代码，请参阅 [`runtime/pprof`](https://golang.org/pkg/runtime/pprof/) 文档。
* 或者你可以在运行基准测试或测试时使用各种 `-***profile` 参数生成配置文件，如下所示：

```shell
$ go test -run=^$ -bench=^BenchmarkFoo$ -cpuprofile=/tmp/cpuprofile.out .
$ go test -run=^$ -bench=^BenchmarkFoo$ -memprofile=/tmp/memprofile.out .
$ go test -run=^$ -bench=^BenchmarkFoo$ -blockprofile=/tmp/blockprofile.out .
$ go test -run=^$ -bench=^BenchmarkFoo$ -mutexprofile=/tmp/mutexprofile.out .
```

注意：运行基准测试或测试时使用 `-***profile` 参数将会把测试二进制文件输出到当前目录。如果要将其输出到其它位置，则应使用 `-o` 参数，如下所示：

```shell
$ go test -run=^$ -bench=^BenchmarkFoo$ -o=/tmp/foo.test -cpuprofile=/tmp/cpuprofile.out .
```

无论你选择何种方式创建配置文件，启用配置文件时，你的 Go 程序将每秒暂停大约 100 次，并在该时刻拍摄快照。这些**样本**被收集在一起形成**轮廓**，你可以使用 `pprof` 工具进行分析。

我最喜欢检查配置文件的方法是使用 `go tool pprof -http` 命令在 Web 浏览器中打开它。例如：

```shell
$ go tool pprof -http=:5000 /tmp/cpuprofile.out
```

![](https://www.alexedwards.net/static/images/tooling-3.png)

这将默认显示**图表**，显示应用程序的采样方面的执行树，这使得可以快速了解任何“热门”使用资源。在上图中，我们可以看到 CPU 使用率方面的热点是来自 `ioutil.ReadFile()` 的两个系统调用。

你还可以导航到配置文件的其他**视图**，包括功能和源代码的最高使用情况。

![](https://www.alexedwards.net/static/images/tooling-4.png)

如果信息量太大，你可能希望使用 `--nodefraction` 参数来忽略占小于一定百分比样本的节点。例如，要忽略在少于 10% 的样本中出现的节点，你可以像这样运行 `pprof`：

```shell
$ go tool pprof --nodefraction=0.1 -http=:5000 /tmp/cpuprofile.out
```

![](https://www.alexedwards.net/static/images/tooling-5.png)

这让图形更加“嘈杂”，如果你[放大这个截图](https://www.alexedwards.net/static/images/tooling-5b.svg)，就可以更清楚的看到和了解 CPU 使用的热点位置。

分析和优化资源使用是一个庞大且复杂的问题，我在这里只涉及到一点皮毛。如果你有兴趣了解更多信息，我建议你阅读以下文章：

* [分析和优化 Go Web 应用程序](https://artem.krylysov.com/blog/2017/03/13/profiling-and-optimizing-go-web-applications/)
* [调试 Go 程序中的性能问题](https://github.com/golang/go/wiki/Performance)
* [使用基准和分析的每日代码优化](https://medium.com/@hackintoshrao/daily-code-optimization-using-benchmarks-and-profiling-in-golang-gophercon-india-2016-talk-874c8b4dc3c5)
* [使用 pprof 分析 Go 程序](https://jvns.ca/blog/2017/09/24/profiling-go-with-pprof/)

另一个可以用来帮助你诊断问题的工具是**运行时执行跟踪器**。这使你可以了解 Go 如何创建和安排运行垃圾收集器时运行的 goroutine，以及有关阻止系统调用/网络/同步操作的信息。

同样，你可以从测试或基准测试中生成跟踪，或使用 `net/http/pprof` 为你的 Web 应用程序创建和下载跟踪。然后，你可以使用 `go tool trace` 在 Web 浏览器中查看输出，如下所示：

```shell
$ go test -run=^$ -bench=^BenchmarkFoo$ -trace=/tmp/trace.out .
$ go tool trace /tmp/trace.out
```

重要提示：目前只能在 Chrome/Chromium 中查看。

![](https://www.alexedwards.net/static/images/tooling-6.png)

有关 Go 的执行跟踪器以及如何解释输出的更多信息，请参阅 [Rhys Hiltner 的 dotGo 2016 演讲](https://www.youtube.com/watch?v=mmqDlbWk_XA)和[优秀博客文章](https://making.pusher.com/go-tool-trace/)。

### 竞争检测 

我之前谈过在测试期间使用 `go test -race` 启用 Go 的竞争检测。但是，你还可以在构建可执行文件时启用它来运行程序，如下所示：

```shell
$ go build -race -o=/tmp/foo .
```

尤其重要的是，启用竞争检测的二进制文件将使用比正常情况更多的 CPU 和内存，因此在正常情况下为生产环境构建二进制文件时，不应使用 `-race` 参数。

但是，你可能希望在一台服务器部署多个启用竞争检测的二进制文件，或者使用它来帮助追踪可疑的竞态条件。方法是使用负载测试工具在启用竞争检测的二进制文件的同时投放流量。

默认情况下，如果在二进制文件运行时检测到任何竞态条件，则日志将写入 `stderr`。如有必要，可以使用 `GORACE` 环境变量来更改此设置。例如，要运行位于 `/tmp/foo` 的二进制文件并将任何竞态日志输出到 `/tmp/race.<pid>`，你可以使用：

```shell
$ GORACE="log_path=/tmp/race" /tmp/foo
```

## 管理依赖

你可以使用 `go list` 工具检查特定依赖项是否具有更新版本，如下所示：

```shell
$ go list -m -u github.com/alecthomas/chroma
github.com/alecthomas/chroma v0.6.2 [v0.6.3]
```

这将输出你当前正在使用的依赖项名称和版本，如果存在较新的版本，则输出方括号 `[]` 中的最新版本。你还可以使用 `go list` 来检查所有依赖项（和子依赖项）的更新，如下所示：

```shell
$ go list -m -u all
```

你可以使用 `go get` 命令将依赖项升级到最新版本、调整为特定 tag 或 hash 的版本，如下所示：

```shell
$ go get github.com/foo/bar@latest
$ go get github.com/foo/bar@v1.2.3
$ go get github.com/foo/bar@7e0369f
```

如果你要更新的依赖项具有 `go.mod` 文件，那么根据此 `go.mod` 文件中的信息，如果需要，还将下载对任何**子依赖项**的更新。如果使用 `go get -u` 参数，`go.mod` 文件的内容将被忽略，所有子依赖项将升级到最新的 minor/patch 版本，即使已经在 `go.mod` 中指定了不同的版本。

在升级或降级任何依赖项后，最好整理你的 modfiles。你可能还希望为所有程序包运行测试以帮助检查不兼容性。像这样：

```shell
$ go mod tidy
$ go test all
```

有时，你可能希望使用本地版本的依赖项（例如，在云端合并修补程序之前，你需要使用本地分支）。为此，你可以使用 `go mod edit` 命令将 `go.mod` 文件中的依赖项替换为本地版本。例如：

```shell
$ go mod edit -replace=github.com/alexedwards/argon2id=/home/alex/code/argon2id
```

这将在你的 `go.mod` 文件中添加一个**替换规则**，并且当以后调用 `go run` 、`go build` 等命令时，将使用本地版本依赖。

File: go.mod

```
module alexedwards.net/example

go 1.12

require github.com/alexedwards/argon2id v0.0.0-20190109181859-24206601af6c

replace github.com/alexedwards/argon2id => /home/alex/Projects/playground/argon2id
```

一旦不再需要，你可以使用以下命令删除替换规则：

```shell
$ go mod edit -dropreplace=github.com/alexedwards/argon2id
```

你可以使用[same general technique](https://github.com/golang/go/wiki/Modules#can-i-work-entirely-outside-of-vcs-on-my-local-filesystem)导入**只在你自己的文件系统上存在**的包。如果你同时处理开发中的多个模块，其中一个模块依赖于另一个模块，则此功能非常有用。

注意：如果你不想使用 `go mod edit` 命令，你也可以可以手动编辑 `go.mod` 文件以进行这些更改。两种方式都是可行的。

## 升级到新版本

`go fix` 工具最初于 2011 年发布（当时仍在对 Go 的 API 进行定期更改），以帮助用户自动更新旧代码以与最新版的 Go 兼容。从那以后，Go 的[兼容性承诺](https://golang.org/doc/go1compat)意味着如果你从 Go 1.x 版本升级到更新的 Go 1.x 版本，一切都应该正常工作，并且通常没有必要使用 `go fix`

但是，在某些具体的问题上，`go fix` 的确起到了作用。你可以通过运行 `go tool fix -help` 来查看命令概述。如果你决定在升级后需要运行 `go fix`，则应该运行以下命令，然后在提交之前检查更改的差异。

```shell
$ go fix ./...
```

## 报告问题

如果你确信在 Go 的标准库、工具和文档中找到了未报告的问题，则可以使用 `Go bug` 命令提出新的 Github issue。

```shell
$ go bug
```

这将会打开一个包含了系统信息和报告模板的 issue 填写页面。

## 速查表

**2019-04-19 更新：[@FedirFR](https://twitter.com/FedirFR) 基于这篇文章制作了一个速查表。你可以[点击这里下载](https://github.com/fedir/go-tooling-cheat-sheet/blob/master/go-tooling-cheat-sheet.pdf)。**

[![](https://www.alexedwards.net/static/images/tooling-7.png)](https://github.com/fedir/go-tooling-cheat-sheet/blob/master/go-tooling-cheat-sheet.pdf)

如果你喜欢这篇文章，请不要忘记查看我的新书《如何[用 Go 构建专业的 Web 应用程序](https://lets-go.alexedwards.net/)》。

你可以在 Twitter 上关注我 [@ajmedwards](https://twitter.com/ajmedwards)。

文中的所有代码片段均可在 [MIT 许可证](http://opensource.org/licenses/MIT)下自由使用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
