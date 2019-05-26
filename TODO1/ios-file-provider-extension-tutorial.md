> - 原文地址：[iOS File Provider Extension Tutorial](https://www.raywenderlich.com/697468-ios-file-provider-extension-tutorial)
> - 原文作者：[Ryan Ackermann](https://www.raywenderlich.com/u/naturaln0va)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ios-file-provider-extension-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ios-file-provider-extension-tutorial.md)
> - 译者：
> - 校对者：

# iOS File Provider Extension Tutorial

In this tutorial, you will learn about the File Provider framework and how to implement your own File Provider extension to expose your app’s own content.

First introduced in iOS 11, a File Provider extension provides access to content managed by your app via the iOS **Files** app. Additionally, other apps can access your app’s data by using either the [`UIDocumentBrowserViewController`](https://developer.apple.com/documentation/uikit/uidocumentbrowserviewcontroller) or [`UIDocumentPickerViewController`](https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller) classes.

The main tasks of a File Provider extension are to:

*   Create file placeholders that represent the remote content.
*   Intercept reads from the host app so that the documents can download or update.
*   Fire a notification after an update to a document occurs so that the changes can upload to the remote server.
*   Enumerate the stored documents and directories.
*   Perform actions on a document such as renaming, moving, or deleting.

You’ll use a [Heroku Button](https://blog.heroku.com/heroku-button) to configure the server that hosts your files. Once the server setup completes, you’ll configure the extension to enumerate the contents of the server.

## Getting Started

To get started, click the **Download Materials** button at the top or bottom of this tutorial. In the downloaded folder, navigate into the **Favart-Starter** folder and open **Favart.xcodeproj** in Xcode. Make sure you’ve selected the **Favart** scheme, then build and run the app, and you’ll see the following:

![The container app for your File Provider.](https://koenig-media.raywenderlich.com/uploads/2019/01/01-container-app-281x500.png)

The app presents a basic view that educates the user about how to enable the File Provider extension since you won’t actually be doing anything within the app itself. Each time you build and run the app in this tutorial, you’ll then return to the home screen and open the **Files** app to access your extension.

> **Note**: If you want to run the sample project on a real device, in addition to setting a development team for both targets, you must edit **Favart.xcconfig** inside the **Configuration** folder. Update the bundle identifier to a unique value.
>
> The sample project uses this value for the `PRODUCT_BUNDLE_IDENTIFIER` build setting in both targets as well as the App Group identifier in **Provider.entitlements** and the associated `NSExtensionFileProviderDocumentGroup` value in **Info.plist**. If you don’t keep the values updated consistently in the project, you might see obscure and hard to debug errors. Using custom build settings is a great way to keep things running smoothly.

The sample project includes the basic components that you’ll use for your File Provider extension:

*   **NetworkClient.swift** contains a network client for talking to the Heroku server.
*   **FileProviderExtension.swift** has the File Provider extension itself.
*   **FileProviderEnumerator.swift** contains the enumerator, which is used to list the contents of a directory.
*   **Models** is a group that contains the models needed to complete the extension.

## Setting Up the Back End With Heroku

To get started, you’ll need your own instance of the back end server. Fortunately, this is easy with a **Heroku Button**. Click the button below to access the **Heroku** dashboard.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/naturaln0va/favart-api/tree/master)

After you either sign up for a free account or sign in to **Heroku**, you’ll end up on a page similar to the following.

![Deploy to Heroku](https://koenig-media.raywenderlich.com/uploads/2019/01/03-backend-deploy-setup.png)

On this page, there is an option to name your application. You may choose a name, or **Heroku** will generate a name for you if you leave the field blank. Since there are no other configurations to worry about, click the **Deploy app** button and after a few moments, your back end will be up and running.

![Deploy successful](https://koenig-media.raywenderlich.com/uploads/2019/01/02-backend-deploy-success.png)

Once Heroku finishes deploying the application, click the **View** button at the bottom. This will take you to the URL that hosts your instance of the back end. At the root of the application, you should see a JSON message reading the familiar **Hello world!**.

Finally, you need to copy the URL of your **Heroku** instance. You only want the domain portion, which should look like this: **{app-name}.herokuapp.com**.

In the starter project, open **Provider/NetworkClient.swift**. Towards the top of the file, you should see a warning telling you to **Add your Heroku URL here**. Remove the warning and replace the `components.host` placeholder string with your URL.

That completes the server configuration. Next, you’ll define the model which the File Provider relies on.

## Defining an NSFileProviderItem

First, the File Provider needs a model that conforms to `NSFileProviderItem`. This model will provide information about files managed by the File Provider. The starter project contains `FileProviderItem` in **FileProviderItem.swift** you’ll use for this, but it requires a bit of work before you conform to the protocol.

While this protocol has twenty seven properties, only four are required. The optional properties provide the File Provider framework with more detailed information about each file and enable other capabilities. For this tutorial, you’ll focus on the required properties: `itemIdentifier`, `parentItemIdentifier`, `filename` and `typeIdentifier`.

`itemIdentifier` provides a uniquely identifiable key for the model. The File Provider uses `parentIdentifier` to keep track of its place in the extension’s hierarchy.

`filename` is the item’s name as displayed in the **Files/em> app<. finally>typeIdentifier is the [uniform type identifier](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_intro/understand_utis_intro.html), or UTI, for the item.**

Before `FileProviderItem` can conform to `NSFileProviderItem`, it needs a way to work with the data coming from the back end. `MediaItem` defines a simple model that returns from the back end. Instead of using this model directly inside `FileProviderItem`, `MediaItemReference` will handle some additional logic for the extension to bridge the gap.

You’ll use `MediaItemReference` in this tutorial for two reasons:

1.  The back end hosted on Heroku is simple. It can’t provide all of the information required by `NSFileProviderItem` so you need to get it elsewhere.
2.  The File Provider extension is also going to be simple. A more complete File Provider extension would need to persist the information returned by the back end locally, using something like Core Data, in order to refer to it later in the extension’s lifecycle.

To keep the focus of the tutorial on the File Provider extension itself, you’ll use `MediaItemReference` to **cheat** by embedding the data for the four required properties into a `URL` object. You’ll then base64-encode that URL into a `NSFileProviderItemIdentifier`. You won’t need to persist anything yourself because `NSFileProviderExtension` will handle it for you.

To start constructing the model open **Provider/MediaItemReference.swift** and add the following in `MediaItemReference`:

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
  let pathComponents = path.components(separatedBy: "/").filter {
    !$0.isEmpty
  } + [filename]
  
  var absolutePath = "/" + pathComponents.joined(separator: "/")
  if isDirectory {
    absolutePath.append("/")
  }
  absolutePath = absolutePath.addingPercentEncoding(
    withAllowedCharacters: .urlPathAllowed
  ) ?? absolutePath
  
  self.init(urlRepresentation: URL(string: "itemReference://\(absolutePath)")!)
}
```

Here’s what you did:

1.  For this tutorial, a URL will represent most of the information needed for the `NSFileProviderItem`.
2.  This computed property determines if the current item is the root of the file system.
3.  You made this initializer private to prevent usage from outside the model.
4.  You’ll use this initializer when reading the data from the back end. You assume that if the filename doesn’t contain a period it must be a directory, since the initializer can’t infer its type.

Before adding the final initializer, replace the import statement at the top of the file with the following:

```swift
import FileProvider
```

Next, add the following initializer below the previous code:

```swift
init?(itemIdentifier: NSFileProviderItemIdentifier) {
  guard itemIdentifier != .rootContainer else {
    self.init(urlRepresentation: URL(string: "itemReference:///")!)
    return
  }
  
  guard 
    let data = Data(base64Encoded: itemIdentifier.rawValue),
    let url = URL(dataRepresentation: data, relativeTo: nil) 
    else {
      return nil
  }
  
  self.init(urlRepresentation: url)
}
```

Most of the extension will use this initializer. Take note of the scheme `itemReference://`. You handle the root container identifier separately to ensure its URL path is properly set.

For the other items, the URL representation is retrieved by converting the raw value of the identifier to base64-encoded data. The information in the URL comes from the network request that first enumerated the instance.

Now that the initializers are out of the way, it’s time to add some properties to this model. First, add the following `import` at the top of the file:

```swift
import MobileCoreServices
```

This provides access to file types. Next, add the following at the end of the struct:

```swift
// 1
var itemIdentifier: NSFileProviderItemIdentifier {
  if isRoot {
    return .rootContainer
  } else {
    return NSFileProviderItemIdentifier(
      rawValue: urlRepresentation.dataRepresentation.base64EncodedString()
    )
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
  let unmanaged = UTTypeCreatePreferredIdentifierForTag(
    kUTTagClassFilenameExtension,
    pathExtension as CFString,
    nil
  )
  let retained = unmanaged?.takeRetainedValue()
  
  return (retained as String?) ?? ""
}

// 3
var parentReference: MediaItemReference? {
  guard !isRoot else {
    return nil
  }
  return MediaItemReference(
    urlRepresentation: urlRepresentation.deletingLastPathComponent()
  )
}
```

Keep in mind:

1.  `itemIdentifier` must be unique per item managed by the FileProvider. If the item reference is the root, then it uses `NSFileProviderItemIdentifier.rootContainer`. If not, it creates an identifier from the reference’s URL.
2.  Here it creates an identifier based on the path extension of the URL. The odd looking `UTTypeCreatePreferredIdentifierForTag` is a C function that returns a UTI type for a given input.
3.  When working in a directory structure, it’s useful to reference the parent. This represents the folder that contains the current reference. It’s optional because the root reference doesn’t have a parent.

You added a few additional properties here that don’t require much explanation but will be useful when creating a `NSFileProviderItem`. With that, the reference model is complete. It’s time to hook everything up in `FileProviderItem`.

Open **FileProviderItem.swift** and add the following at the top of the file:

```swift
import FileProvider
```

Then, add the following to the bottom of the file, outside the class implementation:

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

`FileProviderItem` now conforms to `NSFileProviderItem` and implements all required properties. Going through the code:

1.  Most of the required properties simply map over logic you previously added to `MediaItemReference`.
2.  `NSFileProviderItemCapabilities` indicates what actions can be taken on the item in the document browser – such as reading and deleting. For this app, you only need to allow reading and enumerating directories. In a real-world use case, you’d likely use the `.allowsAll` capability since a user would expect all actions to work.
3.  This tutorial won’t use the document size, but it’s included to prevent a crash in `NSFileProviderManager.writePlaceholder(at:withMetadata:)`. This is likely a bug with the framework, and fortunately, a typical app’s File Extension would provide a `documentSize` anyway.

That’s it for the model. `NSFileProviderItem` has more properties, but what you’ve implemented will suffice for this tutorial.

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
override func urlForItem(withPersistentIdentifier
  identifier: NSFileProviderItemIdentifier) -> URL? {
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
guard 
  let identifier = persistentIdentifierForItem(at: url),
  let reference = MediaItemReference(itemIdentifier: identifier) 
  else {
    throw FileProviderError.unableToFindMetadataForPlaceholder
}
 
// 2
try fileManager.createDirectory(
  at: url.deletingLastPathComponent(),
  withIntermediateDirectories: true,
  attributes: nil
)

// 3  
let placeholderURL = NSFileProviderManager.placeholderURL(for: url)
let item = FileProviderItem(reference: reference)
  
// 4
try NSFileProviderManager.writePlaceholder(
  at: placeholderURL,
  withMetadata: item
)
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

guard 
  let ref = MediaItemReference(itemIdentifier: containerItemIdentifier),
  ref.isDirectory 
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
  
override func fetchThumbnails(
  for itemIdentifiers: [NSFileProviderItemIdentifier],
  requestedSize size: CGSize,
  perThumbnailCompletionHandler: 
    @escaping (NSFileProviderItemIdentifier, Data?, Error?) -> Void,
  completionHandler: @escaping (Error?) -> Void) 
    -> Progress {
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

    guard 
      let reference = MediaItemReference(itemIdentifier: itemIdentifier),
      !reference.isDirectory 
      else {
        progress.completedUnitCount += 1

        let error = NSError.fileProviderErrorForNonExistentItem(
          withIdentifier: itemIdentifier
        )
        itemCompletion(nil, error)
        continue
    }

    let name = reference.filename
    let path = reference.containingDirectory

    // 3
    let task = NetworkClient.shared
      .downloadMediaItem(named: name, at: path) { url, error in
        guard 
          let url = url,
          let data = try? Data(contentsOf: url, options: .alwaysMapped) 
          else {
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

override func startProvidingItem(
  at url: URL, 
  completionHandler: @escaping ((_ error: Error?) -> Void)) {
  // 1
  guard !fileManager.fileExists(atPath: url.path) else {
    completionHandler(nil)
    return
  }

  // 2
  guard 
    let identifier = persistentIdentifierForItem(at: url),
    let reference = MediaItemReference(itemIdentifier: identifier) 
    else {
      completionHandler(FileProviderError.unableToFindMetadataForItem)
      return
  }

  // 3
  let name = reference.filename
  let path = reference.containingDirectory
  NetworkClient.shared
    .downloadMediaItem(named: name, at: path, isPreview: false) { fileURL, error in
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
