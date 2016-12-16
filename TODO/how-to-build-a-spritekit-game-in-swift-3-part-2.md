
> * 原文地址：[ How To Build A SpriteKit Game In Swift 3 (Part 2) ](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-2/ )
* 原文作者：[ Marc Vandehey ]( https://www.smashingmagazine.com/author/marcvandehey/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[ZiXYu](https://github.com/ZiXYu)
* 校对者：

## [ 如何在 Swift 3 中用 SpriteKit 框架编写游戏 (Part 2)](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-2/)  ##

你是否曾经想过要创建一个  [SpriteKit](https://developer.apple.com/spritekit/)[1](#1) 游戏？碰撞检测看起来像是个令人生畏的任务吗？你想知道如何正确的处理音效和背景音乐吗？自从 SpriteKit 推出以来，在 iOS 上的游戏制作从未看起来如此简单过。本文中，我们将探索 SpriteKit 的基础使用。

如果你错过了[之前的课程](https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/)[2](#2)，你可以通过获取[ Github 上的代码](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one)[3](#3)来赶上进度。请记住，本教程需要使用 Xcode 8 和 Swift 3。

[![Raincat: Lesson 2](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt.png)[4](#4)

RainCat, 第二课

在 [上一课](https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/)[5](#5)， 我们创建了地板和背景，随机生成了雨滴并添加了雨伞。这把雨伞的精灵(译者注：sprite，中文译名精灵，在游戏开发中，精灵指的是以图像方式呈现在屏幕上的一个图像)中存在一个自定义的 `SKPhysicsBody`，是通过 `CGPath` 来生成的，同时我们启用了触摸检测，因此我们可以在屏幕范围内移动它。我们使用了 `categoryBitMask` 和 `contactTestBitMask` 来链接了碰撞检测。我们移除了当雨滴落到任何物体上时的碰撞，因此它们不会堆积起来，而是在一次弹跳后穿过地板。最后，我们设置了一个世界的边框来移除所有和它接触的 `SKNode`。

本文中，我们将重点实现以下几点：

- 生成猫
- 实现猫的碰撞
- 生成食物
- 实现食物的碰撞
- 将猫移向食物
- 创建猫的动画
- 当猫接触雨滴时，使猫受到伤害
- 添加音效和背景音乐

### 重新获取资源

你可以从 [GitHub](https://github.com/thirteen23/RainCat/blob/smashing-day-2/dayTwoAssets.zip)[6](#6) (ZIP) 上获取本课所需要的资源。下载图片后，通过一次性拖拽所有图片将它们添加到你的 `Assets.xcassets` 文件中。你现在应该有了包含猫动画和宠物碗的资源文件。我们之后将会添加音效和背景音乐文件。

[![App 资源](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt-1.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png)[7](#7)


一大堆资源！ ([查看源版本](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png)[8](#8))

### 猫猫时间！ 

我们从添加游戏主角开始本期课程。我们首先在 “Sprites” 组下创建一个新文件，命名为 `CatSprite`。

更新 `CatSprite.swift` 中的代码如下：

```
import SpriteKit

public class CatSprite : SKSpriteNode {
  public static func newInstance() -> CatSprite {
    let catSprite = CatSprite(imageNamed: "cat_one")

    catSprite.zPosition = 5
    catSprite.physicsBody = SKPhysicsBody(circleOfRadius: catSprite.size.width / 2)

    return catSprite
  }

  public func update(deltaTime : TimeInterval) {

  }
}
```

我们已经使用了一个会返回猫精灵的静态初始化器来处理这些文件。我们也同样处理了另一个 `update` 函数。如果我们需要更新更多的精灵，我们应该尝试把这个函数变成一个[协议](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html)[9](#9)的一部分来让我们的精灵能够符合要求。这里需要注意一点，对于猫精灵，我们使用了一个圆形的 `SKPhysicsBody`。我们可以使用纹理来创建猫的物理实体，就像我们创建雨滴一样，但是这是一个“艺术”的决定。当猫被雨滴打中时， 与其让猫始终坐着，让猫痛苦地打滚显然更有趣一些。

当猫接触雨滴或猫掉出该世界时，我们将需要回调函数来处理这些事件。我们可以打开 `Constants.swift` 文件，将下列代码加入该文件，使它作为一个 `CatCategory`：

```
let CatCategory      : UInt32 = 0x1 << 4
```

上面代码中定义的变量将决定猫的身体是哪个 `SKPhysicsBody` 。让我们重新打开 `CatSprite.swift` 来更新猫精灵，使它包含 `categoryBitMask` 和 `contactTestBitMask`。 在 `newInstance()` 返回 `catSprite` 之前，我们需要添加如下代码：

```
catSprite.physicsBody?.categoryBitMask = CatCategory
catSprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldCategory
```

现在，当猫被雨滴击中或者当猫跌出世界时，我们将会得到一个回调。在添加了如上代码后，我们需要将猫添加到场景中。

在 `GameScene.swift` 文件的顶部, 初始化了 `umbrellaSprite` 之后， 我们需要添加如下代码:

```
private var catNode : CatSprite!
```

我们可以立刻在 `sceneDidLoad()` 里创建一只猫，但是我们更想要从一个单独的函数中来创建猫对象，以便于代码重用。感叹号(`!`)告诉编译器，它并不需要在 `init` 语句中立即初始化，而且它应该不会是 `nil`。我们这么做有两个理由。首先，我们不想单独为了一个变量创建 `init()` 语句。其次，我们并不想立刻初始化它，只要在我们第一次运行 `spawnCat()` 时重新初始化和定位猫对象就可以了。我们也可以用 optional(`?`) 来定义该变量，但是当我们第一次运行了 `spawnCat()` 函数后，我们的猫精灵就再也不会变成 `nil` 了。为了解决初始化问题和让我们头疼的拆包，我们会说使用感叹号来进行自动拆包是安全的操作。如果我们在初始化我们的猫对象前就使用了它，我们的应用就会闪退，因为我们告诉我们的应用对我们的猫对象进行拆包是安全的，然而并不是。我们需要在使用它之前初始化它，但是是在合适的函数中。

接下来，我们将要在 `GameScene.swift` 文件中新建一个 `spawnCat()` 函数来初始化我们的猫精灵。我们会把这个初始化的部分拆分到一个单独的函数中，使这部分代码具有重用性，同时保证在一个场景中一次只可能存在一只猫。

在这个文件中接近底部的地方，我们的 `spawnRaindrop()` 函数后面添加如下代码：

```
func spawnCat() {
  if let currentCat = catNode, children.contains(currentCat) {
    catNode.removeFromParent()
    catNode.removeAllActions()
    catNode.physicsBody = nil
  }

  catNode = CatSprite.newInstance()
  catNode.position = CGPoint(x: umbrellaNode.position.x, y: umbrellaNode.position.y - 30)

  addChild(catNode)
}
```

纵观这段函数，我们首先检查了猫对象是否为空。然后，我们确定了这个场景中是否存在一个猫对象。如果这个场景内存在一只猫，我们就要从父类中移除它，移除它现在正在进行的所有操作，并清除这个猫对象的 `SKPhysicsBody` 。这些操作仅仅会在猫掉出该世界时被触发。在这之后，我们会重新初始化一个新的猫对象，同时设定它的初始位置为伞下 30 像素的地方。其实我们可以在任何位置初始化我们的猫对象，但是我想这个位置总比直接从天空中把猫丢下来更好。

最后，在 `sceneDidLoad()` 函数中，在我们定位并添加了雨伞之后，调用 `spawnCat()` 函数：

```
umbrellaNode.zPosition = 4
addChild(umbrellaNode)

spawnCat()
```

现在我们可以运行我们的应用并且欢呼啦！

[![应用资源](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png)[10](#10)

猫 ([查看源文件](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png)[11](#11))

如果现在猫走出了雨伞并且碰到了雨滴，它将会在地上打滚。这时候，猫可能会滚出屏幕然后在接触世界边框的一瞬间被删除掉，那么，我们就需要重新生成猫对象了。因为现在回调函数会在当猫接触到雨滴时或猫掉出世界时被触发，所以我们可以在 `didBegin(_ contact:)` 函数中来处理这个碰撞事件。

我们想要在猫触碰到雨滴后和触碰世界边框后触发不同的事件，所以我们把这些逻辑拆分到了一个新的函数中。在 `GameScene.swift` 文件的底部， `didBegin(_ contact:)` 函数的后面，加上如下代码：

```
func handleCatCollision(contact: SKPhysicsContact) {
  var otherBody : SKPhysicsBody

  if contact.bodyA.categoryBitMask == CatCategory {
    otherBody = contact.bodyB
  } else {
    otherBody = contact.bodyA
  }

  switch otherBody.categoryBitMask {
  case RainDropCategory:
    print("rain hit the cat")
  case WorldCategory:
    spawnCat()
  default:
    print("Something hit the cat")
  }
}
```

在这段代码中，我们在寻找除了猫以外的物理实体。一旦我们获取到了另外的实体对象，我们需要判断是什么触碰了猫。现在，如果是雨滴击中了猫，我们只在控制台中输出这个碰撞发生了，而如果是猫触碰了这个游戏世界的边缘，我们就会重新生成一个猫对象。

我们需要在有触碰发生猫对象上时调用这个函数。那么，让我们用如下代码来更新 `didBegin(_ contact:)` 函数：

```
func didBegin(_ contact: SKPhysicsContact) {
  if (contact.bodyA.categoryBitMask == RainDropCategory) {
    contact.bodyA.node?.physicsBody?.collisionBitMask = 0
  } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
    contact.bodyB.node?.physicsBody?.collisionBitMask = 0
  }

  if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
    handleCatCollision(contact: contact)

    return
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

我们在移除雨滴碰撞和移除离屏指针中间插入了一个条件判断。这个 `if` 语句判断了碰撞物体是不是猫，然后我们在 `handleCatCollision(contact:)` 函数中处理猫的行为。

我们现在可以用雨伞把猫推出屏幕来测试猫的重生函数了。猫现在将会在伞下重新被定义出来。请注意，如果雨伞的底部低于地板，那么猫就会一直从屏幕中掉出去。到现在为止这并不是什么大问题，但是我们之后会提供一个方法来解决它。

### 生成食物

现在看来，是时候生成一些食物来喂我们的小猫了。当然了，现在猫并不能自己移动，不过我们一会可以修复这个问题。在创建食物精灵之前，我们可以先在 `Constants.swift` 文件中为食物新建一个类。让我们在 `CatCategory` 中添加如下代码：

```
let FoodCategory     : UInt32 = 0x1 << 5
```

上面代码中定义的变量将决定食物的物理对象是哪个 `SKPhysicsBody` 。在 “Sprites” 组中，我们用创建 `CatSprite.swift` 文件图片同样的方法新建一个名为 `FoodSprite.swift` 的文件，并在该文件中添加如下代码：

```
import SpriteKit

public class FoodSprite : SKSpriteNode {
  public static func newInstance() -> FoodSprite {
    let foodDish = FoodSprite(imageNamed: "food_dish")

    foodDish.physicsBody = SKPhysicsBody(rectangleOf: foodDish.size)
    foodDish.physicsBody?.categoryBitMask = FoodCategory
    foodDish.physicsBody?.contactTestBitMask = WorldCategory | RainDropCategory | CatCategory
    foodDish.zPosition = 5

    return foodDish
  }
}
```

这是一个静态的类，当它被调用时，将会初始化一个 `FoodSprite` 并且返回它。我们把食物的物理实体设置为一个和食物精灵同样大小的矩形。这种处理很好，因为食物精灵本身就是一个矩形。接下来，我们把物理对象的种类设置为我们刚刚创建的 `FoodCategory` ，然后把它添加到它可能会碰撞的对象（世界边框，雨滴和猫）中。我们把食物和猫的 `zPosition` 设置成相同的，它们将永远不会重叠，因为当它们相遇时，食物就会被删除然后用户将会得到一分。

重新打开 `GameScene.swift` 文件，我们需要添加一些功能来生成和移除食物。在这个文件的顶部，`rainDropSpawnRate` 变量的下面，我们添加如下代码：

```
private let foodEdgeMargin : CGFloat = 75.0
```

这个变量将会作为生成食物时的外边距。我们不想将食物生成在离屏幕两侧特别近的位置。我们把这个值定义在文件的顶部，这样如果我们之后可能要改变这个值的时候就不用搜索整个文档了。接下来，在我们的 `spawnCat()` 函数下面，我们可以新增我们的 `spawnFood` 函数了。

```
func spawnFood() {
  let food = FoodSprite.newInstance()
  var randomPosition : CGFloat = CGFloat(arc4random())
  randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2)
  randomPosition += foodEdgeMargin

  food.position = CGPoint(x: randomPosition, y: size.height)

  addChild(food)
}
```

这个函数和我们的 `spawnRaindrop()` 函数几乎一模一样。我们新建了一个 `FoodSprite`，然后把它放在了屏幕上一个随机的位置 `x`。我们用了之前设定的外边距变量来限制了能够生成食物精灵的屏幕范围。首先，我们设置了随机的位置的范围为屏幕的宽度减去 2 乘以外边距。然后，我们用外边距来偏移起始位置。这使得食物不会生成在距屏幕边界 0 到 75 的任意位置。

在 `sceneDidLoad()` 文件接近顶部的位置，让我们在 `spawnCat()` 函数的初始化调用下面加上如下代码：

```
spawnCat()
spawnFood()
```

现在当场景加载时，我们会生成一把雨伞，雨伞下一只猫，还有一些从天上掉下来的雨滴和食物。现在雨滴可以和猫互动，还可以让它来回滚动。对于雨伞和地板，食物将和雨滴有一样的碰撞效果，反弹一次然后失去所有的碰撞属性，直到触碰到世界边界后被删除。我们也同样需要添加一些食物和猫的互动。

在 `GameScene.swift` 文件的底部，我们将添加所有有关于食物碰撞的代码。让我们在 `handleCatCollision()` 函数后添加如下代码：

```
func handleFoodHit(contact: SKPhysicsContact) {
  var otherBody : SKPhysicsBody
  var foodBody : SKPhysicsBody

  if(contact.bodyA.categoryBitMask == FoodCategory) {
    otherBody = contact.bodyB
    foodBody = contact.bodyA
  } else {
    otherBody = contact.bodyA
    foodBody = contact.bodyB
  }

  switch otherBody.categoryBitMask {
  case CatCategory:
    //TODO increment points
    print("fed cat")
    fallthrough
  case WorldCategory:
    foodBody.node?.removeFromParent()
    foodBody.node?.physicsBody = nil

    spawnFood()
  default:
    print("something else touched the food")
  }
}
```

在这个函数中，我们将用和处理猫的碰撞同样的方式来处理食物的碰撞。首先，我们定义了食物的物理实体，然后我们运行了一个 `switch` 语句来判断除食物之外的物理实体。接下来，我们为 `CatCategory` 创建一个新的分支语句 - 这是个预留的接口，我们之后可以来更新我们的代码。接下来我们 `fallthrough` 到 `WorldFrameCategory` 分支语句，这里我们需要从场景里移除食物精灵和它的物理实体。最后，我们需要重新生成食物。当食物触碰到了世界边界，我们只需要移除食物精灵和它的物理实体。如果食物触碰到了其它物理实体，那么 default 分支语句就会被触发然后在控制台打印一个通用语句。现在，唯一能触发这个语句的物理实体就是 `RainDropCategory`。而到现在为止，我们并不关心当雨击中食物时会发生什么。我们只希望雨滴和食物在击中地板或雨伞时有同样的表现。

为了让所有部分连接起来，我们将在 `didBegin(_ contact)` 函数中添加几行代码。在判断 `CatCategory` 之前添加如下代码：

```
if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
  handleFoodHit(contact: contact)
  return
}
```

`didBegin(_ contact)` 最后应该看起来像下面这个代码片段：

```
func didBegin(_ contact: SKPhysicsContact) {
  if (contact.bodyA.categoryBitMask == RainDropCategory) {
    contact.bodyA.node?.physicsBody?.collisionBitMask = 0
  } else if (contact.bodyB.categoryBitMask == RainDropCategory) {
    contact.bodyB.node?.physicsBody?.collisionBitMask = 0
  }

  if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
    handleFoodHit(contact: contact)

    return
  }

  if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
    handleCatCollision(contact: contact)

    return
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

我们再次运行我们的应用。猫现在还不会自己跑来跑去，但是我们可以通过把食物推出屏幕边界或把猫移动到食物上来测试我们的函数。两个情况都会删除食物节点，而其中一个情况则会从屏幕外重新生成食物。

### 让物理实体动起来吧

现在是时候让我们的小猫动起来了。是什么驱使了小猫移动呢？当然是食物啦！我们刚刚生成了食物，那么现在我们就需要让小猫向着食物移动啦。 现在我们的食物精灵被添加到了场景中，然后就被遗忘了。我们需要修正这个问题。如果我们能够保留食物的引用，我们就可以知道它在任何时候的位置，这样我们就可以告诉小猫食物在场景的哪个位置了。小猫可以通过检查自己的坐标来了解自己在场景中的哪个位置。有了这些位置信息，我们就可以让小猫向着食物移动了。

重新打开 `GameScene.swift` 文件，让我们在文件的顶部，猫变量的下面添加一个变量：

```
private var foodNode : FoodSprite!
```

现在我们可以更新 `spawnFood()` 函数，使每次食物生成时都会设置这个变量的值：

用如下代码更新 `spawnFood()` 函数：

```
func spawnFood() {
  if let currentFood = foodNode, children.contains(currentFood) {
    foodNode.removeFromParent()
    foodNode.removeAllActions()
    foodNode.physicsBody = nil
  }

  foodNode = FoodSprite.newInstance()
  var randomPosition : CGFloat = CGFloat(arc4random())
  randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2)
  randomPosition += foodEdgeMargin

  foodNode.position = CGPoint(x: randomPosition, y: size.height)

  addChild(foodNode)
}
```

这个函数将把食物变量的作用域从 `spawnFood()` 函数变为整个 `GameScene.swift` 文件。在我们的代码中，同一时间我们只会生成一个 `FoodSprite`，同时我们需要保持对它的引用。因为有这个引用，我们就可以检测到在任何给定时间里食物的位置了。同样的，在任何时间场景内也只会有一只猫，同样我们也需要保持对它的引用。

我们知道小猫想要获得食物，我们只需要提供一个方法让小猫能够移动。我们需要编辑 `CatSprite.swift` 文件以便我们知道小猫需要往哪个方向前进来获取食物。为了让小猫获得食物，我们还需要知道小猫的移动速度。在 `CatSprite.swift` 文件的顶部，我们可以在 `newInstance()` 函数前添加如下代码：

```
private let movementSpeed : CGFloat = 100
```

这一行代码定义了猫的移动速度，这是对一个复杂问题的简单解法。这是个简单的线性方程，忽略了所有摩擦和加速带来的复杂性。

现在我们需要在我们的 `update(deltaTime:)` 方法中做点什么了。因为我们已经知道了食物的位置，我们需要让小猫朝着这个位置移动了。用如下代码更新 `CatSprite.swift` 文件中的 update 函数：

```
public func update(deltaTime : TimeInterval, foodLocation: CGPoint) {
  if foodLocation.x < position.x {
    //Food is left
    position.x -= movementSpeed * CGFloat(deltaTime)
    xScale = -1
  } else {
    //Food is right
    position.x += movementSpeed * CGFloat(deltaTime)
    xScale = 1
  }
}
```

我们更新了这个函数的函数签名。因为我们需要告诉小猫食物的位置，所以在传参时，我们不仅传递了 delta 时间，也传递了食物的位置信息。因为很多事情可以影响食物的位置，所以我们需要不停地更新食物的位置信息，以保证小猫一直在正确的方向上前进。接下来，让我们来看一下函数的功能。在这个更新过的函数中，我们取的 delta 时间是一个非常短的时间，大约只有 0.166 秒左右。我们也取了食物的位置，是 `CGPoint` 类型的参数。如果食物的 `x` 位置比小猫的 `x` 位置更小，那么我们就知道食物在小猫的左边，反之，食物就在小猫的上边或右边。如果小猫朝左边移动，那么我们取小猫的 `x` 位置减去小猫的移动速度乘以 delta 时间。我们需要把 delta 时间的类型从 `TimeInterval` 转换到 `CGFloat`，因为我们的位置和速度变量用的是这个单位，而 Swift 恰恰是一种强类型语言。

What this does exactly is nudge the cat left at a pretty constant rate to make it appear as if it is moving. In case the delta time is 0.166 seconds, we position the cat sprite 16.6 units to the left of its previous location. This is because our `movementSpeed` variable is 100, and 0.166 × 100 = 16.6. The same will happen when going right, except that we position the cat 16.6 units to the right of its previous location. Next, we edit the [xScale](https://developer.apple.com/reference/spritekit/sknode/1483087-xscale)[12](#12) property of our cat. This governs the width of our sprite. The default value is 1.0; so, if we set the `xScale` to 0.5, the cat will be half its original width. If we double it to 2.0, then the cat will be double its original width, and so on. Because the original sprite is looking to the right, when moving right, the scale will be set to its default value of 1. If we want to “flip” the cat, we set the scale to -1, which sets its frame to a negative value and renders it backwards. We keep it at -1 to maintain the proportions of the cat. Now, when moving left, the cat will face left, and when moving right, will face right!
What this does exactly is nudge the cat left at a pretty constant rate to make it appear as if it is moving. In case the delta time is 0.166 seconds, we position the cat sprite 16.6 units to the left of its previous location. This is because our `movementSpeed` variable is 100, and 0.166 × 100 = 16.6. The same will happen when going right, except that we position the cat 16.6 units to the right of its previous location. Next, we edit the [xScale](https://developer.apple.com/reference/spritekit/sknode/1483087-xscale)[12](#12) property of our cat. This governs the width of our sprite. The default value is 1.0; so, if we set the `xScale` to 0.5, the cat will be half its original width. If we double it to 2.0, then the cat will be double its original width, and so on. Because the original sprite is looking to the right, when moving right, the scale will be set to its default value of 1. If we want to “flip” the cat, we set the scale to -1, which sets its frame to a negative value and renders it backwards. We keep it at -1 to maintain the proportions of the cat. Now, when moving left, the cat will face left, and when moving right, will face right!

Now we will move toward the food dish’s location at a constant rate of speed. First, we check which direction to move in, then we move in that direction on the x-axis. We should also update the `xScale`, because we want to face the correct direction while moving… unless, of course, we want our cat to do the moonwalk! Finally, we need to tell the cat to update in our game scene.

打开 `GameScene.swift` 文件，找到我们的 `update(_ currentTime:)` 函数，在更新雨伞的调用下面，新增如下代码：

```
catNode.update(deltaTime: dt, foodLocation: foodNode.position)
```

Run the app, and we should have success! Mostly, at least. Currently, the cat does indeed move toward the food, but it can get into some interesting situations.

Just a normal cat doing normal cat things

Next, we can add the walking animation! After that, we’ll circle back to fix the cat’s rotation after it gets hit. You may have noticed an unused asset named `cat_two`. We need to pull this texture in and alternate it to make it appear as if the cat is walking. To do this, we will add our first `SKAction`!

### Walking With Style 

At the top of `CatSprite.swift`, we will add in a string constant so that we can add a walking action associated with this key. This way, we can stop the walking action without removing all of the actions that we may have on the cat later on. Add the following line above the `movementSpeed` variable:

```
private let walkingActionKey = "action_walking"
```

The string itself is not really important, but it is unique to this walking animation. I also like adding something meaningful to the key for debugging purposes down the line. For example, if I see the key, I will know that it is a `SKAction` and, specifically, that it is the walking action.

Beneath the `walkingActionKey`, we will add in the frames. Because we will be using only two frames, we can do this at the top of the file without it looking messy:

```
private let walkFrames = [
  SKTexture(imageNamed: "cat_one"),
  SKTexture(imageNamed: "cat_two")
]
```

This is just an array of the two textures that we will switch between while walking. To finish this off, we will update our `update(deltaTime: foodLocation:)` function to the following code:

```
public func update(deltaTime : TimeInterval, foodLocation: CGPoint) {
  if action(forKey: walkingActionKey) == nil {
    let walkingAction = SKAction.repeatForever(
      SKAction.animate(with: walkFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true))

    run(walkingAction, withKey:walkingActionKey)
  }

  if foodLocation.x < position.x {
    //Food is left
    position.x -= movementSpeed * CGFloat(deltaTime)
    xScale = -1
  } else {
    //Food is right
    position.x += movementSpeed * CGFloat(deltaTime)
    xScale = 1
  }
}
```

With this update, we’ve checked whether our cat sprite is already running the walking animation sequence. If it is not, we will add an action to the sprite. This is a nested `SKAction`. First, we create an action that will repeat forever. Then, in *that* action, we create the animation sequence for walking. The `SKAction.animate(with: …)` takes in the array of animation frames, along with the time per frame. The next variable in the function checks whether one of the textures is of a different size and whether it should resize the `SKSpriteNode` when it gets to that frame. `Restore` checks whether the sprite should return to its initial state after the action is completed. We set both of these to `false` so that we don’t get any unintended side effects. After we set up the walking action, we tell the sprite to start running it with the `run()` function.

Run the app again, and we will see our cat walking intently toward the food!

Yeah, on the catwalk, on the catwalk, yeah I do my little turn on the catwalk.

If the cat gets hit, it will rotate but still move toward the food. We need to show a damaged state for the cat, so that the user knows they did something bad. Also, we need to correct the cat’s rotation while moving, so that it is not walking on its side or upside down.

Let’s go over the plan. We want to show the user that the cat has been hit, other than by just updating the score later on. Some games will make the unit invulnerable while flashing. We could also do a damage animation if we get the textures for this. For this game, I want to keep things simple, so I will add in some functionality for “flailing.” This cat, when hit by rain, will become stunned and just sort of roll onto its back in disbelief; the cat will be *shocked* that you would let this happen. To accomplish this, we will set up a few variables. We need to know for how long the cat will be stunned and for how long it has been stunned. Add the following lines to the top of the file, below the `movementSpeed` variable:

```
private var timeSinceLastHit : TimeInterval = 2
private let maxFlailTime : TimeInterval = 2
```

The first variable, `timeSinceLastHit` holds how long it has been since the cat was hit last. We set it to `2` because of the next variable, `maxFlailTime`. This is a constant, saying that the cat will be stunned for only 2 seconds. Both are set to 2 so that the cat does not start out stunned when spawned. You can play with these variables later to get the perfect stun time.

Now we need to add in a function to let the cat know it’s been hit, and that it needs to react, by stopping moving. Add the following function below our `update(deltaTime: foodLocation:)` function:

```
public func hitByRain() {
  timeSinceLastHit = 0
  removeAction(forKey: walkingActionKey)
}
```

This just updates the `timeSinceLastHit` to `0`, and removes the walking animation that we set up earlier. Now we need to overhaul `update(deltaTime: foodLocation:)`, so that the cat doesn’t move while it is stunned. Update the function to the following:

```
public func update(deltaTime : TimeInterval, foodLocation: CGPoint) {
  timeSinceLastHit += deltaTime

  if timeSinceLastHit >= maxFlailTime {
    if action(forKey: walkingActionKey) == nil {
      let walkingAction = SKAction.repeatForever(
        SKAction.animate(with: walkFrames,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: true))

      run(walkingAction, withKey:walkingActionKey)
    }

    if foodLocation.x < position.x {
      //Food is left
      position.x -= movementSpeed * CGFloat(deltaTime)
      xScale = -1
    } else {
      //Food is right
      position.x += movementSpeed * CGFloat(deltaTime)
      xScale = 1
    }
  }
}
```

Now, our `timeSinceLastHit` will constantly be updated, and if the cat hasn’t been hit in the past 2 seconds, it will walk toward the food. If our walking animation isn’t set, then we’ll set it correctly. This is a frame-based animation that just swaps out the texture every 0.1 seconds to make it appear as though the cat is walking. It looks exactly like how real cats walk, doesn’t it?

We need to move over to `GameScene.swift` to tell the cat that it has been hit. In `handleCatCollision(contact:)`, we will call the `hitByRain` function. In the `switch` statement, look for the `RainDropCategory` and replace this…

```
print("rain hit the cat")
```

… with this:

```
catNode.hitByRain()
```

If we run the app now, the cat will be stunned for 2 seconds once rain touches it!

It works, but the cat seems to get into a rotated state and looks funny. Also, it looks like the rain really hurts — maybe we need to do something about that.

For the raindrop problem, we can make a slight tweak to its `physicsBody`. Under `spawnRaindrop` and below where we initialize `physicsBody`, we can add the following line:

```
raindrop.physicsBody?.density = 0.5
```

This will halve the density of the raindrop from its normal value of `1.0`. This will launch the cat a little less.

Moving to `CatSprite.swift`, we can correct the rotation of the cat with an `SKAction`. Add the following to the `update(deltaTime: foodLocation:)` function. Make sure that it is inside the `if` statement that checks whether the cat is flailing.

Find this line:

```
if timeSinceLastHit >= maxFlailTime {
```

And add the following code to correct the angular rotation:

```
if zRotation != 0 && action(forKey: "action_rotate") == nil {
  run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
}
```

This block of code checks whether the cat is rotated, even in the slightest. Then, we check currently running `SKAction`s to see whether we are already animating the cat to its standing position. If the cat is rotated and not animating, we run an action to rotate it back to 0 radians. Note that we are hardcoding the key here, because we currently don’t need to use this key outside of this spot. In the future, if we need to check the animation of our rotation in another function or class, we would make a constant at the top of the file, exactly like the `walkingActionKey`.

Run the app, and you will see the magic happen: Cat gets hit, cat probably rotates, cat fixes itself, cat is then happy to eat more. There are still two problems, though. Because we are using a circle for the cat’s `physicsBody`, after the cat corrects itself the first time, you might notice that the cat gets jittery. It is constantly rotating and correcting itself. To get around this, we need to reset the `angularVelocity`. Basically, the cat is rotating from getting hit, and we’ve never corrected the velocity that was added. The cat also does not update its velocity after being hit. If the cat is hit and tries to move in the opposite direction, you might notice that it goes slower than normal. The other problem is when the food is directly above the cat. The cat will quickly turn around endlessly while the food is above it. We can fix these issues by updating our `update(deltaTime :, foodLocation:)` function to the following:

```
public func update(deltaTime : TimeInterval, foodLocation: CGPoint) {
  timeSinceLastHit += deltaTime

  if timeSinceLastHit >= maxFlailTime {
    if action(forKey: walkingActionKey) == nil {
      let walkingAction = SKAction.repeatForever(
        SKAction.animate(with: walkFrames,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: true))

      run(walkingAction, withKey:walkingActionKey)
    }

      if zRotation != 0 && action(forKey: "action_rotate") == nil {
        run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
      }

      //Stand still if the food is above the cat.
      if foodLocation.y > position.y && abs(foodLocation.x - position.x) < 2 {
        physicsBody?.velocity.dx = 0
        removeAction(forKey: walkingActionKey)
        texture = walkFrames[1]
      } else if foodLocation.x < position.x {
        //Food is left
        physicsBody?.velocity.dx = -movementSpeed
        xScale = -1
      } else {
        //Food is right
        physicsBody?.velocity.dx = movementSpeed
        xScale = 1
      }

    physicsBody?.angularVelocity = 0
  }
}
```

Run the app yet again, and much of the herky-jerky action will be corrected. Not only that, but the cat will now stand still when the food is directly above it.

### Now Add Sound 

Before we start the programming, we should look into finding sound effects. Generally, when looking for sound effects, I just search for a phrase like “cat meow royalty free.” The first hit is usually [SoundBible.com](http://soundbible.com/tags-cat-meow.html)[13](#13), which generally has a good selection of royalty-free sound effects. Make sure to read the licenses. If you plan to never release the app, then pay no concern to licensing, since the app is for personal use. However, if you wish to sell this in the App Store, distribute it or the like, then make sure to attach a Creative Commons Attribution 3.0 licence or something similar. A lot of licenses are out there, so find out what the license is for a sound or image before using someone else’s work.

All of these RainCat sound effects are Creative Commons-licensed and are free to use. For the next step, move the `SFX` folder that we downloaded earlier into the `RainCat` folder.

[![Finder mode activated](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png)[14](#14)

Add in your sound effects to the file system. ([View large version](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png)[15](#15))

After you add the files to the project, add them to your project in Xcode. Create a group under “Support” named “SFX.” Right-click on the group and click “Add Files to RainCat…”

[![Adding in sound effects](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-SFX-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-SFX-preview-opt.png)[16](#16)

Adding in your sound effects

Find your “SFX” folder, select all of your sound-effect files, and click the “Add” button. Now you have sound effects to play with. Moving to `CatSprite.swift`, we can add in an array of the sound-effect file names so that we can play them on the hit of a raindrop. Add the following array below the `walkFrames` variable up at the top of the file:

```
private let meowSFX = [
  "cat_meow_1.mp3",
  "cat_meow_2.mp3",
  "cat_meow_3.mp3",
  "cat_meow_4.mp3",
  "cat_meow_5.wav",
  "cat_meow_6.wav"
]
```

We can have the cat make sounds by adding two lines to the `hitByRain` function:

```
let selectedSFX = Int(arc4random_uniform(UInt32(meowSFX.count)))
run(SKAction.playSoundFileNamed(meowSFX[selectedSFX], waitForCompletion: true))
```

The code above selects a random number, with the minimum being `0` and maximum being the size of the `meowSFX` array. Then, we pick the sound effect’s name from the string array and play the sound file. We will get to the `waitForCompletion` variable in a bit. Also, we’ll use `SKAction.playSoundFileNamed` for our short-and-sweet sound effects.

And we have sound! Too much sound! We have sounds playing over other sounds. Right now, we’re playing one of the sound effects every time the cat gets hit by rain. This gets annoying fast. We need to add more logic around when to play the sound, and we also shouldn’t play two clips at the same time.

Add these variables to the top of the `CatSprite.swift` file, below the `maxFlailTime` variable:
```
private var currentRainHits = 4
private let maxRainHits = 4

```

The first variable, `currentRainHits`, is a counter for how many times the cat has been hit, and `maxRainHits` is the number of hits it will take before meowing.

Now we will update the `hitByRain` function. We need to apply the rules for `currentRainHits` and `maxRainHits`. Replace the `hitByRain` function with the following:

```
public func hitByRain() {
  timeSinceLastHit = 0
  removeAction(forKey: walkingActionKey)

  //Determine if we should meow or not
  if(currentRainHits < maxRainHits) {
    currentRainHits += 1

    return
  }

  if action(forKey: "action_sound_effect") == nil {
    currentRainHits = 0

    let selectedSFX = Int(arc4random_uniform(UInt32(meowSFX.count)))

    run(SKAction.playSoundFileNamed(meowSFX[selectedSFX], waitForCompletion: true),
          withKey: "action_sound_effect")
  }
}
```

Now, if the `currentRainHits` is less than the maximum, we just increment the `currentRainHits` and return before we play the sound effect. Then, we check whether we are currently playing the sound effect by the key we provided: `action_sound_effect`. If we are not running the action, then we select a random sound effect to play. We set `waitForCompletion` to `true` because the action will not complete until the sound effect is completed. If we set it to `false`, then it would count the sound-effect action as completed as soon as it begins to play.

### Adding Music 

Before we create a way to play music in our app, we need something to play. Similar to our search for sound effects, we can search Google for “royalty free music,” and we will generally find something. Additionally, you can go to SoundCloud and talk to artists there. See if you can reach an agreement, either by using the music for free with attribution or by paying for a license to use it in your game. For this app, I happened across [Bensound](http://www.bensound.com/royalty-free-music)[28](#28)[17](#17), which had some music I could use, under the Creative Commons license. To use it, you must follow its [licensing agreement](http://www.bensound.com/licensing)[18](#18). Pretty straightforward: Either credit Bensound or pay for a license.

Download all four tracks ([1](http://www.bensound.com/royalty-free-music/track/little-idea)[19](#19), [2](http://www.bensound.com/royalty-free-music/track/clear-day)[20](#20), [3](http://www.bensound.com/royalty-free-music/track/jazzy-frenchy)[21](#21), [4](http://www.bensound.com/royalty-free-music/track/jazz-comedy)[22](#22)), or move them over from the “Music” folder that we downloaded earlier. We will use them and cycle between each track to keep things fresh. Another thing to consider is that these tracks don’t loop correctly, so you will know when each starts and ends. Good background music will loop or morph one track into another really well.

Once you download the tracks, create a folder named “Music” in the “RainCat” folder, the same way you created the “SFX” folder earlier. Move the tracks to that folder.

[![Adding in some music tracks](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png)[23](#23)

Adding in some music tracks ([View large version](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png)[24](#24))

Then, create a group in the “Support” group of our project’s structure, named “Music.” Add our tracks to the project by right-clicking on the “Music” group and clicking “Add Files to RainCat”. This is the same procedure that we used when adding our sound effects.

Next, we will create a new file named `SoundManager.swift`, as you may have seen in the picture above. This will act as the single source of music tracks to be played. For sound effects, we don’t care if one plays over another, but it would sound terrible if two music tracks played at the same time. Finally, we can implement the `SoundManager`:

```
import AVFoundation

class SoundManager : NSObject, AVAudioPlayerDelegate {
  static let sharedInstance = SoundManager()

  var audioPlayer : AVAudioPlayer?
  var trackPosition = 0

  //Music: http://www.bensound.com/royalty-free-music
  static private let tracks = [
    "bensound-clearday",
    "bensound-jazzcomedy",
    "bensound-jazzyfrenchy",
    "bensound-littleidea"
  ]

  private override init() {
    //This is private, so you can have only one Sound Manager ever.
    trackPosition = Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
  }

  public func startPlaying() {
    if audioPlayer == nil || audioPlayer?.isPlaying == false {
      let soundURL = Bundle.main.url(forResource: SoundManager.tracks[trackPosition], withExtension: "mp3")

      do {
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        audioPlayer?.delegate = self
      } catch {
        print("audio player failed to load")

        startPlaying()
      }

      audioPlayer?.prepareToPlay()

      audioPlayer?.play()

      trackPosition = (trackPosition + 1) % SoundManager.tracks.count
    } else {
      print("Audio player is already playing!")
    }
  }

  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    //Just play the next track.
    startPlaying()
  }
}
```

Going through the new `SoundManager` class, we are making a [singleton](https://www.codefellows.org/blog/singletons-and-swift/)[25](#25) class that handles playback of the large track files and continuously plays them in order. For longer-format audio files, we need to use `AVFoundation`. It is built for this, and `SKAction` cannot load the file in quickly enough to play it in the same way it could load in a small SFX file. Because this library has been around forever, the `delegate` still depends on [`NSObjects`](https://developer.apple.com/reference/objectivec/nsobject)[26](#26). We need to be the [`AVAudioPlayerDelegate`](https://developer.apple.com/reference/avfoundation/avaudioplayerdelegate)[27](#27) to detect when the audio player completes playback. We’ll hold class variables for the current `audioPlayer` for now; we will need them later to mute playback.

Now we have the current track’s location, so we know the next track to play, followed by an array of the names of the music tracks in our project. We should attribute it to [Bensound](http://www.bensound.com/royalty-free-music)[28](#28)[17](#17) to honor our licensing agreement.

We need to implement the default `init` function. Here, we choose a random track to start with, so that we don’t always hear the same track first. From then on, we wait for the program to tell us to start playing. In `startPlaying`, we check to see whether the current audio player is playing. If it is not, then we attempt to start playing the selected track. We’ll attempt to start the audio player, which can fail, so we need to surround it in a [try/catch block](https://www.bignerdranch.com/blog/error-handling-in-swift-2/)[29](#29). After that, we prepare playback, play the audio clip, and then set the index for the next track. This line is pretty important:

```
trackPosition = (trackPosition + 1) % SoundManager.tracks.count
```

This sets the next position of the track by incrementing it and then performing a [modulo](https://en.wikipedia.org/wiki/Modulo_operation)[30](#30) on it to keep it within the bounds of the tracks’ array. Finally, in `audioPlayerDidFinishPlaying(_ player:successfully flag:)`, we implement the `delegate` method, which lets us know when the track finishes. Currently, we don’t care whether it succeeds or not — we just play the next track when this is called.

### Just Press Play 

Now that we are done explaining the `SoundManager`, we just need to tell it to start, and we’ll have music playing on a loop forever. Quickly run over to `GameViewController.swift` and place the following line of code below where we set up the scene the first time:

```
SoundManager.sharedInstance.startPlaying()
```

We do this in `GameViewController` because we want the music to be independent of the scene. If we run the app at this point, and everything has been added to the project correctly, we will have background music for our game!

In this lesson, we’ve touched on two major topics: sprite animation and sound. We used a frame-based animation to animate our sprite, used `SKAction`s to animate, and used methods to correct our cat after it is hit by rain. We added sound effects using `SKAction`s and assigned them to play when the cat gets hit by rain. Finally, we added initial background music for our game.

For those who have made it this far, congratulations! Our game is nearing completion! If you missed a step or got confused along the way, please check out the completed code for this lesson [on GitHub](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-two)[31](#31).

How did you do? Does your code look almost exactly like mine? What has changed? Did you update the code for the better? Let me know in the comments below.

Lesson 3 is coming up next!

#### Footnotes 

1. [ https://developer.apple.com/spritekit/](#note-1)
2. [ https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/](#note-2)
3. [ https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one](#note-3)
4. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt.png](#note-4)
5. [ https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/](#note-5)
6. [ https://github.com/thirteen23/RainCat/blob/smashing-day-2/dayTwoAssets.zip](#note-6)
7. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png](#note-7)
8. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png](#note-8)
9. [ https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html](#note-9)
10. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png](#note-10)
11. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png](#note-11)
12. [ https://developer.apple.com/reference/spritekit/sknode/1483087-xscale](#note-12)
13. [ http://soundbible.com/tags-cat-meow.html](#note-13)
14. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png](#note-14)
15. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png](#note-15)
16. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-SFX-preview-opt.png](#note-16)
17. [ http://www.bensound.com/royalty-free-music](#note-17)
18. [ http://www.bensound.com/licensing](#note-18)
19. [ http://www.bensound.com/royalty-free-music/track/little-idea](#note-19)
20. [ http://www.bensound.com/royalty-free-music/track/clear-day](#note-20)
21. [ http://www.bensound.com/royalty-free-music/track/jazzy-frenchy](#note-21)
22. [ http://www.bensound.com/royalty-free-music/track/jazz-comedy](#note-22)
23. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png](#note-23)
24. [ https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png](#note-24)
25. [ https://www.codefellows.org/blog/singletons-and-swift/](#note-25)
26. [ https://developer.apple.com/reference/objectivec/nsobject](#note-26)
27. [ https://developer.apple.com/reference/avfoundation/avaudioplayerdelegate](#note-27)
28. [ http://www.bensound.com/royalty-free-music](#note-28)
29. [ https://www.bignerdranch.com/blog/error-handling-in-swift-2/](#note-29)
30. [ https://en.wikipedia.org/wiki/Modulo_operation](#note-30)
31. [ https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-two](#note-31)

