> * 原文链接 : [Build Tic Tac Toe with AI Using Swift](https://medium.com/swift-programming/build-tic-tac-toe-with-ai-using-swift-25c5cd3085c9)
> * 原文作者 : [Keith Elliott](https://medium.com/@mrkeithelliott)
> * 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者 : [Nicolas(Yifei) Li](https://github.com/yifili09) 
> * 校对者: [cyseria](https://github.com/cyseria), [jamweak](https://github.com/jamweak)


### 用 Swift 语言和 SpriteKit 创建有人工智能的井字游戏

我对（自我）学习有着很强的热情并且非常着迷。最近，我提出了一个利用制作游戏的理论应用到应用程序开发中来提高用户体验的假说。很多人提出“游戏化”这类的流行词，通过应用程序与用户之间的交互，以及让用户主动参与的方式去取悦用户，达到解决应用程序的痛点的难题。无论你的应用程序到底提供了什么内容。我们今天不会讨论这个（我甚至都不会提起增加游戏感行为的倡导者们是否玩游戏这样的问题。） 取而代之，我们会使用 `SpriteKit`，`GameplayKit` 和 `Swift` 来建立一个游戏。

#### 抑制下你的期望

在你野心勃勃（准备）创建一个高居榜单的应用程序之前，我要告诉你这不是我们今天的目标。我们准备只看冰山一角，创建一个简单的井字游戏 [Tic Tac Toe](http://playtictactoe.org)。在我们着手工作后，我会增加一个由计算机控制的AI（人工智能）　对手（供）允许你对战。

### 第一部分 - 原理

Apple 公司在召开 WWDC2013 期间发布了 `SpriteKit`，这给开发者一个比玩转自己（创建的）框架更快建立游戏应用程序的可选方案。由于游戏应用程序这个类别在 Apple 的生态系统中占据了大部分的下载量，这就一点儿都不奇怪 Apple 公司致力于游戏社区的发展并且从让程序开发者们更加简单的创建新的 iOS，macOS，watchOS 和 tvOS 游戏获得巨大的利益。

`SpriteKit` 也通常被引用为 `sprites`，是一个处理渲染，图形动画和图片的框架。作为一个程序开发者，你决定了改变什么，`SpriteKit` 就去处理显示这些变化的工作。你能在[这里](https://developer.apple.com/library/mac/documentation/SpriteKit/Reference/SpriteKitFramework_Ref/index.html)读到更多有关SpriteKit的内容。我也强烈推荐你去阅读 [SpriteKit编程指导](https://developer.apple.com/library/mac/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40013043-CH1-SW1) 获取更多框架提供的其他特性，例如处理声音的播放和 `Sprite` 物理模型。

`SpriteKit` 处理你游戏的运行循环并提供多个地方让开发者在每一帧更新游戏内容。下图展示了每一帧从开始更新到最终渲染发生了什么。本质上来说，在每一帧你有很多机会来调整你的游戏。

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9ffdorqj20hn0bmt9o.jpg)

[GameplayKit](https://developer.apple.com/reference/gameplaykit) 是另外一个能使用的框架。 `GameplayKit` 是在去年的 WWDC 被引进的，它提供了很多制作游戏使用的通用方法的实现，例如创建随机数，创建人工智能对手，或者障碍物的寻路系统。他们是非常有用的工具，能做很多繁重的工作并且让游戏应用程序的开发者把精力放在怎么制作更有趣的游戏。我强烈推荐你阅读[GameplayKit编程指导](https://developer.apple.com/library/prerelease/content/documentation/General/Conceptual/GameplayKit_Guide/index.html#//apple_ref/doc/uid/TP40015172)　去学习怎样利用这些框架中的技巧。回到我们这个简单的游戏，我们将只包含框架中的一小部分内容让我们的计算机对手更加“聪明”。

#### 启动 Xcode

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9ge6xqvg20m80dwdxq.gif)

启动 XCode 并且通过为 iOS 设计的模板创建一个游戏项目。 命名游戏为 `TicTacToe` 并且确认编程语言设定为 `Swift`。在项目的创建过程中，　XCode 创建了 `SKScene` 文件，它展示了游戏的初始视图，连同一个视图控制器文件用于初始化你的游戏场景并且处理在应用程序启动的时候展现在屏幕上。如果你现在启动应用程序，你会看到Hello World标签，它让你所有的东西都立即可以使用了。另外，如果你点击了视图，一个宇宙飞船会增加在你点击的位置。我们已经不再需要那个标签和宇宙飞船了，让我们移除那部分代码。切换到 `GameScene.swift` 文件，移除 `didMoveToView` 和 `touchesBegan` 方法中的代码。

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9hnffbmj20m80angoe.jpg)

让我们来花点时间并强调一些场景编辑器的特性。视图的中心是显示了场景，黄色的轮廓围绕着我们的　tic tac toe　游戏棋盘展现了我们的视口，它让我们的游戏可见。我们能改变游戏的视口或者增加摄像机，让我们实时得看见更多游戏的内容。在 `platformer` 中，我们也可以创建一个很大的很多敌人点散列在场景终的背景图片。我们也可以使用一个摄像机节点横跨整个场景随着时间去显示更多新的背景部分。然而，对于这个游戏，我们的视图将会时静止在棋盘附近。

![](http://ww4.sinaimg.cn/large/a490147fjw1f5s9hyl7ocj20m80dvwgg.jpg)

场景的底部是节点编辑器。我们可以使用这个编辑器为节点增加功能或者在场景中更容易的选择他们。我们用增加一个节点来表示游戏棋盘，标签和每一格游戏棋盘的占位节点。最后，每一个在场景中的节点都有一个名字，它用于在代码中引用回去。

为了考虑写这篇文章的时间我已经将整个游戏项目提交到了 [Github](https://github.com/mrkeithelliott/tictactoe)，所以你可以追随并且研究我略过的这个区域。

#### 回到代码

让我们切换回到 `GameViewController.swift` 去看看怎样建立我们的场景和让我们的游戏干点事情。在 `viewDidLoad` 方法中我们配置并且装载我们的场景。我们也增加了调试语句所以我们能追踪代码和每秒多少帧。在一个动作游戏中，我们对监控每秒钟多少个节点同时出现在屏幕上连同我们是否可以保持理想上的60fps的帧率感兴趣。

```
    override func viewDidLoad() {
      super.viewDidLoad()

      if let scene = GameScene(fileNamed:"GameScene") {
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true

        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true

        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill

        skView.presentScene(scene)
      }
    }
```

再看 `GameScene.swift` 文件，我们需要检查以下三个方法: `didMoveToView`, `tochesBegan` 和 `update`。当场景既要显示在我们的视图控制器的视图内时，`didMoveToView` 方法被调用。我们的 `GameScene` 视图最炫的是我们有好几种选择访问视图里的节点。在我们的方法里，我们通过移除游戏棋盘单元格背景的颜色初始化场景。我们也干了点其他事情，但是我们将在之后的文章里面讨论这些。

```
    override func didMoveToView(view: SKView) {
      /* Setup your scene here */
      self.enumerateChildNodesWithName("//grid*") { (node, stop) in
        if let node = node as? SKSpriteNode{
          node.color = UIColor.clearColor()
        }
      }

      let top_left: BoardCell  = BoardCell(value: .None, node: "//*top_left")
      let top_middle: BoardCell = BoardCell(value: .None, node: "//*top_middle")
      let top_right: BoardCell = BoardCell(value: .None, node: "//*top_right")
      let middle_left: BoardCell = BoardCell(value: .None, node: "//*middle_left")
      let center: BoardCell = BoardCell(value: .None, node: "//*center")
      let middle_right: BoardCell = BoardCell(value: .None, node: "//*middle_right")
      let bottom_left: BoardCell = BoardCell(value: .None, node: "//*bottom_left")
      let bottom_middle: BoardCell = BoardCell(value: .None, node: "//*bottom_middle")
      let bottom_right: BoardCell = BoardCell(value: .None, node: "//*bottom_right")

      let board = [top_left, top_middle, top_right, middle_left, center, middle_right, bottom_left, bottom_middle, bottom_right]

      gameBoard = Board(gameboard: board)
  }
```

下一个我们讨论的方法是 `touchesBegan`。这个方法处理用户选择移动和重置游戏的触摸事件。对场景上的每一个触摸事件，我们决定他们在场景上的位置和哪一个节点被选中。就我们的情况来说，我们要么放置玩家的棋子在一个单元格里，要么重置游戏。我们也更新内部的游戏棋盘状态。

```
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {        
    for touch in touches {
      let location = touch.locationInNode(self)
      let selectedNode = self.nodeAtPoint(location)
      var node: SKSpriteNode

      if let name = selectedNode.name {
        if name == "Reset" || name == "reset_label"{
          self.stateMachine.enterState(StartGameState.self)
          return
        }
      }

      if gameBoard.isPlayerOne(){
        let cross = SKSpriteNode(imageNamed: "X_symbol")
        cross.size = CGSize(width: 75, height: 75)
        cross.zRotation = CGFloat(M_PI / 4.0)
        node = cross
      }
      else{
        let circle = SKSpriteNode(imageNamed: "O_symbol")
        circle.size = CGSize(width: 75, height: 75)
        node = circle
      }

      for i in 0...8{
        guard let cellNode: SKSpriteNode = self.childNodeWithName(gameBoard.getElementAtBoardLocation(i).node) as? SKSpriteNode else{
            return
        }
        if selectedNode.name == cellNode.name{
          cellNode.addChild(node)
          gameBoard.addPlayerValueAtBoardLocation(i, value: gameBoard.isPlayerOne() ? .X : .O)
          gameBoard.togglePlayer()
        }
      }
    }
  }
```

最后需要被重写的方法是 `update`。这个方法在游戏中的每一帧都被调用并且是触发我们游戏逻辑处理的地方。我们使用 `GameplayKit` 的状态机(`StateMachine`)处理我们的游戏逻辑。

```
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    self.stateMachine.updateWithDeltaTime(currentTime)
  }
```

### 第二部分 - 游戏逻辑

到目前为止，我们已经涉及掌握了建立（游戏如何）显示的内容，我们将开始涉及足够你能自己开发一个游戏的游戏逻辑。

#### 状态机(StateMachines)

大部分游戏的逻辑仅仅是请求当前游戏设置的状态。随着状态的改变，所以逻辑也需要改变。这也就归结为（怎么）对待状态机。我们将使用 `GameplyKit` 提供的一种状态机的实现在我们的游戏里。让我们看看我实现的 `GameStateMachine.swift` 去控制游戏中的状态。我为我们的游戏创建了三个状态: `StartGameState`，　`ActiveGameState` 和 `EndGameState`，他们都从自 `GKState` 继承来。为了让我们的状态机工作，我们必须为每一个（状态）提供有效的下一个状态连同一个更新（状态）的方法，我们的状态机将同每一个帧更新的同时调用这个方法。在每一个更新时，我们的状态机会为活动的状态调用 `updateWithDeltaTime` 方法。

![](http://ww2.sinaimg.cn/large/a490147fjw1f5s9j8vludj20l803i0t2.jpg)

 `StartGameState`是我们如何开始游戏（的状态）。在这个状态行下我们重置游戏棋盘并且在之后转换到 `ActiveGameState`。我们重写 `isValidNextState` 函数确保只有 `ActiveGameState` 是下一个有效的状态。所以，当我们在 `StartGameState`（状态下）， 我们只能去那里并且避免进入到其他状态。状态机也有一个 `didEnterWithPreviousState` 的函数被调用当正在执行的状态被激活。它也提供给你这个状态来自哪里。就我们的情况来说，我们调用 `resetGame` 函数去建立我们的游戏。

```
    class StartGameState: GKState{
      var scene: GameScene?
      var winningLabel: SKNode!
      var resetNode: SKNode!
      var boardNode: SKNode!

      init(scene: GameScene){
        self.scene = scene
        super.init()
      }

      override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == ActiveGameState.self
      }

      override func updateWithDeltaTime(seconds: NSTimeInterval) {
        resetGame()
        self.stateMachine?.enterState(ActiveGameState.self)
      }

      func resetGame(){
        let top_left: BoardCell  = BoardCell(value: .None, node: "//*top_left")
        let top_middle: BoardCell = BoardCell(value: .None, node: "//*top_middle")
        let top_right: BoardCell = BoardCell(value: .None, node: "//*top_right")
        let middle_left: BoardCell = BoardCell(value: .None, node: "//*middle_left")
        let center: BoardCell = BoardCell(value: .None, node: "//*center")
        let middle_right: BoardCell = BoardCell(value: .None, node: "//*middle_right")
        let bottom_left: BoardCell = BoardCell(value: .None, node: "//*bottom_left")
        let bottom_middle: BoardCell = BoardCell(value: .None, node: "//*bottom_middle")
        let bottom_right: BoardCell = BoardCell(value: .None, node: "//*bottom_right")

        boardNode = self.scene?.childNodeWithName("//Grid") as? SKSpriteNode

        winningLabel = self.scene?.childNodeWithName("winningLabel")
        winningLabel.hidden = true

        resetNode = self.scene?.childNodeWithName("Reset")
        resetNode.hidden = true

        let board = [top_left, top_middle, top_right, middle_left, center, middle_right, bottom_left, bottom_middle, bottom_right]

        self.scene?.gameBoard = Board(gameboard: board)

        self.scene?.enumerateChildNodesWithName("//grid*") { (node, stop) in
          if let node = node as? SKSpriteNode{
            node.removeAllChildren()
          }
        }
      }
    }
```

`ActiveGameState` 是当我们正在玩我们的游戏时候的状态。我们再次重写 `isValidNextState` 这个函数并且这次我们想你只能转换到 `EndGameState` 状态。我们也重写了 `didEnterWithPreviousState` 函数，但是这次我们只是在 `update` 方法被调用的时候更新一个我们的实例属性让我们的游戏如期望的执行。最后，我们重写 `updateWithDeltaTime` 函数去决定是否有一个胜利者，游戏是否被绘制，或者当前玩家游戏回合被改变。此外当玩家二的回合时，我们调用 `AI` 的程序去决定对玩家最好的策略并执行这个策略。

```
    class ActiveGameState: GKState{
      var scene: GameScene?
      var waitingOnPlayer: Bool

      init(scene: GameScene){
        self.scene = scene
        waitingOnPlayer = false
        super.init()
      }

      override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == EndGameState.self
      }

      override func didEnterWithPreviousState(previousState: GKState?) {
        waitingOnPlayer = false
      }

      override func updateWithDeltaTime(seconds: NSTimeInterval) {
        assert(scene != nil, "Scene must not be nil")
        assert(scene?.gameBoard != nil, "Gameboard must not be nil")

        if !waitingOnPlayer{
          waitingOnPlayer = true
          updateGameState()
        }
      }

      func updateGameState(){
        assert(scene != nil, "Scene must not be nil")
        assert(scene?.gameBoard != nil, "Gameboard must not be nil")

        let (state, winner) = self.scene!.gameBoard!.determineIfWinner()
        if state == .Winner{
          let winningLabel = self.scene?.childNodeWithName("winningLabel")
          winningLabel?.hidden = true
          let winningPlayer = self.scene!.gameBoard!.isPlayerOne(winner!) ? "1" : "2"
          if let winningLabel = winningLabel as? SKLabelNode,
            let player1_score = self.scene?.childNodeWithName("//player1_score") as? SKLabelNode,
            let player2_score = self.scene?.childNodeWithName("//player2_score") as? SKLabelNode{
            winningLabel.text = "Player \(winningPlayer) wins!"
            winningLabel.hidden = false

            if winningPlayer == "1"{
              player1_score.text = "\(Int(player1_score.text!)! + 1)"
            }
            else{
              player2_score.text = "\(Int(player2_score.text!)! + 1)"
            }

            self.stateMachine?.enterState(EndGameState.self)
            waitingOnPlayer = false
          }
        }
        else if state == .Draw{
          let winningLabel = self.scene?.childNodeWithName("winningLabel")
          winningLabel?.hidden = true

          if let winningLabel = winningLabel as? SKLabelNode{
            winningLabel.text = "It's a draw"
            winningLabel.hidden = false
          }
          self.stateMachine?.enterState(EndGameState.self)
          waitingOnPlayer = false
        }

        else if self.scene!.gameBoard!.isPlayerTwoTurn(){
          //AI moves
          self.scene?.userInteractionEnabled = false

          assert(scene != nil, "Scene must not be nil")
          assert(scene?.gameBoard != nil, "Gameboard must not be nil")

          dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.scene!.ai.gameModel = self.scene!.gameBoard!
            let move = self.scene!.ai.bestMoveForActivePlayer() as? Move

            assert(move != nil, "AI should be able to find a move")

            let strategistTime = CFAbsoluteTimeGetCurrent()
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            let  aiTimeCeiling: NSTimeInterval = 1.0

            let delay = min(aiTimeCeiling - delta, aiTimeCeiling)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue()) {

              guard let cellNode: SKSpriteNode = self.scene?.childNodeWithName(self.scene!.gameBoard!.getElementAtBoardLocation(move!.cell).node) as? SKSpriteNode else{
                return
              }
              let circle = SKSpriteNode(imageNamed: "O_symbol")
              circle.size = CGSize(width: 75, height: 75)
              cellNode.addChild(circle)
              self.scene!.gameBoard!.addPlayerValueAtBoardLocation(move!.cell, value: .O)
              self.scene!.gameBoard!.togglePlayer()
              self.waitingOnPlayer = false
              self.scene?.userInteractionEnabled = true
            }
          }
        }
        else{
          self.waitingOnPlayer = false
          self.scene?.userInteractionEnabled = true
        }
      }
    }
```

`EndGameState` 是我们状态机的最后一个状态。`isValidNextState` 函数只允许这个状态被转换到 `StartGameState`。`didEnterWithPreviousState` 函数只显示重置按钮所以玩家可以点击并且重置游戏。

```
    class EndGameState: GKState{
      var scene: GameScene?

      init(scene: GameScene){
        self.scene = scene
        super.init()
      }

      override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == StartGameState.self
      }

      override func didEnterWithPreviousState(previousState: GKState?) {
        updateGameState()
      }

      func updateGameState(){
        let resetNode = self.scene?.childNodeWithName("Reset")
        resetNode?.hidden = false
      }
    }
```

#### 极大极小值策略(MinMax Strategist)

在很多棋盘类游戏中，胜利基于策略，并且每一步都需要计算。在 `GameplayKit` 中，一个（战略家） `Strategist` 是一个人工智能，可作为一个对手或者确定一步或者多步的策略为玩家给予提示。 [GKMinmaxStrategist](https://developer.apple.com/library/prerelease/content/documentation/General/Conceptual/GameplayKit_Guide/Minmax.html#//apple_ref/doc/uid/TP40015172-CH2-SW1) 类提供一个实现极大极小值策略的方式。极大极小值策略通过在游戏里建立一个对所有剩余可能性策略选择的决策树。我们可以通过配置预测多少步让 AI 变得更强或更弱。 

让我们关注下最后的文件 `AIStrategy.swift` 去瞧一瞧怎么实现必须的类和协议来完成我们游戏中AI的工作。最终我们需要创建一个 `GKMinmaxStrategist` 类的实例并且实现以下几个协议: `GKGameModel`, `GKGameModelUpdate` 和 `GKGameModelPlayer`。

我们需要模型去展示玩家，他们的步棋策略和展示棋盘。我们实现了 `GKGameModelPlayer` 协议，所以我们的AI（人工智能）可以辨别我们不同的玩家。还有一个必须要实现的属性是 `playerId`。下一个我们需要解决的是创建一个策略对象，该对象实现了 `GKGameModelUpdate` 协议。该协议需要我们提供一个数值属性（可被量化的属性），该属性能被决策树用于评估每一次的策略。我们所做的是把这个数值增加到我们的类中然后让极大极小值策略者来解决余下的问题。

最后，我们创建游戏棋盘的类并且实现 `GKGameModel` 协议。这个协议很大一部分的作用是模拟一个玩家可能使用的策略（步骤走法）。通过实现 `gameModleUpdatesForPlayer` 函数，我们汇总了某一个玩家所有可能使用的走法。每一个我们存储的走法都是 `Move` 类的实例，该函数实现了 `GKGameModelUpdate` 的协议。我也实现了一些其他的协议方法，我会把这些留给读者去研究: `unapplyGameModelUpdate`， `isWinForPlayer`， `isLossForPlayer`， `setGameModel`， `activePlayer`， `scoreForPlayer`。

#### 汇总

切换回 `GameScene.swift` 文件并且检查 `didMoveToView` 这个功能函数。我们需要连接AI（人工智能）和创建我们的状态机。关于连接AI（人工智能），我们初始化一个 `GKMinmaxStrategist` 的实例并且设置 `maxLookAheadDepth` 来控制AI　对手在游戏种到底有多厉害。我们也会设定 `GKARC4RandomSource` 的随机源属性，所以我们的 AI(人工智能)将会在出现很多个“最好”的走法的时候随机的选择一个。关于我们的状态机，我们创建 `Start` , `Active` 和 `End` 状态的实例并且将他们传给我们的状态机，让他开始运作。最后，我们告诉状态机进入 `StartGameState`。

```
     override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.enumerateChildNodesWithName("//grid*") { (node, stop) in
          if let node = node as? SKSpriteNode{
            node.color = UIColor.clearColor()
          }
        }

        let top_left: BoardCell  = BoardCell(value: .None, node: "//*top_left")
        let top_middle: BoardCell = BoardCell(value: .None, node: "//*top_middle")
        let top_right: BoardCell = BoardCell(value: .None, node: "//*top_right")
        let middle_left: BoardCell = BoardCell(value: .None, node: "//*middle_left")
        let center: BoardCell = BoardCell(value: .None, node: "//*center")
        let middle_right: BoardCell = BoardCell(value: .None, node: "//*middle_right")
        let bottom_left: BoardCell = BoardCell(value: .None, node: "//*bottom_left")
        let bottom_middle: BoardCell = BoardCell(value: .None, node: "//*bottom_middle")
        let bottom_right: BoardCell = BoardCell(value: .None, node: "//*bottom_right")

        let board = [top_left, top_middle, top_right, middle_left, center, middle_right, bottom_left, bottom_middle, bottom_right]

        gameBoard = Board(gameboard: board)

        ai = GKMinmaxStrategist()
        ai.maxLookAheadDepth = 9
        ai.randomSource = GKARC4RandomSource()

        let beginGameState = StartGameState(scene: self)
        let activeGameState = ActiveGameState(scene: self)
        let endGameState = EndGameState(scene: self)

        stateMachine = GKStateMachine(states: [beginGameState, activeGameState, endGameState])
        stateMachine.enterState(StartGameState.self)

    }
```

如果你运行了 `iOS` 模拟器，我们可以开始玩游戏并且测试我们的 AI（人工智能）！

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9ktn73pg20ae0j8aas.gif)

#### 总结

我们已经创建了一个快速的游戏并且学习了一些关于 `SpriteKit` 和 `GameplayKit` 的内容。我支持你们去改变这个游戏并且尝试些什么让自己更舒服。如果你需要什么建议，你也许可以开始先从实现玩家交替（游戏）开始。另一个想法是可实现提供玩家一个在屏幕上调整 AI（人工智能）的等级或者彻底关闭（的功能）。

还有一点要注意的是，我也写了一篇关于为什么创建原生应用程序可能是最好的努力学习移动手机应用程序开发的方式。你可以阅读它并且可以提出自己的观点。
