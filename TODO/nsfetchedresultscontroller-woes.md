> * 原文地址：[NSFetchedResultsController Woes](https://medium.com/bpxl-craft/nsfetchedresultscontroller-woes-3a9b485058#.5gva2sils)
* 原文作者：[Michael Gachet](https://medium.com/@6Be)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：


### NSFetchedResultsController Woes

### NSFetchedResultsController 困境
_NSFetchedResultsController_ is a staple of iOS Core Data development. Introduced in iOS 3, this class is responsible for efficiently managing collections of Core Data entities.


_NSFetchedResultsController_ 是iOS核心数据开发的一个主要工具。自iOS 3系统面世以来，这个类就负责高效的管理核心数据实体的集合。


Over the last six years, I have used this controller in all my projects with[various types of Core Data stack configurations](https://medium.com/bpxl-craft/thoughts-on-core-data-stack-configurations-b24b0ea275f3). On a recent project for one of Black Pixel’s top clients, we decided to use a standard “sibling” Core Data stack configuration:

在过去的六年里，我使用这个控制器，并为它设置了[各种类型的核心数据堆栈配置](https://medium.com/bpxl-craft/thoughts-on-core-data-stack-configurations-b24b0ea275f3)来管理我所有的项目。最近，在为Black Pixel的一个大客户制作的项目上，我们决定使用一个标准的“sibling”（同级）核心数据堆栈配置：

*   An _NSFetchedResultsController_ was used to fetch objects from the store on the main UI context. This main context was only used for reading from the store.
*   The background context, used to retrieve entities from a server, was connected to the persistent store coordinator as a sibling to the main UI context.
*   The main context was set up to merge changes from the background context automatically whenever the background context saved its changes to the store.


*   一个_NSFetchedResultsController_ 被用来从主要UI上下文的存储器里获取对象。这个主要的上下文过去只被用来从存储器里读取内容。
*   后台上下文，它被用来从服务器端获取实体，被连接到跟主要UI上下文同级的持久化存储协调者上。
*   主要上下文被设置成这样的状态————每当后台上下文存储变化到存储器的时候，主要上下文都会自动合并来自后台上下文的变化。

Much to my surprise I ended up facing strange issues whereby the_NSFetchedResultsController_ would sometimes be out of sync with the content of the store: Some existing entities matching the _NSFetchedResultsController_’s predicate would never get fetched.

出乎我的意料，我最终遇到了一些奇怪的问题即 the_NSFetchedResultsController_ 有时和存储器里的内容不同步，这导致了一些存在的符合_NSFetchedResultsController_断言的实体却永远无法获取到。

How could something so basic and expected be occurring?

这么基础的问题是怎么发生的呢？


#### A Few Explanations and Fixes

#### 一些解释和解决措施。
A quick Google search yielded a bunch of answers. One in particular provided a detailed explanation of [how things played out with the_NSFetchedResultsController_](http://stackoverflow.com/questions/16296364/nsfetchedresultscontroller-is-not-showing-all-results-after-merging-an-nsmanage?lq=1). Here is the explanation that was given (Note: FRC = _NSFetchedResultsController_):

一次快速的谷歌搜索获得一些答案。一个特别的答案对[_NSFetchedResultsController_是怎么出错的](http://stackoverflow.com/questions/16296364/nsfetchedresultscontroller-is-not-showing-all-results-after-merging-an-nsmanage?lq=1)提供一份详细的解释.这里是给出的解释（备注:FRC = _NSFetchedResultsController_）


> 1\. An FRC is set up with a predicate that doesn’t match all objects (thus preventing the objects that do not match the predicate from being registered in the FRCs context).

> 2\. A second context makes a change to an object, which means that it now matches the FRC’s predicate. The second context is saved.

> 3\. The FRC’s context processes the_NSManagedObjectContextDidSaveNotification_ but only updates its registered objects. Therefore, it does not update the object that now matches the FRC predicate.

> 4\. The FRC does not perform another fetch when there’s a save, therefore it isn’t aware that the updated object should be included.



> 1\. 一个FRC设置的断言并不能匹配所有的对象（这样可以避免不符合断言的对象被注册到FRCs上下文里）

> 2\.第二个上下文使一个对象做产生了一个变化，这意味着它现在符合FRC的断言。第二个上下文被保存下来。

> 3\. FRC上下文处理_NSManagedObjectContextDidSaveNotification_ 的方法只是更新它已经注册过的对象。所以，FRC无法更新现在符合FRC断言的对象。

> 4\. 当有一个保存发生时，FRC不进行再一次的抓取，所以它意识不到更新了的对象应该被包括在内。




I was bothered by the statement made in the third point.

我被上面的第三点陈述所困扰。

Here is the proposed fix:

> The solution is to fetch all updated objects when merging the notification.

The idea is to call _refreshObject(_:mergeChanges:)_ on every updated object that is part of the _NSManagedContextDidSaveNotification_ _userInfo_ payload.

Another set of explanations (for example, articles “[Core Data Gotcha](http://www.mlsite.net/blog/?p=518)” and “[NSFetchedResultsController with predicate ignores changes merged from different NSManagedObjectContext](http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different?lq=1)”) mention that when the_NSManagedContextDidSaveNotification_ is fired, some objects may be faults in the main context and these faults need to be fired before calling_mergeChangesFromContextDidSaveNotification()_.

The idea here is to call _willAccessValueForKey(nil)_ on every updated object that is part of the _NSManagedContextDidSaveNotification_ _userInfo_ payload. And then call _mergeChangesFromContextDidSaveNotification()_.

下面是提出的解决措施：

> 这个解决措施就是当合并消息通知的时候抓取所有的更新对象。

这个措施是在 _NSManagedContextDidSaveNotification_ _userInfo_ 包含的每一个更新对象上调用 _refreshObject(_:mergeChanges:)_ 方法。

另外一些解释（举个例子，[Core Data Gotcha](http://www.mlsite.net/blog/?p=518)” 和“[NSFetchedResultsController with predicate ignores changes merged from different NSManagedObjectContext](http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different?lq=1)”两篇文章提到当_NSManagedContextDidSaveNotification_解注册？时，一些对象可能在主要的上下文变成默认值，这些默认值需要在调用_mergeChangesFromContextDidSaveNotification()_方法前被去除。）

这里的解决方法是在 _NSManagedContextDidSaveNotification_ _userInfo_ 包含的每一个更新对象上调用_willAccessValueForKey(nil)_ 方法，然后调用_mergeChangesFromContextDidSaveNotification()_方法。

#### Time for In-Depth Investigations

#### 深度调查的时间

While in the heat of the project, I settled on the first solution, which introduced a new set of issues that were solved but not always to my satisfaction. I wanted to understand what was going on and verify some of the claims I had been reading that I found disturbing.
当这个项目进行到关键时候，我采用了第一个解决方案，它解决了一系列的新问题，但是始终没有让我满意。我想要理解究竟是什么地方出了问题并且验证一些我正在阅读的另我烦恼的主张。

The goals of these investigations are to:
这些研究的目的是：

*   Figure out what is really going on when changes are merged from one context to another: What is in the target context, and what is in the notification payload?
*   Figure out under which conditions is the _NSFetchedResultsController_ fail to behave as one would expect.
*   Evaluate the various proposed solutions.

*   指出当变化从一个上下文被合并到另一个上下文的时候正在发生些什么：在目标上下文里的是什么？在通知集合里的是什么？
*   指出在什么情况下_NSFetchedResultsController_ 会表现的与预期不符。
*   改善提出的各种解决方法。


### Investigation Setup
### 研究设置


The investigations are performed using a stand-alone iOS application, which is set up as follows:
这个研究使用一个单机的iOS应用进行，它按照如下内容进行设置：

#### Core Data Stack
#### 核心数据堆栈

The Core Data stack is a very basic _“sibling”_ stack with:

*   A main context (_MainQueueConcurrencyType_) that is used as a read-only context.
*   A background context (_PrivateQueueConcurrencyType_) that is read-write.

这个核心数据堆栈是一个非常基础的_“sibling”_堆栈，它有着以下内容：

*   一个主要的上下文（_MainQueueConcurrencyType_）被用作只读的上下文。
*   一个后台上下文 (_PrivateQueueConcurrencyType_) 可以读写.


The main context and background context are siblings and both are connected directly to the _NSPersistentStoreCoordinator_. When changes are saved on the background context, they are automatically merged in the main context using the _mergeChangesFromContextDidSaveNotification()_method.

主要上下文和后台上下文是同级关系并且都直接连接到 _NSPersistentStoreCoordinator_上。当在后台存储变化的时候，这些变化通过调用_mergeChangesFromContextDidSaveNotification()方法被自动合并到主要上下文。

#### Core Data Model
#### 核心数据模型


We use a very simple model containing a single entity _TestDummy_ with three properties: _id: Int_, _name: String_, _isEven: Bool_.
我们使用一个包含一个单独实体 _TestDummy_的简单模型，它有三个属性：_id: Int_, _name: String_, _isEven: Bool_.

#### UI and Main View Controller
#### UI和主要视图控制器

We have a single view controller that has access to both contexts in the Core Data stack and allows one to:
我们有一个单独的视图控制器，它有在核心数据堆栈获得两个上下文的权限并且允许其中的一个有以下的功能：

*   Insert, update, and delete objects in the background context.
*   Save both the main and background contexts.
*   Display information about objects present in both contexts as fetched by two instances of _NSFetchedResultsController_.

*   在后台上下文中插入，更新，删除对象。
*   保存主要上下文和后台上下文。
*   展示被 _NSFetchedResultsController_的两个实例获取的两个上下文的对象信息.


The controller also allows for controlling how the_NSManagedObjectContextDidSaveNotification_ notifications received on the main context are to be processed. Nothing other than_mergeChangesFromContextDidSaveNotification()_ occurs by default.
这个控制器也负责控制在主要上下文里_NSManagedObjectContextDidSaveNotification_ 消息是如何被接收的。默认设置是除了_mergeChangesFromContextDidSaveNotification()_方法调用以外什么都不会发生。

#### NSFetchedResultsController
#### NSFetchedResultsController

Two instances of FRC are managed by the main view controller:
两个FRC的实例被主要视图控制器管理：

*   One instance fetches all _TestDummy_ objects in the main UI context. This instance is referred to the “main FRC.”
*   One instance fetches all _TestDummy_ objects in the background context. This instance is referred to the “background FRC.”

*   一个实例在主要UI上下文中获取所有的_TestDummy_对象。这个实例被称为“主要FRC”。
*   一个实例在后台上下文中获取所有的_TestDummy_对象。这个实例被称为“后台FRC”。


The main context FRC can use two predicates to either fetch all _TestDummy_entities or only those marked as _isEven_ == _true_.
主要上下文FRC可以使用两个断言：要么获取所有_TestDummy_实体要么只是把那些实体标记 _isEven_ == _true_。

### Let’s Fetch Them All!
### 让我们把他们全部拿到！

We start by setting up the main FRC to fetch all _TestDummy_ entities, and we look at three different scenarios taking place in the background context: inserting, updating, and deleting.

我们开始设置主要FRC来获取所有的_TestDummy_实体，然后我们观察在后台上下文发生的三个不同场景：插入，更新，和删除。

#### Inserting Objects
#### 插入对象

We performed the following simple test:
我们进行了下面的简单测试：

1.  Inserting four entities in the background context.
2.  Saving the background context.

1.  在后台上下文中插入4个实体。
2.  保存后台上下文。


The _insertion_ leads to the following:
插入操作导致了下面的情况：

1.  The content of the _insertedObjects_ property on the background context before _save_ matches the content of the _registeredObjects_ property.
2.  The objects fetched by the background FRC match the _registeredObjects_set.

1.  后台的 _insertedObjects_属性内容在保存操作之前与_registeredObjects_的属性内容是匹配的。
2.  后台FRC获取的对象与 _registeredObjects_集合是匹配的。


As expected, s_aving_ changes made in the background context pushes all those changes to the main context:
正如预期的那样，在后台上下文保存的所有变化被推送到主要上下文：

1.  The content of the _registeredObjects_ on both the main and background contexts should be identical.
2.  The objects fetched by the main FRC match the _registeredObjects_ set in the main context.
3.  The main FRC informs its _delegate_ that insertions took place.

1.  主要上下文与后台上下文中的 _registeredObjects_ 内容应该是完全一样的.
2.  主要FRC获取到的对象应该与主要上下文中的 _registeredObjects_ 集合相匹配。
3.  主要FRC通知它的 _delegate_ 插入操作已经发生了。


As a side note, saving the background context also resets the _insertedObjects_set to _nil_ on that context.
顺便需要注意的是：保存后台上下文会把后台上下文的_insertedObjects_集合重置为 _nil_。

#### Updating Objects
#### 更新对象

Understanding what happens when updating objects required digging a bit deeper and looking at two alternate scenarios:
想要理解更新对象的时候发生了什么需要我们更深入的研究，看下面两个交替的场景。

**Scenario #1**

**场景 #1**
1.  Inserting four entities in the background context.
2.  Updating entities 0 and 2 by changing their _isEven_ (from _false_ to _true_) and _title_ properties.
3.  Saving the background context.

1.  在后台上下文中插入四个实体。
2.  改变实体0和实体2的 _isEven_（从_false_ 改为 _true_）和_title_属性参数，然后更新它们。
3.  保存后台上下文。


**Scenario #2**
**场景 #2**

1.  Inserting four entities in the background context.
2.  Saving the background context.
3.  Updating entities 0 and 2 as before.

1.  在后台上下文插入4个实体。
2.  保存后台上下文。
3.  像以前一样更新实体0和实体2。

**Results**
**结果**

As far as Core Data is concerned, objects that have been _inserted_ and then_updated_ before saving the background context are considered as _inserted_. This means that if you inspect the background context’s _updatedObjects_ set, it will be empty by the time you are notified of the changes (it will _not_ be empty right after the update). This may be expected, but it surprised us nonetheless.

考虑到核心数据，在保存后台上下文之前已经被插入并更新的对象被视作已插入。这意味着如果你检查后台上下文的 _updatedObjects_集合，在收到变化通知之前它都是空的（在更新之后，它不会是空的）。这是我们预料到的结果，但是它还是让我们有些惊讶。

The second scenario was much more straightforward. Since the objects have been saved _before_ being updated, they will appear in the _updatedObjects_ set of the background context. This is in line with what one would expect.

第二个场景更加直接。由于对象在被更新之前已经被保存下来，它们将在后台的_updatedObjects_ 集合中出现。这是和我们预期相一致的。

Once again the main FRC behaves as expected: It fetches all entities and properly notifies its _delegate_.
主要的FRC再次表现的跟预期的相一致：它获取到所有的实体并且正确的通知了它的_delegate_。

#### Deleting Objects
#### 删除对象

For deletion we also needed to look into two different scenarios. However, the case of deletion is not as interesting as insertion and updating, as far as the main FRC is concerned. Indeed if an object is registered in the main context, the FRC will always react to this object being deleted.

删除操作我们也需要看两个不同的场景。但是，这个删除操作的例子不像插入和更新那么有趣，直到涉及到主要FRC。确实如果一个对象被注册到主要上下文，FRC将会与这个将被删除的对象进行交互。

The most interesting findings are:

*   Deleting objects from the background context before ever saving that context will remove these objects from the _deletedObjects_ set, and the_insertedObjects_ set will contain the net difference between what was inserted and what was deleted.
*   Deleting objects after saving changes will bring these objects into the_deletedObjects_ set as one would expect.
*   The contents of the _registeredObjects_ and _deletedObjects_ set on the background context may reflect a transient state during the _save_ and should therefore be used with care.
*   The main context will contain all changes made to the background context (i.e., the _registeredObjects_ set will contain all objects before deletion, and the _deletedObjects_ set will contain the deleted objects).
*   Once again, the main FRC reacts properly to all changes.

最有趣的一些发现是：

*   在保存后台上下文之前，进行删除后台上下文对象的操作会把_deletedObjects_集合中的对象删除，
*   在保存变化之后，像我们预料的一样，进行删除对象的操作会把这些对象放入_deletedObjects_ 集合。
*   后台上下文 _registeredObjects_ 和 _deletedObjects_集合的内容在保存期间可能会有一个短暂的反射状态，所以需要小心使用。
*   主要上下文将包含所有后台上下文产生的变化。 (换言之,  _registeredObjects_ 集合在删除操作之前会包含所有的对象， _deletedObjects_ 集合 将包含被删除的对象)。
*   再一次的，主要FRC正确的应对了所有变化。


#### Conclusions and Insights
#### 结论和领悟

If the _delegate_ of the an FRC is not set:
如果一个FRC的 _delegate_没有被设置：

*   The _fetchedObjects_ array will only contain the objects resulting from the initial fetch.
*   The FRC does not receive notifications when objects change or when the context it initialized with is saved.

*    _fetchedObjects_ 队列将只包含初始化时获取到的对象。
*    当对象变化时或者FRC初始化的上下文被保存时，FRC收不到通知。

If the _delegate_ is set for the main FRC, it behaves exactly as expected for entities matching the FRC’s fetch request:
如果主要FRC的_delegate_ 被设置了，它将表现的像预期的那样：实体和FRC的获取请求相一致。

*   Objects inserted, updated, or deleted in the background context are properly fetched (deleted) when the background context merges its changes into the main context.
*   Deletions of permanent objects (i.e., saved to the store and with a permanent objectID) in the background context are carried over to the main context for objects registered in the main context.

*   当后台上下文把它的变化合并到主要上下文的时候，在后台上下文 中插入、更新或者删除的对象都会被正确的获取（删除）。
*   在后台上下文删除一个持久化对象 (即拥有一个持久化ID并保存到存储器的对象)会影响到主要上下文，因为这些对象在主页上下文中注册过。

However, these tests are very specific: The main FRC is set up to fetch all_TestDummy_ entities, which is rarely the case in a real application.

但是，这些测试是非常特殊的：主要FRC被设置获取所有的_TestDummy_ 实体，这在一个真正的应用中是很少见的。

### Let’s Only Fetch a Subset!
### 让我们只获取一个子集!

In order to reflect something more realistic, we perform the same tests as before with one slight change. The main FRC is now set up to only fetch_TestDummy_ entities that are marked as _isEven == true_. Let’s see what happens.

为了让测试变得更加真实，我们进行和之前同样的测试，只是做一些细小的改变。主要FRC现在被设置成只获取属性为_isEven == true__的TestDummy_ 实体。让我们看看发生了什么。

When entities are inserted in the background context the _isEven_ property is set to _false_. Therefore, after inserting objects in the background context and saving them, no entities will be fetched by the main FRC. But what happens if:

当实体在后台上下文被插入时，_isEven_属性被设置成了 _false_。所以，在后台插入对象并保存他们之后，没有实体将被主要FRC获取到。但是如果我们按照下面的做法去做会发生什么呢？

*   We insert entities that match the main FRC’s _predicate_?
*   We update some entities to match the main FRC’s _predicate?_

*   我们插入符合主要FRC的断言的实体？
*   我们更新实体来符合主要FRC的断言？


#### Inserting Matching Entities
#### 插入匹配的实体

When entities inserted in the background context are such that they match the main FRC, they will be properly fetched by this FRC when the background context is saved.

当匹配主要FRC的实体在后台上下文里被被插入的时候，在后台上下文保存的时候他们将会被主要FRC正确的获取到。

#### Updating Entities to Match the Main _FRC’s Predicate_
#### 更新实体来匹配主要的FRC断言

This case is more troublesome. As we stated previously, updating an entity will behave differently depending on whether this entity has already been saved or not:

*   If the entities are inserted in the background context, updated to match the main FRC’s _predicat_e, and then saved, the main FRC will fetch those entities. All behave as if those entities had been inserted to match the predicate in the first place.
*   On the other hand, if entities are inserted, saved, and then updated to match the main FRC’s _predicate_, **they will never be fetched by the main FRC**.

这个方法有些麻烦。在我们之前的陈述中，更新一个实体会有不同的表现，这取决于这个实体是否已经保存了。

*  如果这些实体在后台上下文中被插入，更新了来匹配主要FRC的断言，然后被保存，这个主要FRC将会获取到这些实体。所有的都表现的仿佛那些实体已经被插入来匹配最开始的断言。
*   另一方面，如果实体被插入了，保存了，然后被更新来匹配主要FRC断言， **他们将无法被主要FRC获得**。


#### Looking at Potential Solutions
#### 看看潜在的解决方案


We can think of four different ways of addressing this issue and will discuss each separately in this section.
我们能想到四种方法来应对这个问题，在这一节我们将一一讨论。


#### Changing the Stack Configuration
#### 改变堆栈配置


Remember that this issue applies to configuration where changes made in the background context are pushed to the persistent store coordinator and subsequently merged into the main context.

记住这个方案是应用于这样的配置环境：当后台上下文中发生变化后，这些变化会被推送到持久化存储协调者中，然后被合并到主要上下文。

Switching to a configuration where the background context writes its changes to the main context instead will eradicate this issue with the FRC. This would be a radical approach to solving this issue. Indeed, reconfiguring the stack to a “parent-child” configuration is a radically different architectural approach to change management and comes with a few caveats:

*   The “parent-child” configuration results in a lot more traffic through the main context. All _fetch_ and _save_ operations will block the main context while they occur.
*   You need to deal with temporary object IDs until objects are saved to the persistent store. Alternatively, you may request permanent object IDs when inserting objects in the background context. But again, this comes at the price of some performance.
*   You have less control over merging in case of conflicts between what is in the background context and what is in the main context.



切换到另一种配置，后台上下文把它的变化写入主要上下文来替代上面的操作，这可以根除FRC的这个问题。这是这个问题的一个彻底解决方法。确实，把堆重新配置成“父子”模式是一种改变管理的完全不同的架构方法，这也带来一些问题：

*   “父子”模式的配置导致大量的数据流通需要通过主要上下文进行。当获取和保存的操作发生时，他们将会堵塞主要上下文线程。
*   你需要处理那些缓存的对象ID直到这些对象被存入持久化存储器。或者，当在后台上下文插入对象ID时，你需要请求获取持久化对象ID。但是，这会带来一些性能上的损耗。

*   对于合并后台上下文和主要上下文的冲突你控制的权限变得更少了。

#### Refreshing Objects in the Main Context
#### 刷新主要上下文中的对象

**Typical Implementation** The idea is to call _refreshObjects(mergeChanges:)_ for updated objects when processing the _NSManagedObjectContextDidSaveNotification_ notification payload on the main context.

Implementations usually refresh all updated objects in the notification payload.

**典型实现**这个方法是：当在主要上下文中处理_NSManagedObjectContextDidSaveNotification_通知队列时，调用 _refreshObjects(mergeChanges:)_ 方法来更新对象。

这些实现方式通常是刷新所有消息队列中的已经更新的对象。

**Benefits**
**优势**
*   Simple to implement.
*   Centralized implementation in an _NSManagedContext_ extension is possible.
*   We can choose to fault (_mergeChanges = false_) or merge (_mergeChanges = true_).

*  实现简单
*   在一个_NSManagedContext_ 扩展里集中的管理实现是可能的。
*   我们可以选择缺页设置(_mergeChanges = false_) 或者合并设置 (_mergeChanges = true_)。



**Drawbacks**
**缺陷**

*   We need to call this method on each individual object, with each call resulting in an update of the FRC. This could easily create a performance bottleneck. Any updated objects that were previously registered with the FRC will be updated twice.
*   With _mergeChanges = false_, we fault all refreshed objects in the main context. If those objects are referenced by the FRC, the faults will immediately fire. This results in at least three updates of the complete set of objects fetched by the FRC that have been updated: once as part of the default FRC update mechanism, once due to the forced refresh, and once when faults are immediately fired.
*   Still, with _mergeChanges = false_, faulting existing objects in the context can have nasty side effects. All relationships are faulted, meaning that any reference to those faulted objects or any of the objects they relate to will become invalid. This can easily become pretty hard to manage efficiently. And the last thing you want is a reference to a dead managed object that will crash your application when you try to access it.
*   With _mergeChanges = true_, you will keep existing objects in memory but override any changes with values from the persistent store (i.e., the background context in that case). If you take the strong approach of making your main context read-only, by enforcing that all changes be applied to the background context exclusively, this may work.
*   We need to choose whether to set _mergeChanges = false_ or _mergeChanges = true_.

*   我们需要子每个独立的对象中调用这个方法，每一个都会造成FRC的更新。这很容易造成一个性能瓶颈。任何之前已经用FRC注册过的更新对象都需要被更新两次。
*  我们使用故障设置 _mergeChanges = false来设置所有的主要上下文中的对象. 如果那些对象被FRC提及到，那么内存缺页将立刻失效。这导致被已经更新的FRC获取的完整对象集合会有三次更新: 一次是默认的FRC更新机制中的一部分，一次是由于强制的刷新，一次是当默认设置失效的时候。
*   还是故障设置_mergeChanges = false_的问题,在上下文中不在内存中的对象会造成负面的影响。所有的关系都是缺失的，这意味着任何指向那些不在内存中的对象的引用和那些不在内存中的对象关联的引用都变得无效。这在很大程度上增加了管理的难度。你想要获取的最后一个对象是一个无法管理的对象，当你尝试去控制它的时候，你的应用就会崩溃。
*  选择合并设置 _mergeChanges = true_, 你把存在的对象保存在内存中，但是这样却把持久化存储器里值的变化全部覆盖掉了。(即那个情况下的后台上下文). 如果你采取强硬的方法让你的主要上下文只读，强制性的把所有的变化唯一的应用到后台上下文中，这可能是起作用的。 
*  我们需要选择是设置成_mergeChanges = false_ 或者是 _mergeChanges = true_。




**Typical Example of _NSManagedObjectContext_ Extension and Usage**
** _NSManagedObjectContext_ 拓展和应用的典型例子**

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
#### 改善 refreshObject(_, mergeChanges:)方法

The main drawback of a global implementation that indiscriminately refreshes all updated objects on the main context is that it will refresh objects that are perfectly well managed by the main FRC.
一个在主要上下文中无差别刷新所有更新对象的全局实现，它的主要缺点是它会刷新那些被主要FRC完美管理的对象。

One obvious way to use the same mechanism in a more refined manner is to have the FRC register for the _NSManagedObjectDidSaveNotification_ directly. By doing so, we are able to limit our refresh call to objects that:

*   Are not already registered with the main context.
*   Match the FRC’s _fetchRequest_ properties (i.e., its _entity_ and _predicate_, if defined).

直接拥有_NSManagedObjectDidSaveNotification_ 的FRC注册是一个明显的更优雅的方式，它使用与之前相同的机制。通过这样做，我们可以限制我们对以下对象的刷新调用：

*   还没有在主要上下文注册的。
*   与FRC_fetchRequest_ 属性相符的。(即它的实体和断言，如果定义了的话).

**Benefits**

*   Simple implementation within an _NSFetchedResultsController_ extension.
*   Ability to target refreshing objects that are not registered and that are specific to the FRC only.
*   Better performance for refreshing.
*   No faulting of objects that are not related to the FRC and that are already registered in the main context.

**优势**

*    _NSFetchedResultsController_ 拓展的一个简单实现。
*   指定没有注册过的和只对FRC透露细节的对象作为刷新对象的能力。
*   更好的刷新性能。
*   没有关联FRC的对象和已经在主要上下文中注册的对象都不会缺失。




**Drawback**

At the point where the main FRC registers for saves on the background context, knowledge of the background context is required. If you want to hide this context from your application, it may be an option to vend FRC from your core data stack directly or whichever class has access to both contexts.

**缺点**

主要FRC在后台上下文注册保存的位置，后台上下文的引用是需要的。如果你想要在你的应用中隐藏掉这个上下文，可能的一个选项就是从你的核心数据堆栈或者其他的拥有两个上下文权限的类中直接去掉FRC。

**Sample NSFetchedResultsController Extension**
**SNSFetchedResultsController扩展范例**

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

在这个扩展背后的想法是:

1.  告知每一个FRC去监控一个特定上下文的保过程存。 (尤其是后台上下文).
2.  当收到监控的上下文的_NSManagedObjectContextDidSaveNotification_ 时, 检查FRC的断言是否过滤出实体。如果没有, 不做任何事. FRC将像预想的那样工作。
3.  从消息通知队列中取回所有的插入和更新过的实体,只保存符合FRC实体和断言对象的 _objectID_ 。
4.  从这个对象集合中，删除掉所有已经在FRC上下文注册过的对象。被注册过的这些对象将按照默认设置进行正确的管理。
5.  每一个保留的对象都是在被监控的上下文中新插入的并且没有在FRC中注册过: 调用 _refreshObject(_, mergeChanges:false)_ 方法。  _mergeChanges:false_ 的设置工作的很完美: 对象不存在与FRC的上下文，这样的情况下不在内存中的对象也不会带来负面的影响。

#### Calling willAccessValueForKey(nil)
#### 调用willAccessValueForKey(nil)方法

Another typical solution seen on Stack Overflow is to replace the call to_refreshObjects(_, mergeChanges:)_ by a call to _willAccessValueForKey(nil)_ to fault all new objects in the context, and then call_mergeChangesFromContextDidSaveNotification()_ if required.

在 Stack Overflow上的另外一个典型解决方法是通过调用_willAccessValueForKey(nil)_来替代_refreshObjects(_, mergeChanges:)_ 方法查询所有的新对象是否在上下文中，然后如果有必要还会调用_mergeChangesFromContextDidSaveNotification()_方法。

Once again, this method is called for all _updatedObjects_ that are part of the notification payload received by the main context while processing the_NSManagedObjectContextDidSaveNotification_ notification. As per Apple documentation:


> You can invoke this method with the key value of nil to ensure that a fault has been fired.

Implemented globally, this method will suffer from the same drawback as the previous method. Implemented for only targeted objects, using an_NSFetchedResultsController_ extension works fine. Here is an example of such an extension implementation:

再一次，当处理_NSManagedObjectContextDidSaveNotification_消息通知时，这个方法被主要上下文调用，来通知属于消息通知队列一部分的所有更新对象。正如每一个苹果文档所说的：

> 你可以用一个nil键值对调用这个方法来确保内存缺页失效。



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

你可以调用这个方法取代之前定义的_processChangesWithRefreshObject(_, mergeChanges:)_方法。再一次的说明，调用这个方法没有负面影响。

#### Refetching Objects When Changes occur
#### 当变化发生时重新获取对象。

This is an idea that you may be tempted to implement. It consists of monitoring changes to the background context using the same_NSManagedObjectContextDidSaveNotification_ notification and call_performFetch()_ whenever required.

这是一个你可能回去尝试实现的一个主意。它包括两个部分：使用相同的_NSManagedObjectContextDidSaveNotification_消息通知检测后台上下文的变化和当有需要时调用_performFetch()_方法。

We implemented this method to see whether it worked or not, because we identified refreshing all objects at once as more preferable than one at a time.

我们实现了这个方法想看看它是否能工作，因为我们证实了一次刷新所有的对象比一次刷新一个更合理。

However, we discovered a huge drawback to using this method: The FRC’s_delegate_ is **never** notified of the changes. The new objects are being fetched and registered in the main context, but no one knows about them.

但是，我们发现了使用这个方法的一个巨大缺陷：FRC的_delegate_“从来没有”收到变化的通知。新的对象被获取并注册在主要上下文，但是没有对象了解它们。

One way to work around this issue is to call the delegate methods ourselves after the call to _performFetch_. This is easy enough as long as changes do not affect the FRC’s _sections_. At that point, the work required starts to look a lot like a reimplementation of the FRC’s main feature of change tracking, which is not a wise thing to do.

解决这个问题的一个办法是在调用 _performFetch_方法之后调用代理方法它们本身。这个方法足够的简单并且不会影响都FRC的_sections_。在这一点上，系统运作的时候需要观测许多东西，就像是FRC的追踪变化这个主要特性的重新实现，这样做并不明智。

### To Conclude
### 总结
For a sibling stack configuration (main context and private queue context connected to the _persistentStoreCoordinator_):

*   An _NSFetchedResultsController_ fetching objects in the main context will only be able to fetch objects inserted in the background context if, at the time of saving the background context, the inserted objects match that_NSFetchedResultsController_’s predicate_._
*   If no predicate exists, the _NSFetchedResultsController_ will behave as expected, fetching all relevant entities inserted in the background context.
*   If a predicate exists, the _NSFetchedResultsController_ will only fetch objects inserted in the background context if, and only if, they match that predicate at the time the objects are first saved in the background context.
*   If changes are made after the first save, the updated objects will **never** be fetched if they were not already registered in the main context.
*   Saving objects in the background context and merging changes in the main context behaves as documented at the end of the current run loop.
*   Calling _refreshObject(_:mergeChanges:)_ on all updated objects when processing _NSManagedObjectDidSaveNotification_ notification payload coming from the background context, the solution most often proposed on Stack Overflow, is both inefficient and rife with issues related to faulting.
*   By contrast, calling this same method on an _NSFetchedResultsController_extension that allows an _NSFetchedResultsController_’s instance to monitor changes made to the background context works extremely well and results in no undesirable side effects that we could identify.

作为一个同级的堆栈配置（主要上下文和连接到_persistentStoreCoordinator_的私有队列上下文）：

*  在主要上下文获取对象的_NSFetchedResultsController_ 将只能在后台上下文中获取到插入的对象，在保存后台上下文的时候，被插入的对象符合_NSFetchedResultsController_的断言。
*  如果没有断言，_NSFetchedResultsController_将表现的像预想的那样，获取到所有在后台上下文插入的所有相关的实体。
*  如果有断言，_NSFetchedResultsController_ 只能获取到后台插入的对象, 并且这些对象在第一次在后台上下文中保存的时候必须要符合这个断言才可以。
*  如果变化是在第一次保存之后发生的，并且更新的对象没有在主要上下文注册过，那么它们将**永远不会**被获取到。
*  在后台上下文保存对象，在主要上下文中合并变化，在当前线程循环的末尾像文档上记录的那样运作。
*   当处理来自后台上下文的_NSManagedObjectDidSaveNotification_消息通知时，在所有的更新对象上调用 _refreshObject(_:mergeChanges:)方法， 这个解决方案总是在Stack Overflow网站上被提出来，但是这不仅是无效的，还会普遍带来关于内存缺页的问题
*   对比一下，通过在_NSFetchedResultsController_扩展上调用同样的方法不仅运行的非常好，还不会产生我们已经验证过的负面影响，这个扩展允许_NSFetchedResultsController_实例监测后台上下文发生的变化。

### The Way Forward
### 之后的打算

Apple announced [several changes to Core Data](https://medium.com/bpxl-craft/wwdc-2016-spotlight-core-data-2699e94d35f7) during WWDC. The_NSPersistentContainer_ will make it a lot easier to keep several contexts in sync. We will be performing the tests in this article with iOS 10 to see whether the issue persists. We’ll keep you updated on our findings.

苹果公司在WWDC期间声明了[核心数据的几个变化](https://medium.com/bpxl-craft/wwdc-2016-spotlight-core-data-2699e94d35f7)。_NSPersistentContainer_ 将会使得在几个不同上下文保持同步变得更简单。我们将在这篇文章中使用iOS 10系统进行测试，看看是否问题还存在。我们将持续更新我们的发现。
