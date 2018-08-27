> * 原文地址：[Swift Arrays Holding Elements With Weak References](https://marcosantadev.com/swift-arrays-holding-elements-weak-references/)
> * 原文作者：[Marco Santarossa](https://marcosantadev.com/about-me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[zhangqippp](https://github.com/zhangqippp)
> * 校对者：[ZhangRuixiang](https://github.com/ZhangRuixiang)，[Danny1451](https://github.com/Danny1451)

# [对元素持有弱引用的Swift数组](https://marcosantadev.com/swift-arrays-holding-elements-weak-references/) #

![](https://marcosantadev.com/wp-content/uploads/header-1.jpg)

在 iOS 开发中我们经常面临一个问题：“用弱引用还是不用，这是一个问题。”。我们来看一下如何在数组中使用弱引用。

# 概述 #

**在本文中，我会谈到内存管理但是不会解释它，因为这不是本文的主题。[官方文档](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html)是学习内存管理的一个好的起点。如果你有其它疑问，请留言，我会尽快给予回复。**

`Array` 是Swift中使用最多的集合。它会默认地对其元素持有强引用。 这种默认的行为在大多数时候都很有用，但是在某些场景下你可能想要使用弱引用。因此，苹果公司给我们提供了一个 `Array` 的替代品：**NSPointerArray**，这个类对它的元素持有弱引用。

在开始研究这个类之前，我们先通过一个例子来了解为什么我们需要使用它。

# 为什么要使用弱引用？ #

举个例子，我们有一个 `ViewManager` ，它有两个 `View` 类型的属性。在它的构造器中，我们把这些视图添加到 `Drawer` 内部的一个数组中，`Drawer` 使用这个数组在其中的视图内绘制一些内容。最后，我们还有一个 `destroyViews` 方法来销毁这两个 `View`：

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
 

但是，`destroyViews` 方法并没能销毁这两个视图，因为 `Drawer` 内部的数组依然对这些视图保持着强引用。我们可以通过使用 `NSPointerArray` 来避免这个问题。

# [NSPointerArray](https://developer.apple.com/reference/foundation/nspointerarray) #

`NSPointerArray` 是 `Array` 的一个替代品，主要区别在于它不存储对象而是存储对象的指针（ `UnsafeMutableRawPointer` ）。 

这种类型的数组可以管理弱引用也可以管理强引用，取决于它是如何被初始化的。它提供两个静态方法以便我们使用不同的初始化方式：

```
let strongRefarray = NSPointerArray.strongObjects() // Maintains strong references
let weakRefarray = NSPointerArray.weakObjects() // Maintains weak references
```
 

我们需要一个弱引用的数组，所以我们使用 `NSPointerArray.weakObjects()`。

现在，我们向数组中添加一个新对象：

```
class MyClass { }
 
var array = NSPointerArray.weakObjects()
 
let obj = MyClass()
let pointer = Unmanaged.passUnretained(obj).toOpaque()
array.addPointer(pointer)
```

如果你觉得这样使用指针很烦，你可以使用我写的这个扩展，可以简化 `NSPointerArray ` 的使用：

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

有了这个扩展类，你可以将前面的例子替换为：

```
var array = NSPointerArray.weakObjects()
 
let obj = MyClass()
array.addObject(obj)
``` 

如果你想清理这个数组，把其中的对象都置为 `nil`，你可以调用 `compact()` 方法：

```
array.compact()
```
 
到了这里，我们可以将上一小节 “为什么要使用弱引用？” 中的例子重构为如下代码：

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

注意:

1. 你可能已经注意到了 `NSPointerArray` 只存储 `AnyObject` 的指针，这意味着你只能存储类 —— 结构体和枚举都不行。你可以存储带有 [`class`](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID281) 关键字的协议：

```
protocolMyProtocol: class{}
```

2. 如果你想试用一下 `NSPointerArray`，我建议不要使用 Playground ，因为你可能因为引用计数问题得到一些奇怪的行为。使用一个简单的 app 会更好。

# 备选方案 #

`NSPointerArray` 对于存储对象和保持弱引用来说非常有用，但是它有一个问题：它不是类型安全的。 

“非类型安全”，在此处的意思是编译器无法无法推断隐含在 `NSPointerArray` 内部的对象的类型，因为它使用的是 `AnyObject` 型对象的指针。因此，当你从数组中获取一个对象时，你需要把它转成你所需要的类型：

```
if let firstObject=array.object(at:0)as?MyClass{// Cast to MyClass

    print("The first object is a MyClass")

}

``` 

**`object(at:)` 方法来自我先前展示的 `NSPointerArray` 扩展类。**

如果我们想使用一个类型安全的数组替代品，我们就不能使用 `NSPointerArray` 了。 

一个可行的方案是创建一个新类 `WeakRef` ，它带有一个普通的weak属性 `value`：

```
class WeakRef<T>whereT: AnyObject{

    private(set)weakvarvalue:T?

    init(value:T?){

        self.value=value

    }

}
```
 

**`private(set)` 方法将 `value` 设置为只读模式, 这样就无法在类的外部设置它的值了。**

然后，我们可以创建一组 `WeakRef` 对象，将你的 `MyClass` 对象储存到它们的 `value` 属性：

```
var array=[WeakRef<MyClass>]()

 

let obj=MyClass()

let weakObj=WeakRef(value:obj)

array.append(weakObj)
``` 

现在，我们拥有一个类型安全的数组，其内部对你的 `MyClass` 对象持有弱引用。这种实现的坏处在于，我们必须在代码中多加一层（`WeakRef`），来用一种类型安全的方式包裹弱引用。

如果你想清理数组，去除其中值为 `nil` 的对象，你可以使用下面的方法：

```
func compact(){

    array=array.filter{$0.value!=nil}

}
```

**`filter` 返回一个其中元素满足给定条件的新数组。你可以在[文档](https://developer.apple.com/reference/swift/array/1688383-filter)中获取更多的信息。**

现在，我们可以将 “为什么要使用弱引用？” 小节中的例子重构为如下代码：

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

使用类型别名的更简洁的版本如下：

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
 
# Dictionary 和 Set #

本文主要讨论了 `Array`，如果你需要 `Dictionary` 的类似于 `NSPointerArray` 的替代品，你可以参考 [NSMapTable](https://developer.apple.com/reference/foundation/nsmaptable)，以及 `Set` 的替代品 [NSHashTable](https://developer.apple.com/reference/foundation/nshashtable)。

如果你需要一个类型安全的 `Dictionary`/`Set`，你可以通过使用 `WeakRef` 对象来实现。

# 结论 #

你可能不会经常使用持有弱引用的数组，但是这不是不去了解其实现原理的理由。在 iOS 开发中，内存管理是非常重要的，我们应该避免内存泄露，因为 iOS 没有垃圾回收器。 ¯\_(ツ)_/¯


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
