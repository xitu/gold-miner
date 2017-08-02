
> * 原文地址：[Reactive iOS Programming: Lightweight State Containers in Swift](https://www.captechconsulting.com/blogs/state-containers-in-swift)
> * 原文作者：[Tyler Tillage](https://www.captechconsulting.com/search#q=Tyler Tillage)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/state-containers-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/state-containers-in-swift.md)
> * 译者：
> * 校对者：

# Reactive iOS Programming: Lightweight State Containers in Swift

## The State of Things

Every iOS & MacOS developer has subtly different opinions on how client architecture should work. From the classic [MVC Pattern](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html) built into Apple's own frameworks (read: Massive View Controllers), to those other MV* patterns (MVP, MVVM), to the scary sounding [Viper](https://www.objc.io/issues/13-architecture/viper/), how do we choose?

This article won't answer that question for you, because the true answer is that it *depends on context*. What I do want to highlight is a fundamental approach I've been seeing more often that I really like, the **state container**.

## What is a State Container?

Essentially, state containers are just wrappers around pieces of information, gatekeepers for inputs & outputs to protected data. They don't care too much about the type of data or where it originally came from. But they do care, a lot, about when it is **changed**. The central doctrine of a state container is that the effect of any state change should propagate across the application in an **organized** and **predictable** fashion.

> State containers provide state safety in the same way thread locks provide thread safety.

This isn't a new concept, and it's not a toolkit you can build your entire app with. The state container idea is versatile enough to fit into any app architecture without imposing too many rules. But it's a powerful approach that is at the crux of popular libraries like [ReactiveReSwift](https://github.com/ReSwift/ReactiveReSwift), which is itself based on [ReSwift](https://github.com/ReSwift/ReSwift), which is itself based on [Redux](https://github.com/reactjs/redux), which is itself based on [Flux](https://github.com/facebook/flux)...and the list goes on. The success and sheer number of these frameworks speaks to the efficacy of the state container pattern in modern mobile applications.

In terms of a reactive library like `ReSwift`, state containers bridge the gap between an `Action` and a `View` as part of a uni-directional data flow. Yet even without the other 2 components state containers can be powerful. In fact, they can do much more than these libraries use them for.

In this article I'll demonstrate a basic state container implementation that I've employed for all sorts of projects that didn't warrant pulling in larger architectural libraries.

## Building a State Container

Let's start by constructing our fundamental `State` class.

    /// Wraps a piece of state.classState<Type> {

        /// Unique key used to identify the state across the application.let key: String/// Holds the state itself.
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


This generic class wraps a `_value` of any `Type`, associates it with a `key` and declares an initializer to provide a `defaultValue`.

### Reading State

In order to read the current value of our state container, we'll create a computed `value` property.

Since state changes are typically triggered and read from multiple threads, we'll use a basic [Readers-Writer Lock](https://en.wikipedia.org/wiki/Readers%E2%80%93writer_lock) with Grand Central Dispatch to enforce thread safety when accessing the internal `_value` property.

     extension State {

        /// The current state value.var value: Type {
            var retVal: Type!
            self.lockQueue.sync {
                retVal = self._value // I wish there was a `sync` method that inferred a generic return value.
            }
            return retVal
        }
    }


### Modifying State

In order to modify state, we'll create a `modify(_newValue:)` method. Although we could have allowed the setter to be accessed directly, the goal here is to define structure around state modifications. Using a method over a simple property setter communicates through our API that modifying state has repercussions. Therefore, all state changes must happen through this method.

    extension State {

        /// Modifies the receiver by assigning the `newValue`.
        func modify(_ newValue: Type) {
            self.lockQueue.async(flags: .barrier) {
                self._value = newValue
            }

            // Handle the repercussions of the modificationself.didModify()
        }
    }


 Just for fun, let's also define a custom operator!

    /// Modifies the receiver by assigning the right-hand side of the operator.
    func ~> <T>(lhs: State<T>, rhs: T) {
        lhs.modify(rhs)
    }


### The `didModify()` Method

`didModify()` is the most important piece of our state container, because it allows us to define behaviors that are triggered by state changes. Subclasses of `State` can override this method to perform custom logic whenever this happens.

The `didModify()` method also plays another role. If our generic `Type` is a `class`, it is possible to alter its properties without our state container knowing about it. Therefore we expose the `didModify()` method so that these types of changes can be propagated manually (see below).

This is an inherent danger of using reference types when dealing with state, so I recommend using value types whenever possible.

### Using the State Container

Here's the most basic example of how to use our new `State` class:

    // State wrapping a value typelet themeColor = State(UIColor.blue, key: "themeColor")
    print(themeColor.value) // "UIExtendedSRGBColorSpace 0 0 1 1"

We can use `Optional` types as well:

    // State wrapping an optional value typelet appRating = State<Int?>(nil, key: "appRating")
    print(String(describing: appRating.value)) // "nil"

Modifying our state is easy:

    appRating.modify(4)
    print(String(describing: appRating.value)) // "Optional(4)"

    appRating ~> nil
    print(String(describing: appRating.value)) // "nil"

If we have non value types (e.g. types that don't trigger `didSet` during in-place modification), we invoke the `didModify()` method to let `State` know about the change:

    classCEO : CustomDebugStringConvertible {
        var name: String

        init(name: String) {
            self.name = name
        }

        var debugDescription: String {
            return name
        }
    }

    // State wrapping a reference typelet currentCEO = State(CEO(name: "John Sculley"), key: "currentCEO")
    print(currentCEO.value) // "John Sculley"// Assigning a new user property, no need to invoke `didModify`
    currentCEO ~> CEO(name: "Steve Jobs")
    print(currentCEO.value) // "Steve Jobs"// Modifying the user in-place, need to invoke `didModify` manually
    currentCEO.value.name = "Tim Cook"
    currentCEO.didModify()
    print(currentCEO.value) // "Tim Cook"

Although calling `didModify()` manually is annoying, there's no current way of knowing if a reference type's internal properties have been modified since they are mutable in-place. If you can think of a good way around this, tweet me [@TTillage](https://twitter.com/TTillage)!

## Listening to State Changes

Now that we've established a basic state container, let's expand it to be more powerful. Through our `didModify()` method we can add functionality in the form of specialized subclasses. Let's add a way to "listen" for changes in state, so our UI components can update themselves whenever changes occur.

### Defining a `StateListener`

First, let's define what a state listener looks like:

    protocol StateListener : AnyObject {

        /// Invoked when state is modified.
        func stateModified<T>(_ state: State<T>)

        /// The queue to use when dispatching state modification messages. Defaults to the main queue.var stateListenerQueue: DispatchQueue { get }
    }

    extension StateListener {

        var stateListenerQueue: DispatchQueue {
            return DispatchQueue.main
        }
    }


Whenever state changes, a listener will receive an invocation of `stateModified(_state:)` on the `stateListenerQueue` that it chooses, defaulting to `DispatchQueue.main`.

### Creating the `MonitoredState` Subclass

Next let's define a specialized subclass called `MonitoredState`, which keeps weak references to our listeners and notifies them of state changes. An easy way to do this is to use `NSHashTable.weakObjects()`.

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

            let state = selffor l in allListeners {
                l.stateListenerQueue.async {
                    l.stateModified(state)
                }
            }
        }
    }


Our `MonitoredState` class invokes `stateModified(_state:)` on its listeners whenever its own `didModify` method is called. Easy!

To add a listener, we'll define an `attach(listener:)` method. Just like earlier, we're use `listenerLockQueue` to set up a readers-writer lock on our `listeners` property.

    extension MonitoredState {

        /// Associate a listener with the receiver's changes.
        func attach(listener: StateListener) {
            self.listenerLockQueue.sync(flags: .barrier) {
                self.listeners.add(listener as AnyObject)
            }
        }
    }


Now it's possible to listen to changes to any value that is wrapped in `MonitoredState`!

### Triggering UI Updates from State Changes

Here's an example of how to utilize our new `MonitoredState` class. Let's say we keep track of the device's location in a `MonitoredState` container:

    /// The device's current location.let deviceLocation = MonitoredState<CLLocation?>(nil, key: "deviceLocation")


We also have a view controller which displays the device's current location on a map:

    // Centers a map on the devices's current locationclassLocationViewController : UIViewController {

        @IBOutlet var mapView: MKMapView!

        override func viewDidLoad() {
            super.viewDidLoad()
            self.updateMapForCurrentLocation()
        }

        func updateMapForCurrentLocation() {
            iflet currentLocation = deviceLocation.value {
                // Center the map on the device's location
                self.mapView.setCenter(currentLocation.coordinate, animated: true)
            }
        }
    }


Since we need to update the map when `deviceLocation` changes, we'll extend `LocationViewController` to be a `StateListener`:

    extension LocationViewController : StateListener {

        func stateModified<T>(_state: State<T>) {
            ifstate === deviceLocation {
                print("Location changed, updating UI")
                self.updateMapForCurrentLocation()
            }
        }
    }


Then we'll remember to attach the view controller to the state using `attach(listener:)`. In practice, this could happen in `viewDidLoad`, `init`, or whenever you want the listening to start.

    let vc = LocationViewController()
    deviceLocation.attach(listener: vc)


Now that we're listening to `deviceLocation`, once we get a new location lock from `CoreLocation` all we have to do is modify our state container and our view controller will update itself automatically!

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        iflet closestLocation = locations.first {
            // Triggers `updateMapForCurrentLocation` on the VC asynchronously on the main queue
            deviceLocation ~> closestLocation
        }
    }


Note that since we're using a weak referencing `NSHashTable`, when the view controller is deallocated it will no longer appear in the `allListeners` property of `deviceLocation`. There is no need to "remove" a listener.

Remember that in a real-world scenario you'd want to check to ensure the view controller's `view` is visible before performing a UI update.

## Persisting State

Ok, now we're getting to the good stuff. We have everything we need to be able to take a state container and **persist** it anywhere we want.

1. We have a unique `key` that can be used to associate with a backing store.
2. We know the `Type` of the value, informing how it should be persisted.
3. We know when the value needs to be loaded from storage, using our `init(_defaultValue:key:)` method.
4. We know when the value needs to be persisted to storage, using our `didModify()` method.

### Backing with `UserDefaults`

Let's make a state container that **automatically** persists any changes to `UserDefaults.standard` and re-loads any previous value when initialized. It'll support values that are both `Optional` and non-`Optional`. It'll also automatically serialize & deserialize types that conform to `NSCoding` since `UserDefaults` doesn't support using `NSCoding` directly.

Here's the code, I'll break it down below.

    classUserDefaultsState<Type> : MonitoredState<Type> {

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

1. Our initializer checks to see if `UserDefaults.standard` already contains a value for the provided `key`.
2. If we're able to load an object which matches our generic `Type`, we can use it immediately.
3. If we're able to load `Data` and unarchive it using `NSKeyedUnarchiver`, it was stored using `NSCoding` and we can use it immediately.
4. If nothing exists in `UserDefaults.standard` matching the `key` we'll use the `defaultValue` provided.

#### `didModify()`

5. Whenever the state changes, we want to persist our state automatically. The method of doing so depends on the `Type`.
6. If the generic `Type` is an `Optional` and it's `nil`, we need to simply remove the value from `UserDefaults.standard`. It's a little tricky to check if a generic type is `nil`, but one way to do it is to extend `Optional` with a custom protocol:

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


7. If our value conforms to `NSCoding`, we'll convert it to `Data` using `NSKeyedArchiver` and then persist it.
8. Otherwise, we'll just save the value directly to `UserDefaults`.

Now if we want our state to be backed by `UserDefaults`, all we have to do is use our new `UserDefaultsState` class!

    UserDefaults.standard.set(true, forKey: "isTouchIDEnabled")
    UserDefaults.standard.synchronize()

    let isTouchIDEnabled = UserDefaultsState(false, key: "isTouchIDEnabled")
    print(isTouchIDEnabled.value) // "true"

    isTouchIDEnabled ~> falseprint(UserDefaults.standard.bool(forKey: "isTouchIDEnabled")) // "false"

Our `UserDefaultsState` will automatically update its backing store whenever its value changes. Between app launches, it'll automatically pull the existing value from `UserDefaults` to be used immediately.

### Backing with Other Data Stores

This is just one example of how `State` can be extended to intelligently store its own data. In my projects I have also built subclasses which persist asynchronously to disk or to the keychain when changes occur. You could even trigger synchronization with a remote server, or log metrics to an Analytics library all by just using a different subclass. The sky is the limit.

## Managing State at the App Level

So where should these state containers be kept? Typically I store them statically in a single `struct`, and access them from all over the app. This is similar to how the Flux-based libraries store global app state.

    struct AppState {
        staticlet themeColor = State(UIColor.blue, key: "themeColor")
        staticlet appRating = State<Int?>(nil, key: "appRating")
        staticlet currentCEO = State(CEO(name: "Tim Cook"), key: "currentCEO")
        staticlet deviceLocation = MonitoredState<CLLocation?>(nil, key: "deviceLocation")
        staticlet isTouchIDEnabled = UserDefaultsState(false, key: "isTouchIDEnabled")
    }


You can scope the state containers however you want, in separate or embedded structs and with varying access levels.

## Conclusion

Managing state inside state containers has many benefits. Data that was previously buried inside a singleton, or being passed around in a web of delegation, is now surfaced and visible at a high-level. All of the many inputs into your application's behavior are suddenly visible and organized.

From API responses to feature toggles to protected keychain items, using a state container pattern is a great way to define structure around critical pieces of information. State containers can easily be used for caching, user preferences, analytics, and anything that needs to stick around between app launches.

The state container pattern allows UI components to stop worrying about how & when data is generated, and start focusing on how data is converted into a fantastic user experience.

## About the Author

CapTecher Tyler Tillage is located in the [Atlanta office](~/link.aspx?_id=4848D51075504B57822781008FC5CE6F&amp;_z=z) and has over 6 years of experience in [application design and development](~/link.aspx?_id=2C66A2C6A29E47CEB3DC7D3505D0DCF7&amp;_z=z). He specializes in front-end products for both mobile and web environments and has a passion for building exceptional user experiences using proven design patterns and techniques. Tyler has built iOS applications for the retail and banking industries that are used by millions of users every month.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
