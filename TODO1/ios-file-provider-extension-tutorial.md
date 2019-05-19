> - 原文地址：[iOS File Provider Extension Tutorial](https://www.raywenderlich.com/697468-ios-file-provider-extension-tutorial)
> - 原文作者：[Ryan Ackermann](https://www.raywenderlich.com/u/naturaln0va)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ios-file-provider-extension-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ios-file-provider-extension-tutorial.md)
> - 译者：[iWeslie](https://github.com/iWeslie)
> - 校对者：

# iOS 中的 File Provider 拓展

在本教程中，你将学习 File Provider 拓展以及如何使用它把你 App 的内容暴露出来。

File Provider 在 iOS 11 中引进，它通过 iOS 的 **Files** App 来访问你 App 管理的内容。此外，其他 App 也可以使用 [`UIDocumentBrowserViewController`](https://developer.apple.com/documentation/uikit/uidocumentbrowserviewcontroller) 或 [`UIDocumentPickerViewController`](https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller) 类来访问你 App 的数据。

File Provider 拓展的主要任务是：

* 创建表示远端内容的文件占位符。
* 拦截从宿主 App 的读取内容来进行下载或更新文件。
* 在更新文件后发出通知来把更新上传到远程服务器。
* 枚举存储的文件和目录。
* 对文档执行操作，例如重命名、移动或删除。

你将使用 [Heroku Button](https://blog.heroku.com/heroku-button) 来配置托管文件的服务器。在服务器设置完成后，你需要配置扩展来对服务器的内容进行枚举。

## 着手开始

首先，请先 [下载资源](https://koenig-media.raywenderlich.com/uploads/2019/05/Favart-5-16-19.zip)，完成后找到 **Favart-Starter** 文件夹并打开 **Favart.xcodeproj**。确保您已选择 **Favart** 的 scheme，然后编译并运行该 App，你会看到以下内容：

![The container app for your File Provider.](https://koenig-media.raywenderlich.com/uploads/2019/01/01-container-app-281x500.png)

该 App 提供了一个基础的 View 来告诉用户如何启用 File Provider 扩展，因为你实际上不会在 App 内执行任何操作。每次在本教程中编译运行 App 时，你都将返回主屏幕并打开 **Files** 这个 App 来访问你的扩展。

> **注意**：如果要在真机上运行该项目，除了为两个 target 设置开发者信息外，还需要在 **Configuration** 文件夹中编辑 **Favart.xcconfig**。将 Bundle ID 更新为唯一值。
>
> 示例项目将这个值用于两个 target 中 build setting 里的 `PRODUCT_BUNDLE_IDENTIFIER`，**Provider.entitlements** 里的 App Groups 标识符，还有 **Info.plist** 中的 `NSExtensionFileProviderDocumentGroup`。在项目中如果没有同步更新它们，你将会得到模糊并且让人摸不着头脑编译报错信息。使用自定义的 build settings 将会是一个讨巧的方法。

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

在 Heroku 完成部署 App 之后，单击底部的 **View**。这会跳转到你托管实例的后端 URL。在根目录下，您应该看到一条 JSON 数据，是你熟悉的 **Hello world!**。

最后，您需要复制 **Heroku** 实例的 URL，但是只需要其中的域名部分：**{app-name}.herokuapp.com**。

在 starter 项目中，打开 **Provider/NetworkClient.swift**。在文件的顶部，你应该会看到一条警告，告诉你 **Add your Heroku URL here**。删除这个警告并用你的 URL 替换 `components.host` 占位符字符串。

现在你就完成了服务器配置。接下来，你将定义 File Provider 所依赖的模型。

## 定义 NSFileProviderItem

首先，File Provider 需要一个遵循了 `NSFileProviderItem` 协议的模型。此模型将提供有关文件提供程序管理的文件的信息。starter 项目在 **FileProviderItem.swift** 中已经定义了 `FileProviderItem`，在使用它之前需要遵循一些协议。

虽然该协议含有 27 个属性，但我们只需要其中 4 个。可选的一些属性为 File Provider 提供有关每个文件的详细信息以及一些其他功能。在本教程中，你将用到以四个属性：`itemIdentifier`，`parentItemIdentifier`，`filename` 和 `typeIdentifier`。

`itemIdentifier` 给模型提供了唯一可识别的密钥。File Provider 使用 `parentIdentifier` 来跟踪它在扩展的层次结构中的位置。

`filename` 是 **Files** 里显示的 App 名字。
`typeIdentifier` 是 item 的 [统一类型标识符（UTI）](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_intro/understand_utis_intro.html)。

在 `FileProviderItem` 可以遵循 `NSFileProviderItem` 协议，它需要一个处理来自后端的数据的方法。`MediaItem` 定义了一个后端数据的简单模型。我们并不是直接在 `FileProviderItem` 中使用这个模型，而是使用 `MediaItemReference` 来处理 File Provider 扩展的一些额外逻辑从而把其中的坑填上。

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
4. 从后端读取数据时，你将调用此初始化方法。如果文件名不包含点，则它必须是目录，因为初始化方法并不能自动推断其类型。

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

## Enumerating Documents

Now that the model is in place, it’s time to put it to use. To display the items defined by the model to the user, you need to tell the system about your app’s content.

`NSFileProviderEnumerator` defines the relationship between the system and the app’s content. In a bit, you’ll see how the system requests an enumerator by providing an `NSFileProviderItemIdentifier` which represents the current context. If the user is viewing the root of your extension, the system will supply the `.rootContainer` identifier. When the user navigates inside a directory, the system then passes in the identifier for that item defined by your model.

First, you’ll build out the enumerator provided in the starter. Open **Provider/FileProviderEnumerator.swift** and add the following below `path`:

```swift
private var currentTask: URLSessionTask?
```

This property will store a reference to the current network task. This provides the ability to cancel the request.

Next, replace the contents of `enumerateItems(for:startingAt:)` with the following:

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

Here, the provided network client code fetches all the items at a specified path. Upon a successful request, the enumerator’s observer returns new data by calling `didEnumerate` followed by `finishEnumerating(upTo:)` to indicate the end of the batch of items. It notifies the enumerator’s observer if an error occurs from the request by calling `finishEnumeratingWithError`.

> **Note**: A production application might use pagination to fetch data. It would use the `NSFileProviderPage` method parameter to do this. In this scenario, an application would use integers as page indices which would then get serialized and stored in the `NSFileProviderPage` struct.

The last step in completing the enumerator is to add the following to `invalidate()`:

```swift
currentTask?.cancel()
currentTask = nil
```

This will cancel the current network request if needed. It’s always a good idea to be conscious of resource use on a user’s device, such as networking or location access.

With that method complete, it’s time to use this enumerator to access data stored in the back end. The remainder of the app’s logic will go inside your `FileProviderExtension` class.

Open **Provider/FileProviderExtension.swift** and replace the contents of `item(for:)` with the following:

```swift
guard let reference = MediaItemReference(itemIdentifier: identifier) else {
  throw NSError.fileProviderErrorForNonExistentItem(withIdentifier: identifier)
}
return FileProviderItem(reference: reference)
```

The system provides the identifier passed to this method, and you return a `FileProviderItem` for that identifier. The guard statement ensures the identifier creates a valid `MediaItemReference`.

Next, replace `urlForItem(withPersistentIdentifier:)` and `persistentIdentifierForItem(at:)` with the following:

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

Going over this:

1.  You validate the item to ensure that the given identifier resolves to an instance of the extension’s model. You then return a file URL specifying where to store the item within the file manager’s document storage directory.
2.  Each URL returned by `urlForItem(withPersistentIdentifier:)` needs to map back to the `NSFileProviderItemIdentifier` it was originally set out to represent. In that method, you built the URL in the format `<documentStorageURL>/<itemIdentifier>/<filename>`, so here you will take the second to last path component as the item identifier.

There are two methods coming up that require you to reference a file placeholder URL that references a remote file. First, you’re going to create a helper method to create this placeholder. Add the following to `providePlaceholder(at:)`:

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

Here is what’s going on:

1.  First, you create an identifier and a reference from the provided URL. If that fails, throw an error.
2.  When creating placeholders, you must ensure the enclosing directory exists or else you’ll run into problems. So, use `NSFileManager` to do so.
3.  The `url` passed into this method is for the image to be displayed, not the placeholder. So you create a placeholder URL with `placeholderURL(for:)` and obtain the `NSFileProviderItem` that this placeholder will represent.
4.  Write the placeholder item to the file system.

Next, replace the contents of `providePlaceholder(at:completionHandler:)` with the following:

```swift
do {
    try providePlaceholder(at: url)
    completionHandler(nil)
} catch {
    completionHandler(error)
}
```

The File Provider will call `providePlaceholder(at:completionHandler:)` when it requires a placeholder URL. In it, you attempt to create a placeholder with the helper you built above, and if there’s an error, you pass it to the `completionHandler`. On success, you don’t need to pass anything – the File Provider just expects you to write the placeholder URL, as you did in `providePlaceholder(at:)`.

As a user navigates directories, the File Provider will call `enumerator(for:)` to ask for a `FileProviderEnumerator` for a given identifier. Replace the contents of this stubbed out method with the following:

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

This method ensures that the item for the supplied identifier is a directory. If the identifier is the root item an enumerator is still created since the root is a valid directory.

Build and run. After the app gets launched, switch to the **Files** app and enable the app’s extension. Tap the **Browse** tab bar item twice to navigate to the root of **Files**. Select **More Locations** and toggle **Provider**, which is the name of the extension.

> **Note**: If you couldn’t find **Provider** listed under **More Locations**, tap the **Edit** button in the top right corner to ensure that the disabled extensions show in the list.

![First look at the extension.](https://koenig-media.raywenderlich.com/uploads/2019/01/04-first-enumeration-281x500.png)

You now have a working File Provider extension! There are a few important things missing, but you’ll add those next.

## Providing Thumbnails

Since this app should show images from the back end, it’s important to show thumbnails for the images. There is a single method to override that will take care of thumbnail generation for the extension.

Add the following below `enumerator(for:)`:

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

While this method is quite lengthy, its logic is simple:

1.  This method returns a `Progress` object that tracks the state of each thumbnail request.
2.  It defines a completion block for each `itemIdentifier`. The block will take care of calling each per item block required by this method as well as calling the final block at the end.
3.  The thumbnail file gets downloaded from the server to a temporary file using the `NetworkClient` included with the starter project. When the download completes, the completion handler passes the downloaded `data` to the `itemCompletion` closure.
4.  Each download task gets added as a dependency to the parent progress object.

> **Note**: Making an individual network request for each placeholder might take some time when working with larger data sets. So if possible, your back end integration should provide a way to batch download images in a single request.

Build and run. Open the extension in **Files** and you should see thumbnails load in.

![The thumbnails are now working.](https://koenig-media.raywenderlich.com/uploads/2019/03/thumbnails-working-281x500.png)

## Viewing Items

Right now when you select an item the app presents a blank view without the full image:

![No content.](https://koenig-media.raywenderlich.com/uploads/2019/01/06-blank-view-281x500.png)

So far, you’ve only implemented the display of preview thumbnails — now it’s time to add the ability to view the full content!

Like the thumbnail generation, there is only a single method needed to view an item’s content and that is `startProvidingItem(at:completionHandler:)`. Add the following to the bottom of the `FileProviderExtension` class:

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

Here’s what this code does:

1.  Checks if an item already exists at the specified URL to prevent requesting the same data again. In a real world case use, you should check modification dates and file versions to be sure that you have the latest data. However, there is no need to do that in this tutorial since it doesn’t support versioning.
2.  Obtains the `MediaItemReference` for the associated `URL` so you know which file you need to fetch from the back end.
3.  Extracts the name and path from the reference to request the file contents from the back end.
4.  Fails if there was an error downloading the file.
5.  Moves the file from its temporary download directory into the document storage URL specified by the extension.

Build and run. After opening the extension, select an item to view the full version.

![A full image is loaded.](https://koenig-media.raywenderlich.com/uploads/2019/01/07-full-doughnut-281x500.png)

As you open more files the extension will need to handle the removal of the downloaded files. The File Provider extension has this feature built in.

You must override `stopProvidingItem(at:)` to clean up the file as well as provide a new placeholder for it. Add the following at the bottom of the `FileProviderExtension` class:

```swift
override func stopProvidingItem(at url: URL) {
  try? fileManager.removeItem(at: url)
  try? providePlaceholder(at: url)
}
```

This removes the item, and calls `providePlaceholder(at:)` to generate a new placeholder.

That completes the most basic functionality of the File Provider. File enumeration, thumbnail previews, and viewing the file content are the essential components of this extension.

Congratulations, the File Provider is complete and functional!

## Where to Go From Here?

You now have an app with a working File Provider extension. The extension can enumerate and view items from a back end.

You can download the completed version of the project using the **Download Materials** button at the top or bottom of this tutorial.

Learn about more actions you can implement for your File Provider in [Apple’s Documentation about File Providers](https://developer.apple.com/documentation/fileprovider). You can also add custom UI to the File Provider using another extension and you can read more about that [here](https://developer.apple.com/documentation/fileproviderui).

Checkout this tutorial on [Document-Based Apps](https://www.raywenderlich.com/5244-document-based-apps-tutorial-getting-started) if you’re interested in more ways to work with files on iOS.

I hope you enjoyed this tutorial! If you have any questions or comments, please join the discussion below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
