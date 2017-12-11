
> * 原文地址：[How to implement expandable menu on iOS (like in Airbnb)](https://blog.uptech.team/how-to-implement-expandable-menu-on-ios-like-in-airbnb-3d2bdd97b049)
> * 原文作者：[Evgeny Matviyenko](https://blog.uptech.team/@evgeny.matviyenko)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-implement-expandable-menu-on-ios-like-in-airbnb.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-implement-expandable-menu-on-ios-like-in-airbnb.md)
> * 译者：[RichardLeeH](https://github.com/RichardLeeH)
> * 校对者：[iOSleep](https://github.com/iOSleep)，[KnightJoker](https://github.com/KnightJoker)

# 如何在 iOS 上实现类似 Airbnb 中的可展开式菜单  

![](https://cdn-images-1.medium.com/max/2000/1*4mjos0c1rx7qIAdfjJy6Wg.png)

几个月前，我有机会实现了一个可展开式菜单，效果同知名的 iOS 应用 Airbnb。然后，我认为把它封装为库会更好。现在我想和大家分享用于实现漂亮的滚动驱动动画采用的一些解决方案。

![](https://cdn-images-1.medium.com/max/1600/1*c4e83KM3BMh8p04jXY3m1A.gif)

此库支持 3 个状态。主要目的是在滚动 [UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview) 时获得流畅的转换。

![](https://cdn-images-1.medium.com/max/2000/1*yghDAza2CgWGTfXYIRJ9kQ.png)

支持的状态

### UIScrollView

[UIScrollView](https://developer.apple.com/documentation/uikit/uiscrollview) 是 iOS SDK 中的一个支持滚动和缩放的视图。它是 [UITableView](https://developer.apple.com/documentation/uikit/uitableview) 和 [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview) 的基类，因此，只要支持 `UIScrollView`，就可以使用它。

`UIScrollView` 使用 [UIPanGestureRecognizer](https://developer.apple.com/documentation/uikit/uipangesturerecognizer) 在内部检测滚动手势。`UIScrollView` 的滚动状态被定义为 `contentOffset: CGPoint` 属性。 可滚动区域由 `contentInsets` 和 `contentSize` 联合决定。 因此，起始的 `contentOffset` 为 `*CGPoint(x: -contentInsets.left, y: -contentInsets.right)*` ，结束值为 `*CGPoint(x: contentSize.width — frame.width+contentInsets.right, y: contentSize.height — frame.height+contentInsets.bottom)*`*.*

`UIScrollView` 有一个 `bounces: Bool` 属性。`bounces` 能够避免设置 `contentOffset`  高于/低于限定值。我们需要记住这一点。

[![](https://i.ytimg.com/vi_webp/fgwVqCGgHZA/maxresdefault.webp)](https://youtu.be/fgwVqCGgHZA)

UIScrollView contentOffset 演示

我们感兴趣的是用于改变我们菜单状态的属性 `contentOffset: CGPoint`。监听滚动视图 `contentOffset` 的主要方式是为对象设置一个代理属性，并实现 `scrollViewDidScroll(UIScrollView)` 方法。在 Swift 中，没有办法使用 `delegate` 而不影响其他客户端代码（因为 `NSProxy` 不可用），因此我打算使用键值监听（KVO）。

### Observable

我创建了 `Observable` 泛型类，因此可以监听任何类型。

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

- `GestureStateObservable` — 封装了 target-action 用于监听 UIGestureRecognizer 状态。

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

为了便于库的测试，我实现了 `Scrollable` 协议。我也需要采用一种方式让 `UIScrollView` 监听 `contentOffset`, `contentSize` 和 `panGestureRecognizer.state`。协议一致性是一个很好的方法。除了可以监听库中使用的所有的属性。还包括用于设置带有动画效果的 `contentOffset` 的 `updateContentOffset(CGPoint, animated: Bool)` 方法。

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

我没有使用系统库提供的 `UIScrollView` 实现的方法 `setContentOffset(...)` ，因为在我看来，`UIKit` 动画 API 更加灵活。这里的问题是直接设置 `contentOffset` 属性并不能使 `UIScrollView` 减速停下来，所以使用没有动画效果的 updateContentOffset(…) 方法设置当前的 contentOffset。

### State

我想要获取可预测的菜单状态。这就是为什么我在 `State` 结构体中封装了所有可变状态，包括 `offset`、`isExpandedStateAvailable` 和 `configuration` 属性。

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

`offset` 仅仅是菜单高度的相反数。我打算使用 `offset` 来代替 `height`，因为向下滚动时高度降低，当向上滚动时高度增加。`offset` 可以使用 `*offset = previousOffset + (contentOffset.y — previousContentOffset.y)*` 来计算。

- `isExpandedStateAvailable` 属性用于判断 offset 应该赋值为 `-normalStateHeight` 或 `-expandedStateHeight`;
- `configuration` 是一个包含菜单高度常量的结构体。

```
public struct Configuration {
  let compactStateHeight: CGFloat
  let normalStateHeight: CGFloat
  let expandedStateHeight: CGFloat
}
```

### BarController

`BarController` 是用于管理所有计算状态的主要对象，并为调用者提供状态改变。

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

它传递 `stateReducer`， `configuration` 和 `stateObserver` 作为初始参数。

- `stateObserver` 闭包在 `state` 属性的 `didSet` 中被调用中被调用。它通知库的调用者关于状态的改变。
- `stateReducer` 是一个函数，它传入之前的状态，一些滚动上下文参数，并返回一个新状态。通过初始化方法传入参数，用于解耦状态计算和 `BarController` 对象。

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

默认的 state reducer 用于计算 `contentOffset.y` 和 `previousContentOffset.y` 的差值, 并对每个变换器进行计算。然后返回返回新状态：`offset = previousState.offset + deltaY`。

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

- `ignoreTopDeltaYTransformer` — 确保滚动到 `UIScrollView` 的顶部被忽略并且不会影响到 `BarController` 状态；

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

- `ignoreBottomDeltaYTransformer` — 和 `ignoreTopDeltaYTransformer`类似，只是滚动到底部；

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

- `cutOutStateRangeDeltaYTransformer` — 删除那些超过BarController支持的状态（最小值/最大值）限制的 delta Y。

```
internal let cutOutStateRangeDeltaYTransformer: ContentOffsetDeltaYTransformer = { params -> CGFloat in
  var deltaY = params.contentOffsetDeltaY

  if deltaY > 0 {
    // Transform when scrolling down.
    // Cut out extra deltaY that will go out of compact state offset after apply.
    deltaY = min(-params.configuration.compactStateHeight, (params.state.offset + deltaY)) - params.state.offset
  } else {
    // Transform when scrolling up.
    // Expanded or normal state height.
    let maxStateHeight = params.state.isExpandedStateAvailable ? params.configuration.expandedStateHeight : params.configuration.normalStateHeight
    // Cut out extra deltaY that will go out of maximum state offset after apply.
    deltaY = max(-maxStateHeight, (params.state.offset + deltaY)) - params.state.offset
  }

  return deltaY
}
```

每次 `contentOffset` 变化时，`BarController` 调用 `stateReducer` 并将结果赋值给 `state`。

```
 private func setupObserving() {
    guard let observables = observables else { return }

    // Content offset observing.
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

到此，该库能够将 `contentOffset` 的变化转化为内部状态的改变，但是 `isExpandedStateAvailable` 状态属性此时不能被修改，因为状态状态转变尚未结束。

该 `panGestureRecognizer.state` 监听出场了：

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

- 如果拖动手势在在滚动的上部，或者我们已经处于展开状态，拖动手势将 `isExpandedStateAvailable` 状态属性设置为 true；

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

- 如果状态偏移值达到正常状态，拖动手势变化回调方法就会设置 `isExpandedStateAvailable`；

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

- 拖动手势结束后找到最接近当前状态的偏移量，添加其差值到偏移量上，并调用偏移量到结束状态的动画 `updateContentOffset(CGPoint, animated: Bool)`。

```
private func panGestureEnded() {
  guard let scrollable = scrollable else { return }

  let stateOffset = state.offset
  // 所有支持的状态偏移。
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

因此，只有当用户在可用的可滚动区域的顶部滚动时，可展开状态才会生效。如果可展开状态可用并且用户滚动到正常状态之下，此时可展开状态被禁用。如果用户在状态转换期间结束拖动手势，`BarController` 此时会以动画的方式更新 contentoffset。

### 将 UIScrollView 绑定到 BarController

`BarController` 包含 2 个公有方法用于用户设置 `UIScrollView`。通常情况下，用户使用 `set(scrollView: UIScrollView)` 方法。也可以使用 `preconfigure(scrollView: UIScrollView)` 方法，用于设置滚动视图的可视状态与当前 `BarController` 状态一致。
它被用于滚动视图即将被交换的时候。例如，用户可以采用动画替换当前的滚动视图，并希望在动画开始时将第二滚动视图可视化配置。动画结束后，用户应该调用 `set(scrollView: UIScrollView)`。如果 `UIScrollView` 只设置一次，那么 `preconfigure(scrollView: UIScrollView)` 方法不是必须调用的，因为 `set(scrollView: UIScrollView)` 是在内部调用的。

`preconfigure` 方法计算 `contentSize` 高度和 frame 高度的差值， 并将其赋值给 bottomcontentinset，使其菜单保持可扩展状态，并设置 `contentInsets.top` 和 `scrollIndicatorInsets.top`，然后设置初始的 `contentOffset` 确保新的滚动视图与状态偏移保持一致。

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

为了通知用户状态变化，`BarController` 调用注入 `stateObserver` 方法并传入变化后的 `State` 模型对象。

`State` 结构体提供了几个公有方法用于从内部状态中读取有用信息：

- `height()`— 返回 offset 的相反数, 菜单的实际高度；

```
  public func height() -> CGFloat {
    return -offset
  }
```

- `transitionProgress()`— 返回从 0 到 2 的改变状态，**0 — 简洁状态，1 — 正常状态， 2 — 展开状态**；

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

- `value(compactNormalRange: ValueRangeType, normalExpandedRange: ValueRangeType)` — 根据当前的 StateRange 将转换进度映射为 2 个范围类型之一并返回。

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

以下为 `AirBarExampleApp` 中使用 `State` 的公有方法。`airBar.frame.height` 根据 `height()` 动画，`backgroundView.alpha` 根据 `value(...)` 动画。这里的背景视图透明会进行 `(0, 1)` 范围内的差值表示为 `compact-normal` 的状态， `1` 为 `normal-expanded` 状态。

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

到此，我已经实现了一个带有可预测状态的漂亮的滚动驱动菜单，并学到了许多使用 `UIScrollView` 的经验。

以下可以找到本封装库，示例应用和安装指南：

[![](https://ws3.sinaimg.cn/large/006tNc79ly1fhpl9s31fbj314i0aaaaw.jpg)](https://github.com/uptechteam/AirBar)

你可以随意使用它。如果遇到任何困难，请告诉我。

你有哪些使用 `UIScrollView` 及滚动驱动动画经验？欢迎在评论中分享/提问，我很乐意帮忙。

感谢您的阅读！

---

我们在 [UPTech](https://uptech.team/) 上做了以 [Freebird Rides](https://www.freebirdrides.com/) 应用为主题的调查。

---

**如果本文对你有帮助, 点击下方的** 💚 **，这样其他人也会喜欢它。关注我们更多关于如何构建极好产品的文章。**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
