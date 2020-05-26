> * 原文地址：[Swift: Avoiding Memory Leaks by Examples](https://hackernoon.com/swift-avoiding-memory-leaks-by-examples-f901883d96e5)
> * 原文作者：[jaafar barek](https://hackernoon.com/@BarekJaafar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-avoiding-memory-leaks-by-examples.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-avoiding-memory-leaks-by-examples.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[HearFishle](https://github.com/HearFishle)

# Swift：通过示例避免内存泄漏

[![](https://cdn-images-1.medium.com/max/1600/1*Vy54VZkKuf4zbd7WjdS75Q.png)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Art/memory_management_2x.png)

在 Swift 中，使用自动引用计数（ARC）来管理 iOS 应用程序中的内存使用情况。

每次创建类的新实例时，ARC都会分配一块内存来存储有关它的信息，并在不再需要该实例时自动释放该内存。

作为开发人员，你不需要为内存管理做任何事情，除了以下 3 种情况，你需要告诉 ARC 有关实例之间关系的更多信息，以避免「循环引用」。

在本文中，我们将在集中讨论这3种情况，并查看循环引用的实际示例以及如何去避免它们。 

但是首先，我们得知道什么是循环引用以及为什么我们需要避免它们？

* * *

### 循环引用：

循环引用就是这种情况，两个对象彼此具有强引用并相互持有，ARC 无法从内存中释放这些对象从而导致「内存泄漏」。

> 在应用程序中出现内存泄漏是非常危险的，因为它们会影响应用程序的性能，并且在应用程序内存不足时可能会导致崩溃。

* * *

### 以下三种情况会造成内存泄漏：

#### **1- 两个类之间的强引用：**

假设我们有2个类（Author 类和 Book 类）直接相互引用：

```
class Author {
    var name:String
    var book:Book
    
    init(name:String,book:Book) {
        self.name = name
        self.book = book
        print("Author Object was allocated in memory")
    }
    deinit {
        print("Author Object was de allocated")
    }
}

var author = Author(name:"John",book:Book())
author = nil
```

```
class Book {
    var name:String
    var author:Author
    
    init(name:String,author:Author) {
        self.name = name
        self.author = author
        print("Book object was allocated in memory")
    }
    deinit {
        print("Book Object was deallocated")
    }
}
var book = Book(name:"Swift",author:author)
book = nil
```

理论上，因为这两个对象都被设置为 nil，所以应该先打印出两个对象都已分配，然后打印出两个对象都被销毁，但是它会打印以下内容：

```
Author Object was allocated in memory
Book object was allocated in memory
```

正如你所见，两个对象并未从内存中释放，因为当两个对象之间彼此具有强引用时发生了循环引用。

为了解决这个问题，我们可以如下声明弱引用或无主引用：

```
class Author {
   var name:String
   weak var book:Book? // book 对象需要被声明为弱的可选项
    
    init(name:String,book:Book?) {
        self.name = name
        self.book = book
        print("Author Object was allocated in memory")
    }
    deinit {
        print("Author Object was deallocated")
    }
}
```

这次两个对象都会被释放，控制台将打印以下内容：

```
Author Object was allocated in memory
Book object was allocated in memory
Author Object was deallocated
Book Object was deallocated
```

问题解决了，ARC 在清理内存块时可以通过使其中一个引用变弱来释放对象，但弱引用和无主引用是什么呢？根据 apple 的文档：

#### 弱引用

> 弱引用是一种不会强制保留它引用实例的引用，因此就不会阻止 ARC 处理这些的实例。这样使引用避免了成为强引用循环的一部分。你可以通过在属性或变量声明之前放置 `weak` 关键字来标记弱引用。

#### 无主引用

> 与弱引类似，**无主引用** 也不会对它引用的实例保持强引用。然而，与弱引用不同得是，当另一个实例具有相同的生命周期或更长的生命周期时，则需要使用无主引用。 你可以通过在属性或变量声明之前放置 `unowned` 关键字来标记无主引用。

* * *

#### **2 类协议关系：**

内存泄漏的另一个原因可能是协议和类之间的密切关系。在下面的示例中，我们将采用一个真实的场景，我们有一个 TablViewController 类和一个 TableViewCell 类，当用户按下 TableViewCell 中的一个按钮时，它应该将此动作代理给 TablViewController，如下所示：

```
@objc protocol TableViewCellDelegate {
   func onAlertButtonPressed(cell:UITableViewCell)
}
class TableViewCell: UITableViewCell {

    var delegate:TableViewCellDelegate?
    
    @IBAction func onAlertButtonPressed(_ sender: UIButton) {
      delegate?.onAlertButtonPressed(cell: self)
    }
}
```

```
class TableViewController: UITableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        return cell
    }
 
    deinit {
        print("TableViewController is deallocated")
    }

}
extension TableViewController: TableViewCellDelegate {
    func onAlertButtonPressed(cell: UITableViewCell) {
        if let row = tableView.indexPath(for: cell)?.row {
            print("cell selected at row: \(row)")
        }
        dismiss(animated: true, completion: nil)
    }
}
```

通常，当我们关闭 TableViewController 时，ARC 应该调用 deinit 方法并且在控制台中 打印「TableViewController is deallocated」，但是在这种情况下，由于 TableViewCellDelegate 和 TableViewController 彼此之间具有强引用，所以它们永远不会从内存中释放。

为了解决这个问题，我们可以简单地将 TableViewCell 类调整为如下：

```
@objc protocol TableViewCellDelegate {
   func onAlertButtonPressed(cell:UITableViewCell)
}
class TableViewCell: UITableViewCell {

   weak var delegate:TableViewCellDelegate?
    
    @IBAction func onAlertButtonPressed(_ sender: UIButton) {
      delegate?.onAlertButtonPressed(cell: self)
    }
}
```

这次关闭 TableViewController 就可以在控制台中看到：

```
TableViewController is deallocated
```

* * *

#### 3- 闭包的强循环引用：

假设我们有以下 ViewController：

```
class ViewController: UIViewController {

    var closure : (() -> ()) = { }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        closure = {
            self.view.backgroundColor = .red
        }
    }
    deinit {
        print("ViewController was deallocated")
    }
}
```

尝试关闭 ViewController，deinit 方法永远不会被执行。
这是因为闭包捕获了 ViewController 的强引用。要解决这个问题，我们需要在闭包中使用 weak 或 unowned 修饰的 self，如下所示：

```
class ViewController: UIViewController {

    var closure : (() -> ()) = { }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        closure = { [unowned self] in
            self.view.backgroundColor = .red
        }
    }
    deinit {
        print("ViewController was deallocated")
    }
}
```

这次关闭 ViewController 时控制台将打印：

```
ClosureViewController was deallocated
```

* * *

### 总结

毫无疑问，ARC 对应用程序的内存管理起了了不起的作用，我们开发者所要做的是注意类之间，类和协议之间以及内部闭包之间的强引用，通过声明 weak 或者 unowned 来避免循环引用。

* * *

### 关于 ARC 的一些重要参考：

*   [Apple 官方文档](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)
*   [Raywenderlich](https://www.raywenderlich.com/959-arc-and-memory-management-in-swift) 关于 ARC 的文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
