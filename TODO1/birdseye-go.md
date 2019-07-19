> * 原文地址：[A bird's eye view of Go](https://blog.merovius.de/2019/06/12/birdseye-go.html)
> * 原文作者：[Axel Wagner](https://blog.merovius.de)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/birdseye-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/birdseye-go.md)
> * 译者：
> * 校对者：

# A bird's eye view of Go

**tl;dr: I provide a very high-level overview of what Go-the-language means vs. Go-the-ecosystem vs. Go-an-implementation. I also try to provide specific references to what documentation is most useful for what purpose. See the bottom-most section for that.**

When we talk about "Go", depending on context, we can mean very different things. This is my attempt at providing a very high-level overview of the language and ecosystem and to link to the relevant documentation about how each part fits together (it's also a bit of a hodgepodge though, addressing individual random questions I encountered recently). So, let's dive in:

#### The Go programming language

The bottom turtle is Go, the programming language. It defines the format and meaning of source code and the authoritative source is [the Go language specification](https://golang.org/ref/spec). If something doesn't conform to the spec, it's not "Go". And conversely, if something **isn't** mentioned in the spec it's not part of the language. The language spec is maintained by the Go team and versioned, with a new release roughly every six months. At the time I wrote this post, the newest release was version `1.12`.

The domain of the spec are

* The grammar of the language
* Types, values and their semantics
* What identifiers are predeclared and what their meaning is
* How Go programs get executed
* The special package [unsafe](https://golang.org/ref/spec#Package_unsafe) (though not all of its semantics)

The spec alone **should** enable you to write a compiler for Go. And indeed, there are many different compilers.

#### A Go compiler and runtime

The language spec is a text document, which is not useful in and of itself. For that you need software that actually implements these semantics. This is done by a compiler (which analyzes and checks the source code and transforms it into an executable format) and a runtime (which provides the necessary environment to actually run the code). There are many such combinations and they all differ a bit more or a bit less. Examples are

* `gc`, a compiler and runtime written in pure Go (with some assembly) by the Go team themselves and versioned and released together with the language. Unlike other such tools, `gc` doesn't **strictly** separate the compiler, assembler and linker - they end up sharing a lot of code and some of the classical responsibilities move or are shared between them. As such, it's in general not possible to e.g. link packages compiled by different versions of `gc`.
* [gccgo and libgo](https://golang.org/doc/install/gccgo), a frontend for gcc and a runtime. It's written in C and maintained by the Go team. It lives in the gcc organization though and is released according to the gcc release schedule and thus often lags a bit behind the "latest" version of the Go spec.
* [llgo](https://llvm.org/svn/llvm-project/llgo/trunk/README.TXT), a frontend for LLVM. I don't know much else about it.
* [gopherjs](https://github.com/gopherjs/gopherjs), compiling Go code into javascript and using a javascript VM plus some custom code as a runtime. Long-term, it'll probably be made obsolete by `gc` gaining native support for WebAssembly.
* [tinygo](https://tinygo.org/), an incomplete implementation targeting small code size. Runs on either bare-metal micro-controllers or WebAssembly VMs, with a custom runtime. Due to its limitations it doesn't **technically** implement Go - notably, it doesn't include a garbage collector, concurrency or reflection.

There are more, but this gives you an overview over the variety of implementations. Each of these made potentially different choices for how to implement the language and have their own idiosyncrasies. Examples (some of them a bit exotic, to illustrate) where they might differ are:

* Size of `int`/`uint` \- the language allows them to be either 32 or 64 bit wide.
* How fundamental functionalities of the runtime, like allocation, garbage collection or concurrency are implemented.
* The order of ranging over a `map` isn't defined in the language - `gc` famously explicitly randomizes it, `gopherjs` uses (last time I checked) whatever the javascript implementation you are running on uses.
* How much extra space `append` allocates if it needs to - **not** however, **when** it allocates extra space.
* How conversions between `unsafe.Pointer` and `uintptr` happen. `gc`, in particular, comes with its own [set of rules](https://godoc.org/unsafe#Pointer) regarding when these conversions are valid and when they aren't. In general, the `unsafe` package is virtual and implemented in the compiler.

In general, relying on details not mentioned in the spec (in particular the ones mentioned here) makes your program **compile** with different compilers, but not **work** as expected. So you should avoid it if possible.

If you install Go via a "normal" way (by downloading it from the website, or installing it via a package manager), you'll get `gc` and the official runtime by the Go team. And if the context doesn't imply otherwise, when we talk about how "Go does things", we usually refer to `gc`. It's the main implementation.

#### The standard library

[The standard library](https://golang.org/pkg/#stdlib) is a set of packages that come with Go and can be relied upon to immediately build useful applications with. It too is maintained by the Go team and versioned and released together with the language and compiler. In general the standard library of one implementation will only work with the compiler it comes with. The reason is that most (but not all) of the runtime is part of the standard library (mainly in the packages `runtime`, `reflect`, `syscall`). As the compiler needs to generate code compatible with the used runtime, both need to come from the same version. The **API** of the standard library is stable and won't change in incompatible ways, so a Go program written against a given version of the standard library will continue to work as expected with future versions of the compiler.

Some implementations use their own version of some or all of the standard library - in particular, the `runtime`, `reflect`, `unsafe` and `syscall` packages are completely implementation-defined. As an example, I believe that [AppEngine Standard](https://cloud.google.com/appengine/docs/standard/go/) used to re-define parts of the standard library for security and safety. In general, implementations try to make that transparent to the user.

There is also a [separate set of repositories](https://golang.org/pkg/#subrepo), colloquially referred to as `x` or "the subrepositories". They contain packages which are developed and maintained by the Go team with all the same processes, but are **not** on the same release schedule as the language and have less strict compatibility guarantees (and commitment to maintainership) than [Go itself](https://golang.org/doc/go1compat). The packages in there are either experimental (for potential future inclusion in the standard library), not widely useful enough to be included in the standard library or, in rare cases, a way for people on the Go team to work on code using the same review processes they are used to.

Again, when referring to "the standard library" devoid of extra context, we mean the officially maintained and distributed one, hosted on [golang.org](https://golang.org/pkg).

#### The build tool

To make the language user-friendly, you need a build tool. The primary role of this tool is to find the package you want to compile, find all of its dependencies, and execute the compiler and linker with the arguments necessary to build them. Go (the language) has [support for packages](https://golang.org/ref/spec#Packages), which combine multiple source files into one unit of compilation. And it defines how to import and use other packages. But importantly, it doesn't define how import paths map to source files or how they are laid out on disk. As such, each build tool comes with its own ideas for this. It's possible to use a generic build tool (like Make) for this purpose, but there are a bunch of Go-specific ones:

* [The go tool](https://golang.org/cmd/go/)<sup><a href="#note1">[1]</a></sup> is the build tool officially maintained by the Go team. It is versioned and released with the language (and `gc` and the standard library). It expects a directory called `GOROOT` (from an environment variable, with a compiled default) to contain the compiler, the standard library and various other tools. And it expects all source code in a single directory called `GOPATH` (from an environment variable, defaulting to `$HOME/go` or equivalent). Specifically, package `a/b` is expected to have its source at `$GOPATH/src/a/b/c.go` etc. And `$GOPATH/src/a/b` is expected to **only** contain source files of one package. It also has a mechanism to [download a package and its dependencies recursively from an arbitrary server](https://golang.org/cmd/go/#hdr-Remote_import_paths), in a fully decentralized scheme, though it does not support versioning or verification of downloads. The go tool also contains extra tooling for testing Go code, reading documentation ([golang.org](https://golang.org) is served by the Go tool), file bugs, run various tools…
* [gopherjs](https://github.com/gopherjs/gopherjs) comes with its own build tool, that largely mimics the Go tool.
* [gomobile](https://github.com/golang/go/wiki/Mobile) is a build tool specifically to build Go code for mobile operating systems.
* [dep](https://github.com/golang/dep), [gb](https://getgb.io/), [glide](https://glide.sh/),… are community-developed build-tools and dependency managers, each with their own approach to file layout (some are compatible with the go tool, some aren't) and dependency declarations.
* [bazel](https://bazel.build/) is the open source version of Google's own build system. While it's not actually Go-specific, I'm mentioning it explicitly due to common claims that idiosyncrasies of the go tool are intended to serve Google's own use cases, in conflict with the needs of the community. However, the go tool (and many public tools) can't be used at Google, because bazel uses an incompatible file layout.

The build tool is what most users directly interface with and as such, it's what largely determines aspects of the **Go ecosystem** and how packages can be combined and thus how different Go programmers interact. As above, the go tool is what's implicitly referred to (unless other context is specified) and thus its design decisions significantly influence public opinion about "Go". While there are alternative tools and they have wide adoption for use cases like company-internal code, the open source community **in general** expects code to conform to the expectations of the go tool, which (among other things) means:

* Be available as source code. The go tool has little support for binary distribution of packages, and what little it has is going to be removed soon.
* Be documented according to [the godoc format](https://blog.golang.org/godoc-documenting-go-code).
* [Have tests](https://golang.org/pkg/testing/#pkg-overview) that can be run via `go test`.
* Be fully compilable by a `go build` (together with the next one, this is usually called being "go-gettable"). In particular, to use [go generate](https://golang.org/pkg/cmd/go/internal/generate/) if generating source-code or metaprogramming is required and commit the generated artifacts.
* Namespace import paths with a domain-name as the first component and have that domain-name either be a well-known code hoster or have a webserver running on it, so that [go get works](https://golang.org/cmd/go/#hdr-Remote_import_paths) and can find the source code of dependencies.
* Have one package per directory and use [build constraints](https://golang.org/pkg/go/build/#hdr-Build_Constraints) for conditional compilation.

The [documentation of the go tool](https://golang.org/cmd/go) is very comprehensive and probably a good starting point to learn how Go implements various ecosystem aspects.

#### Tools

Go's standard library includes [several packages to interact with Go source code](https://golang.org/pkg/go/) and the [x/tools subrepo contains even more](https://godoc.org/golang.org/x/tools/go). As a result (and due to a strong desire to keep the canonical Go distribution lean), Go has developed a strong culture of developing third-party tools. In general, these tools need to know where to find source code, and might need access to type information. The [go/build](https://golang.org/pkg/go/build/) package implements the conventions used by the Go tool, and can thus also serve as documentation for parts of its build process. The downside is that tools built on top of it sometimes don't work with code relying on other build tools. That's why there is a [new package in development](https://godoc.org/golang.org/x/tools/go/packages) which integrates nicely with other build tools.

By its nature the list of Go tools is long and everybody has their own preferences. But broadly, they contain:

* [Tools developed by the Go team and released as part of the distribution](https://golang.org/cmd/).
* This includes tools for [automatically formatting source code](https://golang.org/cmd/gofmt/), [coverage testing](https://golang.org/cmd/cover/), [runtime tracing](https://golang.org/cmd/trace/) and [profiling](https://golang.org/cmd/pprof/), a [static analyzer for common mistakes](https://golang.org/cmd/vet/) and [a mostly obsolete tool to migrate code to new Go versions](https://golang.org/cmd/fix/). These are generally accesed via `go tool <cmd>`.
* [Tools developed by the Go team and maintained out-of-tree](https://godoc.org/golang.org/x/tools/cmd). This includes tools to [write blog posts and presentations](https://godoc.org/golang.org/x/tools/cmd/present), [easily do large refactors](https://godoc.org/golang.org/x/tools/cmd/eg), [automatically find and fix import paths](https://godoc.org/golang.org/x/tools/cmd/goimports) and a [language server](https://godoc.org/golang.org/x/tools/cmd/gopls).
* Third-party tools - too many to count. There are many lists of these; [here is one](https://github.com/avelino/awesome-go#tools).

#### In Summary

I wanted to end this with a short list of references for beginners who feel lost. So this is where you should go, if you:

* [Want to start learning Go](https://tour.golang.org/welcome/1).
* [Want to understand how a specific language construct works](https://golang.org/doc/effective_go.html).
* [Want to nitpick what is or is not valid Go and why](https://golang.org/ref/spec).
* [Want documentation about what the go tool does](https://golang.org/cmd/go/) Also available via `go help`. It sometimes references other topics, that you can also [see on the web](https://golang.org/pkg/cmd/go/internal/help/), but not nicely.
* [Want to write code that adheres to community standards](https://github.com/golang/go/wiki/CodeReviewComments).
* [Want to test your code](https://golang.org/pkg/testing/#pkg-overview).
* [Want to find new packages or look at documentation of public packages](https://godoc.org/).

There are many more useful supplementary documents, but this should serve as a good start. Please [let me know on Twitter](https://twitter.com/TheMerovius) if you are a beginner and there's an area of Go you are missing from this overview (I might follow this up with more specific topics), or a specific reference you found helpful. You can also drop me a note if you're a more experienced Gopher and think I missed something important (but keep in mind that I intentionally left out most references, so as to keep the ways forward crisp and clear :) ).

---

\[1\]<a name="note1"></a>  Note: The Go team is currently rolling out support for **modules**, which is a unit of code distribution above packages, including support for versioning and more infrastructure to solve some issues with the "traditional" go tool. With that, basically everything in that paragraph becomes obsolete. However, **for now** the module support exists but is opt-in. And as the point of this article is to provide an overview of the separation of concerns, which doesn't actually change, I felt it was better to stay within ye olden days - **for now**.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
