
> * 原文地址：[ How To Build A SpriteKit Game In Swift 3 (Part 2) ](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-2/ )
* 原文作者：[ Marc Vandehey ]( https://www.smashingmagazine.com/author/marcvandehey/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[ZiXYu](https://github.com/ZiXYu)
* 校对者：[DeepMissea](https://github.com/DeepMissea), [Tuccuay](https://github.com/Tuccuay)

## [ 如何在 Swift 3 中用 SpriteKit 框架编写游戏 (Part 2)](https://www.smashingmagazine.com/2016/12/how-to-build-a-spritekit-game-in-swift-3-part-2/)  ##

你是否想过如何来开发一款 [SpriteKit](https://developer.apple.com/spritekit/)<sup>[\[1\]](#note-1)</sup> 游戏？实现碰撞检测会是个令人生畏的任务吗？你想知道如何正确的处理音效和背景音乐吗？随着 SpriteKit 的发布，在 iOS 上的游戏开发已经变得空前简单了。在本系列三部中的第二部分中，我们将继续探索 SpriteKit 的基础知识。

如果你错过了 [之前的课程](https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/)<sup>[\[2\]](#note-2)</sup>，你可以通过获取 [ GitHub 上的代码](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one)<sup>[\[3\]](#note-3)</sup> 来赶上进度。请记住，本教程需要使用 Xcode 8 和 Swift 3。

[![Raincat: 第二课](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt.png)<sup>[\[4\]](#note-4)</sup>

RainCat, 第二课

在 [上一课](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-build-a-spritekit-game-in-swift-3-part-1.md)<sup>[\[5\]](#note-5)</sup> 中，我们创建了地板和背景，随机生成了雨滴并添加了雨伞。这把雨伞的精灵（译者注：sprite，中文译名精灵，在游戏开发中，精灵指的是以图像方式呈现在屏幕上的一个图像）中存在一个自定义的 `SKPhysicsBody`，是通过 `CGPath` 来生成的，同时我们启用了触摸检测，因此我们可以在屏幕范围内移动它。而且我们通过 `categoryBitMask` 和 `contactTestBitMask` 来实现了碰撞检测。我们在雨滴落到任何物体上时消除了碰撞，因此它们不会堆积起来，而是会在一次弹跳后穿过地板。最后，我们设置了一个世界边框来移除所有和它接触的 `SKNode`。

本文中，我们将重点实现以下几点：

- 生成猫
- 实现猫的碰撞
- 生成食物
- 实现食物的碰撞
- 使猫向食物移动
- 创建猫的动画
- 当猫接触雨滴时，使猫受到伤害
- 添加音效和背景音乐

### 获取资源

你可以从 [GitHub](https://github.com/thirteen23/RainCat/blob/smashing-day-2/dayTwoAssets.zip)<sup>[\[6\]](#note-6)</sup> (ZIP) 上获取本课所需要的资源。下载图片后，通过一次性拖拽所有图片将它们添加到你的 `Assets.xcassets` 文件中。你现在应该有了包含猫动画和宠物碗的资源文件。我们之后将会添加音效和背景音乐文件。

[![App 资源](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-preview-opt-1.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png)<sup>[\[7\]](#note-7)</sup>

一大堆资源！ ([查看源文件](https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png))<sup>[\[8\]](#note-8)</sup>

### 猫猫时间！ 

我们从添加游戏主角开始本期课程。我们首先在 “Sprites” 组下创建一个新文件，命名为 `CatSprite`。

将如下代码添加到 `CatSprite.swift` 文件中：

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

在这个文件中，我们用了一个会返回猫精灵的静态初始化函数。在另一个 `update` 函数中，我们也使用了同样的方法。如果我们需要生成更多的精灵，我们应该尝试把这个函数变成一个 [协议](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html)<sup>[\[9\]](#note-9)</sup> 的一部分来生成合适的精灵。这里需要注意一点，对于猫精灵，我们使用的是一个圆形的 `SKPhysicsBody`。就像我们创建雨滴一样，我们当然可以使用纹理来创建猫的物理实体，但是这是一个有“美感”的决定。当猫被雨滴或雨伞碰到时， 与其让猫始终坐着，让猫在地上打滚显然更有趣一些。

当猫接触雨滴或猫掉出该世界时，我们将需要回调函数来处理这些事件。我们可以打开 `Constants.swift` 文件，将下列代码加入该文件，使它作为一个 `CatCategory`：

```
let CatCategory : UInt32 = 0x1 << 4
```

上面代码中定义的变量将决定猫的身体是哪个 `SKPhysicsBody`。让我们重新打开 `CatSprite.swift` 来更新猫精灵的状态，使它包含 `categoryBitMask` 和 `contactTestBitMask` 这两个属性。 在 `newInstance()` 返回 `catSprite` 之前，我们需要添加如下代码：

```
catSprite.physicsBody?.categoryBitMask = CatCategory
catSprite.physicsBody?.contactTestBitMask = RainDropCategory | WorldCategory
```

现在，当猫被雨滴击中或者当猫跌出世界时，我们将会得到一个回调。在添加了如上代码后，我们需要将猫添加到场景中。

在 `GameScene.swift` 文件的顶部, 初始化了 `umbrellaSprite` 之后， 我们需要添加如下代码:

```
private var catNode : CatSprite!
```

我们可以立刻在 `sceneDidLoad()` 里创建一只猫，但是我们更想要从一个单独的函数中来创建猫对象，以便于代码重用。`!` 告诉编译器，它并不需要在 `init` 语句中立即初始化，而且它应该不会是 `nil`。我们这么做有两个理由。首先，我们不想单独为了一个变量创建 `init()` 语句。其次，我们并不想立刻初始化猫精灵，只要在我们第一次运行 `spawnCat()` 时重新初始化和定位它就可以了。我们也可以用 `?` 来定义该变量，但是当我们第一次运行了 `spawnCat()` 函数后，我们的猫精灵就再也不会变成 `nil` 了。为了解决初始化问题和让我们头疼的拆包，我们会说使用感叹号来进行自动拆包是安全的操作。如果我们在初始化我们的猫对象前就使用了它，我们的应用就会闪退，因为我们告诉应用对猫对象进行拆包是安全的，然而它还没有初始化。在我们使用它之前，需要先在合适的函数中将它初始化

接下来，我们将要在 `GameScene.swift` 文件中新建一个 `spawnCat()` 函数来初始化我们的猫精灵。我们会把这个初始化的部分拆分到一个单独的函数中，使这部分代码具有重用性，同时保证在场景里每次只有一只猫。

在这个文件中接近底部的地方，`spawnRaindrop()` 函数后面添加如下代码：

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

纵观这段函数，我们首先检查了猫对象是否为空。然后，我们检查了这个场景中是否已经存在了一个猫对象。如果这个场景内已经存在了一只小猫，我们就要从父类中移除它，移除它现在正在进行的所有操作，并清除这个猫对象的 `SKPhysicsBody`。而这些操作仅仅会在猫掉出该世界时被触发。在这之后，我们会重新初始化一个新的猫对象，同时设定它的初始位置为伞下 30 像素的地方。其实我们可以在任何位置初始化我们的猫对象，但是我想这个位置总比直接从天空中把猫丢下来好一些。

最后，在 `sceneDidLoad()` 函数中，在我们定位并添加了雨伞之后，调用 `spawnCat()` 函数：

```
umbrellaNode.zPosition = 4
addChild(umbrellaNode)

spawnCat()
```

现在我们可以运行我们的应用啦！

[![应用资源](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png)<sup>[\[10\]](#note-10)</sup>

猫 ([查看源文件](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png))<sup>[\[11\]](#note-11)</sup>

如果现在猫碰到雨滴或是雨伞，它将会在地上打滚。这时候，猫可能会滚出屏幕然后在接触世界边框的一瞬间被删除掉，那么，我们就需要重新生成猫对象了。因为现在回调函数会在当猫接触到雨滴时或猫掉出世界时被触发，所以我们可以在 `didBegin(_ contact:)` 函数中来处理这个碰撞事件。

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

在这段代码中，我们在寻找除了猫以外的物理实体（physics body）。在我们发现其他实体对象时，我们就需要判断是什么触碰了猫。现在，如果是雨滴在猫身上，我们只在控制台中输出这个碰撞发生了，而如果是猫触碰了这个游戏世界的边缘，我们就会重新生成一个猫对象。

如果（什么东西）与猫对象发生接触，我们就调用这个函数。时那么，让我们用如下代码来更新 `didBegin(_ contact:)` 函数：

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

我们在移除雨滴碰撞和移除离屏节点中间插入了一个条件判断。这个 `if` 语句判断了碰撞物体是不是猫，然后我们在 `handleCatCollision(contact:)` 函数中处理猫的行为。

我们现在可以用雨伞把猫推出屏幕来测试猫的重生函数了。我们会看到，猫将在伞下重新被定义出来。请注意，如果雨伞的底部低于地板，那么猫就会一直从屏幕中掉出去。到现在为止这并不是什么大问题，但是我们之后会提供一个方法来解决它。

### 生成食物

现在看来，是时候生成一些食物来喂我们的小猫了。当然了，现在猫并不能自己移动，不过我们一会可以修复这个问题。在创建食物精灵之前，我们可以先在 `Constants.swift` 文件中为食物新建一个类。让我们在 `CatCategory` 中添加如下代码：

```
let FoodCategory : UInt32 = 0x1 << 5
```

上面代码中定义的变量将决定食物的物理对象是哪个 `SKPhysicsBody`。在“Sprites”组中，我们用创建 `CatSprite.swift` 文件同样的方法新建一个名为 `FoodSprite.swift` 的文件，并在该文件中添加如下代码：

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

这是一个静态的函数，当它被调用时，将会初始化一个 `FoodSprite` 并且返回它。我们把食物的物理实体设置为一个和食物精灵同样大小的矩形。因为食物精灵本身就是一个矩形。接下来，我们把物理对象的种类设置为我们刚刚创建的 `FoodCategory` ，然后把它添加到它可能会碰撞的对象（世界边框，雨滴和猫）中。我们把食物和猫的 `zPosition` 设置成相同的，这样它们将永远不会重叠，因为当它们相遇时，食物就会被删除然后玩家将会得到一分。

重新打开 `GameScene.swift` 文件，我们需要添加一些功能来生成和移除食物。在这个文件的顶部，`rainDropSpawnRate` 变量的下面，我们添加如下代码：

```
private let foodEdgeMargin : CGFloat = 75.0
```

这个变量将会作为生成食物时的外边距。我们不想将食物生成在离屏幕两侧特别近的位置。我们把这个值定义在文件的顶部，这样如果我们之后要改变这个值的时候就不用搜索整个文档了。接下来，在我们的 `spawnCat()` 函数下面，我们可以新增我们的 `spawnFood` 函数了。

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

这个函数和我们的 `spawnRaindrop()` 函数几乎一模一样。我们新建了一个 `FoodSprite`，然后把它放在了屏幕上一个随机的位置 `x`。这里我们用了之前设定的外边距（margin）变量来限制了能够生成食物精灵的屏幕范围。首先，我们设置了随机位置的范围为屏幕的宽度减去 2 乘以外边距。然后，我们用外边距来偏移起始位置。这使得食物不会生成在任意距屏幕边界 0 到 75 的位置里。

在 `sceneDidLoad()` 文件接近顶部的位置，让我们在 `spawnCat()` 函数的初始化调用下面加上如下代码：

```
spawnCat()
spawnFood()
```

现在当场景加载时，我们会生成一把雨伞，雨伞下面有一只猫，还有一些从天上掉下来的雨滴和食物。现在雨滴可以和猫（译者注：原文写的是 food，百分百是写错了）互动，让它来回滚动了。对食物来说，它跟雨滴碰到雨伞和地板一样，反弹一次然后失去所有的碰撞属性，直到触碰到世界边界后被删除。我们也同样需要添加一些食物和猫的互动。

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

在这个函数中，我们将用和处理猫碰撞同样的方式来处理食物碰撞。首先，我们定义了食物的物理实体，然后我们用了一个 `switch` 语句来判断除食物之外的物理实体。接着，我们添加了一个 `CatCategory` 条件分支 - 这是个预留的接口，我们之后可以添加代码来更新游戏分数。接下来我们 `fallthrough` 到 `WorldFrameCategory` 分支语句，这里我们需要从场景里移除食物精灵和它的物理实体。最后，我们需要重新生成食物。总而言之，当食物触碰到了世界边界，我们只需要移除食物精灵和它的物理实体。如果食物触碰到了其它物理实体，那么 default 分支语句就会被触发然后在控制台打印一个通用语句。现在，唯一能触发这个语句的物理实体就是 `RainDropCategory`。而到现在为止，我们并不关心当雨击中食物时会发生什么。我们只希望雨滴和食物在击中地板或雨伞时有同样的表现。

为了让所有部分连接起来，我们将在 `didBegin(_ contact)` 函数中添加几行代码。在判断 `CatCategory` 之前添加如下代码：

```
if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
  handleFoodHit(contact: contact)
  return
}
```

`didBegin(_ contact)` 最后应该看起来像这样：

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

现在是时候让我们的小猫动起来了。是什么驱使了小猫移动呢？当然是食物啦！我们刚刚生成了食物，那么现在我们就需要让小猫向着食物移动啦。现在我们的食物精灵被添加到了场景中，然后就被遗忘了。我们需要修正这个问题。如果我们能够保留食物的引用（reference），我们就可以知道它在任何时候的位置，这样我们就可以告诉小猫食物在场景的哪个位置了。小猫可以通过检查自己的坐标来了解自己在场景中的哪个位置。有了这些位置信息，我们就可以让小猫向着食物移动了。

重新打开 `GameScene.swift` 文件，让我们在文件的顶部，猫变量的下面添加一个变量：

```
private var foodNode : FoodSprite!
```

现在我们可以更新 `spawnFood()` 函数，使每次食物生成时都会刷新这个变量的值。

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

这个函数将把食物变量的作用域从 `spawnFood()` 函数变为整个 `GameScene.swift` 文件。在我们的代码中，同一时间我们只会生成一个 `FoodSprite`，同时我们需要保持对它的引用。因为有这个引用，我们就可以检测到在任何时间食物的位置了。同样的，在任何时间场景内也只会有一只猫，同样我们也需要保持对它的引用。

我们知道小猫想要获得食物，我们只需要提供一个方法让小猫能够移动。我们需要编辑 `CatSprite.swift` 文件以便我们知道小猫需要往哪个方向前进来获取食物。为了让小猫获得食物，我们还需要知道小猫的移动速度。在 `CatSprite.swift` 文件的顶部，我们可以在 `newInstance()` 函数前添加如下代码：

```
private let movementSpeed : CGFloat = 100
```

这一行代码定义了猫的移动速度，这是对一个复杂问题的简单解法。我们用了一个简单的线性方程，不考虑任何摩擦和加速。

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

我们更新了这个函数的函数签名（signature）。因为我们需要告诉小猫食物的位置，所以在传参时，我们不仅传递了 delta 时间，也传递了食物的位置信息。因为很多事情可以影响食物的位置，所以我们需要不停地更新食物的位置信息，以保证小猫一直在正确的方向上前进。接下来，让我们来看一下函数的功能。在这个更新过的函数中，我们取的 delta 时间是一个非常短的时间，大约只有 0.166 秒左右。我们也取了食物的位置，是 `CGPoint` 类型的参数。如果食物的 `x` 位置比小猫的 `x` 位置更小，那么我们就知道食物在小猫的左边，反之，食物就在小猫的上边或右边。如果小猫朝左边移动，那么我们取小猫的 `x` 位置减去小猫的移动速度乘以 delta 时间。我们需要把 delta 时间的类型从 `TimeInterval` 转换到 `CGFloat`，因为我们的位置和速度变量用的是这个单位，而 Swift 恰恰是一种强类型语言。

这个效果实际上是以一个恒定的速率将小猫往左边推，让它看起来像是在移动。在这里，每隔 0.166 秒，我们就将猫精灵放在上一位置左边 16.6 单位的位置上。这是因为我们的 `movementSpeed` 变量是 100，而 0.166 × 100 = 16.6。小猫往右边移动时进行一样的处理，除了我们是将猫精灵放在上一位置右边 16.6 单位的位置上。接下来，我们设定了我们猫的 [xScale](https://developer.apple.com/reference/spritekit/sknode/1483087-xscale)<sup>[\[12\]](#note-12)</sup> 属性。这个值决定了猫精灵的宽度。默认值是 1.0，如果我们把 `xScale` 设置成 0.5，猫的宽度就会变成之前的一半。如果我们把这个值翻倍到 2.0，那么猫的宽度就会变成之前的一倍，以此类推。因为原始的猫精灵是面朝右边的，当猫朝着右边移动时，xScale 值会被设定为默认的 1。如果我们想要“翻转”猫精灵，我们就把 xScale 设置成 -1，这会把猫的 frame 值置为负数并且反向渲染。我们把这个值保持在 -1 来保证猫精灵的比例一致。现在，当猫朝左边移动时，它会面朝左边，当猫朝右边移动时，它会面朝右边。

现在小猫会以一个恒定的速率朝着食物的位置移动了。首先，我们确定了小猫需要移动的方向，之后让小猫在 x 轴上朝着那个方向移动。我们同样也需要更新猫的  `xScale` 参数，因为我们希望小猫可以在移动时面朝正确的方向。除非我们希望小猫在用太空步移动！最后，我们需要告诉小猫来更新我们的游戏场景。

打开 `GameScene.swift` 文件，找到我们的 `update(_ currentTime:)` 函数，在更新雨伞的调用下面，新增如下代码：

```
catNode.update(deltaTime: dt, foodLocation: foodNode.position)
```

运行我们的应用，然后成功！最起码是在绝大多数情况下。到现在为止，小猫会朝着食物移动了，但是却可能会陷入一些有意思的情况里。

只是一只小猫做着小猫该做的事

接下来，我们就要来添加移动动画啦！在这之后，我们会绕回来解决猫被打中后的滚动效果。你可能已经注意到了一个名为 `cat_two` 的未使用资源。我们需要添加这个纹理，并且穿插使用它，使小猫看起来像在行走。为了实现这个，我们需要添加我们第一个 `SKAction`！

### 行走样式

在 `CatSprite.swift` 文件的顶部，我们将要添加一个字符串常量，以便我们添加一个与该键值相关联的步行动作。这样做使得我们可以单独停止猫的步行动作，而不是移除之后可能会添加的所有动作。在 `movementSpeed` 变量前添加如下代码：

```
private let walkingActionKey = "action_walking"
```

这个字符串本身并不是那么重要，但是它是步行动画的标志位。我也很喜欢在给键值命名时添加一些有意义的字段，以方便调试。例如，当我看到这个键值时，我会知道这是个 `SKAction`，具体来说，是个步行动作。

在 `walkingActionKey` 的下面，我们将会添加图像帧。因为我们只会使用两个不同的图象帧，我们可以把它放在文件的顶部：

```
private let walkFrames = [
  SKTexture(imageNamed: "cat_one"),
  SKTexture(imageNamed: "cat_two")
]
```

这只是个包含了两个纹理的数组，而这两个纹理是在猫行走时需要交替使用的。为了完成这个功能，我们需要用如下代码更新我们的 `update(deltaTime: foodLocation:)` 函数：

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

通过此更新，我们检查了我们的猫精灵是否已经在运行步行动画序列了。如果没有，那么我们就会将步行动画添加到猫精灵上。这是个嵌套的 `SKAction`。首先，我们新建了一个会一直重复的动作。然后，在*那个*动作里，我们新建了步行的动画序列。 `SKAction.animate(with: …)` 函数会接收动画帧数组，以及每帧持续的时间。 函数中接收的下一个变量确定了其中的纹理是否具有不一样的大小，同时当该纹理在动画帧上生效时是否需要调整 `SKSpriteNode` 的大小。 `Restore` 确定了当动画结束时，精灵是否需要重置到它的初始状态。我们把这两个值都设置成了 `false`，这样就不会有什么出人意料的事情发生了。在我们设定好了步行动画之后，我们就可以通过运行 `run()` 函数来让猫精灵开始行走了。

再次运行我们的应用，我们将看到我们的小猫专心致志地朝着食物移动啦！

Yeah, on the catwalk, on the catwalk, yeah I do my little turn on the catwalk（译者注：这是 “I am Too Sexy” 的歌词）.

如果在这个过程中，小猫被击中，它会打滚，但是仍旧朝着食物移动。我们需要显示小猫的受损状态，以便用户知道他们做了什么不好的事。同样的，我们需要修正小猫在移动过程中的打滚动作，以保证小猫不会在乱七八糟的方向上移动。

让我们来看一下我们的计划。我们希望能够显示小猫被击中了，而不是仅仅更新游戏得分。有些游戏会使该受损单位闪烁并且进入无敌状态。如果我们有纹理的话，我们也可以做一个受损动画。对这个游戏而言，我想保持它的简单性，所以我只添加了一些“摇动”功能。当小猫被雨滴击中时，它会被晕眩然后不可置信地翻倒；它会被*震惊*，因为玩家居然让这种事发生了。为了实现这个功能，我们会定义一些变量。我们需要知道小猫会被晕眩多长时间和它已经被晕眩了多长时间。在这个文件的顶部， `movementSpeed` 变量的下面添加如下代码：

```
private var timeSinceLastHit : TimeInterval = 2
private let maxFlailTime : TimeInterval = 2
```

第一个变量， `timeSinceLastHit` 保存了自小猫上次被打中后过了多长时间。因为下一个变量 `maxFlailTime`，我们把这个值设置成 `2`。`maxFlailTime` 变量是个常数，表示小猫每次会被晕眩 2 秒钟。我们把这两个值都被设置成 2，这样小猫就不会在生成的一瞬间就被晕眩了。你可以尝试着重新设定这两个值，来确定最好的晕眩时间。

现在，我们需要添加一个函数，让小猫知道它被打中了，它需要通过停止移动来对此做出反应。在我们的 `update(deltaTime: foodLocation:)` 函数下添加如下代码：

```
public func hitByRain() {
  timeSinceLastHit = 0
  removeAction(forKey: walkingActionKey)
}
```

这段代码只是把 `timeSinceLastHit` 变量设置成了 `0`，同时移除了小猫的步行动画。现在我们需要重写 `update(deltaTime: foodLocation:)` 函数，以保证小猫就不会在它被晕眩的时候移动。让我们用如下代码更新该函数：

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

现在，我们的 `timeSinceLastHit` 变量会不停更新，而且如果小猫在过去的 2 秒钟没有被打中，那么它就会继续朝着食物移动。如果我们并没有设置步行动画，那么必须要正确地设置它。步行动画是个基于帧的动画，而它只是每 0.1 秒交换两个纹理使得小猫看起来像在行走。不过它看起来的确很像小猫真的在行走，对吧？

我们需要重新打开 `GameScene.swift` 文件来告诉小猫它被击中了。在 `handleCatCollision(contact:)` 函数中，我们需要调用 `hitByRain` 函数。在 `switch` 语句里，找到 `RainDropCategory` 然后把其中的这个语句：

```
print("rain hit the cat")
```

换成这个：

```
catNode.hitByRain()
```

如果我们现在运行我们的应用，当小猫被雨滴击中时，它就会被晕眩 2 秒啦！

这个功能成功实现了，只是现在小猫会进入一个颠倒的状态，看起来很滑稽。同样的，这也会让雨滴看起来真的很痛——可能我们需要做点什么了。

对于雨滴的问题，我们可以对它的 `physicsBody` 做点细微的调整。在 `spawnRaindrop` 函数中，初始化 `physicsBody` 语句的下面，我们可以添加如下代码：

```
raindrop.physicsBody?.density = 0.5
```

这会使雨滴的密度从它的初始值 `1.0` 减半。这会使得小猫没这么容易被击中了。

打开 `CatSprite.swift` 文件，我们可以修改 `SKAction` 来修正小猫的旋转。在 `update(deltaTime: foodLocation:)` 函数中添加如下代码。确保它在 `if` 语句的里面判断猫是否在抖动。

找到这一行：

```
if timeSinceLastHit >= maxFlailTime {
```

并且添加如下代码来修正小猫的旋转角度：

```
if zRotation != 0 && action(forKey: "action_rotate") == nil {
  run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
}
```

这个代码块会判断是否小猫已经被旋转了，哪怕只是一点点。然后，我们要判断当前正在运行的这些 `SKAction` 来确定我们是否已经运行猫的重置动画。如果小猫被旋转了，而又没有运行动画，那么我们就需要运行一个动画来让小猫回归到初始状态。需要注意的是，我们这里采用了硬编码，因为我们暂时不需要在任何别的部分使用这个值。以后如果我们需要在别的函数或类中判断旋转动画，我们就需要在文件的顶部设置一个常量了，就像 `walkingActionKey` 一样。

运行我们的应用，现在你能看到奇迹发生了：小猫被击中了，小猫旋转了，小猫又转回来了，它很开心可以继续去吃掉更多的食物了。可是这里仍旧有两个小问题。因为我们把猫的 `physicsBody` 设置成了一个圆，在小猫第一次修正自己时，你可能会发现小猫的状态变得不太稳定了。它会不停的旋转然后修正自己。为了解决这个问题，我们需要重设 `angularVelocity`。本质上，小猫在被击中时会旋转，然而我们并没有修正我们为小猫添加的移动速度。而小猫也在被击中后没有更新自己的速度。如果小猫被击中了然后尝试着向相反方向移动，你可能会发现它比正常的速度慢了。另外一个问题是，食物可能会在小猫的正上方。当食物在小猫正上方时，小猫会迅速地转身。我们可以通过用如下代码更新我们的 `update(deltaTime :, foodLocation:)` 函数来解决这个问题：

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

现在让我们再来重新运行应用，大部分的不稳定动作已经被修正了。不仅仅是这样，当食物在小猫正上方时，小猫也会稳稳地站着了。

### 现在来添加音乐吧 

在我们开始写代码前，我们应该先要找点音效。一般来说，在寻找音效时，我只会搜索一些类似于 “cat meow royalty free” 的关键词。第一个匹配的通常是 [SoundBible.com](http://soundbible.com/tags-cat-meow.html)<sup>[\[13\]](#note-13)</sup>，它会提供一些免费的音效。请务必阅读使用许可证。如果你不打算发布你的应用，那么就不需要关心许可证，因为这只是个个人应用。可是，如果你想要在 App store 中发售它，或者通过别的方式发布它，那么就请确保附上了 Creative Commons Attribution 3.0 或者是类似的许可证。这里有许多种许可证，所以当你使用别人的作品前，请确定你找到了相对应的许可证。

在该应用中使用的音效都是通过 Creative Commons-licensed 授权并且免费使用的。为了之后的操作，我们需要将之前下载的 `SFX` 文件夹移动到 `RainCat` 文件夹中。

[![Finder 模式已激活](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png)<sup>[\[14\]](#note-14)</sup>

把音效添加到文件系统中。 ([查看源文件](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png)<sup>[\[15\]](#note-15)</sup>)

在你把这些文件拷贝到项目中之后，你需要用 Xcode 来把它们添加到你的项目中。在 “Support” 文件夹下新建一个名为 “SFX” 的 group。右键点击这个group 然后点击 “Add Files to RainCat…” 选项。

[![添加音效](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-SFX-preview-opt.png) ](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-SFX-preview-opt.png)<sup>[\[16\]](#note-16)</sup>

添加音效

找到你的 “SFX” 文件夹，选中你的所有音效文件，然后点击 “Add” 按钮。现在项目中就有了你所有需要使用的音效文件了。打开 `CatSprite.swift` 文件，我们可以添加一个包含了所有音效文件名的数组，这样我们就可以在雨滴击中物体时播放它们了。在该文件的顶部， `walkFrames` 变量下，添加如下数组：

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

我们在 `hitByRain` 函数中添加两行代码，来让小猫发出声音了：

```
let selectedSFX = Int(arc4random_uniform(UInt32(meowSFX.count)))
run(SKAction.playSoundFileNamed(meowSFX[selectedSFX], waitForCompletion: true))
```

上面的代码会在 0 到 `meowSFX` 数组大小的范围内随机选择一个值。然后，我们从字符串数组中选择相对应的音效名并且播放它。我们将得到一个 1 bit 的 `waitForCompletion` 变量. 同样的，我们将使用 `SKAction.playSoundFileNamed` 来播放我们可爱的音效。

那么现在我们的应用就有声音啦！那么多声音！可是有些声音会重叠起来。现在，每当小猫被雨滴击中时，我们就会播放一个音效。很快我们就会觉得烦了。我们需要在播放音效时添加更多的逻辑判断，而且我们也不应该同时播放两个音效。

在 `CatSprite.swift` 文件的顶部，`maxFlailTime` 变量的下面，添加如下两个变量:

```
private var currentRainHits = 4
private let maxRainHits = 4

```

第一个变量，`currentRainHits`，是一个计数器，会统计小猫总共被雨滴打中了多少次，而 `maxRainHits` 表示了在小猫喵喵叫前能被击中几次。

现在我们将要更新 `hitByRain` 函数了。我们需要应用 `currentRainHits` 和 `maxRainHits` 两个变量来制定规则了。让我们用如下代码来更新 `hitByRain` 函数：

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

现在，如果 `currentRainHits` 的值比设定的最大值小，那么我们只增加 `currentRainHits` 的值而不播放音效。然后，我们需要通过我们提供的键值： `action_sound_effect` 来判断我们现在是否已经在播放音效了。如果我们没在播放音效，那么我们可以随机播放一个音效。我们把 `waitForCompletion` 参数设置成 `true`， 因为这个操作在音效结束前并不会完成。如果我们把该参数设置成 `false`，那么它会在音效刚开始时就把它当做播放结束来计数了。
 
### 添加音乐 

在我们新建一个方法在我们的应用中播放音乐之前，我们需要找到能播放的东西。类似于搜索音效的过程，我们可以在 Google 中搜索 “royalty free music” 来找到需要播放的音乐。此外，你可以去 SoundCloud 网站，并与里面的艺术家交谈。你需要查看你是否可以找到音乐相对应的许可证以保证你可以在你的游戏中使用它。 对这个应用而言，我碰巧发现了 [Bensound](http://www.bensound.com/royalty-free-music)<sup>[\[28\]](#note-28)</sup><sup>[\[17\]](#note-17)</sup>，根据 Creative Commons license，有一些我们可以使用的音乐。你必须遵从 [licensing agreement](http://www.bensound.com/licensing)<sup>[\[18\]](#note-18)</sup> 来使用它。操作其实很简单：credit Bensound 或者付费购买许可。

下载我们的四个音轨 ([1](http://www.bensound.com/royalty-free-music/track/little-idea)<sup>[\[19\]](#note-19)</sup>, [2](http://www.bensound.com/royalty-free-music/track/clear-day)<sup>[\[20\]](#note-20)</sup>, [3](http://www.bensound.com/royalty-free-music/track/jazzy-frenchy)<sup>[\[21\]](#note-21)</sup>, [4](http://www.bensound.com/royalty-free-music/track/jazz-comedy)<sup>[\[22\]](#note-22)</sup>)，或者把它们从之前下载的 “Music” 文件夹里拖出来。我们将在四个音轨循环播放，来保证玩家不会感到厌烦。另外一件需要考虑的事是，这些音轨可能并不能正确循环，这样你就需要知道每个音轨的开始和结束时间。好的背景音乐可以很好的在不同的音轨间循环或切换。

在你下载了这些音轨之后，你需要在 “RainCat” 文件夹下新建一个名叫 “Music” 的文件夹，和你之前创建 “SFX” 文件夹的操作一样。然后把下载的音轨移动到这个文件夹中。

[![添加音乐](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-preview-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png)<sup>[\[23\]](#note-23)</sup>

添加音乐 ([查看源文件](https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png))<sup>[\[24\]](#note-24)</sup>

然后，在我们的项目结构里的 “Support” 中创建一个组，命名为 “Music”。 右键点击 “Music” 组，点击 “Add Files to RainCat”，把我们的音乐添加到项目里。这和我们添加音效的操作一样。

然后，我们需要创建一个名为 `SoundManager.swift` 新文件，正如你在上面图片中看到的那样。这将用来作为播放音乐的单例，对音效而言，我们并不介意两个音效重叠，但是如果有两个背景音乐同时播放那将是一件很恐怖的事。所以我们需要实现 `SoundManager`：

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

在 `SoundManager` 类中，我们需要使用 [单例](https://www.codefellows.org/blog/singletons-and-swift/)<sup>[\[25\]](#note-25)</sup> 来创建 `SoundManager`，来处理巨大的音轨文件并且按顺序连续播放它们。为了处理更长时间的音频文件，我们需要使用 `AVFoundation`。它是专门为此构建的，而 `SKAction` 并不能边加载边播放一个大音频文件，这和它在加载小的 SFX 文件时不一样。因为这个库一直都存在， `delegate` 是依赖于 [`NSObjects`](https://developer.apple.com/reference/objectivec/nsobject)<sup>[\[26\]](#note-26)</sup>。我们需要使用 [`AVAudioPlayerDelegate`](https://developer.apple.com/reference/avfoundation/avaudioplayerdelegate)<sup>[\[27\]](#note-27)</sup> 来检测音频何时播放完毕。
我们需要持有现在正在播放的 `audioPlayer` 变量，以用来实现静音操作。

现在我们有当前音轨的位置，我们可以按照文件名数组来播放下一个音轨。当然我们也应该遵守 [Bensound](http://www.bensound.com/royalty-free-music)<sup>[\[28\]](#note-28)</sup><sup>[\[17\]](#note-17)</sup> 协议许可。

我们需要实现默认的 `init` 函数，在这里，我们将随机选择起始音乐，这样我们不用总是在游戏开始时听同样的音乐。在这之后，我们需要等待程序告诉我们开始播放操作。在 `startPlaying` 函数中，我们需要检查当前播放器是否正在播放，如果没有，我们开始尝试播放被选中的音乐。我们需要启动音乐播放器，因为该操作有可能失败，所以我们需要将该操作放到 [try/catch block](https://www.bignerdranch.com/blog/error-handling-in-swift-2/)<sup>[\[29\]](#note-29)</sup> 中。然后，我们准备开始播放选中的音轨，同时设置索引给下一个需要播放的音乐。因此，下面这行代码非常重要：

```
trackPosition = (trackPosition + 1) % SoundManager.tracks.count
```

这行代码会通过增加索引值来设置音轨的下个位置，然后会执行 [modulo](https://en.wikipedia.org/wiki/Modulo_operation)<sup>[\[30\]](#note-30)</sup> 操作，以保持索引值不会越界。最后，在 `audioPlayerDidFinishPlaying(_ player:successfully flag:)` 函数中，我们实现了 `delegate` 方法，这可以让我们知道音乐播放完毕。现在，我们并不需要关心这个方法是否成功——只要在这个方法被调用时播放下一个音乐就好了。

### 按下 Play 键 

现在我们已经实现了 `SoundManager`，我们就需要告诉它什么时候开始运行，这样我们就有无限循环播放的背景音乐了。让我们重新打开 `GameViewController.swift` 文件，然后将下面这行代码放到初始化场景的地方：

```
SoundManager.sharedInstance.startPlaying()
```


我们在 `GameViewController` 里执行这个操作，是因为我们需要音乐独立于场景。如果我们在这个时候运行 app，而且所有的东西都已经被正确地添加到了项目中，我们就可以听到背景音乐了！

在本课中，我们主要实现了两个部分：精灵动画和声音。我们使用了一个基于帧的动画来使精灵可以动起来，用了 SKAction 来实现，并使用了一些方法来重设我们被雨滴击中的小猫。我们使用了 `SKAction` 来添加了音效，并指定了当小猫被雨击中时来播放音效。 最后，我们为我们的游戏添加了初始背景音乐。

到这里，恭喜！我们的游戏即将完成！如果你有什么不明白的地方，请仔细检查我们在 [在Github](https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-two)<sup>[\[31\]](#note-31)</sup> 上的代码。

你做的怎么样了？你的代码和我的差不多吗？如果你做了一些修改，或者有更好的更新，可以通过评论让我知道。

第三节课即将到来！

#### 附录 

1. <a name="note-1"></a>https://developer.apple.com/spritekit/
2. <a name="note-2"></a>https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/
3. <a name="note-3"></a>https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-one
4. <a name="note-4"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/raincat_header_sm-preview-opt.png
5. <a name="note-5"></a>https://www.smashingmagazine.com/2016/11/how-to-build-a-spritekit-game-in-swift-3-part-1/
6. <a name="note-6"></a>https://github.com/thirteen23/RainCat/blob/smashing-day-2/dayTwoAssets.zip
7. <a name="note-7"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png
8. <a name="note-8"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/App-assets-large-opt.png
9. <a name="note-9"></a>https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html
10. <a name="note-10"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png
11. <a name="note-11"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Cat-large-opt.png
12. <a name="note-12"></a>https://developer.apple.com/reference/spritekit/sknode/1483087-xscale
13. <a name="note-13"></a>http://soundbible.com/tags-cat-meow.html
14. <a name="note-14"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png
15. <a name="note-15"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Finder-Mode-Activated-large-opt.png
16. <a name="note-16"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-SFX-preview-opt.png
17. <a name="note-17"></a>http://www.bensound.com/royalty-free-music
18. <a name="note-18"></a>http://www.bensound.com/licensing](#note-18)
19. <a name="note-19"></a>http://www.bensound.com/royalty-free-music/track/little-idea
20. <a name="note-20"></a>http://www.bensound.com/royalty-free-music/track/clear-day
21. <a name="note-21"></a>http://www.bensound.com/royalty-free-music/track/jazzy-frenchy
22. <a name="note-22"></a>http://www.bensound.com/royalty-free-music/track/jazz-comedy
23. <a name="note-23"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png
24. <a name="note-24"></a>https://www.smashingmagazine.com/wp-content/uploads/2016/10/Adding-in-some-music-tracks-large-opt.png
25. <a name="note-25"></a>https://www.codefellows.org/blog/singletons-and-swift/
26. <a name="note-26"></a>https://developer.apple.com/reference/objectivec/nsobject
27. <a name="note-27"></a>https://developer.apple.com/reference/avfoundation/avaudioplayerdelegate
28. <a name="note-28"></a>http://www.bensound.com/royalty-free-music
29. <a name="note-29"></a>https://www.bignerdranch.com/blog/error-handling-in-swift-2/
30. <a name="note-30"></a>https://en.wikipedia.org/wiki/Modulo_operation
31. <a name="note-31"></a>https://github.com/thirteen23/RainCat/releases/tag/smashing-magazine-lesson-two

