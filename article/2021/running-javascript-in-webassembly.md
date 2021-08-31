> * 原文地址：[Running JavaScript in WebAssembly with WasmEdge](https://javascript.plainenglish.io/running-javascript-in-webassembly-883ec71438e1)
> * 原文作者：[Michael Yuan](https://medium.com/@michaelyuan_88928)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/running-javascript-in-webassembly.md](https://github.com/xitu/gold-miner/blob/master/article/2021/running-javascript-in-webassembly.md)
> * 译者：
> * 校对者：

# Running JavaScript in WebAssembly with WasmEdge

![](https://cdn-images-1.medium.com/max/3840/1*P4LKOkLu-MB2QAQb9FaRhQ.png)

[WebAssembly](https://webassembly.org/) started as a “JavaScript alternative for browsers”. The idea is to run high-performance applications compiled from languages like C/C++ or Rust safely in browsers. In the browser, WebAssembly runs side by side with JavaScript.

![Figure 1. WebAssembly and JavaScript in the browser.](https://cdn-images-1.medium.com/max/2000/1*h59dPAp6HQcaaIQt7GdejA.png)

As WebAssembly is increasingly used in the cloud, it is now a [universal runtime for cloud-native applications](https://github.com/WasmEdge/WasmEdge). Compared with Docker-like application containers, WebAssembly runtimes achieve higher performance with lower resource consumption. The common uses cases for WebAssembly in the cloud include the following.

* Runtime for [serverless function-as-a-service](https://github.com/second-state/aws-lambda-wasm-runtime) (FaaS)
* Embedding [user-defined functions into SaaS](http://reactor.secondstate.info/en/docs/) apps or databases
* Runtime for [sidecar applications](https://github.com/second-state/dapr-wasm) in a service mesh
* Programmable plug-ins for web proxies
* Sandbox runtimes for edge devices including [software-defined vehicles](https://www.secondstate.io/articles/second-state-joins-the-autoware-foundation/) and smart factories

However, in those cloud-native use cases, developers often want to use JavaScript to write business applications. That means we must now support [JavaScript in WebAssembly](https://github.com/WasmEdge/WasmEdge/blob/master/docs/run_javascript.md). Furthermore, we should support calling C/C++ or Rust functions from JavaScript in a WebAssembly runtime to take advantage of WebAssembly’s computational efficiency. The WasmEdge WebAssembly runtime allows you to do exactly that.

![Figure 2. WebAssembly and JavaScript in the cloud.](https://cdn-images-1.medium.com/max/2000/1*OmqZydcKW18qNIbVKs0J3A.png)

## WasmEdge

[WasmEdge](https://github.com/WasmEdge/WasmEdge) is a leading cloud-native WebAssembly runtime [hosted by the CNCF](https://www.secondstate.io/articles/wasmedge-joins-cncf/) (Cloud Native Computing Foundation) / Linux Foundation. It is the fastest WebAssembly runtime in the market today. WasmEdge supports all standard WebAssembly extensions as well as proprietary extensions for Tensorflow inference, KV store, and image processing, etc. Its compiler toolchain supports not only WebAssembly languages such as C/C++, Rust, Swift, Kotlin, and AssemblyScript but also [regular JavaScript](https://github.com/WasmEdge/WasmEdge/blob/master/docs/run_javascript.md).

A WasmEdge application can be embedded into a [C](https://github.com/WasmEdge/WasmEdge/blob/master/docs/c_api_quick_start.md) program, a [Go](https://www.secondstate.io/articles/extend-golang-app-with-webassembly-rust/) program, a [Rust](https://github.com/WasmEdge/WasmEdge/tree/master/wasmedge-rs) program, a [JavaScript](https://www.secondstate.io/articles/getting-started-with-rust-function/) program, or the operating system’s [CLI](https://github.com/WasmEdge/WasmEdge/blob/master/docs/run.md). The runtime can be managed by Docker tools (eg [CRI-O](https://www.secondstate.io/articles/manage-webassembly-apps-in-wasmedge-using-docker-tools/)), orchestration tools (eg K8s), serverless platforms (eg [Vercel](https://www.secondstate.io/articles/vercel-wasmedge-webassembly-rust/), [Netlify](https://www.secondstate.io/articles/netlify-wasmedge-webassembly-rust-serverless/), [AWS Lambda](https://www.cncf.io/blog/2021/08/25/webassembly-serverless-functions-in-aws-lambda/), [Tencent SCF](https://github.com/second-state/tencent-scf-wasm-runtime)), and data streaming frameworks (eg [YoMo](https://www.secondstate.io/articles/yomo-wasmedge-real-time-data-streams/) and Zenoh).

Now, you can run JavaScript programs in WasmEdge powered serverless functions, microservices, and AIoT applications! It not only runs plain JavaScript programs but also allows developers to use Rust and C/C++ to create new JavaScript APIs within the safety sandbox of WebAssembly.

## Building a JavaScript engine in WasmEdge

First, let’s build a WebAssmbly-based JavaScript interpreter program for WasmEdge. It is based on [QuickJS](https://bellard.org/quickjs/) with WasmEdge extensions, such as [network sockets](https://github.com/second-state/wasmedge_wasi_socket) and [Tensorflow inference](https://www.secondstate.io/articles/wasi-tensorflow/), incorporated into the interpreter as JavaScript APIs. You will need to [install Rust](https://www.rust-lang.org/tools/install) to build the interpreter.

> **If you just want to use the interpreter to run JavaScript programs, you can skip this section.**

Fork or clone [the wasmegde-quickjs Github repository](https://github.com/second-state/wasmedge-quickjs) to get started.

```bash
$ git clone https://github.com/second-state/wasmedge-quickjs
```

Following the instructions from that repo, you will be able to build a JavaScript interpreter for WasmEdge.

```bash
$ rustup target add wasm32-wasi
$ cargo build --target wasm32-wasi --release
```

The WebAssembly-based JavaScript interpreter program is located in the build target directory.

```bash
$ ls target/wasm32-wasi/debug/quickjs-rs-wasi.wasm
```

Next, let’s try some JavaScript programs.

## A JavaScript networking example

The interpreter supports the WasmEdge networking socket extension so that your JavaScript can make HTTP connections to the Internet. Here is an example of JavaScript.

```js
let r = GET("http://18.235.124.214/get?a=123",{"a":"b","c":[1,2,3]})
print(r.status)
    
let headers = r.headers
print(JSON.stringify(headers))

let body = r.body;
let body_str = new Uint8Array(body)
print(String.fromCharCode.apply(null,body_str))
```

To run the JavaScript in the WasmEdge runtime, you can do this on the CLI.

```bash
$ wasmedge --dir .:. target/wasm32-wasi/debug/quickjs-rs-wasi.wasm example_js/http_demo.js
```

You should now see the HTTP GET result printed on the console.

## A JavaScript Tensorflow inference example

The interpreter supports the WasmEdge Tensorflow lite inference extension so that your JavaScript can run an ImageNet model for image classification. Here is an example of JavaScript.

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

To run the JavaScript in the WasmEdge runtime, you can do this on the CLI.

```bash
$ wasmedge --dir .:. target/wasm32-wasi/debug/quickjs-rs-wasi.wasm example_js/tensorflow_lite_demo/main.js
```

You should now see the name of the food item recognized by the TensorFlow lite imagenet model.

## Incorporating JavaScript into Rust

The above two examples demonstrate how to use the pre-built `quickjs-rs-wasi.wasm` application in WasmEdge. Besides using the CLI, you could use Docker / Kubernetes tools to start the WebAssembly application or to embed the application into your own applications or frameworks as we discussed earlier in this article.

Alternatively, you can create your own Rust function that embeds a JavaScript program as a string variable or takes a JavaScript program from the function input parameter. You can refer to the [main.rs](https://github.com/second-state/wasmedge-quickjs/blob/main/src/main.rs) application in the template, which reads the JavaScript program as a string from a file.

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

This approach enables developers to mix and match high-performance Rust together with easy-to-use JavaScript, and to create a single `.wasm` file for the application so that it can be more easily deployed and managed.

## A note on QuickJS

Now, the choice of QuickJS as our JavaScript engine might raise the question of performance. Isn’t QuickJS [a lot slower](https://bellard.org/quickjs/bench.html) than v8 due to a lack of JIT support? Yes, but …

First of all, QuickJS is a lot smaller than v8. In fact, it only takes 1/40 (or 2.5%) of the runtime resources v8 consumes. You can run a lot more QuickJS functions than v8 functions on a single physical machine.

Second, for most business logic applications, raw performance is not critical. The application may have computationally intensive tasks, such as AI inference on the fly. WasmEdge allows the QuickJS applications to drop to high-performance WebAssembly for these tasks while it is not so easy with v8 to add such extensions modules.

Third, it is known that [many JavaScript security issues arise from JIT](https://www.theregister.com/2021/08/06/edge_super_duper_security_mode/). Maybe turning off JIT in the cloud-native environment is not such a bad idea!

JavaScript in cloud-native WebAssembly is still an emerging area in the next generation of cloud and edge computing infrastructure. We are just getting started! If you are interested, join us in the WasmEdge project (or tell us what you want by raising feature request issues).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
