
> * 原文地址：[Modelling state in Swift](https://www.swiftbysundell.com/posts/modelling-state-in-swift)
> * 原文作者：[John](https://twitter.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/modelling-state-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/modelling-state-in-swift.md)
> * 译者：[Deepmissea](http://deepmissea.blue)
> * 校对者：[atuooo](http://atuo.xyz)

# 模块化 Swift 中的状态

在构建应用或设计系统的时候，最困难的事情之一就是如何建模并处理状态。当应用的某些部分处于我们意料之外的状态时，管理状态的代码也是一个非常常见的 bug 来源。

这周，让我们看一看能更容易处理并响应状态改变的编码技术 - 让代码更加强壮，不容易出错。在本文中，我不会讨论具体的框架或者更大的应用程序架构范围的更改（比如 RxSwift、ReSwift 或者使用 ELM 风格的架构，我会在之后讨论它们）。相反的，我会专注于小的技巧、窍门和模式，那些真正有用的东西。

## 单一数据源

建立各种状态模型时的一个重要原则就是尽量保持**单一的数据源**。看它是否单一的简单方法是永远不需要检查**多个条件**来决定你的状态是什么。让我们看个栗子。

假设我们在做一个游戏，某个敌人会有一个确定的血量，也会有一个标志来决定他们是否在游戏中。我们可能会构建一个 `Enemy` 类，用两个属性来表示，像这样：

```
class Enemy {
    var health = 10
    var isInPlay = false
}
```

虽然上面代码看起来很直观，但很容易让我们处于一种有多种数据来源的情况。假如一旦敌人的血量到零，就不应该在游戏中。所以在我们的代码中，有一些逻辑来处理：

```
func enemyDidTakeDamage() {
    if enemy.health <= 0 {
        enemy.isInPlay = false
    }
}
```

在我们引入新的代码路径时，忘记执行上述检查，就会发生问题。例如，我们可能给我们的玩家一个特殊的攻击，立即将所有敌人的血量清零：

```
func performSpecialAttack() {
    for enemy in allEnemies {
        enemy.health = 0
    }
}
```

就如你在上面看到的一样，我们更新了所有敌人的 `health` 属性，但是我们忘记了更新 `isInPlay` 属性。这很可能导致一堆 bug，并使我们最终陷入一个未定义的状态。

这种情况下，通过添加多重检查来修复这个问题也许很诱人，像这样：

```
if enemy.isInPlay && enemy.health > 0 {
    // Enemy is *really* in play
} else {
    // Enemy is *really* defeated
}
```

虽然作为一个临时的“邦迪式”解决方案会正常工作，但它很快就会导致代码更难阅读，随着我们添加更多条件和更复杂的状态，它们更脆弱。如果你仔细思考，会觉得做一些像上面的事情有点像不相信我们自己的 API，因为我们不得不对他们进行这样的防御式编码 😕

这个问题的解决方案之一，就是确保我们有单一的数据源，在 `Enemy` 类里面，对 `health` 使用一个 `didSet`，自动更新 `isInPlay` 属性：

```
class Enemy {
    var health = 10 {
        didSet { putOutOfPlayIfNeeded() }
    }

    // Important to only allow mutations of this property from within this class
    private(set) var isInPlay = true

    private func putOutOfPlayIfNeeded() {
        guard health <= 0 else {
            return
        }

        isInPlay = false
        remove()
    }
}
```
这样我们就只需要关心敌人血量的更新，我们可以确保 `isInPlay` 属性会永远的保持同步。

## 让状态彼此独立

上面 `Enemy` 的例子实在太简单，所以我们看一下另一个有着更复杂状态的例子，每个状态都有关联值，我们需要相应的渲染并响应。

假设我们正构建一个视频播放器，它可以让我们从一个确定的 URL 下载并观看视频。要模块化一个视频，我们使用一个 `struct`，像这样：

```
struct Video {
    let url: URL
    var downloadTask: Task?
    var file: File?
    var isPlaying = false
    var progress: Double = 0
}
```

上面的问题是，我们最终有太多的选择，我们无法通过阅读视频模块代码来告诉我们视频的状态具体在哪一步。最终，我们还通常编写复杂的处理，包括在理想情况下不该输入的代码路径：

```
if let downloadTask = video.downloadTask {
    // Handle download
} else if let file = video.file {
    // Perform playback
} else {
    // Uhm... what to do here? 🤔
}
```
解决这种问题，我经常使用一个 `enum` 来定义非常清晰的、独占的状态，像这样：

```
struct Video {
    enum State {
        case willDownload(from: URL)
        case downloading(task: Task)
        case playing(file: File, progress: Double)
        case paused(file: File, progress: Double)
    }

    var state: State
}
```

如上你所看到的，我们已经把所有的选择都删除了，所有状态特定值现在都被并入了他们被使用的状态当中。我们可以通过引入另一个级别的状态来进一步摆脱重复的信息：

```
extension Video {
    struct PlaybackState {
        let file: File
        var progress: Double
    }
}
```

我们可以使用 `playing` 和 `paused` 条件来判断状态：

```
case playing(PlaybackState)
case paused(PlaybackState)
```

## 响应式渲染

可是，如果你开始像上面那样对状态进行建模，但继续编写命令式状态处理代码（使用多个 `if/else` 语句，像上面那样），那事情就会非常丑陋。由于我们需要的所有信息都是“隐藏”在各种条件之下，所以我们需要做很多 `switch` 或 `if case let` 语句来“获得它”。

我们需要把枚举状态与响应式状态处理代码结合起来。举个栗子，让我们看一看如何编码来更新一个视频播放视图控制器中的操作按钮：

```
class VideoPlayerViewController: UIViewController {
    var video: Video {
        // Every time the video changes, we re-render
        didSet { render() }
    }

    fileprivate lazy var actionButton = UIButton()

    private func render() {
        renderActionButton()
    }

    private func renderActionButton() {
        let actionButtonImage = resolveActionButtonImage()
        actionButton.setImage(actionButtonImage, for: .normal)
    }

    private func resolveActionButtonImage() -> UIImage {
        // The image for the action button is declaratively resolved
        // directly from the video state
        switch video.state {
            // We can easily discard associated values that we don't need
            // by simply omitting them
            case .willDownload:
                return .wait
            case .downloading:
                return .cancel
            case .playing:
                return .pause
            case .paused:
                return .play
        }
    }
}
```

现在每次播放状态改变，我们的 UI 都会自动更新。我们有单一数据源，并且没有未定义的状态 🎉 我们可以接着扩展 `render` 函数，以便当状态改变时，自动更新我们所有的 UI。

```
func render() {
    renderActionButton()
    renderVideoSurface()
    renderNavigationBarButtonItems()
    ...
}
```

## 处理状态的变化

渲染是一回事，但通常我们还需要在状态改变时触发某种形式的逻辑。我们可能想要过度到另一个状态，或者开始一个操作。好消息是我们能使用和渲染 UI 时完全相同的模式。

让我们写一个 `handleStateChange` 函数，它也在 `video` 属性中的 `didSet` 被调用。它会根据我们目前所在的状态来运行各种逻辑：

```
private extension VideoPlayerViewController {
    func handleStateChange() {
        switch video.state {
        case .willDownload(let url):
            // Start a download task and enter the 'downloading' state
            let task = Task.download(url: url)
            task.start()
            video.state = .downloading(task: task)
        case .downloading(let task):
            // If the download task finished, start playback
            switch task.state {
            case .inProgress:
                break
            case .finished(let file):
                let playbackState = Video.PlaybackState(file: file, progress: 0)
                video.state = .playing(playbackState)
            }
        case .playing:
            player.play()
        case .paused:
            player.pause()
        }
    }
}
```

## 抽取信息

到目前，我们一直使用 `switch` 语句来执行所有的渲染和状态处理。这样做的好处是，它会“强制”我们思考，所有的状态和条件，并为每一种情况写下适合的逻辑。如果有一个新的状态我们没有处理，它也会让编译器把错误展示给我们。

然而，有时你需要做一些非常具体的事，值影响一个确定的状态，比如我们想在视图控制器离开屏幕时，确保所有正在下载的任务都取消：

```
extension VideoPlayerViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Ideally, we'd like an API like this, that let's us cancel any ongoing
        // download task without having to write a huge switch statement
        video.downloadTask?.cancel()
    }
}
```

像上面那样访问明确的属性非常好，能帮助我们摆脱一大堆的模板代码，如果我们**一直**使用 `switch` 语句来处理状态的话。

所以，让我们把它变成现实！要实现上面的功能，我们只需要简单的传建一个 `Video` 的扩展，使用 Swift 的 `guard case let` 模式匹配语法来抽取任何正在下载的任务：

```
extension Video {
    var downloadTask: Task? {
        guard case let .downloading(task) = state else {
            return nil
        }

        return task
    }
}
```

## 结论

虽然在处理状态时候没有任何捷径，但是以消除歧义并强制明确地定义状态的方式对状态进行建模，通常都会写出更健壮的代码。

使用单一数据源并且响应式的处理状态改变，通常也会让你的代码更加容易阅读与理解，还更容易扩展与重构（只需要添加或删掉一个 `case`，编译器会告诉你，什么代码需要更新）。

这篇文章中我提到的解决方案肯定有取舍，他们的确需要你写一些更多的模板代码，在为状态枚举实现 `Equatable` 的时候也可能会有点棘手（在以后的文章中，我们会看一看如何让代码生成与脚本更容易）。

你怎么看？你已经使用过文中提到的一些技巧吗，还是要试试？告诉我，你可以在下面的评论部分或 Twitter [@johnsundell](https://twitter.com/johnsundell) 上提出任何其他问题或反馈。

感谢阅读！🚀

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
