> * 原文地址：[When Should I Use @State, @Binding, @ObservedObject, @EnvironmentObject, or @Environment?](https://jaredsinclair.com/2020/05/07/swiftui-cheat-sheet.html)
> * 原文作者：[Jared Sinclair](https://jaredsinclair.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-cheat-sheet.md](https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-cheat-sheet.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[Zilin Zhu](https://github.com/zhuzilin),[PassionPenguin](https://github.com/PassionPenguin)

# 我们应该在什么时候使用 \@State、\@Binding、\@ObservedObject、\@EnvironmentObject 和 \@Environment？

SwiftUI 引入了一系列新的属性包装器让你的代码可以通过它们架起程序状态和视图之间的桥梁：

```swift
 @State
 @Binding
 @ObservedObject
 @EnvironmentObject
 @Environment
```

这只是其中一部分。还有其他用于 Core Data 获取请求和用于识别手势的属性包装器。但这些包装器与本文无关。与列举的包装器不同是，`@FetchRequest` 和`@GestureState` 的使用场景是明确的，然而，何时应该使用 `@State` 还是 `@Binding`，或 `@ObservedObject` 还是 `@EnvironmentObject` ，这些通常会令人感到困惑。

本文试图通过简单、重复性的术语来定义每个包装器合适的使用时机。在这里我可能有点过于规定性，但我从这些规则中已经有了不错的收获。此外，过度规范是一个由来已久的程序员编写博客的传统，因此尽管偶尔会令人讨厌，但我想遵循规范应该会对你有所帮助。

下面的所有代码示例代码都可以在 [GitHub 仓库](https://github.com/jaredsinclair/swiftui-property-wrappers) 中找到。

> **注意：本文是基于 iOS 13 并使用 Swift 5 编写的。**

## 速查表

1. 当你的视图需要改变它自己的属性时，请使用 `@State`。
2. 当你的视图需要更改祖先视图所拥有的属性或祖先视图所引用的可观察对象所拥有的属性时，请使用 `@Binding` 。
3. 当你的视图依赖于可观察对象时，请使用 `@ObservedObject`，该对象可以自我创建，也可以当做参数传递给该视图的构造方法。
4. 当通过视图所有祖先视图的构造方法传递一个可观察对象太麻烦时，请使用 `@EnvironmentObject`。
5. 当视图所依赖的类型不符合 ObserveObject 时，请使用 `@Environment`。
6. 当视图依赖于多个相同类型的实例时，只要该类型不需要被用作可观察对象，也可以使用 `@Environment`。
7. 如果你的视图需要同一个可观察对象类的多个实例，那么不走运了。您不能使用 `@EnvironmentObject` 或 `@Environment` 来解决问题。(不过，在这篇文章的底部有一个简单的变通方法)。

## 你的视图需要一个 `@State` 属性，如果…

### …它需要对自己的某个属性进行读/写访问以供私有使用时。

就像是 UIButton 上的 `isHighlighted` 属性。其他对象不需要知道按钮什么时候高亮显示，也不需要对该属性进行赋值操作。如果你要在 SwiftUI 中从头开始实现一个按钮，那么使用  @State 包装器修饰你的 `isHighlighted` 属性将是一个很好的选择。

```swift
struct CustomButton<Label>: View where Label : View {
    let action: () -> Void
    let label: () -> Label

    /// it needs read/write access to one of 
    /// its own properties for private use
    @State private var isHighlighted = false
}
```

### …它需要让子视图可以对其某个属性进行读/写访问时。

视图通过传递 @State-wrapped 属性的 `projectedValue` 来实现这一点，该属性是该值的绑定 <sup><a href="#note1">[1]</a></sup>。一个很好的例子是 SwiftUI.Alert。视图通过改变某个使用 @State 修饰的属性的值来负责控制 Alert 弹框的显示与否，比如一个 `isPresentingAlert` 的布尔属性。但是视图不能隐藏 Alert 弹框本身，因为 Alert 弹框并不知道它在具体哪个视图弹出。可以通过使用 `@State` 属性解决这个难题。通过使用编译器生成的 `self.$isPresentingAlert` 属性，视图与 Alert 弹框的 `isPresentingAlert` 属性做了一个绑定，这是 @State 包装器的预测值的语法糖。`.alert(isPresented:content:)` 修饰符接受了这个绑定，随后，Alert 弹框将它的 `isPresentingAlert` 属性设为 false，从而实现了弹框的自动消失。

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

### …它需要对祖先视图的 `State` 包装属性进行读/写访问

与上述 Alert 弹框的场景相反。如果你的视图类似于 Alert 弹框，它依赖于祖先所拥有的值，并且关键的是，需要对该值的可变访问，那么该视图需要一个 @Binding 到该值。

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

天啊，这可真拗口。在这种情况下，有三件事：

1. 一个可观察的物体
2. 具有引用该对象的 @-Something 包装器的祖先视图
3. **你的**视图是 #2 的后代。（视图是其所继承的某个祖先视图的后代视图）

你的视图需要具有对该可观察对象的某些成员的读/写访问权限，但是它没（也不应）具有对该可观察对象的访问权限。然后，视图将为该值定义一个 @Binding 属性，该属性将在视图初始化时由其祖先视图提供。这方面的一个很好的例子是任何可复用的输入视图们，如选择器或文本框。 一个文本框需要能够对另一个对象上的一些字符串属性有读/写访问权，但是文本框不应该与那个特定的对象紧密耦合。相反，文本框的 @Binding 属性将提供对字符串属性的读/写访问权限，而无需将该属性直接暴露给文本框。

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

假设你有一个视图，用来展示从网络服务获取的项目列表。SwiftUI 的视图是临时的、可丢弃的值类型。它们很适合展示内容，但不适合进行网络服务请求。此外，你不应该将用户界面代码与其他任务混在一起，因为那样会违反[单一职责原则](https://en.wikipedia.org/wiki/Single-responsibility_principle)。取而代之的是，你可能会将这些责任转移给另一个对象，该对象可以协调发出请求，解析响应并将响应映射到用户界面模型值所需的值。视图将通过 @ObservedObject 包装器拥有对该对象的引用。

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

让我们回到上面 @ObservedObject 部分的第二个示例，其中需要一个可观察对象来代表你的视图执行某些任务，但是视图无法自己初始化该对象。但是现在让我们假设你的视图不是根视图，而是深深地嵌套在许多祖先视图中的后代视图。如果所有祖先视图都不需要该被观察对象，那么要求视图链中的每个视图都将被观察对象包含在它们的构造器参数中，只为了让某一个后代视图能够访问它，这将非常尴尬。相反，你可以通过将其放入视图周围的 SwiftUI 环境来间接提供该值。视图可以通过 @EnvironmentObject 包装器访问当前环境实例。注意，一旦 @EnvironmentObject 的值被解析，这个用例在功能上与使用包装在 @ObservedObject 中的对象是相同的。

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

有时候你的视图会依赖一些不符合 ObservableObject 的东西，但你希望它能够符合，因为把它作为构造器参数传递太麻烦了。一个依赖可能不能符合 ObservableObject 的原因有很多，比如：

* 依赖项是一个值类型（类似结构，枚举等）
* 依赖项仅作为协议而不是具体类型向视图公开
* 依赖关系是一个闭包

在这种情况下，视图将使用 @Environment 包装器来获得所需的依赖项。这需要一些样板才能正确完成。

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

### …你的视图依赖于同一个类型的多个实例，只要该类型不需要被用作可观察对象。

由于 @EnvironmentObject 每种类型仅支持一个实例，所以这种想法是行不通的。相反，如果您需要使用每个实例的键路径注册给定类型的多个实例，则需要使用 @Environment，以便视图的属性可以指定其所需的键路径。

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

虽然在**技术**上可以使用 `.environment()` 修饰符注册一个可观察对象，但对该对象的 `@Published` 属性的更改不会触发视图的失效或更新。只有使用 `@EnvironmentObject` 和 `@ObservedObject` 才能做到这一点。除非即将发布的 iOS 14 API 有所变化，否则我只能找到一种方法：使用自定义属性包装器来解决这个问题。

* 你应该使用修饰符 `.environment()`  注册每个实例，而**不是**使用修饰符 `.environmentObject()`  注册。
* 您需要一个符合 `DynamicProperty` 的自定义属性包装器，它拥有一个私有的 `@ObservedObject` 属性，该属性的值在初始化过程中通过从一个`Environment<T>` 结构的单次实例（用作实例，而不是属性包装器）中提取出来。
  

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

[1] <a name="note1"></a> 每个 `@propertyWrapper` ——一致性类型都将提供 `projectedValue `属性的选项。由具体实现来决定值的类型。 此例中 `State<T>` 的预期值是 `Binding<T>`。每当使用一个新的属性包装器时，你都应该跳转到它生成的界面，更深入地发现它的预期值。 
    

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
