
> * 原文地址：[Next-generation 3D Graphics on the Web](https://webkit.org/blog/7380/next-generation-3d-graphics-on-the-web/)
> * 原文作者：[Dean Jackson](https://twitter.com/grorgwork)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/next-generation-3d-graphics-on-the-web.md](https://github.com/xitu/gold-miner/blob/master/TODO/next-generation-3d-graphics-on-the-web.md)
> * 译者：[reid3290](https://github.com/reid3290)
> * 校对者：[leviding](https://github.com/leviding),[H2O-2](https://github.com/H2O-2)

# Web 端的下一代三维图形

今天，苹果 WebKit 团队提议[在 W3C 成立一个新的社区群组（Community Group）来讨论 Web 端三维图形的未来](https://www.w3.org/community/gpu/)和开发一款支持现代 GPU 特性（包括底层图像处理和通用计算）的标准 API。W3C 社区允许大家自由参与进来，而且我们也诚邀浏览器开发商、GPU 硬件提供商、软件开发者和 Web 社区[加入我们](https://www.w3.org/community/gpu/)。

权当抛砖引玉，我们分享了一个 [API 提案](https://webkit.org/wp-content/uploads/webgpu-api-proposal.html)和一个[针对 WebKit 开源项目的 API 原型](https://webkit.org/b/167952)。我们希望这是一个有益的开始，并期待随着社区讨论的进行 API 会不断发展进化。

**更新**：现在有一个[实现和演示 WebGPU 的 demo](https://webkit.org/blog/7504/webgpu-prototype-and-demos/)。

让我们来看看我们成立这个社区群组的前因后果，以及这个新组与现有 Web 图形 API（如 WebGL）的关系。

## 首先谈点历史问题

有一段时间，基于 Web 标准的技术可以生成具有静态内容的页面，而其中唯一的图形则是嵌入的图片。不久之后，Web 开始增加更多开发人员可以通过 JavaScript 访问的功能。最终，我们需要一个完全可编程的图形 API，以使脚本可以实时创建图像。因此，“canvas” 元素及其相关的 [2D 渲染 API](https://html.spec.whatwg.org/multipage/scripting.html#2dcontext) 诞生于 WebKit，随后迅速普及到其他浏览器引擎中，并且很快标准化了。

随着时间的推移，Web 应用程序和内容渐趋丰富和复杂，并开始触及平台的瓶颈。以游戏为例，其性能和视觉质量至关重要。在浏览器中开发游戏的需求是有的，但大多数游戏使用的是 GPU 提供的 3D 图形 API。Mozilla 和 Opera 公布了一些从 “canvas” 元素中暴露出 3D 渲染上下文的实验，其结果非常具有吸引力，因此社区决定一起将大家都可以实现的内容进行标准化。

所有的浏览器引擎协作创建了 [WebGL](https://www.khronos.org/webgl/)，这是在 Web 上渲染 3D 图形的标准。它基于 OpenGL ES —— 一种面向嵌入式系统的跨平台图形 API。这个起点是正确的，因为它可以轻松地在所有浏览器中实现相同的 API，而且大多数浏览器引擎都在支持 OpenGL 的系统上运行。即使系统没有直接支持 OpenGL，像 [ANGLE](http://angleproject.org/) 这样的项目也可以在其他技术之上进行仿真，毕竟这种 API 的抽象级别是很高的。随着 OpenGL 的发展，WebGL 也可以跟着发展。

WebGL 已经在开放平台上赋予了开发人员图形处理器的功能，所有主流浏览器都支持 WebGL 1，使得可以在 Web 上开发出高质量的游戏（console-quality games），也促进了 [three.js](http://threejs.org/) 等第三方库的蓬勃发展。此后，该标准发展成为 WebGL 2，[包括 WebKit](https://bugs.webkit.org/show_bug.cgi?id=126404) 在内的所有主流浏览器引擎都承诺对它提供支持。

## 接下来呢？

在 WebGL 发展的同时，GPU 技术也在发展进步，而且已经创建了新的软件 API，能够更好地反映现代 GPU 的设计特性。这些新 API 的抽象级别比较低，并且由于其降低了开销，通常来说比 OpenGL 的性能更好。该领域的主要技术平台有微软的 Direct3D 12、苹果的 Metal 和 Khronos Group 的 Vulkan。虽然这些技术的设计理念都是相似的，但可惜的是没有一项技术是跨平台可用的。

那么这对 Web 意味着什么呢？从充分利用 GPU 的角度来讲，这些新技术无疑是未来的发展方向。Web 平台想要成功必须定义一种允许多个系统上实现的通用标准，而现在已经有几个在架构上稍有差别的图形 API 了。要开发一款可以加速图形和计算的现代化底层技术，必须设计一个可以在多种系统（包括上面提到的那些系统）上实现的 API。随着图形技术的蓬勃发展，继续遵循像 OpenGL 这样的某个特定 API 标准显然是不可行的。

相反，我们需要评估和设计一个新的 Web 标准：它能够提供一组核心功能，以及一个支持多种系统图形技术和平台的 API，此外还要保障 Web 所要求的保密性和安全性。

再者，我们还需要考虑如何在图形处理之外使用 GPU，以及新标准如何与其他 Web 技术协同工作。该标准应该暴露现代 GPU 的通用计算功能。其设计架构应符合 Web 的既定模式以便开发和使用。它需要能够与其他重要的新兴 Web 标准（如 WebAssembly 和 WebVR）协同工作。最重要的是，这个标准的制定应该是一个开放的过程，允许行业专家和更广泛的网络社区参与。

W3C 为这种情况提供了社区群组平台。[“Web 端的 GPU” 社区群组](https://www.w3.org/community/gpu/)现已开放会员注册。

## WebKit 的初始 API 提案

几年前我们就预估了下一代图形 API 的发展情况，并着手在 WebKit 中设计原型以验证我们可以将非常低级别的 GPU API 暴露给 Web 同时还可以获得有价值的性能提升。我们得到了一些非常鼓舞人心的实验结果，所以我们将原型分享给了 W3C 社区群组。我们也准备[将代码部署到 WebKit 中](https://webkit.org/b/167952)，所以你很快就可以自己去尝试了。我们并不奢望这一 API 本身能成为最后的标准，社区也有可能根本就不会从它入手，但是我们认为编写代码的工作本身是很有价值的。其他浏览器引擎也已经开发了类似的原型。与社区合作并为计算机图形提出一个伟大的新技术想必是一件十分令人激动的事情。

下文将详细阐述我们的实验，我们将它称为 “WebGPU”。

### 获取渲染上下文（Rendering Context）和渲染管道（Rendering Pipeline）

不出意料，WebGPU 的接口是通过 “canvas” 元素来访问的。

```
let canvas = document.querySelector("canvas");
let gpu = canvas.getContext("webgpu");
```

WebGPU 比 WebGL 要更加面向对象化，事实上这也是性能提升的缘由之一。WebGPU 允许你创建和存储表示状态的对象和可以处理一组命令的对象，而无需在每次绘制操作之前设置状态。这样，我们可以在状态创建时就执行一些验证工作，从而减少绘图时的工作量。

WebGPU 上下文暴露了图形命令和并行计算命令。假设需要绘制一些图形，这需要用到图形管道。图形管道中最重要的元素是着色器（shaders），它们是在 GPU 上运行用以处理几何数据并为每个像素的绘制提供颜色的程序。着色器通常用专门用于图形的编程语言进行编写。

决定 Web API 使用何种着色语言是件有趣的事情，因为有很多因素需要考虑。我们需要一种功能强大的语言，要求编程尽量简单、能序列化为可高效传输的格式，并要求可以由浏览器进行验证以确保着色器的安全性。业内有部分人倾向于使用可以从许多源格式生成的着色器表示，这有点类似于汇编语言。同时，在“查看源代码”方面 Web 可谓发展迅速，对人而言代码的可读性还是很重要的。我们期望关于着色语言的讨论成为标准化过程中最有趣的部分之一，我们也十分愿意听取社区的意见。

就 WebGPU 原型而言，我们决定暂不考虑着色语言的问题，而是直接采用一种现存的语言。因为我们当时的工作是建立在苹果的平台上的，所以我们选择了[Metal Shading Language](https://developer.apple.com/library/content/documentation/Metal/Reference/MetalShadingLanguageGuide/Introduction/Introduction.html)。那接下来的问题就是如何将着色器加载到 WebGPU 了。

```
let library = gpu.createLibrary( /* 源代码 */ );

let vertexFunction = library.functionWithName("vertex_main");
let fragmentFunction = library.functionWithName("fragment_main");
```

我们使用 `gpu` 对象从源代码加载并编译着色器，生成一个 `WebGPULibrary`。着色器代码本身并不重要 —— 其实就是一个非常简单的顶点（vertex）和片段（fragment）的组合。一个 `WebGPULibrary` 可以容纳多个着色器函数，因此我们通过函数名称取出将要在管道中用到的相应函数。

现在我们就可以创建管道了。

```
// 管道的一些细节。
let pipelineDescriptor = new WebGPURenderPipelineDescriptor();
pipelineDescriptor.vertexFunction = vertexFunction;
pipelineDescriptor.fragmentFunction = fragmentFunction;
pipelineDescriptor.colorAttachments[0].pixelFormat = "BGRA8Unorm";

let pipelineState = gpu.createRenderPipelineState(pipelineDescriptor);
```

传入所需描述信息（包括使用的顶点、片段着色器以及图像格式）即可从上下文中得到一个新的 `WebGPURenderPipelineState` 对象。

### 缓冲区（Buffers）

绘图操作要求使用缓冲区向渲染管道提供数据，例如几何坐标、颜色、法向量等等，而 `WebGPUBuffer` 则是容纳这些数据的对象。

```
let vertexData = new Float32Array([ /* some data */ ]);
let vertexBuffer = gpu.createBuffer(vertexData);
```

此例中，我们有一个 `Float32Array`，它包含了需要在几何图形中绘制的每个顶点的数据。我们从 `Float32Array` 创建一个 `WebGPUBuffer`，该缓冲区会在之后的绘图操作中用到。

诸如此类的顶点数据很少发生变化，但也有些数据是几乎每次绘制时都会发生变化的。像这种不变的数据被称为 **uniforms**。表示相机位置的当前变换矩阵即是 uniform 的一个很常见的例子。`WebGPUBuffer` 也可用于 uniform，但此处我们希望在创建之后将其写入缓冲区。

```
// 将 "buffer" 看作是一个之前分配好的 WebGPUBuffer。
// buffer.contents 暴露一个 ArrayBufferView，我们将其
// 解析为一个 32 位的浮点数数组。
let uniforms = new Float32Array(buffer.contents);

// 设置所需 uniform。
uniforms[42] = Math.PI;
```

这样做的好处之一是 JavaScript 开发人员可以将 ArrayBufferView 封装在带有自定义 getter 和 setter 的类或代理对象（Proxy object）中，这样外部接口看起来像典型的 JavasScript 对象一样。然后，包装器对象会更新缓冲区正在使用的底层数组中的相应部分。

### 绘图（Drawing）

在通知 WebGPU 上下文绘图之前还需要设置一些状态，这包括渲染的目标位置（最终将在 `canvas` 中显示的 `WebGPUTexture`）以及纹理（texture）初始化和使用情况的描述信息。这些状态存储在 `WebGPURenderPassDescriptor` 中。

```
// 从上下文获取下一帧所期望的纹理信息。
let drawable = gpu.nextDrawable();

let passDescriptor = new WebGPURenderPassDescriptor();
passDescriptor.colorAttachments[0].loadAction = "clear";
passDescriptor.colorAttachments[0].storeAction = "store";
passDescriptor.colorAttachments[0].clearColor = [0.8, 0.8, 0.8, 1.0];
passDescriptor.colorAttachments[0].texture = drawable.texture;
```
首先，我们向 WebGPU 上下文请求一个表示下一可绘帧的对象，此对象最终会被复制到 canvas 元素中去。完成绘图代码后，我们要通知 WebGPU 以便其显示绘图结果并准备下一个可绘帧。

从初始化 `WebGPURenderPassDescriptor` 的代码中可以看出，我们不会在绘图操作正在进行的时候从纹理中读取信息（因为 `loadAction` 的值是 `clear`），而是在绘图操作完成之后才使用该纹理（因为 `storeAction` 的值是 `store`），此外代码还指定了纹理的填充颜色。

接下来，我们创建用于保存实际绘制操作的对象。一个 `WebGPUCommandQueue` 有一组 `WebGPUCommandBuffers`。我们使用 `WebGPUCommandEncoder` 将操作推送到 `WebGPUCommandBuffer` 中去。

```
let commandQueue = gpu.createCommandQueue();
let commandBuffer = commandQueue.createCommandBuffer();

// 使用之前创建的描述符。
let commandEncoder = commandBuffer.createRenderCommandEncoderWithDescriptor(
                        passDescriptor);

// 告知编码器使用何种状态（例如：着色器）。
commandEncoder.setRenderPipelineState(pipelineState);

// 最后，编码器还需要知道使用哪个缓冲区。
commandEncoder.setVertexBuffer(vertexBuffer, 0, 0);
```

至此，我们已经设置好了一个渲染管道，其中包含若干着色器、一个用于保存几何信息的缓冲区、一个用于保存绘制操作的队列以及一个可以提交到该队列的编码器。现在只需将实际绘图命令推入编码器即可。

```
// 我们知道我们的缓冲区有 3 个顶点，
// 我们希望绘制出一个填充的三角形。
commandEncoder.drawPrimitives("triangle", 0, 3);
commandEncoder.endEncoding();

// 所有绘图命令已经提交。通知 WebGPU
// 一旦队列处理完毕即刻显示 canvas 中的绘图结果。
commandBuffer.presentDrawable(drawable);
commandBuffer.commit();
```

像大多数 3D 图形的示例代码一样，绘制一个简单的形状看起来要写很多代码，但其实并非如此。这些现代 API 有一个优点 —— 其大部分代码都是在创建可以重用以绘制其他内容的对象。例如，一般渲染上下文只需要一个 `WebGPUCommandQueue` 实例，又者可以为不同的着色器提前创建多个 `WebGPURenderPipelineState` 对象。此外，浏览器还可以在前期进行很多验证工作，从而减少绘图操作过程中的开销。

希望本文可以让你对 WebGPU 提案有一个大致了解。尽管由 W3C 社区群组最终确定的 API 可能同此提案有很大不同，但我们相信很多一般的设计原则都是通用的。

## 公开邀请

苹果的 WebKit 团队已经建议为 Web 端 GPU 建立一个 W3C 社区群组作为工作论坛，同时也[请你加入我们](https://www.w3.org/community/gpu/)一起定义 GPU 的下一代标准。我们的建议得到了其他浏览器引擎开发商、GPU 供应商、框架开发人员等业内同仁的积极回应。在行业的支持下，我们诚邀所有对 Web GPU 感兴趣或有专长的人加入社区群组。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
