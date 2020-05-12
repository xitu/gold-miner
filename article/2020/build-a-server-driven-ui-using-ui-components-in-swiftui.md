> * 原文地址：[Build a Server-Driven UI Using UI Components in SwiftUI](https://medium.com/better-programming/build-a-server-driven-ui-using-ui-components-in-swiftui-466ecca97290)
> * 原文作者：[Anup Ammanavar](https://medium.com/@ammanavaranup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-server-driven-ui-using-ui-components-in-swiftui.md](https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-server-driven-ui-using-ui-components-in-swiftui.md)
> * 译者：
> * 校对者：

# Build a Server-Driven UI Using UI Components in SwiftUI

![Photo by [Charles Deluvio](https://unsplash.com/@charlesdeluvio?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8512/0*V5kRzEsP5a7zxJwY)

> Make changes to your app on the fly without submitting to Apple

This article will talk about server-driven UI, its implementation using re-usable components called **UIComponents**, and creating a generic vertical list view for rendering UI components. It will conclude with a brief discussion of how UI components can serve different purposes.

## What Is Server-Driven UI?

* It is an architecture where the server decides the UI views that need to be rendered on the application screen.
* There exists a contract between the application and the server. The basis of this contract gives the server control over the UI of the application.

What is that contract?- The server defines the list of components. For each of the components defined at the server, we have a corresponding UI implementation in the app (UIComponent). Consider an entertainment app like Hotstar, whose contract is defined as shown below. On the left are the components from the server, and on the right are the corresponding UI components.

![](https://cdn-images-1.medium.com/max/2796/1*e0caqOJanQdl7yvrU1Y0pg.png)

Working — The screen does not have a predefined layout like a storyboard. Rather, it consists of a generic list view rendering multiple different views vertically, as per the server response. To make it possible, we have to create views that are standalone and can be reused throughout the application. We call these re-usable views the **UIComponent**.

Contract — For every server component, we have a UIComponent.

## SwiftUI

Swift is a UI toolkit that lets you design application screens in a programmatic, declarative way.

```Swift
struct NotificationView: View {
    
    let notificationMessage: String
    
    var body: some View {
        Text(notificationMessage)
    }
}
```

## Server-Driven UI Implementation in SwiftUI

This is a three-step process.

1. Define the standalone UIComponents.
2. Construct the UIComponents based on the API response.
3. Render the UIComponents on the screen.

#### 1. Define the standalone UIComponents

![Pictorial representation of UI-component](https://cdn-images-1.medium.com/max/2872/1*vaTfkYDRJuPnUQm8nYskgQ.png)

Input: Firstly, for the UIComponent to render itself, it should be provided with data.

Output: ****UIComponent defines its UI. When used for rendering inside a screen, it renders itself based on the data (input) provided to it.

**UIComponent implementation**

```Swift
protocol UIComponent {
    var uniqueId: String  { get }
    func render() -> AnyView
}
```

* All the UI views have to conform to this UI-component protocol.
* As the components are rendered inside a generic vertical list, each UIComponent has to be independently identified. The`uniqueId` property is used to serve that purpose.
* The `render()` is where the UI of the component is defined. Calling this function on a screen will render the component. Let's look at `NotificationComponent`.

```Swift
struct NotificationComponent: UIComponent {
    var uniqueId: String
    
    // The data required for rendering is passed as a dependency
    let uiModel: NotificationUIModel
    
    // Defines the View for the Component
    func render() -> AnyView {
        NotificationView(uiModel: uiModel).toAny()
    }
}

// Contains the properties required for rendering the Notification View
struct NotificationUIModel {
    let header: String
    let message: String
    let actionText: String
}

// Notification view takes the NotificationUIModel as a dependency
struct NotificationView: View {
    let uiModel: NotificationUIModel
    var body: some View {
        VStack {
            Text(uiModel.header)
            Text(uiModel.message)
            Button(action: {}) {
                Text(uiModel.actionText)
            }
        }
    }
}
```

* `NotificationUIModel` is the data required by the component to render. This is the input to the UIComponent.
* `NotificationView` is a SwiftUI view that defines the UI of the component. It takes in `NotificationUIModel` as a dependency. This view is the output of the UIComponent when used for rendering on the screen.

#### 2. Construct the UIComponents based on the API response

```Swift
 class HomePageController: ObservableObject {
 
    let repository: Repository
    @Published var uiComponents: [UIComponent] = []
  
    ..
    .. 
    
    func loadPage() {
        val response = repository.getHomePageResult()
        response.forEach { serverComponent in
          let uiComponent = parseToUIComponent(serverComponent)
          uiComponents.append(uiComponent)
        }
    }
}

func parseToUIComponent(serverComponent: ServerComponent) -> UIComponent {
  var uiComponent: UIComponent
  
  if serverComponent.type == "NotificationComponent" {
    uiComponent = NotificationComponent(serverComponent.data, serverComponent.id)
  }
  else if serverComponent.type == "GenreListComponent" {
    uiComponent = GenreListComponent(serverComponent.data, serverComponent.id)
  }
  ...
  ...
  return uiComponent
}
```

* `HomePageController` loads the server components from the repository and converts them into the UIComponents.
* The `uiComponent`'s property is responsible for holding the list of UIComponents. Wrapping it with the `@Published` property makes it an observable. Any change in its value will be published to the `Observer(View)`. This makes it possible to keep the `View` in sync with the state of the application.

#### 3. Render UIComponents on the screen

This the last part. The screen’s only responsibility is to render the `UIComponents`. It subscribes to the `uiComponents` observable. Whenever the value of the `uiComponents` changes, the `HomePage` is notified, which then updates its UI. A generic `ListView` is used for rendering the UIComponents.

```Swift
struct HomePageView: View {
    
    @ObservedObject var controller: HomePageViewModel
    
    var body: some View {
    
        ScrollView(.vertical) {
            VStack {
                ForEach(controller.uiComponents, id: \.uniqueId) { uiComponent in
                    uiComponent.render()
                }
            }
        }
        .onAppear(perform: {
            self.controller.loadPage()
        })
        
    }
}
```

Generic `Vstack:` All the UIComponents are rendered vertically using a `VStack` inside. As the UIComponents are uniquely identifiable, we can use the `ForEach` construct for rendering.

Since all the components conforming to UIComponent protocol must return a common type, the `render()` function returns `AnyView` . Below is an extension on the `View` for converting it to`AnyView`.

```Swift
extension View {
    func toAny() -> AnyView {
        return AnyView(self)
    }
}

```

## Conclusion

We saw how `UIComponent` can be used to give the server control over the UI of the application. But with `UIComponents` you can achieve something more.

Let’s consider a case without server-driven UI. It's often the case that the pieces of UI are used many times across the application. This leads to duplication of the view and view logic. So, it’s better to divide the UI into meaningful, reusable UI-components.

Having them this way will let the domain-layer/business layer define and construct the UI components. Additionally, the business-layer can take the responsibility of controlling the UI.

You can find [the project](https://github.com/AnupAmmanavar/SwiftUI-Server-Driver-UI) on GitHub.

Have a look at the article “[Android Jetpack Compose — Create a Component-Based Architecture](https://medium.com/better-programming/create-a-component-based-architecture-in-android-jetpack-compose-96980c191351),” which explains UI-Components in detail. As it uses Jetpack compose-Android’s declarative UI kit, it wouldn’t be hard to understand.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
