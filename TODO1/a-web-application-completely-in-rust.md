> * 原文地址：[A web application completely in Rust](https://medium.com/@saschagrunert/a-web-application-completely-in-rust-6f6bdb6c4471)
> * 原文作者：[Sascha Grunert](https://medium.com/@saschagrunert?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-web-application-completely-in-rust.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-web-application-completely-in-rust.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：

# Rust 开发完整的 Web 应用程序

我在软件架构方面最新的尝试是在 Rust 中使用尽可能少的模板文件来搭建一个真实的 web 应用程序。在这篇文章中我将和大家分享我的发现，来回答实际上[有多少网站](http://www.arewewebyet.org)在使用 Rust 这个问题。

这篇文章提到的项目[都可以在 GitHub 上找到](https://github.com/saschagrunert/webapp.rs/tree/rev1)，为了提高项目的可维护性，我将前端（客户端）和后端（服务端）放在了一个仓库中。这就需要 Cargo 为整个项目去分别编译有着不同依赖关系的前端和后端二进制文件。

> 请注意，目前这个项目正在快速迭代中可以在 `rev1` 这个分支上找到所有相关的代码。你可以点击[此处](https://medium.com/@saschagrunert/lessons-learned-on-writing-web-applications-completely-in-rust-2080d0990287)阅读这个本系列博客的第二部分。

这个应用是一个简单的身份验证示范，它允许你选一个用户名和密码（必须相同）来登录，当它们不同就会失败。验证成功后，将一个 [JSON Web Token (JWT)](https://en.wikipedia.org/wiki/JSON_Web_Token) 同时保存在客户端和服务端。通常服务端不需要存储 token，但是出于演示的目的，我们还是存储了。举个栗子，这个 token 可以被用来追踪实际登录的用户数量。整个项目可以通过一个 [Config.toml](https://github.com/saschagrunert/webapp.rs/blob/rev1/Config.toml) 文件来配置，比如去设置数据库连接凭证，或者服务器的 host 和 port。

```
[server]
ip = "127.0.0.1"
port = "30080"
tls = false

[log]
actix_web = "debug"
webapp = "trace"

[postgres]
host = "127.0.0.1"
username = "username"
password = "password"
database = "database"
```

webapp 默认的 Config.toml 文件

### 前端 —— 客户端

我决定使用 [yew](https://github.com/DenisKolodin/yew) 作为应用程序的客户端。Yew 是一个现代的 Rust 应用框架，受到 Elm、Angular 和 ReactJs 的启发，使用 [WebAssembly](https://en.wikipedia.org/wiki/WebAssembly)(Wasm) 来创建多线程的前端应用。该项目正处于高度活跃发展阶段，并没有发布那么多稳定版。

[cargo-web](https://github.com/koute/cargo-web) 工具是 yew 的直接依赖之一，能直接交叉编译出 Wasm。实际上，在 Rust 编译器中使用 Wasm 有三大主要目标：

*   _asmjs-unknown-emscripten _— 通过 Emscripten 使用 [asm.js](https://en.wikipedia.org/wiki/Asm.js) 
*   _wasm32-unknown-emscripten_ — 通过 Emscripten 使用 WebAssembly 
*   _wasm32-unknown-unknown _— 使用带有 Rust 原生 WebAssembly 后端的 WebAssembly 

![](https://cdn-images-1.medium.com/max/800/1*8q4reKhsoW7H-vxSzh-KJQ.jpeg)

我决定使用最后一个，需要一个 nightly Rust 编译器，事实上，演示 Rust 原生的 Wasm 可能是最好的。

> WebAssembly 目前是 Rust 最热门 🔥  的话题之一。关于编译 Rust 成为 Wasm 并将其集成到 nodejs（npm 打包），世界上有很多正在进行的工作。我决定采用直接的方式，不引入任何 JavaScript 依赖。

当启动 web 应用程序的前端的时候（在我的项目中用 `make frontend`）， cargo-web 将应用编译成 Wasm，并且将其与静态资源打包到一起。然后 cargo-web 启动一个本地 web 服务器，方便应用程序进行开发。

```
> make frontend
   Compiling webapp v0.3.0 (file:///home/sascha/webapp.rs)
    Finished release [optimized] target(s) in 11.86s
    Garbage collecting "app.wasm"...
    Processing "app.wasm"...
    Finished processing of "app.wasm"!

如果需要对任何其他文件启动服务，将其放入项目根目录下的“静态资源”目录；然后他们将和应用一起被服务。
同样可以把静态资源目录放到 ‘src’ 目录中。

你的应用在'/app.js'上启动，如果有任何代码上的变动，都会触发自动重建。

你可以通过 `http://0.0.0.0:8000` 访问 web 服务器

```

yew 有些很好用的功能，就像可复用的组件架构，可以很轻松的将我的应用程序分为三个主要的组件：

*   [_根组件_](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/components/root.rs): 直接挂载在网页的 `<body>` 标签，决定接下来加载哪一个子组件。如果在进入页面的时候发现了 JWT，那么将尝试和后端通信来续订这个 token，如果续订失败，则路由到 _登录组件_ 。
*   [_登录组件_](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/components/login.rs): _根组件_ 的一个子组件包含登录表单字段。它同样和后端进行基本的用户名和密码的身份验证，并在成功后将 JWT 保存到 cookie 中。成功验证身份后路由到 _内容组件_ 。

![](https://cdn-images-1.medium.com/max/800/1*0h9AZ2uIwzbdDvUTsna9Lw.png)

登录组件

*   [_内容组件_](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/components/content.rs):  _根组件的_ 的另一个子组件，包括一个主页面内容（目前只有一个头部和一个登出按钮）。它可以通过 _根组件_ 访问（如果有效的 session token 已经可用）或者通过 _登录组件_ （成功认证）访问。当用户按下登出按钮后，这个组件将会和后端进行通信。

![](https://cdn-images-1.medium.com/max/800/1*8ryczcVc5JrfrkMkBgFcuw.png)

内容组件

*   _路由组件_: 保存包含内容的组件之间的所有可能路由。同样包含应用的一个初始的 “loading” 状态和一个 “error” 状态，并直接附加到 _根组件_ 上。

服务是 yew 的下一个关键概念之一。它允许组件间重用相同的逻辑，比如日志记录或者 [cookie 处理](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/services/cookie.rs)。在组件的服务是无状态的，并且服务会在组件初始化的时候被创建。除了服务， yew 还包含了代理（Agent）的概念。代理可以用来在组件间共享数据，提供一个全局的应用状态，就像路由代理所需要的那样。为了在所有的组件之间完成示例程序的路由，实现了一套[自定义的路由代理和服务](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/services/router.rs)。Yew 实际上没有独立的路由，[但他们的示例](https://github.com/DenisKolodin/yew/tree/master/examples/routing)提供了一个支持所有类型 URL 修改的参考实现。

> 太让人惊讶了，yew 使用 [Web Workers API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API) 在独立的线程中生成代理，并使用附加到线程的本地的任务调度程序来执行并发任务。这使得使用 Rust 在浏览器中编写高并发应用成为可能。

每个组件都实现了[自己的 \`Renderable\` 特性](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/components/root.rs#L123)，这让我们可以直接通过 `[html!{}](https://github.com/DenisKolodin/yew#jsx-like-templates-with-html-macro)` 宏在 rust 源码中包含 HTML。这非常棒，并且确保了使用编辑器内置的 borrow checker 进行检查！

```
impl Renderable<LoginComponent> for LoginComponent {
    fn view(&self) -> Html<Self> {
        html! {
            <div class="uk-card uk-card-default uk-card-body uk-width-1-3@s uk-position-center",>
                <form onsubmit="return false",>
                    <fieldset class="uk-fieldset",>
                        <legend class="uk-legend",>{"Authentication"}</legend>
                        <div class="uk-margin",>
                            <input class="uk-input",
                                   placeholder="Username",
                                   value=&self.username,
                                   oninput=|e| Message::UpdateUsername(e.value), />
                        </div>
                        <div class="uk-margin",>
                            <input class="uk-input",
                                   type="password",
                                   placeholder="Password",
                                   value=&self.password,
                                   oninput=|e| Message::UpdatePassword(e.value), />
                        </div>
                        <button class="uk-button uk-button-default",
                                type="submit",
                                disabled=self.button_disabled,
                                onclick=|_| Message::LoginRequest,>{"Login"}</button>
                        <span class="uk-margin-small-left uk-text-warning uk-text-right",>
                            {&self.error}
                        </span>
                    </fieldset>
                </form>
            </div>
        }
    }
}
```

登录组件 `Renderable` 的实现 

每个客户端从前端到后盾的通信（反之亦然）通过 [WebSocket](https://en.wikipedia.org/wiki/WebSocket) 连接来实现。WebSocket 的好处是可以使用二进制信息，并且如果需要的话，服务端同时可以向客户端推送通知。Yew 已经发行了一个 WebSocket 服务，但我还是要为示例程序[创建一个自定义的版本](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/services/websocket.rs)，主要是因为要在服务中的延迟初始化连接。如果在组件初始化的时候创建 WebSocket 服务，那么我们就得去追踪多个套接字连接。

![](https://cdn-images-1.medium.com/max/800/1*w3kQzk007POxE3PqjECqXQ.png)

出于速度和紧凑的考量。我决定使用一个二进制协议 —— [Cap’n Proto](https://capnproto.org)，作为应用数据通信层（而不是[JSON](https://www.json.org)、[MessagePack](https://msgpack.org) 或者 [CBOR](http://cbor.io)这些）。值得一提的是，我没有使用 Cap’n Proto 的[RPC 接口协议](https://capnproto.org/rpc.html)，因为其 Rust 实现不能编译成 WebAssembly（由于[tokio-rs](https://github.com/tokio-rs/tokio)’ unix 依赖项）。这使得正确区分请求和响应类型稍有困难，但是[结构清晰的 API](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/protocol.capnp) 可以解决这个问题：

```
@0x998efb67a0d7453f;

struct Request {
    union {
        login :union {
            credentials :group {
                username @0 :Text;
                password @1 :Text;
            }
            token @2 :Text;
        }
        logout @3 :Text; # The session token
    }
}

struct Response {
    union {
        login :union {
            token @0 :Text;
            error @1 :Text;
        }
        logout: union {
            success @2 :Void;
            error @3 :Text;
        }
    }
}
```

应用程序的 Cap’n Proto 协议定义

你可以看到我们这里有两个不同的登录请求变体：一个是 _登录组件_ （用户名和密码的凭证请求），另一个是 _根组件_ （已经存在的 token 刷新请求）。所有需要的协议实现都包含在[协议服务](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/services/protocol.rs)中，这使得它在整个前端中可以被轻松复用。

![](https://cdn-images-1.medium.com/max/800/1*Ngm7Avt7AM7ITqjlPcfARw.jpeg)

UIkit - 用于开发快速且功能强大的Web界面的轻量级模块化前端框架

前端的用户界面由 [UIkit](https://getuikit.com) 提供支持，其 `3.0.0` 版将在不久的将来发布。自定义的 [build.rs](https://github.com/saschagrunert/webapp.rs/blob/rev1/build.rs) 脚本会自动下载 UIkit 所需要的全部依赖项并编译整个样式表。这就意味着我们可以在[单独的一个 style.scss 文件](https://github.com/saschagrunert/webapp.rs/blob/rev1/src/frontend/style.scss)中插入自定义的样式，然后在应用程序中使用。安排！（PS: 原文是 `Neat！`）

#### 前端测试

在我的看来，测试可能会存在一些小问题。测试独立的服务很容易，但是 yew 还没有提供一个很优雅的方式去测试单个组件或者代理。目前在 Rust 内部也不可能对前端进行整合以及端到端测试。或许可以使用 [Cypress](https://www.cypress.io) 或者 [Protractor](http://www.protractortest.org/#/) 这类项目，但是这会引入太多的 JavaScript/TypeScript 样板文件，所以我跳过了这个选项。

> 但是呢，或许这是一个新项目的好起点：用 Rust 编写一个端到端测试框架！你怎么看？

### 后端 —— 服务端

我选择的后端框架是 [actix-web](https://github.com/actix/actix-web): 一个小而务实且极其快速的 Rust [actor 框架](https://en.wikipedia.org/wiki/Actor_model)。它支持所有需要的技术，比如 WebSockets、TLS 和 [HTTP/2.0](https://actix.rs/docs/http2/). Actix-web 支持不同的处理程序和资源，但在示例程序中只用到了两个组要的路由：

*   `**/ws**`: 主要的 websocket 通信资源。
*   `**/**`: 路由到静态部署的前端应用的主程序处理句柄（handler）

默认情况下，actix-web 会生成与本地计算机逻辑CPU数量一样多的 works（PS: 翻译参考了[Actix中文文档中服务器一节的多线程部分](https://actix-cn.github.io/document/server.html#%E5%A4%9A%E7%BA%BF%E7%A8%8B)）。这就意味着必须在线程之间安全的共享可能的应用程序状态，但这对于 Rust 无所畏惧的并发模式来说完全不是问题。尽管如此，整个后端应该是无状态的，因为可能会在云端（比如 [Kubernetes](https://kubernetes.io)）上并行部署多个副本。所以应用程序状态应该在单个 [Docker](https://www.docker.com) 容器示例中的后端之外。

![](https://cdn-images-1.medium.com/max/800/1*vbIdg_EDv0Jakk7iGByH-Q.png)

我决定使用 [PostgreSQL](https://www.postgresql.org) 作为主要的数据存储。为什么呢？因为令人敬畏的 [Diesel 项目](http://diesel.rs) 已经支持 PostgreSQL，并且为它提供了一个安全、可拓展的对象关系映射（ORM）和查询构建器（query builder）。这很棒，因为 actix-web 已经支持了 Diesel。这样的话，就可以自定义惯用的 Rust 域特定语言来创建、读取、更新或者删除（CRUD）数据库中的会话，如下所示：

```
impl Handler<UpdateSession> for DatabaseExecutor {
    type Result = Result<Session, Error>;

    fn handle(&mut self, msg: UpdateSession, _: &mut Self::Context) -> Self::Result {
        // Update the session
        debug!("Updating session: {}", msg.old_id);
        update(sessions.filter(id.eq(&msg.old_id)))
            .set(id.eq(&msg.new_id))
            .get_result::<Session>(&self.0.get()?)
            .map_err(|_| ServerError::UpdateToken.into())
    }
}
```

由 Diesel.rs 提供的 actix-web 的 UpdateSession 处理程序

至于 actix-web 和 Diesel 之间的连接的处理，使用 [r2d2](https://github.com/sfackler/r2d2) 项目。这就意味着我们（应用程序和它的 works）具有共享的应用程序状态，该状态将多个连接保存到数据库作为单个连接池。这使得整个后端非常灵活，很容易大规模拓展。[这里](https://github.com/saschagrunert/webapp.rs/blob/master/src/backend/server.rs#L44-L82)可以找到整个服务器示例。

#### 后端测试

后端的[集成测试](https://github.com/saschagrunert/webapp.rs/blob/rev1/tests/backend.rs)通过设置一个测试用例并连接到已经运行的数据库来完成。然后可以使用标准的 WebSocket 客户端（我使用 [tungstenite](https://github.com/snapview/tungstenite-rs)）将与协议相关的 Cap'n Proto 数据发送到服务器并验证预期结果。这很好用！我没有用 [actix-web 特定的测试服务器](https://actix.rs/actix-web/actix_web/test/index.html)，因为设置一个真正的服务器并费不了多少事儿。后端其他部分的单元测试工作像预期一样简单，没有任何棘手的陷阱。

### 部署

使用 Docker 镜像可以很轻松地部署应用程序。

![](https://cdn-images-1.medium.com/max/800/1*d-HKujYLR5Q2QED4ybEiPw.png)

Makefile 命令 `make deploy` 创建一个名为 `webapp` 的 Docker 镜像，其中包含静态链接（staticlly linked）的后端可执行文件、当前的 `Config.toml`、TLS 证书和前端的静态内容。在 Rust 中构建一个完全的静态链接的可执行文件是通过修改的 [rust-musl-builder](https://hub.docker.com/r/ekidd/rust-musl-builder/) 镜像变体实现的。生成的 webapp 可以使用 `make run` 进行测试，这个命令可以启动容器和主机网络。PostgreSQL 容器现在应该并行运行。总的来说，整体部署不应该是这个工程的重要部分，应该足够灵活来适应将来的变动。

### 总结

总结一下，应用程序的基本依赖栈如下所示：

![](https://cdn-images-1.medium.com/max/800/1*jkm-cPEWdyZeHjAyqNfHHw.png)

前端和后端之间唯一的共享组件是 Cap'n Proto 生成的 Rust 源，它需要本地安装的 Cap’n Proto 编译器。

#### 那么, 我们的 web 完成了吗（用于生产环境）？

这是一个大问题，这是我的个人观点：

> 后端部分我倾向于说“是”。因为 Rust 有包含非常成熟的 [HTTP 技术栈](http://www.arewewebyet.org/topics/stack/)的各种各样的[框架](http://www.arewewebyet.org/topics/frameworks/)，类似 actix-web。用于快速构建 API 和后端服务。

> 前端部分的话，由于 WebAssembly 的炒作，目前还有很多正在进行中的工作。但是项目需要和后端具有相同的成熟度，特别是在稳定的 API 和测试的可行性方面。所以前端应该是“不”。但是我们的方向很好。

![](https://cdn-images-1.medium.com/max/800/1*BIUlQD822_EKKLv4jtElWg.png)

> 非常感谢你能读到这里。 ❤

我将继续完善我的示例程序，来不断探索 Rust 和 Web 应用的连接点。持续 rusting！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
