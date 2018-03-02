> * 原文地址：[A Simple Web App in Rust, Part 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)
> * 译者：[LeopPro](https://github.com/LeopPro)

# 使用 Rust 开发一个简单的 Web 应用，第 2a 部分

## 1 来龙去脉

如果你还没看过这个系列的第一部分，请从[这里](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1)开始。

在第一部分，我们成功的创建了一个 Rust 工程并且编写了一个“Hello World” Web 应用。

起初，在这个部分中我想写一个可以将日期写入文件系统的程序。但是在这个过程中，我和类型检查斗争了好久，所以这个部分主要写这个。

## 2 开始

上一次还不算太糟。但当我之前做这部分的时候，我记得这是最难的部分。

让我们从移动已存在的 `main.rs` 开始，这样我们就可以使用一个新文件。

```
$ pwd
/Users/joel/Projects/simple-log
$ cd src/
$ ls
main.rs
$ mv main.rs web_main.rs
$ touch main.rs
```

## 3 回忆“Hello World”

我可以不借助任何参考独立写出“Hello World”么？

让我试试：

```
fn main() {
    println!("Hello, world");
}
```

然后：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
Hello, world
```

哦，我想我还记得它。我只是有一点不太肯定，我是否需要为 `println!` 导入些什么，现在看来，这是不必要的。

## 4 天真的方法

好了，继续。上网搜索“Rust 创建文件”，我找到了 `std::fs::File`：[https://doc.rust-lang.org/std/fs/struct.File.html](https://doc.rust-lang.org/std/fs/struct.File.html)。让我们来试试一个例子：

```
use std::fs::File;

fn main() {
    let mut f = try!(File::create("foo.txt"));
}
```

编译：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
<std macros>:5:8: 6:42 error: mismatched types:
 expected `()`,
    found `core::result::Result<_, _>`
(expected (),
    found enum `core::result::Result`) [E0308]
<std macros>:5 return $ crate:: result:: Result:: Err (
<std macros>:6 $ crate:: convert:: From:: from ( err ) ) } } )
<std macros>:1:1: 6:48 note: in expansion of try!
src/main.rs:5:17: 5:46 note: expansion site
error: aborting due to previous error
Could not compile `simple-log`.
```

当我编写第一个版本的时候，解决这个错误真是花费了我很多时间。我不再经常活跃于社区，所以这些问题的解决方案可能是比较粗糙的。弄清楚这个问题给我留下了深刻的印象，所以我马上就知道答案了。

上面代码的问题是 `try!` 宏的展开代码在出现错误的情况下返回 `Err` 类型。然而 `main` 返回单元类型（`()`）[1](#fn.1)，这会导致一个类型错误。

我认为有三点难以理解：

1. 在这一点上，我不是很确定要如何理解错误信息。'expected' 和 'found'都指什么？我知道答案之后，我明白 'expected' 指的是 `main` 的返回值，我可以清楚的明白 'expected' 和 'found'。
2. 于我而言，查阅[文档](https://doc.rust-lang.org/std/macro.try!.html)并没有让我立刻明白 `try!` 是如何影响调用它的函数返回值的。当然，我应该查阅 `return` 在宏中的定义。然而，当我找到一个在 [Rust 文档](http://doc.rust-lang.org/stable/book/) 中的评论时，我才明白在这个例子中为什么 `try!` 不能在 `main` 中调用。
3. 这个错误事实上可以在宏中体现。我当时没明白，但 Rust 编译器可以输出经过宏扩展后的源代码。这个功能让这类问题易于调试。

在第三点中，我们提到了扩展宏。查阅扩展宏是调试这类问题非常有效的方法，这值得我们深究。

## 5 调试扩展宏

首先，我通过搜索“Rust 扩展宏”查阅到这些代码：

```
use std::fs::File;

fn main() {
    let mut f = try!(File::create("foo.txt"));
}
```

……我们可以通过这种方式使编译器输出宏扩展：

```
$ rustc src/main.rs --pretty=expanded -Z unstable-options
#![feature(no_std)]
#![no_std]
#[prelude_import]
use std::prelude::v1::*;
#[macro_use]
extern crate std as std;
use std::fs::File;

fn main() {
    let mut f =
        match File::create("foo.txt") {
            ::std::result::Result::Ok(val) => val,
            ::std::result::Result::Err(err) => {
                return ::std::result::Result::Err(::std::convert::From::from(err))
            }
        };
}
```

这次就易于调试了。宏是非常有效的工具，但是同其他工具一样，我们要知道何时、怎样使用它们。

看看吧，上面输出中的 `return` 定义，问题就出在这里。它尝试返回一个 `Err` 结果，但是 `main` 函数期望得到一个单元类型。

## 6 和类型斗争

我要知道如何解决这个类型问题。我尝试模仿 `try!` 宏，但是这次只返回单元类型：

```
use std::fs::File;

fn main() {
    match File::create("foo.txt") {
        Ok(val) => val,
        Err(err) => ()
    }
}
```

运行：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:5:5: 8:6 error: match arms have incompatible types:
 expected `std::fs::File`,
    found `()`
(expected struct `std::fs::File`,
    found ()) [E0308]
src/main.rs:5     match File::create("foo.txt") {
src/main.rs:6         Ok(val) => val,
src/main.rs:7         Err(err) => ()
src/main.rs:8     }
src/main.rs:7:21: 7:23 note: match arm with an incompatible type
src/main.rs:7         Err(err) => ()
                                  ^~
error: aborting due to previous error
Could not compile `simple-log`.
```

我不知道该如何表述，“这里不应该做任何事”。我猜 `val` 一定是 `std::fs::File` 类型，所以编译器推断 `match`的**所有**分支都应该返回它。我可以令 `Ok` 分支也不返回任何东西么？

```
use std::fs::File;

fn main() {
    match File::create("foo.txt") {
        Ok(val) => (),
        Err(err) => ()
    }
}
```

运行：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:6:12: 6:15 warning: unused variable: `val`, #[warn(unused_variables)] on by default
src/main.rs:6         Ok(val) => (),
                         ^~~
src/main.rs:7:13: 7:16 warning: unused variable: `err`, #[warn(unused_variables)] on by default
src/main.rs:7         Err(err) => ()
                          ^~~
     Running `target/debug/simple-log`
$ ls
Cargo.lock      Cargo.toml      foo.txt         src             target
```

它创建了 `foo.txt`！当然，代码可以更优雅，但是它现在很不错。让我们试试其他的方法：

```
use std::fs::File;

fn main() {
    File::create("foo.txt")
}
```

=>

```
$ rm foo.txt
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:5:5: 5:28 error: mismatched types:
 expected `()`,
    found `core::result::Result<std::fs::File, std::io::error::Error>`
(expected (),
    found enum `core::result::Result`) [E0308]
src/main.rs:5     File::create("foo.txt")
                  ^~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

我之前看到过这个。它的意思是 `main` 函数返回了 `File::create` 的结果。我想，这里不应该返回任何东西，但是我没有往这个方向思考。如果我添加一个分号呢？

```
use std::fs::File;

fn main() {
    File::create("foo.txt");
}
```

=>

```
$ rm foo.txt
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:5:5: 5:29 warning: unused result which must be used, #[warn(unused_must_use)] on by default

src/main.rs:5     File::create("foo.txt");
                  ^~~~~~~~~~~~~~~~~~~~~~~~
     Running `target/debug/simple-log`
$ ls
Cargo.lock      Cargo.toml      foo.txt         src             target
```

好了，我们成功运行且创建了文件，但是现在有一个“未使用的结果”警告。让我们去做点什么来处理这个结果：

```
use std::fs::File;

fn main() {
    match File::create("foo.txt") {
        Ok(val) => println!("File created!"),
        Err(err) => println!("Error: could not create file.")
    }
}
```

=>

```
$ rm foo.txt
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:6:12: 6:15 warning: unused variable: `val`, #[warn(unused_variables)] on by default
src/main.rs:6         Ok(val) => println!("File created!"),
                         ^~~
src/main.rs:7:13: 7:16 warning: unused variable: `err`, #[warn(unused_variables)] on by default
src/main.rs:7         Err(err) => println!("Error: could not create file.")
                          ^~~
     Running `target/debug/simple-log`
File created!
```

现在出现了未使用的变量警告。我的直觉是，我们可以使用省略号或删除变量名来解决这个问题：

```
use std::fs::File;

fn main() {
    match File::create("foo.txt") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
File created!
```

看，使用省略号可行，那么如果我删除省略号会发生什么？

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:6:12: 6:13 error: nullary enum variants are written with no trailing `( )`
src/main.rs:6         Ok() => println!("File created!"),
                         ^
src/main.rs:7:13: 7:14 error: nullary enum variants are written with no trailing `( )`
src/main.rs:7         Err() => println!("Error: could not create file.")
                          ^
error: aborting due to 2 previous errors
Could not compile `simple-log`.
```

这和我预想的不一样。我猜测“nullary”的意思是空元组，它需要被删除。如果我把括号删掉：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:6:9: 6:11 error: this pattern has 0 fields, but the corresponding variant has 1 field [
E0023]
src/main.rs:6         Ok => println!("File created!"),
                      ^~
src/main.rs:7:9: 7:12 error: this pattern has 0 fields, but the corresponding variant has 1 field [
E0023]
src/main.rs:7         Err => println!("Error: could not create file.")
                      ^~~
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

这很好理解，基本上是我所预想的。我的思维正在形成！

## 7 写入文件

让我们尝试一些更难的东西。这个怎么样：

1. 尝试创建日志文件。如果日志文件不存在则创建它。
2. 尝试写一个字符串到日志文件。
3. 把一切理清。

第一个例子进度还没有过半，我们继续：

```
use std::fs::File;

fn log_something(filename, string) {
    let mut f = try!(File::create(filename));
    try!(f.write_all(string));
}

fn main() {
    match log_something("log.txt", "ITS ALIVE!!!") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:3:26: 3:27 error: expected one of `:` or `@`, found `,`
src/main.rs:3 fn log_something(filename, string) {
                                       ^
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
$
```

所以我想函数参数必须要声明类型：

```
use std::fs::File;

fn log_something(filename: &'static str, string: &'static str) {
    let mut f = try!(File::create(filename));
    try!(f.write_all(string));
}

fn main() {
    match log_something("log.txt", "ITS ALIVE!!!") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
<std macros>:5:8: 6:42 error: mismatched types:
 expected `()`,
    found `core::result::Result<_, _>`
(expected (),
    found enum `core::result::Result`) [E0308]
<std macros>:5 return $ crate:: result:: Result:: Err (
<std macros>:6 $ crate:: convert:: From:: from ( err ) ) } } )
<std macros>:1:1: 6:48 note: in expansion of try!
src/main.rs:4:17: 4:45 note: expansion site
src/main.rs:5:12: 5:29 error: type `std::fs::File` does not implement any method in scope named `wr
ite_all`
src/main.rs:5     try!(f.write_all(string));
                         ^~~~~~~~~~~~~~~~~
<std macros>:1:1: 6:48 note: in expansion of try!
src/main.rs:5:5: 5:31 note: expansion site
src/main.rs:5:12: 5:29 help: methods from traits can only be called if the trait is in scope; the f
ollowing trait is implemented but not in scope, perhaps add a `use` for it:
src/main.rs:5:12: 5:29 help: candidate #1: use `std::io::Write`
<std macros>:5:8: 6:42 error: mismatched types:
 expected `()`,
    found `core::result::Result<_, _>`
(expected (),
    found enum `core::result::Result`) [E0308]
<std macros>:5 return $ crate:: result:: Result:: Err (
<std macros>:6 $ crate:: convert:: From:: from ( err ) ) } } )
<std macros>:1:1: 6:48 note: in expansion of try!
src/main.rs:5:5: 5:31 note: expansion site
src/main.rs:10:9: 10:15 error: mismatched types:
 expected `()`,
    found `core::result::Result<_, _>`
(expected (),
    found enum `core::result::Result`) [E0308]
src/main.rs:10         Ok(..) => println!("File created!"),
                       ^~~~~~
src/main.rs:11:9: 11:16 error: mismatched types:
 expected `()`,
    found `core::result::Result<_, _>`
(expected (),
    found enum `core::result::Result`) [E0308]
src/main.rs:11         Err(..) => println!("Error: could not create file.")
                       ^~~~~~~
error: aborting due to 5 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

出现了好多错误。我们看第一个错误，我猜 `log_something` 函数需要规定一个返回值。我尝试了一些方法，但是我卡住了。求助于搜索引擎！

几分钟过去了，我终于找到了答案。我在 GitHub 上找到了一些[相关信息](https://github.com/search?p=15&q=Result+language:rust&ref=simplesearch&type=Code&utf8=%E2%9C%93)，但是它并不有效。我大约尝试了 50 种不同方案，最终得以解决：

```
use std::io::prelude::*;
use std::fs::File;

fn log_something(filename: &'static str, string: &'static str) -> Result<File,std::io::error::Error> {
    let mut f = try!(File::create(filename));
    try!(f.write_all(string));
}

fn main() {
    match log_something("log.txt", "ITS ALIVE!!!") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

我不知道它能正常工作的原因。如果我理解的正确，返回值的类型 `Result` 的参数应该是 `File` 和 `std::io::error::Error`。这究竟是什么意思？对我来说，这两种类型很奇怪，一种是实际结果（文件），另一种是 `Error` 类型。为什么？我想，我修复了剩余错误之后，这还需要再次修复。

现在当我尝试运行它时，我得到如下错误信息：

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:8:22: 8:28 error: mismatched types:
 expected `&[u8]`,
    found `&'static str`
(expected slice,
    found str) [E0308]
src/main.rs:8     try!(f.write_all(string));
                                   ^~~~~~
<std macros>:1:1: 6:48 note: in expansion of try!
src/main.rs:8:5: 8:31 note: expansion site
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

我在例子中看到他们在字符串前加了一个 `b` Ok，我忽略它只是为了看看会发生什么。修复参数：

```
use std::io::prelude::*;
use std::fs::File;

fn log_something(filename: &'static str, string: &'static [u8; 12]) -> Result<File,std::io::error::Error> {
    let mut f = try!(File::create(filename));
    try!(f.write_all(string));
}

fn main() {
    match log_something("log.txt", "ITS ALIVE!!!") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:4:85: 4:106 error: struct `Error` is private
src/main.rs:4 fn log_something(filename: &'static str, string: &'static [u8; 12]) -> Result<File, std::io::error::Error> {
                                                                                                  ^~~~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `simple-log`.
```

我知道这将出现问题。花一些时间查阅资料。

Rust 文档有[一章](https://doc.rust-lang.org/book/error-handling.html)介绍 `Result`。看起来我做了一些非常规的操作。我是说，这似乎是“最好”的方式来处理当前的错误，但是我很疑惑。我曾见过这个 `unwrap` 几次，这看起来可能是我想要的。如果我尝试 `unwrap`，事情可能会有所不同：

```
fn log_something(filename: &'static str, string: &'static [u8; 12]) {
    let mut f = File::create(filename).unwrap();
    f.write_all(string);
}

fn main() {
    log_something("log.txt", b"ITS ALIVE!!!")
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:6:5: 6:25 warning: unused result which must be used, #[warn(unused_must_use)] on by def
ault
src/main.rs:6     f.write_all(string);
                  ^~~~~~~~~~~~~~~~~~~~
     Running `target/debug/simple-log`
$ ls
Cargo.lock      Cargo.toml      foo.txt         log.txt         src             target
$ cat log.txt
ITS ALIVE!!!
```

看，虽然有一个警告，它还是工作了。但我想，这不是 Rust 的方式，Rust 提倡提前失败或抛出错误。

真正的问题是 `try!` 和 `try!` 宏返回古怪 `Result` 的分支：

```
return $crate::result::Result::Err($crate::convert::From::from(err))
```

这意味着无论我传入什么都必须在枚举上实现一个 `From::from` 特征。但是我真的不知道特征或枚举是如何工作的，而且我认为整个事情对于我来说都是矫枉过正。

我去查阅 `Result` 的文档，看起来我走错了方向：[https://doc.rust-lang.org/std/result/](https://doc.rust-lang.org/std/result/)。这里的 `io::Result` 例子似乎于我做的相似，所以让我看看我是否能解决问题：

```
use std::io::prelude::*;
use std::fs::File;
use std::io;

fn log_something(filename: &'static str, string: &'static [u8; 12]) -> io::Result<()> {
    let mut f = try!(File::create(filename));
    try!(f.write_all(string));
}

fn main() {
    match log_something("log.txt", b"ITS ALIVE!!!") {
        Ok(..) => println!("File created!"),
        Err(..) => println!("Error: could not create file.")
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:5:1: 8:2 error: not all control paths return a value [E0269]
src/main.rs:5 fn log_something(filename: &'static str, string: &'static [u8; 12]) -> io::Result<()>
 {
src/main.rs:6     let mut f = try!(File::create(filename));
src/main.rs:7     try!(f.write_all(string));
src/main.rs:8 }
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

经过一段时间的思考，我发现了问题：必须在 `log_something` 的最后添加 `OK(())` 语句。我通过参考 `Result` 文档得出这样的结论。

我已经习惯了在函数最后的无分号语句意思是 `return ()`；而错误消息“不是所有的分支都返回同一类型”不好理解 —— 对我来说，这是类型不匹配问题。当然，`()` 可能不是一个值，我仍然认为这是令人困惑的。

我们最终的结果（这篇文章）：

```
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

=>

```
$ rm log.txt
$ cargo run
     Running `target/debug/simple-log`
File created!
$ cat log.txt
ITS ALIVE!!!
```

好了，它工作了，美滋滋！我想在这里结束本章，因为本章内容非常富有挑战性。我确信这个代码是可以做出改进的，但这里暂告一段落，[下一章](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md)我们将研究 Rust 中的日期和时间.

## 8 更新

1. NMSpaz 在 [Reddit](https://www.reddit.com/r/rust/comments/38ahgr/a_simple_web_app_in_rust_part_2a/crvvhkf) 指出了我例子中的一个错误。

—

系列文章：使用 Rust 开发一个简单的 Web 应用

* [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md)
* [Part 2a](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)
* [Part 2b](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md)
* [Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md)
* [Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md)
* [Conclusion](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-conclusion.md)

## 脚注:

[1](#fnr.1) 哈哈哈哈。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
