> * 原文地址：[When Should I Use @State, @Binding, @ObservedObject, @EnvironmentObject, or @Environment?](https://jaredsinclair.com/2020/05/07/swiftui-cheat-sheet.html)
> * 原文作者：[Jared Sinclair](https://jaredsinclair.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-cheat-sheet.md](https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-cheat-sheet.md)
> * 译者：
> * 校对者：

# 我们应该在什么时候使用 \@State、\@Binding、\@ObservedObject、\@EnvironmentObject 和 \@Environment？

SwiftUI 引入了一系列新的属性包装器，你的代码可以通过它们来架起程序状态和视图之间的桥梁:

```swift
 @State
 @Binding
 @ObservedObject
 @EnvironmentObject
 @Environment
```

这只是其中一部分。还有其他用于 Core Data 获取请求和手势识别器的属性包装器。 但本文与其他包装器无关。与上面的包装器不同，`@FetchRequest` 和`@GestureState` 的用例是明确的，然而，何时使用 `@State` 还是 `@Binding`，或 `@ObservedObject` 还是 `@EnvironmentObject` ，等等，会非常令人困惑。

本文试图通过简单、可重复的术语来定义每个包装器合适的使用时机。在这里我可能有点过于规定性，但我从这些规则中已经得到了一些不错的收获。 此外，过度规范是一个由来已久的程序员编写博客的传统，因此尽管偶尔会令人讨厌，但我的处境还是不错的。

下面的所有代码示例代码都可以在 [GitHub repo](https://github.com/jaredsinclair/swiftui-property-wrappers) 中找到。

> **注意：本文是使用 Swift 5 和 iOS 13 编写的。**

## 速查表

1. 当你的视图需要改变它自己的属性时，请使用 `@State`。
2. 当你的视图需要更改祖先视图所拥有的属性或祖先引用的可观察对象所拥有的属性时，请使用 `@Binding` 。
3. 当你的视图依赖于可观察对象时，请使用 `@ObservedObject`，该对象可以创建自己，也可以传递给该视图的初始值设定项。
4. 当通过视图所有祖先的初始化器传递一个可观察对象太麻烦时，请使用 `@EnvironmentObject`。
5. 当视图所依赖的类型不符合 observeObject 时，请使用 `@Environment`。
6. 当视图依赖于多个相同类型的实例时，只要该类型不需要被用作可观察对象，也可以使用 `@Environment`。
7. 如果你的视图需要同一个可观察对象类的多个实例，那么不走运了。您不能使用 `@EnvironmentObject` 或 `@Environment` 来解决问题。(不过，在这篇文章的底部有一个简单的变通方法)。

## 你的视图需要一个 `@State` 属性，如果…

### …当需要对自己的一个属性进行读/写访问以供私有使用时。

就像是是 UIButton 上的 `isHighlighted` 属性。其他对象不需要知道按钮什么时候高亮显示，也不需要对该属性进行赋值操作。如果你要在 SwiftUI 中从头开始实现一个按钮，那么你的 `isHighlighted` 属性将是 @State 包装器的一个很好的候选。

```swift
struct CustomButton<Label>: View where Label : View {
    let action: () -> Void
    let label: () -> Label

    /// it needs read/write access to one of 
    /// its own properties for private use
    @State private var isHighlighted = false
}
```

### …当需要向子视图提供对其某个属性进行读/写访问。

视图通过传递 @State-wrapped 属性的 `projectedValue`来实现这一点，该属性是该值的绑定  [1]。一个很好的例子是 SwiftUI.Alert。视图负责通过改变一些 @State 的值来显示 Alert 弹框，比如一个 `isPresentingAlert` 的布尔属性。但是视图不能隐藏 Alert 弹框本身，因为 Alert 弹框并不知道它所弹出的视图。通过绑定解决了这个难题。通过使用编译器生成的 `self.$isPresentingAlert` 属性，视图与 Alert 弹框的 `isPresentingAlert` 属性做了一个绑定，这是 @State 包装器的预测值的语法糖。`.alert(isPresented:content:)` 修饰符接受了这个绑定，随后，Alert 弹框将它的 `isPresentingAlert` 属性设为 false，从而实现了弹框的自动解散。

```swift
struct MyView: View {
    /// it needs to provide read/write access of 
    /// one of its properties to a descendant view
    @State var isPresentingAlert = false

    var body: some View {
        Button(action: {
            self.isPresentingAlert = true
        }, label: {
            Text("Present an Alert")
        })
        .alert(isPresented: $isPresentingAlert) {
            Alert(title: Text("Alert!"))
        }
    }
}
```

## 你的视图需要一个 `@Binding` 属性，如果…

### …它需要对祖先视图的 `State`包装属性进行读/写访问

就像上述 Alert 弹框的反例一样。如果你的视图类似于 Alert 弹框，它依赖于祖先所拥有的值，并且关键的是，需要对该值的可变访问，那么视图需要一个 @Binding 到该值。

```swift
struct MyView: View {
    @State var isPresentingAlert = false

    var body: some View {
        Button(action: {
            self.isPresentingAlert = true
        }, label: {
            Text("Present an Alert")
        })
        .customAlert(isPresented: $isPresentingAlert) {
            CustomAlertView(title: Text("Alert!"))
        }
    }
}

struct CustomAlertView: View {
    let title: Text
    
    /// it needs read/write access to a State-
    /// wrapped property of an ancestor view
    @Binding var isBeingPresented: Bool
}
```

### …它需要对符合 `ObservableObject` 的对象的属性进行读/写访问，但是对该对象的引用是由其祖先拥有的。

天啊，真拗口。在这种情况下，有三件事：

1. 一个可观察的物体
2. 具有引用该对象的 @-Something 包装器的祖先视图
3. **你的**视图是 #2 的后代。

你的视图需要具有对该可观察对象的某些成员的读/写访问权限，但是你的视图没有（也不应）具有对该可观察对象的访问权限。然后，视图将为该值定义一个@Binding 属性，该属性将在视图初始化时由其祖先视图提供。这方面的一个很好的例子是任何可重用的输入视图，如选择器或文本框。 一个文本框需要能够对另一个对象上的一些字符串属性有读/写访问权，但是文本框不应该与那个特定的对象有紧密耦合。相反，文本框的 @Binding 属性将提供对字符串属性的读/写访问权限，而无需将该属性直接暴露给文本框。

```swift
struct MyView: View {
    @ObservedObject var person = Person()

    var body: some View {
        NamePicker(name: $person.name)
    }
}

struct NamePicker: View {

    /// it needs read/write access to a property 
    /// of an observable object owned by an ancestor
    @Binding var name: String

    var body: some View {
        CustomButton(action: {
            self.name = names.randomElement()!
        }, label: {
            Text(self.name)
        })
    }
}
```

## 你的视图需要一个 `@ObservedObject` 属性，如果…

### …它取决于可实例化的可观察对象。

假设你有一个视图，用来展示从网络服务获取的项目列表。SwiftUI 的视图是暂时的、可丢弃的值类型。它们很适合展示内容，但不适合进行网络服务请求。此外，你不应该将用户界面代码与其他任务混在一起，因为那样会违反[单一职责原则](https://en.wikipedia.org/wiki/Single-responsibility_principle)。取而代之的是，你可能会将这些责任转移给另一个对象，该对象可以协调发出请求，解析响应并将响应映射到用户界面模型值所需的值。视图将通过 @ObservedObject 包装器拥有对该对象的引用。

```swift
struct MyView: View {

    /// it is dependent on an object that it 
    /// can instantiate itself
    @ObservedObject var veggieFetcher = VegetableFetcher()

    var body: some View {
        List(veggieFetcher.veggies) {
            Text($0.name)
        }.onAppear {
            self.veggieFetcher.fetch()
        }
    }
}
```

### …它依赖于一个引用类型对象，该对象可以很容易地传递给视图的构造器。

这个场景与前面的场景几乎相同，除了视图之外还有其他一些对象负责初始化和配置可观察对象。如果某些 UIKit 代码负责呈现你的 SwiftUI 视图，则可能会出现这种情况，特别是如果可观察对象在没有引用其他 SwiftUI 视图时，在不能（或不应该）访问依赖项的情况下被访问。 

```swift
struct MyView: View {

    /// it is dependent on an object that can
    /// easily be passed to its initializer
    @ObservedObject var dessertFetcher: DessertFetcher

    var body: some View {
        List(dessertFetcher.desserts) {
            Text($0.name)
        }.onAppear {
            self.dessertFetcher.fetch()
        }
    }
}

extension UIViewController {

    func observedObjectExampleTwo() -> UIViewController {
        let fetcher = DessertFetcher(preferences: .init(toleratesMint: false))
        let view = ObservedObjectExampleTwo(dessertFetcher: fetcher)
        let host = UIHostingController(rootView: view)
        return host
    }

}
```

## 你的视图需要一个 `@EnvironmentObject` 属性，如果…

### …将观察到的对象传递给视图所有祖先的所有构造器，这样太麻烦了

Let’s return to the second example from the @ObservedObject section above, where an observable object is needed to carry out some tasks on behalf of your view, but your view is unable to initialize that object by itself. But let’s now imagine that your view is not a root view, but a descendant view that is deeply nested within many ancestor views. If none of the ancestors need the observed object, it would be painfully awkward to require every view in that chain of views to include the observed object in their initializer arguments, just so the one descendant view has access to it. Instead, you can provide that value indirectly by tucking it into the SwiftUI environment around your view. Your view can access that environment instance via the @EnvironmentObject wrapper. Note that once the @EnvironmentObject’s value is resolved, this use case is functionally identical to using an object wrapped in @ObservedObject.

```swift
struct SomeChildView: View {

    /// it would be too cumbersome to pass that 
    /// observed object through all the initializers 
    /// of all your view's ancestors
    @EnvironmentObject var veggieFetcher: VegetableFetcher

    var body: some View {
        List(veggieFetcher.veggies) {
            Text($0.name)
        }.onAppear {
            self.veggieFetcher.fetch()
        }
    }
}

struct SomeParentView: View {
    var body: some View {
        SomeChildView()
    }
}

struct SomeGrandparentView: View {
    var body: some View {
        SomeParentView()
    }
}
```

## 你的视图需要一个 `@Environment` 属性，如果…

### …这取决于是否符合 ObservableObject 类型。

Sometimes your view will have a dependency on something that cannot conform to ObservableObject, but you wish it could because it’s too cumbersome to pass it as a initializer argument. There are a number of reasons why a dependency might not be able to conform to ObservableObject:

* The dependency is a value type (struct, enum, etc.)
* The dependency is exposed to your view only as a protocol, not as a concrete type
* The dependency is a closure

In cases like these, your view would instead use the @Environment wrapper to obtain the required dependency. This requires some boilerplate to accomplish correctly.

```swift
struct MyView: View {

    /// it is dependent on a type that cannot 
    /// conform to ObservableObject
    @Environment(\.theme) var theme: Theme

    var body: some View {
        Text("Me and my dad make models of clipper ships.")
            .foregroundColor(theme.foregroundColor)
            .background(theme.backgroundColor)
    }
}

// MARK: - Dependencies

protocol Theme {
    var foregroundColor: Color { get }
    var backgroundColor: Color { get }
}

struct PinkTheme: Theme {
    var foregroundColor: Color { .white }
    var backgroundColor: Color { .pink }
}

// MARK: - Environment Boilerplate

struct ThemeKey: EnvironmentKey {
    static var defaultValue: Theme {
        return PinkTheme()
    }
}

extension EnvironmentValues {
    var theme: Theme {
        get { return self[ThemeKey.self]  }
        set { self[ThemeKey.self] = newValue }
    }
}
```

### …your views are dependent upon more than one instance of the same type, as long as that type does not need to be used as an observable object.

Since @EnvironmentObject only supports one instance per type, that idea is a non-starter. Instead if you need to register multiple instances of a given type using per-instance key paths, then you will need to use @Environment so that your views’ properties can specify their desired keypath.

```swift
struct MyView: View {
    @Environment(\.positiveTheme) var positiveTheme: Theme
    @Environment(\.negativeTheme) var negativeTheme: Theme

    var body: some View {
        VStack {
            Text("Positive")
                .foregroundColor(positiveTheme.foregroundColor)
                .background(positiveTheme.backgroundColor)
            Text("Negative")
                .foregroundColor(negativeTheme.foregroundColor)
                .background(negativeTheme.backgroundColor)
        }
    }
}

// MARK: - Dependencies

struct PositiveTheme: Theme {
    var foregroundColor: Color { .white }
    var backgroundColor: Color { .green }
}

struct NegativeTheme: Theme {
    var foregroundColor: Color { .white }
    var backgroundColor: Color { .red }
}

// MARK: - Environment Boilerplate

struct PositiveThemeKey: EnvironmentKey {
    static var defaultValue: Theme {
        return PositiveTheme()
    }
}

struct NegativeThemeKey: EnvironmentKey {
    static var defaultValue: Theme {
        return NegativeTheme()
    }
}

extension EnvironmentValues {
    var positiveTheme: Theme {
        get { return self[PositiveThemeKey.self]  }
        set { self[PositiveThemeKey.self] = newValue }
    }

    var negativeTheme: Theme {
        get { return self[NegativeThemeKey.self]  }
        set { self[NegativeThemeKey.self] = newValue }
    }
}
```

## 一个 EnvironmentObject 的多实例的解决方案

While it is **technically** possible to register an observable object using the `.environment()` modifier, changes to that object’s `@Published` properties will not trigger an invalidation or update of your view. Only `@EnvironmentObject` and `@ObservedObject` provide that. Unless something changes in the upcoming iOS 14 APIs, there is only one recourse I have found: a hacky but effective workaround using a custom property wrapper.

* You must register each instance using the `.environment()` modifier, **not** the `.environmentObject()` modifier.
* You need a custom property wrapper conforming to `DynamicProperty` that owns a private `@ObservedObject` property whose value is retrieved during initialization by pulling it from a single-shot instantiation of an `Environment<T>` struct (used as an instance, not as a property wrapper).
  

这样，视图就可以观察同一类的多个对象：

```swift
struct MyView: View {

    @DistinctEnvironmentObject(\.posts) var postsService: Microservice
    @DistinctEnvironmentObject(\.users) var usersService: Microservice
    @DistinctEnvironmentObject(\.channels) var channelsService: Microservice

    var body: some View {
        Form {
            Section(header: Text("Posts")) {
                List(postsService.content, id: \.self) {
                    Text($0)
                }
            }
            Section(header: Text("Users")) {
                List(usersService.content, id: \.self) {
                    Text($0)
                }
            }
            Section(header: Text("Channels")) {
                List(channelsService.content, id: \.self) {
                    Text($0)
                }
            }
        }.onAppear(perform: fetchContent)
    }
}

// MARK: - Property Wrapper To Make This All Work

@propertyWrapper
struct DistinctEnvironmentObject<Wrapped>: DynamicProperty where Wrapped : ObservableObject {
    var wrappedValue: Wrapped { _wrapped }
    @ObservedObject private var _wrapped: Wrapped

    init(_ keypath: KeyPath<EnvironmentValues, Wrapped>) {
        _wrapped = Environment<Wrapped>(keypath).wrappedValue
    }
}

// MARK: - Wherever You Create Your View Hierarchy

MyView()
    .environment(\.posts, Microservice.posts)
    .environment(\.users, Microservice.users)
    .environment(\.channels, Microservice.channels)
    // each of these has a dedicated EnvironmentKey
```

## 示例代码

上述所有示例均可从[这里](https://github.com/jaredsinclair/swiftui-property-wrappers)下载并执行。

#### 参考

[1] 每个 `@propertyWrapper` ——一致性类型都将提供 `projectedValue `属性的选项。由具体实现来决定值的类型。 此例中 `State<T>` 的预期值是 `Binding<T>`。每当使用一个新的属性包装器时，你都应该跳转到它生成的界面，更深入地发现它的预期值。 
    

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
