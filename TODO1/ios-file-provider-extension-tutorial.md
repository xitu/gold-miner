> - 原文地址：[iOS File Provider Extension Tutorial](https://www.raywenderlich.com/697468-ios-file-provider-extension-tutorial)
> - 原文作者：[Ryan Ackermann](https://www.raywenderlich.com/u/naturaln0va)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ios-file-provider-extension-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ios-file-provider-extension-tutorial.md)
> - 译者：[iWeslie](https://github.com/iWeslie)
> - 校对者：[swants](https://github.com/swants)

# iOS 中的 File Provider 拓展

在本教程中，你将学习 File Provider 拓展以及如何使用它把你 App 的内容公开出来。

File Provider 在 iOS 11 中引入，它通过 iOS 的 **文件** App 来访问你 App 管理的内容。同时其他的 App 也可以使用 [`UIDocumentBrowserViewController`](https://developer.apple.com/documentation/uikit/uidocumentbrowserviewcontroller) 或 [`UIDocumentPickerViewController`](https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller) 来访问你 App 的数据。

File Provider 拓展的主要任务是：

* 创建表示云端内容的占位文件。
* 当有 App 访问文件内容时先对文件进行下载或上传。
* 在更新文件后发出通知来把更新上传到服务器。
* 枚举存储的文件和目录。
* 对文档执行操作，例如重命名、移动或删除。

你将使用 [Heroku 按钮](https://blog.heroku.com/heroku-button) 来配置托管文件的服务器。在服务器设置完成后，你需要配置扩展来对服务器的内容进行枚举。

## 着手开始

首先，请先 [下载资源](https://koenig-media.raywenderlich.com/uploads/2019/05/Favart-5-16-19.zip)，完成后找到 **Favart-Starter** 文件夹并打开 **Favart.xcodeproj**。确保你已选择 **Favart** 的 scheme，然后编译并运行该 App，你会看到以下内容：

![The container app for your File Provider.](https://koenig-media.raywenderlich.com/uploads/2019/01/01-container-app-281x500.png)

该 App 提供了一个基础的 View 来告诉用户如何启用 File Provider 扩展，因为你实际上不会在 App 内执行任何操作。每次在本教程中编译运行 App 时，你都将返回主屏幕并打开 **文件** 这个 App 来访问你的扩展。

> **注意**：如果要在真机上运行该项目，除了为两个 target 设置开发者信息外，还需要在 **Configuration** 文件夹中编辑 **Favart.xcconfig**。将 Bundle ID 更新为唯一值。
>
> 示例项目将这个值用于两个 target 中 build setting 里的 `PRODUCT_BUNDLE_IDENTIFIER`，**Provider.entitlements** 里的 App Groups 标识符，还有 **Info.plist** 中的 `NSExtensionFileProviderDocumentGroup`。在项目中如果没有同步更新它们，你将会得到模糊并且让人没法调试的编译报错信息，而使用自定义的 build settings 将会是一个聪明的方法。

示例项目中已经包含了你将用于 File Provider 扩展的基本组件：

* **NetworkClient.swift** 包含用于与 Heroku 服务器通信的网络请求客户端。
* **FileProviderExtension.swift** 就是 File Provider 拓展本身。
* **FileProviderEnumerator.swift** 包含了枚举器，用于枚举目录的内容。
* **Models** 是一组用来完成扩展所需的模型。

## 使用 Heroku 设置后端

首先，你需要一个自己的后端服务器实例。幸运的是，使用 **Heroku Button** 将很容易完成这个操作。单击下面的按钮访问 **Heroku** 的 dashboard。

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/naturaln0va/favart-api/tree/master)

在你注册完 **Heroku** 的免费账号后，你将看到以下页面：

![Deploy to Heroku](https://koenig-media.raywenderlich.com/uploads/2019/01/03-backend-deploy-setup.png)

在此页面上，你可以给你的 App 取一个名字，也可以将该字段留空，**Heroku** 将为你自动生成一个名称。不必配置其他东西，现在你可以点击 **Deploy app** 按钮，一会儿之后你的后端就会启动并运行。

![Deploy successful](https://koenig-media.raywenderlich.com/uploads/2019/01/02-backend-deploy-success.png)

在 Heroku 完成部署 App 之后，单击底部的 **View**。这会跳转到你托管实例的后端 URL。在根目录下，你应该看到一条 JSON 数据，是你熟悉的 **Hello world!**。

最后，你需要复制 **Heroku** 实例的 URL，但是只需要其中的域名部分：**{app-name}.herokuapp.com**。

在 starter 项目中，打开 **Provider/NetworkClient.swift**。在文件的顶部，你应该会看到一条警告，告诉你 **Add your Heroku URL here**。删除这个警告并用你的 URL 替换 `components.host` 占位符字符串。

现在你就完成了服务器配置。接下来，你将定义 File Provider 所依赖的模型。

## 定义 NSFileProviderItem

首先，File Provider 需要一个遵循了 `NSFileProviderItem` 协议的模型。此模型将提供有关 File Provider 所管理的文件的信息。starter 项目在 **FileProviderItem.swift** 中已经定义了 `FileProviderItem`，在使用它之前需要遵循一些协议。

虽然该协议含有 27 个属性，但我们只需要其中 4 个。其他一些可选属性为 File Provider 提供有关每个文件的详细信息以及一些其他功能。在本教程中，你将用到以四个属性：`itemIdentifier`、`parentItemIdentifier`、`filename` 和 `typeIdentifier`。

`itemIdentifier` 给模型提供了唯一标示符。File Provider 使用 `parentIdentifier` 来跟踪它在扩展的层次结构中的位置。

`filename` 是 **文件** 里显示的 App 名字。`typeIdentifier` 是一个 [统一类型标识符（UTI）](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_intro/understand_utis_intro.html)。

在 `FileProviderItem` 可以遵循 `NSFileProviderItem` 协议之前，它还需要一个处理来自后端数据的方法。`MediaItem` 定义了一个后端数据的简单模型。我们并不是直接在 `FileProviderItem` 中使用这个模型，而是使用 `MediaItemReference` 来处理 File Provider 扩展的一些额外逻辑从而把其中的坑填上。

你将在本教程中使用 `MediaItemReference` 有两个原因：

1. 在 Heroku 上托管的后端非常简洁，它无法提供 `NSFileProviderItem` 所需的所有信息，因此你需要在其他地方获取它。
2. 这个 File Provider 扩展也很简单，更完整的 File Provider 扩展需要使用诸如 Core Data 之类的东西在本地持久化存储后端返回的数据，让它能在该扩展的生命周期结束后引用它。

为了将教程的重心放到 File Provider 扩展本身上，你将使用 `MediaItemReference` 来快速入门，你需要将四个必填字段嵌入到 `URL` 对象中。然后将该 URL 编码成 `NSFilProviderItemIdentifier`。你不需要手动存储其他东西，因为 `NSFileProviderExtension` 会为你处理它。

打开 **Provider/MediaItemReference.swift** 并把以下代码添加到 `MediaItemReference` 里：

```swift
// 1
private let urlRepresentation: URL

// 2
private var isRoot: Bool {
    return urlRepresentation.path == "/"
}

// 3
private init(urlRepresentation: URL) {
    self.urlRepresentation = urlRepresentation
}

// 4
init(path: String, filename: String) {
    let isDirectory = filename.components(separatedBy: ".").count == 1
    let pathComponents = path.components(separatedBy: "/").filter { !$0.isEmpty } + [filename]

    var absolutePath = "/" + pathComponents.joined(separator: "/")
    if isDirectory {
        absolutePath.append("/")
    }
    absolutePath = absolutePath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? absolutePath

    self.init(urlRepresentation: URL(string: "itemReference://\(absolutePath)")!)
}
```

以下是代码的详解：

1. 在本教程中，URL 将包含 `NSFileProviderItem` 所需的大部分信息。
2. 此计算属性判断当前项是否是文件系统的根目录。
3. 你将此初始化方法设为私有以防止从模型外部调用。
4. 从后端读取数据时，你将调用此初始化方法。如果文件名不包含文件后缀，则它一定是个文件夹，因为初始化方法并不能自动推断其类型。

在添加最终初的始化器之前，请把文件顶部的 import 语句替换成：

```swift
import FileProvider
```

接下来在刚刚那段代码下面添加以下初始化器：

```swift
init?(itemIdentifier: NSFileProviderItemIdentifier) {
    guard itemIdentifier != .rootContainer else {
        self.init(urlRepresentation: URL(string: "itemReference:///")!)
        return
    }

    guard let data = Data(base64Encoded: itemIdentifier.rawValue),
        let url = URL(dataRepresentation: data, relativeTo: nil)
    else {
        return nil
    }

    self.init(urlRepresentation: url)
}
```

大部分扩展都将使用此初始化器。注意开头的 `itemReference://`。你可以单独处理根目录的标识符以确保能正确设置其 URL 的路径。

对于其他项，你可以将标识符的原始值转换为 base64 编码后的数据来检索 URL。URL 中的信息来自第一次对实例进行枚举的网络请求。

既然现在初始化器已经设置好了，是时候为这个模型添加一些属性了。首先，在文件顶部添加如下 `import`：

```swift
import MobileCoreServices
```

这将让你可以访问文件类型，在这个结构体里继续添加：

```swift
// 1
var itemIdentifier: NSFileProviderItemIdentifier {
    if isRoot {
        return .rootContainer
    } else {
        return NSFileProviderItemIdentifier(rawValue: urlRepresentation.dataRepresentation.base64EncodedString())
    }
}

var isDirectory: Bool {
    return urlRepresentation.hasDirectoryPath
}

var path: String {
    return urlRepresentation.path
}

var containingDirectory: String {
    return urlRepresentation.deletingLastPathComponent().path
}

var filename: String {
    return urlRepresentation.lastPathComponent
}

// 2
var typeIdentifier: String {
    guard !isDirectory else {
        return kUTTypeFolder as String
    }

    let pathExtension = urlRepresentation.pathExtension
    let unmanaged = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)
    let retained = unmanaged?.takeRetainedValue()

    return (retained as String?) ?? ""
}

// 3
var parentReference: MediaItemReference? {
    guard !isRoot else {
        return nil
    }
    return MediaItemReference(urlRepresentation: urlRepresentation.deletingLastPathComponent())
}
```

你需要知道记住以下几点：

1. 对于 FileProvider 管理的每一项，`itemIdentifier` 必须是唯一的。如果是根目录，那么它使用 `NSFileProviderItemIdentifier.rootContainer`，否则从 URL 创建一个标识符。
2. 这里它根据拓展路径的 URL 创建一个标识符，看上去很奇怪的 `UTTypeCreatePreferredIdentifierForTag` 实际上是一个返回给定输入的 UTI 类型的 C 函数。
3. 在处理目录型结构时，对于父级的引用非常有用。这个属性表示了包含当前引用的文件夹。它是一个可选类型，因为根目录是没有父级的。

你在此处添加了一些其他属性，这些属性不需要太多解释，但在创建 `NSFileProviderItem` 时非常有用。现在参考模型已经创建完成了，是时候把所有东西与 `FileProviderItem` 进行挂钩了。

打开 **FileProviderItem.swift** 并在顶部添加：

```swift
import FileProvider
```

然后在文件的最底部添加：

```swift
// MARK: - NSFileProviderItem

extension FileProviderItem: NSFileProviderItem {
    // 1
    var itemIdentifier: NSFileProviderItemIdentifier {
        return reference.itemIdentifier
    }

    var parentItemIdentifier: NSFileProviderItemIdentifier {
        return reference.parentReference?.itemIdentifier ?? itemIdentifier
    }

    var filename: String {
        return reference.filename
    }

    var typeIdentifier: String {
        return reference.typeIdentifier
    }

    // 2
    var capabilities: NSFileProviderItemCapabilities {
        if reference.isDirectory {
            return [.allowsReading, .allowsContentEnumerating]
        } else {
            return [.allowsReading]
        }
    }

    // 3
    var documentSize: NSNumber? {
        return nil
    }
}
```

`FileProviderItem` 现在已经遵循 `NSFileProviderItem` 并实现了所有必须的属性。以上代码的详解如下：

1. 大多数必须的属性映射了你之前添加到 `MediaItemReference` 的逻辑。
2. `NSFileProviderItemCapabilities` 表示可以对文档浏览器中的项目执行哪些操作，例如读取和删除。对于该 App，你只需要允许读取和枚举目录。在实际项目中，你可能会使用 `.allowsAll`，因为用户希望所有操作都可以进行。
3. 本教程不会用到文档的大小，把它包含在里面以防止 `NSFileProviderManager.writePlaceholder(at:withMetadata:)` 会崩溃。这可能是框架的一个错误，但是一般情况下 App 的文件扩展无论如何都会提供 `documentSize`。

以上就是模型，`NSFileProviderItem` 还有更多其他属性，但是你目前实现的已经足够了。

## 枚举文件

现在模型已经完善好了，可以拿来使用了。你需要告诉系统你 App 里有什么内容才能向用户展示模型定义的 item。

`NSFileProviderEnumerator` 定义系统和 App 内容间的关系。你稍后将看到系统是如何通过提供表示当前上下文的 `NSFileProviderItemIdentifier` 从而请求枚举器的。如果用户当前在根目录下，系统将会提供 `.rootContainer` 标识符。在其他目录下时，系统则会传入你模型定义的项目的标识符。

首先，在 starter 里构建枚举器。打开 **Provider/FileProviderEnumerator.swift** 并在 `path` 下添加：

```swift
private var currentTask: URLSessionTask?
```

此属性将存储对当前网络请求任务的引用。这提可以让你随时取消请求。

接下来把 `enumerateItems(for:startingAt:)` 里的内容替换成：

```swift
let task = NetworkClient.shared.getMediaItems(atPath: path) { results, error in
    guard let results = results else {
        let error = error ?? FileProviderError.noContentFromServer
        observer.finishEnumeratingWithError(error)
        return
    }

    let items = results.map { mediaItem -> FileProviderItem in
        let ref = MediaItemReference(path: self.path, filename: mediaItem.name)
        return FileProviderItem(reference: ref)
    }

    observer.didEnumerate(items)
    observer.finishEnumerating(upTo: nil)
}

currentTask = task
```

这里实现了 NetworkClient 单例获取指定路径的内容。请求成功后，枚举器的观察者通过调用 `didEnumerate` 和 `finishEnumerating(upTo:)` 来返回新的数据。通过 `finishEnumeratingWithError` 来通知枚举器的观察者请求到的结果是否有错误。

> **注意**：实际的 App 可能使用分页来获取数据，这就会用到 `NSFileProviderPage` 来执行此操作。首先 App 将使用整数作为页面索引，然后将其序列化并存储在 `NSFileProviderPage` 结构体中。

最后你讲把下面的内容添加到 `invalidate()` 来完成这个枚举器：

```swift
currentTask?.cancel()
currentTask = nil
```

如果有需要，那就会取消当前的网络请求，因为有些情况下可能需要访问用户的网络状态或者当前的位置，也可能是一些一些资源的使用情况。

完成该方法后，你就可以使用此枚举器访问后端服务器的数据，接下来就会进入 `FileProviderExtension` 类。

打开 **Provider/FileProviderExtension.swift** 并把 `item(for:)` 的代码替换成：

```swift
guard let reference = MediaItemReference(itemIdentifier: identifier) else {
    throw NSError.fileProviderErrorForNonExistentItem(withIdentifier: identifier)
}
return FileProviderItem(reference: reference)
```

系统会提供 identifier 参数，并且你需要给那个 identifier 返回一个 `FileProviderItem`。这个 guard 语句确保了创建的 `MediaItemReference` 是有效的。

接下来，把 `urlForItem(withPersistentIdentifier:)` 和 `persistentIdentifierForItem(at:)` 替换成以下内容：

```swift
// 1
override func urlForItem(withPersistentIdentifier identifier: NSFileProviderItemIdentifier) -> URL? {
    guard let item = try? item(for: identifier) else {
        return nil
    }

    return NSFileProviderManager.default.documentStorageURL
      .appendingPathComponent(identifier.rawValue, isDirectory: true)
      .appendingPathComponent(item.filename)
}

// 2
override func persistentIdentifierForItem(at url: URL) -> NSFileProviderItemIdentifier? {
    let identifier = url.deletingLastPathComponent().lastPathComponent
    return NSFileProviderItemIdentifier(identifier)
}
```

以下是代码详解：

1. 验证一下来确保给定的 identifier 能解析为扩展模型的实例。然后返回一个文件 URL，它是将项目存储在文件管理器里的位置。
2. 由 `urlForItem(withPersistentIdentifier:)` 返回的每个 URL 都需要映射回最初设置的 `NSFileProviderItemIdentifier`。在该方法中，你要以 `<documentStorageURL>/<itemIdentifier>/<filename>` 的格式构建 URL 并采用 `<itemIdentifier>` 作为标识符。

现在有两个方法都需要你传入一个指向远端文件的占位符 URL 。首先你将创建一个帮助辅助方法来完成这个功能，将以下内容添加到 `providePlaceholder(at:)`：

```swift
// 1
guard let identifier = persistentIdentifierForItem(at: url),
    let reference = MediaItemReference(itemIdentifier: identifier)
else {
    throw FileProviderError.unableToFindMetadataForPlaceholder
}

// 2
try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)

// 3
let placeholderURL = NSFileProviderManager.placeholderURL(for: url)
let item = FileProviderItem(reference: reference)

// 4
try NSFileProviderManager.writePlaceholder(at: placeholderURL, withMetadata: item)
```

以上代码完成的功能如下：

1. 首先你从提供的 URL 创建 identifier 和 reference。如果失败了则抛出错误。
2. 创建占位符时，必须确保这个目录是存在的，否则就会遇到问题，使用 `NSFileManager` 来执行此操作。
3. 这个 `url` 参数是用来显示图像的，而不是占位符。因此你要使用 `placeholderURL(for:)` 来创建占位符 URL，并获取此占位符将表示的 `NSFileProviderItem`。
4. 将占位符写入文件系统。

接下来把 `providePlaceholder(at:completionHandler:)` 的内容替换成：

```swift
do {
    try providePlaceholder(at: url)
    completionHandler(nil)
} catch {
    completionHandler(error)
}
```

当 File Provider 需要一个占位符 URL 时，它将调用 `providePlaceholder(at:completionHandler:)`。你将尝试使用上面的辅助方法创建占位符，如果抛出错误，则将其传递给 `completionHandler`。就像在 `providePlaceholder(at:)` 中一样，这个步骤成功之后就不需要传递任何内容，File Provider 只需要你的占位符 URL。

当用户在目录下切换时，File Provider 将调用 `enumerator(for:)` 来请求给定 identifier 的 `FileProviderEnumerator`。用以下内容替换该法的内容：

```swift
if containerItemIdentifier == .rootContainer {
    return FileProviderEnumerator(path: "/")
}

guard let ref = MediaItemReference(itemIdentifier: containerItemIdentifier), ref.isDirectory
else {
    throw FileProviderError.notAContainer
}

return FileProviderEnumerator(path: ref.path)
```

此方法确保了给定 identifier 对应的是一个目录。如果是根目录，则仍然创建枚举器，因为根目录也是有效目录。

编译并运行，App 启动后，打开 **文件** App，点击两次右下角的 **浏览**，你就会进入 **文件** 的根目录。选择 **更多位置**，会出现 **提供者** 或展开一个列表，点击开启你 App 的拓展。

> **注意**：如果找不到 **更多位置** 展开的项目不能点击，你可以再点击一下右上角的 **编辑** 按钮。

![First look at the extension.](https://koenig-media.raywenderlich.com/uploads/2019/01/04-first-enumeration-281x500.png)

你现在有一个有效的 File Provider 扩展了，但是还缺少一些重要的东西，接下来你将添加它们。

## 提供缩略图

因为 App 会显示后端请求来的图片，因此显示出图像的缩略图非常重要，你可以重写一个方法来生成缩略图。

在 `enumerator(for:)` 下面添加：

```swift
// MARK: - Thumbnails

override func fetchThumbnails(for itemIdentifiers: [NSFileProviderItemIdentifier], requestedSize size: CGSize,
                              perThumbnailCompletionHandler: @escaping (NSFileProviderItemIdentifier, Data?, Error?) -> Void,
                              completionHandler: @escaping (Error?) -> Void) -> Progress {
    // 1
    let progress = Progress(totalUnitCount: Int64(itemIdentifiers.count))

    for itemIdentifier in itemIdentifiers {
        // 2
        let itemCompletion: (Data?, Error?) -> Void = { data, error in
            perThumbnailCompletionHandler(itemIdentifier, data, error)

            if progress.isFinished {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }

        guard let reference = MediaItemReference(itemIdentifier: itemIdentifier), !reference.isDirectory
        else {
            progress.completedUnitCount += 1

            let error = NSError.fileProviderErrorForNonExistentItem(withIdentifier: itemIdentifier)
            itemCompletion(nil, error)
            continue
        }

        let name = reference.filename
        let path = reference.containingDirectory

        // 3
        let task = NetworkClient.shared.downloadMediaItem(named: name, at: path) { url, error in
            guard let url = url, let data = try? Data(contentsOf: url, options: .alwaysMapped) else {
                itemCompletion(nil, error)
                return
            }
            itemCompletion(data, nil)
        }

        // 4
        progress.addChild(task.progress, withPendingUnitCount: 1)
    }

    return progress
}
```

虽然这种方法非常冗长，但其逻辑很简单：

1. 此方法返回一个 `Progress` 对象，该对象会记录每个缩略图请求的状态。
2. 它为每个 `itemIdentifier` 定义了一个 completion 闭包，该闭包将负责调用此方法所需的每个项的闭包以及最后调用最后一个闭包。
3. 使用 starter 项目附带的 `NetworkClient` 将缩略图文件从服务器下载到临时文件。在下载完成后，completion handler 将下载的 `data` 传递给 `itemCompletion` 闭包。
4. 每个下载任务都作为依赖项添加到父进程对象。

> **注意**：在处理较大的数据时，为每个占位符都发出单独的网络请求可能需要耗费一些时间。因此如果可能的话，你的后端应提供单个请求中的批量下载图像方法。

编译并运行。打开 **文件** 里的拓展就能看到你的缩略图了：

![The thumbnails are now working.](https://koenig-media.raywenderlich.com/uploads/2019/03/thumbnails-working-281x500.png)

## 显示完整图片

现在当你选择一个项目时，该 App 将会显示一个没有完整图像的空白视图：

![No content.](https://koenig-media.raywenderlich.com/uploads/2019/01/06-blank-view-281x500.png)

到目前为止，你只实现了预览缩略图的显示，还需要添加完整图片的显示。

与缩略图生成一样，让完整的图片显示只需要一个方法，即 `startProvidingItem(at:completionHandler:)`。将以下内容添加到 `FileProviderExtension` 类的底部：

```swift
// MARK: - Providing Items

override func startProvidingItem(at url: URL, completionHandler: @escaping ((_ error: Error?) -> Void)) {
    // 1
    guard !fileManager.fileExists(atPath: url.path) else {
        completionHandler(nil)
        return
    }

    // 2
    guard let identifier = persistentIdentifierForItem(at: url), let reference = MediaItemReference(itemIdentifier: identifier) else {
        completionHandler(FileProviderError.unableToFindMetadataForItem)
        return
    }

    // 3
    let name = reference.filename
    let path = reference.containingDirectory
    NetworkClient.shared.downloadMediaItem(named: name, at: path, isPreview: false) { fileURL, error in
        // 4
        guard let fileURL = fileURL else {
            completionHandler(error)
            return
        }

        // 5
        do {
            try self.fileManager.moveItem(at: fileURL, to: url)
            completionHandler(nil)
        } catch {
            completionHandler(error)
        }
    }
}
```

以上的代码功能是：

1. 检查指定 URL 中是否已存在某项，防止再次请求相同的数据。在实际项目中，你应该检查修改日期和文件版本号，确保你获得的是最新数据。但是，在本教程中没有必要这样做，因为它并不支持版本控制。
2. 获取相关 `URL` 的 `MediaItemReference` 来确认需要从后端请求哪个文件。
3. 从 reference 中提取文件名称和路径，然后进行请求。
4. 如果下载文件时出错，则把错误传给错误处理闭包。
5. 将文件从其临时下载目录移动到扩展名指定的文档存储 URL。

编译并运行，打开扩展后选择任何一张图，你可以看到完整的图片。

![A full image is loaded.](https://koenig-media.raywenderlich.com/uploads/2019/01/07-full-doughnut-281x500.png)

当你打开更多文件时，该扩展程序需要删除已经下载了的文件，File Provider 扩展内置了这个功能。

你必须重写 `stopProvidingItem(at:)`，这样才能清理下载了的文件并提供新的占位符。在 `FileProviderExtension` 类的底部添加以下内容：

```swift
override func stopProvidingItem(at url: URL) {
    try? fileManager.removeItem(at: url)
    try? providePlaceholder(at: url)
}
```

这样就能删除图片，并调用 `providePlaceholder(at:)` 来生成一个新的占位符。

以上就完成了 File Provider 的最基本功能。文件枚举，缩略图预览以及查看文件内容是此扩展的基本组件。

到现在为止，你的 File Provider 的功能就齐全了。

## 接下来该干嘛？

你现在已经拥有了一个包含了有效的 File Provider 的 App，这个扩展程序可以枚举以及显示后端服务器的东西。

你可以点击 [下载资源](https://koenig-media.raywenderlich.com/uploads/2019/05/Favart-5-16-19.zip) 来下载完整版的项目。

你可以在 [Apple 关于 File Provider 的文档](https://developer.apple.com/documentation/fileprovider) 中了解更多有关 File Provider 的操作。你还可以使用其他扩展程序将自定义 UI 添加到 File Provider，你可以从 [这里](https://developer.apple.com/documentation/fileproviderui) 可以阅读到更多相关信息。

如果你对其他在 iOS 上使用文件的操作感兴趣，你可以查看 的更多方式感兴趣，请查看 [基于文档的 App](https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started)。

希望你喜欢这个教程！如果你有任何问题或意见，可以加入 [原文](https://www.raywenderlich.com/697468-ios-file-provider-extension-tutorial) 最下面的讨论组。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
