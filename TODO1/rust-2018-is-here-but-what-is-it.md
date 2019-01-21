> * 原文地址：[Rust 2018 is here… but what is it?](https://hacks.mozilla.org/2018/12/rust-2018-is-here/)
> * 原文作者：[Lin Clark](http://code-cartoons.com/), [The Rust Team](https://www.rust-lang.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/rust-2018-is-here-but-what-is-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/rust-2018-is-here-but-what-is-it.md)
> * 译者：[子非](https://www.github.com/coolrice)
> * 校对者：[iceytea](https://github.com/iceytea)

# Rust 2018 已经发布……但它到底是什么呢？

**本文是与 Rust 团队（指文中“我们”）合著。你也可在 Rust 博客上阅读[他们的声明](https://blog.rust-lang.org/2018/12/06/Rust-1.31-and-rust-2018.html)**

今天，Rust 2018 发布了它的第一个版本，在这个版本中，我们专注于提高生产力，让 Rust 开发人员尽可能高效。

[![时间线显示了不同的进程，Rust 2018 和 Rust 2015，并且 beta 版上的功能指向另两个版本。包围时间线的是工具图标及 4 个领域：WebAssembly，嵌入式，网络和命令行界面(CLI)。一个红色的环包围了所有的东西（除了 Rust 2018 字样和 Developer Productivity 标签）](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_01-rust2018-500x549.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_01-rust2018.png)

但除了这些，很难准确解释 Rust 2018 是什么。

一些人认为它是一门语言的新版本，确实可以这么认为，但其实又不完全是。我说“不完全是”是因为如果这是语言新版本，它并不像其它语言的版本更新。

在大多数其它语言中，当新版本到来时任何新功能都会添加到此版本中。之前版本并不会得到功能更新。

Rust 的版本则不同。这是因为语言的演进方式不同。几乎所有新功能都会 100% 兼容原有的 Rust。他们不需要重大的更新。这意味着不需要把他们限制在 Rust 2018 代码中。新版本的编译器会继续支持“Rust 2015 模式”，也就是你默认使用的模式。

然而因为有时候要改进语言，你必须添加新的东西（像新语法）。并且这类新语法会在老的代码库下执行失败。

拿 `async/await` 举例来说。Rust 最初并没有 `async` 和 `await` 的概念。但是事实证明这些简单的语法实际上非常有用。它们让异步代码易于编写并且不会使代码变得笨重。

为了让添加这个功能成为可能，我们需要把 `async` 和 `await` 添加为关键字。但我们必须小心不能使旧代码失效……代码可能会把 `async` 或 `await` 当做变量名使用。

所以我们把添加关键字作为 Rust 2018 的一部分。虽然这个功能本身还没实现，但现在关键字已经被保留。接下来三年开发（例如添加关键字）所需的所有重大变化都是在 Rust 1.3.1 中一次性完成的。

[![时间线显示 Rust 2015 连接到 Rust 2018 发布的 1.31版本](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_02-breaking-changes-02-500x353.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_02-breaking-changes-02.png)

虽然 Rust 2018 有重大的变化，但这并不意味着你的代码会执行失败。你的代码会继续编译甚至会把 `async` 或 `await` 当做变量名。除非你告诉它，不然编译器会假设你想让它当前以相同的方式来编译代码。

不过一旦你想使用这些新的重大功能，你可以设置成 Rust 2018 模式。你仅需要执行 `cargo fix`，它会告诉你如果你需要更新你的代码来使用新功能。它几乎可以自动地处理更改。然后你可以添加 `edition=2018` 到你的 Cargo.toml 来设置和使用新功能。

Cargo.toml 中的 edition 说明符不适用于你的整个项目……它不适用于你的依赖。它只限于一个包。这意味着你将能够拥有相互依赖的 Rust 2015 和 Rust 2018 包。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_03-crate-graph-500x330.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_03-crate-graph.png)

因此，即使 Rust 2018 已经出现，它大致看起来与 Rust 2015 相同。大多数变化都将同时出现在 Rust 2018 和 Rust 2015 中。只有少数需要重大变化的功能不会同步支持。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_04-rust2018-only-500x290.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_04-rust2018-only.png)

Rust 2018 不仅仅是对核心语言的改变。事实上，远非如此。

Rust 2018 致力于提高 Rust 开发人员的工作效率。许多生产力的提高来自核心语言以外的东西……比如工具。他们还专注于特定用例，并弄清楚 Rust 如何成为这些用例最有效的语言。

因此，你可以将 Rust 2018 视为 Cargo.toml 中的说明符，你可以使用它来启用少数需要重大更改的功能……

[![时间线的箭头指向几个 Rust 2018 的功能，这些功能在 Rust 2015 中不会通过。](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_05-handful-of-changes-500x381.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_05-handful-of-changes.png)

或者你可以把它想象成一个时刻，在许多情况下，Rust 成为你可以使用的最有效的语言之一 —— 每当你需要性能，轻巧的实现或高可靠性时。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_06-as_this-500x463.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/01_06-as_this.png)

在我们看来，这是第二点。让我们先来看看核心语言之外的所有事情。然后我们可以深入研究核心语言本身。

## 针对特定用例的 Rust

抽象描述的编程语言自身并不能高效，但在一些用例中它会很有效。因此，团队知道我们不仅需要将 Rust 作为一种语言或 Rust 工具更好，我们还需要在特定领域中使 Rust 更容易使用。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/02_01-specific-use-cases-500x376.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/02_01-specific-use-cases.png)

在某些情况下，这意味着要为一个全新的生态系统创建一套全新的工具。

在其他情况下，它意味着打磨已经存在于生态系统中的内容并将文档做好，以便保持生态系统的成长和正常运作。

Rust 团队成立了专注于四个领域的工作组：

*   WebAssembly
*   嵌入式应用
*   网络
*   命令行工具

### WebAssembly

对于 WebAssembly，工作组需要创建一整套新工具。

就在去年，WebAssembly 让[编译像 Rust 这样的语言在 Web 上运行](https://hacks.mozilla.org/2017/02/creating-and-working-with-webassembly-modules/)成为可能。从那时起，Rust 迅速成为与现有 Web 应用程序集成的最佳语言。

[![Rust logo 和 JS logo 之间有一颗心](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/03/01_rust_loves_js-500x201.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/03/01_rust_loves_js.png)

Rust 非常适合 Web 开发，原因有两个：

1.  Cargo 包生态系统的工作方式与大多数 Web 应用程序开发人员习惯的方式相同。你将一堆小模块组合在一起构成一个更大的应用程序。这意味着在你需要的地方可以很容易地使用 Rust。
2.  Rust 实现简单并且不需要特定的运行环境。这意味着你无需嵌入大量代码。如果你需要一个很小的模块进行大量繁重的计算工作，你可以引入几行 Rust 来加快运行速度。

使用[`web-sys` 和 `js-sys` crates](https://rustwasm.github.io/2018/09/26/announcing-web-sys.html)，很容易在 Rust 代码调用类似于 `fetch` 或 `appendChild` 的 Web API 。并且 `wasm-bindgen` 可以轻松支持 WebAssembly 原生不支持的高级数据类型。

一旦编写了 Rust WebAssembly 模块，就可以使用各种工具将其嵌入到 Web 应用程序的其余部分中。你可以使用 [wasm-pack](https://github.com/rustwasm/wasm-pack) 自动运行这些工具，并根据需要将新模块推送到 npm。

Check out the [Rust and WebAssembly book](https://rustwasm.github.io/book/) to try it yourself.
建议你查看 [Rust 嵌入式书籍](https://rust-embedded.github.io/book/)并亲自尝试一下。

#### What’s next?
#### 下一步呢？

现在 Rust 2018 已经完成，工作组正在确定下一步要做什么。他们将与社区合作，确定下一个重点领域。

### 嵌入式

对于嵌入式的开发，工作组需要使现存的功能稳定。

理论上，Rust 对于嵌入式开发来说已经是非常出色的语言了。它为嵌入式开发人员提供了他们非常缺乏的现代工具，以及非常方便的高级语言功能。并且不需要耗费资源。因此，Rust 似乎非常适合嵌入式开发。

然而，实际上它并不好使用。必备的功能处在[不稳定阶段](https://blog.rust-lang.org/2014/10/30/Stability.html)。另外，为了在嵌入式设备上使用，需要对标准库做一些改变。这意味着人们必须编译他们自己版本的 Rust 核心包（用来给每个 Rust 应用提供 Rust 的基本构建模块 —— 内部模块和原始值）

[![左边：一个人骑在猛然弓背跃起的微处理器芯片上，说“Whoa, Rusty！”。右边，一个人骑在一个驯服的微处理器芯片上说“很好 Rusty，乖乖地保持稳定”](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/02_02-bronco-500x444.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/02_02-bronco.png)

总之，这两件事意味着开发人员必须依赖于 Rust 的每日构建版本。并且由于没有针对微控制器的自动化测试，每日构建版在这些目标上会经常出错

为了解决这个问题，工作组需要保证稳定版本有那些必要的功能。我们也必须向持续集成系统为微控制器目标添加测试。这意味着向桌面端组件添加功能不会破坏嵌入式组件的东西。

有了这些变化，Rust 的嵌入式开发将从有风险的前沿迈向高效。

建议你查看 [Rust 嵌入式书籍](https://rust-embedded.github.io/book/)并亲自尝试一下。

#### 下一步呢？

随着近年来的推进，Rust 已经很好地支持了 ARM Cortex-M 架构的芯片处理器核心，这些核心用于大量设备。然而，还有很多被用于嵌入式设备的架构没有得到很好的支持，并且没有被很好的支持。Rust 需要被扩展来给这些架构以同样水平的支持。

### 网络

对于网络来说，工作组需要构建核心抽象概念到语言中 —— `async/await`。这样，开发者可以在异步代码中使用符合语言习惯的 Rust。

对于网络任务来说，你必须要等待。例如，你可能需要等待请求的响应。如果你的代码是同步的，那意味着 CPU 核心正在执行的任务会停止而且不能会做其它的任何事情，直到请求进来。但如果你的代码是异步的，那么等待响应的函数会在 CPU 核心执行其它函数时挂起。

使用 Rust 2015 使异步编程成为可能。并且还有很多优点。从大的方面讲，像服务端应用之类的服务，你的异步代码使得每个服务器可以处理更多的连接。从小的方面讲，对于那些运行在小型单核 CPU 上的嵌入式应用，异步使你更好的利用单线程。

但这些优点也带来了一个大的缺点 —— 你不能为那些代码使用借用检查器，并且你将必须书写符合语法习惯的（和别的令人迷惑的） Rust。这就是 `async/await` 出现的理由。它给予编译器需要的信息，这些信息用来在异步函数之间调用 borrow check。

`async/await` 关键字在 1.31 被引入，虽然它们目前的实现还不能向下兼容。但大部分工作都已完成，并且你可以期待这个功能在将要到来的一个版本中可用。

#### 下一步呢？

除了为网络应用程序实现高效的低层次开发之外，Rust 还可以在更高层次上实现更高效的开发。

许多服务器需要去处理相同类型的任务。它们需要解析 URL 或者处理 HTTP 任务。如果把它们变成组件通用抽象类型，并且在包之间分享 —— 那么就可以轻松地把它们组合在一起来组成各种各样的服务和框架。

为了驱动组件开发过程，[Tide 组件](https://github.com/rust-net-web/tide) 为这些组件提供了测试平台，并最终展示这些组件。

### 命令行工具

对于命令行工具，工作组需要给更小，更低级的库引入高级的抽象，并且打磨已有的工具。

对于一些 CLI 脚本，你真的很想使用 bash。例如，如果你仅仅需要唤出其他 shell 工具并在它们之间使用管道传输数据，bash 是最好的选择。

不过 Rust 也非常适于其他的命令行工具。比如你正在构建一个复杂的工具像 [ripgrep](https://github.com/BurntSushi/ripgrep/) 或构建一个处在现有的库功能之上的 CLI。

Rust 不需要运行时并且允许你编译进单独的静态二进制文件，这样利于分发。并且你能得到其它语言向 C 或 C++ 得不到的高级抽象，这些特性已经让 Rust CLI 开发者更高效。

工作组需要做些什么来改善它？是更高级的抽象。

有了这些高级抽象，组合成熟的 CLI 会快速并轻松。

这些抽象中的其中一个是 [human panic](https://github.com/rust-clique/human-panic) 库。没有这个库，如果你的 CLI 代码报错，他可能会输出整个错误栈。但这对于你的终端用户没有帮助。你可以添加自定义错误处理，不过那需要额外工作。

如果你用了 human panic，那么输出会自动地转到错误转储文件。而用户会看到有帮助的消息建议他们报告这个问题并上传错误转储文件。

[![命令行使用 hunam-panic 友好地输出](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/02_04-human-panic-500x323.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/02_04-human-panic.png)

工作组也让 CLI 开发更容易入手。例如，[confy](https://github.com/rust-clique/confy) 库会自动处理一些新 CLI 工具的安装事项。它只会问你两件事：

*   你的应用叫什么名字？
*   你想暴露那些配置选项（你定义的结构可以被被序列化和反序列化）？

从这个问题出发，confy 会帮你处理剩余的事情。

#### 下一步呢？

The working group abstracted away a lot of different tasks that are common between CLIs. But there’s still more that could be abstracted away. The working group will be making more of these high level libraries, and fixing more paper cuts as they go.
工作组会抽象出很多不同的任务，这些任务可以在不同的 CLI 中共用。但是还有更多可以抽象的。工作组会制作更多类似的高级库，并随着时间推移解决更多的 [Pager cut bug](https://en.wikipedia.org/wiki/Paper_cut_bug)。

## Rust tooling
## Rust 工具

[![工具图标](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/03_01-tooling-1-500x435.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/03_01-tooling-1.png)

当你体验一门语言时，你需要通过工具来体验。从你使用的编辑器开始，它贯穿于开发和维护的各个阶段。

这意味着高效的语言依赖于高效工具。

这里有一些工具（包含一些现有 Rust 工具的改进）会作为 Rust 2018 的一部分被引进。

### IDE 支持

当然，高效的关键是将代码从头脑中迅速传递到屏幕上。IDE 的支持严重影响这一点。为了支持 IDE，我们需要一些工具来告诉 IDE Rust 代码的实际含义 —— 例如，告诉 IDE 什么字符串对代码完成有意义。

在 Rust 2018 推送中，社区聚焦于 IDE 需要的功能。随着 Rust Language Server 和 IntelliJ Rust 的发展，现在许多 IDE 已经能够对 Rust 有良好的支持。

### 更快的编译

更快的编译意味着更高效。所以我们使编译器更快。

以前，当你想编译 Rust 包，编译器会重复编译每个包里的单独文件。但是现在，使用[增量编译](https://rust-lang-nursery.github.io/edition-guide/rust-2018/the-compiler/incremental-compilation-for-faster-compiles.html)让编译器变得智能并且只会重复编译已经改变的部分。这和[其它的优化](https://blog.mozilla.org/nnethercote/2018/04/30/how-to-speed-up-the-rust-compiler-in-2018/)一起使得 Rust 编译器更加迅速。

### rustfmt

高效也意味着不需要每天解决风格问题（再不需要去争论代码风格规则）。

rustfmt 工具通过使用（[已与社区达成共识的](https://github.com/rust-lang/rfcs/pull/2436)）默认代码风格自动格式化你的代码。使用 rustfmt 保证你所有的 Rust 代码符合相同的风格。就像 C++ 使用 clang format 和 JavaScript 使用 Prettier 那样。

### Clippy

有时候你的身旁能有个经验丰富的顾问会非常好……给你提出一些代码的最佳实践。这就是 Clippy 做的东西 —— 它会审查你的代码实现并告诉你怎样让代码更符合语言习惯。

### rustfix

但是如果你在维护一个使用过时的语法的老旧代码库，那么只是获取提示并自己来纠正代码可能会很乏味。你只是希望有人进入代码库来更正这些问题。。

对于这些情况，rustfix 会自动化该过程。它会同时应用来自 Clippy 等工具的 lint 并更新旧的代码来匹配 Rust 2018 语法。

## Rust 本身的变化

生态系统的这些变化已经带来大量的生产力，但是一些生产力问题只能通过语言本身的变化来解决。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_01-language-500x377.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_01-language.png)

就像我在简介中说过的，大部分语言层面的变更完全兼容已有的 Rust 代码。这些变更都是 Rust 2018 变更的一部分。不过因为它们不会破坏原有任何代码，它们也可以在任何 Rust 代码中运行……甚至是没有使用 Rust 2018 的代码。

让我们看一些被加到全部版本的重大语言功能。然后我们可以看一下 Rust 2018 特色功能的小清单。

### 适用全部版本的语言新功能

这里有一个重大新语言功能的小型示例，它（或将）被包含在所有的语言版本中

### 更精确的 borrow checking（例如：非词法有效期）

Rust 的一大卖点就是借用检查器。借用检查器帮助你确保你的代码是内存安全的。但对于 Rust 开发新手来说它也一个痛点。

部分原因是需要学习新的概念。但还有一个大的原因……借用检查器有时候会拒绝那些看起来应该工作的代码，甚至对于那些概念有足够理解的人来说，他们也会遇到这种情况。

[![借用检查器告诉程序员因为变量已经被借走了，所以不能去借这个变量](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_03-nll-01-500x268.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_03-nll-01.png)

这是因为一次借用的有效期是到它的作用域结束为止 —— 例如，变量的有效期到函数结束为止。

这意味着尽管变量值的有效期已经结束并且不能访问，别的变量仍然被拒绝直到函数结束。

为了解决这个问题，我们使得借用检查器更加智能。现在它可以看到**实际**正在使用的变量。如果它的有效期结束，那么它不会阻塞其他使用数据的借用。

[![借用检查器说：啊，我现在看得到了](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_04-nll-02-500x303.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_04-nll-02.png)

不过当前这个特性只支持在 Rust 2018 中使用，而在不远的将来，所有 Rust 版本都将可以使用。之后我很会写更多关于这部分的内容。

#### 稳定的 Rust 过程宏

Rust 中的宏已经出现在 Rust 1.0 之前。但是在 Rust 2018 中，我们对它做了一些重大的改进，比如引入过程宏。

使用过程宏，有点像你可以添加自己的语法到 Rust。

Rust 2018 带来了两种过程宏：

#### 类函数宏

类函数宏允许你拥有看起来像常规函数调用的东西，但这些东西实际上是在编译期间运行的。他们接受一些代码并输出不同的代码，然后编译器将这些代码插入到二进制文件中。

他们已经存在了一段时间，但你能用它们做的事情有限。你的宏只能获取输入代码并在其上运行匹配语句。它无权查看输入代码中的所有令牌。

但是使用过程宏，你可以获得与解析器相同的输入 —— 令牌流。这意味着可以创建更强大的类函数宏。

#### 类属性宏

如果你熟悉 JavaScript 等语言中的装饰器，属性宏和它非常相似。它们允许你在 Rust 中注解应该预处理并转换为其他内容的代码。

`derive` 宏就是做这种事情的东西。当你把 derive 放到一个结构上时，编译器会把这个结构输入（在它被解析为一个令牌列表之后）并处理它。具体来说，它将从特征中添加函数的基本实现。

#### 更多易于理解的借用匹配

这种变化非常直观。

以前，如果你想借一些资源并尝试匹配它，你不得不添加一些奇怪的语法：

[![旧版本的代码使用 &Some(ref s) ，新版本使用 Some(s)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_06-match-500x162.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/12/04_06-match.png)

但现在，你不再需要写 `&Some(ref s)` 了。你可以只写 `Some(s)`，Rust 能清楚地找到（它们之间的）差异。。

### Rust 2018 特有的新功能

Rust 2018 的最小部分是它特有的功能。以下是 Rust 2018 版本解锁的少数几项更改。

#### 关键字

Rust 2018 中添加了一些关键字。

*   `try` 关键字
*   `async/await` 关键字

这些功能尚未完全实现，但对应的关键字正在向 Rust 1.31 添加中。这意味着在将来，当我们实现了这些关键字背后的功能时，也不需要引入新的关键字（引入关键字将会是一个有破坏性的变更。

#### 模块系统

开发人员学习 Rust 的一个痛点是模块系统。我们可以来看看为什么（是这样）。（我们）很难去推断 Rust 会使用哪个模块。

为了解决这个问题，我们对 Rust 中路径的工作方式进行了一些更改。

例如，如果你导入了一个包，则可以在顶级路径中使用它。但是，如果你将任何代码移动到子模块，那么它将不再起作用。

```
// 顶层模块
extern crate serde;

// 这样在顶层模块中可以工作
impl serde::Serialize for MyType { ... }

mod foo {
  // 但它在子模块中**不能**工作
  impl serde::Serialize for OtherType { ... }
}
```

另一个例子是前缀 `::`，它被用来指代当前包的根目录或一个外部包，这（两种情况）可能很难被（使用者）区分。

We’ve made this more explicit. Now, if you want to refer to the crate root, you use the prefix `crate::` instead. And this is just one of the [path clarity](https://rust-lang-nursery.github.io/edition-guide/rust-2018/module-system/path-clarity.html) improvements we’ve made.
我们已经明确了这一点。现在，如果要引用包的根路径，则使用前缀 `crate::`。这只是我们所做的 [path clarity](https://rust-lang-nursery.github.io/edition-guide/rust-2018/module-system/path-clarity.html) 改进之一。

If you have existing Rust code and you want it to use Rust 2018, you’ll very likely need to update it for these new module paths. But that doesn’t mean that you’ll need to manually update your code. Run `cargo fix` before you add the edition specifier to Cargo.toml and `rustfix` will make all the changes for you.
如果你有现存的 Rust 代码并且希望它使用 Rust 2018，那么你很可能需要为这些新的模块路径更新它。但那并不意味着你需要手动更新代码。在将版本说明符添加到 Cargo.toml 之前运行 `cargo fix` ，并且运行 `rustfix` 会为你进行所有更改。

## 了解更多

在 [Rust 2018 版本指南](https://rust-lang-nursery.github.io/edition-guide/rust-2018/index.html) 中了解这个版本的更多内容

### 关于 [Lin Clark](http://code-cartoons.com)

Lin 是 Mozilla Developer Relations 团队的工程师。她了解 JavaScript，WebAssembly，Rust 和 Servo，还可以绘制代码漫画（code cartoons）。

*  [code-cartoons.com](http://code-cartoons.com)
*  [@linclark](http://twitter.com/linclark)

[Lin Clark 的更多文章…](https://hacks.mozilla.org/author/lclarkmozilla-com/)

### 关于 [Rust 团队](https://www.rust-lang.org)

*  [https://www.rust-lang.org](https://www.rust-lang.org)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
