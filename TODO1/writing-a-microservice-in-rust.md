> * 原文地址：[Writing a Microservice in Rust](http://www.goldsborough.me/rust/web/tutorial/2018/01/20/17-01-11-writing_a_microservice_in_rust/)
> * 原文作者：[Peter Goldsborough](http://www.goldsborough.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-microservice-in-rust.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-microservice-in-rust.md)
> * 译者：[nettee](https://github.com/nettee)
> * 校对者：[HearFishle](https://github.com/HearFishle), [shixi-li](https://github.com/shixi-li)

# 用 Rust 写一个微服务

请允许我在写这样一篇**用 Rust 写一个微服务**的文章的开头先谈两句 C++。我成为 C++ 社区的一个相当活跃的成员已经很长一段时间了。我参加会议并[贡献了演讲](https://www.youtube.com/watch?v=E6i8jmiy8MY)，跟随语言的更现代化的特性的发展和传播，当然也写了很多代码。C++ 让用户在写代码时能对程序的所有方面有非常细粒度的控制，不过代价是陡峭的学习曲线，以及写出有效的 C++ 代码所需的[大量知识](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/n4659.pdf)。然而，C++ 也是一个非常古老的语言。它由 Bjarne Stroustrup 在 1985 年构思出来。因此，它即使在现代标准中也带有很多的历史包袱。 当然，在 C++ 创建之后，关于语言设计的研究仍在继续，也导致了一些如 [Go](https://golang.org)、[Rust](https://www.rust-lang.org/en-US/)、[Crystal](https://crystal-lang.org) 等很多有趣的新语言的诞生。然而，这些新语言中很少有能够既具有比现代 C++ 更有趣的功能，**同时仍**保证具备和 C++ 同样的性能和对内存、硬件的控制。Go 想要替代 C++，但正如 [Rob Pike 发现的那样](https://commandcenter.blogspot.com/2012/06/less-is-exponentially-more.html)，C++ 程序员对一种性能较差而又提供较少控制的语言不是很感兴趣。不过，Rust 却吸引了很多 C++ 爱好者。Rust 和 C++ 有不少相同的设计目标，比如**零成本抽象**，以及对内存的精细控制。除此之外，Rust 还添加了很多让程序更安全、更有表达力，以及让开发更高效的语言特性。我对 Rust 最感兴趣的东西是

* **借用检查**，极大地提升了内存安全性（再也没有 `SEGFAULT` 了！）；
* 默认的不可变性（`const`）；
* 符合直觉的语法糖，例如模式匹配（pattern matching）；
* 没有内置的（算数）类型间的隐式转换。

闲聊完毕。本文的剩余部分将引导你创建一个小而完整的**微服务** —— 类似于我为我的博客所写的 [URL 缩短器](https://github.com/goldsborough/psag.cc)。我说的**微服务**指的是一个使用 HTTP，接受请求，访问数据库，返回一个响应（可能运送着 HTML），打包在一个 Docker 容器中，并可以放在云上的某个地方的这样一种应用。在这篇文章中，我会构建一个简单的聊天应用，允许你存储和检索消息。我会在过程中介绍一些相关的包（crate）。你可以[在 GitHub 上](http://github.com/goldsborough/microservice-rs)找到服务的完整代码。

## 使用 HTTP

我们需要让我们的 web 服务做的第一件事就是如何**使用 HTTP 协议**，也就是我们的应用（服务器）需要接收并解析 HTTP 请求，并返回 HTTP 响应。虽然有很多类似 [Flask](http://flask.pocoo.org) 或 [Django](https://www.djangoproject.com) 的高级框架能将这一切封装起来，我们还是选择使用稍微低级一点的 [hyper](https://hyper.rs) 库来处理 HTTP。这个库使用网络库 [tokio](https://tokio.rs) 和 [futures](https://github.com/alexcrichton/futures-rs)，让我们能创建一个干净的异步 web 服务器。此外，我们还会使用 [log](https://docs.rs/log/0.4.1/log/) 和 [env-logger](https://docs.rs/crate/env_logger/0.5.2) 两个 crate 来实现日志功能。

我们首先设置好 `Cargo.toml`，下载上述的 crate：

```plain
[package]
name = "microservice_rs"
version = "0.1.0"
authors = ["you <you@email>"]
[dependencies]
env_logger = "0.5.3"
futures = "0.1.17"
hyper = "0.11.13"
log = "0.4.1"
```

然后是实际的代码。Hyper 中有 `Service` 的概念。它是一个实现了 `Service` trait 的类型，有一个 `call` 函数，接收一个表示解析过的 HTTP 请求的 `hyper::Request` 对象作为参数。对于一个异步服务来说，这个函数必须返回一个 `Future`。下面是基本的样板文件，我们可以直接放在 `main.rs` 中：

```rust
extern crate hyper;
extern crate futures;

#[macro_use]
extern crate log;
extern crate env_logger;

use hyper::server::{Request, Response, Service};

use futures::future::Future;

struct Microservice;

impl Service for Microservice {
  type Request = Request;
  type Response = Response;
  type Error = hyper::Error;
  type Future = Box<Future<Item = Self::Response, Error = Self::Error>>;

  fn call(&self, request: Request) -> Self::Future {
    info!("Microservice received a request: {:?}", request);
    Box::new(futures::future::ok(Response::new()))
  }
}
```

注意到我们还需要为我们的服务声明一些基本的类型。我们装箱了 future 类型，因为 `futures::future::Future` 本身只是一个 trait，不能作为函数的返回值。在 `call()` 内部，我们目前返回一个最简单的有效值，一个包含空响应的装箱 future。

要启动服务器，我们绑定一个 IP 地址到 `hyper::server::Http` 实例，并调用它的 `run()` 方法：

```rust
fn main() {
  env_logger::init();
  let address = "127.0.0.1:8080".parse().unwrap();
  let server = hyper::server::Http::new()
    .bind(&address, || Ok(Microservice {}))
    .unwrap();
  info!("Running microservice at {}", address);
  server.run().unwrap();
}
```

有了上面的代码，hyper 会在 `localhost:8080` 开始监听 HTTP 请求，解析并将其转发到我们的 `Microservice` 类。请注意，每次有新请求到来，都会创建一个新的实例。我们现在可以启动服务器，用 curl 发来一些请求！我们在终端中启动服务器：

```plain
$ RUST_LOG="microservice=debug" cargo run
  Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
    Running `target/debug/microservice`
INFO 2018-01-21T23:35:05Z: microservice: Running microservice at 127.0.0.1:8080
```

然后在另一个终端中向它发送一些请求：

```bash
$ curl 'localhost:8080'
```

在第一个终端中，你应该能看到类似下面的输出

```bash
$ RUST_LOG="microservice=debug" cargo run
  Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
  Running `target/debug/microservice`
Running microservice at 127.0.0.1:8080
INFO 2018-01-21T23:35:05Z: microservice: Running microservice at 127.0.0.1:8080
INFO 2018-01-21T23:35:06Z: microservice: Microservice received a request: Request { method: Get, uri: "/", version: Http11, remote_addr: Some(V4(127.0.0.1:61667)), headers: {"Host": "localhost:8080", "User-Agent": "curl/7.54.0", "Accept": "*/*"} }
```

万岁！我们有了一个用 Rust 写的基础的服务器。注意到在上面的命令中，我将 `RUST_LOG="microservice=debug"` 添加到了 `cargo run` 中。由于 `env_logger` 会搜索这个特定的环境变量，我们通过这种方式控制它的行为。这个环境变量（`"microservice=debug"`）的第一部分指定了我们希望启动的日志的根模块，第二部分（`=` 后面的部分）指定了可见的最小日志级别。默认情况下，只有 `error!` 会被记录。

现在，让我们的服务器真正做点事情。因为我们在构建一个聊天应用，我们想要处理的两个请求类型是 `POST` 请求（有包含用户名和消息的表单数据）和 `GET` 请求（有可选的用来根据时间过滤的 `before` 和 `after` 参数）。

### 接收 `POST` 请求

我们先从写数据的这一部分开始。我们的接受发送到我们服务的根路径（`"/"`）的 `POST` 请求，并期望请求的表单数据中包含 `username` 和 `message` 字段。然后，这些信息会传入一个函数，写进数据库中。最终，我们返回一个响应。

首先重写 `call()` 方法：

```rust
fn call(&self, request: Request) -> Self::Future {
      match (request.method(), request.path()) {
        (&Post, "/") => {
          let future = request
            .body()
            .concat2()
            .and_then(parse_form)
            .and_then(write_to_db)
            .then(make_post_response);
          Box::new(future)
        }
        _ => Box::new(futures::future::ok(
          Response::new().with_status(StatusCode::NotFound),
        )),
      }
    }
```

我们通过匹配请求的方法和路径来区分不同的请求。在我们的例子中，请求的方法会是 `Post` 或 `Get`。我们服务的唯一有效路径是根路径 `"/"`。如果方法是 `&Post` 并且路径正确，我们就调用前面提到的函数。注意到我们可以优雅地使用组合函数来串联 future。组合子 `and_then` 会在 future 正确解析（不包含错误）的情况下，使用 future 中包含的值来调用一个函数。这个调用的函数也必须返回一个新的 future。这允许我们在多个处理阶段之间传递值，而不是**现场**计算出某个值。最终，我们使用组合子 `then`，无论 future 的状态如何都会执行回调函数。这样，它会得到一个 `Result`，而不是一个值。

这里是上面使用到的函数的内容：

```rust
struct NewMessage {
  username: String,
  message: String,
}

fn parse_form(form_chunk: Chunk) -> FutureResult<NewMessage, hyper::Error> {
  futures::future::ok(NewMessage {
    username: String::new(),
    message: String::new(),
  })
}

fn write_to_db(entry: NewMessage) -> FutureResult<i64, hyper::Error> {
  futures::future::ok(0)
}

fn make_post_response(
  result: Result<i64, hyper::Error>,
) -> FutureResult<hyper::Response, hyper::Error> {
  futures::future::ok(Response::new().with_status(StatusCode::NotFound))
}
```

我们的 `use` 语句也发生了一点变化：

```rust
use hyper::{Chunk, StatusCode};
use hyper::Method::{Get, Post};
use hyper::server::{Request, Response, Service};

use futures::Stream;
use futures::future::{Future, FutureResult};
```

让我们观察一下 `parse_form`。它接收一个 `Chunk`（消息体），从中解析出用户名和消息，同时恰当地处理错误。为了解析表单，我们使用 `url` 这个 crate（你需要使用 cargo 下载它）：

```rust
use std::collections::HashMap;
use std::io;

fn parse_form(form_chunk: Chunk) -> FutureResult<NewMessage, hyper::Error> {
  let mut form = url::form_urlencoded::parse(form_chunk.as_ref())
    .into_owned()
    .collect::<HashMap<String, String>>();

  if let Some(message) = form.remove("message") {
    let username = form.remove("username").unwrap_or(String::from("anonymous"));
    futures::future::ok(NewMessage {
      username: username,
      message: message,
    })
  } else {
    futures::future::err(hyper::Error::from(io::Error::new(
        io::ErrorKind::InvalidInput,
        "Missing field 'message",
    )))
  }
}
```

在将表单解析为一个 hashmap 之后，我们尝试从中移除 `message` 键。因为这是一个必填项，所以如果移除失败，就返回一个错误（error）。如果移除成功，我们接着获取 `username` 字段，如果这个字段不存在的话，就使用默认值 `"anonymous"`。最后，我们返回一个包含简单的 `NewMessage` 结构体的一个成功的 future。

我现在不会立刻讨论 `write_to_db` 函数。数据库的交互本身非常复杂，所以我会使用后续的一个章节来介绍这个函数，以及对应的从数据库中读取消息的函数。然而，注意到 `write_to_db` 在成功时返回 `i64` 类型的值，这是新消息提交到数据库中的时间戳。

先让我们看看我们如何将响应返回给任何向微服务发来的请求：

```rust
#[macro_use]
extern crate serde_json;

fn make_post_response(
  result: Result<i64, hyper::Error>,
) -> FutureResult<hyper::Response, hyper::Error> {
  match result {
    Ok(timestamp) => {
      let payload = json!({"timestamp": timestamp}).to_string();
      let response = Response::new()
        .with_header(ContentLength(payload.len() as u64))
        .with_header(ContentType::json())
        .with_body(payload);
      debug!("{:?}", response);
      futures::future::ok(response)
    }
    Err(error) => make_error_response(error.description()),
  }
}
```

我们在 `result` 上进行匹配，看看我们是否能成功写入数据库。如果成功，我们会创建一个 JSON 负载，构成我们返回的响应体。为此我使用了 `serde_json` 这个 crate，你应当将其添加到 `Cargo.toml` 中。当构建响应结构体时，我们需要设置正确的 HTTP 头。在这个例子中，这意味着将 `Content-Length` 头字段设置为响应体的长度，将 `Content-Type` 头字段设置为 `application/json`。

我已经重构了代码，将在错误情况下构建响应体的功能变成一个单独的函数 `make_error_response`，因为我们稍后会重新使用它：

```rust
fn make_error_response(error_message: &str) -> FutureResult<hyper::Response, hyper::Error> {
  let payload = json!({"error": error_message}).to_string();
  let response = Response::new()
    .with_status(StatusCode::InternalServerError)
    .with_header(ContentLength(payload.len() as u64))
    .with_header(ContentType::json())
    .with_body(payload);
  debug!("{:?}", response);
  futures::future::ok(response)
}
```

响应的构建与前一个函数相当相似，不过这次我们必须将响应的 HTTP 状态设置为 `StatusCode::InternalServerError`（状态 500）。默认的状态是 OK（200），因此我们之前不需要设置状态。

### 接收 `GET` 请求

下面，我们转向 `GET` 请求，这些请求发到服务器是要获取消息。我们允许请求有两个查询参数（query arguments）`before` 和 `after`。两个参数都是时间戳，用于根据消息的时间戳来约束会获取哪些消息。两个参数都是可选的。如果 `before` 和 `after` 参数都不存在，我们将只返回最后的消息。

下面是处理 `GET` 请求的 match 分支。它的逻辑比前面的代码略多。

```rust
(&Get, "/") => {
  let time_range = match request.query() {
    Some(query) => parse_query(query),
    None => Ok(TimeRange {
      before: None,
      after: None,
    }),
  };
  let response = match time_range {
    Ok(time_range) => make_get_response(query_db(time_range)),
    Err(error) => make_error_response(&error),
  };
  Box::new(response)
}
```

通过调用 `request.query()`，我们得到一个 `Option<&str>`，因为一个 URI 可能根本没有查询字符串。如果查询存在，我们调用 `parse_query`，它会解析查询参数，返回一个 `TimeRange` 结构体。它的定义是

```rust
struct TimeRange {
  before: Option<i64>,
  after: Option<i64>,
}
```

因为 `before` 和 `after` 参数都是可选的，我们将 `TimeRange` 结构体的两个字段都设置为 `Option`。此外，时间戳可能是无效的（例如不是数字），所以我们应当处理解析其值失败的情况。在这种情况下，`parse_query` 会返回一条错误消息，我们可以将其转发给我们之前写的 `make_error_response` 函数。如果解析成功，我们可以继续调用 `query_db`（为我们获取消息）和 `make_get_response`（创建合适的 `Response` 对象，并返回给客户端）。

为了解析查询字符串，我们再次使用之前的 `url::form_urlencoded` 函数，因为它的语法还是 `key=value&key=value`。然后我们尝试获取 `before` 和 `after` 两个值并将其转化为整数类型（即时间戳类型）：

```rust
fn parse_query(query: &str) -> Result<TimeRange, String> {
  let args = url::form_urlencoded::parse(&query.as_bytes())
    .into_owned()
    .collect::<HashMap<String, String>>();

  let before = args.get("before").map(|value| value.parse::<i64>());
  if let Some(ref result) = before {
    if let Err(ref error) = *result {
        return Err(format!("Error parsing 'before': {}", error));
    }
  }

  let after = args.get("after").map(|value| value.parse::<i64>());
  if let Some(ref result) = after {
    if let Err(ref error) = *result {
      return Err(format!("Error parsing 'after': {}", error));
    }
  }

  Ok(TimeRange {
    before: before.map(|b| b.unwrap()),
    after: after.map(|a| a.unwrap()),
  })
}
```

不幸的是，这里的代码有些笨重和重复，但在不增加复杂性的情况下很难让它变得更好了。本质上，我们尝试从表单中获取 `before` 和 `after` 两个字段。如果字段存在的话，再尝试将其解析为 `i64`。我希望能合并多个 `if let` 语句，所以我们可以写：

```rust
if let Some(ref result) = before && let Err(ref error) = *result {
  return Err(format!("Error parsing 'before': {}", error));
}
```

然而，现在 Rust 中不能这么写（可以通过打包在元组中的方法，在 `if let` 语句中写多个值，但是这些值不能像这里一样互相依赖）。

暂时跳过 `query_db` 的话，`make_get_response` 看起来非常简单：

```rust
fn make_get_response(
    messages: Option<Vec<Message>>,
) -> FutureResult<hyper::Response, hyper::Error> {
  let response = match messages {
    Some(messages) => {
      let body = render_page(messages);
      Response::new()
        .with_header(ContentLength(body.len() as u64))
        .with_body(body)
    }
    None => Response::new().with_status(StatusCode::InternalServerError),
  };
  debug!("{:?}", response);
  futures::future::ok(response)
}
```

如果 `messages` 这个 option 包含一个值，我们可以将这个消息传给 `render_page`，它会返回一个构成我们的响应体的 HTML 页面，其中在一个简单的 HTML 列表中显示消息。如果 option 为空，`query_db` 中出现了一个错误，我们会记录日志但不会暴露给用户，所以我们只是返回状态码为 500 的响应。我将在模板章节介绍 `render_page` 的实现。

## 连接到数据库

既然我们的服务中有写入和读取的路径，我们就需要将它们与数据库结合起来进行读写。Rust 有一个非常好用和流行的对象关系模型（ORM）库叫做 [diesel](http://diesel.rs)。这个库非常有趣和直观。将它添加到你的 `Cargo.toml` 中，并启用 `postgres` 功能，因为我们这份教程中要使用 [Postgres](https://postgresql.org) 数据库：

```plain
diesel = { version = "1.0.0", features = ["postgres"] }
```

请保证你已经在机器上安装了 Postgres，并且可以使用 `psql` 登录（作为基本的健壮性检查）。Diesel 还支持 MySQL 等其他 DBMS，你可以在学完本教程之后尝试它们。

让我们从为应用创建数据库模式开始。我们将它放入 `schemas/messages.sql` 中：

```sql
CREATE TABLE messages (
  id SERIAL PRIMARY KEY,
  username VARCHAR(128) NOT NULL,
  message TEXT NOT NULL,
  timestamp BIGINT NOT NULL DEFAULT EXTRACT('epoch' FROM CURRENT_TIMESTAMP)
)
```

表中的每一行都存储一条消息，包括单调递增的 ID、作者的用户名、消息文本和一个时间戳。上面所说的时间戳的默认值会为每个新的条目插入自 epoch 以来的当前秒数。由于 `id` 列也是自动递增的，我们最终只需要为每个新行插入用户名和消息。

现在我们需要将此表与 Diesel 集成。为此，我们需要通过 `cargo install diesel_cli` 安装 Diesel CLI。然后你就可以运行下面的命令：

```rust
$ export DATABASE_URL=postgres://<user>:<password>@localhost
$ diesel print-schema | tee src/schema.rs
table! {
  messages (id) {
    id -> Int4,
    username -> Varchar,
    message -> Text,
    timestamp -> Int8,
  }
}
```

其中 `<user>:<password>` 是你的数据库的用户名和密码。如果你的数据库没有密码，则只需要输入用户名。后一个命令打印出用 Rust 写的数据库表示，我们可以将它存储在 `src/schema.rs` 中。`table!` 宏来自于 Diesel。除了**模式**（schema）之外，Diesel 还要求我们写一个**模型**（model）。这个我们需要在 `src/models.rs` 中自己编写：

```rust
#[derive(Queryable, Serialize, Debug)]
pub struct Message {
  pub id: i32,
  pub username: String,
  pub message: String,
  pub timestamp: i64,
}
```

这个模型是我们在代码中与之交互的 Rust 结构体。为此，我们需要在主模块中添加一些声明：

```rust
#[macro_use]
extern crate serde_derive;
#[macro_use]
extern crate diesel;

mod schema;
mod models;
```

此时，我们已经准备好补充我们之前遗漏的函数 `write_to_db` 和 `query_db` 了。

### 写入数据库

我们从 `write_to_db` 开始。这个函数只是简单地将一个条目写入数据库，并返回它创建的时间戳：

```rust
use diesel::prelude::*;
use diesel::pg::PgConnection;

fn write_to_db(
  new_message: NewMessage,
  db_connection: &PgConnection,
) -> FutureResult<i64, hyper::Error> {
  use schema::messages;
  let timestamp = diesel::insert_into(messages::table)
    .values(&new_message)
    .returning(messages::timestamp)
    .get_result(db_connection);

  match timestamp {
    Ok(timestamp) => futures::future::ok(timestamp),
    Err(error) => {
      error!("Error writing to database: {}", error.description());
      futures::future::err(hyper::Error::from(
          io::Error::new(io::ErrorKind::Other, "service error"),
      ))
    }
  }
}
```

就这么简单！Diesel 提供了一个非常直观而且类型安全的查询接口，我们用它来：

* 指定我们要插入的表，
* 指定我们要插入的值（马上还会再提到），
* 指定我们想要返回的值（如果有的话），以及
* 调用 `get_result`，它将实际执行查询。

这返回给我们一个 `QueryResult<i64>` 对象，我们可以对它进行匹配，根据需要处理错误。上面应当会让你感到惊讶的两件事是（1）我们可以直接将 `NewMessage` 结构体传入 Diesel，以及（2）我们使用一个神奇的、之前不存在的 `db_connection` 参数。让我们解开这两个谜团！对于（1），上面我给你的代码实际上不会通过编译。为了让代码能编译，我们需要将 `NewMessage` 结构体移动到 `src/models.rs` 中，就放在 `Message` 结构体下面。代码看起来像这样：

```rust
use schema::messages;

#[derive(Queryable, Serialize, Debug)]
pub struct Message {
  pub id: i32,
  pub username: String,
  pub message: String,
  pub timestamp: i64,
}

#[derive(Insertable, Debug)]
#[table_name = "messages"]
pub struct NewMessage {
  pub username: String,
  pub message: String,
}
```

这样，Diesel 可以直接将我们的结构体中的字段与数据库中的列关联起来。多么简洁！注意到，为此，数据库中的表必须叫做 `messages`，如 `table_name` 属性所示。

对于第二个谜团，我们需要稍微修改代码，引入数据库连接的概念。在 `Service::call()` 中，将以下内容放在顶部：

```rust
fn call(&self, request: Request) -> Self::Future {
  let db_connection = match connect_to_db() {
    Some(connection) => connection,
    None => {
      return Box::new(futures::future::ok(
        Response::new().with_status(StatusCode::InternalServerError),
      ))
    }
  };
```

其中 `connect_to_db` 如下定义

```rust
use std::env;

const DEFAULT_DATABASE_URL: &'static str = "postgresql://postgres@localhost:5432";

fn connect_to_db() -> Option<PgConnection> {
  let database_url = env::var("DATABASE_URL").unwrap_or(String::from(DEFAULT_DATABASE_URL));
  match PgConnection::establish(&database_url) {
    Ok(connection) => Some(connection),
    Err(error) => {
      error!("Error connecting to database: {}", error.description());
      None
    }
  }
}
```

这个函数查找环境变量 `DATABASE_URL` 来确定 Postgres 数据库的 URL，否则使用预定义的常量。然后它尝试创建一个新的数据库连接，如果成功的话则返回。你还需要更新处理 `GET` 和 `POST` 的代码：

```rust
(&Post, "/") => {
  let future = request
    .body()
    .concat2()
    .and_then(parse_form)
    .and_then(move |new_message| write_to_db(new_message, &db_connection))
    .then(make_post_response);
  Box::new(future)
}
(&Get, "/") => {
  let time_range = match request.query() {
    Some(query) => parse_query(query),
    None => Ok(TimeRange {
      before: None,
      after: None,
    }),
  };
  let response = match time_range {
    Ok(time_range) => make_get_response(query_db(time_range, &db_connection)),
    Err(error) => make_error_response(&error),
  };
  Box::new(response)
}
```

使用这种方案，我们会在每次请求到来时创建一个新的数据库连接。取决于你的配置，这种方案可能没问题。不过，你可能还需要考虑使用 [r2d2](https://github.com/diesel-rs/r2d2-diesel) 建立一个**连接池**来保持一定数量的连接打开，并在你需要的时候给你一个连接。

### 查询数据库

我们现在可以将新的消息写入数据库 —— 这太棒了。下面，我们要弄清楚如何通过恰当地查询数据库来将它们再读出来。让我们实现 `query_db`：

```rust
fn query_db(time_range: TimeRange, db_connection: &PgConnection) -> Option<Vec<Message>> {
  use schema::messages;
  let TimeRange { before, after } = time_range;
  let query_result = match (before, after) {
    (Some(before), Some(after)) => {
      messages::table
        .filter(messages::timestamp.lt(before as i64))
        .filter(messages::timestamp.gt(after as i64))
        .load::<Message>(db_connection)
    }
    (Some(before), _) => {
      messages::table
        .filter(messages::timestamp.lt(before as i64))
        .load::<Message>(db_connection)
    }
    (_, Some(after)) => {
      messages::table
        .filter(messages::timestamp.gt(after as i64))
        .load::<Message>(db_connection)
    }
    _ => messages::table.load::<Message>(db_connection),
  };
  match query_result {
    Ok(result) => Some(result),
    Err(error) => {
      error!("Error querying DB: {}", error);
      None
    }
  }
}
```

不幸的是，这段代码有点复杂。这是因为 `before` 和 `after` 都是 `Option`，而且 Diesel 目前不支持逐步构建查询的简单方法。所以我们只能穷举 `before` 或 `after` 是 `Some` 或者 `None`，然后决定执行零个、一个或两个过滤器。不过，查询本身还是非常简单和直观的。由于 `where` 是 Rust 中的关键字，SQL 中的 `WHERE` 子句是使用 Diesel 中的 `filter` 方法实现的。像 `>` 或 `=` 这样的关系操作符则是模型结构体上的方法，如 `.gt()` 或 `.eq()`。

## 渲染 HTML 模板

我们很接近完成了！现在还剩下的就只有编写我们之前遗漏的 `render_page`。为此，我们要使用**模板**库。在 web 服务器的上下文中，模板是一种通过动态数据和控制流创建 HTML 页面的通用概念。其他语言中流行的模板库有 JavaScript 的 [Handlebars](http://handlebarsjs.com) 和 Python 的 [Jinja](http://jinja.pocoo.org)。虽然我在 [URL 缩短器](http://github.com/goldsborough/psag.cc) 项目中使用了 [Rust 上的 Handlebars](https://github.com/sunng87/handlebars-rust)，但是我不得不说 Rust 的模板库都[不怎么样](http://www.arewewebyet.org/topics/templating/)。就像 Rust 中的不少领域一样，没有像 Jinja 在 Python 中一样的“准标准库”. 这使得从中选择一个很难，因为你永远不知道它会不会在未来六个月内被弃用。

虽然如此，我们的教程中会使用一个叫做 [maud](http://maud.lambda.xyz) 的模板库。虽然 maud 不是真实世界应用的最具扩展性的选择，但它也很有趣和强大，允许我们直接用 Rust 写 HTML 模板。maud 还可以发挥 Rust 宏的力量，如果有的话。也就是说，maud 需要一个 Rust 的每日构建版本，以启动宏程序（procedural macro）功能。这个功能[看起来已经接近稳定了](https://github.com/rust-lang/rust/issues/38356)。

首先，在你的 Cargo.toml 中添加 `maud`：

```rust
[dependencies]
maud = "0.17.2"
```

然后，将下面的声明添加到你的 `main.rs` 的顶部：

```rust
#![feature(proc_macro)]
extern crate maud;
```

现在，你可以编写 `render_page` 了：

```bash
fn render_page(messages: Vec<Message>) -> String {
  (html! {
    head {
      title "microservice"
      style "body { font-family: monospace }"
    }
    body {
      ul {
        @for message in &messages {
          li {
            (message.username) " (" (message.timestamp) "): " (message.message)
          }
        }
      }
    }
  }).into_string()
}
```

**什么鬼**？这确实有点惊人。仔细思考一下，深呼吸。这是在用 Rust 宏来编写 HTML 页面。我勒个去。

确实如此！我们的微服务已经写完了，而且非常的**微**。我们来运行它：

```bash
$ DATABASE_URL="postgresql://goldsborough@localhost" RUST_LOG="microservice=debug" cargo run
Compiling microservice v0.1.0 (file:///Users/goldsborough/Documents/Rust/microservice)
  Finished dev [unoptimized + debuginfo] target(s) in 12.30 secs
  Running `target/debug/microservice`
INFO 2018-01-22T01:22:16Z: microservice: Running microservice at 127.0.0.1:8080
```

然后在另一个终端中：

```bash
$ curl -X POST -d 'username=peter&message=hi' 'localhost:8080'
{"timestamp":1516584255}
$ curl -X POST -d 'username=mike&message=hi2' 'localhost:8080'
{"timestamp":1516584282}
```

你应当立刻能看到调试日志：

```plain
...
DEBUG 2018-01-22T01:24:14Z: microservice: Request { method: Post, uri: "/", version: Http11, remote_addr: Some(V4(127.0.0.1:64869)), headers: {"Host": "localhost:8080", "User-Agent": "curl/7.54.0", "Accept": "*/*", "Content-Length": "25", "Content-Type": "application/x-www-form-urlencoded"} }
DEBUG 2018-01-22T01:24:14Z: microservice: Response { status: Ok, version: Http11, headers: {"Content-Length": "24", "Content-Type": "application/json"} }
...
```

现在，我们用 `GET` 来获取一些消息：

```bash
$ curl 'localhost:8080'
<head><title>microservice</title><style>body { font-family: monospace }</style></head><body><ul><li>peter (1516584255): hi</li><li>mike (1516584282): hi2</li></ul></body>
```

或者你在浏览器中打开 `http://localhost:8080`：

![screenshot](http://www.goldsborough.me/images/rust-webservice/index.png)

你也可以尝试在查询 URL 上添加 `?after=<timestamp>&before=<timestamp>`，并验证你确实只获得了指定时间范围内的消息。

## 使用 Docker 打包

我将简单谈谈如何将这个应用打包为一个 Docker 容器。这和 Rust 本身没有任何关系，但在此基础上了解相关的 Docker 容器是很有用的。

Rust 开发人员维护了两个官方的 Docker 镜像：一个是稳定版，一个是用于每日构建的 Rust。稳定版的 Rust 镜像就是 [`rust`](https://hub.docker.com/_/rust/)，每日构建版的镜像是 [`rust-lang/rust:nightly`](https://hub.docker.com/r/rustlang/rust/)。基于其中一个镜像扩展出我们的容器非常简单。我们想基于每日构建的镜像。`Dockerfile` 的内容应当像下面这样：

```Dockerfile
FROM rustlang/rust:nightly
MAINTAINER <your@email>

WORKDIR /var/www/microservice/
COPY . .

RUN rustc --version
RUN cargo install

CMD ["microservice"]
```

参考典型的微服务架构，我们在另一个 Docker 容器中运行 Postgres 数据库。如下编写 `Dockerfile-db`：

```Dockerfile
FROM postgres
MAINTAINER <your@email>

# Create the table on start-up
ADD schemas/messages.sql /docker-entrypoint-initdb.d/
```

然后用 [docker-compose.yaml](https://docs.docker.com/compose/) 将它们组合在一起：

```yaml
version: '2'
services:
  server:
    build:
      context: .
      dockerfile: docker/Dockerfile
    networks:
      - network
    ports:
        - "8080:80"
    environment:
      DATABASE_URL: postgresql://postgres:secret@db:5432
      RUST_BACKTRACE: 1
      RUST_LOG: microservice=debug
  db:
    build:
      context: .
      dockerfile: docker/Dockerfile-db
    restart: always
    networks:
      - network
    environment:
      POSTGRES_PASSWORD: secret

networks:
  network:
```

这个文件有点复杂，但写好这个以后，其他内容都简单了。注意到我将两个 Dockerfile 都放在了 `docker/` 目录下。现在，只需运行 `docker-compose up`：

```bash
$ docker-compose up
Recreating microservice_db_1 ...
Recreating microservice_server_1 ... done
Attaching to microservice_db_1, microservice_server_1
server_1  |  INFO 2018-01-22T01:38:57Z: microservice: Running microservice at 127.0.0.1:8080
db_1      | 2018-01-22 01:38:57.886 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
db_1      | 2018-01-22 01:38:57.886 UTC [1] LOG:  listening on IPv6 address "::", port 5432
db_1      | 2018-01-22 01:38:57.891 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
db_1      | 2018-01-22 01:38:57.917 UTC [20] LOG:  database system was shut down at 2018-01-22 00:10:07 UTC
db_1      | 2018-01-22 01:38:57.939 UTC [1] LOG:  database system is ready to accept connections
```

当然，你第一次运行时的输出可能会有所不同。但无论如何，我们的工作已经全部完成了。你可以将这些代码上传到一个 GitHub 仓库，然后放到（免费的）[AWS](https://aws.amazon.com/free/) 或 [Google Cloud](https://cloud.google.com/free/) 实例上，就可以从外部访问你的服务了。哇哦！

## 结语

上面的代码片段拼在一起大约有 270 行，这已经足够用 Rust 创建我们完整的微服务了。相比于例如在 Flask 中的等价代码，我们的代码可能也不是很少。然而，Rust 中还有更多的 web 框架，可以为你提供更多的抽象，例如 [Rocket](https://rocket.rs)。尽管如此，我相信跟随这个教程，使用 *Hyper* 稍微接近底层，会带给你关于如何利用 Rust 写一个安全且高性能的 web 服务的一些很好的思路。

我写这篇博文是想分享我在学习 Rust，以及使用我的知识写一个小型的 [URL 缩短器 web 服务](http://github.com/goldsborough/psag.cc) —— 我用这个 web 服务来缩短我的博客的 URL（如果你看一眼浏览器的 URL 栏，会发现它非常长）—— 时学到的东西。出于这个原因，我觉得我现在对 Rust 提供的特性有了深刻的认识。也知道了 Rust 的这些特性和现代 C++ 相比，哪些表达能力较强且更安全，而哪些表达能力较弱（但不会更不安全）。

我觉得 Rust 的生态系统可能还需要几年的时间来稳定，才能让稳定且维护良好的软件包完成主要的功能。尽管如此，前途还是很光明的。Facebook 已经在研究如何使用 Rust 构建托管其代码库的新 [Mercurial 服务器](https://www.theregister.co.uk/2016/10/18/facebook_mercurial_devs_forget_git/)。越来越多的人将 Rust 视为嵌入式编程的一个有趣选择。我会密切关注这个语言的发展，这意味着我已经在 Reddit 上订阅了 `r/Rust`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
