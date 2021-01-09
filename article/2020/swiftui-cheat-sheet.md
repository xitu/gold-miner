> * 原文地址：[When Should I Use @State, @Binding, @ObservedObject, @EnvironmentObject, or @Environment?](https://jaredsinclair.com/2020/05/07/swiftui-cheat-sheet.html)
> * 原文作者：[Jared Sinclair](https://jaredsinclair.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-cheat-sheet.md](https://github.com/xitu/gold-miner/blob/master/article/2020/swiftui-cheat-sheet.md)
> * 译者：
> * 校对者：

# When Should I Use \@State, \@Binding, \@ObservedObject, \@EnvironmentObject, or \@Environment?

SwiftUI introduced a laundry list of new property wrappers that your code can use to bridge the gap between program state and your views:

```swift
 @State
 @Binding
 @ObservedObject
 @EnvironmentObject
 @Environment
```

That’s only a partial list. There are other property wrappers for Core Data fetch requests and gesture recognizers. But this post isn’t about these other wrappers. Unlike the wrappers above, the use cases for `@FetchRequest` and `@GestureState` are unambiguous, whereas it can be very confusing how to decide when to use a `@State` versus `@Binding`, or `@ObservedObject` versus `@EnvironmentObject`, etc.

This post is an attempt to define in simple, repeatable terms when each wrapper is an appropriate choice. There’s a risk I’m being overly prescriptive here, but I’ve gotten some decent mileage from these rules already. Besides, being overly prescriptive is a time-honored programmer blog tradition, so I’m in good albeit occasionally obnoxious company.

All of the code samples that follow are available [in this GitHub repo](https://github.com/jaredsinclair/swiftui-property-wrappers).

> **Note for posterity: this post was written using Swift 5 and iOS 13.**

## Cheat Sheet

1. Use `@State` when your view needs to mutate one of its own properties.
2. Use `@Binding` when your view needs to mutate a property owned by an ancestor view, or owned by an observable object that an ancestor has a reference to.
3. Use `@ObservedObject` when your view is dependent on an observable object that it can create itself, or that can be passed into that view’s initializer.
4. Use `@EnvironmentObject` when it would be too cumbersome to pass an observable object through all the initializers of all your view’s ancestors.
5. Use `@Environment` when your view is dependent on a type that cannot conform to ObservableObject.
6. Also use `@Environment` when your views are dependent upon more than one instance of the same type, as long as that type does not need to be used as an observable object.
7. If your view needs more than one instance of the same observable object class, you are out of luck. You cannot use `@EnvironmentObject` nor `@Environment` to resolve this issue. (There is a hacky workaround, though, at the bottom of this post). 

## Your view needs a `@State` property if…

### …it needs read/write access to one of its own properties for private use.

A helpful metaphor is the `isHighlighted` property on UIButton. Other objects don’t need to know when a button is highlighted, nor do they need write access to that property. If you were implementing a from-scratch button in SwiftUI, your `isHighlighted` property would be a good candidate for an @State wrapper.

```swift
struct CustomButton<Label>: View where Label : View {
    let action: () -> Void
    let label: () -> Label

    /// it needs read/write access to one of 
    /// its own properties for private use
    @State private var isHighlighted = false
}
``` 

### …it needs to provide read/write access of one of its properties to a descendant view.

Your view does this by passing the `projectedValue` of the @State-wrapped property, which is a Binding to that value [1]. A good example of this is SwiftUI.Alert. Your view is responsible for showing the alert by changing the value of some @State, like an `isPresentingAlert` boolean property. But your view can’t dismiss that alert itself, nor does the alert have any knowledge of the view that presented it. This dilemma is resolved by a Binding. Your view passes the Alert a Binding to its `isPresentingAlert` property by using the compiler-generated property `self.$isPresentingAlert`, which is syntax sugar for the @State wrapper’s projected value. The `.alert(isPresented:content:)` modifier takes in that binding, which is later used by the alert to set `isPresentingAlert` back to false, in effect allowing the alert to dismiss itself.

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

## Your view needs a `@Binding` property if…

### …it needs read/write access to a `State`-wrapped property of an ancestor view

This is the reverse perspective of the alert problem described above. If your view is like an Alert, where it’s dependent upon a value owned by an ancestor and, crucially, needs mutable access to that value, then your view needs a @Binding to that value.

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

### …it needs read/write access to a property of an object conforming to `ObservableObject` but the reference to that object is owned by an ancestor.

Boy that’s a mouthful. In this situation, there are three things:

1. an observable object
2. some ancestor view that has an @-Something wrapper referencing that object
3. **your** view, which is a descendant of #2.

Your view needs to have read/write access to some member of that observable object, but your view does not (and should not) have access to that observable object. Your view will then define a @Binding property for that value, which the ancestor view will provide when your view is initialized. A good example of this is any reusable input view, like a picker or a text field. A text field needs to be able to have read/write access to some String property on another object, but the text field should not have a tight coupling to that particular object. Instead, the text field’s @Binding property will provide read/write access to the String property without exposing that property directly to the text field.

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

## Your view needs an `@ObservedObject` property if…

### …it is dependent on an observable object that it can instantiate itself.

Imagine you have a view that displays a list of items pulled down from a web service. SwiftUI views are transient, discardable value types. They’re good for displaying content, but not appropriate for doing the work of making web service requests. Besides, you shouldn’t be mixing user interface code with other tasks as that would violate the [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single-responsibility_principle). Instead your view might offload those responsibilities to an object that can coordinate the tasks needed to make a request, parse the response, and map the response to user interface model values. Your view would own a reference to that object by way of an @ObservedObject wrapper.

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

### …it is dependent on a reference type object that can easily be passed to that view’s initializer.

This scenario is nearly identical to the previous scenario, except that some other object besides your view is responsible for initializing and configuring the observable object. This might be the case if some UIKit code is responsible for presenting your SwiftUI view, especially if the observable object can’t be constructed without references to other dependencies that your SwiftUI view cannot (or should not) have access to.

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

## Your view needs an `@EnvironmentObject` property if…

### …it would be too cumbersome to pass that observed object through all the initializers of all your view’s ancestors.

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

## Your view needs an `@Environment` property if…

### …it is dependent on a type that cannot conform to ObservableObject.

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

## Workaround for Multiple Instances of an EnvironmentObject

While it is **technically** possible to register an observable object using the `.environment()` modifier, changes to that object’s `@Published` properties will not trigger an invalidation or update of your view. Only `@EnvironmentObject` and `@ObservedObject` provide that. Unless something changes in the upcoming iOS 14 APIs, there is only one recourse I have found: a hacky but effective workaround using a custom property wrapper.

* You must register each instance using the `.environment()` modifier, **not** the `.environmentObject()` modifier.
* You need a custom property wrapper conforming to `DynamicProperty` that owns a private `@ObservedObject` property whose value is retrieved during initialization by pulling it from a single-shot instantiation of an `Environment<T>` struct (used as an instance, not as a property wrapper).
    

With this set up in place, your view can observe multiple objects of the same class:

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

## Sample Code

All of the code above is available [in an executable form here](https://github.com/jaredsinclair/swiftui-property-wrappers).

#### Reference

[1] Every `@propertyWrapper`-conforming type has the option of providing a `projectedValue` property. It is up to each implementation to decide the type of the value. In the case of the `State<T>` struct, the projected value is a `Binding<T>`. It behoves you, any time you’re using a new property wrapper, to jump to its generated interface to discover in detail what it’s projected value is.
    

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
