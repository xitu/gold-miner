
> * 原文地址：[Next-generation 3D Graphics on the Web](https://webkit.org/blog/7380/next-generation-3d-graphics-on-the-web/)
> * 原文作者：[Dean Jackson](https://twitter.com/grorgwork)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/next-generation-3d-graphics-on-the-web.md](https://github.com/xitu/gold-miner/blob/master/TODO/next-generation-3d-graphics-on-the-web.md)
> * 译者：
> * 校对者：

# Next-generation 3D Graphics on the Web

Apple’s WebKit team today proposed a new [Community Group at the W3C to discuss the future of 3D graphics on the Web](https://www.w3.org/community/gpu/), and to develop a standard API that exposes modern GPU features including low-level graphics and general purpose computation. W3C Community Groups allow all to freely participate, and we invite browser engineers, GPU hardware vendors, software developers and the Web community to [join us](https://www.w3.org/community/gpu/).

To kick off the discussion, we’re sharing an [API proposal](https://webkit.org/wp-content/uploads/webgpu-api-proposal.html), and a [prototype of that API for the WebKit Open Source project](https://webkit.org/b/167952). We hope this is a useful starting point, and look forward to seeing the API evolve as discussions proceed in the Community Group.

*UPDATE*: There is now a [prototype implementation and demos of WebGPU](https://webkit.org/blog/7504/webgpu-prototype-and-demos/).

Let’s cover the details of how we got to this point, and how this new group relates to existing Web graphics APIs such as WebGL.

## First, a Little History

There was a time where the standards-based technologies for the Web produced pages with static content, and the only graphics were embedded images. Before long, the Web started adding more features that developers could access via JavaScript. Eventually, there was enough demand for a fully programmable graphics API, so that scripts could create images on the fly. Thus the `canvas` element and its associated [2D rendering API](https://html.spec.whatwg.org/multipage/scripting.html#2dcontext) were born inside WebKit, quickly spread to other browser engines, and standardized soon afterward.

Over time, the type of applications and content that people were developing for the Web became more ambitious, and began running into limitations of the platform. One example is gaming, where performance and visual quality are essential. There was demand for games in browsers, but most games were using APIs that provided 3D graphics using the power of Graphics Processing Units (GPUs). Mozilla and Opera showed some experiments that exposed a 3D rendering context from the `canvas` element, and they were so compelling that the community decided to gather to standardize something that everyone could implement.

All the browser engines collaborated to create [WebGL](https://www.khronos.org/webgl/), the standard for rendering 3D graphics on the Web. It was based on OpenGL ES, a cross-platform API for graphics targeted at embedded systems. This was the right starting place, because it made it possible to implement the same API in all browsers easily, especially since most browser engines were running on systems that had support for OpenGL. And even when the system didn’t directly support OpenGL, the API sat at a high enough level of abstraction for projects like [ANGLE](http://angleproject.org/) to emulate it on top of other technologies. As OpenGL evolved, WebGL could follow.

WebGL has unleashed the power of graphics processors to developers on an open platform, and all major browsers support WebGL 1, allowing console-quality games to be built for the Web, and communities like [three.js](http://threejs.org/) to flourish. Since then, the standard has evolved to WebGL 2 and, again, all major browser engines, [including WebKit](https://bugs.webkit.org/show_bug.cgi?id=126404), are committed to supporting it.

## What’s Next?

Meanwhile, GPU technology has improved and new software APIs have been created to better reflect the designs of modern GPUs. These new APIs exist at a lower level of abstraction and, due to their reduced overhead, generally offer better performance than OpenGL. The major platform technologies in this space are Direct3D 12 from Microsoft, Metal from Apple, and Vulkan from the Khronos Group. While these technologies have similar design concepts, unfortunately none are available across all platforms.

So what does this mean for the Web? These new technologies are clearly the next evolutionary step for content that can benefit from the power of the GPU. The success of the web platform requires defining a common standard that allows for multiple implementations, but here we have several graphics APIs that have nuanced architectural differences. In order to expose a modern, low-level technology that can accelerate graphics and computation, we need to design an API that can be implemented on top of many systems, including those mentioned above. With a broader landscape of graphics technologies, following one specific API like OpenGL is no longer possible.

Instead we need to evaluate and design a new web standard that provides a core set of required features, an API that can be implemented on a mix of platforms with different system graphics technologies, and the security and safety required to be exposed to the Web.

We also need to consider how GPUs can be used outside of the context of graphics and how the new standard can work in concert with other web technologies. The standard should expose the general-purpose computational functionality of modern GPUs. Its design should fit with established patterns of the Web, to make it easy for developers to adopt the technology. It needs to be able to work well with other critical emerging web standards like WebAssembly and WebVR. And most importantly, the standard should be developed in the open, allowing both industry experts and the broader web community to participate.

The W3C provides the Community Group platform for exactly this situation. The [“GPU for the Web” Community Group](https://www.w3.org/community/gpu/) is now open for membership.

## WebKit’s Initial API Proposal

We anticipated the situation of next-generation graphics APIs a few years ago and started prototyping in WebKit, to validate that we could expose a very low-level GPU API to the Web, and still get worthwhile performance improvements. Our results were very encouraging, so we are sharing the prototype with the W3C Community Group. We will also [start landing code in WebKit](https://webkit.org/b/167952) soon, so that you can try it out for yourself. We don’t expect this to become the actual API that ends up in the standard, and maybe not even the one that the Community Group decides to start with, but we think there is a lot of value in working code. Other browser engines have made their own similar prototypes. It will be exciting to collaborate with the community and come up with a great new technology for graphics.

Let’s take a look at our experiment in detail, which we call “WebGPU”.

### Getting a Rendering Context and Rendering Pipeline

The interface to WebGPU is, as expected, via the `canvas` element.

```
let canvas = document.querySelector("canvas");
let gpu = canvas.getContext("webgpu");
```

WebGPU is much more object-oriented than WebGL. In fact, that is where some of the efficiencies come from. Rather than setting up state before each draw operation, WebGPU allows you to create and store objects that represent state, along with objects that can process a set of commands. This way we can do some validation up front as the states are created, reducing the work we need to perform during a drawing operation.

A WebGPU context exposes graphics commands and parallel compute commands. Let’s just assume we want to draw something, so we’ll be using a graphics pipeline. The most important elements in the pipeline are the shaders, which are  programs that run on the GPU to process the geometric data and provide a color for each drawn pixel. Shaders are typically written in a language that is specialized for graphics.

Deciding on a shading language in a Web API is interesting because there are many factors to consider. We need a language that is powerful, allows programs to be easily created, can be serialized into a format that is efficient for transfer, and can be validated by the browser to make sure the shader is safe. Parts of the industry are moving to shader representations that can be generated from many source formats, sort of like an assembly language. Meanwhile, the Web has thrived on the “View Source” approach, where human readable code is valuable. We expect the discussions around the shading language to be one of the most fun parts of the standardization process, and look forward to hearing community opinions.

For our WebGPU prototype, we decided to defer the issue and just accept an existing language for now. Since we were building on Apple platforms we picked the [Metal Shading Language](https://developer.apple.com/library/content/documentation/Metal/Reference/MetalShadingLanguageGuide/Introduction/Introduction.html). How do we load our shaders into WebGPU?

```
let library = gpu.createLibrary( /* source code */ );

let vertexFunction = library.functionWithName("vertex_main");
let fragmentFunction = library.functionWithName("fragment_main");
```


We ask the `gpu` object to load and compile the shader from source code, producing a `WebGPULibrary`. The shader code itself isn’t that important—imagine a very simple vertex and fragment combination. A library can hold multiple shader functions, so we extract the functions we want to use in this pipeline by name.

Now we can create our pipeline.

```
// The details of the pipeline.
let pipelineDescriptor = new WebGPURenderPipelineDescriptor();
pipelineDescriptor.vertexFunction = vertexFunction;
pipelineDescriptor.fragmentFunction = fragmentFunction;
pipelineDescriptor.colorAttachments[0].pixelFormat = "BGRA8Unorm";

let pipelineState = gpu.createRenderPipelineState(pipelineDescriptor);
```

We get a new `WebGPURenderPipelineState` object from the context by passing in the description of what we need. In this case we say which vertex and fragment shaders we’ll use, as well as the type of image data we want.

### Buffers

In order to draw something you need to provide data to the rendering pipeline using a buffer. `WebGPUBuffer` is the object that can hold such data, such as geometry coordinates, colors and normal vectors.

```
let vertexData = new Float32Array([ /* some data */ ]);
let vertexBuffer = gpu.createBuffer(vertexData);
```

In this case we have data for each vertex we want to draw in our geometry inside a `Float32Array`, and then create a `WebGPUBuffer` from that data. We’ll use this buffer later when we issue a draw operation.

Vertex data such as this rarely changes, but there are data that change nearly every time a draw happens. These are called *uniforms*. A common example of a uniform is the current transformation matrix representing a camera position. `WebGPUBuffer`s are used for uniforms too, but in this case we want to write into the buffer after we’ve created it.

```
// Imagine "buffer" is a WebGPUBuffer that was allocated earlier.
// buffer.contents exposes an ArrayBufferView, that we then interpret
// as an array of 32-bit floating point numbers.
let uniforms = new Float32Array(buffer.contents);

// Set the uniform of interest.
uniforms[42] = Math.PI;
```

One of the nice things about this is that a JavaScript developer can wrap the ArrayBufferView with a class or Proxy object with custom getters and setters, so that the external interface looks like typical JavasScript objects. The wrapper object then updates the right ranges within the underlying Array that the buffer is using.

### Drawing

Before we can tell the WebGPU context to draw something, we need to set up some state. This includes the destination of the rendering (a `WebGPUTexture` that will eventually be shown in the `canvas` ), and a description of how that texture is initialized and used. That state is stored in a `WebGPURenderPassDescriptor`.

```
// Ask the context for the texture it expects the next
// frame to be drawn into.
let drawable = gpu.nextDrawable();

let passDescriptor = new WebGPURenderPassDescriptor();
passDescriptor.colorAttachments[0].loadAction = "clear";
passDescriptor.colorAttachments[0].storeAction = "store";
passDescriptor.colorAttachments[0].clearColor = [0.8, 0.8, 0.8, 1.0];
passDescriptor.colorAttachments[0].texture = drawable.texture;
```

First we ask the WebGPU context for an object that represents the next frame that we can draw into. This is what is ultimately copied into the canvas element. After we’ve finished our drawing code, we tell WebGPU that we’re done with the drawable object so it can display the results and prepare the next frame.

The `WebGPURenderPassDescriptor` is initialized indicating that we won’t be reading from this texture in a draw operation (the `loadAction` is `clear`), that we will use the texture after the draw (`storeAction` is `store`), and the color it should fill the texture with.

Next, we create the objects we’ll need to hold the actual draw operations. A `WebGPUCommandQueue` has a set of `WebGPUCommandBuffers`. We push operations into a `WebGPUCommandBuffer` using a `WebGPUCommandEncoder`.

```
let commandQueue = gpu.createCommandQueue();
let commandBuffer = commandQueue.createCommandBuffer();

// Use the descriptor we created above.
let commandEncoder = commandBuffer.createRenderCommandEncoderWithDescriptor(
                        passDescriptor);

// Tell the encoder which state to use (i.e. shaders).
commandEncoder.setRenderPipelineState(pipelineState);

// And, lastly, the encoder needs to know which buffer
// to use for the geometry.
commandEncoder.setVertexBuffer(vertexBuffer, 0, 0);
```

At this point we have set up a rendering pipeline with shaders, a buffer holding the geometry, a queue that we’ll submit draw operations to, and an encoder that can submit to the queue. Now we just push the actual command to draw into the encoder.

```
// We know our buffer has three vertices. We want to draw them
// with filled triangles.
commandEncoder.drawPrimitives("triangle", 0, 3);
commandEncoder.endEncoding();

// All drawing commands have been submitted. Tell WebGPU to
// show/present the results in the canvas once the queue has
// been processed.
commandBuffer.presentDrawable(drawable);
commandBuffer.commit();
```

Like most 3D graphics sample code, it feels like a lot of work in order to draw a simple shape. But it’s not a waste. An advantage of these modern APIs is that much of that code is creating objects that can be reused to draw other things. For example, often content will only need a single  `WebGPUCommandQueue` instance, or can create multiple `WebGPURenderPipelineState` objects up-front for different shaders. And again, the browser can do a lot of early validation to reduce the overhead during the drawing operations.

Hopefully this gave you a taste of the WebGPU proposal. Even though the final API produced by the W3C Community Group may be very different, we expect a lot of the general design principles to be common.

## An Open Invitation

Apple’s WebKit team has proposed establishing a W3C Community Group for GPU on the Web to be the forum for this work, and today [you are invited to join us](https://www.w3.org/community/gpu/) in defining the next standard for GPUs. Our proposal has been received positively by our colleagues at other browser engines, GPU vendors, and framework developers. With support from the industry, we invite all with an interest or expertise in this area to join the Community Group.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
