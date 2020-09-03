
# Single Page Applications using Rust

WebAssembly (wasm) allows code written in languages other than JavaScript to run on browsers. If you haven't been paying attention, all the major browsers support wasm and [globally more than 90% of users](https://caniuse.com/#feat=wasm) have browsers that can run wasm.

Since Rust compiles to wasm, is it possible to build SPAs (Single Page Applications) purely in Rust and without writing a single line of JavaScript? The short answer is YES! Read on to learn more or visit the [demo site](https://rustmart-yew.netlify.app) if you can't contain your excitement!

We'll be building a simple ecommerce site called "RustMart" that will have 2 pages:

- HomePage - list all the products that the customer can add to cart
- ProductDetailPage - show the product details when a product card is clicked

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-1.png)

I'm using this example as it tests the minimal set of capabilities required to build modern SPAs:

- Navigate between multiple pages without page reload
- Make network requests without page reload
- Ability to reuse UI components across multiple pages
- Update components in different layers of the UI hierarchy

## Setup

Follow this [link](https://www.rust-lang.org/tools/install) to install Rust if you haven't done so already.

Install these Rust tools:

```shell
$ cargo install wasm-pack          # Compile Rust to Wasm and generate JS interop code
$ cargo install cargo-make         # Task runner
$ cargo install simple-http-server # Simple server to serve assets
```

Create a new project:

```shell
$ cargo new --lib rustmart && cd rustmart
```

We'll be using the [`Yew`](https://yew.rs) library to build UI components. Let's add this and wasm dependencies to `Cargo.toml`:

```toml
[lib]
crate-type = ["cdylib", "rlib"]

[dependencies]
yew = "0.17"
wasm-bindgen = "0.2"
```

Create a new file named `Makefile.toml` and add this:

```toml
[tasks.build]
command = "wasm-pack"
args = ["build", "--dev", "--target", "web", "--out-name", "wasm", "--out-dir", "./static"]
watch = { ignore_pattern = "static/*" }

[tasks.serve]
command = "simple-http-server"
args = ["-i", "./static/", "-p", "3000", "--nocache", "--try-file", "./static/index.html"]
```

Start the build task:

```shell
$ cargo make build
```

If you're new to Rust, I've written some [guides for beginners](http://www.sheshbabu.com/tags/Rust-Beginners/) which will help you follow this post better.

## Hello World

Let's start with a simple "hello world" example:

Create `static/index.html` and add this:

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

Add this to `src/lib.rs`:

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

Lot of things going on but you can see that we're creating a new component named "Hello" that renders `<span>Hello World!</span>` into the DOM. We'll learn more about Yew components later.

Start the serve task in a new terminal and load `http://localhost:3000` in your browser

```shell
$ cargo make serve
```

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-1.png)

It works!! It's only "hello world" but this is fully written in Rust.

Let's learn about components and other SPA concepts before proceeding further.

## Thinking in Components

Building UIs by composing components and passing data in a unidirectional way is a paradigm shift in the frontend world. It's a huge improvement in the way we reason about UI and it's very hard to go back to imperative DOM manipulation once you get used to this.

A `Component` in libraries like React, Vue, Yew, Flutter etc have these features:

- Ability to be composed into bigger components
- `Props` - Pass data and callbacks from that component to its child components.
- `State` - Manipulate state local to that component.
- `AppState` - Manipulate global state.
- Listen to lifecycle events like "Instantiated", "Mounted in DOM" etc
- Perform side effects like fetching remote data, manipulating localstorage etc

A component gets updated (re-rendered) when one of the following happens:

- Parent component is re-rendered
- `Props` changes
- `State` changes
- `AppState` changes

So, instead of imperatively updating the UI when user interaction, network requests etc happen, we update the data (Props, State, AppState) and the UI is updated based on this data. This what someone means when they say "UI is a function of state".

The exact details differ across different libraries but this should give you a general idea. If you're new to this, this way of thinking might take sometime to "click" and get used to.

## HomePage

Let's build the HomePage first. We'll be building the HomePage as a monolithic component and later decompose it into smaller reusable components.

Let's create the following files:

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

Let's update the `src/lib.rs` to import the HomePage component:

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

Now, you should see "Home Sweet Home!" instead of "Hello World!" rendered in your browser.

Let's start designing the `State` of this component:

- We need to store a list of products retrieved from server
- Store the products the user has added to cart

We create a simple struct to hold the `Product` details:

```rust
struct Product {
    name: String,
    description: String,
    image: String,
    price: f64,
}
```

We then create a new struct `State` with field called `products` to hold the products from server:

```rust
struct State {
    products: Vec<Product>,
}
```

Here's the full list of changes in the HomePage component:

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

The `create` lifecycle method is invoked when the component is created and this is where we set the initial state. For the time being, we've created a mock list of products and assigned it to the `products` inside the state as initial value. Later, we'll fetch this list using network request.

The `view` lifecycle method is invoked when the component is rendered. Here we've iterated over `products` inside state to generate product cards. If you're familiar with React, this is same as the `render` method and the `html!` macro is similar to `JSX`.

Save some random images as `static/products/apple.png` and `static/products/banana.png` and you'll get this UI:

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/image-2.png)

Let's implement the "add to cart" functionality:

- We keep track of all products added to cart in a new state field called `cart_products`
- We render a "add to cart" button for each product
- Add logic to update the `cart_products` state when "add to cart" button is clicked

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

- `clone` - We've derived the [`Clone`](https://doc.rust-lang.org/std/clone/trait.Clone.html) trait in `Product` struct so we can save the cloned `Product` into `CartProduct` whenever the user adds them to cart.
- `update` - This method is the place where the logic to update the component `State` or perform side-effects (like network requests) exist. It is invoked using a `Message` enum that contains all the actions the component supports. When we return `true` from this method, the component is re-rendered. In the above code, when the user clicks the "Add To Cart" button, we send a `Msg::AddToCart` message to `update`. Inside `update`, this either adds the product to `cart_product` if it doesn't exist or it increments the quantity.
- `link` - This allows us to register callbacks that can trigger our `update` lifecycle method.

If you've used [Redux](https://redux.js.org) before, `update` is similar to [`Reducer`](https://redux.js.org/basics/reducers) (for state updates) and [`Action Creator`](https://redux.js.org/basics/actions#action-creators) (for side-effects), `Message` is similar to [`Action`](https://redux.js.org/basics/actions) and `link` is similar to [`Dispatch`](https://redux.js.org/basics/store#dispatching-actions).

![](https://raw.githubusercontent.com/sheshbabu/Blog/master/source/images/2020-rust-wasm-yew-single-page-application/rust-wasm-yew-single-page-application-2.png)

Here's how the UI looks like, try clicking the "Add To Cart" button and see the changes in "Cart Value":

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

## Conclusion

The Yew community has done a good job designing abstractions like `html!`, `Component` etc so someone like me who's familiar with React can immediately start being productive. It definitely has some rough edges like FetchTask, lack of [_predictable_](https://redux.js.org/introduction/motivation) state management and the documentation is sparse, but has potential to become a good alternative to React, Vue etc once these issues are fixed.

Thanks for reading! Feel free to follow me in [Twitter](https://twitter.com/sheshbabu) for more posts like this :)
