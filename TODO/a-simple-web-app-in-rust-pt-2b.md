> * 原文地址：[A Simple Web App in Rust, Part 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md)
> * 译者：[LeopPro](https://github.com/LeopPro)

# 使用 Rust 开发一个简单的 Web 应用，第 2b 部分

## 目录

## 1 系列文章

在这个系列文章中，我记录下了，我在尝试使用 Rust 开发一个简单的 Web 应用过程中获得的经验。

到目前为止，我们有：

1. [制定目标 & “Hello World”级 Web 服务器](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md)
2. [搞清楚如何写入文件](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)

上一篇文章很恶心。这次我们会探索 Rust 的时间、日期格式，重点是用一个合适的格式记录时间。

## 2 使用 Chrono

在 crates.io 中搜索“日期”将得到[一个名为 chrono 的包](https://crates.io/search?q=date)。它热度很高，更新频繁，所以这看起来是一个好的候选方案。 从 README 文件来看，它有着很棒的的日期、时间输出功能。

第一件事情是在 `Cargo.toml` 中添加 Chrono 依赖，但在此之前，我们先把旧的 `main.rs` 移出，腾出空间用于实验：

```
$ ls
Cargo.lock Cargo.toml log.txt    src        target
$ cd src/
$ ls
main.rs     web_main.rs
$ git mv main.rs main_file_writing.rs
$ touch main.rs
$ git add main.rs
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   main.rs
        copied:     main.rs -> main_file_writing.rs

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        ../log.txt

$ git commit -m 'move file writing out of the way for working with dates'
[master 4cd2b0e] move file writing out of the way for working with dates
 2 files changed, 16 deletions(-)
 rewrite src/main.rs (100%)
 copy src/{main.rs => main_file_writing.rs} (100%)
```

在 `Cargo.toml` 中添加 Chrono 依赖：

```
[package]
name = "simple-log"
version = "0.1.0"
authors = ["Joel McCracken <mccracken.joel@gmail.com>"]

[dependencies]

chrono = "0.2"

[dependencies.nickel]

git = "https://github.com/nickel-org/nickel.rs.git"
```

自述文件接着说：

```
And put this in your crate root:

    extern crate chrono;
```

我不知道这是什么意思，但我要尝试把它放到 `main.rs` 顶部，因为它看起来像是 Rust 代码：

```
extern crate chrono;

fn main() { }
```

编译：

```
$ cargo run
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading num v0.1.25
 Downloading rand v0.3.8
 Downloading chrono v0.2.14
   Compiling rand v0.3.8
   Compiling num v0.1.25
   Compiling chrono v0.2.14
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `/Users/joel/Projects/simple-log/target/debug/simple-log`
```

好了，它似乎下载了 Chrono，并且编译成功了、结束了。我想下一步就是尝试使用它。根据自述文件第一个例子，我想这样：

```
extern crate chrono;
use chrono::*;

fn main() {
    let local: DateTime<Local> = Local::now();
    println!('{}', local);
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
main.rs:6:14: 6:16 error: unterminated character constant: '{
main.rs:6     println!('{}', local);
                       ^~
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

……？我愣了几秒后，我意识到它是告诉我，我应该使用双引号，而不是单引号。这是有道理的，单引号被用于生命周期规范。

从单引号切换到双引号之后：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `/Users/joel/Projects/simple-log/target/debug/simple-log`
2015-06-05 16:54:47.483088 -04:00
```

……**哇偶**，这真简单。看起来 `println!` 可以调用某种接口以打印各种不同的东西。

这很讽刺。我很轻松就构建一个简单的“Hello World”级 Web 应用并且打印了一个格式良好的时间，但我在写入文件上花费了很多时间。我不知道这意味着什么。尽管 Rust 语言很难用（对我来说），但是我相信 Rust 社区已经做了许多努力使系统包工作良好。

## 3 将日期时间写入文件

我认为，下一步我们应该将这个字符串写入文件。为此，我想看看上一篇文章的结尾：

```
$ cat main_file_writing.rs
use std::io::prelude::*;
use std::fs::File;
use std::io;

fn log_something(filename: &'static str, string: &'static [u8; 12]) -> io::Result<()> {
    let mut f = try!(File::create(filename));
    try!(f.write_all(string));
    Ok(())
}

fn main() {
    match log_something("log.txt", b"ITS ALIVE!!!") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

我只是将上面那个例子和这个合并到一起：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn log_something(filename: &'static str, string: &'static [u8; 12]) -> io::Result<()> {
    let mut f = try!(File::create(filename));
    try!(f.write_all(string));
    Ok(())
}

fn main() {
    let local: DateTime<Local> = Local::now();
    println!('{}', local);
    match log_something("log.txt", b"ITS ALIVE!!!") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

编译：

```
$ ls
Cargo.lock      Cargo.toml      log.txt         src             target
$ pwd
/Users/joel/Projects/simple-log
$ ls
Cargo.lock      Cargo.toml      log.txt         src             target
$ rm log.txt
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
2015-06-05 17:08:57.814176 -04:00
File created!
$ cat log.txt
ITS ALIVE!!!$
```

它工作了！和语言作斗争真有意思，很顺利地把两个东西放在一起。

## 4 构建时间记录器

我们离写一个真正的、完整的、最终系统越来越近。我突然想起，我可以为这个代码写一些测试，但是不急，一会再说。

以下是这个函数应该做的事情：

1. 给定一个文件名，
2. 如果它不存在则创建它，然后打开这个文件。
3. 创建一个时间日期字符串，
4. 将这个字符串写入文件，然后关闭这个文件。

### 4.1 对 `u8` 的误解

我的第一次尝试：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn log_time(filename: &'static str) -> io::Result<()> {

    let local: DateTime<Local> = Local::now();
    let time_str = local.format("%Y").to_string();
    let mut f = try!(File::create(filename));
    try!(f.write_all(time_str));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:13:22: 13:30 error: mismatched types:
 expected `&[u8]`,
    found `collections::string::String`
(expected &-ptr,
    found struct `collections::string::String`) [E0308]
src/main.rs:13     try!(f.write_all(time_str));
                                    ^~~~~~~~
<std macros>:1:1: 6:48 note: in expansion of try!
src/main.rs:13:5: 13:33 note: expansion site
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

我知道 Rust 中有很多字符串类型[1](#fn.1)，看起来这里我需要另一种类型。我不知道怎么下手，所以我只能搜索一番。

我记得在 [Rust 文档的某一部分](http://doc.rust-lang.org/book/strings.html)中特别提到了字符串。查一查，它说，可以使用 `&` 符号实现从 `String` 到 `&str` 的转换。我感觉这不是我们需要的，因为它应该是 `[u8]` 与 `&str`[2](#fn.2) 之间的类型冲突，让我们试试:

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn log_time(filename: &'static str) -> io::Result<()> {

    let local: DateTime<Local> = Local::now();
    let time_str = local.format("%Y").to_string();
    let mut f = try!(File::create(filename));
    try!(f.write_all(&time_str));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:13:22: 13:31 error: mismatched types:
 expected `&[u8]`,
    found `&collections::string::String`
(expected slice,
    found struct `collections::string::String`) [E0308]
src/main.rs:13     try!(f.write_all(&time_str));
                                    ^~~~~~~~~
<std macros>:1:1: 6:48 note: in expansion of try!
src/main.rs:13:5: 13:34 note: expansion site
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

好吧，显然，添加 `&` 符号只能从 `String` 转换到 `&String`。这似乎与 Rust 文档中所说的直相矛盾，但也可能是我不知道发生了什么事情。

……而且我刚刚读了字符串的章节的末尾。据我所知，这里没有任何东西。

我离开了一段时间去忙别的事情（家长里短，你懂），当我走的时候，我恍然大悟。在此之前，我一直以为 `u8` 是 `UTF-8` 的缩写，但是现在我仔细想想，它肯定是“无符号 8 位整数”的意思。而且我记得我看见过 `as_bytes` 方法，所以，我们试一下：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn log_time(filename: &'static str) -> io::Result<()> {
    let local: DateTime<Local> = Local::now();
    let bytes = local.format("%Y").to_string().as_bytes();
    let mut f = try!(File::create(filename));
    try!(f.write_all(bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
main.rs:10:17: 10:47 error: borrowed value does not live long enough
main.rs:10     let bytes = local.format("%Y").to_string().as_bytes();
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main.rs:10:59: 14:2 note: reference must be valid for the block suffix following statement 1 at 10:
58...
main.rs:10     let bytes = local.format("%Y").to_string().as_bytes();
main.rs:11     let mut f = try!(File::create(filename));
main.rs:12     try!(f.write_all(bytes));
main.rs:13     Ok(())
main.rs:14 }
main.rs:10:5: 10:59 note: ...but borrowed value is only valid for the statement at 10:4
main.rs:10     let bytes = local.format("%Y").to_string().as_bytes();
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main.rs:10:5: 10:59 help: consider using a `let` binding to increase its lifetime
main.rs:10     let bytes = local.format("%Y").to_string().as_bytes();
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

好吧，我**希望**事情有所进展。这个错误是否意味着我修正了一些东西，而还有一些其他的错误掩盖了这个问题？我是不是遇到了一个全新的问题？

奇怪的是错误信息集中体现在同一行上。我并不是很明白，但我觉得它是想告诉我，我需要添加一个赋值语句在方法中。我们试一下：

```
fn log_time(filename: &'static str) -> io::Result<()> {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%Y").to_string();
    let bytes = formatted.as_bytes();
    let mut f = try!(File::create(filename));
    try!(f.write_all(bytes));
    Ok(())
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
File created!
$ cat log.txt
2015$
```

太棒了！我们想要的都在这了。在我继续之前，我想吐槽一下，我有一点失望。没有我的提示，Rust 也应该可以通过上下文推断正确的行为。

测试脚本：

```
$ ls
Cargo.lock      Cargo.toml      log.txt         src             target
$ rm log.txt
$ cargo run
     Running `target/debug/simple-log`
File created!
$ cat log.txt
2015$ cargo run
     Running `target/debug/simple-log`
File created!
$ cat log.txt
2015$
```

### 4.2 查缺补漏

一些问题：

1. 没有另起一行，这忍不了。
2. 格式需要一些处理。
3. 新的日期会覆盖旧的。

Let's verify #3 by fixing the format. If the time changes between runs, then we will know that's what is happening.

`DateTime` 中的 `format` 方法使用标准 strftime 格式公约。理想情况下，我希望时间看起来像是这样的：

```
Sat, Jun 6 2015 05:32:00 PM
Sun, Jun 7 2015 08:35:00 AM
```

……等等。这可读性应该是足够的，供我使用。查阅[文档](https://lifthrasiir.github.io/rust-chrono/chrono/format/strftime/index.html)后，我想出了这个：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn log_time(filename: &'static str) -> io::Result<()> {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    let bytes = formatted.as_bytes();
    let mut f = try!(File::create(filename));
    try!(f.write_all(bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

测试：

```
$ rm log.txt
$ cargo run
     Running `target/debug/simple-log`
File created!
$ cat log.txt
Sun, Jun 07 2015 06:37:21 PM
$ sleep 5; cargo run
     Running `target/debug/simple-log`
File created!
$ cat log.txt
Sun, Jun 07 2015 06:37:41 PM
```

显然，程序覆盖我想要的日志项。我记得 `File::create` 的文档中指出了这里发生的事。所以，为了正确处理文件我需要再次查阅文档。

我进行了一些搜索，基本上找到答案都是无关紧要的。随后，我找到了 [std::path::Path](https://doc.rust-lang.org/std/path/struct.Path.html) 的文档，其中有一个 `exists` 模式。

此时，我的程序中的类型转换变得越来越难以管理。我感到紧张，所以继续之前，我要提交一次。

我想把对时间实体字符串的处理逻辑从 `log_time` 函数中抽取出来，因为时间的创建与格式化显然与文件操作代码不同。所以，我做了如下尝试：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn log_time_entry() -> String {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    formatted
}

fn log_time(filename: &'static str) -> io::Result<()> {
    let bytes = log_time_entry().as_bytes();
    let mut f = try!(File::create(filename));
    try!(f.write_all(bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:16:17: 16:33 error: borrowed value does not live long enough
src/main.rs:16     let bytes = log_time_entry().as_bytes();
                               ^~~~~~~~~~~~~~~~
src/main.rs:16:45: 20:2 note: reference must be valid for the block suffix following statement 0 at
 16:44...
src/main.rs:16     let bytes = log_time_entry().as_bytes();
src/main.rs:17     let mut f = try!(File::create(filename));
src/main.rs:18     try!(f.write_all(bytes));
src/main.rs:19     Ok(())
src/main.rs:20 }
src/main.rs:16:5: 16:45 note: ...but borrowed value is only valid for the statement at 16:4
src/main.rs:16     let bytes = log_time_entry().as_bytes();
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
src/main.rs:16:5: 16:45 help: consider using a `let` binding to increase its lifetime
src/main.rs:16     let bytes = log_time_entry().as_bytes();
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

好吧，这看起来就像我以前遇到的问题。是不是假借或持有要求函数拥有明确的资源引用？这似乎有一点奇怪。我再次尝试修复它：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn formatted_time_entry() -> String {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    formatted
}

fn log_time(filename: &'static str) -> io::Result<()> {
    let entry = formatted_time_entry();
    let bytes = entry.as_bytes();

    let mut f = try!(File::create(filename));
    try!(f.write_all(bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
File created!
```

所以，看起来添加一个明确的引用解决了问题。不管怎样，这个规则还蛮简单。

下面，我要将文件操作代码抽取至它自己的函数：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::File;
use std::io;
use chrono::*;

fn formatted_time_entry() -> String {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    formatted
}

fn record_entry_in_log(filename: &str, bytes: &[u8]) -> io::Result<()> {
    let mut f = try!(File::create(filename));
    try!(f.write_all(bytes));
    Ok(())
}

fn log_time(filename: &'static str) -> io::Result<()> {
    let entry = formatted_time_entry();
    let bytes = entry.as_bytes();

    try!(record_entry_in_log(filename, &bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

它正常工作。我犯了一些一开始的错误，但它们很快被纠正了。这里已经是修改后的代码。

查阅文档中的 [std::fs::File](https://doc.rust-lang.org/std/fs/struct.File.html)，我注意到文档对 [std::fs::OpenOptions](https://doc.rust-lang.org/std/fs/struct.OpenOptions.html) 的介绍，这正是我一直在寻找的。这肯定比使用 `std::path` 更好。

我的第一次尝试：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::{File,OpenOptions};
use std::io;
use chrono::{DateTime,Local};

fn formatted_time_entry() -> String {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    formatted
}

fn record_entry_in_log(filename: &str, bytes: &[u8]) -> io::Result<()> {
    let mut file = try!(OpenOptions::new().
                        append(true).
                        create(true).
                        open(filename));
    try!(file.write_all(bytes));
    Ok(())
}

fn log_time(filename: &'static str) -> io::Result<()> {
    let entry = formatted_time_entry();
    let bytes = entry.as_bytes();

    try!(record_entry_in_log(filename, &bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:4:15: 4:19 warning: unused import, #[warn(unused_imports)] on by default
src/main.rs:4 use std::fs::{File,OpenOptions};
                            ^~~~
     Running `target/debug/simple-log`
Error: could not create file.
```

有趣。其实它成功创建文件了。哦，我注意错误提示是我硬编码到 `main` 的信息。我认为这样它将工作：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::{File,OpenOptions};
use std::io;
use chrono::{DateTime,Local};

fn formatted_time_entry() -> String {
    let local: DateTime<Local> = Local::now();
    let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
    formatted
}

fn record_entry_in_log(filename: &str, bytes: &[u8]) -> io::Result<()> {
    let mut file = try!(OpenOptions::new().
                        append(true).
                        create(true).
                        open(filename));
    try!(file.write_all(bytes));
    Ok(())
}

fn log_time(filename: &'static str) -> io::Result<()> {
    let entry = formatted_time_entry();
    let bytes = entry.as_bytes();

    try!(record_entry_in_log(filename, &bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(e) => println!("Error: {}", e)
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:4:15: 4:19 warning: unused import, #[warn(unused_imports)] on by default
src/main.rs:4 use std::fs::{File,OpenOptions};
                            ^~~~
     Running `target/debug/simple-log`
Error: Bad file descriptor (os error 9)
```

奇怪。搜索“非法的文件描述”错误信息似乎表明，被使用的文件描述已经被关闭了。如果我注释掉 `file.write_all` 调用，将会发生什么呢？

```
$ rm log.txt
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:3:5: 3:25 warning: unused import, #[warn(unused_imports)] on by default
src/main.rs:3 use std::io::prelude::*;
                  ^~~~~~~~~~~~~~~~~~~~
src/main.rs:4:15: 4:19 warning: unused import, #[warn(unused_imports)] on by default
src/main.rs:4 use std::fs::{File,OpenOptions};
                            ^~~~
src/main.rs:15:40: 15:45 warning: unused variable: `bytes`, #[warn(unused_variables)] on by default
src/main.rs:15 fn record_entry_in_log(filename: &str, bytes: &[u8]) -> io::Result<()> {
                                                      ^~~~~
src/main.rs:16:9: 16:17 warning: unused variable: `file`, #[warn(unused_variables)] on by default
src/main.rs:16     let mut file = try!(OpenOptions::new().
                       ^~~~~~~~
src/main.rs:16:9: 16:17 warning: variable does not need to be mutable, #[warn(unused_mut)] on by de
fault
src/main.rs:16     let mut file = try!(OpenOptions::new().
                       ^~~~~~~~
     Running `target/debug/simple-log`
File created!
$ ls
Cargo.lock      Cargo.toml      log.txt         src             target
```

不出所料，有一堆未使用的警告信息，但是无他，文件的确被创建了。

这似乎有点傻，但我尝试向函数调用链中添加 `.write(true)` 后，它工作了。语义上 `.append(true)` 就意味着 `.write(true)`，但我想规定上不是这样的。

搞定了这个，它工作了！最终版本：

```
extern crate chrono;

use std::io::prelude::*;
use std::fs::{File,OpenOptions};
use std::io;
use chrono::{DateTime,Local};

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

fn log_time(filename: &'static str) -> io::Result<()> {
    let entry = formatted_time_entry();
    let bytes = entry.as_bytes();

    try!(record_entry_in_log(filename, &bytes));
    Ok(())
}

fn main() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(e) => println!("Error: {}", e)
    }
}
```

=>

```
$ ls
Cargo.lock      Cargo.toml      src             target
$ cargo run
     Running `target/debug/simple-log`
File created!
$ cargo run
     Running `target/debug/simple-log`
File created!
$ cat log.txt
Sun, Jun 07 2015 10:40:01 PM
Sun, Jun 07 2015 10:40:05 PM
```

## 5 结论 & 后续步骤

Rust 对我来说越来越容易了。我现在有一些有效的、单功能的代码可以使用，我对下一部分程序的开发感到相当有信心。

当我首次规划这个系列的时候，我计划下一个任务是整合日志代码和 `nickel.rs` 代码，但是现在，我认为这是非常简单的。我猜测，下一个有挑战的部分将是处理选[项解析](http://doc.rust-lang.org/getopts/getopts/index.html)。

—

系列文章：使用 Rust 开发一个简单的 Web 应用

* [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md)
* [Part 2a](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)
* [Part 2b](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md)
* [Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md)
* [Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md)
* [Conclusion](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md)

## 脚注：

[1](#fnr.1) 有很多种类的字符串是非常合理的事情。字符串是一个复杂的实体，很难得到正确的表达。不幸的是，乍一看字符串非常简单，这种事情似乎没必要复杂。

[2](#fnr.2) 我也不知道我在说什么。这些就是现在所能企及的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
