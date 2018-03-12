> * 原文地址：[A Simple Web App in Rust, Part 3 -- Integration](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md)
> * 译者：[LeopPro](https://github.com/LeopPro)
> * 校对者：[ryouaki](https://github.com/ryouaki)

# 使用 Rust 开发一个简单的 Web 应用，第 3 部分 —— 整合

## 1 前情回顾

这是使用 Rust 开发一个简单的 Web 应用系列的第 3 部分.

到目前为止，我们已经有了一些最简可行功能在几个 Rust 源文件中。现在，我们想把它们放在一个应用程序中。

### 1.1 Review

我们将以下两个模块整合在一起：文件写入 / 记录代码，Web 服务代码。让我们 Review 一下它们：

首先，文件记录代码：

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

现在，Web 服务代码：

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

## 2 整合代码：和类型系统作斗争

好了，我想整合这两个程序。首先我会将它们放到一个文件中（当然，要将它们其中之一的 `main` 函数名字改一下），看一看是否能成功编译。

```
#[macro_use] extern crate nickel;
extern crate chrono;

use std::io::prelude::*;
use std::fs::{File,OpenOptions};
use std::io;
use chrono::{DateTime,Local};

use nickel::Nickel;

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

fn main2() {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(e) => println!("Error: {}", e)
    }
}

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

编译运行：

```
$ cargo run
src/main.rs:5:15: 5:19 warning: unused import, #[warn(unused_imports)] on by default
src/main.rs:5 use std::fs::{File,OpenOptions};
                            ^~~~
src/main.rs:11:1: 15:2 warning: function is never used: `formatted_time_entry`, #[warn(dead_code)] o
n by default
src/main.rs:11 fn formatted_time_entry() -> String {
src/main.rs:12     let local: DateTime<Local> = Local::now();
src/main.rs:13     let formatted = local.format("%a, %b %d %Y %I:%M:%S %p\n").to_string();
src/main.rs:14     formatted
src/main.rs:15 }
src/main.rs:17:1: 25:2 warning: function is never used: `record_entry_in_log`, #[warn(dead_code)] on
 by default
src/main.rs:17 fn record_entry_in_log(filename: &str, bytes: &[u8]) -> io::Result<()> {
src/main.rs:18     let mut file = try!(OpenOptions::new().
src/main.rs:19                         append(true).
src/main.rs:20                         write(true).
src/main.rs:21                         create(true).
src/main.rs:22                         open(filename));
               ...
src/main.rs:27:1: 33:2 warning: function is never used: `log_time`, #[warn(dead_code)] on by default
src/main.rs:27 fn log_time(filename: &'static str) -> io::Result<()> {
src/main.rs:28     let entry = formatted_time_entry();
src/main.rs:29     let bytes = entry.as_bytes();
src/main.rs:30
src/main.rs:31     try!(record_entry_in_log(filename, &bytes));
src/main.rs:32     Ok(())
               ...
src/main.rs:35:1: 40:2 warning: function is never used: `main2`, #[warn(dead_code)] on by default
src/main.rs:35 fn main2() {
src/main.rs:36     match log_time("log.txt") {
src/main.rs:37         Ok(..) => println!("File created!"),
src/main.rs:38         Err(e) => println!("Error: {}", e)
src/main.rs:39     }
src/main.rs:40 }
     Running `target/debug/simple-log`
Listening on http://127.0.0.1:6767
Ctrl-C to shutdown server
```

酷！这些未使用警告正是我所预期的，在浏览器上访问 `localhost:6767` 仍然呈现“Hello World”页面。

我们尝试整合它们：

```
#[macro_use] extern crate nickel;
extern crate chrono;

use std::io::prelude::*;
use std::fs::{File,OpenOptions};
use std::io;
use chrono::{DateTime,Local};

use nickel::Nickel;

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

fn do_log_time() -> &'static str {
    match log_time("log.txt") {
        Ok(..) => println!("File created!"),
        Err(e) => println!("Error: {}", e)
    }
}

fn main() {
    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time()
        }
    });

    server.listen("127.0.0.1:6767");
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:37:19: 37:44 error: mismatched types:
 expected `&'static str`,
    found `()`
(expected &-ptr,
    found ()) [E0308]
src/main.rs:37         Ok(..) => println!("File created!"),
                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
src/main.rs:38:19: 38:43 error: mismatched types:
 expected `&'static str`,
    found `()`
(expected &-ptr,
    found ()) [E0308]
src/main.rs:38         Err(e) => println!("Error: {}", e)
                                 ^~~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

这里的 `println!` 宏功能是写入标准输出，但我是想要的是某些能返回字符串的东西。这有 `sprintln!` 吗，或者其他差不多的东西？

查了查资料，看起来答案是 `format!`：

```
#[macro_use] extern crate nickel;
extern crate chrono;

use std::io::prelude::*;
use std::fs::{File,OpenOptions};
use std::io;
use chrono::{DateTime,Local};

use nickel::Nickel;

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

fn do_log_time() -> &'static str {
    match log_time("log.txt") {
        Ok(..) => format!("File created!"),
        Err(e) => format!("Error: {}", e)
    }
}

fn main() {
    let mut server = Nickel::new();

    server.utilize(router! {
        get "**" => |_req, _res| {
            do_log_time()
        }
    });

    server.listen("127.0.0.1:6767");
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:37:19: 37:43 error: mismatched types:
 expected `&'static str`,
    found `collections::string::String`
(expected &-ptr,
    found struct `collections::string::String`) [E0308]
src/main.rs:37         Ok(..) => format!("File created!"),
                                 ^~~~~~~~~~~~~~~~~~~~~~~~
src/main.rs:38:19: 38:42 error: mismatched types:
 expected `&'static str`,
    found `collections::string::String`
(expected &-ptr,
    found struct `collections::string::String`) [E0308]
src/main.rs:38         Err(e) => format!("Error: {}", e)
                                 ^~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

因此，我知道从 `String` 转化到 `&str` 的方法，嗯……我想起可以用 `&`。

```
fn do_log_time() -> &'static str {
    match log_time("log.txt") {
        Ok(..) => &format!("File created!"),
        Err(e) => &format!("Error: {}", e)
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:37:20: 37:44 error: borrowed value does not live long enough
src/main.rs:37         Ok(..) => &format!("File created!"),
                                  ^~~~~~~~~~~~~~~~~~~~~~~~
note: reference must be valid for the static lifetime...
src/main.rs:37:19: 37:44 note: ...but borrowed value is only valid for the expression at 37:18
src/main.rs:37         Ok(..) => &format!("File created!"),
                                 ^~~~~~~~~~~~~~~~~~~~~~~~~
src/main.rs:38:20: 38:43 error: borrowed value does not live long enough
src/main.rs:38         Err(e) => &format!("Error: {}", e)
                                  ^~~~~~~~~~~~~~~~~~~~~~~
note: reference must be valid for the static lifetime...
src/main.rs:38:19: 38:43 note: ...but borrowed value is only valid for the expression at 38:18
src/main.rs:38         Err(e) => &format!("Error: {}", e)
                                 ^~~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

又出现了相同的错误。我想这里我需要一个块：

```
fn do_log_time() -> &'static str {
    match log_time("log.txt") {
        Ok(..) => {
            let fmt = format!("File created!");
            &fmt
        },
        Err(e) => {
            let fmt = format!("Error: {}", e);
            &fmt
        }
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:39:14: 39:17 error: `fmt` does not live long enough
src/main.rs:39             &fmt
                            ^~~
note: reference must be valid for the static lifetime...
src/main.rs:38:48: 40:10 note: ...but borrowed value is only valid for the block suffix following s
tatement 0 at 38:47
src/main.rs:38             let fmt = format!("File created!");
src/main.rs:39             &fmt
src/main.rs:40         },
src/main.rs:43:14: 43:17 error: `fmt` does not live long enough
src/main.rs:43             &fmt
                            ^~~
note: reference must be valid for the static lifetime...
src/main.rs:42:47: 44:10 note: ...but borrowed value is only valid for the block suffix following s
tatement 0 at 42:46
src/main.rs:42             let fmt = format!("Error: {}", e);
src/main.rs:43             &fmt
src/main.rs:44         }
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

这仍然无效。我想问题出在 `fmt` ，`fmt` 只存在于新块中，但是作为返回值，它需要在能在外面被使用。如果我在函数顶部声明 `fmt` 会发生什么呢？

```
fn do_log_time() -> &'static str {
    let mut fmt = "".to_string();
    match log_time("log.txt") {
        Ok(..) => {
            fmt = format!("File created!");
            &fmt
        },
        Err(e) => {
            fmt = format!("Error: {}", e);
            &fmt
        }
    }

}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:40:14: 40:17 error: `fmt` does not live long enough
src/main.rs:40             &fmt
                            ^~~
note: reference must be valid for the static lifetime...
src/main.rs:36:34: 48:2 note: ...but borrowed value is only valid for the block suffix following st
atement 0 at 36:33
src/main.rs:36     let mut fmt = "".to_string();
src/main.rs:37     match log_time("log.txt") {
src/main.rs:38         Ok(..) => {
src/main.rs:39             fmt = format!("File created!");
src/main.rs:40             &fmt
src/main.rs:41         },
               ...
src/main.rs:44:14: 44:17 error: `fmt` does not live long enough
src/main.rs:44             &fmt
                            ^~~
note: reference must be valid for the static lifetime...
src/main.rs:36:34: 48:2 note: ...but borrowed value is only valid for the block suffix following st
atement 0 at 36:33
src/main.rs:36     let mut fmt = "".to_string();
src/main.rs:37     match log_time("log.txt") {
src/main.rs:38         Ok(..) => {
src/main.rs:39             fmt = format!("File created!");
src/main.rs:40             &fmt
src/main.rs:41         },
               ...
error: aborting due to 2 previous errors
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

我不知道如何修正它。我现在打算放一放，一会再回来肝。

—

我尝试了一些新方法，但是无一有效。我想我需要深入学习所有权和生命周期的工作机制。

我刚要查阅 Rust 文档时，我注意到了这个贴士：

> 我们选择 `String` 而非 `&str` 为其命名，通常来说，与一个拥有数据的类型打交道要比引用类型容易些。

因为我现在是在实践而非理论学习，我想尝试一下使用 `String` 看看是否有效。

现在：

```
fn do_log_time() -> String {
    match log_time("log.txt") {
        Ok(..) => format!("File created!"),
        Err(e) => format!("Error: {}", e)
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
Listening on http://127.0.0.1:6767
Ctrl-C to shutdown server
```

有效！在浏览器访问页面显示“File created!”，还写了一个日志文件的条目。

我对它能工作并不感到惊讶 —— 我有一点理解使用 `String` 替代 `&str` 就能解决问题，但我想将此作为一个挑战去弄清它。

现在我想通了，这是说得通的。我尝试返回一个假借引用，但我同时拥有它，所以返回它没有任何意义。那么我如何在我自己的函数中返回 `&str` 呢？我没有见过任何使用非假借“`str`”的地方。

缺失了非假借 ~&str~ 类型，我只能认为它表现上是一个普通的 C 字符串指针。这一定会引发一些我尚不了解的问题，对它来说要想很好的应用在 Rust 就必须与 Rust 交互，则 Rust 就必须兼容共享所有权的规则。

如果程序的其他部分持有一个字节数组，提供我一个对该数组的引用，这意味着什么？`&str` 类型是不是基本上就像 C 字符串一样，可以被引用而没有相关的额外元数据？

Rust 文档提到从 `&str` 到 `String` 的转化有一些成本。我不知道这是否真的如此，还是仅适用于静态字符串。在堆中分配 `&str` 需要复制 `String`吗？现在我明白了，我敢打赌答案是肯定的；如果你想把假借的值转化成拥有的，唯一合理的办法就是复制它。

无论如何，我都需要继续深入。我觉得原因是，我想要做的事没有意义，所以 Rust 正确的阻止了我。我希望我明白了，为什么每一个 `str` 都是假借值。

我将尝试让 `log_time` 返回记录时间，这样可以显示给用户。我的首次尝试：

```
fn log_time(filename: &'static str) -> io::Result<String> {
    let entry = formatted_time_entry();
    let bytes = entry.as_bytes();

    try!(record_entry_in_log(filename, &bytes));
    Ok(entry)
}

fn do_log_time() -> String {
    match log_time("log.txt") {
        Ok(entry) => format!("Entry Logged: {}", entry),
        Err(e) => format!("Error: {}", e)
    }
}
```

=>

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:32:8: 32:13 error: cannot move out of `entry` because it is borrowed
src/main.rs:32     Ok(entry)
                      ^~~~~
src/main.rs:29:17: 29:22 note: borrow of `entry` occurs here
src/main.rs:29     let bytes = entry.as_bytes();
                               ^~~~~
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

嗯……我想这说得通。`bytes` “借了” `entry` 的内容。当 `OK(entry)` 被调用时，这个值仍然被借用，这会导致错误。

现在它工作了：

```
fn log_time(filename: &'static str) -> io::Result<String> {
    let entry = formatted_time_entry();
    {
        let bytes = entry.as_bytes();

        try!(record_entry_in_log(filename, &bytes));
    }
    Ok(entry)
}
```

=>

```
$ cargo run &
[1] 66858
$      Running `target/debug/simple-log`
Listening on http://127.0.0.1:6767
Ctrl-C to shutdown server

$ curl localhost:6767
Entry Logged: Tue, Jun 23 2015 12:34:19 AM
```

这已经不是我第一次使用“贴一个新块在这”这样的特性了，但是它就是因此而工作了，这似乎是一个相当优雅的方式来处理这个问题。我首先想到的是，我需要调用另一个函数以某种方式将字节“转换”回 `String`，但后来我意识到这实际上没有意义，我需要以某种方式“释放”借用。

我不明白错误信息中“迁出 `entry`”的意思。我觉得是只要有假借引用，你就不能转移值的所有权。但这也不一定是对的。把它传给 `Ok()` 就是改变所有权了吗？我对此很困惑，Rust 文档似乎并没有针对这一具体的问题给出解释，但我认为我的猜测就应该是对的 —— 所有权猜假借存在的时候不能被改变。我想是的。

我很欣慰我在 Rust 文档的假借部分中见到，使用块是这个类问题的一种解决方案。

## 3 结语

整合工作比我预期的难得多。假借（Borrowing） / 所有权（Ownership）花费了我一些时间，所以我打算在这停一停，因为已经写了很长了。

幸运的是，我认为我在慢慢理解 Rust 的工作机制，尤其是它的假借功能。这给了我对未来的希望。

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
