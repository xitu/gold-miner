>* 原文链接 : [Undo History in Swift](http://chris.eidhof.nl/post/undo-history-in-swift/)
* 原文作者 : [chriseidhof](https://twitter.com/chriseidhof/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zheaoli](https://github.com/Zheaoli)
* 校对者:



在过去的一段时间里，有很多的Blog推出了介绍关于**Swift**动态特性的文章.**Swift** 已经成为了一门具有相当多动态特性的语言：它拥有泛型，协议， 可以作为一等公民的函数（译者注：first-class function指函数可以向类一样作为参数传递），和包含很多可以的动态操作的函数的标准库，比如**map**和**filter**等（这意味着我们可以利用更安全更强大的函数来代替像KVC这样的操作方式）（译者注：KVC指Key-Value-Coding一个非正式的 Protocol，提供一种机制来间接访问对象的属性。）。对于大多数人而言，特别希望介绍[反射](http://inessential.com/2016/05/26/a_definition_of_dynamic_programming_in_t)这一特性，这意味着他们可以在程序运行时进行观察和修改。

在**Swift**中，只有少量受限制的反射机制，尽管你可以在代码运行的时候动态的生成和插入一些东西。 比如这里是怎样为[**NSCoding**或者是JSON动态生成字典的实例](http://chris.eidhof.nl/post/swift-mirrors-and-json/).

今天在这里，我们将一起看一下在**Swift**中怎样去实现撤销功能。 其中一种方法是通过利用**Objective-C**中基于的反射机制所提供的**NSUndoManager**。通过利用**struct**，我们可以利用不同的方式在我们的APP中实现撤销这一功能。 在教程开始之前，请务必确保你自己已经理解了**Swift**中**struct**的工作机制(最重要的是去理解**struct**的拷贝机制)。
首先要声明的一点是，这篇文章并不是想告诉大家我们不需要对**runtime**进行操作，或者我们提供的是一种**NSUndoManager**的替代品。这篇文章只是告诉了大家一种不同的思考方式而已。

我们首先创建一个叫做**UndoHistory**的**struct**We’ll build a struct called `UndoHistory`. It’s generic, with the caveat that it only works when `A` is a struct. To keep a history of all the states, we can store every value in an array. Whenever we want to change something, we just push onto the array, and whenever we want to undo, we pop from the array. We always want to start with an initial state, so we create an initializer for that:
~~~ Swift
    struct UndoHistory<A> {
        private let initialValue: A
        private var history: [A] = []
        init(initialValue: A) {
            self.initialValue = initialValue
        }
    }
~~~

For example, if we want to add undo support to a table view controller that’s backed by an array, we can create a value of this struct:
~~~ Swift
    var history = UndoHistory(initialValue: [1, 2, 3])
~~~

To support undo for a different struct, we just start with a different initial value:
~~~ Swift
    struct Person {
        var name: String
        var age: Int
    }
~~~
~~~ Swift
    var personHistory = UndoHistory(initialValue: Person(name: "Chris", age: 31))
~~~

Of course, we want to have a way of getting the current state, and setting the current state (in other words: adding an item to our history). To get the current state, we simply return the last item in our `history` array, and if the array is empty, we return the initial value. To set the current state, we simply append to our `history` array.
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

For example, if we want to change the person’s age, we can easily do that through our new computed property:
~~~ Swift
    personHistory.currentItem.age += 1
    personHistory.currentItem.age // Prints 32
~~~

Of course, the code isn’t complete without an `undo` method. This is as simple as removing the last item from the array. Depending on your preference, you could also make it `throw` when the undo stack is empty, but I’ve chosen not to do that.
~~~ Swift
    extension UndoHistory {
        mutating func undo() {
            guard !history.isEmpty else { return }
            history.removeLast()
        }
    }
~~~

Using it is easy:
~~~ Swift
    personHistory.undo()
    personHistory.currentItem.age // Prints 31 again
~~~~

Of course, our `UndoHistory` works on more than just simple `Person` structs. For example, if we want to create a table view controller that’s backed by an `Array`, we can use the `currentItem` property to get the array out :
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

Another thing that is really cool with struct semantics: we get observation for free. For example, we could change the definition of `data`:
~~~ Swift
    var data: UndoHistory<[item]> {
        didSet {
            tableView.reloadData()
        }
    }
~~~

Even if we change something deep inside the array (e.g. `data.currentItem[17].name = "John"`) our `didSet` will get triggered. Of course, we probably want to do something a little bit smarter than `reloadData`. For example, we could use the [Changeset](https://github.com/osteslag/Changeset) library to compute a diff and have insert/delete/move animations.

Obviously, this approach has its drawbacks too. For example, it keeps a full history of the state, rather than a diff. It only works with structs (to be precise: only with structs that have value semantics). That said, you do not have to read the [runtime programming guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html), you only need to have a good grasp of structs and generics to come up with this solution.



1.  It would probably be nice to define a computed property `items` which just gets and sets `data.currentItem`. This makes the data source / delegate method implementations much nicer. [<sup>[return]</sup>](#fnref:4f7f6a73fd4549ae772cf1c92915d55d:1)
2.  If you want to take this further, there are a couple of fun exercises: try adding redo support, or labeled actions. You can implement reordering in the table view, and you will see that if you do it naively, you’ll end up with two entries in your undo history. [<sup>[return]</sup>](#fnref:4f7f6a73fd4549ae772cf1c92915d55d:2)
