> * 原文地址：[NSFetchedResultsController Woes](https://medium.com/bpxl-craft/nsfetchedresultscontroller-woes-3a9b485058#.5gva2sils)
* 原文作者：[Michael Gachet](https://medium.com/@6Be)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：[Gran](https://github.com/Graning) ，[cbangchen](https://github.com/cbangchen)

# 一些 NSFetchedResultsController 使用报错解决方案

### NSFetchedResultsController 困境

_NSFetchedResultsController_ 是关于 iOS 的 Core Data 开发的一个主要部分。自 iOS 3系统开始引入这个类之后，这个类就负责高效的管理 Core Data 实体的集合。


在过去的六年里，我使用这个控制器，并为它设置了[各种类型的 Core Data  栈配置](https://medium.com/bpxl-craft/thoughts-on-core-data-stack-configurations-b24b0ea275f3)来管理我所有的项目。最近，在为 Black Pixel 的一个大客户制作的项目上，我们决定使用一个标准的 “sibling”（同级）Core Data 栈配置：


*   一个 _NSFetchedResultsController_ 被用来从主要 UI context 的存储器里获取对象。这个主要的 context 过去只被用来从存储器里读取内容。
*   后台 context，它被用来从服务器端获取实体，被连接到跟主要 UI context 同级的持久化存储协调者上。
*   主要 context 被设置成这样的状态————每当后台 context 存储变化到存储器的时候，主要 context 都会自动合并来自后台 context 的变化。

出乎我的意料，我最终遇到了一些奇怪的问题即 the_NSFetchedResultsController_ 有时和存储器里的内容不同步，这导致了一些存在的符合 _NSFetchedResultsController_ 过滤条件的实体却永远无法获取到。

这么基础的问题是怎么发生的呢？


#### 一些解释和解决措施。

一次快速的谷歌搜索获得一些答案。一个特别的答案对[ _NSFetchedResultsController_ 是怎么出错的](http://stackoverflow.com/questions/16296364/nsfetchedresultscontroller-is-not-showing-all-results-after-merging-an-nsmanage?lq=1)提供一份详细的解释.这里是给出的解释（备注: FRC = _NSFetchedResultsController_ ）
> 1\. 一个 FRC 设置的过滤条件并不能匹配所有的对象（这样可以避免不符合过滤条件的对象被注册到 FRCs context 里）

> 2\.第二个 context 使一个对象做产生了一个变化，这意味着它现在符合FRC的过滤条件。第二个 context 被保存下来。

> 3\. FRC context 处理 _NSManagedObjectContextDidSaveNotification_ 的方法只是更新它已经注册过的对象。所以，FRC 无法更新现在符合FRC过滤条件的对象。

> 4\. 当有一个保存发生时，FRC 不进行再一次的抓取，所以它意识不到更新了的对象应该被包括在内。


我被上面的第三点陈述所困扰。

下面是提出的解决措施：

> 这个解决措施就是当合并消息通知的时候抓取所有的更新对象。

这个措施是在 _NSManagedContextDidSaveNotification_ _userInfo_ 包含的每一个更新对象上调用 _refreshObject(_:mergeChanges:)_ 方法。

另外一些解释（举个例子，“[Core Data Gotcha](http://www.mlsite.net/blog/?p=518)” 和“[NSFetchedResultsController with predicate ignores changes merged from different NSManagedObjectContext](http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different?lq=1)”两篇文章提到当 _NSManagedContextDidSaveNotification_ 被触发时，上下文中的某些对象可能是错误的对象，需要在调用 _mergeChangesFromContextDidSaveNotification_ 方法之前被移除。）

这里的解决方法是在 _NSManagedContextDidSaveNotification_ _userInfo_ 包含的每一个更新对象上调用 _willAccessValueForKey(nil)_ 方法，然后调用 _mergeChangesFromContextDidSaveNotification()_ 方法。


#### 深度调查的时间

当这个项目进行到关键时候，我采用了第一个解决方案，它解决了一系列的新问题，但是始终没有让我满意。我想要理解究竟是什么地方出了问题并且验证一些我正在阅读的令我烦恼的主张。

这些研究的目的是：

*   指出当变化从一个 context 被合并到另一个 context 的时候正在发生些什么：在目标 context 里的是什么？在通知集合里的是什么？
*   指出在什么情况下 _NSFetchedResultsController_ 会表现的与预期不符。
*   改善提出的各种解决方法。

### 研究设置

这个研究使用一个单机的 iOS 应用进行，它按照如下内容进行设置：

#### Core Data栈

这个 Core Data 栈是一个非常基础的 _“sibling”_ 栈，它有着以下内容：

*   一个主要的 context（_MainQueueConcurrencyType_）被用作只读的 context 。
*   一个后台 context (_PrivateQueueConcurrencyType_) 可以读写.


主要 context 和后台 context 是同级关系并且都直接连接到 _NSPersistentStoreCoordinator_ 上。当在后台存储变化的时候，这些变化通过调用 _mergeChangesFromContextDidSaveNotification() 方法被自动合并到主要 context 。

#### Core Data模型

我们使用一个包含一个单独实体 _TestDummy_ 的简单模型，它有三个属性：_id: Int_ , _name: String_, _isEven: Bool_.

#### UI和主要视图控制器

我们有一个单独的视图控制器，它有在 Core Data 栈获得两个 context 的权限并且允许其中的一个有以下的功能：

*   在后台 context 中插入，更新，删除对象。
*   保存主要 context 和后台 context。
*   展示被 _NSFetchedResultsController_ 的两个实例获取的两个 context 的对象信息.

这个控制器也负责控制在主要 context 里 _NSManagedObjectContextDidSaveNotification_ 消息是如何被接收的。默认设置是除了 _mergeChangesFromContextDidSaveNotification()_ 方法调用以外什么都不会发生。

#### NSFetchedResultsController

两个 FRC 的实例被主要视图控制器管理：


*   一个实例在主要 UI context 中获取所有的 _TestDummy_ 对象。这个实例被称为“主要 FRC”。
*   一个实例在后台 context 中获取所有的 _TestDummy_ 对象。这个实例被称为“后台 FRC”。

主要 context FRC 可以使用两个过滤条件：要么获取所有 _TestDummy_ 实体要么只是把那些实体标记 _isEven_ == _true_。

### 让我们把他们全部拿到！


我们开始设置主要 FRC 来获取所有的 _TestDummy_ 实体，然后我们观察在后台 context 发生的三个不同场景：插入，更新和删除。

#### 插入对象


我们进行了下面的简单测试：


1.  在后台 context 中插入4个实体。
2.  保存后台 context。

插入操作导致了下面的情况：


1.  后台的 _insertedObjects_ 属性内容在保存操作之前与 _registeredObjects_ 的属性内容是匹配的。
2.  后台FRC获取的对象与 _registeredObjects_ 集合是匹配的。

正如预期的那样，在后台 context 保存的所有变化被推送到主要 context ：

1.  主要 context 与后台 context 中的 _registeredObjects_ 内容应该是完全一样的.
2.  主要 FRC 获取到的对象应该与主要 context 中的 _registeredObjects_ 集合相匹配。
3.  主要 FRC 通知它的 _delegate_ 插入操作已经发生了。

顺便需要注意的是：保存后台 context 会把后台 context 的 _insertedObjects_ 集合重置为 _nil_ 。

#### 更新对象

想要理解更新对象的时候发生了什么需要我们更深入的研究，看下面两个交替的场景。


**场景 #1**

1.  在后台 context 中插入四个实体。
2.  改变实体0和实体2的 _isEven_（从 _false_ 改为 _true_ ）和 _title_ 属性参数，然后更新它们。
3.  保存后台 context 。

**场景 #2**

1.  在后台 context 插入4个实体。
2.  保存后台 context。
3.  像以前一样更新实体0和实体2。

**结果**

考虑到 Core Data，在保存后台 context 之前已经被插入并更新的对象被视作已插入。这意味着如果你检查后台 context 的 _updatedObjects_ 集合，在收到变化通知之前它都是空的（在更新之后，它不会是空的）。这是我们预料到的结果，但是它还是让我们有些惊讶。


第二个场景更加直接。由于对象在被更新之前已经被保存下来，它们将在后台的 _updatedObjects_ 集合中出现。这是和我们预期相一致的。

主要的 FRC 再次表现的跟预期的相一致：它获取到所有的实体并且正确的通知了它的 _delegate_。

#### 删除对象

删除操作我们也需要看两个不同的场景。但是，这个删除操作的例子不像插入和更新那么有趣，直到涉及到主要 FRC 。确实如果一个对象被注册到主要 context ，FRC 将会与这个将被删除的对象进行交互。


最有趣的一些发现是：

*   在保存后台 context 之前，进行删除后台 context 对象的操作会把 _deletedObjects_ 集合中的对象删除，
*   在保存变化之后，像我们预料的一样，进行删除对象的操作会把这些对象放入 _deletedObjects_ 集合。
*   后台 context 的 _registeredObjects_ 和 _deletedObjects_ 集合的内容在保存期间可能会有一个短暂的反射状态，所以需要小心使用。
*   主要 context 将包含所有后台 context 产生的变化。 (换言之,  _registeredObjects_ 集合在删除操作之前会包含所有的对象, _deletedObjects_ 集合将包含被删除的对象)。
*   再一次的，主要 FRC 正确的应对了所有变化。


#### 结论和领悟

如果一个 FRC 的 _delegate_ 没有被设置：


*    _fetchedObjects_ 队列将只包含初始化时获取到的对象。
*    当对象变化时或者 FRC 初始化的 context 被保存时，FRC 收不到通知。

如果主要 FRC 的 _delegate_ 被设置了，它将表现的像预期的那样：实体和 FRC 的获取请求相一致。

*   当后台 context 把它的变化合并到主要 context 的时候，在后台 context 中插入、更新或者删除的对象都会被正确的获取（删除）。
*   在后台 context 删除一个持久化对象 (即拥有一个持久化 ID 并保存到存储器的对象)会影响到主要 context ，因为这些对象在主页 context 中注册过。

但是，这些测试是非常特殊的：主要 FRC 被设置获取所有的 _TestDummy_ 实体，这在一个真正的应用中是很少见的。

### 让我们只获取一个子集!

为了让测试变得更加真实，我们进行和之前同样的测试，只是做一些细小的改变。主要 FRC 现在被设置成只获取属性为 _isEven == true__ 的 TestDummy_ 实体。让我们看看发生了什么。


当实体在后台 context 被插入时，_isEven_ 属性被设置成了 _false_。所以，在后台插入对象并保存他们之后，没有实体将被主要 FRC 获取到。但是如果我们按照下面的做法去做会发生什么呢？


*   我们插入符合主要 FRC 的过滤条件的实体？
*   我们更新实体来符合主要 FRC 的过滤条件？

#### 插入匹配的实体


当匹配主要 FRC 的实体在后台 context 里被被插入的时候，在后台 context 保存的时候他们将会被主要 FRC 正确的获取到。

#### 更新实体来匹配主要的 FRC 过滤条件

这个方法有些麻烦。在我们之前的陈述中，更新一个实体会有不同的表现，这取决于这个实体是否已经被保存了。

*  如果这些实体在后台 context 中被插入，更新了来匹配主要 FRC 的过滤条件，然后被保存，这个主要 FRC 将会获取到这些实体。所有的都表现的仿佛那些实体已经被插入来匹配最开始的过滤条件。
*   另一方面，如果实体被插入了，保存了，然后被更新来匹配主要 FRC 过滤条件， **他们将无法被主要 FRC 获得**。

#### 看看潜在的解决方案

我们能想到四种方法来应对这个问题，在这一节我们将一一讨论。

#### 改变栈配置


记住这个方案是应用于这样的配置环境：当后台 context 中发生变化后，这些变化会被推送到持久化存储协调者中，然后被合并到主要 context 。

切换到另一种配置，后台 context 把它的变化写入主要 context 来替代上面的操作，这可以根除 FRC 的这个问题。这是这个问题的一个彻底解决方法。确实，把堆重新配置成“父子”模式是一种改变管理的完全不同的架构方法，这也带来一些问题：

*   “父子”模式的配置导致大量的数据流通需要通过主要 context 进行。当获取和保存的操作发生时，他们将会堵塞主要 context 线程。
*   你需要处理那些临时的对象 ID 直到这些对象被存入持久化存储器。或者，当在后台 context 插入对象 ID 时，你需要请求获取持久化对象 ID 。但是，这会带来一些性能上的损耗。

*   对于合并后台 context 和主要 context 的冲突你控制的权限变得更少了。

#### 刷新主要 context 中的对象


**典型实现**这个方法是：当在主要 context 中处理 _NSManagedObjectContextDidSaveNotification_ 通知队列时，调用 _refreshObjects(mergeChanges:)_ 方法来更新对象。

这些实现方式通常是刷新所有消息队列中的已经更新的对象。

**优势**

*  实现简单
*   在一个 _NSManagedContext_ 扩展里集中的管理实现是可能的。
*   我们可以选择缺页设置( _mergeChanges = false_ ) 或者合并设置 ( _mergeChanges = true_ )。


**缺陷**

*   我们需要子每个独立的对象中调用这个方法，每一个都会造成 FRC 的更新。这很容易造成一个性能瓶颈。任何之前已经用 FRC 注册过的更新对象都需要被更新两次。
*  我们使用故障设置 _mergeChanges = false 来设置所有的主要 context 中的对象. 如果那些对象被  FRC 提及到，那么内存缺页将立刻失效。这导致被已经更新的 FRC 获取的完整对象集合会有三次更新: 一次是默认的 FRC 更新机制中的一部分，一次是由于强制的刷新，一次是当默认设置失效的时候。
*   还是故障设置 _mergeChanges = false_ 的问题,在 context 中不在内存中的对象会造成负面的影响。所有的关系都是缺失的，这意味着任何指向那些不在内存中的对象的引用和那些不在内存中的对象关联的引用都变得无效。这在很大程度上增加了管理的难度。你想要获取的最后一个对象是一个无法管理的对象，当你尝试去控制它的时候，你的应用就会崩溃。
*  选择合并设置 _mergeChanges = true_, 你把存在的对象保存在内存中，但是这样却把持久化存储器里值的变化全部覆盖掉了(即那个情况下的后台 context )。 如果你采取强硬的方法让你的主要 context 只读，强制性的把所有的变化唯一的应用到后台 context 中，这可能是起作用的。 
*  我们需要选择是设置成 _mergeChanges = false_ 或者是 _mergeChanges = true_。


**_NSManagedObjectContext_ 拓展和应用的典型例子**

```
public extension NSManagedObjectContext {

    func addContextDidSaveNotificationObserver(center: NSNotificationCenter, handler: NSNotification -> ()) -> NSObjectProtocol {
        return center.addObserverForName(NSManagedObjectContextDidSaveNotification, object: self, queue: nil) { notification in
            handler(notification)
        }
    }

    func performMergeChangesFromContextDidSaveNotification(notification: NSNotification) {
        self.performBlock {
            self.mergeChangesFromContextDidSaveNotification(notification)
            guard let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<nsmanagedobject> else {
                return
            }
            updatedObjects.map({ $0.objectID }).forEach { objectID in
                guard let object = try? self.existingObjectWithID(objectID) else {
                    return
                }
                self.refreshObject(object, mergeChanges: false)
            }
        }
    }
}

// Prototype of a CoreDataStack class to illustrate how you could use the `NSManagedObjectContext` extension methods
class CoreDataStack {
    var mainContext: NSManagedObjectContext
    var backgroundContext: NSManagedObjectContext

    var backgroundObserver: NSObjectProtocol?

    deinit() {
        if let backgroundObserver = self.backgroundObserver {
            NSNotificationCenter.defaultcenter().removeObserver(backgroundObserver)
        }
    }

    init() {
        //....  
        // A bunch of initialization code here where you define backgroundContext and mainContext
        //....

        // Somewhere else in your code you would register your main context to listen to `NSManagedObjectDidChangeNotification` 
        // coming from the background context like so
        backgroundObserver = backgroundContext.addContextDidSaveNotificationObserver(
            NSNotificationCenter.defaultcenter(),
            handler: processBackgroundContextDidSaveNotification
        )
    }

    private func processBackdroundContextDidSaveNotication(notification: NSNotification) {
        mainContext.performMergeChangesFromContextDidSaveNotification(notification)
    }
}
```

#### 改善 refreshObject(_, mergeChanges:) 方法

一个在主要 context 中无差别刷新所有更新对象的全局实现，它的主要缺点是它会刷新那些被主要 FRC 完美管理的对象。


直接拥有 _NSManagedObjectDidSaveNotification_ 的 FRC 注册是一个明显的更优雅的方式，它使用与之前相同的机制。通过这样做，我们可以限制我们对以下对象的刷新调用：

*   还没有在主要 context 注册的。
*   与 FRC 的 _fetchRequest_ 属性相符的。(即它的实体和过滤条件，如果定义了的话).


**优势**

*    _NSFetchedResultsController_ 拓展的一个简单实现。
*   指定没有注册过的和只对 FRC 透露细节的对象作为刷新对象的能力。
*   更好的刷新性能。
*   没有关联 FRC 的对象和已经在主要 context 中注册的对象都不会缺失。



**缺点**

主要 FRC 在后台 context 注册保存的位置，后台 context 的引用是需要的。如果你想要在你的应用中隐藏掉这个 context，可能的一个选项就是从你的 Core Data 栈或者其他的拥有两个 context 权限的类中直接去掉 FRC 。

**SNSFetchedResultsController 扩展范例**

```
extension NSFetchedResultsController {
    func registerForCommitsToContext(context: NSManagedObjectContext, notificationCenter: NSNotificationCenter? = nil) -> NSObjectProtocol? {
        guard self.managedObjectContext != context else {
            return nil
        }
        let center = notificationCenter ?? NSNotificationCenter.defaultCenter()
        return  center.addObserverForName(NSManagedObjectContextDidSaveNotification, object: context, queue: nil) { [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            strongSelf.processChangesWithRefreshObjects(notification, mergeChanges: mergeChanges)
        }
    }

    private func insertedOrUpdatedObjectIDsMatchingFetchRequestInNotification(notification: NSNotification) -> Set<nsmanagedobjectid> {
        guard let entity = self.fetchRequest.entity else {
            return []
        }
        let predicate = self.fetchRequest.predicate ?? NSPredicate(value: true)

        // We are only interested in retrieving inserted and updated objects since those may be the one now matching the
        // fetchRequest and which will not be handled properly if they are not already registered in out context
        var matchingObjectIDs : Set<nsmanagedobjectid> = []
        for key in [NSUpdatedObjectsKey, NSInsertedObjectsKey] {
            if let objects = notification.userInfo?[key] as? Set<nsmanagedobject>  {
                let matching = objects.filter({$0.entity == entity && predicate.evaluateWithObject($0)}).map{$0.objectID}
                matchingObjectIDs.unionInPlace(matching)
            }
        }
        return matchingObjectIDs
    }

    private func processChangesWithRefreshObjects(notification: NSNotification) {
        guard let _ = self.fetchRequest.predicate, _ = self.fetchRequest.entity else {
            return
        }
        var matchingObjectIDs = self.insertedOrUpdatedObjectIDsMatchingFetchRequestInNotification(notification)
        self.managedObjectContext.performBlock({
            // We do not want to process objects which are already registered in our context. These objects are fine and already
            // properly tracked by the default change management mechanism
            let registeredObjectIDs = self.managedObjectContext.registeredObjects.map{$0.objectID}
            matchingObjectIDs.subtractInPlace(registeredObjectIDs)

            for matchingObjectID in matchingObjectIDs {
                // Calling `existingObjectWithID` is the right thing to do here: it fetches the objects from the store
                // and brings them into the main context.
                // Note that it is perfectly safe, and even desirable, to get these objects here using the objectID coming from
                // the background context since it will reuse the row cache and make the fetch "faster".
                guard let object = try? self.managedObjectContext.existingObjectWithID(matchingObjectID) else {
                    continue
                }
                // Since we know that the objects we are processing are not part of our context and are new, calling
                // this method with `mergeChanges: false` has no side effects: the object is simply faulted in memory and the 
                // fault will immediately fire since the object matches our fetchRequest.
                self.managedObjectContext.refreshObject(object, mergeChanges: false)
            }
        })
    }
}
```


在这个扩展背后的想法是:

1.  告知每一个 FRC 去监控一个特定 context 的保存过程 (尤其是后台 context )。
2.  当收到监控的 context 的 _NSManagedObjectContextDidSaveNotification_ 时, 检查 FRC 的过滤条件是否过滤出实体。如果没有, 不做任何事. FRC 将像预想的那样工作。
3.  从消息通知队列中取回所有的插入和更新过的实体,只保存符合FRC实体和过滤条件对象的 _objectID_ 。
4.  从这个对象集合中，删除掉所有已经在 FRC context 注册过的对象。被注册过的这些对象将按照默认设置进行正确的管理。
5.  每一个保留的对象都是在被监控的 context 中新插入的并且没有在 FRC 中注册过: 调用 _refreshObject(_, mergeChanges:false)_ 方法。  _mergeChanges:false_ 的设置工作的很完美: 对象不存在与 FRC 的 context，这样的情况下不在内存中的对象也不会带来负面的影响。

#### 调用 willAccessValueForKey(nil) 方法



在 Stack Overflow 上的另外一个典型解决方法是通过调用 _willAccessValueForKey(nil)_ 来替代 _refreshObjects(_, mergeChanges:)_ 方法查询所有的新对象是否在 context 中，然后如果有必要还会调用 _mergeChangesFromContextDidSaveNotification()_ 方法。


再一次，当处理 _NSManagedObjectContextDidSaveNotification_ 消息通知时，这个方法被主要 context 调用，来通知属于消息通知队列一部分的所有更新对象。正如每一个苹果文档所说的：

> 你可以用一个 nil 键值对调用这个方法来确保内存缺页失效。



```
extension NSFetchedResultsController {
    private func processChangesWithWillAccessValueForKey(notification: NSNotification) {
        guard let _ = self.fetchRequest.predicate, _ = self.fetchRequest.entity else {
            return
        }
        var matchingObjectIDs = self.insertedOrUpdatedObjectIDsMatchingFetchRequestInNotification(notification)
        self.managedObjectContext.performBlock({
            let registeredObjectIDs = self.managedObjectContext.registeredObjects.map{$0.objectID}
            matchingObjectIDs.subtractInPlace(registeredObjectIDs)
            for matchingObjectID in matchingObjectIDs {
                guard let object = try? self.managedObjectContext.existingObjectWithID(matchingObjectID) else {
                    continue
                }
                object.willAccessValueForKey(nil)
            }
            if !matchingObjectIDs.isEmpty {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        })
    }
}
```


你可以调用这个方法取代之前定义的 _processChangesWithRefreshObject(_, mergeChanges:)_ 方法。再一次的说明，调用这个方法没有负面影响。

#### 当变化发生时重新获取对象。


这是一个你可能回去尝试实现的一个主意。它包括两个部分：使用相同的 _NSManagedObjectContextDidSaveNotification_ 消息通知检测后台 context 的变化和当有需要时调用 _performFetch()_ 方法。


我们实现了这个方法想看看它是否能工作，因为我们证实了一次刷新所有的对象比一次刷新一个更合理。



但是，我们发现了使用这个方法的一个巨大缺陷：FRC 的 _delegate_ “从来没有”收到变化的通知。新的对象被获取并注册在主要 context ，但是没有对象了解它们。


解决这个问题的一个办法是在调用 _performFetch_ 方法之后调用代理方法它们本身。这个方法足够的简单并且不会影响到 FRC 的 _sections_ 。在这一点上，系统运作的时候需要观测许多东西，就像是 FRC 的追踪变化这个主要特性的重新实现，这样做并不明智。

### 总结

作为一个同级的栈配置（主要 context 和连接到 _persistentStoreCoordinator_ 的私有队列 context ）：

*  在主要 context 获取对象的 _NSFetchedResultsController_ 将只能在后台 context 中获取到插入的对象，在保存后台 context 的时候，被插入的对象符合 _NSFetchedResultsController_ 的过滤条件。
*  如果没有过滤条件，_NSFetchedResultsController_ 将表现的像预想的那样，获取到所有在后台 context 插入的所有相关的实体。
*  如果有过滤条件，_NSFetchedResultsController_ 只能获取到后台插入的对象, 并且这些对象在第一次在后台 context 中保存的时候必须要符合这个过滤条件才可以。
*  如果变化是在第一次保存之后发生的，并且更新的对象没有在主要 context 注册过，那么它们将**永远不会**被获取到。
*  在后台 context 保存对象，在主要 context 中合并变化，在当前线程循环的末尾像文档上记录的那样运作。
*   当处理来自后台 context 的 _NSManagedObjectDidSaveNotification_ 消息通知时，在所有的更新对象上调用 _refreshObject(_:mergeChanges:) 方法， 这个解决方案总是在 Stack Overflow 网站上被提出来，但是这不仅是无效的，还会普遍带来关于内存缺页的问题
*   对比一下，通过在 _NSFetchedResultsController_ 扩展上调用同样的方法不仅运行的非常好，还不会产生我们已经验证过的负面影响，这个扩展允许 _NSFetchedResultsController_ 实例监测后台 context 发生的变化。

### 之后的打算

苹果公司在 WWDC 期间声明了[ Core Data 的几个变化](https://medium.com/bpxl-craft/wwdc-2016-spotlight-core-data-2699e94d35f7)。_NSPersistentContainer_ 将会使得在几个不同 context 保持同步变得更简单。我们将在这篇文章中使用 iOS 10 系统进行测试，看看是否问题还存在。我们将持续更新我们的发现。
