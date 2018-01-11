> * 原文地址：[A Simple Web App in Rust, Part 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
> * 原文作者：[Joel's Journal](http://joelmccracken.github.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-simple-web-app-in-rust-pt-1.md)
> * 译者：
> * 校对者：

# A Simple Web App in Rust, Part 1

## 1 Intro & Background

What is it like to write a tiny web app in Rust from the perspective of an experienced programmer who is new to the ecosystem? Read on to find out.

I've been interested in Rust since I first heard about it. A systems language that supports macros & has room to grow towards higher-level abstractions? Awesome.

So far, I have only written read blog posts about Rust & done some very basic "hello world" style programs. So, I guess I'm saying that my perspective is pretty raw.

A while back I saw [this article](http://artyom.me/learning-racket-1) about learning Racket, and I thought it was really great. We need more people writing about their experiences as beginners with a technology, especially those who already have a fair amount of experience with technology [1](#fn.1). I also liked its stream-of-consciousness approach, and think it would be a nice experiment to write one for Rust.

So, with the preliminaries out of the way, let's get started.

## 2 The App

The app I want to build serves a simple need of mine: A brain-dead-easy way to record when I take my medication each day. I want tap a link on my home screen and have it record the visit, and this will preserve a record of when I've taken my medication.

Rust seems to be suited for this app. It's fast. Running a single, simple server takes relatively few resources, so it won't be taxing to my VPS. And, I have wanted to do something more real with Rust.

The MVP is very small, but there room for it to grow if I want to add more features. Sounds perfect.

## 3 The Plan

So, I'm going to quickly admit something here: I lost an earlier version of this project. This has some disadvantages: as I recreate this, I won't have the same level of unfamiliarity I did when I approached it some weeks ago. However, I think I remember those pain points, and will do my best to recreate them.

However, there is one thing that I learned that I want to apply here: it is much easier to build separate, individual programs while exploring APIs instead of trying to do everything all at once.

To that end, I have the following plan:

1. Build a simple web server that displays "hello world" when I visit.
2. Build a tiny program that logs the formatted date and time whenever it is run.
3. Integrate the two into a single application.
4. Deploy this application to my server, a Digital Ocean VPS.

## 4 Writing The "Hello World" Web App

So, I'm starting an empty git repo & have homebrew installed. Lets install Rust. I know this much, at least.

### 4.1 Installing Rust

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

Oook, before anything else, lets do a regular "hello world" program.

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

So far, so good. Rust is working! Or, at least, the compiler is.

A friend suggested I try [nickle.rs](http://nickel.rs/) as a web application framework for Rust. It looks good to me!

As of today, the first example it uses is:

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

So, the first time I did this, I got a little side tracked and learned a bit about cargo. This time, I notice that there's this ["getting started" link](http://nickel.rs/getting-started.html), so I think I'll try that instead of getting everything set up on my own.

There's a script that I'm supposed to `curl` and pipe into a root shell, but that makes me paranoid so I'm going to download it and look over it first.

`curl -LO https://static.rust-lang.org/rustup.sh`


Ok, this actually doesn't look like its going to do what I want. At least, there's a lot going on in this script, more than I want to deal with right now. Hmm. I _wonder_ if `cargo` got installed with `rustc`?

```
$ which cargo
/usr/local/bin/cargo
$ cargo -v
Rust's package manager

Usage:
    cargo <command> [<args>...]
    cargo [options]

Options:
    -h, --help       Display this message
    -V, --version    Print version info and exit
    --list           List installed commands
    -v, --verbose    Use verbose output

Some common cargo commands are:
    build       Compile the current project
    clean       Remove the target directory
    doc         Build this project's and its dependencies' documentation
    new         Create a new cargo project
    run         Build and execute src/main.rs
    test        Run the tests
    bench       Run the benchmarks
    update      Update dependencies listed in Cargo.lock
    search      Search registry for crates

See 'cargo help <command>' for more information on a specific command.
```

Ok, that looks good I guess? I'll go with it for now.

`$ rm rustup.sh`

### 4.2 Setting Up the Project

So, the next step is to generate a new project directory. But I already have a project directory =(. I'll try it like this, anyway.

```
$ cargo new . --bin
Destination `/Users/joel/Projects/simplelog/.` already exists
```

Ugh, that didn't work.

```
$ cargo -h
Create a new cargo package at <path>

Usage:
    cargo new [options] <path>
    cargo new -h | --help

Options:
    -h, --help          Print this message
    --vcs <vcs>         Initialize a new repository for the given version
                        control system (git or hg) or do not initialize any version
                        control at all (none) overriding a global configuration.
    --bin               Use a binary instead of a library template
    --name <name>       Set the resulting package name
    -v, --verbose       Use verbose output
```

Yeah, it doesn't look like this is going to do what I want it to. Blah I guess I'll just redo this repo.

```
$ cd ../
$ rm -rf simplelog/
$ cargo new simple-log --bin
$ cd simple-log/
```

Ok, what's up in here?

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

So, it made a git repository, `Cargo.toml` and a `main.rs` in a `src` directory. Sounds fine to me.

Next on the nickel getting started page, I add the `nickel.rs` dependency to the cargo file, and it now looks like:

```
[package]
name = "simple-log"
version = "0.1.0"
authors = ["Joel McCracken <mccracken.joel@gmail.com>"]

[dependencies.nickel]

git = "https://github.com/nickel-org/nickel.rs.git"
```

This makes sense, I think. I'm not sure what "dependencies.nickel" is actually _saying_. Is `dependencies` a hash with a `nickel` key? I do get that I'm saying "get nickel from here, yo".



### 4.3 The "Hello World" Example Running

Anyway, moving on and pasting the example into `main.rs`:

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

So, what's the deal with `macro_use`, `extern`, and then needing to `use`? All stuff I will figure out later.

_Oh snap_, I had a few sentences about how `macro_use` was probably a macro-time directive[2](#fn.2), but I didn't see any actual macros, so I deleted it. Now I see `router!`, though, so I'm even more inclined to think this is a macro directive. Also, I doubt the term 'directive' is correct, so don't pick it up.

Lets try it:

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

Woo hoo! Visiting `localhost:6767` in my browser worked.

### 4.4 One Final Challenge

Ok, now I want to try one thing and then call it a night: can I move the "hello world" into its own function? Baby steps, after all.

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

Err… when I run it this time, I see "Not found". Let me try fiddling with semicolons just in case that's important:

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

Ok… now I have a completely different error message:

```
$ cargo run
   Compiling simple-log v0.1.0 (file:///Users/joel/Projects/simple-log)
src/main.rs:6:5: 6:24 error: mismatched types:
 expected `()`,
    found `&'static str`
(expected (),
    found &-ptr) [E0308]
src/main.rs:6     "Hello dear world!"
                  ^~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `simple-log`.

To learn more, run the command again with --verbose.
```

So, I _guess_ the presence/absence of the semicolon was important. And now I'm getting a type error, at least. Oh, and I'm 90% sure that `()` is referring to what I remember to be 'unit', the Rust idea of undefined, nil, or whatever. I'm sure this isn't quite right, but I guess it makes sense.

I _assumed_ Rust would do type inferencing. Does it not? Or does it just not do it around function boundaries? Hmm.

So, the error message is telling me that it expected the return value to be unit, but the actual return value was a static string(?). I'm pretty sure I've seen the syntax for specifying return value types; let me see:

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

The type `&'static str` looks very weird to me. Does it compile? Does it work?

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

Yay, it worked! This time around, Rust hasn't been _that_ frustrating. I'm not sure if its because I'm more familiar with some of this tooling, or I've opted to read documentation more, but I'm having fun. Also, the difference between _reading_ a language and _writing_ in a language sometimes very surprising. While I understand these code examples, I can't make edits quickly and effectively.

—

Next up, we will work through the process of writing the current date to a file. This can be found [here](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a).

—

Series: A Simple Web App in Rust

* [Part 1](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-1/)
* [Part 2a](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2a/)
* [Part 2b](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-2b/)
* [Part 3](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-3/)
* [Part 4](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-pt-4-cli-option-parsing/)
* [Conclusion](http://joelmccracken.github.io/entries/a-simple-web-app-in-rust-conclusion/)

## Footnotes:

[1](#fnr.1) I'm not trying to say that the experiences of beginners is not valuable – far from it! However, I do think those experiences bring a separate set of insights than those from someone who has been programming for a long time, and they may notice how non-standard some things in an ecosystem are.

[2](#fnr.2) I would normally say 'compile-time' directive, but that doesn't make much sense since Rust is a compiled language. So, I say 'macro-time' directive, but I really have no idea.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
