> * 原文地址：[Combine: Getting Started](https://www.raywenderlich.com/7864801-combine-getting-started)
> * 原文作者：[Fabrizio Brancati](https://www.raywenderlich.com/u/fbrancati) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/combine-getting-started.md](https://github.com/xitu/gold-miner/blob/master/TODO1/combine-getting-started.md)
> * 译者：
> * 校对者：

# Combine: Getting Started

> Learn how to use Combine’s Publisher and Subscriber to handle event streams, merge multiple publishers and more.

Combine, announced at WWDC 2019, is Apple's new "reactive" framework for handling events over time. You can use Combine to unify and simplify your code for dealing with things like delegates, notifications, timers, completion blocks and callbacks. There have been third-party reactive frameworks available for some time on iOS, but now Apple has made its own.

In this tutorial, you'll learn how to:

- Use `Publisher` and `Subscriber`.
- Handle event streams.
- Use `Timer` the Combine way.
- Identify when to use Combine in your projects.

You'll see these key concepts in action by enhancing FindOrLose, a game that challenges you to quickly identify the one image that's different from the other three.

Ready to explore the magic world of Combine in iOS? Time to dive in!

## Getting Started

Download the project materials using the Download Materials button at the top or bottom of this tutorial.

Open the starter project and check out the project files.

Before you can play the game, you must register at [Unsplash Developers Portal](https://unsplash.com/developers) to get an API key. After registration, you'll need to create an app on their developer's portal. Once complete, you'll see a screen like this:

[![Creating Unsplash app to get the API key](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalUnsplashFindOrLose-634x500.jpg)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalUnsplashFindOrLose.jpg)

> Note: Unsplash APIs have a rate limit of 50 calls per hour. Our game is fun, but please avoid playing it too much :]

Open UnsplashAPI.swift and add your Unsplash API key to `UnsplashAPI.accessToken` like this:


```swift
enum UnsplashAPI {
  static let accessToken = "<your key>"
  ...
}
```

Build and run. The main screen shows you four gray squares. You'll also see a button for starting or stopping the game:

[![First screen of FindOrLose with four gray squares](https://koenig-media.raywenderlich.com/uploads/2020/01/StartScreen-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/StartScreen.png)

Tap Play to start the game:

[![First run of FindOrLose with four images](https://koenig-media.raywenderlich.com/uploads/2020/01/StartGaming-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/StartGaming.png)

Right now, this is a fully working game, but take a look at `playGame()` in GameViewController.swift. The method ends like this:

```
            }
          }
        }
      }
    }
  }
```

That's too many nested closures. Can you work out what's happening, and in what order? What if you wanted to change the order things happen in, or bail out, or add new functionality? Time to get some help from Combine!

## Introduction to Combine

The Combine framework provides a declarative API to process values over time. There are three main components:

1. Publishers: Things that produce values.
2. Operators: Things that do work with values.
3. Subscribers: Things that care about values.

Taking each component in turn:

### Publishers

Objects that conform to `Publisher` deliver a sequence of values over time. The protocol has two associated types: `Output`, the type of value it produces, and `Failure`, the type of error it could encounter.

Every publisher can emit multiple events:

- An output value of `Output` type.
- A successful completion.
- A failure with an error of `Failure`type.

Several Foundation types have been enhanced to expose their functionality through publishers, including `Timer` and `URLSession`, which you'll use in this tutorial.

### Operators

Operators are special methods that are called on publishers and return the same or a different publisher. An operator describes a behavior for changing values, adding values, removing values or many other operations. You can chain multiple operators together to perform complex processing.

Think of values flowing from the original publisher, through a series of operators. Like a river, values come from the upstream publisher and flow to the downstream publisher.

### Subscribers

Publishers and operators are pointless unless something is listening to the published events. That something is the `Subscriber`.

`Subscriber` is another protocol. Like `Publisher`, it has two associated types: `Input` and `Failure`. These must match the `Output` and `Failure` of the publisher.

A subscriber receives a stream of value, completion or failure events from a publisher.

### Putting it together

A publisher starts delivering values when you call `subscribe(_:)` on it, passing your subscriber. At that point, the publisher sends a subscription to the subscriber. The subscriber can then use this subscription to make a request from the publisher for a definite or indefinite number of values.

After that, the publisher is free to send values to the Subscriber. It might send the full number of requested values, but it might also send fewer. If the publisher is finite, it will eventually return the completion event or possibly an error. This diagram summarizes the process:

[![Publisher-Subscriber pattern](https://koenig-media.raywenderlich.com/uploads/2020/01/Publisher-Subscriber-474x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/Publisher-Subscriber.png)

## Networking with Combine

That gives you a quick overview of Combine. Time to use it in your own project!

First, you need to create the `GameError` enum to handle all `Publisher` errors. From Xcode's main menu, select File ▸ New ▸ File... and choose the template iOS ▸ Source ▸ Swift File.

Name the new file GameError.swift and add it to the Game folder.

Now add the `GameError` enum:

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

This gives you all of the possible errors you can encounter while running the game, plus a handy function to take an error of any type and make sure it's a `GameError`. You'll use this when dealing with your publishers.

With that, you're now ready to handle HTTP status code and decoding errors.

Next, import Combine. Open UnsplashAPI.swift and add the following at the top of the file:

```swift
import Combine
```

Then change the signature of `randomImage(completion:)` to the following:

```swift
static func randomImage() -> AnyPublisher<RandomImageResponse, GameError> {
```

Now, the method doesn't take a completion closure as a parameter. Instead, it returns a publisher, with an output type of `RandomImageResponse` and a failure type of `GameError`.

`AnyPublisher` is a system type that you can use to wrap "any" publisher, which keeps you from needing to update method signatures if you use operators, or if you want to hide implementation details from callers.

Next, you'll update your code to use `URLSession`'s new Combine functionality. Find the line that begins `session.dataTask(with:`. Replace from that line to the end of the method with the following code:

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

This looks like a lot of code, but it's using a lot of Combine features. Here's the step-by-step:

1. You get a publisher from the URL session for your URL request. This is a `URLSession.DataTaskPublisher`, which has an output type of `(data: Data, response: URLResponse)`. That's not the right output type, so you're going to use a series of operators to get to where you need to be.
2. Apply the `tryMap` operator. This operator takes the upstream value and attempts to convert it to a different type, with the possibility of throwing an error. There is also a `map` operator for mapping operations that can't throw errors.
3. Check for `200 OK` HTTP status.
4. Throw the custom `GameError.statusCode` error if you did not get a `200 OK` HTTP status.
5. Return the `response.data` if everything is OK. This means the output type of your chain is now `Data`
6. Apply the `decode` operator, which will attempt to create a `RandomImageResponse` from the upstream value using `JSONDecoder`. Your output type is now correct!
7. Your failure type still isn't quite right. If there was an error during decoding, it won't be a `GameError`. The `mapError` operator lets you deal with and map any errors to your preferred error type, using the function you added to `GameError`.
8. If you were to check the return type of `mapError` at this point, you would be greeted with something quite horrific. The `.eraseToAnyPublisher` operator tidies all that mess up so you're returning something more usable.

Now, you could have written almost all of this in a single operator, but that's not really in the spirit of Combine. Think of it like UNIX tools, each step doing one thing and passing the results on.

### Downloading an Image With Combine

Now that you have the networking logic, it's time to download some images.

Open the ImageDownloader.swift file and import Combine at the start of the file with the following code:

```swift
import Combine
```

Like `randomImage`, you don't need a closure with Combine. Replace `download(url:, completion:)` with this:

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

A lot of this code is similar to the previous example. Here's the step-by-step:

1. Like before, change the signature so that the method returns a publisher instead of accepting a completion block.
2. Get a `dataTaskPublisher` for the image URL.
3. Use `tryMap` to check the response code and extract the data if everything is OK.
4. Use another `tryMap` operator to change the upstream `Data` to `UIImage`, throwing an error if this fails.
5. Map the error to a `GameError`.
6. `.eraseToAnyPublisher` to return a nice type.

### Using Zip

At this point, you've changed all of your networking methods to use publishers instead of completion blocks. Now you're ready to use them.

Open GameViewController.swift. Import Combine at the start of the file:

```swift
import Combine
```

Add the following property at the start of the `GameViewController` class:

```swift
var subscriptions: Set<AnyCancellable> = []
```

You'll use this property to store all of your subscriptions. So far you've dealt with publishers and operators, but nothing has subscribed yet.

Now, remove all the code in `playGame()`, right after the call to `startLoaders()`. Replace it with this:

```swift
// 1
let firstImage = UnsplashAPI.randomImage()
  // 2
  .flatMap { randomImageResponse in
    ImageDownloader.download(url: randomImageResponse.urls.regular)
  }
```

In the code above, you:

1. Get a publisher that will provide you with a random image value.
2. Apply the `flatMap` operator, which transforms the values from one publisher into a new publisher. In this case you're waiting for the output of the random image call, and then transforming that into a publisher for the image download call.

Next, you'll use the same logic to retrieve the second image. Add this right after `firstImage`:

```swift
let secondImage = UnsplashAPI.randomImage()
  .flatMap { randomImageResponse in
    ImageDownloader.download(url: randomImageResponse.urls.regular)
  }
```

At this point, you have downloaded two random images. Now it's time to, pardon the pun, *combine* them. You'll use `zip` to do this. Add the following code right after `secondImage`:

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

Here's the breakdown:

1. `zip` makes a new publisher by combining the outputs of existing ones. It will wait until both publishers have emitted a value, then it will send the combined values downstream.
2. The `receive(on:)` operator allows you to specify where you want events from the upstream to be processed. Since you're operating on the UI, you'll use the main dispatch queue.
3. It's your first subscriber! `sink(receiveCompletion:receiveValue:)` creates a subscriber for you which will execute those two closures on completion or receipt of a value.
4. Your publisher can complete in two ways --- either it finishes or fails. If there's a failure, you stop the game.
5. When you receive your two random images, add them to an array and shuffle, then update the UI.
6. Store the subscription in `subscriptions`. Without keeping this reference alive, the subscription will cancel and the publisher will terminate immediately.

Finally, build and run!

[![Playing the FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/GameWithCombine-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/GameWithCombine.png)

Congratulations, your app now successfully uses Combine to handle streams of events!

## Adding a Score

As you may notice, scoring doesn't work any more. Before, your score counted down while you were choosing the correct image, now it just sits there. You're going to rebuild that timer functionality, but with Combine!

First, restore the original timer functionality by replacing `// TODO: Handling game score` in `playGame()` with this code:

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

In the code above, you schedule `gameTimer` to fire every very `0.1` seconds and decrease the score by `10`. When the score reaches `0`, you invalidate `timer`.

Now, build and run to confirm that the game score decreases as time elapses.

[![Game score decreases as time elapses](https://koenig-media.raywenderlich.com/uploads/2020/01/ScoreDecreases-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/ScoreDecreases.png)

## Using Timers in Combine

Timer is another Foundation type that has had Combine functionality added to it. You're going to migrate across to the Combine version to see the differences.

At the top of `GameViewController`, change the definition of `gameTimer`:

```swift
var gameTimer: AnyCancellable?
```

You're now storing a subscription to the timer, rather than the timer itself. This can be represented with `AnyCancellable` in Combine.

Change the first line of`playGame()` and `stopGame()` with the following code:

```swift
gameTimer?.cancel()
```

Now, change the `gameTimer` assignment in `playGame()` with the following code:

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

Here's the breakdown:

1. You use the new API for vending publishers from `Timer`. The publisher will repeatedly send the current date at the given interval, on the given run loop.
2. The publisher is a special type of publisher that needs to be explicitly told to start or stop. The `.autoconnect` operator takes care of this by connecting or disconnecting as soon as subscriptions start or are canceled.
3. The publisher can't ever fail, so you don't need to deal with a completion. In this case, `sink` makes a subscriber that just processes values using the closure you supply.

Build and run and play with your Combine app!

[![FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGame-231x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGame.png)

## Refining the App

There are just a couple of refinements that are missing. You're continuously adding subscribers with `.store(in: &subscriptions)` without ever removing them. You'll fix that next.

Add the following line at the top of `resetImages()`:

```swift
subscriptions = []
```

Here, you assign an empty array that will remove all the references to the unused subscriptions.

Next, add the following line at the top of `stopGame()`:

```swift
subscriptions.forEach { $0.cancel() }
```

Here, you iterate over all `subscriptions` and cancel them.

Time to build and run one last time!

[![FindOrLose game made with Combine](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGameGIF-1.gif)](https://koenig-media.raywenderlich.com/uploads/2020/01/FinalGameGIF-1.gif)

## I want to Combine All The Things Now!

Using Combine may seem like a great choice. It's hot, new, and first party, so why not use it now? Here are some things to think about before you go all-in:

### Older iOS Versions

First of all, you need to think about your users. If you want to continue to support iOS 12, you can't use Combine. (Combine requires iOS 13 or above.)

### Your Team

Reactive programming is quite a change of mindset, and there is going to be a learning curve while your team gets up to speed. Is everyone on your team as keen as you to change the way things are done?

### Other SDKs

Think about the technologies your app already uses before adopting Combine. If you have other callback-based SDKs, like Core Bluetooth, you'll have to build wrappers to use them with Combine.

### Gradual Integration

You can mitigate many of these concerns if you start using Combine gradually. Start from the network calls and then move to the other parts of the app. Also, consider using Combine where you currently have closures.

## Where to Go From Here?

You can download the completed version of the project using the Download Materials button at [original article page](https://www.raywenderlich.com/7864801-combine-getting-started).

In this tutorial, you've learned the basics behind Combine's `Publisher` and `Subscriber`. You also learned about using operators and timers. Congratulations, you're off to a good start with this technology!

To learn even more about using Combine, check out our book [Combine: Asynchronous Programming with Swift](https://store.raywenderlich.com/products/combine-asynchronous-programming-with-swift)!

If you have any questions or comments on this tutorial, please join the forum discussion below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
