> * 原文地址：[Swift Arrays Holding Elements With Weak References](https://marcosantadev.com/swift-arrays-holding-elements-weak-references/)
> * 原文作者：[Marco Santarossa](https://marcosantadev.com/about-me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# [Swift Arrays Holding Elements With Weak References](https://marcosantadev.com/swift-arrays-holding-elements-weak-references/) #

![](https://marcosantadev.com/wp-content/uploads/header-1.jpg)

In iOS development there are moments where you ask yourself: “To weak, or not to weak, that is the question”. Let’s see how “to weak” with the arrays.

# Overview #

*In this article, I speak about memory management without explaining it since it would be beyond the goal of this article. The [official documentation](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html) is a good starting point to learn this subject. Then, if you have other doubts, please leave a comment and I’ll reply as soon as possible.*

`Array` is the most popular collection in Swift. By default, it maintains a strong references of its elements. Even if this behaviour is useful most of the time, you might have some scenarios where you would want to use weak references. For this reason, Apple provides an alternative to `Array` which maintains weak references of its elements: **NSPointerArray**.

Before looking at this class, let’s see and example to understand why we should use it.

# Why Weak References? #

Let’s use, as example, a `ViewManager` class which has two properties of type `View`. In its constructor, we add these views in an array to inject inside `Drawer`—which uses this array to draw something inside the views. Finally, we have a method `destroyViews` to destroy the two `View`s:

```
class View { }
 
class Drawer {
 
    private let views: [View]
 
    init(views: [View]) {
        self.views = views
    }
 
    func draw() {
        // draw something in views
    }
}
 
class ViewManager {
 
    private var viewA: View? = View()
    private var viewB: View? = View()
    private var drawer: Drawer
 
    init() {
        self.drawer = Drawer(views: [viewA!, viewB!])
    }
 
    func destroyViews() {
        viewA = nil
        viewB = nil
    }
}
```
 

Unfortunately, `destroyViews` doesn’t destroy the two views because the array inside `Drawer` is maintaining a strong reference of the views. We can avoid this problem replacing the array with a `NSPointerArray`.

# [NSPointerArray](https://developer.apple.com/reference/foundation/nspointerarray) #

`NSPointerArray` is an alternative to `Array` with the main difference that it doesn’t store an object but its pointer (`UnsafeMutableRawPointer`).

This type of array can store the pointer maintaining either a weak or a strong reference depending on how it’s initialised. It provides two static methods to be initialised in different ways:

```
let strongRefarray = NSPointerArray.strongObjects() // Maintains strong references
let weakRefarray = NSPointerArray.weakObjects() // Maintains weak references
```
 

Since we want an array of weak references, we’ll use `NSPointerArray.weakObjects()`.

Now, we can add a new object in this array:

```
class MyClass { }
 
var array = NSPointerArray.weakObjects()
 
let obj = MyClass()
let pointer = Unmanaged.passUnretained(obj).toOpaque()
array.addPointer(pointer)
```

Since using the pointer may be annoying, you can use this extension which I made to simplify the `NSPointerArray`:

```
extension NSPointerArray {
    func addObject(_ object: AnyObject?) {
        guard let strongObject = object else { return }
 
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
 
    func insertObject(_ object: AnyObject?, at index: Int) {
        guard index < count, let strongObject = object else { return }
 
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
 
    func replaceObject(at index: Int, withObject object: AnyObject?) {
        guard index < count, let strongObject = object else { return }
 
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
 
    func object(at index: Int) -> AnyObject? {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
 
    func removeObject(at index: Int) {
        guard index < count else { return }
 
        removePointer(at: index)
    }
}
```

Thanks to this extension, you can replace the previous example with:

```
var array = NSPointerArray.weakObjects()
 
let obj = MyClass()
array.addObject(obj)
``` 

If you want to clean the array removing the objects with value `nil`, you can call the method `compact()`:

```
array.compact()
```
 
At this point, we can refactor the example used in “Why Weak References?” with the following code:

```
class View { }
 
class Drawer {
 
    private let views: NSPointerArray
 
    init(views: NSPointerArray) {
        self.views = views
    }
 
    func draw() {
        // draw something in views
    }
}
 
class ViewManager {
 
    private var viewA: View? = View()
    private var viewB: View? = View()
    private var drawer: Drawer
 
    init() {
        let array = NSPointerArray.weakObjects()
        array.addObject(viewA)
        array.addObject(viewB)
        self.drawer = Drawer(views: array)
    }
 
    func destroyViews() {
        viewA = nil
        viewB = nil
    }
}
 
```

Note:

1. You may have noticed that `NSPointerArray` stores pointers of `AnyObject` only, it means that you can store just classes—so neither structs nor enums. You can store protocols if they have the keyword [`class`](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID281):

```
protocolMyProtocol: class{}
```

2. If you want to play with `NSPointerArray`, I suggest you to avoid the Playground since you may have odd behaviours with the retain count. A sample app would be better.

# Alternatives #

`NSPointerArray` is very useful to store objects maintaining weak references, but it has a problem: it’s not type-safe.

For “not type-safe”, I mean that the compiler is not able to infer the type of the objects inside `NSPointerArray`, since it uses pointers of objects `AnyObject`. For this reason, when you get an object from the array, you must cast it to your object type:

```
ifletfirstObject=array.object(at:0)as?MyClass{// Cast to MyClass

    print("The first object is a MyClass")

}

``` 

*`object(at:)` comes from my `NSPointerArray` extension which I shown previously.*

If we want to use a type-safe alternative we can’t use `NSPointerArray` anymore.

A possible workaround is creating a new class `WeakRef` with a generic weak property `value`:

```
classWeakRef<T>whereT: AnyObject{

    private(set)weakvarvalue:T?

    init(value:T?){

        self.value=value

    }

}
```
 

*`private(set)` exposes `value` in read-only mode, in this way no one can set its value from outside the class.*

Then, we can create an array of `WeakRef`, where `value` is your `MyClass` object to store:

```
vararray=[WeakRef<MyClass>]()

 

letobj=MyClass()

letweakObj=WeakRef(value:obj)

array.append(weakObj)
``` 

Now, we have an array type-safe which maintains a weak reference of your `MyClass` objects. The disadvantage of this approach is that we must add an extra layer in our code (`WeakRef`) to wrap the weak reference in a type-safe way.

If you want to clean the array removing the objects with value `nil`, you can write the following method:

```
funccompact(){

    array=array.filter{$0.value!=nil}

}
```

*`filter` returns a new array with the elements that satisfy the given predicate. You can find more details in the [documentation](https://developer.apple.com/reference/swift/array/1688383-filter).*

Now, we can refactor the example used in “Why Weak References?” with the following code:

```
class View { }
 
class Drawer {
 
    private let views: [WeakRef<View>]
 
    init(views: [WeakRef<View>]) {
        self.views = views
    }
 
    func draw() {
        // draw something in views
    }
}
 
class ViewManager {
 
    private var viewA: View? = View()
    private var viewB: View? = View()
    private var drawer: Drawer
 
    init() {
        var array = [WeakRef<View>]()
        array.append(WeakRef<View>(value: viewA))
        array.append(WeakRef<View>(value: viewB))
        self.drawer = Drawer(views: array)
    }
 
    func destroyViews() {
        viewA = nil
        viewB = nil
    }
}
```

A cleaner version using the typealias:

```
typealias WeakRefView = WeakRef<View>
 
class View { }
 
class Drawer {
 
    private let views: [WeakRefView]
 
    init(views: [WeakRefView]) {
        self.views = views
    }
 
    func draw() {
        // draw something in views
    }
}
 
class ViewManager {
    private var viewA: View? = View()
    private var viewB: View? = View()
    private var drawer: Drawer
 
    init() {
        var array = [WeakRefView]()
        array.append(WeakRefView(value: viewA))
        array.append(WeakRefView(value: viewB))
        self.drawer = Drawer(views: array)
    }
 
    func destroyViews() {
        viewA = nil
        viewB = nil
    }
}
```
 
# Dictionary And Set #

This article has the main focus on `Array`, if you need something similar to `NSPointerArray` for `Dictionary` you can have a look at [NSMapTable](https://developer.apple.com/reference/foundation/nsmaptable), whereas for `Set` you can use [NSHashTable](https://developer.apple.com/reference/foundation/nshashtable).

If you want a type-safe `Dictionary`/`Set`, you can achieve it storing a `WeakRef` object.

# Conclusion #

I guess you are not going to use arrays with weak references very often, but it’s not an excuse not to know how to achieve it. In iOS development the memory management is very important to avoid memory leaks, since iOS doesn’t have a garbage collector. ¯\_(ツ)_/¯


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
