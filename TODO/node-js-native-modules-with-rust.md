> * 原文地址：[Writing fast and safe native Node.js modules with Rust](https://blog.risingstack.com/node-js-native-modules-with-rust/)
> * 原文作者：[Peter Czibik](https://twitter.com/@peteyycz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/node-js-native-modules-with-rust.md](https://github.com/xitu/gold-miner/blob/master/TODO/node-js-native-modules-with-rust.md)
> * 译者：[LeopPro](https://github.com/LeopPro)
> * 校对者：[Serendipity96](https://github.com/Serendipity96)

# 使用 Rust 编写快速安全的原生 Node.js 模块

> 内容梗概 - 使用 Rust 代替 C++ 开发原生 Node.js 模块！

[RisingStack](https://risingstack.com/) 去年面临一件棘手的事：我们已经尽可能让 Node.js 发挥出最高的性能，然而我们的服务器开销还是达到的最高限度。为了提高我们应用的性能（并且降低成本），我们决定彻底重写它，并将系统迁移到其他的基础设施上 - 毫无疑问，这个工作量很大，这里不详叙了。
后来我发现，**我们只要写一个原生模块就行了！**

那时候，我们还没意识到有更好的方法来解决我们的性能问题。就在几周前，我发现有另外一个方案可行 **采用 Rust 代替 C ++ 来实现原生模块。** 我发现这是一个很好的选择，这要归功于它提供的安全性和易用性。

> 在这篇 Rust 教程中，我将手把手教你写一个先进、快速、安全的原生模块。

## Node.js 服务器的性能问题

我们的问题在 2016 年末的时候暴露出来，当时我们一直在研究 Node.js 的监控产品 Trace，该产品于2017年10月与 [Keymetrics](https://blog.risingstack.com/trace-becomes-keymetrics-by-october-31/) 合并。
像当时的其他科技创业公司一样，我们将服务部署到 [Heroku](https://www.heroku.com/) 上以节省一些基础设施成本和维护费用。我们一直在构建微服务架构应用程序，这意味着我们很多服务都是通过 HTTP(S) 进行通信的。

**棘手的问题来了：** 我们想让各服务之间进行安全的通信，但是 Heroku 不支持私有网络，所以我们不得不实现一个自己的方案。因此，我们查阅了一些安全认证方案，最终选定了 HTTP 签名。

> 简要地解释一下：HTTP 签名基于非对称密码体系。要创建一个 HTTP 签名，你需要获取一个请求的所有部分：URL、请求头、请求体，使用你的私钥对其签名。然后，你可以将公钥发给将会收到签名请求的设备，以便它们验证。

随时间流逝，我们发现在大多数 HTTP 服务器进程中，CPU 利用率已经达到了极限。显然，一个原因引起我们怀疑 - 如果你想加密，那就会发生这样的问题。

然而，在对 [v8-profiler](https://github.com/node-inspector/v8-profiler) 进行了严格分析之后，我们发现问题不是由加密引起的！是 [URL 解析](https://node.js.org/docs/latest/api/url.html)占用 CPU 最多的时间。为什么？因为要进行验证，就必须解析 URL 来验证请求签名。

为了解决这个问题，我们决定放弃 Heroku（这其中也有其他因素），我们创建了一个包含 Kubernetes 和内部网络的 Google 云基础设施，而不是优化我们的 URL 解析。

是什么原因促使我写这个故事（教程）呢？就在几周前，我意识到我们可以用另一种方法优化 URL 解析 —— 使用 Rust 写一个原生库。

## 编写原生模块 - 需要一个 Rust 模块

**编写原生代码应该不那么难，对吧？**

在 RisingStack，我们奉行工欲善其事，必先利其器的宗旨。我们经常对更好的软件构件方式做调查，在必要的时候，也使用 C++ 来编写原生模块。

> 恬不知耻地说一句：我也在博客上写了我的学习历程 [原生 Node.js 模块之旅](https://blog.risingstack.com/writing-native-node-js-modules/)。去看一看！

在此之前，我认为在绝大多数业务场景中，C++ 是编写一个快速有效的软件的正确选择。然而现在我们有了现代化的工具（本例中 - Rust），我们可以用它花费比以前都少的人力成本来编写更有效、更安全、更快速的代码。

让我们回到最初的问题：解析一个 URL 难道很困难么？它包括协议、主机、查询参数……

![URL-parsing-protocol](/content/images/2017/11/URL-parsing-protocol.png)  
（出自 [Node.js documentation](https://nodejs.org/en/docs/)）

这看起来真复杂。当我通读 [the URL standard](https://url.spec.whatwg.org/) 之后，我发现我不想自己实现它，所以我开始寻找替代品。

我确信我不是唯一一个想要解析 URL 的人。浏览器可能已经解决了这个问题，所以我搜索了 Chromium 的解决方案：[谷歌链接](https://src.chromium.org/viewvc/chrome/trunk/src/url/)。尽管使用 N-API 可以很容易地从 Node.js 调用这个实现，但是有几个原因让我不这样做：

*   **更新：** 当我只是从网上复制粘贴代码的时候，我立即感到了不安。长久以来，人们一直这样做，而且总有许多原因使它们不能很好地工作……没有什么好的方法去更新代码库中的大段代码。
*   **安全性：** 一个没有丰富 C++ 编程经验的人是无法验证代码是否正确的，但是我们又不得不将它运行在我们服务器上。C++ 学习曲线过于陡峭，人们需要花费很长时间掌握它。
*   **私密性：** 我们都听说过可用的 C++ 代码是存在的，然而我宁愿避免复用 C++ 代码，因为我没办法独自审计它。使用维护良好的开源模块给了我足够的信心，我不必担心它的私密性。

**所以我更倾向于一门更易于使用的，具有简易更新机制和现代化的语言：Rust！**

## 关于 Rust 简单说两句

Rust 允许我们编写快速有效的代码。

所有的 Rust 工程由 `cargo` 管理 —— 就是 Rust 界的 `npm`。`cargo` 可以安装工程依赖，并且有一个注册表包含了所有你需要使用的包。

我发现了一个可以在我们例子中使用的库 - [rust-url](https://github.com/servo/rust-url)，非常感谢 Servo 团队所做的工作。

我们也要使用 Rust FFI！两年前我已经写过一个相关的博客 [using Rust FFI with Node.js](https://blog.risingstack.com/how-to-use-rust-with-node-when-performance-matters/)。从那时到现在，Rust 生态系统已经发生了很多改变。

我们有了一个可以工作的库（rust-url），让我们试着去编译它吧！

### 如何编译一个 Rust 应用？

根据 [https://rustup.rs](https://rustup.rs) 指南，我们可以用 `rustc` 编译器，但是我们现在更应该关心的是 `cargo`。我不想深入描述它是如何工作的，如果你感兴趣，请移步至我们[以前的 Rust 博文](https://blog.risingstack.com/how-to-use-rust-with-node-when-performance-matters/)。

### 创建新的 Rust 工程

创建一个新的 Rust 工程就这么简单：`cargo new --lib <工程名>`。

> 你可以在我的仓库中查看完整代码 [https://github.com/peteyy/rust-url-parse](https://github.com/peteyy/rust-url-parse)

想要引用 Rust 库，我们只要将它作为一个依赖列在 `Cargo.toml` 中就可以了。

```
[package]
name = "ffi"
version = "1.0.0"
authors = ["Peter Czibik <p.czibik@gmail.com>"]

[dependencies]
url = "1.6"
```

Rust 没有类似 `npm install` 一样安装依赖的命令 - 你必须自己手动添加它。然而有一个叫做 [`cargo edit`](https://github.com/killercup/cargo-edit) 的 crate 可以实现类似功能。

> 译者注：crate 是 Rust 中一个类似包（package）的概念，上文中的 rust-url 也属于一个 crate。[crates.io](https://crates.io/) 允许全世界的 Rust 开发者搜索或者发布 crate。

### Rust FFI

为了从 Node.js 中调用 Rust，我们可以使用 Rust 提供的 FFI。FFI 是外部函数接口（Foreign Function Interface）的缩写。外部函数接口（FFI）是由一种程序语言编写的，能够调用另一种语言编写的例程或使用服务的机制。

为了链接我们的库，我们还需要向 `Cargo.toml` 中添加两个东西

```
[lib]
crate-type = ["dylib"]

[dependencies]
libc = "0.2"
url = "1.6"
```

在这里需要说明：我们的库是动态链接库，文件扩展名为 `.dylib`，这个库在运行期被加载而不是编译期。

我们还要为工程添加 `libc`依赖，`libc` 是遵从 ANSI C 标准的 C 语言标准库。

`libc` crate 是 Rust 的一个库，它具有与各种系统（包括libc）中常见类型和函数的本地绑定。这允许我们在 Rust 代码中使用 C 语言类型，我们想在 Rust 函数中接收或返回任何 C 类型数据，我们都必须使用它。

我们的代码相当简单 —— 我使用 `extern crate` 关键字来引用 `url` 和 `libc` crate。我们要把函数标记为 `pub extern` 使得这些函数可以通过 FFI 被暴漏给外部。我们的函数持有一个代表 Node.js 中 `String` 类型的 `c_char` 指针。

我们需要把类型转换标记为 `unsafe`。被标记了 `unsafe` 关键字的代码块可以访问非安全的函数或者取消引用在安全函数中的裸指针（raw pointer）。

Rust 使用 `Option<T>` 类型来表示一个可为空的值。就像 JavaScript 中一个值可以为 `null` 或者 `undefined` 一样。每次尝试访问可能为空的值时，都可以（也应该）明确地检查。在 Rust 中，有几种方式可以访问它，但是在这里，我将使用最简单的方式：如果值为空，则将会抛出一个错误（panic in Rust terms）[`unwrap`](https://doc.rust-lang.org/std/option/enum.Option.html#method.unwrap)。

当我们搞定了 URL 解析，我们要将结果转化为 `CString` 才能传回 JavaScript。

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

要编译这些 Rust 代码，你可以使用 `cargo build --release` 命令。在编译之前，确认你在 `Cargo.toml` 的依赖中添加 `url` 库了！

现在我们可以使用 Node.js 的 `ffi` 包创建一个用于调用 Rust 代码的模块。

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

`cargo build --release` 命令编译出的 `.dylib` 命名规则是 `lib*`，其中的 `*` 是你的库名。

美滋滋：我们已经有了一个可以从 Node.js 调用的 Rust 代码！虽说能拔脓的就是好膏药，但是你应该已经发现了，我们不得不做一大堆类型转换，这将增加我们函数调用的开销。一定有更好的办法将我们的代码与 JavaScript 做整合。

## 初遇 Neon

> 用于编写安全、快速的原生 Node.js 模块的 Rust 绑定。

Neon 让我们可以在 Rust 代码中使用 JavaScript 类型。要创建一个新的 Neon 工程，我们可以使用它自带的命令行工具。执行 `npm install neon-cli --global` 来安装它。

执行 `neon new <projectname>` 将会创建一个新的没有任何配置 Neon 工程。

创建好 Neon 工程后，我们重写上面的代码如下：

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

上述代码中，新类型 `JsString`、`Call` 和 `JsResult` 是对 JavaScript 类型的封装，这样我们就可以接入 JavaScript VM ，执行上面的代码。`Scope` 将我们的新变量绑定到当前的 JavaScript 域中，这让我们的变量就可以被垃圾收集器回收。

这和我之前写的博文中 [使用 C++ 编写原生 Node.js 模块](https://blog.risingstack.com/writing-native-node-js-modules/) 解释地非常类似。

值得注意的是，`#[macro_use]` 属性允许我们使用 `register_module!` 宏，这可以让我们像 Node.js 中的 `module.exports` 一样创建模块。

唯一棘手的地方是对参数的访问：

```
let url = call.arguments.require(scope, 0)?.check::<JsString>()?.value();
```

我们得接受所有类型的参数（如同任何 JavaScript 函数一样），所以我们没办法确定参数的数量，这就是我们必须要检查第一个元素是否存在的原因。

除此之外，我们可以摆脱大多数的序列化工作，直接使用 `Js` 类型就好了。

**现在，我们尝试运行它！**

如果你事先下载了我的示例代码，你需要进入 ffi 文件夹执行 `cargo build --release` ，然后进入 neon 文件夹执行  `neon build`（事先要装好 neon-cli）。

如果你都准备好了，你可以使用 Node.js 的 [faker library](https://www.npmjs.com/package/faker) 生成一个新的 URL 列表。

执行 `node generateUrls.js` 命令，这将会在你的文件夹中创建一个 `urls.json` 文件，我们的测试程序一会儿会尝试解析它。搞定了这些后，你可以执行 `node urlParser.js` 来运行基准测试，如果全部成功了，你将会看到下图：

![Rust-Node-js-success-screen](/content/images/2017/11/Rust-Node-js-success-screen.png)

测试程序解析了100个URL（随机产生），我们的应用只需要一次运行就可以解析出结果。如果你想做基准测试，请增加 URL 数量（urlParser.js 中的 `tryCount`）或次数（urlGenerator.js 中的 `urlLength`）。

显而易见，在基准测试中表现最好的是 Rust neon 版本，但是随之数组长度的增加，V8 有越来越多的优化空间，他们之间的成绩会接近。最终它将超过 Rust neon 实现。

![Rust-node-js-benchmark](/content/images/2017/11/Rust-node-js-benchmark.png)

这只是一个简单的例子，当然，在这个领域我们还有很多东西要学习，

后续，我们可以进一步优化计算，尽可能的利用并发计算提高性能，一些类似 [`rayon`](https://crates.io/crates/rayon) 的 crates 提供给我们类似的功能。

## 在 Node.js 中实现 Rust 模块

希望你今天跟我学到了在 Node.js 中实现 Rust 模块的方法，从此你可以从（工具链中的）新工具中受益。我想说的是，虽然这是能解决问题的（而且很有趣），但它并不是解决所有性能问题的银弹。

**请记住，在某些场景下，Rust 可能是很便利的解决方案**

如果你想看看我在 Rust 匈牙利研讨会上关于本话题的发言，[点这里](https://youtu.be/zz1Gie9FkbI)！

如果你有任何问题或评论，请在下面留言，我将在这回复你们！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
