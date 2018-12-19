> * 原文地址：[Intermediate Design Patterns in Swift](https://www.raywenderlich.com/2102-intermediate-design-patterns-in-swift)
> * 原文作者：[raywenderlich.com](https://www.raywenderlich.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/intermediate-design-patterns-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/intermediate-design-patterns-in-swift.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# iOS 设计模式进阶

设计模式对于代码的维护和提高可读性非常有用，通过本教程你讲学习 Swift 中的其他设计模式。

**更新说明**：本教程已由译者针对 iOS 12，Xcode 10 和 Swift 4.2 进行了更新

**新手教程**：没了解过设计模式？来看看设计模式的 [入门教程](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-1-2.md) 来阅读之前的基础知识吧。

在本教程中，您将学习如何使用 Swift 中的设计模式来重构一个名为 **Tap the Larger Shape** 的游戏。

了解设计模式对于编写可维护且无错误的应用程序至关重要，了解何时采用何种设计模式是一项只能通过实践学习的技能。这本教程再好不过了！

但究竟什么是设计模式呢？这是一个针对常见问题的正式文档型解决方案。例如，考虑一下遍历一个集合，您在此处使用 **迭代器** 设计模式：

```swift
var collection = ...

// for 循环使用迭代器设计模式
for item in collection {
  print("Item is: \(item)")
}
```

**迭代器** 设计模式的价值在于它抽象出了访问集合中每一项的实际底层机制。无论 `集合` 是数组，字典还是其他类型，您的代码都可以用相同的方式访问它们中的每一项。

不仅如此，设计模式也是开发者文化的一部分，因此维护或扩展代码的另一个开发人员可能会理解迭代器设计模式，它们是用于推理出软件架构的语言。

在 iOS 编程中有很多设计模式频繁出现，例如 **MVC** 出现在几乎每个应用程序中，**代理** 是一个强大的，通常未被充分利用的模式，比如说你曾用过的 tableView，本教程讨论了一些鲜为人知但非常有用的设计模式。

如果您不熟悉设计模式的概念，此篇文章可能不适合现在的你，不妨先看一下 [使用 Swift 的 iOS 设计模式](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-1-2.md) 来开始吧。

## 入门

Tap the Larger Shape 是一个有趣但简单的游戏，你会看到一对相似的形状，你需要点击两者中较大的一个。如果你点击较大的形状，你会得到一分，反之你会失去一分。

你看起来好像你涂鸦出了一些随机的方块、圆圈和三角形涂鸦，不过孩子们会买单的！:\]

下载 [入门项目](https://github.com/iWeslie/SwiftDesignPatterns) 并在 Xcode 中打开。

> **注意**：您需要使用 Xcode 10 和 Swift 4.2 及以上版本从而获得最大的兼容性和稳定性。

此入门项目包含完整游戏，您将在本教程中对改项目进行重构并利用一些设计模式来使您的游戏更易于维护并且更加有趣。

Build and run the project on the iPhone 5 simulator, and tap a few shapes to understand how the game plays. You should see something like the image below:

[![Tap the larger shape and gain points.](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot2-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot2.png)

Tap the larger shape and gain points.

[![Tap the smaller shape and lose points.](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot3-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot3.png)

Tap the smaller shape and lose points.

## Understanding the Game

Before getting into the details of design patterns, take a look at the game as it’s currently written. Open **Shape.swift** take a look around and find the following code. You don’t need to make any changes, just look:

```swift
import UIKit

class Shape {
}

class SquareShape: Shape {
  var sideLength: CGFloat!
}
```

The `Shape` class is the basic model for tappable shapes in the game. The concrete subclass `SquareShape` represents a square: a polygon with four equal-length sides.

Next, open **ShapeView.swift** and take a look at the code for `ShapeView`:

```swift
import UIKit

class ShapeView: UIView {
  var shape: Shape!

  // 1
  var showFill: Bool = true {
    didSet {
      setNeedsDisplay()
    }
  }
  var fillColor: UIColor = UIColor.orangeColor() {
    didSet {
      setNeedsDisplay()
    }
  }

  // 2
  var showOutline: Bool = true {
    didSet {
      setNeedsDisplay()
    }
  }
  var outlineColor: UIColor = UIColor.grayColor() {
    didSet {
      setNeedsDisplay()
    }
  }

  // 3
  var tapHandler: ((ShapeView) -> ())?

  override init(frame: CGRect) {
    super.init(frame: frame)

    // 4
    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap"))
    addGestureRecognizer(tapRecognizer)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func handleTap() {
  	// 5
    tapHandler?(self)
  }

  let halfLineWidth: CGFloat = 3.0
}
```

`ShapeView` is the view that renders a generic `Shape` model. Line by line, here’s what’s happening in that block:

1.  Indicate if the app should fill the shape with a color, and if so, which color. This is the solid interior color of the shape.

2.  Indicate if the app should stroke the shape’s outline with a color, and if so, which color. This is the color of the shape’s border.

3.  A closure that handles taps (e.g. to adjust the score). If you’re not familiar with Swift closures, you can review them in this [Swift Functional Programming Tutorial](http://www.raywenderlich.com/82599/swift-functional-programming-tutorial), but keep in mind they’re similar to Objective C blocks.

4.  Set up a tap gesture recognizer that invokes `handleTap` when the player taps the view.

5.  Invoke the `tapHandler` when the gesture recognizer recognizes a tap gesture.

Now scroll down and examine `SquareShapeView`:

```swift
class SquareShapeView: ShapeView {
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)

    // 1
    if showFill {
      fillColor.setFill()
      let fillPath = UIBezierPath(rect: bounds)
      fillPath.fill()
    }

    // 2
    if showOutline {
      outlineColor.setStroke()

      // 3
      let outlinePath = UIBezierPath(rect: CGRect(x: halfLineWidth, y: halfLineWidth, width: bounds.size.width - 2 * halfLineWidth, height: bounds.size.height - 2 * halfLineWidth))
      outlinePath.lineWidth = 2.0 * halfLineWidth
      outlinePath.stroke()
    }
  }
}
```

Here’s how `SquareShapeView` draws itself:

1.  If configured to show fill, then fill in the view with the fill color.

2.  If configured to show an outline, then outline the view with the outline color.

3.  Since iOS draws lines that are centered over their position, you need to inset the view bounds by `halfLineWidth` when stroking the path.

Excellent, now that you understand how the game draws its shapes, open **GameViewController.swift** and have a look at the game logic:

```swift
import UIKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // 1
    beginNextTurn()
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  private func beginNextTurn() {
    // 2
    let shape1 = SquareShape()
    shape1.sideLength = Utils.randomBetweenLower(0.3, andUpper: 0.8)
    let shape2 = SquareShape()
    shape2.sideLength = Utils.randomBetweenLower(0.3, andUpper: 0.8)

    // 3
    let availSize = gameView.sizeAvailableForShapes()

    // 4
    let shapeView1: ShapeView =
      SquareShapeView(frame: CGRect(x: 0,
                                    y: 0,
                                    width: availSize.width * shape1.sideLength,
                                    height: availSize.height * shape1.sideLength))
    shapeView1.shape = shape1
    let shapeView2: ShapeView =
      SquareShapeView(frame: CGRect(x: 0,
                                    y: 0,
                                    width: availSize.width * shape2.sideLength,
                                    height: availSize.height * shape2.sideLength))
    shapeView2.shape = shape2

    // 5
    let shapeViews = (shapeView1, shapeView2)

    // 6
    shapeViews.0.tapHandler = {
      tappedView in
      self.gameView.score += shape1.sideLength >= shape2.sideLength ? 1 : -1
      self.beginNextTurn()
    }
    shapeViews.1.tapHandler = {
      tappedView in
      self.gameView.score += shape2.sideLength >= shape1.sideLength ? 1 : -1
      self.beginNextTurn()
    }

    // 7
    gameView.addShapeViews(shapeViews)
  }

  private var gameView: GameView { return view as! GameView }
}
```

Here’s how the game logic works:

1.  Begin a turn as soon as the `GameView` loads.

2.  Create a pair of square shapes with random side lengths drawn as proportions in the range `[0.3, 0.8]`. The shapes will also scale to any screen size.

3.  Ask the `GameView` what size is available for each shape based on the current screen size.

4.  Create a `SquareShapeView` for each shape, and size the shape by multiplying the shape’s `sideLength` proportion by the appropriate `availSize` dimension of the current screen.

5.  Store the shapes in a tuple for easier manipulation.

6.  Set the tap handler on each shape view to adjust the score based on whether the player tapped the larger view or not.

7.  Add the shapes to the `GameView` so it can lay out the shapes and display them.

That’s it. That’s the complete game logic. Pretty simple, right? :\]

## Why Use Design Patterns?

You’re probably wondering to yourself, “Hmmm, so why do I need design patterns when I have a working game?” Well, what if you want to support shapes other than just squares?

You **could** add code to create a second shape in `beginNextTurn`, but as you add a third, fourth or even fifth type of shape the code would become unmanageable.

And what if you want the player to be able to select the shape she plays?

If you lump all of that code together in `GameViewController` you’ll end up with tightly-coupled code containing hard-coded dependencies that will be difficult to manage.

Here’s the answer to your question: design patterns help decouple your code into nicely-separated bits.

Before moving on, I have a confession; I already snuck in a design pattern.

[![ragecomic1](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic1-e1415029446968-480x268.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic1-e1415029446968.png)

Now, on to the design patterns. Each section from here on describes a different design pattern. Let’s get going!

## Design Pattern: Abstract Factory

`GameViewController` is tightly coupled with the `SquareShapeView`, and that doesn’t allow much room to later use a different view to represent squares or introduce a second shape.

Your first task is to decouple and simplify your `GameViewController` using the **Abstract Factory** design pattern. You’re going to use this pattern in code that establishes an API for constructing a group of related objects, like the shape views you’ll work with momentarily, without hard-coding specific classes.

Click File\New\File… and then select iOS\Source\Swift File. Call the file **ShapeViewFactory.swift**, save it and then replace its contents with the code below:

```swift
import UIKit

// 1
protocol ShapeViewFactory {
  // 2
  var size: CGSize { get set }
  // 3
  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView)
}
```

Here’s how your new factory works:

1.  Define `ShapeViewFactory` as a Swift protocol. There’s no reason for it to be a class or struct since it only describes an interface and has no functionality itself.

2.  Each factory should have a size that defines the bounding box of the shapes it creates. This is essential to layout code using the factory-produced views.

3.  Define the method that produces shape views. This is the “meat” of the factory. It takes a tuple of two Shape objects and returns a tuple of two ShapeView objects. This essentially manufactures views from its raw materials — the models.

Add the following code to end of **ShapeViewFactory.swift**:

```swift
class SquareShapeViewFactory: ShapeViewFactory {
  var size: CGSize

  // 1
  init(size: CGSize) {
    self.size = size
  }

  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    // 2
    let squareShape1 = shapes.0 as! SquareShape
    let shapeView1 =
      SquareShapeView(frame: CGRect(x: 0,
                                    y: 0,
                                    width: squareShape1.sideLength * size.width,
                                    height: squareShape1.sideLength * size.height))
    shapeView1.shape = squareShape1

    // 3
    let squareShape2 = shapes.1 as! SquareShape
    let shapeView2 =
      SquareShapeView(frame: CGRect(x: 0,
                                    y: 0,
                                    width: squareShape2.sideLength * size.width,
                                    height: squareShape2.sideLength * size.height))
    shapeView2.shape = squareShape2

    // 4
    return (shapeView1, shapeView2)
  }
}
```

Your `SquareShapeViewFactory` produces `SquareShapeView` instances as follows:

1.  Initialize the factory to use a consistent maximum size.

2.  Construct the first shape view from the first passed shape.

3.  Construct the second shape view from the second passed shape.

4.  Return a tuple containing the two created shape views.

Finally, it’s time to put `SquareShapeViewFactory` to use. Open **GameViewController.swift**, and replace its contents with the following:

```swift
import UIKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // 1 ***** ADDITION
    shapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())

    beginNextTurn()
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  private func beginNextTurn() {
    let shape1 = SquareShape()
    shape1.sideLength = Utils.randomBetweenLower(0.3, andUpper: 0.8)
    let shape2 = SquareShape()
    shape2.sideLength = Utils.randomBetweenLower(0.3, andUpper: 0.8)

    // 2 ***** ADDITION
    let shapeViews = shapeViewFactory.makeShapeViewsForShapes((shape1, shape2))

    shapeViews.0.tapHandler = {
      tappedView in
      self.gameView.score += shape1.sideLength >= shape2.sideLength ? 1 : -1
      self.beginNextTurn()
    }
    shapeViews.1.tapHandler = {
      tappedView in
      self.gameView.score += shape2.sideLength >= shape1.sideLength ? 1 : -1
      self.beginNextTurn()
    }

    gameView.addShapeViews(shapeViews)
  }

  private var gameView: GameView { return view as! GameView }

  // 3 ***** ADDITION
  private var shapeViewFactory: ShapeViewFactory!
}
```

There are three new lines of code:

1.  Initialize and store a `SquareShapeViewFactory`.

2.  Use this new factory to create your shape views.

3.  Store your new shape view factory as an instance property.

The key benefits are in section two, where you replaced six lines of code with one. Better yet, you moved the complex shape view creation code out of `GameViewController` to make the class smaller and easier to follow.

It’s helpful to move view creation code out of your view controller since `GameViewController` acts as a view controller and coordinates between model and view.

Build and run, and then you should see something like the following:

[![Screenshot4](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot4-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot4.png)

Nothing about your game’s visuals changed, but you did simplify your code.

If you were to replace `SquareShapeView` with `SomeOtherShapeView`, then the benefits of the `SquareShapeViewFactory` would shine. Specifically, you wouldn’t need to alter `GameViewController`, and you could isolate all the changes to `SquareShapeViewFactory`.

Now that you’ve simplified the creation of shape views, you’re going to simplify the creation of shapes. Create a new Swift file like before, called **ShapeFactory.swift**, and paste in the following code:

```swift
import UIKit

// 1
protocol ShapeFactory {
  func createShapes() -> (Shape, Shape)
}

class SquareShapeFactory: ShapeFactory {
  // 2
  var minProportion: CGFloat
  var maxProportion: CGFloat

  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }

  func createShapes() -> (Shape, Shape) {
    // 3
    let shape1 = SquareShape()
    shape1.sideLength = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)

    // 4
    let shape2 = SquareShape()
    shape2.sideLength = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)

    // 5
    return (shape1, shape2)
  }
}
```

Your new `ShapeFactory` produces shapes as follows:

1.  Again, you’ve declared the `ShapeFactory` as a protocol to build in maximum flexibility, just like you did for `ShapeViewFactory`.

2.  You want your shape factory to produce shapes that have dimensions in unit terms, for instance, in a range like `[0, 1]` — so you store this range.

3.  Create the first square shape with random dimensions.

4.  Create the second square shape with random dimensions.

5.  Return the pair of square shapes as a tuple.

Now open **GameViewController.swift** and insert the following line at the bottom just before the closing curly brace:

```swift
private var shapeFactory: ShapeFactory!
```

Then insert the following line near the bottom of `viewDidLoad`, just above the invocation of `beginNextTurn`:

```swift
shapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
```

Finally, replace `beginNextTurn` with this code:

```swift
private func beginNextTurn() {
  // 1
  let shapes = shapeFactory.createShapes()

  let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes)

  shapeViews.0.tapHandler = {
    tappedView in
    // 2
    let square1 = shapes.0 as! SquareShape, square2 = shapes.1 as! SquareShape
    // 3
    self.gameView.score += square1.sideLength >= square2.sideLength ? 1 : -1
    self.beginNextTurn()
  }
  shapeViews.1.tapHandler = {
    tappedView in
    let square1 = shapes.0 as! SquareShape, square2 = shapes.1 as! SquareShape
    self.gameView.score += square2.sideLength >= square1.sideLength ? 1 : -1
    self.beginNextTurn()
  }

  gameView.addShapeViews(shapeViews)
}
```

Section by section, here’s what that does.

1.  Use your new shape factory to create a tuple of shapes.

2.  Extract the shapes from the tuple…

3.  …so that you can compare them here.

Once again, using the **Abstract Factory** design pattern simplified your code by moving shape generation out of `GameViewController`.

## Design Pattern: Servant

At this point you can **almost** add a second shape, for example, a circle. Your only hard-coded dependence on squares is in the score calculation in `beginNextTurn` in code like the following:

```swift
shapeViews.1.tapHandler = {
  tappedView in
  // 1
  let square1 = shapes.0 as! SquareShape, square2 = shapes.1 as! SquareShape

  // 2
  self.gameView.score += square2.sideLength >= square1.sideLength ? 1 : -1
  self.beginNextTurn()
}
```

Here you cast the shapes to `SquareShape` so that you can access their `sideLength`. Circles don’t have a `sideLength`, instead they have a `diameter`.

The solution is to use the **Servant** design pattern, which provides a behavior like score calculation to a group of classes like shapes, via a common interface. In your case, the score calculation will be the servant, the shapes will be the serviced classes, and an `area` property plays the role of the common interface.

Open **Shape.swift** and add the following line to the bottom of the `Shape` class:

```swift
var area: CGFloat { return 0 }
```

Then add the following line to the bottom of the `SquareShape` class:

```swift
override var area: CGFloat { return sideLength * sideLength }
```

You can see where this is going — you can calculate which shape is larger based on its area.

Open **GameViewController.swift** and replace `beginNextTurn` with the following:

```swift
private func beginNextTurn() {
  let shapes = shapeFactory.createShapes()

  let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes)

  shapeViews.0.tapHandler = {
    tappedView in
    // 1
    self.gameView.score += shapes.0.area >= shapes.1.area ? 1 : -1
    self.beginNextTurn()
  }
  shapeViews.1.tapHandler = {
    tappedView in
    // 2
    self.gameView.score += shapes.1.area >= shapes.0.area ? 1 : -1
    self.beginNextTurn()
  }

  gameView.addShapeViews(shapeViews)
}
```

1.  Determines the larger shape based on the shape area.

2.  Also determines the larger shape based on the shape area.

Build and run, and you should see something like the following — the game looks the same, but the code is now more flexible.

[![Screenshot6](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot6-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot6.png)

Congratulations, you’ve completely removed dependencies on squares from your game logic. If you were to create and use some circle factories, your game would become more…well-rounded.

[![ragecomic2](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic2.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic2.png)

## Leveraging Abstract Factory for Gameplay Versatility

“Don’t be a square!” can be an insult in real life, and your game feels like it’s been boxed in to one shape — it aspires to smoother lines and more aerodynamic shapes

You need to introduce some smooth “circley goodness.” Open **Shape.swift**, and then add the following code at the bottom of the file:

```swift
class CircleShape: Shape {
    var diameter: CGFloat!
    override var area: CGFloat { return CGFloat(M**PI) * diameter * diameter / 4.0 }
}
```

Your circle only needs to know the `diameter` from which it can compute its area, and thus support the **Servant** pattern.

Next, build `CircleShape` objects by adding a `CircleShapeFactory`. Open **ShapeFactory.swift**, and add the following code at the bottom of the file:

```swift
class CircleShapeFactory: ShapeFactory {
  var minProportion: CGFloat
  var maxProportion: CGFloat

  init(minProportion: CGFloat, maxProportion: CGFloat) {
    self.minProportion = minProportion
    self.maxProportion = maxProportion
  }

  func createShapes() -> (Shape, Shape) {
    // 1
    let shape1 = CircleShape()
    shape1.diameter = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)

    // 2
    let shape2 = CircleShape()
    shape2.diameter = Utils.randomBetweenLower(minProportion, andUpper: maxProportion)

    return (shape1, shape2)
  }
}
```

This code follows a familiar pattern: **Section 1** and **Section 2** create a `CircleShape` and assign it a random `diameter`.

You need to solve another problem, and doing so might just prevent a messy Geometry Revolution. See, what you have right now is “Geometry Without Representation,” and you know how wound up shapes can get when they feel underrepresented. (haha!)

It’s easy to please your constituents; all you need to is **represent** your new `CircleShape` objects on the screen with a `CircleShapeView`. :\]

Open `ShapeView.swift` and add the following at the bottom of the file:

```swift
class CircleShapeView: ShapeView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    // 1
    self.opaque = false
    // 2
    self.contentMode = UIViewContentMode.Redraw
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func drawRect(rect: CGRect) {
    super.drawRect(rect)

    if showFill {
      fillColor.setFill()
      // 3
      let fillPath = UIBezierPath(ovalInRect: self.bounds)
      fillPath.fill()
    }

    if showOutline {
      outlineColor.setStroke()
      // 4
      let outlinePath = UIBezierPath(ovalInRect: CGRect(
        x: halfLineWidth,
        y: halfLineWidth,
        width: self.bounds.size.width - 2 * halfLineWidth,
        height: self.bounds.size.height - 2 * halfLineWidth))
      outlinePath.lineWidth = 2.0 * halfLineWidth
      outlinePath.stroke()
    }
  }
}
```

Explanations of the above that take each section in turn:

1.  Since a circle cannot fill the rectangular bounds of its view, you need to tell **UIKit** that the view is not opaque, meaning content behind it may poke through. If you miss this, then the circles will have an ugly black background.

2.  Because the view is not opaque, you should redraw the view when its bounds change.

3.  Draw a circle filled with the `fillColor`. In a moment, you’ll create `CircleShapeViewFactory`, which will ensurethat `CircleView` has equal width and height so the shape will be a circle and not an ellipse.

4.  Stroke the outline border of the circle and inset to account for line width.

Now you’ll create `CircleShapeView` objects in a `CircleShapeViewFactory`.

Open **ShapeViewFactory.swift** and add the following code at the bottom of the file:

```swift
class CircleShapeViewFactory: ShapeViewFactory {
  var size: CGSize

  init(size: CGSize) {
    self.size = size
  }

  func makeShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    let circleShape1 = shapes.0 as! CircleShape
    // 1
    let shapeView1 = CircleShapeView(frame: CGRect(
      x: 0,
      y: 0,
      width: circleShape1.diameter * size.width,
      height: circleShape1.diameter * size.height))
    shapeView1.shape = circleShape1

    let circleShape2 = shapes.1 as! CircleShape
    // 2
    let shapeView2 = CircleShapeView(frame: CGRect(
      x: 0,
      y: 0,
      width: circleShape2.diameter * size.width,
      height: circleShape2.diameter * size.height))
    shapeView2.shape = circleShape2

    return (shapeView1, shapeView2)
  }
}
```

This is the factory that will create circles instead of squares. **Section 1** and **Section 2** are creating `CircleShapeView` instances by using the passed in shapes. Notice how your code is makes sure the circles have equal width and height so they render as perfect circles and not ellipses.

Finally, open **GameViewController.swift** and replace the lines in `viewDidLoad` that assign the shape and view factories with the following:

```swift
shapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
shapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
```

Now build and run and you should see something like the following screenshot.

[![Screenshot7](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot7-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot7.png)
Lookee there. You made circles!

Notice how you were able to add a new shape without much impact on your game’s logic in `GameViewController`? The Abstract Factory and Servant design patterns made this possible.

## Design Pattern: Builder

Now it’s time to examine a third design pattern: **Builder**.

Suppose you want to vary the appearance of your `ShapeView` instances — whether they should show fill and outline colors and what colors to use. The **Builder** design pattern makes such object configuration easier and more flexible.

One approach to solve this configuration problem would be to add a variety of constructors, either class convenience methods like `CircleShapeView.redFilledCircleWithBlueOutline()` or initializers with a variety of arguments and default values.

Unfortunately, it’s not a scalable technique as you’d need to write a new method or initializer for every combination.

Builder solves this problem rather elegantly because it creates a class with a single purpose — configure an already initialized object. If you set up your builder to build red circles and then later blue circles, it’ll do so without need to alter `CircleShapeView`.

Create a new file **ShapeViewBuilder.swift** and replace its contents with the following code:

```swift
import UIKit

class ShapeViewBuilder {
  // 1
  var showFill  = true
  var fillColor = UIColor.orangeColor()

  // 2
  var showOutline  = true
  var outlineColor = UIColor.grayColor()

  // 3
  init(shapeViewFactory: ShapeViewFactory) {
    self.shapeViewFactory = shapeViewFactory
  }

  // 4
  func buildShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
    let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes)
    configureShapeView(shapeViews.0)
    configureShapeView(shapeViews.1)
    return shapeViews
  }

  // 5
  private func configureShapeView(shapeView: ShapeView) {
    shapeView.showFill  = showFill
    shapeView.fillColor = fillColor
    shapeView.showOutline  = showOutline
    shapeView.outlineColor = outlineColor
  }

  private var shapeViewFactory: ShapeViewFactory
}
```

Here’s how your new `ShapeViewBuilder` works:

1.  Store configuration to set `ShapeView` fill properties.

2.  Store configuration to set `ShapeView` outline properties.

3.  Initialize the builder to hold a `ShapeViewFactory` to construct the views. This means the builder doesn’t need to know if it’s building `SquareShapeView` or `CircleShapeView` or even some other kind of shape view.

4.  This is the public API; it creates and initializes a pair of `ShapeView` when there’s a pair of `Shape`.

5.  Do the actual configuration of a `ShapeView` based on the builder’s stored configuration.

Deploying your spiffy new `ShapeViewBuilder` is as easy as opening **GameViewController.swift** and adding the following code to the bottom of the class, just before the closing curly brace:

```swift
private var shapeViewBuilder: ShapeViewBuilder!
```

Now, populate your new property by adding the following code to `viewDidLoad` just above the line that invokes `beginNextTurn`:

```swift
shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
shapeViewBuilder.fillColor = UIColor.brownColor()
shapeViewBuilder.outlineColor = UIColor.orangeColor()
```

Finally replace the line that creates `shapeViews` in `beginNextTurn` with the following:

```swift
let shapeViews = shapeViewBuilder.buildShapeViewsForShapes(shapes)
```

Build and run, and you should see something like this:

[![Screenshot8](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot8-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot8.png)

Notice how your circles are now a pleasant brown with orange outlines — I know you must be amazed by the stunning design here, but please don’t try to hire me to be your interior decorator.

Now to reinforce the power of the Builder pattern. With `GameViewController.swift` still open, change your `viewDidLoad` to use square factories:

```swift
shapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
shapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
```

Build and run, and you should see this.

[![Screenshot9](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot9-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot9.png)

Notice how the Builder pattern made it easy to apply a new color scheme to squares as well as to circles. Without it, you’d need color configuration code in both `CircleShapeViewFactory` and `SquareShapeViewFactory`.

Furthermore, changing to another color scheme would involve widespread code changes. By restricting `ShapeView` color configuration to a single `ShapeViewBuilder`, you also isolate color changes to a single class.

## Design Pattern: Dependency Injection

Every time you tap a shape, you’re taking a turn in your game, and each turn can be a match or not a match.

Wouldn’t it be helpful if your game could track all the turns, stats and award point bonuses for hot streaks?

Create a new file called **Turn.swift**, and replace its contents with the following code:

```swift

class Turn {
  // 1
  let shapes: [Shape]
  var matched: Bool?

  init(shapes: [Shape]) {
    self.shapes = shapes
  }

  // 2
  func turnCompletedWithTappedShape(tappedShape: Shape) {
    var maxArea = shapes.reduce(0) { $0 > $1.area ? $0 : $1.area }
    matched = tappedShape.area >= maxArea
  }
}
```

Your new `Turn` class does the following:

1.  Store the shapes that the player saw during the turn, and also whether the turn was a match or not.

2.  Records the completion of a turn after a player taps a shape.

To control the sequence of turns your players play, create a new file named **TurnController.swift**, and replace its contents with the following code:

```swift

class TurnController {
  // 1
  var currentTurn: Turn?
  var pastTurns: [Turn] = [Turn]()

  // 2
  init(shapeFactory: ShapeFactory, shapeViewBuilder: ShapeViewBuilder) {
    self.shapeFactory = shapeFactory
    self.shapeViewBuilder = shapeViewBuilder
  }

  // 3
  func beginNewTurn() -> (ShapeView, ShapeView) {
    let shapes = shapeFactory.createShapes()
    let shapeViews = shapeViewBuilder.buildShapeViewsForShapes(shapes)
    currentTurn = Turn(shapes: [shapeViews.0.shape, shapeViews.1.shape])
    return shapeViews
  }

  // 4
  func endTurnWithTappedShape(tappedShape: Shape) -> Int {
    currentTurn!.turnCompletedWithTappedShape(tappedShape)
    pastTurns.append(currentTurn!)

    var scoreIncrement = currentTurn!.matched! ? 1 : -1

    return scoreIncrement
  }

  private let shapeFactory: ShapeFactory
  private var shapeViewBuilder: ShapeViewBuilder
}
```

Your `TurnController` works as follows:

1.  Stores both the current turn and past turns.

2.  Accepts a `ShapeFactory` and `ShapeViewBuilder`.

3.  Uses this factory and builder to create shapes and views for each new turn and records the current turn.

4.  Records the end of a turn after the player taps a shape, and returns the computed score based on whether the turn was a match or not.

Now open **GameViewController.swift**, and add the following code at the bottom, just above the closing curly brace:

```swift
private var turnController: TurnController!
```

Scroll up to `viewDidLoad`, and just before the line invoking `beginNewTurn`, insert the following code:

```swift
turnController = TurnController(shapeFactory: shapeFactory, shapeViewBuilder: shapeViewBuilder)
```

Replace `beginNextTurn` with the following:

```swift
private func beginNextTurn() {
  // 1
  let shapeViews = turnController.beginNewTurn()

  shapeViews.0.tapHandler = {
    tappedView in
    // 2
    self.gameView.score += self.turnController.endTurnWithTappedShape(tappedView.shape)
    self.beginNextTurn()
  }

  // 3
  shapeViews.1.tapHandler = shapeViews.0.tapHandler

  gameView.addShapeViews(shapeViews)
}
```

Your new code works as follows:

1.  Asks the `TurnController` to begin a new turn and return a tuple of `ShapeView` to use for the turn.

2.  Informs the turn controller that the turn is over when the player taps a `ShapeView`, and then it increments the score. Notice how `TurnController` abstracts score calculation away, further simplifying `GameViewController`.

3.  Since you removed explicit references to specific shapes, the second shape view can share the same `tapHandler` closure as the first shape view.

An example of the **Dependency Injection** design pattern is that it passes in its dependencies to the `TurnController` initializer. The initializer parameters essentially inject the shape and shape view factory dependencies.

Since `TurnController` makes no assumptions about which type of factories to use, you’re free to swap in different factories.

Not only does this make your game more flexible, but it makes automated testing easier since it allows you to pass in special `TestShapeFactory` and `TestShapeViewFactory` classes if you desire. These could be special stubs or mocks that would make testing easier, more reliable or faster.

Build and run and check that it looks like this:

[![Screenshot10](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot10-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot10.png)

There are no visual differences, but `TurnController` has opened up your code so it can use more sophisticated turn strategies: calculating scores based on streaks of turns, alternating shape type between turns, or even adjusting the difficulty of play based on the player’s performance.

## Design Pattern: Strategy

I’m happy because I’m eating a piece of pie while writing this tutorial. Perhaps that’s why it was imperative to add circles to the game. :\]

You should be happy because you’ve done a great job using design patterns to refactor your game code so that it’s easy to expand and maintain.

[![ragecomic3](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic3.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic3.png)

Speaking of pie, err, Pi, how do you get those circles back in your game? Right now your `GameViewController` can use **either** circles or squares, but only one or the other. It doesn’t have to be all restrictive like that.

Next, you’ll use the **Strategy** design pattern to manage which shapes your game produces.

The **Strategy** design pattern allows you to design algorithm behaviors based on what your program determines at runtime. In this case, the algorithm will choose which shapes to present to the player.

You can design many different algorithms: one that picks shapes randomly, one that picks shapes to challenge the player or help him be more successful, and so on. **Strategy** works by defining a family of algorithms through abstract declarations of the behavior that each strategy must implement. This makes the algorithms within the family interchangeable.

If you guessed that you’re going to implement the Strategy as a Swift `protocol`, you guessed correctly!

Create a new file named **TurnStrategy.swift**, and replace its contents with the following code:

```swift

// 1
protocol TurnStrategy {
  func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView)
}

// 2
class BasicTurnStrategy: TurnStrategy {
  let shapeFactory: ShapeFactory
  let shapeViewBuilder: ShapeViewBuilder

  init(shapeFactory: ShapeFactory, shapeViewBuilder: ShapeViewBuilder) {
    self.shapeFactory = shapeFactory
    self.shapeViewBuilder = shapeViewBuilder
  }

  func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView) {
    return shapeViewBuilder.buildShapeViewsForShapes(shapeFactory.createShapes())
  }
}

class RandomTurnStrategy: TurnStrategy {
  // 3
  let firstStrategy: TurnStrategy
  let secondStrategy: TurnStrategy

  init(firstStrategy: TurnStrategy, secondStrategy: TurnStrategy) {
    self.firstStrategy = firstStrategy
    self.secondStrategy = secondStrategy
  }

  // 4
  func makeShapeViewsForNextTurnGivenPastTurns(pastTurns: [Turn]) -> (ShapeView, ShapeView) {
    if Utils.randomBetweenLower(0.0, andUpper: 100.0) < 50.0 {
      return firstStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns)
    } else {
      return secondStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns)
    }
  }
}
```

Here's what your new `TurnStrategy` does line-by-line:

1.  Declare the behavior of the algorithm. This is defined in a protocol, with one method. The method takes an array of the past turns in the game, and returns the shape views to display for the next turn.

2.  Implement a basic strategy that uses a `ShapeFactory` and `ShapeViewBuilder`. This strategy implements the existing behavior, where the shape views just come from the single factory and builder as before. Notice how you're using **Dependency Injection** again here, and that means this strategy doesn't care which factory or builder it's using.

3.  Implement a random strategy which randomly uses one of two other strategies. You've used composition here so that `RandomTurnStrategy` can behave like two potentially different strategies. However, since it's a `Strategy`, that composition is hidden from whatever code uses `RandomTurnStrategy`.

4.  This is the meat of the random strategy. It randomly selects either the first or second strategy with a 50 percent chance.

Now you need to use your strategies. Open **TurnController.swift**, and replace its contents with the following:

```swift

class TurnController {
  var currentTurn: Turn?
  var pastTurns: [Turn] = [Turn]()

  // 1
  init(turnStrategy: TurnStrategy) {
    self.turnStrategy = turnStrategy
  }

  func beginNewTurn() -> (ShapeView, ShapeView) {
    // 2
    let shapeViews = turnStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns)
    currentTurn = Turn(shapes: [shapeViews.0.shape, shapeViews.1.shape])
    return shapeViews
  }

  func endTurnWithTappedShape(tappedShape: Shape) -> Int {
    currentTurn!.turnCompletedWithTappedShape(tappedShape)
    pastTurns.append(currentTurn!)

    var scoreIncrement = currentTurn!.matched! ? 1 : -1

    return scoreIncrement
  }

  private let turnStrategy: TurnStrategy
}
```

Here's what's happening, section by section:

1.  Accepts a passed strategy and stores it on the `TurnController` instance.

2.  Uses the strategy to generate the `ShapeView` objects so the player can begin a new turn.

> **Note:** This will cause a syntax error in **GameViewController.swift**. Don't worry, it's only temporary. You're going to fix the error in the very next step.

Your last step to use the **Strategy** design pattern is to adapt your `GameViewController` to use your `TurnStrategy`.

Open **GameViewController.swift** and replace its contents with the following:

```swift
import UIKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // 1
    let squareShapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
    let squareShapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    let squareShapeViewBuilder = shapeViewBuilderForFactory(squareShapeViewFactory)
    let squareTurnStrategy = BasicTurnStrategy(shapeFactory: squareShapeFactory, shapeViewBuilder: squareShapeViewBuilder)

    // 2
    let circleShapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
    let circleShapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
    let circleShapeViewBuilder = shapeViewBuilderForFactory(circleShapeViewFactory)
    let circleTurnStrategy = BasicTurnStrategy(shapeFactory: circleShapeFactory, shapeViewBuilder: circleShapeViewBuilder)

    // 3
    let randomTurnStrategy = RandomTurnStrategy(firstStrategy: squareTurnStrategy, secondStrategy: circleTurnStrategy)

    // 4
    turnController = TurnController(turnStrategy: randomTurnStrategy)

    beginNextTurn()
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  private func shapeViewBuilderForFactory(shapeViewFactory: ShapeViewFactory) -> ShapeViewBuilder {
    let shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
    shapeViewBuilder.fillColor = UIColor.brownColor()
    shapeViewBuilder.outlineColor = UIColor.orangeColor()
    return shapeViewBuilder
  }

  private func beginNextTurn() {
    let shapeViews = turnController.beginNewTurn()

    shapeViews.0.tapHandler = {
      tappedView in
      self.gameView.score += self.turnController.endTurnWithTappedShape(tappedView.shape)
      self.beginNextTurn()
    }
    shapeViews.1.tapHandler = shapeViews.0.tapHandler

    gameView.addShapeViews(shapeViews)
  }

  private var gameView: GameView { return view as! GameView }
  private var turnController: TurnController!
}
```

Your revised `GameViewController` uses `TurnStrategy` as follows:

1.  Create a strategy to create squares.

2.  Create a strategy to create circles.

3.  Create a strategy to randomly select either your square or circle strategy.

4.  Create your turn controller to use the random strategy.

Build and run, then go ahead and play five or six turns. You should see something similar to the following screenshots.

[![Screenshot111213**Animatedv2](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot111213**Animatedv2.gif)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot111213**Animatedv2.gif)

Notice how your game randomly alternates between square shapes and circle shapes. At this point, you could easily add a third shape like triangle or parallelogram and your `GameViewController` could use it simply by switching up the strategy.

## Design Patterns: Chain of Responsibility, Command and 迭代器

Think about the example at the beginning of this tutorial:

```swift
var collection = ...

// The for loop condition uses the 迭代器 design pattern
for item in collection {
  print("Item is: \(item)")
}
```

What is it that makes the `for item in collection` loop work? The answer is Swift's `SequenceType`.

By using the **迭代器** pattern in a `for ... in` loop, you can iterate over any type that conforms to the `SequenceType` protocol.

The built-in collection types `Array` and `Dictionary` already conform to `SequenceType`, so you generally don't need to think about `SequenceType` unless you code your own collections. Still, it's nice to know. :\]

Another design pattern that you'll often see used in conjunction with **迭代器** is the **Command** design pattern, which captures the notion of invoking a specific behavior on a target when asked.

For this tutorial, you'll use **Command** to determine if a `Turn` was a match, and compute your game's score from that.

Create a new file named **Scorer.swift**, and replace its contents with the following code:

```swift

// 1
protocol Scorer {
  func computeScoreIncrement<S: SequenceType where Turn == S.Generator.Element>(pastTurnsReversed: S) -> Int
}

// 2
class MatchScorer: Scorer {
  func computeScoreIncrement<S : SequenceType where Turn == S.Generator.Element>(pastTurnsReversed: S) -> Int {
    var scoreIncrement: Int?
    // 3
    for turn in pastTurnsReversed {
      if scoreIncrement == nil {
      	// 4
        scoreIncrement = turn.matched! ? 1 : -1
        break
      }
    }

    return scoreIncrement ?? 0
  }
}
```

Taking each section in turn:

1.  Define your **Command** type, and declare its behavior to accept a collection of past turns that you can iterate over using the **迭代器** design pattern.

2.  Declare a concrete implementation of `Scorer` that will score turns based on whether they matched or not.

3.  Use the **迭代器** design pattern to iterate over past turns.

4.  Compute the score as +1 for a matched turn and -1 for a non-matched turn.

Now open **TurnController.swift** and add the following line near the end, just before the closing brace:

```swift
private let scorer: Scorer
```

Then add the following line to the end of the initializer `init(turnStrategy:)`:

```swift
self.scorer = MatchScorer()
```

Finally, replace the line in `endTurnWithTappedShape` that declares and sets `scoreIncrement` with the following:

```swift
var scoreIncrement = scorer.computeScoreIncrement(pastTurns.reverse())=
```

Take note of how how you reverse `pastTurns` before passing it to the scorer because the scorer expects turns in reverse order (newest first), whereas `pastTurns` stores oldest-first (In other words, it appends newer turns to the end of the array).

Build and run your code. Did you notice something strange? I bet your scoring didn't change for some reason.

You need to make your scoring change by using the **Chain of Responsibility** design pattern.

The **Chain of Responsibility** design pattern captures the notion of dispatching multiple commands across a set of data. For this exercise, you'll dispatch different `Scorer` commands to compute your player's score in multiple additive ways.

For example, not only will you award +1 or -1 for matches or mismatches, but you'll also award bonus points for streaks of consecutive matches. **Chain of Responsibility** allows you add a second `Scorer` implementation in a manner that doesn't interrupt your existing scorer.

Open **Scorer.swift** and add the following line to the top of `MatchScorer`

```swift
var nextScorer: Scorer? = nil
```

Then add the following line to the end of the `Scorer` protocol:

```swift
var nextScorer: Scorer? { get set }
```

Now both `MatchScorer` and any other `Scorer` implementations declare that they implement the **Chain of Responsibility** pattern through their `nextScorer` property.

Replace the `return` statement in `computeScoreIncrement` with the following:

```swift
return (scoreIncrement ?? 0) + (nextScorer?.computeScoreIncrement(pastTurnsReversed) ?? 0)
```

Now you can add another `Scorer` to the chain after `MatchScorer`, and its score gets automatically added to the score computed by `MatchScorer`.

> **Note:** The `??` operator is Swift's **nil coalescing operator**. It unwraps an optional to its value if non-nil, else returns the other value if the optional is nil. Effectively, `a ?? b` is the same as `a != nil ? a! : b`. It's a nice shorthand and I encourage you to use it in your code.

To demonstrate this, open **Scorer.swift** and add the following code to the end of the file:

```swift
class StreakScorer: Scorer {
  var nextScorer: Scorer? = nil

  func computeScoreIncrement<S : SequenceType where Turn == S.Generator.Element>(pastTurnsReversed: S) -> Int {
    // 1
    var streakLength = 0
    for turn in pastTurnsReversed {
      if turn.matched! {
        // 2
        ++streakLength
      } else {
        // 3
        break
      }
    }

    // 4
    let streakBonus = streakLength >= 5 ? 10 : 0
    return streakBonus + (nextScorer?.computeScoreIncrement(pastTurnsReversed) ?? 0)
  }
}
```

Your nifty new `StreakScorer` works as follows:

1.  Track streak length as the number of consecutive turns with successful matches.

2.  If a turn is a match, the streak continues.

3.  If a turn is not a match, the streak is broken.

4.  Compute the streak bonus: 10 points for a streak of five or more consecutive matches!

To complete the **Chain of Responsibility** open **TurnController.swift** and add the following line to the end of the initializer `init(turnStrategy:)`:

```swift
self.scorer.nextScorer = StreakScorer()
```

Excellent, you're using **Chain of Responsibility**.

Build and run. After five successful matches in the first five turns you should see something like the following screenshot.

[![ScreenshotStreakAnimated](https://koenig-media.raywenderlich.com/uploads/2014/10/ScreenshotStreakAnimated.gif)](https://koenig-media.raywenderlich.com/uploads/2014/10/ScreenshotStreakAnimated.gif)

Notice how the score hits 15 after only 5 turns since 15 = 5 points for successful 5 matches + 10 points streak bonus.

## Where To Go From Here?

Here is the [final completed project](https://koenig-media.raywenderlich.com/uploads/2014/12/DesignPatternsInSwift**FinalCompleted.zip) for this tutorial.

You've taken a fun game, **Tap the Larger Shape** and used design patterns to add even more shapes and enhance their styling. You've also used design patterns to add more elaborate scoring.

Most remarkably, even though the final project has many more features, its code is actually simpler and more maintainable than what you started with.

Why not use these design patterns to extend your game even further? Some ideas follow.

**Add more shapes like triangle, parallelogram, star, etc**
Hint: Think back to how you added circles, and follow a similar sequence of steps to add new shapes. If you come up with some really cool shapes, please post screenshots of them in the comments at the bottom of this tutorial!

**Add an animation whenever the score changes**
Hint: Use the `didSet` property observer on `GameView.score`.

**Add controls so that players can choose which types of shapes the game uses**
Hint: Add three `UIButton` or a `UISegmentedControl` with three choices (Square, Circle, Mixed) in `GameView`, which should forward any target actions from the controls on to an **Observer** (Swift closure). `GameViewController` can use these closures to adjust which `TurnStrategy` it uses.

**Persist shape settings to preferences that you can restore**
Hint: Store the player's choice of shape type in `NSUserDefaults`. Try to use the **Facade** design pattern ([Facade details](http://en.wikipedia.org/wiki/Facade**pattern)) to hide your choice of persistence mechanism for this preference from the rest of your code.

**Allow players to select the color scheme for the game**
Hint: Use `NSUserDefaults` to persist the player's choice. Create a `ShapeViewBuilder` that can accept the persisted choice and adjust the app's UI accordingly. Could you use `NSNotificationCenter` to inform all interested views that the color scheme changed so that they can immediately update themselves?

**Have your game play a happy sound when a match occurs and a sad sound when a match fails**
Hint: Extend the **Observer** pattern used between `GameView` and `GameViewController`.

**Use Dependency Injection to pass in the Scorer to TurnController**
Hint: Remove the hard-coded dependency on `MatchScorer` and `StreakScorer` from the initializer.

Thank you for working through this tutorial! Please join the discussion below and share your questions, ideas and cool ways you kicked the game up a few notches.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
