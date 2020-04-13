> * 原文地址：[Combine: Getting Started](https://www.raywenderlich.com/7864801-combine-getting-started)
> * 原文作者：[Fabrizio Brancati](https://www.raywenderlich.com/u/fbrancati) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/combine-getting-started.md](https://github.com/xitu/gold-miner/blob/master/TODO1/combine-getting-started.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：

# 0202 年了，是时候学习 Combine 了

> 学习使用 Combine 框架中的 Publisher(发布者) 和 Subscriber(订阅者) 处理事件流，合并多个发布者。

Combine 框架是在 2019 年的 WWDC 上登场的，它是苹果公司新推出的“响应式”框架，用来处理随时间变化的事件。你可以用 Combine 来统一和简化像代理、通知、定时器、完成回调这样的代码。在 iOS 平台上，之前也一直有可用的第三方响应式框架，但是现在苹果开发了自己的框架。

在本教程中，你将学到：

- 使用 `Publisher` 和 `Subscriber`。
- 处理事件流。
- 用 Combine 框架中的方式使用 `Timer` 。
- 确定什么时候在你的项目中使用 Combine。

我们通过优化 FindOrLose 来学习这些核心概念。FindOrLose 是一个游戏，它的玩法是让你快速辨别四张图中不同与其他三张的图片。

准备好探索 iOS 中 Combine 的奇妙世界吗？是时候开始了！

## 入门

你可以在这里下载本教程的[项目资源](https://koenig-media.raywenderlich.com/uploads/2020/04/FindOrLose.zip)。

打开 starter 项目，查看一下项目文件。

你必须先在 [Unsplash Developers Portal](https://unsplash.com/developers) 上注册，获取一个 API key，才能玩这个游戏。注册完之后，你需要在他们的开发者门户网站上创建一个 App。创建完成后，你会在屏幕上看到下面的内容：

[![Creating Unsplash app to get the API key](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalUnsplashFindOrLose-634x500.jpg)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalUnsplashFindOrLose.jpg)

> 注释: Unsplash APIs 每小时有 50 次的调用上限。我们的游戏很有趣，但不要玩太多哟 :]

打开 UnsplashAPI.swift，然后在 `UnsplashAPI.accessToken` 中添加你的 Unsplash API key，如下：


```swift
enum UnsplashAPI {
  static let accessToken = "<your key>"
  ...
}
```

编译运行。主屏幕上会显示四个灰色正方形，还有一个用于开始或者停止游戏的按钮。

[![First screen of FindOrLose with four gray squares](https://koenig-media.raywenderlich.com/uploads/2020/01/StartScreen-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/StartScreen.png)

点击 Play 开始游戏：

[![First run of FindOrLose with four images](https://koenig-media.raywenderlich.com/uploads/2020/01/StartGaming-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/StartGaming.png)

现在，这个游戏完全工作正常，但是请看看 GameViewController.swift 文件中的 `playGame()`，这个方法的结尾是这样的：


```
            }
          }
        }
      }
    }
  }
```
有太多内嵌的闭包了。你能理清里面的逻辑和顺序吗？如果你想改变它们的顺序或者增加新功能要怎么办？Combine 帮你的时候到了。

## Combine 介绍

Combine 框架提供了一套声明式的 API 来计算随时间变化的值。它主要有三个要素：

1. Publishers: 产生值
2. Operators: 对值进行运算
3. Subscribers: 接收值

下面依次来看每一个要素：

### Publishers

遵循 `Publisher` 协议的对象能发送随时间变化的值序列。协议中有两个关联类型：`Output`，是产生值的类型；`Failure`，是遇到的异常类型。

每一个发布者可以发送多种事件：

- `Output` 类型的输出值
- 成功回调
- `Failure` 类型的异常输出

在 Foundation 框架中已经优化了一些类型的性能，用来支持 Publishers，包括 `Timer` 和 `URLSession`，在本教程也会用到它们。

### Operators

Operators 是特殊的方法，它能被 Publishers 调用并且返回相同的或者不同的 Publisher。Operator 描述了对一个值进行修改、增加、删除或者其他操作的行为。你可以通过链式调用将这些操作组合在一起，进行复杂的运算。

想象一下，值从原始的 Publisher 开始流动，然后经过一系列运算。就像一条河，值从上游的 Publisher 流向下游的 Publisher。

### Subscribers

如果没有监听这些发布的事件，Publishers 和 Operators 就没有意义。所以我们需要 Subscriber 来监听。

`Subscriber` 是另外的协议。跟 `Publisher` 一样，它也有两个关联类型：`Input` 和 `Failure`。它们必须和 Publisher 中的 `Output` 和 `Failure` 类型相对应。

订阅者接收来自于发布者的值、成功或者异常的事件流。

### 组合

当你调用发布者的 `subscribe(_:)` 方法时，它就开始发送值，传递给订阅者。这个时候，发布者会给订阅者发送一个订阅消息。订阅者就可以用这个消息向发布者请求数据。

这些完成之后，发布者就可以自由地向订阅者传值了。有可能会传送所有请求的值，有可能不会传这么多。如果发布者是有限的，它最终会返回完成事件或者错误事件。下面的图表总结了这个过程：

[![Publisher-Subscriber pattern](https://koenig-media.raywenderlich.com/uploads/2020/01/Publisher-Subscriber-474x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/Publisher-Subscriber.png)

## 在网络层使用 Combine

上文是对 Combine 的概述。现在我们在项目中使用它。

首先，你需要创建 `GameError` 枚举来处理所有的 `Publisher` 错误。在 Xcode 的主目录中，进入 File ▸ New ▸ File... 选项卡，然后选择 template iOS ▸ Source ▸ Swift File。

给这个新文件命名为 GameError.swift，然后添加到 Game 文件夹中。

下面完善 `GameError` 这个枚举：

```swift
enum GameError: Error {
  case statusCode
  case decoding
  case invalidImage
  case invalidURL
  case other(Error)

  static func map(_ error: Error) -> GameError {
    return (error as? GameError) ?? .other(error)
  }
}
```

这里定义了你在玩游戏时所有可能遇到的错误，再加上一个处理任意类型错误的函数，确保这个错误是 GameError 类型。当你处理发布者的时候就会用到这些。

有了这些，你就可以准备处理 HTTP 状态码和 decoding 中的错误了。

下一步，导入 Combine 框架。打开 UnsplashAPI.swift，在文件的开头加入下面这段：

```swift
import Combine
```

然后把 `randomImage(completion:)` 的签名改成如下：

```swift
static func randomImage() -> AnyPublisher<RandomImageResponse, GameError> {
```

现在这个方法没有把回调闭包作为参数。而是返回了一个发布者，它的 output 是 RandomImageResponse 类型，faliure 是 GameError 类型。

`AnyPublisher` 是一个系统类型，你可以用它来包装“任意”发布者。这意味着，如果你想用操作者或者对调用者隐藏实现细节，就不必去更新方法签名了。

下一步，我们改下代码，让 `URLSession` 支持 Combine 的新功能。找到以 `session.dataTask(with:` 开头的那一行。从这行开始到方法的末尾，用下面的代码替换。

```swift
// 1
return session.dataTaskPublisher(for: urlRequest)
  // 2
  .tryMap { response in
    guard
      // 3
      let httpURLResponse = response.response as? HTTPURLResponse,
      httpURLResponse.statusCode == 200
      else {
        // 4
        throw GameError.statusCode
    }
    // 5
    return response.data
  }
  // 6
  .decode(type: RandomImageResponse.self, decoder: JSONDecoder())
  // 7
  .mapError { GameError.map($0) }
  // 8
  .eraseToAnyPublisher()
```

这看起来有很多代码，但是它用到了很多 Combine 的特性。下面一步一步来讲解：

1. URL session 返回了 URL 请求的发布者。它是一个 `URLSession.DataTaskPublisher` ，输出的类型是 (data: Data, response: URLResponse)。这不是正确的输出类型，所以你要用一系列操作者进行转换来达到目的。
2. 使用 `tryMap` 操作者。这个操作会接收上游的值，尝试将它转换成不同的类型，并且可能会抛出错误。也有一个叫 `map` 的操作者可以执行映射操作，但它不会抛出错误。
3. 检查 HTTP 状态是否为 `200 OK`。
4. 如果 HTTP 状态码不是 `200 OK`，抛出自定义的 `GameError.statusCode` 错误。
5. 如果一切都 OK，返回 `response.data`。这意味着现在链式调用的输出类型是 `Data`。
6. 使用 `decode` 操作者，它将尝试用 `JSONDecoder` 从上游的值用创建 `RandomImageResponse`。现在你的输出类型才是正确的。
7. 你的错误类型还不完全正确。如果在 decode 的过程中产生了错误，错误的类型不会是 GameError。使用 GameError 中定义的方法，可以让你通过 mapError 操作者把任意的错误类型映射成你想要的错误类型。
8. 如果这个时候让你查看一下 `mapError` 的返回类型，你可能会被吓到。`.eraseToAnyPublisher` 操作者会帮你把一切都收拾好，让返回值会更有可读性。

现在，你几乎可以在一个操作者中完成全部逻辑，但是这不是 Combine 真正的思想。思考一下，像 UNIX 中的工具，每一步做一件事情，然后传递结果。

### 用 Combine 框架下载图片

你已经掌握了网络层的逻辑，现在用它可以下载一些图片了。

打开 ImageDownloader.swift 文件，然后在文件的开头用下面的代码导入 Combine：

```swift
import Combine
```

和 `randomImage` 一样，有了 Combine 你不必使用闭包。用下面的代码替换 `download(url:, completion:)` 方法：

```swift
// 1
static func download(url: String) -> AnyPublisher<UIImage, GameError> {
  guard let url = URL(string: url) else {
    return Fail(error: GameError.invalidURL)
      .eraseToAnyPublisher()
  }

  //2
  return URLSession.shared.dataTaskPublisher(for: url)
    //3
    .tryMap { response -> Data in
      guard
        let httpURLResponse = response.response as? HTTPURLResponse,
        httpURLResponse.statusCode == 200
        else {
          throw GameError.statusCode
      }

      return response.data
    }
    //4
    .tryMap { data in
      guard let image = UIImage(data: data) else {
        throw GameError.invalidImage
      }
      return image
    }
    //5
    .mapError { GameError.map($0) }
    //6
    .eraseToAnyPublisher()
}
```

这里的代码与之前例子中的很类似。下面一步一步来讲解：

1. 跟之前一样，修改方法签名。让它返回一个发布者，而不是接收闭包参数。
2. 获得图片 URL 的 `dataTaskPublisher`。
3. 使用 `tryMap` 检查响应码，如果没有错误，就提取数据。
4. 用另一个 `tryMap` 操作者把上游的 `Data` 转换成 `UIImage`，如果失败，就抛出一个错误。
5. 将错误映射成 `GameError` 类型。
6. `.eraseToAnyPublisher` 用来返回一个优雅的类型

### 使用 Zip

你已经修改了所有网络相关的方法，用发布者来代替回调闭包。现在，可以使用这些方法了。

打开 GameViewController.swift，在文件的开头导入 Combine：

```swift
import Combine
```

在 `GameViewController` 类的开头加入下面的属性：

```swift
var subscriptions: Set<AnyCancellable> = []
```

这个属性是用来存储所有的订阅消息。目前为止，你已经使用过发布者和操作者，但是仍然没有什么东西可以订阅。

现在，删除 `playGame()` 中所有的代码，在调用 `startLoaders()` 方法的后面，替换下面的代码：

```swift
// 1
let firstImage = UnsplashAPI.randomImage()
  // 2
  .flatMap { randomImageResponse in
    ImageDownloader.download(url: randomImageResponse.urls.regular)
  }
```

在上面的代码中：

1. 获得一个能提供你随机图片的发布者
2. 使用 `flatMap` 操作者，把值从上一个发布者映射为新的发布者。在本例中，你先是在等待获得随机图片调用的输出，然后把它映射成一个可以响应图片下载调用的发布者。

下一步，用同样的逻辑来获取第二张图片。把下面的代码添加到 `firstImage` 后面：


```swift
let secondImage = UnsplashAPI.randomImage()
  .flatMap { randomImageResponse in
    ImageDownloader.download(url: randomImageResponse.urls.regular)
  }
```
现在你已经下载了两张随机图片了。我们可以使用 `zip` 对这些操作进行组合。在 `secondImage` 的后面添加下面的代码：

```swift
// 1
firstImage.zip(secondImage)
  // 2
  .receive(on: DispatchQueue.main)
  // 3
  .sink(receiveCompletion: { [unowned self] completion in
    // 4
    switch completion {
    case .finished: break
    case .failure(let error):
      print("Error: \(error)")
      self.gameState = .stop
    }
  }, receiveValue: { [unowned self] first, second in
    // 5
    self.gameImages = [first, second, second, second].shuffled()

    self.gameScoreLabel.text = "Score: \(self.gameScore)"

    // TODO: Handling game score

    self.stopLoaders()
    self.setImages()
  })
  // 6
  .store(in: &subscriptions)
```

下面的步骤分解：

1. `zip` 通过组合现有的发布者的输出，来创建一个新的发布者。它会一直等待，直到所有的发布者都发送了值，然后把这个组合的值发送给下游。
2. `receive(on:)` 操作者可以让你指定上游的事件在哪里处理。要在 UI 上操作，所以你要使用主队列。
3. 这是你的第一个订阅者。`sink(receiveCompletion:receiveValue:)` 创建了一个订阅者，它会在两个闭包完成时或者收到值的时候执行。
4. 发布者会用两种方式来完成 --- 结束或者失败。如果产生了故障，游戏就会终止。
5. 你已经有了两张随机图片了，把他们加入到数组中随机化，然后更新 UI。
6. 把订阅信息存储到 `subscriptions` 中，用于消除引用。没有引用之后，订阅信息就会取消，发布者也会立即终止。

最后，编译运行吧。

[![Playing the FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/GameWithCombine-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/GameWithCombine.png)

恭喜，现在你的 App 成功使用了 Combine 来处理事件流。

## 加入分数

你也许会注意到，分数逻辑还没有开始工作。在这之前，你在选择图片的同时分数也在倒数，但是现在分数是静止的。现在我们要用 Combine 重构计时器的功能。

首先，用下面的代码来替换 playGame() 方法中的 // TODO: Handling game score，用来恢复原始计时器功能：

```swift
self.gameTimer = Timer
  .scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] timer in
  self.gameScoreLabel.text = "Score: \(self.gameScore)"

  self.gameScore -= 10

  if self.gameScore <= 0 {
    self.gameScore = 0

    timer.invalidate()
  }
}
```

在上面的代码中，计划让 `gameTimer` 每 `0.1` 秒触发一次，同时让分数减小 `10`。当分数达到 `0` 的时候，终止定时器。

现在编译运行一下，确定游戏分数随着时间流逝在减小。

[![Game score decreases as time elapses](https://koenig-media.raywenderlich.com/uploads/2020/01/ScoreDecreases-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/ScoreDecreases.png)

## 在 Combine 中使用定时器

定时器是另外一种加入了 Combine 功能的 Foundation 类型。现在我们迁移到 Combine 的版本来看看差异。

在 `GameViewController` 的顶部，修改  `gameTimer` 的定义。

```swift
var gameTimer: AnyCancellable?
```

现在是在定时器里存储一个订阅消息，而不是定时器本身。在 Combine 中我们使用 `AnyCancellable`。

用下的代码替换 `playGame()` 和 `stopGame()` 方法的第一行：

```swift
gameTimer?.cancel()
```

现在用下面的代码在 `playGame()` 方法中修改 `gameTimer` 的赋值：

```swift
// 1
self.gameTimer = Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
  // 2
  .autoconnect()
  // 3
  .sink { [unowned self] _ in
    self.gameScoreLabel.text = "Score: \(self.gameScore)"
    self.gameScore -= 10

    if self.gameScore < 0 {
      self.gameScore = 0

      self.gameTimer?.cancel()
    }
  }
```

下面是分解步骤：

1. 用这个新 API 可以通过 Timer 产生发布者。这个发布者会在给定的时间间隔下，给定的 runloop 上重复发送当前的时间。
2. 这个发布者是一个特殊的发布者类型，它需要明确告知开始和结束de 时机。当订阅消息开始或者取消时，`.autoconnect` 操作者通过连接或者断开连接来进行管理。
3. 这个发布者不可能异常，所以你不用处理回调。在这个例子中，`sink` 创建了一个用闭包来计算值的订阅者。

编译运行，玩一下你的 Combine App吧。

[![FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGame-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGame.png)

## 改进 App

这里我们还有几个待优化的地方。你连续地通过 `.store(in: &subscriptions)` 添加订阅者，但并没有移除它们。下面我们来修复。

在 `resetImages()` 的顶部添加下面一行代码

```swift
subscriptions = []
```

这里，你赋值了一个空数组，用来移除所有无用订阅信息的引用。

下一步，在 `stopGame()` 方法的顶部添加下面一行代码：

```swift
subscriptions.forEach { $0.cancel() }
```

这里，你遍历了所有的 `subscriptions`，然后取消了它们。

最后一次编译运行了。

[![FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGameGIF-1.gif)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGameGIF-1.gif)

## 用 Combine 做所有的事情！

使用 Combine 框架是一个很好的选择。它既流行又新颖，而且还是官方的，所以为什么不现在就用呢？不过在你打算全面使用之前，你得考虑一些事情：

### iOS 低版本

首先，你得为用户考虑。如果你打算继续支持 iOS 12，你就不能使用 Combine。(Combine 需要 iOS 13 及以上的版本才支持)

### 团队

响应式编程在思维上的转变很大，会有学习曲线，但是你的团队要赶进度。在你的团队中是否每个人都像你一样敏锐，去改变事物的工作方式呢？

### 其他的 SDK

在采用 Combine 之前，思考一下你的 app 中已经用到的技术。如果你有其他基于回调的 SDK，比如 Core Bluetooth，你必须用 Combine 对它们进行封装。

### 逐渐整合

当你开始逐渐使用 Combine 时，就可以减轻这些顾虑了。从网络层调用开始使用，然后切换到 app 的其他部分。也可以考虑在你现在使用闭包的地方使用 Combine。

## 接下来怎么学？

You can download the completed version of the project using the Download Materials button at [original article page](https://www.raywenderlich.com/7864801-combine-getting-started).

本教程中，你学到了 Combine 背后的 `Publisher` 和 `Subscriber`。你也学到了操作者和定时器。恭喜，你已经对这项技术入门了！

想学习更多 Combine 的用法，请看我们的书籍 [Combine: Asynchronous Programming with Swift](https://store.raywenderlich.com/products/combine-asynchronous-programming-with-swift) !

如果你对本教程有问题或者评价，请加入下面的论坛！


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
