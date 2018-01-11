> * 原文地址：[A Simple Web App in Rust, Part 4 -- CLI Option Parsing](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-4-cli-option-parsing.md)
> * 译者：
> * 校对者：

# A Simple Web App in Rust, Part 4 -- CLI Option Parsing

## 1 Back from Hiatus

Hello! Sorry for the delay in this one. My wife and I just bought a house, and we have been dealing with all that. Thanks for your patience.

## 2 Intro

Last time, we built a "working" application; the proof-of-concept is there. In order to make it into something that could actually be used, we need to worry about some other things like adding command line options.

So, I'm going to do some command parsing. But first, lets move this existing code out of the way to have a "blank slate" to do some CLI parsing experimentation. But, even before that, lets just generally clean things up a bit by removing some old files, and then creating a new `main.rs`:

```
$ ls
Cargo.lock      Cargo.toml      log.txt         src             target
$ cd src/
$ ls
main.rs                 main_file_writing.rs    web_main.rs
```

`main_file_writing.rs` and `web_main.rs` are both old, so I can remove them. After that I'll move `main.rs` to, say, `main_logging_server.rs` and create a new `main.rs`.

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

On to parameter parsing. In the comments section of an earlier post, [Stephan Sokolow](http://blog.ssokolow.com/) asked if I had considered using the package [clap](https://github.com/kbknapp/clap-rs) for command line parsing. Clap looks interesting, so, I'll try it.

## 3 Requirements

The service needs to be parameterized for the following:

1. The location of the log file.
2. A secret token to authenticate with.
3. (Possibly) setting the time zone to use with logging.

I just checked the Digital Ocean VM that I'm planning to use this on, and the machine is in EST, which is also my time zone, so I'll probably skip number 3, for now.

## 4 Implementation

As far as I can tell, the way to specify _this_ dependency is via `clap = "*";`. I'd always rather specify one, specific version, but for now "*" will work.

My new Cargo.toml:

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

Installing the dependency:

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

The error is just because my `main.rs` file is still empty; the important part is that the "Compiling clap" things look good.

Based upon the README, I'll try the very simple version listed:

```
extern crate clap;
use clap::App;

fn main() {
  let _ = App::new("fake").version("v1.0-beta").get_matches();
}
```

Running:

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

I don't know why the readme told me to compile with `--release` – it looks like the `debug` worked the same way. Unless I don't understand what's going on. Lemmie rm the target dir, then try again without the release flag:

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

So, I guess you don't need that `--release` flag. Ya learn something new every day.

Also, looking at the `main` code again, I notice that the variable is named `_`; I assume this must be in order to silence warnings/signify disuse. Using `_` to signify "intentionally unused" is pretty standard, I like that Rust supports this.

So, based upon the clap readme and a little experimentation, I've come up with this first attempt at writing an argument parser:

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

Ok, so that worked! But here's a problem:

```
$ cargo run
     Running `target/debug/simple-log`
thread '<main>' panicked at 'called `Option::unwrap()` on a `None` value', /private/tmp/rust2015051
6-38954-h579wb/rustc-1.0.0/src/libcore/option.rs:362
An unknown error occurred

To learn more, run the command again with --verbose.
```

So. Calling `unwrap()` up there was a bad idea, since this argument may not be passed in!

I'm not sure what the opinion of the greater Rust community is on `unwrap`, but everywhere I've noticed it there is also a comment explaining why it should be OK to use here. While I think that makes sense, as an application grows it is easy for assumptions in one place to become invalidated. And, notice that the error occurs at _run-time_. This isn't something that the compiler can determine!

Is `unwrap` the same basic idea as there being a null pointer exception? I think so. But, it does make you stop and think about what you're doing, and if it means that `unwrap` is a code sort-of-smell, then that's great. Which leads me to a bit of a rant:

## 5 A Rant

I firmly believe that you cannot make developers write good code. The problem I have with static language communities is that the rhetoric around these programming languages: that they will "prevent the programmer from doing bad things". Well, guess what: that's impossible.

Firstly, you cannot define "good code" in any sensible way. Indeed, much of what makes code good is highly context-dependent. As a very basic example, sloppy code is good when prototyping, but sloppy code is horrible when making something production-quality.

The latest OpenSSL vulnerability is a great example of this. I didn't read very much into the news about the vulnerability, but from what I gathered, the cause of the bug was _an error in business logic_. Under certain very-specific circumstances, an attacker could become a certificate authority. How do you write a compiler that prevents _this_ problem?

Indeed, this takes me back to an old quote from Charles Babbage:

> On two occasions I have been asked, "Pray, Mr. Babbage, if you put into the machine wrong figures, will the right answers come out?" In one case a member of the Upper, and in the other a member of the Lower, House put this question. I am not able rightly to apprehend the kind of confusion of ideas that could provoke such a question.

The best thing that you can do is make it _easier_ for developers to write good code. Doing the right thing should be the normal, easy path.

Once you start talking about static type systems as tools to make programming _easier_, I think things start to make sense again. In the end, the developer is still responsible for doing the right thing, and we must _trust_ them and _empower_ them to do these things.

Finally: the programmer can always implement a little Scheme interpreter and write all their application logic in that. Good luck trying to get your type checker to prevent that sort of thing.

Ok, I'm done. I'll get down off my soapbox. Thanks for indulging me.

## 6 Continuing

Back in the real world, I notice that there is an option for an `Arg` that specifies that the argument is required. I think I'd like to use that here:

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

It works! The next we need option is to specify a secret token via the command line. Lets add that, but make it optional because, well, why not? I might want to put up an open version of this for people to see.

I'm left with this:

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

There are a lot of (expected) warnings, but it compiles and runs fine. I just wanted it to type-check. Now lets bring this back to the real program. I start with the code below:

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

I don't understand what is wrong – this is essentially the same code as from the example. I tried commenting out a bunch of code besides what is essentially this:

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

… and now it compiles. There are lots of warnings, but that's fine.

None of the error messages above refer to any lines that are commented out. Now that I know that the error message do not refer to what is causing the problem, I know to look elsewhere.

The first thing I do is remove the references to those two variables. The code becomes this:

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

This compiles and runs correctly. Now that I know this is the problem, I _suspect_ that this is because the get request is routing to the `get **` closure, and importing these variables into a closure would clearly impact their lifetimes.

I talked with my friend [Carol Nichols](https://twitter.com/Carols10cents) about the problem, and she was able to suggest something that got me one step closer: convert `logfile_path` and `auth_token` to `String` types.

What I believe is going on here is that `logfile_path` and `auth_token` are both borrowed `str` types from somewhere inside the `matches` data structure, which goes out of scope… some time. At the end of `main`? Since `main` should still be running while the closure exists, it seems like `matches` should still exist.

Alternatively, it might be that closures just don't work with borrows. This seems _unlikely_ to me. It seems more likely that the compiler can't _prove_ that `matches` will still exist while closure could still be invoked. Although this _still_ doesn't make sense, since the closure is passed into `server`, which would go out of scope at the same time as `matches`!

But anyway, changing this code:

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

into this:

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

… fixed the problem. I also had to change the various functions that take `&str` types to take `String` types.

Of course, this reveals a _new_ problem:

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

At first glance, this error doesn't make any sense to me:

```
src/main.rs:69:25: 69:37 error: cannot move out of captured outer variable in an `Fn` closure
src/main.rs:69             do_log_time(logfile_path, auth_token)
```

What does it mean to "move out of" a captured variable? I don't remember anything that used language like moving in to or out of variables, and besides, that sentence doesn't make any sense to me.

The error also says some other weird stuff; what does a `Fn` closure have to do with any of this?

I searched the Internet a while for this error message, and found some results. However, none of them seemed like they applied to me. So, back to playing around

## 7 More Debugging

First, I tried compiling with the `--verbose` flag just to see if was helpful, but it did not print any additional debugging information about the error, only about the general command.

I remembered seeing a section specific to closures in the the Rust book, so I decided to look at that. From it, my guess is that I need to do a "move" closure. But, when I try it:

```
server.utilize(router! {
    get "**" => move |_req, _res| {
        do_log_time(logfile_path, auth_token)
    }
});
```

… I get a new error message:

```
$ cargo run -- -l whodat
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:66:21: 66:25 error: no rules expected the token `move`
src/main.rs:66         get "**" => move |_req, _res| {
                                   ^~~~
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

This confused me, so I decided to just try to move it outside:

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

This is the same error message.

At this point, I notice that the language of the error message sounds suspiciously like the wording used around Scheme pattern matching macro systems, and I remember the `router!` macro being used here. Some macro weirdness! I know how to solve this, because I had to deal with it before.

```
$ rustc src/main.rs --pretty=expanded -Z unstable-options
src/main.rs:5:14: 5:34 error: can't find crate for `nickel`
src/main.rs:5 #[macro_use] extern crate nickel;
```

So, I guess I need to pass this argument to cargo? Searching cargo docs doesnt seem to show anything about passing `rustc` arguments.

Searching the Internet, I found some GitHub issues that indicate sending arbitrary arguments is not supported, besides creating a custom cargo command. Creating a custom cargo command sounds like an awful diversion from the problem I am trying to solve right now, so I don't want to go down that route.

Suddenly, a wild idea appears: when using `cargo run --verbose`, I saw this `rustc` command in its output:

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

… which makes me wonder: Could I modify this to make it compile and output the macro-expanded code? Trying it:

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

It worked! It is inelegant, but at least I was able to figure it out. It is also clearer to me how the `cargo` interfaces with `rustc`.

The relevant portion of the output is this:

```
server.utilize({
                   use nickel::HttpRouter;
                   let mut router = ::nickel::Router::new();
                   {
                       router.get("**",
                                  {
                                      use nickel::{MiddlewareResult,
                                                   Responder, Response,
                                                   Request};
                                      #[inline(always)]
                                      fn restrict<'a,
                                                  R: Responder>(r: R,
                                                                res:
                                                                    Response<'a>)
                                       -> MiddlewareResult<'a> {
                                          res.send(r)
                                      }
                                      #[inline(always)]
                                      fn restrict_closure<F>(f: F) -> F
                                       where F: for<'r, 'b,
                                       'a>Fn(&'r mut Request<'b, 'a, 'b>,
                                             Response<'a>) ->
                                       MiddlewareResult<'a> + Send +
                                       Sync {
                                          f
                                      }
                                      restrict_closure(move |_req, _res| {
                                                       restrict({
                                                                    do_log_time(logfile_path,
                                                                                auth_token)
                                                                }, _res)
                                                   })
                                  });
                       router
                   }
               });
```

Ok, so that's a lot to look at. Let us unpack it a little bit.

There are two functions, `restrict` and `restrict_closure`, that immediately surprise me. I _think_ they exist to provide better type/error messaging about these request handling closures.

However, what is even _more_ interesting is:

```
restrict_closure(move |_req, _res| { ... })
```

… which tells me that macro is specify the closure as a move closure _already_. Well, there goes that theory.

## 8 Regrouping

Lets regroup and try to restate the problem. At this point, I have a `main` that looks like this:

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

Compiling gives me this:

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

I asked about it on IRC, but I got no replies. Realistically, I should have probably tried to ask on IRC during a time that I had more patience, but it is what it is.

I submitted an issue on the `nickel.rs` project, thinking that this was an issue with the macro. This was the last idea I had – I _knew_ how likely it was that I was wrong, but I saw no other way forward and I didn't want to give up.

And thus the issue at [https://github.com/nickel-org/nickel.rs/issues/241](https://github.com/nickel-org/nickel.rs/issues/241) was born. Ryman quickly saw my mistake and was kind enough to help me through it. Sure enough, he was right – if you're reading this Ryman, I owe you one.

The problem occurred in the following specific closure. Let us examine it to see what we can see:

```
get "**" => |_req, _res| {
    do_log_time(logfile_path, auth_token)
}
```

If you notice, here, the call to `do_log_time` is _transferring ownership_ of `logfile_path` and `auth_token` to that invocation of that function. This is where the problem is.

To my untrained eye, this looks "normal", the most natural form of the code. There is an important caveat that I missed: _in its current form, this lambda cannot be called more than once_. On the first time it is called, ownership of `logfile_path` and `auth_token` are transferred to the invocation of `do_log_time`. Here's the thing: if this function is called again, it _couldn't_ transfer ownership to `do_log_time`, as it no longer owns these two variables.

Thus, we get the error message:

```
src/main.rs:69:39: 69:49 error: cannot move out of captured outer variable in an `Fn` closure
```

I still don't think it makes any sense but now I understand at least that it deals with moving ownership "out" from a closure.

Anyway, the simplest way to fix this problem is to do:

```
let mut server = Nickel::new();
server.utilize(router! {
    get "**" => |_req, _res| {
        do_log_time(logfile_path.clone(), auth_token.clone())
    }
});
```

Now, upon each invocation, `logfile_path` and `auth_token` are still owned, but clones are created and ownership of the clones is transferred.

However, I'd like to point out that I still believe this is a sub-optimal solution. Since passing ownership is not referentially transparent by definition, I'm now leaning towards favoring the use of references whenever possible.

Would rust have been better if it used bare symbols to represent borrowed references, but some other symbol for owned, say `*`? I don't know, but is an interesting question.

## 9 Refactoring

I'm going to try a quick refactor to see if I can make things use references. This is going to be interesting, because I might have some unforeseen problems arise – we'll see!

I've been reading the Martin Fowler Refactoring book, and this has renewed my appreciation for doing things in small steps at a time. First, I want to change just one ownership transfer to a borrow; lets start with `logfile_path`. Starting with this:

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

I end up with this:

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

This refactoring might be called something like: _replace ownership with borrow and clone_. If I own something, and I want to change this to a borrow, but I currently transfer ownership somewhere else, I must create my own copy internally first. This allows me to change my ownership to a borrow, and yet still transfer ownership when I must. Of course, this involves cloning the thing I borrowed, which duplicates memory and has performance costs, but it allows me to change this line of code safely. I can then keep replacing ownership with borrows without breaking anything.

Applying this a few more times gives me this code:

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

I'm going to need to deal with `auth_token` soon, but for now this is a good place to stop.

## 10 Conclusions & Retrospective on Part 4

The application now parses options. However, it was tremendously difficult. I nearly ran out of options while trying solve my problems. I would have been really frustrated if the issue on nickel.rs wasn't resolved so helpfully.

Some lessons:

* Transferring ownership is a tricky thing. I think a new guideline for me is to favor passing immutable borrows by default unless I _must_ pass ownership for whatever reason.
* Cargo _really_ should have an option to pass arbitrary `rustc` arguments.
* Some of the Rust error messages are still not very good.
* Even if the error messages were poor, Rust was still right – transferring ownership inside my closure _was_ an error, since the function is called many times, once per web request. A lesson here for me is: if I don't understand an error message, it would be a good idea to _think through_ the code, specifically looking what might be hard for Rust to prove to be safe.

This experience also reinforces my frustration with compiled, strong-typed programming languages. Sometimes, you really need to examine things _in vivo_ in order to appreciate what is going on. In this example, it was hard to create a minimal reproducible that illustrated the problem.

When error messages don't give you the information you need, you're next best option is to start searching the Internet for information related to the error message. This doesn't really give you the ability to investigate, understand, and solve the problem yourself.

I think this could be alleviated by adding some ability to interrogate the state of the compiler at different times, to find more information about the problem. Something like opening an interactive prompt on compile errors would be really great, but even annotating the code to request detailed information from the compiler would be extremely useful.

—

I wrote this post over the course of about a month, mostly because I was so busy dealing with house buying stuff. At times, I was _extremely_ frustrated with some of this. I expected integrating option parsing to be the easiest of tasks!

However, realizing that Rust caught my bug really relieving. Even if the error message wasn't as good as I had hoped, I liked that this would have been a legitimate segmentation fault that I was saved from.

I hope that as Rust matures, the error messages get better. If they do, I think all my concerns will disappear.

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
