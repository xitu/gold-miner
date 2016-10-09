> * 原文地址：[25 Core Data in iOS10: NSPersistentContainer](https://swifting.io/blog/2016/09/25/25-core-data-in-ios10-nspersistentcontainer/)
* 原文作者：[Michał Wojtysiak](https://swifting.io/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：





Xcode 8 is here if you have not peeked at any of betas yet, you will find all kinds of new stuff. There is Swift 3 with [major changes](https://swifting.io/blog/2016/08/17/22-swift-3-access-control-beta-6?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post), there are new frameworks like [SiriKit](https://swifting.io/blog/2016/07/18/20-sirikit-can-you-outsmart-provided-intents?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post) and there are enhancements to existing ones like [notifications](https://swifting.io/blog/2016/08/22/23-notifications-in-ios-10?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post). We have also received simplified Core Data stack in form of NSPersistentContainer that does heavy part of setup for us. Is it worth trying? Let's dig in and find out.

#### Core Data stack prior to iOS10

Over years, after trying many Core Data stacks we have settled on simple two context stack with a merge on save. Let's have a look at key components and wiring up. Link to the full version on GitHub is available in references. Code has been adjusted to Swift 3 and Xcode 8.







    finalclassCoreDataStack{

    staticletsharedStack=CoreDataStack()

    varerrorHandler:(Error)->Void={_in}

    private init(){

    NotificationCenter.default.addObserver(self,

    selector:#selector(CoreDataStack.mainContextChanged(notification:)),

    name:.NSManagedObjectContextDidSave,

    object:self.managedObjectContext)

    NotificationCenter.default.addObserver(self,

    selector:#selector(CoreDataStack.bgContextChanged(notification:)),

    name:.NSManagedObjectContextDidSave,

    object:self.backgroundManagedObjectContext)

    deinit{

    NotificationCenter.default.removeObserver(self)

    lazy varapplicationDocumentsDirectory:NSURL={

    leturls=FileManager.default.urls(for:.documentDirectory,in:.userDomainMask)

    returnurls[urls.count-1]asNSURL

    }()

    lazy varmanagedObjectModel:NSManagedObjectModel={

    letmodelURL=Bundle.main.url(forResource:"DataModel",withExtension:"momd")!

    returnNSManagedObjectModel(contentsOf:modelURL)!

    }()

    lazy varpersistentStoreCoordinator:NSPersistentStoreCoordinator={

    letcoordinator=NSPersistentStoreCoordinator(managedObjectModel:self.managedObjectModel)

    leturl=self.applicationDocumentsDirectory.appendingPathComponent("DataModel.sqlite")

    do{

    trycoordinator.addPersistentStore(ofType:NSSQLiteStoreType,

    configurationName:nil,

    at:url,

    options:[NSMigratePersistentStoresAutomaticallyOption:true,

    NSInferMappingModelAutomaticallyOption:true])

    }catch{

    // Report any error we got.

    NSLog("CoreData error \(error), \(error._userInfo)")

    self.errorHandler(error)

    returncoordinator

    }()

    lazy varbackgroundManagedObjectContext:NSManagedObjectContext={

    letcoordinator=self.persistentStoreCoordinator

    varprivateManagedObjectContext=NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)

    privateManagedObjectContext.persistentStoreCoordinator=coordinator

    returnprivateManagedObjectContext

    }()

    lazy varmanagedObjectContext:NSManagedObjectContext={

    letcoordinator=self.persistentStoreCoordinator

    varmainManagedObjectContext=NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)

    mainManagedObjectContext.persistentStoreCoordinator=coordinator

    returnmainManagedObjectContext

    }()

    @objc funcmainContextChanged(notification:NSNotification){

    backgroundManagedObjectContext.perform{[unownedself]in

    self.backgroundManagedObjectContext.mergeChanges(fromContextDidSave:notification asNotification)

    @objc funcbgContextChanged(notification:NSNotification){

    managedObjectContext.perform{[unownedself]in

    self.managedObjectContext.mergeChanges(fromContextDidSave:notification asNotification)







What's up there? Let's break it down to pieces.

##### #1

In the init we subscribe to notifications sent by main and background `NSManagedObjectContext`'s on save.

##### #2

Extracted documents directory `NSURL` getter. `NSPersistentStoreCoordinator` uses it to create `NSPersistentStore` at given location.

##### #3

Similarly to documents directory, this extracted `NSManagedObjectModel` getter is used to initialize `NSPersistentStoreCoordinator` with our model.

##### #4

This is where all the wiring up magic is done. First, we create `NSPersitentStoreCoordinator` with model. Then we retrieve url of our documents directory. Finally we add a persitent store of certain type to `NSPersitentStoreCoordinator` at documents directory.

##### #5

Here we create a 'background' `NSManagedObjectContext` in a private queue and attach it to our `NSPersistentStoreCoordinator`. This context is used to perform syncronisation and write operations.

##### #6

Here we create a 'view' `NSManagedObjectContext` in a main queue and attach it to our `NSPersistentStoreCoordinator`. This context is used to fetch data to be displayed on UI.

##### #7

This stack uses good old merging contexts triggered on save notifications. In these methods we perform this merging.

#### Meet NSPersistentContainer

iOS 10 provides us `NSPersistentContainer`. It is supposed to simplify code and do heavy lifing for us. Does it? Let me show you our rebuilt CoreDataStack based on `NSPersistentContainer`. A **_complete_** one:





    finalclassCoreDataStack{

    staticletshared=CoreDataStack()

    varerrorHandler:(Error)->Void={_in}

    lazy varpersistentContainer:NSPersistentContainer={

    letcontainer=NSPersistentContainer(name:"DataModel")

    container.loadPersistentStores(completionHandler:{[weakself](storeDescription,error)in

    ifleterror=error{

    NSLog("CoreData error \(error), \(error._userInfo)")

    self?.errorHandler(error)

    returncontainer

    }()

    lazy varviewContext:NSManagedObjectContext={

    returnself.persistentContainer.viewContext

    }()

    // Optional

    lazy varbackgroundContext:NSManagedObjectContext={

    returnself.persistentContainer.newBackgroundContext()

    }()

    funcperformForegroundTask(_block:@escaping(NSManagedObjectContext)->Void){

    self.viewContext.perform{

    block(self.viewContext)

    funcperformBackgroundTask(_block:@escaping(NSManagedObjectContext)->Void){

    self.persistentContainer.performBackgroundTask(block)







It is much shorter indeed. But what happened to all that code from the earlier version?

Simple answer is that `NSPersistentContainer` does all that for us. That is not good enough for a blog post explanation 😆. We will break it down to pieces as well.

##### #1

Here we can see the power of `NSPersistentContainer`. It does the entire work of #2, #3, #4, #5, #6 from former stack and to some extent frees us from implementing #1 and #7\.

How?

First, it is initialised with a name that is used to find a model with that name in documents directory and creates a store with the same name. This is convenience initialiser. You can use a full version and pass your model manually.







    public init(name:String,managedObjectModel model:NSManagedObjectModel)





Then, before calling `loadPersistentStores` method you have time to further configure your container with `NSPersistentStoreDescription` for example. We went for a default SQLite database so we have just loaded our persistent store and ensured error handling.

##### #2

This is actually just a wrapper. `viewContext` was already created for us by `NSPersistentContainer`. What is more it is already configured to consume save notifications from other contexts. Quoting Apple:

> The managed object context associated with the main queue. (read-only) … This context is configured to be generational and to automatically consume save notifications from other contexts.

##### #3

`NSPersistentContainer` gives us also a factory method to create multiple private queue contexts. Here we use it to have one, common background context for complex synchronisation purposes. Contexts created with this factory method are also set to consume `NSManagedObjectContextDidSave` broadcasts automatically.  
This is optional.

##### #4

`NSPersistentContainer` exposes a method for running Core Data tasks in background (more in #5). We have liked the name of API so much that we have created similar wrapper for our `viewContext`.

##### #5

As mentioned above this just a wrapper on `performBackgroundTask` method of `NSPersistentContainer`. Each time it is invoked a new context of `privateQueueConcurrencyType` is created.

**NOTE:** We have covered most of `NSPersistentContainer` features but you may want to look into [reference](https://developer.apple.com/reference/coredata/nspersistentcontainer?utm_source=swifting.io&utm_medium=web&utm_campaign=blog%20post) to see all that it is offering.

#### What if NSPersistentContainer does slightly too much for me?

There are some options.

First, make sure to check full reference and look for properties or methods that you may need. We have covered that there are two initialisers, a convenience one that takes just string name and full one that takes also `NSManagedObjectModel`.

Then, you can go into extensions or subclassing. Let me give you example. In one of our projects we have had a CoreData stack shared between core app and extensions. It had to land in an AppGroup shared space and `NSPersistentContainer` default documents directory was no longer a use for us.

Luckily, with a small subclass of `NSPersistentContainer` we were back in the game and could use all goodies given by container.





    structCoreDataServiceConsts{

    staticletapplicationGroupIdentifier="group.com.identifier.app-name"

    final classPersistentContainer: NSPersistentContainer{

    internal overrideclassfuncdefaultDirectoryURL()->URL{

    varurl=super.defaultDirectoryURL()

    ifletnewURL=

    FileManager.default.containerURL(

    forSecurityApplicationGroupIdentifier:CoreDataServiceConsts.applicationGroupIdentifier){

    url=newURL

    returnurl







#### Summary & References

Hopefully, you have enjoyed this little walkthrough `NSPersistentContainer` and we are keen to see how your Core Data stacks will evolve with all improvements in Core Data Framework.

Wait… What? Are there more changes?

Yes there is. The best way to find out is Apple's 'What's new in Core Data in iOS10' article (link below). Changes start from concurrency, context versioning, fetch requests, auto merging changes from parent context and end on … `NSFetchedResultsController` in macOS 10.12.

Written by: Michał Wojtysiak

