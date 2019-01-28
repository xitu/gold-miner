> * 原文地址：[Intermediate Design Patterns in Swift](https://www.raywenderlich.com/2102-intermediate-design-patterns-in-swift)
> * 原文作者：[raywenderlich.com](https://www.raywenderlich.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/intermediate-design-patterns-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/intermediate-design-patterns-in-swift.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[swants](https://github.com/swants), [kirinzer](https://github.com/kirinzer)

# iOS 设计模式进阶

设计模式对于代码的维护和提高可读性非常有用，通过本教程你将学习 Swift 中的一些设计模式。

**更新说明**：本教程已由译者针对 iOS 12，Xcode 10 和 Swift 4.2 进行了更新。

**新手教程**：没了解过设计模式？来看看设计模式的 [入门教程](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-1-2.md) 来阅读之前的基础知识吧。

在本教程中，你将学习如何使用 Swift 中的设计模式来重构一个名为 **Tap the Larger Shape** 的游戏。

了解设计模式对于编写可维护且无 bug 的应用程序至关重要，了解何时采用何种设计模式是一项只能通过实践学习的技能。这本教程再好不过了！

但究竟什么是设计模式呢？这是一个针对常见问题的正式文档型解决方案。例如，考虑一下遍历一个集合，你在此处使用 **迭代器** 设计模式：

```swift
var collection = ...

// for 循环使用迭代器设计模式
for item in collection {
    print("Item is: \(item)")
}
```

**迭代器** 设计模式的价值在于它抽象出了访问集合中每一项的实际底层机制。无论 `collection` 是数组，字典还是其他类型，你的代码都可以用相同的方式访问它们中的每一项。

不仅如此，设计模式也是开发者文化的一部分，因此维护或扩展代码的另一个开发人员可能会理解迭代器设计模式，它们是用于推理出软件架构的语言。

在 iOS 编程中有很多设计模式频繁出现，例如 **MVC** 出现在几乎每个应用程序中，**代理** 是一个强大的，通常未被充分利用的模式，比如说你曾用过的 tableView，本教程讨论了一些鲜为人知但非常有用的设计模式。

如果你不熟悉设计模式的概念，此篇文章可能不适合现在的你，不妨先看一下 [使用 Swift 的 iOS 设计模式](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-1-2.md) 来开始吧。

## 入门

Tap the Larger Shape 是一个有趣但简单的游戏，你会看到一对相似的形状，你需要点击两者中较大的一个。如果你点击较大的形状，你会得到一分，反之你会失去一分。

看起来你好像只喷出了一些随机的方块、圆圈和三角形涂鸦，不过孩子们会买单的！:\]

下载 [入门项目](https://github.com/iWeslie/SwiftDesignPatterns) 并在 Xcode 中打开。

> **注意**：你需要使用 Xcode 10 和 Swift 4.2 及以上版本从而获得最大的兼容性和稳定性。

此入门项目包含完整游戏，你将在本教程中对改项目进行重构并利用一些设计模式来使你的游戏更易于维护并且更加有趣。

使用 iPhone 8 模拟器，编译并运行项目，随意点击几个图形来了解这个游戏的规则。你会看到如下图所示的内容：

[![Tap the larger shape and gain points.](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot2-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot2.png)

点击较大的图形就能得分。

[![Tap the smaller shape and lose points.](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot3-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot3.png)

点击较小的图形则会扣分。

## 理解这款游戏

在深入了解设计模式的细节之前，先看一下目前编写的游戏。打开 **Shape.swift** 看一看并找到以下代码，你无需进行任何更改，只需要看看就行：

```swift
import UIKit

class Shape {

}

class SquareShape: Shape {
	var sideLength: CGFloat!
}
```

`Shape` 类是游戏中可点击图形的基本模型。具体的一个子类 `SquareShape` 表示一个正方形：一个具有四条等长边的多边形。

接下来打开 **ShapeView.swift** 并查看 `ShapeView` 的代码：

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
	var fillColor: UIColor = UIColor.orange {
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
	var outlineColor: UIColor = UIColor.gray {
		didSet {
			setNeedsDisplay()
		}
	}

	// 3
	var tapHandler: ((ShapeView) -> ())?

	override init(frame: CGRect) {
		super.init(frame: frame)

		// 4
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
		addGestureRecognizer(tapRecognizer)
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func handleTap() {
		// 5
		tapHandler?(self)
	}

	let halfLineWidth: CGFloat = 3.0
}
```

`ShapeView` 是呈现通用 `Shape` 模型的 view。以下是其中代码的逐行解析：

1. 指明应用程序是否使用，并使用哪种颜色来填充图形，这是图形内部的颜色。

2. 指明应用程序是否使用，并使用哪种颜色来给图形描边，这是图形边框的颜色。

3. 一个处理点击事件的闭包（例如更新得分）。如果你不熟悉 Swift 闭包，可以在 [Swift 闭包](https://www.cnswift.org/closures) 中查看它们，但请记住它们与 Objective-C 里的 block 类似。

4. 设置一个 tap gesture recognizer，当玩家点击 view 时调用 `handleTap`。

5. 当检测到点击手势时调用 `tapHandler`。

现在向下滚动并且查看 `SquareShapeView`：

```swift
class SquareShapeView: ShapeView {
	override func draw(_ rect: CGRect) {
		super.draw(rect)

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

以下是 `SquareShapeView` 如何进行绘制的：

1. 如果配置为显示填充，则使用填充颜色填充 view。

2. 如果配置为显示轮廓，则使用轮廓颜色给 view 描边。

3. 由于 iOS 是以 position 为中心绘制线条的，因此我们在描边路径时需要将从 view 的 bounds 里减去 `halfLineWidth`。

很棒！现在你已经了解了这个游戏里的图形是如绘制的，打开 **GameViewController.swift** 并查看其中的逻辑：

```swift
import UIKit

class GameViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
        // 1
		beginNextTurn()
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	private func beginNextTurn() {
        // 2
		let shape1 = SquareShape()
		shape1.sideLength = Utils.randomBetweenLower(lower: 0.3, andUpper: 0.8)
		let shape2 = SquareShape()
		shape2.sideLength = Utils.randomBetweenLower(lower: 0.3, andUpper: 0.8)

        // 3
		let availSize = gameView.sizeAvailableForShapes()

        // 4
		let shapeView1: ShapeView = SquareShapeView(frame: CGRect(x: 0, y: 0, width: availSize.width * shape1.sideLength, height: availSize.height * shape1.sideLength))
		shapeView1.shape = shape1
		let shapeView2: ShapeView = SquareShapeView(frame: CGRect(x: 0, y: 0, width: availSize.width * shape2.sideLength, height: availSize.height * shape2.sideLength))
		shapeView2.shape = shape2

        // 5
		let shapeViews = (shapeView1, shapeView2)

        // 6
		shapeViews.0.tapHandler = { tappedView in
			self.gameView.score += shape1.sideLength >= shape2.sideLength ? 1 : -1
			self.beginNextTurn()
		}
		shapeViews.1.tapHandler = { tappedView in
			self.gameView.score += shape2.sideLength >= shape1.sideLength ? 1 : -1
			self.beginNextTurn()
		}

        // 7
		gameView.addShapeViews(newShapeViews: shapeViews)
	}

	private var gameView: GameView { return view as! GameView }
}
```

以下是游戏逻辑的工作原理：

1. 当 `GameView` 加载后开始新的一局。

2. 在 `[0.3, 0.8]` 区间内取边长绘制正方形，绘制的图形也可以在任何屏幕尺寸下缩放。

3. 由 `GameView` 确定哪种尺寸的图形适合当前屏幕。

4. 为每个形状创建一个 `SquareShapeView`，并通过将图形的 `sideLength` 比例乘以当前屏幕的相应 `availSize` 来调整形状的大小。

5. 将形状存储在元组中以便于操作。

6. 在每个 shape view 上设置点击事件并根据玩家是否点击较大的 view 来计算分数。

7. 将形状添加到 `GameView` 以便布局显示。

以上就是游戏的完整逻辑。是不是很简单？:\]

## 为什么要使用设计模式？

你可能想问自己：“嗯，所以当我有一个工作游戏时，为什么我需要设计模式呢？”那么如果你想支持除了正方形以外的形状又要怎么办呢？

你 **本可以** 在 `beginNextTurn` 中添加代码来创建第二个形状，但是当你添加第三种、第四种甚至第五种形状时，代码将变得难以管理。

如果你希望玩家能够选择别人的形状又要怎么办呢？

如果你把所有代码放在 `GameViewController` 中，你最终会得到难以管理的包含硬编码依赖的耦合度很高的代码。

以下是你的问题的答案：设计模式有助于将你的代码解耦成分离地很开的单位。

在进行下一步之前，我坦白，我已经偷偷地进入了一个设计模式。

[![ragecomic1](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic1-e1415029446968-480x268.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic1-e1415029446968.png)

现在，关于设计模式，以下的每个部分都描述了不同的设计模式。我们开始吧！

## 抽象工厂模式

`GameViewController` 与 `SquareShapeView` 紧密耦合，这将不能为以后使用不同的视图来表示正方形或引入第二个形状留出余地。

你的第一个任务是使用 **抽象工厂** 设计模式给你的`GameViewController` 进行简化和解耦。你将要在代码中使用此模式，该代码建立用于构造一组相关对象的API，例如你将暂时使用的 shape view，而无需对特定类进行硬编码。

新建一个 Swift 文件，命名为 **ShapeViewFactory.swift** 并保存，然后添加以下代码：

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

以下是你新的工厂的工作原理：

1. 将 `ShapeViewFactory` 定义为 Swift 协议，它没有理由成为一个类或结构体，因为它只描述了一个接口而本身并没有功能。

2. 每个工厂应当有一个定义了创建形状的边界的尺寸，这对使用工厂生成的 view 布局代码至关重要。

3. 定义生成形状视图的方法。这是工厂的“肉”，它需要两个 Shape 对象的元组，并返回两个 ShapeView 对象的元组。这基本上是从其原材料 — 模型中制造 view。

在 **ShapeViewFactory.swift** 的最后添加以下代码：

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
        let shapeView1 = SquareShapeView(frame: CGRect(
            x: 0,
            y: 0,
            width: squareShape1.sideLength * size.width,
            height: squareShape1.sideLength * size.height))
        shapeView1.shape = squareShape1

        // 3
        let squareShape2 = shapes.1 as! SquareShape
        let shapeView2 = SquareShapeView(frame: CGRect(
            x: 0,
            y: 0,
            width: squareShape2.sideLength * size.width,
            height: squareShape2.sideLength * size.height))
        shapeView2.shape = squareShape2

        // 4
        return (shapeView1, shapeView2)
    }
}
```

你的 `SquareShapeViewFactory` 建造了 `SquareShapeView` 实例，如下所示：

1. 使用一致的最大尺寸来初始化工厂。

2. 从第一个传递的形状构造第一个 shape view。

3. 从第二个传递的形状构造第二个 shape view。

4. 返回包含两个刚创建的 shape view 的元组。

最后，是时候使用 `SquareShapeViewFactory` 了。打开 **GameViewController.swift**，并全部替换为以下内容：

```swift
import UIKit

class GameViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
        // 1 ***** 附加
        shapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())

		beginNextTurn()
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	private func beginNextTurn() {
		let shape1 = SquareShape()
		shape1.sideLength = Utils.randomBetweenLower(lower: 0.3, andUpper: 0.8)
		let shape2 = SquareShape()
		shape2.sideLength = Utils.randomBetweenLower(lower: 0.3, andUpper: 0.8)

        // 2 ***** 附加
        let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes: (shape1, shape2))

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

        gameView.addShapeViews(newShapeViews: shapeViews)
	}

	private var gameView: GameView { return view as! GameView }

    // 3 ***** 附加
    private var shapeViewFactory: ShapeViewFactory!
}
```

这里有三行新代码：

1. 初始化并存储一个 `SquareShapeViewFactory`。

2. 使用此新工厂创建你的 shape view。

3. 将新的 shape view 工厂存储为实例属性。

主要的好处在于第二部分，其中你用一行替换了六行代码。更好的是，你将复杂的 shape view 的创建代码移出了 `GameViewController` 从而使类更小也更容易理解。

将 view 创建代码移出 controller 是很有帮助的，因为 `GameViewController` 充当 Controller 在 Model 和 View 之间进行协调。

编译并运行，然后你应该看到类似以下内容：

[![Screenshot4](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot4-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot4.png)

你游戏的视觉效果没有任何改变，但你确实简化了代码。

如果你用 `SomeOtherShapeView` 替换 `SquareShapeView`，那么 `SquareShapeViewFactory` 的好处就会大放异彩。具体来说，你不需要更改 `GameViewController`，你可以将所有更改分离到 `SquareShapeViewFactory`。

既然你已经简化了 shape view 的创建，那么你也同时可以简化 shape 的创建。像之前那样创建一个新的 Swift 文件，命名为 **ShapeFactory.swift**，并把以下代码粘贴进去：

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
        shape1.sideLength = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

        // 4
        let shape2 = SquareShape()
        shape2.sideLength = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

        // 5
        return (shape1, shape2)
    }
}
```

你的新 `ShapeFactory` 生产 shape 的具体步骤如下：

1. 再一次地，就像你对 `ShapeViewFactory` 所做的那样，将 `ShapeFactory` 声明为一个协议来获得最大的灵活性。

2. 你希望你的 shape 工厂生成具有单位尺寸的形状，例如，在 `[0, 1]` 的范围内，因此你要存储这个范围。

3. 创建具有随机尺寸的第一个方形。

4. 创建具有随机尺寸的第二个方形。

5. 将这对方形形状作为元组返回。

现在打开 **GameViewController.swift** 并在底部大括号结束之前的插入以下代码：

```swift
private var shapeFactory: ShapeFactory!
```

然后在 `viewDidLoad` 的底部 `beginNextTurn` 的调用之上插入以下代码：

```swift
shapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
```

最后把 `beginNextTurn` 替换为以下代码:

```swift
private func beginNextTurn() {
    // 1
    let shapes = shapeFactory.createShapes()

    let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes: shapes)

    shapeViews.0.tapHandler = { tappedView in
        // 2
        let square1 = shapes.0 as! SquareShape, square2 = shapes.1 as! SquareShape
        // 3
        self.gameView.score += square1.sideLength >= square2.sideLength ? 1 : -1
        self.beginNextTurn()
    }
    shapeViews.1.tapHandler = { tappedView in
        let square1 = shapes.0 as! SquareShape, square2 = shapes.1 as! SquareShape
        self.gameView.score += square2.sideLength >= square1.sideLength ? 1 : -1
        self.beginNextTurn()
    }

    gameView.addShapeViews(newShapeViews: shapeViews)
}
```

以下是上面代码的解析：

1. 使用新的 shape 工厂创建一个形状元组。

2. 从元组中提取形状。

3. 这样你就可以在这里比较它们了。

再一次使用 **抽象工厂** 设计模式，通过将创建形状的部分移出 `GameViewController` 来简化代码。

## 雇工模式

现在你甚至可以添加第二个形状，例如圆圈。你对正方形的唯一硬性依赖是下面 `beginNextTurn` 中的得分计算：

```swift
shapeViews.1.tapHandler = { tappedView in
    // 1
    let square1 = shapes.0 as! SquareShape, square2 = shapes.1 as! SquareShape

    // 2
    self.gameView.score += square2.sideLength >= square1.sideLength ? 1 : -1
    self.beginNextTurn()
}
```

在这里你把形状转换为 `SquareShape` 以便你可以访问它们的 `sideLength`，圆没有 `sideLength`，而是“直径”。

解决方案是使用 **雇工** 设计模式，它通过一个通用接口为一组类（如形状类）提供分数计算等方法。在你现在的情况下，分数计算是雇工，形状类作为服务对象，并且 `area` 属性扮演公共接口的角色。

打开 **Shape.swift** 并在 `Shape` 类的底部添加以下代码：

```swift
var area: CGFloat { return 0 }
```

然后在 `SquareShape` 类的底部添加以下代码:

```swift
override var area: CGFloat { return sideLength * sideLength }
```

现在你可以根据其面积来判断哪个形状更大。

打开 **GameViewController.swift** 并把 `beginNextTurn` 替换成以下内容：

```swift
private func beginNextTurn() {
    let shapes = shapeFactory.createShapes()

    let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes: shapes)

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

    gameView.addShapeViews(newShapeViews: shapeViews)
}
```

1. 根据形状区域确定较大的形状。

2. 还是根据形状区域确定较大的形状。

编译并运行，你应该看到类似下面的内容，虽然游戏看起来相同，但代码现在更灵活了。

[![Screenshot6](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot6-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot6.png)

恭喜，你已经从游戏逻辑中完全解除了对正方形的依赖关系，如果你要创建和使用一些圆形的工厂，你的游戏将变得更加完善。

[![ragecomic2](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic2.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic2.png)

## 利用抽象工厂实现游戏的多功能性

“不要做一个古板的人！”在现实生活中可能是一种侮辱，你的游戏感觉它被装在一个形状中，它渴望更流畅的线条和更多的符合空气动力学的形状。

你需要引入一些流畅的“善良的圆”，现在打开 **Shape.swift** 并在文件底部添加以下代码：

```swift
class CircleShape: Shape {
    var diameter: CGFloat!
    override var area: CGFloat { return CGFloat.pi * diameter * diameter / 4.0 }
}
```

你的圆只需要知道它可以计算自身面积的“直径”就可以支持 **雇工** 模式。

接下来通过添加 `CircleShapeFactory` 来构建 `CircleShape` 对象。打开 **ShapeFactory.swift** 并在文件底部添加以下代码：

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
		shape1.diameter = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

		// 2
		let shape2 = CircleShape()
		shape2.diameter = Utils.randomBetweenLower(lower: minProportion, andUpper: maxProportion)

		return (shape1, shape2)
	}
}
```

这段代码遵循一个熟悉的模式：**第1部分** 和 **第2部分** 创建了一个 `CircleShape` 并为其指定一个随机的 `diameter`。

你需要解决另一个问题，这样做可能会防止一个混乱的几何图形的革命。看吧，你现在拥有的是 “没有代表性的几何图形”，你知道当形状不足时，形状会变得多么干净哈！

取悦你的玩家很容易，你需要的只是用 `CircleShapeView` 在屏幕上 **绘制** 你的新 `CircleShape` 对象。:\]

打开 `ShapeView.swift` 并在文件底部添加以下内容：

```swift
class CircleShapeView: ShapeView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		// 1
		self.isOpaque = false
		// 2
		self.contentMode = UIView.ContentMode.redraw
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)

		if showFill {
			fillColor.setFill()
			// 3
			let fillPath = UIBezierPath(ovalIn: self.bounds)
			fillPath.fill()
		}

		if showOutline {
			outlineColor.setStroke()
			// 4
			let outlinePath = UIBezierPath(ovalIn: CGRect(
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

对上述内容的解释依次为以下几个部分：

1. 由于圆无法填充其 view 的 bounds，因此你需要告诉 **UIKit** 该 view 是透明的，这意味着能透过它看到背后的东西。如果你没有意识到这点，那么这个圆将会有一个丑陋的黑色背景。

2. 由于视图是透明的，因此应在 bounds 更改时进行重绘。

3. 画一个用 `fillColor` 填充的圆圈。稍后，你将创建 `CircleShapeViewFactory`，它会确保 `CircleView` 具有相等的宽度和高度，因此画出来的形状将是圆形而不是椭圆形。

4. 给圆用 lineWidth 进行描边。

现在你将在 `CircleShapeViewFactory` 中创建` CircleShapeView` 对象。

打开 **ShapeViewFactory.swift** 并在文件的底部添加以下代码：

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

这是将创建圆而不是正方形的工厂。**第1部分** 和 **第2部分** 使用传入的形状创建 `CircleShapeView` 实例。请注意你的代码是如何确保圆圈具有相同的宽度和高度，因此它们呈现为完美的圆形而不是椭圆形。

最后，打开 **GameViewController.swift** 并替换 `viewDidLoad` 中对应的两行，用以下内容分配形状和视图工厂：

```swift
shapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
shapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
```

现在编译并运行项目，你应该看到类似下面的截图。

[![Screenshot7](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot7-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot7.png)
瞧，你造出了圆形！

请注意你是如何在 `GameViewController` 中添加新形状而不会对游戏逻辑产生太大影响的，抽象工厂和雇工设计模式使之成为可能。

## 建造者模式

现在是时候来看看第三种设计模式了：**建造者**。

假设你想要改变 `ShapeView` 实例的外观 - 例如它们是否应显示，以及用什么颜色来填充和描边。 **建造者** 设计模式使这种对象的配置变得更加容易和灵活。

解决此配置问题的一种方法是添加各种构造函数，可以使用诸如 `CircleShapeView.redFilledCircleWithBlueOutline()` 之类的类便利初始化方法，也可以添加具有各种参数和默认值的初始化方法。

然而不幸的是，它不是一种可扩展的技术，因为你需要为每种组合编写新方法或初始化程序。

建造者非常优雅地解决了这个问题，因为它创建了一个具有单一用途的类来配置已经初始化的对象。如果你将让建造者来构建红色的圆，然后再构建蓝色的圆，则无需更改 `CircleShapeView` 就可达到目的。

创建一个新文件 **ShapeViewBuilder.swift** 并添加以下代码：

```swift
import UIKit

class ShapeViewBuilder {
	// 1
	var showFill  = true
	var fillColor = UIColor.orange

	// 2
	var showOutline  = true
	var outlineColor = UIColor.gray

	// 3
	init(shapeViewFactory: ShapeViewFactory) {
		self.shapeViewFactory = shapeViewFactory
	}

	// 4
	func buildShapeViewsForShapes(shapes: (Shape, Shape)) -> (ShapeView, ShapeView) {
		let shapeViews = shapeViewFactory.makeShapeViewsForShapes(shapes: shapes)
		configureShapeView(shapeView: shapeViews.0)
		configureShapeView(shapeView: shapeViews.1)
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

以下是你的新的 `ShapeViewBuilder` 的工作原理：

1. 存储配置 `ShapeView` 的填充属性。

2. 存储配置 `ShapeView` 的描边属性。

3. 初始化建造者来持有 `ShapeViewFactory` 从而构造 view。这意味着建造者并不需要知道它是来建造 `SquareShapeView` 还是 `CircleShapeView` 抑或是其他形状的 view。

4. 这是公共 API，当有一对 `Shape` 时，它会创建并初始化一对 `ShapeView`。

5. 根据建造者的存储了的配置来对 `ShapeView` 进行配置。

现在来部署你新的 `ShapeViewBuilder`，打开 **GameViewController.swift**，在大括号结束之前将以下代码添加到类的底部：

```swift
private var shapeViewBuilder: ShapeViewBuilder!
```

现在在 `viewDidLoad` 里 `beginNextTurn` 调用的上方添加以下代码来填充新属性：

```swift
shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
shapeViewBuilder.fillColor = UIColor.brown
shapeViewBuilder.outlineColor = UIColor.orange
```

最后用以下代码替换 `beginNextTurn` 中创建 `shapeViews` 的那一行：

```swift
let shapeViews = shapeViewBuilder.buildShapeViewsForShapes(shapes: shapes)
```

编译并运行，你将看到以下内容：

[![Screenshot8](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot8-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot8.png)

说实话我也觉得填充颜色很丑，但是先别吐槽，毕竟我们目前关注点不在于它是有多么好看。

现在来强化建造者的力量。还是在 `GameViewController.swift` 里，将 `viewDidLoad` 对应的两行更改为使用方形工厂：

```swift
shapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
shapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
```

编译并运行，你将看到以下内容：

[![Screenshot9](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot9-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot9.png)

注意建造者模式是如何使新的颜色方案来应用到正方形和圆形上的。没有它的话你需要在 `CircleShapeViewFactory` 和 `SquareShapeViewFactory` 中来单独设置颜色。

此外，更改为另一种配色方案将涉及大量代码的修改。通过将 `ShapeView` 颜色配置限制为单个 `ShapeViewBuilder`，你还可以将颜色更改隔离到单个类。

## 依赖注入模式

每次点击一个形状，你都会进行一个回合，每回合的结果可以是得分或者减分。

如果你的游戏可以自动跟踪所有回合，统计数据和得分，那会不会有帮助呢？

创建一个名为 **Turn.swift** 的新文件，并使用以下代码替换其内容：

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
        let maxArea = shapes.reduce(0) { $0 > $1.area ? $0 : $1.area }
        matched = tappedShape.area >= maxArea
    }
}
```

你的新 `Turn` 类做了以下事情：

1. 存储玩家每一回合看到的形状，以及是否点击了较大的形状。

2. 在玩家点击形状后记录该回合已经结束。

要控制玩家玩的回合顺序，请创建一个名为 **TurnController.swift** 的新文件，并使用以下代码替换其内容：

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
        let shapeViews = shapeViewBuilder.buildShapeViewsForShapes(shapes: shapes)
        currentTurn = Turn(shapes: [shapeViews.0.shape, shapeViews.1.shape])
        return shapeViews
    }

    // 4
    func endTurnWithTappedShape(tappedShape: Shape) -> Int {
        currentTurn!.turnCompletedWithTappedShape(tappedShape: tappedShape)
        pastTurns.append(currentTurn!)

        let scoreIncrement = currentTurn!.matched! ? 1 : -1

        return scoreIncrement
    }

    private let shapeFactory: ShapeFactory
    private var shapeViewBuilder: ShapeViewBuilder
}
```

你的 `TurnController` 工作原理如下：

1. 存储当前和过去的回合。

2. 接收一个 `ShapeFactory` 和一个 `ShapeViewBuilder`。

3. 使用此工厂和建造者为每个新的回合创建形状和视图，并记录当前回合。

4. 在玩家点击形状后记录回合结束，并根据该回合玩家点击的形状计算得分。

现在打开 **GameViewController.swift**，并在底部大括号上方添加以下代码：

```swift
private var turnController: TurnController!
```

向上滚动到 `viewDidLoad`，在调用 `beginNewTurn` 这行之前，插入以下代码：

```swift
turnController = TurnController(shapeFactory: shapeFactory, shapeViewBuilder: shapeViewBuilder)
```

用以下代码替换 `beginNextTurn`：

```swift
private func beginNextTurn() {
    // 1
    let shapeViews = turnController.beginNewTurn()

    shapeViews.0.tapHandler = {
        tappedView in
        // 2
        self.gameView.score += self.turnController.endTurnWithTappedShape(tappedShape: tappedView.shape)
        self.beginNextTurn()
    }

    // 3
    shapeViews.1.tapHandler = shapeViews.0.tapHandler

    gameView.addShapeViews(newShapeViews: shapeViews)
}
```

你的新代码的工作原理如下：

1. 让 `TurnController` 开始一个新的回合并返回一个 `ShapeView` 元组用于回合。

2. 当玩家点击 `ShapeView` 时，通知控制器回合结束，然后计算得分。请注意 `TurnController` 是如何把得分计算的过程抽象出来并进一步简化 `GameViewController`。

3. 由于你移除了对特定形状的显式引用，因此第二个形状视图可以与第一个形状视图共享相同的 `tapHandler` 闭包。

**依赖注入** 设计模式的一个实例应用是它将其依赖项传递给 `TurnController` 初始化器，初始化器的参数主要是要注入的形状和工厂的依赖项。

由于 `TurnController` 没有假定使用哪种类型的工厂，因此你可以自由地在不同的工厂间进行交换。

这不仅使你的游戏更加灵活，还让自动化测试变得更容易了。如果你想的话，它允许你向特殊的 `TestShapeFactory` 和 `TestShapeViewFactory` 类传递参数。这些可能是特殊的存根或模拟，可以使测试更容易、更可靠并且更快速。

Build and run and check that it looks like this:编译并运行，你会看到如下图：

[![Screenshot10](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot10-180x320.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot10.png)

界面好像没什么变化，但是 `TurnController` 已经开放了你的代码，所以它可以使用更复杂的回合机制：根据回合计算得分然后在每一回合之间选择性的改变形状，甚至根据玩家的表现调整比赛难度。

## 策略模式

我现在特别高兴因为我在写这个教程时正在吃一块派，也许这就是为什么我们在游戏中要添加圆形了哈。:\]

你应该感到高兴，因为你在使用设计模式重构游戏代码方面做得很好，游戏因此变得很容易扩展和维护。

[![ragecomic3](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic3.png)](https://koenig-media.raywenderlich.com/uploads/2014/10/ragecomic3.png)

说到派，呃，Pi，你要怎么把这些圆形放回游戏中呢？现在你的 `GameViewController` 可以使用 **圆或正方形**，但只能使用其中一个。并不一定都要限制的死死的。

接下来你将使用 **策略** 模式来管理游戏里的形状。

**策略** 设计模式允许你根据程序在运行时确定的内容来设计算法。在这种情况下，算法将选择向玩家呈现什么样的形状。

你可以设计许多不同的算法：一种是随机选择形状，一种是挑选形状来给玩家一点挑战或者帮助他获胜更多，等等！**策略** 通过对每个策略必须实现的行为的抽象声明来定义一系列算法，这使得该族内的算法可以互换。

如果你猜想你将会把策略作为一个 Swift `protocol` 来实现，那你就猜对了！

Create a new file named **TurnStrategy.swift**, and replace its contents with the following code:创建一个名为 **TurnStrategy.swift** 的新文件，并使用以下代码替换其内容：

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
        return shapeViewBuilder.buildShapeViewsForShapes(shapes: shapeFactory.createShapes())
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
        if Utils.randomBetweenLower(lower: 0.0, andUpper: 100.0) < 50.0 {
            return firstStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns: pastTurns)
        } else {
            return secondStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns: pastTurns)
        }
    }
}
```

以下是你的新的 `TurnStrategy` 进行的操作：

1. 这是在一个协议中定义的一个抽象方法，该方法获取游戏中上一个回合的数组，并返回形状视图来显示下一回合。

2. 实现一个使用 `ShapeFactory` 和 `ShapeViewBuilder` 的基本策略，此策略实现了现有行为，其中形状视图与以前一样来自单个工厂和建造者。请注意你在此处再次使用 **依赖注入**，这意味着此策略不关心它使用的是哪一个工厂或建造者。

3. 随机使用其他两种策略之一来实施随机策略。你在这里使用了组合，因此 `RandomTurnStrategy` 可以表现得像两个可能不同的策略。但是由于它是一个 `策略`，所以任何使用 `RandomTurnStrategy` 的代码都隐藏了该组合。

4. 这是随机策略的核心。它以 50％ 的概率随机选择第一种或第二种策略。

现在你需要使用你的策略。打开 **TurnController.swift** 并用以下内容替换：

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
        let shapeViews = turnStrategy.makeShapeViewsForNextTurnGivenPastTurns(pastTurns: pastTurns)
        currentTurn = Turn(shapes: [shapeViews.0.shape, shapeViews.1.shape])
        return shapeViews
    }

    func endTurnWithTappedShape(tappedShape: Shape) -> Int {
        currentTurn!.turnCompletedWithTappedShape(tappedShape: tappedShape)
        pastTurns.append(currentTurn!)

        let scoreIncrement = currentTurn!.matched! ? 1 : -1

        return scoreIncrement
    }

    private let turnStrategy: TurnStrategy
}
```

以下是详细步骤：

1. 接收传递的策略并将其存储在 `TurnController` 实例中。

2. 使用策略生成 `ShapeView` 对象，以便玩家可以开始新的回合。

> **注意：** 这将会导致 **GameViewController.swift** 中出现语法错误。但是别担心，这只是暂时的，你将在下一步中修复错误。

使用 **策略** 设计模式的最后一步是调整你的 `GameViewController` 从而来使用你的 `TurnStrategy`。

打开 **GameViewController.swift** 并用以下内容替换：

```swift
import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1
        let squareShapeViewFactory = SquareShapeViewFactory(size: gameView.sizeAvailableForShapes())
        let squareShapeFactory = SquareShapeFactory(minProportion: 0.3, maxProportion: 0.8)
        let squareShapeViewBuilder = shapeViewBuilderForFactory(shapeViewFactory: squareShapeViewFactory)
        let squareTurnStrategy = BasicTurnStrategy(shapeFactory: squareShapeFactory, shapeViewBuilder: squareShapeViewBuilder)

        // 2
        let circleShapeViewFactory = CircleShapeViewFactory(size: gameView.sizeAvailableForShapes())
        let circleShapeFactory = CircleShapeFactory(minProportion: 0.3, maxProportion: 0.8)
        let circleShapeViewBuilder = shapeViewBuilderForFactory(shapeViewFactory: circleShapeViewFactory)
        let circleTurnStrategy = BasicTurnStrategy(shapeFactory: circleShapeFactory, shapeViewBuilder: circleShapeViewBuilder)

        // 3
        let randomTurnStrategy = RandomTurnStrategy(firstStrategy: squareTurnStrategy, secondStrategy: circleTurnStrategy)

        // 4
        turnController = TurnController(turnStrategy: randomTurnStrategy)

        beginNextTurn()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func shapeViewBuilderForFactory(shapeViewFactory: ShapeViewFactory) -> ShapeViewBuilder {
        let shapeViewBuilder = ShapeViewBuilder(shapeViewFactory: shapeViewFactory)
        shapeViewBuilder.fillColor = UIColor.brown
        shapeViewBuilder.outlineColor = UIColor.orange
        return shapeViewBuilder
    }

    private func beginNextTurn() {
        let shapeViews = turnController.beginNewTurn()

        shapeViews.0.tapHandler = {
            tappedView in
            self.gameView.score += self.turnController.endTurnWithTappedShape(tappedShape: tappedView.shape)
            self.beginNextTurn()
        }
        shapeViews.1.tapHandler = shapeViews.0.tapHandler

        gameView.addShapeViews(newShapeViews: shapeViews)
    }

    private var gameView: GameView { return view as! GameView }
    private var turnController: TurnController!
}
```

你修改后的 `GameViewController` 使用 `TurnStrategy` 的详细步骤如下：

1. 创建一个策略来创建正方形。

2. 创建一个策略来创建圆形。

3. 创建策略来随机选择是使用正方形还是圆形策略。

4. 创建回合控制器来使用随机策略。

编译并运行，然后玩五到六轮，你应该看到类似于以下的内容。

[![Screenshot111213**Animatedv2](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot111213_Animatedv2.gif)](https://koenig-media.raywenderlich.com/uploads/2014/10/Screenshot111213_Animatedv2.gif)

请注意你的游戏是如何在正方形和圆形之间随机交替的。此时你可以轻松地添加第三个形状来，如三角形或平行四边形，你的 `GameViewController` 可以通过切换策略来使用它。

## 责任链，命令和迭代器模式

考虑一下本教程开头的示例：

```swift
var collection = ...

// for 循环使用迭代器设计模式
for item in collection {
    print("Item is: \(item)")
}
```

是什么使得 `for item in collection` 这个循环工作的呢？答案是 Swift 的 `SequenceType`。

通过在 `for ... in` 循环中使用 **迭代器** 模式，你可以迭代任何遵循 `SequenceType` 协议的类型。

内置的集合类型 `Array` 和 `Dictionary` 是遵循 `SequenceType` 的，因此除非你要编写自己的集合，否则通常不需要考虑 `SequenceType` 。不过我仍然很高兴了解这个模式。:\]

你经常看到的与 **迭代器** 结合使用的另一种设计模式是 **命令** 模式，它会捕获在被询问时在目标上调用特定行为的概念。

在本教程中你将使用 **命令** 来确定一个 `回合` 的胜负并计算游戏的分数。

创建一个名为 **Scorer.swift** 的新文件，并使用以下代码替换：

```swift
// 1
protocol Scorer {
    func computeScoreIncrement<S>(_ pastTurnsReversed: S) -> Int where S : Sequence, Turn == S.Iterator.Element
}

// 2
class MatchScorer: Scorer {
    func computeScoreIncrement<S>(_ pastTurnsReversed: S) -> Int where S : Sequence, S.Element == Turn {
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

依次来看看每一步：

1. 定义你的 **命令** 类型并声明它的行为让它接收一个你可以用 **迭代器** 来迭代的过去所有回合的集合。

2. 一个 `Scorer` 的具体实现，根据它们是否获胜来计算得分。

3. 使用 **迭代器** 迭代过去的回合。

4. 将获胜回合的得分计为 +1，输掉的回合得分为 -1。

现在打开 **TurnController.swift** 并在类的最底部添加以下代码：

```swift
private var scorer: Scorer
```

然后将以下代码添加到初始化器 `init(turnStrategy:)` 的末尾：

```swift
self.scorer = MatchScorer()
```

Finally, replace the line in `endTurnWithTappedShape` that declares and sets `scoreIncrement` with the following:最后把 `endTurnWithTappedShape` 里 `scoreIncrement` 的声明替换为：

```swift
let scoreIncrement = scorer.computeScoreIncrement(pastTurns.reversed())
```

注意你将在计算得分之前反转 `pastTurns`，因为计算得分的顺序和回合进行的顺序相反，而 `pastTurns` 存储着最开始的回合，换句话说就是我们将在数组的最后 append 最新的回合。

编译并运行项目，你注意到一些奇怪的事了吗？我打赌你的得分因某种原因没有改变。

你需要使用 **责任链** 模式来改变你的得分。

**责任链** 模式会捕获跨一组数据​​调度多个命令的概念。在本练习中，你将发送不同的 `Scorer` 命令来以多种附加方式计算你的玩家得分。

例如你不仅会为比赛的胜负加或减一分，而且还会为连续比赛的连胜获得奖励分。**责任链** 允许你以不会打断现有记分员的方式添加第二个 `Scorer` 的实现。

打开 **Scorer.swift** 并在 `MatchScorer` 里的最上方添加以下代码：

```swift
var nextScorer: Scorer? = nil
```

然后在 `Scorer` 协议的最后添加:

```swift
var nextScorer: Scorer? { get set }
```

现在 `MatchScorer` 和其他所有的 `Scorer` 都表明它们通过 `nextScorer` 属性实现了 **责任链** 模式。

在 `computeScoreIncrement` 里用以下代码替换 `return` 语句:

```swift
return (scoreIncrement ?? 0) + (nextScorer?.computeScoreIncrement(pastTurnsReversed) ?? 0)
```

现在你可以在 `MatchScorer` 之后向链中添加另一个 `Scorer` 并将其得分自动添加到 `MatchScorer` 计算的分数中。

> **注意：**`??` 运算符是 Swift 的 **合并空值运算符**。如果可选值非 nil 则将其值展开，如果可选值为 nil 则返回 ?? 后的另一个值。实际上 `a ?? b` 与 `a != nil ? a! : b` 一样。这是一个很好的速记，我们鼓励你在你的代码中使用它。

要来演示这一点，请打开 **Scorer.swift** 并将以下代码添加到文件末尾：

```swift
class StreakScorer: Scorer {
    var nextScorer: Scorer? = nil

    func computeScoreIncrement<S>(_ pastTurnsReversed: S) -> Int where S : Sequence, S.Element == Turn {
        // 1
        var streakLength = 0
        for turn in pastTurnsReversed {
            if turn.matched! {
                // 2
                streakLength += 1
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

你漂亮的新的 `StreakScorer` 工作原理如下：

1. 连续获胜的次数。

2. 如果该回合获胜，则连续次数加一。

3. 如果该回合输了，则连续获胜次数清零。

4. 计算连胜奖励，连胜 5 场或更多场奖励 10 分！

要完成 **责任链** 模式，打开 **TurnController.swift** 并将以下行添加到初始化器 `init(turnStrategy:)` 的末尾：

```swift
self.scorer.nextScorer = StreakScorer()
```

很好，现在你正在使用 **责任链**。

编译并运行，在前五个回合都获胜的情况下，你应该看到如下截图。

[![ScreenshotStreakAnimated](https://koenig-media.raywenderlich.com/uploads/2014/10/ScreenshotStreakAnimated.gif)](https://koenig-media.raywenderlich.com/uploads/2014/10/ScreenshotStreakAnimated.gif)

请注意分数是如何从 5 一下子变成 16 的，因为连胜五局，计算奖励分 10 分和第六局获得的 1 分所以一共是 16 分。

## 接下来该干嘛？

这里是本次教程的 [最终项目](http://iweslie.com/code/SwiftDesignPatterns.zip)。

你玩了一个有趣的游戏 **Tap the Larger Shape** 并使用设计模式来添加更多的形状以及增强其样式，你还使用了设计模式来更精确地计算得分。

最值得注意的是，即使最终项目具有更多功能，其代码实际上比你开始时更简单且更易于维护。

为什么不使用这些设计模式进来一步扩展你的游戏呢？可以尝试一下下面的想法。

**添加更多形状，如三角形、平行四边形、星形等**
提示：回想一下如何添加圆形，并按照类似的步骤顺序添加新形状。如果你想出一些非常酷的形状，你也可以自己尝试一下！

**添加分数变化时的动画**
提示：在 `GameView.score` 上使用 `didSet`。

**添加控件来让玩家选择游戏使用的形状类型**
提示：在 `GameView` 中添加三个 `UIButton` 或一个带有 Square、Circle 和 Mixed 三个选项的 `UISegmentedControl`，它们应该将控件上的任何点击事件通过闭包转发给 **观察者**。`GameViewController` 可以使用这些闭包来调整它使用的 `TurnStrategy`。

**将形状设置保留为可以恢复的首选项**
提示：将玩家选择的形状类型存储在 `UserDefaults` 中。尝试使用一下 **外观** 模式（[详细说明](http://en.wikipedia.org/wiki/Facade_pattern)）来隐藏你对其他人的持久性机制的选择。

**允许玩家选择游戏的配色方案**
提示：使用 `UserDefaults` 来持久化存储玩家的选择。创建一个可以接受持久选择并相应地调整应用程序的 UI 的 `ShapeViewBuilder`。当配色方案更改时，你是否可以使用 `NotificationCenter` 来通知所有相关的 view 来作出相应的更新呢？

**每当玩家获胜时发出庆祝的铃声，失败时发出悲伤的铃声**
提示：扩展 `GameView` 和 `GameViewController` 之间使用的 **观察者** 模式。

**使用依赖注入将 Scorer 传递给 TurnController**
提示：从初始化器中移除对 `MatchScorer` 和 `StreakScorer` 的引用。

感谢你完成本教程！你可以在评论区分享你的问题和想法以及提升游戏逼格的方法。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
