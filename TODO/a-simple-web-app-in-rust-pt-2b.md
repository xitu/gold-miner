> * 原文地址：[A Simple Web App in Rust, Part 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-2b.md)
> * 译者：
> * 校对者：

# A Simple Web App in Rust, Part 2b

## Table of Contents

## 1 The Series

This is a post in a series of me writing down my experience as I try to build a simple web app in Rust.

So far, we have:

1. [Defined the goal & Written a "Hello World" web server](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
2. [Figured out how to write to a file](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)

The last part was especially harrowing. This piece will be to investigate date/time formatting in Rust, with a focus on writing visiting time in a nice format.

## 2 Using Chrono

So, searching for "date" on crates.io shows [one prominent result](https://crates.io/search?q=date), namely the crate "chrono". This looks very popular, and was updated very recently, so it looks like a good candidate. A look through the README seems to show that it has decent date/time pretty printing functionality.

The first thing would be to add the Chrono requirement line to `Cargo.toml`, but first let's move the old `main.rs` out of the way so that there is a new place to experiment:

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

Adding the dependency on Chrono to `Cargo.toml`:

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

The readme says this next:

```
And put this in your crate root:

    extern crate chrono;
```

I don't know what this means, but I'm just going to try to put it on top of `main.rs` because it looks like Rust code:

```
extern crate chrono;

fn main() { }
```

compiling:

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

So, it looks like it downloaded Chrono, compiled successfully, and exited. Rad. I think the next step would be to try to use it. Based upon the first example listed, I have this:

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

…? After I look at this for a second, I think its telling me that I need to use double quotes, not single quotes. which makes some sense, since single quotes are used in lifetime specifications.

After switching from single to double quotes:

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
     Running `/Users/joel/Projects/simple-log/target/debug/simple-log`
2015-06-05 16:54:47.483088 -04:00
```

… _whoa_. That was easy. It looks like `println!` has some kind of interface for whatever is being printed and can print many different things.

There is some irony here. So far, I was able to generate a simple hello world web application and print a well-formatted date and time with really very little effort, but writing to a file cost me dearly in time. I'm not sure what the lesson is, here. I think it is clear that the rust community has gone through great effort to make their packages nice to work with, even if the language is still hard to use (for me).

## 3 Writing the Date/Time to a File

I think the next sensible task would be to actually write this string to a file, and for this, I want to look at what I ended up with in the last entry:

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

I'll just do a real quick merge of the above example with this one:

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

compiling:

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

That all worked! It feels really good to go from struggling with a language, to being able to put things together with much less frustration.

## 4 Building a File Logger

We're getting closer to writing a real, bona fide piece of the final system. It hits me that I might like to write some tests for this code, but I'll add those in later.

Here's what this function should do:

1. Given a file name,
2. Create it first if doesn't exist, and open the file.
3. Create a time/date string,
4. Write that string to the file, and close the file.

### 4.1 Misunderstanding `u8`

My first attempt:

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

Ugh. So, I know that there are many types of strings in Rust[1](#fn.1), and it looks like I need a different one, here. Thing is, I don't know how to do this, so I'll have to do some searching.

I remember seeing [a section in the Rust](http://doc.rust-lang.org/book/strings.html) book specifically about strings. Looking into it, it says that a can be converted from `String` to `&str` with an ampersand (`&`). I don't think this is quite right, because it looks like it's expecting a `[u8]` and _not_ a `&str` [2](#fn.2) Lemmie try that:

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

Well. Apparently, adding the ampersand just converted a `String` to an `&String`. That seems to directly contradict what the Rust book is saying, but I also probably don't know what is going on.

…And I just reached the end of the chapter on strings. Harumph. As far as I can tell, there isn't anything in here.

I walked away from this for a while (because, you know, life), and while I was gone it hit me. All this time, I have been reading `u8` as a short form of `UTF-8`, but now that I think about it, it almost certainly actually means "unsigned 8-bit integer". And, I remember seeing an `as_bytes` method, so let me try that instead:

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

Well, I _hope_ this is progress. Does this error mean I fixed something, and there was something else wrong that was obscuring this problem? Did I introduce a whole new problem?

The strange thing about this error message is that it seems to be talking about error messages on the same line. I don't really understand most of it, but I'm thinking it is saying that I need to add a let in the middle of the sequence of method calls. Lets try:

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

Great! All the pieces are here. Before I move on, I want to reflect that I find this a little disappointing. It seems like Rust should be able to infer the correct behavior in the previous snippet without my guidance.

Testing the script:

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

### 4.2 Filling in Missing Pieces

A few problems:

1. No newline. This is really gross.
2. The format needs some work.
3. It appears that the old value is being erased by the new value.

Let's verify #3 by fixing the format. If the time changes between runs, then we will know that's what is happening.

The `format` method of `DateTime` uses the standard strftime formatting conventions. Ideally, I would like times to be something like:

```
Sat, Jun 6 2015 05:32:00 PM
Sun, Jun 7 2015 08:35:00 AM
```

…etc. This should be readable enough for me to use. After reading [the documentation](https://lifthrasiir.github.io/rust-chrono/chrono/format/strftime/index.html) for a while, I've come up with this:

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

Testing it:

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

So, clearly the program is overwriting the log entries, which tbqh is what I expect, as I remember the documentation for `File::create` specifying that this is what would happen. So, I need to look at the documentation for manipulating files again.

I did some searching around, and basically finding the answer to this isn't trivial. After a while I found the documentation for [std::path::Path](https://doc.rust-lang.org/std/path/struct.Path.html), which has an `exists` method.

At this point, the interactions between types in my application is becoming increasingly hard to manage. I feel nervous, so I will commit before continuing.

I want to pull the time entry string generation out of the `log_time` function because it seems like the entry formatting/creation is distinct from the file manipulation code. So, trying this:

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

So, this looks just like the problem I had earlier. Does borrowing/ownership require that a function have an explicit reference to resources? That seems a little strange. I will try to fix it again:

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

So, adding an explicit reference seems to be the solution. Whatever. It is an easy rule to learn and follow.

Next I want to extract the file manipulation code to its own function:

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

And this works. I made some initial errors, but they were quickly corrected and was all stuff that has been covered here before.

Looking into the documentation for [std::fs::File](https://doc.rust-lang.org/std/fs/struct.File.html), I notice a reference to [std::fs::OpenOptions](https://doc.rust-lang.org/std/fs/struct.OpenOptions.html), which is _exactly_ what I have been looking for. It would definitely be better than using `std::path`.

My first attempt:

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

Interesting. I see that it _is_ actually creating the file, after which I notice this is the message I've hard-coded into `main`. Ugh; I think this will work:

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

Weird. Searching for this "bad file descriptor" error message seems to indicate that this happens when a file descriptor is used has been closed. what happens if I comment out the `file.write_all` call?

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

Unsurprisingly, there are a bunch unused messages, but aside from that the file is indeed created.

It seems a little silly, but I tried adding `.write(true)` to the chain of functions, and it worked. It seems like `.append(true)` should imply `.write(true)`, but I guess it doesn't.

And with that, its working! The final version:

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

## 5 Conclusion & Next Steps

Rust is getting easier for me. I now have some reasonably factored code to work with, and I feel fairly confident about starting on the next part of the application.

When I was first planning this series, I expected the next task to be integrating the logging code with the `nickel.rs` code, but at this point I think it is going to be pretty simple. I suspect that the next difficult part will be handling [option parsing](http://doc.rust-lang.org/getopts/getopts/index.html).

—

Series: A Simple Web App in Rust

* [Part 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
* [Part 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
* [Part 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
* [Part 3](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
* [Part 4](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
* [Conclusion](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)

## Footnotes:

[1](#fnr.1) Having many types of strings is a completely reasonable thing. Strings are a complicated subject and hard to get right. Unfortunately, at first glance strings seem very simple, and this kind of things seems like needless complication

[2](#fnr.2) I basically have no idea what I'm talking about here. These are just things I've seen that I'm to make sense of.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
