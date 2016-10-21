> * 原文地址：[25 Core Data in iOS10: NSPersistentContainer](https://swifting.io/blog/2016/09/25/25-core-data-in-ios10-nspersistentcontainer/)
* 原文作者：[Michał Wojtysiak](https://swifting.io/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者： [Gran](https://github.com/Graning), [Wenlin Ou(owenlyn)](https://github.com/owenlyn)

# iOS 10 中的 NSPersistentContainer

Xcode 8 已经面世了，如果你还没有尝试过这个测试版本，你将会发现各种新东西。这里有 Swift 3 [主要的更新](https://swifting.io/blog/2016/08/17/22-swift-3-access-control-beta-6?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post)，有新的框架，比如 [SiriKit](https://swifting.io/blog/2016/07/18/20-sirikit-can-you-outsmart-provided-intents?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post) 和一些对现存特性的增强改进，比如 [notifications](https://swifting.io/blog/2016/08/22/23-notifications-in-ios-10?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post)。 我们也接收以 `NSPersistentContainer` 形式的简化版的 `Core Data stack`，它为我们做了大部分的准备工作。它值得我们去尝试么？让我们开始深入挖掘这些新特性吧。

#### `iOS 10` 之前的 `Core Data stack` 

多年来，在尝试了很多种 `Core Data stack` 之后，我们选定了两个简单的 `stack`，融合成一个使用。让我们仔细看一下这些关键组件并开始连接使用他们。完整版本的 `Github` 链接在引用中能找到。代码已经适配到 `Swift 3` 和 `Xcode 8`。 

```
final class CoreDataStack {
    static let sharedStack = CoreDataStack()
    var errorHandler: (Error) -> Void = {_ in }
    
    private init() {
    #1
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CoreDataStack.mainContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.managedObjectContext)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CoreDataStack.bgContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.backgroundManagedObjectContext)
 
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    #2
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    #3
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    #4
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("DataModel.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                         NSInferMappingModelAutomaticallyOption: true])
            } catch {
                // Report any error we got.
                NSLog("CoreData error \(error), \(error._userInfo)")
                self.errorHandler(error)
            }
        return coordinator
    }()
    
    #5
    lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = coordinator
        return privateManagedObjectContext
    }()
    
    #6
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = coordinator
        return mainManagedObjectContext
    }()
    
    #7
    @objc func mainContextChanged(notification: NSNotification) {
        backgroundManagedObjectContext.perform { [unowned self] in
            self.backgroundManagedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
    
    @objc func bgContextChanged(notification: NSNotification) {
        managedObjectContext.perform{ [unowned self] in
            self.managedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
}
```


上面是啥？且容我慢慢道来。

##### #1

在初始化的时候，我们订阅了从主线程和后台线程 `NSMagedObjectContext` 发送来的通知。

##### #2

获取文档路径 `NSURL` 的 `getter`。`NSPersistentStoreCoordinator` 使用它在给定的位置创建 `NSPersistentStore`。  

##### #3

和文件目录相似，他获得 `NSManagedObjectModel` 的 `getter` 方法，用它来初始化有我们模型的 `NSPersistentStoreCoordinator`。

##### #4

这就是这些神奇的代码干的事情。首先，我们创建有模型的 `NSPersistentStoreCoordinator`。之后，我们获取我们文档目录的 `url`。最后，我们在这些文档目录内为某些类型的 `NSPersistentStoreCoordinator` 增加一个持久化的存储。

##### #5

我们在一个私有队列里创建一个'后台' `NSManagedObjectContext` 并且把它绑定到 `NSPersistentStoreCoordinator`。这个 `context` 被用于执行同步和写操作。 

##### #6

我们在主队列中创建一个'视图' `NSManagedObjectContext`并且把它绑定到我们的 `NSPersistentStoreCoordinator`。这个 `context` 被用于获取显示在 `UI` 上的数据。  

##### #7

这个 `stack` 使用了稳定、成熟的融合过的 `contexts`，它被保存的 `notifications` 驱动。在这些方法中，我们执行这个融合。

#### `NSPersistentContainer` 简介

iOS 10 给我们提供了 `NSPersistentContainer`。它意图简化代码并且为我们解决负担。它能做到么？让我展示给你我们基于 `NSPersistentContainer` 重建 `CoreData stack` 。 一个**完整**的例子:

```
final class CoreDataStack {
 
    static let shared = CoreDataStack()
    var errorHandler: (Error) -> Void = {_ in }
    
    #1
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(error._userInfo)")
                self?.errorHandler(error)
            }
            })
        return container
    }()
    
    #2
    lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    #3
    // Optional
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    #4
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    #5
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
}
```
实际上这个更简短。但是之前版本的代码发生了什么？

简单的答案是，`NSPersistentContainer` 已可以为我们代劳。对于一个博客文章的解释，这肯定不够 😆 。还是容我慢慢道来。

##### #1

这里，我们能看到 `NSPersistentContainer` 的能力。它完成了之前 `stack` 内#2, #3, #4, #5, #6 的工作，并一定程度上把我们从 #1 和 #7 中的工作中解放出来。 

怎么做到的？

首先，它通过一个名字来初始化，这个名字被用于在文档目录中查找一个模型并且用相同的名字创建一个存储器。这是一个快捷初始器。你也可以使用完整的版本，手动地传递你的模型。


    public init(name:String,managedObjectModel model:NSManagedObjectModel)


之后，在调用 `loadPersistentStores` 方法之前，你还有时间来进一步配置你的容器，例如，使用 `NSPersistentStoreDescription`。我们使用一个默认的 `SQLite` 数据库，所以我们装载自己的永久存储器并且确保错误处理。

##### #2

实际上这只是一个封装器。已经通过 `NSPersistentContainer` 为我们创建了 `viewContext`。而且，它已经被配置成可以接收从其他的 `contexts` 来的保存通知。引用自 `Apple` 公司:

> 这个被管理的 `context` 对象与主队列有关。（只读）... 这个 `context` 是被配置成可持续的，并且从其他 `contexts` 处理保存的通知。

##### #3

`NSpersistentContainer` 也给予了我们一个工厂方法，它用来创建多个私有队列的 `contexts`。我们为了复杂的同步目的，在这里仅使用一个，常见的后台 `context`。由工厂方法创建出的 `Contexts` 也被设定成可自动地接收和处理 `NSManagedObjectContextDidSave` 的广播消息。
这是可选项。

##### #4

`NSPersistentContainer` 在后台（详情可见 #5）为运行 `Core Data stack` 暴露了一个方法。我们非常喜欢这个 `API` 的命名，所以我们也为 `viewContext` 创建了类似的封装器。

##### #5

正如上文提到的，这仅是一个有关 `performBackgroundTask` 方法的封装器，它是 `NSPersistentContainer` 中的一个方法。每一次它调用一个新的 `context`， `parivateQueueConcurrencyType` 也被创建。

**注意:** 我们已讨论了大部分 `NSPersistentContainer` 的特性，但是你也可以查看[参考资料](https://developer.apple.com/reference/coredata/nspersistentcontainer?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post)，去查阅完整的内容。

### 如果 `NSPersistentContinainer` 对我来说还是太庞大？

有一些可选项。

首先，确保查阅了完整的参考资料，并且在寻找你所需要的属性或者方法。我们已经涵盖了两个初始化器，一个仅需要字符串名和完整采用 `NSManagedObjectModel` 的快捷方法。

之后，你可以调查扩展或者子类。举个例子，在我们其中一个项目中，我们在核心程序和扩展程序之间共享了一个 `Core Data stack`。它不得不落地在一个 App 共享组群空间中，并且 `NSPersistentContainer` 默认的文档目录已经不再为我们所用。

幸运的是，通过一个轻量的子类 `NSPersistentContainer`，我们又满血复活了，并且能继续使用那些容器类带来的好处。

```
struct CoreDataServiceConsts {
    static let applicationGroupIdentifier = "group.com.identifier.app-name"
}
 
final class PersistentContainer: NSPersistentContainer {
    internal override class func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        if let newURL =
            FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: CoreDataServiceConsts.applicationGroupIdentifier) {
            url = newURL
        }
        return url
    }
}
```

#### 总结 & 参考文献

我希望你们喜欢这篇有关 `NSPersistentContainer` 的简短精干的文章，并且我们也希望看到你们是如何通过这些在 `Core Data` 框架上的改进来演进你们的 `Core Data stack`。

稍等一下... 啊？还有其他的改变么？

是的，当然有。最佳的方法是通过 `Apple` 公司的官方推文 'Core Data 在 iOS 10 上的新特性'。这些改变从并发、`context` 版本、请求获取、自动融合来自父 `context` 变化等开始，以在 `macOS 10.12` 中的 `NSFetchResultsController` 结束。

作者: Michał Wojtysiak

