
> * 原文地址：[Building an AR game with ARKit and Spritekit](https://blog.pusher.com/building-ar-game-arkit-spritekit/)
> * 原文作者：[Esteban Herrera](https://github.com/eh3rrera)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-ar-game-arkit-spritekit.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-ar-game-arkit-spritekit.md)
> * 译者：
> * 校对者：

# Building an AR game with ARKit and Spritekit

*This blog post was written under the [Pusher Guest Writer program](https://pusher.com/guest-writer-program).*

[ARKit](https://developer.apple.com/arkit/) is the new Apple framework that integrates device motion tracking, camera capture, and scene processing to build [augmented reality (AR)](https://en.wikipedia.org/wiki/Augmented_reality) experiences.

When using ARKit, you have three options to create your AR world:

- SceneKit, to render 3D overlay content
- SpriteKit, to render 2D overlay content
- Metal, to build your own view for an AR experience

In this tutorial, we’re going to explore the basics of ARKit and SpriteKit by building a game, something inspired by Pokemon Go, but with ghosts, check out this video:

[![](https://i.ytimg.com/vi_webp/0mmaLiuYAho/maxresdefault.webp)](https://www.youtube.com/embed/0mmaLiuYAho)

Every few seconds, a little ghost appears randomly in the scene and a counter in the bottom left part of the screen is incremented. When you tap on a ghost, it fades out playing a sound and decrementing the counter.

The code of this project is hosted on [GitHub](https://github.com/eh3rrera/ARKitGameSpriteKit).

Let’s start by reviewing what you’ll need to develop and run this project.

## What you’ll need

First of all, ARKit requires an iOS device with an A9 or later processor for a full AR experience. In other words, you’ll need an iPhone 6s or better, iPhone SE, any iPad Pro, or the 2017 iPad.

ARKit is a feature of iOS 11, so you’ll need to have this version installed and use Xcode 9 for development. At the time of writing, iOS 11 and Xcode 9 are still in beta, so you’ll need to enroll in the [Apple Developer Program](https://developer.apple.com/programs/), however, Apple has now released both to the public so a paid developer account is no longer required. You can find more info about installing [iOS 11 beta here](https://9to5mac.com/2017/06/26/how-to-install-ios-11-public-beta-on-your-eligible-iphone-ipad-or-ipod-touch/) and [Xcode beta here](https://developer.apple.com/download/).

In case something changes in a later version, the app of this tutorial was built with Xcode beta 2.

For the game, we’ll need images to represent the ghosts and a sound effect to play when one is removed. A great site to find free game assets is [OpenGameArt.org](https://opengameart.org). I chose this [ghost image](https://opengameart.org/content/ghosts) and this [ghost sound effect](https://opengameart.org/content/ghost), but you can use any other files you want.

## Creating the project

Open Xcode 9 and create a new AR app:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-01-createProject.png)

Enter the project information, choosing Swift as the language and SpriteKit as the content technology and create the project:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-01-createProject2.png)

At this time, AR cannot be tested on an iOS simulator, so we’ll need to test on a real device. For this, we’ll need to sign our app with our developer account. If you haven’t already, add your developer account to Xcode and choose your team to sign your app:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-02-developmentTeam-774x600.png)

If you don’t have a paid developer account, you’ll have some limitations, like the fact that you can only create up to 10 App IDs every 7 days and that you can’t have more than 3 apps installed in your device.

The first time you install the app on your device,  probably you’ll be asked to trust the certificate in the device, just follow the instructions:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-03-Trust.png)

This way, when the app is run, you’ll be asked to give permissions to the camera:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-07-camera-permission.png)

After that, a new sprite will be added to the scene when you touch the screen and positioned according to the orientation of the camera:

[![](https://i.ytimg.com/vi_webp/NyIHEM69skU/maxresdefault.webp)](https://www.youtube.com/watch?v=NyIHEM69skU)

Now that we have set up the project, let’s take a look at the code.

## How SpriteKit works with ARKit

If you open `Main.storyboard`, you’ll see there’s an [ARSKView](https://developer.apple.com/documentation/arkit/arskview) that fills the entire screen:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-04-storyboard-836x600.png)

This view renders the live video feed from the device camera as the scene background, placing 2D images (as SpriteKit nodes) in the 3D space (as [ARAnchor](https://developer.apple.com/documentation/arkit/aranchor) objects). When you move the device, the view automatically rotates and scales the images (SpriteKit nodes) corresponding to anchors (`ARAnchor` objects) so that they appear to track the real world seen by the camera.

This view is managed by the class `ViewController.swift`. First, in the `viewDidLoad` method, it turns on some debug properties of the view and then creates the SpriteKit scene from the automatically created scene `Scene.sks`:

```
    override func viewDidLoad() {
      super.viewDidLoad()

      // Set the view's delegate
      sceneView.delegate = self

      // Show statistics such as fps and node count
      sceneView.showsFPS = true
      sceneView.showsNodeCount = true

      // Load the SKScene from 'Scene.sks'
      if let scene = SKScene(fileNamed: "Scene") {
        sceneView.presentScene(scene)
      }
    }
```

Then, the method `viewWillAppear` configures the session with the class [ARWorldTrackingSessionConfiguration](https://developer.apple.com/documentation/arkit/arworldtrackingsessionconfiguration). The session (an [ARSession](https://developer.apple.com/documentation/arkit/arsession) object) manages the motion tracking and image processing required to create an AR experience:

```
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      // Create a session configuration
      let configuration = ARWorldTrackingSessionConfiguration()

      // Run the view's session
      sceneView.session.run(configuration)
    }
```

You can configure the session with the `ARWorldTrackingSessionConfiguration` class to track the device’s movement with [six degrees of freedom (6DOF)](https://en.wikipedia.org/wiki/Six_degrees_of_freedom). The three rotation axes:

- Roll, the rotation on the X-axis
- Pitch, the rotation on the Y-axis
- Yaw, the rotation on the Z-axis

And three translation:

- Surging, moving forward and backward on the X-axis
- Swaying, moving left and right on the Y-axis
- Heaving, moving up and down on the Z-axis

Alternatively, you can also use [ARSessionConfiguration](https://developer.apple.com/documentation/arkit/arsessionconfiguration), which provides three degrees of freedom (3DOF) for simple motion tracking in less capable devices.

A few lines below, you’ll find the method `view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode?`. When an anchor is added, this method provides a custom node for that anchor that will be added to the scene. In this case, it returns an [SKLabelNode](https://developer.apple.com/documentation/spritekit/sklabelnode) to display the emoji that is presented to the user:

```
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
      // Create and configure a node for the anchor added to the view's session.
      let labelNode = SKLabelNode(text: "👾")
      labelNode.horizontalAlignmentMode = .center
      labelNode.verticalAlignmentMode = .center
      return labelNode;
    }
```

But when is this anchor created?

It is done in the file `Scene.swift`, the class that manages the Sprite scene (`Scene.sks`), specifically, in this method:

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let sceneView = self.view as? ARSKView else {
        return
      }

      // Create anchor using the camera's current position
      if let currentFrame = sceneView.session.currentFrame {
        // Create a transform with a translation of 0.2 meters in front of the camera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.2
        let transform = simd_mul(currentFrame.camera.transform, translation)

        // Add a new anchor to the session
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
      }
    }
```

As you can read in the comments, it creates an anchor using the camera’s current position, then it creates a matrix to position the anchor 0.2 meters in front of the camera and add it to the scene.

An ARAnchor uses a [4×4 matrix](https://developer.apple.com/documentation/scenekit/scnmatrix4) represents the combined position, rotation or orientation, and scale of an object in three-dimensional space.

In the 3D programming world, matrices are used to represent graphical transformations like translation, scaling, rotation, and projection. Through matrix multiplication, multiple transformations can be concatenated into a single transformation matrix.

Here’s a good post about [the math behind transforms](http://ronnqvi.st/the-math-behind-transforms/). Also, the [Core Animation Programming Guide has a section about manipulating layers in three dimensions](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/CoreAnimationBasics/CoreAnimationBasics.html#//apple_ref/doc/uid/TP40004514-CH2-SW18) where you can find matrix configurations for some common transformations.

Back to the code, we start with an identity matrix (`matrix_identity_float4x4`):

```
1.0   0.0   0.0   0.0  // This row represents X
0.0   1.0   0.0   0.0  // This row represents Y
0.0   0.0   1.0   0.0  // This row represents Z
0.0   0.0   0.0   1.0  // This row represents W
```


>  If you’re wondering what is W:
>
>  If w == 1, then the vector (x, y, z, 1) is a position in space.
>
>  If w == 0, then the vector (x, y, z, 0) is a direction.
>
> [http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/](http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/)

Then, the Z-axis of column number 3 is modified with the value -0.2 to indicate a translation in that axis (a negative z value places an object in front of the camera).

If you print the value of the translation matrix at this point, you’ll see it’s printed as an array of vectors, where each vector represents a column.

```
[ [1.0, 0.0,  0.0, 0.0 ],
  [0.0, 1.0,  0.0, 0.0 ],
  [0.0, 0.0,  1.0, 0.0 ],
  [0.0, 0.0, -0.2, 1.0 ]
]
```


Probably it’s easier to see it this way:

```
0     1     2     3    // Column number
1.0   0.0   0.0   0.0  // This row represents X
0.0   1.0   0.0   0.0  // This row represents Y
0.0   0.0   1.0  -0.2  // This row represents Z
0.0   0.0   0.0   1.0  // This row represents W
```


Then, this matrix is mutliplied by the transformation matrix of the camera’s current frame to get the final matrix that will be used to position the new anchor. For example, assumming the following camera’s transform matrix (as an array of columns):

```
[ [ 0.103152, -0.757742,   0.644349, 0.0 ],
  [ 0.991736,  0.0286687, -0.12505,  0.0 ],
  [ 0.0762833, 0.651924,   0.754438, 0.0 ],
  [ 0.0,       0.0,        0.0,      1.0 ]
]
```


The result of the multiplication will be:

```
[ [0.103152,   -0.757742,   0.644349, 0.0 ],
  [0.991736,    0.0286687, -0.12505,  0.0 ],
  [0.0762833,   0.651924,   0.754438, 0.0 ],
  [-0.0152567, -0.130385,  -0.150888, 1.0 ]
]
```


Here’s more information about [how to multiply matrices](https://www.mathsisfun.com/algebra/matrix-multiplying.html) and here’s a [matrix multiplication calculator](http://matrix.reshish.com/multiplication.php).

Now that you understand how the sample works, let’s modify it to make our game.

## Building the SpriteKit scene

In the file Scene.swift, let’s add the following properties:

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

We’re adding two labels, one that represents the number of ghosts present in the scene, a time interval to control the creating of the ghosts, and the ghost counter, with a property observer to update the label whenever its value changes.

Next up, download the sound that will be played when the ghost is removed and drag it to the project:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-06-addImages-1.gif)

And add the following line to the class:

```
let killSound = SKAction.playSoundFileNamed("ghost", waitForCompletion: false)
```

We’ll call this action later to play the sound.

In the method `didMove`, let’s add the labels to the scene:

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

You can use a site like [iOS Fonts](http://iosfonts.com/) to visually choose the font for the labels.

The position coordinates represent the bottom-left section of the screen (the code to make this happen will be explained later). I chose to place them in that section of the screen to avoid orientation issues because the size of the scene changes with the orientation, however, the coordinates remain the same, which can cause the labels to appear out of the screen or in odd positions (which can be fixed by overriding the `didChangeSize` method or by using [UILabels](https://developer.apple.com/documentation/uikit/uilabel) instead of [SKLabelNodes](https://developer.apple.com/documentation/spritekit/sklabelnode)).

Now, to create the ghosts at a defined time interval, we’ll need some sort of timer. The update method, which is called before a frame is rendered (in average 60 times per second), can help us with this:

```
    override func update(_ currentTime: TimeInterval) {
      // Called before each frame is rendered
      if currentTime > creationTime {
        createGhostAnchor()
        creationTime = currentTime + TimeInterval(randomFloat(min: 3.0, max: 6.0))
      }
    }
```

The argument `currentTime` represents the current time in the app, so if this is greater than the time represented by `creationTime`, a new ghost anchor will be created and `creationTime` will be incremented by a random amount of seconds, in this case, between 3 and 6.

Here’s the definition of `randomFloat`:

```
    func randomFloat(min: Float, max: Float) -> Float {
      return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
```

For the `createGhostAnchor` method, we need to get the scene view:

```
    func createGhostAnchor(){
      guard let sceneView = self.view as? ARSKView else {
        return
      }

    }
```

Then, since the functions we’re going to use work with radians, let’s define 360 degrees in radians:

```
    func createGhostAnchor(){
      ...

      let _360degrees = 2.0 * Float.pi

    }
```

Now, to place the ghost in a random position, let’s create one random rotation matrix on the X-axis and one on the Y-axis:

```
    func createGhostAnchor(){
      ...

       let rotateX = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 1, 0, 0))

      let rotateY = simd_float4x4(SCNMatrix4MakeRotation(_360degrees * randomFloat(min: 0.0, max: 1.0), 0, 1, 0))

    }
```


Luckily, we don’t have to build the rotation matrix manually, there are functions that returns a matrix describing a rotation, translation, or scale transformation.

In this case, [SCNMatrix4MakeRotation](https://developer.apple.com/documentation/scenekit/1409686-scnmatrix4makerotation) returns a matrix describing a rotation transformation. The first parameter represents the angle of rotation, in radians. The expression `_360degrees * randomFloat(min: 0.0, max: 1.0)` gives a random angle from 0 to 360 degrees.

The rest of `SCNMatrix4MakeRotation`’s parameters represent the X, Y, and Z-components of the rotation axis respectively, that’s why we’re passing 1 as the parameter that corresponds to X in the first call and 1 as the parameter that corresponds to Y in the second call.

The result of `SCNMatrix4MakeRotation` is converted to a 4×4 matrix using the `simd_float4x4` struct.

>   If you’re using XCode 9 Beta 1, you should use SCNMatrix4ToMat4 instead, which was replaced by simd_float4x4 in XCode 9 Beta 2.

We can combine both rotation matrices with a multiplication operation:

```
    func createGhostAnchor(){
      ...
      let rotation = simd_mul(rotateX, rotateY)

    }
```

Then, we create a translation matrix in the Z-axis with a random value between -1 and -2 meters:

```
    func createGhostAnchor(){
      ...
      var translation = matrix_identity_float4x4
      translation.columns.3.z = -1 - randomFloat(min: 0.0, max: 1.0)

    }
```

Combine the rotation and translation matrices:

```
    func createGhostAnchor(){
      ...
      let transform = simd_mul(rotation, translation)

    }
```

Create and add the anchor to the session:

```
    func createGhostAnchor(){
      ...
      let anchor = ARAnchor(transform: transform)
      sceneView.session.add(anchor: anchor)

    }
```

And increment the ghost counter:

```
    func createGhostAnchor(){
      ...
      ghostCount += 1
    }
```

Now the only piece of code that is missing is the one executed when the user touches a ghost to remove it. Override the `touchesBegan` method to get the touch object first:

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let touch = touches.first else {
        return
      }

    }
```

Then get the location of the touch in the AR scene:

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      let location = touch.location(in: self)

    }
```

Get the nodes at that location:

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      let hit = nodes(at: location)

    }
```

Get the first node (if any) and check if the node represents a ghost (remember that labels are also a node):

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      if let node = hit.first {
        if node.name == "ghost" {

        }
      }
    }
```

If that’s the case, group the fade-out and sound actions, create an action sequence, execute it, and decrement the ghost counter:

```
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      ...
      if let node = hit.first {
        if node.name == "ghost" {

          let fadeOut = SKAction.fadeOut(withDuration: 0.5)
          let remove = SKAction.removeFromParent()

          // Group the fade out and sound actions
          let groupKillingActions = SKAction.group([fadeOut, killSound])
          // Create an action sequence
          let sequenceAction = SKAction.sequence([groupKillingActions, remove])

          // Excecute the actions
          node.run(sequenceAction)

          // Update the counter
          ghostCount -= 1

        }
      }
    }
```

And our scene is done, now let’s work on the view controller of `ARSKView`.

## Building the view controller

In viewDidLoad, instead of loading the scene Xcode created for us, let’s create our scene in this way:

```
    override func viewDidLoad() {
      ...

      let scene = Scene(size: sceneView.bounds.size)
      scene.scaleMode = .resizeFill
      sceneView.presentScene(scene)
    }
```

This will ensure our scene fills the entire view and therefore, the entire screen (remember that the `ARSKView` defined in `Main.storyboard` fills the entire screen).  This will also help to position the game labels in the bottom-left section of the screen, with the position coordinates defined in the scene.

Now it’s time to include the ghost images. In my case, the image format was SVG so I converted to PNG and for simplicity,  only added the first 6 ghosts of the image, creating the 2X and 3X versions (I didn’t see the point on creating the 1X version since devices using this resolution probably won’t be able to run the app anyway).

Drag the image to `Assets.xcassets`:

![](https://blog.pusher.com/wp-content/uploads/2017/07/building-an-ar-game-with-arkit-and-spritekit-06-addImages.gif)

Notice the number at the end of the image’s names – this will help us to randomly choose an image to create the SpriteKit node. Replace the code in `view(_ view: ARSKView, nodeFor anchor: ARAnchor)` with this:

```
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
      let ghostId = randomInt(min: 1, max: 6)

      let node = SKSpriteNode(imageNamed: "ghost\(ghostId)")
      node.name = "ghost"

      return node
    }
```

We give all the nodes the same name *ghost,* so we can identify them when it’s time to remove them.

Of course, don’t forget the randomInt function:

```
    func randomInt(min: Int, max: Int) -> Int {
      return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
```

And we’re done! Let’s test it.

## Testing the app

Run the app on a real device, give permissions to the camera, and start searching for the ghosts in all directions:

[![](https://i.ytimg.com/vi_webp/0mmaLiuYAho/maxresdefault.webp)](https://www.youtube.com/embed/0mmaLiuYAho)

A new ghost should appear every 3 to 6 seconds, the counter should be updated and a sound should play every time you hit a ghost.

Try to take the counter to zero!

## Conclusion

There are two great things about ARKit. One is that with a few lines of code we can create amazing AR apps, and second, we can leverage our knowledge of SpriteKit and SceneKit. ARKit actually has a small number of classes, it’s more learning about how to use the mentioned frameworks and adapt them a little bit to create an AR experience.

You can extend this app by adding game rules, introducing bonus points or changing the images and sound. Also, using [Pusher](https://pusher.com/), you could add multi-player features by syncing the state of the game.

Remember that you can find the Xcode project in this [GitHub repository](https://github.com/eh3rrera/ARKitGameSpriteKit).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
