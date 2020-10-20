> * 原文地址：[Your first CLI tool with Rust](https://www.demainilpleut.fr/your-first-cli-tool-with-rust/)
> * 原文作者：[Jérémie Veillet](https://www.demainilpleut.fr/authors/jveillet)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/your-first-cli-tool-with-rust.md](https://github.com/xitu/gold-miner/blob/master/TODO1/your-first-cli-tool-with-rust.md)
> * 译者：[JackEggie](https://github.com/JackEggie)
> * 校对者：[TloveYing](https://github.com/TloveYing)

# 用 Rust 打造你的第一个命令行工具

在精彩的编程世界里，你可能听说过这种名为 Rust 的新语言。它是一种开源的系统级编程语言。它专注于性能、内存安全和并行性。你可以像 C/C++ 那样用它编写底层应用程序。

你可能已经在 [Web Assembly](https://webassembly.org/) 网站上见到过它了。Rust 能够编译 WASM 应用程序，你可以在 [Web Assembly FAQ](https://webassembly.org/docs/use-cases/) 上找到很多例子。它也被认为是 [servo](https://servo.org/) 的基石，servo 是一个在 Firefox 中实现的高性能浏览器引擎。

这可能会让你望而却步，但这不是我们要在这里讨论的内容。我们将介绍如何使用它构建命令行工具，而你可能会从中发现很多有意思的东西。

## 为什么是 Rust？

好吧，让我把事情说清楚。我本可以用任何其他语言或框架来完成命令行工具。我可以选 C、Go、Ruby 等等。甚至，我可以使用经典的 bash。

在 2018 年中，我想学习一些新东西，Rust 激发了我的好奇心，同时我也需要构建一些简单的小工具来自动化工作和个人项目中的一些流程。

## 安装

你可以使用 [Rustup](https://rustup.rs/) 来设置你的开发环境，它是安装和配置你机器上所有的 Rust 工具的主要入口。

如果你在 Linux 和 MacOS 上工作，使用如下命令即可完成安装：

```bash
$ curl <https://sh.rustup.rs> -sSf | sh
```

如果你使用的是 Windows 系统，同样地，你需要在 [Rustup 网站](https://rustup.rs/)上下载一个 `exe` 并运行。

如果你用的是 Windows 10，我建议你使用 [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) 来完成安装。以上就是安装所需的步骤，我们现在可以去创建我们的第一个 Rust 应用程序了！

## 你的第一个 Rust 应用程序

我们在这里要做的是，仿照 [cat](https://en.wikipedia.org/wiki/Cat_(Unix)) 来构建一个 UNIX 实用工具，或者至少是一个简化版本，我们称之为 `kt`。这个应用程序将接受一个文件路径作为输入，并在终端的标准输出中显示文件的内容。

要创建这个应用程序的基本框架，我们将使用一个名为 [Cargo](https://github.com/rust-lang/cargo/) 的工具。它是 Rust 的包管理器，可以将它看作是 Rust 工具的 NPM（对于 Javascript 开发者）或 Bundler（对于 Ruby 开发者）。

打开你的终端，进入你想要存储源代码的路径下，然后输入下面的代码。

```bash
$ cargo init kt
```

这将会创建一个名为 `kt` 的目录，该目录下已经有我们应用程序的基本结构了。

如果我们 `cd` 到该目录中，我们将看到这个目录结构。而且，方便的是，这个项目已经默认初始化了 git。真是太好了！

```bash
$ cd kt/
  |
  .git/
  |
  .gitignore
  |
  Cargo.toml
  |
  src/
```

`Cargo.toml` 文件包含了我们的应用程序的基本信息和依赖信息。同样地，可以把它看做应用程序的 `package.json` 或者 `Gemfile` 文件。

`src/` 目录包含了应用程序的源文件，我们可以看到其中只有一个 `main.rs` 文件。检查文件的内容，我们可以看到其中只有一个 `main` 函数。

```rust
fn main() {
    println!("Hello, world!");
}
```

试试构建这个项目。由于没有外部依赖，它应该会构建得非常快。

```bash
$ cargo build
Compiling kt v0.1.0 (/Users/jeremie/Development/kitty)
Finished dev [unoptimized + debuginfo] target(s) in 2.82s
```

在开发模式下，你可以通过调用 `cargo run` 来执行二进制文件（用 `cargo run --- my_arg` 来传递命令行参数）。

```bash
$ cargo run
Finished dev [unoptimized + debuginfo] target(s) in 0.07s
Running `target/debug/kt`
Hello, world!
```

恭喜你，你通过刚才的步骤已经创建并运行了你的第一个 Rust 应用程序了！🎉

## 解析第一个命令行参数

正如我之前在文章中所说的，我们正在尝试构建一个简化版的 `cat` 命令。我们的目标是模拟 `cat` 的行为，运行 `kt myfile.txt` 命令之后，在终端输出文件内容。

我们本来可以自己处理参数的解析过程，但幸运的是，一个 Rust 工具可以帮我们简化这个过程，它就是 [Clap](https://github.com/clap-rs/clap)。

这是一个高性能的命令行参数解析器，它让我们管理命令行参数变得很简单。

使用这个工具的第一步是打开 `Cargo.toml` 文件，并在其中添加指定的依赖项。如果你从未处理过 `.toml` 文件也没关系，它与 Windows 系统中的 `.INI` 文件极其相似。这种文件格式在 Rust 中是很常见的。

在这个文件中，你将看到有一些信息已经填充好了，比如作者、版本等等。我们只需要在 `[dependencies]` 下添加依赖项就行了。

```toml
[dependencies]
clap = "~2.32"
```

保存文件后，我们需要重新构建项目，以便能够使用依赖库。即使 `cargo` 下载了除 `clap` 以外的文件也不用担心，这是由于 `clap` 也有其所需的依赖关系。

```bash
$ cargo build
 Updating crates.io index
  Downloaded clap v2.32.0
  Downloaded atty v0.2.11
  Downloaded bitflags v1.0.4
  Downloaded ansi_term v0.11.0
  Downloaded vec_map v0.8.1
  Downloaded textwrap v0.10.0
  Downloaded libc v0.2.48
  Downloaded unicode-width v0.1.5
  Downloaded strsim v0.7.0
   Compiling libc v0.2.48
   Compiling unicode-width v0.1.5
   Compiling strsim v0.7.0
   Compiling bitflags v1.0.4
   Compiling ansi_term v0.11.0
   Compiling vec_map v0.8.1
   Compiling textwrap v0.10.0
   Compiling atty v0.2.11
   Compiling clap v2.32.0
   Compiling kt v0.1.0 (/home/jeremie/Development/kt)
    Finished dev [unoptimized + debuginfo] target(s) in 33.92s
```

以上就是需要配置的内容，接下来我们可以动手，写一些代码来读取我们的第一个命令行参数。

打开 `main.rs` 文件。我们必须显式地声明我们要使用 Clap 库。

```rust
extern crate clap;

use clap::{Arg, App};

fn main() {}
```

`extern crate` 关键字用于导入依赖库，你只需将其添加到主文件中，应用程序的任何源文件就都可以引用它了。`use` 部分则是指你将在这个文件中使用 `clap` 的哪个模块。

Rust 模块（module）的简要说明：

> Rust 有一个模块系统，能够以有组织的方式重用代码。模块是一个包含函数或类型定义的命名空间，你可以选择这些定义是否在其模块外部可见（public/private）。—— Rust 文档

这里我们声明的是我们想要使用 `Arg` 和 `App` 模块。我们希望我们的应用程序有一个 `FILE` 参数，它将包含一个文件路径。Clap 可以帮助我们快速实现该功能。这里使用了一种链式调用方法的方式，这是一种令人非常愉悦的方式。

```rust
fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();
}
```

再次编译并执行，除了变量 `matches` 上的编译警告（对于 Ruby 开发者来说，可以在变量前面加上 `_`，它会告诉编译器该变量是可选的），它应该不会输出太多其他信息。

如果你向应用程序传递 `-h` 或者 `-V` 参数，程序会自动生成一个帮助信息和版本信息。我不知道你如何看待这个事情，但我觉得它 🔥🔥🔥。

```bash
$ cargo run -- -h
    Finished dev [unoptimized + debuginfo] target(s) in 0.03s
     Running `target/debug/kt -h`
kt 0.1.0
Jérémie Veillet. jeremie@example.com
A drop-in cat replacement written in Rust

 USAGE:
    kt [FILE]

 FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

 ARGS:
    <FILE>    File to print.

$ cargo run --- -V
Finished dev [unoptimized + debuginfo] target(s) in 0.04s
Running target/debug/kt -V
kt 0.1.0
```

我们还可以尝试不带任何参数，启动程序，看看会发生什么。

```bash
$ cargo run --
Finished dev [unoptimized + debuginfo] target(s) in 0.03s
  Running `target/debug/kt`
```

什么都没有发生。这是每次构建命令行工具时应该发生的默认行为。我认为不向应用程序传递任何参数就永远不应该触发任何操作。即使有时候这并不正确，但是在大多数情况下，永远不要执行用户从未打算执行的操作。

现在我们已经有了参数，我们可以深入研究如何**捕获**这个命令行参数并在标准输出中显示一些内容。

要实现这一点，我们可以使用 `clap` 中的 `value_of` 方法。请参考[文档](https://docs.rs/clap/2.32.0/clap/struct.ArgMatches.html#method.value_of)来了解该方法是怎么运作的。

```rust
fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
      )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        println!("Value for file argument: {}", file);
    }
}
```

此时，你可以运行应用程序并传入一个随机字符串作为参数，在你的控制台中会回显该字符串。

```bash
$ cargo run -- test.txt
Finished dev [unoptimized + debuginfo] target(s) in 0.02s
  Running `target/debug/kt test.txt`
Value for file argument: test.txt
```

请注意，目前我们实际上没有对该文件是否存在进行验证。那么我们应该怎么实现呢？

有一个标准库可以让我们检查一个文件或目录是否存在，使用方式非常简单。它就是 `std::path` 库。它有一个 `exists` 方法，可以帮我们检查文件是否存在。

如前所述，使用 `use` 关键字来添加依赖库，然后编写如下代码。你可以看到，我们使用 `If-Else` 条件控制在输出中打印一些文本。`println!` 方法会写入标准输出 `stdout`，而 `eprintln!` 会写入标准错误输出 `stderr`。

```rust
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;

 fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        println!("Value for file argument: {}", file);
        if Path::new(&file).exists() {
            println!("File exist!!");
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1); // 程序错误终止时的标准退出码
        }
    }
}
```

我们快要完成了！现在我们需要读取文件的内容并将结果显示在 `stdout` 中。

同样，我们将使用一个名为 `File` 的标准库来读取文件。我们将使用 `open` 方法读取文件的内容，然后将其写入一个字符串对象，该对象将在 `stdout` 中显示。

```rust
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read};

fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();
    if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
           println!("File exist!!");
           let mut f = File::open(file).expect("[kt Error] File not found.");
           let mut data = String::new();
           f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
           println!("{}", data);
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

再次构建并运行此代码。恭喜你！我们现在有一个功能完整的工具了！🍾

```bash
$ cargo build
   Compiling kt v0.1.0 (/home/jeremie/Development/kt)
    Finished dev [unoptimized + debuginfo] target(s) in 0.70s
$ cargo run -- ./src/main.rs
    Finished dev [unoptimized + debuginfo] target(s) in 0.03s
     Running `target/debug/kt ./src/main.rs`
File exist!!
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read};

 fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
            println!("File exist!!");
            let mut f = File::open(file).expect("[kt Error] File not found.");
            let mut data = String::new();
            f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
            println!("{}", data);
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

## 改进一点点

我们的应用程序现可以接收一个参数并在 `stdout` 中显示结果。

我们可以稍微调整一下整个打印阶段的性能，方法是用 `writeln!` 来代替 `println!`。这在 [Rust 输出教程](https://rust-lang-nursery.github.io/cli-wg/tutorial/output.html#a-note-on-printing-performance)中有很好的解释。在此过程中，我们可以清理一些代码，删除不必要的打印，并对可能的错误场景进行微调。

```rust
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read, Write};

fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
            match File::open(file) {
                Ok(mut f) => {
                    let mut data = String::new();
                    f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
                    let stdout = std::io::stdout(); // 获取全局 stdout 对象
                    let mut handle = std::io::BufWriter::new(stdout); // 可选项：将 handle 包装在缓冲区中
                    match writeln!(handle, "{}", data) {
                        Ok(_res) => {},
                        Err(err) => {
                            eprintln!("[kt Error] Unable to display the file contents. {:?}", err);
                            process::exit(1);
                        },
                    }
                }
                Err(err) => {
                    eprintln!("[kt Error] Unable to read the file. {:?}", err);
                    process::exit(1);
                },
            }
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

```bash
$ cargo run -- ./src/main.rs
  Finished dev [unoptimized + debuginfo] target(s) in 0.02s
    Running `target/debug/kt ./src/main.rs`
extern crate clap;

use clap::{Arg, App};
use std::path::Path;
use std::process;
use std::fs::File;
use std::io::{Read, Write};

 fn main() {
    let matches = App::new("kt")
      .version("0.1.0")
      .author("Jérémie Veillet. jeremie@example.com")
      .about("A drop in cat replacement written in Rust")
      .arg(Arg::with_name("FILE")
            .help("File to print.")
            .empty_values(false)
        )
      .get_matches();

     if let Some(file) = matches.value_of("FILE") {
        if Path::new(&file).exists() {
            match File::open(file) {
                Ok(mut f) => {
                    let mut data = String::new();
                    f.read_to_string(&mut data).expect("[kt Error] Unable to read the  file.");
                    let stdout = std::io::stdout(); // 获取全局 stdout 对象
                    let mut handle = std::io::BufWriter::new(stdout); // 可选项：将 handle 包装在缓冲区中
                    match writeln!(handle, "{}", data) {
                        Ok(_res) => {},
                        Err(err) => {
                            eprintln!("[kt Error] Unable to display the file contents. {:?}", err);
                            process::exit(1);
                        },
                    }
                }
                Err(err) => {
                    eprintln!("[kt Error] Unable to read the file. {:?}", err);
                    process::exit(1);
                },
            }
        }
        else {
            eprintln!("[kt Error] No such file or directory.");
            process::exit(1);
        }
    }
}
```

我们完成了！我们通过约 45 行代码就完成了我们的简化版 `cat` 命令 🤡，并且它表现得非常好！

## 构建独立的应用程序

那么构建这个应用程序并将其安装到文件系统中要怎么做呢？向 cargo 寻求帮助吧！

`cargo build` 接受一个 `---release` 标志位，以便我们可以指定我们想要的可执行文件的最终版本。

```bash
$ cargo build --release
   Compiling libc v0.2.48
   Compiling unicode-width v0.1.5
   Compiling ansi_term v0.11.0
   Compiling bitflags v1.0.4
   Compiling vec_map v0.8.1
   Compiling strsim v0.7.0
   Compiling textwrap v0.10.0
   Compiling atty v0.2.11
   Compiling clap v2.32.0
   Compiling kt v0.1.0 (/home/jeremie/Development/kt)
    Finished release [optimized] target(s) in 28.17s
```

生成的可执行文件位于该子目录中：`./target/release/kt`。

你可以将这个文件复制到你的 `PATH` 环境变量中，或者使用一个 cargo 命令来自动安装。应用程序将安装在 `~/.cargo/bin/` 目录中（确保该目录在 `~/.bashrc` 或 `~/.zshrc` 的 `PATH` 环境变量中）。

```bash
$ cargo install --path .
  Installing kt v0.1.0 (/home/jeremie/Development/kt)
    Finished release [optimized] target(s) in 0.03s
  Installing /home/jeremie/.cargo/bin/kt
```

现在我们可以直接在终端中使用 `kt` 命令调用我们的应用程序了！\o/

```bash
$ kt -V
kt 0.1.0
```

## 总结

我们创建了一个仅有数行 Rust 代码的命令行小工具，它接受一个文件路径作为输入，并在 `stdout` 中显示该文件的内容。

你可以在这个 [GitHub 仓库](https://github.com/jveillet/kt-rs)中找到这篇文章中的所有源代码。

轮到你来改进这个工具了！

-   你可以添加一个命令行参数来控制是否在输出中添加行号（`-n` 选项）。
-   只显示文件的一部分，然后通过按键盘上的 `ENTER` 键来显示其余部分。
-   使用 `kt myfile.txt myfile2.txt myfile3.txt` 这样的语法一次性打开多个文件。

不要犹豫，告诉我你用它做了什么！😎

**特别感谢帮助修订这篇文章的 Anaïs** 👍

## 进一步探索

-   [cat](https://en.wikipedia.org/wiki/Cat_(Unix))：cat 实用程序的 Wikipedia 页面。
-   [kt-rs](https://github.com/jveillet/kt-rs)
-   [Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/)
-   [Clap](https://github.com/clap-rs/clap)：一个功能齐全、高性能的 Rust 命令行参数解析器。
-   [Reqwest](https://github.com/seanmonstar/reqwest)：一个简单而功能强大的 Rust HTTP 客户端。
-   [Serde](https://github.com/serde-rs/serde)：一个 Rust 的序列化框架。
-   [crates.io](https://crates.io/): Rust 社区的工具注册站点。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
