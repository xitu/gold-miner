> * 原文地址：[How To Build A SpriteKit Game In Swift 3 (Part 3)](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-3/)
* 原文作者：[Marc Vandehey](https://twitter.com/marcvandehey)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[DeepMissea](http://deepmissea.blue)
* 校对者：[Tina92](https://github.com/Tina92)，[Tuccuay](http://www.tuccuay.com)

# 如何在 Swift 3 中用 SpriteKit 框架编写游戏 (Part 3)

你有没有想过要如何开始创作一款基于 SpriteKit 的游戏？按钮的开发是一个很庞大的任务吗？想过如何制作游戏的设置部分吗？随着 [SpriteKit](https://developer.apple.com/spritekit/) 的出现，在 iOS 上开发游戏已经变得空前的简单了。在本系列的第三部分，我们将完成 RainCat 游戏的开发以及对 SpriteKit 框架的介绍。

如果你错过了[上一课](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-build-a-spritekit-game-in-swift-3-part-2.md)，你可以通过获取 [Github 上的代码](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-two)来赶上进度。请记住，本教程需要使用 Xcode 8 和 Swift 3。

[![Raincat, 第三课](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt-1.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt-1.png)

这是我们 RainCat 之旅的第三课。在[上节课](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-build-a-spritekit-game-in-swift-3-part-2.md)里，我们用了很长一段时间来搞定了一些简单动画，猫的行为、音效和背景音乐。


今天，我们将重点关注下面的内容：

- 用指示器（HUD）显示得分；
- 主菜单 — 带一些按钮；
- 静音选项；
- 退出游戏选项。

#### 更多的资源

最后一节课的资源都在 [GitHub](https://github.com/thirteen23/RainCat/blob/smashing-day-3/dayThreeAssets.zip) 上，再次把那些图片拖进 `Assets.xcassets` 里，就像我们上节课做的那样。

### 第一步！

我们需要一种方式来显示得分。要做这个，我们就得创建一个指示器（HUD）。这个很简单：指示器是一个 `SKNode` ，它包含了分数和一个退出游戏的按钮。现在，我们先来搞定分数。我们用 Pixel Digivolve 字体来显示分数，你可以在 [Dafont.com](http://www.dafont.com/pixel-digivolve.font) 找到它。就像之前我们使用不是我们原创的图片和音效一样，使用字体前，一定要浏览它的使用协议。这个字体声明，个人使用是免费的，但如果你真的很喜欢，你可以去作者的页面对他进行捐赠以表示支持。你不可能自己做所有的事，所以回馈那些一路帮助过你的人也是很愉快的。

接着，我们就需要把自定义的字体添加到项目里了。如果是第一次添加，这可能是个棘手的过程。

下载字体并把它移动到项目文件夹的 “Fonts” 文件夹里。这个过程我们上节课已经做过好几次了，所以我们加快点儿速度。在项目里创建 `Fonts` 组，然后把 `Pixel digivolve.otf` 文件加进去。

现在棘手的部分来了。如果错过了这部分，也许你就不能使用字体了。我们需要添加它到 `Info.plist` 文件。这个文件在 Xcode 的左边。打开它你会看到一堆属性列表（或者叫 `plist` 文件）。右键点击列表，然后点 “Add Row”。

[![添加一行](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_infoplist-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_infoplist-preview-opt.png)

在新添加的一行里，输入下面的内容：

```
Fonts provided by application
```

然后在 `Item 0` 下面，我们得添加字体的名字。`plist` 文件看起来应该像下面这样：

[![Pixel digivolve.otf](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_plistfont-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_plistfont-preview-opt.png)

字体已经准备完毕啦！我们应该做个快速的测试，看看它能不能像预期那样使用。打开 `GameScene.swift`，把下面的代码加在 `sceneDidLoad` 函数里的上方：

```
let label =SKLabelNode(fontNamed:"PixelDigivolve")
label.text ="Hello World!"
label.position =CGPoint(x: size.width /2, y: size.height /2)
label.zPosition =1000addChild(label)    
```

一切 OK 吗？

[![Hello world!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/screen_withtext-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/screen_withtext-preview-opt.png)

如果字体正常，那就说明你做的完全正确。如果不正常，那就是什么地方出了问题。Code With Chris 有一篇更加深入的[字体导入问题的文章](http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/)，但要注意的是，这是一篇老版本 Swift 的文章，你可能需要稍稍改动一些地方来过渡到 Swift 3 。

现在可以开始给我们的指示器加载自定义字体了。删掉 “Hello World” 标签，因为这个只是测试字体是否正常用的。指示器是一个 `SKNode` ，作为我们 HUD 控件的容器。这和我们在第一节课创建背景节点的过程一样。

老样子，创建 `HudNode.swift` 文件，输入下面的代码：

```
import SpriteKit

class HudNode : SKNode {
  private let scoreKey = "RAINCAT_HIGHSCORE"
  private let scoreNode = SKLabelNode(fontNamed: "PixelDigivolve")
  private(set) var score : Int = 0
  private var highScore : Int = 0
  private var showingHighScore = false

  /// Set up HUD here.
  public func setup(size: CGSize) {
    let defaults = UserDefaults.standard

    highScore = defaults.integer(forKey: scoreKey)

    scoreNode.text = "\(score)"
    scoreNode.fontSize = 70
    scoreNode.position = CGPoint(x: size.width / 2, y: size.height - 100)
    scoreNode.zPosition = 1

    addChild(scoreNode)
  }

  /// Add point.
  /// - Increments the score.
  /// - Saves to user defaults.
  /// - If a high score is achieved, then enlarge the scoreNode and update the color.
  public func addPoint() {
    score += 1

    updateScoreboard()

    if score > highScore {

      let defaults = UserDefaults.standard

      defaults.set(score, forKey: scoreKey)

      if !showingHighScore {
        showingHighScore = true

        scoreNode.run(SKAction.scale(to: 1.5, duration: 0.25))
        scoreNode.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
      }
    }
  }

  /// Reset points.
  /// - Sets score to zero.
  /// - Updates score label.
  /// - Resets color and size to default values.
  public func resetPoints() {
    score = 0

    updateScoreboard()

    if showingHighScore {
      showingHighScore = false

      scoreNode.run(SKAction.scale(to: 1.0, duration: 0.25))
      scoreNode.fontColor = SKColor.white
    }
  }

  /// Updates the score label to show the current score.
  private func updateScoreboard() {
    scoreNode.text = "\(score)"
  }
}
```

在我们做其他事之前，先在 `Constants.swift` 文件底部把下面的这行代码加上 —— 我们用这个键来读写最高得分记录：

```
let ScoreKey ="RAINCAT_HIGHSCORE"
```

代码里，有五个关于计分板的变量，第一个实际上是个 `SKLabelNode`，用来表示标签。接着是用来保存当前分数的变量；再接下来是记录最高分的变量，最后一个变量是布尔类型，用来判断是否显示我们当前获得的分数（我们用这个变量来判断是否需要运行一个 `SKAction` 来增加计分板的比例以及把地板弄成黄色）。

第一个函数 `setup(size:)` 的功能是把一切都设置好。我们就像之前那样来设置 `SKLabelNode`。`SKNode` 类没有任何默认尺寸，所以我们要创建一种方式来设置一个尺寸用于固定 `scoreNode` 的大小。我们还要从 [`UserDefaults`](https://developer.apple.com/reference/foundation/userdefaults) 里面得到当前最高分。这是一种简单方便的存储少量数据的方法，不过不太安全。不过我们并不用担心示例程序的安全性，所以使用  `UserDefaults` 也能让很好地完成这个任务

在 `addPoint()` 函数里面，我们增加了 `score` 变量的值，接着检查玩家是否得到一个更高的分数。如果是，那么我们就把分数存到 `UserDefaults` 里，然后检查当前是否显示最高分。如果玩家达到了一个很高的分数，我们就用动画渲染 `scoreNode` 的颜色和大小。

在 `resetPoints()` 函数中，我们把当前分数设为 `0`。然后，我们就检查是否需要显示高的得分，如果需要的话，重置默认值的颜色和大小。

最后还有一个小函数，叫 `updateScoreboard`。这个私有函数用来把分数设置到 `scoreNode` 的文本上。在 `addPoint()` 和 `resetPoints()` 里用到了这个函数。

### 挂上指示器

我们得检查一下指示器是不是正常工作。到 `GameScene.swift` 文件，在文件的上方，`foodNode` 变量下边添加一行代码：

```
private let hudNode =HudNode()
```

在 `sceneDidLoad()` 函数内部的上方，添加下面两行代码：

```
hudNode.setup(size: size)
addChild(hudNode)
```

接着，在 `spawnCat()` 函数，重置所有点防止猫从屏幕上掉下去。在把猫精灵加到场景的后面，加上这行代码：

```
hudNode.resetPoints()
```

接下来，在 `handleCatCollision(contact:)` 函数中，当猫被雨淋到时，我们也需要重置分数。在函数最后，`switch` 语句的 `RainDropCategory` 分支里，加上下面这行代码：

```
hudNode.resetPoints()
```

最后，我们得告诉计分板，什么时候用户得了分。在 `handleFoodHit(contact:)` 文件的最后，找到下面这几行代码：

```
//TODO increment points
print("fed cat")
```

换成这个：

```
hudNode.addPoint()
```

以上！

[![HUD unlocked!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoring-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoring-preview-opt.png)

当来回收集食物时，你就会看到指示器的效果了。第一次收集食物的时候，你应该会看到分数变黄然后比例变大，如果你看到当猫淋到雨滴时，分数重置，那么你就是正确的！

[![High Score!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoreincrease-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoreincrease-preview-opt.png)

### 下一个场景

没错，我们要开始下一个场景了！事实上，如果这个场景完成，它将会作为我们游戏的首屏展示。在做其他事情之前，打开 `Constants.swift` 然后添加下面这行代码到文件的底部 — 我们用它来检索以及保持高分：

```
let ScoreKey ="RAINCAT_HIGHSCORE"
```

创建一个新场景，把它放到 “Scenes” 文件夹里，然后命名为 `MenuScene.swift`。把下面的代码加进去：

```
import SpriteKit

class MenuScene : SKScene {
	let startButtonTexture =SKTexture(imageNamed:"button_start")
	let startButtonPressedTexture =SKTexture(imageNamed:"button_start_pressed")
	let soundButtonTexture =SKTexture(imageNamed:"speaker_on")
	let soundButtonTextureOff =SKTexture(imageNamed:"speaker_off")

	let logoSprite =SKSpriteNode(imageNamed:"logo")
	var startButton : SKSpriteNode!= nil
	var soundButton : SKSpriteNode!= nil

	let highScoreNode =SKLabelNode(fontNamed:"PixelDigivolve")

	var selectedButton : SKSpriteNode?

override func sceneDidLoad(){
	backgroundColor =SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)
	
	//Set up logo - sprite initialized earlier
	logoSprite.position =CGPoint(x: size.width /2, y: size.height /2+100)
	
	addChild(logoSprite)
	
	//Set up start button
	startButton =SKSpriteNode(texture: startButtonTexture)
	startButton.position =CGPoint(x: size.width /2, y: size.height /2- startButton.size.height /2)
	
	addChild(startButton)
	
	let edgeMargin : CGFloat =25
	
	//Set up sound button
	soundButton =SKSpriteNode(texture: soundButtonTexture)
	soundButton.position =CGPoint(x: size.width - soundButton.size.width /2- edgeMargin, y: soundButton.size.height /2+ edgeMargin)
	
	addChild(soundButton)
	
	//Set up high-score node
	let defaults = UserDefaults.standard
	
	let highScore = defaults.integer(forKey: ScoreKey)
	
	highScoreNode.text ="\(highScore)"
	highScoreNode.fontSize =90
	highScoreNode.verticalAlignmentMode =.top
	highScoreNode.position =CGPoint(x: size.width /2, y: startButton.position.y - startButton.size.height /2-50)
	highScoreNode.zPosition =1
	
	addChild(highScoreNode)
	}
}
  
```

因为这个场景真的很简单。所以我们不会创建任何特殊的类。我们的场景将只由两个按钮组成。这两个按钮可以（或者说应该）拥有自己的 `SKSpriteNodes` 类，但是因为他们都不一样，所以我不会为他们创建新的类。在构建属于你自己的游戏的时候，这是很重要的一点：在事情变得复杂时，你需要有能力来判断，在哪里停下来并重构代码。一旦你添加了三个或四个以上的按钮到游戏里，那可能就是时候停下来把菜单按钮放到他们自己的类里了。

上面的代码没做什么特别的事儿；只是设置了四个精灵的坐标。当然我们也设置了场景的背景颜色，所以整个背景的值也是正确的。[UI Color](http://uicolor.xyz/) 是一个从十六进制串（HEX strings）生成 Xcode 颜色代码的优秀工具。上面的代码还设置了按钮状态的纹理。开始按钮有一个正常状态和一个按下的状态，而声音按钮则是一个开关。为了让开关简单点，在玩家点击时，我们改变声音按钮上的透明度。当然我们也设置了获得高分的 `SKLabelNode`。

我们的 `MenuScene` 看起来不错。现在，在游戏加载时需要展示场景。到 `GameViewController.swift` 文件，找到下面这行代码：

```
let sceneNode =GameScene(size: view.frame.size)
```

把它换成这个：

```
let sceneNode =MenuScene(size: view.frame.size)
```

这个小改动会默认加载 `MenuScene` 场景，而不是 `GameScene`。

[![我们新的场景!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_newscene-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_newscene-preview-opt.png)

### 按钮的状态

按钮在 SpriteKit 中可能有些麻烦。有丰富的轮子可以用（我甚至还自己做了一个），但是理论上，你只需要理解这三个函数：

- `touchesBegan(_ touches: with event:)`
- `touchesMoved(_ touches: with event:)`
- `touchesEnded(_ touches: with event:)`

在更新伞的时候我们简单提了几句，但是现在我们需要知道接下来的几点：哪个按钮被触摸，玩家是松开按钮还是点击按钮，按钮是不是一直被按着。这个时候就需要 `selectedButton` 变量发挥它的作用了。在触摸开始时，我们就可以通过这个变量来捕获被按的按钮。如果他们拖拽按钮，我们就可以处理并适当的给它一些纹理。在松开按钮时，我们也可以知道他们是否还跟按钮有接触，如果有接触，那就可以提供一些相关联的动作。把下面这些代码添加到 `MenuScene.swift` 的底部：

```
  override func touchesBegan(_ touches: Set, with event: UIEvent?){
    if let touch = touches.first {
      if selectedButton != nil {
        handleStartButtonHover(isHovering: false)
        handleSoundButtonHover(isHovering: false)
    }

    // Check which button was clicked (if any)
    if startButton.contains(touch.location(in: self)){
      selectedButton = startButton
      handleStartButtonHover(isHovering: true)
    } else if soundButton.contains(touch.location(in: self)){
      selectedButton = soundButton
      handleSoundButtonHover(isHovering: true)
      }
    }
  }

  override func touchesMoved(_ touches: Set, with event: UIEvent?){
    if let touch = touches.first {
    
      // Check which button was clicked (if any)
      if selectedButton == startButton {
        handleStartButtonHover(isHovering:(startButton.contains(touch.location(in: self))))
      } else if selectedButton == soundButton {
        handleSoundButtonHover(isHovering:(soundButton.contains(touch.location(in: self))))
      }
    }
  }

override func touchesEnded(_ touches: Set, with event: UIEvent?){
   if let touch = touches.first {
    
     if selectedButton == startButton {  
       // Start button clicked
       handleStartButtonHover(isHovering: false)
        
       if(startButton.contains(touch.location(in: self))){
         handleStartButtonClick()
       }
        
     } else if selectedButton == soundButton {
       // Sound button clicked
         handleSoundButtonHover(isHovering: false)
          
         if(soundButton.contains(touch.location(in: self))){
           handleSoundButtonClick()
         }
       }
     }

   selectedButton = nil
}
  
  /// Handles start button hover behavior
  func handleStartButtonHover(isHovering : Bool){
    if isHovering {
      startButton.texture = startButtonPressedTexture
    } else {
      startButton.texture = startButtonTexture
    }
  }
  
  /// Handles sound button hover behavior
  func handleSoundButtonHover(isHovering : Bool){
    if isHovering {
      soundButton.alpha =0.5
    }else{
      soundButton.alpha =1.0
    }
  }
  
  /// Stubbed out start button on click method
  func handleStartButtonClick(){
    print("start clicked")
  }
  
  /// Stubbed out sound button on click method
  func handleSoundButtonClick(){
    print("sound clicked")
  }
```

这就是对我们两个按钮的简单处理。在 `touchesBegan(_ touches: with events:)` 里，我们首先检查当前是否有按钮被选中。如果我们要做这个检查，我们就要得先重置按钮到没有被按下的状态，然后，检查是否有哪个按钮被按下。如果有被按下的按钮，就显示它的高亮状态，接下来，我们就在其他两个方法里设置按钮的 `selectedButton` 属性以供使用。

在 `touchesMoved(_ touches: with events:)` 方法中，我们检查最初触摸的是哪个按钮。接着，检查当前触摸是否还在 `selectedButton` 的边界内，如果还在，就更新按钮的状态为高亮。`startButton` 的高亮状态是改变按下的纹理，而 `soundButton` 的高亮状态是把精灵的透明度设置为 50%。

最后，在 `touchesEnded(_ touches: with event:)` 方法里，我们再次检查哪个按钮被选中，如果有，接着检查这个触摸时候还在按钮的边界内，如果前面的条件都满足，那么我们根据不同的按钮调用 `handleStartButtonClick()` 或者 `handleSoundButtonClick()`。

### 按钮的动作

现在，我们已经搞定了按钮的基础行为，在按钮被点击的时候，我们还需要一个触发事件。对于 `startButton` 来说，这个实现很容易。我们只需要在点击时展示 `GameScene`。在 `MenuScene.swift` 文件里，更新 `handleStartButtonClick()` 方法里面的代码：
```
func handleStartButtonClick(){
	let transition = SKTransition.reveal(with:.down, duration:0.75)
	let gameScene =GameScene(size: size)
	gameScene.scaleMode = scaleMode
	view?.presentScene(gameScene, transition: transition)
}
```

如果你现在运行程序，然后点击按钮，游戏就开始了！

接着，我们需要一个静音的切换。我们已经有一个音乐管理器了，但是我们需要告诉它静音是否开启。我们需要在 `Constants.swift` 里添加一个 key 来持久化存储静音状态。添加下面这行代码：

```
let MuteKey ="RAINCAT_MUTED"
```

用它把一个布尔类型的值保存到 `UserDefaults` 里。现在这里已经设置完了，我们到 `SoundManager.swift` 文件中。我们在这里通过检查和设置 `UserDefaults` 来确定静音的开关。在文件的顶部，`trackPosition` 变量的下面，加上这行代码：

```
private(set) var isMuted = false
```   

这个变量用于主菜单（或者其他要播放声音的地方）检查是否允许播放声音。我们给他设置一个 `false` 的初始值，但首先我们需要检查 `UserDefaults` 里，来看看玩家是怎样设置的。把 `init()` 方法换成下面的代码：

```
private override init(){
	//This is private, so you can only have one Sound Manager ever.
	trackPosition =Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
	
	let defaults = UserDefaults.standard
	
	isMuted = defaults.bool(forKey: MuteKey)
}
```

做完这些，我们的 `isMuted` 就有默认值了，我们还需要它能够切换。在 `SoundManager.swift` 文件里的底部，加入这些代码：

```
func toggleMute()-> Bool {
	isMuted =!isMuted
	
	let defaults = UserDefaults.standard
	defaults.set(isMuted, forKey: MuteKey)
	defaults.synchronize()
	    
	if isMuted {
	  audioPlayer?.stop()
	   } else {
	  startPlaying()
	  }
	  
	return isMuted
}
```

在 `UserDefaults` 更新时，这个方法会切换我们的静音变量，如果新的值不是静音，那音乐就会开始播放；如果新的值是静音，那音乐就不会开始。此外，我们还会停止播放当前的音乐。做完这些，我们还需要修改一下 `startPlaying()` 里的 `if` 语句。

找到下面的代码：

```
if audioPlayer == nil || audioPlayer?.isPlaying == false {
```

换成这行：

```
if!isMuted &&(audioPlayer == nil || audioPlayer?.isPlaying == false){
```

现在，在静音被关闭时，无论是播放器没有设置，还是当前播放停止了，我们都会继续播放音乐。

从这开始，我们就该完成 `MenuScene.swift` 的静音按钮了。把 `handleSoundbuttonClick()` 方法换成下面的代码：

```
func handleSoundButtonClick(){
	if SoundManager.sharedInstance.toggleMute(){
  		//Is muted
  		soundButton.texture = soundButtonTextureOff
   } else {
	  	//Is not muted
  		soundButton.texture = soundButtonTexture
	}
}
```

这里切换了在 `SoundManager` 的声音，检查结果，接着稍微改变了一下纹理，来告诉玩家音乐是否静音。我们马上就要完成了！只剩下在游戏启动时候，设置按钮的初始纹理。在 `sceneDidLoad()`，找到这行代码：

```
soundButton =SKSpriteNode(texture: soundButtonTexture)
```
  

替换成下面的：

```
soundButton =SKSpriteNode(texture: SoundManager.sharedInstance.isMuted ?
soundButtonTextureOff : soundButtonTexture)
```

上面的例子使用了 [ternary operator](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html#//apple_ref/doc/uid/TP40014097-CH6-ID60) 来设置正确的纹理。

音乐这部分处理已经完成了，我们到 `CatSprite.swift` 文件，让小猫在静音的时候不能喵喵叫。在 `hitByRain()` 方法，删除散步动作后，添加下面的这行 `if` 语句：

```
if SoundManager.sharedInstance.isMuted {return}
```

这条语句会判断游戏是否静音，如果是就返回。这样，我们就可以忽略 `currentRainHits`，`maxRainHits` 和喵喵声的效果了。

所有的这些都弄完之后，是时候来试试静音按钮的效果了。运行游戏，确定是否在播放音乐。关闭音乐，然后重启游戏。确定游戏还是静音的。需要注意的一点是，如果你只是开启静音并用 Xcode 重启游戏，那可能没有足够的时间来向 `UserDefaults` 存储静音变量。玩一下游戏，确认在静音的时候猫不会喵喵的叫。

[![](https://i.vimeocdn.com/video/600110219.webp?mw=700&mh=528)](https://player.vimeo.com/video/189700402)

### 退出游戏

现在为止，我们已经弄完了主菜单的第一种按钮，我们可以通过添加按钮，来为场景处理一些棘手的业务了。一些有趣的交互可以展示出我们游戏的风格；现在，雨伞会随着玩家的触摸而移动到相应的位置。显然，在玩家要退出游戏的时候，雨伞也会移动过去，这肯定是个糟糕的用户体验，所以我们要阻止它发生。

我们会模仿前面添加的开始按钮来实现退出按钮，其中大部分过程都不会变。改变的地方在处理触摸这部分。把你的 `quit_button` 和 `quit_button_pressed` 资源放进 `Assets.xcassets` 文件夹里，然后把下面的代码添加到 `HudNode.swift` 文件中：

```
private var quitButton : SKSpriteNode!
private let quitButtonTexture =SKTexture(imageNamed:"quit_button")
private let quitButtonPressedTexture =SKTexture(imageNamed:"quit_button_pressed")
```
    
这些变量会处理我们的 `quitButton` 引用，并且会根据退出按钮的不同状态来设置纹理。为了确保不在退出游戏的时候，不小心更新雨伞对象，我们还需要一个变量来告诉指示器（和游戏场景），我们只是和退出按钮交互，而不是雨伞。把下面的代码添加到 `showingHighScore` 变量后面：

```
private(set) var quitButtonPressed = false
```
  
同样的，这是一个只有在 `HudNode` 中才能修改，而其他类只能查看的变量。现在变量已经设置好了，我们可以添加按钮到指示器了。把下面的代码添加到 `setup(size:)` 方法中：

```
quitButton = SKSpriteNode(texture: quitButtonTexture)
let margin : CGFloat =15
quitButton.position =CGPoint(x: size.width - quitButton.size.width - margin, y: size.height - quitButton.size.height - margin)
quitButton.zPosition =1000
  
addChild(quitButton)
```

上面的代码会设置退出按钮没被按下状态的纹理。我们也把它的位置设到了右上角，并且把 `zPosition` 的值设置的很高，来让它一直显示在最前面。如果你现在运行游戏，他就会显示在 `GameScene` 里，不过还不能点。

[![Quit button](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_quit-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_quit-preview-opt.png)

现在按钮已经定位，我们还要能够和它交互。在 `GameScene` 中，唯一有交互的地方就是和 `umbrellaSprite` 的交互。在我们的例子里，指示器的优先级比伞高，所以玩家在退出时，不用特意把伞移走。我们可以在 `HudNode.swift` 里创建一些相同的方法来模仿 `GameScene.swift` 里的触摸功能。在 `HudNode.swift` 文件加入下面的代码：
```
func touchBeganAtPoint(point: CGPoint) {
  let containsPoint = quitButton.contains(point)

  if quitButtonPressed && !containsPoint {
    //Cancel the last click
    quitButtonPressed = false
    quitButton.texture = quitButtonTexture
  } else if containsPoint {
    quitButton.texture = quitButtonPressedTexture
    quitButtonPressed = true
  }
}

func touchMovedToPoint(point: CGPoint) {
  if quitButtonPressed {
    if quitButton.contains(point) {
      quitButton.texture = quitButtonPressedTexture
    } else {
      quitButton.texture = quitButtonTexture
    }
  }
}

func touchEndedAtPoint(point: CGPoint) {
  if quitButton.contains(point) {
    //TODO tell the gamescene to quit the game
  }

  quitButton.texture = quitButtonTexture
}
```

上面的代码大部分和 `MenuScene` 创建的差不多。不同的地方是，只需要跟踪一个按钮的状态，所以我们可以在这些方法里处理所有的事情。而且，我们还知道 `GameScene` 里的触摸点的位置，这样就可以检查我们的按钮是否包含触摸点。

移动到 `GameScene.swift`， 并用下面的代码替换 `touchesBegan(_ touches with event:)` 和 `touchesMoved(_ touches: with event:)`：

```
override func touchesBegan(_ touches: Set, with event: UIEvent?) {
  let touchPoint = touches.first?.location(in: self)

  if let point = touchPoint {
    hudNode.touchBeganAtPoint(point: point)

    if !hudNode.quitButtonPressed {
      umbrellaNode.setDestination(destination: point)
    }
  }
}

override func touchesMoved(_ touches: Set, with event: UIEvent?) {
  let touchPoint = touches.first?.location(in: self)

  if let point = touchPoint {
    hudNode.touchMovedToPoint(point: point)

    if !hudNode.quitButtonPressed {
      umbrellaNode.setDestination(destination: point)
    }
  }
}

override func touchesEnded(_ touches: Set, with event: UIEvent?) {
	let touchPoint = touches.first?.location(in: self)

	if let point = touchPoint {
	hudNode.touchEndedAtPoint(point: point)
	}
}
```

这里，每个方法以几乎相同的方式处理一切。我们告诉指示器玩家和场景交互。然后，检查退出按钮当前是否在捕捉触摸。如果它没有捕捉触摸，那我们就移动伞。我们还在 `touchesEnded(_ touches: with event:)` 方法里添加了点击退出按钮结束的处理，但我们还是没有使用到 `umbrellaSprite`。

[![](https://i.vimeocdn.com/video/600111380.webp?mw=700&mh=549)](https://player.vimeo.com/video/189701318)

我们有个按钮了，现在我们需要一种方式来作用于 `GameScene`。把下面这行代码添加到 `HudeNode.swift` 的顶部：

```
  var quitButtonAction : (()->())?
```

这是一个基本的[闭包](https://www.weheartswift.com/closures/)，没有参数也没返回值。我们会在 `GameScene.swift` 文件里设置它，在点击 `HudNode.swift` 里的按钮时候调用。接着，我们就可以用下面的代码，来替换以前在 `touchEndedAtPoint(point:)` 里面创建的 `TODO` 部分：
        
```
if quitButton.contains(point)&& quitButtonAction != nil {
	quitButtonAction!()
}
```
    
现在如果我们设置了 `quitButtonAction` 闭包，它就会在这被调用。

要设置 `quitButtonAction` 闭包，我们就要到 `GameScene.swift` 文件里。在 `sceneDidLoad()` 函数，把设置指示器的代码换成下面的：

```
hudNode.setup(size: size)
    
hudNode.quitButtonAction ={
  let transition = SKTransition.reveal(with:.up, duration:0.75)
    
  let gameScene =MenuScene(size: self.size)
  gameScene.scaleMode = self.scaleMode
    
  self.view?.presentScene(gameScene, transition: transition)
    
  self.hudNode.quitButtonAction = nil
}
    
addChild(hudNode)
```

运行程序，点击开始游戏，然后点退出按钮。如果你回到了主菜单，那说明退出按钮和预期的一样。在闭包里，我们创建并初始化了一个到 `MenuScene` 的过渡。我们还把这个闭包设置为 `HUD` 的节点，当点击退出按钮时运行闭包。这里，另一行重要的代码是我们把 `quitButtonAction` 设为 `nil`。这么做的原因是有一个循环引用产生了。场景持有一个指示器的引用，而指示器也持有一个场景的引用。因为他们两个互相引用，导致在垃圾回收的时候，他们都不会被处理。这种情形下，每次我们进入和离开 `GameScene` 的时候，都会有一个新的实例被创建，并且从来都不释放。这对性能有严重的影响，游戏最后一定会内存爆炸。有很多种方式来避免它，但在我们这里，只是从指示器中移除对 `GameScene` 的引用，这样在我们回到 `MenuScene` 的时候，场景和指示器都会被终止。对于引用类型和如何避免循环引用，[Krakendev 有一些更深的见解](http://krakendev.io/blog/weak-and-unowned-references-in-swift) 。

现在，到 `GameViewController.swift` 文件，把下面的这几行代码注掉或者删除：

```
view.showsPhysics = true
view.showsFPS = true
view.showsNodeCount = true
```
  
把调试信息去掉以后，游戏看起来真的很不错！恭喜你：我们已经现在进入 beta 版了！在 [GitHub](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-three) 上找到今天的最终代码。

### 最后的思考

这是三遍教程的最后一篇，如果你一直跟着到这，那你已经对你的游戏付出了很多工作。在本教程中，你把一个一无所有的场景，变成了一个完整的游戏。恭喜！在[第一课](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-build-a-spritekit-game-in-swift-3-part-1.md)里，我们添加了地面，雨滴，背景和雨伞精灵。我们还通过物理引擎来确保雨滴没有堆积在一起。我们用碰撞检测来移除节点，这样就解决了内存溢出的问题。我们也添加了一些交互来允许伞向玩家触摸屏幕的位置移动。

在[第二课](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-build-a-spritekit-game-in-swift-3-part-2.md)里，我们添加了猫和食物，为他们定制了一些不同的生成方法。我们还更新了碰撞检测，让猫精灵和食物精灵产生一些作用。我们也在猫的移动上做了一些处理。小猫有一个目的：吃掉每一个食物。我们为猫添加了简单的动画效果，还增加了猫和雨滴之间的交互。最后，我们添加了音效和背景音乐，让我们的程序看上去更像一个完整的游戏。

在这最后的一篇教程里，我们创建了一个指示器放我们的分数标签和退出按钮。我们处理节点上的操作，并使用户能够从指示器节点的回调里退出。我们还添加了一个玩家启动游戏的场景，并可以在点击退出按钮后返回。我们还处理了开始游戏和控制游戏中的声音的过程。

#### 接下来做什么

我们做到这一步用了很久，但这个游戏还有许多工作需要继续。RainCat 也会继续发展，而且它已经可以在 [App Store](https://itunes.apple.com/us/app/raincat/id1152624676?ls=1&amp;mt=8) 下载了。下面的列表是一些想要加的和需要加的功能。有一些已经加上了，还有一些待定中：

- 添加 icon 图标和启动画面。
- 完成主菜单（教程的是简化版）。
- 修复 bug，包括烦人的雨滴和多重食物的生成。
- 重构并优化代码。
- 根据得分更改游戏的调色板。
- 根据得分更新难度。
- 当食物在猫的正上方，让猫有一些动作。
- 集成 Game Center。
- 标明出处（包括一些适当的音乐曲目）。

请持续关注 [GitHub](https://github.com/thirteen23/RainCat)，因为在不久的将来这些都会被实现。如果你对代码有任何的问题，随时可以在 [hello@thirteen23.com](mailto:hello@thirteen23.com) 给我们留言，我们可以一起讨论它。如果问题有足够的关注，那也许我们会专门写一篇文章来探讨这些问题。

#### 感谢！

我真的很感谢所有那些，在制作游戏和写文章的过程中，与之相伴的人。

- [Cathryn Rowe](https://www.thirteen23.com/about/#cathryn-rowe)

提供了游戏最初的美术，设计和编辑，并且在 [Garage](https://www.thirteen23.com/garage/) 发布了文章。
- [Morgan Wheaton](https://www.thirteen23.com/about/#morgan-wheaton)

提供了游戏最终菜单的设计和调色板（如果我实现了这些，效果肯定酷炫 — 敬请期待）。
- [Nikki Clark](https://www.thirteen23.com/about/#nikki-clark)

提供了文章中漂亮的标题和分割符，并且帮助编写文章。
- [Laura Levisay](https://www.thirteen23.com/about/#laura-levisay)

提供了三篇文章里所有漂亮的 GIF 图片，还很友好的把小猫的 GIF 也发给了我。
- [Tom Hudson](https://www.thirteen23.com/about/#tom-hudson)

提供了编辑文章的帮助，如果没有他，这个系列可能都不会出现。
- [Lani DeGuire](https://www.thirteen23.com/about/#lani-deguire)

提供了编辑文章的帮助，这的确是一项大工程。
- [Jeff Moon](https://www.thirteen23.com/about/#jeffrey-moon)

提供了第三课的编辑工作和乒乓球，很多的乒乓球（译者注：这里原文就是ping-pong，译者的理解是，可能他们写代码有点累，所以打了会乒乓球。）
- [Tom Nelson](https://www.thirteen23.com/about/#tom-nelson)

正因为这些帮助，教程才会像预计的那样完成。

认真的说，真的用了一大堆人来准备这篇文章，并发布到商店。

也谢谢每一位读到这句话的读者，感谢。
