> * 原文链接 : [using-a-core-data-model-in-swift-playgrounds](https://www.andrewcbancroft.com/2016/07/10/using-a-core-data-model-in-swift-playgrounds/)
* 原文作者 : [Andrew Bancroft](https://www.andrewcbancroft.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [MAYDAY1993](https://github.com/MAYDAY1993)
* 校对者: [siegeout](https://github.com/siegeout) [owenlyn] (https://github.com/owenlyn)

# 在 Swift Playgrounds 中使用 Core Data 模型

你能在 Xcode 的 Swift Playgrounds 中使用 Core Data 模型么？当然可以！

在2015年， [http://www.learncoredata.com](http://www.learncoredata.com)的作者 [Jeremiah Jessel](https://twitter.com/JCubedApps)，写了篇文章 [detailing how you can use the Core Data framework inside a playground](http://www.learncoredata.com/core-data-and-playgrounds/)。从建立 Core Data 堆栈到在代码中创建 NSManagedObjects，他向我们展示了如何处理这一过程中的所有事情。多么好的资料啊！
读完他的指南后，我开始思考：我很好奇你是否能拿到一个由 Xcode 的数据模型设计创建的 .xcdatamodeld 文件，并在某个背景使用这个文件...
简短的答案是不可以。你不能使用 .xcdatamodeld 文件（至少，我找不到可行的方法），但是你能用当你构建应用就生成的 “momd” 文件。
##局限性
当我了解这个概念的时候我遇到了至少两个局限性／或者说是需要注意的地方。


 ##没有 NSManagedObject 子类
尽管你能在模型中创建实体的实例，如果你已经为实体创建了 `NSManagedObject` 的子类，在 Swift Playgrounds 中你还不能使用这些实体。你得用 `setValue(_: forKey:)` 在  `NSManagedObject` 实例中设置属性来解决这一问题。
但是这只是一个很小的缺陷，尤其是如果你只想稍微了解。
##更新模型
你读过 [walkthrough](https://www.andrewcbancroft.com/2016/07/10/using-a-core-data-model-in-swift-playgrounds/#walkthrough)之后，将会知道如何在背景中引入模型。
总的说来是这样的:如果你曾经更改了模型，你需要操作必须的步骤来在资源文件夹中重新添加一个最新编译的模型。这是因为新加的资源是复制过来的，不是引用的。
我并不认为这是个很糟糕的缺点，尤其是你一旦了解怎么做的时候。
所以你要怎么做呢？看下面过程：
##攻略
在你的项目中加入一个数据模型，我们开始啦。如果你已经进行了一个使用 Core Data 的项目，在你的项目里可能已经有了一个 .xcdatamodeld 文件。如果你没有，这个 .xcdatamodeld 文件能从文件菜单中简单添加。
##添加数据模型文件（除非你已经有一个）
 File -> New -> File…
![New Data Model](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/new-model.png)

用冒烟测试来看以上方法是否可行，我将模型名字设置为默认的值 “Model.xcdatamodeld”。
##添加带属性的实体
将数据模型添加到项目之后，我继续添加了一个带（ 16 位的整数类型名字是 “attribute” ）属性的（名字叫 “Entity” ）实体：
![Add an entity with an attribute.](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/add-entity-and-attributes.png)

##添加 playground
下一步，我往项目里加了一个新的 playground：
 File -> New -> Playground…  
![Add new playground](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/new-playground.png)

##构建项目：定位 “momd” 文件
有一个 playground 并且一个数据模型结构化了，我构建了项目（CMD + B），因此 .xcdatamodeld 文件能被编译成一个 “momd” 文件。就是这个 “momd” 文件需要作为一个资源被添加到 playground 中。
要找到 “momd” 文件，在你的项目导航栏中展开 “Products”，右击 .app，单击 “Show in Finder”：
![Show product in finder](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/show-product-in-finder.png)

##显示 .app 包的内容
在 finder 窗口，右击 .app 文件，然后单击 “Show package contents”:
![Show package contents](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/show-package-contents.png)

##从 finder 中把 “momd” 文件拖拽到 playground 的资源文件夹
![Locate ](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/locate-momd-file.png)

![Drag ](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/drag-momd-to-resources.png)

##写 Core Data 代码来使用模型
既然 “momd” 文件在 playground 的资源文件夹里，你能写代码了。你能插入 `NSManagedObject` 实例，运行 fetch requests 等等。下面是我写的一个例子：

Core Data Playground
```
import UIKit
import CoreData

// Core Data 堆栈存在内存中
public func createMainContext() -> NSManagedObjectContext {
    
    //用你自己模型的名字替换 "Model"
    let modelUrl = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")
    guard let model = NSManagedObjectModel.init(contentsOfURL: modelUrl!) else { fatalError("model not found") }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
    
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    
    return context
}

let context = createMainContext()

//插入一个新实体
let ent = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: context)
ent.setValue(42, forKey: "attribute")

try! context.save()

//运行一个 fetch request
let fr = NSFetchRequest(entityName: "Entity")
let result = try! context.executeFetchRequest(fr)

print(result)
```

![Fetch request result](https://www.andrewcbancroft.com/wp-content/uploads/2016/07/printed-result.png)

哇哦！这很酷啊。

**别忘了** :如果你更新了模块，你需要重新构建你的应用，从 playground 的资源中删掉 “momd” 文件夹，再一次重新把新编译好的 “momd”  文件拖拽到 playground 中来运行最新版本的模型。

## 潜在的用处

除了“我想知道这是否可能”，另一个问的重要问题是“它是多么有用？”

* 学习。 Playgrounds 本身作为一个学习工具有意义。能够搭建你在 Xcode 设计中思考的模块，把它导入一个 Playground ，并且把它当作一个学习练习来研究它，是多么酷啊！
* 当你需要测试你的数据模块但是不想把它连到一个实际的用户交互的时候，也是有用的。在 playground 中抛掉所有用户交互复杂性，只研究数据模型！这似乎是一个比在控制台输出更优雅的解决方法
* 有可能你需要为一个 fetch request 构建半复杂性的 `NSPredicate` 实例－－为何不首先在 playground 中得到这个实例，然后把实例迁移到你的应用中呢？仅仅是个想法哦！
