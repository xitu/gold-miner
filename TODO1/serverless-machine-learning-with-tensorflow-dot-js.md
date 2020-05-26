> * 原文地址：[Serverless Machine Learning With TensorFlow.js](http://jamesthom.as/blog/2018/08/13/serverless-machine-learning-with-tensorflow-dot-js/)
> * 原文作者：[jamesthom](http://jamesthom.as)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-machine-learning-with-tensorflow-dot-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-machine-learning-with-tensorflow-dot-js.md)
> * 译者：[wzasd](wzasd.github.com)
> * 校对者：[haiyang-tju](https://github.com/haiyang-tju)

# 基于 TensorFlow.js 的无服务架构机器学习

在[以前的博客中](http://jamesthom.as/blog/2018/08/07/machine-learning-in-node-dot-js-with-tensorflow-dot-js/)，我讲解了如何使用 [TensorFlow.js](https://js.tensorflow.org/) 在 Node.js 上来运行[在本地图像中进行的视觉识别](https://gist.github.com/jthomas/145610bdeda2638d94fab9a397eb1f1d#file-script-js)。TensorFlow.js 是来自 Google 的开源机器学习库中的 JavaScript 版本。

当我将本地的 Node.js 脚本跑通，我的下一个想法就是将其转换成为无服务功能。我将会在 [IBM Cloud Functions](https://console.bluemix.net/openwhisk/)（[Apache OpenWhisk](https://openwhisk.incubator.apache.org/)）运行此功能并将脚本转换成自己的用于视觉识别的微服务。

![](http://jamesthom.as/images/tfjs-serverless/tf-js-example.gif "使用 TensorFlow.js 实现的无服务功能")

看起来很简单，对吧？它只是一个 JavaScript 库？因此，解压它然后我们进入正题… **啊哈** 👊；

**将图像分类脚本转换并运行在无服务架构环境中具有以下挑战：**

*   **TensorFlow.js 库需要在运行时加载。**
*   **必须根据平台体系结构对库文件的本地绑定进行编译。**
*   **需要从文件系统来加载模型文件。**                                                                                                   
    
其中有一些问题会比其它问题更具有挑战性！让我们在解释如何使用 Apache OpenWhisk 中的 [Docker support](http://jamesthom.as/blog/2017/01/16/openwhisk-docker-actions/) 来解决每个问题之前，我们先看一下每个问题的细节部分。

## 挑战

### TensorFlow.js 库

TensorFlow.js 库不包括在 Apache OpenWhisk 提供的 [Node.js 运行时的库](https://github.com/apache/incubator-openwhisk-runtime-nodejs)


外部库可以通过从zip文件中部署应用程序的方式[导入到运行时](http://jamesthom.as/blog/2016/11/28/npm-modules-in-openwhisk/)时。zip 文件中包含自定义文件夹 `node_modules` 被提取到运行时中。Zip 文件的大小最大[限制为 48 MB](https://github.com/apache/incubator-openwhisk/blob/master/docs/reference.md#actions)。

#### 库大小

使用 TensorFlow.js 库需要运行命令 `npm install` 这里会出现第一个问题……即生成的 `node_modules` 文件夹大小为 175MB。😱

查看该文件夹的内容，`tfjs-node` 模块编译一个 135M 的[本地共享库](https://github.com/tensorflow/tfjs-node/tree/master/src)（`libtensorflow.so`）。这意味着，在这个神奇的 48 MB 限制规则下，没有多少 JavaScript 可以缩小到限制要求以获得这些外部依赖。👎

#### 本地依赖

本地共享库  `libtensorflow.so` 必须使用平台运行时来进行编译。在本地运行 `npm install` 会自动编译针对主机平台的机器依赖项。本地环境可能使用不同的 CPU 体系结构（Mac 与 Linux）或链接到无服务运行时中不可用的共享库。

### MobileNet 模型文件

TensorFlow 模型文件[需要在 Node.js 中从文件系统进行加载](https://js.tensorflow.org/tutorials/model-save-load.html)。无服务运行时确实在运行时环境中提供临时文件系统。zip 部署文件中的相关文件在调用前会自动解压缩到此环境中。在无服务功能的生命周期之外，没有对该文件系统的外部访问。

MobileNet 模型文件有 16MB。如果这些文件包含在部署包中，则其余的应用程序源代码将会留下 32MB 的大小。虽然模型文件足够小，可以包含在 zip 文件中，但是 TensorFlow.js 库呢？这是这篇文章的结尾吗？没那么快…。

**Apache OpenWhisk 对自定义运行时的支持为所有这些问题提供了简单的解决方案！**

## 自定义运行时

Apache OpenWhisk 使用 Docker 容器作为无服务功能（操作）的运行时环境。所有的平台运行时的镜像都在 [Docker Hub 发布](https://hub.docker.com/r/openwhisk/)，允许开发人员在本地启动这些环境。

开发人员也可以在创建操作的时候[自定义运行映像](https://github.com/apache/incubator-openwhisk/blob/master/docs/actions-docker.md)。这些镜像必须在 Docker Hub 上公开。自定义运行时必须公开平台用于调用[相同的 HTTP API](https://github.com/apache/incubator-openwhisk/blob/master/docs/actions-new.md#action-interface)。

将平台运行时的映像用作[父映像](https://docs.docker.com/glossary/?term=parent%20image)可以使构建自定义运行时变得简单。用户可以在 Docker 构建期间运行命令以安装其他库和其他依赖项。父映像已包含具有 Http API 服务处理平台请求的源文件。

### TensorFlow.js 运行时

以下是 Node.js 操作运行时的 Docker 构建文件，其中包括其它 TensorFlow.js 依赖项。

```
FROM openwhisk/action-nodejs-v8:latest

RUN npm install @tensorflow/tfjs @tensorflow-models/mobilenet @tensorflow/tfjs-node jpeg-js

COPY mobilenet mobilenet
```

`openwhisk/action-nodejs-v8:latest` 是 OpenWhisk 发布的安装了 Node.js 运行时的映像。

在构建过程中使用 `npm install` 安装 TensorFlow 库和其他依赖项。在构建过程中安装库 `@tensorflow/tfjs-node` 的本地依赖项，可以自动对应平台进行编译。

由于我正在构建一个新的运行时，我还将 [MobileNet 模型文件](https://github.com/tensorflow/tfjs-models/tree/master/mobilenet)添加到镜像中。虽然不是绝对必要，但从运行 zip 文件中删除它们可以减少部署时间。

**想跳过下一步吗？使用这个镜像 [`jamesthomas/action-nodejs-v8:tfjs`](https://hub.docker.com/r/jamesthomas/action-nodejs-v8/) 而不是自己来创建的。**

### 构建运行时

**在[之前的博客](http://jamesthom.as/blog/2018/08/07/machine-learning-in-node-dot-js-with-tensorflow-dot-js/)中，我展示了如何从公共库下载模型文件。**

*   下载 MobileNet 模型的一个版本并将所有文件放在 `mobilenet` 目录中。
*   复制 Docker 构建文件到本地，并将其命名为 `Dockerfile`。
*   运行 Docker [build command](https://docs.docker.com/engine/reference/commandline/build/) 生成本地映像。

```
docker build -t tfjs .
```

*   使用远程用户名和存储库[标记本地映像](https://docs.docker.com/engine/reference/commandline/tag/)。

```
docker tag tfjs <USERNAME>/action-nodejs-v8:tfjs
```

**用你自己的 Docker Hub 用户名替换 `<USERNAME>`**

*   [推送本地映像](https://docs.docker.com/engine/reference/commandline/push/)到 Docker Hub

```
docker push <USERNAME>/action-nodejs-v8:tfjs
```

一旦 Docker Hub 上的镜像[可用](https://hub.docker.com/r/jamesthomas/action-nodejs-v8/)，就可以使用该运行时映像创建操作。😎

## 示例代码

此代码将图像分类实现为 OpenWhisk 操作。使用事件参数上的 `image` 属性将图像文件作为 Base64 编码的字符串提供。分类结果作为响应中的 `results` 属性返回。

```
const tf = require('@tensorflow/tfjs')
const mobilenet = require('@tensorflow-models/mobilenet');
require('@tensorflow/tfjs-node')

const jpeg = require('jpeg-js');

const NUMBER_OF_CHANNELS = 3
const MODEL_PATH = 'mobilenet/model.json'

let mn_model

const memoryUsage = () => {
  let used = process.memoryUsage();
  const values = []
  for (let key in used) {
    values.push(`${key}=${Math.round(used[key] / 1024 / 1024 * 100) / 100} MB`);
  }

  return `memory used: ${values.join(', ')}`
}

const logTimeAndMemory = label => {
  console.timeEnd(label)
  console.log(memoryUsage())
}

const decodeImage = source => {
  console.time('decodeImage');
  const buf = Buffer.from(source, 'base64')
  const pixels = jpeg.decode(buf, true);
  logTimeAndMemory('decodeImage')
  return pixels
}

const imageByteArray = (image, numChannels) => {
  console.time('imageByteArray');
  const pixels = image.data
  const numPixels = image.width * image.height;
  const values = new Int32Array(numPixels * numChannels);

  for (let i = 0; i < numPixels; i++) {
    for (let channel = 0; channel < numChannels; ++channel) {
      values[i * numChannels + channel] = pixels[i * 4 + channel];
    }
  }

  logTimeAndMemory('imageByteArray')
  return values
}

const imageToInput = (image, numChannels) => {
  console.time('imageToInput');
  const values = imageByteArray(image, numChannels)
  const outShape = [image.height, image.width, numChannels];
  const input = tf.tensor3d(values, outShape, 'int32');

  logTimeAndMemory('imageToInput')
  return input
}

const loadModel = async path => {
  console.time('loadModel');
  const mn = new mobilenet.MobileNet(1, 1);
  mn.path = `file://${path}`
  await mn.load()
  logTimeAndMemory('loadModel')
  return mn
}

async function main (params) {
  console.time('main');
  console.log('prediction function called.')
  console.log(memoryUsage())

  console.log('loading image and model...')

  const image = decodeImage(params.image)
  const input = imageToInput(image, NUMBER_OF_CHANNELS)

  if (!mn_model) {
    mn_model = await loadModel(MODEL_PATH)
  }

  console.time('mn_model.classify');
  const predictions = await mn_model.classify(input);
  logTimeAndMemory('mn_model.classify')

  console.log('classification results:', predictions);

  // free memory from TF-internal libraries from input image
  input.dispose()
  logTimeAndMemory('main')

  return { results: predictions }
}
```

### 缓存加载的模型

无服务的平台按需初始化运行环境用以处理调用。一旦运行环境被创建，他将会对[重新调用](https://medium.com/openwhisk/squeezing-the-milliseconds-how-to-make-serverless-platforms-blazing-fast-aea0e9951bd0)有一些限制。

应用程序可以通过使用全局变量来维护跨请求的状态来利用此方式。这通常用于[已打开的数据库缓存方式](https://blog.rowanudell.com/database-connections-in-lambda/)或存储从外部系统加载的初始化数据。

我使用这种模式来[缓存 MobileNet 模型](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L80-L82)用于分类任务。在冷调用期间，模型从文件系统加载并存储在全局变量中。然后，热调用就会利用这个已存在的全局变量来处理进一步的请求，从而跳过模型的再次加载过程。

缓存模型可以减少热调用分类的时间（从而降低成本）。

### 内存泄漏

可以通过最简化的修改从 IBM Cloud Functions 上的博客文章来运行 Node.js 脚本。不幸的是，性能测试显示处理函数中存在内存泄漏。😢

**在 Node.js 上阅读更多关于 [TensorFlow.js 如何工作](https://js.tensorflow.org/tutorials/core-concepts.html)的信息，揭示了这个问题...**

TensorFlow.js 的 Node.js 扩展使用本地 C++ 库在 CPU 或 GPU 引擎上计算 Tensors。为应用程序显式释放它或进程退出之前，将保留为本机库中的 Tensor 对象分配的内存。TensorFlow.js 在各个对象上提供 `dispose` 方法以释放分配的内存。 还有一个 `tf.tidy` 方法可以自动清理帧内所有已分配的对象。

检查代码，每个请求都会从图像创建图像张量[作为模型的输入](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L51-L59)。在从请求处理程序返回之前，这些生成的张量对象并未被销毁。这意味着本地内存会无限增长。在返回之前添加显式的 `dispose` 调用以释放这些对象可以[修复该问题](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L91)。

### 分析和性能

执行代码记录了分类处理过程中不同阶段的内存使用和时间消耗。

记录[内存使用情况](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L12-L20)可以允许我修改分配给该功能的最大内存，以获得最佳性能和成本。Node.js 提供[标准库 API](https://nodejs.org/docs/v0.4.11/api/all.html#process.memoryUsage) 来检索当前进程的内存使用情况。记录这些值允许我检查不同阶段的内存使用情况。

分类过程中的[不同任务](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L71)的耗时，也就是模型加载，图像分类等不同任务，这可以让我深入了解到与其它方法相比这里的分类方法的效率。Node.js 有一个[标准库 API](https://nodejs.org/api/console.html#console_console_time_label)，可以使用计时器将时间消耗进行记录和打印到控制台。

## 例子

### 部署代码

*   使用 [IBM Cloud CLI](https://console.bluemix.net/openwhisk/learn/cli) 运行以下命令以创建操作。

```
ibmcloud fn action create classify --docker <IMAGE_NAME> index.js
```

**使用自定义运行时的公共 Docker Hub 映像标识符替换 `<IMAGE_NAME>`。如果你并没有构建它，请使用 `jamesthomas/action-nodejs-v8:tfjs`。**

### 测试

*   从维基百科下载[此图片](https://upload.wikimedia.org/wikipedia/commons/f/fe/Giant_Panda_in_Beijing_Zoo_1.JPG)。

![](https://upload.wikimedia.org/wikipedia/commons/f/fe/Giant_Panda_in_Beijing_Zoo_1.JPG)

```
wget http://bit.ly/2JYSal9 -O panda.jpg
```

*   使用 Base64 编码图像作为调用方法的输入参数。

```
ibmcloud fn action invoke classify -r -p image $(base64 panda.jpg)
```

*   返回的 JSON 消息包含分类概率。🐼🐼🐼

```
{
  "results":  [{
    className: 'giant panda, panda, panda bear, coon bear',
    probability: 0.9993536472320557
  }]
}
```

### 激活的细节

*   检索上次激活的日志记录输出以显示性能数据。

```
ibmcloud fn activation logs --last
```

**分析和内存使用详细信息记录到 stdout**

```
prediction function called.
memory used: rss=150.46 MB, heapTotal=32.83 MB, heapUsed=20.29 MB, external=67.6 MB
loading image and model...
decodeImage: 74.233ms
memory used: rss=141.8 MB, heapTotal=24.33 MB, heapUsed=19.05 MB, external=40.63 MB
imageByteArray: 5.676ms
memory used: rss=141.8 MB, heapTotal=24.33 MB, heapUsed=19.05 MB, external=45.51 MB
imageToInput: 5.952ms
memory used: rss=141.8 MB, heapTotal=24.33 MB, heapUsed=19.06 MB, external=45.51 MB
mn_model.classify: 274.805ms
memory used: rss=149.83 MB, heapTotal=24.33 MB, heapUsed=20.57 MB, external=45.51 MB
classification results: [...]
main: 356.639ms
memory used: rss=144.37 MB, heapTotal=24.33 MB, heapUsed=20.58 MB, external=45.51 MB

```


`main` 是处理程序的总耗时。`mn_model.classify` 是图像分类的耗时。冷启动请求打印了一条带有模型加载时间的额外日志消息，`loadModel：394.547ms`。

## 性能结果

对冷激活和热激活（使用 256 MB 内存）调用 `classify` 动作 1000 次会产生以下结果。

### 热激活

![](http://jamesthom.as/images/tfjs-serverless/warm-activations.png "热激活的表现结果")

在热启动环境中，分类处理的平均耗时为 **316 毫秒**。查看耗时数据，将 Base64 编码的 JPEG 转换为输入张量大约需要 100 毫秒。运行模型进行分类任务的耗时为 200-250 毫秒。

### 冷激活

![](http://jamesthom.as/images/tfjs-serverless/cold-activations.png "冷激活的表现结果")

使用冷环境时，分类处理大的平均耗时 **1260 毫秒**。这些请求会因初始化新的运行时容器和从文件系统加载模型而受到限制。这两项任务都需要大约 400 毫秒的时间。

**在 Apache OpenWhisk 中使用自定义运行时映像的一个缺点是缺少[预热容器](https://medium.com/openwhisk/squeezing-the-milliseconds-how-to-make-serverless-platforms-blazing-fast-aea0e9951bd0)。预热是指在该容器在需要使用之前启动运行时容器，以减少冷启动的时间消耗。**

### 分类成本

IBM Cloud Functions 提供了一个每月 400,000 GB/s 流量的[免费等级](https://console.bluemix.net/openwhisk/learn/pricing)。每秒时间内的调用额外收费为 $0.000017 每 GB 的内存占用。执行时间四舍五入到最接近的 100 毫秒。

如果所有激活都是热激活的，那么用户可以在免费等级内使用 256MB 存储占用和**每月执行超过 4,000,000 个分类**。一旦超出免费等级范围，大约 600,000 次额外调用的花费才 $1 多一点。

如果所有激活都是冷激活的，那么用户可以在免费等级内使用 256MB 存储占用和**每月执行超过 1,2000,000 个分类**。一旦超出免费等级范围，大约 180,000 次额外调用的花费为 $1。

## 结论

TensorFlow.js 为 JavaScript 开发人员带来了深度学习的力量。使用预先训练的模型和 TensorFlow.js 库，可以轻松地以最少的工作量和代码扩展具有复杂机器学习任务的 JavaScript 应用程序。

获取本地脚本来运行图像分类相对简单，但转换为无服务器功能带来了更多挑战！Apache OpenWhisk 将最大应用程序大小限制为 50MB，本机库依赖项远大于此限制。

幸运的是，Apache OpenWhisk 的自定义运行时支持使我们能够解决所有这些问题。通过使用本机依赖项和模型文件构建自定义运行时，可以在平台上使用这些库，而无需将它们包含在部署包中。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
