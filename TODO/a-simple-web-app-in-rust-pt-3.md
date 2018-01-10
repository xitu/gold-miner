> * 原文地址：[A Simple Web App in Rust, Part 3 -- Integration](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-3.md)
> * 译者：
> * 校对者：

# A Simple Web App in Rust, Part 3 -- Integration

## 1 Previously

This is the third part in a series on writing a very simple web application in Rust.

So far, we have the the pieces for an MVP in separate rust files. Here, we want to put them together into a single app.

### 1.1 Review

We have the following two pieces to put together: the file writing/logging code, and the serving code. Lets review each of them.

First, the logging code:

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

Now, the serving code:

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

## 2 Combining the Code: Fisticuffing with the Type System

So, I want to combine these two programs. First, I'll put them both into the same file (and change the name of one of the `main` functions, of course) to see if they all compile together.

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

Compiling & Running:

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

Cool. I totally expected those dead-code warning messages, and visiting `localhost:6767` in my browser still renders a "hello, world" page.

Here's an attempt to integrate them:

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

The macro `println!` here is writing to standard out, but what I want is something that will be returning a string. Is there a `sprintln!`, or something equivalent?

Doing a quick search, it looks like the answer is `format!`:

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

So, I know there's a way to convert between a `String` and an `&str`… hmm. I recall that I can use an `&`.

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

This thing again. I think I'm going to need a block here:

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

That didn't work. I think the problem is that `fmt` only exists for that new block, but the return value is used outside of it. What if I promote `fmt` to the top of the function?

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

I don't know how to fix this. I'm going to just set this down, for now, and come back to it later.

—

I've tried a few new things, and nothing works. I think I need to learn more of how this ownership/lifetime stuff works.

I just read a bit of the Rust book, and I notice this note:

> We choose the `String` type for the name, rather than `&str`. Generally speaking, working with a type which owns its data is easier than working with one that uses references.

Because I'm in "do" mode and not "learn" mode, I want to try using `String` to see if that works.

Now:

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

It worked. Visiting the page in a browser shows "File created!", and it also wrote an entry to the log file.

I'm not really surprised that this works – I kinda figured the solution would be to return a `String` instead of an `&str`, but I wanted to take it as a challenge to figure out.

Now that I think about it, this makes sense. I'm trying to return a borrowed reference, but I also own it, so returning it wouldn't make any sense. How would I return an `&str` that I created in my own function? I haven't seen anything using a plain, not-borrowed "`str`" anywhere.

I this absence of not-borrowed ~&str~s has to do with it representing being a plain c string pointer. This must have some complications that I'm not aware of, and for it to play nicely with Rust it must interface with rust the normal Rust rules sharing ownership must apply.

If some other part of the program has knowledge of an array of bytes, and provides me with a reference to that array, what does that mean? Are `&str` types basically just so that C strings can be referenced without some additional metadata associated with them?

The Rust book says `&str` -> `String` has some cost. I wonder if this always true, or only for static program strings. Would a heap-allocated `&str` require copying for a `String`? Now that I think about it, I bet the answer is yes; if you want to convert a borrowed value into something that is owned, the only reasonable solution would be to copy it.

Anyway, I think I just want to move on. I think the answer is that what I was trying to do just didn't make sense, and Rust correctly stopped me. I do wish I understood why every `str` is borrowed, though.

I'm going to try to return the logged time string from `log_time` and have that displayed to the user. My first attempt:

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

Hmm. So I guess that makes sense… `bytes` "borrows" the contents of `entry`. And, since this value is still borrowed by the time `OK(entry)` is called, this causes the error.

This works:

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

This isn't the first time I've used the "stick a new block here" feature, but it does seem to work for this, and it seems like a reasonably elegant way to handle this. My first thought though was that I needed to call another function to somehow "convert" bytes back into a `String`, but then I realized that this didn't actually make sense, and I needed to "deallocate" the borrow, somehow.

I don't understand what "move out of `entry`" means in that error message though. I'm thinking that you can't transfer ownership of a value as long as there is a borrowed reference to it, too. But maybe that isn't actually true. Is sending it to `Ok()` changing it? I'm pretty confused by this, and the Rust book doesn't seem to address this specific issue, but I think this must be it – ownership can't be changed while a borrow exists. I think.

Its nice to see that as I've been browsing through the Rust book section on borrowing, using a block is the cited solution to this problem.

## 3 Fin

Integrating this was much harder than I expected. Borrowing/ownership got me a few times here, so I'm going to cut it at this point, since this has gotten pretty long.

Fortunately, I think I am slowly understanding how Rust works, and especially its borrowing functionality. This gives me hope for the future.

—

Series: A Simple Web App in Rust

* [Part 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
* [Part 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
* [Part 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
* [Part 3](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
* [Part 4](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
* [Conclusion](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
