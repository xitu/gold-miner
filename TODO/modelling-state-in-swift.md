
> * 原文地址：[Modelling state in Swift](https://www.swiftbysundell.com/posts/modelling-state-in-swift)
> * 原文作者：[John](https://twitter.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/modelling-state-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/modelling-state-in-swift.md)
> * 译者：
> * 校对者：

# Modelling state in Swift

One of the hardest things when building apps and designing systems is deciding how to model and deal with state. Code managing state is also a very common source of bugs, when parts of our app might end up in a state we didn't expect.

This week, let's take a look at some techniques that can make it easier to write code that handles and reacts to state changes - to make it more robust and less error prone. I won't go into specific frameworks or larger, app-wide architectural changes (like RxSwift, ReSwift or using an ELM inspired architecture) in this post (will save that for another week) - instead I'd like to focus on smaller tips, tricks and patterns that I've come to find really useful.

## A single source of truth

One core principle that is good to keep in mind when modelling various states is to try to stick to a *"single source of truth"* as much as possible. One easy way to look at this is that you should never need to check for *multiple conditions* to determine what state you are in. Let's take a look at an example.

Let's say we're building a game, in which enemies have a certain  health, as well as a flag to determine whether they're in play or not. We might model that using two properties on an `Enemy` class, like this:

```
class Enemy {
    var health = 10
    var isInPlay = false
}
```

While the above looks straight forward, it can easily put us in a situation where we have multiple sources of truth. Let's say that as soon as an enemy's health reaches zero, it should be put out of play. So somewhere in our code, we have some logic to handle that:

```
func enemyDidTakeDamage() {
    if enemy.health <= 0 {
        enemy.isInPlay = false
    }
}
```

The problem occurs when we introduce new code paths where we forget to perform the above check. For example, we might give our player a special attack that sets all enemies' health to zero instantly:

```
func performSpecialAttack() {
    for enemy in allEnemies {
        enemy.health = 0
    }
}
```

As you can see above, we update the `health` property of all enemies, but we forget to update `isInPlay`. This will most likely lead to bugs and situations where we end up in an undefined state.

In a situation like this, it might be tempting to fix the problem by adding multiple checks, like this:

```
if enemy.isInPlay && enemy.health > 0 {
    // Enemy is *really* in play
} else {
    // Enemy is *really* defeated
}
```

While the above might work as a temporary "band aid" solution, it will quickly lead to harder to read code that will easily break as we add more conditions and more complex states. If you think about it, doing something like the above is kind of like not trusting our own APIs, since we have to code so defensively against them 😕

One way of solving this problem, and to make sure that we have a single source of truth, is to automatically update the `isInPlay` property inside the `Enemy` class, using a `didSet` on the `health` property:

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

This way we now only have to worry about updating an enemy's health, and we're sure that the `isInPlay` property will always stay synced 👍

## Making states exclusive

The above `Enemy` example was pretty simple, so let's take a look at another one where we deal with more complex states that each have associated values that we need to render & react to accordingly.

Let's say we're building a video player, which will let us download and watch a video from a certain URL. To model a video, we might use a `struct`, like this:

```
struct Video {
    let url: URL
    var downloadTask: Task?
    var file: File?
    var isPlaying = false
    var progress: Double = 0
}
```

The problem with the above way is that we end up with a lot of optionals, and we can't really tell what states that a video can be in just by reading our model code. We also usually end up having to write complex handling that includes code paths that ideally should never be entered:

```
if let downloadTask = video.downloadTask {
    // Handle download
} else if let file = video.file {
    // Perform playback
} else {
    // Uhm... what to do here? 🤔
}
```

The way I often solve this problem is to use an `enum` to define very clear, exclusive states, like this:

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

As you can see above, we have taken away all of the optionals, and all state-specific values are now incorporated into the state that they'll be used for. We can further get rid of some duplication by introducing another level of state for playback information:

```
extension Video {
    struct PlaybackState {
        let file: File
        var progress: Double
    }
}
```

Which we can then use in both the `playing` and `paused` cases:

```
case playing(PlaybackState)
case paused(PlaybackState)
```

## Rendering reactively

However, if you start modelling your state like above, but keep writing imperative state handling code (using multiple `if/else` statements, like above), things are going to get quite ugly. Since all of the information we need is "hidden" inside various cases, we'll need to do a lot of `switch` or `if case let` statements to "get it out".

What we need to combine our state enum with is reactive state handling code. As an example, let's take a look at how we might write code to update an action button in a video player view controller:

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

Now every time our video state changes, our UI will automatically update. We have a single source of truth, and no undefined states 🎉 We can then extend our `render` method to perform all of our UI updates automatically when our state changes:

```
func render() {
    renderActionButton()
    renderVideoSurface()
    renderNavigationBarButtonItems()
    ...
}
```

## Handling state changes

Rendering is one thing, but usually we also need to trigger some form of logic when states change. We might want to transition into yet another state, or start an operation. The good thing is that we can use the exact same pattern as we did for rendering for performing such logic as well.

Let's write a `handleStateChange` method that also gets called from the `didSet` of the `video` property, that runs various logic depending on which state we are currently in:

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

## Extracting information

Up until now we've been using `switch` statements to perform all of our rendering and state handling. For a good reason - it "forces" us to consider all states and all cases, and write the proper logic for each and every one of them. It also lets us leverage the compiler to give us errors if a new state is introduced that we're not handling.

However, sometimes you need to do something very specific that only affects a certain state. Let's say that we want to make sure that we cancel any ongoing download task if our view controller goes off screen:

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

Being able to access certain properties like above is very nice, and can help us get rid of a lot of boilerplate that we'd have to write if we chose to *always* use a `switch` statement for state handling.

So let's make that happen! To do that we simply create an extension on `Video` that uses Swift's `guard case let` pattern matching syntax to extract any ongoing download task:

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

## Conclusion

While there are no silver bullets when it comes to state handling, modelling your state in a way that removes ambiguity and enforces clearly defined states will usually lead to more robust code.

Having single sources of truth and handling state changes in a reactive fashion also usually lets you write code that is easier to read and reason about, and also easier to extend and refactor (just add or remove a `case`, and the compiler will tell you what code you need to update).

The solutions and tips I mentioned in this post sure have tradeoffs, they do require you to write a bit more boilerplate code, and implementing `Equatable` for your state enums can be a bit tricky sometimes (we'll take a look at how to make that easier with code generation and scripts in a future post).

What do you think? Do you already use some of the techniques mentioned in this post, or will you try them out? Let me know, along with any other questions or feedback you might have, either in the comments section below or on Twitter [@johnsundell](https://twitter.com/johnsundell).

Thanks for reading! 🚀


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
