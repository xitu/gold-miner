> * 原文地址：[NSFetchedResultsController Woes](https://medium.com/bpxl-craft/nsfetchedresultscontroller-woes-3a9b485058#.5gva2sils)
* 原文作者：[Michael Gachet](https://medium.com/@6Be)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


### NSFetchedResultsController Woes

_NSFetchedResultsController_ is a staple of iOS Core Data development. Introduced in iOS 3, this class is responsible for efficiently managing collections of Core Data entities.

Over the last six years, I have used this controller in all my projects with[various types of Core Data stack configurations](https://medium.com/bpxl-craft/thoughts-on-core-data-stack-configurations-b24b0ea275f3). On a recent project for one of Black Pixel’s top clients, we decided to use a standard “sibling” Core Data stack configuration:

*   An _NSFetchedResultsController_ was used to fetch objects from the store on the main UI context. This main context was only used for reading from the store.
*   The background context, used to retrieve entities from a server, was connected to the persistent store coordinator as a sibling to the main UI context.
*   The main context was set up to merge changes from the background context automatically whenever the background context saved its changes to the store.

Much to my surprise I ended up facing strange issues whereby the_NSFetchedResultsController_ would sometimes be out of sync with the content of the store: Some existing entities matching the _NSFetchedResultsController_’s predicate would never get fetched.

How could something so basic and expected be occurring?

#### A Few Explanations and Fixes

A quick Google search yielded a bunch of answers. One in particular provided a detailed explanation of [how things played out with the_NSFetchedResultsController_](http://stackoverflow.com/questions/16296364/nsfetchedresultscontroller-is-not-showing-all-results-after-merging-an-nsmanage?lq=1). Here is the explanation that was given (Note: FRC = _NSFetchedResultsController_):

> 1\. An FRC is set up with a predicate that doesn’t match all objects (thus preventing the objects that do not match the predicate from being registered in the FRCs context).

> 2\. A second context makes a change to an object, which means that it now matches the FRC’s predicate. The second context is saved.

> 3\. The FRC’s context processes the_NSManagedObjectContextDidSaveNotification_ but only updates its registered objects. Therefore, it does not update the object that now matches the FRC predicate.

> 4\. The FRC does not perform another fetch when there’s a save, therefore it isn’t aware that the updated object should be included.

I was bothered by the statement made in the third point.

Here is the proposed fix:

> The solution is to fetch all updated objects when merging the notification.

The idea is to call _refreshObject(_:mergeChanges:)_ on every updated object that is part of the _NSManagedContextDidSaveNotification_ _userInfo_ payload.

Another set of explanations (for example, articles “[Core Data Gotcha](http://www.mlsite.net/blog/?p=518)” and “[NSFetchedResultsController with predicate ignores changes merged from different NSManagedObjectContext](http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different?lq=1)”) mention that when the_NSManagedContextDidSaveNotification_ is fired, some objects may be faults in the main context and these faults need to be fired before calling_mergeChangesFromContextDidSaveNotification()_.

The idea here is to call _willAccessValueForKey(nil)_ on every updated object that is part of the _NSManagedContextDidSaveNotification_ _userInfo_ payload. And then call _mergeChangesFromContextDidSaveNotification()_.

#### Time for In-Depth Investigations

While in the heat of the project, I settled on the first solution, which introduced a new set of issues that were solved but not always to my satisfaction. I wanted to understand what was going on and verify some of the claims I had been reading that I found disturbing.

The goals of these investigations are to:

*   Figure out what is really going on when changes are merged from one context to another: What is in the target context, and what is in the notification payload?
*   Figure out under which conditions is the _NSFetchedResultsController_ fail to behave as one would expect.
*   Evaluate the various proposed solutions.

### Investigation Setup

The investigations are performed using a stand-alone iOS application, which is set up as follows:

#### Core Data Stack

The Core Data stack is a very basic _“sibling”_ stack with:

*   A main context (_MainQueueConcurrencyType_) that is used as a read-only context.
*   A background context (_PrivateQueueConcurrencyType_) that is read-write.

The main context and background context are siblings and both are connected directly to the _NSPersistentStoreCoordinator_. When changes are saved on the background context, they are automatically merged in the main context using the _mergeChangesFromContextDidSaveNotification()_method.

#### Core Data Model

We use a very simple model containing a single entity _TestDummy_ with three properties: _id: Int_, _name: String_, _isEven: Bool_.

#### UI and Main View Controller

We have a single view controller that has access to both contexts in the Core Data stack and allows one to:

*   Insert, update, and delete objects in the background context.
*   Save both the main and background contexts.
*   Display information about objects present in both contexts as fetched by two instances of _NSFetchedResultsController_.

The controller also allows for controlling how the_NSManagedObjectContextDidSaveNotification_ notifications received on the main context are to be processed. Nothing other than_mergeChangesFromContextDidSaveNotification()_ occurs by default.

#### NSFetchedResultsController

Two instances of FRC are managed by the main view controller:

*   One instance fetches all _TestDummy_ objects in the main UI context. This instance is referred to the “main FRC.”
*   One instance fetches all _TestDummy_ objects in the background context. This instance is referred to the “background FRC.”

The main context FRC can use two predicates to either fetch all _TestDummy_entities or only those marked as _isEven_ == _true_.

### Let’s Fetch Them All!

We start by setting up the main FRC to fetch all _TestDummy_ entities, and we look at three different scenarios taking place in the background context: inserting, updating, and deleting.

#### Inserting Objects

We performed the following simple test:

1.  Inserting four entities in the background context.
2.  Saving the background context.

The _insertion_ leads to the following:

1.  The content of the _insertedObjects_ property on the background context before _save_ matches the content of the _registeredObjects_ property.
2.  The objects fetched by the background FRC match the _registeredObjects_set.

As expected, s_aving_ changes made in the background context pushes all those changes to the main context:

1.  The content of the _registeredObjects_ on both the main and background contexts should be identical.
2.  The objects fetched by the main FRC match the _registeredObjects_ set in the main context.
3.  The main FRC informs its _delegate_ that insertions took place.

As a side note, saving the background context also resets the _insertedObjects_set to _nil_ on that context.

#### Updating Objects

Understanding what happens when updating objects required digging a bit deeper and looking at two alternate scenarios:

**Scenario #1**

1.  Inserting four entities in the background context.
2.  Updating entities 0 and 2 by changing their _isEven_ (from _false_ to _true_) and _title_ properties.
3.  Saving the background context.

**Scenario #2**

1.  Inserting four entities in the background context.
2.  Saving the background context.
3.  Updating entities 0 and 2 as before.

**Results**

As far as Core Data is concerned, objects that have been _inserted_ and then_updated_ before saving the background context are considered as _inserted_. This means that if you inspect the background context’s _updatedObjects_ set, it will be empty by the time you are notified of the changes (it will _not_ be empty right after the update). This may be expected, but it surprised us nonetheless.

The second scenario was much more straightforward. Since the objects have been saved _before_ being updated, they will appear in the _updatedObjects_ set of the background context. This is in line with what one would expect.

Once again the main FRC behaves as expected: It fetches all entities and properly notifies its _delegate_.

#### Deleting Objects

For deletion we also needed to look into two different scenarios. However, the case of deletion is not as interesting as insertion and updating, as far as the main FRC is concerned. Indeed if an object is registered in the main context, the FRC will always react to this object being deleted.

The most interesting findings are:

*   Deleting objects from the background context before ever saving that context will remove these objects from the _deletedObjects_ set, and the_insertedObjects_ set will contain the net difference between what was inserted and what was deleted.
*   Deleting objects after saving changes will bring these objects into the_deletedObjects_ set as one would expect.
*   The contents of the _registeredObjects_ and _deletedObjects_ set on the background context may reflect a transient state during the _save_ and should therefore be used with care.
*   The main context will contain all changes made to the background context (i.e., the _registeredObjects_ set will contain all objects before deletion, and the _deletedObjects_ set will contain the deleted objects).
*   Once again, the main FRC reacts properly to all changes.

#### Conclusions and Insights

If the _delegate_ of the an FRC is not set:

*   The _fetchedObjects_ array will only contain the objects resulting from the initial fetch.
*   The FRC does not receive notifications when objects change or when the context it initialized with is saved.

If the _delegate_ is set for the main FRC, it behaves exactly as expected for entities matching the FRC’s fetch request:

*   Objects inserted, updated, or deleted in the background context are properly fetched (deleted) when the background context merges its changes into the main context.
*   Deletions of permanent objects (i.e., saved to the store and with a permanent objectID) in the background context are carried over to the main context for objects registered in the main context.

However, these tests are very specific: The main FRC is set up to fetch all_TestDummy_ entities, which is rarely the case in a real application.

### Let’s Only Fetch a Subset!

In order to reflect something more realistic, we perform the same tests as before with one slight change. The main FRC is now set up to only fetch_TestDummy_ entities that are marked as _isEven == true_. Let’s see what happens.

When entities are inserted in the background context the _isEven_ property is set to _false_. Therefore, after inserting objects in the background context and saving them, no entities will be fetched by the main FRC. But what happens if:

*   We insert entities that match the main FRC’s _predicate_?
*   We update some entities to match the main FRC’s _predicate?_

#### Inserting Matching Entities

When entities inserted in the background context are such that they match the main FRC, they will be properly fetched by this FRC when the background context is saved.

#### Updating Entities to Match the Main _FRC’s Predicate_

This case is more troublesome. As we stated previously, updating an entity will behave differently depending on whether this entity has already been saved or not:

*   If the entities are inserted in the background context, updated to match the main FRC’s _predicat_e, and then saved, the main FRC will fetch those entities. All behave as if those entities had been inserted to match the predicate in the first place.
*   On the other hand, if entities are inserted, saved, and then updated to match the main FRC’s _predicate_, **they will never be fetched by the main FRC**.

#### Looking at Potential Solutions

We can think of four different ways of addressing this issue and will discuss each separately in this section.

#### Changing the Stack Configuration

Remember that this issue applies to configuration where changes made in the background context are pushed to the persistent store coordinator and subsequently merged into the main context.

Switching to a configuration where the background context writes its changes to the main context instead will eradicate this issue with the FRC. This would be a radical approach to solving this issue. Indeed, reconfiguring the stack to a “parent-child” configuration is a radically different architectural approach to change management and comes with a few caveats:

*   The “parent-child” configuration results in a lot more traffic through the main context. All _fetch_ and _save_ operations will block the main context while they occur.
*   You need to deal with temporary object IDs until objects are saved to the persistent store. Alternatively, you may request permanent object IDs when inserting objects in the background context. But again, this comes at the price of some performance.
*   You have less control over merging in case of conflicts between what is in the background context and what is in the main context.

#### Refreshing Objects in the Main Context

**Typical Implementation** The idea is to call _refreshObjects(mergeChanges:)_ for updated objects when processing the _NSManagedObjectContextDidSaveNotification_ notification payload on the main context.

Implementations usually refresh all updated objects in the notification payload.

**Benefits**

*   Simple to implement.
*   Centralized implementation in an _NSManagedContext_ extension is possible.
*   We can choose to fault (_mergeChanges = false_) or merge (_mergeChanges = true_).

**Drawbacks**

*   We need to call this method on each individual object, with each call resulting in an update of the FRC. This could easily create a performance bottleneck. Any updated objects that were previously registered with the FRC will be updated twice.
*   With _mergeChanges = false_, we fault all refreshed objects in the main context. If those objects are referenced by the FRC, the faults will immediately fire. This results in at least three updates of the complete set of objects fetched by the FRC that have been updated: once as part of the default FRC update mechanism, once due to the forced refresh, and once when faults are immediately fired.
*   Still, with _mergeChanges = false_, faulting existing objects in the context can have nasty side effects. All relationships are faulted, meaning that any reference to those faulted objects or any of the objects they relate to will become invalid. This can easily become pretty hard to manage efficiently. And the last thing you want is a reference to a dead managed object that will crash your application when you try to access it.
*   With _mergeChanges = true_, you will keep existing objects in memory but override any changes with values from the persistent store (i.e., the background context in that case). If you take the strong approach of making your main context read-only, by enforcing that all changes be applied to the background context exclusively, this may work.
*   We need to choose whether to set _mergeChanges = false_ or _mergeChanges = true_.

**Typical Example of _NSManagedObjectContext_ Extension and Usage**

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

#### Improving on refreshObject(_, mergeChanges:)

The main drawback of a global implementation that indiscriminately refreshes all updated objects on the main context is that it will refresh objects that are perfectly well managed by the main FRC.

One obvious way to use the same mechanism in a more refined manner is to have the FRC register for the _NSManagedObjectDidSaveNotification_ directly. By doing so, we are able to limit our refresh call to objects that:

*   Are not already registered with the main context.
*   Match the FRC’s _fetchRequest_ properties (i.e., its _entity_ and _predicate_, if defined).

**Benefits**

*   Simple implementation within an _NSFetchedResultsController_ extension.
*   Ability to target refreshing objects that are not registered and that are specific to the FRC only.
*   Better performance for refreshing.
*   No faulting of objects that are not related to the FRC and that are already registered in the main context.

**Drawback**

At the point where the main FRC registers for saves on the background context, knowledge of the background context is required. If you want to hide this context from your application, it may be an option to vend FRC from your core data stack directly or whichever class has access to both contexts.

**Sample NSFetchedResultsController Extension**

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

The idea behind this extension is:

1.  Tell each FRC to monitor saves made to a specific context (typically, the background context).
2.  Upon receiving an _NSManagedObjectContextDidSaveNotification_ for the observed context, check whether this FRC’s predicate filters out entities or not. If not, don’t do anything. The FRC will work as expected.
3.  Retrieve all _inserted_ and _updated_ entities from the notification payload, and only save the _objectID_ of the objects matching the FRC’s _entity_ and_predicate._
4.  From this set of objects, remove all objects that are already registered with the FRC’s context. Being registered, these objects will be managed properly by default.
5.  Each remaining object is newly inserted in the monitored context and not yet registered in the FRC: call _refreshObject(_, mergeChanges:false)_. Setting _mergeChanges:false_ works perfectly: The object is non-existent in the FRC’s context and the faulting will have no side effects.

#### Calling willAccessValueForKey(nil)

Another typical solution seen on Stack Overflow is to replace the call to_refreshObjects(_, mergeChanges:)_ by a call to _willAccessValueForKey(nil)_ to fault all new objects in the context, and then call_mergeChangesFromContextDidSaveNotification()_ if required.

Once again, this method is called for all _updatedObjects_ that are part of the notification payload received by the main context while processing the_NSManagedObjectContextDidSaveNotification_ notification. As per Apple documentation:

> You can invoke this method with the key value of nil to ensure that a fault has been fired.

Implemented globally, this method will suffer from the same drawback as the previous method. Implemented for only targeted objects, using an_NSFetchedResultsController_ extension works fine. Here is an example of such an extension implementation:

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

You could call this method instead of the previously defined_processChangesWithRefreshObject(_, mergeChanges:)_. Once again, there should be no side effects to calling this method. We only fault objects that are brand new to the main context and matching the main FRC’s _predicate_.

#### Refetching Objects When Changes occur

This is an idea that you may be tempted to implement. It consists of monitoring changes to the background context using the same_NSManagedObjectContextDidSaveNotification_ notification and call_performFetch()_ whenever required.

We implemented this method to see whether it worked or not, because we identified refreshing all objects at once as more preferable than one at a time.

However, we discovered a huge drawback to using this method: The FRC’s_delegate_ is **never** notified of the changes. The new objects are being fetched and registered in the main context, but no one knows about them.

One way to work around this issue is to call the delegate methods ourselves after the call to _performFetch_. This is easy enough as long as changes do not affect the FRC’s _sections_. At that point, the work required starts to look a lot like a reimplementation of the FRC’s main feature of change tracking, which is not a wise thing to do.

### To Conclude

For a sibling stack configuration (main context and private queue context connected to the _persistentStoreCoordinator_):

*   An _NSFetchedResultsController_ fetching objects in the main context will only be able to fetch objects inserted in the background context if, at the time of saving the background context, the inserted objects match that_NSFetchedResultsController_’s predicate_._
*   If no predicate exists, the _NSFetchedResultsController_ will behave as expected, fetching all relevant entities inserted in the background context.
*   If a predicate exists, the _NSFetchedResultsController_ will only fetch objects inserted in the background context if, and only if, they match that predicate at the time the objects are first saved in the background context.
*   If changes are made after the first save, the updated objects will **never** be fetched if they were not already registered in the main context.
*   Saving objects in the background context and merging changes in the main context behaves as documented at the end of the current run loop.
*   Calling _refreshObject(_:mergeChanges:)_ on all updated objects when processing _NSManagedObjectDidSaveNotification_ notification payload coming from the background context, the solution most often proposed on Stack Overflow, is both inefficient and rife with issues related to faulting.
*   By contrast, calling this same method on an _NSFetchedResultsController_extension that allows an _NSFetchedResultsController_’s instance to monitor changes made to the background context works extremely well and results in no undesirable side effects that we could identify.

### The Way Forward

Apple announced [several changes to Core Data](https://medium.com/bpxl-craft/wwdc-2016-spotlight-core-data-2699e94d35f7) during WWDC. The_NSPersistentContainer_ will make it a lot easier to keep several contexts in sync. We will be performing the tests in this article with iOS 10 to see whether the issue persists. We’ll keep you updated on our findings.
