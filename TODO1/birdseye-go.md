> * 原文地址：[A bird's eye view of Go](https://blog.merovius.de/2019/06/12/birdseye-go.html)
> * 原文作者：[Axel Wagner](https://blog.merovius.de)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/birdseye-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/birdseye-go.md)
> * 译者：[JackEggie](https://github.com/JackEggie)
> * 校对者：[40m41h42t](https://github.com/40m41h42t), [JalanJiang](https://github.com/JalanJiang)

# Go 语言概览

**本文摘要：本文非常笼统地总结了 Go 语言的定义、生态系统和实现方式，也尽力给出了与不同的需求所对应的参考文档，详情参见本文末尾。**

每当我们说起“Go 语言”的时候，可能会因为场景的不同聊到很多完全不同的东西。因此，我尝试着对 Go 语言和其生态系统做一个概述，并在各部分内容中都列出相关的文档（这可能有点像是大杂烩，其中还包含了我最近实际遇到的许多问题）。让我们开始吧：

#### Go 编程语言

Go 语言是一种编程语言。作为一种权威，[Go 语言规范](https://golang.org/ref/spec)中定义了代码的格式规范和代码所代表的含义。不符合该规范的都不是 Go 语言。同样地，该规范中**没有**提到的内容不视为该语言的一部分。目前由 Go 语言开发团队维护该规范，每半年发布一个新版本。在我写这篇文章的时候最新的版本是 `1.12`。

Go 语言规范规定了：

* 语法
* 变量的类型、值，及其语义
* 预先声明的标识符及其含义
* Go 程序的运行方式
* 特殊的 [unsafe 包](https://golang.org/ref/spec#Package_unsafe)（虽然没有包含所有的语义）

该规范**应该**已经足够让你实现一个 Go 语言的编译器了。实际上，已经有很多人基于此实现了许多不同的编译器。

#### Go 编译器及其运行时

该语言规范只是一份文本文档，它本身不太有用。你需要的是实现了这些语义的软件，即编译器（分析、检查源代码，并将其转换为可执行的形式）和运行时（提供运行代码时所需的环境）。有很多这样的软件组合，他们都或多或少有些不同。示例如下：

* `gc`，Go 语言开发团队自己开发的纯 Go 语言实现的（有一小部分汇编实现）编译器和运行时。它随着 Go 语言一起发布。与其他此类工具不同的是，`gc` 并不**严格**区分编译器、组装器和链接器 —— 它们在实现的时候共享了大量的代码，并且会共享或传递一些重要职责。因此，通常无法链接由不同版本的 `gc` 所编译的包。
* [gccgo 和 libgo](https://golang.org/doc/install/gccgo)，gcc 的前端和其运行时。它是用 C 实现的，并且也由 Go 开发团队维护。然而，由于它是 gcc 组织的一部分，并根据 gcc 的发布周期发布，因此通常会稍微落后于 Go 语言规范的“最新”版本。
* [llgo](https://llvm.org/svn/llvm-project/llgo/trunk/README.TXT)，LLVM 的前端。我对其不太了解。
* [gopherjs](https://github.com/gopherjs/gopherjs)，将 Go 代码编译为 JavaScript，并使用一个 JavaScript VM 和一些自定义代码作为运行时。长远来看，由于 `gc` 获得了 WebAssembly 的原生支持，它有可能会被淘汰。
* [tinygo](https://tinygo.org/)，针对小规模编程的不完整实现。它可以通过自定义一个运行时运行在微控制器（裸机）或者 WebAssembly 虚拟机上。由于它的局限性，**技术上来说**它并没有实现 Go 语言的所有特性 —— 主要体现在它缺少垃圾回收器、并发和反射。

还有更多其他的实现，但这已经足以让你了解不同的实现方式。以上每一种方法都使用了不同的方式来实现 Go 语言，并具有自己与众不同的特性。他们可能存在的不同之处有（为了说明这一点，下面的某些说法可能会有点奇特）：

* `int`/`uint` 的大小 —— 长度可能为 32 位或 64 位。
* 运行时中基础功能的实现方式，如内存分配、垃圾回收和并发的实现。
* 遍历 `map` 的顺序并没有在 Go 语言中定义 —— `gc` 显然会将这类操作随机化，而 `gopherjs` 会用你使用的 JavaScript 实现遍历。
* `append` 操作分配的所需额外内存空间大小 —— 但是，**在分配额外空间时**，**不会**再次分配更多的内存空间。
* `unsafe.Pointer` 与 `uintptr` 之间的转换方式。特别指出，`gc` 对于该转换何时应该生效有自己的[规则](https://godoc.org/unsafe#Pointer)。通常情况下，`unsafe` 包是虚拟的，它会在编译器中被实现。

一般来说，根据规范中没有提到的某些细节（尤其是上面提到的那些细节）可以使你的程序用不同的编译器也能**编译**，但往往程序不会像你预期的那样**正常工作**。因此，你应该尽力避免此类事情发生。

如果你的 Go 语言是通过“正常”渠道安装的话（在官网上下载安装，或是通过软件包管理器安装），那么你会得到 Go 开发团队提供的 `gc` 和正式的运行时。在本文中，当我们在讨论“Go 是如何做的”时，若没有在上下文特别指明，我们通常就是在谈论 `gc`。因为它是最重要的一个实现。

#### 标准库

[标准库](https://golang.org/pkg/#stdlib)是 Go 语言中附带的一组依赖包，它可以被用来立即构建许多实用的应用程序。它也由 Go 开发团队维护，并且会随着 Go 语言和编译器一起发布。一般来说，标准库的某种实现只能依赖与其共同发布的编译器才能正常使用。因为大部分（但不是所有）运行时都是标准库的一部分（主要包含在 `runtime`、`reflect`、`syscall` 包中）。由于编译器在编译时需要兼容当前使用的运行时，因此它们的版本要相同。标准库的 **API** 是稳定的，不会以不兼容的方式改变，所以基于某个指定版本的标准库编写的 Go 程序在编译器的未来版本中也可以正常运行。

有些标准库会完全自己实现整个库中的所有内容，而有些则只实现一部分 —— 开发者尤其会在 `runtime`、`reflect`、`unsafe` 和 `syscall` 包中实现自定义的功能。举个例子，我相信 [AppEngine 标准库](https://cloud.google.com/appengine/docs/standard/go/)是出于安全考虑重新实现了标准库的部分功能的。这类重新实现的部分通常会尽量对用户保持透明。

还存在一种[标准库以外的独立库](https://golang.org/pkg/#subrepo)，通俗地说这就是 `x` 或者说是“扩展库”。这种库包含了 Go 开发团队同时开发和维护的部分代码，但是**不会**与 Go 语言有相同的发布周期，并且相比于 [Go 语言本身](https://golang.org/doc/go1compat)，兼容性也会较差（功能性和维护性也会较差）。其中的代码要么是实验性的（在未来可能会包含在标准库中），要么是比起标准库中的功能还不够泛用，或者是在某些罕见的情况下，提供一种开发者们可以与 Go 开发团队同步进行代码审查的方式。

再一次强调，如果没有额外地指出，在提到“标准库”时，我们指的是官方维护和发布的、托管在 [golang.org](https://golang.org/pkg) 上的 Go 标准库。

#### 代码构建工具

我们需要代码构建工具来使 Go 语言易于使用。构建工具的主要职责是找到需要编译的包和所有的依赖项，并依据必要的参数调用编译器和链接器。Go 语言有[对包的支持](https://golang.org/ref/spec#Packages)，允许在编译时把多个源代码文件视为一个单元。这也定义了导入和使用其他包的方式。但重要的是，这并没有定义导入包的路径与源文件的映射方式，也没有定义导入包在磁盘中的位置。因此，每种构建工具对于该问题都有不同的处理方式。你可以使用通用构建工具（如 Make 命令），但也有许多专门为 Go 语言而生的构建工具：

* [Go 语言工具](https://golang.org/cmd/go/)<sup><a href="#note1">[1]</a></sup>是 Go 开发团队官方维护的构建工具。它与 Go 语言（`gc` 和标准库）有相同的发布周期。它需要一个名为 `GOROOT` 的目录（该值从环境变量中获取，会在安装时产生一个默认值）来存放编译器、标准库和其他各种工具。它要求所有的源代码都要存放在一个名为 `GOPATH` 的目录下（该值也从环境变量中获取，默认为 `$HOME/go` 或是一个与其相等的值）。举例来说，包 `a/b` 的源代码应该位于诸如 `$GOPATH/src/a/b/c.go` 的路径下。并且 `$GOPATH/src/a/b` 路径下应该**只**包含一个包下的源文件。在分布式的模式下，有一种机制可以[从任意服务器上递归地下载某个包及其依赖项](https://golang.org/cmd/go/#hdr-Remote_import_paths)，即使这种机制不支持版本控制或是下载校验。Go 语言工具中也包含了许多其他工具包，包括用于测试 Go 代码的工具、阅读文档的工具（[golang.org](https://golang.org) 是用 Go 语言工具部署的）、提交 bug 的工具和其他各种小工具。
* [gopherjs](https://github.com/gopherjs/gopherjs) 自带的构建工具，它在很大程度上模仿了 Go 语言工具。
* [gomobile](https://github.com/golang/go/wiki/Mobile) 是一个专门为移动操作系统构建 Go 代码的工具。
* [dep](https://github.com/golang/dep)、[gb](https://getgb.io/)、[glide](https://glide.sh/) 等等是社区开发的构建和依赖项管理工具，它们各自都有自己独特的文件布局方式（有些可以与 Go 语言工具兼容，有些则不兼容）和依赖项声明方式。
* [bazel](https://bazel.build/) 是谷歌内部构建工具的开源版本。虽然它的使用实际上并不限于 Go 语言，但我之所以把它列为单独的一项，是因为人们常说 Go 语言工具旨在为谷歌服务，而与社区的需求相冲突。然而，Go 语言工具（和其他许多开放的工具）是无法被谷歌所使用的，原因是 bazel 使用了不兼容的文件布局方式。

代码构建工具是大多数用户在编写代码时直接使用的重要工具，因此它很大程度上决定了 **Go 语言生态系统**的方方面面，也决定了包的组合方式，这也将影响 Go 程序员之间的沟通和交流方式。如上所述，Go 语言工具是被隐式引用的（除非指定了其他的运行环境），因此它的设计会让公众对 “Go 语言”的看法造成很大的影响。虽然有许多替代工具可供使用，这些工具也已经在如公司内部使用等场景被广泛使用，但是开源社区**通常**希望 Go 语言工具与 Go 语言的使用方式相契合，这意味着：

* 可以获取源代码。Go 语言工具对包的二进制分发只做了极其有限的支持，并且仅有的支持将会在将来的版本中移除。
* 要依据 [Go 官方文档编排格式](https://blog.golang.org/godoc-documenting-go-code)来撰写文档。
* 要[包含测试用例](https://golang.org/pkg/testing/#pkg-overview)，并且能通过 `go test` 运行测试。
* 可以完全通过 `go build` 来编译（与后面所述的特征共同被称为“可以通过 Go 得到的” —— “go-gettable”）。特别指出，如果需要生成源代码或是元编程，则使用 [go generate](https://golang.org/pkg/cmd/go/internal/generate/) 并提交生成的构件。
* 通过命名空间导入的路径其第一部分是一个域名，该域名可以是一个代码托管服务器或者是该服务器上运行的一个 Web 服务，则 Go 代码可以找到源代码和其依赖，并且可以[正常工作](https://golang.org/cmd/go/#hdr-Remote_import_paths)。
* 每个目录都只有一个包，并且可以使用[代码构建约束条件](https://golang.org/pkg/go/build/#hdr-Build_Constraints)进行条件编译。

[Go 语言工具的文档](https://golang.org/cmd/go)非常全面，它是一个学习 Go 如何实现各种生态系统的良好起点。

#### 其他工具

Go 语言的标准库包含了[一些可以与 Go 源代码交互的包](https://golang.org/pkg/go/)和[包含了更多功能的 x/tools 扩展库](https://godoc.org/golang.org/x/tools/go)。Go 语言也因此在社区中有非常强的第三方工具开发文化（由于官方强烈地想要保持 Go 语言本身的精简）。这些工具通常需要知道源代码的位置，可能还需要获取类型信息。[go/build](https://golang.org/pkg/go/build/) 包遵循了 Go 语言工具的约定，因此它本身就可以作为其部分构建过程的文档。缺点则是，构建在它之上的工具有时与基于其他构建工具的代码不兼容。因此有[一个新的包正在开发中](https://godoc.org/golang.org/x/tools/go/packages)，它可以与其他构建工具很好地集成。

实际上 Go 语言的工具有非常多，并且每个人都有自己的偏好。但大致如下：

* [Go 语言开发团队所研发的工具，与 Go 语言有相同的发布周期](https://golang.org/cmd/)。
* 它包含[代码自动格式化工具](https://golang.org/cmd/gofmt/)、[测试覆盖率工具](https://golang.org/cmd/cover/)、[运行时追踪工具](https://golang.org/cmd/trace/)、[信息收集工具](https://golang.org/cmd/pprof/)、[针对常见错误的静态分析器](https://golang.org/cmd/vet/)、[一款已经废弃的 Go 代码升级工具](https://golang.org/cmd/fix/)。这些工具都可以通过 `go tool <cmd>` 命令来访问。
* [由 Go 开发团队所维护，但不随 Go 语言一起发布的工具](https://godoc.org/golang.org/x/tools/cmd)。[博客文章编写工具和演示工具](https://godoc.org/golang.org/x/tools/cmd/present)、[大型代码重构工具](https://godoc.org/golang.org/x/tools/cmd/eg)、[导入路径自动修正工具](https://godoc.org/golang.org/x/tools/cmd/goimports)和[语言服务器](https://godoc.org/golang.org/x/tools/cmd/gopls)。
* 第三方工具 —— 实在太多了。有很多关于第三方工具的列表，例如[这个](https://github.com/avelino/awesome-go#tools)。

#### 总结

我想用一个简短的参考文献列表来结束这篇文章，列表的内容是为那些感到迷茫的初学者准备的。请点击下面的链接：

* [开始学习 Go 语言](https://tour.golang.org/welcome/1)。
* [理解 Go 语言的工作方式](https://golang.org/doc/effective_go.html)。
* [什么是合法的 Go 代码及其原因](https://golang.org/ref/spec)。
* [Go 语言工具及其文档](https://golang.org/cmd/go/)，也可以通过 `go help` 查看。有时会涉及到其他内容，你也可以查看[这些不够精细的内容](https://golang.org/pkg/cmd/go/internal/help/)。
* [编写符合社区标准的代码](https://github.com/golang/go/wiki/CodeReviewComments)。
* [对代码进行测试](https://golang.org/pkg/testing/#pkg-overview)。
* [寻找新的依赖包或查看公用包的文档](https://godoc.org/)。

除此以外还有许多有价值的文档可以作为补充，但这些应该已经足够让你有一个良好的开端了。作为一个 Go 语言的初学者，如果你发现本文有任何遗漏之处（我可能会补充更多的细节）或者你找到了任何有价值的参考资料，请[通过 Twitter 联系我](https://twitter.com/TheMerovius)。如果你已经是一个经验丰富的 Go 语言开发者，并且你发现我遗漏了某些重要的内容（但是我有意忽略了一些重要的参考资料，使得初学者们可以感受到 Go 语言学习中的新鲜感:smile:），也请给我留言。

---

[1]<a name="note1"></a> 注：Go 开发团队目前正在对**模块**做一些支持，模块是包之上的代码分发单元，这些支持包括版本控制和一些可以使“传统” Go 语言工具解决问题的基础工作。等这些支持完成以后，这一段中的所有内容基本上就都过时了。对模块的支持**目前**是有的，但还不是 Go 语言的一部分。由于本文的核心内容是对 Go 语言的不同组成部分进行简要介绍，这些内容是不太容易发生变化的，**目前来看**我认为理解这些历史问题也是很有必要的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
