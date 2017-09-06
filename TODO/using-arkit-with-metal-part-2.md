
> * 原文地址：[Using ARKit with Metal part 2](http://metalkit.org/2017/08/31/using-arkit-with-metal-part-2.html)
> * 原文作者：[Marius Horga](https://twitter.com/gpu3d)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/using-arkit-with-metal-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/using-arkit-with-metal-part-2.md)
> * 译者：
> * 校对者：

# Using ARKit with Metal part 2

As underlined last time, ￼there are three layers in an **ARKit** application: `Rendering`, `Tracking` and `Scene Understanding`. Last time we analyzed in great detail how Rendering is done in `Metal` using a custom view. `ARKit` uses `Visual Inertial Odometry` for accurate Tracking of the world around it and to combine camera sensor data with `CoreMotion` data. No additional calibration is necessary for image stability while we are in motion. In this article we look at **Scene Understanding** - ways of describing scene attributes by using plane detection, hit-testing and light estimation. `ARKit` can analyze the scene presented by the camera view and find horizontal planes such as floors. First, we need to enable the plane detection feature (which is **off** by default) by simply adding one more line before running the session configuration:

```
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  let configuration = ARWorldTrackingConfiguration()
  configuration.planeDetection = .horizontal
  session.run(configuration)
}
```

> Note that only horizontal plane detection is possible with the current API version.

The **ARSessionObserver** protocol’s methods are used for handling session errors, tracking changes and interruptions:

```
func session(_ session: ARSession, didFailWithError error: Error) {}
func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {}
func session(_ session: ARSession, didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer) {}
func sessionWasInterrupted(_ session: ARSession) {}
func sessionInterruptionEnded(_ session: ARSession) {}
```

However, there are other delegate methods that belong to the **ARSessionDelegate** protocol (which extends ARSessionObserver) that let us work with anchors. Put a **print()** call inside the first one:

```
func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
  print(anchors)
}
func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {}
func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {}
func session(_ session: ARSession, didUpdate frame: ARFrame) {}
```

Let’s move to the **Renderer.swift** file now. First, create a few class properties we need to work with. These variables will help us create and display a debug plane on the screen:

```
var debugUniformBuffer: MTLBuffer!
var debugPipelineState: MTLRenderPipelineState!
var debugDepthState: MTLDepthStencilState!var debugMesh: MTKMesh!
var debugUniformBufferOffset: Int = 0
var debugUniformBufferAddress: UnsafeMutableRawPointer!
var debugInstanceCount: Int = 0
```

Next, in **setupPipeline()** we create the buffer:

```
debugUniformBuffer = device.makeBuffer(length: anchorUniformBufferSize, options: .storageModeShared)
```

We need to create new vertex and fragment functions for our plane, as well as new render pipeline and depth stencil states. Right before the line where the command queue is created, add these lines:

```
let debugGeometryVertexFunction = defaultLibrary.makeFunction(name: "vertexDebugPlane")!
let debugGeometryFragmentFunction = defaultLibrary.makeFunction(name: "fragmentDebugPlane")!
anchorPipelineStateDescriptor.vertexFunction =  debugGeometryVertexFunction
anchorPipelineStateDescriptor.fragmentFunction = debugGeometryFragmentFunction
do { try debugPipelineState = device.makeRenderPipelineState(descriptor: anchorPipelineStateDescriptor)
} catch let error { print(error) }
debugDepthState = device.makeDepthStencilState(descriptor: anchorDepthStateDescriptor)
```

Next, in **setupAssets()** we need to create a new `Model I/O` plane mesh and then create the Metal mesh from it. At the end of the function add these lines:

```
mdlMesh = MDLMesh(planeWithExtent: vector3(0.1, 0.1, 0.1), segments: vector2(1, 1), geometryType: .triangles, allocator: metalAllocator)
mdlMesh.vertexDescriptor = vertexDescriptor
do { try debugMesh = MTKMesh(mesh: mdlMesh, device: device)
} catch let error { print(error) }
```

Next, in **updateBufferStates()** we need to update the address of the buffer where the plane resides. Add the following lines:

```
debugUniformBufferOffset = alignedInstanceUniformSize * uniformBufferIndex
debugUniformBufferAddress = debugUniformBuffer.contents().advanced(by: debugUniformBufferOffset)
```

Next, in **updateAnchors()** we need to update the transform matrices and the anchors count. Add the following lines before the loop:

```
let count = frame.anchors.filter{ $0.isKind(of: ARPlaneAnchor.self) }.count
debugInstanceCount = min(count, maxAnchorInstanceCount - (anchorInstanceCount - count))
```

Then, inside the loop replace the last three lines with the following lines:

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

We had to rotate the plane **90** degrees by the **Z** axis so we can make it horizontal. Notice that we used a custom method named **rotationMatrix()** so let’s define it. We have seen this matrix in the early articles when we first introduced 3D transforms:

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

Next, in **drawAnchorGeometry()** we need to make sure we have at least one anchor before drawing it. Replace the first line with this one:

```
guard anchorInstanceCount - debugInstanceCount > 0 else { return }
```

Next, let’s finally create the **drawDebugGeometry()** function that draws our plane. It’s very similar to the anchor drawing function:

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

There is one more thing left to do in `Renderer` and that is - call this function in **update()** right above the line where we end the encoding:

```
drawDebugGeometry(renderEncoder: renderEncoder)
```

Finally, let’s go to the **Shaders.metal** file. We need a new struct with just the vertex position passed via a vertex descriptor:

```
typedef struct {
  float3 position [[attribute(0)]];
} DebugVertex;
```

In the vertex shader we update the vertex position using the model-view matrix:

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

And last, in the fragment shader we give the plane a bold color to make it noticeable in the view:

```
fragment float4 fragmentDebugPlane() {
  return float4(0.99, 0.42, 0.62, 1.0);
}
```

If you run the app, you should be able to see a rectangle added when the app detects a plane, like this:

![](https://github.com/MetalKit/images/blob/master/plane.gif?raw=true)

What we could do next is update/remove planes as we detect more or as we move away from the previously detected one. The other delegate methods can help us achieve just that. Then, we could look at collisions and physics. Just a thought for the future.

I want to thank [Caroline](https://twitter.com/carolinebegbie) for being the designated (plane) detective for this article! The [source code](https://github.com/MetalKit/metal) is posted on `Github` as usual.

Until next time!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
