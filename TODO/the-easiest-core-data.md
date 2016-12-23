> * 原文地址：[The Easiest Core Data](http://albertodebortoli.com/blog/2016/08/05/the-easiest-core-data/)
* 原文作者：[Alberto De Bortoli](http://albertodebortoli.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Zheaoli](https://github.com/Zheaoli)
* 校对者：[Kulbear](https://github.com/Kulbear), [cbangchen](https://github.com/cbangchen)

# 「最简单」的 Core Data 上手指南

在过去的几个月里，我花费了大量的时间在研究 Core Data 之上，我得去处理一个使用了很多陈旧的代码，糟糕的 Core Data 以及违反了多线程安全的项目。讲真，Core Data 学习起来非常的困难，在学习 Core Data 的时候，你肯定会感到迷惑和一种深深的挫败感。正是因为这些原因，我决定给出一种超级简单的解决方案。这个方案的特点就是简洁，线程安全，非常易于使用，这个方案能满足你大部分对于 Core Data 的需求。在经过若干次的迭代后，我所设计的方案最终成为一个成熟的方案。

OK，女士们，先生们，现在请允许我隆重向您介绍 [Skiathos](https://github.com/albertodebortoli/Skiathos) 和 [Skopelos](https://github.com/albertodebortoli/Skopelos)。其中 **Skiathos** 是基于 **Objective-C** 所开发的，而 **Skopelos** 则基于 **Swift** 所开发的。这两个框架的名字来源于希腊的两个岛，在这里，我渡过了2016年的夏天，同时，在这里完成了两个框架的编写工作。

## 写在前面的话

整个项目的目的就是能够让您以及其简便的方式在您的 App 中引入 Core Data。

我们将从如下几个方面来进行一个介绍:

*   CoreDataStack
*   AppStateReactor
*   DALService (Data Access Layer)

### CoreDataStack

如果你有过使用 Core Data 的经验，那么你应该知道创建一个堆栈是一个充满陷阱的过程。这个组件是用于创建堆栈（用于管理 **Obejct Context** ），具体的设计说明可以参看 Marcus Zarra 所写的这篇[文章](http://martiancraft.com/blog/2015/03/core-data-stack/)。

![](https://s3.amazonaws.com/albertodebortoli.github.com/images/coredata/coredatastack.png)

其中一个和 Magical Record 或者其余第三方插件不同的是，整个存储过程都是在一个方向上发起的，可能是从某个子节点向下或者向上传递来进行持久化储存。其余的组件允许你创建以 **private context** 作为父节点的子节点，这将会导致 **main context** 不能被更新，同时只能通过通知的方式来进行合并更新。**main context** 是相对固定的并与 **UI** 进行了绑定：这样较为简单的方式可以帮助开发者更好的去完成一个 APP 的开发。

### AppStateReactor

唔，其实你可以忽略这一段。这个组件属于 CoreDataStack ，在 App 切换至后台，失去节点，或者即将退出时，它负责监视相对应的修改，并把其保存。

### DALService (Data Access Layer) / (Skiathos/Skopelos)

如果你拥有使用 Core Data 的经验，那么你也应该知道，我们大部分操作都是重复的，我们经常在一个 context 中调用 `performBlock:/performBlockAndWait:` 函数，而这个 Context 提供了一个最终会调用 `save:` 作为最终语句的 block 。数据库的所有操作都是基于 API 中所提供的 `read:` 和 `write:` ：这两个协议提供了 CQRS （命令和查询分离） 的实现。用于读取的代码块将在主体中进行运行（因为这被认为是一个已确定的单个资源）。用于写入的代码块将会在一个子线程中运行，这样可以保证实时的进行数据储存，变化的数据将会在不会阻塞主线程的情况下通过异步的方式进行储存。`write:completion:` 方法将会程序运行完后来对数据的更改进行持久化储存。

换句话说，写入的数据在 `main managed object context` 和最后持久化过程中都会保证其一致性。在 主要管理对象的 `context` 中，相应的数据也能保证其可用性。

`Skiathos`/`Skopelos` 是 `DALService` 的子类, 这样可以给这个组件一个比较好听的名字。

## 使用介绍

在使用这一系列组件之前，你首先需要创建一个类型为 `Skiathos` 的属性，然后以下面这种方式去初始化它：

~~~OC
    self.skiathos = [Skiathos setupInMemoryStackWithDataModelFileName:@"<#datamodelfilename>"];
    // or
    self.skiathos = [Skiathos setupSqliteStackWithDataModelFileName:@"<#datamodelfilename>"];
~~~

在使用 `Skopelos` 时，代码如下所示：

~~~Swift
    self.skopelos = SkopelosClient(inMemoryStack: "<#datamodelfilename>")
    // or
    self.skopelos = SkopelosClient(sqliteStack: "<#datamodelfilename>")
~~~


你可以通过使用依赖注入的方式来在应用的其余地方使用这些对象。不得不说，为 Core Data 栈上的不同对象创建单例是一种很不错的做法。当然，不断的创建实例的开销是十分巨大的。通常来讲，我们不是很推荐使用单例模式。单例模式的测试性不强，在使用过程中，使用者无法有效的控制其声明周期，这样可能会违背一些最佳实践的编程原则。正是因为如此，在这个库里，我们不推荐使用单例。

由于下面几个原因，你在使用时需要从 `Skiathos`/`Skopelos` 进行继承：

*   创建一个全局可共享的实例。
*   重载 `handleError(error: NSError)` 方法，以便在你的程序里出现一些错误时，这个方法能够正常的被调用。

为了创建单例，你应该如下面的示例一样去从 `Skiathos`/`Skopelos` 进行继承：

### 单例

~~~Swift
    @interface SkiathosClient : Skiathos
    + (SkiathosClient *)sharedInstance;
    @end
    static SkiathosClient *sharedInstance = nil;
    @implementation SkiathosClient
    + (SkiathosClient *)sharedInstance
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [self setupSqliteStackWithDataModelFileName:@"<#datamodelfilename>"];
    </#datamodelfilename>    });
        return sharedInstance;
    }
    - (void)handleError:(NSError *)error
    {
        // clients should do the right thing here
        NSLog(@"%@", error.description);
    }
    @end
~~~

或者是

~~~Swift
    class SkopelosClient: Skopelos {
        static let sharedInstance = Skopelos(sqliteStack: "DataModel")
        override func handleError(error: NSError) {
            // clients should do the right thing here
            print(error.description)
        }
    }
~~~

### 读写操作

写到这里，让我们同时看看在一个标准 Core Data 的操作方式和我们组件所提供的方式吧。

标准的读取姿势:

~~~OC
    __block NSArray *results = nil;
    NSManagedObjectContext *context = ...;
    [context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(User)
        inManagedObjectContext:context];
        [request setEntity:entityDescription];
        NSError *error;
        results = [context executeFetchRequest:request error:&error];
    }];
    return results;
~~~

标准的写入姿势:

~~~OC
    NSManagedObjectContext *context = ...;
    [context performBlockAndWait:^{
        User *user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(User)
        inManagedObjectContext:context];
        user.firstname = @"John";
        user.lastname = @"Doe";
        NSError *error;
        [context save:&error];
        if (!error)
        {
            // continue to save back to the store
        }
    }];
~~~

`Skiathos` 中的读取姿势：

~~~OC
    [[SkiathosClient sharedInstance] read:^(NSManagedObjectContext *context) {
        NSArray *allUsers = [User allInContext:context];
        NSLog(@"All users: %@", allUsers);
    }];
~~~

`Skiathos` 中的写入姿势：

~~~OC
    // Sync
    [[SkiathosClient sharedInstance] writeSync:^(NSManagedObjectContext *context) {
        User *user = [User createInContext:context];
        user.firstname = @"John";
        user.lastname = @"Doe";
    }];
    [[SkiathosClient sharedInstance] writeSync:^(NSManagedObjectContext *context) {
        User *user = [User createInContext:context];
        user.firstname = @"John";
        user.lastname = @"Doe";
    } completion:^(NSError *error) {
        // changes are saved to the persistent store
    }];
    // Async
    [[SkiathosClient sharedInstance] writeAsync:^(NSManagedObjectContext *context) {
        User *user = [User createInContext:context];
        user.firstname = @"John";
        user.lastname = @"Doe";
    }];
    [[SkiathosClient sharedInstance] writeAsync:^(NSManagedObjectContext *context) {
        User *user = [User createInContext:context];
        user.firstname = @"John";
        user.lastname = @"Doe";
    } completion:^(NSError *error) {
        // changes are saved to the persistent store
    }];
~~~

`Skiathos` 当然也支持链式调用：

~~~OC
    __block User *user = nil;
    [SkiathosClient sharedInstance].write(^(NSManagedObjectContext *context) {
        user = [User createInContext:context];
        user.firstname = @"John";
        user.lastname = @"Doe";
    }).write(^(NSManagedObjectContext *context) {
        User *userInContext = [user inContext:context];
        [userInContext deleteInContext:context];
    }).read(^(NSManagedObjectContext *context) {
        NSArray *users = [User allInContext:context];
    });
~~~

如果是在 Swift中，代码将会变成下面这个样子

读取：

~~~Swift
    SkopelosClient.sharedInstance.read { context in
        let users = User.SK_all(context)
        print(users)
    }
~~~

写入：

~~~Swift
    // Sync
    SkopelosClient.sharedInstance.writeSync { context in
        let user = User.SK_create(context)
        user.firstname = "John"
        user.lastname = "Doe"
    }
    SkopelosClient.sharedInstance.writeSync({ context in
        let user = User.SK_create(context)
        user.firstname = "John"
        user.lastname = "Doe"
        }, completion: { (error: NSError?) in
            // changes are saved to the persistent store
    })
    // Async
    SkopelosClient.sharedInstance.writeAsync { context in
        let user = User.SK_create(context)
        user.firstname = "John"
        user.lastname = "Doe"
    }
    SkopelosClient.sharedInstance.writeAsync({ context in
        let user = User.SK_create(context)
        user.firstname = "John"
        user.lastname = "Doe"
    }, completion: { (error: NSError?) in
        // changes are saved to the persistent store
    })
~~~

链式调用：

~~~Swift
    SkopelosClient.sharedInstance.write { context in
        user = User.SK_create(context)
        user.firstname = "John"
        user.lastname = "Doe"
    }.write { context in
        if let userInContext = user.SK_inContext(context) {
            userInContext.SK_remove(context)
        }
    }.read { context in
        let users = User.SK_all(context)
        print(users)
    }
~~~

`NSManagedObject` 类所提供了非常清楚的 **CRUD** 方法。在作为读/写代码块的参数传递之时，对象应该被作为一个整体进行处理。你应该优先使用这些内建的方法。主要的方法有下面这些：


~~~OC
    + (instancetype)SK_createInContext:(NSManagedObjectContext *)context;
    + (NSUInteger)SK_numberOfEntitiesInContext:(NSManagedObjectContext *)context;
    - (void)SK_deleteInContext:(NSManagedObjectContext *)context;
    + (void)SK_deleteAllInContext:(NSManagedObjectContext *)context;
    + (NSArray *)SK_allInContext:(NSManagedObjectContext *)context;
    + (NSArray *)SK_allWithPredicate:(NSPredicate *)pred inContext:(NSManagedObjectContext *)context;
    + (instancetype)SK_firstInContext:(NSManagedObjectContext *)context;
~~~

~~~Swift
    static func SK_create(context: NSManagedObjectContext) -> Self
    static func SK_numberOfEntities(context: NSManagedObjectContext) -> Int
    func SK_remove(context: NSManagedObjectContext) -> Void
    static func SK_removeAll(context: NSManagedObjectContext) -> Void
    static func SK_all(context: NSManagedObjectContext) -> [Self]
    static func SK_all(predicate: NSPredicate, context:NSManagedObjectContext) -> [Self]
    static func SK_first(context: NSManagedObjectContext) -> Self?
~~~

注意，在使用 `SK_inContext(context: NSManagerObjectContext)` 时，不同的读写代码块可能会得到同一个对象。

## 线程安全

所有 DALService 所产生的实例都可以认为是线程安全的。

我们特别建议你在项目中进行这样的设置 `-com.apple.CoreData.ConcurrencyDebug 1` ，这可以确保你不会在多线程和并发的情况下滥用 Core Data。

这个组件不是为了通过隐藏 `ManagedObjectContext:` 的概念来达到接口引入的目的：它将会在客户端中引入更多的线程问题，因为开发者有责任去检查所调用线程的类型（而那将会是在忽视 Core Data 所带给我们的好处）。
