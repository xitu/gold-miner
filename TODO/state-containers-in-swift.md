
> * 原文地址：[Reactive iOS Programming: Lightweight State Containers in Swift](https://www.captechconsulting.com/blogs/state-containers-in-swift)
> * 原文作者：[Tyler Tillage](https://www.captechconsulting.com/search#q=Tyler Tillage)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/state-containers-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/state-containers-in-swift.md)
> * 译者：[deepmissea](http://deepmissea.blue)
> * 校对者：[FlyOceanFish](http://www.jianshu.com/u/48277aa2055d)

# iOS 响应式编程：Swift 中的轻量级状态容器

## 事物的状态

在客户端架构如何工作上，每一个 iOS 和 MacOS 开发者都有不同的细微见解。从最经典的苹果框架所内嵌的 
[MVC 模式](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html)（读作：臃肿的视图控制器），到那些 MV* 模式（比如 MVP,MVVM），再到听起来有点吓人的 [Viper](https://www.objc.io/issues/13-architecture/viper/)，那么我们该如何选择？

这篇文章并不会回答你的问题，因为正确的答案是**依据环境而定的**。我想要强调的是一个我很喜欢并且经常看到的基本方法，名为**状态容器**。

## 状态容器是什么？

实质上，状态容器只是一个围绕信息的封装，是数据安全输入输出的守护者。他们不是特别在意数据的类型和来源。但是他们非常在意的是当数据**改变**的时候。状态容器的中心思想就是，任何由于状态改变产生的影响都应该以有组织并且可预测这种方式在应用里传递。

> 状态容器以与线程锁相同的方式提供安全的状态。

这并不是一个新的概念，而且它也不是一个你可以集成到整个应用的工具包。状态容器的理念是非常通用的，它可以融入进任何应用程序架构，而无需太多的附加规则。但是它是一个强大的方法，是很多流行库（比如[ReactiveReSwift](https://github.com/ReSwift/ReactiveReSwift)）的核心，比如 [ReSwift](https://github.com/ReSwift/ReSwift)、[Redux](https://github.com/reactjs/redux)、[Flux](https://github.com/facebook/flux) 等等，这些框架的成功和绝对数量说明了状态容器模式在现代移动应用中的有效性。

就像 `ReSwift` 这样的响应式库，状态容器将 `Action` 和 `View` 之间的缺口桥联为单向数据流的一部分。然而即使没有其他两个组件，状态容器也很强力。实际上，他们可以做的比这些库使用的更多。

在这篇文章中，我会演示一个基本的状态容器实现，我已经把它用于各种没有引入大型架构库的项目中。

## 构建一个状态容器

让我们从构建一个基本的 `State` 类开始。

    /// Wraps a piece of state.
    class State<Type> {

        /// Unique key used to identify the state across the application.
        let key: String
        /// Holds the state itself.
        fileprivate var _value: Type

        /// Used to synchronize changes to the state value.
        fileprivate let lockQueue: DispatchQueue

        /// Create a state container with the provided `defaultValue`, and associate it with a `key`.
        init(_ defaultValue: Type, key: String) {
            self._value = defaultValue
            self.key = key
            self.lockQueue = DispatchQueue(label: "com.stateContainers.\(key)", attributes: .concurrent)
        }

        /// Invoke this method after manipulating the state.
        func didModify() {
            print("State for key \(self.key) modified.")
        }
    }

这个基类封装了一个任何 `Type` 的 `_value`，通过一个 `key` 关联，并声明了一个提供 `defaultValue` 的初始化器。

### 读取状态

为了读取我们状态容器的当前值，我们要创建一个计算属性 `value`。

由于状态改变通常是由多线程触发并读取的，所以我们要通过 GCD 使用一个[读写锁](https://en.wikipedia.org/wiki/Readers%E2%80%93writer_lock)来确保访问内部 `_value` 属性时的线程安全。

     extension State {

        /// The current state value.
        var value: Type {
            var retVal: Type!
            self.lockQueue.sync {
                retVal = self._value // I wish there was a `sync` method that inferred a generic return value.
            }
            return retVal
        }
    }


### 改变状态

为了改变状态，我们还要创建一个 `modify(_newValue:)` 函数。虽然我们可以允许直接访问设置器，但在这里的目的是围绕状态改变来定义结构。在使用简单属性设置器的方法中，通过与我们 API 通信修改状态产生的影响。因此，所有的状态改变都必须通过这个方法来达成。

    extension State {

        /// Modifies the receiver by assigning the `newValue`.
        func modify(_ newValue: Type) {
            self.lockQueue.async(flags: .barrier) {
                self._value = newValue
            }

            // Handle the repercussions of the modificationself.
            didModify()
        }
    }

为了有趣一些，我们自定义一个运算符！

    /// Modifies the receiver by assigning the right-hand side of the operator.
    func ~> <T>(lhs: State<T>, rhs: T) {
        lhs.modify(rhs)
    }


### 关于 `didModify()` 方法

`didModify()` 是我们状态容器中最重要的一部分，因为它允许我们定义在状态改变后所触发的行为。为了能够在任何时候这种情况发生时能够执行自定义的逻辑，`State` 的子类可以覆盖这个方法。

`didModify()` 也扮演着另一个角色。如果我们通用的 `Type` 是一个 `class`，状态器就可以无需知道它就可以更改它的属性。因此，我们暴露出 `didModify()` 方法，以便这些类型的更改可以手动传播（见下文）。

这是在处理状态时使用引用类型的固有危险，所以我建议尽可能使用值类型。

### 使用状态容器

下面是如何使用我们 `State` 类的最基本的例子：

    // State wrapping a value type
    let themeColor = State(UIColor.blue, key: "themeColor")
    print(themeColor.value) // "UIExtendedSRGBColorSpace 0 0 1 1"

我们也可以使用`可选`类型：

    // State wrapping an optional value type
    let appRating = State<Int?>(nil, key: "appRating")
    print(String(describing: appRating.value)) // "nil"

改变状态很容易：

    appRating.modify(4)
    print(String(describing: appRating.value)) // "Optional(4)"

    appRating ~> nil
    print(String(describing: appRating.value)) // "nil"

如果我们有无价值的类型（比如在状态改变时，不触发 `didSet` 的类型），我们调用 `didModify()` 方法，让 `State` 知道这个改变：

    classCEO : CustomDebugStringConvertible {
        var name: String

        init(name: String) {
            self.name = name
        }

        var debugDescription: String {
            return name
        }
    }

    // State wrapping a reference type
    let currentCEO = State(CEO(name: "John Sculley"), key: "currentCEO")
    print(currentCEO.value) // "John Sculley"
    // 分配一个新的用户属性，不需要调用 `didSet`
    currentCEO ~> CEO(name: "Steve Jobs")
    print(currentCEO.value) // "Steve Jobs"
    // 就地修改用户，需要手动调用 `didSet`
    currentCEO.value.name = "Tim Cook"
    currentCEO.didModify()
    print(currentCEO.value) // "Tim Cook"

手动调用 `didModify()` 是不好的，因为无法知道引用类型的内部属性是否改变，因为他们是可以现场（in-place）改变的，如果你有好的方法，@我 [@TTillage](https://twitter.com/TTillage)!

## 监听状态的改变

现在我们已经建立了一个基本的状态容器，让我们来扩展一下，让它更强大。通过我们的 `didModify()` 方法，我们可以用特定子类的形式添加功能。让我们添加一种方式，来“监听”状态的改变，这样我们的 UI 组件可以在发生更改时自动更新。
### 定义一个 `StateListener`

第一步，让我们定义一个这样的状态监听器：

    protocol StateListener : AnyObject {

        /// Invoked when state is modified.
        func stateModified<T>(_ state: State<T>)

        /// The queue to use when dispatching state modification messages. Defaults to the main queue.
        var stateListenerQueue: DispatchQueue { get }
    }

    extension StateListener {

        var stateListenerQueue: DispatchQueue {
            return DispatchQueue.main
        }
    }

在状态改变时，监听器会在它选择的 `stateListenerQueue` 上收到 `stateModified(_state:)` 调用，默认是 `DispatchQueue.main`。

### 创建 `MonitoredState` 的子类

下一步，我们定义一个专门的子类，叫做 `MonitoredState`，它会对监听器保持弱引用，并通知他们状态的改变。一个简单的实现方式是使用 `NSHashTable.weakObjects()`。

    class MonitoredState<Type> : State<Type> {

        /// Weak references to all the state listeners.
        fileprivate let listeners: NSHashTable<AnyObject>

        /// Used to synchronize changes to the listeners.
        fileprivate let listenerLockQueue: DispatchQueue

        /// Create a state container with the provided `defaultValue`, and associate it with a `key`.
        override init(_ defaultValue: Type, key: String) {
            self.listeners = NSHashTable<AnyObject>.weakObjects()
            self.listenerLockQueue = DispatchQueue(label: "com.stateContainers.listeners.\(key)", attributes: .concurrent)
            super.init(defaultValue, key: key)
        }

        /// All of the listeners associated with the receiver.
        var allListeners: [StateListener] {
            var retVal: [StateListener] = []
            self.listenerLockQueue.sync {
                retVal = self.listeners.allObjects.map({ $0 as? StateListener }).flatMap({ $0 }) // remove `nil` values
            }
            return retVal
        }

        /// Notifies all listeners that something changed.
        override func didModify() {
            super.didModify()

            let allListeners = self.allListeners

            let state = self
            for l in allListeners {
                l.stateListenerQueue.async {
                    l.stateModified(state)
                }
            }
        }
    }

无论何时 `didModify` 被调用，我们的 `MonitoredState` 类调用 `stateModified(_state:)` 上的监听者，简单！

为了添加监听器，我们要定义一个 `attach(listener:)` 方法。和上面的内容很像，在我们的 `listeners` 属性上，使用 `listenerLockQueue` 来设置一个读写锁。

    extension MonitoredState {

        /// Associate a listener with the receiver's changes.
        func attach(listener: StateListener) {
            self.listenerLockQueue.sync(flags: .barrier) {
                self.listeners.add(listener as AnyObject)
            }
        }
    }


现在可以监听任何封装在 `MonitoredState` 里任何值的改变了！
### 根据状态的改变来触发 UI 的更新

下面是一个如何使用我们新的 `MonitoredState` 类的例子。假设我们在 `MonitoredState` 容器中追踪设备的位置：

    /// The device's current location.
    let deviceLocation = MonitoredState<CLLocation?>(nil, key: "deviceLocation")


我们还需要一个视图控制器来展示当前设备在地图上的位置：


    // Centers a map on the devices's current locationclass
    LocationViewController : UIViewController {

        @IBOutlet var mapView: MKMapView!

        override func viewDidLoad() {
            super.viewDidLoad()
            self.updateMapForCurrentLocation()
        }

        func updateMapForCurrentLocation() {
            if let currentLocation = deviceLocation.value {
                // Center the map on the device's location
                self.mapView.setCenter(currentLocation.coordinate, animated: true)
            }
        }
    }


由于我们需要在 `deviceLocation` 改变的时候更新地图，所以要把 `LocationViewController` 扩展为一个 `StateListener`：

    extension LocationViewController : StateListener {

        func stateModified<T>(_state: State<T>) {
            ifstate === deviceLocation {
                print("Location changed, updating UI")
                self.updateMapForCurrentLocation()
            }
        }
    }


然后记住使用 `attach(listener:)` 把视图控制器附加到状态。实际上，这个操作可以在 `viewDidLoad`，`init` 或者任何你想要开始监听的时候来做。

    let vc = LocationViewController()
    deviceLocation.attach(listener: vc)


现在我们正监听 `deviceLocation`，一旦我们从 `CoreLocation` 得到一个新的定位，我们所要做的只是改变我们的状态容器，我们的视图控制器会自动的更新位置！

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let closestLocation = locations.first {
            // Triggers `updateMapForCurrentLocation` on the VC asynchronously on the main queue
            deviceLocation ~> closestLocation
        }
    }


值得注意的是，由于我们使用了一个弱引用 `NSHashTable`，在视图控制器被销毁时，`allListeners` 属性永远也不会有 `deviceLocation`。没有必要“移除”监听器。

记住，在真实的使用场景里，要确保视图控制器的 `view` 在执行更新 UI 之前是可见的。

## 保持状态

OK，现在我们正在获得好的东东。我们可以把现在所需要的一切装在状态容器里，并且**保持**可以随时随地使用。

1. 我们现在有一个唯一的 `key` 用于与后备存储关联。
2. 我们知道值的 `Type`，通知它应该如何保持。
3. 我们知道什么时候值需要从存储器中加载，使用 `init(_defaultValue:key:)` 方法。
4. 我们知道什么时候值需要被保存在存储器中，使用 `didModify()` 方法。

### 使用 `UserDefaults` 

让我们创建一个状态容器，它可以**自动地**保存任何改变到 `UserDefaults.standard` 中，并且在初始化的时候重新加载之前的这些值。它同时支持可选类型和非可选类型。他也会自动序列化和反序列化符合 `NSCoding` 的类型，即使 `UserDefaults` 并没有直接支持 `NSCoding` 的使用。

这里是代码，我会在下面讲解。

    class UserDefaultsState<Type> : MonitoredState<Type> {

        ///1) Loads existing value from `UserDefaults.standard`if it exists, otherwise falls back to the `defaultValue`.
        public override init(_defaultValue:Type, key:String) {
            let existingValue = UserDefaults.standard.object(forKey: key)
            if let existing = existingValue as? Type {
                //2) Non-NSCoding value
                print("Loaded \(key) from UserDefaults")
                super.init(existing, key: key)
            } elseif let data = existingValue as? Data, let decoded = NSKeyedUnarchiver.unarchiveObject(with: data) as? Type {
                //3) NSCoding value
                print("Loaded \(key) from UserDefaults")
                super.init(decoded, key: key)
            } else {
                //4) No existing value
                super.init(defaultValue, key: key)
            }
        }

        ///5) Persists any changes to `UserDefaults.standard`.
        public override func didModify() {
            super.didModify()

            let val = self.value
            if let val = val as? OptionalType, val.isNil {
                //6) Nil value
                UserDefaults.standard.removeObject(forKey:self.key)
                print("Removed \(self.key) from UserDefaults")
            } elseif let val = val as? NSCoding {
                //7) NSCoding value
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: val), forKey:self.key)
                print("Saved \(self.key) to UserDefaults")
            } else {
                //8) Non-NSCoding value
                UserDefaults.standard.set(val, forKey:self.key)
                print("Saved \(self.key) to UserDefaults")
            }

            UserDefaults.standard.synchronize()
        }
    }


#### `init(_defaultValue:key:)`

1. 我们的初始化方法检查 `UserDefaults.standard` 是否已经包含一个由 `key` 对应的值。
2. 如果我们能加载一个对象，并且它刚好是基本类型，我们可以立即使用它。
3. 如果我们加载的是 `Data`，那么使用 `NSKeyedUnarchiver` 解压，它会被 `NSCoding` 存储，然后我们立即使用它。
4. 如果 `UserDefaults.standard` 里没有和 `key` 匹配的值，我们就使用已提供的 `defaultValue`。

#### `didModify()`

5. 在状态改变的时候，我们想要自动保存我们的状态，这样做的方法依赖于 `Type`
6. 如果基本类型是 `Optional` 的，并且为 `nil`，我们只需要简单的把值从 `UserDefaults.standard` 移除，检查一个基本类型是否为 `nil` 有点棘手，不过 用协议扩展 `Optional` 是一个解决方法：

```
protocol OptionalType {

    /// Whether the receiver is `nil`.var isNil: Bool { get }
}

extension Optional : OptionalType {

    publicvar isNil: Bool {
        return self == nil
    }
}
```

7. 如果我们的值符合 `NSCoding`，我们就需要使用 `NSKeyedArchiver` 来把它转换成 `Data`，然后保存它。
8. 除此之外，我们只需把值直接存储到 `UserDefaults` 中。

现在，如果我们想要获得 `UserDefaults` 的支持，我们要做的仅仅是使用新的 `UserDefaultsState` 类！

    UserDefaults.standard.set(true, forKey: "isTouchIDEnabled")
    UserDefaults.standard.synchronize()

    let isTouchIDEnabled = UserDefaultsState(false, key: "isTouchIDEnabled")
    print(isTouchIDEnabled.value) // "true"

    isTouchIDEnabled ~> falseprint(UserDefaults.standard.bool(forKey: "isTouchIDEnabled")) // "false"

我们的 `UserDefaultsState` 会在其值更改时自动更新它的后台存储。在应用启动的时候，它会自动把 `UserDefaultsState` 中的现有值投入使用。

### 支持其他的数据存储

这只是使用状态容器的例子之一，`State` 如何扩展到智能地存储自己的数据。在我的项目中，也建立了一些子类，当发生更改时，它们将异步地保留到磁盘或钥匙串。你甚至可以通过使用不同的子类来触发与远程服务器的同步或者将指定标记录到分析库中。它毫无限制。

## 应用级别的状态管理

所以这些状态容器放在哪里呢？通常我把他们静态储存到一个 `struct` 里，这样可以在整个应用里访问。这与基于 Flux 库存储全局应用状态有些相似。

    struct AppState {
        static let themeColor = State(UIColor.blue, key: "themeColor")
        static let appRating = State<Int?>(nil, key: "appRating")
        static let currentCEO = State(CEO(name: "Tim Cook"), key: "currentCEO")
        static let deviceLocation = MonitoredState<CLLocation?>(nil, key: "deviceLocation")
        static let isTouchIDEnabled = UserDefaultsState(false, key: "isTouchIDEnabled")
    }


你可以使用分离或嵌入式的结构体以及不同的访问级别来调整状态容器的作用域。

## 结论

在状态容器上管理状态有很多好处。以前放在单例上的数据，或在网络代理中传播的数据，现在已经在高层次上浮现出来并且可见。应用程序行为中的所有输入都突然变得清晰可见并且组织严谨。

从 API 响应到特征切换到受保护的钥匙串项，使用状态容器模式是围绕关键信息定义结构的优秀方式。状态容器可以轻松地用于缓存，用户偏好，分析以及应用程序启动之间需要保持的任何事情。

状态容器模式让 UI 组件不用担心如何以及何时生成数据，并开始把焦点转向如何把数据转换成梦幻般的用户体验。

## 关于作者

CapTecher Tyler Tillage 位于[亚特兰大办公室](~/link.aspx?_id=4848D51075504B57822781008FC5CE6F&amp;_z=z)，在[应用设计和开发](~/link.aspx?_id=2C66A2C6A29E47CEB3DC7D3505D0DCF7&amp;_z=z)有超过六年的经验。 他专注于移动和 web 的前端产品，并且热衷于使用成熟的设计模式和技术来构建卓越的用户体验。Tyler 曾为每个月数百万用户使用的零售和银行业构建 iOS 应用程序。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
