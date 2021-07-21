> - 原文地址：[FFmpeg + WebAssembly](https://dev.to/alfg/ffmpeg-webassembly-2cbl)
> - 原文作者：[alfg](https://dev.to/alfg)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/ffmpeg-webassembly.md](https://github.com/xitu/gold-miner/blob/master/article/2021/ffmpeg-webassembly.md)
> - 译者：[finalwhy](https://github.com/finalwhy)
> - 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[Chorer](https://github.com/Chorer)

# FFmpeg + WebAssembly

![](https://res.cloudinary.com/practicaldev/image/fetch/s--JZhzlW_S--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/dktx72lm8zpz9wodh95m.jpeg)

[FFmpeg](https://ffmpeg.org) 是一个强大的命令行工具，它能够处理包括视频、音频和其他多媒体文件，甚至包括流媒体。对于任何视频开发者来说，它都是用于编辑、转化以及混流几乎任何格式的重要工具。它是用 C 开发的，因此可用于绝大多数平台。

但 FFmpeg 不仅仅只是一个命令行工具。它是由被称为 libav 的一些 FFmpeg 库提供支持。这些库赋予了 FFmpeg 读取、写入和处理多媒体文件的能力。这些库为混流、编/解码、过滤、缩放、色域转换以及底层接口提供功能支持。如果你使用 C/C++ 开发应用，你可以直接调用这些库。很多常见的语言也集成了 libav 库。

> 假如你能在浏览器中调用 FFmpeg 的库呢？

运行在浏览器中的 JavaScript 非常与众不同。它被设计成不能在浏览器环境中运行系统级的应用。那么我们要怎么在浏览器中使用 FFmpeg 呢？答案是使用 WebAssembly！

WebAssembly（或者叫 Wasm）近年来逐渐流行起来，原因是它能够让我们在浏览器中运行二进制指令。通过一套编译工具链，我们可以将 C/C++ 代码构建为 Wasm。

这项工作目前已经有人实现了。你可以看一看 [ffmpeg.wasm](https://github.com/ffmpegwasm/ffmpeg.wasm) ，这个文件能够让你在浏览器环境中运行 FFmpeg CLI 工具。

但是，本文的关注点并非 FFmpeg CLI，而是如何一步步将 FFmpeg 的 `libav` 库编译为 WebAssembly 并在浏览器中使用。

## 为什么？🤔

因为与运行在原生系统环境中相比，在浏览器环境中运行 FFmpeg 并不能发挥其最大的性能。当 FFmpeg 在原生的操作系统环境中运行时，它能充分享受到多线程处理和硬件加速带来的优势。

通常情况下，你只需要搭建一个包含 FFmpeg 或 libav 的后端服务，然后与前端对接并发送处理结果。

然而，我们仍然可以使用 FFmpeg 库提供的强大功能，例如解析多媒体格式、编解码信息、解码音视频帧、使用过滤器等。想象一下，我们能够在浏览器环境中的一个静态 Web 页面上，仅仅使用 JavaScript 就能完成这些操作。

## 初尝 `libav`

让我们从一个简单的 C 程序开始，在本程序中我使用 libav 库输出基本的媒体信息。我们将它命名为 `mp4info.c`。

如果你不了解 `libav`，[ffmpeg-libav-tutorial](https://github.com/leandromoreira/ffmpeg-libav-tutorial) 是一份不错的指南。

```cpp
#include <stdio.h>
#include <libavformat/avformat.h>

static AVFormatContext *fmt_ctx;

int main(int argc, const char *argv[])
{
  if (argc < 2) {
    printf("Please specify a media file.\n");
    return -1;
  }

  // 打开多媒体文件并读取文件头
  int ret;
  if ((ret = avformat_open_input(&fmt_ctx, argv[1], NULL, NULL)) < 0) {
      printf("%s", av_err2str(ret));
      return ret;
  }

  // 读取包含的数据
  printf("format: %s, duration: %ld us, streams: %d\n",
    fmt_ctx->iformat->name,
    fmt_ctx->duration,
    fmt_ctx->nb_streams);

  return 0;
}
```

这是一个基础的程序，它读取一个媒体文件作为参数，然后打印出这个媒体文件的格式、时长和流的数量。

让我们来编译并运行这个程序：
[下载钢铁之泪（时长 10s）样例](https://github.com/alfg/ffmpeg-webassembly-example/blob/master/tears-of-steel-10s.mp4?raw=true)

```shell
gcc src/mp4info.c -lavformat -lavutil -o bin/mp4info
./bin/mp4info tears-of-steel-10s.mp4
```

**构建时需要使用 `gcc`, `ffmpeg` 和 `ffmpeg-dev`**

你将会得到如下的输出。

```shell
format: mov,mp4,m4a,3gp,3g2,mj2, duration: 10000000 us, streams: 2
```

非常好！现在我们可以进行下一步了，即使用 Emscripten 来编译 FFmpeg 并为其构建一个包装器，以便在 JavaScript 环境中使用。

## Emscripten

Emscripten 是 WebAssembly 的一套编译工具链。我们会使用 [Docker](https://www.docker.com/) 和 [emscripten](https://emscripten.org/) 将 FFmpeg 的 `libav` 库和我们自定义的包装器编译为 Wasm。让我们先从 FFmpeg 开始。

## 将 FFmpeg 编译为 WebAssembly

在我们的 Dockerfile 中，我们将使用基础的 emscripten emsdk 从源代码构建 FFmpeg，以及最新的稳定版 `libx264` 库。

由于我们需要编译到 WebAssembly，我们将通过禁用所有程序并仅启用我们需要使用的功能来进行最小构建。这将有助于保持二进制的体积最小和最佳。

```dockerfile
FROM emscripten/emsdk:2.0.16 as build

ARG FFMPEG_VERSION=4.3.2
ARG X264_VERSION=20170226-2245-stable

ARG PREFIX=/opt/ffmpeg
ARG MAKEFLAGS="-j4"

# 构建依赖。
RUN apt-get update && apt-get install -y autoconf libtool build-essential

# 下载并构建 x264。
RUN cd /tmp && \
  wget https://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 && \
  tar xvfj x264-snapshot-${X264_VERSION}.tar.bz2

RUN cd /tmp/x264-snapshot-${X264_VERSION} && \
  emconfigure ./configure \
  --prefix=${PREFIX} \
  --host=i686-gnu \
  --enable-static \
  --disable-cli \
  --disable-asm \
  --extra-cflags="-s USE_PTHREADS=1"

RUN cd /tmp/x264-snapshot-${X264_VERSION} && \
  emmake make && emmake make install

# 下载 ffmpeg 发布的源码
RUN cd /tmp/ && \
  wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
  tar zxf ffmpeg-${FFMPEG_VERSION}.tar.gz && rm ffmpeg-${FFMPEG_VERSION}.tar.gz

ARG CFLAGS="-s USE_PTHREADS=1 -O3 -I${PREFIX}/include"
ARG LDFLAGS="$CFLAGS -L${PREFIX}/lib -s INITIAL_MEMORY=33554432"

# 使用 emscripten 配置和构建 FFmpeg。
# 禁用其他所有程序，只开启我们需要的功能
# https://github.com/FFmpeg/FFmpeg/blob/master/configure
RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  emconfigure ./configure \
  --prefix=${PREFIX} \
  --target-os=none \
  --arch=x86_32 \
  --enable-cross-compile \
  --disable-debug \
  --disable-x86asm \
  --disable-inline-asm \
  --disable-stripping \
  --disable-programs \
  --disable-doc \
  --disable-all \
  --enable-avcodec \
  --enable-avformat \
  --enable-avfilter \
  --enable-avdevice \
  --enable-avutil \
  --enable-swresample \
  --enable-postproc \
  --enable-swscale \
  --enable-filters \
  --enable-protocol=file \
  --enable-decoder=h264,aac,pcm_s16le \
  --enable-demuxer=mov,matroska \
  --enable-muxer=mp4 \
  --enable-gpl \
  --enable-libx264 \
  --extra-cflags="$CFLAGS" \
  --extra-cxxflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --nm="llvm-nm -g" \
  --ar=emar \
  --as=llvm-as \
  --ranlib=llvm-ranlib \
  --cc=emcc \
  --cxx=em++ \
  --objcc=emcc \
  --dep-cc=emcc

RUN cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
  emmake make -j4 && \
  emmake make install
```

```shell
docker build -t mp4info .
```

以上操作会将构建 ffmpeg 的库并安装到 `/opt/ffmpeg` 中。但我们仍然需要使用之前编写的 Hello World 示例来编写包装器。

## 编写包装器

现在我们可以将 FFmpeg 的库文件构建为 Wasm 了，我们需要创建一个集成了 emscripten 功能的包装器，以方便我们在浏览器中通过 JavaScript 引入和使用。

我们会使用 C++ 编写自定义包装器，并利用 [Embind](https://emscripten.org/docs/porting/connecting_cpp_and_javascript/embind.html)。

在 Embind 的文档中这样写到：

> Embind 用于将 C++ 的函数和类绑定到 JavaScript，这样编译产出的代码就可以在 JavaScript 中以常规的方式调用。

这使得我们能很简单地从 C++ 的结构中创建绑定。所以让我们开始吧！

将我们的 Hello World 样例改为用 C++ 编写。

`mp4info-wrapper.cpp`：

```cpp
#include <emscripten.h>
#include <emscripten/bind.h>
#include <inttypes.h>

#include <string>
#include <vector>

using namespace emscripten;

extern "C"
{
#include <libavformat/avformat.h>
};

typedef struct Response
{
  std::string format;
  int duration;
  int streams;
} Response;

static AVFormatContext *fmt_ctx;

Response run(std::string filename)
{
  // 打开文件并读取头信息。
  int ret;
  if ((ret = avformat_open_input(&fmt_ctx, filename.c_str(), NULL, NULL)) < 0)
  {
    printf("%s", av_err2str(ret));
  }

  // 读取容器数据.
  printf("format: %s, duration: %lld us, streams: %d\n",
         fmt_ctx->iformat->name,
         fmt_ctx->duration,
         fmt_ctx->nb_streams);

  // 使用读取到的格式数据填充 response 结构体。
  Response r = {
      .format = fmt_ctx->iformat->name,
      .duration = (int)fmt_ctx->duration,
      .streams = (int)fmt_ctx->nb_streams,
  };

  return r;
}

EMSCRIPTEN_BINDINGS(structs)
{
  emscripten::value_object<Response>("Response")
      .field("format", &Response::format)
      .field("duration", &Response::duration)
      .field("streams", &Response::streams);
  function("run", &run);
}
```

显著的变化包括:

- C 实现变成了 C++ 实现
- 引入 `emscripten` 头文件
- 创建了一个 `Response` 类型定义
- `main` 函数改为 `run` 函数, 接受一个文件名参数并返回一个 `Response` 类型的结构体，其中包含格式、时长和流计数。
- 增加了 `EMSCRIPTEN_BINDINGS` 用于暴露绑定了 `Response` 类型的 `run` 方法。

为 `emcc` 增加一个 `Makefile` 文件用于构建这个包装器：

```make
dist/mp4info.wasm.js:
    mkdir -p dist && \
    emcc --bind \
    -O3 \
    -L/opt/ffmpeg/lib \
    -I/opt/ffmpeg/include/ \
    -s EXTRA_EXPORTED_RUNTIME_METHODS="[FS, cwrap, ccall, getValue, setValue, writeAsciiToMemory]" \
    -s INITIAL_MEMORY=268435456 \
    -s ASSERTIONS=1 \
    -s STACK_OVERFLOW_CHECK=2 \
    -s PTHREAD_POOL_SIZE_STRICT=2 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -lavcodec -lavformat -lavfilter -lavdevice -lswresample -lpostproc -lswscale -lavutil -lm \
    -pthread \
    -lworkerfs.js \
    -o dist/mp4info.js \
    src/mp4info-wrapper.cpp
```

然后在我们的 Dockerfile 中添加以下几行：

```dockerfile
COPY ./src/mp4info-wrapper.cpp /build/src/mp4info-wrapper.cpp
COPY ./Makefile /build/Makefile

WORKDIR /build
```

现在让我们通过 Docker 构建一个挂载的卷。这样我们就可以轻松地从容器构建一个工件到主机。

```shell
docker run -v ${pwd}:/build -it mp4info make
```

最终我们会将以下几个文件构建到 `dist/` 目录下：

```shell
dist
├───mp4info.js
├───mp4info.wasm
└───mp4info.worker.js
```

现在，你的 WebAssembly 已经可以在 JavaScript 中使用了！🎉

## 编写 JavaScript 代码

接下来，我们将只使用 HTML 和 JavaScript 来构建一个静态网页。

让我们来创建一个基础的 `index.html` 页面，这个页面中只包含一个用于上传文件的输入框以及一个用于展示结果的 `div`：

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>FFmpeg WebAssembly Example</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
  </head>
  <body>
    <div>
      <input id="file" type="file" />
    </div>
    <div id="results"></div>
  </body>
</html>
```

因为我们的 `mp4info` 包装器是由同步的 C++ 代码编译而来，所以当它在处理较大的文件时，它会阻塞浏览器的主线程。这将导致浏览器的 UI 被锁定，用户体验较差。

但是，我们可以利用 [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) 将任务转到后台运行，只将最后的处理结果返回给主线程。这样就能避免因为同步代码导致的线程阻塞。

我们创建一个新的包含如下代码的 `worker.js` 文件：

```javascript
// 将以下脚本作为一个 Web Worker 来运行，这样它就不会阻塞
// 浏览器主线程。
// 详见：index.html。
onmessage = e => {
  const file = e.data[0];
  let data;

  // 创建并挂载 FS 工作目录.
  if (!FS.analyzePath('/work').exists) {
    FS.mkdir('/work');
  }
  FS.mount(WORKERFS, { files: [file] }, '/work');

  // 运行我们暴露的 Wasm 函数
  const info = Module.run('/work/' + file.name);
  console.log(info);

  // 将消息发送回主线程
  postMessage(info);

  // 卸载工作目录
  FS.unmount('/work');
};

// 从 E Emscripten 构建工具生成的代码中引入 Wasm 装载器
self.importScripts('mp4info.js');
```

此处包含一个消息监听器，它使用 `Emscripten` [Filesystem API](https://emscripten.org/docs/api_reference/Filesystem-API.html) 创建了一个虚拟的文件系统，运行我们的 Wasm 模块代码，并使用 `postMessage` 将结果发回主线程。

现在，将以下代码加到你的 `index.html` 中的 `</html>` 行之前：

```html
<script>
  // 创建一个 web worker 用于运行 Wasm 代码，并且不会阻塞主线程。
  const worker = new Worker('worker.js');

  const input = document.querySelector('input');
  input.addEventListener('change', onFileChange);

  // 监听从 worker 中返回的消息，并渲染到 Dom
  worker.onmessage = e => {
    const data = e.data;
    const results = document.getElementById('results');
    const ul = document.createElement('ul');
    const li = document.createElement('li');
    li.textContent = 'format: ' + data.format;
    const li2 = document.createElement('li');
    li2.textContent = 'duration: ' + data.duration;
    const li3 = document.createElement('li');
    li3.textContent = 'streams: ' + data.streams;
    ul.appendChild(li);
    ul.appendChild(li2);
    ul.appendChild(li3);
    results.appendChild(ul);
  };

  // 向 worker 发送文件
  function onFileChange(event) {
    const file = input.files[0];
    worker.postMessage([file]);
  }
</script>
```

此处在 `input` 表单元素上创建了一个事件监听器用于将上传的文件发送给 Web Worker。同时，也创建了一个消息监听器用于接受从 `worker.js` 中返回的消息，以便我们可以将结果渲染到 DOM 上。

接下来我们将 `index.html`、`worker.js` 和 Wasm 相关的文件放到一个新目录 `www` 中：

```shell
www
├───index.html
├───worker.js
├───mp4info.js
├───mp4info.wasm
└───mp4info.worker.js
```

在浏览器载入 `index.html` 之前，我们的 Wasm 模块会使用 [PTHREADS](https://emscripten.org/docs/porting/pthreads.html)，但在一些浏览器中会导致一个安全问题。在 Emscripten 文档中：

> 浏览器会在跨源开放者策略（Cross Origin Opener Policy，COOP）和跨源嵌入程序策略（Cross Origin Embedder Policy，COEP）请求头通过验证后才会响应 SharedArrayBuffer。除非正确设置这些标头，否则 Pthreads 代码将无法在部署环境中工作。

因此当服务器为我们的网页提供响应时，需要提供正确的请求头：

```http request
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

在使用 [Express](https://expressjs.com/) 框架的 [NodeJS](https://nodejs.org/en/) 中，我们可以很简单地实现以上操作：

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.use((req, res, next) => {
  // CORS headers.
  res.append('Access-Control-Allow-Origin', ['*']);
  res.append('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
  res.append('Access-Control-Allow-Headers', 'Content-Type');

  // Required headers for SharedArrayBuffer.
  // See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer#security_requirements
  res.append('Cross-Origin-Opener-Policy', 'same-origin');
  res.append('Cross-Origin-Embedder-Policy', 'require-corp');
  next();
});
app.use(express.static(__dirname));
app.listen(port);
```

但是，请记住，如果部署到任何静态网页提供程序，您将需要添加这些响应头。

## 样例时间!

启动服务器（需要 [NodeJS](https://nodejs.org/en/)）：

```shell
npm install express
node server.js
```

在浏览器中输入 [http://localhost:8080/www](http://localhost:8080/www) 并选择一个 mp4 文件。

[![Alt Text](https://res.cloudinary.com/practicaldev/image/fetch/s--7Ux4Erxc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/nx1lp38jqe13cdu7a5k1.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--7Ux4Erxc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/nx1lp38jqe13cdu7a5k1.png)

**这就是你在浏览器中运行 FFmpeg 的 `libav` 库的结果!** ⚡

这只是 FFmpeg + WebAssembly 的能力的皮毛。你可以使用 `libav` 来做更多的事情，而不仅仅是读取媒体格式的详细信息。查看更多 [libav 示例](http://ffmpeg.org/doxygen/4.1/examples.html) 并尝试将它们移植到 WebAssembly。

## 感谢阅读!

你可以在 [https://github.com/alfg/ffmpeg-webassembly-example](https://github.com/alfg/ffmpeg-webassembly-example) 中找到本文中的完整样例文件。

我还有一个优秀的例子，是关于通过 Wasm 来使用 FFProbe：
[https://github.com/alfg/ffprobe-wasm](https://github.com/alfg/ffprobe-wasm)

我的 Github 主页: [https://github.com/alfg](https://github.com/alfg)

## 引用和资源

- [https://webassembly.org/](https://webassembly.org/)
- [https://emscripten.org/](https://emscripten.org/)
- [http://ffmpeg.org/doxygen/4.1/examples.html](http://ffmpeg.org/doxygen/4.1/examples.html)
- [https://github.com/alfg/libav-examples](https://github.com/alfg/libav-examples)
- [https://github.com/alfg/ffprobe-wasm](https://github.com/alfg/ffprobe-wasm)
- [https://github.com/alfg/ffmpeg-webassembly-example](https://github.com/alfg/ffmpeg-webassembly-example)

欢迎指正! 🎥

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
