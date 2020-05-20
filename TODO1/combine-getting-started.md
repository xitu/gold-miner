> * 原文地址：[Combine: Getting Started](https://www.raywenderlich.com/7864801-combine-getting-started)
> * 原文作者：[Fabrizio Brancati](https://www.raywenderlich.com/u/fbrancati) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/combine-getting-started.md](https://github.com/xitu/gold-miner/blob/master/TODO1/combine-getting-started.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[lsvih](https://github.com/lsvih)

# 0202 年了，是时候学习 Combine 了

> 学习如何使用 Combine 框架中的 Publisher（发布者）和 Subscriber（订阅者）来处理随时间变化的事件流，合并多个 publisher。

在 2019 年的 WWDC 大会上，Combine 框架登场，它是苹果公司新推出的“响应式”框架，用来处理随时间变化的事件。你可以用 Combine 来统一和简化像代理、通知、定时器、完成回调这样的代码。在 iOS 平台上，之前也有可用的第三方响应式框架，但现在苹果开发了自己的框架。

在本教程中，你将学到：

- 使用 `Publisher` 和 `Subscriber`。
- 处理事件流。
- 用 Combine 框架中的方式使用 `Timer`。
- 确定在项目中使用 Combine 的时机。

我们通过优化 FindOrLose 来学习这些核心概念。FindOrLose 是一个游戏，它的玩法是：在四张图中，有一张图与其他三张图不同，你需要快速辨别出这张图。

准备好探索 iOS 中 Combine 的奇妙世界吗？是时候开始了！

## 入门

你可以在这里下载本教程的[项目资源](https://koenig-media.raywenderlich.com/uploads/2020/04/FindOrLose.zip)。

打开 starter 项目，查看一下项目文件。

在玩游戏之前，你必须先在 [Unsplash Developers Portal](https://unsplash.com/developers) 上注册并获取一个 API key。注册完之后，在他们的开发者门户网站上创建一个 App。创建完成后，在屏幕上看到下面的内容：

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

现在，游戏运行完全正常，但是请看看 GameViewController.swift 文件中的 `playGame()`，这个方法的结尾是这样的：


```
            }
          }
        }
      }
    }
  }
```

有太多内嵌的闭包了。你能理清里面的逻辑和顺序吗？如果你想改变调用顺序或者增加新功能，要怎么办？Combine 帮你的时候到了。

## Combine 介绍

Combine 框架提供了一套声明式的 API，用来计算随时间变化的值。它有三个要素：

1. Publishers：产生值
2. Operators：对值进行运算
3. Subscribers：接收值

下面我们依次来看每一个要素：

### Publishers

遵循 `Publisher` 协议的对象能发送随时间变化的值序列。协议中有两个关联类型：`Output` 是产生值的类型；`Failure` 是异常类型。

每一个 publisher 可以发送多种事件：

- `Output` 类型的值输出
-  完成回调
- `Failure` 类型的异常输出

为了支持 Publishers，在 Foundation 框架中已经优化了一些类型的函数式特性，比如 `Timer` 和 `URLSession`。在本教程我们也会用到它们。

### Operators

Operators 是特殊的方法，它能被 Publishers 调用并且返回相同的或者不同的 Publisher。Operator 描述了对一个值进行修改、增加、删除或者其他操作的行为。你可以通过链式调用将这些操作组合在一起，进行复杂的运算。

想象一下，值从原始的 Publisher 开始流动，然后经过一系列 Operator 的处理，形成新的 Publisher。这个过程就像一条河，值从上游的 Publisher 流向下游的 Publisher。

### Subscribers

如果没有监听这些发布的事件，Publishers 和 Operators 就没有意义。所以我们需要 Subscriber 来监听。

`Subscriber` 是另一个协议。跟 `Publisher` 协议类似，它也有两个关联类型：`Input` 和 `Failure`。这两个类型必须和 Publisher 中的 `Output` 和 `Failure` 类型相对应。

Subscriber 接收 Publisher 的值序列以及正常或者异常的事件。

### 组合

在调用 publisher 的 `subscribe(_:)` 方法时，它就准备给 subscriber 传值。这个时候，publisher 会给 subscriber 发送一个 subscription。subscriber 就可以用这个 subscription 向 publisher 请求数据。

这些完成之后，publisher 就可以自由地向 subscriber 传送数据了。在这个过程中，publisher 有可能会传送请求的所有数据，有可能只会传送部分数据。如果 publisher 是有限事件流，它最终会以完成事件或者错误事件结束。下面的图表总结了这个过程：

[![Publisher-Subscriber pattern](https://koenig-media.raywenderlich.com/uploads/2020/01/Publisher-Subscriber-474x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/Publisher-Subscriber.png)

## 在网络层使用 Combine

上文是对 Combine 的概述。现在我们在项目中使用它。

首先，创建 `GameError` 枚举来处理所有的 `Publisher` 错误。在 Xcode 的主目录中，进入 File ▸ New ▸ File... 选项卡，然后选择 template iOS ▸ Source ▸ Swift File。

给这个新文件命名为 GameError.swift，然后添加到 Game 文件夹中。

下面来完善 `GameError` 这个枚举：

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

枚举中定义了在游戏中所有可能遇到的错误，还定义了一个处理任意类型错误的方法，用来保证错误是 GameError 类型。我们在处理 publisher 的时候就会用到。

有了这些，我们就可以处理 HTTP 状态码和 decoding 中的错误了。

下一步，导入 Combine 框架。打开 UnsplashAPI.swift，在文件的开头加入下面这段：

```swift
import Combine
```

然后把 `randomImage(completion:)` 的签名改成如下:

```swift
static func randomImage() -> AnyPublisher<RandomImageResponse, GameError> {
```

现在这个方法没有把回调闭包作为参数，而是返回了一个 publisher，它的 output 是 RandomImageResponse 类型，faliure 是 GameError 类型。

`AnyPublisher` 是一个系统类型，你可以用它来包装“任意”的 publisher。这意味着，如果你想使用 operators 或者对调用者隐藏实现细节时，就不必修改方法签名了。

下一步，我们来修改代码，让 `URLSession` 支持 Combine 的新功能。找到以 `session.dataTask(with:` 开头的那一行，从这行开始到方法的末尾，用下面的代码替换。

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

这段代码看起来有很多，但是它用到了很多 Combine 的特性。下面一步一步来讲解：

1. URL session 返回了 URL 请求的 publisher。这个 publisher 是 `URLSession.DataTaskPublisher` 类型，它的 output 类型是 (data: Data, response: URLResponse)。这不是正确的输出类型，所以你要用一系列 operator 进行转换来达到目的。
2. 使用 `tryMap`。这个 operator 会接收上游的值，并尝试将它映射成其它的类型，映射过程中可能会抛出错误。还有一个叫 `map` 的 operator 可以执行映射操作，但它不会抛出错误。
3. 检查 HTTP 状态是否为 `200 OK`。
4. 如果 HTTP 状态码不是 `200 OK`，抛出自定义的 `GameError.statusCode` 错误。
5. 如果一切都 OK，返回 `response.data`。这意味着现在链式调用的输出类型是 `Data`。
6. 使用 `decode`，它将尝试用 `JSONDecoder` 把上游的值解析为 `RandomImageResponse`类型。到这一步，输出类型才是正确的。
7. 错误类型没有完全正确。如果在 decode 的过程中产生了错误，错误的类型不会是 GameError。在 mapError 这个 operator 中，我们使用 GameError 中定义的方法，把任意的错误类型映射成你想要的错误类型。
8. 如果查看一下 `mapError` 的返回类型，你可能会被吓到。`.eraseToAnyPublisher` 操作者会帮你把一切都收拾好，让返回值会更有可读性。

上面的绝大部分逻辑，你也可以在一个 operator 中实现，但这明显不是 Combine 的思想。你可以思考一下 UNIX 中的一些工具，它们每一步只做一件事情，然后把每一步中的结果向下一步传递。

### 用 Combine 框架下载图片

重构好了网络层的逻辑，我们来下载图片

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

这里的代码与之前例子中的非常类似。下面一步一步来讲解：

1. 跟之前一样，修改方法签名。让它返回一个 publisher，而不是接收闭包参数。
2. 获得图片 URL 的 `dataTaskPublisher`。
3. 使用 `tryMap` 检查响应码，如果没有错误，就提取数据。
4. 用另一个 `tryMap` 操作者把上游的 `Data` 转换成 `UIImage`，如果失败，就抛出错误。
5. 将错误映射成 `GameError` 类型。
6. `.eraseToAnyPublisher` 返回一个优雅的类型

### 使用 Zip

我们已经用 publisher 来代替回调闭包修改完了所有网络相关的方法。现在，我们来调用这些方法。

打开 GameViewController.swift，在文件的开头导入 Combine：

```swift
import Combine
```

在 `GameViewController` 类的开头加入下面的属性：

```swift
var subscriptions: Set<AnyCancellable> = []
```

这个属性是用来存储所有的 subscriptions。目前为止，我们使用过 publishers 和 operators，但是没有订阅。

删除 `playGame()` 中所有的代码，在 `startLoaders()` 方法调用的后面，用下面的代码替换：

```swift
// 1
let firstImage = UnsplashAPI.randomImage()
  // 2
  .flatMap { randomImageResponse in
    ImageDownloader.download(url: randomImageResponse.urls.regular)
  }
```

在上面的代码中：

1. 获得一个随机图片的 publisher。
2. 使用 `flatMap`，把上一个 publisher 的值映射为新的 publisher。在本例中，你首先调用了 randomImage，获得了 output 后，将它映射成下载图片的 publisher。

下一步，我们用同样的逻辑来获取第二张图片。把下面的代码添加到 `firstImage` 后面：


```swift
let secondImage = UnsplashAPI.randomImage()
  .flatMap { randomImageResponse in
    ImageDownloader.download(url: randomImageResponse.urls.regular)
  }
```
现在我们已经下载了两张随机图片了。用 `zip` 对这些操作进行组合。在 `secondImage` 的后面添加下面的代码：

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

1. `zip` 通过组合现有的 pulisher 的 output，来创建一个新的 publisher。它会等所有的 publisher 都发送 output 之后，才会把组合值发送给下游。
2. `receive(on:)` 可以指定上游的事件在哪里处理。如果要在 UI 上操作，就必须使用主队列。
3. 这是我们的第一个 subscriber。`sink(receiveCompletion:receiveValue:)` 创建了一个 subscriber，它有两个闭包参数。当收到完成事件或者正常值时，闭包就会调用。
4. Publisher 有两种方式结束调用 — 完成或者异常。如果产生了异常，游戏就会终止。
5. 将两张随机图片的数据加入到数组中进行随机化，然后更新 UI。
6. 把订阅信息存储到 `subscriptions` 中，用于消除引用。没有引用之后，订阅信息就会取消，publisher 也会立即停止发送。

最后，编译运行吧。

[![Playing the FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/GameWithCombine-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/GameWithCombine.png)

恭喜，现在你的 App 成功使用了 Combine 来处理事件流。

## 加入分数

你也许会注意到，分数逻辑没有起作用。重构之前，我们选择图片的同时分数也在倒数，但是现在分数是静止的。现在我们要用 Combine 重构计时器的功能。

首先，用下面的代码替换 playGame() 方法中的 `// TODO: Handling game score`，用来恢复计时器功能：

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

在上面的代码中，我们打算让 `gameTimer` 每 `0.1` 秒触发一次，同时让分数减小 `10`。当分数达到 `0` 的时候，终止定时器。

现在编译运行，确定游戏分数是否随着时间流逝在减小。

[![Game score decreases as time elapses](https://koenig-media.raywenderlich.com/uploads/2020/01/ScoreDecreases-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/ScoreDecreases.png)

## 在 Combine 中使用定时器

定时器是另外一种支持 Combine 功能的 Foundation 类型。现在我们把定时器迁移到 Combine 的版本来看看差异。

在 `GameViewController` 的顶部，修改  `gameTimer` 的定义。

```swift
var gameTimer: AnyCancellable?
```

现在是在定时器里存储一个 subscription，而不是定时器本身。在 Combine 中我们使用 `AnyCancellable`。

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

1. 用这个新 API 可以通过 Timer 创建 publisher。这个 publisher 会在给定的时间间隔下和给定的 runloop 上重复发送当前的时刻。
2. 这个 publisher 是一个特殊的 Publisher 类型，它需要明确指定开始和结束的 时机。当订阅开始或取消时，`.autoconnect` 通过连接或者断开连接来进行管理。
3. 这个 publisher 不可能异常，所以不用处理异常回调。在这个例子中，`sink` 创建的 subscriber，只需要处理正常值。

编译运行，玩一下你的 Combine App 吧。

[![FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGame-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGame.png)

## 改进 App

这里还有几个待优化的地方，我们用 `.store(in: &subscriptions)` 连续添加了多个 subscriber，但没有移除它们。下面我们来改进。

在 `resetImages()` 的顶部添加下面这行代码:

```swift
subscriptions = []
```

这里，你声明了一个空数组，用来移除所有无用订阅信息的引用。

下一步，在 `stopGame()` 方法的顶部添加下面这行代码:

```swift
subscriptions.forEach { $0.cancel() }
```

这里，你遍历了所有的 `subscriptions`，然后取消了它们。

最后一次编译运行了。

[![FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGameGIF-1.gif)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGameGIF-1.gif)

## 用 Combine 做所有的事情！

使用 Combine 框架是一个很好的选择。它既流行又新颖，而且还是官方的，为什么不现在就用呢？不过在你打算全面使用之前，你得考虑一些事情：

### iOS 低版本

首先，你得为用户考虑。如果你打算继续支持 iOS 12，你就不能使用 Combine。（Combine 需要 iOS 13 及以上的版本才支持）

### 团队

响应式编程在思维上的转变很大，会有学习曲线，但是你的团队要赶进度。在你的团队中是否每个人都像你一样热衷于改变固有的工作方式？

### 其他的 SDK

在采用 Combine 之前，思考一下你的 app 中已经用到的技术。如果你有其他基于回调的 SDK，比如 Core Bluetooth，你必须用 Combine 对它们进行封装。

### 逐渐整合

当你逐渐掌握 Combine 时，就没有那么多顾虑了。你可以先从网络层调用开始重构，然后切换到 app 的其他模块。你也可以在使用闭包的地方使用 Combine。

## 接下来怎么学？

你可以在[原文页面](https://www.raywenderlich.com/7864801-combine-getting-started)下载本工程的完整版本。

本教程中，你学习了 Combine 的基础知识：`Publisher` 和 `Subscriber`。你也学会了 operator 和定时器的使用。恭喜，你已经入门了！

想学习更多 Combine 的用法，请看我们的书籍 [Combine: Asynchronous Programming with Swift](https://store.raywenderlich.com/products/combine-asynchronous-programming-with-swift)！

如果你对本教程有问题或者评价，欢迎在下讨论区讨论！


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
