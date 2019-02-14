> * 原文地址：[Swift: Avoiding Memory Leaks by Examples](https://hackernoon.com/swift-avoiding-memory-leaks-by-examples-f901883d96e5)
> * 原文作者：[jaafar barek](https://hackernoon.com/@BarekJaafar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-avoiding-memory-leaks-by-examples.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-avoiding-memory-leaks-by-examples.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：

# Swift：通过示例避免内存泄漏

[![](https://cdn-images-1.medium.com/max/1600/1*Vy54VZkKuf4zbd7WjdS75Q.png)](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Art/memory_management_2x.png)

在 Swift 中，使用自动引用计数（ARC）来管理 iOS 应用程序中的内存使用情况。

每次创建类的新实例时，ARC都会分配一块内存来存储有关它的信息，并在不再需要该实例时自动释放该内存。

作为开发人员，你不需要为内存管理做任何事情，除了3个案例，你需要告诉ARC有关实例之间关系的更多信息，以避免「循环引用期」。

In this article we will walk together in the process of managing these 3 cases , and see real examples of retain cycles and how to get rid of them.  
But first, what are retain cycles and why we need to avoid them?

* * *

### Retain Cycles:

Retain Cycle is the case when 2 objects have strong reference to each others and are retained , make it impossible for ARC to release those object from the memory and cause what we call a “memory leak”.

> Memory leaks are dangerous in you app because they will affect your app’s performance and might lead to crashes when the app runs out of memory.

* * *

### The 3 cases that cause memory leaks:

#### **1- Strong Reference Between 2 Classes:**

Suppose we have 2 classes (Author&Book) that directly reference each other :

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

Theoretically this should print that both objects were allocated , and then de allocated because they were set to nil but instead it prints the following:

```
Author Object was allocated in memory
Book object was allocated in memory
```

As you see both objects were never released from memory because a retain cycle occurred when both classed had strong reference to each others.

To solve this we can declare on of the references to be weak or unowned as follows:

```
class Author {
   var name:String
   weak var book:Book? // book needs to be optional to be declared as weak
    
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

This time both objects will be released and the console prints the following:

```
Author Object was allocated in memory
Book object was allocated in memory
Author Object was deallocated
Book Object was deallocated
```

The problem was solved and ARC was able to clean the memory chunk when the objects were released just by making one of the references weak , but what does weak and unowned actually mean? According to apple’s documentation:

#### Weak References

> A weak reference is a reference that does not keep a strong hold on the instance it refers to, and so does not stop ARC from disposing of the referenced instance. This behavior prevents the reference from becoming part of a strong reference cycle. You indicate a weak reference by placing the `weak` keyword before a property or variable declaration.

#### Unowned References

> Like a weak reference, an _unowned reference_ does not keep a strong hold on the instance it refers to. Unlike a weak reference, however, an unowned reference is used when the other instance has the same lifetime or a longer lifetime. You indicate an unowned reference by placing the `unowned` keyword before a property or variable declaration.

* * *

#### **2- Class Protocol Relation:**

Another cause for memory leaks can be a strong relation between a protocol and a class. In the following example we will take a real world scenario were we have a TablViewController Class and a TableViewCell Class , when the user presses a button in the TableViewCell it should delegate this action to the TablViewController as follows:

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

Normally , when we dismiss the TableViewController , deinit should be called and the print statement should appear in the console , but in this case since TableViewCellDelegate and TableViewController have strong reference to each other they will never be released from memory.  
To solve this we can simply adjust the TableViewCell class to be as follows:

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

This time dismiss the TableViewController and see the console:

```
TableViewController is deallocated
```

* * *

#### 3- Strong Reference Cycles for Closures:

Suppose we have the following ViewController:

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

Try dismissing ViewController , the deinit method will never be executed.  
The reason why is because the closure captures a strong reference of the ViewController. To solve this we need to pass self as weak or unowned as follows:

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

This time when dismissing ViewController the console will print:

```
ClosureViewController was deallocated
```

* * *

### Conclusion

There is no doubt ARC do an amazing job managing memory for our application , all we have to do as developers is to be aware of strong references between classes , between a class and a protocol , and inside closures by declaring weak or unowned variables in those cases.

* * *

### Some Great References about ARC:

*   [Apple’s Documentation.](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)
*   [Raywenderlich](https://www.raywenderlich.com/959-arc-and-memory-management-in-swift) article about ARC.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
