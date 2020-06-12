> * 原文地址：[Build a Server-Driven UI Using UI Components in SwiftUI](https://medium.com/better-programming/build-a-server-driven-ui-using-ui-components-in-swiftui-466ecca97290)
> * 原文作者：[Anup Ammanavar](https://medium.com/@ammanavaranup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-server-driven-ui-using-ui-components-in-swiftui.md](https://github.com/xitu/gold-miner/blob/master/article/2020/build-a-server-driven-ui-using-ui-components-in-swiftui.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[lhd951220](https://github.com/lhd951220)

# 在 SwiftUI 中构建服务端驱动的 UI 组件

![Photo by [Charles Deluvio](https://unsplash.com/@charlesdeluvio?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8512/0*V5kRzEsP5a7zxJwY)

> 在不提交给 Apple 审核的情况下即时修改应用

本文将讨论使用可重用 **UIComponents** 组件来实现服务端驱动的 UI，以及如何创建通用垂直列表视图。最后将简要讨论如何使用 UI 组件实现不同的需求。

## 什么是服务端驱动的 UI ?

* 它是一种架构，其中约定应用程序中 UI 视图在屏幕上的渲染是由服务器决定的。
* 应用程序和服务器之间存在协议。该协议的基础是让服务器可以控制应用程序的 UI。

协议是什么？—— 服务器定义的组件列表。对于服务器上定义的每个组件，我们在应用程序（UIComponent）中都有一个相应的 UI 实现。比如像 Hotstar 这样的娱乐应用，其协议定义如下。左边是服务器中的组件，右边是相应的 UI 组件。

![](https://cdn-images-1.medium.com/max/2796/1*e0caqOJanQdl7yvrU1Y0pg.png)

运行 —— 屏幕上没有像 storyboard 一样预定义的布局。取而代之的是一个普通的列表视图，它会根据服务器的响应，在垂直方向上渲染多个不同的视图。为了实现这一点，我们必须创建独立并且在整个应用中可重用的视图。我们将这些可重用的视图称为 **UIComponent**。

协议 —— 对于每个服务端的组件，我们有与之对应的 UIComponent。

## SwiftUI

SwiftUI 是一个用声明式编程来设计屏幕布局的 UI 框架。

```Swift
struct NotificationView: View {
    
    let notificationMessage: String
    
    var body: some View {
        Text(notificationMessage)
    }
}
```

## 在 SwiftUI 中实现服务端驱动的 UI 

它分为三个步骤。

1. 定义独立的 UIComponents。
2. 根据 API 响应结果构建 UIComponents。
3. 在屏幕上渲染 UIComponents。

#### 1. 定义独立的 UIComponents

![Pictorial representation of UI-component](https://cdn-images-1.medium.com/max/2872/1*vaTfkYDRJuPnUQm8nYskgQ.png)

输入：首先，要使 UIComponent 能够渲染，应为其提供数据。

输出：**UIComponent** 中定义的 UI。当屏幕渲染时，它根据提供的数据（输入）进行渲染。

**UIComponent 实现**

```Swift
protocol UIComponent {
    var uniqueId: String  { get }
    func render() -> AnyView
}
```

* 所有 UI 视图都必须遵守 UIComponent 协议。
* 由于组件是在通用垂直列表中渲染的，所以每个 UIComponent 必须有一个独立的标识。`uniqueId` 属性用于实现标识的功能。
* 我们在 `render()` 方法中定义组件的 UI。调用这个方法时会在屏幕上渲染组件。现在我们来看一下 `NotificationComponent` 的实现。

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

* `NotificationUIModel` 是组件渲染所需的数据。这是 UIComponent 的输入。
* `NotificationView` 是一个 SwiftUI 视图，用于定义组件的 UI。它以 `NotificationUIModel` 作为依赖。当屏幕渲染时，此视图是 UIComponent 的输出。

#### 2. 根据 API 响应结果构建 UIComponents

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

* `HomePageController` 从存储库加载服务器组件并将其转换为 UIComponents。
* `uiComponent` 属性负责保存 UIComponents 的列表。我们用 `@Published` 属性包装使其转化为可观察的对象。其值的任何更改都将发布到 `Observer(View)`。这样可以使 `视图` 与应用程序状态保持同步。

#### 3. 在屏幕上渲染 UIComponents

这是最后一部分。屏幕的唯一职责是渲染 `UIComponents`。它订阅了可观察的 `uiComponents`。每当 `uiComponents` 的值更改时，就会通知 `HomePage`，然后更新其 UI。通用的 `ListView` 用于展示 UIComponent。

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

通用的 `VStack`：`VStack` 内部所有的 UIComponent 都在垂直方向上展示。因为 UIComponent 是唯一可识别的，所以我们可以使用 `ForEach` 进行渲染。

所有遵守 UIComponent 协议的组件都必须返回通用类型，因此 `render()` 方法返回的类型是 `AnyView`。以下是 `View` 的扩展，用于将其转换为 `AnyView`。

```Swift
extension View {
    func toAny() -> AnyView {
        return AnyView(self)
    }
}

```

## 结论

我们学习了如何使用 `UIComponent` 来使服务器控制应用程序的 UI。其实 `UIComponents` 还可以实现更多功能。

现在我们考虑没有服务器端驱动时界面的情况。这种情况下，UI 片段在整个应用程序中使用很多次。这会导致视图和视图逻辑的重复。因此，最好将界面定义为有意义的，可重用的组件。

这种方式可以让控制层/业务层定义和构造 UI 组件。另外，业务层也可以承担控制 UI 的责任。

你可以在 GitHub 上找到[这个项目](https://github.com/AnupAmmanavar/SwiftUI-Server-Driver-UI)。

您还可以阅读[在 Android 中使用 Jetpack Compose 创建基于组件的架构](https://medium.com/better-programming/create-a-component-based-architecture-in-android-jetpack-compose-96980c191351)这篇文章，它详细解释了 UI 组件原理。文中使用的是 Jetpack compose —— Android 中声明式的 UI 框架，因此这篇文章的内容也不难理解。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
