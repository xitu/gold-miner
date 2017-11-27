> * 原文地址：[Writing fast and safe native Node.js modules with Rust](https://blog.risingstack.com/node-js-native-modules-with-rust/)
> * 原文作者：[Peter Czibik](https://twitter.com/@peteyycz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/node-js-native-modules-with-rust.md](https://github.com/xitu/gold-miner/blob/master/TODO/node-js-native-modules-with-rust.md)
> * 译者：
> * 校对者：

# Writing fast and safe native Node.js modules with Rust

> TL:DR - Use Rust instead of C++ to write native Node.js modules!

RisingStack faced a shocking event last year: we reached the maximum speed that Node.js had to offer at the time, while our server costs went over the roof. To increase the performance of our application (and decrease our costs), we decided to completely rewrite it, and migrate our system to a different infrastructure - which was a lot of work, needless to say.

I figured out later that **we could have just implemented a native module instead!**

Back then, we weren’t aware that there was a better method to solve our performance issue. Just a few weeks ago I found out that another option could have been available. **That’s when I picked up Rust instead of C++ to implement a native module.** I figured out that it is a great choice thanks to the safety and ease of use it provides.

> In this Rust tutorial, I’m going to walk you through the steps of writing a modern, fast and safe native module.

## The Problem with our Node.js Server Speed

Our issue began in late 2016 when we've been working on Trace, our Node.js monitoring product, which was recently merged with [Keymetrics](https://blog.risingstack.com/trace-becomes-keymetrics-by-october-31/) in October 2017.

Like every other tech startup at the time, we've been running our services on Heroku to spare some expenses on infrastructure costs and maintenance. We've been building a microservice architecture application, which meant that our services have been communicating a lot over HTTP(S).

**This is where the tricky part comes in:** we wanted to communicate securely between the services, but Heroku did not offer private networking, so we had to implement our own solution. Therefore, we looked into a few solutions for authentication, and the one we eventually settled with was http signatures.

> To explain it briefly; http signatures are based on public-key cryptography. To create an http signature, you take all parts of a request: the URL, the body and the headers and you sign them with your private key. Then, you can give your public key to those who would receive your signed requests so they can validate them.

Time passed by and we noticed that CPU utilization went over the roof in most of our http server processes. We suspected an obvious reason - if you're doing crypto, it's like that all the time.

However, after doing some serious profiling with the [v8-profiler](https://github.com/node-inspector/v8-profiler) we figured out that it actually wasn't the crypto! It was the [URL parsing](https://node.js.org/docs/latest/api/url.html) that took the most CPU time. Why? Because to do the authentication, we had to parse the URL to validate request signatures.

To solve this issue, we decided to leave Heroku (what we wanted to do for other reasons too), and create a Google Cloud infrastructure with Kubernetes & internal networking - instead of optimizing our URL parsing.

The reason for writing this story/tutorial is that just a few weeks ago I realized that we could have optimized URL parsing in an other way - by writing a native library with Rust.

## Naive developer going native - the need for a Rust module

**It shouldn't be that hard to write native code, right?**

Here at RisingStack, we've always said that we want to use the right tool for the job. To do so, we’re always doing research to create better software, including some on C++ native modules when necessary.

> Shameless plug: I've written a blogpost about my learning [journey on native Node.js modules](https://blog.risingstack.com/writing-native-node-js-modules/) too. Take a look!

Back then I thought that in most cases C++ is the right way to write fast and efficient software.. However, as now we have modern tooling at our disposal (in this example - Rust), we can use it to write more efficient, safe and fast code with much less effort than it ever required.

Let's get back to our initial problem: parsing an URL shouldn't be that hard right? It contains a protocol, host, query parameters...

![URL-parsing-protocol](/content/images/2017/11/URL-parsing-protocol.png)  
(Source the [Node.js documentation](https://nodejs.org/en/docs/))

That looks pretty complex. After reading through [the URL standard](https://url.spec.whatwg.org/) I figured out that I don't want to implement it myself, so I started to look for alternatives.

I thought that surely I'm not the only person who wants to parse URLs. Browsers probably have already solved this issue, so I checked out chromium's solution: [google-url](https://src.chromium.org/viewvc/chrome/trunk/src/url/). While that implementation can be easily called from Node.js using the N-API, I have a few reasons not to do so:

*   **Updates:** when I just copy-paste some code from the internet I immediately get the feeling of danger. People have been doing it for a long time, and there are so many reasons it didn't work out so well.. There is just no easy way of updating a huge block of code that is sitting in my repository.
*   **Safety:** a person with not so much C++ experience cannot validate that the code is right, but we'll eventually have to run it on our servers. C++ has a steep learning curve, and it takes a long time to master it.
*   **Security:** we all heard about exploitable C++ code that is out there, which I'd rather avoid because I have no way to audit it myself. Using well maintained open-source modules gives me enough confidence to not worry about security.

**So I'd much prefer a more approachable language, with an easy to use update mechanism and modern tooling: Rust!**

## A few words about Rust

Rust allows us to write fast and efficient code.

All of the Rust projects are managed with `cargo` - think about it as `npm` for Rust. Project dependencies can be installed with `cargo`, and there is a registry full of packages waiting for you to use.

I found a library which we can use in this example - [rust-url](https://github.com/servo/rust-url), so shout out to the Servo team for their work.

We’re going to use Rust FFI too! We had already covered [using Rust FFI with Node.js](https://blog.risingstack.com/how-to-use-rust-with-node-when-performance-matters/) in a previous blogpost two years ago. Since then quite a lot has changed in the Rust ecosystem.

We have a supposedly working library (rust-url), so let's try to build it!

### How do I build a Rust app?

After following instructions on [https://rustup.rs](https://rustup.rs), we can have a working `rustc` compiler, but all we should care about now is `cargo`. I don't want to go into much detail about how it works, so please check out our [previous Rust blogpost](https://blog.risingstack.com/how-to-use-rust-with-node-when-performance-matters/) if you're interested.

### Creating a new Rust Project

Creating a new Rust project is as simple as `cargo new --lib <projectname>`.

> You can check out all of the code in my example repository [https://github.com/peteyy/rust-url-parse](https://github.com/peteyy/rust-url-parse)

To use the Rust library that we have, we can just list it as a dependency in our `Cargo.toml`

```
[package]
name = "ffi"
version = "1.0.0"
authors = ["Peter Czibik <p.czibik@gmail.com>"]

[dependencies]
url = "1.6"
```

There is no short (built in) form for adding a dependency as you do with `npm install` - you have to manually add it yourself. However, there is a crate called [`cargo edit`](https://github.com/killercup/cargo-edit) that adds a similar functionality.

### Rust FFI

To be able to use Rust modules from Node.js, we can use the FFI provided by Rust. FFI is a short-term for Foreign Function Interface. Foreign function interface (FFI) is a mechanism by which a program written in one programming language can call routines or make use of services written in another.

To be able to link to our library we have to add two things to `Cargo.toml`

```
[lib]
crate-type = ["dylib"]

[dependencies]
libc = "0.2"
url = "1.6"
```

We have to declare that our library is a dynamic library. A file ending with the extension `.dylib` is a dynamic library: it's a library that's loaded at runtime instead of at compile time.

We will also have to link our program against `libc`. `libc` is the standard library for the C programming language, as specified in the ANSI C standard.

The `libc` crate is a Rust library with native bindings to the types and functions commonly found on various systems, including libc. This allows us to use C types from our Rust code, which we will have to do if we'd like to accept or return anything from our Rust functions. :)

Our code is fairly simple - I'm using the `url` and `libc` crate with the `extern crate` keyword. To expose this to the outer world through FFI, it is important to mark our function as `pub extern`. Our function takes a `c_char` pointer which represents the `String` types coming from Node.js.

We need to mark our conversion as `unsafe`. A block of code that is prefixed with the unsafe keyword is used to permit calling unsafe functions or dereferencing raw pointers within a safe function.

Rust uses the `Option<T>` type to represent a value that can be empty. Think of it as a value that can be `null` or `undefined` in your JavaScript. You can (and should) explicitly check every time you try to access a value that can be null. There are a few ways to address this in Rust, but this time I'm going with the simplest method: [`unwrap`](https://doc.rust-lang.org/std/option/enum.Option.html#method.unwrap) which will simply throw an error (panic in Rust terms) if the value is not present.

When the URL parsing is done, we have to convert it to a `CString`, that can be passed back to JavaScript.

```
extern crate libc;
extern crate url;

use std::ffi::{CStr,CString};
use url::{Url};

#[no_mangle]
pub extern "C" fn get_query (arg1: *const libc::c_char) -> *const libc::c_char {

    let s1 = unsafe { CStr::from_ptr(arg1) };

    let str1 = s1.to_str().unwrap();

    let parsed_url = Url::parse(
        str1
    ).unwrap();

    CString::new(parsed_url.query().unwrap().as_bytes()).unwrap().into_raw()
}
```

To build this Rust code, you can use `cargo build --release` command. Before compilation, make sure you add the `url` library to your list of dependencies in `Cargo.toml` for this project too!

We can use the `ffi` Node.js package to create a module that exposes the Rust code.

```
const path = require('path');
const ffi = require('ffi');

const library_name = path.resolve(__dirname, './target/release/libffi');
const api = ffi.Library(library_name, {
  get_query: ['string', ['string']]
});

module.exports = {
  getQuery: api.get_query
};
```

The naming convention is `lib*`, where `*` is the name of your library, for the `.dylib` file that `cargo build --release` builds.

This is great; we have a working Rust code that we called from Node.js! It works, but you can already see that we had to do a bunch of conversion between the types, which can add a bit of an overhead to our function calls. There should be a much better way to integrate our code with JavaScript.

## Meet Neon

> Rust bindings for writing safe and fast native Node.js modules.

Neon allows us to use JavaScript types in our Rust code. To create a new Neon project, we can use their own cli. Use `npm install neon-cli --global` to install it.

`neon new <projectname>` will create a new neon project with zero configuration.

With our neon project done, we can rewrite the code from above as the following:

```
#[macro_use]
extern crate neon;

extern crate url;

use url::{Url};
use neon::vm::{Call, JsResult};
use neon::js::{JsString, JsObject};

fn get_query(call: Call) -> JsResult<JsString> {
    let scope = call.scope;
    let url = call.arguments.require(scope, 0)?.check::<JsString>()?.value();

    let parsed_url = Url::parse(
        &url
    ).unwrap();

    Ok(JsString::new(scope, parsed_url.query().unwrap()).unwrap())
}

    register_module!(m, {
        m.export("getQuery", get_query)
    });
```

Those new types that we're using on the top `JsString`, `Call` and `JsResult` are wrappers for JavaScript types that allows us to hook into the JavaScript VM and execute code on top of it. The `Scope` allows us to bind our new variables to existing JavaScript scopes, so our variables can be garbage collected.

This is much like [writing native Node.js modules in C++](https://blog.risingstack.com/writing-native-node-js-modules/) which I've explained in a previous blogpost.

Notice the `#[macro_use]` attribute that allows us to use the `register_module!` macro, which allows us to create modules just like in Node.js `module.exports`.

The only tricky part here is accessing arguments:

```
let url = call.arguments.require(scope, 0)?.check::<JsString>()?.value();
```

We have to accept all kinds of arguments (as any other JavaScript function does) so we cannot be sure if the function was called with single or multiple arguments. That is why we have to check for the first element's existence.

Other than that change, we can get rid of most of the serialization and just use `Js` types directly.

**Now let's try to run them!**

If you downloaded my example first, you have to go into the ffi folder and do a `cargo build --release` and then into the neon folder and (with previously globally installed neon-cli) run `neon build`.

If you're ready, you can use Node.js to generate a new list of urls with the [faker library](https://www.npmjs.com/package/faker).

Run the `node generateUrls.js` command which will place a `urls.json` file in your folder, what our tests will read and try to parse. When that is ready, you can run the "benchmarks" with `node urlParser.js`. If everything was successful, you should see something like this:

![Rust-Node-js-success-screen](/content/images/2017/11/Rust-Node-js-success-screen.png)

This test was done with 100 URLs (randomly generated) and our app parsed them only once to give a result. If you'd like to benchmark parsing, increase the number (`tryCount` in urlParser.js) of URLs or the number of times (`urlLength` in urlGenerator.js).

You can see the winner in my benchmark is the Rust neon version, but as the length of the array increases, there will be more optimization V8 can do, and they will get closer. Eventually, it will surpass the Rust neon implementation.

![Rust-node-js-benchmark](/content/images/2017/11/Rust-node-js-benchmark.png)

This was just a simple example, so of course, there is much to learn for us in this field,

We can further optimize this calculation in the future, potentially utilizing concurrency libraries provided by some crates like [`rayon`](https://crates.io/crates/rayon).

## Implementing Rust modules in Node.js

Hopefully, you've also learned something today about implementing Rust modules in Node.js along with me, and you can benefit from a new tool in your toolchain from now on. I wanted to demonstrate that while this is possible (and fun), it is not a silver bullet that will solve all of the performance problems.

**Just keep in mind that knowing Rust may come handy in certain situations.**

In case you'd like to see me talking about this topic during the Rust Hungary meetup, [check this vid out](https://youtu.be/zz1Gie9FkbI)!

If you have any questions or comments, let me know in the section below - I’ll be here to answer them!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
