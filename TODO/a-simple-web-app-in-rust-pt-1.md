> * 原文地址：[A Simple Web App in Rust, Part 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md)
> * 译者：[LeopPro](https://github.com/LeopPro)
> * 校对者：[pthtc](https://github.com/pthtc) [hippyk](https://github.com/hippyk)

# 使用 Rust 开发一个简单的 Web 应用，第 1 部分

## 1 简介 & 背景

站在一个经验丰富但刚接触本生态系统的开发者的角度，使用 Rust 开发一个小型的 Web 应用是什么感觉呢？请继续阅读。

我第一次听说 Rust 的时候就对它产生了兴趣。一个支持宏的系统级语言，并且在高级抽象方面有成长空间。真棒！

到目前为止，我只写过关于 Rust 的博客，做了一些很基础的“Hello World”级程序。所以，我估计我的观点会欠一些火候。

不久之前，我看见了关于学习 Racket 的[这篇文章](http://artyom.me/learning-racket-1)，我觉得特别好。我们需要更多的人分享他们作为技术初学者时获得的经验，尤其是那些已经有相当丰富的技术经验的人[1](#fn.1)。我也非常喜欢它的“思维流”方法。我想，像这样写一个 Rust 教程，应该是一个非常好的尝试。

好了，前言说完了，我们开始吧！

## 2 应用

我想构建的应用要实现我的一个简单需求：用一种无脑的方式记录我每天服药时间。我想我点一下主屏幕上的链接，让它记录这次访问，并且这将会储存为一份我服药时间的记录。

Rust 似乎很适合这个应用。它速度快，运行一个简单的服务器消耗的资源特别少，所以它不会对我的 VPS 造成负担。我还想用 Rust 做一些更实际的事。

最小可行性版本非常小巧，但如果我想添加更多功能，它也有增长空间。听起来完美！

## 3 计划

我不得不承认一件事：我弄丢了这个项目的早期版本，这将产生以下弊端：当我重现它的时候，我并不会有几周前刚刚接触它的时候那种陌生感。然而，我想我仍然记得当时让我痛苦的地方，并且我会尽力重现这些难点。

我知道一个道理有必要在这里讲一下：对于一个独立的个人程序来说，利用现有 API 要比试着独立完成所有的工作容易得多。

为了达成目的，我制定了如下计划：

1. 构建一个简单的 Web 服务器，当我访问他的时候它能在屏幕上显示“Hello World”。
2. 构建一个小型程序，每当他运行的时候，它会按照一定格式记录当前时间。
3. 将上面两个整合到一个程序中。
4. 将此应用程序部署到我的 Digital Ocean VPS 上。

## 4 编写一个“Hello World” Web 应用

所以，我要建立一个新的 Git 仓库 & 装好 homebrew。我至少知道，我先要安装 Rust。

### 4.1 安装 Rust

```
$ brew update
...
$ brew install rust
==> Downloading https://homebrew.bintray.com/bottles/rust-1.0.0.yosemite.bottle.tar.gz
############################################################ 100.0%
==> Pouring rust-1.0.0.yosemite.bottle.tar.gz
==> Caveats
Bash completion has been installed to:
  /usr/local/etc/bash_completion.d

zsh completion has been installed to:
  /usr/local/share/zsh/site-functions
==> Summary
   /usr/local/Cellar/rust/1.0.0: 13947 files, 353M
```

Ok，在开始之前，我们先写一个常规的“Hello World”程序。

```
$ cat > hello_world.rs
fn main() {

        println!("hello world");
}
^D
$ rustc hello_world.rs
$ ./hello_world
hello world
$
```

到目前为止一切顺利。Rust 正常工作了，或者至少说，Rust 的编译器在正常工作。

有位朋友建议我尝试使用 [nickle.rs](http://nickel-org.github.io/)，那是 Rust 的 一个 Web 应用框架。我觉得不错。

截止到今天，它的第一个示例是：

```
#[macro_use] extern crate nickel;

use nickel::Nickel;

fn main() {
    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            "Hello world!"
        }
    });

    server.listen("127.0.0.1:6767");
}
```

我第一次做这些的时候，我有一点小分心，去学了一点 Cargo。这次我注意到了这个[入门指南](http://nickel-org.github.io/getting-started.html)，所以我打算跟着它走而不是什么都靠自己误打误撞。

这里有一个脚本，我应该通过 `curl` 下载然后使用 root 权限执行。但是“患有强迫症的”我打算先把脚本下载下来检查一下。

`curl -LO https://static.rust-lang.org/rustup.sh`


Ok，这事实上并不像我预想的那样，这个脚本完成了很多工作，大部分都是我现在不想自己去做的。而我很想知道，`cargo` 是不是用 `rustc` 来安装的？

```
$ which cargo
/usr/local/bin/cargo
$ cargo -v
Rust 包管理器

用法:
    cargo <命令> [<参数>...]
    cargo [选项]

选项:
    -h, --help       显示帮助信息
    -V, --version    显示版本信息并退出
    --list           安装命令列表
    -v, --verbose    使用详细的输出

常见的 cargo 命令:
    build       编译当前工程
    clean       删除目标目录
    doc         编译此工程及其依赖项文档
    new         创建一个新的 cargo 工程
    run         编译并执行 src/main.rs
    test        运行测试
    bench       运行基准测试
    update      更新 Cargo.lock 中的依赖项
    search      搜索注册过的 crates

执行 'cargo help <command>' 获取指定命令的更多帮助信息。
```

Ok，我猜这看起来不错吧？我现在就开始用它。

`$ rm rustup.sh`

### 4.2 设置工程

下一步是生成一个新的项目目录，但是我已经有了一个项目目录。不管怎样，我还是要试一试。

```
$ cargo new . --bin
目标 `/Users/joel/Projects/simplelog/.` 已经存在
```

嗯……它不工作。

```
$ cargo -h
在 <路径> 处创建一个新的 Cargo 包。

用法:
    cargo new [选项] <路径>
    cargo new -h | --help

选项:
    -h, --help          显示帮助信息
    --vcs <vcs>         为指定的版本管理系统（git 或 hg）
                        初始化一个新仓库
                        或者不使用版本管理系统（none）
    --bin               创建可执行文件工程而不是库工程
    --name <name>       设置结果包名
    -v, --verbose       使用详细的输出
```

> 上述代码第一行中 `cargo -h` 应为作者笔误，实为 `cargo new -h`。（译者注）

嗯，它似乎不会按照我的预想去工作，我需要重建这个仓库。

```
$ cd ../
$ rm -rf simplelog/
$ cargo new simple-log --bin
$ cd simple-log/
```

Ok，我们看看这里有什么？

```
$ tree
.
|____.git
| |____config
| |____description
| |____HEAD
| |____hooks
| | |____README.sample
| |____info
| | |____exclude
| |____objects
| | |____info
| | |____pack
| |____refs
| | |____heads
| | |____tags
|____.gitignore
|____Cargo.toml
|____src
| |____main.rs
```

看，它建立了一个 Git 仓库，`Cargo.toml` 文件和在 `src` 目录中的 `main.rs` 文件，看起来不错。

根据 Nickel 的入门指南，我向 `Cargo.toml` 文件中加入 `nickel.rs` 依赖，现在它看起来像是这样：

```
[package]
name = "simple-log"
version = "0.1.0"
authors = ["Joel McCracken <mccracken.joel@gmail.com>"]

[dependencies.nickel]

git = "https://github.com/nickel-org/nickel.rs.git"
```

我觉得这很容易理解。然而我不确定 `dependencies.nickel` 实际的**含义**是什么。`dependencies` 是一个带有 `nickel` 键的哈希值么？但可以肯定的是，我们已经在工程中引进 Nickel 了，真棒!



### 4.3 运行“Hello World”例子

管他呢，我把那个例子复制到 `main.rs` 中：

```
#[macro_use] extern crate nickel;

use nickel::Nickel;

fn main() {
    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            "Hello world!"
        }
    });

    server.listen("127.0.0.1:6767");
}
```

啥？`macro_use`、`extern` 都是什么东西？为什么要用 `use`？这些疑问我会在下面一一解答。

这里我有一些疑问，`macro_use` 似乎是一个宏指令[2](#fn.2)，但是我没有看到任何宏调用，所以我删除了它。然而现在我注意到了 `router!`，因此我更加倾向于这是一个宏指令。同时，我怀疑用`指令`一词来指代是否恰当，因此别太肯定。

我们试一下：

```
cargo run
    Updating git repository `https://github.com/nickel-org/nickel.rs.git`
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading unsafe-any v0.4.1
 Downloading httparse v0.1.2
 Downloading traitobject v0.0.3
 Downloading lazy_static v0.1.10
 Downloading pkg-config v0.3.4
 Downloading num_cpus v0.2.5
 Downloading modifier v0.1.0
 Downloading groupable v0.2.0
 Downloading unicase v0.1.0
 Downloading gcc v0.3.5
 Downloading time v0.1.25
 Downloading log v0.3.1
 Downloading url v0.2.34
 Downloading plugin v0.2.6
 Downloading hyper v0.4.0
 Downloading matches v0.1.2
 Downloading mustache v0.6.1
 Downloading bitflags v0.1.1
 Downloading typeable v0.1.1
 Downloading openssl v0.6.2
 Downloading rustc-serialize v0.3.14
 Downloading typemap v0.3.2
 Downloading regex v0.1.30
 Downloading cookie v0.1.20
 Downloading mime v0.0.11
 Downloading libc v0.1.8
 Downloading openssl-sys v0.6.2
   Compiling modifier v0.1.0
   Compiling traitobject v0.0.3
   Compiling regex v0.1.30
   Compiling libc v0.1.8
   Compiling lazy_static v0.1.10
   Compiling matches v0.1.2
   Compiling httparse v0.1.2
   Compiling rustc-serialize v0.3.14
   Compiling groupable v0.2.0
   Compiling pkg-config v0.3.4
   Compiling gcc v0.3.5
   Compiling bitflags v0.1.1
   Compiling unicase v0.1.0
   Compiling typeable v0.1.1
   Compiling unsafe-any v0.4.1
   Compiling log v0.3.1
   Compiling num_cpus v0.2.5
   Compiling typemap v0.3.2
   Compiling mime v0.0.11
   Compiling plugin v0.2.6
   Compiling openssl-sys v0.6.2
   Compiling time v0.1.25
   Compiling openssl v0.6.2
   Compiling url v0.2.34
   Compiling mustache v0.6.1
   Compiling cookie v0.1.20
   Compiling hyper v0.4.0
   Compiling nickel v0.5.0 (https://github.com/nickel-org/nickel.rs.git#69546f58)
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
Listening on http://127.0.0.1:6767
Ctrl-C to shutdown server
^C
```

哦吼！我的浏览器中 `localhost:6767` 的访问成功啦！

### 4.4 最终挑战

Ok，现在我想尝试一件事情，然后今晚就收工：我可以将“Hello World”移动到它自己的函数中么？毕竟我们现在是婴儿学步的阶段。

```
fn say_hello() {
    "Hello dear world!";
}

fn main() {
    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            say_hello();
        }
    });

    server.listen("127.0.0.1:6767");
}
```

错误……当我这次运行的时候，我看到了“未找到”。我们这次把分号去掉，以防万一：

```
fn say_hello() {
    "Hello dear world!"
}

fn main() {
    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            say_hello()
        }
    });

    server.listen("127.0.0.1:6767");
}
```

好吧……现在编译器报出了不同的错误信息：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:6:5: 6:24 错误：不匹配的类型：
    预期 `()`,
    找到 `&'static str`
   (预期 (),
    找到 &-ptr) [E0308]
src/main.rs:6     "Hello dear world!"
                  ^~~~~~~~~~~~~~~~~~~
错误：由于先前的错误而中止
不能编译 `simple-log`。

想查看更多信息，请加上 --verbose 重新运行命令。
```

根据报错信息，我**猜测**分号的有无是重要的。现在这产生了一个类型错误。哦，我有九成的把握肯定这里的 `()` 指的是“unit”，这是 Rust 中的空、未定义、或者未规定。我知道这不完全对，但是我想这是讲得通的。

我**假设** Rust 会做类型推断。编译器没这么做吗？还是只在函数边界附近没有做？嗯……

错误信息告诉我，编译器希望函数的返回值是“unit”，但是实际上返回值是一个静态字符串（这是啥？）。我已经看过函数返回值的语法了，我们看一看：

```
#[macro_use] extern crate nickel;

use nickel::Nickel;

fn say_hello() -> &'static str {
    "Hello dear world!"
}

fn main() {
    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            say_hello()
        }
    });

    server.listen("127.0.0.1:6767");
}
```

在我看来 `&'static str` 类型非常的怪异。它会成功编译么？它会正常工作么？

```
$ cargo run &
[1] 14997
Running `target/debug/simple-log`
Listening on http://127.0.0.1:6767
Ctrl-C to shutdown server
$ curl http://localhost:6767
Hello dear world!
$ fg
cargo run
^C
```

耶，它工作了！这一次 Rust 没有令人失望。我不知道是不是因为我对这些工具更熟悉了，还是我选择去多看文档，但是我乐在其中。**读**一门语言和**写**一门语言之间的差别非常的惊奇。虽然我理解这些代码示例，但是我仍然不能高效的编辑它们。

—

在下一章中，我们将完成当前日期写入文件的过程。你可以在[这里](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)阅读它。

—

系列文章：使用 Rust 开发一个简单的 Web 应用

* [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md)
* [Part 2a](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)
* [Part 2b](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md)
* [Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md)
* [Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md)
* [Conclusion](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md)

## 脚注:

[1](#fnr.1) 我并不是想说，初学者的经验是没有价值的 —— 远非如此！我认为相比于经验丰富者而言，初学者经常会带来一些独到的见解，他们可能会注意到生态系统中的某些东西是非标准的。

[2](#fnr.2) 我通常说编译期指令，但是这对于 Rust 这样一个编译语言来说没太大意义。所以除了宏指令以外，我不知道该如何表述它了。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
