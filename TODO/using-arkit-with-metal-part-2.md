
> * 原文地址：[Using ARKit with Metal part 2](http://metalkit.org/2017/08/31/using-arkit-with-metal-part-2.html)
> * 原文作者：[Marius Horga](https://twitter.com/gpu3d)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-arkit-with-metal-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-arkit-with-metal-part-2.md)
> * 译者：[swants](http://www.swants.cn)
> * 校对者：[zhangqippp](https://github.com/zhangqippp) [Danny1451](https://github.com/Danny1451)

# 基于 Metal 的 ARKit 使用指南（下）

- [基于 Metal 的 ARKit 使用指南（上）](https://github.com/xitu/gold-miner/blob/master/TODO/using-arkit-with-metal.md)
- [基于 Metal 的 ARKit 使用指南（下）](https://github.com/xitu/gold-miner/blob/master/TODO/using-arkit-with-metal-part-2.md)

咱们上篇提到过 ,  **ARKit** 应用通常包括三个图层 : `渲染层` , `追踪层` 和 `场景解析层` 。上一篇我们通过一个自定义视图已经非常详细地分析了渲染层在 `Metal` 中是如何工作的了。 `ARKit` 使用 `视觉惯性测程法` 准确地追踪它周围的环境，并将相机传感器数据和 `CoreMotion` 数据相结合。这样当相机随我们运动时，不需要额外的校准就可以保证图像的稳定性。这篇文章我们将研究  __场景解析__ —— 通过平面检测，碰撞测试和光线测定来描述场景特征的方法。 `ARKit` 可以分析相机呈现出来的场景并在场景中找到类似地板这样的水平面。前提是，我们需要在运行 session configuration 之前，简单地添加额外的一行代码来打开水平面检测的新特性（默认是关闭的）：

```
override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(animated)
let configuration = ARWorldTrackingConfiguration()
configuration.planeDetection = .horizontal
session.run(configuration)
}
```

> 注意，在当前的 API 版本中只能添加水平的平面检测。

使用 **ARSessionObserver** 协议方法来处理会话错误，追踪变化和打断：

```
func session(_ session: ARSession, didFailWithError error: Error) {}
func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {}
func session(_ session: ARSession, didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer) {}
func sessionWasInterrupted(_ session: ARSession) {}
func sessionInterruptionEnded(_ session: ARSession) {}
```

与此同时， **ARSessionDelegate** 协议还有其他的代理方法（继承于 ARSessionObserver ）来让我们处理锚点：我们在第一个方法中调用 **print()** ：

```
func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
print(anchors)
}
func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {}
func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {}
func session(_ session: ARSession, didUpdate frame: ARFrame) {}
```

让我们现在打开 **Renderer.swift** 文件。首先，创建一些我们需要的类属性。这些变量将会帮助我们在屏幕上创建和展示一个调试界面：

```
var debugUniformBuffer: MTLBuffer!
var debugPipelineState: MTLRenderPipelineState!
var debugDepthState: MTLDepthStencilState!var debugMesh: MTKMesh!
var debugUniformBufferOffset: Int = 0
var debugUniformBufferAddress: UnsafeMutableRawPointer!
var debugInstanceCount: Int = 0
```

其次，我们在 **setupPipeline()** 中创建缓存区：

```
debugUniformBuffer = device.makeBuffer(length: anchorUniformBufferSize, options: .storageModeShared)
```

我们需要为我们的平面创建新的顶点和分段函数，以及新的渲染管道和深度模板状态。在刚才创建命令行队列的代码上面，添加以下代码：

```
let debugGeometryVertexFunction = defaultLibrary.makeFunction(name: "vertexDebugPlane")!
let debugGeometryFragmentFunction = defaultLibrary.makeFunction(name: "fragmentDebugPlane")!
anchorPipelineStateDescriptor.vertexFunction =  debugGeometryVertexFunction
anchorPipelineStateDescriptor.fragmentFunction = debugGeometryFragmentFunction
do { try debugPipelineState = device.makeRenderPipelineState(descriptor: anchorPipelineStateDescriptor)
} catch let error { print(error) }
debugDepthState = device.makeDepthStencilState(descriptor: anchorDepthStateDescriptor)
```

再次，在 **setupAssets()** 方法中，我们需要创建一个新的 `Model I/O` 平面网格，然后在通过它创建一个 Metal 网格。在这个方法的末尾添加下面的代码：

```
mdlMesh = MDLMesh(planeWithExtent: vector3(0.1, 0.1, 0.1), segments: vector2(1, 1), geometryType: .triangles, allocator: metalAllocator)
mdlMesh.vertexDescriptor = vertexDescriptor
do { try debugMesh = MTKMesh(mesh: mdlMesh, device: device)
} catch let error { print(error) }
```

下一步，在 **updateBufferStates()** 方法中，我们需要更新平面所在缓存区的地址。添加下面的代码：


```
debugUniformBufferOffset = alignedInstanceUniformSize * uniformBufferIndex
debugUniformBufferAddress = debugUniformBuffer.contents().advanced(by: debugUniformBufferOffset)
```

接下来，在 **updateAnchors()** 方法中，我们需要更新转换矩阵和锚点的数量。在循环之前添加下面的代码：


```
let count = frame.anchors.filter{ $0.isKind(of: ARPlaneAnchor.self) }.count
debugInstanceCount = min(count, maxAnchorInstanceCount - (anchorInstanceCount - count))
```

然后，在循环中用下面代码替换最后的三行代码：

```
if anchor.isKind(of: ARPlaneAnchor.self) {
let transform = anchor.transform * rotationMatrix(rotation: float3(0, 0, Float.pi/2))
let modelMatrix = simd_mul(transform, coordinateSpaceTransform)
let debugUniforms = debugUniformBufferAddress.assumingMemoryBound(to: InstanceUniforms.self).advanced(by: index)
debugUniforms.pointee.modelMatrix = modelMatrix
} else {
let modelMatrix = simd_mul(anchor.transform, coordinateSpaceTransform)
let anchorUniforms = anchorUniformBufferAddress.assumingMemoryBound(to: InstanceUniforms.self).advanced(by: index)
anchorUniforms.pointee.modelMatrix = modelMatrix
}
```

我们必须以 **Z** 轴为轴心扭转平面 90°，这样我们就可以使平面保持水平。注意我们使用了一个叫做  **rotationMatrix()** 的自定义方法，现在来让我们定义这个方法。在我早先的文章第一次介绍 3D 转换时提到过这个矩阵：


```
func rotationMatrix(rotation: float3) -> float4x4 {
var matrix: float4x4 = matrix_identity_float4x4
let x = rotation.x
let y = rotation.y
let z = rotation.z
matrix.columns.0.x = cos(y) * cos(z)
matrix.columns.0.y = cos(z) * sin(x) * sin(y) - cos(x) * sin(z)
matrix.columns.0.z = cos(x) * cos(z) * sin(y) + sin(x) * sin(z)
matrix.columns.1.x = cos(y) * sin(z)
matrix.columns.1.y = cos(x) * cos(z) + sin(x) * sin(y) * sin(z)
matrix.columns.1.z = -cos(z) * sin(x) + cos(x) * sin(y) * sin(z)
matrix.columns.2.x = -sin(y)
matrix.columns.2.y = cos(y) * sin(x)
matrix.columns.2.z = cos(x) * cos(y)
matrix.columns.3.w = 1.0
return matrix
}
```

接着，在 **drawAnchorGeometry()** 方法中，我们需要确保我们在渲染的时候至少拥有一个锚点，用下面的代码替换方法第一行：


```
guard anchorInstanceCount - debugInstanceCount > 0 else { return }
```

再然后，让我们最后创建 **drawDebugGeometry()** 方法来绘制我们的平面。它和锚点渲染方法是非常相似的：


```
func drawDebugGeometry(renderEncoder: MTLRenderCommandEncoder) {
guard debugInstanceCount > 0 else { return }
renderEncoder.pushDebugGroup("DrawDebugPlanes")
renderEncoder.setCullMode(.back)
renderEncoder.setRenderPipelineState(debugPipelineState)
renderEncoder.setDepthStencilState(debugDepthState)
renderEncoder.setVertexBuffer(debugUniformBuffer, offset: debugUniformBufferOffset, index: 2)
renderEncoder.setVertexBuffer(sharedUniformBuffer, offset: sharedUniformBufferOffset, index: 3)
renderEncoder.setFragmentBuffer(sharedUniformBuffer, offset: sharedUniformBufferOffset, index: 3)
for bufferIndex in 0..<debugMesh.vertexBuffers.count {
let vertexBuffer = debugMesh.vertexBuffers[bufferIndex]
renderEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index:bufferIndex)
}
for submesh in debugMesh.submeshes {
renderEncoder.drawIndexedPrimitives(type: submesh.primitiveType, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: submesh.indexBuffer.offset, instanceCount: debugInstanceCount)
}
renderEncoder.popDebugGroup()
}
```

在渲染层还有最后件事要做 —— 就是在 **update()** 里我们刚才结束编码的那一行上面调用这个方法： 


```
drawDebugGeometry(renderEncoder: renderEncoder)
```

接着，我们打开 **Shaders.metal** 文件，我们需要一个新的结构体，只需通过一个顶点描述符传递顶点的位置


```
typedef struct {
float3 position [[attribute(0)]];
} DebugVertex;
```

在顶点着色器中，我们使用模型视图矩阵来更新顶点的位置：


```
vertex float4 vertexDebugPlane(DebugVertex in [[ stage_in]],
constant SharedUniforms &sharedUniforms [[ buffer(3) ]],
constant InstanceUniforms *instanceUniforms [[ buffer(2) ]],
ushort vid [[vertex_id]],
ushort iid [[instance_id]]) {
float4 position = float4(in.position, 1.0);
float4x4 modelMatrix = instanceUniforms[iid].modelMatrix;
float4x4 modelViewMatrix = sharedUniforms.viewMatrix * modelMatrix;
float4 outPosition = sharedUniforms.projectionMatrix * modelViewMatrix * position;
return outPosition;
}
```

最后，在片段着色器中，我们给平面一个鲜艳的颜色，使我们在视图中可以一眼看到它：


```
fragment float4 fragmentDebugPlane() {
return float4(0.99, 0.42, 0.62, 1.0);
}
```

如果你运行这个 app , 当 APP 检测到一个平面时，你应该能够看到一个矩形，就像这样：

![](https://github.com/MetalKit/images/blob/master/plane.gif?raw=true)

接下来,我们可以通过检测其他目标,或将视角从之前的检测目标上移开来更新或者移除平面。其他的代理方法可以帮助我们实现这一点。接着我们可以研究碰撞和其他物理效果。当然，这只是一个未来的想象。

我想要感谢 [Caroline](https://twitter.com/carolinebegbie) 为本篇文章指定检测目标（平面）! 按照惯例，[源代码](https://github.com/MetalKit/metal) 都发表在 `Github` 上。

期待下次相见！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
