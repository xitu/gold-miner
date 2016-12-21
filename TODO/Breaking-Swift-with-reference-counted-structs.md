>* 原文链接 : [Breaking Swift with reference counted structs](http://www.cocoawithlove.com/blog/2016/03/27/on-delete.html)
* 原文作者 : [Matt Gallagher](http://www.cocoawithlove.com/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Tuccuay](https://github.com/Tuccuay)
* 校对者 : [Jing KE](https://github.com/jingkecn), [Jack King](https://github.com/Jack-Kingdom)

# 打破 Swift 结构体中的循环引用

在 Swift 中，「类」(`class`) 类型会被分配在堆 (heap) 中，并使用引用计数来追踪它的生命周期，并在它被销毁的时候从堆中移除。而「结构体」(`struct`) 则不需要在堆中分配额外的内存空间，也不使用引用计数器机制，同时也就没有了销毁的步骤。

是吧？

事实上，「堆」、「引用计数」、「清除行为」 这些也适用于「结构体」类型。不过要当心：不适当的行为容易引发问题，接下来我将会向你展示你可能会怎样把「结构体」当成「类」来使用的结果，并告诉你为什么会导致内存泄漏、错误行为和编译器错误。

> **警告**：这篇文章使用了一些 __反模式__（你千万不要真的去这么干），我这么做是为了突出结构体在使用闭包时一些不容易被注意到的风险，避免危险的最好方式就是掌握好它们，除非你了解风险后还能怡然自得。

目录：

1.  [在结构体中类的作用域](#class-fields-in-a-struct)
2.  [尝试从一个闭包中访问结构体](#trying-to-access-a-struct-from-a-closure)
3.  [疯狂的循环](#completely-loopy)
4.  [我们要怎样破解这个循环？](#can-we-break-the-loop)
5.  [复制行不通，共享引用怎么样？](#copies-bad-shared-references-good)
6.  [一些观点](#some-perspective)
7.  [说在最后](#conclusion)

## 在结构体中类的作用域 <a name="class-fields-in-a-struct" />

虽然一个「结构体」通常不会具有 `deinit` 方法，但像其它的 Swift 类型一样，他也需要被正确的引用计数。当结构体内的成员变量被引用或者整个结构体被销毁时，都必须正确的将引用计数增加或减少。

事实上我们可以这样做，当一个「结构体」满足一定条件的时候，其引用计数将随「结构体」的相应行为减少，就好像它拥有 `deinit` 方法一样，要做到这一点，我们可以使用 OnDelete 类

```swift
public final class OnDelete {
    var closure: () -> Void
    public init(_ c: () -> Void) {
        closure = c
    }
    deinit {
        closure()
    }
}
```

并且这样来使用这个 `OnDelete` 类：

```swift
struct DeletionLogger {
    let od = OnDelete { print("DeletionLogger deleted") }
}

do {
    let dl = DeletionLogger()
    print("Not deleted, yet")
    withExtendedLifetime(dl) {}
}
```

将会得到这样的输出：

```bash
Not deleted, yet
DeletionLogger deleted
```

当 `DeletionLogger` 被删除（也就是在 `print` 之后的 `withExtendedLifetime` 运行完之后），`OnDelete` 的闭包将会被执行。

## 尝试从一个闭包中访问结构体 <a name="trying-to-access-a-struct-from-a-closure" />

现在看起来还一切正常，一个 `OnDelete` 对象可以在结构体被销毁之前执行一个函数，这看起来有点像是 `deinit` 方法。不过虽然它看起来能模仿「类」的 `deinit` 行为，但是 `deinit` 有一个很重要的功能 `OnDelete` 方法办不到：在结构体的作用域内运行。

尽管这是一个很糟糕的主意，不过还是让我们来尝试着来访问一下结构体看看会有什么不顺心的事情发生。我们将使用一个简单的结构体，它会有一个 `Int` 值和一个 `OnDelete` 闭包，最后会输出一个 `Int` 值。

```swift
struct Counter {
    let count = 0
    let od = OnDelete { print("Counter value is \(count)") }
}
```

我们不能这样干（报错信息：`Instance member 'count' cannot be used on type 'SomeStruct'`）。这不奇怪：我们没有被允许这样做，你不能从一个类的初始化方法 (`initializer`) 中访问其它空间。

让我们来正确的初始化一个结构体并且尝试着获取其中一个成员变量：

```swift
struct Counter {
    let count = 0
    var od: OnDelete? = nil
    init() {
        od = OnDelete { print("Counter value is \(self.count)") }
    }
}
```

编译器在 Swift 2.2 报了一个「内存区段错误」(segmentation fault)，而在 Swift 开发版本快照 (Swift Development Snapshot) 2016-03-26 版本则报了一个「致命错误」(fatal error)。

"Excellent!"，我现在很开心(I'm Angry!)。

当然，我能这样避免所有的编译错误：

```swift
struct Counter {
    var count: Int
    let od: OnDelete
    init() {
        let c = 0
        count = c
        od = OnDelete { print("Counter value is \(c)") }
    }
}
```

或者用另一种不常见的方法，在这种情况下它们是等效的：

```swift
struct Counter {
    var count = 0
    let od: OnDelete?
    init() {
        od = OnDelete { [count] in print("Counter value is \(count)") }
    }
}
```

可是这两个方法并不能真的让我们访问到这个结构体本身。因为这两种方法捕捉到的都只是 `count` 的不可变副本，但是我们想要得到的是最新的 `count` 可变值。

```swift
struct Counter {
    var count = 0
    var od: OnDelete?
    init() {
        od = OnDelete { print("Counter value is \(self.count)") }
    }
}
```

万岁！这样就更完美了。 一切都是可变的并且共享的。 我们捕获到了 count 变量，并且通过了编译。

我们应该来尝试使用这个代码，因为他能很好的工作，不是吗？

## 疯狂的循环 <a name="completely-loopy" />

如果我们像之前那样运行代码的话，显然是不行的：

```swift
do {
    let c = Counter()
    print("Not deleted, yet")
    withExtendedLifetime(c) {}
}
```

我们只会得到这样的输出：

```bash
Not deleted, yet
```

这个 `OnDelete` 闭包没有被调用，为什么？

通过查看 SIL(Swift Intermediate Language，Swift 中继语言，通过 `swiftc -emit-sil` 命令返回)，很显然在 `OnDelete` 的闭包里阻止了 `self` 被优化到堆中。这就意味着并非使用 `alloc_stack`，`self` 变量是通过 `alloc_box` 来分配的：

```bash
%1 = alloc_box $Counter, var, name "self", argno 1 // users: %2, %20, %22, %29
```

并且这个 `OnDelete` 的闭包引用了这个 `alloc_box`。

发生了什么问题？这是一个引用计数循环：

闭包引用了这个封装的 `Counter` → 这个封装的 `Counter` 引用了 `OnDelete` → `OnDelete` 引用了闭包

当这个循环产生之后，我们的 `OnDelete` 对象永远都不会被释放，从而也就不会去调用那个闭包。

## 我们要怎样破解这个循环？ <a name="can-we-break-the-loop" />

如果 `Counter` 是一个类，我们可以使用 `[weak self]` 闭包来避免这个循环强引用，然而 `Counter` 是一个结构体而不是一个类，试图这样做只会得到一个报错，真糟糕。

我们能不能手动打破这个循环，在构造之后，把 `od` 属性设置为 `nil`？

```swift
var c = Counter()
c.od = nil
```

不行，依然不能正常工作，这是为什么呢？

当 `Counter.init` 函数结束时，`alloc_box` 所创建的被拷贝到了堆栈中。这意味着这个被 `OnDelete` 引用的副本与我们所访问到的副本不同。`OnDelete` 引用的副本现在我们无法访问。

我们已经创建了一个牢不可破的循环。

就像 [Joe Groff 在推上说的那样](https://twitter.com/jckarter/status/715171466283646977)，Swift 发展进程 SE-0035 应该避免此问题的产生，通过限制最大 `inout` 捕获（也就是 `Counter.init` 方法使用的那种捕捉），直到 `@noescape` 闭包（这将防止 `OnDelete` 的尾随闭包被捕获）。

## 复制行不通，共享引用怎么样？ <a name="copies-bad-shared-references-good" />

这样的问题产生是因为我们的方法返回的副本和从 `self` 的 `Counter.init` 返回的不同。我们需要的让返回的版本和引用的版本相同。

让我们避免在 `init` 方法中做任何事情，并且使用一个 `static`（静态）方法来替代它。

```swift
struct Counter {
    var count = 0
    var od: OnDelete? = nil
    static func construct() -> Counter {
        var c = Counter()
        c.od = OnDelete{
            print("Value loop break is \(c.count)")
        }
        return c
    }
}

do {
    var c = Counter.construct()
    c.count += 1
    c.od = nil
}
```

还是同样的问题：我们获得了一个 `Counter` ，它被永久性的嵌入在 `OnDelete` 上，这不是被返回的那个版本。

让我们来改变这个 `static` 方法...

```swift
struct Counter {
    var count = 0
    var od: OnDelete? = nil
    static func construct() -> () -> () {
        var c = Counter()
        c.od = OnDelete{
            print("Value loop break is \(c.count)")
        }
        return {
            c.count += 1
            c.od = nil
        }
    }
}

do {
    var loopBreaker = Counter.construct()
    loopBreaker()
}
```

现在的输出是这样：

```bash
Counter value is 1
```

这样终于奏效了，可以看到我们的 `loopBreaker` 闭包正确的影响到了 `OnDelete` 闭包的打印结果。

现在我们不再需要返回 `Counter` 实例，我们不再会拷贝一个单独的副本。现在只有一个 `Counter` 实例的副本并且它 `alloc_box` 的版本同时共享给两个闭包，我们引用了堆中的 `struct`，并且 `OnDelete` 方法也可以在 `struct` 被销毁的时候正确的访问到它的成员变量了。

# 一些观点 <a name="some-perspective" />

这份代码在技术上能够「运行」，但事实上一团糟。我们造成了一个循环强引用，我们只能手动打破它，我们可以只在 `Counter` 的闭包中设置 `construct` 函数并且只有一个基于此的实例，我们现在在堆中分配了 4 份空间。（`OnDelete` 中的闭包，`OnDelete` 对象本身，封装起来的 `c` 变量和 `loopBreaker` 闭包）。

如果你还没有意识到问题的所在...那我们白白浪费了这些时间。

我们一开始只要创建 `Counter` 为一个「类」，就可以保持分配的堆的数量为 1。

```swift
class Counter {
    var count = 0
    deinit {
        print("Counter value is \(count)")
    }
}
```

长话短说：如果你需要从一个不同的作用域中访问一个可变的数据，那么结构体很可能不是一个好的选择。

## 说在最后 <a name="conclusion" />

闭包捕获是我们写了一些东西并且期望编译器将要做这些事情的时候使用。无论如何，捕获可变的值将会有多种结果，有一些微妙的不同，需要弄明白这点才能避免这些问题。为了修复这些小问题我们使用了复杂的方法，希望 Swift 3 能够修复这些问题。

别忘了在类的属性中捕获结构体也要考虑循环引用的问题。你不能弱引用得捕获结构体，所以如果发生了一个循环强引用，你需要用其它的方法来打破它。

所有情况都表明，这篇文章带你看了一种非常愚蠢的做法：试图用一个结构体捕获它自身。不要那样做，像其它使用引用计数的结构一样，不应该是一个循环。如果你发现你正在尝试着创造一个循环，那你可能需要使用 `class` 类型并且用 weak（弱引用）来从子元素连接父元素。

最后的最后，我还有一个使用 `OnDelete` 这个类的好想法（我将会在下一篇文章中使用它），但是我不应该在一开始就想着让它能够像 `deinit` 方法一样工作——这是它产生问题的关键（它的属性超出作用域）。
