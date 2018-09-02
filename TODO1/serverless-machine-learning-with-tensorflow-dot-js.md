> * 原文地址：[Serverless Machine Learning With TensorFlow.js](http://jamesthom.as/blog/2018/08/13/serverless-machine-learning-with-tensorflow-dot-js/)
> * 原文作者：[jamesthom](http://jamesthom.as)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-machine-learning-with-tensorflow-dot-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-machine-learning-with-tensorflow-dot-js.md)
> * 译者：
> * 校对者：

# Serverless Machine Learning With TensorFlow.js

In a [previous blog post](http://jamesthom.as/blog/2018/08/07/machine-learning-in-node-dot-js-with-tensorflow-dot-js/), I showed how to use [TensorFlow.js](https://js.tensorflow.org/) on Node.js to run [visual recognition on images from the local filesystem](https://gist.github.com/jthomas/145610bdeda2638d94fab9a397eb1f1d#file-script-js). TensorFlow.js is a JavaScript version of the open-source machine learning library from Google.

Once I had this working with a local Node.js script, my next idea was to convert it into a serverless function. Running this function on [IBM Cloud Functions](https://console.bluemix.net/openwhisk/) ([Apache OpenWhisk](https://openwhisk.incubator.apache.org/)) would turn the script into my own visual recognition microservice.

![](http://jamesthom.as/images/tfjs-serverless/tf-js-example.gif "Serverless TensorFlow.js Function")

Sounds easy, right? It’s just a JavaScript library? So, zip it up and away we go… **_ahem_** 👊

_Converting the image classification script to run in a serverless environment had the following challenges…_

*   **TensorFlow.js libraries need to be available in the runtime.**
*   **Native bindings for the library must be compiled against the platform architecture.**
*   **Models files need to be loaded from the filesystem.**

Some of these issues were more challenging than others to fix! Let’s start by looking at the details of each issue, before explaining how [Docker support](http://jamesthom.as/blog/2017/01/16/openwhisk-docker-actions/) in Apache OpenWhisk can be used to resolve them all.

## Challenges

### TensorFlow.js Libraries

TensorFlow.js libraries are not included in the [Node.js runtimes](https://github.com/apache/incubator-openwhisk-runtime-nodejs) provided by the Apache OpenWhisk.

External libraries [can be imported](http://jamesthom.as/blog/2016/11/28/npm-modules-in-openwhisk/) into the runtime by deploying applications from a zip file. Custom `node_modules` folders included in the zip file will be extracted in the runtime. Zip files are limited to a [maximum size of 48MB](https://github.com/apache/incubator-openwhisk/blob/master/docs/reference.md#actions).

#### Library Size

Running `npm install` for the TensorFlow.js libraries used revealed the first problem… the resulting `node_modules` directory was 175MB. 😱

Looking at the contents of this folder, the `tfjs-node` module compiles a [native shared library](https://github.com/tensorflow/tfjs-node/tree/master/src) (`libtensorflow.so`) that is 135M. This means no amount of JavaScript minification is going to get those external dependencies under the magic 48 MB limit. 👎

#### Native Dependencies

The `libtensorflow.so` native shared library must be compiled using the platform runtime. Running `npm install` locally automatically compiles native dependencies against the host platform. Local environments may use different CPU architectures (Mac vs Linux) or link against shared libraries not available in the serverless runtime.

### MobileNet Model Files

TensorFlow models files [need loading from the filesystem](https://js.tensorflow.org/tutorials/model-save-load.html) in Node.js. Serverless runtimes do provide a temporary filesystem inside the runtime environment. Files from deployment zip files are automatically extracted into this environment before invocations. There is no external access to this filesystem outside the lifecycle of the serverless function.

Models files for the MobileNet model were 16MB. If these files are included in the deployment package, it leaves 32MB for the rest of the application source code. Although the model files are small enough to include in the zip file, what about the TensorFlow.js libraries? Is this the end of the blog post? Not so fast….

**Apache OpenWhisk’s support for custom runtimes provides a simple solution to all these issues!**

## Custom Runtimes

Apache OpenWhisk uses Docker containers as the runtime environments for serverless functions (actions). All platform runtime images are [published on Docker Hub](https://hub.docker.com/r/openwhisk/), allowing developers to start these environments locally.

Developers can also [specify custom runtime images](https://github.com/apache/incubator-openwhisk/blob/master/docs/actions-docker.md) when creating actions. These images must be publicly available on Docker Hub. Custom runtimes have to expose the [same HTTP API](https://github.com/apache/incubator-openwhisk/blob/master/docs/actions-new.md#action-interface) used by the platform for invoking actions.

Using platform runtime images as [parent images](https://docs.docker.com/glossary/?term=parent%20image) makes it simple to build custom runtimes. Users can run commands during the Docker build to install additional libraries and other dependencies. The parent image already contains source files with the HTTP API service handling platform requests.

### TensorFlow.js Runtime

Here is the Docker build file for the Node.js action runtime with additional TensorFlow.js dependencies.

```
FROM openwhisk/action-nodejs-v8:latest

RUN npm install @tensorflow/tfjs @tensorflow-models/mobilenet @tensorflow/tfjs-node jpeg-js

COPY mobilenet mobilenet
```

`openwhisk/action-nodejs-v8:latest` is the Node.js action runtime image [published by OpenWhisk](https://hub.docker.com/r/openwhisk/action-nodejs-v8/).

TensorFlow libraries and other dependencies are installed using `npm install` in the build process. Native dependencies for the `@tensorflow/tfjs-node` library are automatically compiled for the correct platform by installing during the build process.

Since I’m building a new runtime, I’ve also added the [MobileNet model files](https://github.com/tensorflow/tfjs-models/tree/master/mobilenet) to the image. Whilst not strictly necessary, removing them from the action zip file reduces deployment times.

**_Want to skip the next step? Use this image [`jamesthomas/action-nodejs-v8:tfjs`](https://hub.docker.com/r/jamesthomas/action-nodejs-v8/) rather than building your own._**

### Building The Runtime

_In the [previous blog post](http://jamesthom.as/blog/2018/08/07/machine-learning-in-node-dot-js-with-tensorflow-dot-js/), I showed how to download model files from the public storage bucket._

*   Download a version of the MobileNet model and place all files in the `mobilenet` directory.
*   Copy the Docker build file from above to a local file named `Dockerfile`.
*   Run the Docker [build command](https://docs.docker.com/engine/reference/commandline/build/) to generate a local image.

```
docker build -t tfjs .
```

*   [Tag the local image](https://docs.docker.com/engine/reference/commandline/tag/) with a remote username and repository.

```
docker tag tfjs <USERNAME>/action-nodejs-v8:tfjs
```

_Replace `<USERNAME>` with your Docker Hub username._

*   [Push the local image](https://docs.docker.com/engine/reference/commandline/push/) to Docker Hub

```
docker push <USERNAME>/action-nodejs-v8:tfjs
```

Once the image [is available](https://hub.docker.com/r/jamesthomas/action-nodejs-v8/) on Docker Hub, actions can be created using that runtime image. 😎

## Example Code

This source code implements image classification as an OpenWhisk action. Image files are provided as a Base64 encoded string using the `image` property on the event parameters. Classification results are returned as the `results` property in the response.

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

### Caching Loaded Models

Serverless platforms initialise runtime environments on-demand to handle invocations. Once a runtime environment has been created, it will be [re-used for further invocations](https://medium.com/openwhisk/squeezing-the-milliseconds-how-to-make-serverless-platforms-blazing-fast-aea0e9951bd0) with some limits. This improves performance by removing the initialisation delay (“cold start”) from request processing.

Applications can exploit this behaviour by using global variables to maintain state across requests. This is often use to [cache opened database connections](https://blog.rowanudell.com/database-connections-in-lambda/) or store initialisation data loaded from external systems.

I have used this pattern to [cache the MobileNet model](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L80-L82) used for classification. During cold invocations, the model is loaded from the filesystem and stored in a global variable. Warm invocations then use the existence of that global variable to skip the model loading process with further requests.

Caching the model reduces the time (and therefore cost) for classifications on warm invocations.

### Memory Leak

Running the Node.js script from blog post on IBM Cloud Functions was possible with minimal modifications. Unfortunately, performance testing revealed a memory leak in the handler function. 😢

_Reading more about [how TensorFlow.js works](https://js.tensorflow.org/tutorials/core-concepts.html) on Node.js uncovered the issue…_

TensorFlow.js’s Node.js extensions use a native C++ library to execute the Tensors on a CPU or GPU engine. Memory allocated for Tensor objects in the native library is retained until the application explicitly releases it or the process exits. TensorFlow.js provides a `dispose` method on the individual objects to free allocated memory. There is also a `tf.tidy` method to automatically clean up all allocated objects within a frame.

Reviewing the code, tensors were being created as [model input from images](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L51-L59) on each request. These objects were not disposed before returning from the request handler. This meant native memory grew unbounded. Adding an explicit `dispose` call to free these objects before returning [fixed the issue](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L91).

### Profiling & Performance

Action code records memory usage and elapsed time at different stages in classification process.

Recording [memory usage](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L12-L20) allows me to modify the maximum memory allocated to the function for optimal performance and cost. Node.js provides a [standard library API](https://nodejs.org/docs/v0.4.11/api/all.html#process.memoryUsage) to retrieve memory usage for the current process. Logging these values allows me to inspect memory usage at different stages.

Timing [different tasks](https://gist.github.com/jthomas/e7c78bbfe4091ed6ace93d1b53cbf6e5#file-index-js-L71) in the classification process, i.e. model loading, image classification, gives me an insight into how efficient classification is compared to other methods. Node.js has a [standard library API](https://nodejs.org/api/console.html#console_console_time_label) for timers to record and print elapsed time to the console.

## Demo

### Deploy Action

*   Run the following command with the [IBM Cloud CLI](https://console.bluemix.net/openwhisk/learn/cli) to create the action.

```
ibmcloud fn action create classify --docker <IMAGE_NAME> index.js
```

_Replace `<IMAGE_NAME>` with the public Docker Hub image identifier for the custom runtime. Use `jamesthomas/action-nodejs-v8:tfjs` if you haven’t built this manually._

### Testing It Out

*   Download [this image](https://upload.wikimedia.org/wikipedia/commons/f/fe/Giant_Panda_in_Beijing_Zoo_1.JPG) of a Panda from Wikipedia.

![](https://upload.wikimedia.org/wikipedia/commons/f/fe/Giant_Panda_in_Beijing_Zoo_1.JPG)

```
wget http://bit.ly/2JYSal9 -O panda.jpg
```

*   Invoke the action with the Base64 encoded image as an input parameter.

```
ibmcloud fn action invoke classify -r -p image $(base64 panda.jpg)
```

*   Returned JSON message contains classification probabilities. 🐼🐼🐼

```
{
  "results":  [{
    className: 'giant panda, panda, panda bear, coon bear',
    probability: 0.9993536472320557
  }]
}
```

### Activation Details

*   Retrieve logging output for the last activation to show performance data.

```
ibmcloud fn activation logs --last
```

**_Profiling and memory usage details are logged to stdout_**

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

`main` is the total elapsed time for the action handler. `mn_model.classify` is the elapsed time for the image classification. Cold start requests print an extra log message with model loading time, `loadModel: 394.547ms`.

## Performance Results

Invoking the `classify` action 1000 times for both cold and warm activations (using 256MB memory) generated the following performance results.

### warm invocations

![](http://jamesthom.as/images/tfjs-serverless/warm-activations.png "Warm Activation Performance Results")

Classifications took an average of **316 milliseconds to process when using warm environments**. Looking at the timing data, converting the Base64 encoded JPEG into the input tensor took around 100 milliseconds. Running the model classification task was in the 200 - 250 milliseconds range.

### cold invocations

![](http://jamesthom.as/images/tfjs-serverless/cold-activations.png "Cold Activation Performance Results")

Classifications took an average of **1260 milliseconds to process when using cold environments**. These requests incur penalties for initialising new runtime containers and loading models from the filesystem. Both of these tasks took around 400 milliseconds each.

_One disadvantage of using custom runtime images in Apache OpenWhisk is the lack of [pre-warmed containers](https://medium.com/openwhisk/squeezing-the-milliseconds-how-to-make-serverless-platforms-blazing-fast-aea0e9951bd0). Pre-warming is used to reduce cold start times by starting runtime containers before they are needed. This is not supported for non-standard runtime images._

### classification cost

IBM Cloud Functions [provides a free tier](https://console.bluemix.net/openwhisk/learn/pricing) of 400,000 GB/s per month. Each further second of execution is charged at $0.000017 per GB of memory allocated. Execution time is rounded up to the nearest 100ms.

If all activations were warm, a user could execute **more than 4,000,000 classifications per month in the free tier** using an action with 256MB. Once outside the free tier, around 600,000 further invocations would cost just over $1.

If all activations were cold, a user could execute **more than 1,2000,000 classifications per month in the free tier** using an action with 256MB. Once outside the free tier, around 180,000 further invocations would cost just over $1.

## Conclusion

TensorFlow.js brings the power of deep learning to JavaScript developers. Using pre-trained models with the TensorFlow.js library makes it simple to extend JavaScript applications with complex machine learning tasks with minimal effort and code.

Getting a local script to run image classification was relatively simple, but converting to a serverless function came with more challenges! Apache OpenWhisk restricts the maximum application size to 50MB and native libraries dependencies were much larger than this limit.

Fortunately, Apache OpenWhisk’s custom runtime support allowed us to resolve all these issues. By building a custom runtime with native dependencies and models files, those libraries can be used on the platform without including them in the deployment package.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
