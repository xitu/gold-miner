> * 原文地址：[Design Patterns on iOS using Swift – Part 1/2](https://www.raywenderlich.com/477-design-patterns-on-ios-using-swift-part-1-2)
> * 原文作者：[Lorenzo Boaro](https://www.raywenderlich.com/u/lorenzoboaro)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-1-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-1-2.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[swants](https://github.com/swants), [Chunk49](https://github.com/Chunk49)

# 使用 Swift 的 iOS 设计模式（第一部分）

## 在这个由两部分组成的教程中，你将了解构建 iOS 应用程序的常见设计模式，以及如何在自己的应用程序中应用这些模式。

> **更新说明**：本教程已由译者针对 iOS 12，Xcode 10 和 Swift 4.2 进行了更新。原帖由教程团队成员 Eli Ganem发布。

**iOS设计模式** — 你可能已经听过这个术语，但是你知道这意味着什么吗？尽管大多数开发人员可能都认为设计模式非常重要，关于这个主题的文章并不多，我们开发人员在编写代码时有时不会过多地关注设计模式。

设计模式是软件设计中常见问题的可重用解决方案。它们的模板旨在帮助你编写易于理解和重用的代码。它们还可以帮助你创建低耦合度的代码，以便你能更改或替换代码中的组件而避免很多麻烦。

如果你对设计模式不熟悉，那么我有个好消息要告诉你！首先，由于 Cocoa 的架构方式以及它鼓励你使用的最佳实践，你已经使用过了大量的 iOS 设计模式。其次，本教程将快速帮助你理解 Cocoa 中常用的所有重要（还有不那么重要）的 iOS 设计模式。

在这个由两部分组成的教程中，你将创建一个音乐应用程序，用于显示你的专辑及其相关信息。

在开发此应用程序的过程中，你将熟悉最常见的 Cocoa 设计模式：

*   **创建型**：单例。
*   **结构型**：MVC、装饰、适配器和外观。
*   **行为型**：观察者和备忘录。

不要误以为这是一篇关于理论的文章，你将在音乐应用中使用大多数这些设计模式。在本教程结束时，你的应用将如下所示：

![How the album app will look when the design patterns tutorial is complete](https://koenig-media.raywenderlich.com/uploads/2017/07/FinalApp-180x320.png)

让我们开始吧！

## 入门

下载 [入门项目](https://koenig-media.raywenderlich.com/uploads/2017/07/RWBlueLibrary-Part1-Starter.zip)，解压缩 ZIP 文件的内容，并在 Xcode 中打开 *RWBlueLibrary.xcodeproj*。

请注意项目中的以下内容：

1.  在 storyboard 里，`ViewController` 有三个 `IBOutlet` 连接了 TableView，还有撤消和删除按钮按钮。
2.  Storyboard 有 3 个组件，为方便起见我们设置了约束。顶部组件是用来显示专辑封面的。专辑封面下方是一个 TableView，其中列出了与专辑封面相关的信息。 最后，工具栏有两个按钮，一个用于撤消操作，另一个用于删除你选择的专辑。Storyboard 如下所示：

[![swiftDesignPatternStoryboard](https://koenig-media.raywenderlich.com/uploads/2017/05/design-patterns-part1-storyboard-1-411x320.png)](https://koenig-media.raywenderlich.com/uploads/2017/05/design-patterns-part1-storyboard-1-411x320.png)

3. 有一个没有实现的初始 HTTP 客户端类（`HTTPClient`），供你稍后填写。

> **注意**：你知道吗，只要你创建新的 Xcode 项目，就已经充满了设计模式了嘛？模型-视图-控制器，代理，协议，单例 — 这些设计模式都是现成的！

## MVC – 设计模式之王

[![mvcking](https://koenig-media.raywenderlich.com/uploads/2013/07/mvcking.png)](https://koenig-media.raywenderlich.com/uploads/2013/07/mvcking.png)

模型 - 视图 - 控制器（MVC）是 Cocoa 的构建模块之一，它无疑是所有设计模式中最常用的。它将应用内对象按照各自常用角色进行分类，并提倡将代码基于角色进行解耦。

这三个角色是：

*   **模型（Model）**：Model 是你的应用中持有并定义如何操作数据的对象。例如，在你的应用程序中，模型是 `Album` 结构体，你可以在 **Album.swift** 中找到它。大多数应用程序将具有多个类型作为其模型的一部分。
*   **视图（View）**：View 是用来展示 model 的数据并管理可与用户交互的控件的对象，基本上可以说是所有 `UIView` 派生的对象。 在你的应用程序中，视图是 `AlbumView`，你可以在 *AlbumView.swift* 中找到它。
*   **控制器（Controller）**：控制器是协调所有工作的中介。它访问模型中的数据并将其与视图一起显示，监听事件并根据需要操作数据。你能猜出哪个类是你的控制器吗？没错，就是 `ViewController`。

你的 App 要想规范地使用 MVC 设计模式，就意味着你 App 中每个对象都可以划分为这三个角色其中的某一个。

通过控制器（Controller）可以最好地描述视图（View）到模型（Model）之间的通信，如下图所示：

[![mvc0](https://koenig-media.raywenderlich.com/uploads/2013/07/mvc0.png)](https://koenig-media.raywenderlich.com/uploads/2013/07/mvc0.png)

模型通知控制器任何数据更改，反过来，控制器更新视图中的数据。然后，视图可以向控制器通知用户执行的操作，控制器将在必要时更新模型或检索任何请求的数据。

你可能想知道为什么你不能抛弃控制器，并在同一个类中实现视图和模型，因为这看起来会容易得多。

这一切都将归结为代码分离和可重用性。理想情况下，视图应与模型完全分离。如果视图不依赖于模型的特定实现，那么可以使用不同的模型重用它来呈现其他一些数据。

例如，如果将来你还想将电影或书籍添加到库中，你仍然可以使用相同的 `AlbumView` 来显示电影和书籍对象。此外，如果你想创建一个与专辑有关的新项目，你可以简单地重用你的 `Album` 结构体，因为它不依赖于任何视图。这就是MVC的力量！

## 如何使用 MVC 设计模式

首先，你需要确保项目中的每个类都是Controller、Model 或 View，不要在一个类中组合两个角色的功能。

其次，为了确保你符合这种工作方法，你应该创建三个文件夹来保存你的代码，每个角色一个。

点击 **File\New\Group（或者按 Command + Option + N）**并把改组名为 Model。重复相同的过程以创建 View 和 Controller 组。

现在将 *Album.swift* 拖拽到 Model 组。将 *AlbumView.swift* 拖拽到 View 组，最后将 *ViewController.swift* 拖拽到 Controller 组。

此时项目结构应如下所示：

[![](https://koenig-media.raywenderlich.com/uploads/2017/05/design-patterns-part1-mvc-1-230x320.png)](https://koenig-media.raywenderlich.com/uploads/2017/05/design-patterns-part1-mvc-1.png)

如果没有所有这些文件夹，你的项目看起来会好很多。显然，你可以拥有其他组和类，但应用程序的核心将包含在这三个类别中。

现在你的组件已组织完毕，你需要从某个位置获取相册数据。你将创建一个 API 类，在整个代码中使用它来管理数据，这提供了讨论下一个设计模式的机会 — 单例（Singleton）。

## 单例模式

单例设计模式确保给定类只会存在一个实例，并且该实例有一个全局的访问点。它通常使用延迟加载来在第一次需要时创建单个实例。

> **注意**：Apple 使用了很多这个方法。例如：`UserDefaults.standard`、`UIApplication.shared`、`UIScreen.main` 和 `FileManager.default` 都返回一个单例对象。

你可能想知道为什么你关心的是一个类有不只一个实例。代码和内存不是都很廉价吗？

在某些情况下，只有一个实例的类才有意义。例如，你的应用程序只有一个实例，设备也只有一个主屏幕，因此你只需要一个实例。再者，采用全局配置处理程序类，他更容易实现对单个共享资源（例如配置文件）的线程安全访问，而不是让许多类可能同时修改配置文件。

## 你应该注意什么？

> **注意事项**：这种模式有被初学者和有经验的开发着滥用（或误用）的历史，因此我们将 Joshua Greene 的 [Design Patterns by Tutorials](https://store.raywenderlich.com/products/design-patterns-by-tutorials) 一书中的一段简述摘录至此，其中解释了使用这种模式的一些需要注意的事项。

单例模式很容易被滥用。

如果你遇到一种想要使用单例的情况，请首先考虑是否还有其他的方法来完成你的任务。

例如，如果你只是尝试将信息从一个视图控制器传递到另一个视图控制器，则不适合使用单例。但是你可以考虑通过初始化程序或属性传递该模型。

如果你确定你确实需要一个单例，那么考虑拓展单例是否会更有意义。

有多个实例会导致问题吗？自定义实例会有用吗？你的答案将决定你是否更好地使用真正的单例或其拓展。

用单例时遇到问题的最常见的原因是测试。如果你将状态存储在像单例这样的全局对象中，则测试顺序可能很重要，并且模拟它们会很烦人。这两个原因都会使测试成为一种痛苦。

最后，要注意“代码异味”，它表明你的用例根本不适合使用单例。例如，如果你经常需要许多自定义实例，那么你的用例可能会更好地作为常规对象。

[![](https://koenig-media.raywenderlich.com/uploads/2017/08/Screen-Shot-2018-05-05-at-1.33.43-PM-650x429.png)](https://koenig-media.raywenderlich.com/uploads/2017/08/Screen-Shot-2018-05-05-at-1.33.43-PM.png)

## 如何使用单例模式

为了确保你的单例只有一个实例，你必须让其他任何人都无法创建实例。Swift 允许你通过将初始化方法标记为私有来完成此操作，然后你可以为共享实例添加静态属性，该属性在类中初始化。

你将通过创建一个单例来管理所有专辑数据从而实现此模式。

你会注意到项目中有一个名为 *API* 的组，这是你将所有将为你的应用程序提供服务的类的地方。右键单击该组并选择 *New File*，在该组中创建一个新文件，选择 *iOS > Swift File*。将文件名设置为 *LibraryAPI.swift*，然后单击 *Create*。

现在打开 *LibraryAPI.swift* 并插入代码：

```swift
final class LibraryAPI {
  // 1
  static let shared = LibraryAPI()
  // 2
  private init() {

  }
}
```

以下是详细分析：

1.  其中 `shared` 声明的常量使得其他对象可以访问到单例对象 `LibraryAPI`。
2.  私有的初始化方法防止从外部创建 `LibraryAPI` 的新实例。

你现在有一个单例对象作为管理专辑的入口。接下来创建一个类来持久化库里的数据。

现在在 *API* 组里创建一个新文件。 选择 *iOS > Swift File*。将类名设置为 *PersistencyManager.swift*，然后单击 *Create*。

打开 *PersistencyManager.swift* 并添加以下代码：

```swift
final class PersistencyManager {

}
```

在括号里面添加以下代码：

```swift
private var albums = [Album]()
```

在这里，你声明一个私有属性来保存专辑数据。该数组将是可变的，因此你可以轻松添加和删除专辑。

现在将以下初始化方法添加到类中：

```swift
init() {
  //Dummy list of albums
  let album1 = Album(title: "Best of Bowie",
                     artist: "David Bowie",
                     genre: "Pop",
                     coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_david_bowie_best_of_bowie.png",
                     year: "1992")
    
  let album2 = Album(title: "It's My Life",
                     artist: "No Doubt",
                     genre: "Pop",
                     coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_no_doubt_its_my_life_bathwater.png",
                     year: "2003")
    
  let album3 = Album(title: "Nothing Like The Sun",
                     artist: "Sting",
                     genre: "Pop",
                     coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_sting_nothing_like_the_sun.png",
                     year: "1999")
    
  let album4 = Album(title: "Staring at the Sun",
                     artist: "U2",
                     genre: "Pop",
                     coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_u2_staring_at_the_sun.png",
                     year: "2000")
    
  let album5 = Album(title: "American Pie",
                     artist: "Madonna",
                     genre: "Pop",
                     coverUrl: "https://s3.amazonaws.com/CoverProject/album/album_madonna_american_pie.png",
                     year: "2000")
    
  albums = [album1, album2, album3, album4, album5]
}
```

在初始化程序中，你将使用五个示例专辑填充数组。如果上述专辑不符合你的喜好，可以随便使用你喜欢的音乐替换它们。

现在将以下函数添加到类中：

```swift
func getAlbums() -> [Album] {
  return albums
}
  
func addAlbum(_ album: Album, at index: Int) {
  if albums.count >= index {
    albums.insert(album, at: index)
  } else {
    albums.append(album)
  }
}
  
func deleteAlbum(at index: Int) {
  albums.remove(at: index)
}
```

这些方法允许你获取，添加和删除专辑。

编译你的项目，确保所有内容能正确地通过编译。

此时，你可能想知道 `PersistencyManager` 类的位置，因为它不是单例。你将在下一节中看到 `LibraryAPI` 和 `PersistencyManager` 之间的关系，你将在其中查看 **外观（Facade）** 设计模式。

## 外观模式

[![](https://koenig-media.raywenderlich.com/uploads/2017/07/swift-sunglasses-1-320x320.png)](https://koenig-media.raywenderlich.com/uploads/2017/07/swift-sunglasses-1.png)

外观设计模式为复杂子系统提供了单一界面。你只需公开一个简单的统一 API，而不是将用户暴露给一组类及其 API。

下图说明了这个概念：

[![facade2](https://koenig-media.raywenderlich.com/uploads/2013/07/facade2-480x241.png)](https://koenig-media.raywenderlich.com/uploads/2013/07/facade2.png)

API 的用户完全不知道它其中的复杂性。这种模式在大量使用比较复杂或难理解的类时是比较理想的。

外观模式将使用系统接口的代码与你隐藏的类的实现进行解耦，它还减少了外部代码对子系统内部工作的依赖性。 如果外观下的类可能会更改，那这仍然很有用，因为外观类可以在幕后发生更改时保留相同的 API。

举个例子，如果你想要替换后端服务，那么你不必更改使用 API 的代码，只需更改外观类中的代码即可。

## 如何使用外观模式

目前，你拥有 `PersistencyManager` 在本地保存专辑数据，并使用 `HTTPClient` 来处理远程通信。项目中的其他类不应该涉及这个逻辑，因为它们将隐藏在 `LibraryAPI` 的外观后面。

要实现此模式，只有 `LibraryAPI` 应该包含 `PersistencyManager` 和 `HTTPClient` 的实例。其次，`LibraryAPI` 将公开一个简单的 API 来访问这些服务。

设计如下所示：

[![facade3](https://koenig-media.raywenderlich.com/uploads/2017/05/design-patterns-part1-facade-1-480x87.png)](https://koenig-media.raywenderlich.com/uploads/2017/05/design-patterns-part1-facade-1-480x87.png)

`LibraryAPI` 将暴露给其他代码，但会隐藏应用程序其余部分的 `HTTPClient` 和 `PersistencyManager` 复杂性。

打开 *LibraryAPI.swift* 并将以下常量属性添加到类中：

```swift
private let persistencyManager = PersistencyManager()
private let httpClient = HTTPClient()
private let isOnline = false
```

`isOnline` 决定了是否应使用对专辑列表所做的任何更改来更新服务器，例如添加或删除专辑。实际上 HTTP 客户端并不是与真实服务器工作，仅用于演示外观模式的用法，因此 `isOnline` 将始终为 `false`。

接下来，将以下三个方法添加到 *LibraryAPI.swift*：

```swift
func getAlbums() -> [Album] {
  return persistencyManager.getAlbums()    
}
  
func addAlbum(_ album: Album, at index: Int) {
  persistencyManager.addAlbum(album, at: index)
  if isOnline {
    httpClient.postRequest("/api/addAlbum", body: album.description)
  }  
}
  
func deleteAlbum(at index: Int) {
  persistencyManager.deleteAlbum(at: index)
  if isOnline {
    httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
  }   
}
```

我们来看看 `addAlbum(_:at:)`。该类首先在本地更新数据，然后如果网络有连接，则更新远程服务器。这是外观模式的核心优势，当你要编写 `Album` 之外的某个类添加一个新专辑时，它不知道，也不需要知道类背后的复杂性。

> **注意**：在为子系统中的类设计外观时，请记住，除非你正在构建单独的模块并使用访问控制，否则不会阻止客户端直接访问这些“隐藏”的类。不要吝啬访问控制的代码，也不要假设所有客户端都必须使用那些与外观使用它们方法相同的类。

编译并运行你的应用程序。你将看到两个空视图和一个工具栏。顶部的 View 将用于显示你的专辑封面，底部 View 将用于显示与该专辑相关的信息列表。

![Album app in starting state with no data displayed](https://koenig-media.raywenderlich.com/uploads/2017/07/startingapp-180x320.png)

你需要一些东西能在屏幕上显示专辑的数据，这是你下一个设计模式的完美实践：**装饰（Decorator）**。

## 装饰模式

装饰模式动态地向对象添加行为和职责而无需修改其中代码。它是子类化的替代方法，通过用另一个对象包装它来修改类的行为。

在 Swift 中，这种模式有两种非常常见的实现：**扩展**和**代理**。

### 拓展

添加扩展是一种非常强大的机制，允许你向现有类，结构体或枚举类型添加新功能，而无需子类化。你可以扩展你无法访问的代码并增强他们的功能也非常棒。这意味着你可以将自己的方法添加到 Cocoa 类，如 `UIView` 和 `UIImage`。

Swift 扩展与装饰模式的经典定义略有不同，因为扩展不包含它扩展的类的实例。

### 如何使用拓展

想象一下，你希望在 TableView 中显示 `Album` 实例的情况：

[![swiftDesignPattern3](https://koenig-media.raywenderlich.com/uploads/2014/11/swiftDesignPattern3-480x262.png)](https://koenig-media.raywenderlich.com/uploads/2014/11/swiftDesignPattern3.png)

专辑的标题来自哪里？`Album` 是一个模型，因此它不关心你将如何呈现数据。你需要一些外部代码才能将此功能添加到 `Album` 结构体中。

你将创建 `Album` 结构体的扩展，它将定义一个返回可以在 `UITableView` 中容易使用的数据结构的新方法。

打开 **Album.swift** 并在文件末尾添加以下代码：

```swift
typealias AlbumData = (title: String, value: String)
```

此类型定义了一个元组，其中包含表视图显示一行数据所需的所有信息。现在添加以下扩展名以访问此信息：

```swift
extension Album {
  var tableRepresentation: [AlbumData] {
    return [
      ("Artist", artist),
      ("Album", title),
      ("Genre", genre),
      ("Year", year)
    ]
  }
}
```

`AlbumData` 数组将更容易在 TableView 中显示。

> **注意**：类完全可以覆盖父类的方法，但是对于扩展则不能。扩展中的方法或属性不能与原始类中的方法或属性同名。

考虑一下这个模式有多强大：

*   你可以直接在 `Album` 中使用属性。
*   你已添加到 `Album` 结构体并且不用修改它。
*   此次简单的操作将允许你返回一个类似 `UITableView` 的 `Album`。

### 代理

外观设计模式的另一个实现是代理，它是一种让一个对象代表或协同另外一个对象工作的机制。`UITableView` 很贪婪，它有两个代理类型属性，一个叫做数据源，另一个叫代理。它们做的事情略有不同，例如 TableView 将询问其数据源在特定部分中应该有多少行，但它会询问其代理在行被点击时要执行的操作。

你不能指望 `UITableView` 知道你希望在每个 section 中有多少行，因为这是特定于应用程序的。因此，计算每个 section 中的行数的任务会被传递到数据源。这允许 `UITableView` 的类独立于它显示的数据。

以下是你创建新 `UITableView` 时所发生的事情的伪解释：

**Table**：我在这儿！我想做的就是显示 cell。嘿，我有几个 section 呢？
**Data source**：一个！
**Table**：好的，好的，很简单！第一个 section 中有多少个 cell 呢？
**Data source**：四个！
**Table**：谢谢！现在，请耐心点，这可能会有点重复。我可以在第 0 个 section 第 0 行获得 cell 吗？
**Data source**：可以，去吧！
**Table**：现在第 0 个 section，第 1 行呢？

未完待续...

`UITableView` 对象完成显示表视图的工作。但是最终它需要一些它没有的信息。然后它转向其代理和数据源，并发送一条消息，要求提供其他信息。

将一个对象子类化并重写必要的方法似乎更容易，但考虑一下你只能基于单个类进行子类化。如果你希望一个对象成为两个或更多其他对象的代理，你就无法通过子类化实现此目的。

> **注意**：这是一个重要的模式。Apple 在大多数 UIKit 类中使用这种方法： `UITableView`， `UITextView`， `UITextField`， `UIWebView`， `UICollectionView`， `UIPickerView`， `UIGestureRecognizer`， `UIScrollView`。 这个清单还将不断更新。

### 如何使用代理模式

打开 **ViewController.swift** 并把这些私有的属性添加到类：

```swift
private var currentAlbumIndex = 0
private var currentAlbumData: [AlbumData]?
private var allAlbums = [Album]()
```

从 Swift 4 开始，标记为 `private` 的变量可以在类型和所述类型的任何扩展之间共享相同的访问控制范围。如果你想浏览 Swift 4 引入的新功能，请查看 [What’s New in Swift 4](https://www.raywenderlich.com/163857/whats-new-swift-4)。

你将使 `ViewController` 成为 TableView 的数据源。在类定义的右大括号之后，将此扩展添加到 *ViewController.swift* 的末尾：

```swift
extension ViewController: UITableViewDataSource {

}
```

编译器会发出警告，因为 `UITableViewDataSource` 有一些必需的函数。在扩展中添加以下代码让警告消失：

```swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  guard let albumData = currentAlbumData else {
    return 0
  }
  return albumData.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
  if let albumData = currentAlbumData {
    let row = indexPath.row
    cell.textLabel?.text = albumData[row].title
    cell.detailTextLabel?.text = albumData[row].value
  }
  return cell
}
```

`tableView(_:numberOfRowsInSection:)` 返回要在 tableView 中显示的行数，该行数与专辑“装饰”表示中的项目数相匹配。

`tableView(_:cellForRowAtIndexPath:)` 创建并返回一个带有 title 和 value 的 cell。

> **注意**：你实际上可以将方法添加到主类声明或扩展中，编译器并不关心数据源方法实际上存在于 `UITableViewDataSource` 扩展中。对于阅读代码的人来说，这种组织确实有助于提高可读性。

接下来，使用以下代码替换 `viewDidLoad()`：

```swift
override func viewDidLoad() {
  super.viewDidLoad()
 
  //1
  allAlbums = LibraryAPI.shared.getAlbums()

  //2
  tableView.dataSource = self		
}
```

以下是上述代码的解析：

1. 通过 API 获取所有专辑的列表。请记住，我们的计划是直接使用 `LibraryAPI` 的外观而不是直接用 `PersistencyManager`！
2. 这是你设置 `UITableView` 的地方。你声明 ViewController 是 `UITableView` 数据源，因此，`UITableView` 所需的所有信息都将由 ViewController 提供。请注意，如果在 storyboard 中创建了 TableView，你实际上可以在那里设置代理和数据源。

现在，将以下方法添加到 ViewController 里：

```swift
private func showDataForAlbum(at index: Int) {
    
  // defensive code: make sure the requested index is lower than the amount of albums
  if index < allAlbums.count && index > -1 {
    // fetch the album
    let album = allAlbums[index]
    // save the albums data to present it later in the tableview
    currentAlbumData = album.tableRepresentation
  } else {
    currentAlbumData = nil
  }
  // we have the data we need, let's refresh our tableview
  tableView.reloadData()
}
```

`showDataForAlbum(at:)` 从专辑数组中获取所需的专辑数据。当你想要刷新数据时，你只需要在 `UITableView` 里调用 `reloadData`。这会导致 TableView 再次调用其数据源方法，例如重新加载 TableView 中应显示的 section 个数，每个 section 中的行数以及每个 cell 的外观等等。

将以下行添加到 `viewDidLoad()` 的末尾：

```swift
showDataForAlbum(at: currentAlbumIndex)
```

这会在应用启动时加载当前专辑。由于 `currentAlbumIndex` 设置为 `0`，因此显示该集合中的第一张专辑。

编译并运行你的项目，你的应用启动后屏幕上应该会显示如下图：

![Album app showing populated table view](https://koenig-media.raywenderlich.com/uploads/2017/07/appwithtableviewpopulated-180x320.png)

TableView 设置数据源完成！

## 写在最后

为了不使用硬编码值（例如字符串 `Cell`）污染代码，请查看 `ViewController`，并在类定义的左大括号之后添加以下内容：

```swift
private enum Constants {
  static let CellIdentifier = "Cell"
}
```

在这里，你将创建一个枚举充当常量的容器。

> **注意**：使用不带 case 的枚举的优点是它不会被意外地实例化并只作为一个纯命名空间。

现在只需用 `Constants.CellIdentifier` 替换 `"Cell"`。

## 接下来该干嘛？

到目前为止，事情看起来进展很顺利！你知道了 MVC 模式，还有单例，外观和装饰模式。你可以看到 Apple 在 Cocoa 中如何使用它们以及如何将模式应用于你自己的代码。

如果你想要查看或比较，那请看 [最终项目](https://koenig-media.raywenderlich.com/uploads/2017/07/RWBlueLibrary-Part1-Final.zip)。

库存里还有很多：[本教程的第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-2-2.md)还有适配器，观察者和备忘录模式。如果这还不够，我们会有一个后续教程，在你重构一个简单的 iOS 游戏时会涉及更多的设计模式。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
