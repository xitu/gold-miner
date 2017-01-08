> * 原文地址：[How To Build A SpriteKit Game In Swift 3 (Part 1)](https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/)
* 原文作者：[Marc Vandehey](https://www.smashingmagazine.com/author/marcvandehey/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015/)
* 校对者：[Tuccuay](https://github.com/Tuccuay), [DeepMissea](https://github.com/DeepMissea)

# 如何在 Swift 3 中用 SpriteKit 框架编写游戏 (Part 1)

**你有没有想过要如何开始创作一款基于 SpriteKit 的游戏？开发一款基于真实物理规则的游戏是不是让你望而生畏？随着 [SpriteKit](https://developer.apple.com/spritekit/)<sup>[\[1\]](#note-1)</sup> 的出现，在 iOS 上开发游戏已经变得空前的简单了。**

本系列将分为三个部分，带你探索 SpriteKit 的基础知识。我们会接触到物理引擎（ SKPhysics ）、碰撞、纹理管理、互动、音效、音乐、按钮以及场景（ `SKScene` ） 。这些看上去艰深晦涩的东西其实非常容易掌握。赶紧跟着我们一起开始编写 RainCat 吧。

[![Raincat: 第一课](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header-preview-opt.png)<sup>[\[2\]](#note-2)</sup>

RainCat，第一课

我们将要实现的这个游戏有一个简单的前提：我们想喂饱一只饥肠辘辘的猫，但它现在正孤身地站在雨中。不巧地是，RainCat 并不喜欢下雨天，而它被淋湿之后就会觉得很难过。为了让它能在大吃的时候不被雨水淋到，我们必须要替它撑把伞。想先体验一下我们的目标成果的话，看看 [完整项目](https://itunes.apple.com/us/app/raincat/id1152624676?ls=1&amp;mt=8)<sup>[\[3\]](#note-3)</sup> 吧。项目中会有一些文章里不会涉及到的进阶内容，但你可以稍后在 GitHub 上面看到这些内容。本系列的目标是让你深刻地理解做一个简单地游戏需要投入些什么。你可以随时与我们联系，并把这些代码作为将来其它项目的参考。我将会持续更新代码库，添加一些有趣的新功能并对一些部分进行重构。

在本文中，我们将：

- 查看 RainCat 游戏的初始代码；
- （为游戏）添加地面；
- （为游戏）添加雨滴；
- 初始化物理引擎；
- 添加雨伞对象，替猫儿遮雨；
- 利用 `categoryBitMask` 和 `contactTestBitMask` 来实现碰撞检测；
- 创造一个全局边界（ world boundary ）来移除落出屏幕的结点（ node ）。

### 入门

接下来有几件事需要你跟着完成。为了让你轻松起步，我准备好了一个基础工程。这个工程把 Xcode 8 在创建新的 SpriteKit 工程时联带生成的冗余代码都删的一干二净了。

- 从 [这里](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-initial-code)<sup>[\[4\]](#note-4)</sup> 下载 RainCat 游戏工程的基础代码。
- 安装 Xcode 8。
- 找一台测试机器！在本例中，你应该找一台 iPad ，这样可以避免做复杂的屏幕适配。模拟器也是可以的，但是操作上会有延迟，而且比在真实设备上的帧数低不少。

### 查看工程代码

我已经帮你起了个好头了，创建好了 RainCat 工程，还做了一些初始化的工作。打开这个 Xcode 工程。现在，项目看起来还非常的简单基础。我们先梳理一下现在的情况：我们创建了一个工程，指定运行系统为 iOS 10，运行设备为 iPad ，并且只支持设备的水平方向。如果我们要在较旧的设备上进行测试，我们也可以把系统版本设定为更早的版本，Swift 3 至多支持到 iOS 8 。当然，让你的应用支持起码比最新版本要早一个版本的系统也是一个很好的实践。不过需要注意：本教程内容仅针对 iOS 10 ，如果你要支持更早的版本的话，可能会出现一些问题。

决定利用 Swift 3 来实现这个游戏的原因： iOS 开发者社区非常积极地参与到了 Swift 3 的发布过程中，带来了许多编码风格上的变化和全方位的升级。由于新版本的 iOS 系统在 Apple 用户群体中覆盖速率快、面积广，我们认为，使用最新发布的 Swift 版本来编写这篇教程是最合适的。

在 `GameViewController.swift` 中有一个标准的 [`UIViewController`](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson4.html)<sup>[\[5\]](#note-5)</sup> 子类 ，我们修改了一些初始化 `GameScene.swift` 中的 [`SKScene`](https://developer.apple.com/reference/spritekit/skscene)<sup>[\[6\]](#note-6)</sup> 的代码。在做这些改动之前，我们会通过一个 SpriteKit 场景编辑器文件（ SpriteKit scene editor (SKS) file ）来读取 `GameScene` 类。在本教程中，我们将直接读取这个场景，而不是使用更复杂的 SKS 文件。如果你想更深入地了解 SKS 文件的相关知识， Ray Wenderlich 有一篇 [极佳的文章](https://www.raywenderlich.com/118225/introduction-sprite-kit-scene-editor)<sup>[\[7\]](#note-7)</sup> 。

### 获取资源文件

在我们写代码之前，要先获取项目中会用到的资源。今天我们会用到雨伞和雨滴。你可以在 GitHub 上找到这些 [纹理](https://github.com/thirteen23/RainCat/tree/smashing-day-1/dayOneAssets.zip)<sup>[\[8\]](#note-8)</sup> 。将它们添加到 Xcode 左部面板的 `Assets.xcassets` 文件夹中。当你点击 `Assets.xcassets` 文件，你会见到一个带有 `AppIcon` 占位符的空白界面。在 Finder 中选中所有（解压的资源文件），并把它们都拖到 `AppIcon` 占位符的下面。如果你正确进行了上述操作，你的 “Assets” 文件看起来应该是这样：

[![程序的资源文件](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png)<sup>[\[9\]](#note-9)</sup>

虽然你不能从白色的背景上分辨出白色的伞尖，但我保证，它是在那儿的。

### 是时候动手编码了

现在我们已经做足了各项准备工作，我们可以开始动手开发游戏啦。

我们首先要做出个地面，好腾出地方来遛猫和喂猫。由于背景和地面都非常的简单，我们可以把这些精灵（ sprite ）放到一个自定义的背景结点（ node ）中。在 Xcode 左部面板的 “Sprites” 文件夹下，创建名为 `BackgroundNode.swift` 的 Swift 源文件，并添加以下代码：

```
import SpriteKit

public class BackgroundNode : SKNode {

  public func setup(size : CGSize) {
    let yPos : CGFloat = size.height * 0.10
    let startPoint = CGPoint(x: 0, y: yPos)
    let endPoint = CGPoint(x: size.width, y: yPos)
    physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
    physicsBody?.restitution = 0.3
  }
}

```

上面的代码引用了 SpriteKit 框架。这是 Apple 官方的用于开发游戏的资源库。在我们接下来新建的大部分源文件中，我们都会用到它。我们创建的这个对象是一个 [`SKNode`](https://developer.apple.com/reference/spritekit/sknode)<sup>[\[10\]](#note-10)</sup> 实例，我们会把它作为背景元素的容器。目前，我们仅仅是在调用 `setup(size:)` 方法的时候为其添加了一个 [`SKPhysicsBody`](https://developer.apple.com/reference/spritekit/skphysicsbody)<sup>[\[11\]](#note-11)</sup> 实例。这个物理实体（ physics body ）会告诉我们的场景（ scene ），其定义的区域（目前只有一条线），能够和其它的物理实体和 [物理世界（ physics world ）](https://developer.apple.com/reference/spritekit/skphysicsworld)<sup>[\[12\]](#note-12)</sup> 进行交互。我们还改变了 `restitution` 的值。这个属性决定了地面的弹性。想让这个对象为我们所用，我们需要把它加入 `GameScene` 中。切换到 `GameScene.swift` 文件中，在靠近顶部，一串 `TimeInterval` 变量的下面，添加如下代码：

```
private let backgroundNode = BackgroundNode()

```

然后，在 `sceneDidLoad()` 方法中，我们可以初始化背景，并将其加入场景中：

```
backgroundNode.setup(size: size)
addChild(backgroundNode)

```

现在，如果我们运行程序，我们将会看到如图的游戏场景：

[![空白场景](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Empty-scene-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Empty-scene-preview-opt.png)<sup>[\[13\]](#note-13)</sup>

我们的略微空旷的场景。

如果你没看见那条线，那说明你在将结点（ node ）加入场景时出现了错误，要么就是场景现在不显示物理实体。要控制这些选项的开关，只需要在 `GameViewController.swift` 中修改下列选项即可：

```
if let view = self.view as! SKView? {
	view.presentScene(sceneNode)
	view.ignoresSiblingOrder = true
	view.showsPhysics = true
	view.showsFPS = true
	view.showsNodeCount = true
}

```

现在，确保 `showsPhysics` 属性被设为 `true` 。这有助于我们调试物理实体。尽管眼下并没有什么值得特别关注的地方，但这个背景将会充当雨滴下落反弹时的地面，也会作为猫咪行走时的边界。

接下来，我们来添加一些雨水。
如果我们在把雨滴加入场景之前思考一下，就会明白在这儿我们需要一个可复用的方法来原子性地添加雨滴。雨滴元素将由一个 `SKSpriteNode` 和另外一个物理实体构成。你可以用一张图片或是一块纹理来实例化一个 `SKSpriteNode` 对象。明白了这点，并且想到我们应该会添加许多的雨滴，我们就知道自己应该做一些复用了。有了这个想法，我们就可以复用纹理，而不必每次创建雨滴元素时都创建新的纹理了。

在 `GameScene.swift` 文件的顶部，实例化 `backgroundNode` 的前面，加入下面这行代码：

```
let raindropTexture = SKTexture(imageNamed: "rain_drop")

```

现在我们就可以在创建雨滴时进行复用，而不需要在每次都浪费内存来生成一份新的纹理了。

接着，在 `GameScene.swift` 的底部，加入下述代码，以便我们方便的创建雨滴：

```
private func spawnRaindrop() {
    let raindrop = SKSpriteNode(texture: raindropTexture)
    raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
    raindrop.position = CGPoint(x: size.width / 2, y: size.height / 2)

    addChild(raindrop)
  }

```

该方法被调用时，会利用我们刚刚创建的 `raindropTexture` 来生成一个新的雨滴结点。然后，我们通过纹理的形状创建 `SKPhysicsBody`，将结点位置设置为场景中央，并最终将其加入场景中。由于我们为雨滴结点添加了 `SKPhysicsBody` ，它将会自动地受到默认的重力作用并滴落至地面。为了测试这段代码，我们可以在 `touchesBegan(_ touches:, with event:)` 中调用这个方法，并看到如图的效果：

[![下起雨吧](https://www.smashingmagazine.com/wp-content/uploads/2016/10/first-rain-fall.gif)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/first-rain-fall.gif)<sup>[\[14\]](#note-14)</sup>

让雨水来的更猛烈些吧

只要我们不断地点击屏幕，雨滴就会源源不断地出现。这仅仅是出于测试的目的；毕竟最终我们想要控制的是雨伞，而不是雨水落下的速率。玩够了之后，我们就该把代码从 `touchesBegan(_ touches:, with event:)` 中删除，并将其绑定到我们的 `update` 循环中了。我们有一个名为 `update(_ currentTime:)` 的方法，我们希望在这个方法中进行降雨操作。方法中已经有一些基础代码了；目前，我们仅仅是测量时间差，但一会儿，我们将用它来更新其它的精灵元素。在这个方法的底部，更新 `self.lastUpdateTime` 变量之前，添加如下代码：

```
// Update the spawn timer
currentRainDropSpawnTime += dt

if currentRainDropSpawnTime > rainDropSpawnRate {
  currentRainDropSpawnTime = 0
  spawnRaindrop()
}

```

上述代码在每次累加的时间差大于 `rainDropSpawnRate` 的时候，就会新建一个雨滴。`rainDropSpawnRate` 目前是 0.5 秒；也就是说，每过半秒钟就会有新的雨滴被创建并落至地面。运行程序来测试一下吧。现在你不需要点击屏幕，而是每过半秒就有一滴新的雨滴被创建并下落，就像之前一样。

但这还不够好。我们可不想所有雨滴都出现在同一个地方，更别说都从屏幕中间开始往下落了。我们可以更新 `spawnRaindrop()` 方法来随机化每个新雨滴的 `x` 坐标，并将它们放到屏幕顶部。

找到 `spawnRaindrop()` 方法中的这行代码：

```
raindrop.position = CGPoint(x: size.width / 2, y: size.height / 2)

```

将其替换成如下代码：

```
let xPosition =
	CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
let yPosition = size.height + raindrop.size.height

raindrop.position = CGPoint(x: xPosition, y: yPosition)

```

在创建雨滴之后，我们利用 `arc4Random()` 来随机化 `x` 坐标，并通过调用 `truncatingRemainder` 来确保坐标在屏幕范围内。现在运行程序，你应该可以看到这样的效果：

[![雨下一整天!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Raindrops-for-days-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Raindrops-for-days-preview-opt.png)<sup>[\[15\]](#note-15)</sup>

这雨可以下好几天！

我们可以尝试不同的雨滴生成速率，雨滴生成的快慢将会根据我们设置的值变化。将 `rainDropSpawnRate` 设置为 `0` ，你将会看到漫天的雨滴。但如果你真的这么做了，你就会发现一个严重的问题。我们相当于创建了无数个对象，并且永远没有清除它们的机制，我们的帧率最终会掉到四帧左右，并且很快就会超出内存限制。

### 监测碰撞

我们目前只需要考虑两种碰撞。雨滴之间的碰撞以及雨滴和地面的碰撞。我们需要监测雨滴碰撞到其它实体时的情况，并判断是否要移除雨滴。我们将引入另一个物理实体来充当全局边界（ world frame ）。任何触碰到边界的对象都会被销毁，内存压力也将得到缓解。我们还需要区分不同的物理实体。幸运的是，`SKPhysicsBody` 有一个名为 `categoryBitMask` 的属性。这个属性将帮助我们区分互相发生接触的对象。

要完成上述工作，我们将在 Xcode 左部面板的 “Support” 文件夹下新创建一个 `Constants.swift` 源文件。这个 “Constants” 文件将统一管理我们在整个工程中会用到的硬编码值（ hardcode value ）。我们并不会用到许多这种类型的变量，但把它们放在同一个地方管理是一个好习惯，这样我们就不需要在工程中到处寻找它们了。创建完文件后，在里面添加如下的代码：

```
let WorldCategory    : UInt32 = 0x1 << 1
let RainDropCategory : UInt32 = 0x1 << 2
let FloorCategory    : UInt32 = 0x1 << 3

```

上述的代码运用了 [移位运算符](http://www-numi.fnal.gov/offline_software/srt_public_context/WebDocs/Companion/cxx_crib/shift.html)<sup>[\[16\]](#note-16)</sup> 来为不同物理实体的 [`categoryBitMasks`](https://developer.apple.com/reference/spritekit/skphysicsbody/1519869-categorybitmask)<sup>[\[17\]](#note-17)</sup> 设置不同的唯一值。`0x1 << 1` 是十六进制的 1 ，`0x1 << 2` 是十六进制的 2 ，`0x1 << 3` 是十六进制的 4 ，后续的值依此类推，为前一个值的两倍。在设置这些特定的类别（ category ）之后，回到 `BackgroundNode.swift` 文件中，将我们的物理实体更新为刚创建的 `FloorCategory` 。接着，我们还要将地面物理实体设置为可触碰的。为了达到这个目的，将 `RainDropCategory` 添加到地面元素的 `contactTestBitMask` 中。如此一来，当我们将这些元素加入 `GameScene.swift` 中时，我们就能在二者（雨滴和地面）接触时收到回调了。`BackgroundNode` 代码如下：

```
import SpriteKit

public class BackgroundNode : SKNode {

  public func setup(size : CGSize) {

    let yPos : CGFloat = size.height * 0.10
    let startPoint = CGPoint(x: 0, y: yPos)
    let endPoint = CGPoint(x: size.width, y: yPos)

    physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
    physicsBody?.restitution = 0.3
    physicsBody?.categoryBitMask = FloorCategory
    physicsBody?.contactTestBitMask = RainDropCategory
  }
}

```

下一步则是为雨滴元素设置正确的类别，并为其添加可触碰元素。回到 `GameScene.swift` 中，在 `spawnRaindrop()` 方法中初始化雨滴物理实体的代码后面添加：

```
raindrop.physicsBody?.categoryBitMask = RainDropCategory
raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory

```

注意，此处我们也添加了 `WorldCategory` 。由于我们此处使用的是 [位掩码（ bitmask ）](https://en.wikipedia.org/wiki/Mask_%28computing%29)<sup>[\[18\]](#note-18)</sup> ，我们可以通过 [位运算（ bitwise operation）](https://en.wikipedia.org/wiki/Bitwise_operation)<sup>[\[19\]](#note-19)</sup> 来添加任何我们想要的类别。而对于本例中的 `raindrop` 实例，我们希望监听它与 `FloorCategory` 以及 `WorldCategory` 发生碰撞时的信息。现在，我们终于可以在 `sceneDidLoad()` 方法中加入我们的全局边界了：

```
var worldFrame = frame
worldFrame.origin.x -= 100
worldFrame.origin.y -= 100
worldFrame.size.height += 200
worldFrame.size.width += 200

self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
self.physicsBody?.categoryBitMask = WorldCategory

```

在上述代码中，我们创建了一个和场景形状相同的边界，只不过我们将每个边都扩张了 100 个点。这相当于创建了一个缓冲区，使得元素在离开屏幕后才会被销毁。注意我们所使用的 `edgeLoopFrom` ，它创建了一个空白矩形，其边界可以和其它元素发生碰撞。

现在，一切用于检测碰撞的准备都已经就绪了，我们只需要监听它就可以了。为我们的游戏场景添加对 `SKPhysicsContactDelegate` 协议的支持。在文件的顶部，找到这一行代码：

```
class GameScene: SKScene {

```

把它改成这样：

```
class GameScene: SKScene, SKPhysicsContactDelegate {

```

现在，我们需要监听场景的 [`physicsWorld`](https://developer.apple.com/reference/spritekit/skphysicsworld)<sup>[\[20\]](#note-20)</sup> 中所发生的碰撞。在 `sceneDidLoad()` 中，我们设置全局边界的逻辑下面添加如下代码：

```
	self.physicsWorld.contactDelegate = self

```

接着，我们需要实现 `SKPhysicsContactDelegate` 中的一个方法，`didBegin(_ contact:)`。每当带有我们预先设置的 `contactTestBitMasks` 的物体碰撞发生时，这个方法就会被调用。在 `GameScene.swift` 的底部，加入如下代码：

```
func didBegin(_ contact: SKPhysicsContact) {
    if (contact.bodyA.categoryBitMask == RainDropCategory) {
      contact.bodyA.node?.physicsBody?.collisionBitMask = 0
      contact.bodyA.node?.physicsBody?.categoryBitMask = 0
    } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
      contact.bodyB.node?.physicsBody?.collisionBitMask = 0
      contact.bodyB.node?.physicsBody?.categoryBitMask = 0
    }
}

```

现在，当一滴雨滴和任何其它对象的边缘发生碰撞后，我们会将其碰撞掩码（ collision bitmask ）清零。这样做可以避免雨滴在初次碰撞后反复与其它对象碰撞，最终变成像俄罗斯方块那样的噩梦！

[![弹跳的雨滴](https://www.smashingmagazine.com/wp-content/uploads/2016/10/happy-bouncing-raindrops.gif) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/happy-bouncing-raindrops.gif)<sup>[\[21\]](#note-21)</sup>

愉快蹦达着的小雨滴

如果雨滴的表现没有像 GIF 图中所展示的那样，回头确认所有的 `categoryBitMask` 和 `contactTestBitMasks` 都被正确设置了。同时，你应该注意到场景右下角的结点数目会持续增长。雨滴不会再堆积在地面上了，但它们也没有从场景中移除。如果我们不做移除工作，内存依然会出现不足的情况。

在 `didBegin(_ contact:)` 方法中，我们需要加入销毁操作来移除这些结点。该方法需要被修改成这样：

```
func didBegin(_ contact: SKPhysicsContact) {
     if (contact.bodyA.categoryBitMask == RainDropCategory) {
      contact.bodyA.node?.physicsBody?.collisionBitMask = 0
      contact.bodyA.node?.physicsBody?.categoryBitMask = 0
    } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
      contact.bodyB.node?.physicsBody?.collisionBitMask = 0
      contact.bodyB.node?.physicsBody?.categoryBitMask = 0
    }

    if contact.bodyA.categoryBitMask == WorldCategory {
      contact.bodyB.node?.removeFromParent()
      contact.bodyB.node?.physicsBody = nil
      contact.bodyB.node?.removeAllActions()
    } else if contact.bodyB.categoryBitMask == WorldCategory {
      contact.bodyA.node?.removeFromParent()
      contact.bodyA.node?.physicsBody = nil
      contact.bodyA.node?.removeAllActions()
    }
}

```

现在，运行程序，我们会看到结点计数器增长到 6 个结点左右之后便会维持在那个数字。如果确实如此，那就证明我们成功的移除了那些离开屏幕的结点了。

### 更新背景结点

目前为止，背景结点都非常的简单。它只是一个 `SKPhysicsBody` ，也就是一条线。我们要对它进行升级来让我们的应用看起来更棒。放在以前，我们会用一个 `SKSpriteNode` 来实现这个需求，但这意味着要为一个简单背景耗费一块巨大的纹理。由于背景仅仅由两种颜色组成，我们可以通过创建两个 `SKShapeNode` 来达到天空和地面的效果。

打开 `BackgroundNode.swift` 并在 `setup(size)` 方法中，初始化 `SKPhysicsBody` 的下面添加如下代码：

```
let skyNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: size))
skyNode.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
skyNode.strokeColor = SKColor.clear
skyNode.zPosition = 0

let groundSize = CGSize(width: size.width, height: size.height * 0.35)
let groundNode = SKShapeNode(rect: CGRect(origin: CGPoint(), size: groundSize))
groundNode.fillColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
groundNode.strokeColor = SKColor.clear
groundNode.zPosition = 1

addChild(skyNode)
addChild(groundNode)

```

在上述代码中，我们创建了两个矩形的 `SKShapeNode` 实例，但引入 `zPosition` 导致了一个新问题。我们将 `skyNode` 的 `zPosition` 设为 `0` ，而地面结点设置为 `1`，如此一来，在渲染时地面就会始终在天空之上。如果你现在运行程序，你会发现，雨滴会被渲染在天空之上，但却在地面之下。这显然不是我们想要的。让我们回到 `GameScene.swift` 中，更新 `spawnRaindrop()` 方法中雨滴的 `zPosition` ，使之在被渲染在地面之上。在 `spawnRaindrop()` 方法中，设置雨滴出现位置的下方，加入下列代码：

```
raindrop.zPosition = 2

```

再次运行程序，背景应该能够被正常绘制了。

[![背景](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Background-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Background-preview-opt.png)<sup>[\[22\]](#note-22)</sup>

这下就好多了。

### 添加交互

现在对雨滴和背景的设置都已经完成了，我们可以开始添加交互了。在 “Sprites” 文件夹下添加 `UmbrellaSprite.swift` 源文件，并添加下列代码以生成雨伞的雏形。

```
import SpriteKit

public class UmbrellaSprite : SKSpriteNode {
  public static func newInstance() -> UmbrellaSprite {
    let umbrella = UmbrellaSprite(imageNamed: "umbrella")

    return umbrella
  }
}

```

一个非常基础的对象就能满足创建雨伞的要求了。目前，我们只是使用一个静态方法创建了一个新的精灵结点（ sprite node ），但别急，一会我们就会为其添加一个自定的物理实体了。我们可以像创建雨滴一样，调用 `init(texture: size:)` 方法来用纹理创建一个物理实体。这样做也是可以的，但是雨伞的把手就会被物理实体所环绕。如果把手被物理实体环绕，那么猫就可能被挂在伞上，这个游戏也就因此失去了许多乐趣。所以，我们会转而通过在 `newInstance()` 方法中构造一个 `CGPath` 来初始化 `SKPhysicsBody` 。将下列代码添加到 `UmbrellaSprite.swift` 的 `newInstance()` 方法中，返回雨伞对象的语句之前。

```
let path = UIBezierPath()
path.move(to: CGPoint())
path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))

umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
umbrella.physicsBody?.isDynamic = false
umbrella.physicsBody?.restitution = 0.9

```

我们自己创建路径来初始化雨伞的 `SKPhysicsBody` 主要有两个原因。首先，就像之前提到的一样，我们只希望雨伞的顶部能够与其它对象碰撞。其次，这样我们可以自行调控雨伞的有效撞击区域。

先创建一个 `UIBezierPath` 并添加点和线绘制好图形后，再通过它生成 `CGPath` 是一个相对简单的方法。上述代码中，我们就创建了一个 `UIBezierPath` 并将其绘制起点移动到精灵的中心点。`umbrellaSprite` 的中心点是 `0,0` 的原因是：其 [`anchorPoint`](https://developer.apple.com/reference/spritekit/skspritenode#//apple_ref/occ/instp/SKSpriteNode/anchorPoint)<sup>[\[23\]](#note-23)</sup> 的值为 `0.5,0.5` 。接着，我们向左侧添加一条线，并向外延伸 30 个点（ points ）。

本文中关于“点（ point ）”的概念的注解：一个“点”，不要与 `CGPoint` 或是我们的 `anchorPoint` 混淆，它是一个测量单位。在非 Retina 设备上，一个点等于一个像素，在 Retina 设备上则等于两个像素，这个值会随着屏幕分辨率的提高而增加。更多相关知识，请参阅 Fluid 博客中的 [pixels and points](http://blog.fluidui.com/designing-for-mobile-101-pixels-points-and-resolutions/)<sup>[\[24\]](#note-24)</sup> 。

随后，我们一路画到精灵的顶部中点位置，再画到中部右侧，并向外延伸 30 个点。我们向外延伸一些距离，是为了在保持精灵外观的前提下，增大其能遮雨的区域。当我们用这个多边形初始化 `SKPhysicsBody` 时，路径将会自动闭合成一个完整的三角形。接着，将雨伞的物理状态设置为非动态，这样它就不会受重力影响了。我们绘制的这个物理实体看起来是这样的：

[![雨伞特写](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png)<sup>[\[25\]](#note-25)</sup>

雨伞物理实体的特写（[放大版本](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png)<sup>[\[26\]](#note-26)</sup>）

现在，到 `GameScene.swift` 中来初始化雨伞对象并将其加入场景中。在文件顶部，类变量的下方，加入下面的代码：

```
private let umbrellaNode = UmbrellaSprite.newInstance()

```

接着，在 `sceneDidLoad()` 中，将 `backgroundNode` 加入场景的下面，加入如下代码来将雨伞放置在屏幕中央：

```
umbrellaNode.position = CGPoint(x: frame.midX, y: frame.midY)
umbrellaNode.zPosition = 4
addChild(umbrellaNode)

```

完成上述操作后，再运行程序，你就能看见雨伞了，同时你还会发现雨滴将会被雨伞弹开！

### 动起来

我们要为雨伞添加手势响应了。聚焦到 `GameScene.swift` 中的空方法 `touchesBegan(_ touches:, with event:)` 和 `touchesMoved(_ touches:, with event:)` 。这两个方法会把我们的交互操作传递给雨伞对象。如果我们在两个方法中都直接根据当前的触摸来更新雨伞的位置，雨伞将会从屏幕的一个位置瞬间移动到另一位置。

另一个可行方法是，实时设置 `UmbrellaSprite` 对象的终点，并且在 `update(dt:)` 方法被调用时，逐步向终点方向移动。

而第三个可选方案则是在 `touchesBegan(_ touches:, with event:)` 或 `touchesMoved(_ touches:, with event:)` 中通过设置一系列 `SKAction` 来移动 `UmbrellaSprite` ，但我不推荐这么做。这样做会导致 `SKAction` 对象被频繁创建和销毁，使得性能变差。

我们这里选择第二个解决方案。将 `UmbrellaSprite` 的代码改成下面这样：

```
import SpriteKit

public class UmbrellaSprite : SKSpriteNode {
  private var destination : CGPoint!
  private let easing : CGFloat = 0.1

  public static func newInstance() -> UmbrellaSprite {
    let umbrella = UmbrellaSprite(imageNamed: "umbrella")

    let path = UIBezierPath()
    path.move(to: CGPoint())
    path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
    path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
    path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))

    umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
    umbrella.physicsBody?.isDynamic = false
    umbrella.physicsBody?.restitution = 0.9

    return umbrella
  }

  public func updatePosition(point : CGPoint) {
    position = point
    destination = point
  }

  public func setDestination(destination : CGPoint) {
    self.destination = destination
  }

  public func update(deltaTime : TimeInterval) {
    let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))

    if(distance > 1) {
      let directionX = (destination.x - position.x)
      let directionY = (destination.y - position.y)

      position.x += directionX * easing
      position.y += directionY * easing
    } else {
      position = destination;
    }
  }
}

```

这里主要干了这么几件事。`newInstance()` 方法保持不变，但我们在它的上方加入了两个变量。我们加入了 destination 变量（保存对象移动的终点位置）；我们加入了 `setDestination(destination:)` 方法来缓冲雨伞的移动；我们还加入了一个 `updatePosition(point:)` 方法。

`updatePosition(point:)` 方法将会在我们进行刷新操作之前直接对 `position` 属性进行赋值（译者注：此处的意思是，雨伞的移动本应是设置终点后，在 `update(dt:)` 方法中逐步移动，但这个 `updatePosition(point:)` 方法将直接移动雨伞）。现在我们可以同时更新 position 和 destination 了。如此一来， `umbrellaSprite` 对象就会被移动到相应位置，并保持在原地，由于这个位置就是它的终点，它也不会在设置位置后立刻移动了。

`setDestination(destination:)` 方法仅更新 destination 属性的值；我们会在后续对这个值进行一系列运算。最终，我们在 `update(dt:)` 方法中添加了计算我们所需要向终点方向移动多少距离的逻辑。我们计算两点之间的距离，如果距离大于一个点，我们就结合 `easing` 属性来计算移动的距离（译者注：原文写的是 `easing` function ，但实际代码中 `easing` 只是一个 factor 属性）。在计算出对象需要移动的方向和距离后， `easing` 属性将每个坐标轴上所需移动的距离乘以 10% ，作为实际移动距离。这样做的话，雨伞就不会瞬间到达新的位置了，当雨伞离目标位置较远时，其移动速度会较快，而当它接近终点附近，它的速度便会逐渐减低。如果距离终点距离不足一个点，我们就直接移动到终点。我们这样做是因为缓冲机制（easing function）的存在会使终点附近的移动非常缓慢。不用反复地计算、更新并每次将雨伞移动一小段距离，我们只需要简单地设置好终点位置就可以了。

回到 `GameScene.swift` 中，将 `touchesBegan(_ touches: with event:)` 和 `touchesMoved(_ touches: with event:)` 中的逻辑做如下修改：

```
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      umbrellaNode.setDestination(destination: point)
    }
  }

override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchPoint = touches.first?.location(in: self)

    if let point = touchPoint {
      umbrellaNode.setDestination(destination: point)
    }
  }

```

现在，我们的雨伞就能响应触摸事件了。在每个方法中，我们都检测触摸是否有效。有效的话，我们就将雨伞的终点更新为触摸的位置。接下来，把 `sceneDidLoad()` 中的这行代码：

```
umbrella.position = CGPoint(x: frame.midX, y: frame.midY)
```

修改成：

```
umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
```

这样，雨伞的初始位置和终点就设置好了。当我们运行程序，场景中的雨伞仅会在我们进行手势交互时才会移动。最后，我们要在 `update(currentTime:)` 中通知雨伞进行更新。

在 `update(currentTime:)` 的底部加入如下代码：

```
umbrellaNode.update(deltaTime: dt)

```

再次运行程序，雨伞应该能够正确地跟着点击和拖动手势进行移动了。

嘿，第一课到此结束啦！我们接触到了许多概念，并自己动手搭建了基础代码，接着又添加了一个容器结点来容纳背景和地面的 `SKPhysicsBody` 。我们还成功使新的雨滴定时出现，并让雨伞响应我们的手势。你可以在 [GitHub上找到](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one)<sup>[\[27\]](#note-27)</sup> 第一课内容所涉及的源代码。

你完成的怎么样？你的代码实现是否和我的示例几乎一样？哪里有不同呢？你是否优化了示例代码？教程中是否有阐述不清晰的地方？请在评论中写下你的想法。

感谢你坚持完成了第一课。让我们拭目以待 RainCat 第二课吧！

#### 注释

1. <a name="note-1"></a>https://developer.apple.com/spritekit/
2. <a name="note-2"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header-preview-opt.png
3. <a name="note-3"></a>https://itunes.apple.com/us/app/raincat/id1152624676?ls=1&mt=8
4. <a name="note-4"></a>https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-initial-code
5. <a name="note-5"></a>https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson4.html
6. <a name="note-6"></a>https://developer.apple.com/reference/spritekit/skscene
7. <a name="note-7"></a>https://www.raywenderlich.com/118225/introduction-sprite-kit-scene-editor
8. <a name="note-8"></a>https://github.com/thirteen23/RainCat/tree/smashing-day-1/dayOneAssets.zip
9. <a name="note-9"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png
10. <a name="note-10"></a>https://developer.apple.com/reference/spritekit/sknode
11. <a name="note-11"></a>https://developer.apple.com/reference/spritekit/skphysicsbody
12. <a name="note-12"></a>https://developer.apple.com/reference/spritekit/skphysicsworld
13. <a name="note-13"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Empty-scene-preview-opt.png
14. <a name="note-14"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/first-rain-fall.gif
15. <a name="note-15"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Raindrops-for-days-preview-opt.png
16. <a name="note-16"></a>http://www-numi.fnal.gov/offline_software/srt_public_context/WebDocs/Companion/cxx_crib/shift.html
17. <a name="note-17"></a>https://developer.apple.com/reference/spritekit/skphysicsbody/1519869-categorybitmask
18. <a name="note-18"></a>https://en.wikipedia.org/wiki/Mask_%28computing%29
19. <a name="note-19"></a>https://en.wikipedia.org/wiki/Bitwise_operation
20. <a name="note-20"></a>https://developer.apple.com/reference/spritekit/skphysicsworld
21. <a name="note-21"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/happy-bouncing-raindrops.gif
22. <a name="note-22"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Background-preview-opt.png
23. <a name="note-23"></a>https://developer.apple.com/reference/spritekit/skspritenode#//apple_ref/occ/instp/SKSpriteNode/anchorPoint
24. <a name="note-24"></a>http://blog.fluidui.com/designing-for-mobile-101-pixels-points-and-resolutions/
25. <a name="note-25"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png
26. <a name="note-26"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png
27. <a name="note-27"></a>https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one
