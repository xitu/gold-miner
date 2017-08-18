
> * 原文地址：[How to implement expandable menu on iOS (like in Airbnb)](https://blog.uptech.team/how-to-implement-expandable-menu-on-ios-like-in-airbnb-3d2bdd97b049)
> * 原文作者：[Evgeny Matviyenko](https://blog.uptech.team/@evgeny.matviyenko)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-implement-expandable-menu-on-ios-like-in-airbnb.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-implement-expandable-menu-on-ios-like-in-airbnb.md)
> * 译者：[]()
> * 校对者：

# 如何在 iOS 上实现类似 Airbnb 中的可展开式菜单  

![](https://cdn-images-1.medium.com/max/2000/1*4mjos0c1rx7qIAdfjJy6Wg.png)

几个月前，我有机会实现了一个可展开式菜单，效果同知名的 iOS 应用 Airbnb。然后，我认为把他制作为库会更好。现在我想和你分享用于实现漂亮的滚动驱动动画采用的一些解决方案。

![](https://cdn-images-1.medium.com/max/1600/1*c4e83KM3BMh8p04jXY3m1A.gif)

此库支持 3 个状态。主要目的是在滚动时获得流畅的转换。 `[UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview)`。

![](https://cdn-images-1.medium.com/max/2000/1*yghDAza2CgWGTfXYIRJ9kQ.png)

支持的状态

### UIScrollView

`[UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview)` 是 iOS SDK 中的一个支持滚动和缩放的视图。 它是 `[UITableView](https://developer.apple.com/documentation/uikit/uitableview)` 和 `[UICollectionView](http://uicollectionview)`的基类，因此你可以在任何`UIScrollView`支持的上使用它。so you can use them wherever `UIScrollView` is supported.

`UIScrollView` 使用 `[UIPanGestureRecognizer](https://developer.apple.com/documentation/uikit/uipangesturerecognizer)` 在内部检测滚动手势。 `UIScrollView` 的滚动状态被定义为 `contentOffset: CGPoint` 属性。 Scrollable area is union of `contentInsets` and `contentSize`. So the starting `contentOffset` is `*CGPoint(x: -contentInsets.left, y: -contentInsets.right)*` and ending is `*CGPoint(x: contentSize.width — frame.width+contentInsets.right, y: contentSize.height — frame.height+contentInsets.bottom)*`*.*

`UIScrollView` 有一个 `bounces: Bool` 属性。 In case `bounces` is on `contentOffset` can change to value above/below limits. 我们需要记住这一点。

[![](https://i.ytimg.com/vi_webp/fgwVqCGgHZA/maxresdefault.webp)](https://youtu.be/fgwVqCGgHZA)

UIScrollView contentOffset 演示

We are interested in `contentOffset: CGPoint` property for changing our menu state. The main way of observing scroll view `contentOffset` is setting an object to delegate property and implementing `scrollViewDidScroll(UIScrollView)` method. There is no way to use delegate without affecting other client code in Swift (because `NSProxy` is not available) so I have decided to use Key-Value Observing.

监控滚动视图`contentOffset`的主要方式是设置代理属性并实现 `scrollViewDidScroll(UIScrollView)`方法。因此我决定使用KVO。

### Observable

我创建了`Observable`泛型类，因此可以观察任何类型。

```
internal class Observable<Value>: NSObject {
  internal var observer: ((Value) -> Void)?
}
```

和两个 `Observable` 子类：

- `KVObservable` — 用于封装 KVO。

```
internal class KVObservable<Value>: Observable<Value> {
  private let keyPath: String
  private weak var object: AnyObject?
  private var observingContext = NSUUID().uuidString

  internal init(keyPath: String, object: AnyObject) {
    self.keyPath = keyPath
    self.object = object
    super.init()

    object.addObserver(self, forKeyPath: keyPath, options: [.new], context: &observingContext)
  }

  deinit {
    object?.removeObserver(self, forKeyPath: keyPath, context: &observingContext)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard
      context == &observingContext,
      let newValue = change?[NSKeyValueChangeKey.newKey] as? Value
    else {
      return
    }

    observer?(newValue)
  }
}
```

- `GestureStateObservable` — 封装了 target-action 用户监控 UIGestureRecognizer 状态。

```
internal class GestureStateObservable: Observable<UIGestureRecognizerState> {
  private weak var gestureRecognizer: UIGestureRecognizer?

  internal init(gestureRecognizer: UIGestureRecognizer) {
    self.gestureRecognizer = gestureRecognizer
    super.init()

    gestureRecognizer.addTarget(self, action: #selector(self.handleEvent(_:)))
  }

  deinit {
    gestureRecognizer?.removeTarget(self, action: #selector(self.handleEvent(_:)))
  }

  @objc private func handleEvent(_ recognizer: UIGestureRecognizer) {
    observer?(recognizer.state)
  }
}
```

### Scrollable

To make library testable I have implemented `Scrollable` protocol. I also needed a way to make `UIScrollView` provide `Observable` for `contentOffset`, `contentSize` and `panGestureRecognizer.state`. Protocol conformance is a good way to do this. Apart from observables it contains all properties that library needs to use. It also contains `updateContentOffset(CGPoint, animated: Bool)` method to set `contentOffset` with animation.

为了便于库的测试，我实现了 `Scrollable` 协议。我也需要一种方式来监控`UIScrollView`的`contentOffset`, `contentSize` 和 `panGestureRecognizer.state`。

协议一致性是完成这中工作的不错方式。除了监控其还包括所有的属性库需要使用的。也包括 `updateContentOffset(CGPoint, animated: Bool)`方法用于设置 `contentOffset` 。

```
internal protocol Scrollable: class {
  var contentOffset: CGPoint { get }
  var contentInset: UIEdgeInsets { get set }
  var scrollIndicatorInsets: UIEdgeInsets { get set }
  var contentSize: CGSize { get }
  var frame: CGRect { get }
  var contentSizeObservable: Observable<CGSize> { get }
  var contentOffsetObservable: Observable<CGPoint> { get }
  var panGestureStateObservable: Observable<UIGestureRecognizerState> { get }
  func updateContentOffset(_ contentOffset: CGPoint, animated: Bool)
}

// MARK: - UIScrollView + Scrollable
extension UIScrollView: Scrollable {
  var contentSizeObservable: Observable<CGSize> {
    return KVObservable<CGSize>(keyPath: #keyPath(UIScrollView.contentSize), object: self)
  }

  var contentOffsetObservable: Observable<CGPoint> {
    return KVObservable<CGPoint>(keyPath: #keyPath(UIScrollView.contentOffset), object: self)
  }

  var panGestureStateObservable: Observable<UIGestureRecognizerState> {
    return GestureStateObservable(gestureRecognizer: panGestureRecognizer)
  }

  func updateContentOffset(_ contentOffset: CGPoint, animated: Bool) {
    // Stops native deceleration.
    setContentOffset(self.contentOffset, animated: false)

    let animate = {
      self.contentOffset = contentOffset
    }

    guard animated else {
      animate()
      return
    }

    UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
      animate()
    }, completion: nil)
  }
}
```

I have not used a native `setContentOffset(...)` method of `UIScrollView` for updating `contentOffset` cause `UIKit` animations API is more flexible IMO. The problem here is that setting `contentOffset` directly to property doesn’t stop `UIScrollView` deceleration, so `updateContentOffset(…)` method stops it via setting current `contentOffset` without animation.

我没有使用

### State

我想要一个可预测的菜单状态。这就是为什么我在 `State` 结构体中提取了所有可变状态，包括`offset`、`isExpandedStateAvailable` 和 `configuration` 属性。

```
public struct State {
  internal let offset: CGFloat
  internal let isExpandedStateAvailable: Bool
  internal let configuration: Configuration

  internal init(offset: CGFloat, isExpandedStateAvailable: Bool, configuration: Configuration) {
    self.offset = offset
    self.isExpandedStateAvailable = isExpandedStateAvailable
    self.configuration = configuration
  }
}
```

`offset`仅仅是菜单高度的相反数。我打算使用`offset`来代替`height`，因为向下滚动时高度降低当向上滚动时高度增加。`offset`可以使用`*offset = previousOffset + (contentOffset.y — previousContentOffset.y)*`来计算。

- `isExpandedStateAvailable` property determines should offset go below `-normalStateHeight` to `-expandedStateHeight` or not;
- `configuration` 是一个包含菜单高度常量的结构体。

```
public struct Configuration {
  let compactStateHeight: CGFloat
  let normalStateHeight: CGFloat
  let expandedStateHeight: CGFloat
}
```

### BarController

`BarController`是用于生成所有状态计算魔法的主要对象，并为调用者提供状态改变。

```
public typealias StateObserver = (State) -> Void

private struct ScrollableObservables {
  let contentOffset: Observable<CGPoint>
  let contentSize: Observable<CGSize>
  let panGestureState: Observable<UIGestureRecognizerState>
}

public class BarController {

  private let stateReducer: StateReducer
  private let configuration: Configuration
  private let stateObserver: StateObserver

  private var state: State {
    didSet { stateObserver(state) }
  }

  private weak var scrollable: Scrollable?
  private var observables: ScrollableObservables?

  // MARK: - Lifecycle
  internal init(
    stateReducer: @escaping StateReducer,
    configuration: Configuration,
    stateObserver: @escaping StateObserver
  ) {
    self.stateReducer = stateReducer
    self.configuration = configuration
    self.stateObserver = stateObserver
    self.state = State(
      offset: -configuration.normalStateHeight,
      isExpandedStateAvailable: false,
      configuration: configuration
    )
  }

  ...
}
```

它传递 `stateReducer`， `configuration` 和 `stateObserver` 作为初始化参数。

- `stateObserver` 闭包是`state`属性在观察者 `didSet` 中被调用。它通知库的调用者关于状态的改变。
- `stateReducer` is a function that takes previous state, some scrolling context params and returns a new state. Injecting it through initializer provides decoupling between state calculation logic and `BarController` object itself.
- `stateReducer` is a function that takes previous state, some scrolling context params and returns a new state. Injecting it through initializer provides decoupling between state calculation logic and `BarController` object itself.

```
internal struct StateReducerParameters {
  let scrollable: Scrollable
  let configuration: Configuration
  let previousContentOffset: CGPoint
  let contentOffset: CGPoint
  let state: State
}

internal typealias StateReducer = (StateReducerParameters) -> State
```

Default state reducer calculates difference between `contentOffset.y` and `previousContentOffset.y` and applies provided transformers one-by-one. After that it returns new state with `offset = previousState.offset + deltaY`.

默认的 state reducer 计算`contentOffset.y`和`previousContentOffset.y`的不同。然后返回返回新状态：`offset = previousState.offset + deltaY`。

```
internal struct ContentOffsetDeltaYTransformerParameters {
  let scrollable: Scrollable
  let configuration: Configuration
  let previousContentOffset: CGPoint
  let contentOffset: CGPoint
  let state: State
  let contentOffsetDeltaY: CGFloat
}

internal typealias ContentOffsetDeltaYTransformer = (ContentOffsetDeltaYTransformerParameters) -> CGFloat

internal func makeDefaultStateReducer(transformers: [ContentOffsetDeltaYTransformer]) -> StateReducer {
  return { (params: StateReducerParameters) -> State in
    var deltaY = params.contentOffset.y - params.previousContentOffset.y

    deltaY = transformers.reduce(deltaY) { (deltaY, transformer) -> CGFloat in
      let params = ContentOffsetDeltaYTransformerParameters(
        scrollable: params.scrollable,
        configuration: params.configuration,
        previousContentOffset: params.previousContentOffset,
        contentOffset: params.contentOffset,
        state: params.state,
        contentOffsetDeltaY: deltaY
      )
      return transformer(params)
    }

    return params.state.add(offset: deltaY)
  }
}
```

库中使用了 3 个变换器来减少状态：

- `ignoreTopDeltaYTransformer` — makes sure that scrolling above top of `UIScrollView` is being ignored and does not affect `BarController` state;
- `ignoreTopDeltaYTransformer` — 确保滚动到`UIScrollView`的顶部被忽略并且不会影响到 `BarController` 状态；

```
internal let ignoreTopDeltaYTransformer: ContentOffsetDeltaYTransformer = { params -> CGFloat in
  var deltaY = params.contentOffsetDeltaY

  // Minimum contentOffset.y without bounce.
  let start = params.scrollable.contentInset.top

  // Apply transform only when contentOffset is below starting point.
  if
    params.previousContentOffset.y < -start ||
      params.contentOffset.y < -start
  {
    // Adjust deltaY to ignore scroll view bounce below minimum contentOffset.y.
    deltaY += min(0, params.previousContentOffset.y + start)
  }

  return deltaY
}
```

- `ignoreBottomDeltaYTransformer` — 和 `ignoreTopDeltaYTransformer`一致，只是滚动到底部；

```
internal let ignoreBottomDeltaYTransformer: ContentOffsetDeltaYTransformer = { params -> CGFloat in
  var deltaY = params.contentOffsetDeltaY

  // Maximum contentOffset.y without bounce.
  let end = params.scrollable.contentSize.height - params.scrollable.frame.height + params.scrollable.contentInset.bottom

  // Apply transform only when contentOffset.y is above ending.
  if params.previousContentOffset.y > end ||
      params.contentOffset.y > end
  {
    // Adjust deltaY to ignore scroll view bounce above maximum contentOffset.y.
    deltaY += max(0, params.previousContentOffset.y - end)
  }

  return deltaY
}
```

- `cutOutStateRangeDeltaYTransformer` — cuts out extra delta Y, that goes out of minimum/maximum limits of BarController supported states.
- `cutOutStateRangeDeltaYTransformer` — 删除多余的 delta Y，BarController支持的状态，超过最小值/最大值限制。

```
internal let cutOutStateRangeDeltaYTransformer: ContentOffsetDeltaYTransformer = { params -> CGFloat in
  var deltaY = params.contentOffsetDeltaY

  if deltaY > 0 {
    // 向下滚动时变换。
    // Cut out extra deltaY that will go out of compact state offset after apply.
    deltaY = min(-params.configuration.compactStateHeight, (params.state.offset + deltaY)) - params.state.offset
  } else {
    // 向上滚动时变换。
    // 展开或者正常状态的高度。
    let maxStateHeight = params.state.isExpandedStateAvailable ? params.configuration.expandedStateHeight : params.configuration.normalStateHeight
    // Cut out extra deltaY that will go out of maximum state offset after apply.
    deltaY = max(-maxStateHeight, (params.state.offset + deltaY)) - params.state.offset
  }

  return deltaY
}
```

`BarController` 调用 `stateReducer` 并且设置结果当 as a `state` every time `contentOffset` changes。

```
 private func setupObserving() {
    guard let observables = observables else { return }

    // 观察的内容偏移。
    var previousContentOffset: CGPoint?
    observables.contentOffset.observer = { [weak self] contentOffset in
      guard previousContentOffset != contentOffset else { return }
      self?.contentOffsetChanged(previousValue: previousContentOffset, newValue: contentOffset)
      previousContentOffset = contentOffset
    }

    ...
  }

  private func contentOffsetChanged(previousValue: CGPoint?, newValue: CGPoint) {
    guard
      let previousValue = previousValue,
      let scrollable = scrollable
    else {
      return
    }

    let reducerParams = StateReducerParameters(
      scrollable: scrollable,
      configuration: configuration,
      previousContentOffset: previousValue,
      contentOffset: newValue,
      state: state
    )

    state = stateReducer(reducerParams)
  }

  ...
```

For now the library is able to transform `contentOffset` changes into internal state changes, but `isExpandedStateAvailable` state property is never being mutated as well as state transitions are not being finished.

That is where `panGestureRecognizer.state` observing comes in:

```
private func setupObserving() {
    ...

    // Pan gesture state observing.
    observables.panGestureState.observer = { [weak self] state in
      self?.panGestureStateChanged(state: state)
    }
  }

  private func panGestureStateChanged(state: UIGestureRecognizerState) {
    switch state {
    case .began:
      panGestureBegan()
    case .ended:
      panGestureEnded()
    case .changed:
      panGestureChanged()
    default:
      break
    }
  }
```

- Pan gesture sets `isExpandedStateAvailable` state property to true in case panning began in the top of scrolling or in case we already have an expanded state;

```
private func panGestureBegan() {
    guard let scrollable = scrollable else { return }

    // Is currently at top of scrollable area.
    // Assertion is not strict here, because of UIScrollView KVO observing bug.
    // First emitted contentOffset.y isn't always a decimal number.
    let isScrollingAtTop = scrollable.contentOffset.y.isNear(to: -configuration.normalStateHeight, delta: 5)
    // Is expanded state previously available.
    let isExpandedStatePreviouslyAvailable = scrollable.contentOffset.y < -configuration.normalStateHeight && state.isExpandedStateAvailable
    // Turn on expanded state if scrolling at top or expanded state previous available.
    state = state.set(isExpandedStateAvailable: isScrollingAtTop || isExpandedStatePreviouslyAvailable)

    // Configure contentInset.top to be consistent with available states.
    scrollable.contentInset.top = state.isExpandedStateAvailable ? configuration.expandedStateHeight : configuration.normalStateHeight
  }
```

- Pan gesture change sets `isExpandedStateAvailable` if state offset reached normal state;

```
private func panGestureChanged() {
  guard let scrollable = scrollable else { return }

  // Turn off expanded state if offset is bigger than normal state offset.
  if state.isExpandedStateAvailable && scrollable.contentOffset.y > -configuration.normalStateHeight {
    state = state.set(isExpandedStateAvailable: false)
    scrollable.contentInset.top = configuration.normalStateHeight
  }
}
```

- Pan gesture end finds offset that is most near current state, adds a difference to current content offset and calls `updateContentOffset(CGPoint, animated: Bool)` with result content offset to end state transition animation.

```
private func panGestureEnded() {
  guard let scrollable = scrollable else { return }

  let stateOffset = state.offset
  // All supported state offsets.
  let offsets = [
    -configuration.compactStateHeight,
    -configuration.normalStateHeight,
    -configuration.expandedStateHeight
  ]

  // Find smallest absolute delta between current offset and supported state offsets.
  let smallestDelta = offsets.reduce(nil) { (smallestDelta: CGFloat?, offset: CGFloat) -> CGFloat in
    let delta = offset - stateOffset
    guard let smallestDelta = smallestDelta else { return delta }
    return abs(delta) < abs(smallestDelta) ? delta : smallestDelta
  }

  // Add samllestDelta to currentOffset.y and update scrollable contentOffset with animation.
  if let smallestDelta = smallestDelta, smallestDelta != 0 {
    let targetContentOffsetY = scrollable.contentOffset.y + smallestDelta
    let targetContentOffset = CGPoint(x: scrollable.contentOffset.x, y: targetContentOffsetY)
    scrollable.updateContentOffset(targetContentOffset, animated: true)
  }
}
```

So expanded state becomes available only when the user starts scrolling at the top of available scrollable area. If expanded state was available and user scrolls below normal state, expanded state turns off. And if the user ends the panning gesture during state transition `BarController` updates content offset with animation to finish it.

### 将 UIScrollView 绑定到 BarController

`BarController` 包含 2 个公有方法用于用户设置 `UIScrollView`。大多数情况下个用户使用 `set(scrollView: UIScrollView)` 方法。也可以使用 `preconfigure(scrollView: UIScrollView)` 方法，it configures the scroll view’s visual state to be consistent with the current `BarController` state. It should be used when the scroll view is about to be swapped. For example the user can replace current scroll view with animation and want second scroll view to be visually configured in the beginning of animation. After animation completion the user should call `set(scrollView: UIScrollView)`. `preconfigure(scrollView: UIScrollView)` method is not needed to be called if `UIScrollView` is set once, cause `set(scrollView: UIScrollView)` calls it internally.

`preconfigure` method finds difference between `contentSize` height and frame height and puts it as a bottom content inset so that the menu remains expandable, configures `contentInsets.top` and `scrollIndicatorInsets.top` and sets initial `contentOffset` to make the new scroll view visually consistent with the state offset.

```
public func set(scrollView: UIScrollView) {
  self.set(scrollable: scrollView)
}

internal func set(scrollable: Scrollable) {
  self.scrollable = scrollable
  self.observables = ScrollableObservables(
    contentOffset: scrollable.contentOffsetObservable,
    contentSize: scrollable.contentSizeObservable,
    panGestureState: scrollable.panGestureStateObservable
  )

  preconfigure(scrollable: scrollable)
  setupObserving()

  stateObserver(state)
}

public func preconfigure(scrollView: UIScrollView) {
  preconfigure(scrollable: scrollView)
}

internal func preconfigure(scrollable: Scrollable) {
  scrollable.setBottomContentInsetToFillEmptySpace(heightDelta: configuration.compactStateHeight)

  // Set contentInset.top to current state height.
  scrollable.contentInset.top = state.offset <= -configuration.normalStateHeight && state.isExpandedStateAvailable ? configuration.expandedStateHeight : configuration.normalStateHeight
  // Set scrollIndicator.top to normal state height.
  scrollable.scrollIndicatorInsets.top = configuration.normalStateHeight

  // Scroll to top of scrollable area if state is expanded or content offset is less than zero.
  if scrollable.contentOffset.y <= 0 || (state.offset < -configuration.normalStateHeight && state.isExpandedStateAvailable) {
    let targetContentOffset = CGPoint(x: scrollable.contentOffset.x, y: state.offset)
    scrollable.updateContentOffset(targetContentOffset, animated: false)
  }
}
```

### API

To inform users about state changes `BarController` calls injected `stateObserver` function with changed `State` model object.

`State` struct has several public methods for getting useful information from internal state:

- `height()`— 返回 offset 的相反数, 菜单的实际高度；

```
  public func height() -> CGFloat {
    return -offset
  }
```

- `transitionProgress()`— 返回从 0 到 2 的过度进度，*0 — 简洁状态，1 — 正常状态， 2 — 展开状态*；

```
internal enum StateRange {
  case compactNormal
  case normalExpanded

  internal func progressBounds() -> (CGFloat, CGFloat) {
    switch self {
    case .compactNormal:
      return (0, 1)
    case .normalExpanded:
      return (1, 2)
    }
  }
}

...

internal func stateRange() -> StateRange {
  if offset > -configuration.normalStateHeight {
    return .compactNormal
  } else {
    return .normalExpanded
  }
}

public func transitionProgress() -> CGFloat {
  let stateRange = self.stateRange()
  let offsetBounds = configuration.offsetBounds(for: stateRange)
  let progressBounds = stateRange.progressBounds()
  let reversedProgressBounds = (progressBounds.1, progressBounds.0)
  return offset.map(from: offsetBounds, to: reversedProgressBounds)
}
```

- `value(compactNormalRange: ValueRangeType, normalExpandedRange: ValueRangeType)` — returns transition progress mapped to one of 2 range types according to the current `StateRange`.

```
public enum ValueRangeType {
    case value(CGFloat)
    case range(CGFloat, CGFloat)

    internal var range: (CGFloat, CGFloat) {
      switch self {
      case let .value(value):
        return (value, value)
      case let .range(range):
        return range
      }
    }
  }

  public func value(compactNormalRange: ValueRangeType, normalExpandedRange: ValueRangeType) -> CGFloat {
    let progress = self.transitionProgress()
    let stateRange = self.stateRange()
    let valueRange = stateRange == .compactNormal ? compactNormalRange : normalExpandedRange
    return progress.map(from: stateRange.progressBounds(), to: valueRange.range)
  }
```

Here is an example from `AirBarExampleApp` with a use of `State` public methods. `airBar.frame.height` is animated with `height()` and `backgroundView.alpha` is animated using `value(...)`. Background view alpha here is interpolated from transition progress to `(0, 1)` range in `compact-normal` transition and constantly `1` in `normal-expanded` transition.

以下为`AirBarExampleApp`中使用 `State` 的公有方法。

```
override func viewDidLoad() {
    ...

    let barStateObserver: (AirBar.State) -> Void = { [weak self] state in
      self?.handleBarControllerStateChanged(state: state)
    }

    barController = BarController(configuration: configuration, stateObserver: barStateObserver)
  }

  ...

  private func handleBarControllerStateChanged(state: State) {
    let height = state.height()

    airBar.frame = CGRect(
      x: airBar.frame.origin.x,
      y: airBar.frame.origin.y,
      width: airBar.frame.width,
      height: height // <~ Animated property
    )

    backgroundView.alpha = state.value(compactNormalRange: .range(0, 1), normalExpandedRange: .value(1)) // <~ Animated property
  }
```

### 总结

As a result, I got a beautiful scroll driven menu with predictable state and a lot of experience working with `UIScrollView`.

The library, example application and installation guide can be found here:

以下可以找到本封装库，示例应用和安装指南：

[![](https://ws3.sinaimg.cn/large/006tNc79ly1fhpl9s31fbj314i0aaaaw.jpg)](https://github.com/uptechteam/AirBar)

Feel free to use it for your own purposes. Let me know if you have any difficulties with it.

And what is your experience working with `UIScrollView`? And with scroll driven animations? Feel free to share / ask questions in the comments, I would be glad to help.

感谢您的阅读！

---

We did the investigation of the topic for the [Freebird Rides](https://www.freebirdrides.com/) app we’ve built here at [UPTech](https://uptech.team/).

---

*If you find this helpful, click the* 💚 *below so other can enjoy it too. Follow us for more articles on how to build great products.*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
