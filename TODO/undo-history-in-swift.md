>* 原文链接 : [Undo History in Swift](http://chris.eidhof.nl/post/undo-history-in-swift/)
* 原文作者 : [chriseidhof](https://twitter.com/chriseidhof/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zheaoli](https://github.com/Zheaoli)
* 校对者: [xcc3641](https://github.com/xcc3641), [Jaeger](https://github.com/laobie)

# 利用 Swift 在 APP 中实现撤销操作的功能

在过去的一段时间里，有很多的Blog推出了关于他们想在**Swift**中所添加的动态特性的文章。事实上**Swift** 已经成为了一门具有相当多动态特性的语言：它拥有泛型，协议， 头等函数（译者注1：first-class function指函数可以向类一样作为参数传递），和包含很多可以的动态操作的函数的标准库，比如**map**和**filter**等（这意味着我们可以利用更安全更灵活的函数来代替 KVC 来使用 字符串）（译者注2：KVC指Key-Value-Coding一个非正式的 Protocol，提供一种机制来间接访问对象的属性）。对于大多数人而言，特别希望介绍[反射](http://inessential.com/2016/05/26/a_definition_of_dynamic_programming_in_t)这一特性，这意味着他们可以在程序运行时进行观察和修改。

在**Swift**中，反射机制受到很多的限制，但是你仍然你可以在代码运行的时候动态的生成和插入一些东西。 比如这里是怎样为[**NSCoding**或者是JSON动态生成字典](http://chris.eidhof.nl/post/swift-mirrors-and-json/)的实例。

今天在这里，我们将一起看一下在**Swift**中怎样去实现撤销功能。 其中一种方法是通过利用**Objective-C**中基于的反射机制所提供的**NSUndoManager**。通过利用**struct**，我们可以利用不同的方式在我们的APP中实现撤销这一功能。 在教程开始之前，请务必确保你自己已经理解了**Swift**中**struct**的工作机制(最重要的是理解他们都是独立的拷贝)。
首先要声明的一点是，这篇文章并不是想告诉大家我们不需要对**runtime**进行操作，或者我们提供的是一种**NSUndoManager**的替代品。这篇文章只是告诉了大家一种不同的思考方式而已。

我们首先创建一个叫做**UndoHistory**的**struct**。 通常而言，创建UndoHistory时会伴随一个警告，提示只有当A是一个struct的时才会生效。为了保存所有状态信息，我们需要将其存放入一个数组之中。当我们修改了什么时，我们只需要将其**push**进数组中，当我们希望进行撤回时，我们将其从数组中**pop**出去。我们通常希望有一个初试状态，所以我们需要建立一个初始化方法：
~~~ Swift
    struct UndoHistory<A> {
        private let initialValue: A
        private var history: [A] = []
        init(initialValue: A) {
            self.initialValue = initialValue
        }
    }
~~~

举个例子，如果我们想在一个**tableViewController**中通过数组的方式提供撤销操作，我们可以创建这样一个**struct**：
~~~ Swift
    var history = UndoHistory(initialValue: [1, 2, 3])
~~~

对于不同情境下的撤销操作，我们可以创建不同的**struct**来实现:
~~~ Swift
    struct Person {
        var name: String
        var age: Int
    }
~~~
~~~ Swift
    var personHistory = UndoHistory(initialValue: Person(name: "Chris", age: 31))
~~~

当然，我们希望获得当前的状态，同时设置当前状态。(换句话说：我们希望实时地操作我们的历史记录）。我们可以从**history**数组中的最后一项值来获取我们的状态，同时如果数组为空的话，我们便返回我们的初始值。 我们可以通过将当前状态添加至**history**数组来改变我们的操作状态。
~~~ Swift
    extension UndoHistory {
        var currentItem: A {
            get {
                return history.last ?? initialValue
            }
            set {
                history.append(newValue)
            }
        }
    }
~~~

比如，如果我们想修改个人年龄（译者注3：指前面作者编写的**Person**结构体中的**age**属性）， 我们可以通过重新计算属性来很轻松的做到这一点：
~~~ Swift
    personHistory.currentItem.age += 1
    personHistory.currentItem.age // Prints 32
~~~

当然，**undo** 方法的编写并未完成。对于从数组中移出最后一个元素来讲是非常简单的。 根据你自己的声明，你可以在数组为空的时候抛出一个异常，不过，我没有选择这样一种做法。
~~~ Swift
    extension UndoHistory {
        mutating func undo() {
            guard !history.isEmpty else { return }
            history.removeLast()
        }
    }
~~~

很简单的使用它（译者注4：这里指作者前面所编写的**undo**相关代码）
~~~ Swift
    personHistory.undo()
    personHistory.currentItem.age // Prints 31 again
~~~~

当然，我们到现在的**UndoHistory**操作只是基于一个很简单的**Person**类。比如，如果我们想利用**Array**来实现一个**tableviewcontroller**的**undo**操作，我们可以利用**属性**来获取从数组中得到的元素：
~~~ Swift
    final class MyTableViewController<item>: UITableViewController {
        var data: UndoHistory<[item]>

        init(value: [Item]) {
            data = UndoHistory(initialValue: value)
            super.init(style: .Plain)
        }

        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.currentItem.count
        }

        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("Identifier", forIndexPath: indexPath)
            let item = data.currentItem[indexPath.row]
            // configure `cell` with `item`
            return cell
        }

        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            guard editingStyle == .Delete else { return }
            data.currentItem.removeAtIndex(indexPath.row)
        }
    }
~~~

在**struct**中另一个非常爽的特性是：我们可以自由的使用监听者模式。 比如,我们可以修改**data**的值：
~~~ Swift
    var data: UndoHistory<[item]> {
        didSet {
            tableView.reloadData()
        }
    }
~~~

我们即使是修改数组内很深的值（比如：**data.currentItem[17].name = "John"**），我们通过**didSet**也能很方便地定位到修改的地方。当然,我们可能希望做一些例如**reloadData**这样方便的事情。比如， 我们可以利用[Changeset](https://github.com/osteslag/Changeset) 库来计算变化，然后来根据插入/删除/移动/等不同的操作来添加动画。

很明显的是, 这种方法有着它自身的缺点。例如，它保存了整个状态的历史操作，不是每次状态变化之间的不同点。 这种方法只使用了**struct**来实现**undo**操作 （更为准确的讲：是只使用了**struct**中值的一些特性）。这意味着，你并不需要去阅读 [**runtime**编程指导](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html)这本书， 你只需要对**struct**和**generics**（译者注5：generics指泛型）有足够的了解。



1.  为data.currentItem提供了一个可计算的属性 items 来进行获取和设置操作，是一个不错的想法。这使得**data-source**和**delegate**等方法的实现变得更为容易。
2.  如果你想更进一步优化，这里有一些非常有意思的想法：添加恢复功能，或者是编辑功能。你可以在**tableView**中去实现, 如果你真的很天真的按照这个去做了，那么你会发现在你的**undo**历史中会存在重复记录。
