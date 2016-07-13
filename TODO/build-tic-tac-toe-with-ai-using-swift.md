>* 原文链接 : [Build Tic Tac Toe with AI Using Swift](https://medium.com/swift-programming/build-tic-tac-toe-with-ai-using-swift-25c5cd3085c9)
* 原文作者 : [Keith Elliott](https://medium.com/@mrkeithelliott)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


### Build Tic Tac Toe with AI Using Swift

I have a fascination and deep passion for learning. Recently, I developed a hypothesis that I could apply the principles of game making to app development to improve experiences for my users. Lots of people throw around terms like “Gamification” as buzzwords that will cure the ails of your application by delighting your users into wanting to interact and engage more with whatever it is that your app offers. We won’t debate that today (I won’t even bring up the question of if the promoters of adding game-like behaviors to apps even play games). Instead, we’ll build a game using SpriteKit, GameplayKit, and Swift.

#### Throttling Expectations Now

Before you get carried away with ambitions of building a chart topping hit, I want to tell you that’s not our objective today. We are going to just skim the surface and build a simple game of Tic Tac Toe. After we get things working, we will add in AI to allow you to play against a computer controlled opponent.

### Part 1 — The Elements

Apple launched SpriteKit during WWDC 2013 to give developers an approachable way to build games quicker than the “roll-your-own” framework alternatives. Since games are the most downloaded type of app on the Apple ecosystem, it’s no surprise that Apple has a strong commitment to the gaming community and a huge vested interest in making it easy for developers to create new games for iOS, macOS, watchOS, and tvOS.

SpriteKit is a framework that handles rendering and animating graphics and images, which are also commonly referred to as sprites. As a developer, you determine which things change, and SpriteKit handles the work involved with displaying those changes. You can read more about SpriteKit [here](https://developer.apple.com/library/mac/documentation/SpriteKit/Reference/SpriteKitFramework_Ref/index.html). I also encourage you to read the [SpriteKit Programming Guide](https://developer.apple.com/library/mac/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40013043-CH1-SW1) to get more details on the many other features the framework offers such as handling audio playback and sprite physics.

SpriteKit handles the run loop for your game and provides several places for you as the developer to update your game on each frame. The following diagram shows what’s happening during each frame from the beginning update through the final render of the frame. Essentially, you have a lot of options to tweak your game during each frame.

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9ffdorqj20hn0bmt9o.jpg)

The other framework will work with is [GameplayKit](https://developer.apple.com/reference/gameplaykit). GameplayKit was introduced at last year’s WWDC and offers useful API for implementing some of the common elements you find in games like creating random numbers, artificial intelligence for your opponents, or pathfinding around obstacles. They are extremely useful tools that do some serious heavy lifting and allow game developers to focus on the aspects that make their games fun. I highly recommend that you read the [GameplayKit Programming Guide](https://developer.apple.com/library/prerelease/content/documentation/General/Conceptual/GameplayKit_Guide/index.html#//apple_ref/doc/uid/TP40015172) to learn more about how to build your game to take advantage of this framework. For our simple game, we will only incorporate a small part for the framework to give our computer opponent some “smarts”.

#### Launching Xcode

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9ge6xqvg20m80dwdxq.gif)

Launch Xcode and create a Game project from the template for iOS. Name your game TicTacToe and make sure the language is set to Swift. During the project creation, Xcode creates a SKScene file that represents your initial view for your game along with a view controller file that initializes your game scene and handles presenting on screen when you launch the app. If you run the app now, you will see a Hello World label that displays to let you know that everything works out of the box. In addition, if you click the view, a space ship gets added to the location of the click. We don’t need the label or the space ship behavior anymore, so let’s remove that code. Switch to the GameScene.swift file, remove the code in didMoveToView and touchesBegan functions.

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9hnffbmj20m80angoe.jpg)

Let’s spend a moment and highlight some of the features of the Scene Editor. The center of the view is the scene display, and the yellow outline around our tic tac toe board represents our view port that is visible for our game. We can can change the size of our view port or even add cameras that allow us to see more of the viewable parts of our game in realtime. In a “platformer”, we might create a large background image with enemy nodes scattered throughout the scene. We would use a camera node to advance across the scene to reveal new portions of the background over time. However, in this game, our view will be static around the board.

![](http://ww4.sinaimg.cn/large/a490147fjw1f5s9hyl7ocj20m80dvwgg.jpg)

At the bottom of the scene is our node editor. We can use this editor to add actions to the node or to select them more easily in our scene. For our purposes, we add a node to represent the board, labels, and placeholder nodes for each cell of the board. Last, notice that every node in our scene has a name, which we will use to reference in code.

I have provided the entire game on [Github](https://github.com/mrkeithelliott/tictactoe) so that you can follow along and investigate the areas that I am glossing over for the sake of time in this article.

#### Back to the Code

Let’s switch back to GameViewController.swift to see how we setup our scene and get our game going. In our viewDidLoad method we configure and load our scene. We also add debug statements so that we can track our node and frames per second counts. In an action game, we would be interested in monitoring how many nodes are on the screen at one time along with if we are maintaining an ideal 60fps frame rate.

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

Looking at the GameScene.swift file, we need to examine three methods for our game: didMoveToView, touchesBegan, and update. The didMoveToView method gets called when the scene is about to display in our view controller’s view. What’s cool about our GameScene view is that we have many options for accessing the nodes in our scene. In our method, we initialize our scene by removing the background color of the cells of our board. We also do a few other things, but we will hold off on discussing that until a little later in the article.

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

The next method we discuss is the touchesBegan method. This method handles our user touches for selecting our moves and reseting the game. For each touch on the scene, we determine the location on the screen and which node was selected. For our case we either place our player’s piece in a cell or we reset the game. We also update the internal state of our game board.

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

The last method we need to override is the update function. This method is called for every frame of our game and it is where we trigger our game logic. We are using GameplayKit’s StateMachine to handle our game logic.

    override func update(currentTime: CFTimeInterval) {
            /* Called before each frame is rendered */
            self.stateMachine.updateWithDeltaTime(currentTime)
    }

### Part 2 — GameLogic

Now that we have covered setting up our displays, we will cover enough of the game logic to get you started with a game of your own.

#### StateMachines

Most games have logic that only applies for the current state of the gameplay. As the state changes, so does the required logic. This boils down to dealing with state machines. GameplayKit offers a state machine implementation that we will use with our game. Let’s look at GameStateMachine.swift to see my implementation for controlling the state in our game. I’ve created three states for our game: StartGameState, ActiveGameState, and EndGameState which all inherit from GKState. For our state machine to work, we need to provide valid next states for each along with an update method that our state machine will call with each frame’s update. On each update, our state machine will call the updateWithDeltaTime method for the active state.

![](http://ww2.sinaimg.cn/large/a490147fjw1f5s9j8vludj20l803i0t2.jpg)

The StartGameState is how we begin our game. In this state we reset our game board and then transition to the ActiveGameState. We override the isValidNextState function to make the only valid next state the ActiveGameState. So, when we are in the StartGameState, we can only go here and are prevented from entering any other state. State machines also have a didEnterWithPreviousState function that gets called when the implementing state becomes active. It also provides you with the state you’re coming from. In our case, we call our resetGame function to set up our game.

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

The ActiveGameState is the state we use when we are actively playing our game. We again override the isValidNextState and this time we want to make the only state you can transition to the EndGameState. We also override the didEnterWithPreviousState function but this time we just update one of our instance properties to allow our game to proceed as expected when the our update method is called. Last, we override our updateWithDeltaTime function to determine if there is a winner, the game is a draw, or if the current player’s turn has changed. In addition when its player two’s turn we call our ai routines to determine the best move for the player and then execute that move.

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

Our last state is the EndGameState for our state machine. The isValidNextState function only allows this state to transition to the StartGameState. The didEnterWithPreviousState function just displays the reset button so that the player can click it and reset the game.

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

#### MinMax Strategist

In many board games, winning is based on strategy, and every move counts. In GameplayKit, a strategist is the artificial intelligence that can act as the opponent or determine one or more moves to provide a hint to a player. The [GKMinmaxStrategist](https://developer.apple.com/library/prerelease/content/documentation/General/Conceptual/GameplayKit_Guide/Minmax.html#//apple_ref/doc/uid/TP40015172-CH2-SW1) class provides an implementation to the minmax strategy. The minmax strategy works by building a decision tree of rated choices for all possible remaining moves in a game. We can make the AI stronger or weaker by configuring how many moves to look ahead.

Let’s look at our final file AIStrategy.swift to see how we can implement the required classes and protocols to make AI work for our game. Ultimately we need to create an instance of the GKMinmaxStrategist class and implement the following protocols: GKGameModel, GKGameModelUpdate, and GKGameModelPlayer.

We need models to represent players, their moves, and to represent the board. We implement the GKGameModelPlayer protocol so that our AI can tell our players apart. There is only one required property that we have to implement, which is playerId. The next thing we need to tackle is to create a move object that implements the GKGameModelUpdate protocol. The protocol requires that we provide a value property that our decision tree logic will use to rate each move. All we have to do is add the value property to our class and let the minmax strategist take care of the rest.

Last, we create our board class and implement the GKGameModel protocol. A big part of this protocol is simulating the possible moves that a player can make. By implementing the gameModelUpdatesForPlayer function, we compile all of the possible moves for a specified player. Each move we store is an instance of our Move class, which implements the GKGameModelUpdate protocol. At some point during the process, the minmax strategist will call our delegate function applyGameModelUpdate to update the internal state of our game. I also implemented a few other protocol methods that I will leave to the reader to investigate: unapplyGameModelUpdate, isWinForPlayer, isLossForPlayer, setGameModel, activePlayer, scoreForPlayer.

#### Wiring things up

Switch back to the GameScene.swift file and examine the the didMoveToView function. We need to connect our AI and setup our state machine. To connect our AI, we initialize an instance of the GKMinmaxStrategist and then set the maxLookAheadDepth to control how strong our AI component will be during gameplay. We also set the randomSource property to GKARC4RandomSource so that our AI will have a way to randomly choose a move when there are multiple “best” moves to choose from. As for our state machine, we create instances of the Start, Active and End states and pass them to our state machine to get it started. Last, we enter tell our state machine to enter the StartGameState.

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

If you start the iOS Simulator, we can play our game and test out our AI!

![](http://ww3.sinaimg.cn/large/a490147fjw1f5s9ktn73pg20ae0j8aas.gif)

#### Wrapping Up

So, we’ve created a quick game and learned a few things about SpriteKit and GameplayKit along the way. I encourage you to make changes to the game and experiment with things to get more comfortable. If you need some suggestions, you might start with implementing a way to alternate which player goes first. Another idea is to give the player a way to tweak the AI level on the game screen or to turn it off completely.

On a lighter note, I also wrote an article on why creating native apps is probably the best way to go in most of your mobile development endeavors. Read it and weigh in the discussion!

