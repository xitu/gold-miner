> * 原文地址：[A Simple Web App in Rust, Part 4 -- CLI Option Parsing](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md)
> * 译者：[LeopPro](https://github.com/LeopPro)

# 使用 Rust 开发一个简单的 Web 应用，第 4 部分 —— CLI 选项解析

## 1 刚刚回到正轨

哈喽！这两天抱歉了哈。我和妻子刚买了房子，这两天都在忙这个。感谢你的耐心等待。

## 2 简介

在之前的文章中，我们构建了一个“能跑起来”的应用；这证明了我们的计划可行。为了使它真正用起来，我们还需要关心比如说命令行选项之类的一些事情。

所以，我要去做命令解析。但首先，我们先将现存的代码移出，以挪出空间我们可以做 CLI 解析实验。但在此之前，我们通常只需要移除旧文件，创建新 `main.rs`：

```
$ ls
Cargo.lock      Cargo.toml      log.txt         src             target
$ cd src/
$ ls
main.rs                 main_file_writing.rs    web_main.rs
```

`main_file_writing.rs` 和 `web_main.rs` 都是旧文件，所以我移除它们。然后我将 `main.rs` 重命名为 `main_logging_server.rs`，然后创建新的 `main.rs`。

```
$ git rm main_file_writing.rs web_main.rs
rm 'src/main_file_writing.rs'
rm 'src/web_main.rs'
$ git commit -m 'remove old files'
[master 771380b] remove old files
 2 files changed, 35 deletions(-)
 delete mode 100644 src/main_file_writing.rs
 delete mode 100644 src/web_main.rs
$ git mv main.rs main_logging_server.rs
$ git commit -m 'move main out of the way for cli parsing experiment'
[master 4d24206] move main out of the way for cli parsing experiment
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename src/{main.rs => main_logging_server.rs} (100%)
$ touch main.rs
```

着眼于参数解析。在之前的帖子的评论部分，[Stephan Sokolow](http://blog.ssokolow.com/) 问我是否考虑过使用这个用于命令行解析的软件包 [clap](https://github.com/kbknapp/clap-rs)。Clap 看起来很有趣，所以我打算试试。

## 3 需求

以下服务需要能被参数配置：

1. 日志文件的位置。
2. 用来进行身份验证的私钥。
3. （可能）设置时间记录使用的时区。

我刚刚查看了一下我打算用的 Digital Ocean 虚拟机，它是东部标准时间，也正是我的时区，所以我或许会暂时跳过第三条。

## 4 实现

据我所知，设置 clap 依赖的方式是 `clap = "*";`。我更愿意指定一个具体的版本，但是现在“\*”可以工作。

我新的 Cargo.toml 文件：

```
[package]
name = "simple-log"
version = "0.1.0"
authors = ["Joel McCracken <mccracken.joel@gmail.com>"]

[dependencies]

chrono = "0.2"
clap   = "*"

[dependencies.nickel]

git = "https://github.com/nickel-org/nickel.rs.git"
```

安装依赖：

```
$ cargo run
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading ansi_term v0.6.3
 Downloading strsim v0.4.0
 Downloading clap v1.0.0-beta
   Compiling strsim v0.4.0
   Compiling ansi_term v0.6.3
   Compiling clap v1.0.0-beta
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
error: main function not found
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

这个错误只是因为我的 `main.rs` 还是空的；重要的是“编译 clap”已经成功。

根据 README 文件，我会先尝试一个非常简单的版本：

```
extern crate clap;
use clap::App;

fn main() {
  let _ = App::new("fake").version("v1.0-beta").get_matches();
}
```

运行：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
$ cargo run
     Running `target/debug/simple-log`
$ cargo build --release
   Compiling lazy_static v0.1.10
   Compiling matches v0.1.2
   Compiling bitflags v0.1.1
   Compiling httparse v0.1.2
   Compiling strsim v0.4.0
   Compiling rustc-serialize v0.3.14
   Compiling modifier v0.1.0
   Compiling libc v0.1.8
   Compiling unicase v0.1.0
   Compiling groupable v0.2.0
   Compiling regex v0.1.30
   Compiling traitobject v0.0.3
   Compiling pkg-config v0.3.4
   Compiling ansi_term v0.6.3
   Compiling gcc v0.3.5
   Compiling typeable v0.1.1
   Compiling unsafe-any v0.4.1
   Compiling num_cpus v0.2.5
   Compiling rand v0.3.8
   Compiling log v0.3.1
   Compiling typemap v0.3.2
   Compiling clap v1.0.0-beta
   Compiling plugin v0.2.6
   Compiling mime v0.0.11
   Compiling time v0.1.25
   Compiling openssl-sys v0.6.2
   Compiling openssl v0.6.2
   Compiling url v0.2.34
   Compiling mustache v0.6.1
   Compiling num v0.1.25
   Compiling cookie v0.1.20
   Compiling hyper v0.4.0
   Compiling chrono v0.2.14
   Compiling nickel v0.5.0 (https://github.com/nickel-org/nickel.rs.git#69546f58)
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)

$ target/debug/simple-log --help
simple-log v1.0-beta

USAGE:
        simple-log [FLAGS]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

$ target/release/simple-log --help
simple-log v1.0-beta

USAGE:
        simple-log [FLAGS]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information
```

我不知道为什么自述文件告诉我要使用 `--release` 编译 —— 似乎 `debug` 也一样能工作。而我并不清楚将会发生什么。我们删除掉 target 目录，不加`--release` 再编译一次：

```
$ rm -rf target
$ ls
Cargo.lock      Cargo.toml      log.txt         src
$ cargo build
   Compiling gcc v0.3.5
   Compiling strsim v0.4.0
   Compiling typeable v0.1.1
   Compiling unicase v0.1.0
   Compiling ansi_term v0.6.3
   Compiling modifier v0.1.0
   Compiling httparse v0.1.2
   Compiling regex v0.1.30
   Compiling matches v0.1.2
   Compiling pkg-config v0.3.4
   Compiling lazy_static v0.1.10
   Compiling traitobject v0.0.3
   Compiling rustc-serialize v0.3.14
   Compiling libc v0.1.8
   Compiling groupable v0.2.0
   Compiling bitflags v0.1.1
   Compiling unsafe-any v0.4.1
   Compiling clap v1.0.0-beta
   Compiling typemap v0.3.2
   Compiling rand v0.3.8
   Compiling num_cpus v0.2.5
   Compiling log v0.3.1
   Compiling time v0.1.25
   Compiling openssl-sys v0.6.2
   Compiling plugin v0.2.6
   Compiling mime v0.0.11
   Compiling openssl v0.6.2
   Compiling url v0.2.34
   Compiling num v0.1.25
   Compiling mustache v0.6.1
   Compiling cookie v0.1.20
   Compiling hyper v0.4.0
   Compiling chrono v0.2.14
   Compiling nickel v0.5.0 (https://github.com/nickel-org/nickel.rs.git#69546f58)
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
$ target/release/simple-log --help
bash: target/release/simple-log: No such file or directory
$ target/debug/simple-log --help
simple-log v1.0-beta

USAGE:
        simple-log [FLAGS]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information
$
```

所以，我猜你并不需要加 `--release`。耶，每天学点新东西。

我们再回过头来看 `main` 代码，我注意到变量以 `_` 命名；我们假定这是必须的，为了防止警告，表示废弃。使用 `_` 表示“故意未使用”真是漂亮的标准，我喜欢 Rust 对此支持。

好了，根据 clap 自述文件和上面的小实验，我首次尝试写一个参数解析器：

```
extern crate clap;
use clap::{App,Arg};

fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .takes_value(true))
        .get_matches();

    println!("Logfile path: {}", matches.value_of("LOG FILE").unwrap());

}
```

=>

```
$ cargo run -- --logfile whodat
     Running `target/debug/simple-log --logfile whodat`
Logfile path: whodat
$ cargo run -- -l whodat
     Running `target/debug/simple-log -l whodat`
Logfile path: whodat
```

很棒，正常工作！但这有一个问题：

```
$ cargo run
     Running `target/debug/simple-log`
thread '<main>' panicked at 'called `Option::unwrap()` on a `None` value', /private/tmp/rust2015051
6-38954-h579wb/rustc-1.0.0/src/libcore/option.rs:362
An unknown error occurred

To learn more, run the command again with --verbose.
```

看起来，在这调用 `unwrap()` 不是一个好主意，因为参数不一定被传入！

我不清楚大型的 Rust 社区对 `unwrap` 的建议是什么，但我总能看见社区里提到为什么它应该可以在这里使用。然而我觉得这说得通，在应用规模增长的过程中，某位置失效是“喜闻乐见的”。错误发生在运行期。这不是编译器可以检测的出的！

`unwrap` 的基本思想是类似空指针异常么？我想是的。但是，它确实让你停下来思考你在做什么，如果 `unwrap` 意味着代码异味，这还不错。这导致我有点想法想倒出来：

## 5 杂言

我坚信开发者的编码质量不是语言层面能解决的问题。各类静态语言社区总是花言巧语：“这些语言能使码农远离糟糕的编码。”好啊，你猜怎么样：这是不可能的。

首先，你没法使用任何明确的方式定义“优秀的代码”。确实，使代码优秀的绝大多数原因是高内聚。举一个非常简单的例子，面条代码在原型期往往是工作良好的，但在生产质量下，面条代码是可怕的。

最近的 OpenSSL 漏洞就是最好的例证。在新闻中，我没有得到多少信息，但我收集的资料表示，漏洞是由于**错误的业务逻辑**导致的。在某些极端情况下，攻击者可以冒充 CA（可信第三方）。你如何通过编译器预防**此类**问题呢？

确实，这将我带回了 Charles Babbage 中的一个旧内容：

> On two occasions I have been asked, "Pray, Mr. Babbage, if you put into the machine wrong figures, will the right answers come out?" In one case a member of the Upper, and in the other a member of the Lower, House put this question. I am not able rightly to apprehend the kind of confusion of ideas that could provoke such a question.

对此最好的办法就是让开发者**更容易**编程，让正确的事情符合常规，容易达成。

当你认为静态类型系统使编程**更易**的时候，我认为这件事又开始有意义了。说到底，开发者有责任保证程序行为正确，我们必须相信他们，赋予他们权利。

总而言之：程序员总是可以实现一个小的 Scheme 解释器，并在其中编写所有的应用程序逻辑。如果你试图通过类型检查器来防止这样的事情，那么祝你好运咯。

好了，我说完了，我将放下我的话匣子。谢谢你容忍我喋喋不休。

## 6 继续

回到主题上，我注意到有一个 `Arg` 的选项用来指定参数是否可选。我觉得我需要指定这个：

```
extern crate clap;
use clap::{App,Arg};

fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .required(true)
             .takes_value(true))
        .get_matches();

    println!("Logfile path: {}", matches.value_of("LOG FILE").unwrap());

}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
error: The following required arguments were not supplied:
        '--logfile <LOG FILE>'

USAGE:
        simple-log --logfile <LOG FILE>

For more information try --help
An unknown error occurred

To learn more, run the command again with --verbose.
$ cargo run -- -l whodat
     Running `target/debug/simple-log -l whodat`
Logfile path: whodat
```

奏效了！我们需要的下一个选项是通过命令行指定一个私钥。让我们添加它，但使其可选，因为，嗯，为什么不呢？我可能要搭建一个公开版本供人们预览。

我这样写：

```
extern crate clap;
use clap::{App,Arg};

fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .required(true)
             .takes_value(true))
        .arg(Arg::with_name("AUTH TOKEN")
             .short("t")
             .long("token")
             .takes_value(true))
        .get_matches();

    let logfile_path = matches.value_of("LOG FILE").unwrap();
    let auth_token   = matches.value_of("AUTH TOKEN");
}
```

=>

```
$ cargo run -- -l whodat
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:17:9: 17:21 warning: unused variable: `logfile_path`, #[warn(unused_variables)] on by d
efault
src/main.rs:17     let logfile_path = matches.value_of("LOG FILE").unwrap();
                       ^~~~~~~~~~~~
src/main.rs:18:9: 18:19 warning: unused variable: `auth_token`, #[warn(unused_variables)] on by default
src/main.rs:18     let auth_token   = matches.value_of("AUTH TOKEN");
                       ^~~~~~~~~~
     Running `target/debug/simple-log -l whodat`
```

这有很多（预料中的）警告，无妨，它成功编译运行。我只是想检查一下类型问题。现在让我们真正开始编写程序。我们以下面的代码开始：

```
use std::io::prelude::*;
use std::fs::OpenOptions;
use std::io;

#[macro_use] extern crate nickel;
use nickel::Nickel;

extern crate chrono;
use chrono::{DateTime,Local};

extern crate clap;
use clap::{App,Arg};

fn formatted_time_entry() -> String {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    formatted
}

fn record_entry_in_log(filename: &str, bytes: &[u8]) -> io::Result<()> {
    let mut file = try!(OpenOptions::new().
                        append(true).
                        write(true).
                        create(true).
                        open(filename));
    try!(file.write_all(bytes));
    Ok(())
}

fn log_time(filename: &'static str) -> io::Result<String> {
    let entry = formatted_time_entry();
    {
        let bytes = entry.as_bytes();

        try!(record_entry_in_log(filename, &bytes));
    }
    Ok(entry)
}

fn do_log_time(logfile_path: &'static str, auth_token: Option<&str>) -> String {
    match log_time(logfile_path) {
        Ok(entry) => format!("Entry Logged: {}", entry),
        Err(e) => format!("Error: {}", e)
    }
}

fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .required(true)
             .takes_value(true))
        .arg(Arg::with_name("AUTH TOKEN")
             .short("t")
             .long("token")
             .takes_value(true))
        .get_matches();

    let logfile_path = matches.value_of("LOG FILE").unwrap();
    let auth_token   = matches.value_of("AUTH TOKEN");

    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time(logfile_path, auth_token)
        }
    });

    server.listen("127.0.0.1:6767");
}
```

=>

```
$ cargo run -- -l whodat
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:60:24: 60:31 error: `matches` does not live long enough
src/main.rs:60     let logfile_path = matches.value_of("LOG FILE").unwrap();
                                      ^~~~~~~
note: reference must be valid for the static lifetime...
src/main.rs:58:24: 72:2 note: ...but borrowed value is only valid for the block suffix following st
atement 0 at 58:23
src/main.rs:58         .get_matches();
src/main.rs:59
src/main.rs:60     let logfile_path = matches.value_of("LOG FILE").unwrap();
src/main.rs:61     let auth_token   = matches.value_of("AUTH TOKEN");
src/main.rs:62
src/main.rs:63     let mut server = Nickel::new();
               ...
src/main.rs:61:24: 61:31 error: `matches` does not live long enough
src/main.rs:61     let auth_token   = matches.value_of("AUTH TOKEN");
                                      ^~~~~~~
note: reference must be valid for the static lifetime...
src/main.rs:58:24: 72:2 note: ...but borrowed value is only valid for the block suffix following st
atement 0 at 58:23
src/main.rs:58         .get_matches();
src/main.rs:59
src/main.rs:60     let logfile_path = matches.value_of("LOG FILE").unwrap();
src/main.rs:61     let auth_token   = matches.value_of("AUTH TOKEN");
src/main.rs:62
src/main.rs:63     let mut server = Nickel::new();
               ...
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

我不理解哪错了 —— 这和例子实质上是一样的。我尝试注释掉一堆代码，直到它等效于下面的代码：

```
fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .required(true)
             .takes_value(true))
        .arg(Arg::with_name("AUTH TOKEN")
             .short("t")
             .long("token")
             .takes_value(true))
        .get_matches();

    let logfile_path = matches.value_of("LOG FILE").unwrap();
    let auth_token   = matches.value_of("AUTH TOKEN");
}
```

…… 现在它可以编译了。报了很多警告，但无妨。

上面的错误信息都不是被注释掉的行产生的。现在我直到错误信息不一定指造成问题的代码，我知道要去别处看看。

我做的第一件事是去掉对两个参数的引用。代码变成了这样：

```
fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .required(true)
             .takes_value(true))
        .arg(Arg::with_name("AUTH TOKEN")
             .short("t")
             .long("token")
             .takes_value(true))
        .get_matches();

    let logfile_path = matches.value_of("LOG FILE").unwrap();
    let auth_token   = matches.value_of("AUTH TOKEN");

    let mut server = Nickel::new();
    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time("", Some(""))
        }
    });

    server.listen("127.0.0.1:6767");
}
```

代码成功的编译运行。现在我了解了问题所在，我**怀疑**是GET请求被映射到 `get **` 闭包中，而将这些变量传入该闭包中引起了生命周期冲突。

我和我的朋友 [Carol Nichols](https://twitter.com/Carols10cents) 讨论了这个问题，她给我的建议使得我离解决问题更进一步：将 `logfile_path` 和 `auth_token` 转换成 `String` 类型。

在这我能确信的是，`logfile_path` 和 `auth_token` 都是对于 `matches` 数据结构中某处的 `str` 类型的一个假借，它们在某一时间被传出作用域。在 `main` 函数结尾？由于在闭包结束时 `main` 函数仍然在运行，似乎 `matches` 仍然存在。

另外，可能闭包不适用于假借变量。我觉得这似乎不太可能。似乎是编译器无法肯定当闭包被调用时 `matches` 会仍然存在。即便如此，现在的情况仍然难以令人理解，因为闭包在 `server` 之中，将与 `matches` 同时结束作用域！

不管如何，我们这样修改代码：

```
// ...
let logfile_path = matches.value_of("LOG FILE").unwrap();
let auth_token   = matches.value_of("AUTH TOKEN");

let mut server = Nickel::new();
server.utilize(router! {
    get "**" => |_req, _res| {
        do_log_time(logfile_path, auth_token)
    }
});
// ...
```

改成这样：

```
// ...
let logfile_path = matches.value_of("LOG FILE").unwrap().to_string();
let auth_token = match matches.value_of("AUTH TOKEN") {
    Some(str) => Some(str.to_string()),
    None => None
};

let mut server = Nickel::new();
server.utilize(router! {
    get "**" => |_req, _res| {
        do_log_time(logfile_path, auth_token)
    }
});

server.listen("127.0.0.1:6767");
// ...
```

…… 解决了问题。我也令各个函数参数中的 `&str` 类型改为 `String` 类型。

当然，这揭示了一个**新**问题：

```
$ cargo build
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:69:25: 69:37 error: cannot move out of captured outer variable in an `Fn` closure
src/main.rs:69             do_log_time(logfile_path, auth_token)
                                       ^~~~~~~~~~~~
<nickel macros>:1:1: 1:27 note: in expansion of as_block!
<nickel macros>:10:12: 10:42 note: expansion site
note: in expansion of closure expansion
<nickel macros>:9:6: 10:54 note: expansion site
<nickel macros>:1:1: 10:62 note: in expansion of _middleware_inner!
<nickel macros>:4:1: 4:60 note: expansion site
<nickel macros>:1:1: 7:46 note: in expansion of middleware!
<nickel macros>:11:32: 11:78 note: expansion site
<nickel macros>:1:1: 21:78 note: in expansion of _router_inner!
<nickel macros>:4:1: 4:43 note: expansion site
<nickel macros>:1:1: 4:47 note: in expansion of router!
src/main.rs:67:20: 71:6 note: expansion site
src/main.rs:69:39: 69:49 error: cannot move out of captured outer variable in an `Fn` closure
src/main.rs:69             do_log_time(logfile_path, auth_token)
                                                     ^~~~~~~~~~
<nickel macros>:1:1: 1:27 note: in expansion of as_block!
<nickel macros>:10:12: 10:42 note: expansion site
note: in expansion of closure expansion
<nickel macros>:9:6: 10:54 note: expansion site
<nickel macros>:1:1: 10:62 note: in expansion of _middleware_inner!
<nickel macros>:4:1: 4:60 note: expansion site
<nickel macros>:1:1: 7:46 note: in expansion of middleware!
<nickel macros>:11:32: 11:78 note: expansion site
<nickel macros>:1:1: 21:78 note: in expansion of _router_inner!
<nickel macros>:4:1: 4:43 note: expansion site
<nickel macros>:1:1: 4:47 note: in expansion of router!
src/main.rs:67:20: 71:6 note: expansion site
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

乍一看，我完全不能理解这个错误：

```
src/main.rs:69:25: 69:37 error: cannot move out of captured outer variable in an `Fn` closure
src/main.rs:69             do_log_time(logfile_path, auth_token)
```

它说的“移出”一个被捕获的变量是什么意思？我不记得有哪个语言有这种移入、移出变量这样的概念，那个错误信息对我来说难以理解。

错误信息也告诉了我一些其他奇怪的事情；什么是闭包必须拥有其中的对象？

我又上网查了查这个错误信息，有一些结果，但看起来没有对我有用的。所以，我们接着玩耍。

## 7 更多的调试

首先，我先使用 `--verbose` 编译看看能不能显示一些有用的，但这并没有打印任何关于此错误的额外信息，只是一些关于一般命令的。

我依稀记得 Rust 文档中具体谈到了闭包，所以我决定去看看。根据文档，我猜测我需要一个“move”闭包。但当我尝试的时候：

```
server.utilize(router! {
    get "**" => move |_req, _res| {
        do_log_time(logfile_path, auth_token)
    }
});
```

…… 提示了一个新的错误信息：

```
$ cargo run -- -l whodat
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:66:21: 66:25 error: no rules expected the token `move`
src/main.rs:66         get "**" => move |_req, _res| {
                                   ^~~~
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

这是我困惑，所以我决定试试把它移动到外面去：

```
foo = move |_req, _res| {
    do_log_time(logfile_path, auth_token)
};

server.utilize(router! {
    get "**" => foo
});
```

=>

```
$ cargo run -- -l whodat
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:70:21: 70:24 error: no rules expected the token `foo`
src/main.rs:70         get "**" => foo
                                   ^~~
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

出现了相同的错误信息。

这次我注意到，关于模式匹配宏系统的错误信息用词看起来十分奇怪，我记得 `router!` 宏在这里被使用。一些宏很奇怪！我知道如何解决这个问题，因为我之前处理过。

```
$ rustc src/main.rs --pretty=expanded -Z unstable-options
src/main.rs:5:14: 5:34 error: can't find crate for `nickel`
src/main.rs:5 #[macro_use] extern crate nickel;
```

据此，我猜，或许我需要给 cargo 传递这个参数So？查阅 cargo 文档，没有发现任何能传递参数给 `rustc` 的方式。

在网上搜索一波，我发现了一些 GitHub issues 提出传递任意参数是不被支持的，除非创建一个自定义 cargo 命令，这似乎从我现在要解决的问题转移到了另一个可怕的问题，所以我不想接着这个思路走。

突然，一个疯狂的想法浮现在我的脑海：当使用 `cargo run --verbose`时，我去看输出中 `rustc` 命令是怎样执行的：

```
# ...
Caused by:
  Process didn't exit successfully: `rustc src/main.rs --crate-name simple_log --crate-type bin -g -
-out-dir /Users/joel/Projects/simple-log/target/debug --emit=dep-info,link -L dependency=/Users/joel
/Projects/simple-log/target/debug -L dependency=/Users/joel/Projects/simple-log/target/debug/deps --
extern nickel=/Users/joel/Projects/simple-log/target/debug/deps/libnickel-0a4cb77ee6c08a8b.rlib --ex
tern chrono=/Users/joel/Projects/simple-log/target/debug/deps/libchrono-a9b06d7e3a59ae0d.rlib --exte
rn clap=/Users/joel/Projects/simple-log/target/debug/deps/libclap-01156bdabdb6927f.rlib -L native=/U
sers/joel/Projects/simple-log/target/debug/build/openssl-sys-9c1a0f13b3d0a12d/out -L native=/Users/j
oel/Projects/simple-log/target/debug/build/time-30c208bd835b525d/out` (exit code: 101)
# ...
```

…… 我这个骚操作：我能否修改 rustc 的编译指令，输出宏扩展代码呢？我们试一下：

```
$ rustc src/main.rs --crate-name simple_log --crate-type bin -g --out-dir /Users/joel/Projects/simple-log/target/debug --emit=dep-info,link -L dependency=/Users/joel/Projects/simple-log/target/debug -L
dependency=/Users/joel/Projects/simple-log/target/debug/deps --extern nickel=/Users/joel/Projects/simple-log/target/debug/deps/libnickel-0a4cb77ee6c08a8b.rlib --extern chrono=/Users/joel/Projects/simple
-log/target/debug/deps/libchrono-a9b06d7e3a59ae0d.rlib --extern clap=/Users/joel/Projects/simple-log/target/debug/deps/libclap-01156bdabdb6927f.rlib -L native=/Users/joel/Projects/simple-log/target/debu
g/build/openssl-sys-9c1a0f13b3d0a12d/out -L native=/Users/joel/Projects/simple-log/target/debug/build/time-30c208bd835b525d/out --pretty=expanded -Z unstable-options > macro-expanded.rs
$ cat macro-expanded.rs
#![feature(no_std)]
#![no_std]
#[prelude_import]
use std::prelude::v1::*;
#[macro_use]
extern crate std as std;
use std::io::prelude::*;
...
```

它奏效了！这种操作登不得大雅之堂，但有时就是偏方才奏效，我至少弄明白了。这也让我弄清了 `cargo` 是怎样调用 `rustc` 的。

对我们有用的输出部分是这样的：

```
server.utilize({
    use nickel::HttpRouter;
    let mut router = ::nickel::Router::new();
    {
        router.get("**",{
            use nickel::{MiddlewareResult, Responder, 
                        Response, Request};
            #[inline(always)]
            fn restrict<'a, R: Responder>(r: R, res: Response<'a>) 
                                            -> MiddlewareResult<'a> {
                res.send(r)
            }
            #[inline(always)]
            fn restrict_closure<F>(f: F) -> F 
                    where F: for<'r, 'b, 'a>Fn(&'r mut Request<'b, 'a, 'b>, 
                        Response<'a>) -> MiddlewareResult<'a> + Send + Sync {
                f
            }
            restrict_closure(
                move |_req, _res| { 
                    restrict({ 
                        do_log_time(logfile_path, auth_token)
                    }, _res)
            })
        });
        router
    }
});
```









好吧，信息量很大。我们来抽丝剥茧。

有两个函数，`restrict` 和 `restrict_closure`，这令我惊讶。我**认为**它们的存在是为了提供更好的关于这些请求处理闭包的类型 / 错误信息。

然而，这还有许多有趣的事情：

```
restrict_closure(move |_req, _res| { ... })
```

…… 这告诉我，宏指定了闭包是 move 闭包。从理论上，是这样的。

## 8 重构

我们重构，并且重新审视一下这个问题。这一次，`main` 函数是这样的：

```
fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .required(true)
             .takes_value(true))
        .arg(Arg::with_name("AUTH TOKEN")
             .short("t")
             .long("token")
             .takes_value(true))
        .get_matches();

    let logfile_path = matches.value_of("LOG FILE").unwrap().to_string();
    let auth_token = match matches.value_of("AUTH TOKEN") {
        Some(str) => Some(str.to_string()),
        None => None
    };

    let mut server = Nickel::new();
    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time(logfile_path, auth_token)
        }
    });

    server.listen("127.0.0.1:6767");
}
```

编译时输出为：

```
$ cargo build
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:69:25: 69:37 error: cannot move out of captured outer variable in an `Fn` closure
src/main.rs:69             do_log_time(logfile_path, auth_token)
                                       ^~~~~~~~~~~~
<nickel macros>:1:1: 1:27 note: in expansion of as_block!
<nickel macros>:10:12: 10:42 note: expansion site
note: in expansion of closure expansion
<nickel macros>:9:6: 10:54 note: expansion site
<nickel macros>:1:1: 10:62 note: in expansion of _middleware_inner!
<nickel macros>:4:1: 4:60 note: expansion site
<nickel macros>:1:1: 7:46 note: in expansion of middleware!
<nickel macros>:11:32: 11:78 note: expansion site
<nickel macros>:1:1: 21:78 note: in expansion of _router_inner!
<nickel macros>:4:1: 4:43 note: expansion site
<nickel macros>:1:1: 4:47 note: in expansion of router!
src/main.rs:67:20: 71:6 note: expansion site
src/main.rs:69:39: 69:49 error: cannot move out of captured outer variable in an `Fn` closure
src/main.rs:69             do_log_time(logfile_path, auth_token)
                                                     ^~~~~~~~~~
<nickel macros>:1:1: 1:27 note: in expansion of as_block!
<nickel macros>:10:12: 10:42 note: expansion site
note: in expansion of closure expansion
<nickel macros>:9:6: 10:54 note: expansion site
<nickel macros>:1:1: 10:62 note: in expansion of _middleware_inner!
<nickel macros>:4:1: 4:60 note: expansion site
<nickel macros>:1:1: 7:46 note: in expansion of middleware!
<nickel macros>:11:32: 11:78 note: expansion site
<nickel macros>:1:1: 21:78 note: in expansion of _router_inner!
<nickel macros>:4:1: 4:43 note: expansion site
<nickel macros>:1:1: 4:47 note: in expansion of router!
src/main.rs:67:20: 71:6 note: expansion site
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

我在 IRC（一种即时通讯系统） 中问了这个问题，但是没有得到回应。按道理讲，我应该多花费一些耐心在 IRC 上提问，但没有就是没有。

我在 `nickel.rs` 项目上提交了一个 Issue，认为该问题是由宏导致的。这是我最终的想法 —— 我知道我可能是错的，但是我没有看到别的方法，我也不想放弃。

我的 Issue 在 [https://github.com/nickel-org/nickel.rs/issues/241](https://github.com/nickel-org/nickel.rs/issues/241)。Ryman 很快看到了我的错误，并且非常友好的帮助我解决了问题。显然，他是对的 —— 如果你能看到这篇文章，Ryman，我欠你一个人情。

问题发生在以下具体的闭包中。我们检查一下看看我们能发现什么：

```
get "**" => |_req, _res| {
    do_log_time(logfile_path, auth_token)
}
```

你注意到没，这里，对 `do_log_time` 的调用转移了 `logfile_path` 和 `auth_token` 的所有权到调用的函数。这是问题的所在。

我未经训练时，我认为这是“正常”的，是代码最自然的表现方式。我忽略了一个重要的警告：**在当前情况下，这个 lambda 表达式不能被调用一次以上**。当它被第一次调用时，`logfile_path` 和 `auth_token` 的所有权被转移到了 `do_log_time` 的调用者。这就是说：如果这个函数再次被调用，它**不能**再转移所有权给 `do_log_time`，因为它不再拥有这两个变量。

因此，我们得到错误信息：

```
src/main.rs:69:39: 69:49 error: cannot move out of captured outer variable in an `Fn` closure
```

我仍然认为这没有任何意义，但是现在至少我明白，它是将所有权从闭包中“移出”。

无论如何，解决这个问题最简单的方法是这样：

```
let mut server = Nickel::new();
server.utilize(router! {
    get "**" => |_req, _res| {
        do_log_time(logfile_path.clone(), auth_token.clone())
    }
});
```

现在，在每次调用中，`logfile_path` 和 `auth_token` 仍然被拥有，克隆体被创建了，其所有权被转移了。

然而，我想指出，我仍然认为这是一个次优的解决方案。因为转移所有权的过程不够透明，我现在倾向于尽可能使用引用。

如果使用显式的符号来代表假借的引用用另一种显式符号代表拥有，Rust 会更好，`*` 起这个作用吗？我不知道，但是这的确是一个有趣的问题。

## 9 重构

我将尝试一个快速重构，看看我是否可以使用引用。这将是有趣的，因为我可能会出现一些不可预见的问题 —— 我们来看看吧！

我一直在阅读 Martin Fowler 写的关于重构的书，这刷新了我的价值观，做事情要从一小步开始。第一步，我只想将所有权转化为假借；我们从 `logfile_path` 开始：

```
fn do_log_time(logfile_path: String, auth_token: Option<String>) -> String {
    match log_time(logfile_path) {
        Ok(entry) => format!("Entry Logged: {}", entry),
        Err(e) => format!("Error: {}", e)
    }
}

// ...

fn main() {
    // ...
    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time(logfile_path.clone(), auth_token.clone())
        }
    });
   // ...
}
```

改为：

```
fn do_log_time(logfile_path: &String, auth_token: Option<String>) -> String {
    match log_time(logfile_path.clone()) {
        Ok(entry) => format!("Entry Logged: {}", entry),
        Err(e) => format!("Error: {}", e)
    }
}

// ...

fn main() {
    // ...
    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time(&logfile_path, auth_token.clone())
        }
    });
   // ...
}
```

这次重构一定要实现：**用假借替代所有权和克隆**。如果我拥有一个对象，并且我要将其转化为假借，而且我还想在其他地方转移其所有权，我必须先在内部创建自己的副本。这使我可以将我的所有权变成假借，在必要的时候我仍然可以转移所有权。当然，这涉及克隆假借的对象，这会重复占用内存以及产生性能开销，但如此一来我可以安全地更改这行代码。然后，我可以持续使用假借取代所有权，而不会破坏任何东西。

尝试了多次之后我得到如下代码：

```
use std::io::prelude::*;
use std::fs::OpenOptions;
use std::io;

#[macro_use] extern crate nickel;
use nickel::Nickel;

extern crate chrono;
use chrono::{DateTime,Local};

extern crate clap;
use clap::{App,Arg};

fn formatted_time_entry() -> String {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    formatted
}

fn record_entry_in_log(filename: &String, bytes: &[u8]) -> io::Result<()> {
    let mut file = try!(OpenOptions::new().
                        append(true).
                        write(true).
                        create(true).
                        open(filename));
    try!(file.write_all(bytes));
    Ok(())
}

fn log_time(filename: &String) -> io::Result<String> {
    let entry = formatted_time_entry();
    {
        let bytes = entry.as_bytes();

        try!(record_entry_in_log(filename, &bytes));
    }
    Ok(entry)
}

fn do_log_time(logfile_path: &String, auth_token: &Option<String>) -> String {
    match log_time(logfile_path) {
        Ok(entry) => format!("Entry Logged: {}", entry),
        Err(e) => format!("Error: {}", e)
    }
}

fn main() {
    let matches = App::new("simple-log").version("v0.0.1")
        .arg(Arg::with_name("LOG FILE")
             .short("l")
             .long("logfile")
             .required(true)
             .takes_value(true))
        .arg(Arg::with_name("AUTH TOKEN")
             .short("t")
             .long("token")
             .takes_value(true))
        .get_matches();

    let logfile_path = matches.value_of("LOG FILE").unwrap().to_string();
    let auth_token = match matches.value_of("AUTH TOKEN") {
        Some(str) => Some(str.to_string()),
        None => None
    };

    let mut server = Nickel::new();
    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time(&logfile_path, &auth_token)
        }
    });

    server.listen("127.0.0.1:6767");

}
```

我马上需要处理 `auth_token`，但现在应该暂告一段落。

## 10 对第四部分的结论与回顾

应用程序现在具有解析选项的功能了。然而，这是非常困难的。在尝试解决我的问题时，我差点走投无路。如果我在 nickel.rs 提出的 Issue 没有这么有帮助的回应的话，我会非常受挫。

一些教训：

* 转让所有权是一件棘手的事情。我认为对我来说，一个新的经验之谈是，如果**不必**使用所有权，尽量通过不可变的假借来传递参数。
* Cargo **真应该**提供一个直接传参给 `rustc` 的方法。
* 一些 Rust 错误提示不那么太好。
* 即使错误信息很不怎么好，Rust 还是对的 —— 向我的闭包中转移所有权是错误的，因为网页每被请求一次，该函数就被调用一次。这里给我的一个教训是：如果我不明白错误信息，那么**以代码为切入点**来思考问题是个好办法，尤其是思考什么与 Rust 保证内存安全的思想相左。

这个经验也加强了我对强类型程序语言编译失败的承受能力。有时，你真的要去了解**内部**发生的事情以清楚正在发生什么。在本例中，很难去创建一个最小可重现错误来说明问题。

当错误消息没有给你你需要的信息时，你下一步最好的选择是开始在互联网上搜索与错误消息相关的信息。这并不能真正帮助你自己调查，理解和解决问题。

我认为这可以通过增加一些在多次不同状态下询问编译器结果来优化，以找到关于该问题的更多信息。就像在编译错误中打开一个交互式提示一样，这真是太好了，但即使是注释代码以从编译器请求详细信息也是非常有用的。

—

我在大约一个月的时间里写了这篇文章，主要是因为我忙于处理房子购置物品。有时候，我对此感到**非常**沮丧。我以为整合选项解析是最简单的任务！

但是，意识到 Rust 揭示了我程序的问题时，缓解了我的心情。即使错误信息不如我所希望的那样好，我还是喜欢它能合理的分割错误，这使我从中被拯救出来。

我希望随着Rust的成熟，错误信息会变得更好。如随我愿，我想我所有的担心都会消失。

—

系列文章：使用 Rust 开发一个简单的 Web 应用

* [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md)
* [Part 2a](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)
* [Part 2b](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md)
* [Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md)
* [Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md)
* [Conclusion](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
