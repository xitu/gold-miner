> * 原文地址：[Building an AR game with ARKit and Spritekit](https://blog.pusher.com/building-ar-game-arkit-spritekit/)
> * 原文作者：[Esteban Herrera](https://github.com/eh3rrera)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-ar-game-arkit-spritekit.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-ar-game-arkit-spritekit.md)
> * 译者：[Danny Lau](https://github.com/Danny1451)
> * 校对者：[KnightJoker](https://github.com/KnightJoker),[LJ147](https://github.com/LJ147)

# 巧用 ARKit 和 SpriteKit 从零开始做 AR 游戏 

**这篇文章隶属于 [Pusher 特邀作者计划](https://pusher.com/guest-writer-program)。**

[ARKit](https://developer.apple.com/arkit/) 是一个全新的苹果框架，它将设备运动追踪，相机捕获和场景处理整合到了一起，可以用来构建[增强现实（Augmented Reality, AR）](https://en.wikipedia.org/wiki/Augmented_reality) 的体验。

在使用 ARKit 的时候，你有三种选项来创建你的 AR 世界：

- SceneKit，渲染 3D 的叠加内容。
- SpriteKit，渲染 2D 的叠加内容。
- Metal，自己为 AR 体验构建的视图

在这个教程里，我们将通过创建一个游戏来学习 ARKit 和 SpriteKit 的基础，游戏是受  Pokemon Go 的启发，添加了幽灵元素，看下下面这个视频吧：

[![](https://i.ytimg.com/vi_webp/0mmaLiuYAho/maxresdefault.webp)](https://www.youtube.com/embed/0mmaLiuYAho)

每几秒钟，就会有一个小幽灵随机出现在场景里，同时在屏幕的左下角会有一个计数器不停在增加。当你点击幽灵的时候，它会播放一个音效同时淡出而且计数器也会减小。

项目的代码已经放在了 [GitHub](https://github.com/eh3rrera/ARKitGameSpriteKit) 上了。

让我们首先检查一下开发和运行这个项目的需要哪些东西。

## 你将会需要的

首先，为了完整的 AR 体验，ARKit 要求一个带有 A9 或者更新的处理器的 iOS 设备。换句话说，你至少需要一台 iPhone6s 或者有更高处理器的设备，比如 iPhoneSE，任何版本的 iPad Pro，或者 2017 版的 iPad。

ARKit 是 iOS 11 的一个特性，所以你必须先装上这个版本的 SDK，并用 Xcode 9 来开发。在写这篇文章的时候，iOS 11 和 Xcode 9 仍然是在测试版本，所以你要先加入到[苹果开发者计划](https://developer.apple.com/programs/)，不过苹果现在也向公众发布了免费的开发者账号。你可以在[这里](https://9to5mac.com/2017/06/26/how-to-install-ios-11-public-beta-on-your-eligible-iphone-ipad-or-ipod-touch/)找到更多关于安装 iOS 11 beta 的信息和[这里](https://developer.apple.com/download/)找到关于安装 Xcode beta 的信息。

为了避免之后版本的改动，这个应用的教程是通过 Xcode beta 2 来构建的。
在这个游戏中，我们需要表示幽灵的图片和它被移除时的音效。[OpenGameArt.org](https://opengameart.org) 是一个非常棒的获取免费游戏资源的网站。我选了这个[幽灵图片](https://opengameart.org/content/ghosts) 和这个[幽灵音效](https://opengameart.org/content/ghost)，当然你也可以用任何你想要用的文件。

## 新建项目

打开 Xcode 9 并且新建一个 AR 应用：

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-01-createProject.png)

输入项目的信息，选择 Swift 作为开发语言并把 SpriteKit 作为内容技术，接着创建项目：

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-01-createProject2.png)

目前 AR 不能够在 iOS 模拟器上测试，所以我们需要在真机上进行测试。为此，我们需要开发者账号来注册我们的应用。如果暂时没有的话，把你的开发账号添加到 Xcode 上并且选择你的团队来注册你的应用：

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-02-developmentTeam-774x600.png)

如果你没有一个付过费的开发者账号的话，你会有一些限制，比如你每七天只能够创建 10 个 App ID 而且你不能够在你的设备上安装超过 3 个以上的应用。

在你第一次在你的设备上安装应用的时候，你可能会被要求信任设备上的证书，就跟着下面的指导：
![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-03-Trust.png)

就像这样，当应用运行的时候，你会被请求给予摄像头权限：

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-07-camera-permission.png)

之后，在你触摸屏幕的时候，一个新的精灵会被加到场景上去，并且根据摄像头的角度来调整位置。

[![](https://i.ytimg.com/vi_webp/NyIHEM69skU/maxresdefault.webp)](https://www.youtube.com/watch?v=NyIHEM69skU)

现在这个项目已经搭建完成了，让我们来看下代码吧。

## SpriteKit 如何和 ARKit 一起工作

如果你打开 `Main.storyboard`，你会发现有个 [ARSKView](https://developer.apple.com/documentation/arkit/arskview) 填满了整个屏幕：
![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-04-storyboard-836x600.png)

这个视图将来自设备摄像头的实时视频，渲染为场景的背景，将 2D 的图片(以 SpriteKit 的节点)加到 3D 的空间中( 以 [ARAnchor](https://developer.apple.com/documentation/arkit/aranchor) 对象)。当你移动设备的时候，这个视图会根据锚点（ `ARAnchor` 对象）自动旋转和缩放这个图像( SpriteKit 节点)，所以他们看上去就像是通过摄像头跟踪的真实的世界。

这个界面是通过 `ViewController.swift` 这个类来管理的。首先，在 `viewDidLoad` 方法中，它打开了界面的一些调试选项，然后通过这个自动生成的场景 `Scene.sks` 来创建 SpriteKit 场景：

```
    override func viewDidLoad() {
      super.viewDidLoad()

      // 设置视图的代理
      sceneView.delegate = self

      // 展示数据，比如 fps 和节点数
      sceneView.showsFPS = true
      sceneView.showsNodeCount = true

      // 从 'Scene.sks' 加载 SKScene
      if let scene = SKScene(fileNamed: "Scene") {
        sceneView.presentScene(scene)
      }
    }
```

接着，`viewWillAppear` 方法通过 [ARWorldTrackingSessionConfiguration](https://developer.apple.com/documentation/arkit/arworldtrackingsessionconfiguration) 类来配置这个会话。这个会话（ [ARSession](https://developer.apple.com/documentation/arkit/arsession) 对象）负责管理创建 AR 体验所需要的运动追踪和图像处理：

```
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      // 创建会话配置
      let configuration = ARWorldTrackingSessionConfiguration()

      // 运行视图的会话
      sceneView.session.run(configuration)
    }
```

你可以用 `ARWorldTrackingSessionConfiguration` 类来配置该会话通过[六个自由度(6DOF)](https://en.wikipedia.org/wiki/Six_degrees_of_freedom)中追踪物体的移动。三个旋转角度：

- Roll，在 X-轴 的旋转角度
- Pitch，在 Y-轴 的旋转角度
- Yaw，在 Z-轴 的旋转角度

和三个平移值：
- Surging，在 X-轴 上向前向后移动。
- Swaying，在 Y-轴 上左右移动。
- Heaving，在 Z-轴 上上下移动。

或者，你也可以用 [ARSessionConfiguration](https://developer.apple.com/documentation/arkit/arsessionconfiguration) ，它提供了 3 个自由度，支持低性能设备的简单运动追踪。

往下几行，你会发现这个方法 `view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode?` 。当一个锚点被添加的时候，这个方法为即将添加到场景上的锚点提供了一个自定义节点。在当前的情况下，它会返回一个 [SKLabelNode](https://developer.apple.com/documentation/spritekit/sklabelnode) 来展示这个面向用户的 emoji ：

```
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
      // 为加上视图会话的锚点增加和配置节点
      let labelNode = SKLabelNode(text: "👾")
      labelNode.horizontalAlignmentMode = .center
      labelNode.verticalAlignmentMode = .center
      return labelNode;
    }
```

但是这个锚点什么时候创建的呢？

它是在 `Scene.swift` 文件中完成的，在这个管理 Sprite 场景（`Scene.sks`）的类中，特别地，这个方法中：

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let sceneView = self.view as? ARSKView else {
        return
      }

      // 通过摄像头当前的位置创建锚点
      if let currentFrame = sceneView.session.currentFrame {
        // 创建一个往摄像头前面平移 0.2 米的转换
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.2
        let transform = simd_mul(currentFrame.camera.transform, translation)

        // 在会话上添加一个锚点
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
      }
    }
```

就像你从注释中可以看到的，它通过摄像头当前的位置创建了一个锚点，然后新建了一个矩阵来把锚点定位在摄像头前 0.2m 处，并把它加到场景中。

ARAnchor 使用一个 [4×4 的矩阵](https://developer.apple.com/documentation/scenekit/scnmatrix4) 来代表和它相对应的对象在一个三维空间中的位置，角度或者方向，和缩放。

在 3D 编程的世界里，矩阵用来代表图形化的转换比如平移，缩放，旋转和投影。通过矩阵的乘法，多个转换可以连接成一个独立的变换矩阵。

这是一篇关于[转换背后的数学](http://ronnqvi.st/the-math-behind-transforms/)很好的博文。同样的，在[核心动画指南中关于操作 3D 界面中层级一章](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW18) 中你也可以找到一些常用转换的矩阵配置。

回到代码中，我们以一个特殊的矩阵开始（`matrix_identity_float4x4`）：

```
1.0   0.0   0.0   0.0  // 这行代表 X
0.0   1.0   0.0   0.0  // 这行代表 Y
0.0   0.0   1.0   0.0  // 这行代表 Z
0.0   0.0   0.0   1.0  // 这行代表 W
```

>  如果你想知道 W 是什么：
>
>  如果 w == 1，那么这个向量 (x, y, z, 1) 是空间中的一个位置。
> 
>  如果 w == 0，那么这个向量 (x, y, z, 0) 是一个方向。 
>
> [http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/](http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/)

接着，Z-轴列的第三个值改为了 -0.2 代表着在这个轴上有平移（负的 z 值代表着把对象放置到摄像头之前）。
如果你这个时候打印了平移矩阵值的话，你会看见它打印了一个向量数组，每个向量代表了一列。

```
[ [1.0, 0.0,  0.0, 0.0 ],
  [0.0, 1.0,  0.0, 0.0 ],
  [0.0, 0.0,  1.0, 0.0 ],
  [0.0, 0.0, -0.2, 1.0 ]
]
```

这样子可能看起来更简单一点：

```
0     1     2     3    // 列号
1.0   0.0   0.0   0.0  // 这一行代表着 X
0.0   1.0   0.0   0.0  // 这一行代表着 Y
0.0   0.0   1.0  -0.2  // 这一行代表着 Z
0.0   0.0   0.0   1.0  // 这一行代表着 W
```


接着，这个矩阵会乘上当前摄像头帧的平移矩阵得到最后用来放置新锚点的矩阵。举个例子，假设是如下的相机转换矩阵（以一个列的数组的形式）：

```
[ [ 0.103152, -0.757742,   0.644349, 0.0 ],
  [ 0.991736,  0.0286687, -0.12505,  0.0 ],
  [ 0.0762833, 0.651924,   0.754438, 0.0 ],
  [ 0.0,       0.0,        0.0,      1.0 ]
]
```

那么相乘的结果将是：

```
[ [0.103152,   -0.757742,   0.644349, 0.0 ],
  [0.991736,    0.0286687, -0.12505,  0.0 ],
  [0.0762833,   0.651924,   0.754438, 0.0 ],
  [-0.0152567, -0.130385,  -0.150888, 1.0 ]
]
```

这里是关于[矩阵如何相乘](https://www.mathsisfun.com/algebra/matrix-multiplying.html)的更多信息，这是一个[矩阵乘法计算器](http://matrix.reshish.com/multiplication.php)。

现在你知道这个例子是如何工作的了，让我们修改它来创建我们的游戏吧。

## 构建 SpriteKit 的场景

在 Scene.swift 的文件中，让我们加上如下的配置：

```
    class Scene: SKScene {

      let ghostsLabel = SKLabelNode(text: "Ghosts")
      let numberOfGhostsLabel = SKLabelNode(text: "0")
      var creationTime : TimeInterval = 0
      var ghostCount = 0 {
        didSet {
          self.numberOfGhostsLabel.text = "\(ghostCount)"
        }
      }
      ...
    }
```

我们增加了两个标签，一个代表了场景中的幽灵的数量，控制幽灵产生的时间间隔，和幽灵的计数器，它有个属性观察器，每当它的值变化的时候，标签就会更新。

接下来，下载幽灵移除时播放的音效，并把它拖到项目中：

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-06-addImages-1.gif)

把下面这行加到类里面：

```
let killSound = SKAction.playSoundFileNamed("ghost", waitForCompletion: false)
```

我们稍后调用这个动作来播放音效。

在 `didMove` 方法中，我们把标签加到场景中：

```
    override func didMove(to view: SKView) {
      ghostsLabel.fontSize = 20
      ghostsLabel.fontName = "DevanagariSangamMN-Bold"
      ghostsLabel.color = .white
      ghostsLabel.position = CGPoint(x: 40, y: 50)
      addChild(ghostsLabel)

      numberOfGhostsLabel.fontSize = 30
      numberOfGhostsLabel.fontName = "DevanagariSangamMN-Bold"
      numberOfGhostsLabel.color = .white
      numberOfGhostsLabel.position = CGPoint(x: 40, y: 10)
      addChild(numberOfGhostsLabel)
    }
```

你可以用像 [iOS Fonts](http://iosfonts.com/) 的站点来可视化的选择标签的字体。

这个位置坐标代表着屏幕左下角的部分（相关代码稍后会解释）。我选择把它们放在屏幕的这个区域是为了避免转向的问题，因为场景的大小会随着方向改变而变化，但是，坐标保持不变，会引起标签显示超过屏幕或者在一些奇怪的位置（可以通过重写 `didChangeSize` 方法或者使用 [UILabels](https://developer.apple.com/documentation/uikit/uilabel) 替换 [SKLabelNodes](https://developer.apple.com/documentation/spritekit/sklabelnode) 来解决这一问题）。

现在，为了在固定的时间间隔创建幽灵，我们需要一个定时器。这个更新方法会在每一帧（平均 60 次每秒）渲染之前被调用，可以像下面这样帮助我们：


```
    override func update(_ currentTime: TimeInterval) {
      // 在每一帧渲染之前调用
      if currentTime > creationTime {
        createGhostAnchor()
        creationTime = currentTime + TimeInterval(randomFloat(min: 3.0, max: 6.0))
      }
    }
```

参数 `currentTime` 代表着当前应用中的时间，所以如果它大于 `creationTime` 所代表的时间，一个新的幽灵锚点会创建， `creationTime` 也会增加一个随机的秒数，在这个例子里面，是在 3 到 6 秒。

这是 `randomFloat` 的定义：

```
    func randomFloat(min: Float, max: Float) -> Float {
      return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
```

在 `createGhostAnchor` 方法中，我们需要获取场景的界面：

```
    func createGhostAnchor(){
      guard let sceneView = self.view as? ARSKView else {
        return
      }

    }
```

接着，因为在接下来的函数中我们都要与弧度打交道，让我们先定义一个弧度的 360 度：

```
    func createGhostAnchor(){
      ...

      let _360degrees = 2.0 * Float.pi

    }
```

现在，为了把幽灵放置在一个随机的位置，我们分别创建一个随机 X-轴旋转和 Y-轴旋转矩阵：

```
    func createGhostAnchor(){
      ...

       let rotateX = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 1, 0, 0))

      let rotateY = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 0, 1, 0))

    }
```


幸运的是，我们不需要去手动地创建这个旋转矩阵，有一些函数可以返回一个表示旋转，平移或者缩放的转换信息矩阵。

在这个例子中，[SCNMatrix4MakeRotation](https://developer.apple.com/documentation/scenekit/1409686-scnmatrix4makerotation) 返回了一个表示旋转变换的矩阵。第一个参数代表了旋转的角度，要用弧度的形式。在这个表达式 `_360degrees * randomFloat(min: 0.0, max: 1.0)` 中得到一个在 0 到 360 度中的随机角度。

剩下的 `SCNMatrix4MakeRotation` 的参数，代表了 X，Y 和 Z 轴各自的旋转，这就是为什么我们第一次调用的时候把 1 作为 X 的参数，而第二次的时候把 1 作为 Y 的参数。

 `SCNMatrix4MakeRotation` 的结果通过 `simd_float4x4` 结构体转换为一个 4x4 的矩阵。 

>   如果你正在使用 Xcode 9 Beta 1 的话，你应该用 SCNMatrix4ToMat4 ，在 Xcode 9 Beta 2 中它被 simd_float4x4 替换了。 

我们可以通过矩阵乘法来组合两个旋转矩阵：

```
    func createGhostAnchor(){
      ...
      let rotation = simd_mul(rotateX, rotateY)

    }
```

接着，我们创建一个 Z-轴是 -1 到 -2 之间的随机值的转换矩阵。

```
    func createGhostAnchor(){
      ...
      var translation = matrix_identity_float4x4
      translation.columns.3.z = -1 - randomFloat(min: 0.0, max: 1.0)

    }
```

组合旋转和位移矩阵：

```
    func createGhostAnchor(){
      ...
      let transform = simd_mul(rotation, translation)

    }
```

创建并把这个锚点加到该会话中：

```
    func createGhostAnchor(){
      ...
      let anchor = ARAnchor(transform: transform)
      sceneView.session.add(anchor: anchor)

    }
```

并且增加幽灵计数器：

```
    func createGhostAnchor(){
      ...
      ghostCount += 1
    }
```

现在唯一剩下没有加的就是当用户触摸一个幽灵并移动它的代码。首先重写 `touchesBegan`  来获取到触摸的物体：

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }

    }
```

接着获取该触摸在 AR 场景中的位置：

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      let location = touch.location(in: self)

    }
```

获取在该位置的所有节点：

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      let hit = nodes(at: location)

    }
```

获取第一个节点（如果有的话），检查这个节点是不是代表着一个幽灵（记住标签同样也是一个节点）：

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      if let node = hit.first {
        if node.name == "ghost" {

        }
      }
    }
```

如果就这个节点的话，组合淡出和音效动作，创建一个动作序列并执行它，同时减小幽灵的计数器：

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      if let node = hit.first {
        if node.name == "ghost" {

          let fadeOut = SKAction.fadeOut(withDuration: 0.5)
          let remove = SKAction.removeFromParent()

          // 组合淡出和音效动画
          let groupKillingActions = SKAction.group([fadeOut, killSound])
          // 创建动作序列
          let sequenceAction = SKAction.sequence([groupKillingActions, remove])

          // 执行动作序列
          node.run(sequenceAction)

          // 更新计数
          ghostCount -= 1

        }
      }
    }
```

到这里，我们的场景已经完成了，现在我们开始处理 `ARSKView` 的视图控制器。

## 构建视图控制器

在 viewDidLoad 中，不再加载 Xcode 为我们创建的场景，让我们通过这种方式来创建我们的场景：

```
    override func viewDidLoad() {
      ...

      let scene = Scene(size: sceneView.bounds.size)
      scene.scaleMode = .resizeFill
      sceneView.presentScene(scene)
    }
```

这会确保我们的场景可以填满整个界面，甚至整个屏幕（在 `Main.storyboard` 中定义的 `ARSKView` 填满了整个屏幕）。这同样也有助于把游戏的标签定位在屏幕的左下角，根据场景中定义的位置坐标。

现在，现在是时候添加幽灵图片了。在我的例子中，图片的格式原来是 SVG ，所以我转换到了 PNG ，并且为了简单起见，只加了图片中的前 6 个幽灵，创建了 2X 和 3X 版本（我没看见创建 1X 版本的地方，因此采用了缩放策略的设备不能够正常的运行这个应用）。

把图片拖到 `Assets.xcassets` 中：

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-06-addImages.gif)

注意图像名字最后的数字 - 这会帮我们随机选择一个图片创建 SpriteKit 节点。用这个替换 `view(_ view: ARSKView, nodeFor anchor: ARAnchor)` 中的代码：  

```
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
      let ghostId = randomInt(min: 1, max: 6)

      let node = SKSpriteNode(imageNamed: "ghost\(ghostId)")
      node.name = "ghost"

      return node
    }
```

我们给所有的节点同样的名字 *ghost* ，所以在移除它们的时候我们可以识别它们。

当然，不要忘了 randomInt 方法：

```
    func randomInt(min: Int, max: Int) -> Int {
      return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
```

现在我们已经完成了所有工作！让我们来测试它吧！

## 测试应用

在真机上运行这个应用，赋予摄像头权限，并且开始在所有方向中寻找幽灵：

[![](https://i.ytimg.com/vi_webp/0mmaLiuYAho/maxresdefault.webp)](https://www.youtube.com/embed/0mmaLiuYAho)

每 3 到 6 秒就会出现一个新的幽灵，计数器也会更新，每当你击中一个幽灵的时候就会播放一个音效。

试着让计数器归零吧！

## 结论

关于 ARKit 有两个非常棒的地方。第一是只需要几行代码我们就能创建神奇的 AR 应用，第二个，我们也能学习到 SpriteKit 和 SceneKit 的知识。 ARKit 实际上只有很少的量的类，更重要的是去学会如何运用上面提到的框架，而且稍加调整就能创造出 AR 体验。

你可以通过增加游戏规则，引入奖励分数或者改变图像和声音来扩展这个应用。同样的，使用 [Pusher](https://pusher.com/)，你可以同步游戏状态来增加多人游戏的特性。

记住你可以在这个 [GitHub 仓库](https://github.com/eh3rrera/ARKitGameSpriteKit)中找到 Xcode 项目。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。



