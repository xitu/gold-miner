> * 原文地址：[Running JavaScript in WebAssembly with WasmEdge](https://javascript.plainenglish.io/running-javascript-in-webassembly-883ec71438e1)
> * 原文作者：[Michael Yuan](https://medium.com/@michaelyuan_88928)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/running-javascript-in-webassembly.md](https://github.com/xitu/gold-miner/blob/master/article/2021/running-javascript-in-webassembly.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：[nia3y](https://github.com/nia3y)、[PassionPenguin](https://github.com/PassionPenguin)

# 使用 WasmEdge 在 WebAssembly 中运行 JavaScript

![](https://cdn-images-1.medium.com/max/3840/1*P4LKOkLu-MB2QAQb9FaRhQ.png)

[WebAssembly](https://webassembly.org/) 最初是作为浏览器中 JavaScript 的替代语言而设计的。这个想法是让像 C/C++ 或 Rust 编译的高性能应用程序能够安全的运行在浏览器中。在浏览器中，WebAssembly 和 JavaScript 并行运行。

![图 1：浏览器中的 WebAssembly 和 JavaScript。](https://cdn-images-1.medium.com/max/2000/1*h59dPAp6HQcaaIQt7GdejA.png)

随着 WebAssembly 越来越多被应用在云端，它现在是[原生云应用通用运行时](https://github.com/WasmEdge/WasmEdge)。与类 Docker 应用容器相比，WebAssembly 运行时有着更低的资源消耗和更高的性能。下面是一个常用的在云端使用 WebAssembly 的例子。

* 为 [serverless function-as-a-service](https://github.com/second-state/aws-lambda-wasm-runtime) (FaaS) 提供运行时。
* 嵌入[用户定义函数到 SaaS](http://reactor.secondstate.info/en/docs/) 应用程序或数据库。
* 为服务网格中的 [sidecar 应用程序](https://github.com/second-state/dapr-wasm) 提供运行时。
* Web 代理的可编程插件。
* 为边缘设备包括[软件定义交通工具](https://www.secondstate.io/articles/second-state-joins-the-autoware-foundation/)和智能工厂提供运行时。

然而，在这些原生云用例中，开发者常常想用 JavaScript 去写商业应用程序。这意味着，我们现在必须支持用 [JavaScript 编写 WebAssembly](https://github.com/WasmEdge/WasmEdge/blob/master/docs/run_javascript.md)。不仅如此，我们应该让运行在 WebAssembly 运行时中的 JavaScript 调用 C/C++ 或者 Rust 函数，以求最大化利用 WebAssembly 的运行效率。WasmEdge WebAssembly 运行时就允许我们这样去实现它。

![图 2：云端中的 WebAssembly 和 JavaScript](https://cdn-images-1.medium.com/max/2000/1*OmqZydcKW18qNIbVKs0J3A.png)

## WasmEdge

[WasmEdge](https://github.com/WasmEdge/WasmEdge) 是一个由 CNCF（Cloud Native Computing Foundation）与  Linux 基金会托管的领先的云原生 WebAssembly 运行时。它是目前市场上最快的 WebAssembly 运行时，支持所有标准的 WebAssembly 扩展以及 Tensorflow inference、KV store 和 image processing 等的私有扩展。它的编译工具链不仅仅支持 WebAssembly 语言如 C/C++、Rust、Swift、Kotlin 以及 AssemblyScript，而且支持[常用的 JavaScript](https://github.com/WasmEdge/WasmEdge/blob/master/docs/run_javascript.md)。

WasmEdge 应用程序可以被嵌入到 [C](https://github.com/WasmEdge/WasmEdge/blob/master/docs/c_api_quick_start.md)、[Go](https://www.secondstate.io/articles/extend-golang-app-with-webassembly-rust/)、[Rust](https://github.com/WasmEdge/WasmEdge/tree/master/wasmedge-rs) 、[JavaScript](https://www.secondstate.io/articles/getting-started-with-rust-function/) 程序，以及其他操作系统的 [CLI](https://github.com/WasmEdge/WasmEdge/blob/master/docs/run.md)。运行时还可以被 Docker 工具（例如 [CRI-O](https://www.secondstate.io/articles/manage-webassembly-apps-in-wasmedge-using-docker-tools/)），编制工具（例如 K8s），serverless 平台（例如 [Vercel](https://www.secondstate.io/articles/vercel-wasmedge-webassembly-rust/), [Netlify](https://www.secondstate.io/articles/netlify-wasmedge-webassembly-rust-serverless/), [AWS Lambda](https://www.cncf.io/blog/2021/08/25/webassembly-serverless-functions-in-aws-lambda/), [Tencent SCF](https://github.com/second-state/tencent-scf-wasm-runtime)），和数据流工具（例如 [YoMo](https://www.secondstate.io/articles/yomo-wasmedge-real-time-data-streams/) 和 Zenoh）管理。

现在，你可以在有 serverless functions，微服务，和 AIoT 应用程序功能的 WasmEdge 中运行 JavaScript 程序。它不仅运行简单的 JavaScript 程序，而且允许开发者在安全的 WebAssembly 沙盒中用 Rust 和 C/C++ 去创建新的 JavaScript 接口。

## 在 WasmEdge 中构建一个 JavaScript 引擎

首先，让我们来为 WasmEdge 构建一个基于 WebAssembly 的 JavaScript 解释器。他是基于附有 WasmEdge 扩展的 [QuickJS](https://bellard.org/quickjs/)，例如 [network sockets](https://github.com/second-state/wasmedge_wasi_socket) 和 [Tensorflow inference](https://www.secondstate.io/articles/wasi-tensorflow/)，被合并封装成 JavaScript APIs 的解释器中。你将需要[安装 Rust](https://www.rust-lang.org/tools/install) 去构建解释器。

> **如果你只想用这个解释器运行 JavaScript 程序，你可以跳过这个部分。**

让我们先从 Fork 或者克隆 [wasmegde-quickjs Github 仓库](https://github.com/second-state/wasmedge-quickjs) 开始。

```bash
$ git clone https://github.com/second-state/wasmedge-quickjs
```

跟着仓库里面给出的克隆指令，你就能构建一个 WasmEdge 的 JavaScript 解释器。

```bash
$ rustup target add wasm32-wasi
$ cargo build --target wasm32-wasi --release
```

基于 WebAssembly 的 JavaScript 解释器程序被放置在构建目标目录中。

```bash
$ ls target/wasm32-wasi/debug/quickjs-rs-wasi.wasm
```

接下来，让我们就尝试一些 JavaScript 程序。

## 一个 JavaScript 网络通信应用的例子

解释器支持  WasmEdge 网络套接口扩展，所以你的 JavaScript 能做 HTTP 连接互联网。下面是一个 JavaScript 的例子。

```js
let r = GET("http://18.235.124.214/get?a=123",{"a":"b","c":[1,2,3]})
print(r.status)
    
let headers = r.headers
print(JSON.stringify(headers))

let body = r.body;
let body_str = new Uint8Array(body)
print(String.fromCharCode.apply(null,body_str))
```

你可以用 CLI 在 WasmEdge 运行时中运行 JavaScript。

```bash
$ wasmedge --dir .:. target/wasm32-wasi/debug/quickjs-rs-wasi.wasm example_js/http_demo.js
```

你现在应该看到一个 HTTP GET 请求结果打印在控制台中。

## JavaScript Tensorflow inference 例子

解释器支持用 WasmEdge Tensorflow 进行简单的推理扩展，所以你可以运行 ImageNet 模型，来进行图像分类。下面是 JavaScript 的例子。

```js
import {TensorflowLiteSession} from 'tensorflow_lite'
import {Image} from 'image'

let img = new Image('./example_js/tensorflow_lite_demo/food.jpg')
let img_rgb = img.to_rgb().resize(192,192)
let rgb_pix = img_rgb.pixels()

let session = new TensorflowLiteSession('./example_js/tensorflow_lite_demo/lite-model_aiy_vision_classifier_food_V1_1.tflite')
session.add_input('input',rgb_pix)
session.run()
let output = session.get_output('MobilenetV1/Predictions/Softmax');
let output_view = new Uint8Array(output)
let max = 0;
let max_idx = 0;
for (var i in output_view){
    let v = output_view[i]
    if(v>max){
        max = v;
        max_idx = i;
    }
}
print(max,max_idx)
```

你可以用 CLI 在 WasmEdge 运行时中运行 JavaScript。

```bash
$ wasmedge --dir .:. target/wasm32-wasi/debug/quickjs-rs-wasi.wasm example_js/tensorflow_lite_demo/main.js
```

你现在应该看到被 TensorFlow 轻量 imagenet 模型识别的食物元素的名字。

## 合并 JavaScript 到 Rust

上面两个例子展示了如何在 WasmEdge 里预构建 `quickjs-rs-wasi.wasm` 应用程序。除了使用 CLI，你可以用 Docker / Kubernetes 工具去启动 WebAssembly 应用程序，也可以嵌入到你自己的应用程序或者我们之前在这篇文章导论过的框架中。

或者，你可以创建你自己的 Rust 函数，这个函数被当作字符串变量嵌入到 JavaScript 程序或者从函数输入参数去获取 JavaScript 程序。你可以参考 [main.rs](https://github.com/second-state/wasmedge-quickjs/blob/main/src/main.rs) 应用模板，它从文件中以字符串的形式读取 JavaScript 程序。

```rs
fn main() {
    use quickjs_sys as q;
    let mut ctx = q::Context::new();

    let file_path = args_parse();
    let code = std::fs::read_to_string(&file_path);
    match code {
        Ok(code) => {
            ctx.eval_str(code.as_str(), &file_path);
        }
        Err(e) => {
            eprintln!("{}", e.to_string());
        }
    }
}
```

这种方法能让开发者用简单易用的 JavaScript 混合搭配高性能 Rust，来创建单个 `.wasm` 应用程序文件，可以更简单的部署和管理。

## QuickJS 注意事项

现在，选择 QuickJS 当作我们的 JavaScript 引擎可以提高性能。QuickJS 不是因为没有 JIT 支持，而比 v8 慢很多吗？是的，但是……

首先，QuickJS 比 v8 小很多。事实上，他只有 v8 运行时资源的 1/40 （或 2.5%）。你可以在单个物理机上运行比 v8 更多的 QuickJS 函数。

其次，大多数商业逻辑应用程序，原始性能并不重要。应用程序也许有计算密集型任务，例如 AI 推理。WasmEdge 允许 QuickJS 应用程序在 不容易给 v8 添加这些扩展模块的情况下，使用高性能的 WebAssembly。

最后，我们知道[很多 JavaScript 安全问题在 JIT 上发生了](https://www.theregister.com/2021/08/06/edge_super_duper_security_mode/)。也许在云原生环境中关闭 JIT 是个不错的主意！

云原生 WebAssembly 中的 JavaScript 在下一代云计算和边缘计算基础设施中仍然是个新的领域。我们只是刚开始。如果你有兴趣，在 WasmEdge 项目中加入我们（或者提出特性请求 issues 告诉我们你想要什么）。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
