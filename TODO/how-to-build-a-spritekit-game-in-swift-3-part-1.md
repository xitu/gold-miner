> * 原文地址：[How To Build A SpriteKit Game In Swift 3 (Part 1)](https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/)
* 原文作者：[Marc Vandehey](https://www.smashingmagazine.com/author/marcvandehey/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015/)
* 校对者：

# How To Build A SpriteKit Game In Swift 3 (Part 1)
# 如何在 Swift 3 中用 SpriteKit 框架编写游戏 (Part 1)

**Have you ever wondered what it takes to create a SpriteKit game from beginning to beta? Does developing a physics-based game seem daunting? Game-making has never been easier on iOS since the introduction of [SpriteKit](https://developer.apple.com/spritekit/) [1](#1).**

In this three-part series, we will explore the basics of SpriteKit. We will touch on SKPhysics, collisions, texture management, interactions, sound effects, music, buttons and `SKScene`s. What might seem difficult is actually pretty easy to grasp. Stick with us while we make RainCat.

**你有没有想过想一款 SpriteKit 游戏从无到有的过程是怎样的？开发一款基于真实物理规则的游戏是不是让你望而生畏？随着 [SpriteKit](https://developer.apple.com/spritekit/) [1](#1) 的出现，在 iOS 上开发游戏已经变得空前的简单了。**

本系列将分为三个部分，带你探索 SpriteKit 的基础知识。我们会接触到 SKPhysics 、（ Sprite 间的）碰撞、纹理管理、（ Sprite 间的）相互作用、音效、音乐、按钮以及 `SKScene` 。这些看起来很难的东西其实非常容易掌握。赶紧跟着我们一起开始编写 RainCat 吧。

[![Raincat: 第一课](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header-preview-opt.png)

[2](#2)

RainCat, lesson 1

The game we will build has a simple premise: We want to feed a hungry cat, but it is outside in the rain. Ironically, RainCat does not like the rain all that much, and it gets sad when it’s wet. To fix this, we must hold an umbrella above the cat so that it can eat without getting rained on. To get a taste of what we will be creating, check out the [completed project](https://itunes.apple.com/us/app/raincat/id1152624676?ls=1&amp;mt=8)[3](#3). It has some more bells and whistles than what we will cover here, but you can look at those additions later on GitHub. The aim of this series is to get a good understanding of what goes into making a simple game. You can check in with us later on and use the code as a reference for future projects. I will keep updating the code base with interesting additions and refactoring.

We will do the following in this article:

- check out the initial code for the RainCat game;
- add a floor;
- add raindrops;
- prepare the initial physics;
- add in the umbrella object to keep our cat dry from the rain;
- begin collision detection with `categoryBitMask` and `contactTestBitMask`;
- create a world boundary to remove nodes that fall off screen.

RainCat，第一课

我们将要实现的这个游戏有一个简单的前提：我们想喂饱一只饥肠辘辘的猫，但它现在正孤身地站在雨中。不巧地是，RainCat 并不喜欢下雨天，而它被淋湿之后就会觉得很难过。为了让它能在大吃的时候不被雨水淋到，我们必须要替它撑把伞。想先体验一下我们的目标成果的话，看看 [完整项目](https://itunes.apple.com/us/app/raincat/id1152624676?ls=1&amp;mt=8) 吧。项目中会有一些文章里不会涉及到的进阶内容，但你可以稍后在 GitHub 上面看到这些内容。本系列的目标是让你深刻地理解做一个简单地游戏需要投入些什么。你可以随时与我们联系，并把这些代码作为将来其它项目的参考。我将会持续更新代码库，添加一些有趣的新功能并对一些部分进行重构。

在本文中，我们将：

- 查看 RainCat 游戏的初始代码；
- （为游戏）添加地面；
- （为游戏）添加雨滴；
- 初始化物理引擎；
- 添加雨伞对象，替猫儿遮雨；
- 利用 `categoryBitMask` 和 `contactTestBitMask` 来实现碰撞检测；
- 创造一个全局边界（ world boundary ）来移除落出屏幕的结点（ node ）。

### Getting Started

You will need to follow along with a few things. To make it easier to start, I’ve provided a base project. This base project removes all of the boilerplate code that Xcode 8 provides when creating a new SpriteKit project.

- Get the base code for the RainCat game by downloading the [custom Xcode project](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-initial-code)[4](#4).
- Install Xcode 8.
- Get something to test on! In this case, it should be an iPad, which will remove some of the complexity of developing for multiple screen sizes. The simulator is functional, but it will always lag and run at a lower frame rate than a proper iOS device.

### 入门

接下来有几件事需要你跟着完成。为了让你轻松起步，我准备好了一个基础工程。这个工程把 Xcode 8 在创建新的 SpriteKit 工程时联带生成的冗余代码都删的一干二净了。

- 从 [这里](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-initial-code) 下载 RainCat 游戏工程的基础代码。
- 安装 Xcode 8。
- 找一台测试机器！在本例中，你应该找一台 iPad ，这样可以避免做复杂的屏幕适配。模拟器也是可以的，但是操作上会有延迟，而且比在真实设备上的帧数低不少。

### Check Out The Project

I’ve given you a head start by creating the project for the RainCat game and completing some initial steps. Open up the Xcode project. It will look fairly barebones at the moment. Here is an overview of what has happened up to this point: We’ve created a project, targeted iOS 10, set the devices to iPad, and set the orientation to landscape only. We can get away with targeting previous versions of iOS, back to version 8 with Swift 3, if we need to test on an older device. Also, a best practice is to support at least one version of iOS older than the current version. Just note that this tutorial targets iOS 10, and issues may arise if you target a previous version.

Side note on the usage of Swift 3 for this game: The iOS development community has been eagerly anticipating the release of Swift 3, which brings with it many changes in coding styles and improvements across the board. As new iOS versions are quickly and widely adopted by Apple’s consumer base, we decided it would be best to present the lessons in this article according to this latest release of Swift.

In `GameViewController.swift`, which is a standard [`UIViewController`](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson4.html)[5](#5), we reworked how we load the initial [SKScene](https://developer.apple.com/reference/spritekit/skscene)[6](#6) named `GameScene.swift`. Before this change, the code would load the `GameScene` class through a SpriteKit scene editor (SKS) file. For this tutorial, we will load the scene directly, instead of inflating it using the SKS file. If you wish to learn more about the SKS file, Ray Wenderlich has a [great example](https://www.raywenderlich.com/118225/introduction-sprite-kit-scene-editor)[7](#7).


### 查看工程代码

我已经帮你起了个好头了，创建好了 RainCat 工程，还做了一些初始化的工作。打开这个 Xcode 工程。现在，项目看起来还非常的简单基础。我们先梳理一下现在的情况：我们创建了一个工程，指定运行系统为 iOS 10，运行设备为 iPad ，支持的设备方向为水平。如果我们要在较旧的设备上进行测试，我们也可以把系统版本设定为更早的版本，Swift 3 至多支持到 iOS 8 。当然，让你的应用支持起码比最新版本要早一个版本的系统也是一个很好的实践。不过需要注意：本教程内容仅针对 iOS 10 ，如果你要支持更早的版本的话，可能会出现一些问题。

决定利用 Swift 3 来实现这个游戏的原因： iOS 开发者社区非常积极地参与到了 Swift 3 的发布过程中，带来了许多编码风格上的变化和全方位的升级。由于新版本的 iOS 系统在 Apple 用户群体中覆盖速率快、面积广，我们认为，使用最新发布的 Swift 版本来编写这篇教程是最合适的。

在 `GameViewController.swift` 中有一个标准的 [`UIViewController`](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson4.html) 子类 ，我们修改了一些初始化 `GameScene.swift` 中的 [`SKScene`](https://developer.apple.com/reference/spritekit/skscene) 的代码。在做这些改动之前，我们会通过一个 SpriteKit 场景编辑器文件（ SpriteKit scene editor (SKS) file ）来读取 `GameScene` 类。在本教程中，我们将直接读取这个场景，而不是使用更复杂的 SKS 文件。如果你想更深入地了解 SKS 文件的相关知识， Ray Wenderlich 有一篇 [极佳的文章](https://www.raywenderlich.com/118225/introduction-sprite-kit-scene-editor) 。

### Get Your Assets

Before we can start coding, we need to get the assets for the project. Today we will have an umbrella sprite, along with raindrops. You will [find the textures on GitHub](https://github.com/thirteen23/RainCat/tree/smashing-day-1/dayOneAssets.zip)[8](#8). Add them to your `Assets.xcassets` folder in the left pane of Xcode. Once you click on the `Assets.xcassets` file, you will be greeted with a white screen with a placeholder for the `AppIcon`. Select all of the files in a Finder window, and drag them below the `AppIcon` placeholder. If that is done correctly, your “Assets” file will look like this:

![App assets](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png)[9](#9)

The umbrella’s top won’t show up due to being white on white, but I promise it is there.

### 获取资源文件

在动手打代码之前，我们要先获取项目中会用到的资源。今天我们会用到雨伞精灵（ sprite ）和雨滴。你可以在 [GitHub 上找到这些纹理](https://github.com/thirteen23/RainCat/tree/smashing-day-1/dayOneAssets.zip) 。将它们添加到 Xcode 左部面板的 `Assets.xcassets` 文件夹中。当你点击 `Assets.xcassets` 文件，你会见到一个带有 `AppIcon` 占位符的空白界面。在 Finder 中选中所有（解压的资源文件），并把它们都拖到 `AppIcon` 占位符的下面。如果你正确进行了上述操作，你的 “Assets” 文件看起来应该是这样：

![App assets](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png)

由于雨伞的顶端是白色的，你现在看不到它，但我保证，它是在那儿的。

### Time To Start Coding

Now that we have a lot of the initial configuration out of the way, we can get started making the game.

The first thing we need is a floor, since we need a surface for the cat to walk and feed on. Because the floor and the background will be extremely simple, we can handle those sprites with a custom background node. Under the “Sprites” group in the left pane of Xcode, create a new Swift file named `BackgroundNode.swift`, and insert the following code:

### 是时候动手编码了

现在我们已经做足了各项准备工作，我们可以开始动手开发游戏啦。

我们首先要做出个地面，好腾出地方来遛猫和喂猫。由于背景和地面都非常的简单，我们可以把这些精灵（ sprite ）放到一个自定义的背景结点（ node ）中。在 Xcode 左部面板的 “Sprites” 文件夹下，创建名为 `BackgroundNode.swift` 的 Swift 源文件（译者注：由于 “Sprites” 文件夹下一开始无任何文件，因此原工程文件目录下并没有这个文件夹， Xcode 工程中仅有一个逻辑文件夹，读者可以自己在工程目录下创建 “Sprites” 文件夹），并添加以下代码：

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

The code above imports our SpriteKit framework. This is Apple’s library for developing games. We will be using this in pretty much every file we create from now on. This object that we are creating is an [`SKNode`](https://developer.apple.com/reference/spritekit/sknode)[10](#10). We will be using it as a container for our background. Currently, we just add an [`SKPhysicsBody`](https://developer.apple.com/reference/spritekit/skphysicsbody)[11](#11) to it when we call the `setup(size:)` function. The physics body will tell our scene that we want this defined area, currently a line, to interact with other physics bodies, as well as with the [physics world](https://developer.apple.com/reference/spritekit/skphysicsworld)[12](#12). We also snuck in a change to `restitution`. This property determines how bouncy the floor will be. To have it show up for us to use, we need to add it to `GameScene`. Move to the `GameScene.swift` file, and near the top of the file, underneath our group of `TimeInterval` variables, we can add this:

上面的代码引用了 SpriteKit 框架。这是 Apple 官方的用于开发游戏的代码库。在我们接下来新建的大部分源文件中，我们都会用到它。我们创建的这个对象是一个 [`SKNode`](https://developer.apple.com/reference/spritekit/sknode) 实例，我们会把它作为背景元素的容器。目前，我们仅仅是在调用 `setup(size:)` 方法的时候为其添加了一个 [`SKPhysicsBody`](https://developer.apple.com/reference/spritekit/skphysicsbody) 实例。这个物理实体（ physics body ）会告诉我们的场景（ scene ），其定义的区域（目前只有一条线），能够和其它的物理实体和 [物理世界（ physics world ）](https://developer.apple.com/reference/spritekit/skphysicsworld) 进行交互。我们还改变了 `restitution` 的值。这个属性决定了地面的弹性。想让这个对象为我们所用，我们需要把它加入 `GameScene` 中。切换到 `GameScene.swift` 文件中，在靠近顶部，一串 `TimeInterval` 变量的下面，添加如下代码：

```
private let backgroundNode = BackgroundNode()

```

Then, inside the `sceneDidLoad()` function, we can set up and add the background to the scene with the following lines:
然后，在 `sceneDidLoad()` 方法中，我们可以初始化背景，并将其加入场景中：

```
backgroundNode.setup(size: size)
addChild(backgroundNode)

```

Now, if we run the app, we will be greeted with this game scene:

现在，如果我们运行程序，我们将会看到如图的游戏场景：

[![Empty scene](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Empty-scene-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Empty-scene-preview-opt.png)[13](#13)

Our slightly less empty scene

我们的略微空旷的场景。

If you don’t see this line, then something went wrong when you added the node to the scene, or else the scene is not showing the physics bodies. To turn these options on and off, go to `GameViewController.swift` and modify these values:

如果你没看见那条线，那说明你在将结点（ node ）加入场景（ scene ）时出现了错误，要么就是场（ scene ）现在不显示物理实体（ physics body ）。要控制这些选项的开关，只需要在 `GameViewController.swift` 中修改下列选项即可：

```
if let view = self.view as! SKView? {
	view.presentScene(sceneNode)
	view.ignoresSiblingOrder = true
	view.showsPhysics = true
	view.showsFPS = true
	view.showsNodeCount = true
}

```

Make sure that `showsPhysics` is set to `true` for now. This will help us to debug our physics bodies. Right now, this isn’t anything special to look at, but this will act as our floor for our raindrops to bounce off of, as well as the boundary within which the cat will walk back and forth.

现在，确保 `showsPhysics` 属性被设为 `true` 。这有助于我们调试物理实体。尽管眼下并没有什么值得特别关注的地方，但这个背景将会充当雨滴下落反弹时的地面，也会作为猫咪行走时的边界。

Next, let’s add some raindrops.

If we think before we just start adding them to the scene, we’ll see that we’ll want a reusable function to add one raindrop to the scene at a time. The raindrop will be made up of an `SKSpriteNode` and another physics body. An `SKSpriteNode` can be initialized by an image or a texture. Knowing this, and also knowing that we will likely spawn a lot of raindrops, we need to do some recycling. With this in mind, we can recycle the texture so that we aren’t creating a new texture every time we create a raindrop.

At the top of the `GameScene.swift` file, above where we initialized `backgroundNode`, we can add the following line to the file:

接下来，我们来添加一些雨水：
如果我们在一股脑的把雨滴加入场景之前思考一下，就会明白在这儿我们需要一个可复用的方法来原子性地添加雨滴。雨滴元素将由一个 `SKSpriteNode` 和另外一个物理实体构成。你可以用一张图片或是一块纹理来实例化一个 `SKSpriteNode` 对象。明白了这点，并且想到我们应该会添加许多的雨滴，我们就知道自己应该做一些复用了。有了这个想法，我们就可以复用纹理，而不必每次创建雨滴元素时都创建新的纹理了。

在 `GameScene.swift` 文件的顶部，实例化 `backgroundNode` 的前面，加入下面这行代码：

```
let raindropTexture = SKTexture(imageNamed: "rain_drop")

```

We can now reuse this texture every time we create a raindrop, so that we aren’t wasting memory by creating a new one every time we want a raindrop.

Now, add in the following function near the bottom of `GameScene.swift`, so that we can constantly create raindrops:

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

This function, when called, will create a raindrop using the `raindropTexture` that we just initialized. Then, we’ll create an `SKPhysicsBody` from the shape of the texture, position the raindrop node at the center of the scene and, finally, add it to the scene. Because we added an `SKPhysicsBody` to the raindrop, it will be automatically affected by the default gravity and fall to the floor. To test things out, we can call this function in `touchesBegan(_ touches:, with event:)`, and we will see this:

该方法被调用时，会利用我们刚刚创建的 `raindropTexture` 来生成一个新的雨滴结点。然后，我们通过纹理的形状创建 `SKPhysicsBody`，将结点位置设置为场景中央，并最终将其加入场景中。由于我们为雨滴结点添加了 `SKPhysicsBody` ，它将会自动地受到默认的重力作用并滴落至地面。为了测试这段代码，我们可以在 `touchesBegan(_ touches:, with event:)` 中调用这个方法，并看到如图的效果：

[![Making it rain](https://www.smashingmagazine.com/wp-content/uploads/2016/10/first-rain-fall.gif)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/first-rain-fall.gif)[14](#14)

Making it rain

让雨水来的更猛烈些吧

Now, as long as we keep tapping the screen, more raindrops will appear. This is for testing purposes only; later on, we will want to control the umbrella, not the rate of rainfall. Now that we’ve had our fun, we should remove the line that we added to `touchesBegan(_ touches:, with event:)` and tie in the rainfall to our `update` loop. We have a function named `update(_ currentTime:)`, and this is where we will want to spawn our raindrops. Some boilerplate code is here already; currently, we are measuring our delta time, and we will use this to update some of our other sprites later on. Near the bottom of that function, before we update our `self.lastUpdateTime` variable, we will add the following code:

只要我们不断地点击屏幕，雨滴就会远远不断地出现。这仅仅是出于测试的目的；毕竟最终我们想要控制的是雨伞，而不是雨水落下的速率。玩够了之后，我们就该把代码从 `touchesBegan(_ touches:, with event:)` 中删除，并将其绑定到我们的 `update` 循环中了。我们有一个名为 `update(_ currentTime:)` 的方法，我们希望在这个方法中进行降雨操作。方法中已经有一些基础代码了；目前，我们仅仅是测量时间差，但一会儿，我们将用它来更新其它的精灵元素。在这个方法的底部，更新 `self.lastUpdateTime` 变量之前，添加如下代码：

```
// Update the spawn timer
currentRainDropSpawnTime += dt

if currentRainDropSpawnTime > rainDropSpawnRate {
  currentRainDropSpawnTime = 0
  spawnRaindrop()
}

```

This will spawn a raindrop every time the accumulated delta time is greater than `rainDropSpawnRate`. Currently, the `rainDropSpawnRate` is 0.5 seconds; so, every half a second, a new raindrop will be created and fall to the floor. Test and run the app. It will act exactly as it did before, but instead of our having to touch the screen, a new raindrop will be created every half a second.

But this is not good enough. We don’t want one location from which to release the raindrops, and we certainly don’t want it to fall from the center of the screen. We can update the `spawnRaindrop()` function to position each new drop at a random `x` location at the top of the screen.

Find the following line in `spawnRaindrop()`:

上述代码在每次累加的时间差大于 `rainDropSpawnRate` 的时候，就会新建一个雨滴。`rainDropSpawnRate` 目前是 0.5 秒；也就是说，每过半秒钟就会有新的雨滴被创建并落至地面。运行程序来测试一下吧。现在你不需要点击屏幕，而是每过半秒就有一滴新的雨滴被创建并下落，就像之前一样。

但这还不够好。我们可不想所有雨滴都出现在同一个地方，更别说都从屏幕中间开始往下落了。我们可以更新 `spawnRaindrop()` 方法来随机化每个新雨滴的 `x` 坐标，并将它们放到屏幕顶部。

找到 `spawnRaindrop()` 方法中的这行代码：

```
raindrop.position = CGPoint(x: size.width / 2, y: size.height / 2)

```

Replace it with this:

将其替换成如下代码：

```
let xPosition =
	CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
let yPosition = size.height + raindrop.size.height

raindrop.position = CGPoint(x: xPosition, y: yPosition)

```

After creating the raindrop, we randomize the `x` position on screen with `arc4Random()`, and we make sure it is on screen with our `truncatingRemainder` method. Run the app, and you should see the following:

在创建雨滴之后，我们利用 `arc4Random()` 来随机化 `x` 坐标，并通过调用 `truncatingRemainder` 来确保坐标在屏幕范围内。现在运行程序，你应该可以看到这样的效果：

[![雨下一整天!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Raindrops-for-days-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Raindrops-for-days-preview-opt.png)[15](#15)

Raindrops for days!

We can play with the spawn rate, and we can spawn raindrops faster or slower depending on what value we enter. Update `rainDropSpawnRate` to be `0`, and you will see many pretty raindrops. If you do this, you will notice that we have a big problem now. We are currently spawning unlimited objects and never getting rid of them. We will eventually be crawling at four frames per second and, soon after that, we’ll be out of memory.

这雨可以下好几天！

我们可以尝试不同的雨滴生成速率，雨滴生成的快慢将会根据我们设置的值变化。将 `rainDropSpawnRate` 设置为 `0` ，你将会看到漫天的雨滴。但如果你真的这么做了，你就会发现一个严重的问题。我们相当于创建了无数个对象，并且永远没有清除它们的机制，我们的帧率最终会掉到四帧左右，并且很快就会超出内存限制。


### Detect Our Collision

Right now, there are only two types of collision. We have one collision between raindrops and one between raindrops and the floor. We need to detect when the raindrops hit something, so that we can tell it to be removed. We will add in another physics body that will act as the world frame. Anything that touches this frame will be deleted, and our memory will thank us for recycling. We need some way to tell the physics bodies apart. Luckily, `SKPhysicsBody` has a field named `categoryBitMask`. This will help us to differentiate between the items that have come into contact with each other.

To accomplish this, we should create another Swift file named `Constants.swift`. Create the file under the “Support” group in the left pane of Xcode. The “Constants” file enables us to hardcode values that will be used in many places across the app, all in one place. We won’t need many of these types of variables, but keeping them in one location is a good practice, so that we don’t have to search everywhere for these variables. After you create the file, add the following code to it:

### 监测碰撞

我们目前只需要考虑两种碰撞。雨滴之间的碰撞以及雨滴和地面的碰撞。我们需要监测雨滴碰撞到其它实体时的情况，并判断是否要移除雨滴。我们将引入另一个物理实体来充当全局边界（ world frame ）。任何触碰到边界的对象都会被销毁，内存压力也将得到缓解。我们还需要区分不同的物理实体。幸运的是，`SKPhysicsBody` 有一个名为 `categoryBitMask` 的属性。这个属性将帮助我们区分互相发生接触的对象。

要完成上述工作，我们将在 Xcode 左部面板的 “Support” 文件夹下新创建一个 `Constants.swift` 源文件。这个 “Constants” 文件将统一管理我们在整个工程中会用到的硬编码值（ hardcode value ）。我们并不会用到许多这种类型的变量，但把它们放在同一个地方管理是一个好习惯，这样我们就不需要在工程中到处寻找它们了。创建完文件后，在里面添加如下的代码：

```
let WorldCategory    : UInt32 = 0x1 << 1
let RainDropCategory : UInt32 = 0x1 << 2
let FloorCategory    : UInt32 = 0x1 << 3

```

The code above uses a [shift operator](http://www-numi.fnal.gov/offline_software/srt_public_context/WebDocs/Companion/cxx_crib/shift.html)[16](#16) to set a unique value for each of the [`categoryBitMasks`](https://developer.apple.com/reference/spritekit/skphysicsbody/1519869-categorybitmask)[17](#17) in our physics bodies. `0x1 << 1` is the hex value of 1, and `0x1 << 2` is the value of 2. `0x1 << 3` equals 4, and each value after that is doubled. Now that our unique categories are set up, navigate to our `BackgroundNode.swift` file, where we can update the physics body to the new `FloorCategory`. Then, we need to tell the floor physics body what we want to touch it. To do this, update the floor’s `contactTestBitMask` to contain the `RainDropCategory`. This way, when we have everything hooked up in our `GameScene.swift`, we will get callbacks when the two touch each other. `BackgroundNode` should now look like this:

上述的代码运用了 [移位运算符](http://www-numi.fnal.gov/offline_software/srt_public_context/WebDocs/Companion/cxx_crib/shift.html) 来为不同物理实体的 [`categoryBitMasks`](https://developer.apple.com/reference/spritekit/skphysicsbody/1519869-categorybitmask) 设置不同的唯一值。`0x1 << 1` 是十六进制的 1 ，`0x1 << 2` 是十六进制的 2 ，`0x1 << 3` 是十六进制的 4 ，后续的值依此类推，为前一个值的两倍。在设置这些特定的类别（ category ）之后，回到 `BackgroundNode.swift` 文件中，将我们的物理实体更新为刚创建的 `FloorCategory` 。接着，我们还要将地面物理实体设置为可触碰的。为了达到这个目的，将 `RainDropCategory` 添加到地面元素的 `contactTestBitMask` 中。如此一来，当我们将这些元素加入 `GameScene.swift` 中时，我们就能在二者（雨滴和地面）接触时收到回调了。`BackgroundNode` 代码如下：

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

The next step is to update the raindrops to the correct category, as well as update what it should come into contact with. Going back to `GameScene.swift`, in `spawnRaindrop()` we can add the following code after we initialize the raindrop’s physics body:

下一步则是为雨滴元素设置正确的类别，并为其添加可触碰元素。回到 `GameScene.swift` 中，在 `spawnRaindrop()` 方法中初始化雨滴物理实体的代码后面添加：

```
raindrop.physicsBody?.categoryBitMask = RainDropCategory
raindrop.physicsBody?.contactTestBitMask = FloorCategory | WorldCategory

```

Notice that we’ve added in the `WorldCategory` here, too. Because we are working with a [bitmask](https://en.wikipedia.org/wiki/Mask_%28computing%29)[18](#18), we can add in any category here that we want with [bitwise operations](https://en.wikipedia.org/wiki/Bitwise_operation)[19](#19). In this instance for `raindrop`, we want to listen for contact when the raindrop hits either the `FloorCategory` or `WorldCategory`. Now, in our `sceneDidLoad()` function, we can finally add in our world frame:

注意，此处我们也添加了 `WorldCategory` 。由于我们此处使用的是 [位掩码（ bitmask ）](https://en.wikipedia.org/wiki/Mask_%28computing%29) ，我们可以通过 [位运算（ bitwise operation）](https://en.wikipedia.org/wiki/Bitwise_operation) 来添加任何我们想要的类别。而对于本例中的 `raindrop` 实例，我们希望监听它与 `FloorCategory` 以及 `WorldCategory` 发生碰撞时的信息。现在，我们终于可以在 `sceneDidLoad()` 方法中加入我们的全局边界了：

```
var worldFrame = frame
worldFrame.origin.x -= 100
worldFrame.origin.y -= 100
worldFrame.size.height += 200
worldFrame.size.width += 200

self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
self.physicsBody?.categoryBitMask = WorldCategory

```

In the code above, we’ve create a frame that is the same as the scenes, but we’ve increased the size so that it extends 100 points on either side. This way, we will have a buffer so that items aren’t deleted on screen. Note that we’ve used `edgeLoopFrom`, which creates an empty rectangle that allows for collisions at the edge of the frame.

Now that we have everything in place for detection, we need to start listening to it. Update the game scene to inherit from `SKPhysicsContactDelegate`. Near the top of the file, find this line:

在上述代码中，我们创建了一个和场景形状相同的边界，只不过我们将每个边都扩张了 100 个点。这相当于创建了一个缓冲区，使得元素在离开屏幕后才会被销毁。注意我们所使用的 `edgeLoopFrom` ，它创建了一个空白矩形，其边界可以和其它元素发生碰撞。

现在，一切用于检测碰撞的准备都已经就绪了，我们只需要监听它就可以了。为我们的游戏场景添加对 `SKPhysicsContactDelegate` 协议的支持。在文件的顶部，找到这一行代码：

```
class GameScene: SKScene {

```

And change it to this:

把它改成这样：

```
class GameScene: SKScene, SKPhysicsContactDelegate {

```

We now need to tell our scene’s [`physicsWorld`](https://developer.apple.com/reference/spritekit/skphysicsworld)[20](#20) that we want to listen for collisions. Add in the following line in `sceneDidLoad()`, below where we set up the world frame:

现在，我们需要监听场景的 [`physicsWorld`](https://developer.apple.com/reference/spritekit/skphysicsworld) 中所发生的碰撞。在 `sceneDidLoad()` 中，我们设置全局边界的逻辑下面添加如下代码：

```
	self.physicsWorld.contactDelegate = self

```

Then, we need to implement one of the `SKPhysicsContactDelegate` functions, `didBegin(_ contact:)`. This will be called every time there is a collision that matches any of the `contactTestBitMasks` that we set up earlier. Add this code to the bottom of `GameScene.swift`:

接着，我们需要实现 `SKPhysicsContactDelegate` 中的一个协议方法，`didBegin(_ contact:)`。每当带有我们预先设置的 `contactTestBitMasks` 的物体碰撞发生时，这个方法就会被调用。在 `GameScene.swift` 的底部，加入如下代码：

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

Now, when a raindrop collides with the edge of any object, we’ll remove the collision bitmask of the raindrop. This prevents the raindrop from colliding with anything after the initial impact, which finally puts an end to our Tetris-like nightmare!

现在，当一滴雨滴和任何其它对象发生碰撞后，我们会将其碰撞掩码（ collision bitmask ）清零。这样做可以避免雨滴在初次碰撞后反复与其它对象碰撞，最终变成像俄罗斯方块那样的噩梦！

[![弹跳的雨滴](https://www.smashingmagazine.com/wp-content/uploads/2016/10/happy-bouncing-raindrops.gif) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/happy-bouncing-raindrops.gif)[21](#21)

Happy little bouncing raindrops

愉快蹦达着的小雨滴

If there is a problem and the raindrops are not acting like in the GIF above, double-check that every `categoryBitMask` and `contactTestBitMasks` is set up correctly. Also, note that the nodes count in the bottom-right corner of the scene will keep increasing. The raindrops are not piling up on the floor anymore, but they are not being removed from the game scene. We will continue running into memory issues if we don’t start culling.

In the `didBegin(_ contact:)` function, we need to add the delete behavior to cull the nodes. This function should be updated to the following:

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

Now, if we run our code, we will notice that the node counter will increase to about six nodes and will remain at that count. If this is true, then we are successfully culling off-screen nodes!

现在，运行程序，我们会看到结点计数器增长到 6 个结点左右之后便会维持在那个数字。如果确实如此，那就证明我们成功的移除了那些离开屏幕的结点了。

### Updating The Background Node

The background node has been very simple until now. It is just an `SKPhysicsBody`, which is one line. We need to upgrade it to make the app look a lot nicer. Initially, we would have used an `SKSpriteNode`, but that would have been a huge texture for such a simple background. Because the background will consist of exactly two colors, we can create two `SKShapeNodes` to act as the sky and the ground.

Navigate to `BackgroundNode.swift` and add the following code in the `setup(size)` function, below where we initialized the `SKPhysicsBody`.

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

In the code above, we’ve created two `SKShapeNodes` that are basic rectangles. But a new problem arises from `zPosition`. Note in the code above that `skyNode`’s `zPosition` is `0`, and the ground’s is `1`. This way, the ground will always render in front of the sky. If you run the app now, you will see the rain draw in front of the sky but behind the ground. This is not the behavior we want. If we move back to `GameScene.swift`, we can update the `spawnRaindrop()` function and set the `zPosition` of the raindrops to render in front of the ground. In the `spawnRaindrop()` function, below where we set the spawn position, add the following line:

在上述代码中，我们创建了两个矩形的 `SKShapeNode` 实例，但引入 `zPosition` 导致了一个新问题。我们将 `skyNode` 的 `zPosition` 设为 `0` ，而地面结点设置为 `1`，如此一来，在渲染时地面就会始终在天空之上。如果你现在运行程序，你会发现，雨滴会被渲染在天空之上，但却在地面之下。这显然不是我们想要的。让我们回到 `GameScene.swift` 中，更新 `spawnRaindrop()` 方法中雨滴的 `zPosition` ，使之在被渲染在地面之上。在 `spawnRaindrop()` 方法中，设置雨滴出现位置的下方，加入下列代码：

```
raindrop.zPosition = 2

```

Run the code again, and the background should be drawn correctly.

再次运行程序，背景应该能够被正常绘制了。

[![背景](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Background-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Background-preview-opt.png)[22](#22)

That’s better.

这就好多了

### Adding Interaction

Now that the rain is falling the way we want and the background is set up nicely, we can start adding some interaction. Create another file under the “Sprites” group, named `UmbrellaSprite.swift`. Add the following code for the initial version of the umbrella.

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

The umbrella will be a pretty basic object. Currently, we have a static function to create a new sprite node, but we will soon add a custom physics body to it. For the physics body, we could use the function `init(texture: size:)`, as we did with the raindrop, to create a physics body from the texture itself. This would work just fine, but then we would have a physics body that wraps around the handle of the umbrella. If we have a body around the handle, the cat would get hung up on the umbrella, which would not make for a fun game. Instead, we will add a `SKPhysicsBody` from the `CGPath` that we created in the static `newInstance()` function. Add the code below in `UmbrellaSprite.swift`, before we return the umbrella sprite’s `newInstance()` function.

一个非常基础的对象就能满足创建雨伞的要求了。目前，我们只是使用一个静态方法创建了一个新的精灵结点（ sprite node ），但别急，一会我们就会为其添加一个自定的物理实体了。我们可以像创建雨滴一样，调用 `init(texture: size:)` 方法来用纹理创建一个物理实体。这样做也是可以的，但是雨伞的把手就会被物理实体所环绕。如果把手被物理实体环绕，那么猫就可能被挂在伞上，这个游戏也就因此失去了许多乐趣。所以，我们会转而通过在 `newInstance()` 方法中构造一个 `CGPath` 来初始化 `SKPhysicsBody` 。将下列代码添加到 `UmbrellaSprite.swift` 的 `newInstance()` 方法中，把它放在返回雨伞精灵的语句之前。

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

We are creating a custom path for the umbrella’s `SKPhysicsBody` for two reasons. First, as mentioned, we only want the top part of the umbrella to have any collision. The second reason is so that we can be a little forgiving with the umbrella’s collision size.

The easy way to create a `CGPath` is to first create a `UIBezierPath` and append lines and points to create our basic shape. In the code above, we’ve created this `UIBezierPath` and moved the start point to the center of the sprite. The `umbrellaSprite`’s center point is `0,0` because our [`anchorPoint`](https://developer.apple.com/reference/spritekit/skspritenode#//apple_ref/occ/instp/SKSpriteNode/anchorPoint)[23](#23) of the object is `0.5,0.5`. Then, we add a line to the far-left side of the sprite and extend the line 30 points past the left edge.

Side note on usage of the word “point” in this context: A “point,” not to be confused with `CGPoint` or our `anchorPoint,` is a unit of measurement. A point may be 1 pixel on a non-Retina device, 2 pixels on a Retina device, and more depending on the pixel density of the device. Learn more about [pixels and points on Fluid’s blog](http://blog.fluidui.com/designing-for-mobile-101-pixels-points-and-resolutions/)[24](#24).

Next, go to the top-center point of the sprite for the top edge, followed by the far-right side, and extend them the same 30 points out. We’re extending the edge of the physics body past the texture to give us more room to block raindrops, while maintaining the look of the sprite. When we add the polygon to `SKPhysicsBody`, it will close the path for us and give us a complete triangle. Then, set the umbrella’s physics to not be dynamic, so that it won’t be affected by gravity. The physics body that we drew will look like this:

我们自己创建路径来初始化雨伞的 `SKPhysicsBody` 主要有两个原因。首先，就像之前提到的一样，我们只希望雨伞的顶部能够与其它对象碰撞。其次，这样我们可以自行调控雨伞的有效撞击区域。

先创建一个 `UIBezierPath` 并添加点和线绘制好图形后，再通过它生成 `CGPath` 是一个相对简单的方法。上述代码中，我们就创建了一个 `UIBezierPath` 并将其绘制起点移动到精灵的中心点。`umbrellaSprite` 的中心点是 `0,0` 的原因是：其 [`anchorPoint`](https://developer.apple.com/reference/spritekit/skspritenode#//apple_ref/occ/instp/SKSpriteNode/anchorPoint) 的值为 `0.5,0.5` 。接着，我们向左侧添加一条线，并向外延伸 30 个点（ points ）。

本文中关于“点（ point ）”的概念的注解：一个“点”，不要与 `CGPoint` 或是我们的 `anchorPoint` 混淆，它是一个测量单位。在非视网膜设备上，一个点等于一个像素，在视网膜设备上则等于两个像素，这个值会随着屏幕分辨率的提高而增加。更多相关知识，请参阅 [pixels and points on Fluid’s blog](http://blog.fluidui.com/designing-for-mobile-101-pixels-points-and-resolutions/)[24](#24) 。

随后，我们一路画到精灵的顶部中点位置，再画到中部右侧，并向外延伸 30 个点。我们向外延伸一些距离，是为了在保持精灵外观的前提下，增大其能遮雨的区域。当我们用这个多边形初始化 `SKPhysicsBody` 时，路径将会自动闭合成一个完整的三角形。接着，将雨伞的物理状态设置为非动态，这样它就不会受重力影响了。我们绘制的这个物理实体看起来是这样的：

[![雨伞特写](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png)[25](#25)

A closeup of the umbrella's physics body ([View large version](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png)[26](#26))

雨伞物理实体的特写（[放大版本](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png)）

Now make your way over to `GameScene.swift` to initialize the umbrella object and add it to the scene. At the top of the file and below our other class variables, add in this line:

现在，到 `GameScene.swift` 中来初始化雨伞对象并将其加入场景中。在文件顶部，类变量的下方，加入下面的代码：

```
private let umbrellaNode = UmbrellaSprite.newInstance()

```

Then, in `sceneDidLoad()`, beneath where we added `backgroundNode` to the scene, insert the following lines to add the umbrella to the center of the screen:

接着，在 `sceneDidLoad()` 中，将 `backgroundNode` 加入场景的下面，加入如下代码来将雨伞放置在屏幕中央：

```
umbrellaNode.position = CGPoint(x: frame.midX, y: frame.midY)
umbrellaNode.zPosition = 4
addChild(umbrellaNode)

```

Once this is added, run the app to see the umbrella. You will see the raindrops bouncing off it!

完成上述操作后，再运行程序，你就能看见雨伞了，同时你还会发现雨滴将会被雨伞弹开！

### Creating Movement

We will update the umbrella to respond to touch. In `GameScene.swift`, look at the empty functions `touchesBegan(_ touches:, with event:)` and `touchesMoved(_ touches:, with event:)`. This is where we will tell the umbrella where we’ve interacted with the game. If we set the position of the umbrella node in both of these functions based on one of the current touches, it will snap into place and teleport from one side of the screen to the other.

Another approach would be to set a destination in the `UmbrellaSprite` object, and when `update(dt:)` is called, we can move toward that location.

Yet a third approach would be to set `SKActions` to move the `UmbrellaSprite` on `touchesBegan(_ touches:, with event:)` or `touchesMoved(_ touches:, with event:)`, but I would not recommend this. This would cause us to create and destroy these `SKActions` frequently and likely would not be performant.

We will choose the second option. Update the code in `UmbrellaSprite` to look like this:

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

A few things are happening here. The `newInstance()` function has been left untouched, but we’ve added two variables above it. We’ve added a destination variable (the point that we want to be moving towards); we’ve added a `setDestination(destination:)` function, to where we will ease the umbrella sprite; and we’ve added an `updatePosition(point:)` function.

The `updatePosition(point:)` will act exactly as though the `position` property was being updated directly before we made this update. Now we can update the position and the destination at the same time. This way, the `umbrellaSprite` will be positioned at this point and will stay where it is, because it will already be at its destination, instead of moving towards it immediately after setup.

这里主要干了这么几件事。`newInstance()` 方法保持不变，但我们在它的上方加入了两个变量。我们加入了 destination 变量（保存对象移动的终点位置）；我们加入了 `setDestination(destination:)` 方法来缓冲雨伞精灵的移动；我们还加入了一个 `updatePosition(point:)` 方法。

`updatePosition(point:)` 方法将会在我们进行刷新操作之前直接对 `position` 属性进行赋值（译者注：此处的意思是，雨伞的移动本应是设置终点后，在 `update(dt:)` 方法中逐步移动，但这个 `updatePosition(point:)` 方法将直接移动雨伞）。现在我们可以同时更新 position 和 destination 了。如此一来， `umbrellaSprite` 对象就会被移动到相应位置，并保持在原地，由于这个位置就是它的终点，它也不会在设置位置后立刻移动了。

The `setDestination(destination:)` function will only update the destination property; we will perform our calculations off of this property later. Finally, we added `update(dt:)` to compute how far we need to travel towards the destination point from our current position. We computed the distance between the two points, and if it is greater than one point, we compute how far we want to travel using the `easing` function. The `easing` function just finds the direction that the umbrella needs to travel in, and then moves the umbrella's position 10% of the distance to the destination for each axis. This way, we won't snap to the new location, but rather will move faster if we are further from the point, and slow down as the umbrella approaches its destination. If it is less than or equal to 1 pixel, then we will just jump to the final position. We do this because the easing function will approach the destination very slowly. Instead of constantly updating, computing and moving the umbrella an extremely short distance, we just set the position and forget about it.

Moving back to `GameScene.swift`, we should update our `touchesBegan(_ touches: with event:)` and `touchesMoved(_ touches: with event:)` functions to the following:

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

Now our umbrella will respond to touch. In each function, we check to see whether the touch is valid. If it is, then we tell the umbrella to update its destination to the touch’s location. Now we need to modify the line in `sceneDidLoad()`:

现在，我们的雨伞就能响应触摸事件了。在每个方法中，我们都检测触摸是否有效。有效的话，我们就将雨伞的终点更新为触摸的位置。接下来，把 `sceneDidLoad()` 中的这行代码：

```
umbrella.position = CGPoint(x: frame.midX, y: frame.midY)
```

Change it to this:

修改成：

```
umbrellaNode.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
```

Thus, our initial position and destination will be set correctly. When we start the scene, we won’t see the umbrella move without us interacting with the app. Lastly, we need to tell the umbrella to update in our own `update(currentTime:)` function.

Add the following code near the end of our `update(currentTime:)` function:

这样，雨伞的初始位置和终点就设置好了。当我们运行程序，场景中的雨伞仅会在我们进行手势交互时才会移动。最后，我们要在 `update(currentTime:)` 中通知雨伞进行更新。

在 `update(currentTime:)` 的底部加入如下代码：

```
umbrellaNode.update(deltaTime: dt)

```

When we run the code, we should be able to tap and drag around the screen, and the umbrella will follow our touching and dragging.

再次运行程序，雨伞应该能够正确地跟着点击和拖动手势进行移动了。

>

So, that’s lesson one! We’ve covered a ton of concepts today, jumping into the code base to get our feet wet, and then adding in a container node to hold our background and ground `SKPhysicsBody`. We also worked on spawning our raindrops at a constant interval, and had some interaction with the umbrella sprite. The source code for today is [available on GitHub](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one)[27](#27).

How did you do? Does your code look almost exactly like mine? What changed? Did you update the code for the better? Was I not clear in explaining what to do? Let me know in the comments below.

Thank you for making it this far. Stay tuned for lesson two of RainCat!

嘿，第一课到此结束啦！我们接触到了许多概念，并自己动手搭建了基础代码，接着又添加了一个容器结点来容纳背景和地面的 `SKPhysicsBody` 。我们还成功做到了定时出现新的雨滴，并让雨伞精灵响应我们的手势。你可以在 [GitHub上找到](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one) [27] 第一课内容所涉及的源代码。

你完成的怎么样？你的代码实现是否和我的示例几乎一样？哪里有不同呢？你是否优化了示例代码？教程中是否有阐述不清晰的地方？请在评论中写下你的想法。

感谢你坚持完成了第一课。让我们拭目以待 RainCat 第二课吧！

*(da, yk, al, il)*

#### Footnotes
#### 注释

1. [1 https://developer.apple.com/spritekit/](#note-1)
2. [2 https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header-preview-opt.png](#note-2)
3. [3 https://itunes.apple.com/us/app/raincat/id1152624676?ls=1&mt=8](#note-3)
4. [4 https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-initial-code](#note-4)
5. [5 https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson4.html](#note-5)
6. [6 https://developer.apple.com/reference/spritekit/skscene](#note-6)
7. [7 https://www.raywenderlich.com/118225/introduction-sprite-kit-scene-editor](#note-7)
8. [8 https://github.com/thirteen23/RainCat/tree/smashing-day-1/dayOneAssets.zip](#note-8)
9. [9 https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt.png](#note-9)
10. [10 https://developer.apple.com/reference/spritekit/sknode](#note-10)
11. [11 https://developer.apple.com/reference/spritekit/skphysicsbody](#note-11)
12. [12 https://developer.apple.com/reference/spritekit/skphysicsworld](#note-12)
13. [13 https://www.smashingmagazine.com/wp-content/uploads/2016/10/Empty-scene-preview-opt.png](#note-13)
14. [14 https://www.smashingmagazine.com/wp-content/uploads/2016/10/first-rain-fall.gif](#note-14)
15. [15 https://www.smashingmagazine.com/wp-content/uploads/2016/10/Raindrops-for-days-preview-opt.png](#note-15)
16. [16 http://www-numi.fnal.gov/offline_software/srt_public_context/WebDocs/Companion/cxx_crib/shift.html](#note-16)
17. [17 https://developer.apple.com/reference/spritekit/skphysicsbody/1519869-categorybitmask](#note-17)
18. [18 https://en.wikipedia.org/wiki/Mask_%28computing%29](#note-18)
19. [19 https://en.wikipedia.org/wiki/Bitwise_operation](#note-19)
20. [20 https://developer.apple.com/reference/spritekit/skphysicsworld](#note-20)
21. [21 https://www.smashingmagazine.com/wp-content/uploads/2016/10/happy-bouncing-raindrops.gif](#note-21)
22. [22 https://www.smashingmagazine.com/wp-content/uploads/2016/10/Background-preview-opt.png](#note-22)
23. [23 https://developer.apple.com/reference/spritekit/skspritenode#//apple_ref/occ/instp/SKSpriteNode/anchorPoint](#note-23)
24. [24 http://blog.fluidui.com/designing-for-mobile-101-pixels-points-and-resolutions/](#note-24)
25. [25 https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png](#note-25)
26. [26 https://www.smashingmagazine.com/wp-content/uploads/2016/10/Umbrella-Close-up-large-opt.png](#note-26)
27. [27 https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one](#note-27)
