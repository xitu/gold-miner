> * 原文地址：[Single Page Applications using Rust](http://www.sheshbabu.com/posts/rust-wasm-yew-single-page-application/)
> * 原文作者：[Shesh](http://www.sheshbabu.com/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/rust-wasm-yew-single-page-application.md](https://github.com/xitu/gold-miner/blob/master/article/2020/rust-wasm-yew-single-page-application.md)
> * 译者：[Derek](https://github.com/derekdick)
> * 校对者：

# 使用 Rust 构建单页应用

WebAssembly (wasm) 使得各种除了 JavaScript 以外的语言编写的代码能够在浏览器中运行。你可能还没有注意到，所有的主流浏览器都支持 wasm 并且 [全球超过 90% 的用户](https://caniuse.com/#feat=wasm) 使用的浏览器都可以运行 wasm。

既然 Rust 能够编译成 wasm，那么是不是有可能只用 Rust 而不使用任何一行 JavaScript 代码来构建 SPA （Single Page Applications，单页应用）呢？简短的答案是**肯定的**！请继续阅读以了解更多信息，或者如果你无法抑制激动的心情，请访问 [演示站点](https://rustmart-yew.netlify.app)。

我们将搭建一个叫作「RustMart」的简单的电子商务网站，包括两个页面：

- 主页 —— 列出所有顾客可以添加到购物车的产品
- 产品详情页 —— 单击产品卡片时展示该产品的详细信息

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-1.png)

我这里使用这个例子是因为它测试了构建现代 SPA 所需要的最小功能集合：

- 在多个页面之间导航而无需重新加载页面
- 发起网络请求而无需重新加载页面
- 能够跨多个页面重用 UI 组件
- 更新 UI 层次结构不同层中的组件

## 建立

如果您尚未安装 Rust，请点击此 [链接](https://www.rust-lang.org/tools/install) 进行安装。

安装这些 Rust 工具：

```shell
$ cargo install wasm-pack          # 将 Rust 编译为 wasm 并生成 JS 互操作代码
$ cargo install cargo-make         # Task runner
$ cargo install simple-http-server # 提供 assets 的简单服务器
```

创建一个新项目：

```shell
$ cargo new --lib rustmart && cd rustmart
```

我们将使用 [`Yew`](https://yew.rs) 库来构建 UI 组件。让我们将这个库和 wasm 的依赖添加到： `Cargo.toml` 中：

```toml
[lib]
crate-type = ["cdylib", "rlib"]

[dependencies]
yew = "0.17"
wasm-bindgen = "0.2"
```

新建文件 `Makefile.toml` 并添加如下代码：

```toml
[tasks.build]
command = "wasm-pack"
args = ["build", "--dev", "--target", "web", "--out-name", "wasm", "--out-dir", "./static"]
watch = { ignore_pattern = "static/*" }

[tasks.serve]
command = "simple-http-server"
args = ["-i", "./static/", "-p", "3000", "--nocache", "--try-file", "./static/index.html"]
```

开始构建任务：

```shell
$ cargo make build
```

如果您不熟悉 Rust，我已经写了一些 [初学者指南](http://www.sheshbabu.com/tags/Rust-Beginners/)，可以帮助您更好地阅读本文。

## Hello World

让我们从简单的 「hello world」例子开始：

创建 `static/index.html` 并添加如下代码：

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>RustMart</title>
    <script type="module">
      import init from "/wasm.js";
      init();
    </script>
    <link rel="shortcut icon" href="#" />
  </head>
  <body></body>
</html>
```

然后将这些添加到 `src/lib.rs` 中：

```rust
// src/lib.rs
use wasm_bindgen::prelude::*;
use yew::prelude::*;

struct Hello {}

impl Component for Hello {
    type Message = ();
    type Properties = ();

    fn create(_: Self::Properties, _: ComponentLink<Self>) -> Self {
        Self {}
    }

    fn update(&mut self, _: Self::Message) -> ShouldRender {
        true
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        true
    }

    fn view(&self) -> Html {
        html! { <span>{"Hello World!"}</span> }
    }
}

#[wasm_bindgen(start)]
pub fn run_app() {
    App::<Hello>::new().mount_to_body();
}
```

发生了很多，但是你可以看到我们正在创建一个叫 「Hello」的新组件，它将 `<span>Hello World!</span>` 渲染进 DOM。我们稍后会进一步了解 Yew 组件。

在新终端中启动服务任务，然后在浏览器中加载 `http://localhost:3000`

```shell
$ cargo make serve
```

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-1.png)

成功了！这只是「hello world」，但这完全用 Rust 编写。

在继续进行之前，让我们了解一下组件和其他 SPA 概念。

## 用组件思考

使用组件来构建 UI 和单向数据流是前端世界的一个范式转变。这是我们处理 UI 方式的一个巨大进步，一旦习惯了，就很难回到命令式 DOM 操作。

在像 React、Vue、Yew、Flutter 等等的库中，一个 `Component` （组件）有这些特性：

- 能够组成更大的组件
- `Props` —— 从该组件向其子组件传递数据和回调
- `State` —— 操作该组件本地的状态
- `AppState` —— 操作全局状态
- 监听生命周期事件，例如「Instantiated」、「Mounted in DOM」等等
- 执行次要功能，例如获取远程数据、操作 localstorage 等等

当下列情况之一发生时，组件会被更新（重新渲染）：

- 父组件被重新渲染
- `Props` 改变
- `State` 改变
- `AppState` 改变

所以，我们更新数据（Props, State, AppState）然后 UI 会基于此数据被更新，而不是在用户交互、网络请求等等发生时命令式地更新 UI。这就是通常我们说的「UI 是状态的函数」。

不同的库在具体的细节上会有所不同，但这应该能够给你一个总体的思想。如果你是新手，这种思维方式可能需要一段时间才能「点击」并习惯。

## 主页

我们先构建主页。我们先将主页构建为一个整体的组件，然后再把它分解成更小的可重用组件。 

让我们创建以下文件：

```rust
// src/pages/home.rs
use yew::prelude::*;

pub struct Home {}

impl Component for Home {
    type Message = ();
    type Properties = ();

    fn create(_: Self::Properties, _: ComponentLink<Self>) -> Self {
        Self {}
    }

    fn update(&mut self, _: Self::Message) -> ShouldRender {
        true
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        true
    }

    fn view(&self) -> Html {
        html! { <span>{"Home Sweet Home!"}</span> }
    }
}
```

```rust
// src/pages/mod.rs
mod home;

pub use home::Home;
```

让我们更新 `src/lib.rs` 来导入主页组件：

```diff
  // src/lib.rs
+ mod pages;

+ use pages::Home;
  use wasm_bindgen::prelude::*;
  use yew::prelude::*;

- struct Hello {}

- impl Component for Hello {
-     type Message = ();
-     type Properties = ();

-     fn create(_: Self::Properties, _: ComponentLink<Self>) -> Self {
-         Self {}
-     }

-     fn update(&mut self, _: Self::Message) -> ShouldRender {
-         true
-     }

-     fn change(&mut self, _: Self::Properties) -> ShouldRender {
-         true
-     }

-     fn view(&self) -> Html {
-         html! { <span>{"Hello World!"}</span> }
-     }
- }

  #[wasm_bindgen(start)]
  pub fn run_app() {
-   App::<Hello>::new().mount_to_body();
+   App::<Home>::new().mount_to_body();
  }
```

现在，你应该看到「Home Sweet Home!」而不是「Hello World!」渲染在你的浏览器中。

让我们开始设计这个组件的 `State`（状态）：

- 我们需要存储一个从服务器获取的产品列表
- 存储用户已经添加到到购物车的产品

我们创建一个简单的结构体来存储 `Product` 的详细信息：

```rust
struct Product {
    name: String,
    description: String,
    image: String,
    price: f64,
}
```

我们接着创建一个新的结构体 `State`，它包含 `products` 字段来存储从服务器获取的产品：

```rust
struct State {
    products: Vec<Product>,
}
```

这是主页组件中更改的完整列表：

```diff
  use yew::prelude::*;

+ struct Product {
+     id: i32,
+     name: String,
+     description: String,
+     image: String,
+     price: f64,
+ }

+ struct State {
+     products: Vec<Product>,
+ }

- pub struct Home {}
+ pub struct Home {
+     state: State,
+ }

  impl Component for Home {
      type Message = ();
      type Properties = ();

      fn create(_: Self::Properties, _: ComponentLink<Self>) -> Self {
+       let products: Vec<Product> = vec![
+           Product {
+               id: 1,
+               name: "Apple".to_string(),
+               description: "An apple a day keeps the doctor away".to_string(),
+               image: "/products/apple.png".to_string(),
+               price: 3.65,
+           },
+           Product {
+               id: 2,
+               name: "Banana".to_string(),
+               description: "An old banana leaf was once young and green".to_string(),
+               image: "/products/banana.png".to_string(),
+               price: 7.99,
+           },
+       ];

-       Self {}
+       Self {
+           state: State {
+               products,
+           },
+       }
      }

      fn update(&mut self, _: Self::Message) -> ShouldRender {
          true
      }

      fn change(&mut self, _: Self::Properties) -> ShouldRender {
          true
      }

      fn view(&self) -> Html {
+        let products: Vec<Html> = self
+            .state
+            .products
+            .iter()
+            .map(|product: &Product| {
+                html! {
+                  <div>
+                    <img src={&product.image}/>
+                    <div>{&product.name}</div>
+                    <div>{"$"}{&product.price}</div>
+                  </div>
+                }
+            })
+            .collect();
+
+        html! { <span>{products}</span> }
-        html! { <span>{"Home!"}</span> }
      }
  }
```

当组件被创建时， `create` 生命周期方法会被调用，这就是我们设置初始状态的地方。目前，我们已经创建了一个产品模拟列表并将其赋值到状态中的 `products` 字段作为初始状态。稍后，我们将使用网络请求获取这个列表。

当组件被渲染时， `view` 生命周期方法会被调用。这就是我们遍历状态中的 `products` 字段来生成产品卡片的地方。如果你熟悉 React，这和 `render` 方法是一样的，而且 `html!` 宏和 `JSX` 是类似的。

将一些随机图片存储为 `static/products/apple.png` 和 `static/products/banana.png` 然后你将得到如下 UI：

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-2.png)

让我们来实现「添加到购物车」的功能：

- 我们在一个新的叫作 `cart_products` 的字段记录所有被添加到购物车的产品
- 我们为每一个产品渲染一个「添加到购物车」的按钮
- 增加当「添加到购物车」按钮被单击时更新 `cart_products` 状态的逻辑

```diff
  use yew::prelude::*;

+ #[derive(Clone)]
  struct Product {
      id: i32,
      name: String,
      description: String,
      image: String,
      price: f64,
  }

+ struct CartProduct {
+     product: Product,
+     quantity: i32,
+ }

  struct State {
      products: Vec<Product>,
+     cart_products: Vec<CartProduct>,
  }

  pub struct Home {
      state: State,
+     link: ComponentLink<Self>,
  }

+ pub enum Msg {
+     AddToCart(i32),
+ }

  impl Component for Home {
-   type Message = ();
+   type Message = Msg;
    type Properties = ();

-   fn create(_: Self::Properties, _: ComponentLink<Self>) -> Self {
+   fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
        let products: Vec<Product> = vec![
            Product {
                id: 1,
                name: "Apple".to_string(),
                description: "An apple a day keeps the doctor away".to_string(),
                image: "/products/apple.png".to_string(),
                price: 3.65,
            },
            Product {
                id: 2,
                name: "Banana".to_string(),
                description: "An old banana leaf was once young and green".to_string(),
                image: "/products/banana.png".to_string(),
                price: 7.99,
            },
        ];
+       let cart_products = vec![];

        Self {
            state: State {
                products,
+               cart_products,
            },
+           link,
        }
    }

-   fn update(&mut self, _: Self::Message) -> ShouldRender {
+   fn update(&mut self, message: Self::Message) -> ShouldRender {
+       match message {
+           Msg::AddToCart(product_id) => {
+               let product = self
+                   .state
+                   .products
+                   .iter()
+                   .find(|p: &&Product| p.id == product_id)
+                   .unwrap();
+               let cart_product = self
+                   .state
+                   .cart_products
+                   .iter_mut()
+                   .find(|cp: &&mut CartProduct| cp.product.id == product_id);
+
+               if let Some(cp) = cart_product {
+                   cp.quantity += 1;
+               } else {
+                   self.state.cart_products.push(CartProduct {
+                       product: product.clone(),
+                       quantity: 1,
+                   })
+               }
+               true
+           }
+       }
-       true
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        true
    }

    fn view(&self) -> Html {
        let products: Vec<Html> = self
            .state
            .products
            .iter()
            .map(|product: &Product| {
+              let product_id = product.id;
                html! {
                  <div>
                    <img src={&product.image}/>
                    <div>{&product.name}</div>
                    <div>{"$"}{&product.price}</div>
+                   <button onclick=self.link.callback(move |_| Msg::AddToCart(product_id))>{"Add To Cart"}</button>
                  </div>
                }
            })
            .collect();

+       let cart_value = self
+           .state
+           .cart_products
+           .iter()
+           .fold(0.0, |acc, cp| acc + (cp.quantity as f64 * cp.product.price));

-       html! { <span>{products}</span> }
+       html! {
+         <div>
+           <span>{format!("Cart Value: {:.2}", cart_value)}</span>
+           <span>{products}</span>
+         </div>
+       }
      }
  }

```

- `clone` —— 我们派生 `Product` 结构体中的 [`Clone`](https://doc.rust-lang.org/std/clone/trait.Clone.html) trait，因此只要用户将产品添加到购物车，我们就可以将克隆的 `Product` 存储到 `CartProduct` 中。
- `update` —— 此方法就是更新组件 `State` 或执行次要功能（比如网络请求）的逻辑所在。它使用包含组件支持所有动作的 `Message` 枚举来调用。当我们从这个方法返回 `true` 时，该组件会被重新渲染。在上面的代码中，当用户单击「添加到购物车」按钮时，我们发送一个 `Msg::AddToCart` 消息到 `update`。在 `update` 内部，这会将产品添加到 `cart_product` 中（如果不存在）或增加其数量。
- `link` —— 这使得我们注册可以触发我们 `update` 生命周期方法的回调。

如果你之前用过 [Redux](https://redux.js.org)，`update` 类似于 [`Reducer`](https://redux.js.org/basics/reducers) (对于状态更新) 和 [`Action Creator`](https://redux.js.org/basics/actions#action-creators) (对于次要功能)，`Message` 类似于 [`Action`](https://redux.js.org/basics/actions)，`link` 类似于 [`Dispatch`](https://redux.js.org/basics/store#dispatching-actions)。

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-2.png)

UI 如下所示，试试单击「添加到购物车」按钮然后看看「购物车价值」的变化：

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-3.png)

## Fetching Data

We'll move the product data from the `create` function to `static/products/products.json` and query it using the [`fetch`](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) api.

```json
[
  {
    "id": 1,
    "name": "Apple",
    "description": "An apple a day keeps the doctor away",
    "image": "/products/apple.png",
    "price": 3.65
  },
  {
    "id": 2,
    "name": "Banana",
    "description": "An old banana leaf was once young and green",
    "image": "/products/banana.png",
    "price": 7.99
  }
]
```

Yew exposes common browser apis like fetch, localstorage etc through something called ["services"](https://docs.rs/yew/0.17.2/yew/services/index.html). We can use the `FetchService` to make network requests. It requires `anyhow` and `serde` crates, let's install them:

```diff
  [package]
  name = "rustmart"
  version = "0.1.0"
  authors = ["sheshbabu <sheshbabu@gmail.com>"]
  edition = "2018"

  [lib]
  crate-type = ["cdylib", "rlib"]

  [dependencies]
  yew = "0.17"
  wasm-bindgen = "0.2"
+ anyhow = "1.0.32"
+ serde = { version = "1.0", features = ["derive"] }
```

Let's extract the `Product` and `CartProduct` to `src/types.rs` so we can share it across multiple files:

```rust
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Clone, Debug)]
pub struct Product {
    pub id: i32,
    pub name: String,
    pub description: String,
    pub image: String,
    pub price: f64,
}

#[derive(Clone, Debug)]
pub struct CartProduct {
    pub product: Product,
    pub quantity: i32,
}

```

We've made both structs and their fields public, and have derived the `Deserialize` and `Serialize` traits.

We'll use the [API module pattern](http://www.sheshbabu.com/posts/organizing-http-requests-using-api-module-pattern/) and create a separate module called `src/api.rs` to hold our fetch logic:

```rust
// src/api.rs
use crate::types::Product;
use anyhow::Error;
use yew::callback::Callback;
use yew::format::{Json, Nothing};
use yew::services::fetch::{FetchService, FetchTask, Request, Response};

pub type FetchResponse<T> = Response<Json<Result<T, Error>>>;
type FetchCallback<T> = Callback<FetchResponse<T>>;

pub fn get_products(callback: FetchCallback<Vec<Product>>) -> FetchTask {
    let req = Request::get("/products/products.json")
        .body(Nothing)
        .unwrap();

    FetchService::fetch(req, callback).unwrap()
}
```

The `FetchService` api is a bit awkward - it takes in a request object and callback as arguments and returns something called a "FetchTask". One surprising gotcha here is that the network request gets aborted if this "FetchTask" is dropped. So we return this and store it in our component.

Let's update `lib.rs` to add these new modules into the [module tree](http://www.sheshbabu.com/posts/rust-module-system/):

```diff
  // src/lib.rs
+ mod api;
+ mod types;
  mod pages;

  use pages::Home;
  use wasm_bindgen::prelude::*;
  use yew::prelude::*;

  #[wasm_bindgen(start)]
  pub fn run_app() {
      App::<Home>::new().mount_to_body();
  }
```

Finally, let's update our HomePage component:

```diff
+ use crate::api;
+ use crate::types::{CartProduct, Product};
+ use anyhow::Error;
+ use yew::format::Json;
+ use yew::services::fetch::FetchTask;
  use yew::prelude::*;

- #[derive(Clone)]
- struct Product {
-     id: i32,
-     name: String,
-     description: String,
-     image: String,
-     price: f64,
- }

- struct CartProduct {
-     product: Product,
-     quantity: i32,
- }

  struct State {
      products: Vec<Product>,
      cart_products: Vec<CartProduct>,
+     get_products_error: Option<Error>,
+     get_products_loaded: bool,
  }

  pub struct Home {
      state: State,
      link: ComponentLink<Self>,
+     task: Option<FetchTask>,
  }

  pub enum Msg {
      AddToCart(i32),
+     GetProducts,
+     GetProductsSuccess(Vec<Product>),
+     GetProductsError(Error),
  }

  impl Component for Home {
      type Message = Msg;
      type Properties = ();

      fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
-         let products: Vec<Product> = vec![
-             Product {
-                 id: 1,
-                 name: "Apple".to_string(),
-                 description: "An apple a day keeps the doctor away".to_string(),
-                 image: "/products/apple.png".to_string(),
-                 price: 3.65,
-             },
-             Product {
-                 id: 2,
-                 name: "Banana".to_string(),
-                 description: "An old banana leaf was once young and green".to_string(),
-                 image: "/products/banana.png".to_string(),
-                 price: 7.99,
-             },
-         ];
+         let products = vec![];
          let cart_products = vec![];

+         link.send_message(Msg::GetProducts);

          Self {
              state: State {
                  products,
                  cart_products,
+                 get_products_error: None,
+                 get_products_loaded: false,
              },
              link,
+             task: None,
          }
      }

      fn update(&mut self, message: Self::Message) -> ShouldRender {
          match message {
+             Msg::GetProducts => {
+                 self.state.get_products_loaded = false;
+                 let handler =
+                     self.link
+                         .callback(move |response: api::FetchResponse<Vec<Product>>| {
+                             let (_, Json(data)) = response.into_parts();
+                             match data {
+                                 Ok(products) => Msg::GetProductsSuccess(products),
+                                 Err(err) => Msg::GetProductsError(err),
+                             }
+                         });
+                 self.task = Some(api::get_products(handler));
+                 true
+             }
+             Msg::GetProductsSuccess(products) => {
+                 self.state.products = products;
+                 self.state.get_products_loaded = true;
+                 true
+             }
+             Msg::GetProductsError(error) => {
+                 self.state.get_products_error = Some(error);
+                 self.state.get_products_loaded = true;
+                 true
+             }
              Msg::AddToCart(product_id) => {
                  let product = self
                      .state
                      .products
                      .iter()
                      .find(|p: &&Product| p.id == product_id)
                      .unwrap();
                  let cart_product = self
                      .state
                      .cart_products
                      .iter_mut()
                      .find(|cp: &&mut CartProduct| cp.product.id == product_id);

                  if let Some(cp) = cart_product {
                      cp.quantity += 1;
                  } else {
                      self.state.cart_products.push(CartProduct {
                          product: product.clone(),
                          quantity: 1,
                      })
                  }
                  true
              }
          }
      }

      fn change(&mut self, _: Self::Properties) -> ShouldRender {
          true
      }

      fn view(&self) -> Html {
          let products: Vec<Html> = self
              .state
              .products
              .iter()
              .map(|product: &Product| {
                  let product_id = product.id;
                  html! {
                    <div>
                      <img src={&product.image}/>
                      <div>{&product.name}</div>
                      <div>{"$"}{&product.price}</div>
                      <button onclick=self.link.callback(move |_| Msg::AddToCart(product_id))>{"Add To Cart"}</button>
                    </div>
                  }
              })
              .collect();

          let cart_value = self
              .state
              .cart_products
              .iter()
              .fold(0.0, |acc, cp| acc + (cp.quantity as f64 * cp.product.price));

+         if !self.state.get_products_loaded {
+             html! {
+               <div>{"Loading ..."}</div>
+             }
+         } else if let Some(_) = self.state.get_products_error {
+             html! {
+               <div>
+                 <span>{"Error loading products! :("}</span>
+               </div>
+             }
+         } else {
              html! {
                <div>
                  <span>{format!("Cart Value: {:.2}", cart_value)}</span>
                  <span>{products}</span>
                </div>
              }
+         }
      }
  }

```

Quite a number of changes, but you should be able to understand most of them.

- We've replaced the hardcoded products list in `create` with an empty array. We're also sending a message `Msg::GetProducts` to `update` which calls the `get_products` method in the `api` module. The returned `FetchTask` is stored in `task`.
- When the network request succeeds, the `Msg::GetProductsSuccess` message is called with products list or `Msg::GetProductsError` with error.
- These two messages set the `products` and `get_products_error` fields in state respectively. They also set the `get_products_loaded` state to true after the request is fulfilled.
- In the `view` method, we've used conditional rendering to render either the loading view, error view or products view based on the component's state.

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-3.png)

## Splitting into reusable components

Let's extract the "product card" component into its own module so we can reuse it in other pages.

```rust
// src/components/product_card.rs
use crate::types::Product;
use yew::prelude::*;

pub struct ProductCard {
    props: Props,
}

#[derive(Properties, Clone)]
pub struct Props {
    pub product: Product,
    pub on_add_to_cart: Callback<()>,
}

impl Component for ProductCard {
    type Message = ();
    type Properties = Props;

    fn create(props: Self::Properties, _link: ComponentLink<Self>) -> Self {
        Self { props }
    }

    fn update(&mut self, _msg: Self::Message) -> ShouldRender {
        true
    }

    fn change(&mut self, _props: Self::Properties) -> ShouldRender {
        true
    }

    fn view(&self) -> Html {
        let onclick = self.props.on_add_to_cart.reform(|_| ());

        html! {
          <div>
            <img src={&self.props.product.image}/>
            <div>{&self.props.product.name}</div>
            <div>{"$"}{&self.props.product.price}</div>
            <button onclick=onclick>{"Add To Cart"}</button>
          </div>
        }
    }
}
```

```rust
// src/components/mod.rs
mod product_card;

pub use product_card::ProductCard;
```

```diff
  // src/lib.rs
  mod api;
+ mod components;
  mod pages;
  mod types;

  // No changes
```

```diff
  // src/pages/home.rs

  use crate::api;
+ use crate::components::ProductCard;
  use crate::types::{CartProduct, Product};
  use anyhow::Error;
  use yew::format::Json;
  use yew::prelude::*;
  use yew::services::fetch::FetchTask;

  // No changes

  impl Component for Home {
      // No changes

      fn view(&self) -> Html {
          let products: Vec<Html> = self
              .state
              .products
              .iter()
              .map(|product: &Product| {
                  let product_id = product.id;
                  html! {
-                   <div>
-                     <img src={&product.image}/>
-                     <div>{&product.name}</div>
-                     <div>{"$"}{&product.price}</div>
-                     <button onclick=self.link.callback(move |_| Msg::AddToCart(product_id))>{"Add To Cart"}</button>
-                   </div>
+                   <ProductCard product={product} on_add_to_cart=self.link.callback(move |_| Msg::AddToCart(product_id))/>
                  }
              })
              .collect();

          // No changes
      }
  }
```

Pretty straightforward, except for `Properties`, `Callback` and `reform`.

- `Properties` - As mentioned in the beginning of the post, "Properties" or "Props" are input to a component. If you think of components as functions, then Props are the function arguments.
- For the `ProductCard` component, we're passing the `Product` struct as well as a `on_add_to_cart` callback. This component doesn't hold any state, so when user clicks on the "Add To Cart" button, this component calls the parent component to update the `cart_products` state. This callback is represented using the `Callback<T>` type and to call this from child component, we either use `emit` or `reform` methods on the callback.

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-4.png)

## Styling

The UI looks barebones as we haven't added any styles.

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-3.png)

We can either use the [class attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/class) or [inline styles](https://developer.mozilla.org/en-US/docs/Web/API/ElementCSSInlineStyle/style) with Yew. Let's add some styles so the UI looks good.

Let's create a new CSS file `static/styles.css`, add it to `static/index.html` and then we can start using the classes in our components.

```diff
  // src/pages/home.rs

  html! {
    <div>
-     <span>{format!("Cart Value: {:.2}", cart_value)}</span>
-     <span>{products}</span>
+     <div class="navbar">
+         <div class="navbar_title">{"RustMart"}</div>
+         <div class="navbar_cart_value">{format!("${:.2}", cart_value)}</div>
+     </div>
+     <div class="product_card_list">{products}</div>
    </div>
  }
```

```diff
  // src/components/product_card.rs

  html! {
-   <div>
-     <img src={&self.props.product.image}/>
-     <div>{&self.props.product.name}</div>
-     <div>{"$"}{&self.props.product.price}</div>
-     <button onclick=onclick>{"Add To Cart"}</button>
-   </div>
+   <div class="product_card_container">
+     <img class="product_card_image" src={&self.props.product.image}/>
+     <div class="product_card_name">{&self.props.product.name}</div>
+     <div class="product_card_price">{"$"}{&self.props.product.price}</div>
+     <button class="product_atc_button" onclick=onclick>{"Add To Cart"}</button>
+   </div>
  }
```

After adding the styles and a few more products, here's how the UI looks like:

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-4.png)

CSS changes are outside the scope of this post, please refer to the [GitHub repo](https://github.com/sheshbabu/rustmart-yew-example).

## Routing

In server rendered pages (Jinja, ERB, JSP etc), each page the user sees is mapped to a different template file. For example, when the user navigates to "/login", it's rendered in server using "login.html" and when the user goes to "/settings", it's rendered using "settings.html". Using unique urls for different UI pages is also useful for bookmarking and sharing.

Since SPAs only have one html page (the "Single Page" in SPA), we should be able to replicate the above behavior. This is done using a `Router`. A Router maps different url paths (with query params, fragments etc) to different page components and helps in navigating between multiple pages without reloading.

For our application, we'll be using this mapping:

```diff
/            => HomePage
/product/:id => ProductDetailPage
```

Let's install `yew-router`:

```diff
  [package]
  name = "rustmart"
  version = "0.1.0"
  authors = ["sheshbabu <sheshbabu@gmail.com>"]
  edition = "2018"

  [lib]
  crate-type = ["cdylib", "rlib"]

  [dependencies]
  yew = "0.17"
+ yew-router = "0.14.0"
  wasm-bindgen = "0.2"
  log = "0.4.6"
  wasm-logger = "0.2.0"
  anyhow = "1.0.32"
  serde = { version = "1.0", features = ["derive"] }
```

Let's add the routes in a dedicated file so it's easier to see all available routes at a glance:

```rust
// src/route.rs
use yew_router::prelude::*;

#[derive(Switch, Debug, Clone)]
pub enum Route {
    #[to = "/"]
    HomePage,
}

```

For the time being, it only has one route. We'll add more later.

Let's create a new file called `src/app.rs` to replace `HomePage` as the new root component:

```rust
use yew::prelude::*;
use yew_router::prelude::*;

use crate::pages::Home;
use crate::route::Route;

pub struct App {}

impl Component for App {
    type Message = ();
    type Properties = ();

    fn create(_: Self::Properties, _link: ComponentLink<Self>) -> Self {
        Self {}
    }

    fn update(&mut self, _msg: Self::Message) -> ShouldRender {
        true
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        false
    }

    fn view(&self) -> Html {
        let render = Router::render(|switch: Route| match switch {
            Route::HomePage => html! {<Home/>},
        });

        html! {
            <Router<Route, ()> render=render/>
        }
    }
}
```

Let's make the corresponding change in `lib.rs`:

```diff
  mod api;
+ mod app;
  mod components;
  mod pages;
+ mod route;
  mod types;

- use pages::Home;
  use wasm_bindgen::prelude::*;
  use yew::prelude::*;

  #[wasm_bindgen(start)]
  pub fn run_app() {
      wasm_logger::init(wasm_logger::Config::default());
-     App::<Home>::new().mount_to_body();
+     App::<app::App>::new().mount_to_body();
  }
```

This is how our component hierarchy looks like so far:

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-5.png)

## ProductDetailPage

Now that we have a router in place, let's use it to navigate from one page to another. Since it's a SPA, we should avoid page reload while navigating.

Let's add a route for ProductDetailPage under `/product/:id`. When the user clicks on a `ProductCard`, it will go to its detail page with the `id` in the route passed as a Prop.

```diff
  // src/route.rs
  use yew_router::prelude::*;

  #[derive(Switch, Debug, Clone)]
  pub enum Route {
+     #[to = "/product/{id}"]
+     ProductDetail(i32),
      #[to = "/"]
      HomePage,
  }
```

Note that the order of the routes above determines which page gets rendered first. For example, the url `/product/2` matches both `/product/{id}` and `/` but since we wrote `/product/{id}` first, the `ProductDetail` page gets rendered instead of `Home`.

Add this route to `app.rs`:

```diff
  use yew::prelude::*;
  use yew_router::prelude::*;

- use crate::pages::{Home};
+ use crate::pages::{Home, ProductDetail};
  use crate::route::Route;

  pub struct App {}

  impl Component for App {
      // No changes

      fn view(&self) -> Html {
          let render = Router::render(|switch: Route| match switch {
+             Route::ProductDetail(id) => html! {<ProductDetail id=id/>},
              Route::HomePage => html! {<Home/>},
          });

          html! {
              <Router<Route, ()> render=render/>
          }
      }
  }
```

Let's update the `ProductCard` so clicking on the product image, name or price takes us to this new page:

```diff
  // src/components/product_card.rs
+ use crate::route::Route;
  use crate::types::Product;
  use yew::prelude::*;
+ use yew_router::components::RouterAnchor;

  // No changes

  impl Component for ProductCard {
      // No changes

      fn view(&self) -> Html {
+         type Anchor = RouterAnchor<Route>;
          let onclick = self.props.on_add_to_cart.reform(|_| ());

          html! {
              <div class="product_card_container">
+                 <Anchor route=Route::ProductDetail(self.props.product.id) classes="product_card_anchor">
                      <img class="product_card_image" src={&self.props.product.image}/>
                      <div class="product_card_name">{&self.props.product.name}</div>
                      <div class="product_card_price">{"$"}{&self.props.product.price}</div>
+                 </Anchor>
                  <button class="product_atc_button" onclick=onclick>{"Add To Cart"}</button>
              </div>
          }
      }
  }
```

Notice how we used `classes` instead of `class` for `Anchor`.

We'll create files named `static/products/1.json`, `static/products/2.json` etc with mock data:

```json
{
  "id": 1,
  "name": "Apple",
  "description": "An apple a day keeps the doctor away",
  "image": "/products/apple.png",
  "price": 3.65
}
```

Let's update the `api.rs` module with the new route:

```diff
  use crate::types::Product;
  use anyhow::Error;
  use yew::callback::Callback;
  use yew::format::{Json, Nothing};
  use yew::services::fetch::{FetchService, FetchTask, Request, Response};

  pub type FetchResponse<T> = Response<Json<Result<T, Error>>>;
  type FetchCallback<T> = Callback<FetchResponse<T>>;

  pub fn get_products(callback: FetchCallback<Vec<Product>>) -> FetchTask {
      let req = Request::get("/products/products.json")
          .body(Nothing)
          .unwrap();

      FetchService::fetch(req, callback).unwrap()
  }

+ pub fn get_product(id: i32, callback: FetchCallback<Product>) -> FetchTask {
+     let req = Request::get(format!("/products/{}.json", id))
+         .body(Nothing)
+         .unwrap();
+
+     FetchService::fetch(req, callback).unwrap()
+ }
```

Finally, here's the `ProductDetail` page component:

```rust
// src/pages/product_detail.rs
use crate::api;
use crate::types::Product;
use anyhow::Error;
use yew::format::Json;
use yew::prelude::*;
use yew::services::fetch::FetchTask;

struct State {
    product: Option<Product>,
    get_product_error: Option<Error>,
    get_product_loaded: bool,
}

pub struct ProductDetail {
    props: Props,
    state: State,
    link: ComponentLink<Self>,
    task: Option<FetchTask>,
}

#[derive(Properties, Clone)]
pub struct Props {
    pub id: i32,
}

pub enum Msg {
    GetProduct,
    GetProductSuccess(Product),
    GetProductError(Error),
}

impl Component for ProductDetail {
    type Message = Msg;
    type Properties = Props;

    fn create(props: Self::Properties, link: ComponentLink<Self>) -> Self {
        link.send_message(Msg::GetProduct);

        Self {
            props,
            state: State {
                product: None,
                get_product_error: None,
                get_product_loaded: false,
            },
            link,
            task: None,
        }
    }

    fn update(&mut self, message: Self::Message) -> ShouldRender {
        match message {
            Msg::GetProduct => {
                let handler = self
                    .link
                    .callback(move |response: api::FetchResponse<Product>| {
                        let (_, Json(data)) = response.into_parts();
                        match data {
                            Ok(product) => Msg::GetProductSuccess(product),
                            Err(err) => Msg::GetProductError(err),
                        }
                    });

                self.task = Some(api::get_product(self.props.id, handler));
                true
            }
            Msg::GetProductSuccess(product) => {
                self.state.product = Some(product);
                self.state.get_product_loaded = true;
                true
            }
            Msg::GetProductError(error) => {
                self.state.get_product_error = Some(error);
                self.state.get_product_loaded = true;
                true
            }
        }
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        false
    }

    fn view(&self) -> Html {
        if let Some(ref product) = self.state.product {
            html! {
                <div class="product_detail_container">
                    <img class="product_detail_image" src={&product.image}/>
                    <div class="product_card_name">{&product.name}</div>
                    <div style="margin: 10px 0; line-height: 24px;">{&product.description}</div>
                    <div class="product_card_price">{"$"}{&product.price}</div>
                    <button class="product_atc_button">{"Add To Cart"}</button>
                </div>
            }
        } else if !self.state.get_product_loaded {
            html! {
                <div class="loading_spinner_container">
                    <div class="loading_spinner"></div>
                    <div class="loading_spinner_text">{"Loading ..."}</div>
                </div>
            }
        } else {
            html! {
                <div>
                    <span>{"Error loading product! :("}</span>
                </div>
            }
        }
    }
}
```

Very similar to the HomePage component. Let's also add this file to the module tree:

```diff
  // src/pages/mod.rs
  mod home;
+ mod product_detail;

  pub use home::Home;
+ pub use product_detail::ProductDetail;
```

This is how it looks like:

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-5.png)

We can now move between multiple pages without refreshing the page!

## State Management

One thing you might have noticed in the `ProductDetail` page is that clicking on the "Add To Cart" button doesn't update the cart. This is because the state that holds the list of products in cart `cart_products` currently resides inside `Home` page component:
![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-6.png)

To share state between two components, we can either:

- Hoist the state to a common ancestor
- Move state to global app state

The `App` component is a common ancestor to both `ProductDetail` and `Home`. We can move the `cart_products` state there and pass it as props to `ProductDetail` and `Home`.

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-7.png)

This works fine for shallow component hierarchies but when you have deep component hierarchy (which is common in larger SPAs), you'll need to pass this state through multiple layers of components (which might not have use for this prop) to reach the desired node. This is called "Prop Drilling".

You can see that `cart_products` is now passed from `App` to `AddToCart` component via `ProductDetail` and `Home` even though they have no use for this state. Imagine the same scenario with components many layers deep.

This is the problem the global state solves. Here's how it would look like:

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-8.png)

Notice how there's a direct link between the components that need this state and the global state.

Unfortunately, Yew doesn't seem to have a [good solution](https://github.com/yewstack/yew/issues/576) for this. The recommended solution is to use `Agents` for broadcasting state changes via pubsub. This is something I stay away from as it gets messy fast. I hope in future we see something similar to React's [Context](https://reactjs.org/docs/context.html), Redux or Mobx etc.

Let's solve our problem by hoisting the state.

## Hoisting State

We'll be refactoring our code by moving `cart_products` state to `App` and extracting `Navbar` and `AtcButton` as separate components:

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-9.png)

```rust
// src/components/navbar.rs
use crate::types::CartProduct;
use yew::prelude::*;

pub struct Navbar {
    props: Props,
}

#[derive(Properties, Clone)]
pub struct Props {
    pub cart_products: Vec<CartProduct>,
}

impl Component for Navbar {
    type Message = ();
    type Properties = Props;

    fn create(props: Self::Properties, _link: ComponentLink<Self>) -> Self {
        Self { props }
    }

    fn update(&mut self, _msg: Self::Message) -> ShouldRender {
        true
    }

    fn change(&mut self, props: Self::Properties) -> ShouldRender {
        self.props = props;
        true
    }

    fn view(&self) -> Html {
        let cart_value = self
            .props
            .cart_products
            .iter()
            .fold(0.0, |acc, cp| acc + (cp.quantity as f64 * cp.product.price));

        html! {
            <div class="navbar">
                <div class="navbar_title">{"RustMart"}</div>
              <div class="navbar_cart_value">{format!("${:.2}", cart_value)}</div>
            </div>
        }
    }
}
```

Notice how we started using the `change` lifecycle methods in the `Navbar` component. When the props sent from parent changes, we need to update the props inside the component so the UI re-renders.

```rust
// src/components/atc_button.rs
use crate::types::Product;
use yew::prelude::*;

pub struct AtcButton {
    props: Props,
    link: ComponentLink<Self>,
}

#[derive(Properties, Clone)]
pub struct Props {
    pub product: Product,
    pub on_add_to_cart: Callback<Product>,
}

pub enum Msg {
    AddToCart,
}

impl Component for AtcButton {
    type Message = Msg;
    type Properties = Props;

    fn create(props: Self::Properties, link: ComponentLink<Self>) -> Self {
        Self { props, link }
    }

    fn update(&mut self, msg: Self::Message) -> ShouldRender {
        match msg {
            Msg::AddToCart => self.props.on_add_to_cart.emit(self.props.product.clone()),
        }
        true
    }

    fn change(&mut self, props: Self::Properties) -> ShouldRender {
        self.props = props;
        true
    }

    fn view(&self) -> Html {
        let onclick = self.link.callback(|_| Msg::AddToCart);

        html! {
          <button class="product_atc_button" onclick=onclick>{"Add To Cart"}</button>
        }
    }
}
```

```diff
  // src/components/mod.rs
+ mod atc_button;
+ mod navbar;
  mod product_card;

+ pub use atc_button::AtcButton;
+ pub use navbar::Navbar;
  pub use product_card::ProductCard;
```

Use the new `AtcButton` in `ProductCard` and `ProductDetail`:

```diff
  // src/components/product_card.rs
+ use crate::components::AtcButton;
  use crate::route::Route;
  use crate::types::Product;
  use yew::prelude::*;
  use yew_router::components::RouterAnchor;

  pub struct ProductCard {
      props: Props,
  }

  #[derive(Properties, Clone)]
  pub struct Props {
      pub product: Product,
-     pub on_add_to_cart: Callback<()>,
+     pub on_add_to_cart: Callback<Product>,
  }

  impl Component for ProductCard {
      // No changes

      fn view(&self) -> Html {
          type Anchor = RouterAnchor<Route>;
-         let onclick = self.props.on_add_to_cart.reform(|_| ());

          html! {
              <div class="product_card_container">
                  <Anchor route=Route::ProductDetail(self.props.product.id) classes="product_card_anchor">
                      <img class="product_card_image" src={&self.props.product.image}/>
                      <div class="product_card_name">{&self.props.product.name}</div>
                      <div class="product_card_price">{"$"}{&self.props.product.price}</div>
                  </Anchor>
-                 <button class="product_atc_button" onclick=onclick>{"Add To Cart"}</button>
+                 <AtcButton product=self.props.product.clone() on_add_to_cart=self.props.on_add_to_cart.clone() />
              </div>
          }
      }
  }
```

```diff
  // src/pages/product_detail.rs
  use crate::api;
+ use crate::components::AtcButton;
  use crate::types::Product;
  use anyhow::Error;
  use yew::format::Json;
  use yew::prelude::*;
  use yew::services::fetch::FetchTask;

  // No changes

  #[derive(Properties, Clone)]
  pub struct Props {
      pub id: i32,
+     pub on_add_to_cart: Callback<Product>,
  }

  impl Component for ProductDetail {
      // No changes

      fn view(&self) -> Html {
          if let Some(ref product) = self.state.product {
              html! {
                  <div class="product_detail_container">
                      <img class="product_detail_image" src={&product.image}/>
                      <div class="product_card_name">{&product.name}</div>
                      <div style="margin: 10px 0; line-height: 24px;">{&product.description}</div>
                      <div class="product_card_price">{"$"}{&product.price}</div>
-                     <button class="product_atc_button">{"Add To Cart"}</button>
+                     <AtcButton product=product.clone() on_add_to_cart=self.props.on_add_to_cart.clone() />
                  </div>
              }
          }

          // No changes
      }
  }
```

Finally, move the `cart_products` state from `Home` to `App`:

```diff
  // src/app.rs
+ use crate::components::Navbar;
+ use crate::types::{CartProduct, Product};
  use yew::prelude::*;
  use yew_router::prelude::*;

  use crate::pages::{Home, ProductDetail};
  use crate::route::Route;

+ struct State {
+     cart_products: Vec<CartProduct>,
+ }

- pub struct App {}
+ pub struct App {
+     state: State,
+     link: ComponentLink<Self>,
+ }

+ pub enum Msg {
+     AddToCart(Product),
+ }

  impl Component for App {
-     type Message = ();
+     type Message = Msg;
      type Properties = ();

-     fn create(_: Self::Properties, _link: ComponentLink<Self>) -> Self {
+     fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
+         let cart_products = vec![];

-         Self {}
+         Self {
+             state: State { cart_products },
+             link,
+         }
      }

-     fn update(&mut self, _msg: Self::Message) -> ShouldRender {
+     fn update(&mut self, message: Self::Message) -> ShouldRender {
+         match message {
+             Msg::AddToCart(product) => {
+                 let cart_product = self
+                     .state
+                     .cart_products
+                     .iter_mut()
+                     .find(|cp: &&mut CartProduct| cp.product.id == product.id);

+                 if let Some(cp) = cart_product {
+                     cp.quantity += 1;
+                 } else {
+                     self.state.cart_products.push(CartProduct {
+                         product: product.clone(),
+                         quantity: 1,
+                     })
+                 }
+                 true
+             }
+         }
-         true
      }

      fn change(&mut self, _: Self::Properties) -> ShouldRender {
          false
      }

      fn view(&self) -> Html {
+         let handle_add_to_cart = self
+             .link
+             .callback(|product: Product| Msg::AddToCart(product));
+         let cart_products = self.state.cart_products.clone();

-         let render = Router::render(|switch: Route| match switch {
-           Route::ProductDetail(id) => html! {<ProductDetail id=id/>},
-           Route::HomePage => html! {<Home/>},
+         let render = Router::render(move |switch: Route| match switch {
+             Route::ProductDetail(id) => {
+                 html! {<ProductDetail id=id on_add_to_cart=handle_add_to_cart.clone() />}
+             }
+             Route::HomePage => {
+                 html! {<Home cart_products=cart_products.clone() on_add_to_cart=handle_add_to_cart.clone()/>}
+             }
          });

          html! {
+             <>
+                 <Navbar cart_products=self.state.cart_products.clone() />
                  <Router<Route, ()> render=render/>
+             </>
          }
      }
  }
```

```diff
  // src/pages/home.rs
  // No changes

  struct State {
      products: Vec<Product>,
-     cart_products: Vec<CartProduct>,
      get_products_error: Option<Error>,
      get_products_loaded: bool,
  }

+ #[derive(Properties, Clone)]
+ pub struct Props {
+     pub cart_products: Vec<CartProduct>,
+     pub on_add_to_cart: Callback<Product>,
+ }

  pub struct Home {
+     props: Props,
      state: State,
      link: ComponentLink<Self>,
      task: Option<FetchTask>,
  }

  pub enum Msg {
-     AddToCart(i32),
      GetProducts,
      GetProductsSuccess(Vec<Product>),
      GetProductsError(Error),
  }

  impl Component for Home {
      type Message = Msg;
-     type Properties = ();
+     type Properties = Props;

-     fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
+     fn create(props: Self::Properties, link: ComponentLink<Self>) -> Self {
          let products = vec![];
-         let cart_products = vec![];

          link.send_message(Msg::GetProducts);

          Self {
              props,
              state: State {
                  products,
-                 cart_products,
                  get_products_error: None,
                  get_products_loaded: false,
              },
              link,
              task: None,
          }
      }

      fn update(&mut self, message: Self::Message) -> ShouldRender {
          match message {
              Msg::GetProducts => {
                  self.state.get_products_loaded = false;
                  let handler =
                      self.link
                          .callback(move |response: api::FetchResponse<Vec<Product>>| {
                              let (_, Json(data)) = response.into_parts();
                              match data {
                                  Ok(products) => Msg::GetProductsSuccess(products),
                                  Err(err) => Msg::GetProductsError(err),
                              }
                          });

                  self.task = Some(api::get_products(handler));
                  true
              }
              Msg::GetProductsSuccess(products) => {
                  self.state.products = products;
                  self.state.get_products_loaded = true;
                  true
              }
              Msg::GetProductsError(error) => {
                  self.state.get_products_error = Some(error);
                  self.state.get_products_loaded = true;
                  true
              }
-             Msg::AddToCart(product_id) => {
-                 let product = self
-                     .state
-                     .products
-                     .iter()
-                     .find(|p: &&Product| p.id == product_id)
-                     .unwrap();
-                 let cart_product = self
-                     .state
-                     .cart_products
-                     .iter_mut()
-                     .find(|cp: &&mut CartProduct| cp.product.id == product_id);
-                 if let Some(cp) = cart_product {
-                     cp.quantity += 1;
-                 } else {
-                     self.state.cart_products.push(CartProduct {
-                         product: product.clone(),
-                         quantity: 1,
-                     })
-                 }
-                 true
-             }
          }
      }

-     fn change(&mut self, _: Self::Properties) -> ShouldRender {
+     fn change(&mut self, props: Self::Properties) -> ShouldRender {
+         self.props = props;
          true
      }

      fn view(&self) -> Html {
          let products: Vec<Html> = self
              .state
              .products
              .iter()
              .map(|product: &Product| {
-                 let product_id = product.id;
                  html! {
-                   <ProductCard product={product} on_add_to_cart=self.link.callback(move |_| Msg::AddToCart(product_id))/>
+                   <ProductCard product={product} on_add_to_cart=self.props.on_add_to_cart.clone()/>
                  }
              })
              .collect();

-        let cart_value = self
-            .state
-            .cart_products
-            .iter()
-            .fold(0.0, |acc, cp| acc + (cp.quantity as f64 * cp.product.price));

          if !self.state.get_products_loaded {
              // No changes
          } else if let Some(_) = self.state.get_products_error {
              // No changes
          } else {
              html! {
-               <div>
-                 <div class="navbar">
-                     <div class="navbar_title">{"RustMart"}</div>
-                     <div class="navbar_cart_value">{format!("${:.2}", cart_value)}</div>
-                 </div>
                  <div class="product_card_list">{products}</div>
-               </div>
              }
          }
      }
  }
```

Now we can finally add to cart from `ProductDetail` page and we can also see the navbar in all pages

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-6.png)
![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-4.png)

We've successfully built a SPA fully in Rust!

I've hosted the demo [here](https://rustmart-yew.netlify.app) and the code is in this [GitHub repo](https://github.com/sheshbabu/rustmart-yew-example). If you have questions or suggestions, please contact me at sheshbabu [at] gmail.com.

## 总结

The Yew community has done a good job designing abstractions like `html!`, `Component` etc so someone like me who's familiar with React can immediately start being productive. It definitely has some rough edges like FetchTask, lack of [_predictable_](https://redux.js.org/introduction/motivation) state management and the documentation is sparse, but has potential to become a good alternative to React, Vue etc once these issues are fixed.

Thanks for reading! Feel free to follow me in [Twitter](https://twitter.com/sheshbabu) for more posts like this :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
