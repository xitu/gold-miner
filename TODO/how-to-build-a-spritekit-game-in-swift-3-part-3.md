> * 原文地址：[How To Build A SpriteKit Game In Swift 3 (Part 3)](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-3/)
* 原文作者：[Marc Vandehey](https://twitter.com/marcvandehey)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[]()
* 校对者：[]()

# [How To Build A SpriteKit Game In Swift 3 (Part 3)](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-3/)

Have you ever wondered what it takes to create a [SpriteKit](https://developer.apple.com/spritekit/) game? Do buttons seem like a bigger task than they should be? Ever wonder how to persist settings in a game? Game-making has never been easier on iOS since the introduction of SpriteKit. In part three of this three-part series, we will finish up our RainCat game and complete our introduction to SpriteKit.

If you missed out on the [previous lesson](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-2/), you can catch up by getting the code [on GitHub](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-two). Remember that this tutorial requires Xcode 8 and Swift 3.

[![Raincat, lesson 3](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt-1.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt-1.png)

This is lesson three in our RainCat journey. In the [previous lesson](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-2/), we had a long day going though some simple animations, cat behaviors, quick sound effects and background music.

Today we will focus on the following:

- heads-up display (HUD) for scoring;
- main menu — with buttons;
- options for muting sounds;
- game-quitting option.

#### Even More Assets

The assets for the final lesson are [available on GitHub](https://github.com/thirteen23/RainCat/blob/smashing-day-3/dayThreeAssets.zip). Drag the images into `Assets.xcassets` again, just as we did in the previous lessons.

### Heads Up!

We need a way to keep score. To do this, we can create a heads-up display (HUD). This will be pretty simple; it will be an `SKNode` that contains the score and a button to quit the game. For now, we will just focus on the score. The font we will be using is Pixel Digivolve, which you can [get at Dafont.com](http://www.dafont.com/pixel-digivolve.font). As with using images or sounds that are not yours, read the font’s license before using it. This one states that it is free for personal use, but if you really like the font, you can donate to the author from the page. You can’t always make everything yourself, so giving back to those who have helped you along the way is nice.

Next, we need to add the custom font to the project. This process can be tricky the first time.

Download and move the font into the project folder, under a “Fonts” folder. We’ve done this a few times in the previous lessons, so we’ll go through this process a little more quickly. Add a group named `Fonts` to the project, and add the `Pixel digivolve.otf` file.

Now comes the tricky part. If you miss this part, you probably won’t be able to use the font. We need to add it to our `Info.plist` file. This file is in the left pane of Xcode. Click it and you will see the property list (or `plist`). Right-click on the list, and click “Add Row.”

[![Add Row](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_infoplist-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_infoplist-preview-opt.png)

When the new row comes up, enter in the following:

```
Fonts provided by application
```

Then, under `Item 0`, we need to add our font’s name. The `plist` should look like the following:

[![Pixel digivolve.otf](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_plistfont-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/settings_plistfont-preview-opt.png)

The font should be ready to use! We should do a quick test to make sure it works as intended. Move to `GameScene.swift`, and in `sceneDidLoad` add the following code at the top of the function:

```
let label =SKLabelNode(fontNamed:"PixelDigivolve")
label.text ="Hello World!"
label.position =CGPoint(x: size.width /2, y: size.height /2)
label.zPosition =1000addChild(label)    
```

Does it work?

[![Hello world!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/screen_withtext-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/screen_withtext-preview-opt.png)

If it works, then you’ve done everything correctly. If not, then something is wrong. Code With Chris has a more in-depth [troubleshooting guide](http://codewithchris.com/common-mistakes-with-adding-custom-fonts-to-your-ios-app/), but note that it is for an older version of Swift, so you will have to make minor tweaks to bring it up to Swift 3.

Now that we can load in custom fonts, we can start on our HUD. Delete the “Hello World” label, because we only used it to make sure our font loads. The HUD will be an `SKNode`, acting like a container for our HUD elements. This is the same process we followed when creating the background node in lesson one.

Create the `HudNode.swift` file using the usual methods, and enter the following code:

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

Before we do anything else, open up `Constants.swift` and add the following line to the bottom of the file — we will be using it to retrieve and persist the high score:

```
let ScoreKey ="RAINCAT_HIGHSCORE"
```

In the code, we have five variables that pertain to the scoreboard. The first variable is the actual `SKLabelNode`, which we use to present the label. Next is our variable to hold the current score; then the variable that holds the best score. The last variable is a boolean that tells us whether we are currently presenting the high score (we use this to establish whether we need to run an `SKAction` to increase the scale of the scoreboard and to colorize it to the yellow of the floor).

The first function, `setup(size:)`, is there just to set everything up. We set up the `SKLabelNode` the same way we did earlier. The `SKNode` class does not have any size properties by default, so we need to create a way to set a size to position our `scoreNode` label. We’re also fetching the current high score from [`UserDefaults`](https://developer.apple.com/reference/foundation/userdefaults). This is a quick and easy way to save small chunks of data, but it isn’t secure. Because we’re not worried about security for this example, `UserDefaults` is perfectly fine.

In our `addPoint()`, we’re incrementing the current `score` variable and checking whether the user has gotten a high score. If they have a high score, then we save that score to `UserDefaults` and check whether we are currently showing the best score. If the user has achieved a high score, we can animate the size and color of `scoreNode`.

In the `resetPoints()` function, we set the current score to `0`. We then need to check whether we were showing the high score, and reset the size and color to the default values if needed.

Finally, we have a small function named `updateScoreboard`. This is an internal function to set the score to `scoreNode`‘s text. This is called in both `addPoint()` and `resetPoints()`.

### Hooking Up The HUD

We need to test whether our HUD is working correctly. Move over to `GameScene.swift`, and add the following line below the `foodNode` variable at the top of the file:

```
private let hudNode =HudNode()
```

Add the following two lines in the `sceneDidLoad()` function, near the top:

```
hudNode.setup(size: size)
addChild(hudNode)
```

Then, in the `spawnCat()` function, reset the points in case the cat has fallen off the screen. Add the following line after adding the cat sprite to the scene:

```
hudNode.resetPoints()
```

Next, in the `handleCatCollision(contact:)` function, we need to reset the score again when the cat is hit by rain. In the `switch` statement at the end of the function — when the other body is a `RainDropCategory` — add the following line:

```
hudNode.resetPoints()
```

Finally, we need to tell the scoreboard when the user has earned points. At the end of the file in `handleFoodHit(contact:)`, find the following lines up to here:

```
//TODO increment points
print("fed cat")
```

And replace them with this:

```
hudNode.addPoint()
```

Voilà!

[![HUD unlocked!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoring-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoring-preview-opt.png)

You should see the HUD in action. Run around and collect some food. The first time you collect food, you should see the score turn yellow and grow in scale. When you see this happen, let the cat get hit. If the score resets, then you’ll know you are on the right track!

[![High Score!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoreincrease-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_scoreincrease-preview-opt.png)

### The Next Scene

That’s right, we are moving to another scene! In fact, when completed, this will be the first screen of our app. Before you do anything else, open up `Constants.swift` and add the following line to the bottom of the file — we will be using it to retrieve and persist the high score:

```
let ScoreKey ="RAINCAT_HIGHSCORE"
```

Create the new scene, place it under the “Scenes” folder, and call it `MenuScene.swift`. Enter the following code in the `MenuScene.swift` file:

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

Because this scene is relatively simple, we won’t be creating any special classes. Our scene will consist of two buttons. These could be (and possibly deserve to be) their own class of `SKSpriteNodes`, but because they are different enough, we will not need to create new classes for them. This is an important tip for when you build your own game: You need to be able to determine where to stop and refactor code when things get complex. Once you’ve added more than three or four buttons to a game, it might be time to stop and refactor the menu button’s code into its own class.

The code above isn’t doing anything special; it is setting the positions of four sprites. We are also setting the scene’s background color, so that the whole background is the correct value. A nice tool to generate color codes from HEX strings for Xcode is [UI Color](http://uicolor.xyz/). The code above is also setting the textures for our button states. The button to start the game has a normal state and a pressed state, whereas the sound button is a toggle. To simplify things for the toggle, we will be changing the alpha value of the sound button upon the user’s press. We are also pulling and setting the high-score `SKLabelNode`.

Our `MenuScene` is looking pretty good. Now we need to show the scene when the app loads. Move to `GameViewController.swift` and find the following line:

```
let sceneNode =GameScene(size: view.frame.size)
```

Replace it with this:

```
let sceneNode =MenuScene(size: view.frame.size)
```

This small change will load `MenuScene` by default, instead of `GameScene`.

[![Our new scene!](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_newscene-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_newscene-preview-opt.png)

### Button States

Buttons can be tricky in SpriteKit. Plenty of third-party options are available (I even made one myself), but in theory you only need to know the three touch methods:

- `touchesBegan(_ touches: with event:)`
- `touchesMoved(_ touches: with event:)`
- `touchesEnded(_ touches: with event:)`

We covered this briefly when updating the umbrella, but now we need to know the following: which button was touched, whether the user released their tap or clicked that button, and whether the user is still touching it. This is where our `selectedButton` variable comes into play. When a touch begin, we can capture the button that the user started clicking with that variable. If they drag outside the button, we can handle this and give the appropriate texture to it. When they release the touch, we can then see whether they are still touching inside the button. If they are, then we can apply the associated action to it. Add the following lines to the bottom of `MenuScene.swift`:

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

This is simple button-handling for our two buttons. In `touchesBegan(_ touches: with events:)`, we start off by checking whether we have any currently selected buttons. If we do, we need to reset the state of the button to unpressed. Then, we need to check whether any button is pressed. If one is pressed, it will show the highlighted state for the button. Then, we set `selectedButton` to the button for use in the other two methods.

In `touchesMoved(_ touches: with events:)`, we check which button was originally touched. Then, we check whether the current touch is still within the bounds of `selectedButton`, and we update the highlighted state from there. The `startButton`‘s highlighted state changes the texture to the pressed-state’s texture, where the `soundButton`‘s highlighted state has the alpha value of the sprite set to 50%.

Finally, in `touchesEnded(_ touches: with event:)`, we check again which button is selected, if any, and then whether the touch is still within the bounds of the button. If all cases are satisfied, we call `handleStartButtonClick()` or `handleSoundButtonClick()` for the correct button.

### A Time For Action

Now that we have the basic button behavior down, we need an event to trigger when they are clicked. The easier button to implement is `startButton`. On click, we only need to present the `GameScene`. Update `handleStartButtonClick()` in the `MenuScene.swift` function to the following code:

```
func handleStartButtonClick(){
	let transition = SKTransition.reveal(with:.down, duration:0.75)
	let gameScene =GameScene(size: size)
	gameScene.scaleMode = scaleMode
	view?.presentScene(gameScene, transition: transition)
}
```

If you run the app now and press the button, the game will start!

Now we need to implement the mute toggle. We already have a sound manager, but we need to be able to tell it whether muting is on or off. In `Constants.swift`, we need to add a key to persist when muting is on. Add the following line:

```
let MuteKey ="RAINCAT_MUTED"
```

We will use this to save a boolean value to `UserDefaults`. Now that this is set up, we can move into `SoundManager.swift`. This is where we will check and set `UserDefaults` to see whether muting is on or off. At the top of the file, under the `trackPosition` variable, add the following line:

```
private(set) var isMuted = false
```   

This is the variable that the main menu (and anything else that will play sound) checks to determine whether sound is allowed. We initialize it as `false`, but now we need to check `UserDefaults` to see what the user wants. Replace the `init()` function with the following:

```
private override init(){
	//This is private, so you can only have one Sound Manager ever.
	trackPosition =Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
	
	let defaults = UserDefaults.standard
	
	isMuted = defaults.bool(forKey: MuteKey)
}
```

Now that we have a default value for `isMuted`, we need the ability to change it. Add the following code to the bottom of `SoundManager.swift`:

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
  
This method will toggle our muted variable, as well as update `UserDefaults`. If the new value is not muted, playback of the music will begin; if the new value is muted, playback will not begin. Otherwise, we will stop the current track from playing. After this, we need to edit the `if` statement in `startPlaying()`.

Find the following line:

```
if audioPlayer == nil || audioPlayer?.isPlaying == false {
```

And replace it with this:

```
if!isMuted &&(audioPlayer == nil || audioPlayer?.isPlaying == false){
```
    
Now, if muting is off and either the audio player is not set or the current audio player is no longer playing, we will play the next track.

From here, we can move back into `MenuScene.swift` to finish up our mute button. Replace `handleSoundbuttonClick()` with the following code:

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

This toggles the sound in `SoundManager`, checks the result and then appropriately sets the texture to show the user whether the sound is muted or not. We are almost done! We only need to set the initial texture of the button on launch. In `sceneDidLoad()`, find the following line:

```
soundButton =SKSpriteNode(texture: soundButtonTexture)
```
  

And replace it with this:

```
soundButton =SKSpriteNode(texture: SoundManager.sharedInstance.isMuted ?
soundButtonTextureOff : soundButtonTexture)
```

The example above uses a [ternary operator](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html#//apple_ref/doc/uid/TP40014097-CH6-ID60) to set the correct texture.

Now that the music is hooked up, we can move to `CatSprite.swift` to disable the cat meowing when muting is on. In the `hitByRain()`, we can add the following `if` statement after removing the walking action:

```
if SoundManager.sharedInstance.isMuted {return}
```

This statement will return whether the user has muted the app. Because of this, we will completely ignore our `currentRainHits`, `maxRainHits` and meowing sound effects.

After all of that, now it is time to try out our mute button. Run the app and verify whether it is playing and muting sounds appropriately. Mute the sound, close the app, and reopen it. Make sure that the mute setting persists. Note that if you just mute and rerun the app from Xcode, you might not have given enough time for `UserDefaults` to save. Play the game, and make sure the cat never meows when you are muted.

[![](https://i.vimeocdn.com/video/600110219.webp?mw=700&mh=528)](https://player.vimeo.com/video/189700402)

### Exiting The Game

Now that we have the first type of button for the main menu, we can get into some tricky business by adding the quit button to our game scene. Some interesting interactions can come up with our style of game; currently, the umbrella will move to wherever the user touches or moves their touch. Obviously, the umbrella moving to the quit button when the user is attempting to exit the game is a pretty poor user experience, so we will attempt to stop this from happening.

The quit button we are implementing will mimic the start game button that we added earlier, with much of the process staying the same. The change will be in how we handle touches. Get your `quit_button` and `quit_button_pressed` assets into the `Assets.xcassets` file, and add the following code to the `HudNode.swift` file:

```
private var quitButton : SKSpriteNode!
private let quitButtonTexture =SKTexture(imageNamed:"quit_button")
private let quitButtonPressedTexture =SKTexture(imageNamed:"quit_button_pressed")
```
    
This will handle our `quitButton` reference, along with the textures that we will set for the button states. To ensure that we don’t inadvertently update the umbrella while trying to quit, we need a variable that tells the HUD (and the game scene) that we are interacting with the quit button and not the umbrella. Add the following code below the `showingHighScore` boolean variable:

```
private(set) var quitButtonPressed = false
```
  
Again, this is a variable that only the `HudNode` can set but that other classes can check. Now that our variables are set up, we can add in the button to the HUD. Add the following code to the `setup(size:)` function:

```
quitButton = SKSpriteNode(texture: quitButtonTexture)
let margin : CGFloat =15
quitButton.position =CGPoint(x: size.width - quitButton.size.width - margin, y: size.height - quitButton.size.height - margin)
quitButton.zPosition =1000
  
addChild(quitButton)
```

The code above will set the quit button with the texture of our non-pressed state. We’re also setting the position to the upper-right corner and setting the `zPosition` to a high number in order to force it to always draw on top. If you run the game now, it will show up in `GameScene`, but it will not be clickable yet.

[![Quit button](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_quit-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_quit-preview-opt.png)

Now that the button has been positioned, we need to be able to interact with it. Right now, the only place where we have interaction in `GameScene` is when we are interacting with `umbrellaSprite`. In our example, the HUD will have priority over the umbrella, so that users don’t have to move the umbrella out of the way in order to exit. We can create the same functions in `HudNode.swift` to mimic the touch functionality in `GameScene.swift`. Add the following code to `HudNode.swift`:

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

The code above is a lot like the code that we created for `MenuScene`. The difference is that there is only one button to keep track of, so we can handle everything within these touch methods. Also, because we will know the location of the touch in `GameScene`, we can just check whether our button contains the touch point.

Move over to `GameScene.swift`, and replace the `touchesBegan(_ touches with event:)` and `touchesMoved(_ touches: with event:)` methods with the following code:

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

Here, each method handles everything in pretty much the same way. We’re telling the HUD that the user has interacted with the scene. Then, we check whether the quit button is currently capturing the touches. If it is not, then we move the umbrella. We’ve also added the `touchesEnded(_ touches: with event:)` function to handle the end of the click for the quit button, but we are still not using it for `umbrellaSprite`.

[![](https://i.vimeocdn.com/video/600111380.webp?mw=700&mh=549)](https://player.vimeo.com/video/189701318)

Now that we have a button, we need a way to have it affect `GameScene`. Add the following line to the top of `HudeNode.swift`:

```
  var quitButtonAction : (()->())?
```

This is a generic [closure](https://www.weheartswift.com/closures/)[19](#19) that has no input and no output. We will set this with code in the `GameScene.swift` file and call it when we click the button in `HudNode.swift`. Then, we can replace the `TODO` in the code we created earlier in the `touchEndedAtPoint(point:)` function with this:
        
```
if quitButton.contains(point)&& quitButtonAction != nil {
	quitButtonAction!()
}
```
    
Now, if we set the `quitButtonAction` closure, it will be called from this point.

To set up the `quitButtonAction` closure, we need to move over to `GameScene.swift`. In `sceneDidLoad()`, we can replace our HUD setup with the following code:

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

Run the app, press play, and then press quit. If you are back at the main menu, then your quit button is working as intended. In the closure that we created, we initialized a transition to the `MenuScene`. And we set this closure to the `HUD` node to run when the quit button is clicked. Another important line here is when we set the `quitButtonAction` to `nil`. The reason for this is that a retain cycle is occurring. The scene is holding a reference to the HUD where the HUD is holding a reference to the scene. Because there is a reference to both objects, neither will be disposed of when it comes time for garbage collection. In this case, every time we enter and leave `GameScene`, another instance of it will be created and never released. This is bad for performance, and the app will eventually run out of memory. There are a number of ways to avoid this, but in our case we can just remove the reference to `GameScene` from the HUD, and the scene and HUD will be terminated once we go back to the `MenuScene`. [Krakendev has a deeper explanation](http://krakendev.io/blog/weak-and-unowned-references-in-swift) of reference types and how to avoid these cycles.

Now, move to `GameViewController.swift`, and remove or comment out the following three lines of code:

```
view.showsPhysics = true
view.showsFPS = true
view.showsNodeCount = true
```
  
With the debugging data out of the way, the game is looking really good! Congratulations: We are currently into beta! Check out the final code from today [on GitHub](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-three)

### Final Thoughts

This is the final lesson of a three-part tutorial, and if you made it this far, you just did a lot of work on your game. In this tutorial, you went from a scene that had absolutely nothing in it, to a completed game. Congrats! In [lesson one](https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/), we added the floor, raindrops, background and umbrella sprites. We also played around with physics and made sure that our raindrops don’t pile up. We started out with collision detection and worked on culling nodes so that we would not run out of memory. We also added some user interaction by allowing the umbrella to move around towards where the user touches on the screen.

In [lesson two](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-2/), we added the cat and food, along with custom spawning methods for each of them. We updated our collision detection to allow for the cat and food sprites. We also worked on the movement of the cat. The cat gained a purpose: Eat every bit of food available. We added simple animation for the cat and added custom interactions between the cat and the rain. Finally, we added sound effects and music to make it feel like a complete game.

In this last lesson, we created a heads-up display to hold our score label, as well as our quit button. We handled actions across nodes and enabled the user to quit with a callback from the HUD node. We also added another scene that the user can launch into and can get back to after clicking the quit button. We handled the process for starting the game and for controlling sound in the game.

#### Where To Go From Here

We put in a lot of time to get this far, but there is still a lot of work that can go into this game. RainCat continues development still, and it is [available in the App Store](https://itunes.apple.com/us/app/raincat/id1152624676?ls=1&amp;mt=8). Below is a list of wants and needs to be added. Some of the items have been added, while others are still pending:

- Add in icons and a splash screen.
- Finalize the main menu (simplified for the tutorial).
- Fix bugs, including rogue raindrops and multiple food spawning.
- Refactor and optimize the code.
- Change the color palette of the game based on the score.
- Update the difficulty based on the score.
- Animate the cat when food is right above it.
- Integrate Game Center.
- Give credit (including proper credit for music tracks).

[Keep track on GitHub](https://github.com/thirteen23/RainCat) because these changes will be made in future. If you have any questions about the code, feel free to drop us a line at [hello@thirteen23.com](mailto:hello@thirteen23.com) and we can discuss it. If certain topics get enough attention, maybe we can write another article discussing the topic.

#### Thank You!

I want to thank all of the people who helped in the process of creating the game and developing the articles that go along with it.

- [Cathryn Rowe](https://www.thirteen23.com/about/#cathryn-rowe)

For the initial art, design and editing, and for publishing the articles in our [Garage](https://www.thirteen23.com/garage/)
- [Morgan Wheaton](https://www.thirteen23.com/about/#morgan-wheaton)

For the final menu design and color palettes (which will look awesome once I actually implement these features — stay tuned).
- [Nikki Clark](https://www.thirteen23.com/about/#nikki-clark)

For the awesome headers and dividers in the articles and for help with editing the articles.
- [Laura Levisay](https://www.thirteen23.com/about/#laura-levisay)

For all of the awesome GIFs in the articles and for sending me cute cat GIFs for moral support.
- [Tom Hudson](https://www.thirteen23.com/about/#tom-hudson)

For help with editing the articles and without whom this series would not have been made at all.
- [Lani DeGuire](https://www.thirteen23.com/about/#lani-deguire)

For help with editing the articles, which was a ton of work.
- [Jeff Moon](https://www.thirteen23.com/about/#jeffrey-moon)

For help editing lesson three and the ping-pong. Lots of ping-pong.
- [Tom Nelson](https://www.thirteen23.com/about/#tom-nelson)

For helping to make sure that the tutorial works as it should.

Seriously, it took a ton of people to get everything ready for this article and to release it to the store.

Thank you to everyone who reads this sentence, too.
