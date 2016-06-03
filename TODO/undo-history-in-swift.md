>* 原文链接 : [Undo History in Swift](http://chris.eidhof.nl/post/undo-history-in-swift/)
* 原文作者 : [chriseidhof](https://twitter.com/chriseidhof/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



Over the last weeks, there have been a number of blog posts that want to add dynamic behavior to Swift. Swift is already a very dynamic language: it has generics, protocols, first-class functions, and the standard library is filled with functions like `map` and `filter`, which dynamically get their operation (not using a string like with KVC, but using a function, which is safer and more flexible). Most of the people that say they want dynamic behavior mean that they [want reflection](http://inessential.com/2016/05/26/a_definition_of_dynamic_programming_in_t) specifically: they want to analyze and modify the program at runtime.

In Swift, there is only a very limited reflection mechanism, although you can already inspect and generate code at runtime. For example, here’s how to generate a dictionary ready for `NSCoding` or JSON serialization: [Swift mirrors and JSON](http://chris.eidhof.nl/post/swift-mirrors-and-json/).

Today, we’ll have a look at implementing undo functionality in Swift. One of the examples people keep bringing up to make the case for reflection (the way Objective-C) supports it is `NSUndoManager`. With struct semantics, we can add undo support to our apps in a different way. Before we get started, make sure that you understand how structs work in Swift (most importantly, how they are all unique copies). Clearly, this post will not remove the need for runtime programming in Swift, nor is it a replacement for `NSUndoManager`. It’s just a simple example of how to think different.

We’ll build a struct called `UndoHistory`. It’s generic, with the caveat that it only works when `A` is a struct. To keep a history of all the states, we can store every value in an array. Whenever we want to change something, we just push onto the array, and whenever we want to undo, we pop from the array. We always want to start with an initial state, so we create an initializer for that:

    struct UndoHistory<A> {
        private let initialValue: A
        private var history: [A] = []
        init(initialValue: A) {
            self.initialValue = initialValue
        }
    }

For example, if we want to add undo support to a table view controller that’s backed by an array, we can create a value of this struct:

    var history = UndoHistory(initialValue: [1, 2, 3])

To support undo for a different struct, we just start with a different initial value:

    struct Person {
        var name: String
        var age: Int
    }

    var personHistory = UndoHistory(initialValue: Person(name: "Chris", age: 31))

Of course, we want to have a way of getting the current state, and setting the current state (in other words: adding an item to our history). To get the current state, we simply return the last item in our `history` array, and if the array is empty, we return the initial value. To set the current state, we simply append to our `history` array.

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

For example, if we want to change the person’s age, we can easily do that through our new computed property:

    personHistory.currentItem.age += 1
    personHistory.currentItem.age // Prints 32

Of course, the code isn’t complete without an `undo` method. This is as simple as removing the last item from the array. Depending on your preference, you could also make it `throw` when the undo stack is empty, but I’ve chosen not to do that.

    extension UndoHistory {
        mutating func undo() {
            guard !history.isEmpty else { return }
            history.removeLast()
        }
    }

Using it is easy:

    personHistory.undo()
    personHistory.currentItem.age // Prints 31 again

Of course, our `UndoHistory` works on more than just simple `Person` structs. For example, if we want to create a table view controller that’s backed by an `Array`, we can use the `currentItem` property to get the array out :

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
   

Another thing that is really cool with struct semantics: we get observation for free. For example, we could change the definition of `data`:

    var data: UndoHistory<[item]> {
        didSet {
            tableView.reloadData()
        }
    }
   

Even if we change something deep inside the array (e.g. `data.currentItem[17].name = "John"`) our `didSet` will get triggered. Of course, we probably want to do something a little bit smarter than `reloadData`. For example, we could use the [Changeset](https://github.com/osteslag/Changeset) library to compute a diff and have insert/delete/move animations.

Obviously, this approach has its drawbacks too. For example, it keeps a full history of the state, rather than a diff. It only works with structs (to be precise: only with structs that have value semantics). That said, you do not have to read the [runtime programming guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html), you only need to have a good grasp of structs and generics to come up with this solution.



1.  It would probably be nice to define a computed property `items` which just gets and sets `data.currentItem`. This makes the data source / delegate method implementations much nicer. [<sup>[return]</sup>](#fnref:4f7f6a73fd4549ae772cf1c92915d55d:1)
2.  If you want to take this further, there are a couple of fun exercises: try adding redo support, or labeled actions. You can implement reordering in the table view, and you will see that if you do it naively, you’ll end up with two entries in your undo history. [<sup>[return]</sup>](#fnref:4f7f6a73fd4549ae772cf1c92915d55d:2)

