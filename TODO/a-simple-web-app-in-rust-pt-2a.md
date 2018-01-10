> * 原文地址：[A Simple Web App in Rust, Part 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2a.md)
> * 译者：
> * 校对者：

# A Simple Web App in Rust, Part 2a

## 1 Context

If you haven't checked out part 1 of this series, I would start [there](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1).

In the first part, we successfully set up the Rust project and built a simple "hello world" web app.

Originally, in this part, I wanted to write a program that writes dates to the filesystem. However, I ended up fighting with the type checker so much that this post ended up mostly being about that.

## 2 Starting Out

The last time wasn't too bad. When I did some of this earlier, I remember this being the hardest part.

Let's start by moving the existing `main.rs` out of the way so that we can work with a fresh file.

```
$ pwd
/Users/joel/Projects/simple-log
$ cd src/
$ ls
main.rs
$ mv main.rs web_main.rs
$ touch main.rs
```

## 3 Remembering "hello world"

Can I write a hello world without needing to look?

Let me try:

```
fn main() {
    println!("Hello, world");
}
```

Then:

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `target/debug/simple-log`
Hello, world
```

So, I guess I remember it OK. I was a little unsure about needing to import something for `println!`, but it must be unnecessary.

## 4 A Naive Approach

Ok, moving on. Searching the Internet for "rust create a file" leads me to this page on `std::fs::File`: [https://doc.rust-lang.org/std/fs/struct.File.html](https://doc.rust-lang.org/std/fs/struct.File.html). Let's try a piece from one example:

```
use std::fs::File;

fn main() {
    let mut f = try!(File::create("foo.txt"));
}
```

Building:

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

When I wrote the first version of this, this error took a _really_ longtime to figure out. I don't get on IRC very often anymore, so figuring things out like this can be pretty rough. Figuring it out left a big impression on me, so I know the answer right away.

The problem with the above code is that `try!` expands to something that returns early with an `Err` type in case of an error. Since `main` returns Unit ("`()`")[1](#fn.1), this causes a type error.

I think three things make this complicated:

1. At this point, I'm not really sure how to read the error message. What does 'expected' and 'found' refer to? Since I know the answer, I can see that 'expected' refers to the return value of `main`, but I could easily see 'expected'/'found' going either way.
2. For me, reading [the documentation](https://doc.rust-lang.org/std/macro.try!.html) for `try!` does not immediately indicate to me how `try!` impacts the return value of the function it is called from. Of course, I should have noticed the `return` in the macro definition. At any rate, I didn't figure the problem out until I found a remark in [the Rust book](http://doc.rust-lang.org/stable/book/) about how `try!` can't be called from `main` because of this exact problem.
3. The error actually occurs inside a macro. It didn't hit me at the time, but the rust compiler can output the code after macros have been expanded. That makes this kind of thing much easier to debug.

In number 3, expanding macros is alluded to. Viewing expanded macro is such a useful way to debug these kinds of issues that its worth discussing in more depth.

## 5 Debugging by Expanding Macros

First off, I figured this out by searching for "rust expand macros". Given this code:

```
use std::fs::File;

fn main() {
    let mut f = try!(File::create("foo.txt"));
}
```

… we can run the compiler to show us the expanded macro output this way:

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

This is _way_ easier to debug. Macros are a very powerful tool, but like any tool you need to know when and how to use them.

So, see that `return` statement in the above output? That's the problem. Its trying to return an `Err` result from `main`, which again has the return type Unit.

## 6 Fighting with Types

I need to know how to resolve this type problem. I'm going to start by imitating the `try!` macro, but this time only returning Unit:

```
use std::fs::File;

fn main() {
    match File::create("foo.txt") {
        Ok(val) => val,
        Err(err) => ()
    }
}
```

Running:

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

Huh. So, I'm not really sure how to say "don't do anything, here". I guess the type 'val' must be 'std::fs::File', and so its assuming that _any_ match return value must be that. Can I make the `Ok` branch not return anything, either?

```
use std::fs::File;

fn main() {
    match File::create("foo.txt") {
        Ok(val) => (),
        Err(err) => ()
    }
}
```

Running:

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

It created `foo.txt`! Of course, the code could be cleaner, but thats fine for now. Let me try something else:

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

I've seen this before. This must mean `main` is returning the result of `File::create`. I was thinking it would return nothing, but I guess I didn't really think that through. What if I add a semicolon?

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
src/main.rs:5:5: 5:29 warning: unused result which must be used, #[warn(unused_must_use)] on by def
ault
src/main.rs:5     File::create("foo.txt");
                  ^~~~~~~~~~~~~~~~~~~~~~~~
     Running `target/debug/simple-log`
$ ls
Cargo.lock      Cargo.toml      foo.txt         src             target
```

So, we now get an "unused result" warning, although it still runs and creates the file. Let's go back and try doing something that handles the results:

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

Now there are unused variables. My hunch is that either ellipses or removing the variable name will fix this:

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

So, ellipses worked. What happens when I instead remove the ellipses?

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

It didn't like that. I'm guessing that "nullary" means "zero-arity", and it needs those removed. If I remove the parentheses totally:

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

This makes sense, and is basically what I expected. My mental model is starting to form!

## 7 Writing to a file

Let's try something a little harder. How about this:

1. Try to create the log file. If it exists, great; if not, boo.
2. Try to write a string to the log file.
3. Clean everything up.

This first example doesn't even attempt half of that, but we'll go with it:

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

So I guess function arguments need must have type annotations:

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

That's a lot of errors. Looking at the first error, I'm guessing that `log_something` needs to have a return value specified. I've tried a few things, but right now I'm stuck. To the search engines!

A few minutes have passed, and I finally have _an_ answer. I did [some searching on GitHub](https://github.com/search?p=15&q=Result+language:rust&ref=simplesearch&type=Code&utf8=%E2%9C%93), but it wasn't fruitful. I tried about 50 different things, but got this to work:

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

I'm not really sure _why_ it works. If I understand correctly, the return value is of `Result` type that's parameterized with the types `File` and `std::io::error::Error`. What does this mean, exactly? It seems strange to me that of the two types, one type is the actual result (a file), yet the second is an `Error` type. Why? I'm thinking that once I fix the remaining error(s), this will need fixing again.

So, now when I try to run it, I get:

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

Ok, so I saw in the example that they prefixed the string with a `b`, which I neglected to do just to see what would happen. Fixing the parameters:

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

Ugh – I knew this was going to be a problem. Time to do some searching and reading.

The Rust book has [a section](https://doc.rust-lang.org/book/error-handling.html) on `Result`. Hmm. It seems like what I'm doing may not be idiomatic? I'd say that it seems like the "best" way to handle what is going on, but I _am_ confused. I've seen this `unwrap` thing a few times, and it seems like it could be what I want. If I try unwrap, things might be different:

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

So, that worked, although there is a warning. I think this is not "the Rust way", since its failing early/throwing errors away.

The real problem with `try!` and returning a `Result` is that there's this weirdness dealing with this line in the `try!` macro:

```
return $crate::result::Result::Err($crate::convert::From::from(err))
```

This means that whatever I pass in has to have a `From::from` trait implemented on an enum, but I really have no idea how traits or enums work, and I think the whole thing is overkill anyway for what I'm trying to do.

I've gone to the documentation for `Result`, and it looks like I may be going in the wrong direction: [https://doc.rust-lang.org/std/result/](https://doc.rust-lang.org/std/result/). This `io::Result` example seems to be similar enough to what I'm doing, so let me see if I can fix that up:

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

After some time thinking, I see the problem: an `Ok(())` statement must be added as the final statement in `log_something`. I realized this because I saw that this is how things happen in the `Result` documentation.

I've been used to the idea that not having something after the final semicolon means `return ()`; however, the message "not all control paths return a value" doesn't make sense – to me, this is a type mismatch. Unless, of course, `()` is not a value, which it might not be, but I still think that's confusing.

Our final result (for this post):

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

Ok, it works. Great. I'm going to end here because this has been pretty challenging. I'm sure improvements could be made on this code, but this is a good stopping point and a good time to research dates and times in Rust, which will be the [the next post](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/).

## 8 Updates

1. NMSpaz pointed out [on Reddit](https://www.reddit.com/r/rust/comments/38ahgr/a_simple_web_app_in_rust_part_2a/crvvhkf) that one of my examples had an error in it.

—

Series: A Simple Web App in Rust

* [Part 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
* [Part 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
* [Part 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
* [Part 3](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
* [Part 4](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
* [Conclusion](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)

## Footnotes:

[1](#fnr.1) lol.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
